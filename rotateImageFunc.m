% rotateImageFunc.m
function rotatedImage = rotateImageFunc(inputImage, angle)
    % 输入参数检查
    if ~exist('inputImage', 'var') || isempty(inputImage)
        error('请提供输入图像');
    end
    if ~exist('angle', 'var') || isempty(angle)
        angle = 0;
    end
    
    % 执行图像旋转
    try
        rotatedImage = imrotate(inputImage, angle, 'bilinear', 'crop');
    catch ME
        error('图像旋转失败: %s', ME.message);
    end
end