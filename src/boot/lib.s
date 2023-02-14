halt:
  jmp halt

video:
  pusha 
  
  mov ah, 0x00
  mov al, 0x03
  int 0x10 

  popa
  ret

clear:
  pusha 

  mov ah, 0x06  
  mov al, 0x00
  mov bh, 0x00
  mov cx, 0x00
  mov dx, 0x00
  int 0x10   

  popa
  ret

print:
  pusha

prstart:
  mov al, [bx]
  cmp al, 0x00
  je prend
  
  mov ah, 0x0e
  int 0x10

  add bx, 1
  jmp prstart

prend:
  mov ah, 0x0e
  mov al, 0x0a
  int 0x10
  mov al, 0x0d
  int 0x10
  
  popa
  ret

disk_load:
    pusha
    push dx

    mov ah, 0x02 ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, dh   ; al <- number of sectors to read (0x01 .. 0x80)
    mov cl, 0x02 ; cl <- sector (0x01 .. 0x11)
                 ; 0x01 is our boot sector, 0x02 is the first 'available' sector
    mov ch, 0x00 ; ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl')
    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF)

    int 0x13 ; BIOS interrupt
    jc disk_error ; if error (stored in the carry bit)

    pop dx
    cmp al, dh    ; BIOS also sets 'al' to the # of sectors read. Compare it.
    jne sectors_error
    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print
    ; mov dh, ah ; ah = error code, dl = disk drive that dropped the error
    ; call print_hex ; check out the code at http://stanislavs.org/helppc/int_13-1.html
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
