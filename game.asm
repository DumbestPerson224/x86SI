section .data 
  player_lives: db 10
  enemy_attack_damage: db 2
  player_x: db 10
  player_y: db 10
  enemy_score: db 0
  game_over_msg: db "Game Over!"
  statistics_msg: db "Statistics:"
  
section .text
  global _start
  
_start:
   mov al, byte [player_lives]
   mov ah, byte [enemy_attack_damage]
   mov cl, byte [enemy_score]
   push ax 
   push cx
  
statistics_loop:
   mov si, statistics_msg 
   lodsb 
   cmp al, 0 
   je done_statistics_loop
 
output_statistics_loop:
  mov ah, 0x0E 
  int 0x10 
  jmp statistics_loop

done_statistics_loop:
   pop cx
   pop ax

game_loop:
 jmp game_loop
 
attack_player:
   inc cl  ; Increase the enemy's score
   dec al  ; Decrement the player's lives
   cmp al, 0 
   jz game_over
   cmp cl, 10
   jl game_loop
   xor cx, cx 
   
game_over:
  mov byte [player_lives], 10
  mov byte [player_x], 10
  mov byte [player_y], 10
  mov ah, 0
  push ax 
  push cx 
  mov si, game_over_msg
  
game_over_loop:
  lodsb 
  cmp al, 0
  je done_game_over_loop

game_over_loop_output:
  mov ah, 0x0E
  int 0x10
  jmp game_over_loop
  
done_game_over_loop:
  pop cx
  pop ax
