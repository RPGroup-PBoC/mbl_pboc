% Load the images.
images = dir('./data/*.tif');

% Try segmenting one of the images. 
im = imread(['./data/'  images(1).name]);

% Apply a median filter to reduce the noise in the image. 
imFilt = medfilt2(im);
imNorm = mat2gray(imFilt);

% Look at the image histogram. 
imhist(imNorm, 1000);

% Try a threshold
thresh = graythresh(imNorm)
imThresh = imNorm > thresh;


% Clear the border and label. 
imClear = imclearborder(imThresh);
imLab = bwlabel(imClear);
imshow(imLab)

% Apply an area threshold. 
props = regionprops(imLab, 'Area', 'Eccentricity');
approvedObj = zeros(size(im));
for i=1:length(props)
    areas(i) = props(i).Area;
    ecc(i) = props(i).Eccentricity;
    if props(i).Eccentricity > 0.5 && props(i).Area > 100 && props(i).Area < 1000
        approvedObj = approvedObj + (imLab==i);
    end
end


imLab = bwlabel(approvedObj);
% Make a histogram of filament areas. 

skel = bwmorph(approvedObj, 'skel', Inf);
spur = bwmorph(skel, 'spur');
imLab = bwlabel(spur);

imshow(imLab)

props = regionprops(imLab, 'Area');
for i=1:length(props)
    sizes(i) = sum(sum(imLab==i));
end

hist(sizes, 200);

%% Process all of the images. 
sizes = [];
for i=1:length(images)
    % Read the images
    im = imread(['./data/' images(i).name]);
    imFilt = medfilt2(im);
    imNorm = mat2gray(imFilt);
    thresh = graythresh(imNorm);
    imThresh = imNorm > thresh;
    imClear = imclearborder(imThresh);
    
    % Label and apply filters.
    imLab = bwlabel(imClear);
    props = regionprops(imLab, 'Area', 'Eccentricity');
    for j=1:length(props)

        if props(j).Area > 50 & props(j).Area < 1000 & props(j).Eccentricity > 0.5
            skel = bwmorph(imLab==j, 'skel', Inf);
%             spur = bwmorph(skel, 'spur', Inf);
            size = sum(sum(skel));
            sizes = [sizes size];
            
        end
    end
end
