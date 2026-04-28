library(msigdbr)
library(clusterProfiler)
library(dplyr)
library(ggplot2)
library(ggtext)

load("data/ranks_interaction.RData")

msig_h <- msigdbr(species = "Homo sapiens", category = "H")

hallmark_t2g <- msig_h %>%
  dplyr::select(gs_name, gene_symbol) %>%
  dplyr::distinct()

set.seed(42)

gsea_int <- GSEA(
  geneList = ranks,
  TERM2GENE = hallmark_t2g,
  minGSSize = 15,
  maxGSSize = 500,
  pvalueCutoff = 1,
  verbose = FALSE
)

gsea_df <- as.data.frame(gsea_int)

gsea_sig <- gsea_df %>%
  filter(p.adjust < 0.25) %>%
  mutate(
    Direction = ifelse(NES > 0, "PS", "TS"),
    Pathway = gsub("HALLMARK_", "", Description)
  )
save(gsea_df, gsea_sig, file = "data/gsea_hallmark.RData")

# plot
library(msigdbr)
library(clusterProfiler)
library(dplyr)
library(ggplot2)

load("data/ranks_interaction.RData")

msig_h <- msigdbr(species = "Homo sapiens", category = "H")

hallmark_t2g <- msig_h %>%
  dplyr::select(gs_name, gene_symbol) %>%
  dplyr::distinct()

set.seed(42)

gsea_int <- GSEA(
  geneList = ranks,
  TERM2GENE = hallmark_t2g,
  minGSSize = 15,
  maxGSSize = 500,
  pvalueCutoff = 1,
  verbose = FALSE
)

gsea_df <- as.data.frame(gsea_int)

gsea_sig <- gsea_df %>%
  filter(p.adjust < 0.25) %>%
  mutate(
    Direction = ifelse(NES > 0, "PS", "TS"),
    Pathway = gsub("HALLMARK_", "", Description)
  )

save(gsea_df, gsea_sig, file = "data/gsea_hallmark.RData")

# plot
pal <- c("PS"="#DD5B57","TS"="#A0C388")
gsea_top20 <- gsea_sig %>%
  arrange(desc(abs(NES))) %>%  
  slice(1:20)
gsea_top20$Description <- factor(
  gsea_top20$Description,
  levels = rev(gsea_top20$Description)
)

gsea_top20 <- gsea_top20 %>%
  mutate(Direction = ifelse(NES > 0, "PS", "TS"))

p <- ggplot(gsea_top20,
            aes(NES, reorder(Pathway_label, NES), fill = Direction)) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = pal) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey60") +
  coord_cartesian(xlim = c(-2, 2)) +
  theme_bw() +
  labs(
    x = "Normalized Enrichment Score (NES)",y = NULL) +
  theme(
    axis.text.x = element_text(size = 14),
    axis.title.x = element_text(size = 12),
    axis.text.y = element_markdown(size = 10)   
  )

p

ggsave("figures/GSEA_Hallmark.pdf", p)
