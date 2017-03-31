clear;

message = [1 0 0 1 1 1 0 1 0];
noise = normrnd(0,sqrt(1),length(message),1);

bitRate = 100000;
bitPeriod = 1/bitRate;
f1=bitRate*8;                           % carrier frequency for information as 1
f2=bitRate*2;                           % carrier frequency for information as 0

Aask= sqrt(2);  % Amplitude of ASK
Ag = 1;         % Amplitude of FSK and PSK (general)

ts=bitPeriod/100:bitPeriod/100:bitPeriod;   %time segment

% Vectors for signal and noisy signal
graphMessage=[];
graphNoise=[];
ASKsignal=[];
ASKnoise=[];
PSKsignal=[];
PSKnoise=[];
FSKsignal=[];
FSKnoise=[];

for i=1:length(message)
    y1 = message(i)*Aask*cos(2*pi*f1*ts);   % Create ASK cosine wave for time segment
    n=ones(1,100).*noise(i);                % Duplicate value for noise over the whole time segment for graphing
    if message(i)==1
        g=ones(1,100);          % Repeat 1s message for graphing
        y2=Ag*cos(2*pi*f2*ts);  % Create PSK cosine wave for time segment
        y3=Ag*cos(2*pi*f1*ts);  % Create FSK cosine wave for time segment
    else
        g=zeros(1,100);          % Repeat 0s message for graphing
        y2=-Ag*cos(2*pi*f2*ts); % Create PSK cosine wave for time segment
        y3=Ag*cos(2*pi*f2*ts);  % Create FSK cosine wave for time segment
    end
    % add time segment to vector
    graphMessage=[graphMessage g];
    graphNoise=[graphNoise n];
    ASKsignal=[ASKsignal y1];
    ASKnoise=[ASKnoise y1+n];
    PSKsignal=[PSKsignal y2];
    PSKnoise=[PSKnoise y2+n];
    FSKsignal=[FSKsignal y3];
    FSKnoise=[FSKnoise y3+n];
end

tm=bitPeriod/100:bitPeriod/100:100*length(message)*(bitPeriod/100); % Length of graphMessage and graphNoise
tg=bitPeriod/100:bitPeriod/100:bitPeriod*length(message);           % Length of signals


%plot each of the generated signals
subplot(4,2,1);
plot(tm,graphMessage,'Color','red','LineWidth',1);
ylabel('Amplitude');
xlabel('Time');
title('Original Message');

subplot (4,2,2);
plot (tm, graphNoise, 'Color', 'red', 'LineWidth',1);
ylabel('Amplitude');
xlabel('Time');
title('Noise (sigma^2 = 1)');

subplot(4,2,3);
plot(tg,ASKsignal,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -1.5 1.5]);
ylabel('Amplitude');
xlabel('Time');
title('ASK Representation');

subplot(4,2,4);
plot(tg,ASKnoise,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -3.5 3.5]);
ylabel('Amplitude');
xlabel('Time');
title('ASK With Noise');

subplot(4,2,5);
plot(tg,PSKsignal,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -1.5 1.5]);
ylabel('Amplitude');
xlabel('Time');
title('PSK Representation');

subplot(4,2,6);
plot(tg,PSKnoise,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -3.5 3.5]);
ylabel('Amplitude');
xlabel('Time');
title('PSK With Noise');

subplot(4,2,7);
plot(tg,FSKsignal,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -1.5 1.5]);
ylabel('Amplitude');
xlabel('Time');
title('FSK Representation');

subplot(4,2,8);
plot(tg,FSKnoise,'Color','blue','LineWidth',0.8);
axis([ 0 bitPeriod*length(message) -3.5 3.5]);
ylabel('Amplitude');
xlabel('Time');
title('FSK With Noise');