library(DESeq2)

load("data/preprocessed.RData")

coldata$preterm <- factor(coldata$preterm, levels = c("Term", "Preterm"))

sga_samples <- coldata$sga == "SGA"

COUNT_sga <- COUNT_filt[, sga_samples]
coldata_sga <- coldata[colnames(COUNT_sga), ]

dds2 <- DESeqDataSetFromMatrix(
  countData = COUNT_sga,
  colData = coldata_sga,
  design = ~ preterm
)

dds2 <- DESeq(dds2)
res2 <- results(dds2, contrast = c("preterm", "Preterm", "Term"))

res2_df <- na.omit(as.data.frame(res2))

save(res2_df, file = "data/res_SGA.RData")