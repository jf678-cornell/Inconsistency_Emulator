function slope = findSlope(a,b,c,d,e)
f = fittype('a*x+b'); 
years = 1:5;
years = years';
array_to_fit = [a;b;c;d;e];
[fit1,~,~] = fit(years,array_to_fit,f,'StartPoint',[1 0]);
slope = fit1.a;

end