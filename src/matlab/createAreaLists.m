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
% createAreaLists(gridSize, partMat, cellSize, sqWidth)
function [cellAreaList particleAreaList] = createAreaLists(gridSize,...
                                                      partMat, cellSize, sqWidth)

import caps.visual.plot.*;                                                  
                                                  
%17.07.12 AY commented, because unused: CAVerletList = cell(gridSize(1)*gridSize(2), 1);
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


end

function partCellList = getPartCellContainingList(partMat, gridSize, ...
                                                 cellSize)

    import caps.visual.plot.*; 
                                             
    partCellList = zeros(length(partMat), 2);
    
    %to get the effective cell height simply (or averaged cell height)
    [width height] = unitHexagonAt(1, gridSize(2));
    effCellHeight = (height(1)*cellSize)/gridSize(2);

    for part=1:length(partMat)
        partCellList(part,:) = getCellPartIsIn(partMat(part, 1:2), gridSize, ...
                                                       cellSize, effCellHeight);
    end

end





function CAVListPos = CAVerletListPosition(gridPos, sizeX)
    CAVListPos = (gridPos(2)-1)*sizeX + gridPos(1);
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
        areaSum = sum(cellAreaList{c}(:,2));
        for p = 1:size(cellAreaList{c},1)
            cellAreaList{c}(p,3) = cellAreaList{c}(p,2)/areaSum;
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
                                        [part area]];
                                        
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
    import caps.visual.plot.unitHexagonAt; 
    [width height] = unitHexagonAt(gridPos(1), gridPos(2));
    hex.x = width.*cellSize;
    hex.x = [hex.x, hex.x(:,1)];
    hex.y = height.*cellSize;
    hex.y = [hex.y, hex.y(:,1)];
    hex.hole = 0;
end

                                            
                                       
                                                
                                               





