
clear;
close all
clc;

files = dir(fullfile('imgs\sample','*.jpg'));

rgb = detect(files); % get RGB of central filters using image recog.

[ec,oc] = ecoc.qu(rbg); % compute EC/OC using qu function

ec_oc = ec./oc;

