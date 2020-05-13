function [signal_point,new_data,new_msg] = send_1_new(r_trans,r_reci,t,n,e,data,msg)
signal_point = 0;
on = 0; 
startup_delay = 90000; 
pause = 3; 
send_steps = 500; 
repeat = 6;

new_data = data; 
new_msg = msg;
                
if(length(t) >= (3*n)/4)
    f1 = 250;
    f2 = 500; 
    f3 = 1000;
    f4 = 2000; 
    f5 = 4000;
    f6 = 8000; 
elseif(length(t) >= n/2)
    f1 = 300;
    f2 = 600; 
    f3 = 1200;
    f4 = 2400; 
    f5 = 4800;
    f6 = 9600; 
elseif(length(t) >= 1/4)
    f1 = 310;
    f2 = 620; 
    f3 = 1240;
    f4 = 2480; 
    f5 = 4960;
    f6 = 9920;  
else
    f1 = 250;
    f2 = 500; 
    f3 = 1000;
    f4 = 2000; 
    f5 = 4000;
    f6 = 8000; 
end 
%% Start doing stuff 

if isempty(data)
    data = [on startup_delay 0 repeat];
    new_data = data;
end

% display(length(msg))

% p1 = b1 ^ b2
% p2 = b1 ^ b3
% p3 = b2 ^ b3
% Get this when sending and when receiving
% If p1, p2, p3 are different when calculated newly than what were
% received, fix errors
% If p1 and p2 are different, invert b1
% If p2 and p3 are different, invert b3
% If p1 and p3 are different, invert b2

