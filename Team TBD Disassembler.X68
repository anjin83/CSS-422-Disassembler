*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

EXIT EQU $2700
PRINT_COUNT EQU 25

WORD_SIZE_CONST EQU 16

NIBBLES_PER_LONG_CONST EQU 8
BYTES_PER_LONG_CONST EQU 4
WORDS_PER_LONG_CONST EQU 2

SIXTEEN_BIT_DISP_CONST EQU $00
THIRTYTWO_BIT_DISP_CONST EQU $FF

*SIZE CODES
BYTE_CODE EQU 0
WORD_CODE EQU 1
LONG_CODE EQU 2

*ADDRESSING MODES
DATA_REGISTER_CONST     EQU %000
ADDRESS_REGISTER_CONST  EQU %001
NO_INC_DEC_CONST        EQU %010
POST_INC_CONST          EQU %011
PRE_DEC_CONST           EQU %100
D16_AN_CONST            EQU %101
D8_AN_XN_CONST          EQU %110
LITERAL_CONST           EQU %111

*ADDRESSING MODE EXTRA BYTE SPECIFYING REGISTERS
WORD_ADDRESS_CONST      EQU %000
LONG_ADDRESS_CONST      EQU %001
IMMEDIATE_CONST         EQU %100
D16_PC_CONST            EQU %010
D8_PC_XN_CONST          EQU %011

*16 BITS
NOP_CONST               EQU %0100111001110001
RTS_CONST               EQU %0100111001110101

*10 BITS
ASL_MEM_CONST           EQU %1110000111         *COMPLETE
ASR_MEM_CONST           EQU %1110000011         *COMPLETE
BCLR_STATIC_CONST       EQU %0000100010         *COMPLETE
JSR_CONST               EQU %0100111010         *COMPLETE
LSL_MEM_CONST           EQU %1110001111         *COMPLETE
LSR_MEM_CONST           EQU %1110001011         *COMPLETE
ROL_MEM_CONST           EQU %1110011111         *COMPLETE
ROR_MEM_CONST           EQU %1110011011         *COMPLETE

*9 BITS
MOVEM_REG_TO_MEM_CONST  EQU %010010001          *COMPLETE
MOVEM_MEM_TO_REG_CONST  EQU %010011001          *COMPLETE

*8 BITS
BCS_CONST               EQU %01100101           *COMPLETE                
BGE_CONST               EQU %01101100           *COMPLETE
BGT_CONST               EQU %01101110           *COMPLETE
BLE_CONST               EQU %01101111           *COMPLETE
BLS_CONST               EQU %01100011           *COMPLETE
BMI_CONST               EQU %01101011           *COMPLETE
BNE_CONST               EQU %01100110           *COMPLETE
BPL_CONST               EQU %01101010           *COMPLETE
BVS_CONST               EQU %01101001           *COMPLETE
BHI_CONST               EQU %01100010           *COMPLETE
BEQ_CONST               EQU %01100111           *COMPLETE
BLT_CONST               EQU %01101101           *COMPLETE
BRA_CONST               EQU %01100000           *COMPLETE
BVC_CONST               EQU %01101000           *COMPLETE

CMPI_CONST              EQU %00001100           *COMPLETE
NEG_CONST               EQU %01000100           *COMPLETE
ORI_CONST               EQU %00000000           *COMPLETE


*4 BITS
ADD_CONST               EQU %1101               *COMPLETE
ASL_ASR_REG_CONST       EQU %1110               *COMPLETE
BCLR_DYNAMIC_CONST      EQU %0000               
CMP_EOR_CONST           EQU %1011               *COMPLETE
DIVS_WORD_CONST         EQU %1000               *COMPLETE
LEA_CONST               EQU %0100               *COMPLETE               
LSL_LSR_REG_CONST       EQU %1110               
MULS_WORD_CONST         EQU %1100               *COMPLETE
OR_CONST                EQU %1000               *COMPLETE              
ROL_ROR_REG_CONST       EQU %1110               
SUB_CONST               EQU %1001               *COMPLETE
SUBQ_CONST              EQU %0101               *COMPLETE              

*2 BITS
MOVE_CONST EQU %00                          *COMPLETE

*OPMODES
BYTE_TO_DN_CONST EQU %000
BYTE_TO_EA_CONST EQU %100
WORD_TO_DN_CONST EQU %001
WORD_TO_EA_CONST EQU %101
LONG_TO_DN_CONST EQU %010
LONG_TO_EA_CONST EQU %110
WORD_TO_AN_CONST EQU %011
LONG_TO_AN_CONST EQU %111

*****2 BIT OPERATIONS: INDIVIDUAL CODES

*MOVE SIZES
MOVE_BYTE_CONST EQU %01
MOVE_WORD_CONST EQU %11
MOVE_LONG_CONST EQU %10

*****4 BIT OPERATIONS: INDIVIDUAL CODES

*ASL/ASR SIZES
ASL_ASR_BYTE_CONST EQU %00
ASL_ASR_WORD_CONST EQU %01
ASL_ASR_LONG_CONST EQU %10

    ORG    $1000
START:                  ; first instruction of program
***************************************LOOP CODE****************************************************

        JSR INPUT
        LEA COUNTER,A3
        JSR IF_BRANCH

IF_BRANCH 
        *MOVEM REGISTER_STORAGE, D2/D3/A3       * LOAD THE VALUE OF D2, D3 FROM MEMORY
        CMP.L D2,D3
        BEQ EXIT_LOOP                        *ARE WE AT THE END OF THE CODE TO DISASSEMBLE?
        CMP.L D2,D3
        BLT EXIT_LOOP
        MOVEM D3/A3, REGISTER_STORAGE       * SAVE THE VALUE OF D2, AND D3 IN MEMORY
        CLR.L D2
        CLR.L D3        
        JSR WHILE_LOOP
        JSR PROMPT_MESSAGE
        BRA IF_BRANCH 
        RTS
    
WHILE_LOOP
        CMP.B #0, (A3)                      *A3 STORES LOOP CONDITIONAL COUNTER
        BEQ PROMPT_MESSAGE
        MOVEM REGISTER_STORAGE, D3/A3       * LOAD THE VALUE OF D2 (STARTING ADDRESS), D3 (ENDING ADDRESS), A3 (COUNTER) FROM MEMORY
        MOVE.L A6,D2
        CMP.L D2,D3                             *CHECK TO SEE IF WE HAVE FINISHED
        BEQ EXIT_LOOP
        CMP.L D2,D3
        BLT EXIT_LOOP
        MOVEM D3/A3, REGISTER_STORAGE       * SAVE THE VALUE OF D2 (STARTING ADDRESS), D3 (ENDING ADDRESS), A3 (COUNTER) FROM MEMORY
        CLR.L D2
        CLR.L D3
        CMP.B #0,(A3)
        BEQ PROMPT_MESSAGE                      *AFTER PRINTING REQUISITE NUMBER OF LINES PROMPT USER TO PRINT NEXT SET OF OPCODES
        JSR PRINT_DISSASSEMBLY                  *PRINT OPCODE
        SUBQ.B #1,(A3)                          *DECREMENT COUNTER
        BRA WHILE_LOOP
        RTS
        

PROMPT_MESSAGE
        
        MOVE #14,D0                             *PROMPT USER TO PRINT NEXT SET OF OPCODES
        LEA PROMPT3, A1
        TRAP #15
        
        
        MOVE #4,D0
        TRAP #15
        CMP.L #1,D0
        BEQ EXIT_LOOP
        
        MOVE.B #25, COUNTER
        BRA WHILE_LOOP
        RTS 

INPUT
        MOVE #14,D0
        LEA PROMPT1, A1
        TRAP #15
    
        MOVE #4,D0
        TRAP #15
        MOVE.L D1,D2    *START ADDRESS OF ARRAY IN D2
    
        MOVE #14,D0
        LEA PROMPT2, A1
        TRAP #15
    
        MOVE #4,D0
        TRAP #15
        MOVE.L D1,D3    *END ADDRESS OF ARRAY IN D3
        *LEA TEST,A6
        MOVEA.L D2,A6
        RTS

PRINT_DISSASSEMBLY    
        JSR DISASSEMBLE_MAIN
        RTS 

  
EXIT_LOOP
        STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!


                    *GET FIRST WORD OF OPCODE IN MEMORY
DISASSEMBLE_MAIN    LEA CURRENT_WORD_ARRAY,A2 *GET A POINTER TO THE BIT ARRAY
                    ADDA.L #WORD_SIZE_CONST,A2 *MOVE POINTER TO END OF ARRAY
                    *LEA TEST_SUBQ,A6 *GET A POINTER TO THE CODE WE'RE DISASSEMBLING
                    MOVE.W  (A6)+,D3      *D3 STORES THE WORD WE ARE WORKING ON
                
                    *16 BITS
                    CMP.W #NOP_CONST,D3
                    BEQ PROC_NOP
                    CMP.W #RTS_CONST,D3
                    BEQ PROC_RTS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2           *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2      *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *15 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *14 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *13 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *12 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *11 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *10 BITS
                    CMP.W #ASL_MEM_CONST,D3
                    BEQ CHECK_ASL_MEM            *COMPLETE
                    CMP.W #ASR_MEM_CONST,D3
                    BEQ CHECK_ASR_MEM            *COMPLETE
CHECK_ASX_MEM_RET   CMP.W #BCLR_STATIC_CONST,D3
                    BEQ CHECK_BCLR_STATIC        *COMPLETE
CHECK_BCLRS_RET     CMP.W #JSR_CONST,D3         
                    BEQ CHECK_JSR               *COMPLETE
CHECK_JSR_RET       CMP.W #LSL_MEM_CONST,D3
                    BEQ CHECK_LSL_MEM            *COMPLETE
CHECK_LSL_MEM_RET   CMP.W #LSR_MEM_CONST,D3
                    BEQ CHECK_LSR_MEM            *COMPLETE
CHECK_LSR_MEM_RET   CMP.W #ROL_MEM_CONST,D3
                    BEQ CHECK_ROL_MEM           *COMPLETE
CHECK_ROL_MEM_RET   CMP.W #ROR_MEM_CONST,D3
                    BEQ CHECK_ROR_MEM           *COMPLETE
                    
                    *SHIFT BITS
CHECK_ROR_MEM_RET   MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY       
                    
                    
                    *9 BIT CHECKS
                    *COMPARISON PART FOR 9-BIT CHECKS
                    CMP.W #MOVEM_REG_TO_MEM_CONST,D3 *COMPLETE
                    BEQ CHECK_MOVEM_REG_TO_MEM
CHECK_MOVEM_RTM_RET CMP.W #MOVEM_MEM_TO_REG_CONST,D3 *COMPLETE
                    BEQ CHECK_MOVEM_MEM_TO_REG
                    
                    *SHIFT BITS
CHECK_MOVEM_MTR_RET MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *8 BIT checks
                    CMP.W #BCS_CONST,D3
                    BEQ CHECK_BCS_CONST
                    CMP.W #BGE_CONST,D3
                    BEQ CHECK_BGE_CONST
                    CMP.W #BLT_CONST,D3
                    BEQ CHECK_BLT_CONST
                    CMP.W #BRA_CONST,D3
                    BEQ CHECK_BRA_CONST
                    CMP.W #BVC_CONST,D3
                    BEQ CHECK_BVC_CONST
                    CMP.W #BHI_CONST,D3
                    BEQ CHECK_BHI_CONST
                    CMP.W #BEQ_CONST,D3
                    BEQ CHECK_BEQ_CONST
                    CMP.W #BGT_CONST,D3
                    BEQ CHECK_BGT_CONST
                    CMP.W #BLE_CONST,D3
                    BEQ CHECK_BLE_CONST
                    CMP.W #BLS_CONST,D3
                    BEQ CHECK_BLS_CONST
                    CMP.W #BMI_CONST,D3
                    BEQ CHECK_BMI_CONST
                    CMP.W #BNE_CONST,D3
                    BEQ CHECK_BNE_CONST
                    CMP.W #BPL_CONST,D3
                    BEQ CHECK_BPL_CONST
                    CMP.W #BVS_CONST,D3
                    BEQ CHECK_BVS_CONST
                    CMP.W #CMPI_CONST,D3
                    BEQ CHECK_CMPI_CONST
                    CMP.W #NEG_CONST,D3
                    BEQ CHECK_NEG_CONST
                    CMP.W #ORI_CONST,D3
                    BEQ CHECK_ORI_CONST

                    *SHIFT BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY
                                                          
                    *7 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *6 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *5 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *INCOMPLETE
                    *4 BITS
                    CMP.W #ADD_CONST,D3
                    BEQ CHECK_ADD
