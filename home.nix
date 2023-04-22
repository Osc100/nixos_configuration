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
        chromium
        inkscape
        pkgs-unstable.obs-studio
        pkgs-unstable.discord
        pkgs-unstable.ferdium
        pkgs-unstable.lutris
        pkgs-unstable.obsidian
        pkgs-unstable.postman
        pkgs-unstable.youtube-music
        pkgs-unstable.cemu
        anydesk
        mpv
        remmina

        # cli-apps
        pkgs-unstable.mov-cli

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
        pkgs-unstable.nodePackages.eas-cli

        # -- rust
        rustup

        # nvchad
        gcc
        ripgrep      

        # gnome extensions
        pkgs-unstable.gnomeExtensions.unite
        pkgs-unstable.gnomeExtensions.caffeine
        gnomeExtensions.aylurs-widgets
        pkgs-unstable.gnomeExtensions.blur-my-shell
        pkgs-unstable.gnomeExtensions.burn-my-windows

        # gnome themes
        gnome.gnome-tweaks
        pkgs-unstable.catppuccin-gtk
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

