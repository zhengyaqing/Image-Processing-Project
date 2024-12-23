function ImageProcessingApp()
    % Main function to create the image processing GUI
    
    % Create the main figure
    fig = figure('Name', 'Advanced Image Processing Toolbox', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1200, 800], ...
                 'MenuBar', 'none', ...
                 'Toolbar', 'none');
    
    % Create main menu
    file_menu = uimenu(fig, 'Label', '文件');
    uimenu(file_menu, 'Label', '打开图片', 'Callback', @openImage);
    uimenu(file_menu, 'Label', '保存图片', 'Callback', @saveImage);
    uimenu(file_menu, 'Label', '取消', 'Callback', 'close');
    
    % Processing menus
    process_menu = uimenu(fig, 'Label', '直方图');
    uimenu(process_menu, 'Label', '灰度直方图', 'Callback', @showHistogram);
    uimenu(process_menu, 'Label', '直方图均衡化', 'Callback', @histogramEqualization);
    uimenu(process_menu, 'Label', '直方图匹配', 'Callback', @histogramMatching);
    
    process_menu = uimenu(fig, 'Label', '对比度增强');
    uimenu(process_menu, 'Label', '对比度增强', 'Callback', @contrastEnhancement);

    process_menu = uimenu(fig, 'Label', '几何变换');
    uimenu(process_menu, 'Label', '缩放图像', 'Callback', @scaleImage);
    uimenu(process_menu, 'Label', '图像旋转', 'Callback', @rotateImage);

    process_menu = uimenu(fig, 'Label', '图像加噪');
    uimenu(process_menu, 'Label', '添加噪声', 'Callback', @addNoiseToImage);
    
    filter_menu = uimenu(fig, 'Label', '滤波');
    uimenu(filter_menu, 'Label', '空域滤波', 'Callback', @applySpatialFilter);
    uimenu(filter_menu, 'Label', '频域滤波', 'Callback', @applyFrequencyFilter);

    
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
    axis(handles.original_axes, 'image');
    axis(handles.processed_axes, 'image');

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

% 显示原始图像的直方图函数
function showHistogram(hObject, ~)
    % 获取 GUI 中的句柄结构体
    handles = guidata(hObject);

    % 检查是否加载了原始图像
    if ~isempty(handles.original_image)
        % 确保图像为灰度图像
        if size(handles.original_image, 3) > 1
            % 如果是彩色图像，将其转换为灰度图像
            img = rgb2gray_custom(handles.original_image); % 自定义灰度转换函数
        else
            % 如果已经是灰度图像，直接使用
            img = handles.original_image;
        end
        % 使用自定义函数绘制直方图
        plotHistogramCustom(img);
    else
        % 如果未加载图像，弹出消息框提示用户
        msgbox('未加载图像，无法显示直方图！', '错误', 'error');
    end
end

