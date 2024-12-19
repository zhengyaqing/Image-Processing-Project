function [hist_eq_img, hist_match_img] = processHistogram(input_img, reference_img)
    % Process Histogram (Histogram Equalization and Histogram Matching)

    % Convert to grayscale if input image is RGB
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    
    % Histogram Equalization
    hist_eq_img = histeq(input_img); % Perform histogram equalization

    % Histogram Matching (if reference image provided)
    if nargin > 1
        % Convert reference image to grayscale if necessary
        if size(reference_img, 3) > 1
            reference_img = rgb2gray(reference_img);
        end
        % Perform histogram matching
        hist_match_img = histogramMatch(input_img, reference_img);
    else
        hist_match_img = [];
    end
end

% Custom Histogram Matching Function
function output_img = histogramMatch(input_img, reference_img)
    % Ensure both input images are of type uint8
    input_img = uint8(input_img);
    reference_img = uint8(reference_img);

    % Compute the histograms of the input and reference images
    input_hist = imhist(input_img);
    reference_hist = imhist(reference_img);
    
    % Compute the cumulative distribution functions (CDFs)
    cdf_input = cumsum(input_hist) / numel(input_img);
    cdf_reference = cumsum(reference_hist) / numel(reference_img);
    
    % Create a mapping of input image intensities to reference image intensities
    mapping = zeros(256, 1);
    for i = 1:256
        [~, idx] = min(abs(cdf_input(i) - cdf_reference)); % Find the closest match
        mapping(i) = idx - 1; % Map input intensity to reference intensity
    end
    
    % Apply the mapping to the input image
    output_img = uint8(mapping(double(input_img) + 1));
end
