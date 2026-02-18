clc;
clear;
close all;
Problem_List = 1:6; 
Problem_Names = {
    'Tension/compression spring design problems', ...
    'Pressure vessel design problems', ...
    'Design problems of three-bar truss', ...
    'Design problems of welded beam', ...
    'Cantilever beam design problems', ...
    'Design problems of gear transmission'
};
nPop = 30;       
Max_iter = 100;  
Internal_Runs = 30;
algo_name = 'GE-SA ISCSO';
algo_func = @GE_SA_ISCSO;
Final_Summary = cell(length(Problem_List)+1, 3);
Final_Summary(1,:) = {'Problem Type', 'Problem Name', 'Best Fitness'};
for k = 1:length(Problem_List)
    type = Problem_List(k);
    prob_name = Problem_Names{type};
    rng(1); 
    [lb, ub, dim, fobj] = Engineering_Problems(type);
    fprintf('Processing Problem %d: %s (Dim: %d)\n', type, prob_name, dim);
    fprintf('Running %s (Scanning %d runs)... \n', algo_name, Internal_Runs);
    Global_Best_Score = inf; 
    Global_Best_X = [];
    try
        tic; 
        for run = 1:Internal_Runs
            [temp_score, temp_x, ~] = algo_func(nPop, Max_iter, lb, ub, dim, fobj);
            if type == 6 || type == 9 || type == 10 || type == 11
                temp_x = round(temp_x);
            end
            if type == 7
                temp_score = -temp_score; 
                if length(temp_x) >= 3
                    temp_x(3) = round(temp_x(3));
                end
            end
            if temp_score < Global_Best_Score
                Global_Best_Score = temp_score;
                Global_Best_X = temp_x;
            end
        end
        runtime = toc;
        fprintf('Done (Time: %.4fs) | Best Fitness: %.6e\n', runtime, Global_Best_Score);    
    catch ME
        fprintf('Error in Problem %d: %s\n', type, ME.message);
        Global_Best_Score = NaN;
        Global_Best_X = NaN(1, dim);
    end
    Final_Summary{k+1, 1} = type;
    Final_Summary{k+1, 2} = prob_name;
    Final_Summary{k+1, 3} = Global_Best_Score;
    format_num = @(x) format_helper(x);
    if isnan(Global_Best_Score)
        score_str = 'NaN';
        x_str_cmd = 'NaN';
    else
        score_str = format_num(Global_Best_Score);
        x_str_cmd = '[';
        for d = 1:length(Global_Best_X)
            x_str_cmd = [x_str_cmd, format_num(Global_Best_X(d))];
            if d < length(Global_Best_X), x_str_cmd = [x_str_cmd, ', ']; end
        end
        x_str_cmd = [x_str_cmd, ']'];
    end
    
    fprintf('   -> Solution: %s\n', x_str_cmd);
end
fprintf('%-5s | %-30s | %-15s\n', 'Type', 'Problem Name', 'Best value');
fprintf('------|--------------------------------|-----------------\n');
for k = 1:length(Problem_List)
    type = Final_Summary{k+1, 1};
    name = Final_Summary{k+1, 2};
    score = Final_Summary{k+1, 3};  
    if isnan(score)
        s_score = 'NaN';
    elseif abs(score) < 1e-4
        s_score = sprintf('%.4e', score);
    else
        s_score = sprintf('%.6f', score);
    end
    
    fprintf('%-5d | %-30s | %s\n', type, name, s_score);
end
function s = format_helper(val)
    if val == 0
        s = '0.0000';
        return;
    end
    if abs(val) < 1e-4
        s = sprintf('%.4e', val);
    else
        s = sprintf('%.6f', val);
    end
end