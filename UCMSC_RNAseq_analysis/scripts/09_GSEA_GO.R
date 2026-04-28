library(clusterProfiler)
library(org.Hs.eg.db)
library(dplyr)
library(ggplot2)

load("data/ranks_interaction.RData")
set.seed(42)
gsea_go <- gseGO(
  geneList = ranks,
  OrgDb = org.Hs.eg.db,
  keyType = "SYMBOL",
  ont = "BP",
  minGSSize = 10,
  maxGSSize = 500,
  pvalueCutoff = 1,
  verbose = FALSE
)

go_res <- as.data.frame(gsea_go)

go_sig <- go_res %>%
  filter(qvalue < 0.25) %>%
  mutate(Direction = ifelse(NES > 0, "PS", "TS"))

save(go_res, go_sig, file = "data/gsea_GO.RData")

# plot
pal <- c("PS"="#DD5B57","TS"="#A0C388")

p <- ggplot(go_sig, aes(NES, reorder(Description, NES), fill = Direction)) +
  geom_col() +
  scale_fill_manual(values = pal) +
  theme_bw()

ggsave("figures/GSEA_GO.pdf", p)
