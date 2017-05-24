;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

;;(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                   ("melpa" . "http://melpa.org/packages/")
;;                 ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    elpy
    flycheck
    py-autopep8
    minimap
    company-irony
    irony
  	))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)



;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'monokai t) ;; load monokai //brin theme
(global-linum-mode t) ;; enable line numbers globally
(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(set-face-attribute 'default nil :height 100)
;; autocomplete paired brackets
(electric-pair-mode 1)
(setq-default cursor-type 'bar)
(minimap-mode 1)
(setq minimap-window-location 'right)
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)



;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f81a9aabc6a70441e4a742dfd6d10b2bae1088830dc7aba9c9922f4b1bd2ba50" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" default)))
 '(erc-modules
   (quote
    (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring stamp track)))
 '(linum-format " %5i ")
 '(minimap-dedicated-window t)
 '(minimap-minimum-width 10)
 '(package-selected-packages
   (quote
    (js2-mode web-mode tabbar sublime-themes sr-speedbar py-autopep8 monokai-theme minimap irony-eldoc ggtags flycheck elpy company-irony-c-headers company-irony better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-active-region-background ((t (:background "dim gray")))))

(add-to-list 'load-path "~/.emacs.d/Neotree/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(setq-local imenu-create-index-function #'ggtags-build-imenu-index)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; scroll one line at a time (less "jumpy" than defaults)

;;    (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

;;    (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
    
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
    
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(global-set-key (kbd "C-<down>") 'enlarge-window)
(global-set-key (kbd "C-<up>") 'shrink-window)
(global-set-key (kbd "C-<left>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<right>") 'shrink-window-horizontally)
(put 'erase-buffer 'disabled nil)
