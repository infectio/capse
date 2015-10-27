%%%%%%%%%%%%%%%%%%%%%%%%
% VIRCAPSE remesh particles to grid-like positions positions
% original code (c) Sbalzarini group
% changes for VIRCAPSE implementation (c) Artur Yakimovich
%%%%%%%%%%%%%%%%%%%%%%%%
% Input
% partMat:  (numParticles x (dim+1+numStren))-Matrix of old (grid-like) particle positions, cell
%               indices and particle strengths 
% newpositions: (numParticles x dim)-Matrix of new particle positions 
% dt:           time step
%
% Output
% partMat:  (numParticles x (dim+1+numStren))-Matrix of new (grid-like) particle positions, cell
%               indices and particle strengths 

%function partMat = remesh(partMat,newpositions)
%%h = PSE_dt; - this is wrong, h is the distance between particles
% Let's find out this value from the old grid distance between coordinates of first two elements,
% since we have anyways have equaly distributed particles
h = partMat(3,2) - partMat(2,2);

dim = 2;
numParticles = size(partMat,1);
numPerDim = round(numParticles^(1/dim));

% create a new set of particles at old (grid) positions
%%posvec = -0.5*h:h:50-0.5*h; % domain is [-1,50]^2
%%gridPositions = meshgrid(posvec,posvec);
% create a new grid, equivalent to the old partMat
posvec = 1*h:h:numPerDim*h; % domain here will be [1, numPerDim]^2
gridPositions = meshgrid(posvec,posvec); %change for 3rd dimension

strength_at_gridPositions = zeros(size(partMat(:,3)));

% remesh the extracellular concentration u_e (M'4-interpolation)
%%strength_at_gridPositions(:) = 0;
Mp4 = zeros(4,2);
distance = zeros(4,2);

NLLGPij = floor(newpositions + 1.5*h); % subscripts i,j of nearest grid point at lower left of each particle
for ip = 1:numParticles
    % indeces of grid points getting contributions of strength of particle ip
    i = NLLGPij(ip,1)-1:NLLGPij(ip,1)+2;
    j = NLLGPij(ip,2)-1:NLLGPij(ip,2)+2;
    % normed distances of these grid points to particle ip (along axes)
    distance(:,1) = abs(newpositions(ip,1) - i + 1.5*h)/h;
    distance(:,2) = abs(newpositions(ip,2) - j + 1.5*h)/h;
    % M'4-kernel evaluation
    ind = find(distance < 1);
    Mp4(ind) = 1 - 0.5*(5*distance(ind).^2 - 3*distance(ind).^3);
    ind = find(distance >= 1);
    Mp4(ind) = 0.5*(2 - distance(ind)).^2.*(1 - distance(ind));
    
    % Added by AY
%     ind = find(distance > 2);
%     Mp4(ind) = 0;
    
    % add contribution to corresponding grid point
    I = repmat(i,4,1);J = repmat(j',1,4);
    W = repmat(Mp4(:,1)',4,1).*repmat(Mp4(:,2),1,4);
    %%ind = intersect(intersect(find(I >= 1),find(I <= 51)),intersect(find(J >= 1),find(J <= 51)));

    ind = intersect(intersect(find(I >= 1),find(I <= length(gridPositions)))...
        ,intersect(find(J >= 1),find(J <= length(gridPositions))));
    corr_indeces = sub2ind(size(gridPositions),J(ind),I(ind));
    strength_at_gridPositions(corr_indeces) = strength_at_gridPositions(corr_indeces) + W(ind)*partMat(ip,dim+1);%originally dim+2, but as far as I remeber our strength dimension is 3
end;
% paste new strengths into partMat-array
% in_domain = intersect(intersect(find(partMat(:,1) > -1),find(partMat(:,1) < 50)), ...
%     intersect(find(partMat(:,2) > -1),find(partMat(:,2) < 50))); % particles inside domain
in_domain = intersect(intersect(find(partMat(:,1) > 0),find(partMat(:,1) < length(gridPositions))), ...
      intersect(find(partMat(:,2) > 0),find(partMat(:,2) < length(gridPositions))));
partMat(in_domain,dim+1) = strength_at_gridPositions(:); % interpolated u_c at remeshed particles %originally dim+2
%end

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
