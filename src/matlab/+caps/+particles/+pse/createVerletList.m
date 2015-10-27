% Input
% PList:  list of particle positions
% rc: cut off radius
%
% Output
% VList: Verlet list of the points in PList using the rc as the
% cuf-off 
% function VList = createVerletList(partList, rc)
function verletList = createVerletList(partList, rc)

    verletList = cell(size(partList, 1), 1);
 
    for p = 1:size(partList, 1)
        for q = 1:size(partList, 1)
            if (p ~= q)
                if(distance(partList(p,:), partList(q,:)) <= rc)
                    verletList(p) = {[verletList{p} q]};
                end
            end
        end
    end

end



function d = distance(p,q)
    d = sqrt(sum((p-q).^2));
    
end































%old - for using intermediate CellLists

% %   must make intermediate Cell List first for efficiency
%     uBounds = max(max(PList));
%     lBounds = min(min(PList));
%     CList = CellList(PList, lBounds, uBounds, rc);
%      
%      for x = 1:length(CList)
%          for y = 1:length(CList) %currently square cell array
%              z = 1;
%             while (~isEmpty(CList(x,y,z)))
%                 
%                 
%                 
%                 
%                 
%                 z = z+1;
%             end
%          end
%      end
%     


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