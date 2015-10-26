InFile = 'D:\PhDProject\130711_fitting_intensity_rate_increase\130715_experimental_values_vacv.mat';
OutFile = 'D:\PhDProject\caps\src\matlab\input\parameters\paper_params\130620_Intensity-rate-increase-IHDJ-interpolated.csv';

load (InFile)

InterpolatedTime = 1:12;
InterpolatedVirusConcentration = virusConcentrationIHDJ(1:12);
%InterpolatedVirusConcentration = virusConcentrationWR;
intensityMatrix = reshape(intensityIHDJ,length(InterpolatedVirusConcentration),length(timeIHDJ)/length(...
    InterpolatedVirusConcentration));

%% Get the interpolated intensity matrix
Y = unique(virusConcentrationIHDJ);
X = unique(timeIHDJ);
InterpolatedIntensity = interp2(X, Y, intensityMatrix, InterpolatedTime,...
    InterpolatedVirusConcentration, 'linear');

%% Plot interpolated
surface(InterpolatedIntensity);

%% Get the table to export into the .csv file
InterpolatedTimeColumn = repmat(InterpolatedTime,1,length(...
    InterpolatedVirusConcentration));
InterpolatedVirusConcentrationColumn = [];
for i=1:length(InterpolatedVirusConcentration)
    InterpolatedVirusConcentrationColumn = [InterpolatedVirusConcentrationColumn, repmat(...
        InterpolatedVirusConcentration(i), 1, length(InterpolatedTime))];
end
InterpolatedIntensityColumn = reshape(InterpolatedIntensity', 1, size(...
    InterpolatedIntensity,1)*size(...
    InterpolatedIntensity,2));

%% export the table into the .csv file
csvwrite(OutFile,[InterpolatedVirusConcentrationColumn', InterpolatedTimeColumn', InterpolatedIntensityColumn']);