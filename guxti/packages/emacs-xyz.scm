(define-module (guxti packages emacs-xyz)
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
    (version "0.9.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/project-" version ".tar"))
       (sha256
        (base32 "0i1q9blvpj3bygjh98gv0kqn2rm01b8lqp9vra82sy3hzzj39pyx"))))
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
    (version "0.4.0.20230115")
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
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after
             'unpack 'fix-version
           (lambda _
             (substitute*
                 (string-append (string-drop ,name (string-length "emacs-")) ".el")
               (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                (string-append ";; Version: " ,version "\n"))))))))
    (propagated-inputs (list emacs-seq emacs-shrink-path))
    (home-page "https://github.com/bbatsov/crux")
    (synopsis "Collection of useful functions for Emacs")
    (description
     "@code{crux} provides a collection of useful functions for Emacs.")
    (license license:gpl3+)))

(define-public emacs-perspective
  (package
    (name "emacs-perspective")
    (version "2.16.20230114")
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
     `(#:phases
       (modify-phases %standard-phases
         (add-after
             'unpack 'fix-version
           (lambda _
             (substitute*
                 (string-append (string-drop ,name (string-length "emacs-")) ".el")
               (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                (string-append ";; Version: " ,version "\n"))))))

       #:tests? #t
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
    (version "1.5.3.20230119")
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
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after
             'unpack 'fix-version
           (lambda _
             (substitute*
                 (string-append (string-drop ,name (string-length "emacs-")) ".el")
               (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                (string-append ";; Version: " ,version "\n"))))))))
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
    (version "1.4.20230114")
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
     `(#:phases
       (modify-phases %standard-phases
         (add-after
             'unpack 'fix-version
           (lambda _
             (substitute*
                 (string-append (string-drop ,name (string-length "emacs-")) ".el")
               (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                (string-append ";; Version: " ,version "\n"))))))
       #:tests? #t
       #:test-command '("ert-runner")))
    (home-page "https://github.com/Wilfred/elisp-refs")
    (synopsis "Find callers of elisp functions or macros")
    (description "@code{elisp-refs} finds references to functions, macros or
variables.  Unlike a dumb text search, it actually parses the code, so it's
never confused by comments or @code{foo-bar} matching @code{foo}.")
    (license license:gpl3+)))


(define-public emacs-helpful
  (package
    (name "emacs-helpful")
    (version "0.19.20230117")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Wilfred/helpful")
             (commit "94c2533")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "09da3d3kx4c8im58kwfv59zpwda70yvwnjk01w7r6lra1ww8d3yx"))))
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
    (version "2.2.0.20230115")
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
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after
             'unpack 'fix-version
           (lambda _
             (substitute*
                 (string-append (string-drop ,name (string-length "emacs-")) ".el")
               (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                (string-append ";; Version: " ,version "\n"))))))))
    (home-page "https://github.com/redguardtoo/elpa-mirror")
    (synopsis "Pixel-perfect visual alignment for Org and Markdown tables")
    (description
     "This program will create a local package repository by from all
installed packages.")
    (license license:gpl3+)))

(define-public emacs-consult
  (let ((commit "0.31"))
    (package
      (name "emacs-consult")
      (version "0.31.20230116")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/minad/consult")
               (commit commit)))
         (sha256
          (base32 "0ckyn4sdhc9dykbbdiin75jxza883dqa3g4mvf8qgsnzlqcjvvg6"))
         (file-name (git-file-name name version))
         (patches
          (parameterize
              ((%patch-path
                (map (lambda (directory)
                       (string-append directory "/guxti/packages/patches"))
                     %load-path)))
            (search-patches "emacs-consult.patch")))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after
               'unpack 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n"))))))))
      (propagated-inputs (list emacs-compat))
      (home-page "https://github.com/minad/consult")
      (synopsis "Consulting completing-read")
      (description "This package provides various handy commands based on the
Emacs completion function completing-read, which allows quickly selecting from a
list of candidates.")
      (license license:gpl3+))))

(define-public emacs-embark
  (let ((commit "0.19"))
    (package
      (name "emacs-embark")
      (version "0.19.20230116")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "05c8p7rqv9p8p3nhgcjfr66hpsqazhnhwsnfdapxd9z7wrybqbg5"))
         (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after
               'unpack 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n")))))
           (add-after 'unpack 'delete-files
             (lambda _
               (delete-file "embark-consult.el")
               (delete-file "avy-embark-collect.el"))))))
      (home-page "https://github.com/oantolin/embark")
      (synopsis "Emacs mini-buffer actions rooted in keymaps")
      (description
       "This package provides a sort of right-click contextual menu for Emacs
offering you relevant @emph{actions} to use on a @emph{target} determined by
the context.")
      (license license:gpl3+))))

(define-public emacs-embark-consult
  (package
    (name "emacs-embark-consult")
    (version "0.19")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/oantolin/embark")
             (commit version)))
       (sha256
        (base32 "05c8p7rqv9p8p3nhgcjfr66hpsqazhnhwsnfdapxd9z7wrybqbg5"))
       (file-name (git-file-name name version))))
    (build-system emacs-build-system)
    (propagated-inputs
     (list emacs-consult emacs-embark))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'delete-files
           (lambda _
             (delete-file "embark.el")
             (delete-file "embark-org.el")
             (delete-file "avy-embark-collect.el"))))))
    (home-page "https://github.com/oantolin/embark")
    (synopsis "This package provides integration between Embark and Consult")
    (description
     "This package provides integration between Embark and Consult. The package
will be loaded automatically by Embark.")
    (license license:gpl3+)))

(define-public emacs-consult-yasnippet
  (let ((commit "ae0450889484f23dc4ec37518852a2c61b89f184")
        (revision "1"))
    (package
      (name "emacs-consult-yasnippet")
      (version (git-version "0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mohkale/consult-yasnippet")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "13hmmsnmh32vafws61sckzzy354rq0nslqpyzhw97iwvn0fpsa35"))))
      (build-system emacs-build-system)
      (propagated-inputs (list emacs-consult emacs-yasnippet))
      (home-page "https://github.com/mohkale/consult-yasnippet")
      (synopsis "Consulting-read interface for Yasnippet")
      (description
       "This package allows you to expand Yasnippet' snippets through
a completing-read interface.  It supports previewing the current snippet
expansion and overwriting the marked region with a new snippet completion.")
      (license license:gpl3+))))

(define-public emacs-yasnippet-snippets
  (let ((commit "2069875"))
    (package
      (name "emacs-yasnippet-snippets")
      (version "1.0.20230127")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/TxGVNN/yasnippet-snippets")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1dza3k50slfcccxzf24jajibhms1gkj0m7wrmz4c346h9vdffma7"))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after
               'unpack 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n"))))))
         #:include (cons* "^snippets\\/" %default-include)))
      (propagated-inputs
       (list emacs-yasnippet))
      (home-page "https://github.com/TxGVNN/yasnippet-snippets")
      (synopsis "Collection of YASnippet snippets for many languages")
      (description "This package provides an extensive collection of YASnippet
snippets.  When this package is installed, the extra snippets it provides are
automatically made available to YASnippet.")
      (license license:gpl3+))))
