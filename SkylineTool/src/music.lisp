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
     (209.6 	208)
     (190.5 	189.1)
     (174.7 	173.3)
     (161.2 	160)
     (149.7 	148.6)
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
     (      2.1 	  	 	  		  	2.1)f
     )
    
    (;; Waveform 4 = Pure tone
     (7860 7800)
     (5240 5200)
     (3930 3900)
     (3144 3120)
     (2620 2600)
     (2245.7 2228.6)
     (1965 1950)
     (1746.7 1733.3)
     (1572 1560)
     (1429.1 1418.2)
     (1310 1300)
     (1209.2 1200)
     (1122.9 1114.3)
     (1048 1040)
     (982.5 975)
     (924.7 917.6)
     (873.3 866.7)
     (827.4 821.1)
     (786 780)
     (748.6 742.9)
     (714.5 709.1)
     (683.5 678.3)
     (655 650)
     (628.8 624)
     (604.6 600)
     (582.2 577.8)
     (561.4 557.1)
     (542.1 537.9)
     (507.1 503.2)
     (491.3 487.5)
     )
    (;; Waveform 5 = Pure tone
     (7860 7800)
     (5240 5200)
     (3930 3900)
     (3144 3120)
     (2620 2600)
     (2245.7 2228.6)
     (1965 1950)
     (1746.7 1733.3)
     (1572 1560)
     (1429.1 1418.2)
     (1310 1300)
     (1209.2 1200)
     (1122.9 1114.3)
     (1048 1040)
     (982.5 975)
     (924.7 917.6)
     (873.3 866.7)
     (827.4 821.1)
     (786 780)
     (748.6 742.9)
     (714.5 709.1)
     (683.5 678.3)
     (655 650)
     (628.8 624)
     (604.6 600)
     (582.2 577.8)
     (561.4 557.1)
     (542.1 537.9)
     (507.1 503.2)
     (491.3 487.5)
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
    (when-let (freq (position (first (sort (copy-list notes) #'<
                                           :key (curry #'frequency-distance freq)))
                              notes :test #'=))
      (list voice freq))))

(defun array<-tia-notes-list (list)
  (let ((array (make-array (list (length list) 4)
                           :element-type 'number)))
    (loop for note in (reverse list)
          for i from 0
          for (control freq) = (or (best-tia-note-for (elt note 2) 1)
                                   (best-tia-note-for (elt note 2) 2)
                                   (best-tia-note-for (elt note 2) 4))
          do (setf (aref array i 0) (floor (or (elt note 0) 1)) ; duration
                   (aref array i 1) control        ;control
                   (aref array i 2) freq ;frequency
                   (aref array i 3) (floor (elt note 3)))) ; volume
    array))

(defun midi-translate-element (element)
  (let ((waveform 1) (volume #x8))
    (if (consp (car element))
        (mapcar #'midi-translate-element element)
        (destructuring-bind (note/rest . info) element
          (ecase note/rest
            (:rest `#(,info 0 0 0))
            (:wait (error "WAIT is not handled properly"))
            (:note `#(,(getf info :duration) ,waveform
                      ,(getf info :freq) ,volume)))))))

(defun midi-translate-notes (notes)
  (let ((volume #x8)
        (output (make-list (length notes) :initial-element nil)))
    (loop for note in notes
          for i from 0
          for time from 0
          do (destructuring-bind (note/rest . info) note
               (ecase note/rest
                 (:rest (setf (elt output i) `#(,info nil 0 0)))
                 (:wait (if (and (plusp i) (vectorp (elt output (1- i))))
                            (setf (elt output i) `#(,info nil ,(aref (elt output (1- i)) 2) ,(aref (elt output (1- i)) 3))
                                  (elt output (1- i)) `#(nil nil nil nil))))
                 (:note (setf (elt output i) `#(,(- (getf info :time) time) nil  ,(getf info :freq) ,volume)
                              time (getf info :time))))))
    output))

(defmethod midi-to-sound-binary ((output-coding (eql :ntsc))
                                 (machine-type (eql 2600)) midi-notes)
  (array<-tia-notes-list (remove-if (lambda (note) (null (aref note 0)))
                                    (midi-translate-notes (car midi-notes)))))

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
                                (read-midi midi-file-name))
        (format *trace-output* "~& - Generated ~:d values…" (first (array-dimensions numbers)))
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
  (format source-file "~%;;;~|~%~a:~2%" (assembler-label-name title))
  (loop for i below (array-dimension notes 0)
        do (let ((duration (floor (/ (aref notes i 0) 20)))
                 (control (aref notes i 1))
                 (frequency (aref notes i 2))
                 (volume (aref notes i 3)))
             #+ (or)
             (when (> duration #xff)
               (error "Note with duration ~d > #xff frames (4¼s)" duration))
             (unless (zerop duration)
               (format source-file "~%	.sound $~x, $~x, $~2,'0x, ~3d, ~d"
                       volume
                       control
                       frequency
                       (min duration #xff)                   
                       (if (= i (1- (array-dimension notes 0))) ; last note
                           1
                           0))
               (finish-output source-file))))
  (format source-file "~2%;;; end of ~a" (assembler-label-name title)))

(defun assigned-song-bank-and-title (assignment)
  (list (car assignment)
        (assembler-label-name
         (second assignment))))

(defun default-playlist-pathname (file-name playlist-name)
  (make-pathname :defaults playlist-name
                 :name file-name
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

(defun import-song-to-catalog (&key 
                                 song-file-name 
                                 output-coding
                                 catalog
                                 comments-catalog)
  (import-music-for-playlist output-coding 
                             (format nil
                                     "Song_~a=~a" 
                                     (pathname-name song-file-name) song-file-name)
                             catalog comments-catalog)
  (format *trace-output* "~&Collected ~r song~:p~
~:*~[~:; in “~a” coding~]."
          (hash-table-count catalog) output-coding))

(defun compile-music (source-out-name in-file-name &optional machine-type$)
  (let ((*machine* (if machine-type$ (parse-integer machine-type$) 2600))
        (output-coding :NTSC)
        (catalog (make-hash-table))
        (comments-catalog (make-hash-table)))
    (format *trace-output* "~&Writing music from playlist ~a…" in-file-name)
    (import-song-to-catalog 
     :song-file-name in-file-name
     :output-coding output-coding
     :catalog catalog
     :comments-catalog comments-catalog)
    (with-output-to-file (source-out source-out-name :if-exists :supersede :if-does-not-exist :create)
      (format *trace-output* "~&Writing ~a…" source-out-name)
      (format source-out ";;; Music compiled from ~a;
;;; do not bother editing (generated file will be overwritten)" 
              in-file-name)
      (loop for symbol being the hash-keys of catalog
            for notes = (gethash symbol catalog)
            do (write-song-data-to-file (string symbol) notes source-out)))
    (format *trace-output* "~&… done.~%")
    (finish-output))
  
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
                   #+(or) (format *trace-output* "~&~s" chunk)
                   (with-slots ((key midi::key) (time midi::time)
                                (velocity midi::velocity))
                       chunk
                     (if (plusp velocity)
                         (prog1
                             (list
                              (let ((lag (- time prior-time)))
                                (when (plusp lag)
                                  (cons :wait lag)))
                              (cons :note
                                    (list :key key
                                          :freq (freq<-midi-key key)
                                          :time time)))
                           (setf prior-time time))
                         #+ (or) (prog1
                                     (list (cons :rest (- time prior-time)))
                                   (setf prior-time time)))))
                  (midi:key-signature-message nil)
                  (midi:reset-all-controllers-message nil)
                  (midi:program-change-message nil)
                  (midi::midi-port-message nil)
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
