function neighbours = getNeighbours(automaton, x, y)
% Get a list of (x,y) for neighboring cells around the hexagon
neighbours = cell(0, 2);

% Differes for odd and even
if ~mod(y, 2)
    if (y > 1) 
        if (x > 1)
            neighbours{end + 1, 1} = x - 1;
            neighbours{end, 2} = y - 1;
        end
        if (x <= automaton.numCellsX)
            neighbours{end + 1, 1} = x;
            neighbours{end, 2} = y - 1;        
        end
    end

    if (x > 1)
        neighbours{end + 1, 1} = x - 1;
        neighbours{end, 2} = y;
    end
    if (x < automaton.numCellsX)
        neighbours{end + 1, 1} = x + 1;
        neighbours{end, 2} = y;
    end

    if (y < automaton.numCellsY)
        if (x > 1)
            neighbours{end + 1, 1} = x - 1;
            neighbours{end, 2} = y + 1;
        end
        if (x <= automaton.numCellsX)
            neighbours{end + 1, 1} = x;
            neighbours{end , 2} = y + 1;
        end
    end
else
     if (y > 1 && x > 0) 
        neighbours{end + 1, 1} = x;
        neighbours{end, 2} = y - 1;
        if (x < automaton.numCellsX)
            neighbours{end + 1, 1} = x + 1;
            neighbours{end, 2} = y - 1;        
        end
    end

    if (x > 1)
        neighbours{end + 1, 1} = x - 1;
        neighbours{end, 2} = y;
    end
    if (x < automaton.numCellsX)
        neighbours{end + 1, 1} = x + 1;
        neighbours{end, 2} = y;
    end

    if (y < automaton.numCellsY)
        neighbours{end + 1, 1} = x;
        neighbours{end, 2} = y + 1;
        if (x < automaton.numCellsX)
            neighbours{end + 1, 1} = x + 1;
            neighbours{end , 2} = y + 1;
        end
    end
end
end