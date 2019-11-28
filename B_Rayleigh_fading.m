% 1b. Rayleigh fading channel
clear
clc
N = 100000; %number of symbol
Es_N0 = 0: 1: 30;
% generate transmistted signal QPSK
% 1 + i, 1 - i, -1 + i, -1 - i
Tx = (2 * (rand(1, N) > 0.5) - 1) + j * (2 * (rand(1, N) > 0.5) - 1); 
Tx_normal = Tx/sqrt(2); % normalize transmistted signal

n = (randn(1, N) + j * randn(1, N))/sqrt(2); % noise
h = (randn(1, N) + j * randn(1, N))/sqrt(2); % rayleigh fading channel

Rx_output = zeros(1, length(Es_N0));
P_s = zeros(1, length(Es_N0)); % probability of symbol error

for i = 1: length(Es_N0)
    Rx = h .* Tx_normal * (10^(Es_N0(i)/20)) + n; % received signal % y = hx + n
    Rx_rayleigh = Rx .* (conj(h) ./ abs(h));
    
    Rx_rayleigh_re = real(Rx_rayleigh);
    Rx_rayleigh_im = imag(Rx_rayleigh);
    
    Rx_output(find(Rx_rayleigh_re > 0 & Rx_rayleigh_im > 0)) = 1 + j;
    Rx_output(find(Rx_rayleigh_re > 0 & Rx_rayleigh_im < 0)) = 1 - j;
    Rx_output(find(Rx_rayleigh_re < 0 & Rx_rayleigh_im > 0)) = -1 + j;
    Rx_output(find(Rx_rayleigh_re < 0 & Rx_rayleigh_im < 0)) = -1 - j;
    
    count_error = size(find(Tx - Rx_output), 2);
    P_s(i) = count_error/N;
    
end

figure(2)
semilogy(Es_N0, P_s, '-y+');
grid on
xlabel('E_s/N_0(dB)')
ylabel('Probability of symbol error (%)')
hold off
legend('Rayleigh')
axis([1 30 10^-3 1])

