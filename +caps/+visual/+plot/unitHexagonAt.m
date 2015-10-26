

function [shape_x shape_y] = unitHexagonAt(x_pos, y_pos)
            
    x_off = 0;
    if(mod(y_pos, 2) == 1)
        x_off = 0.5;
    end
    r = 1/2;
    a = 2*r / sqrt(3);
    y_off = 1.5*a;
    
    [shape_x shape_y] = unitHexagon(r);
    shape_x = (x_pos-1) + shape_x + x_off;
    shape_y = y_off*(y_pos-1) + shape_y;
    
end

function [shape_x shape_y] =  unitHexagon(r)
%a = 2/3;
%r = 1/2;
    a = 2*r / sqrt(3);
    xCentre = 0.5;
    rLeft = xCentre - r;
    rRight = xCentre + r;
    shape_x = [xCentre, rLeft, rLeft, xCentre, rRight, rRight];
    shape_y = [2*a, a+(1/2)*a, a-(1/2)*a, 0, a-(1/2)*a, a+(1/2)*a];
end
        
