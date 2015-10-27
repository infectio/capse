import caps.visual.plot.*;


% CA realted
dt_CA = 1;  % dt for cellular automata in hours 

%!!!warning a bug in the cellSize parameter dimension error for certain values
% for now we set it to be 22um, which works
cellSize = 22; % Size in um; (for A549 cells it was 24um, for the BSC40 we put 21)

% virus production parameters
virusSpread = struct();
if strcmp(virusType, 'VACV-IHD-J')
    virusSpread.cellAssociatedWeight = 10; 
    virusSpread.cellFreeWeight = 1;
    % Sigmoidal growth Equation Parameters, see wikipedia
    virusSpread.bottom = 1.995e-16;
    virusSpread.top = 3.426;
    virusSpread.EC50 = 1.616e18;
    virusSpread.slope = 0.3036;
    % Plaque growth speed in um/h will be divided by cell size to get time
    % it takes to infect neighbor cell via cell2cell mechanism
    virusSpread.cell2CellTime = cellSize/17.07;
elseif strcmp(virusType, 'VACV-WR')
    virusSpread.cellAssociatedWeight = 10; 
    virusSpread.cellFreeWeight = 0.01;
    % Sigmoidal growth Equation Parameters, see wikipedia
    virusSpread.bottom = 1.995e-16;
    virusSpread.top = 3.426;
    virusSpread.EC50 = 1.616e18;
    virusSpread.slope = 0.3036;
    % Plaque growth speed in um/h will be divided by cell size to get time
    % it takes to infect neighbor cell via cell2cell mechanism
    virusSpread.cell2CellTime = cellSize/19.66;
end


if strcmp(virusType, 'HAdV-E3B') || strcmp(virusType, 'HAdV-E1B')
    % Size in um;
    virusSize = 0.09; 
    
    % Fraction of SPs (after 113.5 hpi) per initially infected cell (after 
    % 23.5 hpi) devided by time interval, measure for E3B virus; (for AdV 
    % it was 0.074/(113.5-23.5), )
    ProbabilityOfSecondaryLysis = 0.074/(113.5-23.5); 
    
    % Time after lysis of first generation of infected cells is:
    % time after cell encountered the virus till the point it will lyse (for
    % AdV it was 72-48 hours post infection, for VACV we set it to the
    % inifinity - 10000, since we never observed the secondary lysis within
    % experiment time)
    timeToLyse = 24; % in hours
    
elseif strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
    % Size in um;
    virusSize = 0.27; 
    
    % for VACV we set it to 0
    ProbabilityOfSecondaryLysis = 0; 
    
    % lysis timer takes inf. long to end
    timeToLyse = 10000; 
end

neighbourInfectionProbabilities = 1;  % not implemented yet. this will need to be added to the script for sens testing (for AdV it was 0 - no c2c spread, for VACV it is always 1 and limited only by the speed of the spread)
cellularInfectionThreshold = 0.01; % amount of virus per cell at which cells become infected

% These parameters stay default for most of the viruses
% DEPRECATED: use CAGridDimensions struct.
stateDim = 1; % state dimension index
infClockDim = 2; % infection clock dimension index - a timer after cell was infected
virusAmtDim = 3; % virus amount dimension index
infTimeDim = 4; % infection time dimension index
infListDim = 5; % infection/infected list dimension index
strengthDim = 3; % PSE == CA plains of infection
% Dimension map to grid indexes.
CAGridDimensions = struct(... 
    'state', stateDim, ...
    'infectionClock', infClockDim, ...
    'virusAmount', virusAmtDim, ...
    'infectionTime', infTimeDim, ...
    'infectionList', infListDim, ...
    'strength', strengthDim ...
);


% PSE related
if strcmp(virusType, 'HAdV-E3B') || strcmp(virusType, 'HAdV-E1B')
    pseThreshold = 25;  % this is the threshold for the difference in theoretical particles
elseif strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
    pseThreshold = 0.00001;  % this is the threshold for the difference in theoretical particles
end

advectionspeed = 0.499;  % advectionspeed

if strcmp(virusType, 'HAdV-E3B') || strcmp(virusType, 'HAdV-E1B')
    % amount of virus egressing by lysis from each infected cell
    virionLysed = 10000;
    % diffusion constant, in um^2/s (AdV: 6.47um^2/s)
    D = 6.47;    
    % cell2cell spread is upsent
    initialC2cInfection = 0;
    % When where the probabilities of infection measured (hours post 
    % infection). THis value is needed to obtain the probabilities for
    % each dt_CA
    timepointOfProbabilitiesMeasurement = 72;
