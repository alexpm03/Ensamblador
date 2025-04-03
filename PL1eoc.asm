.model small
.stack 100h

.data
    msg1 db "Please, input first number (integer between 0 and 255): $"
    msg2 db "Please, input second number (integer between 0 and 255): $"
    msg3 db "Choose operation: $"
    msg4 db "1.- Add of both numbers.$"
    msg5 db "2.- Subtraction: the first number minus the second.$"
    msg6 db "3.- Subtraction: the second number minus the first.$"
    msg7 db "4.- Multiplication of the two numbers (unsigned).$"
    msg8 db "5.- Division: the first number divided by the second (unsigned).$"
    msg9 db "6.- Change the sign of the first number.$"
    msg10 db "7.- Change the sign of the second number.$"
    msg_result db "Result: $"
    msg_end db "Press any key to exit...$"

    num1 db 0
    num2 db 0
    choice db 0
    ResSuma db 0
    ResResta12 db 0
    ResResta21 db 0
    ResMul db 0
    ResDivCociente db 0
    ResDivResto db 0
    ResCambio1 db 0
    ResCambio2 db 0

.code
main:
    ; Inicializar el segmento de datos
    mov ax, @data
    mov ds, ax

    ; Solicitar el primer número
    call salto_linea
    mov ah, 09h
    lea dx, msg1
    int 21h
    

    ; Leer el primer número
    mov ah, 01h
    int 21h
    sub al, 30h        ; Convertir de ASCII a valor numérico
    mov [num1], al
    call salto_linea
    ; Solicitar el segundo número
    
    mov ah, 09h
    lea dx, msg2
    int 21h
    

    ; Leer el segundo número
    mov ah, 01h
    int 21h
    sub al, 30h        ; Convertir de ASCII a valor numérico
    mov [num2], al
    call salto_linea
    ; Mostrar el menú de operaciones
    mov ah, 09h
    lea dx, msg3
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg4
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg5
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg6
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg7
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg8
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg9
    int 21h
    call salto_linea
    mov ah, 09h
    lea dx, msg10
    int 21h
    call salto_linea

    ; Leer la opción elegida
    mov ah, 01h
    int 21h
    sub al, 30h         ; Convertir de ASCII a valor numérico
    mov [choice], al

    ; Procesar la opción elegida
    mov al, [choice]
    cmp al, 1
    je suma
    cmp al, 2
    je resta12
    cmp al, 3
    je resta21
    cmp al, 4
    je multiplicar
    cmp al, 5
    je dividir
    cmp al, 6
    je cambiar1
    cmp al, 7
    je cambiar2
    jmp fin

suma:
    ; ResSuma = num1 + num2
    mov al, [num1]
    add al, [num2]
    mov [ResSuma], al
    jmp mostrar_resultado

resta12:
    ; ResResta12 = num1 - num2
    mov al, [num1]
    sub al, [num2]
    mov [ResResta12], al
    jmp mostrar_resultado

resta21:
    ; ResResta21 = num2 - num1
    mov al, [num2]
    sub al, [num1]
    mov [ResResta21], al
    jmp mostrar_resultado

multiplicar:
    ; ResMul = num1 * num2
    mov al, [num1]
    mov bl, [num2]
    mul bl              ; multiplica al * bl (el resultado se guarda en AX)
    mov [ResMul], al    ; solo guardamos el byte bajo del resultado
    jmp mostrar_resultado

dividir:
    ; ResDivCociente = num1 / num2, ResDivResto = num1 % num2
    mov al, [num1]
    mov bl, [num2]
    xor ah, ah          ; Limpiar AH, para que AX contenga el número completo
    div bl              ; al = cociente, ah = resto
    mov [ResDivCociente], al
    mov [ResDivResto], ah
    jmp mostrar_resultado

cambiar1:
    ; ResCambio1 = -num1 (cambiar signo de num1)
    mov al, [num1]
    neg al
    mov [ResCambio1], al
    jmp mostrar_resultado

cambiar2:
    ; ResCambio2 = -num2 (cambiar signo de num2)
    mov al, [num2]
    neg al
    mov [ResCambio2], al
    jmp mostrar_resultado

mostrar_resultado:
    ; Mostrar el mensaje de resultado
    mov ah, 09h
    lea dx, msg_result
    int 21h
    call salto_linea

    ; Mostrar el resultado en pantalla (convertir a ASCII si es necesario)
    mov al, [ResSuma]
    add al, 30h          ; Convertir de valor numérico a ASCII
    mov dl, al
    mov ah, 02h
    int 21h              ; Mostrar el resultado
    call salto_linea

fin:
    ; Mensaje de salida
    mov ah, 09h
    lea dx, msg_end
    int 21h
    call salto_linea

    ; Finalizar el programa
    mov ah, 4Ch
    int 21h

salto_linea:
    ; Imprimir salto de línea (retorno de carro + salto de línea)
    mov dl, 0Dh        ; Retorno de carro (CR)
    mov ah, 02h
    int 21h

    mov dl, 0Ah        ; Salto de línea (LF)
    mov ah, 02h
    int 21h
    ret
