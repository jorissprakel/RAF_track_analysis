function [MSDout]=MSD(tracks,maxtime,fps,mindisp);

%delete MSD.mat;
numtracks=max(tracks(:,4));
dt=[1:1:maxtime];
MSDtemp=zeros(length(dt),numtracks);
dr_cut = 0; %if motion< this value track is considered non motile and not used

counter=0;
for bead = 1: numtracks

   thistrack = tracks(tracks(:,4)==bead,1:2);
   dx=max(thistrack(:,1))-min(thistrack(:,1));
   dy = max(thistrack(:,2))-min(thistrack(:,2));
   dr=sqrt(dx^2+dy^2);

    if dr>dr_cut
        counter=counter+1
   for ctime=1:maxtime
       if length(thistrack>ctime+5)
           xdisp=thistrack(1:end-ctime,1)-thistrack(ctime:end-1,1);
           ydisp=thistrack(1:end-ctime,2)-thistrack(ctime:end-1,2);
           MSDtemp(ctime,bead) = mean(xdisp.^2+ydisp.^2);
       end
   end
    end
end

%MSDtemp2=MSDtemp;
MSDtemp2=[];


%select based on streaming tracks
 counter=1;
 for bead=1:numtracks
     if MSDtemp(end,bead)>mindisp
         MSDtemp2(:,counter)=MSDtemp(:,bead)
         counter=counter+1;
     end
 end

if numel(MSDtemp2)>0
MSDar=[];
for j=1:maxtime
    thistime=MSDtemp2(j,:);
    MSDar=[MSDar; nanmean(thistime)];
end

MSDout=zeros(length(MSDar),2);
MSDout(:,1)=(1/fps)*[0:1:length(MSDar)-1]';
MSDout(:,2)=MSDar;
save 'MSD.mat' MSDout;
else
    MSDout=[];
end

           
