rm(list=ls())

COUNT <- read.table("data/chondrocyte_gene_count.txt", sep="\t", header=TRUE, row.names=1)
COUNT <- as.matrix(COUNT)

keep <- rowSums(COUNT >= 100) >= 1
COUNT_filt <- COUNT[keep, ]

group <- data.frame(
  sample = colnames(COUNT_filt),
  condition = factor(c("PS","PS","PS","TS","TS","TS")),
  row.names = colnames(COUNT_filt)
)

save(COUNT, COUNT_filt, group, file="data/chondro_preprocessed.RData")
