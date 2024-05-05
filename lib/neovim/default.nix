{
  neovim,
  neovimUtils,
  wrapNeovimUnstable,
  callPackage,
  lib,
  appName ? "entenvim",
  viAlias ? false,
  vimAlias ? false,
  self-contained ? true,
  include-native-config ? true,
  tmp-cache ? self-contained,
}: let
  config = callPackage ./config.nix {inherit appName include-native-config;};
  deps = callPackage ./dependencies.nix {};
  extraWrapperArgs =
    [
      "--set"
      "NVIM_APPNAME"
      appName
    ]
    ++ lib.optionals (deps != []) [
      "--suffix"
      "PATH"
      ":"
      "${lib.makeBinPath deps}"
    ]
    ++ lib.optionals self-contained [
      "--add-flags"
      "-u"
      "--add-flags"
      "'${config}/${appName}/init.lua'"
      "--prefix"
      "XDG_CONFIG_DIRS"
      ":"
      "${config}"
    ]
    ++ lib.optionals tmp-cache [
      "--set"
      "XDG_CACHE_HOME"
      "/tmp/${appName}-cache"
    ];

  neovimConfig = neovimUtils.makeNeovimConfig {
    inherit viAlias vimAlias;
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
  };

  nvim = wrapNeovimUnstable neovim (
    neovimConfig
    // {
      wrapperArgs = neovimConfig.wrapperArgs ++ extraWrapperArgs;
      wrapRc = false;
    }
  );
in
  lib.attrsets.recursiveUpdate nvim {
    passthru = {
      inherit config;
    };
  }
