function y = f(x)
    y = x^3 - 3*x^2 - 24*x - 5;
endfunction
// Початкове наближення
x0 = -5;
// Виклик fsolve
root = fsolve(x0, f);
disp("Знайдений корінь:");
disp(root);
