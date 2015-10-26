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
