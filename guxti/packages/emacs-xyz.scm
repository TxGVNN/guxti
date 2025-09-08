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
  #:use-module (gnu packages curl)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages screen)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-build)
  #:use-module (gnu packages emacs-xyz))

(define-public emacs-crux
  (package
    (name "emacs-crux")
    (version "0.5.0.20240808")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/bbatsov/crux")
              (commit "6ed75a6")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "09lybi0bld14bdfvbji5cxrwrwflcvfnkdk618yybv1zphxmj2nx"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-crux.patch")))))
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
    (home-page "https://github.com/bbatsov/crux")
    (synopsis "Collection of useful functions for Emacs")
    (description
     "@code{crux} provides a collection of useful functions for Emacs.")
    (license license:gpl3+)))

(define-public emacs-perspective-me
  (package
    (name "emacs-perspective")
    (version "2.19.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/nex3/perspective-el")
              (commit "2.19")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1vpjc9mk96siabl5j0k023bag00cwb852cpc9f89jyqhavm6011b"))
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
                  (string-append ";; Version: " ,version "\n"))))))
         #:tests? #false))
      (home-page "https://github.com/redguardtoo/elpa-mirror")
      (synopsis "Create local emacs package repository.")
      (description
       "This program will create a local package repository by from all
installed packages.")
      (license license:gpl3+))))

(define-public emacs-embark-me
  (let ((commit "1.1")) ;version bump
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
          (base32 "1361jvwr3wjbpmq6dfkrhhhv9vrmqpkp1j18syp311g6h8hzi3hg"))
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
  (let ((commit "1.1")) ;version bump
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
          (base32 "1361jvwr3wjbpmq6dfkrhhhv9vrmqpkp1j18syp311g6h8hzi3hg"))
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
    (version "0.14.3-1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/joaotavora/yasnippet")
              (commit "c1e6ff2")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08kmhncvgprha73654p969rr72rhp0d1bn4jj56vpmg6hnw1jy0r"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "emacs-yasnippet-fix-empty-snippet-next.patch"
                          "emacs-yasnippet-lighter.patch")))))
    (build-system emacs-build-system)
    (arguments
     `(#:tests? #false
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
  (let ((commit "13dec7de")
        (hash "0psjdrqhwwk42k3jfjffrgnpa2dq8nznb8xfh4v4jbw0wqlq6vlm"))
    (package
      (name "emacs-yasnippet-snippets")
      (version "1.1.20240724")
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
  (let ((commit "926e97dc5b8b2caadbdfa2e791397f14fa459574")
        (hash "1zgnn3jrvadfvg5sldphkjkdca8h6m6y5g6q36syl6gv9i5jgv8r"))
    (package
      (name "emacs-project-tasks")
      (version "0.7.1")
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
      #:tests? #false
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
    (version "0.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/TxGVNN/ob-compile.git")
                     (commit version)))
              (sha256 (base32
                       "1l3hifa88jvzr75rz4cc5q0w8y60qnw7jin6x3fcam8915a1nd2f"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/TxGVNN/ob-compile")
    (synopsis "Run compile by org-babel")
    (description "Run compile in org-mode.")
    (license license:gpl3+)))

(define-public emacs-isearch-mb
  (package
    (name "emacs-isearch-mb")
    (version "0.8")
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
          (url "https://github.com/astoff/isearch-mb")
          (commit "927ea1790bd0c474be5f63bd9c23874e6c61fb48")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1j53hgi635kmpdf6y9iaz7pnfnfkhvqvpzxdp00xmxvx3qrrk414"))))
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
                (string-append ";; Version: " ,version "\n"))))))
       #:tests? #false))
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
    (arguments
     (list
      #:tests? #false))
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
    (arguments
     (list
      #:tests? #false))
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
    (arguments
     (list
      #:tests? #false))
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

(define-public emacs-docker-me
  (package
    (name "emacs-docker")
    (version "2.3.1.20240917")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/Silex/docker.el")
              (commit "6f8bba0")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00bc768jknzym99k56jhbrj1hyzj7yygi513vw2wz89vq2axjdkg"))))
    (propagated-inputs (list emacs-aio emacs-s emacs-tablist emacs-transient emacs-dash))
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
