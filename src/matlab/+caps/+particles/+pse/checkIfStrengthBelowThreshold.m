function done = checkIfStrengthBelowThreshold(partMat, strengthDim, ...
    cellAreaList, cellArea, ...
    infectionThreshold, pseThreshold)
%CHECKIFSTRENGTHBELOWTHRESHOLD is just a little helper method that goes 
% through all the particles to determine if the strength of a particle is 
% less than the lowest infection threshold when it is below this threshold 
% then no additional cells can become infected and then the PSE simulation 
% can stop.

done = false;
nPartsAboveThreshold = 0;
for c=1:length(cellAreaList)
    if(sum(partMat(cellAreaList{c}(:,1),strengthDim))/cellArea > infectionThreshold)
        nPartsAboveThreshold = nPartsAboveThreshold + 1;
    end
end

%fprintf('nPartsAboveThreshold: %d\n', nPartsAboveThreshold);
if(nPartsAboveThreshold == 0)
    done = true;
    return;
end

%else maybe we should check to see if there is much difference
%left in the concentrations
% this is needed bc if threshold is set low and the space isn't
% very big, then it will never reach below infection
% probability threshold
maxStrength = max(partMat(:,strengthDim));
minStrength = min(partMat(:,strengthDim));
if(maxStrength - minStrength <= pseThreshold)
    done = true;
    return;
end


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