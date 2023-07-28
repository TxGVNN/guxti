(define-module (guxti packages me)
  #:use-module (guix git-download)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))


(define-public oops
  (let ((commit "d8b4cde89bd8f4059bb61a052c849f876979a240")
        (hash "0y1j0n7ji0skzrrpj6h6j63rlhgb8xv8q4h3zqlj3v73xm8xindm")
        (version "20230728.1255"))
    (package
      (name "oops")
      (version version)
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/TxGVNN/oops")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256 (base32 hash))))
      (build-system copy-build-system)
      (arguments
       '(#:install-plan
         '(("profile/etc" "etc")
           ("profile/bin" "bin"))))
      (home-page "https://github.com/TxGVNN/oops")
      (synopsis "TxGVNN's emacs config")
      (description "TxGVNN's emacs config")
      (license license:gpl3+))))
