{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs }:
    let
      hosts = import ./hosts.nix;
      mkHost = host: user:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit user host; };
          modules = [
            ./configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              # checkLinkTargets aborts the whole user activation if any target
              # already exists as a real file. Tools installed by the Homebrew
              # step - which runs earlier in the same switch - create some of
              # them, so move them aside instead of failing the bootstrap.
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit user host; };
              home-manager.users.${user} = import ./home.nix;
            }
          ];
        };
    in
    {
      darwinConfigurations = builtins.mapAttrs (host: spec: mkHost host spec.user) hosts;
    };
}
