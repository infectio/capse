function [automaton partMat] = lyseCells(automaton, virusFlags, partMat)

gridWidth = size(automaton.grid, 1);
infectedIndexes = []; % Will be removed from the automaton.infectedCells shorthand.

infectClockDim = automaton.dimension.infectionClock;
infectTimeDim = automaton.dimension.infectionTime;

% Walk though the short list of infected cells.
for iCell=1:length(automaton.infectedCells)
    % If cell is valid.
    infectedCell = automaton.infectedCells{iCell};
    if infectedCell.valid == true
        indx = infectedCell.x;
        indy = infectedCell.y;
        
        % Update clocks.
        automaton.grid(indx, indy, infectClockDim) = automaton.grid(indx, indy, infectClockDim) - automaton.dt;
        automaton.grid(indx, indy, infectTimeDim) = automaton.grid(indx, indy, infectTimeDim) + automaton.dt;
        
        % Check for no lysis.
        if ~virusFlags.isPrimaryLysisEnabled
           continue 
        end
        
        % Lysis happens when time (for infected cells) runs out.
        if (automaton.grid(indx, indy, infectClockDim) < 0) 
            
            %check if the each cell is going to lyse
            if (size(find(automaton.grid(:,:,automaton.dimension.state) ==  automaton.cellStates.LYSED),1)>=1)
                if strcmp(virusFlags.lysisDist, 'unif')
                    LyseRand = rand(1); % generate uniformly distributed values 0 to 1
                elseif strcmp(virusFlags.lysisDist, 'norm')
                    LyseRand = 0.5 + 0.5.*randn(1); % generate normally distributed values from 0 to 1 with 0.5 mean
                    if LyseRand >1
                        LyseRand = 1;
                    elseif LyseRand <0
                        LyseRand = 0;
                    end
                    
                elseif strcmp(virusFlags.lysisDist, 'exp')
                    LyseRand = exprnd(0.5); % generate exponentially distributed values from 0 to 1 with 0.5 mean
                    if LyseRand >1
                        LyseRand = 1;
                    elseif LyseRand <0
                        LyseRand = 0;
                    end
                end
            else
                LyseRand = 0;
            end
            
            if(LyseRand <= automaton.probabilityOfSecondaryLysis)
                %cell has lysed
                automaton.grid(indx, indy, 1) = automaton.cellStates.LYSED;
                %need to be removed from infected list, because now it is lysed
                infectedIndexes(end+1) = iCell;
                
                %add virus particles to strengths of particles
                partMat = caps.particles.pse.addVirusToParticleStrengths( ...
                    partMat, ...
                    automaton.cellAreaList, ...
                    [indx indy], ...
                    automaton.numVirionLysed, ...
                    gridWidth, ... 
                    automaton.dimension.strength);
            else
                % this cell will never lyse
                infectedIndexes(end+1) = iCell;
            end
            
        end
    end
end
% now clean out the inf_list of cells that have lysed
for iCell=1:length(infectedIndexes)
    % by setting their validity to false
    automaton.infectedCells{infectedIndexes(iCell)}.valid = false;
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
