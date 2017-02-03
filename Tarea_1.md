# Tarea 1 grupal

Adaptado de este trabajo -> [http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html]

El URL de descarga de eventos de la página [http://gdeltproject.org/] es
http://data.gdeltpoject.org/events/index.htm

Cada uno de los archivos viene en formato =YYYYMMDD.export.CSV.zip=

### Descarguen los archivos desde el mes de Diciembre de 2016 (usando =parallel= obviamente)

``` shell 
seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P tmp3/

```
Primero creamos una secuencia de números.  
Pasamos esta secuencia como argumento y, utilizando expresiones regulares, creamos una secuencia de fechas.  
Después paralelizamos la descarga de los archivos especificados en la secuencia.  
Si los archivos ya existen en la carpeta no los descargamos, en caso contrario se descargan comprimidos a la carpeta tmp3.   


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

```
El comando zcat nos permite ver los contenidos del archivo sin necesidad de descomprimirlo.  
Filtramos los renglones que tengas MEX y los guardamos todos en un archivo mexico.csv.  

### Al comando anterior agrega =tee= y guarda en otra *tabla* (llamada =mexico_ts=) el número de eventos por día y la escala de goldstein



