#!/bin/bash

echo "Equipo 3"
echo "Descargando archivos desde diciembre de 2016"
seq $((($(date --date=$(date -u -d "-2 days" +"%Y%m%d") +%s) - $(date --date=$(date -u -d "20161201" +"%Y%m%d") +%s) )/(60*60*24))) | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel -j0 wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P ./tmp3/
#nombres de columnas de archivos
wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O tmp3/mexico.csv

echo "Tamanio de los archivos descargados"
du -h ./tmp3/

echo "Número de archivos"
ls ./tmp3/ *.zip | wc -l 

#parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' >> tmp3/mexico.csv 

#cat mexico.csv | parallel -j0 csvsql --db sqlite:///tmp3/gdelt.db --table mexico --insert -t 

#echo "Creando una tabla en base de datos, sin descomprimir archivos, en paralelo"
#parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico --insert 

echo "creando dos tablas en base de datos, sin descomprimir archivos en paralelo"
echo " date 	event_count 	goldstein_scale" > goldstein_tmp_2.csv

parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'|tee -a mexico.csv | awk -F "\t" '{counter[$2] +=1 ; sum_goldstein[$2]+=$31}END{for(i in counter) print i "\t" counter[i] "\t" sum_goldstein[i]}'| tee -a goldstein_tmp.csv | parallel awk -F "\t" '{counter_2[$1] += $2 ; sum_goldstein_2[$1] +=$3}END{for(i in counter_2) print i "\t" counter_2[i] "\t" sum_goldstein_2[i]/counter_2[i]}' >> goldstein_tmp_2.csv

cat mexico.csv | parallel csvsql --db sqlite:///gdelt.db --table mexico --insert -t

cat goldstein_tmp_2.csv| csvsql --db sqlite:///gdelt.db --table mexico_ts --insert -t