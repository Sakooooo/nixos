;; -*- lexical-binding: t; -*-

;; -- paren matching and other horrors of mankind

(use-package smartparens 
  :hook (prog-mode . smartparens-mode)
  :config
  (sp-use-smartparens-bindings))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; -- the compile command --
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

;; -- project.el --
(setq project-switch-commands '((project-find-file "Find file" "f") (project-find-dir "Find dir" "d") (project-dired "Dired" "D") (consult-ripgrep "ripgrep" "g") (magit-project-status "Magit" "m")))
;; -- elgot (lsp thing) --
(use-package eglot
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-r" . eglot-rename))
  :config
  (setq eglot-autoshutdown t
        eglot-confirm-server-initiated-edits nil))

;; this'll make it so i don't have to use vscode every now and then
;; TODO:: WRITE NIX PACKAGE!!!!!!!!!!!!!!
(unless (eq system-type 'gnu/linux)
  (use-package eglot-booster
    :straight (eglot-booster :type git :host github :repo "jdtsmith/eglot-booster")
    :after eglot
    :config (eglot-booster-mode))
  )

;; -- Magit --
(use-package magit
  :bind ("C-M-;" . magit-status-here)
  :custom
  (magit-show-long-lines-warning nil)
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package magit-todos
  :after magit
  :config
  (magit-todos-mode))

;; -- magit forge --
(use-package forge
  :after magit)
(setq auth-sources '("~/.authinfo"))

(defhydra sk/smerge-panel ()
  "smerge"
  ("k" (smerge-prev) "prev change" )
  ("j" (smerge-next) "next change")
  ("u" (smerge-keep-upper) "keep upper")
  ("l" (smerge-keep-lower) "keep lower")
  ("q" nil "quit" :exit t))

;; -- formatting --
(use-package apheleia
  :hook (prog-mode . apheleia-mode))

;; -- autocompletition --
(use-package company
  :after eglot
  :hook (eglot . company-mode)
  :bind (:map company-active-map
		("<tab>" . company-complete-selection))
  (:map eglot-mode-map
          ("<tab>" . company-indent-or-complete-common))
  :custom
    (company-minimum-prefix-length 1)
    (company-idle-delay 0)
    (company-selection-wrap-around t)
    (company-tooltip-align-annotations t))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; -- syntax checking
(use-package flycheck
  :config
  (global-flycheck-mode +1))

(provide 'sk-dev)
