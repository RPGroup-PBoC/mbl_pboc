function [imLabel, areas] = segmenter(filename)
%This function segments an image and returns the segmentation mask.
%
%Parameters:
%------------
% filename : string
%   Name of the image file to be segmented. 

%Load the image. 
imPhase = imread(filename);
    
%Normalize it!
imNorm = mat2gray(imPhase);

% Use Otsu's method to get an automatic threshold
threshold = graythresh(imNorm);

%Apply a threshold. 
imThresh = im2bw(imNorm, threshold);
 
%Remove cells touching border. 
imThresh = imclearborder(imThresh);

%Label our image.
imLabel = bwlabel(imThresh);
    
%Extract the region properties of our image. 
props = regionprops(imLabel, 'Area');
areas = [props.Area];

end