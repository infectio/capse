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

