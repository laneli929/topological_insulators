function apps
    % Create GUI Interface
    fig = figure('Name', 'Data Processing and Zak Phase Calculation', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

    % Import Data Button
    uicontrol('Style', 'pushbutton', 'String', 'Import Data', 'Position', [10, 550, 100, 30], 'Callback', @importData);

    % Filter Data Button
    uicontrol('Style', 'pushbutton', 'String', 'Filter Data', 'Position', [120, 550, 100, 30], 'Callback', @filterData);

    % Calculate Zak Phase Button
    uicontrol('Style', 'pushbutton', 'String', 'Calculate Zak Phase', 'Position', [230, 550, 120, 30], 'Callback', @calculateZakPhase);

    % Draw Rotation Diagram Button (Feature 1)
    uicontrol('Style', 'pushbutton', 'String', 'Draw Rotation Diagram', 'Position', [360, 550, 100, 30], 'Callback', @feature1);

    % Save Rotation Diagram Button (Feature 2)
    uicontrol('Style', 'pushbutton', 'String', 'Save Rotation Diagram', 'Position', [470, 550, 100, 30], 'Callback', @feature2);

    % Exit Button
    uicontrol('Style', 'pushbutton', 'String', 'Exit', 'Position', [580, 550, 80, 30], 'Callback', @exitApp);

    % Status Display Area
    statusText = uicontrol('Style', 'text', 'Position', [10, 500, 760, 30], ...
        'String', 'Welcome to the Data Processing System', 'HorizontalAlignment', 'left', 'FontSize', 12);

    % Plotting Area
    ax = axes('Parent', fig, 'Units', 'pixels', 'Position', [50, 80, 700, 400]);

    % Initialize Variables
    dataFile = '';
    data = [];
    
    % Import Data Function
    function importData(~, ~)
        [file, path] = uigetfile('*.txt', 'Select Data File');
        if file
            dataFile = fullfile(path, file);
            data = dlmread(dataFile, '', 5); % Read data starting from the 6th line
            set(statusText, 'String', ['Imported file: ', file]);
        end
    end

    % Filter Data Function
    function filterData(~, ~)
        if ~isempty(data)
            prompt = {'Enter imagThreshold value:'};
            dlgtitle = 'Filter Data Parameters';
            dims = [1 35];
            definput = {'0.3'};  % Default value
            answer = inputdlg(prompt, dlgtitle, dims, definput);

            if ~isempty(answer)
                imagThreshold = str2double(answer{1});
                modify(imagThreshold, ax);  % Pass ax to modify
                set(statusText, 'String', ['Data filtering completed. Output file: q1234fixed-modified.txt (imagThreshold = ', num2str(imagThreshold), ')']);
            end
        else
            set(statusText, 'String', 'Please import a data file first.');
        end
    end

    % Calculate Zak Phase Function
    function calculateZakPhase(~, ~)
        % Zak Phase calculation is based on the modified file
        if exist('q1234fixed-modified.txt', 'file')
            prompt = {'Enter realmin:', 'Enter realThreshold:'};
            dlgtitle = 'Zak Phase Parameters';
            dims = [1 35];
            definput = {'0', '3'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);

            if ~isempty(answer)
                realmin = str2double(answer{1});
                realThreshold = str2double(answer{2});

                zakPhase = funcs(realmin, realThreshold);
                set(statusText, 'String', ['Zak Phase calculation completed. Value: ', num2str(zakPhase)]);
            end
        else
            set(statusText, 'String', 'Please complete data filtering first (generate modified file).');
        end
    end

    % Draw Rotation Diagram Function (Feature 1)
    function feature1(~, ~)
        set(statusText, 'String', 'Drawing rotation diagram...');
        cla(ax); % Clear previous contents
        drawRotationDiagram(ax); % Draw rotation diagram in ax
    end

    % Save Rotation Diagram Function (Feature 2)
    function feature2(~, ~)
        set(statusText, 'String', 'Saving rotation diagram...');
        [file, path] = uiputfile({'*.png'; '*.jpg'; '*.fig'}, 'Save Rotation Diagram As');
        if isequal(file, 0) || isequal(path, 0)
            set(statusText, 'String', 'Saving canceled.');
            return;
        end
        fullFileName = fullfile(path, file);

        exportgraphics(ax, fullFileName);  % Save the plot
        set(statusText, 'String', ['Rotation diagram saved to: ', fullFileName]);
    end

    % Exit Application Function
    function exitApp(~, ~)
        close(fig);
    end
end
