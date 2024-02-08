function world_area = getLandfrac()
world_area = ncread("Climate_Data/GAUSS-DEFAULT-OFF-2055/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-GAUSS-DEFAULT-OFF-2055.002.cam.h0.2055-12.nc",'LANDFRAC');

end