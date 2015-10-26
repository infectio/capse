function isGuiRunning = runningGUI()
%RUNNINGGUI returns TRUE if infectio is runnig from GUI
%   Checks whether infectio is ran from GUI, noinput arguments.
global usingGUI;
isGuiRunning = false;
if (usingGUI)
       isGuiRunning = true;
end


