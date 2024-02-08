function array = readFromGAUSSDaily(var,scaling,run,suffix,years,ensemble_number)
if strcmp(var,'SST')
    module = '.pop.h.nday1.';
else 
    module = '.cam.h0.';
end

suffix_year_1 = str2double(suffix(1:4));
suffix_year_2 = str2double(suffix(8:11));
if strcmp(var,'P-E')
    array = readFromGAUSSDaily('PRECT',scaling,run,suffix,years,ensemble_number) - readFromGAUSSDaily('QFLX',scaling/1000,run,suffix,years,ensemble_number);
elseif strcmp(var,'FSNT-FLNT')
    array = readFromGAUSSDaily('FSNT',scaling,run,suffix,years,ensemble_number) - readFromGAUSSDaily('FLNT',scaling,run,suffix,years,ensemble_number);
else
%     if (strcmp(run,'GAUSS-DEFAULT-OFF-2055') || strcmp(run,'GAUSS-DEFAULT-PO-2055')) && ensemble_number>1 && suffix_year_2==2069
    if strcmp(run,'GAUSS-DEFAULT-PO-2055') && ensemble_number>1 && suffix_year_2==2069
        array_1_5 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) module var '.' '20550101-20591231.nc']],var)*scaling;
        try
        array_6_15 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) module var '.' '20550101-20691231.nc']],var)*scaling;
        
        catch
        array_6_15 = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) module var '.' '20591231-20691231.nc']],var)*scaling;
        end
        array = cat(3,array_1_5,array_6_15(:,:,2:end));
    elseif strcmp(run,'GAUSS-LOWER-1.0') && ensemble_number>1 && suffix_year_2==2069
        suffix_year_2 = 2070;
        suffix = '203501-207012.nc';
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) module var '.' suffix]],var)*scaling;
    else
        array = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number) module var '.' suffix]],var)*scaling;
    end
    if years(2) < suffix_year_2
        array = array(:,:,1:((years(2)-suffix_year_1)*365+365));
    end
    if years(1) > suffix_year_1
        array = array(:,:,((years(1)-suffix_year_1)*365+1):end);
    end
    if years(1)<suffix_year_1
        if strcmp(run,'GAUSS-DEFAULT-OFF-2055') || strcmp(run,'GAUSS-DEFAULT-PO-2055')
            array2 = array;
            size2 = size(array2);
            array = readFromGAUSSDaily(var,scaling,['GAUSS-DEFAULT'],['20350101-20691231.nc'],[years(1) 2054],ensemble_number);
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        elseif strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y') || strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')
            interrupt_size = str2double(run(end-1));
            array2 = array;
            size2 = size(array2);
            array = readFromGAUSSDaily(var,scaling,['GAUSS-DEFAULT-OFF-2055'],['20550101-20691231.nc'],[years(1) 2054+interrupt_size],ensemble_number);
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        elseif strcmp(run,'GAUSS-DEFAULT')
            array2 = array;
            size2 = size(array2);
            if ensemble_number ==3
            array = ncread(['Climate_Data/WACCM_MA_1deg/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.00' int2str(ensemble_number) module var '.20200101-20691231.nc'],var)*scaling;
            array = array(:,:,(years(1)-2020)*365+1:(2034-2020)*365+365);
            else
            array = ncread(['Climate_Data/WACCM_MA_1deg/b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.00' int2str(ensemble_number) module var '.20150101-20641231.nc'],var)*scaling;
            array = array(:,:,(years(1)-2015)*365+1:(2034-2015)*365+365);
            end
            size1 = size(array);
            array(:,:,(size1(3)+1):(size1(3)+size2(3))) = array2;
        end
    end
end
end