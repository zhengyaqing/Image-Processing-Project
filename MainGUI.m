% MainGUI.m
function MainGUI
    % 创建主窗口
    fig = figure('Name', '图像处理程序', ...
                'Position', [300 300 800 600], ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none');
    
    % 创建界面元素
    handles.axes1 = axes('Parent', fig, ...
                        'Position', [0.1 0.3 0.8 0.6]);
    
    % 创建按钮
    uicontrol('Style', 'pushbutton', ...
             'String', '打开图像', ...
             'Position', [50 50 100 30], ...
             'Callback', {@openImage, handles});  % 修改：传入handles
         
    handles.scalePanel = uipanel('Title', '缩放控制', ...
                                'Position', [0.1 0.1 0.25 0.15]);
    
    uicontrol('Parent', handles.scalePanel, ...
             'Style', 'text', ...
             'String', '缩放比例:', ...
             'Position', [10 30 60 20]);
         
    handles.scaleEdit = uicontrol('Parent', handles.scalePanel, ...
                                 'Style', 'edit', ...
                                 'String', '1.0', ...
                                 'Position', [80 30 40 20]);
                             
    uicontrol('Parent', handles.scalePanel, ...
             'Style', 'pushbutton', ...
             'String', '缩放', ...
             'Position', [130 30 50 20], ...
             'Callback', @scaleImageCallback);  % 修改：简化回调
         
    handles.rotatePanel = uipanel('Title', '旋转控制', ...
                                 'Position', [0.4 0.1 0.25 0.15]);
                             
    uicontrol('Parent', handles.rotatePanel, ...
             'Style', 'text', ...
             'String', '旋转角度:', ...
             'Position', [10 30 60 20]);
         
    handles.rotateEdit = uicontrol('Parent', handles.rotatePanel, ...
                                  'Style', 'edit', ...
                                  'String', '0', ...
                                  'Position', [80 30 40 20]);
                              
    uicontrol('Parent', handles.rotatePanel, ...
             'Style', 'pushbutton', ...
             'String', '旋转', ...
             'Position', [130 30 50 20], ...
             'Callback', @rotateImageCallback);  % 修改：简化回调
    
    % 保存handles到figure
    guidata(fig, handles);
end

% 打开图像回调函数
function openImage(hObject, ~, handles)
    % 获取当前figure的handles
    handles = guidata(gcf);
    
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', '图像文件 (*.jpg, *.png, *.bmp)'});
    if filename ~= 0
        handles.image = imread(fullfile(pathname, filename));
        axes(handles.axes1);
        imshow(handles.image);
        % 更新handles
        guidata(gcf, handles);
    end
end

% 缩放图像回调函数
function scaleImageCallback(hObject, ~)
    % 获取当前figure的handles
    handles = guidata(gcf);
    
    if isfield(handles, 'image')
        try
            scale = str2double(get(handles.scaleEdit, 'String'));
            % 调用外部缩放函数
            scaledImage = scaleImageFunc(handles.image, scale);
            axes(handles.axes1);
            imshow(scaledImage);
        catch ME
            msgbox(['缩放错误: ' ME.message], '错误', 'error');
        end
    else
        msgbox('请先打开图像！', '提示', 'warn');
    end
end

% 旋转图像回调函数
function rotateImageCallback(hObject, ~)
    % 获取当前figure的handles
    handles = guidata(gcf);
    
    if isfield(handles, 'image')
        try
            angle = str2double(get(handles.rotateEdit, 'String'));
            % 调用外部旋转函数
            rotatedImage = rotateImageFunc(handles.image, angle);
            axes(handles.axes1);
            imshow(rotatedImage);
        catch ME
            msgbox(['旋转错误: ' ME.message], '错误', 'error');
        end
    else
        msgbox('请先打开图像！', '提示', 'warn');
    end
end