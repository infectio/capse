function intensityRates = readIntensityRate(filename)
    
    
    fileContents = csvread(filename);
    
    %create cell array for the file contents
    %first element is infection start value
    %second element is the infection rate increase table
    numInfectionStartRates = length(unique(fileContents(:,1)));
    intensityRates = cell(numInfectionStartRates, 2);
    
    j=1;
    for i=1:numInfectionStartRates
        ind = find(fileContents(:,1) == fileContents(j,1));
        intensityRates{i,1} = fileContents(ind(1),1);
        if size(fileContents, 2) == 4
            intensityRates{i,2} = fileContents(ind, 2:4);
        else
            intensityRates{i,2} = fileContents(ind, 2:3);
        end
        j = ind(end) + 1; %start next from the next initial
                          %infection value
        
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
