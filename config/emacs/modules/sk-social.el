;; -*- lexical-binding: t; -*-

;; discord rpc
(use-package elcord
  :init
  (setq elcord-display-buffer-details nil)
  (setq elcord-use-major-mode-as-main-icon t)
  )

;; telegram
(unless (eq system-type 'windows-nt)
  (use-package telega))

;; TODO:: Make nix package for this
;; send files and images and other shit over IRC!!!!
(unless (eq system-type 'gnu/linux)
  (use-package 0x0
    :straight (0x0 :type git :host sourcehut :repo "willvaughn/emacs-0x0")))

;; -- irc --
;; ill get to configuring this later
(use-package rcirc)

;; -- rss --
;; ill also get to configuring this later
;; reminder, use elfeed protocol ok tysm thanks
(use-package elfeed)

;; -- matrix --
;; todo setup this later
(use-package ement)


(provide 'sk-social)
