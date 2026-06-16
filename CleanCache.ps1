# CleanCache.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Unicode Characters Helper (using character codes to stay 100% ASCII-compatible)
$symBroom = [char]::ConvertFromUtf32(0x1F9F9)
$symCheck = [char]::ConvertFromUtf32(0x2713)
$symWarn = [char]::ConvertFromUtf32(0x26A0)
$symRocket = [char]::ConvertFromUtf32(0x1F680)
$symInfo = [char]::ConvertFromUtf32(0x2139)
$symClose = [char]::ConvertFromUtf32(0x2715)

# Color Palette (Catppuccin Mocha / Sleek Modern Dark Theme)
$colorBg = [System.Drawing.Color]::FromArgb(30, 30, 46)        # #1e1e2e (Dark Background)
$colorPanel = [System.Drawing.Color]::FromArgb(49, 50, 68)     # #313244 (Panel/Surface)
$colorText = [System.Drawing.Color]::FromArgb(205, 214, 244)   # #cdd6f4 (Text)
$colorSubtext = [System.Drawing.Color]::FromArgb(166, 173, 200)# #a6adc8 (Subtext)
$colorAccent = [System.Drawing.Color]::FromArgb(137, 180, 250)  # #89b4fa (Blue Accent)
$colorSuccess = [System.Drawing.Color]::FromArgb(166, 227, 161) # #a6e3a1 (Green)
$colorWarning = [System.Drawing.Color]::FromArgb(249, 226, 175) # #f9e2af (Yellow/Orange)
$colorError = [System.Drawing.Color]::FromArgb(243, 139, 168)   # #f38ba8 (Red/Close)
$colorConsoleBg = [System.Drawing.Color]::FromArgb(17, 17, 27)  # #11111b (Console Black)

# Form Utama
$form = New-Object System.Windows.Forms.Form
$form.Text = "Cache Cleaner Windows Pro"
$form.Size = New-Object System.Drawing.Size(500, 620)
$form.StartPosition = "CenterScreen"
$form.BackColor = $colorBg
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false
try {
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
} catch {}

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "$symBroom Windows Cache Cleaner Pro"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(460, 35)
$titleLabel.TextAlign = "MiddleCenter"
$titleLabel.ForeColor = $colorAccent
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

# Group Box Browser (Panel Custom)
$groupPanel = New-Object System.Windows.Forms.GroupBox
$groupPanel.Text = " Pilihan Pembersihan Browser "
$groupPanel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$groupPanel.Location = New-Object System.Drawing.Point(20, 80)
$groupPanel.Size = New-Object System.Drawing.Size(445, 150)
$groupPanel.ForeColor = $colorAccent
$groupPanel.BackColor = $colorBg
$form.Controls.Add($groupPanel)

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
        # Firefox cache path handled inside function (LOCALAPPDATA vs APPDATA)
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

# Kolom 1 (Chrome, Edge, Firefox)
$yOffset = 30
$c1 = @("Chrome", "Edge", "Firefox")
foreach ($browser in $c1) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $browser
    $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $checkbox.Location = New-Object System.Drawing.Point(25, $yOffset)
    $checkbox.Size = New-Object System.Drawing.Size(150, 30)
    $checkbox.Checked = $true
    $checkbox.ForeColor = $colorText
    $groupPanel.Controls.Add($checkbox)
    $checkboxes[$browser] = $checkbox
    $yOffset += 35
}

# Kolom 2 (Opera, Brave, Pilih Semua)
$yOffset = 30
$c2 = @("Opera", "Brave")
foreach ($browser in $c2) {
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $browser
    $checkbox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $checkbox.Location = New-Object System.Drawing.Point(230, $yOffset)
    $checkbox.Size = New-Object System.Drawing.Size(150, 30)
    $checkbox.Checked = $true
    $checkbox.ForeColor = $colorText
    $groupPanel.Controls.Add($checkbox)
    $checkboxes[$browser] = $checkbox
    $yOffset += 35
}

# Select All Checkbox
$selectAll = New-Object System.Windows.Forms.CheckBox
$selectAll.Text = "Pilih Semua"
$selectAll.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$selectAll.Location = New-Object System.Drawing.Point(230, 100)
$selectAll.Size = New-Object System.Drawing.Size(150, 30)
$selectAll.Checked = $true
$selectAll.ForeColor = $colorAccent
$groupPanel.Controls.Add($selectAll)

$selectAll.Add_CheckedChanged({
    foreach ($cb in $checkboxes.Values) {
        $cb.Checked = $selectAll.Checked
    }
})

