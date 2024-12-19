function noisy_img = addNoise(input_img, noise_type, noise_level)
    % Add different types of noise to the image
    if nargin < 3
        noise_level = 0.05; % Default noise level
    end
    
    if nargin < 2
        noise_type = 'gaussian'; % Default noise type
    end
    
    switch lower(noise_type)
        case 'gaussian'
            noisy_img = imnoise(input_img, 'gaussian', 0, noise_level);
        case 'salt & pepper'
            noisy_img = imnoise(input_img, 'salt & pepper', noise_level);
        case 'speckle'
            noisy_img = imnoise(input_img, 'speckle', noise_level);
        otherwise
            error('Unsupported noise type');
    end
end

function filtered_img = spatialFiltering(noisy_img, filter_type)
    % Spatial domain filtering
    if nargin < 2
        filter_type = 'median'; % Default filter
    end
    
    switch lower(filter_type)
        case 'median'
            filtered_img = medfilt2(noisy_img);
        case 'mean'
            h = fspecial('average', 3);
            filtered_img = imfilter(noisy_img, h);
        case 'gaussian'
            h = fspecial('gaussian', 3, 0.5);
            filtered_img = imfilter(noisy_img, h);
        otherwise
            error('Unsupported spatial filter');
    end
end

function filtered_img = frequencyFiltering(noisy_img, filter_type)
    % Frequency domain filtering
    % Convert image to frequency domain
    F = fft2(double(noisy_img));
    F_shifted = fftshift(F);
    
    % Create frequency domain filter
    [M, N] = size(F_shifted);
    [X, Y] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
    
    switch lower(filter_type)
        case 'lowpass'
            % Ideal low-pass filter
            D0 = 30; % Cutoff frequency
            filter = sqrt(X.^2 + Y.^2) <= D0;
        case 'highpass'
            % Ideal high-pass filter
            D0 = 30; % Cutoff frequency
            filter = sqrt(X.^2 + Y.^2) > D0;
        otherwise
            error('Unsupported frequency filter');
    end
    
    % Apply filter
    filtered_F = F_shifted .* filter;
    filtered_F_inv = ifftshift(filtered_F);
    
    % Convert back to spatial domain
    filtered_img = uint8(abs(ifft2(filtered_F_inv)));
end
