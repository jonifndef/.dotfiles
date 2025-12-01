{
  description = "Dynamic multi-environment PDE";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay/800a400cde11cbdc9296bc3246869495560d2c9e";
  };

  outputs =
    { nixpkgs, home-manager, self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];

      impure = builtins.getEnv "USER" != "";

      username = if impure then builtins.getEnv "USER" else "jonas";
      homeDir = if impure then builtins.getEnv "HOME" else "/home/jonas";
    in
    {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          {
            nixpkgs.overlays = overlays;
          }
        ];

        extraSpecialArgs = {
          username = "${username}";
          homeDirectory = "${homeDir}";
        };
      };
    };
}
