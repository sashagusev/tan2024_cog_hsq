inps = c("1KG.cognitive_performance.csv","1KG.cognitive_performance.phi_e2.csv","1KG.cognitive_performance.phi_e4.csv")
inps = c("1KG.adhd.csv","1KG.adhd.phi_e2.csv","1KG.adhd.phi_e4.csv")

ttl = c("Default shrinkage (empirical Bayes)","High polygenicity shrinkage (1e-2)","Low polygenicity shrinkage (1e-4)")

par(mfrow=c(3,1))

for ( input in 1:3 ) {
tab = read.csv(inps[input],as.is=T,head=T)
#ggplot(tab, aes(x=SuperPop, y=PRS_COG_Pop)) + 
#  geom_violin() + stat_summary(fun.y=median, geom="point", size=2, color="red")
#tab_new = data.frame("IID" = c(tab$IID,tab$IID) , "SuperPop" = c(tab$SuperPop,tab$SuperPop) , "PRS" = c(tab$PRS_COG_Dir,tab$PRS_COG_Pop) , "Type" = c(rep("Direct",nrow(tab)),rep("Pop",nrow(tab))))
#ggplot(tab_new, aes(x=SuperPop, y=PRS,fill=Type)) + 
#  geom_violin() + stat_summary(fun.y=median, geom="point", size=2, color="red")

pops = unique(tab$SuperPop)
prs_pop_mean = rep(NA,length(pops))
prs_dir_mean = rep(NA,length(pops))
prs_pop_se = rep(NA,length(pops))
prs_dir_se = rep(NA,length(pops))

for ( i in 1:length(pops) ) {
  keep = tab$SuperPop == pops[i]
  prs_pop_mean[i] = mean( tab$PRS_COG_Pop[ keep ] )
  prs_pop_se[i] = sd( tab$PRS_COG_Pop[ keep ] ) / sqrt(sum(keep))
}

for ( i in 1:length(pops) ) {
  keep = tab$SuperPop == pops[i]
  prs_dir_mean[i] = mean( tab$PRS_COG_Dir[ keep ] )
  prs_dir_se[i] = sd( tab$PRS_COG_Dir[ keep ] ) / sqrt(sum(keep))
}

mat = rbind(prs_pop_mean,prs_dir_mean)
mat_se = rbind(prs_pop_se,prs_dir_se)
colnames(mat) = pops
if ( input == 1 ) ord = order(mat[2,])
mat = mat[ , ord ]
mat_se = mat_se[,ord]
#xval = barplot(mat,beside=T,las=1,ylim=c(-1,1),col=c("#fee08b","#d9ef8b"),border=c("#fc8d59","#91cf60"),ylab="Polygenic Score Mean (Standardized)")
xval = barplot(mat,beside=T,las=1,ylim=c(-1.5,1.5),col=NA,border=NA,ylab="Polygenic Score Mean (Standardized)",main=ttl[input])
arrows(xval[1,],mat[1,],xval[2,],mat[2,],len=0,lwd=3,col="#eeeeee")
abline(h=0,lty=3,col="gray")

points(xval[1,],mat[1,],pch=19,col="#fc8d59")
text( xval[1,],mat[1,],rank(mat[1,]),pos=2,col="#fc8d59")
points(xval[2,],mat[2,],pch=19,col="#91cf60")
text( xval[2,],mat[2,],rank(mat[2,]),pos=4,col="#91cf60")
arrows(xval[1,],mat[1,]-mat_se[1,]*1.96,xval[1,],mat[1,]+mat_se[1,]*1.96,len=0,col="#fc8d59")
arrows(xval[2,],mat[2,]-mat_se[2,]*1.96,xval[2,],mat[2,]+mat_se[2,]*1.96,len=0,col="#91cf60")
legend("bottomrigh",legend=c("Population (w/ confounding)","Within-family (w/ ascertainment)"),pch=19,col=c("#fc8d59","#91cf60"),bty="n")
}