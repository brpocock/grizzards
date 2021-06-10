(in-package :Skyline-Tool)

(defun collect-strings (file-in file-out)
  (let ((catalog (make-hash-table :test #'equal)))
    (with-input-from-file (in file-in)
      (let ((last-label nil)
            (string-buffer ""))
        (flet ((collect-last ()
                 (if last-label
                     (progn
                       (when-let (old-string (gethash last-label catalog))
                         (error "Already defined ~a as ~s, can't re-use for ~s"
                                last-label old-string string-buffer))
                       (setf (gethash last-label catalog) string-buffer)
                       (setf string-buffer ""
                             last-label nil))
                     (when (plusp (length string-buffer))
                       (error "string without label: ~s" string-buffer)))))
          (loop for line = (read-line in nil nil)
             while line
             do (when (plusp (length line))
                  (case (char line 0)
                    (#\\ (collect-last)
                         (setf last-label (subseq line 1)))
                    (#\;         ; no op
                     )
                    (otherwise
                     (concatenatef string-buffer line)
                     (concatenatef string-buffer #(#\Newline)))))))))
    (with-output-to-file (out file-out :if-exists :supersede)
      (let ((keys (hash-table-keys catalog)))
        (format out ";;; -*- asm -*-
;;; Generated file, from ~a (edit that file instead)
strings:
	.enc skyline64

	string_catalog=(~{~a_text, ~})
string_catalog_low: .byte <(string_catalog), 0
string_catalog_high: .byte >(string_catalog), 0
"
                file-in keys)
        (loop for label in keys
           for string = (gethash label catalog)
           for i from 0
           do (format out "~%	msg_~a = ~2@*~d~%~0@*~a_text:	.ptext ~s"
                      label
                      (cl-ppcre:regex-replace-all
                       "\\n"
                       (string-trim #(#\Space #\Newline) string)
                       "{cr}")
                      i))))))

