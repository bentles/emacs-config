(filesets-init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(delete-selection-mode t)
 '(desktop-save-mode t)
 '(display-time-mode t)
 '(ecb-options-version "2.40")
 '(gdb-enable-debug t)
 '(gdb-many-windows t)
 '(inhibit-startup-screen t)
 '(reb-re-syntax (quote string))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(weather-distance-unit "mile"))

(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives 
    '("melpa" .
      "http://melpa.milkbox.net/packages/"))
(package-initialize)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:foreground "steel blue" :weight extra-bold))))
 '(slime-repl-inputed-output-face ((t (:foreground "hot pink"))) t))

;set up slime and sbcl 
;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
;(setq inferior-lisp-program "sbcl")

;;add tab complete
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(require 'smex)
(smex-initialize)

;;c indentation
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
;(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;(require 'weather)
;(setq weather-key "64ftej9e8rgn82z8y2etdvv8")

;(if (file-directory-p "c:/cygwin64/bin")
;    (add-to-list 'exec-path "c:/cygwin64/bin"))

;(setq shell-file-name "bash")
;(setq explicit-shell-file-name shell-file-name)

(require 'tramp)
(setq tramp-default-method "sshx")
;(setq tramp-debug-buffer t) 

(display-time)

(global-set-key "\C-m" 'newline-and-indent)

;(add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)


(add-hook 'html-mode-hook
  (lambda ()
    ;; Default indentation is usually 2 spaces, changing to 4.
    (set (make-local-variable 'sgml-basic-offset) 4)))



;;; auto complete mode
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
;(ac-set-trigger-key "TAB")
;(ac-set-trigger-key "<tab>")
(require 'yasnippet)
(yas-global-mode 1)


;(require 'auto-complete-c-headers)
;(add-hook 'c-mode-hook
;	  (lambda ()
;	    (add-to-list 'ac-sources 'ac-source-c-headers)
;	    (add-to-list 'ac-sources 'ac-source-c-header-symbols t)))


;;add keybinding F to dired to open marked files
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

(require 'multiple-cursors)
(global-set-key (kbd "C-S-q C-S-q") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'phi-search)
(global-set-key (kbd "C-s") 'phi-search)
(global-set-key (kbd "C-r") 'phi-search-backward)

(require 'phi-replace)
(global-set-key (kbd "M-%") 'phi-replace-query)

(global-linum-mode)

;repl switcher
(setq rtog/fullscreen nil)
(require 'repl-toggle)
(setq rtog/mode-repl-alist '((js2-mode . nodejs-repl)))

(setq-default indent-tabs-mode nil)

(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun shk-eshell-prompt ()
  (let ((header-bg "#fff"))
    (concat
     (with-face (concat (eshell/pwd) " ") :background header-bg)
     (with-face (format-time-string "(%Y-%m-%d %H:%M) " (current-time)) :background header-bg :foreground "#888")
     (with-face
      (or (ignore-errors (format "(%s)" (vc-responsible-backend default-directory))) "")
      :background header-bg)
     (with-face "\n" :background header-bg)
     (with-face user-login-name :foreground "blue")
     "@"
     (with-face "localhost" :foreground "green")
     (if (= (user-uid) 0)
         (with-face " #" :foreground "red")
       " $")
     " ")))
(setq eshell-prompt-function 'shk-eshell-prompt)
(setq eshell-highlight-prompt nil)

(ido-mode)
