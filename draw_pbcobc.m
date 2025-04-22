%compare energy bands between PBC and OBC
clear;
clc;

% Subplot positioning parameters
main_width = 0.6;    % Main plot (scatter) width
side_width = 0.15;   % Side plot (bar) width
gap = 0.05;          % Gap between plots
margin = 0.1;        % Figure margins

% Data filtering thresholds
realThreshold = 3;    % Maximum real part value
realmin = 0;          % Minimum value
imagThreshold = 0.3;  % Maximum allowed imaginary part (PBC)
imagThreshold1 = 0.2; % Maximum allowed imaginary part (OBC)

% Load and filter PBC data
A1 = dlmread('q14fixed.txt', '', 5);
rowsToRemove1 = real(A1(:, 2)) > realThreshold | real(A1(:, 2)) < realmin | imag(A1(:, 2)) > imagThreshold;
A1(rowsToRemove1, :) = [];
kx1 = A1(:, 1);
freq1 = A1(:, 2);

% Load and filter OBC data
A2 = dlmread('DM1.txt', '', 5);
rowsToRemove2 = real(A2(:, 1)) > realThreshold | real(A2(:, 1)) < realmin | imag(A2(:, 1)) > imagThreshold1;
A2(rowsToRemove2, :) = [];
kx2 = A2(:, 1);
freq2 = A2(:, 2);
w = ones(length(freq2)); % Weight vector for bar plot

% Create figure window
figure;

% Set global font sizes
font_size = 10;  % Uniform font size
tick_size = 9;   % Uniform tick label size

% First subplot (Scatter plot - PBC)
subplot(1,2,1);
hold on
scatter(kx1, real(freq1), 10, [0, 0, 0], 'filled');
hold off
title('PBC', 'FontSize', font_size);
xlabel('kx(2π/a)', 'FontSize', font_size);
ylabel('Frequency (GHz)', 'FontSize', font_size);
grid on;
ylim([0 realThreshold]);
xlim([-1 1]);
set(gca, 'FontSize', tick_size);

% Second subplot (Bar plot - OBC)
subplot(1,2,2);
% Create color index for special frequency range highlighting
colorIdx = zeros(length(freq2), 1);
colorIdx((real(freq2) >= 2.1 & real(freq2) <= 2.2)) = 1;
colorMap = [0.8 0.8 0.8; 1 0 0]; % [gray; red]

h = barh(real(freq2), w, 0.3, ...
    'FaceColor', [1, 1, 0.8], ... % Light yellow fill
    'EdgeColor', 'flat', ...       % Edge colors follow CData
    'CData', colorIdx, ...         % Color data
    'CDataMapping', 'direct', ...  % Direct color mapping
    'LineWidth', 0.9);             % Edge line width

colormap(colorMap);
title('OBC', 'FontSize', font_size);
ylabel('');
xlabel('');
ylim([0 realThreshold]);
xlim([0 0.2]);
set(gca, 'XTick', [], 'FontSize', tick_size);

% Synchronize y-axis ticks with first subplot
yticks = get(subplot(1,2,1), 'YTick');
set(gca, 'YTick', yticks);

% Adjust figure layout and size
set(gcf, 'Position', [100, 100, 700, 400]); % [left, bottom, width, height]
