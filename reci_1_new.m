function [signal_point,new_data,new_bits] = reci_1_new(r_reci,r_trans,t,n,e,data)

signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 200; 
new_bits = []; 
repeat = 4;

new_data = data;


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
    data = [on startup_delay 0 repeat];
    new_data = data;
end

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(4) = data(4) - 1;
                new_data(1,3) = 0;
                new_data(1,2) = 3;
                a1 = sin(2*pi()*f1*t(1,n-send_steps:n));
                a2 = sin(2*pi()*f2*t(1,n-send_steps:n));
              
                wave = r_trans(n-send_steps:n);
                dot1 = dot(wave,a1);
                dot2 = dot(wave,a2);

                if (dot1 > 0)
                    b1 = 1;
                else
                    b1 = 0; 
                end
                if (dot2 > 0) 
                    b2 = 1;
                else
                    b2 = 0; 
                end

                new_data = [data,b1,b2]; 
                new_data(4) = new_data(4) - 1;
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

%% Attempt to use scratchpad 

if new_data(4) == 0

    b1 = round((new_data(5) + new_data(7) + new_data(9) + new_data(11))/4);
%      display("new_data(5) = " + new_data(5))
%      display("new_data(7) = "+ new_data(7))
%      display("new_data(9) = "+ new_data(9))
%      display("new_data(11) = "+ new_data(11))
%     display("receiver b1 = "+ b1)

    b2 = round((new_data(6) + new_data(8) + new_data(10) + new_data(12))/4);
    new_bits = [~b1,~b2];
    data = [on startup_delay 0 repeat];
    new_data = data;
end


