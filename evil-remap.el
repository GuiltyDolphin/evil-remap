;;; evil-remap.el --- additional key-binding options for evil
;; Copyright (C) 2016 Ben Moon
;;
;; This program is free software: you can redistribute it and/or modify
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
;;;
;;; Provide additional means of remapping keys in evil-mode
;;; akin to those found in Vim.
;;;
;;; Overview of which functions affect which modes:
;;; FUNCTIONS      MODES
;;; noremap        Normal, Visual, Operator-pending
;;; nnoremap       Normal
;;; vnoremap       Visual
;;; xnoremap       Ex-mode
;;; onoremap       Operator-pending
;;; inoremap       Insert
;;; enoremap       Emacs
;;; mnoremap       Motion
;;; nnoremap!      Normal, Visual, Operator-pending, Motion

;;; (evil-noremap! ";" 'evil-ex)
;;; Code:

(require 'evil)

(defun evil-noremap (key command)
  "Bind key in evil normal, visual and operator modes."
  (evil-nnoremap key command)
  (evil-vnoremap key command)
  (evil-onoremap key command))


;;;
(defun evil-nnoremap-mode (keymap key command)
  (evil-define-key 'normal key command))

(defun evil-define-key-multi (states keymap key def)
  "For each STATE in STATES, create a STATE binding from KEY to
DEF for the given KEYMAP.

STATES must be a list of valid evil-mode states.
See `evil-define-key' for more information."
  (dolist (state states)
    (evil-define-key state keymap key def)))
;;;

(defun evil-inoremap-mode (keymap key command)
  (evil-define-key-multi '(insert) key command))

(defmacro evil-define-remap (state shortname)
  "Define a new keybinding function for STATE.

SHORTNAME should be the desired name in evil-{SHORTNAME}noremap."
  (let ((name-sym (intern (concat "evil-" shortname "noremap"))))
    `(defun ,name-sym (key command)
       ,(format "Bind KEY to COMMAND in evil %s."
                (if (string-match "^\\(.*\\)-state$" (symbol-name state))
                    (format "%s state" (match-string 1 (symbol-name state)))
                  (format "%s mode" shortname)))
       (define-key ,(intern (format "evil-%s-map" state)) key command))))

(evil-define-remap normal-state "n")
(evil-define-remap visual-state "v")
(evil-define-remap ex "x")
(evil-define-remap operator-state "o")
(evil-define-remap insert-state "i")
(evil-define-remap emacs-state "e")
(evil-define-remap motion-state "m")

(defun evil-nnoremap! (key command)
  (evil-nnoremap key command)
  (evil-mnoremap key command))

(provide 'evil-remap)
;;; evil-remap.el ends here
