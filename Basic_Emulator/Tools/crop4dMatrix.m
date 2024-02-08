function croppedM = crop4dMatrix(M,lon,lat,lonDes,latDes)

croppedM = M(lon>=lonDes(1)&lon<=lonDes(2),lat>=latDes(1)&lat<=latDes(2),:,:);

end