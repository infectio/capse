function inf_list = addToInfList( ...
    inf_list, ... 
    newly_inf_cells, ...
    intensityRates, ... 
    CAGrid, ...
    virusAmtDim, ....
    ExtrapolationFlag)
    
    for i=1:size(newly_inf_cells,1)
        
        
        initialInfectionValue = CAGrid(newly_inf_cells(i,1), ...
                                                        newly_inf_cells(i,2), virusAmtDim);
        intensityRate = interpolateIntensityRate(intensityRates, ...
                                                initialInfectionValue, ExtrapolationFlag);
        
        inf_list{end+1}.x = newly_inf_cells(i,1);
        inf_list{end}.y = newly_inf_cells(i,2);
        inf_list{end}.initInfVal = initialInfectionValue;
        inf_list{end}.intRate = intensityRate;
        inf_list{end}.valid = true;
        
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