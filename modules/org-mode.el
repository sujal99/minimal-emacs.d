;;; org-mode.el --- org-mode -*-  no-byte-compile: t; lexical-binding: t; -*-


(defvar sjlg/org-directory  "~/my-drive/orgfiles" "Choose org file directory.")
(defvar sjlg/inbox-file (expand-file-name "inbox.org" sjlg/org-directory) "New stuff collects in this file.")


(setq-default org-agenda-files (list sjlg/org-directory))

;; TODO FACES
(defface sjlg/org-todo-active
  '((t :inherit (bold org-todo)))
  "")
(defface sjlg/org-todo-doc
  '((t :inherit (default org-todo)))
  "")
(defface sjlg/org-todo-warning
  '((t :inherit (bold warning org-todo)))
  "")
(defface sjlg/org-todo-error
  '((t :inherit (bold error org-todo)))
  "")
(defface sjlg/org-todo-done
  '((t :inherit (bold org-done)))
  "")  


;;; Org mode
(use-package org
  :hook
  (org-mode . org-indent-mode)
  (org-mode . visual-line-mode)  ; wrap lines at word breaks
  (org-mode . flyspell-mode)  ; spell checking!
  :bind (:map global-map
              ("C-c l s" . org-store-link)          ; Mnemonic: link → store
              ("C-c l i" . org-insert-link-global)) ; Mnemonic: link → insert
  
  :ensure nil
  :custom
  (org-return-follows-link t)
  
  (org-catch-invisible-edits 'show)
  (org-directory sjlg/org-directory)
  (org-export-coding-system 'utf-8)
  (org-export-kill-product-buffer-when-displayed t)


  (org-html-validation-link nil)
  (org-indent-indentation-per-level 2)
  (org-log-done 'time)
  (org-log-into-drawer t)
  ;; TODO KEYWORDS
  (org-todo-keywords
   '((sequence
      "IDEA(i)"        ; An unconfirmed and unapproved task or notion
      "TODO(t!)"        ; A task that needs doing & is ready to do
      "PROJ(p)"         ; A project, which usually contains other tasks
      "LOOP(r)"         ; A recurring task
      "DOING(s!)"        ; A task that is in progress
      "WAIT(w!)"        ; on hold
      "|"
      "DONE(d!)"        ; Task successfully completed
      "KILL(k!)")       ; Task was cancelled, aborted, or is no longer applicable
     (sequence
      "[ ](T!)"   ; A task that needs doing
      "[-](S!)"   ; Task is in progress
      "[?](W!)"   ; Task is being held up or paused
      "|"
      "[X](D!)")  ; Task was completed
     (sequence
      "|"
      "OKAY(o)"
      "YES(y)"
      "NO(n)")))

   ;; (org-todo-keyword-faces
   ;;  '(
   ;;    ("TODO" . sjlg/org-todo-active)
   ;;    ("PROJECT" . sjlg/org-todo-doc)
   ;;    ("LOOP" . sjlg/org-todo-doc)
   ;;    ("DOING" . sjlg/org-todo-active)
   ;;    ("WAIT" . sjlg/org-todo-warnig)
   ;;    ("IDEA" . sjlg/org-todo-doc)
   ;;    ("DONE" . sjlg/org-todo-doc)
   ;;    ("KILL" . sjlg/org-todo-doc)))
   
  ;; Refile configuration
  (org-refile-targets '((nil :maxlevel . 5)
			(org-agenda-files :maxlevel . 5)))
  (org-outline-path-complete-in-steps nil)
  (org-refile-use-outline-path 'file)

  (org-capture-templates
   '(("c" "Default Capture" entry (file sjlg/org-inbox-file)
      "* %?\n:PROPERTIES:\n:CREATED:%U\n:END:\n\n%i"
      :empty-lines 1)))
  
  :config
  (setq-default org-fontify-done-headline t)
  (setq-default org-fontify-drawers t)
  (setq-default org-fontify-todo-headline t)
  (setq-default org-hide-emphasis-markers t)
  (setq-default org-hide-leading-stars t)
  (setq-default org-mouse-1-follows-link t)

  
  
  (require 'oc-csl)                     ; citation support
  (add-to-list 'org-export-backends 'md)

  ;; Make org-open-at-point follow file links in the same window
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)

  ;; Make exporting quotes better
  (setq org-export-with-smart-quotes t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   (seq-filter
    (lambda (pair)
      (locate-library (concat "ob-" (symbol-name (car pair)))))
    '((R . t)
      (ditaa . t)
      (dot . t)
      (emacs-lisp . t)
      (gnuplot . t)
      (haskell . nil)
      (latex . t)
      (ledger . t)
      (python . t)
      (ruby . t)
      (screen . nil)
      (sh . t) ;; obsolete
      (shell . t)
      (sql . t)
      (sqlite . t))))
  )

