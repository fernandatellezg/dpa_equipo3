seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P tmp3/

parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv

wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O tmp3/headers.csv

