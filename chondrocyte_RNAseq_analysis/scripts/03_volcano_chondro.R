load("data/chondro_DESeq2.RData")

m <- result$log2FoldChange
p <- result$pvalue
logp <- -log10(p + 1e-10)

col_vec <- ifelse(p < 0.05 & m >= 1, "#DD5857",
                  ifelse(p < 0.05 & m <= -1, "#A0C388", "black"))

pdf("figures/chondro_volcano.pdf")
plot(m, logp, pch=20, col=col_vec,
     xlab="Log2 Fold Change", ylab="-log10 p-value")
dev.off()