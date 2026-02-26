{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [
          sketchybar
        ];

        shellHook = ''
          exec ${pkgs.zsh}/bin/zsh
        '';
      };
    };
}
