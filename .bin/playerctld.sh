# playerctl in bash using dbus-bin,dbus
COMMAND="$1"
PLAYERS=$(dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep 'org.mpris.MediaPlayer2' | awk -F '"' '{print $2}')

if [ -z "$COMMAND" ]; then
    echo "$PLAYERS"
    echo "Please provide a command: (n)ext, (pp)play-pause, (p)revious, (s)top"
    exit 1
fi


if pgrep -x "mpv" > /dev/null; then
    case "$COMMAND" in
        "next")
            echo "script-binding uosc/next" | socat - /tmp/mpv
            exit 0
            ;;
        "play-pause")
            echo "script-binding uosc/prev" | socat - /tmp/mpv
            exit 0
            ;;
    esac
fi

case "$COMMAND" in
    "next")
        DBUS_COMMAND="Next"
        ;;
    "play-pause")
        DBUS_COMMAND="PlayPause"
        ;;
    "previous")
        DBUS_COMMAND="Previous"
        ;;
    "stop")
        DBUS_COMMAND="Stop"
        ;;
    *)
        echo "Unknown command: $COMMAND"
        exit 1
        ;;
esac


for INSTANCE in $PLAYERS; do
    dbus-send --session --dest="$INSTANCE" --type=method_call /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."$DBUS_COMMAND"
done
