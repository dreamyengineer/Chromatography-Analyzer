function [yFits,beta,Rsquare,bestChoiceIndex] = FuncDeconvoluterNLinFitV03(x,y,pks,mean_val)
    %% Find Number of Peaks and relevant Metadata
    % finds the location of all relevant peaks (this is at the same time the mean value for the skewed gaussians 
    %[pks,mean_val] = findpeaks(y,x,'Threshold',Threshold);%'NPeaks',3);
    % Number of Peaks and hence number of Curves I want to approximate
    NumPeaks = length(mean_val);
    %disp(NumPeaks);
    % fittype of fit function
    skewedGauss = skewedGaussFunType(NumPeaks);
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    opts.Display = 'off';
    %StartPoint Vector to accelerate computation
    beta0 = genBeta0(pks,mean_val);
    %% Fitting the curves
    exceptionHandler = 0;
    try
        [beta{1},R] = nlinfit(x,y,skewedGauss,beta0,opts);
        expGaussChoice = false;
        SSres = sum(R.^2);
        SStot = sum((y-mean(y)).^2);
        Rsquare = 1 - SSres/SStot;
    catch ME
        %disp('Error encountered during fitting with first skewedGauss:');
        %disp(ME.message);
        Rsquare = NaN;
        exceptionHandler = 1;
        beta{1} = [0.001;0.001;0.001;0.001];
    end
    Rsquare2 = 0; Rsquare3 = 0; Rsquare4 = 0; Rsquare5 = 0;
    if Rsquare < 0.97 
        expGauss = ExpModGaussianFunTypeV01(NumPeaks);
        try
            % First fitting attempt
            [beta{2}, R] = nlinfit(x, y, expGauss, beta0, opts);
            SSres = sum(R.^2);
            Rsquare2 = 1 - SSres / SStot;
        catch ME
            % Handle the error
            %disp('Error encountered during fitting with first expGauss:');
            %disp(ME.message);
            Rsquare2 = NaN;
        end
        expGaussChoice = true;
        if Rsquare < 0.97 || Rsquare2 < 0.97
            beta0 = genBeta0(pks*1.2,mean_val*1.1);
            try
                [beta{3}, R] = nlinfit(x, y, expGauss, beta0, opts);
                SSres = sum(R.^2);
                Rsquare3 = 1 - SSres / SStot;
            catch ME
                %disp('Error encountered during fitting with subsequent expGauss:');
                %disp(ME.message);
                Rsquare3 = NaN;
            end
            if Rsquare < 0.97 || Rsquare2 < 0.97 || Rsquare3 < 0.97
                [beta{4},R] = nlinfit(x,y,skewedGauss,beta0,opts);
                SSres = sum(R.^2);
                Rsquare4 = 1 - SSres/SStot;
                expGaussChoice = false;
                if Rsquare < 0.97 || Rsquare2 < 0.97 || Rsquare3 < 0.97 || Rsquare4 < 0.97
                    beta0 = genBeta0(pks*0.8,mean_val*0.9);
                    [beta{5},R] = nlinfit(x,y,skewedGauss,beta0,opts);
                    SSres = sum(R.^2);
                    Rsquare5 = 1 - SSres/SStot;
                end
            end            
        end        
    end
    [Rsquare,bestChoiceIndex] = max([Rsquare,Rsquare2,Rsquare3,Rsquare4,Rsquare5]);
    if exceptionHandler==1
        beta=beta{1};
    else
        beta = beta{bestChoiceIndex};
    end
    %% finding coefficients and creating a yFits
    yFits = generateFits(beta,x); % pay attention, this is only for skew Gauss, own written function
end
