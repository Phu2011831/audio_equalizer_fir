% MATLAB code to read hex file, filter signal using FIR with Kaiser window, and analyze signal

% Step 1: Read data from a hex file and convert to signed 24-bit integers
fileID = fopen('sine.hex', 'r');  % Open the hex file
hexData = fscanf(fileID, '%x');   % Read hex data
fclose(fileID);                   % Close the file

% Step 2: Convert the hex data to signed 24-bit integers
N = length(hexData);              % Number of samples
signal = zeros(1, N);             % Initialize signal array

for i = 1:N
    value = hexData(i);           % Get the 24-bit value
    % If the value represents a negative number, convert it to signed format
    if bitand(value, hex2dec('800000')) ~= 0
        value = value - hex2dec('1000000');  % Convert to signed 24-bit
    end
    signal(i) = value;            % Store in signal array
end

% Normalize the signal to be in the range [-1, 1]
signal = signal / (2^23);

% Step 3: Visualize the original signal
fs = 1000;                        % Sampling frequency (Hz)
t = (0:N-1) / fs;                 % Time vector

figure;
subplot(2,1,1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');




% Step 4: Design FIR filter with Kaiser window (Beta = 4)
Fc = 10;                          % Cutoff frequency (Hz)
order = 63 ;                      % Filter order 
beta = 4;                         % Kaiser window Beta
b = fir1(order, Fc/(fs/2), 'low', kaiser(order+1, beta));  % Design FIR filter


% Step 5: Apply the FIR filter using zero-phase filtering (filtfilt)

filtered_signal = filtfilt(b, 1, signal);

% Step 6: Visualize the filtered signal
subplot(2,1,2);
plot(t, filtered_signal);
title('Filtered Signal (Low-pass FIR with Kaiser Window)');
xlabel('Time (s)');
ylabel('Amplitude');




% Step 7: Compute and plot Fourier Transform (FFT) before and after filtering
figure;
% FFT of original signal
signal_fft = fft(signal);
frequencies = (0:N-1)*(fs/N);  % Frequency vector

subplot(2,1,1);
plot(frequencies, abs(signal_fft)/N);
xlim([0 fs/2]);  % Show positive frequencies only
title('FFT of Original Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% FFT of filtered signal
filtered_signal_fft = fft(filtered_signal);
subplot(2,1,2);
plot(frequencies, abs(filtered_signal_fft)/N);
xlim([0 fs/2]);  % Show positive frequencies only
title('FFT of Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Step 8: Convert FIR filter coefficients to 24-bit hex values
b_scaled_24bit = round(b * 2^23);     % Scale coefficients to 24-bit signed integer range
b_hex_24bit = dec2hex(b_scaled_24bit);  % Convert to hexadecimal

% Display FIR filter coefficients in hex format
disp('FIR Filter Coefficients in 24-bit Hex:');
disp(b_hex_24bit);

% Save FIR coefficients to a text file
fileID = fopen('fir_coefficients.hex', 'w');
for i = 1:length(b_hex_24bit)
    fprintf(fileID, '%s\n', b_hex_24bit(i, :));  % Write each coefficient in hex to the file
end
fclose(fileID);


