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

