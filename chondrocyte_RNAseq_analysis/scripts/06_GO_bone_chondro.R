library(clusterProfiler)
library(org.Hs.eg.db)
library(stringr)
library(dplyr)

load("data/chondro_GSEA.RData")
gsea_go <- gseGO(
  geneList     = ranks_PS,
  OrgDb        = org.Hs.eg.db,
  keyType      = "SYMBOL",
  ont          = "BP",
  minGSSize    = 10,
  maxGSSize    = 500,
  pvalueCutoff = 1,
  verbose      = FALSE
)

go_df <- as.data.frame(gsea_go)

keywords <- c("bone","cartilage","chondro","oste","skelet",
              "extracellular matrix","collagen","proteoglycan",
              "bmp","tgf","smad")
pattern <- str_c(keywords, collapse="|")
set.seed(42)
go_bone <- go_df %>%
  dplyr::filter(!is.na(qvalue), qvalue < 0.25) %>%
  dplyr::mutate(
    desc_l = tolower(Description),
    Direction = ifelse(NES > 0, "PS high", "TS high")
  ) %>%
  dplyr::filter(stringr::str_detect(desc_l, pattern)) %>%
  dplyr::arrange(NES)

save(go_bone, file="data/chondro_GO_bone.RData")

pal <- c("PS high"="#DD5B57","TS high"="#A0C388")
p2 <- ggplot(go_bone, aes(NES, reorder(Description, NES), fill=Direction)) +
  geom_col() +
  scale_fill_manual(values=pal) +
  geom_vline(xintercept=0, linetype="dashed") +
  theme_bw()
p2
ggsave("data/GSEA_GO_bone_chondro.pdf", p2, width=6, height=6)

# enrichplot 
pdf("figures/GSEA_enrichment_examples.pdf")
gseaplot2(gsea_go, geneSetID="GO:0030198")  #extracellular matrix organization
gseaplot2(gsea_go, geneSetID="GO:0002062")  #chondrocyte differentiation
dev.off()