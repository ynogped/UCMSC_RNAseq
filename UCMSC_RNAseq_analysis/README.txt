#UCMSC RNA-seq Analysis Pipeline

#Overview
RNA-seq analysis pipeline for human UCMSCs to separate the effects of prematurity and fetal growth restriction (FGR/SGA) using a two-factor design.

#Study Design
Four neonatal groups:
- TA: Term AGA
- PA: Preterm AGA
- TS: Term SGA
- PS: Preterm SGA

#Main Objective
Identify genes affected by timing of FGR using the interaction term:
Preterm × SGA

#Analyses include:
- Differential expression analysis
- Pathway enrichment (GSEA)
- Bone/cartilage-related biological processes

#Pipeline
1. Preprocessing

2. Differential Expression
- AGA: prematurity effect
- SGA: prematurity within FGR
- Interaction (main analysis)
  design = ~ preterm + sga + preterm:sga

3. Visualization
- Volcano plots
- PCA

4. GSEA
- Rank preparation
- Hallmark gene sets
- GO Biological Process
- Bone/cartilage pathway filtering

Directory Structure

project/
├── scripts/
│   ├── 01_preprocessing.R
│   ├── 02_DESeq2_AGA.R
│   ├── 03_DESeq2_SGA.R
│   ├── 04_DESeq2_interaction.R
│   ├── 05_volcano_plots.R
│   ├── 06_PCA.R
│   ├── 07_prepare_ranks.R
│   ├── 08_GSEA_Hallmark.R
│   ├── 09_GSEA_GO.R
│   ├── 10_GO_bone_filter.R
├── data/        # input/output (not included)
├── figures/     # generated plots
├── README.md

Data Availability
Raw RNA-seq data: GEO: GSE327822
Accession: (to be added upon publication)

Processed data are not included but are available upon reasonable request.

Requirements
- R (≥ 4.3.1)

R packages:
- DESeq2
- clusterProfiler
- msigdbr
- org.Hs.eg.db
- ggplot2
- dplyr
- stringr

Reproducibility
- Fixed random seed: set.seed(42)
- Scripts should be run in numerical order
- Results are reproducible given the same input data

Notes
- Gene identifiers: Ensembl IDs
- Pathway direction:
  NES > 0 → PS-high
  NES < 0 → TS-high
- Figures are generated in publication-ready format

Contact
ynogped@tmd.ac.jp

License
This repository is intended for academic research use.