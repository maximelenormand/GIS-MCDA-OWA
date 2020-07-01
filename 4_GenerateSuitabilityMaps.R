# Import packages
library(raster)

# Working directory
wd=""
setwd(wd)

# Load data
load("Z.Rdata")
load("W.Rdata")

# Load a criteria map as template
pathcrit="Criteria"              # Path to the folder containing the criteria (in tifs) 
crit=list.files(pathcrit)        # List of criteria    
nbcrit=length(crit)              # Number of criteria

temp=as.matrix(raster(paste0(pathcrit, "/", crit[1])))
n=dim(temp)[1] 
m=dim(temp)[2] 

# Define the criteria weights (TO ADAPT TO YOUR CASE STUDY)
v=c(15,8,6,5,14,6,8,8,5,15)/15

# Create an ordered criteria weights matrix based on v and orderZ
V=matrix(v[as.vector(orderZ[,-1])], nrow=length(orderZ[,1]), ncol=nbcrit)
V=cbind(Z[,1], V)
colnames(V)=colnames(Z)

# Loop to generate the maps stored as Rdata in a folder Maps
dir.create("Maps") # Create folder Maps
 
sampsize=length(w[,1])
for(i in 1:sampsize){

  gc()
  print(c(i,sampsize))

  risk=w[i,1]         # Risk
  tradeoff=w[i,2]     # Tradeoff
  wi=w[i,][-c(1:2)]   # Order weights

  # Weight matrix
  VW=t(wi*t(V[,-1])) 
  VW=VW/apply(VW, 1, sum)

  # OWA
  owa=apply(VW*sortZ[,-1], 1, sum) 

  # Put the NAs back to build the map    
  map1=cbind(Z[,1], owa) 
  colnames(map1)=c("ID","W")
  map2=cbind(IDNA, NA)
  colnames(map2)=c("ID","W")
  map=rbind(map1,map2)
  map=map[order(map[,1]),]

  # Build the map 
  map=matrix(map[,2], nrow=n, ncol=m, byrow = TRUE) 

  # Save the resulting matrix/map in a Rdata
  save(map, file = paste0("Maps/SuitabilityMap_",risk,"_",tradeoff,".Rdata"))

}




