% Select an image for distortion analysis or for correction

function [filename, fullname]=imselect
% input endoscope image file,distorted
disp('Please select the image.');
% pathname=fullfile('../images/','*.JPG;*.jpg;*.tif;*.png');
pathname=fullfile('images/','*.JPG;*.jpg;*.tif;*.png');
[filename,pathname] = uigetfile(pathname,'Select the image file'); % can creat a new file
fullname=fullfile(pathname, filename);
clear pathname;
display('Image being processed:');
disp(fullname);
end
