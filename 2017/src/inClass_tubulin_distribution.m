%Get the length distribution of microtubules

Image=imread('80min_20uM_03.tif');
imshow(Image)

%Note that this image is 16 bits (0 - 65535), but the screen can only display in an 8
%bit range (0 - 255). We need to tell Matlab how to rescale the image
%intensities in order to display it on the screen. We start by assinging
%zero to the dimmest pixel, and 255 to the brightest one. This is done in
%imshow using "[]".
imshow(Image,[])

%The filaments still look to dim. This is because we have a few really
%bright pixels. Let's play with the range we want Matlab to adjust the
%intensities by.
imshow(Image,[0,6000])
%Even better, let's grab the pixel with minimum brightness and call it
%zero.
figure(1)
imshow(Image,[min(min(Image)),6000])

%We like this range for display purposes. We'll also use it for analysis.
%The point is that we don't care about the intensities of the filaments. As
%a result, I can normalize the brighness of the image using mat2gray.
ImNorm=mat2gray(Image,[double(min(min(Image))),6000]);
%Note that mat2gray needs double precision numbers as an input inside the
%[]. That's why we're using "double(min(min(Image)))".
figure(2)
imshow(ImNorm)
%ImNorm is an image with the same morphological information, but with a
%dimmest pixel value of zero and a brightest pixel value of 1.

%Let's try with a threshold of 0.9
Threshold=0.9;
ImThresh=ImNorm>Threshold;
imshow(ImThresh)
%Overlay the original and thresholded images
imshowpair(-ImNorm,ImThresh)

%We want to start by filtering segmented pixels by area. First, we label
%them.
ImLabel=bwlabel(ImThresh);
%Show them in color
imshow(label2rgb(ImLabel))
%Show them in grayscale
imshow(ImLabel,[])

%Calculate morphological properties of each labeled image. Go for
%the area, MajorAxisLength and MinorAxisLength
ImProps=regionprops(ImLabel,'Area','MajorAxisLength','MinorAxisLength');
%Let's say I want the area of the region 200
ImProps(200).Area
%We want to remove anything that is smaller than diffraction limited. We
%know (and we'll measure this) that a pixel is 100nm. So, anything with an
%area below 5x5 pixels is likely to be a diffraction limited spot.
AreaThreshold=30;

%Let's say I want to look at the region that is indexed as 100.
imshow(ImLabel==100)

%I want to go through each area and ask whether it is larger than
%AreaThreshold. If it is, I'll keep the informaiton about the Major and
%Minor axes length.
%Define a counter for the regions we keep in our filter
k=1;
for i=1:length(ImProps)
    %Ask whether the area is larger than the threshold. We need to use an
    %if-statement
    if ImProps(i).Area>AreaThreshold
        %Save the MajorAxisLength. Note that we're using k as our counter
        %of regions that passed our filter.
        MajorAxisFiltered(k)=ImProps(i).MajorAxisLength;
        %Go up one value in our counter k.
        k=k+1;
    end
end

%Plot a histogram of MajorAxisLength using 20 bins
hist(MajorAxisFiltered,20)
%To check whether it's exponentially distributed, change the y-axis to
%log-scale
set(gca,'YScale','log')

%If you want to do this using plot, you need to extract the bin position
%and number in each bin
[number,bins]=hist(MajorAxisFiltered,20);
semilogy(bins,number,'.','MarkerSize',20)
xlabel('length (pixels)')
ylabel('number of filaments')





























