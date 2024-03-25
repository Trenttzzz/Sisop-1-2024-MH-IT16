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

    # dekripisi password dan diperiksa
    local decrypted_password=$(decrypt_password "$password_hash")
    if [[ "$password" != "$decrypted_password" ]]; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN GAGAL] Password salah untuk pengguna dengan email $email." >> auth.log
        echo "Password salah. Login gagal."
        return 1
    fi

    echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN BERHASIL] Pengguna dengan email $email berhasil login." >> auth.log
    echo "Login berhasil. Selamat datang!"
}

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
