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
  #:use-module (gnu packages screen)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz))

(define-public emacs-crux-me
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

(define-public emacs-perspective-me
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

(define-public emacs-consult-me
  (let ((commit "0.34"))
    (package
      (name "emacs-consult")
      (version "0.34.20230427")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/minad/consult")
               (commit commit)))
         (sha256
          (base32 "1ggbvc5ylsw430w05fjl4vk1hmim45mwah7cyr94g03rwjhng1sc"))
         (file-name (git-file-name name version))
         ))
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

(define-public emacs-embark-me
  (let ((commit "c914efe881df2bc6a2bd35cc7ee975d3e9d4a418")) ;version bump
    (package
      (name "emacs-embark")
      (version "0.22.1.20230427")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "1l288w27wav0r71hprqi74r77042d1fx3p1zmi05vl6z6230h48b"))
         (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-avy emacs-consult-me))
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
  (let ((commit "c914efe881df2bc6a2bd35cc7ee975d3e9d4a418")) ;version bump
    (package
      (name "emacs-embark-consult")
      (version "0.22.1")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "1l288w27wav0r71hprqi74r77042d1fx3p1zmi05vl6z6230h48b"))
         (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-consult-me emacs-embark-me))
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

(define-public emacs-consult-yasnippet-me
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
      (propagated-inputs (list emacs-consult-me emacs-yasnippet))
      (home-page "https://github.com/mohkale/consult-yasnippet")
      (synopsis "Consulting-read interface for Yasnippet")
      (description
       "This package allows you to expand Yasnippet' snippets through
a completing-read interface.  It supports previewing the current snippet
expansion and overwriting the marked region with a new snippet completion.")
      (license license:gpl3+))))

(define-public emacs-yasnippet-snippets-me
  (let ((commit "e360d047")
        (hash "0v5qv6czlw4k0cc6aqwrqv11prm7xr7arsis3fjm7arms7939din"))
    (package
      (name "emacs-yasnippet-snippets")
      (version "1.0.20230331")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/TxGVNN/yasnippet-snippets")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 hash))))
      (build-system emacs-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-before 'build 'set-home
             (lambda _ (setenv "HOME" (getcwd))))
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

(define-public emacs-project-tasks
  (let ((commit "3e2de52")
        (hash "0mpyblrwmxzgcz3dpshikd948vnjiqd658yx6fq76i1vcmi1bb7v"))
    (package
      (name "emacs-project-tasks")
      (version "0.2.0")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/TxGVNN/project-tasks")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256 (base32 hash))))
      (build-system emacs-build-system)
      (propagated-inputs (list emacs-project))
      (home-page "https://github.com/TxGVNN/project-tasks")
      (synopsis "Efficient task management for your project.")
      (description "Manage your tasks in a project by using org file and code blocks.
 I will call it is Tasks As Code.")
      (license license:gpl3+))))

(define-public emacs-detached-me
  (package
    (name "emacs-detached")
    (version "0.10.1.20230406")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~niklaseklund/detached.el")
             (commit "0.10.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0dvvyqc0nw9has54vps10f5iv831cb29vqvbvx0m2djv9pacqp17"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-detached.patch")))))
    (arguments
     (list
      #:tests? #t
      #:test-command #~(list "ert-runner")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'fix-version
            (lambda _
              (substitute*
                  (string-append (string-drop #$name (string-length "emacs-")) ".el")
                (("^;; Version: ([^/[:blank:]\r\n]*)(.*)$")
                 (string-append ";; Version: " #$version "\n")))))
          (add-after 'unpack 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (emacs-substitute-variables "detached.el"
                ("detached-dtach-program"
                 (search-input-file inputs "/bin/dtach"))
                ("detached-shell-program"
                 (search-input-file inputs "/bin/bash"))))))))
    (build-system emacs-build-system)
    (native-inputs (list emacs-ert-runner))
    (inputs (list dtach))
    (home-page "https://git.sr.ht/~niklaseklund/detached.el")
    (synopsis "Launch and manage detached processes from Emacs")
    (description
     "The Detached package allows users to run processes detached from Emacs.
It provides integration with multiple built-in modes, as well as providing an
interface to attach and interact with the processes.")
    (license license:gpl3+)))

(define-public emacs-org-alert
  (package
    (name "emacs-org-alert")
    (version "0.2.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/spegoraro/org-alert.git")
                    (commit "6d3c0acd66d8626ec2cb353c9da92a214039c7ab")))
              (sha256
               (base32
                "12vy25sf3cz2y2y1s2s3q2c4ykfldvd8zj0vy2adiyda7bzqflgs"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-org emacs-alert))
    (home-page "https://github.com/spegoraro/org-alert")
    (synopsis "Notify org deadlines via notify-send")
    (description
     "This package provides functions to display system notifications for any org-mode
deadlines that are due in your agenda.  To perform a one-shot check call
(org-alert-deadlines).  To enable repeated checking call (org-alert-enable) and
to disable call (org-alert-disable).  You can set the checking interval by
changing the org-alert-interval variable to the number of seconds you'd like.")
    (license license:gpl3+)))
