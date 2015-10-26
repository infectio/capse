%Input:
% partMat:      the particle matrix to where the strengths will be
%               added to 
% CAVerletList: the verlet list for the CA to know which particles
%               are in the vicinity of the lysed cell
% cellLocation: the coordinates of the cell that lysed
% totalVirus:   the amount of virus to distribute amongst the pse particles
% gridSizeX:    the size of the grid in the x-dimension
% strengthDim:  which dimension in the partMat should the strengths
%               be added to
% gridPosDims:  the position in the partMat of the grid position
%               the particle belongs to
%Output:
% partMat:      the particle matrix with the virus amounts added to
%               the associated particles strengths
%function partMat =  addVirusToParticleStrengths(partMat, ...
%   CAVerletList, cellLocation, totalVirus)

function grid =  updateMaxCellVirusAmount(partMat, ...
                       grid, partAreaList, strengthDim, virusAmtDim)

% TODO: vectorize code                   
                   
%make a copy of the grid to which new strengths will be added
tempGrid = zeros(size(grid,1), size(grid,2));

%update that copy
for p = 1:length(partMat)
    for c = 1:size(partAreaList{p},1)
        %fprintf('p: %d c: %d size:%d\n', p, c, size(partAreaList{p},2));
        gridPos = partAreaList{p}(c,1:2);
        %add percent of strength thats in that particular cell
        tempGrid(gridPos(1), gridPos(2)) = tempGrid(gridPos(1), gridPos(2)) ...
            +  partMat(p,strengthDim)*partAreaList{p}(c,4);
    end
end


%then for each cell in the two grids, keep the max
for i=1:size(grid,1)
    for j=1:size(grid,2)
        if(tempGrid(i,j) > grid(i,j,virusAmtDim))
            grid(i,j,virusAmtDim) = tempGrid(i,j);
        end
    end
end


end