CHECK_ADD_RET       CMP.W #SUB_CONST,D3
                    BEQ CHECK_SUB
CHECK_SUB_RET       CMP.W #ASL_ASR_REG_CONST,D3
                    BEQ CHECK_ASL_ASR_REG
CHECK_ASL_ASR_RET   CMP.W #CMP_EOR_CONST,D3
                    BEQ CHECK_CMP_EOR
CHECK_CMP_EOR_RET   CMP.W #MULS_WORD_CONST,D3
                    BEQ CHECK_MULS_WORD_CONST
                    CMP.W #DIVS_WORD_CONST,D3           *CHECK IF DIVS/OR
                    BEQ CHECK_DIVS_OR_CONST
                    CMP.W #LEA_CONST,D3
                    BEQ CHECK_LEA_CONST
                    CMP.W #SUBQ_CONST, D3
                    BEQ CHECK_SUBQ_CONST
                    CMP.W #BCLR_DYNAMIC_CONST, D3
                    BEQ CHECK_BCLR_DYNAMIC
                    
                    *SHIFT BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *3 BITS
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *INCOMPLETE
                    *2 BITS
                    CMP.W #MOVE_CONST,D3
                    BEQ CHECK_MOVE
CHECK_MOVE_RET      MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

                    *1 BIT
                    MOVE.L #0,D2
                    LSR.W #1,D3 *SHIFT OUT A BIT
                    SCS D2 *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D2 *MAKE IT A 1 IF IT WAS $FF
                    MOVE.B D2,-(A2) *MOVE THE BIT WE SHIFTED OUT INTO THE BIT ARRAY

UNSUPPORTED_OP      *PRINT "DATA "
                    LEA DATA_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *GET TO THE START OF THE BIT ARRAY FOR THE FIRST WORD, AND PUT IT BACK INTO A SINGLE WORD IN D1.
                    LEA CURRENT_WORD_ARRAY,A2
                    MOVE.B #WORD_SIZE_CONST,D6
                    JSR BITARR_TO_INT
                    MOVE.W D7,D1
                    *^
                    *IT WAS A B
                    *A B WHERE IT SHOULD HAVE BEEN A W
                    *I'M DONE
                    *I'M QUITTING PROGRAMMING FOREVER
                    *BYE
                    JSR PRINT_HEX *PRINT THE WORD IN HEX
                    JSR PRINT_NEXT_LINE *PRINT CARRIAGE RETURN AND LINE FEED
                    RTS      
                    
******************************16 BITS******************************

*TODO
PROC_NOP
                               

*TODO
PROC_RTS            

******************************10 BITS******************************

*NEEDS TESTING
CHECK_ASL_MEM       *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    JSR ASX_MEM_CVALID *CHECK EA MODE VALIDITY
                    *PRINT "ASL"
                    LEA ASL_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                    
*NEEDS TESTING
CHECK_ASR_MEM       *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    JSR ASX_MEM_CVALID *CHECK EA MODE VALIDITY
                    *PRINT "ASR"
                    LEA ASR_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                    
                    *FOR USE BY CHECK_ASL_MEM AND CHECK_ASR_MEM
                    *CHECKS IF THE EA MODE IN D2 IS VALID (MAY HAVE TO CHECK REG AS WELL; THIS SHOULD BE IN D1), AND BRANCHES APPROPRIATELY IF NOT
                    *NOTE THAT THIS NEVER RETURNS TO THE CALLER IF THE MODE IS INVALID/UNSUPPORTED; INSTEAD IT RETURNS TO CHECK_ASX_MEM_RET OR TO PROC_INVALID
ASX_MEM_CVALID      *CHECK REG IF LITERAL
                    CMP.B #LITERAL_CONST,D2
                    BEQ ASX_MEM_LITERAL
                    *VALID IF MEMORY ACCESS
                    CMP.B #NO_INC_DEC_CONST,D2
                    BEQ ASX_MEM_VALID
                    CMP.B #POST_INC_CONST,D2
                    BEQ ASX_MEM_VALID
                    CMP.B #PRE_DEC_CONST,D2
                    BEQ ASX_MEM_VALID
                    *INVALID IF DN OR AN
                    CMP.B #DATA_REGISTER_CONST,D2
                    BEQ ASX_MEM_INVALID
                    CMP.B #ADDRESS_REGISTER_CONST,D2
                    BEQ ASX_MEM_INVALID
                    *ELSE UNSUPPORTED
ASX_MEM_UNSUPPORTED *"RETURN" TO HANDLING FOR UNSUPPORTED OPERATIONS, RATHER THAN TO CALLER
                    ADDA.L #1,SP
                    BRA CHECK_ASX_MEM_RET
ASX_MEM_INVALID     *MOVE BACK BITARR POINTER (A2) BY THE NUMBER OF TIMES WE INCREMENTED IT (3+3==6), AND "RETURN" TO CHECKING NEXT OPERATION, RATHER THAN TO CALLER
                    SUBA.L #6,A2
                    ADDA.L #1,SP
                    BRA CHECK_ASX_MEM_RET
ASX_MEM_VALID       RTS
ASX_MEM_LITERAL     *VALID IF MEMORY ADDRESS
                    CMP.B #WORD_ADDRESS_CONST,D1
                    BEQ ASX_MEM_VALID
                    CMP.B #LONG_ADDRESS_CONST,D1
                    BEQ ASX_MEM_VALID
                    *INVALID IF IMMEDIATE
                    CMP.B #IMMEDIATE_CONST,D1
                    BEQ ASX_MEM_INVALID
                    *ELSE UNSUPPORTED
                    BRA ASX_MEM_UNSUPPORTED

*NEEDS TESTING
CHECK_BCLR_STATIC   MOVE.L #0,D1 *CLEAR D1
                    *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D5
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    
                    *CHECK MODE VALIDITY
                    *INVALID IF AN
                    CMP.B #ADDRESS_REGISTER_CONST,D2
                    BEQ BCLRS_BAD_MODE
                    *IF LITERAL, CHECK REGISTER BITS
                    CMP.B #LITERAL_CONST,D2
                    BEQ BCLRS_LITERAL
                    *UNSUPPORTED IF DISPLACEMENT
                    CMP.B #D16_AN_CONST,D2
                    BEQ UNSUPPORTED_OP
                    CMP.B #D8_AN_XN_CONST,D2
                    BEQ UNSUPPORTED_OP
                    
                    *PRINT "BCLR"
PRINT_BCLR_STATIC   LEA BCLR_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    *PRINT BIT NUMBER
                    JSR PRINT_WORD_IMM
                    *PRINT COMMA
                    MOVE.B  #14,D0
                    LEA COMMA_TEXT, A1
                    TRAP   #15
                    *PRINT EA
                    MOVE.B D5,D1
                    MOVE.B #LONG_CODE,D3 *TELL SUBROUTINE THAT SIZE IS LONG
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                    
                                        
BCLRS_LITERAL       *VALID IF MEMORY; CONTINUE
                    CMP.B #WORD_ADDRESS_CONST,D5
                    BEQ PRINT_BCLR_STATIC *VALID, SO BRANCH BACK
                    CMP.B #LONG_ADDRESS_CONST,D5
                    BEQ PRINT_BCLR_STATIC *VALID, SO BRANCH BACK
                    *INVALID IF IMMEDIATE; GO BACK TO CHECK MORE OPS
                    CMP.B #IMMEDIATE_CONST,D5
                    BEQ BCLRS_BAD_MODE
                    *ELSE UNSUPPORTED
                    BRA UNSUPPORTED_OP
BCLRS_BAD_MODE      *ROLL BACK THE BIT ARRAY POINTER (3+3==6) AND RETURN TO CHECK OTHER OPERATIONS
                    SUBA.L #6,A2
                    BRA CHECK_BCLRS_RET


*NEEDS TESTING
CHECK_JSR           *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    
                    *CHECK WHETHER ADDRESSING MODE IS VALID, INVALID, OR UNRECOGNIZED
                    *VALID IF (AN), WORD ADDRESS, OR LONG ADDRESS
                    CMP.B #NO_INC_DEC_CONST,D2
                    BEQ PRINT_JSR
                    CMP.B #WORD_ADDRESS_CONST,D2
                    BEQ PRINT_JSR
                    CMP.B #LONG_ADDRESS_CONST,D2
                    BEQ PRINT_JSR
                    *IF LITERAL, NEED TO CHECK REGISTER BITS
                    CMP.B #LITERAL_CONST,D2
                    BEQ JSR_LITERAL
                    *IF DISPLACEMENT, UNRECOGNIZED
                    CMP.B #D16_AN_CONST,D2
                    BEQ JSR_UNRECOGNIZED
                    CMP.B #D8_AN_XN_CONST,D2
                    BEQ JSR_UNRECOGNIZED
                    *ELSE INVALID
                    BRA JSR_INVALID
                    
                    *PRINT "JSR"
PRINT_JSR           LEA JSR_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!

                  
JSR_LITERAL         *VALID IF MEMORY ADDRESS, SO GO BACK AND CONTINUE DECODING
                    CMP.B #WORD_ADDRESS_CONST,D1
                    BEQ PRINT_JSR
                    CMP.B #LONG_ADDRESS_CONST,D1
                    BEQ PRINT_JSR
                    *INVALID IF IMMEDIATE
                    CMP.B #IMMEDIATE_CONST,D1
                    BEQ JSR_INVALID
                    *ELSE UNRECOGNIZED
JSR_UNRECOGNIZED    BRA UNSUPPORTED_OP
JSR_INVALID         *MOVE BACK THE BITARR POINTER (A2) THE NUMBER OF SPACES WE MOVED IT (3+3==6)
                    SUBA.L #6,A2
                    BRA CHECK_JSR_RET
 

*NEEDS TESTING
CHECK_LSL_MEM        *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    *PRINT "ASL"
                    LEA LSL_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!      

*NEEDS TESTING
CHECK_LSR_MEM       *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    JSR ASX_MEM_CVALID *CHECK EA MODE VALIDITY
                    *PRINT "ASR"
                    LEA LSR_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!! 

*NEEDS TESTING
CHECK_ROL_MEM       *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    JSR ASX_MEM_CVALID *CHECK EA MODE VALIDITY
                    *PRINT "ROL"
                    LEA ROL_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!

*NEEDS TESTING
CHECK_ROR_MEM       *READ MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ REGISTER NUMBER (3 BITS) INTO D1.L
                    MOVE.L #0,D1 *CLEAR D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    JSR ASX_MEM_CVALID *CHECK EA MODE VALIDITY
                    *PRINT "ROR"
                    LEA ROR_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B #WORD_CODE,D3 *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!
  

*******************************9 BITS******************************
*NEEDS TESTING
CHECK_MOVEM_REG_TO_MEM
                    *READ SIZE BIT (1 BIT) INTO D3 
                    MOVE.B #1,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3     
                    
                    MOVE.B #3,D6                *GET THE <EA> MODE BITS AND STORE IN D2                    
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2              
                    MOVE.B #3,D6                *GET THE <EA> REGISTER BITS AND STORE IN D1
                    JSR BITARR_TO_INT
                    CLR.L D1
                    MOVE.B D7,D1
                    
                    *PRINT MOVEM
                    LEA MOVEM_TEXT, A1
                    MOVE.B #14,D0
                    TRAP #15
                    
                    *PRINT SIZE EXTENSION
                    CMP.B #0,D3             *OPCODE IS A WORD
                    BEQ MOVEM_RTM_WORD
                    BRA MOVEM_RTM_LONG
MOVEM_RTM_WORD      LEA WORD_TEXT, A1       *PRINT '.W'
                    MOVE.B #14,D0
                    TRAP #15
                    BRA MOVEM_RTM_PROC_CONT *PRINT LIST OF REGISTERS TO STORE
MOVEM_RTM_LONG      LEA LONG_TEXT, A1       *PRINT '.L'
                    MOVE.B #14,D0
                    TRAP #15
MOVEM_RTM_PROC_CONT MOVE.B D1,D3            *TEMP STORE <EA> REGISTER BITS IN D3 WHILE PROCESSING LIST
                    JSR PRINT_MOVEM_DREGS
                    MOVE.B D3,D1            *MOVE REGISTERS BACK TO D1
                    JSR PRINT_COMMA
                    MOVE.B #WORD_CODE,D3    *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT              *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!
                                     
                    
