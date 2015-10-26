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

