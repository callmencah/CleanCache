# Cache Cleaner Windows 🧹

Aplikasi GUI untuk membersihkan cache browser dan sistem di Windows tanpa menghapus session login.

Made by **Ncah** | Repository: [github.com/callmencah/CleanCache](https://github.com/callmencah/CleanCache)

## ✨ Fitur

- **5 Browser Support**: Chrome, Edge, Firefox, Opera, Brave
- **Aman**: Session login tidak terhapus
- **System Cache**: Membersihkan temp, prefetch, dan DNS cache
- **GUI Interaktif**: Mudah digunakan dengan antarmuka visual
- **Log Real-time**: Melihat proses pembersihan berlangsung

## 📋 Persyaratan

- Windows 7/8/10/11
- PowerShell 5.0 atau lebih tinggi

## 🚀 Cara Menjalankan

### Metode 1: One-Liner (Praktis & Langsung Jalan)
Buka PowerShell Anda (tidak harus Administrator), lalu salin dan jalankan perintah di bawah ini:
```powershell
irm https://raw.githubusercontent.com/callmencah/CleanCache/main/CleanCache.ps1 | iex
```

### Metode 2: Jalankan dari File Lokal
Buka PowerShell, masuk ke folder repository ini terlebih dahulu menggunakan perintah `cd`, lalu jalankan:
```powershell
powershell -ExecutionPolicy Bypass -File .\CleanCache.ps1
```

### Metode 3: Gunakan Installer Shortcut
Jalankan file `setup.bat` sebagai Administrator. Skrip ini akan membuat shortcut **Cache Cleaner** di Desktop sehingga Anda tinggal mengkliknya kapan saja untuk membuka aplikasi.
