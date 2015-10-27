function [cellAssociatedVirusAmount cellFreeVirusAmount] = producePrelyticVirus(virusSpread, cellInfectiontime)
% PRELYTICVIRUSPRODUCTION
%
% prelyticVirusProduction determines  how much virus is produces at the 
% current time step by the virus according to the Sigmoidal Virus Growth 
% model.
% Y=Bottom + (Top-Bottom)/(1+10^((LogEC50-X)*HillSlope))
% The model equation is: Y = Bottom + (Top - Bottom)/...
% (1+ 10^((logEC50-t)*Slope)), where Y is the virus amount, t � is time after
% infection and "Bottom", "Top", "EC50" and "Slope"  are the fitting 
% parameters.
% Input Arguments: virusType, t, Bottom, Top, EC50 and Slope
% 

% Compute model predicted result for delta t
deltaY = (virusSpread.bottom + (virusSpread.top - virusSpread.bottom)/(1+ 10^((log10(virusSpread.EC50)-cellInfectiontime)*virusSpread.slope)));
if cellInfectiontime >= 1
    deltaY = deltaY - (virusSpread.bottom + (virusSpread.top - virusSpread.bottom)/(1+ 10^((log10(virusSpread.EC50)-(cellInfectiontime-1))*virusSpread.slope)));
end
% apply weights
cellAssociatedVirusAmount = virusSpread.cellAssociatedWeight*deltaY;
cellFreeVirusAmount = virusSpread.cellFreeWeight*deltaY;

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
