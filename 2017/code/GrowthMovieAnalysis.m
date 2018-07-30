% look at a picture of a cell
colony = imread('ecoli_phase_00.tif');
imshow(colony,[])

% look at the fluorescence image
colony = imread('ecoli_TRITC_00.tif');
imshow(colony,[])

% automatically find the names of the images in a folder
images = dir('ecoli_TRITC_*');

images

% access data stored in a structure
images(1).name

% look at the pixel values
imtool(colony,[])

% find a threshold to identify pixels belonging to cells
threshold = 209;

imshow(colony>threshold)

% estimate the colony size by adding up the pixels
colony_thresh = colony>threshold;
area = sum(sum(colony_thresh))

% write a loop to analyze all the images
% 1. read in the image
% 2. apply the  threshold
% 3. calculate the area and save in a vector called area

area = [];

for i = 1:length(images)
    colony = imread(images(i).name);
    colony_thresh = colony>threshold;
    area(i) = sum(sum(colony_thresh));
end

% pictures are 5 minuntes apart
time = 0:5:20*5;

% make a plot of time vs log area
plot(time,log(area),'x')

xlabel('time (min)')
ylabel('log(area)')

% fit for the doubling time
fitk = polyfit(time,log(area),1);

fitk

log(2)/fitk(1)
    









