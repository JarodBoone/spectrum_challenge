function [signal_point,new_data,new_msg] = s_2bit(r_trans,r_reci,t,n,e,data,msg)

% Want to use a 4 dimensional signal space to send 5 bits (3 info 2 parity)
% We iterate over the message bits by 3
% 32 cases 
signal_point = 0;

on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 200; 
display(length(msg))
% score = 1987 with time step 200 and sp/1.22
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

% 500, 1000, 2000, 4000, 8000
if(length(t) >= (3*n)/4)
    f1 = 1000; 
    f2 = 2000; 
elseif(length(t) >= n/2)
    f1 = 3000; 
    f2 = 6000; 
elseif(length(t) >= 1/4)
    f1 = 4000; 
    f2 = 8000; 
else
    f1 = 1500; 
    f2 = 3000; 
end 
%% Start doing stuff 

if isempty(data)
    data = [on startup_delay 0];
    new_data = data;
end

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            % Transmit a signal point 
            signal_point = ((b1 * sin(2*pi()*f1*t(1,n)) + ...
                b2 * sin(2*pi()*f2*t(1,n)))/(1.22)); 

            % countdown 3rd data index 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0; % End the timer
                new_data(1,2) = pause; % Add a startup delay 
                
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
