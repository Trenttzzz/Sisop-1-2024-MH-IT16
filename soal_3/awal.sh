#!/bin/bash

# Unduh file dari link yang diberikan
wget -O genshin_files.zip "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN"

# Unzip file yang telah diunduh
unzip genshin_files.zip

# Unzip file genshin_character.zip
unzip genshin_character.zip

path="/home/zaa/Desktop/sisop/modul-1/Sisop-1-2024-MH-IT16/soal_3/genshin_character"

# buat folder di dalam genshin_character
mkdir -p  "$path/Mondstat" "$path/Sumeru" "$path/Fontaine" "$path/Inazuma" "$path/Liyue"

# iterasi ke semua file .jpg di dalam folder 
for file in "$path"/*.jpg; do
  
  # decrypt hex ke string
  files_init=$(echo "${file%.*}")
  decrypt=$(echo "${files_init##*/}" | xxd -r -p)

  # mengganti nama file awal ke versi decrypt nya
  mv -- "$path/${files_init##*/}".jpg "$decrypt".jpg

  # ambil region dari nama $decrypt lalu tulis ulang namanya di fungsi $new_name
  region=$(awk -F, "/$decrypt/"'{OFS=","; print $2}' list_character.csv)
  new_name=$(awk -F, "/$decrypt/"'{OFS=","; print $2 "-" $1 "-" $3 "-" $4}' list_character.csv)
  
  # merename file decrypt menjadi new_name.jpg dan memindahkan file new_name ke region yang sesuai di file csv 
  mv -- "$decrypt.jpg" "$new_name".jpg
  mv "$new_name".jpg "$path/$region"
done

# clear output tidak penting
clear

# hitung jumlah weapon yang setipe
echo "Weapon Count:"
echo "Claymore: $(grep -c 'Claymore' list_character.csv)"
echo "Polearm: $(grep -c 'Polearm' list_character.csv)"
echo "Catalyst: $(grep -c 'Catalyst' list_character.csv)"
echo "Bow: $(grep -c 'Bow' list_character.csv)"
echo "Sword: $(grep -c 'Sword' list_character.csv)"

# menghapus file yang tidak diperlukan
rm -rf genshin_character.zip list_character.csv genshin_files.zip