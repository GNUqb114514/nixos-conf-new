# -*- separedit-default-mode: emacs-lisp-mode; -*-
{
  pkgs,
  config,
  lib,
  ...
}:
{
  config.user.emacs.plugins = {
    keyfreq = {
      hook = {
        after-init-hook = [
          "keyfreq-mode"
          "keyfreq-autosave-mode"
        ];
      };
      custom = {
        keyfreq-excluded-commands = ''
          '(self-insert-command
                                                  forward-char
                                                  backward-char
                                                  previous-line
                                                  next-line)'';
      };
    };
    mwim = {
      bind = {
        _ = {
          "C-a" = "mwim-beginning-of-code-or-line";
          "C-e" = "mwim-end-of-code-or-line";
        };
      };
    };
    separedit = {
      bind._ = {
        "C-c '" = "separedit";
      };
      custom = {
        separedit-preserve-string-indentation = "t";
        separedit-continue-fill-column = "t";
      };
    };
  };
}
