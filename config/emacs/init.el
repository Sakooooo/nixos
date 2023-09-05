;; Ui/UX
(setq inhibit-startup-message t)

;; make it look like neovim a little
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

;; Line Numbers
(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Bell
(setq visible-bell t)

;; Font
(set-face-attribute `default nil :font "JetBrainsMono NF" :height 150)

;; Keymaps
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Package related stuqff
(require `package)

(setq package-archives `(("mepla" . "https://melpa.org/packages/")
			 ("org" . "https://orgemode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Init package for non-linux
(unless (package-installed-p `use-package)
  (package-install `use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; for showing commands
(use-package command-log-mode)

;; better search
(use-package swiper)
;; better commands
(use-package counsel)
;; autocompletion on commands (?)
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :demand
  :config
  (ivy-mode 1))
;; better ivy autocompletion
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; counsel M+X
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-inital-inputs-alist nil))

;; doom themes

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; load the theme
  (load-theme 'doom-monokai-pro t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config))
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  ;;(doom-themes-org-config))

;; better statusbar
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 35)))

;; all the icons
(use-package all-the-icons)

;; continue configuring from here
;; https://youtu.be/74zOY-vgkyw?t=3125

;; rainbow delimiters for lisp (TODO find this for javascript, c++ etc)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; which-key because i dont know what emacs is
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))

;; better help menu
(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function ] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; general emacs
(use-package general
  :config
  ;:(general-evil-setup t)
  (general-create-definer rune/leader-keys
			  :keymaps
			  :prefix "SPC"
			  :global-prefix "C-SPC"))


;; video
;; https://youtu.be/IspAZtNTslY?t=3070
