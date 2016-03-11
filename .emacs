(filesets-init)

;;add repos
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives 
    '("melpa" .
      "http://melpa.milkbox.net/packages/"))
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (base16-default-dark)))
 '(custom-safe-themes
   (quote
    ("0b6645497e51d80eda1d337d6cabe31814d6c381e69491931a688836c16137ed" "e688cf46fd8d8fcb4e7ad683045fbf314716f184779f3f087ef226a4e170837a" "bede70e4b2654751936d634040347bb4704fa956ecf7dceab03661a75e46a8ca" default)))
 '(delete-selection-mode t)
 '(desktop-save-mode t)
 '(display-time-mode t)
 '(ecb-layout-name "left-dir-plus-speedbar")
 '(ecb-layout-window-sizes
   (quote
    (("left-dir-plus-speedbar"
      (ecb-directories-buffer-name 0.21052631578947367 . 0.5)
      (ecb-speedbar-buffer-name 0.21052631578947367 . 0.5)))))
 '(ecb-options-version "2.40")
 '(electric-pair-inhibit-predicate (quote electric-pair-conservative-inhibit))
 '(electric-pair-mode t)
 '(gdb-enable-debug t)
 '(gdb-many-windows nil)
 '(global-auto-revert-mode t)
 '(ido-mode (quote both) nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(org-clock-persist (quote history))
 '(org-startup-indented t)
 '(reb-re-syntax (quote string))
 '(show-paren-mode t)
 '(slime-backend "swank-loader.lisp")
 '(tool-bar-mode nil)
 '(weather-distance-unit "mile")
 '(winner-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:foreground "steel blue" :weight extra-bold))))
 '(slime-repl-inputed-output-face ((t (:foreground "hot pink"))) t))

;;;LETS USE SOME PACKAGES
;;smex
(use-package smex
  :init
  (smex-initialize)
  :bind
  ("M-x" . smex)
  ("M-X" . smex-major-mode-commands)
  ("C-c C-c M-x" . execute-extended-command))

;;tramp
(use-package tramp
  :init
  (setq tramp-default-method "sshx"))

;;yasnippet
(use-package yasnippet 
  :init (yas-global-mode 1))

;;auto complete mode
;;should be loaded after yasnippet so that they can work together
(use-package auto-complete)
(use-package auto-complete-config
  :init 
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (ac-config-default))

;;multiple cursors
(use-package multiple-cursors
  :bind 
  ("C-S-q C-S-q" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

;;drag stuff
;;M-up and down to move lines                    
(use-package drag-stuff
  :init                            
  (drag-stuff-global-mode t)                      
  (add-to-list 'drag-stuff-except-modes 'org-mode))

(use-package cc-mode)

;;semantic in da house
(use-package semantic
         :init 
         (semantic-mode 1)
         :config
         (global-semanticdb-minor-mode 1)
         (global-semantic-idle-scheduler-mode 1))

(use-package js2-mode
  :init 
  (add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))
  (add-hook 'js-mode-hook 'js2-minor-mode)
  (add-hook 'js2-mode-hook 'ac-js2-mode))

(use-package switch-window
  :bind
  ( "C-x <tab>" . switch-window))


(use-package slime-autoloads
  :init 
  (add-to-list 'load-path "~/quicklisp/dists/quicklisp/software/slime-2.13/")
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (add-to-list 'load-path "~/.emacs.d/manual/")) ; <-- wut?

;;flycheck all the things
(use-package flycheck
  :init 
  (add-hook 'after-init-hook #'global-flycheck-mode))

;;;OTHER THINGS (TM)
;;add tab complete
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t) 

;;html mode uses 4 spaces
(add-hook 'html-mode-hook
  (lambda ()
    (set (make-local-variable 'sgml-basic-offset) 4)))

;;add keybinding F to dired to open all marked files
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

;;mode for writing VM assembly
(autoload 'vm-mode "~/.emacs.d/vm-mode.el" "" t)
(add-to-list 'auto-mode-alist '("\\.\\(asm\\|s\\)$" . vm-mode))
(add-hook 'vm-mode-hook
          (lambda () (setq-default vm-basic-offset 2)))

;;turn on the horizontal line about the point
(global-hl-line-mode)

;;reopen killed file:
;;Habits from browsers shouldn't have to die when i load emacs
(defvar killed-file-list nil
  "List of recently killed files.")

(defun add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-file-list)))

(add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)

(defun reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (when killed-file-list
    (find-file (pop killed-file-list))))

(define-key global-map (kbd "C-S-t") 'reopen-killed-file)

;;some conveniences for common tasks
(global-set-key [f12] 'compile)
(global-set-key [f11] 'magit-status)

;;switch between headers and source files
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c <down>") 'ff-find-other-file)))

;;c indentation
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
