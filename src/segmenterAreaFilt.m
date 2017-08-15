function [imLabel, areas, imYFP] = segmenterAreaFilt(filename, radius,...
                                              areaBounds, interPixelDist)
%This function segments an image and returns the segmentation mask.
%
%Parameters:
%------------
% filename : string
%   Name of the image file to be segmented. 
% radius : float 
%   Radius to use during the gaussian blur smoothing. 
% areaBounds : array 2x1.
%   Upper and lower area bounds to filter the segmentation mask
% interPixelDist : float.
%   Physical distance between pixels in the camera

% read image
im = bfopen(filename);

% extract phase contrast image
imPhase = im{1, 1}{1, 1};
% extract YFP image
imYFP = im{1,1}{3, 1};

%Normalize it!
imNorm = mat2gray(imPhase);
    
%BPerform a Gaussian blur
imBlur = imgaussfilt(imNorm, radius);
% Extract the background
imSub = imNorm - imBlur;
% Renormalization using the complement of an image
imSub = mat2gray(imSub);

% Use Otsu's method to get an automatic threshold
threshold = graythresh(imSub);

%Apply a threshold. 
imThresh = imSub < threshold;
% imThresh = im2bw(imSub, threshold);
 
%Remove cells touching border. 
imThresh = imclearborder(imThresh);
%Label our image.
imLabel = bwlabel(imThresh);
    
%Extract the region properties of our image. 
props = regionprops(imLabel, 'Area');
areas = [props.Area];

% covnvert area array to µm
areasMicron = areas * interPixelDist^2; 
% Apply filter to area array
[row, index] = find(areasMicron > min(areaBounds) &...
                    areasMicron < max(areaBounds));

% Find which labeled objects fell within the area bounds
imAreaFilt = ismember(imLabel, index);
% re-label the binary image
imLabel = bwlabel(imAreaFilt);

end
