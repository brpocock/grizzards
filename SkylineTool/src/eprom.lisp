(defpackage :click.adventuring.skyline.eprom
  (:use :common-lisp :alexandria :bordeaux-threads))

(in-package :click.adventuring.skyline.eprom)

;;;; What is this?
;;;;
;;;; For burning  EPROM chips for Atari  2600 cartridges, I have  an old
;;;; (but   quite  nice)   EP-1  serial-port   EPROM  burner.   This  is
;;;; a teletype-mode utility program that  gives a rather nice interface
;;;; for burning EPROMs under Linux.
;;;;
;;;; Lots  of  things  in  this   file  are  peculiar  to  this  set-up.
;;;; Since I rarely have an actual serial port on a modern system, I use
;;;; USB serial  converters, which  means that I  don't usually  know in
;;;; advance  what  the device  special  file  will  be. As  such,  this
;;;; searches  through  available  serial   (tty)  devices,  using  some
;;;; Linux-specific features. Once  found, it speaks to the  EP-1 in its
;;;; native   command  language,   taken  from   the  fairly   excellent
;;;; documentation that came with the system.
;;;;
;;;; In  other words,  this is  hardly expected  to be  general-purpose,
;;;; portable software, but nonetheless:
;;;;
;;;; This library is  free software, licensed to you under  the terms of
;;;; the GNU Lesser General Public  License (LGPL); either version 3, or
;;;; (at your  option) any  later version  to be  published by  the Free
;;;; Software Foundation. See COPYING.LIB or www.fsf.org for details.
;;;;
;;;; Click.Adventuring.Skyline.EPROM  ©   2016-2017,2020  Bruce-Robert
;;;; Pocock; All rights reserved except those granted under the terms of
;;;; a license agreement (LGPLv3 or otherwise).


