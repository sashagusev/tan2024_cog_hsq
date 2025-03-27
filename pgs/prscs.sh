#!/bin/sh

GWAS=$1
CHR=$2
GWAS_N=$3

PRScs.py \
--ref_dir=ldblk_ukbb_eur \
--bim_prefix=phase3_maf01 \
--sst_file=$GWAS.sumstats \
--n_gwas=${GWAS_N} \
--out_dir=$GWAS.prscs \
--chrom=$CHR

PRScs.py \
--ref_dir=ldblk_ukbb_eur \
--bim_prefix=phase3_maf01 \
--sst_file=$GWAS.sumstats \
--n_gwas=${GWAS_N} \
--out_dir=$GWAS.prscs.phi_e2. \
--phi=1e-2 \
--chrom=$CHR

PRScs.py \
--ref_dir=ldblk_ukbb_eur \
--bim_prefix=phase3_maf01 \
--sst_file=$GWAS.sumstats \
--n_gwas=${GWAS_N} \
--out_dir=$GWAS.prscs.phi_e4. \
--phi=1e-4 \
--chrom=$CHR
