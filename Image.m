clc;
clear all;
close all;

% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'eight.tif';
fullFileName = fullfile(folder, baseFileName);
fullFileName = baseFileName;

% Convert the hexadecimal matrix to binary vector for processing
image = imread(fullFileName);
imageBin = dec2bin(image) - '0'; % subtract 0 to convert to int
signal = reshape(imageBin, [], 1); % convert matrix to vector
bits = length(signal);
variance = 0.25

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

% Thresholds
ASKthreshold = A2/2;% ASK can have amplitude 0 or A2, so threshold is half A2
PSKthreshold = 0;   % PSK can have the amplitude A1 or -A1 (wave shifted 180 degrees), so threshold is 0
                    % It should be noted that FSK doesn't have a threshold and instead uses a comparison

ASKdemod = zeros(length(ASKsignal),1);
PSKdemod = zeros(length(PSKsignal),1);
FSKdemod = zeros(length(FSKsignal),1);

noise = normrnd(0,sqrt(variance),bits,1); % Generate Noise
% Adds noise to signal
PSKy = noise+PSKsignal;
ASKy = noise+ASKsignal;
noise1 = normrnd(0,sqrt(variance,bits,1);


 for j = 1:bits
    % ASK demodulation
    if (ASKy(j) < ASKthreshold)
        ASKdemod(j) = 0;
    else
        ASKdemod(j) = 1;
    end
    
    % PSK demodulation
    if (PSKy(j) < PSKthreshold)
        PSKdemod(j) = 0;    % treat -1 as 0 for image matrix processing
    else
        PSKdemod(j) = 1;
    end
        
    % FSK demodulation
    if FSKsignal == 0           % If recived signal should be a 0
        if A1+noise(j) > noise1 % Check if the value from the 0 LPF is larger than the value from the 1 LPF
            FSKdemod(j) = 0;
        else
            FSKdemod(j) = 1;
        end
    else                        % Opposite of previous
        if A1+noise1(j) > noise
            FSKdemod(j) = 1;
        else
            FSKdemod(j) = 0;
        end
    end
   
 end

ASKstr = num2str(ASKdemod);
ASKmat = reshape(ASKstr, size(imageBin, 1), size(imageBin, 2));
ASKdec = bin2dec(ASKmat);
ASKimg = reshape(ASKdec, size(image, 1), size(image, 2));

PSKstr = num2str(PSKdemod);
PSKmat = reshape(PSKstr, size(imageBin, 1), size(imageBin, 2));
PSKdec = bin2dec(PSKmat);
PSKimg = reshape(PSKdec, size(image, 1), size(image, 2));

FSKstr = num2str(FSKdemod);
FSKmat = reshape(FSKstr, size(imageBin, 1), size(imageBin, 2));
FSKdec = bin2dec(FSKmat);
FSKimg = reshape(FSKdec, size(image, 1), size(image, 2));

% og image
% imshow(image);

% ask image
imshow(ASKimg); % need both of these
imagesc(ASKimg);
