function B = LLLReduction(B, delta)
    %% Initialize
    n = size(B,1);
    Bstar = GramSchmidt(B);
    done = 0;
    
    while done ~= 1,
        %% Gauss Reduction
        for i=2:n,
            for k=(i-1):-1:1,
                mu = round(ComputeMu(B, Bstar, i, k));
                B(i,:) = B(i,:)-mu*B(k,:);
            end
        end

        %% Swapping
        done = 1;
        
        for i=1:(n-1),
            mu = ComputeMu(B, Bstar, i+1, i);
            temp1 = (Bstar(i+1,:)+mu*Bstar(i,:));
            temp2 = Bstar(i,:);

            compare1 = temp1*temp1';
            compare2 = delta*temp2*temp2';

            if compare2 > compare1,
                temp = B(i+1,:);
                B(i+1,:) = B(i,:);
                B(i,:) = temp;
            end
        end
    end
            
function Bstar = GramSchmidt(B)
    %% Setup
    n = size(B,1);
    Bstar = zeros(size(B));
    Bstar(1,:) = B(1,:);
    
    %% Algorithm
    for i=2:n,
        temp_sum = zeros(1,n);
        for j =1:(i-1),
            mu = ComputeMu(B, Bstar, i, j);
            temp_sum = temp_sum + mu*Bstar(j,:);
        end
        Bstar(i,:) = B(i,:) - temp_sum;
    end

function mu = ComputeMu(B, Bstar, i, j)
    mu = (B(i,:)*Bstar(j,:)') / (Bstar(j,:)*Bstar(j,:)');