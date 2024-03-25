# Write up Modul-1 Kelompok IT-16

## Soal 1

### Langkah-Langkah:

1. jadi awal nya diberi sebuah file **sandbox.csv**, untuk tugas pertama cipung dan abe adalah menampilakn nama pembeli dengan total sales paling tinggi, 
pertama saya mendeclare sebuah fungsi bernama **highest_sales_customer** untuk mencari nilai sales tertinggi.

2. didalam **highest_sales_customer** saya membuat local variable dengan nama **data** untuk membaca file *sandbox.csv*, berikut adalah code snippetnya:

    `local data=$(tail -n +2 /home/zaa/Downloads/Sandbox.csv | cut -d',' -f6,17)` 

    `local` pada command diatas adalah untuk mendeklarasi suatu variable local, kebetulan disini saya beri nama `data`, kemudian untuk `tail -n +2` adalah untuk hanya mengambil baris kedua dan seterusnya karena baris pertama hanya berisi nama data tersebut. `/home/zaa/Downloads/Sandbox.csv` adalah path ke file **Sandbox.csv** di host, dan terakhir saya menggunakan `cut -d',' -f6,17` untuk memotong semua kolom kecuali kolom 6 dan 17 yang berisi *Costumer Names* dan *Sales*. jdi sekarang pada variabel `data` berisi hanya kolom 6 dan 17 dari file **Sandbox.csv** yang diberikan.

3. kemudian saya membuat fungsi untuk mencari Costumer Name dengan Sales paling tinggi, berikut adalah code snippetnya: 

    ```Shell Script
    local result=$(echo "$data" | awk -F',' '{
    sales[$1]+=$2
    } 
    END {
        for (customer in sales) {
            if (sales[customer] > max || max == "") {
                max = sales[customer]
                name = customer
            }
        }
        print "Pelanggan dengan total penjualan tertinggi adalah " name " dengan penjualan sebesar " max
    }')
        echo "$result"
    }
    ```
    jadi intinya saya membuat variabel local `result`, kemudian didalamnya memasukkan variabel `data` dengan `echo`, kemudian dengan menggunakan `awk -F` untuk mencari nilai dalam kolom. `sales[$1]+=$2`  dapat diinterpretasikan sebagai proses mengakumulasi total diskon untuk setiap segment yang ditemukan dalam data yang diberikan. kemudian menggunakan syntax **END** untuk memberitahu awk bahwa scriptnya didalamnya dijalankan di akhir. kemudian menggunakan **for loop** untuk mencari nilai max nya, dan **print** hasilnya. diakhiri dengan `echo "$result"` untuk menjalankan dan menampilkan hasilnya.

4. kemudian cipung dan abe ingin menampilkan segment dengan profit paling kecil. diawali dengan saya membuat fungsi bernama **lowest_profit_segment**, didalamnya berisi variabel:

    ` local data=$(tail -n +2 /home/zaa/Downloads/Sandbox.csv | cut -d',' -f7,20)` 

    sama seperti di langkah nomor 2 fungsinya untuk mengambil baris kedua dan seterusnya dan mengambil hanya pada kolom 7 dan 20 yaitu **segment** dan **profit**.

