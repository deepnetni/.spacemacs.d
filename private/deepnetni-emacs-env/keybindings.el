;;; keybindings.el --- Vinegar Layer keybindings File for Spacemacs
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
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

;;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(define-key global-map (kbd "C-k") nil)

;; ============================== counsel ==============================
;(define-key c-mode-map (kbd "C-c C-c") 'counsel-ag)
(define-key global-map (kbd "C-c C-r") 'counsel-etags-recent-tag)

;; ============================== python ==============================
;(define-key python-mode-map (kbd "C-j") 'helm-resume)

;; ============================== eyebrowse ==============================
(define-key global-map (kbd "C-`") 'eyebrowse-last-window-config)
(define-key global-map (kbd "C-1") 'eyebrowse-switch-to-window-config-1)
(define-key global-map (kbd "C-2") 'eyebrowse-switch-to-window-config-2)
(define-key global-map (kbd "C-3") 'eyebrowse-switch-to-window-config-3)
(define-key global-map (kbd "C-4") 'eyebrowse-switch-to-window-config-4)
(define-key global-map (kbd "C-5") 'eyebrowse-switch-to-window-config-5)

;; ============================== evil ==============================

(define-key evil-motion-state-map (kbd "C-b") 'backward-word)
;(define-key evil-motion-state-map (kbd "w") 'forward-word)
(define-key evil-motion-state-map (kbd "M-u") 'evil-window-top)
(define-key evil-motion-state-map (kbd "M-n") 'evil-window-bottom)
;(define-key evil-insert-state-map (kbd "C-h") 'evil-backward-char)
;(define-key evil-insert-state-map (kbd "C-l") 'evil-forward-char)
(define-key evil-insert-state-map (kbd "C-h") 'left-char)
(define-key evil-insert-state-map (kbd "C-l") 'right-char)
(define-key evil-insert-state-map (kbd "C-j") 'evil-next-line)
(define-key evil-insert-state-map (kbd "C-k") 'evil-previous-line)
(define-key evil-insert-state-map (kbd "TAB") 'yas-expand)
(define-key evil-insert-state-map (kbd "M-i") 'tab-to-tab-stop)

(define-key evil-motion-state-map (kbd "*") 'evil-ex-search-word-forward)
(define-key evil-motion-state-map (kbd "#") 'evil-ex-search-word-backward)
(define-key evil-normal-state-map (kbd "C-k") 'evil-ex-nohighlight)
(define-key evil-motion-state-map (kbd "C-e") 'evil-end-of-line)
(define-key evil-motion-state-map (kbd "C-b") 'evil-first-non-blank)
;(define-key evil-motion-state-map (kbd "H") 'evil-first-non-blank)
;(define-key evil-motion-state-map (kbd "L") 'evil-end-of-line)
(define-key evil-motion-state-map (kbd "C-<tab>") 'powershell)

(define-key global-map (kbd "C-h C-f") 'find-function)
(define-key global-map (kbd "C-h C-v") 'find-variable)
(define-key global-map (kbd "C-h C-k") 'find-function-on-key)

(spacemacs/set-leader-keys
  "b k" 'kill-matching-buffers
  "b l" 'ibuffer
  "c h" 'gendoxy-header
  "c t" 'gendoxy-tag)

(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)
(define-key evil-motion-state-map (kbd "C-f") 'counsel-find-file)
(define-key evil-normal-state-map (kbd "C-i") 'evil-jump-forward)
(define-key evil-normal-state-map (kbd "C-=") 'evil-window-increase-height)
(define-key evil-normal-state-map (kbd "C--") 'evil-window-decrease-height)
(define-key evil-normal-state-map (kbd "C-.") 'evil-window-increase-width)
(define-key evil-normal-state-map (kbd "C-,") 'evil-window-decrease-width)
(define-key evil-normal-state-map (kbd "C-w g") 'spacemacs/toggle-golden-ratio)
(define-key evil-normal-state-map (kbd "C-w C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "M-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "M-l") 'evil-window-right)
(define-key evil-normal-state-map (kbd "M-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "M-k") 'evil-window-up)

;(define-key evil-visual-state-map (kbd "C-c") (progn ()))
;; (global-set-key [f8] 'neotree-toggle)

;; ============================== counsel-etags ==============================
(define-key evil-motion-state-map (kbd "C-t") 'pop-tag-mark)

;; ============================== ibuffer ==============================
(define-key ibuffer-mode-map (kbd "j") 'ibuffer-forward-line)
(define-key ibuffer-mode-map (kbd "k") 'ibuffer-backward-line)
(define-key ibuffer-mode-map (kbd "C-k") 'ibuffer-do-kill-lines)
(define-key ibuffer-mode-map (kbd "M-h") 'evil-window-left)


;; ============================== elisp ==============================
