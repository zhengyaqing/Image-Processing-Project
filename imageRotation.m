function transformed_img = imageRotation(input_img, angle)
    if nargin < 2
        angle = 45; % 默认旋转角度为 45 度
    end
    
    % 获取输入图像的大小
    [rows, cols, ~] = size(input_img);

    % 计算图像的中心坐标
    cx = cols / 2;
    cy = rows / 2;

    % 根据旋转后的边界计算新的输出图像大小
    theta = deg2rad(angle); % 将角度转换为弧度
    new_width = ceil(abs(rows * sin(theta)) + abs(cols * cos(theta))); % 旋转后的新宽度
    new_height = ceil(abs(rows * cos(theta)) + abs(cols * sin(theta))); % 旋转后的新高度

    % 准备输出图像，初始化为零矩阵
    transformed_img = zeros(new_height, new_width, size(input_img, 3), 'like', input_img);

    % 计算旋转后的图像需要的偏移量，以确保图像居中
    offset_x = ceil((new_width - cols) / 2); % 水平偏移量
    offset_y = ceil((new_height - rows) / 2); % 垂直偏移量

    % 遍历输出图像的每个像素位置
    for y = 1:new_height
        for x = 1:new_width
            % 将输出图像坐标映射回原始图像的坐标
            x_prime = (x - offset_x - cx) * cos(theta) + (y - offset_y - cy) * sin(theta) + cx;
            y_prime = -(x - offset_x - cx) * sin(theta) + (y - offset_y - cy) * cos(theta) + cy;

            % 检查映射后的坐标是否在原始图像的范围内
            if x_prime >= 1 && x_prime <= cols && y_prime >= 1 && y_prime <= rows
                % 使用最近邻插值方法来获取像素值
                x_nn = round(x_prime); % 将映射坐标四舍五入为整数
                y_nn = round(y_prime);
                transformed_img(y, x, :) = input_img(y_nn, x_nn, :); % 将像素值赋值到输出图像
            end
        end
    end
end
