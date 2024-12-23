function output = spatialFilter(inputImage, filterType)
    % 空域滤波函数，支持中值滤波、均值滤波和高斯滤波
    % 确保输入图像为灰度图像，如果是彩色图像则转换为灰度图像
    if size(inputImage, 3) > 1
        inputImage = rgb2gray(inputImage); % 将彩色图像转为灰度图像
    end

    % 将输入图像转换为 double 类型，便于进行滤波操作
    inputImage = double(inputImage);
    
    % 获取图像的尺寸
    [rows, cols] = size(inputImage);

    % 根据滤波类型选择不同的滤波操作
    switch filterType
        case 'median'
            % 中值滤波：使用 3x3 的窗口进行中值滤波
            filtered_image = medianFilter(inputImage, 3, rows, cols);
            
        case 'mean'
            % 均值滤波：使用 3x3 的均值滤波核
            kernel = ones(3, 3) / 9;  % 3x3 核，元素值为 1/9
            filtered_image = meanFilter(inputImage, kernel, rows, cols);
            
        case 'gaussian'
            % 高斯滤波：使用 3x3 的高斯滤波核
            kernel = [1 2 1; 2 4 2; 1 2 1] / 16; % 高斯滤波核归一化
            filtered_image = meanFilter(inputImage, kernel, rows, cols);
            
        otherwise
            % 如果滤波类型不支持，则报错
            error('不支持的滤波类型');
    end

    % 将滤波结果归一化并转换为 uint8 格式，确保输出图像像素值在 0-255 范围内
    output = uint8(mat2gray(filtered_image) * 255);
end

% 中值滤波函数：对每个像素的邻域进行排序并取中位数
function output = medianFilter(inputImage, windowSize, rows, cols)
    % 输出图像初始化
    output = zeros(rows, cols);
    padSize = floor(windowSize / 2); % 窗口大小的一半，作为边界扩展
    
    % 对图像进行边界扩展，处理边缘像素
    paddedImage = padarray(inputImage, [padSize, padSize], 'replicate');
    
    % 对每个像素进行中值滤波
    for i = 1:rows
        for j = 1:cols
            % 获取当前像素邻域的 3x3 窗口
            window = paddedImage(i:i+windowSize-1, j:j+windowSize-1);
            % 对邻域窗口进行排序，并取中位数
            output(i,j) = median(window(:));
        end
    end
end

% 均值滤波函数：对每个像素的邻域进行均值计算
function output = meanFilter(inputImage, kernel, rows, cols)
    % 输出图像初始化
    output = zeros(rows, cols);
    padSize = floor(size(kernel, 1) / 2); % 根据核大小计算边界扩展
    
    % 对图像进行边界扩展，处理边缘像素
    paddedImage = padarray(inputImage, [padSize, padSize], 'replicate');
    
    % 对每个像素进行均值滤波
    for i = 1:rows
        for j = 1:cols
            % 获取当前像素邻域的窗口
            window = paddedImage(i:i+size(kernel,1)-1, j:j+size(kernel,2)-1);
            % 对邻域窗口和滤波核进行卷积运算
            output(i,j) = sum(sum(window .* kernel)); 
        end
    end
end
