(define-module (guxti packages emacs)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages emacs))

;; https://lists.gnu.org/archive/html/guix-devel/2022-12/msg00073.html
(define (emacs-tree-sitter-grammar org lang version commit hash
                                   synopsis)
  (let ((name
         (string-append "emacs-tree-sitter-grammar-" lang))
        (home-page
         (string-append "https://github.com/" org "/tree-sitter-"
                        lang))
        (src-dir (if (equal? "typescript" lang) "tsx/" ""))
        (lib (format #f "libtree-sitter-~a.so"
                     (if (equal? "typescript" lang) "tsx" lang))))
    (package
      (name name)
      (version version)
      (home-page home-page)
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url home-page)
                      (commit commit)))
                (file-name (git-file-name name version))
                ;; Patch includes two files necessary to build each grammar
                ;; in emacs-with-tree-sitter loadable way. Files are
                ;; emacs-module.h and tree-sitter-lang.in,                originated
                ;; from https://github.com/casouri/tree-sitter-module.
                (patches (list (local-file
                                "patches/emacs-tree-sitter-module.patch")))
                (modules '((guix build utils)))
                (snippet
                 #~(begin
                     (copy-file (string-append #$src-dir
                                               "grammar.js")
                                (string-append #$src-dir
                                               "src/grammar.js"))
                     (for-each
                      (lambda (f) (rename-file f (string-append
                                                  #$src-dir f)))
                      '("src/emacs-module.h"
                        "src/tree-sitter-lang.in"))))
                (sha256 (base32 hash))))
      (build-system gnu-build-system)
      (arguments
       (list
        ;; Phases below and snippet above mimics actions from:
        ;; https://github.com/casouri/tree-sitter-module/blob/master/build.sh
        #:phases
        #~(modify-phases %standard-phases
            (delete 'configure)
            (replace 'build
              (lambda _
                (with-directory-excursion (string-append #$src-dir
                                                         "src")
                  (let* ((scanner? (or (file-exists? "scanner.c")
                                       (file-exists?
                                        "scanner.cc")))
                         (CC (if (file-exists? "scanner.cc") "g++"
                                 "gcc"))
                         (compile (lambda (f) (invoke CC "-fPIC"
                                                      "-c" "-I." f)))
                         (link-args `("-fPIC" "-shared" "parser.o"
                                      ,@(if scanner?
                                            '("scanner.o") '())
                                      "-o" ,#$lib)))
                    (invoke "gcc" "-fPIC" "-c" "-I." "parser.c")
                    (for-each
                     (lambda (f) (when (file-exists? f) (compile
                                                         f)))
                     '("scanner.c" "scanner.cc"))
                    (apply invoke CC link-args)))))
            (delete 'check)
            (replace 'install
              (lambda _
                (install-file (string-append #$src-dir "src/"
                                             #$lib)
                              (string-append #$output
                                             "/lib")))))))
      (synopsis synopsis)
      (description (string-append synopsis "."))
      (license license:expat))))

(define-public emacs-tree-sitter-grammar-bash
  (emacs-tree-sitter-grammar
   "tree-sitter" "bash" "0.19.0" "b6667be"
   "18c030bb65r50i6z37iy7jb9z9i8i36y7b08dbc9bchdifqsijs5"
   "Bash grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-c
  (emacs-tree-sitter-grammar
   "tree-sitter" "c" "0.20.2" "5aa0bbb"
   "1w03r4l773ki4iq2xxsc2pqxf3pjsbybq3xq4glmnsihgylibn8v"
   "C grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-cpp
  (emacs-tree-sitter-grammar
   "tree-sitter" "cpp" "0.20.0" "05cf203"
   "0hxcpdvyyig8njga1mxp4qcnbbnr1d0aiy27vahijwbh98b081nr"
   "C++ grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-css
  (emacs-tree-sitter-grammar
   "tree-sitter" "css" "0.19.0" "9668e88"
   "014jrlgi7zfza9g38hsr4vlbi8964i5p7iglaih6qmzaiml7bja2"
   "CSS grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-c-sharp
  (emacs-tree-sitter-grammar
   "tree-sitter" "c-sharp" "0.20.0" "70fd2cb"
   "0lijbi5q49g50ji00p2lb45rvd76h07sif3xjl9b31yyxwillr6l"
   "C# grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-elixir
  (emacs-tree-sitter-grammar
   "elixir-lang" "elixir" "b11cec3"
   "0ba537df8692179f34cccc7efed05de6cf5178aa"
   "1k35nfwnz8zjiw2mg8d6nphxp3gb7yhb0a5vw4cz2h3n10yyq75i"
   "Elixir grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-go
  (emacs-tree-sitter-grammar
   "tree-sitter" "go" "0.19.1" "e41dd56"
   "0nxs47vd2fc2fr0qlxq496y852rwg39flhg334s7dlyq7d3lcx4x"
   "Go grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-html
  (emacs-tree-sitter-grammar
   "tree-sitter" "html" "0.19.0" "d93af48"
   "1hg7vbcy7bir6b8x11v0a4x0glvqnsqc3i2ixiarbxmycbgl3axy"
   "HTML grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-java
  (emacs-tree-sitter-grammar
   "tree-sitter" "java" "0.20.0" "ac14b4b"
   "1i9zfgqibinz3rkx6yws1wk49iys32x901dki65qihbxcmcfh341"
   "Java grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-javascript
  (emacs-tree-sitter-grammar
   "tree-sitter" "javascript" "0.20.0" "fdeb68a"
   "175yrk382n2di0c2xn4gpv8y4n83x1lg4hqn04vabf0yqynlkq67"
   "JavaScript grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-json
  (emacs-tree-sitter-grammar
   "tree-sitter" "json" "0.19.0" "8960792"
   "06pjh31bv9ja9hlnykk257a6zh8bsxg2fqa54al7qk1r4n9ksnff"
   "JSON grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-python
  (emacs-tree-sitter-grammar
   "tree-sitter" "python" "0.20.0" "2b9e9e0"
   "14nnnblbjxyri8x21kj59agiy3cn4fwfrab3dmidykdyq2r46f5w"
   "Python grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-rust
  (emacs-tree-sitter-grammar
   "tree-sitter" "rust" "0.20.3" "0431a2c"
   "149jhy01mqvavwa8jlxb8bnn7sxpfq2x1w35si6zn60b7kqjlx8f"
   "Rust grammar for tree-sitter in Emacs"))

(define-public emacs-tree-sitter-grammar-typescript
  (emacs-tree-sitter-grammar
   "tree-sitter" "typescript" "0.20.1" "5d20856"
   "07fl9d968lal0aqj4f0n16p3n94cjkgfp54wynfr8gbdkjss5v5x"
   "TypeScript/TSX grammar for tree-sitter in Emacs"))

(define-public emacs-next-tree-sitter
  (let ((commit "be67cc276a95a97a329fa633fef686ba06c8e6d2")
        (revision "3"))
    (package
      (inherit emacs-next)
      (name "emacs-next-tree-sitter")
      (version (git-version "30.0.50" revision commit))
      (source
       (origin
         (inherit (package-source emacs-next))
         (method git-fetch)
         (uri (git-reference
               (url "https://git.savannah.gnu.org/git/emacs.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0daczbivmp1v8dzp98pn8d93m9np38avs0xyyvhd48b8ly71daia"))))
      (arguments
       (substitute-keyword-arguments (package-arguments
                                      emacs-next)
         ((#:configure-flags flags #~'())
          #~(cons* "--with-tree-sitter" #$flags))))
      (inputs
       (modify-inputs
           (package-inputs emacs-next)
         (prepend tree-sitter))))))

(define-public emacs-next-pgtk-tree-sitter
  (let ((commit "be67cc276a95a97a329fa633fef686ba06c8e6d2")
        (revision "3"))
    (package
      (inherit emacs-next-pgtk)
      (name "emacs-next-pgtk-tree-sitter")
      (version (git-version "30.0.50" revision commit))
      (source
       (origin
         (inherit (package-source emacs-next))
         (method git-fetch)
         (uri (git-reference
               (url "https://git.savannah.gnu.org/git/emacs.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0daczbivmp1v8dzp98pn8d93m9np38avs0xyyvhd48b8ly71daia"))))
      (arguments
       (substitute-keyword-arguments (package-arguments
                                      emacs-next-pgtk)
         ((#:configure-flags flags #~'())
          #~(cons* "--with-tree-sitter" #$flags))))
      (inputs
       (modify-inputs
           (package-inputs emacs-next-pgtk)
         (prepend tree-sitter))))))
