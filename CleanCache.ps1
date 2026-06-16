# CleanCache.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Color Palette (Modern Clean Zinc Dark Theme)
$colorBg = [System.Drawing.Color]::FromArgb(9, 9, 11)          # #09090b (Zinc-950)
$colorCard = [System.Drawing.Color]::FromArgb(24, 24, 27)      # #18181b (Zinc-900)
$colorBorder = [System.Drawing.Color]::FromArgb(39, 39, 42)    # #27272a (Zinc-800)
$colorText = [System.Drawing.Color]::FromArgb(250, 250, 250)   # #fafafa (Zinc-50)
$colorSubtext = [System.Drawing.Color]::FromArgb(113, 113, 122)# #71717a (Zinc-500)
$colorAccent = [System.Drawing.Color]::FromArgb(59, 130, 246)  # #3b82f6 (Blue-500)
$colorSuccess = [System.Drawing.Color]::FromArgb(34, 197, 94)  # #22c55e (Green-500)
$colorWarning = [System.Drawing.Color]::FromArgb(234, 179, 8)  # #eab308 (Yellow-500)
$colorError = [System.Drawing.Color]::FromArgb(239, 68, 68)    # #ef4444 (Red-500)
$colorConsoleBg = [System.Drawing.Color]::FromArgb(9, 9, 11)   # #09090b (Zinc-950)

# Form Utama
$form = New-Object System.Windows.Forms.Form
$form.Text = "Cache Cleaner Windows Pro"
$form.Size = New-Object System.Drawing.Size(500, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = $colorBg
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false
try {
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
} catch {}

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Windows Cache Cleaner Pro"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(460, 35)
$titleLabel.TextAlign = "MiddleCenter"
$titleLabel.ForeColor = $colorText
$form.Controls.Add($titleLabel)

# Info Label
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "Pilih cache yang ingin dibersihkan. Sesi login browser tetap aman."
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$infoLabel.Location = New-Object System.Drawing.Point(20, 50)
$infoLabel.Size = New-Object System.Drawing.Size(460, 25)
$infoLabel.TextAlign = "MiddleCenter"
$infoLabel.ForeColor = $colorSubtext
$form.Controls.Add($infoLabel)

# Card Border Panel
$cardBorder = New-Object System.Windows.Forms.Panel
$cardBorder.Location = New-Object System.Drawing.Point(20, 80)
$cardBorder.Size = New-Object System.Drawing.Size(445, 160)
$cardBorder.BackColor = $colorBorder
$form.Controls.Add($cardBorder)

# Card Panel
$cardPanel = New-Object System.Windows.Forms.Panel
$cardPanel.Location = New-Object System.Drawing.Point(1, 1)
$cardPanel.Size = New-Object System.Drawing.Size(443, 158)
$cardPanel.BackColor = $colorCard
$cardBorder.Controls.Add($cardPanel)

# Checkbox untuk setiap browser
$checkboxes = @{}
$browsers = @{
    "Chrome" = @{
        Path = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
        SessionPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Session Storage"
        LoginPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data"
    }
    "Edge" = @{
        Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
        SessionPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Session Storage"
        LoginPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Login Data"
    }
    "Firefox" = @{
        Path = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles" 
        SessionPath = "$env:APPDATA\Mozilla\Firefox\Profiles"
        LoginPath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    }
    "Opera" = @{
        Path = "$env:LOCALAPPDATA\Opera Software\Opera Stable\Cache"
        SessionPath = "$env:LOCALAPPDATA\Opera Software\Opera Stable\Session Storage"
        LoginPath = "$env:LOCALAPPDATA\Opera Software\Opera Stable\Login Data"
    }
    "Brave" = @{
        Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache"
        SessionPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Session Storage"
        LoginPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Login Data"
    }
}

# Kolom 1 (Chrome, Edge, Firefox, Opera)
$yOffset = 15
$c1 = @("Chrome", "Edge", "Firefox", "Opera")
foreach ($browser in $c1) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $browser
    $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $checkbox.Location = New-Object System.Drawing.Point(25, $yOffset)
    $checkbox.Size = New-Object System.Drawing.Size(150, 30)
    $checkbox.Checked = $true
    $checkbox.ForeColor = $colorText
    $cardPanel.Controls.Add($checkbox)
    $checkboxes[$browser] = $checkbox
    $yOffset += 35
}

