% This functon calculates the maximum grid number at maximum pixel distance
% from the image center, by getting the polynomial fitting function of 
% pixel distance v. grid #. 

% input:
% x: distances (in pixeld) of cross points read from the image center to boundary
% y: grid number
% x_max: the maximum distance (in pixels) from the image center to boundary
% r2min: the minimum r-squared value requirement for the fitting

% output:
% y_max: the maximum grid number at maximum pixel distance 
% r2_order: the r-squared value and degree (n) of the final function
% p:  polynomial coefficients, p(x)=p(1)*x^n+p(2)*x^(n-1)+...+p(n)*x+p(n+1)
% The maximum digree of fitting equation is 7.

function [p,y_max,r2_order]=max_gp(x,y,x_max,r2min)
% If switch x and y, the function can also calculate macimum pixel # with 
% known maximum grid #

r2_order=[0 0];
for i=1:7
    [p,S]=polyfit(x,y,i);
    r2=1-S.normr^2/norm(y-mean(y))^2;
    %     y_fit=polyval(p,x);
    %     r2=rsquare(y_fit,y);
    if r2>r2_order(1)
        r2_order=[r2 i];
    end
    if r2>r2min
        break;
    end
end

if r2<r2min
   disp('The R squared value is less than the minimum r-squared value requirement for polynomial fitting of degree');
end
   disp('The best R squared value and the optimized degree (1-7) of the polynomial are:');
   disp(r2_order);

y_max=polyval(p,x_max);
if y_max<max(y)
    y_max=max(y);
end

% y_fit=polyval(p,x);
% figure;
% hold on
% plot(x,y,'-.r'); % raw data
% plot(x,y_fit,'-r'); % fitted data
% legend('raw data','fitted data')
% hold off;

% if r2_order<r2min
%     disp('The minimum r-squared value requirement for the fitting is not satisfied.');
% end


%     function r2 = rsquare(x,y)
%         mean_x=mean(x);
%         mean_y=mean(y);
%         r=sum((x-mean_x).*(y-mean_y))/sqrt(sum((x-mean_x).*(x-mean_x))*sum((y-mean_y).*(y-mean_y)));
%         r2=r*r;
%     end

end