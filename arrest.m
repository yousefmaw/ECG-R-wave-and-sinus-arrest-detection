function [ miss_timestamps ] = arrest( datadir,win )
[RR_timestamps,RR]=R_R(datadir,win);
nbeats=size(RR,1);
threshold = std(RR)+mean(RR);
miss_timestamps= zeros(nbeats,1);
 lastmax=1; missb=0; mbeats=zeros(nbeats,1);
 %applying the method of finding the beats on RR to find the missing beats
 %but with window =1 as the rr array is vs the beat number
 win=1;
for i = 1:win:nbeats-win
    [M,I]=max(transpose(RR(i:i+win-1)));
    if(M>threshold)
        if( lastmax<i && lastmax>i-win) %if ther is a max was handled in the last window
            if(M>RR(lastmax))
                 mbeats(missb)=M;
               miss_timestamps(missb)=I+i-1; 
                    lastmax=I+i-1;
            end
        else
                missb=missb+1;
             mbeats(missb)=M;
                miss_timestamps(missb)=I+i-1;
                    lastmax=I+i-1;
        end  
    end
   
end
figure(2);
plot((1:nbeats-1),RR(1:nbeats-1),'g', miss_timestamps(1:missb),mbeats(1:missb),'*');
title('detected missing beat in RR interval');
xlabel('beat neumber');
ylabel('rr intervales in msec');

for i=1:1:missb
    %time of missing beats by msec
    miss_timestamps(i)=0.5*(RR_timestamps( miss_timestamps(i)+1)+RR_timestamps( miss_timestamps(i)));
    %transforming to sample num
end
miss_timestamps=miss_timestamps(1:missb);
out=fopen('MissingBeats.txt','w');
fprintf(out,'%f \n',miss_timestamps);
end

