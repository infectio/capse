function varargout = infectioGUI(varargin)
% INFECTIOGUI MATLAB code for infectioGUI.fig
%      INFECTIOGUI, by itself, creates a new INFECTIOGUI or raises the existing
%      singleton*.
%
%      H = INFECTIOGUI returns the handle to a new INFECTIOGUI or the handle to
%      the existing singleton*.
%
%      INFECTIOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFECTIOGUI.M with the given input arguments.
%
%      INFECTIOGUI('Property','Value',...) creates a new INFECTIOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before infectioGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to infectioGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help infectioGUI

% Last Modified by GUIDE v2.5 08-Dec-2014 22:29:51

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @infectioGUI_OpeningFcn, ...
    'gui_OutputFcn',  @infectioGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before infectioGUI is made visible.
function infectioGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to infectioGUI (see VARARGIN)

% Choose default command line output for infectioGUI

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%adding logo file here
%axes(handles.logo)
%imshow(fullfile([caps.path.app_root() '/src/matlab/logo.png']));
Im = imread(fullfile([caps.path.app_root() fullfile('src','matlab','logo.png')]));
%scz = get(0, 'screensize');
pos = get(hObject,'Position');

AxesH = axes('Units', 'pixels', 'position', [60, pos(4) - 130, 745, 100], 'Visible', 'off');
image(Im, 'Parent', AxesH);
set(AxesH,'Visible','off');

% Get the list of models
modelDirPath = fullfile('+caps','+models');
%store the path to the models
setappdata(handles.ModelParametersListbox, 'modelDirPath', modelDirPath);
modelFilePattern = 'VirusModel_*.m';
%read all the files into nested cell array
modelsList = dir(fullfile(modelDirPath,modelFilePattern));
%create a cell array of file names to pass to GUI
%for i = length(modelsList)
set(handles.ModelParametersListbox,'String',{modelsList(:).name});
%Set global variable to track if the analysis has been started
setappdata(0,'isAnalysisRunning',0);

global usingGUI;
usingGUI = true;




%
% UIWAIT makes infectioGUI wait for user response (see UIRESUME)
% uiwait(handles.GUImain);


% --- Outputs from this function are returned to the command line.
function varargout = infectioGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawnow;
import caps.utils.*;
import caps.models.*
global usingGUI;
global outputFolder;
global t_handles;

t_handles = handles;
outputFolder = get(handles.output_folder,'String');

if (~getappdata(0,'isAnalysisRunning')) && isdir(outputFolder)
    try
        setappdata(0,'handles', handles);
        set(hObject,'String','Cancel');
        setappdata(0,'isAnalysisRunning',1);
        %Get params from the GUI
        modelList = get(handles.ModelParametersListbox,'String');
        modelID = get(handles.ModelParametersListbox,'Value');
        [~ , modelSelected , ~]= fileparts(char(modelList(modelID,1)));
        writeinlog(handles.log_output,['Model selected: ', modelSelected]);
        writeinlog(handles.log_output,'Running the simulation, please standby...');
        
        % call the simulation here
        feval(['caps.models.', modelSelected]);
        set(hObject,'String','Run');
        writeinlog(handles.log_output,'Simulation run finished successfully');
        writeinlog(handles.log_output,['Result images saved in: ', outputFolder]);
    catch errorMsg
        setappdata(0,'isAnalysisRunning',0);
        set(hObject,'String','Run');
        set(hObject,'Enable','On');
        disp(errorMsg)
        writeinlog(handles.log_output,strcat({'ERROR: '},errorMsg.message));
    end
    set(hObject,'Enable','On');
    setappdata(0,'isAnalysisRunning',0);
    
elseif (getappdata(0,'isAnalysisRunning') == 1)
    disp('CANCELLED');
    caps.utils.writeinlog(handles.log_output, 'Executing action, please stand by...');
    set(hObject,'Enable','On');
    drawnow;
    setappdata(0,'isAnalysisRunning',0);
    set(hObject,'String','Run');
    
elseif (~isdir(outputFolder))
    writeinlog(handles.log_output, 'Your output is not a valid directory');
end


% --- Executes on selection change in ModelParametersListbox.
function ModelParametersListbox_Callback(hObject, eventdata, handles)
% hObject    handle to ModelParametersListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ModelParametersListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ModelParametersListbox


% --- Executes during object creation, after setting all properties.
function ModelParametersListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModelParametersListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_log_button.
function save_log_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_log_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,FilterIndex] = uiputfile('*','Save Log File',[datestr(now,'yymmdd') 'log.txt']);
disp(FileName);
if(exist('FileName'))
    fid = fopen( fullfile(PathName,FileName),'w+');
    cell = get(handles.log_output,'String');
    if class(cell) == 'cell'
        fprintf(fid, '%s\n', cell{:});
    else
        fprintf(fid, '%s\n', cell(:));
    end
    fclose(fid);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to log_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of log_output as text
%        str2double(get(hObject,'String')) returns contents of log_output as a double


% --- Executes during object creation, after setting all properties.
function log_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to log_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isdir(get(hObject,'String')))
    outputFolder = uigetdir(get(hObject,'String'));
else
    outputFolder = uigetdir('');
end
if(outputFolder)
    set(handles.output_folder,'String',outputFolder);
end



function output_folder_Callback(hObject, eventdata, handles)
% hObject    handle to output_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of output_folder as text
%        str2double(get(hObject,'String')) returns contents of output_folder as a double


% --- Executes during object creation, after setting all properties.
function output_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when GUImain is resized.
function GUImain_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to GUImain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% % menu functions
% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function About_menu_Callback(hObject, eventdata, handles)
% hObject    handle to About_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isunix)
    web('http://infectio.github.io/', '-browser')
    
else
    system('start http://infectio.github.io/')
end


% --------------------------------------------------------------------
function Help_item_Callback(hObject, eventdata, handles)
% hObject    handle to Help_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isunix)
    web('http://infectio.github.io/help.html', '-browser')
    
else
    system('start http://infectio.github.io/help.html')
end


% --------------------------------------------------------------------
function Quit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Quit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global usingGUI;
usingGUI = false;
close all force
