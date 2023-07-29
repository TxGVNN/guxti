(define-module (guxti packages me)
  #:use-module (guix git-download)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))


(define-public oops
  (let ((commit "1644eb48be04e1648db776fe74511011acc6dad3")
        (hash "03rjn5xcg7gcknkqnm9ipshhawwnzbbnjbvch46a42yk301phjln")
        (version "20230729.0747"))
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
