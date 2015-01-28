%% Face Morphing
%  Given two images of face and manually labelled landmarks (for both),
%  this code can create a video that morphs one face to another
%  consecutively. 
%  This script produces one such example.
%  by Tianye Li <tianye.focus@gmail.com>, Jan.28,2015  

%% initialization
clear; clc; close all;
addpath('./lib');
addpath('./img');

%% read images and landmarks
origin = double( imread('junior_drew.png') ) / 255;
target = double( imread('senior_drew.png') ) / 255;

% read landmarks
get_landmarks;

% show landmarks
figure; 
subplot(1,2,1); showLandmarks( origin, origPts );
subplot(1,2,2); showLandmarks( target, destPts );

disp('image and landmarks ok');
%% morph faces

% parameters of output video
fps = 30;      % frame per second
duration = 2;  % second
nFrames = duration * fps + 1;


% morph faces
tic;
[MergedFaces, WarpedOrigFaces, WarpedDestFaces]...
    = morphFace( origin, target, origPts, destPts, nFrames );
toc;

% if want, you can flip the frames so that the video will morph the face
% back in the second half
MergedFaces_back = flip( MergedFaces, 4 );
Frames = cat( 4, MergedFaces, MergedFaces_back );

% use movie tool in matlab to display
mov = immovie(Frames);
implay(mov);

disp('morphing ok');
%% write frames and video

% write video frames
spec = ['./frames/morph_%0', num2str(floor(log10(nFrames)+1)), 'd.png'];
for i = 1:nFrames
    filepath = sprintf( spec, i );
    disp(['writing frame', num2str(i), ' at ', filepath]);
    imwrite( Frames(:,:,:,i), filepath, 'png' );
end

% write video
videopath = './output/Morph.avi';
disp(['writing video at ', videopath]);
writerObj = VideoWriter(videopath);
open(writerObj);
writeVideo(writerObj,mov);
close(writerObj);

disp('all set!');
