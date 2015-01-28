% function: triangulize
% Tianye

function [ mask, triangle ] = triangulate( image, points, pretriangle, isDisplay )

% image = zeros(640, 480);

% pt_num = 122;
% points = zeros(2, pt_num);
%
% points(1,:) = randi(size(image,2), 1, pt_num);
% points(2,:) = randi(size(image,1), 1, pt_num);

if nargin == 4
    triangle = pretriangle;
    
elseif nargin == 3
    isDisplay = false;
    triangle = pretriangle;
    
elseif nargin == 2
    isDisplay = false;
    triangle = delaunay( points(1,:), points(2,:) );
end

% given image size, control points



% figure;
% imshow(image); hold on;
%
% for i = 1:size(triangle,1)
%     plot( [points(1, triangle(i,:)) points(1, triangle(i,1))],...
%         [points(2, triangle(i,:)) points(2, triangle(i,1))], '-ro');
%     hold on;
% end

[XX, YY] = meshgrid( 1:size(image,2), 1:size(image,1) );
all_x = XX(:);
all_y = YY(:);

mask_1D = zeros(size(image,1)*size(image,2),1);

for i = 1:size(triangle,1)
    in_trig = inpolygon( all_x, all_y,...
        points(1,triangle(i,:)), points(2,triangle(i,:)) );
    mask_1D( in_trig ) = i;
end

mask = reshape(mask_1D, size(image,1), size(image,2));

if isDisplay
    figure;
    imagesc( mask ); 
    axis image; axis off;
    hold on;
    for i = 1:size(triangle,1)
        plot( [points(1, triangle(i,:)) points(1, triangle(i,1))],...
            [points(2, triangle(i,:)) points(2, triangle(i,1))], '-ro');
        hold on;
    end
end

end