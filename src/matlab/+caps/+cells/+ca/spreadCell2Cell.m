function [automaton newlyInfectedCells] = spreadCell2Cell(automaton, infection, virusFlags)
%SPREADCELL2CELL Simulate cell-to-cell viral spread.
%   Use CA as an input to simulate cell-to-cell viral spread.

import caps.cells.ca.getNeighbours;
import caps.cells.ca.infectSingleCell;
import caps.cells.ca.producePrelyticVirus;


newlyInfectedCells = cell(0,2);
infectionTimeDim = automaton.dimension.infectionTime;

% Walk through a shorthand of infected lists
for iCell = 1:numel(automaton.infectedCells)
    infectedCell = automaton.infectedCells{iCell};
    cellInfectionTime = automaton.grid( ...
        infectedCell.x, infectedCell.y, infectionTimeDim);
    neighbours = getNeighbours(automaton, infectedCell.x, infectedCell.y);
    for iNeighbour = 1:size(neighbours, 1)
        % infect each neighbour
        [x y] = neighbours{iNeighbour, :};
        if isAlreadyInfected(automaton, x, y)
            continue
        end
        % Spread of prelytic Cell Associated virions happens in the 
        % updateVirusAmount function, here we decide based on it whther the
        % neighbor cells will be infected
        
        if virusFlags.isSpreadCell2CellLimitedByTime && cellInfectionTime < infection.virusSpread.cell2CellTime
            % Do not infect! - too early
            continue
        end
        nCellVirusAmount = automaton.grid(x, y, automaton.dimension.virusAmount);
        if virusFlags.isSpreadCell2CellLimitedByVirusAmount && nCellVirusAmount < infection.cellularThreshold
            % Do not infect! - not enough virus
            continue
        end
        
        if virusFlags.isSpreadCell2CellLimitedByTime %|| cellInfectionTime == 0
            automaton = infectSingleCell(automaton, {x, y}, infection, infection.initialLevel);
        elseif virusFlags.isSpreadCell2CellLimitedByVirusAmount
            automaton = infectSingleCell(automaton, {x, y}, infection, nCellVirusAmount);
            newlyInfectedCells(end + 1, :) = {x, y};
        end
    end
end

end

function res = isAlreadyInfected(automaton, x, y)

for iCell = 1:numel(automaton.infectedCells)
    infectedCell = automaton.infectedCells{iCell};
    if infectedCell.x == x && infectedCell.y == y
        res = true;
        return
    end
end
res = false;

end