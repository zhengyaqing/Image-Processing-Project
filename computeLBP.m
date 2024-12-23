function lbp_image = computeLBP(input_img)
    % Local Binary Pattern (LBP) Feature Extraction
    % Returns the LBP image, not the histogram
    
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img); % Convert to grayscale if RGB
    end
    
    % Parameters for LBP
    radius = 1;
    neighbors = 8;

    % Ensure input image is double for computation
    input_img = im2double(input_img);
    
    % Pad the image to handle edges
    padded_img = padarray(input_img, [radius radius], 'symmetric');
    [rows, cols] = size(input_img);
    lbp_image = zeros(rows, cols); % Initialize the LBP image
    
    % Circular neighbors offsets
    angles = 2 * pi * (0:neighbors-1) / neighbors;
    offset_x = round(radius * cos(angles));
    offset_y = round(radius * sin(angles));

    % Compute LBP for each pixel
    for i = 1:rows
        for j = 1:cols
            center = padded_img(i + radius, j + radius);
            binary_pattern = zeros(1, neighbors);
            for k = 1:neighbors
                neighbor_value = padded_img(i + radius + offset_y(k), j + radius + offset_x(k));
                binary_pattern(k) = neighbor_value >= center;
            end
            % Convert binary pattern to decimal
            lbp_image(i, j) = sum(binary_pattern .* 2.^(0:neighbors-1));
        end
    end
    
    % Normalize the LBP image for display
    lbp_image = mat2gray(lbp_image);
    
    % Display the original and LBP image
    figure;
    subplot(1, 2, 1);
    imshow(input_img);
    title('Original Image');
    
    subplot(1, 2, 2);
    imshow(lbp_image);
    title('LBP Image');
end
