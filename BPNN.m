banana=[1 2 3 1 2 3 4 5 6 2 1 3 1.8 0.3 4 5 4 6 2 3 1 2 0.6]; 
pen=[2 3 7 2 3 4 5 3 9 2 6 9 3 0.3 1 2 4 7 9 8 8 10 0.9];
potato_actual=[1.6 2.6 5.6 1.6 2.6 3.6 4.6 3.6 8.0 2.0 4.3 7.0 2.6 0.3 2 3 4 6.7 6.7 6.3 5.7 7.3 0.8];

[input,ps1]=mapminmax([banana;pen]);%两行十列
[target,ps2]=mapminmax(potato_actual); %一行十列
%这里的ps1,2是这个归一化操作的种子，之后我们要用这个进行逆操作

net=newff(input,target,6,{'tansig','purelin'},'trainlm');
net.trainParam.epochs=1000;
 %最大训练次数
net.trainParam.goal=0.000001;%目标最小误差
LP.lr=0.00001;%学习速率

net=train(net,input,target);

banana1=[2 1 3 5 9 9];
pen1=[1 2 8 2 10 3];
potato_actual1=(banana1*1+pen1*2)/3;
input1=mapminmax('apply',[banana1;pen1],ps1);%应用之前的种子归一化

%预测
output1=net(input1);
prediction1=mapminmax('reverse',output1,ps2);

%做出预测值与实际值的图像
set(0,'defaultfigurecolor','w')
figure
plot(potato_actual1,'*','color',[222 87 18]/255);hold on
plot(prediction1,'-o','color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',14,'MarkerEdgecolor',[138 151 123]/255);
legend('actua value','prediction1'),title('预测其他数据')
xlabel('potato1'),ylabel('weight')
%使得坐标图优美
 set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'on', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],'LineWidth', 1)

%如果是预测本身呢？
figure
output=net(input);
prediction=mapminmax('reverse',output,ps2);

%让我们做出预测值与实际值的图像
plot(potato_actual,'*','color',[29 131 8]/255);hold on
plot(prediction,'-o','color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',14,'MarkerEdgecolor',[138 151 123]/255);
legend('actua value','prediction')
title('预测训练集本身数据')
%使得坐标图优美
xlabel('potato'),ylabel('weight')
 set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'on', 'YMinorTick', 'on', 'YGrid', 'on', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],'LineWidth', 1)