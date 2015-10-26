function [ app_root_path ] = app_root()
%APP_ROOT Return absolute path to applicaiton root.
%
%   Normally contains lib, src, tools, etc.

    d = @caps.path.dirname; % function alias
    app_root_path = [d(d(caps.path.root)) filesep];

end

