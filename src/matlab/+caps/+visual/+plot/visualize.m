% Input
% grid: the Cellular Automaton grid that contains the states of the cells
%
% Output
% draws the cells in the grid as unit hexagons
% hg:    graphics handle to the graph   
%
% function hg = visualize(grid)
function hg =  visualize(grid, partMat, inf_list, cellSize, stateDim, ...
                         infListDim, infTimeDim, withParts, backgroundIntensity)


import caps.visual.plot.*;

figure(getappdata(0,'h2'));
clf('reset');
set(getappdata(0,'h2') ,'Name','Simulation Visualization', 'NumberTitle','off');
gridSize = size(grid);
[width height] = unitHexagonAt(1,gridSize(2));
%axis([0 (gridSize(1)+0.5)*cellSize 0 (height(1)+0.2)*cellSize])
axis off

black = [0 0 0]; green = [0 1 0];
background =  backgroundIntensity .* green;
            

hold on

for j = 1:gridSize(2)
    for i = 1:gridSize(1)
        [shapex, shapey] = unitHexagonAt(i,j);
        shapex = shapex*cellSize;
        shapey = shapey*cellSize;
        %shapey = shapey*(max(shapey) - min(shapey));3
        switch(grid(i,j, 1))
          case 0
            hg = fill(shapex, shapey, background);
          case 1
            hg = fill(shapex, shapey, background);
          case 2
            %infected, but must calculate intensity
            infListPos = grid(i,j,infListDim);
            intensityRate = inf_list{infListPos}.intRate;
            iTime = grid(i,j,infTimeDim);
            %intensity = interp1(intensityRate(:,1), intensityRate(:,2), iTime);
            intensity = interp1(intensityRate(:,1), intensityRate(:,2), iTime, 'linear','extrap');
            
            if(isnan(intensity))
                if(grid(i,j, infTimeDim) < min(intensityRate(:,1)))
                    intensity = backgroundIntensity;
                else
                    intensity =  intensityRate(end,2);
                end
            end
            
            % Always a value within the [0,1] range.
            intensity = max(0, min(1, intensity));

            blended = intensity.*green;
            
            hg = fill(shapex, shapey, blended);
          case 3
            hg = fill(shapex, shapey, 'r');
          case 4
            hg = fill(shapex, shapey, 'r');
                
        end
        
        plot([shapex shapex(1)], [shapey shapey(1)], 'b')
    end
end

if(withParts)
    if(sum(partMat(:,3)) == 0)
        scatter(partMat(:,1), partMat(:,2), 2, black, '.');
    else
        scatter(partMat(:,1), partMat(:,2), 2, partMat(:,3), '.');
    end
end


hold off

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