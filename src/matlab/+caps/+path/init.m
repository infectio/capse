function init()
%INIT Initialize caps path.
%   Modify MATLAB path to include +caps package, and other required
%   packagess. 
    
    % Always adding to the top of the path. Note that order is important!
    path([caps.path.lib filesep 'polygon'], path);
    path(caps.path.root, path);

end
