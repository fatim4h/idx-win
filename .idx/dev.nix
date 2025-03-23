# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [ 
    pkgs.docker
    pkgs.htop
   ];
  # Sets service
  services = {
    docker = {
      enable = true;
    };
  };
  # Sets environment variables in the workspace
  env = {

  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [ ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        # install =
        #   "npm ci --prefer-offline --no-audit --no-progress --timing && npm i @expo/ngrok@^4.1.0";
      };
      # Runs when a workspace restarted
      onStart = {
        start-htop = ''htop'';
        start-windows = ''
          sh "$PWD/start.sh"
        '';
        # windows = ''
        #   echo -e "\033[1;33mWaiting for Android emulator to be ready...\033[0m"
        #   # Wait for the device connection command to finish
        #   adb -s emulator-5554 wait-for-device && \
        #   npm run android -- --tunnel
        # '';
      };
    };
    # Enable previews and customize configuration
    previews = {
      # enable = true;
      # previews = {
        # web = {
        #   command = [ "npm" "run" "web" "--" "--port" "$PORT" ];
        #   manager = "web";
        # };
        # android = {
        #   # noop
        #   command = [ "tail" "-f" "/dev/null" ];
        #   manager = "web";
        # };
      # };
    };
  };
}
