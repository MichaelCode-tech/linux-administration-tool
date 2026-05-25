#!/usr/bin/env bash
# Unified Linux Administration Tool
# Created by MichaelCode-tech 
# Combines: System Info, Cleaner, User/Group Management, Archiving, Search TUI, Systemd, Links, and Swap

IFS=$'\n\t'

#====== MAIN MENU ======#
main_menu(){
    while true; do
        clear
        echo "╔════════════════════════════════════╗"
        echo "║    LINUX ADMINISTRATION TOOL       ║"
        echo "║    Created by MichaelCode-tech     ║"
        echo "╚════════════════════════════════════╝"
        echo ""
        echo "1. System Information"
        echo "2. System Cleaner"
        echo "3. User Management"
        echo "4. Group Management"
        echo "5. Archive & Compression"
        echo "6. File Search TUI"
        echo "7. Systemd Service Manager"
        echo "8. File Link Manager"
        echo "9. Linux Swap Manager"
        echo "10. Install Requirements"
        echo "11. Exit"
        echo ""
        read -p "Choose option: " main_choice
        case $main_choice in
            1) system_info_menu ;;
            2) system_cleaner_menu ;;
            3) user_menu ;;
            4) group_menu ;;
            5) archive_main_menu ;;
            6) search_tui_main ;;
            7) systemd_manager_menu ;;
            8) file_link_manager_menu ;;
            9) swap_manager_menu ;;
            10) install_requirements ;;
            11) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

#====== MULTI-DISTRO INSTALL REQUIREMENTS ======#
install_requirements(){
    clear
    echo "═════ MULTI-DISTRO REQUIREMENT INSTALLER ═════"
    echo "Detecting package manager..."
    echo ""

    if command -v apt &>/dev/null; then
        echo "[+] Detected Debian/Ubuntu-based system (apt)"
        sudo apt update
        sudo apt install -y lshw util-linux usbutils pciutils lsscsi hdparm dmidecode inxi whiptail xclip wl-clipboard systemd
    
    elif command -v pacman &>/dev/null; then
        echo "[+] Detected Arch Linux-based system (pacman)"
        sudo pacman -Sy --needed --noconfirm lshw util-linux usbutils pciutils lsscsi hdparm dmidecode inxi newt xclip wl-clipboard systemd
    
    elif command -v dnf &>/dev/null; then
        echo "[+] Detected Red Hat/Fedora-based system (dnf)"
        sudo dnf install -y lshw util-linux usbutils pciutils lsscsi hdparm dmidecode inxi newt xclip wl-clipboard systemd
    
    elif command -v yum &>/dev/null; then
        echo "[+] Detected older Red Hat/CentOS system (yum)"
        sudo yum install -y lshw util-linux usbutils pciutils lsscsi hdparm dmidecode inxi newt xclip wl-clipboard systemd
    
    else
        echo "[-] Error: Package manager not explicitly supported by this auto-installer."
        echo "Please manually verify installation of: lshw, util-linux, usbutils, pciutils, lsscsi, hdparm, dmidecode, inxi, whiptail (newt), xclip, wl-clipboard, systemd"
    fi

    echo ""
    echo "Dependencies alignment verification process complete!"
    read -p "Press Enter to continue..."
}

#====== SYSTEM INFORMATION ======#
system_info_menu(){
    while true; do
        clear
        echo "═════ SYSTEM INFORMATION MENU ═════"
        echo "1. Basic system and kernel info"
        echo "2. Comprehensive hardware listing"
        echo "3. Detailed CPU information"
        echo "4. Block device information"
        echo "5. USB controller and device details"
        echo "6. PCI device information"
        echo "7. SCSI/SATA device details"
        echo "8. Hard disk parameters (/dev/sda)"
        echo "9. RAM information"
        echo "10. Partition information"
        echo "11. DMI/SMBIOS hardware data"
        echo "12. All-in-one system information"
        echo "0. Return to main menu"
        read -p "Choose: " info_choice
        case $info_choice in
            1)
                echo "System name: $(uname)"
                echo "Hostname: $(uname -n)"
                echo "Kernel version: $(uname -v)"
                echo "Kernel release: $(uname -r)"
                echo "Hardware architecture: $(uname -m)"
                read -p "Press Enter to continue..."
                ;;
            2) sudo lshw; read -p "Press Enter to continue..." ;;
            3) lscpu; read -p "Press Enter to continue..." ;;
            4) lsblk -a; read -p "Press Enter to continue..." ;;
            5) sudo lsusb -v 2>/dev/null || lsusb; read -p "Press Enter to continue..." ;;
            6) lspci -t -v; read -p "Press Enter to continue..." ;;
            7) lsscsi -s; read -p "Press Enter to continue..." ;;
            8) 
                if [ -b /dev/sda ]; then
                    sudo hdparm -i /dev/sda
                else
                    echo "Target disk /dev/sda not found. Listing available devices:"
                    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
                fi
                read -p "Press Enter to continue..." 
                ;;
            9) free -h; read -p "Press Enter to continue..." ;;
            10) sudo fdisk -l; read -p "Press Enter to continue..." ;;
            11) dmi_decode_tool ;;
            12) inxi -F; read -p "Press Enter to continue..." ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

