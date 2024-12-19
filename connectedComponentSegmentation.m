function [segmented_img, labeled_regions] = connectedComponentSegmentation(input_img)
    % Segmentation using connected component analysis
    if size(input_img, 3) > 1
        gray_img = rgb2gray(input_img);
    else
        gray_img = input_img;
    end
    
    % Threshold and create binary image
    threshold = graythresh(gray_img);
    binary_img = imbinarize(gray_img, threshold);
    
    % Remove small noise regions
    cleaned_img = bwareaopen(binary_img, 100);
    
    % Label connected components
    [labeled_regions, num_regions] = bwlabel(cleaned_img);
    
    % Create segmented image with colored regions
    rgb_label = label2rgb(labeled_regions);
    
    % Overlay labeled regions on original image
    segmented_img = input_img;
    for i = 1:size(input_img, 3)
        channel = input_img(:,:,i);
        channel(~cleaned_img) = 0;
        segmented_img(:,:,i) = channel;
    end
    
    % Visualize results
    figure;
    subplot(2,2,1);
    imshow(input_img);
    title('Original Image');
    
    subplot(2,2,2);
    imshow(binary_img);
    title('Binary Image');
    
    subplot(2,2,3);
    imshow(rgb_label);
    title('Labeled Regions');
    
    subplot(2,2,4);
    imshow(segmented_img);
    title('Segmented Image');
end