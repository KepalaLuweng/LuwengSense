#!/system/bin-h
# LuwengSense Zenith By KepalaLuweng

MODDIR="/data/adb/modules/LuwengSense"
DNS_CONF="$MODDIR/dns.conf"
LOGFILE="/data/luwengsense_log.txt"

echo "--- LuwengSense Tweak Application ---" > $LOGFILE
echo "Timestamp: $(date)" >> $LOGFILE

setprop debug.performance.tuning 0; setprop debug.egl.swapinterval -1; setprop power.saving.mode 0

for cpu_policy in /sys/devices/system/cpu/cpufreq/policy*; do
    if [ -f "$cpu_policy/cpuinfo_max_freq" ]; then echo $(cat "$cpu_policy/cpuinfo_max_freq") > "$cpu_policy/scaling_max_freq"; fi
    if [ -f "$cpu_policy/cpuinfo_min_freq" ]; then echo $(cat "$cpu_policy/cpuinfo_min_freq") > "$cpu_policy/scaling_min_freq"; fi
done

if [ -f "$DNS_CONF" ]; then DNS_PROFILE=$(cat "$DNS_CONF"); else DNS_PROFILE="default"; fi
echo "Applying DNS Profile: $DNS_PROFILE" >> $LOGFILE
SDK_VERSION=$(getprop ro.build.version.sdk)
if [ "$SDK_VERSION" -ge 28 ]; then
    case "$DNS_PROFILE" in
        "google") settings put global private_dns_mode hostname; settings put global private_dns_specifier dns.google;;
        "cloudflare") settings put global private_dns_mode hostname; settings put global private_dns_specifier 1dot1dot1dot1.cloudflare-dns.com;;
        "adguard") settings put global private_dns_mode hostname; settings put global private_dns_specifier dns.adguard.com;;
        "opendns") settings put global private_dns_mode hostname; settings put global private_dns_specifier dns.opendns.com;;
        "quad9") settings put global private_dns_mode hostname; settings put global private_dns_specifier dns.quad9.net;;
        *) settings put global private_dns_mode off;;
    esac
    if [ "$DNS_PROFILE" != "default" ]; then setprop net.dns1 ""; setprop net.dns2 ""; fi
else
    case "$DNS_PROFILE" in
        "google") setprop net.dns1 8.8.8.8; setprop net.dns2 8.8.4.4;;
        "cloudflare") setprop net.dns1 1.1.1.1; setprop net.dns2 1.0.0.1;;
        "adguard") setprop net.dns1 94.140.14.14; setprop net.dns2 94.140.15.15;;
        "opendns") setprop net.dns1 208.67.222.222; setprop net.dns2 208.67.220.220;;
        "quad9") setprop net.dns1 9.9.9.9; setprop net.dns2 149.112.112.112;;
        *) setprop net.dns1 ""; setprop net.dns2 "";;
    esac
fi

if [ -f "$MODDIR/profile.conf" ]; then PROFILE=$(cat "$MODDIR/profile.conf"); else PROFILE="normal"; fi
if [ "$PROFILE" = "auto" ]; then
    BASE_PROFILE="normal"
else
    BASE_PROFILE="$PROFILE"
fi
TOTAL_RAM_MB=$(free -m | grep Mem | awk '{print $2}')
echo "Applying System Profile: $BASE_PROFILE (from selected: $PROFILE)" >> $LOGFILE

case "$BASE_PROFILE" in
  "extreme"|"gaming")
    GOV_PRIORITY="performance schedutil interactive"; TCP_PRIORITY="bbr cubic"; IO_PRIORITY="noop deadline cfq";
    sysctl -w vm.swappiness=10 > /dev/null 2>&1; sysctl -w kernel.sched_autogroup_enabled=0 > /dev/null 2>&1;
    setprop persist.sys.ui.hw true; setprop ro.performance.tuning 1; setprop ro.ril.disable.power.collapse 1;
    setprop windowsmgr.max_events_per_sec 150; setprop debug.performance.tuning 1;
    if [ "$BASE_PROFILE" = "extreme" ]; then ZRAM_ENABLED=false; else ZRAM_ENABLED=true; ZRAM_SIZE_MB=$((TOTAL_RAM_MB / 2)); fi
    ;;
  "battery"|"extreme_battery")
    GOV_PRIORITY="schedutil interactive ondemand"; TCP_PRIORITY="cubic"; IO_PRIORITY="bfq cfq noop";
    ZRAM_ENABLED=true; ZRAM_SIZE_MB=$TOTAL_RAM_MB;
    setprop persist.sys.ui.hw false; setprop ro.performance.tuning 0; setprop ro.ril.disable.power.collapse 0;
    setprop windowsmgr.max_events_per_sec 90; setprop power.saving.mode 1;
    if [ "$BASE_PROFILE" = "extreme_battery" ]; then
        sysctl -w vm.swappiness=100 > /dev/null 2>&1;
        for cpu_policy in /sys/devices/system/cpu/cpufreq/policy*; do
            if [ -w "$cpu_policy/scaling_max_freq" ]; then
                MIN_FREQ=$(cat "$cpu_policy/cpuinfo_min_freq"); echo "960000" > "$cpu_policy/scaling_max_freq" || echo "$MIN_FREQ" > "$cpu_policy/scaling_max_freq"
            fi
        done
    else
        sysctl -w vm.swappiness=90 > /dev/null 2>&1;
    fi
    ;;
  *)
    GOV_PRIORITY="schedutil interactive ondemand"; TCP_PRIORITY="cubic"; IO_PRIORITY="noop deadline cfq";
    ZRAM_ENABLED=true; ZRAM_SIZE_MB=$((TOTAL_RAM_MB * 3 / 4));
    sysctl -w kernel.sched_autogroup_enabled=1 > /dev/null 2>&1; sysctl -w vm.swappiness=80 > /dev/null 2>&1;
    setprop persist.sys.ui.hw true; setprop ro.performance.tuning 0; setprop ro.ril.disable.power.collapse 0;
    setprop windowsmgr.max_events_per_sec 120;
    ;;
