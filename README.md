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

(isi langkah-langkah pengerjaan)

## Soal 3

### Langkah-Langkah

(isi langkah-langkah pengerjaan)

## Soal 4

### Langkah-Langkah

(isi langkah-langkah pengerjaan)
