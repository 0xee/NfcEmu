clear all;
close all;

load scope_2.csv

sc = scope_2;

t = sc(:,1);
d = sc(:,2);


plot(t,d,'x-');