function [signal_point,new_data,new_msg] = send_1_new(r_trans,r_reci,t,n,e,data,msg)

signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 200; 
repeat = 4;

new_data = data; 
new_msg = msg;
                
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
    data = [on startup_delay 0 repeat 0 0];
    new_data = data;
end

if data(1,1) == 0 
    if data(1,2) <= 0
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
        if data(1,3) >= 0 
            % Attempt to repeat same 4 points
            if new_data(4) == 4
                if (length(msg) >= 3) 
                    if (msg(1) == 0) b1 = -1; 
                    else b1 = 1; end 
                    if (msg(2) == 0) b2 = -1; 
                    else b2 = 1; end 
                else
                    b1 = 1; 
                    b2 = 1; 
                end 
                new_data(5) = b1;
                new_data(6) = b2;
            end
            if new_data(4) > 0
                signal_point = ((new_data(5) * sin(2*pi()*f1*t(1,n)) + ...
                    new_data(6) * sin(2*pi()*f2*t(1,n)))/(1.22)); 
                
                new_data(4) = new_data(4) - 1;
            end
            new_data(4) = repeat;
            % countdown 3rd data index  
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
