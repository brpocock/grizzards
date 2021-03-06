(in-package :cl-user)
(require :alexandria)
(require :bordeaux-threads)
(require :split-sequence)
(require :cl-fad)
(require :local-time)
(require :cl-ppcre)
(require :parse-number)
(require 'trivial-gray-streams)

(defpackage :oliphaunt
  (:use :cl :alexandria
        :bordeaux-threads :local-time :split-sequence :cl-fad :parse-number
        :cl-ppcre :trivial-gray-streams)
  (:nicknames :romans :romance-ii :romance2)
  (:shadowing-import-from :cl-fad :copy-file :copy-stream) ; conflicts with Alexandria.
  (:shadowing-import-from #+sbcl :sb-int
                          #+ccl :ccl
                          #-(or sbcl ccl)
                          (warn-impl simple-file-error
                                     "The SIMPLE-FILE-ERROR condition type must be imported into
the ROMANCE package. It is probably in your compiler's INT or EXT
package (or similar). Perhaps it's even named the same? Try (APROPOS
\"SIMPLE-FILE-ERROR\").")
                          :simple-file-error)
  (:documentation
   "Common code used by some of my projects")
  (:export
   ;; Locally-defined symbols
   #:+inline-whitespace+
   #:+often-naughty-chars+
   #:+utf-8+
   #:+utf8+
   #:+whitespace+
   #:36r
   #:a/an
   #:a/an/some
   #:any
   #:as-number
   #:boolbool
   #:c-style-identifier
   #:c-style-identifier-p
   #:clean-plist #:keyword*
   #:collect-file
   #:collect-file-lines
   #:collect-file-tabular
   #:copyrights
   #:counting
   #:dohash
   #:doseq
   #:escape-by-doubling
   #:escape-c-style
   #:escape-lispy
   #:escape-java
   #:escape-url-encoded
   #:escape-with-char
   #:for-all
   #:for-any
   #:forever
   #:group-by
   #:join
   #:keywordify
   #:letter-case
   #:mail-only
   #:make-t-every-n-times
   #:mapplist
   #:maybe-alist-row
   #:maybe-alist-split
   #:maybe-numeric
   #:membership
   #:modincf
   #:numeric
   #:parse-decimal
   #:parse-roman-numeral
   #:plist-keys
   #:plist-p
   #:plist-values
   #:plural
   #:print-plist->table
   #:range
   #:regex-replace-pairs
   #:remove-commas
   #:repeat
   #:roman-numeral
   #:schemey-record
   #:server-start-banner
   #:split-and-collect-file
   #:start-repl
   #:start-server/generic
   #:strcat
   #:string-beginning
   #:string-begins
   #:string-case
   #:string-ending
   #:string-ends
   #:string-escape
   #:string-escape-uri-fragment
   #:string-fixed
   #:strings-list
   #:strings-list-p
   #:take
   #:take-if
   #:todo
   #:until
   #:while
   #:with-do-over-restart
   #:without-warnings
   #:yesno$
   #:|hash|
   #:???
   
      ;;; Symbols from other libraries
   ;; There is a very lengthy set of library functions that we want to
   ;; use without package prefixes in all of our other packages. As
   ;; such, they're exported here from their original packages. In other
   ;; packages, (:USE :CL :OLIPHAUNT) is the normal DEFPACKAGE form; MOST
   ;; other packages should NOT be ???used??? in the DEFPACKAGE form, with
   ;; some exceptions on a subsystem basis.
   alexandria:alist-hash-table
   alexandria:alist-plist
   alexandria:appendf
   alexandria:array-index
   alexandria:array-length
   alexandria:assoc-value
   alexandria:binomial-coefficient
   alexandria:circular-list
   alexandria:circular-list-p
   alexandria:circular-tree-p
   alexandria:clamp
   alexandria:coercef
   alexandria:compose
   alexandria:conjoin
   alexandria:copy-array
   ;; NOT: alexandria:copy-file (using CL-FAD:COPY-FILE)
   alexandria:copy-hash-table
   alexandria:copy-sequence
   ;; NOT: alexandria:copy-stream (using CL-FAD:COPY-STREAM)
   alexandria:count-permutations
   alexandria:cswitch
   alexandria:curry
   alexandria:define-constant
   alexandria:delete-from-plist
   alexandria:delete-from-plistf
   alexandria:deletef
   alexandria:destructuring-case
   alexandria:destructuring-ccase
   alexandria:destructuring-ecase
   alexandria:disjoin
   alexandria:doplist
   alexandria:emptyp
   alexandria:ends-with
   alexandria:ends-with-subseq
   alexandria:ensure-car
   alexandria:ensure-cons
   alexandria:ensure-function
   alexandria:ensure-functionf
   alexandria:ensure-gethash
   alexandria:ensure-list
   alexandria:ensure-symbol
   alexandria:eswitch
   alexandria:extremum
   alexandria:factorial
   alexandria:featurep
   alexandria:first-elt
   alexandria:flatten
   alexandria:format-symbol
   alexandria:gaussian-random
   alexandria:hash-table-alist
   alexandria:hash-table-keys
   alexandria:hash-table-plist
   alexandria:hash-table-values
   alexandria:if-let
   alexandria:ignore-some-conditions
   alexandria:iota
   alexandria:last-elt
   alexandria:lastcar
   alexandria:length=
   alexandria:lerp
   alexandria:make-circular-list
   alexandria:make-gensym
   alexandria:make-gensym-list
   alexandria:make-keyword
   alexandria:map-combinations
   alexandria:map-derangements
   alexandria:map-iota
   alexandria:map-permutations
   alexandria:map-product
   alexandria:maphash-keys
   alexandria:maphash-values
   alexandria:mappend
   alexandria:maxf
   alexandria:mean
   alexandria:median
   alexandria:minf
   alexandria:multiple-value-compose
   alexandria:multiple-value-prog2
   alexandria:named-lambda
   alexandria:nconcf
   alexandria:negative-double-float
   alexandria:negative-double-float-p
   alexandria:negative-fixnum
   alexandria:negative-fixnum-p
   alexandria:negative-float
   alexandria:negative-float-p
   alexandria:negative-integer
   alexandria:negative-integer-p
   alexandria:negative-long-float
   alexandria:negative-long-float-p
   alexandria:negative-rational
   alexandria:negative-rational-p
   alexandria:negative-real
   alexandria:negative-real-p
   alexandria:negative-short-float
   alexandria:negative-short-float-p
   alexandria:negative-single-float
   alexandria:negative-single-float-p
   alexandria:non-negative-double-float
   alexandria:non-negative-double-float-p
   alexandria:non-negative-fixnum
   alexandria:non-negative-fixnum-p
   alexandria:non-negative-float
   alexandria:non-negative-float-p
   alexandria:non-negative-integer
   alexandria:non-negative-integer-p
   alexandria:non-negative-long-float
   alexandria:non-negative-long-float-p
   alexandria:non-negative-rational
   alexandria:non-negative-rational-p
   alexandria:non-negative-real
   alexandria:non-negative-real-p
   alexandria:non-negative-short-float
   alexandria:non-negative-short-float-p
   alexandria:non-negative-single-float
   alexandria:non-negative-single-float-p
   alexandria:non-positive-double-float
   alexandria:non-positive-double-float-p
   alexandria:non-positive-fixnum
   alexandria:non-positive-fixnum-p
   alexandria:non-positive-float
   alexandria:non-positive-float-p
   alexandria:non-positive-integer
   alexandria:non-positive-integer-p
   alexandria:non-positive-long-float
   alexandria:non-positive-long-float-p
   alexandria:non-positive-rational
   alexandria:non-positive-rational-p
   alexandria:non-positive-real
   alexandria:non-positive-real-p
   alexandria:non-positive-short-float
   alexandria:non-positive-short-float-p
   alexandria:non-positive-single-float
   alexandria:non-positive-single-float-p
   alexandria:nreversef
   alexandria:nth-value-or
   alexandria:nunionf
   alexandria:of-type
   alexandria:once-only
   alexandria:ordinary-lambda-list-keywords
   alexandria:parse-body
   alexandria:parse-ordinary-lambda-list
   alexandria:plist-alist
   alexandria:plist-hash-table
   alexandria:positive-double-float
   alexandria:positive-double-float-p
   alexandria:positive-fixnum
   alexandria:positive-fixnum-p
   alexandria:positive-float
   alexandria:positive-float-p
   alexandria:positive-integer
   alexandria:positive-integer-p
   alexandria:positive-long-float
   alexandria:positive-long-float-p
   alexandria:positive-rational
   alexandria:positive-rational-p
   alexandria:positive-real
   alexandria:positive-real-p
   alexandria:positive-short-float
   alexandria:positive-short-float-p
   alexandria:positive-single-float
   alexandria:positive-single-float-p
   alexandria:proper-list
   alexandria:proper-list-length
   alexandria:proper-list-p
   alexandria:proper-sequence
   alexandria:random-elt
   alexandria:rassoc-value
   alexandria:rcurry
   alexandria:read-file-into-byte-vector
   alexandria:read-file-into-string
   alexandria:remove-from-plist
   alexandria:remove-from-plistf
   alexandria:removef
   alexandria:required-argument
   alexandria:reversef
   alexandria:rotate
   alexandria:sequence-of-length-p
   alexandria:set-equal
   alexandria:setp
   alexandria:shuffle
   alexandria:simple-parse-error
   alexandria:simple-program-error
   alexandria:simple-reader-error
   alexandria:simple-style-warning
   alexandria:standard-deviation
   alexandria:starts-with
   alexandria:starts-with-subseq
   alexandria:string-designator
   alexandria:subfactorial
   alexandria:switch
   alexandria:symbolicate
   alexandria:type=
   alexandria:unionf
   alexandria:unwind-protect-case
   alexandria:variance
   alexandria:when-let
   alexandria:when-let*
   alexandria:whichever
   alexandria:with-gensyms
   alexandria:with-input-from-file
   alexandria:with-output-to-file
   alexandria:with-unique-names
   alexandria:write-byte-vector-into-file
   alexandria:write-string-into-file
   alexandria:xor
   bordeaux-threads:*default-special-bindings*
   bordeaux-threads:*standard-io-bindings*
   bordeaux-threads:*supports-threads-p*
   bordeaux-threads:acquire-lock
   bordeaux-threads:acquire-recursive-lock
   bordeaux-threads:all-threads
   bordeaux-threads:condition-notify
   bordeaux-threads:condition-wait
   bordeaux-threads:current-thread
   bordeaux-threads:destroy-thread
   bordeaux-threads:interrupt-thread
   bordeaux-threads:join-thread
   bordeaux-threads:make-condition-variable
   bordeaux-threads:make-lock
   bordeaux-threads:make-recursive-lock
   bordeaux-threads:make-thread
   bordeaux-threads:release-lock
   bordeaux-threads:release-recursive-lock
   bordeaux-threads:start-multiprocessing
   bordeaux-threads:thread
   bordeaux-threads:thread-alive-p
   bordeaux-threads:thread-name
   bordeaux-threads:thread-yield
   bordeaux-threads:threadp
   bordeaux-threads:timeout
   bordeaux-threads:with-lock-held
   bordeaux-threads:with-recursive-lock-held
   bordeaux-threads:with-timeout
   cl-fad:*default-template*
   cl-fad:cannot-create-temporary-file
   cl-fad:canonical-pathname
   cl-fad:copy-file
   cl-fad:copy-stream
   cl-fad:delete-directory-and-files
   cl-fad:directory-exists-p
   cl-fad:directory-pathname-p
   cl-fad:file-exists-p
   cl-fad:invalid-temporary-pathname-template
   cl-fad:list-directory
   cl-fad:merge-pathnames-as-directory
   cl-fad:merge-pathnames-as-file
   cl-fad:open-temporary
   cl-fad:pathname-absolute-p
   cl-fad:pathname-as-directory
   cl-fad:pathname-as-file
   cl-fad:pathname-directory-pathname
   cl-fad:pathname-equal
   cl-fad:pathname-parent-directory
   cl-fad:pathname-relative-p
   cl-fad:pathname-root-p
   cl-fad:walk-directory
   cl-fad:with-open-temporary-file
   cl-fad:with-output-to-temporary-file
   cl-ppcre:*ALLOW-NAMED-REGISTERS* 	cl-ppcre:*ALLOW-QUOTING*
   cl-ppcre:*OPTIMIZE-CHAR-CLASSES* 	cl-ppcre:*PROPERTY-RESOLVER*
   cl-ppcre:*REGEX-CHAR-CODE-LIMIT* 	cl-ppcre:*USE-BMH-MATCHERS*
   cl-ppcre:ALL-MATCHES 	cl-ppcre:ALL-MATCHES-AS-STRINGS
   cl-ppcre:CREATE-OPTIMIZED-TEST-FUNCTION 	cl-ppcre:CREATE-SCANNER
   cl-ppcre:DEFINE-PARSE-TREE-SYNONYM 	cl-ppcre:DO-MATCHES
   cl-ppcre:DO-MATCHES-AS-STRINGS 	cl-ppcre:DO-REGISTER-GROUPS
   cl-ppcre:DO-SCANS 	cl-ppcre:PARSE-STRING
   cl-ppcre:PARSE-TREE-SYNONYM 	cl-ppcre:PPCRE-ERROR
   cl-ppcre:PPCRE-INVOCATION-ERROR 	cl-ppcre:PPCRE-SYNTAX-ERROR
   cl-ppcre:PPCRE-SYNTAX-ERROR-POS 	cl-ppcre:PPCRE-SYNTAX-ERROR-STRING
   cl-ppcre:QUOTE-META-CHARS 	cl-ppcre:REGEX-APROPOS
   cl-ppcre:REGEX-APROPOS-LIST 	cl-ppcre:REGEX-REPLACE
   cl-ppcre:REGEX-REPLACE-ALL 	cl-ppcre:REGISTER-GROUPS-BIND
   cl-ppcre:SCAN 	cl-ppcre:SCAN-TO-STRINGS
   cl-ppcre:SPLIT
   local-time:*clock*
   local-time:*default-timezone*
   local-time:+asctime-format+
   local-time:+day-names+
   local-time:+days-per-week+
   local-time:+gmt-zone+
   local-time:+hours-per-day+
   local-time:+iso-8601-date-format+
   local-time:+iso-8601-format+
   local-time:+iso-8601-time-format+
   local-time:+iso-week-date-format+
   local-time:+minutes-per-day+
   local-time:+minutes-per-hour+
   local-time:+month-names+
   local-time:+months-per-year+
   local-time:+rfc-1123-format+
   local-time:+rfc3339-format+
   local-time:+rfc3339-format/date-only+
   local-time:+seconds-per-day+
   local-time:+seconds-per-hour+
   local-time:+seconds-per-minute+
   local-time:+short-day-names+
   local-time:+short-month-names+
   local-time:+utc-zone+
   local-time:adjust-timestamp
   local-time:adjust-timestamp!
   local-time:astronomical-julian-date
   local-time:astronomical-modified-julian-date
   local-time:clock-now
   local-time:clock-today
   local-time:date
   local-time:day-of
   local-time:days-in-month
   local-time:decode-timestamp
   local-time:define-timezone
   local-time:enable-read-macros
   local-time:encode-timestamp
   local-time:find-timezone-by-location-name
   local-time:format-rfc1123-timestring
   local-time:format-rfc3339-timestring
   local-time:format-timestring
   local-time:make-timestamp
   local-time:modified-julian-date
   local-time:now
   local-time:nsec-of
   local-time:parse-rfc3339-timestring
   local-time:parse-timestring
   local-time:reread-timezone-repository
   local-time:sec-of
   local-time:time-of-day
   local-time:timestamp
   local-time:timestamp+
   local-time:timestamp-
   local-time:timestamp-century
   local-time:timestamp-day
   local-time:timestamp-day-of-week
   local-time:timestamp-decade
   local-time:timestamp-difference
   local-time:timestamp-hour
   local-time:timestamp-maximize-part
   local-time:timestamp-maximum
   local-time:timestamp-microsecond
   local-time:timestamp-millennium
   local-time:timestamp-millisecond
   local-time:timestamp-minimize-part
   local-time:timestamp-minimum
   local-time:timestamp-minute
   local-time:timestamp-month
   local-time:timestamp-second
   local-time:timestamp-subtimezone
   local-time:timestamp-to-universal
   local-time:timestamp-to-unix
   local-time:timestamp-week
   local-time:timestamp-whole-year-difference
   local-time:timestamp-year
   local-time:timestamp/=
   local-time:timestamp<
   local-time:timestamp<=
   local-time:timestamp=
   local-time:timestamp>
   local-time:timestamp>=
   local-time:to-rfc1123-timestring
   local-time:to-rfc3339-timestring
   local-time:today
   local-time:universal-to-timestamp
   local-time:unix-to-timestamp
   local-time:with-decoded-timestamp
   parse-number:parse-number
   split-sequence:partition
   split-sequence:partition-if
   split-sequence:partition-if-not
   split-sequence:split-sequence
   split-sequence:split-sequence-if
   split-sequence:split-sequence-if-not
   trivial-gray-streams:fundamental-binary-input-stream
   trivial-gray-streams:fundamental-binary-output-stream
   trivial-gray-streams:fundamental-binary-stream
   trivial-gray-streams:fundamental-character-input-stream
   trivial-gray-streams:fundamental-character-output-stream
   trivial-gray-streams:fundamental-character-stream
   trivial-gray-streams:fundamental-input-stream
   trivial-gray-streams:fundamental-output-stream
   trivial-gray-streams:fundamental-stream
   trivial-gray-streams:stream-advance-to-column
   trivial-gray-streams:stream-clear-input
   trivial-gray-streams:stream-clear-output
   trivial-gray-streams:stream-file-position
   trivial-gray-streams:stream-finish-output
   trivial-gray-streams:stream-force-output
   trivial-gray-streams:stream-fresh-line
   trivial-gray-streams:stream-line-column
   trivial-gray-streams:stream-listen
   trivial-gray-streams:stream-peek-char
   trivial-gray-streams:stream-read-byte
   trivial-gray-streams:stream-read-char
   trivial-gray-streams:stream-read-char-no-hang
   trivial-gray-streams:stream-read-line
   trivial-gray-streams:stream-read-sequence
   trivial-gray-streams:stream-start-line-p
   trivial-gray-streams:stream-terpri
   trivial-gray-streams:stream-unread-char
   trivial-gray-streams:stream-write-byte
   trivial-gray-streams:stream-write-char
   trivial-gray-streams:stream-write-sequence
   trivial-gray-streams:stream-write-string
   
   )) ; end of DEFPACKAGE form

(require :babel)

(in-package :oliphaunt)

(defvar +utf-8+ (flexi-streams:make-external-format :utf8 :eol-style :lf))

