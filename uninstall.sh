#!/system/bin/sh
#
# LuwengSense Zenith :: Uninstaller Script (Optimized & Complete Cleanup)
# This script will be executed when the module is uninstalled.
#

# --- Remove Created Files ---
# Remove the main log file from /data partition
rm -f /data/luwengsense_log.txt

# BARU: Hapus log dari watcher.sh
rm -f /data/luwengsense_watcher_log.txt

# BARU: Hapus log diagnosa ZRAM jika ada
rm -f /data/luwengsense_zram_debug.txt

# Note: The /data/system/.luweng.id file is no longer created by the new installer,
# but we keep this line to clean up installations from older versions.
rm -f /data/system/.luweng.id


# --- Reset Persistent System Properties ---
# This is crucial for a truly clean uninstall, as 'persist' props
# are not removed automatically. We reset them to an empty value.

# Properti dari uninstaller lama (sudah benar)
setprop persist.location.mode ""
setprop persist.sys.gps.lpp ""
setprop persist.gps.wakelock ""
setprop persist.radio.add_power_save ""
setprop persist.data.netmgrd.qos.enable ""
setprop persist.dbg.volte_avail_ovr ""
setprop persist.dbg.vt_avail_ovr ""
setprop persist.dbg.wfc_avail_ovr ""

# BARU: Reset properti dari system.prop yang tertinggal
setprop persist.telephony.support.ipv4 ""
setprop persist.telephony.support.ipv6 ""
setprop persist.cust.tel.adapt ""
setprop persist.cust.tel.eons ""

# BARU: Reset properti dari apply_tweaks.sh
setprop persist.sys.ui.hw ""


# --- Reset System Settings (BONUS) ---
# BARU: Mengembalikan pengaturan Private DNS ke default (off)
# Ini adalah praktik terbaik untuk kebersihan maksimal.
SDK_VERSION=$(getprop ro.build.version.sdk)
if [ "$SDK_VERSION" -ge 28 ]; then
    settings put global private_dns_mode off
    settings put global private_dns_specifier ""
fi


# The module is now fully removed.
exit 0
