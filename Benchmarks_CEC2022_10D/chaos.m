function result = chaos(index, N, dim)
switch index
    case 1
        %Bernoulli mapping
        lammda = 0.4;
        Bernoulli=rand(N,dim);
        for i=1:N
            for j=2:dim
                if Bernoulli(i,j-1) <  1-lammda
                    Bernoulli(i,j)= Bernoulli(i,j-1)/(1-lammda);
                else
                    Bernoulli(i,j)= (Bernoulli(i,j-1)-1+lammda)/lammda;
                end
            end
        end
        result = Bernoulli; 
end
end


