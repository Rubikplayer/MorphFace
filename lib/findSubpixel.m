% function: find pixel value in inverse mapping
% Tianye Li

function pixel = findSubpixel( image, row, col )

height  = size(image, 1);
width   = size(image, 2);
channel = size(image, 3);
assert( channel == 1 || channel == 3, 'channel of image must be 1 or 3' );

if (row <= 0 || row >= height+1) || (col <= 0 || col >= width+1)
    if channel == 3
        pixel = [0;0;0];
        return;
    else
        pixel = 0;
        return;
    end
end


if col <= 1
    left = 1; 
    right = 1;
    alpha = 0;
elseif col >= width
    left = width; 
    right = width;
    alpha = 0;
else
    left   = floor(col);
    right  = left + 1;
    alpha = col - left;
end

if row <= 1
    top = 1;
    bottom = 1;
    beta = 0;
elseif row >= height
    top = height;
    bottom = height;
    beta = 0;
else
    top = floor(row);
    bottom = top + 1;
    beta  = row - top;
end


if channel == 3
    pixel = zeros(3,1);
    for c = 1:3
        pixel(c) = (1-alpha) * (1-beta) * image(top, left, c)...
            +          alpha * (1-beta) * image(top, right, c)...
            +      (1-alpha) * beta     * image(bottom, left, c)...
            +          alpha * beta     * image(bottom, right, c);
    end
    
else
    pixel = (1-alpha) * (1-beta) * image(top, left)...
        +       alpha * (1-beta) * image(top, right)...
        +   (1-alpha) * beta     * image(bottom, left)...
        +       alpha * beta     * image(bottom, right);
end


end