function hog_features = computeHOG(input_img)
    % Histogram of Oriented Gradients (HOG) Feature Extraction
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    
    % Resize image to a standard size
    input_img = imresize(input_img, [128 128]);
    
    % Parameters for HOG
    cell_size = 16;
    block_size = 2;
    block_overlap = 1;
    num_bins = 9;
    
    % Compute HOG features
    [hog_features, vis] = extractHOGFeatures(input_img, ...
        'CellSize', [cell_size cell_size], ...
        'BlockSize', [block_size block_size], ...
        'BlockOverlap', [block_overlap block_overlap], ...
        'NumBins', num_bins);
    
    % Visualize HOG
    figure;
    subplot(1,2,1);
    imshow(input_img);
    title('Original Image');
    
    subplot(1,2,2);
    plot(vis);
    title('HOG Feature Visualization');
end