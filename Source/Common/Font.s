;;; -*- fundamental -*-
;;; Grizzards Source/Common/Font.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; The text font is an 8 × 15px font stored at 8 × 5px resolution,
;;; inverted.

;;; The font character order is:
;;; 
;;; 0123456789ABCDEFGHIJKLMNOPZRSTUVWXYZ.!?-
;;; 
;;; the last character is (blank space) at index 40
;;; 
;;; Note that this enables decimal or hex echoes very easily

Font:	.block

	Height = 5

Zero:	
	.byte %0111100
	.byte %1100110
	.byte %1100110
	.byte %1100110
	.byte %0111100
One:      
	.byte %0111100
	.byte %0011000
	.byte %0011000
	.byte %0111000
	.byte %0011000
Two:      
	.byte %1111110
	.byte %0111000
	.byte %0001100
	.byte %1100110
	.byte %0111100
Three:    
	.byte %1111100
	.byte %0000110
	.byte %0111100
	.byte %0000110
	.byte %1111100
Four:     
	.byte %0000110
	.byte %0000110
	.byte %1111110
	.byte %1100110
	.byte %1100110
Five:     
	.byte %1111100
	.byte %0000110
	.byte %1111100
	.byte %1100000
	.byte %1111110
Six:      
	.byte %0111100
	.byte %1100110
	.byte %1111100
	.byte %0110000
	.byte %0001110
Seven:    
	.byte %0011000
	.byte %0011000
	.byte %0011000
	.byte %0001100
	.byte %1111110
Eight:    
	.byte %0111100
	.byte %1100110
	.byte %0111100
	.byte %1100110
	.byte %0111100
Nine:     
	.byte %1110000
	.byte %0001100
	.byte %1111100
	.byte %1100110
	.byte %0111100
A:	
	.byte %1100110
	.byte %1100110
	.byte %1111110
	.byte %0100100
	.byte %0011000
B:        
	.byte %1111100
	.byte %1100110
	.byte %1111100
	.byte %1100110
	.byte %1111100
C:        
	.byte %0111100
	.byte %1100110
	.byte %1100000
	.byte %1100110
	.byte %0111100
D:        
	.byte %1111100
	.byte %1100110
	.byte %1100110
	.byte %1100110
	.byte %1111100
E:        
	.byte %1111110
	.byte %1100000
	.byte %1111000
	.byte %1100000
	.byte %1111110
F:        
	.byte %1100000
	.byte %1100000
	.byte %1111000
	.byte %1100000
	.byte %1111110
G:        
	.byte %0111110
	.byte %1100110
	.byte %1101110
	.byte %1100000
	.byte %0111110
H:        
	.byte %1100110
	.byte %1100110
	.byte %1111110
	.byte %1100110
	.byte %1100110
I:        
	.byte %1111110
	.byte %0011000
	.byte %0011000
	.byte %0011000
	.byte %1111110
J:        
	.byte %0111000
	.byte %1101100
	.byte %0001100
	.byte %0001100
	.byte %1111110
K:        
	.byte %1100110
	.byte %1100110
	.byte %1111000
	.byte %1100110
	.byte %1100110
L:        
	.byte %1111110
	.byte %1100000
	.byte %1100000
	.byte %1100000
	.byte %1100000
M:        
	.byte %11000011
	.byte %11000011
	.byte %11011011
	.byte %11100111
	.byte %11000011
N:        
	.byte %1100010
	.byte %1100110
	.byte %1111110
	.byte %1100110
	.byte %1000110
O:        
	.byte %0111100
	.byte %1100110
	.byte %1100110
	.byte %1100110
	.byte %0111100
P:        
	.byte %1100000
	.byte %1100000
	.byte %1111100
	.byte %1100110
	.byte %1111100
Q:        
	.byte %00111111
	.byte %01111010
	.byte %01100110
	.byte %01100110
	.byte %00111100
R:        
	.byte %1100110
	.byte %1100110
	.byte %1111100
	.byte %1100110
	.byte %1111100
S:        
	.byte %1111100
	.byte %0000110
	.byte %0111100
	.byte %1100000
	.byte %0111110
T:        
	.byte %0011000
	.byte %0011000
	.byte %0011000
	.byte %0011000
	.byte %1111110
U:        
	.byte %0111100
	.byte %1100110
	.byte %1100110
	.byte %1100110
	.byte %1100110
V:        
	.byte %0011000
	.byte %0111100
	.byte %1100110
	.byte %1100110
	.byte %1100110
W:        
	.byte %11000011
	.byte %11100111
	.byte %11011011
	.byte %11000011
	.byte %11000011
X:        
	.byte %1100110
	.byte %0111100
	.byte %0011000
	.byte %0111100
	.byte %1100110
Y:        
	.byte %0011000
	.byte %0011000
	.byte %0111100
	.byte %1100110
	.byte %1100110
Z:        
	.byte %1111110
	.byte %0110000
	.byte %0011000
	.byte %0001100
	.byte %1111110
Stop:   	
	.byte %1100000
	.byte %1100000
	.byte %0000000
	.byte %0000000
	.byte %0000000
Bang:     
	.byte %1100000
	.byte %0000000
	.byte %1100000
	.byte %1100000
	.byte %1100000
Query:    
	.byte %1100000
	.byte %0000000
	.byte %1111000
	.byte %0001100
	.byte %1111000
Tack:   
	.byte %0000000
	.byte %0000000
	.byte %1111110
	.byte %0000000
	.byte %0000000
Blank:    
	.byte 0, 0, 0, 0, 0

	.bend

;; Audited 2022-02-16 BRPocock
