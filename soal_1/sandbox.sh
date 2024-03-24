#!/bin/bash

# Fungsi untuk menampilkan nama pembeli dengan total sales paling tinggi
highest_sales_customer() {
    # read csv
    local data=$(tail -n +2 /home/zaa/Downloads/Sandbox.csv | cut -d',' -f6,17)

    
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



# Fungsi untuk menampilkan customer segment dengan diskon paling kecil
 lowest_profit_segment() {
    
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


}

# Fungsi untuk menampilkan 10 kategori dengan total profit paling tinggi
top_3_totalprofit_categories() {
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
}


# Fungsi untuk mencari purchase date dan amount dari nama pembeli tertentu
check_order_adriaens() {
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
}

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
        lowest_profit_segment
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

main
