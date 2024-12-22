function output = spatialFilter(inputImage, filterType)
    % Ensure input image is grayscale
    if size(inputImage, 3) > 1
        inputImage = rgb2gray(inputImage);
    end

    % Convert input image to double and normalize
    inputImage = double(inputImage);

    % Choose filter type
    switch filterType
        case 'median'
            % Median filter with 3x3 window
            filtered_image = medfilt2(inputImage, [3 3]);
        case 'mean'
            % Mean filter with 3x3 window
            kernel = ones(3, 3) / 9;
            filtered_image = conv2(inputImage, kernel, 'same');
        case 'gaussian'
            % Gaussian filter with 3x3 kernel
            kernel = [1 2 1; 2 4 2; 1 2 1] / 16;
            filtered_image = conv2(inputImage, kernel, 'same');
        otherwise
            error('Unsupported filter type');
    end

    % Normalize result and convert to uint8
    output = uint8(mat2gray(filtered_image) * 255);
end