esac

AVAILABLE_GOVERNORS=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 2>/dev/null)
FINAL_GOVERNOR=""
for GOV in $GOV_PRIORITY; do
    if echo "$AVAILABLE_GOVERNORS" | grep -q "$GOV"; then
        FINAL_GOVERNOR="$GOV"
        break
    fi
done
if [ -n "$FINAL_GOVERNOR" ]; then
    echo "Applying CPU Governor: $FINAL_GOVERNOR (from priority list: $GOV_PRIORITY)" >> $LOGFILE
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do if [ -f "$cpu" ]; then echo "$FINAL_GOVERNOR" > "$cpu"; fi; done
else
    echo "Warning: No suitable CPU governor found from priority list." >> $LOGFILE
fi

AVAILABLE_TCP=$(cat /proc/sys/net/ipv4/tcp_available_congestion_control 2>/dev/null)
FINAL_TCP=""
for TCP in $TCP_PRIORITY; do
    if echo "$AVAILABLE_TCP" | grep -q "$TCP"; then
        FINAL_TCP="$TCP"
        break
    fi
done
if [ -n "$FINAL_TCP" ]; then
    echo "Applying TCP Algorithm: $FINAL_TCP (from priority list: $TCP_PRIORITY)" >> $LOGFILE
    if [ -f "/proc/sys/net/ipv4/tcp_congestion_control" ]; then echo "$FINAL_TCP" > "/proc/sys/net/ipv4/tcp_congestion_control"; fi
else
    echo "Warning: No suitable TCP algorithm found from priority list." >> $LOGFILE
fi

AVAILABLE_SCHEDULERS=$(cat /sys/block/sda/queue/scheduler 2>/dev/null || cat /sys/block/mmcblk0/queue/scheduler 2>/dev/null)
FINAL_IO_SCHED=""
for IO in $IO_PRIORITY; do
    if echo "$AVAILABLE_SCHEDULERS" | grep -q "$IO"; then
        FINAL_IO_SCHED="$IO"
        break
    fi
done
if [ -n "$FINAL_IO_SCHED" ]; then
    echo "Applying I/O Scheduler: $FINAL_IO_SCHED (from priority list: $IO_PRIORITY)" >> $LOGFILE
    for queue in /sys/block/sd*/queue /sys/block/mmcblk*/queue; do if [ -f "$queue/scheduler" ]; then echo "$FINAL_IO_SCHED" > "$queue/scheduler"; fi; done
else
    echo "Warning: No suitable I/O scheduler found from priority list." >> $LOGFILE
fi

echo "Applying ZRAM config. Enabled: $ZRAM_ENABLED. Size: ${ZRAM_SIZE_MB}MB" >> $LOGFILE
if [ -e /sys/block/zram0 ]; then
    swapoff /dev/block/zram0 > /dev/null 2>&1; echo 1 > /sys/block/zram0/reset; sleep 1
    if $ZRAM_ENABLED; then
        if [ "$ZRAM_SIZE_MB" -lt 1024 ]; then ZRAM_SIZE_MB=1024; fi
        if [ "$ZRAM_SIZE_MB" -gt 8192 ]; then ZRAM_SIZE_MB=8192; fi
        echo lz4 > /sys/block/zram0/comp_algorithm; echo "${ZRAM_SIZE_MB}M" > /sys/block/zram0/disksize
        mkswap /dev/block/zram0 > /dev/null 2>&1; swapon /dev/block/zram0 > /dev/null 2>&1
    fi
fi

echo "Tweak application complete." >> $LOGFILE