%
% Intensity data resorting for Surface Fitting tool
%

%% Create structures 
intensityAllValues = meanIntensity(1,1);
timeAllValues = time(1);
virusConcentrationAllValues = virusConcentration(1);

%% Main loop
for itime=2:length(time)
    for ivirusConcentration=2:length(virusConcentration)
        
        intensityAllValues = vertcat(intensityAllValues,meanIntensity(ivirusConcentration,itime));
        timeAllValues = vertcat(timeAllValues,time(itime));
        virusConcentrationAllValues = vertcat(virusConcentrationAllValues, virusConcentration(ivirusConcentration));
    end
end