5. kemudian membuat variable local `result` untuk mencari segment dengan diskon paling kecil yang ada didalam **Sandbox.csv** berikut adalah command yang saya gunakan: 
    ```Shell Script
    local data=$(tail -n +2 /home/zaa/Downloads/Sandbox.csv | cut -d',' -f7,20)

    local result=$(echo "$data" | awk -F',' '{
        profit[$1]+=$2
    }
    END {
        PROCINFO["sorted_in"]="@val_num_asc"  
        for (segment in profit) {
            print segment, profit[segment]
            exit   
        }
    }')

    echo "$result"
    ```
    syntax awalnya sama dengan command yang ada pada langkah 6, ini hanya saya ganti pada bagian **for loop** nya untuk mencari segment dengan profit **terkecil** dan hanya 1 saja itulah mengapa saya menggunakan syntax ``exit` di akhir **for loop**.

6. lanjut untuk bagian 3, cipung dan abe meminta untuk menampilkan top 3 kategori dengan total profit paling banyak, awalnya saya mendeclare variable bernama `top_3_totalprofit_categories` yang berisi:
    ```Shell Script
    local data=$(tail -n +2 /home/zaa/Downloads/Sandbox.csv | cut -d',' -f14,20)

    local result=$(echo "$data" | awk -F',' '{
        profit[$1]+=$2
    }
    END {
        PROCINFO["sorted_in"]="@val_num_desc"  
        for (category in profit) {
            print category, profit[category]
        }
    }' | head -n3)

    echo "$result"
    ```
    sama seperti variabel yang saya buat sebelumnya awalnya membuat local variable `data` untuk memasukkan data yang dibutuhkan saja, dalam kontek soal ini saya hanya mengambil 2 kolom yaitu kolom ke 14 (category) dan kolom ke 20 (profit).

    kemudian sama dengan variabel sebelumnya saya menggunakan awk untuk mencari top 3 kategori paling banyak, baris `profit[$1]+=$2` berarti profit dari kategori yang ditemukan di kolom pertama dari baris akan **ditambahkan** dengan nilai di kolom kedua. lalu mengurutkan hasil total nya dengan `PROCINFO["sorted_in"]="@val_num_desc"`, kemudian menggunakan **for loop** untuk menampilkan hasil dari kit mengurutkan hasil profit per kategorinya. kemudian dilanjut dengan pipe lalu `head -n3` fungsinya untuk menampilkan maksimal 3 kategori saja.

7. kemudian cipung dan abe meminta untuk mencari purchace date dan amount atas nama adriens bila ada. awalnya saya declare fungsi `check_order_adriaens` lalu didalamnya berisi:
    ```Shell Script
    local result=$(awk -F',' '{
        if ($6 == "adriaens") {
            print $2, $18
            found=1
        }
    }
    END {
        if (found != 1) {
            print "tidak ada adriaens dalam file csv"
        }
    }' /home/zaa/Downloads/Sandbox.csv)

    echo "$result"
    ```

    cara kerja command diatas adalah menggunakan awk untuk mencari nama adriens dengan menggunakan `if` function jika `$6` atau kolom ke-6 sama dengan "adriens" maka `print $2, $18`, tampilakn kolom ke-2 (purchase date) dan kolom ke-18 (quantity). 

    kemudian menggunakan syntax END untuk memastikan command berikutnya di run saat terakhir, lalu dilanjutkan dengan `if` function untuk cek apakah output dari fungsi cek namanya *true* atau *false*, jika true maka `print $2, $18` jika false `print "tidak ada adriaens dalam file csv"`.

8. lalu saya menambahan fungsi `main` untuk memanggil setiap fungsi yang sudah saya buat, sesuai dengan nomornya.
    ```Shell Script
    main(){

    echo 'soal:'
    echo '1. bagian (A)'
    echo '2. bagian (B)'
    echo '3. bagian (C)'
    echo '4. bagian (D)'

    read -p 'pilih [1-4]: ' pilihan

    case $pilihan in
    1)
        highest_sales_customer
        ;;
    2)
        lowest_discount_segment
        ;;
    3)
        top_3_totalprofit_categories
        ;;
    4)
        check_order_adriaens
        ;;
    *)
        echo "Pilihan tidak valid. Silakan masukkan pilihan antara 1 hingga 4."
        ;;
    esac

    }
    ```
    
    selesai.

## Soal 2

### Langkah-Langkah
1. Saya akan membuat program yang akan menyimpan data yang sudah diregister-kan oleh user yang kemudian bisa menjadi data pada saat login. Sehingga saya membuat file **login.sh** dan **register.sh** yang dimana **register.sh** akan dijalankan saat user akan         
   membuat/mendaftarkan email dan **login.sh** ketika akun sudah terdaftar

2. Ketika program **register.sh** dijalankan maka user maupun admin akan melakukan register. *register* itu sendiri menggunakan email, username, pertanyaan keamanan serta jawabannya dan password, berikut adalah code snippetnya:

   ### **register.sh**
   #### Fungsi untuk mendaftarkan pengguna
   ``` Shell Script
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

    # masukkan data ke users.txt
    echo "$email:$username:$security_question:$security_answer:$encrypted_password:$user_type" >> users.txt

    ```
   fungsi ini memeriksa apakah email yang diberikan sudah terdaftar dalam sistem dengan memanggil fungsi `check_email_exists`. Kemudian data pengguna yang berhasil di register akan disimpan pada file `users.txt` dan di akhir fungsi akan mencatat register dalam file log    `auth.log`.

    #### Skrip utama / main
    ``` Shell Script
    echo "Welcome to Registration System"

    read -p "Enter you email: " email
    read -p "Enter your username: " username
    read -p "Enter a security question: " security_question
    read -p "Enter the answer to your security question: " security_answer
    read -sp "Enter a password (minimum 8 characters, at least 1 uppercase letter,1 lowercase letter, 1 digit, 1 symbol, and not same as username, birthdate, or name): " password
    echo

     register_user "$email" "$username" "$security_question" "$security_answer" "$password"
    ```
   fungsi main diatas untuk menampilkan seperti di soal. Kemudian setiap data yang dimasukkan oleh user akan disimpan pada variabel sesuai dengan yang ditentukan. Dan fungsi `register_user` akan melakukan proses register seperti fungsi diatasnya.

3. Kemudian di soal meminta agar **login.sh** dapat mengidentifikasi admin atau user yang sedang register, berikut contoh snippetnya :
    ``` Shell Script
    if [[ $email == *admin* ]]; then
        user_type="admin"
    else
        user_type="pengguna"
    fi
    ```
   Dengan program diatas maka jika alamat email mengandung kata "admin" maka variabel `user_type` akan diatur sebagai "admin", begitupun sebaliknya.

4. Kemudian program diminta agar dapat mengenkripsi menggunakan base64 maka saya menggunakan fungsi sebagai berikut:
    ``` Shell Script
    function encrypt_password() {
    local password=$1
    echo -n "$password" | base64
    }
    ```
     Kriteria berikutnya password yang dibuat harus (lebih dari 8 karakter, Harus terdapat 1 huruf kapital dan 1 huruf kecil dan paling sedikit terdiri dari 1 angka) maka saya membuat fungsi berikutnya seperti berikut: 
    ``` Shell Script
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
    ```
   Fungsi `validate_password()` adalah sebuah bash function yang bertujuan untuk memvalidasi kekuatan password yang diberikan, dengan memeriksa panjang password, keberadaan setidaknya satu karakter huruf kecil, satu karakter huruf besar, dan satu digit, serta              mengembalikan nilai 0 jika memenuhi semua persyaratan atau nilai 1 jika tidak.

5. Kemudian data register akan dimasukkan ke dalam file `users.txt` didalam file tersebut terdapat semua data login termasuk email, password, dll. Saya menggunakan fungsi sebagai berikut
    ``` Shell Script
     echo "$email:$username:$security_question:$security_answer:$encrypted_password:$user_type" >> users.txt

    echo "[`date +'%d/%m/%Y %H:%M:%S'`] [PENGGABUNGAN BERHASIL] Pengguna $username berhasil terdaftar." >> auth.log
    echo "Pengguna $username berhasil terdaftar."
    ```
    Program tersebut merupakan bagian dari sebuah skrip bash yang bertujuan untuk mendaftarkan pengguna baru ke dalam sistem. Baris pertama menambahkan data pengguna baru ke dalam file `users.txt`, sementara baris kedua mencatat keberhasilan pendaftaran dalam file log     `auth.log `dan mencetak pesan keberhasilan pendaftaran ke dalam output terminal.

   ### **login.sh**
6. Karena program harus bisa melakukan login setelah register, login hanya perlu dilakukan menggunakan password dan email. Saya menmbuat fungsi awal sebagai berikut
    ``` Shell Script
    # Fungsi untuk melakukan login
    function login() {
    local email=$1
    local password=$2

    # Periksa apakah email dan password cocok dengan data yang teregister
    if grep -q "^$email:" users.txt && grep -q "^$email:.*:.*:.*:.*:" users.txt && grep -q "^$email:.*:.*:.*:$password:" users.txt; then
        echo "Login berhasil!"
    else
        echo "Login gagal. Email atau password salah."
    fi
    }
    ```
    Itu merupakan fungsi awal untuk user memasukkan data login kemudian diperiksa apakah data yang dimasukkan cocok dengan data pada `users.txt`

7. Disini saya akan membuat program akan menampilkan opsi ketika **login.sh** dijalankan seperti pada soal maka saya akan membuat fungsi seperti berikut:
    ```shell script
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
    ```
   Maka program tersebut akan menampilkan opsi login atau lupa password, jika user memilih opsi login maka program akan menjalankan fungsi `login` kemudian jika user memilih opsi 2 yang dimana merupakan opsi lupa password maka program akan menjalankan fungsi              `forgot_password`, fungsi forgot password sendiri akan saya jelaskan dibawah berikut:
    ``` Shell Script
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
    ```
    fungsi diatas adalah fungsi yang dimana user dapat mereset password jika lupa, `forgot_password()` digunakan untuk mereset password. Singkatnya program akan memeriksa apakah email yang dimasukkan oleh user terdapat pada `users.txt` jika email ditemukan maka program     akan menampilkan pertanyaan keamanan sesuai dengan email user, semua itu diambil dari `users.txt`. Kemudian jika jawaban dari pertanyaan keamanan yang dijawab oleh user benar maka program akan mengambil password baru dari file `users.txt` dan menampilkan password       baru kepada user sebagai reset password.

8. Kemudian pada soal diminta untuk seorang admin dapa menambah mengedit (username, pertanyaan keamanan dan jawaban, dan password), dan menghapus user untuk memudahkan kerjanya sebagai admin. Maka saya gunakan program sebagai berikut:
    ``` Shell Script
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
    ```
9. Agar program dapat mencatat seluruh log dengan baik maka saya membuat program menyimpan semua seluruh log baik login maupun register ke dalam file auth.log menggunakan fungsi sebagai berikut.
    #### Pada `register.sh`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [PENGGABUNGAN GAGAL] Pengguna dengan email $email sudah terdaftar." >> auth.log`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [PENGGABUNGAN GAGAL] Password tidak memenuhi persyaratan kompleksitas untuk pengguna $username." >> auth.log`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [PENGGABUNGAN BERHASIL] Pengguna $username berhasil terdaftar." >> auth.log`
    #### Pada `login.sh`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [LOGIN GAGAL] Pengguna dengan email $email tidak ada." >> auth.log`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [LOGIN FAILED] Incorrect password for user with email $email." >> auth.log`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [LOGIN SUCCESS] Admin with email $email logged in successfully." >> auth.log`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [LOGIN SUCCESS] User with email $email logged in successfully." >> auth.log`
    * `echo "[date +'%d/%m/%Y %H:%M:%S'] [LOGIN BERHASIL] Pengguna dengan email $email berhasil login." >> auth.log`
    
    Pada intinya semua aktifitas yang terdapat pada login dan register akan tersimpan pada auth.log menggunakan perintah seperti diatas.

