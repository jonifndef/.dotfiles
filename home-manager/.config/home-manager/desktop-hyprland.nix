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

#  wayland.windowManager.hyprland = {
#    enable = true;
#    package = pkgs.hyprland;
#    xwayland.enable = true;
#  };

  home.packages = with pkgs; [
    hyprland
    #kitty
    kittyWrapped
    waybar
    cliphist
    wl-clipboard
    rofi
    hyprmon
    nerd-fonts.hack
    keychain
    wlr-randr
    hyprlock
    grim
    satty
    slurp
    wiremix
    networkmanagerapplet
    dunst
    hyprpaper
    xdg-desktop-portal-hyprland
  ];

  # The only applications that Home Mangager sets up are zsh with oh-my-zsh, the plugins, and fzf. Everything else is managed by standard dotfiles

  programs.zsh = {
    profileExtra = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        export PATH="$HOME/.nix-profile/bin:$PATH"
        exec start-hyprland > ~/hyprland-launch.log 2>&1
    fi
    '';
  };

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";

    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr";
      force = true;
    };

    ".config/swaylock" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/swaylock/.config/swaylock";
      force = true;
    };

    ".config/systemd/user/xdg-desktop-portal-hyprland.service" = {
      source = "${pkgs.xdg-desktop-portal-hyprland}/lib/systemd/user/xdg-desktop-portal-hyprland.service";
    };
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";

    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";  # avoids cursor glitches on nvidia
  };
}
