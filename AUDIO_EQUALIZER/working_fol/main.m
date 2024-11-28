% Close all figures, clear all variables and the command window
close all;
clear all;
clc;

% Ask the user to select the audio signal file
audioFile = uigetfile;
[Signal, sampleRate] = audioread(audioFile); % Read the signal
fprintf('Audio Sample Rate: %d\n', sampleRate);
gain = []; % Array to store the gain values for each frequency band
titles = {'170', '170-310', '310-600', '600-1000', '1000-3000', '3000-6000', '6000-12000', '12000-14000', '14000-20000'};

% Ask the user to enter the gain values for each frequency band
for i = 1:9
    str = sprintf('Please enter the gain (in dB) for the frequency band (%s)Hz: ', titles{i});
    gain(i) = str2double(input(str, 's'));

    while (isnan(gain(i)))% Check if the input is a number
        str = sprintf('Error! Please enter the gain (in dB) for the frequency band (%s)Hz: ', titles{i});
        gain(i) = str2double(input(str, 's'));
    end

    gain(i) = db2mag(gain(i)); % Convert the gain from dB to magnitude
end

% Ask the user to enter the desired output sample rate
newFs = str2double(input('\nPlease enter the desired output sample rate (must be in the range 80-1000000): ', 's'));

% Check if the input is a number and if it is in the range 80-1000000
while (newFs == 0 || newFs <= 80 || newFs >= 1000000 || isnan(newFs))
    newFs = str2double(input('Invalid input! Please enter the desired output sample rate: ', 's'));
end

% Ask the user to select the type of filter
filterType = str2double(input('\nPlease enter the type of filter (1. FIR / 2. IIR): ', 's'));

% Check if the input is a number and if it is 1 or 2
while ((filterType ~= 1 && filterType ~= 2) || isnan(filterType))
    filterType = str2double(input('Invalid input! Please enter the type of filter (1. FIR / 2. IIR): ', 's'));
end

tempFs = 48000; % Temporary sample rate greater than 2*Fm
resampledSignal = resample(Signal, tempFs, sampleRate); % Resample the signal to the temporary sample rate
Fs = tempFs; % Set the sample rate to the temporary sample rate

% Calculate the normalized frequencies for each frequency band
Fn = Fs / 2; % Nyquist frequency is half of the sample rate
wn1 = 170 / Fn;
wn2 = [170 310] / Fn;
wn3 = [310 600] / Fn;
wn4 = [600 1000] / Fn;
wn5 = [1000 3000] / Fn;
wn6 = [3000 6000] / Fn;
wn7 = [6000 12000] / Fn;
wn8 = [12000 14000] / Fn;
wn9 = [14000 20000] / Fn;

% Initialize the output signal and the output signal gain
outputSignal = 0;
outputSignalGain = 0;

order_fir = 63;
order_iir = 63;

num_hex_24bit_1 = 0;
num_hex_24bit_2 = 0;
num_hex_24bit_3 = 0;
num_hex_24bit_4 = 0;
num_hex_24bit_5 = 0;
num_hex_24bit_6 = 0;
num_hex_24bit_7 = 0;
num_hex_24bit_8 = 0;
num_hex_24bit_9 = 0;

% num_scaled_24bit = round(b * 2^23);

