seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P ./tmp3/

wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O mexico.csv

parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv 

cat mexico.csv | parallel csvsql --db sqlite:///gdelt.db --table mexico --insert -t 



