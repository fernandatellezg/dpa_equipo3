#!/bin/bash

echo "Equipo 3"
echo "Descargando archivos desde diciembre de 2016"
seq $((($(date --date=$(date -u -d "-2 days" +"%Y%m%d") +%s) - $(date --date=$(date -u -d "20161201" +"%Y%m%d") +%s) )/(60*60*24))) | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P ./tmp3/

wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O mexico.csv

echo "Tamanio de los archivos descargados"
du -h ./tmp3/

echo "Número de archivos"
ls ./tmp3/ *.zip | wc -l 

parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv 

cat mexico.csv | parallel csvsql --db sqlite:///gdelt.db --table mexico --insert -t 
