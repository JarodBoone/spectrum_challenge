tic
t1 = testing_ground_final('test',0,'BOB',@s_2bit,@r_2bit,'SAM',@send_2,@reci_2);
disp(t1)
toc
% tic
% t2 = testing_ground_4('test',0,'BOB',@send_2,@reci_2,'SAM',@send_1,@reci_1);
% toc
% tic
% f = testing_ground_final('fight',0,'BOB',@s1_no_p,@r1_no_p,'SAM',@s1_opponent,@r1_opponent);
% toc
% tic
% c = testing_ground_4('fight',0,'BOB',@send_1,@reci_1,'SAM',@send_2,@reci_2);
% toc
% score_1 = t1+f+abs(c)
% score_2 = t2-f+abs(c)