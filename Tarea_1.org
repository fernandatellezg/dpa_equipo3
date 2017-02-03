* Tarea 1 grupal

Adaptado de este [[http://aadrake.com/command-line-tools-can-be-235x-faster-tha$

#+BEGIN_SRC org :tangle tareas/tarea_1_grupal.org

El URL de descarga de eventos de [[http://gdeltproject.org/][=GDELT=]] es
=http://data.gdeltpoject.org/events/=

Cada uno de los archivos viene en formato =YYYYMMDD.export.CSV.zip=

- Descarguen los archivos desde el mes de Diciembre de 2016 (usando =parallel=
  obviamente)

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

