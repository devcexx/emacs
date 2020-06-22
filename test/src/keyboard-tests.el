;;; keyboard-tests.el --- Tests for keyboard.c -*- lexical-binding: t -*-

;; Copyright (C) 2017-2020 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Code:

(require 'ert)

(ert-deftest keyboard-unread-command-events ()
  "Test `unread-command-events'."
  (should (equal (progn (push ?\C-a unread-command-events)
                        (read-event nil nil 1))
                 ?\C-a))
  (should (equal (progn (run-with-timer
                         1 nil
                         (lambda () (push '(t . ?\C-b) unread-command-events)))
                        (read-event nil nil 2))
                 ?\C-b)))

(ert-deftest keyboard-lossage-limit ()
  "Test `lossage-limit' updates."
  (dolist (val (list 100 100 200 500 300 1000 700))
    (update-lossage-limit val)
    (should (= val lossage-limit)))
  (let ((current-limit lossage-limit))
    (should-error (update-lossage-limit 0))
    (should-error (update-lossage-limit "200"))
    (should (= lossage-limit current-limit))))


(provide 'keyboard-tests)
;;; keyboard-tests.el ends here
