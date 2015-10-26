function lib_path = lib()
%LIB Return absolute path to parent folder contining toolboxes.
%
%   Return absolute path to parent folder contining toolboxes required by 
%   CAPS. Usually this is .../lib/ (with ending path separator symbol).

    d = @caps.path.dirname; % function alias
    lib_path = [d(d(d(d(caps.path.get_path)))) filesep 'lib' filesep];

end
