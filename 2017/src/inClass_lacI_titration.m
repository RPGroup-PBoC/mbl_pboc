% Add to MATLAB's path the folder to read the ND2 files
addpath('bfmatlab/');

%%

% Define variable that points at the data directory
% dataDir = '../data/';
dataDir = 'data/lacI_titration/delta/';

% Read the image using the new package
im = bfopen([dataDir, '1.nd2']);

%%

% Extract the phase contrast image from the cell array
imPhase = im{1,1}{1,1};

% Display image
imshow(imPhase, [100, 5000])

%%
% Print features of the image into the screen
whos imPhase

%%
% Show the pixel histogram
imhist(imPhase, 2^14)

%%

% Let's re-scale the x-axis of our histogram

% define max and min values of the image
maxVal = max(imPhase(:));
minVal = min(imPhase(:));

%Plot the histogram
imhist(imPhase, 2^14);
xlim([minVal, 2500]);

%%
% Set threshold for bacteria
threshold = 1100;

% apply threshold
imThresh = imPhase < threshold; % generates the binary image with 0 for 
                                % pixels in thebackground and 1 for pixels
                                % in bacteria

% imshow(imThresh);
imshowpair(imPhase, imThresh)%, 'Method', 'montage')

%%
% Normalize the image to take values between 0 and 1
imNorm = mat2gray(imPhase);

imshow(imNorm)

%%
% Implement a Gaussian filter to correct for uneven illumination

% define the radius of the gaussian blur
radius = 50;

% Apply the Gaussian blur to the image
imBlur = imgaussfilt(imNorm, radius);

% Display the blur
imagesc(imBlur)

%%

% Substract the background
imBgSubstract = imNorm - imBlur;

% Show both images for comparison
fig = figure; % initialize a figure object
% Generate the first subplot with the normalized image
subplot(1, 2, 1);
imagesc(imNorm);
title('normalized image');

% Generate a subplot for the background corrected image
subplot(1, 2, 2);
imagesc(imBgSubstract);
title('background corrected');

%%

% Re-normalize the background substracted image
imBgNorm = mat2gray(imBgSubstract);

imagesc(imBgNorm)

%%

% Find the threshold
imhist(imBgNorm)
xlim([0, 0.2])

%%

% apply threshold again
threshold = 0.06;
imThresh = imBgNorm < threshold;
% imshow(imThresh)
imshowpair(imBgNorm, imThresh)

%%

% Label the binary image to obtain our segmentation mask
imLabel = bwlabel(imThresh);


% 
imshow(label2rgb(imLabel))

%%
% To know how many objects we have in the labeled image, we just need to
% look at the maximum value of the segmentation mask
max(imLabel(:))


%%

% Let's extrac Jamie's favorite object
jamie = 52;

imJamie = imLabel == jamie;

imshow(imJamie)

% To compute the area of Jamie's favorite object we need to sum all the
% pixels of the binary mask
sum(imJamie(:))

%%

% Extract the area of the labeled objects using region props
propArea = regionprops(imLabel, 'Area');

% Convert the structure object into a 1D array of areas
areas = [propArea.Area];


%%

hist(areas, 50)
%%


% Let's plot the fancy ECDF function of our area data
ecdf(areas)
xlabel('area pixels')

%%

% Convert pixels into µm^2 using the interpixel distance

% Define interpixel distance
interPix = 0.0733; % µm / pixel

areaMicrons = areas * interPix^2;

% Define our area bouundaries
areaMin = 1.8; % µm^2
areaMax = 4; % µm^2

% Apply the area filter using boolean operations
idx = find(areaMicrons > areaMin & areaMicrons < areaMax);


%%

% Generate a new binary mask keeping only the objects that passed our area
% filter criteria
imAreaFilt = ismember(imLabel, idx);

% re-label the binary image
imLabelFilt = bwlabel(imAreaFilt);

% Display the filtered segmentation mask
imshow(label2rgb(imLabelFilt))


%%

% Define entries to test the function
% filename = '../data/1.nd2';
filename = 'data/lacI_titration/delta/1.nd2';
gaussianBlur = 50; %pixels
areaBounds = [1.8, 4]; % µm^2
interPix = 0.0733 % µm / pixel

% test the function!
[imLabel, imYFP] = eColiSegmentation(filename, gaussianBlur, areaBounds,...
                                     interPix);

%%
% Display the outputs of the function
imshow(label2rgb(imLabel))
imagesc(imYFP)
%%

% Extract single-cell fluorescent values from the YFP image

fluor = []; % initialize array to save fluorescence