dmi_decode_tool(){
    while true; do
        clear
        echo "═════ DMI DECODE TOOL ═════"
        echo "1. Memory"
        echo "2. System"
        echo "3. BIOS"
        echo "4. Processor"
        echo "0. Return"
        read -p "Choose: " dmi_choice
        case $dmi_choice in
            1) sudo dmidecode -t memory; read -p "Press Enter..." ;;
            2) sudo dmidecode -t system; read -p "Press Enter..." ;;
            3) sudo dmidecode -t bios; read -p "Press Enter..." ;;
            4) sudo dmidecode -t processor; read -p "Press Enter..." ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

#====== SYSTEM CLEANER ======#
system_cleaner_menu(){
    while true; do
        clear
        CHOICE=$(whiptail --title "Linux Cleaner" \
        --menu "Select what you want to clean" 15 60 5 \
        "1" "Clean /tmp" \
        "2" "Clean /var/tmp" \
        "3" "Clean user cache (~/.cache)" \
        "4" "Clean ALL" \
        "0" "Return to main menu" \
        3>&1 1>&2 2>&3)

        case $CHOICE in
            1)
                sudo rm -rf /tmp/* 2>/dev/null
                whiptail --msgbox "/tmp cleaned successfully!" 10 40
                ;;
            2)
                sudo rm -rf /var/tmp/* 2>/dev/null
                whiptail --msgbox "/var/tmp cleaned successfully!" 10 40
                ;;
            3)
                rm -rf ~/.cache/* 2>/dev/null
                whiptail --msgbox "User cache cleaned successfully!" 10 40
                ;;
            4)
                sudo rm -rf /tmp/* 2>/dev/null
                sudo rm -rf /var/tmp/* 2>/dev/null
                rm -rf ~/.cache/* 2>/dev/null
                whiptail --msgbox "All temporary files cleaned!" 10 40
                ;;
            0|*)
                return
                ;;
        esac
    done
}

#====== USER MANAGEMENT ======#
user_menu(){
    while true; do
        clear
        echo "═════ USER MANAGEMENT MENU ═════"
        echo "1. Create users"
        echo "2. Delete users"
        echo "3. Set password limits"
        echo "4. Change user password"
        echo "5. Add user to group"
        echo "6. Remove user from group"
        echo "7. Get user information"
        echo "8. Show all users"
        echo "0. Return to main menu"
        read -p "Choose: " user_choice
        case $user_choice in
            1) create_users ;;
            2) delete_users ;;
            3) set_limit_to_user_paswd ;;
            4) change_user_passwd ;;
            5) add_user_to_group ;;
            6) remove_user_from_group ;;
            7) get_info ;;
            8) all_users ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

create_users(){
    while true; do
        clear
        echo "═════ CREATE USERS ═════"
        echo "1. Create simple user"
        echo "2. Create user with custom shell"
        echo "0. Back to user menu"
        read -p "Choose: " create_choice
        case $create_choice in
            1)
                read -p "Enter username: " name
                sudo useradd -m -s /bin/bash --badname "$name"
                echo "User created. Set password:"
                sudo passwd "$name"
                ;;
            2)
                read -p "Enter username: " name
                sudo useradd -m --badname "$name"
                echo "Choose shell:"
                echo "1. bash"
                echo "2. sh"
                echo "3. zsh"
                read -p "Choose: " shell_choice
                case $shell_choice in
                    1) sudo usermod -s /bin/bash "$name" ;;
                    2) sudo usermod -s /bin/sh "$name" ;;
                    3) sudo usermod -s /bin/zsh "$name" ;;
                esac
                echo "Set password:"
                sudo passwd "$name"
                ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

delete_users(){
    while true; do
        clear
        echo "═════ DELETE USERS ═════"
        echo "1. Full delete (with home directory)"
        echo "2. Partial delete (keep home directory)"
        echo "0. Back to user menu"
        read -p "Choose: " delete_choice
        case $delete_choice in
            1)
                echo "All users:"
                awk -F: '$3 >= 1000 {print $1}' /etc/passwd
                read -p "Enter username to delete: " user_to_delete
                read -p "Are you sure? (Y/n): " confirm
                if [[ $confirm == "Y" || $confirm == "y" ]]; then
                    sudo userdel -f -r "$user_to_delete"
                    sudo groupdel -f "$user_to_delete" 2>/dev/null
                    echo "User deleted successfully!"
                fi
                read -p "Press Enter..."
                ;;
            2)
                echo "All users:"
                awk -F: '$3 >= 1000 {print $1}' /etc/passwd
                read -p "Enter username to delete: " user_to_delete
                sudo userdel "$user_to_delete"
                echo "User deleted (home directory kept)"
                read -p "Press Enter..."
                ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

set_limit_to_user_paswd(){
    clear
    echo "═════ SET PASSWORD LIMITS ═════"
    echo "All users:"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd
    read -p "Choose user to modify: " user
    echo ""
    read -p "Set minimum days before password change: " mindays
    read -p "Set maximum days until password change required: " maxdays
    read -p "Set expiration date (YYYY-MM-DD): " expiredate
    read -p "Set inactive days after expiration: " inactive
    read -p "Set warning days before expiration: " warnday
    
    sudo chage -m "$mindays" "$user"
    sudo chage -M "$maxdays" "$user"
    sudo chage -E "$expiredate" "$user"
    sudo chage -I "$inactive" "$user"
    sudo chage -W "$warnday" "$user"
    
    echo ""
    echo "Final result:"
    sudo chage -l "$user"
    read -p "Press Enter..."
}

change_user_passwd(){
    clear
    echo "═════ CHANGE USER PASSWORD ═════"
    echo "All users:"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd
    read -p "Choose user to modify: " passwd_user
    sudo passwd "$passwd_user"
    read -p "Press Enter to return..."
}

add_user_to_group(){
    clear
    echo "═════ ADD USER TO GROUP ═════"
    echo "All users:"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd
    read -p "Choose user: " user_add
    echo ""
    echo "All groups:"
    awk -F: '$3 >= 1000 {print $1}' /etc/group
    read -p "Choose group: " group_add
    sudo usermod -aG "$group_add" "$user_add"
    echo "User added to group!"
    read -p "Press Enter..."
}

remove_user_from_group(){
    clear
    echo "═════ REMOVE USER FROM GROUP ═════"
    echo "All users:"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd
    read -p "Choose user: " user_remove
    echo ""
    echo "User's groups:"
    sudo groups "$user_remove"
    read -p "Choose group to remove: " group_remove
    sudo gpasswd -d "$user_remove" "$group_remove"
    echo "User removed from group!"
    read -p "Press Enter..."
}

get_info(){
    clear
    echo "═════ GET USER INFORMATION ═════"
    echo "All users:"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd
    read -p "Choose user: " info_user
    sudo id "$info_user"
    read -p "Press Enter..."
}

all_users(){
    clear
    echo "═════ ALL SYSTEM USERS ═════"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd
    read -p "Press Enter..."
}

#====== GROUP MANAGEMENT ======#
group_menu(){
    while true; do
        clear
        echo "======= Group Management Menu ========"
        echo "1. Create group"
        echo "2. Delete group"
        echo "3. Show all normal groups"
        echo "4. Modify Group"
        echo "5. List users in a group"
        echo "0. Return to Main Menu"
        read -p "Choose: " choice
        
        case $choice in
            1) create_group ;;
            2) delete_group ;;
            3) show_normal_groups ;;
            4) modify_groups ;;
            5) group_list_users ;;
            0) return ;;
            *) echo "Invalid option" ; sleep 1 ;;
        esac
    done
}

create_group(){
    while true; do
        clear
        echo "======= Create Group ======="
        echo "1. Create a new group"
        echo "0. Back to Group Menu"
        read -p "Choose: " sub_choose
        
        case $sub_choose in
            0) return ;;
            1)
                read -p "Enter the group name: " group_name
                read -p "Do you want a specific GID? (y/N): " want_gid
                case $want_gid in
                    y|Y|yes|YES)
                        read -p "Enter the GID you want: " gid
                        sudo groupadd -g "$gid" "$group_name" && echo "Group created successfully!"
                        ;;
                    *)
                        sudo groupadd "$group_name" && echo "Group created successfully!"
                        ;;
                esac
                sleep 1
                ;;
            *) echo "Please enter a valid choice" ; sleep 1 ;;
        esac
    done
}

delete_group(){
    clear
    echo "======= Delete Group ======="
    awk -F: '$3 >= 1000 {print $1}' /etc/group
    echo "############################"
    read -p "Enter group name to delete (or '0' to cancel): " delete_name
    if [ "$delete_name" != "0" ]; then
        sudo groupdel -f "$delete_name" && echo "Deleted successfully"
    fi
    sleep 1
}

show_normal_groups(){
    clear
    echo "======= Normal Groups (GID >= 1000) ======="
    awk -F: '$3 >= 1000 {print $1 " (GID: "$3")"}' /etc/group
    echo "###########################################"
    read -p "Press Enter to return..." 
}

modify_groups(){
    while true; do
        clear
        echo "======= Modify Groups ======="
        echo "1. Rename group"
        echo "2. Set group password"
        echo "3. Change Group ID (GID)"
        echo "0. Back to Group Menu"
        read -p "Choose: " mod_choose
        
        case $mod_choose in
            0) return ;;
            1)
                read -p "Enter old group name: " old_name
                read -p "Enter new group name: " new_name
                sudo groupmod -n "$new_name" "$old_name" && echo "Renamed successfully"
                ;;
            2)
                read -p "Enter group name to set password: " pass_group
                sudo gpasswd "$pass_group"
                ;;
            3)
                read -p "Enter group name: " gid_group
                read -p "Enter new GID: " new_gid
                sudo groupmod -g "$new_gid" "$gid_group" && echo "GID updated"
                ;;
            *) echo "Invalid choice" ;;
        esac
        sleep 1
    done
}

group_list_users(){
    clear
    read -p "Enter group name to list its users: " gname
    echo "Users in $gname: "
    grep "^$gname:" /etc/group | cut -d: -f4
    read -p "Press Enter to continue..."
}

#====== ARCHIVE & COMPRESSION ======#
archive_main_menu() {
  while true; do
    clear
    echo "--- LINUX ARCHIVE & COMPRESSION TOOL ---"
    echo "1. Archiving Menu (Compress)"
    echo "2. Decompression & Extraction Menu"
    echo "3. System Tools (File Check/Performance)"
    echo "0. Return to Main Menu"
    read -p "Choose: " choose
    case $choose in
      1) archive_compress_menu ;;
      2) decomp_menu ;;
      3) tools_menu ;;
      0) return ;;
      *) echo "Please enter a valid option." ; sleep 1 ;;
    esac
  done
}

archive_compress_menu() {
  while true; do
    clear
    echo "--- ARCHIVING (COMPRESSION) ---"
    echo "1. Lite Archive (.gz) - Fast"
    echo "2. Medium Archive (.bz2) - Balanced"
    echo "3. Deep Archive (.xz) - Maximum"
    echo "4. Bulk Archive All Folders (.tar.xz)"
    echo "0. Return"
    read -p "Choose: " choose
    case $choose in
      1) lite_arch ;;
      2) med_archive ;;
      3) deep_arch ;;
      4) 
        read -p "Enter name for the bulk archive (without extension): " bulk_name
        tar -cJvf "${bulk_name}.tar.xz" */
        echo "Finished bulk archiving." ; sleep 1 ;;
      0) return ;;
      *) echo "Enter a valid option" ; sleep 1 ;;
    esac
  done
}

