
#
# Program name: multiply.s
# Author: Jack Kurowski
# Date: 11/7/2023
# Purpose: This program calculates the product of 2 numbers
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
   LDR r2, =number2
   BL scanf
   LDR r1, =number1
   LDR r1, [r1]
   LDR r2, =number2
   LDR r2, [r2]

   # Set args and branch to mult
   MOV r0, r1
   MOV r1, r2
   BL mult

   # Print result
   MOV r1, r0
   LDR r0, =output
   BL printf

   # Return to the OS
   LDR lr, [sp, #0]
   ADD sp, sp, #4
   MOV pc, lr

.data
   number2: .word 0
   number1: .word 0
   prompt1: .asciz "Enter 2 numbers to multiply\n"
   input1: .asciz "%d %d"
   output: .asciz "The product is %d\n"
#End main


.text
.global mult

mult:

   # Push
   SUB sp, sp, #16
   STR lr, [sp, #0]
   STR r4, [sp, #4]
   STR r5, [sp, #8]
   STR r6, [sp, #12]

   # Store variables that need to be retained when branching in regs > 3
   MOV r4, r0
   MOV r5, r1


   CMP r5, #0
   BGT Else2
   # if error block
      LDR r0, =errMsg
      BL printf
      B Return
   # end if error block
   Else2:
      CMP r5, #1
      BNE Else  // if n == 1
      # if block
         # return m
         MOV r0, r4
         B Return
      # end if block
      B EndIf
      Else: 
      # else block
         # call mult(r0=m, r1=n-1)
         MOV r0, r4
         SUB r1, r5, #1
         BL mult
         ADD r0, r0, r4
         B Return
      # end else block
      EndIf: 
      # end if/else
   EndIf2:

   # Pop
   Return:
      LDR lr, [sp, #0]
      LDR r4, [sp, #4]
      LDR r5, [sp, #8]
      LDR r6, [sp, #12]
      ADD sp, sp, #16
      MOV pc, lr

.data
   errMsg: .asciz "You must enter a number greater than zero!!!\n"
