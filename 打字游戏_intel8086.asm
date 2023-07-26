; multi-segment executable file template.

data segment
    ;系统信息
    msg db "this is info",'$'
    menu db "chh's typing game",'$'
    st db "1.start",'$'
    help db "2.help",'$'
    quit db "3.quit",'$'
    choice db "(click the num to choose:)",'$'
    menuerror db "   The invalid choise!    ",'$'
    gameinfo1 db "#Type the sentence as quick as possible!",'$'
    gameinfo2 db "#press <ESC> will back to main menu.",'$'
    echinfo db "#press y/n to continue or back to menu.",'$'
    pkey db "press any key...$"
    scoreinfo db "the score is: ",'$'
    scoreinfo1 db "/100",'$'
    hundred db '100','$'
    helpinfo1 db "####No help here,#####",'$'
    helpinfo2 db "#just start the game!#",'$'
    helpinfo3 db "###press any key to###",'$'
    helpinfo4 db "###back to main menu##",'$'
    qtinfo1 db 23h, 23h, 20h, 41h, 6Ch, 6Ch, 20h, 74h, 68h, 65h, 20h, 74h, 69h, 6Dh, 65h, 2Ch, 74h, 68h, 61h, 6Eh, 6Bh, 20h, 23h, 23h, 23h, 23h, 23h, 23h, 23h, 24h
    qtinfo2 db 23h, 23h, 20h, 79h, 6Fh, 75h, 20h, 66h, 6Fh, 72h, 20h, 79h, 6Fh, 75h, 72h, 20h, 65h, 6Eh, 74h, 69h, 72h, 65h, 20h, 20h, 23h, 23h, 23h, 23h, 23h, 24h
    qtinfo3 db 23h, 23h, 20h, 77h, 6Fh, 72h, 6Bh, 20h, 66h, 6Fh, 72h, 20h, 75h, 73h, 20h, 61h, 73h, 20h, 61h, 20h, 74h, 65h, 61h, 63h, 68h, 65h, 72h, 2Eh, 23h, 24h
    qtinfo4 db 23h, 23h, 20h, 47h, 6Fh, 6Fh, 64h, 20h, 6Ch, 75h, 63h, 6Bh, 20h, 69h, 6Eh, 20h, 76h, 61h, 63h, 61h, 74h, 69h, 6Fh, 6Eh, 21h, 20h, 23h, 23h, 23h, 24h
    ;记错用数字与信息
    qch dw 0
    wrong db 0
    score dw 0
    sumword dw 0
    sumwrong db 0
    sumscore dw 0
    wtmch db "the wrong letters is more than 10!",'$'
    wnum db "the number of wrong letters: ",'$'
    ;计时用单元与信息
    time_min dw 0
    time_sec dw 0
    time_msec dw 0
    minute dw 0
    second dw 0
    minsec dw 0
    timeinfo db "the time you spend: ",'$'
    type_times dw 0
    ;打字用缓存
    tybuf db 40,0,40 dup('$')
    ;出题用信息
    q1 db "this is msg!",'$'
    q1len = $-q1
    q2 db "string",'$'
    q2len = $-q2
    q3 db "the infomation",'$'
    q3len = $-q3
    q4 db "love and peace",'$'
    q4len = $-q4
    q5 db "Love look not with the eyes",'$'
    q5len = $-q5
    q6 db "but with the mind.",'$'
    q6len = $-q6
    q7 db "The fox changes his skin",'$'
    q7len = $-q7
    q8 db "but not his habits.",'$'
    q8len = $-q8
    q9 db "Being on sea,sail;",'$'
    q9len = $-q9
    q10 db "being on land,settle",'$'
    q10len = $-q10
    q dw q1,q2,q3,q4,q5,q6,q7,q8,q9,q10
    ques dw 0
    qlen dw q1len,q2len,q3len,q4len,q5len,q6len,q7len,q8len,q9len,q10len
    queslen db 0
    qnum dw 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    
    call main
    jmp e
    
    ;屏幕布局用
    scroll macro n,ulr,ulc,lrr,lrc,att
        mov ah,7
        mov al,n
        mov ch,ulr
        mov cl,ulc
        mov dh,lrr
        mov dl,lrc
        mov bh,att
        int 10h
    endm
   
   ;光标位置
   curse macro cury,curx
        mov ah,2
        mov dh,cury
        mov dl,curx
        mov bh,0
        int 10h
   endm
   
   ;判断某些特殊键入
   compare macro n,et,nl,bk,info
        cmp n,1bh;如果是esc则退出
        jz et
        cmp n,0dh;如果是换行符则窗口内换行
        jz nl
        cmp n,8;如果是退格符则退格
        jz bk
        cmp n,9
        jz info
   endm
   
   ;产生一条信息
   sinfo macro m
            mov ah,9
            lea dx,m
            int 21h
            mov dx,0
            mov ah,2
            int 21h
            ;
   endm
   
   ;退格
   goback macro
            mov al,8
            mov ah,0eh
            int 10h
            mov al,20h
            int 10h
            mov al,8
   endm
   
   ;主菜单
   menucreate macro
            scroll 0,0,0,24,79,02
            scroll 13,7,22,17,49,70h
            scroll 12,8,23,16,48,0fh            
            curse 7,28
            sinfo menu
            curse 9,32
            sinfo st
            curse 11,32
            sinfo help
            curse 13,32
            sinfo quit
            curse 15,23
            sinfo choice
            curse 15,23
   endm
   
   ;帮助菜单
   helpmenu macro
            scroll 0,0,0,24,79,02
            scroll 13,7,22,17,49,70h
            scroll 12,8,23,16,48,0fh
            curse 11,25
            sinfo helpinfo1
            curse 12,25
            sinfo helpinfo2
            curse 14,25
            sinfo helpinfo3
            curse 15,25    
            sinfo helpinfo4
            mov ah,0
            int 16h
            jmp p1
   endm
   ;辅助算分
