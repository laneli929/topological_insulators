function drawRotationDiagram(ax)
    % 读取和处理数据
    a = 40e-3;
    divide_num = 10;
    realThreshold = 3;
    realmin = 0;
    imagThreshold = 0.3;

    field_data = dlmread('q1234fixed.txt', '', 5);
    A = field_data;

    % 过滤数据
    rowsToRemove = real(A(:, 2)) > realThreshold | real(A(:, 2)) < realmin | imag(A(:, 2)) > imagThreshold;
    A(rowsToRemove, :) = [];
    kx = A(:, 1);
    freq = A(:, 2);

    % 生成坐标
    x = -a/2:a/divide_num:a/2;
    y = -a/2:a/divide_num:a/2;
    sizenum = (divide_num+1)^2;
    step = a/divide_num;
    x_start = -a/2;
    y_start = -a/2;
    x_vector = zeros(1, sizenum);
    y_vector = zeros(1, sizenum);

    index = 1;
    for i = 0:divide_num
        for j = 0:divide_num
            x_vector(index) = y_start + j * step;
            y_vector(index) = x_start + i * step;
            index = index + 1;
        end
    end

    % 圆的位置
    d1 = 0.3*a;
    d2 = 0.75*a;
    r1 = 0.1*a;
    r2 = 0.1*a;
    height = 0.1*a;

    x_zuoshang = -d1/2; y_zuoshang = height;
    x_youshang = d1/2;  y_youshang = height;
    x_zuoxia = -d2/2;   y_zuoxia = -height;
    x_youxia = d2/2;    y_youxia = -height;

    in_circle1 = zeros(1, sizenum);
    in_circle2 = zeros(1, sizenum);
    in_circle3 = zeros(1, sizenum);
    in_circle4 = zeros(1, sizenum);

    for i = 1:sizenum
        x_i = x_vector(i);
        y_i = y_vector(i);
        if (x_i - x_zuoshang)^2 + (y_i - y_zuoshang)^2 <= r1^2
            in_circle1(i) = 1;
        end
        if (x_i - x_youshang)^2 + (y_i - y_youshang)^2 <= r1^2
            in_circle2(i) = 1;
        end
        if (x_i - x_zuoxia)^2 + (y_i - y_zuoxia)^2 <= r2^2
            in_circle3(i) = 1;
        end
        if (x_i - x_youxia)^2 + (y_i - y_youxia)^2 <= r2^2
            in_circle4(i) = 1;
        end
    end

    % 计算phi
    [m, n] = size(A);
    B = [A(:,1:2), zeros(m, 4)];
    for i = 1:m
        row_data = A(i, 3:end); 
        phi1 = row_data * in_circle1';
        phi2 = row_data * in_circle2';
        phi3 = row_data * in_circle3';
        phi4 = row_data * in_circle4';
        B(i, end-3:end) = [phi1, phi2, phi3, phi4];
    end

    % Takagi分解
    U_GPT = [0 1 0 0; 1 0 0 0; 0 0 0 1; 0 0 1 0];
    [V,~] = takagi(U_GPT);
    Wmat = V';

    % 应用旋转
    phi_mat = [B(:, end-3), B(:, end-2), B(:, end-1), B(:, end)]';
    phi_prime = (Wmat * phi_mat)';
    B(:, end-3:end) = phi_prime;

    % 蓝色 band 特别处理
    red_points = B(freq >= 0 & freq < 1.5, end-3:end);
    green_points = B(freq >= 1.5 & freq < 2.1, end-3:end);
    blue_points = B(freq >= 2.1 & freq < 2.7, end-3:end);
    gray_points = B(freq >= 2.7, end-3:end);

    mask = blue_points(:, end-3) > 0;
    blue_points(mask, :) = -blue_points(mask, :);

    normalize_data = @(data) data ./ max(abs(data), [], 'all');

    % 在 ax 上画图
    axes(ax); % 指定绘图区域
    cla(ax); % 清空ax内容
    hold(ax, 'on');

    scatter3(ax, normalize_data(red_points(:,1)), normalize_data(red_points(:,2)), normalize_data(red_points(:,3)), ...
        20, [1, 0, 0], 'filled', 'DisplayName', 'Band 1');
    scatter3(ax, normalize_data(green_points(:,1)), normalize_data(green_points(:,2)), normalize_data(green_points(:,3)), ...
        20, [0, 1, 0], 'filled', 'DisplayName', 'Band 2');
    scatter3(ax, normalize_data(blue_points(:,1)), normalize_data(blue_points(:,2)), normalize_data(blue_points(:,3)), ...
        20, [0, 0, 1], 'filled', 'DisplayName', 'Band 3');
    scatter3(ax, normalize_data(gray_points(:,1)), normalize_data(gray_points(:,2)), normalize_data(gray_points(:,3)), ...
        20, [0.5, 0.5, 0.5], 'filled', 'DisplayName', 'Band 4');

    title(ax, 'Rotation Scatter Plot for Four Circles (Transformed)');
    xlabel(ax, 'x');
    ylabel(ax, 'y');
    zlabel(ax, 'z');
    legend(ax, 'Location', 'bestoutside');
    grid(ax, 'on');
    view(ax, 3);
    hold(ax, 'off');
end

function [V,Sigma]=takagi(U)
    [U_SVD, Sigma, V_SVD] = svd(U);
    Z = U_SVD' * conj(V_SVD);
    V = U_SVD * sqrtm(Z);
end
