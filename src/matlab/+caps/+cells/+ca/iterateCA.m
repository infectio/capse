function [automaton, partMat] = iterateCA(automaton, virusFlags, partMat, timeStep, infection)
%ITERATECA Do one iteration of CA cycle

import caps.particles.pse.*;
import caps.cells.ca.*;


% Cell die.
if virusFlags.isCellDeathEnabled
    automaton = caps.cells.ca.killCells(automaton, timeStep);
end

% Cell lyse.
[automaton partMat] = caps.cells.ca.lyseCells(automaton, virusFlags, partMat);

% Infection spreads.
[automaton partMat] = caps.cells.ca.infectCells(automaton, virusFlags, partMat, infection);


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