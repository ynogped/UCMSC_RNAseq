library(DESeq2)

load("data/preprocessed.RData")

coldata$preterm <- factor(coldata$preterm, levels = c("Term", "Preterm"))

aga_samples <- coldata$sga == "AGA"

COUNT_aga <- COUNT_filt[, aga_samples]
coldata_aga <- coldata[aga_samples, ]

dds <- DESeqDataSetFromMatrix(
  countData = COUNT_aga,
  colData = coldata_aga,
  design = ~ preterm
)

dds <- DESeq(dds)
res <- results(dds, contrast = c("preterm", "Preterm", "Term"))

res_df <- na.omit(as.data.frame(res))

save(res_df, file = "data/res_AGA.RData")