function output = realpath(thePath)
%REALPATH   Absolute pathname
%   Resolves relative paths and extra filesep characters in the input
%   path.
%
%   Syntax:
%      OUTPUT = REALPATH(THEPATH)
%
%   Input:
%      THEPATH   Path to a file or folder, which should exist
%
%   Output:
%      OUTPUT   The absolute pathname or [] if THEPATH does not exist
%
%   Example:
%      realpath('../myfile.txt'); % returns /home/user/whatever/myfile.txt
%
%   MMA 18-09-2005, martinho@fis.ua.pt
%
%   See also DIRNAME, BASENAME

%   Department of Physics
%   University of Aveiro, Portugal

output = [];
isfile = 0;
if exist(thePath,'file') == 2 & isempty(which(thePath))
  [path,name,ext]=fileparts(thePath);
  thePath =  path;
  isfile = 1;
end

current = cd;
if exist(thePath,'dir') == 7 & ~isempty(dir(thePath))
  cd(thePath);
  output = cd;
  cd(current);

  if isempty(output)
    if isunix, new = filesep; end
    if ispc,   new='C:\';     end
  end
end

if isfile
  output = [output,filesep,name,ext];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     Infectio - a virus infection spread simulation platform
%     Copyright (C) 2014-2015  Artur Yakimovich, Yauhen Yakimovich
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.