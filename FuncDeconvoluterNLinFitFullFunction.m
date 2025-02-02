function [yFits,beta,Rsquare,bestChoiceIndex] = FuncDeconvoluterNLinFitFullFunction(x,y,StartPoints)
    %% Find relevant Metadata
    skewedGauss = skewedGaussFunType(length(StartPoints)/4);
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    opts.Display = 'off';
    warning('off','all');
    %% Fitting the curves
    [beta{1},R] = nlinfit(x,y,skewedGauss,StartPoints,opts);
    SSres = sum(R.^2);
    SStot = sum((y-mean(y)).^2);
    Rsquare{1} = 1 - SSres/SStot;
    %disp(StartPoints);
    if Rsquare{1} < 0.92 
        StartPoints(1:4:end) = abs(StartPoints(1:4:end));
        StartPoints(3:4:end) = abs(StartPoints(3:4:end));
        %disp(StartPoints);
        [beta{2},R] = nlinfit(x,y,skewedGauss,StartPoints,opts);
        SSres = sum(R.^2);
        Rsquare{2} = 1 - SSres/SStot;
        % i = 2;
        % maxIterations = 10;
        % while Rsquare{i} < 0.92 && i < maxIterations + 1
        %     StartPoints = StartPoints.*Randomizer(size(StartPoints));
        %     i = i +1;
        %     [beta{i},R] = nlinfit(x,y,skewedGauss,StartPoints,opts);
        %     SSres = sum(R.^2);
        %     Rsquare{i} = 1 - SSres/SStot;
        % end
    end
    Rsquare = cell2mat(Rsquare);
    [Rsquare,bestChoiceIndex] = max(Rsquare);
    beta = beta{bestChoiceIndex};
    %% finding coefficients and creating a yFits
    yFits = generateFits(beta,x); % pay attention, this is only for skew Gauss, own written function
end
