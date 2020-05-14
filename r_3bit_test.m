function [signal_point,new_data,new_bits] = r_3bit_test(r_reci,r_trans,t,n,e,data)

signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 150; 
new_bits = []; 

new_data = data; 

f1 = 150; 
f2 = 300;  
%% Start doing stuff 

if isempty(data)
    data = [on startup_delay 0];
    new_data = data;
end

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0;
                new_data(1,2) = pause;
                a1 = sin(2*pi()*f1*t(1,n-(send_steps * 2):2:n));
                a2 = cos(2*pi()*f1*t(1,n-(send_steps * 2):2:n));
                a3 = sin(2*pi()*f2*t(1,n-(send_steps * 2):2:n));
                wave = r_trans(n-(send_steps * 2):2:n);

                if (dot(wave,a1) > 0) b1 = 1;
                else b1 = 0; end
                if (dot(wave,a2) > 0) b2 = 1;
                else b2 = 0; end
                if (dot(wave,a3) > 0) b3 = 1;
                else b3 = 0; end

                new_bits = [b1,b2,b3];
             
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

