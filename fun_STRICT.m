% This function evaluates the score of the drugs and interactions by two
% inputs: 
% X is the m*n matrix, where each row is a drug combination experiment and
% each column is a drug, the elements of the matrix are doses
% Y is a m*1 vector representing the efficacy corresponding to X 
% Order is the exponential order of distance function, default is 2
% draw is a 0/1 input for whether a heatmap will be plotted, default is not
% Name is a drug name for plotting the heatmap.
% The two outputs are respectively the single drug score and the drug 
% interaction score.
% Example:
% load bacteria
% [escore_single,escore_inter]=fun_STRICT(X,Y,2,1,drugName)

function [escore_single,escore_inter]=fun_STRICT(X,Y,order,draw,Name)
%drug number
dn=size(X,2);
%weight function order
if ~exist('order','var')
    order=2;
end
if ~exist('draw','var')
    draw=0;
elseif ~exist('Name','var')
    Name=cellfun(@num2str,mat2cell([1:dn]',ones(1,dn)),'uniformoutput',0);
end
%experiment number
expn=size(X,1);

%normalize X to [0,1]
X=X./repmat(max(X),[size(X,1) 1]);

%% single drug escore
escore_single=zeros(dn,2);
for i=1:dn
    temp=zeros(expn,1);
    for ii=1:expn
        x=X(ii,:);
        x(i)=[];
        temp(ii)=Y(ii)*X(ii,i)*(1-sqrt(sum(x.^2)/(dn-1)))^order;
    end
    escore_single(i,1)=round(sum(temp(temp~=0)),2);
    escore_single(i,2)=sum(temp~=0);
end

%double drug escore
escore_inter=zeros(dn,dn);
for i=1:dn-1
    for j=i+1:dn
        temp=zeros(expn,1);
        for ii=1:expn
            x=X(ii,:);
            x([i j])=[];
            temp(ii)=Y(ii)*sqrt(X(ii,i)*X(ii,j))*(1-sqrt(sum(x.^2)/(dn-2)))^order;
        end
        escore_inter(i,j)=round(sum(temp(temp~=0)),2);
        %escore_double(j,i)=sum(temp~=0);
    end
end
escore_inter=escore_inter+escore_inter';
%% draw
if draw==1
    
    escore_inter(isnan(escore_inter))=0;
    g=clustergram(escore_inter,'colormap',jet);
    seq=cellfun(@str2num,g.RowLabels);
    Name=Name(seq);
    subplot(1,100,1:75)
    imagesc(escore_inter(seq,seq))
    colorbar
    colormap(jet)
    xticks([])
    yticks(1:dn)
    yticklabels(Name)
    subplot(1,100,90:100)
    imagesc(escore_single(seq,1))
    xticks([])
    yticks(1:dn)
    yticklabels(Name)
    colorbar
    colormap(jet)
end
end
