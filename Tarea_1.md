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
> du -h .
```

Número de archivos  

 ```shell 
> ls *.zip | wc -l
```
  
### Usando =parallel= y sin descomprimir los archivos guarda los registros de México en una tabla =mexico= en una base de datos =sqlite= llamada =gdelt.db=

### Al comando anterior agrega =tee= y guarda en otra *tabla* (llamada =mexico_ts=) el número de eventos por día y la escala de goldstein



