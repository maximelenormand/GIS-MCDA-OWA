############################################################################################################################
# This script proposes several functions to generate OWA weights using the truncated normal distribution.
# 
# The main function owg automatically generates OWA weights according to a certain number of criteria, 
# level of risk and level of tradeoff.
#
# Author: Maxime Lenormand
############################################################################################################################

#Import packages
#library(truncnorm)
#library(scales)

#OWA order weights generator according to a certain number of criteria, level of risk and level of tradeoff
#The function returns the order weights and a boolean that indicates whether the weights values are accurate or not
#If warn=TRUE the function returns a warning if the risk and trade-off are not suitable 
owg=function(n,risk,tradeoff,warn=TRUE){

    #Initialize suitable
    suit=TRUE

    #Exception: Small Trade-off values
    if(tradeoff<0.01){

        w=rep(0,n)
        
        d=abs(risk-((seq(1,n,1)-1)/(n-1)))
        minindex=which(d==min(d))
        if(length(minindex)==2){
            minindex=minindex[sample(2,1)]
        }
        w[minindex]=1 

    #Trade-off in ]0,1]
    }else{

        # Warning if outside decision-strategy space
        if((tradeoff > (4*risk*(1-risk)))){            
            suit=FALSE
            if(warn){
                print("No suitable PDF found for these values of risk and trade-off")
            }
            w=rep(NA,n)
        }

        # Generate mu and sd
        maxsdw=(1/(2*sqrt(3)))

        muw=risk
        sdw=tradeoff*maxsdw
        res=inv.moment.tnorm(muw,sdw)

        mu=res$mu
        sd=res$sd

        #Discretization
        w=NULL
        for(i in 0:(n-1)){
            w=c(w,dtruncnorm(i/(n-1),0,1,mu,sd))
        }
        w=w/sum(w)
        w=round(w, digits=5)

        # Warning if w = NA, it may happen for very small tradeoff values
        if(is.na(w[1])){
            suit=FALSE
            if(warn){
                print("No suitable PDF found for these values of risk and trade-off")
            }
        }

        # Warning if sd < 0
        if(sd<0){
            suit=FALSE
            if(warn){
                print("No suitable PDF found for these values of risk and trade-off")
            }
            w=rep(NA,n)
        }

    }
    
    L=list(Weights=w, Suitable=suit)
    return(L)
    
}

#Return the truncated mean mu_w and the truncated standard deviation sd_w of a truncated normal distribution (mu,sd,0,1)
#Definition from https://en.wikipedia.org/wiki/Truncated_normal_distribution
moment.tnorm=function(mu,sd){
  
  alpha=(0-mu)/sd
  beta=(1-mu)/sd
  muw=mu+sd*(dnorm(alpha)-dnorm(beta))/(pnorm(beta)-pnorm(alpha))
  sdw=(1+(alpha*dnorm(alpha)-beta*dnorm(beta))/(pnorm(beta)-pnorm(alpha))-((dnorm(alpha)-dnorm(beta))/(pnorm(beta)-pnorm(alpha)))^2)
  sdw=sqrt((sd^2)*sdw)

  res=list(muw=muw,sdw=sdw)
  return(res)

}

#Return the mean mu and the standard deviation sd of a truncated normal distribution (mu,sd,0,1)
#according to the truncated mean mu_w and the truncated standard deviation sd_w
#The function also returns the estimated mu_w and sd_w and an error of estimation (L2)
inv.moment.tnorm=function(muw,sdw){

     #Function to minimize, distance between actual and simulated moments
     l2=function(par,muw,sdw){
        mom=moment.tnorm(par[1],par[2])
        sqrt(sum((muw-mom$muw)^2+(sdw-mom$sdw)^2)) 
     }

     #Minimisation of distfun in order to the optimal couple (mu,sd)
     opt=optim(par=c(muw,sdw),l2,muw=muw,sdw=sdw)
     
     mom=moment.tnorm(mu=opt$par[1],sd=opt$par[2])

     res=list(mu=opt$par[1],sd=opt$par[2],estmuw=mom$muw,estsdw=mom$sdw,err=opt$value)
     return(res)

}

#Orness & andness
orandness=function(w){
  
  n=length(w)
  
  andness=(1/(n-1))*sum(w*(n-(1:n)))
  orness=(1-andness)
  
  res=list(orness=orness, andness=andness)
  
  return(res)
  
}

#Dispersion & Tradeoff
tradeoff=function(w){
  
  n=length(w)
  
  disp=-sum(w*log(w))/log(n)
  trad=1-sqrt((n/(n-1))*sum((w-1/n)^2))
  
  res=list(disp=disp, trad=trad)
  
  return(res)
  
}







