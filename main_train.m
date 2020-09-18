
clear;
close all
clc;
addpath matlab

rgb = readmatrix('test.csv');
ec = rgb(:, 4);
oc = rgb(:, 5);
rgb = rgb(:, 1:3);

lab = rgb2lab(rgb);
lch = rgb2lch(rgb);

% p1 = pca([rgb,lab,lch,ec]);
% p2 = pca([rgb,lab,lch,oc]);

x = [rgb, ec./oc];
[coeffs,score,roots] = pca(x); % principle component analysis

pct = roots ./ sum(roots) % percent explained by each basis

basis = coeffs(:, 1:(end-1)) % basis functions
normal = coeffs(:, end) % normal vector


r0 = 1:25:251;
g0 = 1:10:251;
[r1,g1] = ndgrid(r0,g0);


[n,p] = size(x);
x_mean = mean(x, 1);
x_fit = repmat(x_mean,n,1) + ...
    score(:,1:(end-1))*coeffs(:,1:(end-1))';
residuals = x - x_fit;
error = abs((x - repmat(x_mean,n,1)) * normal);
sse = sum(error.^2)
pct_error = error ./ x(:,end)