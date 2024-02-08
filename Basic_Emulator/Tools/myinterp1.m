function vq = myinterp1(x,v,xq)

if x(1) == x(end)
    vq = v(1);
else
    xq(end)
    vq = interp1(x, v,xq);
end

end