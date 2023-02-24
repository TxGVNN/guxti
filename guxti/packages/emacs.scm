(define-module (guxti packages emacs)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs))

(define (%emacs-modules build-system)
  (let ((which (build-system-name build-system)))
    `((guix build ,(symbol-append which '-build-system))
      (guix build utils)
      (srfi srfi-1)
      (ice-9 ftw))))

(define-public emacs-next-nox
  (package/inherit emacs-next
    (name "emacs-next-nox")
    (build-system gnu-build-system)
    (inputs (modify-inputs (package-inputs emacs-next)
              (delete "libx11" "gtk+" "libxft" "libtiff" "giflib" "libjpeg"
                      "imagemagick" "libpng" "librsvg" "libxpm" "libice"
                      "libsm" "cairo" "pango" "harfbuzz"
                      ;; These depend on libx11, so remove them as well.
                      "libotf" "m17n-lib" "dbus")))
    (arguments
     (substitute-keyword-arguments (package-arguments emacs-next)
       ((#:configure-flags flags #~'())
        #~(delete "--with-cairo" #$flags))
       ((#:modules _) (%emacs-modules build-system))
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'restore-emacs-pdmp)
            (delete 'strip-double-wrap)))))))
