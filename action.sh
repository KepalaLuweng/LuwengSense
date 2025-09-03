#!/system/bin/sh
#
# LuwengSense :: action.sh (Robust BusyBox Finder)
# Author: KepalaLuweng
#

ui_print() {
  echo "$1"
}

# --- LOGIKA PINTAR UNTUK MENEMUKAN BUSYBOX ---
# Mencari toolbox yang benar, baik untuk KernelSU maupun Magisk
if [ -x /data/adb/ksu/bin/busybox ]; then
  BB=/data/adb/ksu/bin/busybox
elif [ -x /data/adb/magisk/busybox ]; then
  BB=/data/adb/magisk/busybox
else
  # Jika tidak ditemukan, coba panggil langsung (sebagai fallback)
  BB=busybox
fi
# --- AKHIR LOGIKA PINTAR ---


# Mulai
ui_print " "
ui_print "====================================="
ui_print "    🚀 LuwengSense Optimizer 🚀"
ui_print "====================================="
ui_print " "
sleep 1

# Membersihkan Cache Sistem (RAM)
ui_print "- Clearing system caches (PageCache, dentries, inodes)..."
sync
echo 3 > /proc/sys/vm/drop_caches
ui_print "  [✓] Caches cleared."
sleep 1

# Menjalankan FSTRIM pada partisi penting
ui_print " "
ui_print "- Running FSTRIM on partitions..."
ui_print "  (This may take a moment...)"

# PERBAIKAN: Menggunakan BusyBox yang sudah ditemukan untuk menjalankan fstrim
$BB fstrim -v /data
$BB fstrim -v /cache

ui_print "  [✓] FSTRIM complete."
sleep 1

# Selesai
ui_print " "
ui_print "====================================="
ui_print "  ✅ Optimization Complete!"
ui_print "====================================="
ui_print " "

exit 0
