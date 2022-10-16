% This fuction calcualte normalized local magnificatoin versus normalized 
% distance from image center to longest image edges based on the paper of:
% ========================================================================%
% Q. Wang, W.-C. Cheng, N. Suresh, and H. Hua, "Development of the local
% magnification method for quantitative evaluation of endoscope geometric 
% distortion," Journal of biomedical optics 21, 056003 (2016). doi: 
% https://doi.org/10.1117/1.JBO.21.5.056003
% ========================================================================%
% Copyright © 2018 Quanzeng Wang 

clear;clc;close all;

% input parameters:
size_grid=1; % Target grid size, mm/grid
size_pp=2.03; % pixel pitch, microns/pixel(Colposcope 2.03, Endoscope 2.8)
ratio_si=1; %ratio of the sensor pixel number to the image pixel number, >=1.
r2_min=0.999; %The r-squared value of the final fitting function is larger than r2_min. 

% output parameters:
% size_d: size of anylyzed image
% center_offset: offset of target center on the image to image center
% r_d: normalized distorted radius
% r_u: normalized undistorted radius
% p_dfu: coefficients for a polynomial that is a best fit for r_d versus r_u

%% polyfit_distortion evaluation
[filename, fullname]=imselect;
im_d = imread(fullname); % distorted image
size_d = size(im_d);

% get the look up table of the cross radius from the distorted grid target
[r_l,r_r,r_t,r_b,r_d,center_offset] = readgrid2(im_d);
warning('center x_offset=%.1f pixels, center y_offset=%.1f pixels',center_offset(1),center_offset(2));

centerx_d = size_d(2)/2;  %image center, x
centery_d = size_d(1)/2;  %image center, y
r_d_size=length(r_d);
r_u=(0:r_d_size-1)';   % 0, 1, 2,...,

% Find edge data
r_max_d=max(centerx_d,centery_d);
[p_max,Ngrid,r2_degree]=max_gp(r_d,r_u,r_max_d,r2_min);
if Ngrid>max(r_u)
    r_u=[r_u;Ngrid];
    r_d=[r_d;r_max_d];
end

%Normalize the data.
r_l=r_l/r_max_d;
r_r=r_r/r_max_d;
r_t=r_t/r_max_d;
r_b=r_b/r_max_d;
r_d=r_d/r_max_d;
r_u=r_u/Ngrid;

% load temp; % for debug

plot(r_u(1:length(r_l)),r_l,'-.r'); % center to left
hold on
plot(r_u(1:length(r_r)),r_r,'-r'); % center to right
plot(r_u(1:length(r_t)),r_t,'-.g'); % center to top
plot(r_u(1:length(r_b)),r_b,'-g'); % center to bottom
plot(r_u,r_d,'-k');
plot([0 1],[0 1],'--k');
hold off
lh=legend('Left','Right','Top','Bottom','Average','Location','SouthEast');
set(lh,'Box','off');
axis([0 1 0 1]);
xlabel('Normalized r_u');
ylabel('Normalized r_d');

% Find coefficients for polynomial:
degr=5; % 5: 5th order polyfit directly; any other value: try different degrees of polynomial
[p_dfu,r2_dfu]=ru_rd_fit3(r_u, r_d,r2_min,degr);
% p_dfu:  polynomial coefficients, p(x)=p(1)*x^n+p(2)*x^(n-1)+...+p(n)*x+p(n+1)
% r2_dfu: the r-squared value and degree of the final fitting function
p_dfu=p_dfu'; % easy to copy to Excel
order_fit=r2_dfu(2);

%%
length_sensor=r_max_d*ratio_si*size_pp/1000; %maximum distance from center to an edge, pixels*(microns/pixel)=mm  
length_target=Ngrid*size_grid; % grids * mm/grid = mm. 
R_u=r_u*length_target; %mm
R_d=r_d*length_sensor; %mm
length_r=length(r_d);

% Local radial (MLR) and tangential (MLT) magnification,
kx_ML=1/length_target;  
ky_ML=1/length_sensor;
p_MLR=(order_fit:-1:1)';
p_MLR=p_MLR.*p_dfu(1:order_fit)*(kx_ML/ky_ML);
p_MLT=p_dfu*(kx_ML/ky_ML);
%to creat a matrix with the same size as r_d or r_u
MLR=zeros(length_r,1); % Local radial magnification
MLT=zeros(length_r,1); % Local tangential magnification
MLR_max=0;
MLT_max=0;

for i=1:order_fit
    MLR=MLR+r_u.^(order_fit-i)*p_MLR(i);
end
% for i=1:order_fit+1
%     MLT=MLT+r_u.^(order_fit-i)*p_MLT(i);
% end
% MLT=MLT(~isinf(MLT)); %remove the inf value at the center
for i=1:order_fit
    MLT=MLT+r_u.^(order_fit-i)*p_MLT(i);
end
MLR_N=MLR/MLR(1);
MLT_N=MLT/MLT(1);

figure;
plot(r_d,MLR_N,'--k'); 
hold on
% plot(r_d(2:end),MLT_N,'-.k'); 
plot(r_d,MLT_N,'-.k'); 
hold off
lh=legend('Radial','Tangential','Location','SouthEast');
set(lh,'Box','off');
axis([0 1.1 0 1.1]);
xlabel('Normalized distance from image center to farthest edges');
ylabel('Local magnification (Ratio of sensor-image size to target size)');
title('Normalized Local Magnification');

fname=datestr(clock,0); % Save parameters and results in a file
filename=strcat('outputs\',filename(1:end-4),'_',fname(1:11),'-',fname(13:14),'-',fname(16:17),'-',fname(19:20),'.mat');

save(filename,'size_grid','size_pp','size_d','ratio_si',...
    'center_offset','r_d','r_u','p_dfu',...
    'R_u','R_d','MLR','MLR_N','MLT','MLT_N');
