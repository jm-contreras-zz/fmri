function searchlightONE(d)

%%%%%%%%%%%%%%%%
% DECLARATIONS %
%%%%%%%%%%%%%%%%

% Identify files with voxel statistics
statsDir = fullfile(d.subsDir, d.subName, d.glmDir);
files    = dir([statsDir '\' d.fileType '*.img']);
files    = strcat(statsDir, '\', cat(1, files(d.fileInds).name));

% Load brain data
pats = spm_get_mat(files);      % Voxel statistics
mask = spm_get_mat(d.maskFile); % Logical index of brain position

% Initialize result matrices
brainSize    = size(mask);     % Dimensions of brain mask
srchlghtWith = nan(brainSize); % Within-condition correlations
srchlghtBetw = nan(brainSize); % Between-condition correlations
srchlghtSize = nan(brainSize); % Number of voxels in searchlight sphere

% Declare waitbar to report progress and associated variables
h = waitbar(0, ['srchlght of ' d.subName ' with r = ' ...
    num2str(d.rSphere) ' in progress...']);
elapsed = 0; nVox = brainSize(1) * brainSize(2) * brainSize(3); tic

%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE SEARCHLIGHT %
%%%%%%%%%%%%%%%%%%%%%%%

% For every voxel in the brain...
for x = 1:brainSize(1)
    for y = 1:brainSize(2)
        for z = 1:brainSize(3)
            
            % ...if it has numeric values and is within the brain mask
            if any(~d.outsideBrain(pats(x, y, z, :))) && mask(x, y, z) > 0
                
                % ...build a sphere around it
                sphere = makeSphere([x y z], d.rSphere, brainSize);
                
                % ...extract the multivoxel pattern for every sphere element
                iPat = nan(length(sphere), d.nConds);
                for v = 1:length(sphere)
                    iPat(v, :) = reshape(pats(sphere(v, 1), ...
                        sphere(v, 2), sphere(v, 3), :), 1, d.nConds);
                end
                
                % ...remove voxels outside the brain mask, if any
                iPat = iPat(sum(iPat ~= 0, 2) == d.nConds, :);
                
                % ...compute correlations
                r = fisher(corr(iPat, 'type', d.rType));
                
                % ...store the results
                srchlghtWith(x, y, z) = mean(r(logical(d.within)));
                srchlghtBetw(x, y, z) = mean(r(logical(d.between)));
                srchlghtSize(x, y, z) = size(iPat, 1);
                
            end
            
            % Update the progress bar
            waitbar(elapsed / nVox, h); elapsed = elapsed + 1;
            
        end
    end
end

% Compute correlation differences
srchlghtCorr = srchlghtWith - srchlghtBetw;

% Remove the progress bar and report completion
delete(h)
fprintf(['\n' d.subName ' searchlight completed in %.2f min.\n'], toc / 60)

%%%%%%%%%%%%%%%%%%
% OUTPUT RESULTS %
%%%%%%%%%%%%%%%%%%

% Save results
save([d.resultsDir '\' d.subName '_' d.analysis], 'srchlghtCorr', ...
    'srchlghtWith', 'srchlghtBetw', 'srchlghtSize', 'd')

% Write the correlation image
maskVol       = spm_vol(d.maskFile);
maskVol.dt    = [spm_type('float64') spm_platform('bigend')];
maskVol.fname = [saveName '_Corr.img'];
spm_write_vol(maskVol, srchlghtCorr);
