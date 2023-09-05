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
  (general-create-definer sakomacs/leader-keys
    :keymaps `(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (sakomacs/leader-keys
    "t" `(:ignore t :which-key "toggles")
    "tt" `(counsel-load-theme :which-key "choose theme")))

;; EVIL !!!! ITS EVIL I TELL YOU !!!!!!!!!!!!
;; vim like because nothing beats vim keybindings
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :hook (evil-mode . sakomacs/evil-hook)
  :config
  (evil mode 1)
  (define-key evil-insert-state-map (kbd "C-g") `evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") `evil-delete-backward-char-and-join)
  ;; visual line motion thingy idk
  (evil-global-set-key `motion "j" `evil-next-visual-line)
  (evil-global-set-key `motion "k" `evil-delete-backward-char-and-join)

  (evil-set-initial-state `messages-buffer-mode `normal)
  (evil-set-initial-state `dashboard-mode `normal))

;; list thing with function
;; idk i dont know lisp im actually sane
;; most of these are copy pasted so i dont know what they do
(defun sakomacs/evil-hook ()
  (dolist (mode `(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list `evil-emacs-state-modes mode)))


;; video
;; https://youtu.be/IspAZtNTslY?t=3070
