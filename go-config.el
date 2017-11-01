;;; go-config.el --- configure go-mode
;;; Commentary:
;;; Code:

(defun configure-go-packages ()
    "Configure go-mode."
    (use-package exec-path-from-shell)
    (use-package rainbow-delimiters)
    (use-package go-snippets)

    (use-package go-guru)
    (use-package go-mode
        ;; Godef jump key binding
        :bind (("M-." . godef-jump)
               ("M-*" . pop-tag-mark))
        :init
        (setenv "GOPATH" (concat (getenv "HOME") "/.local"))
        :config
        (defun set-exec-path-from-shell-PATH ()
            (let ((path-from-shell (replace-regexp-in-string
                                    "[ \t\n]*$"
                                    ""
                                    (shell-command-to-string "/bin/bash -c '. ~/.bashrc && echo $PATH'"))))
                (setenv "PATH" path-from-shell)
                ;; (setq eshell-path-env path-from-shell) ; for eshell users
                (setq exec-path (split-string path-from-shell path-separator))))

        (when window-system (set-exec-path-from-shell-PATH))

        (defun my-go-mode-hook ()
            "My Golang hook."
            (setq gofmt-command "goimports")

            ;; Call Gofmt before saving
            (add-hook 'before-save-hook 'gofmt-before-save)

            ;; Set compile command
            (if (not (string-match "go" compile-command))
                    (set (make-local-variable 'compile-command)
                         "go build -v && go test -v && go vet"))

            ;; Enable rainbow
            (rainbow-delimiters-mode-enable)
            (auto-complete-for-go)
            (yas-initialize))

        ;; Go autocomplete
        (use-package go-autocomplete)
        (defun auto-complete-for-go ()
            "Enable golang autocomple."
            (auto-complete-mode 1))

        (add-hook 'go-mode-hook 'auto-complete-for-go)
        (add-hook 'completion-at-point-functions 'go-complete-at-point)
        (add-hook 'go-mode-hook 'my-go-mode-hook)
        (add-hook 'go-mode-hook #'rainbow-delimiters-mode)))

(provide 'go-config)

;;; go-config.el ends here
