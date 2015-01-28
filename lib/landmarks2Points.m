% function: transform landmarks (1-D array) to 2-row coordinate matrix
% Tianye Li

function points = landmarks2Points(landmarks, imagesize)

if nargin == 1
    imagesize = [0,0,0];
end

height = imagesize(1);
width  = imagesize(2);


point_num = length( landmarks ) / 2;
points = zeros(2,point_num);


for i = 1:point_num
    points( :,i ) = ( [ landmarks(2*i-1)+width/2; -landmarks(2*i)+height/2 ] );
end

end