## Soal 3

### Langkah-Langkah

(isi langkah-langkah pengerjaan)

## Soal 4

### Langkah-Langkah
1. Pada soal ini, kita akan membantu Stitch untuk membuat sebuah program yang dimana program tersebut dapat membantunya untuk monitoring resource pada PC. Program tersebut cukup untuk monitoring ram dan monitoring size suatu directory. Langkah pertama yang dapat kita lakukan adalah dengan membuat suatu directori yang berisi 2 file, yang akan kita namakan:
    a.minute_log.sh
    b.aggregate_minutes_to_hourly_log.sh


2. Kemudian kita akan memonitoring semua metrics yang ada di directori, dengan target_path yaitu, /home/user.
   Berikut adalah codenya:

#### Skrip untuk Mencatat Metrik Setiap Menit (minute_log.sh):
```
#!/bin/bash

# Define the log file path
log_file="/home/user/log/metrics_$(date +'%Y%m%d%H%M%S').log"

# Execute the commands to retrieve system metrics
mem_metrics=$(free -m | grep Mem | awk '{print $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8}')
swap_metrics=$(free -m | grep Swap | awk '{print $2 "," $3 "," $4}')
path="/home/user/log/"
path_size=$(du -sh "$path" | cut -f1)

# Write the metrics to the log file
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"
```

