(define-module (guxti packages emacs-xyz)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages emacs)
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
    (version "1.5.3.20230226")
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
  (let ((version "2.2.2.20230318")
        (commit "9d7cfbf72ef8c7cd014c91e5bb3d8fbebda56140")
        (hash "0lw018bn5a6z8pxzqscs196l8k18m1m9p0p6amr3n27qmf6fp3vw"))
    (package
      (name "emacs-elpa-mirror")
      (version version)
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/redguardtoo/elpa-mirror")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 hash))))
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
      (synopsis "Create local emacs package repository.")
      (description
       "This program will create a local package repository by from all
installed packages.")
      (license license:gpl3+))))

(define-public emacs-consult
  (let ((commit "0.31"))
    (package
      (name "emacs-consult")
      (version "0.31.20230224")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/minad/consult")
               (commit commit)))
         (sha256
          (base32 "0ckyn4sdhc9dykbbdiin75jxza883dqa3g4mvf8qgsnzlqcjvvg6"))
         (file-name (git-file-name name version))
         (patches (list (local-file
                         "patches/emacs-consult.patch")))))
      (build-system emacs-build-system)
      (propagated-inputs (list emacs-compat))
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
      (home-page "https://github.com/minad/consult")
      (synopsis "Consulting completing-read")
      (description "This package provides various handy commands based on the
Emacs completion function completing-read, which allows quickly selecting from a
list of candidates.")
      (license license:gpl3+))))

(define-public emacs-embark
  (let ((commit "63013c2d3ef4dccc95167218ccbf4f401e489c3e")) ;version bump
    (package
      (name "emacs-embark")
      (version "0.21.1.20230225")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "14qp46wa1xgmb09jyk9cadj0b3m7bwspqnprk3zbfc6gw1r53235"))
         (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-avy emacs-consult))
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
  (let ((commit "63013c2d3ef4dccc95167218ccbf4f401e489c3e")) ;version bump
    (package
      (name "emacs-embark-consult")
      (version "0.21.1")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "14qp46wa1xgmb09jyk9cadj0b3m7bwspqnprk3zbfc6gw1r53235"))
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
      (license license:gpl3+))))

