(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

;; bell
(setq visible-bell t)

;; font
(set-face-attribute `default nil :font "JetBrains Mono" :height 150)

(load-theme 'tango-dark)