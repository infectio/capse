function output = dirname(theFile)
%DIRNAME   Directory name component of path
%   Returns the absolute path of a file or folder. In the case of
%   using the path to a file, only the file's folder path is returned.
%
%   Syntax:
%      OUT = DIRNAME(THEPATH)
%
%   Input:
%      THEPATH   Path to a file or folder, which should exist
%
%   Output:
%      OUTPUT   The absolute folder pathname or [] if THEPATH does
%               not exist
%
%   Example:
%      realpath('../myfile.txt'); % returns /home/user/whatever
%
%   MMA 18-09-2005, martinho@fis.ua.pt
%
%   See also REALPATH, BASENAME

%   Department of Physics
%   University of Aveiro, Portugal

import caps.path.realpath

d = realpath(theFile);
[path,name,ext]=fileparts(d);
output = path;

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