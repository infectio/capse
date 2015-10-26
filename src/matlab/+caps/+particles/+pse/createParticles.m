% Input
% numParticles: Number of particles
% lBounds:      Scalar lower bound on all particle positions  
% uBounds:      Scalar upper bound on all particle positions
%
% Output
% particlePos:    (numParticles x dim)-Matrix of particle positions   
%
% function particlePos =
% createParticles(numParticles,lBounds,uBounds)
function [particlePos, cellMid, numPerDim] = createParticles(numParticles,lBounds,uBounds)

particlePos = [];

% Particles that are distributed on a grid 
numPerDim=round(numParticles^(1/2));
cellMid = (1/2)*(uBounds-lBounds)/(numPerDim);

xVec = linspace(lBounds+cellMid,uBounds-cellMid,numPerDim);
yVec = linspace(lBounds+cellMid,uBounds-cellMid,numPerDim);
[X,Y]=meshgrid(xVec,yVec);
particlePos=[X(:),Y(:)]; 
        
end