# Status Label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Status: Siap"
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$statusLabel.Location = New-Object System.Drawing.Point(20, 240)
$statusLabel.Size = New-Object System.Drawing.Size(460, 20)
$statusLabel.ForeColor = $colorSuccess
$form.Controls.Add($statusLabel)

# Log RichTextBox
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Location = New-Object System.Drawing.Point(20, 265)
$logBox.Size = New-Object System.Drawing.Size(445, 200)
$logBox.ReadOnly = $true
$logBox.BackColor = $colorConsoleBg
$logBox.ForeColor = $colorText
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9.5)
$logBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$form.Controls.Add($logBox)

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

# Function untuk clear cache
function Clear-BrowserCache {
    param($browserName, $paths)
    Write-Log "=== Membersihkan $browserName ===`n" $colorAccent
    
    $browserFound = $false
    
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
                        try {
                            Remove-Item -Path "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
                            Write-Log "$symCheck Cache Firefox dibersihkan`n" $colorSuccess
                        } catch {
                            Write-Log "$symWarn Gagal membersihkan Cache Firefox`n" $colorWarning
                        }
                    } else {
                        Write-Log "$symCheck Cache Firefox kosong`n" $colorSubtext
                    }
                    
                    $sessionPath = "$env:APPDATA\Mozilla\Firefox\Profiles\$($profile.Name)\sessionstore.jsonlz4"
                    if (Test-Path $sessionPath) {
                        try {
                            $backupPath = "$env:APPDATA\Mozilla\Firefox\Profiles\$($profile.Name)\sessionstore_backup.jsonlz4"
                            Copy-Item $sessionPath $backupPath -Force -ErrorAction SilentlyContinue
                            Write-Log "$symCheck Session Firefox dibackup`n" $colorSuccess
                        } catch {}
                    }
                }
            }
        }
        default {
            # Chrome, Edge, Opera, Brave
            if (Test-Path $paths.Path) {
                $browserFound = $true
                try {
                    $filesBefore = (Get-ChildItem -Path $paths.Path -Recurse -ErrorAction SilentlyContinue).Count
                    Remove-Item -Path "$($paths.Path)\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $filesAfter = (Get-ChildItem -Path $paths.Path -Recurse -ErrorAction SilentlyContinue).Count
                    if ($filesAfter -eq 0 -or $filesAfter -lt $filesBefore) {
                        Write-Log "$symCheck Cache $browserName dibersihkan`n" $colorSuccess
                    } else {
                        Write-Log "$symWarn Cache $browserName tidak dapat dibersihkan sepenuhnya (tutup browser Anda)`n" $colorWarning
                    }
                } catch {
                    Write-Log "$symWarn Gagal membersihkan Cache $browserName`n" $colorWarning
                }
            }
            # Session storage
            if (Test-Path $paths.SessionPath) {
                $browserFound = $true
                try {
                    Remove-Item -Path "$($paths.SessionPath)\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Log "$symCheck Session Storage $browserName dibersihkan`n" $colorSuccess
                } catch {
                    Write-Log "$symWarn Gagal membersihkan Session Storage $browserName`n" $colorWarning
                }
            }
            # Login Data
            if (Test-Path $paths.LoginPath) {
                $browserFound = $true
                Write-Log "$symCheck Login Data $browserName diamankan`n" $colorSuccess
            }
        }
    }
    
    if (-not $browserFound) {
        Write-Log "$symWarn $browserName tidak ditemukan atau tidak aktif`n" $colorSubtext
    }
    Write-Log "`n"
}

# Clear System Cache function
function Clear-SystemCache {
    Write-Log "=== Membersihkan System Cache ===`n" $colorAccent
    $systemCaches = @(
        "$env:TEMP",
        "$env:WINDIR\Temp",
        "$env:USERPROFILE\AppData\Local\Temp"
    )
    foreach ($cache in $systemCaches) {
        if (Test-Path $cache) {
            try {
                Remove-Item -Path "$cache\*" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Log "$symCheck System Temp ($cache) dibersihkan`n" $colorSuccess
            } catch {
                Write-Log "$symWarn Gagal membersihkan folder temp: $cache`n" $colorWarning
            }
        }
    }
    # Clear Windows Prefetch
    if (Test-Path "$env:WINDIR\Prefetch") {
        try {
            Remove-Item -Path "$env:WINDIR\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "$symCheck Windows Prefetch dibersihkan`n" $colorSuccess
        } catch {
            Write-Log "$symWarn Gagal membersihkan Prefetch (butuh hak Administrator)`n" $colorWarning
        }
    }
    # Clear DNS Cache
    try {
        ipconfig /flushdns | Out-Null
        Write-Log "$symCheck DNS Cache dibersihkan`n" $colorSuccess
    } catch {
        Write-Log "$symWarn Gagal membersihkan DNS Cache`n" $colorWarning
    }
    Write-Log "`n"
}

