# Cómo correr los scripts (versión corta)

## Para qué sirve

Cada `run_*.sh` corre su notebook (Exp9110, Exp9111, Exp9112, Exp9116_GrupoA
o Exp9117_GrupoA) varias veces seguidas, una por semilla, sin que tengas que
abrir el notebook y tocar nada a mano.

## Dónde tiene que ir

El `.sh` va en una carpeta **un nivel por debajo** de donde está su notebook:

```
src/
├── 621_WorkFlow_01_junior_grupoB_Exp9110.ipynb
├── 621_WorkFlow_01_junior_grupoB_Exp9111.ipynb
├── 621_WorkFlow_01_junior_grupoB_Exp9112.ipynb
├── 621_WorkFlow_01_junior_grupoB_Exp9116_GrupoA.ipynb
├── 621_WorkFlow_01_junior_grupoB_Exp9117_GrupoA.ipynb
└── Corridas_FE/              ← los .sh van ACÁ
    ├── run_9110_15semillas.sh
    ├── run_9111_15semillas.sh
    ├── run_9112_15semillas.sh
    ├── run_9116_GrupoA_10semillas.sh
    └── run_9117_GrupoA_10semillas.sh
```

(La carpeta `Corridas_FE` se puede llamar como sea, con que quede justo un
nivel abajo de los notebooks alcanza.)

## Cómo se corre

Parate en esa carpeta y corré el que te toque, por ejemplo:

```bash
cd Corridas_FE
chmod +x run_9110_15semillas.sh
nohup bash run_9110_15semillas.sh > salida.log 2>&1 &
```

Eso es todo. Se va a quedar corriendo solo en segundo plano (podés cerrar la
terminal). Para ver si sigue vivo o cómo va:

```bash
tail -f "$HOME/log/z621_9110/secuencial.log"
```

Ahí vas a ver una línea por semilla que dice `INICIO`, `OK` o `FALLO`.

Cuando termina todo, va a decir `TERMINARON` al final de ese mismo log.

## Dónde se alojan los archivos

Automáticamente se crea una carpeta del experimento que se está corriendo, dentro del bucket en la carpeta exp/b1, con el nombre 'WF_<nro_experimento>'. Este número de experimento debe ser previamente seteado en el script correspondiente original (por ejemplo 621_WorkFlow_01_junior_grupoB_Exp9110.ipynb) en el lugar correspondiente para dicho fin. En la carpeta mencionada se creará una carpeta por cada semilla ejecuta y dentro de ella se almacenarán los archivos generados por el script original (modelo, feature importance, grid search, ganancias, etc.)

Además en la carpeta interna de la VM llamada log, automáticamente se crea una carpeta a donde se guardará la bitácora de ejecución del experimento, es decir habrá un archivo llamado secuencial.log con el detalle de la secuencia de ejecución de cada semilla del experimento y un archivo resumen.txt con el resumen de las semillas corridas hasta el momento, la ganancia máxima y la cantidad de envíos óptima. 
