function enhanced_img = logarithmicTransform(input_img)
    % Logarithmic Transformation
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % Ensure grayscale image
    end
    
    % Convert to double for computation
    input_img = im2double(input_img);
    
    % Apply log transformation
    c = 1 / log(1 + max(input_img(:)));  % Normalize constant
    enhanced_img = c * log(1 + input_img);  % Apply log transform
    
    % Rescale the result to [0, 1] range, then convert to uint8
    enhanced_img = mat2gray(enhanced_img);  % Rescale to [0, 1]
    enhanced_img = uint8(enhanced_img * 255);  % Convert to uint8 format (0-255 range)
end
