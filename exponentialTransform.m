function enhanced_img = exponentialTransform(input_img, gamma)
    % 指数变换（幂律变换）
    if nargin < 2
        gamma = 1.5; % 默认的 gamma 值
    end
    
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % 如果输入图像为彩色图像，则转换为灰度图像
    end
    
    % 转换为 double 类型以便进行计算
    input_img = im2double(input_img);
    
    % 调用自定义指数变换函数
    enhanced_img = myExponentialTransform(input_img, gamma);
    
    % 将结果转换为 uint8 格式并缩放到 [0, 255] 范围
    enhanced_img = uint8(enhanced_img * 255);  % 将增强后的图像转换为 uint8 格式
end

% 自定义指数变换函数
function output_img = myExponentialTransform(input_img, gamma)
    % 应用指数变换（幂律变换）
    output_img = input_img .^ gamma;  % 对每个像素应用幂律变换
    
    % 对结果进行归一化，使其处于 [0, 1] 范围
    output_img = mat2gray(output_img);  % 将输出图像的像素值缩放到 [0, 1] 范围
end
