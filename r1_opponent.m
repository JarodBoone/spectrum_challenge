function [signal_point,new_data,new_bits] = r1_opponent(r_reci,r_trans,t,n,e,data)

% Want to use a 4 dimensional signal space to send 5 bits (3 info 2 parity)
% We iterate over the message bits by 3
% 32 cases 
signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 500; 
new_bits = []; 

new_data = data; 
% 500, 1000, 2000, 4000, 8000
f1 = 100; 
f2 = 200; 
f3 = 400; 
f4 = 800; 
% f5 = 8000; 
% f6 = 250; 

%% Start doing stuff 

if isempty(data)
    data = [on startup_delay 0];
    new_data = data;
    r_trans = [0 0]; %Override transmission history ??
end

if e == 0 || r_trans(end,end) == 154 || r_reci(end,end) == 198
    data(1,1) = 1;
end

if length(t) == n || length(t) == n + 1
    new_bits = zeros(1, 10000);
end

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0;
                new_data(1,2) = 3;
                a1 = cos(2*pi()*f1*t(1,n-send_steps:n));
                a2 = sin(2*pi()*f2*t(1,n-send_steps:n));
                a3 = cos(2*pi()*f3*t(1,n-send_steps:n));
                a4 = sin(2*pi()*f4*t(1,n-send_steps:n));

                wave = r_trans(n-send_steps:n);
                
                display(dot(wave,a1))

                if (dot(wave,a1) > 0) b1 = 1;
                else b1 = 0; end
                if (dot(wave,a2) > 0) b2 = 1;
                else b2 = 0; end
                if (dot(wave,a3) > 0) b3 = 1;
                else b3 = 0; end
                if (dot(wave,a4) > 0) b4 = 1;
                else b4 = 0; end
                
                new_bits = [new_bits,b1,b2,b3,b4];  % Don't need to write new_bits
             
            
     
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


