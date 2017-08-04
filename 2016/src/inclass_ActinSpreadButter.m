%Load the actin image
Image=imread('H15_01.tif');
%Display the image
imshow(Image,[])
%Note that if we use [] the maximum of the image is normalized to a few
%bright pixels. This results in an image where the constrast is very low.
%We examine the image and find that those bright pixels have a value of
%~1000 whereas the pixels corresponding to filaments have a value of ~300.

%We're going to normalize the image, not by the maximum and minimim as
%when we display using [], but in the range of 0 to 500. We need to do this
%because we have very bright individual pixels that reduce the overall
%contrast of the image.
imshow(Image,[0,500])
%If we want to create a normalized image, we use mat2gray
ImNorm=mat2gray(Image,[0,500]);
%Display the normalized image
imshow(ImNorm)

%Let's first segment the image. We're going to try thresholding.
%First, find the threshold
%imtool(ImNorm)           %I comment this out so that we don't open a new
                            %imtool window every time we run the script
Threshold=0.4;

%Take the threshold and display
ImThresh=ImNorm>Threshold;
imshow(ImThresh)

%Overlay the segmented and original images
imshowpair(-ImNorm,ImThresh)

%We want to measure different morphological features of each region. First,
%I need to identify the different regions using bwlabel
ImLabel=bwlabel(ImThresh);
imshow(ImLabel,[])
%We calculate morphological properties using regionprops
RegionProperties=regionprops(ImLabel,'Area','MajorAxisLength',...
    'MinorAxisLength');
%RegionProperties is a structured array. If I want the are of region 200:
RegionProperties(200).Area
%Next, we want to plot a histogram of areas. We need to convert the
%information about Area from the structured array RegionProperties into a
%list of numbers.
Areas=[RegionProperties.Area];
%Plot an area histogram using 400 bins
hist(Areas,400)
%We see that there are a lot of regions with 5 or less pixels in area.
AreaThresh=50;

%Scheme: Go through each region and ask whether that region has an area
%larger than AreaThresh. If yes, then copy that region to a new blank
%image.
%How do we select an individual region? Let's look at region 200 using the
%logic operation "=="
imshow(ImLabel==200)

%We want to look at each region and ask whether its area is larger than a
%certain threshold. If so, we'll copy this region onto a new image.

%Define a blank image where we can dump things into
ImNew=zeros(size(ImLabel));

%Create a for-loop where we check each region
figure(2)
for i=1:length(Areas)  %Go through each region found in ImLabel
    if Areas(i)>AreaThresh      %Is the area of the i-th region larger than AreaThresh?
        %If the answer is yes (1), then execute this part
        FilteredRegion=(ImLabel==i);        %Create a image where we only see
                                            %the i-th region
        ImNew=ImNew+FilteredRegion;
        %imshow(ImNew)
        %drawnow        
    end
end
    
%Now we have our first set of filtered regions
imshow(ImNew)
%We have a new thresholded image that only includes the regions that were
%filtered by area. If I want to calculate, for example, the
%MinorAxisLength, I need to label them again.
ImLabel2=bwlabel(ImNew);
RegionProperties2=regionprops(ImLabel2,'MinorAxisLength');
%Create a vector that lists all MinorAxisLength values
MinorLengths=[RegionProperties2.MinorAxisLength];
%Check this out on a histogram
hist(MinorLengths,200)
%From here, let's decide on a threshold for the minor axis
MinorThresh=9;
%Now take the filter as we did before
figure(3)
ImNew2=zeros(size(ImLabel2));       %Blank image we'll add the filaments to
for i=1:length(MinorLengths)    %Go through each region in the new labeled image
                                %ImLabel2
	if MinorLengths(i)<MinorThresh
        FilteredRegion=(ImLabel2==i);  %Only keep the i-th region
        ImNew2=ImNew2+FilteredRegion;   %Add the i-th region to ImNew2
        %imshow(ImNew2)
        %drawnow
    end
end

%Now, we're ready to get the filament length distribution
%For the third time, label the image
ImLabel3=bwlabel(ImNew2);
%Calculate the maximum axis length of each region
RegionProperties3=regionprops(ImLabel3,'MajorAxisLength');
%Put the results in a vector
MajorLengths=[RegionProperties3.MajorAxisLength];
%Display them
hist(MajorLengths,30)
xlabel('Filament length (pixels)')
ylabel('Number of filaments')
%To turn this into a probability I need the total number of filaments as
%well as the number of filaments within each bin. The function hist can
%give you this information
[Counts,Bins]=hist(MajorLengths,30);
bar(Bins,Counts)
%To turn the Counts into a probability I divide by the total number of
%filaments I have
bar(Bins,Counts/length(MajorLengths))
xlabel('Filament length (pixels)')
ylabel('Probability')


%Is this a geometric distribution as predicted by our model? To check that,
%we plot the probability on a log-axis and determine by eye whether the
%functional form looks like a line
figure(4)
semilogy(Bins,Counts/length(MajorLengths),'.k',...
    'MarkerSize',20)
xlabel('Filament length (pixels)')
ylabel('Probability')


%Note that the distribution we got decays linearly.















































