***************************************************************
*
* Title: Dimming the LED lights 
*
* Objective: CSE472 Homework 3
* 
* Revision: V2.1
*
* Date: January 30 2019
*
* Programmer: Trishita Bhattacharya
*
* Company : The Pennsylvania State Uninveristy, EECS
*
* Algorithm: Parallel Port I/O in a delay-loop.
*
* Register use: A: Light on/off state, Switch SW1 on/off state and dim level
*               B: Delay loop counters
*
* Memory use: RAM Locations from $3000 for data, 
*                                $3100 for program
*
* Input: Parameters hard coded in the program.
*        Switch SW1 at PORTP bit  0 
*
* Output: LED 1,2,3,4 at PORTBbit 4,5,6,7
*
* Observation: This is a program that uses parallel port I/O, subroutine, 
*              looping, and timing to dim the LED lights using PWM technique
*
***************************************************************
* Parameter Declaration Section
*
* Export Symbols
          XDEF      pgstart   ; export 'pgstart' symbol
          ABSENTRY  pgstart   ; for assembly entry point
*                             ; This is the first instruction of the program
*                             ; up on the start of simulation

* Symbols and Macros
PORTA     EQU     $0000       ; i/o port addresses (pot A not used) 
DDRA     EQU      $0002

PORTB     EQU     $0001       ; PORT B is connected with LEDs
DDRB      EQU     $0003
PUCR      EQU     $000C       ; to enable pull-up mode for PORT A, B, E, K

PTP       EQU     $0258       ; PORTP data register. used for Push Switch
PTIP      EQU     $0259       ; PORTP input register
DDRP      EQU     $025A       ; PORTP data direction register
PERP      EQU     $025C       ; PORTP pull up/down enable
PPSP      EQU     $025D       ; PORTP pull up/dpwn selection

***************************************************************
* Data Section

          ORG     $3000       ; reserved RAM memory starting address
                              ; Memory $3000 to $30FF are for Data
Counter1  DC.B    $EC         ; delay 10usec count number

StackSpace                    ; remaining memory space for stack data
                              ; initial stack pointer position set
                              ; to $3100 (pgstart)
*
***************************************************************
* Program Section

          ORG     $3100                ; Program start address, in RAM
pgstart   LDS     #pgstart             ; initialize the stack pointer

          LDAA    #%11110000           ; set PORTB bit 7,5,6,4 as output, 3,2,1,0 as input
          STAA     DDRB                ; LED 1,2,3,4 on PORTB bit 4,5,6,7
                                       ; DIP switch 1,2,3,4 on PORTB bit 0,1,2,3
          BSET    PUCR, %00000010      ; enable PORTB pull up/down feature, for the
                                       ; DIP switch 1,2,3,4 on the bits 0,1,2,3
          BCLR    DDRP, %00000011      ; Push Button Switch 1 and 2 at PORTP bit 0 and 1
                                       ; set PORTP bit 0 and 1 as input
          BSET    PERP, %00000011      ; enable the pull up/down feature at PORTP bit 0 and 1
          BCLR    PPSP, %00000011      ; select pull up feature at PORTP bit 0 and 1 for the 
                                       ; Push Button Switch 1 and 2.
          LDAA    #%01110000           ; Turn off lED 1,2,3 at PORTB bit 4,5,6 and turn on lED 4 at PORTB bit 7
          STAA    PORTB                ; NOTE; LED numbers and PORTB bit numbers are different
          
mainLoop  LDAA    PTIP                 ; Read push button SW1 at PORTP0
          ANDA    #%00000001           ; check the but 0 only
          BEQ     sw1pushed
swlnotpush LDAA   #$08
  onLoop: BCLR    PORTB, %10000000     ; Turn on LED 4 at PORTB7
          BSET    PORTB, %01000000     ; Turn off LED 3 at PORTB6
          BCLR    PORTB, %00100000     ; Turn on LED 2 at PORTB5
          BSET    PORTB, %00010000     ; Turn off LED 1 at PORTB4
          JSR     delay10usec          ; Wait for 10us 
          SUBA    #$1                  ; Decrease loop counter by 1
          BNE     onLoop
          LDAA    #$5C
 offLoop: BCLR    PORTB, %10000000     ; Turn on LED 4 at PORTB7
          BSET    PORTB, %01000000     ; Turn off LED 3 at PORTB6
          BSET    PORTB, %00100000     ; Turn off LED 2 at PORTB5
          BSET    PORTB, %00010000     ; Turn off LED 1 at PORTB4
          JSR     delay10usec          ; Wait for 10us 
          SUBA    #$1                  ; Decrease loop counter by 1
          BNE     offLoop
          BRA     mainLoop            ; loop forever
          
sw1pushed LDAA    #$12
  onLoop1:BCLR    PORTB, %10000000     ; Turn off LED 4 at PORTB7
          BSET    PORTB, %01000000     ; Turn off LED 3 at PORTB6
          BCLR    PORTB, %00100000     ; Turn on LED 2 at PORTB5
          BSET    PORTB, %00010000     ; Turn off LED 1 at PORTB4
          JSR     delay10usec          ; Wait for 10us 
          SUBA    #$1                  ; Decrease loop counter by 1
          BNE     onLoop1     
          LDAA    #$52
 offLoop1:BCLR    PORTB, %10000000     ; Turn onn LED 4 at PORTB7
          BSET    PORTB, %01000000     ; Turn off LED 3 at PORTB6
          BSET    PORTB, %00100000     ; Turn off LED 2 at PORTB5
          BSET    PORTB, %00010000     ; Turn off LED 1 at PORTB4
          JSR     delay10usec          ; Wait for 10us 
          SUBA    #$1                  ; Decrease loop counter by 1
          BNE     offLoop
          BRA     mainLoop            ; loop forever 
       
          
**************************************************************
* Subroutine Section   
*


; **************************************************************
; delay10usec subroutine
;
; This subroutine causes 10 usec. delay
;
; Input: a 8 bit count number in 'Counter1'
; Output: timedelay cpu cylce waited
; Registers: B register as counter
; Memory locations: a 8bit input number in 'Counter1'        
          
delay10usec
          
          LDAB    Counter1          ; short delay
dlyLoop   SUBB    #$01
          BNE     dlyLoop
         
          RTS                                  
          
          end                       ; last line of file