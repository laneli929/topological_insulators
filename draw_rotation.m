% draw rotation phase diagram for 4-band system
clear;
clc;

%% ========== PARAMETER DEFINITION (MODIFY BEFORE USE) ==========
a = 40e-3;              % Lattice constant (m)
r1 = 0.1*a;             % Upper circle radius
r2 = 0.1*a;             % Lower circle radius
d1 = 0.3*a;             % Intra-cell spacing (upper chain)
d2 = 0.75*a;            % Intra-cell spacing (lower chain)
height = 0.1*a;         % Inter-chain spacing
epsilon = 36;           % Dielectric constant
divide_num = 30;        % Number of sampling points

%% ========== DATA PROCESSING ==========
% Frequency filtering thresholds
realThreshold = 3;      % Maximum real part value
realmin = 0;            % Minimum real part value
imagThreshold = 0.3;    % Maximum allowed imaginary part

% Load field data (skipping first 5 header lines)
field_data = dlmread('q14-30.txt', '', 5);
A = field_data;

% Filter data based on thresholds
rowsToRemove = real(A(:, 2)) > realThreshold | ...
               real(A(:, 2)) < realmin | ...
               imag(A(:, 2)) > imagThreshold;
A(rowsToRemove, :) = [];
kx = A(:, 1);
freq = A(:, 2);
scatter(kx, freq);      % Plot band structure

%% ========== POSITION DETERMINATION ==========
% Generate coordinate grid
x = -a/2:a/divide_num:a/2;
y = -a/2:a/divide_num:a/2;
sizenum = (divide_num+1)^2;  % Total number of field points

% Initialize coordinate vectors
step = a/divide_num;
x_start = -a/2;
y_start = -a/2;
x_vector = zeros(1, sizenum);
y_vector = zeros(1, sizenum);

% Generate coordinate grid
index = 1;
for i = 0:divide_num
    for j = 0:divide_num
        x_vector(index) = y_start + j * step;
        y_vector(index) = x_start + i * step;
        index = index + 1;
    end
end

% Circle positions (upper and lower chains)
d12 = d1;
d22 = d2;
rr1 = r1; 
rr2 = r2;

% Circle center coordinates
x_zuoshang = -d1/2; y_zuoshang = height;  % Upper left
x_youshang = d1/2;  y_youshang = height;  % Upper right
x_zuoxia = -d2/2;   y_zuoxia = -height;   % Lower left
x_youxia = d2/2;    y_youxia = -height;   % Lower right

% Initialize circle membership flags
in_circle = zeros(4, sizenum);  % [upper_left; upper_right; lower_left; lower_right]

% Determine points inside each circle
for i = 1:sizenum
    dist = @(x,y,xc,yc) (x - xc)^2 + (y - yc)^2;
    
    in_circle(1,i) = dist(x_vector(i), y_vector(i), x_zuoshang, y_zuoshang) <= rr1^2;
    in_circle(2,i) = dist(x_vector(i), y_vector(i), x_youshang, y_youshang) <= rr1^2;
    in_circle(3,i) = dist(x_vector(i), y_vector(i), x_zuoxia, y_zuoxia) <= rr2^2;
    in_circle(4,i) = dist(x_vector(i), y_vector(i), x_youxia, y_youxia) <= rr2^2;
end

%% ========== PHASE CALCULATION ==========
% Initialize output matrix with 4 additional columns
[m, n] = size(A);
B = [A(:,1:2), zeros(m, 4)];  % [kx, freq, phi1, phi2, phi3, phi4]

% Calculate phi1-phi4 for each mode
for i = 1:m
    field_pattern = A(i, 3:end); 
    B(i, 3:6) = field_pattern * in_circle';  % Dot product with each circle
end

%% ========== UNITARY TRANSFORMATION ==========
%For this part, please contact the author xinghan.li11@outlook.com for permission
str='For this part, please contact the author xinghan.li11@outlook.com for permission';
disp(str);


% Apply transformation to phi vectors
phi_mat = B(:, 3:6)';          % 4×m matrix
phi_prime = (Wmat * phi_mat)';  % m×4 transformed matrix
B(:, 3:6) = phi_prime;          % Store back

%% ========== VISUALIZATION ==========
% Classify points by frequency bands
band_ranges = [0 1.5; 1.5 2.1; 2.1 2.7; 2.7 Inf];
band_colors = {[1 0 0], [0 1 0], [0 0 1], [0.5 0.5 0.5]};
band_names = {'Band 1', 'Band 2', 'Band 3', 'Band 4'};

% Special processing for Band 3 (blue points)
blue_idx = freq >= band_ranges(3,1) & freq < band_ranges(3,2);
B(blue_idx & B(:,3) > 0, 3:6) = -B(blue_idx & B(:,3) > 0, 3:6);

% Create figure
figure;
hold on;

% Plot each band
for b = 1:4
    band_idx = freq >= band_ranges(b,1) & freq < band_ranges(b,2);
    band_points = B(band_idx, 3:5);  % Use first three phi components
    
    % Normalize points
    norm_points = band_points ./ max(abs(band_points(:)));
    
    scatter3(norm_points(:,1), norm_points(:,2), norm_points(:,3), ...
            20, band_colors{b}, 'filled', 'DisplayName', band_names{b});
end

% Figure formatting
title('Rotation Scatter Plot for Four Bands (Transformed)');
xlabel('\phi_1'''); 
ylabel('\phi_2'''); 
zlabel('\phi_3''');
legend('Location', 'bestoutside');
grid on; 
view(3);  % 3D view
hold off;
