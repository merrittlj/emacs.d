(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1);
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(blink-cursor-mode 0)
(setq-default cursor-type `hbar)

(set-frame-font "Anonymous Pro 12")

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
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)


(setq custom-theme-directory "~/.emacs.d/themes")
(load-theme `st t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(connection-local-criteria-alist
   '(((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
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
 '(package-selected-packages '(avy ivy-avy counsel ivy ace-window magit autothemer)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
