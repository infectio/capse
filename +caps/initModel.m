import caps.cells.ca.*;
import caps.visual.plot.*;


%%% CA Model Parameters %%%

states = struct('EMPTY', 0, 'HEALTHY', 1, 'INFECTED', 2, 'LYSED', 3, 'DEAD', 4);

%probMove = 0;      % not dealing with moving cells yet
%probInf  = 0.1;    RDF_plotting
%cellCutOff = 3;    % currently how many "cells" away a neighbour can
                    % be, will need to be a physical distance
                    % OR will not be needed since the PSE model
                    % will take into account how far the virus will
                    % go

latentPeriod = [lyseStart, lyseEnd]*24; % how long a cell stays infected before lysis
                    % in hours

%%% initialize CA CAGrid %%% 
numOfCells = struct('x', cells_x, 'y', cells_y);
[CAGrid,  inf_list] = initCA( ...
    numOfCells, ...
    states, ...
    timeToLyse, ...
    infectionProbabilities, ...
    intensityRatesNormalised, ...
    CAGridDimensions, ...
    virusFlags ...
);

%%% PSE Model Parameters %%%
[width height] = unitHexagonAt(1, size(CAGrid,2));
modelSize = [cells_x*cellWidth+1/2*cellWidth cellSize*height(1)];
 

lBounds = 0; 
uBounds = max(modelSize(1), modelSize(2));

% approximately 9 particles per cell - ~ one every 10nm
% added some extra for outer layer of hexagons
nParts = round(sqrt(9*(nCells+cells_x+cells_y)))^2;        

h = (uBounds-lBounds)/(nParts^(1/2)-1); % distance between particles
epsilon = h; % machine epsilon

% Particle volume
V = ones(nParts^(1/2),nParts^(1/2))*h^2;

cutOff = 8*epsilon; % changes from 3 to 8 epsilon, as in PSE convergence validation


%%% Simulation Parameters %%%
dt_CA_seconds = dt_CA*3600; %conversion to seconds for PSE
%TODO: check if dt_PSE is correct, i.e. maybe dt_PSE = h/(2*D) as for 2 dimensions?
dt_PSE = h^2/(3*D);  %Stability criterion for Euler dt < h^2/(2*D)
%now to have dt_PSe divisible by dt_CA
PSEstepsPerCA = ceil(dt_CA_seconds/dt_PSE);
dt_PSE = dt_CA_seconds/PSEstepsPerCA;

%length (in hours) of simulation
timeSteps_CA = (TotalTimeStepsHPI)/dt_CA;

%now must correct for the infection probabilities
%now that we know how many time steps there will be

%Here we divide the final infection probability by each time step of CA
infectionProbabilities(:,2) = infectionProbabilities(:,2)./(timepointOfProbabilitiesMeasurement/dt_CA);
% add a first entry of all alive for t=0
cellDeathFractions(2:end+1, :) = cellDeathFractions(1:end, :); 
cellDeathFractions(1, :) = [0 cellDeathFractions(2, 2)];
% repeat last entry 
cellDeathFractions(end+1, :) = [timeSteps_CA cellDeathFractions(end, 2)];  % repeat last entry for interpolation
    

%%% initialize PSE %%%

%Create particle positions: (X,Y) columns of particle positions
[partPos, cellMid, numPerDim] = caps.particles.pse.createParticles(nParts, lBounds, uBounds);
% Particle matrix consits of three columns with each row being 
% (x-coor, y-coor, particle-weight)
partMat = [partPos zeros( size(partPos, 1), 1)]; 
%Create Verlet list
verletList = caps.particles.pse.createVerletListnlogn(partPos, cutOff, lBounds, uBounds);

% Not used in PSE?
% Determine max index value using number of particles
% numParticles = length(partMat);
% sizeInBits = ceil(log2(numParticles));
% if sizeInBits <= 8
%     verletListIndexType = 'uint8';
% elseif sizeInBits <= 16
%     verletListIndexType = 'uint16';
% elseif sizeInBits <= 32
%     verletListIndexType = 'uint32';
% else 
%     verletListIndexType = 'uint64';
% end
% for ind = 1:numParticles
%     eval(['verletList{ind} = ' verletListIndexType '(verletList{ind});']);
% end

%%% initialize CA-PSE %%%

%Create 'Verlet List' for the CA Cells
[cellAreaList, partAreaList] = createAreaLists([size(CAGrid,1) ... 
                    size(CAGrid,2)], partMat, cellSize, h);

%%% Make Directory for Saved State Variables %%%
if (caps.utils.runningGUI)
    global outputFolder;
    simResDir = outputFolder ;
else
    simResDir = strcat(OutputPrefix, 'output/simulationResults/', date, '-', num2str(now),'-',simulationFileName);
    mkdir(simResDir);
end

if Sensors
    Sensorsdir =[simResDir, '/Sensors/'];
    mkdir(Sensorsdir);
end
%imgsDir = strcat('gimgs/', date);
%mkdir(imgsDir);
intDir = strcat(simResDir, '/int_');
imgsDir = strcat(simResDir, '/CA_PSE_');

%%% For RDF Stuff %%%

%make the "pixel list%
numPixels = (modelSize(1)/9)*(modelSize(2)/9);
pixelList = createPixelList(numPixels, modelSize, [size(CAGrid,1) size(CAGrid,2)], cellSize);
pixelSpacing = pixelList(2, 2) - pixelList(1,2); % this is for scaling the RDF to correct physical size later
