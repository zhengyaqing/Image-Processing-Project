function lbp_features = computeLBP(input_img)
    % Local Binary Pattern (LBP) Feature Extraction
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    
    % Parameters for LBP
    radius = 1;
    neighbors = 8;
    
    % Convert image to double for computation
    input_img = im2double(input_img);
    
    % Compute LBP
    lbp_features = extractLBPFeatures(input_img, ...
        'Radius', radius, ...
        'NumNeighbors', neighbors);
    
    % Visualize LBP
    figure;
    subplot(1,2,1);
    imshow(input_img);
    title('Original Image');
    
    subplot(1,2,2);
    bar(lbp_features);
    title('LBP Feature Histogram');
end

