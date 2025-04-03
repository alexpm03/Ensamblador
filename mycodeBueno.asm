.model small
.stack 100h

.data
    msg1 db "Please, input first number (decimal, 0 to 255): $"
    msg2 db "Please, input second number (decimal, 0 to 255): $"
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

    num1 dw 0
    num2 dw 0
    choice db 0
    ResSuma dw 0
    ResResta12 dw 0
    ResResta21 dw 0
    ResMul dw 0
    ResDivCociente dw 0
    ResDivResto dw 0
    ResCambio1 dw 0 
    ResCambio2 dw 0
    hex_buffer db '0000$', 0 

.code
main:
    ; Inicializar el segmento de datos
    mov ax, @data
    mov ds, ax

    ; Solicitar el primer numero en decimal
    mov ah, 09h
    lea dx, msg1
    int 21h
    call salto_linea

    ; Leer el primer numero decimal (3 dígitos máximo)
    call leer_numero_decimal
    mov [num1], ax

    ; Solicitar el segundo número en decimal
    mov ah, 09h
    lea dx, msg2
    int 21h
    call salto_linea

    ; Leer el segundo número decimal (3 dígitos máximo)
    call leer_numero_decimal
    mov [num2], ax

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
    mov ax, [num1]
    add ax, [num2]
    mov [ResSuma], ax  ; Solo se guarda el byte bajo del resultado
    lea si, [ResSuma]
    jmp mostrar_resultado 
    mov cx, 16
    jmp print_bin

resta12:
    ; ResResta12 = num1 - num2
    mov ax, [num1]
    sub ax, [num2]
    mov [ResResta12], ax 
    lea si, [ResResta12]
    jmp mostrar_resultado 
    mov cx, 16
    jmp print_bin

resta21:
    ; ResResta21 = num2 - num1
    mov ax, [num2]
    sub ax, [num1]
    mov [ResResta21], ax 
    lea si, [ResResta21]
    jmp mostrar_resultado   
    mov cx, 16
    jmp print_bin

multiplicar:
    ; ResMul = num1 * num2
    mov ax, [num1]
    mov bx, [num2]
    imul bx              ; Multiplica AX * BX (el resultado se guarda en DX:AX)
    mov [ResMul], ax     ; Solo guardamos el byte bajo del resultado
    lea si, [ResMul]
    jmp mostrar_resultado   
    mov cx, 16
    jmp print_bin

dividir:
    ; ResDivCociente = num1 / num2, ResDivResto = num1 % num2
    mov ax, [num1]
    mov bx, [num2]
    xor dx, dx           ; Limpiar DX, para que AX contenga el número completo
    div bx               ; AX = cociente, DX = resto
    mov [ResDivCociente], ax
    mov [ResDivResto], dx
    lea si, [ResDivCociente]
    jmp mostrar_resultado  
    mov cx, 16
    jmp print_bin

cambiar1:
    ; ResCambio1 = -num1 (cambiar signo de num1)
    mov ax, [num1]
    neg ax
    mov [ResCambio1], ax
    lea si, [ResCambio1]
    jmp mostrar_resultado 
    mov cx, 16
    jmp print_bin

cambiar2:
    ; ResCambio2 = -num2 (cambiar signo de num2)
    mov ax, [num2]
    neg ax
    mov [ResCambio2], ax   
    lea si, [ResCambio2]
    jmp mostrar_resultado  
    mov cx, 16
    jmp print_bin

fin:
    ; Mensaje de salida
    mov ah, 09h
    lea dx, msg_end
    int 21h
    call salto_linea

    ; Finalizar el programa
    mov ah, 4Ch
    int 21h
    
salto_linea proc
    mov ah, 02h
    mov dl, 0Dh  ; Retorno de carro (CR)
    int 21h
    mov dl, 0Ah  ; Nueva línea (LF)
    int 21h
    ret
salto_linea endp