%%%%%%%%%%%%%%%%%%
if data(1,1) == 0 
    if data(1,2) <= 0
       % display(new_data(4))
        if new_data(4) > 0 % times to repeat 
            if data(1,3)-1 > 0 % ticks to send
                new_data(1,3) = data(1,3) - 1; 

                % Get bits from this chunk 
                if (msg(1) == 0) b1 = -1; 
                else b1 = 1; end 
                if (msg(2) == 0) b2 = -1; 
                else b2 = 1; end 
                if (msg(3) == 0) b3 = -1; 
                else b3 = 1; end 
                p1 = xor(msg(1), msg(2));
                p2 = xor(msg(1), msg(3));
                p3 = xor(msg(2), msg(3));

                if (msg(4) == 0) b4 = -1; 
                else b4 = 1; end 
                if (msg(5) == 0) b5 = -1; 
                else b5 = 1; end 
                if (msg(6) == 0) b6 = -1; 
                else b6 = 1; end 
                p4 = xor(msg(4), msg(5));
                p5 = xor(msg(4), msg(6));
                p6 = xor(msg(5), msg(6));
                
                if (msg(7) == 0) b7 = -1; 
                else b7 = 1; end 
                if (msg(8) == 0) b8 = -1; 
                else b8 = 1; end  
                if (msg(9) == 0) b9 = -1; 
                else b9 = 1; end 
                p7 = xor(msg(7), msg(8));
                p8 = xor(msg(7), msg(9));
                p9 = xor(msg(8), msg(9));
                
                if (msg(10) == 0) b10 = -1; 
                else b10 = 1; end 
                if (msg(11) == 0) b11 = -1; 
                else b11 = 1; end 
                if (msg(12) == 0) b12 = -1; 
                else b12 = 1; end 
                p10 = xor(msg(10), msg(11));
                p11 = xor(msg(10), msg(12));
                p12 = xor(msg(11), msg(12));
                
                if (msg(13) == 0) b13 = -1; 
                else b13 = 1; end 
                if (msg(14) == 0) b14 = -1; 
                else b14 = 1; end 
                if (msg(15) == 0) b15 = -1; 
                else b15 = 1; end 
                p13 = xor(msg(13), msg(14));
                p14 = xor(msg(13), msg(15));
                p15 = xor(msg(14), msg(15));
                
                if (msg(16) == 0) b16 = -1; 
                else b16 = 1; end  
                if (msg(17) == 0) b17 = -1; 
                else b17 = 1; end 
                if (msg(18) == 0) b18 = -1; 
                else b18 = 1; end
                p16 = xor(msg(16), msg(17));
                p17 = xor(msg(16), msg(18));
                p18 = xor(msg(17), msg(18));
                
                if(new_data(4) == 6)
                    signal_point = (b1 * sin(2*pi()*f1*t(1,n)) + ...
                        b4 * sin(2*pi()*f2*t(1,n)) + ... 
                        b7 * sin(2*pi()*f3*t(1,n)) + ... 
                        b10 * sin(2*pi()*f4*t(1,n)) + ... 
                        b13 * sin(2*pi()*f5*t(1,n)) + ... 
                        b16 * sin(2*pi()*f6*t(1,n)));
                  %  display("signal 6 sent"+msg(1)+msg(2)+msg(3))
                elseif(new_data(4) == 5)
                    signal_point = (b2 * sin(2*pi()*f1*t(1,n)) + ...
                        b5 * sin(2*pi()*f2*t(1,n)) + ... 
                        b8 * sin(2*pi()*f3*t(1,n)) + ... 
                        b11 * sin(2*pi()*f4*t(1,n)) + ... 
                        b14 * sin(2*pi()*f5*t(1,n)) + ... 
                        b17 * sin(2*pi()*f6*t(1,n)));
                   %  display("signal 5 sent"+msg(1)+msg(2)+msg(3))
                elseif(new_data(4) == 4)
                    signal_point = (b3 * sin(2*pi()*f1*t(1,n)) + ...
                        b6 * sin(2*pi()*f2*t(1,n)) + ... 
                        b9 * sin(2*pi()*f3*t(1,n)) + ... 
                        b12 * sin(2*pi()*f4*t(1,n)) + ... 
                        b15 * sin(2*pi()*f5*t(1,n)) + ... 
                        b18 * sin(2*pi()*f6*t(1,n)));
                   %  display("signal 4 sent"+msg(1)+msg(2)+msg(3))
                elseif(new_data(4) == 3)
                    signal_point = (p1 * sin(2*pi()*f1*t(1,n)) + ...
                        p4 * sin(2*pi()*f2*t(1,n)) + ... 
                        p7 * sin(2*pi()*f3*t(1,n)) + ... 
                        p10 * sin(2*pi()*f4*t(1,n)) + ... 
                        p13 * sin(2*pi()*f5*t(1,n)) + ... 
                        p16 * sin(2*pi()*f6*t(1,n)));
                  %  display("signal 3 sent"+msg(1)+msg(2)+msg(3))
                elseif(new_data(4) == 2)
                    signal_point = (p2 * sin(2*pi()*f1*t(1,n)) + ...
                        p5 * sin(2*pi()*f2*t(1,n)) + ... 
                        p8 * sin(2*pi()*f3*t(1,n)) + ... 
                        p11 * sin(2*pi()*f4*t(1,n)) + ... 
                        p14 * sin(2*pi()*f5*t(1,n)) + ... 
                        p17 * sin(2*pi()*f6*t(1,n)));
                elseif(new_data(4) == 1)
                    signal_point = (p3 * sin(2*pi()*f1*t(1,n)) + ...
                        p6 * sin(2*pi()*f2*t(1,n)) + ... 
                        p9 * sin(2*pi()*f3*t(1,n)) + ... 
                        p12 * sin(2*pi()*f4*t(1,n)) + ... 
                        p15 * sin(2*pi()*f5*t(1,n)) + ... 
                        p18 * sin(2*pi()*f6*t(1,n)));
                end
                % we have finished this chunk 
                new_data(1,3) = 0; % End the timer
                new_data(1,2) = pause; % Add a startup delay 
                new_data(1,4) = new_data(1,4) - 1; % decrement repetition
            end   
        else
            % get a new message 
            if length(new_msg) >= 19
                new_msg = msg(19:end);
                new_data(1,4) = repeat;
            else
                % End broadcast done with message 
                new_data(1) = 1;
            end
            % start data(4) at its value 
%             new_data(1,4) = repeat; 
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


