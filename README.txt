Objective
Learn simple HC12 assembly program for the parallel port I/O, subroutine, looping, and timing. Dimming the LED lights using PWM (Pulse Width Modulation) technique.

Instruction
Read the textbook (Valvano) Sections for I/O ports. Also read the MC9S12C128 CPU Reference Manual and the MC9S12C chip Data Sheet. Again, you do NOT need to understand all of them at this time.

Your program MUST be run on the CSM-12C128 board to see the LED light dimming. To work with the CSM-12C128 board, you must download the HyperTerminal program (click here) and install it on your computer. The step by step guide using the USB-to-Serial cable, installing the HyperTerminal, connecting the CSM-12C128 board with HyperTerminal is posted: Guide - USB, HyperTerminal, and CSM-12C128 board connection. (The USB-to-Serial cable driver should be auto-installed - it is a part of the MS Windows System - when you plug in the cable. In case if you have problem, here is the driver software - click here. )

To test CSM-12C128 board and your computer connection, load your Homework 2 program (or the sample Homework 2 program) to the CSM-12C128 board from your computer and run. Be sure to check the LED blinking from your Homework 2, correctly operating on the CSM-12C128 board.

Suggested experiment: can you change your Homework 2 program to make the LED blinking faster? One can simply reduce the 'Counter1' and/or 'Counter2' number used for the delay subroutine. What values of 'Counter1' and 'Counter2' will cause you to not see the LED blinking, such that LED lights become steady lit?

Homework 3 question: What values of 'Counter1' and 'Counter2' will cause the sample Homework 2 LED blinking 1000 time per each second?

Now, check the PWM introduction material: 
Introduction to PWM, 
Pulse-width modulation, 
more intro to PWM, and 
Pulse-width modulation on Wikipedia.

Write the program, 'main.asm', to dimm the LED lights on CSM-12C128 board as follows:

Initial state of LED lights:
(0) LED 1 is OFF (0%), LED 2 is ON (100%), and LED 3 is OFF (0%).

SW1 NOT pressed:
(1) LED 4 lit with light level to 9% and repeat.

SW1 pressed:
(2) LED 4 lit with light level to 19% and repeat.

Suggested light level control (dimming) algorithm is outlined below:
            initialize
mainloop:   check sw1
                 if sw1 not pressed      ; 9% light level
                      set counter ONN=9
                      set counter OFF=91
                      turn-on LED 4
                           loop 9 times (using counter ONN, call delay10usec 9 time)
                      turn-off LED 4
                           loop 91 times (using counter OFF, call delay10usec 91 time)
                      goto mainloop

                 if sw1 pressed           ; 19% light level
                      set counter ONN=19
                      set counter OFF=81
                      turn-on LED 4
                           loop 19 times (using counter ONN, call delay10usec 19 time)
                      turn-off LED 4
                           loop 81 times (using counter OFF, call delay10usec 81 time)
                      goto mainloop

You may want to see a sample Flow Charts of the above algorithm. *Please note that the sample flow charts show the LED 3 dimming but you are require to dim the LED 4 for this homework.

The counter variable 'ONN' is the delay count for LED-on time. The counter variable 'OFF' is the delay count for LED-off time. The sum of 'ONN' and 'OFF' is always 100.

The delay subroutine 'delay10usec' will cause 10 usec delay when called. The LED on-offf cycle will always take 1 msec (100 * 10 usec). Therefore, this program will turn on-off the LED light 1000 times per second. With such high rate of LED on-off cycles, the normal human eyes will perceive the LED light level of 9% or 19%.

LED 1, LED 2, and LED 3 maintain their initial light level state, and LED 4 light level changes based on the switch SW1 pressing.

You MUST note that the LED light and switch press behavior is opposite way on the CSM-12C128 board compare to the CodeWarrior simulator:
On the CSM-12C128 board:

  LDAA %10111111
  STAA PORTB       ; Turn-On LED3 only

  LDAA %0100XXXX
  STAA PORTB       ; Turn-OFF LED3, Turn-On LED 1, 2, 4

  switch SW1 button pressed =>     PTIP=xxxxxxx0, ANDA=> Z=1
  switch SW1 button not pressed => PTIP=xxxxxxx1, ANDA=> Z=0

CodeWarrior simulator/debugger way:

  LDAA %01000000
  STAA PORTB       ; Turn-On LED3 only

  LDAA %1011XXXX
  STAA PORTB       ; Turn-OFF LED3, Turn-On LED 1, 2, 4

  switch SW1 button pressed     => PTIP=00000001, ANDA=> Z=0
  switch SW1 button not pressed => PTIP=00000000, ANDA=> Z=1

Design the program to start at $3100 and data to start at $3000.

Be sure to put much comments so that grader and others can clearly and quickly understand your program. Comments are very important in assembly language programs.

This program MUST be run on the CSM-12C128 board to see the LED light dimming. LED light dimming does not work on the simulator

However, one can still use the simulator for debugging. If you set the delay time on the program as minimum, then you can do single step through the program to check the LED light ON and OFF on the simulation. Also note that when you change the program source file, you need to re- Make the main.asm file and restart the debugger.