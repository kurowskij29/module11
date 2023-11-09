

#
# Program name: calcFib.s
# Author: Jack Kurowski
# Date: 11/7/2023
# Purpose: This program calculates the fibonacci number of an input
#

.text
.global main
main:

   # Save return to os on stack
   SUB sp, sp, #4
   STR lr, [sp, #0]

   # Prompt For An Input
   LDR r0, =prompt1
   BL  printf

   #Scanf
   LDR r0, =input1
   LDR r1, =number1
   BL scanf
   LDR r1, =number1
   LDR r1, [r1]

   # Set args and branch to mult
   MOV r0, r1
   BL fib

   # Print result
   MOV r1, r0
   LDR r0, =output
   BL printf

   # Return to the OS
   LDR lr, [sp, #0]
   ADD sp, sp, #4
   MOV pc, lr

.data
   number1: .word 0
   prompt1: .asciz "Enter a number to calculate the Fibonacci number of\n"
   input1: .asciz "%d"
   output: .asciz "The Fibonacci number is %d\n"
#End main


# Function
#
# fib(r0) calculates the fibonacci number of an input
# Inputs
#     r0 - input integer
# Variables
#     r4 - store input number
#     r5 - fib(n-1)
#     r6 - fib(n-2)
# Outputs
#     r0 - fibonacci number

.text
.global fib

fib:

   # Push
   SUB sp, sp, #16
   STR lr, [sp, #0]
   STR r4, [sp, #4]
   STR r5, [sp, #8]
   STR r6, [sp, #12]

   # Store variables that need to be retained when branching in regs > 3
   MOV r4, r0

   CMP r4, #0
   BGE Else2
   # if error block
      LDR r0, =errMsg
      BL printf
      MOV r0, #-1
      B Return
   # end if error block
   Else2:
      CMP r4, #0
      BNE Elif1  // return 0 for fib(0)
      # if1 block
         MOV r0, #0
         B Return
      # end if block
      Elif1:
      CMP r4, #1
      BNE Else // return 1 for fib(1)
      # if2 block
         MOV r0, #1
         B Return
      # end if block
      Else: 
      # else block
         # calc fib(n-1) and store in r5
         SUB r0, r4, #1
         BL fib
         MOV r5, r0
         # calc fib(n-2) and store in r6
         SUB r0, r4, #2
         BL fib
         MOV r6, r0
         # add fib(n-1) and fib(n-2)
         ADD r0, r5, r6
         B Return
      # end else block
      EndIf: 
      # end if/else
   EndIf2:

   Return:
      # Pop
      LDR lr, [sp, #0]
      LDR r4, [sp, #4]
      LDR r5, [sp, #8]
      LDR r6, [sp, #12]
      ADD sp, sp, #16
      MOV pc, lr

.data
   errMsg: .asciz "You must enter a positive number!!!\n"
