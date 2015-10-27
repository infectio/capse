%
% Input:
%  modelSize:  the 2D physical size (ie um)
%
% Output:
%  pixelList:  each 1um^2 pixel will have it's hexagon coordinates
%  it belongs to

function pixelList = createPixelList(numPixels, modelSize, gridSize, cellSize)


    import caps.particles.pse.*;
    import caps.visual.plot.*;
    
    pixelList = createParticles(numPixels, 0, max(modelSize(1), ...
                                                  modelSize(2)));
    pixelList = [pixelList zeros(length(pixelList), 2)];
    
    %to get the effective cell height simply (or averaged cell height)
    [width height] = unitHexagonAt(1, gridSize(2));
    effCellHeight = (height(1)*cellSize)/gridSize(2);

    for p = 1:length(pixelList)
        gridPos = getCellPartIsIn(pixelList(p,1:2), gridSize, cellSize, ...
                                             effCellHeight);
        pixelList(p, 3:4) = gridPos;
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
