;;; post-init.el --- post-init  -*-  no-byte-compile: t; lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;; Base example init.el (extended from the info file).
;; Basic example of loading a module.

;;; Code:

;; Themes
(use-package ef-themes :ensure t)
(use-package cyberpunk-2019-theme :ensure t)
(use-package gandalf-theme :ensure t)
(use-package cyberpunk-theme :ensure t)


;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(add-hook 'after-init-hook #'global-auto-revert-mode)

;; recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(add-hook 'after-init-hook #'recentf-mode)

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(add-hook 'after-init-hook #'savehist-mode)

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(add-hook 'after-init-hook #'save-place-mode)










;; Create the variable if needed
(if (boundp 'crafted-emacs-home)
    (message "crafted-emacs-home value set by user: %s" crafted-emacs-home)
  (defvar crafted-emacs-home nil
    "Defines where the Crafted Emacs project was cloned to.

This is set when loading the crafted-init-config.el module during
initialization.  Alternatively, it can be set by the user
explicitly."))

;; Only set the `crafted-emacs-home' variable if it does not already
;; have a value set by the user.
(when (null crafted-emacs-home)
  (setq crafted-emacs-home
        (expand-file-name
         (vc-find-root load-file-name "modules"))))

;; we still don't have a `crafted-emacs-home' value, so we can't
;; proceed, without it the `load-path' will not be set correctly and
;; crafted-emacs modules will not be found.
(unless crafted-emacs-home
  (error "%s\n%s"
         "The value for crafted-emacs-home is not set"
         "Please set this value to the location where crafted-emacs is installed"))


;; update the `load-path' to include the Crafted Emacs modules path
(let ((modules (expand-file-name "./modules/" crafted-emacs-home)))
  (when (file-directory-p modules)
    (message "adding modules to load-path: %s" modules)
    (add-to-list 'load-path modules)))


(require 'base)
(require 'org-mode)


;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

;;; _
(provide 'post-init)
;;; init.el ends here
