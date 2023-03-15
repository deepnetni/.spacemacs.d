(when (configuration-layer/layer-used-p 'deepnetni-emacs-env)
  (defun deepnetni-emacs-env//goto-line-center (hook-list)
    (dolist (tgt hook-list)
      (advice-add tgt :after (lambda (&rest _)
                              (evil-scroll-line-to-center (line-number-at-pos))))))

  (defun deepnetni-emacs-env/occur-mode ()
    (interactive)
    (push (if (region-active-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (let ((sym (thing-at-point 'symbol)))
              (when (stringp sym)
                (regexp-quote sym))))
          regexp-history)
    (call-interactively 'occur))

  ;; Suppress the message saying that the undo history file was
  ;; saved that happens every single time you create a new file.
  (defun deepnetni-emacs-env/suppress-undo-tree-save-history
      (undo-tree-save-history &rest args)
    (let ((inhibit-message t))
      (apply undo-tree-save-history args)))

  ;; Supress the message saying that the undo history could not be
  ;; loaded because the file changed outside of Emacs
  (defun deepnetni-emacs-env/suppress-undo-tree-load-history
      (undo-tree-load-history &rest args)
    (let ((inhibit-message t))
      (apply undo-tree-load-history args)))

  (defun deepnetni-emacs-env/format-code ()
    (interactive)
    (pcase major-mode
      ('c-mode (hide-ifdefs)
               (clang-format-buffer))
      ('c++-mode (hide-ifdefs)
                 (clang-format-buffer))
      ('python-mode (if blacken-mode
                        (blacken-buffer))
                    (spacemacs/python-format-buffer)))))


;; load json macro configure
;(defun deepnetni-emacs-env/load-json-file (fname)
;  "read it's content if file exist, else do nothing"
;  (let ((fpath (expand-file-name (concat projectile-project-root fname)))
;        json-alist)
;    (when (file-exists-p fpath)
;      (message "load macro from file %s" fpath)
;      (setq json-array-type 'list)
;      (setq json-alist (json-read-file fpath))
;      (dolist (macro (alist-get 'defines json-alist))
;        (hide-ifdef-define macro))
;      (dolist (macro (alist-get 'undefs json-alist))
;        (hide-ifdef-undef macro)))))
