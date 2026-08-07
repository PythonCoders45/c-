// ==============================================================================
// MEMORY ARENA ALLOCATOR MODULE (allocator.s)
// ==============================================================================

.global init_memory_arena
.extern printf

.data
    msg_arena_init: .asciz "[Allocator] Initializing C-style raw memory arena (64KB)...\n"

.text
init_memory_arena:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    ldr     x0, =msg_arena_init
    bl      printf

    ldp     x29, x30, [sp], #16
    ret
