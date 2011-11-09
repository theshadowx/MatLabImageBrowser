function organize_image(dirName,files,handles)
    global N page MaxIndDraw;
    
    if isstruct(files) 
        files={files.name};
    end
   
   if ~iscell(files)
        temp = files;
        files = cell(1);
        files{1} = temp;
   end
    
   cd(dirName);                                                                 % change the current folder to the directory mentionned in dirName
   setappdata(handles.figure1,'files',files);                                   % store the filesname in the figure handle
   N= size(files,2);                                                            % getting the number of files
   page=1;                                                                      % initializing the current page
    
   if (N==0)                                                                    % if there is no file in the directory mentioned 
        warndlg(sprintf('No files with this type in this directory'),'!! Warning !!');% show a warning telling 
        return;                                                                 % and get out of the function
   end
   

    showpageim(handles);                                                        % show image in the page
    
    if MaxIndDraw==N                                                            % if we are in the last page  disable the next button
        set( handles.next_but,'enable','off');
    end
    set( handles.prev_but,'enable','off');                                      % as this function is aimed to be applied for the first page so
                                                                                % the previous button must be disabled