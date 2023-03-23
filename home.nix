{ pkgs, config, pkgs-unstable, ...}:
  {
    imports = [ ./dconf.nix ];
    nixpkgs.config = config.nixpkgs.config;
    home = {
      username = "osc";
      stateVersion = "22.11";
      packages = with pkgs; [
        # gui apps
        firefox
        inkscape
        pkgs-unstable.ferdium
        obsidian
        mpv
        pkgs-unstable.youtube-music
        remmina

        # wine
        wineWowPackages.stable

        # dev gui apps
        pkgs-unstable.vscode.fhs
        pkgs-unstable.android-studio
        pkgs-unstable.godot_4
        alacritty

        # virtualization
        gnome.gnome-boxes
        virt-manager

        # cli apps
        neovim # I only use it inside vscode. Helix ftw
        pkgs-unstable.ani-cli
        pkgs-unstable.dconf2nix

        # dev dependencies
        # -- python
        pkgs-unstable.python311
        pkgs-unstable.poetry 
        pkgs-unstable.python311Packages.pip
        pkgs-unstable.python311Packages.ipykernel

        # -- node js
        pkgs-unstable.nodejs
        pkgs-unstable.nodePackages.pnpm

        # -- rust
        rustup
     
        # gnome extensions
        pkgs-unstable.gnomeExtensions.unite
        pkgs-unstable.gnomeExtensions.caffeine
        gnomeExtensions.aylurs-widgets
        pkgs-unstable.gnomeExtensions.blur-my-shell
        pkgs-unstable.gnomeExtensions.burn-my-windows
        # gnome themes
        gnome.gnome-tweaks
        flat-remix-gnome
      ]; 
    };

    programs = {  
      home-manager.enable = true;
      alacritty = {
        enable = true;
      };
    };

    xdg.configFile = {
      "alacritty/alacritty.yml".source = ./alacritty/alacritty.yml;
      "helix/config.toml".source = ./helix/config.toml;
      "helix/languages.toml".source = ./helix/languages.toml;
    };
}

