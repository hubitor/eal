#!/bin/bash
source ceal.sh
warn "Before executing script, MAKE SURE that you've mounted\n\t1) Windows partition to /mnt/windows\n\t2) Dropbox partition to /home/$username/Dropbox"

#After-X instructions
    #After installing all this, you need to do smth. on your own
    #1) Setup BitlBee twitter account
        #Run sc (open screen irssi session)
        #Open bitlbee window, run
            #register <passwd>
            #account add twitter ewancoder
            #account on
            #<go to token link to accept>
    #2) Unlock michrophone by using bad-way :/
        #Install pavucontrol
        #Unlock michrophone (rear mic buildin)
        #Uninstall pavucontrol
    #3) [optional] setup alsa standard sink & source
        #pactl list
        #pacmd set-default-{sink,source} X

mess "Download package-query.tar.gz file"
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
mess "UnTar package-query.tar.gz archive"
tar xvf package-query.tar.gz
mess "Cd into package-query directory"
cd package-query
mess "Makepkg here"
makepkg -s --noconfirm
mess "Install .xz package using pacman"
sudo pacman -U --noconfirm *.xz
mess "Download yaourt.tar.gz file"
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
mess "UnTar yaourt.tar.gz archive"
tar xvf yaourt.tar.gz
mess "Cd into yaourt directory"
cd yaourt
mess "Makepkg here"
makepkg --noconfirm
mess "Install .xz package using pacman"
sudo pacman -U --noconfirm *.xz
mess "Cd into home directory and remove all archives and dirs respectively"
cd && rm -r package-query*

mess "Install git"
sudo rm /var/lib/pacman/db.lck #Need this cause pacman is still locked when installing on ssd very quickly
yaourt -S --noconfirm git
mess "Configure git user.name"
git config --global user.name ewancoder
mess "Configure git user.email"
git config --global user.email ewancoder@gmail.com
mess "Configure git merge.tool"
git config --global merge.tool vimdiff
mess "Configure git core.editor"
git config --global core.editor vim
mess "Make link to .gitconfig for /root user"
sudo ln -s ~/.gitconfig /root/
mess "Clone ~/.dotfiles github repository"
git clone https://github.com/ewancoder/dotfiles.git .dotfiles
mess "Clone /etc/.dotfiles github repository"
sudo git clone https://github.com/ewancoder/etc.git /etc/.dotfiles
mess "Cd into .dotfiles & pull submodules: oh-my-zsh & vundle"
cd .dotfiles && git submodule update --init --recursive .oh-my-zsh .vim/bundle/vundle
mess "Make vim swap & backup dirs"
mkdir .vim/{swap,backup}
mess "Cd into home directory"
cd

mess "Merge all git links: Now will be executed script that will merge all git links from ~/.dotfiles & from /etc/.dotfiles"
./peal-merge.sh

mess "Make grub config based on new scripts + image"
sudo grub-mkconfig -o /boot/grub/grub.cfg
mess "Generate locales (en+ru)"
sudo locale-gen
mess "Link gvim config for /root user"
sudo ln -s ~/.vim /root/.vim
sudo ln -s ~/.vimrc /root/.vimrc
mess "Set font cyr-sun16"
sudo setfont cyr-sun16
mess "Update yaourt/pacman including multilib"
yaourt -Syy

mess "Install Audio software (1/7)"
yaourt -S --noconfirm alsa-plugins alsa-utils pulseaudio pulseaudio-alsa lib32-libpulse lib32-alsa-plugins
mess "Install A Drivers software (2/7)"
yaourt -S --noconfirm lib32-nvidia-libgl mesa nvidia nvidia-libgl phonon-gstreamer
mess "Install Coding software (3/7)"
yaourt -S --noconfirm python python-matplotlib python-numpy python-scipy python-sphinx tig
mess "Install Core software (4/7)"
yaourt -S --noconfirm devilspie dunst faience-icon-theme feh fuse encfs ntfs-3g gxkb kalu p7zip preload rsync rxvt-unicode screen terminus-font transset-df ttf-dejavu xorg-server xorg-server-utils xorg-xinit wmii-hg urxvt-perls xarchiver xclip xcompmgr zsh
mess "Install Graphics software (5/7)"
yaourt -S --noconfirm geeqie gource scrot vlc
mess "Install Internet software (6/7)"
yaourt -S --noconfirm bitlbee canto chromium chromium-libpdf chromium-pepper-flash djview4 icedtea-web-java7 deluge dropbox irssi openssh perl-html-parser skype

#These won't install if merged earlier
mess "Pulseaudio instead of alsa (pulseaudio won't install if merged earlier) - /etc/pulse folder"
link "pulse"
mess "Bitlbee config (bitlbee won't install if merged earlier) - /etc/bitlbee folder"
link "bitlbee"

mess "Install Office software (7/7)"
yaourt -S --noconfirm anki gvim kdegraphics-okular libreoffice-calc libreoffice-common libreoffice-impress libreoffice-math libreoffice-writer libreoffice-en-US hyphen hyphen-en hyphen-ru hunspell hunspell-en hunspell-ru thunar thunar-dropbox

#Additional not-inistalled software
#Games - extremetuxracer, kdegames-kolf, kdegames-konquest, openbve, pingus, rocksndiamonds, steam, supertux, supertuxcart, warmux, wesnoth
#Graphics - gimp, inkscape, krita, mypaint
#Testing - gparted, smartmontools
#Video editing - openshot
#Wind-a - mono virtualbox wine wine_gecko wine-mono

mess "Fix dead acute error in Compose-keys X11 file :)"
sudo sed -i "s/dead actute/dead acute/g" /usr/share/X11/locale/en_US.UTF-8/Compose > compose
sudo mv compose /usr/share/X11/locale/en_US.UTF-8/Compose

mess "Change bitlbee folder owner to bitlbee:bitlbee"
sudo mkdir -p /var/lib/bitlbee
sudo chown -R bitlbee:bitlbee /var/lib/bitlbee
mess "Activate & start bitlbee"
sudo systemctl enable bitlbee
sudo systemctl start bitlbee
mess "Activate & start preload"
sudo systemctl enable preload
sudo systemctl start preload
mess "Change shell to /bin/zsh for $username user"
sudo chsh -s /bin/zsh $username
mess "Activate fuse (modprobe)"
sudo modprobe fuse
messpause "Generate new ssh key for my github [MANUAL]"
ssh-keygen -t rsa -C "ewancoder@gmail.com"
mess "Link this ssh for /root user to be able to do 'sudo git'"
sudo ln -s ~/.ssh /root/.ssh
mess "Change Dropbox folder owner to $username"
sudo chown $username:users

if [ $winfonts -eq 1 ]
then
    messpause "Mount windows partition to /mnt/windows [MANUAL]"
    warn "Do it yourself on the second terminal and then, when all done, press [ENTER]"
    mess "Copy windows fonts to /usr/share/fonts/winfonts"
    sudo cp -r /mnt/windows/Windows/Fonts /usr/share/fonts/winfonts
    mess "Update fonts cache"
    sudo fc-cache -fv
fi

messpause "Change password for irssi config freenode autocmd [MANUAL]"
cp ~/.irssi/config_sample ~/.irssi/config
vim ~/.irssi/config

messpause "Download and place canadian icon into /usr/share/gxkb/flags/ca(fr).png"
curl -O http://files.softicons.com/download/web-icons/flags-icons-by-gosquared/png/24x24/Canada.png
sudo mv Canada.png /usr/share/gxkb/flags/ca\(fr\).png

messpause "Run :BundleInstall within vim to install all plugins"
vim

mess "Remove files"
sudo rm *eal*
exit
