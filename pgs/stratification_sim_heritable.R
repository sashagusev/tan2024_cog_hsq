set.seed(0)
pdf("stratification_sim_heritable.pdf",width=20,height=4)
par(mfrow=c(1,5))

M = 5e3
N = 10e3
M_causal = 100
hsq = 0.2

maf_p0 = runif(M,0.1,0.9)
maf_p1 = maf_p0 + rnorm(M,0,0.05)
maf_p2 = maf_p0 + rnorm(M,0,0.05)

# select causal variants to have identical frequencies
p_causal = sample(1:M,M_causal)
maf_p1[p_causal] = maf_p0[p_causal]
maf_p2[p_causal] = maf_p0[p_causal]

plot(maf_p1,maf_p2,las=1,xlim=c(0,1),ylim=c(0,1),cex=0.5,col="#00000050",bty="n",xlab="Frequency in Pop A",ylab="Frequency in Pop B",main="Neutral Drift")
points( maf_p1[p_causal],maf_p2[p_causal],col="#91cf60",cex=0.5)
legend("topleft",legend=c("Causal","Non-causal"),col=c("#91cf60","#000000"),bty="n",pch=1)
maf_p1[ maf_p1 < 0.1 ] = 0.1
maf_p1[ maf_p1 > 0.9 ] = 0.9
maf_p2[ maf_p2 < 0.1 ] = 0.1
maf_p2[ maf_p2 > 0.9 ] = 0.9

X1 = matrix(NA,N,M)
X2 = matrix(NA,N,M)
for ( i in 1:M ) {
  X1[,i] = rbinom(N,2,maf_p1[i])
  X2[,i] = rbinom(N,2,maf_p2[i])
}
X_both = scale( rbind(X1,X2) )

# generate phenotypes with different population means
pop_lbl = c(rep(0,N),rep(1,N))
# generate the genetic component
b_causal = rnorm(M_causal,0,sqrt(hsq/M_causal))
gv = scale(X_both[,p_causal] %*% b_causal / M_causal) * sqrt(hsq)
# generate the phenotype
y = pop_lbl * 0.5 + gv + rnorm(N*2,0,sqrt(1-hsq))

# compute GWAS betas
beta = sqrt(N) * t(X_both) %*% (y) / N
# compute polygenic scores
prs = X_both %*% beta / M

clr = c("#d53e4f","#fc8d59")
brk = seq(-max(abs(y)),max(abs(y)),length.out=100)
hist(y,breaks=brk,border=NA,col=NA,las=1,xlab="Phenotype",ylab="",main="Heritable + stratified phenotype",bty="n",yaxt="n")
hist(y[pop_lbl==0],breaks=brk,add=T,border="#d53e4f",col="#d53e4f50")
hist(y[pop_lbl==1],breaks=brk,add=T,border="#fc8d59",col="#fc8d5950")
legend("topleft",legend=c("Population A","Population B"),fill=c("#d53e4f","#fc8d59"),bty="n")

brk = seq(-max(abs(gv)),max(abs(gv)),length.out=100)
hist(gv,breaks=brk,border=NA,col=NA,las=1,xlab="Genetic Value",ylab="",main="True genetic value",bty="n",yaxt="n")
hist(gv[pop_lbl==0],breaks=brk,add=T,border="#d53e4f",col="#d53e4f50")
hist(gv[pop_lbl==1],breaks=brk,add=T,border="#fc8d59",col="#fc8d5950")

brk = seq(-max(abs(prs)),max(abs(prs)),length.out=100)
hist(prs,breaks=brk,border=NA,col=NA,las=1,xlab="Polygenic Score",main="Predicted genetic value",ylab="",bty="n",yaxt="n")
hist(prs[pop_lbl==0],breaks=brk,add=T,border="#d53e4f",col="#d53e4f50")
hist(prs[pop_lbl==1],breaks=brk,add=T,border="#fc8d59",col="#fc8d5950")

cat( cor(prs,pop_lbl),cor(y,pop_lbl),'\n')
cor(prs[pop_lbl == 0] , y[pop_lbl==0])

plot( prs , y , cex=0.5 , las=1 , type="n" , ylim=c(-1,1),bty="n",xlab="Polygenic score",ylab="Phenotype",main="Accurate within-group predictions",xlim=c(-1,1))
ncuts = 11

for ( cur_pop in c(0,1) ) {
cur_x = prs[pop_lbl == cur_pop]
cur_y = y[pop_lbl==cur_pop]
decs = cut( cur_x, quantile(cur_x, prob = seq(0, 1, length = ncuts), type = 5) )
xvals = rep(NA,ncuts)
yvals = xvals
ctr = 1
for ( i in unique(decs) ) {
  xvals[ctr] = mean(cur_x[decs==i],na.rm=T)
  yvals[ctr] = mean(cur_y[decs==i],na.rm=T)
  ctr = ctr + 1
}
ord = order(xvals)
xvals = xvals[ord]
yvals = yvals[ord]
points(xvals,yvals,pch=19,col=clr[cur_pop+1] )
lines(xvals,yvals,col=clr[cur_pop+1] )
}
dev.off()