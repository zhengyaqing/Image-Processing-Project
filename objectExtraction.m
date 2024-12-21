% objectExtraction.m
function [extracted_img, mask] = objectExtraction(input_img)
    % Object extraction using multiple image processing techniques
    % Parameters:
    %   input_img - Input image (RGB or grayscale)
    % Returns:
    %   extracted_img - Image with extracted object
    %   mask - Binary mask of the extracted object
    
    % Convert to grayscale if needed
    if size(input_img, 3) > 1
        gray_img = rgb2gray(input_img);
    else
        gray_img = input_img;
    end
    
    % Step 1: Enhance contrast for better segmentation
    enhanced_img = imadjust(gray_img);
    
    % Step 2: Apply Gaussian filter to reduce noise
    smoothed_img = imgaussfilt(enhanced_img, 1.5);
    
    % Step 3: Edge detection using Sobel
    [~, threshold] = edge(smoothed_img, 'sobel');
    edge_img = edge(smoothed_img, 'sobel', threshold * 0.7);
    
    % Step 4: Morphological operations to connect edges
    se = strel('disk', 2);
    closed_img = imclose(edge_img, se);
    
    % Step 5: Fill holes in the binary image
    filled_img = imfill(closed_img, 'holes');
    
    % Step 6: Remove small objects
    cleaned_img = bwareaopen(filled_img, 100);
    
    % Step 7: Get the largest connected component
    cc = bwconncomp(cleaned_img);
    stats = regionprops(cc, 'Area');
    [~, idx] = max([stats.Area]);
    mask = false(size(cleaned_img));
    mask(cc.PixelIdxList{idx}) = true;
    
    % Create output image
    extracted_img = input_img;
    for i = 1:size(input_img, 3)
        channel = input_img(:,:,i);
        channel(~mask) = 0;
        extracted_img(:,:,i) = channel;
    end
    
    % Visualize results
    figure('Name', 'Object Extraction Results');
    subplot(2,3,1); imshow(input_img); title('Original Image');
    subplot(2,3,2); imshow(enhanced_img); title('Enhanced Image');
    subplot(2,3,3); imshow(edge_img); title('Edge Detection');
    subplot(2,3,4); imshow(filled_img); title('Filled Image');
    subplot(2,3,5); imshow(mask); title('Final Mask');
    subplot(2,3,6); imshow(extracted_img); title('Extracted Object');
end