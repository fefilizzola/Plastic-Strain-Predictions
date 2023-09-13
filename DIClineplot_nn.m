function [coords,s,pts] = DIClineplot_nn(INT,COORD)
% Produces points to be plotted as line plot
%     Input:  Interpolated DIC data struct;
%     Output: Vector of values along the selected line.
%
% Created by Renato Vieira

%Check if coordinates were passed
if ~exist('COORD','var')
    COORD = 0;
end

if COORD == 0
    I = INT.CM;
    IM = figure;
    imshow(I)
    
    roi = drawline;
    pos = customWait(roi);
    t = num2cell(pos(1:4));
    [X1,X2,Y1,Y2] = deal(t{:});
    
    close(IM)
else
    t = num2cell(COORD(1:4));
    [X1,X2,Y1,Y2] = deal(t{:});
end

coords = [X1,Y1;X2,Y2];

if abs(X1-X2) >= abs(Y1-Y2)
    a = (Y2-Y1)/(X2-X1);
    b = Y1-a*X1;
    X = round(linspace(X1,X2,abs(X2-X1)));
    Y = round(a*X+b);
end
if abs(X1-X2) < abs(Y1-Y2)
    a = (X2-X1)/(Y2-Y1);
    b = X1-a*Y1;
    Y = round(linspace(Y2,Y1,abs(Y1-Y2)));
    X = round(a*Y+b);
end

s = zeros(length(X));
pts = zeros(1,length(X));
for i = 1:length(X)
    s(i) = i;
    pts(i) = INT.IntStrains.Enn(Y(i),X(i));
end


    function pos = customWait(hROI)
        
        % Listen for mouse clicks on the ROI
        l = addlistener(hROI,'ROIClicked',@clickCallback);
        
        % Block program execution
        uiwait;
        
        % Remove listener
        delete(l);
        
        % Return the current position
        pos = hROI.Position;
        
    end
    function clickCallback(~,evt)
        
        if strcmp(evt.SelectionType,'double')
            uiresume;
        end
        
    end

end