*TODO
CHECK_MOVEM_MEM_TO_REG
                    *READ SIZE BIT (1 BIT) INTO D3 
                    MOVE.B #1,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3     
                    
                    MOVE.B #3,D6                *GET THE <EA> MODE BITS AND STORE IN D2                    
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2              
                    MOVE.B #3,D6                *GET THE <EA> REGISTER BITS AND STORE IN D1
                    JSR BITARR_TO_INT
                    CLR.L D1
                    MOVE.B D7,D1
                    
                    *PRINT MOVEM
                    LEA MOVEM_TEXT, A1
                    MOVE.B #14,D0
                    TRAP #15
                    
                    *PRINT SIZE EXTENSION
                    CMP.B #0,D3             *OPCODE IS A WORD
                    BEQ MOVEM_MTR_WORD
                    BRA MOVEM_MTR_LONG
MOVEM_MTR_WORD      LEA WORD_TEXT, A1       *PRINT '.W'
                    MOVE.B #14,D0
                    TRAP #15
                    MOVE.B D1,D5
                    BRA MOVEM_MTR_PROC_CONT *PRINT LIST OF REGISTERS TO STORE
MOVEM_MTR_LONG      LEA LONG_TEXT, A1       *PRINT '.L'
                    MOVE.B #14,D0
                    TRAP #15
MOVEM_MTR_PROC_CONT MOVE.B #WORD_CODE,D3    *LET SUBROUTINE KNOW THAT SIZE IS WORD
                    CMP.B #7, D2
                    BEQ HANDLE_ADDRESS
                    BRA MTR_CONT                        *HANDLE ADDRESSES
HANDLE_ADDRESS      ADDA.L #2, A6
                    BRA MTR_CONT                    
MTR_CONT            JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    MOVE.B D5,D1
                    CMP.B #7, D2
                    BEQ FIX_ADDRESS_MTR
                    BRA MTR_CONT2
FIX_ADDRESS_MTR     CMP.B #0,D1
                    BEQ FIX_WORD
                    BRA FIX_LONG
FIX_WORD            SUBA.L #4,A6                    
                    BRA MTR_CONT2
FIX_LONG            SUBA.L #6,A6                    
MTR_CONT2           JSR PRINT_MOVEM_DREGS
                    CMP.B #7,D2                 *FIX POINTER IF <EA> WAS ADDRESS
                    BEQ FIX_ADDRESS2
                    BRA MTR_CONT3
FIX_ADDRESS2        CMP.B #0,D1
                    BEQ FIX_WORD_ADD
                    BRA FIX_LONG_ADD
FIX_WORD_ADD        ADDA.L #2, A6
                    BRA MTR_CONT3
FIX_LONG_ADD        ADDA.L #4,A6                    
MTR_CONT3           JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT              *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!
                    
*******************************8 BITS******************************
CHECK_BRA_CONST     
                    LEA BRA_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!                 

CHECK_BHI_CONST     
                    LEA BHI_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!                

CHECK_BLO_CONST     
                    LEA BLO_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BEQ_CONST     
                    LEA BEQ_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 
CHECK_BGE_CONST     
                    LEA BGE_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BGT_CONST     
                    LEA BGT_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 
CHECK_BCS_CONST     
                    LEA BCS_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 
CHECK_BLE_CONST     
                    LEA BLE_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BLS_CONST     
                    LEA BLS_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BLT_CONST     
                    LEA BLT_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BMI_CONST     
                    LEA BMI_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BNE_CONST     
                    LEA BNE_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BPL_CONST     
                    LEA BPL_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 

CHECK_BVC_CONST     
                    LEA BVC_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!! 
                    
CHECK_BVS_CONST     
                    LEA BVS_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PROC_BCC_OUT
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!                     

**************************************BRANCH DISPLACEMENT PROC CODE*********************************************
PROC_BCC_OUT        MOVE.L #0,D4 *CLEAR D4 FOR DISPLACEMENT
                    MOVE.L #0,D1 *CLEAR D1 FOR OUTPUT
                    MOVE.B #8,D6 *GRAB NEXT 8-BITS TO FIND DISPLACEMENT
                    JSR BITARR_TO_INT
                    MOVE.B D7,D4    *STORE DISPLACEMENT IN D4
                    MOVE.L A6,D5    *STORE ADDRESS TO DISPLACE FROM IN D5
                    CMP.B #$00,D4    *CHECK IF DISPLACEMENT IS WORD                    
                    BEQ BCC_DISP_WORD   *GRAB NEXT WORD FOR DISPLACEMENT
                    CMP.B #$FF,D4        *CHECK IF DISPLACEMENT LONG
                    BEQ BCC_DISP_LONG
                    BRA BCC_DISP_BYTE
BCC_DISP_BYTE       NEG.B D4            *GET THE INVERSE OF 8-BIT DISPLACEMENT (8-BIT IS ALWAYS NEGATIVE)
                    SUB.L D4,D5         *SUBTRACT DISPLACEMENT FROM STARTING ADDRESS
                    MOVE.L D5,D1        *MOVE TO DISPLAY ADDRESS                  
                    MOVE.B #3,D0    
                    TRAP #15
                    BRA EXIT_BCC_LOOP
BCC_DISP_WORD       MOVE.W (A6)+,D4     *GRAB THE DISPLACEMENT
                    CMP.W #0,D4
                    BLT BCC_DISP_WORD_NEG
                    BRA BCC_DISP_WORD_POS
BCC_DISP_WORD_NEG   NEG D4              *GET THE INVERSE OF 16-BIT DISPLACEMENT FOR NEGATIVE NUMBERS
                    SUB.L D4,D5
                    MOVE.L D5,D1        *PRINT ADDRESS WITH DISPLACEMENT
                    JSR PRINT_HEX
                    BRA EXIT_BCC_LOOP
BCC_DISP_WORD_POS   ADD.L D4,D5 
                    MOVE.L D5,D1
                                    *PRINT ADDRESS WITH DISPLACEMENT
                    JSR PRINT_HEX
                    BRA EXIT_BCC_LOOP                           
BCC_DISP_LONG       MOVE.L (A6)+,D4
                    ADD.L D4,D5
                    MOVE.L D5,D1
                    JSR PRINT_HEX
                    BRA EXIT_BCC_LOOP
EXIT_BCC_LOOP       RTS              *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!

******************************************************************************************************************
               
CHECK_NEG_CONST     MOVE.L #0,D4        *CLEAR THE REGISTERS TO BE USED
                    MOVE.L #0,D1
                    MOVE.B #2,D6        *GET THE SIZE BITS (2)
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3        *STORE SIZE IN D3
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT   *GET THE <EA> MODE BITS (3) AND STORE IN D2
                    MOVE.B D7,D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT   *GET THE <EA> REGISTER AND STORE IN D1
                    MOVE.B D7,D1
                    LEA NEG_TEXT,A1     *OUTPUT 'NEG'
                    MOVE.B #14,D0
                    TRAP #15
                    CMP.B #0,D3         *PRINT SIZE CODE
                    BEQ NEG_BYTE
                    CMP.B #1,D3
                    BEQ NEG_WORD        
                    BRA NEG_LONG
NEG_BYTE            LEA BYTE_TEXT,A1                    
                    TRAP #15
                    BRA NEG_CONT
NEG_WORD            LEA WORD_TEXT,A1
                    TRAP #15
                    BRA NEG_CONT
NEG_LONG            LEA LONG_TEXT,A1
                    TRAP #15                    
NEG_CONT            LEA SPACE_TEXT,A1   *PRINT SPACE
                    TRAP #15
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!
                    
CHECK_CMPI_CONST    MOVE.L #0,D4        *CLEAR THE REGISTERS TO BE USED
                    MOVE.L #0,D1
                    MOVE.B #2,D6        *GET THE SIZE BITS (2)
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3        *STORE SIZE IN D3
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT   *GET THE <EA> MODE BITS (3) AND STORE IN D2
                    MOVE.B D7,D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT   *GET THE <EA> REGISTER AND STORE IN D1
                    MOVE.B D7,D4
                    LEA CMPI_TEXT,A1    *PRINT CMPI
                    MOVE.B #14,D0
                    TRAP #15
                    CMP.B #BYTE_CODE,D3
                    BEQ CMPI_PRINT_BYTE
                    CMP.B #WORD_CODE,D3
                    BEQ CMPI_PRINT_WORD
                    BRA CMPI_PRINT_LONG
CMPI_PRINT_BYTE     LEA BYTE_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    BRA CMPI_CONT
CMPI_PRINT_WORD     LEA WORD_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    BRA CMPI_CONT
CMPI_PRINT_LONG     LEA LONG_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    BRA CMPI_CONT                   
CMPI_CONT           LEA SPACE_TEXT,A1
                    TRAP #15
                    JSR PRINT_IMM       *PRINT THE DATA
                    MOVE.B D4,D1
                    LEA COMMA_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT           *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!

CHECK_ORI_CONST     MOVE.L #0,D4        *CLEAR THE REGISTERS TO BE USED
                    MOVE.L #0,D1
                    MOVE.B #2,D6        *GET THE SIZE BITS (2)
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3        *STORE SIZE IN D3
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT   *GET THE <EA> MODE BITS (3) AND STORE IN D2
                    MOVE.B D7,D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT   *GET THE <EA> REGISTER AND STORE IN D1
                    MOVE.B D7,D4
                    LEA ORI_TEXT,A1    *PRINT CMPI
                    MOVE.B #14,D0
                    TRAP #15
                    CMP.B #0,D3         *PRINT SIZE CODE
                    BEQ ORI_BYTE
                    CMP.B #1,D3
                    BEQ ORI_WORD
                    BRA ORI_LONG
ORI_BYTE            LEA BYTE_TEXT,A1
                    TRAP #15
                    BRA ORI_CONT
ORI_WORD            LEA WORD_TEXT,A1
                    TRAP #15
                    BRA ORI_CONT
ORI_LONG            LEA LONG_TEXT,A1
                    TRAP #15                    
ORI_CONT            JSR PRINT_IMM       *PRINT THE DATA
                    MOVE.B D4,D1
                    LEA COMMA_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT           *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!

                     




*******************************4 BITS******************************
*NEEDS TESTING
CHECK_ADD           MOVE.L #0,D1 *CLEAR D1 FOR OUTPUT
                    *READ REGISTER (3 BITS) INTO D4
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D4
                    *READ OPMODE (3 BITS) INTO D5
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    *READ EA MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ EA REGISTER (3 BITS) INTO D7
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    *STORE 14 IN D0 TO PREPARE FOR OUTPUT
                    MOVE.B #14,D0
                    *DO THE REST, ACCORDING TO OPMODE
                    CMP.B #BYTE_TO_DN_CONST,D5
                    BEQ ADD_BYTE_TO_DN
                    CMP.B #BYTE_TO_EA_CONST,D5
                    BEQ ADD_BYTE_TO_EA
                    CMP.B #WORD_TO_DN_CONST,D5
                    BEQ ADD_WORD_TO_DN
                    CMP.B #WORD_TO_EA_CONST,D5
                    BEQ ADD_WORD_TO_EA
                    CMP.B #LONG_TO_DN_CONST,D5
                    BEQ ADD_LONG_TO_DN
                    CMP.B #LONG_TO_EA_CONST,D5
                    BEQ ADD_LONG_TO_EA
                    CMP.B #WORD_TO_AN_CONST,D5
                    BEQ ADD_WORD_TO_AN
                    *ELSE ADD LONG TO AN
                    MOVE.B #LONG_CODE,D3
                    LEA ADDA_TEXT,A1
                    TRAP #15
                    LEA LONG_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    *PRINT COMMA
                    JSR PRINT_COMMA
                    *PRINT AN
                    MOVE.B D4,D1
                    JSR PRINT_AN
                    BRA ADD_CLEANUP
ADD_WORD_TO_AN      MOVE.B #WORD_CODE,D3
                    LEA ADDA_TEXT,A1
                    TRAP #15
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.L #0,D1 *CLEAR OUT D1 FOR OUTPUT
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT AN
                    MOVE.B D4,D1
                    JSR PRINT_AN
                    BRA ADD_CLEANUP
ADD_BYTE_TO_DN      MOVE.B #BYTE_CODE,D3
                    JSR PRINT_ADD_OR_ADDI
                    LEA BYTE_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    BRA ADD_CLEANUP
ADD_WORD_TO_DN      MOVE.B #WORD_CODE,D3
                    JSR PRINT_ADD_OR_ADDI
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    BRA ADD_CLEANUP
ADD_LONG_TO_DN      MOVE.B #LONG_CODE,D3
                    JSR PRINT_ADD_OR_ADDI
                    LEA LONG_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    BRA ADD_CLEANUP
