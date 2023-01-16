(define-module (guxti packages emacs)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages emacs-xyz))

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
    (version "0.4.0-28-20230113")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bbatsov/crux")
             (commit "f8789f6")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0bsyrp0xmsi1vdpgpx6n3vfrmh75bpp8ncync8srzx6clbl71ch4"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-crux.patch")))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-seq emacs-shrink-path))
    (home-page "https://github.com/bbatsov/crux")
    (synopsis "Collection of useful functions for Emacs")
    (description
     "@code{crux} provides a collection of useful functions for Emacs.")
    (license license:gpl3+)))

(define-public emacs-perspective
  (package
    (name "emacs-perspective")
    (version "2.16-7-20230114")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nex3/perspective-el")
             (commit "1c257f3")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0rgkajcw7fismqmww1r0yy84hnqripx5dwklf2mfm042whn9bqgf"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-perspective.patch")))))
    (build-system emacs-build-system)
    (arguments
     `(#:tests? #t
       #:test-command '("emacs" "-Q" "-batch" "-L" "."
                        "-l" "test/test-perspective.el"
                        "-f" "ert-run-tests-batch-and-exit")))
    (home-page "https://github.com/nex3/perspective-el")
    (synopsis "Switch between named \"perspectives\"")
    (description
     "This package provides tagged workspaces in Emacs, similar to workspaces in
windows managers such as Awesome and XMonad.  @code{perspective.el} provides
multiple workspaces (or \"perspectives\") for each Emacs frame.  Each
perspective is composed of a window configuration and a set of buffers.
Switching to a perspective activates its window configuration, and when in a
perspective only its buffers are available by default.")
    ;; This package is released under the same license as Emacs (GPLv3+) or
    ;; the Expat license.
    (license license:gpl3+)))

(define-public emacs-magit-todos
  (package
    (name "emacs-magit-todos")
    (version "1.5.3-19-gc5030cc")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/alphapapa/magit-todos")
             (commit "c5030cc")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0j32zslcbiaq2a6ppyzdq4x59payya5hzd2kpw3mdj0p479byz19"))))
    (build-system emacs-build-system)
    (propagated-inputs
     (list emacs-async
           emacs-dash
           emacs-f
           emacs-hl-todo
           emacs-magit
           emacs-pcre2el
           emacs-s))
    (home-page "https://github.com/alphapapa/magit-todos")
    (synopsis "Show source files' TODOs (and FIXMEs, etc) in Magit status buffer")
    (description "This package displays keyword entries from source code
comments and Org files in the Magit status buffer.  Activating an item jumps
to it in its file.  By default, it uses keywords from @code{hl-todo}, minus a
few (like NOTE).")
    (license license:gpl3)))

(define-public emacs-elisp-refs
  (package
    (name "emacs-elisp-refs")
    (version "1.4-20230114")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Wilfred/elisp-refs")
             (commit "af73739084637c8ebadad337a8fe58ff4f1d2ec1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0kbx2dxvbidl2fjxw41hhdhk4iicvdf9zwxmgdr2glrf3sv9ncb5"))))
    (build-system emacs-build-system)
    (propagated-inputs
     (list emacs-dash
           emacs-f
           emacs-list-utils
           emacs-loop
           emacs-s
           emacs-shut-up))
    (native-inputs
     (list emacs-ert-runner emacs-undercover))
    (arguments
     (list
      #:tests? #t
      #:test-command #~(list "ert-runner")))
    (home-page "https://github.com/Wilfred/elisp-refs")
    (synopsis "Find callers of elisp functions or macros")
    (description "@code{elisp-refs} finds references to functions, macros or
variables.  Unlike a dumb text search, it actually parses the code, so it's
never confused by comments or @code{foo-bar} matching @code{foo}.")
    (license license:gpl3+)))


(define-public emacs-helpful
  (package
    (name "emacs-helpful")
    (version "0.19-20230114")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Wilfred/helpful")
             (commit "0.19")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0qwsifzsjw95l83m7z07fr9h1sqbhggwmcps1qgbddpan2a8ab8a"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-helpful-fix-docstring-test.patch")))))
    (build-system emacs-build-system)
    (propagated-inputs
     (list emacs-elisp-refs emacs-dash emacs-s emacs-f emacs-shut-up))
    (native-inputs
     (list emacs-ert-runner emacs-undercover))
    (arguments
     `(#:tests? #t
       #:test-command '("ert-runner")))
    (home-page "https://github.com/Wilfred/helpful")
    (synopsis "More contextual information in Emacs help")
    (description "@code{helpful} is an alternative to the built-in Emacs help
that provides much more contextual information.")
    (license license:gpl3+)))

(define-public emacs-elpa-mirror
  (package
    (name "emacs-elpa-mirror")
    (version "2.2.0-20230115")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/TxGVNN/elpa-mirror")
             (commit "eadf584")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1p89dgnyina60ipvzys1lzfs9havwpn1nh9vmd9qn6lgr5028k3y"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/redguardtoo/elpa-mirror")
    (synopsis "Pixel-perfect visual alignment for Org and Markdown tables")
    (description
     "This program will create a local package repository by from all
installed packages.")
    (license license:gpl3+)))