calculate macro word,wrg,sco
    local c1,c2,e
    mov dx,0
    mov cx,word
    cmp cx,100
    ja c1
    mov ax,word
    div cx
    mov bx,ax
    mov ah,0
    mov al,wrg
    mul bx
    mov sco,100
    sub sco,ax
    jmp e
c1: mov sco,100
    cmp wrg,100
    ja c2
    mov al,wrg
    mov ah,0
    sub sco,ax
    jmp e
c2: mov sco,0
e:  
endm
    
   ;选择退出后界面
endtyping macro
        getresult 
        wrongcount wrong
        curse 17,13
        sinfo scoreinfo
        calculate sumword,sumwrong,sumscore
        numoutput score
        sinfo scoreinfo1
        curse 18,13
        sinfo timeinfo
        timeget minute,second,minsec
        curse 19,13
        sinfo pkey
        mov minute,0
        mov second,0
        mov minsec,0
endm

   ;打字完后选择
   echoose macro j1,j
        local j2,e,ctn
        ;mov cx,type_times
        lea dx,echinfo
        mov ah,9
        int 21h
   ctn: dec type_times
        jz j2
        mov ah,0h
        int 16h
        cmp al,'y'
        je j1
        cmp al,'n'
        je j2
        jmp ctn
   j2:  endtyping
        mov ax,0
        int 16h
        jmp j
   e:
   endm
   
   ;游戏主体
   game macro
        local c1
            mov type_times,10
        c1: mov ah,0
            scroll 0,0,0,24,79,02
            scroll 13,7,12,15,56,70h
            scroll 12,8,13,14,55,0fh
            getresult
            curse 8,13
            lea dx,gameinfo1
            mov ah,9
            int 21h
            curse 9,13
            ;lea dx,gameinfo2
            ;mov ah,9
            ;int 21h
            curse 11,13
            typing
            echoose c1,p1
            jmp c1            
   endm
   ;下半窗口指针偏移
   getresult macro
            scroll 13,15,12,20,56,70h
            scroll 12,16,13,19,55,0fh
            curse 16,13            
   endm
   
   ;打字程序
   ;;typing macro
   ;local get1,get2,c1,newline,exit,back,showinfo
   ;    get1:mov cx,30
   ;    get2:mov ah,0
   ;         int 16h
   ;         compare al,exit,newline,back,showinfo
   ;    c1:  mov ah,0eh
   ;         int 10h
   ;         loop get2
   ;newline: strcmp 
   ;         ;scroll 12,12,13,12,55,0fh
   ;         curse 12,13
   ;         jmp get1
   ;    exit:jmp p1
   ;    back:goback         ;退格
   ;         jmp c1                  
   ;    showinfo:
    ;        sinfo msg
    ;        sub cx,13
    ;        jmp c1
   ;endm
   ;错误字母统计
   wrongcount macro w
    local c1,e
         cmp w,9
         ja c1
         lea dx,wnum
         mov ah,9
         int 21h
         mov dh,0
         mov dl,w
         add dl,30h
         mov ah,2
         int 21h
         curse 17,13
         mov wrong,0
         jmp e
    c1:  lea dx,wtmch
         mov ah,9
         int 21h
         mov ah,2
         mov dx,0
         int 21h
         mov wrong,0
         curse 17,13
         jmp e
    e: 
   endm
   ;计时模块
   ;数字转码输出
