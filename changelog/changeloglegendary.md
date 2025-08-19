# Changelog — Legendary Edition

## 🚀 Major Features & Upgrades
- **Web UI Control Panel**  
  Full web-based interface to control every feature in real-time.  
  *For Magisk Users: This can be accessed by installing the `KsuWebUI` app.*
- **New "Extreme" Profile**  
  Added a **fourth profile** for maximum performance with **disabled thermal throttling** for uncompromising speed.  
  (Previously only 3 profiles were available.)
- **Smart DNS System**  
  Choose from multiple providers (Google, Cloudflare, etc.) via a dropdown.  
  Uses secure **Private DNS (DoH/DoT)** on Android 9+ and falls back to classic DNS on older versions.
- **Adaptive I/O Scheduler**  
  Intelligently selects the best scheduler available on your kernel: `bfq` → `cfq` → `noop`.
- **Quick Action Button**  
  Run on-demand system optimization (cache clean & `fstrim`) directly from KernelSU/Magisk app.

## 🐛 Fixes & Stability
- **Core Logic Reworked**  
  Completely rewrote **ZRAM** and **Thermal Throttling** logic.  
  ZRAM settings now persist and are no longer overridden by the ROM.  
  Thermal disabling method is now safer & more compatible.
- **Universal Scripting**  
  All scripts fixed for universal compatibility across ROMs, kernels, and root solutions (**KernelSU & Magisk**).  
  Resolved previous `fstrim` errors.
- **Smarter Installer**  
  Installer now provides a **detailed kernel compatibility report** with a clear summary.
