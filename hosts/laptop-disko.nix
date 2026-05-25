# Split disko config to make formatting easier
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        # No device config in favor of disko-install command-line
        type = "disk";
        content = {
          type = "gpt";

          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "8G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";

                subvolumes = {
                  "@root" = {
                    # Root subvolume
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd:1"
                      "discard=async"
                    ];
                  };
                  "@journal" = {
                    # Journal subvolume
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd:3" # Compress rate added so journals will cost less space
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
