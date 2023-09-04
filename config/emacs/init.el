(setq inhibit-startup-message t)

;; go away bars, you look ugly
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

;; packages
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

(use-package command-log-buffer)
