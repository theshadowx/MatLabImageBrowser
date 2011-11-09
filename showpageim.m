function showpageim(handles)

global page dirName cPitch rPitch axWidth axHight N MaxIndDraw N_Im_Draw N_err ;

tot_page=floor(N/N_Im_Draw)+1;                                                 % Calculating the number of total pages
Nleft=mod(N,N_Im_Draw);                                                        % calculating the number of images in the last page
ind = 16*(page-1)+1;                                                           % update the start indice for the current serie of files
MaxIndDraw=N_Im_Draw*page;                                                     % update the last indice  for the current serie of files
Axes_Ind=1;                                                                    % initialize the index of the Axes
N_err=0;                                                                       % initialise the number of errors


Npage=sprintf('%d files - %d/%d pages',N,page,tot_page);                       % storing the number of files and pages information in Npage
set(handles.state_bar,'string',Npage);                                         % showing it in the state bar
set(handles.cancel,'enable','on');                                             % activate the cancel button
hActions = getappdata(handles.figure1,'actionItems');                          % get all the object stored in figure1 as 'actionItem'
set(hActions,'enable','off');                                                  % disable them to not be used during loading 
files=getappdata(handles.figure1,'files');                                     % get the names of the files
hAxes = getappdata(handles.figure1,'hAxes');                                   % Get the Axes from the figure
if ~isempty(hAxes)                                                             % if they containe sth
    f = find ( ishandle(hAxes) & hAxes);
    delete(hAxes(f));                                                          % delete them
end
if MaxIndDraw>N                                                                % In the last page, the number of images to be loaded may be less than  
    MaxIndDraw=N;                                                              % the image could be shown in the page.
    hAxes = zeros(Nleft,1);                                                    % allocate memory size as the reduced number of the images in the last page
    steps = Nleft;                                                             % make total steps of the progress bar to fit with the number of images in the page
else                                                                           % else for the other pages
    hAxes = zeros(N_Im_Draw,1);                                                % allocate memory as the same size as the number of the page images
    steps = N_Im_Draw;                                                         % make total steps of progress bar equal to the total number of images in the page
end

axesProp = {'dataaspectratio' ,...                                             % gathering the properties in one variable
                            'Parent',...
                            'PlotBoxAspectRatio', ...
                            'xgrid' ,...
                            'ygrid'};
axesVal = {[1,1,1] , ...                                                       % gathering the Values of the properties respectively in one variable
                        handles.uipanel1,...
                        [1 1 1]...
                        'off',...
                        'off'};


                                           


h = waitbar(0,'Loading images, please wait...');
step=1;

 
while ind<=MaxIndDraw && ~get(handles.cancel,'value')                           % while the current index is samaller than the last index i
    [r c] = ind2sub([4 4],Axes_Ind);                                            % transforme the Index of the Axes to index matrix
    x = 1-(c)*cPitch;                                                           % calculating the abscissa of the origine of the graph
    y = 1-(r)*rPitch;                                                           % calculating the ordiante of the origine of the graph
    hAxes(Axes_Ind) = axes( 'position', [x y axWidth axHight],axesProp,axesVal); % création "axes" et la pointé par hAxes (axes handle)
    try                                                                         %
        im = imread(fullfile(dirName,files{ind}));                              % read the image
        plotImInAxis(im,hAxes(Axes_Ind),files{ind})                             % Plot the image in the graph   
        waitbar(step / steps)                                                   % updating the progress bar
        Axes_Ind=Axes_Ind+1;                                                    % incrementing the index of the Axes
        step=step+1;                                                            % incrementing progress bar step
    catch
        N_err=N_err+1;                                                          % incrementing the error number
        delete(hAxes(Axes_Ind));                                                % delete the axes not used
        if(page~=tot_page)                                                      % if it's not the last page
            MaxIndDraw=MaxIndDraw+1;                                            % incremebting in order not to leave the void in the page
        end
    end 
    ind=ind+1;                                                                  % incrementing the indice used for the files
end 

close(h)                                                                        % after all images are loaded, close the progress bar

if N_err~=0                                                                     % if there is error
    ErrMess=sprintf('%d errors while loading images',N_err);                    % show message telling the number of error while loading images
else
    ErrMess=sprintf('');                                                        % else if there is no error, nothing to be shown
end
set(handles.warn_txt,'string',ErrMess);                                         % write message in the error bar
set(hActions,'enable','on');                                                    % enable the action items
set(handles.cancel,'value',0);                                                  % initialize the cancel button state
set(handles.cancel,'enable','off');                                             % disactivate the cancel button
setappdata(handles.figure1,'hAxes',hAxes)                                       % update the Axes in the handle 