function edge_img = sobelEdgeDetection(input_img)
    % 如果输入图像是彩色图像，则转换为灰度图像
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);  % 转换为灰度图像
    end
    
    % 定义Sobel算子内核
    Gx = [-1 0 1; -2 0 2; -1 0 1];  % 水平方向的Sobel算子
    Gy = [-1 -2 -1; 0 0 0; 1 2 1];  % 垂直方向的Sobel算子
    
    % 使用卷积操作将图像与Gx和Gy算子进行卷积，计算图像的梯度
    Ix = conv2(double(input_img), Gx, 'same');  % 计算水平方向的梯度
    Iy = conv2(double(input_img), Gy, 'same');  % 计算垂直方向的梯度
    
    % 计算梯度的幅值
    edge_img = sqrt(Ix.^2 + Iy.^2);  % 使用勾股定理计算梯度幅值
    
    % 将边缘图像的值归一化到[0, 255]范围内
    edge_img = uint8(255 * mat2gray(edge_img));  % 归一化并转换为uint8类型
end
