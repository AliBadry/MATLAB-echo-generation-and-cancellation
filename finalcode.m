[y,Fs] = audioread('signals.wav');
% length of the audio in samples
ylen=length(y); %to
T = ylen/Fs;
time = ([1:ylen]-1)/Fs;
%sound(y,Fs)
%pause(T)
% calculate the time value of samples
%Impulse
U_input_1 = [0.2 0.5; 0.4 0.3; 0.6 0.1]; %strong
U_input_2 = [0.4 0.5; 0.8 0.3; 1.2 0.1]; %medium
U_input_3 = [0.6 0.5; 1.2 0.3; 1.8 0.1]; %weak
for k=1:3
    t = zeros(size(y,1),1);
    if(k==1)
        U_input=U_input_1;
        disp('strong eco system')
    end
     if(k==2)
        U_input=U_input_2;
        disp('medium eco system')
     end
      if(k==3)
        U_input=U_input_3;
        disp('weak eco system')
    end
         
    t(1)=1;
    
for i = 1:size(U_input,1)
    t(U_input(i,1)*Fs) = U_input(i,2);
end  
figure(k);
% plot the input waveform
subplot(4,1,1);
plot(time,y,'g');
xlabel('Time in seconds')
ylabel('signal strength')
title('Input')
grid on


ly = length(y);
lt = length(t);
outlength = ly + lt - 1; 
y_out = ifft(fft(y, outlength) .* fft(t, outlength));
y_out = y_out./max(abs(y_out)); % Normalises Signal

% y_out = freqconv(y, t);
subplot(4,1,2);     
plot(time,t,'r'); 
xlabel('Time in seconds')
ylabel('Impulses')
title('Impulse Train');
grid on


% Define the time axis of the convolved signal
y_outlen=length(y_out);
time_axis_out = ([1:y_outlen]-1)/Fs;

%plot the sound after applying the echo to it
subplot(4,1,3); 
plot(time_axis_out,y_out,'b');
xlabel('Time in seconds')
ylabel('signal strength')
title('output signal');   
grid on

%saving the output . wav file
%audiowrite('echo3.wav',y_out,Fs); 


%getting the original signal by dividing the signal by the frequency
%response in the frequency domain
xx = ifft(fft(y_out,outlength)./fft(t, outlength)); 

%applying the deconv. by dividing the signal with the freq. response 
%then getting the inverse fft to get the signal in the time domain
xx = xx./max(abs(xx)); %normalizing the signal

%plotting the signal after deconv.
subplot(4,1,4); 
plot(time_axis_out,xx,'g');
xlabel('Time in seconds')
ylabel('signal strength')
title('output after deconv. the echo');   
grid on

%playing the sound of the echoed signal
sound(y_out,Fs)
pause(T)

%playing the sound of the signal after removing the echo
sound(xx,Fs)
pause(T)

%saving the signal after removing the echo
%%audiowrite('de-echo3.wav',xx,Fs);


end

