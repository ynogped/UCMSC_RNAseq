library(dplyr)
library(org.Hs.eg.db)

load("data/res_interaction.RData")

ensg_ids <- rownames(res_int_df)

symbol <- mapIds(
  org.Hs.eg.db,
  keys      = ensg_ids,
  keytype   = "ENSEMBL",
  column    = "SYMBOL",
  multiVals = "first"
)

res_int_df$symbol <- symbol

res_int_sym <- res_int_df %>%
  filter(!is.na(symbol) & symbol != "")

res_int_sym2 <- res_int_sym %>%
  group_by(symbol) %>%
  slice_max(order_by = abs(stat), n = 1) %>%
  ungroup()

ranks <- res_int_sym2$stat
names(ranks) <- res_int_sym2$symbol
ranks <- sort(ranks, decreasing = TRUE)

save(ranks, file = "data/ranks_interaction.RData")