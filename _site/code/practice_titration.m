% Testing the image analysis. 

% Load the data. 
deltaPhaseFiles = dir('O2_delta_phase*.tif');
deltaYFPFiles = dir('O2_delta_yfp*.tif');

% Look at the first phase image. 
phaseIm = imread(deltaPhaseFiles(5).name);

imshow(phaseIm, [])

% Before, we used imtool. Now let's just look at the image histogram. 
minPhase = min(min(phaseIm));
maxPhase = max(max(phaseIm));
imhist(phaseIm, 4000);
xlim([minPhase,maxPhase]);

% Looking at the histogram, we can choose a threshold value. 
threshVal = 2000;
imThresh = phaseIm < threshVal;
% imshow(imThresh, [])


% It looks like we have some uneven illumination. We can deal with this
% through background subtraction. 
imNorm = mat2gray(phaseIm);
imhist(imNorm)
imshow(imNorm < 0.3);


seg = segmenter(deltaPhaseFiles(1).name, 0.3);
imshow(seg)

%%
% Now we can filter by area. 
label = bwlabel(seg);

% Get the region properties
properties = regionprops(label, 'Area');
areas = [properties.Area];

hist(areas, 10)
xlabel('bacterial area (sq pixel)');
ylabel('count');

% convert this to physical uints. 
ipDist = 0.160 ; % in units of microns per pixel. 
areas = areas .* ipDist^2;

hist(areas, 10)
xlabel('bacterial area (sq micron)')
ylabel('counts')


% Show only one index at a time. 
imCells = zeros(size(label));
for i=1:length(areas)
    if (areas(i) > 1) && (areas(i) < 4);
        imCells = imCells + (label==i);
    end
end

% Relabel the image. 
cellLabel = bwlabel(imCells);
imshow(label2rgb(cellLabel))
    
% Now get the intensities
max(max(cellLabel))

