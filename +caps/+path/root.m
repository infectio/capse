function root_path = root()
%ROOT Return absolute path to parent folder of +caps packages.
%
%   Usually this is .../src/matlab/ (with ending path separator symbol).

    d = @caps.path.dirname; % function alias
    root_path = [d(d(caps.path.get_path)) filesep];

end
