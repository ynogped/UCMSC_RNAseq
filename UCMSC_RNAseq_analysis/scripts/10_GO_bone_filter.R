library(dplyr)
library(stringr)
library(ggplot2)

load("data/gsea_GO.RData")

keywords <- c(
  "bone","cartilage","chondro","oste","skelet",
  "extracellular matrix","collagen","proteoglycan",
  "bmp","tgf")

pattern <- str_c(keywords, collapse="|")

go_core <- go_res %>%
  filter(qvalue < 0.25) %>%
  mutate(desc = tolower(Description)) %>%
  filter(str_detect(desc, pattern)) %>%
  mutate(Direction = ifelse(NES > 0, "PS", "TS"))

save(go_core, file = "data/gsea_GO_bone.RData")

# plot
pal <- c("PS"="#DD5B57","TS"="#A0C388")
go_top20 <- go_core %>%
  arrange(desc(abs(NES))) %>%  
  slice(1:20)
go_top20$Description <- factor(
  go_top20$Description,
  levels = rev(go_top20$Description)
)

go_top20 <- go_top20 %>%
  mutate(Direction = ifelse(NES > 0, "PS", "TS"))

go_top20 <- go_top20 %>%
  mutate(
    Pathway_label = str_wrap(Description, width = 40) 
  )

p <- ggplot(go_top20,
            aes(NES, reorder(Pathway_label, NES), fill = Direction)) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = pal) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey60") +
  coord_cartesian(xlim = c(-2, 2)) +
  theme_bw() +
  labs(
    x = "Normalized Enrichment Score (NES)",
    y = NULL,
    fill = "Direction"
  ) +
  theme(
    axis.text.x = element_text(size = 12),
    axis.title.x = element_text(size = 16),
    axis.text.y = element_markdown(size = 10)
  )

p
ggsave("figures/GSEA_GO_bone.pdf", p)
