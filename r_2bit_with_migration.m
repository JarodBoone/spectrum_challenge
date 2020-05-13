function [signal_point,new_data,new_bits] = r_2bit(r_reci,r_trans,t,n,e,data)

signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 200; 
new_bits = []; 

new_data = data; 

default_freq = 1000;
%% Start doing stuff 

if isempty(data)
    data = [on startup_delay 0 default_freq];
    new_data = data;
end

f = data(4);

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0;
                new_data(1,2) = 3;
                
                %in between messages, change frequency
                %find actual best frequency (min of fft) 
                sampling_freq = 25*1000 / 2; 
                bin_steps = sampling_freq / (send_steps + 1);
                recent_received_signal = r_reci(n-send_steps*2:2:n);
                frequencies = fft(recent_received_signal);
                frequencies = abs(frequencies)/ (send_steps + 1);
                frequencies = frequencies(1:100);
                [~, arg] = min(frequencies(2:end)); %ensures the chosen freq is in a viable range
                new_carrier_freq = bin_steps*(arg);
                new_data(4) = new_carrier_freq;
                
                
                a1 = sin(2*pi()*f*t(1,n-(send_steps * 2):2:n));
                a2 = cos(2*pi()*f*t(1,n-(send_steps * 2):2:n));
                
%                 wave1 = bandpass(r_trans(n-send_steps:n), [f1 - 1, f1 + 1], f1);
%                 wave2 = bandpass(r_trans(n-send_steps:n), [f2 - 1, f2 + 1], f2);
%                 dot1 = dot(wave1, a1);
%                 dot2 = dot(wave2, a2);

                wave = r_trans(n-(send_steps * 2):2:n);
                dot1 = dot(wave,a1);
                dot2 = dot(wave,a2);

                if ((dot1 > 0))
                    b1 = 1;
                else
                    b1 = 0; 
                end
                if ((dot2 > 0)) 
                    b2 = 1;
                else
                    b2 = 0; 
                end

                new_bits = [b1,b2];  % Don't need to write new_bits
             
            end
        end
    else
        % Countdown startup delay
        if data(1,2)-1 > 0
            new_data(1,2) = data(1,2) - 1;
        else
            % Start new broadcast 
            
            new_data(1,2) = 0;
            new_data(1,3) = send_steps;
        end
    end
end

end


