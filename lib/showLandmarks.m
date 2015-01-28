% function: show landmarks on image
% Tianye Li

function showLandmarks(image, landmarks)

imagesc(image);
if size(image,3) == 1
    colormap(gray);
end

hold on;
axis image;
axis off;

if size(landmarks,1) == 1 || size(landmarks,2) == 1
    point_num = length( landmarks ) / 2;
    points = zeros(2,point_num);
    
    [height, width, ~] = size(image);
    % landmarks = round(landmarks);
    
    for i = 1:point_num
        points( :,i ) = ( [ landmarks(2*i-1)+width/2; -landmarks(2*i)+height/2 ] );
    end
else
    points = landmarks;
end

plot( points(1,:), points(2,:) ,'r.','markersize',15);

drawnow;

end