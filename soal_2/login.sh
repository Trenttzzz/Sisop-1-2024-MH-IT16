#!/bin/bash

# memeriksa ketersediaan email
function check_email_exists() {
    local email=$1
    grep -q "^$email:" users.txt
    return $?
}

# mendekripsi password dari register.sh
function decrypt_password() {
    local encrypted_password=$1
    echo "$encrypted_password" | base64 -d
}

# memeriksa kredensial login
function login() {
    local email=$1
    local password=$2

    #periksa email ada/tidak
    if ! check_email_exists "$email"; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN GAGAL] Pengguna dengan email $email tidak ada." >> auth.log
        echo "Pengguna dengan email $email tidak ada."
        return 1
    fi

    # hash password
    local password_hash=$(grep "^$email:" users.txt | cut -d ':' -f 5)

    # desenkripsi password
    local password_hash=$(echo "$user_data" | cut -d ':' -f 5)
    local decrypted_password=$(decrypt_password "$password_hash")
    if [[ "$password" != "$decrypted_password" ]]; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN FAILED] Incorrect password for user with email $email." >> auth.log
        echo "Incorrect password. Login failed."
        return 1
    fi

    if [[ "$user_type" == "admin" ]]; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN SUCCESS] Admin with email $email logged in successfully." >> auth.log
        echo "Login successful as admin. Welcome!"
        # call fungsi admin
        admin_menu
    else
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN SUCCESS] User with email $email logged in successfully." >> auth.log
        echo "Login successful as user. Welcome!"
    fi
}

# fungsi utk admin
function admin_menu() {
    PS3="Select an option: "
    options=("Add User" "Edit User" "Delete User" "Logout")
    select opt in "${options[@]}"
    do
        case $opt in
            "Add User")
                bash register.sh
                break
                ;;
            "Edit User")
                read -p "Enter the email of the user you want to edit: " email
                # fungsi ediit user
                bash edit_user.sh "$email"
                break
                ;;
            "Delete User")
                read -p "Enter the email of the user you want to delete: " email
                # fungsi delete user
                bash delete_user.sh "$email"
                break
                ;;
            "Logout")
                echo "Logging out..."
                break
                ;;
            *) echo "Invalid option. Please select again.";;
        esac
    done
}

    echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN BERHASIL] Pengguna dengan email $email berhasil login." >> auth.log
    echo "Login berhasil. Selamat datang!"


# untuk mereset password
function forgot_password() {
    local email=$1

    # periksa email ada/tidak
    if ! check_email_exists "$email"; then
        echo "Pengguna dengan email $email tidak ada."
        return 1
    fi

    # dapatkan pertanyaan keamanan dari email yang dimasukkan
    local security_question=$(grep "^$email:" users.txt | cut -d ':' -f 3)

    echo "Pertanyaan Keamanan: $security_question"
    read -p "Jawaban: " security_answer

    # dapatkan jawaban yg benar dari users.txt
    local correct_security_answer=$(grep "^$email:" users.txt | cut -d ':' -f 4)

    # periksa jawaban dari pertanyaan keamanan
    if [[ "$security_answer" != "$correct_security_answer" ]]; then
        echo "Jawaban keamanan salah. Reset password gagal."
        return 1
    fi

    # password baru dari users.txt
    local new_password=$(grep "^$email:" users.txt | cut -d ':' -f 5)

    echo "Password Anda telah direset menjadi: $new_password"
}

# fungsi utama/main

echo "Welcome to Login System"
echo "1. Login"
echo "2. Lupa Password"

read -p "" choice

case $choice in
    1)
        read -p "Email: " email
        read -sp "Password: " password
        echo
        login "$email" "$password"
        ;;
    2)
        read -p "Email: " email
        forgot_password "$email"
        ;;
    *)
        echo "Pilihan tidak valid."
        ;;
esac
