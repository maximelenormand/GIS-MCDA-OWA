# Import packages
library(doParallel)

# Working directory
wd=""
setwd(wd)

# Compute L2 distances between all maps
lmap=list.files("Maps")
nmap=length(lmap)

dmap=matrix(0, nrow=nmap, ncol=nmap)
for(i in 1:(nmap-1)){

  print(i)

  # Load map
  load(paste0("Maps/",lmap[i])) 
  mapi=map

  # Loop to compute L2 distances
  cl=makeCluster(17)
  registerDoParallel(cl)
  d=foreach(j=(i+1):nmap, .combine='c') %dopar% {
    load(paste0("Maps/",lmap[j])) 
    mapj=map
    sum((mapi-mapj)^2, na.rm=T)
  }
  stopCluster(cl)

  dmap[i,]=c(rep(0,i), d) 

}

# Output: Distance + associated risk & tradeoff values 
dmap=dmap+t(dmap)

spl=strsplit(lmap, "_")
risk=as.numeric(unlist(lapply(spl, function(x){ x[[2]] } )))

spl=unlist(lapply(spl, function(x){ x[[3]] } ))
trad=as.numeric(substr(spl, 1, nchar(spl)-6))

save(dmap, risk, trad, file = paste0("MapsDistanceMatrix.Rdata"))


