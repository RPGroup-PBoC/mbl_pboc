%The following code is an example of a matlab functions. Unlike most other
%programming languages, matlab functions must exist in their own file free
%from all other code. The file will always start with the word function and
%is then followed by the name of the variable the function will return. In
%this case, it is 'imLabel' and 'areas'. The next name ('segmenter') is the actual
%name of the function we will call. Followed are the various arguments we
%can pass to it sandwiched inbetween parenthesis.
function [imLabel, areas] = segmenter(filename, radius)
%This function segments an image and returns the segmentation mask.
%
%Parameters:
%------------
% filename : string
%   Name of the image file to be segmented. 
% radius : float 
%   Radius to use during the gaussian blur smoothing. 

% read image
im = bfopen(filename);

% extract phase contrast image
imPhase = im{1, 1}{1, 1};

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

end
