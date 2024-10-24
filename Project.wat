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
