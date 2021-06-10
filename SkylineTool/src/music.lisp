(in-package :skyline-tool)

(defvar +atari-voices+
  '( ;; Waveform 0 = silent
    (0)
    (1 ;; Waveform 1 = “Buzzy”
     (2096 2080)
     (1048 1040)
     (698.7 	693.3)
     (524 	520)
     (419.2 	416)
     (349.3 	346.7)
     (299.4 	297.1)
     (262 	 	260)
     (232.9 	231.1)
     (	 	209.6 	208)
     ( 	190.5 	189.1)
     ( 	174.7 	173.3)
     ( 	161.2 	160)
     ( 	149.7 	148.6)
     (139.7 	138.7)
     (131 	 	130)
     (123.3 	122.4)
     (116.4 	115.6)
     (110.3 	109.5)
     (104.8 	104)
     (99.8 	 	99)
     (95.3 	 	94.5)
     (91.1 	 	90.4)
     (87.3 	 	86.7)
     (83.8 	 	83.2)
     (80.6 	 	80)
     (77.6 	 	77)
     (74.9 	 	74.3)
     (72.3 	 	71.7)
     (69.9 	 	69.3)
     (67.6 	 	67.1)
     (65.5 	 	65))

    (2  ;; Waveform 2 = lower-frequency buzz/rumble
     (     67.6 	 	67.1)
     (      33.8 	 	33.5)
     (      22.5 	 	22.4)
     (      16.9 	 	16.8)
     (      13.5 	 	  	  	13.4)
     (      11.3 	 	  	  	  	11.2)
     (      9.7 	 	  	  	  	9.6)
     (      8.5 	 	  	  	  	8.4)
     (      7.5 	 	  	  	  	7.5)
     (      6.8 	 	  	  	  	6.7)
     (      6.1 	 	  	  	  	6.1)
     (      5.6 	 	  	  	  	5.6)
     (      5.2 	 	  	  	  	5.2)
     (      4.8 	 	  	  	  	4.8)
     (      4.5 	 	  	  	  	4.5)
     (      4.2 	 	  	  	  	4.2)
     (      4 	   	  	  	  	4)
     (      3.8 	   	  	  	  	3.7)
     (      3.6 	   	  	  	  	3.5)
     (      3.4 	   	  	  	  	3.4)
     (      3.2 	   	  	  	  	3.2)
     (      3.1 	   	  	  	  	3)
     (      3 	         	  	  	  	2.9)
     (      2.8 	  	 	  	  	  	2.8)
     (      2.7 	  	 	  	  	  	2.7)
     (      2.6 	  	 	  	  	  	2.6)
     (      2.5 	  	 	  	  	  	2.5)
     (      2.4 	  	 	  	  	  	2.4)
     (      2.3 	  	 	  	  	  	2.3)
     (      2.3 	  	 	  	  	  	2.2)
     (      2.2 	  	 	  	  	  	2.2)
     (      2.1 	  	 	  		  	2.1)
     )

    (;; Waveform 3 = Flangy “UFO”


     )

    (;; Waveform 4 = Pure tone
     )

    (;; Waveform 6 = Somewhere between Pure & Buzzy
     )

    (;; Waveform 12 = lower-pitch pure tones
     )

    (;; Waveform 14 = low-pitch electronic tones
     )

    (;; Waveform 15 = low-pitch electronic tones

     ))

  "NTSC and PAL/SECAM sound values for each frequency code")

