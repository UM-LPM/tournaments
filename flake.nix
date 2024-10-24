{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;
    flake-utils.url = github:numtide/flake-utils;
    build-gradle-application.url = github:raphiz/buildGradleApplication;
  };
  outputs = { self, nixpkgs, flake-utils, build-gradle-application, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [build-gradle-application.overlays.default];
      };

      mkEars = pkgs.callPackage ./nix/ears.nix {};
    in
    {
      packages.submissions.minimal = mkEars {
        pname = "minimal";
        version = "1.0.0";
        src = ./submissions/minimal;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [ pkgs.gradle pkgs.jdk11 ];
      };

    }) // {
      nixosModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.ears;

          boot-detect = pkgs.writeScript "boot-detect" ''
            ${pkgs.mount}/bin/mount -t tmpfs -o size=1 tmpfs /boot-detect
          '';
    
          submission = pkgs.writeScript "submission" ''
            if [[ -f /boot-detect ]]
            then
              echo "BOOT"
            else
              ${lib.getExe self.packages.x86_64-linux.submissions.minimal}
            fi
          '';
        in
        {
          systemd.services.boot-detect = {
            description = "Submissions service";
            wantedBy = [ "multi-user.target" ];
            wants = [ "submissions.service" ];

            serviceConfig = {
              ExecStart = lib.getExe boot-detect;
            };
          };
          systemd.services.submissions = {
            description = "Submissions service";
            wantedBy = [ "multi-user.target" ];
            
            serviceConfig = {
              User = "ears";
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = lib.getExe submission;
            };
          };

        };
    };
}
