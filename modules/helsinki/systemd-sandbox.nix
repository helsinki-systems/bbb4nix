# This is essentially the same as the helsinki module, but
# with the warnings removed (they depend on the machine owner).
{ config, lib, ... }:
with lib;
let
  toplevelConfig = config;
  isset = attrs: name: (attrs ? name) -> attrs.name != null;
  # mkDefault is 1000
  # assignment is 100
  # This ensures that service defaults are overwritten, while
  # giving the administrator a chance to just override by assigning.
  mkDefaulter = mkOverride 999;
in {
  options = {
    systemd.services = with types; mkOption {
      type = attrsOf (submodule ({ name, config, ... }: {
        options.sandbox = mkOption {
          description = ''
            Level of confinement for this particular unit.

            0 is no confinement at all.
            1 is most confinement (probably good enough).
            2 is the current state of confinement.
          '';
          default = 0;
          type = enum [ 0 1 2 ];
        };

        config = mkMerge [
          (mkIf (config.sandbox >= 1) {
            serviceConfig = mapAttrs (_: mkDefaulter) {
              # Filesystem stuff
              # TODO Force for phpfpm
              ProtectSystem = "strict"; # Prevent writing to most of /
              ProtectHome = true; # Prevent accessing /home and /root
              PrivateTmp = true; # Give an own directory under /tmp
              PrivateDevices = true; # Deny access to most of /dev
              ProtectKernelTunables = true; # Protect some parts of /sys
              ProtectControlGroups = true; # Remount cgroups read-only
              RestrictSUIDSGID = true; # Prevent creating SETUID/SETGID files
              PrivateMounts = true; # Give an own mount namespace

              # Capabilities
              CapabilityBoundingSet = ""; # Allow no capabilities at all
              NoNewPrivileges = true; # Disallow getting more capabilities. This is also implied by other options.

              # Kernel stuff
              ProtectKernelModules = true; # Prevent loading of kernel modules
              SystemCallArchitectures = "native"; # Usually no need to disable this
              ProtectKernelLogs = true; # Prevent access to kernel logs
              ProtectClock = true; # Prevent setting the RTC

              # Networking
              RestrictAddressFamilies = ""; # Example: "AF_UNIX AF_INET AF_INET6"
              PrivateNetwork = true; # Isolate the entire network

              # Misc
              LockPersonality = true; # Prevent change of the personality
              ProtectHostname = true; # Give an own UTS namespace
              RestrictRealtime = true; # Prevent switching to RT scheduling
              MemoryDenyWriteExecute = true; # Maybe disable this for interpreters like python
              PrivateUsers = true; # If anything randomly breaks, it's mostly because of this
            };

            apparmor.enable = mkDefault true;
          })
          (mkIf (config.sandbox >= 2) {
            serviceConfig = mapAttrs (_: mkDefaulter) {
              RestrictNamespaces = true;
              RemoveIPC = true;
              UMask = "0077";
            };
          })
        ];
      }));
    };
  };
}