ADD_BYTE_TO_EA      MOVE.B #BYTE_CODE,D3
                    LEA ADD_TEXT,A1
                    TRAP #15
                    LEA BYTE_TEXT,A1
                    TRAP #15
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    JSR PRINT_COMMA
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    BRA ADD_CLEANUP
ADD_WORD_TO_EA      MOVE.B #WORD_CODE,D3
                    LEA ADD_TEXT,A1
                    TRAP #15
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    JSR PRINT_COMMA
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    BRA ADD_CLEANUP
ADD_LONG_TO_EA      MOVE.B #LONG_CODE,D3
                    LEA ADD_TEXT,A1
                    TRAP #15
                    LEA LONG_TEXT,A1
                    TRAP #15
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    JSR PRINT_COMMA
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN

                    BRA ADD_CLEANUP
ADD_CLEANUP         JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!

                    *PRINTS ADD OR ADDI, BASED ON THE EA MODE (D2) AND EA ADDRESS (D7)
PRINT_ADD_OR_ADDI   CMP.B #LITERAL_CONST,D2
                    BNE PRINT_ADD
                    CMP.B #IMMEDIATE_CONST,D7
                    BNE PRINT_ADD
                    *IF BOTH WERE THE SPECIFIED VALUES, IT'S ADDI
                    LEA ADDI_TEXT,A1
                    BRA PAOAI_CLEANUP
PRINT_ADD           LEA ADD_TEXT,A1
PAOAI_CLEANUP       MOVE.B #14,D0
                    TRAP #15
                    RTS
                    
*NEEDS TESTING
CHECK_SUB            MOVE.L #0,D1 *CLEAR D1 FOR OUTPUT
                    *READ REGISTER (3 BITS) INTO D4
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D4
                    *READ OPMODE (3 BITS) INTO D5
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    *READ EA MODE (3 BITS) INTO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ EA REGISTER (3 BITS) INTO D7
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    *STORE 14 IN D0 TO PREPARE FOR OUTPUT
                    MOVE.B #14,D0
                    *DO THE REST, ACCORDING TO OPMODE
                    CMP.B #BYTE_TO_DN_CONST,D5
                    BEQ SUB_BYTE_TO_DN
                    CMP.B #BYTE_TO_EA_CONST,D5
                    BEQ SUB_BYTE_TO_EA
                    CMP.B #WORD_TO_DN_CONST,D5
                    BEQ SUB_WORD_TO_DN
                    CMP.B #WORD_TO_EA_CONST,D5
                    BEQ SUB_WORD_TO_EA
                    CMP.B #LONG_TO_DN_CONST,D5
                    BEQ SUB_LONG_TO_DN
                    CMP.B #LONG_TO_EA_CONST,D5
                    BEQ SUB_LONG_TO_EA
                    CMP.B #WORD_TO_AN_CONST,D5
                    BEQ SUB_WORD_TO_AN
                    *ELSE SUB LONG TO AN
                    MOVE.B #LONG_CODE,D3
                    LEA SUBA_TEXT,A1
                    TRAP #15
                    LEA LONG_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT AN
                    MOVE.B D4,D1
                    JSR PRINT_AN
                    BRA SUB_CLEANUP
SUB_WORD_TO_AN      MOVE.B #WORD_CODE,D3
                    LEA SUBA_TEXT,A1
                    TRAP #15
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT AN
                    MOVE.B D4,D1
                    JSR PRINT_AN
                    BRA SUB_CLEANUP
SUB_BYTE_TO_DN      MOVE.B #BYTE_CODE,D3
                    JSR PRINT_SUB_OR_SUBI
                    LEA BYTE_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    BRA SUB_CLEANUP
SUB_WORD_TO_DN      MOVE.B #WORD_CODE,D3
                    JSR PRINT_SUB_OR_SUBI
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    BRA SUB_CLEANUP
SUB_LONG_TO_DN      MOVE.B #LONG_CODE,D3
                    JSR PRINT_SUB_OR_SUBI
                    LEA LONG_TEXT,A1
                    TRAP #15
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    BRA SUB_CLEANUP
SUB_BYTE_TO_EA      MOVE.B #BYTE_CODE,D3
                    LEA SUB_TEXT,A1
                    TRAP #15
                    LEA BYTE_TEXT,A1
                    TRAP #15
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    JSR PRINT_COMMA
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    BRA SUB_CLEANUP
SUB_WORD_TO_EA      MOVE.B #WORD_CODE,D3
                    LEA SUB_TEXT,A1
                    TRAP #15
                    LEA WORD_TEXT,A1
                    TRAP #15
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    JSR PRINT_COMMA
                    *PRINT EA
                    MOVE.L #0,D1 *CLEAR OUT D1 FOR OUTPUT
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
                    BRA SUB_CLEANUP
SUB_LONG_TO_EA      MOVE.B #LONG_CODE,D3
                    LEA SUB_TEXT,A1
                    TRAP #15
                    LEA LONG_TEXT,A1
                    TRAP #15
                    *PRINT DN
                    MOVE.B D4,D1
                    JSR PRINT_DN
                    JSR PRINT_COMMA
                    *PRINT EA
                    MOVE.B D7,D1
                    JSR PRINT_TOKEN
SUB_CLEANUP         JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!

                    *PRINTS SUB OR SUBI, BASED ON THE EA MODE (D2) AND EA ADDRESS (D7)
PRINT_SUB_OR_SUBI   CMP.B #LITERAL_CONST,D2
                    BNE PRINT_SUB
                    CMP.B #IMMEDIATE_CONST,D7
                    BNE PRINT_SUB
                    *IF BOTH WERE THE SPECIFIED VALUES, IT'S SUBI
                    LEA SUBI_TEXT,A1
                    BRA PSOSI_CLEANUP
PRINT_SUB           LEA SUB_TEXT,A1
PSOSI_CLEANUP       MOVE.B #14,D0
                    TRAP #15
                    RTS
                    
                    *FOR USE BY CHECK_ADD AND CHECK_SUB
                    *CHECKS THE VALIDITY OF THE EA MODE AND BRANCHES APPROPRIATELY USING THE MODE IN D2 AND REGISTER IN D7
                    *NOTE THAT IT MAY BRANCH SOMEWHERE ELSE INSTEAD OF RETURNING TO THE CALLER
ADDSUB_CHECK_EA     *CHECK REGISTER BITS IF LITERAL
                    CMP.B #LITERAL_CONST,D2
                    BEQ ADDSUB_LITERAL
                    *UNSUPPORTED IF DISPLACEMENT
                    CMP.B #D16_AN_CONST,D2
                    BEQ ADDSUB_UNSUPPORTED
                    CMP.B #D8_AN_XN_CONST,D2
                    BEQ ADDSUB_UNSUPPORTED
                    *ELSE WE'RE GOOD; GO BACK
                    RTS
ADDSUB_LITERAL      *VALID IF ADDRESS OR IMMEDIATE
                    CMP.B #WORD_ADDRESS_CONST,D7
                    RTS
                    CMP.B #LONG_ADDRESS_CONST,D7
                    RTS
                    CMP.B #IMMEDIATE_CONST,D7
                    RTS
                    BRA ADDSUB_UNSUPPORTED
ADDSUB_UNSUPPORTED  SUBA #WORDS_PER_LONG_CONST,SP *REMOVE THE FUNCTION CALL FROM THE STACK, SINCE WE AREN'T RETURNING PROPERLY
                    BRA UNSUPPORTED_OP
                    
CHECK_CMP_EOR       MOVE.B #14,D0 *PREP FOR OUTPUT
                    MOVE.L #0,D1 *CLEAR D1 FOR OUTPUT
                    *READ SOURCE REGISTER (3 BITS) TO D4
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D4
                    *READ OPMODE (3 BITS) TO D5
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    *READ DESTINATION MODE (3 BITS) TO D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *READ DESTINATION REGISTER (3 BITS) TO D7
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    
                    *IF LITERAL, MAKE SURE VALID REG BITS
                    CMP.B #LITERAL_CONST,D2
                    BEQ CMP_CHECK_LIT
                    
                    *DETERMINE CMP/EOR, AND IF CMP, STORE DESTINATION EA MODE IN D6 AND SIZE IN D3, BASED ON OPMODE
CMP_PROCESS         CMP.B #BYTE_TO_DN_CONST,D5
                    BEQ CMP_BYTE_TO_DN
                    CMP.B #WORD_TO_DN_CONST,D5
                    BEQ CMP_WORD_TO_DN
                    CMP.B #LONG_TO_DN_CONST,D5
                    BEQ CMP_LONG_TO_DN
                    CMP.B #WORD_TO_AN_CONST,D5
                    BEQ CMP_WORD_TO_AN
                    CMP.B #LONG_TO_AN_CONST,D5
                    BEQ CMP_LONG_TO_AN
                    CMP.B #BYTE_TO_EA_CONST,D5
                    BEQ EOR_BYTE
                    CMP.B #WORD_TO_EA_CONST,D5
                    BEQ EOR_WORD
                    CMP.B #LONG_TO_EA_CONST,D5
                    BEQ EOR_LONG
CMP_BYTE_TO_DN      MOVE.B #DATA_REGISTER_CONST,D6
                    MOVE.B #BYTE_CODE,D3
                    BRA PRINT_CMP_OR_CMPA
CMP_WORD_TO_DN      MOVE.B #DATA_REGISTER_CONST,D6
                    MOVE.B #WORD_CODE,D3
                    BRA PRINT_CMP_OR_CMPA
CMP_LONG_TO_DN      MOVE.B #DATA_REGISTER_CONST,D6
                    MOVE.B #LONG_CODE,D3
                    BRA PRINT_CMP_OR_CMPA
CMP_WORD_TO_AN      MOVE.B #ADDRESS_REGISTER_CONST,D6
                    MOVE.B #WORD_CODE,D3
                    BRA PRINT_CMP_OR_CMPA
CMP_LONG_TO_AN      MOVE.B #ADDRESS_REGISTER_CONST,D6
                    MOVE.B #LONG_CODE,D3
                    BRA PRINT_CMP_OR_CMPA
EOR_BYTE            MOVE.B #BYTE_CODE,D3
                    BRA EOR
EOR_WORD            MOVE.B #WORD_CODE,D3
                    BRA EOR
EOR_LONG            MOVE.B #LONG_CODE,D3
                    BRA EOR
PRINT_CMP_OR_CMPA   CMP.B #DATA_REGISTER_CONST,D6
                    BEQ PRINT_CMP
                    *ELSE PRINT CMPA
                    LEA CMPA_TEXT,A1
                    TRAP #15
                    BRA CMP_PRINT_SIZE
PRINT_CMP           LEA CMP_TEXT,A1
                    TRAP #15
CMP_PRINT_SIZE      CMP.B #BYTE_CODE,D3
                    BEQ CMP_PRINT_BYTE
                    CMP.B #WORD_CODE,D3
                    BEQ CMP_PRINT_WORD
                    CMP.B #LONG_CODE,D3
                    BEQ CMP_PRINT_LONG
CMP_PRINT_BYTE      LEA BYTE_TEXT,A1
                    TRAP #15
                    BRA CMP_SOURCE
CMP_PRINT_WORD      LEA WORD_TEXT,A1
                    TRAP #15
                    BRA CMP_SOURCE
CMP_PRINT_LONG      LEA LONG_TEXT,A1
                    TRAP #15
CMP_SOURCE          MOVE.B D7,D1 *MOVE DESTINATION REG INTO D1
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA                   
                    *PRINT SOURCE EA
                    MOVE.B D4,D1 *MOVE SOURCE REGISTER TO D1
                    MOVE.B D6,D2 *MOVE SOURCE MODE TO D2
                    JSR PRINT_TOKEN                                      
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                    
CMP_CHECK_LIT       *VALID IF ADDRESS; CONTINUE
                    CMP.B #WORD_ADDRESS_CONST,D1
                    BEQ CMP_PROCESS
                    CMP.B #LONG_ADDRESS_CONST,D1
                    BEQ CMP_PROCESS
                    *ELSE INVALID; MOVE BITARR POINTER (A2) BACK THE NUMBER OF TIMES WE INCREMENTED IT (3+3+3+3==12) AND GO BACK TO CHECK MORE OPS
CMP_EOR_INVALID     SUBA.L #12,A2
                    BRA CHECK_CMP_EOR_RET

EOR                 *INVALID IF EA MODE IS AN
                    CMP.B #ADDRESS_REGISTER_CONST,D2
                    BEQ CMP_EOR_INVALID
                    *PRINT "EOR"
                    LEA EOR_TEXT,A1
                    TRAP #15
                    *PRINT SIZE BASED ON SIZE CODE IN D3
                    CMP.B #BYTE_CODE,D3
                    BEQ EOR_PRINT_BYTE
                    CMP.B #WORD_CODE,D3
                    BEQ EOR_PRINT_WORD
                    *ELSE LONG
                    LEA LONG_TEXT,A1
                    TRAP #15
                    BRA EOR_OPERANDS
