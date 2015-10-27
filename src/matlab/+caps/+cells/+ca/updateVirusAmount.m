function [automaton partMat] = updateVirusAmount(automaton, virusFlags, partMat, infection)

import caps.cells.ca.producePrelyticVirus;

sizeOfNeighborhoodToInfect = 6;

% TODO vectorize this code
infectionTimeDim = automaton.dimension.infectionTime;
virusAmountDim = automaton.dimension.virusAmount;
gridWidth = size(automaton.grid, 1);

for iCell = 1:numel(automaton.infectedCells)
    infectedCell = automaton.infectedCells{iCell};
    cellInfectionTime = automaton.grid( ...
        infectedCell.x, infectedCell.y, infectionTimeDim); 
    
    [cellAssociatedVirusAmount cellFreeVirusAmount] = producePrelyticVirus(infection.virusSpread, cellInfectionTime);
           
    % Update cell-to-cell virus accumulation.
    % This has to be done in the neighborhood rather than a single cell
    
%     previousAmount = automaton.grid(infectedCell.x, infectedCell.y, virusAmountDim);
%     automaton.grid(infectedCell.x, infectedCell.y, virusAmountDim) = ...
%         previousAmount + cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;

     currentCellVirusAmount = automaton.grid(infectedCell.x, infectedCell.y, virusAmountDim);
     % Here we update virus amount in neighbors.
     % Outside of the grid virus will be discarded.
     
     if infectedCell.x-1 > 0 && infectedCell.y-1>0 && infectedCell.x+1<=size( automaton.grid,1) && infectedCell.y+1<=size( automaton.grid,2)
         % x-1, y neighbor
         previousAmount = automaton.grid(infectedCell.x-1, infectedCell.y, virusAmountDim);
         automaton.grid(infectedCell.x-1, infectedCell.y, virusAmountDim) = ...
             previousAmount + currentCellVirusAmount*cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;
         % x+1, y neighbor
         previousAmount = automaton.grid(infectedCell.x+1, infectedCell.y, virusAmountDim);
         automaton.grid(infectedCell.x+1, infectedCell.y, virusAmountDim) = ...
             previousAmount + currentCellVirusAmount*cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;
         % x, y-1 neighbor
         previousAmount = automaton.grid(infectedCell.x, infectedCell.y-1, virusAmountDim);
         automaton.grid(infectedCell.x, infectedCell.y-1, virusAmountDim) = ...
             previousAmount + currentCellVirusAmount*cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;
         % x, y+1 neighbor
         previousAmount = automaton.grid(infectedCell.x, infectedCell.y+1, virusAmountDim);
         automaton.grid(infectedCell.x, infectedCell.y+1, virusAmountDim) = ...
             previousAmount + currentCellVirusAmount*cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;
         % x-1, y+1 neighbor
         previousAmount = automaton.grid(infectedCell.x-1, infectedCell.y+1, virusAmountDim);
         automaton.grid(infectedCell.x-1, infectedCell.y+1, virusAmountDim) = ...
             previousAmount + currentCellVirusAmount*cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;
         % x-1, y-1 neighbor
         previousAmount = automaton.grid(infectedCell.x-1, infectedCell.y-1, virusAmountDim);
         automaton.grid(infectedCell.x-1, infectedCell.y-1, virusAmountDim) = ...
             previousAmount + currentCellVirusAmount*cellAssociatedVirusAmount / sizeOfNeighborhoodToInfect;
     else
         continue;
     end
     
    % Update cell-free virus accumulation.
    % Add virus particles to strengths of particles
    partMat = caps.particles.pse.addVirusToParticleStrengths( ...
        partMat, ...
        automaton.cellAreaList, ...
        [infectedCell.x infectedCell.y], ...
        cellFreeVirusAmount * previousAmount, ...
        gridWidth, ... 
        automaton.dimension.strength);
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