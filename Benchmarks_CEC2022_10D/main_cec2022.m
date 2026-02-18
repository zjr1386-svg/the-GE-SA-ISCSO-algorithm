clear 
close all
clc
addpath(genpath(pwd));
pop_size = 30;      
max_iter = 500;     
run_times = 30;     
variables_no = 10;  
F = [ 1 2 3 4 5 6 7 8 9 10 11 12 ]; 
Best_Seeds = [6,6,5,8,6,7 ,9,3,2,2,6,1];  
Final_Report = []; 
for i = 1:length(F)
    func_num = F(i);
    [lower_bound, upper_bound, variables_no, fobj] = Get_Functions_cec2022(func_num, variables_no);
    current_seed = Best_Seeds(i);
    rng(current_seed); 
    current_run_results = zeros(run_times, 1);
    for nrun = 1:run_times
        [final_fitness, ~, ~] = GE_SA_ISCSO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj);
        current_run_results(nrun) = final_fitness;
    end
    best_val = min(current_run_results);
    mean_val = mean(current_run_results);
    std_val  = std(current_run_results);
    Final_Report = [Final_Report; func_num, best_val, mean_val, std_val];
end
fprintf('%-6s | %-15s | %-15s | %-15s\n', 'Func', 'Best', 'Mean', 'Std');
disp('-------|-----------------|-----------------|-----------------');

for i = 1:size(Final_Report, 1)
    f_num = Final_Report(i, 1);
    val_best = Final_Report(i, 2);
    val_mean = Final_Report(i, 3);
    val_std  = Final_Report(i, 4);
    str_best = sprintf('%.4f', val_best);
    str_mean = sprintf('%.4f', val_mean);
    str_std  = sprintf('%.4f', val_std);
    fprintf('F%-5d | %-15s | %-15s | %-15s\n', f_num, str_best, str_mean, str_std);
end