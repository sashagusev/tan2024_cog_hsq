GWAS=$1

for c in `seq 1 22`; do
cat ${GWAS}.prscs.phi_e2._pst_eff_a1_b0.5_phi1e-02_chr${c}.txt
done > $GWAS.prscs.phi_e2.tab
wc -l $GWAS.prscs.phi_e2.tab
done