numoutput macro num
        local c1,c2,e,h
        mov ax,100
        cmp ax,num
        je h
        mov cx,0
        mov dx,0
        mov ax,num
        mov bx,10
        cmp ax,bx
        jb c1
        div bx
        mov cx,dx
        add cx,30h
   c1:  mov dx,ax
        add dx,30h
        mov ah,2
        int 21h
        cmp cx,0
        jne c2
        jmp e
    c2: mov dx,cx
        mov ah,2
        int 21h
        jmp e
    h:  lea dx,hundred
        mov ah,9
        int 21h
    e: 
    endm
;开始计时
timestart macro min,sec,msec
    mov ah,2ch
    int 21h
    mov ch,0
    mov min,cx
    mov bx,0
    mov bl,dh
    mov sec,bx
    mov bl,dl
    mov msec,bx
endm
;结束计时
timeend macro min,sec,msec
    local c1,c2
    mov ah,2ch
    int 21h
    mov bx,0    
    mov ax,msec
    mov bl,dl
    cmp bx,ax
    jnb c1
    add bx,100
    dec dh
c1: sub bx,ax
    mov msec,bx        
    mov bx,0
    mov ax,sec
    mov bl,dh
    cmp bx,ax
    jnb c2
    add bx,60
    dec cl
c2: sub bx,ax
    mov sec,bx    
    mov bx,0    
    mov bl,cl
    cmp bx,min
    jnb c3
    add bx,60
c3: sub bx,min
    mov min,bx       
endm
;时间获取
timeget macro min,sec,msec
    numoutput min
    mov dx,'m'    
    mov ah,2
    int 21h
    mov dx,':'
    int 21h
    numoutput sec
    mov dx,'s'
    mov ah,2
    int 21h
    mov dx,':'
    int 21h
    numoutput msec
    numoutput 0
    mov dx,'m'
    mov ah,2
    int 21h
    mov dx,'s'
    int 21h    
endm
;总时间存储
sumtime macro m,s,ms,min,sec,msec
    local c1,c2,n1,n2,e    
    mov ax,ms
    add msec,ax
    cmp msec,100
    ja c1
n1: mov ax,s
    add sec,ax
    cmp sec,60
    ja c2
n2: mov ax,m
    add min,ax
    jmp e
c1: sub msec,100
    inc sec
    jmp n1
c2: sub sec,60
    inc m
    jmp n2
e:
endm
;总时间清零
setsumtime macro
    mov minute,0
    mov second,0
    mov minsec,0
endm    