EOR_PRINT_WORD      LEA WORD_TEXT,A1
                    TRAP #15
                    BRA EOR_OPERANDS
EOR_PRINT_BYTE      LEA BYTE_TEXT,A1
                    TRAP #15
EOR_OPERANDS        *PRINT SOURCE EA
                    MOVE.B D4,D1 *MOVE DESTINATION REGISTER TO D1
                    MOVE.B D2,D3
                    MOVE.B D6,D2 *MOVE DESTINATION MODE TO D2
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DESTINATION REGISTER
                    MOVE.B D7,D1 *MOVE SOURCE REG INTO D1
                    MOVE.B D3,D2
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!                    



                    
CHECK_ASL_ASR_REG   MOVE.L #0,D1 *MAKE SURE D1 IS CLEAN FOR OUTPUT
                    *READ COUNT/REGITSTER (3 BITS) INTO D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    *READ DIRECTION BIT (1 BIT) INTO D2
                    MOVE.B (A2)+,D2
                    *READ SIZE (2 BITS) INTO D3
                    MOVE.B #2,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3
                    *INVALID SIZE CODE IF 11; RETURN TO CHECKING OPCODES
                    CMP.B #%11,D3
                    BEQ ASX_INVALID_SIZE
                    *READ IR BIT (1 BIT) INTO D4
                    MOVE.B (A2)+,D4
                    *MOVE FINAL BITS TO CHECK (NEXT 2 BITS) INTO D5
                    MOVE.B #2,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    *THOSE BITS SHOULD BE 00, OR IT ISN'T ASL/ASR
                    CMP.B #%00,D5
                    BEQ IS_ASL_OR_ASR
                    CMP.B #%01,D5
                    BEQ IS_LSL_OR_LSR
                    CMP.B #%11,D5
                    BEQ IS_ROL_OR_ROR
                    *ELSE ROLL BACK A2, AND RETURN
                    SUBA.L #9,A2 *3+1+2+1+2 THAT WE JUST INCREMENTED IT
                    BRA CHECK_ASL_ASR_RET
IS_ASL_OR_ASR       *NOW THAT D5 ISN'T BEING USED ANYMORE, PUT DESTINATION REGISTER (3 BITS) THERE
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    MOVE.B #14,D0 *PREP FOR OUTPUT
                    CMP.B #1,D2 *SHIFT LEFT IF DIRECTION BIT IS 1; OTHERWISE SHIFT RIGHT
                    BEQ ASL_REG
                    *ELSE ASR           PRINT "ASR"
                    LEA ASR_TEXT,A1
                    TRAP #15
                    BRA ASL_ASR_REG_SIZE
ASL_REG             *PRINT "ASL"
                    LEA ASL_TEXT,A1
                    TRAP #15
                    BRA ASL_ASR_REG_SIZE

                    
IS_LSL_OR_LSR       *NOW THAT D5 ISN'T BEING USED ANYMORE, PUT DESTINATION REGISTER (3 BITS) THERE
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    MOVE.B #14,D0 *PREP FOR OUTPUT
                    CMP.B #1,D2 *SHIFT LEFT IF DIRECTION BIT IS 1; OTHERWISE SHIFT RIGHT
                    BEQ LSL_REG
                    *ELSE ASR           PRINT "ASR"
                    LEA LSR_TEXT,A1
                    TRAP #15
                    BRA ASL_ASR_REG_SIZE
LSL_REG             *PRINT "ASL"
                    LEA LSL_TEXT,A1
                    TRAP #15 
                    BRA ASL_ASR_REG_SIZE
                   

IS_ROL_OR_ROR       *NOW THAT D5 ISN'T BEING USED ANYMORE, PUT DESTINATION REGISTER (3 BITS) THERE
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    MOVE.B #14,D0 *PREP FOR OUTPUT
                    CMP.B #1,D2 *SHIFT LEFT IF DIRECTION BIT IS 1; OTHERWISE SHIFT RIGHT
                    BEQ ROL_REG
                    *ELSE ASR           PRINT "ASR"
                    LEA ROR_TEXT,A1
                    TRAP #15
                    BRA ASL_ASR_REG_SIZE
ROL_REG             *PRINT "ASL"
                    LEA ROL_TEXT,A1
                    TRAP #15
                    BRA ASL_ASR_REG_SIZE

                    
ASL_ASR_REG_SIZE    *DETERMINE SIZE, PRINT, AND STORE IN D3
                    CMP.B #ASL_ASR_BYTE_CONST,D3
                    BEQ ASL_ASR_REG_BYTE
                    CMP.B #ASL_ASR_WORD_CONST,D3
                    BEQ ASL_ASR_REG_WORD
                    *ELSE LONG
                    LEA LONG_TEXT,A1
                    TRAP #15
                    MOVE.B #LONG_CODE,D3
                    BRA ASX_REG_OPERANDS
ASL_ASR_REG_BYTE    LEA BYTE_TEXT,A1
                    TRAP #15
                    MOVE.B #BYTE_CODE,D3
                    BRA ASX_REG_OPERANDS
ASL_ASR_REG_WORD    LEA WORD_TEXT,A1
                    TRAP #15
                    MOVE.B #WORD_CODE,D3
                    BRA ASX_REG_OPERANDS
ASX_REG_OPERANDS    *BEHAVE ACCORDING TO IR BIT
                    CMP.B #1,D4
                    BEQ ASX_REG_IR_EQU_ONE
                    *PRINT SOURCE REGISTER AS SHIFT COUNT
                    *CHANGE TO 8 IF 0
                    CMP.B #0,D1
                    BEQ ASX_CHANGE_ZERO
ASX_REG_P_SHIFT_C   LEA POUND_TEXT,A1
                    TRAP #15
                    MOVE.B #3,D0
                    TRAP #15
                    BRA ASL_ASR_REG_DEST
ASX_REG_IR_EQU_ONE  *PRINT SOURCE REGISTER AS A D REGISTER
                    JSR PRINT_DN
ASL_ASR_REG_DEST    JSR PRINT_COMMA
                    *PRINT DESTINATION REGISTER
                    MOVE.B D5,D1
                    JSR PRINT_DN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                    
ASX_CHANGE_ZERO     *CHANGE SOURCE REGISTER TO 8 INSTEAD OF 0
                    MOVE.B #8,D1
                    BRA ASX_REG_P_SHIFT_C
                    
ASX_INVALID_SIZE    *MOVE A2 BACK THE NUMBER OF BITS WE'VE READ (3+1+2==6) AND GO BACK TO CHECK DIFFERENT OPERATIONS.
                    SUBA.L #6,A2
                    BRA CHECK_ASL_ASR_RET





*NEEDS TESTING
CHECK_MOVE          *STORE SIZE BITS (2) IN D3
                    MOVE.B #2,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D3
                    *STORE THE DESTINATION REGISTER (3 BITS) IN D4
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D4
                    *STORE THE DESTINATION MODE (3 BITS) IN D5
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D5
                    *STORE THE SOURCE MODE (3 BITS) IN D2
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D2
                    *STORE THE SOURCE REGISTER (3 BITS) IN D1
                    MOVE.B #3,D6
                    JSR BITARR_TO_INT
                    MOVE.B D7,D1
                    
                    *CHECK EA MODE VALIDITY
                    *IF LITERAL DEST, CHECK DEST REGISTER
                    CMP.B #LITERAL_CONST,D5
                    BEQ MOVE_DEST_REG
                    *IF LITERAL SOURCE, CHECK SOURCE REGISTER
MOVE_SOURCE_LIT     CMP.B #LITERAL_CONST,D2
                    BEQ MOVE_SOURCE_REG
                    *UNSUPPORTED IF SOURCE OR DEST IS DISPLACEMENT
                    CMP.B #D16_AN_CONST,D2
                    BEQ UNSUPPORTED_OP
                    CMP.B #D8_AN_XN_CONST,D2
                    BEQ UNSUPPORTED_OP
                    *ELSE VALID; CONTINUE
                    
MOVE_OUTPUT         MOVE.B #14,D0 *PREP FOR OUTPUT
                    *DETERMINE WHETHER MOVE OR MOVEA
                    CMP.B #ADDRESS_REGISTER_CONST,D4
                    BEQ MOVEA
                    *PRINT "MOVE"
                    LEA MOVE_TEXT,A1
                    TRAP #15
                    BRA MOVE_SIZE
MOVEA               *PRINT "MOVEA"
                    LEA MOVEA_TEXT,A1
                    TRAP #15
MOVE_SIZE           *DETERMINE SIZE IN ORDER TO PRINT IT AND STORE SIZE CODE IN D3
                    CMP.B #MOVE_BYTE_CONST,D3
                    BEQ MOVE_BYTE
                    CMP.B #MOVE_WORD_CONST,D3
                    BEQ MOVE_WORD
                    *ELSE LONG
                    MOVE.B #LONG_CODE,D3
                    *PRINT ".L "
                    LEA LONG_TEXT,A1
                    TRAP #15
                    BRA MOVE_SOURCE
MOVE_WORD           MOVE.B #WORD_CODE,D3
                    *PRINT ".W "
                    LEA WORD_TEXT,A1
                    TRAP #15
                    BRA MOVE_SOURCE
MOVE_BYTE           MOVE.B #BYTE_CODE,D3
                    *PRINT ".B "
                    LEA BYTE_TEXT,A1
                    TRAP #15
MOVE_SOURCE         *PRINT SOURCE TOKEN
                    JSR PRINT_TOKEN
                    JSR PRINT_COMMA
                    *PRINT DESTINATION TOKEN
                    MOVE.L D4,D1
                    MOVE.B D5,D2
                    JSR PRINT_TOKEN
                    JSR PRINT_NEXT_LINE
                    RTS
                    STOP #EXIT *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                    
MOVE_DEST_REG       *INVALID IF IMMEDIATE, VALID IF MEMORY, OTHERWISE UNSUPPORTED                    
                    CMP.B #IMMEDIATE_CONST,D4
                    BEQ MOVE_INVALID
                    CMP.B #WORD_ADDRESS_CONST,D4
                    BEQ MOVE_SOURCE_LIT
                    CMP.B #LONG_ADDRESS_CONST,D4
                    BEQ MOVE_SOURCE_LIT
                    BRA UNSUPPORTED_OP
MOVE_SOURCE_REG     *VALID IF IMMEDIATE OR MEMORY, OTHERWISE UNSUPPORTED
                    CMP.B #IMMEDIATE_CONST,D1
                    BEQ MOVE_OUTPUT
                    CMP.B #WORD_ADDRESS_CONST,D1
                    BEQ MOVE_OUTPUT
                    CMP.B #LONG_ADDRESS_CONST,D1
                    BEQ MOVE_OUTPUT
                    BRA UNSUPPORTED_OP
MOVE_INVALID        *MOVE BITARR POINTER BACK NUMBER OF SPACES FORWARD WE'VE MOVED IT (2+3+3+3+3==14) AND RETURN TO CHECK 
                    *MORE OPERATIONS
                    SUBA.L #14,A2
                    BRA CHECK_MOVE_RET




CHECK_MULS_WORD_CONST   MOVE.L #0,D0    *CLEAR REGISTERS
                        MOVE.L #0,D1
                        MOVE.B #3,D6        *STORE REGISTER BIT(3) IN D4
                        JSR BITARR_TO_INT
                        MOVE.B D7,D4        *STORE NEXT 3 BITS IN D3
                        MOVE.B #3,D6
                        JSR BITARR_TO_INT    
                        MOVE.B D7,D3
                        MOVE.B #3, D6       *STORE MODE IN D6
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2
                        MOVE.B #3,D6        *STORE REGISTER IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA MULS_TEXT,A1    *PRINT MULS
                        MOVE.B #14,D0
                        TRAP #15
                        LEA SPACE_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        JSR PRINT_TOKEN     *PRINT SOURCE
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        MOVE.B D4,D1        *PRINT DEST. REGISTER
                        JSR PRINT_DN
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT  *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                        
CHECK_BCLR_DYNAMIC      MOVE.L #0,D0    *CLEAR REGISTERS
                        MOVE.L #0,D1
                        MOVE.B #3,D6        *STORE REGISTER BIT(3) IN D4
                        JSR BITARR_TO_INT
                        MOVE.B D7,D4        *STORE NEXT 3 BITS IN D3
                        MOVE.B #3,D6
                        JSR BITARR_TO_INT    
                        MOVE.B D7,D3
                        MOVE.B #3, D6       *STORE MODE IN D6
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2
                        MOVE.B #3,D6        *STORE REGISTER IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA BCLR_TEXT,A1    *PRINT BCLR
                        MOVE.B #14,D0
                        TRAP #15
                        LEA SPACE_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        MOVE.B D4,D1        *PRINT SOURCE REGISTER
                        JSR PRINT_DN
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        JSR PRINT_TOKEN     *PRINT DESTINATION
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT  *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                        

   
CHECK_DIVS_OR_CONST     MOVE.L #0,D0         *CLEAR REGISTERS
                        MOVE.L #0,D1
                        MOVE.B #3,D6        *STORE REGISTER BIT(3) IN D4
                        JSR BITARR_TO_INT
                        MOVE.B D7,D4        *STORE OPMODE 3 BITS IN D3
                        MOVE.B #3,D6
                        JSR BITARR_TO_INT    
                        MOVE.B D7,D3
                        CMP.B #7,D3
                        BEQ DIVS_BRANCH
                        BRA OR_BRANCH

                        *PROCESS DIVS
