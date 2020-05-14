function [signal_point,new_data,new_bits] = r_2bit_fight(r_reci,r_trans,t,n,e,data)

signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 150; 
new_bits = []; 

new_data = data; 

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
        if data(1,3) >= 0 % if still transmitting 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0;
                new_data(1,2) = pause;
                a1 = sin(2*pi()*f1*t(1,n-(send_steps * 2):2:n));
                a2 = sin(2*pi()*f2*t(1,n-(send_steps * 2):2:n));
              
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

                new_bits = [b1,b2];
             
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

