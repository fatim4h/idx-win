$installerUrl = "https://pkgs.tailscale.com/stable/tailscale-setup-latest.exe"
$installerPath = "C:\temp\tailscale-setup-latest.exe"
$logFilePath = "C:\temp\tailscale_install_log.txt"

# Start logging to a file
Start-Transcript -Path $logFilePath -Append

# Create the temp directory if it doesn't exist
if (-not (Test-Path "C:\temp")) {
    New-Item -ItemType Directory -Path "C:\temp"
}

# Download the Tailscale installer
Write-Host "[INFO] Downloading Tailscale installer..."
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
Write-Host "[INFO] Download complete."

# Install Tailscale silently
Write-Host "[INFO] Installing Tailscale..."
Start-Process -FilePath $installerPath -ArgumentList "/quiet" -Wait
Write-Host "[INFO] Installation complete."

# Authorizing tailscale
Write-Host "[INFO] Connecting to Tailnet..."
&"C:\Program Files\Tailscale\tailscale.exe" up --authkey="__AUTH__KEY__" --hostname "__TAILSCALE_HOSTNAME__" --accept-dns=false --reset --unattended --advertise-tags=tag:temp
Write-Host "[INFO] Connection to Tailnet complete."

# Stop logging
Stop-Transcript

# Keep the console open
Read-Host -Prompt "Press Enter to exit"