{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.user.gui.bar;
in
{
  options.user.gui.bar = with lib; {
    enable = mkEnableOption "Noctalia";
    useV5 = mkEnableOption "Noctalia v5";
    configuration = mkEnableOption "home-manager side Noctalia config management";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.useV5 {
        programs.noctalia = {
          enable = true;
          systemd.enable = true;
        };
      })
      (lib.mkIf (cfg.useV5 && cfg.configuration) {
        programs.noctalia.settings = {
          bar = {
            default = {
              center = [ "workspaces" ];
              end = [
                "tray"
                "notifications"
                "clipboard"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "control-center"
                "session"
              ];
              margin_ends = 50.0;
              start = [
                "launcher"
                "clock"
                "media"
              ];
            };
          };
          dock = {
            auto_hide = true;
            enabled = true;
            icon_size = 36;
          };
          idle = {
            behavior_order = [
              "lock"
              "screen-off"
              "suspend"
            ];
            behavior = {
              lock = {
                action = "lock";
                enabled = true;
                timeout = 30;
              };
              screen-off = {
                action = "screen_off";
                enabled = true;
                timeout = 3 * 60;
              };
              suspend = {
                action = "suspend";
                enabled = false;
                lock_before_suspend = true;
                timeout = 5 * 60;
              };
            };
          };
          nightlight = {
            enabled = true;
            temperature_night = 5500;
          };
          notification = {
            layer = "overlay";
          };
          widget = {
            network = {
              show_label = false;
            };
            notifications = {
              hide_when_no_unread = true;
            };
          };
        };
      })
      (lib.mkIf (!cfg.useV5) {
        home.packages = with pkgs; [ noctalia-shell ];
        warnings = lib.optionals (cfg.configuration) [
          "Home Manager side Noctalia configuration is not available with noctalia v4."
        ];
      })
    ]
  );
}
