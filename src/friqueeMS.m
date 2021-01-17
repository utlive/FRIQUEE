%{ 
Author: Deepti Ghadiyaram

Description: Given either M or S maps from LMS color space, this method extracts the
some of the features from LMS Feature Maps proposed in [1] in LMS color space.

Input: a MXN array of either M or S channel map (computed in LMS color space).

Output: Features extracted from the M/S channel map (as described in the section
LMS Feature Maps in [1])

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
function feat = friqueeMS(img)
    scalenum=2;
    img1=img;

    % The array that aggregates all the features from different feature
    % maps.
    feat = [];

    for itr_scale = 1:scalenum    
         % Sigma features of M or S map (from LMS)
        [sigFeat, sigmaMap] = sigmaMapFeats(img);
        feat = [feat sigFeat];
        
        % M or S map's classical debiased and normalized map's features.
        dnFeat = debiasedNormalizedFeats(img);
        feat = [feat dnFeat];
        
         % Debiased and normalized map features of the sigmaMap of Chroma map.
        dnSigmaFeat = debiasedNormalizedFeats(sigmaMap);
        feat = [feat dnSigmaFeat];

        img = imresize(img,0.5);
    end
    
    img=img1;
   
    % Features from the Difference of Gaussian (DoG) of Sigma Map 
    dFeat =DoGFeat(img);
    feat = [feat dFeat];
    
    % Laplacian of the Chroma Map
    lFeat = lapPyramidFeats(img);
    feat =[feat lFeat];
end