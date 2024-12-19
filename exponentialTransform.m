function enhanced_img = exponentialTransform(input_img, gamma)
    % Exponential (Power-Law) Transformation
    if nargin < 2
        gamma = 1.5; % Default gamma value
    end
    
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % Ensure grayscale image
    end
    
    % Convert to double and normalize
    input_img = im2double(input_img);
    
    % Apply power-law transformation
    enhanced_img = input_img.^gamma;
    enhanced_img = uint8(enhanced_img * 255);  % Convert back to uint8
end