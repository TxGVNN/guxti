(define-module (guxti packages me)
  #:use-module (guix git-download)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))


(define-public oops
  (let ((commit "bb5ea4a60238dfc251746afa109ff90c191ad2c2")
        (hash "03xn5npxdayh6riy2qnnjkg7ih1qp0vgrgq1d6rjnhi6d3xlkyxs")
        (version "20230731.0803"))
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
      (synopsis "TxGVNN's dotfiles")
      (description "TxGVNN's dotfiles")
      (license license:gpl3+))))
