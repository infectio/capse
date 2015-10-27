
function saveImages(imgsDir, timestep, hg, cells_x, cells_y, ...
                    withParts)
    if(withParts)
        imgsDir = strcat(imgsDir, 'withParts_');
    end
    
    if(timestep < 10)
        imagename = sprintf('%s%d%s%d%s%s%s%d%d%d',imgsDir, cells_x, '_', ...
                            cells_y,'_', date, '_', 0, 0, timestep);
    elseif(timestep < 100)
        imagename = sprintf('%s%d%s%d%s%s%s%d%d',imgsDir, cells_x, '_', ...
                            cells_y,'_', date, '_',0, timestep);
    else
        imagename = sprintf('%s%d%s%d%s%s%s%d',imgsDir, cells_x, '_', ...
                            cells_y,'_', date, '_', timestep);
    end
    print ('-f1', '-dtiff', '-r1200', imagename);
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