;; (use-package org-superstar
;;   :ensure t
;;   :after org
;;   :if (and (display-graphic-p) (char-displayable-p ?◉))
;;   :hook (org-mode . org-superstar-mode)
;;   :config
;;   (setq-default org-superstar-prettify-item-bullets t))

(use-package org-fancy-priorities
  :ensure t
  :after org
  :diminish
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq-default org-fancy-priorities-list
                  (if (and (display-graphic-p) (char-displayable-p ?🅐))
                      '("🅐" "🅑" "🅒" "🅓")
                    '("HIGH" "MEDIUM" "LOW" "OPTIONAL"))))

(require 'org)
(require 'outline)
(defun org-where-am-i ()
  "Return a string of headers indicating where point is in the current tree."
  (interactive)
  (let (headers)
    (save-excursion
      (while (condition-case nil
                 (progn
                   (push (nth 4 (org-heading-components)) headers)
                   (outline-up-heading 1))
               (error nil))))
    (message (mapconcat #'identity headers " > "))))

;;;; tags
(use-package org
  :ensure nil
  :config
  (setq org-tag-alist nil)
  ;; (setq org-tag-alist '(
  ;;       	   (:startgroup)
  ;;       	   ("@office" . ?o)
  ;;       	   ("@gov" . ?g)
  ;;       	   ("@self")
  ;;       	   (:endgroup)
  ;;       	   (:newline)
  ;;       	   (:startgroup)
  ;;       	   ("$java")
  ;;                  ("$postgres")
  ;;                  ("$system-design")
  ;;                  ("$python")
  ;;                  ("$cs")
  ;;       	   (:endgroup)
  ;;                  (:startgroup)
  ;;       	   ("PROJECT")
  ;;                  (:endgroup)))
  (setq org-auto-align-tags nil)
  (setq org-tags-column 0))







;; Org-refile: where should org-refile look?


;;; Phase 3 variables

;; Org-roam variables

;;; Optional variables

;; Advanced: Custom link types
;; This example is for linking a person's 7-character ID to their page on the
;; free genealogy website Family Search.
(setq org-link-abbrev-alist
      '(("family_search" . "https://www.familysearch.org/tree/person/details/%s")))


(use-package org-roam
  :ensure t
  :diminish
  :custom
  (org-roam-db-location (file-truename "~/org-roam.db"))
  (org-roam-directory (file-truename sjlg/org-directory))
  (org-roam-dailies-directory "daily/")
  (org-roam-node-display-template (concat "${title:40} " (propertize "${tags:50}" 'face 'org-tag) "${file:50}"))
  (org-roam-capture-templates
   '(("y" "default (all notes)" plain "%?"
      :target
      (file+head "all/${slug}.org"
                 "#+title: ${title}\n#+startup: overview\n")
      :immediate-finish t
      :empty-lines 1
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %?\n"
      :target
      (file+head+olp "%<%Y>/%<%Y-%b>.org"
                     "#+TITLE: %<%Y-%b>\n#+STARTUP: overview\n"
                     ("%<%Y-%b-%d-%a>"))
      :unnarrowed t)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; Dedicated side window for backlinks
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (window-width . 0.4)
                 (window-height . fit-window-to-buffer))))

;; Pretty web interface for org-roam
;(use-package org-roam-ui
;  :ensure t
;  :after org-roam
;  :config
;  (setq org-roam-ui-sync-theme t
;        org-roam-ui-follow t
;        org-roam-ui-update-on-save t
;        org-roam-ui-open-on-start t))


(use-package hydra :ensure t
    :config (setq hydra-is-helpful t
                hydra-lv t
                lv-use-separator t))

(require `org)

(defhydra hydra-org-refiler (:hint nil)
    "
  ^Navigate^      ^Refile^       ^Move^           ^Update^        ^Go To^        ^Dired^
  ^^^^^^^^^^---------------------------------------------------------------------------------------
  _k_: ↑ previous _t_: tasks     _m X_: projects  _T_: todo task  _g t_: tasks    _g X_: projects
  _j_: ↓ next     _i_: incubate  _m P_: personal  _S_: schedule   _g i_: incubate _g P_: personal
  _c_: archive    _p_: personal  _m T_: technical _D_: deadline   _g x_: inbox    _g T_: technical
  _d_: delete     _r_: refile                   _R_: rename     _g n_: notes    _g C_: completed
  "
    ("<up>" org-previous-visible-heading)
    ("<down>" org-next-visible-heading)
    ("k" org-previous-visible-heading)
    ("j" org-next-visible-heading)
    ("c" org-archive-subtree-as-completed)
    ("d" org-cut-subtree)
    ("t" org-refile-to-task)
    ("i" org-refile-to-incubate)
    ("p" org-refile-to-personal-notes)
    ("r" org-refile)
    ("m X" org-refile-to-projects-dir)
    ("m P" org-refile-to-personal-dir)
    ("m T" org-refile-to-technical-dir)
    ("T" org-todo)
    ("S" org-schedule)
    ("D" org-deadline)
    ("R" org-rename-header)
    ("g t" (find-file-other-window org-default-tasks-file))
    ("g i" (find-file-other-window org-default-incubate-file))
    ("g x" (find-file-other-window org-default-inbox-file))
    ("g c" (find-file-other-window org-default-completed-file))
    ("g n" (find-file-other-window org-default-notes-file))
    ("g X" (dired org-default-projects-dir))
    ("g P" (dired org-default-personal-dir))
    ("g T" (dired org-default-technical-dir))
    ("g C" (dired org-default-completed-dir))
    ("[\t]" (org-cycle))
    ("s" (org-save-all-org-buffers) "save")
    ("q" nil "quit"))
(define-key org-mode-map (kbd "C-c s") 'hydra-org-refiler/body)


(use-package org-agenda
  :ensure nil
  :after org
  :bind ("C-c a" . org-agenda)
  :custom
  (org-agenda-include-diary t)
  (org-todo-repeat-to-state t)
  ;; (org-agenda-prefix-format
  ;;  '((agenda . " %i %-12:c%?-12t% s")
  ;;    ;; Indent todo items by level to show nesting
  ;;    (todo . " %i %-12:c%l")
  ;;    (tags . " %i %-12:c")
  ;;    (search . " %i %-12:c")))
  ;; (org-agenda-custom-commands
  ;;  '(("c" "Simple agenda view"
  ;;     ((agenda "")
  ;;      (alltodo "")))))
  (org-agenda-start-on-weekday nil))

(use-package org-agenda
  :ensure nil
  :after org
  :config
  (setq org-agenda-tags-column org-tags-column)
  (setq org-agenda-sticky nil)
  (setq org-agenda-inhibit-startup nil)
  (setq org-agenda-dim-blocked-tasks nil)
  (setq org-agenda-compact-blocks nil)
  ;; Set the times to display in the time grid
  (setq org-agenda-time-grid
        (quote
         ((daily today remove-match)
          (800 1200 1600 2000)
          "......" "----------------")))

  (setq org-agenda-tags-todo-honor-ignore-options t)
  (setq org-deadline-warning-days 10)
  )
;;; _
(provide 'org-mode)
;;; org-mode.el ends here
