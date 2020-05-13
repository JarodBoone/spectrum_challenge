function [signal_point,new_data,new_bits] = r_2bit(r_reci,r_trans,t,n,e,data)

% Want to use a 4 dimensional signal space to send 5 bits (3 info 2 parity)
% We iterate over the message bits by 3
% 32 cases 
signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 200; 
new_bits = []; 

new_data = data; 
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
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0;
                new_data(1,2) = 3;
                a1 = sin(2*pi()*f1*t(1,n-(send_steps * 2):2:n));
                a2 = sin(2*pi()*f2*t(1,n-(send_steps * 2):2:n));
                
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
        %disp("please god here at least") 
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


