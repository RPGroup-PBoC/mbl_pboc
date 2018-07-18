function [imLabel, imYFP] = LogSegmentation(filename, radius,...
                                            A, E, interPix)
%This function segments an image and returns the segmentation mask.
%
%Parameters:
%------------
% filename : string
%   Name of the image file to be segmented. 
% radius : float 
%   Radius to use during the gaussian blur smoothing. 
% A : array 2x1.
%   Upper and lower area bounds to filter the segmentation mask
% interPixelDist : float.
%   Physical distance between pixels in the camera
% read image
im = bfopen(filename);

% extract phase contrast image
imPhase = im{1, 1}{1, 1};
% extract phase contrast image
imCherry = im{1, 1}{2, 1};
% extract YFP image
imYFP = im{1,1}{3, 1};

%Instantiate the edgefinder function.
imEdge = edge(imCherry, 'log');

%Fill the holes in the edge image.
imFill = imfill(imEdge, 'holes');

%Remove the small stuff.
imFilt = bwareaopen(imFill, 100, 4);

%Dilate the objects by 2px.
selem = strel('diamond', 1);
imDil = imdilate(imFilt, selem);

%Remove objects touching the border and label the output image.
imSeg = imclearborder(imDil, 4); %Buffer of 4px.
imSeg = bwlabel(imSeg);

%Extract the region props of the mask.
props = regionprops(imSeg, 'Area', 'Eccentricity');

%Iterate through each object and apply an area and eccentricity filter.
areas = [props.Area];
areas = areas * interPix^2;

eccs = [props.Eccentricity];

approvedAreas = (areas > min(A)) & (areas < max(A));
approvedEccs = (eccs > min(E)) & (eccs < max(E));

%Find the approved labels
approvedLabels = find((approvedAreas .* approvedEccs) > 0);

%Generate the final mask.
segMask = zeros(size(imSeg));
for i=1:length(approvedLabels)
	segMask = segMask + (imSeg==approvedLabels(i));
end

%Relabel the image.
imLabel = bwlabel(segMask > 0);

end