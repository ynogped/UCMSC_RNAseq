library(progeny)
library(dplyr)
library(tibble)
library(ggplot2)

vsd <- vst(dds, blind = FALSE)
expr <- assay(vsd)   

prog_mat <- progeny(expr, scale = TRUE, organism = "Human", top = 500, perm = 1,z_scores = FALSE)
group <- colData(dds)$condition

PS_mean <- colMeans(prog_mat[group == "PS", , drop = FALSE])
TS_mean <- colMeans(prog_mat[group == "TS", , drop = FALSE])

prog_df <- data.frame(pathway = colnames(prog_mat), PS_mean = PS_mean, TS_mean = TS_mean) %>%
  mutate(diff = PS_mean - TS_mean,Direction = ifelse(diff > 0, "PS high", "TS high"))
focus_pathways <- c("TGFb", "WNT", "NFkB", "TNFa", "Hypoxia")
prog_focus <- prog_df %>% arrange(diff)

pal_dir <- c("PS high" = "#DD5B57", "TS high" = "#A0C388")
fig_prog <- ggplot(prog_focus,
                   aes(x = reorder(pathway, diff), y = diff, fill = Direction)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = pal_dir, name = "Direction") +
  labs(title = "Predicted upstream pathway activity (PS vs TS, PROGENy)", x = "", y = "Pathway activity (PS - TS)") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey60") + theme_bw(base_size = 12)

fig_prog