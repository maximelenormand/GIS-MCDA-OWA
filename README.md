# Comprehensive decision-strategy space exploration in GIS-MCDA with OWA

## Description

This repository contains six R scripts to perform a spatial multi-criteria 
decision analysis according to a given set of criteria as described in 
[[1]](https://www.sciencedirect.com/science/article/pii/S0198971520302490). The 
workflow takes as input a set of rasters (same extend and resolution) that 
(spatially) represents the criteria used to build suitability maps on which the 
final decision will be based. For each criteria, a pixel contains a value 
ranging from 0 (not suitable) to 1 (suitable). The different scripts described 
below can be used independently as needed. The first two scripts allow to 
aggregate the criteria using an OWA operator in which the criteria and order 
weights are defined manually. Scripts 3 to 6 can be used to automatically 
generate suitability maps according to a certain level of risk and trade-off 
based on the method described in 
[[2]](https://onlinelibrary.wiley.com/doi/full/10.1002/int.21963) using the 
scripts avalaible 
[here](https://github.com/maximelenormand/OWA-weights-generator). 

To illustrate the approach, the folder ***Criteria*** contains 10 rasters 
regarding urban land use suitability in South of France (more details available 
[here](https://www.sciencedirect.com/science/article/pii/S0198971520302490)).

## Scripts

  * **1_BuildZ** transform the rasters contained in the folder ***Criteria*** into a matrix ***Z*** which value ***Zij*** represents the suitability of pixel ***i*** according to criteria ***j***. Pixels with at least one NA value are filtered out and their position is stored in a boolean vector ***IDNA***. Two matrices ***sortZ*** and ***orderZ*** are also computed to sort ***Z*** by row and keep track of the original column indices in the sorted matrix.  
  * **2_GenerateSuitabilityBasedMaps** applies the OWA operator on ***Z*** according to a given set of criteria and order weights set manually. I relied here on the three typical vectors of order weights **low risk - no tradeoff**, **high risk - no tradeoff** and **intermediate risk - full tradeoff** corresponding to the couple of risk and tradeoff values **(0,0)**, **(1,0)** and **(0.5,1)**, respectively. The scripts returns the suitability maps associated to the vectors of order weights stored in a folder ***Maps***.
  * **3_GenerateExperimentalDesign** allows to generate a given number of order weights vectors (1,000 by default) according to different combinations of risk and tradeoff value sampled from the decision-strategy space using the function **owg.R** and **ED.R** described [here](https://github.com/maximelenormand/OWA-weights-generator).  
  * **4_GenerateSuitabilityMaps** applies the OWA operator on ***Z*** for each set of order weights generated with the experimental design. The scripts returns the suitability maps associated to the vectors of order weights stored in a folder ***Maps***.
  * **5_SuitabilityMapsDistanceMatrix** computes an Euclidean distance matrix between every pairs of suitability maps generated above. 
  * **6_ClusterAnalysis** performs a cluster analysis to segment the decision-strategy space and identify clusters of risk and trade-off values leading to similar suitability maps. 

## Contributors

- [Maxime Lenormand](https://www.maximelenormand.com/)
- [Maxence Soubeyrand](https://scholar.google.com/citations?user=tAPNCJQAAAAJ&hl=en)
- [Olivier Billaud](https://www.researchgate.net/profile/Olivier_Billaud)

## References

[1] Billaud *et al.* (2020) [Comprehensive decision-strategy space exploration for efficient territorial planning strategies.](https://www.sciencedirect.com/science/article/pii/S0198971520302490) 
*Computers, Environment and Urban Systems* 83, 101516.  

[2] Lenormand M (2018) [Generating OWA weights using truncated distributions.](https://onlinelibrary.wiley.com/doi/full/10.1002/int.21963) 
*International Journal of Intelligent Systems* 33, 791–801. [[arXiv](https://arxiv.org/abs/1709.04328)]

## Citation

If you use this code, please cite the following reference:

Billaud *et al.* (2020) [Comprehensive decision-strategy space exploration for efficient territorial planning strategies.](https://www.sciencedirect.com/science/article/pii/S0198971520302490) 
*Computers, Environment and Urban Systems* 83, 101516. 

If you need help, find a bug, want to give me advice or feedback, please contact me!

## Repository mirrors

This repository is mirrored on both GitLab and GitHub. You can access it via the following links:

- **GitLab**: [https://gitlab.com/maximelenormand/gis-mcda-owa](https://gitlab.com/maximelenormand/gis-mcda-owa)  
- **GitHub**: [https://github.com/maximelenormand/gis-mcda-owa](https://github.com/maximelenormand/gis-mcda-owa)  

The repository is archived in Software Heritage:

[![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/maximelenormand/gis-mcda-owa/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/maximelenormand/gis-mcda-owa)
