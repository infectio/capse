% Input
% intensityRates:    (x,2) cell structure, where the first index is the
%                    value at initial infection 
%                    the second value is the table with the
%                    intensity rate increases
%                    NB: ASSUMES time increments same!
% initialInfectionValue:  value of particles at the initial time
%                         the cell became infected
%
% Output
% interpolateIntensityRate:  Interpolated matrix of the rate of
%                            intensities between the two closest
%                            initialInfectionValues from the
%                            intensityRates table

function rateInterpolation = ...
    interpolateIntensityRate(intensityRates, initialInfectionValue, ExtrapolationFlag)
    
    %first find the two values closest between
    intensityRateHigher = inf;
    intensityRateLower  = 0;  
    intensityRateHigherInd = 0;
    intensityRateLowerInd = 0;
    
    %maximum value of initial infection
    maxInitialInfection = max(cell2mat({intensityRates{:,1}}));
    %the index value that this occurs at
    maxInitialInfectionInd = find(cell2mat({intensityRates{:,1}}) == maxInitialInfection);
    
    %initialize this to the min to find the 2nd highest initial infection
    %value for extrapolations
    secondMaxInitialInfection = min(cell2mat({intensityRates{:,1}}));
    secondMaxInitialInfectionInd =  find(cell2mat({intensityRates{:,1}}) == secondMaxInitialInfection);
    
    for in=1:size(intensityRates,1)
        
        % find the values above and below the initial Inf value
        if(intensityRates{in,1} >= initialInfectionValue ...
           && intensityRates{in,1} < intensityRateHigher)
            intensityRateHigher = intensityRates{in,1};
            intensityRateHigherInd = in;
        end
        if (intensityRates{in,1} <= initialInfectionValue ...
                && intensityRates{in,1} > intensityRateLower)
            intensityRateLower = intensityRates{in,1};
            intensityRateLowerInd = in;
        end
        
        % find the 2nd highest inf value for extrapolation
        if(intensityRates{in,1} > secondMaxInitialInfection && ...
                intensityRates{in,1} < maxInitialInfection)
            secondMaxInitialInfection = intensityRates{in,1};
            secondMaxInitialInfectionInd = in;
        end
        
    end
    
    
    
    %initialize
    rateInterpolation = ...
        zeros(size(intensityRates{maxInitialInfectionInd,2}));
    
    
    if(initialInfectionValue >= maxInitialInfection)
        % do we do a linear interpolation or do we take the last value
        if ExtrapolationFlag
            time = intensityRates{maxInitialInfectionInd,2}(:,1);
            rateInterpolation(:,1) = time;
            for ii = 1:length(time)
                yi = [intensityRates{secondMaxInitialInfectionInd,2}(time(ii),2),...
                     intensityRates{maxInitialInfectionInd,2}(time(ii),2)];
                xi = [intensityRates{secondMaxInitialInfectionInd,1},...
                     intensityRates{maxInitialInfectionInd,1}];
                rateInterpolation(ii, 2) = interp1(xi, yi, initialInfectionValue,'linear','extrap');
                % don't let it go above 1 or below 0
                rateInterpolation(ii, 2) = max(0, min(1, rateInterpolation(ii, 2)));                  ;
            end
            return
        else
            intensityRateHigherInd = maxInitialInfectionInd;
        end
       
    end
   intensityRateLowerInd = max(1, intensityRateLowerInd);
    
    %fprintf('InitialInfectionValue: %f, indH: %d, indL%d \n',initialInfectionValue,...
    %        intensityRateHigherInd,intensityRateLowerInd);
    %must do a check to make sure the time-course data is the same
    %length
    if(length(intensityRates{intensityRateHigherInd,2}) ~= ...
              length(intensityRates{intensityRateLowerInd,2}))
        fprintf('Error: Intensity Rate Increase time-course data is not the same length.\n');
        rateInterpolation = 0;
        return;
    end
    
    
  
    if(intensityRateHigherInd == intensityRateLowerInd)
        rateInterpolation = intensityRates{intensityRateHigherInd, 2};
        return 
    end
    
    %now must interpolate between the values
    mixingFactor = (initialInfectionValue-intensityRateLower)/ ...
        (intensityRateHigher-intensityRateLower);
    if (mixingFactor > 1 || mixingFactor < 0)
        error('Abnormal mixing factor!')
    end
    
    rateInterpolation(:,1) = intensityRates{intensityRateHigherInd,2}(:,1);
    
    rateInterpolation(:,2) = mixingFactor* ...
        intensityRates{intensityRateHigherInd,2}(:,2);
    rateInterpolation(:,2) = rateInterpolation(:,2) + (1-mixingFactor)*...
        intensityRates{intensityRateLowerInd,2}(:,2);
    rateInterpolation(:,3) = 0;
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     Infectio - a virus infection spread simulation platform
%     Copyright (C) 2014-2015  Artur Yakimovich, Yauhen Yakimovich
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.