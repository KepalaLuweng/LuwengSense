# 🧠 LuwengSense v1.4.0 – Gaming Isolation Edition  
📅 Release Date: 2025-07-16  
👤 Author: KepalaLuweng  
📺 YouTube: [@luwengtechid](https://www.youtube.com/@luwengtechid)

---

## 🔄 Changelog

- ✅ **Volume Key Profile Selector**  
  Choose your preferred profile during module installation:  
  - 🔘 **[Vol+]** = Next  
  - 🔘 **[Vol-]** = Select  

  **Available Profiles:**
  - 🎮 **Gaming Mode** – Max performance, thermal throttling disabled, 240Hz touch  
  - ⚖️ **Normal Mode** – Balanced setup for daily use  
  - 🔋 **Battery Saver** – Power-optimized, lower touch response

- 🧠 **Profile Engine (`service.sh`)**  
  Automatically applies selected profile tweaks on boot:
  - CPU governor  
  - GPU settings  
  - TCP congestion algorithm  
  - ZRAM size tuning  
  - Thermal and VM/I/O optimizations

- 📄 **Log System**  
  All applied tweaks are logged in `/data/luwengsense_log.txt` for transparency.

- 🧪 **Built-in Verification Tool**  
  `luwengsense_check.sh` is auto-installed to `/sdcard`  
  **How to verify tweaks:**
  ```sh
  su
  sh /sdcard/luwengsense_check.sh
  ```

- ⚙️ **Compatibility**
  - ✅ Root: Magisk v24+ & KernelSU  
  - ✅ Android: 9 to 14+  
  - ✅ SoC: MediaTek, Qualcomm, Exynos, etc.  
  - ✅ CPU Arch: ARM / ARM64 / x86

---

💚 **LuwengSense – Built to Move, Tuned for You**  
📺 YouTube: [LuwengTechID](https://www.youtube.com/@luwengtechid)
