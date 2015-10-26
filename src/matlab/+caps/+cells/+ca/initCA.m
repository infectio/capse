function [ CAGrid,  inf_list] = initCA( ...
    numOfCells, ...
    states, ...
    timeToLyse, ...
    infectionProbabilities, ...
    intensityRatesNormalised, ...
    gridDimensions, ...
    virusFlags ...
)
%INIT Initialize CA GRID, etc.

    CAGrid = ones(numOfCells.x, numOfCells.y, 3);     %first field: state of the cell
    % TODO: maybe do 
    % CAGrid = zeros(cells_x, cells_y, 5);
    % CAGrid(:,:,1) = 1;
    CAGrid(:,:,2) = 0; %second field: the latent infection clock
    CAGrid(:,:,3) = 0; %third field: the max amount of virus
                     %the cell has encountered during a PSE
    CAGrid(:,:,4) = 0; %time since cell has become infected
    CAGrid(:,:,5) = 0; %inf_list index position

    inf_list = cell(0); % infection/infected list

    infPos = [ceil(numOfCells.x/2) ceil(numOfCells.y/2)]; % cell which will get infected first (beginning of the simulation)

    CAGrid(infPos(1), infPos(2), gridDimensions.state) = states.INFECTED;
    CAGrid(infPos(1), infPos(2), gridDimensions.infectionClock) = timeToLyse; 

    inf_list{1}.x = infPos(1);
    inf_list{1}.y = infPos(2);
    inf_list{1}.initInfVal = max(infectionProbabilities(:,1));
    % Intensity rate
    inf_list{1}.intRate = interpolateIntensityRate(intensityRatesNormalised, inf_list{1}.initInfVal, virusFlags.isExtrapolationEnabled);
    inf_list{1}.valid = true;

    CAGrid(infPos(1), infPos(2), gridDimensions.infectionList) = 1;
    %CAGrid(infPos(1), infPos(2), gridDimensions.infectionTime) = timeToLyse;
    CAGrid(infPos(1), infPos(2), gridDimensions.infectionTime) = 0;
    % Add the initial amount of virus for the cell we infect in the center of
    % the grid. So far, this value is used only for the prelytic virus production
    CAGrid(infPos(1), infPos(2), gridDimensions.virusAmount) = 1;
end