DIVS_BRANCH             MOVE.B #3, D6       *STORE MODE IN D6
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2
                        MOVE.B #3,D6        *STORE <EA> REGISTER IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA DIVS_TEXT,A1    *PRINT DIVS
                        MOVE.B #14,D0
                        TRAP #15
                        LEA SPACE_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        JSR PRINT_TOKEN     *PRINT SOURCE
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        MOVE.B D4,D1        *PRINT DEST. REGISTER
                        JSR PRINT_DN
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT  *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                        
OR_BRANCH               CMP.B #2,D3           *FIGURE OUT WHICH BRANCH TO GO TO, OPMODE IN D3
                        BLE OR_EA_DN
                        BRA OR_DN_EA
OR_EA_DN                MOVE.B #3,D6        *STORE EA MODE IN D2
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2 
                        MOVE.B #3,D6        *STORE EA REGISTER IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA OR_TEXT,A1      *PRINT 'OR'
                        MOVE.B #14,D0
                        TRAP #15
                        CMP.B #0,D3
                        BEQ OR_BYTE1             *FIGURE OUT SIZE
                        CMP.B #1,D3
                        BEQ OR_WORD1
                        BRA OR_LONG1
OR_BYTE1                LEA BYTE_TEXT,A1        *PRINT SIZE CODE
                        MOVE.B #14,D0
                        TRAP #15
                        BRA OR_EA_DN_CONT
OR_WORD1                LEA WORD_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        BRA OR_EA_DN_CONT
OR_LONG1                LEA LONG_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        BRA OR_EA_DN_CONT
OR_EA_DN_CONT           LEA SPACE_TEXT,A1
                        TRAP #15
                        JSR PRINT_TOKEN                       
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15                        
                        MOVE.B D4,D1
                        JSR PRINT_DN                       
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT    *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!
                        
OR_DN_EA                MOVE.B #3,D6        *STORE EA MODE IN D2
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2 
                        MOVE.B #3,D6        *STORE EA REGISTER IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA OR_TEXT,A1
                        MOVE.B #14,D0           *PRINT OR
                        TRAP #15
                        CMP.B #4,D3
                        BEQ OR_BYTE             *FIGURE OUT SIZE
                        CMP.B #5,D3
                        BEQ OR_WORD
                        BRA OR_LONG
OR_BYTE                 LEA BYTE_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        BRA OR_DN_EA_CONT
OR_WORD                 LEA WORD_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        BRA OR_DN_EA_CONT
OR_LONG                 LEA LONG_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        BRA OR_DN_EA_CONT
OR_DN_EA_CONT           LEA SPACE_TEXT,A1
                        TRAP #15                       
                        JSR PRINT_DN
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15                        
                        MOVE.B D4,D1
                        JSR PRINT_TOKEN                        
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT    *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!                         
                        
                
CHECK_LEA_CONST         MOVE.L #0,D0         *CLEAR REGISTERS
                        MOVE.L #0,D1
                        MOVE.B #3,D6        *STORE REGISTER BIT(3) IN D4
                        JSR BITARR_TO_INT
                        MOVE.B D7,D4        *STORE OPMODE 3 BITS IN D3
                        MOVE.B #3,D6
                        JSR BITARR_TO_INT    
                        MOVE.B D7,D3
                        MOVE.B #3, D6       *STORE MODE IN D6
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2
                        MOVE.B #3,D6        *STORE <EA> REGISTER IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA LEA_TEXT,A1    *PRINT LEA
                        MOVE.B #14,D0
                        TRAP #15
                        LEA SPACE_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        JSR PRINT_TOKEN     *PRINT SOURCE
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        MOVE.B D4,D1        *PRINT DEST. REGISTER
                        JSR PRINT_AN
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT  *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!

CHECK_SUBQ_CONST        MOVE.L #0,D0         *CLEAR REGISTERS
                        MOVE.L #0,D1
                        MOVE.B #3,D6        *STORE DATA BITS(3) IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        CMP #0,D1
                        BEQ SUBQ_PRINT_8                        
                        BRA SUBQ_PROC_CONT
SUBQ_PRINT_8            MOVE.B #8,D1
SUBQ_PROC_CONT          LEA SUBQ_TEXT,A1    *PRINT SUBQ
                        MOVE.B #14,D0
                        TRAP #15
                        MOVE.B #1,D6
                        JSR BITARR_TO_INT   *GET RID OF THE STUPID BIT
                        MOVE.B #2,D6        *GET SIZE BITS (2 BITS) STORES IN D3
                        JSR BITARR_TO_INT
                        MOVE.B D7,D3
                        CMP.B #0,D3         *PRINT SIZE CODE
                        BEQ SUBQ_BYTE
                        CMP.B #1,D3
                        BEQ SUBQ_WORD
                        BRA SUBQ_LONG
SUBQ_BYTE               LEA BYTE_TEXT,A1    
                        TRAP #15
                        BRA SUBQ_CONT
SUBQ_WORD               LEA WORD_TEXT,A1
                        TRAP #15
                        BRA SUBQ_CONT
SUBQ_LONG               LEA LONG_TEXT,A1
                        TRAP #15                    
SUBQ_CONT               LEA POUND_TEXT,A1
                        TRAP #15
                        MOVE.B #3,D0
                        TRAP #15
                        MOVE.B #3,D6        *GET <EA> MODE BITS(3BITS) STORE IN D2
                        JSR BITARR_TO_INT
                        MOVE.B D7,D2
                        MOVE.B #3, D6       *GET REGISTER BITS (3BITS) STORE IN D1
                        JSR BITARR_TO_INT
                        MOVE.B D7,D1
                        LEA COMMA_TEXT,A1
                        MOVE.B #14,D0
                        TRAP #15
                        JSR PRINT_TOKEN
                        JSR PRINT_NEXT_LINE
                        RTS
                        STOP #EXIT  *!!!!!CHANGE THIS ONCE THERE'S SOMEWHERE TO GO AFTER DECODING AN OPCODE!!!!!

                        
                        
                       



*****************************MOVEM REGISTER LIST PROC CODE***********************************************
PRINT_MOVEM_DREGS   *READS THE BIT MASK FOR THE MOVEM COMMAND AND PRINTS THE DATA REGISTERS IN THE SYNTAX
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST THE END OF SOURCE CODE
                    *GETS WORD TO READ FROM (A6) AND INCREMENTS
                    MOVE.W (A6)+,D4     *GRAB THE BITMASK AND STORE IN D4
                    MOVE.B #0, D6       *SET UP COUNTER FOR LOOP IN D6
                    MOVE.B #0, D5       *USED TO DETERMINE WHETHER TO PRINT /. PRINT IF GREATER THAN 0
MOVEM_DREGS_LOOP    CMP.B #8, D6       
                    BEQ MOVEM_DREGS_EXIT        *EXIT LOOP WHEN DONE WITH 8 BITS                    
                    ASR #1,D4                   *SHIFT BITS RIGHT AND CHECK THE CARRY
                    SCS D7                      *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D7              *CONVERT TO A ONE
                    CMP.B #1,D7
                    BEQ PRINT_DREGISTER          *IF A ONE WAS FOUND, PRINT IT OUT
                    BRA MOVEM_DLOOP_CONT        *OTHERWISE GO BACK TO START OF LOOP
PRINT_DREGISTER     MOVE.B #14,D0               *PREPARE FOR OUTPUT       
                    CMP.B #0, D5                *CHECK IF A SLASH NEEDS TO BE PRINTED
                    BEQ DONT_PRINT_SLASH        
                    LEA SLASH_TEXT,A1           *PRINT SLASH IF NECESSARY
                    TRAP #15    
DONT_PRINT_SLASH    LEA D_TEXT,A1               *PRINT 'D' FOR DATA REGISTER
                    TRAP #15
                    MOVE.B D6,D1                *MOVE THE CURRENT COUNTER TO PRINT
                    MOVE.B #3,D0                *PRINT COUNTER, COUNTER WILL BE THE CORRECT REGISTER NUMBER FOR CURRENT BIT
                    TRAP #15
                    ADD.B #1,D5                 *INCREMENT SLASH COUNTER                                              
MOVEM_DLOOP_CONT    ADD.B #1,D6                 *INCREMENT LOOP COUNTER
                    BRA MOVEM_DREGS_LOOP

                                *NOW PRINT THE ADDRESS REGISTERS
MOVEM_DREGS_EXIT    MOVE.B #0, D6               *SET UP COUNTER FOR LOOP IN D6
MOVEM_AREGS_LOOP    CMP.B #8, D6                *LOOP 8 TIMES TO GO THROUGH THE 8 REMAINING BITS IN BITMASK            
                    BEQ MOVEM_AREGS_EXIT     *EXIT LOOP WHEN DONE WITH WORD                    
                    ASR #1,D4                   *SHIFT BITS RIGHT AND CHECK THE CARRY
                    SCS D7                      *PUT $FF IN D2 IF WE SHIFTED OUT A 1; OTHERWISE LEAVE IT AS 0
                    DIVU.W #$FF,D7              *CONVERT TO A ONE
                    CMP.B #1,D7
                    BEQ PRINT_AREGISTER          *IF A ONE WAS FOUND, PRINT IT OUT
                    BRA MOVEM_ALOOP_CONT         *OTHERWISE GO BACK TO START OF LOOP
PRINT_AREGISTER     MOVE.B #14,D0               *PREPARE FOR OUTPUT       
                    CMP.B #0, D5                *CHECK IF A SLASH NEEDS TO BE PRINTED
                    BEQ DONT_PRINT_SLASHA        
                    LEA SLASH_TEXT,A1           *PRINT SLASH IF NECESSARY
                    TRAP #15    
DONT_PRINT_SLASHA   LEA A_TEXT,A1               *PRINT 'A' FOR ADDRESS REGISTER
                    TRAP #15
                    MOVE.B D6,D1                *MOVE THE CURRENT COUNTER TO PRINT
                    MOVE.B #3,D0                *PRINT COUNTER, COUNTER WILL BE THE CORRECT REGISTER NUMBER FOR CURRENT BIT
                    TRAP #15
                    ADD.B #1,D5                 *INCREMENT SLASH COUNTER
MOVEM_ALOOP_CONT    ADD.B #1,D6                 *INCREMENT LOOP COUNTER
                    BRA MOVEM_AREGS_LOOP               
MOVEM_AREGS_EXIT    RTS

****************************************************************************************************
               
                    *DETERMINE THE X-BIT NUMBER Y FROM THE NEXT X BITS STORED IN BYTES AT (A2)
                    *CALLER'S RESPONSIBILITY TO NOT RUN PAST END OF ARRAY
                    *INCREMENTS A2 BY X
                    *USES D6.B. VALUE WILL BE 0 WHEN THIS RETURNS.
                    *X SHOULD BE STORED IN D6.B
                    *Y WILL BE STORED IN D7.B
                    *X SHOULD NEVER BE 0 OR NEGATIVE. UNDEFINED BEHAVIOR IF X<=0. SERIOUSLY, JUST DON'T DO IT.
                    
BITARR_TO_INT       MOVE.L D5,-(SP)
                    CLR.L D7
                    MOVE.B (A2)+,D7 *MOVE THE FIRST BIT INTO D7
                    SUBQ.B #1,D6 *WE'VE ALREADY MOVED IN ONE BIT, SO DECREMENT X (USING IT AS LOOP CONTROL VARIABLE).
