%We want to automate our GeneExpression script so that we can analyze
%multiple images corresponding to the same bacterial strain.

%First, get the information about the files in the folder we want to
%analyze
%List all YFP files in the folder
DYFP=dir('lacI_full_set\Delta\YFP*.tif');
%List all mCherry files in the folder
DmCherry=dir('lacI_full_set\Delta\mCherry*.tif');

%Initialize the vector where we will save the YFP fluorescence per cell
YFPPerCell=[];      %This creates an empty vector

%Let's start by imagining a for-loop that only goes through one index: j=1
for j=1:length(DYFP)
    %Load the images. Note that the images are not on the working folder. In
    %order to lead them, we need to give imread information the folder
    %containing the images as well as the name of the images. This means we
    %need to concatenate the string (text) for the folder with the name of the
    %j-th image we are going to load. Strings are concatenated using a comma
    %and by placing everything between square brackets.
    mCherry=imread(['lacI_full_set\Delta\',DmCherry(j).name]);
    YFP=imread(['lacI_full_set\Delta\',DYFP(j).name]);
    %Find a threshold for the mCherry image
    %imtool(mCherry,[])  %I comment this out so that I don't keep loading
                         %imtool every time I run the script
    Threshold=400;
    %Take the threshold
    ImThresh=mCherry>Threshold;
    imshow(ImThresh)

    %Note that there are big clumps of cells. We want to get rid of them. We'll
    %use the area of each region as a measure of whether a region is a single
    %cell or multiple ones.
    %Label the image
    ImLabel=bwlabel(ImThresh);
    imshow(ImLabel,[])
    %Find the area of the different regions found
    AreaProps=regionprops(ImLabel,'Area');
    Areas=[AreaProps.Area];      %Remember this is the syntax to extract the area 
                                 %of all found regions from the results coming
                                 %out of regionprops
    %Plot an area histogram
    hist(Areas,50)
    %Let's take an area threshold of
    MaxAreaThresh=400;
    MinAreaThresh=50;    
    %Now keep only regions with an area below this threshold
    NewImThresh=zeros(size(ImLabel));       %Create a blank image to add cells to
    for i=1:length(Areas)
        if Areas(i)<MaxAreaThresh
            if Areas(i)>MinAreaThresh
                NewImThresh=NewImThresh+(ImLabel==i);
            end
        end
    end
    %Compare the old and new thresholded imaged
    imshowpair(ImThresh,NewImThresh)
    %Now label the new thresholded image
    NewImLabel=bwlabel(NewImThresh);
    %Get the fluorescence of each cell
    for i=1:max(max(NewImLabel))
       %Get a mask for this cell and multiply it by the YFP image
       YFPFiltered=immultiply(YFP,NewImLabel==i);
       %Get the area of this cell
       CellArea=sum(sum(NewImLabel==i));
       %Add all the pixel values within the multiplied image to get the
       %fluorescence per cell. Then divide by the area to obtain the
       %fluorescence per pixel per cell.
       %Concatenate the information about this cell within the YFPPerCell
       %vector. We do this so that the fluorescence information does not get
       %overwritten with each iteration of the for-loop that goes over the
       %multiple images in the folder.
       YFPPerCell=[YFPPerCell,sum(sum(YFPFiltered))/CellArea];   
    end
end

%Plot the distribution of fluorescence values
hist(YFPPerCell)
xlabel('Fluorescence per cell')
ylabel('Number of cells')
%Get the mean of the distribution
mean(YFPPerCell)
















