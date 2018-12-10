clear
clc
%% Load image
fprintf('Loading image\n');
img = imread('pics/5.jpg');
ratio = 1000/size(img,1);
[x,y,z] = size(img);
img = imresize(img, [x,y]*ratio );


%% Find face features
fprintf('Finding face features\n');
face = [308,332];%[433, 343];%[164,223];
leye = [300,302];%[390, 310];%[145,216];
reye = [356,301];%[475, 301];%[177,216];
% detectFace(img);
%% Segment
fprintf('Segmenting image\n');
img_seg = meanshift(img, face,0.2); % segmented image
img_lab = label2rgb(img_seg); % rgb labeled imaged for debugging
img_seg = uint8(img_seg / max(max(img_seg)) * 255); % map to uint8
se = offsetstrel('ball',2,2); % structuring element used in image erosion
img_seg = imerode(img_seg,se);

%% Generate Depth Map
fprintf('Generating depth map\n');
img_depth = generateDepth(img_seg, face, leye, reye);
img_depth = imgaussfilt(img_depth, 4);
% imshow(img_depth);

%% Blur
fprintf('Blurring image\n');

imgr = img(:,:,1);
imgg = img(:,:,2);
imgb = img(:,:,3);

outr = defocus(imgr, img_depth);
outg = defocus(imgg, img_depth);
outb = defocus(imgb, img_depth);

out = im2uint8(zeros(size(img)));
out(:,:,1) = outr;
out(:,:,2) = outg;
out(:,:,3) = outb;

out = out+20;
img_d = cat(3, img_depth, img_depth, img_depth);
composite = [img, img_lab,img_d, out];
imshow(composite);
%% Clean
clear imgb imgg imgr leye reye se x y z outb outg outr face ratio img_d

% imwrite(out, 'render2.png');