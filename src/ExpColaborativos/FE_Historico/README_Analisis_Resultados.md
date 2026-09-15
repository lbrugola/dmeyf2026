# Cómo correr el análisis de resultados (analisis_wilcox_graficos.Rmd)

## Para qué sirve

Se crean distintos gráficos, tablas y tests de Wilcoxon para analizar los resultados de los experimentos.

## Cómo se corre

Directamente se conecta al bucket, a la carpeta exp/b1 y extrae de las carpetas WF_<nro_experimento>/semilla_<nro_semilla> los distintos archivos necesarios para dicho fin. Además será necesario incorporar el archivo secuencial.log, que se crea al ejecutar cada archivo .sh de automatización de experimentos, dentro de la carpeta WF_<nro_experimento>. Este script informa el horario de inicio y fin de cada una de las semillas y con esa información se calculan los tiempos de corrida.

Luego se ejecuta como cualquier notebook.