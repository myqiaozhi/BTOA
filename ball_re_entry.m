
function  X=ball_re_entry(X,oldPopPos,Up,Low)


    Dim=length(X);
    for d=1:Dim
        if X(d)>Up(d)
            q=rand;
            X(d)=q*Up(d)+(1-q)*oldPopPos(d);
        end
        if X(d)<Low(d)
            p=rand;
            X(d)=p*Low(d)+(1-p)*oldPopPos(d);
        end
    end