if (filterType == 1)% FIR filter ~ Finitie Impulse Respone filter
    % order_fir = 100; % Set the order to 100

    for i = 1:9

        % Calculate the filter coefficients for each frequency band
        if (i == 1)
            num = fir1(order_fir, wn1, 'low');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_1 = dec2hex(num_scaled_24bit);
        elseif (i == 2)
            num = fir1(order_fir, wn2, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_2 = dec2hex(num_scaled_24bit);
        elseif (i == 3)
            num = fir1(order_fir, wn3, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_3 = dec2hex(num_scaled_24bit);
        elseif (i == 4)
            num = fir1(order_fir, wn4, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_4 = dec2hex(num_scaled_24bit);
        elseif (i == 5)
            num = fir1(order_fir, wn5, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_5 = dec2hex(num_scaled_24bit);
        elseif (i == 6)
            num = fir1(order_fir, wn6, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_6 = dec2hex(num_scaled_24bit);
        elseif (i == 7)
            num = fir1(order_fir, wn7, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_7 = dec2hex(num_scaled_24bit);
        elseif (i == 8)
            num = fir1(order_fir, wn8, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_8 = dec2hex(num_scaled_24bit);
        else
            num = fir1(order_fir, wn9, 'bandpass');
            num_scaled_24bit = round(num * 2^23);
            num_hex_24bit_9 = dec2hex(num_scaled_24bit);
        end

        den = 1; % Set the denominator to 1
        filteredOutputSignal = filter(num, 1, resampledSignal); % Filter the resampled signal
        outputSignal = outputSignal + filteredOutputSignal; % Add the filtered signal to the output signal
        outputSignalGain = outputSignalGain + gain(i) * filteredOutputSignal; % Add the filtered signal multiplied by the gain to the output signal gain

        % Plot the magnitude and phase, impulse response, step response, zero-pole plot, filtered input in time domain and filtered input in frequency domain
        figure('units', 'normalized', 'outerposition', [0 0 1 1]);
        freqz(num, den);
        title(sprintf('(FIR) Magnitude and Phase for (%s)Hz', titles{i}));
        figure('units', 'normalized', 'outerposition', [0 0 1 1]);

        [h, t] = impz(num, den);
        subplot(2, 3, 1); stem(t, h);
        title(sprintf('(FIR) Impulse Response for (%s)Hz', titles{i}));

        [s, t] = stepz(num, den);
        subplot(2, 3, 2); stem(t, s);
        title(sprintf('(FIR) Step response for (%s)Hz', titles{i}));

        fprintf('\n(FIR) Order for (%s)Hz = %d\n', titles{i}, order_fir);
        TF = tf(num, den);
        [zero1, gains] = zero(TF);
        fprintf('(FIR) Gain for (%s)Hz = %d\n\n', titles{i}, gains);
        t = linspace(0, length(filteredOutputSignal) / Fs, length(filteredOutputSignal));
        f = linspace(-Fs / 2, Fs / 2, length(filteredOutputSignal));
        subplot(2, 3, 3); zplane(roots(num), roots(den));
        title(sprintf('(FIR) Zero-Pole plot (%s)Hz', titles{i}));
        subplot(2, 3, 4); plot(t, filteredOutputSignal);
        title(sprintf('(FIR) Filtered input in Time Domain for (%s)Hz', titles{i}));
        subplot(2, 3, 5); plot(f, abs(fftshift(fft(filteredOutputSignal))));
        title(sprintf('(FIR) Filtered input in Freq Domain for (%s)Hz', titles{i}));

        disp('FIR Filter Coefficients 1 in 24-bit Hex:');
        disp(num_hex_24bit_1);

        disp('FIR Filter Coefficients 2 in 24-bit Hex:');
        disp(num_hex_24bit_2);

        disp('FIR Filter Coefficients 3 in 24-bit Hex:');
        disp(num_hex_24bit_3);

        disp('FIR Filter Coefficients 4 in 24-bit Hex:');
        disp(num_hex_24bit_4);

        disp('FIR Filter Coefficients 5 in 24-bit Hex:');
        disp(num_hex_24bit_5);

        disp('FIR Filter Coefficients 6 in 24-bit Hex:');
        disp(num_hex_24bit_6);

        disp('FIR Filter Coefficients 7 in 24-bit Hex:');
        disp(num_hex_24bit_7);

        disp('FIR Filter Coefficients 8 in 24-bit Hex:');
        disp(num_hex_24bit_8);

        disp('FIR Filter Coefficients 9 in 24-bit Hex:');
        disp(num_hex_24bit_9);

    end

else % IIR filter ~ Infinite Impulse Respone filter

    for i = 1:9

        % Calculate the filter coefficients for each frequency band
        if (i == 1)
            [num, den] = butter(order_iir, wn1, 'low');
            [z, p, k] = butter(order_iir, wn1, 'low');
        elseif (i == 2)
            [num, den] = butter(order_iir, wn2, 'bandpass');
            [z, p, k] = butter(order_iir, wn2, 'bandpass');
        elseif (i == 3)
            [num, den] = butter(order_iir, wn3, 'bandpass');
            [z, p, k] = butter(order_iir, wn3, 'bandpass');
        elseif (i == 4)
            [num, den] = butter(order_iir, wn4, 'bandpass');
            [z, p, k] = butter(order_iir, wn4, 'bandpass');
        elseif (i == 5)
            [num, den] = butter(order_iir, wn5, 'bandpass');
            [z, p, k] = butter(order_iir, wn5, 'bandpass');
        elseif (i == 6)
            [num, den] = butter(order_iir, wn6, 'bandpass');
            [z, p, k] = butter(order_iir, wn6, 'bandpass');
        elseif (i == 7)
            [num, den] = butter(order_iir, wn7, 'bandpass');
            [z, p, k] = butter(order_iir, wn7, 'bandpass');
        elseif (i == 8)
            [num, den] = butter(order_iir, wn8, 'bandpass');
            [z, p, k] = butter(order_iir, wn8, 'bandpass');
        else
            [num, den] = butter(order_iir, wn9, 'bandpass');
            [z, p, k] = butter(order_iir, wn9, 'bandpass');
        end

        filteredOutputSignal = filter(num, den, resampledSignal); % Filter the resampled signal
        outputSignal = outputSignal + filteredOutputSignal; % Add the filtered signal to the output signal
        outputSignalGain = outputSignalGain + gain(i) * filteredOutputSignal; % Add the filtered signal multiplied by the gain to the output signal gain

        % Plot the magnitude and phase, impulse response, step response, zero-pole plot, filtered input in time domain and filtered input in frequency domain
        figure('units', 'normalized', 'outerposition', [0 0 1 1]);
        freqz(num, den);
        title(sprintf('(IIR) Magnitude and Phase for (%s)Hz', titles{i}));
        figure('units', 'normalized', 'outerposition', [0 0 1 1]);

        [h, t] = impz(num, den);
        subplot(2, 3, 1); stem(t, h);
        title(sprintf('(IIR) Impulse Response for (%s)Hz', titles{i}));

        [s, t] = stepz(num, den);
        subplot(2, 3, 2); stem(t, s);
        title(sprintf('(IIR) Step response (%s)Hz', titles{i}));

        fprintf('(IIR) Order for (%s)Hz = %d\n', titles{i}, order_iir);

        subplot(2, 3, 3); zplane(z, p);
        title(sprintf('(IIR) Zero-Pole plot %s', titles{i}));
        t = linspace(0, length(filteredOutputSignal) / Fs, length(filteredOutputSignal));
        f = linspace(-Fs / 2, Fs / 2, length(filteredOutputSignal));
        fprintf('(IIR) Gain for (%s)Hz= %d\n\n', titles{i}, k);
        subplot(2, 3, 4); plot(t, filteredOutputSignal);
        title(sprintf('(IIR) Filtered input in Time Domain for (%s)Hz', titles{i}));
        subplot(2, 3, 5); plot(f, abs(fftshift(fft(filteredOutputSignal))));
        title(sprintf('(IIR) Filtered input in Freq Domain for (%s)Hz', titles{i}));
    end

end

% Plot the input signal in time domain and frequency domain, the composite signal in time domain and frequency domain
tSignal = linspace(0, length(Signal) / sampleRate, length(Signal));
fSignal = linspace(-sampleRate / 2, sampleRate / 2, length(Signal));
outputSignalGain = resample(outputSignalGain, newFs, tempFs);

tCompositeSignal = linspace(0, length(outputSignalGain) / newFs, length(outputSignalGain));
fCompositeSignal = linspace(-newFs / 2, newFs / 2, length(outputSignalGain));

figure('units', 'normalized', 'outerposition', [0 0 1 1]);
subplot(2, 2, 1); plot(tSignal, Signal);
title('Input signal in Time Domain');
subplot(2, 2, 2); plot(fSignal, abs(fftshift(fft(Signal))));
title('Input Signal in Freq Domain');

subplot(2, 2, 3); plot(tCompositeSignal, outputSignalGain);
title('Composite signal in Time Domain');
subplot(2, 2, 4); plot(fCompositeSignal, abs(fftshift(fft(outputSignalGain))));
title('Composite Signal in Freq Domain');

% Store coeff low band
fileID = fopen('fir_coefficients1_hex.txt', 'w');
for i = 1:length(num_hex_24bit_1)
    fprintf(fileID, '%s\n', num_hex_24bit_1(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients2_hex.txt', 'w');
for i = 1:length(num_hex_24bit_2)
    fprintf(fileID, '%s\n', num_hex_24bit_2(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients3_hex.txt', 'w');
for i = 1:length(num_hex_24bit_3)
    fprintf(fileID, '%s\n', num_hex_24bit_3(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients4_hex.txt', 'w');
for i = 1:length(num_hex_24bit_4)
    fprintf(fileID, '%s\n', num_hex_24bit_4(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients5_hex.txt', 'w');
for i = 1:length(num_hex_24bit_5)
    fprintf(fileID, '%s\n', num_hex_24bit_5(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients6_hex.txt', 'w');
for i = 1:length(num_hex_24bit_6)
    fprintf(fileID, '%s\n', num_hex_24bit_6(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients7_hex.txt', 'w');
for i = 1:length(num_hex_24bit_7)
    fprintf(fileID, '%s\n', num_hex_24bit_7(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients8_hex.txt', 'w');
for i = 1:length(num_hex_24bit_8)
    fprintf(fileID, '%s\n', num_hex_24bit_8(i, :));  % Write each coefficient in hex to the file
end

% Store coeff low band
fileID = fopen('fir_coefficients9_hex.txt', 'w');
for i = 1:length(num_hex_24bit_9)
    fprintf(fileID, '%s\n', num_hex_24bit_9(i, :));  % Write each coefficient in hex to the file
end

% Play the composite signal
sound(outputSignalGain, newFs);

% Save the output signal as a wave file
audiowrite('output.wav', outputSignalGain, newFs)