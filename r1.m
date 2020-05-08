function [signal_point,new_data,new_bits] = r1(r_reci,r_trans,t,n,e,data)

% Want to use a 4 dimensional signal space to send 5 bits (3 info 2 parity)
% We iterate over the message bits by 3
% 32 cases 
signal_point = 0;
on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 250; 
new_bits = []; 

new_data = data; 
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
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                new_data(1,3) = 0;
                new_data(1,2) = 3;
                a1 = sin(2*pi()*f1*t(1,n-send_steps:n));
                a2 = sin(2*pi()*f2*t(1,n-send_steps:n));
                a3 = sin(2*pi()*f3*t(1,n-send_steps:n));
                a4 = sin(2*pi()*f4*t(1,n-send_steps:n));
                a5 = sin(2*pi()*f5*t(1,n-send_steps:n));
                a6 = sin(2*pi()*f6*t(1,n-send_steps:n));
                wave = r_trans(n-send_steps:n);
                
                if (dot(wave,a1) > 0) b1 = 1;
                else b1 = 0; end
                if (dot(wave,a2) > 0) b2 = 1;
                else b2 = 0; end
                if (dot(wave,a3) > 0) b3 = 1;
                else b3 = 0; end
                if (dot(wave,a4) > 0) b4 = 1;
                else b4 = 0; end
                if (dot(wave,a5) > 0) b5 = 1;
                else b5 = 0; end
                if (dot(wave,a6) > 0) b6 = 1;
                else b6 = 0; end
%                 
%                 p1 = xor(xor(b1,b2),b4); 
%                 p2 = xor(xor(b1,b3),b5);
%                 p3 = xor(xor(b2,b3),b6); 
%                 
%                 if (p1 && p2 && ~p3) 
%                     b1 = ~b1;
%                 elseif(p1 && ~p2 && p3) 
%                     b2 = ~b2;
%                         
%                 elseif(~p1 && p2 && p3) 
%                     b3 = ~b3;     
%                 end
          
                new_bits = [new_bits,b1,b2,b3];
             
            
     
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