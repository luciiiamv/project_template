
#!/usr/bin/env bash
set -e

# Localizar la carpeta principal del proyecto
BASE="$(cd "$(dirname "$0")/.." && pwd)"

# Crear una carpeta local para las librerías de R
LIB="$BASE/software/deps_R"
mkdir -p "$LIB"

# Instalar las librerías necesarias
R_LIBS_USER="$LIB" Rscript -e 'install.packages(
  c("igraph", "optparse"),
  lib=Sys.getenv("R_LIBS_USER"),
  repos="https://cloud.r-project.org"
)'

echo "Instalacion completada"
