;;; deepnetni-model.el --- Personal minor mode used to manage the configurations modified

;;; Commentary:

;; Bind all the settings to this minor mode for easy management

;;; Code:

;(add-to-list 'load-path (expand-file-name "~/.emacs.d"))
;(require 'evil-commands)

(defvar deepni-settings-mode-map (make-sparse-keymap)
  "Keymap used in `deepni-settings-mode' buffers.")

;;;###autoload
(define-minor-mode deepni-settings-mode
  "A minor mode for deepnetni to override conflict settings."
  :init-value t
  :lighter ""
  :keymap deepni-settings-mode-map)

;(defvar deepnetni-mode-map
;  (let ((map (make-sparse-keymap)))
;    (define-key map (kbd "M-h") #'evil-window-left)
;    (define-key map (kbd "M-l") #'evil-window-right)
;    (define-key map (kbd "M-j") #'evil-window-down)
;    (define-key map (kbd "M-k") #'evil-window-up)
;    (define-key map (kbd "C-c C-f") #'deepnetni-emacs-env/format-code)
;    map) "Deepnet ni minor mode keybindings.")

(provide 'deepni-settings)

;;; deepni-settings ends here
