function [ path ] = get_path()

    path = [regexprep(mfilename('fullpath'), ['\' filesep '[\w\.]*$'],'') filesep];

end
