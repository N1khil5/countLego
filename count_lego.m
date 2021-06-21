function [numA,numB]=count_lego(I)
% The region props function here is used to calculate and count how many
% red 2x2 Legos and how many blue 2x4 Legos appear in a given image.
% This function starts by reading the image.
% The red objects are isolated from the image I provided, and the red
% colour is isolated from the image, from there the red is binarised and  
% bwareaopen is used to clean up the image and remove small object from the
% binarised image. The function then uses region props to get parameters
% and bounding boxes around the areas which match the color sequence and a
% for loop is utilised to find the area, length of the bounding box, width
% of the bounding box and the circularity. Then by looking at the
% information of the bounding boxes, an if condition is used to check if
% the boxes match certain parameters that give true values and if the box
% meets the criteria, the counter is incremented by one. This same process
% is repeated for the blue object as well. The red object stores its
% counter in the blockRed variable and the blue object stores its counter
% in the blockBlue variable. After the last for loop and if statements are
% executed, numA (output for the blue block) is set to the value of
% blockBlue and numB is set to the value of blockRed. Most resources were
% used from the official matlab website. The rest are referenced here.
% References:
% https://www.youtube.com/watch?v=Dkm6XirJ-jw&t=404s&ab_channel=Theboredkid
% was used for object detection by color and isolating the different color
% channels.
% https://www.youtube.com/watch?v=Gq7mp3G94ao&ab_channel=AnselmGriffin was
% used for regionprops and identifying parameters from regionprops.
Igray = im2gray(I);

% Initialise values for the red and blue block counters that will be 
% incremented if it matches our if conditions.
blockRed = 0;
blockBlue = 0;

% Isolating the red color channels
red = I(:,:,1)-I(:,:,2);
red = imsubtract(red,Igray);
red = im2bw(red, 0.23);
red = bwareaopen(red,1300);
red = imfill(red,'holes');

% Using region props 
redRegion = regionprops(red,'Area','BoundingBox','Perimeter','Circularity');

% Finding parameter values of circularity, height, width, and area. 
for i = 1:numel(redRegion)
Rarea = redRegion(i).Area;
Rcircularity = redRegion(i).Circularity;
boundingBoxRW=redRegion(i).BoundingBox(3);
boundingBoxRL=redRegion(i).BoundingBox(4);
boundingRatioR=(boundingBoxRL/boundingBoxRW);
% If conditions to check if the parameters meet our criteria to add them 
% to our counter of red blocks.
if((Rcircularity>0.23)&&(Rcircularity<0.45)&&(boundingRatioR>0.75))
    blockRed = blockRed + 1;
end
if((Rcircularity<0.2)&&(boundingRatioR>0.9)&&(Rarea<10000))
    blockRed = blockRed + 1;
end
end

% Isolating the blue color channels
blue = I(:,:,3)-I(:,:,1);
blue = imsubtract(blue,Igray);
blue = im2bw(blue, 0.10);
blue = bwareaopen(blue,1300);
blue = imfill(blue,'holes');

% Using region props.
blueRegion = regionprops(blue,'Area','BoundingBox','Perimeter','Circularity');

% For loop to find the parameter values for area, circularity, width and
% height.
for i = 1:numel(blueRegion)
Barea = blueRegion(i).Area;
Bcircularity = blueRegion(i).Circularity;
boundingBoxBW=blueRegion(i).BoundingBox(3);
boundingBoxBL=blueRegion(i).BoundingBox(4);
boundingRatioB=(boundingBoxBL/boundingBoxBW);

% If condition to check if the paramters meet our criteria and if it does,
% it adds 1 to the blockBlue counter. 
if ((boundingRatioB < 1.9)&&(boundingRatioB>0.5)&&(Bcircularity<0.45)&&(Bcircularity>0.10)&&(Barea>7000))
    blockBlue = blockBlue + 1;
end
end
% numA is set to the blue block counter and numB is set to the red block
% counter. 
numA = blockBlue;
numB = blockRed;
end