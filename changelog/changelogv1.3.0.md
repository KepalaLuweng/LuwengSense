# 📄 Changelog — LuwengSense v1.3.0

🗓️ **Release Date:** 11 July 2025  
🔧 **Status:** Stable

---

## 🔥 What's New in v1.3.0

### 📱 Performance & Touch
- ✅ Improved **touch response** with new runtime props (up to 240Hz supported)
- ✅ Disabled unnecessary `checkjni` and forced GPU-based rendering (SkiaGL)

### 📡 Network & Signal
- ✅ Applied **TCP BBR** congestion control for more stable ping & faster data
- ✅ Disabled **radio power-saving** for better signal hold
- ✅ Enabled **VoLTE**, **VoWiFi**, and **video calling** props (auto-detected)

### 📍 GPS Optimization
- ✅ Added **dual GPS support**:  
  - `gps_debug.conf` → MediaTek  
  - `gps.conf` → Qualcomm/Snapdragon  
- ✅ Regional **NTP servers** for faster GPS lock (Asia & Indonesia prioritized)

### 🧠 RAM & I/O Optimization
- ✅ Activated **ZRAM** (2GB) with `lz4` compression for better multitasking
- ✅ Lowered **VFS cache pressure** for faster file access
- ✅ Enforced **noop I/O scheduler** for faster storage access

### ❄️ Thermal & Background Services
- ✅ Disabled **thermal throttling** (use with caution)
- ✅ Turned off `profcollectd`, `statsd`, and persistent loggers to save CPU & I/O

### ⚙️ Compatibility & Structure
- ✅ Fully compatible with **Magisk v24+** & **KernelSU**
- ✅ OTA support via `update.json` (Magisk/KernelSU Manager)
- ✅ Clean, professional **customize.sh UI**

---

📎 **Total Size:** <10KB  
🧠 100% Shell-Based. No APKs. No bloat.  
💻 Built by: [KepalaLuweng](https://www.youtube.com/@luwengtechid)
