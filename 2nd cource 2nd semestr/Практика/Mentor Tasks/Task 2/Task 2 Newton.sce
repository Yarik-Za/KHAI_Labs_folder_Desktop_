function root = newtonRaphson(x0, epsilon, maxIterations)
    // Функція та її похідна
    function y = f(x)
        y = x^3 - 3*x^2 - 24*x - 5;
    endfunction

    function dy = df(x)
        dy = 3*x^2 - 6*x - 24;
    endfunction

    // Метод Ньютона
    x = x0;
    for i = 1:maxIterations
        fx = f(x);
        dfx = df(x);
        
        if abs(dfx) < epsilon then
            error("Похідна близька до нуля. Спробуйте інше початкове наближення.");
        end
        
        xNext = x - fx / dfx;
        
        if abs(xNext - x) < epsilon then
            root = xNext;
            return;
        end
        
        x = xNext;
    end
    
    error("Не вдалося знайти корінь в межах заданої точності.");
endfunction

// Виклик функції
x0 = 3; // Початкове наближення
epsilon = 1e-6; // Точність
maxIterations = 100; // Максимальна кількість ітерацій

root = newtonRaphson(x0, epsilon, maxIterations);
disp(root);
