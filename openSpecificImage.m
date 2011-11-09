function openSpecificImage(handles)
    type = get(gcf,'SelectionType');
    switch type
        case 'open' % double-click
            im = get( gcbo,'cdata' );
            imtool(im, [min(im(:)) max(im(:))] )
            case 'normal'   
            %left mouse button action
        case 'extend'
            % shift & left mouse button action
        case 'alt'
            % alt & left mouse button action
end