leer_numero_decimal:
    
    ; Leer el primer carácter
    mov ah, 01h          ; Función para leer un carácter
    int 21h              ; Leer un carácter del teclado
    sub al, 30h          ; Convertir de ASCII a número (de '0' a '9')
    mov bl, al           ; Guardar el primer dígito en BL

    ; Leer el segundo carácter
    mov ah, 01h          ; Función para leer un carácter
    int 21h              ; Leer un carácter
    sub al, 30h          ; Convertir de ASCII a número
    mov dl, al           ; Guardar el segundo dígito en BH

    ; Leer el tercer carácter
    mov ah, 01h          ; Función para leer un carácter
    int 21h              ; Leer un carácter
    sub al, 30h          ; Convertir de ASCII a número
    mov cl, al           ; Guardar el tercer dígito en CL

    ; Combinar los tres dígitos en AX utilizando multiplicación por 10
    mov ch, 00h 
    mov al, bl           ; Copiar el primer dígito a AL
    mov ah, 00h          ; Limpiar AH para usar AX correctamente

    ; Multiplicar el primer dígito por 10
    mov bl, 10d          ; Cargar 10 en BL
    mul bl               ; AX = AL * 10
    mov bx, ax           ; Guardar el resultado en BX (esto es el primer dígito multiplicado por 10)

    ; Ahora, sumar el segundo dígito al resultado
    mov al, dl           ; Copiar el segundo dígito en AL
    add ax, bx           ; Sumar lo que teníamos en BX (primer dígito * 10) al segundo dígito
    
    ; Multiplicar el resultado por 10
    mov bl, 10d          ; Cargar 10 en BL
    mul bl               ; AX = AX * 10

    ; Finalmente, añadir el tercer dígito
    add ax, cx           ; Sumar el tercer dígito (almacenado en CX) al resultado

    ; Verificación: En este punto, AX contiene el número final de 3 dígitos
    ; AX está en formato decimal, y debería ocupar hasta 16 bits (2 bytes)
    ; El número final está en AX, que es adecuado para 16 bits (máximo 999)


    ret                  ; Regresar al programa principal
       ; Devolver el número completo en AX

mostrar_resultado:
    ; Mostrar el mensaje de resultado
    mov ah, 09h
    lea dx, msg_result
    int 21h
    call salto_linea

    push ax       ; Guardar AX en la pila
    push dx       ; Guardar DX en la pila

    mov ax, [si]  ; Cargar el valor apuntado por SI en AX

    ; Imprimir el valor de AX en hexadecimal
    mov bx, ax    ; Guardar AX en BX para no modificarlo
    mov cx, 4     ; Número de dígitos hexadecimales (2 bytes = 4 dígitos)  
  

imprimir_hex:
    ; Obtener el nibble más significativo
    mov dx, bx        ; Mover el valor de BX a DX
    shr dx, 12        
    and dx, 0Fh       
    add dl, '0'       ; Convertir a ASCII
    cmp dl, '9'       ; Si es mayor que '9', es una letra A-F
    jbe imprimir1     
    add dl, 7         ; Convertir a letra A-F
imprimir1:
    mov ah, 02h       ; Funcion DOS para imprimir un carácter
    int 21h           ; Llamar a la interrupcion

    ; Mover el valor de BX a la derecha 4 bits para obtener el siguiente nibble
    shl bx, 4
    loop imprimir_hex ; Repetir para los otros 3 nibbles

    pop dx        ; Restaurar DX
    pop ax        ; Restaurar AX
    
    ; Retornar de la función
    call salto_linea
   
                
; --- SUBRUTINA PARA IMPRIMIR BINARIO ---  
mov ax, [si]  ; Cargar el valor apuntado por SI en AX 
print_bin proc
    push dx   ; guardamos dx en la pila
    push bx   ; guardamos bx en la pila
    push ax   ; guardamos ax en la pila
    mov cx, 16  ; 16 bits a procesar
    mov bx, ax  ; copiamos el valor de ax en bx para no modificarlo

    print_loop:
        rol bx, 1  ; desplazamos el bit más significativo a cf sin perder el valor original
        mov dl, '0' ; por defecto, imprimimos '0'
        jnc no_carry
        mov dl, '1' ; si cf está en 1, imprimimos '1'
    
    no_carry:
        mov ah, 02h  ; función de interrupción para imprimir un carácter
        int 21h
        loop print_loop  ; cx actúa como contador, cuando llega a 0 termina
    
    pop ax   ; restauramos ax
    pop bx   ; restauramos bx
    pop dx   ; restauramos dx
    cmp cx, 0    ; Compara CX con 0
    je fin       ; Si es igual (Zero Flag set), salta a la etiqueta fin
    ret
print_bin endp
exit_program:
    mov ah, 4ch  ; terminar programa
    int 21h     ; 
