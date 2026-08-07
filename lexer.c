.global lexer_main_loop
.extern printf

.data
script_buffer:   .asciz "class GameEngine { int score = 100; }"
msg_lexer_start: .asciz "[Lexer] Scanning source stream character-by-character...\n"
msg_found_tok:   .asciz "  [Lexer Token] Found: %s\n"

.bss
.align 4
local_lexeme:    .space 64

.text
lexer_main_loop:
    stp     x29, x30, [sp, #-32]!
    mov     x29, sp

    ldr     x0, =msg_lexer_start
    bl      printf

    ldr     x19, =script_buffer
    mov     x20, #0

.scan_loop:
    ldrb    w21, [x19], #1
    cmp     w21, #0
    b.eq    .lexer_done

    cmp     w21, #32
    b.eq    .process_token

    ldr     x22, =local_lexeme
    add     x22, x22, x20
    strb    w21, [x22]
    add     x20, x20, #1
    b       .scan_loop

.process_token:
    cmp     x20, #0
    b.eq    .scan_loop

    ldr     x22, =local_lexeme
    add     x22, x22, x20
    mov     w23, #0
    strb    w23, [x22]

    sub     sp, sp, #16
    ldr     x0, =msg_found_tok
    ldr     x1, =local_lexeme
    bl      printf
    add     sp, sp, #16

    mov     x20, #0
    b       .scan_loop

.lexer_done:
    mov     x0, #0
    ldp     x29, x30, [sp], #32
    ret

