clear all; close all

%% Sample
%B = [1 1 1; -1 0 2; 3 5 6];
%Bnew = [0 1 0; 1 0 1; -1 0 2];

%% Setup Polynomials
N = 11;
q = 32;
p = 3;
df = 4;
dg = 3;
dr = 3;

h = [-7, 3, 7, -4, 4, -3, 16, -2, 0, -7, -4];

correct_f = [-1, 1, -1, 0, 0, -1, 0, 0, 1, 1, 1];
correct_g = [0, 1, 0, 0, 0, 0, -1, 1, 0, -1, 1];

%Confidence
c = sqrt((2*pi*exp(1)*sqrt(2*df-1-1/N)*sqrt(2*dg))/(N*q))

%% Create Lattice Matrix
% Find Alpha
alpha = sqrt(2*dg)/sqrt(2*df-1);

% Create Matrix
A = alpha*eye(N);
Q = q*eye(N);
O = zeros(N,N);

H = zeros(N,N);
for i=1:N,
    H(i,:) = circshift(h,i-1,2);
end

B = [A H; O Q];

%% Find LLL Reduced Basis

Bnew = LLLReduction(B,1 );

%% Look For Private Keys