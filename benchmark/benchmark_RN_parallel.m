clear
AllFiles=dir(fullfile(pwd,'*.mat'));
XX={};YY={};
for i=1:length(AllFiles)
    load([AllFiles(i).folder '/' AllFiles(i).name])
    XX{i}=X;
    YY{i}=Y./max(Y);
end
result=cell(5,1);
A=0:10:100;
for ii=1:5
    ii
    temp=zeros(9*11,3);
    parfor k=1:length(AllFiles)*11
        iii=mod(k,11);
        iii(iii==0)=11;
        i=fix((k-1)/11)+1;
        
        if ii==1
           model=@fun_escore;
        elseif ii==2
           model=@fun_lasso;
        elseif ii==3
           model=@fun_elastic;
        elseif ii==4
           model=@fun_nca;
        elseif ii==5
           model=@fun_stepwise;
        end
        
        iii=A(iii);

        [SSEs,SSEd,SSEall]=randomNoise(XX{i},YY{i},model,iii);
        temp(k,:)=[SSEs,SSEd,SSEall];
    end
    result{ii,1}=temp;
end

%%
Result={};
for i=1:5
    load(['4.30/' num2str(i) '.mat'])
    temp=mat2cell(temp,[11 11 11 11 11 11 11 11 11]);
    Result=[Result temp];
end
result=Result;
%%
C=[136 171 218; 209 192 156; 250 205 137; 242 156 159; 179 162 199]/255;
A=result;
subplot(2,2,1)
A=cell2mat(A);
for i=[1 3:5]
    plot(0:10:100,A(:,3*i-2),'.-','markersize',12,'color',C(i,:),'linewidth',2);hold on
end
set(gca,'ticklength',[0 0])
legend({'STRICT','EN','NCA','Stepwise'},'fontsize',8,'location','northwest')
xlabel('Irrelevant Random Features')
ylabel('nRMSE')
set(gca,'fontsize',10)
title('Single-drug Effects')
hold off
subplot(2,2,2)
A(A>0.02)=A(A>0.02)/6.66667;
for i=[1 3:5]
    plot(0:10:100,A(:,3*i-1),'.-','markersize',12,'color',C(i,:),'linewidth',2);hold on
end
set(gca,'ticklength',[0 0])
%set(gca,'YScale','log')
legend({'STRICT','EN','NCA','Stepwise'},'fontsize',8,'location','northwest')
xlabel('Irrelevant Random Features')
ylabel('nRMSE')
set(gca,'fontsize',10)
title('Pairwise Interaction Effects')
ylim([0 0.03])
yticks([0 0.005 0.01 0.015 0.02 0.03])
yticklabels({'0','0.005','0.01','0.015','0.02','0.2'})
hold off
%saveas(gcf,[AllFiles(i).name(1:end-4) '.png'],'png')
%close all





