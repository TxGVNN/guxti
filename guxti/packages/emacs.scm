(define-module (guxti packages emacs)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages emacs-xyz)
  )

(define-public emacs-project
  (package
    (name "emacs-project")
    (version "0.9.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/project-" version ".tar"))
       (sha256
        (base32 "10xmpx24k98crpddjdz1i4wck05kcnj3wdxhdj4km53nz8q66wbg"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-xref))
    (home-page "https://elpa.gnu.org/packages/project.html")
    (synopsis "Operations on the current project")
    (description
     "This library contains generic infrastructure for dealing with projects,
some utility functions, and commands using that infrastructure.")
    (license license:gpl3+)))


(define-public emacs-crux
  (package
    (name "emacs-crux")
    (version "0.4.0-20230113")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bbatsov/crux")
             (commit "0.4.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1h28chpyq61k72qh749r5kqq1y70wx3xw9c3zyfzmy750wlw6nyj"))
       (patches (search-patches "emacs-crux.patch"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-seq emacs-shrink-path))
    (home-page "https://github.com/bbatsov/crux")
    (synopsis "Collection of useful functions for Emacs")
    (description
     "@code{crux} provides a collection of useful functions for Emacs.")
    (license license:gpl3+)))
