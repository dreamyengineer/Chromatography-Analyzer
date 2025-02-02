function s_meas_ns_bc = NoiseFilter(time, s_meas_ns_bc)
    % Create a new figure window
    hFig = figure;
    
    % Plot the data
    hPlots = plot(time, s_meas_ns_bc);
    zoom on; % Enable zoom mode
    
    % Create a UI button to proceed after zooming
    uicontrol('Style', 'pushbutton', 'String', 'Continue', ...
              'Position', [20 20 100 40], ...
              'Callback', 'uiresume(gcbf)');
    
    % Prompt the user to zoom in and press the button to continue
    disp('Zoom in to select the region of interest, then press "Continue" to proceed...');
    
    % Wait for the user to interact with the figure
    uiwait(hFig);
    
    % Disable zoom
    zoom off;
    
    % Use ginput to select two points for the region to zero out
    [x_selected, ~] = ginput(2);
    x_selected = sort(x_selected);
    
    % Find the indices corresponding to the selected x values
    idx_start = find(time >= x_selected(1), 1);
    idx_end = find(time <= x_selected(2), 1, 'last');
    
    % Zero out the selected region for all columns
    for i = 1:size(s_meas_ns_bc, 2)
        s_meas_ns_bc(idx_start:idx_end, i) = 0;
    end
    
    % Check if the plot is still valid before updating it
    if all(isvalid(hPlots))
        % Update each plot with the modified signal
        for i = 1:length(hPlots)
            set(hPlots(i), 'YData', s_meas_ns_bc(:, i));
        end
        
        % Optionally, redraw the plot
        drawnow;
    else
        disp('The figure was closed before the data could be updated.');
    end
end
