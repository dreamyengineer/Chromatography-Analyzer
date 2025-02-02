function [commonPeaks,usedlist2,usedlist3] = findCommonPeaksWithEllipsesV18orig(errorBoundX, errorBoundY, errorBoundYPercentage, errorBoundXPercentage, locs, pks)
    % ChangeLog: same as V17orig but with try-catch logic implemented
    % Initialize a matrix to store common peaks
    commonPeaks = [];
    
    % Create a new figure for plotting
    figure(1);
    title('Peak Comparison using dynamic ellipses');
    hold on;
    
    % Plot peaks
    plot(locs{1}, pks{1}, 'o', 'DisplayName', 'Chromatogram 1');
    plot(locs{2}, pks{2}, 'o', 'DisplayName', 'Chromatogram 2');
    plot(locs{3}, pks{3}, 'o', 'DisplayName', 'Chromatogram 3');
    
    % Find Chromatogram with the most peaks and create list to iterate over the other two
    [maxval, maxindex] = max([length(pks{1}), length(pks{2}), length(pks{3})]);
    A = [1, 2, 3];
    A(A == maxindex) = [];
    commonPeaks = [maxindex, 0, A(1), 0, A(2), 0];
    %usedlist1 = [];%zeros(1,length(pks{maxindex}));
    usedlist2 = [];%zeros(1,length(pks{A(1)}));
    usedlist3 = [];%zeros(1,length(pks{A(2)}));
    % Iterate through the peaks of the Chromatogram with the most peaks
    for i = 1:maxval
        loc1 = locs{maxindex}(i);
        pk1 = pks{maxindex}(i);
        
        % Define ellipse parameters
        a = errorBoundX + (errorBoundXPercentage / 10000) * loc1; % semi-major axis (horizontal direction)
        b = errorBoundY + (errorBoundYPercentage / 500) * pk1; % semi-minor axis (vertical direction)        
        
        % Check peaks in chromatogram 2
        % This creates a logic array with length of locs{A(1)} and has
        % entries wether the momentary peak in the longest peaklist we are
        % going through belongs to each peak in the pks{A(1)}
        inEllipse2 = arrayfun(@(loc, pk) ((loc - loc1)^2 / a^2 + (pk - pk1)^2 / b^2) <= 1, locs{A(1)}, pks{A(1)});
        if any(inEllipse2)
            % Find the corresponding peak in chromatogram 2
            % finds the index of the first nonzero entry in inEllipse2
            try
                if any(ismember(locs{A(1)}(inEllipse2==1),usedlist2))
                    index2list = find(inEllipse2, 2);
                    index2 = index2list(2);
                else
                    index2 = find(inEllipse2, 1);
                end
                loc2 = locs{A(1)}(index2);
                pk2 = pks{A(1)}(index2);
                usedlist2(i) = loc2;
            catch
                disp(['fault at',num2str(i),'in 2nd point']);
                continue
            end
            % Check peaks in chromatogram 3
            inEllipse3 = arrayfun(@(loc, pk) ((loc - loc1)^2 / a^2 + (pk - pk1)^2 / b^2) <= 1, locs{A(2)}, pks{A(2)});
            if any(inEllipse3)
                % Find the corresponding peak in chromatogram 3
                try
                    if any(ismember(locs{A(2)}(inEllipse3==1),usedlist3))
                        index3list = find(inEllipse3, 2);
                        index3 = index3list(2);
                    else
                        index3 = find(inEllipse3, 1);
                    end
                    loc3 = locs{A(2)}(index3);
                    pk3 = pks{A(2)}(index3);
                    usedlist3(i) = loc3;
                catch
                    disp(['fault at',num2str(i),'in 3rd point']);
                    continue
                end
                % If peaks are found in both chromatograms within the ellipse, add to common peaks
                commonPeaks = [commonPeaks; loc1, pk1, loc2, pk2, loc3, pk3]; %#ok<AGROW>
                plotEllipse(loc1, pk1, a, b, ':');
            end
        end
        %disp([usedlist2,usedlist3]);
    end
    plot(commonPeaks(2:end,1),commonPeaks(2:end,2),".r");
    plot(commonPeaks(2:end,3),commonPeaks(2:end,4),".r");
    plot(commonPeaks(2:end,5),commonPeaks(2:end,6),".r");
    hold off;
end