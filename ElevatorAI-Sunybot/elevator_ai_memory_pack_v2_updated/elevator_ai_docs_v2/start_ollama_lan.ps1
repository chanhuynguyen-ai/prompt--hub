param(
    [string]$BindHost = "0.0.0.0",
    [int]$Port = 11434,
    [string]$RequiredGenModel = "qwen2.5:3b-instruct",
    [string]$RequiredEmbedModel = "nomic-embed-text",
    [switch]$KeepWindowOpen
)

$ErrorActionPreference = "SilentlyContinue"

function Write-Info($msg) {
    Write-Host "[INFO] $msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "[OK]   $msg" -ForegroundColor Green
}

function Write-WarnMsg($msg) {
    Write-Host "[WARN] $msg" -ForegroundColor Yellow
}

function Write-ErrMsg($msg) {
    Write-Host "[ERR ] $msg" -ForegroundColor Red
}

$ollamaExe = (Get-Command ollama.exe -ErrorAction SilentlyContinue).Source
if (-not $ollamaExe) {
    $ollamaExe = (Get-Command ollama -ErrorAction SilentlyContinue).Source
}
if (-not $ollamaExe) {
    Write-ErrMsg "Khong tim thay lenh 'ollama'. Hay cai Ollama truoc."
    if ($KeepWindowOpen) { Read-Host "Nhan Enter de dong" | Out-Null }
    exit 1
}

$targetHost = "$BindHost`:$Port"
$localApi = "http://127.0.0.1:$Port"
$bindApi = "http://$BindHost:$Port"

Write-Info "Dang khoi dong Ollama LAN..."
Write-Info "OLLAMA_HOST se duoc dat thanh: $targetHost"

# Stop old processes if any
Get-Process ollama -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process "ollama app" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process ollama_llama_server -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Open firewall rule if needed
$ruleName = "Ollama LAN $Port"
$existingRule = netsh advfirewall firewall show rule name="$ruleName" | Out-String
if ($existingRule -notmatch "Rule Name") {
    netsh advfirewall firewall add rule name="$ruleName" dir=in action=allow protocol=TCP localport=$Port | Out-Null
    Write-Ok "Da tao firewall rule cho port $Port"
} else {
    Write-Info "Firewall rule da ton tai cho port $Port"
}

# Set env and start serve
$env:OLLAMA_HOST = $targetHost
$proc = Start-Process -FilePath $ollamaExe -ArgumentList "serve" -PassThru -WindowStyle Minimized

Write-Info "Dang doi Ollama len..."
$maxTries = 20
$up = $false
for ($i = 1; $i -le $maxTries; $i++) {
    Start-Sleep -Seconds 1
    try {
        $null = Invoke-RestMethod -Method Get -Uri "$localApi/api/tags" -TimeoutSec 3
        $up = $true
        break
    } catch {
    }
}

if (-not $up) {
    Write-ErrMsg "Ollama khong phan hoi tai $localApi sau $maxTries giay."
    Write-WarnMsg "Hay mo PowerShell va chay tay:"
    Write-Host '$env:OLLAMA_HOST="0.0.0.0:11434"; ollama serve' -ForegroundColor White
    if ($KeepWindowOpen) { Read-Host "Nhan Enter de dong" | Out-Null }
    exit 1
}

Write-Ok "Ollama dang chay tai $localApi"

# Show IPv4 addresses useful for Jetson
Write-Info "Dia chi IPv4 hien tai cua Win11:"
Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -ne "127.0.0.1" -and
        $_.InterfaceAlias -notmatch "vEthernet|Loopback|VirtualBox|VMware|Hyper-V|WSL|Docker"
    } |
    Sort-Object InterfaceAlias |
    Format-Table InterfaceAlias, IPAddress -AutoSize

# Check models
try {
    $tags = Invoke-RestMethod -Method Get -Uri "$localApi/api/tags" -TimeoutSec 5
    $names = @($tags.models | ForEach-Object { $_.name })

    if ($names -contains $RequiredGenModel) {
        Write-Ok "Da tim thay model generate: $RequiredGenModel"
    } else {
        Write-WarnMsg "Chua tim thay model generate: $RequiredGenModel"
        Write-Host "Hay chay: ollama pull $RequiredGenModel" -ForegroundColor White
    }

    if (($names -contains $RequiredEmbedModel) -or ($names -contains "$RequiredEmbedModel`:latest")) {
        Write-Ok "Da tim thay model embedding: $RequiredEmbedModel"
    } else {
        Write-WarnMsg "Chua tim thay model embedding: $RequiredEmbedModel"
        Write-Host "Hay chay: ollama pull $RequiredEmbedModel" -ForegroundColor White
    }
} catch {
    Write-WarnMsg "Khong doc duoc /api/tags de kiem tra model."
}

Write-Host ""
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host "OLLAMA LAN READY" -ForegroundColor Green
Write-Host "API local : $localApi" -ForegroundColor White
Write-Host "Bind host : $bindApi" -ForegroundColor White
Write-Host "Test Win11:" -ForegroundColor Cyan
Write-Host "  curl.exe $localApi/api/tags" -ForegroundColor White
Write-Host "Jetson test (thay <WIN11_IP>):" -ForegroundColor Cyan
Write-Host "  curl http://<WIN11_IP>:$Port/api/tags" -ForegroundColor White
Write-Host "  curl -s http://<WIN11_IP>:$Port/api/generate -H ""Content-Type: application/json"" -d '{""model"":""$RequiredGenModel"",""prompt"":""Xin chao, ban la ai?"",""stream"":false}'" -ForegroundColor White
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host ""

if ($KeepWindowOpen) {
    Read-Host "Nhan Enter de dong cua so nay (Ollama van tiep tuc chay nen)" | Out-Null
}
