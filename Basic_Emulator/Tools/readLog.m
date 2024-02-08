function L = readLog(run,mem)
% mem = [1 2 3]
% run = 'GAUSS-DEFAULT';
nickname = 1;
if strcmp(run,'GAUSS-DEFAULT')
    controllername = 'DefaultMA';
elseif strcmp(run,'GAUSS-DEFAULT-PO-2055')
    controllername = 'DefaultMA_PO';
elseif strcmp(run,'GAUSS-DEFAULT-RESTART-2055-1y')
    controllername = 'DefaultMA_Restart1y';
elseif strcmp(run,'GAUSS-DEFAULT-RESTART-2055-2y')
    controllername = 'DefaultMA_Restart2y';
elseif strcmp(run,'GAUSS-LOWER-1.0')
    controllername = 'Lower-1.0-MA';
elseif strcmp(run,'GAUSS-LOWER-0.5')
    controllername = 'Lower-0.5-MA';
else
    nickname = 0;
"ControlLog_b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-GAUSS-DEFAULT-DELAYED.2045.001";
end
L = [];
for i=1:length(mem)
    if nickname ==1
        FA = dlmread(['Climate_Data/' run '/' 'Controller_start_' controllername '_00' int2str(mem(i)) '.txt'], ' ' ,1, 0);
    else
        FA = dlmread(['Climate_Data/' run '/ControlLog_b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(mem(i)) '.txt'], ' ' ,1, 0);
    end
    L.yy(:,i) = FA(:,1);
    L.dt0(:,i) = FA(:,2);
    L.sdt0(:,i) = FA(:,3);
    L.dt1(:,i) = FA(:,4);
    L.sdt1(:,i) = FA(:,5);
    L.dt2(:,i) = FA(:,6);
    L.sdt2(:,i) = FA(:,7);
    L.L0(:,i) = FA(:,8);
    L.L1N(:,i) = FA(:,9);
    L.L1S(:,i) = FA(:,10);
    L.L2(:,i) = FA(:,11);
    L.S30(:,i) = FA(:,12);
    L.S15(:,i) = FA(:,13);
    L.N15(:,i)= FA(:,14);
    L.N30(:,i) = FA(:,15);
    L.sums(:,i)=( L.N15(:,i)+ L.S15(:,i)+ L.N30(:,i)+ L.S30(:,i));
end
end