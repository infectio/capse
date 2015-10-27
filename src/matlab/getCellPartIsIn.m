function gridPos = getCellPartIsIn(part, gridSize, cellSize, effCellHeight)
    
    import caps.visual.plot.*; 

    %just make sure centre of PSE particle is in this cell
    
    %guess what cell it is likely in
    if(  mod(ceil(part(1)/effCellHeight), 2) == 0 )
        xpos = part(1) + 0.5*cellSize;  %is offset in the x-axis
        %first guess
        gridPosStart = [round(xpos/cellSize), ceil(part(2)/effCellHeight)];
        %since there is no such thing as a 0 element in the grid
        if ( gridPosStart(1) == 0 )
            gridPosStart(1) = 1;
        end
    else
        %first guess
        gridPosStart = [ceil(part(1)/cellSize), ceil(part(2)/effCellHeight)];
    end  
   
   %now find the cell
   %middle(1), top (3), bottom (3), left and right (2)
   possibleNeighbours = [0,0;  -1,1; 0,1; 1,1;  -1,-1; 0,-1; 1,-1; -1,0; 1,0];
   for n = 1:length(possibleNeighbours)
       if(isInExtendedRange(gridSize(1), gridSize(2), gridPosStart+possibleNeighbours(n,:)))
           if(checkIfIsInCell(part(:), gridPosStart + ...
                              possibleNeighbours(n,:), cellSize))

               gridPos = gridPosStart + possibleNeighbours(n,:);
               return;
           end
       end   
   end
   gridPos = [0, 0];  %not in a cell - likely an error
end



%check to make sure all corners are contained inside of grid cell
function isInCell = checkIfIsInCell(psePart, gridPos, cellSize)

    import caps.visual.plot.*; 

%get the coordinatates of the cell shape
%now this is just a simple hexagon
    [shapex, shapey] = unitHexagonAt(gridPos(1), gridPos(2));
    shapex = shapex.*cellSize;
    shapey = shapey.*cellSize;

    isInCell = false;

    %check to see if between the two verticle lines
    if(shapex(2) < psePart(1) && psePart(1) < shapex(5)) 
        
        
        
        %slope 1:  (top to left)
        s1 = (shapey(1) - shapey(2))/(shapex(1) - shapex(2));
        s1Compare = (psePart(2) - shapey(2))/(psePart(1) -shapex(2));
        
        %fprintf('   s1C: %f s1: %f  <?\n', s1Compare, s1);
        if(s1Compare > s1)
            return;
        end
        
        %slope 2: (left to bottom)
        s2 = (shapey(3) - shapey(4))/(shapex(3) - shapex(4));
        s2Compare = (psePart(2) - shapey(3))/(psePart(1) - ...
                                               shapex(3));
        %fprintf('   s2C: %f s2: %f  <?\n', s2Compare, s2);
        if(s2Compare < s2)
            return;
        end
        
        %slope 3: (bottom to right)
        s3 = (shapey(4) - shapey(5))/(shapex(4) - shapex(5));
        s3Compare = (psePart(2) - shapey(5))/(psePart(1) - ...
                                              shapex(5));
        %fprintf('   s3C: %f s3: %f  <?\n', s3Compare, s3);
        if(s3Compare > s3)
            return;
        end
        
        %slope 3: (right to top)
        s4 = (shapey(6) - shapey(1))/(shapex(6) - shapex(1));
        s4Compare = (psePart(2) - shapey(1))/(psePart(1) - ...
                                              shapex(1));
        
        %fprintf('   s4C: %f s4: %f  >?\n', s4Compare, s4);
        if((s4Compare > s4 && psePart(1) > shapex(1)) || ...
           (s4Compare < s4 && psePart(1) < shapex(1)))
        %if(s4Compare > s4)
            return;
        end
         
        %passed all tests
         isInCell = true;
         
    elseif (shapex(2) == psePart(1))
        if(shapey(2) >= psePart(2) && psePart(2) >= shapey(3))
            %has been the case where some points
            isInCell = true;  %biased to one side, but ok since
                              %area will be shared
        end
        
    end
end


function isInRange = isInExtendedRange(gridSizeX, gridSizeY, index)
    if(index(1) < 0 || index(1) > (gridSizeX+1))
        isInRange = false;
    elseif (index(2) < 0 || index(2) > (gridSizeY+1))
        isInRange = false;
    else
        isInRange = true;
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
