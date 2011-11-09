function varargout = image_browser(varargin)
% IMAGE_BROWSER M-file for image_browser.fig
%      IMAGE_BROWSER, by itself, creates a new IMAGE_BROWSER or raises the existing
%      singleton*.
%
%      H = IMAGE_BROWSER returns the handle to a new IMAGE_BROWSER or the handle to
%      the existing singleton*.
%
%      IMAGE_BROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_BROWSER.M with the given input arguments.
%
%      IMAGE_BROWSER('Property','Value',...) creates a new IMAGE_BROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_browser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_browser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_browser

% Last Modified by GUIDE v2.5 25-Oct-2011 20:56:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_browser_OpeningFcn, ...
                   'gui_OutputFcn',  @image_browser_OutputFcn, ...
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


% --- Executes just before image_browser is made visible.
function image_browser_OpeningFcn(hObject, eventdata, handles, varargin)
clc
global maxNumCols maxNumRows page N_Im_Draw NDelIm...
       dirName cPitch rPitch axWidth axHight N_err
maxNumCols = 4;                                                                % maximal number of colomns
maxNumRows = 4;                                                                % maximal number of rows
N_Im_Draw=16;                                                                  % number of images in each page
page=1;                                                                        % initialization of the current page 
N_err=0;                                                                       % initialization of number of errors
NDelIm=0;                                                                      % initialize the number of imge deleted
dirName='';                                                                    % initialization of the current directory name
rPitch = 0.98/maxNumRows;                                                      % Abcissa of the origin 
cPitch = 0.98/maxNumCols;                                                      % ordinate of the origin
axWidth = 0.9/maxNumCols;                                                      % width of the graph
axHight = 0.9/maxNumRows;                                                      % heigh of the graph
set(handles.prev_but,'enable','off');                                          % make the "previous" button deactivate
set(handles.next_but,'enable','off');                                          % make the "next" button deactivate
set(handles.slider1,'enable','off');                                           % deactivate the slider not used anymmore for now
set(handles.cancel,'enable','off');                                            % deactivate the cancel button
set(handles.pathfolder,'string',dirName);                                      % initialize the directory field 
setappdata(handles.figure1,'actionItems',...                                   % store GUI objects in the figure as a
                        [handles.imageSelection,...                            % collection named "actionItems"
                        handles.Type_im,...
                        handles.pathfolder,...
                        handles.next_but,...
                        handles.prev_but]...
           );
handles.output = hObject;                                                       
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = image_browser_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in imageSelection.
% its role to collecte the files selectionned with types of the image
function imageSelection_Callback(hObject, eventdata, handles)
    global dirName 
    set(handles.cancel,'value',0);                                              % initialize cancel button

    [files dirName FilterIndex] = uigetfile({...
                                '*.jpg;*.bmp;*png','All supported format(*.jpg;*.bmp;*png)';...
                                '*.bmp','Image format bmp (*.bmp)';...          % file selection with multiple 
                                '*.jpg','Image format jpg (*.jpg)';...          % filters
                                '*.png','Image format png (*.png)';...          %
                                },'MultiSelect','on');
    if ~dirName                                                                 % if no files selected nothing to do
        return;                                                                                         
    end
    set(handles.Type_im,'value',FilterIndex);                                   % change the popupmenu to the kind of images selected
    set(handles.pathfolder,'string',dirName);
    organize_image(dirName,files,handles);                                      % organize the images selected in the GUI
  

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *******         the slider is for now unused  *************** 
    
    % --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    pos = get(handles.uipanel1,'position');                                     % extract the position(x,y,width,height) of the pannel 
    hight = pos(4);                                                             % get the height
    if hight > 1                                                                % if the height of the pannel is higher than the window
        val = get(hObject,'value');                                             % get the position of the slider         
        yPos = -val * (hight-0.95);                                             %  
        pos(2) = yPos;                                                          % modify the position of the pannel correspondingly
        set(handles.uipanel1,'position',pos);                                   % with the slider position
    end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pathfolder_Callback(hObject, eventdata, handles)                      
global dirName
                                                                               % when the path of the folder is validated
dirName=get(handles.pathfolder,'string');                                      % check if the path exists
checkdir=isdir(dirName);
if ~checkdir                                                                  
    warndlg('No such directory','!! Warning!!');                               % if doesn't exist a warning message will be shown
    return;
end
Type_im_Callback(handles.Type_im, eventdata, handles);                         % get the files from the path directory written and with  
                                                                               % respect of the file extention selected in the popupmenu


% --- Executes during object creation, after setting all properties.
function pathfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in Type_im.
function Type_im_Callback(hObject, eventdata, handles)
global  files dirName

str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val};                                                                % popupmenu selection
    case 'any'                                                                  % extension for image files
        type='all';
    case 'bmp'
        type='*.bmp';
    case 'jpg'
        type='*.jpg';
    case 'png'
        type='*.png';
end

if isempty(dirName)                                                             % if no directory was mentioned before  
        return;                                                                 % nothing will be done
else                                                                            % else 
    set(handles.pathfolder,'string',dirName);                                   % set the path of the directory in the field
    if(strcmp(type,'all'))                                                      % if all supported files are selected
        
        filesjpg=dir(fullfile(dirName,'*.jpg'));                                % get all jpg files from the directory
        filesbmp=dir(fullfile(dirName,'*.bmp'));                                % get all bmp files from the directory
        filespng=dir(fullfile(dirName,'*.png'));                                % get all png files from the directory
        files=struct('name',{filesjpg.name filesbmp.name filespng.name},...     % merge all these files in one cell
                     'date',{filesjpg.date filesbmp.date filespng.date},...
                    'bytes',{filesjpg.bytes filesbmp.bytes filespng.bytes},...
                    'isdir',{filesjpg.isdir filesbmp.isdir filespng.isdir},...
                  'datenum',{filesjpg.datenum filesbmp.datenum filespng.datenum});
        organize_image(dirName,files,handles);                                  % ask to be shown in the GUI
    else
        files=dir(fullfile(dirName,type));                                      % if a specific extention is selected
        organize_image(dirName,files,handles);                                  % this type of images will be shown
    end
end


% --- Executes during object creation, after setting all properties.
function Type_im_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in prev_but.
function prev_but_Callback(hObject, eventdata, handles)
% hObject    handle to prev_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global page ;
	page=page-1;                                                                 % go to the previous page
    showpageim(handles)                                                          % show the pictures
    if page==1                                                                   % if it's the first page
        set( handles.prev_but,'enable','off');                                   % desactivate the button
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in next_but.
function next_but_Callback(hObject, eventdata, handles)
% hObject    handle to next_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global  N page MaxIndDraw;
	page=page+1;                                                                 % go to the next page
    showpageim(handles)                                                          % show the pictures
    if     MaxIndDraw==N                                                         % if we are it's last page
           set( handles.next_but,'enable','off');                                % deactivate the button
    end
