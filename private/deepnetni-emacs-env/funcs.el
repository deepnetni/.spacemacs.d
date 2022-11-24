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
      (apply undo-tree-load-history args))))
