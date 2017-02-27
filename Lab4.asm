;RUCHI SHETH
;rjsheth
;CMPE12/L
;MAXWELL DUNNE
;LAB 4: CAESER'S CIPHER

;README
;I HAVE USED ROW MAJOR AS MY ARRAY SETUP
;WHENEVER R2 (WHICH IS THE REGISTER I USE TO KEEP TRACK OF MY ROW) IS 0, IT'S ROW IS 0; WHEN R2 IS 199, IT'S ROW 1. 
;COLUMN NUMBERS ARE INCREMENTED AS NEEDED

.ORIG X3000
START
   AND R0, R0, 0    ;userinput
   AND R1, R1, 0    ;CIPHER
   AND R2, R2, 0    ;dummy register
   AND R3, R3, 0    ;dummy register
   AND R4, R4, 0    ;DIG
   AND R5, R5, 0    ;flag for E
   AND R6, R6, 0    ;FLAG for D
   AND R7, R7, 0    ;unused

GREET_F 
   LEA	R0, GREETING      ;Hello, welcome to my Caesar Cipher program 
   PUTS 

E_OR_D
   AND R0, R0, 0    ;userinput
   AND R1, R1, 0    ;CIPHER
   AND R2, R2, 0    ;dummy register
   AND R3, R3, 0    ;dummy register
   AND R4, R4, 0    ;DIG
   AND R5, R5, 0    ;flag for E
   AND R6, R6, 0    ;FLAG for D
   AND R7, R7, 0    ;unused

   LEA R0, GREETING1      ;Do you want to (E)ncrypt or D(ecrypt) or e(X)it? 
   PUTS  
   BR LOOP

GREETING:	.STRINGZ	"Hello, welcome to my Caesar Cipher Program."
GREETING1:      .STRINGZ        "\nDo you want to (E)ncrypt or (D)ecrypt or e(X)it?\n>"

LOOP 
   GETC 
   PUTC                    
   ST R0, USERINPUT

   LD R3, EIG             
   ADD R2, R0, R3          ;If x then dead
   BRz DONE

   LD R2, E_n              
   ADD R1, R0, R2          ;check if E then encrypt+1
   BRz ENCRYPT_P

   AND R2, R2, 0
   LD R2, D_n            
   ADD R3, R0, R2          ;check if D then Decrypt+1
   BRz DECRYPT_P

ENCRYPT_P
   ADD R6, R6, 1           ;flag+1
   BR  CIPHER              ;E becomes 1

DECRYPT_P
   ADD R6, R6, -1          ;flag+1
   BR CIPHER               ;D becomes 1

CIPHER
   LEA R0, EN_P           ;What is the cipher (1-25)?
   PUTS
   AND R1, R1, 0
   BR CIPHER_LOOP 

CIPHER_LOOP
   GETC
   PUTC 
   ADD R3, R0, -10         ;(CARRAIGE RETURN) R3 becomes zero if added with -10
   BRz SECONDLOOP
   AND R3, R3, 0
   LD R3, DIG
   ADD R4, R0, R3          ;Digit is in single character decimal form       
   BR MULT
MULT
   AND R3, R3, 0  
   ADD R3, R3, R1
   ADD R5, R5, 9
MULT_2   
   BRz AFTER_MULT
   ADD R1, R3, R1
   ADD R5, R5, -1
   BR MULT_2
AFTER_MULT 
   ADD R1, R1, R4          ;INT = INT+digit
   BR CIPHER_LOOP          ;CIPHER              

;---------------------------------------------------------------------------------
SECONDLOOP 
   AND R0, R0, 0           ;userinput
   AND R2, R2, 0           ;row
   AND R3, R3, 0           ;column
   AND R4, R4, 0           ;MYARRAY
   BR FOR_MYARRAY
MYARRAY_BACK
   LEA	R0, S_PROMPT       ;What is the string (up to 200 characters)? 
   PUTS
   BR STORE_LOOP

S_PROMPT        .STRINGZ        "What is the string (up to 200 characters)?\n>"

STORE_LOOP
   GETC
   PUTC
   ADD R5, R0, -10         ;(CARRAIGE RETURN) R5 becomes zero if added with -10
   BRz CHECK
   ADD R2, R2, #0          ;row value
   ADD R3, R3, #0          ;column value
   JSR STORE
   BR STORE_LOOP
ENC
   JSR ENCRYPT
   BR PRINT
   BR E_OR_D
DEC
   NOT R1, R1               ;INT = !INT
   ADD R1, R1, 1 
   JSR DECRYPT
   BR PRINT
   BR E_OR_D

;---------------------------------------------------------------------------------
ENCRYPT
   ST R7, FALTU 
   AND R6, R6, 0
BRANCH_LOAD
   AND R2, R2, 0
   JSR LOAD
   AND R5, R5, 0
   ADD R5, R0, #0            ;check if null character
   BRz BR_RET
   LD R5, A
   ADD R5, R0, R5            ;checks if less than ascii of A           
   BRzp GO
   BRn INCRE
GO
   LD R5, Z                  ;check if greater than ascii of Z
   ADD R5, R0, R5 
   BRnz ADD_CI
   BRp NEXT
NEXT LD R5, F_a              
   ADD R5, R0, R5            ;check if lesser than a
   BRzp LAST 
   BRn INCRE
LAST LD R5, F_z             ;check if greater than z
   ADD R5, R0, R5
   BRnz ADD_CI
   BRp INCRE
ADD_CI
   ADD R0, R0, R1            ;adding cipher
   LD R5, Z                  ;wrapping if greater than Z
   ADD R5, R0, R5
   BRp WRAP_2
   BRnz INCRE
