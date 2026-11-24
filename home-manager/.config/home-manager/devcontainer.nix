{ config, pkgs, username, homeDirectory, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
  home.username = username;
  home.homeDirectory = homeDirectory;

  imports = [
    ./common.nix
  ];

  programs.zsh = {
    # Pass the "impure" flag to home.nix, and if it is set, check if a
    # custom environment variable is set (something akin to "IS_DEV_CONTAINER").
    # This env variable should be passed when running 'Docker run'.
    # If so, set the prompt to something like "dev_container~"
    initContent = ''
      # Prompt
      unset -f prompt_garyblessington_setup 2>/dev/null
      PROMPT='%F{cyan}''${DEVCONTAINER_NAME:-devcontainer}%f %B%F{green}%~%f%b%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%} '
      RPROMPT=""
    '';

  };
}
