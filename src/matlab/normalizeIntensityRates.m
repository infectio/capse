function intensityRatesNormalized = normalizeIntensityRates2(intensityRates)
% This function rescales intensities based on experimental data solely for
% the visualization properties
   
%% Find max throw all the rows
  numberOfRows = length(intensityRates(:,1));
  % Preallocate matrix for local maxima
  localMaxima = zeros(size(numberOfRows));
  for iRow=1:numberOfRows
      localMaxima(iRow) = max(intensityRates{iRow,2}(:,2));
  end
%% Find global maximum
maxIntensity = max(localMaxima);

%% Normalize all rows by the global maximum
      % Preallocating target array
      intensityRatesNormalized = intensityRates;
  for iRow=1:numberOfRows
      intensityRatesNormalized{iRow,2}(:,2) = intensityRatesNormalized{iRow,2}(:,2)/maxIntensity;
  end

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
