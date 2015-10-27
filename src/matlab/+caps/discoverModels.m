function models = discoverModels()
%DISCOVERMODEL Discover all CAPS model functions.
%   Discover all CAPS model functions.
res = what('+caps/+models');
models = {};
for index = 1:numel(res.m)
    name = res.m{index};   
    if (length(name) <  11) || (strcmp(name(1:11), 'VirusModel_') == 0)
        continue
    end
    models{end + 1} = name;
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