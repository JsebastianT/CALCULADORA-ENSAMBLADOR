section .data
    prompt db "Calculadora RPN: Ingresa dos numeros y una operacion (+, -, *, /, %). Escribe 'exit' para salir.", 0
    error_div_zero db "Error: Division por cero no permitida.", 0
    newline db 0xA, 0
    result_msg db "Resultado: ", 0
    exit_cmd db "exit", 0
    input_format_error db "Formato invalido. Intenta nuevamente.", 0

section .bss
    num1 resb 4            ; Espacio para el primer número
    num2 resb 4            ; Espacio para el segundo número
    operator resb 1        ; Espacio para el operador
    input resb 20          ; Buffer para la entrada del usuario

section .text
    global _start

_start:
    ; Mensaje de bienvenida
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, prompt        ; mensaje
    mov edx, 83            ; longitud del mensaje
    int 0x80               ; llamada al sistema

    ; ¿Es 'exit'? Si es así, ¡nos vamos!
    mov ecx, input
    mov edi, exit_cmd
    mov esi, 4             ; longitud de 'exit'
    repe cmpsb
    je exit_program        ; si dice 'exit', salir del programa

    ; Procesamos la entrada
    call parse_input       ; llame a la función que separa números y operador

    ; Realizar la operación
    call calculate_result

    ; Mostrar el resultado
    call print_result

    ; Volver a pedir entrada
    jmp read_input

exit_program:
    ; Aquí terminamos el programa
    mov eax, 1             ; sys_exit
    xor ebx, ebx           ; estado de salida 0
    int 0x80               ; llamada al sistema

parse_input:
    ; Separar los números y el operador de la entrada
    ; Obteniendo el primer número
    mov eax, [input]
    sub eax, '0'           ; Convertimos el carácter a un número
    mov [num1], eax        ; Guardamos el primer número

    ; Obteniendo el segundo número
    mov eax, [input + 2]
    sub eax, '0'
    mov [num2], eax        ; Guardamos el segundo número

    ; Obteniendo el operador
    mov al, [input + 4]
    mov [operator], al     ; Guardamos el operador
    ret

calculate_result:
    ; Cargamos num1 y num2
    mov eax, [num1]
    mov ebx, [num2]

    ; Verificamos qué operación hacer
    mov al, [operator]
    cmp al, '+'
    je do_addition
    cmp al, '-'
    je do_subtraction
    cmp al, '*'
    je do_multiplication
    cmp al, '/'
    je do_division
    cmp al, '%'
    je do_modulus
    jmp input_format_error  ; Si no es un operador válido, mostrar error

do_addition:
    add eax, ebx            ; Hacemos la suma
    ret

do_subtraction:
    sub eax, ebx            ; Hacemos la resta
    ret

do_multiplication:
    imul ebx                ; Multiplicamos
    ret

do_division:
    ; Comprobamos si estamos dividiendo por cero
    cmp ebx, 0
    je division_by_zero
    xor edx, edx            ; Limpiamos edx antes de dividir
    div ebx                  ; Hacemos la división
    ret

do_modulus:
    cmp ebx, 0              ; Comprobamos si el divisor es cero
    je division_by_zero
    xor edx, edx            ; Limpiamos edx antes de dividir
    div ebx                  ; Hacemos la división
    mov eax, edx            ; Guardamos el residuo
    ret

division_by_zero:
    ; Mensaje de error si hay división por cero
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, error_div_zero  ; mensaje de error
    mov edx, 34             ; longitud del mensaje
    int 0x80
    ret

print_result:
    ; Mostrar "Resultado: "
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, result_msg     ; mensaje
    mov edx, 11             ; longitud del mensaje
    int 0x80

    ; Convertir el valor de eax (resultado) a carácter ASCII
    add eax, '0'            ; Convertimos el número a carácter
    mov [num1], eax         ; Guardamos el resultado convertido

    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, num1           ; Mostramos el resultado
    mov edx, 1              ; longitud (un carácter)
    int 0x80

    ; Mostrar nueva línea
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, newline        ; Salto de línea
    mov edx, 1              ; longitud
    int 0x80
    ret