BATI_LOOP           CMP.B #0,D6
                    BEQ BATI_CLEANUP
                    CLR.L D5
                    LSL.W #1,D7 *BITSHIFT THE BITS WE'VE GOT SO FAR 1 TO THE LEFT
                    ADD.B (A2)+,D5 *ADD IN THE NEXT BIT AT THE 0-BIT, USE D5 TO RETAIN ARRAY INTEGRITY WHEN ADDING AS A WORD
                    ADD.W D5,D7        
                    SUBQ.B #1,D6 *DECREMENT X BECAUSE WE GOT ONE MORE BIT.
                    BRA BATI_LOOP
                    
BATI_CLEANUP        MOVE.L (SP)+,D5
                    RTS

                    *PRINT A COMMA (",")
                    *USES D0.B. VALUE WILL BE 14 WHEN THIS RETURNS.
                    *USES A1.L. WILL POINT TO "," WHEN THIS RETURNS.
PRINT_COMMA         LEA COMMA_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    RTS

                    
                    *PRINT THE NUMBER STORED IN D1.L IN HEX
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
PRINT_HEX           *STORE D2 AND D3, BECAUSE OTHER SUBROUTINES DON'T CHANGE THEM, AND FOR BACKWARDS COMPATIBILITY WITH CODE
                    *WRITTEN BEFORE NUMBER OUTPUT USED THEM.
                    MOVEM.L D2/D3,-(SP)
                    *MOVE THE VALUE TO D2; WE ACTUALLY WANT IT IN A REGISTER OTHER THAN D1.
                    MOVE.L D1,D2
                    *CLEAR OUT D1 BEFORE USE, SINCE WE'LL STORE A BYTE IN IT AND NEED EVERYTHING BEFORE TO BE 0.
                    MOVE.L #0,D1
                    *INITIALIZE D3 (COUNTER FOR NUMBER OF NUMBER OF NIBBLES WE'VE CHECKED) TO -1.
                    *EASIER TO START AT -1 AND INCREMENT AN EXTRA TIME.
                    MOVE.B #-1,D3
                    *PRINT "$"
                    LEA DOLLAR_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    *PREPARE FOR CHAR OUTPUT
                    MOVE.B #6,D0
                    
                    *SPECIAL CASE: VALUE==0 -> PRINT 0
                    CMP.L #0,D2
                    BNE PH_LEADING_ZEROS
                    LEA HEX_DIGITS,A1 *A1 POINTS TO 0 ALREADY, SO NO NEED TO ADD ANYTHING TO IT.
                    MOVE.B (A1),D1
                    TRAP #15
                    BRA PH_CLEANUP
                    
PH_LEADING_ZEROS    *STARTING FROM LARGEST NIBBLE OF D1 AND GOING SMALLER EACH TIME, INCREMENT PAST LEADING 0'S.
                    ADDQ.B #1,D3 *INCREMENT NUMBER OF BYTES WE'VE CHECKED. DOES IT ONE EXTRA TIME, WHICH IS ACCOUNTED
                                 *ABOVE BY STARTING COUNTER AT -1.
                    ROL.L #4,D2
                    MOVE.B D2,D1
                    AND.B #$0F,D1 *CHANGE LARGER NIBBLE OF D1.B TO 0 SO WE'RE JUST WORKING WITH THE SMALLER NIBBLE.
                    CMP.B #0,D1
                    BEQ PH_LEADING_ZEROS
                    
PH_PRINT_LOOP       *PRINT EACH NIBBLE UNTIL WE'VE DONE THE WHOLE LONG
                    MOVE.B D2,D1
                    AND.B #$0F,D1 *CHANGE LARGER NIBBLE OF D1.B TO 0 SO WE'RE JUST WORKING WITH THE SMALLER NIBBLE.
                    
                    *NOW THAT WE'VE ISOLATED THE NIBBLE IN D1, PRINT IT.
                    LEA HEX_DIGITS,A1 *A1 POINTS TO 0.
                    ADDA.L D1,A1 *MOVE A1 TO DIGIT WE WANT TO PRINT.
                    MOVE.B (A1),D1
                    TRAP #15
                    
                    *ROTATE IN NEXT NIBBLE, INCREMENT NIBBLE COUNTER, AND LOOP AGAIN,
                    *UNLESS WE'VE ALREADY DONE THE WHOLE LONG, IN WHICH CASE WE'RE DONE.
                    ROL.L #4,D2
                    ADDQ.B #1,D3
                    CMP.B #NIBBLES_PER_LONG_CONST,D3
                    BNE PH_PRINT_LOOP
                    
PH_CLEANUP          MOVEM.L (SP)+,D2/D3
                    RTS
                    
                    *PRINT THE NEXT BYTE FROM THE SOURCE CODE (AND INCREMENT A6)
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE CODE, OR LEAVE AN ADDRESS INVALID FOR WORD ACCESS
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
PRINT_BYTE          MOVE.L #0,D1 *CLEAR OUT D1.L FOR OUTPUT.
                    MOVE.B (A6)+,D1
                    JSR PRINT_HEX
                    RTS


                    
                    *PRINT THE NEXT WORD FROM THE SOURCE CODE (AND INCREMENT A6)
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE CODE
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D1.L. UNKNOWN WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
PRINT_WORD          MOVE.L #0,D1 *CLEAR OUT LARGER WORD OF D1 FOR OUTPUT.
                    MOVE.W (A6)+,D1
                    JSR PRINT_HEX                    
                    RTS
                    
                    *PRINT THE NEXT LONG FROM THE SOURCE CODE (AND INCREMENT A6)
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE CODE
                     *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
PRINT_LONG          *READ THE NEXT LONG INTO D1, ONE WORD AT A TIME.
                    MOVE.W (A6)+,D1
                    LSL.L #8,D1
                    LSL.L #8,D1
                    MOVE.W (A6)+,D1
                    JSR PRINT_HEX
                    RTS 

                    *PRINT THE NEXT WORD OR LONG IMMEDIATE FROM SOURCE CODE, DEPENDING ON SIZE
                    *SIZE CODE SHOULD BE STORED IN D3
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS.
PRINT_IMM           *PRINT_LONG_IMM IF LONG; OTHERWISE PRINT BYTE_IMM
                    CMP.B #LONG_CODE,D3
                    BEQ PRINT_LONG_IMM
                    BRA PRINT_WORD_IMM

                    *PRINT THE NEXT BYTE FROM THE SOURCE CODE AS A BYTE IMMEDIATE (AND INCREMENT A6)
                    *I KNOW THERE'S NO SUCH THING AS A WORD IMMEDIATE, BUT IT'S STILL USEFUL, BECAUSE SOMETIMES VALUES WRITTEN AS IMMEDIATES ARE STORED AS BYTES
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS
PRINT_BYTE_IMM      LEA POUND_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    JSR PRINT_BYTE
                    RTS 
                    


                    *PRINT THE NEXT WORD FROM THE SOURCE CODE AS A WORD IMMEDIATE (AND INCREMENT A6)
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE CODE
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS.
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS.
PRINT_WORD_IMM      LEA POUND_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    JSR PRINT_WORD
                    RTS
                    
                    *PRINT THE NEXT LONG FROM THE SOURCE CODE AS A LONG IMMEDIATE (AND INCREMENT A6)
                    *CALLER'S RESPONSIBILITY NOT TO RUN PAST END OF SOURCE CODE
                    *USES D1.L. UNKNOWN VALUE WHEN THIS RETURNS
                    *USES D0.B. VALUE WILL BE 6 WHEN THIS RETURNS.
                    *USES A1.L. UNKNOWN VALUE WHEN THIS RETURNS
PRINT_LONG_IMM      LEA POUND_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    JSR PRINT_LONG
                    RTS
                    
                    *PRINT THE NAME OF A D-REGISTER CORRESPONDING TO THE VALUE IN D1.L
                    *USES D0.B. VALUE WILL BE 3 WHEN THIS RETURNS.
                    *USES A1. WILL POINT TO "D" WHEN THIS RETURNS.
PRINT_DN            LEA D_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    MOVE.B #3,D0
                    TRAP #15
                    RTS
                    
                    *PRINT THE NAME OF AN A-REGISTER CORRESPONDING TO THE VALUE IN D1.L
                    *USES D0.B. VALUE WILL BE 3 WHEN THIS RETURNS.
                    *USES A1. WILL POINT TO "A" WHEN THIS RETURNS.
PRINT_AN            LEA A_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    MOVE.B #3,D0
                    TRAP #15
                    RTS
                    
                    *PRINT THE NAME OF AN A-REGISTER CORRESPONDING TO THE VALUE IN D1.L, IN PARENTHESES
                    *USES D0.B. VALUE WILL BE 14 WHEN THIS RETURNS.
                    *USES A1. WILL POINT TO ")" WHEN THIS RETURNS.
PRINT_PAREN_AN      LEA OPEN_PAREN_A_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    MOVE.B #3,D0
                    TRAP #15
                    LEA CLOSE_PAREN_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    RTS
                    
                    *PRINT THE NAME OF AN A-REGISTER CORRESPONDING TO THE VALUE IN D1.L, IN PARENTHESES WITH POST-INCREMENT
                    *USES D0.B. VALUE WILL BE 14 WHEN THIS RETURNS.
                    *USES A1. WILL POINT TO ")+" WHEN THIS RETURNS.
PRINT_AN_POST_INC   LEA OPEN_PAREN_A_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    MOVE.B #3,D0
                    TRAP #15
                    LEA CLOSE_PAREN_PLUS_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    RTS
                    
                    *PRINT THE NAME OF AN A-REGISTER CORRESPONDING TO THE VALUE IN D1.L, IN PARENTHESES WITH PRE-DECREMENT
                    *USES D0.B. VALUE WILL BE 14 WHEN THIS RETURNS.
                    *USES A1. WILL POINT TO ")" WHEN THIS RETURNS.
PRINT_AN_PRE_DEC    LEA MINUS_OPEN_PAREN_A_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    MOVE.B #3,D0
                    TRAP #15
                    LEA CLOSE_PAREN_TEXT,A1
                    MOVE.B #14,D0
                    TRAP #15
                    RTS
                    
PRINT_NEXT_LINE     *PRINTS A CARRIAGE RETURN AND A LINE FEED
                    LEA CRLF,A1
                    MOVE.B #14,D0
                    TRAP #15
                    RTS
                    
                    *PRINTS THE CORRESPONDING TOKEN GIVEN A REGISTER NUMBER, ADDRESSING MODE, AND SIZE.
                    *READS ADDITIONAL WORDS FROM SOURCE IF NECESSARY (LITERALS).
                    *REGISTER NUMBER SHOULD BE IN D1.L.
                    *ADDRESSING MODE SHOULD BE IN D2.B.
                    *SIZE SHOULD BE IN D3.B. (UNNECESSARY IF YOU KNOW IT WON'T BE AN IMMEDIATE).
                    *USES A1.L. UNPREDICTABLE VALUE WILL BE STORED IN A1.L WHEN THIS RETURNS.
                    *USES D0.B. UNPREDICTABLE VALUE WILL BE STORED IN D0.B WHEN THIS RETURNS.
                    *USES D1.L. UNPREDICTABLE VALUE WILL BE STORED IN D1.L WHEN THIS RETURNS.
PRINT_TOKEN         *CHECK EA MODE TO PRINT TOKEN ACCORDINGLY
                    CMP.B #DATA_REGISTER_CONST,D2
                    BEQ PT_DATA_REGISTER
                    CMP.B #ADDRESS_REGISTER_CONST,D2
                    BEQ PT_ADDRESS_REGISTER
                    CMP.B #NO_INC_DEC_CONST,D2
                    BEQ PT_NO_INC_DEC
                    CMP.B #POST_INC_CONST,D2
                    BEQ PT_POST_INC
                    CMP.B #PRE_DEC_CONST,D2
                    BEQ PT_PRE_DEC
                    *ELSE LITERAL
                    *CHECK WHETHER WORD ADDRESS, LONG ADDRESS, OR IMMEDIATE
                    CMP.B #WORD_ADDRESS_CONST,D1
                    BEQ PT_WORD_ADDRESS
                    CMP.B #LONG_ADDRESS_CONST,D1
                    BEQ PT_LONG_ADDRESS
                    *ELSE IMMEDIATE
                    CMP.B #LONG_CODE,D3 *CHECK IF LONG IMMEDIATE
                    BEQ PT_LONG_IMM
                    *ELSE WORD IMMEDIATE
                    JSR PRINT_WORD_IMM
                    RTS
PT_WORD_ADDRESS     JSR PRINT_WORD
                    RTS
PT_LONG_ADDRESS     JSR PRINT_LONG
                    RTS
PT_DATA_REGISTER    JSR PRINT_DN
                    RTS
PT_ADDRESS_REGISTER JSR PRINT_AN
                    RTS
PT_NO_INC_DEC       JSR PRINT_PAREN_AN
                    RTS
PT_POST_INC         JSR PRINT_AN_POST_INC
                    RTS
PT_PRE_DEC          JSR PRINT_AN_PRE_DEC
                    RTS
PT_LONG_IMM         JSR PRINT_LONG_IMM
                    RTS

    SIMHALT             ; halt simulator

* Put variables and constants here
CR EQU $0A
LF EQU $0D

CURRENT_WORD_ARRAY DC.B    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
TEST_NOOP1 DC.W %0100111001110001
NOOP       DC.W $4E71

TEST_MOVEB1 DC.W %0001001000000011   * MOVE.B D3,D1
TEST_MOVEB2 DC.W $1203

TEST_MOVEL1 DC.W $203C,$0001,$2345 *MOVE.L #$12345,D0

TEST_MOVEAW1 DC.W $3079,$0001,$2345 *MOVEA.W $12345,A0

TEST_MOVEW1 DC.W $303C,$1234 *MOVE.W #$1234,D0
TEST_MOVEM  DC.W $4891,$0003 *MOVEM D0/D1, (A1)
TEST_MOVEM2 DC.W $4CB8,$6000,$0000 *MOVEM $0000, A5/A6
TEST_MOVEM3 DC.W $4CB8,$0015,$1000 *MOVEM $1000, D0/D2/D4
TEST_MOVEM4 DC.W $4C94,$0002        *MOVEM (A4), D1

TEST_BRA    DC.W $60FC
TEST_BRA2   DC.W $6000,$0010
TEST_BRA3   DC.W $6000,$000E
TEST_BRA4   DC.W $60D8

TEST_NEG    DC.W $4446
TEST_CMPI   DC.W $0C78,$03E8,$2000
TEST_ORI    DC.W $0078,$03E8,$2000
NOOP_T      DC.B    'NOP',0
TEST_MULS   DC.W $C5FC,$0064
TEST_DIVS   DC.W $83FC,$0064
TEST_OR     DC.W $8278,$1000
TEST_OR2    DC.W $8278,$1000
TEST_OR3    DC.W $8238,$1000
TEST_OR4    DC.W $8338,$1000
TEST_LEA    DC.W $43F9,$0000,$100A
TEST_SUBQ   DC.W $5941

TEST_CODE   DC.W    $4E71

TEST_BLOCK  DC.W $303C,$1234,$0C78,$03E8,$2000,$8278,$1000,$3079,$0001,$2345


*****TEXT

HEX_DIGITS DC.B '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'



*CHARACTERS
POUND_TEXT DC.B '#',0
DOLLAR_TEXT DC.B '$',0
COMMA_TEXT DC.B ',',0
D_TEXT DC.B 'D',0
A_TEXT DC.B 'A',0
OPEN_PAREN_A_TEXT DC.B '(A',0
CLOSE_PAREN_TEXT DC.B ')',0
MINUS_OPEN_PAREN_A_TEXT DC.B '-(A',0
CLOSE_PAREN_PLUS_TEXT DC.B ')+',0
SLASH_TEXT  DC.B '/',0
SPACE_TEXT  DC.B ' ',0

*SIZE
BYTE_TEXT DC.B '.B ',0
WORD_TEXT DC.B '.W ',0
LONG_TEXT DC.B '.L ',0

*OPERATION
ADD_TEXT    DC.B    'ADD',0
ADDA_TEXT   DC.B    'ADDA',0
ADDI_TEXT   DC.B    'ADDI',0
ADDQ_TEXT   DC.B    'ADDQ',0
ASR_TEXT    DC.B    'ASR',0
ASL_TEXT    DC.B    'ASL',0
BHI_TEXT    DC.B    'BHI',0
BLO_TEXT    DC.B    'BLO',0
BEQ_TEXT    DC.B    'BEQ',0
BGE_TEXT    DC.B    'BGE',0
BGT_TEXT    DC.B    'BGT',0
BCS_TEXT    DC.B    'BCS',0
BLE_TEXT    DC.B    'BLE',0
BLS_TEXT    DC.B    'BLS',0
BLT_TEXT    DC.B    'BLT',0
BMI_TEXT    DC.B    'BMI',0
BNE_TEXT    DC.B    'BNE',0
BPL_TEXT    DC.B    'BPL',0
BRA_TEXT    DC.B    'BRA',0
BVC_TEXT    DC.B    'BVC',0
BVS_TEXT    DC.B    'BVS',0
BCLR_TEXT   DC.B    'BCLR',0
CMP_TEXT    DC.B    'CMP',0
CMPA_TEXT   DC.B    'CMPA',0
CMPI_TEXT   DC.B    'CMPI',0
DATA_TEXT   DC.B    'DATA ',0
DIVS_TEXT   DC.B    'DIVS',0
EOR_TEXT    DC.B    'EOR',0
JSR_TEXT    DC.B    'JSR',0
LEA_TEXT    DC.B    'LEA',0
LSL_TEXT    DC.B    'LSL',0
LSR_TEXT    DC.B    'LSR',0
MOVE_TEXT   DC.B    'MOVE',0
MOVEA_TEXT  DC.B    'MOVEA',0
MOVEM_TEXT  DC.B    'MOVEM',0
MULS_TEXT   DC.B    'MULS',0
NEG_TEXT    DC.B    'NEG',0
OR_TEXT     DC.B    'OR',0
ORI_TEXT    DC.B    'ORI',0
ROR_TEXT    DC.B    'ROR',0
ROL_TEXT    DC.B    'ROL',0
RTS_TEXT    DC.B    'RTS',0
SUB_TEXT    DC.B    'SUB',0
SUBA_TEXT   DC.B    'SUBA',0
SUBI_TEXT   DC.B    'SUBI',0
SUBQ_TEXT   DC.B    'SUBQ',0

*******LOOP VARIABLES***********

COUNTER DC.B     20
CRLF    DC.B    $D,$A,0         carriage return & line feed, null
TEST2    DC.B    '---------------------------------',CR,LF,0
PROMPT1 DC.B    'Enter start address of array = ',0
PROMPT2 DC.B    'Enter end address of array = ',0
PROMPT3 DC.B    'Press any key to display next page, 1 for terminate',CR,LF,0
REGISTER_STORAGE   DC.L    0,0
TEST    DC.W    $8178,$4000
  
*$8239,$FF02,$AB89


ASD_TEST DC.W $E326,$E366,$E3A6,$E106,$E146,$E186,$E1F9,$FF02,$AB89,$E226,$E266,$E2A6,$E006,$E046,$E086,$E0F9,$FF02,$AB89 *18 WORDS
BCLR_TEST DC.W $0887,$0000,$03B9,$FF02,$AB89,$03B9,$FF02,$AB89,$08B9,$0009,$FF02,$AB89,$08B9,$00FF,$FF02,$AB89  *16 WORDS 34 TOTAL
BCC_TEST DC.W $6500,$2FFE,$6500,$2FFA,$6500,$2FF6,$6700,$2FF2,$6700,$2FEE,$6700,$2FEA,$6C00,$2FE6,$6C00,$2FE2,$6C00,$2FDE,$6E00,$2FDA,$6E00,$2FD6,$6E00,$2FD2,$6200,$2FCE,$6200,$2FCA,$6200,$2FC6,$6500,$2FC2,$6500,$2FBE,$6500,$2FBA,$6F00,$2FB6 
BCC2_TEST DC.W $6F00,$2FB2,$6F00,$2FAE,$6D00,$2FAA,$6D00,$2FA6,$6D00,$2FA2,$6300,$2F9E,$6300,$2F9A,$6300,$2F96,$6B00,$2F92,$6B00,$2F8E,$6B00,$2F8A,$6600,$2F86,$6600,$2F82 *26 WORDS 98 TOTAL
BCC3_TEST DC.W $6600,$2F7E,$6A00,$2F7A,$6A00,$2F76,$6A00,$2F72,$6000,$2F6E,$6000,$2F6A,$6000,$2F66 *14 WORDS, 112 TOTAL
BCC4_TEST DC.W $6800,$2F62,$6800,$2F5E,$6800,$2F5A,$6900,$2F56,$6900,$2F52,$6900,$2F4E *12 words 124 total
CMP_TEST DC.W $BC01,$BC41,$BC81,$BC51,$B2B9,$10FC,$B901,$0C01,$0007,$0C41,$0FA0,$0C81,$0000,$0FA0,$0C16,$0007,$0C56,$0FA0,$0C96,$10FC,$B901 *21 words 145
DIVS_TEST DC.W $83F9,$10FC,$B901,$83F9,$FF02,$AB89 *6 words 151 total
EOR_TEST DC.W $B346,$B306,$B346,$B386,$B317,$B357,$B397,$B339,$FF02,$AB89,$B379,$FF02,$AB89,$B3B9,$FF02,$AB89,$B338,$0FA0,$B378,$0FA0,$B3B8,$0FA0 *22 words 173 total
JSR_TEST DC.W $4EB8,$1000,$4E97,$4EB9,$FF02,$AB89,$4EB8,$0FA0 *8 words 181 total
LEA_TEST DC.W $4DF9,$FF02,$AB89,$4DF8,$03E8 *5 words 186 total
LSD_TEST DC.W $E32E,$E36E,$E3AE,$E10E,$E14E,$E18E,$E3F9,$FF02,$AB89,$E22E,$E26E,$E2AE,$E00E,$E04E,$E08E,$E2F9,$FF02,$AB89 *18 words, 204 words
MOV_TEST DC.W $1C01,$3C01,$2C01,$1C3C,$0001,$3C3C,$03E8,$2C3C,$FF02,$AB89,$1C39,$FF02,$AB89,$3C39,$FF02,$AB89 *16 words, 220 words
MOV2_TEST DC.W $2C39,$FF02,$AB89,$13F9,$FF02,$AB89,$EF02,$AB89,$33F9,$FF02,$AB89,$EF02,$AB89,$23F9,$FF02,$AB89,$EF02,$AB89,$3C0B,$2C0B,$1C1D,$3C1D,$2C1D,$1F18,$3F18,$2F18 *26 words 246
MOVEA_TEST DC.W $3C41,$2C41,$3C7C,$03E8,$2C7C,$FF02,$AB89,$3C79,$FF02,$AB89,$2C79,$FF02,$AB89,$3C4B,$2C4B,$3C5D,$2C5D,$3C67,$2C67 *19 words, 265 total
MOVEM_TEST DC.W $48B9,$FFFF,$FF02,$AB89,$48F9,$FFFF,$FF02,$AB89,$4CB9,$FFFF,$FF02,$AB89,$4CF9,$FFFF,$FF02,$AB89 *16 words 281 total
MULUS_TEST DC.W $C3F9,$FF02,$AB89,$C3FC,$0FA0 *5 words 286 total
NEG_TEST DC.W $4401,$4441,$4481,$4411,$4451,$4491,$4439,$FF02,$AB89,$4479,$FF02,$AB89,$44B9,$FF02,$AB89,$4427,$4467,$44A7,$441D,$445D,$449D *21 words 307 total
OR_TEST DC.W $8C01,$8C41,$8C81,$8239,$FF02,$AB89,$8279,$FF02,$AB89,$82B9,$FF02,$AB89,$8215,$8255,$8295,$821D,$825D,$829D,$823C,$0007,$827C,$0FA0,$82B9,$FF02,$AB89
ORI_TEST DC.W $0001,$0007,$0041,$0FA0,$0081,$FF02,$AB89,$0039,$0007,$FF02,$AB89,$0079,$0FA0,$FF02,$AB89,$00B9,$FE02,$AB89,$FF02,$AB89,$0016,$0007,$0056,$0FA0,$0096,$FF02,$AB89,$001E,$0007,$005E,$0FA0,$009E,$FF02,$AB89 *34 words, 341 total
ROD_TEST DC.W $E33E,$E37E,$E3BE,$E11E,$E15E,$E19E,$E7F9,$FF02,$AB89,$E23E,$E27E,$E2BE,$E01E,$E05E,$E09E,$E6F9,$FF02,$AB89 *18 words, 359 total
SUB_TEST DC.W $9C01,$9C41,$9C81,$5106,$5146,$5186,$9CC1,$9CC1,$925F,$9567,$9C49,$9C89,$9379,$FF02,$AB89 *15 words 374 total
SUBQ_TEST DC.W $5106,$5146,$5186,$5139,$FF02,$AB89,$5179,$FF02,$AB89,$51B9,$FF02,$AB89 *12 words 386 total
    END    START        ; last line of source






























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
