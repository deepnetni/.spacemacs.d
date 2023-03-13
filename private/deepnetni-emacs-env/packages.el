;;; packages.el --- deepnetni-emacs-env layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author:  <niyel@DESKTOP-QKNA44S>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `deepnetni-emacs-env-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `deepnetni-emacs-env/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `deepnetni-emacs-env/pre-init-PACKAGE' and/or
;;   `deepnetni-emacs-env/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

;; In :config should be
;; - Anything that requires the package to be already loaded.
;; - Anything that takes a long time to run, which would ruin startup performance.
;; In :init should be
;; - keybinds
;; - hooks

;; Each package should be owned by one layer only.
;; The layer that owns the package should define its init function.
;; Other layers should rely on pre-init or post-init functions.
(defconst deepnetni-emacs-env-packages
  '((abbrev :location built-in)
    (deepni-settings :location local)
    all-the-icons
    all-the-icons-dired
    blacken
    counsel-etags
    (company :location built-in)
    company-anaconda
    company-irony
    company-irony-c-headers
    irony
    ;company-jedi
    cmake-mode
    cc-mode
    counsel
    ;ggtags
    ;esup
    helm-ag
    hl-todo
    imenu-list
    javascript
    lsp-mode
    ;magit
    (occur-mode :location built-in)
    ;paredit
    projectile
    python
    spaceline
    spaceline-all-the-icons
    ;slime
    (vim-powerline :location built-in)
    yard-mode)
  "The list of Lisp packages required by the deepnetni-emacs-env layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

;; In Spacemacs, layers are loaded in order of inclusion in the dotfile,
;; and packages are loaded in alphabetical order.

