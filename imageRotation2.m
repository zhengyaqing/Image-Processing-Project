function rotated_img = imageRotation(input_img, angle)
    % Custom Image Rotation Function (no built-in affine transformation)
    if nargin < 2
        angle = 0; % Default angle
    end

    % Convert angle to radians
    angle_rad = deg2rad(angle);

    % Get input image size
    [rows, cols, channels] = size(input_img);

    % Calculate rotation matrix
    R = [cos(angle_rad), -sin(angle_rad); sin(angle_rad), cos(angle_rad)];

    % Find center of the image
    center = [rows / 2, cols / 2];

    % Initialize rotated image
    rotated_img = zeros(rows, cols, channels, 'like', input_img);

    % Iterate through each pixel in the output image
    for r = 1:rows
        for c = 1:cols
            % Map output pixel to input coordinates
            coords = R \ ([r; c] - center');
            orig_coords = coords + center';

            % Ensure coordinates are within bounds
            orig_r = min(max(orig_coords(1), 1), rows);
            orig_c = min(max(orig_coords(2), 1), cols);

            % Use nearest neighbor interpolation
            rotated_img(r, c, :) = input_img(round(orig_r), round(orig_c), :);
        end
    end
end