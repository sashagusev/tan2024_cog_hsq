# LCV

source("RunLCV.R")

process_and_run_LCV = function( trait1File , trait2File , n1 , n2 , ldscoresFile ) {
  # Load trait 1 data and calculate Zs
  d1 = na.omit(read.table(gzfile(trait1File),header=TRUE,stringsAsFactors = FALSE))
  colnames(d1)[2] = "A1"
  colnames(d1)[3] = "A2"
  
  # get standard error from p-value for Nawaz
  if ( sum(colnames(d1) == "se") == 0 ) {
    z = qnorm(d1$pval/2)
    d1$se = abs(d1$beta/z)
  }
  d1$Z = d1$beta/d1$se
  
  #Load trait 2 data and calculate Zs
  d2 = na.omit(read.table(gzfile(trait2File),header=TRUE,stringsAsFactors = FALSE))
  colnames(d2)[2] = "A1"
  colnames(d2)[3] = "A2"
  d2$Z = d2$beta/d2$se
  
  #Load LD scores
  d3=read.table(gzfile(ldscoresFile),header=TRUE,stringsAsFactors=FALSE)
  
  #Merge
  m = merge(d3,d1,by="SNP")
  data = merge(m,d2,by="SNP")
  
  #Sort by position 
  data = data[order(data[,"CHR"],data[,"BP"]),]
  
  #Flip sign of one z-score if opposite alleles-shouldn't occur with UKB data
  #If not using munged data, will have to check that alleles match-not just whether they're opposite A1/A2
  mismatch = which(data$A1.x!=data$A1.y,arr.ind=TRUE)
  data[mismatch,]$Z.y = data[mismatch,]$Z.y*-1
  data[mismatch,]$A1.y = data[mismatch,]$A1.x
  data[mismatch,]$A2.y = data[mismatch,]$A2.x
  
  data = data[ !is.na(data$L2+data$Z.x+data$Z.y) , ]
  LCV = RunLCV(data$L2,data$Z.x,data$Z.y,n.1=n1,n.2=n2)
  return(LCV)
}

# Volume <-> IQ
LCV = process_and_run_LCV ( trait1 = "Nawaz_ICV.HM3.sumstats.gz" , trait2 = "Lee_CP.HM3.sumstats.gz" , n1 = 79174 , n2 = 257841 , ldscoresFile = "all.l2.round.ldscore.gz" )
sprintf("Volume -> IQ : Estimated posterior gcp=%.2f(%.2f), log10(p)=%.1f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, log(LCV$pval.gcpzero.2tailed)/log(10), LCV$rho.est, LCV$rho.err)
# Volume <-> EA
LCV = process_and_run_LCV ( trait1 = "Nawaz_ICV.HM3.sumstats.gz" , trait2 = "Okbay_EA.HM3.sumstats.gz" , n1 = 79174 , n2 = 3037499 - 2272216 , ldscoresFile = "all.l2.round.ldscore.gz" )
sprintf("Volume -> EA : Estimated posterior gcp=%.2f(%.2f), log10(p)=%.1f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, log(LCV$pval.gcpzero.2tailed)/log(10), LCV$rho.est, LCV$rho.err)
# IQ <-> EA
LCV = process_and_run_LCV ( trait1 = "Lee_CP.HM3.sumstats.gz" , trait2 = "Okbay_EA.HM3.sumstats.gz" , n1 = 257841 , n2 = 3037499 - 2272216 , ldscoresFile = "all.l2.round.ldscore.gz" )
sprintf("IQ -> EA : Estimated posterior gcp=%.2f(%.2f), log10(p)=%.1f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, log(LCV$pval.gcpzero.2tailed)/log(10), LCV$rho.est, LCV$rho.err)