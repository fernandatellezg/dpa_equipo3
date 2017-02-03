# Tarea 1 grupal

Adaptado de este [[http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html][trabajo]]

El URL de descarga de eventos de [[http://gdeltproject.org/][=GDELT=]] es
=http://data.gdeltpoject.org/events/=

Cada uno de los archivos viene en formato =YYYYMMDD.export.CSV.zip=

# Descarguen los archivos desde el mes de Diciembre de 2016 (usando =parallel=
  obviamente)

``` shell 
seq 63 | xargs -I {} date -d "20161201 {} days" +%Y%m%d | parallel wget -nc http://data.gdeltproject.org/events/{}.export.CSV.zip -P tmp3/

```
- Reporten el número de archivos y el tamaño.

#+begin_example shell
# Peso los archivos comprimidos
> du -h .

# Número de archivos
> ls *.zip | wc -l
#+end_example

- Usando =parallel= y sin descomprimir los archivos guarda los registros de
  México en una tabla =mexico= en una base de datos =sqlite= llamada =gdelt.db=

- Al comando anterior agrega =tee= y guarda en otra *tabla* (llamada
  =mexico_ts=) el número de eventos por día y la escala de goldstein

#+END_SRC

