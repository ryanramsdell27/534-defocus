function img_depth = generateDepth(img_seg, face, leye, reye)
% img_seg is the segmented face, assumed to be uint8 x by y image
% face is the center of the face and width height: x, y, width, height
% leye, reye are left and right bounding box centers for eyes
[img_x, img_y] = size(img_seg);
face_index = face(2):img_x;
leye_index = leye(2):img_x;
reye_index = reye(2):img_x;

face_segs = img_seg(face_index, face(1));
leye_segs = img_seg(leye_index, leye(1));
reye_segs = img_seg(reye_index, reye(1));

segs = union(union(leye_segs,reye_segs),face_segs);
segs = face_segs;
focal_plane = uint8(1-ismember(img_seg,segs));
gradient = (img_x:-1:1)'/(30*img_x);
gradient = uint8(255*gradient/max(max(gradient)))
img_depth = focal_plane.*gradient;
% img_depth = im2uint8(img_depth);
imshow(img_depth);
% img_depth(leye_line) = 
end

