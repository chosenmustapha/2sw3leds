;******************************************************************************
;   This file is a basic template for creating relocatable assembly code for  *
;   a PIC18F1330. Copy this file into your project directory and modify or    *
;   add to it as needed.                                                      *
;                                                                             *
;   The PIC18FXXXX architecture allows two interrupt configurations. This     *
;   template code is written for priority interrupt levels and the IPEN bit   *
;   in the RCON register must be set to enable priority levels. If IPEN is    *
;   left in its default zero state, only the interrupt vector at 0x008 will   *
;   be used and the WREG_TEMP, BSR_TEMP and STATUS_TEMP variables will not    *
;   be needed.                                                                *
;                                                                             *
;   Refer to the MPASM User's Guide for additional information on the         *
;   features of the assembler and linker.                                     *
;                                                                             *
;******************************************************************************
;                                                                             *
;    Filename:                                                                *
;    Date:                                                                    *
;    File Version:                                                            *
;                                                                             *
;    Author:                                                                  *
;    Company:                                                                 *
;                                                                             * 
;******************************************************************************
;                                                                             *
;    Files required: P18F1330.INC                                             *
;                                                                             *
;******************************************************************************

    LIST P=18F1330, F=INHX32 ;directive to define processor and file format
    #include <P18F1330.INC>	 ;processor specific variable definitions

;******************************************************************************
;Configuration bits
;Microchip has changed the format for defining the configuration bits, please 
;see the .inc file for futher details on notation.  Below are a few examples.



;   Oscillator Selection:
  ;  CONFIG	OSC = LP             ;LP

  CONFIG	OSC	=   INTIO1
  CONFIG	WDT	=   OFF



;******************************************************************************
;Variable definitions
; These variables are only needed if low priority interrupts are used. 
; More variables may be needed to store other special function registers used
; in the interrupt routines.

    UDATA

WREG_TEMP	RES	1	;variable in RAM for context saving 
STATUS_TEMP	RES	1	;variable in RAM for context saving
BSR_TEMP	RES	1	;variable in RAM for context saving

    UDATA_ACS

EXAMPLE		RES	1	;example of a variable in access RAM

;******************************************************************************
;EEPROM data
; Data to be programmed into the Data EEPROM is defined here

DATA_EEPROM	CODE	0xf00000

    DE	"Test Data",0,1,2,3,4,5

;******************************************************************************
;Reset vector
; This code will start executing when a reset occurs.

RESET_VECTOR	CODE	0x0000

    goto	Main		;go to start of main code

;******************************************************************************
;High priority interrupt vector
; This code will start executing when a high priority interrupt occurs or
; when any interrupt occurs if interrupt priorities are not enabled.

HI_INT_VECTOR	CODE	0x0008

    bra	HighInt		;go to high priority interrupt routine

;******************************************************************************
;Low priority interrupt vector
; This code will start executing when a low priority interrupt occurs.
; This code can be removed if low priority interrupts are not used.

LOW_INT_VECTOR	CODE	0x0018

    bra	LowInt		;go to low priority interrupt routine

;******************************************************************************
;High priority interrupt routine
; The high priority interrupt code is placed here.

    CODE

HighInt:

;	*** high priority interrupt code goes here ***


    retfie	FAST

;******************************************************************************
;Low priority interrupt routine
; The low priority interrupt code is placed here.
; This code can be removed if low priority interrupts are not used.

LowInt:
    movff	STATUS,STATUS_TEMP	;save STATUS register
    movff	WREG,WREG_TEMP		;save working register
    movff	BSR,BSR_TEMP		;save BSR register

;	*** low priority interrupt code goes here ***


    movff	BSR_TEMP,BSR		;restore BSR register
    movff	WREG_TEMP,WREG		;restore working register
    movff	STATUS_TEMP,STATUS	;restore STATUS register
    retfie

;******************************************************************************
;Start of main program
; The main program code is placed here.

Main:
		
    MOVLW 7C	
    MOVWF OSCCON	
    BSF TRISB, 0	
    BSF TRISB, 1	
    BCF TRISB, 4	
    BCF TRISB, 5	
    BCF TRISA, 1	
	
CONDITION	
    BTFSS PORTB,0    
    BRA Switch2_Not_Pushed 
    BRA Switch2_Pushed  
 
Switch2_Pushed
    BTFSC PORTB,1  
    BRA Blink2
    BRA Blink1
 
Switch2_Not_Pushed
    BTFSC PORTB,1
    BRA Blink1
    BRA Blink2
 
Blink1
    BSF PORTB,4
    BSF PORTB,5
    BSF	PORTA,1
    BRA CONDITION
 
    MOVLW 33
 
Blink2 
    BCF PORTB,5
    BCF PORTB,4
    BCF PORTA,1
    BRA CONDITION
 
    MOVLW 33


;	*** main code goes here ***


;******************************************************************************
;End of program

    END
