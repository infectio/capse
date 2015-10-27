function compile()

d = caps.path.dirname(caps.path.get_path());
compile_c(fullfile(d, '+particles', '+pse'), fullfile(d, '+particles', '+pse', 'applyPSE.cpp'));

end

function compile_c(outdir, filepath)
    if isunix
        eval(...
            sprintf([
                'mex CFLAGS="\\$CFLAGS -fopenmp  -std=c99" LDFLAGS="\\$LDFLAGS -fopenmp"'...
                ' -outdir %s %s'], ...
                outdir, filepath) ...
        )
    else
        % assume windows 
        eval(...
            sprintf([
                'mex COMPFLAGS="$COMPFLAGS /openmp /Za" LINKFLAGS="$LINKFLAGS"'...
                ' -outdir %s %s'], ...
                outdir, filepath) ...
        )
    end
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