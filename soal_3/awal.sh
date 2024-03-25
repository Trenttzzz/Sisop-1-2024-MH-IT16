#!/bin/bash

# Unduh file dari link yang diberikan
wget -O genshin_files.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"

# Unzip file yang telah diunduh
unzip genshin_files.zip

# Unzip file genshin_character.zip
unzip genshin_character.zip

# Decode setiap nama file yang terenkripsi dengan hex
for file in genshin_character/*.jpg; do
    decoded_name=$(echo $file | sed 's/\.jpg$//' | xxd -r -p)
    mv "$file" "${file%/*}/${decoded_name}.jpg"
done

# Merename setiap file berdasarkan data lengkap karakter dari list_character.csv
IFS=$'\n' # Set internal field separator to newline
for line in $(tail -n +2 list_character.csv); do
    nama=$(echo $line | cut -d ',' -f 1)
    region=$(echo $line | cut -d ',' -f 2)
    elemen=$(echo $line | cut -d ',' -f 3)
    senjata=$(echo $line | cut -d ',' -f 4)
    
    # Buat folder berdasarkan region jika belum ada
    mkdir -p "${region}"

    # Cari file yang sesuai dengan karakter dan pindahkan ke folder yang sesuai
    character_file=$(find genshin_character -type f -name "*${nama}*" | head -n 1)
    if [ -n "$character_file" ]; then
        mv "$character_file" "${region}/${region} - ${nama} - ${elemen} - ${senjata}.jpg"
    fi
done

# Menghapus file yang tidak diperlukan
rm genshin_character.zip list_character.csv genshin.zip

# Menghitung dan menampilkan jumlah pengguna untuk setiap senjata
echo "Jumlah pengguna untuk setiap senjata:"
for senjata in $(find . -mindepth 2 -type f -name "*.jpg" | cut -d '-' -f 4 | sort | uniq); do
    jumlah=$(find . -mindepth 2 -type f -name "*-${senjata}.jpg" | wc -l)
    echo "${senjata} : ${jumlah}"
done