WRAP LD R5, T_6
   ADD R0, R0, R5            ;wrapping with negative 26
   BR INCRE
WRAP_2 
   LD R5, F_a              
   ADD R5, R0, R5            ;check if lesser than a
   BRn WRAP 
   LD R5, F_z                ;wrapping if greater than z
   ADD R5, R0, R5
   BRp WRAP
INCRE
   LD R5, ONN
   ADD R2, R2, R5            ;adds 199 ("row 1")
   JSR STORE
   BR F_A   
B_A                          ;points back to ahead of array
   ADD R6, R6, #1
   ADD R4, R4, R6            ;Increments column
   BR BRANCH_LOAD
BR_RET
   LD R7, FALTU
   RET
;----------------------------------------------------------------
DECRYPT 
   ST R7, FALTU 
   AND R6, R6, 0
BRANCH_LOAD_1
   AND R2, R2, 0
   JSR LOAD
   AND R5, R5, 0
   ADD R5, R0, #0            ;check if null character
   BRz BR_RET_1
   LD R5, A
   ADD R5, R0, R5            ;checks if less than ascii of A           
   BRzp GO_1
   BRn INCRE_1
GO_1
   LD R5, Z                  ;check if greater than ascii of Z
   ADD R5, R0, R5 
   BRnz ADD_CI_1
   BRp NEXT_1
NEXT_1
   LD R5, F_a              
   ADD R5, R0, R5            ;check if lesser than a
   BRzp LAST_1 
   BRn INCRE_1
LAST_1
   LD R5, F_z                ;check if greater than z
   ADD R5, R0, R5
   BRnz ADD_CI_1
   BRp INCRE_1
ADD_CI_1
   ADD R0, R0, R1            ;adding cipher
   LD R5, A                  ;checking if less than A
   ADD R5, R0, R5
   ;BRn INCRE_1
   BR WRAP_3
WRAP_1 LD R5, PT_6
   ADD R0, R0, R5            ;wrapping with 26
   BR INCRE_1
WRAP_3
   LD R5, F_a                ;wrapping if less than a
   ADD R5, R0, R5
   BRn WRAP_1
INCRE_1
   LD R5, ONN
   ADD R2, R2, R5            ;adds 199 ("row 1")
   JSR STORE
   LEA R4, MYARRAY           ;points back to ahead of array
   ADD R6, R6, #1
   ADD R4, R4, R6            ;Increments column
   BR BRANCH_LOAD_1
BR_RET_1
   LD R7, FALTU
   RET
;---------------------------------------------------------------------

PRINT
   ST R7, FALTU_1
   ADD R6, R6, 0
   BRn DEC_P
   BRp ENC_P
DEC_P
   LEA R0, NEWLINE      ;"\nHere is your string and the decrypted result\n<Encrypted>"
   PUTS  
   LEA R0, MYARRAY
   PUTS
   LEA R0, D_P          ;"\n<Decrypted>"
   PUTS  
   LEA R0, MYARRAY
   LD R5, ONN           ;"row1"
   ADD R0, R0, R5
   PUTS
   BR BR_R
ENC_P
   LEA R0, NEWLINE_1      ;"\nHere is your string and the decrypted result\n<Encrypted>"
   PUTS  
   LEA R0, MYARRAY
   PUTS
   LEA R0, E_P          ;"\n<Encrypted>"
   PUTS  
   LEA R0, MYARRAY
   LD R5, ONN           ;"row1"
   ADD R0, R0, R5
   PUTS
   BR BR_R
BR_R
   LD R7, FALTU_1
   ADD R7, R7, 1
   RET

CHECK 
   LEA R4, MYARRAY
   ADD R6,R6,0                ;Check if to encrypt or decrypT
   BRp ENC
   BRn DEC

FOR_MYARRAY
   LEA R4, MYARRAY
   BR MYARRAY_BACK

F_A
   LEA R4, MYARRAY
   BR B_A

DONE HALT 

;VARIABLES
USERINPUT	.FILL	0
E_n             .FILL   -69 
D_n             .FILL   -68
EIG             .FILL   -88
DIG:            .FILL   -48
FALTU		.FILL	0
FALTU_1		.FILL	0
KUCH		.FILL 	89
A		.FILL	-65
Z		.FILL	-90
ONN		.FILL	199
F_a		.FILL	-97
F_z		.FILL	-122
T_6		.FILL	-26
PT_6		.FILL	26

;strings
EN_P            .STRINGZ        "\nWhat is the cipher (1-25)?\n>"
D_P		.STRINGZ	"\n<Decrypted> "
NEWLINE:	.STRINGZ        "Here is your string and the decrypted result\n<Encrypted> "
NEWLINE_1:	.STRINGZ        "Here is your string and the encrypted result\n<Decrypted> "
E_P		.STRINGZ	"\n<Encrypted> "
MYARRAY .BLKW 400

LOAD
   ST R7, FOR_PC_1
   ST R4, LOAD_V
   LDI R0, LOAD_V
   LD R7, FOR_PC_1
   RET

STORE
   ST R7, FOR_PC
   ADD R4, R4, R2          ;ADD ROW
   STR R0, R4, #0
   ADD R4, R4, #1
   LD R5, ZERO
   STR R5, R4, #0
   LD R7, FOR_PC
   RET

LOAD_V          .FILL	0
FOR_PC_1	.FILL	0
FOR_PC          .FILL   0
ZERO            .FILL   0
	.END         ; end of code
