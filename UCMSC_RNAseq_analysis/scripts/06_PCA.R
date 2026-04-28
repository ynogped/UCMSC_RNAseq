library(ggplot2)
library(dplyr)

load("data/preprocessed.RData")

run_pca <- function(count_matrix, prefix, colors){
  
  gene_max <- apply(count_matrix, 1, max)
  top_genes <- names(sort(gene_max, decreasing = TRUE))[1:3000]
  
  data <- log10(count_matrix[top_genes, ] + 1)
  data <- t(data)
  
  pca <- prcomp(data, scale = FALSE)
  var_exp <- summary(pca)$importance[2, 1:2] * 100
  
  df <- data.frame(pca$x)
  df$group <- sub("_.*", "", rownames(df))
  
  centroids <- df %>%
    group_by(group) %>%
    summarise(PC1 = mean(PC1),PC2 = mean(PC2),)
  
  hull_df <- df %>%
    group_by(group) %>%
    slice(chull(PC1, PC2))
  
  p <- ggplot(df, aes(PC1, PC2, color = group)) +
    geom_point(size = 3) +
    scale_color_manual(values = colors) +
    geom_point(data = centroids,
               aes(x = PC1, y = PC2),
               size = 5, shape = 4, stroke = 2) +
    geom_polygon(data = hull_df,
                 aes(fill = group),
                 alpha = 0.2,
                 color = NA)+
    scale_fill_manual(values = c("PA" = "#568CBD","TA" = "#ECB86B","PS" = "#DD5B57","TS" = "#5BAE6E")) +
    theme_classic() +
    xlab(paste0("PC1 (", round(var_exp[1],1), "%)")) +
    ylab(paste0("PC2 (", round(var_exp[2],1), "%)"))
  
  ggsave(paste0("figures/PCA_", prefix, ".pdf"), p)
}

# AGA
aga_samples <- coldata$sga == "AGA"
run_pca(COUNT_filt[, aga_samples], "AGA", c("PA"="#568CBD","TA"="#ECB86B"))

# SGA
sga_samples <- coldata$sga == "SGA"
run_pca(COUNT_filt[, sga_samples], "SGA", c("PS"="#E83C38","TS"="#A0C388"))
