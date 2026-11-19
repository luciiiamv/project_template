
#!/usr/bin/env bash
set -euo pipefail

BASE="$(cd "$(dirname "$0")/.." && pwd)"
LIB="$BASE/software/deps_R"

mkdir -p "$LIB"

echo "Preparando librerias de R..."

# Comprobar que R esta disponible
if [ ! -x /usr/bin/Rscript ]; then
    echo "ERROR: Es necesario tener R instalado."
    exit 1
fi

# Evitar conflictos con Anaconda
env -u LD_LIBRARY_PATH \
    -u LIBRARY_PATH \
    -u CPATH \
    -u PKG_CONFIG_PATH \
    PATH=/usr/local/bin:/usr/bin:/bin \
    R_LIBS_USER="$LIB" \
    /usr/bin/Rscript -e '
        lib <- Sys.getenv("R_LIBS_USER")
        paquetes <- c("igraph", "optparse")

        instalados <- rownames(
            installed.packages(lib.loc=lib)
        )

        faltan <- setdiff(paquetes, instalados)

        if (length(faltan) > 0) {
            install.packages(
                faltan,
                lib=lib,
                repos="https://cloud.r-project.org"
            )
        }

        for (p in paquetes) {
            library(p, character.only=TRUE, lib.loc=lib)
        }

        cat("LIBRERIAS VERIFICADAS CORRECTAMENTE\n")
    '
