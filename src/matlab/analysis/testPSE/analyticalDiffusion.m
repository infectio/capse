function analyticalSoln = analyticalDiffusion(particlePos, D, t, ...
                                    initPosCoords)
    
    
    dim = size(particlePos,2);
    numParticles =size(particlePos,1);
    particleDists = sqrt(sum((particlePos-...
                              repmat(initPosCoords,numParticles, 1)).^2,2));
    analyticalSoln = greensFunc(particleDists, D, t, dim);
end

function analyticalSoln = greensFunc(partDists, D, t, dim)

    analyticalSoln = 1/((4*pi*D*t)^(dim/2))*exp(-(partDists.^2/(4*D*t)));
 
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
