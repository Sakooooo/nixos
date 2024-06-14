;; -*- lexical-binding: t; -*-

(use-package general
  :config
  (general-create-definer sk/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (sk/leader-keys
   ;; code
   "c" '(:ignore c :which-key "code")
   "cc" '(compile :which-key "compile")
   "cC" '(recompile :which-key "compile")
   "cX" '(lsp-treeemacs-errors-list :which-ley "list errors")
   ;; toggles
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")
   "ts" '(hydra-text-scale/body :which-key "scale text")
   ;; search
   "s" '(:ignore s :which-key "search")
   "sb" '(swiper :which-key "search buffer")
   ;; insert
   "i" '(:ignore i :which-key "insert")
   "ie" '(emoji-search :which-key "Emoji")
   ;; project
   "p" '(:ignore p :which-key "projects")
   "pp" '(project-switch-project :which-key "open project")
   "pk" '(project-kill-buffers :which-key "close project")
   "pt" '(magit-todos-list :which-key "list project todos")
   "ps" '(projectile-save-project-buffers :which-key "save project")
   "po" '(projectile-find-other-file :which-key "find other file")
   "pg" '(projectile-configure-project :which-key "configure project")
   "pc" '(project-compile :which-key "compile project")
   ;; open
   "o" '(:ignore o :which-key "open")
   "op" '(treemacs :which-key "treemacs")
   "oP" '(treemacs-find-file :which-key "treemacs find file")
   "oe" '(eshell :which-key "eshell")
   "or" '(elfeed :which-key "rss")
   ;; notes
   "n" '(:ignore o :which-key "notes")
   "na" '(org-agenda :which-key "agenda")
   "nf" '(org-roam-node-find :which-key "find node")
   "nc" '(org-capture :which-key "capture")
   "np" '(org-pomodoro :which-key "pomodoro")
   "ne" '(:ignore ne :which-key "export")
   "nep" '(org-latex-export-to-pdf :which-key "pdf")
   ;; quit
   "q" '(:ignore q :which-key "quit")
   "qq" '(delete-frame :which-key "close emacs")
   "qK" '(kill-emacs :which-key "quit emacs")
   ;; git
   "g" '(:ignore g :which-key "git")
   "gs" '(magit-status :which-key "status")
   "gc" '(:ignore gc :which-key "create")
   "gcr" '(magit-init :which-key "init repo")
   "gcR" '(magit-clone :which-key "clone repo")
   "gcc" '(magit-commit-create :which-key "commit")
   "gci" '(forge-create-issue :which-key "issue")
   "gcp" '(forge-create-pullreq :which-key "pull request"))) 

(provide 'sk-keys-general)
