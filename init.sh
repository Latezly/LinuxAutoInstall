#!/bin/bash
set -e

modify_ssh_config() {
    sed -i 's/^#\?Port .*/Port 4747/' /etc/ssh/sshd_config
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin without-password/' /etc/ssh/sshd_config
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

    if systemctl is-active --quiet ssh; then
        systemctl restart ssh
    elif systemctl is-active --quiet sshd; then
        systemctl restart sshd
    else
        echo "警告: 未找到 ssh 服务，请手动检查"
    fi
}

configure_ssh_keys() {
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    cat > /root/.ssh/authorized_keys << 'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAABAEAruM8Rku6KNEHReToq+QadcPh2PUkDLhbv07O/v48tcuJ3JO5AlZYaNmtMhOmDde394hyFEZM9kJxVG7kxhiLw7rXxJec0Zmm9hoivYGcFeyX3wXfq71HOZaeblhWGzKUc4zq2tUevabUZRkKK3sF4m2josPvr1agrJsJDavAvQNbi91O1gqpKF9OPSLPZnXv5Tk+uE/KjCTowZxph9S/eYyqaw+OGcnDPgN1RSBBxucbYP7VAEnZXkml437Q6ZVXXrSjY3YWsNCe+NnjI6GEcJZtFFiVzNooUnhyhKoX5sqB6rHYKQMWMaZ1e9OEsbHnLrw47ol2emgP/J2Sig/NbP0DajFLQZc99x+4V5dOgZZqKJGWnbTdagnHmNiFqLNSDInOf0cDK9YSMGbXoYbHxSH4UdgARHuM8AOq8PSrNftdMvvKuD2bTmmhLBq1rj4RM1k6wMLY+8x19x0BGPhVtyCHTkoNhztYmqwmoLaBl/SA048F8hTTuziI2yPzihfLhVGL/SBfkVFxiwgzUjzydb6oGSEMogmRfxb8mcFtrjXlwl8jfFJaZfEMrmgW1YT3Ox/53fTLQAQhaFzsI+FiuWcxjPwcrgLP2+7zzYDvJ18Kjuk+SVUl8KuQM1f6QxrrDQ5lcWM0Hm/HYr2nCb6Zi62nRzkj7VRDR5aJfq+BFn2cLifeaKDNB3tjDpzeGVyLdyNbSy5fzqJC+rp1tN+lbdAY36DyQgm90WD1DYpGgW098WKM/F7U7lxPkWxhjUIeBgDjJ1dHj2IoeHfk1WIOXzZCjjx++HEdVv7COheZa6IN3ySTIjbgsMgdgq+Qgwi2VkPfnV/gLziS9/CfgT74CwLfR4O9MaMFh4LdGsmlQYZrgUAj53GiVeUE3K5s5cp2WQWK1nCY5/s8fLiMxEcVEIerbyZFrKjCEokEqsQA4PBfVy0vqtGKKY0o4BpP3JYW4WpXelliJ5GdfxEXS6SqPW0mQRqVDV8wkB5up5qjq8NPpHTSskdONsUmmAePShUoGntIrFYQ0VLY73FxgKcU3tbqwDjyKdckDUq9AA67YFNcMJzDWb6QjYDg2fiyD6zs/d2/sfCHB8apBtZR2TOIgHElIq0/KRQIuW9UFPQJ6oPIEAmdn4i5meVnWLJCYkmT5cXOjRQENtRQexE5sVqdOeshqbCA8AB+3oitBe5ddyppi1aOayhKVBQG1ZQxkVw6F9MAIRycYLgRee4bSjEYuq2I+VGrNr7DpLM/vUm3Wy2vs5nYhU/Tcqa4oGG42fmNzn6ZZhofaajRnAdUPdJI3Aviv2P1UlOqM9TUXsiStGIKCzp0xkzHG8SGYksJ/WaOe/U2iYJKqxLRoJzxAVOSVw==
EOF
    chmod 600 /root/.ssh/authorized_keys
}

write_bashrc() {
    cat > /etc/bash.bashrc << 'EOF'
BASHRCVERSION="23.1"
EDITOR=nano; export EDITOR=nano
USER=`whoami`
TMPDIR=$HOME/.tmp/
HOSTNAME=`hostname -s`
IDUSER=`id -u`
PROMPT_COMMAND='echo -ne "\033]0;${USER}(${IDUSER})@${HOSTNAME}: ${PWD}\007"'
export LS_COLORS='rs=0:di=01;33:ln=00;36:mh=00:pi=40;33:so=00;35:do=00;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.log=02;36:*.torrent=02;37:*.conf=02;36:*.sh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.tlz=00;31:*.txz=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.dz=00;31:*.gz=00;31:*.lz=00;31:*.xz=00;31:*.bz2=00;31:*.tbz=00;31:*.tbz2=00;31:*.bz=00;31:*.tz=00;31:*.tcl=00;31:*.deb=00;31:*.rpm=00;31:*.jar=00;31:*.rar=00;31:*.ace=00;31:*.zoo=00;31:*.cpio=00;31:*.7z=00;31:*.rz=00;31:*.jpg=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.pbm=00;35:*.pgm=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.tiff=00;35:*.png=00;35:*.svg=00;35:*.svgz=00;35:*.mng=00;35:*.pcx=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:*.m2v=00;35:*.mkv=00;35:*.ogm=00;35:*.mp4=00;35:*.m4v=00;35:*.mp4v=00;35:*.vob=00;35:*.qt=00;35:*.nuv=00;35:*.wmv=00;35:*.asf=00;35:*.rm=00;35:*.rmvb=00;35:*.flc=00;35:*.avi=00;35:*.fli=00;35:*.flv=00;35:*.gl=00;35:*.dl=00;35:*.xcf=00;35:*.xwd=00;35:*.yuv=00;35:*.cgm=00;35:*.emf=00;35:*.axv=00;35:*.anx=00;35:*.ogv=00;35:*.ogx=00;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
export TERM=xterm;TERM=xterm
export GPG_TTY=$(tty)

COLDBLUE="\e[0;38;5;33m"
SCOLDBLUE="\[\e[0;38;5;33m\]"
DFSCRIPT="${HOME}/.du.sh"
if [ ! -e $DFSCRIPT ]; then
cat >"$DFSCRIPT"<< '__EOF__'
#!/bin/bash
let TotalBytes=0
for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }')
do
    let TotalBytes=$TotalBytes+$Bytes
