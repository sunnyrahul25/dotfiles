(setq user-full-name "Sunny Rahul"
      user-mail-address "sunny.rahul@tutanota.com")
(setq doom-font (font-spec :family "OpenSansCondensed" :size 18 :weight 'light))
(setq doom-theme 'modus-operandi)
(setq hl-line-mode 'f)
;; disable highlight line mode in emacs.
;;
(setq darkroom-text-scale-increase 1.1)

(setq display-line-numbers-type t)
(setq-default evil-escape-key-sequence "jk")
(setq-default evil-escape-delay 0.2)
(setq org-roam-directory "~/orgroamfiles/")

(setq-default line-spacing 2)
;;; Optional additional aesthetic changes
;; Adapted from `sanity.el' in Elegant Emacs by Nicolas P. Rougier (rougier)
;; https://github.com/rougier/elegant-emacs

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)
(setq-default indent-tabs-mode nil)
(setq pop-up-windows nil)
(tool-bar-mode 0)
(tooltip-mode  0)
(scroll-bar-mode 0)
(setq-default doom-modeline-mode 0)
(menu-bar-mode 0) ;menu bar is explicitly turned on for beginners. Change the value to 0.
(map! :leader "f a"#'helm-bibtex)  ; "find article" : opens up helm bibtex for search.
(map! :leader "o n"#'org-noter)    ; "org noter"  : opens up org noter in a headline
(map! :leader "r c i"#'org-clock-in); "routine clock in" : clock in to a habit.

(use-package! org
  :config
                                        ; Ricing
  (add-hook 'org-mode-hook
            (lambda ()
              (setq hl-line-mode nil)
              (darkroom-mode 1)))
  (setq org-directory "~/org/")
  (setq org-log-done 'time)
  (setq org-bullets-bullet-list '("∴" "◉" "○"))
  (setq display-line-numbers-type nil)
  (setq org-hidden-keywords '(title startup))
  (setq org-refile-allow-creating-parent-nodes 'confirm
        ))

(setq org-ref-notes-function
      (lambda (thekey)
        (let ((bibtex-completion-bibliography (org-ref-find-bibliography)))
          (bibtex-completion-edit-notes
           (list (car (org-ref-get-bibtex-key-and-file thekey)))))))
(defun bms/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-command "rg --null --ignore-case --type org --line-buffered --color=always --max-columns=500 --no-heading --line-number . -e ARG OPTS"))
    (consult-ripgrep org-roam-directory)))
(global-set-key (kbd "C-c rr") 'bms/org-roam-rg-search)
(setq org-roam-capture-templates
        '(("d" "default" plain
           (function org-roam-capture--get-point)
           "%?"
           :file-name "%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n\n"
           :unnarrowed t))
        org-roam-capture-ref-templates
        '(("r" "ref" plain
           (function org-roam-capture--get-point)
           ""
           :file-name "caps/${slug}"
           :head "#+TITLE: ${title}\n#+ROAM_KEY: ${ref}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n\n"
           :unnarrowed t)))
(defun my/navigate-note (arg &optional note choices)
  "Navigate notes by link. With universal ARG tries to use only to navigate the tags of the current note. Optionally takes a selected NOTE and filepaths CHOICES."
  (interactive "P")
  (let* ((choices (or
                   choices
                   (when arg (org-roam-db--links-with-max-distance (buffer-file-name) 1))))
         (all-notes (org-roam--get-title-path-completions))
         (completions
          (or (--filter (-contains-p choices (plist-get (cdr it) :path)) all-notes) all-notes))
         (title-with-tags (org-roam-completion--completing-read "File: " completions))
         (res (cdr (assoc title-with-tags completions)))
         (next-note (plist-get res :path)))
    (if (string= note next-note)
        (find-file note)
      (my/navigate-note nil next-note (org-roam-db--links-with-max-distance next-note 1)))))

(setq time-stamp-active t
      time-stamp-start "#\\+LAST_MODIFIED:[ \t]*"
      time-stamp-end "$"
      time-stamp-format "\[%Y-%02m-%02d %3a %02H:%02M\]")
(add-hook 'before-save-hook 'time-stamp nil)

(setq +org-roam-open-buffer-on-find-file nil)

(use-package deft
  :init
    (setq deft-extensions '("org" "md" "txt")
          deft-use-filename-as-title t
          deft-auto-save-interval 0
          deft-file-naming-rules '( (noslash . "-") ))
    (setq deft-directory "~/orgroamfiles/"))

(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   ;;org-noter-notes-window-location 'vertical
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   ;;org-noter-hide-other nil
   org-noter-notes-search-path (list "/home/rahul/orgroamfiles/")
   ;; Everything is relative to the main notes file
   ))

(setq org-directory "~/org/"
      org-ellipsis " ▼ "
      org-adapt-indentation nil
      org-habit-show-habits-only-for-today t)
(require 'org)
(require 'org-habit)
(defun jethro/org-archive-done-tasks ()
  "Archive all done tasks."
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file))
(require 'find-lisp)
(setq jethro/org-agenda-directory (file-truename "~/org/gtd/"))
(setq org-agenda-files
      (find-lisp-find-files jethro/org-agenda-directory "\.org$"))

;'(setq org-capture-templates
;'        `(("i" "Inbox" entry (file ,(expand-file-name "inbox.org" jethro/org-agenda-directory))
;'           ,(concat "* TODO %?\n"
;'                    "/Entered on/ %u"))))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

(setq org-log-done 'time
      org-log-into-drawer t
      org-log-state-notes-insert-after-drawers nil)

(setq org-tag-alist '(("@errand" . ?e)
                      ("@office" . ?o)
                      ("@home" . ?h)
                      (:newline)
                      ("CANCELLED" . ?c)))

;(setq org-agenda-prefix-format
;      '((agenda . " %i %-12:c%?-12t% s")
;        (todo   . " ")
;        (tags   . " %i %-12:c")
;        (search . " %i %-12:c")))

(setq org-fast-tag-selection-single-key nil)
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-targets '(("~/org/gtd.org" :maxlevel . 3)
                           ("~/org/gtd/someday.org" :level . 1)
                           (nil . (:level . 1))
                           ("~/org/gtd/online.org" :level . 1)
                           ("~/org/gtd/archive.org" :level . 4)
                           ("~/org/gtd/tickler.org" :maxlevel . 2)))
;(setq org-refile-allow-creating-parent-nodes 'confirm
;      org-refile-targets '((org-agenda-files . (:level . 1))))

(defvar jethro/org-agenda-bulk-process-key ?f
  "Default key for bulk processing inbox items.")

(defun jethro/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (custom/org-agenda-bulk-mark-regexp-category "inbox")
  (jethro/bulk-process-entries))

(defvar jethro/org-current-effort "1:00"
  "Current effort for agenda items.")

(defun jethro/my-org-agenda-set-effort (effort)
  "Set the effort property for the current headline."
  (interactive
   (list (read-string (format "Effort [%s]: " jethro/org-current-effort) nil nil jethro/org-current-effort)))
  (setq jethro/org-current-effort effort)
  (org-agenda-check-no-diary)
  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                       (org-agenda-error)))
         (buffer (marker-buffer hdmarker))
         (pos (marker-position hdmarker))
         (inhibit-read-only t)
         newhead)
    (org-with-remote-undo buffer
      (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (funcall-interactively 'org-set-effort nil jethro/org-current-effort)
        (end-of-line 1)
        (setq newhead (org-get-heading)))
      (org-agenda-change-all-lines newhead hdmarker))))

(defun jethro/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'jethro/my-org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(defun jethro/bulk-process-entries ()
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)
              (let (org-loop-over-headlines-in-active-region) (funcall 'jethro/org-agenda-process-inbox-item))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

(defun jethro/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(setq org-agenda-bulk-custom-functions '((jethro/org-agenda-bulk-process-key jethro/org-agenda-process-inbox-item)))

(map! :map org-agenda-mode-map
      "i" #'org-agenda-clock-in
      "s" #'jethro/clock-in-and-advance
      "q" #'jethro/org-process-inbox
      "R" #'org-agenda-refile
      "c" #'jethro/org-inbox-capture)

(defun jethro/advance-todo ()
  (org-todo 'right)
  (remove-hook 'org-clock-in-hook #'jethro/advance-todo))

(defun jethro/clock-in-and-advance ()
  (interactive)
  (add-hook 'org-clock-in-hook 'jethro/advance-todo)
  (org-agenda-clock-in))

(use-package! org-clock-convenience
  :bind (:map org-agenda-mode-map
              ("<S-up>" . org-clock-convenience-timestamp-up)
              ("<S-down>" . org-clock-convenience-timestamp-down)
              ("o" . org-clock-convenience-fill-gap)
              ("e" . org-clock-convenience-fill-gap-both)))

(use-package! org-agenda
  :init
  (map! "<f1>" #'jethro/switch-to-agenda)
  (setq org-agenda-block-separator nil
        org-agenda-start-with-log-mode t)
  (defun jethro/switch-to-agenda ()
    (interactive)
    (org-agenda nil " "))
  :config
  (defun jethro/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))

  (defun jethro/skip-projects ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
        next-headline)
       ((jethro/is-project-p)
        next-headline)
       (t
        nil)))))

  )


 (add-to-list 'org-agenda-custom-commands `("r" "Reading"
                                             ((todo "WRITING"
                                                    ((org-agenda-overriding-header "Writing")
                                                     (org-agenda-files '(,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory)))))
                                              (todo "READING"
                                                    ((org-agenda-overriding-header "Reading")
                                                     (org-agenda-files '(,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory)))))
                                              (todo "TO-READ"
                                                    ((org-agenda-overriding-header "To Read")
                                                     (org-agenda-files '(,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory))))))))
(setq jethro/org-agenda-todo-view
      `(" " "Agenda"
        ((agenda ""
                 ((org-agenda-span 'day)
                  (org-deadline-warning-days 365)))
         (todo "TODO"
               ((org-agenda-overriding-header "To Refile")
                (org-agenda-files '(,(concat jethro/org-agenda-directory "inbox.org")))))
         (todo "TODO"
               ((org-agenda-overriding-header "Emails")
                (org-agenda-files '(,(concat jethro/org-agenda-directory "emails.org")))))
         (todo "NEXT"
               ((org-agenda-overriding-header "In Progress")
                (org-agenda-files '(,(concat jethro/org-agenda-directory "someday.org")
                                    ,(concat jethro/org-agenda-directory "projects.org")
                                    ,(concat jethro/org-agenda-directory "next.org")))
                ))
         (todo "TODO"
               ((org-agenda-overriding-header "Projects")
                (org-agenda-files '(,(concat jethro/org-agenda-directory "projects.org")))
                ))
         (todo "TODO"
               ((org-agenda-overriding-header "One-off Tasks")
                (org-agenda-files '(,(concat jethro/org-agenda-directory "next.org")))
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
         nil)))

(add-to-list 'org-agenda-custom-commands `,jethro/org-agenda-todo-view)
(defun custom/org-agenda-bulk-mark-regexp-category (regexp)
    "Mark entries whose category matches REGEXP for future agenda bulk action."
    (interactive "sMark entries with category matching regexp: ")
    (let ((entries-marked 0) txt-at-point)
      (save-excursion
        (goto-char (point-min))
        (goto-char (next-single-property-change (point) 'org-hd-marker))
        (while (and (re-search-forward regexp nil t)
                    (setq category-at-point
                          (get-text-property (match-beginning 0) 'org-category)))
          (if (get-char-property (point) 'invisible)
              (beginning-of-line 2)
            (when (string-match-p regexp category-at-point)
              (setq entries-marked (1+ entries-marked))
              (call-interactively 'org-agenda-bulk-mark)))))
      (unless entries-marked
        (message "No entry matching this regexp."))))

(require 'org-protocol)
(use-package! org-roam-protocol
  :after org-protocol)
(add-to-list 'org-capture-templates `("c" "org-protocol-capture" entry (file+olp ,(expand-file-name "reading_and_writing_inbox.org" org-roam-directory) "The List")
                                      "* TO-READ [[%:link][%:description]] %^g"
                                      :immediate-finish t))

(use-package org-ref
    :config
    (setq
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-default-bibliography (list "/home/rahul/bibliography/zotlib.bib")
         org-ref-bibliography-notes "/home/rahul/orgroamfiles/"
         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
;         org-ref-notes-directory "/home/rahul/orgroamfiles/"
    ))
(setq
 bibtex-completion-notes-path "/home/rahul/orgroamfiles/"
 bibtex-completion-bibliography "/home/rahul/bibliography/zotlib.bib"
 bibtex-completion-pdf-field "file"
 bibtex-completion-notes-template-multiple-files
 (concat
  "${title}\n"
  "#+ROAM_KEY: cite:${=key=}\n"
  "* TODO Notes\n"
  ":PROPERTIES:\n"
  ":Custom_ID: ${=key=}\n"
  ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
  ":AUTHOR: ${author-abbrev}\n"
  ":JOURNAL: ${journaltitle}\n"
  ":DATE: ${date}\n"
  ":YEAR: ${year}\n"
  ":DOI: ${doi}\n"
  ":URL: ${url}\n"
  ":END:\n\n"
  )
 )
;; Tell org-ref to let helm-bibtex find notes for it
(setq org-ref-notes-function
      (lambda (thekey)
    (let ((bibtex-completion-bibliography (org-ref-find-bibliography)))
      (bibtex-completion-edit-notes
       (list (car (org-ref-get-bibtex-key-and-file thekey)))))))
(setq bibtex-completion-library-path '("/home/rahul/Zotero/storage"))
(setq bibtex-completion-pdf-field "file")
(setq bibtex-completion-additional-search-fields '(keywords))



(after! org-journal
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-time-prefix "* "
        org-journal-carryover-items nil))

(use-package! org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))

(setq org-download-screenshot-method "shotgun -g $(hacksaw) %s")
(setq-default org-download-image-dir "/home/rahul/orgroamfiles/Screenshots")
(add-hook 'dired-mode-hook 'org-download-enable)

(use-package! yequake
  :config
  (setq yequake-frames
   '(("org-capture"
      (buffer-fns . (yequake-org-capture))
      (width . 0.75)
      (height . 0.5)
      (alpha . 0.95)
      ))))

(defun org-toggle-properties ()
  "Toggle visibility of property drawers."
  (interactive)
  (if (eq (get 'org-toggle-properties-hide-state 'state) 'hidden)
      (progn
        (org-show-properties)
        (put 'org-toggle-properties-hide-state 'state 'shown))
    (progn
      (org-hide-properties)
      (put 'org-toggle-properties-hide-state 'state 'hidden))))
(defun org-show-properties ()
  "Show all org-mode property drawers hidden by org-hide-properties."
  (interactive)
  (remove-overlays (point-min) (point-max) 'hidden-prop-drawer t))
(defun org-hide-properties ()
  "Hide all org-mode headline property drawers in buffer. Could be slow if buffer has a lot of overlays."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward
            "^ *:properties:\n\\( *:.+?:.*\n\\)+ *:end:\n" nil t)
      (let ((ov_this (make-overlay (match-beginning 0) (match-end 0))))
        (overlay-put ov_this 'display "")
        (overlay-put ov_this 'hidden-prop-drawer t)))))

(use-package! ox-hugo
  :after org)

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

(defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
    (org-roam-server-mode 1)
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port)))

(defun current-task-to-status ()
  (interactive)
  (with-temp-file "~/.emacs.d/.task"
    (if (org-clocking-p)
        (insert (org-clock-get-clock-string))
        (insert "No active clock"))))
'(run-with-timer 0 10 'current-task-to-status)

(add-hook 'org-mode-hook 'org-appear-mode)
