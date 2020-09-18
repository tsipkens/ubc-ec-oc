
clear;
close all
clc;

files = dir(fullfile('imgs\sample','*.jpg'));

rgb = detect(files(1:5)); % get RGB of central filters using image recog.

[ec,oc] = ecoc.qu(rgb); % compute EC/OC using qu function

ec_oc = ec./oc;

