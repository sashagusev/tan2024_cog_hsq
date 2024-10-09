# ---
# Set up:
# ---

# This script is identical to `run_all.sh` but does not munge any summary stats
# The Howe et al. statistics were created separately
# Download the summary stats from:
# https://gwas.mrcieu.ac.uk/datasets/ieu-b-4838/ (population)
# https://gwas.mrcieu.ac.uk/datasets/ieu-b-4837/ (direct)
gwas="Howe.Cog"

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
