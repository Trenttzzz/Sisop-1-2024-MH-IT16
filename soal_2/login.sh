#belom fixx

#!/bin/bash

# Fungsi untuk memeriksa apakah email ada
function check_email_exists() {
    local email=$1
    grep -q "^$email:" users.txt
    return $?
}

# Fungsi untuk mendekripsi password dari base64
function decrypt_password() {
    local encrypted_password=$1
    echo "$encrypted_password" | base64 -d
}

# Fungsi untuk memeriksa kredensial login
function login() {
    local email=$1
    local password=$2

    # Periksa apakah email ada
    if ! check_email_exists "$email"; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN GAGAL] Pengguna dengan email $email tidak ada." >> auth.log
        echo "Pengguna dengan email $email tidak ada."
        return 1
    fi

    # Dapatkan hash password
    local password_hash=$(grep "^$email:" users.txt | cut -d ':' -f 5)

    # Dekripsi dan periksa password
    local decrypted_password=$(decrypt_password "$password_hash")
    if [[ "$password" != "$decrypted_password" ]]; then
        echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN GAGAL] Password salah untuk pengguna dengan email $email." >> auth.log
        echo "Password salah. Login gagal."
        return 1
    fi

    echo "[`date +'%d/%m/%Y %H:%M:%S'`] [LOGIN BERHASIL] Pengguna dengan email $email berhasil login." >> auth.log
    echo "Login berhasil. Selamat datang!"
}

# Fungsi untuk mereset password
function forgot_password() {
    local email=$1

    # Periksa apakah email ada
    if ! check_email_exists "$email"; then
        echo "Pengguna dengan email $email tidak ada."
        return 1
    fi

    # Dapatkan pertanyaan keamanan untuk email yang diberikan
    local security_question=$(grep "^$email:" users.txt | cut -d ':' -f 3)

    # Tampilkan pertanyaan keamanan dan minta jawaban dari pengguna
    echo "Pertanyaan Keamanan: $security_question"
    read -p "Jawaban: " security_answer

    # Dapatkan jawaban keamanan yang benar dari berkas users.txt
    local correct_security_answer=$(grep "^$email:" users.txt | cut -d ':' -f 4)

    # Periksa apakah jawaban keamanan yang diberikan benar
    if [[ "$security_answer" != "$correct_security_answer" ]]; then
        echo "Jawaban keamanan salah. Reset password gagal."
        return 1
    fi

    # Dapatkan password yang baru dari berkas users.txt
    local new_password=$(grep "^$email:" users.txt | cut -d ':' -f 5)

    echo "Password Anda telah direset menjadi: $new_password"
}

# Skrip utama dimulai di sini

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
