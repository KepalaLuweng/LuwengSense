#!/system/bin/sh
# LuwengSense Zenith Installer
# By KepalaLuweng

SKIPUNZIP=1
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2

# Simple print wrapper
ui_print() {
  echo "$1"
}

# Fancy box for headers
ui_box() {
  ui_print " "
  ui_print "====================================="
  ui_print "   $1"
  ui_print "====================================="
  ui_print " "
}

# Kernel feature analysis
run_feature_analysis() {
  ui_box "Kernel Feature Analysis"
  ui_print "- Analyzing your kernel's supported features..."
  sleep 1.5

  GOVS=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors 2>/dev/null)
  IOS=$(cat /sys/block/sda/queue/scheduler 2>/dev/null || cat /sys/block/mmcblk0/queue/scheduler 2>/dev/null)
  TCPS=$(cat /proc/sys/net/ipv4/tcp_available_congestion_control 2>/dev/null)

  ui_print "-------------------------------------"
  ui_print " [ CPU Governors ]"
  ui_print " LuwengSense seeks: performance, schedutil, interactive"
  ui_print " Your kernel has: $GOVS"
  ui_print "-------------------------------------"
  sleep 1.5

  ui_print "-------------------------------------"
  ui_print " [ I/O Schedulers ]"
  ui_print " LuwengSense seeks: bfq, noop, deadline, cfq"
  ui_print " Your kernel has: $(echo $IOS | sed 's/\[//g;s/\]//g')"
  ui_print "-------------------------------------"
  sleep 1.5

  ui_print "-------------------------------------"
  ui_print " [ TCP Algorithms ]"
  ui_print " LuwengSense seeks: bbr, cubic"
  ui_print " Your kernel has: $TCPS"
  ui_print "-------------------------------------"
  sleep 1.5

  ui_box "Analysis Complete"
  ui_print " LuwengSense will automatically"
  ui_print " select the best supported settings."
  sleep 3
}

# --- MAIN ---

ui_box "LuwengSense Zenith by KepalaLuweng"
sleep 1

run_feature_analysis

ui_print "-------------------------------------"
ui_print "- Installing with 'Normal' as default profile..."
echo "normal" > "$MODPATH/profile.conf"
sleep 1.5
ui_print "  [✓] Default profile set to 'Normal'!"
ui_print " "
ui_print "  [ i ] NOTE: You can change the profile anytime"
ui_print "        from the Control Panel after reboot."
ui_print "-------------------------------------"
sleep 2

ui_print "- Creating placebo files for thermal disabling..."
mkdir -p $MODPATH/system/vendor/bin
touch $MODPATH/system/vendor/bin/thermal
touch $MODPATH/system/vendor/bin/thermal_manager
ui_print "  [✓] Thermal placebo files created."
sleep 1.5

ui_print "- Finalizing installation..."
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/handler.sh" 0 0 0755
set_perm "$MODPATH/apply_tweaks.sh" 0 0 0755
set_perm "$MODPATH/profile.conf" 0 0 0644
ui_print "  [✓] Permissions set."
sleep 1.5

ui_box "Installation Complete"
ui_print "-> Please reboot your device to activate LuwengSense."
ui_print " "
sleep 2
ui_print "⚠️  IMPORTANT NOTE:"
ui_print " Please wait at least 1 minute after reboot"
ui_print " before opening the Control Panel or switching"
ui_print " profiles to ensure all tweaks are fully applied."
ui_print " "