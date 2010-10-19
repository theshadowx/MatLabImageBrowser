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

% Last Modified by GUIDE v2.5 24-Apr-2010 11:11:09

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
global dirName files maxNumCols maxNumFiles
dirName='/media/Media/themes/wallpaper';
addpath(dirName);                   % ajouter le chemin
maxNumFiles = 200;                          % Nombre maximal d'images
maxNumCols = 4;                             % Nombre maximal de colonnes
files=dir(fullfile(dirName,'*.bmp'));
organize_image(dirName,files,maxNumFiles,maxNumCols,handles);
handles.output = hObject;
setappdata(handles.figure1,'actionItems',[handles.imageSelection,handles.Type_im,handles.pathfolder]); % ajouter le bouton imageSelection comme donnée dans  "handles.figure1"
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = image_browser_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




% elle est appelée à chaque fois qu'on clique sur "imageSelection"

% --- Executes on button press in imageSelection.
function imageSelection_Callback(hObject, eventdata, handles)
    global dirName maxNumCols maxNumFiles
    set(handles.cancel,'value',0);              % initialiser le bouton 'Cancel'

  % selection des images à afficher  
  % ce qui va se traduire par les noms des fichiers et leur chemin 
    [files_ dirName] = uigetfile({'*.png ; *.jpg;*.bmp'},'MultiSelect','on');
    if ~dirName                                  % si rien n'est selectionner
        return;
    end
    set(handles.Type_im,'value',4);
    organize_image(dirName,files_,maxNumFiles,maxNumCols,handles);
  

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gestion du slider permettre de mouvoir le panneau 
% d'affichage
    
    % --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    pos = get(handles.uipanel1,'position');       % extraire la position du panneau 
    hight = pos(4);                               % la hauteur
    if hight > 1                                  % si la hauteur du panneau est plus grande que la fenêtre
        val = get(hObject,'value');                % obtention de la position du slider         
        yPos = -val * (hight-0.95);               % convertir en position du panneau
        pos(2) = yPos;                            
        set(handles.uipanel1,'position',pos);     % modifier la position du panneau
    end


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cette fonction permet d'oganiser la position et la taille 
% des images dependant de leurs nombres

