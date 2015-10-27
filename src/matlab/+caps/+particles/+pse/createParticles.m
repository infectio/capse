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