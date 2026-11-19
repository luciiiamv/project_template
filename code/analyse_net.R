
# Proyecto Biologia de Sistemas
# Fenotipo: HP:0002612

# Cargar libreria instalada localmente
.libPaths(c("software/deps_R", .libPaths()))
library(igraph)

# Leer interacciones descargadas de STRING
datos <- read.delim("results/data/string_network.tsv")

# Seleccionar las proteinas y su confianza
aristas <- data.frame(
  from = datos$preferredName_A,
  to = datos$preferredName_B,
  score = datos$score
)

# Crear una red no dirigida
red <- graph_from_data_frame(aristas, directed = FALSE)
red <- simplify(red, edge.attr.comb = list(score = "max"))

# Calcular propiedades de la red
cat("Numero de proteinas:", vcount(red), "\n")
cat("Numero de conexiones:", ecount(red), "\n")
cat("Transitividad:", transitivity(red), "\n")
cat("Componentes conectados:", components(red)$no, "\n")

# Calcular conexiones de cada proteina
grados <- data.frame(
  Gen = V(red)$name,
  Conexiones = degree(red)
)

grados <- grados[order(-grados$Conexiones), ]
print(head(grados, 10))

# Guardar tabla de resultados
write.csv(grados, "results/grados_genes.csv",
          row.names = FALSE)

# Dibujar y guardar la red
set.seed(42)
pdf("results/red_fibrosis_hepatica.pdf",
    width = 12, height = 10)

plot(red,
     layout = layout_with_fr(red),
     vertex.color = "skyblue",
     vertex.size = 9,
     vertex.label.cex = 0.65,
     edge.width = 0.7,
     main = "Red de proteinas - HP:0002612")

dev.off()

cat("Analisis completado correctamente\n")
