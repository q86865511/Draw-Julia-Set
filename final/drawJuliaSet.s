    .data
    .equ    FRAME_WIDTH, 640
    .equ    FRAME_HEIGHT,    480

    .text
    .global julia
/*
r0~r3 temp
r4 x
r5 y
r6 cY
r7 tmp
r8 zx
r9 zy
r10 i
r11 frame
*/
julia:
    stmfd   sp!,{r4-r11,ip,lr}
    mov r11,r1              @   operand2--1
    mov r6, r0
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    mov r4, #0              @   x   &&  operand2--2
    subs r0,r14,r13
loop:
    cmp r4, #FRAME_WIDTH    @   x<width
    bge done
    mov r5, #0              @   y
loop2:
    cmp r5, #FRAME_HEIGHT   @   y<height
    bge done2
@--------------------------------------------------------------------
    ldr ip, .constant
    mul r8, ip, r4
    ldr ip, .constant+12
    sub r8, r8, ip
    mov r0, r8
    mov r1, #320
    bl  __aeabi_idiv
    mov r8, r0
@--------------------------------------------------------------------
    mov ip, #1000
    mul r9, ip, r5
    ldr ip, .constant+16
    sub r9, r9, ip
    mov r0, r9
    mov r1, #240
    bl  __aeabi_idiv
    mov r9, r0
@--------------------------------------------------------------------
    mov r10,#255            @   i=maxIter=255
    mul r0, r8, r8
    mul ip, r9, r9
    add r2, r0, ip
    ldr r3, .constant+4
    cmp r2, r3
    bge donewhile
    cmp r10,#0
    ble donewhile

while:
    sub r0, r0, ip
    mov r1, #1000
    bl  __aeabi_idiv
    sub r7, r0, #700
@--------------------------------------------------------------------
    mul r0, r8, r9
    mov r1, #500
    bl  __aeabi_idiv
    add r9, r0, r6
@--------------------------------------------------------------------
    mov r8, r7
@--------------------------------------------------------------------
    sub r10,r10,#1
@--------------------------------------------------------------------
    mul r0, r8, r8
    mul ip, r9, r9
    add r2, r0, ip
    ldr r3, .constant+4
    cmp r2, r3
    bge donewhile
    cmp r10,#0
    ble donewhile
    b while

donewhile:
    and r10,r10,#0xff
    orr r10,r10,r10,lsl #8      @   operand2--3
    ldr r0, .constant+8
    bic r10,r0,r10

    mov r0, r11
    mov r1, #1280
    mul r1,r1,r5
    add r0,r0,r1
    mov r1, #1
    add r0,r0,r4,lsl r1         @   operand2--4
    strh    r10,[r0]
@--------------------------------------------------------------------
    add r5,r5,#1
    b   loop2

done2:
    add r4,r4,#1                @   x++
    b loop

done:
    ldmfd   sp!,{r4-r11,ip,lr}
    mov r0, #1
    cmp r0, #1
    moveq r0, #0                @   conditional execution--1
    cmp r0, #1
    movne pc,lr                 @   conditional execution--2

.constant:
    .word   1500
    .word   4000000
    .word   0xffff
    .word   480000
    .word   240000