lite_arch() {
  while true; do
    clear
    echo "-- GZIP COMPRESSION --"
    echo "1. Archive Folder (.tar.gz)"
    echo "2. Archive File (.gz)"
    echo "0. Return"
    read -p "Choose: " choose
    case $choose in
      1)
        read -p "Choose folder to archive: " folder_arch
        read -p "Enter new archive name: " new_arch
        if [ -d "$folder_arch" ]; then
          sudo tar -czf "${new_arch}.tar.gz" "$folder_arch"
          echo "Created ${new_arch}.tar.gz"
        else
          echo "Folder not found: $folder_arch"
        fi ; sleep 1 ;;
      2)
        read -p "Choose file to archive: " file_arch
        read -p "Enter new file name: " file_arch_new
        if [ -f "$file_arch" ]; then
          gzip -c "$file_arch" > "${file_arch_new}.gz"
          echo "Created ${file_arch_new}.gz"
        else
          echo "File not found: $file_arch"
        fi ; sleep 1 ;;
      0) return ;;
    esac
  done
}

med_archive() {
  while true; do
    clear
    echo "-- BZIP2 COMPRESSION --"
    echo "1. Archive Folder (.tar.bz2)"
    echo "2. Archive File (.bz2)"
    echo "0. Return"
    read -p "Choose: " choose
    case $choose in
      1)
        read -p "Folder to archive: " folder_arch
        read -p "New archive name: " new_arch
        if [ -d "$folder_arch" ]; then
          sudo tar -cjf "${new_arch}.tar.bz2" "$folder_arch"
          echo "Created ${new_arch}.tar.bz2"
        fi ; sleep 1 ;;
      2)
        read -p "File to archive: " file_arch
        read -p "New file name: " file_arch_new
        if [ -f "$file_arch" ]; then
          bzip2 -c "$file_arch" > "${file_arch_new}.bz2"
          echo "Created ${file_arch_new}.bz2"
        fi ; sleep 1 ;;
      0) return ;;
    esac
  done
}

