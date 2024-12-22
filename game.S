section .text 
  global _start 

section .data 
   game_states:
     db 0 ; Game paused
     db 0 ; Game over
     dw 1 ; Timer on

   messages:
     ;48 + 12 = 60
     db "Game Paused!" ; How many characters? 12 
     db "Game over!"   ; How many characters? 10
     db "Player 1, enter your name: "
     db "Player 2, enter your name: "
   player_input:
     db "" ; Player 1's name
     db "" ; Player 2's name

_start:
   
   ; Check for a game over
   cmp byte [game_states + 1], 1
   je .game_over

.output_start:
     mov eax, 4
     mov ebx, 1
     lea ecx, [messages + 22]
     mov edx, 27
     int 0x80
     jmp .handle_player1_input 

.game_over:
   mov eax, 4
   mov ebx, 1
   lea ecx, [messages + 12]
   mov edx, 10
   int 0x80

   mov byte [game_states + 1], 0

.handle_player1_input:
     mov eax, 3
     mov edx, 1
     lea ecx, [player_input]
     mov edx, 3
     int 0x80

.output_player2_message:
     mov eax, 4
     mov ebx, 1
     lea ecx, [messages + 48]
     mov edx, 28
     int 0x80

_handle_player2_input:
     mov eax, 3
     mov edx, 1
     lea ecx, [player_input + 1]
     mov edx, 3
     int 0x80 

.output_input:
     mov eax, 4
     mov ebx, 1
     lea ecx, [player_input]
     mov edx, 3
     int 0x80 
     
     mov eax, 4
     mov ebx, 1
     lea ecx, [player_input + 1]
     mov edx, 3
     int 0x80

.exit:
     mov eax, 1
     xor edx, edx 
     int 0x80 