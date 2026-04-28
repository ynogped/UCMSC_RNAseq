library(DESeq2)

load("data/preprocessed.RData")

coldata$preterm <- factor(coldata$preterm, levels = c("Term", "Preterm"))
coldata$sga     <- factor(coldata$sga,     levels = c("AGA", "SGA"))

dds <- DESeqDataSetFromMatrix(
  countData = COUNT_filt,
  colData   = coldata,
  design    = ~ preterm + sga + preterm:sga
)

dds <- DESeq(dds)

res_int <- results(dds, name = "pretermPreterm.sgaSGA")
res_int_df <- as.data.frame(res_int)

save(res_int_df, file = "data/res_interaction.RData")