deep_arch() {
  while true; do
    clear
    echo "-- XZ COMPRESSION (Deep) --"
    echo "1. Archive Folder (.tar.xz)"
    echo "2. Archive File (.xz)"
    echo "0. Return"
    read -p "Choose: " choose
    case $choose in
      1)
        read -p "Folder to archive: " folder_arch
        read -p "New archive name: " new_arch
        if [ -d "$folder_arch" ]; then
          sudo tar -cJf "${new_arch}.tar.xz" "$folder_arch"
          echo "Created ${new_arch}.tar.xz"
        fi ; sleep 1 ;;
      2)
        read -p "File to archive: " file_arch
        read -p "New file name: " file_arch_new
        if [ -f "$file_arch" ]; then
          xz -c "$file_arch" > "${file_arch_new}.xz"
          echo "Created ${file_arch_new}.xz"
        fi ; sleep 1 ;;
      0) return ;;
    esac
  done
}

decomp_menu() {
  while true; do
    clear
    echo "--- DECOMPRESSION & EXTRACTION ---"
    echo "1. Extract Tar Archive (.tar.gz, .tar.bz2, .tar.xz)"
    echo "2. Decompress single file (gunzip/bunzip2/unxz)"
    echo "0. Return"
    read -p "Choose: " choose
    case $choose in
      1)
        read -p "Path to archive: " t_file
        if [ -f "$t_file" ]; then
          tar -xvf "$t_file"
          echo "Extraction complete."
        else
          echo "Archive not found."
        fi ; read -p "Press Enter..." ;;
      2)
        read -p "File to decompress: " d_file
        if [ -f "$d_file" ]; then
          case "$d_file" in
            *.gz) gunzip "$d_file" ;;
            *.bz2) bunzip2 "$d_file" ;;
            *.xz) unxz "$d_file" ;;
            *) echo "Unsupported single file format." ;;
          esac
          echo "Decompression finished."
        fi ; read -p "Press Enter..." ;;
      0) return ;;
    esac
  done
}

