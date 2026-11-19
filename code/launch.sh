
#!/usr/bin/env bash
set -euo pipefail

# Situarnos en la carpeta principal del proyecto
BASE="$(cd "$(dirname "$0")/.." && pwd)"

# Crear carpeta para los resultados
mkdir -p "$BASE/results/data"

# Fenotipo elegido
HPO="HP:0002612"

echo "Descargando genes del fenotipo $HPO"

# Descargar las asociaciones desde HPO
curl -fL --retry 3 \
  "https://ontology.jax.org/api/network/annotation/${HPO}/download/gene" \
  -o "$BASE/results/data/hpo_query.txt"

echo "Descarga finalizada"

# Mostrar las primeras lineas del archivo
head -n 5 "$BASE/results/data/hpo_query.txt"

# Mostrar numero de lineas
wc -l "$BASE/results/data/hpo_query.txt"
