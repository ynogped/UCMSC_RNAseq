library(DESeq2)

load("data/chondro_preprocessed.RData")

dds <- DESeqDataSetFromMatrix(
  countData = COUNT_filt,
  colData = group,
  design = ~ condition
)

dds <- DESeq(dds)
result <- results(dds, contrast = c("condition","TS","PS"))

normalized_counts <- counts(dds, normalized=TRUE)

save(result, dds, normalized_counts, file="data/chondro_DESeq2.RData")