(defun deepnetni-emacs-env/init-deepni-settings ()
  (use-package deepni-settings
    :load-path "~/.spacemacs.d/private/core"
    :commands (deepni-settings-mode)
    :bind (:map deepni-settings-mode-map
                ("M-h" . #'evil-window-left)
                ("M-l" . #'evil-window-right)
                ("M-j" . #'evil-window-down)
                ("M-k" . #'evil-window-up)
                ("C-c C-f" . #'deepnetni-emacs-env/format-code))
    :init
    (add-hook 'deepni-settings-mode-hook
              ;(message "### test deepni mode")
              (lambda ()
                (deepnetni-emacs-env//goto-line-center
                 #'(evil-goto-mark
                    evil-jump-backward
                    evil-jump-forward
                    pop-tag-mark))))
    :config))

(defun deepnetni-emacs-env/post-init-abbrev ()
  (add-hook 'emacs-lisp-mode-hook 'abbrev-mode)
  (define-abbrev-table 'global-abbrev-table '(("niye/" "deepnetni-emacs-env/"))))

(defun deepnetni-emacs-env/init-counsel-etags ()
  (use-package counsel-etags
    :delight
    :defer t
    :after (cc-mode)
    ;:pin melpa-cn
    :bind (:map evil-motion-state-map ("C-]" . counsel-etags-find-tag-at-point))
    :init
    ;(add-hook 'prog-mode-hook
    ;          (lambda ()
    ;            (add-hook 'after-save-hook
    ;                      'counsel-etags-virtual-update-tags 'append 'local)))
    ;; Setup auto update now
    (add-hook 'after-save-hook 'counsel-etags-virtual-update-tags 'append 'local)
    ;; auto update tags file
    ;; Don't ask before rereading the TAGS files if they have changed
    (setq tags-revert-without-query t)
    ;; Don't warn when TAGS files are large
    (setq large-file-warning-threshold nil)
    (global-set-key (kbd "C-c C-t") 'counsel-etags-list-tag)
    (define-key c-mode-map (kbd "C-c C-u") 'counsel-etags-update-tags-force)
    (advice-add 'counsel-etags-find-tag-at-point :after
                (lambda () (evil-scroll-line-to-center (line-number-at-pos))))
    (advice-add 'counsel-etags-list-tag :after
                (lambda () (evil-scroll-line-to-center (line-number-at-pos))))
    :config
    (setq counsel-etags-update-interval 60)
    ;; counsel-etags-ignore-directories does NOT support wildcast
    (push "build" counsel-etags-ignore-directories)
    (push "build_clang" counsel-etags-ignore-directories)
    ;; counsel-etags-ignore-filenames supports wildcast
    (push "*.json" counsel-etags-ignore-filenames)
    (push "TAGS" counsel-etags-ignore-filenames)))

;(defun deepnetni-emacs-env/post-init-company ()
;  (setq compandy-minimum-prefix-length 4)
;  (setq company-tooltip-align-annotations t)
;  ;; items in the completion list are sorted by frequency of use
;  (setq company-transformers '(company-sort-by-occurrence))
;  (setq company-selection-wrap-around t)
;  ;(if (boundp 'company-backends)
;  ;    (add-to-list 'company-backends '(company-anaconda :with company-capf))
;  ;  (defvar company-backends '(company-anaconda :with company-capf)))
;  (add-hook 'python-mode-hook 'anaconda-mode)
;  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(defun deepnetni-emacs-env/init-company-irony ()
  (use-package company-irony
    :defer t
    :after (irony company-irony-c-headers)
    :init
    (spacemacs|add-company-backends :backends
                                    company-irony-c-headers
                                    company-irony
                                    :modes c-mode)))

;; the irony cannot company .h files without the following single package
(defun deepnetni-emacs-env/init-company-irony-c-headers ()
  (use-package company-irony-c-headers
    :after irony))

(defun deepnetni-emacs-env/init-irony ()
  (use-package irony
    :diminish irony-mode
    :init
    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    :config
    (irony-cdb-autosetup-compile-options)))

(defun deepnetni-emacs-env/post-init-blacken ()
  (spacemacs|use-package-add-hook blacken
    :post-config
    (setq blacken-line-length '95)))

(defun deepnetni-emacs-env/post-init-company ()
  (spacemacs|use-package-add-hook company
    :post-config
    (setq company-minimum-prefix-length 1)
    (setq company-tooltip-align-annotations t)
    ;; items in the completion list are sorted by frequency of use
    (setq company-transformers '(company-sort-by-occurrence))
    (setq company-selection-wrap-around t)))

(defun deepnetni-emacs-env/init-all-the-icons-dired ()
  (use-package all-the-icons-dired
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
    :commands all-the-icons-dired-mode))

;(defun spacemacs-visual/init-all-the-icons ()
;  (use-package all-the-icons
;    :defer t
;    :if (display-grayscale-p)))

(defun deepnetni-emacs-env/pre-init-all-the-icons ()
  (spacemacs|use-package-add-hook all-the-icons
    :if (display-grayscale-p)
    :after (:any all-the-icons-dired-mode)
    :post-init
    :post-config
    ;(spaceline-toggle-all-the-icons-buffer-position-on)
    (setq spaceline-all-the-icons-icon-set-sun-time 'sun/moon)
    (setq inhibit-compacting-font-caches t)
    (setq spaceline-all-the-icons-icon-set-window-numbering 'square)
    (setq spaceline-all-the-icons-icon-set-eyebrowse-slot 'solid)
    (setq spaceline-all-the-icons-icon-set-git-stats 'diff-icons)))

(defun deepnetni-emacs-env/pre-init-company-anaconda ()
  (spacemacs|use-package-add-hook company-anaconda
    :post-init
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
    (spacemacs|add-company-backends :backends (company-anaconda :with company-capf)
                                    :modes python-mode)))

(defun deepnetni-emacs-env/init-company-jedi ()
  (use-package company-jedi
    :delight
    :defer t
    :init
    (add-hook 'python-mode-hook 'jedi:setup)
    (add-hook 'python-mode-hook
              (lambda ()
                 (add-to-list 'company-backends 'company-jedi)))
    :config
    (setq jedi:complete-on-dot t)
    (setq jedi:use-shortcuts t)))

(defun deepnetni-emacs-env/pre-init-cmake-mode ()
  (spacemacs|use-package-add-hook cmake-mode
    :post-init
    (add-hook 'cmake-mode-hook (lambda () (modify-syntax-entry ?_ "w")))))

(defun deepnetni-emacs-env/pre-init-cc-mode ()
  (spacemacs|use-package-add-hook cc-mode
    :post-init
    (add-hook 'c-mode-hook (lambda () (modify-syntax-entry ?_ "w")))))

(defun deepnetni-emacs-env/pre-init-counsel ()
  (spacemacs|use-package-add-hook counsel
    :post-init
    ;(global-set-key (kbd "C-c j") 'counsel-git-grep)
    ; use projectile to get file C-p
    ;(global-set-key (kbd "C-c f") 'counsel-git)
    ))

; (defun deepnetni-emacs-env/init-ggtags ()
;   (use-package ggtags
;     :init
;     (add-hook 'c-mode-common-hook
;               (lambda ()
;                 (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;                   (ggtags-mode 1))))))

(defun deepnetni-emacs-env/init-esup ()
  (use-package esup
    :ensure t
    :pin melpa))

(defun deepnetni-emacs-env/init-helm-ag ()
  (use-package helm-ag
    :delight
    :ensure t
    :init
    ;(modify-coding-system-alist 'process "ag" '(utf-8 . chinese-gbk-dos))
    (custom-set-variables
     ;; enable helm-follow-mode which will disable the helm-resume function
     ;'(helm-follow-mode-persistent t)
     '(helm-ag-insert-at-point 'symbol)
     ;'(helm-ag-base-command "ag --nocolor --nogroup -w")
     ;'(helm-ag-command-option "--all-text")
     ;'(helm-ag--ignore-case)
     '(helm-ag-ignore-buffer-patterns '("\\.txt\\'" "\\.mkd\\'" "TAGS")))
    (global-set-key (kbd "C-c a") 'helm-ag-project-root)
    (global-set-key (kbd "C-l") 'helm-do-ag-project-root)
    (global-set-key (kbd "C-j") 'helm-resume)
    (add-hook 'c-mode-hook 'helm-mode)
    :config
    (advice-add 'helm-ag :after
                (lambda (&optional basedir query) (evil-scroll-line-to-center (line-number-at-pos))))
    ; &reset _ means don't care about the args
    (advice-add 'helm-ag-project-root :after
                (lambda (&rest _) (evil-scroll-line-to-center (line-number-at-pos))))))

(defun deepnetni-emacs-env/pre-init-hl-todo ()
  (spacemacs|use-package-add-hook hl-todo
    :post-config
    (define-key hl-todo-mode-map (kbd "C-c i") 'hl-todo-insert)
    (define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)))

(defun deepnetni-emacs-env/init-imenu-list ()
  (use-package imenu-list
    :delight
    :init
    (global-set-key (kbd "C-'") #'imenu-list-smart-toggle)
    (setq imenu-list-focus-after-activation t)
    (setq imenu-list-auto-resize t)))

(defun deepnetni-emacs-env/pre-init-javascript ()
  (spacemacs|use-package-add-hook javascript
    :post-init
    (add-hook 'js2-mode-hook (lambda () (modify-syntax-entry ?_ "w")))))

(defun deepnetni-emacs-env/pre-init-lsp-mode ()
  (spacemacs|use-package-add-hook lsp-mode
    :post-init
    (add-hook 'c-mode-hook (lambda ()
                               (setq lsp-modeline-diagnostics-enable nil)))))

(defun deepnetni-emacs-env/init-magit ()
  (use-package magit
    :delight))

(defun deepnetni-emacs-env/init-org-bullets ()
  (use-package org-bullets
    :delight
    :ensure t
    :init
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))))

(defun deepnetni-emacs-env/pre-init-org-projectile ()
  (spacemacs|use-package-add-hook org-projectile
    :post-config
    (progn
      (org-projectile-per-project)
      (setq org-projectile-per-project-filepath "todos.org")
      (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
      (global-set-key (kbd "C-c c") 'org-capture)
      (global-set-key (kbd "C-c n p") 'org-projectile-project-todo-completing-read))))

(defun deepnetni-emacs-env/post-init-occur-mode ()
  (define-key global-map (kbd "M-s o") 'deepnetni-emacs-env/occur-mode)
  (evilified-state-evilify-map occur-mode-map
    :mode occur-mode))

;:bind-keymap ("C-c p" . projectile-command-map)
(defun deepnetni-emacs-env/pre-init-projectile ()
  (spacemacs|use-package-add-hook projectile
    :post-config
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    (define-key evil-normal-state-map (kbd "C-p") 'counsel-projectile-find-file)))

(defun deepnetni-emacs-env/post-init-python ()
  (spacemacs|use-package-add-hook python
    :post-init
    (add-hook 'python-mode-hook (lambda () (modify-syntax-entry ?_ "w")))
    :post-config
    (define-key python-mode-map (kbd "M-n") 'spacemacs/python-execute-file)
    (define-key python-mode-map (kbd "C-j") 'helm-resume)))

(defun deepnetni-emacs-env/post-init-vim-powerline ()
  (setq-default powerline-default-separator 'arrow))

(defun deepnetni-emacs-env/pre-init-spaceline ()
  (spacemacs|use-package-add-hook spaceline
    :post-init
    ;; spaceline mode line configurations
    (setq spaceline-workspace-number-p nil)
    (setq spaceline-buffer-size-p nil)))

(defun deepnetni-emacs-env/pre-init-spaceline-all-the-icons ()
  (spacemacs|use-package-add-hook spaceline-all-the-icons
    :post-config
    (setq anzu-cons-mode-line-p nil)
    (spaceline-all-the-icons--setup-anzu)
    (spaceline-all-the-icons--setup-neotree)
    ;; configure segments
    (spaceline-toggle-all-the-icons-buffer-size-off)
    (spaceline-toggle-all-the-icons-flycheck-status-on)
    (spaceline-toggle-all-the-icons-time-on)
    (spaceline-toggle-all-the-icons-flycheck-status-info-off)
    (spaceline-toggle-all-the-icons-mode-icon-on)
    (spaceline-toggle-all-the-icons-position-off)))

;(defun deepnetni-emacs-env/init-slime ()
;  (use-package slime
;    :ensure t
;    :init
;    (add-hook 'lisp-mode-hook (lambda ()
;                                (unless (featurep 'slime)
;                                  (load (expand-file-name "~/quicklisp/slime-helper.el"))
;                                  (require 'slime-autoloads)
;                                  (normal-mode))))
;    (setq inferior-lisp-program "sbcl")))

(defun deepnetni-emacs-env/init-yard-mode ()
    (use-package yard-mode
      :defer t
      :delight
      :init
      (progn
        (add-hook 'ruby-mode-hook 'yard-mode)
        (add-hook 'ruby-mode-hook 'eldoc-mode))))
