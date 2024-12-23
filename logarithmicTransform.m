function enhanced_img = logarithmicTransform(input_img)
    % 对数变换
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % 如果输入为彩色图像，转换为灰度图像
    end
    
    % 转换为 double 类型，确保计算精度
    input_img = im2double(input_img);
    
    % 调用自定义的对数变换函数进行图像处理
    enhanced_img = myLogTransform(input_img);
    
    % 将结果缩放到 [0, 1] 范围，再转换为 uint8 格式
    enhanced_img = mat2gray(enhanced_img);  % 缩放像素值到 [0, 1] 范围
    enhanced_img = uint8(enhanced_img * 255);  % 将像素值映射到 [0, 255] 范围，并转换为 uint8 格式
end

% 自定义对数变换函数
function output_img = myLogTransform(input_img)
    % 计算归一化常数 c，用于调整图像亮度
    c = 1 / log(1 + max(input_img(:)));  % 计算归一化常数，确保对数变换后的图像亮度适当
    
    % 应用对数变换
    output_img = c * log(1 + input_img);  % 对图像进行对数变换
end
