function edge_img = laplacianEdgeDetection(input_img)
    % 如果输入图像是彩色图像，则转换为灰度图像
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % 转换为灰度图像
    end
    
    % 定义拉普拉斯算子（Laplacian）内核
    laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];  % 3x3 拉普拉斯算子
    
    % 使用卷积操作进行拉普拉斯边缘检测
    edge_img = conv2(double(input_img), laplacian_filter, 'same');  % 将图像与拉普拉斯算子卷积，检测边缘
    
    % 计算并归一化到[0, 255]范围
    edge_img = uint8(255 * mat2gray(abs(edge_img)));  % 计算绝对值后归一化到[0, 255]并转换为uint8类型
end