(defgeneric midi-to-sound-binary (output-coding machine-type midi-file-name)
  (:method (output-coding machine-type midi-notes)
    (warn "No handler for output coding ~a (machine ~a); ~
skipping MIDI music with ~:d note~:p"
          output-coding machine-type (length midi-notes))
    (make-array '(0 4))))

(defun best-tia-note-for (freq &optional (voice 1))
  (let ((notes (mapcar #'first       ; #'second for PAL
                       (cdr (elt +atari-voices+ voice)))))
    (position (first (sort (copy-list notes) #'<
                           :key (curry #'frequency-distance freq)))
              notes :test #'=)))

(defun array<-tia-notes-list (list)
  (let ((array (make-array (list (length list) 4)
                           :element-type 'number)))
    (loop for note in (reverse list)
       for i from 0
       do (setf (aref array i 0) (floor (or (elt note 0) 1)) ; duration
                (aref array i 1) (floor (elt note 1))        ;control
                (aref array i 2) (best-tia-note-for (elt note 2)) ;frequency
                (aref array i 3) (floor (elt note 3)))) ; volume
    array))

(defun midi-translate-element (element)
  (let ((waveform 1) (volume 5))
    (if (consp (car element))
        (mapcar #'midi-translate-element element)
        (destructuring-bind (note/rest . info) element
          (ecase note/rest
            ((:rest :wait) `#(,info 0 0 0))
            (:note `#(,(getf info :duration) ,waveform
                      ,(getf info :freq) ,volume)))))))

(defmethod midi-to-sound-binary ((output-coding (eql :ntsc))
                                 machine-type midi-notes)
  (array<-tia-notes-list
   (flatten (mapcar #'midi-translate-element midi-notes))))

(defun collect-midi-texts (midi)
  (loop for track in (midi:midifile-tracks midi)
     for track-number from 0
     appending (loop for chunk in track
                  when (typep chunk 'midi::text-message)
                  collect (format nil "~& ~d. ~:(~a~) “~a”"
                                  track-number (type-of chunk)
                                  (slot-value chunk 'midi::text)))))

(defun midi-track-notes-count (track)
  (count-if (lambda (chunk)
              (typep chunk 'midi::note-on-message))
            track))

(defun midi-tracks-with-music (midi)
  (remove-if-not (lambda (track)
                   (plusp (midi-track-notes-count track)))
                 (midi:midifile-tracks midi)))

(defconstant +a4/hz+ 440
  "The frequency (Hz) of the A in octave 4; by convention, 440Hz.")

(define-constant +semitone+ (expt 2 1/12)
  :documentation "The ratio of each semitone in equal temperment"
  :test #'=)

(defun midi-distance-from-a4 (key)
  (- key 69))

(defun freq<-midi-key (key)
  (* (expt 2 (/ (midi-distance-from-a4 key) 12)) +a4/hz+))

(defun frequency-distance (a b)
  (cond ((> b a)
         (frequency-distance b a))
        ((zerop b) most-positive-fixnum)
        (t
         (log (/ a b) 2))))

(defun read-midi (file)
  (let ((midi (midi:read-midi-file file)))
    (let ((parts/quarter (midi::midifile-division midi))
          (texts (collect-midi-texts midi))
          (real-tracks (midi-tracks-with-music midi)))
      (cond
        ((zerop (length real-tracks))
         (error "File ~a contains no tracks with actual music?
Gathered text:~{~% • ~a~}"
                file texts))
        ((< 2 (length real-tracks))
         (warn "File ~a contains multiple music tracks; using the longest two ~{
  • Track with length ~:d chunk~:p, ~:d note~:p~}"
               file (mapcar (lambda (track)
                              (list (length track)
                                    (midi-track-notes-count track)))
                            real-tracks))
         (let ((sorted-tracks (sort real-tracks #'>
                                    :key #'midi-track-notes-count)))
           (setf real-tracks (list (first sorted-tracks)
                                   (second sorted-tracks))))))
      (map 'list (lambda (track) (midi-track-decode track parts/quarter))
           real-tracks))))

(defun import-music-for-playlist (output-coding line catalog comments-catalog)
  (when (or (not (find #\= line))
            (char= #\; (first-elt (string-trim #(#\Space #\Tab) line))))
    (return-from import-music-for-playlist nil))
  (destructuring-bind (symbol-name$ midi-file-name$)
      (split-string line :separator "=")
    (let ((symbol-name (make-keyword (string-trim " " symbol-name$)))
          (midi-file-name (string-trim " " midi-file-name$)))
      (format *trace-output* "~&Converting MIDI file ~a to format ~a…"
              midi-file-name output-coding)
      (multiple-value-bind (numbers comments)
          (midi-to-sound-binary output-coding
                                *machine*
                                (read-midi (concatenate 'string "music/"
                                                        midi-file-name)))
        (when (plusp (first (array-dimensions numbers)))
          (setf (gethash symbol-name catalog) numbers
                (gethash symbol-name comments-catalog) comments))))))


(defun edit-long-notes (table)
  (let ((list 
         (loop for note from 0 below (array-dimension table 0)
            if (< (aref table note 0) #x80) 
            collect (list (aref table note 0)
                                        ;(aref table note 1)
                          (aref table note 2)
                                        ;(aref table note 3)
                          )
            else
            append (list (list (floor (aref table note 0) #x80)
                                        ;(aref table note 1)
                               (aref table note 2)
                                        ;(aref table note 3)
                               )
                         (list (mod (aref table note 0) #x80)
                                        ;(aref table note 1)
                               (aref table note 2)
                                        ;(aref table note 3)
                               )))))
    (make-array (list (length list) 2)
                :element-type '(unsigned-byte 8)
                :initial-contents list)))

(defvar *room-available-for-music%* 2000) ; FIXME

(defmacro memoize (var &body fn)
  `(or (and (boundp ',var) ,var)
       (setf ,var (progn ,@fn))))

(defun room-available-for-music ()
  (memoize *room-available-for-music%*
    (- #x1000
       (find-size-of-bank)
       #x100)))

(defun increment-name (name)
  (check-type name symbol)
  (let ((name$ (string name)))
    (if (digit-char-p (last-elt name$))
        (let ((number-starts (1+ (position-if-not #'digit-char-p
                                                  name$
                                                  :from-end t))))
          (intern (concatenate 
                   'string
                   (subseq name$ 0 number-starts)
                   (princ-to-string
                    (1+ (parse-integer
                         (subseq name$ number-starts)))))))
        (intern (concatenate 'string name$ "-2")
                (symbol-package name)))))

(defun fill-array² (destination source start-index end-index) 
  (loop 
     for x₀ from (first start-index) upto (first end-index)
     for x₁ from 0
     do (loop 
           for y₀ from (second start-index) upto (second end-index)
           for y₁ from 0 
           do (setf (aref destination x₁ y₁) (aref source x₀ y₀))))
  destination)

(defun song-split (array bytes)
  (let ((split-length (floor bytes 2)))
    (let ((before (fill-array² (make-array (list (1+ split-length) 2)
                                           :element-type '(unsigned-byte 8)
                                           :initial-element #xff)
                               array 
                               '(0 0) (list (1- split-length) 1)))
          (after 
           (fill-array² (make-array (list (- (array-dimension array 0)
                                             split-length)
                                          2)
                                    :element-type '(unsigned-byte 8) 
                                    :initial-element 0)
                        array (list split-length 1) 
                        (mapcar #'1- (array-dimensions array)))))
      (setf (aref before split-length 0) #xff
            (aref before split-length 1) #xff)
      (values before after))))

(defun split-long-songs (songs)
  (loop 
     with room-used = 0
     for (title . notes) = (pop songs)
     for song-bytes = (* 2 (array-dimension notes 0))
     collect
       (if (< (room-available-for-music)
              (+ room-used song-bytes))
           ;; split the song into two with a continuation flag
           (progn
             (format *trace-output* "~&Splitting song “~a” after ~:d bytes …"
                     title (- (room-available-for-music)
                              room-used
                              2))
             (multiple-value-bind (before after) 
                 (song-split notes (- (room-available-for-music)
                                      room-used
                                      2))
               (check-type before (array (unsigned-byte 8) (* 2)))
               (check-type after (array (unsigned-byte 8) (* 2)))
               (prog1 (cons title before)
                 (push (cons (increment-name title) after)
                       songs)
                 (setf room-used 0))))
           (prog1
               (cons title notes)
             (incf room-used song-bytes)))))

(defun song-bytes (song)
  (check-type song cons)
  (check-type (car song) symbol)
  (check-type (cdr song) (array * (* 2)))
  (* 2 (array-dimension (cdr song) 1)))


(defun assign-repertoire-to-banks (repertoire)
  (loop
     with assignments = nil
     for music-bank downfrom 128
     while repertoire 
     do (loop with room = (room-available-for-music)
           for length = (song-bytes (first repertoire))
           while (> room length)
           do (progn 
                (decf room length)
                (push (list music-bank (pop repertoire)) assignments)))
     finally
       (return assignments)))

(defun write-song-data-to-file (title notes source-file)
  (format source-file "~%;;;~|~%~a:~2%
~{~%     .byte $~2,'0x~^, $~2,'0x~^,   $~2,'0x~^, $~2,'0x~^, ~
$~2,'0x~^, $~2,'0x~^,   $~2,'0x~^, $~2,'0x~}~2%" 
          (assembler-label-name title)
          (loop for i below (array-dimension notes 0)
             appending (list (aref notes i 1)
                             (aref notes i 0)))))

(defun assigned-song-bank-and-title (assignment)
  (list (car assignment)
        (assembler-label-name
         (second assignment))))

(defun default-playlist-pathname (playlist-name)
  (make-pathname :directory '(:relative "music")
                 :name playlist-name
                 :type "playlist"))

(defun max-of-cars (assignments)
  (reduce #'max (mapcar #'car assignments)))

(defun numbered-bank-filename (basename bank)
  (make-pathname :name (concatenate 'string
                                    (pathname-name basename)
                                    "."
                                    (princ-to-string bank))
                 :defaults basename))

(defun build-repertoire-from-raw-catalog (catalog)
  (split-long-songs
   (loop for symbol-name being the hash-keys of catalog
      collect (cons symbol-name
                    (edit-long-notes 
                     (gethash symbol-name catalog))))))

(defun write-music-bank-header (assignments source-file)
  (format source-file ";;; -*- asm -*-
;;; This file generated by Skyline-Tool; editing it is futile.

.include \"preamble.s\"
.include \"music-bank.s'

;;; start of encoded music data from MIDI files
MusicBanks:
~{~%          .byte ~d ; ~a~}
Music:~:*
~{~%          .word ~*~a~} ~%"
          (mapcar #'assigned-song-bank-and-title
                  assignments)))

(defun import-songs-from-playlist-to-catalog (&key 
                                                playlist-file-name 
                                                output-coding
                                                catalog
                                                comments-catalog)
  (with-input-from-file (playlist-file playlist-file-name)
    (loop for line = (read-line playlist-file nil)
       while line
       do (import-music-for-playlist output-coding line
                                     catalog comments-catalog)))
  (format *trace-output* "~&End of playlist; collected ~r song~:p~
~:*~[~:; in “~a” coding~]."
          (hash-table-count catalog) output-coding))

(defun compile-music (source-out-name &optional in-file-name)
  (destructuring-bind (obj machine-type$ object-file-name)
      (split-string source-out-name :separator "/") 
    (assert (equal obj "Object"))
    (destructuring-bind (playlist-name area-name output-coding$ s)
        (split-string object-file-name :separator ".")
      (declare (ignore area-name)) 
      (assert (equal s "s"))
      (let ((*machine* (parse-integer machine-type$))
            (output-coding (make-keyword (string-upcase output-coding$)))
            (playlist-file-name (or in-file-name
                                    (default-playlist-pathname playlist-name)))
            (catalog (make-hash-table))
            (comments-catalog (make-hash-table)))
        (import-songs-from-playlist-to-catalog 
         :playlist-file-name playlist-file-name
         :output-coding output-coding
         :catalog catalog
         :comments-catalog comments-catalog)
        (let ((assignments (assign-repertoire-to-banks
                            (build-repertoire-from-raw-catalog catalog)))) 
          (dotimes (bank (max-of-cars assignments))
            (with-output-to-file (source-file
                                  (numbered-bank-filename
                                   source-out-name bank) 
                                  :if-exists :supersede)
              (write-music-bank-header assignments source-file) 
              (loop for (song-bank title . notes) in assignments
                 when (= bank song-bank) 
                 do (write-song-data-to-file title notes source-file))))))))

  (defgeneric midi-to-sound-binary (output-coding machine-type midi-file-name)
    (:method (output-coding machine-type midi-file-name)
      (warn "No handler for output coding ~a (machine ~a); skipping ~a" 
            output-coding machine-type midi-file-name)
      #())))

(defun midi-track-decode (track parts/quarter)
  (declare (ignore parts/quarter))
  (remove-if 
   #'null
   (loop for chunk in track
      with time-signature-num = 4
      with time-signature-den = 4
      ;; with tempo = 120
      ;; with sec/quarter-note =
      with prior-time = 0
      append (typecase chunk
               (midi::text-message nil)
               (midi::time-signature-message
                (setf time-signature-num (midi::message-numerator chunk)
                      time-signature-den (expt 2
                                               (midi::message-denominator chunk)))
                nil)
               (midi::tempo-message nil)
               (midi::control-change-message nil)
               (midi::note-on-message
                (with-slots ((key midi::key) (time midi::time)) chunk
                  (prog1
                      (list
                       (let ((lag (- time prior-time)))
                         (when (plusp lag)
                           (cons :wait lag)))
                       (cons :note
                             (list :key key
                                   :freq (freq<-midi-key key))))
                    (setf prior-time time))))
               (t (format t "~&Ignored (unsupported) chunk ~s" chunk))))))

(defun key<-midi-key (key)
  (multiple-value-bind (octave-ish note-in-octave) (floor key 12)
    (let ((note-name (nth note-in-octave '(c c♯ d d♯ e f f♯ g g♯ a a♯ b))))
      (values (1- octave-ish) note-in-octave note-name))))

(defconstant +a4/hz+ 440
  "The frequency (Hz) of the A in octave 4; by convention, 440Hz.")

(define-constant +semitone+ (expt 2 1/12)
  :documentation "The ratio of each semitone in equal temperment"
  :test #'=)
