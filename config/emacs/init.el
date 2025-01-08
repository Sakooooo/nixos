;;; init.el --- Sako's terrible eMacs config -*- lexical-binding: t; -*-
;;; Commentary:
;; Lots of things missing but its whats needed
;; TODO(sako):: Setup mu4e
;; TODO(sako):: Setup irc (erc/rcirc)
;; TODO(sako):: Setup elfeed
;; TODO(sako):: Setup elcord

;;; Code:

;; --- Display Options ---
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 0)
(setq visible-bell nil)
(setq inhibit-startup-message t)

(repeat-mode 1)
(column-number-mode)

(setq display-line-numbers-type 'relative)

(dolist (mode '(text-mode-hook
		prog-mode-hook
		conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

(set-face-attribute 'default nil
		    :font "JetBrainsMono NF"
		    :weight 'light
		    :height 120)

(setq frame-resize-pixelwise t)

(setq global-auto-revert-non-file-buffers t)

(global-auto-revert-mode 1)

(add-to-list 'default-frame-alist '(font . "JetBrainsMono NF"))
(set-frame-font "JetBrainsMono NF" nil t)

(fset 'yes-or-no-p 'y-or-n-p)

;; --- Extra options ---
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      delete-old-versions t
      kept-new-versions 20
      kept-old-version 5)

(setq native-comp-async-report-warnings-errors nil)
(add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;; --- Package Setup ---
(require `package)

(setq package-archives `(("mepla" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(setq use-package-always-ensure t)

(package-initialize)
(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

;; --- Theme ---
;; (use-package cherry-blossom-theme
;;   :ensure t
;;   :config
;;   (load-theme 'cherry-blossom t))

(use-package kanagawa-themes
  :ensure t
  :config
  (load-theme 'kanagawa-dragon t))

;; --- no-littering ---

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t  
      kept-new-versions 20 
      kept-old-versions 5)

(use-package no-littering
  :config
  (setq custom-file (if (boundp 'server-socket-dir)
                        (expand-file-name "custom.el" server-socket-dir)
                      (no-littering-expand-etc-file-name "custom.el")))
  (when (file-exists-p custom-file)
    (load custom-file t))

  ;; Don't litter project folders with backup files
  (let ((backup-dir (no-littering-expand-var-file-name "backup/")))
    (make-directory backup-dir t)
    (setq backup-directory-alist
          `(("\\`/tmp/" . nil)
            ("\\`/dev/shm/" . nil)
            ("." . ,backup-dir))))

  (setq auto-save-default nil)

  ;; Tidy up auto-save files
  (setq auto-save-default nil)
  (let ((auto-save-dir (no-littering-expand-var-file-name "auto-save/")))
    (make-directory auto-save-dir t)
    (setq auto-save-file-name-transforms
          `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
             ,(concat temporary-file-directory "\\2") t)
            ("\\`\\(/tmp\\|/dev/shm\\)\\([^/]*/\\)*\\(.*\\)\\'" "\\3")
            ("." ,auto-save-dir t)))))

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; --- Keybinds ---
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; --- helpful ---
(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind (([remap describe-function] . helpful-function)
         ([remap describe-symbol] . helpful-symbol)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-command] . helpful-command)
         ([remap describe-key] . helpful-key)))

;; --- Startup Dashboard ---
(use-package enlight
  :ensure t
  :custom
  (enlight-content
   (concat
    (propertize "MENU" 'face 'highlight)
    "\n"
    (enlight-menu
     '(("Org Mode"
	("Org-Agenda (current day)" (org-agenda nil "a") "a"))
       ("Other"
	("Projects" project-switch-project "p"))))))
  :config
  (setopt initial-buffer-choice #'enlight))

;; --- Completition ---
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (require 'vertico-directory)
  (vertico-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))

(use-package consult
  :after vertico
  :ensure t
  :bind (("C-s" . consult-line)
	 ("C-M-j" . consult-buffer)
	 ("C-x C-b" . consult-buffer)))

(use-package orderless
  :ensure t
  :config
  (orderless-define-completion-style orderless+initialism
    (orderless-matching-styles '(orderless-initialism
                                 orderless-literal
                                 orderless-regexp)))

  (setq completion-styles '(orderless)
        completion-category-defaults nil
        orderless-matching-styles '(orderless-literal orderless-regexp)
        completion-category-overrides
        '((file (styles partial-completion)))))

(use-package corfu
  :ensure t
  :bind (:map corfu-map
	      ("TAB" . corfu-insert)
	      ([tab] . corfu-insert)
	      ("RET" . nil))
  :config
  (setq corfu-cycle t
	corfu-quit-at-boundary t
	corfu-auto t
	corfu-quit-no-match t
	corfu-popupinfo-delay '(1.0 . 0.5))
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu)


;; --- Pinentry ---
(unless (eq system-type 'windows-nt)
  (use-package pinentry
    :config
    (setq epa-pinentry-mode 'loopback)
    (pinentry-start)))

;; --- Passwords ---
(use-package password-store
  :ensure t
  :bind (("C-c p p" . password-store-copy)
	 ("C-c p i" . password-store-insert)
	 ("C-c p g" . password-store-generate)))
(auth-source-pass-enable)

;; --- Terminal ---
(use-package vterm
  :ensure t
  :bind ("<f1>" . vterm)
  :config
  (setq vterm-max-scrollback 10000))

;; --- Parens ---
(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode)
  :config
  (sp-use-smartparens-bindings))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; --- M-x compile ---
(setq compilation-scroll-output t)

(setq compilation-environment '("TERM=xterm-256color"))

(defun sk/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))

(advice-add 'compilation-filter :around #'sk/advice-compilation-filter)

(defun sk/auto-recompile-buffer ()
  (interactive)
  (if (member #'recompile after-save-hook)
      (remove-hook 'after-save-hook #'recompile t)
    (add-hook 'after-save-hook #'recompile nil t)))

;; --- project.el ---
(setq project-switch-commands '((project-find-file "Find file" "f")
				(project-find-dir "Find dir" "d")
				(project-dired "Dired" "D")
				(consult-ripgrep "ripgrep" "g")
				(magit-project-status "Magit" "m")))

;; --- magit ---
(use-package magit
  :ensure t
  :custom
  (magit-show-long-lines-warning nil)
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; --- flycheck ---
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode +1))

;; --- direnv ---
(when (eq system-type 'gnu/linux)
  (use-package envrc
    :ensure t
    :hook (after-init . envrc-global-mode)))

;; --- editorconfig ---
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; --- wakatime ---
(use-package wakatime-mode
  :ensure t
  :config
  (global-wakatime-mode))

;; --- formatting ---
(use-package apheleia
  :ensure t
  :hook (prog-mode . apheleia-mode))

;; --- LSP ---
(use-package eglot
  :ensure t
  :bind (:map eglot-mode-map
	      ("C-c C-a" . eglot-code-actions)
	      ("C-c C-r" . eglot-rename))

  :config
  (setq eglot-autoshutdown t
	eglot-confirm-server-initiated-edits nil))

;; --- LSP Booster ---
(when (eq system-type 'gnu/linux)
  (use-package eglot-booster
    :ensure nil
    :config (eglot-booster-mode)))

;;; --- Languages ---

;; nix
(use-package nix-mode
  :hook (nix-mode . eglot-ensure)
  :mode "\\.nix\\'")

;; python
(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . eglot-ensure))

(use-package elpy
  :after python-mode

  :custom
  (elpy-rpc-python-command "python3")

  :config
  (elpy-enable))

(use-package poetry
  :config
  (poetry-tracking-mode 1))

;; c/cpp
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; cmake
(use-package cmake-mode
  :mode "CMakeLists.txt"
  :hook (cmake-mode . eglot-ensure))

;; astro
(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
	      auto-mode-alist))

(add-to-list 'eglot-server-programs
             '(astro-mode . ("astro-ls" "--stdio"
                             :initializationOptions
                             (:typescript (:tsdk "./node_modules/typescript/lib")))))

;; typescript
(add-to-list 'auto-mode-alist '(".*\\.ts" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '(".*\\.tsx" . tsx-ts-mode))

(add-hook 'typescript-ts-mode-hook 'eglot-ensure) 
(add-hook 'tsx-ts-mode-hook 'eglot-ensure) 

(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src" nil nil)
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src" nil nil)))

;; html/css
(use-package web-mode
  :hook (web-mode . eglot-ensure)
  :mode ("\\.html\\'"
         "\\.css\\'"))

;; rust
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save nil)
  (setq rustic-lsp-client 'eglot)
  :custom
  (rustic-cargo-use-last-stored-arguments t))

;; go
(use-package go-mode
  :ensure t
  :hook (go-mode . eglot-ensure)
  :mode ("\\.go\\'"))

;; lua
(use-package lua-mode
  :ensure t
  :hook (lua-mode . eglot-ensure)
  :mode ("\\.lua\\'"))

(use-package moonscript
  :ensure t
  :hook (moonscript-mode . eglot-ensure)
  :mode ("\\.moon\\'"))

;; --- Org-Mode ---
(use-package org
  :ensure t
  :bind (("C-c o a" . org-agenda))
  :hook (org-mode . org-indent-mode)
  :config
  ;; replace ... with >
  (setq org-ellipsis " >")
  (setq org-startup-with-inline-images t)
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANCELED(k@)")))

  ;; --- Org Agenda ---
  (setq org-agenda-files
	'("~/org/tasks.org"
          "~/org/school.org"
          "~/org/daily.org"
          "~/org/irl.org"
          "~/org/work.org"))

  (setq org-agenda-custom-commands
	`(("s" "School" tags-todo "+school")))

  ;; --- org2pdf ---
  (setq org-latex-compiler "lualatex")
  (setq org-preview-latex-default-process 'dvisvgm))

;; --- Org-Roam ---
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org/notes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

;; --- Org Extras ---
(use-package org-wild-notifier
  :ensure t
  :config
  (setq alert-default-style 'libnotifiy)
  (setq org-wild-notifier-alert-time 30)
  (org-wild-notifier-mode))

(use-package org-pomodoro
  :ensure t)

;; --- Social ---

;; elcord
(use-package elcord
  :init
  (setq elcord-display-buffer-details nil)
  (setq elcord-use-major-mode-as-main-icon t)
  (setq elcord-quiet t)
  (setq elcord-display-elapsed nil)
  :config
  (defun elcord--disable-elcord-if-no-frames (f)
    (ignore f)
    (when (let ((frames (delete f (visible-frame-list))))
  	    (or (null frames)
                (elcord-mode -1)))))

  (defun elcord--enable-on-frame-created (f)
    (elcord-mode +1))

  (add-hook 'after-make-frame-functions 'elcord--enable-on-frame-created)

  (defun sakomacs/elcord-mode-hook ()
    (if elcord-mode
        (add-hook 'delete-frame-functions 'elcord--disable-elcord-if-no-frames)
      (remove-hook 'delete-frame-functions 'elcord--disable-elcord-if-no-frames)))
  (elcord-mode)
  (add-hook 'elcord-mode-hook 'sakomacs/elcord-mode-hook))
;;; init.el ends here
