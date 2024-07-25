function F = system_eq(variables)
    x = variables(1);
    y = variables(2);
    F(1) = x - x^2 - y^2 + 0.1;
    F(2) = y - 2*x*y + 0.1;
endfunction

// Початкові наближення
initial_guess = [0.1; 0.1];

// Використовуємо fsolve для знаходження розв'язку системи рівнянь
[solution, info] = fsolve(initial_guess, system_eq);

// Виводимо результат
disp("Чисельний розвязок системи рівнянь:");
disp("x = "), disp(solution(1));
disp("y = "), disp(solution(2));

// Перевірка результату
disp("Перевірка:");
disp(system_eq(solution));
