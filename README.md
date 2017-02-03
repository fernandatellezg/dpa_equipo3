#Data Product Architecture

##Integrantes
Ma. Fernanda Téllez Girón Enríquez  
Jorge Carlos Urteaga Reyesvera  
Ángel Farid Fajardo Oroz  
José Carlos Castro Montes  

## Comando que baja archivos en paralelo 

	seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P ./tmp3/

## Bajamos los headers

	wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O mexico.csv

## Filtramos y guardamos en mexico.csv (append)

	parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv 

## Cargamos con parallel a la base de datos todo mexico.csv

	cat mexico.csv | parallel csvsql --db sqlite:///gdelt.db --table mexico --insert -t 

