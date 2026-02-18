function [lb,ub,dim,fobj] = Engineering_Problems(type)
switch type
    case 1 % Tension/compression spring design problem
        fobj = @spring;       
        lb = [0.05 0.25  2];   
        ub = [2    1.3   15];   
        dim = length(lb);     
    case 2 % Pressure vessel design problem
        fobj = @pvd;
        lb =[0 0 10 10];
        ub = [99 99 200 200];
        dim = length(lb);
    case 3 % Three-bar truss design problem
        fobj = @three_bar;
        lb = [0 0];
        ub = [1 1];
        dim = length(lb);
    case 4 % Welded beam design problem
        fobj = @welded_beam;
        lb = [0.1 0.1 0.1 0.1];
        ub = [2 10 10 2];
        dim = length(lb);
   case 5 % Cantilever beam design problem
        fobj = @cantilever_beam;
        lb = [0.01,0.01,0.01,0.01,0.01];
        ub= [100,100,100,100,100];
        dim = length(lb);
    case 6 % Gear train design problem
        fobj = @gear_train;
        lb = [12 12 12 12];
        ub= [60 60 60 60];
        dim = length(lb);
end
end
function fitness = spring(x)
    x1 = x(1);
    x2 = x(2);
    x3 = x(3); 
    f = (x3+2)*x2*(x1^2); 
    penalty_factor = 10e100; 
    g1 = 1-((x2^3)*x3)/(71785*(x1^4));
    g2 = (4*(x2^2)-x1*x2)/(12566*(x2*(x1^3)-(x1^4))) + 1/(5108*(x1^2))-1;
    g3 = 1-(140.45*x1)/((x2^2)*x3);
    g4 = ((x1+x2)/1.5)-1;
    penalty_1 = penalty_factor*(max(0,g1))^2; 
    penalty_2 = penalty_factor*(max(0,g2))^2; 
    penalty_3 = penalty_factor*(max(0,g3))^2; 
    penalty_4 = penalty_factor*(max(0,g4))^2; 
    fitness = f + penalty_1 + penalty_2 + penalty_3 + penalty_4;
end
function fitness = pvd(x)
    x1 = x(1); x2 = x(2); x3 = x(3); x4 = x(4);
    f = 0.6224*x1*x3*x4 + 1.7781*x2*x3^2 + 3.1661*x1^2*x4 + 19.84*x1^2*x3;
    penalty_factor = 10e100; 
    g1 = -x1+0.0193*x3;
    g2 = -x2+0.00954*x3;
    g3 = -pi*x3^2*x4 - (4/3)*pi*x3^3 + 1296000;
    g4 = x4 - 240;
    penalty_1 = penalty_factor*(max(0,g1))^2;
    penalty_2 = penalty_factor*(max(0,g2))^2;
    penalty_3 = penalty_factor*(max(0,g3))^2;
    penalty_4 = penalty_factor*(max(0,g4))^2;   
    fitness = f + penalty_1 + penalty_2 + penalty_3 + penalty_4;
end
function fitness = three_bar(x)
    l = 100; P = 2; q = 2;
    x1 = x(1);
    x2 = x(2);
    f = l*(2*sqrt(2)*x1+x2);
    penalty_factor = 10e100;
    g1 = P*(sqrt(2)*x1+x2)/(sqrt(2)*x1^2+2*x1*x2)-q;
    g2 = P*(x2)/(sqrt(2)*x1^2+2*x1*x2)-q;
    g3 = P/(sqrt(2)*x2+x1)-q;
    penalty_g1 = penalty_factor*(max(0,g1))^2;
    penalty_g2 = penalty_factor*(max(0,g2))^2;
    penalty_g3 = penalty_factor*(max(0,g3))^2;
    fitness = f + penalty_g1 + penalty_g2 + penalty_g3;
end
function fitness = welded_beam(x)
    P = 6000; L=14; E=30e6; G = 12e6;
    tmax=13600; sigma_max=30000; deta_max=0.25;
    x1 = x(1); x2 = x(2); x3 = x(3); x4 = x(4);
    M = P*(L+0.5*x2);
    r1 = (x2^2)/4;
    r2 = ((x1+x3)/2)^2;
    R = (r1+r2)^0.5;
    j1 = sqrt(2)*x1*x2;
    j2 = (x2^2)/12;
    j3 = ((x1+x3)/2)^2;
    J = 2*(j1*(j2+j3));
    sigma_x = 6*P*L/(x4*x3^2);
    deta_x = 4*P*L^3/((E*x4)*(x3^3));
    p1 = (4.013*E*((x3^2)*(x4^6)/36)^0.5)/(L^2);
    p2 = (x3/(2*L))*(E/(4*G))^0.5;
    Pc = p1*(1-p2);
    t_1 = P/(sqrt(2*x1*x2));
    t_2 = M*R/J;
    t = ((t_1)^2 + 2*t_1*t_2*(x2/(2*R))+(t_2)^2)^0.5;
    f = 1.10471*(x1^2)*x2+0.04811*x3*x4*(14+x2);
    penalty_factor = 10e100;
    g1 = t - tmax;
    g2 = sigma_x - sigma_max;
    g3 = deta_x - deta_max;
    g4 = x1 - x4;
    g5 = P - Pc;
    g6 = 0.125 - x1;
    g7 = 1.10471*(x1^2)*x2+0.04811*x3*x4*(14+x2) - 5;
    penalty_g1 = penalty_factor*(max(0,g1))^2;
    penalty_g2 = penalty_factor*(max(0,g2))^2;
    penalty_g3 = penalty_factor*(max(0,g3))^2;
    penalty_g4 = penalty_factor*(max(0,g4))^2;
    penalty_g5 = penalty_factor*(max(0,g5))^2;
    penalty_g6 = penalty_factor*(max(0,g6))^2;
    penalty_g7 = penalty_factor*(max(0,g7))^2;
    fitness = f + penalty_g1 + penalty_g2 + penalty_g3 + penalty_g4 + penalty_g5 + penalty_g6 + penalty_g7;
end
function fitness = cantilever_beam(x)
    penalty_factor = 10e100; 
    g(1) = 61/x(1)^3 + 37/x(2)^3 + 19/x(3)^3 + 7/x(4)^3 + 1/x(5)^3 - 1;
    penalty = penalty_factor * sum(g(g>0).^2);
    fitness = 0.0624*sum(x) + penalty;
end
function fitness = gear_train(x)
    x = round(x); 
    fitness = (1/6.931 - (x(2)*x(3)/(x(1)*x(4))))^2;
end