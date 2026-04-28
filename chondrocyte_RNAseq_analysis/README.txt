# UCMSC Chondrocyte RNA-seq Analysis

## Overview
This repository contains R scripts for RNA-seq analysis of chondrocytes differentiated from human umbilical cord mesenchymal stem cells (UCMSCs).
The analysis aims to compare transcriptional profiles between:
* Preterm SGA (PS)
* Term SGA (TS)

and to identify:
* Differentially expressed genes
* Pathway enrichment (GSEA)
* Bone/cartilage-related biological processes
* Upstream signaling activity (PROGENy)

---
## Workflow
The analysis is organized into sequential scripts:
### 1. Preprocessing
* Load count matrix
* Filter low-expression genes
* Define sample groups
---
### 2. Differential Expression Analysis
* DESeq2 analysis (PS vs TS)
* Normalization
* Export results
---
### 3. Visualization
#### Volcano plot
* Highlights differentially expressed genes
#### PCA
* Uses top 3000 variable genes
* Includes centroids and convex hulls
---
### 4. Pathway Analysis
#### Hallmark GSEA
* Gene ranking based on log2 fold change
* PS direction defined as positive
* FDR threshold: q < 0.25
---
#### GO enrichment (Biological Process)
* GSEA-based GO analysis
* Focus on bone/cartilage-related pathways
* Keyword filtering:
"  * bone, cartilage, chondro, ECM, BMP, TGF, etc."
---
### 5. Upstream pathway analysis
* PROGENy pathway activity inference
* Comparison: PS vs TS
* Output: pathway activity difference (PS | TS)

---
## Key analysis details
### Gene ranking
Genes were ranked based on log2 fold change from DESeq2 results:
* PS-upregulated genes ¨ positive values
* TS-upregulated genes ¨ negative values
---
### GSEA parameters
* Method: clusterProfiler::GSEA
* Gene sets: MSigDB Hallmark
* minGSSize = 15
* maxGSSize = 500
* Significance: FDR < 0.25
* Random seed fixed (`set.seed(42)`) for reproducibility
---
### GO analysis
* Method: clusterProfiler::gseGO
* Ontology: Biological Process (BP)
* keyType: SYMBOL
* Bone/cartilage-related terms extracted by keyword filtering
---
### PROGENy
* Method: progeny
* Top genes: 500 per pathway
* Output: pathway activity scores
* Interpretation:

  * Positive values ¨ PS enriched
  * Negative values ¨ TS enriched
---

## Directory structure
project/
„¥„Ÿ„Ÿ scripts/
„    „¥„Ÿ„Ÿ 01_preprocessing_chondro.R
„    „¥„Ÿ„Ÿ 02_DESeq2_chondro.R
„    „¥„Ÿ„Ÿ 03_volcano_chondro.R
„    „¥„Ÿ„Ÿ 04_PCA_chondro.R
„    „¥„Ÿ„Ÿ 05_GSEA_chondro.R
„    „¥„Ÿ„Ÿ 06_GO_bone_chondro.R
„    „¥„Ÿ„Ÿ 07_PROGENy_chondro.R
„¥„Ÿ„Ÿ data/        # input/output (not included)
„¥„Ÿ„Ÿ figures/     # generated plots
„¥„Ÿ„Ÿ README.md

---
## Data availability
Raw RNA-seq data are available at GEO:GSE327822
**Accession: (to be added upon publication)**
Processed data are not included in this repository but are available upon reasonable request.
---
## Requirement
* R (version 4.3.1)
### R packages
* DESeq2
* clusterProfiler
* msigdbr
* org.Hs.eg.db
* progeny
* ggplot2
* dplyr
* stringr
* enrichplot
---
## Reproducibility
* All analyses were performed with a fixed random seed (`set.seed(42)`)
* Scripts should be run in the order listed above
* Results are deterministic given the same input data
---
## Notes
* Gene identifiers are assumed to be gene symbols
* Pathway direction is defined relative to PS vs TS comparison
* Visualization scripts generate publication-ready figures
---
## Contact
mail: ynogped@tmd.ac.jp 
---
## License
This repository is intended for academic research use.