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

Write-Host "[INFO] Connecting to Tailnet..."
# Start-Process -FilePath "C:\Program Files\Tailscale\tailscale.exe" -ArgumentList "up", "--authkey=tskey-auth-kD2wv8ATzY11CNTRL-HBpKxRDZC5Ky6gdGRGae5K6jCw35GfUJ", "--accept-dns=false", "--reset", "--unattended", "--advertise-tags=tag:temp" -Wait
&"C:\Program Files\Tailscale\tailscale.exe" up --authkey="__AUTH__KEY__" --accept-dns=false --reset --unattended --advertise-tags=tag:temp
Write-Host "[INFO] Connection to Tailnet complete."
# Check if the Tailscale service is installed
# $serviceName = "tailscale"
# $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

# if ($service) {
#     Write-Host "[INFO] Tailscale service is installed."

#     # Check if the Tailscale service is running
#     if ($service.Status -eq 'Running') {
#         Write-Host "[INFO] Tailscale service is already running."
#     } else {
#         Write-Host "[INFO] Tailscale service is not running."
#         # Start the Tailscale service
#         Start-Service -Name $serviceName
#         # Set the service to start automatically
#         Set-Service -Name $serviceName -StartupType Automatic
#         Write-Host "[INFO] Tailscale service started and set to automatic."
#     }

#     Write-Host "[INFO] Connecting to Tailnet..."
#     # Start-Process -FilePath "C:\Program Files\Tailscale\tailscale.exe" -ArgumentList "up", "--authkey=tskey-auth-kD2wv8ATzY11CNTRL-HBpKxRDZC5Ky6gdGRGae5K6jCw35GfUJ", "--accept-dns=false", "--reset", "--unattended", "--advertise-tags=tag:temp" -Wait
#     &"C:\Program Files\Tailscale\tailscale.exe" up --authkey="__AUTH__KEY__" --accept-dns=false --reset --unattended --advertise-tags=tag:temp
#     Write-Host "[INFO] Connection to Tailnet complete."
#     # Connect the machine to Tailnet (unattended)
#     # Uncomment the line below if you want to connect automatically
#     # Jun 21, 2025
    
# } else {
#     Write-Host "[ERROR] Tailscale service is missing, make sure to install the software properly."
# }
# Stop logging
Stop-Transcript

# Keep the console open
Read-Host -Prompt "Press Enter to exit"