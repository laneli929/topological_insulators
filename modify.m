function modify(imagThreshold)
% MODIFY Load and filter band structure data, plot results, and save filtered data
%   modify(imagThreshold) filters and plots band structure data using the specified
%   imaginary threshold value and saves the filtered data
%
%   Input:
%       imagThreshold - maximum allowed imaginary frequency value (e.g., 0.3)

% Load field data using readmatrix
try
    A = readmatrix('q1234fixed.txt', 'NumHeaderLines', 5);
catch
    error('Failed to read the data file. Please check the file path and format.');
end

realThreshold = 3;
realmin = 0; % Minimum real frequency value

% Filter data
rowsToRemove = real(A(:, 2)) > realThreshold | real(A(:, 2)) < realmin | imag(A(:, 2)) > imagThreshold;
A(rowsToRemove, :) = [];

% Save filtered data to new file
outputFilename = 'q1234fixed-modified.txt';%output a modified file
writematrix(A, outputFilename);
fprintf('Filtered data saved to: %s\n', outputFilename);

% Extract data for plotting
kx = A(:, 1);
freq = A(:, 2);

% Plot band structure
scatter(kx, freq);
xlabel('kx');
ylabel('freq');
title(['Band Structure (imagThreshold = ', num2str(imagThreshold)]);
grid on;

end