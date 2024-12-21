function transformed_img = imageRotation(input_img, angle)
    % Image Rotation Function with full image display around center
    
    if nargin < 2
        angle = 45; % Default rotation angle in degrees
    end
    
    % Get size of input image
    [rows, cols, ~] = size(input_img);
    
    % Calculate the center of the image
    cx = cols / 2;
    cy = rows / 2;
    
    % Create affine transformation matrix for rotation around the image center
    tform_translate1 = affine2d([1 0 0; 0 1 0; -cx -cy 1]); % Translate to origin
    tform_rotate = affine2d([cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1]); % Rotate
    tform_translate2 = affine2d([1 0 0; 0 1 0; cx cy 1]); % Translate back
    
    % Combine transformations
    tform_combined = affine2d(tform_translate1.T * tform_rotate.T * tform_translate2.T);
    
    % Calculate new output limits
    [xlim, ylim] = outputLimits(tform_combined, [1 cols], [1 rows]);
    width = ceil(max(xlim) - min(xlim));
    height = ceil(max(ylim) - min(ylim));
    
    % Create new output reference
    output_ref = imref2d([height, width]);
    
    % Apply rotation using `imwarp`
    transformed_img = imwarp(input_img, tform_combined, 'OutputView', output_ref);
end
