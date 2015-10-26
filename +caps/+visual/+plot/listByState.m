% Goes though the given table and selects the elements that have
% the provided state as their state.
% NB: that the state is indicated in (x,y,1)

function list = listByState(grid, state)
list = zeros(0,0);
for i=1:size(grid, 1)
    for j=1:size(grid, 2)
        if(grid(i,j,1) == state)
            list(end+1, 1:2) = [i j]; 
        end
    end
end
end