{ config, pkgs, username, homeDirectory, inputs, ... }:

let
  nixgl = inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system};
  kittyWrapped = pkgs.writeShellScriptBin "kitty" ''
    exec ${nixgl.nixGLDefault}/bin/nixGL ${pkgs.kitty}/bin/kitty "$@"
  '';
in
{
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
  home.username = username;
  home.homeDirectory = homeDirectory;

  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    kittyWrapped
    cliphist
    wl-clipboard
    rofi
    nerd-fonts.hack
    keychain
    wlr-randr
    grim
    satty
    slurp
    wiremix
    networkmanagerapplet
    dunst
  ];

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
}
