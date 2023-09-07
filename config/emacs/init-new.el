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
;; disable line numbers on some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;; Bell
(setq visible-bell t)

;; Font
(set-face-attribute `default nil :font "JetBrains Mono" :height 125)
