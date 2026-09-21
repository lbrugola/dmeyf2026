# Solución Final

## Experimento WF9100

En este experimento se optó por las siguientes modificaciones respecto al baseline:

- Data Drifting: estandarizar
- FE intra-mes: se incorporan las variables sugeridas en el esquema 2 por el grupo B de dicho experimento.
- FE Histórico: se incorporan las variables sugeridas por el grupo B de dicho experimento.
- Meses de Pandemia: se excluyen los meses 202003 hasta 202012
- Undersampling: 0.1

## Experimento WF9104

En este experimento se optó por las siguientes modificaciones respecto al baseline:

- Data Drifting: dolar_oficial
- FE intra-mes: se incorporan las variables sugeridas en el esquema 2 por el grupo B de dicho experimento.
- FE Histórico: se incorporan las variables sugeridas por el grupo B de dicho experimento.
- Meses de Pandemia: se excluyen los meses 202003 hasta 202012
- Undersampling: 0.01

## Cómo se corre la solución final: Ensemble de 10 semillas del experimento WF9100 y WF9104

Se ejecuta el script run_9100_15semillas.sh que lo que hace es ejecutar 10 veces con 10 semillas distintas el script 729_final_junior_Luciano_Brugola_Exp9100_multi_semilla.ipynb, generando una carpeta llamada WF9100_multi_semilla y guardando allí un archivo prediccion_semilla_<nro_semilla> para cada semilla.

Se ejecuta el script run_9104_15semillas.sh que lo que hace es ejecutar 10 veces con 10 semillas distintas el script 729_final_junior_Luciano_Brugola_Exp9104_multi_semilla.ipynb, generando una carpeta llamada WF9104_multi_semilla y guardando allí un archivo prediccion_semilla_<nro_semilla> para cada semilla.

Finalmente se ejecuta el notebook crear_ensemble.ipynb que genera y sube la solución final con 1850 cortes.