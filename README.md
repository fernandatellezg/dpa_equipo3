#Data Product Architecture

##Integrantes
Ma. Fernanda Téllez Girón Enríquez  
Jorge Carlos Urteaga Reyesvera  
Ángel Farid Fajardo Oroz  
José Carlos Castro Montes  

## Parallel Download
	
	seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget http://data.gdeltproject.org/events/{}.export.CSV.zip
