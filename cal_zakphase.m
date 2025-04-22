% Calculate Zak phase for 4 energy bands

clear;
clc;

% Predefined parameters - MODIFY BEFORE USE !!!!!!!!!!!!!!!!!!!!!!!
a = 40e-3;
r1 = 0.1*a;
r2 = 0.1*a; % Radius of upper/lower circles

d1 = 0.3*a;
d2 = 0.75*a; % Intra-cell spacing of upper/lower chains
height = 0.1*a; % Distance between two chains
epsilon = 36;
divide_num = 10; % Number of sampling points
%A = readmatrix("q14fixed_modified.txt");
realThreshold = 3; % Maximum real part
realmin = 0; % Minimum real part
imagThreshold = 0.3; % Limit for large imaginary part

field_data = dlmread('q1234fixed.txt','',5);
A = field_data;

% Data processing
rowsToRemove = real(A(:, 2)) > realThreshold | real(A(:, 2)) < realmin | imag(A(:, 2)) > imagThreshold;
A(rowsToRemove, :) = [];

kx = A(:, 1);
freq = A(:, 2);
% kx = field_data(:,1);
% freq = field_data(:,2);
scatter(kx, freq); % Plot band structure

x = -a/2:a/divide_num:a/2;
y = -a/2:a/divide_num:a/2;

sizenum = (divide_num+1)^2; % Total number of electric field points
% field_Ez = field_data(:,3:end); % 121 = 11*11 columns
field_Ez = A(:,3:end); % 121 = 11*11 columns
field_Ezguiyi = field_Ez;

% Initialization
%sizenum = 121; % Total points
% Need modification
step = a/divide_num; % Step size
x_start = -a/2; % X-coordinate starting value
y_start = -a/2; % Y-coordinate starting value

% Initialize vectors
x_vector = zeros(1, sizenum); % Now x_vector stores y-coordinates
y_vector = zeros(1, sizenum); % Now y_vector stores x-coordinates

% Generate coordinates
index = 1; % Initialize index
for i = 0:divide_num
    for j = 0:divide_num
        x_vector(index) = y_start + j * step; % Y-coordinate
        y_vector(index) = x_start + i * step; % X-coordinate
        index = index + 1;
    end
end

% x/y_vector stores the coordinates of the i-th point

% Define circle centers and radii (parameters should not be changed)
% d12 = 0.5 * a;
% d22 = 0.7 * a;
% rr1 = 0.1 * a; % Upper circle radius
% rr2 = 0.125 * a; % Lower circle radius
% height1 = 0.11 * a;

% x_zuoshang = a/2 - d12/2; y_zuoshang = a/2 + height1;
% x_youshang = a/2 + d12/2; y_youshang = a/2 + height1;
% x_zuoxia = a/2 - d22/2; y_zuoxia = a/2 - height1;
% x_youxia = a/2 + d22/2; y_youxia = a/2 - height1;

d12 = d1;
d22 = d2;
rr1 = r1; % Upper circle radius
rr2 = r2; % Lower circle radius

x_zuoshang = -d1/2; y_zuoshang = height;
x_youshang = d1/2; y_youshang = height;
x_zuoxia = -d2/2; y_zuoxia = -height;
x_youxia = d2/2; y_youxia = -height;

% Create structure array for circle centers and radii
circles = struct('x_center', {x_zuoshang, x_youshang, x_zuoxia, x_youxia}, ...
                 'y_center', {y_zuoshang, y_youshang, y_zuoxia, y_youxia}, ...
                 'radius', {rr1, rr1, rr2, rr2});

% Check if point is inside any circle
function isInCircle = checkPointInCircles(x, y, circles)
    isInCircle = false;
    for i = 1:length(circles)
        isInCircle = isInCircle || ((x - circles(i).x_center)^2 + (y - circles(i).y_center)^2 < circles(i).radius^2);
    end
end

% Initialize permittivity matrix
eps = zeros(1, (divide_num + 1)^2);
for i = 1:(divide_num + 1)^2
    if checkPointInCircles(x_vector(i), y_vector(i), circles)
        eps(i) = 45;
    else
        eps(i) = 1;
    end
end
% Test points - correct up to this point
eps_test = eps;
eps = eps * 8.85e-12;

% Calculate Zak phase
for i = 1:1:length(kx)
    guiyi = sqrt(field_Ez(i,:).*eps*field_Ez(i,:)');
    field_Ezguiyi(i,:) = field_Ez(i,:)./guiyi;
end
c1 = 0;
for j = 1:1:length(kx)-1
    field1 = field_Ezguiyi(j,:);
    field2 = field_Ezguiyi(j+1,:);
    
    F = (field1.*eps*field2')./(abs(field1.*eps*field2'));
    
    c1 = c1 + imag(log(F));
end
c1
scatter(kx, freq); title(['Zak Phase = ', num2str(c1)]); xlabel('kx'); ylabel('freq')