#### Skrip untuk Membuat Agregasi Per Jam (aggregate_minutes_to_hourly_log.sh):
```
#!/bin/bash

# Determine the current user's home directory
user_home=$(getent passwd "$(whoami)" | cut -d: -f6)

# Define the path to the log file in the user's home directory
log_file="$user_home/log/metrics_agg_$(date +'%Y%m%d%H%M%S').log"

# Execute the commands to retrieve system metrics
mem_metrics=$(free -m | grep Mem | awk '{print $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8}')
swap_metrics=$(free -m | grep Swap | awk '{print $2 "," $3 "," $4}')
path="/home/user/log/"
path_size=$(du -sh "$path" | cut -f1)

# Write the metrics to the log file
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "minimum,$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"
echo "maximum,$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"
echo "average,$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"
```

3. Untuk menjalankan kedua skrip ini secara otomatis, tambahkan entri ke dalam crontab sebagai berikut:
   a. Konfigurasi Cron untuk Mencatat Metrik Setiap Menit:
      #### Tambahkan entri berikut ke dalam crontab (crontab -e):
           * * * * * /path/to/minute_log.sh

   b. Konfigurasi Cron untuk Membuat Agregasi Per Jam:
      #### Tambahkan entri berikut ke dalam crontab (crontab -e):
           0 * * * * /path/to/aggregate_minutes_to_hourly_log.sh

   *Pastikan untuk mengganti /path/to/aggregate_minutes_to_hourly_log.sh dengan path lengkap ke skrip aggregate_minutes_to_hourly_log.sh.
   Kemudian setelah itu, jika kalian mendapati permission denied kalian bisa menggunakan 'chmod +x' atau menggunakan command 'sudo crontab -e'.


5. Langkah terakhir adalah untuk menjalankan kedua file untuk melihat apakah monitoring yang dilakukan sudah sesuai dengan spesifikasi yang diinginkan.
   Gunakan command 'bash' untuk menjalankan kedua file tadi, setelah itu kalian dapat menggunakan command 'find' untuk mencari log monitoring tersebut.
   Log file tersebut memiliki code seperti ini:
       a. minute_log.sh : metrics_20240325195825.log
       b. aggregate_minutes_to_hourly_log.sh : metrics_agg_20240325200024.log

   Kemudian cek kembali apakah isi dari sudah sesuai dengan spesifikasi yang diinginkan.





