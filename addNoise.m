function noisy_img = addNoise(input_img, noise_type, noise_level) 
    % 向图像添加不同类型的噪声
    if nargin < 3
        noise_level = 0.05; % 默认噪声强度为 0.05
    end
    
    if nargin < 2
        noise_type = 'gaussian'; % 默认噪声类型为高斯噪声
    end
    
    % 根据噪声类型选择对应的噪声添加方法
    switch lower(noise_type)
        case 'gaussian'
            % 添加高斯噪声
            noisy_img = myAddGaussianNoise(input_img, noise_level);
        case 'salt & pepper'
            % 添加椒盐噪声
            noisy_img = myAddSaltPepperNoise(input_img, noise_level);
        case 'speckle'
            % 添加斑点噪声
            noisy_img = myAddSpeckleNoise(input_img, noise_level);
        otherwise
            error('不支持的噪声类型');
    end
end

% 自定义高斯噪声添加函数
function noisy_img = myAddGaussianNoise(input_img, noise_level)
    % 添加高斯噪声
    noisy_img = imnoise(input_img, 'gaussian', 0, noise_level);
end

% 自定义椒盐噪声添加函数
function noisy_img = myAddSaltPepperNoise(input_img, noise_level)
    % 添加椒盐噪声
    noisy_img = imnoise(input_img, 'salt & pepper', noise_level);
end

% 自定义斑点噪声添加函数
function noisy_img = myAddSpeckleNoise(input_img, noise_level)
    % 添加斑点噪声
    noisy_img = imnoise(input_img, 'speckle', noise_level);
end
