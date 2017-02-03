#Data Product Architecture

##Integrantes
Ma. Fernanda Téllez Girón Enríquez  
Jorge Carlos Urteaga Reyesvera  
Ángel Farid Fajardo Oroz  
José Carlos Castro Montes  

## Parallel Download
	
	seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget http://data.gdeltproject.org/events/{}.export.CSV.zip
## Comando awk 
	
	zcat -f 20170108.export.CSV.zip | awk '$16 == "KOR"'	

##Agrego un || a la línea anterior e imprimo a mexico.csv

	zcat -f 20161201.export.CSV.zip | awk '( $8=="MEX" || $18=="MEX") {print}'> mexico.csv


## Aprovecho el tmp3 de la línea anterior y uso parallel con zcat para que apliqué el awk de forma paralela y guarde un solo .csv
parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv
