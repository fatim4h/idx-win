{ pkgs, tailscaleAuthKey, winUser, winPass, osVariant, ... }: {
  packages = [
    pkgs.jq
    pkgs.j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    mkdir "$WS_NAME/.idx/"

    # Pass all parameters including osVariant to the template
    winUser=${winUser} winPass=${winPass} osVariant=${osVariant} j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"
    nixfmt "$WS_NAME/.idx/dev.nix"

    # Copy OS-specific files based on variant
    if [ "${osVariant}" = "windows" ] || [ "${osVariant}" = "windows-arm" ]; then
      mkdir "$WS_NAME/oem/"
      tailscaleAuthKey=${tailscaleAuthKey} j2 ${./oem/tailscale.ps1} -o "$WS_NAME/oem/tailscale.ps1"
      cp -f ${./oem/install.bat} "$WS_NAME/oem/install.bat"
    fi

    # Generate appropriate README based on OS variant
    cp ${./README.j2} "$WS_NAME/README.md"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}
