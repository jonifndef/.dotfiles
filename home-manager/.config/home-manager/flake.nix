{
  description = "Home Manager configuration of ubuntu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      impure = builtins.getEnv "USER" != "";

      username = if impure then builtins.getEnv "USER" else "ubuntu";
      homeDir = if impure then builtins.getEnv "HOME" else "/home/ubuntu";
    in
    {
      homeConfigurations = {
        "${username}-headless" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./headless.nix
        ];

        extraSpecialArgs = {
          username = "${username}";
          homeDirectory = "${homeDir}";
        };
      };

      "${username}-desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./desktop.nix
        ];

        extraSpecialArgs = {
          username = "${username}";
          homeDirectory = "${homeDir}";
        };
      };
    };
  };
}
