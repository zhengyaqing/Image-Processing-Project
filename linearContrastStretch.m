function enhanced_img = linearContrastStretch(input_img)
    % 自定义函数实现线性对比度拉伸

    % 如果输入图像是 RGB 图像，将其转换为灰度图像
    if size(input_img, 3) > 1
        input_img = rgb2gray_custom(input_img);
    end

    % 将图像转换为 double 类型以便进行计算
    input_img = double(input_img);

    % 获取图像中最小值和最大值
    min_val = min(input_img(:));
    max_val = max(input_img(:));

    % 计算线性拉伸公式：new_pixel = (pixel - min_val) / (max_val - min_val) * 255
    enhanced_img = (input_img - min_val) / (max_val - min_val) * 255;

    % 将图像转换回 uint8 类型
    enhanced_img = uint8(enhanced_img);
end
