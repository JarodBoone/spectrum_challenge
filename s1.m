function [signal_point,new_data,new_msg] = s1(r_trans,r_reci,t,n,e,data,msg)

% Want to use a 4 dimensional signal space to send 5 bits (3 info 2 parity)
% We iterate over the message bits by 3
% 32 cases 
signal_point = 0;

on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 450; 


new_data = data; 
new_msg = msg;
if (length(msg) >= 3) 
    if (msg(1) == 0) b1 = -1; 
    else b1 = 1; end 
    if (msg(2) == 0) b2 = -1; 
    else b2 = 1; end 
    if (msg(3) == 0) b3 = -1; 
    else b3 = 1; end 
else
    b1 = 1; 
    b2 = 1; 
    b3 = 1; 
end 



if (xor(b1,b2) == 0) b4 = -1; 
else b4 = 1; end 

if (xor(b1,b3) == 0) b5 = -1; 
else b5 = 1; end 

if (xor(b2,b3) == 0) b6 = -1; 
else b6 = 1; end 


% 500, 1000, 2000, 4000, 8000
f1 = 500; 
f2 = 1000; 
f3 = 2000; 
f4 = 4000; 
f5 = 8000; 
f6 = 250; 



%% Start doing stuff 

if isempty(data)
    data = [on startup_delay 0];
    new_data = data;
    r_trans = [0 0]; %Override transmission history ??
end

if e == 0 || r_trans(end,end) == 154 || r_reci(end,end) == 198
    data(1,1) = 1;
end

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            % Transmit a signal point 
            signal_point = (b1 * cos(2*pi()*f1*t(1,n)) + ...
                b2 * cos(2*pi()*f2*t(1,n)) + ...
                b3 * cos(2*pi()*f3*t(1,n)) + ...
                b4 * cos(2*pi()*f4*t(1,n)) + ...
                b5 * cos(2*pi()*f5*t(1,n)) + ...
                b6 * cos(2*pi()*f6*t(1,n)))/3; 
            
            % countdown 3rd data index 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0; % End the timer
                new_data(1,2) = pause; % Add a startup delay 
                
                if length(new_msg) >= 4
                    new_msg = msg(4:end);
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