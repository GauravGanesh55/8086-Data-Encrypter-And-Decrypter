org 100h

.data
    u0 DW 0100h
    u1 DW 0100h
    
    v0 DW ?
    v1 DW ?
    
    k0 DW ?
    k1 DW ?
    k2 DW ?
    k3 DW ?
    
    k4 DW ?
    k5 DW ?
    k6 DW ?
    k7 DW ?
    
    msgE1 DB 'Enter text to be encrypted (4 letters): $'
    msgE2 DB 0Dh,0Ah,'Enter a password for encryption (4 letters): $'
    msgD1 DB 0Dh,0Ah,'Enter the previous password to decrypt the text: $'     
    p1 DB 0Dh,0Ah,'Encrypting... $'
    p2 DB 0Dh,0Ah,'Decrypting... $' 
    p3 DB 0Dh,0Ah,'Encrypted text: $'
    p4 DB 0Dh,0Ah,'Decrypted text: $'
    invalid DB 0Dh,0Ah,'Password is incorrect$' 

.code  

main proc  
        
    mov ah, 09h 
    lea dx, msgE1
    int 21h          ; dialog box pops up asking for text to be encrypted
        
    
    mov ah, 01h      ; input char is stored in al
    int 21h
    mov bh, al       ; first char stored in bh
    int 21h
    mov bl, al       ; second char stored in bl
    mov v0, bx       ; first and second char moved to v0 
       
    
    mov ah, 01h      
    int 21h
    mov bh, al       
    int 21h
    mov bl, al       
    mov v1, bx       ; third and fourth char moved to v1
    
     
    mov ah, 09h
    lea dx, msgE2 
    int 21h          ; text asking for password to use for encryption
    
   
    mov ah, 01h
    int 21h
    xor bx, bx       ; clears bx by using xor
    mov bl, al       ; first char stored in bl
    mov k0, bx       ; moved to k0
    
    
    mov ah, 01h
    int 21h
    xor bx, bx
    mov bl, al
    mov k1, bx
    
    
    mov ah, 01h
    int 21h
    xor bx, bx
    mov bl, al
    mov k2, bx
    
    
    mov ah, 01h
    int 21h
    xor bx, bx
    mov bl, al
    mov k3, bx
    
  
    mov ah, 09h
    lea dx, p1
    int 21h          ; text imforming user about current process
    
    call encrypt
      
    mov ah, 09h
    lea dx, p3       ; text giving user the encrypted text
    int 21h
    
    mov ah, 02h     
    ; print v0       
    mov bx, v0
    mov dl, bh             
    int 21h
    mov dl, bl
    int 21h
    
    ; print v1
    mov bx, v1
    mov dl, bh             
    int 21h
    mov dl, bl
    int 21h
    
    mov ah, 09h
    lea dx, msgD1 
    int 21h          ; text asking for password to verify for decryption
    
   
    mov ah, 01h
    int 21h
    xor bx, bx       
    mov bl, al       
    cmp k0, bx       ; compare the first char of password with user input
    jne nequal       ; if it does not match, jump to end of program
    
    
    mov ah, 01h
    int 21h
    xor bx, bx
    mov bl, al
    cmp k1, bx
    jne nequal       
    
    
    mov ah, 01h
    int 21h
    xor bx, bx
    mov bl, al
    cmp k2, bx
    jne nequal       
    
    
    mov ah, 01h
    int 21h
    xor bx, bx
    mov bl, al
    cmp k3, bx
    jne nequal        
    
    
    mov ah, 09h
    lea dx, p2     ; informing user abut current process
    int 21h
    
    
    call decrypt
     
    
    mov ah, 09h
    lea dx, p4
    int 21h    
    
    mov ah, 02h      
    mov bx, v0
    mov dl, bh             
    int 21h        ; print first char of decrypted text
    mov dl, bl
    int 21h        ; second char
    
    ; print v1
    mov bx, v1
    mov dl, bh             
    int 21h        ; third char
    mov dl, bl
    int 21h        ; fourth char
    
    
    mov ah, 4ch
    int 21h       ; exit the program
    
    endp
    
       
       
       
encrypt proc
           
           
    mov cx, 8        
    encLoop:
        mov bx, u1 
        mov ax, u0
        add ax, bx ; adds u1 to u0 at the beginning of every loop to add variation to the encryption each loop
        mov u0, ax                                                      



        mov ax, v1
        shl ax, 4
        mov bx, k0
        add ax, bx
        mov dx, ax  
        
        mov ax, v1
        mov bx, u0
        add ax, bx
        xor dx, ax  
        
        mov ax, v1
        shr ax, 5
        mov bx, k1
        add ax, bx
        xor dx, ax 

        mov ax, v0
        add ax, dx
        mov v0, ax 
             
             
        
        mov ax, v0
        shl ax, 4
        mov bx, k2
        add ax, bx
        mov dx, ax         
        
        mov ax, v0
        mov bx, u0
        add ax, bx
        xor dx, ax           
        
        mov ax, v0
        shr ax, 5
        mov bx, k3
        add ax, bx
        xor dx, ax
        
        mov ax, v1
        add ax, dx
        mov v1, ax 
                  
    loop encLoop   
    ret   
       
       
encrypt endp

    
    
    
decrypt proc
             
             
    mov cx, 8        
    decLoop:      

        mov ax, v0
        shl ax, 4
        mov bx, k2
        add ax, bx
        mov dx, ax

        mov ax, v0
        mov bx, u0
        add ax, bx
        xor dx, ax

        mov ax, v0
        shr ax, 5
        mov bx, k3
        add ax, bx
        xor dx, ax

        mov ax, v1
        sub ax, dx
        mov v1, ax



        mov ax, v1
        shl ax, 4
        mov bx, k0
        add ax, bx
        mov dx, ax

        mov ax, v1
        mov bx, u0
        add ax, bx
        xor dx, ax

        mov ax, v1
        shr ax, 5
        mov bx, k1
        add ax, bx
        xor dx, ax

        mov ax, v0
        sub ax, dx
        mov v0, ax


        
        mov bx, u1 
        mov ax, u0
        sub ax, bx
        mov u0, ax 
        
    loop decLoop      
    ret 
    
decrypt endp                                                                                                       
 
nequal:
    mov ah, 09h
    lea dx, invalid 
    int 21h     

end
