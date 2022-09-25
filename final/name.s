    .data
first:  .asciz  "*****Print Name*****\n"
last:   .asciz  "*****End   Print*****\n"
team:   .asciz  "Team   16\n"
name1:  .asciz  "WeiLun Chou\n"
name2:  .asciz  "Henry  Wu\n"
name3:  .asciz  "ZiCen  Deng\n"
    .text
    .globl gett
    .globl getn1
    .globl getn2
    .globl getn3
    .globl printname
printname:
    stmfd   sp!,{lr}
    ldr r0,=first   @   "*****Print Name*****\n"
    bl  printf
    ldr r0,=team    @   "Team   16\n"
    bl  printf
    ldr r0,=name1
    bl  printf
    ldr r0,=name2
    bl  printf
    ldr r0,=name3
    bl  printf
    ldr r0,=last    @   "*****End   Print*****\n"
    bl  printf

    bl  done
    mov r13, r1
    ldmfd   sp!,{lr}
    mov pc,lr

done:
    mov r1, r13
    mov r13, #0
    add r15,r14,r13
gett:
    stmfd   sp!,{lr}
    ldr r0, =team
    ldmfd   sp!,{lr}
    mov pc, lr

getn1:
    stmfd   sp!,{lr}
    ldr r0, =name1
    ldmfd   sp!,{lr}
    mov pc, lr

getn2:
    stmfd   sp!,{lr}
    ldr r0, =name2
    ldmfd   sp!,{lr}
    mov pc, lr

getn3:
    stmfd   sp!,{lr}
    ldr r0, =name3
    ldmfd   sp!,{lr}
    mov pc, lr


    .end

