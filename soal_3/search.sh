#!/bin/bash

path="/home/zaa/Desktop/sisop/modul-1/Sisop-1-2024-MH-IT16/soal_3/genshin_character"

for folder in "$path"/*; do
  for file in "$folder"/*.jpg; do
    fix="${file%.*}"
    name="${file##*/}"
    steghide extract -sf "$file" -xf "$fix.txt" -p "" -q
    string=$(cat "$fix.txt")
    time=$(date '+%d/%m/%y %H:%M:%S')

    
    decrypted_text=$(echo "$string" | base64 -d)
    

    


    if echo "$decrypted_text" | grep -q "^https:"; then
        echo -e "\n$time: Found the secret file at $fix\nThe URL is $decrypted_text"
        echo "$time [FOUND] $fix" >> image.log

        # Ganti perintah wget dengan tindakan yang sesuai
        # Misalnya, tampilkan pesan atau lakukan tindakan lain
         wget --content-disposition "$decrypted_text"

        echo "$decrypted_text" >> "/home/zaa/Desktop/sisop/modul-1/Sisop-1-2024-MH-IT16/soal_3/$name.txt"
        rm -rf "$fix.txt"
        exit 0
    else
        echo "$time Not this one.."
        echo "$time [NOT FOUND] $fix" >> image.log
        rm -rf "$fix.txt"
    fi

    sleep 1
  done
done
