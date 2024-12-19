function [edge_img, combined_edges] = compareEdgeDetection(input_img)
    % Ensure input image is grayscale
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    
    % Perform edge detection with different operators
    roberts_edges = robertsEdgeDetection(input_img);
    prewitt_edges = prewittEdgeDetection(input_img);
    sobel_edges = sobelEdgeDetection(input_img);
    laplacian_edges = laplacianEdgeDetection(input_img);
    
    % Combine edges for comparison
    combined_edges = figure;
    subplot(2,3,1);
    imshow(input_img);
    title('Original Image');
    
    subplot(2,3,2);
    imshow(roberts_edges);
    title('Roberts Edge Detection');
    
    subplot(2,3,3);
    imshow(prewitt_edges);
    title('Prewitt Edge Detection');
    
    subplot(2,3,4);
    imshow(sobel_edges);
    title('Sobel Edge Detection');
    
    subplot(2,3,5);
    imshow(laplacian_edges);
    title('Laplacian Edge Detection');
    
    % Return the Sobel edges as default edge image
    edge_img = sobel_edges;
end
