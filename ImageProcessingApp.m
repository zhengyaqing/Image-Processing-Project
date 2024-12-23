function ImageProcessingApp()
    % Main function to create the image processing GUI
    
    % Create the main figure
    fig = figure('Name', 'Advanced Image Processing Toolbox', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1200, 800], ...
                 'MenuBar', 'none', ...
                 'Toolbar', 'none');
    
    % Create main menu
    file_menu = uimenu(fig, 'Label', 'File');
    uimenu(file_menu, 'Label', 'Open Image', 'Callback', @openImage);
    uimenu(file_menu, 'Label', 'Save Image', 'Callback', @saveImage);
    uimenu(file_menu, 'Label', 'Exit', 'Callback', 'close');
    
    % Processing menus
    process_menu = uimenu(fig, 'Label', 'Image Processing');
    uimenu(process_menu, 'Label', 'Histogram Equalization', 'Callback', @histogramEqualization);
    uimenu(process_menu, 'Label', 'Histogram Matching', 'Callback', @histogramMatching);
    uimenu(process_menu, 'Label', 'Show Histogram', 'Callback', @showHistogram);
    uimenu(process_menu, 'Label', 'Contrast Enhancement', 'Callback', @contrastEnhancement);
    uimenu(process_menu, 'Label', 'Geometric Transforms', 'Callback', @geometricTransforms);
    uimenu(process_menu, 'Label', 'Add Noise', 'Callback', @addNoiseToImage);
    
     % Filtering menu
    filter_menu = uimenu(fig, 'Label', 'Filtering');
    uimenu(filter_menu, 'Label', 'Spatial Filtering', 'Callback', @applySpatialFilter);
    uimenu(filter_menu, 'Label', 'Frequency Filtering', 'Callback', @applyFrequencyFilter);

    
    % Edge detection menu
    edge_menu = uimenu(fig, 'Label', 'Edge Detection');
    uimenu(edge_menu, 'Label', 'Compare Edge Operators', 'Callback', @compareEdges);
    uimenu(edge_menu, 'Label', 'Roberts Edge Detection', 'Callback', @robertsEdge);
    uimenu(edge_menu, 'Label', 'Prewitt Edge Detection', 'Callback', @prewittEdge);
    uimenu(edge_menu, 'Label', 'Sobel Edge Detection', 'Callback', @sobelEdge);
    uimenu(edge_menu, 'Label', 'Laplacian Edge Detection', 'Callback', @laplacianEdge);
    
    % Segmentation menu
    segmentation_menu = uimenu(fig, 'Label', 'Segmentation');
    uimenu(segmentation_menu, 'Label', 'Threshold Segmentation', 'Callback', @thresholdSegmentation);
    uimenu(segmentation_menu, 'Label', 'Connected Component Segmentation', 'Callback', @connectedComponentSeg);
    
    % Object Extraction menu
    object_menu = uimenu(fig, 'Label', 'Object Extraction');
    uimenu(object_menu, 'Label', 'Extract Object', 'Callback', @extractObject);

    % Feature extraction menu
    feature_menu = uimenu(fig, 'Label', 'Feature Extraction');
    uimenu(feature_menu, 'Label', 'LBP Features', 'Callback', @extractLBPFeatures);
    uimenu(feature_menu, 'Label', 'HOG Features', 'Callback', @extractHOGFeatures);
    uimenu(feature_menu, 'Label', 'Combined Features', 'Callback', @extractAllImageFeatures);
    

    % Image display axes
    handles.original_axes = axes('Parent', fig, 'Position', [0.1 0.1 0.4 0.8]);
    handles.processed_axes = axes('Parent', fig, 'Position', [0.55 0.1 0.4 0.8]);
    
    % Store global variables
    handles.original_image = [];
    handles.processed_image = [];
    handles.noisy_image = []; % For storing the noisy image

    % Store handles in figure's application data
    guidata(fig, handles);
end

% Callback functions
function openImage(hObject, ~)
    handles = guidata(hObject);
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
    if filename ~= 0
        full_path = fullfile(pathname, filename);
        handles.original_image = imread(full_path);
        imshow(handles.original_image, 'Parent', handles.original_axes);
        guidata(hObject, handles);
    end
end

function saveImage(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.processed_image)
        [filename, pathname] = uiputfile({'*.jpg', 'JPEG file';...
                                          '*.png', 'PNG file';...
                                          '*.bmp', 'BMP file'});
        if filename ~= 0
            full_path = fullfile(pathname, filename);
            imwrite(handles.processed_image, full_path);
        end
    else
        msgbox('No processed image to save!', 'Error', 'error');
    end
end

