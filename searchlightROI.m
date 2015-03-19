function results = searchlightROI(d, results)

%%%%%%%%%%%%%%%%
% DECLARATIONS %
%%%%%%%%%%%%%%%%

% Identify files with voxel statistics
statsDir = fullfile(d.subsDir, d.subName, d.glmDir);
files = dir([statsDir '\' d.fileType '*.img']);
files = strcat(statsDir, '\', cat(1,files(d.fileInds).name));

% Load brain data
pats = spm_get_mat(files);      % Voxel statistics
mask = spm_get_mat(d.maskFile); % Logical index of brain position

% Count the number of unique ROIs in the brain mask
nROI = max(unique(mask));

%%%%%%%%%%%%%%%%
% COMPUTATIONS %
%%%%%%%%%%%%%%%%

% For every ROI...
for iROI = 1:nROI
    
    % ...determine its size
    sizeROI = sum(sum(sum(mask == iROI)));
    
    % ...extract the multivoxel patterns for every condition
    iROIpats = nan(sizeROI, d.nConds);
    for iCond = 1:d.nConds
        iROIpatsTemp = pats(:, :, :, iCond);
        iROIpats(:, iCond) = iROIpatsTemp(mask == iROI);
    end
    
    % ...compute correlation differences and store results
    r = fisher(corr(iROIpats, 'type', d.rType));
    within = mean(r(logical(d.within)));
    between = mean(r(logical(d.between)));
    results(d.iSub, iROI) = within - between;
    
end
