%calculation for Inverse Participation Ratio (IPR)
clear;
clc;

% Load data (skipping first 5 header lines)
A = dlmread('ipr.txt', '', 5);

% Get matrix dimensions
[m, n] = size(A);

% Initialize new matrix B with an extra column
B = [A(:,1:2), zeros(m, 1)];

% Calculate Inverse Participation Ratio (IPR)
for i = 1:m
    row_data = A(i, 2:end); % Exclude first column
    numerator = sum(abs(row_data).^4); % Sum of fourth powers
    denominator = sum(abs(row_data).^2)^2; % Square of sum of squares
    B(i, end) = numerator / denominator; % Store IPR in last column
end

% Create scatter plot
x = A(:,1);          % x-coordinates (first column)
y = real(B(:,2));    % y-coordinates (real part of second column)
c = abs(B(:,3));     % Color values based on IPR magnitude

scatter(x, y, 10, log(c), 'filled'); % Logarithmic color scaling

% Generate custom colormap
num_colors = 256; % Color gradient steps
x = linspace(0, 1, num_colors);
y = x.^2; % Exponential mapping for sharper color transitions

% Gray-to-blue colormap definition
gray_to_blue = [0.8 - 0.8*y', ... % Red channel (gray to blue)
                0.8 - 0.8*y', ... % Green channel (gray to blue)
                0.8 + 0.2*y'];    % Blue channel (gray to blue)

colormap(gray_to_blue);

% Customize colorbar
h = colorbar;
h.Ticks = []; % Remove default ticks
caxis_range = caxis;
min_val = caxis_range(1);
max_val = caxis_range(2);

% Set colorbar ticks and labels
h.Ticks = [min_val, max_val];
h.TickLabels = {'0', '1'};

% Add colorbar title
title(h, 'IPR');

% Adjust colorbar position and size
h.Position = [0.8, 0.8, 0.02, 0.06]; % [left, bottom, width, height]

% Add plot labels
title('Phase transition');
xlabel('ht (mm)');
ylabel('Frequency (GHz)');
