# 📄 Changelog — LuwengSense v1.3.0

🗓️ **Release Date:** 11 July 2025  
🔧 **Status:** Stable

---

## 🔥 What's New in v1.3.0

### 📱 Performance & Touch
- ✅ Improved **touch response** with high refresh support (up to 240Hz)
- ✅ Disabled `checkjni` for smoother execution
- ✅ Forced GPU-based rendering using **SkiaGL**

### 📡 Network & Signal
- ✅ Applied **TCP BBR** congestion algorithm for stable ping
- ✅ Disabled **radio power-saving** for stronger signal hold
- ✅ Enabled **VoLTE**, **VoWiFi**, and video call props (if supported)

### 📍 GPS Optimization
- ✅ Added dual GPS config files:  
  - `gps_debug.conf` for **MediaTek**  
  - `gps.conf` for **Qualcomm/Snapdragon**
- ✅ Optimized **NTP servers** for Asia (including Indonesia)
- ✅ Enabled **GPS wakelock** to reduce signal drop during standby

### 🧠 RAM & I/O Optimization
- ✅ Enabled **ZRAM (2GB)** using `lz4` compression
- ✅ Lowered **VFS cache pressure** to improve storage responsiveness
- ✅ Applied **noop I/O scheduler** to reduce latency

### ❄️ Thermal & Background Services
- ✅ (Optional) **Thermal throttling disabled** for sustained performance
- ✅ Disabled logging daemons: `profcollectd`, `statsd`, and `logpersistd`

### ⚙️ Compatibility & Structure
- ✅ Fully compatible with **Magisk v24+** and **KernelSU**
- ✅ Supports **OTA updates** via `update.json`
- ✅ Updated `customize.sh` with professional installer output

---

📎 **Size:** <10KB  
🧠 Pure shell script — no APKs, no bloat  
💻 Built by: [KepalaLuweng](https://www.youtube.com/@luwengtechid)
