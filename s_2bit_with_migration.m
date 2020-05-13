function [signal_point,new_data,new_msg] = s_2bit(r_trans,r_reci,t,n,e,data,msg)


signal_point = 0;

on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 200; 

new_data = data; 
new_msg = msg;
if (length(msg) >= 3) 
    if (msg(1) == 0) b1 = -1; 
    else b1 = 1; end 
    if (msg(2) == 0) b2 = -1; 
    else b2 = 1; end 
else
    b1 = 1; 
    b2 = 1; 
end 

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
            % Transmit a signal point 
            signal_point = ((b1 * sin(2*pi()*f*t(1,n)) + ...
                b2 * cos(2*pi()*f*t(1,n)))/(1.22)); 

            % countdown 3rd data index 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0; % End the timer
                new_data(1,2) = pause; % Add a startup delay 
                
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
                
                
                
                if length(new_msg) >= 3
                    new_msg = msg(3:end);
                else
                    % End broadcast 
                    new_data(1) = 1;
                end
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