# Kolom 2 (Brave, Recycle Bin, Pilih Semua)
$checkboxBrave = New-Object System.Windows.Forms.CheckBox
$checkboxBrave.Text = "Brave"
$checkboxBrave.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$checkboxBrave.Location = New-Object System.Drawing.Point(230, 15)
$checkboxBrave.Size = New-Object System.Drawing.Size(150, 30)
$checkboxBrave.Checked = $true
$checkboxBrave.ForeColor = $colorText
$cardPanel.Controls.Add($checkboxBrave)
$checkboxes["Brave"] = $checkboxBrave

$checkboxRB = New-Object System.Windows.Forms.CheckBox
$checkboxRB.Text = "Recycle Bin"
$checkboxRB.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$checkboxRB.Location = New-Object System.Drawing.Point(230, 50)
$checkboxRB.Size = New-Object System.Drawing.Size(150, 30)
$checkboxRB.Checked = $true
$checkboxRB.ForeColor = $colorText
$cardPanel.Controls.Add($checkboxRB)
$checkboxes["Recycle Bin"] = $checkboxRB

# Select All Checkbox
$selectAll = New-Object System.Windows.Forms.CheckBox
$selectAll.Text = "Pilih Semua"
$selectAll.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$selectAll.Location = New-Object System.Drawing.Point(230, 120)
$selectAll.Size = New-Object System.Drawing.Size(150, 30)
$selectAll.Checked = $true
$selectAll.ForeColor = $colorAccent
$cardPanel.Controls.Add($selectAll)

$selectAll.Add_CheckedChanged({
    foreach ($cb in $checkboxes.Values) {
        $cb.Checked = $selectAll.Checked
    }
})

# Status Label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Status: Siap"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$statusLabel.Location = New-Object System.Drawing.Point(20, 255)
$statusLabel.Size = New-Object System.Drawing.Size(460, 20)
$statusLabel.ForeColor = $colorSuccess
$form.Controls.Add($statusLabel)

# Console Border Panel
$consoleBorder = New-Object System.Windows.Forms.Panel
$consoleBorder.Location = New-Object System.Drawing.Point(20, 280)
$consoleBorder.Size = New-Object System.Drawing.Size(445, 210)
$consoleBorder.BackColor = $colorBorder
$form.Controls.Add($consoleBorder)

# Log RichTextBox
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(1, 1)
$logBox.Size = New-Object System.Drawing.Size(443, 208)
$logBox.ReadOnly = $true
$logBox.BackColor = $colorConsoleBg
$logBox.ForeColor = $colorText
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$logBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$consoleBorder.Controls.Add($logBox)

# Log Helper
function Write-Log {
    param(
        [string]$text,
        [System.Drawing.Color]$color = $colorText
    )
    $logBox.SelectionStart = $logBox.TextLength
    $logBox.SelectionLength = 0
    $logBox.SelectionColor = $color
    $logBox.AppendText($text)
    $logBox.SelectionColor = $logBox.ForeColor
    $logBox.ScrollToCaret()
}

