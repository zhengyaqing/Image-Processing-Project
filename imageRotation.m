function transformed_img = imageRotation(input_img, angle)
    % Image Rotation Function with full image display
    
    if nargin < 2
        angle = 45; % Default rotation angle in degrees
    end
    
    % Get the size of the input image
    [rows, cols, ~] = size(input_img);
    
    % Create the affine transformation matrix for rotation
    tform = affine2d([cosd(angle) -sind(angle) 0; 
                      sind(angle) cosd(angle) 0; 
                      0 0 1]);
    
    % Calculate the output image reference (bounding box after rotation)
    % We need to calculate the new bounds after rotation
    output_ref = imref2d([rows, cols]);
    
    % Rotate the image using `imwarp`, passing the new reference object
    transformed_img = imwarp(input_img, tform, 'OutputView', output_ref);
    
    % Display the transformed image
    imshow(transformed_img);
end
