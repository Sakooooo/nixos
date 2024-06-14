;; -*- lexical-binding: t; -*-

;; -- evil mode configuration --

(use-package evil
  :init
  ;; Pre-load configuration
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)

   ;; use emacs state for these mods
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode))

   (defun sk/dont-arrow-me-bro ()
      (interactive)
      (message "STOP USING THE ARROW KEYS!!!!!!!!!!!!!!!!!!!!!!!"))

    ;; Disable arrow keys in normal and visual modes
    (define-key evil-normal-state-map (kbd "<left>") 'sk/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<right>") 'sk/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<down>") 'sk/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<up>") 'sk/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<left>") 'sk/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<right>") 'sk/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<down>") 'sk/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<up>") 'sk/dont-arrow-me-bro)

   (evil-set-initial-state 'messages-buffer-mode 'normal) 
   (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  ;; Is this a bug in evil-collection?
  (setq evil-collection-company-use-tng nil)
  (delete 'lispy evil-collection-mode-list)
  (delete 'org-present evil-collection-mode-list)
  (evil-collection-init))

(use-package evil-org
  :after (evil org)
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-set-key-theme '(navigation todo insert textobjects additional))
  (evil-org-agenda-set-keys))

(use-package evil-nerd-commenter
:bind ("M-/" . evilnc-comment-or-uncomment-lines))

(with-eval-after-load 'org
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup))

(provide 'sk-keys-evil)



