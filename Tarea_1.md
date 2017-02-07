# Tarea 1 grupal

Adaptado de este trabajo -> [http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html]

El URL de descarga de eventos de la página [http://gdeltproject.org/] es
http://data.gdeltpoject.org/events/index.htm

Cada uno de los archivos viene en formato =YYYYMMDD.export.CSV.zip=

###Para generar una secuencia de números
``` shell 
seq $((($(date --date=$(date -u -d "-2 days" +"%Y%m%d") +%s) - $(date --date=$(date -u -d "20161201" +"%Y%m%d") +%s) )/(60*60*24))) 
```
Esta secuencia de numeros depende de una fecha fija (1 diciembre 2016) y la fecha actual

### Descarguen los archivos desde el mes de Diciembre de 2016 (usando =parallel= obviamente)

``` shell 
seq $((($(date --date=$(date -u -d "-2 days" +"%Y%m%d") +%s) - $(date --date=$(date -u -d "20161201" +"%Y%m%d") +%s) )/(60*60*24))) \
| xargs -I {} date -d "20161201 {} days" +%Y%m%d \
| parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P tmp3/

wget -nc http://gdeltproject.org/data/lookups/CSV.header.dailyupdates.txt -O mexico.csv


```
Primero creamos una secuencia de números.  
Pasamos esta secuencia como argumento y, creamos una secuencia de fechas con base a estos números generados.  
Después paralelizamos la descarga de los archivos especificados en la secuencia.  
Si los archivos ya existen en la carpeta no los descargamos, en caso contrario se descargan comprimidos a la carpeta tmp3.  
Descargamos además el archivo con los headers y le llamamos names_gdelt.csv ya que a este se agregaran nuestros datos filtrados. 


### Reporten el número de archivos y el tamaño.

Peso los archivos comprimidos 

``` shell
> du -h tmp3/.
```
El comando du nos muestra el peso de los archivos.  
La bandera -h los hace más entendibles (sino todo es en kilobytes).  

Número de archivos  

 ```shell 
> ls tmp3/*.zip | wc -l
```
Cuenta los archivos con terminación .zip en la carpeta tmp3.  

### Usando =parallel= y sin descomprimir los archivos guarda los registros de México en una tabla =mexico= en una base de datos =sqlite= llamada =gdelt.db=


``` shell 

parallel zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}'>> mexico.csv

cat mexico.csv | parallel csvsql --db sqlite:///gdelt.db --table mexico --insert -t 

```
El comando zcat nos permite ver los contenidos del archivo sin necesidad de descomprimirlo.  
Filtramos los renglones que tengas MEX y los guardamos todos en el archivo mexico.csv "appendeando".  
Luego usamos igual parallel para cargar el archivo mexico.csv a una base de datos gdelt.db

### Al comando anterior agrega =tee= y guarda en otra *tabla* (llamada =mexico_ts=) el número de eventos por día y la escala de goldstein

Otra opción sería:
``` shell 
parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico --insert 

```

Y con el comando tee, para guardarl el número de ventos por día (columna 27) y escala de goldstein (columna 31)
``` shell 
parallel -j0 zcat ::: $(ls ./tmp3/*.export.CSV.zip) | awk '( $8=="MEX" || $18=="MEX") {print}' | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico --insert  | tee awk '{print $27 "," $31}'  | csvsql --db sqlite:///tmp3/gdelt.db --tables mexico_ts --insert  
```


