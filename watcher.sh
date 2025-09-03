#!/system/bin/sh
# LuwengSense Zenith By KepalaLuweng

MODDIR="/data/adb/modules/LuwengSense"
LOGFILE="/data/luwengsense_watcher_log.txt"

rm -f $LOGFILE
sleep 15

# Init config files
[ ! -f "$MODDIR/watched_apps.conf" ] && touch "$MODDIR/watched_apps.conf"
[ ! -f "$MODDIR/watcher_state.conf" ] && echo "default" > "$MODDIR/watcher_state.conf"
[ ! -f "$MODDIR/previous_profile.conf" ] && echo "normal" > "$MODDIR/previous_profile.conf"

log_message() {
    echo "$(date '+%d-%m-%y %H:%M:%S') - $1" >> $LOGFILE
}

apply_profile() {
    local new_profile="$1"
    echo "$new_profile" > "$MODDIR/profile.conf"
    sh "$MODDIR/apply_tweaks.sh"
    echo "$new_profile" > "$MODDIR/watcher_state.conf"

    if [ "$new_profile" = "gaming" ]; then
        log_message "Switched to Gaming Profile for app: $CURRENT_APP"
        su -c 'am broadcast -a com.kernelsu.foss.toast -e message "LuwengSense: Gaming Mode Activated"'
    else
        log_message "Reverted to $new_profile Profile."
        su -c "am broadcast -a com.kernelsu.foss.toast -e message \"LuwengSense: Reverted to $new_profile\""
    fi
}

get_foreground_app_pkg() {
    local last_app=""
    local pid_paths="/dev/cpuset/top-app/tasks /dev/cpuset/foreground/tasks"
    for path in $pid_paths; do
        if [ -f "$path" ]; then
            while read -r pid; do
                if [ -n "$pid" ] && [ -f "/proc/$pid/cmdline" ]; then
                    pkg_name=$(tr -d '\0' < "/proc/$pid/cmdline")
                    case "$pkg_name" in
                        "system_server"|"com.android.systemui"|*"launcher"*|*"inputmethod"*)
                            continue ;;
                        *)
                            last_app="$pkg_name" ;;
                    esac
                fi
            done < "$path"
        fi
    done
    echo "$last_app"
}

echo "--------- Watcher Service Started at $(date) ---------" > $LOGFILE

while true; do
    CURRENT_PROFILE_MODE=$(cat "$MODDIR/profile.conf")
    CURRENT_STATE=$(cat "$MODDIR/watcher_state.conf")

    # Kalau user tidak di auto, kembalikan manual profile setelah game
    if [ "$CURRENT_PROFILE_MODE" != "auto" ]; then
        if [ "$CURRENT_STATE" = "gaming" ]; then
            REVERT_PROFILE=$(cat "$MODDIR/previous_profile.conf" 2>/dev/null)
            apply_profile "${REVERT_PROFILE:-normal}"
        fi
        sleep 10
        continue
    fi

    CURRENT_APP=$(get_foreground_app_pkg)

    IS_WATCHED_APP=false
    if [ -n "$CURRENT_APP" ] && grep -qF "$CURRENT_APP" "$MODDIR/watched_apps.conf"; then
        IS_WATCHED_APP=true
    fi

    if [ "$IS_WATCHED_APP" = "true" ] && [ "$CURRENT_STATE" != "gaming" ]; then
        # simpan profil sebelum masuk gaming (auto tetap tersimpan)
        echo "$CURRENT_PROFILE_MODE" > "$MODDIR/previous_profile.conf"
        apply_profile "gaming"
    elif [ "$IS_WATCHED_APP" = "false" ] && [ "$CURRENT_STATE" = "gaming" ]; then
        # revert sesuai previous (default: auto)
        REVERT_PROFILE=$(cat "$MODDIR/previous_profile.conf" 2>/dev/null)
        apply_profile "${REVERT_PROFILE:-auto}"
    fi

    sleep 3
done