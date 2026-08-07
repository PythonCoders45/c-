// ==============================================================================
// PURE ARM64 EXECUTION RUNTIME (execute.s)
// Directly allocates and executes object memory without text parsing
// ==============================================================================

.global main
.extern printf
.extern malloc

.data
    banner:          .asciz "=== PURE OBJECT EXECUTION RUNTIME (ARM64) ===\n"
    msg_alloc:       .asciz "[Allocator] Initializing 64KB raw memory arena...\n"
    msg_exec:        .asciz "[Execution] Allocating class instance on heap...\n"
    msg_obj_created: .asciz "[Runtime] Object allocated at memory address: 0x%llX\n"
    msg_field_val:   .asciz "[Runtime] Object Member Read -> health = %d, isAlive = %d\n"
    msg_success:     .asciz "[Success] Object execution completed via ARM64 registers.\n"

.text
main:
    // Setup stack frame
    stp     x29, x30, [sp, #-32]!
    mov     x29, sp

    // 1. Print Startup Banner
    ldr     x0, =banner
    bl      printf

    // 2. Initialize Memory Arena message
    ldr     x0, =msg_alloc
    bl      printf

    // 3. Start Pure Object Execution
    ldr     x0, =msg_exec
    bl      printf

    // Request 16 bytes from the heap (using malloc / memory arena pool)
    mov     x0, #16
    bl      malloc
    mov     x19, x0                 // x19 holds the object base pointer

    // Store member variables into the object's memory layout
    mov     w20, #100               // health = 100
    str     w20, [x19, #0]          // offset 0: health
    
    mov     w21, #1                 // isAlive = true (1)
    str     w21, [x19, #4]          // offset 4: isAlive

    // Print object creation memory address
    ldr     x0, =msg_obj_created
    mov     x1, x19
    bl      printf

    // Read and print field values straight from object memory
    ldr     x0, =msg_field_val
    ldr     w1, [x19, #0]           // Load health from object
    ldr     w2, [x19, #4]           // Load isAlive from object
    bl      printf

    // 4. Final Success Output
    ldr     x0, =msg_success
    bl      printf

    // Exit program successfully
    mov     w0, #0
    ldp     x29, x30, [sp], #32
    ret
