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
(helm-mode 1)

; Change ctl-x-map key and move transpose-chars elsewhere.
(global-set-key (kbd "C-t") ctl-x-map)
(global-set-key (kbd "C-x") 'transpose-chars)

; Move around functions of C-u/e/o for easier Dvorak-access.
(global-set-key (kbd "C-u") 'move-end-of-line)
(global-set-key (kbd "C-e") 'open-line)
(global-set-key (kbd "C-o") 'universal-argument)

; Change execute extended command(helm) to M-t and move transpose-words elsewhere.
(global-set-key (kbd "M-t") 'helm-M-x)  ; helm with execute-extended-command.
(global-set-key (kbd "M-x") 'transpose-words)

(global-set-key (kbd "C-t g") 'magit-status)  ; Rebind magit-status.

; Bind misc. helm functions.
(global-set-key (kbd "C-t C-f") 'helm-find-files)

; Change default i-search to Swiper i-search(displays results).
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'swiper-isearch-backward)
(global-set-key (kbd "M-p") 'swiper-query-replace)

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
 '(custom-safe-themes
   '("1a2d351d3190916c5fa3773a70a5fa89f72c00506bd84bfbaac250aa6b12fc04" "6b06958b5e02b76d565f2940949e9dc119b09fdf53693e7963e9e1ee3f1f4262" "cbbe67291b1b58dfd483f8eebc25fed3348512a6a770cecd661347163028c980" "a4646825aeaba37191110073353defd9451fa0b98109d1081159e4f48899d115" "eb0968f62d67c4d6070c8a513c5d6c1532898129e86c4d90fa4cc50959fc5af4" "4f4263e9db7511fe2ccc05ac2cfd324b251954d001e5262143bcc6d6b9f3bf2b" "5fd2dc500575f7ce10ade0ee1bb69811d820f0094c0edf379bcf545e20a7d987" "6a779995eb3d29114d7d8a6759fd6cd07532f5220280957519007662b2d35d84" "ce5769c33fafea5a89230fd736fabbd17e8f9d0239762702efa036bc1855142c" "42cd7c9dbc39dfbc112fa78c723ee3af89d449afedf88fdef51207c8d1557a9f" default))
 '(package-selected-packages '(swiper-helm helm ace-window autothemer)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