(define-public emacs-consult-yasnippet
  (let ((commit "ae0450889484f23dc4ec37518852a2c61b89f184")
        (revision "20230226"))
    (package
      (name "emacs-consult-yasnippet")
      (version (string-append "0.2." revision))
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
  (let ((commit "947d8f4"))
    (package
      (name "emacs-yasnippet-snippets")
      (version "1.0.20230312")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/TxGVNN/yasnippet-snippets")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1pb5dj587zr532wyll4p0f9zl9hcjjb6yswlk83zzk6ahf862467"))))
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

(define-public emacs-transient
  (let ((commit "v0.3.7"))
    (package
      (name "emacs-transient")
      (version "0.3.7.20230226")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/magit/transient")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0c7wbd0j0b802bzdpdkrx2q7wm7b9s56rk554dnadkpywhmdiqwn"))))
      (build-system emacs-build-system)
      (arguments
       `(#:tests? #f                      ;no test suite
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'build-info-manual
             (lambda _
               (invoke "make" "info")
               ;; Move the info file to lisp so that it gets installed by the
               ;; emacs-build-system.
               (rename-file "docs/transient.info" "lisp/transient.info")))
           (add-after 'build-info-manual 'enter-lisp-directory
             (lambda _
               (chdir "lisp")))
           (add-after 'enter-lisp-directory 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Package-Version: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n"))))))))
      (native-inputs
       (list texinfo))
      (propagated-inputs
       (list emacs-dash))
      (home-page "https://magit.vc/manual/transient")
      (synopsis "Transient commands in Emacs")
      (description "Taking inspiration from prefix keys and prefix arguments
in Emacs, Transient implements a similar abstraction involving a prefix
command, infix arguments and suffix commands.  We could call this abstraction
a \"transient command\", but because it always involves at least two
commands (a prefix and a suffix) we prefer to call it just a \"transient\".")
      (license license:gpl3+))))


(define-public emacs-with-editor
  (let ((commit "v3.2.0"))
    (package
      (name "emacs-with-editor")
      (version "3.2.0.20230226")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/magit/with-editor")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "1d98hagpm6h5vgx80qlh3zrfcb6z000rfc707w9zzmh634dkg3xx"))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'enter-lisp-directory
             (lambda _
               (chdir "lisp")))
           (add-after 'enter-lisp-directory 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Package-Version: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n")))))
           (add-before 'install 'make-info
             (lambda _
               (with-directory-excursion "../docs"
                 (invoke "makeinfo" "--no-split"
                         "-o" "with-editor.info" "with-editor.texi")
                 (install-file "with-editor.info" "../lisp")))))))
      (native-inputs
       (list texinfo))
      (propagated-inputs
       (list emacs-async))
      (home-page "https://github.com/magit/with-editor")
      (synopsis "Emacs library for using Emacsclient as EDITOR")
      (description
       "This package provides an Emacs library to use the Emacsclient as
@code{$EDITOR} of child processes, making sure they know how to call home.
For remote processes a substitute is provided, which communicates with Emacs
on stdout instead of using a socket as the Emacsclient does.")
      (license license:gpl3+))))


(define-public emacs-envrc
  (let ((commit "0.4"))
    (package
      (name "emacs-envrc")
      (version (string-append commit ".20230226"))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/purcell/envrc")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0nqqx4qlw75lmbn0v927sg3xyjkk86ihw1q3rdbbn59va41grds4"))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after
               'unpack 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Package-Version: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n"))))))))
      (propagated-inputs
       (list emacs-inheritenv))
      (home-page "https://github.com/purcell/envrc")
      (synopsis "Support for Direnv which operates buffer-locally")
      (description
       "This is library which uses Direnv to set environment variables on
a per-buffer basis.  This means that when you work across multiple projects
which have @file{.envrc} files, all processes launched from the buffers ``in''
those projects will be executed with the environment variables specified in
those files.  This allows different versions of linters and other tools to be
used in each project if desired.")
      (license license:gpl3+))))

(define-public emacs-closql
  (let ((commit "v1.2.1"))
    (package
      (name "emacs-closql")
      (version "1.2.1.20230226")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/emacscollective/closql")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1s9riibws28xjn2bjn9qz3m2gvcmrn18b7g5y6am4sy7rgkx3nwx"))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after
               'unpack 'fix-version
             (lambda _
               (substitute*
                   (string-append (string-drop ,name (string-length "emacs-")) ".el")
                 (("^;; Keywords: ([^/[:blank:]\r\n]*)(.*)$")
                  (string-append ";; Version: " ,version "\n;; Keywords: extensions\n"))))))))
      (propagated-inputs
       (list emacs-emacsql))
      (home-page "https://github.com/emacscollective/closql")
      (synopsis "Store EIEIO objects using EmacSQL")
      (description
       "This package stores uniform EIEIO objects in an EmacSQL
database.  SQLite is used as backend.  This library imposes some restrictions
on what kind of objects can be stored; it isn't intended to store arbitrary
objects.  All objects have to share a common superclass and subclasses cannot
add any additional instance slots.")
      (license license:gpl3))))

(define-public emacs-emacsql
  (let ((commit "e1baaf2f874df7f9259a8ecca978e03d3ddae5b5")
        (revision "20230226"))
    (package
      (name "emacs-emacsql")
      (version (string-append "3.1.1" revision))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/magit/emacsql")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0dvqs1jg5zqn0i3r67sn1a40h5rm961q9vxvmqxbgvdhkjvip8fn"))))
      (build-system emacs-build-system)
      (arguments
       (list
        #:tests? #true
        #:test-command #~(list "emacs" "-Q" "--batch"
                               "-L" "tests"
                               "-L" "."
                               "-l" "tests/emacsql-tests.el"
                               "-f" "ert-run-tests-batch-and-exit")
        #:modules '((guix build emacs-build-system)
                    (guix build utils)
                    (guix build emacs-utils)
                    (srfi srfi-26))
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'fix-version
              (lambda _
                (substitute*
                    (string-append (string-drop #$name (string-length "emacs-")) ".el")
                  (("^;; Package-Version: ([^/[:blank:]\r\n]*)(.*)$")
                   (string-append ";; Version: " #$version "\n")))))
            (add-before 'install 'remove-sqlite-builtin
              ;; Current emacs 28.2 doesn't have sqlite feature and compilation
              ;; of this file fails.  This phase should be removed, when emacs
              ;; package is updated to 29.
              (lambda _
                (delete-file "emacsql-sqlite-builtin.el")))
            (add-before 'install 'patch-elisp-shell-shebangs
              (lambda _
                (substitute* (find-files "." "\\.el")
                  (("/bin/sh") (which "sh")))))
            (add-after 'patch-elisp-shell-shebangs 'setenv-shell
              (lambda _
                (setenv "SHELL" "sh")))
            (add-after 'setenv-shell 'build-emacsql-sqlite
              (lambda _
                (invoke "make" "binary" (string-append "CC=" #$(cc-for-target)))))
            (add-after 'build-emacsql-sqlite 'install-emacsql-sqlite
              ;; This build phase installs emacs-emacsql binary.
              (lambda _
                (install-file "sqlite/emacsql-sqlite"
                              (string-append #$output "/bin"))))
            (add-after 'install-emacsql-sqlite 'patch-emacsql-sqlite.el
              ;; This build phase removes interactive prompts
              ;; and makes sure Emacs look for binaries in the right places.
              (lambda _
                (emacs-substitute-variables "emacsql-sqlite.el"
                  ("emacsql-sqlite-executable"
                   (string-append #$output "/bin/emacsql-sqlite"))
                  ;; Make sure Emacs looks for ‘GCC’ binary in the right place.
                  ("emacsql-sqlite-c-compilers"
                   `(list ,(which "gcc")))))))))
      (inputs
       (list emacs-minimal `(,mariadb "dev") `(,mariadb "lib") postgresql))
      (propagated-inputs
       (list emacs-finalize emacs-pg emacs-sqlite3-api))
      (home-page "https://github.com/magit/emacsql")
      (synopsis "Emacs high-level SQL database front-end")
      (description "Any readable Lisp value can be stored as a value in EmacSQL,
including numbers, strings, symbols, lists, vectors, and closures.  EmacSQL
has no concept of @code{TEXT} values; it's all just Lisp objects.  The Lisp
object @code{nil} corresponds 1:1 with @code{NULL} in the database.")
      (license license:gpl3+))))

