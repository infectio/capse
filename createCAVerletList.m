% Input
% gridSizcele:     Vector containing the x and y sizes of the CA Grid
% partMat:      Positions of PSE particles
% sizeCell:     the size of a "cell" in the CA
% addX:         any additional space put in the x-dimension of the CA
% addY:         any additional space put in the y-dimension of the CA
%
% Output
% CAVerletList:    Matlab cell structure that for each cell in the
%                  CA, there is a list of the PSE particles which
%                  represent some of the area of the CA cell along
%                  with the percentage they represent.
% partMat:         The partMat with an extra column that indicates
%                  which cell the PSE particle is in.
%
% function [CAVerletList, partMat) =
% createCAVerletList(gridSize, partMat, cellSize)
function [cellAreaList particleAreaList] = createCAVerletList(gridSize,...
                                                      partMat, cellSize, sqWidth)

CAVerletList = cell(gridSize(1)*gridSize(2), 1);
partMat = [partMat, zeros(length(partMat),2)];

%first find the cell the particle is in
partCellList = getPartCellContainingList(partMat, gridSize, cellSize);


%find intersection areas of the particles and hexagons
[cellAreaList, particleAreaList] = ...
        getCellParticleAreas(partMat, partCellList, gridSize, cellSize, ...
                                      sqWidth);

%then determine the percentages of area of the particles in the
%cell

[cellAreaList, particleAreaList] = ...
    convertToPercentAreas(cellAreaList, particleAreaList, sqWidth);


    
%NB: must also take care of 'special case (0,0)' 
%when they weren't in a cell, but are still likely to be
%close/around a cell
%--> done by 'extended the cells, eg if grid goes from 1-n
%extended grid cells go from 0-(n+1)


end

function partCellList = getPartCellContainingList(partMat, gridSize, ...
                                                 cellSize)

    partCellList = zeros(length(partMat), 2);
    
    %to get the effective cell height simply (or averaged cell height)
    [width height] = unitHexagonAt(1, gridSize(2));
    effCellHeight = (height(1)*cellSize)/gridSize(2);

    for part=1:length(partMat)
        partCellList(part,:) = getCellPartIsIn(partMat(part, 1:2), gridSize, ...
                                                       cellSize, effCellHeight);
    end

end


function gridPos = getCellPartIsIn(part, gridSize, cellSize, effCellHeight)
        
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


function CAVListPos = CAVerletListPosition(gridPos, sizeX)
    CAVListPos = (gridPos(2)-1)*sizeX + gridPos(1);
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


function isInRange = isInRange(gridSizeX, gridSizeY, index)
    if(index(1) < 1 || index(1) > gridSizeX)
        isInRange = false;
    elseif (index(2) < 1 || index(2) > gridSizeY)
        isInRange = false;
    else
        isInRange = true;
    end
end

function [cellAreaList, particleAreaList] = ...
    convertToPercentAreas(cellAreaList, particleAreaList, width)
    
    
    %do the cells
    for c = 1:length(cellAreaList)
        areaSum = sum(cellAreaList{c}(:,3));
        for p = 1:size(cellAreaList{c},1)
            cellAreaList{c}(p,4) = cellAreaList{c}(p,3)/areaSum;
        end
    end
    
    %do the particles
    
    %all particles have same area
    sq = getSquareAroundPoint([1,1],width);
    areaSum = polyarea(sq.x, sq.y);
    for p = 1:length(particleAreaList)
        for c = 1:size(particleAreaList{p},1)
            particleAreaList{p}(c,4) = particleAreaList{p}(c,3)/areaSum;
        end
        
    end
    
    
    
end


%for area distributions

function [cellAreaList, particleAreaList] = ...
        getCellParticleAreas(partMat, particleCellList, gridSize, cellSize, width)
    
    %initiate the lists
    particleAreaList = cell(length(partMat),1);
    cellAreaList = cell(gridSize(1)*gridSize(2), 1);
    
    %to check neighbouring cells
    neighbours = [0,0;  -1,1; 0,1; 1,1;  -1,-1; 0,-1; 1,-1; -1,0; 1,0];

    for part = 1:length(partMat)
        
        curPart = partMat(part,1:2);
        curCell = particleCellList(part,:);
        
        %for each particle we have to determine the area of intersection
        %with the cell it is in, and also all the neighbours
        sq = getSquareAroundPoint(curPart, width);
        
        
        for n = 1:length(neighbours)
            gridPos = curCell + neighbours(n,:);
            if(isInRange(gridSize(1), gridSize(2), gridPos))
                hex = getClosedHexAt(gridPos, cellSize);
                intersection = PolygonClip(hex, sq, 1); %type 1 =
                                                        %intersection
                if(size(intersection,2) == 1)
                    %update the part and the cells with area
                    area = polyarea(intersection.x, intersection.y);
                    particleAreaList{part} = [particleAreaList{part}; ...
                                        [gridPos, area]];
                    
                    gridListPos = CAVerletListPosition(gridPos, gridSize(1));
                    cellAreaList{gridListPos} = [cellAreaList{gridListPos}; ...
                                        [curPart area]];
                                        
                end
                
            end
            
        end
        
    end 
end


function sq = getSquareAroundPoint(part, width)

    sq.x = part(1) + [-width -width  width width -width];
    sq.y = part(2) + [width  -width -width width  width];
    sq.hole = 0;
end

function hex = getClosedHexAt(gridPos, cellSize)
    [width height] = unitHexagonAt(gridPos(1), gridPos(2));
    hex.x = width.*cellSize;
    hex.x = [hex.x, hex.x(:,1)];
    hex.y = height.*cellSize;
    hex.y = [hex.y, hex.y(:,1)];
    hex.hole = 0;
end

                                            
                                       
                                                
                                               





