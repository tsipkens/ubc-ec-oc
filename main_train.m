
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

x = [rgb, lab, lch, ec./oc];
[coeffs, score, roots] = pca(x); % principle component analysis

pct = roots ./ sum(roots) % percent explained by each basis

basis = coeffs(:, 1:(end-1)); % basis functions
normal = coeffs(:, end); % normal vector


r0 = 1:25:251;
g0 = 1:10:251;
[r1,g1] = ndgrid(r0,g0);


% Truncate the number of bases considered
trnc = 3; % truncate at this number of bases to include
basis1 = basis(:, 1:trnc);
score1 = score(:, 1:trnc);

[n,p] = size(x);
x_mean = mean(x, 1);
x_fit = repmat(x_mean,n,1) + score1*basis1';
residuals = x(:,end) - x_fit(:,end);

error = abs(residuals);
sse = sum(error.^2)
pct_error = error ./ x(:,end);
out = [error, pct_error]

figure(1);
loglog(ec ./ oc, x_fit(:,end), '.');




