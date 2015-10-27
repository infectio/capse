function [automaton partMat] = infectCells(automaton, virusFlags, partMat, infection)

import caps.cells.ca.determineIfCellsBecomeInfected; % cell-free
import caps.cells.ca.spreadCell2Cell; % cell-to-cell
import caps.cells.ca.updatePreliticVirusProgenyAmount;


% Cell-free spread
if virusFlags.isCellFreeSpreadEnabled
    [automaton.grid newlyInfectedCells] = determineIfCellsBecomeInfected(...
        automaton.grid, ...
        automaton.dimension.virusAmount, ...
        automaton.dimension.state, ...
        automaton.dimension.infectionList, ...
        automaton.dimension.infectionClock, ...
        automaton.infectionProbabilities, ...
        automaton.neighbourInfectionProbabilities, ...
        automaton.cellArea, automaton.cellStates, ... 
        automaton.latentPeriod, length(automaton.infectedCells));

    automaton.infectedCells = addToInfList( ...
        automaton.infectedCells, ...
        newlyInfectedCells, ...
        automaton.intensityRatesNormalised, ...
        automaton.grid, ... 
        automaton.dimension.virusAmount, ...
        virusFlags.isExtrapolationEnabled);
    
    
end

% Cell-to-cell spread
if virusFlags.isCell2CellSpreadEnabled
    automaton = spreadCell2Cell(automaton, infection, virusFlags);
end


% Update virus amount.
if virusFlags.isPrelyticVirusProductionEnabled
    [automaton partMat] = caps.cells.ca.updatePreliticVirusProgenyAmount(automaton, virusFlags, partMat, infection);
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
