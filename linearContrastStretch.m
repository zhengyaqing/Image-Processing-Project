function enhanced_img = linearContrastStretch(input_img)
    % Linear Contrast Stretching
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    
    % Find min and max pixel values
    min_val = double(min(input_img(:)));
    max_val = double(max(input_img(:)));
    
    % Perform linear stretching
    enhanced_img = imadjust(input_img, [min_val/255; max_val/255], [0; 1]);
end