elseif strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
    % lysis never happens and there is no egress?
    virionLysed = 0;
    % VACV:1,22um^2/s
    D = 1.22;
    % cell2cell spread 
    initialC2cInfection = 1;
    % When where the probabilities of infection measured (hours post 
    % infection). THis value is needed to obtain the probabilities for
    % each dt_CA
    timepointOfProbabilitiesMeasurement = 12;
end


% Area of cell um^2
[cellX cellY] = unitHexagonAt(1,1);
y_scaling_factor = max(cellY) - min(cellY);
cellX = cellSize*cellX;
cellY = cellSize*cellY;
cellArea = polyarea(cellX, cellY);

% For the CA grid, height and width of the hexagonal cells
cellWidth = cellSize;
cellHeight = cellSize*y_scaling_factor;
    
% Number of cells
cells_x = 50; %normally 200, for debug purposes 30 or 50 - defines the model size
%cells_x = 20;
cells_y = ceil(cells_x*y_scaling_factor);
nCells = cells_x*cells_y;

% Number of cells infected from beginning, currently not implemented
%nInfCellsStart = 1; 

% Total time steps for the model to run in hours post infection
TotalTimeStepsHPI = 60; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters import from external files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(virusType, 'HAdV-E3B')
    infProbfile = [caps.path.root fullfile('input', 'parameters', 'paper_params','100617_TNAP_probabilities_calculation_E3B_exported.csv')];
    intRateIncrfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '100524_TNAP_intesity_rate_increase_E3B_exported.csv')];
elseif strcmp(virusType, 'HAdV-E1B')
    infProbfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '101002_TNAP_probabilities_calculation_E1B_exported.csv')];
    intRateIncrfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '101002_TNAP_intesity_rate_increase_E1B_exported.csv')];
elseif strcmp(virusType, 'VACV-IHD-J')
    infProbfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '130620_probability-IHDJ.csv')];
    intRateIncrfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '130620_Intensity-rate-increase-IHDJ-interpolated.csv')];
elseif strcmp(virusType, 'VACV-WR')
    infProbfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '130620_probability-WR.csv')];
    intRateIncrfile = [caps.path.root fullfile('input', 'parameters', 'paper_params', '130620_Intensity-rate-increase-WR-interpolated.csv')];
else
    error('The virus type specified is unknown and there are no parameters for it.');
end

infectionProbabilities = csvread(infProbfile);
infectionProbabilities = infectionProbabilities(infectionProbabilities(:,2) > 0, :);
lowestInfectionThreshold = min(infectionProbabilities(:, 1));

% Neighbourhood infection probabilities -- to help show it's just the cell-free


% Intensity rate increases
intensityRates = readIntensityRate(intRateIncrfile);
if strcmp(virusType, 'HAdV-E3B') || strcmp(virusType, 'HAdV-E1B')
    if strcmp(OutputMedia, 'Images')
       intensityRatesNormalised = normalizeIntensityRates(intensityRates);
    else % For 'RDF' or empty string ( = Animation is turned off).
       intensityRatesNormalised = intensityRates;
    end
else
    %intensityRatesNormalised = readIntensityRate(intRateIncrfile);
    intensityRatesNormalised = intensityRates;
end
backgroundIntensity = mean(intensityRatesNormalised{end, 2}(:,2));
if strcmp(virusType, 'VACV-IHD-J') || strcmp(virusType, 'VACV-WR')
    % for display purposes we will normalize all the intensity to the
    % maximum observable in the experimental data, since it's in the cell
    % array we need a for loop
    
    if strcmp(OutputMedia, 'Images')
     intensityRatesNormalised = normalizeIntensityRates(intensityRates);
     intensityRates = intensityRatesNormalised;
    end
    backgroundIntensity = 0;
end


% Cell death statistics
cellDeathProbFile = [caps.path.root fullfile('input', 'parameters', 'paper_params', 'CellDeathProbabilities_exported.csv')];
cellDeathFractions = csvread(cellDeathProbFile);


% Wait for key stroke or user input after every iteration
pauseOnCAIterations = true; 
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