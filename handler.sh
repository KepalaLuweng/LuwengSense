#!/system/bin/sh
# LuwengSense Zenith By KepalaLuweng

MODDIR="/data/adb/modules/LuwengSense"
DNS_CONF="$MODDIR/dns.conf"
THEME_CONF="$MODDIR/theme.conf"
WATCHED_APPS_CONF="$MODDIR/watched_apps.conf"
WATCHER_LOG="/data/luwengsense_watcher_log.txt"
BOOT_LOG="/data/luwengsense_log.txt"

get_full_status() {
    if [ -f "$MODDIR/profile.conf" ]; then PROFILE=$(cat "$MODDIR/profile.conf"); else PROFILE="normal"; fi
    GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
    ZRAM_INFO=$(grep zram0 /proc/swaps); if [ -n "$ZRAM_INFO" ]; then ZRAM_SIZE_KB=$(echo "$ZRAM_INFO" | awk '{print $3}'); ZRAM_SIZE_MB=$((ZRAM_SIZE_KB / 1024)); ZRAM_ALGO=$(cat /sys/block/zram0/comp_algorithm 2>/dev/null | sed -n 's/.*\[\([^]]*\)\].*/\1/p' | tr '[:lower:]' '[:upper:]'); else ZRAM_SIZE_MB=0; ZRAM_ALGO="Inactive"; fi
    SWAPPINESS=$(cat /proc/sys/vm/swappiness 2>/dev/null)
    IO_SCHED_RAW=$(cat /sys/block/sda/queue/scheduler 2>/dev/null || cat /sys/block/mmcblk0/queue/scheduler 2>/dev/null)
    IO_SCHEDULER=$(echo "$IO_SCHED_RAW" | sed -n 's/.*\[\([^]]*\)\].*/\1/p');
    TCP_ALGORITHM=$(cat /proc/sys/net/ipv4/tcp_congestion_control 2>/dev/null)
    if [ "$PROFILE" = "extreme" ]; then THERMAL_STATUS="Disabled"; else THERMAL_STATUS="Active"; fi
    
    TEMP_LABEL="Temperature"
    TEMP_VALUE="N/A"
    BATTERY_TEMP_PATH="/sys/class/power_supply/battery/temp"
    if [ -f "$BATTERY_TEMP_PATH" ]; then
        TEMP_LABEL="Battery Temp"
        TEMP_RAW=$(cat "$BATTERY_TEMP_PATH")
        if [ "$TEMP_RAW" -gt 0 ]; then TEMP_VALUE=$((TEMP_RAW / 10)); fi
    else
        TEMP_LABEL="CPU Temp"
        CPU_TEMP_PATH=$(find /sys/class/thermal/thermal_zone* -type f -name "temp" 2>/dev/null | head -n 1)
        if [ -f "$CPU_TEMP_PATH" ]; then
            TEMP_RAW=$(cat "$CPU_TEMP_PATH" 2>/dev/null)
            if [ "$TEMP_RAW" -gt 1000 ]; then
                TEMP_VALUE=$((TEMP_RAW / 1000))
            elif [ "$TEMP_RAW" -gt 0 ]; then
                TEMP_VALUE=$TEMP_RAW
            fi
        fi
    fi
    
    CPU_FREQ="N/A"; CPU_FREQ_PATH="/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
    if [ -f "$CPU_FREQ_PATH" ]; then CPU_FREQ_RAW=$(cat "$CPU_FREQ_PATH" 2>/dev/null); if [ "$CPU_FREQ_RAW" -gt 0 ]; then CPU_FREQ=$((CPU_FREQ_RAW / 1000)); fi; fi
    
    echo "{ \"profile\": \"${PROFILE:-normal}\", \"governor\": \"${GOVERNOR:-N/A}\", \"zram_mb\": ${ZRAM_SIZE_MB:-0}, \"zram_algo\": \"${ZRAM_ALGO:-N/A}\", \"thermal_status\": \"$THERMAL_STATUS\", \"swappiness\": \"${SWAPPINESS:-N/A}\", \"io_scheduler\": \"${IO_SCHEDULER:-N/A}\", \"tcp_algorithm\": \"${TCP_ALGORITHM:-N/A}\", \"temp_label\": \"${TEMP_LABEL}\", \"temp_value\": \"${TEMP_VALUE}\", \"cpu_freq\": \"${CPU_FREQ}\" }"
}

set_profile() { echo "$1" > "$MODDIR/profile.conf"; echo "✅ Profile set to '$1'. Use 'Force Apply Tweaks' to apply now."; }
force_apply_tweaks() { (su -c "sh $MODDIR/apply_tweaks.sh") & echo "✅ Tweaks are being applied in the background..."; echo "   Refresh status in a few seconds."; }
get_version() { if [ -f "$MODDIR/module.prop" ]; then grep '^version=' "$MODDIR/module.prop" | cut -d'=' -f2; else echo "N/A"; fi; }
get_dns_profile() { if [ -f "$DNS_CONF" ]; then cat "$DNS_CONF"; else echo "default"; fi; }
set_dns_profile() { echo "$1" > "$DNS_CONF"; echo "✅ Custom DNS profile saved as '$1'."; }
clear_caches() { echo "Attempting to run optimizer..."; if su -c "sh $MODDIR/action.sh"; then echo "✅ System optimizer script executed successfully."; else echo "❌ Failed to execute optimizer script."; fi; }
view_boot_log() { if [ -f "$BOOT_LOG" ]; then echo "--- Displaying Boot Log ---"; cat "$BOOT_LOG"; echo "--- End of Log ---"; else echo "Boot log not found."; fi; }
get_theme() { if [ -f "$THEME_CONF" ]; then cat "$THEME_CONF"; else echo "legendary"; fi; }
set_theme() { echo "$1" > "$THEME_CONF"; }
get_watched_apps() { if [ -f "$WATCHED_APPS_CONF" ]; then cat "$WATCHED_APPS_CONF"; fi; }
set_watched_apps() { echo "$1" > "$WATCHED_APPS_CONF"; echo "✅ Watched apps list updated."; }
view_watcher_log() { if [ -f "$WATCHER_LOG" ]; then echo "--- Displaying Auto-Profile Log ---"; cat "$WATCHER_LOG"; echo "--- End of Log ---"; else echo "Watcher log not found. Open a watched app to generate it."; fi; }

case "$1" in
    "get_full_status") get_full_status;;
    "set_profile") set_profile "$2";;
    "force_apply_tweaks") force_apply_tweaks;;
    "get_version") get_version;;
    "get_dns_profile") get_dns_profile;;
    "set_dns_profile") set_dns_profile "$2";;
    "clear_caches") clear_caches;;
    "view_boot_log") view_boot_log;;
    "get_theme") get_theme;;
    "set_theme") set_theme "$2";;
    "get_watched_apps") get_watched_apps;;
    "set_watched_apps") set_watched_apps "$2";;
    "view_watcher_log") view_watcher_log;;
    *) echo "Invalid command.";;
esac