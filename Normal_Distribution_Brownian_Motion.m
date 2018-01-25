%% Intro to Derivative Securities Homework 2
% Created by Michael (Po-Hsuan) Lin
% Date: September 30, 2017
% Last updated: October 3, 2017

% Simple test: using normpdf and normrnd to generate normal distribution
% curve and random numbers from normal distribution
% x = -1:0.1:1;
% graph = normpdf(x,0,1);
% figure;
% plot(x,graph)
% for i = 0:10
%     test = normrnd(0,1);
% end

%% Homework 2 Question 2
% Generate an uniform distribution through the use of function rand()
uniform_sample = rand(50000,1); 

% Use the uniform rv created above to generate normal rv through the use of
% g(x) mentioned in question 1
% g(x) is the inverse function of normal distribution which is denoted as
% norminv in MATLAB
norm_sample = norminv(uniform_sample,0,0.1);

% Check the result in graph form
% Please refer to Graph 1 in appendix
% figure;
% histogram(norm_sample,1000);
% xlabel('x value');
% ylabel('frequency');
% title('Uniform to normal distribution');

% To find P[X>0.1]
count_0 = 0;
for i = 1:1:50000
    if norm_sample(i) > 0.1
        count_0 = count_0 + 1;
    end
end
prob = count_0 / 50000;

% Compare with the answer from directly using normcdf built in on MATLAB
prob_normcdf = 1 - normcdf(0.1,0,0.1);
% One of the sample run yields: 
% prob = 0.1591
% prob_normcdf = 0.1587
% prob and prob_normcdf are incredibly close; answer can be even more
% accurate if the amount of sample increases

% To find the expectation of X to the fourth power
fourth_power = norm_sample .^ 4;
expectation_fourth_power = sum(fourth_power) / 50000;
% Answer equals approx 3.00e-04

%% Homework 2 Question 3
% Generate Brownian Motion through brownian motion function, denoted as
% b_m.m

% Instantiation
w_t_next = 0; 
w_t = 0;
count_1 = 1;

% For X_t which is a normal distribution of mean 0 and variance 1, instead
% of using the generation method from the previous example, I decide to use
% normrnd to generate

% For each time difference, a new normal variable will be generated and
% inputs into the function below

% To create and record different paths, use matrix expansion
% By changing path_num, one can create different number of paths; for
% question 3, we are able to create 10, 100 and 1000 paths

% For 10,000 paths, it takes too long to generate the graph; the graph is
% also not significant with so many paths overlapping
for path_num = 1:10000
    count_1 = 1;
    for delta_t = 0:0.01:1
        t = 0.01; 
        X_t = normrnd(0,1);
        if count_1 == 1
            brownian_motion(1,count_1,path_num) = 0;
        else
            w_t_next = b_m(w_t,X_t,t);
            brownian_motion(1,count_1,path_num) = w_t_next;
        end
        count_1 = count_1 + 1;
        w_t = w_t_next;
        w_t_next = 0;
    end
    % Graphs with different path counts can be found in the appendix,
    % labelled as graph 2, 3 and 4
    % To increase calculation speed, graph part is commented out
    % x_var = 0:0.01:1;
    % hold on;
    % plot(x_var,brownian_motion(1,:,path_num));
    % xlabel('Time');
    % ylabel('Price');
    % title('Brownian Motion With 100 Paths');
end
% hold off;

% The next step of this question is to find the expectation at t = 1
sum_of_all_paths = sum(brownian_motion(1,101,:));
expectation_of_all_paths = sum_of_all_paths / path_num; 

%% Answers For Question 3 From One Trial: 
% 10 Paths: 
% Sum_of_all_paths = -1.3226
% Expectation_of_all_paths = -0.1323

% 100 Paths: 
% Sum_of_all_paths = 8.7221
% Expectation_of_all_paths = 0.0872

% 1000 Paths: 
% Sum_of_all_paths = 9.7265
% Expectation_of_all_paths = 0.0097

% 5000 Paths: 
% Sum_of_all_paths = 83.3473
% Expectation_of_all_paths = 0.0167

% 10,000 Paths: 
% Sum_of_all_paths = 9.5160
% Expectation_of_all_paths = 9.5160e-04

% As we can see from the data, when the number of path increases, the
% expectation of the brownian motion at t = 1 is close to 0
% When it is close to 10,000 paths, the expectation goes to e-04, therefore
% this proves that brownian motion has the expectation of 0

%% Homework 3 Question 4
% Generate option stock price using previously created brownian motions

% Instantiation: assuming time equals to 252 trading days since 12 months
% implies a year
So = 90;
r = 0.02;
sigma = 0.2;
K = 100;
T = 252;
% count_2 = 1;
% op_w_t = 0;
% op_w_t_next = 0;

% Use a for loop to generate option values with 10,000 paths brownian
% motion
% for op_path_num = 1:10
%     count_2 = 1;
%     for k = 0:0.01:T
%         t = 0.01; 
%         op_X_t = normrnd(0,1);
%         if count_2 == 1
%             op_brownian_motion(1,count_2,op_path_num) = 0;
%         else
%             op_w_t_next = b_m(op_w_t,op_X_t,t);
%             op_brownian_motion(1,count_2,op_path_num) = op_w_t_next;
%         end
%         count_2 = count_2 + 1;
%         op_w_t = op_w_t_next;
%         op_w_t_next = 0;
%     end
    % The extended brownian motion can be seen in appendix as graph 5
    % Graphs are again commented out for the sake of faster computation
    % op_x_var = 0:0.01:252;
    % hold on;
    % plot(op_x_var,op_brownian_motion(1,:,op_path_num));
    % xlabel('Time');
    % ylabel('Price');
    % title('Extended Brownian Motion With 10 Paths');
% end
% hold off;

% To calculate option price, call on the function option_pricing, written
% in the mfunction file option_pricing.m

% After some experiments, I believe brownian motion here shouldn't be
% extended to 252 time periods, instead it should just be the original
% brownian motion
% Following the same concept as Black Scholes Equation, the t used in the
% equation is actually tau which is the ratio of days to expiration to the
% number of trading days in a year; in this case, both values are 252,
% hence tau equals to 1
% This gives the original Brownian motion
for m = 1:10000
    stock_price(m) = option_pricing(So,r,sigma,T,brownian_motion(1,101,m));
    if stock_price(m) > 100
        stock_price(m) = stock_price(m) - 100;
    else
        stock_price(m) = 0;
    end
end

% Calculate the expectation
option_pricing = sum(stock_price) / m;
% Option calculated is approximately 4.234 according to one trial





