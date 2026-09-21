#!/bin/bash

# Asegurar que se ejecuta en el directorio del script
cd "$(dirname "$0")" || exit 1

ORIGINAL="../729_final_junior_Luciano_Brugola_Exp9100_multi_semilla.ipynb"
TRABAJO="729_final_junior_Luciano_Brugola_Exp9100_semilla_actual.ipynb"

# Numero de experimento REAL segun PARAM$experimento adentro del notebook
# (define en que carpeta WF<N> caen los resultados). Coincide con el numero del experimento.
WF_EXPERIMENTO=9100_multi

LOGDIR="$HOME/log/729_9100_multi"
RESULTDIR="$HOME/buckets/b1/exp/WF${WF_EXPERIMENTO}"

if [ ! -f "$ORIGINAL" ]; then
  echo "ERROR: no encuentro $ORIGINAL (parado en $(pwd)). Este script tiene que estar en una subcarpeta, un nivel por debajo del notebook original." >&2
  exit 1
fi

mkdir -p "$LOGDIR"
mkdir -p "$RESULTDIR"

# semillas para el Experimento (15 semillas)
SEMILLAS=(487649 522497 569321 906839 992689 828833 791261 981947 962867 223063)

RESUMEN="$LOGDIR/resumen_9100_multi.txt"

for semilla in "${SEMILLAS[@]}"; do
  echo "=== $(date '+%F %T') INICIO semilla $semilla ===" | tee -a "$LOGDIR/secuencial.log"

  if [ ! -f "$ORIGINAL" ]; then
    echo "ERROR: no encuentro $ORIGINAL" | tee -a "$LOGDIR/secuencial.log"
    exit 1
  fi

  # copia de trabajo: el archivo original NO se toca en ningun momento
  cp "$ORIGINAL" "$TRABAJO"

  # cambio UNICAMENTE el valor de la semilla en la copia de trabajo
  python3 - "$TRABAJO" "$semilla" <<'PYEOF'
import json, sys
path, semilla = sys.argv[1], sys.argv[2]
nb = json.load(open(path))
cambiado = False
for c in nb["cells"]:
    if c["cell_type"] != "code":
        continue
    for i, line in enumerate(c["source"]):
        if "PARAM$semilla_primigenia <- 247067" in line:
            c["source"][i] = line.replace("247067", semilla)
            cambiado = True
if not cambiado:
    sys.exit("no se encontro la linea de la semilla_primigenia")
json.dump(nb, open(path, "w"), indent=1)
PYEOF

  if [ $? -ne 0 ]; then
    echo "=== $(date '+%F %T') ERROR parcheando la semilla $semilla, se sigue con la proxima ===" | tee -a "$LOGDIR/secuencial.log"
    rm -f "$TRABAJO"
    continue
  fi

  jupyter nbconvert --to notebook --execute --inplace \
    --ExecutePreprocessor.timeout=-1 \
    --ExecutePreprocessor.kernel_name=ir \
    "$TRABAJO" >> "$LOGDIR/semilla_${semilla}.log" 2>&1
  rc=$?

  if [ $rc -eq 0 ]; then
    echo "=== $(date '+%F %T') OK    semilla $semilla ===" | tee -a "$LOGDIR/secuencial.log"

    # archivo los resultados de ESTA semilla antes de que la proxima corrida los pise
    destino="$RESULTDIR/semilla_${semilla}"
    mkdir -p "$destino"
    cp "$RESULTDIR"/PARAM.yml "$RESULTDIR"/modelo.txt \
       "$RESULTDIR"/impo.txt "$RESULTDIR"/prediccion.txt \
       "$RESULTDIR"/tb_grid_search_01.txt \
       "$destino/" 2>/dev/null

    # Procesa la tabla de grid search para extraer el maximo de gan_suavizada
    python3 - "$RESULTDIR/tb_grid_search_01.txt" "$semilla" "$RESUMEN" <<'PYEOF'
import csv, sys
path, semilla, resumen = sys.argv[1], sys.argv[2], sys.argv[3]
mx, mxpos = None, None
try:
    with open(path) as f:
        r = csv.reader(f, delimiter="\t")
        header = next(r)
        idx = header.index("gan_suavizada")
        for i, row in enumerate(r, start=1):
            v = row[idx]
            if v == "":
                continue
            v = float(v)
            if mx is None or v > mx:
                mx, mxpos = v, i
    with open(resumen, "a") as f:
        f.write(f"{semilla}\t{mx}\t{mxpos}\n")
except Exception as e:
    pass
PYEOF

  else
    echo "=== $(date '+%F %T') FALLO semilla $semilla (exit $rc) --- se sigue con la proxima ===" | tee -a "$LOGDIR/secuencial.log"
  fi

  rm -f "$TRABAJO"
done

echo "=== $(date '+%F %T') LAS 15 SEMILLAS TERMINARON. Resumen en $RESUMEN, detalle por semilla en $RESULTDIR/semilla_<N>/ ===" | tee -a "$LOGDIR/secuencial.log"