function searchlightRFX(d)

%%%%%%%%%%%%%%%%
% DECLARATIONS %
%%%%%%%%%%%%%%%%

nSubs     = length(d.subs);                % Number of subjects
files     = dir([d.resultsDir '\s*.mat']); % Searchlight statistics
mask      = spm_get_mat(d.maskFile);       % Logical index of brain position
brainSize = size(mask);                    % Dimensions of brain mask

%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD VOXEL STATISTICS %
%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize result matrices
mats = nan([brainSize nSubs]); % Searchlight statistics
pRFX = mats(:, :, :, 1);       % Random-effects p-values
tRFX = mats(:, :, :, 1);       % Random-effects t-values

% Load voxel statistics from searchlight analysis
for iSub = 1:nSubs
    load([d.resultsDir '\' files(iSub).name], 'srchlghtCorr')
    mats(:, :, :, iSub) = eval('srchlghtCorr');
end

%%%%%%%%%%%%%%%%%%%
% COMPUTE T-TESTS %
%%%%%%%%%%%%%%%%%%%

% Declare waitbar to report progress and associated variables
h = waitbar(0,['RFX of ' d.analysis ' in progress...']);
elapsed = 0; nVox = brainSize(1) * brainSize(2) * brainSize(3);

% For every voxel in the brain...
for x = 1:brainSize(1)
    for y = 1:brainSize(2)
        for z = 1:brainSize(3)
            
            % ...if it has numeric values and is within the brain mask
            if any(~isnan(mats(x, y, z, :))) && mask(x, y, z) > 0
                
                % ...compute a one-sample right-tailed t-test
                [~, p, ~, stats] = ttest(mats(x, y, z, :), 0, .05, 'right');
                
                % ...store t- and p-values (if the correlation is positive)
                if stats.tstat > 0
                    tRFX(x,y,z) = stats.tstat;
                    pRFX(x,y,z) = p;
                end
                
            end
            
            % Update the progress bar
            waitbar(elapsed / nVox, h); elapsed = elapsed + 1;
            
        end
    end
end

% Remove the progress bar
delete(h)

%%%%%%%%%%%%%%%%%%
% OUTPUT RESULTS %
%%%%%%%%%%%%%%%%%%

% Save results
save([d.resultsDir '\RFX_' d.analysis], 'mats', 'tRFX', 'pRFX')

% Write t- and p-value images
maskVol = spm_vol(d.maskFile);
maskVol.dt = [spm_type('float64') spm_platform('bigend')];
maskVol.fname = [saveName '_Tval.img'];
spm_write_vol(maskVol, tRFX);
maskVol.fname = [saveName '_Pval.img'];
spm_write_vol(maskVol, 1 - pRFX);
