
function saveImages(imgsDir, timestep, hg, cells_x, cells_y, ...
                    withParts)
    if(withParts)
        imgsDir = strcat(imgsDir, 'withParts_');
    end
    
    if(timestep < 10)
        imagename = sprintf('%s%d%s%d%s%s%s%d%d%d',imgsDir, cells_x, '_', ...
                            cells_y,'_', date, '_', 0, 0, timestep);
    elseif(timestep < 100)
        imagename = sprintf('%s%d%s%d%s%s%s%d%d',imgsDir, cells_x, '_', ...
                            cells_y,'_', date, '_',0, timestep);
    else
        imagename = sprintf('%s%d%s%d%s%s%s%d',imgsDir, cells_x, '_', ...
                            cells_y,'_', date, '_', timestep);
    end
    print ('-f1', '-dtiff', '-r1200', imagename);
end