% 直方图均衡化 
function histogramEqualization(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % 如果图像是彩色图像，转换为灰度图像
        if size(handles.original_image, 3) > 1
            input_img = rgb2gray(handles.original_image);
        else
            input_img = handles.original_image;
        end

        % 执行直方图均衡化
        processed_img = histeq(input_img);

        % 创建新窗口
        figure('Name', '直方图均衡化结果', 'NumberTitle', 'off', 'Position', [100, 100, 800, 400]);

        % 左侧显示均衡化后的图像
        subplot(1, 2, 1);
        imshow(processed_img);
        title('均衡化后的图像');

        % 右侧绘制均衡化后的直方图
        subplot(1, 2, 2);
        equalized_hist = imhist(processed_img);
        bar(0:255, equalized_hist, 'BarWidth', 1, 'FaceColor', [0.3, 0.3, 0.9]);
        title('均衡化后的直方图');
        xlabel('灰度值');
        ylabel('像素数量');
        grid on;

    else
        % 如果没有加载图像，弹出错误提示
        msgbox('未加载图像，无法进行直方图均衡化！', '错误', 'error');
    end
end



% 直方图匹配
function histogramMatching(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % 确保原始图像是灰度图像
        if size(handles.original_image, 3) > 1
            input_img = rgb2gray(handles.original_image);
        else
            input_img = handles.original_image;
        end
        
        % 提示用户选择参考图像
        [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'}, '选择参考图像');
        if filename ~= 0
            reference_img = imread(fullfile(pathname, filename));
            
            % 确保参考图像是灰度图像
            if size(reference_img, 3) > 1
                reference_img = rgb2gray(reference_img);
            end
            
            % 执行直方图匹配
            processed_img = histogramMatch(input_img, reference_img);

            % 创建新窗口显示对比结果
            figure('Name', '直方图匹配结果', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 800]);

            % 左上显示原始图像
            subplot(2, 3, 1);
            imshow(input_img);
            title('原始图像');

            % 右上显示原始图像的直方图
            subplot(2, 3, 2);
            input_hist = imhist(input_img);
            bar(0:255, input_hist, 'BarWidth', 1, 'FaceColor', [0.3, 0.7, 0.3]);
            title('原始图像的直方图');
            xlabel('灰度值');
            ylabel('像素数量');
            grid on;

            % 左下显示参考图像
            subplot(2, 3, 4);
            imshow(reference_img);
            title('参考图像');

            % 右下显示参考图像的直方图
            subplot(2, 3, 5);
            reference_hist = imhist(reference_img);
            bar(0:255, reference_hist, 'BarWidth', 1, 'FaceColor', [0.3, 0.4, 0.8]);
            title('参考图像的直方图');
            xlabel('灰度值');
            ylabel('像素数量');
            grid on;

            % 中间显示匹配后的图像
            subplot(2, 3, 3);
            imshow(processed_img);
            title('匹配后的图像');

            % 中间下方显示匹配后图像的直方图
            subplot(2, 3, 6);
            matched_hist = imhist(processed_img);
            bar(0:255, matched_hist, 'BarWidth', 1, 'FaceColor', [0.8, 0.5, 0.2]);
            title('匹配后图像的直方图');
            xlabel('灰度值');
            ylabel('像素数量');
            grid on;

        else
            msgbox('未选择参考图像！', '错误', 'error');
        end
    else
        msgbox('未加载原始图像！', '错误', 'error');
    end
end



%对比度增强
function contrastEnhancement(hObject, ~)
    handles = guidata(hObject);
    if ~isempty(handles.original_image)
        % Ensure the original image is in grayscale before processing
        if size(handles.original_image, 3) > 1
            handles.original_image = rgb2gray(handles.original_image);
        end

        % Create enhancement options dialog
        choice = questdlg('Select Contrast Enhancement Method', ...
            '对比度增强', ...
            '线性变换', '对数变换', '指数变换', '线性变换');
        
        switch choice
            case '线性变换'
                handles.processed_image = linearContrastStretch(handles.original_image);
            case '对数变换'
                handles.processed_image = logarithmicTransform(handles.original_image);
            case '指数变换'
                handles.processed_image = exponentialTransform(handles.original_image);
            otherwise
                return;
        end
        
        imshow(handles.processed_image, 'Parent', handles.processed_axes);
        guidata(hObject, handles);
    end
end

%Scale Image
function scaleImage(hObject, ~)
    handles = guidata(hObject);

    if ~isempty(handles.original_image)
        % 弹出对话框获取缩放比例
        prompt = {'请输入缩放比例（>0）:'};
        dlg_title = '图像缩放';
        dims = [1 50];
        def_input = {'1.5'};
        answer = inputdlg(prompt, dlg_title, dims, def_input);

        if ~isempty(answer)
            scale_factor = str2double(answer{1});

            if isnan(scale_factor) || scale_factor <= 0
                msgbox('缩放比例必须为正数！', '错误', 'error');
                return;
            end

            % 调用 imageScaling 函数
            scaled_image = imageScaling(handles.original_image, scale_factor);

            % 调试信息输出
            %disp(['Original Size: ', mat2str(size(handles.original_image))]);
            %disp(['Scaled Size: ', mat2str(size(scaled_image))]);

            % 弹出窗口显示原图
            figure('Name', 'Original Image');
            imshow(handles.original_image);
            title('原图');

            % 弹出窗口显示缩放后的图像
            figure('Name', 'Scaled Image');
            imshow(scaled_image);
            title(['缩放后的图像 (比例: ', num2str(scale_factor), ')']);

            % 更新句柄数据
            handles.processed_image = scaled_image;
            guidata(hObject, handles);
        end
    else
        msgbox('请先加载图像！', '错误', 'error');
    end
end

%Rotate Image
function rotateImage(hObject, ~)
    handles = guidata(hObject);

    if ~isempty(handles.original_image)
        % Prompt user for rotation angle
        prompt = {'请输入旋转角度（正负均可）:'};
        dlg_title = '图像旋转';
        dims = [1 50];
        def_input = {'45'};
        answer = inputdlg(prompt, dlg_title, dims, def_input);

        if ~isempty(answer)
            angle = str2double(answer{1});

            if isnan(angle)
                msgbox('旋转角度必须是一个数字！', '错误', 'error');
                return;
            end

            % 调用自定义的 imageRotation 函数
            rotated_image = imageRotation(handles.original_image, angle);

            % 显示原图和旋转后的图像
            figure('Name', 'Image Rotation Results');
            subplot(1, 2, 1);
            imshow(handles.original_image);
            title('原图');

            subplot(1, 2, 2);
            imshow(rotated_image);
            title(['旋转后的图像 (角度: ', num2str(angle), '°)']);

            % 更新句柄数据
            handles.processed_image = rotated_image;
            guidata(hObject, handles);
        end
    else
        msgbox('请先加载图像！', '错误', 'error');
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