(define-module (guxti packages emacs-xyz)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages ncurses)
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
    (version "0.4.0.20231015")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bbatsov/crux")
             (commit "3998b75")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "00l0y7alcsgmhiif9isjkw6i7lgq540414m9kzadjqnf49jq28zr"))
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
    (version "2.18.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nex3/perspective-el")
             (commit "2.18")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1r026cw6p2ss5wg8mxgzf6iv1lb9pdnqyf6yrqb914aibkrvp9b6"))
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

(define-public emacs-embark-me
  (let ((commit "1.0")) ;version bump
    (package
      (name "emacs-embark")
      (version (string-append commit ".1"))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "14alpanynww6z7yxxyiiy24c0p4pq1argsb0pmqavq25mdxgn4v2"))
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
  (let ((commit "1.0")) ;version bump
    (package
      (name "emacs-embark-consult")
      (version (string-append commit ".1"))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/oantolin/embark")
               (commit commit)))
         (sha256
          (base32 "14alpanynww6z7yxxyiiy24c0p4pq1argsb0pmqavq25mdxgn4v2"))
         (file-name (git-file-name name version))))
      (build-system emacs-build-system)
      (propagated-inputs
       (list emacs-consult emacs-embark-me))
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
        (revision "20240128"))
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
      (propagated-inputs (list emacs-consult emacs-yasnippet-me))
      (home-page "https://github.com/mohkale/consult-yasnippet")
      (synopsis "Consulting-read interface for Yasnippet")
      (description
       "This package allows you to expand Yasnippet' snippets through
a completing-read interface.  It supports previewing the current snippet
expansion and overwriting the marked region with a new snippet completion.")
      (license license:gpl3+))))


(define-public emacs-yasnippet-me
  (package
    (name "emacs-yasnippet")
    (version "0.14.0-1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/joaotavora/yasnippet")
             (commit "0.14.0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0via9dzw8m5lzymg1h78xkwjssh39zr3g6ccyamlf1rjzjsyxknv"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-yasnippet-fix-empty-snippet-next.patch"
                          "emacs-yasnippet-fix-tests.patch"
                          "emacs-yasnippet-lighter.patch")))))
    (build-system emacs-build-system)
    (arguments
     `(#:tests? #t
       #:test-command '("emacs" "--batch"
                        "-l" "yasnippet-tests.el"
                        "-f" "ert-run-tests-batch-and-exit")
       #:phases
       (modify-phases %standard-phases
         ;; Set HOME, otherwise test-rebindings fails.
         (add-before 'check 'set-home
           (lambda _
             (setenv "HOME" (getcwd))
             #t)))))
    (home-page "https://github.com/joaotavora/yasnippet")
    (synopsis "Yet another snippet extension for Emacs")
    (description "YASnippet is a template system for Emacs.  It allows you to
type an abbreviation and automatically expand it into function templates.")
    (license license:gpl3+)))

(define-public emacs-yasnippet-snippets-me
  (let ((commit "c67d876a")
        (hash "0c64mk4kkm352lfs3rxrpydq5kvb04cqb4m0rl6x8xjg4q22ynh4"))
    (package
      (name "emacs-yasnippet-snippets")
      (version "1.0.20231116")
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
       (list emacs-yasnippet-me))
      (home-page "https://github.com/TxGVNN/yasnippet-snippets")
      (synopsis "Collection of YASnippet snippets for many languages")
      (description "This package provides an extensive collection of YASnippet
snippets.  When this package is installed, the extra snippets it provides are
automatically made available to YASnippet.")
      (license license:gpl3+))))

(define-public emacs-eev
  (package
    (name "emacs-eev")
    (version "20240205")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://elpa.gnu.org/packages/eev-" version ".tar"))
              (sha256
               (base32 "06psmcf3yi7pincsbhjrcrml0wzwgmlv6xy2fbpg1sg8vlibbgi3"))))
    (build-system emacs-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'patch-el-files))
       #:exclude (delete "^[^/]*tests?\\.el$" %default-exclude)))
    (home-page "http://anggtwu.net/#eev")
    (synopsis "Support for e-scripts (eepitch blocks, elisp hyperlinks, etc)")
    (description
     "Eev's central idea is that you can keep \"executable logs\" of what you do, in a
format that is reasonably readable and that is easy to \"play back\" later, step
by step and in any order.  We call these \"executable logs\" _e-scripts_.")
    (license license:gpl3+)))

(define-public emacs-combobulate
  (let ((commit "c7e4670a3047c0b58dff3746577a5c8e5832cfba")
        (hash "063w2sm0c7xhg3ml31xp870azb0sv7z689lnbnjnbl3rfdy4kg50"))
    (package
      (name "emacs-combobulate")
      (version "0.1.20240217")
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
       `(#:include (cons* "^build\\/" %default-include)))
      (home-page "https://github.com/mickeynp/combobulate")
      (synopsis "Structured Navigation and Editing.")
      (description "Combobulate is a package that adds structured editing
and movement to a wide range of programming languages.")
      (license license:gpl3+))))

