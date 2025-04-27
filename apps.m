function apps
    % 创建GUI界面
    fig = figure('Name', '数据处理与Zak Phase计算', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

    % 导入数据按钮
    uicontrol('Style', 'pushbutton', 'String', '导入数据', 'Position', [10, 550, 100, 30], 'Callback', @importData);

    % 数据筛选按钮
    uicontrol('Style', 'pushbutton', 'String', '数据筛选', 'Position', [120, 550, 100, 30], 'Callback', @filterData);

    % 计算Zak Phase按钮
    uicontrol('Style', 'pushbutton', 'String', '计算Zak Phase', 'Position', [230, 550, 120, 30], 'Callback', @calculateZakPhase);

    % 预留按钮1
    uicontrol('Style', 'pushbutton', 'String', '功能1', 'Position', [360, 550, 100, 30], 'Callback', @feature1);

    % 预留按钮2
    uicontrol('Style', 'pushbutton', 'String', '功能2', 'Position', [470, 550, 100, 30], 'Callback', @feature2);

    % 退出按钮
    uicontrol('Style', 'pushbutton', 'String', '退出', 'Position', [580, 550, 80, 30], 'Callback', @exitApp);

    % 显示文本区域
    statusText = uicontrol('Style', 'text', 'Position', [10, 500, 760, 30], 'String', '欢迎使用数据处理系统', 'HorizontalAlignment', 'left', 'FontSize', 12);

    % 变量初始化
    dataFile = '';
    data = [];
    
    % 导入数据函数
    function importData(~, ~)
        [file, path] = uigetfile('*.txt', '选择数据文件');
        if file
            dataFile = fullfile(path, file);
            data = dlmread(dataFile,'',5); % 读取数据，从第6行开始
            set(statusText, 'String', ['已导入文件: ', file]);
        end
    end

    % 数据筛选函数
    function filterData(~, ~)
        if ~isempty(data)
            prompt = {'输入imagThreshold值:'};
            dlgtitle = '数据筛选参数设置';
            dims = [1 35];
            definput = {'0.3'};  % 默认值
            answer = inputdlg(prompt, dlgtitle, dims, definput);

            if ~isempty(answer)
                imagThreshold = str2double(answer{1});
                modify(imagThreshold);  % 调用你的 modify.m
                set(statusText, 'String', ['数据筛选完成，输出文件：q1234fixed-modified.txt (imagThreshold = ', num2str(imagThreshold), ')']);
            end
        else
            set(statusText, 'String', '请先导入数据文件');
        end
    end

    % 计算Zak Phase函数
    function calculateZakPhase(~, ~)
        % 计算Zak Phase需要基于 modify 后生成的新文件
        if exist('q1234fixed-modified.txt', 'file')
            prompt = {'输入 realmin:', '输入 realThreshold:'};
            dlgtitle = 'Zak Phase参数设置';
            dims = [1 35];
            definput = {'0', '3'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);

            if ~isempty(answer)
                realmin = str2double(answer{1});
                realThreshold = str2double(answer{2});

                zakPhase = funcs(realmin, realThreshold);
                set(statusText, 'String', ['Zak Phase 计算完成，值为: ', num2str(zakPhase)]);
            end
        else
            set(statusText, 'String', '请先完成数据筛选 (生成modified文件)');
        end
    end

    % 预留功能1
    function feature1(~, ~)
        set(statusText, 'String', '功能1待开发');
    end

    % 预留功能2
    function feature2(~, ~)
        set(statusText, 'String', '功能2待开发');
    end

    % 退出函数
    function exitApp(~, ~)
        close(fig);
    end
end
