function [signal_point,new_data,new_msg] = s_3bit_fight(r_trans,r_reci,t,n,e,data,msg)

signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 150; 

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

if(n >= (7*length(t))/8)
    f1 = 150; 
    f2 = 300;  
elseif(n >= (3*length(t))/4)
    f1 = 1000; 
    f2 = 2000; 
elseif(n >= (5*length(t))/8)
    f1 = 155; 
    f2 = 310; 
elseif(n >= length(t)/2)
    f1 = 200; 
    f2 = 2000; 
elseif(n >= (3*length(t))/8)
    f1 = 200; 
    f2 = 500; 
elseif(n >= length(t)/4)
    f1 = 1500; 
    f2 = 3000; 
else
    f1 = 160; 
    f2 = 320; 
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
            signal_point = (b1 * sin(2*pi()*f1*t(1,n)) + ...
            b2 * cos(2*pi()*f1*t(1,n)) + ...
            b3 * sin(2*pi()*f2*t(1,n)))/(1.51);
            
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
