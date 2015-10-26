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
    
