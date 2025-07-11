# 📦 Changelog – LuwengSense v1.4.0  
**Release Date:** 2025-07-11  

---

## 🚀 New Features

### • Interactive Installer (Volume Key Navigation)  
A brand new interactive installer allows users to choose a performance profile during installation using volume keys:
- **🚀 Gaming Mode** – Maximum FPS & responsiveness, disables thermal throttling, TCP BBR, 50% RAM ZRAM
- **✨ Normal (Balanced)** – Daily balance with interactive governor and 75% RAM ZRAM
- **🔋 Battery Saver** – Power-efficient mode with schedutil governor and 100% RAM ZRAM

### • Adaptive ZRAM Engine  
ZRAM is now dynamically calculated based on physical RAM size to balance swap performance and memory usage.

### • Real-time Logging  
All actions and tweaks are now logged to:  
`/data/luwengsense_log.txt`  

---

## 🔧 System Enhancements

- CPU governor, I/O scheduler, TCP congestion control, and VFS pressure now profile-aware  
- GPU-based rendering (SkiaGL) forced across all profiles  
- Touch responsiveness optimized  
- V-Sync disabled in Gaming Mode  
- Thermal throttling disabled (Gaming Mode only)  
- Automatic FSTRIM executed on `/data` and `/cache` at boot  
- `system.prop` updated for better Android 14+ compatibility  
- Refined GPS configurations for faster and more accurate locks on both MediaTek and Qualcomm  

---

## ✅ Compatibility

- **Root Method:** Magisk (v24.0+) or KernelSU  
- **CPU Architecture:** ARM / ARM64  
- **Android Version:** 9 (Pie) to 14+  

---

> LuwengSense now delivers true user-controlled performance tuning.  
> Enjoy smarter tweaks. No apps. No bloat. Just raw control.
