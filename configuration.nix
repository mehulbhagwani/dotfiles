{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    # This Mac already has Homebrew at /opt/homebrew. Adopt it in place instead
    # of failing/reinstalling on the first switch.
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    # SAFETY: "none" never uninstalls anything not listed here. Do NOT set this
    # to "zap"/"uninstall" until every existing package is declared below,
    # or it will remove your current brews/casks. Inventory of what you have
    # today is in ~/dotfiles-backup-2026-07-19/brew-{leaves,casks}.txt.
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    # Curate from the backed-up inventory when ready. cleanup="none" so listing
    # these installs them without removing anything else you already have.
    brews = [
      "herdr"       # Kun's terminal agent multiplexer (herdr.dev)
    ];
    casks = [
    ];
  };
}
