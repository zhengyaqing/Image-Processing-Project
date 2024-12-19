function edge_img = prewittEdgeDetection(input_img)
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % Convert to grayscale
    end
    
    % Define Prewitt kernels
    Gx = [-1 0 1; -1 0 1; -1 0 1];
    Gy = [-1 -1 -1; 0 0 0; 1 1 1];
    
    % Convolve the image with the kernels
    Ix = conv2(double(input_img), Gx, 'same');
    Iy = conv2(double(input_img), Gy, 'same');
    
    % Compute the magnitude of the gradient
    edge_img = sqrt(Ix.^2 + Iy.^2);
    
    % Normalize to range [0, 255]
    edge_img = uint8(255 * mat2gray(edge_img)); 
end
