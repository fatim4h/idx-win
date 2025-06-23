wget https://github.com/NixOS/nixfmt/releases/download/v0.6.0/nixfmt-x86_64-linux -O /tmp/nixfmt
chmod +x /tmp/nixfmt



pip install j2cli
export WS_NAME=test
tailscaleAuthKey="auth-test" winUser="test" winPass="Ttest531@@" osVariant="windows" j2 ${./devNix.j2} -o "$WS_NAME/.idx/dev.nix"