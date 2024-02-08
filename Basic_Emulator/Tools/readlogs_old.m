function [yr,dat]=readlogs(str)
%function [yr,dat]=readlogs(str)
%
% read log files, optional argument to specify search string
% note hard-coded to assume without checking that all files have same
% number of years!
%
% Turned into function 7/13/21
if nargin==0,str='*';end
DD=dir(['ControlLog*' str '*.txt']);
nfl=length(DD);
if nfl==0,disp('No files found');return;end
nvar=15;
nyr=81;
dat=zeros(nvar,nyr,nfl);
for kk=1:nfl,
    fid=fopen(DD(kk).name);
    if ~isempty(findstr(DD(kk).name,'eq')),nvar=5;else,nvar=15;end
    txtstr=fgetl(fid);
    tmp=fscanf(fid,'%f',[nvar inf]);
    dat(1:nvar,1:size(tmp,2),kk)=tmp;
    fclose(fid);
end
yr=squeeze(dat(1,:,1));
II=find(yr==max(yr));
yr=yr(1:II);
dat=dat(:,1:II,:);
