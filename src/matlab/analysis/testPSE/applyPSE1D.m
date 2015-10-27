% Input
% particleMat:  (numParticles x (dim+1+numStren))-Matrix of particle positions, cell
%               indices and particle strengths 
% verletList:   Verlet list of particles
% epsilon:      Kernel parameter epsilon (standard deviation)
% strengthDim:  The dimension in the partMat where the particles
%               strengths are
%
% Output
% pseSum:       ((numParticles x numStren)-Matrix of updated particle strengths
%
% function pseSum = applyPSE(particleMat,verletList,epsilon,numStren)

function pseSum = applyPSE1D(partMat, verletList, epsilon, strengthDim)

numParts = length(verletList);
pseSum = zeros(numParts,1);

for i=1:numParts

    % collect neighboring particles from the Verlet list
    neighPartMat = partMat(verletList{i},:);

    if ~isempty(neighPartMat)
        % compute distances
        neighVecs=neighPartMat(:,1)-repmat(partMat(i,1),size(neighPartMat,1),1);
        partDists=sqrt(sum(neighVecs.*neighVecs,2));
        % Compute summation of the PSE operator
        pseSum(i) = sum((neighPartMat(:,strengthDim)- ...
                           partMat(i,strengthDim)).*etaKernel(partDists,epsilon));
        
    end
end

end

% 1-dimensional version of the eta kernel
function etaVals = etaKernel(distsVec, epsilon)
 etaVals = exp(-distsVec.^2/(4*epsilon^2)) / (2*epsilon*sqrt(pi));
 
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