(define-public emacs-magit
  (let ((commit "2c91c080a8e2f35e3b036a2f6b8011fa897d23a1")
        (revision "20230226"))
    (package
      (name "emacs-magit")
      (version (string-append "3.3.0." revision))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/magit/magit")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "00ibnr76nfyf4fff3ga324d7dbqnsb4crlxgr94npiy8rsclaszp"))))
      (build-system emacs-build-system)
      (arguments
       (list
        #:tests? #t
        #:test-command #~(list "make" "test")
        #:exclude #~(cons* "magit-libgit.el"
                           "magit-libgit-pkg.el"
                           %default-exclude)
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'build-info-manual
              (lambda _
                (invoke "make" "info")
                ;; Copy info files to the lisp directory, which acts as
                ;; the root of the project for the emacs-build-system.
                (for-each (lambda (f)
                            (install-file f "lisp"))
                          (find-files "docs" "\\.info$"))))
            (add-after 'build-info-manual 'set-magit-version
              (lambda _
                (make-file-writable "lisp/magit.el")
                (emacs-substitute-variables "lisp/magit.el"
                  ("magit-version" #$version))))
            (add-after 'set-magit-version 'patch-exec-paths
              (lambda* (#:key inputs #:allow-other-keys)
                (for-each make-file-writable
                          (list "lisp/magit-git.el" "lisp/magit-sequence.el"))
                (emacs-substitute-variables "lisp/magit-git.el"
                  ("magit-git-executable"
                   (search-input-file inputs "/bin/git")))
                (emacs-substitute-variables "lisp/magit-sequence.el"
                  ("magit-perl-executable"
                   (search-input-file inputs "/bin/perl")))))
            (add-before 'check 'configure-git
              (lambda _
                ;; Otherwise some tests fail with error "unable to auto-detect
                ;; email address".
                (setenv "HOME" (getcwd))
                (invoke "git" "config" "--global" "user.name" "toto")
                (invoke "git" "config" "--global" "user.email"
                        "toto@toto.com")))
            (replace 'expand-load-path
              (lambda args
                (with-directory-excursion "lisp"
                  (apply (assoc-ref %standard-phases 'expand-load-path) args))))
            (replace 'install
              (lambda args
                (with-directory-excursion "lisp"
                  (apply (assoc-ref %standard-phases 'install) args)))))))
      (native-inputs
       (list texinfo))
      (inputs
       (list git perl))
      (propagated-inputs
       (list emacs-dash emacs-with-editor emacs-compat))
      (home-page "https://magit.vc/")
      (synopsis "Emacs interface for the Git version control system")
      (description
       "With Magit, you can inspect and modify your Git repositories
with Emacs.  You can review and commit the changes you have made to
the tracked files, for example, and you can browse the history of past
changes.  There is support for cherry picking, reverting, merging,
rebasing, and other common Git operations.")
      (license license:gpl3+))))

(define-public emacs-forge
  (package
    (name "emacs-forge")
    (version "0.3.2.20230226")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/magit/forge")
             (commit "v0.3.2")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0p1jlq169hpalhzmjm3h4q3x5xr9kdmz0qig8jwfvisyqay5vbih"))))
    (build-system emacs-build-system)
    (arguments
     `(#:tests? #f                     ;no tests
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'build-info-manual
           (lambda _
             (invoke "make" "info")
             ;; Move the info file to lisp so that it gets installed by the
             ;; emacs-build-system.
             (rename-file "docs/forge.info" "lisp/forge.info")))
         (add-after 'build-info-manual 'chdir-lisp
           (lambda _
             (chdir "lisp")))

         (add-after 'chdir-lisp 'fix-version
           (lambda _
             (substitute*
                 (string-append (string-drop ,name (string-length "emacs-")) ".el")
               (("^;; Keywords: ([^/[:blank:]\r\n]*)(.*)$")
                (string-append ";; Version: " ,version "\n;; Keywords: git tools vc\n"))))))))
    (native-inputs
     (list texinfo))
    (propagated-inputs
     (list emacs-closql
           emacs-dash
           emacs-emacsql
           emacs-ghub
           emacs-let-alist
           emacs-magit
           emacs-markdown-mode
           emacs-yaml))
    (home-page "https://github.com/magit/forge/")
    (synopsis "Access Git forges from Magit")
    (description "Work with Git forges, such as Github and Gitlab, from the
comfort of Magit and the rest of Emacs.")
    (license license:gpl3+)))

(define-public emacs-eev
  (package
    (name "emacs-eev")
    (version "20230127")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://elpa.gnu.org/packages/eev-" version ".tar"))
              (sha256
               (base32 "12f8r1mymd73gjbha6w9fk1ar38yxgbnrr6asvr8aa9rhcwwgxqm"))))
    (build-system emacs-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'patch-el-files))))
    (home-page "http://anggtwu.net/#eev")
    (synopsis "Support for e-scripts (eepitch blocks, elisp hyperlinks, etc)")
    (description
     "Eev's central idea is that you can keep \"executable logs\" of what you do, in a
format that is reasonably readable and that is easy to \"play back\" later, step
by step and in any order.  We call these \"executable logs\" _e-scripts_.")
    (license license:gpl3+)))

(define-public emacs-combobulate
  (let ((commit "6c36a85")
        (hash "090sxd7pfq95pfylbsi6kwb82pz2rs1ny2gwq3m3m7xlhm2ar4n7"))
    (package
      (name "emacs-combobulate")
      (version "0.1.20230318")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/mickeynp/combobulate")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256 (base32 hash))))
      (build-system emacs-build-system)
      (arguments
       `(#:emacs ,emacs-next
         #:include (cons* "^build\\/" %default-include)))
      (home-page "https://github.com/mickeynp/combobulate")
      (synopsis "Structured Navigation and Editing.")
      (description "Combobulate is a package that adds structured editing
and movement to a wide range of programming languages.")
      (license license:gpl3+))))
