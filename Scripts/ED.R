############################################################################################################################
# This script proposes several functions to design an experimental design and automatically generate OWA weights 
# according to a certain number of criteria and a list of couple of risk and tradeoff values.
# 
# 1. Define your experimental design with defED to generate a shape within the decision-strategy space
# 2. Generate your experimental design with genED to randomly draw risk and tradeoff values within your shape
# 3. CHoose the number of criteria and compute their value with ED and owg that need to be sourced
#
# Author: Maxime Lenormand
############################################################################################################################

#Import packages
#library(rgdal)
#library(rgeos)

#source("owg.R")

# Define your experimental design
# Inputs: Three different shapes: "parabolic" (full space), "circle" or "square" 
#         + set center and radius values if the shape is a circle or a square
# Output: SpatialPolygon representing the shape 
defED=function(shape, center=c(0.5,0.5), radius=0.2){

   # Parabola
   x=seq(0,1,length.out = 10000)
   y=4*x*(1-x)

   parab=cbind(x,y)
   parab=Polygon(rbind(parab,parab[1,]))
   parab=Polygons(list(parab),1)
   parab=SpatialPolygons(Srl=list(parab), proj4string=CRS("+init=epsg:27572"))       

   #If not parabolic
   if(shape!="parabolic"){ 

       # Circle
       if(shape=="circle"){

           X=center[1]
       	   Y=center[2]
           pol=gBuffer(SpatialPoints(cbind(X,Y), proj4string=CRS("+init=epsg:27572")), width=radius, quadsegs=100)        

       }

       # Square
       if(shape=="square"){

       	   X=center[1]
       	   Y=center[2]
       	   coor1=c(X-radius,Y-radius)
       	   coor2=c(X-radius,Y+radius)
       	   coor3=c(X+radius,Y+radius)
       	   coor4=c(X+radius,Y-radius)

       	   pol=rbind(coor1,coor2,coor3,coor4,coor1)
       	   pol=Polygon(rbind(pol,pol[1,]))
       	   pol=Polygons(list(pol),1)
       	   pol=SpatialPolygons(Srl = list(pol),proj4string=CRS("+init=epsg:27572"))

       }

       # Intersection of the shape with the parabola  
       int=gIntersection(parab,pol)

       # NA if the shape is outside the parabola
       if(length(int)==0){
           #print("The shape is outside the parabolic decision-strategy space")
           return(NA)
       }else{
           return(int)
       }
    }else{
        return(parab)
    }

}


# Generate your experimental design
# Inputs: Number of simulations nbsim (i.e. sample size)
#         + a SpatialPolygon pol representing a shape within the decision-strategy space
# Output: Matrix of nbsim couple of risk and tradeoff values draw at random within the shape
genED=function(nbsim, pol){
    ech=spsample(pol, nbsim, "random")
    ech=as.matrix(ech@coords)
    colnames(ech)=c("Risk", "Tradeoff")   

    return(ech)
}


# Choose the number of criteria
# Inputs: Number of weights + a matrix of risk and tradeoff values
# Output: Matrix of risk and tradeoff values + their associated weights 
ED=function(nbcrit, data){

    data[,1]=round(data[,1], digits=5)
    data[,2]=round(data[,2], digits=5)
    nsim=dim(data)[1]

    # Generate the weights for each couple of risk and tradeoff values with owg
    res=NULL
    for(i in 1:nsim){
        owgi=owg(nbcrit,data[i,1],data[i,2],warn=FALSE)
        if(owgi$Suitable){
            res=rbind(res,owgi$Weights)
        }else{# If not suitable compute a new couple of risk and tardeoff based on 10 other values
            test=owgi$Suitable
            count=0
            while(!test & count<1000){
                datai=apply(data[sample(nsim, 10, replace=TRUE),], 2, mean)
                owgi=owg(nbcrit,datai[1],datai[2],warn=FALSE)

                test=owgi$Suitable
                count=count+1                   
            }
            res=rbind(res,owgi$Weights)            
        }
    }

    res=cbind(data, res)
    res=res[!is.na(res[,3]),]
    colnames(res)=c("Risk", "Tradeoff", paste("W_",1:nbcrit,sep=""))

    return(res)

}







