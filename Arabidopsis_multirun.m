numfiles=45;
fps = 5.3;
maxtime=15;
pixtomicrons = 0.1608; %pixel to micron conversion
mindisp=0.2;

MSDcombined=zeros(maxtime,numfiles+3); %c1 = dt, c2 = average over experiments, c3 = error, c4-c9 = individual MSD
dt=[0:1:(maxtime-1)];
MSDcombined(:,1)=(1/fps)*dt';
track_counter=0;
D=[];
Alpha=[];

for file=1:numfiles
%for file=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30]
bp_low = 2; %lower bp cutoff
bp_high = 15; %upper bp cutoff
thresh = 15; %threshold value for peak intensity
featsize = 5; %feature size in pixels
filtsize = 9; %size for centroid filter (larger than featsize, not so large it captures neighbors)
cd(['file' num2str(file)]);
%pretrack_bg_Penium;
track_all(bp_high, bp_low, featsize, filtsize, thresh);
load 'positions.mat';
create_traject(positionlist,pixtomicrons);
load 'tracks.mat';
numtracks=max(tracks(:,4));
track_counter=track_counter+numtracks;
[MSDout]=MSD(tracks,maxtime,fps,mindisp);
a=numel(MSDout)
if numel(MSDout)>0
MSDcombined(1:length(MSDout(:,2)),file+3)=MSDout(:,2);
[thisD thisAlpha]=MSDfit;
D=[D; thisD];
Alpha=[Alpha; thisAlpha];
end
%delete im_*.*
cd ..
end

for k=1:maxtime
    thisdt=MSDcombined(k,4:end);
    thisdt(thisdt==0)=[];
    if numel(thisdt)>0
        MSDcombined(k,2)=nanmean(thisdt);
        MSDcombined(k,3)=nanstd(thisdt);
    end
end
%Alpha(D>Dmax)=[];
%D(D>Dmax)=[];

save 'MSDcombined_filt.mat' MSDcombined;
save 'track_counter.mat' track_counter;
save 'diffusion_coefficients.mat' D;
save 'anomalous_diff_exponent.mat' Alpha;

meanD=mean(D);
stdD=std(D);
clear;
