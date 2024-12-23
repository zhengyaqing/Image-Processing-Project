function [hist_eq_img, hist_match_img] = processHistogram(input_img, reference_img)
    % 处理直方图，包括自定义的直方图均衡化和直方图匹配

    % 如果输入图像是 RGB 图像，则将其转换为灰度图像
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    
    % 使用自定义函数进行直方图均衡化
    hist_eq_img = customHisteq(input_img); 

    % 直方图匹配（如果提供了参考图像）
    if nargin > 1
        % 如果参考图像是 RGB 图像，则将其转换为灰度图像
        if size(reference_img, 3) > 1
            reference_img = rgb2gray(reference_img);
        end
        % 使用自定义函数进行直方图匹配
        hist_match_img = histogramMatch(input_img, reference_img);
    else
        hist_match_img = []; % 如果没有参考图像，返回空值
    end
end

% 自定义直方图均衡化函数
function output_img = customHisteq(input_img)
    % 将输入图像转换为 uint8 类型
    input_img = uint8(input_img);

    % 计算直方图
    hist_counts = imhist(input_img); % 每个灰度级的像素数量
    num_pixels = numel(input_img);   % 图像的总像素数
    
    % 计算累计分布函数（CDF）
    cdf = cumsum(hist_counts) / num_pixels;
    
    % 构建映射表：将每个灰度级映射到新的灰度级
    mapping = uint8(255 * cdf); 
    
    % 使用映射表对图像像素进行转换
    output_img = mapping(double(input_img) + 1);
end


