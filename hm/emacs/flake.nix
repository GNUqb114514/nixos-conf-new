# -*- separedit-default-mode: emacs-lisp-mode; -*-
{
  description = "My simple system configuration - Emacs configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nixpkgs,
      systems,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }@top:
      {
        imports = [ ];
        systems = import systems;
        flake = {
          homeModules.emacs =
            {
              config,
              lib,
              pkgs,
              ...
            }:
            let
              cfg = config.user.emacs;
            in
            {
              options.user.emacs = with lib; {
                enable = mkEnableOption "Emacs";
                pgtk = mkEnableOption "Emacs PGTK (instead of XWayland)";
                plugins = mkOption {
                  description = "Extra plugins for Emacs";
                  type =
                    with types;
                    let
                      pluginSpec = {
                        package = mkOption {
                          description = "The package used as the plugin.";
                          type = nullOr (functionTo (nullOr package));
                        };
                        requirements = mkOption {
                          description = "The plugins this plugin requires.

                                         Note that this does not ensure the required plugins are installed.";
                          type = listOf str;
                          default = [ ];
                        };
                        condition = mkOption {
                          description = "The condition that should meet before the plugin is loaded, in plain Elisp.";
                          type = nullOr str;
                          default = null;
                        };
                        initPhase = mkOption {
                          description = "Elisp code to run before the plugin is loaded";
                          type = lines;
                          default = "()";
                        };
                        prefacePhase = mkOption {
                          description = "Elisp code to run before the anything is loaded";
                          type = lines;
                          default = "()";
                        };
                        configPhase = mkOption {
                          description = "Elisp code to run after the plugin is loaded";
                          type = lines;
                          default = "()";
                        };
                        bind = mkOption {
                          description = "Key bindings for the plugin";
                          type = lazyAttrsOf (lazyAttrsOf str);
                          default = { };
                        };
                        custom = mkOption {
                          description = "Custom variables for the plugin";
                          type = lazyAttrsOf str;
                          default = { };
                        };
                        hook = mkOption {
                          description = "Hook definitions for the plugin";
                          type = lazyAttrsOf (listOf str);
                          default = { };
                        };
                        extraConfig = mkOption {
                          description = "Extra config in the use-packages block";
                          type = lines;
                          default = "";
                        };
                      };
                    in
                    lazyAttrsOf (submodule {
                      options = pluginSpec;
                    });
                };
              };

              imports = [
                ./emacs.nix
              ];

              config = lib.mkIf cfg.enable {
                services.emacs = {
                  client.enable = true;
                  enable = true;
                  defaultEditor = true;
                };
                programs.emacs = {
                  enable = true;
                  package = lib.mkIf cfg.pgtk pkgs.emacs-pgtk;
                  extraPackages =
                    epkgs:
                    (
                      builtins.filter (a: a != null) (
                        lib.concatMap (
                          { name, value }: if value.package == null then [ epkgs.${name} ] else [ (value.package epkgs) ]
                        ) (lib.attrsToList cfg.plugins)
                      )
                    );
                  extraConfig = (
                    lib.concatMapStringsSep "\n" (
                      { name, value }:
                      let
                        bindSpec = mapping: args: ''
                          :bind (${if map != null then ":map ${mapping}" else "; Global Mapping"}
                          ${lib.concatMapAttrsStringSep "" (key: val: "${key} . ${val}") args})
                        '';
                      in
                      ''
                        (use-package ${name}
                          ${if value.condition == null then "; No condition" else ":if ${value.condition}"} 
                          ${
                            if builtins.length value.requirements != 0 then
                              ":after (${builtins.concatStringSep " " value.requirements})"
                            else
                              "; No requirements"
                          }
                          ${if value.initPhase != null then ":init ${value.initPhase}" else "; No init"}
                          ${if value.prefacePhase != null then ":preface ${value.prefacePhase}" else "; No preface"}
                          ${if value.configPhase != null then ":config ${value.configPhase}" else "; No config"}
                          ${
                            if builtins.length (builtins.attrNames value.custom) != 0 then
                              ":custom ${lib.concatMapAttrsStringSep "" (name: value: "(${name} ${value})") value.custom}"
                            else
                              "; No custom"
                          }
                          ${lib.concatMapStrings ({ name, value }: bindSpec name value) (lib.attrsToList value.bind)}
                          ${
                            if builtins.length (builtins.attrNames value.hook) != 0 then
                              ":hook (${
                                lib.concatMapAttrsStringSep " " (
                                  hook: funcs:
                                  if builtins.isList funcs then
                                    lib.concatMapStringsSep " " (func: "(${hook} . ${func})") funcs
                                  else
                                    "(${hook} . ${funcs})"
                                ) value.hook
                              })"
                            else
                              "; No hooks"
                          }
                          ${value.extraConfig}
                        )
                      ''
                    ) (lib.attrsToList cfg.plugins)
                  );
                };
              };
            };
        };
      }
    );
}
