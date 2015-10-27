

inf_list

This list contains the coordinates of cells which are infected.  It also contains the initial virus amount at the time of infection as well as the interpolated table of the rate of intensity increase over time.
This list is created with these values to save time.  Firstly, for each step of the CA, only the cells that are infected must be examined.  Since infected cells are the only ones that will change states in time steps of the CA, this reduces the amount of cells that need to be checked.
Computational savings is also obtained by only interpolating the rate of intensity increase once, instead of for every time step.

{:,1:2} - CA grid index
{:,3} - initial infection virion amount
{:, 4} - interpolated table

 
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