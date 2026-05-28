{ config, lib, ... }:
{ mapping, maps }:
let
  recipe-generator = (
    { mapping, maps }:
    {
      modifier = maps.name;
      prefix = if builtins.isAttrs maps.value then maps.value.${mapping.name} else maps.value;
      keys = mapping.value;
    }
  );
  recipe = lib.mapCartesianProduct recipe-generator {
    mapping = lib.attrsToList mapping;
    maps = lib.attrsToList maps;
  };
in
lib.listToAttrs (
  map
    (
      { name, value }:
      {
        # Turn string actions into acceptable values by niri.
        inherit name;
        value.action = config.lib.niri.actions.${value};
      }
    )
    (
      lib.flatten (
        map (
          # Converts a recipe into a mapping.
          #
          # A recipe is like
          #   {
          #     keys = { left = [ "Up" "K" ]; };
          #     modifier = "Mod";
          #     prefix = "focus-window";
          #   }
          # and this turns it into
          #   [
          #     {
          #       name = "Mod+Up";
          #       value = "focus-window-left";
          #     }
          #     ...
          #   ]
          #
          # It is not very hard to understand, and I think you can ask
          # LLM for help.
          {
            keys,
            modifier,
            prefix,
          }:
          map (
            { name, value }:
            map (value: {
              # Combine modifier and action name.
              name = "${modifier}+${value}";
              value = "${prefix}-${name}";
            }) value
          ) (lib.attrsToList keys)
        ) recipe
      )
    )
)
