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

##Parallel download, este ya revisa si el archivo existe y solo baja los
nuevos, además los pone todos en una carpeta llamada "tmp3"

	seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P tmp3/

