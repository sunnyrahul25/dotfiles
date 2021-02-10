;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sunny Rahul"
      user-mail-address "sunny.rahul@tutanota.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;(setq doom-font (font-spec :family "Fira Mono" :size 20 :weight 'light)
;      doom-big-font (font-spec :family "Fira Mono" :size 26)
;      doom-variable-pitch-font (font-spec :family "Iosevka Aile"))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'modus-operandi)
(setq hl-line-mode 'f)
;; disable highlight line mode in emacs.
;;
(setq darkroom-text-scale-increase 1.1)
(add-hook 'org-mode-hook
          (lambda ()
            (setq hl-line-mode nil)
            (darkroom-mode 1)))


;; If you use `org' and don't want your org files in the default location below,
;;
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
(use-package deft
  :init
    (setq deft-extensions '("org" "md" "txt")
          deft-use-filename-as-title t
          deft-file-naming-rules '( (noslash . "-") ))
    (setq deft-directory "~/orgroamfiles/"))

(after! org-roam
  (setq org-roam-directory "~/orgroamfiles/"))


(use-package org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   org-noter-notes-window-location 'horizontal
   ;; Please stop opening frames
   org-noter-always-create-frame nil
   ;; I want to see the whole file
   ;;org-noter-hide-other nil
   org-noter-notes-search-path (list "/home/rahul/orgroamfiles/")
   ;; Everything is relative to the main notes file
   )
  )

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

(use-package org-ref
    :config
    (setq
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-default-bibliography (list "/home/rahul/bibliography/zotlib.bib")
         org-ref-bibliography-notes "/home/rahul/orgroamfiles/"
         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
;         org-ref-notes-directory "/home/rahul/orgroamfiles/"
    ))
;
;
;
;; Org Agenda
(setq org-agenda-files '("~/gtd/inbox.org"
                         "~/gtd/gtd.org"
                         "~/gtd/classes.org"
                         "~/gtd/habits.org"
                         "~/gtd/tickler.org"))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; Beautification
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

;org journal
(after! org-journal
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-carryover-items nil))

;org-download

(use-package! org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))

;;-----------------
;; Org
;;-----------------
(use-package! org
  :config
  ; Ricing
  (setq org-log-done 'time)
  (setq org-bullets-bullet-list '("∴" "◉" "○"))
  (setq display-line-numbers-type nil)
  (setq org-hidden-keywords '(title startup))
  (setq org-refile-targets '(("~/gtd/gtd.org" :maxlevel . 3)
                           ("~/gtd/someday.org" :level . 1)
                           (nil . (:level . 1))
                           ("~/gtd/online.org" :level . 1)
                           ("~/gtd/archive.org" :level . 4)
                           ("~/gtd/tickler.org" :maxlevel . 2)))
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/gtd/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/gtd/tickler.org" "Tickler")
                               "* %i%? \n %U")))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "NEXT(n)" "|" "DONE(d)" "CANCEL(c)")))

)
; Auto save
;; http://ergoemacs.org/emacs/emacs_auto_save.html
(defun open-file-external (file)
  (interactive "f")
  (let ((process-connection-type nil))
    (start-process
     "" nil shell-file-name
     shell-command-switch
     (format "nohup 1>/dev/null 2>/dev/null xdg-open %s"
             (expand-file-name file)))))
(defun xah-save-all-unsaved ()
  "Save all unsaved files. no ask.
Version 2019-11-05"
  (interactive)
  (save-some-buffers t ))

(if (version< emacs-version "27")
    (add-hook 'focus-out-hook 'xah-save-all-unsaved)
  (setq after-focus-change-function 'xah-save-all-unsaved))

; org roam  do open buffer every time I open a file.
(remove-hook 'find-file-hook #'+org-roam-open-buffer-maybe-h)
(add-hook 'dired-mode-hook 'org-download-enable)
(add-hook 'org-mode-hook 'hl-line-mode 0)
