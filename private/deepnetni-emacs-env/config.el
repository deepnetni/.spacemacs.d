;; lsp
;; use flycheck-verify-setup command to choose code check backends

;; mode line configurations
(with-eval-after-load 'spaceline
  (setq spaceline-workspace-number-p nil)
  (setq spaceline-buffer-size-p nil))

;(with-eval-after-load 'c-c++-mode (add-hook 'c++-mode-hook 'lsp))
;(with-eval-after-load 'lsp-mode
;  (add-hook 'c-mode-hook '(lsp-mode nil)))
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))

; jump over characters with _, e.g., ab_c
(with-eval-after-load 'evil
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (setq-default evil-symbol-word-search t))

;; diminish lets you fight modeline clutter by removing or abbreviating minor mode indicators"
;(eval-after-load "xx" '(diminish 'xx-mode))

;(add-hook 'python-mode-hook (lambda ()
; (set (make-local-variable 'company-backends)
; '(company-anaconda company-dabbrev company-ispell))))

;; self minor mode part
(setq deepnetni-emacs-env--goto-center-hook
      #'(evil-goto-mark
         ;evil-ex-search-next
         ;evil-ex-search-previous
         evil-jump-backward
         evil-jump-forward
         pop-tag-mark))

;; define minor mode
(define-minor-mode deepnetni-mode
  "A minor mode for deepnetni to override conflict settings."
  :init-value t
  :lighter "")


;; override keybinds defined after deepnetni packages
(defvar deepnetni-mode-map
  (let ((map (make-sparse-keymap)))
    ;(define-key map (kbd "") 'some-function)
    map)
  "deepnet ni minor mode keybindings")

(add-hook 'deepnetni-mode-hook
          (lambda ()
             (deepnetni-emacs-env//goto-line-center
              deepnetni-emacs-env--goto-center-hook)))

(add-hook 'deepnetni-mode-hook
          (lambda ()
            ;; ignore warning that cl is deprecated xxx
            (setq byte-compile-warnings '(cl-functions))
            (setq python-indent-guess-indent-offset t)
            (setq python-indent-guess-indent-offset-verbose nil)
            (setq tags-add-tables nil)
            (eval-after-load 'dired-quick-sort
              '(setq dired-quick-sort-suppress-setup-warning t))
            ;; hide the minor mode indicators
            (spaceline-toggle-minor-modes-off)
            (with-eval-after-load 'spaceline-all-the-icons
              (spaceline-toggle-all-the-icons-buffer-size-off)
              (spaceline-toggle-all-the-icons-flycheck-status-off)
              (spaceline-toggle-all-the-icons-mode-icon-off)
              (spaceline-toggle-all-the-icons-position-off))
            (global-undo-tree-mode 1)
            ;; configure coding system to support Chinese characters
            (set-language-environment 'Chinese-GB)
            (set-default buffer-file-coding-system 'utf-8-unix)
            (set-default-coding-systems 'utf-8-unix)
            (prefer-coding-system 'gb2312)
            (prefer-coding-system 'utf-16)
            (prefer-coding-system 'utf-8-emacs)
            (prefer-coding-system 'utf-8-unix)))

(add-hook 'minibuffer-setup-hook (lambda () (deepnetni-mode nil)))

;; better configurations
(advice-add #'undo-tree-load-history
            :around #'deepnetni-emacs-env/suppress-undo-tree-load-history)
(advice-add #'undo-tree-save-history
            :around #'deepnetni-emacs-env/suppress-undo-tree-save-history)
