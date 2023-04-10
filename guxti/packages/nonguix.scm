(define-module (guxti packages nonguix)
  #:use-module (guix download)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))

(define-public ghcli
  (package
    (name "ghcli")
    (version "2.27.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/cli/cli/releases/download/v"
                           version "/gh_" version "_linux_amd64.tar.gz"))
       (sha256
        (base32
         "0ivpc85cs35yrx7immcn67pa3ml02ig4rxlj047fkr7d95z9iqm3"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("bin/gh" "bin/gh")
         ("share/man" "share/man"))))
    (home-page "https://github.com/cli/cli")
    (synopsis "GitHub’s official command line tool ")
    (description
     "gh is GitHub on the command line. It brings pull requests, issues,
and other GitHub concepts to the terminal next to where
you are already working with git and your code..")
    (license license:expat)))
