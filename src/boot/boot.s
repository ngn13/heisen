BITS 16
[org 0x7c00]

call video
call clear

mov bx, welcome
call print

mov bx, sbl
call print

mov bx, line
call print

mov bx, 0x1000
mov dh, 16
mov dl, 0
call disk_load

jmp halt

%include "boot/lib.s"

welcome:
  db "    Welcome to HBL", 0x00

sbl:
  db "  Heisen boot loader", 0x00

line:
  db "########################", 0x00

times 510 - ($ - $$) db 0x00
dw 0xaa55
