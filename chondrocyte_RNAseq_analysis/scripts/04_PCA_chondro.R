library(ggplot2)
library(dplyr)

load("data/chondro_preprocessed.RData")

gene_max <- apply(COUNT,1,max)
top_genes <- names(sort(gene_max,decreasing=TRUE))[1:3000]

data <- log10(COUNT[top_genes,]+1)
data <- t(data)

pca <- prcomp(data)
var <- summary(pca)$importance[2, 1:3] * 100

df <- data.frame(pca$x)
df$group <- group$condition
centroids<- df %>%
  group_by(group) %>%
  summarise(PC1 = mean(PC1),PC2 = mean(PC2),)
hull_df <- df %>%  group_by(group) %>% slice(chull(PC1, PC2))

p <- ggplot(df, aes(PC1, PC2, color=group)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_manual(values = c("TS" = "#A0C388","PS" = "#E83C38")) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey50") +
  geom_point(data = centroids,
             aes(x = PC1, y = PC2),
             size = 5, shape = 4, stroke = 2) +
  theme_classic() +
  geom_polygon(data = hull_df,aes(fill = group),alpha = 0.2,color = NA)+
  scale_fill_manual(values = c("PS" = "#DD5B57","TS" = "#5BAE6E")) +
  xlab(paste0("PC1 (", round(var[1],1), "%)")) +
  ylab(paste0("PC2 (", round(var[2],1), "%)"))

ggsave("figures/chondro_PCA.pdf", p)
