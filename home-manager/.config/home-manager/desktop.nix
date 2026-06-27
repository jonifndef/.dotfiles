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
  ];

  # The only applications that Home Mangager sets up are zsh with oh-my-zsh, the plugins, and fzf. Everything else is managed by standard dotfiles

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    profileExtra = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec ${nixgl.nixGLDefault}/bin/nixGL ${pkgs.hyprland}/bin/Hyprland
    fi

    if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
    '';

    oh-my-zsh = {
      enable = true;
      theme = "garyblessington";
      plugins = [ "git" "wd" ];
    };

    # Pass the "impure" flag to home.nix, and if it is set, check if a
    # custom environment variable is set (something akin to "IS_DEV_CONTAINER").
    # This env variable should be passed when running 'Docker run'.
    # If so, set the prompt to something like "dev_container~"
    initContent = ''
      alias ls='LC_COLLATE=C ls --color=auto --group-directories-first'
      alias ll='LC_COLLATE=C ls -lah --color=auto --group-directories-first'
      alias ..='cd ..'
      alias ...='cd ../../'
      alias nano='nvim'
      alias vi='nvim'
      alias fuck='pkill -9'
      alias ':q'=exit

      bindkey '^n' autosuggest-accept

      ENABLE_CORRECTION="false"
      unsetopt correct_all
      unsetopt correct

      # Prompt
      unset -f prompt_garyblessington_setup 2>/dev/null
      PROMPT='%F{cyan}devcontainer%f %B%F{green}%~%f%b '
      RPROMPT=""
    '';

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--reverse" ]; # To make fzf prompt appear at the top
  };

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr";
      force = true;
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
