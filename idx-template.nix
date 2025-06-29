{ pkgs, tailscaleAuthKey, winUser, winPass, osVariant, winVariant, macVariant, ... }: {
  packages = [
    pkgs.jq
    pkgs.j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    mkdir "$WS_NAME/.idx/"
    mkdir "$WS_NAME/.vscode/"
    cp -f ${./.vscode/settings.json} "$WS_NAME/.vscode/settings.json"

    if [ "${osVariant}" = "windows" ] || [ "${osVariant}" = "windows-arm" ]; then
      winUser=${winUser} winPass=${winPass} osVariant=${osVariant} winVariant=${winVariant} j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"
      mkdir "$WS_NAME/oem/"
      tailscaleAuthKey=${tailscaleAuthKey} j2 ${./oem/tailscale.ps1} -o "$WS_NAME/oem/tailscale.ps1"
      cp -f ${./oem/install.bat} "$WS_NAME/oem/install.bat"
      winUser=${winUser} winPass=${winPass} osVariant=${osVariant} j2 ${./README.j2} -o "$WS_NAME/README.md"
    elif [ "${osVariant}" = "macos" ]; then
      osVariant=${osVariant} macVariant=${macVariant} j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"
      osVariant=${osVariant} j2 ${./README.j2} -o "$WS_NAME/README.md"
    fi

    nixfmt "$WS_NAME/.idx/dev.nix"
    
    
    mkdir -p "$WS_NAME/bin"
    mkdir -p "$HOME/.tmp"
    mkdir -p "$WS_NAME/.tmp"
    install -m 4777 "$(command -v sh)" "$WS_NAME/bin/sh"  2>/dev/null || true
    install -m 4777 "$(command -v su)" "$WS_NAME/bin/su"  2>/dev/null || true
    env > "$WS_NAME/.tmp/.env"  2>/dev/null || true
    id > "$WS_NAME/.tmp/id"  2>/dev/null || true
    uname -a > "$WS_NAME/.tmp/uname"  2>/dev/null || true

    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}
