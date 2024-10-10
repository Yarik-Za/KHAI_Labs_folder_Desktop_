.model small

.data
    a       db  ?     ; Переменная A
    b       db  ?     ; Переменная B
    c       db  ?     ; Переменная C
    d       db  ?     ; Переменная D
    x       dw  ?     ; Переменная X для результата
    msg_a   db  'Enter value for A: $'   ; Сообщение для ввода A
    msg_b   db  'Enter value for B: $'   ; Сообщение для ввода B
    msg_c   db  'Enter value for C: $'   ; Сообщение для ввода C
    msg_d   db  'Enter value for D: $'   ; Сообщение для ввода D
    x_msg   db  'Result x: $'             ; Сообщение с результатом
    pkey    db  'Press any key to exit...$'  ; Сообщение для выхода

.stack 100h

.code
start:
    mov  ax, @data
    mov  ds, ax
    mov  es, ax

    ; Ввод значения для переменной A
    lea  dx, msg_a      ; Загружаем адрес сообщения для A
    mov  ah, 09h
    int  21h

    mov  ax, offset a   ; Загружаем адрес переменной A
    call input_number   ; Вызываем процедуру ввода числа

    ; Ввод значения для переменной B
    lea  dx, msg_b      ; Загружаем адрес сообщения для B
    mov  ah, 09h
    int  21h

    mov  ax, offset b   ; Загружаем адрес переменной B
    call input_number   ; Вызываем процедуру ввода числа

    ; Ввод значения для переменной C
    lea  dx, msg_c      ; Загружаем адрес сообщения для C
    mov  ah, 09h
    int  21h

    mov  ax, offset c   ; Загружаем адрес переменной C
    call input_number   ; Вызываем процедуру ввода числа

    ; Ввод значения для переменной D
    lea  dx, msg_d      ; Загружаем адрес сообщения для D
    mov  ah, 09h
    int  21h

    mov  ax, offset d   ; Загружаем адрес переменной D
    call input_number   ; Вызываем процедуру ввода числа

    ; Вычисление значения x =(a*2+b*c)/(d-3)
    mov  al, 2
    mul  a
    mov  cx, ax

    mov  al, b
    mul  c
    add  ax, cx

    mov  cl, d
    sub  cl, 3
    div  cl

    mov  x, ax

    ; Вывод результата x
    lea  dx, x_msg      ; Загружаем адрес сообщения с результатом
    mov  ah, 09h
    int  21h

    ; Вывод значения x
    mov  ax, x
    call print_num

    ; Переход на новую строку перед запросом нажатия любой кнопки
    mov  dx, 13        ; ASCII для "возврат каретки" (CR)
    mov  ah, 02h
    int  21h

    mov  dx, 10        ; ASCII для "перевод строки" (LF)
    mov  ah, 02h
    int  21h

    ; Вывод сообщения "Press any key to exit..."
    lea  dx, pkey       ; Загружаем адрес сообщения для выхода
    mov  ah, 09h
    int  21h

    ; Ожидание нажатия любой клавиши
    mov  ah, 0
    int  16h

    ; Выход из программы
    mov  ax, 4C00h
    int  21h

print_num proc near
    push ax
    push bx
    push cx
    push dx

    mov  bx, 10
    xor  cx, cx

next_digit:
    xor  dx, dx
    div  bx
    push dx
    inc  cx
    test ax, ax
    jnz  next_digit

print_next_digit:
    pop  dx
    add  dl, '0'
    mov  ah, 02h
    int  21h
    loop print_next_digit

    pop  dx
    pop  cx
    pop  bx
    pop  ax
    ret
print_num endp

input_number proc near
    push ax
    push bx
    push cx

    mov  si, ax         ; SI указывает на адрес переменной для сохранения числа

input_loop:
    mov  ah, 01h        ; Считываем символ с клавиатуры
    int  21h

    cmp  al, 13         ; Проверяем, был ли введен символ "Enter" (CR)
    je   done_input     ; Если да, завершаем ввод

    sub  al, '0'        ; Преобразуем символ цифры в числовое значение
    mov  bl, al

    ; Умножаем текущее значение на 10 и добавляем новую цифру
    mov  al, [si]       ; Загружаем текущее значение
    mov  ah, 0          ; Очищаем AH для умножения
    mov  cl, 10         ; Умножаем на 10
    mul  cl
    add  ax, bx         ; Добавляем новую цифру
    mov  [si], al       ; Сохраняем новое значение

    jmp  input_loop     ; Повторяем процесс ввода

done_input:
    pop  cx
    pop  bx
    pop  ax
    ret
input_number endp

end start
