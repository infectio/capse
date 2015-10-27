function [ grid ] = determineIfCellsDie(grid, time, cellDeathFractions, stateDim, states)

% number of cells in the "dead" state
numDeadCells = 0;
for ii = 1:size(grid, 1)
    for jj = 1:size(grid, 2)
        if grid(ii, jj, stateDim) == states.DEAD
            numDeadCells = numDeadCells + 1;
        end
    end
end

% determine how many cells should be dead at this point
fractionCellsExpDead = interp1(cellDeathFractions(:,1), cellDeathFractions(:,2), time);

% scale based on the number of cells we have
cellsExpDead = round(fractionCellsExpDead*size(grid,1)*size(grid,2));


cellsToDie = cellsExpDead - numDeadCells;

if cellsToDie > 0
    % now we pick random cells to die - muahaha
    for ii = 1:cellsToDie 
        killedOne = false;
        
        %until we found a cell to kill
        while ~killedOne
            xcoord = randi(size(grid,1), 1);
            ycoord = randi(size(grid,2), 1);
            if grid(xcoord, ycoord, stateDim) == states.HEALTHY
                
                grid(xcoord, ycoord, stateDim) = states.DEAD;
                killedOne = true;
            end
        end
    end
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