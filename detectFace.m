function [face,eyePos] = detectFace(img)

%I = imread('pics/7.jpg');
I = img;
%Return Face center x and y positions, and each side of the eyes x and y
%positions. 

% For Face
faceDetect = vision.CascadeObjectDetector;
bbFace = step(faceDetect, I);

faceDetect.MergeThreshold = 10;

%Get Necessary Face positions 
for i=1:size(bbFace,1)
    face = bbFace(i,:);
end


%figure, imshow(I);
%hold on;
%for i=1:size(bbFace,1)
%    rectangle('Position',bbFace(i,:),'LineWidth', 5,'LineStyle','-','EdgeColor','r');
%end
%hold off;
%Face Returns vector with variables of face: [x,y,width,height]

%Eyes Detection

eyeDetector = vision.CascadeObjectDetector('EyePairBig');
bbEyes = step(eyeDetector,I);

[x,y,z] = size(bbEyes);
eyes = bbEyes(x,:,:);


%Calculate edge of eye positions
x2 = eyes(1);
width = eyes(4)/2;

%Get x values for edge of eye positions
realx = x2 - width;
realx2 = x2 + width;
k = imcrop(I, eyes);

realx = int8(realx);
realx2 = int8(realx2);
% eyePos returns x values for edge of eye box, y value of center, height, and
% width
eyePos = [realx, realx2,eyes(2),eyes(3),eyes(4)];

