function commonPeaks = deselectPeak(time, s_meas_ns_bc, commonPeaks)
    % Create a new figure window
    hFig = figure;
    hold on;

    % Plot the chromatograms
    plot(time, s_meas_ns_bc, 'k'); % Plot all chromatograms in black
    
    % Plot each peak individually with its own ButtonDownFcn
    peakMarkers = gobjects(size(commonPeaks, 1), 1);  % Create array to hold graphic objects
    
    for i = 1:size(commonPeaks, 1)
        peakMarkers(i) = plot(commonPeaks(i,1), commonPeaks(i,2), 'ro', 'MarkerSize', 8, ...
                              'ButtonDownFcn', @(src, event) onPeakClick(i));
    end
    
    % Block MATLAB command line until figure is closed
    uiwait(hFig);
    
    % Return the updated commonPeaks after deselection
    function onPeakClick(peakIndex)
        % Remove the clicked peak from the plot and commonPeaks
        delete(peakMarkers(peakIndex));  % Remove the clicked peak from the figure
        commonPeaks(peakIndex, :) = NaN;  % Mark the peak as deselected by setting to NaN
        
        % Update peakMarkers to reflect deselected peaks
        drawnow;
    end
end

