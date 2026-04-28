library(clusterProfiler)
library(msigdbr)
library(org.Hs.eg.db)
library(dplyr)
library(AnnotationDbi)

load("data/chondro_DESeq2.RData")

ranks <- result$log2FoldChange
names(ranks) <- rownames(result)
ranks <- ranks[!is.na(ranks)]

ranks_PS <- -ranks
ranks_PS <- sort(ranks_PS, decreasing = TRUE)
set.seed(42)
# Hallmark GSEA
msig <- msigdbr(species = "Homo sapiens", category = "H")

t2g <- msig %>%
  dplyr::select(gs_name, gene_symbol) %>%
  dplyr::distinct()

gsea <- GSEA(
  geneList     = ranks_PS,
  TERM2GENE    = t2g,
  minGSSize    = 15,
  maxGSSize    = 500,
  pvalueCutoff = 1,
  verbose      = FALSE
)

save(gsea, file = "data/chondro_GSEA.RData")

gsea_df <- as.data.frame(gsea)

gsea_sig <- gsea_df %>%
  filter(qvalue < 0.25) %>%
  arrange(NES) %>%
  mutate(
    Pathway = gsub("HALLMARK_", "", Description),
    Direction = ifelse(NES > 0, "PS high", "TS high")
  )

pal <- c("PS high"="#DD5B57","TS high"="#A0C388")

p1 <- ggplot(gsea_sig, aes(NES, reorder(Pathway, NES), fill=Direction)) +
  geom_col() +
  scale_fill_manual(values=pal) +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw()

ggsave("figures/GSEA_Hallmark_chondro.pdf", p1, width=6, height=5)
