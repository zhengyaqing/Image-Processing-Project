function output = frequencyFilter(inputImage, filterType)
    % Ensure input image is grayscale
    if size(inputImage, 3) > 1
        inputImage = rgb2gray(inputImage);
    end
    
    % Transform to frequency domain
    inputImage = double(inputImage);
    fftImage = fft2(inputImage);
    fftImage = fftshift(fftImage);
    
    % Create filter
    [rows, cols] = size(inputImage);
    [x, y] = meshgrid(1:cols, 1:rows);
    centerX = cols / 2;
    centerY = rows / 2;
    radius = sqrt((x - centerX).^2 + (y - centerY).^2);
    
    switch filterType
        case 'low-pass'
            H = double(radius <= min(rows, cols) * 0.2);
        case 'high-pass'
            H = double(radius >= min(rows, cols) * 0.2);
        otherwise
            error('Unknown filter type');
    end
    
    % Apply filter in frequency domain
    filteredFFT = fftImage .* H;
    
    % Transform back to spatial domain
    filteredFFT = ifftshift(filteredFFT);
    output = abs(ifft2(filteredFFT));
    output = uint8(output);
end
