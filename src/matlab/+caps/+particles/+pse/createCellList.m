% Input
% particlePos:  (numParticles x dim)-Matrix of particle positions   
% lBounds:      Scalar lower bound on all particle positions  
% uBounds:      Scalar upper bound on all particle positions
% cellSide:     Scalar value of the cell's side length 
% 
% Output
% particleMat:  (numParticles x dim+1)-Matrix that contains the particle
%               positions and the cell index it belongs to
% cellList:     Matlab cell structure of length number of overall cells (prod(numCells)) 
% numCells:     (dim x 1)- Vector that contains the number of cells per dimension 
% 
% function [particleMat,cellList,numCells] =
% createCellList(particlePos,lBounds,uBounds,cellSide)

function [particleMat,cellList,numCells] = createCellList(particlePos,lBounds,uBounds,cellSide)

[numParticles,dim] = size(particlePos);
indices=zeros(numParticles,1);

domainSize = (uBounds-lBounds)*ones(dim,1);

% determine how many cells are needed per dimension
numCells = max(1,floor(domainSize./cellSide));
indParticlePos = zeros(numParticles,dim);

for i=1:dim
    % shift to zero and discretize
    indParticlePos(:,i)=floor((particlePos(:,i)-min(particlePos(:,i)))./(domainSize(i)-min(particlePos(:,i))).*numCells(i))+1;
end

% add cell index in the particle representation
if dim == 1
    indices = indParticlePos;       

elseif dim == 2
    
    for i=1:numParticles
        % Use the convention of sub2ind to map the dimx1 indices to a
        % single integer
        indices(i,1) = sub2ind(numCells,indParticlePos(i,1),indParticlePos(i,2));
    end

end

% Create a Matlab cell structure
particleMat=[particlePos,indices];
maxCellNum=max(particleMat(:,dim+1));
cellList = cell(prod(numCells),1);

for c=1:maxCellNum
    currInd = find(particleMat(:,dim+1)==c);
    cellList{c} = currInd;    
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
