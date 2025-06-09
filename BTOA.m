
% Basketball Team Optimization Algorithm (BTOA) is a novel metaheuristic inspired by basketball strategies, 
% designed to enhance optimization performance through dynamic positioning, 
% high-intensity training, and fast-break strategies.

function [Xbest, Fbest, convergence_curve] = BTOA(F, TeamSize, MaxGen,DIM,cec)


    [lb, ub, dim, fobj] = Get_Functions_cec2017(F, DIM);


    kappa  = 5;
    lambda = 1;
    strongnum = round(TeamSize / 8);

    
    if size(lb) == 1
        lb = ones(1, dim) * lb;
        ub = ones(1, dim) * ub;
    end
    Players = zeros(TeamSize, dim);
    PlayerFitness = zeros(1, TeamSize);
    for i = 1:TeamSize
        Players(i, :) = rand(1, dim) .* (ub - lb) + lb;
        PlayerFitness(i) = fobj(Players(i, :));
    end 

    convergence_curve = zeros(MaxGen, 1);

    for It = 1:MaxGen
        [PlayerFitness, Fit_idx] = sort(PlayerFitness);
        Players = Players(Fit_idx, :);
        Xbest = Players(1, :);
        Fbest = PlayerFitness(1);

        for i = 1:TeamSize
            newPlayer = Players(i, :);
            if i < strongnum  % % High-intensity Training Strategy
                alpha = ceil(dim / 2 + ((i - 1) / (TeamSize - 1)) * (dim / 2));
                indices = randperm(dim, alpha);
                VariableAttributes = zeros(1, dim);
                VariableAttributes(indices) = 1;

                K = setdiff(1:TeamSize, i);  
                j = K(randi(length(K)));      
                K = setdiff(K, j);           
                g = K(randi(length(K))); 

                gamma = 0.1 + (0.8 * ((1 - (It / MaxGen)^0.5))); % gamma changes from 0.9 to 0.1 over iterations
                beta=i/strongnum;
                newPlayer = Xbest + (gamma * (Players(j, :) - Players(i, :))) + (beta * (Players(g, :) - Players(i, :)) .* VariableAttributes);

            else
                eta = kappa * exp(-lambda * i / TeamSize) * log(1 / rand);
                if eta > 1  % Fast Break Strategy
                    K = setdiff(1:TeamSize, i);  
                    j = K(randi(length(K)));      
                    K = setdiff(K, j);           
                    g = K(randi(length(K))); 
                    f = 2 - (It / MaxGen)^2;
                    alpha = ceil(dim / 2 + ((i - 1) / (TeamSize - 1)) * (dim / 2));
                    indices = randperm(dim, alpha);
                    VariableAttributes = zeros(1, dim);
                    VariableAttributes(indices) = 1;
                    newPlayer = Players(i, :) + (f * rand(1, dim) .* (Xbest - Players(i, :)) + (1 - (It / MaxGen)) * rand(1, dim) .* (Players(j, :) - Players(g, :))) .* VariableAttributes;          
                else  % Dynamic Positioning Strategy
                    P_rand = randi(TeamSize);
                    d_rand = randi(dim);
                    d_best = randi(dim);

                    R = lb + rand(1, dim) .* (ub - lb);

                    l_rand = (Players(P_rand, d_rand) - lb(d_rand)) / (ub(d_rand) - lb(d_rand));
                    L_rand = lb + l_rand * (ub - lb);
                    l_best = (Xbest(d_best) - lb(d_best)) / (ub(d_best) - lb(d_best));
                    L_best = lb + l_best * (ub - lb);

                    Q1 = L_rand + rand(1, dim) .* (Xbest - L_rand);
                    C1 = Q1 + randn * (Q1 - round(rand) * Players(i, :));% Random Position Strategy
                    for D = 1:dim     % Diagonal Position Strategy
                        if R(D) < L_best(D)
                            C2(D) = L_best(D) + rand * (ub(D) - L_best(D));
                        else
                            C2(D) = lb(D) + rand * (L_best(D) - lb(D));
                        end
                    end
                    
                    if fobj(C1) < fobj(C2)
                        newPlayer = C1;
                    else
                        newPlayer = C2;
                    end    
                end
            end
            
            newPlayer = ball_re_entry(newPlayer, Players(i, :), ub, lb);
            newPlayerFitness = fobj(newPlayer);
            if newPlayerFitness < PlayerFitness(i)
                PlayerFitness(i) = newPlayerFitness;
                Players(i, :) = newPlayer;
                if PlayerFitness(i) <= Fbest
                    Fbest = PlayerFitness(i);
                    Xbest = Players(i, :);
                end
            end
        end


        convergence_curve(It) = Fbest;
        disp(['In iteration ' num2str(It) ': Best solution = ' num2str(Fbest)]);
    end

 
end

   