% loop through each of the labeled objects
for i=1:max(imLabel(:))
    % build image that contains only the ith cell of the segmentation mask
    imSingleCell = (imLabel == i) .* double(imYFP); % NOTE: We converted the
                                                   % image into a double
                                                   % in order to handle the
                                                   % multiplication.
    fluor(i) = sum(imSingleCell(:));                                               
end %for

histogram(fluor)
xlabel('fluorescence (a.u.)')
ylabel('count')


%%

% Process all the images in the delta directory
dataDir = 'data/lacI_titration/auto/';

% list images inside the directory
files = dir([dataDir, '*.nd2']);

% initialize array to save fluorescence
fluor = [];

gaussianBlur = 50; %pixels
areaBounds = [1.8, 4]; % µm^2
interPix = 0.0733 % µm / pixel

% loop through images
for im=1:length(files)
    filename = [dataDir, files(im).name];
    [imLabel, imYFP] = eColiSegmentation(filename, gaussianBlur,...
                                         areaBounds, interPix);      
                                     
    % loop through the labeled objects in our segmentation mask
    for i=1:max(imLabel(:))
        % build image that contains only the ith cell of the segmentation mask
        imSingleCell = (imLabel == i) .* double(imYFP); % NOTE: We converted the
                                                   % image into a double
                                                   % in order to handle the
                                                   % multiplication.
        fluor(end+1) = sum(imSingleCell(:));     
    end %for2
end %for1

%%
ecdf(fluor)

xlabel('fluorescence (a.u.)')
ylabel('count')

%%

% Run all of the analysis in a single badass loop

gaussianBlur = 50; %pixels
areaBounds = [1.8, 4]; % µm^2
eccentricity = [0.8, 1]
interPix = 0.0733 % µm / pixel

% define directory containing all of the strains
dataDir = 'data/lacI_titration/';

% List all of the directories
directories = dir(dataDir);

% List all of the strain names
strains = {'auto', 'delta', 'R22', 'R60', 'R124', 'R260', 'R1220',...
           'R1740'};
       
% initialize a cell array to save all of the single cell measurements
cellFluor = {};

% loop through the directories, processing all of the images and saving the
% single cell fluorescent measurements
parfor d=1:length(strains)
    % list the files inside the dth directory
    files = dir([dataDir, strains{d}, '/*nd2']);
    
    % initialize array to save this strain fluorescence measturements
    fluor = [];
    
    % loop through images
    for im=1:length(files)
        filename = [dataDir, strains{d}, '/', files(im).name];
        [imLabel, imYFP] = LogSegmentation(filename, gaussianBlur,...
                                             areaBounds, eccentricity,...
                                             interPix);

        % loop through the labeled objects in our segmentation mask
        for i=1:max(imLabel(:))
            % build image that contains only the ith cell of the
            % segmentation mask
            imSingleCell = (imLabel == i) .* double(imYFP);
            fluor(end+1) = sum(imSingleCell(:));     
        end %for2        
    end %for1
    
    % save the sincle cell fluorescence array into our cell array
    cellFluor{d} = fluor;
end %parfor

%%

figure()
hold on
for i=1:length(cellFluor)
    ecdf(cellFluor{i});
    set(gca, 'xscale', 'log')
end %for
legend(strains)
hold off

%%
% Compute the mean fluorescence for each of the strains

% initialize array to save mean fluorescence
meanFluor = [];

% loop through each of the strains
for i=1:length(strains)
    meanFluor(i) = mean(cellFluor{i});
end %for


%%

% Compute fold change for each of the strains

% Initialize array to save fold-change
foldChange = zeros([1, length(meanFluor)]);

for i=1:length(strains)
    foldChange(i) = (meanFluor(i) - meanFluor(1)) /...
                    (meanFluor(2) - meanFluor(1))
end %for

% Define an array of repressors
repressors = [22, 60, 124, 260, 1220, 1740];

% Plot on a log-log scale the number of repressors vs fold-change
loglog(repressors, foldChange(3:end), 'o')
xlabel('repressors / cell')
ylabel('fold-change')


%%

% Compute the theoretical fold-change with Garcia et al 2011 parameters
Nns = 4.6E6; % bp in E. coli's genome
DeltaEpsilon = -13.9 % kBT
repArray = logspace(1, 4, 200);

foldChangeTheory = 1 ./ (1 + repArray ./ Nns .* exp(-DeltaEpsilon));

% Plot theory vs data


% Plot on a log-log scale the number of repressors vs fold-change
figure()
hold on
loglog(repArray, foldChangeTheory, '-')
loglog(repressors, foldChange(3:end), 'o')
xlabel('repressors / cell')
ylabel('fold-change')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')

hold off