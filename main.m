clc;
clear;
close all;

cec = 2017; % CEC 2017
DIM = 50; % Dimension
pop = 100; % Population size
maxGen = 1000; % Maximum iterations

% Specify the function to run (for example, F5)
F = 5; % Change this to the function number you want to run


% Run BTOA
[~, ~, curve_BTOA] = BTOA(F, pop, maxGen, DIM, cec); % Run BTOA


% Plot convergence curve
figure;
semilogy(curve_BTOA, 'k', 'LineWidth', 3); 
title(['F' num2str(F) ' Convergence Curve']); 
xlabel('Iteration'); 
ylabel('Best Score'); 
grid on; 

