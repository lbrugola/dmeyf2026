# Solución Final

La solución final consiste en un ensemble de los siguientes experimentos ejecutados con 10 semillas distintas (las mismas para ambos experimentos).

## Experimento WF9100

En este experimento se optó por las siguientes modificaciones respecto al baseline sugerido por la cátedra:

- Data Drifting: estandarizar.
- FE intra-mes: se incorporan las variables sugeridas en el experimento 2 por el grupo B.
- FE Histórico: se incorporan las variables sugeridas por el grupo B de dicho experimento.
- Meses de Pandemia: se excluyen los meses 202003 hasta 202012 tanto en training para grid search como en training del modelo final.
- Undersampling: 0.1.

## Experimento WF9104

En este experimento se optó por las siguientes modificaciones respecto al baseline sugerido por la cátedra:

- Data Drifting: dolar_oficial.
- FE intra-mes: se incorporan las variables sugeridas en el esquema 2 por el grupo B de dicho experimento.
- FE Histórico: se incorporan las variables sugeridas por el grupo B de dicho experimento.
- Meses de Pandemia: se excluyen los meses 202003 hasta 202012 tanto en training para grid search como en training del modelo final.
- Undersampling: 0.01.

## Cómo se corre la solución final: Ensemble de 10 semillas del experimento WF9100 y WF9104

### Exp9100 con 10 semillas

Se ejecuta el script run_9100_10semillas.sh que lo que hace es ejecutar 10 veces (con una semilla distinta en cada ocasión) el script 729_final_junior_Luciano_Brugola_Exp9100_multi_semilla.ipynb, generando una carpeta llamada WF9100_multi_semilla y guardando allí un archivo prediccion_semilla_<nro_semilla> para cada semilla.

### Exp9104 con 10 semillas

Se ejecuta el script run_9104_10semillas.sh que lo que hace es ejecutar 10 veces (con una semilla distinta en cada ocasión, las mismas que para Exp9100) el script 729_final_junior_Luciano_Brugola_Exp9104_multi_semilla.ipynb, generando una carpeta llamada WF9104_multi_semilla y guardando allí un archivo prediccion_semilla_<nro_semilla> para cada semilla.

### Ensemble con solución final

Finalmente se ejecuta el notebook crear_ensemble.ipynb que genera y sube la solución final con 1850 cortes. Dicho notebook lee las predicciones generadas en la ejecución de 10 semillas de cada experimento, que quedan alojadas en las respectivas carpetas (WF<nro_experimento>_multi_semilla), luego 

- Se calcula la posición de cada cliente en cada predicción de cada semilla-experimento según la probabilidad de baja en forma ascendente.
- Se genera un score continuo calculado como el cociente entre la posición recién calculada y la cantidad total de clientes únicos. Este score es un valor en el (0,1], siendo un valor cercano a 0 para aquellos clientes con baja probabilidad de baja y cercano a 1 para aquellos clientes con alta probabilidad de baja.
- Se agrupa por numero_de_cliente calculando el promedio, sobre las 20 predicciones (10 semillas x 2 experimentos),  del score recién calculado.
- Luego se ordena de mayor a menor según el promedio para marcar a los de mayor promedio con envío, para distintos cortes.

Se adoptó este enfoque, en lugar de calcular el promedio directo de la probabilidad de baja debido a que en ambos experimentos se utiliza un undersampling muy distinto. En el Exp9104 el undersampling es mucho más agresivo que en el Exp9100 (0.01 vs 0.1), por lo tanto sus probabilidades de baja tenderán a ser sistemáticamente mayores debido a que la cantidad de clientes CONTINUA en el entrenamiento se reduce de forma más drástica. Si consideráramos el promedio de las probabilidades, el Exp9104 prevalecerá sobre Exp9100, es decir, no tomaríamos en cuenta la señal del Exp9100 porque sus probabilidades son de menor magnitud. Este método neutraliza la diferencia de escala entre las probabilidades de ambos experimentos.