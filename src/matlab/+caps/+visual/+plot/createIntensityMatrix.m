% Input
% grid: the Cellular Automaton grid that contains the states of the cells
%
% Output
% an intensity matrix (like an grey-scale image) 
%
% function hg = visualize(grid)
function intMat =  createIntensityMatrix(grid, inf_list, pixelList, stateDim, ...
                         infListDim, infTimeDim, backgroundIntensity)

gridSize = size(grid);

intMat = zeros(length(pixelList)^(1/2));

gridInt = zeros(gridSize(1), gridSize(2));

for x = 1:gridSize(1)
    for y = 1:gridSize(2)
         switch(grid(x,y, stateDim))
          case 2
            %infected, but must calculate intensity
            infListPos = grid(x,y,infListDim);
            intensityRate = inf_list{infListPos}.intRate;
            intensity = interp1(intensityRate(:,1), intensityRate(:,2), ...
                                grid(x,y,infTimeDim));
            if(isnan(intensity))
                if(grid(x,y, infTimeDim) < min(intensityRate(:,1)))
                    intensity = backgroundIntensity;
                else
                    intensity =  intensityRate(end,2);
                end
            end
            gridInt(x,y) = intensity; 
            
          otherwise
            gridInt(x,y) = backgroundIntensity; 
        end
    end
end



pixel = 0;
for x = 1:size(intMat,1)
    for y = 1:size(intMat,2)
        pixel = pixel + 1;
        if(pixelList(pixel, 3) ~= 0 && pixelList(pixel, 4) ~= 0 ...
           && pixelList(pixel, 3) < size(grid,1) ...
           && pixelList(pixel,4) < size(grid,2))
            
            intMat(x,y) = gridInt(pixelList(pixel,3), ...
                                  pixelList(pixel,4));
        end
        
    end
end



%for j = 1:gridSize(2)
%    for i = 1:gridSize(1)
%        [shapex, shapey] = unitHexagonAt(i,j);
%        shapex = shapex*cellSize;
%        shapey = shapey*cellSize;
%        %shapey = shapey*(max(shapey) - min(shapey));3
%        switch(grid(i,j, 1))
%          case 0
%            hg = fill(shapex, shapey, 'w');
%          case 1
%            hg = fill(shapex, shapey, [0 0 0]);
%          case 2
%            %infected, but must calculate intensity
%            infListPos = grid(i,j,infListDim);
%            intensityRate = inf_list{infListPos, 4};
%            intensity = interp1(intensityRate(:,1), intensityRate(:,2), ...
%                                grid(i,j,infTimeDim));
%            if(isnan(intensity))
%                if(grid(i,j, infTimeDim) < min(intensityRate(:,1)))
%                    intensity = 0;
%                else
%                    intensity =  intensityRate(end,2);
%                end
%            end
%            
%            black = [0 0 0]; white = [1 1 1];
%            blended = intensity.*white + (1 - intensity).*black;
%            
%            hg = fill(shapex, shapey, blended);
%          case 3
%            hg = fill(shapex, shapey, [0 0 0]);
%        end
%    end
%end

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