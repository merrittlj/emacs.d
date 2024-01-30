(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(connection-local-criteria-alist
   '(((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-locpal-default-shell-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(custom-safe-themes
   '("69f7e8101867cfac410e88140f8c51b4433b93680901bb0b52014144366a08c8" "21e3d55141186651571241c2ba3c665979d1e886f53b2e52411e9e96659132d4" "fc608d4c9f476ad1da7f07f7d19cc392ec0fb61f77f7236f2b6b42ae95801a62" default))
 '(package-selected-packages
   '(markdown-mode default-font-presets modus-themes avy ivy-avy counsel ivy ace-window magit autothemer)))

(defun merritt/read-file-numeric (filename)
  "Return the numeric contents value of FILENAME."
  (with-temp-buffer
    (insert-file-contents filename)
    (string-to-number (buffer-string))))

(defun merritt/-scroll-percentage-decimal ()
  "Return the percentage scrolled through a window as a decimal(ex: 20% = 0.2, internal)."
  (/ (float (line-number-at-pos (window-start)))
     (float (line-number-at-pos (point-max)))
     )
  )

(defun merritt/-set-window-start-to-percentage (scroll-percentage)
  "Sets the window start to a percentage in the buffer(internal)."
  
  (goto-char (point-min))
  (let ((target-line-number (truncate (* (line-number-at-pos (point-max)) scroll-percentage))))  ; Get desired line number to start at(truncated result of the percentage and the total line count).
    (forward-line (1- target-line-number))
    )
  (set-window-start nil (point))  ; Start the window at the desired line number/current point(line number is now the first line displayed on the screen).
  )

(defun merritt/-render-markdown-preview-current-buffer ()  ; Actually render the current buffer as a Markdown file.
  "Renders a preview of the current buffer as a Markdown file(requires variables, internal)."
  
  (message "Rendering Markdown preview of %s" filename)
  
  (shell-command-on-region (point-min) (point-max) conversion-cmd output-name)  ; Convert the current buffer's Markdown into HTML.
  (switch-to-buffer-other-window output-name)  ; Switch to a different window containing the specified buffer, creating/opening a window or buffer if either is non-existent.

  (let ((dom (libxml-parse-html-region (point-min) (point-max))))  ; Parse HTML into Lisp "cons" list.
    (erase-buffer)
    
    ;; Renders the "cons" list into the current buffer(output-name buffer in this case).
    ;; Wraps HTML list with "base", which specifies what path relative URLs should base their resolution on.
    ;; Uses backquote-splicing to return everything literally except what is preceded with a comma(ex: below returns (base ((href . "file://test.md")) "test document") )
    (shr-insert-document `(base ((href . ,url)) ,dom))
    
    (setq buffer-read-only t)
    )
  )

(defun merritt/-markdown-preview-file (filename)  ; Fully preview a specified markdown file.
  "Fully preview the specified Markdown file in a new window with variables and additional features([scroll-save, relative URLs, etc.], internal)."

  (save-selected-window
    (find-file filename)
    (let ((url (concat "file://" filename))
          (output-name "*Markdown Preview*")
          (conversion-cmd "pandoc --from gfm+raw_html")
          (previous-scroll-percentage (merritt/-scroll-percentage-decimal)))
      (merritt/-render-markdown-preview-current-buffer)
      (merritt/-set-window-start-to-percentage previous-scroll-percentage)
      )
    )
  )

(defun merritt/markdown-preview (&optional filename)  ; Handle preview command when used interactively.
  "Previews a specified Markdown file(interactively/parameter), or default to the current buffer."

  (interactive "fFile: ")
  (if filename  ; Preview a specified file.
      (progn
        (merritt/-markdown-preview-file filename)
        (switch-to-buffer (current-buffer))  ; TODO: Does this open the Markdown editing file if it is not open?
        )
    (merritt/-markdown-preview-file buffer-file-name)  ; Preview the current buffer.
    )
  )

(add-hook 'markdown-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'merritt/markdown-preview nil t)))

(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(blink-cursor-mode 0)
(setq-default cursor-type `hbar)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4)
(setq c-basic-indent 4)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(setq c-default-style "gnu")

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(global-subword-mode)  ; Allow word interactions to be based/"work" with camelCase and similar.

(ivy-mode 1)
(counsel-mode 1)

(setq colir-compose-method nil)

(setq aw-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n))

(setq avy-timeout-seconds 0.5)

; Change ctl-x-map key and move transpose-chars elsewhere.
(global-set-key (kbd "C-t") ctl-x-map)
(global-set-key (kbd "C-x") 'transpose-chars)

; Move around functions of C-u/e/o for easier Dvorak-access.
(global-set-key (kbd "C-u") 'move-end-of-line)
(global-set-key (kbd "C-e") 'open-line)
(global-set-key (kbd "C-o") 'universal-argument)

; Change execute extended command(helm) to M-t and move transpose-words elsewhere.
(global-set-key (kbd "M-t") 'execute-extended-command)
(global-set-key (kbd "M-x") 'transpose-words)

(global-set-key (kbd "C-t C-f") 'magit-status)  ; Rebind magit-status.

(keyboard-translate ?\C-m ?\H-m)  ; Disambiguate C-m from <RET>, C-m translates to Hyper-m(shouldn't work in terminal mode!).
(global-set-key (kbd "H-m") 'ace-window)

; Change default i-search to Swiper i-search(displays results).
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'swiper-isearch-backward)

(define-key ivy-mode-map (kbd "M-s M-c") 'swiper-query-replace)  ; M-q for swiper is hard to reach.

(global-set-key (kbd "M-s M-t") 'avy-goto-char)
(global-set-key (kbd "M-s M-s") 'avy-goto-line)

(global-set-key (kbd "C-t C-g") 'ivy-switch-buffer)
(global-set-key (kbd "C-t g") 'ibuffer)
(global-set-key (kbd "C-t C-r") 'counsel-find-file)
(global-set-key (kbd "C-t C-b") 'find-file-read-only)


;; ensure ibuffer opens with point at the current buffer's entry.
(defadvice ibuffer
  (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name."
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-top-buffer recent-buffer-name)))
(ad-activate 'ibuffer)


;; (setq custom-theme-directory "~/.emacs.d/themes")
;; (load-theme `automata t)

(require 'modus-themes)
(setq modus-themes-disable-other-themes t)

(if (eq (merritt/read-file-numeric (concat (getenv "THEME_PATH") "theme.value")) 0)
    (progn
      (load-theme 'modus-operandi)
      (enable-theme 'modus-operandi)
      )
  (if (eq (merritt/read-file-numeric (concat (getenv "THEME_PATH") "theme.value")) 1)
      (progn
        (load-theme 'modus-vivendi)
        (enable-theme 'modus-vivendi)
        )
    )
  )

(setq default-frame-alist '((font . "Proggy Vector Dotted 14")))

;; For font testing
;; (setq default-font-presets-list
;;       (list
;;        "Anonymous Pro 12"
;;        "Fixedsys Excelsior 14"
;;        "Mononoki 12"
;;        "Monoid 10"
;;        "Input Mono 12"
;;        "Twilio Sans Mono 12"
;;        "Proggy Vector 12"
;;        "Monaspace Neon 12"
;;        "Monaspace Krypton 12"
;;        "Monaspace Argon 12"
;;        "DejaVu Sans Mono 12"
;;        "Hack 12"
;;        "Fira Code 12"
;;        "Source Code Pro 12"
;;        "Courier Prime 12"
;;        "Courier Prime Sans 12"
;;        "Courier Prime Code 12"
;;        "Monaspace Radon 12"
;;        "Monaspace Xenon 12"
;;        ))
;; (global-set-key (kbd "C-+") 'default-font-presets-forward)
;; (global-set-key (kbd "C-*") 'default-font-presets-backward)

;; (set-fontset-font t '(#Xefb0 . #Xefc5) "Fixedsys Excelsior")
;; (defconst fixedsys-excelsior-font-lock-keywords-alist
;;   (mapcar (lambda (regex-char-pair)
;; 	    `(,(car regex-char-pair)
;; 	      (0 (prog1 ()
;; 		   (compose-region (match-beginning 1)
;; 				   (match-end 1)
;; 				   ;; The first argument to concat is a string containing a literal tab
;; 				   ,(concat "	" (list (decode-char 'ucs (cadr regex-char-pair)))))))))
;; 	  '(("\\(>>=\\)"        #Xefb0)
;; 	    ("\\(=<<\\)"        #Xefb1)
;; 	    ("\\(<\\*>\\)"      #Xefb2)
;; 	    ("\\(<\\$>\\)"      #Xefb3)
;; 	    ("\\(::\\)"         #Xefb4)
;; 	    ("\\(:=\\)"         #Xefb5)
;; 	    ("\\(<<<\\)"        #Xefb6)
;; 	    ("\\(>>>\\)"        #Xefb7)
;; 	    ("\\(<>\\)"         #Xefb8)
;; 	    ("\\(/=\\)"         #Xefb9)
;; 	    ("\\({-\\)"         #Xefba)
;; 	    ("\\(-}\\)"         #Xefbb)
;; 	    ("\\(<|\\)"         #Xefbc)
;; 	    ("\\(|>\\)"         #Xefbd)
;; 	    ("\\(~>\\)"         #Xefbe)
;; 	    ("\\(<~\\)"         #Xefbf)
;; 	    ("\\(<~>\\)"        #Xefc0)
;; 	    ("\\(<^>\\)"        #Xefc1)
;; 	    ("\\(/\\\\\\)"      #Xefc2)
;; 	    ("\\(<|>\\)"        #Xefc3)
;; 	    ("\\(>=>\\)"        #Xefc4)
;; 	    ("\\(<=<\\)"        #Xefc5))))


;; (defun add-fixedsys-excelsior-symbol-keywords ()
;;   (font-lock-add-keywords nil fixedsys-excelsior-font-lock-keywords-alist))

;; (add-hook 'prog-mode-hook
;;           #'add-fixedsys-excelsior-symbol-keyword)

;; (global-font-lock-mode 0)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
