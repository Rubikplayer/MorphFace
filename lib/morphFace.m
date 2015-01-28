% function: morph and cross-dissolve face series
% Tianye Li

function [MergedFaces, WarpedOrigFaces, WarpedDestFaces]...
    = morphFace( origFace, destFace, origPts, destPts, nFrames )

% assume: 
% origFace, destFace: grayscale/RGB image with pixel values range in
%   [0,1] in double type
% origPts, destPts: both 2-by-n array whose columns store [x,y] coordinates
%   that starts from 1 from left-top of image.
% nFrames: a positive number >= 2

MergedFaces = zeros( size(origFace,1), size(origFace,2), size(origFace,3), nFrames );
WarpedOrigFaces = zeros(size(MergedFaces));
WarpedDestFaces = zeros(size(MergedFaces));

% compute triangulation for all frames
[ ~, pretriangle ] = triangulate( origFace, origPts );

for fr = 1:nFrames
    alpha = (fr-1) / (nFrames-1);
    
    if fr == 2
        wait = 1;
    end
    
    nowPts = (1-alpha) * origPts + alpha * destPts;
    
    nowOrig = warpFace( origFace, origPts, nowPts, pretriangle );
    nowDest = warpFace( destFace, destPts, nowPts, pretriangle );
    nowMerged = (1-alpha) * nowOrig + alpha * nowDest;
    
    WarpedOrigFaces(:,:,:,fr) = nowOrig;
    WarpedDestFaces(:,:,:,fr) = nowDest;
    MergedFaces(:,:,:,fr)     = nowMerged;
    
end




end