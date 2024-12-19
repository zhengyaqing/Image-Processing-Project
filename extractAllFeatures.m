function [combined_features] = extractAllFeatures(input_img)
    % Extract both LBP and HOG features
    lbp_features = computeLBP(input_img);
    hog_features = computeHOG(input_img);
    
    % Combine features (simple concatenation)
    combined_features = [lbp_features, hog_features];
    
    % Optional: Normalize features
    combined_features = (combined_features - mean(combined_features)) ./ std(combined_features);
end