function av = globalMean(M,p)
M_size = size(M);
if length(M_size) ==2
    M_size = [M_size, 1];
end
if length(M_size) ==3
    M_size = [M_size, 1];
end
ww = p.ww;

av = zeros(M_size(3:4));
% area = getArea;

for i = 1:M_size(3)
    for j = 1:M_size(4)
        av(i,j) = (mean((sum(M(:,:,i,j)'.*ww)/sum(ww))'));
%         av(i,j) = M(:,:,i,j).*area;
    end
end
end