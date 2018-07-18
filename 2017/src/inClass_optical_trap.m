% Define the directory containing the data
dataDir = 'data/optical_trap/';

% List images
images = dir([dataDir, '*.tif']);

%%

% Show one image as example
imshow([dataDir, images(1).name]);

%%

% Let's show the movie of the bead trapped with the tweezers

% initialize a figure
figure()
hold on

% loop through the images
for i=1:length(images)
    imshow([dataDir, images(i).name])
    pause(0.001)
end %for


hold off

%%

% Load the image into memory
imExample = imread([dataDir, images(1).name]);

% normalize the image
imNorm = mat2gray(imExample);

% Show the pixel intensity histogram
imhist(imNorm);

%%
imtool(imNorm)

%%
% Define threshold we chose using imtool
threshold = 0.3;

% Apply the threshold to the sample image
imThresh = imNorm > threshold;

imshowpair(imNorm, imThresh)


%%

% initialize a figure
figure()
hold on

% loop through the images
for i=1:length(images)
    im = imread([dataDir, images(i).name]);
    imNorm = mat2gray(im);
    imThresh = imNorm > threshold;
    imshowpair(imNorm, imThresh)
    pause(0.001)
end %for

hold off



%%

% Loop through the images using region props to find the centroid and the
% area of the labeled objects

for i=1:length(images)
    % load the image
    im = imread([dataDir, images(i).name]);
    
    % Normalize the image
    imNorm = mat2gray(im);
    
    % Apply the threshold
    imThresh = imNorm > threshold;
    
    % Label the binary image
    imLabel = bwlabel(imThresh);
    
    % Use regionprops to find centroid and area
    props = regionprops(imLabel, 'Area', 'Centroid');
    
    % Find the object with the largest area
    [value, idx] = max([props.Area]);
    
    % save the centroid positions
    position(i, :) = props(idx).Centroid;
    
end %for

%%

% initialize figure
figure()
% Loop through images
for i=1:length(images)
    plot(position(1:i, 1), position(1:i, 2), 'b-')
    hold on
    plot(position(i, 1), position(i, 2), 'bo')
    pause(0.05)
    hold off
end %for

%%

% MSD = <x^2> = <(position(i) - <position>)>

% Compute the mean position along the x and y axis.
meanPos = mean(position);

% Compute the mean square displacement
msdX = mean( (position(:, 1) - meanPos(1)).^2 );
msdY = mean( (position(:, 2) - meanPos(2)).^2 );

% Define interpix distance
interPix = 50 / 1200; % µm / pixel

% Define kBT as pN µm
kBT = 4E-3; % pN µm

% Compute the spring constant in both directions
kX = kBT / (msdX * interPix.^2);
kY = kBT / (msdY * interPix.^2);







