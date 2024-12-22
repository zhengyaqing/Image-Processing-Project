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
            orig_r = min(max((r - 0.5) / scale_factor + 0.5, 1), rows);
            orig_c = min(max((c - 0.5) / scale_factor + 0.5, 1), cols);

            % Use floor for rounding and avoid boundary overflow
            orig_r = floor(orig_r);
            orig_c = floor(orig_c);

            % Assign pixel value with nearest neighbor
            transformed_img(r, c, :) = input_img(orig_r, orig_c, :);
        end
    end
end