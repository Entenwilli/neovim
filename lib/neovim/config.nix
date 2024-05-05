{
  pkgs,
  lib,
  appName,
  include-native-config,
}: let
  nativeConfig = pkgs.stdenv.mkDerivation {
    name = "${appName}-native-config";
    src = ../../nvim;
    dontBuild = true;
    installPhase = ''
      cp -r $src $out
    '';
  };
in
  pkgs.symlinkJoin {
    name = "${appName}-config";
    paths = lib.optionals include-native-config [nativeConfig];

    # config structure: $out/${appName}/init.lua
    # (the same as XDG_CONFIG_HOME)
    postBuild = ''
      mkdir $out/${appName}
      shopt -s extglob dotglob
      mv $out/!(${appName}) $out/${appName}
      shopt -u dotglob
    '';
  }
