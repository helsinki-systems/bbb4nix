{ pkgs, lib }: with lib;
rec {
  mkHoconConfig = prefix: config:
    if isList config then "[ ${concatStringsSep ", " (map (mkHoconConfig "") config)} ]"
      else if isBool config then if config then "on" else "off"
        else if isString config then ''"${config}"''
          else if !(isAttrs config) then toString config
            else (concatStringsSep "\n" (mapAttrsToList (n: v: "${prefix}${n}" +
              (if isAttrs v then " {\n" else " = ") + (mkHoconConfig "${prefix}  " v) + (optionalString (isAttrs v) "\n${prefix}}")) config));

  mkHoconFile = name: config: pkgs.writeText name ((mkHoconConfig "" config) + "\ninclude file(\"/var/lib/secrets/bigbluebutton/${name}\")");

  hoconType = with types; let
    valueType = oneOf [
      bool
      int
      float
      str
      (lazyAttrsOf valueType)
      (listOf valueType)
    ];
  in valueType // {
    description = "AKKA configuration";
    emptyValue.value = {};
  };
}
