function [signal_point,new_data,new_msg] = s1_opponent(r_trans,r_reci,t,n,e,data,msg)

% Want to use a 4 dimensional signal space to send 5 bits (3 info 2 parity)
% We iterate over the message bits by 3
% 32 cases 
signal_point = 0;

on = 0; 
startup_delay = 1000; 
pause = 3; 
send_steps = 410; 


new_data = data; 
new_msg = msg;
if (length(msg) >= 4) 
    if (msg(1) == 0) b1 = -1; 
    else b1 = 1; end 
    if (msg(2) == 0) b2 = -1; 
    else b2 = 1; end 
    if (msg(3) == 0) b3 = -1; 
    else b3 = 1; end 
%     if (msg(4) == 0) b4 = -1; 
%     else b4 = 1; end 
else
    b1 = 1; 
    b2 = 1; 
    b3 = 1; 
%     b4 = 1;
end 



% if (xor(b1,b2) == 0) b4 = -1; 
% else b4 = 1; end 
% 
% if (xor(b1,b3) == 0) b5 = -1; 
% else b5 = 1; end 
% 
% if (xor(b2,b3) == 0) b6 = -1; 
% else b6 = 1; end 


% % 500, 1000, 2000, 4000, 8000
% f1 = 100; 
% f2 = 200; 
% f3 = 400; 
% f4 = 800; 
% % f5 = 8000; 
% % f6 = 250; 


if(length(t) >= (3*n)/4)
    f1 = 250; 
    f2 = 2000; 
    f3 = 4000; 
    f4 = 8000;
elseif(length(t) >= n/2)
    f1 = 300; 
    f2 = 1200;
    f3 = 2400; 
    f4 = 4800; 
elseif(length(t) >= 1/4)
    f1 = 700; 
    f2 = 1400; 
    f3 = 2800;
    f4 = 5600;
else
    f1 = 800; 
    f2 = 1600; 
    f3 = 3200;
    f4 = 6400;
end 
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
            signal_point = (b1 * sin(2*pi()*f1*t(1,n)) + ...
                b2 * sin(2*pi()*f2*t(1,n)) + ...
                b3 * sin(2*pi()*f3*t(1,n)))/1.7;
%                 b4 * sin(2*pi()*f4*t(1,n)))/(1.7);
            
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
