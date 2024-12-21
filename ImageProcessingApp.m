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

function geometricTransforms(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Create a new figure for transform controls
        control_fig = figure('Name', 'Transform Controls', ...
                           'Position', [300, 300, 400, 200], ...
                           'NumberTitle', 'off', ...
                           'MenuBar', 'none');
        
        % Add rotation slider
        uicontrol('Parent', control_fig, ...
                 'Style', 'text', ...
                 'Position', [20, 160, 100, 20], ...
                 'String', 'Rotation Angle:');
        
        rotation_slider = uicontrol('Parent', control_fig, ...
                                  'Style', 'slider', ...
                                  'Position', [130, 160, 200, 20], ...
                                  'Min', 0, 'Max', 360, ...
                                  'Value', 0, ...
                                  'SliderStep', [1/360, 10/360]);
        
        rotation_text = uicontrol('Parent', control_fig, ...
                                'Style', 'text', ...
                                'Position', [340, 160, 40, 20], ...
                                'String', '0°');
        
        % Add scale slider
        uicontrol('Parent', control_fig, ...
                 'Style', 'text', ...
                 'Position', [20, 120, 100, 20], ...
                 'String', 'Scale Factor:');
        
        scale_slider = uicontrol('Parent', control_fig, ...
                               'Style', 'slider', ...
                               'Position', [130, 120, 200, 20], ...
                               'Min', 0.1, 'Max', 3, ...
                               'Value', 1, ...
                               'SliderStep', [0.1/2.9, 0.5/2.9]);
        
        scale_text = uicontrol('Parent', control_fig, ...
                             'Style', 'text', ...
                             'Position', [340, 120, 40, 20], ...
                             'String', '1.0x');
        
        % Add reset button
        uicontrol('Parent', control_fig, ...
                 'Style', 'pushbutton', ...
                 'Position', [150, 20, 100, 30], ...
                 'String', 'Reset', ...
                 'Callback', @resetTransforms);
        
        % Store original image and handles
        setappdata(control_fig, 'handles', handles);
        setappdata(control_fig, 'original_image', handles.original_image);
    
        % Add listeners for continuous updates
        addlistener(rotation_slider, 'Value', 'PostSet', @updateTransform);
        addlistener(scale_slider, 'Value', 'PostSet', @updateTransform);
        
        % Initial transform
        updateTransform();
    end  % end if
    
    % Nested functions defined at end of main function
    function updateTransform(~, ~)
        local_handles = getappdata(control_fig, 'handles');
        orig_img = getappdata(control_fig, 'original_image');
    
        % Get current values
        angle = get(rotation_slider, 'Value');
        scale = get(scale_slider, 'Value');
    
        % Update text displays
        set(rotation_text, 'String', sprintf('%.1f°', angle));
        set(scale_text, 'String', sprintf('%.1fx', scale));
    
        % Apply custom scaling
        scaled_img = imageScaling(orig_img, scale);
    
        % Rotate image
        transformed_img = imageRotation(scaled_img, angle);
    
        % Update display
        imshow(transformed_img, 'Parent', local_handles.processed_axes);
    
        % Store processed image
        local_handles.processed_image = transformed_img;
        guidata(hObject, local_handles);
    end

    
    function resetTransforms(~, ~)
        set(rotation_slider, 'Value', 0);
        set(scale_slider, 'Value', 1);
        set(rotation_text, 'String', '0°');
        set(scale_text, 'String', '1.0x');
        updateTransform();
    end
end  % end main function



% Noise Addition
function addNoiseToImage(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % 创建噪声类型选择对话框
        choice = questdlg('Select Noise Type', ...
            'Add Noise', ...
            'Gaussian', 'Salt & Pepper', 'Speckle', 'Gaussian');
        
        switch choice
            case 'Gaussian'
                handles.processed_image = addNoise(handles.original_image, 'gaussian');
            case 'Salt & Pepper'
                handles.processed_image = addNoise(handles.original_image, 'salt & pepper');
            case 'Speckle'
                handles.processed_image = addNoise(handles.original_image, 'speckle');
            otherwise
                return;
        end
        
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
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

% Feature Extraction Callbacks
function extractLBPFeatures(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        computeLBP(handles.original_image);
    end
end

%object extraction
function extractObject(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        [handles.processed_image, mask] = objectExtraction(handles.original_image);
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    else
        msgbox('Please load an image first!', 'Error', 'error');
    end
end

function extractHOGFeatures(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        computeHOG(handles.original_image);
    end
end

function extractAllImageFeatures(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        extractAllFeatures(handles.original_image);
    end
end