function [automaton partMat] = updatePreliticVirusProgenyAmount(automaton, virusFlags, partMat, infection)

import caps.cells.ca.producePrelyticVirus;
import caps.cells.ca.getNeighbours;


% TODO vectorize this code
infectionTimeDim = automaton.dimension.infectionTime;
virusAmountDim = automaton.dimension.virusAmount;
gridWidth = size(automaton.grid, 1);

for iCell = 1:numel(automaton.infectedCells)
    infectedCell = automaton.infectedCells{iCell};
    cellInfectionTime = automaton.grid( ...
        infectedCell.x, infectedCell.y, infectionTimeDim); 
    infectedCellVirusAmount = automaton.grid(infectedCell.x, infectedCell.y, virusAmountDim);
    [cellAssociatedVirusAmount cellFreeVirusAmount] = producePrelyticVirus(infection.virusSpread, cellInfectionTime);
    
    if virusFlags.isCellFreeSpreadEnabled
        
        % Update cell-free virus accumulation.
        % Add virus particles to strengths of particles
        partMat = caps.particles.pse.addVirusToParticleStrengths( ...
            partMat, ...
            automaton.cellAreaList, ...
            [infectedCell.x infectedCell.y], ...
            cellFreeVirusAmount * infectedCellVirusAmount, ...
            gridWidth, ...
            automaton.dimension.strength);
        
    end
    
    if virusFlags.isCell2CellSpreadEnabled   && virusFlags.isVirusCell2CellSuperinfectionFlag     
        % Spread virus to each neighbour
        neighbours = getNeighbours(automaton, infectedCell.x, infectedCell.y);
        for iNeighbour = 1:size(neighbours, 1)
            [x y] = neighbours{iNeighbour, :};
            % Spread of prelytic Cell Associated virions happens in the
            % updateVirusAmount function, here we decide based on it whther the
            % neighbor cells will be infected
            previousAmount = automaton.grid(x, y, virusAmountDim);
            automaton.grid(x, y, virusAmountDim) = previousAmount + ...
                infectedCellVirusAmount * cellAssociatedVirusAmount / automaton.neighbourhoodSize;            
        end
    end
end

    
end



