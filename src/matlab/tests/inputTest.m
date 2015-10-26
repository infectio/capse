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
