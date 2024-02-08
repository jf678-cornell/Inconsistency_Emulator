% calculates the contrast ratio between all pairs of colors in a set
% formulas were taken from https://www.w3.org/TR/WCAG20/#contrast-ratiodef
% input: color scheme - a matrix of RGB values, where each row contains the
%                       RGB values for one color - n x 3
% output 1: contrast ratio - a matrix containing the contrast ratios of
%                            each pair of colors in the color scheme. 
%                            Entry i,j is the contrast ratio between
%                            the ith and jth colors.
%                            This matrix is symmetric and all of the diagonal entries are 1. 
% output 2: min_contrast_ratio - the minimum contrast ratio between 2
%                                different colors in the color scheme
function [contrast_ratio, min_contrast_ratio] = calculate_contrast_ratio(color_scheme)
    if nargin ~=1
        error('This function must be called with exactly 1 input')
    elseif ~ismatrix(color_scheme)
        error('Input must be a 2D matrix')
    elseif size(color_scheme,2)~=3
        error('Input must be a n x 3 matrix')
    end
    n = size(color_scheme,1);
    RGB = zeros(n,3);
    for i = 1:n %calculate the RGB values from the provided sRGB values in color_scheme
        if color_scheme(i,1) < 0.03928
            RGB(i,1) = color_scheme(i,1)/12.92;
        else
            RGB(i,1) = ((color_scheme(i,1)+0.055)/1.055)^2.4;
        end
        if color_scheme(i,2) < 0.03928
            RGB(i,2) = color_scheme(i,2)/12.92;
        else
            RGB(i,2) = ((color_scheme(i,2)+0.055)/1.055)^2.4;
        end
        if color_scheme(i,3) < 0.03928
            RGB(i,3) = color_scheme(i,3)/12.92;
        else
            RGB(i,3) = ((color_scheme(i,3)+0.055)/1.055)^2.4;
        end
    end
    L =  0.2126*RGB(:,1) + 0.7152*RGB(:,2) + 0.0722*RGB(:,3); %relative luminence
    contrast_ratio = NaN(n);
    for i = 1:n-1
        for j = i+1:n
            if L(i)>=L(j)
%                 cr = (L(i)+0.05)/(L(j)+0.05);
                cr = (L(i)+realmin)/(L(j)+realmin);
            else
%                 cr = (L(j)+0.05)/(L(i)+0.05);
                cr = (L(j)+realmin)/(L(i)+realmin);
            end
            contrast_ratio(i,j) = cr;
            contrast_ratio(j,i) = cr;
        end
    end
    min_contrast_ratio = min(contrast_ratio,[],'all','omitnan');
    for i = 1:n
        contrast_ratio(i,i)=1;
    end
end