;; @module arglist.lsp
;; @description Find function argument list.
;; @author KOBAYASHI Shigeru <shigeru.kb[at]gmail.com>
;; @version 0.1

;; ### Argument Format ###
;;
;; - [] (&optional)
;; - ... (&rest, args)
;; - string, list, (array) -> seq, sequence
;; - int-file, str-device -> device
;; - int, float -> num
;; - integer-only -> int
;; - primitive, lambda, sym-function -> function
;; - test-function -> predicate
;; - exp -> obj, form

;; ChangeLog:
;;  v10.2.9 [+] net-ipv
;;  v10.2.8 [+] net-packet,
;;          [*] net-connect, get-url, post-url, put-url, delete-url, net-service
;;  v10.2.1 [+] term, prefix, self, extend, read, write, ++, --
;;          [-] name

;; TODO:
;; * FIXMEの見直し
;; * http://www.newlisp.org/downloads/newlisp_manual.html#type_ids
;; -> array,body,bool,context,exp,func,int,list,num,matrix,place,str,sym,sym-context
;; * Win32システムで利用できない関数の扱い

;;; Code:

(new Tree 'Arglist)             ; make hash-table

(define (subr-name f)
  (and (primitive? f)
       (let ((cell->aux
              ;; see newlisp.c:printCell
              (lambda (x) (nth 3 (dump x)))))
         (get-string (cell->aux f)))))

;(arglist cons) => (cons x y)
;(arglist-1 cons) => (x y)
(define (arglist-1 f)
  (cond
    ((primitive? f) (Arglist (subr-name f)))
    ((string? f) (Arglist f))
    ((or (lambda? f) (macro? f)) (first f))
    ((= f MAIN) nil)
    ((context? f) (arglist-1 (default f)))
    ("else" (Arglist (string f)))))

;;;##interface
(define-macro (arglist f)
  (let ((lst (arglist-1 (or (eval f) f))))
    (when lst
      (cons (sym f) lst))))

(define-macro (defargs fname lambda-list)
  (Arglist (string fname) lambda-list))

(defargs ! (command))
(defargs $ (index))
(defargs + ([num ...]))
(defargs - (num ...))
(defargs * ([num ...]))
(defargs / (num ...))
(defargs % (num ...))
(defargs ++ (place [num]))
(defargs -- (place [num]))
(defargs < (obj ...))
(defargs > (obj ...))
(defargs = (obj ...))
(defargs <= (obj ...))
(defargs >= (obj ...))
(defargs != (obj ...))
(defargs << (int (count 1) ...))
(defargs >> (int (count 1) ...))
(defargs & (int ...))
(defargs | (int ...))
(defargs ^ (int ...))
(defargs ~ (int))
(defargs : (function obj ...))
(defargs abort ([pid]))
(defargs abs (num))
(defargs acos (num))
(defargs acosh (z))
(defargs add ([num ...]))
(defargs address (obj))
(defargs amb ([obj ...]))
(defargs and ([form ...]))
(defargs append ([seq ...]))
(defargs append-file (pathname buffer))
(defargs apply (function list [reduce]))
(defargs args ([index ...]))
(defargs array (int ... [(init nil)]))
(defargs array-list (array))
(defargs array? (obj))
(defargs asin (z))
(defargs asinh (z))
(defargs assoc (key alist))
(defargs atan (y))
(defargs atan2 (y x))           ; (atan 1) == (atan2 1 1)
(defargs atanh (z))
(defargs atom? (obj))
(defargs base64-dec (string))
(defargs base64-enc (string))
(defargs bayes-query (list-L context-D [bool-chain [bool-probs]]))
(defargs bayes-train (list-M1 [list-M2 ...] sym-context-D))
(defargs begin ([form ...]))
(defargs beta (a b))
(defargs betai (x a b))
(defargs bind (alist [eval?]))
(defargs binomial (n k p))
(defargs bits (int [bool]))
(defargs callback (index function))
(defargs case (keyform forms))
(defargs catch (form [symbol]))
(defargs ceil (num))
(defargs change-dir (directory))
(defargs char (int-or-string [index]))
(defargs chop (seq (index 1)))
(defargs clean (predicate list))
(defargs close (device))
(defargs command-event (function))
(defargs cond (clauses ...))
(defargs cons (x y))
(defargs constant (symbol value ...))
(defargs context (context [string-or-symbol] [value]))
(defargs context? (obj [string]))
(defargs copy (obj))
(defargs copy-file (from-file to-file))
(defargs cos (radians))
(defargs cosh (radians))
(defargs count (list-A list-B))
(defargs cpymem (from-address to-address bytes))
(defargs crc32 (string))
(defargs crit-chi2 (num-probability num-df))
(defargs crit-z (num-probability))
(defargs current-line ())
(defargs curry (function form))
(defargs date ([utc-time] [offset] [format]))
(defargs date-value ([year month day [hour min sec]]))
(defargs debug (form))
(defargs dec (place [num]))
(defargs def-new (source [target]))
(defargs default (context))
(defargs define ((name [args]) body))
(defargs define-macro ((name [args]) body))
(defargs delete (symbol-or-context [bool]))
(defargs delete-file (pathname))
(defargs delete-url (url [timeout]))
(defargs destroy (pid [signal-number]))
(defargs det (matrix))
(defargs device ([int]))
(defargs difference (list-A list-B [bool]))
(defargs directory ([pathname] [pattern] [option]))
(defargs directory? (pathname))
(defargs div (num ...))
(defargs do-until (test body))
(defargs do-while (test body))
(defargs doargs ((var [test]) body))
(defargs dolist ((var list [test]) body))
(defargs dostring ((var string [test]) body))
(defargs dotimes ((var count [test]) body))
(defargs dotree ((var context [hash-key-only?]) body))
(defargs dump ([obj]))
(defargs dup (obj [int] [bool]))
(defargs empty? (seq))
(defargs encrypt (source pad))
(defargs ends-with (seq key [option]))
(defargs env ([var] [value]))
(defargs erf (num))
(defargs error-event (function))
(defargs eval (form))
(defargs eval-string (source [context] [eval-if-error] [offset]))
(defargs exec (command [str-stdin]))
(defargs exists (predicate list))
(defargs exit ([int-code]))
(defargs exp (num))
(defargs expand (form [[list-assoc [bool]] | [symbols ...]])) ; FIXME
(defargs explode (seq [chunk] [bool]))
(defargs extend (seq ...))                        ; add v.10.2.0
(defargs factor (int))
(defargs fft (nums))
(defargs file-info (pathname [index] [follow-link?]))
(defargs file? (pathname))
(defargs filter (predicate list))
(defargs find (key seq [predicate-or-int]))
(defargs find-all (key seq [form] [predicate-or-int])) ; FIXME
(defargs first (seq))
(defargs flat (list))
(defargs float (obj [default]))
(defargs float? (obj))
(defargs floor (num))
(defargs flt (num))
(defargs "lambda" ((args) body))
(defargs "fn" ((args) body))            ; fn == lambda
(defargs for ((var from to [step] [test]) body))
(defargs for-all (predicate list))
(defargs fork (form))
(defargs format (control-string [data-or-list ...]))
(defargs fv (num-rate num-nper num-pmt num-pv [int-type]))
(defargs gammai (a b))
(defargs gammaln (x))
(defargs gcd ([int ...]))
(defargs get-char (address))
(defargs get-float (address))
(defargs get-int (address))
(defargs get-long (address))
(defargs get-string (address))
(defargs get-url (url [option] [timeout] [header]))
(defargs global (symbol ...))
(defargs global? (symbol))
(defargs if (test then [else (if ...)]))
(defargs if-not (test then [else]))
(defargs ifft (nums))
(defargs import (lib-name func-name ["cdecl"]))
(defargs inc (place [num]))
(defargs index (predicate list))
(defargs inf? (num))
(defargs int (obj [default] [base]))
(defargs integer (obj [default] [base])) ; int == integer
(defargs integer? (obj))
(defargs intersect (list-A list-B [allow-dup?]))
(defargs invert (matrix))
(defargs irr (amounts [times] [guess]))
(defargs join (strings [separator] [trail-joint?]))
(defargs lambda? (obj))
(defargs last (seq))
(defargs last-error ([error-num]))
(defargs legal? (string))
(defargs length (obj))
(defargs let ((var [value] ...) body))
(defargs letex ((var [value] ...) body))
(defargs letn ((var [value] ...) body))
(defargs list ([obj ...]))
(defargs list? (obj))
(defargs load (pathname ... [context]))
(defargs local ((symbol ...) body))
(defargs log (num [base]))
(defargs lookup (key list-assoc [(index -1)] [default]))
(defargs lower-case (string))
(defargs macro? (obj))
(defargs main-args ([index]))
(defargs make-dir (pathname [int-mode]))
(defargs map (function list ...))
(defargs mat (op matrix-A matrix-B-or-num))
(defargs match (pattern match [bool]))
(defargs max (num ...))
(defargs member (key seq [regex-option]))
(defargs min (num ...))
(defargs mod (num divisor ...))
(defargs mul ([num ...]))
(defargs multiply (matrix-A matrix-B))
;; (defargs name (symbol-or-context [bool])) ; replace as `term/prefix'
(defargs NaN? (num))
(defargs net-accept (socket))
(defargs net-close (socket [true]))
(defargs net-connect (pathname-or-hostname port [[mode] [ttl] | [timeout]]))
(defargs net-error ([error-number]))
(defargs net-eval (hostnames port form [timeout] [handler]))
(defargs net-interface ([hostname]))
(defargs net-ipv ([version]))
(defargs net-listen (or (port [hostname] [mode]) (pathname)))
(defargs net-local (socket))
(defargs net-lookup (hostname [force-host-by-name]))
(defargs net-packet (str-packet))       ; add v10.2.8
(defargs net-peek (socket))
(defargs net-peer (socket))
(defargs net-ping (hosts [(timeout 1000)] [count]))
(defargs net-receive (socket buffer max-bytes [wait-string]))
(defargs net-receive-from (socket max-size))
(defargs net-receive-udp (port max-size [microsec] [addr-if]))
(defargs net-select (sockets mode microsec))
(defargs net-send (socket buffer [bytes]))
(defargs net-send-to (host port buffer socket))
(defargs net-send-udp (host port buffer [bool]))
(defargs net-service (service|port protocol))
(defargs net-sessions ())
(defargs new (source target [bool]))
(defargs nil? (obj))
(defargs normal (mean stdev [length]))
(defargs not (form))
(defargs now ([offset] [index]))
(defargs nper (interest pmt pv [fv type]))
(defargs npv (interest values))
(defargs nth (indices seq))
(defargs null? (obj))
(defargs number? (obj))
(defargs open (pathname access-mode [option]))
(defargs or ([form ...]))
(defargs pack (format [data-or-list ...]))
(defargs parse (string [separator] [regex-option]))
(defargs parse-date (string format))
(defargs peek (device))
(defargs pipe ())
(defargs pmt (interest periods principal [future-value type]))
(defargs pop (seq [indices ...] [length]))
(defargs pop-assoc (keys list-assoc))
(defargs post-url (url contents [content-type] [option] [timeout] [header]))
(defargs pow (base [num ...]))
(defargs prefix (symbol))
(defargs pretty-print ([length] [tab]))
(defargs primitive? (obj))
(defargs print ([args ...]))
(defargs println ([args ...]))
(defargs prob-chi2 (chi2 df))
(defargs prob-z (z))
(defargs process (command [pipe-in pipe-out] [pipe-error-or-win32-option]))
(defargs prompt-event (function))
(defargs protected? (symbol))
(defargs push (obj seq [indies]))
(defargs put-url (url contents [option] [timeout] [header]))
(defargs pv (int nper pmt [fv type]))
(defargs quote (obj))
(defargs quote? (obj))
(defargs rand (range [length]))
(defargs random (offset scale [length]))
(defargs randomize (list [bool]))
(defargs read (device buffer size [wait-string]))
(defargs read-buffer (device buffer size [wait-string])) ; replace as `read'
(defargs read-char (device))
(defargs read-expr (source [context] [eval-if-error] [offset]))
(defargs read-file (pathname))
(defargs read-key ())
(defargs read-line ([device]))
(defargs read-utf8 (device))
(defargs reader-event ([function|nil]))
(defargs real-path ([pathname]))
(defargs receive (pid message))
(defargs ref (key list [predicate]))
(defargs ref-all (key list [predicate]))
(defargs regex (pattern text [regex-option] [offset]))
(defargs regex-comp (pattern [regex-option]))
(defargs remove-dir (pathname))
(defargs rename-file (pathname-old pathname-new))
(defargs replace (exp-from seq [exp-to] [func-or-option]))
(defargs reset ([restart?]))
(defargs rest (seq))
(defargs reverse (seq))
(defargs rotate (seq [count]))
(defargs round (num [digits]))
(defargs save (pathname [symbol ...]))
(defargs search (device pattern [no-dup?] [regex-option]))
(defargs seed (int))
(defargs seek (device [position]))
(defargs select (seq [indices]))
(defargs semaphore ([id] (or wait signal 0))) ; FIXME
(defargs self (index))
(defargs send (pid obj))
(defargs sequence (start end [step]))
(defargs series (start factor count))
(defargs set (symbol value ...))
(defargs set-locale ([locale] [category]))
(defargs set-ref (exp-from list exp-to [predicate]))
(defargs set-ref-all (exp-from list exp-to [predicate]))
(defargs setf (place value ...))
(defargs setq (var value ...))
(defargs sgn (num [minus zero plus]))
(defargs share ([address] [value])) ; FIXME: +(nil address)
(defargs signal (signal-number [function-or-bool]))
(defargs silent ([form ...]))
(defargs sin (radians))
(defargs sinh (radians))
(defargs sleep (milliseconds))
(defargs slice (seq index [length]))
(defargs sort (list [predicate]))
(defargs source ([symbol ...]))
(defargs spawn (symbol form))
(defargs sqrt (num))
(defargs starts-with (seq key [regex-option]))
(defargs string ([args ...]))
(defargs string? (obj))
(defargs sub (num ...))
(defargs swap (place-1 place-2))
(defargs sync ([timeout] [function]))
(defargs sym (string|num|symbol [context] [nil]))
(defargs symbol? (obj))
(defargs symbols ([context]))
(defargs sys-error ([(error-number 0)]))
(defargs sys-info ([index]))
(defargs tan (radians))
(defargs tanh (radians))
(defargs term (symbol))
(defargs throw (form))
(defargs throw-error (form))
(defargs time (form [count]))
(defargs time-of-day ())
(defargs timer ([function] [seconds] [option]))
(defargs title-case (string [lowercase-rest?]))
(defargs trace ([bool-switch]))
(defargs trace-highlight (start end [header footer]))
(defargs transpose (matrix))
(defargs trim (string [trim-char-left] [char-right]))
(defargs true? (obj))
(defargs unicode (string))
(defargs unify (A B [env]))
(defargs unique (list))
(defargs unless (test body))
(defargs unpack (format data))
(defargs until (test body))
(defargs upper-case (string))
(defargs utf8 (unicode))
(defargs utf8len (string))
(defargs uuid ([node]))
(defargs wait-pid (pid (or option 0)))
(defargs when (test body))
(defargs while (test body))
(defargs write (device buffer [size]))
(defargs write-buffer (device buffer [size])) ; replace as `write'
(defargs write-char (device char ...))
(defargs write-file (pathname buffer))
(defargs write-line ([(device stdout)] [buffer]))
(defargs xfer-event (function))
(defargs xml-error ())
(defargs xml-parse (xml [xml-option] [context] [callback]))
(defargs xml-type-tags ([TEXT CDATA COMMENT ELEMENT]))
(defargs zero? (obj))

(context MAIN)
;;; EOF
