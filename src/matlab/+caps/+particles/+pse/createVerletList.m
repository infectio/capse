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