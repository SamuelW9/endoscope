% r2_min: the minimum r-squared value requirement for the fitting
% p:  polynomial coefficients, p(x)=p(1)*x^n+p(2)*x^(n-1)+...+p(n)*x+p(n+1)
% r2_fit: the r-squared value and degree of the final fitting function
function [p,r2_fit]=ru_rd_fit3(x,y,r2_min,degr)

r2_fit=[0 0];

% degr=5; % 5: 5th order polyfit directly; any other value: try different degrees of polynomial
if degr==5
    
    [p,S]=polyfit(x,y,5);
    r2=1-S.normr^2/norm(y-mean(y))^2;
    if r2>r2_fit(1)
        r2_fit=[r2 5];
    end
    
else
    
    for i=1:7
        [p,S]=polyfit(x,y,i);
        r2=1-S.normr^2/norm(y-mean(y))^2;
        if r2>r2_fit(1)
            r2_fit=[r2 i];
        end
        if r2>r2_min
            break;
        else
            disp('The R squared value is less than the minimum r-squared value requirement for polynomial fitting of degree');
            disp(i);
        end
    end
    
end

if r2_fit<r2_min
    disp('The minimum r-squared value requirement for the fitting is not satisfied.');
end

end