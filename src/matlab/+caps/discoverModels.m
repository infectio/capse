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

