function searchlight_selector(whichsearchlight, whichsubs, d)

switch whichsearchlight
    
    % Subject-level searchlight
    case 'subject'
        for iSub = whichsubs(1):whichsubs(end)
            d.iSub = iSub;
            d.subName = d.subs(iSub).name;
            searchlightONE(d)
        end
        
    % Random-effects analysis of individual searchlights
    case 'rfx'  
        searchlightRFX(d)
    
    % Subject-level searchlights followed by a random-effects analysis
    case 'subject_rfx'   
        searchlight_selector('subject', whichsubs, d)
        searchlight_selector('rfx', whichsubs, d)
    
    % Region-of-interest analysis
    case 'roi'     
        mask = spm_get_mat(d.maskFile);
        nROI = max(unique(mask));
        results = nan(d.nSubs, nROI);
        for iSub = whichsubs(1):whichsubs(end)            
            d.iSub = iSub;
            d.subName = d.subs(iSub).name;
            results = searchlightROI(d, results);
        end
        save([d.resultsDir '\ROI_' d.analysis], 'results', 'd')
    
    % Don't know what to do
    otherwise
        error('Input subject, rfx, subject_rfx, or roi.')
        
end
