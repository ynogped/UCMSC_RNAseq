rm(list=ls())

COUNT <- read.table("data/UCMSC_gene_count.txt", header = TRUE, row.names = 1, sep = "\t")
COUNT <- as.matrix(COUNT)

# filter
keep <- rowSums(COUNT >= 100) >= 1
COUNT_filt <- COUNT[keep, ]

# metadata
coldata <- data.frame(
  sample = colnames(COUNT),
  preterm = c(rep("Term", 12), rep("Preterm", 8)),
  sga = c(rep("SGA", 8), rep("AGA", 4), rep("SGA", 4), rep("AGA", 4)),
  row.names = colnames(COUNT)
)

save(COUNT, COUNT_filt, coldata, file = "data/preprocessed.RData")