# LCV Analysis

This is an analysis of Cognitive Performance (CP), Educational Attainment (EA), and brain volume (ICV) using the Latent Causal Variable model.
The LCV model can be downloaded from [this](https://github.com/lukejoconnor/LCV/tree/master) repository and also reproduced here.

Processed summary statistics (restricted to HapMap3 variants), LD Scores, and analysis script are available in this repository. Note these summary stats do not follow the LDSC format and are slightly reprocessed in the script.

All analyses are conducted in `BrainLCV.R`. The results are summarized in this table:

| Trait 1 | Trait 2 | GCP | log10(p) | rho |
| --- | --- | --- | --- | --- |
| Volume (Nawaz) | IQ (Lee) | 0.43 (0.07) | -18.2 | 0.21 (0.03) |
| Volume (Nawaz) | EA (Okbay) | 0.38 (0.09) | -6.0 | 0.25 (0.03) |
| IQ (Lee) | EA (Okbay) | -0.09 (0.07) | -0.6 | 0.71 (0.02) |
| FGWAS IQ (Tan) | FGWAS EA (Tan) | -0.54 (0.20) | -7.6 | 0.65( 0.13) |

And the raw output is below:

```
> # Volume <-> IQ
> LCV = process_and_run_LCV ( trait1 = "Nawaz_ICV.HM3.sumstats.gz" , trait2 = "Lee_CP.HM3.sumstats.gz" , n1 = 79174 , n2 = 257841 , ldscoresFile = "all.l2.round.ldscore.gz" )
> sprintf("Volume -> IQ : Estimated posterior gcp=%.2f(%.2f), log10(p)=%.1f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, log(LCV$pval.gcpzero.2tailed)/log(10), LCV$rho.est, LCV$rho.err)
[1] "Volume -> IQ : Estimated posterior gcp=0.43(0.07), log10(p)=-18.2; estimated rho=0.21(0.03)"
> # Volume <-> EA
> LCV = process_and_run_LCV ( trait1 = "Nawaz_ICV.HM3.sumstats.gz" , trait2 = "Okbay_EA.HM3.sumstats.gz" , n1 = 79174 , n2 = 3037499 - 2272216 , ldscoresFile = "all.l2.round.ldscore.gz" )
> sprintf("Volume -> EA : Estimated posterior gcp=%.2f(%.2f), log10(p)=%.1f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, log(LCV$pval.gcpzero.2tailed)/log(10), LCV$rho.est, LCV$rho.err)
[1] "Volume -> EA : Estimated posterior gcp=0.38(0.09), log10(p)=-6.0; estimated rho=0.25(0.03)"
> # IQ <-> EA
> LCV = process_and_run_LCV ( trait1 = "Lee_CP.HM3.sumstats.gz" , trait2 = "Okbay_EA.HM3.sumstats.gz" , n1 = 257841 , n2 = 3037499 - 2272216 , ldscoresFile = "all.l2.round.ldscore.gz" )
> sprintf("IQ -> EA : Estimated posterior gcp=%.2f(%.2f), log10(p)=%.1f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, log(LCV$pval.gcpzero.2tailed)/log(10), LCV$rho.est, LCV$rho.err)
[1] "IQ -> EA : Estimated posterior gcp=-0.09(0.07), log10(p)=-0.6; estimated rho=0.71(0.02)"
```
