% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% * Lu X, Rudi A, Borgonovo E, Rosasco L. Faster Kriging: Facing High-Dimensional Simulators. Operations Research. 2020 Jan;68(1):233-49.
% * Author: Xuefei Lu, xuefei.lu@ed.ac.uk
% * Date: Dec, 2020
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate Dataset for
% 21-dim Additive Gaussian model
% Y = \sum_{i=1}^{21} a_i * X_i
% a_1 = ... = a_7 = -4; a_8= ... = a_14 = 2, a_{15} = ... = a_{21} = 1
%%
n=103000;

k=21; % dimension
p = haltonset(k,'Skip',1e3,'Leap',1e2);
p = scramble(p,'RR2');
u=net(p,n+1);
uu=u(2:end,:);
x=norminv(uu,1,1);
y=sum(-4*x(:,1:7),2)+sum(2*x(:,8:14),2)+sum(x(:,15:21),2);

x_train = x(1:100000,:);
y_train = y(1:100000,:);
x_test = x(100001:end,:);
y_test = y(100001:end,:);

save('x_train.txt','x_train','-ascii')
save('y_train.txt','y_train','-ascii')
save('x_test.txt','x_test','-ascii')
save('y_test.txt','y_test','-ascii')
