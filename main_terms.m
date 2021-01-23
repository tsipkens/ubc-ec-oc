
clear;
close all
clc;
addpath matlab;


% Read and interpret RGB and EC/OC data.
data = readmatrix('test.csv');
ec = data(:, 4);
oc = data(:, 5);
rgb = data(:, 1:3);
r = rgb(:,1);
g = rgb(:,2);
b = rgb(:,3);


% Get converted values.
lab = rgb2lab(rgb);
l = lab(:,1);
a = lab(:,2);
b0 = lab(:,3);

lch = rgb2lch(rgb);
c = lch(:,2);
h = lch(:,3);

xyz = rgb2xyz(rgb);
x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

hsv = rgb2hsv(rgb ./ 255);
h0 = hsv(:,1);
s = hsv(:,2);
v = hsv(:,3);


figure(1);
plot(r, ec, '.');


