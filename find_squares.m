
% FIND_SQUARES  Find the squares in the template
% Author:       Timothy Sipkens
% Data:         October 1, 2019
%=========================================================================%
function [bb2,id,rgb_sq] = find_squares(img)

img_gr = rgb2gray(img);
expected_size = numel(img_gr);
expected_size = round(expected_size/770);

img_bw = ~imbinarize(img_gr,graythresh(img_gr)+0.05);
img_fill = imfill(img_bw,'holes');
img_area = bwareaopen(img_fill,expected_size);
img_final = logical(img_area);
stat = regionprops(img_final,'boundingbox');
bb = [];

for ii=length(stat):-1:1
    bb(ii,:) = round(stat(ii).BoundingBox);
end

ind_remove = and(or(isoutlier(bb(:,3)),isoutlier(bb(:,4))),...
    or(bb(:,3)>mean(bb(:,3)),bb(:,4)>mean(bb(:,4))));
bb(ind_remove,:) = []; % remove outliers with area larger than mean


%-- Sort and label squares -----------------------------%
[id_c,cent_c] = kmeans(bb(:,1),7);
[~,idx_c] = sortrows(cent_c);
[~,idx_c] = sortrows(idx_c);
id_c2 = idx_c(id_c);

[id_r,cent_r] = kmeans(bb(:,2),6);
[~,idx_r] = sortrows(cent_r);
[~,idx_r] = sortrows(idx_r);
id_r2 = idx_r(id_r);

col = [1,1,2,2,2,2,3,4,5,6,6,6,6,7,7];
row = [1,6,2,3,4,5,2,2,2,2,3,4,5,1,6];

id = zeros(size(id_c2));
for ii=1:length(id)
    t0 = find(and(id_c2(ii)==col,id_r2(ii)==row));
    if ~isempty(t0)
        id(ii) = t0;
    end
end


%-- Shrink shapes and average colour --------------------------%
shrink = 16;
bb2(:,3:4) = bb(:,3:4)-shrink;
bb2(:,1:2) = bb(:,1:2)+shrink/2;
hold on;
rgb_sq = [];
for ii=length(bb2):-1:1
    img_sq = double(img(bb2(ii,2):(bb2(ii,2)+bb2(ii,4)),...
        bb2(ii,1):(bb2(ii,1)+bb2(ii,3)),:));
    rgb_sq(ii,:) = mode(reshape(double(img_sq),...
        [size(img_sq,1)*size(img_sq,2),3]));
end
hold off;

bb2 = abs(bb2);

end