% Show Histogram of Original Image
function showHistogram(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Ensure the image is in grayscale
        if size(handles.original_image, 3) > 1
            % Convert to grayscale if it's a color image
            img = rgb2gray(handles.original_image);
        else
            img = handles.original_image;
        end
        % Call the plotHistogram function
        plotHistogram(img);
    else
        msgbox('No image loaded to show histogram!', 'Error', 'error');
    end
end

% Plot Histogram Function
function plotHistogram(img)
    % Plot histogram of grayscale image
    figure;
    subplot(2,1,1);
    imshow(img);
    title('Original Image');
    
    subplot(2,1,2);
    histogram(img, 256, 'Normalization', 'probability');
    title('Histogram');
    xlabel('Pixel Intensity');
    ylabel('Probability');
end


% Histogram Equalization
function histogramEqualization(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Perform histogram equalization
        handles.processed_image = histeq(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

% Histogram Matching
function histogramMatching(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Ensure the original image is in grayscale
        if size(handles.original_image, 3) > 1
            handles.original_image = rgb2gray(handles.original_image);
        end
        
        % Ask for a reference image
        [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
        if filename ~= 0
            reference_img = imread(fullfile(pathname, filename));
            
            % Ensure the reference image is in grayscale
            if size(reference_img, 3) > 1
                reference_img = rgb2gray(reference_img);
            end
            
            % Perform histogram matching
            handles.processed_image = histogramMatch(handles.original_image, reference_img);
            imshow(handles.processed_image, 'Parent', handles.processed_axes);
            guidata(hObject, handles);
        end
    end
end



% Contrast Enhancement 
function contrastEnhancement(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Ensure the original image is in grayscale before processing
        if size(handles.original_image, 3) > 1
            handles.original_image = rgb2gray(handles.original_image);
        end

        % Create enhancement options dialog
        choice = questdlg('Select Contrast Enhancement Method', ...
            'Contrast Enhancement', ...
            'Linear Stretch', 'Logarithmic', 'Exponential', 'Linear Stretch');
        
        switch choice
            case 'Linear Stretch'
                handles.processed_image = linearContrastStretch(handles.original_image);
            case 'Logarithmic'
                handles.processed_image = logarithmicTransform(handles.original_image);
            case 'Exponential'
                handles.processed_image = exponentialTransform(handles.original_image);
            otherwise
                return;
        end
        
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end
%GeometricTransforms
function geometricTransforms(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Create a new figure for transform controls with edit boxes instead of sliders
        control_fig = figure('Name', 'Transform Controls', ...
                           'Position', [300, 300, 300, 200], ...
                           'NumberTitle', 'off', ...
                           'MenuBar', 'none');
        
        % Add rotation input
        uicontrol('Parent', control_fig, ...
                 'Style', 'text', ...
                 'Position', [20, 160, 100, 20], ...
                 'String', 'Rotation Angle:');
        
        rotation_edit = uicontrol('Parent', control_fig, ...
                                'Style', 'edit', ...
                                'Position', [130, 160, 60, 20], ...
                                'String', '0', ...
                                'Callback', @updateTransform);
        
        uicontrol('Parent', control_fig, ...
                 'Style', 'text', ...
                 'Position', [195, 160, 20, 20], ...
                 'String', '°');
        
        % Add scale input
        uicontrol('Parent', control_fig, ...
                 'Style', 'text', ...
                 'Position', [20, 120, 100, 20], ...
                 'String', 'Scale Factor:');
        
        scale_edit = uicontrol('Parent', control_fig, ...
                              'Style', 'edit', ...
                              'Position', [130, 120, 60, 20], ...
                              'String', '1.0', ...
                              'Callback', @updateTransform);
        
        uicontrol('Parent', control_fig, ...
                 'Style', 'text', ...
                 'Position', [195, 120, 20, 20], ...
                 'String', 'x');
        
        % Add Apply button
        uicontrol('Parent', control_fig, ...
                 'Style', 'pushbutton', ...
                 'Position', [20, 70, 100, 30], ...
                 'String', 'Apply', ...
                 'Callback', @updateTransform);
        
        % Add Reset button
        uicontrol('Parent', control_fig, ...
                 'Style', 'pushbutton', ...
                 'Position', [130, 70, 100, 30], ...
                 'String', 'Reset', ...
                 'Callback', @resetTransforms);
        
        % Store handles and original image
        setappdata(control_fig, 'handles', handles);
        setappdata(control_fig, 'original_image', handles.original_image);
        setappdata(control_fig, 'rotation_edit', rotation_edit);
        setappdata(control_fig, 'scale_edit', scale_edit);
        
        % Initial transform
        updateTransform();
    end
    
    % Nested functions
    function updateTransform(~, ~)
        try
            local_handles = getappdata(control_fig, 'handles');
            orig_img = getappdata(control_fig, 'original_image');
            
            % Get values from edit boxes
            angle = str2double(get(getappdata(control_fig, 'rotation_edit'), 'String'));
            scale = str2double(get(getappdata(control_fig, 'scale_edit'), 'String'));
            
            % Validate inputs
            if isnan(angle) || isnan(scale)
                errordlg('Please enter valid numbers', 'Input Error');
                return;
            end
            
            if scale <= 0
                errordlg('Scale factor must be positive', 'Input Error');
                return;
            end
            
            % Apply transformations
            scaled_img = imageScaling(orig_img, scale);
            transformed_img = imageRotation(scaled_img, angle);
            
            % Update display
            axes(local_handles.processed_axes);
            imshow(transformed_img);
            
            % Store processed image
            local_handles.processed_image = transformed_img;
            guidata(hObject, local_handles);
        catch e
            errordlg(['Error: ' e.message], 'Transform Error');
        end
    end
    
    function resetTransforms(~, ~)
        set(getappdata(control_fig, 'rotation_edit'), 'String', '0');
        set(getappdata(control_fig, 'scale_edit'), 'String', '1.0');
        updateTransform();
    end
end


% Add Noise Function
function addNoiseToImage(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Select noise type and level
        choice = questdlg('Select Noise Type', ...
            'Add Noise', ...
            'Gaussian', 'Salt & Pepper', 'Speckle', 'Gaussian');
        prompt = {'Enter noise level (default: 0.05):'};
        answer = inputdlg(prompt, 'Noise Level', 1, {'0.05'});
        noise_level = str2double(answer{1});
        if isnan(noise_level) || noise_level <= 0
            noise_level = 0.05; % Default value
        end
        
        % Apply noise
        handles.noisy_image = addNoise(handles.original_image, choice, noise_level);
        imshow(handles.noisy_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    else
        msgbox('Please load an image first!', 'Error', 'error');
    end
end

function applySpatialFilter(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.noisy_image)
        % Select filter type
        choice = questdlg('Select Spatial Filter', ...
            'Spatial Filtering', ...
            'Median', 'Mean', 'Gaussian', 'Median');

        % Map filter type to lowercase
        filterType = lower(choice);

        % Apply spatial filter
        handles.processed_image = spatialFilter(handles.noisy_image, filterType);

        % Display the processed image
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    else
        msgbox('Please add noise to the image first!', 'Error', 'error');
    end
end





% Frequency Filtering
function applyFrequencyFilter(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.noisy_image)
        % Select filter type
        choice = questdlg('Select Frequency Filter', ...
            'Frequency Filtering', ...
            'Lowpass', 'Highpass', 'Lowpass');
        handles.processed_image = frequencyFilter(handles.noisy_image, lower(choice));
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    else
        msgbox('Please add noise to the image first!', 'Error', 'error');
    end
end

% Edge Detection Callbacks
function compareEdges(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        [~, ~] = compareEdgeDetection(handles.original_image);
    end
end

function robertsEdge(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        handles.processed_image = robertsEdgeDetection(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

function prewittEdge(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        handles.processed_image = prewittEdgeDetection(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

function sobelEdge(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        handles.processed_image = sobelEdgeDetection(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

function laplacianEdge(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        handles.processed_image = laplacianEdgeDetection(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

% Segmentation Callbacks
function thresholdSegmentation(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        [handles.processed_image, binary_mask] = simpleThresholdSegmentation(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

function connectedComponentSeg(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        [handles.processed_image, ~] = connectedComponentSegmentation(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end



%object extraction
function extractObject(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Perform object extraction and feature extraction
        [extracted_img, mask, lbp_img, hog_img] = objectExtraction(handles.original_image);
        
        % Display extracted object
        imshow(extracted_img, 'Parent', handles.processed_axes);
        
        % Store results in handles
        handles.processed_image = extracted_img;
        handles.lbp_image = lbp_img;
        handles.hog_image = hog_img;
        guidata(hObject, handles);
        
        % Optionally show additional features
        figure('Name', 'Feature Extraction Results');
        subplot(1,2,1); imshow(lbp_img); title('LBP Features');
        subplot(1,2,2); imshow(hog_img); title('HOG Features');
    else
        msgbox('Please load an image first!', 'Error', 'error');
    end
end


% Feature Extraction
function extractLBPFeatures(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Call LBP function to get LBP image
        lbp_image = computeLBP(handles.original_image);
        
        % Display the LBP image
        imshow(lbp_image, 'Parent', handles.processed_axes);
        
        % Store the processed image
        handles.processed_image = lbp_image;
        guidata(hObject, handles);
    else
        msgbox('Please load an image first!', 'Error', 'error');
    end
end


function extractHOGFeatures(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Call HOG function to get HOG image
        hog_image = computeHOG(handles.original_image);
        
        % Display the HOG image
        imshow(hog_image, 'Parent', handles.processed_axes);
        
        % Store the processed image
        handles.processed_image = hog_image;
        guidata(hObject, handles);
    else
        msgbox('Please load an image first!', 'Error', 'error');
    end
end


function extractAllImageFeatures(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        extractAllFeatures(handles.original_image);
    end
end