;;; conao3-json-ts-mode.el --- Conao3 json tree-sitter major-mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience
;; Package-Requires: ((emacs "29.1"))
;; URL: https://github.com/conao3/elisp-conao3-json-ts-mode

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Conao3 json tree-sitter major-mode

;;; Code:

(require 'treesit)

(defvar conao3-json-ts-mode-language-source
  '(conao3-json . ("https://github.com/conao3/tree-sitter-conao3-json"))
  "`treesit-language-source-alist' value.")

;;;###autoload
(define-derived-mode conao3-json-ts-mode prog-mode "[Conao3]JSON"
  :group 'conao3-json-ts-mode
  (unless (treesit-language-available-p 'conao3-json)
    (let ((treesit-language-source-alist (list conao3-json-ts-mode-language-source)))
      (treesit-install-language-grammar 'conao3-json)))

  (setq-local treesit-primary-parser (treesit-parser-create 'conao3-json))

  (setq-local treesit-font-lock-settings
              (treesit-font-lock-rules
               :language 'conao3-json
               :feature 'all
               '(((string) @font-lock-string-face)
                 ((number) @font-lock-constant-face)
                 ((boolean) @font-lock-constant-face)
                 ((null) @font-lock-constant-face))))

  (setq-local treesit-font-lock-feature-list '((all)))

  (setq-local treesit-simple-indent-rules
              '((conao3-json
                 ((node-is "]") parent-bol 0)
                 ((node-is "}") parent-bol 0)
                 ((parent-is "object") parent-bol 2)
                 ((parent-is "array") parent-bol 2))))

  (treesit-major-mode-setup))

;;;###autoload
(define-minor-mode conao3-json-ts-mode-mode
  "Toggle `conao3-json-ts-mode' enabled."
  :group 'conao3-json-ts-mode
  :global t
  (if conao3-json-ts-mode-mode
      (progn
        (add-to-list 'auto-mode-alist '("\\.json\\'" . conao3-json-ts-mode))
        (add-to-list 'major-mode-remap-alist '(json-mode . conao3-json-ts-mode)))
    (setq auto-mode-alist (delete '("\\.json\\'" . conao3-json-ts-mode) auto-mode-alist))
    (setq major-mode-remap-alist (delete '(json-mode . conao3-json-ts-mode) major-mode-remap-alist))))

(provide 'conao3-json-ts-mode)

;;; conao3-json-ts-mode.el ends here
