# Интернет для ВМ стенда — вторая сетевая карта «на горячую» в сети lab-nat.
# Карта подключается к работающей ВМ (--live) и исчезает при её выключении,
# поэтому забыть отключить интернет невозможно.
#
# Подключение: в ~/.zshrc добавить строку   source /путь/к/lab-net.zsh
# Нужно: export LIBVIRT_DEFAULT_URI=qemu:///system
#
# Использование:  lab-net-on lab-ws01   →  работа  →   lab-net-off lab-ws01

typeset -A LABMAC
LABMAC=(lab-ws01 52:54:00:09:0f:02  lab-ws02 52:54:00:09:0f:03  lab-lnx01 52:54:00:09:0f:04
        lab-wazuh 52:54:00:09:0f:05  lab-kali 52:54:00:09:0f:06)

lab-net-on()  { [[ -n ${LABMAC[$1]} ]] || { echo "нет MAC для $1"; return 1; }
                virsh attach-interface "$1" network lab-nat --model virtio --mac "${LABMAC[$1]}" --live && virsh domiflist "$1"; }

lab-net-off() { [[ -n ${LABMAC[$1]} ]] || { echo "нет MAC для $1"; return 1; }
                virsh detach-interface "$1" network --mac "${LABMAC[$1]}" --live && virsh domiflist "$1"; }
