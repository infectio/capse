function pixelCentre = getCentreOfHexagon(pixelList, centre, cellSize)
    
    [hex.x hex.y] = unitHexagonAt(centre(1), centre(2));
    
    hex.x = hex.x*cellSize;
    hex.y = hex.y*cellSize;
    
    centroid.x = hex.x(1);
    centroid.y = hex.y(1) - (hex.y(1)-hex.y(4))/2;
    
    nearestPoint = [-10, -10];
    nearestDistance = 10000000;
    
    for p = 1:length(pixelList)
        if distance(pixelList(p, 1:2), nearestPoint) < ...
                nearestDistance
            nearestPoint = pixelList(p, 1:2);
        end
        
    end
    

    pixelCentre = nearestPoint;
    
    
    end
    
    
    function dist = distance(x1, x2)
        dist = sqrt((x1(1) - x2(1))^2 + (x1(2) - x2(2))^2);
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
