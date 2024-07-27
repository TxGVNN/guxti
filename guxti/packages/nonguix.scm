(define-module (guxti packages nonguix)
  #:use-module (guix download)
  #:use-module (guix build-system)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages compression)
  #:use-module ((guix licenses) #:prefix license:))

(define-public ghcli
  (package
    (name "ghcli")
    (version "2.53.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/cli/cli/releases/download/v"
                           version "/gh_" version "_linux_amd64.tar.gz"))
       (sha256
        (base32
         "1inhplwfrzp7x9bgnvnxiff8lyw2kcmf9jmnla9zbq1h4ybayb7d"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("bin/gh" "bin/gh")
         ("share/man" "share/man"))))
    (home-page "https://github.com/cli/cli")
    (synopsis "GitHub’s official command line tool ")
    (description
     "gh is GitHub on the command line. It brings pull requests, issues,
and other GitHub concepts to the terminal next to where
you are already working with git and your code..")
    (license license:expat)))

(define-public k8s-kubectl
  (package
    (name "k8s-kubectl")
    (version "1.27.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.k8s.io/release/v"
                           version "/bin/linux/amd64/kubectl"))
       (sha256
        (base32
         "0vbzq7axqsdim6z7hc4h7npqqvll1s49khrjms5hdyr6v5iagqvz"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("kubectl" "bin/kubectl"))
       #:phases
       (modify-phases %standard-phases
         (add-after
             'unpack 'chmod
           (lambda _ (chmod "kubectl" #o775))))))
    (home-page "https://kubernetes.io/docs/tasks/tools/install-kubectl-linux")
    (synopsis "Kubernetes cli tool")
    (description "Kubernetes cli tool")
    (license license:asl2.0)))

(define-public k8s-helm
  (package
    (name "k8s-helm")
    (version "3.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://get.helm.sh/helm-v" version "-linux-amd64.tar.gz"))
       (sha256
        (base32
         "0frc7vpx2nh4pvp8jcy8hvdhilgv48r2icmsqn77rifvsqby2dns"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("helm" "bin/helm"))))
    (home-page "https://github.com/helm/helm")
    (synopsis "The Kubernetes Package Manager")
    (description
     "Helm is a tool for managing Charts.
Charts are packages of pre-configured Kubernetes resources.")
    (license license:asl2.0)))

(define-public terraform
  (package
    (name "terraform")
    (version "1.5.7")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://releases.hashicorp.com/terraform/" version "/terraform_" version "_linux_amd64.zip"))
       (sha256
        (base32
         "0b08z9ssnzh3xgz5a7fghl262k3sib4ci0lrmxay4ap55v1ppvf0"))))
    (build-system copy-build-system)
    (native-inputs (list unzip))
    (arguments
     '(#:install-plan
       '(("terraform" "bin/terraform"))))
    (home-page "https://github.com/hashicorp/terraform")
    (synopsis "The tool to automate infrastructure on any cloud")
    (description
     "Terraform enables you to safely and predictably create, change, and improve infrastructure.")
    (license license:mpl2.0)))
