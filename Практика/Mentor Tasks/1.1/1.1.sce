x_min = 0;
x_max = %pi;
step = 0.1;
x = x_min:step:x_max;
y = 2 + cos(x);
plot(x, y);
xlabel('x');
ylabel('y');
title('Графік функції y = 2 + cos(x)');
disp('Таблиця значень функції y = 2 + cos(x)');
disp('x          y');
for i = 1:length(x)
    disp([x(i), y(i)]);
end