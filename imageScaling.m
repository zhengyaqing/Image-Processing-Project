function transformed_img = imageScaling(input_img, scale_factor)
    % Custom Image Scaling Function (no built-in affine transformation)

    if nargin < 2
        scale_factor = 1.5; % Default scale factor
    end

    % Get input image size
    [rows, cols, channels] = size(input_img);

    % Calculate new dimensions
    new_rows = round(rows * scale_factor);
    new_cols = round(cols * scale_factor);

    % Initialize transformed image
    transformed_img = zeros(new_rows, new_cols, channels, 'like', input_img);

    % Mapping from output to input coordinates
    for r = 1:new_rows
        for c = 1:new_cols
            % Find the corresponding source coordinates
            orig_r = (r - 0.5) / scale_factor + 0.5;
            orig_c = (c - 0.5) / scale_factor + 0.5;

            % Ensure coordinates are within bounds
            orig_r = max(min(orig_r, rows), 1);
            orig_c = max(min(orig_c, cols), 1);

            % Nearest-neighbor interpolation
            transformed_img(r, c, :) = input_img(round(orig_r), round(orig_c), :);
        end
    end
end
