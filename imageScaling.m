function transformed_img = imageScaling(input_img, scale_factor)
    % Image scaling function using imresize
    % Parameters:
    %   input_img: Input image (can be grayscale or RGB)
    %   scale_factor: Scaling factor (>0)
    
    if nargin < 2
        scale_factor = 1.5; % Default scale factor
    end
    
    % Input validation
    if scale_factor <= 0
        error('Scale factor must be positive');
    end
    
    % Use imresize for reliable scaling
    transformed_img = imresize(input_img, scale_factor, 'bicubic');
end