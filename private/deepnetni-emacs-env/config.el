;;; config --- settings

;;; Commentary:
;;; Code:

;(message "deepnetni-emacs-env.config.el")

;; Use a hook so the message doesn't get clobbered by other messages.
;(add-hook 'emacs-startup-hook
;          (lambda ()
;            (message "Emacs ready in %s with %d garbage collections."
;                     (format "%.2f seconds"
;                             (float-time
;                              (time-subtract after-init-time before-init-time)))
;                     gcs-done)))

;; add macro definitions with `hide-ifdef-define` and undefine it by `hide-ifdef-undef`
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq hide-ifdef-shadow t)
            (hide-ifdef-mode)
            (hide-ifdefs)))

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))

;; jump over characters with -, e.g., ab-c
;; somethings need the following configure
(with-eval-after-load 'evil
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (setq-default evil-symbol-word-search t))

;(define-key c++-mode-map (kbd "C-c C-c") nil)

; <C-c> <C-p> enter run-python mode
(add-hook 'inferior-python-mode-hook
          (lambda ()
            (define-key inferior-python-mode-map (kbd "M-h") 'evil-window-left)
            (define-key inferior-python-mode-map (kbd "M-l") 'evil-window-right)
            (define-key inferior-python-mode-map (kbd "M-j") 'evil-window-down)
            (define-key inferior-python-mode-map (kbd "M-k") 'evil-window-up)))

(add-hook 'deepni-settings-mode-hook
          (lambda ()
            (global-undo-tree-mode t)
            ;; Automatically synchronize modifications to buffer
            (global-auto-revert-mode t)
            ;; hide the minor mode indicators
            (spaceline-toggle-minor-modes-off)
            ;; ignore warning that cl is deprecated xxx
            (setq byte-compile-warnings '(cl-functions))
            (setq python-indent-guess-indent-offset t)
            (setq python-indent-guess-indent-offset-verbose nil)
            (setq tags-add-tables nil)
            ;; don't generate file starts with .#
            (setq create-lockfiles nil)
            ;; don't load org-mode sub-modules to boot startup
            (setq org-modules-loaded t)
            (eval-after-load 'dired-quick-sort
              '(setq dired-quick-sort-suppress-setup-warning t))
            ;; configure coding system to support Chinese characters
            (set-language-environment 'Chinese-GB)
            (set-default buffer-file-coding-system 'utf-8-unix)
            (set-default-coding-systems 'utf-8-unix)
            (prefer-coding-system 'gb2312)
            (prefer-coding-system 'utf-16)
            (prefer-coding-system 'utf-8-emacs)
            (prefer-coding-system 'utf-8-unix)
            ;; configure terminal coding system
            (set-terminal-coding-system 'utf-8-unix)))

;(add-hook 'minibuffer-setup-hook (lambda () (deepni-settings-mode nil)))

;; better configurations
(advice-add #'undo-tree-load-history
            :around #'deepnetni-emacs-env/suppress-undo-tree-load-history)
(advice-add #'undo-tree-save-history
            :around #'deepnetni-emacs-env/suppress-undo-tree-save-history)


;; ================== Reference ==================
;(add-hook 'python-mode-hook (lambda ()
; (set (make-local-variable 'company-backends)
; '(company-anaconda company-dabbrev company-ispell))))

;; diminish lets you fight modeline clutter
;; by removing or abbreviating minor mode indicators
;(eval-after-load "xx" '(diminish 'xx-mode))

;;; config.el ends here
