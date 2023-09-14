# PersonalizedAtlas

### v0.01 Repository for "A Personalized Cortical Atlas for Functional Regions of Interest" Molloy & Osher (2023). 
THIS CODE IS CURRENTLY IN A VERY EARLY ALPHA RELEASE AND ASSUMES THAT VOXELWISE FUNCTIONAL CONNECTIVITY HAS ALREADY BEEN COMPUTED AND SAVED AS A MAT FILE CONTAINING THE VARIABLE "cortex" AS A 59412x59412 SINGLE PRECISION FLOAT. OUR NEXT RELEASE WILL COMPUTE FUNCTIONAL CONNECTIVITY FROM DATA THAT HAVE BEEN RUN THROUGH THE HCP PIPELINE AND EXIST AS CIFTI FILES ON THE fsaverage_LR32k SURFACE, AND FUTURE RELEASES WILL INCLUDE THE HCP PIPELINE. 
WE ARE ALSO CURRENTLY OPTIMIZING THESE SCRIPTS TO REQUIRE LESS RAM. AT THE MOMENT, 16GB ARE REQUIRED AND 20GB IS RECOMMENDED.

#### Compute rs-fROIs 
The main commands to compute the 21 fROIs for motor control, working memory, high-level vision, and language are `compute_personalized_parcellations.m` and `compute_rsfROIs.m`. 

To compute for an example subject, change the working directory to this folder, and run 
```
% define subject id. Should contain a 59412x59412 connectome fc 
subj='Example'
% compute individualized parcellations for k values identified in the training stage
compute_personalized_parcellations(subj) %outputs as .mat files in Parcellations subdirectory 
% compute .mat and cifti files for all 21 rsfROIs
define_rsfroi(subj,wb_path) %wb_path is path to connectome workbench v1.3.2 wb_command
```
_Contrast and fROI Key_

| Contrast    | fROI                                  |
|-------------|---------------------------------------|
| RH-AVG      | Right Hand                            |
| LH-AVG      | Left Hand                             |
| RF-AVG      | Right Foot                            |
| LF-AVG      | Left Foot                             |
| T-AVG       | Tongue                                |
| BODY-AVG    | Extrastriate Body Area (EBA)          |
| FACE-AVG    | Fusiform Face Area (FFA)              |
| FACE-AVG2   |     Occipital Face Area (OFA)         |
| FACE-AVG3   | Superior Temporal Sulcus (STS)        |
| PLACE-AVG   |     Parahippocampal Place Area (PPA)  |
| PLACE-AVG2  |     Retrosplenial Cortex (RSC)        |
| PLACE-AVG3  |     Transverse Occipital Sulcus (TOS) |
| TOOL-AVG    |     Lateral Occipital (LO)            |
| TOOL-AVG2   |     Posterior Fusiform Sulcus (PFS)   |
| 2BK-0BK     |     Working Memory Network            |
| STORY-MATH1 |     Language 1                        |
| STORY-MATH2 |     Language 2                        |
| STORY-MATH3 |     Language 3                        |
| STORY-MATH4 |     Language 4                        |
| STORY-MATH5 | Language 5                            |
| STORY-MATH6 | Language 6                            |

#### Compute additional personalized k-network parcellations
Additional personalized parcellations can be computed for a k=7-network solution using `compute_personalized_parcellations(subj,wb_path)` (also outputs a cifti file) and for all k total networks from 2 to 200 using `compute_personalized_parcellations_allk(subj)`. The training group-level solutions for all k shown below. 

![image](https://github.com/CognitionBrainCircuitryLab/PersonalizedAtlas/blob/main/g500a.gif)

<i>Supplementary Figure 1.</i> All group parcellations. The above figure shows the k-means group-level parcellations for the 500 training set individuals. In each frame, k increases in an increment of 1 from 2 to 200 networks. The color scheme is preserved in the highest overlapping clusters from one parcellation to the next with an additional random color assigned to the newest network.
