# the-GE-SA-ISCSO-algorithm
This code repository contains the source code of the GE-SA ISCSO algorithm and its applications in 21 benchmark test functions, the CEC2022 test set function, engineering design optimization problems, and photovoltaic power prediction.

## 1. Operating environment
It is recommended to use MATLAB R2023b or a later version.

## 2. 21 Benchmark test Functions
* **Run Scripts:** `Benchmarks_21_Functions/main.m`.
* **Output:** Best, Mean and Std.

## 3. CEC2022 Test Set Function
This section includes the CEC2022 test set function of 10 dimensions and 20 dimensions.

* **Run Scripts:**
    * **10D:** `Benchmarks_CEC2022_10D/main_cec2022.m`
    * **20D:** `Benchmarks_CEC2022_20D/main_cec2022.m`
* **Output:** Best, Mean and Std.

## 4. Engineering Design Optimization
This section evaluates the proposed algorithm on six classical constrained engineering design problems.

* **Run Scripts:** `Engineering optimization problems/main_engineering.m`.
* **Output:** the optimal design variables and the optimal value.

## 5. Photovoltaic Power Prediction
The hyperparameters of the LSTM neural network are optimized using the GE-SA ISCSO algorithm, and the model’s predictive performance is rigorously evaluated under rain conditions.

* **Run Scripts:** `Photovoltaic power prediction/main_pv_lstm.m`.
* **Output:** six error evaluation indexes are reported: MAE, MSE, RMSE, NSE, MAPE, and RRMSE.
* **Results:** Convergence curves, predicted values, and actual values will be saved to `GE-SA ISCSO-LSTM.mat`.
