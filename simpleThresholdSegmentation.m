function [segmented_img, binary_mask] = simpleThresholdSegmentation(input_img)
    % Simple thresholding-based segmentation
    if size(input_img, 3) > 1
        gray_img = rgb2gray(input_img);
    else
        gray_img = input_img;
    end
    
    % Otsu's thresholding method
    threshold = graythresh(gray_img);
    binary_mask = imbinarize(gray_img, threshold);
    
    % Create segmented image
    segmented_img = input_img;
    for i = 1:size(input_img, 3)
        channel = input_img(:,:,i);
        channel(~binary_mask) = 0;
        segmented_img(:,:,i) = channel;
    end
end
