function array = readFromGAUSS(var,scaling,run,suffix,years,ensemble_number)

suffix_year_1 = str2double(suffix(1:4));
suffix_year_2 = str2double(suffix(8:11));
if strcmp(var,'P-E')
    array = readFromGAUSS('PRECT',scaling,run,suffix,years,ensemble_number) - readFromGAUSS('QFLX',scaling/1000,run,suffix,years,ensemble_number);
elseif strcmp(var,'FSNT-FLNT')
    array = readFromGAUSS('FSNT',scaling,run,suffix,years,ensemble_number) - readFromGAUSS('FLNT',scaling,run,suffix,years,ensemble_number);
elseif strcmp(var,'SO4')
    array = readFromGAUSS('TMso4_a1',scaling,run,suffix,years,ensemble_number) +readFromGAUSS('TMso4_a2',scaling,run,suffix,years,ensemble_number)+readFromGAUSS('TMso4_a3',scaling,run,suffix,years,ensemble_number);
elseif strcmp(var,'ALL_SULFUR')
    array = readFromGAUSS('TMSO2',scaling,run,suffix,years,ensemble_number)+readFromGAUSS('TMso4_a1',scaling,run,suffix,years,ensemble_number)*64.066/96.06*96.06/115 +readFromGAUSS('TMso4_a2',scaling,run,suffix,years,ensemble_number)*64.066/96.06*96.06/115+readFromGAUSS('TMso4_a3',scaling,run,suffix,years,ensemble_number)*64.066/96.06*96.06/115;
else
%     if (strcmp(run,'GAUSS-DEFAULT-OFF-2055') || strcmp(run,'GAUSS-DEFAULT-PO-2055')) && ensemble_number>1 && suffix_year_2==2069
    if strcmp(run,'GAUSS-DEFAULT-PO-2055') && ensemble_number>1 && suffix_year_2==2069
        array_1_5 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' '205501-205912.nc']],var)*scaling;
        try
        array_6_15 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' '205501-206912.nc']],var)*scaling;
        
        catch
        array_6_15 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' '205912-206912.nc']],var)*scaling;
        end
        array = cat(3,array_1_5,array_6_15(:,:,2:end));
    elseif strcmp(run,'GAUSS-LOWER-1.0') && ensemble_number>1 && suffix_year_2==2069
        suffix_year_2 = 2070;
        suffix = '203501-207012.nc';
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' suffix]],var)*scaling;
    elseif (strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')||strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')) && ensemble_number==1 %&& 0==1
        if strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')
            old_suffix = '205601-206512.nc';
            suffix = '205701-206012.nc';
            suffix3 = '206012-206112.nc';
        else
            old_suffix = '205701-206612.nc';
            suffix = '205801-206012.nc';
            suffix3 = '206012-206212.nc';

        end
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' old_suffix]],var)*scaling;
        array2 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.redone.cam.h0.' var '.' suffix]],var)*scaling;
        array3 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.redone.cam.h0.' var '.' suffix3]],var)*scaling;
        array2_size = size(array2);
        array3_size = size(array3);
        array(:,:,13:(12+array2_size(3))) = array2;
        array(:,:,(12+array2_size(3):(11+array2_size(3)+array3_size(3)))) = array3;
        suffix=old_suffix;
        suffix_year_1 = str2double(suffix(1:4));
        suffix_year_2 = str2double(suffix(8:11));
    elseif (strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')||strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')) && ensemble_number==2
        if strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')
            suffix = '205501-206012.nc';
            suffix3 = '206012-206112.nc';
        else
            suffix = '205601-206012.nc';
            suffix3 = '206012-206212.nc';
        end
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' suffix]],var)*scaling;
        array3 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' suffix3]],var)*scaling;
        array3_size = size(array3);
        array = array(:,:,13:end);
        array1_size = size(array);
        array(:,:,array1_size(3):(array1_size(3)-1+array3_size(3))) = array3;
        suffix_year_1 = str2double(suffix(1:4));
        suffix_year_2 = str2double(suffix(8:11));
    elseif (strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')||strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')) && ensemble_number==3
        if strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')
            suffix = '205601-206012.nc';
            suffix3 = '206012-206112.nc';
        else
            suffix = '205701-206012.nc';
            suffix3 = '206012-206212.nc';
        end
        array3 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' suffix3]],var)*scaling;
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' suffix]],var)*scaling;
        array3_size = size(array3);
        array1_size = size(array);
        array(:,:,array1_size(3):(array1_size(3)-1+array3_size(3))) = array3;
        suffix_year_1 = str2double(suffix(1:4));
        suffix_year_2 = str2double(suffix(8:11));
    else
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) '.cam.h0.' var '.' suffix]],var)*scaling;
    end
    
    if years(2) < suffix_year_2
        array_size = size(array);
        if array_size(3)>((years(2)-suffix_year_1)*12+12)
            array = array(:,:,1:((years(2)-suffix_year_1)*12+12));
        end
    end
    
    if years(1) > suffix_year_1 && ~strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y') && ~strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')
        array = array(:,:,((years(1)-suffix_year_1)*12+1):end);
    end
    
    if years(1)<suffix_year_1 || strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y') || strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')
        if strcmp(run,'GAUSS-DEFAULT-OFF-2055') || strcmp(run,'GAUSS-DEFAULT-PO-2055')
            array2 = array;
            size2 = size(array2);
            array = readFromGAUSS(var,scaling,['GAUSS-DEFAULT'],['203501-206912.nc'],[years(1) 2054],ensemble_number);
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        elseif (strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')&& years(1)<2056) || (strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')&&years(1)<2057)
            interrupt_size = str2double(run(end-1));
            array2 = array;
            size2 = size(array2);
            array = readFromGAUSS(var,scaling,['GAUSS-DEFAULT-OFF-2055'],['205501-206912.nc'],[years(1) 2054+interrupt_size],ensemble_number);
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        elseif strcmp(run,'GAUSS-DEFAULT')||strcmp(run,'GAUSS-LOWER-1.0')||strcmp(run,'GAUSS-LOWER-0.5')
            array2 = array;
            size2 = size(array2);
            p = [];
            array = readFromSSP45(var,scaling,run,suffix,[years(1) 2034],ensemble_number,p);
%             if ensemble_number ==3
%             array = ncread(['Climate_Data/WACCM_MA_1deg/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.00' int2str(ensemble_number) '.cam.h0.' var '.202001-206912.nc'],var)*scaling;
%             array = array(:,:,(years(1)-2020)*12+1:(2034-2020)*12+12);
%             else
%             array = ncread(['Climate_Data/WACCM_MA_1deg/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.00' int2str(ensemble_number) '.cam.h0.' var '.201501-206412.nc'],var)*scaling;
%             array = array(:,:,(years(1)-2015)*12+1:(2034-2015)*12+12);
%             end
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        elseif strcmp(run,'GAUSS-DEFAULT-DELAYED.2045')
            array2 = array;
            size2 = size(array2);
            if ensemble_number ==3
            array = ncread(['Climate_Data/WACCM_MA_1deg/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.00' int2str(ensemble_number) '.cam.h0.' var '.202001-206912.nc'],var)*scaling;
            array = array(:,:,(years(1)-2020)*12+1:(2044-2020)*12+12);
            else
            array = ncread(['Climate_Data/WACCM_MA_1deg/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.00' int2str(ensemble_number) '.cam.h0.' var '.201501-206412.nc'],var)*scaling;
            array = array(:,:,(years(1)-2015)*12+1:(2044-2015)*12+12);
            end
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        end
    end
end
end