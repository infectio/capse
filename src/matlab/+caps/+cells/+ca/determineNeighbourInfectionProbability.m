function prob_neigh = determineNeighbourInfectionProbability(grid,  pos, neighInfProbs)

    % so we must define a few things
    
    % if the infection is additive (most simple) based on the infection
    % status of neighbours, or if say it follows some other sort of
    % distribution (like for example... maybe a negative binomial - if the
    % first infected neighbour cell doesn't make it infected, then does the
    % next, and the next...)
    prob_neigh = neighInfProbs;
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