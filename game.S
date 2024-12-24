section .text 
  global _start 

section .data 
     player:
          db "Player 1's turn"
          db "Player 2's turn"
          db "" ; Player 1 input
          db "" ; Player 2 input

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
    je .exit 

.generate_turn:
     ; 1 XOR 1 = 0
     ; 0 XOR 1 = 1
     xor byte [game_states], 1 
     test byte [game_states], byte [game_states]
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
     xor byte [output_question], 1
     test byte [output_question], byte [output_questions]
     jz .question2 
     
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

     test byte [game_states], byte [game_states]
     jz .handle_input_player1 
     jnz .handle_input_player2 
     
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
     
     test byte [game_states], byte [game_states]
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

.exit:
     mov eax, 1
     xor edx, edx 
     int 0x80
