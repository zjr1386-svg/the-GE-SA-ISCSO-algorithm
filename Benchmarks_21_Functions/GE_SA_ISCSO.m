function [Best_Score,BestFit,Convergence_curve]=GE_SA_ISCSO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
BestFit=zeros(1,dim);
Best_Score=inf;
lowerbound=ones(1,dim).*(lb);                             
upperbound=ones(1,dim).*(ub);  
Positions = repmat(lowerbound,SearchAgents_no,1)+chaos(1,SearchAgents_no,dim).* repmat((upperbound-lowerbound),SearchAgents_no,1);  
Convergence_curve=zeros(1,Max_iter);
t=0;
p=[1:360];
for i=1:size(Positions,1)
    fitness(i)=fobj(Positions(i,:));
    if fitness(i)<Best_Score
        Best_Score=fitness(i);
        BestFit=Positions(i,:);
    end
end
pX = Positions;
pFit = fitness;
while t<Max_iter

    S=2;                                  
    rg=S-((S)*t/(Max_iter));               
    sigma_initial = 2; 
    sigma_final = 1 / Max_iter ;
    l1 =  ((Max_iter - t)/(Max_iter-1) )^1 * (sigma_initial - sigma_final) + sigma_final;
    r1=rand(); 
    r2=rand(); 
    A1 =1+l1*(r1 -1/2);
    C1=2*r2;
    for i=1:size(Positions,1)
        r=rand*rg;
        R=((2*rg)*rand)-rg;                
        for j=1:size(Positions,2)
            teta=RouletteWheelSelection(p);
            if((-1<=R)&&(R<=1))             
                Rand_position=abs(rand*BestFit(j)-pX(i,j));
                Positions(i,j)=BestFit(j)-r*Rand_position*cos(teta);
            else
                cp=floor(SearchAgents_no*rand()+1);
                CandidatePosition =pX(cp,:);
                D=C1*BestFit(j)-pX(i,j);
                Positions(i,j)=r*(CandidatePosition(j)+A1*D);
            end
        end
    end
    for i=1:size(Positions,1)
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        fitness(i)=fobj(Positions(i,:));
        if (fitness( i ) < pFit( i ))
            pFit( i ) = fitness( i );
            pX(i, :) = Positions( i, : );
        end
        if  pFit( i )<Best_Score
            Best_Score=pFit(i);
            BestFit=pX(i,:);
        end
    end
    
    [fmax,idx]=max(pFit);
    worse = pX(idx,:);
    c=randperm(SearchAgents_no);
    b=c(1:30);
    for i =  1:length(b)     
        if( fitness(b(i))>Best_Score)
            Positions(b(i),:)=BestFit+(randn(1,dim)).*(abs(( pX(b(i),:)-BestFit)));
        else
            Positions(b(i),:) =pX(b(i),:)+(2*rand(1)-1)*(abs(pX(b(i),:)-worse))/ ( pFit(b(i))-fmax+1e-50);
        end
        Flag4ub=Positions(b(i),:)>ub;
        Flag4lb=Positions(b(i),:)<lb;
        Positions(b(i),:)=(Positions(b(i),:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        fitness(b(i))=fobj(Positions(b(i),:));
    end
    for i=1:size(Positions,1) 
        if (fitness(i) < pFit(i))
            pFit( i ) = fitness( i );
            pX(i, :) = Positions( i, : );
        end
        if  pFit( i )<Best_Score
            Best_Score=pFit(i);
            BestFit=pX(i,:);
        end
    end
    t=t+1;
    Convergence_curve(t)=Best_Score;
end
end