    .data
fmtInput:   .string "%d"
pornot: .asciz "p"
anotherfmt: .string "%s"
id1:    .word   0
id2:    .word   0
id3:    .word   0
idsum:  .word   0
command:    .word  0
changeline: .asciz  "\n"
tab:    .asciz  "   "
first:  .asciz  "*****Input ID*****\n"
output1: .asciz  "** Please  Enter   Member  1   Id:**\n"
output2: .asciz  "** Please  Enter   Member  2   Id:**\n"
output3: .asciz  "** Please  Enter   Member  3   Id:**\n"
outputc: .asciz  "** Please  Enter   Command **\n"
outputp: .asciz  "*****Print Team    Member  Id  and Id  Summation*****\n"
outputpa:   .asciz  "*****Print All*****\n"
outputs: .asciz  "ID Summation   =   "
last:   .asciz  "*****End   Print*****\n"
hpy:    .asciz  ".*.*.*.<:: Happy New Year ::.*.*.*.\nby Team 16\n"

    .text
    .globl  printmain
    .globl  id
    .globl  happy
id:
    stmfd   sp!,{lr}
    ldr r0, =first  @   "*****Print ID*****\n"
    bl  printf

    ldr r0, =output1    @   "** Please  Enter   Member  1   Id:**\n"
    bl  printf
    ldr r0, =fmtInput
    ldr r1, =id1
    bl  scanf

    ldr r0, =output2    @   "** Please  Enter   Member  2   Id:**\n"
    bl  printf
    ldr r0, =fmtInput
    ldr r1, =id2
    bl  scanf

    ldr r0, =output3    @   "** Please  Enter   Member  3   Id:**\n"
    bl  printf
    ldr r0, =fmtInput
    ldr r1, =id3
    bl  scanf

    ldr r0, =id1        @do sum and print
    ldr r0, [r0]
    ldr r1, =id2
    ldr r1, [r1]
    ldr r2, =id3
    ldr r2, [r2]
    cmp r0, r1
    addne   r1, r1, r0  @conditional execution   1
    moveq   r0,#2       @conditional execution   2
    muleq   r1,r1,r0    @if(r0  ==  r1) do r1*2 else    r0+r1
    add r1, r1, r2
    ldr r3, =idsum
    str r1, [r3]

    ldr r0, =outputc    @   "** Please  Enter   Command **\n"
    bl  printf
    ldr r0, =anotherfmt @   %s
    ldr r1, =command
    bl  scanf

    ldr r1, =command
    ldrb    r1, [r1,#+0]    @addressing mode    1
    ldr r2, =pornot
    ldrb    r2, [r2,#0]     @addressing mode    2
                            @get the string  and compare(al  ==  alaways
    cmpal r1, r2            @operand2   1 &&  conditional execution   3
    bleq    printallnum     @if  r1  ==  r2  ==  p   go  for printidandsum

    ldr r0, =last           @"*****End   Print*****\n"
    bl  printf

    mov r0,#0               @operand2   2
    ldmfd   sp!,{lr}
    mov pc,lr,  ASR #0      @operand2   3

printallnum:
    stmfd   sp!,{lr}
    ldr r0, =outputp        @"*****Print Team    Member  Id  and Id  Summation*****\n"
    bl  printf

    ldr r0, =fmtInput
    ldr r2, =id1
    ldr r1, [r2],#0         @addressing mode    3
    bl  printf

    ldr r0, =changeline
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id2
    mov r2, #0
    ldr r1, [r1,r2] @addressing mode    4
    bl  printf

    ldr r0, =changeline
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id3
    ldr r1, [r1]
    bl  printf

    ldr r0, =changeline
    bl  printf
    ldr r0, =changeline
    bl  printf

    ldr r0, =outputs
    bl  printf

    ldr r1, =idsum
    ldr r1, [r1]
    ldr r0, =fmtInput
    bl  printf
    ldr r0, =changeline
    bl  printf


    mov r0, #0
    ldmfd   sp!,{lr}
    mov pc,lr

printmain:  @just like printallnum but also print name
    stmfd   sp!,{lr}
    ldr r0, =outputpa
    bl  printf
    bl  gett
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id1
    ldr r1, [r1]
    bl  printf
    ldr r0, =tab
    bl  printf
    bl  getn1
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id2
    ldr r1, [r1]
    bl  printf
    ldr r0, =tab
    bl  printf
    bl  getn2
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id3
    ldr r1, [r1]
    bl  printf
    ldr r0, =tab
    bl  printf
    bl  getn3
    bl  printf

    ldr r0, =outputs
    bl  printf
    ldr r1, =idsum
    ldr r1, [r1]
    ldr r0, =fmtInput
    bl  printf
    ldr r0, =changeline
    bl  printf

    ldr r0, =last
    bl  printf

    mov r0, #0
    ldmfd   sp!,{lr}
    mov pc,lr

happy:
    stmfd   sp!,{lr}
    ldr r0, =hpy
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id1
    ldr r1, [r1]
    bl  printf
    ldr r0, =tab
    bl  printf
    bl  getn1
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id2
    ldr r1, [r1]
    bl  printf
    ldr r0, =tab
    bl  printf
    bl  getn2
    bl  printf

    ldr r0, =fmtInput
    ldr r1, =id3
    ldr r1, [r1]
    bl  printf
    ldr r0, =tab
    bl  printf
    bl  getn3
    bl  printf

    mov r0, #0
    ldmfd   sp!,{lr}
    mov pc,lr

