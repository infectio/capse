function automaton = infectSingleCell( ...
        automaton, ... 
        position, ...        
        infection, ...
        infectionLevel)

    if ~iscell(position)
        position = num2cell(position);
    end
    [x y] = position{:};
    
    intensityRate = interpolateIntensityRate(infection.intensityRates, infectionLevel, true);
    
    stateDim = automaton.dimension.state;
    infectionList = automaton.dimension.infectionList;
    virusAmountDim = automaton.dimension.virusAmount;
    infectionTime = automaton.dimension.infectionTime;
    infectionClock = automaton.dimension.infectionClock;
    automaton.grid(x, y, stateDim) = automaton.cellStates.INFECTED;
    automaton.grid(x, y, infectionList) = size(automaton.infectedCells,1) + 1;
    automaton.grid(x, y, virusAmountDim) = infectionLevel;
    automaton.grid(x, y, infectionTime) = infection.initialTime;
    automaton.grid(x, y, infectionClock) = infection.initialClock;

    automaton.infectedCells{end + 1}.x = x;
    automaton.infectedCells{end}.y = y;
    automaton.infectedCells{end}.initInfVal = infectionLevel;
    automaton.infectedCells{end}.intRate = intensityRate;
    automaton.infectedCells{end}.valid = true;
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