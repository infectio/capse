function inputTest(m)
%fprintf('%d %d two numbers then worked', m(1), m(2));


    for i=1:(length(m)-1)
        d = distance(m(:,i), m(:, i+1));
        fprintf('d%d: %f\n', i, d);
    end
    
        d = distance(m(:,1), m(:, end));
        fprintf('d%d: %f\n', i, d);
    
end

function d = distance(p,q)
    d = sqrt(sum((p-q).^2));
    
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