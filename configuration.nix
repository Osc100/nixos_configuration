{ config, pkgs, lib, ... }:
let
  pkgs-unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  networking = {
    hostName = "nixosc"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    wireless.enable = false;
  };

  time.timeZone = "America/Managua";

  # Enable the GNOME Desktop Environment.
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    input-remapper.enable = true;
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };
  };

  sound.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
  ];

  users.users.osc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanager" ];
    shell = pkgs.fish;
    initialPassword = "1234";
  };

  home-manager.users.osc = import ./home.nix { inherit pkgs pkgs-unstable config lib; };
  programs = {
    dconf.enable = true;
    fish = {
      enable = true;
      promptInit = ''
        any-nix-shell fish --info-right | source
        source (/run/current-system/sw/bin/starship init fish --print-full-init | psub)
      '';
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
  
  environment = {
    gnome.excludePackages = (with pkgs; [ gnome-tour gnome-console gnome-text-editor gnome-connections ]) ++ (
      with pkgs.gnome; [ geary ]
    );
    systemPackages = with pkgs; [
      # gui apps that can't be installed on home.nix
      input-remapper
      # command line apps
      killall
      any-nix-shell
      lsd
      btop
      htop
      curl
      git
      ranger
      wl-clipboard
      fzf
      bat
      lazygit
      pkgs-unstable.helix
      pkgs-unstable.nil

      # postgres 
      postgresql_15

      # fish
      pkgs-unstable.starship
      fishPlugins.fzf-fish
    ];
  };

  system.stateVersion = "22.11";
  swapDevices = [ { device = "/swap/swapfile"; } ];

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = "btrfs";
    };
    libvirtd = {
      enable = true;
    };
    vmVariant = {
      virtualisation = {
        memorySize = 2048;
        cores = 3;        
      };
    };
  };
}

