// ==============================================================================
// UNIFIED MAIN LINKER MODULE (main_linker.s)
// Coordinates the startup banner, allocator, and lexer execution engine
// ==============================================================================

.global main
.extern printf
.extern init_memory_arena
.extern lexer_main_loop

.data
    banner:         .asciz "=== HYBRID C/C++/C# ARM64 LANGUAGE RUNTIME ===\n"
    msg_alloc:      .asciz "[2/2] Initializing Memory Arena...\n"
    msg_lexer:      .asciz "[1/2] Running ASM Lexer Scanner & Parser...\n"
    msg_success:    .asciz "[Success] Code executed completely via ARM64 registers.\n"

.text
main:
    // Setup stack frame and link register
    stp     x29, x30, [sp, #-32]!
    mov     x29, sp

    // 1. Print Startup Banner
    ldr     x0, =banner
    bl      printf

    // 2. Initialize Memory Arena Allocator
    ldr     x0, =msg_alloc
    bl      printf
    bl      init_memory_arena

    // 3. Run Lexer & Parser Scanner
    ldr     x0, =msg_lexer
    bl      printf
    bl      lexer_main_loop

    // 4. Final Success Output
    ldr     x0, =msg_success
    bl      printf

    // Exit program successfully
    mov     w0, #0
    ldp     x29, x30, [sp], #32
    ret

