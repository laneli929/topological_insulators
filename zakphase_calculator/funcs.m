function c1 = funcs(realmin, realThreshold)
% 计算4能带的 zak phase
% 输入：realmin —— 实部最小值
%      realThreshold —— 实部最大值
% 输出：c1 —— 计算得到的 Zak phase

    clearvars -except realmin realThreshold;
    clc;

    % 数据预定义
    a = 40e-3;
    r1 = 0.1*a;
    r2 = 0.1*a; % 上下圆半径
    d1 = 0.3*a;
    d2 = 0.75*a; % 上下链胞内间距
    height = 0.1*a; % 两链间距
    epsilon = 36;
    divide_num = 10; % 取点数目
    imagThreshold = 0.3; % 限制大的虚部

    % 读取数据
    field_data = dlmread('q1234fixed.txt','',5);
    A = field_data;

    % 处理数据
    rowsToRemove = real(A(:,2)) > realThreshold | real(A(:,2)) < realmin | imag(A(:,2)) > imagThreshold;
    A(rowsToRemove, :) = [];

    kx = A(:,1);
    freq = A(:,2);

    scatter(kx,freq); % 画能带图

    x = -a/2 : a/divide_num : a/2;
    y = -a/2 : a/divide_num : a/2;

    sizenum = (divide_num+1)^2; % 电场总数目
    field_Ez = A(:,3:end); % 121=11*11列
    field_Ezguiyi = field_Ez;

    step = a/divide_num; % 步长
    x_start = -a/2; % 横坐标起始值
    y_start = -a/2; % 纵坐标起始值

    % 初始化向量
    x_vector = zeros(1, sizenum); % 存储纵坐标
    y_vector = zeros(1, sizenum); % 存储横坐标

    % 生成坐标
    index = 1;
    for i = 0:divide_num
        for j = 0:divide_num
            x_vector(index) = y_start + j * step;
            y_vector(index) = x_start + i * step;
            index = index + 1;
        end
    end

    % 定义圆心和半径
    d12 = d1;
    d22 = d2;
    rr1 = r1;
    rr2 = r2;

    x_zuoshang = -d1/2; y_zuoshang = height;
    x_youshang = d1/2; y_youshang = height;
    x_zuoxia = -d2/2; y_zuoxia = -height;
    x_youxia = d2/2; y_youxia = -height;

    circles = struct('x_center', {x_zuoshang, x_youshang, x_zuoxia, x_youxia}, ...
                     'y_center', {y_zuoshang, y_youshang, y_zuoxia, y_youxia}, ...
                     'radius', {rr1, rr1, rr2, rr2});

    % 判断点是否在圆内
    eps = zeros(1, sizenum);
    for i = 1:sizenum
        if checkPointInCircles(x_vector(i), y_vector(i), circles)
            eps(i) = 45;
        else
            eps(i) = 1;
        end
    end
    eps = eps * 8.85e-12;

    % 归一化
    for i = 1:length(kx)
        guiyi = sqrt(field_Ez(i,:) .* eps * field_Ez(i,:)');
        field_Ezguiyi(i,:) = field_Ez(i,:) ./ guiyi;
    end

    % 计算 Zak phase
    c1 = 0;
    for j = 1:length(kx)-1
        field1 = field_Ezguiyi(j,:);
        field2 = field_Ezguiyi(j+1,:);
        F = (field1 .* eps * field2') ./ abs(field1 .* eps * field2');
        c1 = c1 + imag(log(F));
    end

    scatter(kx,freq);
    title(['Zak Phase =',num2str(c1)]);
    xlabel('kx');
    ylabel('freq');

end

% 子函数：判断点是否在圆内
function isInCircle = checkPointInCircles(x, y, circles)
    isInCircle = false;
    for i = 1:length(circles)
        isInCircle = isInCircle || ((x - circles(i).x_center)^2 + (y - circles(i).y_center)^2 < circles(i).radius^2);
    end
end
