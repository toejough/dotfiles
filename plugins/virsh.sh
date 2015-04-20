
function virsh-get-ip() {
    ip_cmd="echo \"${1} IP:\" \$(arp -an | grep \$(sudo virsh dumpxml ${1} | grep 'mac address' | cut -d \' -sf 2) | tr \( - | tr \) - | cut -d - -sf 2)"
    if [[ $# -gt 1 ]]; then
        ssh -tq $2 $ip_cmd
    else
        eval $ip_cmd
    fi
}
