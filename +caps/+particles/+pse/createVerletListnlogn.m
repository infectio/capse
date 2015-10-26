% Input
% particleMat:  (numParticles x dim+1)-Matrix of particle positions and cell index
% cellList:     Matlab cell structure of length prod(numCells) (number of cells)
% numCells:     (dim x 1)- Vector that contains the number of cells per
%               dimension
% cutoff:       Scalar distance cutoff that defines the neighborhood. It should be
%               equivalent to the side length of a cell
% 
% Output
% verletList:   Matlab cell structure of length numParticles. Each element
%               contains the indices of the particles, i.e. the row numbers
%               in the particleMat matrix
%
% function verletList = createVerletList(particleMat,cellList,numCells,cutoff)


function verletList = createVerletListnlogn(particleMat, cutoff, ...
                                            lBounds,uBounds)


import caps.particles.pse.*;
                                        
[particleMat, cellList, numCells] = createCellList(particleMat, lBounds, uBounds, cutoff);

[numParticles,dim] = size(particleMat);
dim = dim-1;

% Initialize Verlet list
verletList = cell(numParticles,1);

% Iterate over all particles and build Verlet list
for n=1:numParticles
    % collect all surrounding cell indices
    currCellInd = particleMat(n,dim+1);
    adjCellIndices = adjacentCells(currCellInd,numCells);
    allCellIndices = [currCellInd,adjCellIndices]';
    
    % collect all particle ID's
    currPartIndices=cell2mat(cellList(allCellIndices));
    
    currVec=[];
    numRows = length(currPartIndices);
    
    % iterate over all collected particles around the current particle
    tempMat = repmat(particleMat(n,1:dim),numRows,1);
    temp = currPartIndices(find(sum(((tempMat-particleMat(currPartIndices,1:dim)).^2),2)<=cutoff^2));
    verletList{n} = temp(find(temp~=n));
end

end

function adjCellIndices = adjacentCells(cellIndex,numCells)

dim=size(numCells,1);
adjCellIndices=[];

if dim==3
    
    [I,J,K]=ind2sub(numCells,cellIndex);
    
    iIndices=[max(I-1,1):1:min(I+1,numCells(1))];
    jIndices=[max(J-1,1):1:min(J+1,numCells(2))];
    kIndices=[max(K-1,1):1:min(K+1,numCells(3))];
    
    for i=iIndices
        for j=jIndices
            for k=kIndices
                if any([i,j,k]-[I,J,K])
                    adjCellIndices=[adjCellIndices,sub2ind(numCells,i,j,k)];
                end
            end
        end
    end
        
elseif dim==2
    
    [I,J]=ind2sub(numCells,cellIndex);
    
    iIndices=[max(I-1,1):1:min(I+1,numCells(1))];
    jIndices=[max(J-1,1):1:min(J+1,numCells(2))];
        
    for i=iIndices
        for j=jIndices
            if any([i,j]-[I,J])
                    adjCellIndices=[adjCellIndices,sub2ind(numCells,i,j)];
            end
        end
    end
end

end