tools_menu() {
  while true; do
    clear
    echo "--- SYSTEM TOOLS ---"
    echo "1. Check File Type (file)"
    echo "2. Measure Compression Performance (time)"
    echo "0. Return"
    read -p "Choose: " choose
    case $choose in
      1)
        read -p "Enter filename: " f_name
        file "$f_name" ; read -p "Press Enter..." ;;
      2)
        read -p "Choose file/folder to measure: " p_file
        read -p "Choose algorithm (gzip/bzip2/xz): " algo
        echo "Measuring time..."
        case $algo in
          gzip) time gzip -c "$p_file" > /dev/null ;;
          bzip2) time bzip2 -c "$p_file" > /dev/null ;;
          xz) time xz -c "$p_file" > /dev/null ;;
        esac ; read -p "Press Enter..." ;;
      0) return ;;
    esac
  done
}

#====== SYSTEMD SERVICE MANAGER ======#
systemd_manager_menu(){
    if ! command -v systemctl >/dev/null 2>&1; then
        clear
        echo "Error: systemctl is not available or systemd is not running."
        read -p "Press Enter to return..."
        return
    fi

    while true; do
        clear
        echo "═════ SYSTEMD SERVICE MANAGER ═════"
        echo "1. List active system services"
        echo "2. Check service status"
        echo "3. Start a service"
        echo "4. Stop a service"
        echo "5. Restart a service"
        echo "6. Enable a service (on boot)"
        echo "7. Disable a service"
        echo "0. Return to main menu"
        read -p "Choose: " sysd_choice
        case $sysd_choice in
            1) systemctl list-units --type=service --state=running; read -p "Press Enter..." ;;
            2) read -p "Enter service name (e.g., ssh, docker): " svc; systemctl status "$svc"; read -p "Press Enter..." ;;
            3) read -p "Enter service name to START: " svc; sudo systemctl start "$svc" && echo "Service started successfully."; read -p "Press Enter..." ;;
            4) read -p "Enter service name to STOP: " svc; sudo systemctl stop "$svc" && echo "Service stopped successfully."; read -p "Press Enter..." ;;
            5) read -p "Enter service name to RESTART: " svc; sudo systemctl restart "$svc" && echo "Service restarted successfully."; read -p "Press Enter..." ;;
            6) read -p "Enter service name to ENABLE: " svc; sudo systemctl enable "$svc"; read -p "Press Enter..." ;;
            7) read -p "Enter service name to DISABLE: " svc; sudo systemctl disable "$svc"; read -p "Press Enter..." ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

