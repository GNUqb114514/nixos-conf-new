{ pkgs, inputs, ... }:
{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
      };
      users.qb114514.imports = [
        inputs.users.homeModules.qb114514
      ];
    };

    networking.hostName = "laptop";

    boot.loader = {
      efi = {
        efiSysMountPoint = "/boot";
      };

      # GRUB supports folding previous generations, which make the interface clearer.
      grub = {
        enable = true;
        device = "nodev"; # No legacy bootloader required
        efiSupport = true; # Using UEFI
      };
    };

    nix.settings = {
      eval-cache = true;

      max-jobs = "auto";

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "recursive-nix"
      ];
      trusted-users = [ "qb114514" ];

      substituters = [
        "https://mirrors.sustech.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.iscas.ac.cn/nix-channels/store"
        "https://mirror.nju.edu.cn/nix-channels/store"
        "https://mirrors.cqupt.edu.cn/nix-channels/store"
        "https://mirror.nyist.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      builders-use-substitutes = true;
    };

    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
    time.timeZone = "Asia/Shanghai";
    i18n.defaultLocale = "zh_CN.UTF-8";

    hardware.graphics.enable = true;

    programs.zsh.enable = true;

    # The best choice at present
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

    hardware.uinput.enable = true;
    services.openssh.enable = true;

    users.mutableUsers = false;
    users.users."qb114514" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
      ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        tree
      ];
      hashedPassword = "$y$j9T$Aye4YC.G36h0XvpnAG0aP.$tJqA3ifHDHjC2wanjJ3UTLVAXJS88kFbV3HQ0Cl6bkC";
      shell = pkgs.zsh;
    };

    # TODO: Understand what this mess actually mean and come back to write better comments.
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "rtsx_usb_sdmmc"
      "r8169"
    ];
    boot.initrd.kernelModules = [ "r8169" ];
    boot.kernelModules = [
      "uinput"
      "kvm-intel"
      "r8169"
    ];
    boot.extraModulePackages = [ ];
    nixpkgs.hostPlatform = "x86_64-linux";

    # Enable firmwares and microcodes
    hardware.cpu.intel.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # This helps manage power status
    services.upower.enable = true;

    # This extends memory spaces, helping compiling massive flakes.
    zramSwap.enable = true;
    zramSwap.memoryPercent = 30;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.05"; # Did you read the comment?
  };

  imports = [
    ./laptop-disko.nix

    inputs.disko.nixosModules.disko
    inputs.watt.nixosModules.watt
    inputs.home-manager.nixosModules.home-manager
  ];
}
