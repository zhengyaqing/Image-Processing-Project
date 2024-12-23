% 自定义绘制直方图函数
function plotHistogramCustom(img)
    % 确保图像是灰度图像
    img = double(img);

    % 初始化灰度值统计数组（0-255 共 256 个灰度值）
    grayLevels = 0:255;
    counts = zeros(1, 256);

    % 遍历图像，统计每个灰度值的像素数量
    [rows, cols] = size(img);
    for r = 1:rows
        for c = 1:cols
            grayValue = img(r, c); % 获取当前像素的灰度值
            counts(grayValue + 1) = counts(grayValue + 1) + 1; % 累加计数（+1 是因为 MATLAB 索引从 1 开始）
        end
    end

    % 绘制直方图
    figure;
    bar(grayLevels, counts, 'BarWidth', 1, 'FaceColor', [0.3, 0.3, 0.9]); % 使用 bar 函数绘制条形图
    title('灰度图像的直方图');
    xlabel('灰度值');
    ylabel('像素数量');
    grid on; % 显示网格
end