#====== FILE LINK MANAGER ======#
file_link_manager_menu(){
    while true; do
        clear
        echo "═════ FILE LINK MANAGER ═════"
        echo "1. Create Symlink (Symbolic/Soft Link)"
        echo "2. Create Hard Link"
        echo "3. Inspect a file's link properties"
        echo "4. Remove a link safely"
        echo "0. Return to main menu"
        read -p "Choose: " link_choice
        case $link_choice in
            1)
                read -p "Target Path (Original file/directory): " target
                read -p "Link Path (Name of the symlink to build): " link_name
                if [ -e "$target" ] || [ -d "$target" ]; then
                    ln -s "$target" "$link_name" && echo "Symlink created: $link_name -> $target"
                else
                    echo "Target does not exist."
                fi
                read -p "Press Enter..."
                ;;
            2)
                read -p "Target Path (Original file only): " target
                read -p "Link Path (Name of the hard link to build): " link_name
                if [ -f "$target" ]; then
                    ln "$target" "$link_name" && echo "Hard link created: $link_name <=> $target"
                else
                    echo "Target must be an existing file (directories cannot have hard links)."
                fi
                read -p "Press Enter..."
                ;;
            3)
                read -p "Enter file or link path to inspect: " path
                if [ -L "$path" ]; then
                    echo "Type: Symbolic Link"
                    echo "Points to: $(readlink -f "$path")"
                elif [ -f "$path" ]; then
                    echo "Type: Regular File / Hard Link"
                    echo "Inodes count / Links count: $(stat -c '%h' "$path")"
                    echo "Inode value: $(stat -c '%i' "$path")"
                else
                    echo "File or link not found."
                fi
                read -p "Press Enter..."
                ;;
            4)
                read -p "Enter the link file path to remove: " to_rm
                if [ -L "$to_rm" ] || [ -f "$to_rm" ]; then
                    rm "$to_rm" && echo "Link entry '$to_rm' safely dropped."
                else
                    echo "Target path is not a file or link component."
                fi
                read -p "Press Enter..."
                ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

#====== LINUX SWAP MANAGER (SWAPMASTER CLI) ======#
swap_manager_menu(){
    while true; do
        clear
        echo "═════ LINUX SWAP MANAGER ═════"
        echo "1. View current swap status"
        echo "2. Create new swap file"
        echo "3. Remove an existing swap file"
        echo "4. Modify swappiness (Performance)"
        echo "0. Return to main menu"
        read -p "Choose: " swap_choice
        case $swap_choice in
            1) show_swap_tool ;;
            2) create_swap_tool ;;
            3) remove_swap_tool ;;
            4) modify_swappiness_tool ;;
            0) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

show_swap_tool() {
    clear
    echo "--- Current Swap Status ---"
    sudo swapon --show
    echo -e "\n--- Memory Usage ---"
    free -h
    echo ""
    read -p "Press Enter to continue..."
}

create_swap_tool() {
    clear
    echo "--- Create New Swap File ---"
    read -p "Enter full path for swap file (e.g., /swapfile): " SWAP_PATH
    if [ -f "$SWAP_PATH" ]; then
        echo "Error: File $SWAP_PATH already exists!"
        read -p "Press Enter..."
        return
    fi

    read -p "Enter size (e.g., 2G, 512M): " SWAP_SIZE
    
    echo "Allocating space..."
    local multi=1
    if [[ "$SWAP_SIZE" == *G || "$SWAP_SIZE" == *g ]]; then multi=1024; fi
    local clean_num=$(echo "$SWAP_SIZE" | sed 's/[^0-9]//g')
    local total_count=$((clean_num * multi))

    sudo fallocate -l "$SWAP_SIZE" "$SWAP_PATH" 2>/dev/null || sudo dd if=/dev/zero of="$SWAP_PATH" bs=1M count="$total_count"
    
    sudo chmod 600 "$SWAP_PATH"
    sudo mkswap "$SWAP_PATH"
    sudo swapon "$SWAP_PATH"
    
    read -p "Do you want to make this permanent in /etc/fstab? (y/n): " PERM
    if [[ "$PERM" == "y" || "$PERM" == "Y" ]]; then
        echo "$SWAP_PATH none swap sw 0 0" | sudo tee -a /etc/fstab >/dev/null
        echo "Added to /etc/fstab."
    fi
    echo "Swap created successfully!"
    read -p "Press Enter to continue..."
}

