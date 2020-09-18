
% FIND_CIRCLES  Find the squares in the template
% Author:       Timothy Sipkens
% Data:         October 1, 2019
%=========================================================================%
function [centers,radii,radii2,rgb_circle] = find_circles(img)

img_size = length(img(:,1,1));
max_circle = round(img_size/4);
min_circle = round(img_size/5.8);

[centers,radii] = ...
    imfindcircles(img,[min_circle,max_circle],...
    'Sensitivity',0.982);


%-- Find new center circle and average colour ----------------%
radii2 = radii/4;

[grid_x,grid_y] = meshgrid(1:size(img,2),1:size(img,1));
dist_x = grid_x-centers(1);
dist_y = grid_y-centers(2);
in_circle = sqrt(dist_x.^2+dist_y.^2)<radii2;

img_circle = [];
for ii=3:-1:1
    t0 = img(:,:,ii);
    img_circle(:,ii) = t0(in_circle);
end
rgb_circle = mode(img_circle);


end

