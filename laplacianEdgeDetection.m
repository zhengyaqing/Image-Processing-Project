function edge_img = laplacianEdgeDetection(input_img)
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % Convert to grayscale
    end
    
    % Define Laplacian kernel
    laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];
    
    % Apply Laplacian edge detection
    edge_img = conv2(double(input_img), laplacian_filter, 'same');
    
    % Normalize to range [0, 255]
    edge_img = uint8(255 * mat2gray(abs(edge_img)));
end