remove_swap_tool() {
    clear
    echo "--- Remove Existing Swap ---"
    sudo swapon --show
    echo "----------------------------"
    read -p "Enter the full path of the swap to remove: " SWAP_PATH
    
    if grep -q "$SWAP_PATH" /proc/swaps; then
        sudo swapoff "$SWAP_PATH"
        echo "Swap disabled."
        
        sudo sed -i "\|\b$SWAP_PATH\b|d" /etc/fstab
        
        read -p "Do you want to delete the swap file itself? (y/n): " DEL_FILE
        if [[ "$DEL_FILE" == "y" || "$DEL_FILE" == "Y" ]]; then
            sudo rm -i "$SWAP_PATH"
            echo "File deleted."
        fi
    else
        echo "Error: $SWAP_PATH is not an active swap area."
    fi
    read -p "Press Enter to continue..."
}

modify_swappiness_tool() {
    clear
    echo "--- Modify Swappiness ---"
    local CURRENT_VAL=$(cat /proc/sys/vm/swappiness)
    echo "Current swappiness: $CURRENT_VAL (Default is usually 60)"
    read -p "Enter new swappiness value (0-100): " NEW_VAL
    
    if [[ "$NEW_VAL" =~ ^[0-9]+$ ]] && [ "$NEW_VAL" -le 100 ]; then
        sudo sysctl vm.swappiness="$NEW_VAL"
        
        read -p "Make this permanent? (y/n): " PERM
        if [[ "$PERM" == "y" || "$PERM" == "Y" ]]; then
            sudo sed -i '/vm.swappiness/d' /etc/sysctl.conf
            echo "vm.swappiness=$NEW_VAL" | sudo tee -a /etc/sysctl.conf >/dev/null
            echo "Permanent change applied to /etc/sysctl.conf."
        fi
    else
        echo "Invalid value input. Skipping modifications."
    fi
    read -p "Press Enter to continue..."
}

