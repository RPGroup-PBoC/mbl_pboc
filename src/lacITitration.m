% Change the working director to where the images are in case we are not there
cd('~/Documents/PhD/RPGroup-PBoC_github/mbl_pboc_2016/src/')

% Read the phase contrast image
imPhase = imread('data/ecoli_images/noLac_phase_0008.tif');

% Print some features of our image
whos imPhase

imshow(imPhase, []);
