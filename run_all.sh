# ---
# Set up:
# ---

# Download the raw GWAS data from the SSGAC data portal: https://thessgac.com/ (https://thessgac.com/papers/16)
# This will contain a 1.5GB file titled "tan_2024_cognitive_performance.gz"
# The name of the GWAS file from the SSGAC data portal
gwas="tan_2024_cognitive_performance"
# The minimum sample size to keep, defined as 80% of the effective sample size for the direct effects
minn="9889"
# For educational attainment, simply use the below parameters:
# gwas="tan_2024_educational_attainment"
# minn=37910

# Download LDSC v1.0.1 from github: `git clone https://github.com/bulik/ldsc.git`
# (Note: the release version 1.0.0 has bugs that will break the munge_sumstats step)
# Directory where `ldsc.py` resides
LDSC_DIR="./ldsc/"

# Download and unpack the baselineLD_v2.2 model from https://storage.googleapis.com/broad-alkesgroup-public-requester-pays/LDSCORE/1000G_Phase3_baselineLD_v2.2_ldscores.tgz 
# Download and unpack the weights files from https://storage.googleapis.com/broad-alkesgroup-public-requester-pays/LDSCORE/1000G_Phase3_weights_hm3_no_MHC.tgz
# Prefix where the baselineLD model scores reside
# This should contain files like `baselineLD.1.l2.ldscore.gz`
BASELINELD_MODEL="./baselineLD_v2.2/baselineLD."
# Prefix where the baselineLD model scores reside
# This should contain files like `weights.hm3_noMHC.2.l2.ldscore.gz`
BASELINELD_WEIGHT="./1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC."

# Download the base model from https://storage.googleapis.com/broad-alkesgroup-public-requester-pays/LDSCORE/eur_w_ld_chr.tar.bz2
# Unpack both into the directory `eur_w_ld_chr`
# Directory where the base model resides
# This should contain files like `1.l2.ldscore.gz` and `w_hm3.snplist`
BASE_MODEL_DIR="./eur_w_ld_chr/"

# ---
# Start Running
# ---

for t in population direct; do

# Process the summary statistics

$LDSC_DIR/munge_sumstats.py \
--sumstats $gwas.gz \
--out $gwas.${t}.munged  \
--N-col ${t}_N --p ${t}_pval --signed-sumstats ${t}_Z,0 \
--merge-alleles ${BASE_MODEL_DIR}/w_hm3.snplist --n-min $minn

# Run using the base model (these estimates will be inflated)
$LDSC_DIR/ldsc.py \
--h2 $gwas.$t.munged.sumstats.gz \
--ref-ld-chr ${BASE_MODEL_DIR}/ \
--w-ld-chr ${BASE_MODEL_DIR}/ \
--out $gwas.${t}.LDSC_h2.base_model

# Run using the baselineLF model (these estimates will be more accurate)
$LDSC_DIR/ldsc.py \
--h2 $gwas.$t.munged.sumstats.gz \
--ref-ld-chr $BASELINELD_MODEL \
--w-ld-chr $BASELINELD_WEIGHT \
--out $gwas.${t}.LDSC_h2.baselineLD_model

done

grep "Total Observed scale h2" *.log
