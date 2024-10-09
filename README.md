# Re-Analysis of LDSC heritability estimates in Tan et al. 2024 and Howe et al. 2022

This repository contains code to re-analyze the population and direct/sibling GWAS data from [Tan et al. 2024](https://www.medrxiv.org/content/10.1101/2024.10.01.24314703v1) and [Howe et al. 2022](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9110300/) using a modern LDSC model.

## The following files are required

* tan_2024_cognitive_performance.gz: The raw Tan et al. GWAS summary data, available from the [SSGAC data portal](https://thessgac.com/)
* ldsc: LD-score regression, available from github or by running `git clone https://github.com/bulik/ldsc.git`
* The baselineLD_v2.2 model, available from the [Alkes Group Google bucket](https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays) and at [this](https://storage.googleapis.com/broad-alkesgroup-public-requester-pays/LDSCORE/1000G_Phase3_baselineLD_v2.2_ldscores.tgz) direct link.
* The base model weights, available from the [Alkes Group Google bucket](https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays) and at [this](https://storage.googleapis.com/broad-alkesgroup-public-requester-pays/LDSCORE/1000G_Phase3_weights_hm3_no_MHC.tgz) direct link.
* The base (no annotation) model, available from the [Alkes Group Google bucket](https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays) and at [this](https://storage.googleapis.com/broad-alkesgroup-public-requester-pays/LDSCORE/eur_w_ld_chr.tar.bz2) direct link.

## The following scripts will perform the analysis

`run_all.sh` : Generates LDSC-format summary stats from the Tan et al. 2024 input data and runs both versions of the LDSC model
`run_howe.sh` : Same as above but for running the Howe et al. summary stats (which are provided in this repository in LDSC format)
`plot.R` : Generate barplots (using hard-coded numbers)

## The following files are produced

`*.log` files from each LDSC run contain all of the heritability estimates and can be queried as follows:
```
$ grep "Total Observed scale h2" *.log
Howe.Cog.direct.LDSC_h2.baselineLD_model.log:Total Observed scale h2: 0.1146 (0.0674)
Howe.Cog.direct.LDSC_h2.base_model.log:Total Observed scale h2: 0.1311 (0.0434)
Howe.Cog.population.LDSC_h2.baselineLD_model.log:Total Observed scale h2: 0.1565 (0.0399)
Howe.Cog.population.LDSC_h2.base_model.log:Total Observed scale h2: 0.243 (0.0276)
tan_2024_cognitive_performance.direct.LDSC_h2.baselineLD_model.log:Total Observed scale h2: 0.1233 (0.0496)
tan_2024_cognitive_performance.direct.LDSC_h2.base_model.log:Total Observed scale h2: 0.1661 (0.0303)
tan_2024_cognitive_performance.population.LDSC_h2.baselineLD_model.log:Total Observed scale h2: 0.1261 (0.0195)
tan_2024_cognitive_performance.population.LDSC_h2.base_model.log:Total Observed scale h2: 0.1855 (0.0161)
```

## Acknowledgements

Thank you to the authors of [Tan et al. 2024](https://www.medrxiv.org/content/10.1101/2024.10.01.24314703v1) for making all data and code easily available with the pre-print. Thank you to the authors of [Howe et al. 2022](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9110300/) for making all data available.
