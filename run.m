%% Segment

img = imread('person.jpg');
face = [162,151];

% for x = 1:10
img_s = segment(img, face);
img_lab = label2rgb(img_s);
% f1=figure;
se = offsetstrel('ball',2,2);
img_e = imerode(uint8(img_s / max(max(img_s)) * 255),se);
imshow(img_e);
% hold on;
% scatter(109,228);
% imwrite(img_lab, strcat('output/british_rail', num2str(x),'.jpg'));
% end
% imshow(img_s);

%% Blur
% img = imread('im0.png');
% img_depth = imread('im.pgm');
% [img_depth, sf] = parsePfm('disp0.pfm');
% img_depth = imcomplement(img_depth*sf);
% %img_depth = img_depth*255/max(max(img_depth));
% img_depth = im2uint8(img_depth);
% img_depth(img_depth==0)=255;
% %imshow(img_depth);
% imgr = img(:,:,1);
% imgg = img(:,:,2);
% imgb = img(:,:,3);
% 
% %img_depthr = img_depth(:,:,1);
% %img_depthg = img_depth(:,:,1);
% %img_depthb = img_depth(:,:,1);
% 
% outr = defocus(imgr, img_depth);
% outg = defocus(imgg, img_depth);
% outb = defocus(imgb, img_depth);
% 
% out = im2uint8(zeros(size(img)));
% out(:,:,1) = outr;
% out(:,:,2) = outg;
% out(:,:,3) = outb;
% 
% imshow(out);
% imwrite(out, 'render2.png');