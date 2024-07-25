function F = system_eq(variables)
    x = variables(1);
    y = variables(2);
    F(1) = x - x^2 - y^2 + 0.1;
    F(2) = y - 2*x*y + 0.1;
endfunction

x0=[0; 0];

// Використовуємо fsolve для знаходження розв'язку системи рівнянь
[solution, info] = fsolve(x0, system_eq);

// Виводимо результат
disp("Чисельний розвязок системи рівнянь:");
disp("x = "), disp(solution(1));
disp("y = "), disp(solution(2));