function organize_image(dirName,files,maxNumFiles,maxNumCols,handles)
    global type
    pos=[0 0 0.974 0.92];
    set(handles.uipanel1,'position',pos);   % affectation du changement pour panneau
    set( handles.slider1,'enable','off'); % de même pour slider
    
    if ~dirName                                  % si rien n'est selectionner
        return;
    else
        set(handles.pathfolder,'string',dirName);
    end
   if isstruct(files) 
    files={files.name};
   end
   
   if ~iscell(files)
        temp = files;
        files = cell(1);
        files{1} = temp;
   end
   
   cd(dirName);                                % changer le dossier courant en celui où se trouve les fichiers
   setappdata(handles.figure1,'files',files);  % grouper les fichier en un bloc "files"
   N= size(files,2);
   
   if (N==0) 
        warndlg(sprintf('No %s file in this directory',type),'!! Warning !!');
   end
   
   if iscell(files)
       if N > maxNumFiles                          % si le nombre de fichier est superieur au nombre Max
           warndlg(['Maximum number of files is ' num2str(maxNumFiles) '!'],'To many files'); % affichage d'un warning dialog  
           N = maxNumFiles;                        
           files = files(1:N);                     % on prend just les Nmax premieres images
       end
   end
        
    if N > maxNumCols^2                         % si nombre de fichiers est superieur au carré du nombre de collones max
        cols = maxNumCols;                      % Nombre de colonnes actuel est le max   
        rows = ceil(N/cols);                    % nombre de lignes (arrondir à l'entier super ou égale)
        ratio = rows/cols;              
        hight = ratio;                          % 
        pos = [0 -(hight-0.95) 0.97 hight];     % position du panneau 
        set(handles.uipanel1,'position',pos);   % affectation du changement pour panneau
        set( handles.slider1,'enable','on','value',1); % de même pour slider
    else
        cols = ceil( sqrt(N) );                 % Nombre de colonnes
        rows = cols - floor( (cols^2 - N)/cols ); % Nombre de ligne
        set( handles.slider1,'enable','off');    % desactivation du slider
    end
    
    setappdata(handles.figure1,'cols',cols);    % grouper les colonnes  et les ajouter comme donnée du handle.figure1
    
    rPitch = 0.98/rows;
    cPitch = 0.98/cols;
    axWidth = 0.9/(cols);
    axHight = (0.85/(rows));  
    hAxes = getappdata(handles.figure1,'hAxes');
    if ~isempty(hAxes)
        f = find ( ishandle(hAxes) & hAxes);
        delete(hAxes(f));
    end
    
    axesProp = {'dataaspectratio' ,...
                                'Parent',...
                                'PlotBoxAspectRatio', ...
                                'xgrid' ,...
                                'ygrid'};
    axesVal = {[1,1,1] , ...
                            handles.uipanel1,...
                            [1 1 1]...
                            'off',...
                            'off'};

    hAxes = zeros(N,1);
    ind = 1;
    hActions = getappdata(handles.figure1,'actionItems');   
    set(hActions,'enable','off');                           % verrouillage du bouton (imageSelection) 
    while ind<=N && ~get(handles.cancel,'value')             % tant que les images ne sont pas tous afficher et qu'on a pas cliqué sur le "Cancel"
        [r c] = ind2sub([rows cols],ind);
        x = 1-(c)*cPitch;
        y = 1-(r)*rPitch;
        hAxes(ind) = axes( 'position', [x y axWidth axHight],axesProp,axesVal); % création "axes" et la pointé par hAxes (axes handle)
        im = imread(fullfile(dirName,files{ind}));                % lire l'image
      	%im = imresize(im,1/4);                              
        plotImInAxis(im,hAxes(ind),files{ind},11-cols)      % afficher l'image dans la position déterminée avant
        pause(0.01);
        ind = ind + 1;
    end 
    set(hActions,'enable','on');                            %  Deverouillage
    set(handles.cancel,'value',0);                          % initialiser l'etat du bouton "Cancel"
    setappdata(handles.figure1,'hAxes',hAxes)               % Ajouter les figure comme donnée du handles.figure1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cette Fonction sert à mettre les images dans l'axes 
%  généré précédement en ajoutant le nom de l'image
% comme titre
    
function plotImInAxis(im,hAx,str,fontSize)
    imageProp = { 'ButtonDownFcn'};
    imageVal = { 'openSpecificImage( guidata(gcf) )'};
    
    % imagesc affiche l'image dans l'axes.
    % la propriété 'ButtonDownFcn' va permettre d'executer la fonction
    % 'openSpecificImage()'quand on click sur l'image.
    % l'argument 'guidata(gcf)' va extraire les données de figure
    % selectionnée .
    imagesc(im,imageProp,imageVal,'parent',hAx );   
    axis(hAx,'image');
    axis(hAx,'off');             % enlever les coordonnées
    str = strrep( str,'_',' ');  % remplacer '_' par ' '
    title( hAx,str,'fontsize',fontSize); % titre
    drawnow;


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)



function pathfolder_Callback(hObject, eventdata, handles)
global dirName

dirName=get(handles.pathfolder,'string');
checkdir=isdir(dirName);
if ~checkdir
    warndlg('No such directory','!! Warning!!');
    return;
end
Type_im_Callback(handles.Type_im, eventdata, handles);



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


% --- Executes on selection change in Type_im.
function Type_im_Callback(hObject, eventdata, handles)
global type files maxNumCols maxNumFiles dirName
str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val};
    case 'bmp'
        type='*.bmp';
    case 'jpg'
        type='*.jpg';
    case 'png'
        type='*.png';
    case 'any'
        type='all';
end
if(strcmp(type,'all'))
    files=dir(dirName);
    files=files(find(~strcmp({files(:).name},'.')));
    files=files(find(~strcmp({files(:).name},'..')));
else
    files=dir(fullfile(dirName,type));
end
organize_image(dirName,files,maxNumFiles,maxNumCols,handles);

% --- Executes during object creation, after setting all properties.
function Type_im_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
