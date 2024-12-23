function output = frequencyFilter(inputImage, filterType) 
    % 确保输入图像是灰度图像，如果是彩色图像，则转换为灰度图像
    if size(inputImage, 3) > 1
        inputImage = rgb2gray(inputImage);  % 将彩色图像转为灰度图像
    end
    
    % 将输入图像转换为 double 类型以便进行傅里叶变换
    inputImage = double(inputImage);
    
    % 对输入图像进行傅里叶变换（二维傅里叶变换）
    fftImage = fft2(inputImage);  
    % 将频谱移到图像的中心
    fftImage = fftshift(fftImage);
    
    % 获取图像的行数和列数
    [rows, cols] = size(inputImage);
    % 生成网格坐标，用于计算每个像素到频谱中心的距离
    [x, y] = meshgrid(1:cols, 1:rows);
    centerX = cols / 2;  % 计算频谱的中心点X坐标
    centerY = rows / 2;  % 计算频谱的中心点Y坐标
    % 计算每个像素到频谱中心的距离（用于生成滤波器）
    radius = sqrt((x - centerX).^2 + (y - centerY).^2);
    
    % 根据滤波类型选择滤波器
    switch filterType
        case 'lowpass'
            % 低通滤波器：允许低频成分通过，阻止高频成分
            H = double(radius <= min(rows, cols) * 0.2);  % 半径小于阈值的部分为1（低频），其余为0（高频）
        case 'highpass'
            % 高通滤波器：允许高频成分通过，阻止低频成分
            H = double(radius >= min(rows, cols) * 0.05);  % 半径大于阈值的部分为1（高频），其余为0（低频）
        otherwise
            error('未知的滤波类型');  % 如果滤波类型不合法，抛出错误
    end
    
    % 在频域中应用滤波器
    filteredFFT = fftImage .* H;
    
    % 将频域图像移回原位置
    filteredFFT = ifftshift(filteredFFT);
    
    % 对频域图像进行逆傅里叶变换，得到滤波后的空间域图像
    output = abs(ifft2(filteredFFT));
    
    % 将输出图像转换为 uint8 格式，确保像素值在0到255之间
    output = uint8(output);
end
