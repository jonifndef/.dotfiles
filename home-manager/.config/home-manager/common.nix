{ config, pkgs, username, homeDirectory, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    neovim
    ripgrep
    ripgrep-all
    fd
    tmux
    nodejs_22
    fzf
    eza
    bat

    # dependencies
    git
    curl
  ];

  # The only applications that Home Mangager sets up are zsh with oh-my-zsh, the plugins, and fzf. Everything else is managed by standard dotfiles

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    profileExtra = ''
    if [ - $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
    '';

    oh-my-zsh = {
      enable = true;
      theme = "garyblessington";
      plugins = [ "git" "wd" ];
    };

    initContent = ''
      export PATH="$HOME/.local/bin:$HOME/.local/bin/scripts:$HOME/.devcontainers/bin:$HOME/.cargo/bin:$PATH"

      eval $(keychain --quiet --eval id_ed25519)

      alias ls='eza --icons=always --color=auto --group-directories-first'
      alias ll='eza --all --long --icons=always --color=auto --group-directories-first'
      alias ..='cd ..'
      alias ...='cd ../../'
      alias nano='nvim'
      alias vi='nvim'
      alias fuck='pkill -9'
      alias ':q'=exit
      alias rg='rg -i --color=auto'
      alias cat='bat'

      bindkey '^n' autosuggest-accept

      ENABLE_CORRECTION="false"
      unsetopt correct_all
      unsetopt correct

      GIT_EDITOR=nvim
    '';

  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--reverse" ]; # To make fzf prompt appear at the top
  };

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";
    ".local/bin/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/scripts/.local/bin/scripts";
    ".config/bat/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/bat/.config/bat/config";
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
}
