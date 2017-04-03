clc;
clear all;
close all;

bits = 10000;
variance=0.25:0.01:16;          % sigma^2 value for normal curve
signal = randi([0,1], bits, 1); % generates random 0s and 1s
ASKsignal = signal;
PSKsignal = signal;
FSKsignal = signal;

% Amplitudes
A1 = 1;         % Amplitude for PSK and FSK
A2 = sqrt(2)*A1;% Amplitude for ASK
                % Amplitude is different for ASK as it only is transmitting half the time (approx.) since the amplitude for a 0 is 0
                % To create a fair comparison, each modulation uses equivalent power (P=A^2/2)

PSKsignal = PSKsignal*(2*A1)-A1;    % Shift 0 values in PSK wave by 180deg
ASKsignal = ASKsignal*A2;           % Adjusts the ASK wave's amplitude

% Bit error rates
ASK_BER = zeros(length(variance),1);
PSK_BER = zeros(length(variance),1);
FSK_BER = zeros(length(variance),1);

% Thresholds
ASKthreshold = A2/2;% ASK can have amplitude 0 or A2, so threshold is half A2
PSKthreshold = 0;   % PSK can have the amplitude A1 or -A1 (wave shifted 180 degrees), so threshold is 0
                    % It should be noted that FSK doesn't have a threshold and instead uses a comparison

% Theoretical BER
ASK_theo = zeros(length(variance),1);
PSK_theo = zeros(length(variance),1);
FSK_theo = zeros(length(variance),1);

for i = 1:length(variance)
    noise = normrnd(0,sqrt(variance(i)),bits,1); % Generate Noise
    % Adds noise to signal
    PSKy = noise+PSKsignal;
    ASKy = noise+ASKsignal;

    % The recieved FSK signal goes through two Low-Pass Filter, each adding their own noise to the signal
    FSKy0 = noise;
    FSKy1 = normrnd(A1,sqrt(variance(i)),bits,1);
    
    for j = 1:bits
        % Count the number of incorrect bits by comparing them to the ASK threshold
        if (ASKy(j) > ASKthreshold && signal(j) ~= 1)||(ASKy(j) <= ASKthreshold && signal(j) ~= 0)
            ASK_BER(i) = ASK_BER(i)+1;
        end
        % Count the number of incorrect bits by comparing them to the FSK threshold
        if (PSKy(j) > PSKthreshold && signal(j) ~= 1)||(PSKy(j) <= PSKthreshold && signal(j) ~= 0)
            PSK_BER(i) = PSK_BER(i)+1;
        end
        % We compare the values obtained by the low pass filters.  The way that this works can be found at the bottom of the file
        if FSKy0(j) > (FSKy1(j))
            FSK_BER(i) = FSK_BER(i)+1;
        end
    end
    
    % Calculate Theoretical BERs
    ASK_theo(i) = normcdf(A2/2,A2,sqrt(variance(i)));
    PSK_theo(i) = normcdf(0,A1,sqrt(variance(i)));
    FSK_theo(i) = normcdf((sqrt(2)*A1)/2,sqrt(2)*A1,sqrt(variance(i)));
    
    % Convert number of errors to BER
    ASK_BER(i) = ASK_BER(i)/bits;
    PSK_BER(i) = PSK_BER(i)/bits;
    FSK_BER(i) = FSK_BER(i)/bits;
end

% Generate Graph
plot(variance,ASK_BER,'m','linewidth',0.5),grid on,hold on;
plot(variance,PSK_BER,'g','linewidth',0.5);
plot(variance,FSK_BER,'c','linewidth',0.5);
plot(variance,ASK_theo,'b','linewidth',2);
plot(variance,PSK_theo,'r','linewidth',1);
plot(variance,FSK_theo,'y:','linewidth',1);
title('Bit Error Rate VS Variance for Digital Modulations Methods');
xlabel('sigma^2');
ylabel('BER');
legend('ASK BER','PSK BER','FSK BER', 'Theoretical ASK BER', 'Theoretical PSK BER', 'Theoretical FSK BER')






% FSK
%
% The code for FSK looks something like:
%
%   if signal == 0
%         if Amplitude+noise1 > noise2
%             return 0;
%        else
%             return 1;
%       end
%   else
%         if Amplitude+noise2 > noise1
%             return 1;
%       else
%             return 0;
%       end
%   end
%
% It can be observed that we have an incorrect bit only when the amplitude plus some noise is less than some other random noise.  Thus, the lines :

%   if FSKy0(j) > (FSKy1(j))
%         FSK_BER(i) = FSK_BER(i)+1;
%   end
