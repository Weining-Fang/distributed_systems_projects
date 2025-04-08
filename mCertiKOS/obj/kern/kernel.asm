
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <pmmap_init.cold>:
  100000:	80 7c 24 1f 00       	cmpb   $0x0,0x1f(%esp)
  100005:	8b 7c 24 10          	mov    0x10(%esp),%edi
    SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);

    /*
     * Copy memory map information from multiboot information mbi to pmmap.
     */
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100009:	74 06                	je     100011 <pmmap_init.cold+0x11>
  10000b:	89 bd 78 76 02 00    	mov    %edi,0x27678(%ebp)
  100011:	80 7c 24 04 00       	cmpb   $0x0,0x4(%esp)
  100016:	74 0a                	je     100022 <pmmap_init.cold+0x22>
  100018:	c7 85 7c 76 02 00 80 	movl   $0x80,0x2767c(%ebp)
  10001f:	00 00 00 
        KERN_PANIC("More than 128 E820 entries.\n");
  100022:	50                   	push   %eax
  100023:	8d 85 a2 83 ff ff    	lea    -0x7c5e(%ebp),%eax
  100029:	89 eb                	mov    %ebp,%ebx
  10002b:	50                   	push   %eax
  10002c:	8d 85 bf 83 ff ff    	lea    -0x7c41(%ebp),%eax
  100032:	6a 3c                	push   $0x3c
  100034:	50                   	push   %eax
  100035:	e8 f6 3f 00 00       	call   104030 <debug_panic>
    free_slot->start = start;
  10003a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  100041:	00 00 00 
  100044:	0f 0b                	ud2    
  100046:	66 90                	xchg   %ax,%ax
  100048:	66 90                	xchg   %ax,%ax
  10004a:	66 90                	xchg   %ax,%ax
  10004c:	66 90                	xchg   %ax,%ax
  10004e:	66 90                	xchg   %ax,%ax

00100050 <video_init>:
    unsigned pos;

    /* Get a pointer to the memory-mapped text display buffer. */
    cp = (uint16_t *) CGA_BUF;
    was = *cp;
    *cp = (uint16_t) 0xA55A;
  100050:	b9 5a a5 ff ff       	mov    $0xffffa55a,%ecx
{
  100055:	57                   	push   %edi
  100056:	56                   	push   %esi
  100057:	53                   	push   %ebx
    was = *cp;
  100058:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
    *cp = (uint16_t) 0xA55A;
  10005f:	e8 25 03 00 00       	call   100389 <__x86.get_pc_thunk.bx>
  100064:	81 c3 9c 0f 01 00    	add    $0x10f9c,%ebx
  10006a:	66 89 0d 00 80 0b 00 	mov    %cx,0xb8000
    if (*cp != 0xA55A) {
  100071:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  100078:	66 3d 5a a5          	cmp    $0xa55a,%ax
  10007c:	0f 84 96 00 00 00    	je     100118 <video_init+0xc8>
        cp = (uint16_t *) MONO_BUF;
        addr_6845 = MONO_BASE;
        dprintf("addr_6845:%x\n", addr_6845);
  100082:	83 ec 08             	sub    $0x8,%esp
  100085:	8d 83 00 80 ff ff    	lea    -0x8000(%ebx),%eax
        cp = (uint16_t *) MONO_BUF;
  10008b:	bf 00 00 0b 00       	mov    $0xb0000,%edi
        addr_6845 = MONO_BASE;
  100090:	c7 83 0c 70 02 00 b4 	movl   $0x3b4,0x2700c(%ebx)
  100097:	03 00 00 
        dprintf("addr_6845:%x\n", addr_6845);
  10009a:	68 b4 03 00 00       	push   $0x3b4
  10009f:	50                   	push   %eax
  1000a0:	e8 9b 41 00 00       	call   104240 <dprintf>
  1000a5:	83 c4 10             	add    $0x10,%esp
        addr_6845 = CGA_BASE;
        dprintf("addr_6845:%x\n", addr_6845);
    }

    /* Extract cursor location */
    outb(addr_6845, 14);
  1000a8:	83 ec 08             	sub    $0x8,%esp
  1000ab:	6a 0e                	push   $0xe
  1000ad:	ff b3 0c 70 02 00    	push   0x2700c(%ebx)
  1000b3:	e8 c8 4d 00 00       	call   104e80 <outb>
    pos = inb(addr_6845 + 1) << 8;
  1000b8:	8b 83 0c 70 02 00    	mov    0x2700c(%ebx),%eax
  1000be:	83 c0 01             	add    $0x1,%eax
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 87 4d 00 00       	call   104e50 <inb>
  1000c9:	0f b6 f0             	movzbl %al,%esi
    outb(addr_6845, 15);
  1000cc:	58                   	pop    %eax
  1000cd:	5a                   	pop    %edx
  1000ce:	6a 0f                	push   $0xf
  1000d0:	ff b3 0c 70 02 00    	push   0x2700c(%ebx)
    pos = inb(addr_6845 + 1) << 8;
  1000d6:	c1 e6 08             	shl    $0x8,%esi
    outb(addr_6845, 15);
  1000d9:	e8 a2 4d 00 00       	call   104e80 <outb>
    pos |= inb(addr_6845 + 1);
  1000de:	8b 83 0c 70 02 00    	mov    0x2700c(%ebx),%eax
  1000e4:	83 c0 01             	add    $0x1,%eax
  1000e7:	89 04 24             	mov    %eax,(%esp)
  1000ea:	e8 61 4d 00 00       	call   104e50 <inb>
    terminal.crt_buf = (uint16_t *) cp;
    terminal.crt_pos = pos;
    terminal.active_console = 0;

    // spinlock_init(&video_lock);
}
  1000ef:	83 c4 10             	add    $0x10,%esp
    terminal.crt_buf = (uint16_t *) cp;
  1000f2:	89 bb 00 70 02 00    	mov    %edi,0x27000(%ebx)
    terminal.active_console = 0;
  1000f8:	c7 83 08 70 02 00 00 	movl   $0x0,0x27008(%ebx)
  1000ff:	00 00 00 
    pos |= inb(addr_6845 + 1);
  100102:	0f b6 c0             	movzbl %al,%eax
  100105:	09 f0                	or     %esi,%eax
    terminal.crt_pos = pos;
  100107:	66 89 83 04 70 02 00 	mov    %ax,0x27004(%ebx)
}
  10010e:	5b                   	pop    %ebx
  10010f:	5e                   	pop    %esi
  100110:	5f                   	pop    %edi
  100111:	c3                   	ret    
  100112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dprintf("addr_6845:%x\n", addr_6845);
  100118:	83 ec 08             	sub    $0x8,%esp
  10011b:	8d 83 00 80 ff ff    	lea    -0x8000(%ebx),%eax
    cp = (uint16_t *) CGA_BUF;
  100121:	bf 00 80 0b 00       	mov    $0xb8000,%edi
        *cp = was;
  100126:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
        dprintf("addr_6845:%x\n", addr_6845);
  10012d:	68 d4 03 00 00       	push   $0x3d4
  100132:	50                   	push   %eax
        addr_6845 = CGA_BASE;
  100133:	c7 83 0c 70 02 00 d4 	movl   $0x3d4,0x2700c(%ebx)
  10013a:	03 00 00 
        dprintf("addr_6845:%x\n", addr_6845);
  10013d:	e8 fe 40 00 00       	call   104240 <dprintf>
  100142:	83 c4 10             	add    $0x10,%esp
  100145:	e9 5e ff ff ff       	jmp    1000a8 <video_init+0x58>
  10014a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100150 <video_putc>:

void video_putc(int c)
{
  100150:	56                   	push   %esi
  100151:	53                   	push   %ebx
  100152:	e8 32 02 00 00       	call   100389 <__x86.get_pc_thunk.bx>
  100157:	81 c3 a9 0e 01 00    	add    $0x10ea9,%ebx
  10015d:	83 ec 04             	sub    $0x4,%esp
  100160:	8b 54 24 10          	mov    0x10(%esp),%edx
    // if no attribute given, then use black on white
    if (!(c & ~0xFF))
        c |= 0x0700;
  100164:	89 d0                	mov    %edx,%eax
  100166:	80 cc 07             	or     $0x7,%ah
  100169:	f7 c2 00 ff ff ff    	test   $0xffffff00,%edx
  10016f:	0f 44 d0             	cmove  %eax,%edx

    // spinlock_acquire(&video_lock);
    switch (c & 0xff) {
  100172:	0f b6 c2             	movzbl %dl,%eax
  100175:	83 f8 0a             	cmp    $0xa,%eax
  100178:	0f 84 93 01 00 00    	je     100311 <video_putc+0x1c1>
  10017e:	0f 8f bc 00 00 00    	jg     100240 <video_putc+0xf0>
  100184:	83 f8 08             	cmp    $0x8,%eax
  100187:	0f 84 53 01 00 00    	je     1002e0 <video_putc+0x190>
  10018d:	83 f8 09             	cmp    $0x9,%eax
  100190:	0f 85 2a 01 00 00    	jne    1002c0 <video_putc+0x170>
        /* fallthru */
    case '\r':
        terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
        break;
    case '\t':
        video_putc(' ');
  100196:	83 ec 0c             	sub    $0xc,%esp
  100199:	6a 20                	push   $0x20
  10019b:	e8 b0 ff ff ff       	call   100150 <video_putc>
        video_putc(' ');
  1001a0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1001a7:	e8 a4 ff ff ff       	call   100150 <video_putc>
        video_putc(' ');
  1001ac:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1001b3:	e8 98 ff ff ff       	call   100150 <video_putc>
        video_putc(' ');
  1001b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1001bf:	e8 8c ff ff ff       	call   100150 <video_putc>
        video_putc(' ');
  1001c4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1001cb:	e8 80 ff ff ff       	call   100150 <video_putc>
    default:
        terminal.crt_buf[terminal.crt_pos++] = c;  /* write the character */
        break;
    }

    if (terminal.crt_pos >= CRT_SIZE) {
  1001d0:	0f b7 83 04 70 02 00 	movzwl 0x27004(%ebx),%eax
        break;
  1001d7:	83 c4 10             	add    $0x10,%esp
    if (terminal.crt_pos >= CRT_SIZE) {
  1001da:	66 3d cf 07          	cmp    $0x7cf,%ax
  1001de:	0f 87 8b 00 00 00    	ja     10026f <video_putc+0x11f>
            terminal.crt_buf[i] = 0x0700 | ' ';
        terminal.crt_pos -= CRT_COLS;
    }

    /* move that little blinky thing */
    outb(addr_6845, 14);
  1001e4:	83 ec 08             	sub    $0x8,%esp
  1001e7:	6a 0e                	push   $0xe
  1001e9:	ff b3 0c 70 02 00    	push   0x2700c(%ebx)
  1001ef:	e8 8c 4c 00 00       	call   104e80 <outb>
    outb(addr_6845 + 1, terminal.crt_pos >> 8);
  1001f4:	58                   	pop    %eax
  1001f5:	0f b6 83 05 70 02 00 	movzbl 0x27005(%ebx),%eax
  1001fc:	5a                   	pop    %edx
  1001fd:	50                   	push   %eax
  1001fe:	8b 83 0c 70 02 00    	mov    0x2700c(%ebx),%eax
  100204:	83 c0 01             	add    $0x1,%eax
  100207:	50                   	push   %eax
  100208:	e8 73 4c 00 00       	call   104e80 <outb>
    outb(addr_6845, 15);
  10020d:	59                   	pop    %ecx
  10020e:	5e                   	pop    %esi
  10020f:	6a 0f                	push   $0xf
  100211:	ff b3 0c 70 02 00    	push   0x2700c(%ebx)
  100217:	e8 64 4c 00 00       	call   104e80 <outb>
    outb(addr_6845 + 1, terminal.crt_pos);
  10021c:	58                   	pop    %eax
  10021d:	0f b6 83 04 70 02 00 	movzbl 0x27004(%ebx),%eax
  100224:	5a                   	pop    %edx
  100225:	50                   	push   %eax
  100226:	8b 83 0c 70 02 00    	mov    0x2700c(%ebx),%eax
  10022c:	83 c0 01             	add    $0x1,%eax
  10022f:	50                   	push   %eax
  100230:	e8 4b 4c 00 00       	call   104e80 <outb>

    // spinlock_release(&video_lock);
}
  100235:	83 c4 14             	add    $0x14,%esp
  100238:	5b                   	pop    %ebx
  100239:	5e                   	pop    %esi
  10023a:	c3                   	ret    
  10023b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10023f:	90                   	nop
    switch (c & 0xff) {
  100240:	83 f8 0d             	cmp    $0xd,%eax
  100243:	75 7b                	jne    1002c0 <video_putc+0x170>
        if (terminal.crt_pos > 0) {
  100245:	0f b7 83 04 70 02 00 	movzwl 0x27004(%ebx),%eax
        terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
  10024c:	0f b7 c0             	movzwl %ax,%eax
  10024f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100255:	c1 e8 16             	shr    $0x16,%eax
  100258:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10025b:	c1 e0 04             	shl    $0x4,%eax
  10025e:	66 89 83 04 70 02 00 	mov    %ax,0x27004(%ebx)
    if (terminal.crt_pos >= CRT_SIZE) {
  100265:	66 3d cf 07          	cmp    $0x7cf,%ax
  100269:	0f 86 75 ff ff ff    	jbe    1001e4 <video_putc+0x94>
        memmove(terminal.crt_buf, terminal.crt_buf + CRT_COLS,
  10026f:	8b 83 00 70 02 00    	mov    0x27000(%ebx),%eax
  100275:	83 ec 04             	sub    $0x4,%esp
  100278:	68 00 0f 00 00       	push   $0xf00
  10027d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  100283:	52                   	push   %edx
  100284:	50                   	push   %eax
  100285:	e8 16 3b 00 00       	call   103da0 <memmove>
            terminal.crt_buf[i] = 0x0700 | ' ';
  10028a:	8b 93 00 70 02 00    	mov    0x27000(%ebx),%edx
  100290:	83 c4 10             	add    $0x10,%esp
  100293:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
  100299:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  10029f:	90                   	nop
  1002a0:	b9 20 07 00 00       	mov    $0x720,%ecx
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  1002a5:	83 c0 02             	add    $0x2,%eax
            terminal.crt_buf[i] = 0x0700 | ' ';
  1002a8:	66 89 48 fe          	mov    %cx,-0x2(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  1002ac:	39 c2                	cmp    %eax,%edx
  1002ae:	75 f0                	jne    1002a0 <video_putc+0x150>
        terminal.crt_pos -= CRT_COLS;
  1002b0:	66 83 ab 04 70 02 00 	subw   $0x50,0x27004(%ebx)
  1002b7:	50 
  1002b8:	e9 27 ff ff ff       	jmp    1001e4 <video_putc+0x94>
  1002bd:	8d 76 00             	lea    0x0(%esi),%esi
        terminal.crt_buf[terminal.crt_pos++] = c;  /* write the character */
  1002c0:	0f b7 8b 04 70 02 00 	movzwl 0x27004(%ebx),%ecx
  1002c7:	8b b3 00 70 02 00    	mov    0x27000(%ebx),%esi
  1002cd:	8d 41 01             	lea    0x1(%ecx),%eax
  1002d0:	66 89 14 4e          	mov    %dx,(%esi,%ecx,2)
  1002d4:	66 89 83 04 70 02 00 	mov    %ax,0x27004(%ebx)
        break;
  1002db:	e9 fa fe ff ff       	jmp    1001da <video_putc+0x8a>
        if (terminal.crt_pos > 0) {
  1002e0:	0f b7 83 04 70 02 00 	movzwl 0x27004(%ebx),%eax
  1002e7:	66 85 c0             	test   %ax,%ax
  1002ea:	0f 84 f4 fe ff ff    	je     1001e4 <video_putc+0x94>
            terminal.crt_pos--;
  1002f0:	83 e8 01             	sub    $0x1,%eax
            terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  1002f3:	8b 8b 00 70 02 00    	mov    0x27000(%ebx),%ecx
  1002f9:	30 d2                	xor    %dl,%dl
  1002fb:	0f b7 f0             	movzwl %ax,%esi
  1002fe:	83 ca 20             	or     $0x20,%edx
            terminal.crt_pos--;
  100301:	66 89 83 04 70 02 00 	mov    %ax,0x27004(%ebx)
            terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  100308:	66 89 14 71          	mov    %dx,(%ecx,%esi,2)
  10030c:	e9 c9 fe ff ff       	jmp    1001da <video_putc+0x8a>
        terminal.crt_pos += CRT_COLS;
  100311:	0f b7 83 04 70 02 00 	movzwl 0x27004(%ebx),%eax
  100318:	83 c0 50             	add    $0x50,%eax
  10031b:	e9 2c ff ff ff       	jmp    10024c <video_putc+0xfc>

00100320 <video_set_cursor>:

void video_set_cursor(int x, int y)
{
    // spinlock_acquire(&video_lock);
    terminal.crt_pos = x * CRT_COLS + y;
  100320:	e8 60 00 00 00       	call   100385 <__x86.get_pc_thunk.dx>
  100325:	81 c2 db 0c 01 00    	add    $0x10cdb,%edx
{
  10032b:	8b 44 24 04          	mov    0x4(%esp),%eax
    terminal.crt_pos = x * CRT_COLS + y;
  10032f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  100332:	c1 e0 04             	shl    $0x4,%eax
  100335:	66 03 44 24 08       	add    0x8(%esp),%ax
  10033a:	66 89 82 04 70 02 00 	mov    %ax,0x27004(%edx)
    // spinlock_release(&video_lock);
}
  100341:	c3                   	ret    
  100342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100350 <video_clear_screen>:

void video_clear_screen()
{
    int i;
    // spinlock_acquire(&video_lock);
    for (i = 0; i < CRT_SIZE; i++) {
  100350:	e8 2c 00 00 00       	call   100381 <__x86.get_pc_thunk.ax>
  100355:	05 ab 0c 01 00       	add    $0x10cab,%eax
  10035a:	8b 80 00 70 02 00    	mov    0x27000(%eax),%eax
  100360:	8d 90 a0 0f 00 00    	lea    0xfa0(%eax),%edx
  100366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10036d:	8d 76 00             	lea    0x0(%esi),%esi
        terminal.crt_buf[i] = ' ';
  100370:	b9 20 00 00 00       	mov    $0x20,%ecx
    for (i = 0; i < CRT_SIZE; i++) {
  100375:	83 c0 02             	add    $0x2,%eax
        terminal.crt_buf[i] = ' ';
  100378:	66 89 48 fe          	mov    %cx,-0x2(%eax)
    for (i = 0; i < CRT_SIZE; i++) {
  10037c:	39 d0                	cmp    %edx,%eax
  10037e:	75 f0                	jne    100370 <video_clear_screen+0x20>
    }
    // spinlock_release(&video_lock);
}
  100380:	c3                   	ret    

00100381 <__x86.get_pc_thunk.ax>:
  100381:	8b 04 24             	mov    (%esp),%eax
  100384:	c3                   	ret    

00100385 <__x86.get_pc_thunk.dx>:
  100385:	8b 14 24             	mov    (%esp),%edx
  100388:	c3                   	ret    

00100389 <__x86.get_pc_thunk.bx>:
  100389:	8b 1c 24             	mov    (%esp),%ebx
  10038c:	c3                   	ret    
  10038d:	66 90                	xchg   %ax,%ax
  10038f:	90                   	nop

00100390 <cons_init>:
    char buf[CONSOLE_BUFFER_SIZE];
    uint32_t rpos, wpos;
} cons;

void cons_init()
{
  100390:	53                   	push   %ebx
  100391:	e8 f3 ff ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100396:	81 c3 6a 0c 01 00    	add    $0x10c6a,%ebx
  10039c:	83 ec 0c             	sub    $0xc,%esp
    memset(&cons, 0x0, sizeof(cons));
  10039f:	68 08 02 00 00       	push   $0x208
  1003a4:	6a 00                	push   $0x0
  1003a6:	8d 83 20 70 02 00    	lea    0x27020(%ebx),%eax
  1003ac:	50                   	push   %eax
  1003ad:	e8 9e 39 00 00       	call   103d50 <memset>
    serial_init();
  1003b2:	e8 59 04 00 00       	call   100810 <serial_init>
    video_init();
  1003b7:	e8 94 fc ff ff       	call   100050 <video_init>
    spinlock_init(&console_lock);
  1003bc:	8d 83 28 72 02 00    	lea    0x27228(%ebx),%eax
  1003c2:	89 04 24             	mov    %eax,(%esp)
  1003c5:	e8 26 53 00 00       	call   1056f0 <spinlock_init>
}
  1003ca:	83 c4 18             	add    $0x18,%esp
  1003cd:	5b                   	pop    %ebx
  1003ce:	c3                   	ret    
  1003cf:	90                   	nop

001003d0 <cons_intr>:

void cons_intr(int (*proc)(void))
{
  1003d0:	55                   	push   %ebp
  1003d1:	57                   	push   %edi
  1003d2:	56                   	push   %esi
    spinlock_acquire(&console_lock);

    while ((c = (*proc)()) != -1) {
        if (c == 0)
            continue;
        cons.buf[cons.wpos++] = c;
  1003d3:	8d 35 20 70 02 00    	lea    0x27020,%esi
{
  1003d9:	53                   	push   %ebx
  1003da:	e8 aa ff ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1003df:	81 c3 21 0c 01 00    	add    $0x10c21,%ebx
  1003e5:	83 ec 28             	sub    $0x28,%esp
  1003e8:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
    spinlock_acquire(&console_lock);
  1003ec:	8d 83 28 72 02 00    	lea    0x27228(%ebx),%eax
        cons.buf[cons.wpos++] = c;
  1003f2:	8d 2c 33             	lea    (%ebx,%esi,1),%ebp
    spinlock_acquire(&console_lock);
  1003f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  1003f9:	50                   	push   %eax
  1003fa:	e8 81 53 00 00       	call   105780 <spinlock_acquire>
    while ((c = (*proc)()) != -1) {
  1003ff:	83 c4 10             	add    $0x10,%esp
  100402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100408:	ff d7                	call   *%edi
  10040a:	83 f8 ff             	cmp    $0xffffffff,%eax
  10040d:	74 33                	je     100442 <cons_intr+0x72>
        if (c == 0)
  10040f:	85 c0                	test   %eax,%eax
  100411:	74 f5                	je     100408 <cons_intr+0x38>
        cons.buf[cons.wpos++] = c;
  100413:	8b 8c 33 04 02 00 00 	mov    0x204(%ebx,%esi,1),%ecx
  10041a:	8d 51 01             	lea    0x1(%ecx),%edx
  10041d:	88 44 0d 00          	mov    %al,0x0(%ebp,%ecx,1)
  100421:	89 94 33 04 02 00 00 	mov    %edx,0x204(%ebx,%esi,1)
        if (cons.wpos == CONSOLE_BUFFER_SIZE)
  100428:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  10042e:	75 d8                	jne    100408 <cons_intr+0x38>
            cons.wpos = 0;
  100430:	c7 84 1e 04 02 00 00 	movl   $0x0,0x204(%esi,%ebx,1)
  100437:	00 00 00 00 
    while ((c = (*proc)()) != -1) {
  10043b:	ff d7                	call   *%edi
  10043d:	83 f8 ff             	cmp    $0xffffffff,%eax
  100440:	75 cd                	jne    10040f <cons_intr+0x3f>
    }

    spinlock_release(&console_lock);
  100442:	83 ec 0c             	sub    $0xc,%esp
  100445:	ff 74 24 18          	push   0x18(%esp)
  100449:	e8 b2 53 00 00       	call   105800 <spinlock_release>
}
  10044e:	83 c4 2c             	add    $0x2c,%esp
  100451:	5b                   	pop    %ebx
  100452:	5e                   	pop    %esi
  100453:	5f                   	pop    %edi
  100454:	5d                   	pop    %ebp
  100455:	c3                   	ret    
  100456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10045d:	8d 76 00             	lea    0x0(%esi),%esi

00100460 <cons_getc>:

char cons_getc(void)
{
  100460:	57                   	push   %edi
  100461:	56                   	push   %esi
  100462:	53                   	push   %ebx
  100463:	e8 21 ff ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100468:	81 c3 98 0b 01 00    	add    $0x10b98,%ebx
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10046e:	e8 5d 02 00 00       	call   1006d0 <serial_intr>
    keyboard_intr();

    spinlock_acquire(&console_lock);
  100473:	8d b3 28 72 02 00    	lea    0x27228(%ebx),%esi
    keyboard_intr();
  100479:	e8 12 06 00 00       	call   100a90 <keyboard_intr>
    spinlock_acquire(&console_lock);
  10047e:	83 ec 0c             	sub    $0xc,%esp
  100481:	56                   	push   %esi
  100482:	e8 f9 52 00 00       	call   105780 <spinlock_acquire>
    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  100487:	8b 83 20 72 02 00    	mov    0x27220(%ebx),%eax
  10048d:	83 c4 10             	add    $0x10,%esp
  100490:	3b 83 24 72 02 00    	cmp    0x27224(%ebx),%eax
  100496:	74 38                	je     1004d0 <cons_getc+0x70>
        c = cons.buf[cons.rpos++];
  100498:	0f b6 bc 03 20 70 02 	movzbl 0x27020(%ebx,%eax,1),%edi
  10049f:	00 
        if (cons.rpos == CONSOLE_BUFFER_SIZE)
            cons.rpos = 0;
  1004a0:	3d ff 01 00 00       	cmp    $0x1ff,%eax
        c = cons.buf[cons.rpos++];
  1004a5:	8d 50 01             	lea    0x1(%eax),%edx
            cons.rpos = 0;
  1004a8:	b8 00 00 00 00       	mov    $0x0,%eax
  1004ad:	0f 44 d0             	cmove  %eax,%edx
        spinlock_release(&console_lock);
  1004b0:	83 ec 0c             	sub    $0xc,%esp
  1004b3:	56                   	push   %esi
  1004b4:	89 93 20 72 02 00    	mov    %edx,0x27220(%ebx)
  1004ba:	e8 41 53 00 00       	call   105800 <spinlock_release>
        return c;
  1004bf:	83 c4 10             	add    $0x10,%esp
    }

    spinlock_release(&console_lock);
    return 0;
}
  1004c2:	89 f8                	mov    %edi,%eax
  1004c4:	5b                   	pop    %ebx
  1004c5:	5e                   	pop    %esi
  1004c6:	5f                   	pop    %edi
  1004c7:	c3                   	ret    
  1004c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1004cf:	90                   	nop
    spinlock_release(&console_lock);
  1004d0:	83 ec 0c             	sub    $0xc,%esp
    return 0;
  1004d3:	31 ff                	xor    %edi,%edi
    spinlock_release(&console_lock);
  1004d5:	56                   	push   %esi
  1004d6:	e8 25 53 00 00       	call   105800 <spinlock_release>
    return 0;
  1004db:	83 c4 10             	add    $0x10,%esp
}
  1004de:	89 f8                	mov    %edi,%eax
  1004e0:	5b                   	pop    %ebx
  1004e1:	5e                   	pop    %esi
  1004e2:	5f                   	pop    %edi
  1004e3:	c3                   	ret    
  1004e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1004eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1004ef:	90                   	nop

001004f0 <cons_putc>:

void cons_putc(char c)
{
  1004f0:	56                   	push   %esi
  1004f1:	53                   	push   %ebx
  1004f2:	e8 92 fe ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1004f7:	81 c3 09 0b 01 00    	add    $0x10b09,%ebx
  1004fd:	83 ec 10             	sub    $0x10,%esp
    serial_putc(c);
  100500:	0f be 74 24 1c       	movsbl 0x1c(%esp),%esi
  100505:	56                   	push   %esi
  100506:	e8 05 02 00 00       	call   100710 <serial_putc>
    video_putc(c);
  10050b:	89 34 24             	mov    %esi,(%esp)
  10050e:	e8 3d fc ff ff       	call   100150 <video_putc>
}
  100513:	83 c4 14             	add    $0x14,%esp
  100516:	5b                   	pop    %ebx
  100517:	5e                   	pop    %esi
  100518:	c3                   	ret    
  100519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100520 <getchar>:

char getchar(void)
{
  100520:	83 ec 0c             	sub    $0xc,%esp
    char c;

    while ((c = cons_getc()) == 0)
  100523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100527:	90                   	nop
  100528:	e8 33 ff ff ff       	call   100460 <cons_getc>
  10052d:	84 c0                	test   %al,%al
  10052f:	74 f7                	je     100528 <getchar+0x8>
        /* do nothing */ ;
    return c;
}
  100531:	83 c4 0c             	add    $0xc,%esp
  100534:	c3                   	ret    
  100535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10053c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100540 <putchar>:
  100540:	56                   	push   %esi
  100541:	53                   	push   %ebx
  100542:	e8 42 fe ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100547:	81 c3 b9 0a 01 00    	add    $0x10ab9,%ebx
  10054d:	83 ec 10             	sub    $0x10,%esp
  100550:	0f be 74 24 1c       	movsbl 0x1c(%esp),%esi
  100555:	56                   	push   %esi
  100556:	e8 b5 01 00 00       	call   100710 <serial_putc>
  10055b:	89 34 24             	mov    %esi,(%esp)
  10055e:	e8 ed fb ff ff       	call   100150 <video_putc>
  100563:	83 c4 14             	add    $0x14,%esp
  100566:	5b                   	pop    %ebx
  100567:	5e                   	pop    %esi
  100568:	c3                   	ret    
  100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100570 <readline>:
{
    cons_putc(c);
}

char *readline(const char *prompt)
{
  100570:	55                   	push   %ebp
  100571:	57                   	push   %edi
  100572:	56                   	push   %esi
  100573:	53                   	push   %ebx
  100574:	e8 10 fe ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100579:	81 c3 87 0a 01 00    	add    $0x10a87,%ebx
  10057f:	83 ec 1c             	sub    $0x1c,%esp
  100582:	8b 44 24 30          	mov    0x30(%esp),%eax
    int i;
    char c;

    if (prompt != NULL)
  100586:	85 c0                	test   %eax,%eax
  100588:	74 13                	je     10059d <readline+0x2d>
        dprintf("%s", prompt);
  10058a:	83 ec 08             	sub    $0x8,%esp
  10058d:	50                   	push   %eax
  10058e:	8d 83 76 98 ff ff    	lea    -0x678a(%ebx),%eax
  100594:	50                   	push   %eax
  100595:	e8 a6 3c 00 00       	call   104240 <dprintf>
  10059a:	83 c4 10             	add    $0x10,%esp
        } else if ((c == '\b' || c == '\x7f') && i > 0) {
            putchar('\b');
            i--;
        } else if (c >= ' ' && i < BUFLEN - 1) {
            putchar(c);
            linebuf[i++] = c;
  10059d:	31 f6                	xor    %esi,%esi
  10059f:	8d bb 40 72 02 00    	lea    0x27240(%ebx),%edi
  1005a5:	8d 76 00             	lea    0x0(%esi),%esi
    while ((c = cons_getc()) == 0)
  1005a8:	e8 b3 fe ff ff       	call   100460 <cons_getc>
  1005ad:	84 c0                	test   %al,%al
  1005af:	74 f7                	je     1005a8 <readline+0x38>
        if (c < 0) {
  1005b1:	0f 88 a2 00 00 00    	js     100659 <readline+0xe9>
        } else if ((c == '\b' || c == '\x7f') && i > 0) {
  1005b7:	3c 08                	cmp    $0x8,%al
  1005b9:	0f 94 c2             	sete   %dl
  1005bc:	3c 7f                	cmp    $0x7f,%al
  1005be:	0f 94 c1             	sete   %cl
  1005c1:	08 ca                	or     %cl,%dl
  1005c3:	74 04                	je     1005c9 <readline+0x59>
  1005c5:	85 f6                	test   %esi,%esi
  1005c7:	75 6f                	jne    100638 <readline+0xc8>
        } else if (c >= ' ' && i < BUFLEN - 1) {
  1005c9:	3c 1f                	cmp    $0x1f,%al
  1005cb:	7e 33                	jle    100600 <readline+0x90>
  1005cd:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  1005d3:	7f 2b                	jg     100600 <readline+0x90>
            putchar(c);
  1005d5:	88 44 24 0f          	mov    %al,0xf(%esp)
  1005d9:	0f be e8             	movsbl %al,%ebp
    serial_putc(c);
  1005dc:	83 ec 0c             	sub    $0xc,%esp
  1005df:	55                   	push   %ebp
  1005e0:	e8 2b 01 00 00       	call   100710 <serial_putc>
    video_putc(c);
  1005e5:	89 2c 24             	mov    %ebp,(%esp)
  1005e8:	e8 63 fb ff ff       	call   100150 <video_putc>
            linebuf[i++] = c;
  1005ed:	0f b6 44 24 1f       	movzbl 0x1f(%esp),%eax
  1005f2:	83 c4 10             	add    $0x10,%esp
  1005f5:	88 04 37             	mov    %al,(%edi,%esi,1)
  1005f8:	83 c6 01             	add    $0x1,%esi
  1005fb:	eb ab                	jmp    1005a8 <readline+0x38>
  1005fd:	8d 76 00             	lea    0x0(%esi),%esi
        } else if (c == '\n' || c == '\r') {
  100600:	3c 0a                	cmp    $0xa,%al
  100602:	74 04                	je     100608 <readline+0x98>
  100604:	3c 0d                	cmp    $0xd,%al
  100606:	75 a0                	jne    1005a8 <readline+0x38>
    serial_putc(c);
  100608:	83 ec 0c             	sub    $0xc,%esp
  10060b:	6a 0a                	push   $0xa
  10060d:	e8 fe 00 00 00       	call   100710 <serial_putc>
    video_putc(c);
  100612:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100619:	e8 32 fb ff ff       	call   100150 <video_putc>
            putchar('\n');
            linebuf[i] = 0;
  10061e:	8d 83 40 72 02 00    	lea    0x27240(%ebx),%eax
            return linebuf;
  100624:	83 c4 10             	add    $0x10,%esp
            linebuf[i] = 0;
  100627:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
        }
    }
}
  10062b:	83 c4 1c             	add    $0x1c,%esp
  10062e:	5b                   	pop    %ebx
  10062f:	5e                   	pop    %esi
  100630:	5f                   	pop    %edi
  100631:	5d                   	pop    %ebp
  100632:	c3                   	ret    
  100633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100637:	90                   	nop
    serial_putc(c);
  100638:	83 ec 0c             	sub    $0xc,%esp
            i--;
  10063b:	83 ee 01             	sub    $0x1,%esi
    serial_putc(c);
  10063e:	6a 08                	push   $0x8
  100640:	e8 cb 00 00 00       	call   100710 <serial_putc>
    video_putc(c);
  100645:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10064c:	e8 ff fa ff ff       	call   100150 <video_putc>
            i--;
  100651:	83 c4 10             	add    $0x10,%esp
  100654:	e9 4f ff ff ff       	jmp    1005a8 <readline+0x38>
            dprintf("read error: %e\n", c);
  100659:	83 ec 08             	sub    $0x8,%esp
  10065c:	0f be c0             	movsbl %al,%eax
  10065f:	50                   	push   %eax
  100660:	8d 83 0e 80 ff ff    	lea    -0x7ff2(%ebx),%eax
  100666:	50                   	push   %eax
  100667:	e8 d4 3b 00 00       	call   104240 <dprintf>
            return NULL;
  10066c:	83 c4 10             	add    $0x10,%esp
  10066f:	31 c0                	xor    %eax,%eax
}
  100671:	83 c4 1c             	add    $0x1c,%esp
  100674:	5b                   	pop    %ebx
  100675:	5e                   	pop    %esi
  100676:	5f                   	pop    %edi
  100677:	5d                   	pop    %ebp
  100678:	c3                   	ret    
  100679:	66 90                	xchg   %ax,%ax
  10067b:	66 90                	xchg   %ax,%ax
  10067d:	66 90                	xchg   %ax,%ax
  10067f:	90                   	nop

00100680 <serial_proc_data>:
    inb(0x84);
    inb(0x84);
}

static int serial_proc_data(void)
{
  100680:	53                   	push   %ebx
  100681:	e8 03 fd ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100686:	81 c3 7a 09 01 00    	add    $0x1097a,%ebx
  10068c:	83 ec 14             	sub    $0x14,%esp
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
  10068f:	68 fd 03 00 00       	push   $0x3fd
  100694:	e8 b7 47 00 00       	call   104e50 <inb>
  100699:	83 c4 10             	add    $0x10,%esp
  10069c:	a8 01                	test   $0x1,%al
  10069e:	74 20                	je     1006c0 <serial_proc_data+0x40>
        return -1;
    return inb(COM1 + COM_RX);
  1006a0:	83 ec 0c             	sub    $0xc,%esp
  1006a3:	68 f8 03 00 00       	push   $0x3f8
  1006a8:	e8 a3 47 00 00       	call   104e50 <inb>
  1006ad:	83 c4 10             	add    $0x10,%esp
  1006b0:	0f b6 c0             	movzbl %al,%eax
}
  1006b3:	83 c4 08             	add    $0x8,%esp
  1006b6:	5b                   	pop    %ebx
  1006b7:	c3                   	ret    
  1006b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1006bf:	90                   	nop
        return -1;
  1006c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c5:	eb ec                	jmp    1006b3 <serial_proc_data+0x33>
  1006c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1006ce:	66 90                	xchg   %ax,%ax

001006d0 <serial_intr>:

void serial_intr(void)
{
  1006d0:	53                   	push   %ebx
  1006d1:	e8 b3 fc ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1006d6:	81 c3 2a 09 01 00    	add    $0x1092a,%ebx
  1006dc:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists)
  1006df:	80 bb 40 76 02 00 00 	cmpb   $0x0,0x27640(%ebx)
  1006e6:	75 08                	jne    1006f0 <serial_intr+0x20>
        cons_intr(serial_proc_data);
}
  1006e8:	83 c4 08             	add    $0x8,%esp
  1006eb:	5b                   	pop    %ebx
  1006ec:	c3                   	ret    
  1006ed:	8d 76 00             	lea    0x0(%esi),%esi
        cons_intr(serial_proc_data);
  1006f0:	83 ec 0c             	sub    $0xc,%esp
  1006f3:	8d 83 80 f6 fe ff    	lea    -0x10980(%ebx),%eax
  1006f9:	50                   	push   %eax
  1006fa:	e8 d1 fc ff ff       	call   1003d0 <cons_intr>
  1006ff:	83 c4 10             	add    $0x10,%esp
}
  100702:	83 c4 08             	add    $0x8,%esp
  100705:	5b                   	pop    %ebx
  100706:	c3                   	ret    
  100707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10070e:	66 90                	xchg   %ax,%ax

00100710 <serial_putc>:
    } else
        return 0;
}

void serial_putc(char c)
{
  100710:	55                   	push   %ebp
  100711:	57                   	push   %edi
  100712:	56                   	push   %esi
  100713:	53                   	push   %ebx
  100714:	e8 70 fc ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100719:	81 c3 e7 08 01 00    	add    $0x108e7,%ebx
  10071f:	83 ec 0c             	sub    $0xc,%esp
  100722:	8b 7c 24 20          	mov    0x20(%esp),%edi
    if (!serial_exists)
  100726:	80 bb 40 76 02 00 00 	cmpb   $0x0,0x27640(%ebx)
  10072d:	75 11                	jne    100740 <serial_putc+0x30>

    if (!serial_reformatnewline(c, COM1 + COM_TX))
        outb(COM1 + COM_TX, c);

    spinlock_release(&serial_lock);
}
  10072f:	83 c4 0c             	add    $0xc,%esp
  100732:	5b                   	pop    %ebx
  100733:	5e                   	pop    %esi
  100734:	5f                   	pop    %edi
  100735:	5d                   	pop    %ebp
  100736:	c3                   	ret    
  100737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10073e:	66 90                	xchg   %ax,%ax
    spinlock_acquire(&serial_lock);
  100740:	83 ec 0c             	sub    $0xc,%esp
  100743:	8d ab 44 76 02 00    	lea    0x27644(%ebx),%ebp
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  100749:	31 f6                	xor    %esi,%esi
    spinlock_acquire(&serial_lock);
  10074b:	55                   	push   %ebp
  10074c:	e8 2f 50 00 00       	call   105780 <spinlock_acquire>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  100751:	83 c4 10             	add    $0x10,%esp
  100754:	eb 49                	jmp    10079f <serial_putc+0x8f>
  100756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10075d:	8d 76 00             	lea    0x0(%esi),%esi
  100760:	81 fe 00 32 00 00    	cmp    $0x3200,%esi
  100766:	74 4b                	je     1007b3 <serial_putc+0xa3>
    inb(0x84);
  100768:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  10076b:	83 c6 01             	add    $0x1,%esi
    inb(0x84);
  10076e:	68 84 00 00 00       	push   $0x84
  100773:	e8 d8 46 00 00       	call   104e50 <inb>
    inb(0x84);
  100778:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  10077f:	e8 cc 46 00 00       	call   104e50 <inb>
    inb(0x84);
  100784:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  10078b:	e8 c0 46 00 00       	call   104e50 <inb>
    inb(0x84);
  100790:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  100797:	e8 b4 46 00 00       	call   104e50 <inb>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  10079c:	83 c4 10             	add    $0x10,%esp
  10079f:	83 ec 0c             	sub    $0xc,%esp
  1007a2:	68 fd 03 00 00       	push   $0x3fd
  1007a7:	e8 a4 46 00 00       	call   104e50 <inb>
  1007ac:	83 c4 10             	add    $0x10,%esp
  1007af:	a8 20                	test   $0x20,%al
  1007b1:	74 ad                	je     100760 <serial_putc+0x50>
    if (c == nl) {
  1007b3:	89 f8                	mov    %edi,%eax
  1007b5:	3c 0a                	cmp    $0xa,%al
  1007b7:	74 2f                	je     1007e8 <serial_putc+0xd8>
        outb(COM1 + COM_TX, c);
  1007b9:	83 ec 08             	sub    $0x8,%esp
  1007bc:	0f b6 f8             	movzbl %al,%edi
  1007bf:	57                   	push   %edi
  1007c0:	68 f8 03 00 00       	push   $0x3f8
  1007c5:	e8 b6 46 00 00       	call   104e80 <outb>
  1007ca:	83 c4 10             	add    $0x10,%esp
    spinlock_release(&serial_lock);
  1007cd:	83 ec 0c             	sub    $0xc,%esp
  1007d0:	55                   	push   %ebp
  1007d1:	e8 2a 50 00 00       	call   105800 <spinlock_release>
  1007d6:	83 c4 10             	add    $0x10,%esp
}
  1007d9:	83 c4 0c             	add    $0xc,%esp
  1007dc:	5b                   	pop    %ebx
  1007dd:	5e                   	pop    %esi
  1007de:	5f                   	pop    %edi
  1007df:	5d                   	pop    %ebp
  1007e0:	c3                   	ret    
  1007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        outb(p, cr);
  1007e8:	83 ec 08             	sub    $0x8,%esp
  1007eb:	6a 0d                	push   $0xd
  1007ed:	68 f8 03 00 00       	push   $0x3f8
  1007f2:	e8 89 46 00 00       	call   104e80 <outb>
        outb(p, nl);
  1007f7:	58                   	pop    %eax
  1007f8:	5a                   	pop    %edx
  1007f9:	6a 0a                	push   $0xa
  1007fb:	68 f8 03 00 00       	push   $0x3f8
  100800:	e8 7b 46 00 00       	call   104e80 <outb>
  100805:	83 c4 10             	add    $0x10,%esp
  100808:	eb c3                	jmp    1007cd <serial_putc+0xbd>
  10080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100810 <serial_init>:

void serial_init(void)
{
  100810:	53                   	push   %ebx
  100811:	e8 73 fb ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100816:	81 c3 ea 07 01 00    	add    $0x107ea,%ebx
  10081c:	83 ec 10             	sub    $0x10,%esp
    /* turn off interrupt */
    outb(COM1 + COM_IER, 0);
  10081f:	6a 00                	push   $0x0
  100821:	68 f9 03 00 00       	push   $0x3f9
  100826:	e8 55 46 00 00       	call   104e80 <outb>

    /* set DLAB */
    outb(COM1 + COM_LCR, COM_LCR_DLAB);
  10082b:	58                   	pop    %eax
  10082c:	5a                   	pop    %edx
  10082d:	68 80 00 00 00       	push   $0x80
  100832:	68 fb 03 00 00       	push   $0x3fb
  100837:	e8 44 46 00 00       	call   104e80 <outb>

    /* set baud rate */
    outb(COM1 + COM_DLL, 0x0001 & 0xff);
  10083c:	59                   	pop    %ecx
  10083d:	58                   	pop    %eax
  10083e:	6a 01                	push   $0x1
  100840:	68 f8 03 00 00       	push   $0x3f8
  100845:	e8 36 46 00 00       	call   104e80 <outb>
    outb(COM1 + COM_DLM, 0x0001 >> 8);
  10084a:	58                   	pop    %eax
  10084b:	5a                   	pop    %edx
  10084c:	6a 00                	push   $0x0
  10084e:	68 f9 03 00 00       	push   $0x3f9
  100853:	e8 28 46 00 00       	call   104e80 <outb>

    /* Set the line status. */
    outb(COM1 + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
  100858:	59                   	pop    %ecx
  100859:	58                   	pop    %eax
  10085a:	6a 03                	push   $0x3
  10085c:	68 fb 03 00 00       	push   $0x3fb
  100861:	e8 1a 46 00 00       	call   104e80 <outb>

    /* Enable the FIFO. */
    outb(COM1 + COM_FCR, 0xc7);
  100866:	58                   	pop    %eax
  100867:	5a                   	pop    %edx
  100868:	68 c7 00 00 00       	push   $0xc7
  10086d:	68 fa 03 00 00       	push   $0x3fa
  100872:	e8 09 46 00 00       	call   104e80 <outb>

    /* Turn on DTR, RTS, and OUT2. */
    outb(COM1 + COM_MCR, 0x0b);
  100877:	59                   	pop    %ecx
  100878:	58                   	pop    %eax
  100879:	6a 0b                	push   $0xb
  10087b:	68 fc 03 00 00       	push   $0x3fc
  100880:	e8 fb 45 00 00       	call   104e80 <outb>

    // Clear any preexisting overrun indications and interrupts
    // Serial COM1 doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100885:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
  10088c:	e8 bf 45 00 00       	call   104e50 <inb>
    (void) inb(COM1 + COM_IIR);
  100891:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100898:	3c ff                	cmp    $0xff,%al
  10089a:	0f 95 83 40 76 02 00 	setne  0x27640(%ebx)
    (void) inb(COM1 + COM_IIR);
  1008a1:	e8 aa 45 00 00       	call   104e50 <inb>
    (void) inb(COM1 + COM_RX);
  1008a6:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
  1008ad:	e8 9e 45 00 00       	call   104e50 <inb>

    // initialize the lock
    spinlock_init(&serial_lock);
  1008b2:	8d 83 44 76 02 00    	lea    0x27644(%ebx),%eax
  1008b8:	89 04 24             	mov    %eax,(%esp)
  1008bb:	e8 30 4e 00 00       	call   1056f0 <spinlock_init>
}
  1008c0:	83 c4 18             	add    $0x18,%esp
  1008c3:	5b                   	pop    %ebx
  1008c4:	c3                   	ret    
  1008c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1008cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001008d0 <serial_intenable>:

void serial_intenable(void)
{
  1008d0:	53                   	push   %ebx
  1008d1:	e8 b3 fa ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1008d6:	81 c3 2a 07 01 00    	add    $0x1072a,%ebx
  1008dc:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1008df:	80 bb 40 76 02 00 00 	cmpb   $0x0,0x27640(%ebx)
  1008e6:	75 08                	jne    1008f0 <serial_intenable+0x20>
        outb(COM1 + COM_IER, 1);
        serial_intr();
    }
}
  1008e8:	83 c4 08             	add    $0x8,%esp
  1008eb:	5b                   	pop    %ebx
  1008ec:	c3                   	ret    
  1008ed:	8d 76 00             	lea    0x0(%esi),%esi
        outb(COM1 + COM_IER, 1);
  1008f0:	83 ec 08             	sub    $0x8,%esp
  1008f3:	6a 01                	push   $0x1
  1008f5:	68 f9 03 00 00       	push   $0x3f9
  1008fa:	e8 81 45 00 00       	call   104e80 <outb>
    if (serial_exists)
  1008ff:	83 c4 10             	add    $0x10,%esp
  100902:	80 bb 40 76 02 00 00 	cmpb   $0x0,0x27640(%ebx)
  100909:	74 dd                	je     1008e8 <serial_intenable+0x18>
        cons_intr(serial_proc_data);
  10090b:	83 ec 0c             	sub    $0xc,%esp
  10090e:	8d 83 80 f6 fe ff    	lea    -0x10980(%ebx),%eax
  100914:	50                   	push   %eax
  100915:	e8 b6 fa ff ff       	call   1003d0 <cons_intr>
  10091a:	83 c4 10             	add    $0x10,%esp
}
  10091d:	83 c4 08             	add    $0x8,%esp
  100920:	5b                   	pop    %ebx
  100921:	c3                   	ret    
  100922:	66 90                	xchg   %ax,%ax
  100924:	66 90                	xchg   %ax,%ax
  100926:	66 90                	xchg   %ax,%ax
  100928:	66 90                	xchg   %ax,%ax
  10092a:	66 90                	xchg   %ax,%ax
  10092c:	66 90                	xchg   %ax,%ax
  10092e:	66 90                	xchg   %ax,%ax

00100930 <kbd_proc_data>:
/*
 * Get data from the keyboard. If we finish a character, return it. Else 0.
 * Return -1 if no data.
 */
static int kbd_proc_data(void)
{
  100930:	56                   	push   %esi
  100931:	53                   	push   %ebx
  100932:	e8 52 fa ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100937:	81 c3 c9 06 01 00    	add    $0x106c9,%ebx
  10093d:	83 ec 10             	sub    $0x10,%esp
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0)
  100940:	6a 64                	push   $0x64
  100942:	e8 09 45 00 00       	call   104e50 <inb>
  100947:	83 c4 10             	add    $0x10,%esp
  10094a:	a8 01                	test   $0x1,%al
  10094c:	0f 84 2e 01 00 00    	je     100a80 <kbd_proc_data+0x150>
        return -1;

    data = inb(KBDATAP);
  100952:	83 ec 0c             	sub    $0xc,%esp
  100955:	6a 60                	push   $0x60
  100957:	e8 f4 44 00 00       	call   104e50 <inb>

    if (data == 0xE0) {
  10095c:	83 c4 10             	add    $0x10,%esp
  10095f:	3c e0                	cmp    $0xe0,%al
  100961:	0f 84 89 00 00 00    	je     1009f0 <kbd_proc_data+0xc0>
        // E0 escape character
        shift |= E0ESC;
  100967:	8b 8b 4c 76 02 00    	mov    0x2764c(%ebx),%ecx
        return 0;
    } else if (data & 0x80) {
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10096d:	89 ca                	mov    %ecx,%edx
  10096f:	83 e2 40             	and    $0x40,%edx
    } else if (data & 0x80) {
  100972:	84 c0                	test   %al,%al
  100974:	0f 88 8e 00 00 00    	js     100a08 <kbd_proc_data+0xd8>
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    } else if (shift & E0ESC) {
  10097a:	85 d2                	test   %edx,%edx
  10097c:	74 06                	je     100984 <kbd_proc_data+0x54>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10097e:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
  100981:	83 e1 bf             	and    $0xffffffbf,%ecx
    }

    shift |= shiftcode[data];
  100984:	0f b6 c0             	movzbl %al,%eax
  100987:	0f b6 94 03 40 81 ff 	movzbl -0x7ec0(%ebx,%eax,1),%edx
  10098e:	ff 
  10098f:	09 ca                	or     %ecx,%edx
    shift ^= togglecode[data];
  100991:	0f b6 8c 03 40 80 ff 	movzbl -0x7fc0(%ebx,%eax,1),%ecx
  100998:	ff 
  100999:	31 ca                	xor    %ecx,%edx

    c = charcode[shift & (CTL | SHIFT)][data];
  10099b:	89 d1                	mov    %edx,%ecx
    shift ^= togglecode[data];
  10099d:	89 93 4c 76 02 00    	mov    %edx,0x2764c(%ebx)
    c = charcode[shift & (CTL | SHIFT)][data];
  1009a3:	83 e1 03             	and    $0x3,%ecx
  1009a6:	8b 8c 8b d8 ff ff ff 	mov    -0x28(%ebx,%ecx,4),%ecx
  1009ad:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
    if (shift & CAPSLOCK) {
  1009b1:	f6 c2 08             	test   $0x8,%dl
  1009b4:	75 22                	jne    1009d8 <kbd_proc_data+0xa8>
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }
    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1009b6:	f7 d2                	not    %edx
  1009b8:	83 e2 06             	and    $0x6,%edx
  1009bb:	75 0c                	jne    1009c9 <kbd_proc_data+0x99>
  1009bd:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
  1009c3:	0f 84 8f 00 00 00    	je     100a58 <kbd_proc_data+0x128>
        dprintf("Rebooting!\n");
        outb(0x92, 0x3);  // courtesy of Chris Frost
    }

    return c;
}
  1009c9:	83 c4 04             	add    $0x4,%esp
  1009cc:	89 f0                	mov    %esi,%eax
  1009ce:	5b                   	pop    %ebx
  1009cf:	5e                   	pop    %esi
  1009d0:	c3                   	ret    
  1009d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if ('a' <= c && c <= 'z')
  1009d8:	8d 46 9f             	lea    -0x61(%esi),%eax
  1009db:	83 f8 19             	cmp    $0x19,%eax
  1009de:	77 60                	ja     100a40 <kbd_proc_data+0x110>
            c += 'A' - 'a';
  1009e0:	83 ee 20             	sub    $0x20,%esi
}
  1009e3:	83 c4 04             	add    $0x4,%esp
  1009e6:	89 f0                	mov    %esi,%eax
  1009e8:	5b                   	pop    %ebx
  1009e9:	5e                   	pop    %esi
  1009ea:	c3                   	ret    
  1009eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1009ef:	90                   	nop
        shift |= E0ESC;
  1009f0:	83 8b 4c 76 02 00 40 	orl    $0x40,0x2764c(%ebx)
        return 0;
  1009f7:	31 f6                	xor    %esi,%esi
}
  1009f9:	83 c4 04             	add    $0x4,%esp
  1009fc:	89 f0                	mov    %esi,%eax
  1009fe:	5b                   	pop    %ebx
  1009ff:	5e                   	pop    %esi
  100a00:	c3                   	ret    
  100a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        data = (shift & E0ESC ? data : data & 0x7F);
  100a08:	89 c6                	mov    %eax,%esi
  100a0a:	83 e6 7f             	and    $0x7f,%esi
  100a0d:	85 d2                	test   %edx,%edx
  100a0f:	0f 44 c6             	cmove  %esi,%eax
        return 0;
  100a12:	31 f6                	xor    %esi,%esi
        shift &= ~(shiftcode[data] | E0ESC);
  100a14:	0f b6 c0             	movzbl %al,%eax
  100a17:	0f b6 84 03 40 81 ff 	movzbl -0x7ec0(%ebx,%eax,1),%eax
  100a1e:	ff 
  100a1f:	83 c8 40             	or     $0x40,%eax
  100a22:	0f b6 c0             	movzbl %al,%eax
  100a25:	f7 d0                	not    %eax
  100a27:	21 c8                	and    %ecx,%eax
  100a29:	89 83 4c 76 02 00    	mov    %eax,0x2764c(%ebx)
}
  100a2f:	83 c4 04             	add    $0x4,%esp
  100a32:	89 f0                	mov    %esi,%eax
  100a34:	5b                   	pop    %ebx
  100a35:	5e                   	pop    %esi
  100a36:	c3                   	ret    
  100a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100a3e:	66 90                	xchg   %ax,%ax
        else if ('A' <= c && c <= 'Z')
  100a40:	8d 4e bf             	lea    -0x41(%esi),%ecx
            c += 'a' - 'A';
  100a43:	8d 46 20             	lea    0x20(%esi),%eax
  100a46:	83 f9 1a             	cmp    $0x1a,%ecx
  100a49:	0f 42 f0             	cmovb  %eax,%esi
  100a4c:	e9 65 ff ff ff       	jmp    1009b6 <kbd_proc_data+0x86>
  100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dprintf("Rebooting!\n");
  100a58:	83 ec 0c             	sub    $0xc,%esp
  100a5b:	8d 83 1e 80 ff ff    	lea    -0x7fe2(%ebx),%eax
  100a61:	50                   	push   %eax
  100a62:	e8 d9 37 00 00       	call   104240 <dprintf>
        outb(0x92, 0x3);  // courtesy of Chris Frost
  100a67:	58                   	pop    %eax
  100a68:	5a                   	pop    %edx
  100a69:	6a 03                	push   $0x3
  100a6b:	68 92 00 00 00       	push   $0x92
  100a70:	e8 0b 44 00 00       	call   104e80 <outb>
  100a75:	83 c4 10             	add    $0x10,%esp
  100a78:	e9 4c ff ff ff       	jmp    1009c9 <kbd_proc_data+0x99>
  100a7d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
  100a80:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100a85:	e9 3f ff ff ff       	jmp    1009c9 <kbd_proc_data+0x99>
  100a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100a90 <keyboard_intr>:

void keyboard_intr(void)
{
  100a90:	53                   	push   %ebx
  100a91:	e8 f3 f8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100a96:	81 c3 6a 05 01 00    	add    $0x1056a,%ebx
  100a9c:	83 ec 14             	sub    $0x14,%esp
    cons_intr(kbd_proc_data);
  100a9f:	8d 83 30 f9 fe ff    	lea    -0x106d0(%ebx),%eax
  100aa5:	50                   	push   %eax
  100aa6:	e8 25 f9 ff ff       	call   1003d0 <cons_intr>
}
  100aab:	83 c4 18             	add    $0x18,%esp
  100aae:	5b                   	pop    %ebx
  100aaf:	c3                   	ret    

00100ab0 <devinit>:
#include "tsc.h"

void intr_init(void);

void devinit(uintptr_t mbi_addr)
{
  100ab0:	56                   	push   %esi
  100ab1:	53                   	push   %ebx
  100ab2:	e8 d2 f8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100ab7:	81 c3 49 05 01 00    	add    $0x10549,%ebx
  100abd:	83 ec 10             	sub    $0x10,%esp
  100ac0:	8b 74 24 1c          	mov    0x1c(%esp),%esi
    seg_init(0);
  100ac4:	6a 00                	push   $0x0
  100ac6:	e8 55 3e 00 00       	call   104920 <seg_init>

    enable_sse();
  100acb:	e8 30 42 00 00       	call   104d00 <enable_sse>

    cons_init();
  100ad0:	e8 bb f8 ff ff       	call   100390 <cons_init>

    debug_init();
  100ad5:	e8 d6 34 00 00       	call   103fb0 <debug_init>
    KERN_INFO("[BSP KERN] cons initialized.\n");
  100ada:	8d 83 40 82 ff ff    	lea    -0x7dc0(%ebx),%eax
  100ae0:	89 04 24             	mov    %eax,(%esp)
  100ae3:	e8 d8 34 00 00       	call   103fc0 <debug_info>
    KERN_INFO("[BSP KERN] devinit mbi_addr: %d\n", mbi_addr);
  100ae8:	58                   	pop    %eax
  100ae9:	8d 83 10 83 ff ff    	lea    -0x7cf0(%ebx),%eax
  100aef:	5a                   	pop    %edx
  100af0:	56                   	push   %esi
  100af1:	50                   	push   %eax
  100af2:	e8 c9 34 00 00       	call   103fc0 <debug_info>

    /* pcpu init codes */
    pcpu_init();
  100af7:	e8 d4 54 00 00       	call   105fd0 <pcpu_init>
    KERN_INFO("[BSP KERN] PCPU initialized\n");
  100afc:	8d 83 5e 82 ff ff    	lea    -0x7da2(%ebx),%eax
  100b02:	89 04 24             	mov    %eax,(%esp)
  100b05:	e8 b6 34 00 00       	call   103fc0 <debug_info>

    tsc_init();
  100b0a:	e8 81 11 00 00       	call   101c90 <tsc_init>
    KERN_INFO("[BSP KERN] TSC initialized\n");
  100b0f:	8d 83 7b 82 ff ff    	lea    -0x7d85(%ebx),%eax
  100b15:	89 04 24             	mov    %eax,(%esp)
  100b18:	e8 a3 34 00 00       	call   103fc0 <debug_info>

    intr_init();
  100b1d:	e8 ce 06 00 00       	call   1011f0 <intr_init>
    KERN_INFO("[BSP KERN] INTR initialized\n");
  100b22:	8d 83 97 82 ff ff    	lea    -0x7d69(%ebx),%eax
  100b28:	89 04 24             	mov    %eax,(%esp)
  100b2b:	e8 90 34 00 00       	call   103fc0 <debug_info>

    trap_init(0);
  100b30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100b37:	e8 c4 79 00 00       	call   108500 <trap_init>

    pmmap_init(mbi_addr);
  100b3c:	89 34 24             	mov    %esi,(%esp)
  100b3f:	e8 3c 01 00 00       	call   100c80 <pmmap_init>
}
  100b44:	83 c4 14             	add    $0x14,%esp
  100b47:	5b                   	pop    %ebx
  100b48:	5e                   	pop    %esi
  100b49:	c3                   	ret    
  100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100b50 <devinit_ap>:

void devinit_ap(void)
{
  100b50:	56                   	push   %esi
  100b51:	53                   	push   %ebx
  100b52:	e8 32 f8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  100b57:	81 c3 a9 04 01 00    	add    $0x104a9,%ebx
  100b5d:	83 ec 04             	sub    $0x4,%esp
    /* Figure out the current (booting) kernel stack) */
    struct kstack *ks = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  100b60:	e8 cb 40 00 00       	call   104c30 <read_esp>

    KERN_ASSERT(ks != NULL);
  100b65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  100b6a:	89 c6                	mov    %eax,%esi
  100b6c:	74 6a                	je     100bd8 <devinit_ap+0x88>
    KERN_ASSERT(1 <= ks->cpu_idx && ks->cpu_idx < 8);
  100b6e:	8b 86 1c 01 00 00    	mov    0x11c(%esi),%eax
  100b74:	8d 50 ff             	lea    -0x1(%eax),%edx
  100b77:	83 fa 06             	cmp    $0x6,%edx
  100b7a:	0f 87 89 00 00 00    	ja     100c09 <devinit_ap+0xb9>

    /* kernel stack for this cpu initialized */
    seg_init(ks->cpu_idx);
  100b80:	83 ec 0c             	sub    $0xc,%esp
  100b83:	50                   	push   %eax
  100b84:	e8 97 3d 00 00       	call   104920 <seg_init>

    pcpu_init();
  100b89:	e8 42 54 00 00       	call   105fd0 <pcpu_init>
    KERN_INFO("[AP%d KERN] PCPU initialized\n", ks->cpu_idx);
  100b8e:	58                   	pop    %eax
  100b8f:	8d 83 ef 82 ff ff    	lea    -0x7d11(%ebx),%eax
  100b95:	5a                   	pop    %edx
  100b96:	ff b6 1c 01 00 00    	push   0x11c(%esi)
  100b9c:	50                   	push   %eax
  100b9d:	e8 1e 34 00 00       	call   103fc0 <debug_info>

    intr_init();
  100ba2:	e8 49 06 00 00       	call   1011f0 <intr_init>
    KERN_INFO("[AP%d KERN] INTR initialized.\n", ks->cpu_idx);
  100ba7:	59                   	pop    %ecx
  100ba8:	58                   	pop    %eax
  100ba9:	8d 83 58 83 ff ff    	lea    -0x7ca8(%ebx),%eax
  100baf:	ff b6 1c 01 00 00    	push   0x11c(%esi)
  100bb5:	50                   	push   %eax
  100bb6:	e8 05 34 00 00       	call   103fc0 <debug_info>

    trap_init(ks->cpu_idx);
  100bbb:	58                   	pop    %eax
  100bbc:	ff b6 1c 01 00 00    	push   0x11c(%esi)
  100bc2:	e8 39 79 00 00       	call   108500 <trap_init>

    paging_init_ap();
  100bc7:	e8 e4 64 00 00       	call   1070b0 <paging_init_ap>
}
  100bcc:	83 c4 14             	add    $0x14,%esp
  100bcf:	5b                   	pop    %ebx
  100bd0:	5e                   	pop    %esi
  100bd1:	c3                   	ret    
  100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(ks != NULL);
  100bd8:	8d 83 b4 82 ff ff    	lea    -0x7d4c(%ebx),%eax
  100bde:	50                   	push   %eax
  100bdf:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  100be5:	50                   	push   %eax
  100be6:	8d 83 dc 82 ff ff    	lea    -0x7d24(%ebx),%eax
  100bec:	6a 31                	push   $0x31
  100bee:	50                   	push   %eax
  100bef:	e8 3c 34 00 00       	call   104030 <debug_panic>
    KERN_ASSERT(1 <= ks->cpu_idx && ks->cpu_idx < 8);
  100bf4:	8b 86 1c 01 00 00    	mov    0x11c(%esi),%eax
    KERN_ASSERT(ks != NULL);
  100bfa:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(1 <= ks->cpu_idx && ks->cpu_idx < 8);
  100bfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  100c00:	83 fa 06             	cmp    $0x6,%edx
  100c03:	0f 86 77 ff ff ff    	jbe    100b80 <devinit_ap+0x30>
  100c09:	8d 83 34 83 ff ff    	lea    -0x7ccc(%ebx),%eax
  100c0f:	50                   	push   %eax
  100c10:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  100c16:	50                   	push   %eax
  100c17:	8d 83 dc 82 ff ff    	lea    -0x7d24(%ebx),%eax
  100c1d:	6a 32                	push   $0x32
  100c1f:	50                   	push   %eax
  100c20:	e8 0b 34 00 00       	call   104030 <debug_panic>
    seg_init(ks->cpu_idx);
  100c25:	8b 86 1c 01 00 00    	mov    0x11c(%esi),%eax
  100c2b:	83 c4 10             	add    $0x10,%esp
  100c2e:	e9 4d ff ff ff       	jmp    100b80 <devinit_ap+0x30>
  100c33:	66 90                	xchg   %ax,%ax
  100c35:	66 90                	xchg   %ax,%ax
  100c37:	66 90                	xchg   %ax,%ax
  100c39:	66 90                	xchg   %ax,%ax
  100c3b:	66 90                	xchg   %ax,%ax
  100c3d:	66 90                	xchg   %ax,%ax
  100c3f:	90                   	nop

00100c40 <pmmap_alloc_slot>:
    if (unlikely(pmmap_slots_next_free == 128))
  100c40:	e8 40 f7 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  100c45:	81 c2 bb 03 01 00    	add    $0x103bb,%edx
  100c4b:	8b 82 7c 76 02 00    	mov    0x2767c(%edx),%eax
  100c51:	3d 80 00 00 00       	cmp    $0x80,%eax
  100c56:	74 18                	je     100c70 <pmmap_alloc_slot+0x30>
    return &pmmap_slots[pmmap_slots_next_free++];
  100c58:	8d 48 01             	lea    0x1(%eax),%ecx
  100c5b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  100c5e:	89 8a 7c 76 02 00    	mov    %ecx,0x2767c(%edx)
  100c64:	8d 84 82 80 76 02 00 	lea    0x27680(%edx,%eax,4),%eax
  100c6b:	c3                   	ret    
  100c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return NULL;
  100c70:	31 c0                	xor    %eax,%eax
}
  100c72:	c3                   	ret    
  100c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100c80 <pmmap_init>:
{
  100c80:	55                   	push   %ebp
  100c81:	e8 63 05 00 00       	call   1011e9 <__x86.get_pc_thunk.bp>
  100c86:	81 c5 7a 03 01 00    	add    $0x1037a,%ebp
  100c8c:	57                   	push   %edi
  100c8d:	56                   	push   %esi
  100c8e:	53                   	push   %ebx
  100c8f:	83 ec 48             	sub    $0x48,%esp
    KERN_INFO("\n");
  100c92:	8d 85 cd 96 ff ff    	lea    -0x6933(%ebp),%eax
{
  100c98:	8b 74 24 5c          	mov    0x5c(%esp),%esi
    KERN_INFO("\n");
  100c9c:	89 eb                	mov    %ebp,%ebx
  100c9e:	50                   	push   %eax
  100c9f:	e8 1c 33 00 00       	call   103fc0 <debug_info>
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100ca4:	8b 5e 2c             	mov    0x2c(%esi),%ebx
    mboot_mmap_t *p = (mboot_mmap_t *) mbi->mmap_addr;
  100ca7:	8b 46 30             	mov    0x30(%esi),%eax
    SLIST_INIT(&pmmap_list);
  100caa:	c7 85 78 76 02 00 00 	movl   $0x0,0x27678(%ebp)
  100cb1:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_USABLE]);
  100cb4:	c7 85 68 76 02 00 00 	movl   $0x0,0x27668(%ebp)
  100cbb:	00 00 00 
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100cbe:	89 5c 24 24          	mov    %ebx,0x24(%esp)
  100cc2:	83 c4 10             	add    $0x10,%esp
    SLIST_INIT(&pmmap_sublist[PMMAP_RESV]);
  100cc5:	c7 85 6c 76 02 00 00 	movl   $0x0,0x2766c(%ebp)
  100ccc:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_ACPI]);
  100ccf:	c7 85 70 76 02 00 00 	movl   $0x0,0x27670(%ebp)
  100cd6:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);
  100cd9:	c7 85 74 76 02 00 00 	movl   $0x0,0x27674(%ebp)
  100ce0:	00 00 00 
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100ce3:	85 db                	test   %ebx,%ebx
  100ce5:	0f 84 9f 02 00 00    	je     100f8a <pmmap_init+0x30a>
  100ceb:	ba e8 ff ff ff       	mov    $0xffffffe8,%edx
  100cf0:	31 ff                	xor    %edi,%edi
  100cf2:	c6 44 24 1f 00       	movb   $0x0,0x1f(%esp)
  100cf7:	8d 58 18             	lea    0x18(%eax),%ebx
  100cfa:	29 c2                	sub    %eax,%edx
  100cfc:	89 7c 24 10          	mov    %edi,0x10(%esp)
  100d00:	8b b5 7c 76 02 00    	mov    0x2767c(%ebp),%esi
  100d06:	c6 44 24 04 00       	movb   $0x0,0x4(%esp)
  100d0b:	89 54 24 18          	mov    %edx,0x18(%esp)
  100d0f:	90                   	nop
        uintptr_t start, end;
        uint32_t type;

        if (p->base_addr_high != 0)  /* ignore address above 4G */
  100d10:	8b 78 08             	mov    0x8(%eax),%edi
  100d13:	85 ff                	test   %edi,%edi
  100d15:	0f 85 b8 00 00 00    	jne    100dd3 <pmmap_init+0x153>
            goto next;
        else
            start = p->base_addr_low;

        if (p->length_high != 0 || p->length_low >= 0xffffffff - start)
  100d1b:	8b 48 10             	mov    0x10(%eax),%ecx
            start = p->base_addr_low;
  100d1e:	8b 50 04             	mov    0x4(%eax),%edx
            end = 0xffffffff;
  100d21:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
        if (p->length_high != 0 || p->length_low >= 0xffffffff - start)
  100d28:	85 c9                	test   %ecx,%ecx
  100d2a:	75 13                	jne    100d3f <pmmap_init+0xbf>
        else
            end = start + p->length_low;
  100d2c:	8b 78 0c             	mov    0xc(%eax),%edi
  100d2f:	89 d1                	mov    %edx,%ecx
  100d31:	f7 d1                	not    %ecx
  100d33:	01 d7                	add    %edx,%edi
  100d35:	39 48 0c             	cmp    %ecx,0xc(%eax)
  100d38:	0f 43 3c 24          	cmovae (%esp),%edi
  100d3c:	89 3c 24             	mov    %edi,(%esp)

        type = p->type;
  100d3f:	8b 78 14             	mov    0x14(%eax),%edi
    if (unlikely(pmmap_slots_next_free == 128))
  100d42:	81 fe 80 00 00 00    	cmp    $0x80,%esi
  100d48:	0f 84 b2 f2 ff ff    	je     100000 <pmmap_init.cold>
    return &pmmap_slots[pmmap_slots_next_free++];
  100d4e:	8d 46 01             	lea    0x1(%esi),%eax
  100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d55:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  100d58:	c1 e0 02             	shl    $0x2,%eax
  100d5b:	8d 8c 05 80 76 02 00 	lea    0x27680(%ebp,%eax,1),%ecx
    free_slot->end = end;
  100d62:	8d 84 05 80 76 02 00 	lea    0x27680(%ebp,%eax,1),%eax
    return &pmmap_slots[pmmap_slots_next_free++];
  100d69:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    free_slot->start = start;
  100d6d:	89 11                	mov    %edx,(%ecx)
    free_slot->end = end;
  100d6f:	8d 0d 80 76 02 00    	lea    0x27680,%ecx
  100d75:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100d79:	8b 0c 24             	mov    (%esp),%ecx
    free_slot->type = type;
  100d7c:	89 78 08             	mov    %edi,0x8(%eax)
    free_slot->end = end;
  100d7f:	89 48 04             	mov    %ecx,0x4(%eax)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d82:	8b 44 24 10          	mov    0x10(%esp),%eax
  100d86:	85 c0                	test   %eax,%eax
  100d88:	0f 84 22 02 00 00    	je     100fb0 <pmmap_init+0x330>
    last_slot = NULL;
  100d8e:	31 ff                	xor    %edi,%edi
  100d90:	eb 11                	jmp    100da3 <pmmap_init+0x123>
  100d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d98:	8b 48 0c             	mov    0xc(%eax),%ecx
  100d9b:	89 c7                	mov    %eax,%edi
  100d9d:	85 c9                	test   %ecx,%ecx
  100d9f:	74 13                	je     100db4 <pmmap_init+0x134>
  100da1:	89 c8                	mov    %ecx,%eax
        if (start < slot->start)
  100da3:	3b 10                	cmp    (%eax),%edx
  100da5:	73 f1                	jae    100d98 <pmmap_init+0x118>
    if (last_slot == NULL) {
  100da7:	85 ff                	test   %edi,%edi
  100da9:	0f 84 01 02 00 00    	je     100fb0 <pmmap_init+0x330>
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100daf:	8b 4f 0c             	mov    0xc(%edi),%ecx
  100db2:	89 f8                	mov    %edi,%eax
  100db4:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  100db7:	8b 74 24 0c          	mov    0xc(%esp),%esi
  100dbb:	8d 54 95 00          	lea    0x0(%ebp,%edx,4),%edx
  100dbf:	89 4c 16 0c          	mov    %ecx,0xc(%esi,%edx,1)
  100dc3:	8b 74 24 08          	mov    0x8(%esp),%esi
  100dc7:	89 70 0c             	mov    %esi,0xc(%eax)
    return &pmmap_slots[pmmap_slots_next_free++];
  100dca:	8b 74 24 04          	mov    0x4(%esp),%esi
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100dce:	c6 44 24 04 01       	movb   $0x1,0x4(%esp)
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100dd3:	8b 7c 24 18          	mov    0x18(%esp),%edi

        pmmap_insert(start, end, type);

      next:
        p = (mboot_mmap_t *) (((uint32_t) p) + sizeof(mboot_mmap_t) /* p->size */);
  100dd7:	89 d8                	mov    %ebx,%eax
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100dd9:	83 c3 18             	add    $0x18,%ebx
  100ddc:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  100ddf:	39 54 24 14          	cmp    %edx,0x14(%esp)
  100de3:	0f 87 27 ff ff ff    	ja     100d10 <pmmap_init+0x90>
  100de9:	80 7c 24 1f 00       	cmpb   $0x0,0x1f(%esp)
  100dee:	8b 7c 24 10          	mov    0x10(%esp),%edi
  100df2:	0f 84 48 02 00 00    	je     101040 <pmmap_init+0x3c0>
  100df8:	80 7c 24 04 00       	cmpb   $0x0,0x4(%esp)
  100dfd:	89 bd 78 76 02 00    	mov    %edi,0x27678(%ebp)
  100e03:	0f 85 44 02 00 00    	jne    10104d <pmmap_init+0x3cd>
    struct pmmap *last_slot[4] = { NULL, NULL, NULL, NULL };
  100e09:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  100e10:	00 
  100e11:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
  100e18:	00 
  100e19:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  100e20:	00 
  100e21:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  100e28:	00 
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e29:	85 ff                	test   %edi,%edi
  100e2b:	0f 84 59 01 00 00    	je     100f8a <pmmap_init+0x30a>
        if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  100e31:	8b 47 0c             	mov    0xc(%edi),%eax
  100e34:	85 c0                	test   %eax,%eax
  100e36:	74 2a                	je     100e62 <pmmap_init+0x1e2>
  100e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e3f:	90                   	nop
        if (slot->start <= next_slot->start &&
  100e40:	8b 10                	mov    (%eax),%edx
  100e42:	39 17                	cmp    %edx,(%edi)
  100e44:	77 13                	ja     100e59 <pmmap_init+0x1d9>
            slot->end >= next_slot->start &&
  100e46:	8b 4f 04             	mov    0x4(%edi),%ecx
        if (slot->start <= next_slot->start &&
  100e49:	39 ca                	cmp    %ecx,%edx
  100e4b:	77 0c                	ja     100e59 <pmmap_init+0x1d9>
            slot->end >= next_slot->start &&
  100e4d:	8b 58 08             	mov    0x8(%eax),%ebx
  100e50:	39 5f 08             	cmp    %ebx,0x8(%edi)
  100e53:	0f 84 b2 01 00 00    	je     10100b <pmmap_init+0x38b>
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100e59:	89 c7                	mov    %eax,%edi
        if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  100e5b:	8b 47 0c             	mov    0xc(%edi),%eax
  100e5e:	85 c0                	test   %eax,%eax
  100e60:	75 de                	jne    100e40 <pmmap_init+0x1c0>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e62:	8b b5 78 76 02 00    	mov    0x27678(%ebp),%esi
  100e68:	85 f6                	test   %esi,%esi
  100e6a:	0f 84 1a 01 00 00    	je     100f8a <pmmap_init+0x30a>
            SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot, type_next);
  100e70:	8d bd 68 76 02 00    	lea    0x27668(%ebp),%edi
  100e76:	eb 1c                	jmp    100e94 <pmmap_init+0x214>
  100e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e7f:	90                   	nop
            SLIST_INSERT_AFTER(last_slot[sublist_nr], slot, type_next);
  100e80:	8b 4a 10             	mov    0x10(%edx),%ecx
        last_slot[sublist_nr] = slot;
  100e83:	89 74 84 20          	mov    %esi,0x20(%esp,%eax,4)
            SLIST_INSERT_AFTER(last_slot[sublist_nr], slot, type_next);
  100e87:	89 4e 10             	mov    %ecx,0x10(%esi)
  100e8a:	89 72 10             	mov    %esi,0x10(%edx)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e8d:	8b 76 0c             	mov    0xc(%esi),%esi
  100e90:	85 f6                	test   %esi,%esi
  100e92:	74 35                	je     100ec9 <pmmap_init+0x249>
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  100e94:	8b 56 08             	mov    0x8(%esi),%edx
  100e97:	31 c0                	xor    %eax,%eax
  100e99:	83 fa 01             	cmp    $0x1,%edx
  100e9c:	74 0f                	je     100ead <pmmap_init+0x22d>
  100e9e:	8d 42 fe             	lea    -0x2(%edx),%eax
  100ea1:	83 f8 02             	cmp    $0x2,%eax
  100ea4:	0f 87 36 01 00 00    	ja     100fe0 <pmmap_init+0x360>
  100eaa:	8d 42 ff             	lea    -0x1(%edx),%eax
        if (last_slot[sublist_nr] != NULL)
  100ead:	8b 54 84 20          	mov    0x20(%esp,%eax,4),%edx
  100eb1:	85 d2                	test   %edx,%edx
  100eb3:	75 cb                	jne    100e80 <pmmap_init+0x200>
            SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot, type_next);
  100eb5:	8b 14 87             	mov    (%edi,%eax,4),%edx
        last_slot[sublist_nr] = slot;
  100eb8:	89 74 84 20          	mov    %esi,0x20(%esp,%eax,4)
            SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot, type_next);
  100ebc:	89 34 87             	mov    %esi,(%edi,%eax,4)
  100ebf:	89 56 10             	mov    %edx,0x10(%esi)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ec2:	8b 76 0c             	mov    0xc(%esi),%esi
  100ec5:	85 f6                	test   %esi,%esi
  100ec7:	75 cb                	jne    100e94 <pmmap_init+0x214>
    if (last_slot[PMMAP_USABLE] != NULL)
  100ec9:	8b 44 24 20          	mov    0x20(%esp),%eax
  100ecd:	85 c0                	test   %eax,%eax
  100ecf:	74 09                	je     100eda <pmmap_init+0x25a>
        max_usable_memory = last_slot[PMMAP_USABLE]->end;
  100ed1:	8b 40 04             	mov    0x4(%eax),%eax
  100ed4:	89 85 64 76 02 00    	mov    %eax,0x27664(%ebp)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100eda:	8b bd 78 76 02 00    	mov    0x27678(%ebp),%edi
  100ee0:	85 ff                	test   %edi,%edi
  100ee2:	0f 84 a2 00 00 00    	je     100f8a <pmmap_init+0x30a>
        KERN_INFO("BIOS-e820: 0x%08x - 0x%08x (%s)\n",
  100ee8:	8d 85 77 83 ff ff    	lea    -0x7c89(%ebp),%eax
  100eee:	8d b5 e4 83 ff ff    	lea    -0x7c1c(%ebp),%esi
  100ef4:	89 04 24             	mov    %eax,(%esp)
  100ef7:	8d 85 8f 83 ff ff    	lea    -0x7c71(%ebp),%eax
  100efd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100f08:	8b 57 08             	mov    0x8(%edi),%edx
  100f0b:	8b 04 24             	mov    (%esp),%eax
  100f0e:	83 fa 01             	cmp    $0x1,%edx
  100f11:	74 26                	je     100f39 <pmmap_init+0x2b9>
  100f13:	8b 44 24 04          	mov    0x4(%esp),%eax
  100f17:	83 fa 03             	cmp    $0x3,%edx
  100f1a:	74 1d                	je     100f39 <pmmap_init+0x2b9>
  100f1c:	8d 85 99 83 ff ff    	lea    -0x7c67(%ebp),%eax
  100f22:	83 fa 04             	cmp    $0x4,%edx
  100f25:	74 12                	je     100f39 <pmmap_init+0x2b9>
  100f27:	83 fa 02             	cmp    $0x2,%edx
  100f2a:	8d 85 7e 83 ff ff    	lea    -0x7c82(%ebp),%eax
  100f30:	8d 95 86 83 ff ff    	lea    -0x7c7a(%ebp),%edx
  100f36:	0f 44 c2             	cmove  %edx,%eax
  100f39:	8b 0f                	mov    (%edi),%ecx
  100f3b:	8b 57 04             	mov    0x4(%edi),%edx
  100f3e:	39 d1                	cmp    %edx,%ecx
  100f40:	74 0a                	je     100f4c <pmmap_init+0x2cc>
  100f42:	31 db                	xor    %ebx,%ebx
  100f44:	83 fa ff             	cmp    $0xffffffff,%edx
  100f47:	0f 95 c3             	setne  %bl
  100f4a:	29 da                	sub    %ebx,%edx
  100f4c:	50                   	push   %eax
  100f4d:	89 eb                	mov    %ebp,%ebx
  100f4f:	52                   	push   %edx
  100f50:	51                   	push   %ecx
  100f51:	56                   	push   %esi
  100f52:	e8 69 30 00 00       	call   103fc0 <debug_info>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100f57:	8b 7f 0c             	mov    0xc(%edi),%edi
  100f5a:	83 c4 10             	add    $0x10,%esp
  100f5d:	85 ff                	test   %edi,%edi
  100f5f:	75 a7                	jne    100f08 <pmmap_init+0x288>
    pmmap_merge();
    pmmap_dump();

    /* count the number of pmmap entries */
    struct pmmap *slot;
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100f61:	8b 95 78 76 02 00    	mov    0x27678(%ebp),%edx
  100f67:	85 d2                	test   %edx,%edx
  100f69:	74 1f                	je     100f8a <pmmap_init+0x30a>
  100f6b:	8b 85 60 76 02 00    	mov    0x27660(%ebp),%eax
  100f71:	83 c0 01             	add    $0x1,%eax
  100f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100f78:	8b 52 0c             	mov    0xc(%edx),%edx
        pmmap_nentries++;
  100f7b:	89 c1                	mov    %eax,%ecx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100f7d:	83 c0 01             	add    $0x1,%eax
  100f80:	85 d2                	test   %edx,%edx
  100f82:	75 f4                	jne    100f78 <pmmap_init+0x2f8>
  100f84:	89 8d 60 76 02 00    	mov    %ecx,0x27660(%ebp)
    }

    /* Calculate the maximum page number */
    mem_npages = rounddown(max_usable_memory, PAGESIZE) / PAGESIZE;
  100f8a:	83 ec 08             	sub    $0x8,%esp
  100f8d:	89 eb                	mov    %ebp,%ebx
  100f8f:	68 00 10 00 00       	push   $0x1000
  100f94:	ff b5 64 76 02 00    	push   0x27664(%ebp)
  100f9a:	e8 51 3c 00 00       	call   104bf0 <rounddown>
}
  100f9f:	83 c4 4c             	add    $0x4c,%esp
  100fa2:	5b                   	pop    %ebx
  100fa3:	5e                   	pop    %esi
  100fa4:	5f                   	pop    %edi
  100fa5:	5d                   	pop    %ebp
  100fa6:	c3                   	ret    
  100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100fae:	66 90                	xchg   %ax,%ax
        SLIST_INSERT_HEAD(&pmmap_list, free_slot, next);
  100fb0:	8b 7c 24 10          	mov    0x10(%esp),%edi
  100fb4:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  100fb7:	8b 74 24 0c          	mov    0xc(%esp),%esi
  100fbb:	c6 44 24 1f 01       	movb   $0x1,0x1f(%esp)
  100fc0:	8d 44 85 00          	lea    0x0(%ebp,%eax,4),%eax
  100fc4:	89 7c 06 0c          	mov    %edi,0xc(%esi,%eax,1)
  100fc8:	8b 44 24 08          	mov    0x8(%esp),%eax
    return &pmmap_slots[pmmap_slots_next_free++];
  100fcc:	8b 74 24 04          	mov    0x4(%esp),%esi
  100fd0:	c6 44 24 04 01       	movb   $0x1,0x4(%esp)
        SLIST_INSERT_HEAD(&pmmap_list, free_slot, next);
  100fd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  100fd9:	e9 f5 fd ff ff       	jmp    100dd3 <pmmap_init+0x153>
  100fde:	66 90                	xchg   %ax,%ax
        KERN_ASSERT(sublist_nr != -1);
  100fe0:	8d 85 d0 83 ff ff    	lea    -0x7c30(%ebp),%eax
  100fe6:	89 eb                	mov    %ebp,%ebx
  100fe8:	50                   	push   %eax
  100fe9:	8d 85 bf 82 ff ff    	lea    -0x7d41(%ebp),%eax
  100fef:	50                   	push   %eax
  100ff0:	8d 85 bf 83 ff ff    	lea    -0x7c41(%ebp),%eax
  100ff6:	6a 6b                	push   $0x6b
  100ff8:	50                   	push   %eax
  100ff9:	e8 32 30 00 00       	call   104030 <debug_panic>
  100ffe:	83 c4 10             	add    $0x10,%esp
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  101001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101006:	e9 a2 fe ff ff       	jmp    100ead <pmmap_init+0x22d>
            slot->end = max(slot->end, next_slot->end);
  10100b:	83 ec 08             	sub    $0x8,%esp
  10100e:	ff 70 04             	push   0x4(%eax)
  101011:	89 eb                	mov    %ebp,%ebx
  101013:	51                   	push   %ecx
  101014:	e8 b7 3b 00 00       	call   104bd0 <max>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  101019:	83 c4 10             	add    $0x10,%esp
            slot->end = max(slot->end, next_slot->end);
  10101c:	89 47 04             	mov    %eax,0x4(%edi)
            SLIST_REMOVE_AFTER(slot, next);
  10101f:	8b 47 0c             	mov    0xc(%edi),%eax
  101022:	8b 40 0c             	mov    0xc(%eax),%eax
  101025:	89 47 0c             	mov    %eax,0xc(%edi)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  101028:	85 c0                	test   %eax,%eax
  10102a:	0f 84 32 fe ff ff    	je     100e62 <pmmap_init+0x1e2>
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  101030:	89 c7                	mov    %eax,%edi
  101032:	e9 24 fe ff ff       	jmp    100e5b <pmmap_init+0x1db>
  101037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10103e:	66 90                	xchg   %ax,%ax
  101040:	31 ff                	xor    %edi,%edi
  101042:	80 7c 24 04 00       	cmpb   $0x0,0x4(%esp)
  101047:	0f 84 3d ff ff ff    	je     100f8a <pmmap_init+0x30a>
  10104d:	89 b5 7c 76 02 00    	mov    %esi,0x2767c(%ebp)
  101053:	e9 b1 fd ff ff       	jmp    100e09 <pmmap_init+0x189>
  101058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10105f:	90                   	nop

00101060 <get_size>:

int get_size(void)
{
    return pmmap_nentries;
  101060:	e8 1c f3 ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  101065:	05 9b ff 00 00       	add    $0xff9b,%eax
  10106a:	8b 80 60 76 02 00    	mov    0x27660(%eax),%eax
}
  101070:	c3                   	ret    
  101071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10107f:	90                   	nop

00101080 <get_mms>:

uint32_t get_mms(int idx)
{
  101080:	53                   	push   %ebx
  101081:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  101085:	e8 ff f2 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10108a:	81 c3 76 ff 00 00    	add    $0xff76,%ebx
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  101090:	8b 83 78 76 02 00    	mov    0x27678(%ebx),%eax
  101096:	85 c0                	test   %eax,%eax
  101098:	74 1c                	je     1010b6 <get_mms+0x36>
    int i = 0;
  10109a:	31 d2                	xor    %edx,%edx
        if (i == idx)
  10109c:	85 c9                	test   %ecx,%ecx
  10109e:	75 0c                	jne    1010ac <get_mms+0x2c>
  1010a0:	eb 1e                	jmp    1010c0 <get_mms+0x40>
  1010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1010a8:	39 d1                	cmp    %edx,%ecx
  1010aa:	74 14                	je     1010c0 <get_mms+0x40>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  1010ac:	8b 40 0c             	mov    0xc(%eax),%eax
            break;
        i++;
  1010af:	83 c2 01             	add    $0x1,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  1010b2:	85 c0                	test   %eax,%eax
  1010b4:	75 f2                	jne    1010a8 <get_mms+0x28>
    }

    if (slot == NULL || i == pmmap_nentries)
        return 0;
  1010b6:	31 c9                	xor    %ecx,%ecx

    return slot->start;
}
  1010b8:	89 c8                	mov    %ecx,%eax
  1010ba:	5b                   	pop    %ebx
  1010bb:	c3                   	ret    
  1010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return 0;
  1010c0:	31 c9                	xor    %ecx,%ecx
    if (slot == NULL || i == pmmap_nentries)
  1010c2:	39 93 60 76 02 00    	cmp    %edx,0x27660(%ebx)
  1010c8:	74 ee                	je     1010b8 <get_mms+0x38>
    return slot->start;
  1010ca:	8b 08                	mov    (%eax),%ecx
}
  1010cc:	5b                   	pop    %ebx
  1010cd:	89 c8                	mov    %ecx,%eax
  1010cf:	c3                   	ret    

001010d0 <get_mml>:

uint32_t get_mml(int idx)
{
  1010d0:	53                   	push   %ebx
  1010d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  1010d5:	e8 af f2 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1010da:	81 c3 26 ff 00 00    	add    $0xff26,%ebx
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  1010e0:	8b 93 78 76 02 00    	mov    0x27678(%ebx),%edx
  1010e6:	85 d2                	test   %edx,%edx
  1010e8:	74 1c                	je     101106 <get_mml+0x36>
    int i = 0;
  1010ea:	31 c9                	xor    %ecx,%ecx
        if (i == idx)
  1010ec:	85 c0                	test   %eax,%eax
  1010ee:	75 0c                	jne    1010fc <get_mml+0x2c>
  1010f0:	eb 1e                	jmp    101110 <get_mml+0x40>
  1010f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1010f8:	39 c8                	cmp    %ecx,%eax
  1010fa:	74 14                	je     101110 <get_mml+0x40>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  1010fc:	8b 52 0c             	mov    0xc(%edx),%edx
            break;
        i++;
  1010ff:	83 c1 01             	add    $0x1,%ecx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  101102:	85 d2                	test   %edx,%edx
  101104:	75 f2                	jne    1010f8 <get_mml+0x28>
    }

    if (slot == NULL || i == pmmap_nentries)
        return 0;
  101106:	31 c0                	xor    %eax,%eax

    return slot->end - slot->start;
}
  101108:	5b                   	pop    %ebx
  101109:	c3                   	ret    
  10110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return 0;
  101110:	31 c0                	xor    %eax,%eax
    if (slot == NULL || i == pmmap_nentries)
  101112:	39 8b 60 76 02 00    	cmp    %ecx,0x27660(%ebx)
  101118:	74 ee                	je     101108 <get_mml+0x38>
    return slot->end - slot->start;
  10111a:	8b 42 04             	mov    0x4(%edx),%eax
}
  10111d:	5b                   	pop    %ebx
    return slot->end - slot->start;
  10111e:	2b 02                	sub    (%edx),%eax
}
  101120:	c3                   	ret    
  101121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10112f:	90                   	nop

00101130 <is_usable>:

int is_usable(int idx)
{
  101130:	53                   	push   %ebx
  101131:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  101135:	e8 4f f2 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10113a:	81 c3 c6 fe 00 00    	add    $0xfec6,%ebx
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  101140:	8b 83 78 76 02 00    	mov    0x27678(%ebx),%eax
  101146:	85 c0                	test   %eax,%eax
  101148:	74 1c                	je     101166 <is_usable+0x36>
    int i = 0;
  10114a:	31 d2                	xor    %edx,%edx
        if (i == idx)
  10114c:	85 c9                	test   %ecx,%ecx
  10114e:	75 0c                	jne    10115c <is_usable+0x2c>
  101150:	eb 1e                	jmp    101170 <is_usable+0x40>
  101152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101158:	39 d1                	cmp    %edx,%ecx
  10115a:	74 14                	je     101170 <is_usable+0x40>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  10115c:	8b 40 0c             	mov    0xc(%eax),%eax
            break;
        i++;
  10115f:	83 c2 01             	add    $0x1,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  101162:	85 c0                	test   %eax,%eax
  101164:	75 f2                	jne    101158 <is_usable+0x28>
    }

    if (slot == NULL || i == pmmap_nentries)
        return 0;
  101166:	31 c9                	xor    %ecx,%ecx

    return slot->type == MEM_RAM;
}
  101168:	89 c8                	mov    %ecx,%eax
  10116a:	5b                   	pop    %ebx
  10116b:	c3                   	ret    
  10116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return 0;
  101170:	31 c9                	xor    %ecx,%ecx
    if (slot == NULL || i == pmmap_nentries)
  101172:	39 93 60 76 02 00    	cmp    %edx,0x27660(%ebx)
  101178:	74 ee                	je     101168 <is_usable+0x38>
    return slot->type == MEM_RAM;
  10117a:	31 c9                	xor    %ecx,%ecx
  10117c:	83 78 08 01          	cmpl   $0x1,0x8(%eax)
}
  101180:	5b                   	pop    %ebx
    return slot->type == MEM_RAM;
  101181:	0f 94 c1             	sete   %cl
}
  101184:	89 c8                	mov    %ecx,%eax
  101186:	c3                   	ret    
  101187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10118e:	66 90                	xchg   %ax,%ax

00101190 <set_cr3>:

void set_cr3(unsigned int **pdir)
{
  101190:	53                   	push   %ebx
  101191:	e8 f3 f1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101196:	81 c3 6a fe 00 00    	add    $0xfe6a,%ebx
  10119c:	83 ec 14             	sub    $0x14,%esp
    lcr3((uint32_t) pdir);
  10119f:	ff 74 24 1c          	push   0x1c(%esp)
  1011a3:	e8 78 3c 00 00       	call   104e20 <lcr3>
}
  1011a8:	83 c4 18             	add    $0x18,%esp
  1011ab:	5b                   	pop    %ebx
  1011ac:	c3                   	ret    
  1011ad:	8d 76 00             	lea    0x0(%esi),%esi

001011b0 <enable_paging>:

void enable_paging(void)
{
  1011b0:	53                   	push   %ebx
  1011b1:	e8 d3 f1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1011b6:	81 c3 4a fe 00 00    	add    $0xfe4a,%ebx
  1011bc:	83 ec 08             	sub    $0x8,%esp
    /* enable global pages (Sec 4.10.2.4, Intel ASDM Vol3) */
    uint32_t cr4 = rcr4();
  1011bf:	e8 7c 3c 00 00       	call   104e40 <rcr4>
    cr4 |= CR4_PGE;
    lcr4(cr4);
  1011c4:	83 ec 0c             	sub    $0xc,%esp
    cr4 |= CR4_PGE;
  1011c7:	0c 80                	or     $0x80,%al
    lcr4(cr4);
  1011c9:	50                   	push   %eax
  1011ca:	e8 61 3c 00 00       	call   104e30 <lcr4>

    /* turn on paging */
    uint32_t cr0 = rcr0();
  1011cf:	e8 2c 3c 00 00       	call   104e00 <rcr0>
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_MP;
    cr0 &= ~(CR0_EM | CR0_TS);
  1011d4:	83 e0 f3             	and    $0xfffffff3,%eax
  1011d7:	0d 23 00 05 80       	or     $0x80050023,%eax
    lcr0(cr0);
  1011dc:	89 04 24             	mov    %eax,(%esp)
  1011df:	e8 0c 3c 00 00       	call   104df0 <lcr0>
}
  1011e4:	83 c4 18             	add    $0x18,%esp
  1011e7:	5b                   	pop    %ebx
  1011e8:	c3                   	ret    

001011e9 <__x86.get_pc_thunk.bp>:
  1011e9:	8b 2c 24             	mov    (%esp),%ebp
  1011ec:	c3                   	ret    
  1011ed:	66 90                	xchg   %ax,%ax
  1011ef:	90                   	nop

001011f0 <intr_init>:
{
    asm volatile ("lidt %0" :: "m" (idt_pd));
}

void intr_init(void)
{
  1011f0:	55                   	push   %ebp
  1011f1:	57                   	push   %edi
  1011f2:	56                   	push   %esi
  1011f3:	53                   	push   %ebx
  1011f4:	e8 90 f1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1011f9:	81 c3 07 fe 00 00    	add    $0xfe07,%ebx
  1011ff:	83 ec 38             	sub    $0x38,%esp
    uint32_t dummy, edx;

    cpuid(0x00000001, &dummy, &dummy, &dummy, &edx);
  101202:	8d 44 24 28          	lea    0x28(%esp),%eax
  101206:	50                   	push   %eax
  101207:	8d 44 24 28          	lea    0x28(%esp),%eax
  10120b:	50                   	push   %eax
  10120c:	50                   	push   %eax
  10120d:	50                   	push   %eax
  10120e:	6a 01                	push   $0x1
  101210:	e8 0b 3b 00 00       	call   104d20 <cpuid>
    using_apic = (edx & CPUID_FEATURE_APIC) ? TRUE : FALSE;
  101215:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    KERN_ASSERT(using_apic == TRUE);
  101219:	83 c4 20             	add    $0x20,%esp
    using_apic = (edx & CPUID_FEATURE_APIC) ? TRUE : FALSE;
  10121c:	c1 e8 09             	shr    $0x9,%eax
  10121f:	83 e0 01             	and    $0x1,%eax
  101222:	88 83 80 88 02 00    	mov    %al,0x28880(%ebx)
    KERN_ASSERT(using_apic == TRUE);
  101228:	0f b6 83 80 88 02 00 	movzbl 0x28880(%ebx),%eax
  10122f:	3c 01                	cmp    $0x1,%al
  101231:	74 1f                	je     101252 <intr_init+0x62>
  101233:	8d 83 05 84 ff ff    	lea    -0x7bfb(%ebx),%eax
  101239:	50                   	push   %eax
  10123a:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  101240:	50                   	push   %eax
  101241:	8d 83 18 84 ff ff    	lea    -0x7be8(%ebx),%eax
  101247:	6a 63                	push   $0x63
  101249:	50                   	push   %eax
  10124a:	e8 e1 2d 00 00       	call   104030 <debug_panic>
  10124f:	83 c4 10             	add    $0x10,%esp

    if (pcpu_onboot())
  101252:	e8 29 28 00 00       	call   103a80 <pcpu_onboot>
  101257:	84 c0                	test   %al,%al
  101259:	75 25                	jne    101280 <intr_init+0x90>
            intr_init_idt();
        }
    }

    /* all processors */
    if (using_apic)
  10125b:	0f b6 83 80 88 02 00 	movzbl 0x28880(%ebx),%eax
  101262:	84 c0                	test   %al,%al
  101264:	0f 85 46 05 00 00    	jne    1017b0 <intr_init+0x5c0>
    asm volatile ("lidt %0" :: "m" (idt_pd));
  10126a:	0f 01 9b 20 03 00 00 	lidtl  0x320(%ebx)
    {
        lapic_init();
    }
    intr_install_idt();
}
  101271:	83 c4 2c             	add    $0x2c,%esp
  101274:	5b                   	pop    %ebx
  101275:	5e                   	pop    %esi
  101276:	5f                   	pop    %edi
  101277:	5d                   	pop    %ebp
  101278:	c3                   	ret    
  101279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pic_init();
  101280:	e8 3b 07 00 00       	call   1019c0 <pic_init>
        if (using_apic)
  101285:	0f b6 83 80 88 02 00 	movzbl 0x28880(%ebx),%eax
  10128c:	84 c0                	test   %al,%al
  10128e:	74 cb                	je     10125b <intr_init+0x6b>
            ioapic_init();
  101290:	e8 5b 18 00 00       	call   102af0 <ioapic_init>
        SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  101295:	c7 c0 0e 22 10 00    	mov    $0x10220e,%eax
  10129b:	8d 0d 80 80 02 00    	lea    0x28080,%ecx
  1012a1:	89 c6                	mov    %eax,%esi
  1012a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1012a7:	89 c7                	mov    %eax,%edi
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  1012a9:	31 c0                	xor    %eax,%eax
        SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  1012ab:	c1 ee 10             	shr    $0x10,%esi
  1012ae:	89 74 24 08          	mov    %esi,0x8(%esp)
  1012b2:	89 f5                	mov    %esi,%ebp
  1012b4:	8d b3 80 80 02 00    	lea    0x28080(%ebx),%esi
  1012ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1012c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1012c7:	66 89 3c c6          	mov    %di,(%esi,%eax,8)
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  1012cb:	83 c0 01             	add    $0x1,%eax
        SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  1012ce:	c7 84 13 82 80 02 00 	movl   $0x8e000008,0x28082(%ebx,%edx,1)
  1012d5:	08 00 00 8e 
  1012d9:	01 da                	add    %ebx,%edx
  1012db:	66 89 6c 11 06       	mov    %bp,0x6(%ecx,%edx,1)
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  1012e0:	3d 00 01 00 00       	cmp    $0x100,%eax
  1012e5:	75 d9                	jne    1012c0 <intr_init+0xd0>
    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  1012e7:	c7 c0 00 21 10 00    	mov    $0x102100,%eax
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  1012ed:	ba 08 00 00 00       	mov    $0x8,%edx
    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  1012f2:	c7 83 82 80 02 00 08 	movl   $0x8e000008,0x28082(%ebx)
  1012f9:	00 00 8e 
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  1012fc:	be 00 8e ff ff       	mov    $0xffff8e00,%esi
    SETGATE(idt[T_DEBUG],                   0, CPU_GDT_KCODE, &Xdebug,          0);
  101301:	c7 83 8a 80 02 00 08 	movl   $0x8e000008,0x2808a(%ebx)
  101308:	00 00 8e 
    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  10130b:	66 89 04 19          	mov    %ax,(%ecx,%ebx,1)
  10130f:	c1 e8 10             	shr    $0x10,%eax
  101312:	66 89 44 19 06       	mov    %ax,0x6(%ecx,%ebx,1)
    SETGATE(idt[T_DEBUG],                   0, CPU_GDT_KCODE, &Xdebug,          0);
  101317:	c7 c0 0a 21 10 00    	mov    $0x10210a,%eax
    SETGATE(idt[T_NMI],                     0, CPU_GDT_KCODE, &Xnmi,            0);
  10131d:	c7 83 92 80 02 00 08 	movl   $0x8e000008,0x28092(%ebx)
  101324:	00 00 8e 
    SETGATE(idt[T_DEBUG],                   0, CPU_GDT_KCODE, &Xdebug,          0);
  101327:	66 89 44 19 08       	mov    %ax,0x8(%ecx,%ebx,1)
  10132c:	c1 e8 10             	shr    $0x10,%eax
  10132f:	66 89 44 19 0e       	mov    %ax,0xe(%ecx,%ebx,1)
    SETGATE(idt[T_NMI],                     0, CPU_GDT_KCODE, &Xnmi,            0);
  101334:	c7 c0 14 21 10 00    	mov    $0x102114,%eax
    SETGATE(idt[T_BRKPT],                   0, CPU_GDT_KCODE, &Xbrkpt,          3);
  10133a:	c7 83 9a 80 02 00 08 	movl   $0xee000008,0x2809a(%ebx)
  101341:	00 00 ee 
    SETGATE(idt[T_NMI],                     0, CPU_GDT_KCODE, &Xnmi,            0);
  101344:	66 89 44 19 10       	mov    %ax,0x10(%ecx,%ebx,1)
  101349:	c1 e8 10             	shr    $0x10,%eax
  10134c:	66 89 44 19 16       	mov    %ax,0x16(%ecx,%ebx,1)
    SETGATE(idt[T_BRKPT],                   0, CPU_GDT_KCODE, &Xbrkpt,          3);
  101351:	c7 c0 1e 21 10 00    	mov    $0x10211e,%eax
    SETGATE(idt[T_OFLOW],                   0, CPU_GDT_KCODE, &Xoflow,          3);
  101357:	c7 83 a2 80 02 00 08 	movl   $0xee000008,0x280a2(%ebx)
  10135e:	00 00 ee 
    SETGATE(idt[T_BRKPT],                   0, CPU_GDT_KCODE, &Xbrkpt,          3);
  101361:	66 89 44 19 18       	mov    %ax,0x18(%ecx,%ebx,1)
  101366:	c1 e8 10             	shr    $0x10,%eax
  101369:	66 89 44 19 1e       	mov    %ax,0x1e(%ecx,%ebx,1)
    SETGATE(idt[T_OFLOW],                   0, CPU_GDT_KCODE, &Xoflow,          3);
  10136e:	c7 c0 28 21 10 00    	mov    $0x102128,%eax
    SETGATE(idt[T_BOUND],                   0, CPU_GDT_KCODE, &Xbound,          0);
  101374:	c7 83 aa 80 02 00 08 	movl   $0x8e000008,0x280aa(%ebx)
  10137b:	00 00 8e 
    SETGATE(idt[T_OFLOW],                   0, CPU_GDT_KCODE, &Xoflow,          3);
  10137e:	66 89 44 19 20       	mov    %ax,0x20(%ecx,%ebx,1)
  101383:	c1 e8 10             	shr    $0x10,%eax
  101386:	66 89 44 19 26       	mov    %ax,0x26(%ecx,%ebx,1)
    SETGATE(idt[T_BOUND],                   0, CPU_GDT_KCODE, &Xbound,          0);
  10138b:	c7 c0 32 21 10 00    	mov    $0x102132,%eax
    SETGATE(idt[T_ILLOP],                   0, CPU_GDT_KCODE, &Xillop,          0);
  101391:	c7 83 b2 80 02 00 08 	movl   $0x8e000008,0x280b2(%ebx)
  101398:	00 00 8e 
    SETGATE(idt[T_BOUND],                   0, CPU_GDT_KCODE, &Xbound,          0);
  10139b:	66 89 44 19 28       	mov    %ax,0x28(%ecx,%ebx,1)
  1013a0:	c1 e8 10             	shr    $0x10,%eax
  1013a3:	66 89 44 19 2e       	mov    %ax,0x2e(%ecx,%ebx,1)
    SETGATE(idt[T_ILLOP],                   0, CPU_GDT_KCODE, &Xillop,          0);
  1013a8:	c7 c0 3c 21 10 00    	mov    $0x10213c,%eax
    SETGATE(idt[T_DEVICE],                  0, CPU_GDT_KCODE, &Xdevice,         0);
  1013ae:	c7 83 ba 80 02 00 08 	movl   $0x8e000008,0x280ba(%ebx)
  1013b5:	00 00 8e 
    SETGATE(idt[T_ILLOP],                   0, CPU_GDT_KCODE, &Xillop,          0);
  1013b8:	66 89 44 19 30       	mov    %ax,0x30(%ecx,%ebx,1)
  1013bd:	c1 e8 10             	shr    $0x10,%eax
  1013c0:	66 89 44 19 36       	mov    %ax,0x36(%ecx,%ebx,1)
    SETGATE(idt[T_DEVICE],                  0, CPU_GDT_KCODE, &Xdevice,         0);
  1013c5:	c7 c0 46 21 10 00    	mov    $0x102146,%eax
  1013cb:	66 89 44 19 38       	mov    %ax,0x38(%ecx,%ebx,1)
  1013d0:	c1 e8 10             	shr    $0x10,%eax
  1013d3:	66 89 44 19 3e       	mov    %ax,0x3e(%ecx,%ebx,1)
    SETGATE(idt[T_DBLFLT],                  0, CPU_GDT_KCODE, &Xdblflt,         0);
  1013d8:	c7 c0 50 21 10 00    	mov    $0x102150,%eax
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  1013de:	66 89 94 19 82 00 00 	mov    %dx,0x82(%ecx,%ebx,1)
  1013e5:	00 
    SETGATE(idt[T_DBLFLT],                  0, CPU_GDT_KCODE, &Xdblflt,         0);
  1013e6:	66 89 44 19 40       	mov    %ax,0x40(%ecx,%ebx,1)
  1013eb:	c1 e8 10             	shr    $0x10,%eax
  1013ee:	66 89 44 19 46       	mov    %ax,0x46(%ecx,%ebx,1)
    SETGATE(idt[T_TSS],                     0, CPU_GDT_KCODE, &Xtss,            0);
  1013f3:	c7 c0 62 21 10 00    	mov    $0x102162,%eax
    SETGATE(idt[T_DBLFLT],                  0, CPU_GDT_KCODE, &Xdblflt,         0);
  1013f9:	c7 83 c2 80 02 00 08 	movl   $0x8e000008,0x280c2(%ebx)
  101400:	00 00 8e 
    SETGATE(idt[T_TSS],                     0, CPU_GDT_KCODE, &Xtss,            0);
  101403:	66 89 44 19 50       	mov    %ax,0x50(%ecx,%ebx,1)
  101408:	c1 e8 10             	shr    $0x10,%eax
  10140b:	66 89 44 19 56       	mov    %ax,0x56(%ecx,%ebx,1)
    SETGATE(idt[T_SEGNP],                   0, CPU_GDT_KCODE, &Xsegnp,          0);
  101410:	c7 c0 6a 21 10 00    	mov    $0x10216a,%eax
    SETGATE(idt[T_TSS],                     0, CPU_GDT_KCODE, &Xtss,            0);
  101416:	c7 83 d2 80 02 00 08 	movl   $0x8e000008,0x280d2(%ebx)
  10141d:	00 00 8e 
    SETGATE(idt[T_SEGNP],                   0, CPU_GDT_KCODE, &Xsegnp,          0);
  101420:	66 89 44 19 58       	mov    %ax,0x58(%ecx,%ebx,1)
  101425:	c1 e8 10             	shr    $0x10,%eax
  101428:	66 89 44 19 5e       	mov    %ax,0x5e(%ecx,%ebx,1)
    SETGATE(idt[T_STACK],                   0, CPU_GDT_KCODE, &Xstack,          0);
  10142d:	c7 c0 72 21 10 00    	mov    $0x102172,%eax
    SETGATE(idt[T_SEGNP],                   0, CPU_GDT_KCODE, &Xsegnp,          0);
  101433:	c7 83 da 80 02 00 08 	movl   $0x8e000008,0x280da(%ebx)
  10143a:	00 00 8e 
    SETGATE(idt[T_STACK],                   0, CPU_GDT_KCODE, &Xstack,          0);
  10143d:	66 89 44 19 60       	mov    %ax,0x60(%ecx,%ebx,1)
  101442:	c1 e8 10             	shr    $0x10,%eax
  101445:	66 89 44 19 66       	mov    %ax,0x66(%ecx,%ebx,1)
    SETGATE(idt[T_GPFLT],                   0, CPU_GDT_KCODE, &Xgpflt,          0);
  10144a:	c7 c0 7a 21 10 00    	mov    $0x10217a,%eax
    SETGATE(idt[T_STACK],                   0, CPU_GDT_KCODE, &Xstack,          0);
  101450:	c7 83 e2 80 02 00 08 	movl   $0x8e000008,0x280e2(%ebx)
  101457:	00 00 8e 
    SETGATE(idt[T_GPFLT],                   0, CPU_GDT_KCODE, &Xgpflt,          0);
  10145a:	66 89 44 19 68       	mov    %ax,0x68(%ecx,%ebx,1)
  10145f:	c1 e8 10             	shr    $0x10,%eax
  101462:	66 89 44 19 6e       	mov    %ax,0x6e(%ecx,%ebx,1)
    SETGATE(idt[T_PGFLT],                   0, CPU_GDT_KCODE, &Xpgflt,          0);
  101467:	c7 c0 82 21 10 00    	mov    $0x102182,%eax
    SETGATE(idt[T_GPFLT],                   0, CPU_GDT_KCODE, &Xgpflt,          0);
  10146d:	c7 83 ea 80 02 00 08 	movl   $0x8e000008,0x280ea(%ebx)
  101474:	00 00 8e 
    SETGATE(idt[T_PGFLT],                   0, CPU_GDT_KCODE, &Xpgflt,          0);
  101477:	66 89 44 19 70       	mov    %ax,0x70(%ecx,%ebx,1)
  10147c:	c1 e8 10             	shr    $0x10,%eax
  10147f:	66 89 44 19 76       	mov    %ax,0x76(%ecx,%ebx,1)
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  101484:	c7 c0 94 21 10 00    	mov    $0x102194,%eax
    SETGATE(idt[T_PGFLT],                   0, CPU_GDT_KCODE, &Xpgflt,          0);
  10148a:	c7 83 f2 80 02 00 08 	movl   $0x8e000008,0x280f2(%ebx)
  101491:	00 00 8e 
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  101494:	66 89 84 19 80 00 00 	mov    %ax,0x80(%ecx,%ebx,1)
  10149b:	00 
  10149c:	c1 e8 10             	shr    $0x10,%eax
  10149f:	66 89 84 19 86 00 00 	mov    %ax,0x86(%ecx,%ebx,1)
  1014a6:	00 
    SETGATE(idt[T_ALIGN],                   0, CPU_GDT_KCODE, &Xalign,          0);
  1014a7:	c7 c0 9e 21 10 00    	mov    $0x10219e,%eax
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  1014ad:	66 89 b3 04 81 02 00 	mov    %si,0x28104(%ebx)
    SETGATE(idt[T_ALIGN],                   0, CPU_GDT_KCODE, &Xalign,          0);
  1014b4:	66 89 84 19 88 00 00 	mov    %ax,0x88(%ecx,%ebx,1)
  1014bb:	00 
  1014bc:	c1 e8 10             	shr    $0x10,%eax
  1014bf:	c7 83 0a 81 02 00 08 	movl   $0x8e000008,0x2810a(%ebx)
  1014c6:	00 00 8e 
  1014c9:	66 89 84 19 8e 00 00 	mov    %ax,0x8e(%ecx,%ebx,1)
  1014d0:	00 
    SETGATE(idt[T_MCHK],                    0, CPU_GDT_KCODE, &Xmchk,           0);
  1014d1:	c7 c0 a2 21 10 00    	mov    $0x1021a2,%eax
  1014d7:	c7 83 12 81 02 00 08 	movl   $0x8e000008,0x28112(%ebx)
  1014de:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  1014e1:	c7 c2 c0 21 10 00    	mov    $0x1021c0,%edx
    SETGATE(idt[T_MCHK],                    0, CPU_GDT_KCODE, &Xmchk,           0);
  1014e7:	66 89 84 19 90 00 00 	mov    %ax,0x90(%ecx,%ebx,1)
  1014ee:	00 
  1014ef:	c1 e8 10             	shr    $0x10,%eax
  1014f2:	66 89 84 19 96 00 00 	mov    %ax,0x96(%ecx,%ebx,1)
  1014f9:	00 
    SETGATE(idt[T_IRQ0 + IRQ_TIMER],        0, CPU_GDT_KCODE, &Xirq_timer,      0);
  1014fa:	c7 c0 a8 21 10 00    	mov    $0x1021a8,%eax
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  101500:	66 89 94 19 20 01 00 	mov    %dx,0x120(%ecx,%ebx,1)
  101507:	00 
  101508:	c1 ea 10             	shr    $0x10,%edx
    SETGATE(idt[T_IRQ0 + IRQ_TIMER],        0, CPU_GDT_KCODE, &Xirq_timer,      0);
  10150b:	66 89 84 19 00 01 00 	mov    %ax,0x100(%ecx,%ebx,1)
  101512:	00 
  101513:	c1 e8 10             	shr    $0x10,%eax
  101516:	66 89 84 19 06 01 00 	mov    %ax,0x106(%ecx,%ebx,1)
  10151d:	00 
    SETGATE(idt[T_IRQ0 + IRQ_KBD],          0, CPU_GDT_KCODE, &Xirq_kbd,        0);
  10151e:	c7 c0 ae 21 10 00    	mov    $0x1021ae,%eax
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  101524:	66 89 94 19 26 01 00 	mov    %dx,0x126(%ecx,%ebx,1)
  10152b:	00 
    SETGATE(idt[T_IRQ0 + IRQ_KBD],          0, CPU_GDT_KCODE, &Xirq_kbd,        0);
  10152c:	66 89 84 19 08 01 00 	mov    %ax,0x108(%ecx,%ebx,1)
  101533:	00 
  101534:	c1 e8 10             	shr    $0x10,%eax
  101537:	66 89 84 19 0e 01 00 	mov    %ax,0x10e(%ecx,%ebx,1)
  10153e:	00 
    SETGATE(idt[T_IRQ0 + IRQ_SLAVE],        0, CPU_GDT_KCODE, &Xirq_slave,      0);
  10153f:	c7 c0 b4 21 10 00    	mov    $0x1021b4,%eax
    SETGATE(idt[T_IRQ0 + IRQ_TIMER],        0, CPU_GDT_KCODE, &Xirq_timer,      0);
  101545:	c7 83 82 81 02 00 08 	movl   $0x8e000008,0x28182(%ebx)
  10154c:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SLAVE],        0, CPU_GDT_KCODE, &Xirq_slave,      0);
  10154f:	66 89 84 19 10 01 00 	mov    %ax,0x110(%ecx,%ebx,1)
  101556:	00 
  101557:	c1 e8 10             	shr    $0x10,%eax
  10155a:	66 89 84 19 16 01 00 	mov    %ax,0x116(%ecx,%ebx,1)
  101561:	00 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  101562:	c7 c0 ba 21 10 00    	mov    $0x1021ba,%eax
    SETGATE(idt[T_IRQ0 + IRQ_KBD],          0, CPU_GDT_KCODE, &Xirq_kbd,        0);
  101568:	c7 83 8a 81 02 00 08 	movl   $0x8e000008,0x2818a(%ebx)
  10156f:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  101572:	66 89 84 19 18 01 00 	mov    %ax,0x118(%ecx,%ebx,1)
  101579:	00 
  10157a:	c1 e8 10             	shr    $0x10,%eax
  10157d:	66 89 84 19 1e 01 00 	mov    %ax,0x11e(%ecx,%ebx,1)
  101584:	00 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  101585:	8b 83 a2 81 02 00    	mov    0x281a2(%ebx),%eax
    SETGATE(idt[T_IRQ0 + IRQ_SLAVE],        0, CPU_GDT_KCODE, &Xirq_slave,      0);
  10158b:	c7 83 92 81 02 00 08 	movl   $0x8e000008,0x28192(%ebx)
  101592:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  101595:	c7 83 9a 81 02 00 08 	movl   $0x8e000008,0x2819a(%ebx)
  10159c:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  10159f:	25 00 00 e0 ff       	and    $0xffe00000,%eax
    SETGATE(idt[T_IRQ0 + IRQ_LPT2],         0, CPU_GDT_KCODE, &Xirq_lpt,        0);
  1015a4:	c7 83 aa 81 02 00 08 	movl   $0x8e000008,0x281aa(%ebx)
  1015ab:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  1015ae:	83 c8 08             	or     $0x8,%eax
  1015b1:	89 83 a2 81 02 00    	mov    %eax,0x281a2(%ebx)
  1015b7:	0f b7 83 a4 81 02 00 	movzwl 0x281a4(%ebx),%eax
  1015be:	83 e0 1f             	and    $0x1f,%eax
  1015c1:	66 0d 00 8e          	or     $0x8e00,%ax
  1015c5:	66 89 83 a4 81 02 00 	mov    %ax,0x281a4(%ebx)
    SETGATE(idt[T_IRQ0 + IRQ_LPT2],         0, CPU_GDT_KCODE, &Xirq_lpt,        0);
  1015cc:	c7 c0 c6 21 10 00    	mov    $0x1021c6,%eax
  1015d2:	66 89 84 19 28 01 00 	mov    %ax,0x128(%ecx,%ebx,1)
  1015d9:	00 
  1015da:	c1 e8 10             	shr    $0x10,%eax
  1015dd:	66 89 84 19 2e 01 00 	mov    %ax,0x12e(%ecx,%ebx,1)
  1015e4:	00 
    SETGATE(idt[T_IRQ0 + IRQ_FLOPPY],       0, CPU_GDT_KCODE, &Xirq_floppy,     0);
  1015e5:	c7 c0 cc 21 10 00    	mov    $0x1021cc,%eax
  1015eb:	66 89 84 19 30 01 00 	mov    %ax,0x130(%ecx,%ebx,1)
  1015f2:	00 
  1015f3:	c1 e8 10             	shr    $0x10,%eax
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1015f6:	c7 c2 ea 21 10 00    	mov    $0x1021ea,%edx
    SETGATE(idt[T_IRQ0 + IRQ_FLOPPY],       0, CPU_GDT_KCODE, &Xirq_floppy,     0);
  1015fc:	66 89 84 19 36 01 00 	mov    %ax,0x136(%ecx,%ebx,1)
  101603:	00 
    SETGATE(idt[T_IRQ0 + IRQ_SPURIOUS],     0, CPU_GDT_KCODE, &Xirq_spurious,   0);
  101604:	c7 c0 d2 21 10 00    	mov    $0x1021d2,%eax
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  10160a:	66 89 94 19 58 01 00 	mov    %dx,0x158(%ecx,%ebx,1)
  101611:	00 
    SETGATE(idt[T_IRQ0 + IRQ_SPURIOUS],     0, CPU_GDT_KCODE, &Xirq_spurious,   0);
  101612:	66 89 84 19 38 01 00 	mov    %ax,0x138(%ecx,%ebx,1)
  101619:	00 
  10161a:	c1 e8 10             	shr    $0x10,%eax
  10161d:	66 89 84 19 3e 01 00 	mov    %ax,0x13e(%ecx,%ebx,1)
  101624:	00 
    SETGATE(idt[T_IRQ0 + IRQ_RTC],          0, CPU_GDT_KCODE, &Xirq_rtc,        0);
  101625:	c7 c0 d8 21 10 00    	mov    $0x1021d8,%eax
    SETGATE(idt[T_IRQ0 + IRQ_FLOPPY],       0, CPU_GDT_KCODE, &Xirq_floppy,     0);
  10162b:	c7 83 b2 81 02 00 08 	movl   $0x8e000008,0x281b2(%ebx)
  101632:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_RTC],          0, CPU_GDT_KCODE, &Xirq_rtc,        0);
  101635:	66 89 84 19 40 01 00 	mov    %ax,0x140(%ecx,%ebx,1)
  10163c:	00 
  10163d:	c1 e8 10             	shr    $0x10,%eax
  101640:	66 89 84 19 46 01 00 	mov    %ax,0x146(%ecx,%ebx,1)
  101647:	00 
    SETGATE(idt[T_IRQ0 + 9],                0, CPU_GDT_KCODE, &Xirq9,           0);
  101648:	c7 c0 de 21 10 00    	mov    $0x1021de,%eax
    SETGATE(idt[T_IRQ0 + IRQ_SPURIOUS],     0, CPU_GDT_KCODE, &Xirq_spurious,   0);
  10164e:	c7 83 ba 81 02 00 08 	movl   $0x8e000008,0x281ba(%ebx)
  101655:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 9],                0, CPU_GDT_KCODE, &Xirq9,           0);
  101658:	66 89 84 19 48 01 00 	mov    %ax,0x148(%ecx,%ebx,1)
  10165f:	00 
  101660:	c1 e8 10             	shr    $0x10,%eax
  101663:	66 89 84 19 4e 01 00 	mov    %ax,0x14e(%ecx,%ebx,1)
  10166a:	00 
    SETGATE(idt[T_IRQ0 + 10],               0, CPU_GDT_KCODE, &Xirq10,          0);
  10166b:	c7 c0 e4 21 10 00    	mov    $0x1021e4,%eax
    SETGATE(idt[T_IRQ0 + IRQ_RTC],          0, CPU_GDT_KCODE, &Xirq_rtc,        0);
  101671:	c7 83 c2 81 02 00 08 	movl   $0x8e000008,0x281c2(%ebx)
  101678:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 10],               0, CPU_GDT_KCODE, &Xirq10,          0);
  10167b:	66 89 84 19 50 01 00 	mov    %ax,0x150(%ecx,%ebx,1)
  101682:	00 
  101683:	c1 e8 10             	shr    $0x10,%eax
  101686:	66 89 84 19 56 01 00 	mov    %ax,0x156(%ecx,%ebx,1)
  10168d:	00 
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  10168e:	8b 83 da 81 02 00    	mov    0x281da(%ebx),%eax
    SETGATE(idt[T_IRQ0 + 9],                0, CPU_GDT_KCODE, &Xirq9,           0);
  101694:	c7 83 ca 81 02 00 08 	movl   $0x8e000008,0x281ca(%ebx)
  10169b:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 10],               0, CPU_GDT_KCODE, &Xirq10,          0);
  10169e:	c7 83 d2 81 02 00 08 	movl   $0x8e000008,0x281d2(%ebx)
  1016a5:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1016a8:	25 00 00 00 ff       	and    $0xff000000,%eax
  1016ad:	c1 ea 10             	shr    $0x10,%edx
  1016b0:	83 c8 08             	or     $0x8,%eax
  1016b3:	66 89 94 19 5e 01 00 	mov    %dx,0x15e(%ecx,%ebx,1)
  1016ba:	00 
  1016bb:	89 83 da 81 02 00    	mov    %eax,0x281da(%ebx)
    SETGATE(idt[T_IRQ0 + IRQ_MOUSE],        0, CPU_GDT_KCODE, &Xirq_mouse,      0);
  1016c1:	c7 c0 f0 21 10 00    	mov    $0x1021f0,%eax
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1016c7:	c6 83 dd 81 02 00 8e 	movb   $0x8e,0x281dd(%ebx)
    SETGATE(idt[T_IRQ0 + IRQ_MOUSE],        0, CPU_GDT_KCODE, &Xirq_mouse,      0);
  1016ce:	66 89 84 19 60 01 00 	mov    %ax,0x160(%ecx,%ebx,1)
  1016d5:	00 
  1016d6:	c1 e8 10             	shr    $0x10,%eax
  1016d9:	66 89 84 19 66 01 00 	mov    %ax,0x166(%ecx,%ebx,1)
  1016e0:	00 
    SETGATE(idt[T_IRQ0 + IRQ_COPROCESSOR],  0, CPU_GDT_KCODE, &Xirq_coproc,     0);
  1016e1:	c7 c0 f6 21 10 00    	mov    $0x1021f6,%eax
    SETGATE(idt[T_IRQ0 + IRQ_MOUSE],        0, CPU_GDT_KCODE, &Xirq_mouse,      0);
  1016e7:	c7 83 e2 81 02 00 08 	movl   $0x8e000008,0x281e2(%ebx)
  1016ee:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_COPROCESSOR],  0, CPU_GDT_KCODE, &Xirq_coproc,     0);
  1016f1:	66 89 84 19 68 01 00 	mov    %ax,0x168(%ecx,%ebx,1)
  1016f8:	00 
  1016f9:	c1 e8 10             	shr    $0x10,%eax
  1016fc:	c7 83 ea 81 02 00 08 	movl   $0x8e000008,0x281ea(%ebx)
  101703:	00 00 8e 
  101706:	66 89 84 19 6e 01 00 	mov    %ax,0x16e(%ecx,%ebx,1)
  10170d:	00 
    SETGATE(idt[T_IRQ0 + IRQ_IDE1],         0, CPU_GDT_KCODE, &Xirq_ide1,       0);
  10170e:	c7 c0 fc 21 10 00    	mov    $0x1021fc,%eax
  101714:	c7 83 f2 81 02 00 08 	movl   $0x8e000008,0x281f2(%ebx)
  10171b:	00 00 8e 
  10171e:	66 89 84 19 70 01 00 	mov    %ax,0x170(%ecx,%ebx,1)
  101725:	00 
  101726:	c1 e8 10             	shr    $0x10,%eax
  101729:	66 89 84 19 76 01 00 	mov    %ax,0x176(%ecx,%ebx,1)
  101730:	00 
    SETGATE(idt[T_IRQ0 + IRQ_IDE2],         0, CPU_GDT_KCODE, &Xirq_ide2,       0);
  101731:	c7 c0 02 22 10 00    	mov    $0x102202,%eax
  101737:	c7 83 fa 81 02 00 08 	movl   $0x8e000008,0x281fa(%ebx)
  10173e:	00 00 8e 
  101741:	66 89 84 19 78 01 00 	mov    %ax,0x178(%ecx,%ebx,1)
  101748:	00 
  101749:	c1 e8 10             	shr    $0x10,%eax
  10174c:	66 89 84 19 7e 01 00 	mov    %ax,0x17e(%ecx,%ebx,1)
  101753:	00 
    SETGATE(idt[T_SYSCALL], 0, CPU_GDT_KCODE, &Xsyscall, 3);
  101754:	c7 c0 08 22 10 00    	mov    $0x102208,%eax
  10175a:	c7 83 02 82 02 00 08 	movl   $0xee000008,0x28202(%ebx)
  101761:	00 00 ee 
  101764:	66 89 84 19 80 01 00 	mov    %ax,0x180(%ecx,%ebx,1)
  10176b:	00 
  10176c:	c1 e8 10             	shr    $0x10,%eax
  10176f:	66 89 84 19 86 01 00 	mov    %ax,0x186(%ecx,%ebx,1)
  101776:	00 
    SETGATE(idt[T_DEFAULT], 0, CPU_GDT_KCODE, &Xdefault, 0);
  101777:	0f b7 44 24 0c       	movzwl 0xc(%esp),%eax
  10177c:	c7 83 72 88 02 00 08 	movl   $0x8e000008,0x28872(%ebx)
  101783:	00 00 8e 
  101786:	66 89 84 19 f0 07 00 	mov    %ax,0x7f0(%ecx,%ebx,1)
  10178d:	00 
  10178e:	0f b7 44 24 08       	movzwl 0x8(%esp),%eax
  101793:	66 89 84 19 f6 07 00 	mov    %ax,0x7f6(%ecx,%ebx,1)
  10179a:	00 
    if (using_apic)
  10179b:	0f b6 83 80 88 02 00 	movzbl 0x28880(%ebx),%eax
  1017a2:	84 c0                	test   %al,%al
  1017a4:	0f 84 c0 fa ff ff    	je     10126a <intr_init+0x7a>
  1017aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        lapic_init();
  1017b0:	e8 db 0d 00 00       	call   102590 <lapic_init>
  1017b5:	e9 b0 fa ff ff       	jmp    10126a <intr_init+0x7a>
  1017ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001017c0 <intr_enable>:

void intr_enable(uint8_t irq, int cpunum)
{
  1017c0:	57                   	push   %edi
  1017c1:	56                   	push   %esi
  1017c2:	53                   	push   %ebx
  1017c3:	8b 7c 24 14          	mov    0x14(%esp),%edi
  1017c7:	e8 bd eb ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1017cc:	81 c3 34 f8 00 00    	add    $0xf834,%ebx
  1017d2:	8b 74 24 10          	mov    0x10(%esp),%esi
    KERN_ASSERT(cpunum == 0xff || (0 <= cpunum && cpunum < pcpu_ncpu()));
  1017d6:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  1017dc:	74 12                	je     1017f0 <intr_enable+0x30>
  1017de:	85 ff                	test   %edi,%edi
  1017e0:	78 3e                	js     101820 <intr_enable+0x60>
  1017e2:	e8 59 22 00 00       	call   103a40 <pcpu_ncpu>
  1017e7:	39 f8                	cmp    %edi,%eax
  1017e9:	76 35                	jbe    101820 <intr_enable+0x60>
  1017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1017ef:	90                   	nop

    if (irq >= 24)
  1017f0:	89 f0                	mov    %esi,%eax
  1017f2:	3c 17                	cmp    $0x17,%al
  1017f4:	77 26                	ja     10181c <intr_enable+0x5c>
        return;

    if (using_apic == TRUE) {
  1017f6:	0f b6 83 80 88 02 00 	movzbl 0x28880(%ebx),%eax
  1017fd:	3c 01                	cmp    $0x1,%al
  1017ff:	74 47                	je     101848 <intr_enable+0x88>
        ioapic_enable(irq, (cpunum == 0xff) ?  0xff : pcpu_cpu_lapicid(cpunum), 0, 0);
    } else {
        KERN_ASSERT(irq < 16);
  101801:	89 f0                	mov    %esi,%eax
  101803:	3c 0f                	cmp    $0xf,%al
  101805:	0f 87 7d 00 00 00    	ja     101888 <intr_enable+0xc8>
        pic_enable(irq);
  10180b:	89 f0                	mov    %esi,%eax
  10180d:	83 ec 0c             	sub    $0xc,%esp
  101810:	0f b6 f0             	movzbl %al,%esi
  101813:	56                   	push   %esi
  101814:	e8 e7 02 00 00       	call   101b00 <pic_enable>
  101819:	83 c4 10             	add    $0x10,%esp
    }
}
  10181c:	5b                   	pop    %ebx
  10181d:	5e                   	pop    %esi
  10181e:	5f                   	pop    %edi
  10181f:	c3                   	ret    
    KERN_ASSERT(cpunum == 0xff || (0 <= cpunum && cpunum < pcpu_ncpu()));
  101820:	8d 83 34 84 ff ff    	lea    -0x7bcc(%ebx),%eax
  101826:	50                   	push   %eax
  101827:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10182d:	50                   	push   %eax
  10182e:	8d 83 18 84 ff ff    	lea    -0x7be8(%ebx),%eax
  101834:	6a 7a                	push   $0x7a
  101836:	50                   	push   %eax
  101837:	e8 f4 27 00 00       	call   104030 <debug_panic>
  10183c:	83 c4 10             	add    $0x10,%esp
  10183f:	eb af                	jmp    1017f0 <intr_enable+0x30>
  101841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        ioapic_enable(irq, (cpunum == 0xff) ?  0xff : pcpu_cpu_lapicid(cpunum), 0, 0);
  101848:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  10184e:	75 20                	jne    101870 <intr_enable+0xb0>
  101850:	89 f0                	mov    %esi,%eax
  101852:	6a 00                	push   $0x0
  101854:	0f b6 f0             	movzbl %al,%esi
  101857:	6a 00                	push   $0x0
  101859:	57                   	push   %edi
  10185a:	56                   	push   %esi
  10185b:	e8 d0 13 00 00       	call   102c30 <ioapic_enable>
  101860:	83 c4 10             	add    $0x10,%esp
}
  101863:	5b                   	pop    %ebx
  101864:	5e                   	pop    %esi
  101865:	5f                   	pop    %edi
  101866:	c3                   	ret    
  101867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10186e:	66 90                	xchg   %ax,%ax
        ioapic_enable(irq, (cpunum == 0xff) ?  0xff : pcpu_cpu_lapicid(cpunum), 0, 0);
  101870:	83 ec 0c             	sub    $0xc,%esp
  101873:	57                   	push   %edi
  101874:	e8 57 22 00 00       	call   103ad0 <pcpu_cpu_lapicid>
  101879:	83 c4 10             	add    $0x10,%esp
  10187c:	0f b6 f8             	movzbl %al,%edi
  10187f:	eb cf                	jmp    101850 <intr_enable+0x90>
  101881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        KERN_ASSERT(irq < 16);
  101888:	8d 83 28 84 ff ff    	lea    -0x7bd8(%ebx),%eax
  10188e:	50                   	push   %eax
  10188f:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  101895:	50                   	push   %eax
  101896:	8d 83 18 84 ff ff    	lea    -0x7be8(%ebx),%eax
  10189c:	68 82 00 00 00       	push   $0x82
  1018a1:	50                   	push   %eax
  1018a2:	e8 89 27 00 00       	call   104030 <debug_panic>
  1018a7:	83 c4 10             	add    $0x10,%esp
  1018aa:	e9 5c ff ff ff       	jmp    10180b <intr_enable+0x4b>
  1018af:	90                   	nop

001018b0 <intr_enable_lapicid>:

void intr_enable_lapicid(uint8_t irq, int lapic_id)
{
  1018b0:	56                   	push   %esi
  1018b1:	53                   	push   %ebx
  1018b2:	e8 d2 ea ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1018b7:	81 c3 49 f7 00 00    	add    $0xf749,%ebx
  1018bd:	83 ec 04             	sub    $0x4,%esp
  1018c0:	8b 44 24 10          	mov    0x10(%esp),%eax
    if (irq > 24)
  1018c4:	3c 18                	cmp    $0x18,%al
  1018c6:	77 1f                	ja     1018e7 <intr_enable_lapicid+0x37>
        return;

    if (using_apic == TRUE) {
  1018c8:	0f b6 93 80 88 02 00 	movzbl 0x28880(%ebx),%edx
        ioapic_enable(irq, (lapic_id == 0xff) ?  0xff : lapic_id, 0, 0);
  1018cf:	0f b6 f0             	movzbl %al,%esi
    if (using_apic == TRUE) {
  1018d2:	80 fa 01             	cmp    $0x1,%dl
  1018d5:	74 41                	je     101918 <intr_enable_lapicid+0x68>
    } else {
        KERN_ASSERT(irq < 16);
  1018d7:	3c 0f                	cmp    $0xf,%al
  1018d9:	77 15                	ja     1018f0 <intr_enable_lapicid+0x40>
        pic_enable(irq);
  1018db:	83 ec 0c             	sub    $0xc,%esp
  1018de:	56                   	push   %esi
  1018df:	e8 1c 02 00 00       	call   101b00 <pic_enable>
  1018e4:	83 c4 10             	add    $0x10,%esp
    }
}
  1018e7:	83 c4 04             	add    $0x4,%esp
  1018ea:	5b                   	pop    %ebx
  1018eb:	5e                   	pop    %esi
  1018ec:	c3                   	ret    
  1018ed:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_ASSERT(irq < 16);
  1018f0:	8d 83 28 84 ff ff    	lea    -0x7bd8(%ebx),%eax
  1018f6:	50                   	push   %eax
  1018f7:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1018fd:	50                   	push   %eax
  1018fe:	8d 83 18 84 ff ff    	lea    -0x7be8(%ebx),%eax
  101904:	68 8f 00 00 00       	push   $0x8f
  101909:	50                   	push   %eax
  10190a:	e8 21 27 00 00       	call   104030 <debug_panic>
  10190f:	83 c4 10             	add    $0x10,%esp
  101912:	eb c7                	jmp    1018db <intr_enable_lapicid+0x2b>
  101914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ioapic_enable(irq, (lapic_id == 0xff) ?  0xff : lapic_id, 0, 0);
  101918:	6a 00                	push   $0x0
  10191a:	6a 00                	push   $0x0
  10191c:	0f b6 44 24 1c       	movzbl 0x1c(%esp),%eax
  101921:	50                   	push   %eax
  101922:	56                   	push   %esi
  101923:	e8 08 13 00 00       	call   102c30 <ioapic_enable>
  101928:	83 c4 10             	add    $0x10,%esp
}
  10192b:	83 c4 04             	add    $0x4,%esp
  10192e:	5b                   	pop    %ebx
  10192f:	5e                   	pop    %esi
  101930:	c3                   	ret    
  101931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10193f:	90                   	nop

00101940 <intr_eoi>:

void intr_eoi(void)
{
  101940:	53                   	push   %ebx
  101941:	e8 43 ea ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101946:	81 c3 ba f6 00 00    	add    $0xf6ba,%ebx
  10194c:	83 ec 08             	sub    $0x8,%esp
    if (using_apic == TRUE)
  10194f:	0f b6 83 80 88 02 00 	movzbl 0x28880(%ebx),%eax
  101956:	3c 01                	cmp    $0x1,%al
  101958:	74 0e                	je     101968 <intr_eoi+0x28>
        lapic_eoi();
    else
        pic_eoi();
  10195a:	e8 f1 01 00 00       	call   101b50 <pic_eoi>
}
  10195f:	83 c4 08             	add    $0x8,%esp
  101962:	5b                   	pop    %ebx
  101963:	c3                   	ret    
  101964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        lapic_eoi();
  101968:	e8 13 0f 00 00       	call   102880 <lapic_eoi>
}
  10196d:	83 c4 08             	add    $0x8,%esp
  101970:	5b                   	pop    %ebx
  101971:	c3                   	ret    
  101972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101980 <intr_local_enable>:

void intr_local_enable(void)
{
  101980:	53                   	push   %ebx
  101981:	e8 03 ea ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101986:	81 c3 7a f6 00 00    	add    $0xf67a,%ebx
  10198c:	83 ec 08             	sub    $0x8,%esp
    sti();
  10198f:	e8 dc 32 00 00       	call   104c70 <sti>
}
  101994:	83 c4 08             	add    $0x8,%esp
  101997:	5b                   	pop    %ebx
  101998:	c3                   	ret    
  101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001019a0 <intr_local_disable>:

void intr_local_disable(void)
{
  1019a0:	53                   	push   %ebx
  1019a1:	e8 e3 e9 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1019a6:	81 c3 5a f6 00 00    	add    $0xf65a,%ebx
  1019ac:	83 ec 08             	sub    $0x8,%esp
    cli();
  1019af:	e8 ac 32 00 00       	call   104c60 <cli>
}
  1019b4:	83 c4 08             	add    $0x8,%esp
  1019b7:	5b                   	pop    %ebx
  1019b8:	c3                   	ret    
  1019b9:	66 90                	xchg   %ax,%ax
  1019bb:	66 90                	xchg   %ax,%ax
  1019bd:	66 90                	xchg   %ax,%ax
  1019bf:	90                   	nop

001019c0 <pic_init>:
static uint16_t irqmask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool pic_inited = FALSE;

/* Initialize the 8259A interrupt controllers. */
void pic_init(void)
{
  1019c0:	53                   	push   %ebx
  1019c1:	e8 c3 e9 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1019c6:	81 c3 3a f6 00 00    	add    $0xf63a,%ebx
  1019cc:	83 ec 08             	sub    $0x8,%esp
    if (pic_inited == TRUE)  // only do once on bootstrap CPU
  1019cf:	80 bb 81 88 02 00 01 	cmpb   $0x1,0x28881(%ebx)
  1019d6:	0f 84 df 00 00 00    	je     101abb <pic_init+0xfb>
        return;
    pic_inited = TRUE;

    /* mask all interrupts */
    outb(IO_PIC1 + 1, 0xff);
  1019dc:	83 ec 08             	sub    $0x8,%esp
    pic_inited = TRUE;
  1019df:	c6 83 81 88 02 00 01 	movb   $0x1,0x28881(%ebx)
    outb(IO_PIC1 + 1, 0xff);
  1019e6:	68 ff 00 00 00       	push   $0xff
  1019eb:	6a 21                	push   $0x21
  1019ed:	e8 8e 34 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, 0xff);
  1019f2:	58                   	pop    %eax
  1019f3:	5a                   	pop    %edx
  1019f4:	68 ff 00 00 00       	push   $0xff
  1019f9:	68 a1 00 00 00       	push   $0xa1
  1019fe:	e8 7d 34 00 00       	call   104e80 <outb>

    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);
  101a03:	59                   	pop    %ecx
  101a04:	58                   	pop    %eax
  101a05:	6a 11                	push   $0x11
  101a07:	6a 20                	push   $0x20
  101a09:	e8 72 34 00 00       	call   104e80 <outb>

    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, T_IRQ0);
  101a0e:	58                   	pop    %eax
  101a0f:	5a                   	pop    %edx
  101a10:	6a 20                	push   $0x20
  101a12:	6a 21                	push   $0x21
  101a14:	e8 67 34 00 00       	call   104e80 <outb>

    // ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
    //        3-bit No of IR line at which slave connects to master (slave PIC).
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
  101a19:	59                   	pop    %ecx
  101a1a:	58                   	pop    %eax
  101a1b:	6a 04                	push   $0x4
  101a1d:	6a 21                	push   $0x21
  101a1f:	e8 5c 34 00 00       	call   104e80 <outb>
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //        can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x1);
  101a24:	58                   	pop    %eax
  101a25:	5a                   	pop    %edx
  101a26:	6a 01                	push   $0x1
  101a28:	6a 21                	push   $0x21
  101a2a:	e8 51 34 00 00       	call   104e80 <outb>

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);            // ICW1
  101a2f:	59                   	pop    %ecx
  101a30:	58                   	pop    %eax
  101a31:	6a 11                	push   $0x11
  101a33:	68 a0 00 00 00       	push   $0xa0
  101a38:	e8 43 34 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, T_IRQ0 + 8);  // ICW2
  101a3d:	58                   	pop    %eax
  101a3e:	5a                   	pop    %edx
  101a3f:	6a 28                	push   $0x28
  101a41:	68 a1 00 00 00       	push   $0xa1
  101a46:	e8 35 34 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
  101a4b:	59                   	pop    %ecx
  101a4c:	58                   	pop    %eax
  101a4d:	6a 02                	push   $0x2
  101a4f:	68 a1 00 00 00       	push   $0xa1
  101a54:	e8 27 34 00 00       	call   104e80 <outb>
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x01);        // ICW4
  101a59:	58                   	pop    %eax
  101a5a:	5a                   	pop    %edx
  101a5b:	6a 01                	push   $0x1
  101a5d:	68 a1 00 00 00       	push   $0xa1
  101a62:	e8 19 34 00 00       	call   104e80 <outb>

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);  /* clear specific mask */
  101a67:	59                   	pop    %ecx
  101a68:	58                   	pop    %eax
  101a69:	6a 68                	push   $0x68
  101a6b:	6a 20                	push   $0x20
  101a6d:	e8 0e 34 00 00       	call   104e80 <outb>
    outb(IO_PIC1, 0x0a);  /* read IRR by default */
  101a72:	58                   	pop    %eax
  101a73:	5a                   	pop    %edx
  101a74:	6a 0a                	push   $0xa
  101a76:	6a 20                	push   $0x20
  101a78:	e8 03 34 00 00       	call   104e80 <outb>

    outb(IO_PIC2, 0x68);  /* OCW3 */
  101a7d:	59                   	pop    %ecx
  101a7e:	58                   	pop    %eax
  101a7f:	6a 68                	push   $0x68
  101a81:	68 a0 00 00 00       	push   $0xa0
  101a86:	e8 f5 33 00 00       	call   104e80 <outb>
    outb(IO_PIC2, 0x0a);  /* OCW3 */
  101a8b:	58                   	pop    %eax
  101a8c:	5a                   	pop    %edx
  101a8d:	6a 0a                	push   $0xa
  101a8f:	68 a0 00 00 00       	push   $0xa0
  101a94:	e8 e7 33 00 00       	call   104e80 <outb>

    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
  101a99:	59                   	pop    %ecx
  101a9a:	58                   	pop    %eax
  101a9b:	68 ff 00 00 00       	push   $0xff
  101aa0:	6a 21                	push   $0x21
  101aa2:	e8 d9 33 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, 0xFF);
  101aa7:	58                   	pop    %eax
  101aa8:	5a                   	pop    %edx
  101aa9:	68 ff 00 00 00       	push   $0xff
  101aae:	68 a1 00 00 00       	push   $0xa1
  101ab3:	e8 c8 33 00 00       	call   104e80 <outb>
  101ab8:	83 c4 10             	add    $0x10,%esp
}
  101abb:	83 c4 08             	add    $0x8,%esp
  101abe:	5b                   	pop    %ebx
  101abf:	c3                   	ret    

00101ac0 <pic_setmask>:

void pic_setmask(uint16_t mask)
{
  101ac0:	56                   	push   %esi
  101ac1:	53                   	push   %ebx
  101ac2:	e8 c2 e8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101ac7:	81 c3 39 f5 00 00    	add    $0xf539,%ebx
  101acd:	83 ec 0c             	sub    $0xc,%esp
  101ad0:	8b 74 24 18          	mov    0x18(%esp),%esi
    irqmask = mask;
    outb(IO_PIC1 + 1, (char) mask);
  101ad4:	89 f0                	mov    %esi,%eax
  101ad6:	0f b6 c0             	movzbl %al,%eax
    irqmask = mask;
  101ad9:	66 89 b3 26 03 00 00 	mov    %si,0x326(%ebx)
    outb(IO_PIC1 + 1, (char) mask);
  101ae0:	50                   	push   %eax
  101ae1:	6a 21                	push   $0x21
  101ae3:	e8 98 33 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  101ae8:	58                   	pop    %eax
  101ae9:	89 f0                	mov    %esi,%eax
  101aeb:	5a                   	pop    %edx
  101aec:	0f b6 f4             	movzbl %ah,%esi
  101aef:	56                   	push   %esi
  101af0:	68 a1 00 00 00       	push   $0xa1
  101af5:	e8 86 33 00 00       	call   104e80 <outb>
}
  101afa:	83 c4 14             	add    $0x14,%esp
  101afd:	5b                   	pop    %ebx
  101afe:	5e                   	pop    %esi
  101aff:	c3                   	ret    

00101b00 <pic_enable>:

void pic_enable(int irq)
{
  101b00:	56                   	push   %esi
  101b01:	53                   	push   %ebx
  101b02:	e8 82 e8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101b07:	81 c3 f9 f4 00 00    	add    $0xf4f9,%ebx
  101b0d:	83 ec 0c             	sub    $0xc,%esp
    pic_setmask(irqmask & ~(1 << irq));
  101b10:	8b 44 24 18          	mov    0x18(%esp),%eax
  101b14:	0f b7 b3 26 03 00 00 	movzwl 0x326(%ebx),%esi
  101b1b:	0f b3 c6             	btr    %eax,%esi
    outb(IO_PIC1 + 1, (char) mask);
  101b1e:	89 f0                	mov    %esi,%eax
    irqmask = mask;
  101b20:	66 89 b3 26 03 00 00 	mov    %si,0x326(%ebx)
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  101b27:	66 c1 ee 08          	shr    $0x8,%si
    outb(IO_PIC1 + 1, (char) mask);
  101b2b:	0f b6 c0             	movzbl %al,%eax
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  101b2e:	0f b7 f6             	movzwl %si,%esi
    outb(IO_PIC1 + 1, (char) mask);
  101b31:	50                   	push   %eax
  101b32:	6a 21                	push   $0x21
  101b34:	e8 47 33 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  101b39:	58                   	pop    %eax
  101b3a:	5a                   	pop    %edx
  101b3b:	56                   	push   %esi
  101b3c:	68 a1 00 00 00       	push   $0xa1
  101b41:	e8 3a 33 00 00       	call   104e80 <outb>
}
  101b46:	83 c4 14             	add    $0x14,%esp
  101b49:	5b                   	pop    %ebx
  101b4a:	5e                   	pop    %esi
  101b4b:	c3                   	ret    
  101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101b50 <pic_eoi>:

void pic_eoi(void)
{
  101b50:	53                   	push   %ebx
  101b51:	e8 33 e8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101b56:	81 c3 aa f4 00 00    	add    $0xf4aa,%ebx
  101b5c:	83 ec 10             	sub    $0x10,%esp
    // OCW2: rse00xxx
    //   r: rotate
    //   s: specific
    //   e: end-of-interrupt
    // xxx: specific interrupt line
    outb(IO_PIC1, 0x20);
  101b5f:	6a 20                	push   $0x20
  101b61:	6a 20                	push   $0x20
  101b63:	e8 18 33 00 00       	call   104e80 <outb>
    outb(IO_PIC2, 0x20);
  101b68:	58                   	pop    %eax
  101b69:	5a                   	pop    %edx
  101b6a:	6a 20                	push   $0x20
  101b6c:	68 a0 00 00 00       	push   $0xa0
  101b71:	e8 0a 33 00 00       	call   104e80 <outb>
}
  101b76:	83 c4 18             	add    $0x18,%esp
  101b79:	5b                   	pop    %ebx
  101b7a:	c3                   	ret    
  101b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101b7f:	90                   	nop

00101b80 <pic_reset>:

void pic_reset(void)
{
  101b80:	53                   	push   %ebx
  101b81:	e8 03 e8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101b86:	81 c3 7a f4 00 00    	add    $0xf47a,%ebx
  101b8c:	83 ec 10             	sub    $0x10,%esp
    // mask all interrupts
    outb(IO_PIC1 + 1, 0x00);
  101b8f:	6a 00                	push   $0x0
  101b91:	6a 21                	push   $0x21
  101b93:	e8 e8 32 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, 0x00);
  101b98:	58                   	pop    %eax
  101b99:	5a                   	pop    %edx
  101b9a:	6a 00                	push   $0x0
  101b9c:	68 a1 00 00 00       	push   $0xa1
  101ba1:	e8 da 32 00 00       	call   104e80 <outb>

    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);
  101ba6:	59                   	pop    %ecx
  101ba7:	58                   	pop    %eax
  101ba8:	6a 11                	push   $0x11
  101baa:	6a 20                	push   $0x20
  101bac:	e8 cf 32 00 00       	call   104e80 <outb>

    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, T_IRQ0);
  101bb1:	58                   	pop    %eax
  101bb2:	5a                   	pop    %edx
  101bb3:	6a 20                	push   $0x20
  101bb5:	6a 21                	push   $0x21
  101bb7:	e8 c4 32 00 00       	call   104e80 <outb>

    // ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
    //        3-bit No of IR line at which slave connects to master(slave PIC).
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
  101bbc:	59                   	pop    %ecx
  101bbd:	58                   	pop    %eax
  101bbe:	6a 04                	push   $0x4
  101bc0:	6a 21                	push   $0x21
  101bc2:	e8 b9 32 00 00       	call   104e80 <outb>
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //        can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x3);
  101bc7:	58                   	pop    %eax
  101bc8:	5a                   	pop    %edx
  101bc9:	6a 03                	push   $0x3
  101bcb:	6a 21                	push   $0x21
  101bcd:	e8 ae 32 00 00       	call   104e80 <outb>

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);            // ICW1
  101bd2:	59                   	pop    %ecx
  101bd3:	58                   	pop    %eax
  101bd4:	6a 11                	push   $0x11
  101bd6:	68 a0 00 00 00       	push   $0xa0
  101bdb:	e8 a0 32 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, T_IRQ0 + 8);  // ICW2
  101be0:	58                   	pop    %eax
  101be1:	5a                   	pop    %edx
  101be2:	6a 28                	push   $0x28
  101be4:	68 a1 00 00 00       	push   $0xa1
  101be9:	e8 92 32 00 00       	call   104e80 <outb>
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
  101bee:	59                   	pop    %ecx
  101bef:	58                   	pop    %eax
  101bf0:	6a 02                	push   $0x2
  101bf2:	68 a1 00 00 00       	push   $0xa1
  101bf7:	e8 84 32 00 00       	call   104e80 <outb>
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x01);        // ICW4
  101bfc:	58                   	pop    %eax
  101bfd:	5a                   	pop    %edx
  101bfe:	6a 01                	push   $0x1
  101c00:	68 a1 00 00 00       	push   $0xa1
  101c05:	e8 76 32 00 00       	call   104e80 <outb>

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);  /* clear specific mask */
  101c0a:	59                   	pop    %ecx
  101c0b:	58                   	pop    %eax
  101c0c:	6a 68                	push   $0x68
  101c0e:	6a 20                	push   $0x20
  101c10:	e8 6b 32 00 00       	call   104e80 <outb>
    outb(IO_PIC1, 0x0a);  /* read IRR by default */
  101c15:	58                   	pop    %eax
  101c16:	5a                   	pop    %edx
  101c17:	6a 0a                	push   $0xa
  101c19:	6a 20                	push   $0x20
  101c1b:	e8 60 32 00 00       	call   104e80 <outb>

    outb(IO_PIC2, 0x68);  /* OCW3 */
  101c20:	59                   	pop    %ecx
  101c21:	58                   	pop    %eax
  101c22:	6a 68                	push   $0x68
  101c24:	68 a0 00 00 00       	push   $0xa0
  101c29:	e8 52 32 00 00       	call   104e80 <outb>
    outb(IO_PIC2, 0x0a);  /* OCW3 */
  101c2e:	58                   	pop    %eax
  101c2f:	5a                   	pop    %edx
  101c30:	6a 0a                	push   $0xa
  101c32:	68 a0 00 00 00       	push   $0xa0
  101c37:	e8 44 32 00 00       	call   104e80 <outb>
}
  101c3c:	83 c4 18             	add    $0x18,%esp
  101c3f:	5b                   	pop    %ebx
  101c40:	c3                   	ret    
  101c41:	66 90                	xchg   %ax,%ax
  101c43:	66 90                	xchg   %ax,%ax
  101c45:	66 90                	xchg   %ax,%ax
  101c47:	66 90                	xchg   %ax,%ax
  101c49:	66 90                	xchg   %ax,%ax
  101c4b:	66 90                	xchg   %ax,%ax
  101c4d:	66 90                	xchg   %ax,%ax
  101c4f:	90                   	nop

00101c50 <timer_hw_init>:
#define TIMER_16BIT   0x30  /* r/w counter 16 bits, LSB first */

// Initialize the programmable interval timer.

void timer_hw_init(void)
{
  101c50:	53                   	push   %ebx
  101c51:	e8 33 e7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101c56:	81 c3 aa f3 00 00    	add    $0xf3aa,%ebx
  101c5c:	83 ec 10             	sub    $0x10,%esp
    outb(PIT_CONTROL, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  101c5f:	6a 34                	push   $0x34
  101c61:	6a 43                	push   $0x43
  101c63:	e8 18 32 00 00       	call   104e80 <outb>
    outb(PIT_CHANNEL0, LOW8(LATCH));
  101c68:	58                   	pop    %eax
  101c69:	5a                   	pop    %edx
  101c6a:	68 9c 00 00 00       	push   $0x9c
  101c6f:	6a 40                	push   $0x40
  101c71:	e8 0a 32 00 00       	call   104e80 <outb>
    outb(PIT_CHANNEL0, HIGH8(LATCH));
  101c76:	59                   	pop    %ecx
  101c77:	58                   	pop    %eax
  101c78:	6a 2e                	push   $0x2e
  101c7a:	6a 40                	push   $0x40
  101c7c:	e8 ff 31 00 00       	call   104e80 <outb>
}
  101c81:	83 c4 18             	add    $0x18,%esp
  101c84:	5b                   	pop    %ebx
  101c85:	c3                   	ret    
  101c86:	66 90                	xchg   %ax,%ax
  101c88:	66 90                	xchg   %ax,%ax
  101c8a:	66 90                	xchg   %ax,%ax
  101c8c:	66 90                	xchg   %ax,%ax
  101c8e:	66 90                	xchg   %ax,%ax

00101c90 <tsc_init>:
    delta = t2 - t1;
    return delta / ms;
}

int tsc_init(void)
{
  101c90:	55                   	push   %ebp
  101c91:	57                   	push   %edi
  101c92:	56                   	push   %esi
  101c93:	53                   	push   %ebx
  101c94:	e8 f0 e6 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  101c99:	81 c3 67 f3 00 00    	add    $0xf367,%ebx
  101c9f:	83 ec 4c             	sub    $0x4c,%esp
    uint64_t ret;
    int i;

    timer_hw_init();
  101ca2:	e8 a9 ff ff ff       	call   101c50 <timer_hw_init>

    tsc_per_ms = 0;
  101ca7:	c7 83 88 88 02 00 00 	movl   $0x0,0x28888(%ebx)
  101cae:	00 00 00 
  101cb1:	c7 83 8c 88 02 00 00 	movl   $0x0,0x2888c(%ebx)
  101cb8:	00 00 00 

    if (detect_kvm())
  101cbb:	e8 70 1e 00 00       	call   103b30 <detect_kvm>
  101cc0:	89 44 24 3c          	mov    %eax,0x3c(%esp)
  101cc4:	85 c0                	test   %eax,%eax
  101cc6:	0f 85 c1 02 00 00    	jne    101f8d <tsc_init+0x2fd>
  101ccc:	8d 83 90 84 ff ff    	lea    -0x7b70(%ebx),%eax

    /*
     * XXX: If TSC calibration fails frequently, try to increase the
     *      upper bound of loop condition, e.g. alternating 3 to 10.
     */
    for (i = 0; i < 10; i++) {
  101cd2:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
  101cd9:	00 
  101cda:	89 44 24 34          	mov    %eax,0x34(%esp)
  101cde:	8d 83 b5 84 ff ff    	lea    -0x7b4b(%ebx),%eax
  101ce4:	89 44 24 30          	mov    %eax,0x30(%esp)
        ret = tsc_calibrate(CAL_LATCH, CAL_MS, CAL_PIT_LOOPS);
        if (ret != ~(uint64_t) 0x0)
            break;
        KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i + 1);
  101ce8:	8d 83 dd 84 ff ff    	lea    -0x7b23(%ebx),%eax
  101cee:	89 44 24 38          	mov    %eax,0x38(%esp)
  101cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  101cf8:	83 ec 0c             	sub    $0xc,%esp
  101cfb:	6a 61                	push   $0x61
  101cfd:	e8 4e 31 00 00       	call   104e50 <inb>
  101d02:	5e                   	pop    %esi
  101d03:	5f                   	pop    %edi
  101d04:	25 fc 00 00 00       	and    $0xfc,%eax
  101d09:	83 c8 01             	or     $0x1,%eax
  101d0c:	50                   	push   %eax
  101d0d:	6a 61                	push   $0x61
  101d0f:	e8 6c 31 00 00       	call   104e80 <outb>
    outb(0x43, 0xb0);
  101d14:	5d                   	pop    %ebp
  101d15:	58                   	pop    %eax
  101d16:	68 b0 00 00 00       	push   $0xb0
  101d1b:	6a 43                	push   $0x43
    pitcnt = 0;
  101d1d:	31 ed                	xor    %ebp,%ebp
    outb(0x43, 0xb0);
  101d1f:	e8 5c 31 00 00       	call   104e80 <outb>
    outb(0x42, latch & 0xff);
  101d24:	58                   	pop    %eax
  101d25:	5a                   	pop    %edx
  101d26:	68 9b 00 00 00       	push   $0x9b
  101d2b:	6a 42                	push   $0x42
  101d2d:	e8 4e 31 00 00       	call   104e80 <outb>
    outb(0x42, latch >> 8);
  101d32:	59                   	pop    %ecx
  101d33:	5e                   	pop    %esi
  101d34:	6a 2e                	push   $0x2e
  101d36:	6a 42                	push   $0x42
  101d38:	e8 43 31 00 00       	call   104e80 <outb>
    tsc = t1 = t2 = rdtsc();
  101d3d:	e8 ae 2f 00 00       	call   104cf0 <rdtsc>
  101d42:	89 44 24 38          	mov    %eax,0x38(%esp)
  101d46:	89 54 24 3c          	mov    %edx,0x3c(%esp)
    while ((inb(0x61) & 0x20) == 0) {
  101d4a:	83 c4 10             	add    $0x10,%esp
    tsc = t1 = t2 = rdtsc();
  101d4d:	89 44 24 18          	mov    %eax,0x18(%esp)
  101d51:	89 54 24 1c          	mov    %edx,0x1c(%esp)
    tscmax = 0;
  101d55:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  101d5c:	00 
  101d5d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  101d64:	00 
    tscmin = ~(uint64_t) 0x0;
  101d65:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
  101d6c:	ff 
  101d6d:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  101d74:	ff 
    while ((inb(0x61) & 0x20) == 0) {
  101d75:	eb 63                	jmp    101dda <tsc_init+0x14a>
  101d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101d7e:	66 90                	xchg   %ax,%ax
        t2 = rdtsc();
  101d80:	e8 6b 2f 00 00       	call   104cf0 <rdtsc>
        delta = t2 - tsc;
  101d85:	89 c6                	mov    %eax,%esi
  101d87:	89 d7                	mov    %edx,%edi
  101d89:	2b 74 24 18          	sub    0x18(%esp),%esi
  101d8d:	1b 7c 24 1c          	sbb    0x1c(%esp),%edi
        if (delta < tscmin)
  101d91:	89 f9                	mov    %edi,%ecx
  101d93:	3b 74 24 08          	cmp    0x8(%esp),%esi
  101d97:	1b 4c 24 0c          	sbb    0xc(%esp),%ecx
        tsc = t2;
  101d9b:	89 44 24 18          	mov    %eax,0x18(%esp)
  101d9f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  101da3:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  101da7:	0f 42 ce             	cmovb  %esi,%ecx
  101daa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  101dae:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  101db2:	0f 42 cf             	cmovb  %edi,%ecx
  101db5:	39 74 24 10          	cmp    %esi,0x10(%esp)
  101db9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        if (delta > tscmax)
  101dbd:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  101dc1:	19 f9                	sbb    %edi,%ecx
  101dc3:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  101dc7:	0f 43 7c 24 14       	cmovae 0x14(%esp),%edi
  101dcc:	0f 42 ce             	cmovb  %esi,%ecx
  101dcf:	89 7c 24 14          	mov    %edi,0x14(%esp)
        pitcnt++;
  101dd3:	83 c5 01             	add    $0x1,%ebp
  101dd6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    while ((inb(0x61) & 0x20) == 0) {
  101dda:	83 ec 0c             	sub    $0xc,%esp
  101ddd:	6a 61                	push   $0x61
  101ddf:	e8 6c 30 00 00       	call   104e50 <inb>
  101de4:	83 c4 10             	add    $0x10,%esp
  101de7:	a8 20                	test   $0x20,%al
  101de9:	74 95                	je     101d80 <tsc_init+0xf0>
    KERN_DEBUG("pitcnt=%u, tscmin=%llu, tscmax=%llu\n",
  101deb:	8b 74 24 10          	mov    0x10(%esp),%esi
  101def:	8b 7c 24 14          	mov    0x14(%esp),%edi
  101df3:	57                   	push   %edi
  101df4:	56                   	push   %esi
  101df5:	ff 74 24 14          	push   0x14(%esp)
  101df9:	ff 74 24 14          	push   0x14(%esp)
  101dfd:	55                   	push   %ebp
  101dfe:	ff 74 24 48          	push   0x48(%esp)
  101e02:	6a 39                	push   $0x39
  101e04:	ff 74 24 4c          	push   0x4c(%esp)
  101e08:	e8 e3 21 00 00       	call   103ff0 <debug_normal>
    if (pitcnt < loopmin || tscmax > 10 * tscmin)
  101e0d:	83 c4 20             	add    $0x20,%esp
  101e10:	81 fd e7 03 00 00    	cmp    $0x3e7,%ebp
  101e16:	0f 8e f4 00 00 00    	jle    101f10 <tsc_init+0x280>
  101e1c:	6b 4c 24 0c 0a       	imul   $0xa,0xc(%esp),%ecx
  101e21:	b8 0a 00 00 00       	mov    $0xa,%eax
  101e26:	f7 64 24 08          	mull   0x8(%esp)
  101e2a:	01 ca                	add    %ecx,%edx
  101e2c:	39 f0                	cmp    %esi,%eax
  101e2e:	89 d0                	mov    %edx,%eax
  101e30:	19 f8                	sbb    %edi,%eax
  101e32:	0f 82 d8 00 00 00    	jb     101f10 <tsc_init+0x280>
    delta = t2 - t1;
  101e38:	8b 44 24 18          	mov    0x18(%esp),%eax
  101e3c:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    return delta / ms;
  101e40:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    delta = t2 - t1;
  101e45:	2b 44 24 28          	sub    0x28(%esp),%eax
  101e49:	1b 54 24 2c          	sbb    0x2c(%esp),%edx
    return delta / ms;
  101e4d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  101e51:	89 c6                	mov    %eax,%esi
  101e53:	03 74 24 0c          	add    0xc(%esp),%esi
  101e57:	83 d6 00             	adc    $0x0,%esi
  101e5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101e5e:	89 f0                	mov    %esi,%eax
  101e60:	f7 e1                	mul    %ecx
  101e62:	8b 44 24 08          	mov    0x8(%esp),%eax
  101e66:	89 d7                	mov    %edx,%edi
  101e68:	83 e2 fc             	and    $0xfffffffc,%edx
  101e6b:	c1 ef 02             	shr    $0x2,%edi
  101e6e:	01 fa                	add    %edi,%edx
  101e70:	31 ff                	xor    %edi,%edi
  101e72:	29 d6                	sub    %edx,%esi
  101e74:	8b 54 24 0c          	mov    0xc(%esp),%edx
  101e78:	29 f0                	sub    %esi,%eax
  101e7a:	19 fa                	sbb    %edi,%edx

        timer_hw_init();
        return 1;
    } else {
        tsc_per_ms = ret;
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  101e7c:	83 ec 10             	sub    $0x10,%esp
    return delta / ms;
  101e7f:	69 f2 cd cc cc cc    	imul   $0xcccccccd,%edx,%esi
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  101e85:	6a 00                	push   $0x0
    return delta / ms;
  101e87:	69 d0 cc cc cc cc    	imul   $0xcccccccc,%eax,%edx
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  101e8d:	68 e8 03 00 00       	push   $0x3e8
    return delta / ms;
  101e92:	01 d6                	add    %edx,%esi
  101e94:	f7 e1                	mul    %ecx
  101e96:	01 f2                	add    %esi,%edx
  101e98:	0f ac d0 01          	shrd   $0x1,%edx,%eax
  101e9c:	d1 ea                	shr    %edx
        tsc_per_ms = ret;
  101e9e:	89 83 88 88 02 00    	mov    %eax,0x28888(%ebx)
  101ea4:	89 93 8c 88 02 00    	mov    %edx,0x2888c(%ebx)
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  101eaa:	8b 83 88 88 02 00    	mov    0x28888(%ebx),%eax
  101eb0:	8b 93 8c 88 02 00    	mov    0x2888c(%ebx),%edx
  101eb6:	8b b3 88 88 02 00    	mov    0x28888(%ebx),%esi
  101ebc:	8b bb 8c 88 02 00    	mov    0x2888c(%ebx),%edi
  101ec2:	52                   	push   %edx
  101ec3:	50                   	push   %eax
  101ec4:	e8 e7 69 00 00       	call   1088b0 <__umoddi3>
  101ec9:	83 c4 1c             	add    $0x1c,%esp
  101ecc:	52                   	push   %edx
  101ecd:	50                   	push   %eax
  101ece:	83 ec 04             	sub    $0x4,%esp
  101ed1:	6a 00                	push   $0x0
  101ed3:	68 e8 03 00 00       	push   $0x3e8
  101ed8:	57                   	push   %edi
  101ed9:	56                   	push   %esi
  101eda:	e8 b1 68 00 00       	call   108790 <__udivdi3>
  101edf:	83 c4 14             	add    $0x14,%esp
  101ee2:	52                   	push   %edx
  101ee3:	50                   	push   %eax
  101ee4:	8d 83 c4 84 ff ff    	lea    -0x7b3c(%ebx),%eax
  101eea:	50                   	push   %eax
  101eeb:	6a 68                	push   $0x68
  101eed:	ff 74 24 4c          	push   0x4c(%esp)
  101ef1:	e8 fa 20 00 00       	call   103ff0 <debug_normal>

        timer_hw_init();
  101ef6:	83 c4 20             	add    $0x20,%esp
  101ef9:	e8 52 fd ff ff       	call   101c50 <timer_hw_init>
        return 0;
    }
}
  101efe:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  101f02:	83 c4 4c             	add    $0x4c,%esp
  101f05:	5b                   	pop    %ebx
  101f06:	5e                   	pop    %esi
  101f07:	5f                   	pop    %edi
  101f08:	5d                   	pop    %ebp
  101f09:	c3                   	ret    
  101f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i + 1);
  101f10:	83 44 24 24 01       	addl   $0x1,0x24(%esp)
  101f15:	8b 7c 24 24          	mov    0x24(%esp),%edi
  101f19:	57                   	push   %edi
  101f1a:	ff 74 24 3c          	push   0x3c(%esp)
  101f1e:	6a 5c                	push   $0x5c
  101f20:	ff 74 24 3c          	push   0x3c(%esp)
  101f24:	e8 c7 20 00 00       	call   103ff0 <debug_normal>
    for (i = 0; i < 10; i++) {
  101f29:	83 c4 10             	add    $0x10,%esp
  101f2c:	83 ff 0a             	cmp    $0xa,%edi
  101f2f:	0f 85 c3 fd ff ff    	jne    101cf8 <tsc_init+0x68>
        KERN_DEBUG("TSC calibration failed.\n");
  101f35:	83 ec 04             	sub    $0x4,%esp
  101f38:	8d 83 fb 84 ff ff    	lea    -0x7b05(%ebx),%eax
  101f3e:	50                   	push   %eax
  101f3f:	6a 60                	push   $0x60
  101f41:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  101f45:	57                   	push   %edi
  101f46:	e8 a5 20 00 00       	call   103ff0 <debug_normal>
        KERN_DEBUG("Assume TSC freq = 1 GHz.\n");
  101f4b:	83 c4 0c             	add    $0xc,%esp
  101f4e:	8d 83 14 85 ff ff    	lea    -0x7aec(%ebx),%eax
  101f54:	50                   	push   %eax
  101f55:	6a 61                	push   $0x61
  101f57:	57                   	push   %edi
  101f58:	e8 93 20 00 00       	call   103ff0 <debug_normal>
        tsc_per_ms = 1000000;
  101f5d:	c7 83 88 88 02 00 40 	movl   $0xf4240,0x28888(%ebx)
  101f64:	42 0f 00 
  101f67:	c7 83 8c 88 02 00 00 	movl   $0x0,0x2888c(%ebx)
  101f6e:	00 00 00 
        timer_hw_init();
  101f71:	e8 da fc ff ff       	call   101c50 <timer_hw_init>
        return 1;
  101f76:	83 c4 10             	add    $0x10,%esp
  101f79:	c7 44 24 3c 01 00 00 	movl   $0x1,0x3c(%esp)
  101f80:	00 
}
  101f81:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  101f85:	83 c4 4c             	add    $0x4c,%esp
  101f88:	5b                   	pop    %ebx
  101f89:	5e                   	pop    %esi
  101f8a:	5f                   	pop    %edi
  101f8b:	5d                   	pop    %ebp
  101f8c:	c3                   	ret    
		tsc_per_ms = kvm_get_tsc_hz() / 1000llu;
  101f8d:	e8 de 1c 00 00       	call   103c70 <kvm_get_tsc_hz>
  101f92:	6a 00                	push   $0x0
  101f94:	68 e8 03 00 00       	push   $0x3e8
  101f99:	52                   	push   %edx
  101f9a:	50                   	push   %eax
  101f9b:	e8 f0 67 00 00       	call   108790 <__udivdi3>
		KERN_INFO ("TSC read from KVM: %u.%03u MHz.\n",
  101fa0:	6a 00                	push   $0x0
		tsc_per_ms = kvm_get_tsc_hz() / 1000llu;
  101fa2:	89 83 88 88 02 00    	mov    %eax,0x28888(%ebx)
  101fa8:	89 93 8c 88 02 00    	mov    %edx,0x2888c(%ebx)
		KERN_INFO ("TSC read from KVM: %u.%03u MHz.\n",
  101fae:	8b 83 88 88 02 00    	mov    0x28888(%ebx),%eax
  101fb4:	8b 93 8c 88 02 00    	mov    0x2888c(%ebx),%edx
  101fba:	68 e8 03 00 00       	push   $0x3e8
  101fbf:	8b b3 88 88 02 00    	mov    0x28888(%ebx),%esi
  101fc5:	8b bb 8c 88 02 00    	mov    0x2888c(%ebx),%edi
  101fcb:	52                   	push   %edx
  101fcc:	50                   	push   %eax
  101fcd:	e8 de 68 00 00       	call   1088b0 <__umoddi3>
  101fd2:	83 c4 14             	add    $0x14,%esp
  101fd5:	52                   	push   %edx
  101fd6:	50                   	push   %eax
  101fd7:	83 ec 0c             	sub    $0xc,%esp
  101fda:	6a 00                	push   $0x0
  101fdc:	68 e8 03 00 00       	push   $0x3e8
  101fe1:	57                   	push   %edi
  101fe2:	56                   	push   %esi
  101fe3:	e8 a8 67 00 00       	call   108790 <__udivdi3>
  101fe8:	83 c4 1c             	add    $0x1c,%esp
  101feb:	52                   	push   %edx
  101fec:	50                   	push   %eax
  101fed:	8d 83 6c 84 ff ff    	lea    -0x7b94(%ebx),%eax
  101ff3:	50                   	push   %eax
  101ff4:	e8 c7 1f 00 00       	call   103fc0 <debug_info>
		return (0);
  101ff9:	83 c4 20             	add    $0x20,%esp
  101ffc:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  102003:	00 
}
  102004:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  102008:	83 c4 4c             	add    $0x4c,%esp
  10200b:	5b                   	pop    %ebx
  10200c:	5e                   	pop    %esi
  10200d:	5f                   	pop    %edi
  10200e:	5d                   	pop    %ebp
  10200f:	c3                   	ret    

00102010 <delay>:

/*
 * Wait for ms millisecond.
 */
void delay(uint32_t ms)
{
  102010:	55                   	push   %ebp
  102011:	57                   	push   %edi
  102012:	56                   	push   %esi
  102013:	53                   	push   %ebx
  102014:	e8 70 e3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102019:	81 c3 e7 ef 00 00    	add    $0xefe7,%ebx
  10201f:	83 ec 1c             	sub    $0x1c,%esp
  102022:	8b 44 24 30          	mov    0x30(%esp),%eax
    volatile uint64_t ticks = tsc_per_ms * ms;
  102026:	8b b3 88 88 02 00    	mov    0x28888(%ebx),%esi
  10202c:	8b 8b 8c 88 02 00    	mov    0x2888c(%ebx),%ecx
  102032:	0f af c8             	imul   %eax,%ecx
  102035:	f7 e6                	mul    %esi
  102037:	01 ca                	add    %ecx,%edx
  102039:	89 04 24             	mov    %eax,(%esp)
  10203c:	89 54 24 04          	mov    %edx,0x4(%esp)
    volatile uint64_t start = rdtsc();
  102040:	e8 ab 2c 00 00       	call   104cf0 <rdtsc>
  102045:	89 44 24 08          	mov    %eax,0x8(%esp)
  102049:	89 54 24 0c          	mov    %edx,0xc(%esp)
    while (rdtsc() < start + ticks);
  10204d:	8d 76 00             	lea    0x0(%esi),%esi
  102050:	e8 9b 2c 00 00       	call   104cf0 <rdtsc>
  102055:	89 c1                	mov    %eax,%ecx
  102057:	89 d5                	mov    %edx,%ebp
  102059:	8b 44 24 08          	mov    0x8(%esp),%eax
  10205d:	8b 54 24 0c          	mov    0xc(%esp),%edx
  102061:	8b 34 24             	mov    (%esp),%esi
  102064:	8b 7c 24 04          	mov    0x4(%esp),%edi
  102068:	01 f0                	add    %esi,%eax
  10206a:	11 fa                	adc    %edi,%edx
  10206c:	39 c1                	cmp    %eax,%ecx
  10206e:	19 d5                	sbb    %edx,%ebp
  102070:	72 de                	jb     102050 <delay+0x40>
}
  102072:	83 c4 1c             	add    $0x1c,%esp
  102075:	5b                   	pop    %ebx
  102076:	5e                   	pop    %esi
  102077:	5f                   	pop    %edi
  102078:	5d                   	pop    %ebp
  102079:	c3                   	ret    
  10207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102080 <udelay>:

/*
 * Wait for us microsecond.
 */
void udelay(uint32_t us)
{
  102080:	55                   	push   %ebp
  102081:	57                   	push   %edi
  102082:	56                   	push   %esi
  102083:	53                   	push   %ebx
  102084:	e8 00 e3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102089:	81 c3 77 ef 00 00    	add    $0xef77,%ebx
  10208f:	83 ec 1c             	sub    $0x1c,%esp
  102092:	8b 74 24 30          	mov    0x30(%esp),%esi
    volatile uint64_t ticks = tsc_per_ms / 1000 * us;
  102096:	6a 00                	push   $0x0
  102098:	68 e8 03 00 00       	push   $0x3e8
  10209d:	8b 83 88 88 02 00    	mov    0x28888(%ebx),%eax
  1020a3:	8b 93 8c 88 02 00    	mov    0x2888c(%ebx),%edx
  1020a9:	52                   	push   %edx
  1020aa:	50                   	push   %eax
  1020ab:	e8 e0 66 00 00       	call   108790 <__udivdi3>
  1020b0:	83 c4 10             	add    $0x10,%esp
  1020b3:	89 d1                	mov    %edx,%ecx
  1020b5:	f7 e6                	mul    %esi
  1020b7:	0f af ce             	imul   %esi,%ecx
  1020ba:	89 04 24             	mov    %eax,(%esp)
  1020bd:	01 ca                	add    %ecx,%edx
  1020bf:	89 54 24 04          	mov    %edx,0x4(%esp)
    volatile uint64_t start = rdtsc();
  1020c3:	e8 28 2c 00 00       	call   104cf0 <rdtsc>
  1020c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1020cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
    while (rdtsc() < start + ticks);
  1020d0:	e8 1b 2c 00 00       	call   104cf0 <rdtsc>
  1020d5:	89 c1                	mov    %eax,%ecx
  1020d7:	89 d5                	mov    %edx,%ebp
  1020d9:	8b 44 24 08          	mov    0x8(%esp),%eax
  1020dd:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1020e1:	8b 34 24             	mov    (%esp),%esi
  1020e4:	8b 7c 24 04          	mov    0x4(%esp),%edi
  1020e8:	01 f0                	add    %esi,%eax
  1020ea:	11 fa                	adc    %edi,%edx
  1020ec:	39 c1                	cmp    %eax,%ecx
  1020ee:	19 d5                	sbb    %edx,%ebp
  1020f0:	72 de                	jb     1020d0 <udelay+0x50>
}
  1020f2:	83 c4 1c             	add    $0x1c,%esp
  1020f5:	5b                   	pop    %ebx
  1020f6:	5e                   	pop    %esi
  1020f7:	5f                   	pop    %edi
  1020f8:	5d                   	pop    %ebp
  1020f9:	c3                   	ret    
  1020fa:	66 90                	xchg   %ax,%ax
  1020fc:	66 90                	xchg   %ax,%ax
  1020fe:	66 90                	xchg   %ax,%ax

00102100 <Xdivide>:
	jmp	_alltraps

.text

/* exceptions  */
TRAPHANDLER_NOEC(Xdivide,	T_DIVIDE)
  102100:	6a 00                	push   $0x0
  102102:	6a 00                	push   $0x0
  102104:	e9 17 01 00 00       	jmp    102220 <_alltraps>
  102109:	90                   	nop

0010210a <Xdebug>:
TRAPHANDLER_NOEC(Xdebug,	T_DEBUG)
  10210a:	6a 00                	push   $0x0
  10210c:	6a 01                	push   $0x1
  10210e:	e9 0d 01 00 00       	jmp    102220 <_alltraps>
  102113:	90                   	nop

00102114 <Xnmi>:
TRAPHANDLER_NOEC(Xnmi,		T_NMI)
  102114:	6a 00                	push   $0x0
  102116:	6a 02                	push   $0x2
  102118:	e9 03 01 00 00       	jmp    102220 <_alltraps>
  10211d:	90                   	nop

0010211e <Xbrkpt>:
TRAPHANDLER_NOEC(Xbrkpt,	T_BRKPT)
  10211e:	6a 00                	push   $0x0
  102120:	6a 03                	push   $0x3
  102122:	e9 f9 00 00 00       	jmp    102220 <_alltraps>
  102127:	90                   	nop

00102128 <Xoflow>:
TRAPHANDLER_NOEC(Xoflow,	T_OFLOW)
  102128:	6a 00                	push   $0x0
  10212a:	6a 04                	push   $0x4
  10212c:	e9 ef 00 00 00       	jmp    102220 <_alltraps>
  102131:	90                   	nop

00102132 <Xbound>:
TRAPHANDLER_NOEC(Xbound,	T_BOUND)
  102132:	6a 00                	push   $0x0
  102134:	6a 05                	push   $0x5
  102136:	e9 e5 00 00 00       	jmp    102220 <_alltraps>
  10213b:	90                   	nop

0010213c <Xillop>:
TRAPHANDLER_NOEC(Xillop,	T_ILLOP)
  10213c:	6a 00                	push   $0x0
  10213e:	6a 06                	push   $0x6
  102140:	e9 db 00 00 00       	jmp    102220 <_alltraps>
  102145:	90                   	nop

00102146 <Xdevice>:
TRAPHANDLER_NOEC(Xdevice,	T_DEVICE)
  102146:	6a 00                	push   $0x0
  102148:	6a 07                	push   $0x7
  10214a:	e9 d1 00 00 00       	jmp    102220 <_alltraps>
  10214f:	90                   	nop

00102150 <Xdblflt>:
TRAPHANDLER     (Xdblflt,	T_DBLFLT)
  102150:	6a 08                	push   $0x8
  102152:	e9 c9 00 00 00       	jmp    102220 <_alltraps>
  102157:	90                   	nop

00102158 <Xcoproc>:
TRAPHANDLER_NOEC(Xcoproc,	T_COPROC)
  102158:	6a 00                	push   $0x0
  10215a:	6a 09                	push   $0x9
  10215c:	e9 bf 00 00 00       	jmp    102220 <_alltraps>
  102161:	90                   	nop

00102162 <Xtss>:
TRAPHANDLER     (Xtss,		T_TSS)
  102162:	6a 0a                	push   $0xa
  102164:	e9 b7 00 00 00       	jmp    102220 <_alltraps>
  102169:	90                   	nop

0010216a <Xsegnp>:
TRAPHANDLER     (Xsegnp,	T_SEGNP)
  10216a:	6a 0b                	push   $0xb
  10216c:	e9 af 00 00 00       	jmp    102220 <_alltraps>
  102171:	90                   	nop

00102172 <Xstack>:
TRAPHANDLER     (Xstack,	T_STACK)
  102172:	6a 0c                	push   $0xc
  102174:	e9 a7 00 00 00       	jmp    102220 <_alltraps>
  102179:	90                   	nop

0010217a <Xgpflt>:
TRAPHANDLER     (Xgpflt,	T_GPFLT)
  10217a:	6a 0d                	push   $0xd
  10217c:	e9 9f 00 00 00       	jmp    102220 <_alltraps>
  102181:	90                   	nop

00102182 <Xpgflt>:
TRAPHANDLER     (Xpgflt,	T_PGFLT)
  102182:	6a 0e                	push   $0xe
  102184:	e9 97 00 00 00       	jmp    102220 <_alltraps>
  102189:	90                   	nop

0010218a <Xres>:
TRAPHANDLER_NOEC(Xres,		T_RES)
  10218a:	6a 00                	push   $0x0
  10218c:	6a 0f                	push   $0xf
  10218e:	e9 8d 00 00 00       	jmp    102220 <_alltraps>
  102193:	90                   	nop

00102194 <Xfperr>:
TRAPHANDLER_NOEC(Xfperr,	T_FPERR)
  102194:	6a 00                	push   $0x0
  102196:	6a 10                	push   $0x10
  102198:	e9 83 00 00 00       	jmp    102220 <_alltraps>
  10219d:	90                   	nop

0010219e <Xalign>:
TRAPHANDLER     (Xalign,	T_ALIGN)
  10219e:	6a 11                	push   $0x11
  1021a0:	eb 7e                	jmp    102220 <_alltraps>

001021a2 <Xmchk>:
TRAPHANDLER_NOEC(Xmchk,		T_MCHK)
  1021a2:	6a 00                	push   $0x0
  1021a4:	6a 12                	push   $0x12
  1021a6:	eb 78                	jmp    102220 <_alltraps>

001021a8 <Xirq_timer>:

/* ISA interrupts  */
TRAPHANDLER_NOEC(Xirq_timer,	T_IRQ0 + IRQ_TIMER)
  1021a8:	6a 00                	push   $0x0
  1021aa:	6a 20                	push   $0x20
  1021ac:	eb 72                	jmp    102220 <_alltraps>

001021ae <Xirq_kbd>:
TRAPHANDLER_NOEC(Xirq_kbd,	T_IRQ0 + IRQ_KBD)
  1021ae:	6a 00                	push   $0x0
  1021b0:	6a 21                	push   $0x21
  1021b2:	eb 6c                	jmp    102220 <_alltraps>

001021b4 <Xirq_slave>:
TRAPHANDLER_NOEC(Xirq_slave,	T_IRQ0 + IRQ_SLAVE)
  1021b4:	6a 00                	push   $0x0
  1021b6:	6a 22                	push   $0x22
  1021b8:	eb 66                	jmp    102220 <_alltraps>

001021ba <Xirq_serial2>:
TRAPHANDLER_NOEC(Xirq_serial2,	T_IRQ0 + IRQ_SERIAL24)
  1021ba:	6a 00                	push   $0x0
  1021bc:	6a 23                	push   $0x23
  1021be:	eb 60                	jmp    102220 <_alltraps>

001021c0 <Xirq_serial1>:
TRAPHANDLER_NOEC(Xirq_serial1,	T_IRQ0 + IRQ_SERIAL13)
  1021c0:	6a 00                	push   $0x0
  1021c2:	6a 24                	push   $0x24
  1021c4:	eb 5a                	jmp    102220 <_alltraps>

001021c6 <Xirq_lpt>:
TRAPHANDLER_NOEC(Xirq_lpt,	T_IRQ0 + IRQ_LPT2)
  1021c6:	6a 00                	push   $0x0
  1021c8:	6a 25                	push   $0x25
  1021ca:	eb 54                	jmp    102220 <_alltraps>

001021cc <Xirq_floppy>:
TRAPHANDLER_NOEC(Xirq_floppy,	T_IRQ0 + IRQ_FLOPPY)
  1021cc:	6a 00                	push   $0x0
  1021ce:	6a 26                	push   $0x26
  1021d0:	eb 4e                	jmp    102220 <_alltraps>

001021d2 <Xirq_spurious>:
TRAPHANDLER_NOEC(Xirq_spurious,	T_IRQ0 + IRQ_SPURIOUS)
  1021d2:	6a 00                	push   $0x0
  1021d4:	6a 27                	push   $0x27
  1021d6:	eb 48                	jmp    102220 <_alltraps>

001021d8 <Xirq_rtc>:
TRAPHANDLER_NOEC(Xirq_rtc,	T_IRQ0 + IRQ_RTC)
  1021d8:	6a 00                	push   $0x0
  1021da:	6a 28                	push   $0x28
  1021dc:	eb 42                	jmp    102220 <_alltraps>

001021de <Xirq9>:
TRAPHANDLER_NOEC(Xirq9,		T_IRQ0 + 9)
  1021de:	6a 00                	push   $0x0
  1021e0:	6a 29                	push   $0x29
  1021e2:	eb 3c                	jmp    102220 <_alltraps>

001021e4 <Xirq10>:
TRAPHANDLER_NOEC(Xirq10,	T_IRQ0 + 10)
  1021e4:	6a 00                	push   $0x0
  1021e6:	6a 2a                	push   $0x2a
  1021e8:	eb 36                	jmp    102220 <_alltraps>

001021ea <Xirq11>:
TRAPHANDLER_NOEC(Xirq11,	T_IRQ0 + 11)
  1021ea:	6a 00                	push   $0x0
  1021ec:	6a 2b                	push   $0x2b
  1021ee:	eb 30                	jmp    102220 <_alltraps>

001021f0 <Xirq_mouse>:
TRAPHANDLER_NOEC(Xirq_mouse,	T_IRQ0 + IRQ_MOUSE)
  1021f0:	6a 00                	push   $0x0
  1021f2:	6a 2c                	push   $0x2c
  1021f4:	eb 2a                	jmp    102220 <_alltraps>

001021f6 <Xirq_coproc>:
TRAPHANDLER_NOEC(Xirq_coproc,	T_IRQ0 + IRQ_COPROCESSOR)
  1021f6:	6a 00                	push   $0x0
  1021f8:	6a 2d                	push   $0x2d
  1021fa:	eb 24                	jmp    102220 <_alltraps>

001021fc <Xirq_ide1>:
TRAPHANDLER_NOEC(Xirq_ide1,	T_IRQ0 + IRQ_IDE1)
  1021fc:	6a 00                	push   $0x0
  1021fe:	6a 2e                	push   $0x2e
  102200:	eb 1e                	jmp    102220 <_alltraps>

00102202 <Xirq_ide2>:
TRAPHANDLER_NOEC(Xirq_ide2,	T_IRQ0 + IRQ_IDE2)
  102202:	6a 00                	push   $0x0
  102204:	6a 2f                	push   $0x2f
  102206:	eb 18                	jmp    102220 <_alltraps>

00102208 <Xsyscall>:

/* syscall */
TRAPHANDLER_NOEC(Xsyscall,	T_SYSCALL)
  102208:	6a 00                	push   $0x0
  10220a:	6a 30                	push   $0x30
  10220c:	eb 12                	jmp    102220 <_alltraps>

0010220e <Xdefault>:

/* default ? */
TRAPHANDLER     (Xdefault,	T_DEFAULT)
  10220e:	68 fe 00 00 00       	push   $0xfe
  102213:	eb 0b                	jmp    102220 <_alltraps>
  102215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102220 <_alltraps>:

	.globl _alltraps
	.type _alltraps, @function
	.p2align 4, 0x90	/* 16-byte alignment, nop filled */
_alltraps:
	cli			# make sure there is no nested trap
  102220:	fa                   	cli    
	cld
  102221:	fc                   	cld    

	pushl	%ds		# build context
  102222:	1e                   	push   %ds
	pushl	%es
  102223:	06                   	push   %es
	pushal
  102224:	60                   	pusha  

	movl	$CPU_GDT_KDATA, %eax	# load kernel's data segment
  102225:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax, %ds
  10222a:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
  10222c:	8e c0                	mov    %eax,%es

	pushl	%esp		# pass pointer to this trapframe
  10222e:	54                   	push   %esp

	call	trap		# and call trap (does not return)
  10222f:	e8 bc 60 00 00       	call   1082f0 <trap>

1:	hlt			# should never get here; just spin...
  102234:	f4                   	hlt    
  102235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102240 <trap_return>:
//
	.globl trap_return
	.type trap_return, @function
	.p2align 4, 0x90	/* 16-byte alignment, nop filled */
trap_return:
	movl	4(%esp), %esp	// reset stack pointer to point to trap frame
  102240:	8b 64 24 04          	mov    0x4(%esp),%esp
	popal			// restore general-purpose registers except esp
  102244:	61                   	popa   
	popl	%es		// restore data segment registers
  102245:	07                   	pop    %es
	popl	%ds
  102246:	1f                   	pop    %ds
	addl	$8, %esp	// skip tf_trapno and tf_errcode
  102247:	83 c4 08             	add    $0x8,%esp
	iret			// return from trap handler
  10224a:	cf                   	iret   
  10224b:	66 90                	xchg   %ax,%ax
  10224d:	66 90                	xchg   %ax,%ax
  10224f:	90                   	nop

00102250 <acpi_probe_rsdp>:

    return NULL;
}

acpi_rsdp_t *acpi_probe_rsdp(void)
{
  102250:	57                   	push   %edi
  102251:	56                   	push   %esi
  102252:	53                   	push   %ebx
    uint8_t *bda;
    uint32_t p;
    acpi_rsdp_t *rsdp;

    bda = (uint8_t *) 0x400;
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
  102253:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  10225a:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  102261:	c1 e0 08             	shl    $0x8,%eax
  102264:	09 d0                	or     %edx,%eax
  102266:	c1 e0 04             	shl    $0x4,%eax
  102269:	74 4d                	je     1022b8 <acpi_probe_rsdp+0x68>
        if (*(uint32_t *) p == ACPI_RSDP_SIG1 &&
  10226b:	81 38 52 53 44 20    	cmpl   $0x20445352,(%eax)
    e = addr + length;
  102271:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
        if (*(uint32_t *) p == ACPI_RSDP_SIG1 &&
  102277:	74 16                	je     10228f <acpi_probe_rsdp+0x3f>
  102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = addr; p < e; p += 16) {
  102280:	83 c0 10             	add    $0x10,%eax
  102283:	39 c1                	cmp    %eax,%ecx
  102285:	76 31                	jbe    1022b8 <acpi_probe_rsdp+0x68>
        if (*(uint32_t *) p == ACPI_RSDP_SIG1 &&
  102287:	81 38 52 53 44 20    	cmpl   $0x20445352,(%eax)
  10228d:	75 f1                	jne    102280 <acpi_probe_rsdp+0x30>
  10228f:	81 78 04 50 54 52 20 	cmpl   $0x20525450,0x4(%eax)
  102296:	75 e8                	jne    102280 <acpi_probe_rsdp+0x30>
  102298:	89 c2                	mov    %eax,%edx
    sum = 0;
  10229a:	31 db                	xor    %ebx,%ebx
  10229c:	8d 70 24             	lea    0x24(%eax),%esi
  10229f:	90                   	nop
        sum += addr[i];
  1022a0:	0f b6 3a             	movzbl (%edx),%edi
    for (i = 0; i < len; i++) {
  1022a3:	83 c2 01             	add    $0x1,%edx
        sum += addr[i];
  1022a6:	01 fb                	add    %edi,%ebx
    for (i = 0; i < len; i++) {
  1022a8:	39 d6                	cmp    %edx,%esi
  1022aa:	75 f4                	jne    1022a0 <acpi_probe_rsdp+0x50>
            *(uint32_t *) (p + 4) == ACPI_RSDP_SIG2 &&
  1022ac:	84 db                	test   %bl,%bl
  1022ae:	75 d0                	jne    102280 <acpi_probe_rsdp+0x30>
        if ((rsdp = acpi_probe_rsdp_aux((uint8_t *) p, 1024)))
            return rsdp;
    }

    return acpi_probe_rsdp_aux((uint8_t *) 0xE0000, 0x1FFFF);
}
  1022b0:	5b                   	pop    %ebx
  1022b1:	5e                   	pop    %esi
  1022b2:	5f                   	pop    %edi
  1022b3:	c3                   	ret    
  1022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1022b8:	b8 00 00 0e 00       	mov    $0xe0000,%eax
  1022bd:	eb 0b                	jmp    1022ca <acpi_probe_rsdp+0x7a>
  1022bf:	90                   	nop
    for (p = addr; p < e; p += 16) {
  1022c0:	83 c0 10             	add    $0x10,%eax
  1022c3:	3d 00 00 10 00       	cmp    $0x100000,%eax
  1022c8:	74 38                	je     102302 <acpi_probe_rsdp+0xb2>
        if (*(uint32_t *) p == ACPI_RSDP_SIG1 &&
  1022ca:	81 38 52 53 44 20    	cmpl   $0x20445352,(%eax)
  1022d0:	75 ee                	jne    1022c0 <acpi_probe_rsdp+0x70>
  1022d2:	81 78 04 50 54 52 20 	cmpl   $0x20525450,0x4(%eax)
  1022d9:	75 e5                	jne    1022c0 <acpi_probe_rsdp+0x70>
  1022db:	89 c2                	mov    %eax,%edx
    sum = 0;
  1022dd:	31 c9                	xor    %ecx,%ecx
  1022df:	8d 70 24             	lea    0x24(%eax),%esi
  1022e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
  1022e8:	0f b6 1a             	movzbl (%edx),%ebx
    for (i = 0; i < len; i++) {
  1022eb:	83 c2 01             	add    $0x1,%edx
        sum += addr[i];
  1022ee:	01 d9                	add    %ebx,%ecx
    for (i = 0; i < len; i++) {
  1022f0:	39 f2                	cmp    %esi,%edx
  1022f2:	75 f4                	jne    1022e8 <acpi_probe_rsdp+0x98>
            *(uint32_t *) (p + 4) == ACPI_RSDP_SIG2 &&
  1022f4:	84 c9                	test   %cl,%cl
  1022f6:	74 b8                	je     1022b0 <acpi_probe_rsdp+0x60>
    for (p = addr; p < e; p += 16) {
  1022f8:	83 c0 10             	add    $0x10,%eax
  1022fb:	3d 00 00 10 00       	cmp    $0x100000,%eax
  102300:	75 c8                	jne    1022ca <acpi_probe_rsdp+0x7a>
}
  102302:	5b                   	pop    %ebx
    return NULL;
  102303:	31 c0                	xor    %eax,%eax
}
  102305:	5e                   	pop    %esi
  102306:	5f                   	pop    %edi
  102307:	c3                   	ret    
  102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10230f:	90                   	nop

00102310 <acpi_probe_rsdt>:

acpi_rsdt_t *acpi_probe_rsdt(acpi_rsdp_t *rsdp)
{
  102310:	56                   	push   %esi
  102311:	53                   	push   %ebx
  102312:	e8 72 e0 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102317:	81 c3 e9 ec 00 00    	add    $0xece9,%ebx
  10231d:	83 ec 04             	sub    $0x4,%esp
  102320:	8b 74 24 10          	mov    0x10(%esp),%esi
    KERN_ASSERT(rsdp != NULL);
  102324:	85 f6                	test   %esi,%esi
  102326:	74 50                	je     102378 <acpi_probe_rsdt+0x68>

    acpi_rsdt_t *rsdt = (acpi_rsdt_t *) (rsdp->rsdt_addr);
  102328:	8b 5e 10             	mov    0x10(%esi),%ebx
  10232b:	89 d8                	mov    %ebx,%eax
    if (rsdt == NULL)
  10232d:	85 db                	test   %ebx,%ebx
  10232f:	74 2a                	je     10235b <acpi_probe_rsdt+0x4b>
        return NULL;
    if (rsdt->sig == ACPI_RSDT_SIG && sum((uint8_t *) rsdt, rsdt->length) == 0) {
  102331:	81 3b 52 53 44 54    	cmpl   $0x54445352,(%ebx)
  102337:	75 2f                	jne    102368 <acpi_probe_rsdt+0x58>
  102339:	8b 73 04             	mov    0x4(%ebx),%esi
    for (i = 0; i < len; i++) {
  10233c:	85 f6                	test   %esi,%esi
  10233e:	7e 1b                	jle    10235b <acpi_probe_rsdt+0x4b>
  102340:	01 de                	add    %ebx,%esi
    sum = 0;
  102342:	31 d2                	xor    %edx,%edx
  102344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  102348:	0f b6 08             	movzbl (%eax),%ecx
    for (i = 0; i < len; i++) {
  10234b:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
  10234e:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
  102350:	39 c6                	cmp    %eax,%esi
  102352:	75 f4                	jne    102348 <acpi_probe_rsdt+0x38>
        return NULL;
  102354:	31 c0                	xor    %eax,%eax
  102356:	84 d2                	test   %dl,%dl
  102358:	0f 45 d8             	cmovne %eax,%ebx
        return rsdt;
    }

    return NULL;
}
  10235b:	83 c4 04             	add    $0x4,%esp
  10235e:	89 d8                	mov    %ebx,%eax
  102360:	5b                   	pop    %ebx
  102361:	5e                   	pop    %esi
  102362:	c3                   	ret    
  102363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102367:	90                   	nop
        return NULL;
  102368:	31 db                	xor    %ebx,%ebx
}
  10236a:	83 c4 04             	add    $0x4,%esp
  10236d:	89 d8                	mov    %ebx,%eax
  10236f:	5b                   	pop    %ebx
  102370:	5e                   	pop    %esi
  102371:	c3                   	ret    
  102372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(rsdp != NULL);
  102378:	8d 83 2e 85 ff ff    	lea    -0x7ad2(%ebx),%eax
  10237e:	50                   	push   %eax
  10237f:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  102385:	50                   	push   %eax
  102386:	8d 83 3b 85 ff ff    	lea    -0x7ac5(%ebx),%eax
  10238c:	6a 33                	push   $0x33
  10238e:	50                   	push   %eax
  10238f:	e8 9c 1c 00 00       	call   104030 <debug_panic>
  102394:	83 c4 10             	add    $0x10,%esp
  102397:	eb 8f                	jmp    102328 <acpi_probe_rsdt+0x18>
  102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001023a0 <acpi_probe_rsdt_ent>:

acpi_sdt_hdr_t *acpi_probe_rsdt_ent(acpi_rsdt_t *rsdt, const uint32_t sig)
{
  1023a0:	55                   	push   %ebp
  1023a1:	57                   	push   %edi
  1023a2:	56                   	push   %esi
  1023a3:	53                   	push   %ebx
  1023a4:	e8 e0 df ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1023a9:	81 c3 57 ec 00 00    	add    $0xec57,%ebx
  1023af:	83 ec 1c             	sub    $0x1c,%esp
  1023b2:	8b 74 24 30          	mov    0x30(%esp),%esi
    KERN_ASSERT(rsdt != NULL);
  1023b6:	85 f6                	test   %esi,%esi
  1023b8:	74 62                	je     10241c <acpi_probe_rsdt_ent+0x7c>

    uint8_t *p = (uint8_t *) &rsdt->ent[0];
    uint8_t *e = (uint8_t *) rsdt + rsdt->length;
  1023ba:	8b 7e 04             	mov    0x4(%esi),%edi
    uint8_t *p = (uint8_t *) &rsdt->ent[0];
  1023bd:	8d 56 24             	lea    0x24(%esi),%edx
    uint8_t *e = (uint8_t *) rsdt + rsdt->length;
  1023c0:	01 f7                	add    %esi,%edi

    int i;
    for (i = 0; p < e; i++) {
  1023c2:	39 d7                	cmp    %edx,%edi
  1023c4:	76 4a                	jbe    102410 <acpi_probe_rsdt_ent+0x70>
  1023c6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1023ca:	8b 7c 24 34          	mov    0x34(%esp),%edi
  1023ce:	eb 09                	jmp    1023d9 <acpi_probe_rsdt_ent+0x39>
  1023d0:	83 c2 04             	add    $0x4,%edx
  1023d3:	39 54 24 0c          	cmp    %edx,0xc(%esp)
  1023d7:	76 37                	jbe    102410 <acpi_probe_rsdt_ent+0x70>
        acpi_sdt_hdr_t *hdr = (acpi_sdt_hdr_t *) (rsdt->ent[i]);
  1023d9:	8b 02                	mov    (%edx),%eax
  1023db:	89 c5                	mov    %eax,%ebp
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  1023dd:	39 38                	cmp    %edi,(%eax)
  1023df:	75 ef                	jne    1023d0 <acpi_probe_rsdt_ent+0x30>
  1023e1:	8b 70 04             	mov    0x4(%eax),%esi
    for (i = 0; i < len; i++) {
  1023e4:	85 f6                	test   %esi,%esi
  1023e6:	7e 18                	jle    102400 <acpi_probe_rsdt_ent+0x60>
  1023e8:	01 c6                	add    %eax,%esi
    sum = 0;
  1023ea:	31 c9                	xor    %ecx,%ecx
  1023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  1023f0:	0f b6 18             	movzbl (%eax),%ebx
    for (i = 0; i < len; i++) {
  1023f3:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
  1023f6:	01 d9                	add    %ebx,%ecx
    for (i = 0; i < len; i++) {
  1023f8:	39 c6                	cmp    %eax,%esi
  1023fa:	75 f4                	jne    1023f0 <acpi_probe_rsdt_ent+0x50>
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  1023fc:	84 c9                	test   %cl,%cl
  1023fe:	75 d0                	jne    1023d0 <acpi_probe_rsdt_ent+0x30>
        }
        p = (uint8_t *) &rsdt->ent[i + 1];
    }

    return NULL;
}
  102400:	83 c4 1c             	add    $0x1c,%esp
  102403:	89 e8                	mov    %ebp,%eax
  102405:	5b                   	pop    %ebx
  102406:	5e                   	pop    %esi
  102407:	5f                   	pop    %edi
  102408:	5d                   	pop    %ebp
  102409:	c3                   	ret    
  10240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102410:	83 c4 1c             	add    $0x1c,%esp
    return NULL;
  102413:	31 ed                	xor    %ebp,%ebp
}
  102415:	5b                   	pop    %ebx
  102416:	89 e8                	mov    %ebp,%eax
  102418:	5e                   	pop    %esi
  102419:	5f                   	pop    %edi
  10241a:	5d                   	pop    %ebp
  10241b:	c3                   	ret    
    KERN_ASSERT(rsdt != NULL);
  10241c:	8d 83 4b 85 ff ff    	lea    -0x7ab5(%ebx),%eax
  102422:	50                   	push   %eax
  102423:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  102429:	50                   	push   %eax
  10242a:	8d 83 3b 85 ff ff    	lea    -0x7ac5(%ebx),%eax
  102430:	6a 41                	push   $0x41
  102432:	50                   	push   %eax
  102433:	e8 f8 1b 00 00       	call   104030 <debug_panic>
  102438:	83 c4 10             	add    $0x10,%esp
  10243b:	e9 7a ff ff ff       	jmp    1023ba <acpi_probe_rsdt_ent+0x1a>

00102440 <acpi_probe_xsdt>:

acpi_xsdt_t *acpi_probe_xsdt(acpi_rsdp_t *rsdp)
{
  102440:	56                   	push   %esi
  102441:	53                   	push   %ebx
  102442:	e8 42 df ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102447:	81 c3 b9 eb 00 00    	add    $0xebb9,%ebx
  10244d:	83 ec 04             	sub    $0x4,%esp
  102450:	8b 74 24 10          	mov    0x10(%esp),%esi
    KERN_ASSERT(rsdp != NULL);
  102454:	85 f6                	test   %esi,%esi
  102456:	74 50                	je     1024a8 <acpi_probe_xsdt+0x68>

    acpi_xsdt_t *xsdt = (acpi_xsdt_t *) (uintptr_t) rsdp->xsdt_addr;
  102458:	8b 5e 18             	mov    0x18(%esi),%ebx
  10245b:	89 d8                	mov    %ebx,%eax
    if (xsdt == NULL)
  10245d:	85 db                	test   %ebx,%ebx
  10245f:	74 2a                	je     10248b <acpi_probe_xsdt+0x4b>
        return NULL;
    if (xsdt->sig == ACPI_XSDT_SIG && sum((uint8_t *) xsdt, xsdt->length) == 0) {
  102461:	81 3b 58 53 44 54    	cmpl   $0x54445358,(%ebx)
  102467:	75 2f                	jne    102498 <acpi_probe_xsdt+0x58>
  102469:	8b 73 04             	mov    0x4(%ebx),%esi
    for (i = 0; i < len; i++) {
  10246c:	85 f6                	test   %esi,%esi
  10246e:	7e 1b                	jle    10248b <acpi_probe_xsdt+0x4b>
  102470:	01 de                	add    %ebx,%esi
    sum = 0;
  102472:	31 d2                	xor    %edx,%edx
  102474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  102478:	0f b6 08             	movzbl (%eax),%ecx
    for (i = 0; i < len; i++) {
  10247b:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
  10247e:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
  102480:	39 c6                	cmp    %eax,%esi
  102482:	75 f4                	jne    102478 <acpi_probe_xsdt+0x38>
        return NULL;
  102484:	31 c0                	xor    %eax,%eax
  102486:	84 d2                	test   %dl,%dl
  102488:	0f 45 d8             	cmovne %eax,%ebx
        return xsdt;
    }

    return NULL;
}
  10248b:	83 c4 04             	add    $0x4,%esp
  10248e:	89 d8                	mov    %ebx,%eax
  102490:	5b                   	pop    %ebx
  102491:	5e                   	pop    %esi
  102492:	c3                   	ret    
  102493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102497:	90                   	nop
        return NULL;
  102498:	31 db                	xor    %ebx,%ebx
}
  10249a:	83 c4 04             	add    $0x4,%esp
  10249d:	89 d8                	mov    %ebx,%eax
  10249f:	5b                   	pop    %ebx
  1024a0:	5e                   	pop    %esi
  1024a1:	c3                   	ret    
  1024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(rsdp != NULL);
  1024a8:	8d 83 2e 85 ff ff    	lea    -0x7ad2(%ebx),%eax
  1024ae:	50                   	push   %eax
  1024af:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1024b5:	50                   	push   %eax
  1024b6:	8d 83 3b 85 ff ff    	lea    -0x7ac5(%ebx),%eax
  1024bc:	6a 54                	push   $0x54
  1024be:	50                   	push   %eax
  1024bf:	e8 6c 1b 00 00       	call   104030 <debug_panic>
  1024c4:	83 c4 10             	add    $0x10,%esp
  1024c7:	eb 8f                	jmp    102458 <acpi_probe_xsdt+0x18>
  1024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001024d0 <acpi_probe_xsdt_ent>:

acpi_sdt_hdr_t *acpi_probe_xsdt_ent(acpi_xsdt_t *xsdt, const uint32_t sig)
{
  1024d0:	55                   	push   %ebp
  1024d1:	57                   	push   %edi
  1024d2:	56                   	push   %esi
  1024d3:	53                   	push   %ebx
  1024d4:	e8 b0 de ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1024d9:	81 c3 27 eb 00 00    	add    $0xeb27,%ebx
  1024df:	83 ec 1c             	sub    $0x1c,%esp
  1024e2:	8b 74 24 30          	mov    0x30(%esp),%esi
    KERN_ASSERT(xsdt != NULL);
  1024e6:	85 f6                	test   %esi,%esi
  1024e8:	74 62                	je     10254c <acpi_probe_xsdt_ent+0x7c>

    uint8_t *p = (uint8_t *) &xsdt->ent[0];
    uint8_t *e = (uint8_t *) xsdt + xsdt->length;
  1024ea:	8b 7e 04             	mov    0x4(%esi),%edi
    uint8_t *p = (uint8_t *) &xsdt->ent[0];
  1024ed:	8d 56 24             	lea    0x24(%esi),%edx
    uint8_t *e = (uint8_t *) xsdt + xsdt->length;
  1024f0:	01 f7                	add    %esi,%edi

    int i;
    for (i = 0; p < e; i++) {
  1024f2:	39 d7                	cmp    %edx,%edi
  1024f4:	76 4a                	jbe    102540 <acpi_probe_xsdt_ent+0x70>
  1024f6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1024fa:	8b 7c 24 34          	mov    0x34(%esp),%edi
  1024fe:	eb 09                	jmp    102509 <acpi_probe_xsdt_ent+0x39>
  102500:	83 c2 08             	add    $0x8,%edx
  102503:	39 54 24 0c          	cmp    %edx,0xc(%esp)
  102507:	76 37                	jbe    102540 <acpi_probe_xsdt_ent+0x70>
        acpi_sdt_hdr_t *hdr = (acpi_sdt_hdr_t *) (uintptr_t) xsdt->ent[i];
  102509:	8b 02                	mov    (%edx),%eax
  10250b:	89 c5                	mov    %eax,%ebp
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  10250d:	39 38                	cmp    %edi,(%eax)
  10250f:	75 ef                	jne    102500 <acpi_probe_xsdt_ent+0x30>
  102511:	8b 70 04             	mov    0x4(%eax),%esi
    for (i = 0; i < len; i++) {
  102514:	85 f6                	test   %esi,%esi
  102516:	7e 18                	jle    102530 <acpi_probe_xsdt_ent+0x60>
  102518:	01 c6                	add    %eax,%esi
    sum = 0;
  10251a:	31 c9                	xor    %ecx,%ecx
  10251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  102520:	0f b6 18             	movzbl (%eax),%ebx
    for (i = 0; i < len; i++) {
  102523:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
  102526:	01 d9                	add    %ebx,%ecx
    for (i = 0; i < len; i++) {
  102528:	39 c6                	cmp    %eax,%esi
  10252a:	75 f4                	jne    102520 <acpi_probe_xsdt_ent+0x50>
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  10252c:	84 c9                	test   %cl,%cl
  10252e:	75 d0                	jne    102500 <acpi_probe_xsdt_ent+0x30>
        }
        p = (uint8_t *) &xsdt->ent[i + 1];
    }

    return NULL;
}
  102530:	83 c4 1c             	add    $0x1c,%esp
  102533:	89 e8                	mov    %ebp,%eax
  102535:	5b                   	pop    %ebx
  102536:	5e                   	pop    %esi
  102537:	5f                   	pop    %edi
  102538:	5d                   	pop    %ebp
  102539:	c3                   	ret    
  10253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102540:	83 c4 1c             	add    $0x1c,%esp
    return NULL;
  102543:	31 ed                	xor    %ebp,%ebp
}
  102545:	5b                   	pop    %ebx
  102546:	89 e8                	mov    %ebp,%eax
  102548:	5e                   	pop    %esi
  102549:	5f                   	pop    %edi
  10254a:	5d                   	pop    %ebp
  10254b:	c3                   	ret    
    KERN_ASSERT(xsdt != NULL);
  10254c:	8d 83 58 85 ff ff    	lea    -0x7aa8(%ebx),%eax
  102552:	50                   	push   %eax
  102553:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  102559:	50                   	push   %eax
  10255a:	8d 83 3b 85 ff ff    	lea    -0x7ac5(%ebx),%eax
  102560:	6a 62                	push   $0x62
  102562:	50                   	push   %eax
  102563:	e8 c8 1a 00 00       	call   104030 <debug_panic>
  102568:	83 c4 10             	add    $0x10,%esp
  10256b:	e9 7a ff ff ff       	jmp    1024ea <acpi_probe_xsdt_ent+0x1a>

00102570 <lapic_register>:
{
}

void lapic_register(uintptr_t lapic_addr)
{
    lapic = (lapic_t *) lapic_addr;
  102570:	e8 0c de ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  102575:	05 8b ea 00 00       	add    $0xea8b,%eax
  10257a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10257e:	89 90 90 88 02 00    	mov    %edx,0x28890(%eax)
}
  102584:	c3                   	ret    
  102585:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102590 <lapic_init>:

/*
 * Initialize local APIC.
 */
void lapic_init()
{
  102590:	55                   	push   %ebp
  102591:	57                   	push   %edi
  102592:	56                   	push   %esi
  102593:	53                   	push   %ebx
  102594:	e8 f0 dd ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102599:	81 c3 67 ea 00 00    	add    $0xea67,%ebx
  10259f:	83 ec 2c             	sub    $0x2c,%esp
    if (!lapic)
  1025a2:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
  1025a8:	8d 93 6e 85 ff ff    	lea    -0x7a92(%ebx),%edx
  1025ae:	89 54 24 10          	mov    %edx,0x10(%esp)
  1025b2:	85 c0                	test   %eax,%eax
  1025b4:	0f 84 9b 02 00 00    	je     102855 <lapic_init+0x2c5>
    lapic[index] = value;
  1025ba:	c7 80 f0 00 00 00 27 	movl   $0x127,0xf0(%eax)
  1025c1:	01 00 00 
    lapic[LAPIC_ID];
  1025c4:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1025c7:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1025ce:	00 00 00 
    lapic[LAPIC_ID];
  1025d1:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1025d4:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1025db:	00 02 00 
    lapic[LAPIC_ID];
  1025de:	8b 50 20             	mov    0x20(%eax),%edx
    int i;
    for (i = 0; i < 5; i++) {
        lapic_ticks_per_ms = lapic_calibrate_timer(CAL_LATCH, CAL_MS, CAL_PIT_LOOPS);
        if (lapic_ticks_per_ms != ~(uint32_t) 0x0)
            break;
        KERN_DEBUG("[%d] Retry to calibrate internal timer of LAPIC.\n", i);
  1025e1:	8d 93 c4 85 ff ff    	lea    -0x7a3c(%ebx),%edx
    for (i = 0; i < 5; i++) {
  1025e7:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  1025ee:	00 
        KERN_DEBUG("[%d] Retry to calibrate internal timer of LAPIC.\n", i);
  1025ef:	89 54 24 1c          	mov    %edx,0x1c(%esp)
    lapic[index] = value;
  1025f3:	c7 80 80 03 00 00 ff 	movl   $0xffffffff,0x380(%eax)
  1025fa:	ff ff ff 
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  1025fd:	83 ec 0c             	sub    $0xc,%esp
    lapic[LAPIC_ID];
  102600:	8b 40 20             	mov    0x20(%eax),%eax
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  102603:	6a 61                	push   $0x61
  102605:	e8 46 28 00 00       	call   104e50 <inb>
  10260a:	5a                   	pop    %edx
  10260b:	59                   	pop    %ecx
  10260c:	25 fc 00 00 00       	and    $0xfc,%eax
  102611:	83 c8 01             	or     $0x1,%eax
  102614:	50                   	push   %eax
  102615:	6a 61                	push   $0x61
  102617:	e8 64 28 00 00       	call   104e80 <outb>
    outb(0x43, 0xb0);
  10261c:	5e                   	pop    %esi
  10261d:	5f                   	pop    %edi
  10261e:	68 b0 00 00 00       	push   $0xb0
  102623:	6a 43                	push   $0x43
    timermin = ~(uint32_t) 0x0;
  102625:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    outb(0x43, 0xb0);
  10262a:	e8 51 28 00 00       	call   104e80 <outb>
    outb(0x42, latch & 0xff);
  10262f:	5d                   	pop    %ebp
  102630:	58                   	pop    %eax
  102631:	68 9b 00 00 00       	push   $0x9b
  102636:	6a 42                	push   $0x42
    timermax = 0;
  102638:	31 ed                	xor    %ebp,%ebp
    outb(0x42, latch & 0xff);
  10263a:	e8 41 28 00 00       	call   104e80 <outb>
    outb(0x42, latch >> 8);
  10263f:	58                   	pop    %eax
  102640:	5a                   	pop    %edx
  102641:	6a 2e                	push   $0x2e
  102643:	6a 42                	push   $0x42
  102645:	e8 36 28 00 00       	call   104e80 <outb>
    return lapic[index];
  10264a:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
  102650:	8b 80 90 03 00 00    	mov    0x390(%eax),%eax
  102656:	89 44 24 28          	mov    %eax,0x28(%esp)
  10265a:	89 c6                	mov    %eax,%esi
  10265c:	89 e8                	mov    %ebp,%eax
    while ((inb(0x61) & 0x20) == 0) {
  10265e:	83 c4 10             	add    $0x10,%esp
  102661:	89 fd                	mov    %edi,%ebp
  102663:	89 c7                	mov    %eax,%edi
    pitcnt = 0;
  102665:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10266c:	00 
    while ((inb(0x61) & 0x20) == 0) {
  10266d:	eb 20                	jmp    10268f <lapic_init+0xff>
  10266f:	90                   	nop
    return lapic[index];
  102670:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
  102676:	8b 80 90 03 00 00    	mov    0x390(%eax),%eax
        delta = timer - timer2;
  10267c:	29 c6                	sub    %eax,%esi
        if (delta < timermin)
  10267e:	39 f5                	cmp    %esi,%ebp
  102680:	0f 47 ee             	cmova  %esi,%ebp
        if (delta > timermax)
  102683:	39 f7                	cmp    %esi,%edi
  102685:	0f 42 fe             	cmovb  %esi,%edi
        pitcnt++;
  102688:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
        timer = timer2;
  10268d:	89 c6                	mov    %eax,%esi
    while ((inb(0x61) & 0x20) == 0) {
  10268f:	83 ec 0c             	sub    $0xc,%esp
  102692:	6a 61                	push   $0x61
  102694:	e8 b7 27 00 00       	call   104e50 <inb>
  102699:	83 c4 10             	add    $0x10,%esp
  10269c:	a8 20                	test   $0x20,%al
  10269e:	74 d0                	je     102670 <lapic_init+0xe0>
    if (pitcnt < loopmin || timermax > 10 * timermin)
  1026a0:	89 f8                	mov    %edi,%eax
  1026a2:	81 7c 24 0c e7 03 00 	cmpl   $0x3e7,0xc(%esp)
  1026a9:	00 
  1026aa:	89 ef                	mov    %ebp,%edi
  1026ac:	89 c5                	mov    %eax,%ebp
  1026ae:	0f 8e 3c 01 00 00    	jle    1027f0 <lapic_init+0x260>
  1026b4:	8d 04 bf             	lea    (%edi,%edi,4),%eax
  1026b7:	01 c0                	add    %eax,%eax
  1026b9:	39 c5                	cmp    %eax,%ebp
  1026bb:	0f 87 2f 01 00 00    	ja     1027f0 <lapic_init+0x260>
    delta = timer1 - timer2;
  1026c1:	8b 54 24 18          	mov    0x18(%esp),%edx
    return delta / ms;
  1026c5:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    if (lapic_ticks_per_ms == ~(uint32_t) 0x0) {
        KERN_WARN("Failed to calibrate internal timer of LAPIC.\n");
        KERN_DEBUG("Assume LAPIC timer freq = 0.5 GHz.\n");
        lapic_ticks_per_ms = 500000;
    } else
        KERN_DEBUG("LAPIC timer freq = %llu Hz.\n",
  1026ca:	83 ec 0c             	sub    $0xc,%esp
    delta = timer1 - timer2;
  1026cd:	29 f2                	sub    %esi,%edx
    return delta / ms;
  1026cf:	89 d0                	mov    %edx,%eax
  1026d1:	f7 e1                	mul    %ecx
        KERN_DEBUG("LAPIC timer freq = %llu Hz.\n",
  1026d3:	b8 e8 03 00 00       	mov    $0x3e8,%eax
    return delta / ms;
  1026d8:	c1 ea 03             	shr    $0x3,%edx
  1026db:	89 d6                	mov    %edx,%esi
        KERN_DEBUG("LAPIC timer freq = %llu Hz.\n",
  1026dd:	f7 e2                	mul    %edx
  1026df:	52                   	push   %edx
  1026e0:	50                   	push   %eax
  1026e1:	8d 83 7f 85 ff ff    	lea    -0x7a81(%ebx),%eax
  1026e7:	50                   	push   %eax
  1026e8:	6a 7d                	push   $0x7d
  1026ea:	ff 74 24 2c          	push   0x2c(%esp)
  1026ee:	e8 fd 18 00 00       	call   103ff0 <debug_normal>
                   (uint64_t) lapic_ticks_per_ms * 1000);

    uint32_t ticr = lapic_ticks_per_ms * 1000 / LAPIC_TIMER_INTR_FREQ;
  1026f3:	69 d6 e8 03 00 00    	imul   $0x3e8,%esi,%edx
  1026f9:	b9 d3 4d 62 10       	mov    $0x10624dd3,%ecx
  1026fe:	83 c4 20             	add    $0x20,%esp
  102701:	89 d0                	mov    %edx,%eax
  102703:	f7 e1                	mul    %ecx
  102705:	c1 ea 06             	shr    $0x6,%edx
  102708:	89 d6                	mov    %edx,%esi
    KERN_DEBUG("Set LAPIC TICR = %x.\n", ticr);
  10270a:	8d 83 9c 85 ff ff    	lea    -0x7a64(%ebx),%eax
  102710:	56                   	push   %esi
  102711:	50                   	push   %eax
  102712:	68 81 00 00 00       	push   $0x81
  102717:	ff 74 24 1c          	push   0x1c(%esp)
  10271b:	e8 d0 18 00 00       	call   103ff0 <debug_normal>
    lapic[index] = value;
  102720:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
    lapic_write(LAPIC_LINT0, LAPIC_LINT_MASKED);
    lapic_write(LAPIC_LINT1, LAPIC_LINT_MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic_read(LAPIC_VER) >> 16) & 0xFF) >= 4)
  102726:	83 c4 10             	add    $0x10,%esp
    lapic[index] = value;
  102729:	89 b0 80 03 00 00    	mov    %esi,0x380(%eax)
    lapic[LAPIC_ID];
  10272f:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102732:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  102739:	00 01 00 
    lapic[LAPIC_ID];
  10273c:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10273f:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102746:	00 01 00 
    lapic[LAPIC_ID];
  102749:	8b 50 20             	mov    0x20(%eax),%edx
    return lapic[index];
  10274c:	8b 50 30             	mov    0x30(%eax),%edx
    if (((lapic_read(LAPIC_VER) >> 16) & 0xFF) >= 4)
  10274f:	c1 ea 10             	shr    $0x10,%edx
  102752:	81 e2 fc 00 00 00    	and    $0xfc,%edx
  102758:	74 0d                	je     102767 <lapic_init+0x1d7>
    lapic[index] = value;
  10275a:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  102761:	00 01 00 
    lapic[LAPIC_ID];
  102764:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102767:	c7 80 e0 00 00 00 00 	movl   $0xf0000000,0xe0(%eax)
  10276e:	00 00 f0 
    lapic[LAPIC_ID];
  102771:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102774:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%eax)
  10277b:	00 00 00 
    lapic[LAPIC_ID];
  10277e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102781:	c7 80 70 03 00 00 32 	movl   $0x32,0x370(%eax)
  102788:	00 00 00 
    lapic[LAPIC_ID];
  10278b:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10278e:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102795:	00 00 00 
    lapic[LAPIC_ID];
  102798:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10279b:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1027a2:	00 00 00 
    lapic[LAPIC_ID];
  1027a5:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1027a8:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1027af:	00 00 00 
    lapic[LAPIC_ID];
  1027b2:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1027b5:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1027bc:	00 00 00 
    lapic[LAPIC_ID];
  1027bf:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1027c2:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1027c9:	85 08 00 
    lapic[LAPIC_ID];
  1027cc:	8b 50 20             	mov    0x20(%eax),%edx
  1027cf:	90                   	nop
    return lapic[index];
  1027d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapic_write(LAPIC_ICRHI, 0);
    lapic_write(LAPIC_ICRLO,
                LAPIC_ICRLO_BCAST | LAPIC_ICRLO_INIT | LAPIC_ICRLO_LEVEL);
    while (lapic_read(LAPIC_ICRLO) & LAPIC_ICRLO_DELIVS);
  1027d6:	80 e6 10             	and    $0x10,%dh
  1027d9:	75 f5                	jne    1027d0 <lapic_init+0x240>
    lapic[index] = value;
  1027db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  1027e2:	00 00 00 
    lapic[LAPIC_ID];
  1027e5:	8b 40 20             	mov    0x20(%eax),%eax

    // Enable interrupts on the APIC (but not on the processor).
    lapic_write(LAPIC_TPR, 0);
}
  1027e8:	83 c4 2c             	add    $0x2c,%esp
  1027eb:	5b                   	pop    %ebx
  1027ec:	5e                   	pop    %esi
  1027ed:	5f                   	pop    %edi
  1027ee:	5d                   	pop    %ebp
  1027ef:	c3                   	ret    
        KERN_DEBUG("[%d] Retry to calibrate internal timer of LAPIC.\n", i);
  1027f0:	8b 7c 24 14          	mov    0x14(%esp),%edi
  1027f4:	57                   	push   %edi
  1027f5:	ff 74 24 20          	push   0x20(%esp)
  1027f9:	6a 75                	push   $0x75
  1027fb:	ff 74 24 1c          	push   0x1c(%esp)
  1027ff:	e8 ec 17 00 00       	call   103ff0 <debug_normal>
    for (i = 0; i < 5; i++) {
  102804:	89 f8                	mov    %edi,%eax
  102806:	83 c0 01             	add    $0x1,%eax
  102809:	89 44 24 24          	mov    %eax,0x24(%esp)
  10280d:	83 c4 10             	add    $0x10,%esp
  102810:	83 f8 05             	cmp    $0x5,%eax
  102813:	74 0b                	je     102820 <lapic_init+0x290>
    lapic[index] = value;
  102815:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
  10281b:	e9 d3 fd ff ff       	jmp    1025f3 <lapic_init+0x63>
        KERN_WARN("Failed to calibrate internal timer of LAPIC.\n");
  102820:	83 ec 04             	sub    $0x4,%esp
  102823:	8d 83 f8 85 ff ff    	lea    -0x7a08(%ebx),%eax
  102829:	be 20 a1 07 00       	mov    $0x7a120,%esi
  10282e:	50                   	push   %eax
  10282f:	6a 79                	push   $0x79
  102831:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  102835:	57                   	push   %edi
  102836:	e8 c5 18 00 00       	call   104100 <debug_warn>
        KERN_DEBUG("Assume LAPIC timer freq = 0.5 GHz.\n");
  10283b:	83 c4 0c             	add    $0xc,%esp
  10283e:	8d 83 28 86 ff ff    	lea    -0x79d8(%ebx),%eax
  102844:	50                   	push   %eax
  102845:	6a 7a                	push   $0x7a
  102847:	57                   	push   %edi
  102848:	e8 a3 17 00 00       	call   103ff0 <debug_normal>
        lapic_ticks_per_ms = 500000;
  10284d:	83 c4 10             	add    $0x10,%esp
  102850:	e9 b5 fe ff ff       	jmp    10270a <lapic_init+0x17a>
        KERN_PANIC("NO LAPIC");
  102855:	83 ec 04             	sub    $0x4,%esp
  102858:	8d 83 65 85 ff ff    	lea    -0x7a9b(%ebx),%eax
  10285e:	50                   	push   %eax
  10285f:	6a 62                	push   $0x62
  102861:	ff 74 24 1c          	push   0x1c(%esp)
  102865:	e8 c6 17 00 00       	call   104030 <debug_panic>
    lapic[index] = value;
  10286a:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
  102870:	83 c4 10             	add    $0x10,%esp
  102873:	e9 42 fd ff ff       	jmp    1025ba <lapic_init+0x2a>
  102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10287f:	90                   	nop

00102880 <lapic_eoi>:
/*
 * Acknowledge the end of interrupts.
 */
void lapic_eoi(void)
{
    if (lapic)
  102880:	e8 fc da ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  102885:	05 7b e7 00 00       	add    $0xe77b,%eax
  10288a:	8b 80 90 88 02 00    	mov    0x28890(%eax),%eax
  102890:	85 c0                	test   %eax,%eax
  102892:	74 0d                	je     1028a1 <lapic_eoi+0x21>
    lapic[index] = value;
  102894:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  10289b:	00 00 00 
    lapic[LAPIC_ID];
  10289e:	8b 40 20             	mov    0x20(%eax),%eax
        lapic_write(LAPIC_EOI, 0);
}
  1028a1:	c3                   	ret    
  1028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001028b0 <lapic_startcpu>:
/*
 * Start additional processor running bootstrap code at addr.
 * See Appendix B of MultiProcessor Specification.
 */
void lapic_startcpu(lapicid_t apicid, uintptr_t addr)
{
  1028b0:	57                   	push   %edi
  1028b1:	56                   	push   %esi
  1028b2:	53                   	push   %ebx
  1028b3:	8b 74 24 14          	mov    0x14(%esp),%esi
  1028b7:	e8 cd da ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1028bc:	81 c3 44 e7 00 00    	add    $0xe744,%ebx
  1028c2:	8b 7c 24 10          	mov    0x10(%esp),%edi
    uint16_t *wrv;

    // "The BSP must initialize CMOS shutdown code to 0AH
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(IO_RTC, 0xF);                      // offset 0xF is shutdown code
  1028c6:	83 ec 08             	sub    $0x8,%esp
    wrv[0] = 0;
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapic_write(LAPIC_ICRHI, apicid << 24);
  1028c9:	c1 e7 18             	shl    $0x18,%edi
    outb(IO_RTC, 0xF);                      // offset 0xF is shutdown code
  1028cc:	6a 0f                	push   $0xf
  1028ce:	6a 70                	push   $0x70
  1028d0:	e8 ab 25 00 00       	call   104e80 <outb>
    outb(IO_RTC + 1, 0x0A);
  1028d5:	58                   	pop    %eax
  1028d6:	5a                   	pop    %edx
  1028d7:	6a 0a                	push   $0xa
  1028d9:	6a 71                	push   $0x71
  1028db:	e8 a0 25 00 00       	call   104e80 <outb>
    wrv[1] = addr >> 4;
  1028e0:	89 f0                	mov    %esi,%eax
    // when it is in the halted state due to an INIT. So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one. Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapic_write(LAPIC_ICRHI, apicid << 24);
        lapic_write(LAPIC_ICRLO, LAPIC_ICRLO_STARTUP | (addr >> 12));
  1028e2:	c1 ee 0c             	shr    $0xc,%esi
        microdelay(200);
    }
}
  1028e5:	83 c4 10             	add    $0x10,%esp
    wrv[1] = addr >> 4;
  1028e8:	c1 e8 04             	shr    $0x4,%eax
        lapic_write(LAPIC_ICRLO, LAPIC_ICRLO_STARTUP | (addr >> 12));
  1028eb:	81 ce 00 06 00 00    	or     $0x600,%esi
    wrv[0] = 0;
  1028f1:	31 c9                	xor    %ecx,%ecx
    wrv[1] = addr >> 4;
  1028f3:	66 a3 69 04 00 00    	mov    %ax,0x469
    lapic[index] = value;
  1028f9:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
    wrv[0] = 0;
  1028ff:	66 89 0d 67 04 00 00 	mov    %cx,0x467
    lapic[index] = value;
  102906:	89 b8 10 03 00 00    	mov    %edi,0x310(%eax)
    lapic[LAPIC_ID];
  10290c:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  10290f:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  102916:	c5 00 00 
    lapic[LAPIC_ID];
  102919:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  10291c:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  102923:	85 00 00 
    lapic[LAPIC_ID];
  102926:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  102929:	89 b8 10 03 00 00    	mov    %edi,0x310(%eax)
    lapic[LAPIC_ID];
  10292f:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  102932:	89 b0 00 03 00 00    	mov    %esi,0x300(%eax)
    lapic[LAPIC_ID];
  102938:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  10293b:	89 b8 10 03 00 00    	mov    %edi,0x310(%eax)
    lapic[LAPIC_ID];
  102941:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102944:	89 b0 00 03 00 00    	mov    %esi,0x300(%eax)
}
  10294a:	5b                   	pop    %ebx
    lapic[LAPIC_ID];
  10294b:	8b 40 20             	mov    0x20(%eax),%eax
}
  10294e:	5e                   	pop    %esi
  10294f:	5f                   	pop    %edi
  102950:	c3                   	ret    
  102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10295f:	90                   	nop

00102960 <lapic_read_debug>:
    return lapic[index];
  102960:	e8 1c da ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  102965:	05 9b e6 00 00       	add    $0xe69b,%eax
  10296a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10296e:	8b 80 90 88 02 00    	mov    0x28890(%eax),%eax
  102974:	8d 04 90             	lea    (%eax,%edx,4),%eax
  102977:	8b 00                	mov    (%eax),%eax

uint32_t lapic_read_debug(int index)
{
    return lapic_read(index);
}
  102979:	c3                   	ret    
  10297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102980 <lapic_send_ipi>:
/*
 * Send an IPI.
 */
void lapic_send_ipi(lapicid_t apicid, uint8_t vector,
                    uint32_t deliver_mode, uint32_t shorthand_mode)
{
  102980:	55                   	push   %ebp
  102981:	57                   	push   %edi
  102982:	56                   	push   %esi
  102983:	53                   	push   %ebx
  102984:	e8 00 da ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102989:	81 c3 77 e6 00 00    	add    $0xe677,%ebx
  10298f:	83 ec 0c             	sub    $0xc,%esp
    KERN_ASSERT(deliver_mode != LAPIC_ICRLO_INIT &&
  102992:	8b 44 24 28          	mov    0x28(%esp),%eax
{
  102996:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  10299a:	8b 74 24 24          	mov    0x24(%esp),%esi
  10299e:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
    KERN_ASSERT(deliver_mode != LAPIC_ICRLO_INIT &&
  1029a2:	2d 00 05 00 00       	sub    $0x500,%eax
  1029a7:	a9 ff fe ff ff       	test   $0xfffffeff,%eax
  1029ac:	74 5a                	je     102a08 <lapic_send_ipi+0x88>
                deliver_mode != LAPIC_ICRLO_STARTUP);
    KERN_ASSERT(vector >= T_IPI0);
  1029ae:	89 f0                	mov    %esi,%eax
  1029b0:	3c 3e                	cmp    $0x3e,%al
  1029b2:	77 11                	ja     1029c5 <lapic_send_ipi+0x45>
  1029b4:	eb 7a                	jmp    102a30 <lapic_send_ipi+0xb0>
  1029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1029bd:	8d 76 00             	lea    0x0(%esi),%esi

    while (lapic_read(LAPIC_ICRLO) & LAPIC_ICRLO_DELIVS)
        pause();
  1029c0:	e8 eb 22 00 00       	call   104cb0 <pause>
    return lapic[index];
  1029c5:	8b 83 90 88 02 00    	mov    0x28890(%ebx),%eax
  1029cb:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
    while (lapic_read(LAPIC_ICRLO) & LAPIC_ICRLO_DELIVS)
  1029d1:	80 e6 10             	and    $0x10,%dh
  1029d4:	75 ea                	jne    1029c0 <lapic_send_ipi+0x40>

    if (shorthand_mode == LAPIC_ICRLO_NOBCAST)
  1029d6:	85 ff                	test   %edi,%edi
  1029d8:	75 0c                	jne    1029e6 <lapic_send_ipi+0x66>
        lapic_write(LAPIC_ICRHI,
  1029da:	c1 e5 18             	shl    $0x18,%ebp
    lapic[index] = value;
  1029dd:	89 a8 10 03 00 00    	mov    %ebp,0x310(%eax)
    lapic[LAPIC_ID];
  1029e3:	8b 50 20             	mov    0x20(%eax),%edx
                    (apicid << LAPIC_ICRHI_DEST_SHIFT) & LAPIC_ICRHI_DEST_MASK);

    lapic_write(LAPIC_ICRLO,
                shorthand_mode |  /* LAPIC_ICRLO_LEVEL | */
                deliver_mode | (vector & LAPIC_ICRLO_VECTOR));
  1029e6:	89 f1                	mov    %esi,%ecx
  1029e8:	0f b6 f1             	movzbl %cl,%esi
  1029eb:	09 fe                	or     %edi,%esi
  1029ed:	0b 74 24 28          	or     0x28(%esp),%esi
    lapic[index] = value;
  1029f1:	89 b0 00 03 00 00    	mov    %esi,0x300(%eax)
    lapic[LAPIC_ID];
  1029f7:	8b 40 20             	mov    0x20(%eax),%eax
}
  1029fa:	83 c4 0c             	add    $0xc,%esp
  1029fd:	5b                   	pop    %ebx
  1029fe:	5e                   	pop    %esi
  1029ff:	5f                   	pop    %edi
  102a00:	5d                   	pop    %ebp
  102a01:	c3                   	ret    
  102a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(deliver_mode != LAPIC_ICRLO_INIT &&
  102a08:	8d 83 4c 86 ff ff    	lea    -0x79b4(%ebx),%eax
  102a0e:	50                   	push   %eax
  102a0f:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  102a15:	50                   	push   %eax
  102a16:	8d 83 6e 85 ff ff    	lea    -0x7a92(%ebx),%eax
  102a1c:	68 e4 00 00 00       	push   $0xe4
  102a21:	50                   	push   %eax
  102a22:	e8 09 16 00 00       	call   104030 <debug_panic>
    KERN_ASSERT(vector >= T_IPI0);
  102a27:	89 f0                	mov    %esi,%eax
    KERN_ASSERT(deliver_mode != LAPIC_ICRLO_INIT &&
  102a29:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(vector >= T_IPI0);
  102a2c:	3c 3e                	cmp    $0x3e,%al
  102a2e:	77 95                	ja     1029c5 <lapic_send_ipi+0x45>
  102a30:	8d 83 b2 85 ff ff    	lea    -0x7a4e(%ebx),%eax
  102a36:	50                   	push   %eax
  102a37:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  102a3d:	50                   	push   %eax
  102a3e:	8d 83 6e 85 ff ff    	lea    -0x7a92(%ebx),%eax
  102a44:	68 e6 00 00 00       	push   $0xe6
  102a49:	50                   	push   %eax
  102a4a:	e8 e1 15 00 00       	call   104030 <debug_panic>
  102a4f:	83 c4 10             	add    $0x10,%esp
    return lapic[index];
  102a52:	e9 6e ff ff ff       	jmp    1029c5 <lapic_send_ipi+0x45>
  102a57:	66 90                	xchg   %ax,%ax
  102a59:	66 90                	xchg   %ax,%ax
  102a5b:	66 90                	xchg   %ax,%ax
  102a5d:	66 90                	xchg   %ax,%ax
  102a5f:	90                   	nop

00102a60 <ioapic_register>:
    base->reg = reg;
    base->data = data;
}

void ioapic_register(uintptr_t addr, lapicid_t id, int g)
{
  102a60:	53                   	push   %ebx
  102a61:	e8 23 d9 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102a66:	81 c3 9a e5 00 00    	add    $0xe59a,%ebx
  102a6c:	83 ec 08             	sub    $0x8,%esp
  102a6f:	8b 54 24 14          	mov    0x14(%esp),%edx
    if (ioapic_num >= MAX_IOAPIC) {
  102a73:	8b 83 a0 88 02 00    	mov    0x288a0(%ebx),%eax
  102a79:	83 f8 0f             	cmp    $0xf,%eax
  102a7c:	7f 4a                	jg     102ac8 <ioapic_register+0x68>
        KERN_WARN("CertiKOS cannot manipulate more than %d IOAPICs.\n", MAX_IOAPIC);
        return;
    }

    ioapics[ioapic_num] = (ioapic_t *) addr;
  102a7e:	8b 83 a0 88 02 00    	mov    0x288a0(%ebx),%eax
  102a84:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  102a88:	89 8c 83 20 89 02 00 	mov    %ecx,0x28920(%ebx,%eax,4)
    ioapicid[ioapic_num] = id;
  102a8f:	8b 83 a0 88 02 00    	mov    0x288a0(%ebx),%eax
    gsi[ioapic_num] = g;
  102a95:	8b 4c 24 18          	mov    0x18(%esp),%ecx
    ioapicid[ioapic_num] = id;
  102a99:	88 94 03 00 89 02 00 	mov    %dl,0x28900(%ebx,%eax,1)
    gsi[ioapic_num] = g;
  102aa0:	8b 93 a0 88 02 00    	mov    0x288a0(%ebx),%edx
  102aa6:	8d 83 c0 88 02 00    	lea    0x288c0(%ebx),%eax
  102aac:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    ioapic_num++;
  102aaf:	8b 83 a0 88 02 00    	mov    0x288a0(%ebx),%eax
  102ab5:	83 c0 01             	add    $0x1,%eax
  102ab8:	89 83 a0 88 02 00    	mov    %eax,0x288a0(%ebx)
}
  102abe:	83 c4 08             	add    $0x8,%esp
  102ac1:	5b                   	pop    %ebx
  102ac2:	c3                   	ret    
  102ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102ac7:	90                   	nop
        KERN_WARN("CertiKOS cannot manipulate more than %d IOAPICs.\n", MAX_IOAPIC);
  102ac8:	8d 83 94 86 ff ff    	lea    -0x796c(%ebx),%eax
  102ace:	6a 10                	push   $0x10
  102ad0:	50                   	push   %eax
  102ad1:	8d 83 0d 87 ff ff    	lea    -0x78f3(%ebx),%eax
  102ad7:	6a 1f                	push   $0x1f
  102ad9:	50                   	push   %eax
  102ada:	e8 21 16 00 00       	call   104100 <debug_warn>
        return;
  102adf:	83 c4 10             	add    $0x10,%esp
}
  102ae2:	83 c4 08             	add    $0x8,%esp
  102ae5:	5b                   	pop    %ebx
  102ae6:	c3                   	ret    
  102ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102aee:	66 90                	xchg   %ax,%ax

00102af0 <ioapic_init>:

void ioapic_init(void)
{
  102af0:	55                   	push   %ebp
  102af1:	57                   	push   %edi
  102af2:	56                   	push   %esi
  102af3:	53                   	push   %ebx
  102af4:	e8 90 d8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102af9:	81 c3 07 e5 00 00    	add    $0xe507,%ebx
  102aff:	83 ec 1c             	sub    $0x1c,%esp
    int i;
    for (i = 0; i < ioapic_num; i++) {
  102b02:	8b 83 a0 88 02 00    	mov    0x288a0(%ebx),%eax
  102b08:	89 1c 24             	mov    %ebx,(%esp)
  102b0b:	85 c0                	test   %eax,%eax
  102b0d:	0f 8e e7 00 00 00    	jle    102bfa <ioapic_init+0x10a>
  102b13:	89 d8                	mov    %ebx,%eax
  102b15:	8d 9b 00 89 02 00    	lea    0x28900(%ebx),%ebx
  102b1b:	31 ff                	xor    %edi,%edi
  102b1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
        volatile ioapic_t *ioapic = ioapics[i];
        KERN_ASSERT(ioapic != NULL);
  102b21:	8d 98 1f 87 ff ff    	lea    -0x78e1(%eax),%ebx
  102b27:	8d 80 bf 82 ff ff    	lea    -0x7d41(%eax),%eax
  102b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102b31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b35:	8d 76 00             	lea    0x0(%esi),%esi
        volatile ioapic_t *ioapic = ioapics[i];
  102b38:	8b 04 24             	mov    (%esp),%eax
  102b3b:	8b b4 b8 20 89 02 00 	mov    0x28920(%eax,%edi,4),%esi
        KERN_ASSERT(ioapic != NULL);
  102b42:	85 f6                	test   %esi,%esi
  102b44:	0f 84 be 00 00 00    	je     102c08 <ioapic_init+0x118>
    base->reg = reg;
  102b4a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    return base->data;
  102b50:	8b 46 10             	mov    0x10(%esi),%eax

        lapicid_t id = ioapic_read(ioapic, IOAPIC_ID) >> 24;
        if (id == 0) {
  102b53:	c1 e8 18             	shr    $0x18,%eax
  102b56:	75 18                	jne    102b70 <ioapic_init+0x80>
            // I/O APIC ID not initialized yet - have to do it ourselves.
            ioapic_write(ioapic, IOAPIC_ID, ioapicid[i] << 24);
  102b58:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  102b5c:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
    base->reg = reg;
  102b60:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
            ioapic_write(ioapic, IOAPIC_ID, ioapicid[i] << 24);
  102b66:	c1 e0 18             	shl    $0x18,%eax
    base->data = data;
  102b69:	89 46 10             	mov    %eax,0x10(%esi)
            id = ioapicid[i];
  102b6c:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
        }

        if (id != ioapicid[i])
  102b70:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  102b74:	0f b6 14 3b          	movzbl (%ebx,%edi,1),%edx
  102b78:	38 c2                	cmp    %al,%dl
  102b7a:	74 28                	je     102ba4 <ioapic_init+0xb4>
            KERN_WARN("ioapic_init: id %d != ioapicid %d\n", id, ioapicid[i]);
  102b7c:	0f b6 14 3b          	movzbl (%ebx,%edi,1),%edx
  102b80:	83 ec 0c             	sub    $0xc,%esp
  102b83:	0f b6 c0             	movzbl %al,%eax
  102b86:	52                   	push   %edx
  102b87:	50                   	push   %eax
  102b88:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  102b8c:	8d 83 c8 86 ff ff    	lea    -0x7938(%ebx),%eax
  102b92:	50                   	push   %eax
  102b93:	8d 83 0d 87 ff ff    	lea    -0x78f3(%ebx),%eax
  102b99:	6a 39                	push   $0x39
  102b9b:	50                   	push   %eax
  102b9c:	e8 5f 15 00 00       	call   104100 <debug_warn>
  102ba1:	83 c4 20             	add    $0x20,%esp
    base->reg = reg;
  102ba4:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    return base->data;
  102baa:	8b 6e 10             	mov    0x10(%esi),%ebp

        int maxintr = (ioapic_read(ioapic, IOAPIC_VER) >> 16) & 0xFF;
  102bad:	c1 ed 10             	shr    $0x10,%ebp
  102bb0:	89 e8                	mov    %ebp,%eax
  102bb2:	0f b6 e8             	movzbl %al,%ebp
  102bb5:	b8 20 00 00 00       	mov    $0x20,%eax
  102bba:	83 c5 21             	add    $0x21,%ebp
  102bbd:	8d 76 00             	lea    0x0(%esi),%esi

        // Mark all interrupts edge-triggered, active high, disabled,
        // and not routed to any CPUs.
        int j;
        for (j = 0; j <= maxintr; j++) {
            ioapic_write(ioapic, IOAPIC_TABLE + 2 * j,
  102bc0:	8d 14 00             	lea    (%eax,%eax,1),%edx
                         IOAPIC_INT_DISABLED | (T_IRQ0 + j));
  102bc3:	89 c1                	mov    %eax,%ecx
        for (j = 0; j <= maxintr; j++) {
  102bc5:	83 c0 01             	add    $0x1,%eax
  102bc8:	8d 5a d0             	lea    -0x30(%edx),%ebx
                         IOAPIC_INT_DISABLED | (T_IRQ0 + j));
  102bcb:	81 c9 00 00 01 00    	or     $0x10000,%ecx
    base->reg = reg;
  102bd1:	83 ea 2f             	sub    $0x2f,%edx
  102bd4:	89 1e                	mov    %ebx,(%esi)
    base->data = data;
  102bd6:	89 4e 10             	mov    %ecx,0x10(%esi)
    base->reg = reg;
  102bd9:	89 16                	mov    %edx,(%esi)
    base->data = data;
  102bdb:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        for (j = 0; j <= maxintr; j++) {
  102be2:	39 c5                	cmp    %eax,%ebp
  102be4:	75 da                	jne    102bc0 <ioapic_init+0xd0>
    for (i = 0; i < ioapic_num; i++) {
  102be6:	8b 04 24             	mov    (%esp),%eax
  102be9:	83 c7 01             	add    $0x1,%edi
  102bec:	8b 80 a0 88 02 00    	mov    0x288a0(%eax),%eax
  102bf2:	39 f8                	cmp    %edi,%eax
  102bf4:	0f 8f 3e ff ff ff    	jg     102b38 <ioapic_init+0x48>
            ioapic_write(ioapic, IOAPIC_TABLE + 2 * j + 1, 0);
        }
    }
}
  102bfa:	83 c4 1c             	add    $0x1c,%esp
  102bfd:	5b                   	pop    %ebx
  102bfe:	5e                   	pop    %esi
  102bff:	5f                   	pop    %edi
  102c00:	5d                   	pop    %ebp
  102c01:	c3                   	ret    
  102c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_ASSERT(ioapic != NULL);
  102c08:	ff 74 24 08          	push   0x8(%esp)
  102c0c:	ff 74 24 10          	push   0x10(%esp)
  102c10:	6a 2f                	push   $0x2f
  102c12:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  102c16:	8d 83 0d 87 ff ff    	lea    -0x78f3(%ebx),%eax
  102c1c:	50                   	push   %eax
  102c1d:	e8 0e 14 00 00       	call   104030 <debug_panic>
  102c22:	83 c4 10             	add    $0x10,%esp
  102c25:	e9 20 ff ff ff       	jmp    102b4a <ioapic_init+0x5a>
  102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102c30 <ioapic_enable>:

void ioapic_enable(uint8_t irq, lapicid_t apicid, bool trigger_mode, bool polarity)
{
  102c30:	55                   	push   %ebp
  102c31:	57                   	push   %edi
  102c32:	56                   	push   %esi
  102c33:	53                   	push   %ebx
  102c34:	e8 50 d7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102c39:	81 c3 c7 e3 00 00    	add    $0xe3c7,%ebx
  102c3f:	83 ec 2c             	sub    $0x2c,%esp
  102c42:	8b 44 24 44          	mov    0x44(%esp),%eax
  102c46:	8b 4c 24 40          	mov    0x40(%esp),%ecx
  102c4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  102c4e:	8b 44 24 48          	mov    0x48(%esp),%eax
  102c52:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
  102c56:	89 44 24 14          	mov    %eax,0x14(%esp)
  102c5a:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102c5e:	89 44 24 18          	mov    %eax,0x18(%esp)
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given APIC ID,
    int i;
    for (i = 0; i < ioapic_num; i++) {
  102c62:	8b 83 a0 88 02 00    	mov    0x288a0(%ebx),%eax
  102c68:	85 c0                	test   %eax,%eax
  102c6a:	0f 8e d8 00 00 00    	jle    102d48 <ioapic_enable+0x118>
            break;
        }
    }

    if (i == ioapic_num)
        KERN_PANIC("Cannot enable IRQ %d on IOAPIC.\n", irq);
  102c70:	0f b6 c9             	movzbl %cl,%ecx
    for (i = 0; i < ioapic_num; i++) {
  102c73:	31 c0                	xor    %eax,%eax
  102c75:	8d b3 c0 88 02 00    	lea    0x288c0(%ebx),%esi
  102c7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  102c7f:	90                   	nop
        ioapic_t *ioapic = ioapics[i];
  102c80:	8b 94 83 20 89 02 00 	mov    0x28920(%ebx,%eax,4),%edx
    base->reg = reg;
  102c87:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    return base->data;
  102c8d:	8b 7a 10             	mov    0x10(%edx),%edi
        if (irq >= gsi[i] && irq <= gsi[i] + maxintr) {
  102c90:	8b 2c 86             	mov    (%esi,%eax,4),%ebp
  102c93:	3b 6c 24 0c          	cmp    0xc(%esp),%ebp
  102c97:	7f 13                	jg     102cac <ioapic_enable+0x7c>
        int maxintr = (ioapic_read(ioapic, IOAPIC_VER) >> 16) & 0xFF;
  102c99:	c1 ef 10             	shr    $0x10,%edi
        if (irq >= gsi[i] && irq <= gsi[i] + maxintr) {
  102c9c:	8b 2c 86             	mov    (%esi,%eax,4),%ebp
        int maxintr = (ioapic_read(ioapic, IOAPIC_VER) >> 16) & 0xFF;
  102c9f:	89 f9                	mov    %edi,%ecx
  102ca1:	0f b6 f9             	movzbl %cl,%edi
        if (irq >= gsi[i] && irq <= gsi[i] + maxintr) {
  102ca4:	01 ef                	add    %ebp,%edi
  102ca6:	3b 7c 24 0c          	cmp    0xc(%esp),%edi
  102caa:	7d 24                	jge    102cd0 <ioapic_enable+0xa0>
    for (i = 0; i < ioapic_num; i++) {
  102cac:	8b 93 a0 88 02 00    	mov    0x288a0(%ebx),%edx
  102cb2:	83 c0 01             	add    $0x1,%eax
  102cb5:	39 c2                	cmp    %eax,%edx
  102cb7:	7f c7                	jg     102c80 <ioapic_enable+0x50>
    if (i == ioapic_num)
  102cb9:	8b 93 a0 88 02 00    	mov    0x288a0(%ebx),%edx
  102cbf:	39 c2                	cmp    %eax,%edx
  102cc1:	74 5f                	je     102d22 <ioapic_enable+0xf2>
}
  102cc3:	83 c4 2c             	add    $0x2c,%esp
  102cc6:	5b                   	pop    %ebx
  102cc7:	5e                   	pop    %esi
  102cc8:	5f                   	pop    %edi
  102cc9:	5d                   	pop    %ebp
  102cca:	c3                   	ret    
  102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102ccf:	90                   	nop
                         ((trigger_mode << 15) | (polarity << 13) | (T_IRQ0 + irq)));
  102cd0:	0f b6 6c 24 14       	movzbl 0x14(%esp),%ebp
  102cd5:	0f b6 7c 24 18       	movzbl 0x18(%esp),%edi
  102cda:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  102cde:	c1 e5 0f             	shl    $0xf,%ebp
  102ce1:	c1 e7 0d             	shl    $0xd,%edi
  102ce4:	09 ef                	or     %ebp,%edi
  102ce6:	8d 69 20             	lea    0x20(%ecx),%ebp
  102ce9:	09 fd                	or     %edi,%ebp
                         IOAPIC_TABLE + 2 * (irq - gsi[i]),
  102ceb:	8b 3c 86             	mov    (%esi,%eax,4),%edi
                         ((trigger_mode << 15) | (polarity << 13) | (T_IRQ0 + irq)));
  102cee:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
                         IOAPIC_TABLE + 2 * (irq - gsi[i]),
  102cf2:	89 cd                	mov    %ecx,%ebp
  102cf4:	29 fd                	sub    %edi,%ebp
            ioapic_write(ioapic,
  102cf6:	8d 7c 2d 10          	lea    0x10(%ebp,%ebp,1),%edi
    base->reg = reg;
  102cfa:	89 3a                	mov    %edi,(%edx)
    base->data = data;
  102cfc:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  102d00:	89 7a 10             	mov    %edi,0x10(%edx)
                         IOAPIC_TABLE + 2 * (irq - gsi[i]) + 1,
  102d03:	8b 34 86             	mov    (%esi,%eax,4),%esi
                         apicid << 24);
  102d06:	8b 7c 24 10          	mov    0x10(%esp),%edi
                         IOAPIC_TABLE + 2 * (irq - gsi[i]) + 1,
  102d0a:	29 f1                	sub    %esi,%ecx
                         apicid << 24);
  102d0c:	c1 e7 18             	shl    $0x18,%edi
            ioapic_write(ioapic,
  102d0f:	8d 4c 09 11          	lea    0x11(%ecx,%ecx,1),%ecx
    base->reg = reg;
  102d13:	89 0a                	mov    %ecx,(%edx)
    base->data = data;
  102d15:	89 7a 10             	mov    %edi,0x10(%edx)
    if (i == ioapic_num)
  102d18:	8b 93 a0 88 02 00    	mov    0x288a0(%ebx),%edx
  102d1e:	39 c2                	cmp    %eax,%edx
  102d20:	75 a1                	jne    102cc3 <ioapic_enable+0x93>
        KERN_PANIC("Cannot enable IRQ %d on IOAPIC.\n", irq);
  102d22:	0f b6 44 24 1c       	movzbl 0x1c(%esp),%eax
  102d27:	50                   	push   %eax
  102d28:	8d 83 ec 86 ff ff    	lea    -0x7914(%ebx),%eax
  102d2e:	50                   	push   %eax
  102d2f:	8d 83 0d 87 ff ff    	lea    -0x78f3(%ebx),%eax
  102d35:	6a 5d                	push   $0x5d
  102d37:	50                   	push   %eax
  102d38:	e8 f3 12 00 00       	call   104030 <debug_panic>
  102d3d:	83 c4 10             	add    $0x10,%esp
}
  102d40:	83 c4 2c             	add    $0x2c,%esp
  102d43:	5b                   	pop    %ebx
  102d44:	5e                   	pop    %esi
  102d45:	5f                   	pop    %edi
  102d46:	5d                   	pop    %ebp
  102d47:	c3                   	ret    
    for (i = 0; i < ioapic_num; i++) {
  102d48:	31 c0                	xor    %eax,%eax
  102d4a:	e9 6a ff ff ff       	jmp    102cb9 <ioapic_enable+0x89>
  102d4f:	90                   	nop

00102d50 <ioapic_number>:

int ioapic_number(void)
{
    return ioapic_num;
  102d50:	e8 2c d6 ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  102d55:	05 ab e2 00 00       	add    $0xe2ab,%eax
  102d5a:	8b 80 a0 88 02 00    	mov    0x288a0(%eax),%eax
}
  102d60:	c3                   	ret    
  102d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102d6f:	90                   	nop

00102d70 <ioapic_get>:

ioapic_t *ioapic_get(uint32_t idx)
{
    if (idx >= ioapic_num)
  102d70:	e8 0c d6 ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  102d75:	05 8b e2 00 00       	add    $0xe28b,%eax
{
  102d7a:	8b 54 24 04          	mov    0x4(%esp),%edx
    if (idx >= ioapic_num)
  102d7e:	8b 88 a0 88 02 00    	mov    0x288a0(%eax),%ecx
  102d84:	39 d1                	cmp    %edx,%ecx
  102d86:	76 08                	jbe    102d90 <ioapic_get+0x20>
        return NULL;
    return ioapics[idx];
  102d88:	8b 84 90 20 89 02 00 	mov    0x28920(%eax,%edx,4),%eax
  102d8f:	c3                   	ret    
        return NULL;
  102d90:	31 c0                	xor    %eax,%eax
}
  102d92:	c3                   	ret    
  102d93:	66 90                	xchg   %ax,%ax
  102d95:	66 90                	xchg   %ax,%ax
  102d97:	66 90                	xchg   %ax,%ax
  102d99:	66 90                	xchg   %ax,%ax
  102d9b:	66 90                	xchg   %ax,%ax
  102d9d:	66 90                	xchg   %ax,%ax
  102d9f:	90                   	nop

00102da0 <mpsearch1>:
    return sum;
}

/* Look for an MP structure in the len bytes at addr. */
static struct mp *mpsearch1(uint8_t *addr, int len)
{
  102da0:	55                   	push   %ebp
  102da1:	57                   	push   %edi
  102da2:	56                   	push   %esi
  102da3:	89 c6                	mov    %eax,%esi
    uint8_t *e, *p;

    e = addr + len;
  102da5:	01 d0                	add    %edx,%eax
{
  102da7:	53                   	push   %ebx
  102da8:	e8 dc d5 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102dad:	81 c3 53 e2 00 00    	add    $0xe253,%ebx
  102db3:	83 ec 1c             	sub    $0x1c,%esp
    e = addr + len;
  102db6:	89 44 24 0c          	mov    %eax,0xc(%esp)
    for (p = addr; p < e; p += sizeof(struct mp))
  102dba:	39 c6                	cmp    %eax,%esi
  102dbc:	73 5a                	jae    102e18 <mpsearch1+0x78>
  102dbe:	8d bb 2e 87 ff ff    	lea    -0x78d2(%ebx),%edi
  102dc4:	eb 12                	jmp    102dd8 <mpsearch1+0x38>
  102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102dcd:	8d 76 00             	lea    0x0(%esi),%esi
  102dd0:	89 ee                	mov    %ebp,%esi
  102dd2:	39 6c 24 0c          	cmp    %ebp,0xc(%esp)
  102dd6:	76 40                	jbe    102e18 <mpsearch1+0x78>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102dd8:	83 ec 04             	sub    $0x4,%esp
  102ddb:	8d 6e 10             	lea    0x10(%esi),%ebp
  102dde:	6a 04                	push   $0x4
  102de0:	57                   	push   %edi
  102de1:	56                   	push   %esi
  102de2:	e8 79 11 00 00       	call   103f60 <memcmp>
  102de7:	83 c4 10             	add    $0x10,%esp
  102dea:	89 c2                	mov    %eax,%edx
  102dec:	85 c0                	test   %eax,%eax
  102dee:	75 e0                	jne    102dd0 <mpsearch1+0x30>
  102df0:	89 f0                	mov    %esi,%eax
  102df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
  102df8:	0f b6 08             	movzbl (%eax),%ecx
    for (i = 0; i < len; i++)
  102dfb:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
  102dfe:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++)
  102e00:	39 e8                	cmp    %ebp,%eax
  102e02:	75 f4                	jne    102df8 <mpsearch1+0x58>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102e04:	84 d2                	test   %dl,%dl
  102e06:	75 c8                	jne    102dd0 <mpsearch1+0x30>
            return (struct mp *) p;
    return 0;
}
  102e08:	83 c4 1c             	add    $0x1c,%esp
  102e0b:	89 f0                	mov    %esi,%eax
  102e0d:	5b                   	pop    %ebx
  102e0e:	5e                   	pop    %esi
  102e0f:	5f                   	pop    %edi
  102e10:	5d                   	pop    %ebp
  102e11:	c3                   	ret    
  102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e18:	83 c4 1c             	add    $0x1c,%esp
    return 0;
  102e1b:	31 c0                	xor    %eax,%eax
}
  102e1d:	5b                   	pop    %ebx
  102e1e:	5e                   	pop    %esi
  102e1f:	5f                   	pop    %edi
  102e20:	5d                   	pop    %ebp
  102e21:	c3                   	ret    
  102e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102e30 <pcpu_mp_init>:

/*
 * Multiple processors initialization method using ACPI
 */
bool pcpu_mp_init(void)
{
  102e30:	55                   	push   %ebp
  102e31:	57                   	push   %edi
  102e32:	56                   	push   %esi
  102e33:	53                   	push   %ebx
  102e34:	e8 50 d5 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  102e39:	81 c3 c7 e1 00 00    	add    $0xe1c7,%ebx
  102e3f:	83 ec 2c             	sub    $0x2c,%esp
    acpi_xsdt_t *xsdt;
    acpi_madt_t *madt;
    uint32_t ap_idx = 1;
    bool found_bsp = FALSE;

    if (mp_inited == TRUE)
  102e42:	80 bb 61 89 02 00 01 	cmpb   $0x1,0x28961(%ebx)
  102e49:	0f 84 8a 01 00 00    	je     102fd9 <pcpu_mp_init+0x1a9>
        return TRUE;

    KERN_INFO("\n");
  102e4f:	83 ec 0c             	sub    $0xc,%esp
  102e52:	8d 83 cd 96 ff ff    	lea    -0x6933(%ebx),%eax
  102e58:	50                   	push   %eax
  102e59:	e8 62 11 00 00       	call   103fc0 <debug_info>

    if ((rsdp = acpi_probe_rsdp()) == NULL) {
  102e5e:	e8 ed f3 ff ff       	call   102250 <acpi_probe_rsdp>
  102e63:	83 c4 10             	add    $0x10,%esp
  102e66:	89 c6                	mov    %eax,%esi
  102e68:	85 c0                	test   %eax,%eax
  102e6a:	0f 84 90 02 00 00    	je     103100 <pcpu_mp_init+0x2d0>
        KERN_DEBUG("Not found RSDP.\n");
        goto fallback;
    }

    xsdt = NULL;
    if ((xsdt = acpi_probe_xsdt(rsdp)) == NULL &&
  102e70:	83 ec 0c             	sub    $0xc,%esp
  102e73:	50                   	push   %eax
  102e74:	e8 c7 f5 ff ff       	call   102440 <acpi_probe_xsdt>
  102e79:	83 c4 10             	add    $0x10,%esp
  102e7c:	85 c0                	test   %eax,%eax
  102e7e:	0f 84 1c 02 00 00    	je     1030a0 <pcpu_mp_init+0x270>
        goto fallback;
    }

    if ((madt =
         (xsdt != NULL) ?
         (acpi_madt_t *) acpi_probe_xsdt_ent(xsdt, ACPI_MADT_SIG) :
  102e84:	83 ec 08             	sub    $0x8,%esp
  102e87:	68 41 50 49 43       	push   $0x43495041
  102e8c:	50                   	push   %eax
  102e8d:	e8 3e f6 ff ff       	call   1024d0 <acpi_probe_xsdt_ent>
  102e92:	83 c4 10             	add    $0x10,%esp
  102e95:	89 c7                	mov    %eax,%edi
    if ((madt =
  102e97:	85 ff                	test   %edi,%edi
  102e99:	0f 84 59 04 00 00    	je     1032f8 <pcpu_mp_init+0x4c8>
        KERN_DEBUG("Not found MADT.\n");
        goto fallback;
    }

    ismp = TRUE;
    lapic_register(madt->lapic_addr);
  102e9f:	83 ec 0c             	sub    $0xc,%esp
  102ea2:	ff 77 24             	push   0x24(%edi)
    ncpu = 0;

    p = (uint8_t *) madt->ent;
  102ea5:	8d 6f 2c             	lea    0x2c(%edi),%ebp
    ismp = TRUE;
  102ea8:	c6 83 60 89 02 00 01 	movb   $0x1,0x28960(%ebx)
    lapic_register(madt->lapic_addr);
  102eaf:	e8 bc f6 ff ff       	call   102570 <lapic_register>
    e = (uint8_t *) madt + madt->length;
  102eb4:	8b 77 04             	mov    0x4(%edi),%esi

    while (p < e) {
  102eb7:	83 c4 10             	add    $0x10,%esp
    ncpu = 0;
  102eba:	c7 83 64 89 02 00 00 	movl   $0x0,0x28964(%ebx)
  102ec1:	00 00 00 
    e = (uint8_t *) madt + madt->length;
  102ec4:	01 fe                	add    %edi,%esi
    while (p < e) {
  102ec6:	39 f5                	cmp    %esi,%ebp
  102ec8:	0f 83 99 00 00 00    	jae    102f67 <pcpu_mp_init+0x137>

            if (!(lapic_ent->flags & ACPI_APIC_ENABLED)) {
                break;
            }

            KERN_INFO("\tCPU%d: APIC id = %x, ", ncpu, lapic_ent->lapic_id);
  102ece:	8d 83 68 87 ff ff    	lea    -0x7898(%ebx),%eax
    bool found_bsp = FALSE;
  102ed4:	31 c9                	xor    %ecx,%ecx
            if (!found_bsp) {
                found_bsp = TRUE;
                KERN_INFO("BSP\n");
                pcpu_mp_init_cpu(0, lapic_ent->lapic_id, TRUE);
            } else {
                KERN_INFO("AP\n");
  102ed6:	89 7c 24 14          	mov    %edi,0x14(%esp)
  102eda:	89 ef                	mov    %ebp,%edi
            KERN_INFO("\tCPU%d: APIC id = %x, ", ncpu, lapic_ent->lapic_id);
  102edc:	89 44 24 10          	mov    %eax,0x10(%esp)
                KERN_INFO("AP\n");
  102ee0:	8d 83 84 87 ff ff    	lea    -0x787c(%ebx),%eax
  102ee6:	89 cd                	mov    %ecx,%ebp
    uint32_t ap_idx = 1;
  102ee8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  102eef:	00 
                KERN_INFO("AP\n");
  102ef0:	89 44 24 18          	mov    %eax,0x18(%esp)
  102ef4:	eb 27                	jmp    102f1d <pcpu_mp_init+0xed>
  102ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102efd:	8d 76 00             	lea    0x0(%esi),%esi

            ioapic_register(ioapic_ent->ioapic_addr, ioapic_ent->ioapic_id,
                            ioapic_ent->gsi);
            break;
        default:
            KERN_INFO("\tUnhandled ACPI entry (type=%x)\n", hdr->type);
  102f00:	83 ec 08             	sub    $0x8,%esp
  102f03:	50                   	push   %eax
  102f04:	8d 83 38 88 ff ff    	lea    -0x77c8(%ebx),%eax
  102f0a:	50                   	push   %eax
  102f0b:	e8 b0 10 00 00       	call   103fc0 <debug_info>
            break;
  102f10:	83 c4 10             	add    $0x10,%esp
        }

        p += hdr->length;
  102f13:	0f b6 47 01          	movzbl 0x1(%edi),%eax
  102f17:	01 c7                	add    %eax,%edi
    while (p < e) {
  102f19:	39 fe                	cmp    %edi,%esi
  102f1b:	76 46                	jbe    102f63 <pcpu_mp_init+0x133>
        switch (hdr->type) {
  102f1d:	0f b6 07             	movzbl (%edi),%eax
  102f20:	84 c0                	test   %al,%al
  102f22:	0f 84 c8 00 00 00    	je     102ff0 <pcpu_mp_init+0x1c0>
  102f28:	3c 01                	cmp    $0x1,%al
  102f2a:	75 d4                	jne    102f00 <pcpu_mp_init+0xd0>
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  102f2c:	83 ec 04             	sub    $0x4,%esp
  102f2f:	ff 77 04             	push   0x4(%edi)
  102f32:	0f b6 47 02          	movzbl 0x2(%edi),%eax
  102f36:	50                   	push   %eax
  102f37:	8d 83 14 88 ff ff    	lea    -0x77ec(%ebx),%eax
  102f3d:	50                   	push   %eax
  102f3e:	e8 7d 10 00 00       	call   103fc0 <debug_info>
            ioapic_register(ioapic_ent->ioapic_addr, ioapic_ent->ioapic_id,
  102f43:	83 c4 0c             	add    $0xc,%esp
  102f46:	ff 77 08             	push   0x8(%edi)
  102f49:	0f b6 47 02          	movzbl 0x2(%edi),%eax
  102f4d:	50                   	push   %eax
  102f4e:	ff 77 04             	push   0x4(%edi)
  102f51:	e8 0a fb ff ff       	call   102a60 <ioapic_register>
        p += hdr->length;
  102f56:	0f b6 47 01          	movzbl 0x1(%edi),%eax
            break;
  102f5a:	83 c4 10             	add    $0x10,%esp
        p += hdr->length;
  102f5d:	01 c7                	add    %eax,%edi
    while (p < e) {
  102f5f:	39 fe                	cmp    %edi,%esi
  102f61:	77 ba                	ja     102f1d <pcpu_mp_init+0xed>
  102f63:	8b 7c 24 14          	mov    0x14(%esp),%edi
    /*
     * Force NMI and 8259 signals to APIC when PIC mode
     * is not implemented.
     *
     */
    if ((madt->flags & APIC_MADT_PCAT_COMPAT) == 0) {
  102f67:	f6 47 28 01          	testb  $0x1,0x28(%edi)
  102f6b:	0f 84 5f 01 00 00    	je     1030d0 <pcpu_mp_init+0x2a0>
    }

    /*
     * Copy AP boot code to 0x8000.
     */
    memmove((uint8_t *) 0x8000,
  102f71:	83 ec 04             	sub    $0x4,%esp
  102f74:	ff b3 e8 ff ff ff    	push   -0x18(%ebx)
  102f7a:	ff b3 fc ff ff ff    	push   -0x4(%ebx)
  102f80:	68 00 80 00 00       	push   $0x8000
  102f85:	e8 16 0e 00 00       	call   103da0 <memmove>
            _binary___obj_kern_init_boot_ap_start,
            (size_t) _binary___obj_kern_init_boot_ap_size);

    mp_inited = TRUE;
    return TRUE;
  102f8a:	83 c4 10             	add    $0x10,%esp
  102f8d:	b8 01 00 00 00       	mov    $0x1,%eax
    mp_inited = TRUE;
  102f92:	c6 83 61 89 02 00 01 	movb   $0x1,0x28961(%ebx)
        ismp = 0;
        ncpu = 1;
        return FALSE;
    } else
        return TRUE;
}
  102f99:	83 c4 2c             	add    $0x2c,%esp
  102f9c:	5b                   	pop    %ebx
  102f9d:	5e                   	pop    %esi
  102f9e:	5f                   	pop    %edi
  102f9f:	5d                   	pop    %ebp
  102fa0:	c3                   	ret    
  102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102fa8:	8b 7c 24 18          	mov    0x18(%esp),%edi
    if (mp->imcrp) {
  102fac:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
  102fb0:	0f 85 51 04 00 00    	jne    103407 <pcpu_mp_init+0x5d7>
    memcpy((uint8_t *) 0x8000,
  102fb6:	83 ec 04             	sub    $0x4,%esp
  102fb9:	ff b3 e8 ff ff ff    	push   -0x18(%ebx)
  102fbf:	ff b3 fc ff ff ff    	push   -0x4(%ebx)
  102fc5:	68 00 80 00 00       	push   $0x8000
  102fca:	e8 41 0e 00 00       	call   103e10 <memcpy>
    mp_inited = TRUE;
  102fcf:	c6 83 61 89 02 00 01 	movb   $0x1,0x28961(%ebx)
  102fd6:	83 c4 10             	add    $0x10,%esp
}
  102fd9:	83 c4 2c             	add    $0x2c,%esp
        return TRUE;
  102fdc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  102fe1:	5b                   	pop    %ebx
  102fe2:	5e                   	pop    %esi
  102fe3:	5f                   	pop    %edi
  102fe4:	5d                   	pop    %ebp
  102fe5:	c3                   	ret    
  102fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102fed:	8d 76 00             	lea    0x0(%esi),%esi
            if (!(lapic_ent->flags & ACPI_APIC_ENABLED)) {
  102ff0:	f6 47 04 01          	testb  $0x1,0x4(%edi)
  102ff4:	0f 84 19 ff ff ff    	je     102f13 <pcpu_mp_init+0xe3>
            KERN_INFO("\tCPU%d: APIC id = %x, ", ncpu, lapic_ent->lapic_id);
  102ffa:	0f b6 47 03          	movzbl 0x3(%edi),%eax
  102ffe:	83 ec 04             	sub    $0x4,%esp
  103001:	50                   	push   %eax
  103002:	ff b3 64 89 02 00    	push   0x28964(%ebx)
  103008:	ff 74 24 1c          	push   0x1c(%esp)
  10300c:	e8 af 0f 00 00       	call   103fc0 <debug_info>
            if (!found_bsp) {
  103011:	89 e8                	mov    %ebp,%eax
  103013:	83 c4 10             	add    $0x10,%esp
  103016:	84 c0                	test   %al,%al
  103018:	74 4e                	je     103068 <pcpu_mp_init+0x238>
                KERN_INFO("AP\n");
  10301a:	83 ec 0c             	sub    $0xc,%esp
  10301d:	ff 74 24 24          	push   0x24(%esp)
  103021:	e8 9a 0f 00 00       	call   103fc0 <debug_info>
    if (idx >= NUM_CPUS)
  103026:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  10302a:	83 c4 10             	add    $0x10,%esp
  10302d:	83 f8 07             	cmp    $0x7,%eax
  103030:	77 1b                	ja     10304d <pcpu_mp_init+0x21d>
    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  103032:	83 ec 0c             	sub    $0xc,%esp
                pcpu_mp_init_cpu(ap_idx, lapic_ent->lapic_id, FALSE);
  103035:	0f b6 6f 03          	movzbl 0x3(%edi),%ebp
    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  103039:	50                   	push   %eax
  10303a:	e8 51 2f 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    info->lapicid = lapic_id;
  10303f:	89 e9                	mov    %ebp,%ecx
    info->bsp = is_bsp;
  103041:	83 c4 10             	add    $0x10,%esp
    info->lapicid = lapic_id;
  103044:	0f b6 c9             	movzbl %cl,%ecx
    info->bsp = is_bsp;
  103047:	c6 40 04 00          	movb   $0x0,0x4(%eax)
    info->lapicid = lapic_id;
  10304b:	89 08                	mov    %ecx,(%eax)
                ap_idx++;
  10304d:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
            ncpu++;
  103052:	83 83 64 89 02 00 01 	addl   $0x1,0x28964(%ebx)
            break;
  103059:	bd 01 00 00 00       	mov    $0x1,%ebp
  10305e:	e9 b0 fe ff ff       	jmp    102f13 <pcpu_mp_init+0xe3>
  103063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103067:	90                   	nop
                KERN_INFO("BSP\n");
  103068:	83 ec 0c             	sub    $0xc,%esp
  10306b:	8d 83 7f 87 ff ff    	lea    -0x7881(%ebx),%eax
  103071:	50                   	push   %eax
  103072:	e8 49 0f 00 00       	call   103fc0 <debug_info>
                pcpu_mp_init_cpu(0, lapic_ent->lapic_id, TRUE);
  103077:	0f b6 6f 03          	movzbl 0x3(%edi),%ebp
    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  10307b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103082:	e8 09 2f 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    info->bsp = is_bsp;
  103087:	83 c4 10             	add    $0x10,%esp
    info->lapicid = lapic_id;
  10308a:	89 e9                	mov    %ebp,%ecx
    info->bsp = is_bsp;
  10308c:	c6 40 04 01          	movb   $0x1,0x4(%eax)
    info->lapicid = lapic_id;
  103090:	0f b6 e9             	movzbl %cl,%ebp
  103093:	89 28                	mov    %ebp,(%eax)
    info->bsp = is_bsp;
  103095:	eb bb                	jmp    103052 <pcpu_mp_init+0x222>
  103097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10309e:	66 90                	xchg   %ax,%ax
        (rsdt = acpi_probe_rsdt(rsdp)) == NULL) {
  1030a0:	83 ec 0c             	sub    $0xc,%esp
  1030a3:	56                   	push   %esi
  1030a4:	e8 67 f2 ff ff       	call   102310 <acpi_probe_rsdt>
    if ((xsdt = acpi_probe_xsdt(rsdp)) == NULL &&
  1030a9:	83 c4 10             	add    $0x10,%esp
  1030ac:	85 c0                	test   %eax,%eax
  1030ae:	0f 84 83 03 00 00    	je     103437 <pcpu_mp_init+0x607>
         (acpi_madt_t *) acpi_probe_rsdt_ent(rsdt, ACPI_MADT_SIG)) == NULL) {
  1030b4:	83 ec 08             	sub    $0x8,%esp
  1030b7:	68 41 50 49 43       	push   $0x43495041
  1030bc:	50                   	push   %eax
  1030bd:	e8 de f2 ff ff       	call   1023a0 <acpi_probe_rsdt_ent>
  1030c2:	83 c4 10             	add    $0x10,%esp
  1030c5:	89 c7                	mov    %eax,%edi
  1030c7:	e9 cb fd ff ff       	jmp    102e97 <pcpu_mp_init+0x67>
  1030cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        outb(0x22, 0x70);
  1030d0:	83 ec 08             	sub    $0x8,%esp
  1030d3:	6a 70                	push   $0x70
  1030d5:	6a 22                	push   $0x22
  1030d7:	e8 a4 1d 00 00       	call   104e80 <outb>
        outb(0x23, inb(0x23) | 1);
  1030dc:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
  1030e3:	e8 68 1d 00 00       	call   104e50 <inb>
  1030e8:	5e                   	pop    %esi
  1030e9:	5f                   	pop    %edi
  1030ea:	83 c8 01             	or     $0x1,%eax
  1030ed:	0f b6 c0             	movzbl %al,%eax
  1030f0:	50                   	push   %eax
  1030f1:	6a 23                	push   $0x23
  1030f3:	e8 88 1d 00 00       	call   104e80 <outb>
  1030f8:	83 c4 10             	add    $0x10,%esp
  1030fb:	e9 71 fe ff ff       	jmp    102f71 <pcpu_mp_init+0x141>
        KERN_DEBUG("Not found RSDP.\n");
  103100:	83 ec 04             	sub    $0x4,%esp
  103103:	8d 83 33 87 ff ff    	lea    -0x78cd(%ebx),%eax
  103109:	50                   	push   %eax
  10310a:	68 4f 01 00 00       	push   $0x14f
        KERN_DEBUG("Not found MADT.\n");
  10310f:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  103115:	89 44 24 18          	mov    %eax,0x18(%esp)
  103119:	50                   	push   %eax
  10311a:	e8 d1 0e 00 00       	call   103ff0 <debug_normal>
        goto fallback;
  10311f:	83 c4 10             	add    $0x10,%esp
    KERN_DEBUG("Use the fallback multiprocessor initialization.\n");
  103122:	8d 83 5c 88 ff ff    	lea    -0x77a4(%ebx),%eax
  103128:	83 ec 04             	sub    $0x4,%esp
  10312b:	50                   	push   %eax
  10312c:	68 ac 01 00 00       	push   $0x1ac
  103131:	ff 74 24 18          	push   0x18(%esp)
  103135:	e8 b6 0e 00 00       	call   103ff0 <debug_normal>
    if (mp_inited == TRUE)
  10313a:	83 c4 10             	add    $0x10,%esp
  10313d:	80 bb 61 89 02 00 01 	cmpb   $0x1,0x28961(%ebx)
  103144:	0f 84 8f fe ff ff    	je     102fd9 <pcpu_mp_init+0x1a9>
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
  10314a:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  103151:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  103158:	c1 e0 08             	shl    $0x8,%eax
  10315b:	09 d0                	or     %edx,%eax
  10315d:	c1 e0 04             	shl    $0x4,%eax
  103160:	75 1b                	jne    10317d <pcpu_mp_init+0x34d>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
  103162:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  103169:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  103170:	c1 e0 08             	shl    $0x8,%eax
  103173:	09 d0                	or     %edx,%eax
  103175:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1((uint8_t *) p - 1024, 1024)))
  103178:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1((uint8_t *) p, 1024)))
  10317d:	ba 00 04 00 00       	mov    $0x400,%edx
  103182:	e8 19 fc ff ff       	call   102da0 <mpsearch1>
  103187:	89 c7                	mov    %eax,%edi
  103189:	85 c0                	test   %eax,%eax
  10318b:	0f 84 ef 01 00 00    	je     103380 <pcpu_mp_init+0x550>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0)
  103191:	8b 77 04             	mov    0x4(%edi),%esi
  103194:	85 f6                	test   %esi,%esi
  103196:	0f 84 e4 00 00 00    	je     103280 <pcpu_mp_init+0x450>
    if (memcmp(conf, "PCMP", 4) != 0)
  10319c:	83 ec 04             	sub    $0x4,%esp
  10319f:	8d 83 88 87 ff ff    	lea    -0x7878(%ebx),%eax
  1031a5:	6a 04                	push   $0x4
  1031a7:	50                   	push   %eax
  1031a8:	56                   	push   %esi
  1031a9:	e8 b2 0d 00 00       	call   103f60 <memcmp>
  1031ae:	83 c4 10             	add    $0x10,%esp
  1031b1:	89 c2                	mov    %eax,%edx
  1031b3:	85 c0                	test   %eax,%eax
  1031b5:	0f 85 c5 00 00 00    	jne    103280 <pcpu_mp_init+0x450>
    if (conf->version != 1 && conf->version != 4)
  1031bb:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  1031bf:	3c 01                	cmp    $0x1,%al
  1031c1:	74 08                	je     1031cb <pcpu_mp_init+0x39b>
  1031c3:	3c 04                	cmp    $0x4,%al
  1031c5:	0f 85 b5 00 00 00    	jne    103280 <pcpu_mp_init+0x450>
    if (sum((uint8_t *) conf, conf->length) != 0)
  1031cb:	0f b7 6e 04          	movzwl 0x4(%esi),%ebp
    for (i = 0; i < len; i++)
  1031cf:	66 85 ed             	test   %bp,%bp
  1031d2:	74 20                	je     1031f4 <pcpu_mp_init+0x3c4>
  1031d4:	89 f0                	mov    %esi,%eax
  1031d6:	01 f5                	add    %esi,%ebp
  1031d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1031df:	90                   	nop
        sum += addr[i];
  1031e0:	0f b6 08             	movzbl (%eax),%ecx
    for (i = 0; i < len; i++)
  1031e3:	83 c0 01             	add    $0x1,%eax
        sum += addr[i];
  1031e6:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++)
  1031e8:	39 c5                	cmp    %eax,%ebp
  1031ea:	75 f4                	jne    1031e0 <pcpu_mp_init+0x3b0>
    if (sum((uint8_t *) conf, conf->length) != 0)
  1031ec:	84 d2                	test   %dl,%dl
  1031ee:	0f 85 8c 00 00 00    	jne    103280 <pcpu_mp_init+0x450>
    lapic_register((uintptr_t) conf->lapicaddr);
  1031f4:	83 ec 0c             	sub    $0xc,%esp
  1031f7:	ff 76 24             	push   0x24(%esi)
    for (p = (uint8_t *) (conf + 1), e = (uint8_t *) conf + conf->length; p < e;) {
  1031fa:	8d 6e 2c             	lea    0x2c(%esi),%ebp
    ismp = 1;
  1031fd:	c6 83 60 89 02 00 01 	movb   $0x1,0x28960(%ebx)
    ncpu = 0;
  103204:	c7 83 64 89 02 00 00 	movl   $0x0,0x28964(%ebx)
  10320b:	00 00 00 
    lapic_register((uintptr_t) conf->lapicaddr);
  10320e:	e8 5d f3 ff ff       	call   102570 <lapic_register>
    for (p = (uint8_t *) (conf + 1), e = (uint8_t *) conf + conf->length; p < e;) {
  103213:	0f b7 56 04          	movzwl 0x4(%esi),%edx
  103217:	83 c4 10             	add    $0x10,%esp
  10321a:	01 d6                	add    %edx,%esi
  10321c:	39 f5                	cmp    %esi,%ebp
  10321e:	0f 83 88 fd ff ff    	jae    102fac <pcpu_mp_init+0x17c>
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  103224:	8d 83 14 88 ff ff    	lea    -0x77ec(%ebx),%eax
            KERN_WARN("mpinit: unknown config type %x\n", *p);
  10322a:	89 7c 24 18          	mov    %edi,0x18(%esp)
  10322e:	89 ef                	mov    %ebp,%edi
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  103230:	89 44 24 10          	mov    %eax,0x10(%esp)
            KERN_WARN("mpinit: unknown config type %x\n", *p);
  103234:	8d 83 90 88 ff ff    	lea    -0x7770(%ebx),%eax
    uint32_t ap_idx = 1;
  10323a:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  103241:	00 
            KERN_WARN("mpinit: unknown config type %x\n", *p);
  103242:	89 44 24 14          	mov    %eax,0x14(%esp)
  103246:	eb 13                	jmp    10325b <pcpu_mp_init+0x42b>
  103248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10324f:	90                   	nop
            p += 8;
  103250:	83 c7 08             	add    $0x8,%edi
    for (p = (uint8_t *) (conf + 1), e = (uint8_t *) conf + conf->length; p < e;) {
  103253:	39 fe                	cmp    %edi,%esi
  103255:	0f 86 4d fd ff ff    	jbe    102fa8 <pcpu_mp_init+0x178>
        switch (*p) {
  10325b:	0f b6 17             	movzbl (%edi),%edx
  10325e:	80 fa 02             	cmp    $0x2,%dl
  103261:	74 5d                	je     1032c0 <pcpu_mp_init+0x490>
  103263:	77 3b                	ja     1032a0 <pcpu_mp_init+0x470>
  103265:	84 d2                	test   %dl,%dl
  103267:	75 e7                	jne    103250 <pcpu_mp_init+0x420>
            p += sizeof(struct mpproc);
  103269:	8d 6f 14             	lea    0x14(%edi),%ebp
            if (!(proc->flags & MPENAB))
  10326c:	f6 47 03 01          	testb  $0x1,0x3(%edi)
  103270:	0f 85 9a 00 00 00    	jne    103310 <pcpu_mp_init+0x4e0>
            p += sizeof(struct mpproc);
  103276:	89 ef                	mov    %ebp,%edi
  103278:	eb d9                	jmp    103253 <pcpu_mp_init+0x423>
  10327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        ismp = 0;
  103280:	c6 83 60 89 02 00 00 	movb   $0x0,0x28960(%ebx)
        return FALSE;
  103287:	31 c0                	xor    %eax,%eax
        ncpu = 1;
  103289:	c7 83 64 89 02 00 01 	movl   $0x1,0x28964(%ebx)
  103290:	00 00 00 
}
  103293:	83 c4 2c             	add    $0x2c,%esp
  103296:	5b                   	pop    %ebx
  103297:	5e                   	pop    %esi
  103298:	5f                   	pop    %edi
  103299:	5d                   	pop    %ebp
  10329a:	c3                   	ret    
  10329b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10329f:	90                   	nop
        switch (*p) {
  1032a0:	8d 4a fd             	lea    -0x3(%edx),%ecx
  1032a3:	80 f9 01             	cmp    $0x1,%cl
  1032a6:	76 a8                	jbe    103250 <pcpu_mp_init+0x420>
            KERN_WARN("mpinit: unknown config type %x\n", *p);
  1032a8:	52                   	push   %edx
  1032a9:	ff 74 24 18          	push   0x18(%esp)
  1032ad:	68 28 01 00 00       	push   $0x128
  1032b2:	ff 74 24 18          	push   0x18(%esp)
  1032b6:	e8 45 0e 00 00       	call   104100 <debug_warn>
  1032bb:	83 c4 10             	add    $0x10,%esp
  1032be:	eb 93                	jmp    103253 <pcpu_mp_init+0x423>
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  1032c0:	83 ec 04             	sub    $0x4,%esp
  1032c3:	ff 77 04             	push   0x4(%edi)
  1032c6:	0f b6 57 01          	movzbl 0x1(%edi),%edx
            p += sizeof(struct mpioapic);
  1032ca:	8d 6f 08             	lea    0x8(%edi),%ebp
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  1032cd:	52                   	push   %edx
  1032ce:	ff 74 24 1c          	push   0x1c(%esp)
  1032d2:	e8 e9 0c 00 00       	call   103fc0 <debug_info>
            ioapic_register((uintptr_t) mpio->addr, mpio->apicno, 0);
  1032d7:	83 c4 0c             	add    $0xc,%esp
  1032da:	6a 00                	push   $0x0
  1032dc:	0f b6 57 01          	movzbl 0x1(%edi),%edx
  1032e0:	52                   	push   %edx
  1032e1:	ff 77 04             	push   0x4(%edi)
            p += sizeof(struct mpioapic);
  1032e4:	89 ef                	mov    %ebp,%edi
            ioapic_register((uintptr_t) mpio->addr, mpio->apicno, 0);
  1032e6:	e8 75 f7 ff ff       	call   102a60 <ioapic_register>
            continue;
  1032eb:	83 c4 10             	add    $0x10,%esp
  1032ee:	e9 60 ff ff ff       	jmp    103253 <pcpu_mp_init+0x423>
  1032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1032f7:	90                   	nop
        KERN_DEBUG("Not found MADT.\n");
  1032f8:	83 ec 04             	sub    $0x4,%esp
  1032fb:	8d 83 57 87 ff ff    	lea    -0x78a9(%ebx),%eax
  103301:	50                   	push   %eax
  103302:	68 5e 01 00 00       	push   $0x15e
  103307:	e9 03 fe ff ff       	jmp    10310f <pcpu_mp_init+0x2df>
  10330c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            KERN_INFO("\tCPU%d: APIC id = %x, ", ncpu, proc->apicid);
  103310:	0f b6 4f 01          	movzbl 0x1(%edi),%ecx
  103314:	83 ec 04             	sub    $0x4,%esp
  103317:	51                   	push   %ecx
  103318:	8d 8b 68 87 ff ff    	lea    -0x7898(%ebx),%ecx
  10331e:	ff b3 64 89 02 00    	push   0x28964(%ebx)
  103324:	51                   	push   %ecx
  103325:	e8 96 0c 00 00       	call   103fc0 <debug_info>
            if (proc->flags & MPBOOT) {
  10332a:	83 c4 10             	add    $0x10,%esp
  10332d:	f6 47 03 02          	testb  $0x2,0x3(%edi)
  103331:	0f 85 9e 00 00 00    	jne    1033d5 <pcpu_mp_init+0x5a5>
                KERN_INFO("AP.\n");
  103337:	83 ec 0c             	sub    $0xc,%esp
  10333a:	8d 8b 93 87 ff ff    	lea    -0x786d(%ebx),%ecx
  103340:	51                   	push   %ecx
  103341:	e8 7a 0c 00 00       	call   103fc0 <debug_info>
    if (idx >= NUM_CPUS)
  103346:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  10334a:	83 c4 10             	add    $0x10,%esp
  10334d:	83 f8 07             	cmp    $0x7,%eax
  103350:	77 1b                	ja     10336d <pcpu_mp_init+0x53d>
    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  103352:	83 ec 0c             	sub    $0xc,%esp
                pcpu_mp_init_cpu(ap_idx, proc->apicid, FALSE);
  103355:	0f b6 7f 01          	movzbl 0x1(%edi),%edi
    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  103359:	50                   	push   %eax
  10335a:	e8 31 2c 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    info->lapicid = lapic_id;
  10335f:	89 f9                	mov    %edi,%ecx
    info->bsp = is_bsp;
  103361:	83 c4 10             	add    $0x10,%esp
    info->lapicid = lapic_id;
  103364:	0f b6 d1             	movzbl %cl,%edx
    info->bsp = is_bsp;
  103367:	c6 40 04 00          	movb   $0x0,0x4(%eax)
    info->lapicid = lapic_id;
  10336b:	89 10                	mov    %edx,(%eax)
                ap_idx++;
  10336d:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
            ncpu++;
  103372:	83 83 64 89 02 00 01 	addl   $0x1,0x28964(%ebx)
            p += sizeof(struct mpproc);
  103379:	89 ef                	mov    %ebp,%edi
            continue;
  10337b:	e9 d3 fe ff ff       	jmp    103253 <pcpu_mp_init+0x423>
            break;
  103380:	bf 00 00 0f 00       	mov    $0xf0000,%edi
  103385:	8d b3 2e 87 ff ff    	lea    -0x78d2(%ebx),%esi
  10338b:	eb 11                	jmp    10339e <pcpu_mp_init+0x56e>
  10338d:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = addr; p < e; p += sizeof(struct mp))
  103390:	89 ef                	mov    %ebp,%edi
  103392:	81 fd 00 00 10 00    	cmp    $0x100000,%ebp
  103398:	0f 84 e2 fe ff ff    	je     103280 <pcpu_mp_init+0x450>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  10339e:	83 ec 04             	sub    $0x4,%esp
  1033a1:	8d 6f 10             	lea    0x10(%edi),%ebp
  1033a4:	6a 04                	push   $0x4
  1033a6:	56                   	push   %esi
  1033a7:	57                   	push   %edi
  1033a8:	e8 b3 0b 00 00       	call   103f60 <memcmp>
  1033ad:	83 c4 10             	add    $0x10,%esp
  1033b0:	85 c0                	test   %eax,%eax
  1033b2:	75 dc                	jne    103390 <pcpu_mp_init+0x560>
  1033b4:	89 fa                	mov    %edi,%edx
  1033b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1033bd:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
  1033c0:	0f b6 0a             	movzbl (%edx),%ecx
    for (i = 0; i < len; i++)
  1033c3:	83 c2 01             	add    $0x1,%edx
        sum += addr[i];
  1033c6:	01 c8                	add    %ecx,%eax
    for (i = 0; i < len; i++)
  1033c8:	39 d5                	cmp    %edx,%ebp
  1033ca:	75 f4                	jne    1033c0 <pcpu_mp_init+0x590>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  1033cc:	84 c0                	test   %al,%al
  1033ce:	75 c0                	jne    103390 <pcpu_mp_init+0x560>
  1033d0:	e9 bc fd ff ff       	jmp    103191 <pcpu_mp_init+0x361>
                KERN_INFO("BSP.\n");
  1033d5:	83 ec 0c             	sub    $0xc,%esp
  1033d8:	8d 8b 8d 87 ff ff    	lea    -0x7873(%ebx),%ecx
  1033de:	51                   	push   %ecx
  1033df:	e8 dc 0b 00 00       	call   103fc0 <debug_info>
                pcpu_mp_init_cpu(0, proc->apicid, TRUE);
  1033e4:	0f b6 7f 01          	movzbl 0x1(%edi),%edi
    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  1033e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1033ef:	e8 9c 2b 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    info->bsp = is_bsp;
  1033f4:	83 c4 10             	add    $0x10,%esp
    info->lapicid = lapic_id;
  1033f7:	89 f9                	mov    %edi,%ecx
    info->bsp = is_bsp;
  1033f9:	c6 40 04 01          	movb   $0x1,0x4(%eax)
    info->lapicid = lapic_id;
  1033fd:	0f b6 d1             	movzbl %cl,%edx
  103400:	89 10                	mov    %edx,(%eax)
    info->bsp = is_bsp;
  103402:	e9 6b ff ff ff       	jmp    103372 <pcpu_mp_init+0x542>
        outb(0x22, 0x70);
  103407:	83 ec 08             	sub    $0x8,%esp
  10340a:	6a 70                	push   $0x70
  10340c:	6a 22                	push   $0x22
  10340e:	e8 6d 1a 00 00       	call   104e80 <outb>
        outb(0x23, inb(0x23) | 1);
  103413:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
  10341a:	e8 31 1a 00 00       	call   104e50 <inb>
  10341f:	5a                   	pop    %edx
  103420:	59                   	pop    %ecx
  103421:	83 c8 01             	or     $0x1,%eax
  103424:	0f b6 c0             	movzbl %al,%eax
  103427:	50                   	push   %eax
  103428:	6a 23                	push   $0x23
  10342a:	e8 51 1a 00 00       	call   104e80 <outb>
  10342f:	83 c4 10             	add    $0x10,%esp
  103432:	e9 7f fb ff ff       	jmp    102fb6 <pcpu_mp_init+0x186>
        KERN_DEBUG("Not found either RSDT or XSDT.\n");
  103437:	83 ec 04             	sub    $0x4,%esp
  10343a:	8d 83 f4 87 ff ff    	lea    -0x780c(%ebx),%eax
  103440:	50                   	push   %eax
  103441:	68 56 01 00 00       	push   $0x156
  103446:	e9 c4 fc ff ff       	jmp    10310f <pcpu_mp_init+0x2df>
  10344b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10344f:	90                   	nop

00103450 <pcpu_boot_ap>:

int pcpu_boot_ap(uint32_t cpu_idx, void (*f)(void), uintptr_t stack_addr)
{
  103450:	57                   	push   %edi
  103451:	56                   	push   %esi
  103452:	53                   	push   %ebx
  103453:	8b 74 24 10          	mov    0x10(%esp),%esi
  103457:	e8 2d cf ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10345c:	81 c3 a4 db 00 00    	add    $0xdba4,%ebx
  103462:	8b 7c 24 14          	mov    0x14(%esp),%edi
    KERN_ASSERT(cpu_idx > 0 && cpu_idx < pcpu_ncpu());
  103466:	85 f6                	test   %esi,%esi
  103468:	74 6e                	je     1034d8 <pcpu_boot_ap+0x88>
  10346a:	3b b3 64 89 02 00    	cmp    0x28964(%ebx),%esi
  103470:	73 66                	jae    1034d8 <pcpu_boot_ap+0x88>
    KERN_ASSERT(get_pcpu_inited_info(cpu_idx) == TRUE);
  103472:	83 ec 0c             	sub    $0xc,%esp
  103475:	56                   	push   %esi
  103476:	e8 35 2b 00 00       	call   105fb0 <get_pcpu_inited_info>
  10347b:	83 c4 10             	add    $0x10,%esp
  10347e:	3c 01                	cmp    $0x1,%al
  103480:	74 22                	je     1034a4 <pcpu_boot_ap+0x54>
  103482:	8d 83 d8 88 ff ff    	lea    -0x7728(%ebx),%eax
  103488:	50                   	push   %eax
  103489:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10348f:	50                   	push   %eax
  103490:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  103496:	68 b8 01 00 00       	push   $0x1b8
  10349b:	50                   	push   %eax
  10349c:	e8 8f 0b 00 00       	call   104030 <debug_panic>
  1034a1:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(f != NULL);
  1034a4:	85 ff                	test   %edi,%edi
  1034a6:	0f 84 54 01 00 00    	je     103600 <pcpu_boot_ap+0x1b0>
    return ismp;
}

bool pcpu_onboot(void)
{
    int cpu_idx = get_pcpu_idx();
  1034ac:	e8 9f 29 00 00       	call   105e50 <get_pcpu_idx>
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  1034b1:	83 ec 0c             	sub    $0xc,%esp
  1034b4:	50                   	push   %eax
  1034b5:	e8 d6 2a 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    return (mp_inited == TRUE) ? arch_info->bsp : (get_pcpu_idx() == 0);
  1034ba:	83 c4 10             	add    $0x10,%esp
  1034bd:	80 bb 61 89 02 00 01 	cmpb   $0x1,0x28961(%ebx)
  1034c4:	75 3a                	jne    103500 <pcpu_boot_ap+0xb0>
    if (pcpu_onboot() == FALSE)
  1034c6:	80 78 04 00          	cmpb   $0x0,0x4(%eax)
  1034ca:	75 3d                	jne    103509 <pcpu_boot_ap+0xb9>
}
  1034cc:	5b                   	pop    %ebx
        return 1;
  1034cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1034d2:	5e                   	pop    %esi
  1034d3:	5f                   	pop    %edi
  1034d4:	c3                   	ret    
  1034d5:	8d 76 00             	lea    0x0(%esi),%esi
    KERN_ASSERT(cpu_idx > 0 && cpu_idx < pcpu_ncpu());
  1034d8:	8d 83 b0 88 ff ff    	lea    -0x7750(%ebx),%eax
  1034de:	50                   	push   %eax
  1034df:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1034e5:	50                   	push   %eax
  1034e6:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  1034ec:	68 b7 01 00 00       	push   $0x1b7
  1034f1:	50                   	push   %eax
  1034f2:	e8 39 0b 00 00       	call   104030 <debug_panic>
  1034f7:	83 c4 10             	add    $0x10,%esp
  1034fa:	e9 73 ff ff ff       	jmp    103472 <pcpu_boot_ap+0x22>
  1034ff:	90                   	nop
    return (mp_inited == TRUE) ? arch_info->bsp : (get_pcpu_idx() == 0);
  103500:	e8 4b 29 00 00       	call   105e50 <get_pcpu_idx>
    if (pcpu_onboot() == FALSE)
  103505:	85 c0                	test   %eax,%eax
  103507:	75 c3                	jne    1034cc <pcpu_boot_ap+0x7c>
    if (get_pcpu_boot_info(cpu_idx) == TRUE)
  103509:	83 ec 0c             	sub    $0xc,%esp
  10350c:	56                   	push   %esi
  10350d:	e8 ee 29 00 00       	call   105f00 <get_pcpu_boot_info>
  103512:	83 c4 10             	add    $0x10,%esp
  103515:	3c 01                	cmp    $0x1,%al
  103517:	74 7c                	je     103595 <pcpu_boot_ap+0x145>
    *(uintptr_t *) (boot - 4) = stack_addr + PAGE_SIZE;
  103519:	8b 44 24 18          	mov    0x18(%esp),%eax
}

lapicid_t pcpu_cpu_lapicid(int cpu_idx)
{
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  10351d:	83 ec 0c             	sub    $0xc,%esp
    *(uintptr_t *) (boot - 8) = (uintptr_t) f;
  103520:	89 3d f8 7f 00 00    	mov    %edi,0x7ff8
    *(uintptr_t *) (boot - 4) = stack_addr + PAGE_SIZE;
  103526:	05 00 10 00 00       	add    $0x1000,%eax
  10352b:	a3 fc 7f 00 00       	mov    %eax,0x7ffc
    *(uintptr_t *) (boot - 12) = (uintptr_t) kern_init_ap;
  103530:	c7 c0 00 63 10 00    	mov    $0x106300,%eax
  103536:	a3 f4 7f 00 00       	mov    %eax,0x7ff4
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  10353b:	56                   	push   %esi
  10353c:	e8 4f 2a 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  103541:	83 c4 10             	add    $0x10,%esp
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103544:	89 c7                	mov    %eax,%edi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  103546:	85 f6                	test   %esi,%esi
  103548:	0f 88 82 00 00 00    	js     1035d0 <pcpu_boot_ap+0x180>
  10354e:	3b b3 64 89 02 00    	cmp    0x28964(%ebx),%esi
  103554:	73 7a                	jae    1035d0 <pcpu_boot_ap+0x180>
    lapic_startcpu(pcpu_cpu_lapicid(cpu_idx), (uintptr_t) boot);
  103556:	83 ec 08             	sub    $0x8,%esp
  103559:	68 00 80 00 00       	push   $0x8000
  10355e:	0f b6 07             	movzbl (%edi),%eax
  103561:	50                   	push   %eax
  103562:	e8 49 f3 ff ff       	call   1028b0 <lapic_startcpu>
    while (get_pcpu_boot_info(cpu_idx) == FALSE)
  103567:	83 c4 10             	add    $0x10,%esp
  10356a:	eb 09                	jmp    103575 <pcpu_boot_ap+0x125>
  10356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        pause();
  103570:	e8 3b 17 00 00       	call   104cb0 <pause>
    while (get_pcpu_boot_info(cpu_idx) == FALSE)
  103575:	83 ec 0c             	sub    $0xc,%esp
  103578:	56                   	push   %esi
  103579:	e8 82 29 00 00       	call   105f00 <get_pcpu_boot_info>
  10357e:	83 c4 10             	add    $0x10,%esp
  103581:	84 c0                	test   %al,%al
  103583:	74 eb                	je     103570 <pcpu_boot_ap+0x120>
    KERN_ASSERT(get_pcpu_boot_info(cpu_idx) == TRUE);
  103585:	83 ec 0c             	sub    $0xc,%esp
  103588:	56                   	push   %esi
  103589:	e8 72 29 00 00       	call   105f00 <get_pcpu_boot_info>
  10358e:	83 c4 10             	add    $0x10,%esp
  103591:	3c 01                	cmp    $0x1,%al
  103593:	75 0b                	jne    1035a0 <pcpu_boot_ap+0x150>
    return 0;
  103595:	31 c0                	xor    %eax,%eax
}
  103597:	5b                   	pop    %ebx
  103598:	5e                   	pop    %esi
  103599:	5f                   	pop    %edi
  10359a:	c3                   	ret    
  10359b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10359f:	90                   	nop
    KERN_ASSERT(get_pcpu_boot_info(cpu_idx) == TRUE);
  1035a0:	8d 83 20 89 ff ff    	lea    -0x76e0(%ebx),%eax
  1035a6:	50                   	push   %eax
  1035a7:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1035ad:	50                   	push   %eax
  1035ae:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  1035b4:	68 cd 01 00 00       	push   $0x1cd
  1035b9:	50                   	push   %eax
  1035ba:	e8 71 0a 00 00       	call   104030 <debug_panic>
  1035bf:	83 c4 10             	add    $0x10,%esp
    return 0;
  1035c2:	31 c0                	xor    %eax,%eax
  1035c4:	eb d1                	jmp    103597 <pcpu_boot_ap+0x147>
  1035c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1035cd:	8d 76 00             	lea    0x0(%esi),%esi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  1035d0:	8d 83 00 89 ff ff    	lea    -0x7700(%ebx),%eax
  1035d6:	50                   	push   %eax
  1035d7:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1035dd:	50                   	push   %eax
  1035de:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  1035e4:	68 ea 01 00 00       	push   $0x1ea
  1035e9:	50                   	push   %eax
  1035ea:	e8 41 0a 00 00       	call   104030 <debug_panic>
  1035ef:	83 c4 10             	add    $0x10,%esp
  1035f2:	e9 5f ff ff ff       	jmp    103556 <pcpu_boot_ap+0x106>
  1035f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1035fe:	66 90                	xchg   %ax,%ax
    KERN_ASSERT(f != NULL);
  103600:	8d 83 98 87 ff ff    	lea    -0x7868(%ebx),%eax
  103606:	50                   	push   %eax
  103607:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10360d:	50                   	push   %eax
  10360e:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  103614:	68 b9 01 00 00       	push   $0x1b9
  103619:	50                   	push   %eax
  10361a:	e8 11 0a 00 00       	call   104030 <debug_panic>
  10361f:	83 c4 10             	add    $0x10,%esp
  103622:	e9 85 fe ff ff       	jmp    1034ac <pcpu_boot_ap+0x5c>
  103627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10362e:	66 90                	xchg   %ax,%ax

00103630 <pcpu_init_cpu>:
{
  103630:	55                   	push   %ebp
  103631:	57                   	push   %edi
  103632:	56                   	push   %esi
  103633:	53                   	push   %ebx
  103634:	e8 50 cd ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103639:	81 c3 c7 d9 00 00    	add    $0xd9c7,%ebx
  10363f:	83 ec 4c             	sub    $0x4c,%esp
    int cpu_idx = get_pcpu_idx();
  103642:	e8 09 28 00 00       	call   105e50 <get_pcpu_idx>
    struct pcpuinfo *cpuinfo = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103647:	83 ec 0c             	sub    $0xc,%esp
  10364a:	50                   	push   %eax
  10364b:	e8 40 29 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    uint32_t *regs[4] = { &eax, &ebx, &ecx, &edx };
  103650:	8d 6c 24 34          	lea    0x34(%esp),%ebp
  103654:	8d 4c 24 3c          	lea    0x3c(%esp),%ecx
    struct pcpuinfo *cpuinfo = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103658:	89 c6                	mov    %eax,%esi
    uint32_t *regs[4] = { &eax, &ebx, &ecx, &edx };
  10365a:	8d 44 24 38          	lea    0x38(%esp),%eax
  10365e:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  103662:	89 44 24 14          	mov    %eax,0x14(%esp)
  103666:	89 44 24 48          	mov    %eax,0x48(%esp)
  10366a:	89 4c 24 4c          	mov    %ecx,0x4c(%esp)
    cpuid(0x0, &eax, &ebx, &ecx, &edx);
  10366e:	89 0c 24             	mov    %ecx,(%esp)
    uint32_t *regs[4] = { &eax, &ebx, &ecx, &edx };
  103671:	89 6c 24 44          	mov    %ebp,0x44(%esp)
    cpuid(0x0, &eax, &ebx, &ecx, &edx);
  103675:	50                   	push   %eax
  103676:	55                   	push   %ebp
  103677:	8d 44 24 38          	lea    0x38(%esp),%eax
  10367b:	89 44 24 18          	mov    %eax,0x18(%esp)
  10367f:	50                   	push   %eax
  103680:	6a 00                	push   $0x0
  103682:	e8 99 16 00 00       	call   104d20 <cpuid>
    cpuinfo->cpuid_high = eax;
  103687:	8b 44 24 40          	mov    0x40(%esp),%eax
    cpuinfo->vendor[12] = '\0';
  10368b:	c6 46 18 00          	movb   $0x0,0x18(%esi)
    cpuinfo->cpuid_high = eax;
  10368f:	89 46 08             	mov    %eax,0x8(%esi)
    ((uint32_t *) cpuinfo->vendor)[0] = ebx;
  103692:	8b 44 24 44          	mov    0x44(%esp),%eax
  103696:	89 46 0c             	mov    %eax,0xc(%esi)
    ((uint32_t *) cpuinfo->vendor)[1] = edx;
  103699:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  10369d:	89 46 10             	mov    %eax,0x10(%esi)
    ((uint32_t *) cpuinfo->vendor)[2] = ecx;
  1036a0:	8b 44 24 48          	mov    0x48(%esp),%eax
  1036a4:	89 46 14             	mov    %eax,0x14(%esi)
    if (strncmp(cpuinfo->vendor, "GenuineIntel", 20) == 0)
  1036a7:	8d 46 0c             	lea    0xc(%esi),%eax
  1036aa:	89 44 24 30          	mov    %eax,0x30(%esp)
  1036ae:	89 c7                	mov    %eax,%edi
  1036b0:	83 c4 1c             	add    $0x1c,%esp
  1036b3:	8d 83 d7 87 ff ff    	lea    -0x7829(%ebx),%eax
  1036b9:	6a 14                	push   $0x14
  1036bb:	50                   	push   %eax
  1036bc:	57                   	push   %edi
  1036bd:	e8 5e 07 00 00       	call   103e20 <strncmp>
  1036c2:	83 c4 10             	add    $0x10,%esp
  1036c5:	89 c2                	mov    %eax,%edx
  1036c7:	b8 01 00 00 00       	mov    $0x1,%eax
  1036cc:	85 d2                	test   %edx,%edx
  1036ce:	0f 85 dc 02 00 00    	jne    1039b0 <pcpu_init_cpu+0x380>
    cpuid(0x1, &eax, &ebx, &ecx, &edx);
  1036d4:	83 ec 0c             	sub    $0xc,%esp
        cpuinfo->cpu_vendor = INTEL;
  1036d7:	89 46 20             	mov    %eax,0x20(%esi)
    cpuid(0x1, &eax, &ebx, &ecx, &edx);
  1036da:	ff 74 24 14          	push   0x14(%esp)
  1036de:	ff 74 24 14          	push   0x14(%esp)
  1036e2:	55                   	push   %ebp
  1036e3:	ff 74 24 18          	push   0x18(%esp)
  1036e7:	6a 01                	push   $0x1
  1036e9:	e8 32 16 00 00       	call   104d20 <cpuid>
    cpuinfo->family = (eax >> 8) & 0xf;
  1036ee:	8b 44 24 40          	mov    0x40(%esp),%eax
  1036f2:	89 c2                	mov    %eax,%edx
  1036f4:	c1 ea 08             	shr    $0x8,%edx
  1036f7:	83 e2 0f             	and    $0xf,%edx
  1036fa:	88 56 24             	mov    %dl,0x24(%esi)
    cpuinfo->model = (eax >> 4) & 0xf;
  1036fd:	89 c2                	mov    %eax,%edx
  1036ff:	c0 ea 04             	shr    $0x4,%dl
  103702:	88 56 25             	mov    %dl,0x25(%esi)
    cpuinfo->step = eax & 0xf;
  103705:	89 c2                	mov    %eax,%edx
  103707:	83 e2 0f             	and    $0xf,%edx
  10370a:	88 56 26             	mov    %dl,0x26(%esi)
    cpuinfo->ext_family = (eax >> 20) & 0xff;
  10370d:	89 c2                	mov    %eax,%edx
    cpuinfo->ext_model = (eax >> 16) & 0xff;
  10370f:	c1 e8 10             	shr    $0x10,%eax
  103712:	88 46 28             	mov    %al,0x28(%esi)
    cpuinfo->brand_idx = ebx & 0xff;
  103715:	8b 44 24 44          	mov    0x44(%esp),%eax
    cpuinfo->ext_family = (eax >> 20) & 0xff;
  103719:	c1 ea 14             	shr    $0x14,%edx
  10371c:	88 56 27             	mov    %dl,0x27(%esi)
    cpuinfo->brand_idx = ebx & 0xff;
  10371f:	89 46 29             	mov    %eax,0x29(%esi)
    cpuinfo->feature1 = ecx;
  103722:	8b 44 24 48          	mov    0x48(%esp),%eax
  103726:	89 46 30             	mov    %eax,0x30(%esi)
    cpuinfo->feature2 = edx;
  103729:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    switch (cpuinfo->cpu_vendor) {
  10372d:	83 c4 20             	add    $0x20,%esp
    cpuinfo->feature2 = edx;
  103730:	89 46 34             	mov    %eax,0x34(%esi)
    switch (cpuinfo->cpu_vendor) {
  103733:	8b 46 20             	mov    0x20(%esi),%eax
  103736:	83 f8 01             	cmp    $0x1,%eax
  103739:	0f 84 31 01 00 00    	je     103870 <pcpu_init_cpu+0x240>
  10373f:	83 f8 02             	cmp    $0x2,%eax
  103742:	0f 84 d0 01 00 00    	je     103918 <pcpu_init_cpu+0x2e8>
        cpuinfo->l1_cache_size = 0;
  103748:	c7 46 38 00 00 00 00 	movl   $0x0,0x38(%esi)
        cpuinfo->l1_cache_line_size = 0;
  10374f:	c7 46 3c 00 00 00 00 	movl   $0x0,0x3c(%esi)
    cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
  103756:	83 ec 0c             	sub    $0xc,%esp
  103759:	ff 74 24 14          	push   0x14(%esp)
  10375d:	ff 74 24 14          	push   0x14(%esp)
  103761:	55                   	push   %ebp
  103762:	ff 74 24 18          	push   0x18(%esp)
  103766:	68 00 00 00 80       	push   $0x80000000
  10376b:	e8 b0 15 00 00       	call   104d20 <cpuid>
    cpuinfo->cpuid_exthigh = eax;
  103770:	8b 44 24 40          	mov    0x40(%esp),%eax
    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
  103774:	83 c4 20             	add    $0x20,%esp
    cpuinfo->cpuid_exthigh = eax;
  103777:	89 46 40             	mov    %eax,0x40(%esi)
    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
  10377a:	e8 d1 26 00 00       	call   105e50 <get_pcpu_idx>
    KERN_INFO("CPU%d: %s, FAMILY %d(%d), MODEL %d(%d), STEP %d, "
  10377f:	8b 56 30             	mov    0x30(%esi),%edx
  103782:	8d 8b a2 87 ff ff    	lea    -0x785e(%ebx),%ecx
  103788:	8b 7e 38             	mov    0x38(%esi),%edi
    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
  10378b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    KERN_INFO("CPU%d: %s, FAMILY %d(%d), MODEL %d(%d), STEP %d, "
  10378f:	8d 83 ce 96 ff ff    	lea    -0x6932(%ebx),%eax
  103795:	f7 c2 00 00 80 00    	test   $0x800000,%edx
  10379b:	89 3c 24             	mov    %edi,(%esp)
  10379e:	0f 44 c8             	cmove  %eax,%ecx
  1037a1:	f7 c2 00 00 10 00    	test   $0x100000,%edx
  1037a7:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  1037ab:	8d 8b ab 87 ff ff    	lea    -0x7855(%ebx),%ecx
  1037b1:	89 cf                	mov    %ecx,%edi
  1037b3:	8d 8b b3 87 ff ff    	lea    -0x784d(%ebx),%ecx
  1037b9:	0f 44 f8             	cmove  %eax,%edi
  1037bc:	f7 c2 00 00 08 00    	test   $0x80000,%edx
  1037c2:	0f 44 c8             	cmove  %eax,%ecx
  1037c5:	f6 c6 02             	test   $0x2,%dh
  1037c8:	89 7c 24 14          	mov    %edi,0x14(%esp)
  1037cc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1037d0:	8d 8b bb 87 ff ff    	lea    -0x7845(%ebx),%ecx
  1037d6:	89 cd                	mov    %ecx,%ebp
  1037d8:	8d 8b c3 87 ff ff    	lea    -0x783d(%ebx),%ecx
  1037de:	0f 44 e8             	cmove  %eax,%ebp
  1037e1:	89 cf                	mov    %ecx,%edi
  1037e3:	f6 c2 01             	test   $0x1,%dl
  1037e6:	8b 4e 34             	mov    0x34(%esi),%ecx
  1037e9:	0f 44 f8             	cmove  %eax,%edi
  1037ec:	89 6c 24 08          	mov    %ebp,0x8(%esp)
  1037f0:	f7 c1 00 00 00 04    	test   $0x4000000,%ecx
  1037f6:	8d ab ca 87 ff ff    	lea    -0x7836(%ebx),%ebp
  1037fc:	0f 44 e8             	cmove  %eax,%ebp
  1037ff:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103803:	f7 c1 00 00 00 02    	test   $0x2000000,%ecx
  103809:	8d bb d1 87 ff ff    	lea    -0x782f(%ebx),%edi
  10380f:	0f 44 f8             	cmove  %eax,%edi
  103812:	83 ec 04             	sub    $0x4,%esp
  103815:	ff 76 3c             	push   0x3c(%esi)
  103818:	ff 74 24 08          	push   0x8(%esp)
  10381c:	ff 74 24 24          	push   0x24(%esp)
  103820:	ff 74 24 24          	push   0x24(%esp)
  103824:	ff 74 24 20          	push   0x20(%esp)
  103828:	ff 74 24 20          	push   0x20(%esp)
  10382c:	ff 74 24 20          	push   0x20(%esp)
  103830:	55                   	push   %ebp
  103831:	57                   	push   %edi
  103832:	51                   	push   %ecx
  103833:	52                   	push   %edx
  103834:	0f b6 46 26          	movzbl 0x26(%esi),%eax
  103838:	50                   	push   %eax
  103839:	0f b6 46 28          	movzbl 0x28(%esi),%eax
  10383d:	50                   	push   %eax
  10383e:	0f b6 46 25          	movzbl 0x25(%esi),%eax
  103842:	50                   	push   %eax
  103843:	0f b6 46 27          	movzbl 0x27(%esi),%eax
  103847:	50                   	push   %eax
  103848:	0f b6 46 24          	movzbl 0x24(%esi),%eax
  10384c:	50                   	push   %eax
  10384d:	8d 83 44 89 ff ff    	lea    -0x76bc(%ebx),%eax
  103853:	ff 74 24 54          	push   0x54(%esp)
  103857:	ff 74 24 64          	push   0x64(%esp)
  10385b:	50                   	push   %eax
  10385c:	e8 5f 07 00 00       	call   103fc0 <debug_info>
}
  103861:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103867:	5b                   	pop    %ebx
  103868:	5e                   	pop    %esi
  103869:	5f                   	pop    %edi
  10386a:	5d                   	pop    %ebp
  10386b:	c3                   	ret    
  10386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cpuid(0x00000002, &eax, &ebx, &ecx, &edx);
  103870:	83 ec 0c             	sub    $0xc,%esp
  103873:	ff 74 24 14          	push   0x14(%esp)
  103877:	ff 74 24 14          	push   0x14(%esp)
  10387b:	55                   	push   %ebp
  10387c:	ff 74 24 18          	push   0x18(%esp)
  103880:	6a 02                	push   $0x2
  103882:	e8 99 14 00 00       	call   104d20 <cpuid>
        i = eax & 0x000000ff;
  103887:	0f b6 44 24 40       	movzbl 0x40(%esp),%eax
        while (i--)
  10388c:	83 c4 20             	add    $0x20,%esp
  10388f:	8d 78 ff             	lea    -0x1(%eax),%edi
  103892:	85 c0                	test   %eax,%eax
  103894:	74 2d                	je     1038c3 <pcpu_init_cpu+0x293>
  103896:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10389a:	89 fe                	mov    %edi,%esi
  10389c:	8b 7c 24 08          	mov    0x8(%esp),%edi
            cpuid(0x00000002, &eax, &ebx, &ecx, &edx);
  1038a0:	83 ec 0c             	sub    $0xc,%esp
        while (i--)
  1038a3:	83 ee 01             	sub    $0x1,%esi
            cpuid(0x00000002, &eax, &ebx, &ecx, &edx);
  1038a6:	57                   	push   %edi
  1038a7:	ff 74 24 14          	push   0x14(%esp)
  1038ab:	55                   	push   %ebp
  1038ac:	ff 74 24 18          	push   0x18(%esp)
  1038b0:	6a 02                	push   $0x2
  1038b2:	e8 69 14 00 00       	call   104d20 <cpuid>
        while (i--)
  1038b7:	83 c4 20             	add    $0x20,%esp
  1038ba:	83 fe ff             	cmp    $0xffffffff,%esi
  1038bd:	75 e1                	jne    1038a0 <pcpu_init_cpu+0x270>
  1038bf:	8b 74 24 0c          	mov    0xc(%esp),%esi
  1038c3:	8d 44 24 30          	lea    0x30(%esp),%eax
  1038c7:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  1038cb:	8d 8b e0 89 ff ff    	lea    -0x7620(%ebx),%ecx
  1038d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038d5:	8d 44 24 40          	lea    0x40(%esp),%eax
  1038d9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1038dd:	8d 44 24 20          	lea    0x20(%esp),%eax
            for (j = 0; j < 4; j++) {
  1038e1:	8d 68 04             	lea    0x4(%eax),%ebp
                cpuinfo->l1_cache_size = intel_cache_info[desc[j]][0];
  1038e4:	0f b6 10             	movzbl (%eax),%edx
            for (j = 0; j < 4; j++) {
  1038e7:	83 c0 01             	add    $0x1,%eax
                cpuinfo->l1_cache_size = intel_cache_info[desc[j]][0];
  1038ea:	8b 14 d1             	mov    (%ecx,%edx,8),%edx
  1038ed:	89 56 38             	mov    %edx,0x38(%esi)
                cpuinfo->l1_cache_line_size = intel_cache_info[desc[j]][1];
  1038f0:	0f b6 78 ff          	movzbl -0x1(%eax),%edi
  1038f4:	8b 7c f9 04          	mov    0x4(%ecx,%edi,8),%edi
  1038f8:	89 7e 3c             	mov    %edi,0x3c(%esi)
            for (j = 0; j < 4; j++) {
  1038fb:	39 c5                	cmp    %eax,%ebp
  1038fd:	75 e5                	jne    1038e4 <pcpu_init_cpu+0x2b4>
        for (i = 0; i < 4; i++) {
  1038ff:	83 44 24 0c 04       	addl   $0x4,0xc(%esp)
  103904:	8b 44 24 0c          	mov    0xc(%esp),%eax
  103908:	39 44 24 14          	cmp    %eax,0x14(%esp)
  10390c:	74 42                	je     103950 <pcpu_init_cpu+0x320>
            desc = (uint8_t *) regs[i];
  10390e:	8b 00                	mov    (%eax),%eax
  103910:	eb cf                	jmp    1038e1 <pcpu_init_cpu+0x2b1>
  103912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cpuid(0x80000005, &eax, &ebx, &ecx, &edx);
  103918:	83 ec 0c             	sub    $0xc,%esp
  10391b:	ff 74 24 14          	push   0x14(%esp)
  10391f:	ff 74 24 14          	push   0x14(%esp)
  103923:	55                   	push   %ebp
  103924:	ff 74 24 18          	push   0x18(%esp)
  103928:	68 05 00 00 80       	push   $0x80000005
  10392d:	e8 ee 13 00 00       	call   104d20 <cpuid>
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103932:	8b 44 24 48          	mov    0x48(%esp),%eax
        break;
  103936:	83 c4 20             	add    $0x20,%esp
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103939:	89 c2                	mov    %eax,%edx
        cpuinfo->l1_cache_line_size = (ecx & 0x000000ff);
  10393b:	25 ff 00 00 00       	and    $0xff,%eax
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103940:	c1 ea 18             	shr    $0x18,%edx
        cpuinfo->l1_cache_line_size = (ecx & 0x000000ff);
  103943:	89 46 3c             	mov    %eax,0x3c(%esi)
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103946:	89 56 38             	mov    %edx,0x38(%esi)
        break;
  103949:	e9 08 fe ff ff       	jmp    103756 <pcpu_init_cpu+0x126>
  10394e:	66 90                	xchg   %ax,%ax
        if (cpuinfo->l1_cache_size && cpuinfo->l1_cache_line_size)
  103950:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  103954:	85 d2                	test   %edx,%edx
  103956:	0f 85 84 00 00 00    	jne    1039e0 <pcpu_init_cpu+0x3b0>
  10395c:	31 ff                	xor    %edi,%edi
            cpuid_subleaf(0x00000004, i, &eax, &ebx, &ecx, &edx);
  10395e:	83 ec 08             	sub    $0x8,%esp
  103961:	ff 74 24 10          	push   0x10(%esp)
  103965:	ff 74 24 10          	push   0x10(%esp)
  103969:	55                   	push   %ebp
  10396a:	ff 74 24 14          	push   0x14(%esp)
  10396e:	57                   	push   %edi
  10396f:	6a 04                	push   $0x4
  103971:	e8 ea 13 00 00       	call   104d60 <cpuid_subleaf>
            if ((eax & 0xf) == 1 && ((eax & 0xe0) >> 5) == 1)
  103976:	8b 54 24 40          	mov    0x40(%esp),%edx
  10397a:	83 c4 20             	add    $0x20,%esp
  10397d:	89 d1                	mov    %edx,%ecx
  10397f:	83 e1 0f             	and    $0xf,%ecx
  103982:	83 f9 01             	cmp    $0x1,%ecx
  103985:	74 69                	je     1039f0 <pcpu_init_cpu+0x3c0>
        for (i = 0; i < 3; i++) {
  103987:	83 c7 01             	add    $0x1,%edi
  10398a:	83 ff 03             	cmp    $0x3,%edi
  10398d:	75 cf                	jne    10395e <pcpu_init_cpu+0x32e>
            KERN_WARN("Cannot determine L1 cache size.\n");
  10398f:	83 ec 04             	sub    $0x4,%esp
  103992:	8d 83 b4 89 ff ff    	lea    -0x764c(%ebx),%eax
  103998:	50                   	push   %eax
  103999:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  10399f:	6a 7c                	push   $0x7c
  1039a1:	50                   	push   %eax
  1039a2:	e8 59 07 00 00       	call   104100 <debug_warn>
            break;
  1039a7:	83 c4 10             	add    $0x10,%esp
  1039aa:	e9 a7 fd ff ff       	jmp    103756 <pcpu_init_cpu+0x126>
  1039af:	90                   	nop
    else if (strncmp(cpuinfo->vendor, "AuthenticAMD", 20) == 0)
  1039b0:	83 ec 04             	sub    $0x4,%esp
  1039b3:	8d 83 e4 87 ff ff    	lea    -0x781c(%ebx),%eax
  1039b9:	6a 14                	push   $0x14
  1039bb:	50                   	push   %eax
  1039bc:	ff 74 24 1c          	push   0x1c(%esp)
  1039c0:	e8 5b 04 00 00       	call   103e20 <strncmp>
  1039c5:	83 c4 10             	add    $0x10,%esp
  1039c8:	85 c0                	test   %eax,%eax
  1039ca:	0f 94 c0             	sete   %al
  1039cd:	0f b6 c0             	movzbl %al,%eax
  1039d0:	01 c0                	add    %eax,%eax
  1039d2:	e9 fd fc ff ff       	jmp    1036d4 <pcpu_init_cpu+0xa4>
  1039d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1039de:	66 90                	xchg   %ax,%ax
        if (cpuinfo->l1_cache_size && cpuinfo->l1_cache_line_size)
  1039e0:	85 ff                	test   %edi,%edi
  1039e2:	0f 85 6e fd ff ff    	jne    103756 <pcpu_init_cpu+0x126>
  1039e8:	e9 71 ff ff ff       	jmp    10395e <pcpu_init_cpu+0x32e>
  1039ed:	8d 76 00             	lea    0x0(%esi),%esi
            if ((eax & 0xf) == 1 && ((eax & 0xe0) >> 5) == 1)
  1039f0:	c1 ea 05             	shr    $0x5,%edx
  1039f3:	83 e2 07             	and    $0x7,%edx
  1039f6:	83 fa 01             	cmp    $0x1,%edx
  1039f9:	75 8c                	jne    103987 <pcpu_init_cpu+0x357>
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  1039fb:	8b 7c 24 24          	mov    0x24(%esp),%edi
            (ecx + 1) /                         /* sets */
  1039ff:	8b 54 24 28          	mov    0x28(%esp),%edx
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103a03:	89 f8                	mov    %edi,%eax
            (ecx + 1) /                         /* sets */
  103a05:	83 c2 01             	add    $0x1,%edx
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103a08:	25 ff 0f 00 00       	and    $0xfff,%eax
  103a0d:	8d 48 01             	lea    0x1(%eax),%ecx
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  103a10:	89 f8                	mov    %edi,%eax
            (((ebx & 0x003ff000) >> 12) + 1) *  /* partitions */
  103a12:	c1 ef 0c             	shr    $0xc,%edi
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  103a15:	c1 e8 16             	shr    $0x16,%eax
        cpuinfo->l1_cache_line_size = ((ebx & 0x00000fff)) + 1;
  103a18:	89 4e 3c             	mov    %ecx,0x3c(%esi)
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  103a1b:	83 c0 01             	add    $0x1,%eax
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103a1e:	0f af c1             	imul   %ecx,%eax
  103a21:	0f af c2             	imul   %edx,%eax
            (((ebx & 0x003ff000) >> 12) + 1) *  /* partitions */
  103a24:	89 fa                	mov    %edi,%edx
  103a26:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  103a2c:	83 c2 01             	add    $0x1,%edx
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103a2f:	0f af c2             	imul   %edx,%eax
            (ecx + 1) /                         /* sets */
  103a32:	c1 e8 0a             	shr    $0xa,%eax
  103a35:	89 46 38             	mov    %eax,0x38(%esi)
        break;
  103a38:	e9 19 fd ff ff       	jmp    103756 <pcpu_init_cpu+0x126>
  103a3d:	8d 76 00             	lea    0x0(%esi),%esi

00103a40 <pcpu_ncpu>:
    return ncpu;
  103a40:	e8 3c c9 ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  103a45:	05 bb d5 00 00       	add    $0xd5bb,%eax
  103a4a:	8b 80 64 89 02 00    	mov    0x28964(%eax),%eax
}
  103a50:	c3                   	ret    
  103a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103a5f:	90                   	nop

00103a60 <pcpu_is_smp>:
    return ismp;
  103a60:	e8 1c c9 ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  103a65:	05 9b d5 00 00       	add    $0xd59b,%eax
  103a6a:	0f b6 80 60 89 02 00 	movzbl 0x28960(%eax),%eax
}
  103a71:	c3                   	ret    
  103a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103a80 <pcpu_onboot>:
{
  103a80:	53                   	push   %ebx
  103a81:	e8 03 c9 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103a86:	81 c3 7a d5 00 00    	add    $0xd57a,%ebx
  103a8c:	83 ec 08             	sub    $0x8,%esp
    int cpu_idx = get_pcpu_idx();
  103a8f:	e8 bc 23 00 00       	call   105e50 <get_pcpu_idx>
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103a94:	83 ec 0c             	sub    $0xc,%esp
  103a97:	50                   	push   %eax
  103a98:	e8 f3 24 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    return (mp_inited == TRUE) ? arch_info->bsp : (get_pcpu_idx() == 0);
  103a9d:	83 c4 10             	add    $0x10,%esp
  103aa0:	80 bb 61 89 02 00 01 	cmpb   $0x1,0x28961(%ebx)
  103aa7:	75 0f                	jne    103ab8 <pcpu_onboot+0x38>
  103aa9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
}
  103aad:	83 c4 08             	add    $0x8,%esp
  103ab0:	5b                   	pop    %ebx
  103ab1:	c3                   	ret    
  103ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return (mp_inited == TRUE) ? arch_info->bsp : (get_pcpu_idx() == 0);
  103ab8:	e8 93 23 00 00       	call   105e50 <get_pcpu_idx>
  103abd:	85 c0                	test   %eax,%eax
  103abf:	0f 94 c0             	sete   %al
}
  103ac2:	83 c4 08             	add    $0x8,%esp
  103ac5:	5b                   	pop    %ebx
  103ac6:	c3                   	ret    
  103ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103ace:	66 90                	xchg   %ax,%ax

00103ad0 <pcpu_cpu_lapicid>:
{
  103ad0:	57                   	push   %edi
  103ad1:	56                   	push   %esi
  103ad2:	53                   	push   %ebx
  103ad3:	8b 7c 24 10          	mov    0x10(%esp),%edi
  103ad7:	e8 ad c8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103adc:	81 c3 24 d5 00 00    	add    $0xd524,%ebx
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103ae2:	83 ec 0c             	sub    $0xc,%esp
  103ae5:	57                   	push   %edi
  103ae6:	e8 a5 24 00 00       	call   105f90 <get_pcpu_arch_info_pointer>
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  103aeb:	83 c4 10             	add    $0x10,%esp
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103aee:	89 c6                	mov    %eax,%esi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  103af0:	85 ff                	test   %edi,%edi
  103af2:	78 08                	js     103afc <pcpu_cpu_lapicid+0x2c>
  103af4:	3b bb 64 89 02 00    	cmp    0x28964(%ebx),%edi
  103afa:	72 22                	jb     103b1e <pcpu_cpu_lapicid+0x4e>
  103afc:	8d 83 00 89 ff ff    	lea    -0x7700(%ebx),%eax
  103b02:	50                   	push   %eax
  103b03:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  103b09:	50                   	push   %eax
  103b0a:	8d 83 44 87 ff ff    	lea    -0x78bc(%ebx),%eax
  103b10:	68 ea 01 00 00       	push   $0x1ea
  103b15:	50                   	push   %eax
  103b16:	e8 15 05 00 00       	call   104030 <debug_panic>
  103b1b:	83 c4 10             	add    $0x10,%esp
    return arch_info->lapicid;
  103b1e:	0f b6 06             	movzbl (%esi),%eax
}
  103b21:	5b                   	pop    %ebx
  103b22:	5e                   	pop    %esi
  103b23:	5f                   	pop    %edi
  103b24:	c3                   	ret    
  103b25:	66 90                	xchg   %ax,%ax
  103b27:	66 90                	xchg   %ax,%ax
  103b29:	66 90                	xchg   %ax,%ax
  103b2b:	66 90                	xchg   %ax,%ax
  103b2d:	66 90                	xchg   %ax,%ax
  103b2f:	90                   	nop

00103b30 <detect_kvm>:
}

#define CPUID_FEATURE_HYPERVISOR	(1<<31) /* Running on a hypervisor */

int detect_kvm(void)
{
  103b30:	55                   	push   %ebp
	__asm __volatile("cpuid"
  103b31:	b8 01 00 00 00       	mov    $0x1,%eax
{
  103b36:	57                   	push   %edi
  103b37:	e8 08 02 00 00       	call   103d44 <__x86.get_pc_thunk.di>
  103b3c:	81 c7 c4 d4 00 00    	add    $0xd4c4,%edi
  103b42:	56                   	push   %esi
	__asm __volatile("cpuid"
  103b43:	31 f6                	xor    %esi,%esi
{
  103b45:	53                   	push   %ebx
	__asm __volatile("cpuid"
  103b46:	89 f1                	mov    %esi,%ecx
{
  103b48:	83 ec 2c             	sub    $0x2c,%esp
	__asm __volatile("cpuid"
  103b4b:	0f a2                	cpuid  
	uint32_t eax;

	if (cpu_has (CPUID_FEATURE_HYPERVISOR))
  103b4d:	83 e2 01             	and    $0x1,%edx
  103b50:	89 d5                	mov    %edx,%ebp
  103b52:	75 0c                	jne    103b60 <detect_kvm+0x30>
		{
			return 1;
		}
	}
	return 0;
}
  103b54:	83 c4 2c             	add    $0x2c,%esp
  103b57:	89 e8                	mov    %ebp,%eax
  103b59:	5b                   	pop    %ebx
  103b5a:	5e                   	pop    %esi
  103b5b:	5f                   	pop    %edi
  103b5c:	5d                   	pop    %ebp
  103b5d:	c3                   	ret    
  103b5e:	66 90                	xchg   %ax,%ax
		cpuid (CPUID_KVM_SIGNATURE, &eax, &hyper_vendor_id[0],
  103b60:	83 ec 0c             	sub    $0xc,%esp
  103b63:	89 fb                	mov    %edi,%ebx
  103b65:	8d 54 24 28          	lea    0x28(%esp),%edx
  103b69:	8d 44 24 20          	lea    0x20(%esp),%eax
  103b6d:	52                   	push   %edx
  103b6e:	8d 54 24 28          	lea    0x28(%esp),%edx
  103b72:	52                   	push   %edx
  103b73:	50                   	push   %eax
  103b74:	8d 54 24 28          	lea    0x28(%esp),%edx
  103b78:	89 44 24 24          	mov    %eax,0x24(%esp)
  103b7c:	52                   	push   %edx
  103b7d:	68 00 00 00 40       	push   $0x40000000
  103b82:	e8 99 11 00 00       	call   104d20 <cpuid>
		if (!strncmp ("KVMKVMKVM", (const char *) hyper_vendor_id, 9))
  103b87:	83 c4 1c             	add    $0x1c,%esp
  103b8a:	6a 09                	push   $0x9
  103b8c:	8b 44 24 14          	mov    0x14(%esp),%eax
  103b90:	50                   	push   %eax
  103b91:	8d 87 d8 91 ff ff    	lea    -0x6e28(%edi),%eax
  103b97:	50                   	push   %eax
  103b98:	e8 83 02 00 00       	call   103e20 <strncmp>
  103b9d:	83 c4 10             	add    $0x10,%esp
	return 0;
  103ba0:	85 c0                	test   %eax,%eax
  103ba2:	0f 45 ee             	cmovne %esi,%ebp
}
  103ba5:	83 c4 2c             	add    $0x2c,%esp
  103ba8:	5b                   	pop    %ebx
  103ba9:	5e                   	pop    %esi
  103baa:	89 e8                	mov    %ebp,%eax
  103bac:	5f                   	pop    %edi
  103bad:	5d                   	pop    %ebp
  103bae:	c3                   	ret    
  103baf:	90                   	nop

00103bb0 <kvm_has_feature>:

int
kvm_has_feature(uint32_t feature)
{
  103bb0:	53                   	push   %ebx
  103bb1:	e8 d3 c7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103bb6:	81 c3 4a d4 00 00    	add    $0xd44a,%ebx
  103bbc:	83 ec 24             	sub    $0x24,%esp
	uint32_t eax, ebx, ecx, edx;
	eax = 0; edx = 0;
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103bbf:	8d 44 24 18          	lea    0x18(%esp),%eax
	eax = 0; edx = 0;
  103bc3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103bca:	00 
  103bcb:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  103bd2:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103bd3:	50                   	push   %eax
  103bd4:	8d 44 24 18          	lea    0x18(%esp),%eax
  103bd8:	50                   	push   %eax
  103bd9:	8d 44 24 18          	lea    0x18(%esp),%eax
  103bdd:	50                   	push   %eax
  103bde:	8d 44 24 18          	lea    0x18(%esp),%eax
  103be2:	50                   	push   %eax
  103be3:	68 01 00 00 40       	push   $0x40000001
  103be8:	e8 33 11 00 00       	call   104d20 <cpuid>

	return ((eax & feature) != 0 ? 1 : 0);
  103bed:	8b 44 24 40          	mov    0x40(%esp),%eax
  103bf1:	23 44 24 20          	and    0x20(%esp),%eax
  103bf5:	85 c0                	test   %eax,%eax
  103bf7:	0f 95 c0             	setne  %al
}
  103bfa:	83 c4 38             	add    $0x38,%esp
	return ((eax & feature) != 0 ? 1 : 0);
  103bfd:	0f b6 c0             	movzbl %al,%eax
}
  103c00:	5b                   	pop    %ebx
  103c01:	c3                   	ret    
  103c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103c10 <kvm_enable_feature>:

int
kvm_enable_feature(uint32_t feature)
{
  103c10:	53                   	push   %ebx
	uint32_t eax, ebx, ecx, edx;
	eax = 1 << feature; edx = 0;
  103c11:	b8 01 00 00 00       	mov    $0x1,%eax
  103c16:	e8 6e c7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103c1b:	81 c3 e5 d3 00 00    	add    $0xd3e5,%ebx
{
  103c21:	83 ec 24             	sub    $0x24,%esp
	eax = 1 << feature; edx = 0;
  103c24:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  103c28:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  103c2f:	00 
  103c30:	d3 e0                	shl    %cl,%eax
  103c32:	89 44 24 0c          	mov    %eax,0xc(%esp)
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103c36:	8d 44 24 18          	lea    0x18(%esp),%eax
  103c3a:	50                   	push   %eax
  103c3b:	8d 44 24 18          	lea    0x18(%esp),%eax
  103c3f:	50                   	push   %eax
  103c40:	8d 44 24 18          	lea    0x18(%esp),%eax
  103c44:	50                   	push   %eax
  103c45:	8d 44 24 18          	lea    0x18(%esp),%eax
  103c49:	50                   	push   %eax
  103c4a:	68 01 00 00 40       	push   $0x40000001
  103c4f:	e8 cc 10 00 00       	call   104d20 <cpuid>

	return (ebx == 0 ? 1 : 0);
  103c54:	8b 54 24 24          	mov    0x24(%esp),%edx
  103c58:	31 c0                	xor    %eax,%eax
  103c5a:	85 d2                	test   %edx,%edx
  103c5c:	0f 94 c0             	sete   %al
}
  103c5f:	83 c4 38             	add    $0x38,%esp
  103c62:	5b                   	pop    %ebx
  103c63:	c3                   	ret    
  103c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103c6f:	90                   	nop

00103c70 <kvm_get_tsc_hz>:

uint64_t
kvm_get_tsc_hz(void)
{
  103c70:	55                   	push   %ebp
  103c71:	57                   	push   %edi
  103c72:	56                   	push   %esi
  103c73:	53                   	push   %ebx
  103c74:	e8 10 c7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103c79:	81 c3 87 d3 00 00    	add    $0xd387,%ebx
  103c7f:	83 ec 38             	sub    $0x38,%esp
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103c82:	8d 44 24 28          	lea    0x28(%esp),%eax
	eax = 0; edx = 0;
  103c86:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  103c8d:	00 
  103c8e:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  103c95:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103c96:	50                   	push   %eax
  103c97:	8d 6c 24 28          	lea    0x28(%esp),%ebp
  103c9b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103c9f:	55                   	push   %ebp
  103ca0:	8d 7c 24 28          	lea    0x28(%esp),%edi
  103ca4:	57                   	push   %edi
  103ca5:	8d 74 24 28          	lea    0x28(%esp),%esi
  103ca9:	56                   	push   %esi
  103caa:	68 01 00 00 40       	push   $0x40000001
  103caf:	e8 6c 10 00 00       	call   104d20 <cpuid>
	uint64_t tsc_hz = 0llu;
	uint32_t msr_sys_time;

	if (kvm_has_feature(KVM_FEATURE_CLOCKSOURCE2))
  103cb4:	83 c4 20             	add    $0x20,%esp
  103cb7:	f6 44 24 10 03       	testb  $0x3,0x10(%esp)
  103cbc:	75 42                	jne    103d00 <kvm_get_tsc_hz+0x90>
	eax = 0; edx = 0;
  103cbe:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  103cc5:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103cc6:	83 ec 0c             	sub    $0xc,%esp
	eax = 0; edx = 0;
  103cc9:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  103cd0:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103cd1:	8b 44 24 18          	mov    0x18(%esp),%eax
  103cd5:	50                   	push   %eax
  103cd6:	55                   	push   %ebp
  103cd7:	57                   	push   %edi
	{
		msr_sys_time = MSR_KVM_SYSTEM_TIME;
	}
	else
	{
		return (0llu);
  103cd8:	31 ff                	xor    %edi,%edi
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103cda:	56                   	push   %esi
		return (0llu);
  103cdb:	31 f6                	xor    %esi,%esi
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103cdd:	68 01 00 00 40       	push   $0x40000001
  103ce2:	e8 39 10 00 00       	call   104d20 <cpuid>
	return ((eax & feature) != 0 ? 1 : 0);
  103ce7:	83 c4 20             	add    $0x20,%esp

	/* disable update */
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock));

	return tsc_hz;
}
  103cea:	89 f0                	mov    %esi,%eax
  103cec:	89 fa                	mov    %edi,%edx
  103cee:	83 c4 2c             	add    $0x2c,%esp
  103cf1:	5b                   	pop    %ebx
  103cf2:	5e                   	pop    %esi
  103cf3:	5f                   	pop    %edi
  103cf4:	5d                   	pop    %ebp
  103cf5:	c3                   	ret    
  103cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103cfd:	8d 76 00             	lea    0x0(%esi),%esi
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock) | 0x1llu);
  103d00:	8d ab 80 89 02 00    	lea    0x28980(%ebx),%ebp
  103d06:	83 ec 04             	sub    $0x4,%esp
  103d09:	31 d2                	xor    %edx,%edx
	tsc_hz = (uint64_t) pvclock.tsc_to_system_mul;
  103d0b:	31 ff                	xor    %edi,%edi
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock) | 0x1llu);
  103d0d:	89 e8                	mov    %ebp,%eax
  103d0f:	52                   	push   %edx
  103d10:	83 c8 01             	or     $0x1,%eax
  103d13:	50                   	push   %eax
  103d14:	68 01 4d 56 4b       	push   $0x4b564d01
  103d19:	e8 72 0f 00 00       	call   104c90 <wrmsr>
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock));
  103d1e:	83 c4 0c             	add    $0xc,%esp
  103d21:	31 d2                	xor    %edx,%edx
	tsc_hz = (uint64_t) pvclock.tsc_to_system_mul;
  103d23:	8b b3 98 89 02 00    	mov    0x28998(%ebx),%esi
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock));
  103d29:	52                   	push   %edx
  103d2a:	55                   	push   %ebp
  103d2b:	68 01 4d 56 4b       	push   $0x4b564d01
  103d30:	e8 5b 0f 00 00       	call   104c90 <wrmsr>
	return tsc_hz;
  103d35:	83 c4 10             	add    $0x10,%esp
}
  103d38:	89 f0                	mov    %esi,%eax
  103d3a:	89 fa                	mov    %edi,%edx
  103d3c:	83 c4 2c             	add    $0x2c,%esp
  103d3f:	5b                   	pop    %ebx
  103d40:	5e                   	pop    %esi
  103d41:	5f                   	pop    %edi
  103d42:	5d                   	pop    %ebp
  103d43:	c3                   	ret    

00103d44 <__x86.get_pc_thunk.di>:
  103d44:	8b 3c 24             	mov    (%esp),%edi
  103d47:	c3                   	ret    
  103d48:	66 90                	xchg   %ax,%ax
  103d4a:	66 90                	xchg   %ax,%ax
  103d4c:	66 90                	xchg   %ax,%ax
  103d4e:	66 90                	xchg   %ax,%ax

00103d50 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *v, int c, size_t n)
{
  103d50:	57                   	push   %edi
  103d51:	56                   	push   %esi
  103d52:	53                   	push   %ebx
  103d53:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  103d57:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
  103d5b:	85 c9                	test   %ecx,%ecx
  103d5d:	74 28                	je     103d87 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
  103d5f:	89 f8                	mov    %edi,%eax
  103d61:	09 c8                	or     %ecx,%eax
  103d63:	a8 03                	test   $0x3,%al
  103d65:	75 29                	jne    103d90 <memset+0x40>
        c &= 0xFF;
  103d67:	0f b6 5c 24 14       	movzbl 0x14(%esp),%ebx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
  103d6c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
  103d6f:	89 da                	mov    %ebx,%edx
  103d71:	89 de                	mov    %ebx,%esi
  103d73:	89 d8                	mov    %ebx,%eax
  103d75:	c1 e2 18             	shl    $0x18,%edx
  103d78:	c1 e6 10             	shl    $0x10,%esi
  103d7b:	09 f2                	or     %esi,%edx
  103d7d:	c1 e0 08             	shl    $0x8,%eax
  103d80:	09 da                	or     %ebx,%edx
  103d82:	09 d0                	or     %edx,%eax
        asm volatile ("cld; rep stosl\n"
  103d84:	fc                   	cld    
  103d85:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
  103d87:	89 f8                	mov    %edi,%eax
  103d89:	5b                   	pop    %ebx
  103d8a:	5e                   	pop    %esi
  103d8b:	5f                   	pop    %edi
  103d8c:	c3                   	ret    
  103d8d:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
  103d90:	8b 44 24 14          	mov    0x14(%esp),%eax
  103d94:	fc                   	cld    
  103d95:	f3 aa                	rep stos %al,%es:(%edi)
}
  103d97:	89 f8                	mov    %edi,%eax
  103d99:	5b                   	pop    %ebx
  103d9a:	5e                   	pop    %esi
  103d9b:	5f                   	pop    %edi
  103d9c:	c3                   	ret    
  103d9d:	8d 76 00             	lea    0x0(%esi),%esi

00103da0 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
  103da0:	57                   	push   %edi
  103da1:	56                   	push   %esi
  103da2:	8b 44 24 0c          	mov    0xc(%esp),%eax
  103da6:	8b 74 24 10          	mov    0x10(%esp),%esi
  103daa:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  103dae:	39 c6                	cmp    %eax,%esi
  103db0:	73 26                	jae    103dd8 <memmove+0x38>
  103db2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  103db5:	39 c2                	cmp    %eax,%edx
  103db7:	76 1f                	jbe    103dd8 <memmove+0x38>
        s += n;
        d += n;
  103db9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
  103dbc:	89 d6                	mov    %edx,%esi
  103dbe:	09 fe                	or     %edi,%esi
  103dc0:	09 ce                	or     %ecx,%esi
  103dc2:	83 e6 03             	and    $0x3,%esi
  103dc5:	74 39                	je     103e00 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
  103dc7:	83 ef 01             	sub    $0x1,%edi
  103dca:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
  103dcd:	fd                   	std    
  103dce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
  103dd0:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
  103dd1:	5e                   	pop    %esi
  103dd2:	5f                   	pop    %edi
  103dd3:	c3                   	ret    
  103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
  103dd8:	89 f2                	mov    %esi,%edx
  103dda:	09 c2                	or     %eax,%edx
  103ddc:	09 ca                	or     %ecx,%edx
  103dde:	83 e2 03             	and    $0x3,%edx
  103de1:	74 0d                	je     103df0 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
  103de3:	89 c7                	mov    %eax,%edi
  103de5:	fc                   	cld    
  103de6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
  103de8:	5e                   	pop    %esi
  103de9:	5f                   	pop    %edi
  103dea:	c3                   	ret    
  103deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103def:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
  103df0:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
  103df3:	89 c7                	mov    %eax,%edi
  103df5:	fc                   	cld    
  103df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103df8:	eb ee                	jmp    103de8 <memmove+0x48>
  103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
  103e00:	83 ef 04             	sub    $0x4,%edi
  103e03:	8d 72 fc             	lea    -0x4(%edx),%esi
  103e06:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
  103e09:	fd                   	std    
  103e0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103e0c:	eb c2                	jmp    103dd0 <memmove+0x30>
  103e0e:	66 90                	xchg   %ax,%ax

00103e10 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
  103e10:	eb 8e                	jmp    103da0 <memmove>
  103e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103e20 <strncmp>:
}

int strncmp(const char *p, const char *q, size_t n)
{
  103e20:	56                   	push   %esi
  103e21:	53                   	push   %ebx
  103e22:	8b 74 24 14          	mov    0x14(%esp),%esi
  103e26:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  103e2a:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
  103e2e:	85 f6                	test   %esi,%esi
  103e30:	74 2e                	je     103e60 <strncmp+0x40>
  103e32:	01 c6                	add    %eax,%esi
  103e34:	eb 18                	jmp    103e4e <strncmp+0x2e>
  103e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103e3d:	8d 76 00             	lea    0x0(%esi),%esi
  103e40:	38 da                	cmp    %bl,%dl
  103e42:	75 14                	jne    103e58 <strncmp+0x38>
        n--, p++, q++;
  103e44:	83 c0 01             	add    $0x1,%eax
  103e47:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
  103e4a:	39 f0                	cmp    %esi,%eax
  103e4c:	74 12                	je     103e60 <strncmp+0x40>
  103e4e:	0f b6 11             	movzbl (%ecx),%edx
  103e51:	0f b6 18             	movzbl (%eax),%ebx
  103e54:	84 d2                	test   %dl,%dl
  103e56:	75 e8                	jne    103e40 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
  103e58:	0f b6 c2             	movzbl %dl,%eax
  103e5b:	29 d8                	sub    %ebx,%eax
}
  103e5d:	5b                   	pop    %ebx
  103e5e:	5e                   	pop    %esi
  103e5f:	c3                   	ret    
        return 0;
  103e60:	31 c0                	xor    %eax,%eax
}
  103e62:	5b                   	pop    %ebx
  103e63:	5e                   	pop    %esi
  103e64:	c3                   	ret    
  103e65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103e70 <strnlen>:

int strnlen(const char *s, size_t size)
{
  103e70:	8b 54 24 08          	mov    0x8(%esp),%edx
  103e74:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  103e78:	31 c0                	xor    %eax,%eax
  103e7a:	85 d2                	test   %edx,%edx
  103e7c:	75 09                	jne    103e87 <strnlen+0x17>
  103e7e:	eb 10                	jmp    103e90 <strnlen+0x20>
        n++;
  103e80:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  103e83:	39 d0                	cmp    %edx,%eax
  103e85:	74 09                	je     103e90 <strnlen+0x20>
  103e87:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  103e8b:	75 f3                	jne    103e80 <strnlen+0x10>
  103e8d:	c3                   	ret    
  103e8e:	66 90                	xchg   %ax,%ax
    return n;
}
  103e90:	c3                   	ret    
  103e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103e9f:	90                   	nop

00103ea0 <strcmp>:

int strcmp(const char *p, const char *q)
{
  103ea0:	53                   	push   %ebx
  103ea1:	8b 54 24 08          	mov    0x8(%esp),%edx
  103ea5:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    while (*p && *p == *q)
  103ea9:	0f b6 02             	movzbl (%edx),%eax
  103eac:	84 c0                	test   %al,%al
  103eae:	75 18                	jne    103ec8 <strcmp+0x28>
  103eb0:	eb 30                	jmp    103ee2 <strcmp+0x42>
  103eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103eb8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
        p++, q++;
  103ebc:	83 c2 01             	add    $0x1,%edx
  103ebf:	8d 59 01             	lea    0x1(%ecx),%ebx
    while (*p && *p == *q)
  103ec2:	84 c0                	test   %al,%al
  103ec4:	74 12                	je     103ed8 <strcmp+0x38>
        p++, q++;
  103ec6:	89 d9                	mov    %ebx,%ecx
    while (*p && *p == *q)
  103ec8:	0f b6 19             	movzbl (%ecx),%ebx
  103ecb:	38 c3                	cmp    %al,%bl
  103ecd:	74 e9                	je     103eb8 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
  103ecf:	29 d8                	sub    %ebx,%eax
}
  103ed1:	5b                   	pop    %ebx
  103ed2:	c3                   	ret    
  103ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103ed7:	90                   	nop
    return (int) ((unsigned char) *p - (unsigned char) *q);
  103ed8:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  103edc:	31 c0                	xor    %eax,%eax
  103ede:	29 d8                	sub    %ebx,%eax
}
  103ee0:	5b                   	pop    %ebx
  103ee1:	c3                   	ret    
    return (int) ((unsigned char) *p - (unsigned char) *q);
  103ee2:	0f b6 19             	movzbl (%ecx),%ebx
  103ee5:	31 c0                	xor    %eax,%eax
  103ee7:	eb e6                	jmp    103ecf <strcmp+0x2f>
  103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103ef0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *strchr(const char *s, char c)
{
  103ef0:	8b 44 24 04          	mov    0x4(%esp),%eax
  103ef4:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
  103ef9:	0f b6 10             	movzbl (%eax),%edx
  103efc:	84 d2                	test   %dl,%dl
  103efe:	75 13                	jne    103f13 <strchr+0x23>
  103f00:	eb 1e                	jmp    103f20 <strchr+0x30>
  103f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103f08:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  103f0c:	83 c0 01             	add    $0x1,%eax
  103f0f:	84 d2                	test   %dl,%dl
  103f11:	74 0d                	je     103f20 <strchr+0x30>
        if (*s == c)
  103f13:	38 d1                	cmp    %dl,%cl
  103f15:	75 f1                	jne    103f08 <strchr+0x18>
            return (char *) s;
    return 0;
}
  103f17:	c3                   	ret    
  103f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103f1f:	90                   	nop
    return 0;
  103f20:	31 c0                	xor    %eax,%eax
}
  103f22:	c3                   	ret    
  103f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103f30 <memzero>:

void *memzero(void *v, size_t n)
{
  103f30:	57                   	push   %edi
  103f31:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  103f35:	8b 7c 24 08          	mov    0x8(%esp),%edi
    if (n == 0)
  103f39:	85 c9                	test   %ecx,%ecx
  103f3b:	74 0f                	je     103f4c <memzero+0x1c>
    if ((int) v % 4 == 0 && n % 4 == 0) {
  103f3d:	89 f8                	mov    %edi,%eax
  103f3f:	09 c8                	or     %ecx,%eax
  103f41:	83 e0 03             	and    $0x3,%eax
  103f44:	75 0a                	jne    103f50 <memzero+0x20>
                      :: "D" (v), "a" (c), "c" (n / 4)
  103f46:	c1 e9 02             	shr    $0x2,%ecx
        asm volatile ("cld; rep stosl\n"
  103f49:	fc                   	cld    
  103f4a:	f3 ab                	rep stos %eax,%es:(%edi)
    return memset(v, 0, n);
}
  103f4c:	89 f8                	mov    %edi,%eax
  103f4e:	5f                   	pop    %edi
  103f4f:	c3                   	ret    
        asm volatile ("cld; rep stosb\n"
  103f50:	31 c0                	xor    %eax,%eax
  103f52:	fc                   	cld    
  103f53:	f3 aa                	rep stos %al,%es:(%edi)
}
  103f55:	89 f8                	mov    %edi,%eax
  103f57:	5f                   	pop    %edi
  103f58:	c3                   	ret    
  103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103f60 <memcmp>:

int memcmp(const void *v1, const void *v2, size_t n)
{
  103f60:	56                   	push   %esi
  103f61:	53                   	push   %ebx
  103f62:	8b 74 24 14          	mov    0x14(%esp),%esi
  103f66:	8b 54 24 0c          	mov    0xc(%esp),%edx
  103f6a:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
  103f6e:	85 f6                	test   %esi,%esi
  103f70:	74 2e                	je     103fa0 <memcmp+0x40>
  103f72:	01 c6                	add    %eax,%esi
  103f74:	eb 14                	jmp    103f8a <memcmp+0x2a>
  103f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103f7d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
  103f80:	83 c0 01             	add    $0x1,%eax
  103f83:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
  103f86:	39 f0                	cmp    %esi,%eax
  103f88:	74 16                	je     103fa0 <memcmp+0x40>
        if (*s1 != *s2)
  103f8a:	0f b6 0a             	movzbl (%edx),%ecx
  103f8d:	0f b6 18             	movzbl (%eax),%ebx
  103f90:	38 d9                	cmp    %bl,%cl
  103f92:	74 ec                	je     103f80 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
  103f94:	0f b6 c1             	movzbl %cl,%eax
  103f97:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
  103f99:	5b                   	pop    %ebx
  103f9a:	5e                   	pop    %esi
  103f9b:	c3                   	ret    
  103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  103fa0:	31 c0                	xor    %eax,%eax
}
  103fa2:	5b                   	pop    %ebx
  103fa3:	5e                   	pop    %esi
  103fa4:	c3                   	ret    
  103fa5:	66 90                	xchg   %ax,%ax
  103fa7:	66 90                	xchg   %ax,%ax
  103fa9:	66 90                	xchg   %ax,%ax
  103fab:	66 90                	xchg   %ax,%ax
  103fad:	66 90                	xchg   %ax,%ax
  103faf:	90                   	nop

00103fb0 <debug_init>:
#include <lib/spinlock.h>


void debug_init(void)
{
}
  103fb0:	c3                   	ret    
  103fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103fbf:	90                   	nop

00103fc0 <debug_info>:

extern int vdprintf(const char *fmt, va_list ap);

void debug_info(const char *fmt, ...)
{
  103fc0:	53                   	push   %ebx
  103fc1:	e8 c3 c3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103fc6:	81 c3 3a d0 00 00    	add    $0xd03a,%ebx
  103fcc:	83 ec 08             	sub    $0x8,%esp
#ifdef DEBUG_MSG
    va_list ap;
    va_start(ap, fmt);
  103fcf:	8d 44 24 14          	lea    0x14(%esp),%eax
    vdprintf(fmt, ap);
  103fd3:	83 ec 08             	sub    $0x8,%esp
  103fd6:	50                   	push   %eax
  103fd7:	ff 74 24 1c          	push   0x1c(%esp)
  103fdb:	e8 d0 01 00 00       	call   1041b0 <vdprintf>
    va_end(ap);
#endif
}
  103fe0:	83 c4 18             	add    $0x18,%esp
  103fe3:	5b                   	pop    %ebx
  103fe4:	c3                   	ret    
  103fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103ff0 <debug_normal>:

#ifdef DEBUG_MSG

void debug_normal(const char *file, int line, const char *fmt, ...)
{
  103ff0:	53                   	push   %ebx
  103ff1:	e8 93 c3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  103ff6:	81 c3 0a d0 00 00    	add    $0xd00a,%ebx
  103ffc:	83 ec 0c             	sub    $0xc,%esp
    dprintf("[D] %s:%d: ", file, line);
  103fff:	ff 74 24 18          	push   0x18(%esp)
  104003:	ff 74 24 18          	push   0x18(%esp)
  104007:	8d 83 e2 91 ff ff    	lea    -0x6e1e(%ebx),%eax
  10400d:	50                   	push   %eax
  10400e:	e8 2d 02 00 00       	call   104240 <dprintf>

    va_list ap;
    va_start(ap, fmt);
  104013:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    vdprintf(fmt, ap);
  104017:	5a                   	pop    %edx
  104018:	59                   	pop    %ecx
  104019:	50                   	push   %eax
  10401a:	ff 74 24 24          	push   0x24(%esp)
  10401e:	e8 8d 01 00 00       	call   1041b0 <vdprintf>
    va_end(ap);
}
  104023:	83 c4 18             	add    $0x18,%esp
  104026:	5b                   	pop    %ebx
  104027:	c3                   	ret    
  104028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10402f:	90                   	nop

00104030 <debug_panic>:
    for (; i < DEBUG_TRACEFRAMES; i++)
        eips[i] = 0;
}

gcc_noinline void debug_panic(const char *file, int line, const char *fmt, ...)
{
  104030:	55                   	push   %ebp
  104031:	57                   	push   %edi
  104032:	56                   	push   %esi
  104033:	53                   	push   %ebx
  104034:	e8 50 c3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104039:	81 c3 c7 cf 00 00    	add    $0xcfc7,%ebx
  10403f:	83 ec 40             	sub    $0x40,%esp
    int i;
    uintptr_t eips[DEBUG_TRACEFRAMES];
    va_list ap;

    dprintf("[P] %s:%d: ", file, line);
  104042:	ff 74 24 58          	push   0x58(%esp)
  104046:	ff 74 24 58          	push   0x58(%esp)
  10404a:	8d 83 ee 91 ff ff    	lea    -0x6e12(%ebx),%eax
  104050:	50                   	push   %eax
  104051:	e8 ea 01 00 00       	call   104240 <dprintf>

    va_start(ap, fmt);
  104056:	8d 44 24 6c          	lea    0x6c(%esp),%eax
    vdprintf(fmt, ap);
  10405a:	5a                   	pop    %edx
  10405b:	59                   	pop    %ecx
  10405c:	50                   	push   %eax
  10405d:	ff 74 24 64          	push   0x64(%esp)
  104061:	e8 4a 01 00 00       	call   1041b0 <vdprintf>
    va_end(ap);

    debug_trace(read_ebp(), eips);
  104066:	e8 d5 0b 00 00       	call   104c40 <read_ebp>
    for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  10406b:	83 c4 10             	add    $0x10,%esp
  10406e:	31 d2                	xor    %edx,%edx
  104070:	8d 74 24 08          	lea    0x8(%esp),%esi
  104074:	85 c0                	test   %eax,%eax
  104076:	74 21                	je     104099 <debug_panic+0x69>
  104078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10407f:	90                   	nop
        eips[i] = frame[1];              /* saved %eip */
  104080:	8b 48 04             	mov    0x4(%eax),%ecx
        frame = (uintptr_t *) frame[0];  /* saved %ebp */
  104083:	8b 00                	mov    (%eax),%eax
        eips[i] = frame[1];              /* saved %eip */
  104085:	89 0c 96             	mov    %ecx,(%esi,%edx,4)
    for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  104088:	83 c2 01             	add    $0x1,%edx
  10408b:	83 fa 09             	cmp    $0x9,%edx
  10408e:	7f 04                	jg     104094 <debug_panic+0x64>
  104090:	85 c0                	test   %eax,%eax
  104092:	75 ec                	jne    104080 <debug_panic+0x50>
    for (; i < DEBUG_TRACEFRAMES; i++)
  104094:	83 fa 0a             	cmp    $0xa,%edx
  104097:	74 14                	je     1040ad <debug_panic+0x7d>
  104099:	8d 04 96             	lea    (%esi,%edx,4),%eax
  10409c:	8d 54 24 30          	lea    0x30(%esp),%edx
        eips[i] = 0;
  1040a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; i < DEBUG_TRACEFRAMES; i++)
  1040a6:	83 c0 04             	add    $0x4,%eax
  1040a9:	39 d0                	cmp    %edx,%eax
  1040ab:	75 f3                	jne    1040a0 <debug_panic+0x70>
  1040ad:	8d 6c 24 30          	lea    0x30(%esp),%ebp
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
        dprintf("\tfrom 0x%08x\n", eips[i]);
  1040b1:	8d bb fa 91 ff ff    	lea    -0x6e06(%ebx),%edi
  1040b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1040be:	66 90                	xchg   %ax,%ax
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  1040c0:	8b 06                	mov    (%esi),%eax
  1040c2:	85 c0                	test   %eax,%eax
  1040c4:	74 14                	je     1040da <debug_panic+0xaa>
        dprintf("\tfrom 0x%08x\n", eips[i]);
  1040c6:	83 ec 08             	sub    $0x8,%esp
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  1040c9:	83 c6 04             	add    $0x4,%esi
        dprintf("\tfrom 0x%08x\n", eips[i]);
  1040cc:	50                   	push   %eax
  1040cd:	57                   	push   %edi
  1040ce:	e8 6d 01 00 00       	call   104240 <dprintf>
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  1040d3:	83 c4 10             	add    $0x10,%esp
  1040d6:	39 f5                	cmp    %esi,%ebp
  1040d8:	75 e6                	jne    1040c0 <debug_panic+0x90>

    dprintf("Kernel Panic !!!\n");
  1040da:	83 ec 0c             	sub    $0xc,%esp
  1040dd:	8d 83 08 92 ff ff    	lea    -0x6df8(%ebx),%eax
  1040e3:	50                   	push   %eax
  1040e4:	e8 57 01 00 00       	call   104240 <dprintf>

    halt();
  1040e9:	e8 b2 0b 00 00       	call   104ca0 <halt>
}
  1040ee:	83 c4 4c             	add    $0x4c,%esp
  1040f1:	5b                   	pop    %ebx
  1040f2:	5e                   	pop    %esi
  1040f3:	5f                   	pop    %edi
  1040f4:	5d                   	pop    %ebp
  1040f5:	c3                   	ret    
  1040f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1040fd:	8d 76 00             	lea    0x0(%esi),%esi

00104100 <debug_warn>:

void debug_warn(const char *file, int line, const char *fmt, ...)
{
  104100:	53                   	push   %ebx
  104101:	e8 83 c2 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104106:	81 c3 fa ce 00 00    	add    $0xcefa,%ebx
  10410c:	83 ec 0c             	sub    $0xc,%esp
    dprintf("[W] %s:%d: ", file, line);
  10410f:	ff 74 24 18          	push   0x18(%esp)
  104113:	ff 74 24 18          	push   0x18(%esp)
  104117:	8d 83 1a 92 ff ff    	lea    -0x6de6(%ebx),%eax
  10411d:	50                   	push   %eax
  10411e:	e8 1d 01 00 00       	call   104240 <dprintf>

    va_list ap;
    va_start(ap, fmt);
  104123:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    vdprintf(fmt, ap);
  104127:	5a                   	pop    %edx
  104128:	59                   	pop    %ecx
  104129:	50                   	push   %eax
  10412a:	ff 74 24 24          	push   0x24(%esp)
  10412e:	e8 7d 00 00 00       	call   1041b0 <vdprintf>
    va_end(ap);
}
  104133:	83 c4 18             	add    $0x18,%esp
  104136:	5b                   	pop    %ebx
  104137:	c3                   	ret    
  104138:	66 90                	xchg   %ax,%ax
  10413a:	66 90                	xchg   %ax,%ax
  10413c:	66 90                	xchg   %ax,%ax
  10413e:	66 90                	xchg   %ax,%ax

00104140 <putch>:
        str += 1;
    }
}

static void putch(int ch, struct dprintbuf *b)
{
  104140:	57                   	push   %edi
  104141:	56                   	push   %esi
  104142:	53                   	push   %ebx
  104143:	8b 74 24 14          	mov    0x14(%esp),%esi
  104147:	e8 3d c2 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10414c:	81 c3 b4 ce 00 00    	add    $0xceb4,%ebx
    b->buf[b->idx++] = ch;
  104152:	8b 54 24 10          	mov    0x10(%esp),%edx
  104156:	8b 0e                	mov    (%esi),%ecx
  104158:	8d 41 01             	lea    0x1(%ecx),%eax
  10415b:	89 06                	mov    %eax,(%esi)
  10415d:	88 54 0e 08          	mov    %dl,0x8(%esi,%ecx,1)
    if (b->idx == CONSOLE_BUFFER_SIZE - 1) {
  104161:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  104166:	74 08                	je     104170 <putch+0x30>
        b->buf[b->idx] = 0;
        cputs(b->buf);
        b->idx = 0;
    }
    b->cnt++;
  104168:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  10416c:	5b                   	pop    %ebx
  10416d:	5e                   	pop    %esi
  10416e:	5f                   	pop    %edi
  10416f:	c3                   	ret    
    while (*str) {
  104170:	0f be 46 08          	movsbl 0x8(%esi),%eax
        b->buf[b->idx] = 0;
  104174:	c6 86 07 02 00 00 00 	movb   $0x0,0x207(%esi)
        cputs(b->buf);
  10417b:	8d 7e 08             	lea    0x8(%esi),%edi
    while (*str) {
  10417e:	84 c0                	test   %al,%al
  104180:	74 1c                	je     10419e <putch+0x5e>
  104182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cons_putc(*str);
  104188:	83 ec 0c             	sub    $0xc,%esp
        str += 1;
  10418b:	83 c7 01             	add    $0x1,%edi
        cons_putc(*str);
  10418e:	50                   	push   %eax
  10418f:	e8 5c c3 ff ff       	call   1004f0 <cons_putc>
    while (*str) {
  104194:	0f be 07             	movsbl (%edi),%eax
  104197:	83 c4 10             	add    $0x10,%esp
  10419a:	84 c0                	test   %al,%al
  10419c:	75 ea                	jne    104188 <putch+0x48>
    b->cnt++;
  10419e:	83 46 04 01          	addl   $0x1,0x4(%esi)
        b->idx = 0;
  1041a2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
}
  1041a8:	5b                   	pop    %ebx
  1041a9:	5e                   	pop    %esi
  1041aa:	5f                   	pop    %edi
  1041ab:	c3                   	ret    
  1041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001041b0 <vdprintf>:

int vdprintf(const char *fmt, va_list ap)
{
  1041b0:	56                   	push   %esi
  1041b1:	53                   	push   %ebx
  1041b2:	e8 d2 c1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1041b7:	81 c3 49 ce 00 00    	add    $0xce49,%ebx
  1041bd:	81 ec 14 02 00 00    	sub    $0x214,%esp
    struct dprintbuf b;

    b.idx = 0;
  1041c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1041ca:	00 
    b.cnt = 0;
  1041cb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1041d2:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
  1041d3:	ff b4 24 24 02 00 00 	push   0x224(%esp)
  1041da:	ff b4 24 24 02 00 00 	push   0x224(%esp)
  1041e1:	8d 44 24 10          	lea    0x10(%esp),%eax
  1041e5:	50                   	push   %eax
  1041e6:	8d 83 40 31 ff ff    	lea    -0xcec0(%ebx),%eax
  1041ec:	50                   	push   %eax
  1041ed:	e8 9e 01 00 00       	call   104390 <vprintfmt>

    b.buf[b.idx] = 0;
  1041f2:	8b 44 24 18          	mov    0x18(%esp),%eax
  1041f6:	c6 44 04 20 00       	movb   $0x0,0x20(%esp,%eax,1)
    while (*str) {
  1041fb:	0f be 44 24 20       	movsbl 0x20(%esp),%eax
  104200:	83 c4 10             	add    $0x10,%esp
  104203:	84 c0                	test   %al,%al
  104205:	74 1f                	je     104226 <vdprintf+0x76>
  104207:	8d 74 24 10          	lea    0x10(%esp),%esi
  10420b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10420f:	90                   	nop
        cons_putc(*str);
  104210:	83 ec 0c             	sub    $0xc,%esp
        str += 1;
  104213:	83 c6 01             	add    $0x1,%esi
        cons_putc(*str);
  104216:	50                   	push   %eax
  104217:	e8 d4 c2 ff ff       	call   1004f0 <cons_putc>
    while (*str) {
  10421c:	0f be 06             	movsbl (%esi),%eax
  10421f:	83 c4 10             	add    $0x10,%esp
  104222:	84 c0                	test   %al,%al
  104224:	75 ea                	jne    104210 <vdprintf+0x60>
    cputs(b.buf);

    return b.cnt;
}
  104226:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10422a:	81 c4 14 02 00 00    	add    $0x214,%esp
  104230:	5b                   	pop    %ebx
  104231:	5e                   	pop    %esi
  104232:	c3                   	ret    
  104233:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104240 <dprintf>:

int dprintf(const char *fmt, ...)
{
  104240:	57                   	push   %edi
  104241:	56                   	push   %esi
  104242:	53                   	push   %ebx
  104243:	e8 41 c1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104248:	81 c3 b8 cd 00 00    	add    $0xcdb8,%ebx
    va_list ap;
    int cnt;

    if (!deprintf_lock_inited) {
  10424e:	80 bb a0 89 02 00 00 	cmpb   $0x0,0x289a0(%ebx)
  104255:	8d bb a4 89 02 00    	lea    0x289a4(%ebx),%edi
  10425b:	74 33                	je     104290 <dprintf+0x50>
        spinlock_init(&deprintf_lock);
        deprintf_lock_inited = TRUE;
    }

    spinlock_acquire(&deprintf_lock);
  10425d:	83 ec 0c             	sub    $0xc,%esp
  104260:	57                   	push   %edi
  104261:	e8 1a 15 00 00       	call   105780 <spinlock_acquire>

    va_start(ap, fmt);
  104266:	8d 44 24 24          	lea    0x24(%esp),%eax
    cnt = vdprintf(fmt, ap);
  10426a:	5a                   	pop    %edx
  10426b:	59                   	pop    %ecx
  10426c:	50                   	push   %eax
  10426d:	ff 74 24 1c          	push   0x1c(%esp)
  104271:	e8 3a ff ff ff       	call   1041b0 <vdprintf>
    va_end(ap);

    spinlock_release(&deprintf_lock);
  104276:	89 3c 24             	mov    %edi,(%esp)
    cnt = vdprintf(fmt, ap);
  104279:	89 c6                	mov    %eax,%esi
    spinlock_release(&deprintf_lock);
  10427b:	e8 80 15 00 00       	call   105800 <spinlock_release>

    return cnt;
  104280:	83 c4 10             	add    $0x10,%esp
}
  104283:	89 f0                	mov    %esi,%eax
  104285:	5b                   	pop    %ebx
  104286:	5e                   	pop    %esi
  104287:	5f                   	pop    %edi
  104288:	c3                   	ret    
  104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        spinlock_init(&deprintf_lock);
  104290:	83 ec 0c             	sub    $0xc,%esp
  104293:	57                   	push   %edi
  104294:	e8 57 14 00 00       	call   1056f0 <spinlock_init>
        deprintf_lock_inited = TRUE;
  104299:	c6 83 a0 89 02 00 01 	movb   $0x1,0x289a0(%ebx)
  1042a0:	83 c4 10             	add    $0x10,%esp
  1042a3:	eb b8                	jmp    10425d <dprintf+0x1d>
  1042a5:	66 90                	xchg   %ax,%ax
  1042a7:	66 90                	xchg   %ax,%ax
  1042a9:	66 90                	xchg   %ax,%ax
  1042ab:	66 90                	xchg   %ax,%ax
  1042ad:	66 90                	xchg   %ax,%ax
  1042af:	90                   	nop

001042b0 <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void printnum(putch_t putch, void *putdat, unsigned long long num,
                     unsigned base, int width, int padc)
{
  1042b0:	e8 de 05 00 00       	call   104893 <__x86.get_pc_thunk.cx>
  1042b5:	81 c1 4b cd 00 00    	add    $0xcd4b,%ecx
  1042bb:	55                   	push   %ebp
  1042bc:	57                   	push   %edi
  1042bd:	89 d7                	mov    %edx,%edi
  1042bf:	56                   	push   %esi
  1042c0:	89 c6                	mov    %eax,%esi
  1042c2:	53                   	push   %ebx
  1042c3:	83 ec 2c             	sub    $0x2c,%esp
  1042c6:	8b 54 24 44          	mov    0x44(%esp),%edx
  1042ca:	8b 44 24 40          	mov    0x40(%esp),%eax
  1042ce:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
    /* first recursively print all preceding (more significant) digits */
    if (num >= base) {
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        /* print any needed pad characters before first digit */
        while (--width > 0)
  1042d2:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
{
  1042d6:	8b 5c 24 50          	mov    0x50(%esp),%ebx
    if (num >= base) {
  1042da:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  1042e1:	00 
{
  1042e2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1042e6:	8b 54 24 48          	mov    0x48(%esp),%edx
  1042ea:	89 44 24 08          	mov    %eax,0x8(%esp)
    if (num >= base) {
  1042ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
        while (--width > 0)
  1042f2:	8d 69 ff             	lea    -0x1(%ecx),%ebp
    if (num >= base) {
  1042f5:	39 54 24 08          	cmp    %edx,0x8(%esp)
  1042f9:	1b 44 24 14          	sbb    0x14(%esp),%eax
  1042fd:	89 54 24 10          	mov    %edx,0x10(%esp)
  104301:	73 55                	jae    104358 <printnum+0xa8>
        while (--width > 0)
  104303:	85 ed                	test   %ebp,%ebp
  104305:	7e 18                	jle    10431f <printnum+0x6f>
  104307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10430e:	66 90                	xchg   %ax,%ax
            putch(padc, putdat);
  104310:	83 ec 08             	sub    $0x8,%esp
  104313:	57                   	push   %edi
  104314:	53                   	push   %ebx
  104315:	ff d6                	call   *%esi
        while (--width > 0)
  104317:	83 c4 10             	add    $0x10,%esp
  10431a:	83 ed 01             	sub    $0x1,%ebp
  10431d:	75 f1                	jne    104310 <printnum+0x60>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
  10431f:	89 7c 24 44          	mov    %edi,0x44(%esp)
  104323:	ff 74 24 14          	push   0x14(%esp)
  104327:	ff 74 24 14          	push   0x14(%esp)
  10432b:	ff 74 24 14          	push   0x14(%esp)
  10432f:	ff 74 24 14          	push   0x14(%esp)
  104333:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
  104337:	e8 74 45 00 00       	call   1088b0 <__umoddi3>
  10433c:	0f be 84 03 26 92 ff 	movsbl -0x6dda(%ebx,%eax,1),%eax
  104343:	ff 
  104344:	89 44 24 50          	mov    %eax,0x50(%esp)
}
  104348:	83 c4 3c             	add    $0x3c,%esp
    putch("0123456789abcdef"[num % base], putdat);
  10434b:	89 f0                	mov    %esi,%eax
}
  10434d:	5b                   	pop    %ebx
  10434e:	5e                   	pop    %esi
  10434f:	5f                   	pop    %edi
  104350:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
  104351:	ff e0                	jmp    *%eax
  104353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104357:	90                   	nop
        printnum(putch, putdat, num / base, base, width - 1, padc);
  104358:	83 ec 0c             	sub    $0xc,%esp
  10435b:	53                   	push   %ebx
  10435c:	55                   	push   %ebp
  10435d:	52                   	push   %edx
  10435e:	83 ec 08             	sub    $0x8,%esp
  104361:	ff 74 24 34          	push   0x34(%esp)
  104365:	ff 74 24 34          	push   0x34(%esp)
  104369:	ff 74 24 34          	push   0x34(%esp)
  10436d:	ff 74 24 34          	push   0x34(%esp)
  104371:	8b 5c 24 4c          	mov    0x4c(%esp),%ebx
  104375:	e8 16 44 00 00       	call   108790 <__udivdi3>
  10437a:	83 c4 18             	add    $0x18,%esp
  10437d:	52                   	push   %edx
  10437e:	89 fa                	mov    %edi,%edx
  104380:	50                   	push   %eax
  104381:	89 f0                	mov    %esi,%eax
  104383:	e8 28 ff ff ff       	call   1042b0 <printnum>
  104388:	83 c4 20             	add    $0x20,%esp
  10438b:	eb 92                	jmp    10431f <printnum+0x6f>
  10438d:	8d 76 00             	lea    0x0(%esi),%esi

00104390 <vprintfmt>:
    else
        return va_arg(*ap, int);
}

void vprintfmt(putch_t putch, void *putdat, const char *fmt, va_list ap)
{
  104390:	e8 ec bf ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  104395:	05 6b cc 00 00       	add    $0xcc6b,%eax
  10439a:	55                   	push   %ebp
  10439b:	57                   	push   %edi
  10439c:	56                   	push   %esi
  10439d:	53                   	push   %ebx
  10439e:	83 ec 3c             	sub    $0x3c,%esp
  1043a1:	8b 74 24 50          	mov    0x50(%esp),%esi
  1043a5:	8b 6c 24 54          	mov    0x54(%esp),%ebp
  1043a9:	89 44 24 14          	mov    %eax,0x14(%esp)
        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
                p = "(null)";
            if (width > 0 && padc != '-')
                for (width -= strnlen(p, precision); width > 0; width--)
  1043ad:	8d 80 37 92 ff ff    	lea    -0x6dc9(%eax),%eax
  1043b3:	89 44 24 24          	mov    %eax,0x24(%esp)
{
  1043b7:	8b 7c 24 58          	mov    0x58(%esp),%edi
        while ((ch = *(unsigned char *) fmt++) != '%') {
  1043bb:	0f b6 07             	movzbl (%edi),%eax
  1043be:	8d 5f 01             	lea    0x1(%edi),%ebx
  1043c1:	83 f8 25             	cmp    $0x25,%eax
  1043c4:	75 20                	jne    1043e6 <vprintfmt+0x56>
  1043c6:	eb 30                	jmp    1043f8 <vprintfmt+0x68>
  1043c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043cf:	90                   	nop
            putch(ch, putdat);
  1043d0:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
  1043d3:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
  1043d6:	55                   	push   %ebp
  1043d7:	50                   	push   %eax
  1043d8:	ff d6                	call   *%esi
        while ((ch = *(unsigned char *) fmt++) != '%') {
  1043da:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  1043de:	83 c4 10             	add    $0x10,%esp
  1043e1:	83 f8 25             	cmp    $0x25,%eax
  1043e4:	74 12                	je     1043f8 <vprintfmt+0x68>
            if (ch == '\0')
  1043e6:	85 c0                	test   %eax,%eax
  1043e8:	75 e6                	jne    1043d0 <vprintfmt+0x40>
            for (fmt--; fmt[-1] != '%'; fmt--)
                /* do nothing */ ;
            break;
        }
    }
}
  1043ea:	83 c4 3c             	add    $0x3c,%esp
  1043ed:	5b                   	pop    %ebx
  1043ee:	5e                   	pop    %esi
  1043ef:	5f                   	pop    %edi
  1043f0:	5d                   	pop    %ebp
  1043f1:	c3                   	ret    
  1043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        precision = -1;
  1043f8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        padc = ' ';
  1043fd:	c6 44 24 18 20       	movb   $0x20,0x18(%esp)
        altflag = 0;
  104402:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104409:	00 
        width = -1;
  10440a:	c7 44 24 10 ff ff ff 	movl   $0xffffffff,0x10(%esp)
  104411:	ff 
        lflag = 0;
  104412:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  104419:	00 
  10441a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  10441e:	89 74 24 50          	mov    %esi,0x50(%esp)
        switch (ch = *(unsigned char *) fmt++) {
  104422:	0f b6 0b             	movzbl (%ebx),%ecx
  104425:	8d 7b 01             	lea    0x1(%ebx),%edi
  104428:	8d 41 dd             	lea    -0x23(%ecx),%eax
  10442b:	3c 55                	cmp    $0x55,%al
  10442d:	77 19                	ja     104448 <.L18>
  10442f:	8b 54 24 14          	mov    0x14(%esp),%edx
  104433:	0f b6 c0             	movzbl %al,%eax
  104436:	8b b4 82 40 92 ff ff 	mov    -0x6dc0(%edx,%eax,4),%esi
  10443d:	01 d6                	add    %edx,%esi
  10443f:	ff e6                	jmp    *%esi
  104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104448 <.L18>:
            putch('%', putdat);
  104448:	8b 74 24 50          	mov    0x50(%esp),%esi
  10444c:	83 ec 08             	sub    $0x8,%esp
            for (fmt--; fmt[-1] != '%'; fmt--)
  10444f:	89 df                	mov    %ebx,%edi
            putch('%', putdat);
  104451:	55                   	push   %ebp
  104452:	6a 25                	push   $0x25
  104454:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
  104456:	83 c4 10             	add    $0x10,%esp
  104459:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  10445d:	0f 84 58 ff ff ff    	je     1043bb <vprintfmt+0x2b>
  104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104467:	90                   	nop
  104468:	83 ef 01             	sub    $0x1,%edi
  10446b:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  10446f:	75 f7                	jne    104468 <.L18+0x20>
  104471:	e9 45 ff ff ff       	jmp    1043bb <vprintfmt+0x2b>
  104476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10447d:	8d 76 00             	lea    0x0(%esi),%esi

00104480 <.L27>:
                ch = *fmt;
  104480:	0f be 43 01          	movsbl 0x1(%ebx),%eax
                precision = precision * 10 + ch - '0';
  104484:	8d 51 d0             	lea    -0x30(%ecx),%edx
        switch (ch = *(unsigned char *) fmt++) {
  104487:	89 fb                	mov    %edi,%ebx
                precision = precision * 10 + ch - '0';
  104489:	89 54 24 1c          	mov    %edx,0x1c(%esp)
                if (ch < '0' || ch > '9')
  10448d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  104490:	83 f9 09             	cmp    $0x9,%ecx
  104493:	77 28                	ja     1044bd <.L27+0x3d>
        switch (ch = *(unsigned char *) fmt++) {
  104495:	8b 74 24 50          	mov    0x50(%esp),%esi
  104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (precision = 0;; ++fmt) {
  1044a0:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
  1044a3:	8d 14 92             	lea    (%edx,%edx,4),%edx
  1044a6:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
                ch = *fmt;
  1044aa:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
  1044ad:	8d 48 d0             	lea    -0x30(%eax),%ecx
  1044b0:	83 f9 09             	cmp    $0x9,%ecx
  1044b3:	76 eb                	jbe    1044a0 <.L27+0x20>
  1044b5:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  1044b9:	89 74 24 50          	mov    %esi,0x50(%esp)
            if (width < 0)
  1044bd:	8b 74 24 10          	mov    0x10(%esp),%esi
  1044c1:	85 f6                	test   %esi,%esi
  1044c3:	0f 89 59 ff ff ff    	jns    104422 <vprintfmt+0x92>
                width = precision, precision = -1;
  1044c9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1044cd:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
  1044d4:	ff 
  1044d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1044d9:	e9 44 ff ff ff       	jmp    104422 <vprintfmt+0x92>

001044de <.L23>:
            putch('0', putdat);
  1044de:	8b 74 24 50          	mov    0x50(%esp),%esi
  1044e2:	83 ec 08             	sub    $0x8,%esp
  1044e5:	55                   	push   %ebp
  1044e6:	6a 30                	push   $0x30
  1044e8:	ff d6                	call   *%esi
            putch('x', putdat);
  1044ea:	59                   	pop    %ecx
  1044eb:	5b                   	pop    %ebx
  1044ec:	55                   	push   %ebp
  1044ed:	6a 78                	push   $0x78
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  1044ef:	31 db                	xor    %ebx,%ebx
            putch('x', putdat);
  1044f1:	ff d6                	call   *%esi
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  1044f3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
            goto number;
  1044f7:	ba 10 00 00 00       	mov    $0x10,%edx
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  1044fc:	8b 08                	mov    (%eax),%ecx
            goto number;
  1044fe:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  104501:	83 c0 04             	add    $0x4,%eax
  104504:	89 44 24 5c          	mov    %eax,0x5c(%esp)
            printnum(putch, putdat, num, base, width, padc);
  104508:	83 ec 0c             	sub    $0xc,%esp
  10450b:	0f be 44 24 24       	movsbl 0x24(%esp),%eax
  104510:	50                   	push   %eax
  104511:	89 f0                	mov    %esi,%eax
  104513:	ff 74 24 20          	push   0x20(%esp)
  104517:	52                   	push   %edx
  104518:	89 ea                	mov    %ebp,%edx
  10451a:	53                   	push   %ebx
  10451b:	51                   	push   %ecx
  10451c:	e8 8f fd ff ff       	call   1042b0 <printnum>
            break;
  104521:	83 c4 20             	add    $0x20,%esp
  104524:	e9 92 fe ff ff       	jmp    1043bb <vprintfmt+0x2b>

00104529 <.L32>:
            altflag = 1;
  104529:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104530:	00 
        switch (ch = *(unsigned char *) fmt++) {
  104531:	89 fb                	mov    %edi,%ebx
            goto reswitch;
  104533:	e9 ea fe ff ff       	jmp    104422 <vprintfmt+0x92>

00104538 <.L31>:
            putch(ch, putdat);
  104538:	8b 74 24 50          	mov    0x50(%esp),%esi
  10453c:	83 ec 08             	sub    $0x8,%esp
  10453f:	55                   	push   %ebp
  104540:	6a 25                	push   $0x25
  104542:	ff d6                	call   *%esi
            break;
  104544:	83 c4 10             	add    $0x10,%esp
  104547:	e9 6f fe ff ff       	jmp    1043bb <vprintfmt+0x2b>

0010454c <.L30>:
            precision = va_arg(ap, int);
  10454c:	8b 44 24 5c          	mov    0x5c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
  104550:	89 fb                	mov    %edi,%ebx
            precision = va_arg(ap, int);
  104552:	8b 00                	mov    (%eax),%eax
  104554:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104558:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  10455c:	83 c0 04             	add    $0x4,%eax
  10455f:	89 44 24 5c          	mov    %eax,0x5c(%esp)
            goto process_precision;
  104563:	e9 55 ff ff ff       	jmp    1044bd <.L27+0x3d>

00104568 <.L29>:
            if (width < 0)
  104568:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10456c:	31 c0                	xor    %eax,%eax
        switch (ch = *(unsigned char *) fmt++) {
  10456e:	89 fb                	mov    %edi,%ebx
  104570:	85 c9                	test   %ecx,%ecx
  104572:	0f 49 c1             	cmovns %ecx,%eax
  104575:	89 44 24 10          	mov    %eax,0x10(%esp)
            goto reswitch;
  104579:	e9 a4 fe ff ff       	jmp    104422 <vprintfmt+0x92>

0010457e <.L22>:
            if ((p = va_arg(ap, char *)) == NULL)
  10457e:	8b 44 24 5c          	mov    0x5c(%esp),%eax
            if (width > 0 && padc != '-')
  104582:	8b 5c 24 10          	mov    0x10(%esp),%ebx
            if ((p = va_arg(ap, char *)) == NULL)
  104586:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  10458a:	8b 74 24 50          	mov    0x50(%esp),%esi
  10458e:	83 c0 04             	add    $0x4,%eax
            if (width > 0 && padc != '-')
  104591:	85 db                	test   %ebx,%ebx
            if ((p = va_arg(ap, char *)) == NULL)
  104593:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104597:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  10459b:	8b 08                	mov    (%eax),%ecx
            if (width > 0 && padc != '-')
  10459d:	0f 9f c0             	setg   %al
  1045a0:	80 7c 24 18 2d       	cmpb   $0x2d,0x18(%esp)
  1045a5:	0f 95 c3             	setne  %bl
  1045a8:	21 d8                	and    %ebx,%eax
            if ((p = va_arg(ap, char *)) == NULL)
  1045aa:	85 c9                	test   %ecx,%ecx
  1045ac:	0f 84 e4 01 00 00    	je     104796 <.L28+0xc>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  1045b2:	8d 59 01             	lea    0x1(%ecx),%ebx
  1045b5:	89 5c 24 20          	mov    %ebx,0x20(%esp)
            if (width > 0 && padc != '-')
  1045b9:	84 c0                	test   %al,%al
  1045bb:	0f 85 04 02 00 00    	jne    1047c5 <.L28+0x3b>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  1045c1:	0f be 09             	movsbl (%ecx),%ecx
  1045c4:	89 c8                	mov    %ecx,%eax
  1045c6:	85 c9                	test   %ecx,%ecx
  1045c8:	0f 84 24 01 00 00    	je     1046f2 <.L24+0x18>
  1045ce:	89 74 24 50          	mov    %esi,0x50(%esp)
  1045d2:	89 d6                	mov    %edx,%esi
  1045d4:	89 7c 24 58          	mov    %edi,0x58(%esp)
  1045d8:	8b 7c 24 10          	mov    0x10(%esp),%edi
  1045dc:	eb 2b                	jmp    104609 <.L22+0x8b>
  1045de:	66 90                	xchg   %ax,%ax
                if (altflag && (ch < ' ' || ch > '~'))
  1045e0:	83 e8 20             	sub    $0x20,%eax
  1045e3:	83 f8 5e             	cmp    $0x5e,%eax
  1045e6:	76 36                	jbe    10461e <.L22+0xa0>
                    putch('?', putdat);
  1045e8:	83 ec 08             	sub    $0x8,%esp
  1045eb:	55                   	push   %ebp
  1045ec:	6a 3f                	push   $0x3f
  1045ee:	ff 54 24 60          	call   *0x60(%esp)
  1045f2:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  1045f5:	0f be 03             	movsbl (%ebx),%eax
  1045f8:	83 c3 01             	add    $0x1,%ebx
                 width--)
  1045fb:	83 ef 01             	sub    $0x1,%edi
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  1045fe:	0f be c8             	movsbl %al,%ecx
  104601:	85 c9                	test   %ecx,%ecx
  104603:	0f 84 dd 00 00 00    	je     1046e6 <.L24+0xc>
  104609:	85 f6                	test   %esi,%esi
  10460b:	78 09                	js     104616 <.L22+0x98>
  10460d:	83 ee 01             	sub    $0x1,%esi
  104610:	0f 82 d0 00 00 00    	jb     1046e6 <.L24+0xc>
                if (altflag && (ch < ' ' || ch > '~'))
  104616:	8b 54 24 08          	mov    0x8(%esp),%edx
  10461a:	85 d2                	test   %edx,%edx
  10461c:	75 c2                	jne    1045e0 <.L22+0x62>
                    putch(ch, putdat);
  10461e:	83 ec 08             	sub    $0x8,%esp
  104621:	55                   	push   %ebp
  104622:	51                   	push   %ecx
  104623:	ff 54 24 60          	call   *0x60(%esp)
  104627:	83 c4 10             	add    $0x10,%esp
  10462a:	eb c9                	jmp    1045f5 <.L22+0x77>

0010462c <.L21>:
    if (lflag >= 2)
  10462c:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
  104631:	8b 74 24 50          	mov    0x50(%esp),%esi
        return va_arg(*ap, unsigned long long);
  104635:	8b 44 24 5c          	mov    0x5c(%esp),%eax
    if (lflag >= 2)
  104639:	0f 8f de 00 00 00    	jg     10471d <.L24+0x43>
        return va_arg(*ap, unsigned long);
  10463f:	8b 4c 24 5c          	mov    0x5c(%esp),%ecx
            precision = va_arg(ap, int);
  104643:	83 c0 04             	add    $0x4,%eax
        return va_arg(*ap, unsigned long);
  104646:	31 db                	xor    %ebx,%ebx
  104648:	ba 0a 00 00 00       	mov    $0xa,%edx
  10464d:	8b 09                	mov    (%ecx),%ecx
  10464f:	89 44 24 5c          	mov    %eax,0x5c(%esp)
  104653:	e9 b0 fe ff ff       	jmp    104508 <.L23+0x2a>

00104658 <.L19>:
    if (lflag >= 2)
  104658:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
  10465d:	8b 74 24 50          	mov    0x50(%esp),%esi
        return va_arg(*ap, unsigned long long);
  104661:	8b 44 24 5c          	mov    0x5c(%esp),%eax
    if (lflag >= 2)
  104665:	0f 8f c0 00 00 00    	jg     10472b <.L24+0x51>
        return va_arg(*ap, unsigned long);
  10466b:	8b 4c 24 5c          	mov    0x5c(%esp),%ecx
            precision = va_arg(ap, int);
  10466f:	83 c0 04             	add    $0x4,%eax
        return va_arg(*ap, unsigned long);
  104672:	31 db                	xor    %ebx,%ebx
  104674:	ba 10 00 00 00       	mov    $0x10,%edx
  104679:	8b 09                	mov    (%ecx),%ecx
  10467b:	89 44 24 5c          	mov    %eax,0x5c(%esp)
  10467f:	e9 84 fe ff ff       	jmp    104508 <.L23+0x2a>

00104684 <.L26>:
            putch(va_arg(ap, int), putdat);
  104684:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  104688:	8b 74 24 50          	mov    0x50(%esp),%esi
  10468c:	83 ec 08             	sub    $0x8,%esp
  10468f:	55                   	push   %ebp
  104690:	8d 58 04             	lea    0x4(%eax),%ebx
  104693:	8b 44 24 68          	mov    0x68(%esp),%eax
  104697:	ff 30                	push   (%eax)
  104699:	ff d6                	call   *%esi
  10469b:	89 5c 24 6c          	mov    %ebx,0x6c(%esp)
            break;
  10469f:	83 c4 10             	add    $0x10,%esp
  1046a2:	e9 14 fd ff ff       	jmp    1043bb <vprintfmt+0x2b>

001046a7 <.L25>:
    if (lflag >= 2)
  1046a7:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
  1046ac:	8b 74 24 50          	mov    0x50(%esp),%esi
        return va_arg(*ap, long long);
  1046b0:	8b 44 24 5c          	mov    0x5c(%esp),%eax
    if (lflag >= 2)
  1046b4:	0f 8f 87 00 00 00    	jg     104741 <.L24+0x67>
        return va_arg(*ap, long);
  1046ba:	8b 00                	mov    (%eax),%eax
            precision = va_arg(ap, int);
  1046bc:	83 44 24 5c 04       	addl   $0x4,0x5c(%esp)
        return va_arg(*ap, long);
  1046c1:	89 c3                	mov    %eax,%ebx
  1046c3:	89 c1                	mov    %eax,%ecx
  1046c5:	c1 fb 1f             	sar    $0x1f,%ebx
            if ((long long) num < 0) {
  1046c8:	85 db                	test   %ebx,%ebx
  1046ca:	0f 88 82 00 00 00    	js     104752 <.L24+0x78>
        return va_arg(*ap, unsigned long long);
  1046d0:	ba 0a 00 00 00       	mov    $0xa,%edx
  1046d5:	e9 2e fe ff ff       	jmp    104508 <.L23+0x2a>

001046da <.L24>:
            lflag++;
  1046da:	83 44 24 20 01       	addl   $0x1,0x20(%esp)
        switch (ch = *(unsigned char *) fmt++) {
  1046df:	89 fb                	mov    %edi,%ebx
            goto reswitch;
  1046e1:	e9 3c fd ff ff       	jmp    104422 <vprintfmt+0x92>
  1046e6:	89 7c 24 10          	mov    %edi,0x10(%esp)
  1046ea:	8b 74 24 50          	mov    0x50(%esp),%esi
  1046ee:	8b 7c 24 58          	mov    0x58(%esp),%edi
            for (; width > 0; width--)
  1046f2:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1046f6:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  1046fa:	85 c9                	test   %ecx,%ecx
  1046fc:	7e 12                	jle    104710 <.L24+0x36>
  1046fe:	66 90                	xchg   %ax,%ax
                putch(' ', putdat);
  104700:	83 ec 08             	sub    $0x8,%esp
  104703:	55                   	push   %ebp
  104704:	6a 20                	push   $0x20
  104706:	ff d6                	call   *%esi
            for (; width > 0; width--)
  104708:	83 c4 10             	add    $0x10,%esp
  10470b:	83 eb 01             	sub    $0x1,%ebx
  10470e:	75 f0                	jne    104700 <.L24+0x26>
            if ((p = va_arg(ap, char *)) == NULL)
  104710:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  104714:	89 44 24 5c          	mov    %eax,0x5c(%esp)
  104718:	e9 9e fc ff ff       	jmp    1043bb <vprintfmt+0x2b>
        return va_arg(*ap, unsigned long long);
  10471d:	8b 08                	mov    (%eax),%ecx
  10471f:	8b 58 04             	mov    0x4(%eax),%ebx
  104722:	83 c0 08             	add    $0x8,%eax
  104725:	89 44 24 5c          	mov    %eax,0x5c(%esp)
  104729:	eb a5                	jmp    1046d0 <.L25+0x29>
  10472b:	8b 08                	mov    (%eax),%ecx
  10472d:	8b 58 04             	mov    0x4(%eax),%ebx
  104730:	83 c0 08             	add    $0x8,%eax
  104733:	ba 10 00 00 00       	mov    $0x10,%edx
  104738:	89 44 24 5c          	mov    %eax,0x5c(%esp)
  10473c:	e9 c7 fd ff ff       	jmp    104508 <.L23+0x2a>
        return va_arg(*ap, long long);
  104741:	8b 08                	mov    (%eax),%ecx
  104743:	8b 58 04             	mov    0x4(%eax),%ebx
  104746:	83 c0 08             	add    $0x8,%eax
  104749:	89 44 24 5c          	mov    %eax,0x5c(%esp)
  10474d:	e9 76 ff ff ff       	jmp    1046c8 <.L25+0x21>
  104752:	89 4c 24 08          	mov    %ecx,0x8(%esp)
                putch('-', putdat);
  104756:	83 ec 08             	sub    $0x8,%esp
  104759:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  10475d:	55                   	push   %ebp
  10475e:	6a 2d                	push   $0x2d
  104760:	ff d6                	call   *%esi
                num = -(long long) num;
  104762:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  104766:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  10476a:	ba 0a 00 00 00       	mov    $0xa,%edx
  10476f:	f7 d9                	neg    %ecx
  104771:	83 d3 00             	adc    $0x0,%ebx
  104774:	83 c4 10             	add    $0x10,%esp
  104777:	f7 db                	neg    %ebx
  104779:	e9 8a fd ff ff       	jmp    104508 <.L23+0x2a>

0010477e <.L58>:
            padc = '-';
  10477e:	c6 44 24 18 2d       	movb   $0x2d,0x18(%esp)
        switch (ch = *(unsigned char *) fmt++) {
  104783:	89 fb                	mov    %edi,%ebx
  104785:	e9 98 fc ff ff       	jmp    104422 <vprintfmt+0x92>

0010478a <.L28>:
  10478a:	c6 44 24 18 30       	movb   $0x30,0x18(%esp)
  10478f:	89 fb                	mov    %edi,%ebx
  104791:	e9 8c fc ff ff       	jmp    104422 <vprintfmt+0x92>
            if (width > 0 && padc != '-')
  104796:	84 c0                	test   %al,%al
  104798:	0f 85 9f 00 00 00    	jne    10483d <.L28+0xb3>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  10479e:	8b 44 24 14          	mov    0x14(%esp),%eax
  1047a2:	89 74 24 50          	mov    %esi,0x50(%esp)
  1047a6:	b9 28 00 00 00       	mov    $0x28,%ecx
  1047ab:	89 d6                	mov    %edx,%esi
  1047ad:	89 7c 24 58          	mov    %edi,0x58(%esp)
  1047b1:	8b 7c 24 10          	mov    0x10(%esp),%edi
  1047b5:	8d 98 38 92 ff ff    	lea    -0x6dc8(%eax),%ebx
  1047bb:	b8 28 00 00 00       	mov    $0x28,%eax
  1047c0:	e9 44 fe ff ff       	jmp    104609 <.L22+0x8b>
                for (width -= strnlen(p, precision); width > 0; width--)
  1047c5:	83 ec 08             	sub    $0x8,%esp
  1047c8:	52                   	push   %edx
  1047c9:	89 54 24 38          	mov    %edx,0x38(%esp)
  1047cd:	51                   	push   %ecx
  1047ce:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  1047d2:	89 4c 24 38          	mov    %ecx,0x38(%esp)
  1047d6:	e8 95 f6 ff ff       	call   103e70 <strnlen>
  1047db:	29 44 24 20          	sub    %eax,0x20(%esp)
  1047df:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  1047e3:	83 c4 10             	add    $0x10,%esp
  1047e6:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  1047ea:	85 c9                	test   %ecx,%ecx
  1047ec:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  1047f0:	7e 34                	jle    104826 <.L28+0x9c>
                    putch(padc, putdat);
  1047f2:	0f be 5c 24 18       	movsbl 0x18(%esp),%ebx
  1047f7:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  1047fb:	89 54 24 18          	mov    %edx,0x18(%esp)
  1047ff:	89 7c 24 58          	mov    %edi,0x58(%esp)
  104803:	8b 7c 24 10          	mov    0x10(%esp),%edi
  104807:	83 ec 08             	sub    $0x8,%esp
  10480a:	55                   	push   %ebp
  10480b:	53                   	push   %ebx
  10480c:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
  10480e:	83 c4 10             	add    $0x10,%esp
  104811:	83 ef 01             	sub    $0x1,%edi
  104814:	75 f1                	jne    104807 <.L28+0x7d>
  104816:	8b 54 24 18          	mov    0x18(%esp),%edx
  10481a:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  10481e:	89 7c 24 10          	mov    %edi,0x10(%esp)
  104822:	8b 7c 24 58          	mov    0x58(%esp),%edi
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  104826:	0f be 01             	movsbl (%ecx),%eax
  104829:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  10482d:	0f be c8             	movsbl %al,%ecx
  104830:	85 c9                	test   %ecx,%ecx
  104832:	0f 85 96 fd ff ff    	jne    1045ce <.L22+0x50>
  104838:	e9 d3 fe ff ff       	jmp    104710 <.L24+0x36>
                for (width -= strnlen(p, precision); width > 0; width--)
  10483d:	83 ec 08             	sub    $0x8,%esp
  104840:	52                   	push   %edx
  104841:	89 54 24 34          	mov    %edx,0x34(%esp)
  104845:	ff 74 24 30          	push   0x30(%esp)
  104849:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  10484d:	e8 1e f6 ff ff       	call   103e70 <strnlen>
  104852:	29 44 24 20          	sub    %eax,0x20(%esp)
  104856:	8b 44 24 20          	mov    0x20(%esp),%eax
  10485a:	83 c4 10             	add    $0x10,%esp
                p = "(null)";
  10485d:	8b 54 24 24          	mov    0x24(%esp),%edx
  104861:	89 d1                	mov    %edx,%ecx
  104863:	83 c2 01             	add    $0x1,%edx
                for (width -= strnlen(p, precision); width > 0; width--)
  104866:	85 c0                	test   %eax,%eax
  104868:	89 54 24 20          	mov    %edx,0x20(%esp)
  10486c:	8b 54 24 28          	mov    0x28(%esp),%edx
  104870:	7f 80                	jg     1047f2 <.L28+0x68>
  104872:	89 74 24 50          	mov    %esi,0x50(%esp)
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  104876:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  10487a:	b9 28 00 00 00       	mov    $0x28,%ecx
  10487f:	89 d6                	mov    %edx,%esi
  104881:	89 7c 24 58          	mov    %edi,0x58(%esp)
  104885:	b8 28 00 00 00       	mov    $0x28,%eax
  10488a:	8b 7c 24 10          	mov    0x10(%esp),%edi
  10488e:	e9 76 fd ff ff       	jmp    104609 <.L22+0x8b>

00104893 <__x86.get_pc_thunk.cx>:
  104893:	8b 0c 24             	mov    (%esp),%ecx
  104896:	c3                   	ret    
  104897:	66 90                	xchg   %ax,%ax
  104899:	66 90                	xchg   %ax,%ax
  10489b:	66 90                	xchg   %ax,%ax
  10489d:	66 90                	xchg   %ax,%ax
  10489f:	90                   	nop

001048a0 <kstack_switch>:
#include "seg.h"

#define offsetof(type, member) __builtin_offsetof(type, member)

void kstack_switch(uint32_t pid)
{
  1048a0:	56                   	push   %esi
  1048a1:	53                   	push   %ebx
  1048a2:	e8 e2 ba ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1048a7:	81 c3 59 c7 00 00    	add    $0xc759,%ebx
  1048ad:	83 ec 04             	sub    $0x4,%esp
    int cpu_idx = get_pcpu_idx();
  1048b0:	e8 9b 15 00 00       	call   105e50 <get_pcpu_idx>
    struct kstack *ks = (struct kstack *) get_pcpu_kstack_pointer(cpu_idx);
  1048b5:	83 ec 0c             	sub    $0xc,%esp
  1048b8:	50                   	push   %eax
  1048b9:	e8 f2 15 00 00       	call   105eb0 <get_pcpu_kstack_pointer>

    /*
     * Switch to the new TSS.
     */
    ks->tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  1048be:	8b 74 24 20          	mov    0x20(%esp),%esi
  1048c2:	c7 c1 00 a0 13 00    	mov    $0x13a000,%ecx
  1048c8:	8d 56 01             	lea    0x1(%esi),%edx
  1048cb:	c1 e2 0c             	shl    $0xc,%edx
  1048ce:	8d 34 0a             	lea    (%edx,%ecx,1),%esi
    ks->tss.ts_ss0 = CPU_GDT_KDATA;
    ks->gdt[CPU_GDT_TSS >> 3] =
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  1048d1:	8d 94 0a 30 f0 ff ff 	lea    -0xfd0(%edx,%ecx,1),%edx
    ks->gdt[CPU_GDT_TSS >> 3] =
  1048d8:	b9 eb 00 00 00       	mov    $0xeb,%ecx
    ks->tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  1048dd:	89 70 34             	mov    %esi,0x34(%eax)
    ks->tss.ts_ss0 = CPU_GDT_KDATA;
  1048e0:	be 10 00 00 00       	mov    $0x10,%esi
    ks->gdt[CPU_GDT_TSS >> 3] =
  1048e5:	66 89 48 28          	mov    %cx,0x28(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  1048e9:	89 d1                	mov    %edx,%ecx
    ks->tss.ts_ss0 = CPU_GDT_KDATA;
  1048eb:	66 89 70 38          	mov    %si,0x38(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  1048ef:	c1 e9 10             	shr    $0x10,%ecx
    ks->gdt[CPU_GDT_TSS >> 3] =
  1048f2:	be 89 40 00 00       	mov    $0x4089,%esi
  1048f7:	66 89 50 2a          	mov    %dx,0x2a(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  1048fb:	c1 ea 18             	shr    $0x18,%edx
    ks->gdt[CPU_GDT_TSS >> 3] =
  1048fe:	66 89 70 2d          	mov    %si,0x2d(%eax)
  104902:	88 48 2c             	mov    %cl,0x2c(%eax)
  104905:	88 50 2f             	mov    %dl,0x2f(%eax)
    ks->gdt[CPU_GDT_TSS >> 3].sd_s = 0;
    ltr(CPU_GDT_TSS);
  104908:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
  10490f:	e8 cc 04 00 00       	call   104de0 <ltr>
}
  104914:	83 c4 14             	add    $0x14,%esp
  104917:	5b                   	pop    %ebx
  104918:	5e                   	pop    %esi
  104919:	c3                   	ret    
  10491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104920 <seg_init>:

void seg_init(int cpu_idx)
{
  104920:	55                   	push   %ebp
  104921:	57                   	push   %edi
  104922:	56                   	push   %esi
  104923:	53                   	push   %ebx
  104924:	e8 60 ba ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104929:	81 c3 d7 c6 00 00    	add    $0xc6d7,%ebx
  10492f:	83 ec 2c             	sub    $0x2c,%esp
  104932:	8b 7c 24 40          	mov    0x40(%esp),%edi
  104936:	c7 c6 00 a0 17 00    	mov    $0x17a000,%esi
    /* clear BSS */
    if (cpu_idx == 0) {
  10493c:	85 ff                	test   %edi,%edi
  10493e:	0f 84 1c 01 00 00    	je     104a60 <seg_init+0x140>
    /* 0x20: user data */
    bsp_kstack[cpu_idx].gdt[CPU_GDT_UDATA >> 3] =
        SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);

    /* setup TSS */
    bsp_kstack[cpu_idx].tss.ts_esp0 = (uint32_t) bsp_kstack[cpu_idx].kstack_hi;
  104944:	8d 57 01             	lea    0x1(%edi),%edx
  104947:	89 f8                	mov    %edi,%eax
    bsp_kstack[cpu_idx].tss.ts_ss0 = CPU_GDT_KDATA;
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104949:	bd eb 00 00 00       	mov    $0xeb,%ebp
  10494e:	c1 e2 0c             	shl    $0xc,%edx
    bsp_kstack[cpu_idx].tss.ts_esp0 = (uint32_t) bsp_kstack[cpu_idx].kstack_hi;
  104951:	c1 e0 0c             	shl    $0xc,%eax
  104954:	01 f0                	add    %esi,%eax
  104956:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
        SEGDESC16(STS_T32A, (uint32_t) &bsp_kstack[cpu_idx].tss, sizeof(tss_t) - 1, 0);
  104959:	89 54 24 0c          	mov    %edx,0xc(%esp)
    bsp_kstack[cpu_idx].tss.ts_esp0 = (uint32_t) bsp_kstack[cpu_idx].kstack_hi;
  10495d:	89 48 34             	mov    %ecx,0x34(%eax)
    bsp_kstack[cpu_idx].tss.ts_ss0 = CPU_GDT_KDATA;
  104960:	b9 10 00 00 00       	mov    $0x10,%ecx
  104965:	66 89 48 38          	mov    %cx,0x38(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &bsp_kstack[cpu_idx].tss, sizeof(tss_t) - 1, 0);
  104969:	8d 8c 16 30 f0 ff ff 	lea    -0xfd0(%esi,%edx,1),%ecx
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104970:	66 89 68 28          	mov    %bp,0x28(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &bsp_kstack[cpu_idx].tss, sizeof(tss_t) - 1, 0);
  104974:	89 cd                	mov    %ecx,%ebp
  104976:	c1 ed 10             	shr    $0x10,%ebp
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104979:	66 89 48 2a          	mov    %cx,0x2a(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &bsp_kstack[cpu_idx].tss, sizeof(tss_t) - 1, 0);
  10497d:	c1 e9 18             	shr    $0x18,%ecx
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104980:	89 ea                	mov    %ebp,%edx
    bsp_kstack[cpu_idx].gdt[0] = SEGDESC_NULL;
  104982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104988:	88 50 2c             	mov    %dl,0x2c(%eax)
  10498b:	8b 68 2c             	mov    0x2c(%eax),%ebp
    /* Set the KSTACK_MAGIC value when we initialize the kstack */
    bsp_kstack[cpu_idx].magic = KSTACK_MAGIC;

    pseudodesc_t gdt_desc = {
        .pd_lim   = sizeof(bsp_kstack[cpu_idx].gdt) - 1,
        .pd_base  = (uint32_t) bsp_kstack[cpu_idx].gdt
  10498e:	8b 54 24 0c          	mov    0xc(%esp),%edx
    bsp_kstack[cpu_idx].gdt[0] = SEGDESC_NULL;
  104992:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104999:	81 e5 ff 10 c0 ff    	and    $0xffc010ff,%ebp
    bsp_kstack[cpu_idx].gdt[CPU_GDT_KCODE >> 3] =
  10499f:	c7 40 08 ff ff 00 00 	movl   $0xffff,0x8(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  1049a6:	81 cd 00 89 00 00    	or     $0x8900,%ebp
    bsp_kstack[cpu_idx].gdt[CPU_GDT_KCODE >> 3] =
  1049ac:	c7 40 0c 00 9a cf 00 	movl   $0xcf9a00,0xc(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  1049b3:	89 68 2c             	mov    %ebp,0x2c(%eax)
  1049b6:	88 48 2f             	mov    %cl,0x2f(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3].sd_s = 0;
  1049b9:	8b 48 2c             	mov    0x2c(%eax),%ecx
    bsp_kstack[cpu_idx].gdt[CPU_GDT_KDATA >> 3] =
  1049bc:	c7 40 10 ff ff 00 00 	movl   $0xffff,0x10(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3].sd_s = 0;
  1049c3:	81 e1 ff ef 3f ff    	and    $0xff3fefff,%ecx
    bsp_kstack[cpu_idx].gdt[CPU_GDT_KDATA >> 3] =
  1049c9:	c7 40 14 00 92 cf 00 	movl   $0xcf9200,0x14(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3].sd_s = 0;
  1049d0:	81 c9 00 00 40 00    	or     $0x400000,%ecx
    bsp_kstack[cpu_idx].gdt[CPU_GDT_UCODE >> 3] =
  1049d6:	c7 40 18 ff ff 00 00 	movl   $0xffff,0x18(%eax)
  1049dd:	c7 40 1c 00 fa cf 00 	movl   $0xcffa00,0x1c(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_UDATA >> 3] =
  1049e4:	c7 40 20 ff ff 00 00 	movl   $0xffff,0x20(%eax)
  1049eb:	c7 40 24 00 f2 cf 00 	movl   $0xcff200,0x24(%eax)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3].sd_s = 0;
  1049f2:	89 48 2c             	mov    %ecx,0x2c(%eax)
    bsp_kstack[cpu_idx].magic = KSTACK_MAGIC;
  1049f5:	c7 80 20 01 00 00 32 	movl   $0x98765432,0x120(%eax)
  1049fc:	54 76 98 
    pseudodesc_t gdt_desc = {
  1049ff:	b8 2f 00 00 00       	mov    $0x2f,%eax
  104a04:	66 89 44 24 1a       	mov    %ax,0x1a(%esp)
        .pd_base  = (uint32_t) bsp_kstack[cpu_idx].gdt
  104a09:	8d 84 16 00 f0 ff ff 	lea    -0x1000(%esi,%edx,1),%eax
  104a10:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    };
    asm volatile ("lgdt %0" :: "m" (gdt_desc));
  104a14:	0f 01 54 24 1a       	lgdtl  0x1a(%esp)
    asm volatile ("movw %%ax,%%gs" :: "a" (CPU_GDT_KDATA));
  104a19:	b8 10 00 00 00       	mov    $0x10,%eax
  104a1e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax,%%fs" :: "a" (CPU_GDT_KDATA));
  104a20:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax,%%es" :: "a" (CPU_GDT_KDATA));
  104a22:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax,%%ds" :: "a" (CPU_GDT_KDATA));
  104a24:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax,%%ss" :: "a" (CPU_GDT_KDATA));
  104a26:	8e d0                	mov    %eax,%ss
    /* reload %cs */
    asm volatile ("ljmp %0,$1f\n 1:\n" :: "i" (CPU_GDT_KCODE));
  104a28:	ea 2f 4a 10 00 08 00 	ljmp   $0x8,$0x104a2f

    /*
     * Load a null LDT.
     */
    lldt(0);
  104a2f:	83 ec 0c             	sub    $0xc,%esp
  104a32:	6a 00                	push   $0x0
  104a34:	e8 17 02 00 00       	call   104c50 <lldt>

    /*
     * Load the bootstrap TSS.
     */
    ltr(CPU_GDT_TSS);
  104a39:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
  104a40:	e8 9b 03 00 00       	call   104de0 <ltr>

    /*
     * Load IDT.
     */
    extern pseudodesc_t idt_pd;
    asm volatile ("lidt %0" :: "m" (idt_pd));
  104a45:	c7 c0 20 13 11 00    	mov    $0x111320,%eax
  104a4b:	0f 01 18             	lidtl  (%eax)

    /*
     * Initialize all TSS structures for processes.
     */
    if (cpu_idx == 0) {
  104a4e:	83 c4 10             	add    $0x10,%esp
  104a51:	85 ff                	test   %edi,%edi
  104a53:	74 4b                	je     104aa0 <seg_init+0x180>
        memzero(&bsp_kstack[1], sizeof(struct kstack) * 7);
        memzero(proc_kstack, sizeof(struct kstack) * 64);
    }
}
  104a55:	83 c4 2c             	add    $0x2c,%esp
  104a58:	5b                   	pop    %ebx
  104a59:	5e                   	pop    %esi
  104a5a:	5f                   	pop    %edi
  104a5b:	5d                   	pop    %ebp
  104a5c:	c3                   	ret    
  104a5d:	8d 76 00             	lea    0x0(%esi),%esi
        memzero(edata, ((uint8_t *) &bsp_kstack[0]) - edata);
  104a60:	c7 c0 3a 7d 13 00    	mov    $0x137d3a,%eax
  104a66:	89 f2                	mov    %esi,%edx
  104a68:	83 ec 08             	sub    $0x8,%esp
  104a6b:	29 c2                	sub    %eax,%edx
  104a6d:	52                   	push   %edx
  104a6e:	50                   	push   %eax
  104a6f:	e8 bc f4 ff ff       	call   103f30 <memzero>
        memzero(((uint8_t *) &bsp_kstack[0]) + 4096, end - ((uint8_t *) &bsp_kstack[0]) - 4096);
  104a74:	58                   	pop    %eax
  104a75:	c7 c0 e4 6d e0 00    	mov    $0xe06de4,%eax
  104a7b:	5a                   	pop    %edx
  104a7c:	29 f0                	sub    %esi,%eax
  104a7e:	2d 00 10 00 00       	sub    $0x1000,%eax
  104a83:	50                   	push   %eax
  104a84:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
  104a8a:	50                   	push   %eax
  104a8b:	e8 a0 f4 ff ff       	call   103f30 <memzero>
  104a90:	83 c4 10             	add    $0x10,%esp
  104a93:	e9 ac fe ff ff       	jmp    104944 <seg_init+0x24>
  104a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104a9f:	90                   	nop
        memzero(&bsp_kstack[1], sizeof(struct kstack) * 7);
  104aa0:	83 ec 08             	sub    $0x8,%esp
  104aa3:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
  104aa9:	68 00 70 00 00       	push   $0x7000
  104aae:	50                   	push   %eax
  104aaf:	e8 7c f4 ff ff       	call   103f30 <memzero>
        memzero(proc_kstack, sizeof(struct kstack) * 64);
  104ab4:	58                   	pop    %eax
  104ab5:	5a                   	pop    %edx
  104ab6:	68 00 00 04 00       	push   $0x40000
  104abb:	ff b3 f4 ff ff ff    	push   -0xc(%ebx)
  104ac1:	e8 6a f4 ff ff       	call   103f30 <memzero>
  104ac6:	83 c4 10             	add    $0x10,%esp
}
  104ac9:	83 c4 2c             	add    $0x2c,%esp
  104acc:	5b                   	pop    %ebx
  104acd:	5e                   	pop    %esi
  104ace:	5f                   	pop    %edi
  104acf:	5d                   	pop    %ebp
  104ad0:	c3                   	ret    
  104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104adf:	90                   	nop

00104ae0 <seg_init_proc>:

/* initialize the kernel stack for each process */
void seg_init_proc(int cpu_idx, int pid)
{
  104ae0:	55                   	push   %ebp
        SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);

    /* setup TSS */
    proc_kstack[pid].tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
    proc_kstack[pid].tss.ts_ss0 = CPU_GDT_KDATA;
    proc_kstack[pid].tss.ts_iomb = offsetof(tss_t, ts_iopm);
  104ae1:	ba 68 00 00 00       	mov    $0x68,%edx
{
  104ae6:	57                   	push   %edi
  104ae7:	56                   	push   %esi
  104ae8:	53                   	push   %ebx
  104ae9:	e8 9b b8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104aee:	81 c3 12 c5 00 00    	add    $0xc512,%ebx
  104af4:	83 ec 14             	sub    $0x14,%esp
  104af7:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  104afb:	89 fe                	mov    %edi,%esi
  104afd:	83 c7 01             	add    $0x1,%edi
  104b00:	c7 c5 00 a0 13 00    	mov    $0x13a000,%ebp
  104b06:	c1 e7 0c             	shl    $0xc,%edi
  104b09:	c1 e6 0c             	shl    $0xc,%esi
  104b0c:	01 ee                	add    %ebp,%esi
    proc_kstack[pid].tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  104b0e:	8d 04 2f             	lea    (%edi,%ebp,1),%eax
  104b11:	89 46 34             	mov    %eax,0x34(%esi)
    proc_kstack[pid].tss.ts_ss0 = CPU_GDT_KDATA;
  104b14:	b8 10 00 00 00       	mov    $0x10,%eax
  104b19:	66 89 46 38          	mov    %ax,0x38(%esi)
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  104b1d:	8d 84 2f 98 f0 ff ff 	lea    -0xf68(%edi,%ebp,1),%eax
    proc_kstack[pid].tss.ts_iomb = offsetof(tss_t, ts_iopm);
  104b24:	66 89 96 96 00 00 00 	mov    %dx,0x96(%esi)
    proc_kstack[pid].gdt[0] = SEGDESC_NULL;
  104b2b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  104b31:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    proc_kstack[pid].gdt[CPU_GDT_KCODE >> 3] =
  104b38:	c7 46 08 ff ff 00 00 	movl   $0xffff,0x8(%esi)
  104b3f:	c7 46 0c 00 9a cf 00 	movl   $0xcf9a00,0xc(%esi)
    proc_kstack[pid].gdt[CPU_GDT_KDATA >> 3] =
  104b46:	c7 46 10 ff ff 00 00 	movl   $0xffff,0x10(%esi)
  104b4d:	c7 46 14 00 92 cf 00 	movl   $0xcf9200,0x14(%esi)
    proc_kstack[pid].gdt[CPU_GDT_UCODE >> 3] =
  104b54:	c7 46 18 ff ff 00 00 	movl   $0xffff,0x18(%esi)
  104b5b:	c7 46 1c 00 fa cf 00 	movl   $0xcffa00,0x1c(%esi)
    proc_kstack[pid].gdt[CPU_GDT_UDATA >> 3] =
  104b62:	c7 46 20 ff ff 00 00 	movl   $0xffff,0x20(%esi)
  104b69:	c7 46 24 00 f2 cf 00 	movl   $0xcff200,0x24(%esi)
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  104b70:	68 80 00 00 00       	push   $0x80
  104b75:	50                   	push   %eax
  104b76:	e8 b5 f3 ff ff       	call   103f30 <memzero>
    proc_kstack[pid].tss.ts_iopm[128] = 0xff;

    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  104b7b:	bb 89 40 00 00       	mov    $0x4089,%ebx
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  104b80:	8d 84 2f 30 f0 ff ff 	lea    -0xfd0(%edi,%ebp,1),%eax
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  104b87:	b9 eb 00 00 00       	mov    $0xeb,%ecx
  104b8c:	66 89 46 2a          	mov    %ax,0x2a(%esi)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  104b90:	89 c2                	mov    %eax,%edx
  104b92:	c1 e8 18             	shr    $0x18,%eax
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  104b95:	88 46 2f             	mov    %al,0x2f(%esi)
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3].sd_s = 0;

    /* other fields */
    proc_kstack[pid].magic = KSTACK_MAGIC;
    proc_kstack[pid].cpu_idx = cpu_idx;
  104b98:	8b 44 24 30          	mov    0x30(%esp),%eax
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  104b9c:	c1 ea 10             	shr    $0x10,%edx
    proc_kstack[pid].tss.ts_iopm[128] = 0xff;
  104b9f:	c6 86 18 01 00 00 ff 	movb   $0xff,0x118(%esi)
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  104ba6:	66 89 4e 28          	mov    %cx,0x28(%esi)
  104baa:	88 56 2c             	mov    %dl,0x2c(%esi)
  104bad:	66 89 5e 2d          	mov    %bx,0x2d(%esi)
    proc_kstack[pid].magic = KSTACK_MAGIC;
  104bb1:	c7 86 20 01 00 00 32 	movl   $0x98765432,0x120(%esi)
  104bb8:	54 76 98 
    proc_kstack[pid].cpu_idx = cpu_idx;
  104bbb:	89 86 1c 01 00 00    	mov    %eax,0x11c(%esi)
}
  104bc1:	83 c4 1c             	add    $0x1c,%esp
  104bc4:	5b                   	pop    %ebx
  104bc5:	5e                   	pop    %esi
  104bc6:	5f                   	pop    %edi
  104bc7:	5d                   	pop    %ebp
  104bc8:	c3                   	ret    
  104bc9:	66 90                	xchg   %ax,%ax
  104bcb:	66 90                	xchg   %ax,%ax
  104bcd:	66 90                	xchg   %ax,%ax
  104bcf:	90                   	nop

00104bd0 <max>:
#include "types.h"

uint32_t max(uint32_t a, uint32_t b)
{
  104bd0:	8b 44 24 08          	mov    0x8(%esp),%eax
    return (a > b) ? a : b;
  104bd4:	8b 54 24 04          	mov    0x4(%esp),%edx
  104bd8:	39 d0                	cmp    %edx,%eax
  104bda:	0f 42 c2             	cmovb  %edx,%eax
}
  104bdd:	c3                   	ret    
  104bde:	66 90                	xchg   %ax,%ax

00104be0 <min>:

uint32_t min(uint32_t a, uint32_t b)
{
  104be0:	8b 44 24 08          	mov    0x8(%esp),%eax
    return (a < b) ? a : b;
  104be4:	8b 54 24 04          	mov    0x4(%esp),%edx
  104be8:	39 d0                	cmp    %edx,%eax
  104bea:	0f 47 c2             	cmova  %edx,%eax
}
  104bed:	c3                   	ret    
  104bee:	66 90                	xchg   %ax,%ax

00104bf0 <rounddown>:

uint32_t rounddown(uint32_t a, uint32_t n)
{
  104bf0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    return a - a % n;
  104bf4:	31 d2                	xor    %edx,%edx
  104bf6:	89 c8                	mov    %ecx,%eax
  104bf8:	f7 74 24 08          	divl   0x8(%esp)
  104bfc:	89 c8                	mov    %ecx,%eax
  104bfe:	29 d0                	sub    %edx,%eax
}
  104c00:	c3                   	ret    
  104c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c0f:	90                   	nop

00104c10 <roundup>:

uint32_t roundup(uint32_t a, uint32_t n)
{
  104c10:	53                   	push   %ebx
  104c11:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
    return a - a % n;
  104c15:	31 d2                	xor    %edx,%edx
    return rounddown(a + n - 1, n);
  104c17:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  104c1a:	03 4c 24 08          	add    0x8(%esp),%ecx
    return a - a % n;
  104c1e:	89 c8                	mov    %ecx,%eax
  104c20:	f7 f3                	div    %ebx
  104c22:	89 c8                	mov    %ecx,%eax
}
  104c24:	5b                   	pop    %ebx
    return a - a % n;
  104c25:	29 d0                	sub    %edx,%eax
}
  104c27:	c3                   	ret    
  104c28:	66 90                	xchg   %ax,%ax
  104c2a:	66 90                	xchg   %ax,%ax
  104c2c:	66 90                	xchg   %ax,%ax
  104c2e:	66 90                	xchg   %ax,%ax

00104c30 <read_esp>:
#include "x86.h"

gcc_inline uintptr_t read_esp(void)
{
    uint32_t esp;
    __asm __volatile ("movl %%esp,%0" : "=rm" (esp));
  104c30:	89 e0                	mov    %esp,%eax
    return esp;
}
  104c32:	c3                   	ret    
  104c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c40 <read_ebp>:

gcc_inline uint32_t read_ebp(void)
{
    uint32_t ebp;
    __asm __volatile ("movl %%ebp,%0" : "=rm" (ebp));
  104c40:	89 e8                	mov    %ebp,%eax
    return ebp;
}
  104c42:	c3                   	ret    
  104c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c50 <lldt>:

gcc_inline void lldt(uint16_t sel)
{
    __asm __volatile ("lldt %0" :: "r" (sel));
  104c50:	0f b7 44 24 04       	movzwl 0x4(%esp),%eax
  104c55:	0f 00 d0             	lldt   %ax
}
  104c58:	c3                   	ret    
  104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104c60 <cli>:

gcc_inline void cli(void)
{
    __asm __volatile ("cli" ::: "memory");
  104c60:	fa                   	cli    
}
  104c61:	c3                   	ret    
  104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104c70 <sti>:

gcc_inline void sti(void)
{
    __asm __volatile ("sti; nop");
  104c70:	fb                   	sti    
  104c71:	90                   	nop
}
  104c72:	c3                   	ret    
  104c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c80 <rdmsr>:

gcc_inline uint64_t rdmsr(uint32_t msr)
{
    uint64_t rv;
    __asm __volatile ("rdmsr"
  104c80:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  104c84:	0f 32                	rdmsr  
                      : "=A" (rv)
                      : "c" (msr));
    return rv;
}
  104c86:	c3                   	ret    
  104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c8e:	66 90                	xchg   %ax,%ax

00104c90 <wrmsr>:

gcc_inline void wrmsr(uint32_t msr, uint64_t newval)
{
    __asm __volatile ("wrmsr" :: "A" (newval), "c" (msr));
  104c90:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  104c94:	8b 44 24 08          	mov    0x8(%esp),%eax
  104c98:	8b 54 24 0c          	mov    0xc(%esp),%edx
  104c9c:	0f 30                	wrmsr  
}
  104c9e:	c3                   	ret    
  104c9f:	90                   	nop

00104ca0 <halt>:

gcc_inline void halt(void)
{
    __asm __volatile ("hlt");
  104ca0:	f4                   	hlt    
}
  104ca1:	c3                   	ret    
  104ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104cb0 <pause>:

gcc_inline void pause(void)
{
    __asm __volatile ("pause" ::: "memory");
  104cb0:	f3 90                	pause  
}
  104cb2:	c3                   	ret    
  104cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104cc0 <xchg>:

gcc_inline uint32_t xchg(volatile uint32_t *addr, uint32_t newval)
{
  104cc0:	8b 54 24 04          	mov    0x4(%esp),%edx
    uint32_t result;

    __asm __volatile ("lock; xchgl %0, %1"
  104cc4:	8b 44 24 08          	mov    0x8(%esp),%eax
  104cc8:	f0 87 02             	lock xchg %eax,(%edx)
                      : "+m" (*addr), "=a" (result)
                      : "1" (newval)
                      : "cc");

    return result;
}
  104ccb:	c3                   	ret    
  104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104cd0 <cmpxchg>:

gcc_inline uint32_t cmpxchg(volatile uint32_t *addr, uint32_t oldval, uint32_t newval)
{
  104cd0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    uint32_t result;

    __asm __volatile ("lock; cmpxchgl %2, %0"
  104cd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  104cd8:	8b 54 24 0c          	mov    0xc(%esp),%edx
  104cdc:	f0 0f b1 11          	lock cmpxchg %edx,(%ecx)
                      : "+m" (*addr), "=a" (result)
                      : "r" (newval), "a" (oldval)
                      : "memory", "cc");

    return result;
}
  104ce0:	c3                   	ret    
  104ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104cef:	90                   	nop

00104cf0 <rdtsc>:

gcc_inline uint64_t rdtsc(void)
{
    uint64_t rv;

    __asm __volatile ("rdtsc" : "=A" (rv));
  104cf0:	0f 31                	rdtsc  
    return (rv);
}
  104cf2:	c3                   	ret    
  104cf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104d00 <enable_sse>:
}

gcc_inline uint32_t rcr4(void)
{
    uint32_t cr4;
    __asm __volatile ("movl %%cr4,%0" : "=r" (cr4));
  104d00:	0f 20 e0             	mov    %cr4,%eax
    FENCE();
  104d03:	0f ae f0             	mfence 
    cr4 = rcr4() | CR4_OSFXSR | CR4_OSXMMEXCPT;
  104d06:	80 cc 06             	or     $0x6,%ah
    __asm __volatile ("movl %0,%%cr4" :: "r" (val));
  104d09:	0f 22 e0             	mov    %eax,%cr4
    __asm __volatile ("movl %%cr0,%0" : "=r" (val));
  104d0c:	0f 20 c0             	mov    %cr0,%eax
    FENCE();
  104d0f:	0f ae f0             	mfence 
}
  104d12:	c3                   	ret    
  104d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104d20 <cpuid>:
{
  104d20:	55                   	push   %ebp
  104d21:	57                   	push   %edi
  104d22:	56                   	push   %esi
  104d23:	53                   	push   %ebx
  104d24:	8b 44 24 14          	mov    0x14(%esp),%eax
  104d28:	8b 74 24 18          	mov    0x18(%esp),%esi
  104d2c:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  104d30:	8b 6c 24 20          	mov    0x20(%esp),%ebp
    __asm __volatile ("cpuid"
  104d34:	0f a2                	cpuid  
    if (eaxp)
  104d36:	85 f6                	test   %esi,%esi
  104d38:	74 02                	je     104d3c <cpuid+0x1c>
        *eaxp = eax;
  104d3a:	89 06                	mov    %eax,(%esi)
    if (ebxp)
  104d3c:	85 ff                	test   %edi,%edi
  104d3e:	74 02                	je     104d42 <cpuid+0x22>
        *ebxp = ebx;
  104d40:	89 1f                	mov    %ebx,(%edi)
    if (ecxp)
  104d42:	85 ed                	test   %ebp,%ebp
  104d44:	74 03                	je     104d49 <cpuid+0x29>
        *ecxp = ecx;
  104d46:	89 4d 00             	mov    %ecx,0x0(%ebp)
    if (edxp)
  104d49:	8b 44 24 24          	mov    0x24(%esp),%eax
  104d4d:	85 c0                	test   %eax,%eax
  104d4f:	74 06                	je     104d57 <cpuid+0x37>
        *edxp = edx;
  104d51:	8b 44 24 24          	mov    0x24(%esp),%eax
  104d55:	89 10                	mov    %edx,(%eax)
}
  104d57:	5b                   	pop    %ebx
  104d58:	5e                   	pop    %esi
  104d59:	5f                   	pop    %edi
  104d5a:	5d                   	pop    %ebp
  104d5b:	c3                   	ret    
  104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104d60 <cpuid_subleaf>:
{
  104d60:	55                   	push   %ebp
  104d61:	57                   	push   %edi
  104d62:	56                   	push   %esi
  104d63:	53                   	push   %ebx
  104d64:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  104d68:	8b 7c 24 20          	mov    0x20(%esp),%edi
  104d6c:	8b 6c 24 24          	mov    0x24(%esp),%ebp
    asm volatile ("cpuid"
  104d70:	8b 44 24 14          	mov    0x14(%esp),%eax
  104d74:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  104d78:	0f a2                	cpuid  
    if (eaxp)
  104d7a:	85 f6                	test   %esi,%esi
  104d7c:	74 02                	je     104d80 <cpuid_subleaf+0x20>
        *eaxp = eax;
  104d7e:	89 06                	mov    %eax,(%esi)
    if (ebxp)
  104d80:	85 ff                	test   %edi,%edi
  104d82:	74 02                	je     104d86 <cpuid_subleaf+0x26>
        *ebxp = ebx;
  104d84:	89 1f                	mov    %ebx,(%edi)
    if (ecxp)
  104d86:	85 ed                	test   %ebp,%ebp
  104d88:	74 03                	je     104d8d <cpuid_subleaf+0x2d>
        *ecxp = ecx;
  104d8a:	89 4d 00             	mov    %ecx,0x0(%ebp)
    if (edxp)
  104d8d:	8b 44 24 28          	mov    0x28(%esp),%eax
  104d91:	85 c0                	test   %eax,%eax
  104d93:	74 06                	je     104d9b <cpuid_subleaf+0x3b>
        *edxp = edx;
  104d95:	8b 44 24 28          	mov    0x28(%esp),%eax
  104d99:	89 10                	mov    %edx,(%eax)
}
  104d9b:	5b                   	pop    %ebx
  104d9c:	5e                   	pop    %esi
  104d9d:	5f                   	pop    %edi
  104d9e:	5d                   	pop    %ebp
  104d9f:	c3                   	ret    

00104da0 <rcr3>:
    __asm __volatile ("movl %%cr3,%0" : "=r" (val));
  104da0:	0f 20 d8             	mov    %cr3,%eax
}
  104da3:	c3                   	ret    
  104da4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104daf:	90                   	nop

00104db0 <outl>:
    __asm __volatile ("outl %0,%w1" :: "a" (data), "d" (port));
  104db0:	8b 54 24 04          	mov    0x4(%esp),%edx
  104db4:	8b 44 24 08          	mov    0x8(%esp),%eax
  104db8:	ef                   	out    %eax,(%dx)
}
  104db9:	c3                   	ret    
  104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104dc0 <inl>:
    __asm __volatile ("inl %w1,%0" : "=a" (data) : "d" (port));
  104dc0:	8b 54 24 04          	mov    0x4(%esp),%edx
  104dc4:	ed                   	in     (%dx),%eax
}
  104dc5:	c3                   	ret    
  104dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104dcd:	8d 76 00             	lea    0x0(%esi),%esi

00104dd0 <smp_wmb>:
}
  104dd0:	c3                   	ret    
  104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104ddf:	90                   	nop

00104de0 <ltr>:
    __asm __volatile ("ltr %0" :: "r" (sel));
  104de0:	0f b7 44 24 04       	movzwl 0x4(%esp),%eax
  104de5:	0f 00 d8             	ltr    %ax
}
  104de8:	c3                   	ret    
  104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104df0 <lcr0>:
    __asm __volatile ("movl %0,%%cr0" :: "r" (val));
  104df0:	8b 44 24 04          	mov    0x4(%esp),%eax
  104df4:	0f 22 c0             	mov    %eax,%cr0
}
  104df7:	c3                   	ret    
  104df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104dff:	90                   	nop

00104e00 <rcr0>:
    __asm __volatile ("movl %%cr0,%0" : "=r" (val));
  104e00:	0f 20 c0             	mov    %cr0,%eax
}
  104e03:	c3                   	ret    
  104e04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104e0f:	90                   	nop

00104e10 <rcr2>:
    __asm __volatile ("movl %%cr2,%0" : "=r" (val));
  104e10:	0f 20 d0             	mov    %cr2,%eax
}
  104e13:	c3                   	ret    
  104e14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104e1f:	90                   	nop

00104e20 <lcr3>:
    __asm __volatile ("movl %0,%%cr3" :: "r" (val));
  104e20:	8b 44 24 04          	mov    0x4(%esp),%eax
  104e24:	0f 22 d8             	mov    %eax,%cr3
}
  104e27:	c3                   	ret    
  104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e2f:	90                   	nop

00104e30 <lcr4>:
    __asm __volatile ("movl %0,%%cr4" :: "r" (val));
  104e30:	8b 44 24 04          	mov    0x4(%esp),%eax
  104e34:	0f 22 e0             	mov    %eax,%cr4
}
  104e37:	c3                   	ret    
  104e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e3f:	90                   	nop

00104e40 <rcr4>:
    __asm __volatile ("movl %%cr4,%0" : "=r" (cr4));
  104e40:	0f 20 e0             	mov    %cr4,%eax
    return cr4;
}
  104e43:	c3                   	ret    
  104e44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104e4f:	90                   	nop

00104e50 <inb>:

gcc_inline uint8_t inb(int port)
{
    uint8_t data;
    __asm __volatile ("inb %w1,%0"
  104e50:	8b 54 24 04          	mov    0x4(%esp),%edx
  104e54:	ec                   	in     (%dx),%al
                      : "=a" (data)
                      : "d" (port));
    return data;
}
  104e55:	c3                   	ret    
  104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e5d:	8d 76 00             	lea    0x0(%esi),%esi

00104e60 <insl>:

gcc_inline void insl(int port, void *addr, int cnt)
{
  104e60:	57                   	push   %edi
    __asm __volatile ("cld\n\trepne\n\tinsl"
  104e61:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  104e65:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  104e69:	8b 54 24 08          	mov    0x8(%esp),%edx
  104e6d:	fc                   	cld    
  104e6e:	f2 6d                	repnz insl (%dx),%es:(%edi)
                      : "=D" (addr), "=c" (cnt)
                      : "d" (port), "0" (addr), "1" (cnt)
                      : "memory", "cc");
}
  104e70:	5f                   	pop    %edi
  104e71:	c3                   	ret    
  104e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104e80 <outb>:

gcc_inline void outb(int port, uint8_t data)
{
    __asm __volatile ("outb %0,%w1" :: "a" (data), "d" (port));
  104e80:	8b 54 24 04          	mov    0x4(%esp),%edx
  104e84:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
  104e89:	ee                   	out    %al,(%dx)
}
  104e8a:	c3                   	ret    
  104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104e8f:	90                   	nop

00104e90 <outsw>:

gcc_inline void outsw(int port, const void *addr, int cnt)
{
  104e90:	56                   	push   %esi
    __asm __volatile ("cld\n\trepne\n\toutsw"
  104e91:	8b 74 24 0c          	mov    0xc(%esp),%esi
  104e95:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  104e99:	8b 54 24 08          	mov    0x8(%esp),%edx
  104e9d:	fc                   	cld    
  104e9e:	f2 66 6f             	repnz outsw %ds:(%esi),(%dx)
                      : "=S" (addr), "=c" (cnt)
                      : "d" (port), "0" (addr), "1" (cnt)
                      : "cc");
}
  104ea1:	5e                   	pop    %esi
  104ea2:	c3                   	ret    
  104ea3:	66 90                	xchg   %ax,%ax
  104ea5:	66 90                	xchg   %ax,%ax
  104ea7:	66 90                	xchg   %ax,%ax
  104ea9:	66 90                	xchg   %ax,%ax
  104eab:	66 90                	xchg   %ax,%ax
  104ead:	66 90                	xchg   %ax,%ax
  104eaf:	90                   	nop

00104eb0 <mon_help>:

#define NCOMMANDS (sizeof(commands) / sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/
int mon_help(int argc, char **argv, struct Trapframe *tf)
{
  104eb0:	56                   	push   %esi
  104eb1:	53                   	push   %ebx
  104eb2:	e8 d2 b4 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104eb7:	81 c3 49 c1 00 00    	add    $0xc149,%ebx
  104ebd:	83 ec 08             	sub    $0x8,%esp
    int i;

    for (i = 0; i < NCOMMANDS; i++)
        dprintf("%s - %s\n", commands[i].name, commands[i].desc);
  104ec0:	8d 83 98 93 ff ff    	lea    -0x6c68(%ebx),%eax
  104ec6:	8d b3 bb 93 ff ff    	lea    -0x6c45(%ebx),%esi
  104ecc:	50                   	push   %eax
  104ecd:	8d 83 b6 93 ff ff    	lea    -0x6c4a(%ebx),%eax
  104ed3:	50                   	push   %eax
  104ed4:	56                   	push   %esi
  104ed5:	e8 66 f3 ff ff       	call   104240 <dprintf>
  104eda:	83 c4 0c             	add    $0xc,%esp
  104edd:	8d 83 60 94 ff ff    	lea    -0x6ba0(%ebx),%eax
  104ee3:	50                   	push   %eax
  104ee4:	8d 83 c4 93 ff ff    	lea    -0x6c3c(%ebx),%eax
  104eea:	50                   	push   %eax
  104eeb:	56                   	push   %esi
  104eec:	e8 4f f3 ff ff       	call   104240 <dprintf>
    return 0;
}
  104ef1:	83 c4 14             	add    $0x14,%esp
  104ef4:	31 c0                	xor    %eax,%eax
  104ef6:	5b                   	pop    %ebx
  104ef7:	5e                   	pop    %esi
  104ef8:	c3                   	ret    
  104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104f00 <mon_kerninfo>:

int mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
  104f00:	57                   	push   %edi
  104f01:	56                   	push   %esi
  104f02:	53                   	push   %ebx
  104f03:	e8 81 b4 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104f08:	81 c3 f8 c0 00 00    	add    $0xc0f8,%ebx
    extern uint8_t start[], etext[], edata[], end[];

    dprintf("Special kernel symbols:\n");
  104f0e:	83 ec 0c             	sub    $0xc,%esp
  104f11:	8d 83 cd 93 ff ff    	lea    -0x6c33(%ebx),%eax
  104f17:	50                   	push   %eax
  104f18:	e8 23 f3 ff ff       	call   104240 <dprintf>
    dprintf("  start  %08x\n", start);
  104f1d:	c7 c7 30 63 10 00    	mov    $0x106330,%edi
  104f23:	58                   	pop    %eax
  104f24:	8d 83 e6 93 ff ff    	lea    -0x6c1a(%ebx),%eax
  104f2a:	5a                   	pop    %edx
  104f2b:	57                   	push   %edi
  104f2c:	50                   	push   %eax
  104f2d:	e8 0e f3 ff ff       	call   104240 <dprintf>
    dprintf("  etext  %08x\n", etext);
  104f32:	8d 83 f5 93 ff ff    	lea    -0x6c0b(%ebx),%eax
  104f38:	59                   	pop    %ecx
  104f39:	5e                   	pop    %esi
  104f3a:	ff b3 f8 ff ff ff    	push   -0x8(%ebx)
  104f40:	50                   	push   %eax
  104f41:	e8 fa f2 ff ff       	call   104240 <dprintf>
    dprintf("  edata  %08x\n", edata);
  104f46:	58                   	pop    %eax
  104f47:	8d 83 04 94 ff ff    	lea    -0x6bfc(%ebx),%eax
  104f4d:	5a                   	pop    %edx
  104f4e:	ff b3 f0 ff ff ff    	push   -0x10(%ebx)
  104f54:	50                   	push   %eax
  104f55:	e8 e6 f2 ff ff       	call   104240 <dprintf>
    dprintf("  end    %08x\n", end);
  104f5a:	59                   	pop    %ecx
  104f5b:	5e                   	pop    %esi
  104f5c:	8d 83 13 94 ff ff    	lea    -0x6bed(%ebx),%eax
  104f62:	c7 c6 e4 6d e0 00    	mov    $0xe06de4,%esi
  104f68:	56                   	push   %esi
    dprintf("Kernel executable memory footprint: %dKB\n",
            ROUNDUP(end - start, 1024) / 1024);
  104f69:	29 fe                	sub    %edi,%esi
    dprintf("  end    %08x\n", end);
  104f6b:	50                   	push   %eax
  104f6c:	e8 cf f2 ff ff       	call   104240 <dprintf>
            ROUNDUP(end - start, 1024) / 1024);
  104f71:	8d 86 ff 03 00 00    	lea    0x3ff(%esi),%eax
    dprintf("Kernel executable memory footprint: %dKB\n",
  104f77:	5f                   	pop    %edi
  104f78:	5a                   	pop    %edx
            ROUNDUP(end - start, 1024) / 1024);
  104f79:	89 c1                	mov    %eax,%ecx
  104f7b:	c1 f9 1f             	sar    $0x1f,%ecx
  104f7e:	c1 e9 16             	shr    $0x16,%ecx
  104f81:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  104f84:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104f8a:	29 ca                	sub    %ecx,%edx
  104f8c:	29 d0                	sub    %edx,%eax
    dprintf("Kernel executable memory footprint: %dKB\n",
  104f8e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  104f94:	0f 48 c2             	cmovs  %edx,%eax
  104f97:	c1 f8 0a             	sar    $0xa,%eax
  104f9a:	50                   	push   %eax
  104f9b:	8d 83 88 94 ff ff    	lea    -0x6b78(%ebx),%eax
  104fa1:	50                   	push   %eax
  104fa2:	e8 99 f2 ff ff       	call   104240 <dprintf>
    return 0;
  104fa7:	83 c4 10             	add    $0x10,%esp
}
  104faa:	31 c0                	xor    %eax,%eax
  104fac:	5b                   	pop    %ebx
  104fad:	5e                   	pop    %esi
  104fae:	5f                   	pop    %edi
  104faf:	c3                   	ret    

00104fb0 <monitor>:
    dprintf("Unknown command '%s'\n", argv[0]);
    return 0;
}

void monitor(struct Trapframe *tf)
{
  104fb0:	55                   	push   %ebp
  104fb1:	57                   	push   %edi
  104fb2:	56                   	push   %esi
  104fb3:	53                   	push   %ebx
  104fb4:	e8 d0 b3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  104fb9:	81 c3 47 c0 00 00    	add    $0xc047,%ebx
  104fbf:	83 ec 68             	sub    $0x68,%esp
    char *buf;

    dprintf("\n****************************************\n\n");
  104fc2:	8d b3 b4 94 ff ff    	lea    -0x6b4c(%ebx),%esi
  104fc8:	56                   	push   %esi
  104fc9:	e8 72 f2 ff ff       	call   104240 <dprintf>
    dprintf("Welcome to the mCertiKOS kernel monitor!\n");
  104fce:	8d 83 e0 94 ff ff    	lea    -0x6b20(%ebx),%eax
  104fd4:	89 04 24             	mov    %eax,(%esp)
  104fd7:	e8 64 f2 ff ff       	call   104240 <dprintf>
    dprintf("\n****************************************\n\n");
  104fdc:	89 34 24             	mov    %esi,(%esp)
        while (*buf && strchr(WHITESPACE, *buf))
  104fdf:	8d b3 26 94 ff ff    	lea    -0x6bda(%ebx),%esi
    dprintf("\n****************************************\n\n");
  104fe5:	e8 56 f2 ff ff       	call   104240 <dprintf>
    dprintf("Type 'help' for a list of commands.\n");
  104fea:	8d 83 0c 95 ff ff    	lea    -0x6af4(%ebx),%eax
  104ff0:	89 04 24             	mov    %eax,(%esp)
  104ff3:	e8 48 f2 ff ff       	call   104240 <dprintf>
  104ff8:	83 c4 10             	add    $0x10,%esp
  104ffb:	8d 83 22 94 ff ff    	lea    -0x6bde(%ebx),%eax
  105001:	89 04 24             	mov    %eax,(%esp)
  105004:	8d 83 b6 93 ff ff    	lea    -0x6c4a(%ebx),%eax
  10500a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10500e:	8d 44 24 10          	lea    0x10(%esp),%eax
  105012:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10501d:	8d 76 00             	lea    0x0(%esi),%esi

    while (1) {
        buf = (char *) readline("$> ");
  105020:	83 ec 0c             	sub    $0xc,%esp
  105023:	ff 74 24 0c          	push   0xc(%esp)
  105027:	e8 44 b5 ff ff       	call   100570 <readline>
        if (buf != NULL)
  10502c:	83 c4 10             	add    $0x10,%esp
        buf = (char *) readline("$> ");
  10502f:	89 c5                	mov    %eax,%ebp
        if (buf != NULL)
  105031:	85 c0                	test   %eax,%eax
  105033:	74 eb                	je     105020 <monitor+0x70>
    argv[argc] = 0;
  105035:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  10503c:	00 
  10503d:	0f be 10             	movsbl (%eax),%edx
    argc = 0;
  105040:	31 c9                	xor    %ecx,%ecx
  105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        while (*buf && strchr(WHITESPACE, *buf))
  105048:	84 d2                	test   %dl,%dl
  10504a:	75 74                	jne    1050c0 <monitor+0x110>
    if (argc == 0)
  10504c:	85 c9                	test   %ecx,%ecx
    argv[argc] = 0;
  10504e:	c7 44 8c 10 00 00 00 	movl   $0x0,0x10(%esp,%ecx,4)
  105055:	00 
    if (argc == 0)
  105056:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10505a:	74 c4                	je     105020 <monitor+0x70>
        if (strcmp(argv[0], commands[i].name) == 0)
  10505c:	83 ec 08             	sub    $0x8,%esp
  10505f:	ff 74 24 10          	push   0x10(%esp)
  105063:	ff 74 24 1c          	push   0x1c(%esp)
  105067:	e8 34 ee ff ff       	call   103ea0 <strcmp>
  10506c:	83 c4 10             	add    $0x10,%esp
  10506f:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  105073:	85 c0                	test   %eax,%eax
  105075:	0f 84 db 00 00 00    	je     105156 <monitor+0x1a6>
  10507b:	83 ec 08             	sub    $0x8,%esp
  10507e:	8d 83 c4 93 ff ff    	lea    -0x6c3c(%ebx),%eax
  105084:	50                   	push   %eax
  105085:	ff 74 24 1c          	push   0x1c(%esp)
  105089:	e8 12 ee ff ff       	call   103ea0 <strcmp>
  10508e:	83 c4 10             	add    $0x10,%esp
  105091:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  105095:	85 c0                	test   %eax,%eax
  105097:	0f 84 e0 00 00 00    	je     10517d <monitor+0x1cd>
    dprintf("Unknown command '%s'\n", argv[0]);
  10509d:	83 ec 08             	sub    $0x8,%esp
  1050a0:	8d 83 48 94 ff ff    	lea    -0x6bb8(%ebx),%eax
  1050a6:	ff 74 24 18          	push   0x18(%esp)
  1050aa:	50                   	push   %eax
  1050ab:	e8 90 f1 ff ff       	call   104240 <dprintf>
    return 0;
  1050b0:	83 c4 10             	add    $0x10,%esp
  1050b3:	e9 68 ff ff ff       	jmp    105020 <monitor+0x70>
  1050b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1050bf:	90                   	nop
  1050c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
        while (*buf && strchr(WHITESPACE, *buf))
  1050c4:	83 ec 08             	sub    $0x8,%esp
  1050c7:	52                   	push   %edx
  1050c8:	56                   	push   %esi
  1050c9:	e8 22 ee ff ff       	call   103ef0 <strchr>
  1050ce:	83 c4 10             	add    $0x10,%esp
  1050d1:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1050d5:	85 c0                	test   %eax,%eax
  1050d7:	74 17                	je     1050f0 <monitor+0x140>
            *buf++ = 0;
  1050d9:	8d 45 01             	lea    0x1(%ebp),%eax
  1050dc:	c6 45 00 00          	movb   $0x0,0x0(%ebp)
  1050e0:	89 cf                	mov    %ecx,%edi
  1050e2:	89 c5                	mov    %eax,%ebp
  1050e4:	0f be 55 00          	movsbl 0x0(%ebp),%edx
  1050e8:	89 f9                	mov    %edi,%ecx
  1050ea:	e9 59 ff ff ff       	jmp    105048 <monitor+0x98>
  1050ef:	90                   	nop
        if (*buf == 0)
  1050f0:	80 7d 00 00          	cmpb   $0x0,0x0(%ebp)
  1050f4:	0f 84 52 ff ff ff    	je     10504c <monitor+0x9c>
        if (argc == MAXARGS - 1) {
  1050fa:	83 f9 0f             	cmp    $0xf,%ecx
  1050fd:	74 3e                	je     10513d <monitor+0x18d>
        argv[argc++] = buf;
  1050ff:	89 6c 8c 10          	mov    %ebp,0x10(%esp,%ecx,4)
        while (*buf && !strchr(WHITESPACE, *buf))
  105103:	0f be 55 00          	movsbl 0x0(%ebp),%edx
        argv[argc++] = buf;
  105107:	8d 79 01             	lea    0x1(%ecx),%edi
        while (*buf && !strchr(WHITESPACE, *buf))
  10510a:	0f be c2             	movsbl %dl,%eax
  10510d:	84 d2                	test   %dl,%dl
  10510f:	74 d7                	je     1050e8 <monitor+0x138>
  105111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105118:	83 ec 08             	sub    $0x8,%esp
  10511b:	50                   	push   %eax
  10511c:	56                   	push   %esi
  10511d:	e8 ce ed ff ff       	call   103ef0 <strchr>
  105122:	83 c4 10             	add    $0x10,%esp
  105125:	85 c0                	test   %eax,%eax
  105127:	75 bb                	jne    1050e4 <monitor+0x134>
  105129:	0f be 45 01          	movsbl 0x1(%ebp),%eax
            buf++;
  10512d:	83 c5 01             	add    $0x1,%ebp
        while (*buf && !strchr(WHITESPACE, *buf))
  105130:	84 c0                	test   %al,%al
  105132:	75 e4                	jne    105118 <monitor+0x168>
  105134:	31 d2                	xor    %edx,%edx
            *buf++ = 0;
  105136:	89 f9                	mov    %edi,%ecx
  105138:	e9 0b ff ff ff       	jmp    105048 <monitor+0x98>
            dprintf("Too many arguments (max %d)\n", MAXARGS);
  10513d:	83 ec 08             	sub    $0x8,%esp
  105140:	8d 83 2b 94 ff ff    	lea    -0x6bd5(%ebx),%eax
  105146:	6a 10                	push   $0x10
  105148:	50                   	push   %eax
  105149:	e8 f2 f0 ff ff       	call   104240 <dprintf>
            return 0;
  10514e:	83 c4 10             	add    $0x10,%esp
  105151:	e9 ca fe ff ff       	jmp    105020 <monitor+0x70>
        if (strcmp(argv[0], commands[i].name) == 0)
  105156:	8d 83 b0 3e ff ff    	lea    -0xc150(%ebx),%eax
            return commands[i].func(argc, argv, tf);
  10515c:	83 ec 04             	sub    $0x4,%esp
  10515f:	ff 74 24 74          	push   0x74(%esp)
  105163:	ff 74 24 14          	push   0x14(%esp)
  105167:	51                   	push   %ecx
  105168:	ff d0                	call   *%eax
            if (runcmd(buf, tf) < 0)
  10516a:	83 c4 10             	add    $0x10,%esp
  10516d:	85 c0                	test   %eax,%eax
  10516f:	0f 89 ab fe ff ff    	jns    105020 <monitor+0x70>
                break;
    }
}
  105175:	83 c4 5c             	add    $0x5c,%esp
  105178:	5b                   	pop    %ebx
  105179:	5e                   	pop    %esi
  10517a:	5f                   	pop    %edi
  10517b:	5d                   	pop    %ebp
  10517c:	c3                   	ret    
        if (strcmp(argv[0], commands[i].name) == 0)
  10517d:	8d 83 00 3f ff ff    	lea    -0xc100(%ebx),%eax
  105183:	eb d7                	jmp    10515c <monitor+0x1ac>
  105185:	66 90                	xchg   %ax,%ax
  105187:	66 90                	xchg   %ax,%ax
  105189:	66 90                	xchg   %ax,%ax
  10518b:	66 90                	xchg   %ax,%ax
  10518d:	66 90                	xchg   %ax,%ax
  10518f:	90                   	nop

00105190 <pt_copyin>:
                       unsigned int perm);
extern unsigned int get_ptbl_entry_by_va(unsigned int pid,
                                         unsigned int vaddr);

size_t pt_copyin(uint32_t pmap_id, uintptr_t uva, void *kva, size_t len)
{
  105190:	55                   	push   %ebp
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
        return 0;
  105191:	31 ed                	xor    %ebp,%ebp
{
  105193:	57                   	push   %edi
  105194:	56                   	push   %esi
  105195:	53                   	push   %ebx
  105196:	e8 ee b1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10519b:	81 c3 65 be 00 00    	add    $0xbe65,%ebx
  1051a1:	83 ec 1c             	sub    $0x1c,%esp
  1051a4:	8b 7c 24 34          	mov    0x34(%esp),%edi
  1051a8:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  1051ac:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  1051b2:	0f 86 b4 00 00 00    	jbe    10526c <pt_copyin+0xdc>
  1051b8:	8d 04 37             	lea    (%edi,%esi,1),%eax
  1051bb:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  1051c0:	0f 87 a6 00 00 00    	ja     10526c <pt_copyin+0xdc>

    if ((uintptr_t) kva + len > VM_USERHI)
  1051c6:	8b 44 24 38          	mov    0x38(%esp),%eax
  1051ca:	01 f0                	add    %esi,%eax
  1051cc:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  1051d1:	0f 87 95 00 00 00    	ja     10526c <pt_copyin+0xdc>
        return 0;

    size_t copied = 0;

    while (len) {
  1051d7:	85 f6                	test   %esi,%esi
  1051d9:	0f 84 8d 00 00 00    	je     10526c <pt_copyin+0xdc>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
        }

        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);

        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1051df:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  1051e3:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  1051e7:	eb 44                	jmp    10522d <pt_copyin+0x9d>
  1051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1051f0:	89 f9                	mov    %edi,%ecx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1051f2:	ba 00 10 00 00       	mov    $0x1000,%edx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1051f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1051fc:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  105202:	29 ca                	sub    %ecx,%edx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  105204:	09 c8                	or     %ecx,%eax
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  105206:	39 f2                	cmp    %esi,%edx
  105208:	0f 47 d6             	cmova  %esi,%edx
            len : PAGESIZE - uva_pa % PAGESIZE;

        memcpy(kva, (void *) uva_pa, size);
  10520b:	83 ec 04             	sub    $0x4,%esp
  10520e:	52                   	push   %edx
  10520f:	89 54 24 10          	mov    %edx,0x10(%esp)
  105213:	50                   	push   %eax
  105214:	55                   	push   %ebp
  105215:	e8 f6 eb ff ff       	call   103e10 <memcpy>

        len -= size;
        uva += size;
  10521a:	8b 54 24 18          	mov    0x18(%esp),%edx
        kva += size;
        copied += size;
  10521e:	01 54 24 1c          	add    %edx,0x1c(%esp)
    while (len) {
  105222:	83 c4 10             	add    $0x10,%esp
        uva += size;
  105225:	01 d7                	add    %edx,%edi
        kva += size;
  105227:	01 d5                	add    %edx,%ebp
    while (len) {
  105229:	29 d6                	sub    %edx,%esi
  10522b:	74 3b                	je     105268 <pt_copyin+0xd8>
        uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  10522d:	83 ec 08             	sub    $0x8,%esp
  105230:	57                   	push   %edi
  105231:	ff 74 24 3c          	push   0x3c(%esp)
  105235:	e8 e6 19 00 00       	call   106c20 <get_ptbl_entry_by_va>
        if ((uva_pa & PTE_P) == 0) {
  10523a:	83 c4 10             	add    $0x10,%esp
  10523d:	a8 01                	test   $0x1,%al
  10523f:	75 af                	jne    1051f0 <pt_copyin+0x60>
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  105241:	83 ec 04             	sub    $0x4,%esp
  105244:	6a 07                	push   $0x7
  105246:	57                   	push   %edi
  105247:	ff 74 24 3c          	push   0x3c(%esp)
  10524b:	e8 80 1e 00 00       	call   1070d0 <alloc_page>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  105250:	58                   	pop    %eax
  105251:	5a                   	pop    %edx
  105252:	57                   	push   %edi
  105253:	ff 74 24 3c          	push   0x3c(%esp)
  105257:	e8 c4 19 00 00       	call   106c20 <get_ptbl_entry_by_va>
  10525c:	83 c4 10             	add    $0x10,%esp
  10525f:	eb 8f                	jmp    1051f0 <pt_copyin+0x60>
  105261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105268:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
    }

    return copied;
}
  10526c:	83 c4 1c             	add    $0x1c,%esp
  10526f:	89 e8                	mov    %ebp,%eax
  105271:	5b                   	pop    %ebx
  105272:	5e                   	pop    %esi
  105273:	5f                   	pop    %edi
  105274:	5d                   	pop    %ebp
  105275:	c3                   	ret    
  105276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10527d:	8d 76 00             	lea    0x0(%esi),%esi

00105280 <pt_copyout>:

size_t pt_copyout(void *kva, uint32_t pmap_id, uintptr_t uva, size_t len)
{
  105280:	55                   	push   %ebp
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
        return 0;
  105281:	31 ed                	xor    %ebp,%ebp
{
  105283:	57                   	push   %edi
  105284:	56                   	push   %esi
  105285:	53                   	push   %ebx
  105286:	e8 fe b0 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10528b:	81 c3 75 bd 00 00    	add    $0xbd75,%ebx
  105291:	83 ec 1c             	sub    $0x1c,%esp
  105294:	8b 7c 24 38          	mov    0x38(%esp),%edi
  105298:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  10529c:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  1052a2:	0f 86 b4 00 00 00    	jbe    10535c <pt_copyout+0xdc>
  1052a8:	8d 04 37             	lea    (%edi,%esi,1),%eax
  1052ab:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  1052b0:	0f 87 a6 00 00 00    	ja     10535c <pt_copyout+0xdc>

    if ((uintptr_t) kva + len > VM_USERHI)
  1052b6:	8b 44 24 30          	mov    0x30(%esp),%eax
  1052ba:	01 f0                	add    %esi,%eax
  1052bc:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  1052c1:	0f 87 95 00 00 00    	ja     10535c <pt_copyout+0xdc>
        return 0;

    size_t copied = 0;

    while (len) {
  1052c7:	85 f6                	test   %esi,%esi
  1052c9:	0f 84 8d 00 00 00    	je     10535c <pt_copyout+0xdc>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
        }

        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);

        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1052cf:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  1052d3:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  1052d7:	eb 44                	jmp    10531d <pt_copyout+0x9d>
  1052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1052e0:	89 f9                	mov    %edi,%ecx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1052e2:	ba 00 10 00 00       	mov    $0x1000,%edx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1052e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1052ec:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1052f2:	29 ca                	sub    %ecx,%edx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1052f4:	09 c8                	or     %ecx,%eax
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1052f6:	39 f2                	cmp    %esi,%edx
  1052f8:	0f 47 d6             	cmova  %esi,%edx
            len : PAGESIZE - uva_pa % PAGESIZE;

        memcpy((void *) uva_pa, kva, size);
  1052fb:	83 ec 04             	sub    $0x4,%esp
  1052fe:	52                   	push   %edx
  1052ff:	89 54 24 10          	mov    %edx,0x10(%esp)
  105303:	55                   	push   %ebp
  105304:	50                   	push   %eax
  105305:	e8 06 eb ff ff       	call   103e10 <memcpy>

        len -= size;
        uva += size;
  10530a:	8b 54 24 18          	mov    0x18(%esp),%edx
        kva += size;
        copied += size;
  10530e:	01 54 24 1c          	add    %edx,0x1c(%esp)
    while (len) {
  105312:	83 c4 10             	add    $0x10,%esp
        uva += size;
  105315:	01 d7                	add    %edx,%edi
        kva += size;
  105317:	01 d5                	add    %edx,%ebp
    while (len) {
  105319:	29 d6                	sub    %edx,%esi
  10531b:	74 3b                	je     105358 <pt_copyout+0xd8>
        uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  10531d:	83 ec 08             	sub    $0x8,%esp
  105320:	57                   	push   %edi
  105321:	ff 74 24 40          	push   0x40(%esp)
  105325:	e8 f6 18 00 00       	call   106c20 <get_ptbl_entry_by_va>
        if ((uva_pa & PTE_P) == 0) {
  10532a:	83 c4 10             	add    $0x10,%esp
  10532d:	a8 01                	test   $0x1,%al
  10532f:	75 af                	jne    1052e0 <pt_copyout+0x60>
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  105331:	83 ec 04             	sub    $0x4,%esp
  105334:	6a 07                	push   $0x7
  105336:	57                   	push   %edi
  105337:	ff 74 24 40          	push   0x40(%esp)
  10533b:	e8 90 1d 00 00       	call   1070d0 <alloc_page>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  105340:	58                   	pop    %eax
  105341:	5a                   	pop    %edx
  105342:	57                   	push   %edi
  105343:	ff 74 24 40          	push   0x40(%esp)
  105347:	e8 d4 18 00 00       	call   106c20 <get_ptbl_entry_by_va>
  10534c:	83 c4 10             	add    $0x10,%esp
  10534f:	eb 8f                	jmp    1052e0 <pt_copyout+0x60>
  105351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105358:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
    }

    return copied;
}
  10535c:	83 c4 1c             	add    $0x1c,%esp
  10535f:	89 e8                	mov    %ebp,%eax
  105361:	5b                   	pop    %ebx
  105362:	5e                   	pop    %esi
  105363:	5f                   	pop    %edi
  105364:	5d                   	pop    %ebp
  105365:	c3                   	ret    
  105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10536d:	8d 76 00             	lea    0x0(%esi),%esi

00105370 <pt_memset>:

size_t pt_memset(uint32_t pmap_id, uintptr_t va, char c, size_t len)
{
  105370:	55                   	push   %ebp
  105371:	57                   	push   %edi
  105372:	56                   	push   %esi
  105373:	53                   	push   %ebx
  105374:	e8 10 b0 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105379:	81 c3 87 bc 00 00    	add    $0xbc87,%ebx
  10537f:	83 ec 1c             	sub    $0x1c,%esp
  105382:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  105386:	8b 7c 24 34          	mov    0x34(%esp),%edi
  10538a:	8b 44 24 38          	mov    0x38(%esp),%eax
    size_t set = 0;

    while (len) {
  10538e:	85 f6                	test   %esi,%esi
  105390:	0f 84 8a 00 00 00    	je     105420 <pt_memset+0xb0>
        pa = (pa & 0xfffff000) + (va % PAGESIZE);

        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
            len : PAGESIZE - pa % PAGESIZE;

        memset((void *) pa, c, size);
  105396:	0f be c0             	movsbl %al,%eax
    size_t set = 0;
  105399:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1053a0:	00 
        memset((void *) pa, c, size);
  1053a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1053a5:	eb 41                	jmp    1053e8 <pt_memset+0x78>
  1053a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1053ae:	66 90                	xchg   %ax,%ax
        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  1053b0:	89 f9                	mov    %edi,%ecx
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  1053b2:	ba 00 10 00 00       	mov    $0x1000,%edx
        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  1053b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1053bc:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  1053c2:	29 ca                	sub    %ecx,%edx
        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  1053c4:	09 c8                	or     %ecx,%eax
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  1053c6:	39 f2                	cmp    %esi,%edx
  1053c8:	0f 47 d6             	cmova  %esi,%edx
        memset((void *) pa, c, size);
  1053cb:	83 ec 04             	sub    $0x4,%esp
  1053ce:	52                   	push   %edx
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  1053cf:	89 d5                	mov    %edx,%ebp
        memset((void *) pa, c, size);
  1053d1:	ff 74 24 14          	push   0x14(%esp)

        len -= size;
        va += size;
  1053d5:	01 ef                	add    %ebp,%edi
        memset((void *) pa, c, size);
  1053d7:	50                   	push   %eax
  1053d8:	e8 73 e9 ff ff       	call   103d50 <memset>
        set += size;
  1053dd:	01 6c 24 18          	add    %ebp,0x18(%esp)
    while (len) {
  1053e1:	83 c4 10             	add    $0x10,%esp
  1053e4:	29 ee                	sub    %ebp,%esi
  1053e6:	74 40                	je     105428 <pt_memset+0xb8>
        uintptr_t pa = get_ptbl_entry_by_va(pmap_id, va);
  1053e8:	83 ec 08             	sub    $0x8,%esp
  1053eb:	57                   	push   %edi
  1053ec:	ff 74 24 3c          	push   0x3c(%esp)
  1053f0:	e8 2b 18 00 00       	call   106c20 <get_ptbl_entry_by_va>
        if ((pa & PTE_P) == 0) {
  1053f5:	83 c4 10             	add    $0x10,%esp
  1053f8:	a8 01                	test   $0x1,%al
  1053fa:	75 b4                	jne    1053b0 <pt_memset+0x40>
            alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
  1053fc:	83 ec 04             	sub    $0x4,%esp
  1053ff:	6a 07                	push   $0x7
  105401:	57                   	push   %edi
  105402:	ff 74 24 3c          	push   0x3c(%esp)
  105406:	e8 c5 1c 00 00       	call   1070d0 <alloc_page>
            pa = get_ptbl_entry_by_va(pmap_id, va);
  10540b:	58                   	pop    %eax
  10540c:	5a                   	pop    %edx
  10540d:	57                   	push   %edi
  10540e:	ff 74 24 3c          	push   0x3c(%esp)
  105412:	e8 09 18 00 00       	call   106c20 <get_ptbl_entry_by_va>
  105417:	83 c4 10             	add    $0x10,%esp
  10541a:	eb 94                	jmp    1053b0 <pt_memset+0x40>
  10541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    size_t set = 0;
  105420:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105427:	00 
    }

    return set;
}
  105428:	8b 44 24 08          	mov    0x8(%esp),%eax
  10542c:	83 c4 1c             	add    $0x1c,%esp
  10542f:	5b                   	pop    %ebx
  105430:	5e                   	pop    %esi
  105431:	5f                   	pop    %edi
  105432:	5d                   	pop    %ebp
  105433:	c3                   	ret    
  105434:	66 90                	xchg   %ax,%ax
  105436:	66 90                	xchg   %ax,%ax
  105438:	66 90                	xchg   %ax,%ax
  10543a:	66 90                	xchg   %ax,%ax
  10543c:	66 90                	xchg   %ax,%ax
  10543e:	66 90                	xchg   %ax,%ax

00105440 <elf_load>:

/*
 * Load elf execution file exe to the virtual address space pmap.
 */
void elf_load(void *exe_ptr, int pid)
{
  105440:	55                   	push   %ebp
  105441:	57                   	push   %edi
  105442:	56                   	push   %esi
  105443:	53                   	push   %ebx
  105444:	e8 40 af ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105449:	81 c3 b7 bb 00 00    	add    $0xbbb7,%ebx
  10544f:	83 ec 2c             	sub    $0x2c,%esp
    char *strtab __attribute__((unused));
    uintptr_t exe = (uintptr_t) exe_ptr;

    eh = (elfhdr *) exe;

    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  105452:	8b 44 24 40          	mov    0x40(%esp),%eax
  105456:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
  10545c:	74 1f                	je     10547d <elf_load+0x3d>
  10545e:	8d 83 31 95 ff ff    	lea    -0x6acf(%ebx),%eax
  105464:	50                   	push   %eax
  105465:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10546b:	50                   	push   %eax
  10546c:	8d 83 4a 95 ff ff    	lea    -0x6ab6(%ebx),%eax
  105472:	6a 1e                	push   $0x1e
  105474:	50                   	push   %eax
  105475:	e8 b6 eb ff ff       	call   104030 <debug_panic>
  10547a:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  10547d:	8b 44 24 40          	mov    0x40(%esp),%eax
  105481:	0f b7 40 32          	movzwl 0x32(%eax),%eax
  105485:	66 85 c0             	test   %ax,%ax
  105488:	0f 84 92 01 00 00    	je     105620 <elf_load+0x1e0>

    sh = (sechdr *) ((uintptr_t) eh + eh->e_shoff);
    esh = sh + eh->e_shnum;

    strtab = (char *) (exe + sh[eh->e_shstrndx].sh_offset);
    KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  10548e:	8b 4c 24 40          	mov    0x40(%esp),%ecx
  105492:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105495:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  105498:	03 41 20             	add    0x20(%ecx),%eax
  10549b:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
  10549f:	74 1f                	je     1054c0 <elf_load+0x80>
  1054a1:	8d 83 7c 95 ff ff    	lea    -0x6a84(%ebx),%eax
  1054a7:	50                   	push   %eax
  1054a8:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1054ae:	50                   	push   %eax
  1054af:	8d 83 4a 95 ff ff    	lea    -0x6ab6(%ebx),%eax
  1054b5:	6a 25                	push   $0x25
  1054b7:	50                   	push   %eax
  1054b8:	e8 73 eb ff ff       	call   104030 <debug_panic>
  1054bd:	83 c4 10             	add    $0x10,%esp

    ph = (proghdr *) ((uintptr_t) eh + eh->e_phoff);
  1054c0:	8b 44 24 40          	mov    0x40(%esp),%eax
  1054c4:	8b 68 1c             	mov    0x1c(%eax),%ebp
  1054c7:	01 c5                	add    %eax,%ebp
    eph = ph + eh->e_phnum;
  1054c9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1054cd:	c1 e0 05             	shl    $0x5,%eax
  1054d0:	01 e8                	add    %ebp,%eax
  1054d2:	89 44 24 18          	mov    %eax,0x18(%esp)

    for (; ph < eph; ph++) {
  1054d6:	39 c5                	cmp    %eax,%ebp
  1054d8:	72 13                	jb     1054ed <elf_load+0xad>
  1054da:	e9 32 01 00 00       	jmp    105611 <elf_load+0x1d1>
  1054df:	90                   	nop
  1054e0:	83 c5 20             	add    $0x20,%ebp
  1054e3:	39 6c 24 18          	cmp    %ebp,0x18(%esp)
  1054e7:	0f 86 24 01 00 00    	jbe    105611 <elf_load+0x1d1>
        uintptr_t fa;
        uint32_t va, zva, eva, perm;

        if (ph->p_type != ELF_PROG_LOAD)
  1054ed:	83 7d 00 01          	cmpl   $0x1,0x0(%ebp)
  1054f1:	75 ed                	jne    1054e0 <elf_load+0xa0>
            continue;

        fa = (uintptr_t) eh + rounddown(ph->p_offset, PAGESIZE);
  1054f3:	83 ec 08             	sub    $0x8,%esp
  1054f6:	68 00 10 00 00       	push   $0x1000
  1054fb:	ff 75 04             	push   0x4(%ebp)
  1054fe:	e8 ed f6 ff ff       	call   104bf0 <rounddown>
  105503:	03 44 24 50          	add    0x50(%esp),%eax
        va = rounddown(ph->p_va, PAGESIZE);
  105507:	5f                   	pop    %edi
        fa = (uintptr_t) eh + rounddown(ph->p_offset, PAGESIZE);
  105508:	89 c6                	mov    %eax,%esi
        va = rounddown(ph->p_va, PAGESIZE);
  10550a:	58                   	pop    %eax
  10550b:	68 00 10 00 00       	push   $0x1000
  105510:	ff 75 08             	push   0x8(%ebp)
  105513:	e8 d8 f6 ff ff       	call   104bf0 <rounddown>
        zva = ph->p_va + ph->p_filesz;
  105518:	8b 4d 10             	mov    0x10(%ebp),%ecx
        va = rounddown(ph->p_va, PAGESIZE);
  10551b:	89 c7                	mov    %eax,%edi
        zva = ph->p_va + ph->p_filesz;
  10551d:	8b 45 08             	mov    0x8(%ebp),%eax
  105520:	01 c1                	add    %eax,%ecx
  105522:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        eva = roundup(ph->p_va + ph->p_memsz, PAGESIZE);
  105526:	5a                   	pop    %edx
  105527:	59                   	pop    %ecx
  105528:	68 00 10 00 00       	push   $0x1000
  10552d:	03 45 14             	add    0x14(%ebp),%eax
  105530:	50                   	push   %eax
  105531:	e8 da f6 ff ff       	call   104c10 <roundup>
  105536:	89 44 24 20          	mov    %eax,0x20(%esp)
  10553a:	89 c1                	mov    %eax,%ecx

        perm = PTE_U | PTE_P;
        if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  10553c:	8b 45 18             	mov    0x18(%ebp),%eax
  10553f:	83 c4 10             	add    $0x10,%esp
  105542:	83 e0 02             	and    $0x2,%eax
            perm |= PTE_W;
  105545:	83 f8 01             	cmp    $0x1,%eax
  105548:	19 d2                	sbb    %edx,%edx
  10554a:	83 e2 fe             	and    $0xfffffffe,%edx
  10554d:	83 c2 07             	add    $0x7,%edx
  105550:	89 54 24 14          	mov    %edx,0x14(%esp)

        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  105554:	39 cf                	cmp    %ecx,%edi
  105556:	73 88                	jae    1054e0 <elf_load+0xa0>
  105558:	89 6c 24 1c          	mov    %ebp,0x1c(%esp)
  10555c:	8b 6c 24 44          	mov    0x44(%esp),%ebp
  105560:	eb 3a                	jmp    10559c <elf_load+0x15c>
  105562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            alloc_page(pid, va, perm);

            if (va < rounddown(zva, PAGESIZE)) {
                /* copy a complete page */
                pt_copyout((void *) fa, pid, va, PAGESIZE);
            } else if (va < zva && ph->p_filesz) {
  105568:	39 7c 24 0c          	cmp    %edi,0xc(%esp)
  10556c:	76 0b                	jbe    105579 <elf_load+0x139>
  10556e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  105572:	8b 40 10             	mov    0x10(%eax),%eax
  105575:	85 c0                	test   %eax,%eax
  105577:	75 5f                	jne    1055d8 <elf_load+0x198>
                /* copy a partial page */
                pt_memset(pid, va, 0, PAGESIZE);
                pt_copyout((void *) fa, pid, va, zva - va);
            } else {
                /* zero a page */
                pt_memset(pid, va, 0, PAGESIZE);
  105579:	68 00 10 00 00       	push   $0x1000
  10557e:	6a 00                	push   $0x0
  105580:	57                   	push   %edi
  105581:	55                   	push   %ebp
  105582:	e8 e9 fd ff ff       	call   105370 <pt_memset>
  105587:	83 c4 10             	add    $0x10,%esp
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  10558a:	81 c7 00 10 00 00    	add    $0x1000,%edi
  105590:	81 c6 00 10 00 00    	add    $0x1000,%esi
  105596:	39 7c 24 10          	cmp    %edi,0x10(%esp)
  10559a:	76 64                	jbe    105600 <elf_load+0x1c0>
            alloc_page(pid, va, perm);
  10559c:	83 ec 04             	sub    $0x4,%esp
  10559f:	ff 74 24 18          	push   0x18(%esp)
  1055a3:	57                   	push   %edi
  1055a4:	55                   	push   %ebp
  1055a5:	e8 26 1b 00 00       	call   1070d0 <alloc_page>
            if (va < rounddown(zva, PAGESIZE)) {
  1055aa:	5a                   	pop    %edx
  1055ab:	59                   	pop    %ecx
  1055ac:	68 00 10 00 00       	push   $0x1000
  1055b1:	ff 74 24 18          	push   0x18(%esp)
  1055b5:	e8 36 f6 ff ff       	call   104bf0 <rounddown>
  1055ba:	83 c4 10             	add    $0x10,%esp
  1055bd:	39 f8                	cmp    %edi,%eax
  1055bf:	76 a7                	jbe    105568 <elf_load+0x128>
                pt_copyout((void *) fa, pid, va, PAGESIZE);
  1055c1:	68 00 10 00 00       	push   $0x1000
  1055c6:	57                   	push   %edi
  1055c7:	55                   	push   %ebp
  1055c8:	56                   	push   %esi
  1055c9:	e8 b2 fc ff ff       	call   105280 <pt_copyout>
  1055ce:	83 c4 10             	add    $0x10,%esp
  1055d1:	eb b7                	jmp    10558a <elf_load+0x14a>
  1055d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1055d7:	90                   	nop
                pt_memset(pid, va, 0, PAGESIZE);
  1055d8:	68 00 10 00 00       	push   $0x1000
  1055dd:	6a 00                	push   $0x0
  1055df:	57                   	push   %edi
  1055e0:	55                   	push   %ebp
  1055e1:	e8 8a fd ff ff       	call   105370 <pt_memset>
                pt_copyout((void *) fa, pid, va, zva - va);
  1055e6:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1055ea:	29 f8                	sub    %edi,%eax
  1055ec:	50                   	push   %eax
  1055ed:	57                   	push   %edi
  1055ee:	55                   	push   %ebp
  1055ef:	56                   	push   %esi
  1055f0:	e8 8b fc ff ff       	call   105280 <pt_copyout>
  1055f5:	83 c4 20             	add    $0x20,%esp
  1055f8:	eb 90                	jmp    10558a <elf_load+0x14a>
  1055fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105600:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
    for (; ph < eph; ph++) {
  105604:	83 c5 20             	add    $0x20,%ebp
  105607:	39 6c 24 18          	cmp    %ebp,0x18(%esp)
  10560b:	0f 87 dc fe ff ff    	ja     1054ed <elf_load+0xad>
            }
        }
    }
}
  105611:	83 c4 2c             	add    $0x2c,%esp
  105614:	5b                   	pop    %ebx
  105615:	5e                   	pop    %esi
  105616:	5f                   	pop    %edi
  105617:	5d                   	pop    %ebp
  105618:	c3                   	ret    
  105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  105620:	8d 83 5c 95 ff ff    	lea    -0x6aa4(%ebx),%eax
  105626:	50                   	push   %eax
  105627:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10562d:	50                   	push   %eax
  10562e:	8d 83 4a 95 ff ff    	lea    -0x6ab6(%ebx),%eax
  105634:	6a 1f                	push   $0x1f
  105636:	50                   	push   %eax
  105637:	e8 f4 e9 ff ff       	call   104030 <debug_panic>
    strtab = (char *) (exe + sh[eh->e_shstrndx].sh_offset);
  10563c:	8b 44 24 50          	mov    0x50(%esp),%eax
  105640:	83 c4 10             	add    $0x10,%esp
  105643:	0f b7 40 32          	movzwl 0x32(%eax),%eax
  105647:	e9 42 fe ff ff       	jmp    10548e <elf_load+0x4e>
  10564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105650 <elf_entry>:

uintptr_t elf_entry(void *exe_ptr)
{
  105650:	56                   	push   %esi
  105651:	53                   	push   %ebx
  105652:	e8 32 ad ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105657:	81 c3 a9 b9 00 00    	add    $0xb9a9,%ebx
  10565d:	83 ec 04             	sub    $0x4,%esp
  105660:	8b 74 24 10          	mov    0x10(%esp),%esi
    uintptr_t exe = (uintptr_t) exe_ptr;
    elfhdr *eh = (elfhdr *) exe;
    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  105664:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  10566a:	74 1f                	je     10568b <elf_entry+0x3b>
  10566c:	8d 83 31 95 ff ff    	lea    -0x6acf(%ebx),%eax
  105672:	50                   	push   %eax
  105673:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  105679:	50                   	push   %eax
  10567a:	8d 83 4a 95 ff ff    	lea    -0x6ab6(%ebx),%eax
  105680:	6a 50                	push   $0x50
  105682:	50                   	push   %eax
  105683:	e8 a8 e9 ff ff       	call   104030 <debug_panic>
  105688:	83 c4 10             	add    $0x10,%esp
    return (uintptr_t) eh->e_entry;
  10568b:	8b 46 18             	mov    0x18(%esi),%eax
}
  10568e:	83 c4 04             	add    $0x4,%esp
  105691:	5b                   	pop    %ebx
  105692:	5e                   	pop    %esi
  105693:	c3                   	ret    
  105694:	66 90                	xchg   %ax,%ax
  105696:	66 90                	xchg   %ax,%ax
  105698:	66 90                	xchg   %ax,%ax
  10569a:	66 90                	xchg   %ax,%ax
  10569c:	66 90                	xchg   %ax,%ax
  10569e:	66 90                	xchg   %ax,%ax

001056a0 <get_kstack_pointer>:

struct kstack bsp_kstack[NUM_CPUS];
struct kstack proc_kstack[NUM_IDS];

uintptr_t *get_kstack_pointer(void)
{
  1056a0:	53                   	push   %ebx
  1056a1:	e8 e3 ac ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1056a6:	81 c3 5a b9 00 00    	add    $0xb95a,%ebx
  1056ac:	83 ec 08             	sub    $0x8,%esp
    return (uintptr_t *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  1056af:	e8 7c f5 ff ff       	call   104c30 <read_esp>
}
  1056b4:	83 c4 08             	add    $0x8,%esp
    return (uintptr_t *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  1056b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
  1056bc:	5b                   	pop    %ebx
  1056bd:	c3                   	ret    
  1056be:	66 90                	xchg   %ax,%ax

001056c0 <get_kstack_cpu_idx>:

int get_kstack_cpu_idx(void)
{
  1056c0:	53                   	push   %ebx
  1056c1:	e8 c3 ac ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1056c6:	81 c3 3a b9 00 00    	add    $0xb93a,%ebx
  1056cc:	83 ec 08             	sub    $0x8,%esp
    return (uintptr_t *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  1056cf:	e8 5c f5 ff ff       	call   104c30 <read_esp>
  1056d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    struct kstack *ks = (struct kstack *) get_kstack_pointer();
    return ks->cpu_idx;
  1056d9:	8b 80 1c 01 00 00    	mov    0x11c(%eax),%eax
}
  1056df:	83 c4 08             	add    $0x8,%esp
  1056e2:	5b                   	pop    %ebx
  1056e3:	c3                   	ret    
  1056e4:	66 90                	xchg   %ax,%ax
  1056e6:	66 90                	xchg   %ax,%ax
  1056e8:	66 90                	xchg   %ax,%ax
  1056ea:	66 90                	xchg   %ax,%ax
  1056ec:	66 90                	xchg   %ax,%ax
  1056ee:	66 90                	xchg   %ax,%ax

001056f0 <spinlock_init>:
#include "spinlock.h"

extern volatile uint64_t tsc_per_ms;

void gcc_inline spinlock_init(spinlock_t *lk)
{
  1056f0:	8b 44 24 04          	mov    0x4(%esp),%eax
    lk->lock_holder = NUM_CPUS + 1;
  1056f4:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
    lk->lock = 0;
  1056fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
  105701:	c3                   	ret    
  105702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105710 <spinlock_holding>:

bool gcc_inline spinlock_holding(spinlock_t *lk)
{
  105710:	57                   	push   %edi
  105711:	31 c0                	xor    %eax,%eax
  105713:	56                   	push   %esi
  105714:	53                   	push   %ebx
  105715:	8b 74 24 10          	mov    0x10(%esp),%esi
  105719:	e8 6b ac ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10571e:	81 c3 e2 b8 00 00    	add    $0xb8e2,%ebx
    if (!lk->lock)
  105724:	8b 56 04             	mov    0x4(%esi),%edx
  105727:	85 d2                	test   %edx,%edx
  105729:	75 05                	jne    105730 <spinlock_holding+0x20>
        return FALSE;

    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
    return lk->lock_holder == kstack->cpu_idx;
}
  10572b:	5b                   	pop    %ebx
  10572c:	5e                   	pop    %esi
  10572d:	5f                   	pop    %edi
  10572e:	c3                   	ret    
  10572f:	90                   	nop
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105730:	e8 fb f4 ff ff       	call   104c30 <read_esp>
  105735:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  10573a:	81 b8 20 01 00 00 32 	cmpl   $0x98765432,0x120(%eax)
  105741:	54 76 98 
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105744:	89 c7                	mov    %eax,%edi
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  105746:	74 1f                	je     105767 <spinlock_holding+0x57>
  105748:	8d 83 a9 95 ff ff    	lea    -0x6a57(%ebx),%eax
  10574e:	50                   	push   %eax
  10574f:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  105755:	50                   	push   %eax
  105756:	8d 83 c7 95 ff ff    	lea    -0x6a39(%ebx),%eax
  10575c:	6a 16                	push   $0x16
  10575e:	50                   	push   %eax
  10575f:	e8 cc e8 ff ff       	call   104030 <debug_panic>
  105764:	83 c4 10             	add    $0x10,%esp
    return lk->lock_holder == kstack->cpu_idx;
  105767:	8b 87 1c 01 00 00    	mov    0x11c(%edi),%eax
  10576d:	39 06                	cmp    %eax,(%esi)
}
  10576f:	5b                   	pop    %ebx
    return lk->lock_holder == kstack->cpu_idx;
  105770:	0f 94 c0             	sete   %al
}
  105773:	5e                   	pop    %esi
  105774:	5f                   	pop    %edi
  105775:	c3                   	ret    
  105776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10577d:	8d 76 00             	lea    0x0(%esi),%esi

00105780 <spinlock_acquire>:

    return spinlock_try_acquire_A(lk);
}
#else   /* DEBUG_LOCKHOLDING */
void gcc_inline spinlock_acquire(spinlock_t *lk)
{
  105780:	57                   	push   %edi
  105781:	56                   	push   %esi
  105782:	53                   	push   %ebx
  105783:	8b 7c 24 10          	mov    0x10(%esp),%edi
    while (xchg(&lk->lock, 1) != 0)
  105787:	e8 fd ab ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10578c:	81 c3 74 b8 00 00    	add    $0xb874,%ebx
  105792:	8d 77 04             	lea    0x4(%edi),%esi
  105795:	eb 0e                	jmp    1057a5 <spinlock_acquire+0x25>
  105797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10579e:	66 90                	xchg   %ax,%ax
        pause();
  1057a0:	e8 0b f5 ff ff       	call   104cb0 <pause>
    while (xchg(&lk->lock, 1) != 0)
  1057a5:	83 ec 08             	sub    $0x8,%esp
  1057a8:	6a 01                	push   $0x1
  1057aa:	56                   	push   %esi
  1057ab:	e8 10 f5 ff ff       	call   104cc0 <xchg>
  1057b0:	83 c4 10             	add    $0x10,%esp
  1057b3:	85 c0                	test   %eax,%eax
  1057b5:	75 e9                	jne    1057a0 <spinlock_acquire+0x20>
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  1057b7:	e8 74 f4 ff ff       	call   104c30 <read_esp>
  1057bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  1057c1:	81 b8 20 01 00 00 32 	cmpl   $0x98765432,0x120(%eax)
  1057c8:	54 76 98 
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  1057cb:	89 c6                	mov    %eax,%esi
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  1057cd:	74 1f                	je     1057ee <spinlock_acquire+0x6e>
  1057cf:	8d 83 a9 95 ff ff    	lea    -0x6a57(%ebx),%eax
  1057d5:	50                   	push   %eax
  1057d6:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1057dc:	50                   	push   %eax
  1057dd:	8d 83 c7 95 ff ff    	lea    -0x6a39(%ebx),%eax
  1057e3:	6a 2f                	push   $0x2f
  1057e5:	50                   	push   %eax
  1057e6:	e8 45 e8 ff ff       	call   104030 <debug_panic>
  1057eb:	83 c4 10             	add    $0x10,%esp
    lk->lock_holder = kstack->cpu_idx;
  1057ee:	8b 86 1c 01 00 00    	mov    0x11c(%esi),%eax
  1057f4:	89 07                	mov    %eax,(%edi)
    spinlock_acquire_A(lk);
}
  1057f6:	5b                   	pop    %ebx
  1057f7:	5e                   	pop    %esi
  1057f8:	5f                   	pop    %edi
  1057f9:	c3                   	ret    
  1057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105800 <spinlock_release>:

void gcc_inline spinlock_release(spinlock_t *lk)
{
  105800:	53                   	push   %ebx
  105801:	e8 83 ab ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105806:	81 c3 fa b7 00 00    	add    $0xb7fa,%ebx
  10580c:	83 ec 10             	sub    $0x10,%esp
  10580f:	8b 44 24 18          	mov    0x18(%esp),%eax
    lk->lock_holder = NUM_CPUS + 1;
  105813:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
    xchg(&lk->lock, 0);
  105819:	83 c0 04             	add    $0x4,%eax
  10581c:	6a 00                	push   $0x0
  10581e:	50                   	push   %eax
  10581f:	e8 9c f4 ff ff       	call   104cc0 <xchg>
    spinlock_release_A(lk);
}
  105824:	83 c4 18             	add    $0x18,%esp
  105827:	5b                   	pop    %ebx
  105828:	c3                   	ret    
  105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105830 <spinlock_try_acquire>:

int gcc_inline spinlock_try_acquire(spinlock_t *lk)
{
  105830:	55                   	push   %ebp
  105831:	57                   	push   %edi
  105832:	56                   	push   %esi
  105833:	53                   	push   %ebx
  105834:	e8 50 ab ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105839:	81 c3 c7 b7 00 00    	add    $0xb7c7,%ebx
  10583f:	83 ec 14             	sub    $0x14,%esp
  105842:	8b 7c 24 28          	mov    0x28(%esp),%edi
    uint32_t old_val = xchg(&lk->lock, 1);
  105846:	6a 01                	push   $0x1
  105848:	8d 47 04             	lea    0x4(%edi),%eax
  10584b:	50                   	push   %eax
  10584c:	e8 6f f4 ff ff       	call   104cc0 <xchg>
    if (old_val == 0) {
  105851:	83 c4 10             	add    $0x10,%esp
    uint32_t old_val = xchg(&lk->lock, 1);
  105854:	89 c6                	mov    %eax,%esi
    if (old_val == 0) {
  105856:	85 c0                	test   %eax,%eax
  105858:	74 0e                	je     105868 <spinlock_try_acquire+0x38>
    return spinlock_try_acquire_A(lk);
}
  10585a:	83 c4 0c             	add    $0xc,%esp
  10585d:	89 f0                	mov    %esi,%eax
  10585f:	5b                   	pop    %ebx
  105860:	5e                   	pop    %esi
  105861:	5f                   	pop    %edi
  105862:	5d                   	pop    %ebp
  105863:	c3                   	ret    
  105864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105868:	e8 c3 f3 ff ff       	call   104c30 <read_esp>
  10586d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  105872:	81 b8 20 01 00 00 32 	cmpl   $0x98765432,0x120(%eax)
  105879:	54 76 98 
        struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  10587c:	89 c5                	mov    %eax,%ebp
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  10587e:	75 18                	jne    105898 <spinlock_try_acquire+0x68>
        lk->lock_holder = kstack->cpu_idx;
  105880:	8b 85 1c 01 00 00    	mov    0x11c(%ebp),%eax
  105886:	89 07                	mov    %eax,(%edi)
}
  105888:	83 c4 0c             	add    $0xc,%esp
  10588b:	89 f0                	mov    %esi,%eax
  10588d:	5b                   	pop    %ebx
  10588e:	5e                   	pop    %esi
  10588f:	5f                   	pop    %edi
  105890:	5d                   	pop    %ebp
  105891:	c3                   	ret    
  105892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  105898:	8d 83 a9 95 ff ff    	lea    -0x6a57(%ebx),%eax
  10589e:	50                   	push   %eax
  10589f:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1058a5:	50                   	push   %eax
  1058a6:	8d 83 c7 95 ff ff    	lea    -0x6a39(%ebx),%eax
  1058ac:	6a 39                	push   $0x39
  1058ae:	50                   	push   %eax
  1058af:	e8 7c e7 ff ff       	call   104030 <debug_panic>
        lk->lock_holder = kstack->cpu_idx;
  1058b4:	8b 85 1c 01 00 00    	mov    0x11c(%ebp),%eax
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  1058ba:	83 c4 10             	add    $0x10,%esp
        lk->lock_holder = kstack->cpu_idx;
  1058bd:	89 07                	mov    %eax,(%edi)
  1058bf:	eb c7                	jmp    105888 <spinlock_try_acquire+0x58>
  1058c1:	66 90                	xchg   %ax,%ax
  1058c3:	66 90                	xchg   %ax,%ax
  1058c5:	66 90                	xchg   %ax,%ax
  1058c7:	66 90                	xchg   %ax,%ax
  1058c9:	66 90                	xchg   %ax,%ax
  1058cb:	66 90                	xchg   %ax,%ax
  1058cd:	66 90                	xchg   %ax,%ax
  1058cf:	90                   	nop

001058d0 <reentrantlock_init>:
#include "reentrant_lock.h"

#define UNLOCKED    0xFFFFFFFF

void reentrantlock_init(reentrantlock *lk)
{
  1058d0:	8b 44 24 04          	mov    0x4(%esp),%eax
    lk->lock = UNLOCKED;
  1058d4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    lk->count = 0u;
  1058da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
  1058e1:	c3                   	ret    
  1058e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001058f0 <reentrantlock_holding>:

bool reentrantlock_holding(reentrantlock *lk)
{
    if (lk->count > 0u)
  1058f0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1058f4:	8b 40 04             	mov    0x4(%eax),%eax
  1058f7:	85 c0                	test   %eax,%eax
  1058f9:	0f 95 c0             	setne  %al
        return TRUE;
    else
        return FALSE;
}
  1058fc:	c3                   	ret    
  1058fd:	8d 76 00             	lea    0x0(%esi),%esi

00105900 <reentrantlock_acquire>:

void reentrantlock_acquire(reentrantlock *lk)
{
  105900:	57                   	push   %edi
  105901:	56                   	push   %esi
  105902:	53                   	push   %ebx
  105903:	8b 7c 24 10          	mov    0x10(%esp),%edi
  105907:	e8 7d aa ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10590c:	81 c3 f4 b6 00 00    	add    $0xb6f4,%ebx
    uint32_t cpuid = get_kstack_cpu_idx();
  105912:	e8 a9 fd ff ff       	call   1056c0 <get_kstack_cpu_idx>
  105917:	89 c6                	mov    %eax,%esi
  105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint32_t lv;

    do {
        lv = cmpxchg(&lk->lock, UNLOCKED, cpuid);
  105920:	83 ec 04             	sub    $0x4,%esp
  105923:	56                   	push   %esi
  105924:	6a ff                	push   $0xffffffff
  105926:	57                   	push   %edi
  105927:	e8 a4 f3 ff ff       	call   104cd0 <cmpxchg>
    } while (lv != cpuid && lv != UNLOCKED);
  10592c:	83 c4 10             	add    $0x10,%esp
  10592f:	39 c6                	cmp    %eax,%esi
  105931:	74 05                	je     105938 <reentrantlock_acquire+0x38>
  105933:	83 f8 ff             	cmp    $0xffffffff,%eax
  105936:	75 e8                	jne    105920 <reentrantlock_acquire+0x20>
    lk->count++;
  105938:	8b 47 04             	mov    0x4(%edi),%eax
  10593b:	83 c0 01             	add    $0x1,%eax
  10593e:	89 47 04             	mov    %eax,0x4(%edi)
}
  105941:	5b                   	pop    %ebx
  105942:	5e                   	pop    %esi
  105943:	5f                   	pop    %edi
  105944:	c3                   	ret    
  105945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105950 <reentrantlock_try_acquire>:

int reentrantlock_try_acquire(reentrantlock *lk)
{
  105950:	57                   	push   %edi
  105951:	56                   	push   %esi
  105952:	53                   	push   %ebx
  105953:	8b 7c 24 10          	mov    0x10(%esp),%edi
  105957:	e8 2d aa ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10595c:	81 c3 a4 b6 00 00    	add    $0xb6a4,%ebx
    uint32_t cpuid = get_kstack_cpu_idx();
  105962:	e8 59 fd ff ff       	call   1056c0 <get_kstack_cpu_idx>
    uint32_t lv;

    lv = cmpxchg(&lk->lock, UNLOCKED, cpuid);
  105967:	83 ec 04             	sub    $0x4,%esp
  10596a:	50                   	push   %eax
    uint32_t cpuid = get_kstack_cpu_idx();
  10596b:	89 c6                	mov    %eax,%esi
    lv = cmpxchg(&lk->lock, UNLOCKED, cpuid);
  10596d:	6a ff                	push   $0xffffffff
  10596f:	57                   	push   %edi
  105970:	e8 5b f3 ff ff       	call   104cd0 <cmpxchg>

    if (lv == cpuid || lv == UNLOCKED) {
  105975:	83 c4 10             	add    $0x10,%esp
  105978:	39 c6                	cmp    %eax,%esi
  10597a:	74 14                	je     105990 <reentrantlock_try_acquire+0x40>
        lk->count++;
        return 1;
    } else
        return 0;
  10597c:	31 d2                	xor    %edx,%edx
    if (lv == cpuid || lv == UNLOCKED) {
  10597e:	83 f8 ff             	cmp    $0xffffffff,%eax
  105981:	74 0d                	je     105990 <reentrantlock_try_acquire+0x40>
}
  105983:	5b                   	pop    %ebx
  105984:	89 d0                	mov    %edx,%eax
  105986:	5e                   	pop    %esi
  105987:	5f                   	pop    %edi
  105988:	c3                   	ret    
  105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        lk->count++;
  105990:	8b 47 04             	mov    0x4(%edi),%eax
        return 1;
  105993:	ba 01 00 00 00       	mov    $0x1,%edx
        lk->count++;
  105998:	83 c0 01             	add    $0x1,%eax
  10599b:	89 47 04             	mov    %eax,0x4(%edi)
}
  10599e:	89 d0                	mov    %edx,%eax
  1059a0:	5b                   	pop    %ebx
  1059a1:	5e                   	pop    %esi
  1059a2:	5f                   	pop    %edi
  1059a3:	c3                   	ret    
  1059a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1059ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1059af:	90                   	nop

001059b0 <reentrantlock_release>:

void reentrantlock_release(reentrantlock *lk)
{
  1059b0:	53                   	push   %ebx
  1059b1:	e8 d3 a9 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1059b6:	81 c3 4a b6 00 00    	add    $0xb64a,%ebx
  1059bc:	83 ec 08             	sub    $0x8,%esp
  1059bf:	8b 44 24 10          	mov    0x10(%esp),%eax
    lk->count--;
  1059c3:	8b 50 04             	mov    0x4(%eax),%edx
  1059c6:	83 ea 01             	sub    $0x1,%edx
  1059c9:	89 50 04             	mov    %edx,0x4(%eax)
    if (lk->count == 0u) {
  1059cc:	8b 50 04             	mov    0x4(%eax),%edx
  1059cf:	85 d2                	test   %edx,%edx
  1059d1:	74 0d                	je     1059e0 <reentrantlock_release+0x30>
        xchg(&lk->lock, UNLOCKED);
    }
}
  1059d3:	83 c4 08             	add    $0x8,%esp
  1059d6:	5b                   	pop    %ebx
  1059d7:	c3                   	ret    
  1059d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1059df:	90                   	nop
        xchg(&lk->lock, UNLOCKED);
  1059e0:	83 ec 08             	sub    $0x8,%esp
  1059e3:	6a ff                	push   $0xffffffff
  1059e5:	50                   	push   %eax
  1059e6:	e8 d5 f2 ff ff       	call   104cc0 <xchg>
  1059eb:	83 c4 10             	add    $0x10,%esp
}
  1059ee:	83 c4 08             	add    $0x8,%esp
  1059f1:	5b                   	pop    %ebx
  1059f2:	c3                   	ret    
  1059f3:	66 90                	xchg   %ax,%ax
  1059f5:	66 90                	xchg   %ax,%ax
  1059f7:	66 90                	xchg   %ax,%ax
  1059f9:	66 90                	xchg   %ax,%ax
  1059fb:	66 90                	xchg   %ax,%ax
  1059fd:	66 90                	xchg   %ax,%ax
  1059ff:	90                   	nop

00105a00 <cond_init>:
#include <lib/cond.h>
#include <thread/PCurID/export.h>
#include <thread/PThread/export.h>
#include <lib/debug.h>

void cond_init(cond_t *c) {
  105a00:	8b 54 24 04          	mov    0x4(%esp),%edx
    SLIST_INIT(&c->waiters);
  105a04:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    for (int i = 0; i < MAX_WAITERS; i++) {
  105a0a:	8d 82 84 00 00 00    	lea    0x84(%edx),%eax
  105a10:	81 c2 94 00 00 00    	add    $0x94,%edx
  105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a1d:	8d 76 00             	lea    0x0(%esi),%esi
        c->used[i] = FALSE;
  105a20:	c6 00 00             	movb   $0x0,(%eax)
    for (int i = 0; i < MAX_WAITERS; i++) {
  105a23:	83 c0 01             	add    $0x1,%eax
  105a26:	39 d0                	cmp    %edx,%eax
  105a28:	75 f6                	jne    105a20 <cond_init+0x20>
    }
}
  105a2a:	c3                   	ret    
  105a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105a2f:	90                   	nop

00105a30 <cond_get_free_waiter>:

// Return a free waiter from the pool.
// Returns 0 on success and -1 if no free slot is available.
int cond_get_free_waiter(cond_t *c, cond_waiter_t **w) {
  105a30:	8b 54 24 04          	mov    0x4(%esp),%edx
    for (int i = 0; i < MAX_WAITERS; i++) {
  105a34:	31 c0                	xor    %eax,%eax
  105a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a3d:	8d 76 00             	lea    0x0(%esi),%esi
        if (!c->used[i]) {
  105a40:	80 bc 02 84 00 00 00 	cmpb   $0x0,0x84(%edx,%eax,1)
  105a47:	00 
  105a48:	74 16                	je     105a60 <cond_get_free_waiter+0x30>
    for (int i = 0; i < MAX_WAITERS; i++) {
  105a4a:	83 c0 01             	add    $0x1,%eax
  105a4d:	83 f8 10             	cmp    $0x10,%eax
  105a50:	75 ee                	jne    105a40 <cond_get_free_waiter+0x10>
            c->used[i] = TRUE;
            *w = &c->waiters_pool[i];
            return 0;
        }
    }
    return -1;  // No free waiter available.
  105a52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105a57:	c3                   	ret    
  105a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a5f:	90                   	nop
            c->used[i] = TRUE;
  105a60:	c6 84 02 84 00 00 00 	movb   $0x1,0x84(%edx,%eax,1)
  105a67:	01 
            *w = &c->waiters_pool[i];
  105a68:	8d 54 c2 04          	lea    0x4(%edx,%eax,8),%edx
  105a6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  105a70:	89 10                	mov    %edx,(%eax)
            return 0;
  105a72:	31 c0                	xor    %eax,%eax
  105a74:	c3                   	ret    
  105a75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105a80 <cond_release_waiter>:

// Mark a waiter slot as free.
void cond_release_waiter(cond_t *c, cond_waiter_t *w) {
  105a80:	53                   	push   %ebx
  105a81:	8b 5c 24 08          	mov    0x8(%esp),%ebx
    for (int i = 0; i < MAX_WAITERS; i++) {
  105a85:	31 d2                	xor    %edx,%edx
void cond_release_waiter(cond_t *c, cond_waiter_t *w) {
  105a87:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  105a8b:	8d 43 04             	lea    0x4(%ebx),%eax
  105a8e:	66 90                	xchg   %ax,%ax
        if (&c->waiters_pool[i] == w) {
  105a90:	39 c1                	cmp    %eax,%ecx
  105a92:	74 14                	je     105aa8 <cond_release_waiter+0x28>
    for (int i = 0; i < MAX_WAITERS; i++) {
  105a94:	83 c2 01             	add    $0x1,%edx
  105a97:	83 c0 08             	add    $0x8,%eax
  105a9a:	83 fa 10             	cmp    $0x10,%edx
  105a9d:	75 f1                	jne    105a90 <cond_release_waiter+0x10>
            c->used[i] = FALSE;
            break;
        }
    }
}
  105a9f:	5b                   	pop    %ebx
  105aa0:	c3                   	ret    
  105aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            c->used[i] = FALSE;
  105aa8:	c6 84 13 84 00 00 00 	movb   $0x0,0x84(%ebx,%edx,1)
  105aaf:	00 
}
  105ab0:	5b                   	pop    %ebx
  105ab1:	c3                   	ret    
  105ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105ac0 <cond_wait>:
//   1. Acquire a free waiter from the pool.
//   2. Insert it into the wait queue.
//   3. Release the caller's lock.
//   4. Block the current thread.
//   5. Reacquire the lock when woken.
void cond_wait(cond_t *c, spinlock_t *lk) {
  105ac0:	55                   	push   %ebp
    for (int i = 0; i < MAX_WAITERS; i++) {
  105ac1:	31 c0                	xor    %eax,%eax
void cond_wait(cond_t *c, spinlock_t *lk) {
  105ac3:	57                   	push   %edi
  105ac4:	56                   	push   %esi
  105ac5:	53                   	push   %ebx
  105ac6:	e8 be a8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105acb:	81 c3 35 b5 00 00    	add    $0xb535,%ebx
  105ad1:	83 ec 0c             	sub    $0xc,%esp
  105ad4:	8b 74 24 20          	mov    0x20(%esp),%esi
  105ad8:	8b 7c 24 24          	mov    0x24(%esp),%edi
  105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (!c->used[i]) {
  105ae0:	80 bc 06 84 00 00 00 	cmpb   $0x0,0x84(%esi,%eax,1)
  105ae7:	00 
  105ae8:	74 76                	je     105b60 <cond_wait+0xa0>
    for (int i = 0; i < MAX_WAITERS; i++) {
  105aea:	83 c0 01             	add    $0x1,%eax
  105aed:	83 f8 10             	cmp    $0x10,%eax
  105af0:	75 ee                	jne    105ae0 <cond_wait+0x20>
    cond_waiter_t *waiter;
    KERN_ASSERT(cond_get_free_waiter(c, &waiter) == 0);
  105af2:	8d 83 dc 95 ff ff    	lea    -0x6a24(%ebx),%eax
  105af8:	50                   	push   %eax
  105af9:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  105aff:	50                   	push   %eax
  105b00:	8d 83 02 96 ff ff    	lea    -0x69fe(%ebx),%eax
  105b06:	6a 2e                	push   $0x2e
  105b08:	50                   	push   %eax
  105b09:	e8 22 e5 ff ff       	call   104030 <debug_panic>
  105b0e:	83 c4 10             	add    $0x10,%esp
    waiter->pid = get_curid();
  105b11:	e8 fa 1b 00 00       	call   107710 <get_curid>
    SLIST_INSERT_HEAD(&c->waiters, waiter, entry);

    spinlock_release(lk);
  105b16:	83 ec 0c             	sub    $0xc,%esp
    waiter->pid = get_curid();
  105b19:	89 45 00             	mov    %eax,0x0(%ebp)
    SLIST_INSERT_HEAD(&c->waiters, waiter, entry);
  105b1c:	8b 06                	mov    (%esi),%eax
  105b1e:	89 45 04             	mov    %eax,0x4(%ebp)
  105b21:	89 2e                	mov    %ebp,(%esi)
    spinlock_release(lk);
  105b23:	57                   	push   %edi
  105b24:	e8 d7 fc ff ff       	call   105800 <spinlock_release>
    thread_block();
  105b29:	e8 d2 1d 00 00       	call   107900 <thread_block>
    spinlock_acquire(lk);
  105b2e:	89 3c 24             	mov    %edi,(%esp)
  105b31:	e8 4a fc ff ff       	call   105780 <spinlock_acquire>
    for (int i = 0; i < MAX_WAITERS; i++) {
  105b36:	8d 46 04             	lea    0x4(%esi),%eax
  105b39:	83 c4 10             	add    $0x10,%esp
  105b3c:	31 d2                	xor    %edx,%edx
  105b3e:	66 90                	xchg   %ax,%ax
        if (&c->waiters_pool[i] == w) {
  105b40:	39 c5                	cmp    %eax,%ebp
  105b42:	74 2c                	je     105b70 <cond_wait+0xb0>
    for (int i = 0; i < MAX_WAITERS; i++) {
  105b44:	83 c2 01             	add    $0x1,%edx
  105b47:	83 c0 08             	add    $0x8,%eax
  105b4a:	83 fa 10             	cmp    $0x10,%edx
  105b4d:	75 f1                	jne    105b40 <cond_wait+0x80>

    // Once the thread wakes up, free the waiter slot.
    cond_release_waiter(c, waiter);
}
  105b4f:	83 c4 0c             	add    $0xc,%esp
  105b52:	5b                   	pop    %ebx
  105b53:	5e                   	pop    %esi
  105b54:	5f                   	pop    %edi
  105b55:	5d                   	pop    %ebp
  105b56:	c3                   	ret    
  105b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105b5e:	66 90                	xchg   %ax,%ax
            c->used[i] = TRUE;
  105b60:	c6 84 06 84 00 00 00 	movb   $0x1,0x84(%esi,%eax,1)
  105b67:	01 
            *w = &c->waiters_pool[i];
  105b68:	8d 6c c6 04          	lea    0x4(%esi,%eax,8),%ebp
            return 0;
  105b6c:	eb a3                	jmp    105b11 <cond_wait+0x51>
  105b6e:	66 90                	xchg   %ax,%ax
            c->used[i] = FALSE;
  105b70:	c6 84 16 84 00 00 00 	movb   $0x0,0x84(%esi,%edx,1)
  105b77:	00 
}
  105b78:	83 c4 0c             	add    $0xc,%esp
  105b7b:	5b                   	pop    %ebx
  105b7c:	5e                   	pop    %esi
  105b7d:	5f                   	pop    %edi
  105b7e:	5d                   	pop    %ebp
  105b7f:	c3                   	ret    

00105b80 <cond_signal>:

// Wake one waiting thread.
void cond_signal(cond_t *c) {
  105b80:	53                   	push   %ebx
  105b81:	e8 03 a8 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105b86:	81 c3 7a b4 00 00    	add    $0xb47a,%ebx
  105b8c:	83 ec 08             	sub    $0x8,%esp
  105b8f:	8b 54 24 10          	mov    0x10(%esp),%edx
    cond_waiter_t *waiter;
    if (!SLIST_EMPTY(&c->waiters)) {
  105b93:	8b 02                	mov    (%edx),%eax
  105b95:	85 c0                	test   %eax,%eax
  105b97:	74 12                	je     105bab <cond_signal+0x2b>
        waiter = SLIST_FIRST(&c->waiters);
        SLIST_REMOVE_HEAD(&c->waiters, entry);
  105b99:	8b 48 04             	mov    0x4(%eax),%ecx
        thread_wake(waiter->pid);
  105b9c:	83 ec 0c             	sub    $0xc,%esp
        SLIST_REMOVE_HEAD(&c->waiters, entry);
  105b9f:	89 0a                	mov    %ecx,(%edx)
        thread_wake(waiter->pid);
  105ba1:	ff 30                	push   (%eax)
  105ba3:	e8 88 1d 00 00       	call   107930 <thread_wake>
  105ba8:	83 c4 10             	add    $0x10,%esp
    }
}
  105bab:	83 c4 08             	add    $0x8,%esp
  105bae:	5b                   	pop    %ebx
  105baf:	c3                   	ret    

00105bb0 <cond_broadcast>:

// Wake all waiting threads.
void cond_broadcast(cond_t *c) {
  105bb0:	56                   	push   %esi
  105bb1:	53                   	push   %ebx
  105bb2:	e8 d2 a7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105bb7:	81 c3 49 b4 00 00    	add    $0xb449,%ebx
  105bbd:	83 ec 04             	sub    $0x4,%esp
  105bc0:	8b 74 24 10          	mov    0x10(%esp),%esi
    cond_waiter_t *waiter;
    while (!SLIST_EMPTY(&c->waiters)) {
  105bc4:	8b 06                	mov    (%esi),%eax
  105bc6:	85 c0                	test   %eax,%eax
  105bc8:	74 1e                	je     105be8 <cond_broadcast+0x38>
  105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        waiter = SLIST_FIRST(&c->waiters);
        SLIST_REMOVE_HEAD(&c->waiters, entry);
  105bd0:	8b 50 04             	mov    0x4(%eax),%edx
        thread_wake(waiter->pid);
  105bd3:	83 ec 0c             	sub    $0xc,%esp
        SLIST_REMOVE_HEAD(&c->waiters, entry);
  105bd6:	89 16                	mov    %edx,(%esi)
        thread_wake(waiter->pid);
  105bd8:	ff 30                	push   (%eax)
  105bda:	e8 51 1d 00 00       	call   107930 <thread_wake>
    while (!SLIST_EMPTY(&c->waiters)) {
  105bdf:	8b 06                	mov    (%esi),%eax
  105be1:	83 c4 10             	add    $0x10,%esp
  105be4:	85 c0                	test   %eax,%eax
  105be6:	75 e8                	jne    105bd0 <cond_broadcast+0x20>
    }
}
  105be8:	83 c4 04             	add    $0x4,%esp
  105beb:	5b                   	pop    %ebx
  105bec:	5e                   	pop    %esi
  105bed:	c3                   	ret    
  105bee:	66 90                	xchg   %ax,%ax

00105bf0 <bb_init>:
#include <lib/debug.h>
#include <pcpu/PCPUIntro/export.h>
#include <thread/PCurID/export.h>


void bb_init(bounded_buffer_t *bb) {
  105bf0:	56                   	push   %esi
  105bf1:	53                   	push   %ebx
  105bf2:	e8 92 a7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105bf7:	81 c3 09 b4 00 00    	add    $0xb409,%ebx
  105bfd:	83 ec 10             	sub    $0x10,%esp
  105c00:	8b 74 24 1c          	mov    0x1c(%esp),%esi
    bb->in = 0;
    bb->out = 0;
    bb->count = 0;
    spinlock_init(&bb->lock);
  105c04:	8d 46 4c             	lea    0x4c(%esi),%eax
    bb->in = 0;
  105c07:	c7 46 40 00 00 00 00 	movl   $0x0,0x40(%esi)
    bb->out = 0;
  105c0e:	c7 46 44 00 00 00 00 	movl   $0x0,0x44(%esi)
    bb->count = 0;
  105c15:	c7 46 48 00 00 00 00 	movl   $0x0,0x48(%esi)
    spinlock_init(&bb->lock);
  105c1c:	50                   	push   %eax
  105c1d:	e8 ce fa ff ff       	call   1056f0 <spinlock_init>
    cond_init(&bb->not_full);
  105c22:	8d 46 54             	lea    0x54(%esi),%eax
    cond_init(&bb->not_empty);
  105c25:	81 c6 e8 00 00 00    	add    $0xe8,%esi
    cond_init(&bb->not_full);
  105c2b:	89 04 24             	mov    %eax,(%esp)
  105c2e:	e8 cd fd ff ff       	call   105a00 <cond_init>
    cond_init(&bb->not_empty);
  105c33:	89 34 24             	mov    %esi,(%esp)
  105c36:	e8 c5 fd ff ff       	call   105a00 <cond_init>
}
  105c3b:	83 c4 14             	add    $0x14,%esp
  105c3e:	5b                   	pop    %ebx
  105c3f:	5e                   	pop    %esi
  105c40:	c3                   	ret    
  105c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105c4f:	90                   	nop

00105c50 <bb_produce>:

// Produce an item: insert it into the buffer.
// If the buffer is full, block until space becomes available.
void bb_produce(bounded_buffer_t *bb, int item) {
  105c50:	55                   	push   %ebp
  105c51:	57                   	push   %edi
  105c52:	56                   	push   %esi
  105c53:	53                   	push   %ebx
  105c54:	e8 30 a7 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105c59:	81 c3 a7 b3 00 00    	add    $0xb3a7,%ebx
  105c5f:	83 ec 18             	sub    $0x18,%esp
  105c62:	8b 74 24 2c          	mov    0x2c(%esp),%esi
    spinlock_acquire(&bb->lock);
  105c66:	8d 7e 4c             	lea    0x4c(%esi),%edi
  105c69:	57                   	push   %edi
  105c6a:	e8 11 fb ff ff       	call   105780 <spinlock_acquire>
    
    // Wait until there is space in the buffer.
    while (bb->count == BBUF_SIZE) {
  105c6f:	8b 46 48             	mov    0x48(%esi),%eax
  105c72:	83 c4 10             	add    $0x10,%esp
  105c75:	83 f8 10             	cmp    $0x10,%eax
  105c78:	75 1b                	jne    105c95 <bb_produce+0x45>
        cond_wait(&bb->not_full, &bb->lock);
  105c7a:	8d 6e 54             	lea    0x54(%esi),%ebp
  105c7d:	8d 76 00             	lea    0x0(%esi),%esi
  105c80:	83 ec 08             	sub    $0x8,%esp
  105c83:	57                   	push   %edi
  105c84:	55                   	push   %ebp
  105c85:	e8 36 fe ff ff       	call   105ac0 <cond_wait>
    while (bb->count == BBUF_SIZE) {
  105c8a:	8b 46 48             	mov    0x48(%esi),%eax
  105c8d:	83 c4 10             	add    $0x10,%esp
  105c90:	83 f8 10             	cmp    $0x10,%eax
  105c93:	74 eb                	je     105c80 <bb_produce+0x30>
    }
    
    // Insert the item.
    bb->buf[bb->in] = item;
  105c95:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  105c99:	8b 56 40             	mov    0x40(%esi),%edx
    bb->in = (bb->in + 1) % BBUF_SIZE;
    bb->count++;
  105c9c:	83 c0 01             	add    $0x1,%eax
    
    // Signal that the buffer is not empty.
    cond_signal(&bb->not_empty);
  105c9f:	83 ec 0c             	sub    $0xc,%esp
    bb->buf[bb->in] = item;
  105ca2:	89 0c 96             	mov    %ecx,(%esi,%edx,4)
    bb->in = (bb->in + 1) % BBUF_SIZE;
  105ca5:	83 c2 01             	add    $0x1,%edx
  105ca8:	89 d1                	mov    %edx,%ecx
    bb->count++;
  105caa:	89 46 48             	mov    %eax,0x48(%esi)
    cond_signal(&bb->not_empty);
  105cad:	8d 86 e8 00 00 00    	lea    0xe8(%esi),%eax
    bb->in = (bb->in + 1) % BBUF_SIZE;
  105cb3:	c1 f9 1f             	sar    $0x1f,%ecx
  105cb6:	c1 e9 1c             	shr    $0x1c,%ecx
  105cb9:	01 ca                	add    %ecx,%edx
  105cbb:	83 e2 0f             	and    $0xf,%edx
  105cbe:	29 ca                	sub    %ecx,%edx
  105cc0:	89 56 40             	mov    %edx,0x40(%esi)
    cond_signal(&bb->not_empty);
  105cc3:	50                   	push   %eax
  105cc4:	e8 b7 fe ff ff       	call   105b80 <cond_signal>
    
    spinlock_release(&bb->lock);
  105cc9:	89 3c 24             	mov    %edi,(%esp)
  105ccc:	e8 2f fb ff ff       	call   105800 <spinlock_release>
    
    // Debug output (optional)
    KERN_DEBUG("CPU %d: Process %d: Produced %d, count=%d\n", get_pcpu_idx(), get_curid(), item, bb->count);
  105cd1:	8b 7e 48             	mov    0x48(%esi),%edi
  105cd4:	e8 37 1a 00 00       	call   107710 <get_curid>
  105cd9:	89 c6                	mov    %eax,%esi
  105cdb:	e8 70 01 00 00       	call   105e50 <get_pcpu_idx>
  105ce0:	83 c4 0c             	add    $0xc,%esp
  105ce3:	57                   	push   %edi
  105ce4:	ff 74 24 2c          	push   0x2c(%esp)
  105ce8:	56                   	push   %esi
  105ce9:	50                   	push   %eax
  105cea:	8d 83 14 96 ff ff    	lea    -0x69ec(%ebx),%eax
  105cf0:	50                   	push   %eax
  105cf1:	8d 83 6b 96 ff ff    	lea    -0x6995(%ebx),%eax
  105cf7:	6a 25                	push   $0x25
  105cf9:	50                   	push   %eax
  105cfa:	e8 f1 e2 ff ff       	call   103ff0 <debug_normal>
}
  105cff:	83 c4 2c             	add    $0x2c,%esp
  105d02:	5b                   	pop    %ebx
  105d03:	5e                   	pop    %esi
  105d04:	5f                   	pop    %edi
  105d05:	5d                   	pop    %ebp
  105d06:	c3                   	ret    
  105d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105d0e:	66 90                	xchg   %ax,%ax

00105d10 <bb_consume>:

// Consume an item: remove it from the buffer.
// If the buffer is empty, block until an item is available.
int bb_consume(bounded_buffer_t *bb) {
  105d10:	55                   	push   %ebp
  105d11:	57                   	push   %edi
  105d12:	56                   	push   %esi
  105d13:	53                   	push   %ebx
  105d14:	e8 70 a6 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105d19:	81 c3 e7 b2 00 00    	add    $0xb2e7,%ebx
  105d1f:	83 ec 18             	sub    $0x18,%esp
  105d22:	8b 74 24 2c          	mov    0x2c(%esp),%esi
    int item;
    
    spinlock_acquire(&bb->lock);
  105d26:	8d 7e 4c             	lea    0x4c(%esi),%edi
  105d29:	57                   	push   %edi
  105d2a:	e8 51 fa ff ff       	call   105780 <spinlock_acquire>
    
    // Wait until there is an item in the buffer.
    while (bb->count == 0) {
  105d2f:	8b 46 48             	mov    0x48(%esi),%eax
  105d32:	83 c4 10             	add    $0x10,%esp
  105d35:	85 c0                	test   %eax,%eax
  105d37:	75 1b                	jne    105d54 <bb_consume+0x44>
        cond_wait(&bb->not_empty, &bb->lock);
  105d39:	8d ae e8 00 00 00    	lea    0xe8(%esi),%ebp
  105d3f:	90                   	nop
  105d40:	83 ec 08             	sub    $0x8,%esp
  105d43:	57                   	push   %edi
  105d44:	55                   	push   %ebp
  105d45:	e8 76 fd ff ff       	call   105ac0 <cond_wait>
    while (bb->count == 0) {
  105d4a:	8b 46 48             	mov    0x48(%esi),%eax
  105d4d:	83 c4 10             	add    $0x10,%esp
  105d50:	85 c0                	test   %eax,%eax
  105d52:	74 ec                	je     105d40 <bb_consume+0x30>
    }
    
    // Remove the item.
    item = bb->buf[bb->out];
  105d54:	8b 56 44             	mov    0x44(%esi),%edx
    bb->out = (bb->out + 1) % BBUF_SIZE;
    bb->count--;
  105d57:	83 e8 01             	sub    $0x1,%eax
    
    // Signal that the buffer is not full.
    cond_signal(&bb->not_full);
  105d5a:	83 ec 0c             	sub    $0xc,%esp
    item = bb->buf[bb->out];
  105d5d:	8b 2c 96             	mov    (%esi,%edx,4),%ebp
    bb->out = (bb->out + 1) % BBUF_SIZE;
  105d60:	83 c2 01             	add    $0x1,%edx
    bb->count--;
  105d63:	89 46 48             	mov    %eax,0x48(%esi)
    cond_signal(&bb->not_full);
  105d66:	8d 46 54             	lea    0x54(%esi),%eax
    bb->out = (bb->out + 1) % BBUF_SIZE;
  105d69:	89 d1                	mov    %edx,%ecx
  105d6b:	c1 f9 1f             	sar    $0x1f,%ecx
  105d6e:	c1 e9 1c             	shr    $0x1c,%ecx
  105d71:	01 ca                	add    %ecx,%edx
  105d73:	83 e2 0f             	and    $0xf,%edx
  105d76:	29 ca                	sub    %ecx,%edx
  105d78:	89 56 44             	mov    %edx,0x44(%esi)
    cond_signal(&bb->not_full);
  105d7b:	50                   	push   %eax
  105d7c:	e8 ff fd ff ff       	call   105b80 <cond_signal>
    
    spinlock_release(&bb->lock);
  105d81:	89 3c 24             	mov    %edi,(%esp)
  105d84:	e8 77 fa ff ff       	call   105800 <spinlock_release>
    
    // Debug output (optional)
    KERN_DEBUG("CPU %d: Process %d: Consumed %d, count=%d\n", get_pcpu_idx(), get_curid(), item, bb->count);
  105d89:	8b 7e 48             	mov    0x48(%esi),%edi
  105d8c:	e8 7f 19 00 00       	call   107710 <get_curid>
  105d91:	89 c6                	mov    %eax,%esi
  105d93:	e8 b8 00 00 00       	call   105e50 <get_pcpu_idx>
  105d98:	83 c4 0c             	add    $0xc,%esp
  105d9b:	57                   	push   %edi
  105d9c:	55                   	push   %ebp
  105d9d:	56                   	push   %esi
  105d9e:	50                   	push   %eax
  105d9f:	8d 83 40 96 ff ff    	lea    -0x69c0(%ebx),%eax
  105da5:	50                   	push   %eax
  105da6:	8d 83 6b 96 ff ff    	lea    -0x6995(%ebx),%eax
  105dac:	6a 3f                	push   $0x3f
  105dae:	50                   	push   %eax
  105daf:	e8 3c e2 ff ff       	call   103ff0 <debug_normal>
    
    return item;
}
  105db4:	83 c4 2c             	add    $0x2c,%esp
  105db7:	89 e8                	mov    %ebp,%eax
  105db9:	5b                   	pop    %ebx
  105dba:	5e                   	pop    %esi
  105dbb:	5f                   	pop    %edi
  105dbc:	5d                   	pop    %ebp
  105dbd:	c3                   	ret    
  105dbe:	66 90                	xchg   %ax,%ax

00105dc0 <pcpu_set_zero>:
struct pcpu pcpu[NUM_CPUS];

extern int get_kstack_cpu_idx(void);

void pcpu_set_zero()
{
  105dc0:	53                   	push   %ebx
  105dc1:	e8 c3 a5 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105dc6:	81 c3 3a b2 00 00    	add    $0xb23a,%ebx
  105dcc:	83 ec 10             	sub    $0x10,%esp
    memzero(pcpu, sizeof(struct pcpu) * NUM_CPUS);
  105dcf:	68 80 02 00 00       	push   $0x280
  105dd4:	8d 83 00 10 07 00    	lea    0x71000(%ebx),%eax
  105dda:	50                   	push   %eax
  105ddb:	e8 50 e1 ff ff       	call   103f30 <memzero>
}
  105de0:	83 c4 18             	add    $0x18,%esp
  105de3:	5b                   	pop    %ebx
  105de4:	c3                   	ret    
  105de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105df0 <pcpu_fields_init>:

void pcpu_fields_init(int cpu_idx)
{
    pcpu[cpu_idx].inited = TRUE;
  105df0:	e8 9e ea ff ff       	call   104893 <__x86.get_pc_thunk.cx>
  105df5:	81 c1 0b b2 00 00    	add    $0xb20b,%ecx
{
  105dfb:	8b 54 24 04          	mov    0x4(%esp),%edx
    pcpu[cpu_idx].inited = TRUE;
  105dff:	8d 04 92             	lea    (%edx,%edx,4),%eax
  105e02:	c1 e0 04             	shl    $0x4,%eax
  105e05:	c6 84 01 00 10 07 00 	movb   $0x1,0x71000(%ecx,%eax,1)
  105e0c:	01 
    pcpu[cpu_idx].cpu_idx = cpu_idx;
  105e0d:	89 94 01 4c 10 07 00 	mov    %edx,0x7104c(%ecx,%eax,1)
}
  105e14:	c3                   	ret    
  105e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105e20 <pcpu_cur>:

struct pcpu *pcpu_cur(void)
{
  105e20:	53                   	push   %ebx
  105e21:	e8 63 a5 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105e26:	81 c3 da b1 00 00    	add    $0xb1da,%ebx
  105e2c:	83 ec 08             	sub    $0x8,%esp
    int cpu_idx = get_kstack_cpu_idx();
  105e2f:	e8 8c f8 ff ff       	call   1056c0 <get_kstack_cpu_idx>
    return &pcpu[cpu_idx];
}
  105e34:	83 c4 08             	add    $0x8,%esp
    return &pcpu[cpu_idx];
  105e37:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105e3a:	c1 e0 04             	shl    $0x4,%eax
  105e3d:	8d 84 03 00 10 07 00 	lea    0x71000(%ebx,%eax,1),%eax
}
  105e44:	5b                   	pop    %ebx
  105e45:	c3                   	ret    
  105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e4d:	8d 76 00             	lea    0x0(%esi),%esi

00105e50 <get_pcpu_idx>:

int get_pcpu_idx(void)
{
  105e50:	53                   	push   %ebx
  105e51:	e8 33 a5 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105e56:	81 c3 aa b1 00 00    	add    $0xb1aa,%ebx
  105e5c:	83 ec 08             	sub    $0x8,%esp
    int cpu_idx = get_kstack_cpu_idx();
  105e5f:	e8 5c f8 ff ff       	call   1056c0 <get_kstack_cpu_idx>
    return pcpu_cur()->cpu_idx;
  105e64:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105e67:	c1 e0 04             	shl    $0x4,%eax
  105e6a:	8b 84 03 4c 10 07 00 	mov    0x7104c(%ebx,%eax,1),%eax
}
  105e71:	83 c4 08             	add    $0x8,%esp
  105e74:	5b                   	pop    %ebx
  105e75:	c3                   	ret    
  105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e7d:	8d 76 00             	lea    0x0(%esi),%esi

00105e80 <set_pcpu_idx>:

void set_pcpu_idx(int index, int cpu_idx)
{
    pcpu[index].cpu_idx = cpu_idx;
  105e80:	e8 00 a5 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105e85:	81 c2 7b b1 00 00    	add    $0xb17b,%edx
{
  105e8b:	8b 44 24 04          	mov    0x4(%esp),%eax
    pcpu[index].cpu_idx = cpu_idx;
  105e8f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  105e93:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105e96:	c1 e0 04             	shl    $0x4,%eax
  105e99:	89 8c 02 4c 10 07 00 	mov    %ecx,0x7104c(%edx,%eax,1)
}
  105ea0:	c3                   	ret    
  105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105eaf:	90                   	nop

00105eb0 <get_pcpu_kstack_pointer>:

uintptr_t *get_pcpu_kstack_pointer(int cpu_idx)
{
    return pcpu[cpu_idx].kstack;
  105eb0:	e8 d0 a4 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105eb5:	81 c2 4b b1 00 00    	add    $0xb14b,%edx
{
  105ebb:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].kstack;
  105ebf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105ec2:	c1 e0 04             	shl    $0x4,%eax
  105ec5:	8b 84 02 04 10 07 00 	mov    0x71004(%edx,%eax,1),%eax
}
  105ecc:	c3                   	ret    
  105ecd:	8d 76 00             	lea    0x0(%esi),%esi

00105ed0 <set_pcpu_kstack_pointer>:

void set_pcpu_kstack_pointer(int cpu_idx, uintptr_t *ks)
{
    pcpu[cpu_idx].kstack = ks;
  105ed0:	e8 b0 a4 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105ed5:	81 c2 2b b1 00 00    	add    $0xb12b,%edx
{
  105edb:	8b 44 24 04          	mov    0x4(%esp),%eax
    pcpu[cpu_idx].kstack = ks;
  105edf:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  105ee3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105ee6:	c1 e0 04             	shl    $0x4,%eax
  105ee9:	89 8c 02 04 10 07 00 	mov    %ecx,0x71004(%edx,%eax,1)
}
  105ef0:	c3                   	ret    
  105ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105eff:	90                   	nop

00105f00 <get_pcpu_boot_info>:

volatile bool get_pcpu_boot_info(int cpu_idx)
{
    return pcpu[cpu_idx].booted;
  105f00:	e8 80 a4 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105f05:	81 c2 fb b0 00 00    	add    $0xb0fb,%edx
{
  105f0b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].booted;
  105f0f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105f12:	c1 e0 04             	shl    $0x4,%eax
  105f15:	8d 84 02 00 10 07 00 	lea    0x71000(%edx,%eax,1),%eax
  105f1c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
}
  105f20:	c3                   	ret    
  105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105f2f:	90                   	nop

00105f30 <set_pcpu_boot_info>:

void set_pcpu_boot_info(int cpu_idx, volatile bool boot_info)
{
    pcpu[cpu_idx].booted = boot_info;
  105f30:	e8 5e e9 ff ff       	call   104893 <__x86.get_pc_thunk.cx>
  105f35:	81 c1 cb b0 00 00    	add    $0xb0cb,%ecx
{
  105f3b:	83 ec 04             	sub    $0x4,%esp
  105f3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  105f42:	8b 54 24 0c          	mov    0xc(%esp),%edx
    pcpu[cpu_idx].booted = boot_info;
  105f46:	8d 04 80             	lea    (%eax,%eax,4),%eax
{
  105f49:	88 14 24             	mov    %dl,(%esp)
    pcpu[cpu_idx].booted = boot_info;
  105f4c:	0f b6 14 24          	movzbl (%esp),%edx
  105f50:	c1 e0 04             	shl    $0x4,%eax
  105f53:	8d 84 01 00 10 07 00 	lea    0x71000(%ecx,%eax,1),%eax
  105f5a:	88 50 01             	mov    %dl,0x1(%eax)
}
  105f5d:	83 c4 04             	add    $0x4,%esp
  105f60:	c3                   	ret    
  105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105f6f:	90                   	nop

00105f70 <get_pcpu_cpu_vendor>:

cpu_vendor get_pcpu_cpu_vendor(int cpu_idx)
{
    return pcpu[cpu_idx].arch_info.cpu_vendor;
  105f70:	e8 10 a4 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105f75:	81 c2 8b b0 00 00    	add    $0xb08b,%edx
{
  105f7b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].arch_info.cpu_vendor;
  105f7f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105f82:	c1 e0 04             	shl    $0x4,%eax
  105f85:	8b 84 02 28 10 07 00 	mov    0x71028(%edx,%eax,1),%eax
}
  105f8c:	c3                   	ret    
  105f8d:	8d 76 00             	lea    0x0(%esi),%esi

00105f90 <get_pcpu_arch_info_pointer>:

uintptr_t *get_pcpu_arch_info_pointer(int cpu_idx)
{
    return (uintptr_t *) &pcpu[cpu_idx].arch_info;
  105f90:	e8 f0 a3 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105f95:	81 c2 6b b0 00 00    	add    $0xb06b,%edx
{
  105f9b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return (uintptr_t *) &pcpu[cpu_idx].arch_info;
  105f9f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105fa2:	c1 e0 04             	shl    $0x4,%eax
  105fa5:	8d 84 02 08 10 07 00 	lea    0x71008(%edx,%eax,1),%eax
}
  105fac:	c3                   	ret    
  105fad:	8d 76 00             	lea    0x0(%esi),%esi

00105fb0 <get_pcpu_inited_info>:

bool get_pcpu_inited_info(int cpu_idx)
{
    return pcpu[cpu_idx].inited;
  105fb0:	e8 d0 a3 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  105fb5:	81 c2 4b b0 00 00    	add    $0xb04b,%edx
{
  105fbb:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].inited;
  105fbf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105fc2:	c1 e0 04             	shl    $0x4,%eax
  105fc5:	0f b6 84 02 00 10 07 	movzbl 0x71000(%edx,%eax,1),%eax
  105fcc:	00 
}
  105fcd:	c3                   	ret    
  105fce:	66 90                	xchg   %ax,%ax

00105fd0 <pcpu_init>:
#include "import.h"

static bool pcpu_inited = FALSE;

void pcpu_init(void)
{
  105fd0:	55                   	push   %ebp
  105fd1:	57                   	push   %edi
  105fd2:	56                   	push   %esi
  105fd3:	53                   	push   %ebx
  105fd4:	e8 b0 a3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  105fd9:	81 c3 27 b0 00 00    	add    $0xb027,%ebx
  105fdf:	83 ec 0c             	sub    $0xc,%esp
    struct kstack *ks = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105fe2:	e8 49 ec ff ff       	call   104c30 <read_esp>
  105fe7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    int cpu_idx = ks->cpu_idx;
  105fec:	8b b8 1c 01 00 00    	mov    0x11c(%eax),%edi
    struct kstack *ks = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105ff2:	89 c5                	mov    %eax,%ebp
    int i;

    if (cpu_idx == 0) {
  105ff4:	85 ff                	test   %edi,%edi
  105ff6:	75 33                	jne    10602b <pcpu_init+0x5b>
        if (pcpu_inited == TRUE)
  105ff8:	80 bb 80 12 07 00 01 	cmpb   $0x1,0x71280(%ebx)
  105fff:	74 4f                	je     106050 <pcpu_init+0x80>
            return;

        pcpu_set_zero();
  106001:	e8 ba fd ff ff       	call   105dc0 <pcpu_set_zero>

        /* Probe SMP. */
        pcpu_mp_init();

        for (i = 0; i < NUM_CPUS; i++) {
  106006:	31 f6                	xor    %esi,%esi
        pcpu_mp_init();
  106008:	e8 23 ce ff ff       	call   102e30 <pcpu_mp_init>
        for (i = 0; i < NUM_CPUS; i++) {
  10600d:	8d 76 00             	lea    0x0(%esi),%esi
            pcpu_fields_init(i);
  106010:	83 ec 0c             	sub    $0xc,%esp
  106013:	56                   	push   %esi
        for (i = 0; i < NUM_CPUS; i++) {
  106014:	83 c6 01             	add    $0x1,%esi
            pcpu_fields_init(i);
  106017:	e8 d4 fd ff ff       	call   105df0 <pcpu_fields_init>
        for (i = 0; i < NUM_CPUS; i++) {
  10601c:	83 c4 10             	add    $0x10,%esp
  10601f:	83 fe 08             	cmp    $0x8,%esi
  106022:	75 ec                	jne    106010 <pcpu_init+0x40>
        }

        pcpu_inited = TRUE;
  106024:	c6 83 80 12 07 00 01 	movb   $0x1,0x71280(%ebx)
    }

    set_pcpu_idx(cpu_idx, cpu_idx);
  10602b:	83 ec 08             	sub    $0x8,%esp
  10602e:	57                   	push   %edi
  10602f:	57                   	push   %edi
  106030:	e8 4b fe ff ff       	call   105e80 <set_pcpu_idx>
    set_pcpu_kstack_pointer(cpu_idx, (uintptr_t *) ks);
  106035:	58                   	pop    %eax
  106036:	5a                   	pop    %edx
  106037:	55                   	push   %ebp
  106038:	57                   	push   %edi
  106039:	e8 92 fe ff ff       	call   105ed0 <set_pcpu_kstack_pointer>
    set_pcpu_boot_info(cpu_idx, TRUE);
  10603e:	59                   	pop    %ecx
  10603f:	5e                   	pop    %esi
  106040:	6a 01                	push   $0x1
  106042:	57                   	push   %edi
  106043:	e8 e8 fe ff ff       	call   105f30 <set_pcpu_boot_info>
    pcpu_init_cpu();
  106048:	e8 e3 d5 ff ff       	call   103630 <pcpu_init_cpu>
  10604d:	83 c4 10             	add    $0x10,%esp
}
  106050:	83 c4 0c             	add    $0xc,%esp
  106053:	5b                   	pop    %ebx
  106054:	5e                   	pop    %esi
  106055:	5f                   	pop    %edi
  106056:	5d                   	pop    %ebp
  106057:	c3                   	ret    
  106058:	66 90                	xchg   %ax,%ax
  10605a:	66 90                	xchg   %ax,%ax
  10605c:	66 90                	xchg   %ax,%ax
  10605e:	66 90                	xchg   %ax,%ax

00106060 <kern_main_ap>:
    dprintf("\nTest complete. Please Use Ctrl-a x to exit qemu.");
#endif
}

static void kern_main_ap(void)
{
  106060:	55                   	push   %ebp
  106061:	57                   	push   %edi
  106062:	56                   	push   %esi
  106063:	53                   	push   %ebx
  106064:	e8 20 a3 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106069:	81 c3 97 af 00 00    	add    $0xaf97,%ebx
  10606f:	83 ec 0c             	sub    $0xc,%esp
    unsigned int pid, pid2;
    int cpu_idx = get_pcpu_idx();
  106072:	e8 d9 fd ff ff       	call   105e50 <get_pcpu_idx>

    set_pcpu_boot_info(cpu_idx, TRUE);
  106077:	83 ec 08             	sub    $0x8,%esp
  10607a:	6a 01                	push   $0x1
    int cpu_idx = get_pcpu_idx();
  10607c:	89 c6                	mov    %eax,%esi
    set_pcpu_boot_info(cpu_idx, TRUE);
  10607e:	50                   	push   %eax
  10607f:	e8 ac fe ff ff       	call   105f30 <set_pcpu_boot_info>

    while (all_ready == FALSE);
  106084:	83 c4 10             	add    $0x10,%esp
  106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10608e:	66 90                	xchg   %ax,%ax
  106090:	8b 83 3c 14 07 00    	mov    0x7143c(%ebx),%eax
  106096:	85 c0                	test   %eax,%eax
  106098:	74 f6                	je     106090 <kern_main_ap+0x30>

    KERN_INFO("[AP%d KERN] kernel_main_ap\n", cpu_idx);
  10609a:	83 ec 08             	sub    $0x8,%esp
  10609d:	8d 83 85 96 ff ff    	lea    -0x697b(%ebx),%eax
  1060a3:	56                   	push   %esi
  1060a4:	50                   	push   %eax
  1060a5:	e8 16 df ff ff       	call   103fc0 <debug_info>

    cpu_booted++;
  1060aa:	8b 83 40 14 07 00    	mov    0x71440(%ebx),%eax

#ifndef TEST
    if (cpu_idx == 1) {
  1060b0:	83 c4 10             	add    $0x10,%esp
    cpu_booted++;
  1060b3:	83 c0 01             	add    $0x1,%eax
  1060b6:	89 83 40 14 07 00    	mov    %eax,0x71440(%ebx)
    if (cpu_idx == 1) {
  1060bc:	83 fe 01             	cmp    $0x1,%esi
  1060bf:	0f 84 c3 00 00 00    	je     106188 <kern_main_ap+0x128>
        KERN_INFO("CPU%d: process ping1 %d is created.\n", cpu_idx, pid);
        pid2 = proc_create(_binary___obj_user_pingpong_ping_start, 1000);
        KERN_INFO("CPU%d: process ping2 %d is created.\n", cpu_idx, pid2);
        proc_create(_binary___obj_user_idle_idle_start, 1000);
    }
    else if (cpu_idx == 2) {
  1060c5:	83 fe 02             	cmp    $0x2,%esi
  1060c8:	74 0e                	je     1060d8 <kern_main_ap+0x78>
    set_curid(pid);
    kctx_switch(0, pid);

    KERN_PANIC("kern_main_ap() should never reach here.\n");
#endif
}
  1060ca:	83 c4 0c             	add    $0xc,%esp
  1060cd:	5b                   	pop    %ebx
  1060ce:	5e                   	pop    %esi
  1060cf:	5f                   	pop    %edi
  1060d0:	5d                   	pop    %ebp
  1060d1:	c3                   	ret    
  1060d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pid = proc_create(_binary___obj_user_pingpong_pong_start, 1000);
  1060d8:	c7 c5 3e 48 12 00    	mov    $0x12483e,%ebp
  1060de:	83 ec 08             	sub    $0x8,%esp
  1060e1:	68 e8 03 00 00       	push   $0x3e8
  1060e6:	55                   	push   %ebp
  1060e7:	e8 14 19 00 00       	call   107a00 <proc_create>
        KERN_INFO("CPU%d: process pong1 %d is created.\n", cpu_idx, pid);
  1060ec:	83 c4 0c             	add    $0xc,%esp
  1060ef:	50                   	push   %eax
        pid = proc_create(_binary___obj_user_pingpong_pong_start, 1000);
  1060f0:	89 c7                	mov    %eax,%edi
        KERN_INFO("CPU%d: process pong1 %d is created.\n", cpu_idx, pid);
  1060f2:	8d 83 68 97 ff ff    	lea    -0x6898(%ebx),%eax
  1060f8:	6a 02                	push   $0x2
  1060fa:	50                   	push   %eax
  1060fb:	e8 c0 de ff ff       	call   103fc0 <debug_info>
        pid2 = proc_create(_binary___obj_user_pingpong_pong_start, 1000);
  106100:	58                   	pop    %eax
  106101:	5a                   	pop    %edx
  106102:	68 e8 03 00 00       	push   $0x3e8
  106107:	55                   	push   %ebp
  106108:	e8 f3 18 00 00       	call   107a00 <proc_create>
        KERN_INFO("CPU%d: process pong2 %d is created.\n", cpu_idx, pid2);
  10610d:	83 c4 0c             	add    $0xc,%esp
  106110:	50                   	push   %eax
  106111:	8d 83 90 97 ff ff    	lea    -0x6870(%ebx),%eax
  106117:	6a 02                	push   $0x2
  106119:	50                   	push   %eax
    tqueue_remove(NUM_IDS + cpu_idx, pid);
  10611a:	83 c6 40             	add    $0x40,%esi
        KERN_INFO("CPU%d: process pong2 %d is created.\n", cpu_idx, pid2);
  10611d:	e8 9e de ff ff       	call   103fc0 <debug_info>
        proc_create(_binary___obj_user_idle_idle_start, 1000);
  106122:	58                   	pop    %eax
  106123:	5a                   	pop    %edx
  106124:	68 e8 03 00 00       	push   $0x3e8
  106129:	ff b3 ec ff ff ff    	push   -0x14(%ebx)
  10612f:	e8 cc 18 00 00       	call   107a00 <proc_create>
  106134:	83 c4 10             	add    $0x10,%esp
    tqueue_remove(NUM_IDS + cpu_idx, pid);
  106137:	83 ec 08             	sub    $0x8,%esp
  10613a:	57                   	push   %edi
  10613b:	56                   	push   %esi
  10613c:	e8 df 14 00 00       	call   107620 <tqueue_remove>
    tcb_set_state(pid, TSTATE_RUN);
  106141:	59                   	pop    %ecx
  106142:	5e                   	pop    %esi
  106143:	6a 01                	push   $0x1
  106145:	57                   	push   %edi
  106146:	e8 65 11 00 00       	call   1072b0 <tcb_set_state>
    set_curid(pid);
  10614b:	89 3c 24             	mov    %edi,(%esp)
  10614e:	e8 dd 15 00 00       	call   107730 <set_curid>
    kctx_switch(0, pid);
  106153:	5d                   	pop    %ebp
  106154:	58                   	pop    %eax
  106155:	57                   	push   %edi
  106156:	6a 00                	push   $0x0
  106158:	e8 33 10 00 00       	call   107190 <kctx_switch>
    KERN_PANIC("kern_main_ap() should never reach here.\n");
  10615d:	83 c4 0c             	add    $0xc,%esp
  106160:	8d 83 b8 97 ff ff    	lea    -0x6848(%ebx),%eax
  106166:	50                   	push   %eax
  106167:	8d 83 a1 96 ff ff    	lea    -0x695f(%ebx),%eax
  10616d:	68 8c 00 00 00       	push   $0x8c
  106172:	50                   	push   %eax
  106173:	e8 b8 de ff ff       	call   104030 <debug_panic>
  106178:	83 c4 10             	add    $0x10,%esp
}
  10617b:	83 c4 0c             	add    $0xc,%esp
  10617e:	5b                   	pop    %ebx
  10617f:	5e                   	pop    %esi
  106180:	5f                   	pop    %edi
  106181:	5d                   	pop    %ebp
  106182:	c3                   	ret    
  106183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106187:	90                   	nop
        pid = proc_create(_binary___obj_user_pingpong_ping_start, 1000);
  106188:	c7 c5 26 ad 11 00    	mov    $0x11ad26,%ebp
  10618e:	83 ec 08             	sub    $0x8,%esp
  106191:	68 e8 03 00 00       	push   $0x3e8
  106196:	55                   	push   %ebp
  106197:	e8 64 18 00 00       	call   107a00 <proc_create>
        KERN_INFO("CPU%d: process ping1 %d is created.\n", cpu_idx, pid);
  10619c:	83 c4 0c             	add    $0xc,%esp
  10619f:	50                   	push   %eax
        pid = proc_create(_binary___obj_user_pingpong_ping_start, 1000);
  1061a0:	89 c7                	mov    %eax,%edi
        KERN_INFO("CPU%d: process ping1 %d is created.\n", cpu_idx, pid);
  1061a2:	8d 83 18 97 ff ff    	lea    -0x68e8(%ebx),%eax
  1061a8:	6a 01                	push   $0x1
  1061aa:	50                   	push   %eax
  1061ab:	e8 10 de ff ff       	call   103fc0 <debug_info>
        pid2 = proc_create(_binary___obj_user_pingpong_ping_start, 1000);
  1061b0:	59                   	pop    %ecx
  1061b1:	58                   	pop    %eax
  1061b2:	68 e8 03 00 00       	push   $0x3e8
  1061b7:	55                   	push   %ebp
  1061b8:	e8 43 18 00 00       	call   107a00 <proc_create>
        KERN_INFO("CPU%d: process ping2 %d is created.\n", cpu_idx, pid2);
  1061bd:	83 c4 0c             	add    $0xc,%esp
  1061c0:	50                   	push   %eax
  1061c1:	8d 83 40 97 ff ff    	lea    -0x68c0(%ebx),%eax
  1061c7:	6a 01                	push   $0x1
  1061c9:	e9 4b ff ff ff       	jmp    106119 <kern_main_ap+0xb9>
  1061ce:	66 90                	xchg   %ax,%ax

001061d0 <kern_init>:

void kern_init(uintptr_t mbi_addr)
{
  1061d0:	55                   	push   %ebp
  1061d1:	57                   	push   %edi
  1061d2:	56                   	push   %esi
  1061d3:	53                   	push   %ebx
  1061d4:	e8 b0 a1 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1061d9:	81 c3 27 ae 00 00    	add    $0xae27,%ebx
  1061df:	83 ec 28             	sub    $0x28,%esp
    thread_init(mbi_addr);
  1061e2:	ff 74 24 3c          	push   0x3c(%esp)
  1061e6:	e8 75 15 00 00       	call   107760 <thread_init>
    KERN_INFO("[BSP KERN] Kernel initialized.\n");
  1061eb:	8d 83 e4 97 ff ff    	lea    -0x681c(%ebx),%eax
        KERN_INFO("[BSP KERN] Boot CPU %d .... \n", i);
  1061f1:	8d ab e8 96 ff ff    	lea    -0x6918(%ebx),%ebp
    KERN_INFO("[BSP KERN] Kernel initialized.\n");
  1061f7:	89 04 24             	mov    %eax,(%esp)
  1061fa:	e8 c1 dd ff ff       	call   103fc0 <debug_info>
    KERN_INFO("[BSP KERN] In kernel main.\n\n");
  1061ff:	8d 83 b2 96 ff ff    	lea    -0x694e(%ebx),%eax
  106205:	89 04 24             	mov    %eax,(%esp)
  106208:	e8 b3 dd ff ff       	call   103fc0 <debug_info>
    KERN_INFO("[BSP KERN] Number of CPUs in this system: %d. \n", pcpu_ncpu());
  10620d:	e8 2e d8 ff ff       	call   103a40 <pcpu_ncpu>
  106212:	5a                   	pop    %edx
  106213:	59                   	pop    %ecx
  106214:	50                   	push   %eax
  106215:	8d 83 04 98 ff ff    	lea    -0x67fc(%ebx),%eax
  10621b:	50                   	push   %eax
  10621c:	e8 9f dd ff ff       	call   103fc0 <debug_info>
    int cpu_idx = get_pcpu_idx();
  106221:	e8 2a fc ff ff       	call   105e50 <get_pcpu_idx>
    KERN_INFO("[BSP KERN] cpu_idx: %d \n", cpu_idx);
  106226:	5e                   	pop    %esi
  106227:	5f                   	pop    %edi
    for (i = 1; i < pcpu_ncpu(); i++) {
  106228:	be 01 00 00 00       	mov    $0x1,%esi
    KERN_INFO("[BSP KERN] cpu_idx: %d \n", cpu_idx);
  10622d:	50                   	push   %eax
  10622e:	8d 83 cf 96 ff ff    	lea    -0x6931(%ebx),%eax
  106234:	50                   	push   %eax
    all_ready = FALSE;
  106235:	c7 83 3c 14 07 00 00 	movl   $0x0,0x7143c(%ebx)
  10623c:	00 00 00 
    KERN_INFO("[BSP KERN] cpu_idx: %d \n", cpu_idx);
  10623f:	e8 7c dd ff ff       	call   103fc0 <debug_info>
    for (i = 1; i < pcpu_ncpu(); i++) {
  106244:	c7 c0 00 a0 17 00    	mov    $0x17a000,%eax
  10624a:	83 c4 10             	add    $0x10,%esp
  10624d:	8d b8 00 10 00 00    	lea    0x1000(%eax),%edi
        pcpu_boot_ap(i, kern_main_ap, (uintptr_t) &bsp_kstack[i]);
  106253:	8d 83 60 50 ff ff    	lea    -0xafa0(%ebx),%eax
  106259:	89 44 24 0c          	mov    %eax,0xc(%esp)
    for (i = 1; i < pcpu_ncpu(); i++) {
  10625d:	e8 de d7 ff ff       	call   103a40 <pcpu_ncpu>
  106262:	39 f0                	cmp    %esi,%eax
  106264:	76 66                	jbe    1062cc <kern_init+0xfc>
  106266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10626d:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_INFO("[BSP KERN] Boot CPU %d .... \n", i);
  106270:	83 ec 08             	sub    $0x8,%esp
  106273:	56                   	push   %esi
  106274:	55                   	push   %ebp
  106275:	e8 46 dd ff ff       	call   103fc0 <debug_info>
        pcpu_boot_ap(i, kern_main_ap, (uintptr_t) &bsp_kstack[i]);
  10627a:	83 c4 0c             	add    $0xc,%esp
        bsp_kstack[i].cpu_idx = i;
  10627d:	89 b7 1c 01 00 00    	mov    %esi,0x11c(%edi)
        pcpu_boot_ap(i, kern_main_ap, (uintptr_t) &bsp_kstack[i]);
  106283:	57                   	push   %edi
  106284:	ff 74 24 14          	push   0x14(%esp)
  106288:	56                   	push   %esi
  106289:	e8 c2 d1 ff ff       	call   103450 <pcpu_boot_ap>
        while (get_pcpu_boot_info(i) == FALSE);
  10628e:	83 c4 10             	add    $0x10,%esp
  106291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106298:	83 ec 0c             	sub    $0xc,%esp
  10629b:	56                   	push   %esi
  10629c:	e8 5f fc ff ff       	call   105f00 <get_pcpu_boot_info>
  1062a1:	83 c4 10             	add    $0x10,%esp
  1062a4:	84 c0                	test   %al,%al
  1062a6:	74 f0                	je     106298 <kern_init+0xc8>
        KERN_INFO("[BSP KERN] done.\n");
  1062a8:	83 ec 0c             	sub    $0xc,%esp
  1062ab:	8d 83 06 97 ff ff    	lea    -0x68fa(%ebx),%eax
    for (i = 1; i < pcpu_ncpu(); i++) {
  1062b1:	83 c6 01             	add    $0x1,%esi
  1062b4:	81 c7 00 10 00 00    	add    $0x1000,%edi
        KERN_INFO("[BSP KERN] done.\n");
  1062ba:	50                   	push   %eax
  1062bb:	e8 00 dd ff ff       	call   103fc0 <debug_info>
    for (i = 1; i < pcpu_ncpu(); i++) {
  1062c0:	83 c4 10             	add    $0x10,%esp
  1062c3:	e8 78 d7 ff ff       	call   103a40 <pcpu_ncpu>
  1062c8:	39 f0                	cmp    %esi,%eax
  1062ca:	77 a4                	ja     106270 <kern_init+0xa0>
    bb_init(&shared_buffer);
  1062cc:	83 ec 0c             	sub    $0xc,%esp
  1062cf:	8d 83 c0 12 07 00    	lea    0x712c0(%ebx),%eax
    all_ready = TRUE;
  1062d5:	c7 83 3c 14 07 00 01 	movl   $0x1,0x7143c(%ebx)
  1062dc:	00 00 00 
    bb_init(&shared_buffer);
  1062df:	50                   	push   %eax
  1062e0:	e8 0b f9 ff ff       	call   105bf0 <bb_init>
    shared_buffer_inited = TRUE;
  1062e5:	c6 83 a0 12 07 00 01 	movb   $0x1,0x712a0(%ebx)
    kern_main();
}
  1062ec:	83 c4 2c             	add    $0x2c,%esp
  1062ef:	5b                   	pop    %ebx
  1062f0:	5e                   	pop    %esi
  1062f1:	5f                   	pop    %edi
  1062f2:	5d                   	pop    %ebp
  1062f3:	c3                   	ret    
  1062f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1062fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1062ff:	90                   	nop

00106300 <kern_init_ap>:

void kern_init_ap(void (*f)(void))
{
  106300:	56                   	push   %esi
  106301:	53                   	push   %ebx
  106302:	e8 82 a0 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106307:	81 c3 f9 ac 00 00    	add    $0xacf9,%ebx
  10630d:	83 ec 04             	sub    $0x4,%esp
  106310:	8b 74 24 10          	mov    0x10(%esp),%esi
    devinit_ap();
  106314:	e8 37 a8 ff ff       	call   100b50 <devinit_ap>
    f();
}
  106319:	83 c4 04             	add    $0x4,%esp
    f();
  10631c:	89 f0                	mov    %esi,%eax
}
  10631e:	5b                   	pop    %ebx
  10631f:	5e                   	pop    %esi
    f();
  106320:	ff e0                	jmp    *%eax
  106322:	66 90                	xchg   %ax,%ax
  106324:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
  10632a:	00 00                	add    %al,(%eax)
  10632c:	fb                   	sti    
  10632d:	4f                   	dec    %edi
  10632e:	52                   	push   %edx
  10632f:	e4                   	.byte 0xe4

00106330 <start>:
	.long CHECKSUM

	/* this is the entry of the kernel */
	.globl start
start:
	cli
  106330:	fa                   	cli    

	/* check whether the bootloader provide multiboot information */
	cmpl	$MULTIBOOT_BOOTLOADER_MAGIC, %eax
  106331:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
	jne	spin
  106336:	75 27                	jne    10635f <spin>
	movl	%ebx, multiboot_ptr
  106338:	89 1d 60 63 10 00    	mov    %ebx,0x106360

	/* tell BIOS to warmboot next time */
	movw	$0x1234, 0x472
  10633e:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  106345:	34 12 

	/* clear EFLAGS */
	pushl	$0x2
  106347:	6a 02                	push   $0x2
	popfl
  106349:	9d                   	popf   

	/* prepare the kernel stack */
	movl	$0x0, %ebp
  10634a:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl	$(bsp_kstack + 4096), %esp
  10634f:	bc 00 b0 17 00       	mov    $0x17b000,%esp

	/* jump to the C code */
	push	multiboot_ptr
  106354:	ff 35 60 63 10 00    	push   0x106360
	call	kern_init
  10635a:	e8 71 fe ff ff       	call   1061d0 <kern_init>

0010635f <spin>:

	/* should not be here */
spin:
	hlt
  10635f:	f4                   	hlt    

00106360 <multiboot_ptr>:
  106360:	00 00                	add    %al,(%eax)
  106362:	00 00                	add    %al,(%eax)
  106364:	66 90                	xchg   %ax,%ax
  106366:	66 90                	xchg   %ax,%ax
  106368:	66 90                	xchg   %ax,%ax
  10636a:	66 90                	xchg   %ax,%ax
  10636c:	66 90                	xchg   %ax,%ax
  10636e:	66 90                	xchg   %ax,%ax

00106370 <mem_spinlock_init>:
 * So it may have up to 2^20 physical pages,
 * with the page size being 4KB.
 */
static struct ATStruct AT[1 << 20];

void mem_spinlock_init(void) {
  106370:	53                   	push   %ebx
  106371:	e8 13 a0 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106376:	81 c3 8a ac 00 00    	add    $0xac8a,%ebx
  10637c:	83 ec 14             	sub    $0x14,%esp
    spinlock_init(&mem_lk);
  10637f:	8d 83 64 14 87 00    	lea    0x871464(%ebx),%eax
  106385:	50                   	push   %eax
  106386:	e8 65 f3 ff ff       	call   1056f0 <spinlock_init>
}
  10638b:	83 c4 18             	add    $0x18,%esp
  10638e:	5b                   	pop    %ebx
  10638f:	c3                   	ret    

00106390 <mem_lock>:

void mem_lock(void) {
  106390:	53                   	push   %ebx
  106391:	e8 f3 9f ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106396:	81 c3 6a ac 00 00    	add    $0xac6a,%ebx
  10639c:	83 ec 14             	sub    $0x14,%esp
    spinlock_acquire(&mem_lk);
  10639f:	8d 83 64 14 87 00    	lea    0x871464(%ebx),%eax
  1063a5:	50                   	push   %eax
  1063a6:	e8 d5 f3 ff ff       	call   105780 <spinlock_acquire>
}
  1063ab:	83 c4 18             	add    $0x18,%esp
  1063ae:	5b                   	pop    %ebx
  1063af:	c3                   	ret    

001063b0 <mem_unlock>:

void mem_unlock(void) {
  1063b0:	53                   	push   %ebx
  1063b1:	e8 d3 9f ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1063b6:	81 c3 4a ac 00 00    	add    $0xac4a,%ebx
  1063bc:	83 ec 14             	sub    $0x14,%esp
    spinlock_release(&mem_lk);
  1063bf:	8d 83 64 14 87 00    	lea    0x871464(%ebx),%eax
  1063c5:	50                   	push   %eax
  1063c6:	e8 35 f4 ff ff       	call   105800 <spinlock_release>
}
  1063cb:	83 c4 18             	add    $0x18,%esp
  1063ce:	5b                   	pop    %ebx
  1063cf:	c3                   	ret    

001063d0 <get_nps>:

// The getter function for NUM_PAGES.
unsigned int get_nps(void)
{
    return NUM_PAGES;
  1063d0:	e8 ac 9f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  1063d5:	05 2b ac 00 00       	add    $0xac2b,%eax
  1063da:	8b 80 60 14 87 00    	mov    0x871460(%eax),%eax
}
  1063e0:	c3                   	ret    
  1063e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1063e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1063ef:	90                   	nop

001063f0 <set_nps>:

// The setter function for NUM_PAGES.
void set_nps(unsigned int nps)
{
    NUM_PAGES = nps;
  1063f0:	e8 8c 9f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  1063f5:	05 0b ac 00 00       	add    $0xac0b,%eax
  1063fa:	8b 54 24 04          	mov    0x4(%esp),%edx
  1063fe:	89 90 60 14 87 00    	mov    %edx,0x871460(%eax)
}
  106404:	c3                   	ret    
  106405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106410 <at_is_norm>:
        perm = 1;
    } else {
        perm = 0;
    }

    return perm;
  106410:	e8 6c 9f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  106415:	05 eb ab 00 00       	add    $0xabeb,%eax
    if (perm > 1) {
  10641a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10641e:	83 bc d0 60 14 07 00 	cmpl   $0x1,0x71460(%eax,%edx,8)
  106425:	01 
  106426:	0f 97 c0             	seta   %al
  106429:	0f b6 c0             	movzbl %al,%eax
}
  10642c:	c3                   	ret    
  10642d:	8d 76 00             	lea    0x0(%esi),%esi

00106430 <at_set_perm>:
 * Sets the permission of the page with given index.
 * It also marks the page as unallocated.
 */
void at_set_perm(unsigned int page_index, unsigned int perm)
{
    AT[page_index].perm = perm;
  106430:	e8 4c 9f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  106435:	05 cb ab 00 00       	add    $0xabcb,%eax
{
  10643a:	8b 54 24 04          	mov    0x4(%esp),%edx
    AT[page_index].perm = perm;
  10643e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    AT[page_index].allocated = 0;
  106442:	c7 84 d0 64 14 07 00 	movl   $0x0,0x71464(%eax,%edx,8)
  106449:	00 00 00 00 
    AT[page_index].perm = perm;
  10644d:	89 8c d0 60 14 07 00 	mov    %ecx,0x71460(%eax,%edx,8)
}
  106454:	c3                   	ret    
  106455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10645c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106460 <at_is_allocated>:
    allocated = AT[page_index].allocated;
    if (allocated > 0) {
        allocated = 1;
    }

    return allocated;
  106460:	e8 1c 9f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  106465:	05 9b ab 00 00       	add    $0xab9b,%eax
    if (allocated > 0) {
  10646a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10646e:	8b 84 d0 64 14 07 00 	mov    0x71464(%eax,%edx,8),%eax
  106475:	85 c0                	test   %eax,%eax
  106477:	0f 95 c0             	setne  %al
  10647a:	0f b6 c0             	movzbl %al,%eax
}
  10647d:	c3                   	ret    
  10647e:	66 90                	xchg   %ax,%ax

00106480 <at_set_allocated>:
 * The setter function for the physical page allocation flag.
 * Set the flag of the page with given index to the given value.
 */
void at_set_allocated(unsigned int page_index, unsigned int allocated)
{
    AT[page_index].allocated = allocated;
  106480:	e8 fc 9e ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  106485:	05 7b ab 00 00       	add    $0xab7b,%eax
  10648a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10648e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  106492:	89 8c d0 64 14 07 00 	mov    %ecx,0x71464(%eax,%edx,8)
}
  106499:	c3                   	ret    
  10649a:	66 90                	xchg   %ax,%ax
  10649c:	66 90                	xchg   %ax,%ax
  10649e:	66 90                	xchg   %ax,%ax

001064a0 <pmem_init>:
 *    based on the information available in the physical memory map table.
 *    Review import.h in the current directory for the list of available
 *    getter and setter functions.
 */
void pmem_init(unsigned int mbi_addr)
{
  1064a0:	55                   	push   %ebp
  1064a1:	57                   	push   %edi
  1064a2:	56                   	push   %esi
  1064a3:	53                   	push   %ebx
  1064a4:	e8 e0 9e ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1064a9:	81 c3 57 ab 00 00    	add    $0xab57,%ebx
  1064af:	83 ec 38             	sub    $0x38,%esp
    unsigned int pg_idx, pmmap_size, cur_addr, highest_addr;
    unsigned int entry_idx, flag, isnorm, start, len;

    // Calls the lower layer initialization primitive.
    // The parameter mbi_addr should not be used in the further code.
    devinit(mbi_addr);
  1064b2:	ff 74 24 4c          	push   0x4c(%esp)
  1064b6:	e8 f5 a5 ff ff       	call   100ab0 <devinit>
    mem_spinlock_init();
  1064bb:	e8 b0 fe ff ff       	call   106370 <mem_spinlock_init>
     * Hint: Think of it as the highest address in the ranges of the memory map table,
     *       divided by the page size.
     */
    nps = 0;
    entry_idx = 0;
    pmmap_size = get_size();
  1064c0:	e8 9b ab ff ff       	call   101060 <get_size>
  1064c5:	89 44 24 18          	mov    %eax,0x18(%esp)
    while (entry_idx < pmmap_size) {
  1064c9:	83 c4 10             	add    $0x10,%esp
  1064cc:	85 c0                	test   %eax,%eax
  1064ce:	0f 84 62 01 00 00    	je     106636 <pmem_init+0x196>
    entry_idx = 0;
  1064d4:	31 ff                	xor    %edi,%edi
    nps = 0;
  1064d6:	31 f6                	xor    %esi,%esi
  1064d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1064df:	90                   	nop
        cur_addr = get_mms(entry_idx) + get_mml(entry_idx);
  1064e0:	83 ec 0c             	sub    $0xc,%esp
  1064e3:	57                   	push   %edi
  1064e4:	e8 97 ab ff ff       	call   101080 <get_mms>
  1064e9:	89 3c 24             	mov    %edi,(%esp)
  1064ec:	89 c5                	mov    %eax,%ebp
  1064ee:	e8 dd ab ff ff       	call   1010d0 <get_mml>
  1064f3:	01 e8                	add    %ebp,%eax
  1064f5:	39 c6                	cmp    %eax,%esi
  1064f7:	0f 42 f0             	cmovb  %eax,%esi
    while (entry_idx < pmmap_size) {
  1064fa:	83 c4 10             	add    $0x10,%esp
        if (nps < cur_addr) {
            nps = cur_addr;
        }
        entry_idx++;
  1064fd:	83 c7 01             	add    $0x1,%edi
    while (entry_idx < pmmap_size) {
  106500:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  106504:	75 da                	jne    1064e0 <pmem_init+0x40>
    }

    nps = ROUNDDOWN(nps, PAGESIZE) / PAGESIZE;
  106506:	89 f5                	mov    %esi,%ebp
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  106508:	83 ec 0c             	sub    $0xc,%esp
    nps = ROUNDDOWN(nps, PAGESIZE) / PAGESIZE;
  10650b:	c1 ed 0c             	shr    $0xc,%ebp
  10650e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  106512:	55                   	push   %ebp
  106513:	e8 d8 fe ff ff       	call   1063f0 <set_nps>
     *    not aligned by pages, so it may be possible that for some pages, only some of
     *    the addresses are in a usable range. Currently, we do not utilize partial pages,
     *    so in that case, you should consider those pages as unavailable.
     */
    pg_idx = 0;
    while (pg_idx < nps) {
  106518:	83 c4 10             	add    $0x10,%esp
  10651b:	85 ed                	test   %ebp,%ebp
  10651d:	0f 84 f2 00 00 00    	je     106615 <pmem_init+0x175>
  106523:	31 c0                	xor    %eax,%eax
    pg_idx = 0;
  106525:	89 7c 24 10          	mov    %edi,0x10(%esp)
  106529:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  106530:	00 
  106531:	89 c7                	mov    %eax,%edi
  106533:	eb 25                	jmp    10655a <pmem_init+0xba>
  106535:	8d 76 00             	lea    0x0(%esi),%esi
        if (pg_idx < VM_USERLO_PI || VM_USERHI_PI <= pg_idx) {
            at_set_perm(pg_idx, 1);
  106538:	83 ec 08             	sub    $0x8,%esp
  10653b:	6a 01                	push   $0x1
  10653d:	51                   	push   %ecx
  10653e:	e8 ed fe ff ff       	call   106430 <at_set_perm>
  106543:	83 c4 10             	add    $0x10,%esp
    while (pg_idx < nps) {
  106546:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  10654a:	81 c7 00 10 00 00    	add    $0x1000,%edi
  106550:	39 54 24 08          	cmp    %edx,0x8(%esp)
  106554:	0f 84 bb 00 00 00    	je     106615 <pmem_init+0x175>
        if (pg_idx < VM_USERLO_PI || VM_USERHI_PI <= pg_idx) {
  10655a:	8b 44 24 08          	mov    0x8(%esp),%eax
  10655e:	89 c1                	mov    %eax,%ecx
  106560:	89 44 24 18          	mov    %eax,0x18(%esp)
            isnorm = 0;
            while (entry_idx < pmmap_size && !flag) {
                isnorm = is_usable(entry_idx);
                start = get_mms(entry_idx);
                len = get_mml(entry_idx);
                if (start <= pg_idx * PAGESIZE && (pg_idx + 1) * PAGESIZE <= start + len) {
  106564:	83 c0 01             	add    $0x1,%eax
  106567:	89 44 24 08          	mov    %eax,0x8(%esp)
        if (pg_idx < VM_USERLO_PI || VM_USERHI_PI <= pg_idx) {
  10656b:	8d 81 00 00 fc ff    	lea    -0x40000(%ecx),%eax
  106571:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  106576:	77 c0                	ja     106538 <pmem_init+0x98>
            while (entry_idx < pmmap_size && !flag) {
  106578:	8b 44 24 08          	mov    0x8(%esp),%eax
            entry_idx = 0;
  10657c:	31 f6                	xor    %esi,%esi
  10657e:	c1 e0 0c             	shl    $0xc,%eax
  106581:	89 44 24 14          	mov    %eax,0x14(%esp)
  106585:	eb 27                	jmp    1065ae <pmem_init+0x10e>
  106587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10658e:	66 90                	xchg   %ax,%ax
                if (start <= pg_idx * PAGESIZE && (pg_idx + 1) * PAGESIZE <= start + len) {
  106590:	8d 54 05 00          	lea    0x0(%ebp,%eax,1),%edx
  106594:	3b 54 24 14          	cmp    0x14(%esp),%edx
  106598:	0f 93 c2             	setae  %dl
  10659b:	0f 92 c0             	setb   %al
                    flag = 1;
                }
                entry_idx++;
  10659e:	83 c6 01             	add    $0x1,%esi
                if (start <= pg_idx * PAGESIZE && (pg_idx + 1) * PAGESIZE <= start + len) {
  1065a1:	0f b6 d2             	movzbl %dl,%edx
            while (entry_idx < pmmap_size && !flag) {
  1065a4:	3b 74 24 10          	cmp    0x10(%esp),%esi
  1065a8:	73 3a                	jae    1065e4 <pmem_init+0x144>
  1065aa:	84 c0                	test   %al,%al
  1065ac:	74 36                	je     1065e4 <pmem_init+0x144>
                isnorm = is_usable(entry_idx);
  1065ae:	83 ec 0c             	sub    $0xc,%esp
  1065b1:	56                   	push   %esi
  1065b2:	e8 79 ab ff ff       	call   101130 <is_usable>
                start = get_mms(entry_idx);
  1065b7:	89 34 24             	mov    %esi,(%esp)
                isnorm = is_usable(entry_idx);
  1065ba:	89 44 24 1c          	mov    %eax,0x1c(%esp)
                start = get_mms(entry_idx);
  1065be:	e8 bd aa ff ff       	call   101080 <get_mms>
                len = get_mml(entry_idx);
  1065c3:	89 34 24             	mov    %esi,(%esp)
                start = get_mms(entry_idx);
  1065c6:	89 c5                	mov    %eax,%ebp
                len = get_mml(entry_idx);
  1065c8:	e8 03 ab ff ff       	call   1010d0 <get_mml>
                if (start <= pg_idx * PAGESIZE && (pg_idx + 1) * PAGESIZE <= start + len) {
  1065cd:	83 c4 10             	add    $0x10,%esp
  1065d0:	39 ef                	cmp    %ebp,%edi
  1065d2:	73 bc                	jae    106590 <pmem_init+0xf0>
  1065d4:	b8 01 00 00 00       	mov    $0x1,%eax
  1065d9:	31 d2                	xor    %edx,%edx
                entry_idx++;
  1065db:	83 c6 01             	add    $0x1,%esi
            while (entry_idx < pmmap_size && !flag) {
  1065de:	3b 74 24 10          	cmp    0x10(%esp),%esi
  1065e2:	72 c6                	jb     1065aa <pmem_init+0x10a>
            }

            if (flag && isnorm) {
  1065e4:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1065e8:	85 c0                	test   %eax,%eax
  1065ea:	74 34                	je     106620 <pmem_init+0x180>
  1065ec:	85 d2                	test   %edx,%edx
  1065ee:	74 30                	je     106620 <pmem_init+0x180>
                at_set_perm(pg_idx, 2);
  1065f0:	83 ec 08             	sub    $0x8,%esp
    while (pg_idx < nps) {
  1065f3:	81 c7 00 10 00 00    	add    $0x1000,%edi
                at_set_perm(pg_idx, 2);
  1065f9:	6a 02                	push   $0x2
  1065fb:	ff 74 24 24          	push   0x24(%esp)
  1065ff:	e8 2c fe ff ff       	call   106430 <at_set_perm>
  106604:	83 c4 10             	add    $0x10,%esp
    while (pg_idx < nps) {
  106607:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  10660b:	39 54 24 08          	cmp    %edx,0x8(%esp)
  10660f:	0f 85 45 ff ff ff    	jne    10655a <pmem_init+0xba>
                at_set_perm(pg_idx, 0);
            }
        }
        pg_idx++;
    }
}
  106615:	83 c4 2c             	add    $0x2c,%esp
  106618:	5b                   	pop    %ebx
  106619:	5e                   	pop    %esi
  10661a:	5f                   	pop    %edi
  10661b:	5d                   	pop    %ebp
  10661c:	c3                   	ret    
  10661d:	8d 76 00             	lea    0x0(%esi),%esi
                at_set_perm(pg_idx, 0);
  106620:	83 ec 08             	sub    $0x8,%esp
  106623:	6a 00                	push   $0x0
  106625:	ff 74 24 24          	push   0x24(%esp)
  106629:	e8 02 fe ff ff       	call   106430 <at_set_perm>
  10662e:	83 c4 10             	add    $0x10,%esp
  106631:	e9 10 ff ff ff       	jmp    106546 <pmem_init+0xa6>
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  106636:	83 ec 0c             	sub    $0xc,%esp
  106639:	6a 00                	push   $0x0
  10663b:	e8 b0 fd ff ff       	call   1063f0 <set_nps>
  106640:	83 c4 10             	add    $0x10,%esp
}
  106643:	83 c4 2c             	add    $0x2c,%esp
  106646:	5b                   	pop    %ebx
  106647:	5e                   	pop    %esi
  106648:	5f                   	pop    %edi
  106649:	5d                   	pop    %ebp
  10664a:	c3                   	ret    
  10664b:	66 90                	xchg   %ax,%ax
  10664d:	66 90                	xchg   %ax,%ax
  10664f:	90                   	nop

00106650 <palloc>:
 *    return 0.
 * 2. Optimize the code using memoization so that you do not have to
 *    scan the allocation table from scratch every time.
 */
unsigned int palloc()
{
  106650:	55                   	push   %ebp
  106651:	57                   	push   %edi
  106652:	56                   	push   %esi
  106653:	53                   	push   %ebx
  106654:	e8 30 9d ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106659:	81 c3 a7 a9 00 00    	add    $0xa9a7,%ebx
  10665f:	83 ec 0c             	sub    $0xc,%esp
    unsigned int nps;
    unsigned int palloc_index;
    unsigned int palloc_free_index;
    bool first;

    mem_lock();
  106662:	e8 29 fd ff ff       	call   106390 <mem_lock>

    nps = get_nps();
  106667:	e8 64 fd ff ff       	call   1063d0 <get_nps>
    palloc_index = last_palloc_index;
  10666c:	8b b3 28 03 00 00    	mov    0x328(%ebx),%esi
    nps = get_nps();
  106672:	89 c7                	mov    %eax,%edi
    palloc_free_index = nps;
    first = TRUE;

    while ((palloc_index != last_palloc_index || first) && palloc_free_index == nps) {
  106674:	eb 1a                	jmp    106690 <palloc+0x40>
  106676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10667d:	8d 76 00             	lea    0x0(%esi),%esi
  106680:	3d 00 00 04 00       	cmp    $0x40000,%eax
  106685:	74 30                	je     1066b7 <palloc+0x67>
  106687:	be 00 00 04 00       	mov    $0x40000,%esi
  10668c:	39 fd                	cmp    %edi,%ebp
  10668e:	75 68                	jne    1066f8 <palloc+0xa8>
        first = FALSE;
        if (at_is_norm(palloc_index) && !at_is_allocated(palloc_index)) {
  106690:	83 ec 0c             	sub    $0xc,%esp
  106693:	89 fd                	mov    %edi,%ebp
  106695:	56                   	push   %esi
  106696:	e8 75 fd ff ff       	call   106410 <at_is_norm>
  10669b:	83 c4 10             	add    $0x10,%esp
  10669e:	85 c0                	test   %eax,%eax
  1066a0:	75 3e                	jne    1066e0 <palloc+0x90>
            palloc_free_index = palloc_index;
        }
        palloc_index++;
  1066a2:	83 c6 01             	add    $0x1,%esi
    while ((palloc_index != last_palloc_index || first) && palloc_free_index == nps) {
  1066a5:	8b 83 28 03 00 00    	mov    0x328(%ebx),%eax
        if (palloc_index >= VM_USERHI_PI) {
  1066ab:	81 fe ff ff 0e 00    	cmp    $0xeffff,%esi
  1066b1:	77 cd                	ja     106680 <palloc+0x30>
    while ((palloc_index != last_palloc_index || first) && palloc_free_index == nps) {
  1066b3:	39 c6                	cmp    %eax,%esi
  1066b5:	75 d5                	jne    10668c <palloc+0x3c>
            palloc_index = VM_USERLO_PI;
        }
    }

    if (palloc_free_index == nps) {
  1066b7:	39 fd                	cmp    %edi,%ebp
  1066b9:	75 3d                	jne    1066f8 <palloc+0xa8>
  1066bb:	b8 00 00 04 00       	mov    $0x40000,%eax
        palloc_free_index = 0;
  1066c0:	31 ed                	xor    %ebp,%ebp
        last_palloc_index = VM_USERLO_PI;
  1066c2:	89 83 28 03 00 00    	mov    %eax,0x328(%ebx)
    } else {
        at_set_allocated(palloc_free_index, 1);
        last_palloc_index = palloc_free_index;
    }

    mem_unlock();
  1066c8:	e8 e3 fc ff ff       	call   1063b0 <mem_unlock>

    return palloc_free_index;
}
  1066cd:	83 c4 0c             	add    $0xc,%esp
  1066d0:	89 e8                	mov    %ebp,%eax
  1066d2:	5b                   	pop    %ebx
  1066d3:	5e                   	pop    %esi
  1066d4:	5f                   	pop    %edi
  1066d5:	5d                   	pop    %ebp
  1066d6:	c3                   	ret    
  1066d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1066de:	66 90                	xchg   %ax,%ax
        if (at_is_norm(palloc_index) && !at_is_allocated(palloc_index)) {
  1066e0:	83 ec 0c             	sub    $0xc,%esp
  1066e3:	89 f5                	mov    %esi,%ebp
  1066e5:	56                   	push   %esi
  1066e6:	e8 75 fd ff ff       	call   106460 <at_is_allocated>
  1066eb:	83 c4 10             	add    $0x10,%esp
  1066ee:	85 c0                	test   %eax,%eax
  1066f0:	0f 45 ef             	cmovne %edi,%ebp
  1066f3:	eb ad                	jmp    1066a2 <palloc+0x52>
  1066f5:	8d 76 00             	lea    0x0(%esi),%esi
        at_set_allocated(palloc_free_index, 1);
  1066f8:	83 ec 08             	sub    $0x8,%esp
  1066fb:	6a 01                	push   $0x1
  1066fd:	55                   	push   %ebp
  1066fe:	e8 7d fd ff ff       	call   106480 <at_set_allocated>
  106703:	83 c4 10             	add    $0x10,%esp
  106706:	89 e8                	mov    %ebp,%eax
  106708:	eb b8                	jmp    1066c2 <palloc+0x72>
  10670a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106710 <pfree>:
 * in the allocation table.
 *
 * Hint: Simple.
 */
void pfree(unsigned int pfree_index)
{
  106710:	53                   	push   %ebx
  106711:	e8 73 9c ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106716:	81 c3 ea a8 00 00    	add    $0xa8ea,%ebx
  10671c:	83 ec 08             	sub    $0x8,%esp
    mem_lock();
  10671f:	e8 6c fc ff ff       	call   106390 <mem_lock>
    at_set_allocated(pfree_index, 0);
  106724:	83 ec 08             	sub    $0x8,%esp
  106727:	6a 00                	push   $0x0
  106729:	ff 74 24 1c          	push   0x1c(%esp)
  10672d:	e8 4e fd ff ff       	call   106480 <at_set_allocated>
    mem_unlock();
  106732:	e8 79 fc ff ff       	call   1063b0 <mem_unlock>
}
  106737:	83 c4 18             	add    $0x18,%esp
  10673a:	5b                   	pop    %ebx
  10673b:	c3                   	ret    
  10673c:	66 90                	xchg   %ax,%ax
  10673e:	66 90                	xchg   %ax,%ax

00106740 <container_init>:
/**
 * Initializes the container data for the root process (the one with index 0).
 * The root process is the one that gets spawned first by the kernel.
 */
void container_init(unsigned int mbi_addr)
{
  106740:	55                   	push   %ebp
  106741:	57                   	push   %edi
  106742:	56                   	push   %esi
  106743:	53                   	push   %ebx
  106744:	e8 40 9c ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106749:	81 c3 b7 a8 00 00    	add    $0xa8b7,%ebx
  10674f:	83 ec 18             	sub    $0x18,%esp
    unsigned int real_quota;
    unsigned int nps, idx;

    pmem_init(mbi_addr);
  106752:	ff 74 24 2c          	push   0x2c(%esp)
  106756:	e8 45 fd ff ff       	call   1064a0 <pmem_init>
    /**
     * Compute the available quota and store it into the variable real_quota.
     * It should be the number of the unallocated pages with the normal permission
     * in the physical memory allocation table.
     */
    nps = get_nps();
  10675b:	e8 70 fc ff ff       	call   1063d0 <get_nps>
    idx = 1;
    while (idx < nps) {
  106760:	83 c4 10             	add    $0x10,%esp
  106763:	83 f8 01             	cmp    $0x1,%eax
  106766:	0f 86 b7 00 00 00    	jbe    106823 <container_init+0xe3>
  10676c:	89 c6                	mov    %eax,%esi
    idx = 1;
  10676e:	bd 01 00 00 00       	mov    $0x1,%ebp
    real_quota = 0;
  106773:	31 ff                	xor    %edi,%edi
  106775:	eb 10                	jmp    106787 <container_init+0x47>
  106777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10677e:	66 90                	xchg   %ax,%ax
        if (at_is_norm(idx) && !at_is_allocated(idx)) {
            real_quota++;
        }
        idx++;
  106780:	83 c5 01             	add    $0x1,%ebp
    while (idx < nps) {
  106783:	39 ee                	cmp    %ebp,%esi
  106785:	74 29                	je     1067b0 <container_init+0x70>
        if (at_is_norm(idx) && !at_is_allocated(idx)) {
  106787:	83 ec 0c             	sub    $0xc,%esp
  10678a:	55                   	push   %ebp
  10678b:	e8 80 fc ff ff       	call   106410 <at_is_norm>
  106790:	83 c4 10             	add    $0x10,%esp
  106793:	85 c0                	test   %eax,%eax
  106795:	74 e9                	je     106780 <container_init+0x40>
  106797:	83 ec 0c             	sub    $0xc,%esp
  10679a:	55                   	push   %ebp
  10679b:	e8 c0 fc ff ff       	call   106460 <at_is_allocated>
  1067a0:	83 c4 10             	add    $0x10,%esp
            real_quota++;
  1067a3:	83 f8 01             	cmp    $0x1,%eax
  1067a6:	83 d7 00             	adc    $0x0,%edi
        idx++;
  1067a9:	83 c5 01             	add    $0x1,%ebp
    while (idx < nps) {
  1067ac:	39 ee                	cmp    %ebp,%esi
  1067ae:	75 d7                	jne    106787 <container_init+0x47>
    }

    KERN_DEBUG("\nreal quota: %d\n\n", real_quota);

    CONTAINER[0].quota = real_quota;
  1067b0:	89 fe                	mov    %edi,%esi
    KERN_DEBUG("\nreal quota: %d\n\n", real_quota);
  1067b2:	8d 83 34 98 ff ff    	lea    -0x67cc(%ebx),%eax
  1067b8:	57                   	push   %edi
  1067b9:	50                   	push   %eax
  1067ba:	8d 83 48 98 ff ff    	lea    -0x67b8(%ebx),%eax
  1067c0:	6a 2c                	push   $0x2c
  1067c2:	50                   	push   %eax
  1067c3:	e8 28 d8 ff ff       	call   103ff0 <debug_normal>
    CONTAINER[0].quota = real_quota;
  1067c8:	89 b3 80 16 87 00    	mov    %esi,0x871680(%ebx)
    CONTAINER[0].usage = 0;
  1067ce:	83 c4 10             	add    $0x10,%esp
  1067d1:	8d b3 80 14 87 00    	lea    0x871480(%ebx),%esi
  1067d7:	c7 83 84 16 87 00 00 	movl   $0x0,0x871684(%ebx)
  1067de:	00 00 00 
    CONTAINER[0].parent = 0;
  1067e1:	8d be 00 02 00 00    	lea    0x200(%esi),%edi
  1067e7:	c7 83 88 16 87 00 00 	movl   $0x0,0x871688(%ebx)
  1067ee:	00 00 00 
    CONTAINER[0].nchildren = 0;
  1067f1:	c7 83 8c 16 87 00 00 	movl   $0x0,0x87168c(%ebx)
  1067f8:	00 00 00 
    CONTAINER[0].used = 1;
  1067fb:	c7 83 90 16 87 00 01 	movl   $0x1,0x871690(%ebx)
  106802:	00 00 00 

    for (idx = 0; idx < NUM_IDS; idx++) {
  106805:	8d 76 00             	lea    0x0(%esi),%esi
        spinlock_init(&container_lks[idx]);
  106808:	83 ec 0c             	sub    $0xc,%esp
  10680b:	56                   	push   %esi
    for (idx = 0; idx < NUM_IDS; idx++) {
  10680c:	83 c6 08             	add    $0x8,%esi
        spinlock_init(&container_lks[idx]);
  10680f:	e8 dc ee ff ff       	call   1056f0 <spinlock_init>
    for (idx = 0; idx < NUM_IDS; idx++) {
  106814:	83 c4 10             	add    $0x10,%esp
  106817:	39 fe                	cmp    %edi,%esi
  106819:	75 ed                	jne    106808 <container_init+0xc8>
    }
}
  10681b:	83 c4 0c             	add    $0xc,%esp
  10681e:	5b                   	pop    %ebx
  10681f:	5e                   	pop    %esi
  106820:	5f                   	pop    %edi
  106821:	5d                   	pop    %ebp
  106822:	c3                   	ret    
    while (idx < nps) {
  106823:	31 f6                	xor    %esi,%esi
    real_quota = 0;
  106825:	31 ff                	xor    %edi,%edi
  106827:	eb 89                	jmp    1067b2 <container_init+0x72>
  106829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106830 <container_get_parent>:

// Get the id of parent process of process # [id].
unsigned int container_get_parent(unsigned int id)
{
    return CONTAINER[id].parent;
  106830:	e8 50 9b ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106835:	81 c2 cb a7 00 00    	add    $0xa7cb,%edx
{
  10683b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].parent;
  10683f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  106842:	8b 84 82 88 16 87 00 	mov    0x871688(%edx,%eax,4),%eax
}
  106849:	c3                   	ret    
  10684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106850 <container_get_nchildren>:

// Get the number of children of process # [id].
unsigned int container_get_nchildren(unsigned int id)
{
    return CONTAINER[id].nchildren;
  106850:	e8 30 9b ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106855:	81 c2 ab a7 00 00    	add    $0xa7ab,%edx
{
  10685b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].nchildren;
  10685f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  106862:	8b 84 82 8c 16 87 00 	mov    0x87168c(%edx,%eax,4),%eax
}
  106869:	c3                   	ret    
  10686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106870 <container_get_quota>:

// Get the maximum memory quota of process # [id].
unsigned int container_get_quota(unsigned int id)
{
    return CONTAINER[id].quota;
  106870:	e8 10 9b ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106875:	81 c2 8b a7 00 00    	add    $0xa78b,%edx
{
  10687b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].quota;
  10687f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  106882:	8b 84 82 80 16 87 00 	mov    0x871680(%edx,%eax,4),%eax
}
  106889:	c3                   	ret    
  10688a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106890 <container_get_usage>:

// Get the current memory usage of process # [id].
unsigned int container_get_usage(unsigned int id)
{
    return CONTAINER[id].usage;
  106890:	e8 f0 9a ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106895:	81 c2 6b a7 00 00    	add    $0xa76b,%edx
{
  10689b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].usage;
  10689f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1068a2:	8b 84 82 84 16 87 00 	mov    0x871684(%edx,%eax,4),%eax
}
  1068a9:	c3                   	ret    
  1068aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001068b0 <container_can_consume>:

// Determines whether the process # [id] can consume an extra
// [n] pages of memory. If so, returns 1, otherwise, returns 0.
unsigned int container_can_consume(unsigned int id, unsigned int n)
{
    return CONTAINER[id].usage + n <= CONTAINER[id].quota;
  1068b0:	e8 de df ff ff       	call   104893 <__x86.get_pc_thunk.cx>
  1068b5:	81 c1 4b a7 00 00    	add    $0xa74b,%ecx
{
  1068bb:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].usage + n <= CONTAINER[id].quota;
  1068bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1068c2:	c1 e0 02             	shl    $0x2,%eax
  1068c5:	8b 94 01 84 16 87 00 	mov    0x871684(%ecx,%eax,1),%edx
  1068cc:	03 54 24 08          	add    0x8(%esp),%edx
  1068d0:	3b 94 01 80 16 87 00 	cmp    0x871680(%ecx,%eax,1),%edx
  1068d7:	0f 96 c0             	setbe  %al
  1068da:	0f b6 c0             	movzbl %al,%eax
}
  1068dd:	c3                   	ret    
  1068de:	66 90                	xchg   %ax,%ax

001068e0 <container_split>:
 * You can assume it is safe to allocate [quota] pages
 * (the check is already done outside before calling this function).
 * Returns the container index for the new child process.
 */
unsigned int container_split(unsigned int id, unsigned int quota)
{
  1068e0:	55                   	push   %ebp
  1068e1:	57                   	push   %edi
  1068e2:	56                   	push   %esi
  1068e3:	53                   	push   %ebx
  1068e4:	e8 a0 9a ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1068e9:	81 c3 17 a7 00 00    	add    $0xa717,%ebx
  1068ef:	83 ec 28             	sub    $0x28,%esp
  1068f2:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    unsigned int child, nc;

    spinlock_acquire(&container_lks[id]);

    nc = CONTAINER[id].nchildren;
    child = id * MAX_CHILDREN + 1 + nc;  // container index for the child process
  1068f6:	8d 7c 76 01          	lea    0x1(%esi,%esi,2),%edi
    spinlock_acquire(&container_lks[id]);
  1068fa:	8d ac f3 80 14 87 00 	lea    0x871480(%ebx,%esi,8),%ebp
  106901:	55                   	push   %ebp
  106902:	e8 79 ee ff ff       	call   105780 <spinlock_acquire>
    nc = CONTAINER[id].nchildren;
  106907:	8d 04 b6             	lea    (%esi,%esi,4),%eax

    if (NUM_IDS <= child) {
  10690a:	83 c4 10             	add    $0x10,%esp
    nc = CONTAINER[id].nchildren;
  10690d:	8d 84 83 80 16 87 00 	lea    0x871680(%ebx,%eax,4),%eax
    child = id * MAX_CHILDREN + 1 + nc;  // container index for the child process
  106914:	03 78 0c             	add    0xc(%eax),%edi
    if (NUM_IDS <= child) {
  106917:	83 ff 3f             	cmp    $0x3f,%edi
  10691a:	77 54                	ja     106970 <container_split+0x90>
    }

    /**
     * Update the container structure of both parent and child process appropriately.
     */
    CONTAINER[child].used = 1;
  10691c:	8d 14 bf             	lea    (%edi,%edi,4),%edx
    CONTAINER[child].nchildren = 0;

    CONTAINER[id].usage += quota;
    CONTAINER[id].nchildren++;

    spinlock_release(&container_lks[id]);
  10691f:	83 ec 0c             	sub    $0xc,%esp
    CONTAINER[child].used = 1;
  106922:	c1 e2 02             	shl    $0x2,%edx
  106925:	8d 8c 13 80 16 87 00 	lea    0x871680(%ebx,%edx,1),%ecx
  10692c:	89 54 24 18          	mov    %edx,0x18(%esp)
    CONTAINER[child].quota = quota;
  106930:	8b 54 24 40          	mov    0x40(%esp),%edx
    CONTAINER[child].usage = 0;
  106934:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
    CONTAINER[child].parent = id;
  10693b:	89 71 08             	mov    %esi,0x8(%ecx)
    CONTAINER[child].nchildren = 0;
  10693e:	c7 41 0c 00 00 00 00 	movl   $0x0,0xc(%ecx)
    CONTAINER[child].used = 1;
  106945:	c7 41 10 01 00 00 00 	movl   $0x1,0x10(%ecx)
    CONTAINER[id].nchildren++;
  10694c:	83 40 0c 01          	addl   $0x1,0xc(%eax)
    CONTAINER[child].quota = quota;
  106950:	89 11                	mov    %edx,(%ecx)
    CONTAINER[id].usage += quota;
  106952:	8b 4c 24 40          	mov    0x40(%esp),%ecx
  106956:	01 48 04             	add    %ecx,0x4(%eax)
    spinlock_release(&container_lks[id]);
  106959:	55                   	push   %ebp
  10695a:	e8 a1 ee ff ff       	call   105800 <spinlock_release>

    return child;
  10695f:	83 c4 10             	add    $0x10,%esp
}
  106962:	89 f8                	mov    %edi,%eax
  106964:	83 c4 1c             	add    $0x1c,%esp
  106967:	5b                   	pop    %ebx
  106968:	5e                   	pop    %esi
  106969:	5f                   	pop    %edi
  10696a:	5d                   	pop    %ebp
  10696b:	c3                   	ret    
  10696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106970:	83 c4 1c             	add    $0x1c,%esp
        return NUM_IDS;
  106973:	bf 40 00 00 00       	mov    $0x40,%edi
}
  106978:	5b                   	pop    %ebx
  106979:	89 f8                	mov    %edi,%eax
  10697b:	5e                   	pop    %esi
  10697c:	5f                   	pop    %edi
  10697d:	5d                   	pop    %ebp
  10697e:	c3                   	ret    
  10697f:	90                   	nop

00106980 <container_alloc>:
 * Allocates one more page for process # [id], given that this will not exceed the quota.
 * The container structure should be updated accordingly after the allocation.
 * Returns the page index of the allocated page, or 0 in the case of failure.
 */
unsigned int container_alloc(unsigned int id)
{
  106980:	57                   	push   %edi
  106981:	56                   	push   %esi
  106982:	53                   	push   %ebx
  106983:	8b 74 24 10          	mov    0x10(%esp),%esi
  106987:	e8 fd 99 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10698c:	81 c3 74 a6 00 00    	add    $0xa674,%ebx
    unsigned int page_index = 0;

    spinlock_acquire(&container_lks[id]);
  106992:	83 ec 0c             	sub    $0xc,%esp
  106995:	8d bc f3 80 14 87 00 	lea    0x871480(%ebx,%esi,8),%edi
  10699c:	57                   	push   %edi
  10699d:	e8 de ed ff ff       	call   105780 <spinlock_acquire>

    if (CONTAINER[id].usage + 1 <= CONTAINER[id].quota) {
  1069a2:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  1069a5:	83 c4 10             	add    $0x10,%esp
  1069a8:	31 f6                	xor    %esi,%esi
  1069aa:	c1 e2 02             	shl    $0x2,%edx
  1069ad:	8d 8c 13 80 16 87 00 	lea    0x871680(%ebx,%edx,1),%ecx
  1069b4:	8b 41 04             	mov    0x4(%ecx),%eax
  1069b7:	3b 84 13 80 16 87 00 	cmp    0x871680(%ebx,%edx,1),%eax
  1069be:	7c 18                	jl     1069d8 <container_alloc+0x58>
        CONTAINER[id].usage++;
        page_index = palloc();
    }

    spinlock_release(&container_lks[id]);
  1069c0:	83 ec 0c             	sub    $0xc,%esp
  1069c3:	57                   	push   %edi
  1069c4:	e8 37 ee ff ff       	call   105800 <spinlock_release>

    return page_index;
  1069c9:	83 c4 10             	add    $0x10,%esp
}
  1069cc:	89 f0                	mov    %esi,%eax
  1069ce:	5b                   	pop    %ebx
  1069cf:	5e                   	pop    %esi
  1069d0:	5f                   	pop    %edi
  1069d1:	c3                   	ret    
  1069d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        CONTAINER[id].usage++;
  1069d8:	83 c0 01             	add    $0x1,%eax
  1069db:	89 41 04             	mov    %eax,0x4(%ecx)
        page_index = palloc();
  1069de:	e8 6d fc ff ff       	call   106650 <palloc>
  1069e3:	89 c6                	mov    %eax,%esi
  1069e5:	eb d9                	jmp    1069c0 <container_alloc+0x40>
  1069e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1069ee:	66 90                	xchg   %ax,%ax

001069f0 <container_free>:

// Frees the physical page and reduces the usage by 1.
void container_free(unsigned int id, unsigned int page_index)
{
  1069f0:	55                   	push   %ebp
  1069f1:	57                   	push   %edi
  1069f2:	56                   	push   %esi
  1069f3:	53                   	push   %ebx
  1069f4:	e8 90 99 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1069f9:	81 c3 07 a6 00 00    	add    $0xa607,%ebx
  1069ff:	83 ec 18             	sub    $0x18,%esp
  106a02:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  106a06:	8b 7c 24 30          	mov    0x30(%esp),%edi
    spinlock_acquire(&container_lks[id]);
  106a0a:	8d ac f3 80 14 87 00 	lea    0x871480(%ebx,%esi,8),%ebp
  106a11:	55                   	push   %ebp
  106a12:	e8 69 ed ff ff       	call   105780 <spinlock_acquire>

    if (at_is_allocated(page_index)) {
  106a17:	89 3c 24             	mov    %edi,(%esp)
  106a1a:	e8 41 fa ff ff       	call   106460 <at_is_allocated>
  106a1f:	83 c4 10             	add    $0x10,%esp
  106a22:	85 c0                	test   %eax,%eax
  106a24:	75 1a                	jne    106a40 <container_free+0x50>
        if (CONTAINER[id].usage > 0) {
            CONTAINER[id].usage--;
        }
    }

    spinlock_release(&container_lks[id]);
  106a26:	83 ec 0c             	sub    $0xc,%esp
  106a29:	55                   	push   %ebp
  106a2a:	e8 d1 ed ff ff       	call   105800 <spinlock_release>
}
  106a2f:	83 c4 1c             	add    $0x1c,%esp
  106a32:	5b                   	pop    %ebx
  106a33:	5e                   	pop    %esi
  106a34:	5f                   	pop    %edi
  106a35:	5d                   	pop    %ebp
  106a36:	c3                   	ret    
  106a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106a3e:	66 90                	xchg   %ax,%ax
        pfree(page_index);
  106a40:	83 ec 0c             	sub    $0xc,%esp
  106a43:	57                   	push   %edi
  106a44:	e8 c7 fc ff ff       	call   106710 <pfree>
        if (CONTAINER[id].usage > 0) {
  106a49:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  106a4c:	83 c4 10             	add    $0x10,%esp
  106a4f:	8d 94 83 80 16 87 00 	lea    0x871680(%ebx,%eax,4),%edx
  106a56:	8b 42 04             	mov    0x4(%edx),%eax
  106a59:	85 c0                	test   %eax,%eax
  106a5b:	7e c9                	jle    106a26 <container_free+0x36>
            CONTAINER[id].usage--;
  106a5d:	83 e8 01             	sub    $0x1,%eax
  106a60:	89 42 04             	mov    %eax,0x4(%edx)
  106a63:	eb c1                	jmp    106a26 <container_free+0x36>
  106a65:	66 90                	xchg   %ax,%ax
  106a67:	66 90                	xchg   %ax,%ax
  106a69:	66 90                	xchg   %ax,%ax
  106a6b:	66 90                	xchg   %ax,%ax
  106a6d:	66 90                	xchg   %ax,%ax
  106a6f:	90                   	nop

00106a70 <set_pdir_base>:
 */
unsigned int IDPTbl[1024][1024] gcc_aligned(PAGESIZE);

// Sets the CR3 register with the start address of the page structure for process # [index].
void set_pdir_base(unsigned int index)
{
  106a70:	53                   	push   %ebx
  106a71:	e8 13 99 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106a76:	81 c3 8a a5 00 00    	add    $0xa58a,%ebx
  106a7c:	83 ec 14             	sub    $0x14,%esp
    set_cr3(PDirPool[index]);
  106a7f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  106a83:	c1 e0 0c             	shl    $0xc,%eax
  106a86:	8d 84 03 00 20 c7 00 	lea    0xc72000(%ebx,%eax,1),%eax
  106a8d:	50                   	push   %eax
  106a8e:	e8 fd a6 ff ff       	call   101190 <set_cr3>
}
  106a93:	83 c4 18             	add    $0x18,%esp
  106a96:	5b                   	pop    %ebx
  106a97:	c3                   	ret    
  106a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106a9f:	90                   	nop

00106aa0 <get_pdir_entry>:

// Returns the page directory entry # [pde_index] of the process # [proc_index].
// This can be used to test whether the page directory entry is mapped.
unsigned int get_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    return (unsigned int) PDirPool[proc_index][pde_index];
  106aa0:	e8 e0 98 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106aa5:	81 c2 5b a5 00 00    	add    $0xa55b,%edx
  106aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  106aaf:	c1 e0 0a             	shl    $0xa,%eax
  106ab2:	03 44 24 08          	add    0x8(%esp),%eax
  106ab6:	8b 84 82 00 20 c7 00 	mov    0xc72000(%edx,%eax,4),%eax
}
  106abd:	c3                   	ret    
  106abe:	66 90                	xchg   %ax,%ax

00106ac0 <set_pdir_entry>:
// You should also set the permissions PTE_P, PTE_W, and PTE_U.
void set_pdir_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int page_index)
{
    unsigned int addr = page_index << 12;
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106ac0:	e8 ce dd ff ff       	call   104893 <__x86.get_pc_thunk.cx>
  106ac5:	81 c1 3b a5 00 00    	add    $0xa53b,%ecx
    unsigned int addr = page_index << 12;
  106acb:	8b 54 24 0c          	mov    0xc(%esp),%edx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106acf:	8b 44 24 04          	mov    0x4(%esp),%eax
    unsigned int addr = page_index << 12;
  106ad3:	c1 e2 0c             	shl    $0xc,%edx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106ad6:	c1 e0 0a             	shl    $0xa,%eax
  106ad9:	03 44 24 08          	add    0x8(%esp),%eax
  106add:	83 ca 07             	or     $0x7,%edx
  106ae0:	89 94 81 00 20 c7 00 	mov    %edx,0xc72000(%ecx,%eax,4)
}
  106ae7:	c3                   	ret    
  106ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106aef:	90                   	nop

00106af0 <set_pdir_entry_identity>:
// with the initial address of page directory # [pde_index] in IDPTbl.
// You should also set the permissions PTE_P, PTE_W, and PTE_U.
// This will be used to map a page directory entry to an identity page table.
void set_pdir_entry_identity(unsigned int proc_index, unsigned int pde_index)
{
    unsigned int addr = (unsigned int) IDPTbl[pde_index];
  106af0:	e8 9e dd ff ff       	call   104893 <__x86.get_pc_thunk.cx>
  106af5:	81 c1 0b a5 00 00    	add    $0xa50b,%ecx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106afb:	8b 44 24 04          	mov    0x4(%esp),%eax
{
  106aff:	8b 54 24 08          	mov    0x8(%esp),%edx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106b03:	c1 e0 0a             	shl    $0xa,%eax
  106b06:	01 d0                	add    %edx,%eax
    unsigned int addr = (unsigned int) IDPTbl[pde_index];
  106b08:	c1 e2 0c             	shl    $0xc,%edx
  106b0b:	8d 94 11 00 20 87 00 	lea    0x872000(%ecx,%edx,1),%edx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106b12:	83 ca 07             	or     $0x7,%edx
  106b15:	89 94 81 00 20 c7 00 	mov    %edx,0xc72000(%ecx,%eax,4)
}
  106b1c:	c3                   	ret    
  106b1d:	8d 76 00             	lea    0x0(%esi),%esi

00106b20 <rmv_pdir_entry>:

// Removes the specified page directory entry (sets the page directory entry to 0).
// Don't forget to cast the value to (unsigned int *).
void rmv_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    PDirPool[proc_index][pde_index] = (unsigned int *) 0;
  106b20:	e8 60 98 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106b25:	81 c2 db a4 00 00    	add    $0xa4db,%edx
  106b2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  106b2f:	c1 e0 0a             	shl    $0xa,%eax
  106b32:	03 44 24 08          	add    0x8(%esp),%eax
  106b36:	c7 84 82 00 20 c7 00 	movl   $0x0,0xc72000(%edx,%eax,4)
  106b3d:	00 00 00 00 
}
  106b41:	c3                   	ret    
  106b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106b50 <get_ptbl_entry>:
// Do not forget that the permission info is also stored in the page directory entries.
unsigned int get_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                            unsigned int pte_index)
{
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
    return pt[pte_index];
  106b50:	e8 30 98 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106b55:	81 c2 ab a4 00 00    	add    $0xa4ab,%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106b5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  106b5f:	c1 e0 0a             	shl    $0xa,%eax
  106b62:	03 44 24 08          	add    0x8(%esp),%eax
  106b66:	8b 84 82 00 20 c7 00 	mov    0xc72000(%edx,%eax,4),%eax
    return pt[pte_index];
  106b6d:	8b 54 24 0c          	mov    0xc(%esp),%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106b71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return pt[pte_index];
  106b76:	8b 04 90             	mov    (%eax,%edx,4),%eax
}
  106b79:	c3                   	ret    
  106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106b80 <set_ptbl_entry>:
void set_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int pte_index, unsigned int page_index,
                    unsigned int perm)
{
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
    pt[pte_index] = (page_index << 12) | perm;
  106b80:	e8 00 98 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106b85:	81 c2 7b a4 00 00    	add    $0xa47b,%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106b8b:	8b 44 24 04          	mov    0x4(%esp),%eax
    pt[pte_index] = (page_index << 12) | perm;
  106b8f:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106b93:	c1 e0 0a             	shl    $0xa,%eax
  106b96:	03 44 24 08          	add    0x8(%esp),%eax
  106b9a:	8b 94 82 00 20 c7 00 	mov    0xc72000(%edx,%eax,4),%edx
    pt[pte_index] = (page_index << 12) | perm;
  106ba1:	8b 44 24 10          	mov    0x10(%esp),%eax
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106ba5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    pt[pte_index] = (page_index << 12) | perm;
  106bab:	c1 e0 0c             	shl    $0xc,%eax
  106bae:	0b 44 24 14          	or     0x14(%esp),%eax
  106bb2:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
}
  106bb5:	c3                   	ret    
  106bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106bbd:	8d 76 00             	lea    0x0(%esi),%esi

00106bc0 <set_ptbl_entry_identity>:

// Sets up the specified page table entry in IDPTbl as the identity map.
// You should also set the given permission.
void set_ptbl_entry_identity(unsigned int pde_index, unsigned int pte_index,
                             unsigned int perm)
{
  106bc0:	53                   	push   %ebx
  106bc1:	8b 54 24 08          	mov    0x8(%esp),%edx
  106bc5:	e8 bf 97 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106bca:	81 c3 36 a4 00 00    	add    $0xa436,%ebx
  106bd0:	8b 44 24 0c          	mov    0xc(%esp),%eax
    unsigned int addr = (pde_index << 22) | (pte_index << 12);
    IDPTbl[pde_index][pte_index] = addr | perm;
  106bd4:	89 d1                	mov    %edx,%ecx
    unsigned int addr = (pde_index << 22) | (pte_index << 12);
  106bd6:	c1 e2 16             	shl    $0x16,%edx
    IDPTbl[pde_index][pte_index] = addr | perm;
  106bd9:	c1 e1 0a             	shl    $0xa,%ecx
  106bdc:	01 c1                	add    %eax,%ecx
    unsigned int addr = (pde_index << 22) | (pte_index << 12);
  106bde:	c1 e0 0c             	shl    $0xc,%eax
    IDPTbl[pde_index][pte_index] = addr | perm;
  106be1:	0b 44 24 10          	or     0x10(%esp),%eax
  106be5:	09 d0                	or     %edx,%eax
  106be7:	89 84 8b 00 20 87 00 	mov    %eax,0x872000(%ebx,%ecx,4)
}
  106bee:	5b                   	pop    %ebx
  106bef:	c3                   	ret    

00106bf0 <rmv_ptbl_entry>:
// Sets the specified page table entry to 0.
void rmv_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int pte_index)
{
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
    pt[pte_index] = 0;
  106bf0:	e8 90 97 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  106bf5:	81 c2 0b a4 00 00    	add    $0xa40b,%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106bfb:	8b 44 24 04          	mov    0x4(%esp),%eax
  106bff:	c1 e0 0a             	shl    $0xa,%eax
  106c02:	03 44 24 08          	add    0x8(%esp),%eax
  106c06:	8b 84 82 00 20 c7 00 	mov    0xc72000(%edx,%eax,4),%eax
    pt[pte_index] = 0;
  106c0d:	8b 54 24 0c          	mov    0xc(%esp),%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106c11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    pt[pte_index] = 0;
  106c16:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
}
  106c1d:	c3                   	ret    
  106c1e:	66 90                	xchg   %ax,%ax

00106c20 <get_ptbl_entry_by_va>:
 * Returns the page table entry corresponding to the virtual address,
 * according to the page structure of process # [proc_index].
 * Returns 0 if the mapping does not exist.
 */
unsigned int get_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  106c20:	55                   	push   %ebp
  106c21:	57                   	push   %edi
  106c22:	56                   	push   %esi
  106c23:	53                   	push   %ebx
  106c24:	e8 60 97 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106c29:	81 c3 d7 a3 00 00    	add    $0xa3d7,%ebx
  106c2f:	83 ec 14             	sub    $0x14,%esp
  106c32:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  106c36:	8b 7c 24 28          	mov    0x28(%esp),%edi
    unsigned int pde_index = PDE_ADDR(vaddr);
  106c3a:	89 f5                	mov    %esi,%ebp
  106c3c:	c1 ed 16             	shr    $0x16,%ebp
    if (get_pdir_entry(proc_index, pde_index) != 0) {
  106c3f:	55                   	push   %ebp
  106c40:	57                   	push   %edi
  106c41:	e8 5a fe ff ff       	call   106aa0 <get_pdir_entry>
  106c46:	83 c4 10             	add    $0x10,%esp
  106c49:	85 c0                	test   %eax,%eax
  106c4b:	75 0b                	jne    106c58 <get_ptbl_entry_by_va+0x38>
        return get_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
    } else {
        return 0;
    }
}
  106c4d:	83 c4 0c             	add    $0xc,%esp
  106c50:	5b                   	pop    %ebx
  106c51:	5e                   	pop    %esi
  106c52:	5f                   	pop    %edi
  106c53:	5d                   	pop    %ebp
  106c54:	c3                   	ret    
  106c55:	8d 76 00             	lea    0x0(%esi),%esi
        return get_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
  106c58:	c1 ee 0c             	shr    $0xc,%esi
  106c5b:	83 ec 04             	sub    $0x4,%esp
  106c5e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  106c64:	56                   	push   %esi
  106c65:	55                   	push   %ebp
  106c66:	57                   	push   %edi
  106c67:	e8 e4 fe ff ff       	call   106b50 <get_ptbl_entry>
  106c6c:	83 c4 10             	add    $0x10,%esp
}
  106c6f:	83 c4 0c             	add    $0xc,%esp
  106c72:	5b                   	pop    %ebx
  106c73:	5e                   	pop    %esi
  106c74:	5f                   	pop    %edi
  106c75:	5d                   	pop    %ebp
  106c76:	c3                   	ret    
  106c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106c7e:	66 90                	xchg   %ax,%ax

00106c80 <get_pdir_entry_by_va>:

// Returns the page directory entry corresponding to the given virtual address.
unsigned int get_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  106c80:	53                   	push   %ebx
  106c81:	e8 03 97 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106c86:	81 c3 7a a3 00 00    	add    $0xa37a,%ebx
  106c8c:	83 ec 10             	sub    $0x10,%esp
    return get_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106c8f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  106c93:	c1 e8 16             	shr    $0x16,%eax
  106c96:	50                   	push   %eax
  106c97:	ff 74 24 1c          	push   0x1c(%esp)
  106c9b:	e8 00 fe ff ff       	call   106aa0 <get_pdir_entry>
}
  106ca0:	83 c4 18             	add    $0x18,%esp
  106ca3:	5b                   	pop    %ebx
  106ca4:	c3                   	ret    
  106ca5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106cb0 <rmv_ptbl_entry_by_va>:

// Removes the page table entry for the given virtual address.
void rmv_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  106cb0:	55                   	push   %ebp
  106cb1:	57                   	push   %edi
  106cb2:	56                   	push   %esi
  106cb3:	53                   	push   %ebx
  106cb4:	e8 d0 96 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106cb9:	81 c3 47 a3 00 00    	add    $0xa347,%ebx
  106cbf:	83 ec 14             	sub    $0x14,%esp
  106cc2:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  106cc6:	8b 7c 24 28          	mov    0x28(%esp),%edi
    unsigned int pde_index = PDE_ADDR(vaddr);
  106cca:	89 f5                	mov    %esi,%ebp
  106ccc:	c1 ed 16             	shr    $0x16,%ebp
    if (get_pdir_entry(proc_index, pde_index) != 0) {
  106ccf:	55                   	push   %ebp
  106cd0:	57                   	push   %edi
  106cd1:	e8 ca fd ff ff       	call   106aa0 <get_pdir_entry>
  106cd6:	83 c4 10             	add    $0x10,%esp
  106cd9:	85 c0                	test   %eax,%eax
  106cdb:	75 0b                	jne    106ce8 <rmv_ptbl_entry_by_va+0x38>
        rmv_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
    }
}
  106cdd:	83 c4 0c             	add    $0xc,%esp
  106ce0:	5b                   	pop    %ebx
  106ce1:	5e                   	pop    %esi
  106ce2:	5f                   	pop    %edi
  106ce3:	5d                   	pop    %ebp
  106ce4:	c3                   	ret    
  106ce5:	8d 76 00             	lea    0x0(%esi),%esi
        rmv_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
  106ce8:	c1 ee 0c             	shr    $0xc,%esi
  106ceb:	83 ec 04             	sub    $0x4,%esp
  106cee:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  106cf4:	56                   	push   %esi
  106cf5:	55                   	push   %ebp
  106cf6:	57                   	push   %edi
  106cf7:	e8 f4 fe ff ff       	call   106bf0 <rmv_ptbl_entry>
  106cfc:	83 c4 10             	add    $0x10,%esp
}
  106cff:	83 c4 0c             	add    $0xc,%esp
  106d02:	5b                   	pop    %ebx
  106d03:	5e                   	pop    %esi
  106d04:	5f                   	pop    %edi
  106d05:	5d                   	pop    %ebp
  106d06:	c3                   	ret    
  106d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106d0e:	66 90                	xchg   %ax,%ax

00106d10 <rmv_pdir_entry_by_va>:

// Removes the page directory entry for the given virtual address.
void rmv_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  106d10:	53                   	push   %ebx
  106d11:	e8 73 96 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106d16:	81 c3 ea a2 00 00    	add    $0xa2ea,%ebx
  106d1c:	83 ec 10             	sub    $0x10,%esp
    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106d1f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  106d23:	c1 e8 16             	shr    $0x16,%eax
  106d26:	50                   	push   %eax
  106d27:	ff 74 24 1c          	push   0x1c(%esp)
  106d2b:	e8 f0 fd ff ff       	call   106b20 <rmv_pdir_entry>
}
  106d30:	83 c4 18             	add    $0x18,%esp
  106d33:	5b                   	pop    %ebx
  106d34:	c3                   	ret    
  106d35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106d40 <set_ptbl_entry_by_va>:

// Maps the virtual address [vaddr] to the physical page # [page_index] with permission [perm].
// You do not need to worry about the page directory entry. just map the page table entry.
void set_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr,
                          unsigned int page_index, unsigned int perm)
{
  106d40:	53                   	push   %ebx
  106d41:	e8 43 96 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106d46:	81 c3 ba a2 00 00    	add    $0xa2ba,%ebx
  106d4c:	83 ec 14             	sub    $0x14,%esp
  106d4f:	8b 44 24 20          	mov    0x20(%esp),%eax
    set_ptbl_entry(proc_index, PDE_ADDR(vaddr), PTE_ADDR(vaddr), page_index, perm);
  106d53:	ff 74 24 28          	push   0x28(%esp)
  106d57:	ff 74 24 28          	push   0x28(%esp)
  106d5b:	89 c2                	mov    %eax,%edx
  106d5d:	c1 e8 16             	shr    $0x16,%eax
  106d60:	c1 ea 0c             	shr    $0xc,%edx
  106d63:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  106d69:	52                   	push   %edx
  106d6a:	50                   	push   %eax
  106d6b:	ff 74 24 2c          	push   0x2c(%esp)
  106d6f:	e8 0c fe ff ff       	call   106b80 <set_ptbl_entry>
}
  106d74:	83 c4 28             	add    $0x28,%esp
  106d77:	5b                   	pop    %ebx
  106d78:	c3                   	ret    
  106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106d80 <set_pdir_entry_by_va>:

// Registers the mapping from [vaddr] to physical page # [page_index] in the page directory.
void set_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr,
                          unsigned int page_index)
{
  106d80:	53                   	push   %ebx
  106d81:	e8 03 96 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106d86:	81 c3 7a a2 00 00    	add    $0xa27a,%ebx
  106d8c:	83 ec 0c             	sub    $0xc,%esp
    set_pdir_entry(proc_index, PDE_ADDR(vaddr), page_index);
  106d8f:	ff 74 24 1c          	push   0x1c(%esp)
  106d93:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  106d97:	c1 e8 16             	shr    $0x16,%eax
  106d9a:	50                   	push   %eax
  106d9b:	ff 74 24 1c          	push   0x1c(%esp)
  106d9f:	e8 1c fd ff ff       	call   106ac0 <set_pdir_entry>
}
  106da4:	83 c4 18             	add    $0x18,%esp
  106da7:	5b                   	pop    %ebx
  106da8:	c3                   	ret    
  106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106db0 <idptbl_init>:

// Initializes the identity page table.
// The permission for the kernel memory should be PTE_P, PTE_W, and PTE_G,
// While the permission for the rest should be PTE_P and PTE_W.
void idptbl_init(unsigned int mbi_addr)
{
  106db0:	55                   	push   %ebp
    unsigned int pde_index, pte_index, perm;
    container_init(mbi_addr);

    // Set up IDPTbl
    for (pde_index = 0; pde_index < 1024; pde_index++) {
  106db1:	31 ed                	xor    %ebp,%ebp
{
  106db3:	57                   	push   %edi
  106db4:	56                   	push   %esi
  106db5:	53                   	push   %ebx
  106db6:	e8 ce 95 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106dbb:	81 c3 45 a2 00 00    	add    $0xa245,%ebx
  106dc1:	83 ec 18             	sub    $0x18,%esp
    container_init(mbi_addr);
  106dc4:	ff 74 24 2c          	push   0x2c(%esp)
  106dc8:	e8 73 f9 ff ff       	call   106740 <container_init>
  106dcd:	83 c4 10             	add    $0x10,%esp
        if ((pde_index < VM_USERLO_PDE) || (VM_USERHI_PDE <= pde_index)) {
  106dd0:	8d 85 00 ff ff ff    	lea    -0x100(%ebp),%eax
            // kernel mapping
            perm = PTE_P | PTE_W | PTE_G;
        } else {
            // normal memory
            perm = PTE_P | PTE_W;
  106dd6:	3d c0 02 00 00       	cmp    $0x2c0,%eax
  106ddb:	19 ff                	sbb    %edi,%edi
        }

        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106ddd:	31 f6                	xor    %esi,%esi
            perm = PTE_P | PTE_W;
  106ddf:	81 e7 00 ff ff ff    	and    $0xffffff00,%edi
  106de5:	81 c7 03 01 00 00    	add    $0x103,%edi
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106def:	90                   	nop
            set_ptbl_entry_identity(pde_index, pte_index, perm);
  106df0:	83 ec 04             	sub    $0x4,%esp
  106df3:	57                   	push   %edi
  106df4:	56                   	push   %esi
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106df5:	83 c6 01             	add    $0x1,%esi
            set_ptbl_entry_identity(pde_index, pte_index, perm);
  106df8:	55                   	push   %ebp
  106df9:	e8 c2 fd ff ff       	call   106bc0 <set_ptbl_entry_identity>
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106dfe:	83 c4 10             	add    $0x10,%esp
  106e01:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106e07:	75 e7                	jne    106df0 <idptbl_init+0x40>
    for (pde_index = 0; pde_index < 1024; pde_index++) {
  106e09:	83 c5 01             	add    $0x1,%ebp
  106e0c:	81 fd 00 04 00 00    	cmp    $0x400,%ebp
  106e12:	75 bc                	jne    106dd0 <idptbl_init+0x20>
        }
    }
}
  106e14:	83 c4 0c             	add    $0xc,%esp
  106e17:	5b                   	pop    %ebx
  106e18:	5e                   	pop    %esi
  106e19:	5f                   	pop    %edi
  106e1a:	5d                   	pop    %ebp
  106e1b:	c3                   	ret    
  106e1c:	66 90                	xchg   %ax,%ax
  106e1e:	66 90                	xchg   %ax,%ax

00106e20 <pdir_init>:
 * For each process from id 0 to NUM_IDS - 1,
 * set up the page directory entries so that the kernel portion of the map is
 * the identity map, and the rest of the page directories are unmapped.
 */
void pdir_init(unsigned int mbi_addr)
{
  106e20:	57                   	push   %edi
    unsigned int proc_index, pde_index;
    idptbl_init(mbi_addr);

    for (proc_index = 0; proc_index < NUM_IDS; proc_index++) {
  106e21:	31 ff                	xor    %edi,%edi
{
  106e23:	56                   	push   %esi
  106e24:	53                   	push   %ebx
  106e25:	e8 5f 95 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106e2a:	81 c3 d6 a1 00 00    	add    $0xa1d6,%ebx
    idptbl_init(mbi_addr);
  106e30:	83 ec 0c             	sub    $0xc,%esp
  106e33:	ff 74 24 1c          	push   0x1c(%esp)
  106e37:	e8 74 ff ff ff       	call   106db0 <idptbl_init>
  106e3c:	83 c4 10             	add    $0x10,%esp
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106e3f:	31 c0                	xor    %eax,%eax
  106e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if ((pde_index < VM_USERLO_PDE) || (VM_USERHI_PDE <= pde_index)) {
  106e48:	8d 90 00 ff ff ff    	lea    -0x100(%eax),%edx
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106e4e:	8d 70 01             	lea    0x1(%eax),%esi
            if ((pde_index < VM_USERLO_PDE) || (VM_USERHI_PDE <= pde_index)) {
  106e51:	81 fa bf 02 00 00    	cmp    $0x2bf,%edx
  106e57:	77 11                	ja     106e6a <pdir_init+0x4a>
                set_pdir_entry_identity(proc_index, pde_index);
            } else {
                rmv_pdir_entry(proc_index, pde_index);
  106e59:	83 ec 08             	sub    $0x8,%esp
  106e5c:	50                   	push   %eax
  106e5d:	57                   	push   %edi
  106e5e:	e8 bd fc ff ff       	call   106b20 <rmv_pdir_entry>
  106e63:	83 c4 10             	add    $0x10,%esp
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106e66:	89 f0                	mov    %esi,%eax
  106e68:	eb de                	jmp    106e48 <pdir_init+0x28>
                set_pdir_entry_identity(proc_index, pde_index);
  106e6a:	83 ec 08             	sub    $0x8,%esp
  106e6d:	50                   	push   %eax
  106e6e:	57                   	push   %edi
  106e6f:	e8 7c fc ff ff       	call   106af0 <set_pdir_entry_identity>
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106e74:	83 c4 10             	add    $0x10,%esp
  106e77:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106e7d:	75 e7                	jne    106e66 <pdir_init+0x46>
    for (proc_index = 0; proc_index < NUM_IDS; proc_index++) {
  106e7f:	83 c7 01             	add    $0x1,%edi
  106e82:	83 ff 40             	cmp    $0x40,%edi
  106e85:	75 b8                	jne    106e3f <pdir_init+0x1f>
            }
        }
    }
}
  106e87:	5b                   	pop    %ebx
  106e88:	5e                   	pop    %esi
  106e89:	5f                   	pop    %edi
  106e8a:	c3                   	ret    
  106e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106e8f:	90                   	nop

00106e90 <alloc_ptbl>:
 * and clears (set to 0) all page table entries for this newly mapped page table.
 * It returns the page index of the newly allocated physical page.
 * In the case when there's no physical page available, it returns 0.
 */
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vaddr)
{
  106e90:	55                   	push   %ebp
  106e91:	57                   	push   %edi
  106e92:	56                   	push   %esi
  106e93:	53                   	push   %ebx
  106e94:	e8 f0 94 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106e99:	81 c3 67 a1 00 00    	add    $0xa167,%ebx
  106e9f:	83 ec 28             	sub    $0x28,%esp
  106ea2:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    unsigned int page_index = container_alloc(proc_index);
  106ea6:	56                   	push   %esi
  106ea7:	e8 d4 fa ff ff       	call   106980 <container_alloc>
  106eac:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    unsigned int pde_index = PDE_ADDR(vaddr);
    unsigned int pte_index;

    if (page_index == 0) {
  106eb0:	83 c4 10             	add    $0x10,%esp
  106eb3:	85 c0                	test   %eax,%eax
  106eb5:	75 0c                	jne    106ec3 <alloc_ptbl+0x33>
            rmv_ptbl_entry(proc_index, pde_index, pte_index);
        }

        return page_index;
    }
}
  106eb7:	8b 44 24 0c          	mov    0xc(%esp),%eax
  106ebb:	83 c4 1c             	add    $0x1c,%esp
  106ebe:	5b                   	pop    %ebx
  106ebf:	5e                   	pop    %esi
  106ec0:	5f                   	pop    %edi
  106ec1:	5d                   	pop    %ebp
  106ec2:	c3                   	ret    
    unsigned int pde_index = PDE_ADDR(vaddr);
  106ec3:	8b 7c 24 34          	mov    0x34(%esp),%edi
        set_pdir_entry_by_va(proc_index, vaddr, page_index);
  106ec7:	83 ec 04             	sub    $0x4,%esp
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106eca:	31 ed                	xor    %ebp,%ebp
        set_pdir_entry_by_va(proc_index, vaddr, page_index);
  106ecc:	50                   	push   %eax
  106ecd:	ff 74 24 3c          	push   0x3c(%esp)
    unsigned int pde_index = PDE_ADDR(vaddr);
  106ed1:	c1 ef 16             	shr    $0x16,%edi
        set_pdir_entry_by_va(proc_index, vaddr, page_index);
  106ed4:	56                   	push   %esi
  106ed5:	e8 a6 fe ff ff       	call   106d80 <set_pdir_entry_by_va>
  106eda:	83 c4 10             	add    $0x10,%esp
  106edd:	8d 76 00             	lea    0x0(%esi),%esi
            rmv_ptbl_entry(proc_index, pde_index, pte_index);
  106ee0:	83 ec 04             	sub    $0x4,%esp
  106ee3:	55                   	push   %ebp
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106ee4:	83 c5 01             	add    $0x1,%ebp
            rmv_ptbl_entry(proc_index, pde_index, pte_index);
  106ee7:	57                   	push   %edi
  106ee8:	56                   	push   %esi
  106ee9:	e8 02 fd ff ff       	call   106bf0 <rmv_ptbl_entry>
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  106eee:	83 c4 10             	add    $0x10,%esp
  106ef1:	81 fd 00 04 00 00    	cmp    $0x400,%ebp
  106ef7:	75 e7                	jne    106ee0 <alloc_ptbl+0x50>
}
  106ef9:	8b 44 24 0c          	mov    0xc(%esp),%eax
  106efd:	83 c4 1c             	add    $0x1c,%esp
  106f00:	5b                   	pop    %ebx
  106f01:	5e                   	pop    %esi
  106f02:	5f                   	pop    %edi
  106f03:	5d                   	pop    %ebp
  106f04:	c3                   	ret    
  106f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106f10 <free_ptbl>:

// Reverse operation of alloc_ptbl.
// Removes corresponding the page directory entry,
// and frees the page for the page table entries (with container_free).
void free_ptbl(unsigned int proc_index, unsigned int vaddr)
{
  106f10:	55                   	push   %ebp
  106f11:	57                   	push   %edi
  106f12:	56                   	push   %esi
  106f13:	53                   	push   %ebx
  106f14:	e8 70 94 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106f19:	81 c3 e7 a0 00 00    	add    $0xa0e7,%ebx
  106f1f:	83 ec 14             	sub    $0x14,%esp
  106f22:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  106f26:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
    unsigned int page_index = get_pdir_entry_by_va(proc_index, vaddr) >> 12;
  106f2a:	57                   	push   %edi

    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106f2b:	c1 ef 16             	shr    $0x16,%edi
    unsigned int page_index = get_pdir_entry_by_va(proc_index, vaddr) >> 12;
  106f2e:	55                   	push   %ebp
  106f2f:	e8 4c fd ff ff       	call   106c80 <get_pdir_entry_by_va>
  106f34:	89 c6                	mov    %eax,%esi
    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106f36:	58                   	pop    %eax
  106f37:	5a                   	pop    %edx
  106f38:	57                   	push   %edi
  106f39:	55                   	push   %ebp
    unsigned int page_index = get_pdir_entry_by_va(proc_index, vaddr) >> 12;
  106f3a:	c1 ee 0c             	shr    $0xc,%esi
    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106f3d:	e8 de fb ff ff       	call   106b20 <rmv_pdir_entry>
    container_free(proc_index, page_index);
  106f42:	59                   	pop    %ecx
  106f43:	5f                   	pop    %edi
  106f44:	56                   	push   %esi
  106f45:	55                   	push   %ebp
  106f46:	e8 a5 fa ff ff       	call   1069f0 <container_free>
}
  106f4b:	83 c4 1c             	add    $0x1c,%esp
  106f4e:	5b                   	pop    %ebx
  106f4f:	5e                   	pop    %esi
  106f50:	5f                   	pop    %edi
  106f51:	5d                   	pop    %ebp
  106f52:	c3                   	ret    
  106f53:	66 90                	xchg   %ax,%ax
  106f55:	66 90                	xchg   %ax,%ax
  106f57:	66 90                	xchg   %ax,%ax
  106f59:	66 90                	xchg   %ax,%ax
  106f5b:	66 90                	xchg   %ax,%ax
  106f5d:	66 90                	xchg   %ax,%ax
  106f5f:	90                   	nop

00106f60 <pdir_init_kern>:
/**
 * Sets the entire page map for process 0 as the identity map.
 * Note that part of the task is already completed by pdir_init.
 */
void pdir_init_kern(unsigned int mbi_addr)
{
  106f60:	56                   	push   %esi
    unsigned int pde_index;

    pdir_init(mbi_addr);

    // Set identity map for user PDEs
    for (pde_index = VM_USERLO_PDE; pde_index < VM_USERHI_PDE; pde_index++) {
  106f61:	be 00 01 00 00       	mov    $0x100,%esi
{
  106f66:	53                   	push   %ebx
  106f67:	e8 1d 94 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106f6c:	81 c3 94 a0 00 00    	add    $0xa094,%ebx
  106f72:	83 ec 10             	sub    $0x10,%esp
    pdir_init(mbi_addr);
  106f75:	ff 74 24 1c          	push   0x1c(%esp)
  106f79:	e8 a2 fe ff ff       	call   106e20 <pdir_init>
  106f7e:	83 c4 10             	add    $0x10,%esp
  106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        set_pdir_entry_identity(0, pde_index);
  106f88:	83 ec 08             	sub    $0x8,%esp
  106f8b:	56                   	push   %esi
    for (pde_index = VM_USERLO_PDE; pde_index < VM_USERHI_PDE; pde_index++) {
  106f8c:	83 c6 01             	add    $0x1,%esi
        set_pdir_entry_identity(0, pde_index);
  106f8f:	6a 00                	push   $0x0
  106f91:	e8 5a fb ff ff       	call   106af0 <set_pdir_entry_identity>
    for (pde_index = VM_USERLO_PDE; pde_index < VM_USERHI_PDE; pde_index++) {
  106f96:	83 c4 10             	add    $0x10,%esp
  106f99:	81 fe c0 03 00 00    	cmp    $0x3c0,%esi
  106f9f:	75 e7                	jne    106f88 <pdir_init_kern+0x28>
    }
}
  106fa1:	83 c4 04             	add    $0x4,%esp
  106fa4:	5b                   	pop    %ebx
  106fa5:	5e                   	pop    %esi
  106fa6:	c3                   	ret    
  106fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106fae:	66 90                	xchg   %ax,%ax

00106fb0 <map_page>:
 * otherwise, it returns the physical page index registered in the page directory,
 * (the return value of get_pdir_entry_by_va or alloc_ptbl).
 */
unsigned int map_page(unsigned int proc_index, unsigned int vaddr,
                      unsigned int page_index, unsigned int perm)
{
  106fb0:	55                   	push   %ebp
  106fb1:	57                   	push   %edi
  106fb2:	56                   	push   %esi
  106fb3:	53                   	push   %ebx
  106fb4:	e8 d0 93 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  106fb9:	81 c3 47 a0 00 00    	add    $0xa047,%ebx
  106fbf:	83 ec 14             	sub    $0x14,%esp
  106fc2:	8b 7c 24 28          	mov    0x28(%esp),%edi
  106fc6:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
    unsigned int pde_entry = get_pdir_entry_by_va(proc_index, vaddr);
  106fca:	55                   	push   %ebp
  106fcb:	57                   	push   %edi
  106fcc:	e8 af fc ff ff       	call   106c80 <get_pdir_entry_by_va>
    unsigned int pde_page_index = pde_entry >> 12;

    if (pde_entry == 0) {
  106fd1:	83 c4 10             	add    $0x10,%esp
  106fd4:	85 c0                	test   %eax,%eax
  106fd6:	74 28                	je     107000 <map_page+0x50>
    unsigned int pde_page_index = pde_entry >> 12;
  106fd8:	c1 e8 0c             	shr    $0xc,%eax
  106fdb:	89 c6                	mov    %eax,%esi
        if (pde_page_index == 0) {
            return MagicNumber;
        }
    }

    set_ptbl_entry_by_va(proc_index, vaddr, page_index, perm);
  106fdd:	ff 74 24 2c          	push   0x2c(%esp)
  106fe1:	ff 74 24 2c          	push   0x2c(%esp)
  106fe5:	55                   	push   %ebp
  106fe6:	57                   	push   %edi
  106fe7:	e8 54 fd ff ff       	call   106d40 <set_ptbl_entry_by_va>
    return pde_page_index;
  106fec:	83 c4 10             	add    $0x10,%esp
}
  106fef:	89 f0                	mov    %esi,%eax
  106ff1:	83 c4 0c             	add    $0xc,%esp
  106ff4:	5b                   	pop    %ebx
  106ff5:	5e                   	pop    %esi
  106ff6:	5f                   	pop    %edi
  106ff7:	5d                   	pop    %ebp
  106ff8:	c3                   	ret    
  106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pde_page_index = alloc_ptbl(proc_index, vaddr);
  107000:	83 ec 08             	sub    $0x8,%esp
  107003:	55                   	push   %ebp
  107004:	57                   	push   %edi
  107005:	e8 86 fe ff ff       	call   106e90 <alloc_ptbl>
        if (pde_page_index == 0) {
  10700a:	83 c4 10             	add    $0x10,%esp
        pde_page_index = alloc_ptbl(proc_index, vaddr);
  10700d:	89 c6                	mov    %eax,%esi
        if (pde_page_index == 0) {
  10700f:	85 c0                	test   %eax,%eax
  107011:	75 ca                	jne    106fdd <map_page+0x2d>
}
  107013:	83 c4 0c             	add    $0xc,%esp
            return MagicNumber;
  107016:	be 01 00 10 00       	mov    $0x100001,%esi
}
  10701b:	5b                   	pop    %ebx
  10701c:	89 f0                	mov    %esi,%eax
  10701e:	5e                   	pop    %esi
  10701f:	5f                   	pop    %edi
  107020:	5d                   	pop    %ebp
  107021:	c3                   	ret    
  107022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00107030 <unmap_page>:
 * Nothing should be done if the mapping no longer exists.
 * You do not need to unmap the page table from the page directory.
 * It should return the corresponding page table entry.
 */
unsigned int unmap_page(unsigned int proc_index, unsigned int vaddr)
{
  107030:	57                   	push   %edi
  107031:	56                   	push   %esi
  107032:	53                   	push   %ebx
  107033:	e8 51 93 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107038:	81 c3 c8 9f 00 00    	add    $0x9fc8,%ebx
  10703e:	83 ec 18             	sub    $0x18,%esp
  107041:	8b 74 24 28          	mov    0x28(%esp),%esi
  107045:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
    unsigned int pte_entry = get_ptbl_entry_by_va(proc_index, vaddr);
  107049:	57                   	push   %edi
  10704a:	56                   	push   %esi
  10704b:	e8 d0 fb ff ff       	call   106c20 <get_ptbl_entry_by_va>
    if (pte_entry != 0) {
  107050:	83 c4 10             	add    $0x10,%esp
  107053:	85 c0                	test   %eax,%eax
  107055:	75 09                	jne    107060 <unmap_page+0x30>
        rmv_ptbl_entry_by_va(proc_index, vaddr);
    }
    return pte_entry;
}
  107057:	83 c4 10             	add    $0x10,%esp
  10705a:	5b                   	pop    %ebx
  10705b:	5e                   	pop    %esi
  10705c:	5f                   	pop    %edi
  10705d:	c3                   	ret    
  10705e:	66 90                	xchg   %ax,%ax
  107060:	89 44 24 0c          	mov    %eax,0xc(%esp)
        rmv_ptbl_entry_by_va(proc_index, vaddr);
  107064:	83 ec 08             	sub    $0x8,%esp
  107067:	57                   	push   %edi
  107068:	56                   	push   %esi
  107069:	e8 42 fc ff ff       	call   106cb0 <rmv_ptbl_entry_by_va>
  10706e:	83 c4 10             	add    $0x10,%esp
  107071:	8b 44 24 0c          	mov    0xc(%esp),%eax
}
  107075:	83 c4 10             	add    $0x10,%esp
  107078:	5b                   	pop    %ebx
  107079:	5e                   	pop    %esi
  10707a:	5f                   	pop    %edi
  10707b:	c3                   	ret    
  10707c:	66 90                	xchg   %ax,%ax
  10707e:	66 90                	xchg   %ax,%ax

00107080 <paging_init>:
/**
 * Initializes the page structures, moves to the kernel page structure (0),
 * and turns on the paging.
 */
void paging_init(unsigned int mbi_addr)
{
  107080:	53                   	push   %ebx
  107081:	e8 03 93 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107086:	81 c3 7a 9f 00 00    	add    $0x9f7a,%ebx
  10708c:	83 ec 14             	sub    $0x14,%esp
    pdir_init_kern(mbi_addr);
  10708f:	ff 74 24 1c          	push   0x1c(%esp)
  107093:	e8 c8 fe ff ff       	call   106f60 <pdir_init_kern>
    set_pdir_base(0);
  107098:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10709f:	e8 cc f9 ff ff       	call   106a70 <set_pdir_base>
    enable_paging();
  1070a4:	e8 07 a1 ff ff       	call   1011b0 <enable_paging>
}
  1070a9:	83 c4 18             	add    $0x18,%esp
  1070ac:	5b                   	pop    %ebx
  1070ad:	c3                   	ret    
  1070ae:	66 90                	xchg   %ax,%ax

001070b0 <paging_init_ap>:

void paging_init_ap(void)
{
  1070b0:	53                   	push   %ebx
  1070b1:	e8 d3 92 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1070b6:	81 c3 4a 9f 00 00    	add    $0x9f4a,%ebx
  1070bc:	83 ec 14             	sub    $0x14,%esp
    set_pdir_base(0);
  1070bf:	6a 00                	push   $0x0
  1070c1:	e8 aa f9 ff ff       	call   106a70 <set_pdir_base>
    enable_paging();
  1070c6:	e8 e5 a0 ff ff       	call   1011b0 <enable_paging>
}
  1070cb:	83 c4 18             	add    $0x18,%esp
  1070ce:	5b                   	pop    %ebx
  1070cf:	c3                   	ret    

001070d0 <alloc_page>:
 * return value from map_page.
 * In the case of error, it should return the constant MagicNumber.
 */
unsigned int alloc_page(unsigned int proc_index, unsigned int vaddr,
                        unsigned int perm)
{
  1070d0:	56                   	push   %esi
  1070d1:	53                   	push   %ebx
  1070d2:	e8 b2 92 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1070d7:	81 c3 29 9f 00 00    	add    $0x9f29,%ebx
  1070dd:	83 ec 10             	sub    $0x10,%esp
  1070e0:	8b 74 24 1c          	mov    0x1c(%esp),%esi
    unsigned int page_index = container_alloc(proc_index);
  1070e4:	56                   	push   %esi
  1070e5:	e8 96 f8 ff ff       	call   106980 <container_alloc>
    if (page_index != 0) {
  1070ea:	83 c4 10             	add    $0x10,%esp
  1070ed:	ba 01 00 10 00       	mov    $0x100001,%edx
  1070f2:	85 c0                	test   %eax,%eax
  1070f4:	74 14                	je     10710a <alloc_page+0x3a>
        return map_page(proc_index, vaddr, page_index, perm);
  1070f6:	ff 74 24 18          	push   0x18(%esp)
  1070fa:	50                   	push   %eax
  1070fb:	ff 74 24 1c          	push   0x1c(%esp)
  1070ff:	56                   	push   %esi
  107100:	e8 ab fe ff ff       	call   106fb0 <map_page>
  107105:	83 c4 10             	add    $0x10,%esp
  107108:	89 c2                	mov    %eax,%edx
    } else {
        return MagicNumber;
    }
}
  10710a:	83 c4 04             	add    $0x4,%esp
  10710d:	89 d0                	mov    %edx,%eax
  10710f:	5b                   	pop    %ebx
  107110:	5e                   	pop    %esi
  107111:	c3                   	ret    
  107112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00107120 <alloc_mem_quota>:

/**
 * Designate some memory quota for the next child process.
 */
unsigned int alloc_mem_quota(unsigned int id, unsigned int quota)
{
  107120:	53                   	push   %ebx
  107121:	e8 63 92 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107126:	81 c3 da 9e 00 00    	add    $0x9eda,%ebx
  10712c:	83 ec 10             	sub    $0x10,%esp
    unsigned int child;
    child = container_split(id, quota);
  10712f:	ff 74 24 1c          	push   0x1c(%esp)
  107133:	ff 74 24 1c          	push   0x1c(%esp)
  107137:	e8 a4 f7 ff ff       	call   1068e0 <container_split>
    return child;
}
  10713c:	83 c4 18             	add    $0x18,%esp
  10713f:	5b                   	pop    %ebx
  107140:	c3                   	ret    
  107141:	66 90                	xchg   %ax,%ax
  107143:	66 90                	xchg   %ax,%ax
  107145:	66 90                	xchg   %ax,%ax
  107147:	66 90                	xchg   %ax,%ax
  107149:	66 90                	xchg   %ax,%ax
  10714b:	66 90                	xchg   %ax,%ax
  10714d:	66 90                	xchg   %ax,%ax
  10714f:	90                   	nop

00107150 <kctx_set_esp>:
// Memory to save the NUM_IDS kernel thread states.
struct kctx kctx_pool[NUM_IDS];

void kctx_set_esp(unsigned int pid, void *esp)
{
    kctx_pool[pid].esp = esp;
  107150:	e8 30 92 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107155:	81 c2 ab 9e 00 00    	add    $0x9eab,%edx
{
  10715b:	8b 44 24 04          	mov    0x4(%esp),%eax
    kctx_pool[pid].esp = esp;
  10715f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107163:	8d 04 40             	lea    (%eax,%eax,2),%eax
  107166:	89 8c c2 00 20 cb 00 	mov    %ecx,0xcb2000(%edx,%eax,8)
}
  10716d:	c3                   	ret    
  10716e:	66 90                	xchg   %ax,%ax

00107170 <kctx_set_eip>:

void kctx_set_eip(unsigned int pid, void *eip)
{
    kctx_pool[pid].eip = eip;
  107170:	e8 10 92 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107175:	81 c2 8b 9e 00 00    	add    $0x9e8b,%edx
{
  10717b:	8b 44 24 04          	mov    0x4(%esp),%eax
    kctx_pool[pid].eip = eip;
  10717f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107183:	8d 04 40             	lea    (%eax,%eax,2),%eax
  107186:	89 8c c2 14 20 cb 00 	mov    %ecx,0xcb2014(%edx,%eax,8)
}
  10718d:	c3                   	ret    
  10718e:	66 90                	xchg   %ax,%ax

00107190 <kctx_switch>:
/**
 * Saves the states for thread # [from_pid] and restores the states
 * for thread # [to_pid].
 */
void kctx_switch(unsigned int from_pid, unsigned int to_pid)
{
  107190:	53                   	push   %ebx
  107191:	e8 f3 91 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107196:	81 c3 6a 9e 00 00    	add    $0x9e6a,%ebx
  10719c:	83 ec 10             	sub    $0x10,%esp
  10719f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1071a3:	8b 54 24 18          	mov    0x18(%esp),%edx
    cswitch(&kctx_pool[from_pid], &kctx_pool[to_pid]);
  1071a7:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
  1071aa:	8d 14 52             	lea    (%edx,%edx,2),%edx
  1071ad:	8d 83 00 20 cb 00    	lea    0xcb2000(%ebx),%eax
  1071b3:	8d 0c c8             	lea    (%eax,%ecx,8),%ecx
  1071b6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
  1071b9:	51                   	push   %ecx
  1071ba:	50                   	push   %eax
  1071bb:	e8 05 00 00 00       	call   1071c5 <cswitch>
}
  1071c0:	83 c4 18             	add    $0x18,%esp
  1071c3:	5b                   	pop    %ebx
  1071c4:	c3                   	ret    

001071c5 <cswitch>:
/*
 * void cswitch(struct kctx *from, struct kctx *to);
 */
	.globl cswitch
cswitch:
	movl	4(%esp), %eax	/* %eax <- from */
  1071c5:	8b 44 24 04          	mov    0x4(%esp),%eax
	movl	8(%esp), %edx	/* %edx <- to */
  1071c9:	8b 54 24 08          	mov    0x8(%esp),%edx

	/* save the old kernel context */
	movl	0(%esp), %ecx
  1071cd:	8b 0c 24             	mov    (%esp),%ecx
	movl	%ecx, 20(%eax)
  1071d0:	89 48 14             	mov    %ecx,0x14(%eax)
	movl	%ebp, 16(%eax)
  1071d3:	89 68 10             	mov    %ebp,0x10(%eax)
	movl	%ebx, 12(%eax)
  1071d6:	89 58 0c             	mov    %ebx,0xc(%eax)
	movl	%esi, 8(%eax)
  1071d9:	89 70 08             	mov    %esi,0x8(%eax)
	movl	%edi, 4(%eax)
  1071dc:	89 78 04             	mov    %edi,0x4(%eax)
	movl	%esp, 0(%eax)
  1071df:	89 20                	mov    %esp,(%eax)

	/* load the new kernel context */
	movl	0(%edx), %esp
  1071e1:	8b 22                	mov    (%edx),%esp
	movl	4(%edx), %edi
  1071e3:	8b 7a 04             	mov    0x4(%edx),%edi
	movl	8(%edx), %esi
  1071e6:	8b 72 08             	mov    0x8(%edx),%esi
	movl	12(%edx), %ebx
  1071e9:	8b 5a 0c             	mov    0xc(%edx),%ebx
	movl	16(%edx), %ebp
  1071ec:	8b 6a 10             	mov    0x10(%edx),%ebp
	movl	20(%edx), %ecx
  1071ef:	8b 4a 14             	mov    0x14(%edx),%ecx
	movl	%ecx, 0(%esp)
  1071f2:	89 0c 24             	mov    %ecx,(%esp)

	xor	%eax, %eax
  1071f5:	31 c0                	xor    %eax,%eax
	ret
  1071f7:	c3                   	ret    
  1071f8:	66 90                	xchg   %ax,%ax
  1071fa:	66 90                	xchg   %ax,%ax
  1071fc:	66 90                	xchg   %ax,%ax
  1071fe:	66 90                	xchg   %ax,%ax

00107200 <kctx_new>:
 * Don't forget the stack is going down from high address to low.
 * We do not care about the rest of states when a new thread starts.
 * The function returns the child thread (process) id.
 */
unsigned int kctx_new(void *entry, unsigned int id, unsigned int quota)
{
  107200:	55                   	push   %ebp
  107201:	57                   	push   %edi
  107202:	56                   	push   %esi
    unsigned int pid = NUM_IDS;
  107203:	be 40 00 00 00       	mov    $0x40,%esi
{
  107208:	53                   	push   %ebx
  107209:	e8 7b 91 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10720e:	81 c3 f2 9d 00 00    	add    $0x9df2,%ebx
  107214:	83 ec 14             	sub    $0x14,%esp
  107217:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  10721b:	8b 6c 24 30          	mov    0x30(%esp),%ebp

    if (container_can_consume(id, quota)) {
  10721f:	55                   	push   %ebp
  107220:	57                   	push   %edi
  107221:	e8 8a f6 ff ff       	call   1068b0 <container_can_consume>
  107226:	83 c4 10             	add    $0x10,%esp
  107229:	85 c0                	test   %eax,%eax
  10722b:	75 13                	jne    107240 <kctx_new+0x40>
            kctx_set_eip(pid, entry);
        }
    }

    return pid;
}
  10722d:	83 c4 0c             	add    $0xc,%esp
  107230:	89 f0                	mov    %esi,%eax
  107232:	5b                   	pop    %ebx
  107233:	5e                   	pop    %esi
  107234:	5f                   	pop    %edi
  107235:	5d                   	pop    %ebp
  107236:	c3                   	ret    
  107237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10723e:	66 90                	xchg   %ax,%ax
        pid = alloc_mem_quota(id, quota);
  107240:	83 ec 08             	sub    $0x8,%esp
  107243:	55                   	push   %ebp
  107244:	57                   	push   %edi
  107245:	e8 d6 fe ff ff       	call   107120 <alloc_mem_quota>
        if (pid != NUM_IDS) {
  10724a:	83 c4 10             	add    $0x10,%esp
        pid = alloc_mem_quota(id, quota);
  10724d:	89 c6                	mov    %eax,%esi
        if (pid != NUM_IDS) {
  10724f:	83 f8 40             	cmp    $0x40,%eax
  107252:	74 d9                	je     10722d <kctx_new+0x2d>
            kctx_set_esp(pid, proc_kstack[pid].kstack_hi);
  107254:	8d 40 01             	lea    0x1(%eax),%eax
  107257:	83 ec 08             	sub    $0x8,%esp
  10725a:	c1 e0 0c             	shl    $0xc,%eax
  10725d:	81 c0 00 a0 13 00    	add    $0x13a000,%eax
  107263:	50                   	push   %eax
  107264:	56                   	push   %esi
  107265:	e8 e6 fe ff ff       	call   107150 <kctx_set_esp>
            kctx_set_eip(pid, entry);
  10726a:	58                   	pop    %eax
  10726b:	5a                   	pop    %edx
  10726c:	ff 74 24 28          	push   0x28(%esp)
  107270:	56                   	push   %esi
  107271:	e8 fa fe ff ff       	call   107170 <kctx_set_eip>
  107276:	83 c4 10             	add    $0x10,%esp
}
  107279:	89 f0                	mov    %esi,%eax
  10727b:	83 c4 0c             	add    $0xc,%esp
  10727e:	5b                   	pop    %ebx
  10727f:	5e                   	pop    %esi
  107280:	5f                   	pop    %edi
  107281:	5d                   	pop    %ebp
  107282:	c3                   	ret    
  107283:	66 90                	xchg   %ax,%ax
  107285:	66 90                	xchg   %ax,%ax
  107287:	66 90                	xchg   %ax,%ax
  107289:	66 90                	xchg   %ax,%ax
  10728b:	66 90                	xchg   %ax,%ax
  10728d:	66 90                	xchg   %ax,%ax
  10728f:	90                   	nop

00107290 <tcb_get_state>:

struct TCB TCBPool[NUM_IDS];

unsigned int tcb_get_state(unsigned int pid)
{
    return TCBPool[pid].state;
  107290:	e8 f0 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107295:	81 c2 6b 9d 00 00    	add    $0x9d6b,%edx
  10729b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10729f:	c1 e0 04             	shl    $0x4,%eax
  1072a2:	8b 84 02 00 26 cb 00 	mov    0xcb2600(%edx,%eax,1),%eax
}
  1072a9:	c3                   	ret    
  1072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001072b0 <tcb_set_state>:

void tcb_set_state(unsigned int pid, unsigned int state)
{
    TCBPool[pid].state = state;
  1072b0:	e8 d0 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  1072b5:	81 c2 4b 9d 00 00    	add    $0x9d4b,%edx
  1072bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  1072bf:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1072c3:	c1 e0 04             	shl    $0x4,%eax
  1072c6:	89 8c 02 00 26 cb 00 	mov    %ecx,0xcb2600(%edx,%eax,1)
}
  1072cd:	c3                   	ret    
  1072ce:	66 90                	xchg   %ax,%ax

001072d0 <tcb_get_cpu>:

unsigned int tcb_get_cpu(unsigned int pid)
{
    return TCBPool[pid].cpuid;
  1072d0:	e8 b0 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  1072d5:	81 c2 2b 9d 00 00    	add    $0x9d2b,%edx
  1072db:	8b 44 24 04          	mov    0x4(%esp),%eax
  1072df:	c1 e0 04             	shl    $0x4,%eax
  1072e2:	8b 84 02 04 26 cb 00 	mov    0xcb2604(%edx,%eax,1),%eax
}
  1072e9:	c3                   	ret    
  1072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001072f0 <tcb_set_cpu>:

void tcb_set_cpu(unsigned int pid, unsigned int cpu)
{
    TCBPool[pid].cpuid = cpu;
  1072f0:	e8 90 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  1072f5:	81 c2 0b 9d 00 00    	add    $0x9d0b,%edx
  1072fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  1072ff:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107303:	c1 e0 04             	shl    $0x4,%eax
  107306:	89 8c 02 04 26 cb 00 	mov    %ecx,0xcb2604(%edx,%eax,1)
}
  10730d:	c3                   	ret    
  10730e:	66 90                	xchg   %ax,%ax

00107310 <tcb_get_prev>:

unsigned int tcb_get_prev(unsigned int pid)
{
    return TCBPool[pid].prev;
  107310:	e8 70 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107315:	81 c2 eb 9c 00 00    	add    $0x9ceb,%edx
  10731b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10731f:	c1 e0 04             	shl    $0x4,%eax
  107322:	8b 84 02 08 26 cb 00 	mov    0xcb2608(%edx,%eax,1),%eax
}
  107329:	c3                   	ret    
  10732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107330 <tcb_set_prev>:

void tcb_set_prev(unsigned int pid, unsigned int prev_pid)
{
    TCBPool[pid].prev = prev_pid;
  107330:	e8 50 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107335:	81 c2 cb 9c 00 00    	add    $0x9ccb,%edx
  10733b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10733f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107343:	c1 e0 04             	shl    $0x4,%eax
  107346:	89 8c 02 08 26 cb 00 	mov    %ecx,0xcb2608(%edx,%eax,1)
}
  10734d:	c3                   	ret    
  10734e:	66 90                	xchg   %ax,%ax

00107350 <tcb_get_next>:

unsigned int tcb_get_next(unsigned int pid)
{
    return TCBPool[pid].next;
  107350:	e8 30 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107355:	81 c2 ab 9c 00 00    	add    $0x9cab,%edx
  10735b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10735f:	c1 e0 04             	shl    $0x4,%eax
  107362:	8b 84 02 0c 26 cb 00 	mov    0xcb260c(%edx,%eax,1),%eax
}
  107369:	c3                   	ret    
  10736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107370 <tcb_set_next>:

void tcb_set_next(unsigned int pid, unsigned int next_pid)
{
    TCBPool[pid].next = next_pid;
  107370:	e8 10 90 ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107375:	81 c2 8b 9c 00 00    	add    $0x9c8b,%edx
  10737b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10737f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107383:	c1 e0 04             	shl    $0x4,%eax
  107386:	89 8c 02 0c 26 cb 00 	mov    %ecx,0xcb260c(%edx,%eax,1)
}
  10738d:	c3                   	ret    
  10738e:	66 90                	xchg   %ax,%ax

00107390 <tcb_init_at_id>:

void tcb_init_at_id(unsigned int pid)
{
    TCBPool[pid].state = TSTATE_DEAD;
  107390:	e8 f0 8f ff ff       	call   100385 <__x86.get_pc_thunk.dx>
  107395:	81 c2 6b 9c 00 00    	add    $0x9c6b,%edx
  10739b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10739f:	c1 e0 04             	shl    $0x4,%eax
  1073a2:	c7 84 02 00 26 cb 00 	movl   $0x3,0xcb2600(%edx,%eax,1)
  1073a9:	03 00 00 00 
    TCBPool[pid].cpuid = NUM_CPUS;
  1073ad:	8d 84 02 00 26 cb 00 	lea    0xcb2600(%edx,%eax,1),%eax
  1073b4:	c7 40 04 08 00 00 00 	movl   $0x8,0x4(%eax)
    TCBPool[pid].prev = NUM_IDS;
  1073bb:	c7 40 08 40 00 00 00 	movl   $0x40,0x8(%eax)
    TCBPool[pid].next = NUM_IDS;
  1073c2:	c7 40 0c 40 00 00 00 	movl   $0x40,0xc(%eax)
}
  1073c9:	c3                   	ret    
  1073ca:	66 90                	xchg   %ax,%ax
  1073cc:	66 90                	xchg   %ax,%ax
  1073ce:	66 90                	xchg   %ax,%ax

001073d0 <tcb_init>:
/**
 * Initializes the TCB for all NUM_IDS threads with the state TSTATE_DEAD,
 * and with two indices being NUM_IDS (which represents NULL).
 */
void tcb_init(unsigned int mbi_addr)
{
  1073d0:	56                   	push   %esi
    unsigned int pid = 0;
  1073d1:	31 f6                	xor    %esi,%esi
{
  1073d3:	53                   	push   %ebx
  1073d4:	e8 b0 8f ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1073d9:	81 c3 27 9c 00 00    	add    $0x9c27,%ebx
  1073df:	83 ec 10             	sub    $0x10,%esp
    paging_init(mbi_addr);
  1073e2:	ff 74 24 1c          	push   0x1c(%esp)
  1073e6:	e8 95 fc ff ff       	call   107080 <paging_init>
  1073eb:	83 c4 10             	add    $0x10,%esp
  1073ee:	66 90                	xchg   %ax,%ax

    while (pid < NUM_IDS) {
        tcb_init_at_id(pid);
  1073f0:	83 ec 0c             	sub    $0xc,%esp
  1073f3:	56                   	push   %esi
        pid++;
  1073f4:	83 c6 01             	add    $0x1,%esi
        tcb_init_at_id(pid);
  1073f7:	e8 94 ff ff ff       	call   107390 <tcb_init_at_id>
    while (pid < NUM_IDS) {
  1073fc:	83 c4 10             	add    $0x10,%esp
  1073ff:	83 fe 40             	cmp    $0x40,%esi
  107402:	75 ec                	jne    1073f0 <tcb_init+0x20>
    }
}
  107404:	83 c4 04             	add    $0x4,%esp
  107407:	5b                   	pop    %ebx
  107408:	5e                   	pop    %esi
  107409:	c3                   	ret    
  10740a:	66 90                	xchg   %ax,%ax
  10740c:	66 90                	xchg   %ax,%ax
  10740e:	66 90                	xchg   %ax,%ax

00107410 <tqueue_get_head>:
 */
struct TQueue TQueuePool[NUM_IDS + NUM_CPUS];

unsigned int tqueue_get_head(unsigned int chid)
{
    return TQueuePool[chid].head;
  107410:	e8 6c 8f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  107415:	05 eb 9b 00 00       	add    $0x9beb,%eax
  10741a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10741e:	8b 84 d0 20 2a cb 00 	mov    0xcb2a20(%eax,%edx,8),%eax
}
  107425:	c3                   	ret    
  107426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10742d:	8d 76 00             	lea    0x0(%esi),%esi

00107430 <tqueue_set_head>:

void tqueue_set_head(unsigned int chid, unsigned int head)
{
    TQueuePool[chid].head = head;
  107430:	e8 4c 8f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  107435:	05 cb 9b 00 00       	add    $0x9bcb,%eax
  10743a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10743e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107442:	89 8c d0 20 2a cb 00 	mov    %ecx,0xcb2a20(%eax,%edx,8)
}
  107449:	c3                   	ret    
  10744a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107450 <tqueue_get_tail>:

unsigned int tqueue_get_tail(unsigned int chid)
{
    return TQueuePool[chid].tail;
  107450:	e8 2c 8f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  107455:	05 ab 9b 00 00       	add    $0x9bab,%eax
  10745a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10745e:	8b 84 d0 24 2a cb 00 	mov    0xcb2a24(%eax,%edx,8),%eax
}
  107465:	c3                   	ret    
  107466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10746d:	8d 76 00             	lea    0x0(%esi),%esi

00107470 <tqueue_set_tail>:

void tqueue_set_tail(unsigned int chid, unsigned int tail)
{
    TQueuePool[chid].tail = tail;
  107470:	e8 0c 8f ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  107475:	05 8b 9b 00 00       	add    $0x9b8b,%eax
  10747a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10747e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  107482:	89 8c d0 24 2a cb 00 	mov    %ecx,0xcb2a24(%eax,%edx,8)
}
  107489:	c3                   	ret    
  10748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107490 <tqueue_init_at_id>:

void tqueue_init_at_id(unsigned int chid)
{
    TQueuePool[chid].head = NUM_IDS;
  107490:	e8 ec 8e ff ff       	call   100381 <__x86.get_pc_thunk.ax>
  107495:	05 6b 9b 00 00       	add    $0x9b6b,%eax
{
  10749a:	8b 54 24 04          	mov    0x4(%esp),%edx
    TQueuePool[chid].head = NUM_IDS;
  10749e:	c7 84 d0 20 2a cb 00 	movl   $0x40,0xcb2a20(%eax,%edx,8)
  1074a5:	40 00 00 00 
    TQueuePool[chid].tail = NUM_IDS;
  1074a9:	c7 84 d0 24 2a cb 00 	movl   $0x40,0xcb2a24(%eax,%edx,8)
  1074b0:	40 00 00 00 
}
  1074b4:	c3                   	ret    
  1074b5:	66 90                	xchg   %ax,%ax
  1074b7:	66 90                	xchg   %ax,%ax
  1074b9:	66 90                	xchg   %ax,%ax
  1074bb:	66 90                	xchg   %ax,%ax
  1074bd:	66 90                	xchg   %ax,%ax
  1074bf:	90                   	nop

001074c0 <tqueue_init>:

/**
 * Initializes all the thread queues with tqueue_init_at_id.
 */
void tqueue_init(unsigned int mbi_addr)
{
  1074c0:	56                   	push   %esi
    unsigned int cpu_idx, chid;
    tcb_init(mbi_addr);

    chid = 0;
  1074c1:	31 f6                	xor    %esi,%esi
{
  1074c3:	53                   	push   %ebx
  1074c4:	e8 c0 8e ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1074c9:	81 c3 37 9b 00 00    	add    $0x9b37,%ebx
  1074cf:	83 ec 10             	sub    $0x10,%esp
    tcb_init(mbi_addr);
  1074d2:	ff 74 24 1c          	push   0x1c(%esp)
  1074d6:	e8 f5 fe ff ff       	call   1073d0 <tcb_init>
  1074db:	83 c4 10             	add    $0x10,%esp
  1074de:	66 90                	xchg   %ax,%ax
    while (chid < NUM_IDS + NUM_CPUS) {
        tqueue_init_at_id(chid);
  1074e0:	83 ec 0c             	sub    $0xc,%esp
  1074e3:	56                   	push   %esi
        chid++;
  1074e4:	83 c6 01             	add    $0x1,%esi
        tqueue_init_at_id(chid);
  1074e7:	e8 a4 ff ff ff       	call   107490 <tqueue_init_at_id>
    while (chid < NUM_IDS + NUM_CPUS) {
  1074ec:	83 c4 10             	add    $0x10,%esp
  1074ef:	83 fe 48             	cmp    $0x48,%esi
  1074f2:	75 ec                	jne    1074e0 <tqueue_init+0x20>
    }
}
  1074f4:	83 c4 04             	add    $0x4,%esp
  1074f7:	5b                   	pop    %ebx
  1074f8:	5e                   	pop    %esi
  1074f9:	c3                   	ret    
  1074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107500 <tqueue_enqueue>:
 * Recall that the doubly linked list is index based.
 * So you only need to insert the index.
 * Hint: there are multiple cases in this function.
 */
void tqueue_enqueue(unsigned int chid, unsigned int pid)
{
  107500:	55                   	push   %ebp
  107501:	57                   	push   %edi
  107502:	56                   	push   %esi
  107503:	53                   	push   %ebx
  107504:	e8 80 8e ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107509:	81 c3 f7 9a 00 00    	add    $0x9af7,%ebx
  10750f:	83 ec 18             	sub    $0x18,%esp
  107512:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  107516:	8b 74 24 30          	mov    0x30(%esp),%esi
    unsigned int tail = tqueue_get_tail(chid);
  10751a:	57                   	push   %edi
  10751b:	e8 30 ff ff ff       	call   107450 <tqueue_get_tail>

    if (tail == NUM_IDS) {
  107520:	83 c4 10             	add    $0x10,%esp
  107523:	83 f8 40             	cmp    $0x40,%eax
  107526:	74 38                	je     107560 <tqueue_enqueue+0x60>
        tcb_set_prev(pid, NUM_IDS);
        tcb_set_next(pid, NUM_IDS);
        tqueue_set_head(chid, pid);
        tqueue_set_tail(chid, pid);
    } else {
        tcb_set_next(tail, pid);
  107528:	83 ec 08             	sub    $0x8,%esp
  10752b:	89 c5                	mov    %eax,%ebp
  10752d:	56                   	push   %esi
  10752e:	50                   	push   %eax
  10752f:	e8 3c fe ff ff       	call   107370 <tcb_set_next>
        tcb_set_prev(pid, tail);
  107534:	59                   	pop    %ecx
  107535:	58                   	pop    %eax
  107536:	55                   	push   %ebp
  107537:	56                   	push   %esi
  107538:	e8 f3 fd ff ff       	call   107330 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  10753d:	58                   	pop    %eax
  10753e:	5a                   	pop    %edx
  10753f:	6a 40                	push   $0x40
  107541:	56                   	push   %esi
  107542:	e8 29 fe ff ff       	call   107370 <tcb_set_next>
        tqueue_set_tail(chid, pid);
  107547:	58                   	pop    %eax
  107548:	5a                   	pop    %edx
  107549:	56                   	push   %esi
  10754a:	57                   	push   %edi
  10754b:	e8 20 ff ff ff       	call   107470 <tqueue_set_tail>
  107550:	83 c4 10             	add    $0x10,%esp
    }
}
  107553:	83 c4 0c             	add    $0xc,%esp
  107556:	5b                   	pop    %ebx
  107557:	5e                   	pop    %esi
  107558:	5f                   	pop    %edi
  107559:	5d                   	pop    %ebp
  10755a:	c3                   	ret    
  10755b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10755f:	90                   	nop
        tcb_set_prev(pid, NUM_IDS);
  107560:	83 ec 08             	sub    $0x8,%esp
  107563:	6a 40                	push   $0x40
  107565:	56                   	push   %esi
  107566:	e8 c5 fd ff ff       	call   107330 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  10756b:	59                   	pop    %ecx
  10756c:	5d                   	pop    %ebp
  10756d:	6a 40                	push   $0x40
  10756f:	56                   	push   %esi
  107570:	e8 fb fd ff ff       	call   107370 <tcb_set_next>
        tqueue_set_head(chid, pid);
  107575:	58                   	pop    %eax
  107576:	5a                   	pop    %edx
  107577:	56                   	push   %esi
  107578:	57                   	push   %edi
  107579:	e8 b2 fe ff ff       	call   107430 <tqueue_set_head>
        tqueue_set_tail(chid, pid);
  10757e:	eb c7                	jmp    107547 <tqueue_enqueue+0x47>

00107580 <tqueue_dequeue>:
 * Reverse action of tqueue_enqueue, i.e. pops a TCB from the head of the specified queue.
 * It returns the popped thread's id, or NUM_IDS if the queue is empty.
 * Hint: there are multiple cases in this function.
 */
unsigned int tqueue_dequeue(unsigned int chid)
{
  107580:	55                   	push   %ebp
  107581:	57                   	push   %edi
  107582:	56                   	push   %esi
  107583:	53                   	push   %ebx
  107584:	e8 00 8e ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107589:	81 c3 77 9a 00 00    	add    $0x9a77,%ebx
  10758f:	83 ec 18             	sub    $0x18,%esp
  107592:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
    unsigned int head, next, pid;

    pid = NUM_IDS;
    head = tqueue_get_head(chid);
  107596:	57                   	push   %edi
  107597:	e8 74 fe ff ff       	call   107410 <tqueue_get_head>

    if (head != NUM_IDS) {
  10759c:	83 c4 10             	add    $0x10,%esp
    head = tqueue_get_head(chid);
  10759f:	89 c6                	mov    %eax,%esi
    if (head != NUM_IDS) {
  1075a1:	83 f8 40             	cmp    $0x40,%eax
  1075a4:	74 42                	je     1075e8 <tqueue_dequeue+0x68>
        pid = head;
        next = tcb_get_next(head);
  1075a6:	83 ec 0c             	sub    $0xc,%esp
  1075a9:	50                   	push   %eax
  1075aa:	e8 a1 fd ff ff       	call   107350 <tcb_get_next>

        if (next == NUM_IDS) {
  1075af:	83 c4 10             	add    $0x10,%esp
        next = tcb_get_next(head);
  1075b2:	89 c5                	mov    %eax,%ebp
        if (next == NUM_IDS) {
  1075b4:	83 f8 40             	cmp    $0x40,%eax
  1075b7:	74 3f                	je     1075f8 <tqueue_dequeue+0x78>
            tqueue_set_head(chid, NUM_IDS);
            tqueue_set_tail(chid, NUM_IDS);
        } else {
            tcb_set_prev(next, NUM_IDS);
  1075b9:	83 ec 08             	sub    $0x8,%esp
  1075bc:	6a 40                	push   $0x40
  1075be:	50                   	push   %eax
  1075bf:	e8 6c fd ff ff       	call   107330 <tcb_set_prev>
            tqueue_set_head(chid, next);
  1075c4:	59                   	pop    %ecx
  1075c5:	58                   	pop    %eax
  1075c6:	55                   	push   %ebp
  1075c7:	57                   	push   %edi
  1075c8:	e8 63 fe ff ff       	call   107430 <tqueue_set_head>
  1075cd:	83 c4 10             	add    $0x10,%esp
        }
        tcb_set_prev(pid, NUM_IDS);
  1075d0:	83 ec 08             	sub    $0x8,%esp
  1075d3:	6a 40                	push   $0x40
  1075d5:	56                   	push   %esi
  1075d6:	e8 55 fd ff ff       	call   107330 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  1075db:	58                   	pop    %eax
  1075dc:	5a                   	pop    %edx
  1075dd:	6a 40                	push   $0x40
  1075df:	56                   	push   %esi
  1075e0:	e8 8b fd ff ff       	call   107370 <tcb_set_next>
  1075e5:	83 c4 10             	add    $0x10,%esp
    }

    return pid;
}
  1075e8:	83 c4 0c             	add    $0xc,%esp
  1075eb:	89 f0                	mov    %esi,%eax
  1075ed:	5b                   	pop    %ebx
  1075ee:	5e                   	pop    %esi
  1075ef:	5f                   	pop    %edi
  1075f0:	5d                   	pop    %ebp
  1075f1:	c3                   	ret    
  1075f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            tqueue_set_head(chid, NUM_IDS);
  1075f8:	83 ec 08             	sub    $0x8,%esp
  1075fb:	6a 40                	push   $0x40
  1075fd:	57                   	push   %edi
  1075fe:	e8 2d fe ff ff       	call   107430 <tqueue_set_head>
            tqueue_set_tail(chid, NUM_IDS);
  107603:	58                   	pop    %eax
  107604:	5a                   	pop    %edx
  107605:	6a 40                	push   $0x40
  107607:	57                   	push   %edi
  107608:	e8 63 fe ff ff       	call   107470 <tqueue_set_tail>
  10760d:	83 c4 10             	add    $0x10,%esp
  107610:	eb be                	jmp    1075d0 <tqueue_dequeue+0x50>
  107612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00107620 <tqueue_remove>:
/**
 * Removes the TCB #pid from the queue #chid.
 * Hint: there are many cases in this function.
 */
void tqueue_remove(unsigned int chid, unsigned int pid)
{
  107620:	55                   	push   %ebp
  107621:	57                   	push   %edi
  107622:	56                   	push   %esi
  107623:	53                   	push   %ebx
  107624:	e8 60 8d ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107629:	81 c3 d7 99 00 00    	add    $0x99d7,%ebx
  10762f:	83 ec 18             	sub    $0x18,%esp
  107632:	8b 7c 24 30          	mov    0x30(%esp),%edi
    unsigned int prev, next;

    prev = tcb_get_prev(pid);
  107636:	57                   	push   %edi
  107637:	e8 d4 fc ff ff       	call   107310 <tcb_get_prev>
    next = tcb_get_next(pid);
  10763c:	89 3c 24             	mov    %edi,(%esp)
    prev = tcb_get_prev(pid);
  10763f:	89 c5                	mov    %eax,%ebp
    next = tcb_get_next(pid);
  107641:	e8 0a fd ff ff       	call   107350 <tcb_get_next>

    if (prev == NUM_IDS) {
  107646:	83 c4 10             	add    $0x10,%esp
    next = tcb_get_next(pid);
  107649:	89 c6                	mov    %eax,%esi
    if (prev == NUM_IDS) {
  10764b:	83 fd 40             	cmp    $0x40,%ebp
  10764e:	74 50                	je     1076a0 <tqueue_remove+0x80>
        } else {
            tcb_set_prev(next, NUM_IDS);
            tqueue_set_head(chid, next);
        }
    } else {
        if (next == NUM_IDS) {
  107650:	83 f8 40             	cmp    $0x40,%eax
  107653:	74 73                	je     1076c8 <tqueue_remove+0xa8>
            tcb_set_next(prev, NUM_IDS);
            tqueue_set_tail(chid, prev);
        } else {
            if (prev != next)
  107655:	39 c5                	cmp    %eax,%ebp
  107657:	75 2f                	jne    107688 <tqueue_remove+0x68>
                tcb_set_next(prev, next);
            tcb_set_prev(next, prev);
  107659:	83 ec 08             	sub    $0x8,%esp
  10765c:	55                   	push   %ebp
  10765d:	56                   	push   %esi
  10765e:	e8 cd fc ff ff       	call   107330 <tcb_set_prev>
  107663:	83 c4 10             	add    $0x10,%esp
        }
    }
    tcb_set_prev(pid, NUM_IDS);
  107666:	83 ec 08             	sub    $0x8,%esp
  107669:	6a 40                	push   $0x40
  10766b:	57                   	push   %edi
  10766c:	e8 bf fc ff ff       	call   107330 <tcb_set_prev>
    tcb_set_next(pid, NUM_IDS);
  107671:	58                   	pop    %eax
  107672:	5a                   	pop    %edx
  107673:	6a 40                	push   $0x40
  107675:	57                   	push   %edi
  107676:	e8 f5 fc ff ff       	call   107370 <tcb_set_next>
}
  10767b:	83 c4 1c             	add    $0x1c,%esp
  10767e:	5b                   	pop    %ebx
  10767f:	5e                   	pop    %esi
  107680:	5f                   	pop    %edi
  107681:	5d                   	pop    %ebp
  107682:	c3                   	ret    
  107683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  107687:	90                   	nop
                tcb_set_next(prev, next);
  107688:	83 ec 08             	sub    $0x8,%esp
  10768b:	50                   	push   %eax
  10768c:	55                   	push   %ebp
  10768d:	e8 de fc ff ff       	call   107370 <tcb_set_next>
  107692:	83 c4 10             	add    $0x10,%esp
  107695:	eb c2                	jmp    107659 <tqueue_remove+0x39>
  107697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10769e:	66 90                	xchg   %ax,%ax
        if (next == NUM_IDS) {
  1076a0:	83 f8 40             	cmp    $0x40,%eax
  1076a3:	74 43                	je     1076e8 <tqueue_remove+0xc8>
            tcb_set_prev(next, NUM_IDS);
  1076a5:	83 ec 08             	sub    $0x8,%esp
  1076a8:	6a 40                	push   $0x40
  1076aa:	50                   	push   %eax
  1076ab:	e8 80 fc ff ff       	call   107330 <tcb_set_prev>
            tqueue_set_head(chid, next);
  1076b0:	5d                   	pop    %ebp
  1076b1:	58                   	pop    %eax
  1076b2:	56                   	push   %esi
  1076b3:	ff 74 24 2c          	push   0x2c(%esp)
  1076b7:	e8 74 fd ff ff       	call   107430 <tqueue_set_head>
  1076bc:	83 c4 10             	add    $0x10,%esp
  1076bf:	eb a5                	jmp    107666 <tqueue_remove+0x46>
  1076c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            tcb_set_next(prev, NUM_IDS);
  1076c8:	83 ec 08             	sub    $0x8,%esp
  1076cb:	6a 40                	push   $0x40
  1076cd:	55                   	push   %ebp
  1076ce:	e8 9d fc ff ff       	call   107370 <tcb_set_next>
            tqueue_set_tail(chid, prev);
  1076d3:	59                   	pop    %ecx
  1076d4:	5e                   	pop    %esi
  1076d5:	55                   	push   %ebp
  1076d6:	ff 74 24 2c          	push   0x2c(%esp)
  1076da:	e8 91 fd ff ff       	call   107470 <tqueue_set_tail>
  1076df:	83 c4 10             	add    $0x10,%esp
  1076e2:	eb 82                	jmp    107666 <tqueue_remove+0x46>
  1076e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            tqueue_set_head(chid, NUM_IDS);
  1076e8:	83 ec 08             	sub    $0x8,%esp
  1076eb:	6a 40                	push   $0x40
  1076ed:	ff 74 24 2c          	push   0x2c(%esp)
  1076f1:	e8 3a fd ff ff       	call   107430 <tqueue_set_head>
            tqueue_set_tail(chid, NUM_IDS);
  1076f6:	58                   	pop    %eax
  1076f7:	5a                   	pop    %edx
  1076f8:	6a 40                	push   $0x40
  1076fa:	ff 74 24 2c          	push   0x2c(%esp)
  1076fe:	e8 6d fd ff ff       	call   107470 <tqueue_set_tail>
  107703:	83 c4 10             	add    $0x10,%esp
  107706:	e9 5b ff ff ff       	jmp    107666 <tqueue_remove+0x46>
  10770b:	66 90                	xchg   %ax,%ax
  10770d:	66 90                	xchg   %ax,%ax
  10770f:	90                   	nop

00107710 <get_curid>:
#include <pcpu/PCPUIntro/export.h>

unsigned int CURID[NUM_CPUS];

unsigned int get_curid(void)
{
  107710:	53                   	push   %ebx
  107711:	e8 73 8c ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107716:	81 c3 ea 98 00 00    	add    $0x98ea,%ebx
  10771c:	83 ec 08             	sub    $0x8,%esp
    return CURID[get_pcpu_idx()];
  10771f:	e8 2c e7 ff ff       	call   105e50 <get_pcpu_idx>
  107724:	8b 84 83 60 2c cb 00 	mov    0xcb2c60(%ebx,%eax,4),%eax
}
  10772b:	83 c4 08             	add    $0x8,%esp
  10772e:	5b                   	pop    %ebx
  10772f:	c3                   	ret    

00107730 <set_curid>:

void set_curid(unsigned int curid)
{
  107730:	53                   	push   %ebx
  107731:	e8 53 8c ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107736:	81 c3 ca 98 00 00    	add    $0x98ca,%ebx
  10773c:	83 ec 08             	sub    $0x8,%esp
    CURID[get_pcpu_idx()] = curid;
  10773f:	e8 0c e7 ff ff       	call   105e50 <get_pcpu_idx>
  107744:	8b 54 24 10          	mov    0x10(%esp),%edx
  107748:	89 94 83 60 2c cb 00 	mov    %edx,0xcb2c60(%ebx,%eax,4)
}
  10774f:	83 c4 08             	add    $0x8,%esp
  107752:	5b                   	pop    %ebx
  107753:	c3                   	ret    
  107754:	66 90                	xchg   %ax,%ax
  107756:	66 90                	xchg   %ax,%ax
  107758:	66 90                	xchg   %ax,%ax
  10775a:	66 90                	xchg   %ax,%ax
  10775c:	66 90                	xchg   %ax,%ax
  10775e:	66 90                	xchg   %ax,%ax

00107760 <thread_init>:
        thread_yield();
    }
}

void thread_init(unsigned int mbi_addr)
{
  107760:	53                   	push   %ebx
  107761:	e8 23 8c ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107766:	81 c3 9a 98 00 00    	add    $0x989a,%ebx
  10776c:	83 ec 14             	sub    $0x14,%esp
    tqueue_init(mbi_addr);
  10776f:	ff 74 24 1c          	push   0x1c(%esp)
  107773:	e8 48 fd ff ff       	call   1074c0 <tqueue_init>
    set_curid(0);
  107778:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10777f:	e8 ac ff ff ff       	call   107730 <set_curid>
    tcb_set_state(0, TSTATE_RUN);
  107784:	58                   	pop    %eax
  107785:	5a                   	pop    %edx
  107786:	6a 01                	push   $0x1
  107788:	6a 00                	push   $0x0
  10778a:	e8 21 fb ff ff       	call   1072b0 <tcb_set_state>
    spinlock_init(&pthread_lock);
  10778f:	8d 83 a0 2c cb 00    	lea    0xcb2ca0(%ebx),%eax
  107795:	89 04 24             	mov    %eax,(%esp)
  107798:	e8 53 df ff ff       	call   1056f0 <spinlock_init>
}
  10779d:	83 c4 18             	add    $0x18,%esp
  1077a0:	5b                   	pop    %ebx
  1077a1:	c3                   	ret    
  1077a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001077b0 <thread_spawn>:
 * Allocates a new child thread context, sets the state of the new child thread
 * to ready, and pushes it to the ready queue.
 * It returns the child thread id.
 */
unsigned int thread_spawn(void *entry, unsigned int id, unsigned int quota)
{
  1077b0:	57                   	push   %edi
  1077b1:	56                   	push   %esi
  1077b2:	53                   	push   %ebx
  1077b3:	e8 d1 8b ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1077b8:	81 c3 48 98 00 00    	add    $0x9848,%ebx
    unsigned int pid = kctx_new(entry, id, quota);
  1077be:	83 ec 04             	sub    $0x4,%esp
  1077c1:	ff 74 24 1c          	push   0x1c(%esp)
  1077c5:	ff 74 24 1c          	push   0x1c(%esp)
  1077c9:	ff 74 24 1c          	push   0x1c(%esp)
  1077cd:	e8 2e fa ff ff       	call   107200 <kctx_new>
    if (pid != NUM_IDS) {
  1077d2:	83 c4 10             	add    $0x10,%esp
    unsigned int pid = kctx_new(entry, id, quota);
  1077d5:	89 c6                	mov    %eax,%esi
    if (pid != NUM_IDS) {
  1077d7:	83 f8 40             	cmp    $0x40,%eax
  1077da:	74 43                	je     10781f <thread_spawn+0x6f>
        spinlock_acquire(&pthread_lock);
  1077dc:	83 ec 0c             	sub    $0xc,%esp
  1077df:	8d bb a0 2c cb 00    	lea    0xcb2ca0(%ebx),%edi
  1077e5:	57                   	push   %edi
  1077e6:	e8 95 df ff ff       	call   105780 <spinlock_acquire>

        tcb_set_cpu(pid, get_pcpu_idx());
  1077eb:	e8 60 e6 ff ff       	call   105e50 <get_pcpu_idx>
  1077f0:	5a                   	pop    %edx
  1077f1:	59                   	pop    %ecx
  1077f2:	50                   	push   %eax
  1077f3:	56                   	push   %esi
  1077f4:	e8 f7 fa ff ff       	call   1072f0 <tcb_set_cpu>
        tcb_set_state(pid, TSTATE_READY);
  1077f9:	58                   	pop    %eax
  1077fa:	5a                   	pop    %edx
  1077fb:	6a 00                	push   $0x0
  1077fd:	56                   	push   %esi
  1077fe:	e8 ad fa ff ff       	call   1072b0 <tcb_set_state>
        tqueue_enqueue(NUM_IDS + get_pcpu_idx(), pid);
  107803:	e8 48 e6 ff ff       	call   105e50 <get_pcpu_idx>
  107808:	59                   	pop    %ecx
  107809:	5a                   	pop    %edx
  10780a:	56                   	push   %esi
  10780b:	83 c0 40             	add    $0x40,%eax
  10780e:	50                   	push   %eax
  10780f:	e8 ec fc ff ff       	call   107500 <tqueue_enqueue>

        spinlock_release(&pthread_lock);
  107814:	89 3c 24             	mov    %edi,(%esp)
  107817:	e8 e4 df ff ff       	call   105800 <spinlock_release>
  10781c:	83 c4 10             	add    $0x10,%esp
    }

    return pid;
}
  10781f:	89 f0                	mov    %esi,%eax
  107821:	5b                   	pop    %ebx
  107822:	5e                   	pop    %esi
  107823:	5f                   	pop    %edi
  107824:	c3                   	ret    
  107825:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10782c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107830 <thread_yield>:
 * current thread id, and switch to the new kernel context.
 * Hint: If you are the only thread that is ready to run,
 * do you need to switch to yourself?
 */
void thread_yield(void)
{
  107830:	55                   	push   %ebp
  107831:	57                   	push   %edi
  107832:	56                   	push   %esi
  107833:	53                   	push   %ebx
  107834:	e8 50 8b ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107839:	81 c3 c7 97 00 00    	add    $0x97c7,%ebx
  10783f:	83 ec 0c             	sub    $0xc,%esp
    unsigned int new_cur_pid;
    unsigned int old_cur_pid = get_curid();
  107842:	e8 c9 fe ff ff       	call   107710 <get_curid>

    spinlock_acquire(&pthread_lock);
  107847:	8d ab a0 2c cb 00    	lea    0xcb2ca0(%ebx),%ebp
  10784d:	83 ec 0c             	sub    $0xc,%esp
  107850:	55                   	push   %ebp
    unsigned int old_cur_pid = get_curid();
  107851:	89 c6                	mov    %eax,%esi
    spinlock_acquire(&pthread_lock);
  107853:	e8 28 df ff ff       	call   105780 <spinlock_acquire>

    tcb_set_state(old_cur_pid, TSTATE_READY);
  107858:	58                   	pop    %eax
  107859:	5a                   	pop    %edx
  10785a:	6a 00                	push   $0x0
  10785c:	56                   	push   %esi
  10785d:	e8 4e fa ff ff       	call   1072b0 <tcb_set_state>
    tqueue_enqueue(NUM_IDS + get_pcpu_idx(), old_cur_pid);
  107862:	e8 e9 e5 ff ff       	call   105e50 <get_pcpu_idx>
  107867:	59                   	pop    %ecx
  107868:	5f                   	pop    %edi
  107869:	56                   	push   %esi
  10786a:	83 c0 40             	add    $0x40,%eax
  10786d:	50                   	push   %eax
  10786e:	e8 8d fc ff ff       	call   107500 <tqueue_enqueue>

    new_cur_pid = tqueue_dequeue(NUM_IDS + get_pcpu_idx());
  107873:	e8 d8 e5 ff ff       	call   105e50 <get_pcpu_idx>
  107878:	83 c0 40             	add    $0x40,%eax
  10787b:	89 04 24             	mov    %eax,(%esp)
  10787e:	e8 fd fc ff ff       	call   107580 <tqueue_dequeue>
    tcb_set_state(new_cur_pid, TSTATE_RUN);
  107883:	5a                   	pop    %edx
  107884:	59                   	pop    %ecx
  107885:	6a 01                	push   $0x1
  107887:	50                   	push   %eax
    new_cur_pid = tqueue_dequeue(NUM_IDS + get_pcpu_idx());
  107888:	89 c7                	mov    %eax,%edi
    tcb_set_state(new_cur_pid, TSTATE_RUN);
  10788a:	e8 21 fa ff ff       	call   1072b0 <tcb_set_state>
    set_curid(new_cur_pid);
  10788f:	89 3c 24             	mov    %edi,(%esp)
  107892:	e8 99 fe ff ff       	call   107730 <set_curid>

    spinlock_release(&pthread_lock);
  107897:	89 2c 24             	mov    %ebp,(%esp)
  10789a:	e8 61 df ff ff       	call   105800 <spinlock_release>
    
    if (old_cur_pid != new_cur_pid) {
  10789f:	83 c4 10             	add    $0x10,%esp
  1078a2:	39 fe                	cmp    %edi,%esi
  1078a4:	74 0d                	je     1078b3 <thread_yield+0x83>
        kctx_switch(old_cur_pid, new_cur_pid);
  1078a6:	83 ec 08             	sub    $0x8,%esp
  1078a9:	57                   	push   %edi
  1078aa:	56                   	push   %esi
  1078ab:	e8 e0 f8 ff ff       	call   107190 <kctx_switch>
  1078b0:	83 c4 10             	add    $0x10,%esp
    }
}
  1078b3:	83 c4 0c             	add    $0xc,%esp
  1078b6:	5b                   	pop    %ebx
  1078b7:	5e                   	pop    %esi
  1078b8:	5f                   	pop    %edi
  1078b9:	5d                   	pop    %ebp
  1078ba:	c3                   	ret    
  1078bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1078bf:	90                   	nop

001078c0 <sched_update>:
void sched_update(void) {
  1078c0:	53                   	push   %ebx
  1078c1:	e8 c3 8a ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1078c6:	81 c3 3a 97 00 00    	add    $0x973a,%ebx
  1078cc:	83 ec 08             	sub    $0x8,%esp
    int cpu = get_pcpu_idx();
  1078cf:	e8 7c e5 ff ff       	call   105e50 <get_pcpu_idx>
    sched_ticks[cpu] += ms_per_tick;
  1078d4:	8d 8b 80 2c cb 00    	lea    0xcb2c80(%ebx),%ecx
  1078da:	8b 14 81             	mov    (%ecx,%eax,4),%edx
  1078dd:	83 c2 01             	add    $0x1,%edx
    if (sched_ticks[cpu] >= SCHED_SLICE) {
  1078e0:	83 fa 04             	cmp    $0x4,%edx
  1078e3:	77 0b                	ja     1078f0 <sched_update+0x30>
    sched_ticks[cpu] += ms_per_tick;
  1078e5:	89 14 81             	mov    %edx,(%ecx,%eax,4)
}
  1078e8:	83 c4 08             	add    $0x8,%esp
  1078eb:	5b                   	pop    %ebx
  1078ec:	c3                   	ret    
  1078ed:	8d 76 00             	lea    0x0(%esi),%esi
        sched_ticks[cpu] = 0;
  1078f0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
}
  1078f7:	83 c4 08             	add    $0x8,%esp
  1078fa:	5b                   	pop    %ebx
        thread_yield();
  1078fb:	e9 30 ff ff ff       	jmp    107830 <thread_yield>

00107900 <thread_block>:


void thread_block(void) {
  107900:	53                   	push   %ebx
  107901:	e8 83 8a ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107906:	81 c3 fa 96 00 00    	add    $0x96fa,%ebx
  10790c:	83 ec 08             	sub    $0x8,%esp
    unsigned int cur_pid = get_curid();
  10790f:	e8 fc fd ff ff       	call   107710 <get_curid>
    // Set current thread state to SLEEP.
    tcb_set_state(cur_pid, TSTATE_SLEEP);
  107914:	83 ec 08             	sub    $0x8,%esp
  107917:	6a 02                	push   $0x2
  107919:	50                   	push   %eax
  10791a:	e8 91 f9 ff ff       	call   1072b0 <tcb_set_state>
    // Yield to let the scheduler choose another thread.
    thread_yield();
    // When resumed, the thread continues execution.
}
  10791f:	83 c4 18             	add    $0x18,%esp
  107922:	5b                   	pop    %ebx
    thread_yield();
  107923:	e9 08 ff ff ff       	jmp    107830 <thread_yield>
  107928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10792f:	90                   	nop

00107930 <thread_wake>:

void thread_wake(int pid) {
  107930:	57                   	push   %edi
  107931:	56                   	push   %esi
  107932:	53                   	push   %ebx
  107933:	8b 7c 24 10          	mov    0x10(%esp),%edi
  107937:	e8 4d 8a ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  10793c:	81 c3 c4 96 00 00    	add    $0x96c4,%ebx
    // may want to acquire the global pthread_lock if needed.
    spinlock_acquire(&pthread_lock);
  107942:	83 ec 0c             	sub    $0xc,%esp
  107945:	8d b3 a0 2c cb 00    	lea    0xcb2ca0(%ebx),%esi
  10794b:	56                   	push   %esi
  10794c:	e8 2f de ff ff       	call   105780 <spinlock_acquire>

    if (tcb_get_state(pid) == TSTATE_SLEEP) {
  107951:	89 3c 24             	mov    %edi,(%esp)
  107954:	e8 37 f9 ff ff       	call   107290 <tcb_get_state>
  107959:	83 c4 10             	add    $0x10,%esp
  10795c:	83 f8 02             	cmp    $0x2,%eax
  10795f:	74 17                	je     107978 <thread_wake+0x48>
        // Here, we assume that the thread will be scheduled on the same CPU
        // that wakes it up
        tqueue_enqueue(NUM_IDS + get_pcpu_idx(), pid);
    }
    
    spinlock_release(&pthread_lock);
  107961:	83 ec 0c             	sub    $0xc,%esp
  107964:	56                   	push   %esi
  107965:	e8 96 de ff ff       	call   105800 <spinlock_release>
}
  10796a:	83 c4 10             	add    $0x10,%esp
  10796d:	5b                   	pop    %ebx
  10796e:	5e                   	pop    %esi
  10796f:	5f                   	pop    %edi
  107970:	c3                   	ret    
  107971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        tcb_set_state(pid, TSTATE_READY);
  107978:	83 ec 08             	sub    $0x8,%esp
  10797b:	6a 00                	push   $0x0
  10797d:	57                   	push   %edi
  10797e:	e8 2d f9 ff ff       	call   1072b0 <tcb_set_state>
        tqueue_enqueue(NUM_IDS + get_pcpu_idx(), pid);
  107983:	e8 c8 e4 ff ff       	call   105e50 <get_pcpu_idx>
  107988:	5a                   	pop    %edx
  107989:	59                   	pop    %ecx
  10798a:	57                   	push   %edi
  10798b:	83 c0 40             	add    $0x40,%eax
  10798e:	50                   	push   %eax
  10798f:	e8 6c fb ff ff       	call   107500 <tqueue_enqueue>
  107994:	83 c4 10             	add    $0x10,%esp
    spinlock_release(&pthread_lock);
  107997:	83 ec 0c             	sub    $0xc,%esp
  10799a:	56                   	push   %esi
  10799b:	e8 60 de ff ff       	call   105800 <spinlock_release>
}
  1079a0:	83 c4 10             	add    $0x10,%esp
  1079a3:	5b                   	pop    %ebx
  1079a4:	5e                   	pop    %esi
  1079a5:	5f                   	pop    %edi
  1079a6:	c3                   	ret    
  1079a7:	66 90                	xchg   %ax,%ax
  1079a9:	66 90                	xchg   %ax,%ax
  1079ab:	66 90                	xchg   %ax,%ax
  1079ad:	66 90                	xchg   %ax,%ax
  1079af:	90                   	nop

001079b0 <proc_start_user>:
extern tf_t uctx_pool[NUM_IDS];

extern unsigned int last_active[NUM_CPUS];

void proc_start_user(void)
{
  1079b0:	57                   	push   %edi
  1079b1:	56                   	push   %esi
  1079b2:	53                   	push   %ebx
  1079b3:	e8 d1 89 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1079b8:	81 c3 48 96 00 00    	add    $0x9648,%ebx
    unsigned int cur_pid = get_curid();
  1079be:	e8 4d fd ff ff       	call   107710 <get_curid>
  1079c3:	89 c6                	mov    %eax,%esi
    unsigned int cpu_idx = get_pcpu_idx();
  1079c5:	e8 86 e4 ff ff       	call   105e50 <get_pcpu_idx>

    kstack_switch(cur_pid);
  1079ca:	83 ec 0c             	sub    $0xc,%esp
  1079cd:	56                   	push   %esi
    unsigned int cpu_idx = get_pcpu_idx();
  1079ce:	89 c7                	mov    %eax,%edi
    kstack_switch(cur_pid);
  1079d0:	e8 cb ce ff ff       	call   1048a0 <kstack_switch>
    set_pdir_base(cur_pid);
  1079d5:	89 34 24             	mov    %esi,(%esp)
  1079d8:	e8 93 f0 ff ff       	call   106a70 <set_pdir_base>
    last_active[cpu_idx] = cur_pid;
  1079dd:	c7 c0 c0 4d e0 00    	mov    $0xe04dc0,%eax
  1079e3:	89 34 b8             	mov    %esi,(%eax,%edi,4)

    trap_return((void *) &uctx_pool[cur_pid]);
  1079e6:	6b f6 44             	imul   $0x44,%esi,%esi
  1079e9:	81 c6 c0 3c dc 00    	add    $0xdc3cc0,%esi
  1079ef:	89 34 24             	mov    %esi,(%esp)
  1079f2:	e8 49 a8 ff ff       	call   102240 <trap_return>
}
  1079f7:	83 c4 10             	add    $0x10,%esp
  1079fa:	5b                   	pop    %ebx
  1079fb:	5e                   	pop    %esi
  1079fc:	5f                   	pop    %edi
  1079fd:	c3                   	ret    
  1079fe:	66 90                	xchg   %ax,%ax

00107a00 <proc_create>:

unsigned int proc_create(void *elf_addr, unsigned int quota)
{
  107a00:	57                   	push   %edi
  107a01:	56                   	push   %esi
  107a02:	53                   	push   %ebx
  107a03:	e8 81 89 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107a08:	81 c3 f8 95 00 00    	add    $0x95f8,%ebx
    unsigned int pid, id;

    id = get_curid();
  107a0e:	e8 fd fc ff ff       	call   107710 <get_curid>
    pid = thread_spawn((void *) proc_start_user, id, quota);
  107a13:	83 ec 04             	sub    $0x4,%esp
  107a16:	ff 74 24 18          	push   0x18(%esp)
  107a1a:	50                   	push   %eax
  107a1b:	8d 83 b0 69 ff ff    	lea    -0x9650(%ebx),%eax
  107a21:	50                   	push   %eax
  107a22:	e8 89 fd ff ff       	call   1077b0 <thread_spawn>

    if (pid != NUM_IDS) {
  107a27:	83 c4 10             	add    $0x10,%esp
    pid = thread_spawn((void *) proc_start_user, id, quota);
  107a2a:	89 c6                	mov    %eax,%esi
    if (pid != NUM_IDS) {
  107a2c:	83 f8 40             	cmp    $0x40,%eax
  107a2f:	74 66                	je     107a97 <proc_create+0x97>
        elf_load(elf_addr, pid);
  107a31:	83 ec 08             	sub    $0x8,%esp

        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  107a34:	6b fe 44             	imul   $0x44,%esi,%edi
        elf_load(elf_addr, pid);
  107a37:	50                   	push   %eax
  107a38:	ff 74 24 1c          	push   0x1c(%esp)
  107a3c:	e8 ff d9 ff ff       	call   105440 <elf_load>
        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  107a41:	81 c7 c0 3c dc 00    	add    $0xdc3cc0,%edi
  107a47:	b8 23 00 00 00       	mov    $0x23,%eax
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  107a4c:	ba 23 00 00 00       	mov    $0x23,%edx
        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  107a51:	66 89 47 20          	mov    %ax,0x20(%edi)
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  107a55:	b9 1b 00 00 00       	mov    $0x1b,%ecx
        uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  107a5a:	b8 23 00 00 00       	mov    $0x23,%eax
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  107a5f:	66 89 57 24          	mov    %dx,0x24(%edi)
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  107a63:	66 89 4f 34          	mov    %cx,0x34(%edi)
        uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  107a67:	66 89 47 40          	mov    %ax,0x40(%edi)
        uctx_pool[pid].esp = VM_USERHI;
  107a6b:	c7 47 3c 00 00 00 f0 	movl   $0xf0000000,0x3c(%edi)
        uctx_pool[pid].eflags = FL_IF;
  107a72:	c7 47 38 00 02 00 00 	movl   $0x200,0x38(%edi)
        uctx_pool[pid].eip = elf_entry(elf_addr);
  107a79:	58                   	pop    %eax
  107a7a:	ff 74 24 1c          	push   0x1c(%esp)
  107a7e:	e8 cd db ff ff       	call   105650 <elf_entry>
  107a83:	89 47 30             	mov    %eax,0x30(%edi)

        seg_init_proc(get_pcpu_idx(), pid);
  107a86:	e8 c5 e3 ff ff       	call   105e50 <get_pcpu_idx>
  107a8b:	5a                   	pop    %edx
  107a8c:	59                   	pop    %ecx
  107a8d:	56                   	push   %esi
  107a8e:	50                   	push   %eax
  107a8f:	e8 4c d0 ff ff       	call   104ae0 <seg_init_proc>
  107a94:	83 c4 10             	add    $0x10,%esp
    }

    return pid;
}
  107a97:	89 f0                	mov    %esi,%eax
  107a99:	5b                   	pop    %ebx
  107a9a:	5e                   	pop    %esi
  107a9b:	5f                   	pop    %edi
  107a9c:	c3                   	ret    
  107a9d:	66 90                	xchg   %ax,%ax
  107a9f:	90                   	nop

00107aa0 <syscall_get_arg1>:
 * Retrieves the system call arguments from uctx_pool that get
 * passed in from the current running process' system call.
 */
unsigned int syscall_get_arg1(tf_t *tf)
{
    return tf->regs.eax;
  107aa0:	8b 44 24 04          	mov    0x4(%esp),%eax
  107aa4:	8b 40 1c             	mov    0x1c(%eax),%eax
}
  107aa7:	c3                   	ret    
  107aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107aaf:	90                   	nop

00107ab0 <syscall_get_arg2>:

unsigned int syscall_get_arg2(tf_t *tf)
{
    return tf->regs.ebx;
  107ab0:	8b 44 24 04          	mov    0x4(%esp),%eax
  107ab4:	8b 40 10             	mov    0x10(%eax),%eax
}
  107ab7:	c3                   	ret    
  107ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107abf:	90                   	nop

00107ac0 <syscall_get_arg3>:

unsigned int syscall_get_arg3(tf_t *tf)
{
    return tf->regs.ecx;
  107ac0:	8b 44 24 04          	mov    0x4(%esp),%eax
  107ac4:	8b 40 18             	mov    0x18(%eax),%eax
}
  107ac7:	c3                   	ret    
  107ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107acf:	90                   	nop

00107ad0 <syscall_get_arg4>:

unsigned int syscall_get_arg4(tf_t *tf)
{
    return tf->regs.edx;
  107ad0:	8b 44 24 04          	mov    0x4(%esp),%eax
  107ad4:	8b 40 14             	mov    0x14(%eax),%eax
}
  107ad7:	c3                   	ret    
  107ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107adf:	90                   	nop

00107ae0 <syscall_get_arg5>:

unsigned int syscall_get_arg5(tf_t *tf)
{
    return tf->regs.esi;
  107ae0:	8b 44 24 04          	mov    0x4(%esp),%eax
  107ae4:	8b 40 04             	mov    0x4(%eax),%eax
}
  107ae7:	c3                   	ret    
  107ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107aef:	90                   	nop

00107af0 <syscall_get_arg6>:

unsigned int syscall_get_arg6(tf_t *tf)
{
    return tf->regs.edi;
  107af0:	8b 44 24 04          	mov    0x4(%esp),%eax
  107af4:	8b 00                	mov    (%eax),%eax
}
  107af6:	c3                   	ret    
  107af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107afe:	66 90                	xchg   %ax,%ax

00107b00 <syscall_set_errno>:
 * Sets the error number in uctx_pool that gets passed
 * to the current running process when we return to it.
 */
void syscall_set_errno(tf_t *tf, unsigned int errno)
{
    tf->regs.eax = errno;
  107b00:	8b 44 24 04          	mov    0x4(%esp),%eax
  107b04:	8b 54 24 08          	mov    0x8(%esp),%edx
  107b08:	89 50 1c             	mov    %edx,0x1c(%eax)
}
  107b0b:	c3                   	ret    
  107b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107b10 <syscall_set_retval1>:
 * Sets the return values in uctx_pool that get passed
 * to the current running process when we return to it.
 */
void syscall_set_retval1(tf_t *tf, unsigned int retval)
{
    tf->regs.ebx = retval;
  107b10:	8b 44 24 04          	mov    0x4(%esp),%eax
  107b14:	8b 54 24 08          	mov    0x8(%esp),%edx
  107b18:	89 50 10             	mov    %edx,0x10(%eax)
}
  107b1b:	c3                   	ret    
  107b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107b20 <syscall_set_retval2>:

void syscall_set_retval2(tf_t *tf, unsigned int retval)
{
    tf->regs.ecx = retval;
  107b20:	8b 44 24 04          	mov    0x4(%esp),%eax
  107b24:	8b 54 24 08          	mov    0x8(%esp),%edx
  107b28:	89 50 18             	mov    %edx,0x18(%eax)
}
  107b2b:	c3                   	ret    
  107b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107b30 <syscall_set_retval3>:

void syscall_set_retval3(tf_t *tf, unsigned int retval)
{
    tf->regs.edx = retval;
  107b30:	8b 44 24 04          	mov    0x4(%esp),%eax
  107b34:	8b 54 24 08          	mov    0x8(%esp),%edx
  107b38:	89 50 14             	mov    %edx,0x14(%eax)
}
  107b3b:	c3                   	ret    
  107b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107b40 <syscall_set_retval4>:

void syscall_set_retval4(tf_t *tf, unsigned int retval)
{
    tf->regs.esi = retval;
  107b40:	8b 44 24 04          	mov    0x4(%esp),%eax
  107b44:	8b 54 24 08          	mov    0x8(%esp),%edx
  107b48:	89 50 04             	mov    %edx,0x4(%eax)
}
  107b4b:	c3                   	ret    
  107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107b50 <syscall_set_retval5>:

void syscall_set_retval5(tf_t *tf, unsigned int retval)
{
    tf->regs.edi = retval;
  107b50:	8b 44 24 04          	mov    0x4(%esp),%eax
  107b54:	8b 54 24 08          	mov    0x8(%esp),%edx
  107b58:	89 10                	mov    %edx,(%eax)
}
  107b5a:	c3                   	ret    
  107b5b:	66 90                	xchg   %ax,%ax
  107b5d:	66 90                	xchg   %ax,%ax
  107b5f:	90                   	nop

00107b60 <sys_puts>:
/**
 * Copies a string from user into buffer and prints it to the screen.
 * This is called by the user level "printf" library as a system call.
 */
void sys_puts(tf_t *tf)
{
  107b60:	55                   	push   %ebp
  107b61:	57                   	push   %edi
  107b62:	56                   	push   %esi
  107b63:	53                   	push   %ebx
  107b64:	e8 20 88 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107b69:	81 c3 97 94 00 00    	add    $0x9497,%ebx
  107b6f:	83 ec 1c             	sub    $0x1c,%esp
    unsigned int cur_pid;
    unsigned int str_uva, str_len;
    unsigned int remain, cur_pos, nbytes;

    cur_pid = get_curid();
  107b72:	e8 99 fb ff ff       	call   107710 <get_curid>
    str_uva = syscall_get_arg2(tf);
  107b77:	83 ec 0c             	sub    $0xc,%esp
    cur_pid = get_curid();
  107b7a:	89 44 24 14          	mov    %eax,0x14(%esp)
    str_uva = syscall_get_arg2(tf);
  107b7e:	ff 74 24 3c          	push   0x3c(%esp)
  107b82:	e8 29 ff ff ff       	call   107ab0 <syscall_get_arg2>
  107b87:	89 c7                	mov    %eax,%edi
    str_len = syscall_get_arg3(tf);
  107b89:	58                   	pop    %eax
  107b8a:	ff 74 24 3c          	push   0x3c(%esp)
  107b8e:	e8 2d ff ff ff       	call   107ac0 <syscall_get_arg3>

    if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI)) {
  107b93:	83 c4 10             	add    $0x10,%esp
  107b96:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  107b9c:	0f 86 f6 00 00 00    	jbe    107c98 <sys_puts+0x138>
  107ba2:	01 c7                	add    %eax,%edi
  107ba4:	89 c5                	mov    %eax,%ebp
  107ba6:	81 ff 00 00 00 f0    	cmp    $0xf0000000,%edi
  107bac:	0f 87 e6 00 00 00    	ja     107c98 <sys_puts+0x138>
    }

    remain = str_len;
    cur_pos = str_uva;

    while (remain) {
  107bb2:	85 c0                	test   %eax,%eax
  107bb4:	0f 84 c0 00 00 00    	je     107c7a <sys_puts+0x11a>
        if (remain < PAGESIZE - 1)
            nbytes = remain;
        else
            nbytes = PAGESIZE - 1;

        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  107bba:	8b 74 24 08          	mov    0x8(%esp),%esi
  107bbe:	8d 83 c0 3d cb 00    	lea    0xcb3dc0(%ebx),%eax
  107bc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  107bc8:	c1 e6 0c             	shl    $0xc,%esi
  107bcb:	01 c6                	add    %eax,%esi
  107bcd:	eb 43                	jmp    107c12 <sys_puts+0xb2>
  107bcf:	90                   	nop
  107bd0:	68 ff 0f 00 00       	push   $0xfff
  107bd5:	56                   	push   %esi
  107bd6:	50                   	push   %eax
  107bd7:	ff 74 24 14          	push   0x14(%esp)
  107bdb:	e8 b0 d5 ff ff       	call   105190 <pt_copyin>
  107be0:	83 c4 10             	add    $0x10,%esp
  107be3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  107be8:	75 47                	jne    107c31 <sys_puts+0xd1>
            syscall_set_errno(tf, E_MEM);
            return;
        }

        sys_buf[cur_pid][nbytes] = '\0';
  107bea:	c6 86 ff 0f 00 00 00 	movb   $0x0,0xfff(%esi)
        KERN_INFO("From cpu %d: %s", get_pcpu_idx(), sys_buf[cur_pid]);
  107bf1:	e8 5a e2 ff ff       	call   105e50 <get_pcpu_idx>
  107bf6:	83 ec 04             	sub    $0x4,%esp
  107bf9:	56                   	push   %esi
  107bfa:	50                   	push   %eax
  107bfb:	8d 83 69 98 ff ff    	lea    -0x6797(%ebx),%eax
  107c01:	50                   	push   %eax
  107c02:	e8 b9 c3 ff ff       	call   103fc0 <debug_info>
    while (remain) {
  107c07:	83 c4 10             	add    $0x10,%esp
  107c0a:	81 ed ff 0f 00 00    	sub    $0xfff,%ebp
  107c10:	74 68                	je     107c7a <sys_puts+0x11a>
  107c12:	89 f8                	mov    %edi,%eax
  107c14:	29 e8                	sub    %ebp,%eax
        if (remain < PAGESIZE - 1)
  107c16:	81 fd fe 0f 00 00    	cmp    $0xffe,%ebp
  107c1c:	77 b2                	ja     107bd0 <sys_puts+0x70>
        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  107c1e:	55                   	push   %ebp
  107c1f:	56                   	push   %esi
  107c20:	50                   	push   %eax
  107c21:	ff 74 24 14          	push   0x14(%esp)
  107c25:	e8 66 d5 ff ff       	call   105190 <pt_copyin>
  107c2a:	83 c4 10             	add    $0x10,%esp
  107c2d:	39 c5                	cmp    %eax,%ebp
  107c2f:	74 1f                	je     107c50 <sys_puts+0xf0>
            syscall_set_errno(tf, E_MEM);
  107c31:	83 ec 08             	sub    $0x8,%esp
  107c34:	6a 01                	push   $0x1
  107c36:	ff 74 24 3c          	push   0x3c(%esp)
  107c3a:	e8 c1 fe ff ff       	call   107b00 <syscall_set_errno>
            return;
  107c3f:	83 c4 10             	add    $0x10,%esp
        remain -= nbytes;
        cur_pos += nbytes;
    }

    syscall_set_errno(tf, E_SUCC);
}
  107c42:	83 c4 1c             	add    $0x1c,%esp
  107c45:	5b                   	pop    %ebx
  107c46:	5e                   	pop    %esi
  107c47:	5f                   	pop    %edi
  107c48:	5d                   	pop    %ebp
  107c49:	c3                   	ret    
  107c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sys_buf[cur_pid][nbytes] = '\0';
  107c50:	8b 44 24 08          	mov    0x8(%esp),%eax
  107c54:	c1 e0 0c             	shl    $0xc,%eax
  107c57:	01 c5                	add    %eax,%ebp
  107c59:	8b 44 24 0c          	mov    0xc(%esp),%eax
  107c5d:	c6 04 28 00          	movb   $0x0,(%eax,%ebp,1)
        KERN_INFO("From cpu %d: %s", get_pcpu_idx(), sys_buf[cur_pid]);
  107c61:	e8 ea e1 ff ff       	call   105e50 <get_pcpu_idx>
  107c66:	83 ec 04             	sub    $0x4,%esp
  107c69:	56                   	push   %esi
  107c6a:	50                   	push   %eax
  107c6b:	8d 83 69 98 ff ff    	lea    -0x6797(%ebx),%eax
  107c71:	50                   	push   %eax
  107c72:	e8 49 c3 ff ff       	call   103fc0 <debug_info>
  107c77:	83 c4 10             	add    $0x10,%esp
    syscall_set_errno(tf, E_SUCC);
  107c7a:	83 ec 08             	sub    $0x8,%esp
  107c7d:	6a 00                	push   $0x0
  107c7f:	ff 74 24 3c          	push   0x3c(%esp)
  107c83:	e8 78 fe ff ff       	call   107b00 <syscall_set_errno>
  107c88:	83 c4 10             	add    $0x10,%esp
}
  107c8b:	83 c4 1c             	add    $0x1c,%esp
  107c8e:	5b                   	pop    %ebx
  107c8f:	5e                   	pop    %esi
  107c90:	5f                   	pop    %edi
  107c91:	5d                   	pop    %ebp
  107c92:	c3                   	ret    
  107c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  107c97:	90                   	nop
        syscall_set_errno(tf, E_INVAL_ADDR);
  107c98:	83 ec 08             	sub    $0x8,%esp
  107c9b:	6a 04                	push   $0x4
  107c9d:	ff 74 24 3c          	push   0x3c(%esp)
  107ca1:	e8 5a fe ff ff       	call   107b00 <syscall_set_errno>
        return;
  107ca6:	83 c4 10             	add    $0x10,%esp
}
  107ca9:	83 c4 1c             	add    $0x1c,%esp
  107cac:	5b                   	pop    %ebx
  107cad:	5e                   	pop    %esi
  107cae:	5f                   	pop    %edi
  107caf:	5d                   	pop    %ebp
  107cb0:	c3                   	ret    
  107cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107cbf:	90                   	nop

00107cc0 <sys_spawn>:
 * NUM_IDS with the error number E_INVAL_PID. The same error case apply
 * when the proc_create fails.
 * Otherwise, you should mark it as successful, and return the new child process id.
 */
void sys_spawn(tf_t *tf)
{
  107cc0:	55                   	push   %ebp
  107cc1:	57                   	push   %edi
  107cc2:	56                   	push   %esi
  107cc3:	53                   	push   %ebx
  107cc4:	e8 c0 86 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107cc9:	81 c3 37 93 00 00    	add    $0x9337,%ebx
  107ccf:	83 ec 28             	sub    $0x28,%esp
  107cd2:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    unsigned int new_pid;
    unsigned int elf_id, quota;
    void *elf_addr;

    elf_id = syscall_get_arg2(tf);
  107cd6:	56                   	push   %esi
  107cd7:	e8 d4 fd ff ff       	call   107ab0 <syscall_get_arg2>
    quota = syscall_get_arg3(tf);
  107cdc:	89 34 24             	mov    %esi,(%esp)
    elf_id = syscall_get_arg2(tf);
  107cdf:	89 c5                	mov    %eax,%ebp
    quota = syscall_get_arg3(tf);
  107ce1:	e8 da fd ff ff       	call   107ac0 <syscall_get_arg3>

    switch (elf_id) {
  107ce6:	83 c4 10             	add    $0x10,%esp
    quota = syscall_get_arg3(tf);
  107ce9:	89 c7                	mov    %eax,%edi
    switch (elf_id) {
  107ceb:	83 fd 02             	cmp    $0x2,%ebp
  107cee:	0f 84 c4 00 00 00    	je     107db8 <sys_spawn+0xf8>
  107cf4:	83 fd 03             	cmp    $0x3,%ebp
  107cf7:	74 2f                	je     107d28 <sys_spawn+0x68>
  107cf9:	83 fd 01             	cmp    $0x1,%ebp
  107cfc:	0f 84 96 00 00 00    	je     107d98 <sys_spawn+0xd8>
    }

    new_pid = proc_create(elf_addr, quota);

    if (new_pid == NUM_IDS) {
        syscall_set_errno(tf, E_INVAL_PID);// lab3
  107d02:	83 ec 08             	sub    $0x8,%esp
  107d05:	6a 05                	push   $0x5
  107d07:	56                   	push   %esi
  107d08:	e8 f3 fd ff ff       	call   107b00 <syscall_set_errno>
        syscall_set_retval1(tf, NUM_IDS);
  107d0d:	59                   	pop    %ecx
  107d0e:	5f                   	pop    %edi
  107d0f:	6a 40                	push   $0x40
  107d11:	56                   	push   %esi
  107d12:	e8 f9 fd ff ff       	call   107b10 <syscall_set_retval1>
  107d17:	83 c4 10             	add    $0x10,%esp
    } else {
        syscall_set_errno(tf, E_SUCC);
        syscall_set_retval1(tf, new_pid);
    }
}
  107d1a:	83 c4 1c             	add    $0x1c,%esp
  107d1d:	5b                   	pop    %ebx
  107d1e:	5e                   	pop    %esi
  107d1f:	5f                   	pop    %edi
  107d20:	5d                   	pop    %ebp
  107d21:	c3                   	ret    
  107d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        elf_addr = _binary___obj_user_pingpong_ding_start;
  107d28:	c7 c0 06 e3 12 00    	mov    $0x12e306,%eax
  107d2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    unsigned int cur_pid = get_curid();
  107d32:	e8 d9 f9 ff ff       	call   107710 <get_curid>
    if (!container_can_consume(cur_pid, quota)) {
  107d37:	83 ec 08             	sub    $0x8,%esp
  107d3a:	57                   	push   %edi
    unsigned int cur_pid = get_curid();
  107d3b:	89 c5                	mov    %eax,%ebp
    if (!container_can_consume(cur_pid, quota)) {
  107d3d:	50                   	push   %eax
  107d3e:	e8 6d eb ff ff       	call   1068b0 <container_can_consume>
  107d43:	83 c4 10             	add    $0x10,%esp
  107d46:	85 c0                	test   %eax,%eax
  107d48:	74 5e                	je     107da8 <sys_spawn+0xe8>
    if (container_get_nchildren(cur_pid) == MAX_CHILDREN) {
  107d4a:	83 ec 0c             	sub    $0xc,%esp
  107d4d:	55                   	push   %ebp
  107d4e:	e8 fd ea ff ff       	call   106850 <container_get_nchildren>
  107d53:	83 c4 10             	add    $0x10,%esp
  107d56:	83 f8 03             	cmp    $0x3,%eax
  107d59:	74 75                	je     107dd0 <sys_spawn+0x110>
    new_pid = proc_create(elf_addr, quota);
  107d5b:	83 ec 08             	sub    $0x8,%esp
  107d5e:	57                   	push   %edi
  107d5f:	ff 74 24 18          	push   0x18(%esp)
  107d63:	e8 98 fc ff ff       	call   107a00 <proc_create>
    if (new_pid == NUM_IDS) {
  107d68:	83 c4 10             	add    $0x10,%esp
    new_pid = proc_create(elf_addr, quota);
  107d6b:	89 c7                	mov    %eax,%edi
    if (new_pid == NUM_IDS) {
  107d6d:	83 f8 40             	cmp    $0x40,%eax
  107d70:	74 90                	je     107d02 <sys_spawn+0x42>
        syscall_set_errno(tf, E_SUCC);
  107d72:	83 ec 08             	sub    $0x8,%esp
  107d75:	6a 00                	push   $0x0
  107d77:	56                   	push   %esi
  107d78:	e8 83 fd ff ff       	call   107b00 <syscall_set_errno>
        syscall_set_retval1(tf, new_pid);
  107d7d:	58                   	pop    %eax
  107d7e:	5a                   	pop    %edx
  107d7f:	57                   	push   %edi
  107d80:	56                   	push   %esi
  107d81:	e8 8a fd ff ff       	call   107b10 <syscall_set_retval1>
  107d86:	83 c4 10             	add    $0x10,%esp
}
  107d89:	83 c4 1c             	add    $0x1c,%esp
  107d8c:	5b                   	pop    %ebx
  107d8d:	5e                   	pop    %esi
  107d8e:	5f                   	pop    %edi
  107d8f:	5d                   	pop    %ebp
  107d90:	c3                   	ret    
  107d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        elf_addr = _binary___obj_user_pingpong_ping_start;
  107d98:	c7 c0 26 ad 11 00    	mov    $0x11ad26,%eax
  107d9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  107da2:	eb 8e                	jmp    107d32 <sys_spawn+0x72>
  107da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        syscall_set_errno(tf, E_EXCEEDS_QUOTA);
  107da8:	83 ec 08             	sub    $0x8,%esp
  107dab:	6a 17                	push   $0x17
  107dad:	e9 55 ff ff ff       	jmp    107d07 <sys_spawn+0x47>
  107db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch (elf_id) {
  107db8:	c7 c0 3e 48 12 00    	mov    $0x12483e,%eax
  107dbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  107dc2:	e9 6b ff ff ff       	jmp    107d32 <sys_spawn+0x72>
  107dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107dce:	66 90                	xchg   %ax,%ax
        syscall_set_errno(tf, E_MAX_NUM_CHILDEN_REACHED);
  107dd0:	83 ec 08             	sub    $0x8,%esp
  107dd3:	6a 18                	push   $0x18
  107dd5:	e9 2d ff ff ff       	jmp    107d07 <sys_spawn+0x47>
  107dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107de0 <sys_yield>:
 * The user level library function sys_yield (defined in user/include/syscall.h)
 * does not take any argument and does not have any return values.
 * Do not forget to set the error number as E_SUCC.
 */
void sys_yield(tf_t *tf)
{
  107de0:	53                   	push   %ebx
  107de1:	e8 a3 85 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107de6:	81 c3 1a 92 00 00    	add    $0x921a,%ebx
  107dec:	83 ec 08             	sub    $0x8,%esp
    thread_yield();
  107def:	e8 3c fa ff ff       	call   107830 <thread_yield>
    syscall_set_errno(tf, E_SUCC);
  107df4:	83 ec 08             	sub    $0x8,%esp
  107df7:	6a 00                	push   $0x0
  107df9:	ff 74 24 1c          	push   0x1c(%esp)
  107dfd:	e8 fe fc ff ff       	call   107b00 <syscall_set_errno>
}
  107e02:	83 c4 18             	add    $0x18,%esp
  107e05:	5b                   	pop    %ebx
  107e06:	c3                   	ret    
  107e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107e0e:	66 90                	xchg   %ax,%ax

00107e10 <sys_produce>:

void sys_produce(tf_t *tf)
{
  107e10:	57                   	push   %edi
  107e11:	56                   	push   %esi
    unsigned int i;
    for (i = 0; i < 5; i++) {
  107e12:	31 f6                	xor    %esi,%esi
{
  107e14:	53                   	push   %ebx
  107e15:	e8 6f 85 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107e1a:	81 c3 e6 91 00 00    	add    $0x91e6,%ebx
  107e20:	c7 c7 c0 22 18 00    	mov    $0x1822c0,%edi
        bb_produce(&shared_buffer, i);
  107e26:	83 ec 08             	sub    $0x8,%esp
  107e29:	56                   	push   %esi
    for (i = 0; i < 5; i++) {
  107e2a:	83 c6 01             	add    $0x1,%esi
        bb_produce(&shared_buffer, i);
  107e2d:	57                   	push   %edi
  107e2e:	e8 1d de ff ff       	call   105c50 <bb_produce>
    for (i = 0; i < 5; i++) {
  107e33:	83 c4 10             	add    $0x10,%esp
  107e36:	83 fe 05             	cmp    $0x5,%esi
  107e39:	75 eb                	jne    107e26 <sys_produce+0x16>
        // intr_local_disable();
        // KERN_DEBUG("CPU %d: Process %d: Produced %d\n", get_pcpu_idx(), get_curid(), i);
        // intr_local_enable();
    }
    syscall_set_errno(tf, E_SUCC);
  107e3b:	83 ec 08             	sub    $0x8,%esp
  107e3e:	6a 00                	push   $0x0
  107e40:	ff 74 24 1c          	push   0x1c(%esp)
  107e44:	e8 b7 fc ff ff       	call   107b00 <syscall_set_errno>
}
  107e49:	83 c4 10             	add    $0x10,%esp
  107e4c:	5b                   	pop    %ebx
  107e4d:	5e                   	pop    %esi
  107e4e:	5f                   	pop    %edi
  107e4f:	c3                   	ret    

00107e50 <sys_consume>:

void sys_consume(tf_t *tf)
{
  107e50:	56                   	push   %esi
  107e51:	53                   	push   %ebx
  107e52:	e8 32 85 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107e57:	81 c3 a9 91 00 00    	add    $0x91a9,%ebx
  107e5d:	83 ec 10             	sub    $0x10,%esp
    unsigned int i;
    for (i = 0; i < 5; i++) {
        bb_consume(&shared_buffer);
  107e60:	c7 c6 c0 22 18 00    	mov    $0x1822c0,%esi
  107e66:	56                   	push   %esi
  107e67:	e8 a4 de ff ff       	call   105d10 <bb_consume>
  107e6c:	89 34 24             	mov    %esi,(%esp)
  107e6f:	e8 9c de ff ff       	call   105d10 <bb_consume>
  107e74:	89 34 24             	mov    %esi,(%esp)
  107e77:	e8 94 de ff ff       	call   105d10 <bb_consume>
  107e7c:	89 34 24             	mov    %esi,(%esp)
  107e7f:	e8 8c de ff ff       	call   105d10 <bb_consume>
  107e84:	89 34 24             	mov    %esi,(%esp)
  107e87:	e8 84 de ff ff       	call   105d10 <bb_consume>
        // intr_local_disable();
        // KERN_DEBUG("CPU %d: Process %d: Consumed %d\n", get_pcpu_idx(), get_curid(), i);
        // intr_local_enable();
    }
    syscall_set_errno(tf, E_SUCC);
  107e8c:	58                   	pop    %eax
  107e8d:	5a                   	pop    %edx
  107e8e:	6a 00                	push   $0x0
  107e90:	ff 74 24 1c          	push   0x1c(%esp)
  107e94:	e8 67 fc ff ff       	call   107b00 <syscall_set_errno>
}
  107e99:	83 c4 14             	add    $0x14,%esp
  107e9c:	5b                   	pop    %ebx
  107e9d:	5e                   	pop    %esi
  107e9e:	c3                   	ret    
  107e9f:	90                   	nop

00107ea0 <syscall_dispatch>:
#include <pcpu/PCPUIntro/export.h>

#include "import.h"

void syscall_dispatch(tf_t *tf)
{
  107ea0:	56                   	push   %esi
  107ea1:	53                   	push   %ebx
  107ea2:	e8 e2 84 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107ea7:	81 c3 59 91 00 00    	add    $0x9159,%ebx
  107ead:	83 ec 10             	sub    $0x10,%esp
  107eb0:	8b 74 24 1c          	mov    0x1c(%esp),%esi
    unsigned int nr;

    nr = syscall_get_arg1(tf);
  107eb4:	56                   	push   %esi
  107eb5:	e8 e6 fb ff ff       	call   107aa0 <syscall_get_arg1>

    switch (nr) {
  107eba:	83 c4 10             	add    $0x10,%esp
  107ebd:	83 f8 04             	cmp    $0x4,%eax
  107ec0:	0f 87 94 00 00 00    	ja     107f5a <.L6+0x12>
  107ec6:	8b 94 83 7c 98 ff ff 	mov    -0x6784(%ebx,%eax,4),%edx
  107ecd:	01 da                	add    %ebx,%edx
  107ecf:	ff e2                	jmp    *%edx
  107ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00107ed8 <.L5>:
         *   None.
         */
        sys_yield(tf);
        break;
    case SYS_produce:
        intr_local_enable();
  107ed8:	e8 a3 9a ff ff       	call   101980 <intr_local_enable>
        sys_produce(tf);
  107edd:	83 ec 0c             	sub    $0xc,%esp
  107ee0:	56                   	push   %esi
  107ee1:	e8 2a ff ff ff       	call   107e10 <sys_produce>
        intr_local_disable();
  107ee6:	e8 b5 9a ff ff       	call   1019a0 <intr_local_disable>
        break;
  107eeb:	83 c4 10             	add    $0x10,%esp
        intr_local_disable();
        break;
    default:
        syscall_set_errno(tf, E_INVAL_CALLNR);
    }
}
  107eee:	83 c4 04             	add    $0x4,%esp
  107ef1:	5b                   	pop    %ebx
  107ef2:	5e                   	pop    %esi
  107ef3:	c3                   	ret    
  107ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107ef8 <.L3>:
        intr_local_enable();
  107ef8:	e8 83 9a ff ff       	call   101980 <intr_local_enable>
        sys_consume(tf);
  107efd:	83 ec 0c             	sub    $0xc,%esp
  107f00:	56                   	push   %esi
  107f01:	e8 4a ff ff ff       	call   107e50 <sys_consume>
        intr_local_disable();
  107f06:	e8 95 9a ff ff       	call   1019a0 <intr_local_disable>
        break;
  107f0b:	83 c4 10             	add    $0x10,%esp
}
  107f0e:	83 c4 04             	add    $0x4,%esp
  107f11:	5b                   	pop    %ebx
  107f12:	5e                   	pop    %esi
  107f13:	c3                   	ret    
  107f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107f18 <.L8>:
        sys_puts(tf);
  107f18:	83 ec 0c             	sub    $0xc,%esp
  107f1b:	56                   	push   %esi
  107f1c:	e8 3f fc ff ff       	call   107b60 <sys_puts>
        break;
  107f21:	83 c4 10             	add    $0x10,%esp
}
  107f24:	83 c4 04             	add    $0x4,%esp
  107f27:	5b                   	pop    %ebx
  107f28:	5e                   	pop    %esi
  107f29:	c3                   	ret    
  107f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107f30 <.L7>:
        sys_spawn(tf);
  107f30:	83 ec 0c             	sub    $0xc,%esp
  107f33:	56                   	push   %esi
  107f34:	e8 87 fd ff ff       	call   107cc0 <sys_spawn>
        break;
  107f39:	83 c4 10             	add    $0x10,%esp
}
  107f3c:	83 c4 04             	add    $0x4,%esp
  107f3f:	5b                   	pop    %ebx
  107f40:	5e                   	pop    %esi
  107f41:	c3                   	ret    
  107f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107f48 <.L6>:
        sys_yield(tf);
  107f48:	83 ec 0c             	sub    $0xc,%esp
  107f4b:	56                   	push   %esi
  107f4c:	e8 8f fe ff ff       	call   107de0 <sys_yield>
        break;
  107f51:	83 c4 10             	add    $0x10,%esp
}
  107f54:	83 c4 04             	add    $0x4,%esp
  107f57:	5b                   	pop    %ebx
  107f58:	5e                   	pop    %esi
  107f59:	c3                   	ret    
        syscall_set_errno(tf, E_INVAL_CALLNR);
  107f5a:	83 ec 08             	sub    $0x8,%esp
  107f5d:	6a 03                	push   $0x3
  107f5f:	56                   	push   %esi
  107f60:	e8 9b fb ff ff       	call   107b00 <syscall_set_errno>
  107f65:	83 c4 10             	add    $0x10,%esp
}
  107f68:	83 c4 04             	add    $0x4,%esp
  107f6b:	5b                   	pop    %ebx
  107f6c:	5e                   	pop    %esi
  107f6d:	c3                   	ret    
  107f6e:	66 90                	xchg   %ax,%ax

00107f70 <trap_dump>:
#include <thread/PThread/export.h>

#include "import.h"

static void trap_dump(tf_t *tf)
{
  107f70:	55                   	push   %ebp
  107f71:	57                   	push   %edi
  107f72:	56                   	push   %esi
  107f73:	53                   	push   %ebx
  107f74:	e8 10 84 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  107f79:	81 c3 87 90 00 00    	add    $0x9087,%ebx
  107f7f:	83 ec 0c             	sub    $0xc,%esp
    if (tf == NULL)
  107f82:	85 c0                	test   %eax,%eax
  107f84:	0f 84 c0 01 00 00    	je     10814a <trap_dump+0x1da>
  107f8a:	89 c6                	mov    %eax,%esi
        return;

    uintptr_t base = (uintptr_t) tf;

    KERN_DEBUG("trapframe at %x\n", base);
  107f8c:	8d bb 14 9a ff ff    	lea    -0x65ec(%ebx),%edi
  107f92:	50                   	push   %eax
  107f93:	8d 83 90 98 ff ff    	lea    -0x6770(%ebx),%eax
  107f99:	50                   	push   %eax
    KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
    KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
    KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  107f9a:	8d ab e3 98 ff ff    	lea    -0x671d(%ebx),%ebp
    KERN_DEBUG("trapframe at %x\n", base);
  107fa0:	6a 16                	push   $0x16
  107fa2:	57                   	push   %edi
  107fa3:	e8 48 c0 ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
  107fa8:	58                   	pop    %eax
  107fa9:	8d 83 a1 98 ff ff    	lea    -0x675f(%ebx),%eax
  107faf:	ff 36                	push   (%esi)
  107fb1:	56                   	push   %esi
  107fb2:	50                   	push   %eax
  107fb3:	6a 17                	push   $0x17
  107fb5:	57                   	push   %edi
  107fb6:	e8 35 c0 ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
  107fbb:	83 c4 14             	add    $0x14,%esp
  107fbe:	8d 46 04             	lea    0x4(%esi),%eax
  107fc1:	ff 76 04             	push   0x4(%esi)
  107fc4:	50                   	push   %eax
  107fc5:	8d 83 b7 98 ff ff    	lea    -0x6749(%ebx),%eax
  107fcb:	50                   	push   %eax
  107fcc:	6a 18                	push   $0x18
  107fce:	57                   	push   %edi
  107fcf:	e8 1c c0 ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
  107fd4:	83 c4 14             	add    $0x14,%esp
  107fd7:	8d 46 08             	lea    0x8(%esi),%eax
  107fda:	ff 76 08             	push   0x8(%esi)
  107fdd:	50                   	push   %eax
  107fde:	8d 83 cd 98 ff ff    	lea    -0x6733(%ebx),%eax
  107fe4:	50                   	push   %eax
  107fe5:	6a 19                	push   $0x19
  107fe7:	57                   	push   %edi
  107fe8:	e8 03 c0 ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  107fed:	83 c4 14             	add    $0x14,%esp
  107ff0:	8d 46 0c             	lea    0xc(%esi),%eax
  107ff3:	ff 76 0c             	push   0xc(%esi)
  107ff6:	50                   	push   %eax
  107ff7:	55                   	push   %ebp
  107ff8:	6a 1a                	push   $0x1a
  107ffa:	57                   	push   %edi
  107ffb:	e8 f0 bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  108000:	83 c4 14             	add    $0x14,%esp
  108003:	8d 46 10             	lea    0x10(%esi),%eax
  108006:	ff 76 10             	push   0x10(%esi)
  108009:	50                   	push   %eax
  10800a:	8d 83 f9 98 ff ff    	lea    -0x6707(%ebx),%eax
  108010:	50                   	push   %eax
  108011:	6a 1b                	push   $0x1b
  108013:	57                   	push   %edi
  108014:	e8 d7 bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
  108019:	83 c4 14             	add    $0x14,%esp
  10801c:	8d 46 14             	lea    0x14(%esi),%eax
  10801f:	ff 76 14             	push   0x14(%esi)
  108022:	50                   	push   %eax
  108023:	8d 83 0f 99 ff ff    	lea    -0x66f1(%ebx),%eax
  108029:	50                   	push   %eax
  10802a:	6a 1c                	push   $0x1c
  10802c:	57                   	push   %edi
  10802d:	e8 be bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
  108032:	83 c4 14             	add    $0x14,%esp
  108035:	8d 46 18             	lea    0x18(%esi),%eax
  108038:	ff 76 18             	push   0x18(%esi)
  10803b:	50                   	push   %eax
  10803c:	8d 83 25 99 ff ff    	lea    -0x66db(%ebx),%eax
  108042:	50                   	push   %eax
  108043:	6a 1d                	push   $0x1d
  108045:	57                   	push   %edi
  108046:	e8 a5 bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  10804b:	83 c4 14             	add    $0x14,%esp
  10804e:	8d 46 1c             	lea    0x1c(%esi),%eax
  108051:	ff 76 1c             	push   0x1c(%esi)
  108054:	50                   	push   %eax
  108055:	8d 83 3b 99 ff ff    	lea    -0x66c5(%ebx),%eax
  10805b:	50                   	push   %eax
  10805c:	6a 1e                	push   $0x1e
  10805e:	57                   	push   %edi
  10805f:	e8 8c bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  108064:	0f b7 46 20          	movzwl 0x20(%esi),%eax
  108068:	83 c4 14             	add    $0x14,%esp
  10806b:	50                   	push   %eax
  10806c:	8d 46 20             	lea    0x20(%esi),%eax
  10806f:	50                   	push   %eax
  108070:	8d 83 51 99 ff ff    	lea    -0x66af(%ebx),%eax
  108076:	50                   	push   %eax
  108077:	6a 1f                	push   $0x1f
  108079:	57                   	push   %edi
  10807a:	e8 71 bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
  10807f:	0f b7 46 24          	movzwl 0x24(%esi),%eax
  108083:	83 c4 14             	add    $0x14,%esp
  108086:	50                   	push   %eax
  108087:	8d 46 24             	lea    0x24(%esi),%eax
  10808a:	50                   	push   %eax
  10808b:	8d 83 67 99 ff ff    	lea    -0x6699(%ebx),%eax
  108091:	50                   	push   %eax
  108092:	6a 20                	push   $0x20
  108094:	57                   	push   %edi
  108095:	e8 56 bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
  10809a:	83 c4 14             	add    $0x14,%esp
  10809d:	8d 46 28             	lea    0x28(%esi),%eax
  1080a0:	ff 76 28             	push   0x28(%esi)
  1080a3:	50                   	push   %eax
  1080a4:	8d 83 7d 99 ff ff    	lea    -0x6683(%ebx),%eax
  1080aa:	50                   	push   %eax
  1080ab:	6a 21                	push   $0x21
  1080ad:	57                   	push   %edi
  1080ae:	e8 3d bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  1080b3:	83 c4 14             	add    $0x14,%esp
  1080b6:	8d 46 2c             	lea    0x2c(%esi),%eax
  1080b9:	ff 76 2c             	push   0x2c(%esi)
  1080bc:	50                   	push   %eax
  1080bd:	8d 83 93 99 ff ff    	lea    -0x666d(%ebx),%eax
  1080c3:	50                   	push   %eax
  1080c4:	6a 22                	push   $0x22
  1080c6:	57                   	push   %edi
  1080c7:	e8 24 bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  1080cc:	83 c4 14             	add    $0x14,%esp
  1080cf:	8d 46 30             	lea    0x30(%esi),%eax
  1080d2:	ff 76 30             	push   0x30(%esi)
  1080d5:	50                   	push   %eax
  1080d6:	8d 83 a9 99 ff ff    	lea    -0x6657(%ebx),%eax
  1080dc:	50                   	push   %eax
  1080dd:	6a 23                	push   $0x23
  1080df:	57                   	push   %edi
  1080e0:	e8 0b bf ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
  1080e5:	0f b7 46 34          	movzwl 0x34(%esi),%eax
  1080e9:	83 c4 14             	add    $0x14,%esp
  1080ec:	50                   	push   %eax
  1080ed:	8d 46 34             	lea    0x34(%esi),%eax
  1080f0:	50                   	push   %eax
  1080f1:	8d 83 bf 99 ff ff    	lea    -0x6641(%ebx),%eax
  1080f7:	50                   	push   %eax
  1080f8:	6a 24                	push   $0x24
  1080fa:	57                   	push   %edi
  1080fb:	e8 f0 be ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
  108100:	83 c4 14             	add    $0x14,%esp
  108103:	8d 46 38             	lea    0x38(%esi),%eax
  108106:	ff 76 38             	push   0x38(%esi)
  108109:	50                   	push   %eax
  10810a:	8d 83 d5 99 ff ff    	lea    -0x662b(%ebx),%eax
  108110:	50                   	push   %eax
  108111:	6a 25                	push   $0x25
  108113:	57                   	push   %edi
  108114:	e8 d7 be ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  108119:	83 c4 14             	add    $0x14,%esp
  10811c:	8d 46 3c             	lea    0x3c(%esi),%eax
  10811f:	ff 76 3c             	push   0x3c(%esi)
  108122:	50                   	push   %eax
  108123:	55                   	push   %ebp
  108124:	6a 26                	push   $0x26
  108126:	57                   	push   %edi
  108127:	e8 c4 be ff ff       	call   103ff0 <debug_normal>
    KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
  10812c:	0f b7 46 40          	movzwl 0x40(%esi),%eax
  108130:	83 c4 14             	add    $0x14,%esp
  108133:	83 c6 40             	add    $0x40,%esi
  108136:	50                   	push   %eax
  108137:	8d 83 eb 99 ff ff    	lea    -0x6615(%ebx),%eax
  10813d:	56                   	push   %esi
  10813e:	50                   	push   %eax
  10813f:	6a 27                	push   $0x27
  108141:	57                   	push   %edi
  108142:	e8 a9 be ff ff       	call   103ff0 <debug_normal>
  108147:	83 c4 20             	add    $0x20,%esp
}
  10814a:	83 c4 0c             	add    $0xc,%esp
  10814d:	5b                   	pop    %ebx
  10814e:	5e                   	pop    %esi
  10814f:	5f                   	pop    %edi
  108150:	5d                   	pop    %ebp
  108151:	c3                   	ret    
  108152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00108160 <default_exception_handler>:

void default_exception_handler(tf_t *tf)
{
  108160:	56                   	push   %esi
  108161:	53                   	push   %ebx
  108162:	e8 22 82 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  108167:	81 c3 99 8e 00 00    	add    $0x8e99,%ebx
  10816d:	83 ec 04             	sub    $0x4,%esp
  108170:	8b 74 24 10          	mov    0x10(%esp),%esi
    unsigned int cur_pid;

    cur_pid = get_curid();
  108174:	e8 97 f5 ff ff       	call   107710 <get_curid>
    trap_dump(tf);
  108179:	89 f0                	mov    %esi,%eax
  10817b:	e8 f0 fd ff ff       	call   107f70 <trap_dump>

    KERN_PANIC("Trap %d @ 0x%08x.\n", tf->trapno, tf->eip);
  108180:	83 ec 0c             	sub    $0xc,%esp
  108183:	8d 83 01 9a ff ff    	lea    -0x65ff(%ebx),%eax
  108189:	ff 76 30             	push   0x30(%esi)
  10818c:	ff 76 28             	push   0x28(%esi)
  10818f:	50                   	push   %eax
  108190:	8d 83 14 9a ff ff    	lea    -0x65ec(%ebx),%eax
  108196:	6a 31                	push   $0x31
  108198:	50                   	push   %eax
  108199:	e8 92 be ff ff       	call   104030 <debug_panic>
}
  10819e:	83 c4 24             	add    $0x24,%esp
  1081a1:	5b                   	pop    %ebx
  1081a2:	5e                   	pop    %esi
  1081a3:	c3                   	ret    
  1081a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1081ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1081af:	90                   	nop

001081b0 <pgflt_handler>:

void pgflt_handler(tf_t *tf)
{
  1081b0:	55                   	push   %ebp
  1081b1:	57                   	push   %edi
  1081b2:	56                   	push   %esi
  1081b3:	53                   	push   %ebx
  1081b4:	e8 d0 81 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1081b9:	81 c3 47 8e 00 00    	add    $0x8e47,%ebx
  1081bf:	83 ec 0c             	sub    $0xc,%esp
    unsigned int cur_pid;
    unsigned int errno;
    unsigned int fault_va;

    cur_pid = get_curid();
  1081c2:	e8 49 f5 ff ff       	call   107710 <get_curid>
  1081c7:	89 c6                	mov    %eax,%esi
    errno = tf->err;
  1081c9:	8b 44 24 20          	mov    0x20(%esp),%eax
  1081cd:	8b 78 2c             	mov    0x2c(%eax),%edi
    fault_va = rcr2();
  1081d0:	e8 3b cc ff ff       	call   104e10 <rcr2>
  1081d5:	89 c5                	mov    %eax,%ebp

    // Uncomment this line to see information about the page fault
    // KERN_DEBUG("Page fault: VA 0x%08x, errno 0x%08x, process %d, EIP 0x%08x.\n",
    //            fault_va, errno, cur_pid, uctx_pool[cur_pid].eip);

    if (errno & PFE_PR) {
  1081d7:	f7 c7 01 00 00 00    	test   $0x1,%edi
  1081dd:	75 21                	jne    108200 <pgflt_handler+0x50>
        KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n",
                   fault_va, errno);
        return;
    }

    if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber) {
  1081df:	83 ec 04             	sub    $0x4,%esp
  1081e2:	6a 07                	push   $0x7
  1081e4:	50                   	push   %eax
  1081e5:	56                   	push   %esi
  1081e6:	e8 e5 ee ff ff       	call   1070d0 <alloc_page>
  1081eb:	83 c4 10             	add    $0x10,%esp
  1081ee:	3d 01 00 10 00       	cmp    $0x100001,%eax
  1081f3:	74 33                	je     108228 <pgflt_handler+0x78>
        KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n",
                   fault_va, errno);
    }
}
  1081f5:	83 c4 0c             	add    $0xc,%esp
  1081f8:	5b                   	pop    %ebx
  1081f9:	5e                   	pop    %esi
  1081fa:	5f                   	pop    %edi
  1081fb:	5d                   	pop    %ebp
  1081fc:	c3                   	ret    
  1081fd:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n",
  108200:	83 ec 0c             	sub    $0xc,%esp
  108203:	57                   	push   %edi
  108204:	50                   	push   %eax
  108205:	8d 83 3c 9a ff ff    	lea    -0x65c4(%ebx),%eax
  10820b:	50                   	push   %eax
  10820c:	8d 83 14 9a ff ff    	lea    -0x65ec(%ebx),%eax
  108212:	6a 43                	push   $0x43
  108214:	50                   	push   %eax
  108215:	e8 16 be ff ff       	call   104030 <debug_panic>
        return;
  10821a:	83 c4 20             	add    $0x20,%esp
}
  10821d:	83 c4 0c             	add    $0xc,%esp
  108220:	5b                   	pop    %ebx
  108221:	5e                   	pop    %esi
  108222:	5f                   	pop    %edi
  108223:	5d                   	pop    %ebp
  108224:	c3                   	ret    
  108225:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n",
  108228:	83 ec 0c             	sub    $0xc,%esp
  10822b:	8d 83 70 9a ff ff    	lea    -0x6590(%ebx),%eax
  108231:	57                   	push   %edi
  108232:	55                   	push   %ebp
  108233:	50                   	push   %eax
  108234:	8d 83 14 9a ff ff    	lea    -0x65ec(%ebx),%eax
  10823a:	6a 49                	push   $0x49
  10823c:	50                   	push   %eax
  10823d:	e8 ee bd ff ff       	call   104030 <debug_panic>
  108242:	83 c4 20             	add    $0x20,%esp
}
  108245:	83 c4 0c             	add    $0xc,%esp
  108248:	5b                   	pop    %ebx
  108249:	5e                   	pop    %esi
  10824a:	5f                   	pop    %edi
  10824b:	5d                   	pop    %ebp
  10824c:	c3                   	ret    
  10824d:	8d 76 00             	lea    0x0(%esi),%esi

00108250 <exception_handler>:
/**
 * We currently only handle the page fault exception.
 * All other exceptions should be routed to the default exception handler.
 */
void exception_handler(tf_t *tf)
{
  108250:	56                   	push   %esi
  108251:	53                   	push   %ebx
  108252:	e8 32 81 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  108257:	81 c3 a9 8d 00 00    	add    $0x8da9,%ebx
  10825d:	83 ec 04             	sub    $0x4,%esp
  108260:	8b 74 24 10          	mov    0x10(%esp),%esi
    if (tf->trapno == T_PGFLT)
  108264:	83 7e 28 0e          	cmpl   $0xe,0x28(%esi)
  108268:	74 36                	je     1082a0 <exception_handler+0x50>
    cur_pid = get_curid();
  10826a:	e8 a1 f4 ff ff       	call   107710 <get_curid>
    trap_dump(tf);
  10826f:	89 f0                	mov    %esi,%eax
  108271:	e8 fa fc ff ff       	call   107f70 <trap_dump>
    KERN_PANIC("Trap %d @ 0x%08x.\n", tf->trapno, tf->eip);
  108276:	83 ec 0c             	sub    $0xc,%esp
  108279:	8d 83 01 9a ff ff    	lea    -0x65ff(%ebx),%eax
  10827f:	ff 76 30             	push   0x30(%esi)
  108282:	ff 76 28             	push   0x28(%esi)
  108285:	50                   	push   %eax
  108286:	8d 83 14 9a ff ff    	lea    -0x65ec(%ebx),%eax
  10828c:	6a 31                	push   $0x31
  10828e:	50                   	push   %eax
  10828f:	e8 9c bd ff ff       	call   104030 <debug_panic>
        pgflt_handler(tf);
    else
        default_exception_handler(tf);
}
  108294:	83 c4 24             	add    $0x24,%esp
  108297:	5b                   	pop    %ebx
  108298:	5e                   	pop    %esi
  108299:	c3                   	ret    
  10829a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pgflt_handler(tf);
  1082a0:	89 74 24 10          	mov    %esi,0x10(%esp)
}
  1082a4:	83 c4 04             	add    $0x4,%esp
  1082a7:	5b                   	pop    %ebx
  1082a8:	5e                   	pop    %esi
        pgflt_handler(tf);
  1082a9:	e9 02 ff ff ff       	jmp    1081b0 <pgflt_handler>
  1082ae:	66 90                	xchg   %ax,%ax

001082b0 <interrupt_handler>:
/**
 * Any interrupt request other than the spurious or timer should be
 * routed to the default interrupt handler.
 */
void interrupt_handler(tf_t *tf)
{
  1082b0:	53                   	push   %ebx
  1082b1:	e8 d3 80 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1082b6:	81 c3 4a 8d 00 00    	add    $0x8d4a,%ebx
  1082bc:	83 ec 08             	sub    $0x8,%esp
    switch (tf->trapno) {
  1082bf:	8b 44 24 10          	mov    0x10(%esp),%eax
  1082c3:	8b 40 28             	mov    0x28(%eax),%eax
  1082c6:	83 f8 20             	cmp    $0x20,%eax
  1082c9:	74 15                	je     1082e0 <interrupt_handler+0x30>
  1082cb:	83 f8 27             	cmp    $0x27,%eax
  1082ce:	74 05                	je     1082d5 <interrupt_handler+0x25>
    intr_eoi();
  1082d0:	e8 6b 96 ff ff       	call   101940 <intr_eoi>
        timer_intr_handler();
        break;
    default:
        default_intr_handler();
    }
}
  1082d5:	83 c4 08             	add    $0x8,%esp
  1082d8:	5b                   	pop    %ebx
  1082d9:	c3                   	ret    
  1082da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    intr_eoi();
  1082e0:	e8 5b 96 ff ff       	call   101940 <intr_eoi>
    sched_update();
  1082e5:	e8 d6 f5 ff ff       	call   1078c0 <sched_update>
}
  1082ea:	83 c4 08             	add    $0x8,%esp
  1082ed:	5b                   	pop    %ebx
  1082ee:	c3                   	ret    
  1082ef:	90                   	nop

001082f0 <trap>:

unsigned int last_active[NUM_CPUS];

void trap(tf_t *tf)
{
  1082f0:	55                   	push   %ebp
  1082f1:	57                   	push   %edi
  1082f2:	56                   	push   %esi
  1082f3:	53                   	push   %ebx
  1082f4:	e8 90 80 ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1082f9:	81 c3 07 8d 00 00    	add    $0x8d07,%ebx
  1082ff:	83 ec 1c             	sub    $0x1c,%esp
    unsigned int cur_pid = get_curid();
  108302:	e8 09 f4 ff ff       	call   107710 <get_curid>
    unsigned int cpu_idx = get_pcpu_idx();
    trap_cb_t handler;

    unsigned int last_pid = last_active[cpu_idx];
  108307:	8d ab c0 3d cf 00    	lea    0xcf3dc0(%ebx),%ebp
    unsigned int cur_pid = get_curid();
  10830d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    unsigned int cpu_idx = get_pcpu_idx();
  108311:	e8 3a db ff ff       	call   105e50 <get_pcpu_idx>
    unsigned int last_pid = last_active[cpu_idx];
  108316:	8b 7c 85 00          	mov    0x0(%ebp,%eax,4),%edi
    unsigned int cpu_idx = get_pcpu_idx();
  10831a:	89 c6                	mov    %eax,%esi

    if (last_pid != 0)
  10831c:	85 ff                	test   %edi,%edi
  10831e:	75 48                	jne    108368 <trap+0x78>
    {
        set_pdir_base(0);  // switch to the kernel's page table
        last_active[cpu_idx] = 0;
    }

    handler = TRAP_HANDLER[get_pcpu_idx()][tf->trapno];
  108320:	e8 2b db ff ff       	call   105e50 <get_pcpu_idx>
  108325:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  108329:	c1 e0 08             	shl    $0x8,%eax
  10832c:	8b 51 28             	mov    0x28(%ecx),%edx
  10832f:	c7 c1 e0 4d e0 00    	mov    $0xe04de0,%ecx
  108335:	01 d0                	add    %edx,%eax
  108337:	8b 04 81             	mov    (%ecx,%eax,4),%eax

    if (handler) {
  10833a:	85 c0                	test   %eax,%eax
  10833c:	74 62                	je     1083a0 <trap+0xb0>
        handler(tf);
  10833e:	83 ec 0c             	sub    $0xc,%esp
  108341:	ff 74 24 3c          	push   0x3c(%esp)
  108345:	ff d0                	call   *%eax
  108347:	83 c4 10             	add    $0x10,%esp
    } else {
        KERN_WARN("No handler for user trap 0x%x, process %d, eip 0x%08x.\n",
                  tf->trapno, cur_pid, tf->eip);
    }
    
    if (last_pid != 0)
  10834a:	85 ff                	test   %edi,%edi
  10834c:	75 32                	jne    108380 <trap+0x90>
        kstack_switch(cur_pid);
        set_pdir_base(cur_pid);
        last_active[cpu_idx] = last_pid;
    }

    trap_return((void *) tf);
  10834e:	83 ec 0c             	sub    $0xc,%esp
  108351:	ff 74 24 3c          	push   0x3c(%esp)
  108355:	e8 e6 9e ff ff       	call   102240 <trap_return>
}
  10835a:	83 c4 2c             	add    $0x2c,%esp
  10835d:	5b                   	pop    %ebx
  10835e:	5e                   	pop    %esi
  10835f:	5f                   	pop    %edi
  108360:	5d                   	pop    %ebp
  108361:	c3                   	ret    
  108362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        set_pdir_base(0);  // switch to the kernel's page table
  108368:	83 ec 0c             	sub    $0xc,%esp
  10836b:	6a 00                	push   $0x0
  10836d:	e8 fe e6 ff ff       	call   106a70 <set_pdir_base>
        last_active[cpu_idx] = 0;
  108372:	c7 44 b5 00 00 00 00 	movl   $0x0,0x0(%ebp,%esi,4)
  108379:	00 
  10837a:	83 c4 10             	add    $0x10,%esp
  10837d:	eb a1                	jmp    108320 <trap+0x30>
  10837f:	90                   	nop
        kstack_switch(cur_pid);
  108380:	83 ec 0c             	sub    $0xc,%esp
  108383:	ff 74 24 18          	push   0x18(%esp)
  108387:	e8 14 c5 ff ff       	call   1048a0 <kstack_switch>
        set_pdir_base(cur_pid);
  10838c:	58                   	pop    %eax
  10838d:	ff 74 24 18          	push   0x18(%esp)
  108391:	e8 da e6 ff ff       	call   106a70 <set_pdir_base>
        last_active[cpu_idx] = last_pid;
  108396:	89 7c b5 00          	mov    %edi,0x0(%ebp,%esi,4)
  10839a:	83 c4 10             	add    $0x10,%esp
  10839d:	eb af                	jmp    10834e <trap+0x5e>
  10839f:	90                   	nop
        KERN_WARN("No handler for user trap 0x%x, process %d, eip 0x%08x.\n",
  1083a0:	83 ec 08             	sub    $0x8,%esp
  1083a3:	8b 44 24 38          	mov    0x38(%esp),%eax
  1083a7:	ff 70 30             	push   0x30(%eax)
  1083aa:	8d 83 a8 9a ff ff    	lea    -0x6558(%ebx),%eax
  1083b0:	ff 74 24 18          	push   0x18(%esp)
  1083b4:	52                   	push   %edx
  1083b5:	50                   	push   %eax
  1083b6:	8d 83 14 9a ff ff    	lea    -0x65ec(%ebx),%eax
  1083bc:	68 93 00 00 00       	push   $0x93
  1083c1:	50                   	push   %eax
  1083c2:	e8 39 bd ff ff       	call   104100 <debug_warn>
  1083c7:	83 c4 20             	add    $0x20,%esp
  1083ca:	e9 7b ff ff ff       	jmp    10834a <trap+0x5a>
  1083cf:	90                   	nop

001083d0 <trap_init_array>:
int inited = FALSE;

trap_cb_t TRAP_HANDLER[NUM_CPUS][256];

void trap_init_array(void)
{
  1083d0:	53                   	push   %ebx
  1083d1:	e8 b3 7f ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  1083d6:	81 c3 2a 8c 00 00    	add    $0x8c2a,%ebx
  1083dc:	83 ec 08             	sub    $0x8,%esp
    KERN_ASSERT(inited == FALSE);
  1083df:	8b 83 e0 5d cf 00    	mov    0xcf5de0(%ebx),%eax
  1083e5:	85 c0                	test   %eax,%eax
  1083e7:	75 27                	jne    108410 <trap_init_array+0x40>
    memzero(&TRAP_HANDLER, sizeof(trap_cb_t) * 8 * 256);
  1083e9:	83 ec 08             	sub    $0x8,%esp
  1083ec:	8d 83 e0 3d cf 00    	lea    0xcf3de0(%ebx),%eax
  1083f2:	68 00 20 00 00       	push   $0x2000
  1083f7:	50                   	push   %eax
  1083f8:	e8 33 bb ff ff       	call   103f30 <memzero>
    inited = TRUE;
  1083fd:	c7 83 e0 5d cf 00 01 	movl   $0x1,0xcf5de0(%ebx)
  108404:	00 00 00 
}
  108407:	83 c4 18             	add    $0x18,%esp
  10840a:	5b                   	pop    %ebx
  10840b:	c3                   	ret    
  10840c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(inited == FALSE);
  108410:	8d 83 e0 9a ff ff    	lea    -0x6520(%ebx),%eax
  108416:	50                   	push   %eax
  108417:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10841d:	50                   	push   %eax
  10841e:	8d 83 58 9b ff ff    	lea    -0x64a8(%ebx),%eax
  108424:	6a 11                	push   $0x11
  108426:	50                   	push   %eax
  108427:	e8 04 bc ff ff       	call   104030 <debug_panic>
  10842c:	83 c4 10             	add    $0x10,%esp
  10842f:	eb b8                	jmp    1083e9 <trap_init_array+0x19>
  108431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10843f:	90                   	nop

00108440 <trap_handler_register>:

void trap_handler_register(int cpu_idx, int trapno, trap_cb_t cb)
{
  108440:	55                   	push   %ebp
  108441:	57                   	push   %edi
  108442:	56                   	push   %esi
  108443:	53                   	push   %ebx
  108444:	e8 40 7f ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  108449:	81 c3 b7 8b 00 00    	add    $0x8bb7,%ebx
  10844f:	83 ec 0c             	sub    $0xc,%esp
  108452:	8b 74 24 20          	mov    0x20(%esp),%esi
  108456:	8b 6c 24 24          	mov    0x24(%esp),%ebp
  10845a:	8b 7c 24 28          	mov    0x28(%esp),%edi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  10845e:	83 fe 07             	cmp    $0x7,%esi
  108461:	77 25                	ja     108488 <trap_handler_register+0x48>
    KERN_ASSERT(0 <= trapno && trapno < 256);
  108463:	81 fd ff 00 00 00    	cmp    $0xff,%ebp
  108469:	77 44                	ja     1084af <trap_handler_register+0x6f>
    KERN_ASSERT(cb != NULL);
  10846b:	85 ff                	test   %edi,%edi
  10846d:	74 63                	je     1084d2 <trap_handler_register+0x92>

    TRAP_HANDLER[cpu_idx][trapno] = cb;
  10846f:	c1 e6 08             	shl    $0x8,%esi
  108472:	01 ee                	add    %ebp,%esi
  108474:	89 bc b3 e0 3d cf 00 	mov    %edi,0xcf3de0(%ebx,%esi,4)
}
  10847b:	83 c4 0c             	add    $0xc,%esp
  10847e:	5b                   	pop    %ebx
  10847f:	5e                   	pop    %esi
  108480:	5f                   	pop    %edi
  108481:	5d                   	pop    %ebp
  108482:	c3                   	ret    
  108483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  108487:	90                   	nop
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  108488:	8d 83 f0 9a ff ff    	lea    -0x6510(%ebx),%eax
  10848e:	50                   	push   %eax
  10848f:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  108495:	50                   	push   %eax
  108496:	8d 83 58 9b ff ff    	lea    -0x64a8(%ebx),%eax
  10849c:	6a 18                	push   $0x18
  10849e:	50                   	push   %eax
  10849f:	e8 8c bb ff ff       	call   104030 <debug_panic>
  1084a4:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(0 <= trapno && trapno < 256);
  1084a7:	81 fd ff 00 00 00    	cmp    $0xff,%ebp
  1084ad:	76 bc                	jbe    10846b <trap_handler_register+0x2b>
  1084af:	8d 83 0c 9b ff ff    	lea    -0x64f4(%ebx),%eax
  1084b5:	50                   	push   %eax
  1084b6:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1084bc:	50                   	push   %eax
  1084bd:	8d 83 58 9b ff ff    	lea    -0x64a8(%ebx),%eax
  1084c3:	6a 19                	push   $0x19
  1084c5:	50                   	push   %eax
  1084c6:	e8 65 bb ff ff       	call   104030 <debug_panic>
  1084cb:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(cb != NULL);
  1084ce:	85 ff                	test   %edi,%edi
  1084d0:	75 9d                	jne    10846f <trap_handler_register+0x2f>
  1084d2:	8d 83 28 9b ff ff    	lea    -0x64d8(%ebx),%eax
  1084d8:	50                   	push   %eax
  1084d9:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1084df:	50                   	push   %eax
  1084e0:	8d 83 58 9b ff ff    	lea    -0x64a8(%ebx),%eax
  1084e6:	6a 1a                	push   $0x1a
  1084e8:	50                   	push   %eax
  1084e9:	e8 42 bb ff ff       	call   104030 <debug_panic>
  1084ee:	83 c4 10             	add    $0x10,%esp
  1084f1:	e9 79 ff ff ff       	jmp    10846f <trap_handler_register+0x2f>
  1084f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1084fd:	8d 76 00             	lea    0x0(%esi),%esi

00108500 <trap_init>:

void trap_init(unsigned int cpu_idx)
{
  108500:	55                   	push   %ebp
  108501:	57                   	push   %edi
  108502:	56                   	push   %esi
  108503:	53                   	push   %ebx
  108504:	e8 80 7e ff ff       	call   100389 <__x86.get_pc_thunk.bx>
  108509:	81 c3 f7 8a 00 00    	add    $0x8af7,%ebx
  10850f:	83 ec 1c             	sub    $0x1c,%esp
  108512:	8b 7c 24 30          	mov    0x30(%esp),%edi
    if (cpu_idx == 0) {
  108516:	85 ff                	test   %edi,%edi
  108518:	0f 84 06 02 00 00    	je     108724 <trap_init+0x224>
        trap_init_array();
    }

    KERN_INFO_CPU("Register trap handlers...\n", cpu_idx);
  10851e:	83 ec 08             	sub    $0x8,%esp
  108521:	8d 83 e8 9b ff ff    	lea    -0x6418(%ebx),%eax
  108527:	57                   	push   %edi
  108528:	50                   	push   %eax
  108529:	e8 92 ba ff ff       	call   103fc0 <debug_info>
  10852e:	83 c4 10             	add    $0x10,%esp
  108531:	8d 83 e0 3d cf 00    	lea    0xcf3de0(%ebx),%eax
  108537:	89 44 24 08          	mov    %eax,0x8(%esp)
  10853b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  10853f:	89 f8                	mov    %edi,%eax
  108541:	c7 c5 50 82 10 00    	mov    $0x108250,%ebp
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  108547:	89 7c 24 30          	mov    %edi,0x30(%esp)
  10854b:	c1 e0 0a             	shl    $0xa,%eax
  10854e:	8d 94 08 80 00 00 00 	lea    0x80(%eax,%ecx,1),%edx
  108555:	89 c6                	mov    %eax,%esi
  108557:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10855b:	8d 83 f0 9a ff ff    	lea    -0x6510(%ebx),%eax
  108561:	89 04 24             	mov    %eax,(%esp)
  108564:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  10856a:	89 d7                	mov    %edx,%edi
  10856c:	01 ce                	add    %ecx,%esi
  10856e:	89 44 24 04          	mov    %eax,0x4(%esp)
  108572:	8b 54 24 30          	mov    0x30(%esp),%edx
  108576:	eb 11                	jmp    108589 <trap_init+0x89>
  108578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10857f:	90                   	nop
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  108580:	89 2e                	mov    %ebp,(%esi)

    // TODO: for CPU # [cpu_idx], register appropriate trap handler for each trap number,
    // with trap_handler_register function defined above.
    for (int i = 0; i < T_IRQ0; i++) {
  108582:	83 c6 04             	add    $0x4,%esi
  108585:	39 fe                	cmp    %edi,%esi
  108587:	74 2f                	je     1085b8 <trap_init+0xb8>
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  108589:	83 fa 07             	cmp    $0x7,%edx
  10858c:	76 f2                	jbe    108580 <trap_init+0x80>
  10858e:	8d 8b 58 9b ff ff    	lea    -0x64a8(%ebx),%ecx
  108594:	89 54 24 30          	mov    %edx,0x30(%esp)
    for (int i = 0; i < T_IRQ0; i++) {
  108598:	83 c6 04             	add    $0x4,%esi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  10859b:	ff 34 24             	push   (%esp)
  10859e:	ff 74 24 08          	push   0x8(%esp)
  1085a2:	6a 18                	push   $0x18
  1085a4:	51                   	push   %ecx
  1085a5:	e8 86 ba ff ff       	call   104030 <debug_panic>
  1085aa:	83 c4 10             	add    $0x10,%esp
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  1085ad:	89 6e fc             	mov    %ebp,-0x4(%esi)
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  1085b0:	8b 54 24 30          	mov    0x30(%esp),%edx
    for (int i = 0; i < T_IRQ0; i++) {
  1085b4:	39 fe                	cmp    %edi,%esi
  1085b6:	75 d1                	jne    108589 <trap_init+0x89>
  1085b8:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1085bc:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1085c0:	c7 c6 b0 82 10 00    	mov    $0x1082b0,%esi
  1085c6:	8d ac 08 80 00 00 00 	lea    0x80(%eax,%ecx,1),%ebp
  1085cd:	8d 8c 08 c0 00 00 00 	lea    0xc0(%eax,%ecx,1),%ecx
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  1085d4:	8d 83 f0 9a ff ff    	lea    -0x6510(%ebx),%eax
  1085da:	89 ef                	mov    %ebp,%edi
  1085dc:	89 cd                	mov    %ecx,%ebp
  1085de:	89 04 24             	mov    %eax,(%esp)
  1085e1:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1085e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1085eb:	eb 0c                	jmp    1085f9 <trap_init+0xf9>
  1085ed:	8d 76 00             	lea    0x0(%esi),%esi
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  1085f0:	89 37                	mov    %esi,(%edi)
        trap_handler_register(cpu_idx, i, exception_handler);
    }

    for (int i = T_IRQ0; i < T_IRQ0 + 16; i++) {
  1085f2:	83 c7 04             	add    $0x4,%edi
  1085f5:	39 ef                	cmp    %ebp,%edi
  1085f7:	74 2f                	je     108628 <trap_init+0x128>
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  1085f9:	83 fa 07             	cmp    $0x7,%edx
  1085fc:	76 f2                	jbe    1085f0 <trap_init+0xf0>
  1085fe:	8d 8b 58 9b ff ff    	lea    -0x64a8(%ebx),%ecx
  108604:	89 54 24 30          	mov    %edx,0x30(%esp)
    for (int i = T_IRQ0; i < T_IRQ0 + 16; i++) {
  108608:	83 c7 04             	add    $0x4,%edi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  10860b:	ff 34 24             	push   (%esp)
  10860e:	ff 74 24 08          	push   0x8(%esp)
  108612:	6a 18                	push   $0x18
  108614:	51                   	push   %ecx
  108615:	e8 16 ba ff ff       	call   104030 <debug_panic>
  10861a:	83 c4 10             	add    $0x10,%esp
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  10861d:	89 77 fc             	mov    %esi,-0x4(%edi)
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  108620:	8b 54 24 30          	mov    0x30(%esp),%edx
    for (int i = T_IRQ0; i < T_IRQ0 + 16; i++) {
  108624:	39 ef                	cmp    %ebp,%edi
  108626:	75 d1                	jne    1085f9 <trap_init+0xf9>
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  108628:	89 d7                	mov    %edx,%edi
  10862a:	83 fa 07             	cmp    $0x7,%edx
  10862d:	77 6f                	ja     10869e <trap_init+0x19e>
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  10862f:	89 d0                	mov    %edx,%eax
  108631:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  108635:	c7 c2 a0 7e 10 00    	mov    $0x107ea0,%edx
  10863b:	c1 e0 0a             	shl    $0xa,%eax
  10863e:	89 94 08 c0 00 00 00 	mov    %edx,0xc0(%eax,%ecx,1)
    }

    trap_handler_register(cpu_idx, T_SYSCALL, syscall_dispatch);

    
    KERN_INFO_CPU("Done.\n", cpu_idx);
  108645:	85 ff                	test   %edi,%edi
  108647:	0f 85 86 00 00 00    	jne    1086d3 <trap_init+0x1d3>
  10864d:	83 ec 0c             	sub    $0xc,%esp
  108650:	8d b3 33 9b ff ff    	lea    -0x64cd(%ebx),%esi
  108656:	56                   	push   %esi
  108657:	e8 64 b9 ff ff       	call   103fc0 <debug_info>
    KERN_INFO_CPU("Enabling interrupts...\n", cpu_idx);
  10865c:	8d 83 a0 9b ff ff    	lea    -0x6460(%ebx),%eax
  108662:	89 04 24             	mov    %eax,(%esp)
  108665:	e8 56 b9 ff ff       	call   103fc0 <debug_info>

    /* enable interrupts */
    intr_enable(IRQ_TIMER, cpu_idx);
  10866a:	59                   	pop    %ecx
  10866b:	5f                   	pop    %edi
  10866c:	6a 00                	push   $0x0
  10866e:	6a 00                	push   $0x0
  108670:	e8 4b 91 ff ff       	call   1017c0 <intr_enable>
    intr_enable(IRQ_KBD, cpu_idx);
  108675:	5d                   	pop    %ebp
  108676:	58                   	pop    %eax
  108677:	6a 00                	push   $0x0
  108679:	6a 01                	push   $0x1
  10867b:	e8 40 91 ff ff       	call   1017c0 <intr_enable>
    intr_enable(IRQ_SERIAL13, cpu_idx);
  108680:	58                   	pop    %eax
  108681:	5a                   	pop    %edx
  108682:	6a 00                	push   $0x0
  108684:	6a 04                	push   $0x4
  108686:	e8 35 91 ff ff       	call   1017c0 <intr_enable>

    KERN_INFO_CPU("Done.\n", cpu_idx);
  10868b:	89 34 24             	mov    %esi,(%esp)
  10868e:	e8 2d b9 ff ff       	call   103fc0 <debug_info>
  108693:	83 c4 10             	add    $0x10,%esp
}
  108696:	83 c4 1c             	add    $0x1c,%esp
  108699:	5b                   	pop    %ebx
  10869a:	5e                   	pop    %esi
  10869b:	5f                   	pop    %edi
  10869c:	5d                   	pop    %ebp
  10869d:	c3                   	ret    
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  10869e:	8d 83 f0 9a ff ff    	lea    -0x6510(%ebx),%eax
  1086a4:	50                   	push   %eax
  1086a5:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  1086ab:	50                   	push   %eax
  1086ac:	8d 83 58 9b ff ff    	lea    -0x64a8(%ebx),%eax
  1086b2:	6a 18                	push   $0x18
  1086b4:	50                   	push   %eax
  1086b5:	e8 76 b9 ff ff       	call   104030 <debug_panic>
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  1086ba:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  1086be:	c7 c2 a0 7e 10 00    	mov    $0x107ea0,%edx
  1086c4:	89 f8                	mov    %edi,%eax
  1086c6:	c1 e0 0a             	shl    $0xa,%eax
  1086c9:	83 c4 10             	add    $0x10,%esp
  1086cc:	89 94 08 c0 00 00 00 	mov    %edx,0xc0(%eax,%ecx,1)
    KERN_INFO_CPU("Done.\n", cpu_idx);
  1086d3:	83 ec 08             	sub    $0x8,%esp
  1086d6:	8d b3 45 9b ff ff    	lea    -0x64bb(%ebx),%esi
  1086dc:	57                   	push   %edi
  1086dd:	56                   	push   %esi
  1086de:	e8 dd b8 ff ff       	call   103fc0 <debug_info>
    KERN_INFO_CPU("Enabling interrupts...\n", cpu_idx);
  1086e3:	58                   	pop    %eax
  1086e4:	8d 83 c4 9b ff ff    	lea    -0x643c(%ebx),%eax
  1086ea:	5a                   	pop    %edx
  1086eb:	57                   	push   %edi
  1086ec:	50                   	push   %eax
  1086ed:	e8 ce b8 ff ff       	call   103fc0 <debug_info>
    intr_enable(IRQ_TIMER, cpu_idx);
  1086f2:	59                   	pop    %ecx
  1086f3:	5d                   	pop    %ebp
  1086f4:	57                   	push   %edi
  1086f5:	6a 00                	push   $0x0
  1086f7:	e8 c4 90 ff ff       	call   1017c0 <intr_enable>
    intr_enable(IRQ_KBD, cpu_idx);
  1086fc:	58                   	pop    %eax
  1086fd:	5a                   	pop    %edx
  1086fe:	57                   	push   %edi
  1086ff:	6a 01                	push   $0x1
  108701:	e8 ba 90 ff ff       	call   1017c0 <intr_enable>
    intr_enable(IRQ_SERIAL13, cpu_idx);
  108706:	59                   	pop    %ecx
  108707:	5d                   	pop    %ebp
  108708:	57                   	push   %edi
  108709:	6a 04                	push   $0x4
  10870b:	e8 b0 90 ff ff       	call   1017c0 <intr_enable>
    KERN_INFO_CPU("Done.\n", cpu_idx);
  108710:	58                   	pop    %eax
  108711:	5a                   	pop    %edx
  108712:	57                   	push   %edi
  108713:	56                   	push   %esi
  108714:	e8 a7 b8 ff ff       	call   103fc0 <debug_info>
  108719:	83 c4 10             	add    $0x10,%esp
}
  10871c:	83 c4 1c             	add    $0x1c,%esp
  10871f:	5b                   	pop    %ebx
  108720:	5e                   	pop    %esi
  108721:	5f                   	pop    %edi
  108722:	5d                   	pop    %ebp
  108723:	c3                   	ret    
    KERN_ASSERT(inited == FALSE);
  108724:	8b 8b e0 5d cf 00    	mov    0xcf5de0(%ebx),%ecx
  10872a:	85 c9                	test   %ecx,%ecx
  10872c:	75 38                	jne    108766 <trap_init+0x266>
    memzero(&TRAP_HANDLER, sizeof(trap_cb_t) * 8 * 256);
  10872e:	83 ec 08             	sub    $0x8,%esp
  108731:	8d 83 e0 3d cf 00    	lea    0xcf3de0(%ebx),%eax
  108737:	68 00 20 00 00       	push   $0x2000
  10873c:	89 44 24 14          	mov    %eax,0x14(%esp)
  108740:	50                   	push   %eax
  108741:	e8 ea b7 ff ff       	call   103f30 <memzero>
    KERN_INFO_CPU("Register trap handlers...\n", cpu_idx);
  108746:	8d 83 78 9b ff ff    	lea    -0x6488(%ebx),%eax
    inited = TRUE;
  10874c:	c7 83 e0 5d cf 00 01 	movl   $0x1,0xcf5de0(%ebx)
  108753:	00 00 00 
    KERN_INFO_CPU("Register trap handlers...\n", cpu_idx);
  108756:	89 04 24             	mov    %eax,(%esp)
  108759:	e8 62 b8 ff ff       	call   103fc0 <debug_info>
  10875e:	83 c4 10             	add    $0x10,%esp
  108761:	e9 d5 fd ff ff       	jmp    10853b <trap_init+0x3b>
    KERN_ASSERT(inited == FALSE);
  108766:	8d 83 e0 9a ff ff    	lea    -0x6520(%ebx),%eax
  10876c:	50                   	push   %eax
  10876d:	8d 83 bf 82 ff ff    	lea    -0x7d41(%ebx),%eax
  108773:	50                   	push   %eax
  108774:	8d 83 58 9b ff ff    	lea    -0x64a8(%ebx),%eax
  10877a:	6a 11                	push   $0x11
  10877c:	50                   	push   %eax
  10877d:	e8 ae b8 ff ff       	call   104030 <debug_panic>
  108782:	83 c4 10             	add    $0x10,%esp
  108785:	eb a7                	jmp    10872e <trap_init+0x22e>
  108787:	66 90                	xchg   %ax,%ax
  108789:	66 90                	xchg   %ax,%ax
  10878b:	66 90                	xchg   %ax,%ax
  10878d:	66 90                	xchg   %ax,%ax
  10878f:	90                   	nop

00108790 <__udivdi3>:
  108790:	f3 0f 1e fb          	endbr32 
  108794:	55                   	push   %ebp
  108795:	57                   	push   %edi
  108796:	56                   	push   %esi
  108797:	53                   	push   %ebx
  108798:	83 ec 1c             	sub    $0x1c,%esp
  10879b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  10879f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  1087a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  1087a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  1087ab:	85 c0                	test   %eax,%eax
  1087ad:	75 19                	jne    1087c8 <__udivdi3+0x38>
  1087af:	39 f3                	cmp    %esi,%ebx
  1087b1:	76 4d                	jbe    108800 <__udivdi3+0x70>
  1087b3:	31 ff                	xor    %edi,%edi
  1087b5:	89 e8                	mov    %ebp,%eax
  1087b7:	89 f2                	mov    %esi,%edx
  1087b9:	f7 f3                	div    %ebx
  1087bb:	89 fa                	mov    %edi,%edx
  1087bd:	83 c4 1c             	add    $0x1c,%esp
  1087c0:	5b                   	pop    %ebx
  1087c1:	5e                   	pop    %esi
  1087c2:	5f                   	pop    %edi
  1087c3:	5d                   	pop    %ebp
  1087c4:	c3                   	ret    
  1087c5:	8d 76 00             	lea    0x0(%esi),%esi
  1087c8:	39 f0                	cmp    %esi,%eax
  1087ca:	76 14                	jbe    1087e0 <__udivdi3+0x50>
  1087cc:	31 ff                	xor    %edi,%edi
  1087ce:	31 c0                	xor    %eax,%eax
  1087d0:	89 fa                	mov    %edi,%edx
  1087d2:	83 c4 1c             	add    $0x1c,%esp
  1087d5:	5b                   	pop    %ebx
  1087d6:	5e                   	pop    %esi
  1087d7:	5f                   	pop    %edi
  1087d8:	5d                   	pop    %ebp
  1087d9:	c3                   	ret    
  1087da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1087e0:	0f bd f8             	bsr    %eax,%edi
  1087e3:	83 f7 1f             	xor    $0x1f,%edi
  1087e6:	75 48                	jne    108830 <__udivdi3+0xa0>
  1087e8:	39 f0                	cmp    %esi,%eax
  1087ea:	72 06                	jb     1087f2 <__udivdi3+0x62>
  1087ec:	31 c0                	xor    %eax,%eax
  1087ee:	39 eb                	cmp    %ebp,%ebx
  1087f0:	77 de                	ja     1087d0 <__udivdi3+0x40>
  1087f2:	b8 01 00 00 00       	mov    $0x1,%eax
  1087f7:	eb d7                	jmp    1087d0 <__udivdi3+0x40>
  1087f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108800:	89 d9                	mov    %ebx,%ecx
  108802:	85 db                	test   %ebx,%ebx
  108804:	75 0b                	jne    108811 <__udivdi3+0x81>
  108806:	b8 01 00 00 00       	mov    $0x1,%eax
  10880b:	31 d2                	xor    %edx,%edx
  10880d:	f7 f3                	div    %ebx
  10880f:	89 c1                	mov    %eax,%ecx
  108811:	31 d2                	xor    %edx,%edx
  108813:	89 f0                	mov    %esi,%eax
  108815:	f7 f1                	div    %ecx
  108817:	89 c6                	mov    %eax,%esi
  108819:	89 e8                	mov    %ebp,%eax
  10881b:	89 f7                	mov    %esi,%edi
  10881d:	f7 f1                	div    %ecx
  10881f:	89 fa                	mov    %edi,%edx
  108821:	83 c4 1c             	add    $0x1c,%esp
  108824:	5b                   	pop    %ebx
  108825:	5e                   	pop    %esi
  108826:	5f                   	pop    %edi
  108827:	5d                   	pop    %ebp
  108828:	c3                   	ret    
  108829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108830:	89 f9                	mov    %edi,%ecx
  108832:	ba 20 00 00 00       	mov    $0x20,%edx
  108837:	29 fa                	sub    %edi,%edx
  108839:	d3 e0                	shl    %cl,%eax
  10883b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10883f:	89 d1                	mov    %edx,%ecx
  108841:	89 d8                	mov    %ebx,%eax
  108843:	d3 e8                	shr    %cl,%eax
  108845:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  108849:	09 c1                	or     %eax,%ecx
  10884b:	89 f0                	mov    %esi,%eax
  10884d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  108851:	89 f9                	mov    %edi,%ecx
  108853:	d3 e3                	shl    %cl,%ebx
  108855:	89 d1                	mov    %edx,%ecx
  108857:	d3 e8                	shr    %cl,%eax
  108859:	89 f9                	mov    %edi,%ecx
  10885b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10885f:	89 eb                	mov    %ebp,%ebx
  108861:	d3 e6                	shl    %cl,%esi
  108863:	89 d1                	mov    %edx,%ecx
  108865:	d3 eb                	shr    %cl,%ebx
  108867:	09 f3                	or     %esi,%ebx
  108869:	89 c6                	mov    %eax,%esi
  10886b:	89 f2                	mov    %esi,%edx
  10886d:	89 d8                	mov    %ebx,%eax
  10886f:	f7 74 24 08          	divl   0x8(%esp)
  108873:	89 d6                	mov    %edx,%esi
  108875:	89 c3                	mov    %eax,%ebx
  108877:	f7 64 24 0c          	mull   0xc(%esp)
  10887b:	39 d6                	cmp    %edx,%esi
  10887d:	72 19                	jb     108898 <__udivdi3+0x108>
  10887f:	89 f9                	mov    %edi,%ecx
  108881:	d3 e5                	shl    %cl,%ebp
  108883:	39 c5                	cmp    %eax,%ebp
  108885:	73 04                	jae    10888b <__udivdi3+0xfb>
  108887:	39 d6                	cmp    %edx,%esi
  108889:	74 0d                	je     108898 <__udivdi3+0x108>
  10888b:	89 d8                	mov    %ebx,%eax
  10888d:	31 ff                	xor    %edi,%edi
  10888f:	e9 3c ff ff ff       	jmp    1087d0 <__udivdi3+0x40>
  108894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  108898:	8d 43 ff             	lea    -0x1(%ebx),%eax
  10889b:	31 ff                	xor    %edi,%edi
  10889d:	e9 2e ff ff ff       	jmp    1087d0 <__udivdi3+0x40>
  1088a2:	66 90                	xchg   %ax,%ax
  1088a4:	66 90                	xchg   %ax,%ax
  1088a6:	66 90                	xchg   %ax,%ax
  1088a8:	66 90                	xchg   %ax,%ax
  1088aa:	66 90                	xchg   %ax,%ax
  1088ac:	66 90                	xchg   %ax,%ax
  1088ae:	66 90                	xchg   %ax,%ax

001088b0 <__umoddi3>:
  1088b0:	f3 0f 1e fb          	endbr32 
  1088b4:	55                   	push   %ebp
  1088b5:	57                   	push   %edi
  1088b6:	56                   	push   %esi
  1088b7:	53                   	push   %ebx
  1088b8:	83 ec 1c             	sub    $0x1c,%esp
  1088bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  1088bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  1088c3:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  1088c7:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  1088cb:	89 f0                	mov    %esi,%eax
  1088cd:	89 da                	mov    %ebx,%edx
  1088cf:	85 ff                	test   %edi,%edi
  1088d1:	75 15                	jne    1088e8 <__umoddi3+0x38>
  1088d3:	39 dd                	cmp    %ebx,%ebp
  1088d5:	76 39                	jbe    108910 <__umoddi3+0x60>
  1088d7:	f7 f5                	div    %ebp
  1088d9:	89 d0                	mov    %edx,%eax
  1088db:	31 d2                	xor    %edx,%edx
  1088dd:	83 c4 1c             	add    $0x1c,%esp
  1088e0:	5b                   	pop    %ebx
  1088e1:	5e                   	pop    %esi
  1088e2:	5f                   	pop    %edi
  1088e3:	5d                   	pop    %ebp
  1088e4:	c3                   	ret    
  1088e5:	8d 76 00             	lea    0x0(%esi),%esi
  1088e8:	39 df                	cmp    %ebx,%edi
  1088ea:	77 f1                	ja     1088dd <__umoddi3+0x2d>
  1088ec:	0f bd cf             	bsr    %edi,%ecx
  1088ef:	83 f1 1f             	xor    $0x1f,%ecx
  1088f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1088f6:	75 40                	jne    108938 <__umoddi3+0x88>
  1088f8:	39 df                	cmp    %ebx,%edi
  1088fa:	72 04                	jb     108900 <__umoddi3+0x50>
  1088fc:	39 f5                	cmp    %esi,%ebp
  1088fe:	77 dd                	ja     1088dd <__umoddi3+0x2d>
  108900:	89 da                	mov    %ebx,%edx
  108902:	89 f0                	mov    %esi,%eax
  108904:	29 e8                	sub    %ebp,%eax
  108906:	19 fa                	sbb    %edi,%edx
  108908:	eb d3                	jmp    1088dd <__umoddi3+0x2d>
  10890a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  108910:	89 e9                	mov    %ebp,%ecx
  108912:	85 ed                	test   %ebp,%ebp
  108914:	75 0b                	jne    108921 <__umoddi3+0x71>
  108916:	b8 01 00 00 00       	mov    $0x1,%eax
  10891b:	31 d2                	xor    %edx,%edx
  10891d:	f7 f5                	div    %ebp
  10891f:	89 c1                	mov    %eax,%ecx
  108921:	89 d8                	mov    %ebx,%eax
  108923:	31 d2                	xor    %edx,%edx
  108925:	f7 f1                	div    %ecx
  108927:	89 f0                	mov    %esi,%eax
  108929:	f7 f1                	div    %ecx
  10892b:	89 d0                	mov    %edx,%eax
  10892d:	31 d2                	xor    %edx,%edx
  10892f:	eb ac                	jmp    1088dd <__umoddi3+0x2d>
  108931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108938:	8b 44 24 04          	mov    0x4(%esp),%eax
  10893c:	ba 20 00 00 00       	mov    $0x20,%edx
  108941:	29 c2                	sub    %eax,%edx
  108943:	89 c1                	mov    %eax,%ecx
  108945:	89 e8                	mov    %ebp,%eax
  108947:	d3 e7                	shl    %cl,%edi
  108949:	89 d1                	mov    %edx,%ecx
  10894b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10894f:	d3 e8                	shr    %cl,%eax
  108951:	89 c1                	mov    %eax,%ecx
  108953:	8b 44 24 04          	mov    0x4(%esp),%eax
  108957:	09 f9                	or     %edi,%ecx
  108959:	89 df                	mov    %ebx,%edi
  10895b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10895f:	89 c1                	mov    %eax,%ecx
  108961:	d3 e5                	shl    %cl,%ebp
  108963:	89 d1                	mov    %edx,%ecx
  108965:	d3 ef                	shr    %cl,%edi
  108967:	89 c1                	mov    %eax,%ecx
  108969:	89 f0                	mov    %esi,%eax
  10896b:	d3 e3                	shl    %cl,%ebx
  10896d:	89 d1                	mov    %edx,%ecx
  10896f:	89 fa                	mov    %edi,%edx
  108971:	d3 e8                	shr    %cl,%eax
  108973:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  108978:	09 d8                	or     %ebx,%eax
  10897a:	f7 74 24 08          	divl   0x8(%esp)
  10897e:	89 d3                	mov    %edx,%ebx
  108980:	d3 e6                	shl    %cl,%esi
  108982:	f7 e5                	mul    %ebp
  108984:	89 c7                	mov    %eax,%edi
  108986:	89 d1                	mov    %edx,%ecx
  108988:	39 d3                	cmp    %edx,%ebx
  10898a:	72 06                	jb     108992 <__umoddi3+0xe2>
  10898c:	75 0e                	jne    10899c <__umoddi3+0xec>
  10898e:	39 c6                	cmp    %eax,%esi
  108990:	73 0a                	jae    10899c <__umoddi3+0xec>
  108992:	29 e8                	sub    %ebp,%eax
  108994:	1b 54 24 08          	sbb    0x8(%esp),%edx
  108998:	89 d1                	mov    %edx,%ecx
  10899a:	89 c7                	mov    %eax,%edi
  10899c:	89 f5                	mov    %esi,%ebp
  10899e:	8b 74 24 04          	mov    0x4(%esp),%esi
  1089a2:	29 fd                	sub    %edi,%ebp
  1089a4:	19 cb                	sbb    %ecx,%ebx
  1089a6:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  1089ab:	89 d8                	mov    %ebx,%eax
  1089ad:	d3 e0                	shl    %cl,%eax
  1089af:	89 f1                	mov    %esi,%ecx
  1089b1:	d3 ed                	shr    %cl,%ebp
  1089b3:	d3 eb                	shr    %cl,%ebx
  1089b5:	09 e8                	or     %ebp,%eax
  1089b7:	89 da                	mov    %ebx,%edx
  1089b9:	83 c4 1c             	add    $0x1c,%esp
  1089bc:	5b                   	pop    %ebx
  1089bd:	5e                   	pop    %esi
  1089be:	5f                   	pop    %edi
  1089bf:	5d                   	pop    %ebp
  1089c0:	c3                   	ret    
