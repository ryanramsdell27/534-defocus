function img_depth = generateDepth(img_seg, face, leye, reye)
% img_seg is the segmented face, assumed to be uint8 x by y image
% face is the center of the face and width height: x, y, width, height
% leye, reye are left and right bounding box centers for eyes

[img_x, img_y] = size(img_seg);

%% Select all indecies directly below face center and eyes
face = double(face);
leye = double(leye);
reye = double(reye);
face_index = face(2):img_x;
leye_index = leye(2):img_x;
reye_index = reye(2):img_x;
% Select segments below eyes and face
face_segs = img_seg(face_index, face(1));
leye_segs = img_seg(leye_index, leye(1));
reye_segs = img_seg(reye_index, reye(1));

% initial_segs = union(union(leye_segs,reye_segs),face_segs);
% segs = [];
% num_modes = 2;
% m = 0;
% while m < num_modes && ~isempty(initial_segs)
%     top_mode = mode(initial_segs);
%     segs = [segs, top_mode];
%     initial_segs = initial_segs(find(initial_segs ~= top_mode));
%     m = m + 1;
% end
%     
segs = img_seg(face(2),face(1));
% segs = [134,13];%img_seg(399, 742), img_seg(196,730)];
%% Create separate focal plane from background
focal_plane = ismember(img_seg,segs);
se = strel('disk', 10);
focal_plane = imclose(focal_plane, se);
focal_plane = uint8(1-focal_plane);

gradient = (img_x:-1:1)'/(30*img_x);
gradient = uint8(255*gradient/max(max(gradient)));
img_depth = focal_plane.*gradient;
% imshow(img_depth);
end
