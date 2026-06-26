final: prev: {
  kitty = prev.kitty.overrideAttrs (old: rec {
    pname = "kitty";
    version = "0.47.4";
    format = "other";

    src = prev.fetchFromGitHub {
      owner = "kovidgoyal";
      repo = "kitty";
      rev = "39ba5e271f4e3442bae349e71fdfc6c996358649";
      hash = "sha256-y4ykZ3luf+TcRllI+BVvD7XeVAkKKYEwfe1MUch8yS0=";
    };

    goModules = (prev.buildGoModule {
      pname = "kitty-go-modules";
      inherit src version;
      vendorHash = "sha256-C3ymNX/PeszRq9IYpH/VpXbaseg15BNemmHHBnp6B+g=";
    }).goModules;
  });
}
