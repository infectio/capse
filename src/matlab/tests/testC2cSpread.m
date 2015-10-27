function testC2cSpread
% Test neighbourhood

S = load(fullfile(caps.path.root, 'tests', 'mock_automaton.mat'));
automaton = S.automaton;
S = load(fullfile(caps.path.root, 'tests', 'mock_intrates.mat'));
intensityRates =  S.intensityRates;

% params
x = 10;
y = 12;
backgroundIntensity = 0.1;
cellSize = 22;
initialInfection = 10;

% check n-hood for first infected cell
neighbours = caps.cells.ca.getNeighbours(automaton, x, y);

% infect neighbour
for iNeighbour = 1:size(neighbours, 1);
    [xp yp] = neighbours{iNeighbour, :};
    automaton = infectSingleCell(automaton, {xp, yp}, initialInfection, intensityRates);
end

% test by drawing
hg = caps.visual.plot.visualize( ...
    automaton.grid, ...
    [], ...
    automaton.infectedCells, ...
    cellSize, ...
    automaton.dimension.state, ...
    automaton.dimension.infectionList, ...
    automaton.dimension.infectionTime, ...
    false, ...
    backgroundIntensity);
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
