function commonPeaks = SelectPeak(time, s_meas_ns_bc,commonPeaks)
    % Create a new figure window
    hFig = figure;
    
    % Plot the data
    plot(time,s_meas_ns_bc,'k');
    hold on;
    hPlots = scatter(commonPeaks(:,1),commonPeaks(:,2));
    zoom on; % Enable zoom mode

    % Create a UI button to proceed after zooming
    uicontrol('Style', 'pushbutton', 'String', 'Continue', ...
              'Position', [20 20 60 20], ...
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
    newtime = time(idx_start:idx_end);
    % find local maxima in the the selected region
    for i = 1:size(s_meas_ns_bc, 2)
        newydata = s_meas_ns_bc(idx_start:idx_end,i);
        [maxval,idx] = max(newydata);
        extraPeak{i}=maxval;
        extraPeakLoc{i}=newtime(idx);
    end
    additionalPeaks = [extraPeakLoc{1},extraPeak{1},extraPeakLoc{2},extraPeak{2},extraPeakLoc{3},extraPeak{3}];
    commonPeaks = [commonPeaks;additionalPeaks];
    % Check if the plot is still valid before updating it
    if all(isvalid(hPlots))
        % Update each plot with the modified signal
        % for i = 1:length(hPlots)
        %     set(hPlots(i), 'YData', s_meas_ns_bc(:, i));
        % end
        set(hPlots,'XData',commonPeaks(:,1), 'YData', commonPeaks(:,2));
        % Optionally, redraw the plot
        drawnow;
    else
        disp('The figure was closed before the data could be updated.');
    end
end
