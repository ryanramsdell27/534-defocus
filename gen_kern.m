function kern = gen_kern(diameter)
%diameter = 1;
diameter = max(1, floor(diameter));
radius = diameter/2;
scale = 1.5;
center = scale*radius + 0.5;
% if mod(diameter, 2) == 1
%     center = center + 0.5;
% else
%     center = center - 0.0;
% end
comp_vec = [1:scale*diameter];
kern = zeros(uint8(scale*diameter));%2 * (comp_vec -radius).^2 <= radius^2;

for x = comp_vec
    for y = comp_vec
        kern(y,x) = (double(x)-center)^2  + (double(y)-center)^2 <= radius^2;
    end
end
kern = kern / sum(sum(kern)) + 0.0001;
kern = imgaussfilt(kern, 1);
% imshow(kern./max(max(kern)));
%kern = zeros(floor(diameter));
end