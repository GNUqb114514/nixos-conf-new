{
  pkgs,
  lib,
  config,
  ...
}@args:
let
  cfg = config.user.gui.niri;
  proportion = value: { proportion = value; };
  fixed = value: { fixed = value; };
in
{
  options.user.gui = with lib; {
    niri = {
      enable = mkEnableOption "GUI";
      xwayland = mkEnableOption "XWayland through xwayland-satellite";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.xwayland (with pkgs; [ xwayland-satellite ]);

    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;

    programs.niri.settings = {
      layout = {
        preset-column-widths = [
          (proportion (1. / 3.))
          (proportion (1. / 2.))
          (proportion (2. / 3.))
        ];
        gaps = 8;
      };

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 10.0;
            top-right = 10.0;
            bottom-right = 10.0;
            bottom-left = 10.0;
          };
          clip-to-geometry = true;
        }
      ];

      prefer-no-csd = true;

      spawn-at-startup = [ ];

      binds =
        with config.lib.niri.actions;
        lib.mkMerge [
          {
            # Window size
            "Mod+BracketLeft".action = consume-or-expel-window-left;
            "Mod+BracketRight".action = consume-or-expel-window-right;

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+R".action = switch-preset-column-width;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";

            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";

            # Floating
            "Mod+V".action = toggle-window-floating;
            "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

            # Miscellaneous
            "Print".action.screenshot = {
              show-pointer = true;
            };
            "Ctrl+Print".action.screenshot-screen = [ ];
            "Alt+Print".action.screenshot-window = [ ];

            "Mod+W".action = toggle-column-tabbed-display;

            "Mod+Tab".action.next-window = [ ];
            "Mod+Shift+Tab".action.previous-window = [ ];
            "Mod+grave".action.next-window = {
              filter = "app-id";
            };
            "Mod+Shift+grave".action.previous-window = {
              filter = "app-id";
            };

            "Mod+Shift+Slash".action = show-hotkey-overlay;

            "Mod+Q".action = close-window;
            "Mod+Shift+E".action = quit;
            "Mod+Shift+P".action = power-off-monitors;
          }
          # Window navigation and moving
          (import ./wm-movement-key-binding.nix args {
            mapping = {
              horizontal = {
                left = [
                  "Left"
                  "H"
                ];
                right = [
                  "Right"
                  "L"
                ];
              };
              vertical = {
                up = [
                  "Up"
                  "K"
                ];
                down = [
                  "Down"
                  "J"
                ];
              };
            };
            maps = {
              "Mod" = {
                horizontal = "focus-column";
                vertical = "focus-window";
              };
              "Mod+Ctrl" = {
                horizontal = "move-column";
                vertical = "move-window";
              };
              "Mod+Shift" = "focus-monitor";
              "Mod+Shift+Ctrl" = "move-column-to-monitor";
            };
          })
          # Monitor navigation and moving
          (import ./wm-movement-key-binding.nix args {
            mapping = {
              vertical = {
                up = [
                  "Page_Up"
                  "I"
                ];
                down = [
                  "Page_Down"
                  "U"
                ];
              };
            };
            maps = {
              "Mod" = {
                vertical = "focus-workspace";
              };
              "Mod+Ctrl" = {
                vertical = "move-column-to-workspace";
              };
              "Mod+Shift" = "move-workspace";
            };
          })
          (lib.listToAttrs (
            lib.flatten (
              map (x: [
                {
                  name = "Mod+${toString x}";
                  value.action = focus-workspace x;
                }
                {
                  name = "Mod+Ctrl+${toString x}";
                  value.action.move-column-to-workspace = x;
                }
              ]) (lib.range 1 9)
            )
          ))
        ];
    };
  };
}
