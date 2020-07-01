# Import packages
library(truncnorm)
library(sp)

# Working directory
wd=""
setwd(wd)

# Load functions ED and owg to automatically generate the order weights
source("Scripts/ED.R")
source("Scripts/owg.R")

# Number of criteria
pathcrit="Criteria"              # Path to the folder containing the criteria (in tifs) 
crit=list.files(pathcrit)        # List of criteria    
nbcrit=length(crit)              # Number of criteria

# Generate a list of risks and tradeoffs value
sampsize=1000  # Sample size

parabola=defED(shape="parabolic", center=c(0.5,0.5), radius=0.5)   # Define your experimental design with defED to generate a shape within the decision-strategy space
samp=genED(sampsize, parabola)                                     # Generate your experimental design with genED to randomly draw risk and tradeoff values within your shape
w=ED(nbcrit, samp)                                                 # Generate the weights

# Save the results in the RData
save(w, file="W.Rdata")


