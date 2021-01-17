function feat = friqueeHueSat(hsv)
    % Get the H and S components of the HSV color space.
    H = double(hsv(:,:,1));
    S = double(hsv(:,:,2));
    
    % Extract sample statistics such as mean and standard deviation of Hue
    % and Saturation maps.
    feat = [mean(H(:)) std(H(:)) mean(S(:)) std(S(:))];
end