done
if [ $TotalBytes -lt 1024 ]; then
           TotalSize=$(echo -e "scale=1 \n$TotalBytes \nquit$(tput sgr0)" | bc)
           suffix="b"
    elif [ $TotalBytes -lt 1048576 ]; then
           TotalSize=$(echo -e "scale=1 \n$TotalBytes/1024 \nquit$(tput sgr0)" | bc)
           suffix="kb"
        elif [ $TotalBytes -lt 1073741824 ]; then
           TotalSize=$(echo -e "scale=1 \n$TotalBytes/1048576 \nquit$(tput sgr0)" | bc)
           suffix="Mb"
else
           TotalSize=$(echo -e "scale=1 \n$TotalBytes/1073741824 \nquit$(tput sgr0)" | bc)
           suffix="Gb"
fi
echo -en "${TotalSize}${suffix}"
__EOF__

chmod u+x $DFSCRIPT
fi

alias ls='ls --color=auto'
alias dir='ls --color=auto'
alias vdir='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function normal() {
Red="$(tput bold ; tput setaf 1)"
Green="$(tput bold ; tput setaf 2)"
Blue_1="$(tput bold ; tput setaf 6)"
Blue_2="$(tput bold ; tput setaf 4)"
Yellow="$(tput bold ; tput setaf 3)"
Purple="$(tput bold ; tput setaf 5)"
White="$(tput bold ; tput setaf 7)"
Reset="$(tput sgr0)"
if [ $(id -u) == 0 ] ; then
    export PS1='\[$Reset\][\[$Red\]\u\[$Yellow\]@\[$Blue_1\]\h\[$Reset\]]:(\[$Blue_2\]$($DFSCRIPT)\[$Reset\]) \[$Yellow\]\w \[$Purple\]\$ \[$Reset\]'
else
    export PS1='\[$Reset\][\[$Green\]\u\[$Yellow\]@\[$Blue_1\]\h\[$Reset\]]:(\[$Blue_2\]$($DFSCRIPT)\[$Reset\]) \[$Yellow\]\w \[$Purple\]\$ \[$Reset\]'
fi
}

case $TERM in
    rxvt*|screen*|cygwin)
        export PS1='\u\@\h\w'
    ;;
    xterm*|linux*|*vt100*|cons25)
        normal
    ;;
    *)
        normal
        ;;
esac

function download() { /usr/local/bin/webBenchmark_linux_x64 -c 16 -s "https://dlied4.myapp.com/myapp/1104466820/cos.release-40109/10040714_com.tencent.tmgp.sgame_a2365718_3.81.1.8_XgeR1j.apk" ;}
function download_stop() { /usr/bin/kill `ps -ef | grep webBenchmark_linux_x64 | grep -v grep | awk '{print $2}'` ; }
function big_file() { du -h ./ --max-depth=1 | sort -hr | head -n 10 ; }
function nat_type() { pystun -H stun.qq.com ; }
function get_ip()   { curl -sS "http://api.myip.la/cn?json" | jq ; }
function get_dns()  { curl -sS http://only-147889-117-153-99-19.nstool.yqkk.link/ | iconv -f gbk -t utf8 | sed 's/<br>/\n/g' ; echo; }

function swap() {
local TMPFILE=tmp.$$
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1
    mv "$1" $TMPFILE; mv "$2" "$1"; mv $TMPFILE "$2"
}

if [ -e /etc/bash_completion ] && ! shopt -oq posix; then source /etc/bash_completion; fi
if [ -e ~/.custom ]; then source ~/.custom; fi
EOF
}

update_profile() {
    if ! grep -q 'source /etc/bash.bashrc' /root/.profile; then
        echo 'source /etc/bash.bashrc' >> /root/.profile
    fi
}

change_apt_source() {
    cat > /etc/apt/sources.list << 'EOF'
deb https://mirrors.cernet.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.cernet.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.cernet.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://mirrors.cernet.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
}

install_packages() {
    apt update && apt -y upgrade
    apt -y install git curl wget vim screen htop neofetch python3 python3-pip bc jq lrzsz vnstat sysstat nload iftop net-tools
}

others(){
    > /etc/motd
}

main() {
    modify_ssh_config
    configure_ssh_keys
    write_bashrc
    update_profile
    change_apt_source
    install_packages
    others
}

main
