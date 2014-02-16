function searchlight_batch(statmap, analysis, mask, whichsrchlght, whichsubs)

% SEARCHLIGHT_BATCH(STATMAP,ANALYSIS,MASK,WHICHSRCHLGHT,WHICHSUBS) scans
% imaged brain volumes at each voxel within MASK. The searchlight is a
% spherical cube, the contents of which are analyzed via differences in
% Fisher-transformed correlations across conditions of interest. The
% difference value computed at each location is assigned to the center voxel
% of the searchlight. The resulting z-map shows how well the multivariate
% signal in the local spherical neighborhood differentiates between
% conditions of interest.
%
% SEARCHLIGHTBATCH assumes a home directory that contains a "searchlight"
% directory, which contains a "results" directory and a "masks" directory.
% In turn, "results" is assumed to contain one directory for each set of
% general linear model (GLM) maps that is analyzed. STATMAP declares the
% name of this directory within "results". The directory specified by
% STATMAP will be made to contain one directory for each radius-mask
% analysis, declared by ANALYSIS, which can take the form ['r' radius mask]
% (e.g., "r3wholebrain").
%
% Though this searchlight analysis is executed at the level of individual
% subjects (WHICHSEARCHLIGHT = 'subject'), a sample of participants can be
% analyzed as a group in a univariate random-effects analysis
% (WHICHSEARCHLIGHT = 'rfx'). At each voxel, a t-statistic is computed
% comparing the average z-score across participants against 0. The resulting
% t-map shows how well the multivariate signal in the local spherical
% neighborhood of the sample differentiates between conditions of interest.
%
% Finally, a non-searchlight multivariate analysis can be performed for one
% or many regions-of-interest (ROI) at the level of individual subjects
% (WHICHSEARCHLIGHT = 'roi'). This analysis correlates the voxels within an
% ROI instead of creating spherical searchlights at each voxel.
%
% SEARCHLIGHTBATCH is a "wrapper" script that can analyze multiple subjects
% sequentially (those declared by WHICHSUBS, a vector that specifies which
% subjects will be analyzed) should be edited from analysis to analysis. In
% turn, it calls, SEARCHLIGHT.m, SEARCHLIGHTRFX.m, or SEARCHLIGHTROI.m.
% These three scripts are robust across analyses and should not be modified
% in their original form, except in cases that build on their functionality.
%
% Written by Juan Manuel Contreras (juan.manuel.contreras.87@gmail.com) on
% April 27, 2012.

%%%%%%%%%%%%%%%%
% DECLARATIONS %
%%%%%%%%%%%%%%%%

% Directories
homeDir      = 'I:\JuanManuel\FaceCategorization';
d.subsDir    = fullfile(homeDir, 'SUBJECTS');
d.glmDir     = ['RESULTS\GLM_' statmap];
d.masksDir   = fullfile(homeDir, 'SEARCHLIGHT\MASKS');
d.resultsDir = fullfile(homeDir, 'SEARCHLIGHT\RESULTS', statmap, analysis);

% Load subject files and brain mask
d.subs     = dir(fullfile(d.subsDir, 's*'));
d.maskFile = fullfile(d.masksDir, mask);

% Searchlight parameters
d.statmap  = statmap;
d.analysis = analysis;
d.nSubs    = length(d.subs);
d.nConds   = 4;

% Correlation sphere size and statistic type
d.rSphere = str2double(d.analysis(2));
d.rType   = 'spearman'; % pearson, kendall, or spearman

% Indices for correlation matrices
d.within  = [0 1 0 0
             0 0 0 0
             0 0 0 1
             0 0 0 0];
d.between = [0 0 0 1
             0 0 1 0
             0 0 0 0
             0 0 0 0];

% Determine which SPM8 files to load
d.fileType = 'spmT'; % spmT or beta
d.nDeriv   = 2;
if strcmp(d.fileType, 'spmT')
    d.fileInds = 1:d.nConds;
    d.outsideBrain = str2func('iszero');
elseif strcmp(d.fileType, 'beta')
    d.fileInds = 1:d.nDeriv + 1:d.nConds * (d.nDeriv + 1);
    d.outsideBrain = str2func('isnan');
end

%%%%%%%%%%%%%%%%
% COMPUTATIONS %
%%%%%%%%%%%%%%%%

selectSearchlight(whichsrchlght, whichsubs, d)
