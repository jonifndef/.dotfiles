{ config, pkgs, username, homeDirectory, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    neovim
    ripgrep
    tmux
    nodejs_20
    fzf
  ];

  # The only applications that Home Mangager sets up are zsh with oh-my-zsh, the plugins, and fzf. Everything else is managed by standard dotfiles

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
}
