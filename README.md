fmri
====
**Repository of MATLAB scripts that I wrote as a graduate student (2011-2013) to perform [multivoxel pattern analysis (MVPA)](http://www.ncbi.nlm.nih.gov/pubmed/16899397) of [functional magnetic resonance imaging (fMRI)](http://en.wikipedia.org/wiki/Functional_magnetic_resonance_imaging) data. MVPA is a novel data mining method in fMRI research to analyze distributed patterns of brain activity, which the human brain uses to represent information ([Mahmoudi, Takerkart, Regragui, Boussaoud, & Brovelli, 2012](http://www.hindawi.com/journals/cmmm/2012/961257/)). Variations of some of the scripts in this repository were used for two scientific publications ([Contreras, Banaji, & Mitchell, 2013](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0069684); [Contreras, Schirmer, Banaji, & Mitchell, 2013](http://www.wjh.harvard.edu/~jmcontre/ContrerasSchirmerBanajiMitchell2013.pdf)).**

- **searchlight.m** uses parameter estimates from SPM8 images to perform two types of MVPA: Whole-brain searchlights ([Kriegeskorte, Goebel, & Bandettini, 2006](http://www.ncbi.nlm.nih.gov/pubmed/16537458)) and region-of-interest (ROI) analyses. It ouputs the resulting statistics as .mat files and brain images. It serves as a wrapper to the following four scripts.
  - **searchlightSEL.m** selects which MVPA to execute: individual- and/or group-level searchlight, or ROI analysis
  - **searchlightONE.m** computes individual-level searchlights
  - **searchlightRFX.m** uses searchlight results produced by **searchlightONE.m** to perform a group-level analysis
  - **searchlightROI.m** executes an ROI analysis given a brain mask denoting one or more ROIs

- **r2z.m** applies a [Fisher transformation](http://en.wikipedia.org/wiki/Fisher_transformation) to transform correlation coefficients to *z*-statistics.

- **temporalSNR.m** computes temporal signal-to-noise ratio, number of experimental timepoints, or effect size in an fMRI experiment given two of these variables and a *p*-value ([Murphy, Bodzurka, & Bandettini, 2007](http://www.ncbi.nlm.nih.gov/pubmed/17126038)).
