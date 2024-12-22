function scaledImage = scaleImageFunc(inputImage, scale)
    % 输入参数检查
    if ~exist('inputImage', 'var') || isempty(inputImage)
        error('请提供输入图像');
    end
    if ~exist('scale', 'var') || isempty(scale)
        scale = 1.0;
    end
    
    % 验证缩放比例
    if scale <= 0
        error('缩放比例必须大于0');
    end
    
    % 执行图像缩放
    try
        scaledImage = imresize(inputImage, scale);
    catch ME
        error('图像缩放失败: %s', ME.message);
    end
end