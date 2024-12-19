function transformed_img = imageScaling(input_img, scale_factor)
    % Image Scaling Function
    if nargin < 2
        scale_factor = 1.5; % Default scale factor
    end
    
    % Create affine transformation matrix
    tform = affine2d([scale_factor 0 0; 0 scale_factor 0; 0 0 1]);
    
    % Apply the transformation
    transformed_img = imwarp(input_img, tform, 'OutputView', imref2d(size(input_img)));
end