#====== SEARCH TUI SECTION ======#
search_tui_main(){
    (
        set -euo pipefail
        
        start_path="."
        pattern="*"
        use_regex=0
        case_insensitive=1
        type_filter="a" 
        maxdepth=""
        TMP="$(mktemp -t search_tui.XXXXXX)"
        trap 'rm -f "$TMP"' EXIT

        clear_screen(){ printf "\033c"; }

        draw_header(){
            clear_screen
            echo "=== File Search TUI — MichaelCode-tech & shield_tech ==="
            echo "Start path: $start_path    Pattern: $pattern    Type: $type_filter    Regex:$use_regex    Case-insensitive:$case_insensitive    Maxdepth:${maxdepth:-none}"
            echo "------------------------------------------------------"
        }

        prompt(){
            local msg="$1"
            read -rp "$msg" REPLY
            echo "$REPLY"
        }

        build_find_cmd(){
            local path="$1"
            local pat="$2"
            local -a parts=(find -- "$path")
            if [[ -n "$maxdepth" ]]; then parts+=( -maxdepth "$maxdepth"); fi
            case "$type_filter" in
                f) parts+=( -type f ) ;;
                d) parts+=( -type d ) ;;
            esac
            if (( use_regex )); then
                parts+=( -regextype posix-extended )
                if (( case_insensitive )); then parts+=( -iregex ); else parts+=( -regex ); fi
                parts+=( ".*/$pat" )
            else
                if (( case_insensitive )); then parts+=( -iname ); else parts+=( -name ); fi
                parts+=( "$pat" )
            fi
            printf '%q ' "${parts[@]}"
        }

        show_results(){
            local lines count sel idx
            mapfile -t lines < "$TMP"
            count=${#lines[@]}
            while :; do
                draw_header
                echo "Results ($count): (Type index number or option selection)"
                for i in "${!lines[@]}"; do
                    printf "%3d) %s\n" $((i+1)) "${lines[i]}"
                done
                echo "------------------------------------------------------"
                echo "Options: [o]pen [c]opy [p]rint [d]elete [s]elect new search [q]uit to Admin Tool"
                read -rp "Select number or option: " sel
                case "$sel" in
                    q) break 2 ;;
                    s) return 0 ;;
                    o)
                        read -rp "Enter result number to open: " idx
                        idx=$((idx-1))
                        if [[ -n "${lines[idx]:-}" ]]; then
                            if command -v xdg-open >/dev/null 2>&1; then xdg-open "${lines[idx]}" >/dev/null 2>&1 &
                            elif command -v open >/dev/null 2>&1; then open "${lines[idx]}" >/dev/null 2>&1 &
                            else echo "No desktop opener found."; fi
                        fi
                        read -rp "Press ENTER..."
                        ;;
                    c)
                        read -rp "Enter result number to copy path: " idx
                        idx=$((idx-1))
                        if [[ -n "${lines[idx]:-}" ]]; then
                            if command -v wl-copy >/dev/null 2>&1; then printf '%s' "${lines[idx]}" | wl-copy
                            elif command -v xclip >/dev/null 2>&1; then printf '%s' "${lines[idx]}" | xclip -selection clipboard
                            elif command -v pbcopy >/dev/null 2>&1; then printf '%s' "${lines[idx]}" | pbcopy
                            else echo "No clipboard tool found."; fi
                        fi
                        read -rp "Press ENTER..."
                        ;;
                    p)
                        read -rp "Enter result number to print: " idx
                        idx=$((idx-1))
                        if [[ -n "${lines[idx]:-}" ]]; then printf '%s\n' "${lines[idx]}"; fi
                        read -rp "Press ENTER..."
                        ;;
                    d)
                        read -rp "Enter result number to delete: " idx
                        idx=$((idx-1))
                        if [[ -n "${lines[idx]:-}" ]]; then
                            read -rp "Confirm delete ${lines[idx]}? (y/N): " conf
                            if [[ "$conf" =~ ^[Yy]$ ]]; then rm -rf -- "${lines[idx]}" && echo "Deleted."; else echo "Cancelled."; fi
                        fi
                        read -rp "Press ENTER..."
                        ;;
                    ''|*[!0-9]*)
                        echo "Unknown option."
                        read -rp "Press ENTER..."
                        ;;
                    *)
                        idx=$((sel-1))
                        if [[ -n "${lines[idx]:-}" ]]; then
                            printf '\n%s\n\n' "${lines[idx]}"
                            read -rp "Press ENTER..."
                        else
                            echo "Index out of range."
                            read -rp "Press ENTER..."
                        fi
                        ;;
                esac
            done
        }

        run_search(){
            local cmd
            cmd="$(build_find_cmd "$start_path" "$pattern")"
            eval "$cmd" > "$TMP" 2>/dev/null || true
            if [[ ! -s "$TMP" ]]; then
                echo "No results."
                read -rp "Press ENTER to continue..."
                return 1
            fi
            show_results
            return 0
        }

        while :; do
            draw_header
            echo "Menu:"
            echo " 1) Set start path (current: $start_path)"
            echo " 2) Set name pattern (wildcard or regex)"
            echo " 3) Toggle regex mode (currently: $use_regex)"
            echo " 4) Toggle case-insensitive (currently: $case_insensitive)"
            echo " 5) Set type filter (a=all,f=file,d=dir) (current: $type_filter)"
            echo " 6) Set max depth (empty = unlimited)"
            echo " 7) Run search"
            echo " 8) Return to main Admin Tool menu"
            echo "------------------------------------------------------"
            read -rp "Choice: " choice
            case "$choice" in
                1) v=$(prompt "Start path: (default .) "); start_path="${v:-.}" ;;
                2) v=$(prompt "Pattern (wildcards like *.txt or regex): "); pattern="${v:-*}" ;;
                3) use_regex=$((1-use_regex)) ;;
                4) case_insensitive=$((1-case_insensitive)) ;;
                5)
                    v=$(prompt "Type (a/f/d): ")
                    case "$v" in a|f|d) type_filter="$v" ;; *) echo "Invalid, keeping." ; sleep 1 ;; esac
                    ;;
                6) v=$(prompt "Max depth (number or empty): "); maxdepth="$v" ;;
                7) run_search ;;
                8) break ;;
                *) echo "Invalid choice."; sleep 1 ;;
            esac
        done
    )
}

# --- Start Code Execution ---
main_menu
