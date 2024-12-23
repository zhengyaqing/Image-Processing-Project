function output_img = histogramMatch(input_img, reference_img)
    % 确保输入和参考图像的类型为 uint8
    input_img = uint8(input_img);
    reference_img = uint8(reference_img);

    % 计算输入图像和参考图像的直方图
    input_hist = imhist(input_img);
    reference_hist = imhist(reference_img);

    % 计算输入图像和参考图像的累积分布函数（CDF）
    cdf_input = cumsum(input_hist) / numel(input_img);
    cdf_reference = cumsum(reference_hist) / numel(reference_img);

    % 创建映射关系：将输入图像的灰度值映射到参考图像
    mapping = zeros(256, 1);
    for i = 1:256
        [~, idx] = min(abs(cdf_input(i) - cdf_reference)); % 找到最接近的CDF值
        mapping(i) = idx - 1; % 映射到参考图像的灰度值
    end

    % 应用映射关系到输入图像
    output_img = uint8(mapping(double(input_img) + 1));
end