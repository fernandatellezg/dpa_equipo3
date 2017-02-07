#Data Product Architecture

##Integrantes
Ma. Fernanda Téllez Girón Enríquez  
Jorge Carlos Urteaga Reyesvera  
Ángel Farid Fajardo Oroz  
José Carlos Castro Montes  

## Comando que baja archivos en paralelo 

   seq $((($(date --date=$(date -u -d "-2 days" +"%Y%m%d") +%s) - $(date --date=$(date -u -d "20161201" +"%Y%m%d") +%s) )/(60*60*24))) \
   | xargs -I {} date -d "20161201 {} days" +%Y%m%d \
   | parallel -j0 wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P tmp3/

## Bajamos los headers

	wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O mexico.csv

## Filtramos y guardamos en mexico.csv (append)

	parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv 

## Cargamos con parallel a la base de datos todo mexico.csv

	cat mexico.csv | parallel -j0 csvsql --db sqlite:///gdelt.db --table mexico --insert -t 

##Usando tee para crear dos tablas
	parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico --insert  | tee awk '{print $27 "," $31}'  | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico_ts --insert  

