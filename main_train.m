
clear;
close all
clc;
addpath matlab

rgb = readmatrix('test.csv');
ec = rgb(:, 4);
oc = rgb(:, 5);
rgb = rgb(:, 1:3);

xyz = rgb2xyz(rgb);
lab = rgb2lab(rgb);
lch = rgb2lch(rgb);

% p1 = pca([rgb,lab,lch,ec]);
% p2 = pca([rgb,lab,lch,oc]);

b_name = 'oc';
b = eval(b_name);
% A = [ones(size(rgb,1),1), rgb(:,1)];
A = [ones(size(rgb,1),1), rgb, lab, ...
    lch(:, 2:end), lab(:,2)./lab(:,3)];
A = [ones(size(rgb,1),1), rgb(:,1), lab, ...
    lch(:, 2:end), lab(:,2)./lab(:,3)];

f_pca = 0;
if f_pca
    [coeffs, score, roots] = pca(A(:,2:end)); % principle component analysis
    pct = roots ./ sum(roots) % percent explained by each basis
    A = [ones(size(rgb,1),1), score];
end



% A = (score1'*score1) \ score1' * (ec./oc);
x = (A'*A) \ A' * b;

if f_pca
    trnc = 5;
    x(trnc+1:end) = 0;
end

b1 = A * x;

out = [b, b1]
x


figure(1);
plot(b, b1, '.');
hold on;
xlims = xlim;
plot(xlim, xlim);
hold off;
xlabel(b_name);
ylabel([b_name, ' fit']);


figure(2);
t0 = abs(corrcov(cov([A(:,2:end),b])));
imagesc(t0);
colormap(gray);


r0 = 1:25:251;
g0 = 1:10:251;
[r1,g1] = ndgrid(r0,g0);




