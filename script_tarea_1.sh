#!/bin/bash

echo "Equipo 3"
echo "Descargando archivos desde diciembre de 2016"
seq $((($(date --date=$(date -u -d "-2 days" +"%Y%m%d") +%s) - $(date --date=$(date -u -d "20161201" +"%Y%m%d") +%s) )/(60*60*24))) | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel -j0 wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P ./tmp3/
#nombres de columnas de archivos
wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O tmp3/names_gdelt.csv

echo "Tamanio de los archivos descargados"
du -h ./tmp3/

echo "Número de archivos"
ls ./tmp3/ *.zip | wc -l 

parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' >> tmp3/mexico.csv 

#cargando a base de datos
cat mexico.csv | parallel -j0 csvsql --db sqlite:///tmp3/gdelt.db --table mexico --insert -t 

echo "Creando una tabla en base de datos, sin descomprimir archivos, en paralelo"
parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico --insert 

echo "creando dos tablas en base de datos, sin descomprimir archivos en paralelo"
parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico --insert  | tee awk '{print $27 "," $31}'  | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico_ts --insert  
