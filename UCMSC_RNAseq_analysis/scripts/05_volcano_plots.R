library(ggplot2)

load("data/res_AGA.RData")
load("data/res_SGA.RData")

# AGA
res_df$log10p <- -log10(res_df$pvalue)
res_df$group <- "NS"
res_df$group[res_df$pvalue < 0.05 & res_df$log2FoldChange > 1] <- "Up (Preterm AGA)"
res_df$group[res_df$pvalue < 0.05 & res_df$log2FoldChange < -1] <- "Up (Term AGA)"

p1 <- ggplot(res_df, aes(log2FoldChange, log10p, color = group)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(values = c(
    "Up (Preterm AGA)" = "#568CBD",
    "Up (Term AGA)" = "#ECB86B",
    "NS" = "black"
  )) +
  theme_classic()

ggsave("figures/Volcano_AGA.pdf", p1)

# SGA
res2_df$log10p <- -log10(res2_df$pvalue)
res2_df$group <- "NS"
res2_df$group[res2_df$pvalue < 0.05 & res2_df$log2FoldChange > 1] <- "Up (Preterm SGA)"
res2_df$group[res2_df$pvalue < 0.05 & res2_df$log2FoldChange < -1] <- "Up (Term SGA)"

p2 <- ggplot(res2_df, aes(log2FoldChange, log10p, color = group)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(values = c(
    "Up (Preterm SGA)" = "#E83C38",
    "Up (Term SGA)" = "#A0C388",
    "NS" = "black"
  )) +
  theme_classic()

ggsave("figures/Volcano_SGA.pdf", p2)