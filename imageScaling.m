function transformed_img = imageScaling(input_img, scale_factor)
    % 自定义图像缩放函数，使用双线性插值
    if nargin < 2
        scale_factor = 1.5; % 默认缩放比例
    end

    if scale_factor <= 0
        error('缩放比例必须为正数');
    end

    % 获取输入图像尺寸
    [orig_h, orig_w, num_channels] = size(input_img);

    % 计算输出图像尺寸
    new_h = round(orig_h * scale_factor);
    new_w = round(orig_w * scale_factor);

    % 初始化输出图像
    transformed_img = zeros(new_h, new_w, num_channels, 'like', input_img);

    % 生成映射到原图的坐标
    row_scale = orig_h / new_h;
    col_scale = orig_w / new_w;

    % 遍历输出图像的每个像素
    for r = 1:new_h
        for c = 1:new_w
            % 映射到原图的浮点坐标
            orig_r = (r - 0.5) * row_scale + 0.5;
            orig_c = (c - 0.5) * col_scale + 0.5;

            % 找到原图四个最近邻点的整数坐标
            r1 = floor(orig_r);
            r2 = min(r1 + 1, orig_h);
            c1 = floor(orig_c);
            c2 = min(c1 + 1, orig_w);

            % 防止索引越界
            r1 = max(r1, 1);
            c1 = max(c1, 1);

            % 计算插值权重
            delta_r = orig_r - r1;
            delta_c = orig_c - c1;

            % 遍历每个通道
            for ch = 1:num_channels
                % 双线性插值
                transformed_img(r, c, ch) = ...
                    (1 - delta_r) * (1 - delta_c) * double(input_img(r1, c1, ch)) + ...
                    delta_r * (1 - delta_c) * double(input_img(r2, c1, ch)) + ...
                    (1 - delta_r) * delta_c * double(input_img(r1, c2, ch)) + ...
                    delta_r * delta_c * double(input_img(r2, c2, ch));
            end
        end
    end

    % 转换回输入图像类型
    transformed_img = cast(transformed_img, class(input_img));
end
