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