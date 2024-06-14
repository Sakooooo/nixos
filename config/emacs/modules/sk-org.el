;; -*- lexical-binding: t; -*-

;; -- org mode config --
(use-package org
  :hook (org-mode . org-indent-mode)
  :config
  (setq org-ellipsis " ↓")
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  ;; habits, useless for now though
  ;; (require 'org-habit)
  ;; (add-to-list 'org-modules 'org-habit)
  ;; (setq org-habit-graph-column 60)

  ;; archive
  (setq org-refile-targets
        '(("archive.org" :maxlevel . 1)))

  ;; make sure to save everything after refiling
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; org agenda
  (setq org-agenda-files
        '("~/org/tasks.org"
          "~/org/school.org"
          "~/org/daily.org"
          "~/org/irl.org"
          "~/org/work.org"))

  ;; follow links
  (setq org-return-follows-link  t)

  ;; hide leading stars
  (setq org-hide-leading-stars t)
  (setq org-hide-emphasis-markers nil)

  ;; this'll come in handly later
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))

  ;; more options
   (setq org-todo-keywords
         '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANCELED(k@)")))

   ;; this is really useful 
  (setq org-startup-with-inline-images t)

  ;; i hope i actually use this eventually
  (setq org-capture-templates
	`(("t" "Tasks")
	  ("tt" "Task" entry (file+olp "~/org/tasks.org" "captured")
	   "* TODO %?\n %U\n %a\n %i" :empty-lines1)))
  )

;; -- org roam -- 

(use-package org-roam
  :custom
  (org-roam-directory "~/org/notes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

;; -- extra org packages --

;; notifications for tasks because i am forgetful
(use-package org-wild-notifier
  :config
  (org-wild-notifier-mode))

;; pomodoro for tasks
(use-package org-pomodoro)

(provide 'sk-org)
