function [signal_point,new_data,new_bits] = reci_1_new(r_reci,r_trans,t,n,e,data)

signal_point = 0;
on = 0; 
startup_delay = 90000; 
pause = 3; 
send_steps = 500; 
new_bits = []; 
repeat = 6;

new_data = data;


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

if data(1,1) == 0 % if on 
    if data(1,2) <= 0 % if done with startup delay
        if data(1,3) >= 0 % If still transmitting 
            if data(1,3)-1 > 0
                new_data(1,3) = data(1,3) - 1;
            else
                display("received a message")
                new_data(1,3) = 0;
                new_data(1,2) = 3;
                a1 = sin(2*pi()*f1*t(1,n-(send_steps * 2):2:n));
                a2 = sin(2*pi()*f2*t(1,n-(send_steps * 2):2:n));
                a3 = sin(2*pi()*f3*t(1,n-(send_steps * 2):2:n));
                a4 = sin(2*pi()*f4*t(1,n-(send_steps * 2):2:n));
                a5 = sin(2*pi()*f5*t(1,n-(send_steps * 2):2:n));
                a6 = sin(2*pi()*f6*t(1,n-(send_steps * 2):2:n));
                
                wave = r_trans(n-(send_steps * 2):2:n);
                dot1 = dot(wave,a1);
                dot2 = dot(wave,a2);
                dot3 = dot(wave,a3);
                dot4 = dot(wave,a4);
                dot5 = dot(wave,a5);
                dot6 = dot(wave,a6);
                if (dot1 > 0) b1_r = 1;
                else b1_r = 0; end
                if (dot2 > 0) b2_r = 1;
                else b2_r = 0; end
                if (dot3 > 0) b3_r = 1;
                else b3_r = 0; end
                if (dot4 > 0) b4_r = 1;
                else b4_r = 0; end
                if (dot5 > 0) b5_r = 1;
                else b5_r = 0; end
                if (dot6 > 0) b6_r = 1;
                else b6_r = 0; end
                
                new_data = [data,b1_r,b2_r,b3_r,b4_r,b5_r,b6_r]; 
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
    display("outputting a message")
    b1 = new_data(5);
    b2 = new_data(11);
    b3 = new_data(17);
    p1_n = xor(b1,b2);
    p2_n = xor(b1,b3);
    p3_n = xor(b2,b3);
    [b1, b2, b3] = parity_check(b1, b2, b3, p1_n, p2_n, p3_n, new_data(23), new_data(29), new_data(35));
    
    b4 = new_data(6);
    b5 = new_data(12);
    b6 = new_data(18);
    p4_n = xor(b4,b5);
    p5_n = xor(b4,b6);
    p6_n = xor(b5,b6);
    [b4, b5, b6] = parity_check(b4, b5, b6, p4_n, p5_n, p6_n, new_data(24), new_data(30), new_data(36));
    
    b7 = new_data(7);
    b8 = new_data(13);
    b9 = new_data(19);
    p7_n = xor(b7,b8);
    p8_n = xor(b7,b9);
    p9_n = xor(b8,b9);
    [b7, b8, b9] = parity_check(b7, b8, b9, p7_n, p8_n, p9_n, new_data(25), new_data(31), new_data(37));
    
    b10 = new_data(8);
    b11 = new_data(14);
    b12 = new_data(20);
    p10_n = xor(b10,b11);
    p11_n = xor(b10,b12);
    p12_n = xor(b11,b12);
    [b10, b11, b12] = parity_check(b10, b11, b12, p10_n, p11_n, p12_n, new_data(26), new_data(32), new_data(38));
    
    b13 = new_data(9);
    b14 = new_data(15);
    b15 = new_data(21);
    p13_n = xor(b13,b14);
    p14_n = xor(b13,b15);
    p15_n = xor(b14,b15);
    [b13, b14, b15] = parity_check(b13, b14, b15, p13_n, p14_n, p15_n, new_data(27), new_data(33), new_data(39));
    
    b16 = new_data(10);
    b17 = new_data(16);
    b18 = new_data(22);
    p16_n = xor(b16,b17);
    p17_n = xor(b16,b18);
    p18_n = xor(b17,b18);
    [b16, b17, b18] = parity_check(b16, b17, b18, p16_n, p17_n, p18_n, new_data(28), new_data(34), new_data(40));
    
    display("message received and bits are = "+b1+b2+b3)
    
    new_bits = [b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18];
    data = [on startup_delay 0 repeat];
    new_data = data;
end
end
