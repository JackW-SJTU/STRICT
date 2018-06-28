function [ss,dd]=fun_nca(X,Y,draw,Name)
%%%

if ~exist('draw','var')
    draw=0;
elseif ~exist('Name','var')
    Name=cellfun(@num2str,mat2cell([1:dn]',ones(1,dn)),'uniformoutput',0);
end
%%%

X=X./repmat(max(X),[size(X,1) 1]);

XX=x2fx(X,'interaction');
XX=XX(:,2:end);
mdl=fsrnca(XX,Y,'standardize',1);

coef=mdl.FeatureWeights;
ss=coef(1:size(X,2));

dd=zeros(size(X,2));
k=size(X,2);
for i=1:size(X,2)-1
    for j=i+1:size(X,2)
        k=k+1;
        dd(i,j)=coef(k);
    end
end
dd=dd+dd';

%%%
if draw==1
    g=clustergram(dd,'colormap',jet);
    seq=cellfun(@str2num,g.RowLabels);
    Name=Name(seq);
    subplot(1,100,1:75)
    imagesc(dd(seq,seq))
    colorbar
    colormap(jet)
    xticks([])
    yticks(1:size(X,2))
    yticklabels(Name)
    subplot(1,100,90:100)
    imagesc(ss(seq,1))
    xticks([])
    yticks(1:size(X,2))
    yticklabels(Name)
    colorbar
    colormap(jet)
end
end
        