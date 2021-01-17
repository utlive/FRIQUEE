%{ 
Author: Deepti Ghadiyaram

Description: Given an input RGB image, this method extracts the 564 FRIQUEE
features proposed in [1] in three different color spaces.

1. We first convert the given input image into different color spaces -
LAB, LMS, and HSI.

2. We then extract the required components from each of these color spaces
eg: Hue and Saturation components, M and S components.

3. We also compute the chroma map from the A and B components of the image
in LAB color space.

Input: a MXNX3 array upon reading any image.

Output: Features extracted in luminance, chroma, LMS color components of the
image.

Dependencies: This method depends on the following methods:
friqueeLuma.m
friqueeChroma.m
friqueeMS.m
lmsColorOpponentFeats.m
friqueeHueSat.m
Complex_DIIVINE_feature.m (borrowed from C-DIIVINE's release [2] 

Reference:
[1] D. Ghadiyaram and A.C. Bovik, "Perceptual Quality Prediction on Authentically Distorted Images Using a
Bag of Features Approach," http://arxiv.org/abs/1609.04757

[2] Y Zhang, AK Moorthy, DM Chandler, AC Bovik  C-DIIVINE: No-reference image quality assessment based on local magnitude and phase statistics of natural scenes
Signal Processing: Image Communication, 2014
http://vision.eng.shizuoka.ac.jp/mod/url/view.php?id=60 

%}

function friqueeFeats = extractFRIQUEEFeatures(rgb)
    addpath(genpath('../include/'));
    
    if(size(rgb,3) ~=3)
        error('The input to this method should be an MXNX3 array, obtained upon reading an image');
    end
    cDivFeats = [];
    
    % Convert the input RGB image to LMS color space.
    lms = convertRGBToLMS(rgb);

    % Convert the input RGB image to LAB color space.
    lab=convertRGBToLAB(rgb);
    
    % Convert the input RGB image to HSI color space.
    hsv = convertRGBToHSI(rgb);
    
    % Get the A and B components of the LAB color space.
    A = double(lab(:,:,2));
    B = double(lab(:,:,3));

    % Compute the chroma map.
    chroma = sqrt(A.*A + B.*B);
    
     % Get the M and S components from the LMS color space.
    LM = double(lms(:,:,2));
    LS = double(lms(:,:,3));
    
    %FRIQUEE features from the Luminance map.
    fLuma = friqueeLuma(rgb);
    
    %FRIQUEE features from the Chroma map.
    fChroma = friqueeChroma(chroma);

    %FRIQUEE features from the LMS color space.
    fM = friqueeMS(LM);
    fS = friqueeMS(LS);
    featOpp = lmsColorOpponentFeats(lms); % Color opponency features.
    fLMS = [fM fS featOpp];
    
    %FRIQUEE features from Hue and Saturation color maps.
    fHueSatFeats = friqueeHueSat(hsv);

    %%== EXTRACTING C-DIIVINE FEATURES ON LUMA, CHROMA, AND M AND S CHANNEL MAPS OF LMS COLOR SPACE.
    
    %C-DIIVINE features from Luminance.
    fLumaCdiv = Complex_DIIVINE_feature(double(rgb2gray(rgb)));
    cDivFeats =  [cDivFeats fLumaCdiv'];

    %C-DIIVINE features from Chroma map.
    fChromaCdiv = Complex_DIIVINE_feature(chroma);
    cDivFeats = [cDivFeats fChromaCdiv'];

    %C-DIIVINE features from M and S channels
    fMCDiv = Complex_DIIVINE_feature(lms(:,:,2));
    fSCDiv = Complex_DIIVINE_feature(lms(:,:,3));

    cDivFeats= [cDivFeats [fMCDiv' fSCDiv']];
    
    % Aggregating all the features.
    friqueeFeats.friqueeALL = [fLuma fChroma fLMS fHueSatFeats cDivFeats];
    friqueeFeats.friqueeLuma = [fLuma fLumaCdiv'];
    friqueeFeats.friqueeChroma = [fChroma fChromaCdiv'];
    friqueeFeats.friqueeLMS = [fLMS fHueSatFeats  [fMCDiv' fSCDiv']];
    friqueeFeats.cDivFeats = cDivFeats;
end