(define-public emacs-project-tasks
  (let ((commit "6a97747d53ba1e0c2cb7cfc7f4e9e3011e8e4208")
        (hash "1bwnisl6hgm4b9kxm0qzj15hfkd5hw1g8mzq90prdnmjzp48hh0k"))
    (package
      (name "emacs-project-tasks")
      (version "0.5.0")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/TxGVNN/project-tasks")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256 (base32 hash))))
      (build-system emacs-build-system)
      (home-page "https://github.com/TxGVNN/project-tasks")
      (synopsis "Efficient task management for your project.")
      (description "Manage your tasks in a project by using org file and code blocks.
 I will call it is Tasks As Code.")
      (license license:gpl3+))))

(define-public emacs-detached-me
  (package
    (name "emacs-detached")
    (version "0.10.1.20240220")
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

(define-public emacs-alert-next
  (package
    (name "emacs-alert")
    (version "1.3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jwiegley/alert")
             (commit "c762380ff71c429faf47552a83605b2578656380")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0c3x54svfal236jwmz2a2jl933av2p1wm83g2vapmqzifz2c0ziw"))))
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
     (list emacs-gntp emacs-log4e))
    (home-page "https://github.com/jwiegley/alert")
    (synopsis "Growl-style notification system for Emacs")
    (description
     "Alert is a Growl-workalike for Emacs which uses a common notification
interface and multiple, selectable \"styles\", whose use is fully
customizable by the user.")
    (license license:gpl2+)))

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
    (propagated-inputs (list emacs-org emacs-alert-next))
    (home-page "https://github.com/spegoraro/org-alert")
    (synopsis "Notify org deadlines via notify-send")
    (description
     "This package provides functions to display system notifications for any org-mode
deadlines that are due in your agenda.  To perform a one-shot check call
(org-alert-deadlines).  To enable repeated checking call (org-alert-enable) and
to disable call (org-alert-disable).  You can set the checking interval by
changing the org-alert-interval variable to the number of seconds you'd like.")
    (license license:gpl3+)))

(define-public emacs-ob-compile
  (package
    (name "emacs-ob-compile")
    (version "0.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/TxGVNN/ob-compile.git")
                    (commit "9a16b3dd0f467c091e91944b90a2ca3d646d6617")))
              (sha256 (base32
                       "0ajs108ib4g57sik31m81hw6ln11gcyrx96x4f1d6hx73c8i8nk7"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/TxGVNN/ob-compile")
    (synopsis "Run compile by org-babel")
    (description
     "Run compile in org-mode.  Example: #+begin_src compile :name uname :output
(format \"compile-%s\" (format-time-string \"%y%m%d-%H%M%S\")) uname -a #+end_src To
enable saving the output, you have to config: (add-hook
compilation-finish-functions #'ob-compile-save-file)")
    (license license:gpl3+)))

(define-public emacs-corfu-terminal-next
  (package
    (name "emacs-corfu-terminal")
    (version "0.6")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://codeberg.org/akib/emacs-corfu-terminal")
         (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0f9zd4q9w5bkli7nbpdkmhglhvafisglhhqb7wfvghpp9gbcafkp"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-corfu emacs-popon-next))
    (home-page "https://codeberg.org/akib/emacs-corfu-terminal/")
    (synopsis "Replace corfu child frames with popups")
    (description
     "This package replaces the child frames @code{emacs-corfu} uses
with popups, which also work in the terminal.")
    (license license:gpl3+)))

(define-public emacs-popon-next
  (package
    (name "emacs-popon")
    (version "0.13")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://codeberg.org/akib/emacs-popon")
         (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "046l8is3rg0c6qhiy7wh91pcdhwqhnw47md8q231w8mxnw5b1n5j"))))
    (build-system emacs-build-system)
    (home-page "https://codeberg.org/akib/emacs-popon/")
    (synopsis "Pop floating text on a window")
    (description
     "@code{emacs-popon} allows you to pop text on a window, what we call
a popon.  Popons are window-local and sticky, they don't move while
scrolling, and they even don't go away when switching buffer, but you
can bind a popon to a specific buffer to only show on that buffer.")
    (license license:gpl3+)))

(define-public emacs-isearch-mb
  (package
    (name "emacs-isearch-mb")
    (version "0.7")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://elpa.gnu.org/packages/isearch-mb-"
                                  version ".tar"))
              (sha256 (base32
                       "1dfjh4ya9515vx0q2dv1brddw350gxd40h1g1vsa783ivvm0hm75"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/astoff/isearch-mb")
    (synopsis "Control isearch from the minibuffer")
    (description
     "ISEARCH-MB — CONTROL ISEARCH FROM THE MINIBUFFER
This Emacs package provides an alternative isearch UI based on the minibuffer.
This allows editing the search string in arbitrary ways without any special
maneuver; unlike standard isearch, cursor motion commands do not end the search.
 Moreover, the search status information in the echo area and some keybindings
are slightly simplified.")
    (license license:gpl3+)))

(define-public emacs-gist
  (package
    (name "emacs-gist")
    (version "1.5.0.20240204")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/emacsmirror/gist.git")
                    (commit "314fe6ab80fae35b95f0734eceb82f72813b6f41")))
              (sha256 (base32
                       "0vbyzww9qmsvdpdc6d6wq6drlq1r9y92807fjhs0frgzmq6dg0rh"))
              (patches
               (parameterize
                   ((%patch-path
                     (map (lambda (directory)
                            (string-append directory "/guxti/packages/patches"))
                          %load-path)))
                 (search-patches "emacs-gist.patch")))))
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
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-gh))
    (home-page "https://github.com/defunkt/gist.el")
    (synopsis "Emacs integration for gist.github.com")
    (description
     "An Emacs interface for managing gists (http://gist.github.com).")
    (license #f)))

(define-public emacs-gh
  (package
    (name "emacs-gh")
    (version "1.0.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sigma/gh.el.git")
                    (commit "b5a8d8209340d49ad82dab22d23dae0434499fdf")))
              (sha256 (base32
                       "1vab2qdjyv4c3hfp09vbkqanfwj8ip7zi64gqbg93kf1aig1qgl9"))))
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
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-pcache emacs-logito emacs-marshal))
    (home-page "https://github.com/sigma/gh.el")
    (synopsis "A GitHub library for Emacs")
    (description "")
    (license #f)))

(define-public emacs-pcache
  (package
    (name "emacs-pcache")
    (version "0.5.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sigma/pcache.git")
                    (commit "507230d094cc4a5025fe09b62569ad60c71c4226")))
              (sha256 (base32
                       "1fjdn4g9ww70f3x6vbzi3gqs9dsmqg16isajlqlflzw2716zf2nh"))))
    (build-system emacs-build-system)
    (home-page "unspecified")
    (synopsis "persistent caching for Emacs.")
    (description
     "pcache provides a persistent way of caching data, in a hashtable-like structure.
 It relies on `eieio-persistent in the backend, so that any object that can be
serialized by EIEIO can be stored with pcache.")
    (license #f)))

(define-public emacs-logito
  (package
    (name "emacs-logito")
    (version "0.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sigma/logito.git")
                    (commit "d5934ce10ba3a70d3fcfb94d742ce3b9136ce124")))
              (sha256 (base32
                       "0bnkc6smvaq37q08q1wbrxw9mlcfbrax304fxw4fx7pc1587av0d"))))
    (build-system emacs-build-system)
    (home-page "unspecified")
    (synopsis "logging library for Emacs")
    (description "This module provides logging facility for Emacs")
    (license #f)))

(define-public emacs-marshal
  (package
    (name "emacs-marshal")
    (version "0.9.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/sigma/marshal.el.git")
                    (commit "bc00044d9073482f589aad959e34d563598f682a")))
              (sha256 (base32
                       "0v5ncg88bghn4rpqw6fnvxpd0276mwn2bh6fpch7s1ibpaj2bsp0"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-ht))
    (home-page "https://github.com/sigma/marshal.el")
    (synopsis "eieio extension for automatic (un)marshalling")
    (description
     "Inspired by Go tagged structs.  alist, plist and json drivers are provided, but
implementing others just requires to inherit from `marshal-driver'.")
    (license #f)))

(define-public emacs-expreg
  (package
    (name "emacs-expreg")
    (version "1.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/casouri/expreg")
                    (commit "81803d84a00be21d5701b19ede637a2523d846e3")))
              (sha256 (base32
                       "07x0p3y9d4n381khgyps6pmwlv859l2mq6j7ba1a44kpbll3mpii"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/casouri/expreg")
    (synopsis "Simple expand region")
    (description
     "This is just like expand-region, but (1) we generate all regions at once, and
(2) should be easier to debug, and (3) we out-source language-specific
expansions to tree-sitter.  Bind ‘expreg-expand’ and ‘expreg-contract’ and start
using it.  Note that if point is in between two possible regions, we only keep
the region after point.  In the example below, only region B is kept (“|”
represents point): (region A)|(region B) Expreg also recognizes subwords if
‘subword-mode’ is on.")
    (license license:gpl3+)))

(define-public emacs-codespaces
  (package
    (name "emacs-codespaces")
    (version "0.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/patrickt/codespaces.el.git")
                    (commit "7b0cfccec6cf590544456fc57d9f4481a992b413")))
              (sha256 (base32
                       "1gq09nxws90rxp5dkhyqcfkwvmn5b7p6g0x3j9caqnybgjhcl3c8"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/patrickt/codespaces.el")
    (synopsis "Connect to GitHub Codespaces via TRAMP")
    (description
     "This package provides support for connecting to GitHub Codespaces via TRAMP in
Emacs.  It also provides a completing-read interface to select codespaces.  This
package works by registering a new \"ghcs\" method in tramp-methods.")
    (license license:gpl3+)))

(define-public emacs-symbol-overlay
  (package
    (name "emacs-symbol-overlay")
    (version "4.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/wolray/symbol-overlay")
             (commit "a783d7b5d8dee5ba9f5e7c00a834fbd6d645081b")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ah4y3j0kdzf3ygrba5bjs04fpbpc9hwrzb8bb8ql0r42vdhbng5"))))
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
    (home-page "https://github.com/wolray/symbol-overlay")
    (synopsis "Highlight symbols and perform various search operations on them")
    (description
     "This package provides functions for highlighting and navigating
between symbols.")
    (license license:gpl3+)))

(define-public emacs-coterm
  (package
    (name "emacs-coterm")
    (version "1.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/coterm-"
                           version ".tar"))
       (sha256 (base32
                "0ikfm1acdsckflv1hcy9lmssyac2099x2yybhvb6vkghcgy99p00"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-compat))
    (home-page "https://repo.or.cz/emacs-coterm.git")
    (synopsis "Terminal emulation for comint")
    (description
     "If the global `coterm-mode is enabled, proper terminal emulation will be
supported for all newly spawned comint processes.  This allows you to use more
complex console programs such as \"less\" and \"mpv\" and full-screen TUI programs
such as \"vi\", \"top\", \"htop\" or even \"emacs -nw\".  In addition to that, the
following two local minor modes may be used: `coterm-char-mode': if enabled,
most characters you type are sent directly to the subprocess, which is useful
for interacting with full-screen TUI programs. `coterm-auto-char-mode': if
enabled, coterm will enter and leave `coterm-char-mode automatically as
appropriate.  For example, if you execute \"less\" in a shell buffer, coterm will
detect that \"less\" is running and automatically enable char mode so that you can
interact with less normally.  Once you leave the \"less\" program, coterm will
disable char mode so that you can interact with your shell in the normal comint
way.  This mode is enabled by default in all coterm comint buffers.  Automatic
entrance into char mode is indicated by \"AChar\" in the modeline.  Non-automatic
entrance into char mode is indicated by \"Char\".  Automatic exit of char mode is
indicated by no text in the modeline.  Non-automatic exit of char mode is
indicated by \"Line\".  The command `coterm-char-mode-cycle is a handy command to
cycle between automatic char-mode, char-mode enabled and char-mode disabled.
Installation: To install coterm, type M-x package-install RET coterm RET It is
best to add the following elisp snippet to your Emacs init file, to enable
`coterm-mode automatically on startup: (coterm-mode) ;; Optional: bind
`coterm-char-mode-cycle to C-; in comint (with-eval-after-load comint
(define-key comint-mode-map (kbd \"C-;\") #'coterm-char-mode-cycle)) ;; If your
process repeats what you have already typed, try customizing ;;
`comint-process-echoes': ;; (setq-default comint-process-echoes t) Differences
from M-x term: coterm is written as an upgrade to comint.  For existing comint
users, the behaviour of comint doesn't change with coterm enabled except for the
added functionality that we can now use TUI programs.  It is therefore good for
users who generally prefer comint to term.el but sometimes miss the superior
terminal emulation that term.el provides.  Coterm also provides
`coterm-auto-char-mode which aims to eliminate the need to manually enable and
disable char mode.  Some common probles: If some TUI programs misbehave, try
checking your TERM environment variable with echo $TERM in your coterm enabled
M-x shell.  It should normally be set to \"coterm-color\".  If if isn't, it might
be that one of your shell initialization files (~/.bashrc) changes it, so check
for that and remove the change.  The default \"less\" prompt, when invoked as less
~/some/file', is too generic and isn't recognized by `coterm-auto-char-mode', so
char mode isn't entered automatically.  It is recommended to make your \"less\"
prompt more complete and recognizable by adding the character \"m\" or \"M\" to your
LESS environment variable.  For example, in your ~/.bashrc, add this line:
export LESS=\"FRXim\" The \"FRX\" options make \"less\" more compatible with \"git\",
and the \"i\" option enables case insensitive search in less.  See man page
less(1) for more information.  Automatic char mode detection also usually fails
if \"--incsearch\" is enabled in \"less\".  It is advised to either turn this option
off or to use manual char mode.  Bugs, suggestions and patches can be sent to
bugs-doseganje (at) groups.io and can be viewed at
https://groups.io/g/bugs-doseganje/topics.  As this package is stored in GNU
ELPA, non-trivial patches require copyright assignment to the FSF, see info node
\"(emacs) Copyright Assignment\".  Some useful information you can send in your
bug reports: After enabling `coterm-mode', open up an M-x shell and copy the
output of the following shell command: export | cat -v | grep LESS\\|TERM'; stty;
You can also set the variable `coterm--t-log-buffer to \"coterm-log\", reproduce
the issue and attach the contents of the buffer named \"coterm-log\", which now
contains all process output that was sent to coterm.")
    (license license:gpl3+)))

(define-public emacs-eat-next
  (package
    (name "emacs-eat")
    (version "0.9.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/akib/emacs-eat")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1lna10sqlxrpncjbhvljnqfcdrlrgx6r1qb1lxi57wvv6nkwbzk2"))
       (modules '((guix build utils)))
       (snippet
        #~(begin
            ;; Remove generated terminfo database.
            (delete-file-recursively "terminfo")))))
    (build-system emacs-build-system)
    (arguments
     (list
      #:tests? #t
      #:include #~(cons* "^term/"
                         "^terminfo/"
                         "^integration/"
                         "\\.ti$"
                         %default-include)
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'install 'build-info
            (lambda _
              (invoke "make" "info")))
          (add-before 'install 'build-terminfo-database
            (lambda _
              (invoke "make" "terminfo")))
          (add-before 'install 'patch-ncurses-tic-executable
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((tic (search-input-file inputs "/bin/tic")))
                (substitute* "eat.el"
                  (("\\(executable-find \"tic\"\\)")
                   (string-append "\"" tic "\"")))))))))
    (propagated-inputs (list emacs-compat))
    (native-inputs
     (list texinfo))
    (inputs
     (list ncurses))
    (home-page "https://codeberg.org/akib/emacs-eat")
    (synopsis "Terminal emulator in Emacs")
    (description
     "Eat (Emulate A Terminal) is a terminal emulator in Emacs, written in
pure Elisp.  It has features like complete mouse support and shell
integration.")
    (license license:gpl3+)))

(define-public emacs-docker-me
  (package
    (name "emacs-docker")
    (version "2.3.1.20240202")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Silex/docker.el")
             (commit "2.3.1")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13927ns3393q40gxrfzyqh6ajxzfjg14d0srfxi6ild3pmaz0460"))))
    (propagated-inputs (list emacs-aio emacs-dash emacs-s emacs-tablist emacs-transient))
    (arguments `(#:tests? #false))      ;no tests
    (build-system emacs-build-system)
    (home-page "https://github.com/Silex/docker.el")
    (synopsis "Manage docker from Emacs")
    (description "This package provides an Emacs interface for Docker.")
    (license license:gpl3+)))

(define-public emacs-denote
  (package
    (name "emacs-denote")
    (version "2.2.4.20240307")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~protesilaos/denote")
             (commit "87518c246861006fec96a017e30e15fa81421a9e")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0avn1gghsbjpw1hxddmmk5qqyna43nzhzmxg3d3vr6wp50qjbkww"))))
    (build-system emacs-build-system)
    (native-inputs (list texinfo))
    (home-page "https://protesilaos.com/emacs/denote/")
    (synopsis "Simple notes for Emacs")
    (description
     "Denote is a simple note-taking tool for Emacs.  It is based on the idea that
notes should follow a predictable and descriptive file-naming scheme.  The
file name must offer a clear indication of what the note is about, without
reference to any other metadata.  Denote basically streamlines the creation of
such files while providing facilities to link between them.")
    (license license:gpl3+)))
