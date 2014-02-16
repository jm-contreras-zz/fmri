function [tnsr tp e] = temporalSNR(which, tp, e, p, tsnr)

% [TSNR TP E] = TEMPORALSNR(WHICH, TP, E, P, TSNR) computes temporal signal-
% to-noise ratio (TSNR), number of experimental timepoints (TP), or effect
% size (E; percentage of baseline activity by which experimental activity
% differs) given two of these variables and a p-value (P). The variable to
% be computed is specified by WHICH, which can be 'tsnr', 'tp', or 'e'. The
% corresponding variable is left undefined.
%
% The equations that perform these computations are derived from theory and
% experimental simulations (Murphy, Bodzurka, & Bandettini, 2007). These
% simulations indicate that a TSNR of .4 is the minimum value to detect
% effects between conditions in functional magnetic resonance imaging data
% reliably (e.g., Anzellotti, Mahon, Schwarzbach, & Caramazza, 2011;
% Simmons, Reddish, Bellgowan, & Martin, 2009).
%
% Anzellotti, S., Mahon, B. Z., Schwarzbach, J., & Caramazza, A. (2011).
%   Differential activity for animals and manipulable objects in the
%   anterior temporal lobes. Journal of Cognitive Neuroscience, 23(8),
%   2059-2067.
% Simmons, W. K., Reddish, M., Bellgowan, P. S. F., & Martin, A. (2010).
%   The selectivity and functional connectivity of the anterior temporal
%   lobes. Cerebral Cortex, 20, 813–825.
% Murphy, K., Bodzurka, J., & Bandettini, P. A. (2007). How long to scan?
%   The relationship between fMRI temporal signal to noise ratio and
%   necessary scan duration. NeuroImage, 34, 565-574.
%
% Written by Juan Manuel Contreras (juan.manuel.contreras.87@gmail.com) on
% November 24, 2011.

% Declare the old standard coefficient
gold = 1.5 * (1 + exp(1) ^ log10(p / 2));

% Temporal signal-to-noise ratio
if strcmp(which, 'tsnr')       
    tnsr = gold * sqrt(8 / tp) * (1 / e) * erfcinv(p);

% Experimental timepoints
elseif strcmp(which, 'tp')    
    tp = 8 * (gold * (erfcinv(p) / (tsnr * e))) ^ 2;

% Effect size
elseif strcmp(which, 'e')
    e = (gold * erfcinv(p)) / (tsnr * sqrt(tp / 8));

% Don't know what to do
else    
    error('The value in WHICH specifies an unknown command.')
    
end
