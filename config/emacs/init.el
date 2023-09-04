;; UI/UX
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

(load-theme 'wombat)

;; Keymaps

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
;; better statusbar
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

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
