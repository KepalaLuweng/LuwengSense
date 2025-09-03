# 📜 Changelog – LuwengSense Zenith Edition  
**Version:** Zenith (Build 170)  
**Release Date:** 2025-09-03  

---

## 🇬🇧 English

### ✨ Major Highlights
- **Auto Mode with Per-App Profiles**  
  Automatically switches to *Gaming* when you launch selected apps, and intelligently reverts back to *Auto (Normal-based)* when closed. True hands-free performance.  
- **Full Theme Engine**  
  10 unique themes including *Legendary*, *Pure Black (OLED friendly)*, *Cyber Gold*, *Emerald Forest*, and *Solar Flare*.  
- **New Profile: Extreme Battery Saver**  
  An ultra-aggressive mode designed to squeeze the maximum out of your battery.  

### 🧠 Intelligence & Core Logic
- **Smart Fallback System** → dynamically selects the best supported kernel features (e.g., falls back from `bbr` to `cubic`).  
- **Profile Optimization**  
  - Smarter governors (schedutil replaces interactive).  
  - ZRAM size tuned per profile (75% Normal, 50% Gaming, 100% Battery).  
- **Robust Foreground Detection** using multi-layer `/proc` + `/dev` checks, ignoring system, launcher, and keyboard processes.  
- **Deeper System Integration** (LMK & Cgroups) for smoother multitasking and UI responsiveness.  

### 🛠️ UI & UX
- **New Installation Report** → *Kernel Feature Analysis* replaces confusing warnings.  
- **Separated Logs** → *Boot Log* vs *Auto-Profile Log* for clearer debugging.  
- **Enhanced Live Status** → battery temperature as CPU temp fallback.  
- **Cleaner Uninstaller** → removes all logs & properties, leaving no trace.  

### 🐛 Bug Fixes
- Fixed ZRAM switching delays.  
- Fixed missing toast notifications.  
- Fixed `watcher.sh` logic to correctly revert to Auto after Gaming.  
- Fixed profile description modal text cutoff.  

---

## 🇮🇩 Bahasa Indonesia

### ✨ Fitur Utama
- **Mode Auto dengan Profil Per-Aplikasi**  
  Otomatis masuk ke *Gaming* saat membuka game/app terpilih, lalu kembali ke *Auto (berbasis Normal)* ketika ditutup. Performa maksimal tanpa repot.  
- **Mesin Tema Penuh**  
  10 tema keren termasuk *Legendary*, *Pure Black*, *Cyber Gold*, *Emerald Forest*, dan *Solar Flare*.  
- **Profil Baru: Extreme Battery Saver**  
  Mode super hemat baterai dengan limit CPU & manajemen memori ketat.  

### 🧠 Kecerdasan & Logika
- **Fallback Cerdas** → pilih pengaturan kernel terbaik secara dinamis.  
- **Optimisasi Profil**  
  - Governor lebih pintar (*schedutil* ganti *interactive*).  
  - ZRAM sesuai profil (75% Normal, 50% Gaming, 100% Battery).  
- **Deteksi Foreground Lebih Andal** (multi-layer, skip system/launcher/keyboard).  
- **Integrasi Lebih Dalam** (LMK & Cgroups) → multitasking & UI lebih mulus.  

### 🛠️ Antarmuka & UX
- **Laporan Instalasi Baru** → *Kernel Feature Analysis*.  
- **Log Terpisah** → *Boot Log* & *Auto-Profile Log*.  
- **Status Lebih Lengkap** → fallback suhu baterai jika CPU tidak ada.  
- **Uninstaller Bersih** → hapus semua jejak modul.  

### 🐛 Perbaikan Bug
- Perbaikan ZRAM lambat/gagal switch.  
- Perbaikan notifikasi toast tidak muncul.  
- Perbaikan `watcher.sh` agar kembali ke Auto dengan benar.  
- Perbaikan modal deskripsi profil yang teksnya kepotong.
