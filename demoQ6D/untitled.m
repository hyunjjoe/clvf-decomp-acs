close all
clear 
clc
%% 1. Take maximum from all of the decomposed CLVFs
data1 = importdata("data_subsys.mat");
g1 = importdata("g_subsys.mat");

visSetIm(g1,data1,'red',0.25)