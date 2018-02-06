function [timestamps,RR] = R_R( datadir,win )
ecg=fopen(datadir);
data = fscanf(ecg,'%f');
nsamples=size(data,1);
time=zeros(nsamples,1);
for i= 1:1:nsamples
    time(i)=(i)/256;
end
wo = 50/(256/2);  bw = wo/30; % getin notch filter with Q = 35 parameters with 50 hz cutoff
[b,a] = iirnotch(wo,bw);
data=filter(b,a,data);
wo = 60/(256/2);  bw = wo/30; % getin notch filter with Q = 35 parameters with 60 hz cutoff
[b,a] = iirnotch(wo,bw);
data=filter(b,a,data);
[b,a] = fir1(20,[0.5 45]/128,'bandpass');
data=filter(b,a,data);
T=1/256;
defdata=zeros(nsamples,1);
for i = 1:1:nsamples 
   %differentiating
    if(i==1)
        defdata(i)= (1/(8*T))*(data(i+2)+2*data(i+1));
    elseif(i==2)
        defdata(i)= (1/(8*T))*(-2*data(i-1)+data(i+2)+2*data(i+1));
    elseif(i==nsamples)
        defdata(i)= (1/(8*T))*(-1*data(i-2)-2*data(i-1));
    elseif(i==nsamples-1)
        defdata(i)= (1/(8*T))*(-1*data(i-2)-2*data(i-1)+2*data(i+1));
    else
        defdata(i)= (1/(8*T))*(-1*data(i-2)-2*data(i-1)+data(i+2)+2*data(i+1));
    end
end

for i = 1:1:nsamples 
   %differentiating
    defdata(i)= defdata(i)^2;
end
 avrdata=zeros(nsamples,1);
for i = 1:1:nsamples
    
    if(i<win+1)
        for j = 25:-1:win-i+1
      avrdata(i)= avrdata(i)+ defdata(i-(win-j));
        end
         avrdata(i)=(1/i)*avrdata(i);
    else
        for j = 1:1:win
      avrdata(i)= avrdata(i)+ defdata(i-(win-j));    
        end
         avrdata(i)=(1/win)*avrdata(i);
    end
        
end

 threshold = std(avrdata)+mean(avrdata); %getting the max 15.9% of the data i think :D 
beats= zeros(nsamples,1);nbeats=0;
timestamps= zeros(nsamples,1);
 lastmax=1;
for i = 1:win:nsamples-win
    [M,I]=max(transpose(avrdata(i:i+win-1)));
    if(M>threshold)
        if( lastmax<i && lastmax>i-win) %if ther is a max was handled in the last window
            if(M>avrdata(lastmax))
                
                 beats(nbeats)=M;
                timestamps(nbeats)=I+i; 
                    lastmax=I+i-1;
            end
        else
                nbeats=nbeats+1;
             beats(nbeats)=M;
                timestamps(nbeats)=I+i;
                    lastmax=I+i-1;
        end  
    end
    if(i<2000)
        nsbeats=nbeats;
    end
end
RR=zeros(nbeats,1);
for i=1:1:nbeats-1
    RR(i)= (10^3/256)*((timestamps(i+1)- timestamps(i)));
end
timestamps=timestamps(1:nbeats);
figure(1);
plot((1:nsamples),avrdata(1:nsamples),'g',timestamps(1:nbeats),beats(1:nbeats),'*');
title('detected R in the data');
xlabel('# sample');
ylabel('voltage');
figure(3);
plot((1:nbeats-1),RR(1:nbeats-1),'g');
title('RR vs beat');
xlabel('beat');
ylabel('RR intervals');
fclose(ecg);
end