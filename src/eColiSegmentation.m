function [imLabel, imYFP] = eColiSegmentation(filename, ...
                                    gaussianBlur, areaBounds, interPix)
% This function segments E. coli from a phase contrast image, applies an
% area filter and returns the segmentation mask along with the YFP image
% and the areas vector.
% Parameters
% ----------
% filename : string.
%       String pointing at the file that will be processed
% gaussianBlur : int.
%       Size of the Gaussian blur that will be used for the backgroun
%       substraction
% areaBounds : array 2x1
%       Area bounds used for filtering non-bacterial objects
% interPix : float.
%       Distance between pixels in µm^2 / pixel.

% Read the image
im = bfopen(filename);

% Extract the phase contrast image
imPhase = im{1, 1}{1, 1};

% Extract the YFP image
imYFP = im{1, 1}{3, 1};

% Normalize the Phase contrast image
imNorm = mat2gray(imPhase);

% Apply Gaussian Blur
imBlur = imgaussfilt(imNorm, gaussianBlur);

% Substract the background
imBgSub = imNorm - imBlur;

% Re-normalize the image
imNormBg = mat2gray(imBgSub);

% Use Otsu's method to get an automatic threshold
% threshold = graythresh(imNormBg .* (imNormBg < median(imNormBg(:))));
threshold = graythresh(imNormBg)% .* (imNormBg < median(imNormBg(:))));

% Apply the threshold
imThresh = imNormBg < threshold;

% Label the binary image
imLabel = bwlabel(imThresh);

% Obtain the area of the labeled objects
propsArea = regionprops(imLabel, 'Area');
% extract the areas
areas = [propsArea.Area];

% Convert to µm^2
areasMicron = areas * interPix^2;

% Apply the area threshold
idx = find(areasMicron > min(areaBounds) & areasMicron < max(areaBounds));

% Find objects that passed the area filter on our labeled image
imAreaFilt = ismember(imLabel, idx);

% re-label the image
imLabel = bwlabel(imAreaFilt);

end %function