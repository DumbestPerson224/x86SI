section .text 
  global _start 

section .data 
     player:
          db "Player 1's turn"
          db "Player 2's turn"
          times 13 db "" ; Player 1 input
          times 13 db "" ; Player 2 input

     game_states:
          db 1    ; Player's turn
          db 0    ; Game over
          
     
     questions:
          db "How do you center a div in CSS?"
          db "How do you create a header in HTML?" 
     output_question: db 0 
     newline: db 0x0A 

_start:
    cmp byte [game_states + 1], 1
    je .game_over 

.generate_turn:
     ; 1 XOR 1 = 0
     ; 0 XOR 1 = 1
     xor byte [game_states], 1 
     cmp byte [game_states], 1
     jz .player2_turn 
     ; This operation tells the CPU to set the address game_state's value to the opposite bit and if it's zero to
     ; Goto the function .player2_turn
     ; In simple terms, this is just figures out who's turn it is

.player1_turn:
     mov eax, 4
     mov ebx, 1
     lea ecx, [player]
     mov edx, 15
     int 0x80

     mov eax, 4
     mov ebx, 1
     mov ecx, newline
     mov edx, 1
     int 0x80
     jmp .generate_question 

.player2_turn:
     mov eax, 4
     mov ebx, 1
     lea ecx, [player + 15]
     mov edx, 15
     int 0x80

     mov eax, 4
     mov ebx, 1
     mov ecx, newline
     mov edx, 1
     int 0x80

.generate_question:
     not byte [output_question]
     cmp byte [output_question], 0
     je .question2 
     
.question1:
     mov eax, 4
     mov ebx, 1
     lea ecx, [questions]
     mov edx, 31
     int 0x80

     mov eax, 4
     mov ebx, 1
     mov ecx, newline 
     mov edx, 1
     int 0x80

     cmp byte [game_states], 0
     je .handle_input_player1 
     jne .handle_input_player2 
     
.question2:
     mov eax, 4
     mov ebx, 1
     lea ecx, [questions + 31]
     mov edx, 37
     int 0x80

     mov eax, 4
     mov ebx, 1
     mov ecx, newline 
     mov edx, 1
     int 0x80
     
     cmp byte [game_states], 0
     jnz .handle_input_player2 

.handle_input_player1:
     mov eax, 3
     mov ebx, 1
     mov ecx, [player + 32]
     mov edx, 13
     int 0x80 
     jmp .generate_turn 

.handle_input_player2:
     mov eax, 3
     mov ebx, 1
     mov ecx, [player + 45]
     mov edx, 13
     int 0x80
     jmp .generate_turn 

.game_over:
     not byte [game_states + 1]
     jmp .generate_turn

.exit:
     mov eax, 1
     xor edx, edx 
     int 0x80
