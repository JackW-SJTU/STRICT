function [SSEs,SSEd,SSEall]=randomNoise(X,Y,model,NN)
[N1,N2]=size(X);

[S,D]=model(X,Y);
if max(S)>0
    S=(S-min(S))./(max(S)-min(S));
end
if max(max(D))>0
    D=(D-min(min(D)))./(max(max(D))-min(min(D)));
end

SSEs=zeros(10,1);
SSEd=zeros(10,1);
SSEall=zeros(10,1);

for i=1:10
    xx=[X rand(N1,NN)];
    yy=Y;
    
    [ss,dd]=model(xx,yy);
    ss=ss(1:N2);
    dd=dd(1:N2,1:N2);
    if max(ss)>0
        ss=(ss-min(ss))./(max(ss)-min(ss));
    end
    if max(max(dd))>0
        dd=(dd-min(min(dd)))./(max(max(dd))-min(min(dd)));
    end
    
    SSEs(i,1)=sqrt(sum((ss-S).^2))./sum(abs(S));
    SSEd(i,1)=sqrt(sum(sum((dd-D).^2)))./sum(sum(abs(D)));
    SSEall(i,1)=sqrt(sum(sum(([dd ss]-[D S]).^2)))./sum(sum(abs([D S])));
end

SSEs=mean(SSEs);
SSEd=mean(SSEd);
SSEall=mean(SSEall);
end