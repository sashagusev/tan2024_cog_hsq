# Analysis of polygenic scores in 1000 Genomes data

`stratification_sim_heritable.R` : R code for simulating and evaluating polygenic scores with population stratification. This code generates the following figure:

![stratification](stratification_sim_heritable.png)

`prscs.sh` : Code to run [PRScs](https://github.com/getian107/PRScs) on a single GWAS study and chromosome.

`merge.sh` : Code to merge polygenic scores across chromosomes into a single genome-wide score.

`score.sh` : Code to run [plink2](https://www.cog-genomics.org/plink/2.0/score) to estimate the score for 1000 Genomes samples.

`1KG.*.csv` : Estimated scores for each 1000 Genomes sample for ADHD and Cognitive Performance.

`plot.R` : Code to produce all visualizations including `Allelic_CogPerf.png`.
