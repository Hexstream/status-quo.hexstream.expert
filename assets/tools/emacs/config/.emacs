;;;; This is the .emacs init file of Jean-Philippe Paradis (Hexstream).
;;;; I have not yet documented and cleaned this so it's very raw.
;;;; There's a lot of old shit I don't even use and should delete...

(package-initialize)

(require 'cl)

;;;; Most of my simple environment setup config files (such as
;;;; ~/.emacs) are now symlinks to files in published git repos.
(setf vc-follow-symlinks t)

(require 'iso-transl)

(setq-default indent-tabs-mode nil)
(setf indent-tabs-mode nil)
(setf dired-listing-switches "-alh")

;; Don't break C-j, one of my favorite commands...
(setf electric-indent-mode nil)

(set-language-environment "UTF-8")
(setf slime-load-failed-fasl 'never)


(setf make-backup-files nil)
(setf enable-recursive-minibuffers t)

(setf read-quoted-char-radix 16)

;;;enable slime
;(setf inferior-lisp-program "sbcl --noinform --end-runtime-options")
(setf slime-lisp-implementations
      '((sbcl ("sbcl" "--noinform" "--end-runtime-options")
              :coding-system utf-8-unix)
        (ccl ("ccl")
             :coding-system utf-8-unix)
        (clisp ("clisp" "-K" "full")
               :coding-system utf-8-unix)
        (abcl ("TODO") :coding-system utf-8-unix)
        (ecl ("ecl"))
        (lw ("lispworks")
            :coding-system utf-8-unix)
        (alisp ("alisp")
               :coding-system utf-8-unix)))
(setf slime-default-lisp 'sbcl)
(add-to-list 'load-path "/usr/local/bin/")
(setf quicklisp-slime-helper-dist "ultralisp")
(load (expand-file-name "~/quicklisp/slime-helper.el"))


(load (expand-file-name "~/quicklisp/clhs-use-local.el") t)
(setf browse-url-browser-function 'browse-url-generic)
(setf browse-url-generic-program "google-chrome")


(add-hook 'slime-connected-hook
          (lambda ()
            (setf tramp-default-method "ssh")
            (make-directory "/tmp/slime-fasls/" t)
            (setf slime-compile-file-options '(:fasl-directory "/tmp/slime-fasls/"))))
(add-hook 'lisp-mode-hook
          '(lambda ()
             (set (make-local-variable 'require-final-newline) 'ask-when-saving)
             (setf indicate-buffer-boundaries '((bottom . left)))))
(require 'slime)

(slime-setup '(slime-fancy slime-asdf))
(set-variable 'slime-sbcl-manual-root
              "/home/hexstream/apps/sbcl/share/doc/sbcl/html/sbcl/index.html")

;;;misc
(global-font-lock-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode t)
(setf inhibit-startup-message t)
(setf Info-scroll-prefer-subnodes nil)
(setf line-move-visual nil)
(setf next-screen-context-lines 1)
(setf x-stretch-cursor t) ; Cursor as large as TAB, for instance.
;(setf slime-autodoc-use-multiline-p t) C-c C-d A


;;;Only one space after the dot of the end of a sentence.
(setf sentence-end-double-space nil)
(setf default-sentence-end sentence-end)
(setf sentence-end "[.?!][]\"')]*\\($\\|\t\\| \\)[ \t\n]*")


;;;my custom commands
(global-set-key "\M-\#" 'slime-selector)
(fset 'wrap "(\206)\202\C-f \C-b")


(defun .emacs ()
  (interactive)
  (find-file "/home/hexstream/.emacs"))

(defun .sbclrc ()
  (interactive)
  (find-file "/home/hexstream/.sbclrc")
  (lisp-mode))

(fset 'parens "()\C-b")
(fset 'brackets "[]\C-b")
(fset 'curlys "{}\C-b")
(fset 'angles "<>\C-b")
(fset 'quotes "\"\"\C-b")
(global-set-key [f32] 'parens)
(global-set-key [S-f32] 'brackets)
(global-set-key [C-S-f32] 'curlys)
(global-set-key [C-f32] 'quotes)

(setf hexstream-map (make-sparse-keymap))
(global-set-key "\M-p" 'backward-paragraph)
(global-set-key "\M-n" 'forward-paragraph)
(global-set-key "\C-t" hexstream-map)
(define-key hexstream-map "w" 'wrap)
(define-key hexstream-map "i" 'slime-reindent-defun)
(define-key hexstream-map "y" 'clipboard-yank)
(define-key hexstream-map "s" 'replace-string)
(define-key hexstream-map "b" 'browse-url-of-file)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(add-hook 'slime-connected-hook
          (lambda ()
            (make-directory "/tmp/slime-fasls/" t)
            (setf slime-compile-file-options '(:fasl-directory "/tmp/slime-fasls/"))
            (slime-set-default-directory "/home/hexstream/data/projects/")))


(autoload 'hexstream-html-doc-mode
  (expand-file-name "~/data/projects/lisp/not-yet-ready/hexstream-html-doc-mode/hexstream-html-doc-mode.el")
  nil t nil)

(push '("\\.html" . hexstream-html-doc-mode) auto-mode-alist)

(setf eval-expression-print-level nil
      eval-expression-print-length nil)

;; dns-mode-soa-increment-serial is broken, at least in Emacs 24.3.1.
(setf dns-mode-soa-auto-increment-serial nil)

(server-start)

;; For transient project-specific stuff, mostly keyboard macros.
;; For example, using "C-x C-k b" to assign the last keyboard macro to "s-h f" instead of the more awkward "C-x C-k F".
(define-prefix-command 'hexstream-map)
(global-set-key (kbd "s-h") 'hexstream-map)

(add-to-list 'load-path "~/apps/pov-mode")
(autoload 'pov-mode "pov-mode" "PoVray scene file mode" t)
(add-to-list 'auto-mode-alist '("\\.pov\\'" . pov-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . pov-mode))
(setf pov-indent-level 4)

;(require 'js-comint)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;custom stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-server "irc.freenode.net")
 '(safe-local-variable-values
   (quote
    ((Package . ccl)
     (Package . CCL)
     (package . asdf)
     (Package . DRAKMA)
     (package . puri)
     (Package . CL-PPCRE)
     (Package . CL-USER)
     (syntax . COMMON-LISP)
     (Package ITERATE :use "COMMON-LISP" :colon-mode :external)
     (Package . Xlib)
     (Log . clx\.log)
     (lisp-version . "7.0 [Windows] (Dec 28, 2004 17:34)")
     (cg . "1.54.2.17")
     (Package . utils-kt)
     (Syntax . Common-Lisp)
     (Package . cells)
     (Package . Demos)
     (Syntax . Common-lisp)
     (Package . XLIB)
     (Lowercase . Yes)
     (Package . FLEXI-STREAMS)
     (Syntax . ANSI-Common-Lisp)
     (Syntax . COMMON-LISP)
     (Package . HUNCHENTOOT)
     (Base . 10)
     (unibyte . t)
     (Package . COMMON-LISP-USER))))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu ((((type x-toolkit)) (:weight normal :height 140 :width normal :family "geneva"))))
 '(slime-repl-output-mouseover-face ((t (:inherit slime-repl-inputed-output-face)))))

(put 'narrow-to-page 'disabled nil)

(put 'set-goal-column 'disabled nil)

(add-to-list 'auto-mode-alist '("\\.asd\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js2-mode))

(ielm)
(put 'narrow-to-region 'disabled nil)

(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)
