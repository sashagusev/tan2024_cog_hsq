#!/bin/sh

GWAS=$1
CHR=$2
GWAS_N=`cat $GWAS.sumstats | tail -n+2 | awk '{ print $NF }' | awk -f ~/tools/avg.awk | awk '{ print int($1) }'`

PRScs.py \
--ref_dir=ldblk_ukbb_eur \
--bim_prefix=phase3_maf01 \
--sst_file=$GWAS.sumstats \
--n_gwas=${GWAS_N} \
--out_dir=$GWAS.prscs \
--chrom=$CHR