(defun power-of-two-size (size)
  "Format a size in bytes using SI units (eg, 1024 = 1kiB)"
  (check-type size (integer 0 *))
  (if (zerop size) "empty"
      (multiple-value-bind (G M_) (floor size (expt 2 30))
        (multiple-value-bind (M k_) (floor M_ (expt 2 20))
          (multiple-value-bind (k b) (floor k_ (expt 2 10))
            (format nil "~[~:;~:*~:dGiB ~]~[~:;~:*~:dMiB ~]~
~[~:;~:*~:dkiB ~]~[~:;~:*~:d byte~:p~]" G M k b))))))

(defun validate-rom-binary-size (binary)
  (let ((size (ql-util:file-size binary)))
    (format t "~&Binary size is ~:d bytes (~a)" size (power-of-two-size size))
    (multiple-value-bind (log2 round-off) (round (log size 2))
      (declare (ignore log2))
      (unless (or (zerop round-off)
                  (yes-or-no-p "~&The binary size is not a power-of-two.

This seems unlikely to be correct.

Are you sure you mean to do this?"))
        (error "Binary ~a size ~a (~:d byte~:p) is not a power of two"
               binary (power-of-two-size size) size))
      size)))

(defun device-file<-sys-device (device-path)
  (ignore-errors
    (with-input-from-file (uevent (merge-pathnames (make-pathname :name "uevent")
                                                   device-path))
      (loop for line = (read-line uevent nil nil)
         while line
         do (destructuring-bind (key value) 
                (uiop:split-string line :separator "=")
              (when (equal "DEVNAME" key)
                (return-from device-file<-sys-device
                  (make-pathname :directory '(:absolute "dev")
                                 :name value
                                 :type nil))))))))

(defun enumerate-real-serial-ports ()
  (remove-if
   #'null 
   (mapcar 
    #'device-file<-sys-device
    (remove-if-not
     (lambda (device-path)
       (ignore-errors (not (search "sys/devices/virtual/tty"
                                   (namestring (truename device-path))))))
     (mapcar (lambda (device-dir)
               (make-pathname :directory (pathname-directory device-dir)
                              :name "device"
                              :type nil)) 
             (directory (make-pathname 
                         :directory 
                         '(:absolute "sys" "class" "tty")
                         :name :wild
                         :type nil)))))))

(defun collect-until-> (stream)
  (loop for line = (read-line stream)
     until (char= (last-elt line) #\>)
     collect line))

(defun ep1-error (stream)
  (cerror
   "Ignore and continue"
   "EP-1 signalled an error …~{~%  ~a~}"
   (collect-until-> stream)))

(defun wait-for-input (ci string)
  "Wait up  to 10s for the  first character, then  up to ½ sec  for each
additional char; start over if any other char(s) is/are received."
  (force-output ci)
  (block start-string
    (loop
       (let ((input (with-timeout (10)
                      (read-char ci))))
         (when (char= input #\BELL)
           (ep1-error ci))
         (when (char= input (first-elt string))
           (return-from start-string)))))
  (when (= 1 (length string))
    (return-from wait-for-input nil))
  (loop
     (block find-rest
       (dolist (char (coerce (subseq string 1) 'list))
         (block next-char
           (loop (let ((input (with-timeout (1/2)
                                (read-char ci))))
                   (when (char= input #\BELL)
                     (ep1-error ci))
                   (when input
                     (if (char= char input)
                         (return-from next-char)
                         (if (char= char (first-elt string))
                             (return-from find-rest nil)
                             (wait-for-input ci string)))))))
         (return-from wait-for-input t)))))

(defun wait-for-> (ci)
  (wait-for-input ci ">"))

(defmethod sb-gray::stream-write-char ((stream cserial-port::serial-stream)
                                       char) 
  (cserial-port:write-serial-char char (cserial-port::stream-serial stream)))

(defmethod sb-gray::stream-read-char ((stream cserial-port::serial-stream))
  (cserial-port:read-serial-char (cserial-port::stream-serial stream)))

(defmethod sb-gray::stream-write-string ((stream cserial-port::serial-stream) 
                                         string
                                         &optional (start 0) (end nil))
  (cserial-port:write-serial-string (subseq string start end)
                                    (cserial-port::stream-serial stream)))

(defmethod sb-gray::stream-read-line ((stream cserial-port::serial-stream))
  (let ((buffer (make-array '(80) 
                            :element-type 'character 
                            :fill-pointer 0
                            :adjustable t)))
    (loop for char = (read-char stream)
       do (cond
            ((and (char= char #\linefeed)
                  (char= (last-elt buffer) #\return))
             (return-from sb-gray::stream-read-line 
               (subseq buffer 0 (1- (length buffer)))))
            ((char= char #\linefeed)
             (return-from sb-gray::stream-read-line buffer))
            (t (vector-push-extend char buffer 80))))))

(defun open-serial-port-stream (port)
  (cserial-port:make-serial-stream 
   (cserial-port:open-serial port
                             :baud-rate 9600 
                             :data-bits 8
                             :parity :none
                             :stop-bits 1)))

(defun serial-port-has-ep-1-p (port)
  (let ((s (open-serial-port-stream port))) 
    ;; DC3 is XON, in case it's paused. ETX is ^C (break) this ensures
    ;; line settings handshaking, see Appendix I of manual
    (unless (cserial-port::%valid-fd-p (cserial-port::stream-serial s))
      (error "Invalid port? ~a ⇒ ~a" port s))
    (loop repeat 3
       do (progn #+ () (sleep 300/1000) ; my paranoia, not theirs
                 #+ () (write-char #\dc3 s)
                 #+ () (write-char #\etx s) 
                 (force-output s)
                 (sleep 300/1000)       ; sleep 300msec after break
                 (write-char #\space s)
                 (write-char #\return s)
                 (write-char #\linefeed s)
                 (force-output s)
                 (wait-for-> s)))
    (format s "?~c~c" #\return #\linefeed) 
    (wait-for-input s "EP-1 EPROM Programmer")
    (wait-for-input s "BP Microsystems")
    (wait-for-> s)
    (list port s)))

(defun spawn-thread-to-look-for-ep-1-on-port (port)
  (make-thread (lambda () (ignore-errors (serial-port-has-ep-1-p port)))
               :name (format nil "Looking for EP-1 on port ~a" port)))

(defun interactive-wait (prompt &rest args)
  (loop for char = nil then (read-char *query-io* t)
     if (member char '(#\Return #\Linefeed #\Newline))
     do (return)
     else do (progn
               (apply #'format *query-io* prompt args)
               (format *query-io* "~& (Press Return to continue) ⇒")
               (force-output *query-io*))))

(defun find-ep1-serial-port ()
  (interactive-wait "~2&Make certain that there is NO chip in the socket, ~
and turn on and connect the EP-1.
When ready, hit Return, and I'll try to locate the path to the burner.")
  (let ((ports (enumerate-real-serial-ports)))
    (format t "~&Searching ~:d serial ports…" (length ports))
    (let ((thread-pool (mapcar #'spawn-thread-to-look-for-ep-1-on-port ports)))
      (labels ((kill-threads () (map nil #'destroy-thread thread-pool)))
        (loop
           (dolist (thread thread-pool)
             (unless (thread-alive-p thread)
               (let ((return (join-thread thread)))
                 (removef thread-pool thread)
                 (when return
                   (destructuring-bind (port stream) return
                     (when (y-or-n-p "~2&Found an EP-1 on ~a. Proceed?" port)
                       (kill-threads)
                       (return-from find-ep1-serial-port (list port stream))))))))
           (unless thread-pool
             (error "Searched ~:d serial port~:p and could not find an EP-1.~
~{~% • ~a~}"
                    (length ports)
                    ports))
           (when (zerop (random 5))
             (format t "~&… still waiting for search of ~:d serial port~:p ~
(~d% of ~:d) to respond or time out …"
                    (length thread-pool)
                    (round (* 100.0 (/ (length thread-pool) (length ports))))
                    (length ports))
            (when (< (length thread-pool) 5)
              (format t "~&… remaining tasks: ~{~a~^, ~}"
                      (mapcar #'thread-name thread-pool))))
          (sleep 3/2))))))

(defun collect-ep1-parts-list (stream)
  (format stream "PARTS~c~c" #\return #\linefeed) 
  (force-output stream)
  (loop with chips = nil
     with maker = "Unknown"
     for line = (read-line stream)
     do (format *trace-output* "~&«~a»" line)
     do (cond ((equal (last-elt line) #\>)
               (return chips))
              ((find #\Space line)
               (dolist (part (mapcar (curry #'string-trim " ") 
                                     (uiop:split-string line :separator " ")))
                 (when (plusp (length part))
                   (push (list maker part) chips))))
              (t (setf maker line)))))

(defun collect-ep1-found-parts (stream try)
  (format stream "FIND ~a~c~c" try #\return #\linefeed) 
  (force-output stream)
  (loop with chips = nil
     for line = (read-line stream)
     do (format *trace-output* "~&«~a»" line)
     do (cond ((equal (format nil "~d FOUND." (length chips)) line)
               (return chips))
              ((search "FOUND" line)
               (error "Someone can't count? Got ~:d chip~:p, response says ~a"
                      (length chips) line))
              ((find #\Space line)
               (destructuring-bind (maker &rest part-parts)
                   (uiop:split-string line :separator " ")
                 (push (list maker (format nil "~{~a~^ ~}" part-parts))
                       chips)))
              (t (warn "Unexpected reply: ~a" line)))))

(defun numbered (list)
  (loop
     for element in list
     for number from 1
     collecting (list number element)))

(defun select-chip-from-short-list% (chips)
  (when (y-or-n-p "~&Found ~r possible matches.~
~{~% ~2,' d • Maker: ~a~30tPart#E ~a~}
Is one of these the correct chip?"
                  (length chips) (numbered chips))
    (format t "~&Enter the number (1 … ~d) of your chip, ~
or “0” if you changed your mind. ⇒"
            (length chips))
    (when-let (selection (ignore-errors (parse-integer (read-line)
                                                       :junk-allowed t)))
      (when (y-or-n-p "You want #~d, ~{Maker: ~a, Part#: ~a~}?"
                      selection (elt chips (1- selection)))
        (throw 'selection (elt chips (1- selection)))))))

(defun interactive-search-for-chip-in-catalog (stream)
  (catch 'selection
    (loop
       (format t "~&Enter part number (blank for all) ⇒")
       (let ((try (string-trim #(#\Space) (read-line))))
         (format t "~&EP-1 matches:")

         (let ((chips        
                (with-timeout (60)
                  (if (equal "" try)
                      (collect-ep1-parts-list stream) 
                      (collect-ep1-found-parts stream try)))))
           (cond
             ((null chips)
              (warn "No results found for search “~a”" try))
             ((= 1 (length chips))
              (when (yes-or-no-p "Found one result. ~{Maker: ~a; Part#: ~a~}.~
 Is this the right chip?"
                                 (first chips))
                (throw 'selection (first chips))))
             ((> 20 (length chips))
              (select-chip-from-short-list% chips))
             (t (format t "Found lots of possible matches.~
~{~%~{~20a ~a~}~^~40t~{~20a ~a~}~}
That's ~r matches. Perhaps you should be a little more specific."
                        chips (length chips)))))
         (format t "~2% Let's try that again. You last looked for “~a.”" try)))))

(defun interactive-choose-chip-type (stream)
  (format t "~&~
Now you need to  specify the chip type. I'm going to  let you search the
built-in database for the type you're using (or a compatible one) in the
catalog. You can  enter a part number or partial  string, and I'll query
the EP-1.

☠ DO NOT put the chip into the ZIF socket yet! ☠

Once you've identified  the part number you are planning  to use, we can
proceed.~2%")
  (destructuring-bind (maker part)
      (interactive-search-for-chip-in-catalog stream)
    (format t "~2%OK. Setting the EP-1 to use maker ~a part number ~a…" 
            maker part)
    (format stream "CHIP ~a ~a~c~c" maker part #\return #\linefeed)
    (force-output stream)
    (wait-for-input stream part)
    (wait-for-> stream)))

(defun interactive-check-blank (stream size)
  (format t " OK, ready.

NOW it  IS safe  to load the  chip. Raise the  ZIF socket's  lever, then
insert the chip  with Pin 1 (dot  or notch end) toward the  “top” of the
ZIF socket,  but ensure  that the  “lower” slots of  the ZIF  socket are
filled (ie,  if the chip  is not as  long as the  socket, put it  in the
lower legs  in the  lowest slots).  Once the chip  is inside,  lower the
ZIF lever.

")
  (interactive-wait "Once the chip is loaded, hit Return.")
  (format t "Checking that the chip is blank…")
  (format stream "BLANK 0000 ~4,'0x~c~c" (1- size) #\return #\linefeed)
  (force-output stream)
  (wait-for-> stream))

(defun handle-ep1-responses (stream)
  (let ((input (read-char-no-hang stream)))
    (cond
      ((null input) nil)
      ((char= input #\DC3)               ; Hold
       (format t "~& Waiting for burner to catch up (got XOFF) …")
       (wait-for-input stream #(#\DC1))
       (format t "~& … resuming …"))
      ((char= input #\BELL)
       (format *error-output* "~2%"))
      (t (format *error-output* "~c" input)))))

(defun set-up-ep1-for-transfer (stream binary)
  (format t "~&Setting transfer mode…")
  (format stream "ADDR ALL~c~c" #\return #\linefeed)
  (wait-for-> stream)
  (format stream "BASE 0~c~c" #\return #\linefeed)
  (wait-for-> stream)
  (format stream "STAT~c~c" #\return #\linefeed)
  (format t "~2% ★ Status report from EP-1: ~{~%  ~a~}~2%"
          (collect-until-> stream))
  (unless (yes-or-no-p "~2% **** LAST CHANCE ***

Everything seems good so far, so now we're going to really do this.

You're about to burn the contents of ~a to the chip you've just tested.

Are you sure you want to continue?" binary)
    (error "User aborted")))

(defun write-record-to-stream (record stream &key write-only-p)
  (progn
    (format stream "~{~2,'0x~^ ~}~c~c" record #\return #\linefeed)
    (force-output stream)
    (unless write-only-p
      (handle-ep1-responses stream))))

(defun actually-burn-binary (stream binary &key write-only-p)
  (let* ((bytes (read-file-into-byte-vector binary))
         (size (length bytes)))
    (format stream "PROGRAM 0000 ~4,'0x~c~c" (1- size) #\return #\linefeed)
    (format t "~2% ★ Programming chip … ")
    (loop
       with start-time = (get-universal-time)
       with report-time = (get-universal-time)
       for index from 0 below size by 16
       for record = (coerce (subseq bytes index (+ index 16)) 'list) 
       do (write-record-to-stream record stream 
                                  :write-only-p write-only-p)
       when (< report-time (get-universal-time))
       do (progn 
            (format t "~% Sent ~:d bytes (~d%) in ~:ds (ETA: ~:ds more)…"
                    index (round (* 100.0 (/ index size)))
                    (- report-time start-time)
                    (round (/ (- report-time start-time)
                              (/ index size))))
            (setf report-time (get-universal-time))))))

(defun verify-burn (stream binary)
  (let* ((bytes (read-file-into-byte-vector binary))
         (size (length bytes)))
    (format stream "VERIFY 0000 ~4,'0x~c~c" (1- size) #\return #\linefeed)
    (format t "~2% ★ Verifying contents of chip … ")
    (loop
       with start-time = (get-universal-time)
       with report-time = (get-universal-time)
       for index from 0 below size by 16
       for record = (coerce (subseq bytes index (+ index 16)) 'list)
       do (write-record-to-stream record stream)
       when (< report-time (get-universal-time))
       do (progn
            (format t "~% Sent ~:d bytes (~d%) in ~:ds (ETA: ~:ds more)…"
                    index (round (* 100.0 (/ index size)))
                    (- report-time start-time)
                    (round (/ (- report-time start-time)
                              (/ index size))))
            (setf report-time (get-universal-time)))) 
    (force-output stream)
    (handle-ep1-responses stream)))

(defun burn-rom (binary)
  "Burn a ROM image into an EPROM chip using the BP EP-1 burner.

Pass in the filename of a ROM image file (raw binary) and this will walk
through  the process  of burning  it to  an appropriate  EPROM. This  is
rather specific  to the BP  EP-1 on  Linux, so it  may not be  useful to
“everyone else.”

"
  (tagbody check-binary-pathname
     (restart-case 
         (unless (probe-file binary)
           (error "binary file not found: ~a" binary))
       (supply-new-filename (f)
         :report "Supply a replacement pathname to the binary"
         (setf binary f)
         (go check-binary-pathname))))
  (format t "~2% Burn ROM (interactive)

This process  will burn an  actual ROM using my  BP EP-1 burner.  If you
don't want to actually sacrifice an  (E)EPROM right now, you should bail
out.  (Or, if  you're not  me,  and don't  have the  same model  burner,
because this will probably not work for you.)~2%")
  (unless (y-or-n-p "Do you have an EP-1 on some serial port and want to burn a ROM?")
    (error "User aborted"))
  (format t "~&OK; ROM binary file selected is ~a." binary)
  (let ((size (validate-rom-binary-size binary)))
    (destructuring-bind (port stream) (find-ep1-serial-port)
      (format t "~&Stream connected to EP-1 on port ~a" port)
      (interactive-choose-chip-type stream)
      (interactive-check-blank stream size)
      (set-up-ep1-for-transfer stream binary)
      (format t "~& Estimated burn+verify time for ~:d bytes, about ~:d minutes."
              size (ceiling (* (/ 70/3 256 60) size)))
      (actually-burn-binary stream binary)
      (verify-burn stream binary))))
