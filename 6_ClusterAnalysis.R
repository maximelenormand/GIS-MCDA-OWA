# Working directory
wd=""
setwd(wd)

# Load data
load("W.Rdata")
load("MapsDistanceMatrix.Rdata")

# List Maps 
lmap=list.files("Maps")
nmap=length(lmap)

# HCA
h=hclust(as.dist(dmap), method= "ward.D2")

# Variance intra / tot
nclustmax=20
vars=rep(0,nclustmax)
for(i in 1:nclustmax){

  clu=cutree(h, i)
  vartot=sum(dmap)/(nmap^2)
  varintra=rep(0,i)
  for(k in 1:i){
    lg=which(clu==k)
    varintra[k]=sum(dmap[lg,lg])/((sum(clu==k)^2))*sum(clu==k)/nmap
  }

  vars[i]=sum(varintra)/vartot

}

pdf("Vintratot.pdf", width=8.322917, height=5.811220, useDingbats=FALSE)

    par(mar=c(5, 7, 1, 1))
    par(mfrow=c(1,1))
    plot(1:20, vars, typ="b", cex=2, lwd=3, pch=16, col="steelblue3", axes=FALSE, xlab="", ylab="", xlim=c(1,20), ylim=c(0,1))
    box(lwd=1.5)
    axis(1, las=1, cex.axis=1.7, lwd=1.5, padj=0.2)
    axis(2, las=1, cex.axis=1.75, lwd=1.5, at=seq(0,1,0.2))
    mtext("Number of clusters",1,line=3.5,cex=2)
    mtext("Variance intra / total",2,line=5,cex=2)

dev.off()


# Results clustering
clu=cutree(h, 4)

colo=c("#E0524C","#F7C501","#93B900","#33ABCE")

pdf("Clustering.pdf", width=7.6, height=7.6, useDingbats=FALSE)

    par(mar=c(6, 7, 2, 2))

    plot(risk, trad, col=colo[clu], pch=19, cex=1.4, xlab="", ylab="", xaxt="n", yaxt="n", frame=F, cex.lab=1.4)

    x=seq(0,1,length.out=1000)
    lines(x,rep(0,1000),lwd=6)
    lines(x,4*x*(1-x),type='l',lwd=6)

    axis(1, cex.axis=1.75, padj=0.2)
    axis(2, cex.axis=1.75, las=2, line=0.4)
    mtext("Risk", 1, cex=2.5, line=4.5)
    mtext("Trade-off", 2, cex=2.5, line=4.7)

dev.off()

# Average & SD maps by clusters
#for(k in 1:max(clu)){
#
#    riskk=risk[clu==k]
#    tradk=trad[clu==k]
#    nk=sum(clu==k)
#    
#    mat=0
#    mat2=0
#    for(i in 1:nk){
#        
#        print(c(k,i))
#
#        load(paste0("Maps/SuitabilityMap_",riskk[i],"_",tradk[i],".Rdata"))
#
#        mat=mat+map/nk
#        mat2=mat2+map*map/nk
#
#    }
#
#    mat2=mat2-mat*mat
#
#    map=mat
#    save(map, file = paste0("Maps/Average_", k,".Rdata"))
#    map=mat2
#    save(map, file = paste0("Maps/SD_", k,".Rdata"))
#
#}



