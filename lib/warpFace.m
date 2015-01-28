% function: warp face
% Tianye

function [warped_face, mask] = warpFace( face,...
                                        orig_landmarks,...
                                        dest_landmarks,...
                                        pretriangle,...
                                        isDisplay )

% imageid = 20;
% 
% % orig face and dest face
% face = faceImg(:,:,imageid);
% face2 = faceImg(:,:,imageid+1);
% 
% landmarks = faceLandmarks(imageid,:);
% landmarks2 = faceLandmarks(imageid+1,:);

% given above
% assume gray-scale image

if size(orig_landmarks,1) == 1
    orig = landmarks2Points( orig_landmarks, size(face) );
else
    orig = orig_landmarks;
end
if size(dest_landmarks,1) == 1
    dest = landmarks2Points( dest_landmarks, size(face) );
else
    dest = dest_landmarks;
end

if nargin == 5
    % triangulate and generate mask that indicates triangle regions
    [ mask, triangle ] = triangulate( face, dest, pretriangle );
    
elseif nargin == 4
    [ mask, triangle ] = triangulate( face, dest, pretriangle );
    isDisplay = false;
    
elseif nargin == 3
    [ mask, triangle ] = triangulate( face, dest );
    isDisplay = false;
    
end



% compute inverse transform for all triangles
invTransform = zeros( 3, 3, size(triangle,1) );
for i = 1:size(triangle, 1)
    dest_points = ones(3,3);
    dest_points(1:2, :) = dest( 1:2, triangle(i,:) );
    orig_points = ones(3,3);
    orig_points(1:2, :) = orig( 1:2, triangle(i,:) );
    
    invTransform(:,:,i) = orig_points / dest_points;
    
end

% backward warp face
warped_face = zeros(size(face));
height = size(warped_face, 1);
width  = size(warped_face, 2);

for r = 1:height
    for c = 1:width
        if mask(r,c) % if in a triangle
            % this coordinate
            x = c;
            y = r;
            
            % trace-back coordinate
            back = invTransform(:,:,mask(r,c)) * [x;y;1];
            back_row = back(2);
            back_col = back(1);
            
            % interpolate pixel values
            warped_face(r,c,:) = findSubpixel( face, back_row, back_col );
        end
        
    end % for all col
end % for all row

% display
if isDisplay
    figure;
    subplot(1,2,1);
    imagesc(face); colormap(gray); axis image; axis off;
    hold on;
    for i = 1:size(triangle,1)
        plot( [orig(1, triangle(i,:)) orig(1, triangle(i,1))],...
            [orig(2, triangle(i,:)) orig(2, triangle(i,1))], '-ro');
        hold on;
    end
    hold off;
    
    subplot(1,2,2);
    imagesc(warped_face); colormap(gray); axis image; axis off;
    hold on;
    for i = 1:size(triangle,1)
        plot( [dest(1, triangle(i,:)) dest(1, triangle(i,1))],...
            [dest(2, triangle(i,:)) dest(2, triangle(i,1))], '-ro');
        hold on;
    end
    hold off;
    
end

end