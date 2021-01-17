%{ 
Author: Deepti Ghadiyaram

Description: Given an input RGB image, this method extracts the
FRIQUEE-Chroma features proposed in [1] in LAB color space.

Input: a MXN array of chroma map (computed from A and B color channels).

Output: Features extracted from the chroma map (as described in the section
Chroma Feature Maps in [1])

Dependencies: This method depends on the following methods:
    neighboringPairProductFeats.m
    sigmaMapFeats.m
    debiasedNormalizedFeats.m
    DoGFeat.m
    lapPyramidFeats.m

Reference:
[1] D. Ghadiyaram and A.C. Bovik, "Perceptual Quality Prediction on Authentically Distorted Images Using a
Bag of Features Approach," http://arxiv.org/abs/1609.04757
%}
function feat = friqueeChroma(imChroma)

    % Initializations
    scalenum=2;   
    imChroma1=imChroma;
    
    % The array that aggregates all the features from different feature
    % maps.
    feat = [];
    
    % Some features are computed at multiple scales
    for itr_scale = 1:scalenum
        
        % 4 Neighborhood map features of Chroma map
       nFeat = neighboringPairProductFeats(imChroma);
       feat = [feat nFeat];
       
        % Sigma features of Chroma map
        [sigFeat, sigmaMap] = sigmaMapFeats(imChroma);
        feat = [feat sigFeat];
        
        % Chroma map's classical debiased and normalized map's features.
        dnFeat = debiasedNormalizedFeats(imChroma);
        feat = [feat dnFeat];
        
        % Debiased and normalized map features of the sigmaMap of Chroma map.
        dnSigmaFeat = debiasedNormalizedFeats(sigmaMap);
        feat = [feat dnSigmaFeat];

        % Scale down the image by 2 and repeat the feature extraction.
        imChroma = imresize(imChroma,0.5);
    end
    
    imChroma=imChroma1;
    
    % Features from the Difference of Gaussian (DoG) of Sigma Map 
    dFeat =DoGFeat(imChroma);
    feat = [feat dFeat];
    
    % Laplacian of the Chroma Map
    lFeat = lapPyramidFeats(imChroma);
    feat = [feat lFeat];
end