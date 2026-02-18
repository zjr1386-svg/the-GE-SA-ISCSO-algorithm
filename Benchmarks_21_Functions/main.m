clear 
close all
clc
addpath(genpath(pwd));
pop_size = 30;    
max_iter = 500;   
run_times = 30;   
F = 1:21;         
Best_Seeds = [5, 4, 1, 2, 1, 2, 1, 1, 1, 5, 2, 4, 1, 1, 1, 1, 2, 3, 1, 1, 5]; 
Final_Stats = [];
disp('Starting GE-SA ISCSO simulation ...');
disp('Please wait for the final table...');
for i = 1:length(F)
    func_num = F(i);
    [lower_bound, upper_bound, variables_no, fhd] = Get_Functions_details2(['F', num2str(func_num)]);
    current_seed = Best_Seeds(i);
    rng(current_seed);
    run_results = zeros(run_times, 1);
    for nrun = 1:run_times
        [final_fitness, ~, ~] =GE_SA_ISCSO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fhd);
        run_results(nrun) = final_fitness;
    end
    best_val = min(run_results);
    mean_val = mean(run_results);
    std_val  = std(run_results);
    Final_Stats = [Final_Stats; func_num, best_val, mean_val, std_val];
end

disp('                  GE-SA ISCSO Performance (F1-F21)');
fprintf('%-6s | %-15s | %-15s | %-15s\n', 'Func', 'Best', 'Mean', 'Std');
for i = 1:size(Final_Stats, 1)
    f_id = Final_Stats(i, 1);
    val_best = Final_Stats(i, 2);
    val_mean = Final_Stats(i, 3);
    val_std  = Final_Stats(i, 4);
    if val_best == 0, str_best = '0'; else, str_best = sprintf('%.4E', val_best); end
    if val_mean == 0, str_mean = '0'; else, str_mean = sprintf('%.4E', val_mean); end
    if val_std  == 0, str_std  = '0'; else, str_std  = sprintf('%.4E', val_std);  end
    
    fprintf('F%-5d | %-15s | %-15s | %-15s\n', f_id, str_best, str_mean, str_std);
end
rmpath(genpath(pwd));