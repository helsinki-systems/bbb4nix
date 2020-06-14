# Since our AppArmor module is not really in a showable state, this is a stub
# with the required options that does nothing. We should really fix our module...
{ lib, ... }: with lib;
{
  options = with types; {
    systemd.services = mkOption {
      type = attrsOf (submodule ({ name, config, ... }: {
        options.apparmor = {
          enable = mkOption {
            type = bool;
            default = false;
            description = "Stub option";
          };

          packages = mkOption {
            type = listOf (either str package);
            default = [];
            description = "Stub option";
          };

          extraConfig = mkOption {
            type = nullOr lines;
            default = null;
            description = "Stub option";
          };
        };
      }));
    };
  };
}
