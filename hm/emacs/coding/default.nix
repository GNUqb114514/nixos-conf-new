{
  pkgs,
  config,
  lib,
  ...
}:
{
  config.user.emacs.plugins = {
    ben = {
      bind = { ben-mode-map = {
        "C-c e" = "ben-command-map";
      }; };
      initPhase = ''
        (add-hook 'after-init-hook #'ben-global-mode 99)
      '';
    };
  };
}
