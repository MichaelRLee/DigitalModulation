clear;

message = [1 0 0 1 1 1 0 1 0];
noise = normrnd(0,sqrt(1),length(message),1);

bitRate = 100000;
bitPeriod = 1/bitRate;
f1=bitRate*8;                           % carrier frequency for information as 1
f2=bitRate*2;                           % carrier frequency for information as 0
noise2 = normrnd(0,sqrt(1),length(message),1);

Aask= sqrt(2);  % Amplitude of ASK
Ag = 1;         % Amplitude of FSK and PSK (general)

ts=bitPeriod/100:bitPeriod/100:bitPeriod;   %time segment

% Vectors for signal and noisy signal
graphMessage=[];
graphNoise=[];
graphNoise2=[];
ASKsignal=[];
ASKnoise=[];
PSKsignal=[];
PSKnoise=[];
FSKsignal=[];
FSKnoise=[];

for i=1:length(message)
    y1 = message(i)*Aask*cos(2*pi*f1*ts);   % Create ASK cosine wave for time segment
    n=ones(1,100).*noise(i);                % Duplicate value for noise over the whole time segment for graphing
    n2=ones(1,100).*noise2(i);
    if message(i)==1
        g=ones(1,100);          % Repeat 1s message for graphing
        y2=Ag*cos(2*pi*f2*ts);  % Create PSK cosine wave for time segment
        y3=Ag*cos(2*pi*f1*ts);  % Create FSK cosine wave for time segment
        
        % FSK demodulation for 1
        if noise(i)+Ag >= noise2(i)
            FSKnoise=[FSKnoise ones(1,100)];
        else
            FSKnoise=[FSKnoise zeros(1,100)];
        end
        
    else
        g=zeros(1,100);         % Repeat 0s message for graphing
        y2=-Ag*cos(2*pi*f2*ts); % Create PSK cosine wave for time segment
        y3=Ag*cos(2*pi*f2*ts);  % Create FSK cosine wave for time segment
        
        %FSK Demodulation for 0
        if noise2(i)+Ag >= noise(i)
            FSKnoise=[FSKnoise zeros(1,100)];
        else
            FSKnoise=[FSKnoise ones(1,100)];
        end
        
    end
    
    %ASK demodulation
    if message(i)*Aask+noise(i) >= Aask/2
        ASKnoise=[ASKnoise ones(1,100)];
    else
        ASKnoise = [ASKnoise zeros(1,100)];
    end
    
    %PSK demodulation
    if message(i)*2*Ag-Ag+noise(i) >= 0
        PSKnoise = [PSKnoise ones(1,100)];
    else
        PSKnoise = [PSKnoise zeros(1,100)];
    end

    
    % add time segment to vector
    graphMessage=[graphMessage g];
    graphNoise=[graphNoise n];
    graphNoise2=[graphNoise2 n2];
    ASKsignal=[ASKsignal y1];
    PSKsignal=[PSKsignal y2];
    FSKsignal=[FSKsignal y3];
end

tm=bitPeriod/100:bitPeriod/100:100*length(message)*(bitPeriod/100); % Length of graphMessage and graphNoise
tg=bitPeriod/100:bitPeriod/100:bitPeriod*length(message);           % Length of signals


%plot each of the generated signals
subplot(3,2,1);
plot(tm,graphMessage,'Color','red','LineWidth',1);
axis([ 0 bitPeriod*length(message) -0.5 1.5]);
ylabel('Amplitude');
title('Original Message');

subplot (5,2,2);
plot (tm, graphNoise, 'Color', 'red', 'LineWidth',1);
ylabel('Amplitude');
title('Noise (sigma^2 = 1)');

subplot (5,2,4);
plot (tm, graphNoise2, 'Color', 'red', 'LineWidth',1);
ylabel('Amplitude');
title('Other Noise (sigma^2 = 1)');

subplot(5,2,5);
plot(tg,ASKsignal,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -1.5 1.5]);
ylabel('Amplitude');
title('ASK Representation');

subplot(5,2,6);
plot(tg,ASKnoise,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -0.5 1.5]);
ylabel('Amplitude');
title('ASK With Noise');

subplot(5,2,7);
plot(tg,PSKsignal,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -1.5 1.5]);
ylabel('Amplitude');
title('PSK Representation');

subplot(5,2,8);
plot(tg,PSKnoise,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -0.5 1.5]);
ylabel('Amplitude');
title('PSK With Noise');

subplot(5,2,9);
plot(tg,FSKsignal,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -1.5 1.5]);
ylabel('Amplitude');
title('FSK Representation');

subplot(5,2,10);
plot(tg,FSKnoise,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -0.5 1.5]);
ylabel('Amplitude');
title('FSK With Noise');
