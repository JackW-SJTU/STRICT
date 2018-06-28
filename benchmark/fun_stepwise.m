function [ss,dd]=fun_stepwise(X,Y,draw,Name)
%%%
if ~exist('draw','var')
    draw=0;
elseif ~exist('Name','var')
    Name=cellfun(@num2str,mat2cell([1:dn]',ones(1,dn)),'uniformoutput',0);
end
%%%

X=X./repmat(max(X),[size(X,1) 1]);

mdl=stepwiselm(X,Y,...
    'criterion','adjrsquared','upper','interactions','verbose',0);
term=mdl.Formula.Terms(:,1:end-1);
coef=mdl.Coefficients.Estimate;

ss=zeros(size(X,2),1);
dd=zeros(size(X,2));

for i=1:length(coef)
    if sum(term(i,:))==1
        ss(logical(term(i,:)))=coef(i);
    elseif sum(term(i,:))==2
        ind=find(term(i,:));
        dd(ind(1),ind(2))=coef(i);
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
        