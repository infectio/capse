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