# Size Helper functions
function Get-PathSize {
    param([string]$path)
    if (-not (Test-Path $path)) { return 0 }
    $size = 0
    try {
        $files = Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue
        if ($files) {
            $size = ($files | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        }
    } catch {}
    return [double]$size
}

function Format-Size {
    param([double]$sizeInBytes)
    if ($sizeInBytes -ge 1GB) {
        return "{0:N2} GB" -f ($sizeInBytes / 1GB)
    }
    if ($sizeInBytes -ge 1MB) {
        return "{0:N2} MB" -f ($sizeInBytes / 1MB)
    }
    if ($sizeInBytes -ge 1KB) {
        return "{0:N2} KB" -f ($sizeInBytes / 1KB)
    }
    if ($sizeInBytes -gt 0) {
        return "{0} Bytes" -f $sizeInBytes
    }
    return "0 KB"
}

# Function untuk clear cache
function Clear-BrowserCache {
    param($browserName, $paths)
    Write-Log "=== Membersihkan $browserName ===`n" $colorAccent
    
    $browserFound = $false
    $cleanedSize = [double]0
    
    switch ($browserName) {
        "Firefox" {
            $profilesDir = "$env:APPDATA\Mozilla\Firefox\Profiles"
            if (Test-Path $profilesDir) {
                $profilePaths = Get-ChildItem -Path $profilesDir -Filter "*.default-release" -ErrorAction SilentlyContinue
                if (-not $profilePaths) {
                    $profilePaths = Get-ChildItem -Path $profilesDir -Filter "*.default" -ErrorAction SilentlyContinue
                }
                foreach ($profile in $profilePaths) {
                    $browserFound = $true
                    $cachePath = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\$($profile.Name)\cache2"
                    if (Test-Path $cachePath) {
                        $size = Get-PathSize $cachePath
                        try {
                            Remove-Item -Path "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
                            $cleanedSize += $size
                            Write-Log "Cache Firefox dibersihkan ($(Format-Size $size))`n" $colorSuccess
                        } catch {
                            Write-Log "Gagal membersihkan Cache Firefox`n" $colorWarning
                        }
                    } else {
                        Write-Log "Cache Firefox kosong`n" $colorSubtext
                    }
                    
                    $sessionPath = "$env:APPDATA\Mozilla\Firefox\Profiles\$($profile.Name)\sessionstore.jsonlz4"
                    if (Test-Path $sessionPath) {
                        $size = Get-PathSize $sessionPath
                        try {
                            $backupPath = "$env:APPDATA\Mozilla\Firefox\Profiles\$($profile.Name)\sessionstore_backup.jsonlz4"
                            Copy-Item $sessionPath $backupPath -Force -ErrorAction SilentlyContinue
                            $cleanedSize += $size
                            Write-Log "Session Firefox dibackup ($(Format-Size $size))`n" $colorSuccess
                        } catch {}
                    }
                }
            }
        }
        default {
            # Chrome, Edge, Opera, Brave
            if (Test-Path $paths.Path) {
                $browserFound = $true
                $size = Get-PathSize $paths.Path
                try {
                    $filesBefore = (Get-ChildItem -Path $paths.Path -Recurse -ErrorAction SilentlyContinue).Count
                    Remove-Item -Path "$($paths.Path)\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $filesAfter = (Get-ChildItem -Path $paths.Path -Recurse -ErrorAction SilentlyContinue).Count
                    if ($filesAfter -eq 0 -or $filesAfter -lt $filesBefore) {
                        $cleanedSize += $size
                        Write-Log "Cache $browserName dibersihkan ($(Format-Size $size))`n" $colorSuccess
                    } else {
                        Write-Log "Cache $browserName tidak dapat dibersihkan sepenuhnya (tutup browser Anda)`n" $colorWarning
                    }
                } catch {
                    Write-Log "Gagal membersihkan Cache $browserName`n" $colorWarning
                }
            }
            # Session storage
            if (Test-Path $paths.SessionPath) {
                $browserFound = $true
                $size = Get-PathSize $paths.SessionPath
                try {
                    Remove-Item -Path "$($paths.SessionPath)\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $cleanedSize += $size
                    Write-Log "Session Storage $browserName dibersihkan ($(Format-Size $size))`n" $colorSuccess
                } catch {
                    Write-Log "Gagal membersihkan Session Storage $browserName`n" $colorWarning
                }
            }
            # Login Data
            if (Test-Path $paths.LoginPath) {
                $browserFound = $true
                $size = Get-PathSize $paths.LoginPath
                Write-Log "Login Data $browserName diamankan ($(Format-Size $size))`n" $colorSuccess
            }
        }
    }
    
    if (-not $browserFound) {
        Write-Log "$browserName tidak ditemukan atau tidak aktif`n" $colorSubtext
    }
    Write-Log "`n"
    return $cleanedSize
}

# Clear System Cache function
function Clear-SystemCache {
    Write-Log "=== Membersihkan System Cache ===`n" $colorAccent
    $systemCaches = @(
        "$env:TEMP",
        "$env:WINDIR\Temp",
        "$env:USERPROFILE\AppData\Local\Temp"
    )
    $cleanedSize = [double]0
    
    foreach ($cache in $systemCaches) {
        if (Test-Path $cache) {
            $size = Get-PathSize $cache
            try {
                Remove-Item -Path "$cache\*" -Recurse -Force -ErrorAction SilentlyContinue
                $cleanedSize += $size
                Write-Log "System Temp ($cache) dibersihkan ($(Format-Size $size))`n" $colorSuccess
            } catch {
                Write-Log "Gagal membersihkan folder temp: $cache`n" $colorWarning
            }
        }
    }
    # Clear Windows Prefetch
    if (Test-Path "$env:WINDIR\Prefetch") {
        $size = Get-PathSize "$env:WINDIR\Prefetch"
        try {
            Remove-Item -Path "$env:WINDIR\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
            $cleanedSize += $size
            Write-Log "Windows Prefetch dibersihkan ($(Format-Size $size))`n" $colorSuccess
        } catch {
            Write-Log "Gagal membersihkan Prefetch (butuh hak Administrator)`n" $colorWarning
        }
    }
    # Clear DNS Cache
    try {
        ipconfig /flushdns | Out-Null
        Write-Log "DNS Cache dibersihkan`n" $colorSuccess
    } catch {
        Write-Log "Gagal membersihkan DNS Cache`n" $colorWarning
    }
    Write-Log "`n"
    return $cleanedSize
}

# Clear Recycle Bin function
function Clear-RecycleBinCustom {
    Write-Log "=== Membersihkan Recycle Bin ===`n" $colorAccent
    $cleanedSize = [double]0
    try {
        $sh = New-Object -ComObject Shell.Application
        $rb = $sh.NameSpace(10)
        if ($rb) {
            foreach ($item in $rb.Items()) {
                $cleanedSize += $item.Size
            }
        }
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Log "Recycle Bin dibersihkan ($(Format-Size $cleanedSize))`n" $colorSuccess
    } catch {
        Write-Log "Gagal membersihkan Recycle Bin`n" $colorWarning
    }
    Write-Log "`n"
    return $cleanedSize
}

# Bottom Buttons Area
# Clear Button
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Bersihkan Cache"
$clearButton.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$clearButton.Location = New-Object System.Drawing.Point(20, 510)
$clearButton.Size = New-Object System.Drawing.Size(220, 45)
$clearButton.BackColor = $colorAccent
$clearButton.ForeColor = [System.Drawing.Color]::White
$clearButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$clearButton.FlatAppearance.BorderSize = 0
$form.Controls.Add($clearButton)

# About Button
$aboutButton = New-Object System.Windows.Forms.Button
$aboutButton.Text = "About"
$aboutButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$aboutButton.Location = New-Object System.Drawing.Point(250, 510)
$aboutButton.Size = New-Object System.Drawing.Size(100, 45)
$aboutButton.BackColor = $colorBorder
$aboutButton.ForeColor = $colorText
$aboutButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$aboutButton.FlatAppearance.BorderSize = 0
$form.Controls.Add($aboutButton)

# Close Button
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Tutup"
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$closeButton.Location = New-Object System.Drawing.Point(360, 510)
$closeButton.Size = New-Object System.Drawing.Size(100, 45)
$closeButton.BackColor = $colorError
$closeButton.ForeColor = [System.Drawing.Color]::White
$closeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$closeButton.FlatAppearance.BorderSize = 0
$form.Controls.Add($closeButton)

# Add Hover effects
$clearButton.Add_MouseEnter({ $clearButton.BackColor = [System.Drawing.Color]::FromArgb(29, 78, 216) }) # Darker blue
$clearButton.Add_MouseLeave({ $clearButton.BackColor = $colorAccent })

$aboutButton.Add_MouseEnter({ $aboutButton.BackColor = [System.Drawing.Color]::FromArgb(63, 63, 70) }) # Zinc-700
$aboutButton.Add_MouseLeave({ $aboutButton.BackColor = $colorBorder })

$closeButton.Add_MouseEnter({ $closeButton.BackColor = [System.Drawing.Color]::FromArgb(185, 28, 28) }) # Darker red
$closeButton.Add_MouseLeave({ $closeButton.BackColor = $colorError })

# Click Actions
$clearButton.Add_Click({
    $logBox.Clear()
    Write-Log "=== MEMULAI PEMBERSIHAN CACHE ===`n" $colorAccent
    Write-Log "Tanggal: $(Get-Date)`n`n" $colorSubtext
    $statusLabel.Text = "Status: Membersihkan..."
    $statusLabel.ForeColor = $colorWarning
    
    $selectedBrowsers = @()
    foreach ($browser in $browsers.Keys) {
        if ($checkboxes[$browser].Checked) {
            $selectedBrowsers += $browser
        }
    }
    
    $totalCleaned = [double]0
    
    # Clear selected browsers
    foreach ($browser in $selectedBrowsers) {
        $totalCleaned += Clear-BrowserCache -browserName $browser -paths $browsers[$browser]
    }
    
    # Clear system
    $totalCleaned += Clear-SystemCache
    
    # Clear Recycle Bin if selected
    if ($checkboxes["Recycle Bin"].Checked) {
        $totalCleaned += Clear-RecycleBinCustom
    }
    
    Write-Log "=== PEMBERSIHAN SELESAI ===`n" $colorSuccess
    Write-Log "Total Ruang Dibebaskan: $(Format-Size $totalCleaned)`n" $colorSuccess
    $statusLabel.Text = "Status: Selesai (Dibebaskan: $(Format-Size $totalCleaned))"
    $statusLabel.ForeColor = $colorSuccess
})

$closeButton.Add_Click({
    $form.Close()
})

$aboutButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "Windows Cache Cleaner Pro v1.1`n`nFitur:`n- Membersihkan cache 5 browser populer`n- Membersihkan system temp & Prefetch`n- Membersihkan Recycle Bin`n- Tidak menghapus session login Anda`n`nMade by Ncah`nRepo: https://github.com/callmencah/CleanCache",
        "About Cache Cleaner",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

# Credit Link Label
$linkLabel = New-Object System.Windows.Forms.LinkLabel
$linkLabel.Text = "Made by Ncah | github.com/callmencah/CleanCache"
$linkLabel.Location = New-Object System.Drawing.Point(20, 580)
$linkLabel.Size = New-Object System.Drawing.Size(445, 20)
$linkLabel.TextAlign = "MiddleCenter"
$linkLabel.ForeColor = $colorSubtext
$linkLabel.LinkColor = $colorAccent
$linkLabel.ActiveLinkColor = $colorSuccess
$linkLabel.VisitedLinkColor = $colorAccent
$linkLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$linkLabel.LinkBehavior = [System.Windows.Forms.LinkBehavior]::HoverUnderline

# Dynamically calculate link position to prevent mismatch
$linkPart = "github.com/callmencah/CleanCache"
$linkStart = $linkLabel.Text.IndexOf($linkPart)
if ($linkStart -ge 0) {
    $linkLabel.Links.Add($linkStart, $linkPart.Length, "https://github.com/callmencah/CleanCache")
}

$linkLabel.Add_LinkClicked({
    [System.Diagnostics.Process]::Start("https://github.com/callmencah/CleanCache")
})
$form.Controls.Add($linkLabel)

# Center Link Label on Form Load (Avoids any DPI or scaling text clipping)
$linkLabel.AutoSize = $true
$form.Add_Load({
    $linkLabel.Left = ($form.ClientSize.Width - $linkLabel.Width) / 2
})

# Custom Icon loading with remote fallback
try {
    $iconPath = Join-Path $PSScriptRoot "app_icon.ico"
    if (-not (Test-Path $iconPath)) {
        $iconPath = Join-Path $env:TEMP "app_icon.ico"
        if (-not (Test-Path $iconPath)) {
            Invoke-RestMethod -Uri "https://raw.githubusercontent.com/callmencah/CleanCache/main/app_icon.ico" -OutFile $iconPath -ErrorAction SilentlyContinue
        }
    }
    if (Test-Path $iconPath) {
        $form.Icon = New-Object System.Drawing.Icon($iconPath)
    } else {
        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
    }
} catch {
    try {
        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
    } catch {}
}

# Show Dialog
$form.ShowDialog()
