% 自定义灰度转换函数
function grayImg = rgb2gray_custom(rgbImg)
    % 提取 RGB 通道
    R = double(rgbImg(:, :, 1));
    G = double(rgbImg(:, :, 2));
    B = double(rgbImg(:, :, 3));
    % 按照加权公式计算灰度值
    grayImg = uint8(0.2989 * R + 0.5870 * G + 0.1140 * B);
end