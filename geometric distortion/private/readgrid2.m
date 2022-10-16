% This function gets cross points on a distorted grid-target image
% [r_l,r_r,r_t,r_b,r_d,center_offset] = readgrid(im_d)
% r_l: data from center to left boundary
% r_r: data from center to right boundary
% r_t: data from center to top boundary
% r_b: data from center to bottom boundary
% r_d: averaged data of r_l, r_r, r_t and r_b
% center_offset: offset of the imaged target center from the image center

function [r_l,r_r,r_t,r_b,r_d,center_offset] = readgrid2(im_d)

imshow(im_d);
title('Select points from center to \color{red}LEFT \color{black}edge with mouse, press Enter to end.');
[x_l,y_l]=ginput;
title('Select points from center to \color{red}RIGHT \color{black}edge with mouse, press Enter to end.');
[x_r,y_r]=ginput;
title('Select points from center to \color{red}TOP \color{black}edge with mouse, press Enter to end.');
[x_t,y_t]=ginput;
title('Select points from center to \color{red}BOTTOM \color{black}edge with mouse, press Enter to end.');
[x_b,y_b]=ginput;

% center of the distorted images
size_d = size(im_d);
centerx_d = size_d(2)/2;
centery_d = size_d(1)/2;
r_max_d=max(centerx_d,centery_d);
% position of the target center on the distorted image
x_center=(x_l(1)+x_r(1)+x_t(1)+x_b(1))/4;
y_center=(y_l(1)+y_r(1)+y_t(1)+y_b(1))/4;

x_offset=x_center-centerx_d;
y_offset=y_center-centery_d;
center_offset=[x_offset y_offset;x_offset/r_max_d y_offset/r_max_d];

r_l=((x_l-x_center).^2+(y_l-y_center).^2).^0.5;
r_r=((x_r-x_center).^2+(y_r-y_center).^2).^0.5;
r_t=((x_t-x_center).^2+(y_t-y_center).^2).^0.5;
r_b=((x_b-x_center).^2+(y_b-y_center).^2).^0.5;
size_l=size(r_l,1);
size_r=size(r_r,1);
size_t=size(r_t,1);
size_b=size(r_b,1);

% combine the matrix from four directions:
% r_h: averaged data of r_l and r_r
% r_v: averaged data of r_t and r_b
if size_l>size_r
    r_h=0.5*(r_l(1:size_r)+r_r);
    r_h=[r_h;r_l(size_r+1:size_l)];
else
    r_h=0.5*(r_r(1:size_l)+ r_l);
    r_h=[r_h;r_r(size_l+1:size_r)];
end

if size_t>size_b
    r_v=0.5*(r_t(1:size_b)+r_b);
    r_v=[r_v;r_t(size_b+1:size_t)];
else
    r_v=0.5*(r_b(1:size_t)+ r_t);
    r_v=[r_v;r_b(size_t+1:size_b)];
end

size_h=size(r_h,1);
size_v=size(r_v,1);
% r_d: averaged data of r_h and r_v
if size_h>size_v
    r_d=0.5*(r_h(1:size_v)+r_v);
    r_d=[r_d;r_h(size_v+1:size_h)];
else
    r_d=0.5*(r_v(1:size_h)+r_h);
    r_d=[r_d;r_v(size_h+1:size_v)];
end

end

