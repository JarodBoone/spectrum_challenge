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

%%%%%%%%%%%%%%%%%%
if data(1,1) == 0 
    if data(1,2) <= 0
        if new_data(4) > 0 % times to repeat 
            if data(1,3)-1 > 0 % ticks to send
                new_data(1,3) = data(1,3) - 1; 

                % Get bits from this chunk 
                if (msg(1) == 0) b1 = -1; 
                else b1 = 1; end 
                if (msg(2) == 0) b2 = -1; 
                else b2 = 1; end 

                % send the signal 
                signal_point = ((b1 * sin(2*pi()*f1*t(1,n)) + ...
                    b2 * sin(2*pi()*f2*t(1,n)))/(1.22)); 
            else

                % we have finished this chunk 
                new_data(1,3) = 0; % End the timer
                new_data(1,2) = pause; % Add a startup delay 
                new_data(1,4) = new_data(1,4) - 1; % decrement repetitino
            end   
        else
            % get a new message 
            if length(new_msg) >= 3
                new_msg = msg(3:end);
            else
                % End broadcast done with message 
                new_data(1) = 1;
            end

            % start data(4) at its value 
            new_data(1,4) = repeat; 
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
%%%%%%%%%%%%%%%
end


