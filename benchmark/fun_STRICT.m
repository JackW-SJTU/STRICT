function [escore_single,A]=fun_escore(X,Y,order,draw,Name)
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

% single drug escore
escore_single=zeros(dn,1);
for i=1:dn
    temp=zeros(expn,1);
    for ii=1:expn
        x=X(ii,:);
        x(i)=[];
        temp(ii)=Y(ii)*X(ii,i)*(1-sqrt(sum(x.^2)/(dn-1)))^order;
    end
    escore_single(i,1)=sum(temp);
end

%double drug escore
escore_double=zeros(dn,dn);
for i=1:dn-1
    for j=i+1:dn
        temp=zeros(expn,1);
        for ii=1:expn
            x=X(ii,:);
            x([i j])=[];
            temp(ii)=Y(ii)*sqrt(X(ii,i)*X(ii,j))*(1-sqrt(sum(x.^2)/(dn-2)))^order;
        end
        escore_double(i,j)=sum(temp);
        %escore_double(j,i)=sum(temp~=0);
    end
end
A=escore_double+escore_double';
% draw
if draw==1
    
    A(isnan(A))=0;
    g=clustergram(A,'colormap',jet);
    seq=cellfun(@str2num,g.RowLabels);
    Name=Name(seq);
    subplot(1,100,1:75)
    imagesc(A(seq,seq))
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
