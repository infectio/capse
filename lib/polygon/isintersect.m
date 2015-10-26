function b = isintersect(P1, P2)
% function b = isintersect(P1, P2)
%
% Check if two polygons intersect
% INPUTS:
%   P1 and P2 are two-row arrays, each column is a vertice, assuming
%   ordered along the boundary
% OUTPUT:
%   b is true if two polygons intersect 
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History:
%     Original 20-May-2010

c = poly2poly(P1, P2);
if isempty(c)
    b = inpolygon(P2(1,1),P2(2,1),P1(1,:),P1(2,:)) || ...
        inpolygon(P1(1,1),P1(2,1),P2(1,:),P2(2,:));
else
    b = true;
end

end % isintersect



