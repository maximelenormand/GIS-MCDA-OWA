# Import packages
library(raster)

# Working directory
wd=""
setwd(wd)

# Merge criteria in a matrix Z
pathcrit="Criteria"              # Path to the folder containing the criteria (in tifs) 
crit=list.files(pathcrit)        # List of criteria    
nbcrit=length(crit)              # Number of criteria

crit1=as.matrix(raster(paste0(pathcrit, "/", crit[1])))     #Intialize Z    
n=dim(crit1)[1]
m=dim(crit1)[2]
Z=matrix(0, ncol=(nbcrit+1), nrow=n*m)
Z[,1]=1:dim(Z)[1]          # Pixel ID
Z[,2]=as.vector(t(crit1))

for(i in 3:(nbcrit+1)){   # Loop over the criteria, one criteria per column, each row represents a pixel
    criti=as.matrix(raster(paste0(pathcrit, "/", crit[(i-1)])))
    Z[,i]=as.vector(t(criti))
}

colnames(Z)=c("Pixel_ID", substr(crit, 1, nchar(crit)-4))
 
# Identify pixels with at least one NA
IDNA=Z[apply(is.na(Z), 1, sum)>0, 1]

# Remove the NAs
Z=Z[-IDNA,]

# Sort Z by row & keep track of the order (to apply the criteria weights)
sortZ=t(apply(t(Z[,-1]), 2, sort))
sortZ=cbind(Z[,1], sortZ)
colnames(sortZ)=c("Pixel_ID", paste0("(", 1:nbcrit, ")"))

orderZ=t(apply(t(Z[,-1]), 2, order))
orderZ=cbind(Z[,1],orderZ)
colnames(orderZ)=c("Pixel_ID", paste0("(", 1:nbcrit, ")"))

# Save the results in a .Rdata
save(Z, IDNA, sortZ, orderZ, file="Z.Rdata")



