
#!/usr/bin/env bash
set -euo pipefail

# Directorio principal del proyecto
BASE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BASE"

# Crear carpetas para resultados
mkdir -p results/data

# Fenotipo seleccionado
HPO="HP:0002612"

echo "1. Descargando genes de HPO..."

curl -fsSL --retry 3 \
  "https://ontology.jax.org/api/network/annotation/${HPO}/download/gene" \
  -o results/data/hpo_query.txt

# Extraer los simbolos de los genes
tail -n +2 results/data/hpo_query.txt |
  cut -f2 |
  tr -d '\r' |
  sed '/^[[:space:]]*$/d' |
  sort -u > results/data/hpo_genes.txt

echo "Genes obtenidos:"
wc -l results/data/hpo_genes.txt

echo "2. Descargando interacciones STRING..."

curl -fsSL --retry 3 \
  --data-urlencode "identifiers@results/data/hpo_genes.txt" \
  --data-urlencode "species=9606" \
  --data-urlencode "required_score=900" \
  --data-urlencode "add_nodes=0" \
  --data-urlencode "caller_identity=UMA_BiologiaSistemas_HP0002612" \
  "https://version-12-5.string-db.org/api/tsv/network" \
  -o results/data/string_network.tsv

echo "3. Analizando la red..."

Rscript code/analyse_net.R

echo "ANALISIS COMPLETADO"
