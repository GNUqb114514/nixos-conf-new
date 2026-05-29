{ inputs }:
{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.wget ];

  home.username = "qb114514";
  home.homeDirectory = "/home/qb114514";

  programs.git = {
    enable = true;
    settings.user = {
      name = "qb114514";
      email = "GNUqb114514@outlook.com";
    };
  };

  programs.home-manager.enable = true;

  user.gui = {
    niri = {
      enable = true;
      xwayland = true;
    };

    bar = {
      enable = true;
      useV5 = true;
      configuration = true;
    };
  };

  imports = [ inputs.hm.homeModules.default ];

  home.stateVersion = "24.11";
}
