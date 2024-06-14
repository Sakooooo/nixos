;; -*- lexical-binding: t; -*-

;; web
;; html/css
(use-package web-mode
     :hook (web-mode . eglot-ensure)
     :mode ("\\.html\\'"
             "\\.css\\'"))

;; js
(use-package js2-mode
:mode ("\\.js\\'"
  	 "\\.jsx\\'")
:hook (js2-mode . eglot-ensure)
:config
(setq web-mode-markup-indent-offset 2) ; HTML
(setq web-mode-css-indent-offset 2)    ; CSS
(setq web-mode-code-indent-offset 2)   ; JS/JSX/TS/TSX
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))

;; ts
(use-package typescript-mode
  :mode ("\\.ts\\'"
	 "\\.tsx\\'")
  :hook (typescript-mode . eglot-ensure))

;; astro
  (define-derived-mode astro-mode web-mode "astro")
  (setq auto-mode-alist
  (append '((".*\\.astro\\'" . astro-mode))
  auto-mode-alist))

;; c/c++
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; cmake
(use-package cmake-mode
  :mode "CMakeLists.txt"
  :hook (cmake-mode . eglot-ensure))

(use-package lua-mode
  :mode "\\.lua\\'"
  :hook (lua-mode . eglot-ensure))


;; python
(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . eglot-ensure))

(use-package elpy
:after python-mode

:custom
(elpy-rpc-python-command "python3")

:config
(elpy-enable))

(use-package poetry
  :config
  (poetry-tracking-mode 1))

;; haskell
(use-package haskell-mode
  :mode "\\.hs\\'"
  :hook (python-mode . eglot-ensure))

;; yaml
(use-package yaml-mode
  :mode ("\\.yaml\\'"
         "\\.yml\\'"))

;; nix
(use-package nix-mode
  :hook (nix-mode . eglot-ensure) 
  :mode "\\.nix\\'")

;; dart
(use-package dart-mode
 :hook (dart-mode . eglot-ensure)
:mode "\\.dart\\'" )

;; markdown
(use-package markdown-mode
  :hook (markdown-mode . visual-line-mode))

(use-package markdown-preview-mode)

;; gdscript
(use-package gdscript-mode
  :hook (gdscript-mode . eglot-ensure)
  :mode "\\.gd\\'")

;; rust
(use-package rust-mode
  :hook (rust-mode . eglot-ensure)
  :mode "\\.rs\\'")


(provide 'sk-dev-lang)
