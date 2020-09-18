
% PLOT_ANNOTATIONS  Plot annotations on top of the selected image
% Author:	Timothy Sipkens
% Data:     October 1, 2019
%=========================================================================%
function [] = plot_annotations(img,rgb_sq,id,bb2,rgb_circle,centers,radii,radii2)

imshow(img);

hold on;
for ii=1:length(bb2)
    rectangle('position',bb2(ii,:),'edgecolor','g','linewidth',2);
    text(bb2(ii,1)+10,bb2(ii,2)+10,[num2str(id(ii)),...
        ' (',num2str(rgb_sq(ii,1),'%5.0f'),',',...
        num2str(rgb_sq(ii,2),'%5.0f'),',',...
        num2str(rgb_sq(ii,3),'%5.0f'),')'],...
        'Color','g','FontSize',7);
end

viscircles(centers,radii,'Color','y');
viscircles(centers,radii2,'Color','r');
text(centers(1)+radii2,centers(2),...
    [' (',num2str(rgb_circle(1),'%5.0f'),',',...
    num2str(rgb_circle(2),'%5.0f'),',',...
    num2str(rgb_circle(3),'%5.0f'),')'],...
    'Color','r');
hold off;


end

