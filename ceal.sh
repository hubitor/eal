#Current version of script
version="1.6 Pre-Cleaned, 2014"

#DANGEROUS - Formatting

    #Auto formatting + mounting switch
    fauto=0

    #Devices to format
    fdevices=( /dev/sdb5 /dev/sdb6 )
    #File system
    ffs=( mkfs.ext4 mkfs.ext4 )
    #Mount point
    fmount=( /mnt /mnt/home )

#Switches

    #Automode (if 0, you will be prompted on each step)
    auto=0

    #If 1, setup netctl ethernet-static; otherwise setup dhcpcd
    netctl=1

    #If 1, your fstab's partitions mounted under /mnt will be set to 'discard'
    ssd=1

    #If 1, copy windows fonts
    winfonts=1

#Constants

    #Editor (change to nano if you don't like vi)
    edit=vi

    #Hostname
    hostname=ewanhost

    #Local timezone
    timezone=Europe/Minsk

    #NetCtl settings
    interface=enp2s0
    ip=192.168.100.22
    dns=192.168.100.1

    #Username & username2 login
    username=ewancoder
    username2=lft

#Devices information

    #Backup device
    backup=/dev/sda5
    bafs=ext4
    baparams=rw,relatime

    #Cloud device
    cloud=/dev/sdb4
    clfs=ext4
    clparams=rw,relatime,discard

    #Grub MBR device
    device=/dev/sdb

    #Windows device
    windows=/dev/sdb1

#Additionals constants
    
    #Mirrorlists
    mirrors=( Belarus United Denmark France Russia )

    #Git params
    gitname=ewancoder
    gitemail=ewancoder@gmail.com
    gittool=vimdiff
    giteditor=vim

    #dotfiles repositories
    githome=ewancoder/dotfiles.git
    gitetc=ewancoder/etc.git

    #git submodules to recursive update
    gitmodules=".oh-my-zsh .vim/bundle/vundle"

#------------------------------
#Output styling
    Green=$(tput setaf 2)
    Yellow=$(tput setaf 3)
    Red=$(tput setaf 1)
    Bold=$(tput bold)
    Def=$(tput sgr0)

title(){
    echo -e $Bold$Green$1$Def
}

pause(){
    read -p $Bold$Yellow"Continue [ENTER]"$Def
}

mess(){
    echo -e $Bold$Green"\n-> "$Def$Bold$1$Def
    if [ $auto -eq 0 ]
    then
        pause
    fi
}

messpause(){
    echo -e $Bold$Yellow"\n-> "$1$Def
    pause
}

warn(){
    echo -e "\n"$Bold$Red$1$Def
    pause
}

#------------------------------
#Link functions

balink(){
    cp -r /mnt/backup/Arch/$1 ~/$2
    sudo ln -fs ~/$2 /root/$2
    sudo cp -r /mnt/backup/Arch/$1 /home/$username2/$2
    sudo chown -R $username2:users /home/$username2/$2
}

foldlink(){
    sudo cp -nr /etc/$1/* /etc/.dotfiles/$1/
    sudo rm -r /etc/$1
    sudo ln -fs /etc/.dotfiles/$1 /etc/$1
}

link(){
    ln -fs ~/.dotfiles/$1 ~/$1
    sudo ln -fs ~/$1 /root/$1
    sudo cp -r ~/.dotfiles/$1 /home/$username2/$1
    sudo chown -R $username2:users /home/$username2/$1
}
