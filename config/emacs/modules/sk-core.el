;; -*- lexical-binding: t; -*-

(message "Reached core")

;; -- encoding --
(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8) ; For old Carbon emacs on OS X only
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system
  (if (eq system-type 'windows-nt)
      'utf-16-le  ;; https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows
    'utf-8))
(prefer-coding-system 'utf-8)

;; -- cleaning up .emacs.d --
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

;; -- native compiliation --

;; oh my god SHUT UP
(setq native-comp-async-report-warnings-errors nil)

;; make native compilation cache go to the user directory instead like NORMAL
(add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;; -- emacs settings --
(setq inhibit-startup-message t)

;; make emacs look a little more cleaner
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; this is really annoying i hate it
(setq visible-bell nil)

;; -- core keybinds and packages --
(repeat-mode 1)

(column-number-mode)

(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; -- appearance --
;; TODO: change this for something better i guess
(use-package doom-themes
  :config
  (load-theme 'doom-monokai-pro t))

;; emacsclient things
(setq frame-resize-pixelwise t)
;; ui settings apparently go below
(setq default-frame-alist '((font . "JetBrainsMono NF")
                            '(vertical-scroll-bars . nil)
                            '(horizontal-scroll-bars . nil)))

;; GO AWAY
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)


;; y/n is better than yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; font
(set-face-attribute 'default nil
		    :font "JetBrainsMono NF"
		    :weight 'light
		    :height 125)

;; -- modeline --
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "JetBrainsMono NF"))
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; -- editor configuration --
(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

;; revert dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; revert buffers when file has been changed
(global-auto-revert-mode 1)

;; popups and stuff
(use-package popper
  :bind (("C-M-'" . popper-toggle)
         ("M-'" . popper-cycle)
         ("C-M-\"" . popper-toggle-type))
  :custom
  (popper-window-height 12)
  (popper-reference-buffers '(eshell-mode
                              vterm-mode
                              geiser-repl-mode
                              help-mode
                              grep-mode
                              helpful-mode
                              compilation-mode))
  :config
  (popper-mode 1))

;; -- helpful help --
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind (([remap describe-function] . helpful-function)
         ([remap describe-symbol] . helpful-symbol)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-command] . helpful-command)
         ([remap describe-key] . helpful-key)))

;; -- which key --
;; incase i get lost
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; -- alerts --
;; quick and dirty fix for windows alert.el
(when (eq system-type 'windows-nt)
  (use-package alert
    :commands (alert)
    :config (setq alert-default-style 'toast))
  
  (use-package alert-toast
    :after alert))

;; -- daemon
(if (eq system-type 'windows-nt)
    (setq server-socket-dir "~/.emacs.d/server"))
(server-start)


(provide 'sk-core)
