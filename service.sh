#!/system/bin/sh
# LuwengSense Zenith By KepalaLuweng

MODDIR=${0%/*}
LOGFILE="/data/luwengsense_log.txt"

(
  while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 5
  done

  sleep 60
  
  echo "Applying Memory Cgroup Tweaks..." > $LOGFILE
  
  if [ -w /dev/memcg/memory.swappiness ]; then echo '100' > /dev/memcg/memory.swappiness; fi
  if [ -w /dev/memcg/system/memory.swappiness ]; then echo '40' > /dev/memcg/system/memory.swappiness; fi
  if [ -w /dev/memcg/apps/memory.swappiness ]; then echo '50' > /dev/memcg/apps/memory.swappiness; fi

  for clear in $(cat /dev/memcg/system/cgroup.procs 2>/dev/null); do
      if [ -w /dev/memcg/cgroup.procs ]; then echo $clear > /dev/memcg/cgroup.procs; fi
  done

  UI_PROCS="system_server surfaceflinger vendor.qti.hardware.display.composer-service"
  for i in 2.0 2.1 2.2 2.3 2.4; do
      UI_PROCS="$UI_PROCS android.hardware.graphics.composer@$i-service"
  done
  
  for process_name in $UI_PROCS; do
      pid_proc=$(pidof "$process_name")
      if [ -n "$pid_proc" ] && [ -w /dev/memcg/system/cgroup.procs ]; then
          echo $pid_proc > /dev/memcg/system/cgroup.procs
      fi
  done
  echo "Memory Cgroup Tweaks Applied." >> $LOGFILE
  
  echo "Applying LuwengSense Profile Tweaks..." >> $LOGFILE
  sh "$MODDIR/apply_tweaks.sh" >> $LOGFILE 2>&1

  sh "$MODDIR/watcher.sh" &

) &