;随机问题选取
ques macro
        ;timestart time_min,time_sec,time_msec
        mov ax,qch
        inc qch
        mov dx,0
        mov cx,10
        div cx
        shl dx,1
        mov si,dx
        mov dx,q[si]
        mov qnum,si
endm


   ;打字模块
   typing macro
    local c1,e
        ques
        mov ah,9
        int 21h
        curse 12,13
        timestart time_min,time_sec,time_msec
        lea dx,tybuf
        mov ah,10
        int 21h
        timeend time_min,time_sec,time_msec
        sumtime time_min,time_sec,time_msec,minute,second,minsec
        curse 12,13
        scmp qnum
        getresult
        ;wrongcount wrong
        ;curse 17,13
        ;sinfo scoreinfo
        ;numoutput score
        ;sinfo scoreinfo1
        ;curse 18,13
        ;sinfo timeinfo
        ;timeget time_min,time_sec,time_msec
        ;curse 19,13
        mov cx,0
        mov cl,tybuf[0]
        dec cx
        lea bx,tybuf[1]
     c1:mov [bx],'$'
        inc bx
        loop c1
     e: 
   endm
   
   ;字符串比较并输出
    strcmp macro str1,str2,len
        local c1,c2,cg,e,sb,e1
        mov bx,0
    c1: mov bh,0
        mov dl,str1[bx]       
        cmp bl,len
        je e
        cmp str2[bx],dl
        jne cg
    c2: inc bx
        jmp c1
    cg: add bl,13
        scroll 12,12,bl,12,bl,04h
        curse 12,bl
        inc wrong
        sub bl,13
        mov bh,0
        mov dl,str1[bx]
        mov ah,2
        int 21h
        jmp c2
    e:  mov dl,len
        mov dh,0
        add sumword,dx
        dec wrong
        mov al,wrong
        add sumwrong,al
        mov cx,0
        mov cl,len
        mov dx,0
        mov ax,100
        div cx
        mov score,100
        mov cx,0
        mov cl,wrong
        cmp cl,0
        je e1
    sb: sub score,ax
        loop sb
    e1:
    endm
;字符串比较辅助模块
scmp macro num
    local e,c1,c2,c3,c4,c5,c6,c7,c8,c9
        mov bx,num
        mov dx,qlen[bx]
        mov queslen,dl
        mov si,q[bx]
        strcmp tybuf[2],si,queslen
        jmp e
        cmp num,0
        jne c1
        strcmp tybuf[2],q1,q1len
        jmp e
 c1:    cmp num,2
        jne c2
        strcmp tybuf[2],q2,q2len
        jmp e
 c2:    cmp num,4
        jne c3
        strcmp tybuf[2],q3,q3len
        jmp e
 c3:    cmp num,6
        jne c4
        strcmp tybuf[2],q4,q4len
        jmp e
 c4:    strcmp tybuf[2],q5,q5len
        jmp e
 e:
endm


   
   ;主菜单选择
   menuchoose macro
   local m1,m2,m3,m4
   m4 : mov ah,0
        int 16h
        cmp al,31h
        je m1
        cmp al,32h
        je m2
        cmp al,33h
        je m3
        lea dx,menuerror
        mov ah,9
        int 21h
        curse 15,23
        jmp m4
   m1:  game
   m2:  helpmenu
   m3:  qt
   endm
   
   ;退出游戏
   qt macro
            scroll 0,0,0,24,79,02
            scroll 13,7,20,17,50,70h
            scroll 12,8,21,16,49,0fh
            curse 11,21
            sinfo qtinfo1
            curse 12,21
            sinfo qtinfo2
            curse 13,21
            sinfo qtinfo3
            curse 14,21
            sinfo qtinfo4
            curse 15,21            
            mov ah,0
            int 16h
        jmp e
   endm
   
   ;主程序
   main proc
   p1:  menucreate;建立主菜单
        menuchoose;主菜单选择
       ret
   main endp    
    
e:  lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