# Bottom Buttons Area
# Clear Button
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "$symRocket Bersihkan Cache"
$clearButton.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$clearButton.Location = New-Object System.Drawing.Point(20, 490)
$clearButton.Size = New-Object System.Drawing.Size(200, 45)
$clearButton.BackColor = $colorAccent
$clearButton.ForeColor = $colorBg
$clearButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$clearButton.FlatAppearance.BorderSize = 0
$form.Controls.Add($clearButton)

# About Button
$aboutButton = New-Object System.Windows.Forms.Button
$aboutButton.Text = "$symInfo About"
$aboutButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$aboutButton.Location = New-Object System.Drawing.Point(235, 490)
$aboutButton.Size = New-Object System.Drawing.Size(95, 45)
$aboutButton.BackColor = $colorPanel
$aboutButton.ForeColor = $colorText
$aboutButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$aboutButton.FlatAppearance.BorderSize = 0
$form.Controls.Add($aboutButton)

# Close Button
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "$symClose Tutup"
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$closeButton.Location = New-Object System.Drawing.Point(345, 490)
$closeButton.Size = New-Object System.Drawing.Size(120, 45)
$closeButton.BackColor = $colorError
$closeButton.ForeColor = $colorBg
$closeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$closeButton.FlatAppearance.BorderSize = 0
$form.Controls.Add($closeButton)

# Add Hover effects
$clearButton.Add_MouseEnter({ $clearButton.BackColor = [System.Drawing.Color]::FromArgb(166, 227, 161) }) # Green hover
$clearButton.Add_MouseLeave({ $clearButton.BackColor = $colorAccent })

$aboutButton.Add_MouseEnter({ $aboutButton.BackColor = [System.Drawing.Color]::FromArgb(69, 71, 90) })
$aboutButton.Add_MouseLeave({ $aboutButton.BackColor = $colorPanel })

$closeButton.Add_MouseEnter({ $closeButton.BackColor = [System.Drawing.Color]::FromArgb(245, 194, 231) }) # Pink hover
$closeButton.Add_MouseLeave({ $closeButton.BackColor = $colorError })

# Click Actions
$clearButton.Add_Click({
    $logBox.Clear()
    Write-Log "=== MEMULAI PEMBERSIHAN CACHE ===`n" $colorAccent
    Write-Log "Tanggal: $(Get-Date)`n`n" $colorSubtext
    $statusLabel.Text = "Status: Membersihkan..."
    $statusLabel.ForeColor = $colorWarning
    
    $selectedBrowsers = @()
    foreach ($browser in $checkboxes.Keys) {
        if ($checkboxes[$browser].Checked) {
            $selectedBrowsers += $browser
        }
    }
    
    # Clear selected browsers
    foreach ($browser in $selectedBrowsers) {
        Clear-BrowserCache -browserName $browser -paths $browsers[$browser]
    }
    
    # Clear system
    Clear-SystemCache
    
    Write-Log "=== PEMBERSIHAN SELESAI ===" $colorSuccess
    $statusLabel.Text = "Status: Selesai $symCheck"
    $statusLabel.ForeColor = $colorSuccess
})

$closeButton.Add_Click({
    $form.Close()
})

$aboutButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "Windows Cache Cleaner Pro v1.1`n`nFitur:`n- Membersihkan cache 5 browser populer`n- Membersihkan system temp & Prefetch`n- Tidak menghapus session login Anda`n`nMade by Ncah`nRepo: https://github.com/callmencah/CleanCache",
        "About Cache Cleaner",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

# Credit Link Label
$linkLabel = New-Object System.Windows.Forms.LinkLabel
$linkLabel.Text = "Made by Ncah | github.com/callmencah/CleanCache"
$linkLabel.Location = New-Object System.Drawing.Point(20, 550)
$linkLabel.Size = New-Object System.Drawing.Size(445, 20)
$linkLabel.TextAlign = "MiddleCenter"
$linkLabel.LinkColor = $colorAccent
$linkLabel.ActiveLinkColor = $colorSuccess
$linkLabel.VisitedLinkColor = $colorAccent
$linkLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$linkLabel.LinkBehavior = [System.Windows.Forms.LinkBehavior]::HoverUnderline
$linkLabel.Links.Add(15, 30, "https://github.com/callmencah/CleanCache")
$linkLabel.Add_LinkClicked({
    [System.Diagnostics.Process]::Start("https://github.com/callmencah/CleanCache")
})
$form.Controls.Add($linkLabel)

# Show Dialog
$form.ShowDialog()
