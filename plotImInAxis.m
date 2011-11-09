function plotImInAxis(im,hAx,str)
    imageProp = { 'ButtonDownFcn'};
    imageVal = { 'openSpecificImage( guidata(gcf) )'};
    
    imagesc(im,imageProp,imageVal,'parent',hAx );                               % Scale data and display image object
    axis(hAx,'image');                                                          % sets the aspect ratio so that equal tick mark
                                                                                % increments on the x-,y- and z-axis are equal in size.
                                                                                % the plot box fits tightly around the data.
    axis(hAx,'off');                                                            % turns off all axis labeling, tick marks and background.
    %drawnow;                                                                   % draw image