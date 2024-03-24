#masih belum fixxxx

#!/bin/bash

# memeriksa email terdaftar
function check_email_exists() {
    local email=$1
    grep -q "^$email:" users.txt
    return $?
}

# mengenkripsi password base64
function encrypt_password() {
    local password=$1
    echo -n "$password" | base64
}

# Fungsi untuk memvalidasi kompleksitas password
function validate_password() {
    local password=$1
    if [[ ${#password} -lt 8 ]]; then
        return 1
    fi
    if ! [[ "$password" =~ [[:lower:]] ]]; then
        return 1
    fi
    if ! [[ "$password" =~ [[:upper:]] ]]; then
        return 1
    fi
    if ! [[ "$password" =~ [0-9] ]]; then
        return 1
    fi
    return 0
}

# Fungsi untuk mendaftarkan pengguna
function register_user() {
    local email=$1
    local username=$2
    local security_question=$3
    local security_answer=$4
    local password=$5

    # Periksa apakah email sudah ada
    if check_email_exists "$email"; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [PENGGABUNGAN GAGAL] Pengguna dengan email $email sudah terdaftar." >> auth.log
        echo "Pengguna dengan email $email sudah terdaftar. Pendaftaran gagal."
        return 1
    fi

    # Validasi password
    if ! validate_password "$password"; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [PENGGABUNGAN GAGAL] Password tidak memenuhi persyaratan kompleksitas untuk pengguna $username." >> auth.log
        echo "Password tidak memenuhi persyaratan kompleksitas. Pendaftaran gagal."
        return 1
    fi

    # Enkripsi password
    local encrypted_password=$(encrypt_password "$password")

    # Tentukan jenis pengguna
    if [[ $email == *admin* ]]; then
        user_type="admin"
    else
        user_type="pengguna"
    fi

    # Tambahkan detail pengguna ke users.txt
    echo "$email:$username:$security_question:$security_answer:$encrypted_password:$user_type" >> users.txt

    echo "[`date +'%d/%m/%Y %H:%M:%S'`] [PENGGABUNGAN BERHASIL] Pengguna $username berhasil terdaftar." >> auth.log
    echo "Pengguna $username berhasil terdaftar."
}

# Skrip utama dimulai di sini

echo "Welcome to Registration System"


read -p "Enter you email: " email
read -p "Enter your username: " username
read -p "Enter a security question: " security_question
read -p "Enter the answer to your security question: " security_answer
read -sp "Enter a password (minimum 8 characters, at least 1 uppercase letter,1 lowercase letter, 1 digit, 1 symbol, and not same as username, birthdate, or name): " password
echo

register_user "$email" "$username" "$security_question" "$security_answer" "$password"
