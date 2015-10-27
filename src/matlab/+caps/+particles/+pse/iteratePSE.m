function [partMat, CAGrid] = iteratePSE( ...
    automaton, virusFlags, partMat, verletList, ...
    partAreaList, dt_PSE, ...
    pseThreshold, infectionThreshold, ...
    lBounds, uBounds, h, cutOff, epsilon, D, V, ...
    advectionspeed, cellMid, numPerDim,cellSize, pseDebugDir)
%ITERATEPSE diffuse -> advect -> remesh
%

CAGrid = automaton.grid;
dt_CA_seconds = automaton.dt*3600; % time in hours is converted to seconds
cellAreaList = automaton.cellAreaList;
strengthDim = automaton.dimension.strength;
virusAmtDim = automaton.dimension.virusAmount;
cellArea = automaton.cellArea;

%     %save the partMat to plot it later for the debug purposes
% if SavePrticlesPlotFlag
%      pseDebugDir = ['I:\Data\simulations\pse\', num2str(advectionspeed)];
%      mkdir(pseDebugDir)
% end
import caps.particles.pse.*;

numParts = length(partMat);

avgApplyPSETimer = 0;
for timeStep = 0:dt_PSE:dt_CA_seconds
    %display('advectionspeed:'); %-debug purpose
    %display(advectionspeed);
    
    %%check to see if all the virus strengths are below the
    % minimum infection threshold
    if(checkIfStrengthBelowThreshold(partMat, strengthDim, ...
            cellAreaList, cellArea, infectionThreshold, pseThreshold))
        fprintf('Stop PSE since virus is below neglectable threshold \n');
        %clear out the particles strengths since we're not going to run
        %this for ever and in the experimental system, it would eventually
        %go to nearly zero (and unrelevant)
        partMat(:,strengthDim) = 0;
        break;
    end
    
    %% Apply diffusion
    %startApplyPSE = tic;
    pseSum = caps.particles.pse.applyPSE(epsilon,strengthDim,length(partMat),partMat,verletList);
    %avgApplyPSETimer = mean([avgApplyPSETimer toc(startApplyPSE)]);
    
    % Apply the time step for particle strengths
    partMat(:,strengthDim) = partMat(:,strengthDim) + V(:).*D*dt_PSE./epsilon^2.*pseSum(:);
    
    
    %% Apply advection
    % Here if advection is ON we need to shift particles and their strength with given speed
    % to given direction.
    if virusFlags.isAdvectionEnabled
        [partMat, cellAreaList, partAreaList] = ...
            applyAdvection(partMat, dt_PSE, advectionspeed, lBounds, uBounds, h, ...
                           cutOff, cellMid, numPerDim, cellSize, CAGrid);
    end
    
    %% Save the partMat to plot it later for the debug purposes
    if virusFlags.saveParticles
        save([pseDebugDir, filesep,'pse',num2str(timeStep/dt_PSE),'.mat'], 'partMat', 'advectionspeed')
    end
    
    %% Add particle strengths back to CAGrid
    CAGrid =  updateMaxCellVirusAmount(partMat, CAGrid, partAreaList, ...
        strengthDim, virusAmtDim);    
end

% becnhmarking
%fprintf('iteratePSE:applyPSE took on avg %5.4f (sec)\n', avgApplyPSETimer * dt_CA_seconds);

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