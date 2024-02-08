function av = L_x(x,M,p)
M_size = size(M);
if length(M_size) ==2
    M_size = [M_size, 1];
end
if length(M_size) ==3
    M_size = [M_size, 1];
end
ww = p.ww;

av = zeros(M_size(3:4));

switch x
    case 0
        for i = 1:M_size(3)
            for j = 1:M_size(4)
                av(i,j) = (mean((sum(M(:,:,i,j)'.*ww)/sum(ww))'));
            end
        end
    case 1
        l1 = legendre(x,sind(p.lat));
        l1 = l1(1,:)';
        for i = 1:M_size(3)
            for j = 1:M_size(4)
                av(i,j) = (mean((sum(M(:,:,i,j)'.*ww.*l1)/sum(ww.*l1.^2))'));
            end
        end
    case 2
%         l2 = legendre(x,sind(p.lat));
        l2 = 1/2*(3*sind(p.lat).^2-1);
        for i = 1:M_size(3)
            for j = 1:M_size(4)
                av(i,j) = (mean((sum(M(:,:,i,j)'.*ww.*l2)/sum(ww.*l2.^2))'));
            end
        end

end