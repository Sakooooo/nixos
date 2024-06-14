;; -*- lexical-binding: t; -*-

(add-to-list 'load-path '"~/.emacs.d/modules")

;; important
(require 'sk-package)
(require 'sk-keybinds)

(require 'sk-core)
(require 'sk-keys-general)
(require 'sk-keys-evil)
(require 'sk-interface)
(require 'sk-auth)
(require 'sk-shell)
(require 'sk-dev)
(require 'sk-dev-lang)
(require 'sk-social)
(require 'sk-org)

(message "Welcome to Emacs!")
