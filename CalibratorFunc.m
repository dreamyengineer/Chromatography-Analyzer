function [AreaData,result] = CalibratorFunc(AreaData,CalibrationTable,IdentificationTable,QSave,SaveAs)
    %% TO WORK WITH THIS FUNCTION, EXPERIMENT WITH THE NORMAL SCRIPT IN CHROMATOGRAPHY ANALYSIS FOLDER

    %% Import Area Data from saved MAT file !!OR IS CSV BETTER?!!
    % filename = 'Areadata.mat';
    % AreaData = load(filename).Areatable;
    % clear filename;
    mean_val = cell2mat(AreaData(4,:));
    %% Import Identification table from xlxs file
    filename = IdentificationTable;
    opts = detectImportOptions(filename);
    IdentificationData = readtable(filename,opts);
    clear filename;
    Compound = IdentificationData{5:end,2};
    RT_min = IdentificationData{5:end,8};
    RT_max = IdentificationData{5:end,9};
    %% Identify Compounds and assign
    % Initialize an array to store the indices of the corresponding ranges
    belonging_indices = NaN(size(mean_val));
    
    for i = 1:length(mean_val)
        % Find all ranges that include the current mean_val(i)
        in_range = (mean_val(i) >= RT_min) & (mean_val(i) <= RT_max);
        
        if any(in_range)
            % Calculate the distance from the middle of each valid range
            range_midpoints = (RT_min(in_range) + RT_max(in_range)) / 2;
            distances = abs(mean_val(i) - range_midpoints);
            
            % Find the range with the smallest distance to the middle
            [~, min_index] = min(distances);
            
            % Get the corresponding index in RT_min and RT_max
            valid_indices = find(in_range);
            belonging_indices(i) = valid_indices(min_index);
        end
    end
    
    % Display the results
    % for i = 1:length(mean_val)
    %     if isnan(belonging_indices(i))
    %         fprintf('mean_val(%.2f) does not belong to any range.\n', mean_val(i));
    %     else
    %         fprintf('mean_val(%.2f) belongs to range [%d, %d] at index %d.\n', ...
    %                 mean_val(i), RT_min(belonging_indices(i)), RT_max(belonging_indices(i)), belonging_indices(i));
    %     end
    % end
    %% Extend Areadata with Compound Information
    for i = 1:length(mean_val)
        if ~isnan(belonging_indices(i))
            AreaData{8,i} = Compound(belonging_indices(i));
        else
            AreaData{8,i} = {'Not in Definition Range'};
        end
    end
    %% Import Calibration Data and transform into calibration curves
    % save calibration curve data for subsequent uses
    filename = CalibrationTable;
    CalibrationData = readtable(filename);
    % CompoundCDHigh = CalibrationData{1:15,1};
    % CompoundCDLow = CalibrationData{22:36,1};
    % mCDHigh = CalibrationData{1:15,3};
    % mCDLow = CalibrationData{22:36,3};
    % bCDHigh = CalibrationData{1:15,4};
    % bCDLow = CalibrationData{22:36,4};
    % AmaxCDHigh = CalibrationData{1:15,7};
    % AminCDHigh = CalibrationData{1:15,8};
    % AmaxCDLow = CalibrationData{22:36,7};
    % AminCDLow = CalibrationData{22:36,8};
    HighTable = CalibrationData(1:15,1:8);
    LowTable = CalibrationData(22:36,1:8);
    %% Perform necessary calculation
    % access Data in HighTable like this HighTable{1,5}, not HighTable(1,5),
    % because this creates a table value and not a real value
    
    % check to what C group it belongs, this was done previously with retention
    % time
    % for i=1:length(mean_val)
    %     match = regexp(AreaData{8,i}, '^[^-]*', 'match');
    %     %modifiedArray{i} = match{1};
    %     Zug = ismember(LowTable{:,1},match{1});
    %     if any(Zug)
    %         if AreaData{5,i} < LowTable{Zug,7}
    %             AreaData{9,i} = (AreaData{5,i}-LowTable{Zug,4})/LowTable{Zug,3};
    %         else
    %             AreaData{9,i} = (AreaData{5,i}-HighTable{Zug,4})/HighTable{Zug,3};
    %         end
    %     end
    % 
    % end
    for i = 1:length(mean_val)
        match = regexp(AreaData{8,i}, '^[^-]*', 'match');  % Extract compound name (e.g., C27)
        compoundName = match{1};
        
        % Find matching row or the closest available compound
        Zug = ismember(LowTable{:,1}, compoundName);  % Check if the compound exists
    
        % Handle special case for C2 and C4
        if strcmp(compoundName, 'C2') || strcmp(compoundName, 'C4')
            compoundName = 'C5';  % Use C5 calibration data for C2 or C4
            Zug = ismember(LowTable{:,1}, compoundName);  % Find C5
        end
    
        if ~any(Zug)  % If compound not found, find the closest available compound
            % Extract the numeric part from compound names in LowTable and current compound
            LowTableNumbers = cellfun(@(x) str2double(regexp(x, '\d+', 'match', 'once')), LowTable{:,1});
            currentCompoundNumber = str2double(regexp(compoundName, '\d+', 'match', 'once'));
            
            % Find the largest number less than or equal to the current compound number
            closestIndex = find(LowTableNumbers <= currentCompoundNumber, 1, 'last');
            
            if ~isempty(closestIndex)
                Zug = false(size(LowTableNumbers));  % Reset Zug to all false
                Zug(closestIndex) = true;  % Set the closest match to true
            end
        end
        
        if any(Zug)
            if AreaData{5,i} < LowTable{Zug,7}
                AreaData{9,i} = (AreaData{5,i} - LowTable{Zug,4}) / LowTable{Zug,3};
            else
                AreaData{9,i} = (AreaData{5,i} - HighTable{Zug,4}) / HighTable{Zug,3};
            end
        end
    end


    % Isomerization
    % take all the C% into one batch and take the ratio of the main to the
    % whole
    % Here we have to find a way to tell logically which one the main one is if
    % the "main" peak is not in the range of data
    % for i = 1:length(mean_val)
    %     match = regexp(AreaData{8,i}, '^[^-]*', 'match');
    %     match1 = regexp(AreaData{8,i}, '^[^-]*', 'match');
    %     match2 = regexp(AreaData{8,i}, '^[^-]*', 'match');
    % end
    
    %%
    % Initialize a map to store the sums by family
    sums_by_family = containers.Map;
    
    % Loop through each label and corresponding value
    for i = 1:length(mean_val)
        label = cell2mat(AreaData{8,i});
        if isempty(AreaData{9,i})
            AreaData{9,i} = 0;
        end
        % Extract the family prefix (everything up to the first space or '-')
        family_prefix = regexp(label, '^[^\s-]+', 'match', 'once');
        
        % If the family prefix is already in the map, add the value to the existing sum
        if isKey(sums_by_family, family_prefix)
            sums_by_family(family_prefix) = sums_by_family(family_prefix) + AreaData{9,i};
        else
            % Otherwise, create a new entry for this family prefix
            sums_by_family(family_prefix) = AreaData{9,i};
        end
    end
    
    % Display the summed values by family
    family_names = keys(sums_by_family);
    summed_values = values(sums_by_family);
    
    % for i = 1:length(family_names)
    %     fprintf('Family %s: Total Value = %d\n', family_names{i}, summed_values{i});
    % end
    
    %% Ratio
    Ratio = cell(1,length(mean_val));
    for i = 1:length(mean_val)
        match = regexp(AreaData{8,i}, '^[^-]*', 'match');   
        zuger = ismember(family_names,match{1});
        if any(zuger) && contains(AreaData{8,i},'main')
            Ratio{i} = 100*AreaData{9,i}/summed_values{zuger};
        end
    end
    AreaData = [AreaData; Ratio];
    %% adding legend to AreaData
    Info = {'Area Chrom. 1'; 'Area Chrom. 2'; 'Area Chrom. 2'; 'Mean Peak Location'; ...
        'Mean Area'; 'Standard Deviation'; 'Ratio STD/MA in %'; 'Compound'; ...
        'Concentration'; 'Ratio Main Comp to Sum Comp'};
    AreaData = [Info, AreaData];
    %% Display Data in visually pleasing format
    AreaData = AreaData';
    
    %% Unnest AreaData cell array
    unnestedAreaData = cell(size(AreaData));  % Initialize the output cell array
    
    for i = 1:numel(AreaData)
        if iscell(AreaData{i}) && numel(AreaData{i}) == 1
            % If the element is a single cell, extract the content
            unnestedAreaData{i} = AreaData{i}{1};
        else
            % If not, leave it as is
            unnestedAreaData{i} = AreaData{i};
        end
    end
    
    %% Sum rows of data if they belong to the same compound and perform easy calculations
    % save it as a new Cell that is compatible with Lilianas Excel sheet
    % and add a choice what format she wants
    % for ii = 1:size(AreaData,2)
    %     %if nnz(ismember())
    %     %end
    % end
    strings = cellfun(@(x) x{1}, AreaData(2:end, 8), 'UniformOutput', false);
    strings = cellfun(@(x) regexp(x, '^[^-]*', 'match', 'once'), strings, 'UniformOutput', false);
    numbers = cell2mat(AreaData(2:end,9));
    [uniqueStrings, ~, idx] = unique(strings);
    summedNumbers = zeros(length(uniqueStrings), 1);
    for i = 1:length(uniqueStrings)
        summedNumbers(i) = sum(numbers(idx == i));
    end
    result = [uniqueStrings, num2cell(summedNumbers)];
    orderList = ["mesitylene", "C4", "C6", "C8", "C9", "C10", "C11", "C12", "C13", ...
             "C14", "C15", "C16", "C17", "C18", "C19", "C20", "C21", "C22", ...
             "C23", "C24", "C25", "C26", "C27", "C28", "C29", "C30", "C31", "C32", "Acetonitrile"];
    resultOrdered = 0; % order the result cell by the logic in orderList
    %% Export Results as xlsx Format for Metafuels
    if QSave
        filename = SaveAs;   % Name of the existing Excel file
        sheetname = 'Sheet1';              % Name of the sheet to write to
        range = 'B2';                      % Top-left corner of where to write the data
        
        writecell(unnestedAreaData, filename, 'Sheet', sheetname, 'Range', range);
    end
end