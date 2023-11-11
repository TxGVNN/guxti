(define-module (guxti packages suckless)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages suckless)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))


(define-public xst
  (package
    (inherit st)
    (name "xst")
    (version "0.8.4.1-2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gnotclub/xst")
             (commit (string-append "v" "0.8.4.1"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1q64x7czpbcg0v509qchn5v96zdnx7jmvy0zxhjmkk3d10x5rqlw"))
       (patches
        (parameterize
            ((%patch-path
              (map (lambda (directory)
                     (string-append directory "/guxti/packages/patches"))
                   %load-path)))
          (search-patches "st.patch")))))
    (home-page "https://github.com/gnotclub/xst")
    (synopsis "Fork of st that uses Xresources")
    (description
     "@command{xst} uses Xresources and applies the following patches to
@command{st}:
@itemize
@item @uref{https://st.suckless.org/patches/alpha/, alpha}
@item @uref{https://st.suckless.org/patches/boxdraw/, boxdraw}
@item @uref{https://st.suckless.org/patches/clipboard/, clipboard}
@item @uref{https://st.suckless.org/patches/disable_bold_italic_fonts/, disable_bold_italic_fonts}
@item @uref{https://st.suckless.org/patches/externalpipe/, externalpipe}
@item @uref{https://st.suckless.org/patches/scrollback/, scrollback}
@item @uref{https://st.suckless.org/patches/spoiler/, spoiler}
@item @uref{https://st.suckless.org/patches/vertcenter/, vertcenter}
@end itemize")
    (license license:expat)))
