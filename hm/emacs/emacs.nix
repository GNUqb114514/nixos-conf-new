# -*- separedit-default-mode: emacs-lisp-mode; -*-
{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = {
    user.emacs.plugins = {
      emacs = {
        package = epkgs: null; # A way to say there's nothing to install.
        custom = {
          word-wrap-by-category = "t";
          confirm-kill-emacs = "#'yes-or-no-p";
          display-line-numbers-type = "'relative";

          auto-revert-avoid-polling = "t";
          auto-revert-interval = "5";

          make-backup-files = "nil";
          auto-save-default = "nil";
          create-lockfiles = "nil";
          recentf-save-file = "nil";
          frame-resize-pixelwise = "t";

          split-height-threshold = "40";
          split-width-threshold = "100";
          indent-tabs-mode = "nil";
        };

        hook = {
          after-init-hook = [
            "column-number-mode"
            "global-display-line-numbers-mode"
            "global-auto-revert-mode"
          ];
          prog-mode = [
            "electric-pair-mode"
            "show-paren-mode"
            "hs-minor-mode"
            "kill-ring-deindent-mode"
          ];
        };

        configPhase = ''
          (tool-bar-mode -1)
          (scroll-bar-mode -1)
        '';
      };
    };
  };
}
