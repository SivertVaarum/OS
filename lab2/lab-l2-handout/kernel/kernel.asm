
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	47013103          	ld	sp,1136(sp) # 8000b470 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000b717          	auipc	a4,0xb
    80000054:	48070713          	addi	a4,a4,1152 # 8000b4d0 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	22e78793          	addi	a5,a5,558 # 80006290 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9cbf>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e2678793          	addi	a5,a5,-474 # 80000ed2 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
    int i;

    for (i = 0; i < n; i++)
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	7a0080e7          	jalr	1952(ra) # 800028ca <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
            break;
        uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
    for (i = 0; i < n; i++)
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
    }

    return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    80000188:	00060b1b          	sext.w	s6,a2
    acquire(&cons.lock);
    8000018c:	00013517          	auipc	a0,0x13
    80000190:	48450513          	addi	a0,a0,1156 # 80013610 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	47448493          	addi	s1,s1,1140 # 80013610 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	50490913          	addi	s2,s2,1284 # 800136a8 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	ad8080e7          	jalr	-1320(ra) # 80001c94 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	550080e7          	jalr	1360(ra) # 80002714 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	29a080e7          	jalr	666(ra) # 8000246c <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	42870713          	addi	a4,a4,1064 # 80013610 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

        if (c == C('D'))
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
            }
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	65a080e7          	jalr	1626(ra) # 80002874 <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
            break;

        dst++;
    80000228:	0a05                	addi	s4,s4,1
        --n;
    8000022a:	39fd                	addiw	s3,s3,-1

        if (c == '\n')
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
                release(&cons.lock);
    80000236:	00013517          	auipc	a0,0x13
    8000023a:	3da50513          	addi	a0,a0,986 # 80013610 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	aae080e7          	jalr	-1362(ra) # 80000cec <release>
                return -1;
    80000246:	557d                	li	a0,-1
        }
    }
    release(&cons.lock);

    return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
            if (n < target)
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
                cons.r--;
    80000264:	00013717          	auipc	a4,0x13
    80000268:	44f72223          	sw	a5,1092(a4) # 800136a8 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	39650513          	addi	a0,a0,918 # 80013610 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	a6a080e7          	jalr	-1430(ra) # 80000cec <release>
    return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
        uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
        uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
        uartputc_sync(' ');
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
        uartputc_sync('\b');
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002e2:	00013517          	auipc	a0,0x13
    800002e6:	32e50513          	addi	a0,a0,814 # 80013610 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	94e080e7          	jalr	-1714(ra) # 80000c38 <acquire>

    switch (c)
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
    {
    case C('P'): // Print process list.
        procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	618080e7          	jalr	1560(ra) # 80002920 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	30050513          	addi	a0,a0,768 # 80013610 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	9d4080e7          	jalr	-1580(ra) # 80000cec <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
    switch (c)
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000332:	00013717          	auipc	a4,0x13
    80000336:	2de70713          	addi	a4,a4,734 # 80013610 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
            c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
            consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00013797          	auipc	a5,0x13
    80000360:	2b478793          	addi	a5,a5,692 # 80013610 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00013797          	auipc	a5,0x13
    8000038e:	31e7a783          	lw	a5,798(a5) # 800136a8 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	27070713          	addi	a4,a4,624 # 80013610 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	26048493          	addi	s1,s1,608 # 80013610 <cons>
        while (cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
            cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
        while (cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
        if (cons.e != cons.w)
    800003f6:	00013717          	auipc	a4,0x13
    800003fa:	21a70713          	addi	a4,a4,538 # 80013610 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	2af72223          	sw	a5,676(a4) # 800136b0 <cons+0xa0>
            consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
            consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00013797          	auipc	a5,0x13
    80000436:	1de78793          	addi	a5,a5,478 # 80013610 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    80000456:	00013797          	auipc	a5,0x13
    8000045a:	24c7ab23          	sw	a2,598(a5) # 800136ac <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	24a50513          	addi	a0,a0,586 # 800136a8 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	06a080e7          	jalr	106(ra) # 800024d0 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	19050513          	addi	a0,a0,400 # 80013610 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00023797          	auipc	a5,0x23
    8000049c:	51078793          	addi	a5,a5,1296 # 800239a8 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	33a60613          	addi	a2,a2,826 # 80008810 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00013797          	auipc	a5,0x13
    80000570:	1607a223          	sw	zero,356(a5) # 800136d0 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000b717          	auipc	a4,0xb
    800005a4:	eef72823          	sw	a5,-272(a4) # 8000b490 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00013d17          	auipc	s10,0x13
    800005ce:	106d2d03          	lw	s10,262(s10) # 800136d0 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	208a8a93          	addi	s5,s5,520 # 80008810 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00013517          	auipc	a0,0x13
    8000061e:	09e50513          	addi	a0,a0,158 # 800136b8 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	616080e7          	jalr	1558(ra) # 80000c38 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00013517          	auipc	a0,0x13
    800007a4:	f1850513          	addi	a0,a0,-232 # 800136b8 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	544080e7          	jalr	1348(ra) # 80000cec <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00013497          	auipc	s1,0x13
    800007c0:	efc48493          	addi	s1,s1,-260 # 800136b8 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	3da080e7          	jalr	986(ra) # 80000ba8 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00013517          	auipc	a0,0x13
    8000082c:	eb050513          	addi	a0,a0,-336 # 800136d8 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	378080e7          	jalr	888(ra) # 80000ba8 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	3a0080e7          	jalr	928(ra) # 80000bec <push_off>

  if(panicked){
    80000854:	0000b797          	auipc	a5,0xb
    80000858:	c3c7a783          	lw	a5,-964(a5) # 8000b490 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	412080e7          	jalr	1042(ra) # 80000c8c <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	0000b797          	auipc	a5,0xb
    80000892:	c0a7b783          	ld	a5,-1014(a5) # 8000b498 <uart_tx_r>
    80000896:	0000b717          	auipc	a4,0xb
    8000089a:	c0a73703          	ld	a4,-1014(a4) # 8000b4a0 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00013a97          	auipc	s5,0x13
    800008c0:	e1ca8a93          	addi	s5,s5,-484 # 800136d8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000b497          	auipc	s1,0xb
    800008c8:	bd448493          	addi	s1,s1,-1068 # 8000b498 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000b997          	auipc	s3,0xb
    800008d4:	bd098993          	addi	s3,s3,-1072 # 8000b4a0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	bde080e7          	jalr	-1058(ra) # 800024d0 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00013517          	auipc	a0,0x13
    80000934:	da850513          	addi	a0,a0,-600 # 800136d8 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	300080e7          	jalr	768(ra) # 80000c38 <acquire>
  if(panicked){
    80000940:	0000b797          	auipc	a5,0xb
    80000944:	b507a783          	lw	a5,-1200(a5) # 8000b490 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000b717          	auipc	a4,0xb
    8000094e:	b5673703          	ld	a4,-1194(a4) # 8000b4a0 <uart_tx_w>
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	b467b783          	ld	a5,-1210(a5) # 8000b498 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00013997          	auipc	s3,0x13
    80000962:	d7a98993          	addi	s3,s3,-646 # 800136d8 <uart_tx_lock>
    80000966:	0000b497          	auipc	s1,0xb
    8000096a:	b3248493          	addi	s1,s1,-1230 # 8000b498 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000b917          	auipc	s2,0xb
    80000972:	b3290913          	addi	s2,s2,-1230 # 8000b4a0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	aee080e7          	jalr	-1298(ra) # 8000246c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00013497          	auipc	s1,0x13
    80000998:	d4448493          	addi	s1,s1,-700 # 800136d8 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000b797          	auipc	a5,0xb
    800009ac:	aee7bc23          	sd	a4,-1288(a5) # 8000b4a0 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	332080e7          	jalr	818(ra) # 80000cec <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00013497          	auipc	s1,0x13
    80000a20:	cbc48493          	addi	s1,s1,-836 # 800136d8 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	212080e7          	jalr	530(ra) # 80000c38 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	2b4080e7          	jalr	692(ra) # 80000cec <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4a:	1101                	addi	sp,sp,-32
    80000a4c:	ec06                	sd	ra,24(sp)
    80000a4e:	e822                	sd	s0,16(sp)
    80000a50:	e426                	sd	s1,8(sp)
    80000a52:	e04a                	sd	s2,0(sp)
    80000a54:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a56:	03451793          	slli	a5,a0,0x34
    80000a5a:	ebb9                	bnez	a5,80000ab0 <kfree+0x66>
    80000a5c:	84aa                	mv	s1,a0
    80000a5e:	00024797          	auipc	a5,0x24
    80000a62:	0e278793          	addi	a5,a5,226 # 80024b40 <end>
    80000a66:	04f56563          	bltu	a0,a5,80000ab0 <kfree+0x66>
    80000a6a:	47c5                	li	a5,17
    80000a6c:	07ee                	slli	a5,a5,0x1b
    80000a6e:	04f57163          	bgeu	a0,a5,80000ab0 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a72:	6605                	lui	a2,0x1
    80000a74:	4585                	li	a1,1
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	2be080e7          	jalr	702(ra) # 80000d34 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a7e:	00013917          	auipc	s2,0x13
    80000a82:	c9290913          	addi	s2,s2,-878 # 80013710 <kmem>
    80000a86:	854a                	mv	a0,s2
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	1b0080e7          	jalr	432(ra) # 80000c38 <acquire>
  r->next = kmem.freelist;
    80000a90:	01893783          	ld	a5,24(s2)
    80000a94:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a96:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	250080e7          	jalr	592(ra) # 80000cec <release>
}
    80000aa4:	60e2                	ld	ra,24(sp)
    80000aa6:	6442                	ld	s0,16(sp)
    80000aa8:	64a2                	ld	s1,8(sp)
    80000aaa:	6902                	ld	s2,0(sp)
    80000aac:	6105                	addi	sp,sp,32
    80000aae:	8082                	ret
    panic("kfree");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	59050513          	addi	a0,a0,1424 # 80008040 <etext+0x40>
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	aa8080e7          	jalr	-1368(ra) # 80000560 <panic>

0000000080000ac0 <freerange>:
{
    80000ac0:	7179                	addi	sp,sp,-48
    80000ac2:	f406                	sd	ra,40(sp)
    80000ac4:	f022                	sd	s0,32(sp)
    80000ac6:	ec26                	sd	s1,24(sp)
    80000ac8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aca:	6785                	lui	a5,0x1
    80000acc:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad0:	00e504b3          	add	s1,a0,a4
    80000ad4:	777d                	lui	a4,0xfffff
    80000ad6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94be                	add	s1,s1,a5
    80000ada:	0295e463          	bltu	a1,s1,80000b02 <freerange+0x42>
    80000ade:	e84a                	sd	s2,16(sp)
    80000ae0:	e44e                	sd	s3,8(sp)
    80000ae2:	e052                	sd	s4,0(sp)
    80000ae4:	892e                	mv	s2,a1
    kfree(p);
    80000ae6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	6985                	lui	s3,0x1
    kfree(p);
    80000aea:	01448533          	add	a0,s1,s4
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f5c080e7          	jalr	-164(ra) # 80000a4a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af6:	94ce                	add	s1,s1,s3
    80000af8:	fe9979e3          	bgeu	s2,s1,80000aea <freerange+0x2a>
    80000afc:	6942                	ld	s2,16(sp)
    80000afe:	69a2                	ld	s3,8(sp)
    80000b00:	6a02                	ld	s4,0(sp)
}
    80000b02:	70a2                	ld	ra,40(sp)
    80000b04:	7402                	ld	s0,32(sp)
    80000b06:	64e2                	ld	s1,24(sp)
    80000b08:	6145                	addi	sp,sp,48
    80000b0a:	8082                	ret

0000000080000b0c <kinit>:
{
    80000b0c:	1141                	addi	sp,sp,-16
    80000b0e:	e406                	sd	ra,8(sp)
    80000b10:	e022                	sd	s0,0(sp)
    80000b12:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b14:	00007597          	auipc	a1,0x7
    80000b18:	53458593          	addi	a1,a1,1332 # 80008048 <etext+0x48>
    80000b1c:	00013517          	auipc	a0,0x13
    80000b20:	bf450513          	addi	a0,a0,-1036 # 80013710 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00024517          	auipc	a0,0x24
    80000b34:	01050513          	addi	a0,a0,16 # 80024b40 <end>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	f88080e7          	jalr	-120(ra) # 80000ac0 <freerange>
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b48:	1101                	addi	sp,sp,-32
    80000b4a:	ec06                	sd	ra,24(sp)
    80000b4c:	e822                	sd	s0,16(sp)
    80000b4e:	e426                	sd	s1,8(sp)
    80000b50:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b52:	00013497          	auipc	s1,0x13
    80000b56:	bbe48493          	addi	s1,s1,-1090 # 80013710 <kmem>
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	0dc080e7          	jalr	220(ra) # 80000c38 <acquire>
  r = kmem.freelist;
    80000b64:	6c84                	ld	s1,24(s1)
  if(r)
    80000b66:	c885                	beqz	s1,80000b96 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b68:	609c                	ld	a5,0(s1)
    80000b6a:	00013517          	auipc	a0,0x13
    80000b6e:	ba650513          	addi	a0,a0,-1114 # 80013710 <kmem>
    80000b72:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	178080e7          	jalr	376(ra) # 80000cec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	4595                	li	a1,5
    80000b80:	8526                	mv	a0,s1
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	1b2080e7          	jalr	434(ra) # 80000d34 <memset>
  return (void*)r;
}
    80000b8a:	8526                	mv	a0,s1
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret
  release(&kmem.lock);
    80000b96:	00013517          	auipc	a0,0x13
    80000b9a:	b7a50513          	addi	a0,a0,-1158 # 80013710 <kmem>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	14e080e7          	jalr	334(ra) # 80000cec <release>
  if(r)
    80000ba6:	b7d5                	j	80000b8a <kalloc+0x42>

0000000080000ba8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ba8:	1141                	addi	sp,sp,-16
    80000baa:	e422                	sd	s0,8(sp)
    80000bac:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb4:	00053823          	sd	zero,16(a0)
}
    80000bb8:	6422                	ld	s0,8(sp)
    80000bba:	0141                	addi	sp,sp,16
    80000bbc:	8082                	ret

0000000080000bbe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bbe:	411c                	lw	a5,0(a0)
    80000bc0:	e399                	bnez	a5,80000bc6 <holding+0x8>
    80000bc2:	4501                	li	a0,0
  return r;
}
    80000bc4:	8082                	ret
{
    80000bc6:	1101                	addi	sp,sp,-32
    80000bc8:	ec06                	sd	ra,24(sp)
    80000bca:	e822                	sd	s0,16(sp)
    80000bcc:	e426                	sd	s1,8(sp)
    80000bce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd0:	6904                	ld	s1,16(a0)
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	0a6080e7          	jalr	166(ra) # 80001c78 <mycpu>
    80000bda:	40a48533          	sub	a0,s1,a0
    80000bde:	00153513          	seqz	a0,a0
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret

0000000080000bec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bec:	1101                	addi	sp,sp,-32
    80000bee:	ec06                	sd	ra,24(sp)
    80000bf0:	e822                	sd	s0,16(sp)
    80000bf2:	e426                	sd	s1,8(sp)
    80000bf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf6:	100024f3          	csrr	s1,sstatus
    80000bfa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c00:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c04:	00001097          	auipc	ra,0x1
    80000c08:	074080e7          	jalr	116(ra) # 80001c78 <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	068080e7          	jalr	104(ra) # 80001c78 <mycpu>
    80000c18:	5d3c                	lw	a5,120(a0)
    80000c1a:	2785                	addiw	a5,a5,1
    80000c1c:	dd3c                	sw	a5,120(a0)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    mycpu()->intena = old;
    80000c28:	00001097          	auipc	ra,0x1
    80000c2c:	050080e7          	jalr	80(ra) # 80001c78 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c30:	8085                	srli	s1,s1,0x1
    80000c32:	8885                	andi	s1,s1,1
    80000c34:	dd64                	sw	s1,124(a0)
    80000c36:	bfe9                	j	80000c10 <push_off+0x24>

0000000080000c38 <acquire>:
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	fa8080e7          	jalr	-88(ra) # 80000bec <push_off>
  if(holding(lk))
    80000c4c:	8526                	mv	a0,s1
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	f70080e7          	jalr	-144(ra) # 80000bbe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c56:	4705                	li	a4,1
  if(holding(lk))
    80000c58:	e115                	bnez	a0,80000c7c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5a:	87ba                	mv	a5,a4
    80000c5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c60:	2781                	sext.w	a5,a5
    80000c62:	ffe5                	bnez	a5,80000c5a <acquire+0x22>
  __sync_synchronize();
    80000c64:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c68:	00001097          	auipc	ra,0x1
    80000c6c:	010080e7          	jalr	16(ra) # 80001c78 <mycpu>
    80000c70:	e888                	sd	a0,16(s1)
}
    80000c72:	60e2                	ld	ra,24(sp)
    80000c74:	6442                	ld	s0,16(sp)
    80000c76:	64a2                	ld	s1,8(sp)
    80000c78:	6105                	addi	sp,sp,32
    80000c7a:	8082                	ret
    panic("acquire");
    80000c7c:	00007517          	auipc	a0,0x7
    80000c80:	3d450513          	addi	a0,a0,980 # 80008050 <etext+0x50>
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	8dc080e7          	jalr	-1828(ra) # 80000560 <panic>

0000000080000c8c <pop_off>:

void
pop_off(void)
{
    80000c8c:	1141                	addi	sp,sp,-16
    80000c8e:	e406                	sd	ra,8(sp)
    80000c90:	e022                	sd	s0,0(sp)
    80000c92:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c94:	00001097          	auipc	ra,0x1
    80000c98:	fe4080e7          	jalr	-28(ra) # 80001c78 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c9c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca2:	e78d                	bnez	a5,80000ccc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000ca4:	5d3c                	lw	a5,120(a0)
    80000ca6:	02f05b63          	blez	a5,80000cdc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000caa:	37fd                	addiw	a5,a5,-1
    80000cac:	0007871b          	sext.w	a4,a5
    80000cb0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb2:	eb09                	bnez	a4,80000cc4 <pop_off+0x38>
    80000cb4:	5d7c                	lw	a5,124(a0)
    80000cb6:	c799                	beqz	a5,80000cc4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc4:	60a2                	ld	ra,8(sp)
    80000cc6:	6402                	ld	s0,0(sp)
    80000cc8:	0141                	addi	sp,sp,16
    80000cca:	8082                	ret
    panic("pop_off - interruptible");
    80000ccc:	00007517          	auipc	a0,0x7
    80000cd0:	38c50513          	addi	a0,a0,908 # 80008058 <etext+0x58>
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	88c080e7          	jalr	-1908(ra) # 80000560 <panic>
    panic("pop_off");
    80000cdc:	00007517          	auipc	a0,0x7
    80000ce0:	39450513          	addi	a0,a0,916 # 80008070 <etext+0x70>
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	87c080e7          	jalr	-1924(ra) # 80000560 <panic>

0000000080000cec <release>:
{
    80000cec:	1101                	addi	sp,sp,-32
    80000cee:	ec06                	sd	ra,24(sp)
    80000cf0:	e822                	sd	s0,16(sp)
    80000cf2:	e426                	sd	s1,8(sp)
    80000cf4:	1000                	addi	s0,sp,32
    80000cf6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	ec6080e7          	jalr	-314(ra) # 80000bbe <holding>
    80000d00:	c115                	beqz	a0,80000d24 <release+0x38>
  lk->cpu = 0;
    80000d02:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d06:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d0a:	0310000f          	fence	rw,w
    80000d0e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	f7a080e7          	jalr	-134(ra) # 80000c8c <pop_off>
}
    80000d1a:	60e2                	ld	ra,24(sp)
    80000d1c:	6442                	ld	s0,16(sp)
    80000d1e:	64a2                	ld	s1,8(sp)
    80000d20:	6105                	addi	sp,sp,32
    80000d22:	8082                	ret
    panic("release");
    80000d24:	00007517          	auipc	a0,0x7
    80000d28:	35450513          	addi	a0,a0,852 # 80008078 <etext+0x78>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	834080e7          	jalr	-1996(ra) # 80000560 <panic>

0000000080000d34 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d34:	1141                	addi	sp,sp,-16
    80000d36:	e422                	sd	s0,8(sp)
    80000d38:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3a:	ca19                	beqz	a2,80000d50 <memset+0x1c>
    80000d3c:	87aa                	mv	a5,a0
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d46:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4a:	0785                	addi	a5,a5,1
    80000d4c:	fee79de3          	bne	a5,a4,80000d46 <memset+0x12>
  }
  return dst;
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d5c:	ca05                	beqz	a2,80000d8c <memcmp+0x36>
    80000d5e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d62:	1682                	slli	a3,a3,0x20
    80000d64:	9281                	srli	a3,a3,0x20
    80000d66:	0685                	addi	a3,a3,1
    80000d68:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d6a:	00054783          	lbu	a5,0(a0)
    80000d6e:	0005c703          	lbu	a4,0(a1)
    80000d72:	00e79863          	bne	a5,a4,80000d82 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d76:	0505                	addi	a0,a0,1
    80000d78:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d7a:	fed518e3          	bne	a0,a3,80000d6a <memcmp+0x14>
  }

  return 0;
    80000d7e:	4501                	li	a0,0
    80000d80:	a019                	j	80000d86 <memcmp+0x30>
      return *s1 - *s2;
    80000d82:	40e7853b          	subw	a0,a5,a4
}
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret
  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	bfe5                	j	80000d86 <memcmp+0x30>

0000000080000d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e422                	sd	s0,8(sp)
    80000d94:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d96:	c205                	beqz	a2,80000db6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d98:	02a5e263          	bltu	a1,a0,80000dbc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d9c:	1602                	slli	a2,a2,0x20
    80000d9e:	9201                	srli	a2,a2,0x20
    80000da0:	00c587b3          	add	a5,a1,a2
{
    80000da4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000da6:	0585                	addi	a1,a1,1
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda4c1>
    80000daa:	fff5c683          	lbu	a3,-1(a1)
    80000dae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000db2:	feb79ae3          	bne	a5,a1,80000da6 <memmove+0x16>

  return dst;
}
    80000db6:	6422                	ld	s0,8(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
  if(s < d && s + n > d){
    80000dbc:	02061693          	slli	a3,a2,0x20
    80000dc0:	9281                	srli	a3,a3,0x20
    80000dc2:	00d58733          	add	a4,a1,a3
    80000dc6:	fce57be3          	bgeu	a0,a4,80000d9c <memmove+0xc>
    d += n;
    80000dca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dcc:	fff6079b          	addiw	a5,a2,-1
    80000dd0:	1782                	slli	a5,a5,0x20
    80000dd2:	9381                	srli	a5,a5,0x20
    80000dd4:	fff7c793          	not	a5,a5
    80000dd8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dda:	177d                	addi	a4,a4,-1
    80000ddc:	16fd                	addi	a3,a3,-1
    80000dde:	00074603          	lbu	a2,0(a4)
    80000de2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000de6:	fef71ae3          	bne	a4,a5,80000dda <memmove+0x4a>
    80000dea:	b7f1                	j	80000db6 <memmove+0x26>

0000000080000dec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e406                	sd	ra,8(sp)
    80000df0:	e022                	sd	s0,0(sp)
    80000df2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	f9c080e7          	jalr	-100(ra) # 80000d90 <memmove>
}
    80000dfc:	60a2                	ld	ra,8(sp)
    80000dfe:	6402                	ld	s0,0(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e0a:	ce11                	beqz	a2,80000e26 <strncmp+0x22>
    80000e0c:	00054783          	lbu	a5,0(a0)
    80000e10:	cf89                	beqz	a5,80000e2a <strncmp+0x26>
    80000e12:	0005c703          	lbu	a4,0(a1)
    80000e16:	00f71a63          	bne	a4,a5,80000e2a <strncmp+0x26>
    n--, p++, q++;
    80000e1a:	367d                	addiw	a2,a2,-1
    80000e1c:	0505                	addi	a0,a0,1
    80000e1e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e20:	f675                	bnez	a2,80000e0c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e22:	4501                	li	a0,0
    80000e24:	a801                	j	80000e34 <strncmp+0x30>
    80000e26:	4501                	li	a0,0
    80000e28:	a031                	j	80000e34 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000e2a:	00054503          	lbu	a0,0(a0)
    80000e2e:	0005c783          	lbu	a5,0(a1)
    80000e32:	9d1d                	subw	a0,a0,a5
}
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e422                	sd	s0,8(sp)
    80000e3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e40:	87aa                	mv	a5,a0
    80000e42:	86b2                	mv	a3,a2
    80000e44:	367d                	addiw	a2,a2,-1
    80000e46:	02d05563          	blez	a3,80000e70 <strncpy+0x36>
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	0005c703          	lbu	a4,0(a1)
    80000e50:	fee78fa3          	sb	a4,-1(a5)
    80000e54:	0585                	addi	a1,a1,1
    80000e56:	f775                	bnez	a4,80000e42 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e58:	873e                	mv	a4,a5
    80000e5a:	9fb5                	addw	a5,a5,a3
    80000e5c:	37fd                	addiw	a5,a5,-1
    80000e5e:	00c05963          	blez	a2,80000e70 <strncpy+0x36>
    *s++ = 0;
    80000e62:	0705                	addi	a4,a4,1
    80000e64:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e68:	40e786bb          	subw	a3,a5,a4
    80000e6c:	fed04be3          	bgtz	a3,80000e62 <strncpy+0x28>
  return os;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e7c:	02c05363          	blez	a2,80000ea2 <safestrcpy+0x2c>
    80000e80:	fff6069b          	addiw	a3,a2,-1
    80000e84:	1682                	slli	a3,a3,0x20
    80000e86:	9281                	srli	a3,a3,0x20
    80000e88:	96ae                	add	a3,a3,a1
    80000e8a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e8c:	00d58963          	beq	a1,a3,80000e9e <safestrcpy+0x28>
    80000e90:	0585                	addi	a1,a1,1
    80000e92:	0785                	addi	a5,a5,1
    80000e94:	fff5c703          	lbu	a4,-1(a1)
    80000e98:	fee78fa3          	sb	a4,-1(a5)
    80000e9c:	fb65                	bnez	a4,80000e8c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e9e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ea2:	6422                	ld	s0,8(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret

0000000080000ea8 <strlen>:

int
strlen(const char *s)
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eae:	00054783          	lbu	a5,0(a0)
    80000eb2:	cf91                	beqz	a5,80000ece <strlen+0x26>
    80000eb4:	0505                	addi	a0,a0,1
    80000eb6:	87aa                	mv	a5,a0
    80000eb8:	86be                	mv	a3,a5
    80000eba:	0785                	addi	a5,a5,1
    80000ebc:	fff7c703          	lbu	a4,-1(a5)
    80000ec0:	ff65                	bnez	a4,80000eb8 <strlen+0x10>
    80000ec2:	40a6853b          	subw	a0,a3,a0
    80000ec6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ec8:	6422                	ld	s0,8(sp)
    80000eca:	0141                	addi	sp,sp,16
    80000ecc:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ece:	4501                	li	a0,0
    80000ed0:	bfe5                	j	80000ec8 <strlen+0x20>

0000000080000ed2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ed2:	1141                	addi	sp,sp,-16
    80000ed4:	e406                	sd	ra,8(sp)
    80000ed6:	e022                	sd	s0,0(sp)
    80000ed8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eda:	00001097          	auipc	ra,0x1
    80000ede:	d8e080e7          	jalr	-626(ra) # 80001c68 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ee2:	0000a717          	auipc	a4,0xa
    80000ee6:	5c670713          	addi	a4,a4,1478 # 8000b4a8 <started>
  if(cpuid() == 0){
    80000eea:	c139                	beqz	a0,80000f30 <main+0x5e>
    while(started == 0)
    80000eec:	431c                	lw	a5,0(a4)
    80000eee:	2781                	sext.w	a5,a5
    80000ef0:	dff5                	beqz	a5,80000eec <main+0x1a>
      ;
    __sync_synchronize();
    80000ef2:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	d72080e7          	jalr	-654(ra) # 80001c68 <cpuid>
    80000efe:	85aa                	mv	a1,a0
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	19850513          	addi	a0,a0,408 # 80008098 <etext+0x98>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	6a2080e7          	jalr	1698(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	0d8080e7          	jalr	216(ra) # 80000fe8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f18:	00002097          	auipc	ra,0x2
    80000f1c:	c90080e7          	jalr	-880(ra) # 80002ba8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	3b4080e7          	jalr	948(ra) # 800062d4 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	3fc080e7          	jalr	1020(ra) # 80002324 <scheduler>
    consoleinit();
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	540080e7          	jalr	1344(ra) # 80000470 <consoleinit>
    printfinit();
    80000f38:	00000097          	auipc	ra,0x0
    80000f3c:	87a080e7          	jalr	-1926(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	0d050513          	addi	a0,a0,208 # 80008010 <etext+0x10>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	662080e7          	jalr	1634(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f50:	00007517          	auipc	a0,0x7
    80000f54:	13050513          	addi	a0,a0,304 # 80008080 <etext+0x80>
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	652080e7          	jalr	1618(ra) # 800005aa <printf>
    printf("\n");
    80000f60:	00007517          	auipc	a0,0x7
    80000f64:	0b050513          	addi	a0,a0,176 # 80008010 <etext+0x10>
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	642080e7          	jalr	1602(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	b9c080e7          	jalr	-1124(ra) # 80000b0c <kinit>
    kvminit();       // create kernel page table
    80000f78:	00000097          	auipc	ra,0x0
    80000f7c:	326080e7          	jalr	806(ra) # 8000129e <kvminit>
    kvminithart();   // turn on paging
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	068080e7          	jalr	104(ra) # 80000fe8 <kvminithart>
    procinit();      // process table
    80000f88:	00001097          	auipc	ra,0x1
    80000f8c:	bfa080e7          	jalr	-1030(ra) # 80001b82 <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	bf0080e7          	jalr	-1040(ra) # 80002b80 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	c10080e7          	jalr	-1008(ra) # 80002ba8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	31a080e7          	jalr	794(ra) # 800062ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	32c080e7          	jalr	812(ra) # 800062d4 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	3f0080e7          	jalr	1008(ra) # 800033a0 <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	aa6080e7          	jalr	-1370(ra) # 80003a5e <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	a56080e7          	jalr	-1450(ra) # 80004a16 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	414080e7          	jalr	1044(ra) # 800063dc <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	f9c080e7          	jalr	-100(ra) # 80001f6c <userinit>
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    started = 1;
    80000fdc:	4785                	li	a5,1
    80000fde:	0000a717          	auipc	a4,0xa
    80000fe2:	4cf72523          	sw	a5,1226(a4) # 8000b4a8 <started>
    80000fe6:	b789                	j	80000f28 <main+0x56>

0000000080000fe8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fe8:	1141                	addi	sp,sp,-16
    80000fea:	e422                	sd	s0,8(sp)
    80000fec:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fee:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ff2:	0000a797          	auipc	a5,0xa
    80000ff6:	4be7b783          	ld	a5,1214(a5) # 8000b4b0 <kernel_pagetable>
    80000ffa:	83b1                	srli	a5,a5,0xc
    80000ffc:	577d                	li	a4,-1
    80000ffe:	177e                	slli	a4,a4,0x3f
    80001000:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001002:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001006:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000100a:	6422                	ld	s0,8(sp)
    8000100c:	0141                	addi	sp,sp,16
    8000100e:	8082                	ret

0000000080001010 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001010:	7139                	addi	sp,sp,-64
    80001012:	fc06                	sd	ra,56(sp)
    80001014:	f822                	sd	s0,48(sp)
    80001016:	f426                	sd	s1,40(sp)
    80001018:	f04a                	sd	s2,32(sp)
    8000101a:	ec4e                	sd	s3,24(sp)
    8000101c:	e852                	sd	s4,16(sp)
    8000101e:	e456                	sd	s5,8(sp)
    80001020:	e05a                	sd	s6,0(sp)
    80001022:	0080                	addi	s0,sp,64
    80001024:	84aa                	mv	s1,a0
    80001026:	89ae                	mv	s3,a1
    80001028:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000102a:	57fd                	li	a5,-1
    8000102c:	83e9                	srli	a5,a5,0x1a
    8000102e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001030:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001032:	04b7f263          	bgeu	a5,a1,80001076 <walk+0x66>
    panic("walk");
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	07a50513          	addi	a0,a0,122 # 800080b0 <etext+0xb0>
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	522080e7          	jalr	1314(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001046:	060a8663          	beqz	s5,800010b2 <walk+0xa2>
    8000104a:	00000097          	auipc	ra,0x0
    8000104e:	afe080e7          	jalr	-1282(ra) # 80000b48 <kalloc>
    80001052:	84aa                	mv	s1,a0
    80001054:	c529                	beqz	a0,8000109e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001056:	6605                	lui	a2,0x1
    80001058:	4581                	li	a1,0
    8000105a:	00000097          	auipc	ra,0x0
    8000105e:	cda080e7          	jalr	-806(ra) # 80000d34 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001062:	00c4d793          	srli	a5,s1,0xc
    80001066:	07aa                	slli	a5,a5,0xa
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda4b7>
    80001072:	036a0063          	beq	s4,s6,80001092 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001076:	0149d933          	srl	s2,s3,s4
    8000107a:	1ff97913          	andi	s2,s2,511
    8000107e:	090e                	slli	s2,s2,0x3
    80001080:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001082:	00093483          	ld	s1,0(s2)
    80001086:	0014f793          	andi	a5,s1,1
    8000108a:	dfd5                	beqz	a5,80001046 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000108c:	80a9                	srli	s1,s1,0xa
    8000108e:	04b2                	slli	s1,s1,0xc
    80001090:	b7c5                	j	80001070 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001092:	00c9d513          	srli	a0,s3,0xc
    80001096:	1ff57513          	andi	a0,a0,511
    8000109a:	050e                	slli	a0,a0,0x3
    8000109c:	9526                	add	a0,a0,s1
}
    8000109e:	70e2                	ld	ra,56(sp)
    800010a0:	7442                	ld	s0,48(sp)
    800010a2:	74a2                	ld	s1,40(sp)
    800010a4:	7902                	ld	s2,32(sp)
    800010a6:	69e2                	ld	s3,24(sp)
    800010a8:	6a42                	ld	s4,16(sp)
    800010aa:	6aa2                	ld	s5,8(sp)
    800010ac:	6b02                	ld	s6,0(sp)
    800010ae:	6121                	addi	sp,sp,64
    800010b0:	8082                	ret
        return 0;
    800010b2:	4501                	li	a0,0
    800010b4:	b7ed                	j	8000109e <walk+0x8e>

00000000800010b6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010b6:	57fd                	li	a5,-1
    800010b8:	83e9                	srli	a5,a5,0x1a
    800010ba:	00b7f463          	bgeu	a5,a1,800010c2 <walkaddr+0xc>
    return 0;
    800010be:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010c0:	8082                	ret
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ca:	4601                	li	a2,0
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	f44080e7          	jalr	-188(ra) # 80001010 <walk>
  if(pte == 0)
    800010d4:	c105                	beqz	a0,800010f4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010d6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010d8:	0117f693          	andi	a3,a5,17
    800010dc:	4745                	li	a4,17
    return 0;
    800010de:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010e0:	00e68663          	beq	a3,a4,800010ec <walkaddr+0x36>
}
    800010e4:	60a2                	ld	ra,8(sp)
    800010e6:	6402                	ld	s0,0(sp)
    800010e8:	0141                	addi	sp,sp,16
    800010ea:	8082                	ret
  pa = PTE2PA(*pte);
    800010ec:	83a9                	srli	a5,a5,0xa
    800010ee:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010f2:	bfcd                	j	800010e4 <walkaddr+0x2e>
    return 0;
    800010f4:	4501                	li	a0,0
    800010f6:	b7fd                	j	800010e4 <walkaddr+0x2e>

00000000800010f8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010f8:	715d                	addi	sp,sp,-80
    800010fa:	e486                	sd	ra,72(sp)
    800010fc:	e0a2                	sd	s0,64(sp)
    800010fe:	fc26                	sd	s1,56(sp)
    80001100:	f84a                	sd	s2,48(sp)
    80001102:	f44e                	sd	s3,40(sp)
    80001104:	f052                	sd	s4,32(sp)
    80001106:	ec56                	sd	s5,24(sp)
    80001108:	e85a                	sd	s6,16(sp)
    8000110a:	e45e                	sd	s7,8(sp)
    8000110c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000110e:	c639                	beqz	a2,8000115c <mappages+0x64>
    80001110:	8aaa                	mv	s5,a0
    80001112:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001114:	777d                	lui	a4,0xfffff
    80001116:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000111a:	fff58993          	addi	s3,a1,-1
    8000111e:	99b2                	add	s3,s3,a2
    80001120:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001124:	893e                	mv	s2,a5
    80001126:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000112a:	6b85                	lui	s7,0x1
    8000112c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001130:	4605                	li	a2,1
    80001132:	85ca                	mv	a1,s2
    80001134:	8556                	mv	a0,s5
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	eda080e7          	jalr	-294(ra) # 80001010 <walk>
    8000113e:	cd1d                	beqz	a0,8000117c <mappages+0x84>
    if(*pte & PTE_V)
    80001140:	611c                	ld	a5,0(a0)
    80001142:	8b85                	andi	a5,a5,1
    80001144:	e785                	bnez	a5,8000116c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001146:	80b1                	srli	s1,s1,0xc
    80001148:	04aa                	slli	s1,s1,0xa
    8000114a:	0164e4b3          	or	s1,s1,s6
    8000114e:	0014e493          	ori	s1,s1,1
    80001152:	e104                	sd	s1,0(a0)
    if(a == last)
    80001154:	05390063          	beq	s2,s3,80001194 <mappages+0x9c>
    a += PGSIZE;
    80001158:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115a:	bfc9                	j	8000112c <mappages+0x34>
    panic("mappages: size");
    8000115c:	00007517          	auipc	a0,0x7
    80001160:	f5c50513          	addi	a0,a0,-164 # 800080b8 <etext+0xb8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3fc080e7          	jalr	1020(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	f5c50513          	addi	a0,a0,-164 # 800080c8 <etext+0xc8>
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	3ec080e7          	jalr	1004(ra) # 80000560 <panic>
      return -1;
    8000117c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000117e:	60a6                	ld	ra,72(sp)
    80001180:	6406                	ld	s0,64(sp)
    80001182:	74e2                	ld	s1,56(sp)
    80001184:	7942                	ld	s2,48(sp)
    80001186:	79a2                	ld	s3,40(sp)
    80001188:	7a02                	ld	s4,32(sp)
    8000118a:	6ae2                	ld	s5,24(sp)
    8000118c:	6b42                	ld	s6,16(sp)
    8000118e:	6ba2                	ld	s7,8(sp)
    80001190:	6161                	addi	sp,sp,80
    80001192:	8082                	ret
  return 0;
    80001194:	4501                	li	a0,0
    80001196:	b7e5                	j	8000117e <mappages+0x86>

0000000080001198 <kvmmap>:
{
    80001198:	1141                	addi	sp,sp,-16
    8000119a:	e406                	sd	ra,8(sp)
    8000119c:	e022                	sd	s0,0(sp)
    8000119e:	0800                	addi	s0,sp,16
    800011a0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011a2:	86b2                	mv	a3,a2
    800011a4:	863e                	mv	a2,a5
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	f52080e7          	jalr	-174(ra) # 800010f8 <mappages>
    800011ae:	e509                	bnez	a0,800011b8 <kvmmap+0x20>
}
    800011b0:	60a2                	ld	ra,8(sp)
    800011b2:	6402                	ld	s0,0(sp)
    800011b4:	0141                	addi	sp,sp,16
    800011b6:	8082                	ret
    panic("kvmmap");
    800011b8:	00007517          	auipc	a0,0x7
    800011bc:	f2050513          	addi	a0,a0,-224 # 800080d8 <etext+0xd8>
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	3a0080e7          	jalr	928(ra) # 80000560 <panic>

00000000800011c8 <kvmmake>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	974080e7          	jalr	-1676(ra) # 80000b48 <kalloc>
    800011dc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011de:	6605                	lui	a2,0x1
    800011e0:	4581                	li	a1,0
    800011e2:	00000097          	auipc	ra,0x0
    800011e6:	b52080e7          	jalr	-1198(ra) # 80000d34 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011ea:	4719                	li	a4,6
    800011ec:	6685                	lui	a3,0x1
    800011ee:	10000637          	lui	a2,0x10000
    800011f2:	100005b7          	lui	a1,0x10000
    800011f6:	8526                	mv	a0,s1
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	fa0080e7          	jalr	-96(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001200:	4719                	li	a4,6
    80001202:	6685                	lui	a3,0x1
    80001204:	10001637          	lui	a2,0x10001
    80001208:	100015b7          	lui	a1,0x10001
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f8a080e7          	jalr	-118(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001216:	4719                	li	a4,6
    80001218:	004006b7          	lui	a3,0x400
    8000121c:	0c000637          	lui	a2,0xc000
    80001220:	0c0005b7          	lui	a1,0xc000
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f72080e7          	jalr	-142(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000122e:	00007917          	auipc	s2,0x7
    80001232:	dd290913          	addi	s2,s2,-558 # 80008000 <etext>
    80001236:	4729                	li	a4,10
    80001238:	80007697          	auipc	a3,0x80007
    8000123c:	dc868693          	addi	a3,a3,-568 # 8000 <_entry-0x7fff8000>
    80001240:	4605                	li	a2,1
    80001242:	067e                	slli	a2,a2,0x1f
    80001244:	85b2                	mv	a1,a2
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f50080e7          	jalr	-176(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001250:	46c5                	li	a3,17
    80001252:	06ee                	slli	a3,a3,0x1b
    80001254:	4719                	li	a4,6
    80001256:	412686b3          	sub	a3,a3,s2
    8000125a:	864a                	mv	a2,s2
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8526                	mv	a0,s1
    80001260:	00000097          	auipc	ra,0x0
    80001264:	f38080e7          	jalr	-200(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001268:	4729                	li	a4,10
    8000126a:	6685                	lui	a3,0x1
    8000126c:	00006617          	auipc	a2,0x6
    80001270:	d9460613          	addi	a2,a2,-620 # 80007000 <_trampoline>
    80001274:	040005b7          	lui	a1,0x4000
    80001278:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000127a:	05b2                	slli	a1,a1,0xc
    8000127c:	8526                	mv	a0,s1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	f1a080e7          	jalr	-230(ra) # 80001198 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001286:	8526                	mv	a0,s1
    80001288:	00001097          	auipc	ra,0x1
    8000128c:	856080e7          	jalr	-1962(ra) # 80001ade <proc_mapstacks>
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6902                	ld	s2,0(sp)
    8000129a:	6105                	addi	sp,sp,32
    8000129c:	8082                	ret

000000008000129e <kvminit>:
{
    8000129e:	1141                	addi	sp,sp,-16
    800012a0:	e406                	sd	ra,8(sp)
    800012a2:	e022                	sd	s0,0(sp)
    800012a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f22080e7          	jalr	-222(ra) # 800011c8 <kvmmake>
    800012ae:	0000a797          	auipc	a5,0xa
    800012b2:	20a7b123          	sd	a0,514(a5) # 8000b4b0 <kernel_pagetable>
}
    800012b6:	60a2                	ld	ra,8(sp)
    800012b8:	6402                	ld	s0,0(sp)
    800012ba:	0141                	addi	sp,sp,16
    800012bc:	8082                	ret

00000000800012be <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012be:	715d                	addi	sp,sp,-80
    800012c0:	e486                	sd	ra,72(sp)
    800012c2:	e0a2                	sd	s0,64(sp)
    800012c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c6:	03459793          	slli	a5,a1,0x34
    800012ca:	e39d                	bnez	a5,800012f0 <uvmunmap+0x32>
    800012cc:	f84a                	sd	s2,48(sp)
    800012ce:	f44e                	sd	s3,40(sp)
    800012d0:	f052                	sd	s4,32(sp)
    800012d2:	ec56                	sd	s5,24(sp)
    800012d4:	e85a                	sd	s6,16(sp)
    800012d6:	e45e                	sd	s7,8(sp)
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012de:	0632                	slli	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e6:	6b05                	lui	s6,0x1
    800012e8:	0935fb63          	bgeu	a1,s3,8000137e <uvmunmap+0xc0>
    800012ec:	fc26                	sd	s1,56(sp)
    800012ee:	a8a9                	j	80001348 <uvmunmap+0x8a>
    800012f0:	fc26                	sd	s1,56(sp)
    800012f2:	f84a                	sd	s2,48(sp)
    800012f4:	f44e                	sd	s3,40(sp)
    800012f6:	f052                	sd	s4,32(sp)
    800012f8:	ec56                	sd	s5,24(sp)
    800012fa:	e85a                	sd	s6,16(sp)
    800012fc:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800012fe:	00007517          	auipc	a0,0x7
    80001302:	de250513          	addi	a0,a0,-542 # 800080e0 <etext+0xe0>
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	25a080e7          	jalr	602(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	dea50513          	addi	a0,a0,-534 # 800080f8 <etext+0xf8>
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	24a080e7          	jalr	586(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000131e:	00007517          	auipc	a0,0x7
    80001322:	dea50513          	addi	a0,a0,-534 # 80008108 <etext+0x108>
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	23a080e7          	jalr	570(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	df250513          	addi	a0,a0,-526 # 80008120 <etext+0x120>
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	22a080e7          	jalr	554(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000133e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001342:	995a                	add	s2,s2,s6
    80001344:	03397c63          	bgeu	s2,s3,8000137c <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001348:	4601                	li	a2,0
    8000134a:	85ca                	mv	a1,s2
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	cc2080e7          	jalr	-830(ra) # 80001010 <walk>
    80001356:	84aa                	mv	s1,a0
    80001358:	d95d                	beqz	a0,8000130e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000135a:	6108                	ld	a0,0(a0)
    8000135c:	00157793          	andi	a5,a0,1
    80001360:	dfdd                	beqz	a5,8000131e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001362:	3ff57793          	andi	a5,a0,1023
    80001366:	fd7784e3          	beq	a5,s7,8000132e <uvmunmap+0x70>
    if(do_free){
    8000136a:	fc0a8ae3          	beqz	s5,8000133e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000136e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001370:	0532                	slli	a0,a0,0xc
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	6d8080e7          	jalr	1752(ra) # 80000a4a <kfree>
    8000137a:	b7d1                	j	8000133e <uvmunmap+0x80>
    8000137c:	74e2                	ld	s1,56(sp)
    8000137e:	7942                	ld	s2,48(sp)
    80001380:	79a2                	ld	s3,40(sp)
    80001382:	7a02                	ld	s4,32(sp)
    80001384:	6ae2                	ld	s5,24(sp)
    80001386:	6b42                	ld	s6,16(sp)
    80001388:	6ba2                	ld	s7,8(sp)
  }
}
    8000138a:	60a6                	ld	ra,72(sp)
    8000138c:	6406                	ld	s0,64(sp)
    8000138e:	6161                	addi	sp,sp,80
    80001390:	8082                	ret

0000000080001392 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001392:	1101                	addi	sp,sp,-32
    80001394:	ec06                	sd	ra,24(sp)
    80001396:	e822                	sd	s0,16(sp)
    80001398:	e426                	sd	s1,8(sp)
    8000139a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	7ac080e7          	jalr	1964(ra) # 80000b48 <kalloc>
    800013a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013a6:	c519                	beqz	a0,800013b4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013a8:	6605                	lui	a2,0x1
    800013aa:	4581                	li	a1,0
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	988080e7          	jalr	-1656(ra) # 80000d34 <memset>
  return pagetable;
}
    800013b4:	8526                	mv	a0,s1
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret

00000000800013c0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013c0:	7179                	addi	sp,sp,-48
    800013c2:	f406                	sd	ra,40(sp)
    800013c4:	f022                	sd	s0,32(sp)
    800013c6:	ec26                	sd	s1,24(sp)
    800013c8:	e84a                	sd	s2,16(sp)
    800013ca:	e44e                	sd	s3,8(sp)
    800013cc:	e052                	sd	s4,0(sp)
    800013ce:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013d0:	6785                	lui	a5,0x1
    800013d2:	04f67863          	bgeu	a2,a5,80001422 <uvmfirst+0x62>
    800013d6:	8a2a                	mv	s4,a0
    800013d8:	89ae                	mv	s3,a1
    800013da:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	76c080e7          	jalr	1900(ra) # 80000b48 <kalloc>
    800013e4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013e6:	6605                	lui	a2,0x1
    800013e8:	4581                	li	a1,0
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	94a080e7          	jalr	-1718(ra) # 80000d34 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013f2:	4779                	li	a4,30
    800013f4:	86ca                	mv	a3,s2
    800013f6:	6605                	lui	a2,0x1
    800013f8:	4581                	li	a1,0
    800013fa:	8552                	mv	a0,s4
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	cfc080e7          	jalr	-772(ra) # 800010f8 <mappages>
  memmove(mem, src, sz);
    80001404:	8626                	mv	a2,s1
    80001406:	85ce                	mv	a1,s3
    80001408:	854a                	mv	a0,s2
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	986080e7          	jalr	-1658(ra) # 80000d90 <memmove>
}
    80001412:	70a2                	ld	ra,40(sp)
    80001414:	7402                	ld	s0,32(sp)
    80001416:	64e2                	ld	s1,24(sp)
    80001418:	6942                	ld	s2,16(sp)
    8000141a:	69a2                	ld	s3,8(sp)
    8000141c:	6a02                	ld	s4,0(sp)
    8000141e:	6145                	addi	sp,sp,48
    80001420:	8082                	ret
    panic("uvmfirst: more than a page");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	d1650513          	addi	a0,a0,-746 # 80008138 <etext+0x138>
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	136080e7          	jalr	310(ra) # 80000560 <panic>

0000000080001432 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001432:	1101                	addi	sp,sp,-32
    80001434:	ec06                	sd	ra,24(sp)
    80001436:	e822                	sd	s0,16(sp)
    80001438:	e426                	sd	s1,8(sp)
    8000143a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000143c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000143e:	00b67d63          	bgeu	a2,a1,80001458 <uvmdealloc+0x26>
    80001442:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001444:	6785                	lui	a5,0x1
    80001446:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001448:	00f60733          	add	a4,a2,a5
    8000144c:	76fd                	lui	a3,0xfffff
    8000144e:	8f75                	and	a4,a4,a3
    80001450:	97ae                	add	a5,a5,a1
    80001452:	8ff5                	and	a5,a5,a3
    80001454:	00f76863          	bltu	a4,a5,80001464 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001458:	8526                	mv	a0,s1
    8000145a:	60e2                	ld	ra,24(sp)
    8000145c:	6442                	ld	s0,16(sp)
    8000145e:	64a2                	ld	s1,8(sp)
    80001460:	6105                	addi	sp,sp,32
    80001462:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001464:	8f99                	sub	a5,a5,a4
    80001466:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001468:	4685                	li	a3,1
    8000146a:	0007861b          	sext.w	a2,a5
    8000146e:	85ba                	mv	a1,a4
    80001470:	00000097          	auipc	ra,0x0
    80001474:	e4e080e7          	jalr	-434(ra) # 800012be <uvmunmap>
    80001478:	b7c5                	j	80001458 <uvmdealloc+0x26>

000000008000147a <uvmalloc>:
  if(newsz < oldsz)
    8000147a:	0ab66b63          	bltu	a2,a1,80001530 <uvmalloc+0xb6>
{
    8000147e:	7139                	addi	sp,sp,-64
    80001480:	fc06                	sd	ra,56(sp)
    80001482:	f822                	sd	s0,48(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e852                	sd	s4,16(sp)
    80001488:	e456                	sd	s5,8(sp)
    8000148a:	0080                	addi	s0,sp,64
    8000148c:	8aaa                	mv	s5,a0
    8000148e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	77fd                	lui	a5,0xfffff
    80001498:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000149c:	08c9fc63          	bgeu	s3,a2,80001534 <uvmalloc+0xba>
    800014a0:	f426                	sd	s1,40(sp)
    800014a2:	f04a                	sd	s2,32(sp)
    800014a4:	e05a                	sd	s6,0(sp)
    800014a6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014a8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014ac:	fffff097          	auipc	ra,0xfffff
    800014b0:	69c080e7          	jalr	1692(ra) # 80000b48 <kalloc>
    800014b4:	84aa                	mv	s1,a0
    if(mem == 0){
    800014b6:	c915                	beqz	a0,800014ea <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800014b8:	6605                	lui	a2,0x1
    800014ba:	4581                	li	a1,0
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	878080e7          	jalr	-1928(ra) # 80000d34 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014c4:	875a                	mv	a4,s6
    800014c6:	86a6                	mv	a3,s1
    800014c8:	6605                	lui	a2,0x1
    800014ca:	85ca                	mv	a1,s2
    800014cc:	8556                	mv	a0,s5
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	c2a080e7          	jalr	-982(ra) # 800010f8 <mappages>
    800014d6:	ed05                	bnez	a0,8000150e <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d8:	6785                	lui	a5,0x1
    800014da:	993e                	add	s2,s2,a5
    800014dc:	fd4968e3          	bltu	s2,s4,800014ac <uvmalloc+0x32>
  return newsz;
    800014e0:	8552                	mv	a0,s4
    800014e2:	74a2                	ld	s1,40(sp)
    800014e4:	7902                	ld	s2,32(sp)
    800014e6:	6b02                	ld	s6,0(sp)
    800014e8:	a821                	j	80001500 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800014ea:	864e                	mv	a2,s3
    800014ec:	85ca                	mv	a1,s2
    800014ee:	8556                	mv	a0,s5
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f42080e7          	jalr	-190(ra) # 80001432 <uvmdealloc>
      return 0;
    800014f8:	4501                	li	a0,0
    800014fa:	74a2                	ld	s1,40(sp)
    800014fc:	7902                	ld	s2,32(sp)
    800014fe:	6b02                	ld	s6,0(sp)
}
    80001500:	70e2                	ld	ra,56(sp)
    80001502:	7442                	ld	s0,48(sp)
    80001504:	69e2                	ld	s3,24(sp)
    80001506:	6a42                	ld	s4,16(sp)
    80001508:	6aa2                	ld	s5,8(sp)
    8000150a:	6121                	addi	sp,sp,64
    8000150c:	8082                	ret
      kfree(mem);
    8000150e:	8526                	mv	a0,s1
    80001510:	fffff097          	auipc	ra,0xfffff
    80001514:	53a080e7          	jalr	1338(ra) # 80000a4a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001518:	864e                	mv	a2,s3
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f14080e7          	jalr	-236(ra) # 80001432 <uvmdealloc>
      return 0;
    80001526:	4501                	li	a0,0
    80001528:	74a2                	ld	s1,40(sp)
    8000152a:	7902                	ld	s2,32(sp)
    8000152c:	6b02                	ld	s6,0(sp)
    8000152e:	bfc9                	j	80001500 <uvmalloc+0x86>
    return oldsz;
    80001530:	852e                	mv	a0,a1
}
    80001532:	8082                	ret
  return newsz;
    80001534:	8532                	mv	a0,a2
    80001536:	b7e9                	j	80001500 <uvmalloc+0x86>

0000000080001538 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001538:	7179                	addi	sp,sp,-48
    8000153a:	f406                	sd	ra,40(sp)
    8000153c:	f022                	sd	s0,32(sp)
    8000153e:	ec26                	sd	s1,24(sp)
    80001540:	e84a                	sd	s2,16(sp)
    80001542:	e44e                	sd	s3,8(sp)
    80001544:	e052                	sd	s4,0(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000154a:	84aa                	mv	s1,a0
    8000154c:	6905                	lui	s2,0x1
    8000154e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001550:	4985                	li	s3,1
    80001552:	a829                	j	8000156c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001554:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001556:	00c79513          	slli	a0,a5,0xc
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	fde080e7          	jalr	-34(ra) # 80001538 <freewalk>
      pagetable[i] = 0;
    80001562:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001566:	04a1                	addi	s1,s1,8
    80001568:	03248163          	beq	s1,s2,8000158a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000156c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000156e:	00f7f713          	andi	a4,a5,15
    80001572:	ff3701e3          	beq	a4,s3,80001554 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001576:	8b85                	andi	a5,a5,1
    80001578:	d7fd                	beqz	a5,80001566 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000157a:	00007517          	auipc	a0,0x7
    8000157e:	bde50513          	addi	a0,a0,-1058 # 80008158 <etext+0x158>
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	fde080e7          	jalr	-34(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000158a:	8552                	mv	a0,s4
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	4be080e7          	jalr	1214(ra) # 80000a4a <kfree>
}
    80001594:	70a2                	ld	ra,40(sp)
    80001596:	7402                	ld	s0,32(sp)
    80001598:	64e2                	ld	s1,24(sp)
    8000159a:	6942                	ld	s2,16(sp)
    8000159c:	69a2                	ld	s3,8(sp)
    8000159e:	6a02                	ld	s4,0(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret

00000000800015a4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015a4:	1101                	addi	sp,sp,-32
    800015a6:	ec06                	sd	ra,24(sp)
    800015a8:	e822                	sd	s0,16(sp)
    800015aa:	e426                	sd	s1,8(sp)
    800015ac:	1000                	addi	s0,sp,32
    800015ae:	84aa                	mv	s1,a0
  if(sz > 0)
    800015b0:	e999                	bnez	a1,800015c6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015b2:	8526                	mv	a0,s1
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	f84080e7          	jalr	-124(ra) # 80001538 <freewalk>
}
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6105                	addi	sp,sp,32
    800015c4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015c6:	6785                	lui	a5,0x1
    800015c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ca:	95be                	add	a1,a1,a5
    800015cc:	4685                	li	a3,1
    800015ce:	00c5d613          	srli	a2,a1,0xc
    800015d2:	4581                	li	a1,0
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	cea080e7          	jalr	-790(ra) # 800012be <uvmunmap>
    800015dc:	bfd9                	j	800015b2 <uvmfree+0xe>

00000000800015de <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015de:	c679                	beqz	a2,800016ac <uvmcopy+0xce>
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	0880                	addi	s0,sp,80
    800015f6:	8b2a                	mv	s6,a0
    800015f8:	8aae                	mv	s5,a1
    800015fa:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015fc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015fe:	4601                	li	a2,0
    80001600:	85ce                	mv	a1,s3
    80001602:	855a                	mv	a0,s6
    80001604:	00000097          	auipc	ra,0x0
    80001608:	a0c080e7          	jalr	-1524(ra) # 80001010 <walk>
    8000160c:	c531                	beqz	a0,80001658 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000160e:	6118                	ld	a4,0(a0)
    80001610:	00177793          	andi	a5,a4,1
    80001614:	cbb1                	beqz	a5,80001668 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001616:	00a75593          	srli	a1,a4,0xa
    8000161a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000161e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	526080e7          	jalr	1318(ra) # 80000b48 <kalloc>
    8000162a:	892a                	mv	s2,a0
    8000162c:	c939                	beqz	a0,80001682 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162e:	6605                	lui	a2,0x1
    80001630:	85de                	mv	a1,s7
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	75e080e7          	jalr	1886(ra) # 80000d90 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000163a:	8726                	mv	a4,s1
    8000163c:	86ca                	mv	a3,s2
    8000163e:	6605                	lui	a2,0x1
    80001640:	85ce                	mv	a1,s3
    80001642:	8556                	mv	a0,s5
    80001644:	00000097          	auipc	ra,0x0
    80001648:	ab4080e7          	jalr	-1356(ra) # 800010f8 <mappages>
    8000164c:	e515                	bnez	a0,80001678 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000164e:	6785                	lui	a5,0x1
    80001650:	99be                	add	s3,s3,a5
    80001652:	fb49e6e3          	bltu	s3,s4,800015fe <uvmcopy+0x20>
    80001656:	a081                	j	80001696 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b1050513          	addi	a0,a0,-1264 # 80008168 <etext+0x168>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	b2050513          	addi	a0,a0,-1248 # 80008188 <etext+0x188>
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
      kfree(mem);
    80001678:	854a                	mv	a0,s2
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	3d0080e7          	jalr	976(ra) # 80000a4a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001682:	4685                	li	a3,1
    80001684:	00c9d613          	srli	a2,s3,0xc
    80001688:	4581                	li	a1,0
    8000168a:	8556                	mv	a0,s5
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	c32080e7          	jalr	-974(ra) # 800012be <uvmunmap>
  return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6161                	addi	sp,sp,80
    800016aa:	8082                	ret
  return 0;
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret

00000000800016b0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016b0:	1141                	addi	sp,sp,-16
    800016b2:	e406                	sd	ra,8(sp)
    800016b4:	e022                	sd	s0,0(sp)
    800016b6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016b8:	4601                	li	a2,0
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	956080e7          	jalr	-1706(ra) # 80001010 <walk>
  if(pte == 0)
    800016c2:	c901                	beqz	a0,800016d2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016c4:	611c                	ld	a5,0(a0)
    800016c6:	9bbd                	andi	a5,a5,-17
    800016c8:	e11c                	sd	a5,0(a0)
}
    800016ca:	60a2                	ld	ra,8(sp)
    800016cc:	6402                	ld	s0,0(sp)
    800016ce:	0141                	addi	sp,sp,16
    800016d0:	8082                	ret
    panic("uvmclear");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	ad650513          	addi	a0,a0,-1322 # 800081a8 <etext+0x1a8>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e86080e7          	jalr	-378(ra) # 80000560 <panic>

00000000800016e2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e2:	c6bd                	beqz	a3,80001750 <copyout+0x6e>
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8b2a                	mv	s6,a0
    800016fe:	8c2e                	mv	s8,a1
    80001700:	8a32                	mv	s4,a2
    80001702:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001704:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001706:	6a85                	lui	s5,0x1
    80001708:	a015                	j	8000172c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000170a:	9562                	add	a0,a0,s8
    8000170c:	0004861b          	sext.w	a2,s1
    80001710:	85d2                	mv	a1,s4
    80001712:	41250533          	sub	a0,a0,s2
    80001716:	fffff097          	auipc	ra,0xfffff
    8000171a:	67a080e7          	jalr	1658(ra) # 80000d90 <memmove>

    len -= n;
    8000171e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001722:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001724:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001728:	02098263          	beqz	s3,8000174c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000172c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001730:	85ca                	mv	a1,s2
    80001732:	855a                	mv	a0,s6
    80001734:	00000097          	auipc	ra,0x0
    80001738:	982080e7          	jalr	-1662(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    8000173c:	cd01                	beqz	a0,80001754 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000173e:	418904b3          	sub	s1,s2,s8
    80001742:	94d6                	add	s1,s1,s5
    if(n > len)
    80001744:	fc99f3e3          	bgeu	s3,s1,8000170a <copyout+0x28>
    80001748:	84ce                	mv	s1,s3
    8000174a:	b7c1                	j	8000170a <copyout+0x28>
  }
  return 0;
    8000174c:	4501                	li	a0,0
    8000174e:	a021                	j	80001756 <copyout+0x74>
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret
      return -1;
    80001754:	557d                	li	a0,-1
}
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6c02                	ld	s8,0(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret

000000008000176e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000176e:	caa5                	beqz	a3,800017de <copyin+0x70>
{
    80001770:	715d                	addi	sp,sp,-80
    80001772:	e486                	sd	ra,72(sp)
    80001774:	e0a2                	sd	s0,64(sp)
    80001776:	fc26                	sd	s1,56(sp)
    80001778:	f84a                	sd	s2,48(sp)
    8000177a:	f44e                	sd	s3,40(sp)
    8000177c:	f052                	sd	s4,32(sp)
    8000177e:	ec56                	sd	s5,24(sp)
    80001780:	e85a                	sd	s6,16(sp)
    80001782:	e45e                	sd	s7,8(sp)
    80001784:	e062                	sd	s8,0(sp)
    80001786:	0880                	addi	s0,sp,80
    80001788:	8b2a                	mv	s6,a0
    8000178a:	8a2e                	mv	s4,a1
    8000178c:	8c32                	mv	s8,a2
    8000178e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001790:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001792:	6a85                	lui	s5,0x1
    80001794:	a01d                	j	800017ba <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001796:	018505b3          	add	a1,a0,s8
    8000179a:	0004861b          	sext.w	a2,s1
    8000179e:	412585b3          	sub	a1,a1,s2
    800017a2:	8552                	mv	a0,s4
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	5ec080e7          	jalr	1516(ra) # 80000d90 <memmove>

    len -= n;
    800017ac:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017b0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017b2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017b6:	02098263          	beqz	s3,800017da <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017ba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017be:	85ca                	mv	a1,s2
    800017c0:	855a                	mv	a0,s6
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	8f4080e7          	jalr	-1804(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    800017ca:	cd01                	beqz	a0,800017e2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017cc:	418904b3          	sub	s1,s2,s8
    800017d0:	94d6                	add	s1,s1,s5
    if(n > len)
    800017d2:	fc99f2e3          	bgeu	s3,s1,80001796 <copyin+0x28>
    800017d6:	84ce                	mv	s1,s3
    800017d8:	bf7d                	j	80001796 <copyin+0x28>
  }
  return 0;
    800017da:	4501                	li	a0,0
    800017dc:	a021                	j	800017e4 <copyin+0x76>
    800017de:	4501                	li	a0,0
}
    800017e0:	8082                	ret
      return -1;
    800017e2:	557d                	li	a0,-1
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6c02                	ld	s8,0(sp)
    800017f8:	6161                	addi	sp,sp,80
    800017fa:	8082                	ret

00000000800017fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017fc:	cacd                	beqz	a3,800018ae <copyinstr+0xb2>
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	0880                	addi	s0,sp,80
    80001814:	8a2a                	mv	s4,a0
    80001816:	8b2e                	mv	s6,a1
    80001818:	8bb2                	mv	s7,a2
    8000181a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000181c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000181e:	6985                	lui	s3,0x1
    80001820:	a825                	j	80001858 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001822:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001826:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001828:	37fd                	addiw	a5,a5,-1
    8000182a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000182e:	60a6                	ld	ra,72(sp)
    80001830:	6406                	ld	s0,64(sp)
    80001832:	74e2                	ld	s1,56(sp)
    80001834:	7942                	ld	s2,48(sp)
    80001836:	79a2                	ld	s3,40(sp)
    80001838:	7a02                	ld	s4,32(sp)
    8000183a:	6ae2                	ld	s5,24(sp)
    8000183c:	6b42                	ld	s6,16(sp)
    8000183e:	6ba2                	ld	s7,8(sp)
    80001840:	6161                	addi	sp,sp,80
    80001842:	8082                	ret
    80001844:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001848:	9742                	add	a4,a4,a6
      --max;
    8000184a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000184e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001852:	04e58663          	beq	a1,a4,8000189e <copyinstr+0xa2>
{
    80001856:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001858:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000185c:	85a6                	mv	a1,s1
    8000185e:	8552                	mv	a0,s4
    80001860:	00000097          	auipc	ra,0x0
    80001864:	856080e7          	jalr	-1962(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    80001868:	cd0d                	beqz	a0,800018a2 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    8000186a:	417486b3          	sub	a3,s1,s7
    8000186e:	96ce                	add	a3,a3,s3
    if(n > max)
    80001870:	00d97363          	bgeu	s2,a3,80001876 <copyinstr+0x7a>
    80001874:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001876:	955e                	add	a0,a0,s7
    80001878:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000187a:	c695                	beqz	a3,800018a6 <copyinstr+0xaa>
    8000187c:	87da                	mv	a5,s6
    8000187e:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001880:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001884:	96da                	add	a3,a3,s6
    80001886:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001888:	00f60733          	add	a4,a2,a5
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda4c0>
    80001890:	db49                	beqz	a4,80001822 <copyinstr+0x26>
        *dst = *p;
    80001892:	00e78023          	sb	a4,0(a5)
      dst++;
    80001896:	0785                	addi	a5,a5,1
    while(n > 0){
    80001898:	fed797e3          	bne	a5,a3,80001886 <copyinstr+0x8a>
    8000189c:	b765                	j	80001844 <copyinstr+0x48>
    8000189e:	4781                	li	a5,0
    800018a0:	b761                	j	80001828 <copyinstr+0x2c>
      return -1;
    800018a2:	557d                	li	a0,-1
    800018a4:	b769                	j	8000182e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800018a6:	6b85                	lui	s7,0x1
    800018a8:	9ba6                	add	s7,s7,s1
    800018aa:	87da                	mv	a5,s6
    800018ac:	b76d                	j	80001856 <copyinstr+0x5a>
  int got_null = 0;
    800018ae:	4781                	li	a5,0
  if(got_null){
    800018b0:	37fd                	addiw	a5,a5,-1
    800018b2:	0007851b          	sext.w	a0,a5
}
    800018b6:	8082                	ret

00000000800018b8 <mlfq_scheduler>:
    }
}
#define NQUEUES 3
#define BOOST_INTERVAL 100
void mlfq_scheduler(void)
{
    800018b8:	7159                	addi	sp,sp,-112
    800018ba:	f486                	sd	ra,104(sp)
    800018bc:	f0a2                	sd	s0,96(sp)
    800018be:	eca6                	sd	s1,88(sp)
    800018c0:	e8ca                	sd	s2,80(sp)
    800018c2:	e4ce                	sd	s3,72(sp)
    800018c4:	e0d2                	sd	s4,64(sp)
    800018c6:	fc56                	sd	s5,56(sp)
    800018c8:	f85a                	sd	s6,48(sp)
    800018ca:	f45e                	sd	s7,40(sp)
    800018cc:	f062                	sd	s8,32(sp)
    800018ce:	ec66                	sd	s9,24(sp)
    800018d0:	e86a                	sd	s10,16(sp)
    800018d2:	1880                	addi	s0,sp,112
  asm volatile("mv %0, tp" : "=r" (x) );
    800018d4:	8792                	mv	a5,tp
    int id = r_tp();
    800018d6:	2781                	sext.w	a5,a5
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
    800018d8:	00012c17          	auipc	s8,0x12
    800018dc:	e58c0c13          	addi	s8,s8,-424 # 80013730 <cpus>
    800018e0:	00779713          	slli	a4,a5,0x7
    800018e4:	00ec06b3          	add	a3,s8,a4
    800018e8:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffda4c0>

  int slices[NQUEUES] = {4, 8, 16};
    800018ec:	4691                	li	a3,4
    800018ee:	f8d42823          	sw	a3,-112(s0)
    800018f2:	46a1                	li	a3,8
    800018f4:	f8d42a23          	sw	a3,-108(s0)
    800018f8:	46c1                	li	a3,16
    800018fa:	f8d42c23          	sw	a3,-104(s0)
    }

    if(best){//Context switch
      best->state = RUNNING;
      c->proc = best;
      swtch(&c->context, &best->context);
    800018fe:	0721                	addi	a4,a4,8
    80001900:	9c3a                	add	s8,s8,a4
    if(ticks % BOOST_INTERVAL == 0){//promote
    80001902:	0000ab17          	auipc	s6,0xa
    80001906:	bbeb0b13          	addi	s6,s6,-1090 # 8000b4c0 <ticks>
      for(p = proc; p < &proc[NPROC]; p++){
    8000190a:	00018917          	auipc	s2,0x18
    8000190e:	e5690913          	addi	s2,s2,-426 # 80019760 <tickslock>
    80001912:	4a81                	li	s5,0
      c->proc = best;
    80001914:	079e                	slli	a5,a5,0x7
    80001916:	00012b97          	auipc	s7,0x12
    8000191a:	e1ab8b93          	addi	s7,s7,-486 # 80013730 <cpus>
    8000191e:	9bbe                	add	s7,s7,a5
    80001920:	a8fd                	j	80001a1e <mlfq_scheduler+0x166>
      for(p = proc; p < &proc[NPROC]; p++){
    80001922:	00012497          	auipc	s1,0x12
    80001926:	23e48493          	addi	s1,s1,574 # 80013b60 <proc>
    8000192a:	a811                	j	8000193e <mlfq_scheduler+0x86>
        release(&p->lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	3be080e7          	jalr	958(ra) # 80000cec <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001936:	17048493          	addi	s1,s1,368
    8000193a:	09248163          	beq	s1,s2,800019bc <mlfq_scheduler+0x104>
        acquire(&p->lock);
    8000193e:	8526                	mv	a0,s1
    80001940:	fffff097          	auipc	ra,0xfffff
    80001944:	2f8080e7          	jalr	760(ra) # 80000c38 <acquire>
        if(p->state != UNUSED){
    80001948:	4c9c                	lw	a5,24(s1)
    8000194a:	d3ed                	beqz	a5,8000192c <mlfq_scheduler+0x74>
          p->priority = 0;
    8000194c:	1604a423          	sw	zero,360(s1)
          p->ticks_used = 0;
    80001950:	1604a623          	sw	zero,364(s1)
    80001954:	bfe1                	j	8000192c <mlfq_scheduler+0x74>
      release(&p->lock);
    80001956:	8526                	mv	a0,s1
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	394080e7          	jalr	916(ra) # 80000cec <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80001960:	17048493          	addi	s1,s1,368
    80001964:	03248e63          	beq	s1,s2,800019a0 <mlfq_scheduler+0xe8>
      acquire(&p->lock);
    80001968:	8526                	mv	a0,s1
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	2ce080e7          	jalr	718(ra) # 80000c38 <acquire>
      if(p->state == RUNNABLE){
    80001972:	4c9c                	lw	a5,24(s1)
    80001974:	ff3791e3          	bne	a5,s3,80001956 <mlfq_scheduler+0x9e>
        if(p->priority < best_pri){
    80001978:	1684a783          	lw	a5,360(s1)
    8000197c:	fd97dde3          	bge	a5,s9,80001956 <mlfq_scheduler+0x9e>
          if(best)
    80001980:	000d0763          	beqz	s10,8000198e <mlfq_scheduler+0xd6>
            release(&best->lock);
    80001984:	856a                	mv	a0,s10
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	366080e7          	jalr	870(ra) # 80000cec <release>
          best_pri = p->priority;
    8000198e:	1684ac83          	lw	s9,360(s1)
    for(p = proc; p < &proc[NPROC]; p++){
    80001992:	17048793          	addi	a5,s1,368
    80001996:	03278b63          	beq	a5,s2,800019cc <mlfq_scheduler+0x114>
          best = p;
    8000199a:	8d26                	mv	s10,s1
    for(p = proc; p < &proc[NPROC]; p++){
    8000199c:	84be                	mv	s1,a5
    8000199e:	b7e9                	j	80001968 <mlfq_scheduler+0xb0>
    if(best){//Context switch
    800019a0:	020d1563          	bnez	s10,800019ca <mlfq_scheduler+0x112>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019a8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019ac:	10079073          	csrw	sstatus,a5
    if(ticks % BOOST_INTERVAL == 0){//promote
    800019b0:	000b2783          	lw	a5,0(s6)
    800019b4:	0347f7bb          	remuw	a5,a5,s4
    800019b8:	2781                	sext.w	a5,a5
    800019ba:	d7a5                	beqz	a5,80001922 <mlfq_scheduler+0x6a>
      for(p = proc; p < &proc[NPROC]; p++){
    800019bc:	8cce                	mv	s9,s3
    800019be:	8d56                	mv	s10,s5
    800019c0:	00012497          	auipc	s1,0x12
    800019c4:	1a048493          	addi	s1,s1,416 # 80013b60 <proc>
    800019c8:	b745                	j	80001968 <mlfq_scheduler+0xb0>
    800019ca:	84ea                	mv	s1,s10
      best->state = RUNNING;
    800019cc:	4791                	li	a5,4
    800019ce:	cc9c                	sw	a5,24(s1)
      c->proc = best;
    800019d0:	009bb023          	sd	s1,0(s7)
      swtch(&c->context, &best->context);
    800019d4:	06048593          	addi	a1,s1,96
    800019d8:	8562                	mv	a0,s8
    800019da:	00001097          	auipc	ra,0x1
    800019de:	13c080e7          	jalr	316(ra) # 80002b16 <swtch>
      c->proc = 0;
    800019e2:	000bb023          	sd	zero,0(s7)
      best->ticks_used++;
    800019e6:	16c4a783          	lw	a5,364(s1)
    800019ea:	2785                	addiw	a5,a5,1
    800019ec:	0007869b          	sext.w	a3,a5
    800019f0:	16f4a623          	sw	a5,364(s1)

      if(best->ticks_used >= slices[best->priority]){//demote
    800019f4:	1684a703          	lw	a4,360(s1)
    800019f8:	00271793          	slli	a5,a4,0x2
    800019fc:	fa078793          	addi	a5,a5,-96
    80001a00:	97a2                	add	a5,a5,s0
    80001a02:	ff07a783          	lw	a5,-16(a5)
    80001a06:	00f6c763          	blt	a3,a5,80001a14 <mlfq_scheduler+0x15c>
        if(best->priority < NQUEUES - 1)
    80001a0a:	4785                	li	a5,1
    80001a0c:	00e7dd63          	bge	a5,a4,80001a26 <mlfq_scheduler+0x16e>
          best->priority++;
        best->ticks_used = 0;
    80001a10:	1604a623          	sw	zero,364(s1)
      }
      release(&best->lock);
    80001a14:	8526                	mv	a0,s1
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	2d6080e7          	jalr	726(ra) # 80000cec <release>
    if(ticks % BOOST_INTERVAL == 0){//promote
    80001a1e:	06400a13          	li	s4,100
      for(p = proc; p < &proc[NPROC]; p++){
    80001a22:	498d                	li	s3,3
    80001a24:	b741                	j	800019a4 <mlfq_scheduler+0xec>
          best->priority++;
    80001a26:	2705                	addiw	a4,a4,1
    80001a28:	16e4a423          	sw	a4,360(s1)
    80001a2c:	b7d5                	j	80001a10 <mlfq_scheduler+0x158>

0000000080001a2e <rr_scheduler>:
    }
  }
}
void rr_scheduler(void)
{
    80001a2e:	7139                	addi	sp,sp,-64
    80001a30:	fc06                	sd	ra,56(sp)
    80001a32:	f822                	sd	s0,48(sp)
    80001a34:	f426                	sd	s1,40(sp)
    80001a36:	f04a                	sd	s2,32(sp)
    80001a38:	ec4e                	sd	s3,24(sp)
    80001a3a:	e852                	sd	s4,16(sp)
    80001a3c:	e456                	sd	s5,8(sp)
    80001a3e:	e05a                	sd	s6,0(sp)
    80001a40:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a42:	8792                	mv	a5,tp
    int id = r_tp();
    80001a44:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001a46:	00012a97          	auipc	s5,0x12
    80001a4a:	ceaa8a93          	addi	s5,s5,-790 # 80013730 <cpus>
    80001a4e:	00779713          	slli	a4,a5,0x7
    80001a52:	00ea86b3          	add	a3,s5,a4
    80001a56:	0006b023          	sd	zero,0(a3)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a5a:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a5e:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a62:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    80001a66:	0721                	addi	a4,a4,8
    80001a68:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    80001a6a:	00012497          	auipc	s1,0x12
    80001a6e:	0f648493          	addi	s1,s1,246 # 80013b60 <proc>
        if (p->state == RUNNABLE)
    80001a72:	498d                	li	s3,3
            p->state = RUNNING;
    80001a74:	4b11                	li	s6,4
            c->proc = p;
    80001a76:	079e                	slli	a5,a5,0x7
    80001a78:	00012a17          	auipc	s4,0x12
    80001a7c:	cb8a0a13          	addi	s4,s4,-840 # 80013730 <cpus>
    80001a80:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001a82:	00018917          	auipc	s2,0x18
    80001a86:	cde90913          	addi	s2,s2,-802 # 80019760 <tickslock>
    80001a8a:	a811                	j	80001a9e <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	25e080e7          	jalr	606(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a96:	17048493          	addi	s1,s1,368
    80001a9a:	03248863          	beq	s1,s2,80001aca <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	198080e7          	jalr	408(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    80001aa8:	4c9c                	lw	a5,24(s1)
    80001aaa:	ff3791e3          	bne	a5,s3,80001a8c <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001aae:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001ab2:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001ab6:	06048593          	addi	a1,s1,96
    80001aba:	8556                	mv	a0,s5
    80001abc:	00001097          	auipc	ra,0x1
    80001ac0:	05a080e7          	jalr	90(ra) # 80002b16 <swtch>
            c->proc = 0;
    80001ac4:	000a3023          	sd	zero,0(s4)
    80001ac8:	b7d1                	j	80001a8c <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    80001aca:	70e2                	ld	ra,56(sp)
    80001acc:	7442                	ld	s0,48(sp)
    80001ace:	74a2                	ld	s1,40(sp)
    80001ad0:	7902                	ld	s2,32(sp)
    80001ad2:	69e2                	ld	s3,24(sp)
    80001ad4:	6a42                	ld	s4,16(sp)
    80001ad6:	6aa2                	ld	s5,8(sp)
    80001ad8:	6b02                	ld	s6,0(sp)
    80001ada:	6121                	addi	sp,sp,64
    80001adc:	8082                	ret

0000000080001ade <proc_mapstacks>:
{
    80001ade:	7139                	addi	sp,sp,-64
    80001ae0:	fc06                	sd	ra,56(sp)
    80001ae2:	f822                	sd	s0,48(sp)
    80001ae4:	f426                	sd	s1,40(sp)
    80001ae6:	f04a                	sd	s2,32(sp)
    80001ae8:	ec4e                	sd	s3,24(sp)
    80001aea:	e852                	sd	s4,16(sp)
    80001aec:	e456                	sd	s5,8(sp)
    80001aee:	e05a                	sd	s6,0(sp)
    80001af0:	0080                	addi	s0,sp,64
    80001af2:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001af4:	00012497          	auipc	s1,0x12
    80001af8:	06c48493          	addi	s1,s1,108 # 80013b60 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001afc:	8b26                	mv	s6,s1
    80001afe:	ff4df937          	lui	s2,0xff4df
    80001b02:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e7d>
    80001b06:	0936                	slli	s2,s2,0xd
    80001b08:	6f590913          	addi	s2,s2,1781
    80001b0c:	0936                	slli	s2,s2,0xd
    80001b0e:	bd390913          	addi	s2,s2,-1069
    80001b12:	0932                	slli	s2,s2,0xc
    80001b14:	7a790913          	addi	s2,s2,1959
    80001b18:	040009b7          	lui	s3,0x4000
    80001b1c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b1e:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001b20:	00018a97          	auipc	s5,0x18
    80001b24:	c40a8a93          	addi	s5,s5,-960 # 80019760 <tickslock>
        char *pa = kalloc();
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	020080e7          	jalr	32(ra) # 80000b48 <kalloc>
    80001b30:	862a                	mv	a2,a0
        if (pa == 0)
    80001b32:	c121                	beqz	a0,80001b72 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001b34:	416485b3          	sub	a1,s1,s6
    80001b38:	8591                	srai	a1,a1,0x4
    80001b3a:	032585b3          	mul	a1,a1,s2
    80001b3e:	2585                	addiw	a1,a1,1
    80001b40:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b44:	4719                	li	a4,6
    80001b46:	6685                	lui	a3,0x1
    80001b48:	40b985b3          	sub	a1,s3,a1
    80001b4c:	8552                	mv	a0,s4
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	64a080e7          	jalr	1610(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b56:	17048493          	addi	s1,s1,368
    80001b5a:	fd5497e3          	bne	s1,s5,80001b28 <proc_mapstacks+0x4a>
}
    80001b5e:	70e2                	ld	ra,56(sp)
    80001b60:	7442                	ld	s0,48(sp)
    80001b62:	74a2                	ld	s1,40(sp)
    80001b64:	7902                	ld	s2,32(sp)
    80001b66:	69e2                	ld	s3,24(sp)
    80001b68:	6a42                	ld	s4,16(sp)
    80001b6a:	6aa2                	ld	s5,8(sp)
    80001b6c:	6b02                	ld	s6,0(sp)
    80001b6e:	6121                	addi	sp,sp,64
    80001b70:	8082                	ret
            panic("kalloc");
    80001b72:	00006517          	auipc	a0,0x6
    80001b76:	64650513          	addi	a0,a0,1606 # 800081b8 <etext+0x1b8>
    80001b7a:	fffff097          	auipc	ra,0xfffff
    80001b7e:	9e6080e7          	jalr	-1562(ra) # 80000560 <panic>

0000000080001b82 <procinit>:
{
    80001b82:	7139                	addi	sp,sp,-64
    80001b84:	fc06                	sd	ra,56(sp)
    80001b86:	f822                	sd	s0,48(sp)
    80001b88:	f426                	sd	s1,40(sp)
    80001b8a:	f04a                	sd	s2,32(sp)
    80001b8c:	ec4e                	sd	s3,24(sp)
    80001b8e:	e852                	sd	s4,16(sp)
    80001b90:	e456                	sd	s5,8(sp)
    80001b92:	e05a                	sd	s6,0(sp)
    80001b94:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001b96:	00006597          	auipc	a1,0x6
    80001b9a:	62a58593          	addi	a1,a1,1578 # 800081c0 <etext+0x1c0>
    80001b9e:	00012517          	auipc	a0,0x12
    80001ba2:	f9250513          	addi	a0,a0,-110 # 80013b30 <pid_lock>
    80001ba6:	fffff097          	auipc	ra,0xfffff
    80001baa:	002080e7          	jalr	2(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001bae:	00006597          	auipc	a1,0x6
    80001bb2:	61a58593          	addi	a1,a1,1562 # 800081c8 <etext+0x1c8>
    80001bb6:	00012517          	auipc	a0,0x12
    80001bba:	f9250513          	addi	a0,a0,-110 # 80013b48 <wait_lock>
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	fea080e7          	jalr	-22(ra) # 80000ba8 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bc6:	00012497          	auipc	s1,0x12
    80001bca:	f9a48493          	addi	s1,s1,-102 # 80013b60 <proc>
        initlock(&p->lock, "proc");
    80001bce:	00006b17          	auipc	s6,0x6
    80001bd2:	60ab0b13          	addi	s6,s6,1546 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001bd6:	8aa6                	mv	s5,s1
    80001bd8:	ff4df937          	lui	s2,0xff4df
    80001bdc:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e7d>
    80001be0:	0936                	slli	s2,s2,0xd
    80001be2:	6f590913          	addi	s2,s2,1781
    80001be6:	0936                	slli	s2,s2,0xd
    80001be8:	bd390913          	addi	s2,s2,-1069
    80001bec:	0932                	slli	s2,s2,0xc
    80001bee:	7a790913          	addi	s2,s2,1959
    80001bf2:	040009b7          	lui	s3,0x4000
    80001bf6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bf8:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001bfa:	00018a17          	auipc	s4,0x18
    80001bfe:	b66a0a13          	addi	s4,s4,-1178 # 80019760 <tickslock>
        initlock(&p->lock, "proc");
    80001c02:	85da                	mv	a1,s6
    80001c04:	8526                	mv	a0,s1
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	fa2080e7          	jalr	-94(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80001c0e:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001c12:	415487b3          	sub	a5,s1,s5
    80001c16:	8791                	srai	a5,a5,0x4
    80001c18:	032787b3          	mul	a5,a5,s2
    80001c1c:	2785                	addiw	a5,a5,1
    80001c1e:	00d7979b          	slliw	a5,a5,0xd
    80001c22:	40f987b3          	sub	a5,s3,a5
    80001c26:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001c28:	17048493          	addi	s1,s1,368
    80001c2c:	fd449be3          	bne	s1,s4,80001c02 <procinit+0x80>
}
    80001c30:	70e2                	ld	ra,56(sp)
    80001c32:	7442                	ld	s0,48(sp)
    80001c34:	74a2                	ld	s1,40(sp)
    80001c36:	7902                	ld	s2,32(sp)
    80001c38:	69e2                	ld	s3,24(sp)
    80001c3a:	6a42                	ld	s4,16(sp)
    80001c3c:	6aa2                	ld	s5,8(sp)
    80001c3e:	6b02                	ld	s6,0(sp)
    80001c40:	6121                	addi	sp,sp,64
    80001c42:	8082                	ret

0000000080001c44 <copy_array>:
{
    80001c44:	1141                	addi	sp,sp,-16
    80001c46:	e422                	sd	s0,8(sp)
    80001c48:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001c4a:	00c05c63          	blez	a2,80001c62 <copy_array+0x1e>
    80001c4e:	87aa                	mv	a5,a0
    80001c50:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001c52:	0007c703          	lbu	a4,0(a5)
    80001c56:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001c5a:	0785                	addi	a5,a5,1
    80001c5c:	0585                	addi	a1,a1,1
    80001c5e:	fea79ae3          	bne	a5,a0,80001c52 <copy_array+0xe>
}
    80001c62:	6422                	ld	s0,8(sp)
    80001c64:	0141                	addi	sp,sp,16
    80001c66:	8082                	ret

0000000080001c68 <cpuid>:
{
    80001c68:	1141                	addi	sp,sp,-16
    80001c6a:	e422                	sd	s0,8(sp)
    80001c6c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c6e:	8512                	mv	a0,tp
}
    80001c70:	2501                	sext.w	a0,a0
    80001c72:	6422                	ld	s0,8(sp)
    80001c74:	0141                	addi	sp,sp,16
    80001c76:	8082                	ret

0000000080001c78 <mycpu>:
{
    80001c78:	1141                	addi	sp,sp,-16
    80001c7a:	e422                	sd	s0,8(sp)
    80001c7c:	0800                	addi	s0,sp,16
    80001c7e:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001c80:	2781                	sext.w	a5,a5
    80001c82:	079e                	slli	a5,a5,0x7
}
    80001c84:	00012517          	auipc	a0,0x12
    80001c88:	aac50513          	addi	a0,a0,-1364 # 80013730 <cpus>
    80001c8c:	953e                	add	a0,a0,a5
    80001c8e:	6422                	ld	s0,8(sp)
    80001c90:	0141                	addi	sp,sp,16
    80001c92:	8082                	ret

0000000080001c94 <myproc>:
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	1000                	addi	s0,sp,32
    push_off();
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	f4e080e7          	jalr	-178(ra) # 80000bec <push_off>
    80001ca6:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001ca8:	2781                	sext.w	a5,a5
    80001caa:	079e                	slli	a5,a5,0x7
    80001cac:	00012717          	auipc	a4,0x12
    80001cb0:	a8470713          	addi	a4,a4,-1404 # 80013730 <cpus>
    80001cb4:	97ba                	add	a5,a5,a4
    80001cb6:	6384                	ld	s1,0(a5)
    pop_off();
    80001cb8:	fffff097          	auipc	ra,0xfffff
    80001cbc:	fd4080e7          	jalr	-44(ra) # 80000c8c <pop_off>
}
    80001cc0:	8526                	mv	a0,s1
    80001cc2:	60e2                	ld	ra,24(sp)
    80001cc4:	6442                	ld	s0,16(sp)
    80001cc6:	64a2                	ld	s1,8(sp)
    80001cc8:	6105                	addi	sp,sp,32
    80001cca:	8082                	ret

0000000080001ccc <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001ccc:	1141                	addi	sp,sp,-16
    80001cce:	e406                	sd	ra,8(sp)
    80001cd0:	e022                	sd	s0,0(sp)
    80001cd2:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	fc0080e7          	jalr	-64(ra) # 80001c94 <myproc>
    80001cdc:	fffff097          	auipc	ra,0xfffff
    80001ce0:	010080e7          	jalr	16(ra) # 80000cec <release>

    if (first)
    80001ce4:	00009797          	auipc	a5,0x9
    80001ce8:	6ec7a783          	lw	a5,1772(a5) # 8000b3d0 <first.1>
    80001cec:	eb89                	bnez	a5,80001cfe <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001cee:	00001097          	auipc	ra,0x1
    80001cf2:	ed2080e7          	jalr	-302(ra) # 80002bc0 <usertrapret>
}
    80001cf6:	60a2                	ld	ra,8(sp)
    80001cf8:	6402                	ld	s0,0(sp)
    80001cfa:	0141                	addi	sp,sp,16
    80001cfc:	8082                	ret
        first = 0;
    80001cfe:	00009797          	auipc	a5,0x9
    80001d02:	6c07a923          	sw	zero,1746(a5) # 8000b3d0 <first.1>
        fsinit(ROOTDEV);
    80001d06:	4505                	li	a0,1
    80001d08:	00002097          	auipc	ra,0x2
    80001d0c:	cd6080e7          	jalr	-810(ra) # 800039de <fsinit>
    80001d10:	bff9                	j	80001cee <forkret+0x22>

0000000080001d12 <allocpid>:
{
    80001d12:	1101                	addi	sp,sp,-32
    80001d14:	ec06                	sd	ra,24(sp)
    80001d16:	e822                	sd	s0,16(sp)
    80001d18:	e426                	sd	s1,8(sp)
    80001d1a:	e04a                	sd	s2,0(sp)
    80001d1c:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001d1e:	00012917          	auipc	s2,0x12
    80001d22:	e1290913          	addi	s2,s2,-494 # 80013b30 <pid_lock>
    80001d26:	854a                	mv	a0,s2
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	f10080e7          	jalr	-240(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001d30:	00009797          	auipc	a5,0x9
    80001d34:	6b078793          	addi	a5,a5,1712 # 8000b3e0 <nextpid>
    80001d38:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001d3a:	0014871b          	addiw	a4,s1,1
    80001d3e:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001d40:	854a                	mv	a0,s2
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	faa080e7          	jalr	-86(ra) # 80000cec <release>
}
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	60e2                	ld	ra,24(sp)
    80001d4e:	6442                	ld	s0,16(sp)
    80001d50:	64a2                	ld	s1,8(sp)
    80001d52:	6902                	ld	s2,0(sp)
    80001d54:	6105                	addi	sp,sp,32
    80001d56:	8082                	ret

0000000080001d58 <proc_pagetable>:
{
    80001d58:	1101                	addi	sp,sp,-32
    80001d5a:	ec06                	sd	ra,24(sp)
    80001d5c:	e822                	sd	s0,16(sp)
    80001d5e:	e426                	sd	s1,8(sp)
    80001d60:	e04a                	sd	s2,0(sp)
    80001d62:	1000                	addi	s0,sp,32
    80001d64:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	62c080e7          	jalr	1580(ra) # 80001392 <uvmcreate>
    80001d6e:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001d70:	c121                	beqz	a0,80001db0 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001d72:	4729                	li	a4,10
    80001d74:	00005697          	auipc	a3,0x5
    80001d78:	28c68693          	addi	a3,a3,652 # 80007000 <_trampoline>
    80001d7c:	6605                	lui	a2,0x1
    80001d7e:	040005b7          	lui	a1,0x4000
    80001d82:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d84:	05b2                	slli	a1,a1,0xc
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	372080e7          	jalr	882(ra) # 800010f8 <mappages>
    80001d8e:	02054863          	bltz	a0,80001dbe <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d92:	4719                	li	a4,6
    80001d94:	05893683          	ld	a3,88(s2)
    80001d98:	6605                	lui	a2,0x1
    80001d9a:	020005b7          	lui	a1,0x2000
    80001d9e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001da0:	05b6                	slli	a1,a1,0xd
    80001da2:	8526                	mv	a0,s1
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	354080e7          	jalr	852(ra) # 800010f8 <mappages>
    80001dac:	02054163          	bltz	a0,80001dce <proc_pagetable+0x76>
}
    80001db0:	8526                	mv	a0,s1
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6902                	ld	s2,0(sp)
    80001dba:	6105                	addi	sp,sp,32
    80001dbc:	8082                	ret
        uvmfree(pagetable, 0);
    80001dbe:	4581                	li	a1,0
    80001dc0:	8526                	mv	a0,s1
    80001dc2:	fffff097          	auipc	ra,0xfffff
    80001dc6:	7e2080e7          	jalr	2018(ra) # 800015a4 <uvmfree>
        return 0;
    80001dca:	4481                	li	s1,0
    80001dcc:	b7d5                	j	80001db0 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001dce:	4681                	li	a3,0
    80001dd0:	4605                	li	a2,1
    80001dd2:	040005b7          	lui	a1,0x4000
    80001dd6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001dd8:	05b2                	slli	a1,a1,0xc
    80001dda:	8526                	mv	a0,s1
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	4e2080e7          	jalr	1250(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001de4:	4581                	li	a1,0
    80001de6:	8526                	mv	a0,s1
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	7bc080e7          	jalr	1980(ra) # 800015a4 <uvmfree>
        return 0;
    80001df0:	4481                	li	s1,0
    80001df2:	bf7d                	j	80001db0 <proc_pagetable+0x58>

0000000080001df4 <proc_freepagetable>:
{
    80001df4:	1101                	addi	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	e04a                	sd	s2,0(sp)
    80001dfe:	1000                	addi	s0,sp,32
    80001e00:	84aa                	mv	s1,a0
    80001e02:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e04:	4681                	li	a3,0
    80001e06:	4605                	li	a2,1
    80001e08:	040005b7          	lui	a1,0x4000
    80001e0c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e0e:	05b2                	slli	a1,a1,0xc
    80001e10:	fffff097          	auipc	ra,0xfffff
    80001e14:	4ae080e7          	jalr	1198(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e18:	4681                	li	a3,0
    80001e1a:	4605                	li	a2,1
    80001e1c:	020005b7          	lui	a1,0x2000
    80001e20:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e22:	05b6                	slli	a1,a1,0xd
    80001e24:	8526                	mv	a0,s1
    80001e26:	fffff097          	auipc	ra,0xfffff
    80001e2a:	498080e7          	jalr	1176(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001e2e:	85ca                	mv	a1,s2
    80001e30:	8526                	mv	a0,s1
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	772080e7          	jalr	1906(ra) # 800015a4 <uvmfree>
}
    80001e3a:	60e2                	ld	ra,24(sp)
    80001e3c:	6442                	ld	s0,16(sp)
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	6902                	ld	s2,0(sp)
    80001e42:	6105                	addi	sp,sp,32
    80001e44:	8082                	ret

0000000080001e46 <freeproc>:
{
    80001e46:	1101                	addi	sp,sp,-32
    80001e48:	ec06                	sd	ra,24(sp)
    80001e4a:	e822                	sd	s0,16(sp)
    80001e4c:	e426                	sd	s1,8(sp)
    80001e4e:	1000                	addi	s0,sp,32
    80001e50:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001e52:	6d28                	ld	a0,88(a0)
    80001e54:	c509                	beqz	a0,80001e5e <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	bf4080e7          	jalr	-1036(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001e5e:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001e62:	68a8                	ld	a0,80(s1)
    80001e64:	c511                	beqz	a0,80001e70 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001e66:	64ac                	ld	a1,72(s1)
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	f8c080e7          	jalr	-116(ra) # 80001df4 <proc_freepagetable>
    p->pagetable = 0;
    80001e70:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001e74:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001e78:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001e7c:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001e80:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001e84:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001e88:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001e8c:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001e90:	0004ac23          	sw	zero,24(s1)
}
    80001e94:	60e2                	ld	ra,24(sp)
    80001e96:	6442                	ld	s0,16(sp)
    80001e98:	64a2                	ld	s1,8(sp)
    80001e9a:	6105                	addi	sp,sp,32
    80001e9c:	8082                	ret

0000000080001e9e <allocproc>:
{
    80001e9e:	1101                	addi	sp,sp,-32
    80001ea0:	ec06                	sd	ra,24(sp)
    80001ea2:	e822                	sd	s0,16(sp)
    80001ea4:	e426                	sd	s1,8(sp)
    80001ea6:	e04a                	sd	s2,0(sp)
    80001ea8:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001eaa:	00012497          	auipc	s1,0x12
    80001eae:	cb648493          	addi	s1,s1,-842 # 80013b60 <proc>
    80001eb2:	00018917          	auipc	s2,0x18
    80001eb6:	8ae90913          	addi	s2,s2,-1874 # 80019760 <tickslock>
        acquire(&p->lock);
    80001eba:	8526                	mv	a0,s1
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	d7c080e7          	jalr	-644(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001ec4:	4c9c                	lw	a5,24(s1)
    80001ec6:	cf81                	beqz	a5,80001ede <allocproc+0x40>
            release(&p->lock);
    80001ec8:	8526                	mv	a0,s1
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	e22080e7          	jalr	-478(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001ed2:	17048493          	addi	s1,s1,368
    80001ed6:	ff2492e3          	bne	s1,s2,80001eba <allocproc+0x1c>
    return 0;
    80001eda:	4481                	li	s1,0
    80001edc:	a889                	j	80001f2e <allocproc+0x90>
    p->pid = allocpid();
    80001ede:	00000097          	auipc	ra,0x0
    80001ee2:	e34080e7          	jalr	-460(ra) # 80001d12 <allocpid>
    80001ee6:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001ee8:	4785                	li	a5,1
    80001eea:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	c5c080e7          	jalr	-932(ra) # 80000b48 <kalloc>
    80001ef4:	892a                	mv	s2,a0
    80001ef6:	eca8                	sd	a0,88(s1)
    80001ef8:	c131                	beqz	a0,80001f3c <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001efa:	8526                	mv	a0,s1
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	e5c080e7          	jalr	-420(ra) # 80001d58 <proc_pagetable>
    80001f04:	892a                	mv	s2,a0
    80001f06:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001f08:	c531                	beqz	a0,80001f54 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001f0a:	07000613          	li	a2,112
    80001f0e:	4581                	li	a1,0
    80001f10:	06048513          	addi	a0,s1,96
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	e20080e7          	jalr	-480(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001f1c:	00000797          	auipc	a5,0x0
    80001f20:	db078793          	addi	a5,a5,-592 # 80001ccc <forkret>
    80001f24:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001f26:	60bc                	ld	a5,64(s1)
    80001f28:	6705                	lui	a4,0x1
    80001f2a:	97ba                	add	a5,a5,a4
    80001f2c:	f4bc                	sd	a5,104(s1)
}
    80001f2e:	8526                	mv	a0,s1
    80001f30:	60e2                	ld	ra,24(sp)
    80001f32:	6442                	ld	s0,16(sp)
    80001f34:	64a2                	ld	s1,8(sp)
    80001f36:	6902                	ld	s2,0(sp)
    80001f38:	6105                	addi	sp,sp,32
    80001f3a:	8082                	ret
        freeproc(p);
    80001f3c:	8526                	mv	a0,s1
    80001f3e:	00000097          	auipc	ra,0x0
    80001f42:	f08080e7          	jalr	-248(ra) # 80001e46 <freeproc>
        release(&p->lock);
    80001f46:	8526                	mv	a0,s1
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	da4080e7          	jalr	-604(ra) # 80000cec <release>
        return 0;
    80001f50:	84ca                	mv	s1,s2
    80001f52:	bff1                	j	80001f2e <allocproc+0x90>
        freeproc(p);
    80001f54:	8526                	mv	a0,s1
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	ef0080e7          	jalr	-272(ra) # 80001e46 <freeproc>
        release(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	d8c080e7          	jalr	-628(ra) # 80000cec <release>
        return 0;
    80001f68:	84ca                	mv	s1,s2
    80001f6a:	b7d1                	j	80001f2e <allocproc+0x90>

0000000080001f6c <userinit>:
{
    80001f6c:	1101                	addi	sp,sp,-32
    80001f6e:	ec06                	sd	ra,24(sp)
    80001f70:	e822                	sd	s0,16(sp)
    80001f72:	e426                	sd	s1,8(sp)
    80001f74:	1000                	addi	s0,sp,32
    p = allocproc();
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	f28080e7          	jalr	-216(ra) # 80001e9e <allocproc>
    80001f7e:	84aa                	mv	s1,a0
    initproc = p;
    80001f80:	00009797          	auipc	a5,0x9
    80001f84:	52a7bc23          	sd	a0,1336(a5) # 8000b4b8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f88:	03400613          	li	a2,52
    80001f8c:	00009597          	auipc	a1,0x9
    80001f90:	46458593          	addi	a1,a1,1124 # 8000b3f0 <initcode>
    80001f94:	6928                	ld	a0,80(a0)
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	42a080e7          	jalr	1066(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80001f9e:	6785                	lui	a5,0x1
    80001fa0:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001fa2:	6cb8                	ld	a4,88(s1)
    80001fa4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001fa8:	6cb8                	ld	a4,88(s1)
    80001faa:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001fac:	4641                	li	a2,16
    80001fae:	00006597          	auipc	a1,0x6
    80001fb2:	23258593          	addi	a1,a1,562 # 800081e0 <etext+0x1e0>
    80001fb6:	15848513          	addi	a0,s1,344
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	ebc080e7          	jalr	-324(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	22e50513          	addi	a0,a0,558 # 800081f0 <etext+0x1f0>
    80001fca:	00002097          	auipc	ra,0x2
    80001fce:	466080e7          	jalr	1126(ra) # 80004430 <namei>
    80001fd2:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001fd6:	478d                	li	a5,3
    80001fd8:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001fda:	8526                	mv	a0,s1
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	d10080e7          	jalr	-752(ra) # 80000cec <release>
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret

0000000080001fee <growproc>:
{
    80001fee:	1101                	addi	sp,sp,-32
    80001ff0:	ec06                	sd	ra,24(sp)
    80001ff2:	e822                	sd	s0,16(sp)
    80001ff4:	e426                	sd	s1,8(sp)
    80001ff6:	e04a                	sd	s2,0(sp)
    80001ff8:	1000                	addi	s0,sp,32
    80001ffa:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	c98080e7          	jalr	-872(ra) # 80001c94 <myproc>
    80002004:	84aa                	mv	s1,a0
    sz = p->sz;
    80002006:	652c                	ld	a1,72(a0)
    if (n > 0)
    80002008:	01204c63          	bgtz	s2,80002020 <growproc+0x32>
    else if (n < 0)
    8000200c:	02094663          	bltz	s2,80002038 <growproc+0x4a>
    p->sz = sz;
    80002010:	e4ac                	sd	a1,72(s1)
    return 0;
    80002012:	4501                	li	a0,0
}
    80002014:	60e2                	ld	ra,24(sp)
    80002016:	6442                	ld	s0,16(sp)
    80002018:	64a2                	ld	s1,8(sp)
    8000201a:	6902                	ld	s2,0(sp)
    8000201c:	6105                	addi	sp,sp,32
    8000201e:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002020:	4691                	li	a3,4
    80002022:	00b90633          	add	a2,s2,a1
    80002026:	6928                	ld	a0,80(a0)
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	452080e7          	jalr	1106(ra) # 8000147a <uvmalloc>
    80002030:	85aa                	mv	a1,a0
    80002032:	fd79                	bnez	a0,80002010 <growproc+0x22>
            return -1;
    80002034:	557d                	li	a0,-1
    80002036:	bff9                	j	80002014 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002038:	00b90633          	add	a2,s2,a1
    8000203c:	6928                	ld	a0,80(a0)
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	3f4080e7          	jalr	1012(ra) # 80001432 <uvmdealloc>
    80002046:	85aa                	mv	a1,a0
    80002048:	b7e1                	j	80002010 <growproc+0x22>

000000008000204a <ps>:
{
    8000204a:	715d                	addi	sp,sp,-80
    8000204c:	e486                	sd	ra,72(sp)
    8000204e:	e0a2                	sd	s0,64(sp)
    80002050:	fc26                	sd	s1,56(sp)
    80002052:	f84a                	sd	s2,48(sp)
    80002054:	f44e                	sd	s3,40(sp)
    80002056:	f052                	sd	s4,32(sp)
    80002058:	ec56                	sd	s5,24(sp)
    8000205a:	e85a                	sd	s6,16(sp)
    8000205c:	e45e                	sd	s7,8(sp)
    8000205e:	e062                	sd	s8,0(sp)
    80002060:	0880                	addi	s0,sp,80
    80002062:	84aa                	mv	s1,a0
    80002064:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	c2e080e7          	jalr	-978(ra) # 80001c94 <myproc>
        return result;
    8000206e:	4901                	li	s2,0
    if (count == 0)
    80002070:	0c0b8663          	beqz	s7,8000213c <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80002074:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002078:	003b951b          	slliw	a0,s7,0x3
    8000207c:	0175053b          	addw	a0,a0,s7
    80002080:	0025151b          	slliw	a0,a0,0x2
    80002084:	2501                	sext.w	a0,a0
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	f68080e7          	jalr	-152(ra) # 80001fee <growproc>
    8000208e:	12054f63          	bltz	a0,800021cc <ps+0x182>
    struct user_proc loc_result[count];
    80002092:	003b9a13          	slli	s4,s7,0x3
    80002096:	9a5e                	add	s4,s4,s7
    80002098:	0a0a                	slli	s4,s4,0x2
    8000209a:	00fa0793          	addi	a5,s4,15
    8000209e:	8391                	srli	a5,a5,0x4
    800020a0:	0792                	slli	a5,a5,0x4
    800020a2:	40f10133          	sub	sp,sp,a5
    800020a6:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    800020a8:	17000793          	li	a5,368
    800020ac:	02f484b3          	mul	s1,s1,a5
    800020b0:	00012797          	auipc	a5,0x12
    800020b4:	ab078793          	addi	a5,a5,-1360 # 80013b60 <proc>
    800020b8:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    800020ba:	00017797          	auipc	a5,0x17
    800020be:	6a678793          	addi	a5,a5,1702 # 80019760 <tickslock>
        return result;
    800020c2:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    800020c4:	06f4fc63          	bgeu	s1,a5,8000213c <ps+0xf2>
    acquire(&wait_lock);
    800020c8:	00012517          	auipc	a0,0x12
    800020cc:	a8050513          	addi	a0,a0,-1408 # 80013b48 <wait_lock>
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	b68080e7          	jalr	-1176(ra) # 80000c38 <acquire>
        if (localCount == count)
    800020d8:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    800020dc:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    800020de:	00017c17          	auipc	s8,0x17
    800020e2:	682c0c13          	addi	s8,s8,1666 # 80019760 <tickslock>
    800020e6:	a851                	j	8000217a <ps+0x130>
            loc_result[localCount].state = UNUSED;
    800020e8:	00399793          	slli	a5,s3,0x3
    800020ec:	97ce                	add	a5,a5,s3
    800020ee:	078a                	slli	a5,a5,0x2
    800020f0:	97d6                	add	a5,a5,s5
    800020f2:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800020f6:	8526                	mv	a0,s1
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	bf4080e7          	jalr	-1036(ra) # 80000cec <release>
    release(&wait_lock);
    80002100:	00012517          	auipc	a0,0x12
    80002104:	a4850513          	addi	a0,a0,-1464 # 80013b48 <wait_lock>
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	be4080e7          	jalr	-1052(ra) # 80000cec <release>
    if (localCount < count)
    80002110:	0179f963          	bgeu	s3,s7,80002122 <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80002114:	00399793          	slli	a5,s3,0x3
    80002118:	97ce                	add	a5,a5,s3
    8000211a:	078a                	slli	a5,a5,0x2
    8000211c:	97d6                	add	a5,a5,s5
    8000211e:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80002122:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80002124:	00000097          	auipc	ra,0x0
    80002128:	b70080e7          	jalr	-1168(ra) # 80001c94 <myproc>
    8000212c:	86d2                	mv	a3,s4
    8000212e:	8656                	mv	a2,s5
    80002130:	85da                	mv	a1,s6
    80002132:	6928                	ld	a0,80(a0)
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	5ae080e7          	jalr	1454(ra) # 800016e2 <copyout>
}
    8000213c:	854a                	mv	a0,s2
    8000213e:	fb040113          	addi	sp,s0,-80
    80002142:	60a6                	ld	ra,72(sp)
    80002144:	6406                	ld	s0,64(sp)
    80002146:	74e2                	ld	s1,56(sp)
    80002148:	7942                	ld	s2,48(sp)
    8000214a:	79a2                	ld	s3,40(sp)
    8000214c:	7a02                	ld	s4,32(sp)
    8000214e:	6ae2                	ld	s5,24(sp)
    80002150:	6b42                	ld	s6,16(sp)
    80002152:	6ba2                	ld	s7,8(sp)
    80002154:	6c02                	ld	s8,0(sp)
    80002156:	6161                	addi	sp,sp,80
    80002158:	8082                	ret
        release(&p->lock);
    8000215a:	8526                	mv	a0,s1
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	b90080e7          	jalr	-1136(ra) # 80000cec <release>
        localCount++;
    80002164:	2985                	addiw	s3,s3,1
    80002166:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    8000216a:	17048493          	addi	s1,s1,368
    8000216e:	f984f9e3          	bgeu	s1,s8,80002100 <ps+0xb6>
        if (localCount == count)
    80002172:	02490913          	addi	s2,s2,36
    80002176:	053b8d63          	beq	s7,s3,800021d0 <ps+0x186>
        acquire(&p->lock);
    8000217a:	8526                	mv	a0,s1
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	abc080e7          	jalr	-1348(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80002184:	4c9c                	lw	a5,24(s1)
    80002186:	d3ad                	beqz	a5,800020e8 <ps+0x9e>
        loc_result[localCount].state = p->state;
    80002188:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    8000218c:	549c                	lw	a5,40(s1)
    8000218e:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002192:	54dc                	lw	a5,44(s1)
    80002194:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    80002198:	589c                	lw	a5,48(s1)
    8000219a:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    8000219e:	4641                	li	a2,16
    800021a0:	85ca                	mv	a1,s2
    800021a2:	15848513          	addi	a0,s1,344
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	a9e080e7          	jalr	-1378(ra) # 80001c44 <copy_array>
        if (p->parent != 0) // init
    800021ae:	7c88                	ld	a0,56(s1)
    800021b0:	d54d                	beqz	a0,8000215a <ps+0x110>
            acquire(&p->parent->lock);
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	a86080e7          	jalr	-1402(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    800021ba:	7c88                	ld	a0,56(s1)
    800021bc:	591c                	lw	a5,48(a0)
    800021be:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	b2a080e7          	jalr	-1238(ra) # 80000cec <release>
    800021ca:	bf41                	j	8000215a <ps+0x110>
        return result;
    800021cc:	4901                	li	s2,0
    800021ce:	b7bd                	j	8000213c <ps+0xf2>
    release(&wait_lock);
    800021d0:	00012517          	auipc	a0,0x12
    800021d4:	97850513          	addi	a0,a0,-1672 # 80013b48 <wait_lock>
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	b14080e7          	jalr	-1260(ra) # 80000cec <release>
    if (localCount < count)
    800021e0:	b789                	j	80002122 <ps+0xd8>

00000000800021e2 <fork>:
{
    800021e2:	7139                	addi	sp,sp,-64
    800021e4:	fc06                	sd	ra,56(sp)
    800021e6:	f822                	sd	s0,48(sp)
    800021e8:	f04a                	sd	s2,32(sp)
    800021ea:	e456                	sd	s5,8(sp)
    800021ec:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	aa6080e7          	jalr	-1370(ra) # 80001c94 <myproc>
    800021f6:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	ca6080e7          	jalr	-858(ra) # 80001e9e <allocproc>
    80002200:	12050063          	beqz	a0,80002320 <fork+0x13e>
    80002204:	e852                	sd	s4,16(sp)
    80002206:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002208:	048ab603          	ld	a2,72(s5)
    8000220c:	692c                	ld	a1,80(a0)
    8000220e:	050ab503          	ld	a0,80(s5)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	3cc080e7          	jalr	972(ra) # 800015de <uvmcopy>
    8000221a:	04054a63          	bltz	a0,8000226e <fork+0x8c>
    8000221e:	f426                	sd	s1,40(sp)
    80002220:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    80002222:	048ab783          	ld	a5,72(s5)
    80002226:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    8000222a:	058ab683          	ld	a3,88(s5)
    8000222e:	87b6                	mv	a5,a3
    80002230:	058a3703          	ld	a4,88(s4)
    80002234:	12068693          	addi	a3,a3,288
    80002238:	0007b803          	ld	a6,0(a5)
    8000223c:	6788                	ld	a0,8(a5)
    8000223e:	6b8c                	ld	a1,16(a5)
    80002240:	6f90                	ld	a2,24(a5)
    80002242:	01073023          	sd	a6,0(a4)
    80002246:	e708                	sd	a0,8(a4)
    80002248:	eb0c                	sd	a1,16(a4)
    8000224a:	ef10                	sd	a2,24(a4)
    8000224c:	02078793          	addi	a5,a5,32
    80002250:	02070713          	addi	a4,a4,32
    80002254:	fed792e3          	bne	a5,a3,80002238 <fork+0x56>
    np->trapframe->a0 = 0;
    80002258:	058a3783          	ld	a5,88(s4)
    8000225c:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80002260:	0d0a8493          	addi	s1,s5,208
    80002264:	0d0a0913          	addi	s2,s4,208
    80002268:	150a8993          	addi	s3,s5,336
    8000226c:	a015                	j	80002290 <fork+0xae>
        freeproc(np);
    8000226e:	8552                	mv	a0,s4
    80002270:	00000097          	auipc	ra,0x0
    80002274:	bd6080e7          	jalr	-1066(ra) # 80001e46 <freeproc>
        release(&np->lock);
    80002278:	8552                	mv	a0,s4
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	a72080e7          	jalr	-1422(ra) # 80000cec <release>
        return -1;
    80002282:	597d                	li	s2,-1
    80002284:	6a42                	ld	s4,16(sp)
    80002286:	a071                	j	80002312 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002288:	04a1                	addi	s1,s1,8
    8000228a:	0921                	addi	s2,s2,8
    8000228c:	01348b63          	beq	s1,s3,800022a2 <fork+0xc0>
        if (p->ofile[i])
    80002290:	6088                	ld	a0,0(s1)
    80002292:	d97d                	beqz	a0,80002288 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002294:	00003097          	auipc	ra,0x3
    80002298:	814080e7          	jalr	-2028(ra) # 80004aa8 <filedup>
    8000229c:	00a93023          	sd	a0,0(s2)
    800022a0:	b7e5                	j	80002288 <fork+0xa6>
    np->cwd = idup(p->cwd);
    800022a2:	150ab503          	ld	a0,336(s5)
    800022a6:	00002097          	auipc	ra,0x2
    800022aa:	97e080e7          	jalr	-1666(ra) # 80003c24 <idup>
    800022ae:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800022b2:	4641                	li	a2,16
    800022b4:	158a8593          	addi	a1,s5,344
    800022b8:	158a0513          	addi	a0,s4,344
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	bba080e7          	jalr	-1094(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    800022c4:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    800022c8:	8552                	mv	a0,s4
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	a22080e7          	jalr	-1502(ra) # 80000cec <release>
    acquire(&wait_lock);
    800022d2:	00012497          	auipc	s1,0x12
    800022d6:	87648493          	addi	s1,s1,-1930 # 80013b48 <wait_lock>
    800022da:	8526                	mv	a0,s1
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	95c080e7          	jalr	-1700(ra) # 80000c38 <acquire>
    np->parent = p;
    800022e4:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800022e8:	8526                	mv	a0,s1
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	a02080e7          	jalr	-1534(ra) # 80000cec <release>
    acquire(&np->lock);
    800022f2:	8552                	mv	a0,s4
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	944080e7          	jalr	-1724(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    800022fc:	478d                	li	a5,3
    800022fe:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80002302:	8552                	mv	a0,s4
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	9e8080e7          	jalr	-1560(ra) # 80000cec <release>
    return pid;
    8000230c:	74a2                	ld	s1,40(sp)
    8000230e:	69e2                	ld	s3,24(sp)
    80002310:	6a42                	ld	s4,16(sp)
}
    80002312:	854a                	mv	a0,s2
    80002314:	70e2                	ld	ra,56(sp)
    80002316:	7442                	ld	s0,48(sp)
    80002318:	7902                	ld	s2,32(sp)
    8000231a:	6aa2                	ld	s5,8(sp)
    8000231c:	6121                	addi	sp,sp,64
    8000231e:	8082                	ret
        return -1;
    80002320:	597d                	li	s2,-1
    80002322:	bfc5                	j	80002312 <fork+0x130>

0000000080002324 <scheduler>:
{
    80002324:	1101                	addi	sp,sp,-32
    80002326:	ec06                	sd	ra,24(sp)
    80002328:	e822                	sd	s0,16(sp)
    8000232a:	e426                	sd	s1,8(sp)
    8000232c:	e04a                	sd	s2,0(sp)
    8000232e:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    80002330:	00009797          	auipc	a5,0x9
    80002334:	0a87b783          	ld	a5,168(a5) # 8000b3d8 <sched_pointer>
        if (old_scheduler != sched_pointer)
    80002338:	00009497          	auipc	s1,0x9
    8000233c:	0a048493          	addi	s1,s1,160 # 8000b3d8 <sched_pointer>
            printf("Scheduler switched\n");
    80002340:	00006917          	auipc	s2,0x6
    80002344:	eb890913          	addi	s2,s2,-328 # 800081f8 <etext+0x1f8>
    80002348:	a809                	j	8000235a <scheduler+0x36>
    8000234a:	854a                	mv	a0,s2
    8000234c:	ffffe097          	auipc	ra,0xffffe
    80002350:	25e080e7          	jalr	606(ra) # 800005aa <printf>
        (*sched_pointer)();
    80002354:	609c                	ld	a5,0(s1)
    80002356:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    80002358:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    8000235a:	6098                	ld	a4,0(s1)
    8000235c:	fef717e3          	bne	a4,a5,8000234a <scheduler+0x26>
    80002360:	bfd5                	j	80002354 <scheduler+0x30>

0000000080002362 <sched>:
{
    80002362:	7179                	addi	sp,sp,-48
    80002364:	f406                	sd	ra,40(sp)
    80002366:	f022                	sd	s0,32(sp)
    80002368:	ec26                	sd	s1,24(sp)
    8000236a:	e84a                	sd	s2,16(sp)
    8000236c:	e44e                	sd	s3,8(sp)
    8000236e:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002370:	00000097          	auipc	ra,0x0
    80002374:	924080e7          	jalr	-1756(ra) # 80001c94 <myproc>
    80002378:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	844080e7          	jalr	-1980(ra) # 80000bbe <holding>
    80002382:	c53d                	beqz	a0,800023f0 <sched+0x8e>
    80002384:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002386:	2781                	sext.w	a5,a5
    80002388:	079e                	slli	a5,a5,0x7
    8000238a:	00011717          	auipc	a4,0x11
    8000238e:	3a670713          	addi	a4,a4,934 # 80013730 <cpus>
    80002392:	97ba                	add	a5,a5,a4
    80002394:	5fb8                	lw	a4,120(a5)
    80002396:	4785                	li	a5,1
    80002398:	06f71463          	bne	a4,a5,80002400 <sched+0x9e>
    if (p->state == RUNNING)
    8000239c:	4c98                	lw	a4,24(s1)
    8000239e:	4791                	li	a5,4
    800023a0:	06f70863          	beq	a4,a5,80002410 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023a4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800023a8:	8b89                	andi	a5,a5,2
    if (intr_get())
    800023aa:	ebbd                	bnez	a5,80002420 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    800023ac:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800023ae:	00011917          	auipc	s2,0x11
    800023b2:	38290913          	addi	s2,s2,898 # 80013730 <cpus>
    800023b6:	2781                	sext.w	a5,a5
    800023b8:	079e                	slli	a5,a5,0x7
    800023ba:	97ca                	add	a5,a5,s2
    800023bc:	07c7a983          	lw	s3,124(a5)
    800023c0:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    800023c2:	2581                	sext.w	a1,a1
    800023c4:	059e                	slli	a1,a1,0x7
    800023c6:	05a1                	addi	a1,a1,8
    800023c8:	95ca                	add	a1,a1,s2
    800023ca:	06048513          	addi	a0,s1,96
    800023ce:	00000097          	auipc	ra,0x0
    800023d2:	748080e7          	jalr	1864(ra) # 80002b16 <swtch>
    800023d6:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800023d8:	2781                	sext.w	a5,a5
    800023da:	079e                	slli	a5,a5,0x7
    800023dc:	993e                	add	s2,s2,a5
    800023de:	07392e23          	sw	s3,124(s2)
}
    800023e2:	70a2                	ld	ra,40(sp)
    800023e4:	7402                	ld	s0,32(sp)
    800023e6:	64e2                	ld	s1,24(sp)
    800023e8:	6942                	ld	s2,16(sp)
    800023ea:	69a2                	ld	s3,8(sp)
    800023ec:	6145                	addi	sp,sp,48
    800023ee:	8082                	ret
        panic("sched p->lock");
    800023f0:	00006517          	auipc	a0,0x6
    800023f4:	e2050513          	addi	a0,a0,-480 # 80008210 <etext+0x210>
    800023f8:	ffffe097          	auipc	ra,0xffffe
    800023fc:	168080e7          	jalr	360(ra) # 80000560 <panic>
        panic("sched locks");
    80002400:	00006517          	auipc	a0,0x6
    80002404:	e2050513          	addi	a0,a0,-480 # 80008220 <etext+0x220>
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	158080e7          	jalr	344(ra) # 80000560 <panic>
        panic("sched running");
    80002410:	00006517          	auipc	a0,0x6
    80002414:	e2050513          	addi	a0,a0,-480 # 80008230 <etext+0x230>
    80002418:	ffffe097          	auipc	ra,0xffffe
    8000241c:	148080e7          	jalr	328(ra) # 80000560 <panic>
        panic("sched interruptible");
    80002420:	00006517          	auipc	a0,0x6
    80002424:	e2050513          	addi	a0,a0,-480 # 80008240 <etext+0x240>
    80002428:	ffffe097          	auipc	ra,0xffffe
    8000242c:	138080e7          	jalr	312(ra) # 80000560 <panic>

0000000080002430 <yield>:
{
    80002430:	1101                	addi	sp,sp,-32
    80002432:	ec06                	sd	ra,24(sp)
    80002434:	e822                	sd	s0,16(sp)
    80002436:	e426                	sd	s1,8(sp)
    80002438:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000243a:	00000097          	auipc	ra,0x0
    8000243e:	85a080e7          	jalr	-1958(ra) # 80001c94 <myproc>
    80002442:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002444:	ffffe097          	auipc	ra,0xffffe
    80002448:	7f4080e7          	jalr	2036(ra) # 80000c38 <acquire>
    p->state = RUNNABLE;
    8000244c:	478d                	li	a5,3
    8000244e:	cc9c                	sw	a5,24(s1)
    sched();
    80002450:	00000097          	auipc	ra,0x0
    80002454:	f12080e7          	jalr	-238(ra) # 80002362 <sched>
    release(&p->lock);
    80002458:	8526                	mv	a0,s1
    8000245a:	fffff097          	auipc	ra,0xfffff
    8000245e:	892080e7          	jalr	-1902(ra) # 80000cec <release>
}
    80002462:	60e2                	ld	ra,24(sp)
    80002464:	6442                	ld	s0,16(sp)
    80002466:	64a2                	ld	s1,8(sp)
    80002468:	6105                	addi	sp,sp,32
    8000246a:	8082                	ret

000000008000246c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000246c:	7179                	addi	sp,sp,-48
    8000246e:	f406                	sd	ra,40(sp)
    80002470:	f022                	sd	s0,32(sp)
    80002472:	ec26                	sd	s1,24(sp)
    80002474:	e84a                	sd	s2,16(sp)
    80002476:	e44e                	sd	s3,8(sp)
    80002478:	1800                	addi	s0,sp,48
    8000247a:	89aa                	mv	s3,a0
    8000247c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000247e:	00000097          	auipc	ra,0x0
    80002482:	816080e7          	jalr	-2026(ra) # 80001c94 <myproc>
    80002486:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002488:	ffffe097          	auipc	ra,0xffffe
    8000248c:	7b0080e7          	jalr	1968(ra) # 80000c38 <acquire>
    release(lk);
    80002490:	854a                	mv	a0,s2
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	85a080e7          	jalr	-1958(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    8000249a:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000249e:	4789                	li	a5,2
    800024a0:	cc9c                	sw	a5,24(s1)

    sched();
    800024a2:	00000097          	auipc	ra,0x0
    800024a6:	ec0080e7          	jalr	-320(ra) # 80002362 <sched>

    // Tidy up.
    p->chan = 0;
    800024aa:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800024ae:	8526                	mv	a0,s1
    800024b0:	fffff097          	auipc	ra,0xfffff
    800024b4:	83c080e7          	jalr	-1988(ra) # 80000cec <release>
    acquire(lk);
    800024b8:	854a                	mv	a0,s2
    800024ba:	ffffe097          	auipc	ra,0xffffe
    800024be:	77e080e7          	jalr	1918(ra) # 80000c38 <acquire>
}
    800024c2:	70a2                	ld	ra,40(sp)
    800024c4:	7402                	ld	s0,32(sp)
    800024c6:	64e2                	ld	s1,24(sp)
    800024c8:	6942                	ld	s2,16(sp)
    800024ca:	69a2                	ld	s3,8(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret

00000000800024d0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800024d0:	7139                	addi	sp,sp,-64
    800024d2:	fc06                	sd	ra,56(sp)
    800024d4:	f822                	sd	s0,48(sp)
    800024d6:	f426                	sd	s1,40(sp)
    800024d8:	f04a                	sd	s2,32(sp)
    800024da:	ec4e                	sd	s3,24(sp)
    800024dc:	e852                	sd	s4,16(sp)
    800024de:	e456                	sd	s5,8(sp)
    800024e0:	0080                	addi	s0,sp,64
    800024e2:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800024e4:	00011497          	auipc	s1,0x11
    800024e8:	67c48493          	addi	s1,s1,1660 # 80013b60 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800024ec:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800024ee:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800024f0:	00017917          	auipc	s2,0x17
    800024f4:	27090913          	addi	s2,s2,624 # 80019760 <tickslock>
    800024f8:	a811                	j	8000250c <wakeup+0x3c>
            }
            release(&p->lock);
    800024fa:	8526                	mv	a0,s1
    800024fc:	ffffe097          	auipc	ra,0xffffe
    80002500:	7f0080e7          	jalr	2032(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002504:	17048493          	addi	s1,s1,368
    80002508:	03248663          	beq	s1,s2,80002534 <wakeup+0x64>
        if (p != myproc())
    8000250c:	fffff097          	auipc	ra,0xfffff
    80002510:	788080e7          	jalr	1928(ra) # 80001c94 <myproc>
    80002514:	fea488e3          	beq	s1,a0,80002504 <wakeup+0x34>
            acquire(&p->lock);
    80002518:	8526                	mv	a0,s1
    8000251a:	ffffe097          	auipc	ra,0xffffe
    8000251e:	71e080e7          	jalr	1822(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80002522:	4c9c                	lw	a5,24(s1)
    80002524:	fd379be3          	bne	a5,s3,800024fa <wakeup+0x2a>
    80002528:	709c                	ld	a5,32(s1)
    8000252a:	fd4798e3          	bne	a5,s4,800024fa <wakeup+0x2a>
                p->state = RUNNABLE;
    8000252e:	0154ac23          	sw	s5,24(s1)
    80002532:	b7e1                	j	800024fa <wakeup+0x2a>
        }
    }
}
    80002534:	70e2                	ld	ra,56(sp)
    80002536:	7442                	ld	s0,48(sp)
    80002538:	74a2                	ld	s1,40(sp)
    8000253a:	7902                	ld	s2,32(sp)
    8000253c:	69e2                	ld	s3,24(sp)
    8000253e:	6a42                	ld	s4,16(sp)
    80002540:	6aa2                	ld	s5,8(sp)
    80002542:	6121                	addi	sp,sp,64
    80002544:	8082                	ret

0000000080002546 <reparent>:
{
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	e052                	sd	s4,0(sp)
    80002554:	1800                	addi	s0,sp,48
    80002556:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002558:	00011497          	auipc	s1,0x11
    8000255c:	60848493          	addi	s1,s1,1544 # 80013b60 <proc>
            pp->parent = initproc;
    80002560:	00009a17          	auipc	s4,0x9
    80002564:	f58a0a13          	addi	s4,s4,-168 # 8000b4b8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002568:	00017997          	auipc	s3,0x17
    8000256c:	1f898993          	addi	s3,s3,504 # 80019760 <tickslock>
    80002570:	a029                	j	8000257a <reparent+0x34>
    80002572:	17048493          	addi	s1,s1,368
    80002576:	01348d63          	beq	s1,s3,80002590 <reparent+0x4a>
        if (pp->parent == p)
    8000257a:	7c9c                	ld	a5,56(s1)
    8000257c:	ff279be3          	bne	a5,s2,80002572 <reparent+0x2c>
            pp->parent = initproc;
    80002580:	000a3503          	ld	a0,0(s4)
    80002584:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002586:	00000097          	auipc	ra,0x0
    8000258a:	f4a080e7          	jalr	-182(ra) # 800024d0 <wakeup>
    8000258e:	b7d5                	j	80002572 <reparent+0x2c>
}
    80002590:	70a2                	ld	ra,40(sp)
    80002592:	7402                	ld	s0,32(sp)
    80002594:	64e2                	ld	s1,24(sp)
    80002596:	6942                	ld	s2,16(sp)
    80002598:	69a2                	ld	s3,8(sp)
    8000259a:	6a02                	ld	s4,0(sp)
    8000259c:	6145                	addi	sp,sp,48
    8000259e:	8082                	ret

00000000800025a0 <exit>:
{
    800025a0:	7179                	addi	sp,sp,-48
    800025a2:	f406                	sd	ra,40(sp)
    800025a4:	f022                	sd	s0,32(sp)
    800025a6:	ec26                	sd	s1,24(sp)
    800025a8:	e84a                	sd	s2,16(sp)
    800025aa:	e44e                	sd	s3,8(sp)
    800025ac:	e052                	sd	s4,0(sp)
    800025ae:	1800                	addi	s0,sp,48
    800025b0:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800025b2:	fffff097          	auipc	ra,0xfffff
    800025b6:	6e2080e7          	jalr	1762(ra) # 80001c94 <myproc>
    800025ba:	89aa                	mv	s3,a0
    if (p == initproc)
    800025bc:	00009797          	auipc	a5,0x9
    800025c0:	efc7b783          	ld	a5,-260(a5) # 8000b4b8 <initproc>
    800025c4:	0d050493          	addi	s1,a0,208
    800025c8:	15050913          	addi	s2,a0,336
    800025cc:	02a79363          	bne	a5,a0,800025f2 <exit+0x52>
        panic("init exiting");
    800025d0:	00006517          	auipc	a0,0x6
    800025d4:	c8850513          	addi	a0,a0,-888 # 80008258 <etext+0x258>
    800025d8:	ffffe097          	auipc	ra,0xffffe
    800025dc:	f88080e7          	jalr	-120(ra) # 80000560 <panic>
            fileclose(f);
    800025e0:	00002097          	auipc	ra,0x2
    800025e4:	51a080e7          	jalr	1306(ra) # 80004afa <fileclose>
            p->ofile[fd] = 0;
    800025e8:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800025ec:	04a1                	addi	s1,s1,8
    800025ee:	01248563          	beq	s1,s2,800025f8 <exit+0x58>
        if (p->ofile[fd])
    800025f2:	6088                	ld	a0,0(s1)
    800025f4:	f575                	bnez	a0,800025e0 <exit+0x40>
    800025f6:	bfdd                	j	800025ec <exit+0x4c>
    begin_op();
    800025f8:	00002097          	auipc	ra,0x2
    800025fc:	038080e7          	jalr	56(ra) # 80004630 <begin_op>
    iput(p->cwd);
    80002600:	1509b503          	ld	a0,336(s3)
    80002604:	00002097          	auipc	ra,0x2
    80002608:	81c080e7          	jalr	-2020(ra) # 80003e20 <iput>
    end_op();
    8000260c:	00002097          	auipc	ra,0x2
    80002610:	09e080e7          	jalr	158(ra) # 800046aa <end_op>
    p->cwd = 0;
    80002614:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80002618:	00011497          	auipc	s1,0x11
    8000261c:	53048493          	addi	s1,s1,1328 # 80013b48 <wait_lock>
    80002620:	8526                	mv	a0,s1
    80002622:	ffffe097          	auipc	ra,0xffffe
    80002626:	616080e7          	jalr	1558(ra) # 80000c38 <acquire>
    reparent(p);
    8000262a:	854e                	mv	a0,s3
    8000262c:	00000097          	auipc	ra,0x0
    80002630:	f1a080e7          	jalr	-230(ra) # 80002546 <reparent>
    wakeup(p->parent);
    80002634:	0389b503          	ld	a0,56(s3)
    80002638:	00000097          	auipc	ra,0x0
    8000263c:	e98080e7          	jalr	-360(ra) # 800024d0 <wakeup>
    acquire(&p->lock);
    80002640:	854e                	mv	a0,s3
    80002642:	ffffe097          	auipc	ra,0xffffe
    80002646:	5f6080e7          	jalr	1526(ra) # 80000c38 <acquire>
    p->xstate = status;
    8000264a:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000264e:	4795                	li	a5,5
    80002650:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80002654:	8526                	mv	a0,s1
    80002656:	ffffe097          	auipc	ra,0xffffe
    8000265a:	696080e7          	jalr	1686(ra) # 80000cec <release>
    sched();
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	d04080e7          	jalr	-764(ra) # 80002362 <sched>
    panic("zombie exit");
    80002666:	00006517          	auipc	a0,0x6
    8000266a:	c0250513          	addi	a0,a0,-1022 # 80008268 <etext+0x268>
    8000266e:	ffffe097          	auipc	ra,0xffffe
    80002672:	ef2080e7          	jalr	-270(ra) # 80000560 <panic>

0000000080002676 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002676:	7179                	addi	sp,sp,-48
    80002678:	f406                	sd	ra,40(sp)
    8000267a:	f022                	sd	s0,32(sp)
    8000267c:	ec26                	sd	s1,24(sp)
    8000267e:	e84a                	sd	s2,16(sp)
    80002680:	e44e                	sd	s3,8(sp)
    80002682:	1800                	addi	s0,sp,48
    80002684:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002686:	00011497          	auipc	s1,0x11
    8000268a:	4da48493          	addi	s1,s1,1242 # 80013b60 <proc>
    8000268e:	00017997          	auipc	s3,0x17
    80002692:	0d298993          	addi	s3,s3,210 # 80019760 <tickslock>
    {
        acquire(&p->lock);
    80002696:	8526                	mv	a0,s1
    80002698:	ffffe097          	auipc	ra,0xffffe
    8000269c:	5a0080e7          	jalr	1440(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    800026a0:	589c                	lw	a5,48(s1)
    800026a2:	01278d63          	beq	a5,s2,800026bc <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800026a6:	8526                	mv	a0,s1
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	644080e7          	jalr	1604(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800026b0:	17048493          	addi	s1,s1,368
    800026b4:	ff3491e3          	bne	s1,s3,80002696 <kill+0x20>
    }
    return -1;
    800026b8:	557d                	li	a0,-1
    800026ba:	a829                	j	800026d4 <kill+0x5e>
            p->killed = 1;
    800026bc:	4785                	li	a5,1
    800026be:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    800026c0:	4c98                	lw	a4,24(s1)
    800026c2:	4789                	li	a5,2
    800026c4:	00f70f63          	beq	a4,a5,800026e2 <kill+0x6c>
            release(&p->lock);
    800026c8:	8526                	mv	a0,s1
    800026ca:	ffffe097          	auipc	ra,0xffffe
    800026ce:	622080e7          	jalr	1570(ra) # 80000cec <release>
            return 0;
    800026d2:	4501                	li	a0,0
}
    800026d4:	70a2                	ld	ra,40(sp)
    800026d6:	7402                	ld	s0,32(sp)
    800026d8:	64e2                	ld	s1,24(sp)
    800026da:	6942                	ld	s2,16(sp)
    800026dc:	69a2                	ld	s3,8(sp)
    800026de:	6145                	addi	sp,sp,48
    800026e0:	8082                	ret
                p->state = RUNNABLE;
    800026e2:	478d                	li	a5,3
    800026e4:	cc9c                	sw	a5,24(s1)
    800026e6:	b7cd                	j	800026c8 <kill+0x52>

00000000800026e8 <setkilled>:

void setkilled(struct proc *p)
{
    800026e8:	1101                	addi	sp,sp,-32
    800026ea:	ec06                	sd	ra,24(sp)
    800026ec:	e822                	sd	s0,16(sp)
    800026ee:	e426                	sd	s1,8(sp)
    800026f0:	1000                	addi	s0,sp,32
    800026f2:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800026f4:	ffffe097          	auipc	ra,0xffffe
    800026f8:	544080e7          	jalr	1348(ra) # 80000c38 <acquire>
    p->killed = 1;
    800026fc:	4785                	li	a5,1
    800026fe:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002700:	8526                	mv	a0,s1
    80002702:	ffffe097          	auipc	ra,0xffffe
    80002706:	5ea080e7          	jalr	1514(ra) # 80000cec <release>
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret

0000000080002714 <killed>:

int killed(struct proc *p)
{
    80002714:	1101                	addi	sp,sp,-32
    80002716:	ec06                	sd	ra,24(sp)
    80002718:	e822                	sd	s0,16(sp)
    8000271a:	e426                	sd	s1,8(sp)
    8000271c:	e04a                	sd	s2,0(sp)
    8000271e:	1000                	addi	s0,sp,32
    80002720:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002722:	ffffe097          	auipc	ra,0xffffe
    80002726:	516080e7          	jalr	1302(ra) # 80000c38 <acquire>
    k = p->killed;
    8000272a:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    8000272e:	8526                	mv	a0,s1
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	5bc080e7          	jalr	1468(ra) # 80000cec <release>
    return k;
}
    80002738:	854a                	mv	a0,s2
    8000273a:	60e2                	ld	ra,24(sp)
    8000273c:	6442                	ld	s0,16(sp)
    8000273e:	64a2                	ld	s1,8(sp)
    80002740:	6902                	ld	s2,0(sp)
    80002742:	6105                	addi	sp,sp,32
    80002744:	8082                	ret

0000000080002746 <wait>:
{
    80002746:	715d                	addi	sp,sp,-80
    80002748:	e486                	sd	ra,72(sp)
    8000274a:	e0a2                	sd	s0,64(sp)
    8000274c:	fc26                	sd	s1,56(sp)
    8000274e:	f84a                	sd	s2,48(sp)
    80002750:	f44e                	sd	s3,40(sp)
    80002752:	f052                	sd	s4,32(sp)
    80002754:	ec56                	sd	s5,24(sp)
    80002756:	e85a                	sd	s6,16(sp)
    80002758:	e45e                	sd	s7,8(sp)
    8000275a:	e062                	sd	s8,0(sp)
    8000275c:	0880                	addi	s0,sp,80
    8000275e:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002760:	fffff097          	auipc	ra,0xfffff
    80002764:	534080e7          	jalr	1332(ra) # 80001c94 <myproc>
    80002768:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000276a:	00011517          	auipc	a0,0x11
    8000276e:	3de50513          	addi	a0,a0,990 # 80013b48 <wait_lock>
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	4c6080e7          	jalr	1222(ra) # 80000c38 <acquire>
        havekids = 0;
    8000277a:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    8000277c:	4a15                	li	s4,5
                havekids = 1;
    8000277e:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002780:	00017997          	auipc	s3,0x17
    80002784:	fe098993          	addi	s3,s3,-32 # 80019760 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002788:	00011c17          	auipc	s8,0x11
    8000278c:	3c0c0c13          	addi	s8,s8,960 # 80013b48 <wait_lock>
    80002790:	a0d1                	j	80002854 <wait+0x10e>
                    pid = pp->pid;
    80002792:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002796:	000b0e63          	beqz	s6,800027b2 <wait+0x6c>
    8000279a:	4691                	li	a3,4
    8000279c:	02c48613          	addi	a2,s1,44
    800027a0:	85da                	mv	a1,s6
    800027a2:	05093503          	ld	a0,80(s2)
    800027a6:	fffff097          	auipc	ra,0xfffff
    800027aa:	f3c080e7          	jalr	-196(ra) # 800016e2 <copyout>
    800027ae:	04054163          	bltz	a0,800027f0 <wait+0xaa>
                    freeproc(pp);
    800027b2:	8526                	mv	a0,s1
    800027b4:	fffff097          	auipc	ra,0xfffff
    800027b8:	692080e7          	jalr	1682(ra) # 80001e46 <freeproc>
                    release(&pp->lock);
    800027bc:	8526                	mv	a0,s1
    800027be:	ffffe097          	auipc	ra,0xffffe
    800027c2:	52e080e7          	jalr	1326(ra) # 80000cec <release>
                    release(&wait_lock);
    800027c6:	00011517          	auipc	a0,0x11
    800027ca:	38250513          	addi	a0,a0,898 # 80013b48 <wait_lock>
    800027ce:	ffffe097          	auipc	ra,0xffffe
    800027d2:	51e080e7          	jalr	1310(ra) # 80000cec <release>
}
    800027d6:	854e                	mv	a0,s3
    800027d8:	60a6                	ld	ra,72(sp)
    800027da:	6406                	ld	s0,64(sp)
    800027dc:	74e2                	ld	s1,56(sp)
    800027de:	7942                	ld	s2,48(sp)
    800027e0:	79a2                	ld	s3,40(sp)
    800027e2:	7a02                	ld	s4,32(sp)
    800027e4:	6ae2                	ld	s5,24(sp)
    800027e6:	6b42                	ld	s6,16(sp)
    800027e8:	6ba2                	ld	s7,8(sp)
    800027ea:	6c02                	ld	s8,0(sp)
    800027ec:	6161                	addi	sp,sp,80
    800027ee:	8082                	ret
                        release(&pp->lock);
    800027f0:	8526                	mv	a0,s1
    800027f2:	ffffe097          	auipc	ra,0xffffe
    800027f6:	4fa080e7          	jalr	1274(ra) # 80000cec <release>
                        release(&wait_lock);
    800027fa:	00011517          	auipc	a0,0x11
    800027fe:	34e50513          	addi	a0,a0,846 # 80013b48 <wait_lock>
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	4ea080e7          	jalr	1258(ra) # 80000cec <release>
                        return -1;
    8000280a:	59fd                	li	s3,-1
    8000280c:	b7e9                	j	800027d6 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000280e:	17048493          	addi	s1,s1,368
    80002812:	03348463          	beq	s1,s3,8000283a <wait+0xf4>
            if (pp->parent == p)
    80002816:	7c9c                	ld	a5,56(s1)
    80002818:	ff279be3          	bne	a5,s2,8000280e <wait+0xc8>
                acquire(&pp->lock);
    8000281c:	8526                	mv	a0,s1
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	41a080e7          	jalr	1050(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    80002826:	4c9c                	lw	a5,24(s1)
    80002828:	f74785e3          	beq	a5,s4,80002792 <wait+0x4c>
                release(&pp->lock);
    8000282c:	8526                	mv	a0,s1
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	4be080e7          	jalr	1214(ra) # 80000cec <release>
                havekids = 1;
    80002836:	8756                	mv	a4,s5
    80002838:	bfd9                	j	8000280e <wait+0xc8>
        if (!havekids || killed(p))
    8000283a:	c31d                	beqz	a4,80002860 <wait+0x11a>
    8000283c:	854a                	mv	a0,s2
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	ed6080e7          	jalr	-298(ra) # 80002714 <killed>
    80002846:	ed09                	bnez	a0,80002860 <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002848:	85e2                	mv	a1,s8
    8000284a:	854a                	mv	a0,s2
    8000284c:	00000097          	auipc	ra,0x0
    80002850:	c20080e7          	jalr	-992(ra) # 8000246c <sleep>
        havekids = 0;
    80002854:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002856:	00011497          	auipc	s1,0x11
    8000285a:	30a48493          	addi	s1,s1,778 # 80013b60 <proc>
    8000285e:	bf65                	j	80002816 <wait+0xd0>
            release(&wait_lock);
    80002860:	00011517          	auipc	a0,0x11
    80002864:	2e850513          	addi	a0,a0,744 # 80013b48 <wait_lock>
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	484080e7          	jalr	1156(ra) # 80000cec <release>
            return -1;
    80002870:	59fd                	li	s3,-1
    80002872:	b795                	j	800027d6 <wait+0x90>

0000000080002874 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002874:	7179                	addi	sp,sp,-48
    80002876:	f406                	sd	ra,40(sp)
    80002878:	f022                	sd	s0,32(sp)
    8000287a:	ec26                	sd	s1,24(sp)
    8000287c:	e84a                	sd	s2,16(sp)
    8000287e:	e44e                	sd	s3,8(sp)
    80002880:	e052                	sd	s4,0(sp)
    80002882:	1800                	addi	s0,sp,48
    80002884:	84aa                	mv	s1,a0
    80002886:	892e                	mv	s2,a1
    80002888:	89b2                	mv	s3,a2
    8000288a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000288c:	fffff097          	auipc	ra,0xfffff
    80002890:	408080e7          	jalr	1032(ra) # 80001c94 <myproc>
    if (user_dst)
    80002894:	c08d                	beqz	s1,800028b6 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002896:	86d2                	mv	a3,s4
    80002898:	864e                	mv	a2,s3
    8000289a:	85ca                	mv	a1,s2
    8000289c:	6928                	ld	a0,80(a0)
    8000289e:	fffff097          	auipc	ra,0xfffff
    800028a2:	e44080e7          	jalr	-444(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    800028a6:	70a2                	ld	ra,40(sp)
    800028a8:	7402                	ld	s0,32(sp)
    800028aa:	64e2                	ld	s1,24(sp)
    800028ac:	6942                	ld	s2,16(sp)
    800028ae:	69a2                	ld	s3,8(sp)
    800028b0:	6a02                	ld	s4,0(sp)
    800028b2:	6145                	addi	sp,sp,48
    800028b4:	8082                	ret
        memmove((char *)dst, src, len);
    800028b6:	000a061b          	sext.w	a2,s4
    800028ba:	85ce                	mv	a1,s3
    800028bc:	854a                	mv	a0,s2
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	4d2080e7          	jalr	1234(ra) # 80000d90 <memmove>
        return 0;
    800028c6:	8526                	mv	a0,s1
    800028c8:	bff9                	j	800028a6 <either_copyout+0x32>

00000000800028ca <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028ca:	7179                	addi	sp,sp,-48
    800028cc:	f406                	sd	ra,40(sp)
    800028ce:	f022                	sd	s0,32(sp)
    800028d0:	ec26                	sd	s1,24(sp)
    800028d2:	e84a                	sd	s2,16(sp)
    800028d4:	e44e                	sd	s3,8(sp)
    800028d6:	e052                	sd	s4,0(sp)
    800028d8:	1800                	addi	s0,sp,48
    800028da:	892a                	mv	s2,a0
    800028dc:	84ae                	mv	s1,a1
    800028de:	89b2                	mv	s3,a2
    800028e0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800028e2:	fffff097          	auipc	ra,0xfffff
    800028e6:	3b2080e7          	jalr	946(ra) # 80001c94 <myproc>
    if (user_src)
    800028ea:	c08d                	beqz	s1,8000290c <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800028ec:	86d2                	mv	a3,s4
    800028ee:	864e                	mv	a2,s3
    800028f0:	85ca                	mv	a1,s2
    800028f2:	6928                	ld	a0,80(a0)
    800028f4:	fffff097          	auipc	ra,0xfffff
    800028f8:	e7a080e7          	jalr	-390(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800028fc:	70a2                	ld	ra,40(sp)
    800028fe:	7402                	ld	s0,32(sp)
    80002900:	64e2                	ld	s1,24(sp)
    80002902:	6942                	ld	s2,16(sp)
    80002904:	69a2                	ld	s3,8(sp)
    80002906:	6a02                	ld	s4,0(sp)
    80002908:	6145                	addi	sp,sp,48
    8000290a:	8082                	ret
        memmove(dst, (char *)src, len);
    8000290c:	000a061b          	sext.w	a2,s4
    80002910:	85ce                	mv	a1,s3
    80002912:	854a                	mv	a0,s2
    80002914:	ffffe097          	auipc	ra,0xffffe
    80002918:	47c080e7          	jalr	1148(ra) # 80000d90 <memmove>
        return 0;
    8000291c:	8526                	mv	a0,s1
    8000291e:	bff9                	j	800028fc <either_copyin+0x32>

0000000080002920 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002920:	715d                	addi	sp,sp,-80
    80002922:	e486                	sd	ra,72(sp)
    80002924:	e0a2                	sd	s0,64(sp)
    80002926:	fc26                	sd	s1,56(sp)
    80002928:	f84a                	sd	s2,48(sp)
    8000292a:	f44e                	sd	s3,40(sp)
    8000292c:	f052                	sd	s4,32(sp)
    8000292e:	ec56                	sd	s5,24(sp)
    80002930:	e85a                	sd	s6,16(sp)
    80002932:	e45e                	sd	s7,8(sp)
    80002934:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002936:	00005517          	auipc	a0,0x5
    8000293a:	6da50513          	addi	a0,a0,1754 # 80008010 <etext+0x10>
    8000293e:	ffffe097          	auipc	ra,0xffffe
    80002942:	c6c080e7          	jalr	-916(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002946:	00011497          	auipc	s1,0x11
    8000294a:	37248493          	addi	s1,s1,882 # 80013cb8 <proc+0x158>
    8000294e:	00017917          	auipc	s2,0x17
    80002952:	f6a90913          	addi	s2,s2,-150 # 800198b8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002956:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002958:	00006997          	auipc	s3,0x6
    8000295c:	92098993          	addi	s3,s3,-1760 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    80002960:	00006a97          	auipc	s5,0x6
    80002964:	920a8a93          	addi	s5,s5,-1760 # 80008280 <etext+0x280>
        printf("\n");
    80002968:	00005a17          	auipc	s4,0x5
    8000296c:	6a8a0a13          	addi	s4,s4,1704 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002970:	00006b97          	auipc	s7,0x6
    80002974:	eb8b8b93          	addi	s7,s7,-328 # 80008828 <states.0>
    80002978:	a00d                	j	8000299a <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    8000297a:	ed86a583          	lw	a1,-296(a3)
    8000297e:	8556                	mv	a0,s5
    80002980:	ffffe097          	auipc	ra,0xffffe
    80002984:	c2a080e7          	jalr	-982(ra) # 800005aa <printf>
        printf("\n");
    80002988:	8552                	mv	a0,s4
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	c20080e7          	jalr	-992(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002992:	17048493          	addi	s1,s1,368
    80002996:	03248263          	beq	s1,s2,800029ba <procdump+0x9a>
        if (p->state == UNUSED)
    8000299a:	86a6                	mv	a3,s1
    8000299c:	ec04a783          	lw	a5,-320(s1)
    800029a0:	dbed                	beqz	a5,80002992 <procdump+0x72>
            state = "???";
    800029a2:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029a4:	fcfb6be3          	bltu	s6,a5,8000297a <procdump+0x5a>
    800029a8:	02079713          	slli	a4,a5,0x20
    800029ac:	01d75793          	srli	a5,a4,0x1d
    800029b0:	97de                	add	a5,a5,s7
    800029b2:	6390                	ld	a2,0(a5)
    800029b4:	f279                	bnez	a2,8000297a <procdump+0x5a>
            state = "???";
    800029b6:	864e                	mv	a2,s3
    800029b8:	b7c9                	j	8000297a <procdump+0x5a>
    }
}
    800029ba:	60a6                	ld	ra,72(sp)
    800029bc:	6406                	ld	s0,64(sp)
    800029be:	74e2                	ld	s1,56(sp)
    800029c0:	7942                	ld	s2,48(sp)
    800029c2:	79a2                	ld	s3,40(sp)
    800029c4:	7a02                	ld	s4,32(sp)
    800029c6:	6ae2                	ld	s5,24(sp)
    800029c8:	6b42                	ld	s6,16(sp)
    800029ca:	6ba2                	ld	s7,8(sp)
    800029cc:	6161                	addi	sp,sp,80
    800029ce:	8082                	ret

00000000800029d0 <schedls>:

void schedls()
{
    800029d0:	1101                	addi	sp,sp,-32
    800029d2:	ec06                	sd	ra,24(sp)
    800029d4:	e822                	sd	s0,16(sp)
    800029d6:	e426                	sd	s1,8(sp)
    800029d8:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    800029da:	00006517          	auipc	a0,0x6
    800029de:	8b650513          	addi	a0,a0,-1866 # 80008290 <etext+0x290>
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	bc8080e7          	jalr	-1080(ra) # 800005aa <printf>
    printf("====================================\n");
    800029ea:	00006517          	auipc	a0,0x6
    800029ee:	8ce50513          	addi	a0,a0,-1842 # 800082b8 <etext+0x2b8>
    800029f2:	ffffe097          	auipc	ra,0xffffe
    800029f6:	bb8080e7          	jalr	-1096(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    800029fa:	00009717          	auipc	a4,0x9
    800029fe:	a3e73703          	ld	a4,-1474(a4) # 8000b438 <available_schedulers+0x10>
    80002a02:	00009797          	auipc	a5,0x9
    80002a06:	9d67b783          	ld	a5,-1578(a5) # 8000b3d8 <sched_pointer>
    80002a0a:	08f70763          	beq	a4,a5,80002a98 <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	8d250513          	addi	a0,a0,-1838 # 800082e0 <etext+0x2e0>
    80002a16:	ffffe097          	auipc	ra,0xffffe
    80002a1a:	b94080e7          	jalr	-1132(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a1e:	00009497          	auipc	s1,0x9
    80002a22:	9d248493          	addi	s1,s1,-1582 # 8000b3f0 <initcode>
    80002a26:	48b0                	lw	a2,80(s1)
    80002a28:	00009597          	auipc	a1,0x9
    80002a2c:	a0058593          	addi	a1,a1,-1536 # 8000b428 <available_schedulers>
    80002a30:	00006517          	auipc	a0,0x6
    80002a34:	8c050513          	addi	a0,a0,-1856 # 800082f0 <etext+0x2f0>
    80002a38:	ffffe097          	auipc	ra,0xffffe
    80002a3c:	b72080e7          	jalr	-1166(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    80002a40:	74b8                	ld	a4,104(s1)
    80002a42:	00009797          	auipc	a5,0x9
    80002a46:	9967b783          	ld	a5,-1642(a5) # 8000b3d8 <sched_pointer>
    80002a4a:	06f70063          	beq	a4,a5,80002aaa <schedls+0xda>
            printf("   \t");
    80002a4e:	00006517          	auipc	a0,0x6
    80002a52:	89250513          	addi	a0,a0,-1902 # 800082e0 <etext+0x2e0>
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	b54080e7          	jalr	-1196(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a5e:	00009617          	auipc	a2,0x9
    80002a62:	a0262603          	lw	a2,-1534(a2) # 8000b460 <available_schedulers+0x38>
    80002a66:	00009597          	auipc	a1,0x9
    80002a6a:	9e258593          	addi	a1,a1,-1566 # 8000b448 <available_schedulers+0x20>
    80002a6e:	00006517          	auipc	a0,0x6
    80002a72:	88250513          	addi	a0,a0,-1918 # 800082f0 <etext+0x2f0>
    80002a76:	ffffe097          	auipc	ra,0xffffe
    80002a7a:	b34080e7          	jalr	-1228(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002a7e:	00006517          	auipc	a0,0x6
    80002a82:	87a50513          	addi	a0,a0,-1926 # 800082f8 <etext+0x2f8>
    80002a86:	ffffe097          	auipc	ra,0xffffe
    80002a8a:	b24080e7          	jalr	-1244(ra) # 800005aa <printf>
}
    80002a8e:	60e2                	ld	ra,24(sp)
    80002a90:	6442                	ld	s0,16(sp)
    80002a92:	64a2                	ld	s1,8(sp)
    80002a94:	6105                	addi	sp,sp,32
    80002a96:	8082                	ret
            printf("[*]\t");
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	85050513          	addi	a0,a0,-1968 # 800082e8 <etext+0x2e8>
    80002aa0:	ffffe097          	auipc	ra,0xffffe
    80002aa4:	b0a080e7          	jalr	-1270(ra) # 800005aa <printf>
    80002aa8:	bf9d                	j	80002a1e <schedls+0x4e>
    80002aaa:	00006517          	auipc	a0,0x6
    80002aae:	83e50513          	addi	a0,a0,-1986 # 800082e8 <etext+0x2e8>
    80002ab2:	ffffe097          	auipc	ra,0xffffe
    80002ab6:	af8080e7          	jalr	-1288(ra) # 800005aa <printf>
    80002aba:	b755                	j	80002a5e <schedls+0x8e>

0000000080002abc <schedset>:

void schedset(int id)
{
    80002abc:	1141                	addi	sp,sp,-16
    80002abe:	e406                	sd	ra,8(sp)
    80002ac0:	e022                	sd	s0,0(sp)
    80002ac2:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002ac4:	4705                	li	a4,1
    80002ac6:	02a76f63          	bltu	a4,a0,80002b04 <schedset+0x48>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002aca:	00551793          	slli	a5,a0,0x5
    80002ace:	00009717          	auipc	a4,0x9
    80002ad2:	92270713          	addi	a4,a4,-1758 # 8000b3f0 <initcode>
    80002ad6:	973e                	add	a4,a4,a5
    80002ad8:	6738                	ld	a4,72(a4)
    80002ada:	00009697          	auipc	a3,0x9
    80002ade:	8ee6bf23          	sd	a4,-1794(a3) # 8000b3d8 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002ae2:	00009597          	auipc	a1,0x9
    80002ae6:	94658593          	addi	a1,a1,-1722 # 8000b428 <available_schedulers>
    80002aea:	95be                	add	a1,a1,a5
    80002aec:	00006517          	auipc	a0,0x6
    80002af0:	84c50513          	addi	a0,a0,-1972 # 80008338 <etext+0x338>
    80002af4:	ffffe097          	auipc	ra,0xffffe
    80002af8:	ab6080e7          	jalr	-1354(ra) # 800005aa <printf>
    80002afc:	60a2                	ld	ra,8(sp)
    80002afe:	6402                	ld	s0,0(sp)
    80002b00:	0141                	addi	sp,sp,16
    80002b02:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002b04:	00006517          	auipc	a0,0x6
    80002b08:	80c50513          	addi	a0,a0,-2036 # 80008310 <etext+0x310>
    80002b0c:	ffffe097          	auipc	ra,0xffffe
    80002b10:	a9e080e7          	jalr	-1378(ra) # 800005aa <printf>
        return;
    80002b14:	b7e5                	j	80002afc <schedset+0x40>

0000000080002b16 <swtch>:
    80002b16:	00153023          	sd	ra,0(a0)
    80002b1a:	00253423          	sd	sp,8(a0)
    80002b1e:	e900                	sd	s0,16(a0)
    80002b20:	ed04                	sd	s1,24(a0)
    80002b22:	03253023          	sd	s2,32(a0)
    80002b26:	03353423          	sd	s3,40(a0)
    80002b2a:	03453823          	sd	s4,48(a0)
    80002b2e:	03553c23          	sd	s5,56(a0)
    80002b32:	05653023          	sd	s6,64(a0)
    80002b36:	05753423          	sd	s7,72(a0)
    80002b3a:	05853823          	sd	s8,80(a0)
    80002b3e:	05953c23          	sd	s9,88(a0)
    80002b42:	07a53023          	sd	s10,96(a0)
    80002b46:	07b53423          	sd	s11,104(a0)
    80002b4a:	0005b083          	ld	ra,0(a1)
    80002b4e:	0085b103          	ld	sp,8(a1)
    80002b52:	6980                	ld	s0,16(a1)
    80002b54:	6d84                	ld	s1,24(a1)
    80002b56:	0205b903          	ld	s2,32(a1)
    80002b5a:	0285b983          	ld	s3,40(a1)
    80002b5e:	0305ba03          	ld	s4,48(a1)
    80002b62:	0385ba83          	ld	s5,56(a1)
    80002b66:	0405bb03          	ld	s6,64(a1)
    80002b6a:	0485bb83          	ld	s7,72(a1)
    80002b6e:	0505bc03          	ld	s8,80(a1)
    80002b72:	0585bc83          	ld	s9,88(a1)
    80002b76:	0605bd03          	ld	s10,96(a1)
    80002b7a:	0685bd83          	ld	s11,104(a1)
    80002b7e:	8082                	ret

0000000080002b80 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b80:	1141                	addi	sp,sp,-16
    80002b82:	e406                	sd	ra,8(sp)
    80002b84:	e022                	sd	s0,0(sp)
    80002b86:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002b88:	00006597          	auipc	a1,0x6
    80002b8c:	80858593          	addi	a1,a1,-2040 # 80008390 <etext+0x390>
    80002b90:	00017517          	auipc	a0,0x17
    80002b94:	bd050513          	addi	a0,a0,-1072 # 80019760 <tickslock>
    80002b98:	ffffe097          	auipc	ra,0xffffe
    80002b9c:	010080e7          	jalr	16(ra) # 80000ba8 <initlock>
}
    80002ba0:	60a2                	ld	ra,8(sp)
    80002ba2:	6402                	ld	s0,0(sp)
    80002ba4:	0141                	addi	sp,sp,16
    80002ba6:	8082                	ret

0000000080002ba8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002ba8:	1141                	addi	sp,sp,-16
    80002baa:	e422                	sd	s0,8(sp)
    80002bac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bae:	00003797          	auipc	a5,0x3
    80002bb2:	65278793          	addi	a5,a5,1618 # 80006200 <kernelvec>
    80002bb6:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002bba:	6422                	ld	s0,8(sp)
    80002bbc:	0141                	addi	sp,sp,16
    80002bbe:	8082                	ret

0000000080002bc0 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002bc0:	1141                	addi	sp,sp,-16
    80002bc2:	e406                	sd	ra,8(sp)
    80002bc4:	e022                	sd	s0,0(sp)
    80002bc6:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	0cc080e7          	jalr	204(ra) # 80001c94 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002bd4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bd6:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002bda:	00004697          	auipc	a3,0x4
    80002bde:	42668693          	addi	a3,a3,1062 # 80007000 <_trampoline>
    80002be2:	00004717          	auipc	a4,0x4
    80002be6:	41e70713          	addi	a4,a4,1054 # 80007000 <_trampoline>
    80002bea:	8f15                	sub	a4,a4,a3
    80002bec:	040007b7          	lui	a5,0x4000
    80002bf0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bf2:	07b2                	slli	a5,a5,0xc
    80002bf4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bf6:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002bfa:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002bfc:	18002673          	csrr	a2,satp
    80002c00:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c02:	6d30                	ld	a2,88(a0)
    80002c04:	6138                	ld	a4,64(a0)
    80002c06:	6585                	lui	a1,0x1
    80002c08:	972e                	add	a4,a4,a1
    80002c0a:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002c0c:	6d38                	ld	a4,88(a0)
    80002c0e:	00000617          	auipc	a2,0x0
    80002c12:	13860613          	addi	a2,a2,312 # 80002d46 <usertrap>
    80002c16:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002c18:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c1a:	8612                	mv	a2,tp
    80002c1c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c1e:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c22:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c26:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c2a:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002c2e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c30:	6f18                	ld	a4,24(a4)
    80002c32:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002c36:	6928                	ld	a0,80(a0)
    80002c38:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c3a:	00004717          	auipc	a4,0x4
    80002c3e:	46270713          	addi	a4,a4,1122 # 8000709c <userret>
    80002c42:	8f15                	sub	a4,a4,a3
    80002c44:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002c46:	577d                	li	a4,-1
    80002c48:	177e                	slli	a4,a4,0x3f
    80002c4a:	8d59                	or	a0,a0,a4
    80002c4c:	9782                	jalr	a5
}
    80002c4e:	60a2                	ld	ra,8(sp)
    80002c50:	6402                	ld	s0,0(sp)
    80002c52:	0141                	addi	sp,sp,16
    80002c54:	8082                	ret

0000000080002c56 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002c56:	1101                	addi	sp,sp,-32
    80002c58:	ec06                	sd	ra,24(sp)
    80002c5a:	e822                	sd	s0,16(sp)
    80002c5c:	e426                	sd	s1,8(sp)
    80002c5e:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002c60:	00017497          	auipc	s1,0x17
    80002c64:	b0048493          	addi	s1,s1,-1280 # 80019760 <tickslock>
    80002c68:	8526                	mv	a0,s1
    80002c6a:	ffffe097          	auipc	ra,0xffffe
    80002c6e:	fce080e7          	jalr	-50(ra) # 80000c38 <acquire>
    ticks++;
    80002c72:	00009517          	auipc	a0,0x9
    80002c76:	84e50513          	addi	a0,a0,-1970 # 8000b4c0 <ticks>
    80002c7a:	411c                	lw	a5,0(a0)
    80002c7c:	2785                	addiw	a5,a5,1
    80002c7e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	850080e7          	jalr	-1968(ra) # 800024d0 <wakeup>
    release(&tickslock);
    80002c88:	8526                	mv	a0,s1
    80002c8a:	ffffe097          	auipc	ra,0xffffe
    80002c8e:	062080e7          	jalr	98(ra) # 80000cec <release>
}
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	64a2                	ld	s1,8(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret

0000000080002c9c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c9c:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002ca0:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002ca2:	0a07d163          	bgez	a5,80002d44 <devintr+0xa8>
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002cae:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002cb2:	46a5                	li	a3,9
    80002cb4:	00d70c63          	beq	a4,a3,80002ccc <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002cb8:	577d                	li	a4,-1
    80002cba:	177e                	slli	a4,a4,0x3f
    80002cbc:	0705                	addi	a4,a4,1
        return 0;
    80002cbe:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002cc0:	06e78163          	beq	a5,a4,80002d22 <devintr+0x86>
    }
}
    80002cc4:	60e2                	ld	ra,24(sp)
    80002cc6:	6442                	ld	s0,16(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret
    80002ccc:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	63e080e7          	jalr	1598(ra) # 8000630c <plic_claim>
    80002cd6:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002cd8:	47a9                	li	a5,10
    80002cda:	00f50963          	beq	a0,a5,80002cec <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002cde:	4785                	li	a5,1
    80002ce0:	00f50b63          	beq	a0,a5,80002cf6 <devintr+0x5a>
        return 1;
    80002ce4:	4505                	li	a0,1
        else if (irq)
    80002ce6:	ec89                	bnez	s1,80002d00 <devintr+0x64>
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	bfe9                	j	80002cc4 <devintr+0x28>
            uartintr();
    80002cec:	ffffe097          	auipc	ra,0xffffe
    80002cf0:	d0e080e7          	jalr	-754(ra) # 800009fa <uartintr>
        if (irq)
    80002cf4:	a839                	j	80002d12 <devintr+0x76>
            virtio_disk_intr();
    80002cf6:	00004097          	auipc	ra,0x4
    80002cfa:	b40080e7          	jalr	-1216(ra) # 80006836 <virtio_disk_intr>
        if (irq)
    80002cfe:	a811                	j	80002d12 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002d00:	85a6                	mv	a1,s1
    80002d02:	00005517          	auipc	a0,0x5
    80002d06:	69650513          	addi	a0,a0,1686 # 80008398 <etext+0x398>
    80002d0a:	ffffe097          	auipc	ra,0xffffe
    80002d0e:	8a0080e7          	jalr	-1888(ra) # 800005aa <printf>
            plic_complete(irq);
    80002d12:	8526                	mv	a0,s1
    80002d14:	00003097          	auipc	ra,0x3
    80002d18:	61c080e7          	jalr	1564(ra) # 80006330 <plic_complete>
        return 1;
    80002d1c:	4505                	li	a0,1
    80002d1e:	64a2                	ld	s1,8(sp)
    80002d20:	b755                	j	80002cc4 <devintr+0x28>
        if (cpuid() == 0)
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	f46080e7          	jalr	-186(ra) # 80001c68 <cpuid>
    80002d2a:	c901                	beqz	a0,80002d3a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002d2c:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002d30:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002d32:	14479073          	csrw	sip,a5
        return 2;
    80002d36:	4509                	li	a0,2
    80002d38:	b771                	j	80002cc4 <devintr+0x28>
            clockintr();
    80002d3a:	00000097          	auipc	ra,0x0
    80002d3e:	f1c080e7          	jalr	-228(ra) # 80002c56 <clockintr>
    80002d42:	b7ed                	j	80002d2c <devintr+0x90>
}
    80002d44:	8082                	ret

0000000080002d46 <usertrap>:
{
    80002d46:	1101                	addi	sp,sp,-32
    80002d48:	ec06                	sd	ra,24(sp)
    80002d4a:	e822                	sd	s0,16(sp)
    80002d4c:	e426                	sd	s1,8(sp)
    80002d4e:	e04a                	sd	s2,0(sp)
    80002d50:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d52:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002d56:	1007f793          	andi	a5,a5,256
    80002d5a:	e3b1                	bnez	a5,80002d9e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d5c:	00003797          	auipc	a5,0x3
    80002d60:	4a478793          	addi	a5,a5,1188 # 80006200 <kernelvec>
    80002d64:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002d68:	fffff097          	auipc	ra,0xfffff
    80002d6c:	f2c080e7          	jalr	-212(ra) # 80001c94 <myproc>
    80002d70:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002d72:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d74:	14102773          	csrr	a4,sepc
    80002d78:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d7a:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002d7e:	47a1                	li	a5,8
    80002d80:	02f70763          	beq	a4,a5,80002dae <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	f18080e7          	jalr	-232(ra) # 80002c9c <devintr>
    80002d8c:	892a                	mv	s2,a0
    80002d8e:	c151                	beqz	a0,80002e12 <usertrap+0xcc>
    if (killed(p))
    80002d90:	8526                	mv	a0,s1
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	982080e7          	jalr	-1662(ra) # 80002714 <killed>
    80002d9a:	c929                	beqz	a0,80002dec <usertrap+0xa6>
    80002d9c:	a099                	j	80002de2 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002d9e:	00005517          	auipc	a0,0x5
    80002da2:	61a50513          	addi	a0,a0,1562 # 800083b8 <etext+0x3b8>
    80002da6:	ffffd097          	auipc	ra,0xffffd
    80002daa:	7ba080e7          	jalr	1978(ra) # 80000560 <panic>
        if (killed(p))
    80002dae:	00000097          	auipc	ra,0x0
    80002db2:	966080e7          	jalr	-1690(ra) # 80002714 <killed>
    80002db6:	e921                	bnez	a0,80002e06 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002db8:	6cb8                	ld	a4,88(s1)
    80002dba:	6f1c                	ld	a5,24(a4)
    80002dbc:	0791                	addi	a5,a5,4
    80002dbe:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dc0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002dc4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dc8:	10079073          	csrw	sstatus,a5
        syscall();
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	2d8080e7          	jalr	728(ra) # 800030a4 <syscall>
    if (killed(p))
    80002dd4:	8526                	mv	a0,s1
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	93e080e7          	jalr	-1730(ra) # 80002714 <killed>
    80002dde:	c911                	beqz	a0,80002df2 <usertrap+0xac>
    80002de0:	4901                	li	s2,0
        exit(-1);
    80002de2:	557d                	li	a0,-1
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	7bc080e7          	jalr	1980(ra) # 800025a0 <exit>
    if (which_dev == 2)
    80002dec:	4789                	li	a5,2
    80002dee:	04f90f63          	beq	s2,a5,80002e4c <usertrap+0x106>
    usertrapret();
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	dce080e7          	jalr	-562(ra) # 80002bc0 <usertrapret>
}
    80002dfa:	60e2                	ld	ra,24(sp)
    80002dfc:	6442                	ld	s0,16(sp)
    80002dfe:	64a2                	ld	s1,8(sp)
    80002e00:	6902                	ld	s2,0(sp)
    80002e02:	6105                	addi	sp,sp,32
    80002e04:	8082                	ret
            exit(-1);
    80002e06:	557d                	li	a0,-1
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	798080e7          	jalr	1944(ra) # 800025a0 <exit>
    80002e10:	b765                	j	80002db8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e12:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e16:	5890                	lw	a2,48(s1)
    80002e18:	00005517          	auipc	a0,0x5
    80002e1c:	5c050513          	addi	a0,a0,1472 # 800083d8 <etext+0x3d8>
    80002e20:	ffffd097          	auipc	ra,0xffffd
    80002e24:	78a080e7          	jalr	1930(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e28:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e2c:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e30:	00005517          	auipc	a0,0x5
    80002e34:	5d850513          	addi	a0,a0,1496 # 80008408 <etext+0x408>
    80002e38:	ffffd097          	auipc	ra,0xffffd
    80002e3c:	772080e7          	jalr	1906(ra) # 800005aa <printf>
        setkilled(p);
    80002e40:	8526                	mv	a0,s1
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	8a6080e7          	jalr	-1882(ra) # 800026e8 <setkilled>
    80002e4a:	b769                	j	80002dd4 <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002e4c:	4505                	li	a0,1
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	5e2080e7          	jalr	1506(ra) # 80002430 <yield>
    80002e56:	bf71                	j	80002df2 <usertrap+0xac>

0000000080002e58 <kerneltrap>:
{
    80002e58:	7179                	addi	sp,sp,-48
    80002e5a:	f406                	sd	ra,40(sp)
    80002e5c:	f022                	sd	s0,32(sp)
    80002e5e:	ec26                	sd	s1,24(sp)
    80002e60:	e84a                	sd	s2,16(sp)
    80002e62:	e44e                	sd	s3,8(sp)
    80002e64:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e66:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e6a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e6e:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002e72:	1004f793          	andi	a5,s1,256
    80002e76:	cb85                	beqz	a5,80002ea6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e7c:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002e7e:	ef85                	bnez	a5,80002eb6 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	e1c080e7          	jalr	-484(ra) # 80002c9c <devintr>
    80002e88:	cd1d                	beqz	a0,80002ec6 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e8a:	4789                	li	a5,2
    80002e8c:	06f50a63          	beq	a0,a5,80002f00 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e90:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e94:	10049073          	csrw	sstatus,s1
}
    80002e98:	70a2                	ld	ra,40(sp)
    80002e9a:	7402                	ld	s0,32(sp)
    80002e9c:	64e2                	ld	s1,24(sp)
    80002e9e:	6942                	ld	s2,16(sp)
    80002ea0:	69a2                	ld	s3,8(sp)
    80002ea2:	6145                	addi	sp,sp,48
    80002ea4:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002ea6:	00005517          	auipc	a0,0x5
    80002eaa:	58250513          	addi	a0,a0,1410 # 80008428 <etext+0x428>
    80002eae:	ffffd097          	auipc	ra,0xffffd
    80002eb2:	6b2080e7          	jalr	1714(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002eb6:	00005517          	auipc	a0,0x5
    80002eba:	59a50513          	addi	a0,a0,1434 # 80008450 <etext+0x450>
    80002ebe:	ffffd097          	auipc	ra,0xffffd
    80002ec2:	6a2080e7          	jalr	1698(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002ec6:	85ce                	mv	a1,s3
    80002ec8:	00005517          	auipc	a0,0x5
    80002ecc:	5a850513          	addi	a0,a0,1448 # 80008470 <etext+0x470>
    80002ed0:	ffffd097          	auipc	ra,0xffffd
    80002ed4:	6da080e7          	jalr	1754(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ed8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002edc:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ee0:	00005517          	auipc	a0,0x5
    80002ee4:	5a050513          	addi	a0,a0,1440 # 80008480 <etext+0x480>
    80002ee8:	ffffd097          	auipc	ra,0xffffd
    80002eec:	6c2080e7          	jalr	1730(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002ef0:	00005517          	auipc	a0,0x5
    80002ef4:	5a850513          	addi	a0,a0,1448 # 80008498 <etext+0x498>
    80002ef8:	ffffd097          	auipc	ra,0xffffd
    80002efc:	668080e7          	jalr	1640(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	d94080e7          	jalr	-620(ra) # 80001c94 <myproc>
    80002f08:	d541                	beqz	a0,80002e90 <kerneltrap+0x38>
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	d8a080e7          	jalr	-630(ra) # 80001c94 <myproc>
    80002f12:	4d18                	lw	a4,24(a0)
    80002f14:	4791                	li	a5,4
    80002f16:	f6f71de3          	bne	a4,a5,80002e90 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002f1a:	4509                	li	a0,2
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	514080e7          	jalr	1300(ra) # 80002430 <yield>
    80002f24:	b7b5                	j	80002e90 <kerneltrap+0x38>

0000000080002f26 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002f26:	1101                	addi	sp,sp,-32
    80002f28:	ec06                	sd	ra,24(sp)
    80002f2a:	e822                	sd	s0,16(sp)
    80002f2c:	e426                	sd	s1,8(sp)
    80002f2e:	1000                	addi	s0,sp,32
    80002f30:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002f32:	fffff097          	auipc	ra,0xfffff
    80002f36:	d62080e7          	jalr	-670(ra) # 80001c94 <myproc>
    switch (n)
    80002f3a:	4795                	li	a5,5
    80002f3c:	0497e163          	bltu	a5,s1,80002f7e <argraw+0x58>
    80002f40:	048a                	slli	s1,s1,0x2
    80002f42:	00006717          	auipc	a4,0x6
    80002f46:	91670713          	addi	a4,a4,-1770 # 80008858 <states.0+0x30>
    80002f4a:	94ba                	add	s1,s1,a4
    80002f4c:	409c                	lw	a5,0(s1)
    80002f4e:	97ba                	add	a5,a5,a4
    80002f50:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002f52:	6d3c                	ld	a5,88(a0)
    80002f54:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret
        return p->trapframe->a1;
    80002f60:	6d3c                	ld	a5,88(a0)
    80002f62:	7fa8                	ld	a0,120(a5)
    80002f64:	bfcd                	j	80002f56 <argraw+0x30>
        return p->trapframe->a2;
    80002f66:	6d3c                	ld	a5,88(a0)
    80002f68:	63c8                	ld	a0,128(a5)
    80002f6a:	b7f5                	j	80002f56 <argraw+0x30>
        return p->trapframe->a3;
    80002f6c:	6d3c                	ld	a5,88(a0)
    80002f6e:	67c8                	ld	a0,136(a5)
    80002f70:	b7dd                	j	80002f56 <argraw+0x30>
        return p->trapframe->a4;
    80002f72:	6d3c                	ld	a5,88(a0)
    80002f74:	6bc8                	ld	a0,144(a5)
    80002f76:	b7c5                	j	80002f56 <argraw+0x30>
        return p->trapframe->a5;
    80002f78:	6d3c                	ld	a5,88(a0)
    80002f7a:	6fc8                	ld	a0,152(a5)
    80002f7c:	bfe9                	j	80002f56 <argraw+0x30>
    panic("argraw");
    80002f7e:	00005517          	auipc	a0,0x5
    80002f82:	52a50513          	addi	a0,a0,1322 # 800084a8 <etext+0x4a8>
    80002f86:	ffffd097          	auipc	ra,0xffffd
    80002f8a:	5da080e7          	jalr	1498(ra) # 80000560 <panic>

0000000080002f8e <fetchaddr>:
{
    80002f8e:	1101                	addi	sp,sp,-32
    80002f90:	ec06                	sd	ra,24(sp)
    80002f92:	e822                	sd	s0,16(sp)
    80002f94:	e426                	sd	s1,8(sp)
    80002f96:	e04a                	sd	s2,0(sp)
    80002f98:	1000                	addi	s0,sp,32
    80002f9a:	84aa                	mv	s1,a0
    80002f9c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	cf6080e7          	jalr	-778(ra) # 80001c94 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002fa6:	653c                	ld	a5,72(a0)
    80002fa8:	02f4f863          	bgeu	s1,a5,80002fd8 <fetchaddr+0x4a>
    80002fac:	00848713          	addi	a4,s1,8
    80002fb0:	02e7e663          	bltu	a5,a4,80002fdc <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002fb4:	46a1                	li	a3,8
    80002fb6:	8626                	mv	a2,s1
    80002fb8:	85ca                	mv	a1,s2
    80002fba:	6928                	ld	a0,80(a0)
    80002fbc:	ffffe097          	auipc	ra,0xffffe
    80002fc0:	7b2080e7          	jalr	1970(ra) # 8000176e <copyin>
    80002fc4:	00a03533          	snez	a0,a0
    80002fc8:	40a00533          	neg	a0,a0
}
    80002fcc:	60e2                	ld	ra,24(sp)
    80002fce:	6442                	ld	s0,16(sp)
    80002fd0:	64a2                	ld	s1,8(sp)
    80002fd2:	6902                	ld	s2,0(sp)
    80002fd4:	6105                	addi	sp,sp,32
    80002fd6:	8082                	ret
        return -1;
    80002fd8:	557d                	li	a0,-1
    80002fda:	bfcd                	j	80002fcc <fetchaddr+0x3e>
    80002fdc:	557d                	li	a0,-1
    80002fde:	b7fd                	j	80002fcc <fetchaddr+0x3e>

0000000080002fe0 <fetchstr>:
{
    80002fe0:	7179                	addi	sp,sp,-48
    80002fe2:	f406                	sd	ra,40(sp)
    80002fe4:	f022                	sd	s0,32(sp)
    80002fe6:	ec26                	sd	s1,24(sp)
    80002fe8:	e84a                	sd	s2,16(sp)
    80002fea:	e44e                	sd	s3,8(sp)
    80002fec:	1800                	addi	s0,sp,48
    80002fee:	892a                	mv	s2,a0
    80002ff0:	84ae                	mv	s1,a1
    80002ff2:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	ca0080e7          	jalr	-864(ra) # 80001c94 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002ffc:	86ce                	mv	a3,s3
    80002ffe:	864a                	mv	a2,s2
    80003000:	85a6                	mv	a1,s1
    80003002:	6928                	ld	a0,80(a0)
    80003004:	ffffe097          	auipc	ra,0xffffe
    80003008:	7f8080e7          	jalr	2040(ra) # 800017fc <copyinstr>
    8000300c:	00054e63          	bltz	a0,80003028 <fetchstr+0x48>
    return strlen(buf);
    80003010:	8526                	mv	a0,s1
    80003012:	ffffe097          	auipc	ra,0xffffe
    80003016:	e96080e7          	jalr	-362(ra) # 80000ea8 <strlen>
}
    8000301a:	70a2                	ld	ra,40(sp)
    8000301c:	7402                	ld	s0,32(sp)
    8000301e:	64e2                	ld	s1,24(sp)
    80003020:	6942                	ld	s2,16(sp)
    80003022:	69a2                	ld	s3,8(sp)
    80003024:	6145                	addi	sp,sp,48
    80003026:	8082                	ret
        return -1;
    80003028:	557d                	li	a0,-1
    8000302a:	bfc5                	j	8000301a <fetchstr+0x3a>

000000008000302c <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    8000302c:	1101                	addi	sp,sp,-32
    8000302e:	ec06                	sd	ra,24(sp)
    80003030:	e822                	sd	s0,16(sp)
    80003032:	e426                	sd	s1,8(sp)
    80003034:	1000                	addi	s0,sp,32
    80003036:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003038:	00000097          	auipc	ra,0x0
    8000303c:	eee080e7          	jalr	-274(ra) # 80002f26 <argraw>
    80003040:	c088                	sw	a0,0(s1)
}
    80003042:	60e2                	ld	ra,24(sp)
    80003044:	6442                	ld	s0,16(sp)
    80003046:	64a2                	ld	s1,8(sp)
    80003048:	6105                	addi	sp,sp,32
    8000304a:	8082                	ret

000000008000304c <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    8000304c:	1101                	addi	sp,sp,-32
    8000304e:	ec06                	sd	ra,24(sp)
    80003050:	e822                	sd	s0,16(sp)
    80003052:	e426                	sd	s1,8(sp)
    80003054:	1000                	addi	s0,sp,32
    80003056:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	ece080e7          	jalr	-306(ra) # 80002f26 <argraw>
    80003060:	e088                	sd	a0,0(s1)
}
    80003062:	60e2                	ld	ra,24(sp)
    80003064:	6442                	ld	s0,16(sp)
    80003066:	64a2                	ld	s1,8(sp)
    80003068:	6105                	addi	sp,sp,32
    8000306a:	8082                	ret

000000008000306c <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000306c:	7179                	addi	sp,sp,-48
    8000306e:	f406                	sd	ra,40(sp)
    80003070:	f022                	sd	s0,32(sp)
    80003072:	ec26                	sd	s1,24(sp)
    80003074:	e84a                	sd	s2,16(sp)
    80003076:	1800                	addi	s0,sp,48
    80003078:	84ae                	mv	s1,a1
    8000307a:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    8000307c:	fd840593          	addi	a1,s0,-40
    80003080:	00000097          	auipc	ra,0x0
    80003084:	fcc080e7          	jalr	-52(ra) # 8000304c <argaddr>
    return fetchstr(addr, buf, max);
    80003088:	864a                	mv	a2,s2
    8000308a:	85a6                	mv	a1,s1
    8000308c:	fd843503          	ld	a0,-40(s0)
    80003090:	00000097          	auipc	ra,0x0
    80003094:	f50080e7          	jalr	-176(ra) # 80002fe0 <fetchstr>
}
    80003098:	70a2                	ld	ra,40(sp)
    8000309a:	7402                	ld	s0,32(sp)
    8000309c:	64e2                	ld	s1,24(sp)
    8000309e:	6942                	ld	s2,16(sp)
    800030a0:	6145                	addi	sp,sp,48
    800030a2:	8082                	ret

00000000800030a4 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    800030a4:	1101                	addi	sp,sp,-32
    800030a6:	ec06                	sd	ra,24(sp)
    800030a8:	e822                	sd	s0,16(sp)
    800030aa:	e426                	sd	s1,8(sp)
    800030ac:	e04a                	sd	s2,0(sp)
    800030ae:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	be4080e7          	jalr	-1052(ra) # 80001c94 <myproc>
    800030b8:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    800030ba:	05853903          	ld	s2,88(a0)
    800030be:	0a893783          	ld	a5,168(s2)
    800030c2:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800030c6:	37fd                	addiw	a5,a5,-1
    800030c8:	4761                	li	a4,24
    800030ca:	00f76f63          	bltu	a4,a5,800030e8 <syscall+0x44>
    800030ce:	00369713          	slli	a4,a3,0x3
    800030d2:	00005797          	auipc	a5,0x5
    800030d6:	79e78793          	addi	a5,a5,1950 # 80008870 <syscalls>
    800030da:	97ba                	add	a5,a5,a4
    800030dc:	639c                	ld	a5,0(a5)
    800030de:	c789                	beqz	a5,800030e8 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    800030e0:	9782                	jalr	a5
    800030e2:	06a93823          	sd	a0,112(s2)
    800030e6:	a839                	j	80003104 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800030e8:	15848613          	addi	a2,s1,344
    800030ec:	588c                	lw	a1,48(s1)
    800030ee:	00005517          	auipc	a0,0x5
    800030f2:	3c250513          	addi	a0,a0,962 # 800084b0 <etext+0x4b0>
    800030f6:	ffffd097          	auipc	ra,0xffffd
    800030fa:	4b4080e7          	jalr	1204(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800030fe:	6cbc                	ld	a5,88(s1)
    80003100:	577d                	li	a4,-1
    80003102:	fbb8                	sd	a4,112(a5)
    }
}
    80003104:	60e2                	ld	ra,24(sp)
    80003106:	6442                	ld	s0,16(sp)
    80003108:	64a2                	ld	s1,8(sp)
    8000310a:	6902                	ld	s2,0(sp)
    8000310c:	6105                	addi	sp,sp,32
    8000310e:	8082                	ret

0000000080003110 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003110:	1101                	addi	sp,sp,-32
    80003112:	ec06                	sd	ra,24(sp)
    80003114:	e822                	sd	s0,16(sp)
    80003116:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80003118:	fec40593          	addi	a1,s0,-20
    8000311c:	4501                	li	a0,0
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	f0e080e7          	jalr	-242(ra) # 8000302c <argint>
    exit(n);
    80003126:	fec42503          	lw	a0,-20(s0)
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	476080e7          	jalr	1142(ra) # 800025a0 <exit>
    return 0; // not reached
}
    80003132:	4501                	li	a0,0
    80003134:	60e2                	ld	ra,24(sp)
    80003136:	6442                	ld	s0,16(sp)
    80003138:	6105                	addi	sp,sp,32
    8000313a:	8082                	ret

000000008000313c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000313c:	1141                	addi	sp,sp,-16
    8000313e:	e406                	sd	ra,8(sp)
    80003140:	e022                	sd	s0,0(sp)
    80003142:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80003144:	fffff097          	auipc	ra,0xfffff
    80003148:	b50080e7          	jalr	-1200(ra) # 80001c94 <myproc>
}
    8000314c:	5908                	lw	a0,48(a0)
    8000314e:	60a2                	ld	ra,8(sp)
    80003150:	6402                	ld	s0,0(sp)
    80003152:	0141                	addi	sp,sp,16
    80003154:	8082                	ret

0000000080003156 <sys_fork>:

uint64
sys_fork(void)
{
    80003156:	1141                	addi	sp,sp,-16
    80003158:	e406                	sd	ra,8(sp)
    8000315a:	e022                	sd	s0,0(sp)
    8000315c:	0800                	addi	s0,sp,16
    return fork();
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	084080e7          	jalr	132(ra) # 800021e2 <fork>
}
    80003166:	60a2                	ld	ra,8(sp)
    80003168:	6402                	ld	s0,0(sp)
    8000316a:	0141                	addi	sp,sp,16
    8000316c:	8082                	ret

000000008000316e <sys_wait>:

uint64
sys_wait(void)
{
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80003176:	fe840593          	addi	a1,s0,-24
    8000317a:	4501                	li	a0,0
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	ed0080e7          	jalr	-304(ra) # 8000304c <argaddr>
    return wait(p);
    80003184:	fe843503          	ld	a0,-24(s0)
    80003188:	fffff097          	auipc	ra,0xfffff
    8000318c:	5be080e7          	jalr	1470(ra) # 80002746 <wait>
}
    80003190:	60e2                	ld	ra,24(sp)
    80003192:	6442                	ld	s0,16(sp)
    80003194:	6105                	addi	sp,sp,32
    80003196:	8082                	ret

0000000080003198 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003198:	7179                	addi	sp,sp,-48
    8000319a:	f406                	sd	ra,40(sp)
    8000319c:	f022                	sd	s0,32(sp)
    8000319e:	ec26                	sd	s1,24(sp)
    800031a0:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    800031a2:	fdc40593          	addi	a1,s0,-36
    800031a6:	4501                	li	a0,0
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	e84080e7          	jalr	-380(ra) # 8000302c <argint>
    addr = myproc()->sz;
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	ae4080e7          	jalr	-1308(ra) # 80001c94 <myproc>
    800031b8:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    800031ba:	fdc42503          	lw	a0,-36(s0)
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	e30080e7          	jalr	-464(ra) # 80001fee <growproc>
    800031c6:	00054863          	bltz	a0,800031d6 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    800031ca:	8526                	mv	a0,s1
    800031cc:	70a2                	ld	ra,40(sp)
    800031ce:	7402                	ld	s0,32(sp)
    800031d0:	64e2                	ld	s1,24(sp)
    800031d2:	6145                	addi	sp,sp,48
    800031d4:	8082                	ret
        return -1;
    800031d6:	54fd                	li	s1,-1
    800031d8:	bfcd                	j	800031ca <sys_sbrk+0x32>

00000000800031da <sys_sleep>:

uint64
sys_sleep(void)
{
    800031da:	7139                	addi	sp,sp,-64
    800031dc:	fc06                	sd	ra,56(sp)
    800031de:	f822                	sd	s0,48(sp)
    800031e0:	f04a                	sd	s2,32(sp)
    800031e2:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    800031e4:	fcc40593          	addi	a1,s0,-52
    800031e8:	4501                	li	a0,0
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	e42080e7          	jalr	-446(ra) # 8000302c <argint>
    acquire(&tickslock);
    800031f2:	00016517          	auipc	a0,0x16
    800031f6:	56e50513          	addi	a0,a0,1390 # 80019760 <tickslock>
    800031fa:	ffffe097          	auipc	ra,0xffffe
    800031fe:	a3e080e7          	jalr	-1474(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    80003202:	00008917          	auipc	s2,0x8
    80003206:	2be92903          	lw	s2,702(s2) # 8000b4c0 <ticks>
    while (ticks - ticks0 < n)
    8000320a:	fcc42783          	lw	a5,-52(s0)
    8000320e:	c3b9                	beqz	a5,80003254 <sys_sleep+0x7a>
    80003210:	f426                	sd	s1,40(sp)
    80003212:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80003214:	00016997          	auipc	s3,0x16
    80003218:	54c98993          	addi	s3,s3,1356 # 80019760 <tickslock>
    8000321c:	00008497          	auipc	s1,0x8
    80003220:	2a448493          	addi	s1,s1,676 # 8000b4c0 <ticks>
        if (killed(myproc()))
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	a70080e7          	jalr	-1424(ra) # 80001c94 <myproc>
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	4e8080e7          	jalr	1256(ra) # 80002714 <killed>
    80003234:	ed15                	bnez	a0,80003270 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    80003236:	85ce                	mv	a1,s3
    80003238:	8526                	mv	a0,s1
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	232080e7          	jalr	562(ra) # 8000246c <sleep>
    while (ticks - ticks0 < n)
    80003242:	409c                	lw	a5,0(s1)
    80003244:	412787bb          	subw	a5,a5,s2
    80003248:	fcc42703          	lw	a4,-52(s0)
    8000324c:	fce7ece3          	bltu	a5,a4,80003224 <sys_sleep+0x4a>
    80003250:	74a2                	ld	s1,40(sp)
    80003252:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003254:	00016517          	auipc	a0,0x16
    80003258:	50c50513          	addi	a0,a0,1292 # 80019760 <tickslock>
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	a90080e7          	jalr	-1392(ra) # 80000cec <release>
    return 0;
    80003264:	4501                	li	a0,0
}
    80003266:	70e2                	ld	ra,56(sp)
    80003268:	7442                	ld	s0,48(sp)
    8000326a:	7902                	ld	s2,32(sp)
    8000326c:	6121                	addi	sp,sp,64
    8000326e:	8082                	ret
            release(&tickslock);
    80003270:	00016517          	auipc	a0,0x16
    80003274:	4f050513          	addi	a0,a0,1264 # 80019760 <tickslock>
    80003278:	ffffe097          	auipc	ra,0xffffe
    8000327c:	a74080e7          	jalr	-1420(ra) # 80000cec <release>
            return -1;
    80003280:	557d                	li	a0,-1
    80003282:	74a2                	ld	s1,40(sp)
    80003284:	69e2                	ld	s3,24(sp)
    80003286:	b7c5                	j	80003266 <sys_sleep+0x8c>

0000000080003288 <sys_kill>:

uint64
sys_kill(void)
{
    80003288:	1101                	addi	sp,sp,-32
    8000328a:	ec06                	sd	ra,24(sp)
    8000328c:	e822                	sd	s0,16(sp)
    8000328e:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80003290:	fec40593          	addi	a1,s0,-20
    80003294:	4501                	li	a0,0
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	d96080e7          	jalr	-618(ra) # 8000302c <argint>
    return kill(pid);
    8000329e:	fec42503          	lw	a0,-20(s0)
    800032a2:	fffff097          	auipc	ra,0xfffff
    800032a6:	3d4080e7          	jalr	980(ra) # 80002676 <kill>
}
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret

00000000800032b2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800032b2:	1101                	addi	sp,sp,-32
    800032b4:	ec06                	sd	ra,24(sp)
    800032b6:	e822                	sd	s0,16(sp)
    800032b8:	e426                	sd	s1,8(sp)
    800032ba:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800032bc:	00016517          	auipc	a0,0x16
    800032c0:	4a450513          	addi	a0,a0,1188 # 80019760 <tickslock>
    800032c4:	ffffe097          	auipc	ra,0xffffe
    800032c8:	974080e7          	jalr	-1676(ra) # 80000c38 <acquire>
    xticks = ticks;
    800032cc:	00008497          	auipc	s1,0x8
    800032d0:	1f44a483          	lw	s1,500(s1) # 8000b4c0 <ticks>
    release(&tickslock);
    800032d4:	00016517          	auipc	a0,0x16
    800032d8:	48c50513          	addi	a0,a0,1164 # 80019760 <tickslock>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	a10080e7          	jalr	-1520(ra) # 80000cec <release>
    return xticks;
}
    800032e4:	02049513          	slli	a0,s1,0x20
    800032e8:	9101                	srli	a0,a0,0x20
    800032ea:	60e2                	ld	ra,24(sp)
    800032ec:	6442                	ld	s0,16(sp)
    800032ee:	64a2                	ld	s1,8(sp)
    800032f0:	6105                	addi	sp,sp,32
    800032f2:	8082                	ret

00000000800032f4 <sys_ps>:

void *
sys_ps(void)
{
    800032f4:	1101                	addi	sp,sp,-32
    800032f6:	ec06                	sd	ra,24(sp)
    800032f8:	e822                	sd	s0,16(sp)
    800032fa:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    800032fc:	fe042623          	sw	zero,-20(s0)
    80003300:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003304:	fec40593          	addi	a1,s0,-20
    80003308:	4501                	li	a0,0
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	d22080e7          	jalr	-734(ra) # 8000302c <argint>
    argint(1, &count);
    80003312:	fe840593          	addi	a1,s0,-24
    80003316:	4505                	li	a0,1
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	d14080e7          	jalr	-748(ra) # 8000302c <argint>
    return ps((uint8)start, (uint8)count);
    80003320:	fe844583          	lbu	a1,-24(s0)
    80003324:	fec44503          	lbu	a0,-20(s0)
    80003328:	fffff097          	auipc	ra,0xfffff
    8000332c:	d22080e7          	jalr	-734(ra) # 8000204a <ps>
}
    80003330:	60e2                	ld	ra,24(sp)
    80003332:	6442                	ld	s0,16(sp)
    80003334:	6105                	addi	sp,sp,32
    80003336:	8082                	ret

0000000080003338 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003338:	1141                	addi	sp,sp,-16
    8000333a:	e406                	sd	ra,8(sp)
    8000333c:	e022                	sd	s0,0(sp)
    8000333e:	0800                	addi	s0,sp,16
    schedls();
    80003340:	fffff097          	auipc	ra,0xfffff
    80003344:	690080e7          	jalr	1680(ra) # 800029d0 <schedls>
    return 0;
}
    80003348:	4501                	li	a0,0
    8000334a:	60a2                	ld	ra,8(sp)
    8000334c:	6402                	ld	s0,0(sp)
    8000334e:	0141                	addi	sp,sp,16
    80003350:	8082                	ret

0000000080003352 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003352:	1101                	addi	sp,sp,-32
    80003354:	ec06                	sd	ra,24(sp)
    80003356:	e822                	sd	s0,16(sp)
    80003358:	1000                	addi	s0,sp,32
    int id = 0;
    8000335a:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    8000335e:	fec40593          	addi	a1,s0,-20
    80003362:	4501                	li	a0,0
    80003364:	00000097          	auipc	ra,0x0
    80003368:	cc8080e7          	jalr	-824(ra) # 8000302c <argint>
    schedset(id - 1);
    8000336c:	fec42503          	lw	a0,-20(s0)
    80003370:	357d                	addiw	a0,a0,-1
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	74a080e7          	jalr	1866(ra) # 80002abc <schedset>
    return 0;
}
    8000337a:	4501                	li	a0,0
    8000337c:	60e2                	ld	ra,24(sp)
    8000337e:	6442                	ld	s0,16(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <sys_yield>:

uint64 sys_yield(void)
{
    80003384:	1141                	addi	sp,sp,-16
    80003386:	e406                	sd	ra,8(sp)
    80003388:	e022                	sd	s0,0(sp)
    8000338a:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    8000338c:	4509                	li	a0,2
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	0a2080e7          	jalr	162(ra) # 80002430 <yield>
    return 0;
    80003396:	4501                	li	a0,0
    80003398:	60a2                	ld	ra,8(sp)
    8000339a:	6402                	ld	s0,0(sp)
    8000339c:	0141                	addi	sp,sp,16
    8000339e:	8082                	ret

00000000800033a0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800033a0:	7179                	addi	sp,sp,-48
    800033a2:	f406                	sd	ra,40(sp)
    800033a4:	f022                	sd	s0,32(sp)
    800033a6:	ec26                	sd	s1,24(sp)
    800033a8:	e84a                	sd	s2,16(sp)
    800033aa:	e44e                	sd	s3,8(sp)
    800033ac:	e052                	sd	s4,0(sp)
    800033ae:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800033b0:	00005597          	auipc	a1,0x5
    800033b4:	12058593          	addi	a1,a1,288 # 800084d0 <etext+0x4d0>
    800033b8:	00016517          	auipc	a0,0x16
    800033bc:	3c050513          	addi	a0,a0,960 # 80019778 <bcache>
    800033c0:	ffffd097          	auipc	ra,0xffffd
    800033c4:	7e8080e7          	jalr	2024(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800033c8:	0001e797          	auipc	a5,0x1e
    800033cc:	3b078793          	addi	a5,a5,944 # 80021778 <bcache+0x8000>
    800033d0:	0001e717          	auipc	a4,0x1e
    800033d4:	61070713          	addi	a4,a4,1552 # 800219e0 <bcache+0x8268>
    800033d8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800033dc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033e0:	00016497          	auipc	s1,0x16
    800033e4:	3b048493          	addi	s1,s1,944 # 80019790 <bcache+0x18>
    b->next = bcache.head.next;
    800033e8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033ea:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033ec:	00005a17          	auipc	s4,0x5
    800033f0:	0eca0a13          	addi	s4,s4,236 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    800033f4:	2b893783          	ld	a5,696(s2)
    800033f8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033fa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033fe:	85d2                	mv	a1,s4
    80003400:	01048513          	addi	a0,s1,16
    80003404:	00001097          	auipc	ra,0x1
    80003408:	4e8080e7          	jalr	1256(ra) # 800048ec <initsleeplock>
    bcache.head.next->prev = b;
    8000340c:	2b893783          	ld	a5,696(s2)
    80003410:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003412:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003416:	45848493          	addi	s1,s1,1112
    8000341a:	fd349de3          	bne	s1,s3,800033f4 <binit+0x54>
  }
}
    8000341e:	70a2                	ld	ra,40(sp)
    80003420:	7402                	ld	s0,32(sp)
    80003422:	64e2                	ld	s1,24(sp)
    80003424:	6942                	ld	s2,16(sp)
    80003426:	69a2                	ld	s3,8(sp)
    80003428:	6a02                	ld	s4,0(sp)
    8000342a:	6145                	addi	sp,sp,48
    8000342c:	8082                	ret

000000008000342e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000342e:	7179                	addi	sp,sp,-48
    80003430:	f406                	sd	ra,40(sp)
    80003432:	f022                	sd	s0,32(sp)
    80003434:	ec26                	sd	s1,24(sp)
    80003436:	e84a                	sd	s2,16(sp)
    80003438:	e44e                	sd	s3,8(sp)
    8000343a:	1800                	addi	s0,sp,48
    8000343c:	892a                	mv	s2,a0
    8000343e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003440:	00016517          	auipc	a0,0x16
    80003444:	33850513          	addi	a0,a0,824 # 80019778 <bcache>
    80003448:	ffffd097          	auipc	ra,0xffffd
    8000344c:	7f0080e7          	jalr	2032(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003450:	0001e497          	auipc	s1,0x1e
    80003454:	5e04b483          	ld	s1,1504(s1) # 80021a30 <bcache+0x82b8>
    80003458:	0001e797          	auipc	a5,0x1e
    8000345c:	58878793          	addi	a5,a5,1416 # 800219e0 <bcache+0x8268>
    80003460:	02f48f63          	beq	s1,a5,8000349e <bread+0x70>
    80003464:	873e                	mv	a4,a5
    80003466:	a021                	j	8000346e <bread+0x40>
    80003468:	68a4                	ld	s1,80(s1)
    8000346a:	02e48a63          	beq	s1,a4,8000349e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000346e:	449c                	lw	a5,8(s1)
    80003470:	ff279ce3          	bne	a5,s2,80003468 <bread+0x3a>
    80003474:	44dc                	lw	a5,12(s1)
    80003476:	ff3799e3          	bne	a5,s3,80003468 <bread+0x3a>
      b->refcnt++;
    8000347a:	40bc                	lw	a5,64(s1)
    8000347c:	2785                	addiw	a5,a5,1
    8000347e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003480:	00016517          	auipc	a0,0x16
    80003484:	2f850513          	addi	a0,a0,760 # 80019778 <bcache>
    80003488:	ffffe097          	auipc	ra,0xffffe
    8000348c:	864080e7          	jalr	-1948(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003490:	01048513          	addi	a0,s1,16
    80003494:	00001097          	auipc	ra,0x1
    80003498:	492080e7          	jalr	1170(ra) # 80004926 <acquiresleep>
      return b;
    8000349c:	a8b9                	j	800034fa <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000349e:	0001e497          	auipc	s1,0x1e
    800034a2:	58a4b483          	ld	s1,1418(s1) # 80021a28 <bcache+0x82b0>
    800034a6:	0001e797          	auipc	a5,0x1e
    800034aa:	53a78793          	addi	a5,a5,1338 # 800219e0 <bcache+0x8268>
    800034ae:	00f48863          	beq	s1,a5,800034be <bread+0x90>
    800034b2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800034b4:	40bc                	lw	a5,64(s1)
    800034b6:	cf81                	beqz	a5,800034ce <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034b8:	64a4                	ld	s1,72(s1)
    800034ba:	fee49de3          	bne	s1,a4,800034b4 <bread+0x86>
  panic("bget: no buffers");
    800034be:	00005517          	auipc	a0,0x5
    800034c2:	02250513          	addi	a0,a0,34 # 800084e0 <etext+0x4e0>
    800034c6:	ffffd097          	auipc	ra,0xffffd
    800034ca:	09a080e7          	jalr	154(ra) # 80000560 <panic>
      b->dev = dev;
    800034ce:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800034d2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800034d6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800034da:	4785                	li	a5,1
    800034dc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034de:	00016517          	auipc	a0,0x16
    800034e2:	29a50513          	addi	a0,a0,666 # 80019778 <bcache>
    800034e6:	ffffe097          	auipc	ra,0xffffe
    800034ea:	806080e7          	jalr	-2042(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    800034ee:	01048513          	addi	a0,s1,16
    800034f2:	00001097          	auipc	ra,0x1
    800034f6:	434080e7          	jalr	1076(ra) # 80004926 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034fa:	409c                	lw	a5,0(s1)
    800034fc:	cb89                	beqz	a5,8000350e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034fe:	8526                	mv	a0,s1
    80003500:	70a2                	ld	ra,40(sp)
    80003502:	7402                	ld	s0,32(sp)
    80003504:	64e2                	ld	s1,24(sp)
    80003506:	6942                	ld	s2,16(sp)
    80003508:	69a2                	ld	s3,8(sp)
    8000350a:	6145                	addi	sp,sp,48
    8000350c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000350e:	4581                	li	a1,0
    80003510:	8526                	mv	a0,s1
    80003512:	00003097          	auipc	ra,0x3
    80003516:	0f6080e7          	jalr	246(ra) # 80006608 <virtio_disk_rw>
    b->valid = 1;
    8000351a:	4785                	li	a5,1
    8000351c:	c09c                	sw	a5,0(s1)
  return b;
    8000351e:	b7c5                	j	800034fe <bread+0xd0>

0000000080003520 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003520:	1101                	addi	sp,sp,-32
    80003522:	ec06                	sd	ra,24(sp)
    80003524:	e822                	sd	s0,16(sp)
    80003526:	e426                	sd	s1,8(sp)
    80003528:	1000                	addi	s0,sp,32
    8000352a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000352c:	0541                	addi	a0,a0,16
    8000352e:	00001097          	auipc	ra,0x1
    80003532:	492080e7          	jalr	1170(ra) # 800049c0 <holdingsleep>
    80003536:	cd01                	beqz	a0,8000354e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003538:	4585                	li	a1,1
    8000353a:	8526                	mv	a0,s1
    8000353c:	00003097          	auipc	ra,0x3
    80003540:	0cc080e7          	jalr	204(ra) # 80006608 <virtio_disk_rw>
}
    80003544:	60e2                	ld	ra,24(sp)
    80003546:	6442                	ld	s0,16(sp)
    80003548:	64a2                	ld	s1,8(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret
    panic("bwrite");
    8000354e:	00005517          	auipc	a0,0x5
    80003552:	faa50513          	addi	a0,a0,-86 # 800084f8 <etext+0x4f8>
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	00a080e7          	jalr	10(ra) # 80000560 <panic>

000000008000355e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000355e:	1101                	addi	sp,sp,-32
    80003560:	ec06                	sd	ra,24(sp)
    80003562:	e822                	sd	s0,16(sp)
    80003564:	e426                	sd	s1,8(sp)
    80003566:	e04a                	sd	s2,0(sp)
    80003568:	1000                	addi	s0,sp,32
    8000356a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000356c:	01050913          	addi	s2,a0,16
    80003570:	854a                	mv	a0,s2
    80003572:	00001097          	auipc	ra,0x1
    80003576:	44e080e7          	jalr	1102(ra) # 800049c0 <holdingsleep>
    8000357a:	c925                	beqz	a0,800035ea <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000357c:	854a                	mv	a0,s2
    8000357e:	00001097          	auipc	ra,0x1
    80003582:	3fe080e7          	jalr	1022(ra) # 8000497c <releasesleep>

  acquire(&bcache.lock);
    80003586:	00016517          	auipc	a0,0x16
    8000358a:	1f250513          	addi	a0,a0,498 # 80019778 <bcache>
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	6aa080e7          	jalr	1706(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003596:	40bc                	lw	a5,64(s1)
    80003598:	37fd                	addiw	a5,a5,-1
    8000359a:	0007871b          	sext.w	a4,a5
    8000359e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035a0:	e71d                	bnez	a4,800035ce <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035a2:	68b8                	ld	a4,80(s1)
    800035a4:	64bc                	ld	a5,72(s1)
    800035a6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800035a8:	68b8                	ld	a4,80(s1)
    800035aa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800035ac:	0001e797          	auipc	a5,0x1e
    800035b0:	1cc78793          	addi	a5,a5,460 # 80021778 <bcache+0x8000>
    800035b4:	2b87b703          	ld	a4,696(a5)
    800035b8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800035ba:	0001e717          	auipc	a4,0x1e
    800035be:	42670713          	addi	a4,a4,1062 # 800219e0 <bcache+0x8268>
    800035c2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800035c4:	2b87b703          	ld	a4,696(a5)
    800035c8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800035ca:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800035ce:	00016517          	auipc	a0,0x16
    800035d2:	1aa50513          	addi	a0,a0,426 # 80019778 <bcache>
    800035d6:	ffffd097          	auipc	ra,0xffffd
    800035da:	716080e7          	jalr	1814(ra) # 80000cec <release>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6902                	ld	s2,0(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret
    panic("brelse");
    800035ea:	00005517          	auipc	a0,0x5
    800035ee:	f1650513          	addi	a0,a0,-234 # 80008500 <etext+0x500>
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	f6e080e7          	jalr	-146(ra) # 80000560 <panic>

00000000800035fa <bpin>:

void
bpin(struct buf *b) {
    800035fa:	1101                	addi	sp,sp,-32
    800035fc:	ec06                	sd	ra,24(sp)
    800035fe:	e822                	sd	s0,16(sp)
    80003600:	e426                	sd	s1,8(sp)
    80003602:	1000                	addi	s0,sp,32
    80003604:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003606:	00016517          	auipc	a0,0x16
    8000360a:	17250513          	addi	a0,a0,370 # 80019778 <bcache>
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	62a080e7          	jalr	1578(ra) # 80000c38 <acquire>
  b->refcnt++;
    80003616:	40bc                	lw	a5,64(s1)
    80003618:	2785                	addiw	a5,a5,1
    8000361a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000361c:	00016517          	auipc	a0,0x16
    80003620:	15c50513          	addi	a0,a0,348 # 80019778 <bcache>
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	6c8080e7          	jalr	1736(ra) # 80000cec <release>
}
    8000362c:	60e2                	ld	ra,24(sp)
    8000362e:	6442                	ld	s0,16(sp)
    80003630:	64a2                	ld	s1,8(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <bunpin>:

void
bunpin(struct buf *b) {
    80003636:	1101                	addi	sp,sp,-32
    80003638:	ec06                	sd	ra,24(sp)
    8000363a:	e822                	sd	s0,16(sp)
    8000363c:	e426                	sd	s1,8(sp)
    8000363e:	1000                	addi	s0,sp,32
    80003640:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003642:	00016517          	auipc	a0,0x16
    80003646:	13650513          	addi	a0,a0,310 # 80019778 <bcache>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	5ee080e7          	jalr	1518(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003652:	40bc                	lw	a5,64(s1)
    80003654:	37fd                	addiw	a5,a5,-1
    80003656:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003658:	00016517          	auipc	a0,0x16
    8000365c:	12050513          	addi	a0,a0,288 # 80019778 <bcache>
    80003660:	ffffd097          	auipc	ra,0xffffd
    80003664:	68c080e7          	jalr	1676(ra) # 80000cec <release>
}
    80003668:	60e2                	ld	ra,24(sp)
    8000366a:	6442                	ld	s0,16(sp)
    8000366c:	64a2                	ld	s1,8(sp)
    8000366e:	6105                	addi	sp,sp,32
    80003670:	8082                	ret

0000000080003672 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003672:	1101                	addi	sp,sp,-32
    80003674:	ec06                	sd	ra,24(sp)
    80003676:	e822                	sd	s0,16(sp)
    80003678:	e426                	sd	s1,8(sp)
    8000367a:	e04a                	sd	s2,0(sp)
    8000367c:	1000                	addi	s0,sp,32
    8000367e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003680:	00d5d59b          	srliw	a1,a1,0xd
    80003684:	0001e797          	auipc	a5,0x1e
    80003688:	7d07a783          	lw	a5,2000(a5) # 80021e54 <sb+0x1c>
    8000368c:	9dbd                	addw	a1,a1,a5
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	da0080e7          	jalr	-608(ra) # 8000342e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003696:	0074f713          	andi	a4,s1,7
    8000369a:	4785                	li	a5,1
    8000369c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800036a0:	14ce                	slli	s1,s1,0x33
    800036a2:	90d9                	srli	s1,s1,0x36
    800036a4:	00950733          	add	a4,a0,s1
    800036a8:	05874703          	lbu	a4,88(a4)
    800036ac:	00e7f6b3          	and	a3,a5,a4
    800036b0:	c69d                	beqz	a3,800036de <bfree+0x6c>
    800036b2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800036b4:	94aa                	add	s1,s1,a0
    800036b6:	fff7c793          	not	a5,a5
    800036ba:	8f7d                	and	a4,a4,a5
    800036bc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800036c0:	00001097          	auipc	ra,0x1
    800036c4:	148080e7          	jalr	328(ra) # 80004808 <log_write>
  brelse(bp);
    800036c8:	854a                	mv	a0,s2
    800036ca:	00000097          	auipc	ra,0x0
    800036ce:	e94080e7          	jalr	-364(ra) # 8000355e <brelse>
}
    800036d2:	60e2                	ld	ra,24(sp)
    800036d4:	6442                	ld	s0,16(sp)
    800036d6:	64a2                	ld	s1,8(sp)
    800036d8:	6902                	ld	s2,0(sp)
    800036da:	6105                	addi	sp,sp,32
    800036dc:	8082                	ret
    panic("freeing free block");
    800036de:	00005517          	auipc	a0,0x5
    800036e2:	e2a50513          	addi	a0,a0,-470 # 80008508 <etext+0x508>
    800036e6:	ffffd097          	auipc	ra,0xffffd
    800036ea:	e7a080e7          	jalr	-390(ra) # 80000560 <panic>

00000000800036ee <balloc>:
{
    800036ee:	711d                	addi	sp,sp,-96
    800036f0:	ec86                	sd	ra,88(sp)
    800036f2:	e8a2                	sd	s0,80(sp)
    800036f4:	e4a6                	sd	s1,72(sp)
    800036f6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800036f8:	0001e797          	auipc	a5,0x1e
    800036fc:	7447a783          	lw	a5,1860(a5) # 80021e3c <sb+0x4>
    80003700:	10078f63          	beqz	a5,8000381e <balloc+0x130>
    80003704:	e0ca                	sd	s2,64(sp)
    80003706:	fc4e                	sd	s3,56(sp)
    80003708:	f852                	sd	s4,48(sp)
    8000370a:	f456                	sd	s5,40(sp)
    8000370c:	f05a                	sd	s6,32(sp)
    8000370e:	ec5e                	sd	s7,24(sp)
    80003710:	e862                	sd	s8,16(sp)
    80003712:	e466                	sd	s9,8(sp)
    80003714:	8baa                	mv	s7,a0
    80003716:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003718:	0001eb17          	auipc	s6,0x1e
    8000371c:	720b0b13          	addi	s6,s6,1824 # 80021e38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003720:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003722:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003724:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003726:	6c89                	lui	s9,0x2
    80003728:	a061                	j	800037b0 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000372a:	97ca                	add	a5,a5,s2
    8000372c:	8e55                	or	a2,a2,a3
    8000372e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003732:	854a                	mv	a0,s2
    80003734:	00001097          	auipc	ra,0x1
    80003738:	0d4080e7          	jalr	212(ra) # 80004808 <log_write>
        brelse(bp);
    8000373c:	854a                	mv	a0,s2
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	e20080e7          	jalr	-480(ra) # 8000355e <brelse>
  bp = bread(dev, bno);
    80003746:	85a6                	mv	a1,s1
    80003748:	855e                	mv	a0,s7
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	ce4080e7          	jalr	-796(ra) # 8000342e <bread>
    80003752:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003754:	40000613          	li	a2,1024
    80003758:	4581                	li	a1,0
    8000375a:	05850513          	addi	a0,a0,88
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	5d6080e7          	jalr	1494(ra) # 80000d34 <memset>
  log_write(bp);
    80003766:	854a                	mv	a0,s2
    80003768:	00001097          	auipc	ra,0x1
    8000376c:	0a0080e7          	jalr	160(ra) # 80004808 <log_write>
  brelse(bp);
    80003770:	854a                	mv	a0,s2
    80003772:	00000097          	auipc	ra,0x0
    80003776:	dec080e7          	jalr	-532(ra) # 8000355e <brelse>
}
    8000377a:	6906                	ld	s2,64(sp)
    8000377c:	79e2                	ld	s3,56(sp)
    8000377e:	7a42                	ld	s4,48(sp)
    80003780:	7aa2                	ld	s5,40(sp)
    80003782:	7b02                	ld	s6,32(sp)
    80003784:	6be2                	ld	s7,24(sp)
    80003786:	6c42                	ld	s8,16(sp)
    80003788:	6ca2                	ld	s9,8(sp)
}
    8000378a:	8526                	mv	a0,s1
    8000378c:	60e6                	ld	ra,88(sp)
    8000378e:	6446                	ld	s0,80(sp)
    80003790:	64a6                	ld	s1,72(sp)
    80003792:	6125                	addi	sp,sp,96
    80003794:	8082                	ret
    brelse(bp);
    80003796:	854a                	mv	a0,s2
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	dc6080e7          	jalr	-570(ra) # 8000355e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037a0:	015c87bb          	addw	a5,s9,s5
    800037a4:	00078a9b          	sext.w	s5,a5
    800037a8:	004b2703          	lw	a4,4(s6)
    800037ac:	06eaf163          	bgeu	s5,a4,8000380e <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800037b0:	41fad79b          	sraiw	a5,s5,0x1f
    800037b4:	0137d79b          	srliw	a5,a5,0x13
    800037b8:	015787bb          	addw	a5,a5,s5
    800037bc:	40d7d79b          	sraiw	a5,a5,0xd
    800037c0:	01cb2583          	lw	a1,28(s6)
    800037c4:	9dbd                	addw	a1,a1,a5
    800037c6:	855e                	mv	a0,s7
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	c66080e7          	jalr	-922(ra) # 8000342e <bread>
    800037d0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037d2:	004b2503          	lw	a0,4(s6)
    800037d6:	000a849b          	sext.w	s1,s5
    800037da:	8762                	mv	a4,s8
    800037dc:	faa4fde3          	bgeu	s1,a0,80003796 <balloc+0xa8>
      m = 1 << (bi % 8);
    800037e0:	00777693          	andi	a3,a4,7
    800037e4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800037e8:	41f7579b          	sraiw	a5,a4,0x1f
    800037ec:	01d7d79b          	srliw	a5,a5,0x1d
    800037f0:	9fb9                	addw	a5,a5,a4
    800037f2:	4037d79b          	sraiw	a5,a5,0x3
    800037f6:	00f90633          	add	a2,s2,a5
    800037fa:	05864603          	lbu	a2,88(a2)
    800037fe:	00c6f5b3          	and	a1,a3,a2
    80003802:	d585                	beqz	a1,8000372a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003804:	2705                	addiw	a4,a4,1
    80003806:	2485                	addiw	s1,s1,1
    80003808:	fd471ae3          	bne	a4,s4,800037dc <balloc+0xee>
    8000380c:	b769                	j	80003796 <balloc+0xa8>
    8000380e:	6906                	ld	s2,64(sp)
    80003810:	79e2                	ld	s3,56(sp)
    80003812:	7a42                	ld	s4,48(sp)
    80003814:	7aa2                	ld	s5,40(sp)
    80003816:	7b02                	ld	s6,32(sp)
    80003818:	6be2                	ld	s7,24(sp)
    8000381a:	6c42                	ld	s8,16(sp)
    8000381c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000381e:	00005517          	auipc	a0,0x5
    80003822:	d0250513          	addi	a0,a0,-766 # 80008520 <etext+0x520>
    80003826:	ffffd097          	auipc	ra,0xffffd
    8000382a:	d84080e7          	jalr	-636(ra) # 800005aa <printf>
  return 0;
    8000382e:	4481                	li	s1,0
    80003830:	bfa9                	j	8000378a <balloc+0x9c>

0000000080003832 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003832:	7179                	addi	sp,sp,-48
    80003834:	f406                	sd	ra,40(sp)
    80003836:	f022                	sd	s0,32(sp)
    80003838:	ec26                	sd	s1,24(sp)
    8000383a:	e84a                	sd	s2,16(sp)
    8000383c:	e44e                	sd	s3,8(sp)
    8000383e:	1800                	addi	s0,sp,48
    80003840:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003842:	47ad                	li	a5,11
    80003844:	02b7e863          	bltu	a5,a1,80003874 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003848:	02059793          	slli	a5,a1,0x20
    8000384c:	01e7d593          	srli	a1,a5,0x1e
    80003850:	00b504b3          	add	s1,a0,a1
    80003854:	0504a903          	lw	s2,80(s1)
    80003858:	08091263          	bnez	s2,800038dc <bmap+0xaa>
      addr = balloc(ip->dev);
    8000385c:	4108                	lw	a0,0(a0)
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	e90080e7          	jalr	-368(ra) # 800036ee <balloc>
    80003866:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000386a:	06090963          	beqz	s2,800038dc <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    8000386e:	0524a823          	sw	s2,80(s1)
    80003872:	a0ad                	j	800038dc <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003874:	ff45849b          	addiw	s1,a1,-12
    80003878:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000387c:	0ff00793          	li	a5,255
    80003880:	08e7e863          	bltu	a5,a4,80003910 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003884:	08052903          	lw	s2,128(a0)
    80003888:	00091f63          	bnez	s2,800038a6 <bmap+0x74>
      addr = balloc(ip->dev);
    8000388c:	4108                	lw	a0,0(a0)
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	e60080e7          	jalr	-416(ra) # 800036ee <balloc>
    80003896:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000389a:	04090163          	beqz	s2,800038dc <bmap+0xaa>
    8000389e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800038a0:	0929a023          	sw	s2,128(s3)
    800038a4:	a011                	j	800038a8 <bmap+0x76>
    800038a6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800038a8:	85ca                	mv	a1,s2
    800038aa:	0009a503          	lw	a0,0(s3)
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	b80080e7          	jalr	-1152(ra) # 8000342e <bread>
    800038b6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038b8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800038bc:	02049713          	slli	a4,s1,0x20
    800038c0:	01e75593          	srli	a1,a4,0x1e
    800038c4:	00b784b3          	add	s1,a5,a1
    800038c8:	0004a903          	lw	s2,0(s1)
    800038cc:	02090063          	beqz	s2,800038ec <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800038d0:	8552                	mv	a0,s4
    800038d2:	00000097          	auipc	ra,0x0
    800038d6:	c8c080e7          	jalr	-884(ra) # 8000355e <brelse>
    return addr;
    800038da:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800038dc:	854a                	mv	a0,s2
    800038de:	70a2                	ld	ra,40(sp)
    800038e0:	7402                	ld	s0,32(sp)
    800038e2:	64e2                	ld	s1,24(sp)
    800038e4:	6942                	ld	s2,16(sp)
    800038e6:	69a2                	ld	s3,8(sp)
    800038e8:	6145                	addi	sp,sp,48
    800038ea:	8082                	ret
      addr = balloc(ip->dev);
    800038ec:	0009a503          	lw	a0,0(s3)
    800038f0:	00000097          	auipc	ra,0x0
    800038f4:	dfe080e7          	jalr	-514(ra) # 800036ee <balloc>
    800038f8:	0005091b          	sext.w	s2,a0
      if(addr){
    800038fc:	fc090ae3          	beqz	s2,800038d0 <bmap+0x9e>
        a[bn] = addr;
    80003900:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003904:	8552                	mv	a0,s4
    80003906:	00001097          	auipc	ra,0x1
    8000390a:	f02080e7          	jalr	-254(ra) # 80004808 <log_write>
    8000390e:	b7c9                	j	800038d0 <bmap+0x9e>
    80003910:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003912:	00005517          	auipc	a0,0x5
    80003916:	c2650513          	addi	a0,a0,-986 # 80008538 <etext+0x538>
    8000391a:	ffffd097          	auipc	ra,0xffffd
    8000391e:	c46080e7          	jalr	-954(ra) # 80000560 <panic>

0000000080003922 <iget>:
{
    80003922:	7179                	addi	sp,sp,-48
    80003924:	f406                	sd	ra,40(sp)
    80003926:	f022                	sd	s0,32(sp)
    80003928:	ec26                	sd	s1,24(sp)
    8000392a:	e84a                	sd	s2,16(sp)
    8000392c:	e44e                	sd	s3,8(sp)
    8000392e:	e052                	sd	s4,0(sp)
    80003930:	1800                	addi	s0,sp,48
    80003932:	89aa                	mv	s3,a0
    80003934:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003936:	0001e517          	auipc	a0,0x1e
    8000393a:	52250513          	addi	a0,a0,1314 # 80021e58 <itable>
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	2fa080e7          	jalr	762(ra) # 80000c38 <acquire>
  empty = 0;
    80003946:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003948:	0001e497          	auipc	s1,0x1e
    8000394c:	52848493          	addi	s1,s1,1320 # 80021e70 <itable+0x18>
    80003950:	00020697          	auipc	a3,0x20
    80003954:	fb068693          	addi	a3,a3,-80 # 80023900 <log>
    80003958:	a039                	j	80003966 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000395a:	02090b63          	beqz	s2,80003990 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000395e:	08848493          	addi	s1,s1,136
    80003962:	02d48a63          	beq	s1,a3,80003996 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003966:	449c                	lw	a5,8(s1)
    80003968:	fef059e3          	blez	a5,8000395a <iget+0x38>
    8000396c:	4098                	lw	a4,0(s1)
    8000396e:	ff3716e3          	bne	a4,s3,8000395a <iget+0x38>
    80003972:	40d8                	lw	a4,4(s1)
    80003974:	ff4713e3          	bne	a4,s4,8000395a <iget+0x38>
      ip->ref++;
    80003978:	2785                	addiw	a5,a5,1
    8000397a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000397c:	0001e517          	auipc	a0,0x1e
    80003980:	4dc50513          	addi	a0,a0,1244 # 80021e58 <itable>
    80003984:	ffffd097          	auipc	ra,0xffffd
    80003988:	368080e7          	jalr	872(ra) # 80000cec <release>
      return ip;
    8000398c:	8926                	mv	s2,s1
    8000398e:	a03d                	j	800039bc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003990:	f7f9                	bnez	a5,8000395e <iget+0x3c>
      empty = ip;
    80003992:	8926                	mv	s2,s1
    80003994:	b7e9                	j	8000395e <iget+0x3c>
  if(empty == 0)
    80003996:	02090c63          	beqz	s2,800039ce <iget+0xac>
  ip->dev = dev;
    8000399a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000399e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800039a2:	4785                	li	a5,1
    800039a4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800039a8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800039ac:	0001e517          	auipc	a0,0x1e
    800039b0:	4ac50513          	addi	a0,a0,1196 # 80021e58 <itable>
    800039b4:	ffffd097          	auipc	ra,0xffffd
    800039b8:	338080e7          	jalr	824(ra) # 80000cec <release>
}
    800039bc:	854a                	mv	a0,s2
    800039be:	70a2                	ld	ra,40(sp)
    800039c0:	7402                	ld	s0,32(sp)
    800039c2:	64e2                	ld	s1,24(sp)
    800039c4:	6942                	ld	s2,16(sp)
    800039c6:	69a2                	ld	s3,8(sp)
    800039c8:	6a02                	ld	s4,0(sp)
    800039ca:	6145                	addi	sp,sp,48
    800039cc:	8082                	ret
    panic("iget: no inodes");
    800039ce:	00005517          	auipc	a0,0x5
    800039d2:	b8250513          	addi	a0,a0,-1150 # 80008550 <etext+0x550>
    800039d6:	ffffd097          	auipc	ra,0xffffd
    800039da:	b8a080e7          	jalr	-1142(ra) # 80000560 <panic>

00000000800039de <fsinit>:
fsinit(int dev) {
    800039de:	7179                	addi	sp,sp,-48
    800039e0:	f406                	sd	ra,40(sp)
    800039e2:	f022                	sd	s0,32(sp)
    800039e4:	ec26                	sd	s1,24(sp)
    800039e6:	e84a                	sd	s2,16(sp)
    800039e8:	e44e                	sd	s3,8(sp)
    800039ea:	1800                	addi	s0,sp,48
    800039ec:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800039ee:	4585                	li	a1,1
    800039f0:	00000097          	auipc	ra,0x0
    800039f4:	a3e080e7          	jalr	-1474(ra) # 8000342e <bread>
    800039f8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039fa:	0001e997          	auipc	s3,0x1e
    800039fe:	43e98993          	addi	s3,s3,1086 # 80021e38 <sb>
    80003a02:	02000613          	li	a2,32
    80003a06:	05850593          	addi	a1,a0,88
    80003a0a:	854e                	mv	a0,s3
    80003a0c:	ffffd097          	auipc	ra,0xffffd
    80003a10:	384080e7          	jalr	900(ra) # 80000d90 <memmove>
  brelse(bp);
    80003a14:	8526                	mv	a0,s1
    80003a16:	00000097          	auipc	ra,0x0
    80003a1a:	b48080e7          	jalr	-1208(ra) # 8000355e <brelse>
  if(sb.magic != FSMAGIC)
    80003a1e:	0009a703          	lw	a4,0(s3)
    80003a22:	102037b7          	lui	a5,0x10203
    80003a26:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a2a:	02f71263          	bne	a4,a5,80003a4e <fsinit+0x70>
  initlog(dev, &sb);
    80003a2e:	0001e597          	auipc	a1,0x1e
    80003a32:	40a58593          	addi	a1,a1,1034 # 80021e38 <sb>
    80003a36:	854a                	mv	a0,s2
    80003a38:	00001097          	auipc	ra,0x1
    80003a3c:	b60080e7          	jalr	-1184(ra) # 80004598 <initlog>
}
    80003a40:	70a2                	ld	ra,40(sp)
    80003a42:	7402                	ld	s0,32(sp)
    80003a44:	64e2                	ld	s1,24(sp)
    80003a46:	6942                	ld	s2,16(sp)
    80003a48:	69a2                	ld	s3,8(sp)
    80003a4a:	6145                	addi	sp,sp,48
    80003a4c:	8082                	ret
    panic("invalid file system");
    80003a4e:	00005517          	auipc	a0,0x5
    80003a52:	b1250513          	addi	a0,a0,-1262 # 80008560 <etext+0x560>
    80003a56:	ffffd097          	auipc	ra,0xffffd
    80003a5a:	b0a080e7          	jalr	-1270(ra) # 80000560 <panic>

0000000080003a5e <iinit>:
{
    80003a5e:	7179                	addi	sp,sp,-48
    80003a60:	f406                	sd	ra,40(sp)
    80003a62:	f022                	sd	s0,32(sp)
    80003a64:	ec26                	sd	s1,24(sp)
    80003a66:	e84a                	sd	s2,16(sp)
    80003a68:	e44e                	sd	s3,8(sp)
    80003a6a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a6c:	00005597          	auipc	a1,0x5
    80003a70:	b0c58593          	addi	a1,a1,-1268 # 80008578 <etext+0x578>
    80003a74:	0001e517          	auipc	a0,0x1e
    80003a78:	3e450513          	addi	a0,a0,996 # 80021e58 <itable>
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	12c080e7          	jalr	300(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a84:	0001e497          	auipc	s1,0x1e
    80003a88:	3fc48493          	addi	s1,s1,1020 # 80021e80 <itable+0x28>
    80003a8c:	00020997          	auipc	s3,0x20
    80003a90:	e8498993          	addi	s3,s3,-380 # 80023910 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a94:	00005917          	auipc	s2,0x5
    80003a98:	aec90913          	addi	s2,s2,-1300 # 80008580 <etext+0x580>
    80003a9c:	85ca                	mv	a1,s2
    80003a9e:	8526                	mv	a0,s1
    80003aa0:	00001097          	auipc	ra,0x1
    80003aa4:	e4c080e7          	jalr	-436(ra) # 800048ec <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003aa8:	08848493          	addi	s1,s1,136
    80003aac:	ff3498e3          	bne	s1,s3,80003a9c <iinit+0x3e>
}
    80003ab0:	70a2                	ld	ra,40(sp)
    80003ab2:	7402                	ld	s0,32(sp)
    80003ab4:	64e2                	ld	s1,24(sp)
    80003ab6:	6942                	ld	s2,16(sp)
    80003ab8:	69a2                	ld	s3,8(sp)
    80003aba:	6145                	addi	sp,sp,48
    80003abc:	8082                	ret

0000000080003abe <ialloc>:
{
    80003abe:	7139                	addi	sp,sp,-64
    80003ac0:	fc06                	sd	ra,56(sp)
    80003ac2:	f822                	sd	s0,48(sp)
    80003ac4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ac6:	0001e717          	auipc	a4,0x1e
    80003aca:	37e72703          	lw	a4,894(a4) # 80021e44 <sb+0xc>
    80003ace:	4785                	li	a5,1
    80003ad0:	06e7f463          	bgeu	a5,a4,80003b38 <ialloc+0x7a>
    80003ad4:	f426                	sd	s1,40(sp)
    80003ad6:	f04a                	sd	s2,32(sp)
    80003ad8:	ec4e                	sd	s3,24(sp)
    80003ada:	e852                	sd	s4,16(sp)
    80003adc:	e456                	sd	s5,8(sp)
    80003ade:	e05a                	sd	s6,0(sp)
    80003ae0:	8aaa                	mv	s5,a0
    80003ae2:	8b2e                	mv	s6,a1
    80003ae4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003ae6:	0001ea17          	auipc	s4,0x1e
    80003aea:	352a0a13          	addi	s4,s4,850 # 80021e38 <sb>
    80003aee:	00495593          	srli	a1,s2,0x4
    80003af2:	018a2783          	lw	a5,24(s4)
    80003af6:	9dbd                	addw	a1,a1,a5
    80003af8:	8556                	mv	a0,s5
    80003afa:	00000097          	auipc	ra,0x0
    80003afe:	934080e7          	jalr	-1740(ra) # 8000342e <bread>
    80003b02:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b04:	05850993          	addi	s3,a0,88
    80003b08:	00f97793          	andi	a5,s2,15
    80003b0c:	079a                	slli	a5,a5,0x6
    80003b0e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b10:	00099783          	lh	a5,0(s3)
    80003b14:	cf9d                	beqz	a5,80003b52 <ialloc+0x94>
    brelse(bp);
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	a48080e7          	jalr	-1464(ra) # 8000355e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b1e:	0905                	addi	s2,s2,1
    80003b20:	00ca2703          	lw	a4,12(s4)
    80003b24:	0009079b          	sext.w	a5,s2
    80003b28:	fce7e3e3          	bltu	a5,a4,80003aee <ialloc+0x30>
    80003b2c:	74a2                	ld	s1,40(sp)
    80003b2e:	7902                	ld	s2,32(sp)
    80003b30:	69e2                	ld	s3,24(sp)
    80003b32:	6a42                	ld	s4,16(sp)
    80003b34:	6aa2                	ld	s5,8(sp)
    80003b36:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003b38:	00005517          	auipc	a0,0x5
    80003b3c:	a5050513          	addi	a0,a0,-1456 # 80008588 <etext+0x588>
    80003b40:	ffffd097          	auipc	ra,0xffffd
    80003b44:	a6a080e7          	jalr	-1430(ra) # 800005aa <printf>
  return 0;
    80003b48:	4501                	li	a0,0
}
    80003b4a:	70e2                	ld	ra,56(sp)
    80003b4c:	7442                	ld	s0,48(sp)
    80003b4e:	6121                	addi	sp,sp,64
    80003b50:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b52:	04000613          	li	a2,64
    80003b56:	4581                	li	a1,0
    80003b58:	854e                	mv	a0,s3
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	1da080e7          	jalr	474(ra) # 80000d34 <memset>
      dip->type = type;
    80003b62:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b66:	8526                	mv	a0,s1
    80003b68:	00001097          	auipc	ra,0x1
    80003b6c:	ca0080e7          	jalr	-864(ra) # 80004808 <log_write>
      brelse(bp);
    80003b70:	8526                	mv	a0,s1
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	9ec080e7          	jalr	-1556(ra) # 8000355e <brelse>
      return iget(dev, inum);
    80003b7a:	0009059b          	sext.w	a1,s2
    80003b7e:	8556                	mv	a0,s5
    80003b80:	00000097          	auipc	ra,0x0
    80003b84:	da2080e7          	jalr	-606(ra) # 80003922 <iget>
    80003b88:	74a2                	ld	s1,40(sp)
    80003b8a:	7902                	ld	s2,32(sp)
    80003b8c:	69e2                	ld	s3,24(sp)
    80003b8e:	6a42                	ld	s4,16(sp)
    80003b90:	6aa2                	ld	s5,8(sp)
    80003b92:	6b02                	ld	s6,0(sp)
    80003b94:	bf5d                	j	80003b4a <ialloc+0x8c>

0000000080003b96 <iupdate>:
{
    80003b96:	1101                	addi	sp,sp,-32
    80003b98:	ec06                	sd	ra,24(sp)
    80003b9a:	e822                	sd	s0,16(sp)
    80003b9c:	e426                	sd	s1,8(sp)
    80003b9e:	e04a                	sd	s2,0(sp)
    80003ba0:	1000                	addi	s0,sp,32
    80003ba2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ba4:	415c                	lw	a5,4(a0)
    80003ba6:	0047d79b          	srliw	a5,a5,0x4
    80003baa:	0001e597          	auipc	a1,0x1e
    80003bae:	2a65a583          	lw	a1,678(a1) # 80021e50 <sb+0x18>
    80003bb2:	9dbd                	addw	a1,a1,a5
    80003bb4:	4108                	lw	a0,0(a0)
    80003bb6:	00000097          	auipc	ra,0x0
    80003bba:	878080e7          	jalr	-1928(ra) # 8000342e <bread>
    80003bbe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003bc0:	05850793          	addi	a5,a0,88
    80003bc4:	40d8                	lw	a4,4(s1)
    80003bc6:	8b3d                	andi	a4,a4,15
    80003bc8:	071a                	slli	a4,a4,0x6
    80003bca:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003bcc:	04449703          	lh	a4,68(s1)
    80003bd0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003bd4:	04649703          	lh	a4,70(s1)
    80003bd8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003bdc:	04849703          	lh	a4,72(s1)
    80003be0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003be4:	04a49703          	lh	a4,74(s1)
    80003be8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003bec:	44f8                	lw	a4,76(s1)
    80003bee:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003bf0:	03400613          	li	a2,52
    80003bf4:	05048593          	addi	a1,s1,80
    80003bf8:	00c78513          	addi	a0,a5,12
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	194080e7          	jalr	404(ra) # 80000d90 <memmove>
  log_write(bp);
    80003c04:	854a                	mv	a0,s2
    80003c06:	00001097          	auipc	ra,0x1
    80003c0a:	c02080e7          	jalr	-1022(ra) # 80004808 <log_write>
  brelse(bp);
    80003c0e:	854a                	mv	a0,s2
    80003c10:	00000097          	auipc	ra,0x0
    80003c14:	94e080e7          	jalr	-1714(ra) # 8000355e <brelse>
}
    80003c18:	60e2                	ld	ra,24(sp)
    80003c1a:	6442                	ld	s0,16(sp)
    80003c1c:	64a2                	ld	s1,8(sp)
    80003c1e:	6902                	ld	s2,0(sp)
    80003c20:	6105                	addi	sp,sp,32
    80003c22:	8082                	ret

0000000080003c24 <idup>:
{
    80003c24:	1101                	addi	sp,sp,-32
    80003c26:	ec06                	sd	ra,24(sp)
    80003c28:	e822                	sd	s0,16(sp)
    80003c2a:	e426                	sd	s1,8(sp)
    80003c2c:	1000                	addi	s0,sp,32
    80003c2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c30:	0001e517          	auipc	a0,0x1e
    80003c34:	22850513          	addi	a0,a0,552 # 80021e58 <itable>
    80003c38:	ffffd097          	auipc	ra,0xffffd
    80003c3c:	000080e7          	jalr	ra # 80000c38 <acquire>
  ip->ref++;
    80003c40:	449c                	lw	a5,8(s1)
    80003c42:	2785                	addiw	a5,a5,1
    80003c44:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c46:	0001e517          	auipc	a0,0x1e
    80003c4a:	21250513          	addi	a0,a0,530 # 80021e58 <itable>
    80003c4e:	ffffd097          	auipc	ra,0xffffd
    80003c52:	09e080e7          	jalr	158(ra) # 80000cec <release>
}
    80003c56:	8526                	mv	a0,s1
    80003c58:	60e2                	ld	ra,24(sp)
    80003c5a:	6442                	ld	s0,16(sp)
    80003c5c:	64a2                	ld	s1,8(sp)
    80003c5e:	6105                	addi	sp,sp,32
    80003c60:	8082                	ret

0000000080003c62 <ilock>:
{
    80003c62:	1101                	addi	sp,sp,-32
    80003c64:	ec06                	sd	ra,24(sp)
    80003c66:	e822                	sd	s0,16(sp)
    80003c68:	e426                	sd	s1,8(sp)
    80003c6a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c6c:	c10d                	beqz	a0,80003c8e <ilock+0x2c>
    80003c6e:	84aa                	mv	s1,a0
    80003c70:	451c                	lw	a5,8(a0)
    80003c72:	00f05e63          	blez	a5,80003c8e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003c76:	0541                	addi	a0,a0,16
    80003c78:	00001097          	auipc	ra,0x1
    80003c7c:	cae080e7          	jalr	-850(ra) # 80004926 <acquiresleep>
  if(ip->valid == 0){
    80003c80:	40bc                	lw	a5,64(s1)
    80003c82:	cf99                	beqz	a5,80003ca0 <ilock+0x3e>
}
    80003c84:	60e2                	ld	ra,24(sp)
    80003c86:	6442                	ld	s0,16(sp)
    80003c88:	64a2                	ld	s1,8(sp)
    80003c8a:	6105                	addi	sp,sp,32
    80003c8c:	8082                	ret
    80003c8e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003c90:	00005517          	auipc	a0,0x5
    80003c94:	91050513          	addi	a0,a0,-1776 # 800085a0 <etext+0x5a0>
    80003c98:	ffffd097          	auipc	ra,0xffffd
    80003c9c:	8c8080e7          	jalr	-1848(ra) # 80000560 <panic>
    80003ca0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ca2:	40dc                	lw	a5,4(s1)
    80003ca4:	0047d79b          	srliw	a5,a5,0x4
    80003ca8:	0001e597          	auipc	a1,0x1e
    80003cac:	1a85a583          	lw	a1,424(a1) # 80021e50 <sb+0x18>
    80003cb0:	9dbd                	addw	a1,a1,a5
    80003cb2:	4088                	lw	a0,0(s1)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	77a080e7          	jalr	1914(ra) # 8000342e <bread>
    80003cbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003cbe:	05850593          	addi	a1,a0,88
    80003cc2:	40dc                	lw	a5,4(s1)
    80003cc4:	8bbd                	andi	a5,a5,15
    80003cc6:	079a                	slli	a5,a5,0x6
    80003cc8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003cca:	00059783          	lh	a5,0(a1)
    80003cce:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003cd2:	00259783          	lh	a5,2(a1)
    80003cd6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003cda:	00459783          	lh	a5,4(a1)
    80003cde:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ce2:	00659783          	lh	a5,6(a1)
    80003ce6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003cea:	459c                	lw	a5,8(a1)
    80003cec:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003cee:	03400613          	li	a2,52
    80003cf2:	05b1                	addi	a1,a1,12
    80003cf4:	05048513          	addi	a0,s1,80
    80003cf8:	ffffd097          	auipc	ra,0xffffd
    80003cfc:	098080e7          	jalr	152(ra) # 80000d90 <memmove>
    brelse(bp);
    80003d00:	854a                	mv	a0,s2
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	85c080e7          	jalr	-1956(ra) # 8000355e <brelse>
    ip->valid = 1;
    80003d0a:	4785                	li	a5,1
    80003d0c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d0e:	04449783          	lh	a5,68(s1)
    80003d12:	c399                	beqz	a5,80003d18 <ilock+0xb6>
    80003d14:	6902                	ld	s2,0(sp)
    80003d16:	b7bd                	j	80003c84 <ilock+0x22>
      panic("ilock: no type");
    80003d18:	00005517          	auipc	a0,0x5
    80003d1c:	89050513          	addi	a0,a0,-1904 # 800085a8 <etext+0x5a8>
    80003d20:	ffffd097          	auipc	ra,0xffffd
    80003d24:	840080e7          	jalr	-1984(ra) # 80000560 <panic>

0000000080003d28 <iunlock>:
{
    80003d28:	1101                	addi	sp,sp,-32
    80003d2a:	ec06                	sd	ra,24(sp)
    80003d2c:	e822                	sd	s0,16(sp)
    80003d2e:	e426                	sd	s1,8(sp)
    80003d30:	e04a                	sd	s2,0(sp)
    80003d32:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d34:	c905                	beqz	a0,80003d64 <iunlock+0x3c>
    80003d36:	84aa                	mv	s1,a0
    80003d38:	01050913          	addi	s2,a0,16
    80003d3c:	854a                	mv	a0,s2
    80003d3e:	00001097          	auipc	ra,0x1
    80003d42:	c82080e7          	jalr	-894(ra) # 800049c0 <holdingsleep>
    80003d46:	cd19                	beqz	a0,80003d64 <iunlock+0x3c>
    80003d48:	449c                	lw	a5,8(s1)
    80003d4a:	00f05d63          	blez	a5,80003d64 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d4e:	854a                	mv	a0,s2
    80003d50:	00001097          	auipc	ra,0x1
    80003d54:	c2c080e7          	jalr	-980(ra) # 8000497c <releasesleep>
}
    80003d58:	60e2                	ld	ra,24(sp)
    80003d5a:	6442                	ld	s0,16(sp)
    80003d5c:	64a2                	ld	s1,8(sp)
    80003d5e:	6902                	ld	s2,0(sp)
    80003d60:	6105                	addi	sp,sp,32
    80003d62:	8082                	ret
    panic("iunlock");
    80003d64:	00005517          	auipc	a0,0x5
    80003d68:	85450513          	addi	a0,a0,-1964 # 800085b8 <etext+0x5b8>
    80003d6c:	ffffc097          	auipc	ra,0xffffc
    80003d70:	7f4080e7          	jalr	2036(ra) # 80000560 <panic>

0000000080003d74 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d74:	7179                	addi	sp,sp,-48
    80003d76:	f406                	sd	ra,40(sp)
    80003d78:	f022                	sd	s0,32(sp)
    80003d7a:	ec26                	sd	s1,24(sp)
    80003d7c:	e84a                	sd	s2,16(sp)
    80003d7e:	e44e                	sd	s3,8(sp)
    80003d80:	1800                	addi	s0,sp,48
    80003d82:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d84:	05050493          	addi	s1,a0,80
    80003d88:	08050913          	addi	s2,a0,128
    80003d8c:	a021                	j	80003d94 <itrunc+0x20>
    80003d8e:	0491                	addi	s1,s1,4
    80003d90:	01248d63          	beq	s1,s2,80003daa <itrunc+0x36>
    if(ip->addrs[i]){
    80003d94:	408c                	lw	a1,0(s1)
    80003d96:	dde5                	beqz	a1,80003d8e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003d98:	0009a503          	lw	a0,0(s3)
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	8d6080e7          	jalr	-1834(ra) # 80003672 <bfree>
      ip->addrs[i] = 0;
    80003da4:	0004a023          	sw	zero,0(s1)
    80003da8:	b7dd                	j	80003d8e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003daa:	0809a583          	lw	a1,128(s3)
    80003dae:	ed99                	bnez	a1,80003dcc <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003db0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003db4:	854e                	mv	a0,s3
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	de0080e7          	jalr	-544(ra) # 80003b96 <iupdate>
}
    80003dbe:	70a2                	ld	ra,40(sp)
    80003dc0:	7402                	ld	s0,32(sp)
    80003dc2:	64e2                	ld	s1,24(sp)
    80003dc4:	6942                	ld	s2,16(sp)
    80003dc6:	69a2                	ld	s3,8(sp)
    80003dc8:	6145                	addi	sp,sp,48
    80003dca:	8082                	ret
    80003dcc:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003dce:	0009a503          	lw	a0,0(s3)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	65c080e7          	jalr	1628(ra) # 8000342e <bread>
    80003dda:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003ddc:	05850493          	addi	s1,a0,88
    80003de0:	45850913          	addi	s2,a0,1112
    80003de4:	a021                	j	80003dec <itrunc+0x78>
    80003de6:	0491                	addi	s1,s1,4
    80003de8:	01248b63          	beq	s1,s2,80003dfe <itrunc+0x8a>
      if(a[j])
    80003dec:	408c                	lw	a1,0(s1)
    80003dee:	dde5                	beqz	a1,80003de6 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003df0:	0009a503          	lw	a0,0(s3)
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	87e080e7          	jalr	-1922(ra) # 80003672 <bfree>
    80003dfc:	b7ed                	j	80003de6 <itrunc+0x72>
    brelse(bp);
    80003dfe:	8552                	mv	a0,s4
    80003e00:	fffff097          	auipc	ra,0xfffff
    80003e04:	75e080e7          	jalr	1886(ra) # 8000355e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e08:	0809a583          	lw	a1,128(s3)
    80003e0c:	0009a503          	lw	a0,0(s3)
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	862080e7          	jalr	-1950(ra) # 80003672 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e18:	0809a023          	sw	zero,128(s3)
    80003e1c:	6a02                	ld	s4,0(sp)
    80003e1e:	bf49                	j	80003db0 <itrunc+0x3c>

0000000080003e20 <iput>:
{
    80003e20:	1101                	addi	sp,sp,-32
    80003e22:	ec06                	sd	ra,24(sp)
    80003e24:	e822                	sd	s0,16(sp)
    80003e26:	e426                	sd	s1,8(sp)
    80003e28:	1000                	addi	s0,sp,32
    80003e2a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e2c:	0001e517          	auipc	a0,0x1e
    80003e30:	02c50513          	addi	a0,a0,44 # 80021e58 <itable>
    80003e34:	ffffd097          	auipc	ra,0xffffd
    80003e38:	e04080e7          	jalr	-508(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e3c:	4498                	lw	a4,8(s1)
    80003e3e:	4785                	li	a5,1
    80003e40:	02f70263          	beq	a4,a5,80003e64 <iput+0x44>
  ip->ref--;
    80003e44:	449c                	lw	a5,8(s1)
    80003e46:	37fd                	addiw	a5,a5,-1
    80003e48:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e4a:	0001e517          	auipc	a0,0x1e
    80003e4e:	00e50513          	addi	a0,a0,14 # 80021e58 <itable>
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	e9a080e7          	jalr	-358(ra) # 80000cec <release>
}
    80003e5a:	60e2                	ld	ra,24(sp)
    80003e5c:	6442                	ld	s0,16(sp)
    80003e5e:	64a2                	ld	s1,8(sp)
    80003e60:	6105                	addi	sp,sp,32
    80003e62:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e64:	40bc                	lw	a5,64(s1)
    80003e66:	dff9                	beqz	a5,80003e44 <iput+0x24>
    80003e68:	04a49783          	lh	a5,74(s1)
    80003e6c:	ffe1                	bnez	a5,80003e44 <iput+0x24>
    80003e6e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003e70:	01048913          	addi	s2,s1,16
    80003e74:	854a                	mv	a0,s2
    80003e76:	00001097          	auipc	ra,0x1
    80003e7a:	ab0080e7          	jalr	-1360(ra) # 80004926 <acquiresleep>
    release(&itable.lock);
    80003e7e:	0001e517          	auipc	a0,0x1e
    80003e82:	fda50513          	addi	a0,a0,-38 # 80021e58 <itable>
    80003e86:	ffffd097          	auipc	ra,0xffffd
    80003e8a:	e66080e7          	jalr	-410(ra) # 80000cec <release>
    itrunc(ip);
    80003e8e:	8526                	mv	a0,s1
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	ee4080e7          	jalr	-284(ra) # 80003d74 <itrunc>
    ip->type = 0;
    80003e98:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	00000097          	auipc	ra,0x0
    80003ea2:	cf8080e7          	jalr	-776(ra) # 80003b96 <iupdate>
    ip->valid = 0;
    80003ea6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003eaa:	854a                	mv	a0,s2
    80003eac:	00001097          	auipc	ra,0x1
    80003eb0:	ad0080e7          	jalr	-1328(ra) # 8000497c <releasesleep>
    acquire(&itable.lock);
    80003eb4:	0001e517          	auipc	a0,0x1e
    80003eb8:	fa450513          	addi	a0,a0,-92 # 80021e58 <itable>
    80003ebc:	ffffd097          	auipc	ra,0xffffd
    80003ec0:	d7c080e7          	jalr	-644(ra) # 80000c38 <acquire>
    80003ec4:	6902                	ld	s2,0(sp)
    80003ec6:	bfbd                	j	80003e44 <iput+0x24>

0000000080003ec8 <iunlockput>:
{
    80003ec8:	1101                	addi	sp,sp,-32
    80003eca:	ec06                	sd	ra,24(sp)
    80003ecc:	e822                	sd	s0,16(sp)
    80003ece:	e426                	sd	s1,8(sp)
    80003ed0:	1000                	addi	s0,sp,32
    80003ed2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ed4:	00000097          	auipc	ra,0x0
    80003ed8:	e54080e7          	jalr	-428(ra) # 80003d28 <iunlock>
  iput(ip);
    80003edc:	8526                	mv	a0,s1
    80003ede:	00000097          	auipc	ra,0x0
    80003ee2:	f42080e7          	jalr	-190(ra) # 80003e20 <iput>
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	64a2                	ld	s1,8(sp)
    80003eec:	6105                	addi	sp,sp,32
    80003eee:	8082                	ret

0000000080003ef0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003ef0:	1141                	addi	sp,sp,-16
    80003ef2:	e422                	sd	s0,8(sp)
    80003ef4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ef6:	411c                	lw	a5,0(a0)
    80003ef8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003efa:	415c                	lw	a5,4(a0)
    80003efc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003efe:	04451783          	lh	a5,68(a0)
    80003f02:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f06:	04a51783          	lh	a5,74(a0)
    80003f0a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f0e:	04c56783          	lwu	a5,76(a0)
    80003f12:	e99c                	sd	a5,16(a1)
}
    80003f14:	6422                	ld	s0,8(sp)
    80003f16:	0141                	addi	sp,sp,16
    80003f18:	8082                	ret

0000000080003f1a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f1a:	457c                	lw	a5,76(a0)
    80003f1c:	10d7e563          	bltu	a5,a3,80004026 <readi+0x10c>
{
    80003f20:	7159                	addi	sp,sp,-112
    80003f22:	f486                	sd	ra,104(sp)
    80003f24:	f0a2                	sd	s0,96(sp)
    80003f26:	eca6                	sd	s1,88(sp)
    80003f28:	e0d2                	sd	s4,64(sp)
    80003f2a:	fc56                	sd	s5,56(sp)
    80003f2c:	f85a                	sd	s6,48(sp)
    80003f2e:	f45e                	sd	s7,40(sp)
    80003f30:	1880                	addi	s0,sp,112
    80003f32:	8b2a                	mv	s6,a0
    80003f34:	8bae                	mv	s7,a1
    80003f36:	8a32                	mv	s4,a2
    80003f38:	84b6                	mv	s1,a3
    80003f3a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f3c:	9f35                	addw	a4,a4,a3
    return 0;
    80003f3e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f40:	0cd76a63          	bltu	a4,a3,80004014 <readi+0xfa>
    80003f44:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003f46:	00e7f463          	bgeu	a5,a4,80003f4e <readi+0x34>
    n = ip->size - off;
    80003f4a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f4e:	0a0a8963          	beqz	s5,80004000 <readi+0xe6>
    80003f52:	e8ca                	sd	s2,80(sp)
    80003f54:	f062                	sd	s8,32(sp)
    80003f56:	ec66                	sd	s9,24(sp)
    80003f58:	e86a                	sd	s10,16(sp)
    80003f5a:	e46e                	sd	s11,8(sp)
    80003f5c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f5e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f62:	5c7d                	li	s8,-1
    80003f64:	a82d                	j	80003f9e <readi+0x84>
    80003f66:	020d1d93          	slli	s11,s10,0x20
    80003f6a:	020ddd93          	srli	s11,s11,0x20
    80003f6e:	05890613          	addi	a2,s2,88
    80003f72:	86ee                	mv	a3,s11
    80003f74:	963a                	add	a2,a2,a4
    80003f76:	85d2                	mv	a1,s4
    80003f78:	855e                	mv	a0,s7
    80003f7a:	fffff097          	auipc	ra,0xfffff
    80003f7e:	8fa080e7          	jalr	-1798(ra) # 80002874 <either_copyout>
    80003f82:	05850d63          	beq	a0,s8,80003fdc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f86:	854a                	mv	a0,s2
    80003f88:	fffff097          	auipc	ra,0xfffff
    80003f8c:	5d6080e7          	jalr	1494(ra) # 8000355e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f90:	013d09bb          	addw	s3,s10,s3
    80003f94:	009d04bb          	addw	s1,s10,s1
    80003f98:	9a6e                	add	s4,s4,s11
    80003f9a:	0559fd63          	bgeu	s3,s5,80003ff4 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003f9e:	00a4d59b          	srliw	a1,s1,0xa
    80003fa2:	855a                	mv	a0,s6
    80003fa4:	00000097          	auipc	ra,0x0
    80003fa8:	88e080e7          	jalr	-1906(ra) # 80003832 <bmap>
    80003fac:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003fb0:	c9b1                	beqz	a1,80004004 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003fb2:	000b2503          	lw	a0,0(s6)
    80003fb6:	fffff097          	auipc	ra,0xfffff
    80003fba:	478080e7          	jalr	1144(ra) # 8000342e <bread>
    80003fbe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fc0:	3ff4f713          	andi	a4,s1,1023
    80003fc4:	40ec87bb          	subw	a5,s9,a4
    80003fc8:	413a86bb          	subw	a3,s5,s3
    80003fcc:	8d3e                	mv	s10,a5
    80003fce:	2781                	sext.w	a5,a5
    80003fd0:	0006861b          	sext.w	a2,a3
    80003fd4:	f8f679e3          	bgeu	a2,a5,80003f66 <readi+0x4c>
    80003fd8:	8d36                	mv	s10,a3
    80003fda:	b771                	j	80003f66 <readi+0x4c>
      brelse(bp);
    80003fdc:	854a                	mv	a0,s2
    80003fde:	fffff097          	auipc	ra,0xfffff
    80003fe2:	580080e7          	jalr	1408(ra) # 8000355e <brelse>
      tot = -1;
    80003fe6:	59fd                	li	s3,-1
      break;
    80003fe8:	6946                	ld	s2,80(sp)
    80003fea:	7c02                	ld	s8,32(sp)
    80003fec:	6ce2                	ld	s9,24(sp)
    80003fee:	6d42                	ld	s10,16(sp)
    80003ff0:	6da2                	ld	s11,8(sp)
    80003ff2:	a831                	j	8000400e <readi+0xf4>
    80003ff4:	6946                	ld	s2,80(sp)
    80003ff6:	7c02                	ld	s8,32(sp)
    80003ff8:	6ce2                	ld	s9,24(sp)
    80003ffa:	6d42                	ld	s10,16(sp)
    80003ffc:	6da2                	ld	s11,8(sp)
    80003ffe:	a801                	j	8000400e <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004000:	89d6                	mv	s3,s5
    80004002:	a031                	j	8000400e <readi+0xf4>
    80004004:	6946                	ld	s2,80(sp)
    80004006:	7c02                	ld	s8,32(sp)
    80004008:	6ce2                	ld	s9,24(sp)
    8000400a:	6d42                	ld	s10,16(sp)
    8000400c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000400e:	0009851b          	sext.w	a0,s3
    80004012:	69a6                	ld	s3,72(sp)
}
    80004014:	70a6                	ld	ra,104(sp)
    80004016:	7406                	ld	s0,96(sp)
    80004018:	64e6                	ld	s1,88(sp)
    8000401a:	6a06                	ld	s4,64(sp)
    8000401c:	7ae2                	ld	s5,56(sp)
    8000401e:	7b42                	ld	s6,48(sp)
    80004020:	7ba2                	ld	s7,40(sp)
    80004022:	6165                	addi	sp,sp,112
    80004024:	8082                	ret
    return 0;
    80004026:	4501                	li	a0,0
}
    80004028:	8082                	ret

000000008000402a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000402a:	457c                	lw	a5,76(a0)
    8000402c:	10d7ee63          	bltu	a5,a3,80004148 <writei+0x11e>
{
    80004030:	7159                	addi	sp,sp,-112
    80004032:	f486                	sd	ra,104(sp)
    80004034:	f0a2                	sd	s0,96(sp)
    80004036:	e8ca                	sd	s2,80(sp)
    80004038:	e0d2                	sd	s4,64(sp)
    8000403a:	fc56                	sd	s5,56(sp)
    8000403c:	f85a                	sd	s6,48(sp)
    8000403e:	f45e                	sd	s7,40(sp)
    80004040:	1880                	addi	s0,sp,112
    80004042:	8aaa                	mv	s5,a0
    80004044:	8bae                	mv	s7,a1
    80004046:	8a32                	mv	s4,a2
    80004048:	8936                	mv	s2,a3
    8000404a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000404c:	00e687bb          	addw	a5,a3,a4
    80004050:	0ed7ee63          	bltu	a5,a3,8000414c <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004054:	00043737          	lui	a4,0x43
    80004058:	0ef76c63          	bltu	a4,a5,80004150 <writei+0x126>
    8000405c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000405e:	0c0b0d63          	beqz	s6,80004138 <writei+0x10e>
    80004062:	eca6                	sd	s1,88(sp)
    80004064:	f062                	sd	s8,32(sp)
    80004066:	ec66                	sd	s9,24(sp)
    80004068:	e86a                	sd	s10,16(sp)
    8000406a:	e46e                	sd	s11,8(sp)
    8000406c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000406e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004072:	5c7d                	li	s8,-1
    80004074:	a091                	j	800040b8 <writei+0x8e>
    80004076:	020d1d93          	slli	s11,s10,0x20
    8000407a:	020ddd93          	srli	s11,s11,0x20
    8000407e:	05848513          	addi	a0,s1,88
    80004082:	86ee                	mv	a3,s11
    80004084:	8652                	mv	a2,s4
    80004086:	85de                	mv	a1,s7
    80004088:	953a                	add	a0,a0,a4
    8000408a:	fffff097          	auipc	ra,0xfffff
    8000408e:	840080e7          	jalr	-1984(ra) # 800028ca <either_copyin>
    80004092:	07850263          	beq	a0,s8,800040f6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004096:	8526                	mv	a0,s1
    80004098:	00000097          	auipc	ra,0x0
    8000409c:	770080e7          	jalr	1904(ra) # 80004808 <log_write>
    brelse(bp);
    800040a0:	8526                	mv	a0,s1
    800040a2:	fffff097          	auipc	ra,0xfffff
    800040a6:	4bc080e7          	jalr	1212(ra) # 8000355e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040aa:	013d09bb          	addw	s3,s10,s3
    800040ae:	012d093b          	addw	s2,s10,s2
    800040b2:	9a6e                	add	s4,s4,s11
    800040b4:	0569f663          	bgeu	s3,s6,80004100 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800040b8:	00a9559b          	srliw	a1,s2,0xa
    800040bc:	8556                	mv	a0,s5
    800040be:	fffff097          	auipc	ra,0xfffff
    800040c2:	774080e7          	jalr	1908(ra) # 80003832 <bmap>
    800040c6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800040ca:	c99d                	beqz	a1,80004100 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800040cc:	000aa503          	lw	a0,0(s5)
    800040d0:	fffff097          	auipc	ra,0xfffff
    800040d4:	35e080e7          	jalr	862(ra) # 8000342e <bread>
    800040d8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040da:	3ff97713          	andi	a4,s2,1023
    800040de:	40ec87bb          	subw	a5,s9,a4
    800040e2:	413b06bb          	subw	a3,s6,s3
    800040e6:	8d3e                	mv	s10,a5
    800040e8:	2781                	sext.w	a5,a5
    800040ea:	0006861b          	sext.w	a2,a3
    800040ee:	f8f674e3          	bgeu	a2,a5,80004076 <writei+0x4c>
    800040f2:	8d36                	mv	s10,a3
    800040f4:	b749                	j	80004076 <writei+0x4c>
      brelse(bp);
    800040f6:	8526                	mv	a0,s1
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	466080e7          	jalr	1126(ra) # 8000355e <brelse>
  }

  if(off > ip->size)
    80004100:	04caa783          	lw	a5,76(s5)
    80004104:	0327fc63          	bgeu	a5,s2,8000413c <writei+0x112>
    ip->size = off;
    80004108:	052aa623          	sw	s2,76(s5)
    8000410c:	64e6                	ld	s1,88(sp)
    8000410e:	7c02                	ld	s8,32(sp)
    80004110:	6ce2                	ld	s9,24(sp)
    80004112:	6d42                	ld	s10,16(sp)
    80004114:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004116:	8556                	mv	a0,s5
    80004118:	00000097          	auipc	ra,0x0
    8000411c:	a7e080e7          	jalr	-1410(ra) # 80003b96 <iupdate>

  return tot;
    80004120:	0009851b          	sext.w	a0,s3
    80004124:	69a6                	ld	s3,72(sp)
}
    80004126:	70a6                	ld	ra,104(sp)
    80004128:	7406                	ld	s0,96(sp)
    8000412a:	6946                	ld	s2,80(sp)
    8000412c:	6a06                	ld	s4,64(sp)
    8000412e:	7ae2                	ld	s5,56(sp)
    80004130:	7b42                	ld	s6,48(sp)
    80004132:	7ba2                	ld	s7,40(sp)
    80004134:	6165                	addi	sp,sp,112
    80004136:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004138:	89da                	mv	s3,s6
    8000413a:	bff1                	j	80004116 <writei+0xec>
    8000413c:	64e6                	ld	s1,88(sp)
    8000413e:	7c02                	ld	s8,32(sp)
    80004140:	6ce2                	ld	s9,24(sp)
    80004142:	6d42                	ld	s10,16(sp)
    80004144:	6da2                	ld	s11,8(sp)
    80004146:	bfc1                	j	80004116 <writei+0xec>
    return -1;
    80004148:	557d                	li	a0,-1
}
    8000414a:	8082                	ret
    return -1;
    8000414c:	557d                	li	a0,-1
    8000414e:	bfe1                	j	80004126 <writei+0xfc>
    return -1;
    80004150:	557d                	li	a0,-1
    80004152:	bfd1                	j	80004126 <writei+0xfc>

0000000080004154 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004154:	1141                	addi	sp,sp,-16
    80004156:	e406                	sd	ra,8(sp)
    80004158:	e022                	sd	s0,0(sp)
    8000415a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000415c:	4639                	li	a2,14
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	ca6080e7          	jalr	-858(ra) # 80000e04 <strncmp>
}
    80004166:	60a2                	ld	ra,8(sp)
    80004168:	6402                	ld	s0,0(sp)
    8000416a:	0141                	addi	sp,sp,16
    8000416c:	8082                	ret

000000008000416e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000416e:	7139                	addi	sp,sp,-64
    80004170:	fc06                	sd	ra,56(sp)
    80004172:	f822                	sd	s0,48(sp)
    80004174:	f426                	sd	s1,40(sp)
    80004176:	f04a                	sd	s2,32(sp)
    80004178:	ec4e                	sd	s3,24(sp)
    8000417a:	e852                	sd	s4,16(sp)
    8000417c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000417e:	04451703          	lh	a4,68(a0)
    80004182:	4785                	li	a5,1
    80004184:	00f71a63          	bne	a4,a5,80004198 <dirlookup+0x2a>
    80004188:	892a                	mv	s2,a0
    8000418a:	89ae                	mv	s3,a1
    8000418c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000418e:	457c                	lw	a5,76(a0)
    80004190:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004192:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004194:	e79d                	bnez	a5,800041c2 <dirlookup+0x54>
    80004196:	a8a5                	j	8000420e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004198:	00004517          	auipc	a0,0x4
    8000419c:	42850513          	addi	a0,a0,1064 # 800085c0 <etext+0x5c0>
    800041a0:	ffffc097          	auipc	ra,0xffffc
    800041a4:	3c0080e7          	jalr	960(ra) # 80000560 <panic>
      panic("dirlookup read");
    800041a8:	00004517          	auipc	a0,0x4
    800041ac:	43050513          	addi	a0,a0,1072 # 800085d8 <etext+0x5d8>
    800041b0:	ffffc097          	auipc	ra,0xffffc
    800041b4:	3b0080e7          	jalr	944(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041b8:	24c1                	addiw	s1,s1,16
    800041ba:	04c92783          	lw	a5,76(s2)
    800041be:	04f4f763          	bgeu	s1,a5,8000420c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041c2:	4741                	li	a4,16
    800041c4:	86a6                	mv	a3,s1
    800041c6:	fc040613          	addi	a2,s0,-64
    800041ca:	4581                	li	a1,0
    800041cc:	854a                	mv	a0,s2
    800041ce:	00000097          	auipc	ra,0x0
    800041d2:	d4c080e7          	jalr	-692(ra) # 80003f1a <readi>
    800041d6:	47c1                	li	a5,16
    800041d8:	fcf518e3          	bne	a0,a5,800041a8 <dirlookup+0x3a>
    if(de.inum == 0)
    800041dc:	fc045783          	lhu	a5,-64(s0)
    800041e0:	dfe1                	beqz	a5,800041b8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800041e2:	fc240593          	addi	a1,s0,-62
    800041e6:	854e                	mv	a0,s3
    800041e8:	00000097          	auipc	ra,0x0
    800041ec:	f6c080e7          	jalr	-148(ra) # 80004154 <namecmp>
    800041f0:	f561                	bnez	a0,800041b8 <dirlookup+0x4a>
      if(poff)
    800041f2:	000a0463          	beqz	s4,800041fa <dirlookup+0x8c>
        *poff = off;
    800041f6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041fa:	fc045583          	lhu	a1,-64(s0)
    800041fe:	00092503          	lw	a0,0(s2)
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	720080e7          	jalr	1824(ra) # 80003922 <iget>
    8000420a:	a011                	j	8000420e <dirlookup+0xa0>
  return 0;
    8000420c:	4501                	li	a0,0
}
    8000420e:	70e2                	ld	ra,56(sp)
    80004210:	7442                	ld	s0,48(sp)
    80004212:	74a2                	ld	s1,40(sp)
    80004214:	7902                	ld	s2,32(sp)
    80004216:	69e2                	ld	s3,24(sp)
    80004218:	6a42                	ld	s4,16(sp)
    8000421a:	6121                	addi	sp,sp,64
    8000421c:	8082                	ret

000000008000421e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000421e:	711d                	addi	sp,sp,-96
    80004220:	ec86                	sd	ra,88(sp)
    80004222:	e8a2                	sd	s0,80(sp)
    80004224:	e4a6                	sd	s1,72(sp)
    80004226:	e0ca                	sd	s2,64(sp)
    80004228:	fc4e                	sd	s3,56(sp)
    8000422a:	f852                	sd	s4,48(sp)
    8000422c:	f456                	sd	s5,40(sp)
    8000422e:	f05a                	sd	s6,32(sp)
    80004230:	ec5e                	sd	s7,24(sp)
    80004232:	e862                	sd	s8,16(sp)
    80004234:	e466                	sd	s9,8(sp)
    80004236:	1080                	addi	s0,sp,96
    80004238:	84aa                	mv	s1,a0
    8000423a:	8b2e                	mv	s6,a1
    8000423c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000423e:	00054703          	lbu	a4,0(a0)
    80004242:	02f00793          	li	a5,47
    80004246:	02f70263          	beq	a4,a5,8000426a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000424a:	ffffe097          	auipc	ra,0xffffe
    8000424e:	a4a080e7          	jalr	-1462(ra) # 80001c94 <myproc>
    80004252:	15053503          	ld	a0,336(a0)
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	9ce080e7          	jalr	-1586(ra) # 80003c24 <idup>
    8000425e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004260:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004264:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004266:	4b85                	li	s7,1
    80004268:	a875                	j	80004324 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000426a:	4585                	li	a1,1
    8000426c:	4505                	li	a0,1
    8000426e:	fffff097          	auipc	ra,0xfffff
    80004272:	6b4080e7          	jalr	1716(ra) # 80003922 <iget>
    80004276:	8a2a                	mv	s4,a0
    80004278:	b7e5                	j	80004260 <namex+0x42>
      iunlockput(ip);
    8000427a:	8552                	mv	a0,s4
    8000427c:	00000097          	auipc	ra,0x0
    80004280:	c4c080e7          	jalr	-948(ra) # 80003ec8 <iunlockput>
      return 0;
    80004284:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004286:	8552                	mv	a0,s4
    80004288:	60e6                	ld	ra,88(sp)
    8000428a:	6446                	ld	s0,80(sp)
    8000428c:	64a6                	ld	s1,72(sp)
    8000428e:	6906                	ld	s2,64(sp)
    80004290:	79e2                	ld	s3,56(sp)
    80004292:	7a42                	ld	s4,48(sp)
    80004294:	7aa2                	ld	s5,40(sp)
    80004296:	7b02                	ld	s6,32(sp)
    80004298:	6be2                	ld	s7,24(sp)
    8000429a:	6c42                	ld	s8,16(sp)
    8000429c:	6ca2                	ld	s9,8(sp)
    8000429e:	6125                	addi	sp,sp,96
    800042a0:	8082                	ret
      iunlock(ip);
    800042a2:	8552                	mv	a0,s4
    800042a4:	00000097          	auipc	ra,0x0
    800042a8:	a84080e7          	jalr	-1404(ra) # 80003d28 <iunlock>
      return ip;
    800042ac:	bfe9                	j	80004286 <namex+0x68>
      iunlockput(ip);
    800042ae:	8552                	mv	a0,s4
    800042b0:	00000097          	auipc	ra,0x0
    800042b4:	c18080e7          	jalr	-1000(ra) # 80003ec8 <iunlockput>
      return 0;
    800042b8:	8a4e                	mv	s4,s3
    800042ba:	b7f1                	j	80004286 <namex+0x68>
  len = path - s;
    800042bc:	40998633          	sub	a2,s3,s1
    800042c0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800042c4:	099c5863          	bge	s8,s9,80004354 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800042c8:	4639                	li	a2,14
    800042ca:	85a6                	mv	a1,s1
    800042cc:	8556                	mv	a0,s5
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	ac2080e7          	jalr	-1342(ra) # 80000d90 <memmove>
    800042d6:	84ce                	mv	s1,s3
  while(*path == '/')
    800042d8:	0004c783          	lbu	a5,0(s1)
    800042dc:	01279763          	bne	a5,s2,800042ea <namex+0xcc>
    path++;
    800042e0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042e2:	0004c783          	lbu	a5,0(s1)
    800042e6:	ff278de3          	beq	a5,s2,800042e0 <namex+0xc2>
    ilock(ip);
    800042ea:	8552                	mv	a0,s4
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	976080e7          	jalr	-1674(ra) # 80003c62 <ilock>
    if(ip->type != T_DIR){
    800042f4:	044a1783          	lh	a5,68(s4)
    800042f8:	f97791e3          	bne	a5,s7,8000427a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800042fc:	000b0563          	beqz	s6,80004306 <namex+0xe8>
    80004300:	0004c783          	lbu	a5,0(s1)
    80004304:	dfd9                	beqz	a5,800042a2 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004306:	4601                	li	a2,0
    80004308:	85d6                	mv	a1,s5
    8000430a:	8552                	mv	a0,s4
    8000430c:	00000097          	auipc	ra,0x0
    80004310:	e62080e7          	jalr	-414(ra) # 8000416e <dirlookup>
    80004314:	89aa                	mv	s3,a0
    80004316:	dd41                	beqz	a0,800042ae <namex+0x90>
    iunlockput(ip);
    80004318:	8552                	mv	a0,s4
    8000431a:	00000097          	auipc	ra,0x0
    8000431e:	bae080e7          	jalr	-1106(ra) # 80003ec8 <iunlockput>
    ip = next;
    80004322:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004324:	0004c783          	lbu	a5,0(s1)
    80004328:	01279763          	bne	a5,s2,80004336 <namex+0x118>
    path++;
    8000432c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000432e:	0004c783          	lbu	a5,0(s1)
    80004332:	ff278de3          	beq	a5,s2,8000432c <namex+0x10e>
  if(*path == 0)
    80004336:	cb9d                	beqz	a5,8000436c <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004338:	0004c783          	lbu	a5,0(s1)
    8000433c:	89a6                	mv	s3,s1
  len = path - s;
    8000433e:	4c81                	li	s9,0
    80004340:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004342:	01278963          	beq	a5,s2,80004354 <namex+0x136>
    80004346:	dbbd                	beqz	a5,800042bc <namex+0x9e>
    path++;
    80004348:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000434a:	0009c783          	lbu	a5,0(s3)
    8000434e:	ff279ce3          	bne	a5,s2,80004346 <namex+0x128>
    80004352:	b7ad                	j	800042bc <namex+0x9e>
    memmove(name, s, len);
    80004354:	2601                	sext.w	a2,a2
    80004356:	85a6                	mv	a1,s1
    80004358:	8556                	mv	a0,s5
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	a36080e7          	jalr	-1482(ra) # 80000d90 <memmove>
    name[len] = 0;
    80004362:	9cd6                	add	s9,s9,s5
    80004364:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004368:	84ce                	mv	s1,s3
    8000436a:	b7bd                	j	800042d8 <namex+0xba>
  if(nameiparent){
    8000436c:	f00b0de3          	beqz	s6,80004286 <namex+0x68>
    iput(ip);
    80004370:	8552                	mv	a0,s4
    80004372:	00000097          	auipc	ra,0x0
    80004376:	aae080e7          	jalr	-1362(ra) # 80003e20 <iput>
    return 0;
    8000437a:	4a01                	li	s4,0
    8000437c:	b729                	j	80004286 <namex+0x68>

000000008000437e <dirlink>:
{
    8000437e:	7139                	addi	sp,sp,-64
    80004380:	fc06                	sd	ra,56(sp)
    80004382:	f822                	sd	s0,48(sp)
    80004384:	f04a                	sd	s2,32(sp)
    80004386:	ec4e                	sd	s3,24(sp)
    80004388:	e852                	sd	s4,16(sp)
    8000438a:	0080                	addi	s0,sp,64
    8000438c:	892a                	mv	s2,a0
    8000438e:	8a2e                	mv	s4,a1
    80004390:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004392:	4601                	li	a2,0
    80004394:	00000097          	auipc	ra,0x0
    80004398:	dda080e7          	jalr	-550(ra) # 8000416e <dirlookup>
    8000439c:	ed25                	bnez	a0,80004414 <dirlink+0x96>
    8000439e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043a0:	04c92483          	lw	s1,76(s2)
    800043a4:	c49d                	beqz	s1,800043d2 <dirlink+0x54>
    800043a6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043a8:	4741                	li	a4,16
    800043aa:	86a6                	mv	a3,s1
    800043ac:	fc040613          	addi	a2,s0,-64
    800043b0:	4581                	li	a1,0
    800043b2:	854a                	mv	a0,s2
    800043b4:	00000097          	auipc	ra,0x0
    800043b8:	b66080e7          	jalr	-1178(ra) # 80003f1a <readi>
    800043bc:	47c1                	li	a5,16
    800043be:	06f51163          	bne	a0,a5,80004420 <dirlink+0xa2>
    if(de.inum == 0)
    800043c2:	fc045783          	lhu	a5,-64(s0)
    800043c6:	c791                	beqz	a5,800043d2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043c8:	24c1                	addiw	s1,s1,16
    800043ca:	04c92783          	lw	a5,76(s2)
    800043ce:	fcf4ede3          	bltu	s1,a5,800043a8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800043d2:	4639                	li	a2,14
    800043d4:	85d2                	mv	a1,s4
    800043d6:	fc240513          	addi	a0,s0,-62
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	a60080e7          	jalr	-1440(ra) # 80000e3a <strncpy>
  de.inum = inum;
    800043e2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043e6:	4741                	li	a4,16
    800043e8:	86a6                	mv	a3,s1
    800043ea:	fc040613          	addi	a2,s0,-64
    800043ee:	4581                	li	a1,0
    800043f0:	854a                	mv	a0,s2
    800043f2:	00000097          	auipc	ra,0x0
    800043f6:	c38080e7          	jalr	-968(ra) # 8000402a <writei>
    800043fa:	1541                	addi	a0,a0,-16
    800043fc:	00a03533          	snez	a0,a0
    80004400:	40a00533          	neg	a0,a0
    80004404:	74a2                	ld	s1,40(sp)
}
    80004406:	70e2                	ld	ra,56(sp)
    80004408:	7442                	ld	s0,48(sp)
    8000440a:	7902                	ld	s2,32(sp)
    8000440c:	69e2                	ld	s3,24(sp)
    8000440e:	6a42                	ld	s4,16(sp)
    80004410:	6121                	addi	sp,sp,64
    80004412:	8082                	ret
    iput(ip);
    80004414:	00000097          	auipc	ra,0x0
    80004418:	a0c080e7          	jalr	-1524(ra) # 80003e20 <iput>
    return -1;
    8000441c:	557d                	li	a0,-1
    8000441e:	b7e5                	j	80004406 <dirlink+0x88>
      panic("dirlink read");
    80004420:	00004517          	auipc	a0,0x4
    80004424:	1c850513          	addi	a0,a0,456 # 800085e8 <etext+0x5e8>
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	138080e7          	jalr	312(ra) # 80000560 <panic>

0000000080004430 <namei>:

struct inode*
namei(char *path)
{
    80004430:	1101                	addi	sp,sp,-32
    80004432:	ec06                	sd	ra,24(sp)
    80004434:	e822                	sd	s0,16(sp)
    80004436:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004438:	fe040613          	addi	a2,s0,-32
    8000443c:	4581                	li	a1,0
    8000443e:	00000097          	auipc	ra,0x0
    80004442:	de0080e7          	jalr	-544(ra) # 8000421e <namex>
}
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	6105                	addi	sp,sp,32
    8000444c:	8082                	ret

000000008000444e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000444e:	1141                	addi	sp,sp,-16
    80004450:	e406                	sd	ra,8(sp)
    80004452:	e022                	sd	s0,0(sp)
    80004454:	0800                	addi	s0,sp,16
    80004456:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004458:	4585                	li	a1,1
    8000445a:	00000097          	auipc	ra,0x0
    8000445e:	dc4080e7          	jalr	-572(ra) # 8000421e <namex>
}
    80004462:	60a2                	ld	ra,8(sp)
    80004464:	6402                	ld	s0,0(sp)
    80004466:	0141                	addi	sp,sp,16
    80004468:	8082                	ret

000000008000446a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000446a:	1101                	addi	sp,sp,-32
    8000446c:	ec06                	sd	ra,24(sp)
    8000446e:	e822                	sd	s0,16(sp)
    80004470:	e426                	sd	s1,8(sp)
    80004472:	e04a                	sd	s2,0(sp)
    80004474:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004476:	0001f917          	auipc	s2,0x1f
    8000447a:	48a90913          	addi	s2,s2,1162 # 80023900 <log>
    8000447e:	01892583          	lw	a1,24(s2)
    80004482:	02892503          	lw	a0,40(s2)
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	fa8080e7          	jalr	-88(ra) # 8000342e <bread>
    8000448e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004490:	02c92603          	lw	a2,44(s2)
    80004494:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004496:	00c05f63          	blez	a2,800044b4 <write_head+0x4a>
    8000449a:	0001f717          	auipc	a4,0x1f
    8000449e:	49670713          	addi	a4,a4,1174 # 80023930 <log+0x30>
    800044a2:	87aa                	mv	a5,a0
    800044a4:	060a                	slli	a2,a2,0x2
    800044a6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800044a8:	4314                	lw	a3,0(a4)
    800044aa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800044ac:	0711                	addi	a4,a4,4
    800044ae:	0791                	addi	a5,a5,4
    800044b0:	fec79ce3          	bne	a5,a2,800044a8 <write_head+0x3e>
  }
  bwrite(buf);
    800044b4:	8526                	mv	a0,s1
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	06a080e7          	jalr	106(ra) # 80003520 <bwrite>
  brelse(buf);
    800044be:	8526                	mv	a0,s1
    800044c0:	fffff097          	auipc	ra,0xfffff
    800044c4:	09e080e7          	jalr	158(ra) # 8000355e <brelse>
}
    800044c8:	60e2                	ld	ra,24(sp)
    800044ca:	6442                	ld	s0,16(sp)
    800044cc:	64a2                	ld	s1,8(sp)
    800044ce:	6902                	ld	s2,0(sp)
    800044d0:	6105                	addi	sp,sp,32
    800044d2:	8082                	ret

00000000800044d4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044d4:	0001f797          	auipc	a5,0x1f
    800044d8:	4587a783          	lw	a5,1112(a5) # 8002392c <log+0x2c>
    800044dc:	0af05d63          	blez	a5,80004596 <install_trans+0xc2>
{
    800044e0:	7139                	addi	sp,sp,-64
    800044e2:	fc06                	sd	ra,56(sp)
    800044e4:	f822                	sd	s0,48(sp)
    800044e6:	f426                	sd	s1,40(sp)
    800044e8:	f04a                	sd	s2,32(sp)
    800044ea:	ec4e                	sd	s3,24(sp)
    800044ec:	e852                	sd	s4,16(sp)
    800044ee:	e456                	sd	s5,8(sp)
    800044f0:	e05a                	sd	s6,0(sp)
    800044f2:	0080                	addi	s0,sp,64
    800044f4:	8b2a                	mv	s6,a0
    800044f6:	0001fa97          	auipc	s5,0x1f
    800044fa:	43aa8a93          	addi	s5,s5,1082 # 80023930 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044fe:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004500:	0001f997          	auipc	s3,0x1f
    80004504:	40098993          	addi	s3,s3,1024 # 80023900 <log>
    80004508:	a00d                	j	8000452a <install_trans+0x56>
    brelse(lbuf);
    8000450a:	854a                	mv	a0,s2
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	052080e7          	jalr	82(ra) # 8000355e <brelse>
    brelse(dbuf);
    80004514:	8526                	mv	a0,s1
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	048080e7          	jalr	72(ra) # 8000355e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000451e:	2a05                	addiw	s4,s4,1
    80004520:	0a91                	addi	s5,s5,4
    80004522:	02c9a783          	lw	a5,44(s3)
    80004526:	04fa5e63          	bge	s4,a5,80004582 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000452a:	0189a583          	lw	a1,24(s3)
    8000452e:	014585bb          	addw	a1,a1,s4
    80004532:	2585                	addiw	a1,a1,1
    80004534:	0289a503          	lw	a0,40(s3)
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	ef6080e7          	jalr	-266(ra) # 8000342e <bread>
    80004540:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004542:	000aa583          	lw	a1,0(s5)
    80004546:	0289a503          	lw	a0,40(s3)
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	ee4080e7          	jalr	-284(ra) # 8000342e <bread>
    80004552:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004554:	40000613          	li	a2,1024
    80004558:	05890593          	addi	a1,s2,88
    8000455c:	05850513          	addi	a0,a0,88
    80004560:	ffffd097          	auipc	ra,0xffffd
    80004564:	830080e7          	jalr	-2000(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004568:	8526                	mv	a0,s1
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	fb6080e7          	jalr	-74(ra) # 80003520 <bwrite>
    if(recovering == 0)
    80004572:	f80b1ce3          	bnez	s6,8000450a <install_trans+0x36>
      bunpin(dbuf);
    80004576:	8526                	mv	a0,s1
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	0be080e7          	jalr	190(ra) # 80003636 <bunpin>
    80004580:	b769                	j	8000450a <install_trans+0x36>
}
    80004582:	70e2                	ld	ra,56(sp)
    80004584:	7442                	ld	s0,48(sp)
    80004586:	74a2                	ld	s1,40(sp)
    80004588:	7902                	ld	s2,32(sp)
    8000458a:	69e2                	ld	s3,24(sp)
    8000458c:	6a42                	ld	s4,16(sp)
    8000458e:	6aa2                	ld	s5,8(sp)
    80004590:	6b02                	ld	s6,0(sp)
    80004592:	6121                	addi	sp,sp,64
    80004594:	8082                	ret
    80004596:	8082                	ret

0000000080004598 <initlog>:
{
    80004598:	7179                	addi	sp,sp,-48
    8000459a:	f406                	sd	ra,40(sp)
    8000459c:	f022                	sd	s0,32(sp)
    8000459e:	ec26                	sd	s1,24(sp)
    800045a0:	e84a                	sd	s2,16(sp)
    800045a2:	e44e                	sd	s3,8(sp)
    800045a4:	1800                	addi	s0,sp,48
    800045a6:	892a                	mv	s2,a0
    800045a8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800045aa:	0001f497          	auipc	s1,0x1f
    800045ae:	35648493          	addi	s1,s1,854 # 80023900 <log>
    800045b2:	00004597          	auipc	a1,0x4
    800045b6:	04658593          	addi	a1,a1,70 # 800085f8 <etext+0x5f8>
    800045ba:	8526                	mv	a0,s1
    800045bc:	ffffc097          	auipc	ra,0xffffc
    800045c0:	5ec080e7          	jalr	1516(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    800045c4:	0149a583          	lw	a1,20(s3)
    800045c8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800045ca:	0109a783          	lw	a5,16(s3)
    800045ce:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045d0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045d4:	854a                	mv	a0,s2
    800045d6:	fffff097          	auipc	ra,0xfffff
    800045da:	e58080e7          	jalr	-424(ra) # 8000342e <bread>
  log.lh.n = lh->n;
    800045de:	4d30                	lw	a2,88(a0)
    800045e0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800045e2:	00c05f63          	blez	a2,80004600 <initlog+0x68>
    800045e6:	87aa                	mv	a5,a0
    800045e8:	0001f717          	auipc	a4,0x1f
    800045ec:	34870713          	addi	a4,a4,840 # 80023930 <log+0x30>
    800045f0:	060a                	slli	a2,a2,0x2
    800045f2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800045f4:	4ff4                	lw	a3,92(a5)
    800045f6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045f8:	0791                	addi	a5,a5,4
    800045fa:	0711                	addi	a4,a4,4
    800045fc:	fec79ce3          	bne	a5,a2,800045f4 <initlog+0x5c>
  brelse(buf);
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	f5e080e7          	jalr	-162(ra) # 8000355e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004608:	4505                	li	a0,1
    8000460a:	00000097          	auipc	ra,0x0
    8000460e:	eca080e7          	jalr	-310(ra) # 800044d4 <install_trans>
  log.lh.n = 0;
    80004612:	0001f797          	auipc	a5,0x1f
    80004616:	3007ad23          	sw	zero,794(a5) # 8002392c <log+0x2c>
  write_head(); // clear the log
    8000461a:	00000097          	auipc	ra,0x0
    8000461e:	e50080e7          	jalr	-432(ra) # 8000446a <write_head>
}
    80004622:	70a2                	ld	ra,40(sp)
    80004624:	7402                	ld	s0,32(sp)
    80004626:	64e2                	ld	s1,24(sp)
    80004628:	6942                	ld	s2,16(sp)
    8000462a:	69a2                	ld	s3,8(sp)
    8000462c:	6145                	addi	sp,sp,48
    8000462e:	8082                	ret

0000000080004630 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004630:	1101                	addi	sp,sp,-32
    80004632:	ec06                	sd	ra,24(sp)
    80004634:	e822                	sd	s0,16(sp)
    80004636:	e426                	sd	s1,8(sp)
    80004638:	e04a                	sd	s2,0(sp)
    8000463a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000463c:	0001f517          	auipc	a0,0x1f
    80004640:	2c450513          	addi	a0,a0,708 # 80023900 <log>
    80004644:	ffffc097          	auipc	ra,0xffffc
    80004648:	5f4080e7          	jalr	1524(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    8000464c:	0001f497          	auipc	s1,0x1f
    80004650:	2b448493          	addi	s1,s1,692 # 80023900 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004654:	4979                	li	s2,30
    80004656:	a039                	j	80004664 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004658:	85a6                	mv	a1,s1
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	e10080e7          	jalr	-496(ra) # 8000246c <sleep>
    if(log.committing){
    80004664:	50dc                	lw	a5,36(s1)
    80004666:	fbed                	bnez	a5,80004658 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004668:	5098                	lw	a4,32(s1)
    8000466a:	2705                	addiw	a4,a4,1
    8000466c:	0027179b          	slliw	a5,a4,0x2
    80004670:	9fb9                	addw	a5,a5,a4
    80004672:	0017979b          	slliw	a5,a5,0x1
    80004676:	54d4                	lw	a3,44(s1)
    80004678:	9fb5                	addw	a5,a5,a3
    8000467a:	00f95963          	bge	s2,a5,8000468c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000467e:	85a6                	mv	a1,s1
    80004680:	8526                	mv	a0,s1
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	dea080e7          	jalr	-534(ra) # 8000246c <sleep>
    8000468a:	bfe9                	j	80004664 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000468c:	0001f517          	auipc	a0,0x1f
    80004690:	27450513          	addi	a0,a0,628 # 80023900 <log>
    80004694:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004696:	ffffc097          	auipc	ra,0xffffc
    8000469a:	656080e7          	jalr	1622(ra) # 80000cec <release>
      break;
    }
  }
}
    8000469e:	60e2                	ld	ra,24(sp)
    800046a0:	6442                	ld	s0,16(sp)
    800046a2:	64a2                	ld	s1,8(sp)
    800046a4:	6902                	ld	s2,0(sp)
    800046a6:	6105                	addi	sp,sp,32
    800046a8:	8082                	ret

00000000800046aa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800046aa:	7139                	addi	sp,sp,-64
    800046ac:	fc06                	sd	ra,56(sp)
    800046ae:	f822                	sd	s0,48(sp)
    800046b0:	f426                	sd	s1,40(sp)
    800046b2:	f04a                	sd	s2,32(sp)
    800046b4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800046b6:	0001f497          	auipc	s1,0x1f
    800046ba:	24a48493          	addi	s1,s1,586 # 80023900 <log>
    800046be:	8526                	mv	a0,s1
    800046c0:	ffffc097          	auipc	ra,0xffffc
    800046c4:	578080e7          	jalr	1400(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    800046c8:	509c                	lw	a5,32(s1)
    800046ca:	37fd                	addiw	a5,a5,-1
    800046cc:	0007891b          	sext.w	s2,a5
    800046d0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800046d2:	50dc                	lw	a5,36(s1)
    800046d4:	e7b9                	bnez	a5,80004722 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800046d6:	06091163          	bnez	s2,80004738 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800046da:	0001f497          	auipc	s1,0x1f
    800046de:	22648493          	addi	s1,s1,550 # 80023900 <log>
    800046e2:	4785                	li	a5,1
    800046e4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffc097          	auipc	ra,0xffffc
    800046ec:	604080e7          	jalr	1540(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800046f0:	54dc                	lw	a5,44(s1)
    800046f2:	06f04763          	bgtz	a5,80004760 <end_op+0xb6>
    acquire(&log.lock);
    800046f6:	0001f497          	auipc	s1,0x1f
    800046fa:	20a48493          	addi	s1,s1,522 # 80023900 <log>
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffc097          	auipc	ra,0xffffc
    80004704:	538080e7          	jalr	1336(ra) # 80000c38 <acquire>
    log.committing = 0;
    80004708:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000470c:	8526                	mv	a0,s1
    8000470e:	ffffe097          	auipc	ra,0xffffe
    80004712:	dc2080e7          	jalr	-574(ra) # 800024d0 <wakeup>
    release(&log.lock);
    80004716:	8526                	mv	a0,s1
    80004718:	ffffc097          	auipc	ra,0xffffc
    8000471c:	5d4080e7          	jalr	1492(ra) # 80000cec <release>
}
    80004720:	a815                	j	80004754 <end_op+0xaa>
    80004722:	ec4e                	sd	s3,24(sp)
    80004724:	e852                	sd	s4,16(sp)
    80004726:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004728:	00004517          	auipc	a0,0x4
    8000472c:	ed850513          	addi	a0,a0,-296 # 80008600 <etext+0x600>
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	e30080e7          	jalr	-464(ra) # 80000560 <panic>
    wakeup(&log);
    80004738:	0001f497          	auipc	s1,0x1f
    8000473c:	1c848493          	addi	s1,s1,456 # 80023900 <log>
    80004740:	8526                	mv	a0,s1
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	d8e080e7          	jalr	-626(ra) # 800024d0 <wakeup>
  release(&log.lock);
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	5a0080e7          	jalr	1440(ra) # 80000cec <release>
}
    80004754:	70e2                	ld	ra,56(sp)
    80004756:	7442                	ld	s0,48(sp)
    80004758:	74a2                	ld	s1,40(sp)
    8000475a:	7902                	ld	s2,32(sp)
    8000475c:	6121                	addi	sp,sp,64
    8000475e:	8082                	ret
    80004760:	ec4e                	sd	s3,24(sp)
    80004762:	e852                	sd	s4,16(sp)
    80004764:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004766:	0001fa97          	auipc	s5,0x1f
    8000476a:	1caa8a93          	addi	s5,s5,458 # 80023930 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000476e:	0001fa17          	auipc	s4,0x1f
    80004772:	192a0a13          	addi	s4,s4,402 # 80023900 <log>
    80004776:	018a2583          	lw	a1,24(s4)
    8000477a:	012585bb          	addw	a1,a1,s2
    8000477e:	2585                	addiw	a1,a1,1
    80004780:	028a2503          	lw	a0,40(s4)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	caa080e7          	jalr	-854(ra) # 8000342e <bread>
    8000478c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000478e:	000aa583          	lw	a1,0(s5)
    80004792:	028a2503          	lw	a0,40(s4)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	c98080e7          	jalr	-872(ra) # 8000342e <bread>
    8000479e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800047a0:	40000613          	li	a2,1024
    800047a4:	05850593          	addi	a1,a0,88
    800047a8:	05848513          	addi	a0,s1,88
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	5e4080e7          	jalr	1508(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    800047b4:	8526                	mv	a0,s1
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	d6a080e7          	jalr	-662(ra) # 80003520 <bwrite>
    brelse(from);
    800047be:	854e                	mv	a0,s3
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	d9e080e7          	jalr	-610(ra) # 8000355e <brelse>
    brelse(to);
    800047c8:	8526                	mv	a0,s1
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	d94080e7          	jalr	-620(ra) # 8000355e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047d2:	2905                	addiw	s2,s2,1
    800047d4:	0a91                	addi	s5,s5,4
    800047d6:	02ca2783          	lw	a5,44(s4)
    800047da:	f8f94ee3          	blt	s2,a5,80004776 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800047de:	00000097          	auipc	ra,0x0
    800047e2:	c8c080e7          	jalr	-884(ra) # 8000446a <write_head>
    install_trans(0); // Now install writes to home locations
    800047e6:	4501                	li	a0,0
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	cec080e7          	jalr	-788(ra) # 800044d4 <install_trans>
    log.lh.n = 0;
    800047f0:	0001f797          	auipc	a5,0x1f
    800047f4:	1207ae23          	sw	zero,316(a5) # 8002392c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800047f8:	00000097          	auipc	ra,0x0
    800047fc:	c72080e7          	jalr	-910(ra) # 8000446a <write_head>
    80004800:	69e2                	ld	s3,24(sp)
    80004802:	6a42                	ld	s4,16(sp)
    80004804:	6aa2                	ld	s5,8(sp)
    80004806:	bdc5                	j	800046f6 <end_op+0x4c>

0000000080004808 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004808:	1101                	addi	sp,sp,-32
    8000480a:	ec06                	sd	ra,24(sp)
    8000480c:	e822                	sd	s0,16(sp)
    8000480e:	e426                	sd	s1,8(sp)
    80004810:	e04a                	sd	s2,0(sp)
    80004812:	1000                	addi	s0,sp,32
    80004814:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004816:	0001f917          	auipc	s2,0x1f
    8000481a:	0ea90913          	addi	s2,s2,234 # 80023900 <log>
    8000481e:	854a                	mv	a0,s2
    80004820:	ffffc097          	auipc	ra,0xffffc
    80004824:	418080e7          	jalr	1048(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004828:	02c92603          	lw	a2,44(s2)
    8000482c:	47f5                	li	a5,29
    8000482e:	06c7c563          	blt	a5,a2,80004898 <log_write+0x90>
    80004832:	0001f797          	auipc	a5,0x1f
    80004836:	0ea7a783          	lw	a5,234(a5) # 8002391c <log+0x1c>
    8000483a:	37fd                	addiw	a5,a5,-1
    8000483c:	04f65e63          	bge	a2,a5,80004898 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004840:	0001f797          	auipc	a5,0x1f
    80004844:	0e07a783          	lw	a5,224(a5) # 80023920 <log+0x20>
    80004848:	06f05063          	blez	a5,800048a8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000484c:	4781                	li	a5,0
    8000484e:	06c05563          	blez	a2,800048b8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004852:	44cc                	lw	a1,12(s1)
    80004854:	0001f717          	auipc	a4,0x1f
    80004858:	0dc70713          	addi	a4,a4,220 # 80023930 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000485c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000485e:	4314                	lw	a3,0(a4)
    80004860:	04b68c63          	beq	a3,a1,800048b8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004864:	2785                	addiw	a5,a5,1
    80004866:	0711                	addi	a4,a4,4
    80004868:	fef61be3          	bne	a2,a5,8000485e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000486c:	0621                	addi	a2,a2,8
    8000486e:	060a                	slli	a2,a2,0x2
    80004870:	0001f797          	auipc	a5,0x1f
    80004874:	09078793          	addi	a5,a5,144 # 80023900 <log>
    80004878:	97b2                	add	a5,a5,a2
    8000487a:	44d8                	lw	a4,12(s1)
    8000487c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000487e:	8526                	mv	a0,s1
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	d7a080e7          	jalr	-646(ra) # 800035fa <bpin>
    log.lh.n++;
    80004888:	0001f717          	auipc	a4,0x1f
    8000488c:	07870713          	addi	a4,a4,120 # 80023900 <log>
    80004890:	575c                	lw	a5,44(a4)
    80004892:	2785                	addiw	a5,a5,1
    80004894:	d75c                	sw	a5,44(a4)
    80004896:	a82d                	j	800048d0 <log_write+0xc8>
    panic("too big a transaction");
    80004898:	00004517          	auipc	a0,0x4
    8000489c:	d7850513          	addi	a0,a0,-648 # 80008610 <etext+0x610>
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	cc0080e7          	jalr	-832(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800048a8:	00004517          	auipc	a0,0x4
    800048ac:	d8050513          	addi	a0,a0,-640 # 80008628 <etext+0x628>
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	cb0080e7          	jalr	-848(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800048b8:	00878693          	addi	a3,a5,8
    800048bc:	068a                	slli	a3,a3,0x2
    800048be:	0001f717          	auipc	a4,0x1f
    800048c2:	04270713          	addi	a4,a4,66 # 80023900 <log>
    800048c6:	9736                	add	a4,a4,a3
    800048c8:	44d4                	lw	a3,12(s1)
    800048ca:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800048cc:	faf609e3          	beq	a2,a5,8000487e <log_write+0x76>
  }
  release(&log.lock);
    800048d0:	0001f517          	auipc	a0,0x1f
    800048d4:	03050513          	addi	a0,a0,48 # 80023900 <log>
    800048d8:	ffffc097          	auipc	ra,0xffffc
    800048dc:	414080e7          	jalr	1044(ra) # 80000cec <release>
}
    800048e0:	60e2                	ld	ra,24(sp)
    800048e2:	6442                	ld	s0,16(sp)
    800048e4:	64a2                	ld	s1,8(sp)
    800048e6:	6902                	ld	s2,0(sp)
    800048e8:	6105                	addi	sp,sp,32
    800048ea:	8082                	ret

00000000800048ec <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800048ec:	1101                	addi	sp,sp,-32
    800048ee:	ec06                	sd	ra,24(sp)
    800048f0:	e822                	sd	s0,16(sp)
    800048f2:	e426                	sd	s1,8(sp)
    800048f4:	e04a                	sd	s2,0(sp)
    800048f6:	1000                	addi	s0,sp,32
    800048f8:	84aa                	mv	s1,a0
    800048fa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048fc:	00004597          	auipc	a1,0x4
    80004900:	d4c58593          	addi	a1,a1,-692 # 80008648 <etext+0x648>
    80004904:	0521                	addi	a0,a0,8
    80004906:	ffffc097          	auipc	ra,0xffffc
    8000490a:	2a2080e7          	jalr	674(ra) # 80000ba8 <initlock>
  lk->name = name;
    8000490e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004912:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004916:	0204a423          	sw	zero,40(s1)
}
    8000491a:	60e2                	ld	ra,24(sp)
    8000491c:	6442                	ld	s0,16(sp)
    8000491e:	64a2                	ld	s1,8(sp)
    80004920:	6902                	ld	s2,0(sp)
    80004922:	6105                	addi	sp,sp,32
    80004924:	8082                	ret

0000000080004926 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004926:	1101                	addi	sp,sp,-32
    80004928:	ec06                	sd	ra,24(sp)
    8000492a:	e822                	sd	s0,16(sp)
    8000492c:	e426                	sd	s1,8(sp)
    8000492e:	e04a                	sd	s2,0(sp)
    80004930:	1000                	addi	s0,sp,32
    80004932:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004934:	00850913          	addi	s2,a0,8
    80004938:	854a                	mv	a0,s2
    8000493a:	ffffc097          	auipc	ra,0xffffc
    8000493e:	2fe080e7          	jalr	766(ra) # 80000c38 <acquire>
  while (lk->locked) {
    80004942:	409c                	lw	a5,0(s1)
    80004944:	cb89                	beqz	a5,80004956 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004946:	85ca                	mv	a1,s2
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	b22080e7          	jalr	-1246(ra) # 8000246c <sleep>
  while (lk->locked) {
    80004952:	409c                	lw	a5,0(s1)
    80004954:	fbed                	bnez	a5,80004946 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004956:	4785                	li	a5,1
    80004958:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000495a:	ffffd097          	auipc	ra,0xffffd
    8000495e:	33a080e7          	jalr	826(ra) # 80001c94 <myproc>
    80004962:	591c                	lw	a5,48(a0)
    80004964:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004966:	854a                	mv	a0,s2
    80004968:	ffffc097          	auipc	ra,0xffffc
    8000496c:	384080e7          	jalr	900(ra) # 80000cec <release>
}
    80004970:	60e2                	ld	ra,24(sp)
    80004972:	6442                	ld	s0,16(sp)
    80004974:	64a2                	ld	s1,8(sp)
    80004976:	6902                	ld	s2,0(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	e426                	sd	s1,8(sp)
    80004984:	e04a                	sd	s2,0(sp)
    80004986:	1000                	addi	s0,sp,32
    80004988:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000498a:	00850913          	addi	s2,a0,8
    8000498e:	854a                	mv	a0,s2
    80004990:	ffffc097          	auipc	ra,0xffffc
    80004994:	2a8080e7          	jalr	680(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004998:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000499c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	b2e080e7          	jalr	-1234(ra) # 800024d0 <wakeup>
  release(&lk->lk);
    800049aa:	854a                	mv	a0,s2
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	340080e7          	jalr	832(ra) # 80000cec <release>
}
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	64a2                	ld	s1,8(sp)
    800049ba:	6902                	ld	s2,0(sp)
    800049bc:	6105                	addi	sp,sp,32
    800049be:	8082                	ret

00000000800049c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800049c0:	7179                	addi	sp,sp,-48
    800049c2:	f406                	sd	ra,40(sp)
    800049c4:	f022                	sd	s0,32(sp)
    800049c6:	ec26                	sd	s1,24(sp)
    800049c8:	e84a                	sd	s2,16(sp)
    800049ca:	1800                	addi	s0,sp,48
    800049cc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800049ce:	00850913          	addi	s2,a0,8
    800049d2:	854a                	mv	a0,s2
    800049d4:	ffffc097          	auipc	ra,0xffffc
    800049d8:	264080e7          	jalr	612(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800049dc:	409c                	lw	a5,0(s1)
    800049de:	ef91                	bnez	a5,800049fa <holdingsleep+0x3a>
    800049e0:	4481                	li	s1,0
  release(&lk->lk);
    800049e2:	854a                	mv	a0,s2
    800049e4:	ffffc097          	auipc	ra,0xffffc
    800049e8:	308080e7          	jalr	776(ra) # 80000cec <release>
  return r;
}
    800049ec:	8526                	mv	a0,s1
    800049ee:	70a2                	ld	ra,40(sp)
    800049f0:	7402                	ld	s0,32(sp)
    800049f2:	64e2                	ld	s1,24(sp)
    800049f4:	6942                	ld	s2,16(sp)
    800049f6:	6145                	addi	sp,sp,48
    800049f8:	8082                	ret
    800049fa:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800049fc:	0284a983          	lw	s3,40(s1)
    80004a00:	ffffd097          	auipc	ra,0xffffd
    80004a04:	294080e7          	jalr	660(ra) # 80001c94 <myproc>
    80004a08:	5904                	lw	s1,48(a0)
    80004a0a:	413484b3          	sub	s1,s1,s3
    80004a0e:	0014b493          	seqz	s1,s1
    80004a12:	69a2                	ld	s3,8(sp)
    80004a14:	b7f9                	j	800049e2 <holdingsleep+0x22>

0000000080004a16 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a16:	1141                	addi	sp,sp,-16
    80004a18:	e406                	sd	ra,8(sp)
    80004a1a:	e022                	sd	s0,0(sp)
    80004a1c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a1e:	00004597          	auipc	a1,0x4
    80004a22:	c3a58593          	addi	a1,a1,-966 # 80008658 <etext+0x658>
    80004a26:	0001f517          	auipc	a0,0x1f
    80004a2a:	02250513          	addi	a0,a0,34 # 80023a48 <ftable>
    80004a2e:	ffffc097          	auipc	ra,0xffffc
    80004a32:	17a080e7          	jalr	378(ra) # 80000ba8 <initlock>
}
    80004a36:	60a2                	ld	ra,8(sp)
    80004a38:	6402                	ld	s0,0(sp)
    80004a3a:	0141                	addi	sp,sp,16
    80004a3c:	8082                	ret

0000000080004a3e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a3e:	1101                	addi	sp,sp,-32
    80004a40:	ec06                	sd	ra,24(sp)
    80004a42:	e822                	sd	s0,16(sp)
    80004a44:	e426                	sd	s1,8(sp)
    80004a46:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a48:	0001f517          	auipc	a0,0x1f
    80004a4c:	00050513          	mv	a0,a0
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	1e8080e7          	jalr	488(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a58:	0001f497          	auipc	s1,0x1f
    80004a5c:	00848493          	addi	s1,s1,8 # 80023a60 <ftable+0x18>
    80004a60:	00020717          	auipc	a4,0x20
    80004a64:	fa070713          	addi	a4,a4,-96 # 80024a00 <disk>
    if(f->ref == 0){
    80004a68:	40dc                	lw	a5,4(s1)
    80004a6a:	cf99                	beqz	a5,80004a88 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a6c:	02848493          	addi	s1,s1,40
    80004a70:	fee49ce3          	bne	s1,a4,80004a68 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a74:	0001f517          	auipc	a0,0x1f
    80004a78:	fd450513          	addi	a0,a0,-44 # 80023a48 <ftable>
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	270080e7          	jalr	624(ra) # 80000cec <release>
  return 0;
    80004a84:	4481                	li	s1,0
    80004a86:	a819                	j	80004a9c <filealloc+0x5e>
      f->ref = 1;
    80004a88:	4785                	li	a5,1
    80004a8a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a8c:	0001f517          	auipc	a0,0x1f
    80004a90:	fbc50513          	addi	a0,a0,-68 # 80023a48 <ftable>
    80004a94:	ffffc097          	auipc	ra,0xffffc
    80004a98:	258080e7          	jalr	600(ra) # 80000cec <release>
}
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	60e2                	ld	ra,24(sp)
    80004aa0:	6442                	ld	s0,16(sp)
    80004aa2:	64a2                	ld	s1,8(sp)
    80004aa4:	6105                	addi	sp,sp,32
    80004aa6:	8082                	ret

0000000080004aa8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004aa8:	1101                	addi	sp,sp,-32
    80004aaa:	ec06                	sd	ra,24(sp)
    80004aac:	e822                	sd	s0,16(sp)
    80004aae:	e426                	sd	s1,8(sp)
    80004ab0:	1000                	addi	s0,sp,32
    80004ab2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004ab4:	0001f517          	auipc	a0,0x1f
    80004ab8:	f9450513          	addi	a0,a0,-108 # 80023a48 <ftable>
    80004abc:	ffffc097          	auipc	ra,0xffffc
    80004ac0:	17c080e7          	jalr	380(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004ac4:	40dc                	lw	a5,4(s1)
    80004ac6:	02f05263          	blez	a5,80004aea <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004aca:	2785                	addiw	a5,a5,1
    80004acc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ace:	0001f517          	auipc	a0,0x1f
    80004ad2:	f7a50513          	addi	a0,a0,-134 # 80023a48 <ftable>
    80004ad6:	ffffc097          	auipc	ra,0xffffc
    80004ada:	216080e7          	jalr	534(ra) # 80000cec <release>
  return f;
}
    80004ade:	8526                	mv	a0,s1
    80004ae0:	60e2                	ld	ra,24(sp)
    80004ae2:	6442                	ld	s0,16(sp)
    80004ae4:	64a2                	ld	s1,8(sp)
    80004ae6:	6105                	addi	sp,sp,32
    80004ae8:	8082                	ret
    panic("filedup");
    80004aea:	00004517          	auipc	a0,0x4
    80004aee:	b7650513          	addi	a0,a0,-1162 # 80008660 <etext+0x660>
    80004af2:	ffffc097          	auipc	ra,0xffffc
    80004af6:	a6e080e7          	jalr	-1426(ra) # 80000560 <panic>

0000000080004afa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004afa:	7139                	addi	sp,sp,-64
    80004afc:	fc06                	sd	ra,56(sp)
    80004afe:	f822                	sd	s0,48(sp)
    80004b00:	f426                	sd	s1,40(sp)
    80004b02:	0080                	addi	s0,sp,64
    80004b04:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b06:	0001f517          	auipc	a0,0x1f
    80004b0a:	f4250513          	addi	a0,a0,-190 # 80023a48 <ftable>
    80004b0e:	ffffc097          	auipc	ra,0xffffc
    80004b12:	12a080e7          	jalr	298(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004b16:	40dc                	lw	a5,4(s1)
    80004b18:	04f05c63          	blez	a5,80004b70 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004b1c:	37fd                	addiw	a5,a5,-1
    80004b1e:	0007871b          	sext.w	a4,a5
    80004b22:	c0dc                	sw	a5,4(s1)
    80004b24:	06e04263          	bgtz	a4,80004b88 <fileclose+0x8e>
    80004b28:	f04a                	sd	s2,32(sp)
    80004b2a:	ec4e                	sd	s3,24(sp)
    80004b2c:	e852                	sd	s4,16(sp)
    80004b2e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b30:	0004a903          	lw	s2,0(s1)
    80004b34:	0094ca83          	lbu	s5,9(s1)
    80004b38:	0104ba03          	ld	s4,16(s1)
    80004b3c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b40:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b44:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b48:	0001f517          	auipc	a0,0x1f
    80004b4c:	f0050513          	addi	a0,a0,-256 # 80023a48 <ftable>
    80004b50:	ffffc097          	auipc	ra,0xffffc
    80004b54:	19c080e7          	jalr	412(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004b58:	4785                	li	a5,1
    80004b5a:	04f90463          	beq	s2,a5,80004ba2 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b5e:	3979                	addiw	s2,s2,-2
    80004b60:	4785                	li	a5,1
    80004b62:	0527fb63          	bgeu	a5,s2,80004bb8 <fileclose+0xbe>
    80004b66:	7902                	ld	s2,32(sp)
    80004b68:	69e2                	ld	s3,24(sp)
    80004b6a:	6a42                	ld	s4,16(sp)
    80004b6c:	6aa2                	ld	s5,8(sp)
    80004b6e:	a02d                	j	80004b98 <fileclose+0x9e>
    80004b70:	f04a                	sd	s2,32(sp)
    80004b72:	ec4e                	sd	s3,24(sp)
    80004b74:	e852                	sd	s4,16(sp)
    80004b76:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004b78:	00004517          	auipc	a0,0x4
    80004b7c:	af050513          	addi	a0,a0,-1296 # 80008668 <etext+0x668>
    80004b80:	ffffc097          	auipc	ra,0xffffc
    80004b84:	9e0080e7          	jalr	-1568(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004b88:	0001f517          	auipc	a0,0x1f
    80004b8c:	ec050513          	addi	a0,a0,-320 # 80023a48 <ftable>
    80004b90:	ffffc097          	auipc	ra,0xffffc
    80004b94:	15c080e7          	jalr	348(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004b98:	70e2                	ld	ra,56(sp)
    80004b9a:	7442                	ld	s0,48(sp)
    80004b9c:	74a2                	ld	s1,40(sp)
    80004b9e:	6121                	addi	sp,sp,64
    80004ba0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ba2:	85d6                	mv	a1,s5
    80004ba4:	8552                	mv	a0,s4
    80004ba6:	00000097          	auipc	ra,0x0
    80004baa:	3a2080e7          	jalr	930(ra) # 80004f48 <pipeclose>
    80004bae:	7902                	ld	s2,32(sp)
    80004bb0:	69e2                	ld	s3,24(sp)
    80004bb2:	6a42                	ld	s4,16(sp)
    80004bb4:	6aa2                	ld	s5,8(sp)
    80004bb6:	b7cd                	j	80004b98 <fileclose+0x9e>
    begin_op();
    80004bb8:	00000097          	auipc	ra,0x0
    80004bbc:	a78080e7          	jalr	-1416(ra) # 80004630 <begin_op>
    iput(ff.ip);
    80004bc0:	854e                	mv	a0,s3
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	25e080e7          	jalr	606(ra) # 80003e20 <iput>
    end_op();
    80004bca:	00000097          	auipc	ra,0x0
    80004bce:	ae0080e7          	jalr	-1312(ra) # 800046aa <end_op>
    80004bd2:	7902                	ld	s2,32(sp)
    80004bd4:	69e2                	ld	s3,24(sp)
    80004bd6:	6a42                	ld	s4,16(sp)
    80004bd8:	6aa2                	ld	s5,8(sp)
    80004bda:	bf7d                	j	80004b98 <fileclose+0x9e>

0000000080004bdc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004bdc:	715d                	addi	sp,sp,-80
    80004bde:	e486                	sd	ra,72(sp)
    80004be0:	e0a2                	sd	s0,64(sp)
    80004be2:	fc26                	sd	s1,56(sp)
    80004be4:	f44e                	sd	s3,40(sp)
    80004be6:	0880                	addi	s0,sp,80
    80004be8:	84aa                	mv	s1,a0
    80004bea:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004bec:	ffffd097          	auipc	ra,0xffffd
    80004bf0:	0a8080e7          	jalr	168(ra) # 80001c94 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004bf4:	409c                	lw	a5,0(s1)
    80004bf6:	37f9                	addiw	a5,a5,-2
    80004bf8:	4705                	li	a4,1
    80004bfa:	04f76863          	bltu	a4,a5,80004c4a <filestat+0x6e>
    80004bfe:	f84a                	sd	s2,48(sp)
    80004c00:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c02:	6c88                	ld	a0,24(s1)
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	05e080e7          	jalr	94(ra) # 80003c62 <ilock>
    stati(f->ip, &st);
    80004c0c:	fb840593          	addi	a1,s0,-72
    80004c10:	6c88                	ld	a0,24(s1)
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	2de080e7          	jalr	734(ra) # 80003ef0 <stati>
    iunlock(f->ip);
    80004c1a:	6c88                	ld	a0,24(s1)
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	10c080e7          	jalr	268(ra) # 80003d28 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c24:	46e1                	li	a3,24
    80004c26:	fb840613          	addi	a2,s0,-72
    80004c2a:	85ce                	mv	a1,s3
    80004c2c:	05093503          	ld	a0,80(s2)
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	ab2080e7          	jalr	-1358(ra) # 800016e2 <copyout>
    80004c38:	41f5551b          	sraiw	a0,a0,0x1f
    80004c3c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004c3e:	60a6                	ld	ra,72(sp)
    80004c40:	6406                	ld	s0,64(sp)
    80004c42:	74e2                	ld	s1,56(sp)
    80004c44:	79a2                	ld	s3,40(sp)
    80004c46:	6161                	addi	sp,sp,80
    80004c48:	8082                	ret
  return -1;
    80004c4a:	557d                	li	a0,-1
    80004c4c:	bfcd                	j	80004c3e <filestat+0x62>

0000000080004c4e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c4e:	7179                	addi	sp,sp,-48
    80004c50:	f406                	sd	ra,40(sp)
    80004c52:	f022                	sd	s0,32(sp)
    80004c54:	e84a                	sd	s2,16(sp)
    80004c56:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c58:	00854783          	lbu	a5,8(a0)
    80004c5c:	cbc5                	beqz	a5,80004d0c <fileread+0xbe>
    80004c5e:	ec26                	sd	s1,24(sp)
    80004c60:	e44e                	sd	s3,8(sp)
    80004c62:	84aa                	mv	s1,a0
    80004c64:	89ae                	mv	s3,a1
    80004c66:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c68:	411c                	lw	a5,0(a0)
    80004c6a:	4705                	li	a4,1
    80004c6c:	04e78963          	beq	a5,a4,80004cbe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c70:	470d                	li	a4,3
    80004c72:	04e78f63          	beq	a5,a4,80004cd0 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c76:	4709                	li	a4,2
    80004c78:	08e79263          	bne	a5,a4,80004cfc <fileread+0xae>
    ilock(f->ip);
    80004c7c:	6d08                	ld	a0,24(a0)
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	fe4080e7          	jalr	-28(ra) # 80003c62 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c86:	874a                	mv	a4,s2
    80004c88:	5094                	lw	a3,32(s1)
    80004c8a:	864e                	mv	a2,s3
    80004c8c:	4585                	li	a1,1
    80004c8e:	6c88                	ld	a0,24(s1)
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	28a080e7          	jalr	650(ra) # 80003f1a <readi>
    80004c98:	892a                	mv	s2,a0
    80004c9a:	00a05563          	blez	a0,80004ca4 <fileread+0x56>
      f->off += r;
    80004c9e:	509c                	lw	a5,32(s1)
    80004ca0:	9fa9                	addw	a5,a5,a0
    80004ca2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ca4:	6c88                	ld	a0,24(s1)
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	082080e7          	jalr	130(ra) # 80003d28 <iunlock>
    80004cae:	64e2                	ld	s1,24(sp)
    80004cb0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	70a2                	ld	ra,40(sp)
    80004cb6:	7402                	ld	s0,32(sp)
    80004cb8:	6942                	ld	s2,16(sp)
    80004cba:	6145                	addi	sp,sp,48
    80004cbc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004cbe:	6908                	ld	a0,16(a0)
    80004cc0:	00000097          	auipc	ra,0x0
    80004cc4:	400080e7          	jalr	1024(ra) # 800050c0 <piperead>
    80004cc8:	892a                	mv	s2,a0
    80004cca:	64e2                	ld	s1,24(sp)
    80004ccc:	69a2                	ld	s3,8(sp)
    80004cce:	b7d5                	j	80004cb2 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004cd0:	02451783          	lh	a5,36(a0)
    80004cd4:	03079693          	slli	a3,a5,0x30
    80004cd8:	92c1                	srli	a3,a3,0x30
    80004cda:	4725                	li	a4,9
    80004cdc:	02d76a63          	bltu	a4,a3,80004d10 <fileread+0xc2>
    80004ce0:	0792                	slli	a5,a5,0x4
    80004ce2:	0001f717          	auipc	a4,0x1f
    80004ce6:	cc670713          	addi	a4,a4,-826 # 800239a8 <devsw>
    80004cea:	97ba                	add	a5,a5,a4
    80004cec:	639c                	ld	a5,0(a5)
    80004cee:	c78d                	beqz	a5,80004d18 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004cf0:	4505                	li	a0,1
    80004cf2:	9782                	jalr	a5
    80004cf4:	892a                	mv	s2,a0
    80004cf6:	64e2                	ld	s1,24(sp)
    80004cf8:	69a2                	ld	s3,8(sp)
    80004cfa:	bf65                	j	80004cb2 <fileread+0x64>
    panic("fileread");
    80004cfc:	00004517          	auipc	a0,0x4
    80004d00:	97c50513          	addi	a0,a0,-1668 # 80008678 <etext+0x678>
    80004d04:	ffffc097          	auipc	ra,0xffffc
    80004d08:	85c080e7          	jalr	-1956(ra) # 80000560 <panic>
    return -1;
    80004d0c:	597d                	li	s2,-1
    80004d0e:	b755                	j	80004cb2 <fileread+0x64>
      return -1;
    80004d10:	597d                	li	s2,-1
    80004d12:	64e2                	ld	s1,24(sp)
    80004d14:	69a2                	ld	s3,8(sp)
    80004d16:	bf71                	j	80004cb2 <fileread+0x64>
    80004d18:	597d                	li	s2,-1
    80004d1a:	64e2                	ld	s1,24(sp)
    80004d1c:	69a2                	ld	s3,8(sp)
    80004d1e:	bf51                	j	80004cb2 <fileread+0x64>

0000000080004d20 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004d20:	00954783          	lbu	a5,9(a0)
    80004d24:	12078963          	beqz	a5,80004e56 <filewrite+0x136>
{
    80004d28:	715d                	addi	sp,sp,-80
    80004d2a:	e486                	sd	ra,72(sp)
    80004d2c:	e0a2                	sd	s0,64(sp)
    80004d2e:	f84a                	sd	s2,48(sp)
    80004d30:	f052                	sd	s4,32(sp)
    80004d32:	e85a                	sd	s6,16(sp)
    80004d34:	0880                	addi	s0,sp,80
    80004d36:	892a                	mv	s2,a0
    80004d38:	8b2e                	mv	s6,a1
    80004d3a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d3c:	411c                	lw	a5,0(a0)
    80004d3e:	4705                	li	a4,1
    80004d40:	02e78763          	beq	a5,a4,80004d6e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d44:	470d                	li	a4,3
    80004d46:	02e78a63          	beq	a5,a4,80004d7a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d4a:	4709                	li	a4,2
    80004d4c:	0ee79863          	bne	a5,a4,80004e3c <filewrite+0x11c>
    80004d50:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d52:	0cc05463          	blez	a2,80004e1a <filewrite+0xfa>
    80004d56:	fc26                	sd	s1,56(sp)
    80004d58:	ec56                	sd	s5,24(sp)
    80004d5a:	e45e                	sd	s7,8(sp)
    80004d5c:	e062                	sd	s8,0(sp)
    int i = 0;
    80004d5e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004d60:	6b85                	lui	s7,0x1
    80004d62:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004d66:	6c05                	lui	s8,0x1
    80004d68:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004d6c:	a851                	j	80004e00 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004d6e:	6908                	ld	a0,16(a0)
    80004d70:	00000097          	auipc	ra,0x0
    80004d74:	248080e7          	jalr	584(ra) # 80004fb8 <pipewrite>
    80004d78:	a85d                	j	80004e2e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d7a:	02451783          	lh	a5,36(a0)
    80004d7e:	03079693          	slli	a3,a5,0x30
    80004d82:	92c1                	srli	a3,a3,0x30
    80004d84:	4725                	li	a4,9
    80004d86:	0cd76a63          	bltu	a4,a3,80004e5a <filewrite+0x13a>
    80004d8a:	0792                	slli	a5,a5,0x4
    80004d8c:	0001f717          	auipc	a4,0x1f
    80004d90:	c1c70713          	addi	a4,a4,-996 # 800239a8 <devsw>
    80004d94:	97ba                	add	a5,a5,a4
    80004d96:	679c                	ld	a5,8(a5)
    80004d98:	c3f9                	beqz	a5,80004e5e <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004d9a:	4505                	li	a0,1
    80004d9c:	9782                	jalr	a5
    80004d9e:	a841                	j	80004e2e <filewrite+0x10e>
      if(n1 > max)
    80004da0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004da4:	00000097          	auipc	ra,0x0
    80004da8:	88c080e7          	jalr	-1908(ra) # 80004630 <begin_op>
      ilock(f->ip);
    80004dac:	01893503          	ld	a0,24(s2)
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	eb2080e7          	jalr	-334(ra) # 80003c62 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004db8:	8756                	mv	a4,s5
    80004dba:	02092683          	lw	a3,32(s2)
    80004dbe:	01698633          	add	a2,s3,s6
    80004dc2:	4585                	li	a1,1
    80004dc4:	01893503          	ld	a0,24(s2)
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	262080e7          	jalr	610(ra) # 8000402a <writei>
    80004dd0:	84aa                	mv	s1,a0
    80004dd2:	00a05763          	blez	a0,80004de0 <filewrite+0xc0>
        f->off += r;
    80004dd6:	02092783          	lw	a5,32(s2)
    80004dda:	9fa9                	addw	a5,a5,a0
    80004ddc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004de0:	01893503          	ld	a0,24(s2)
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	f44080e7          	jalr	-188(ra) # 80003d28 <iunlock>
      end_op();
    80004dec:	00000097          	auipc	ra,0x0
    80004df0:	8be080e7          	jalr	-1858(ra) # 800046aa <end_op>

      if(r != n1){
    80004df4:	029a9563          	bne	s5,s1,80004e1e <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004df8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004dfc:	0149da63          	bge	s3,s4,80004e10 <filewrite+0xf0>
      int n1 = n - i;
    80004e00:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004e04:	0004879b          	sext.w	a5,s1
    80004e08:	f8fbdce3          	bge	s7,a5,80004da0 <filewrite+0x80>
    80004e0c:	84e2                	mv	s1,s8
    80004e0e:	bf49                	j	80004da0 <filewrite+0x80>
    80004e10:	74e2                	ld	s1,56(sp)
    80004e12:	6ae2                	ld	s5,24(sp)
    80004e14:	6ba2                	ld	s7,8(sp)
    80004e16:	6c02                	ld	s8,0(sp)
    80004e18:	a039                	j	80004e26 <filewrite+0x106>
    int i = 0;
    80004e1a:	4981                	li	s3,0
    80004e1c:	a029                	j	80004e26 <filewrite+0x106>
    80004e1e:	74e2                	ld	s1,56(sp)
    80004e20:	6ae2                	ld	s5,24(sp)
    80004e22:	6ba2                	ld	s7,8(sp)
    80004e24:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004e26:	033a1e63          	bne	s4,s3,80004e62 <filewrite+0x142>
    80004e2a:	8552                	mv	a0,s4
    80004e2c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e2e:	60a6                	ld	ra,72(sp)
    80004e30:	6406                	ld	s0,64(sp)
    80004e32:	7942                	ld	s2,48(sp)
    80004e34:	7a02                	ld	s4,32(sp)
    80004e36:	6b42                	ld	s6,16(sp)
    80004e38:	6161                	addi	sp,sp,80
    80004e3a:	8082                	ret
    80004e3c:	fc26                	sd	s1,56(sp)
    80004e3e:	f44e                	sd	s3,40(sp)
    80004e40:	ec56                	sd	s5,24(sp)
    80004e42:	e45e                	sd	s7,8(sp)
    80004e44:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004e46:	00004517          	auipc	a0,0x4
    80004e4a:	84250513          	addi	a0,a0,-1982 # 80008688 <etext+0x688>
    80004e4e:	ffffb097          	auipc	ra,0xffffb
    80004e52:	712080e7          	jalr	1810(ra) # 80000560 <panic>
    return -1;
    80004e56:	557d                	li	a0,-1
}
    80004e58:	8082                	ret
      return -1;
    80004e5a:	557d                	li	a0,-1
    80004e5c:	bfc9                	j	80004e2e <filewrite+0x10e>
    80004e5e:	557d                	li	a0,-1
    80004e60:	b7f9                	j	80004e2e <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004e62:	557d                	li	a0,-1
    80004e64:	79a2                	ld	s3,40(sp)
    80004e66:	b7e1                	j	80004e2e <filewrite+0x10e>

0000000080004e68 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e68:	7179                	addi	sp,sp,-48
    80004e6a:	f406                	sd	ra,40(sp)
    80004e6c:	f022                	sd	s0,32(sp)
    80004e6e:	ec26                	sd	s1,24(sp)
    80004e70:	e052                	sd	s4,0(sp)
    80004e72:	1800                	addi	s0,sp,48
    80004e74:	84aa                	mv	s1,a0
    80004e76:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e78:	0005b023          	sd	zero,0(a1)
    80004e7c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e80:	00000097          	auipc	ra,0x0
    80004e84:	bbe080e7          	jalr	-1090(ra) # 80004a3e <filealloc>
    80004e88:	e088                	sd	a0,0(s1)
    80004e8a:	cd49                	beqz	a0,80004f24 <pipealloc+0xbc>
    80004e8c:	00000097          	auipc	ra,0x0
    80004e90:	bb2080e7          	jalr	-1102(ra) # 80004a3e <filealloc>
    80004e94:	00aa3023          	sd	a0,0(s4)
    80004e98:	c141                	beqz	a0,80004f18 <pipealloc+0xb0>
    80004e9a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e9c:	ffffc097          	auipc	ra,0xffffc
    80004ea0:	cac080e7          	jalr	-852(ra) # 80000b48 <kalloc>
    80004ea4:	892a                	mv	s2,a0
    80004ea6:	c13d                	beqz	a0,80004f0c <pipealloc+0xa4>
    80004ea8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004eaa:	4985                	li	s3,1
    80004eac:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004eb0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004eb4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004eb8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ebc:	00003597          	auipc	a1,0x3
    80004ec0:	7dc58593          	addi	a1,a1,2012 # 80008698 <etext+0x698>
    80004ec4:	ffffc097          	auipc	ra,0xffffc
    80004ec8:	ce4080e7          	jalr	-796(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004ecc:	609c                	ld	a5,0(s1)
    80004ece:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ed2:	609c                	ld	a5,0(s1)
    80004ed4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ed8:	609c                	ld	a5,0(s1)
    80004eda:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004ede:	609c                	ld	a5,0(s1)
    80004ee0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004ee4:	000a3783          	ld	a5,0(s4)
    80004ee8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004eec:	000a3783          	ld	a5,0(s4)
    80004ef0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ef4:	000a3783          	ld	a5,0(s4)
    80004ef8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004efc:	000a3783          	ld	a5,0(s4)
    80004f00:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f04:	4501                	li	a0,0
    80004f06:	6942                	ld	s2,16(sp)
    80004f08:	69a2                	ld	s3,8(sp)
    80004f0a:	a03d                	j	80004f38 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f0c:	6088                	ld	a0,0(s1)
    80004f0e:	c119                	beqz	a0,80004f14 <pipealloc+0xac>
    80004f10:	6942                	ld	s2,16(sp)
    80004f12:	a029                	j	80004f1c <pipealloc+0xb4>
    80004f14:	6942                	ld	s2,16(sp)
    80004f16:	a039                	j	80004f24 <pipealloc+0xbc>
    80004f18:	6088                	ld	a0,0(s1)
    80004f1a:	c50d                	beqz	a0,80004f44 <pipealloc+0xdc>
    fileclose(*f0);
    80004f1c:	00000097          	auipc	ra,0x0
    80004f20:	bde080e7          	jalr	-1058(ra) # 80004afa <fileclose>
  if(*f1)
    80004f24:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004f28:	557d                	li	a0,-1
  if(*f1)
    80004f2a:	c799                	beqz	a5,80004f38 <pipealloc+0xd0>
    fileclose(*f1);
    80004f2c:	853e                	mv	a0,a5
    80004f2e:	00000097          	auipc	ra,0x0
    80004f32:	bcc080e7          	jalr	-1076(ra) # 80004afa <fileclose>
  return -1;
    80004f36:	557d                	li	a0,-1
}
    80004f38:	70a2                	ld	ra,40(sp)
    80004f3a:	7402                	ld	s0,32(sp)
    80004f3c:	64e2                	ld	s1,24(sp)
    80004f3e:	6a02                	ld	s4,0(sp)
    80004f40:	6145                	addi	sp,sp,48
    80004f42:	8082                	ret
  return -1;
    80004f44:	557d                	li	a0,-1
    80004f46:	bfcd                	j	80004f38 <pipealloc+0xd0>

0000000080004f48 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f48:	1101                	addi	sp,sp,-32
    80004f4a:	ec06                	sd	ra,24(sp)
    80004f4c:	e822                	sd	s0,16(sp)
    80004f4e:	e426                	sd	s1,8(sp)
    80004f50:	e04a                	sd	s2,0(sp)
    80004f52:	1000                	addi	s0,sp,32
    80004f54:	84aa                	mv	s1,a0
    80004f56:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f58:	ffffc097          	auipc	ra,0xffffc
    80004f5c:	ce0080e7          	jalr	-800(ra) # 80000c38 <acquire>
  if(writable){
    80004f60:	02090d63          	beqz	s2,80004f9a <pipeclose+0x52>
    pi->writeopen = 0;
    80004f64:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f68:	21848513          	addi	a0,s1,536
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	564080e7          	jalr	1380(ra) # 800024d0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f74:	2204b783          	ld	a5,544(s1)
    80004f78:	eb95                	bnez	a5,80004fac <pipeclose+0x64>
    release(&pi->lock);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	d70080e7          	jalr	-656(ra) # 80000cec <release>
    kfree((char*)pi);
    80004f84:	8526                	mv	a0,s1
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	ac4080e7          	jalr	-1340(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80004f8e:	60e2                	ld	ra,24(sp)
    80004f90:	6442                	ld	s0,16(sp)
    80004f92:	64a2                	ld	s1,8(sp)
    80004f94:	6902                	ld	s2,0(sp)
    80004f96:	6105                	addi	sp,sp,32
    80004f98:	8082                	ret
    pi->readopen = 0;
    80004f9a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f9e:	21c48513          	addi	a0,s1,540
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	52e080e7          	jalr	1326(ra) # 800024d0 <wakeup>
    80004faa:	b7e9                	j	80004f74 <pipeclose+0x2c>
    release(&pi->lock);
    80004fac:	8526                	mv	a0,s1
    80004fae:	ffffc097          	auipc	ra,0xffffc
    80004fb2:	d3e080e7          	jalr	-706(ra) # 80000cec <release>
}
    80004fb6:	bfe1                	j	80004f8e <pipeclose+0x46>

0000000080004fb8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004fb8:	711d                	addi	sp,sp,-96
    80004fba:	ec86                	sd	ra,88(sp)
    80004fbc:	e8a2                	sd	s0,80(sp)
    80004fbe:	e4a6                	sd	s1,72(sp)
    80004fc0:	e0ca                	sd	s2,64(sp)
    80004fc2:	fc4e                	sd	s3,56(sp)
    80004fc4:	f852                	sd	s4,48(sp)
    80004fc6:	f456                	sd	s5,40(sp)
    80004fc8:	1080                	addi	s0,sp,96
    80004fca:	84aa                	mv	s1,a0
    80004fcc:	8aae                	mv	s5,a1
    80004fce:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004fd0:	ffffd097          	auipc	ra,0xffffd
    80004fd4:	cc4080e7          	jalr	-828(ra) # 80001c94 <myproc>
    80004fd8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004fda:	8526                	mv	a0,s1
    80004fdc:	ffffc097          	auipc	ra,0xffffc
    80004fe0:	c5c080e7          	jalr	-932(ra) # 80000c38 <acquire>
  while(i < n){
    80004fe4:	0d405863          	blez	s4,800050b4 <pipewrite+0xfc>
    80004fe8:	f05a                	sd	s6,32(sp)
    80004fea:	ec5e                	sd	s7,24(sp)
    80004fec:	e862                	sd	s8,16(sp)
  int i = 0;
    80004fee:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ff0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004ff2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ff6:	21c48b93          	addi	s7,s1,540
    80004ffa:	a089                	j	8000503c <pipewrite+0x84>
      release(&pi->lock);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	ffffc097          	auipc	ra,0xffffc
    80005002:	cee080e7          	jalr	-786(ra) # 80000cec <release>
      return -1;
    80005006:	597d                	li	s2,-1
    80005008:	7b02                	ld	s6,32(sp)
    8000500a:	6be2                	ld	s7,24(sp)
    8000500c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000500e:	854a                	mv	a0,s2
    80005010:	60e6                	ld	ra,88(sp)
    80005012:	6446                	ld	s0,80(sp)
    80005014:	64a6                	ld	s1,72(sp)
    80005016:	6906                	ld	s2,64(sp)
    80005018:	79e2                	ld	s3,56(sp)
    8000501a:	7a42                	ld	s4,48(sp)
    8000501c:	7aa2                	ld	s5,40(sp)
    8000501e:	6125                	addi	sp,sp,96
    80005020:	8082                	ret
      wakeup(&pi->nread);
    80005022:	8562                	mv	a0,s8
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	4ac080e7          	jalr	1196(ra) # 800024d0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000502c:	85a6                	mv	a1,s1
    8000502e:	855e                	mv	a0,s7
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	43c080e7          	jalr	1084(ra) # 8000246c <sleep>
  while(i < n){
    80005038:	05495f63          	bge	s2,s4,80005096 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    8000503c:	2204a783          	lw	a5,544(s1)
    80005040:	dfd5                	beqz	a5,80004ffc <pipewrite+0x44>
    80005042:	854e                	mv	a0,s3
    80005044:	ffffd097          	auipc	ra,0xffffd
    80005048:	6d0080e7          	jalr	1744(ra) # 80002714 <killed>
    8000504c:	f945                	bnez	a0,80004ffc <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000504e:	2184a783          	lw	a5,536(s1)
    80005052:	21c4a703          	lw	a4,540(s1)
    80005056:	2007879b          	addiw	a5,a5,512
    8000505a:	fcf704e3          	beq	a4,a5,80005022 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000505e:	4685                	li	a3,1
    80005060:	01590633          	add	a2,s2,s5
    80005064:	faf40593          	addi	a1,s0,-81
    80005068:	0509b503          	ld	a0,80(s3)
    8000506c:	ffffc097          	auipc	ra,0xffffc
    80005070:	702080e7          	jalr	1794(ra) # 8000176e <copyin>
    80005074:	05650263          	beq	a0,s6,800050b8 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005078:	21c4a783          	lw	a5,540(s1)
    8000507c:	0017871b          	addiw	a4,a5,1
    80005080:	20e4ae23          	sw	a4,540(s1)
    80005084:	1ff7f793          	andi	a5,a5,511
    80005088:	97a6                	add	a5,a5,s1
    8000508a:	faf44703          	lbu	a4,-81(s0)
    8000508e:	00e78c23          	sb	a4,24(a5)
      i++;
    80005092:	2905                	addiw	s2,s2,1
    80005094:	b755                	j	80005038 <pipewrite+0x80>
    80005096:	7b02                	ld	s6,32(sp)
    80005098:	6be2                	ld	s7,24(sp)
    8000509a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000509c:	21848513          	addi	a0,s1,536
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	430080e7          	jalr	1072(ra) # 800024d0 <wakeup>
  release(&pi->lock);
    800050a8:	8526                	mv	a0,s1
    800050aa:	ffffc097          	auipc	ra,0xffffc
    800050ae:	c42080e7          	jalr	-958(ra) # 80000cec <release>
  return i;
    800050b2:	bfb1                	j	8000500e <pipewrite+0x56>
  int i = 0;
    800050b4:	4901                	li	s2,0
    800050b6:	b7dd                	j	8000509c <pipewrite+0xe4>
    800050b8:	7b02                	ld	s6,32(sp)
    800050ba:	6be2                	ld	s7,24(sp)
    800050bc:	6c42                	ld	s8,16(sp)
    800050be:	bff9                	j	8000509c <pipewrite+0xe4>

00000000800050c0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800050c0:	715d                	addi	sp,sp,-80
    800050c2:	e486                	sd	ra,72(sp)
    800050c4:	e0a2                	sd	s0,64(sp)
    800050c6:	fc26                	sd	s1,56(sp)
    800050c8:	f84a                	sd	s2,48(sp)
    800050ca:	f44e                	sd	s3,40(sp)
    800050cc:	f052                	sd	s4,32(sp)
    800050ce:	ec56                	sd	s5,24(sp)
    800050d0:	0880                	addi	s0,sp,80
    800050d2:	84aa                	mv	s1,a0
    800050d4:	892e                	mv	s2,a1
    800050d6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800050d8:	ffffd097          	auipc	ra,0xffffd
    800050dc:	bbc080e7          	jalr	-1092(ra) # 80001c94 <myproc>
    800050e0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800050e2:	8526                	mv	a0,s1
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	b54080e7          	jalr	-1196(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050ec:	2184a703          	lw	a4,536(s1)
    800050f0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050f4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050f8:	02f71963          	bne	a4,a5,8000512a <piperead+0x6a>
    800050fc:	2244a783          	lw	a5,548(s1)
    80005100:	cf95                	beqz	a5,8000513c <piperead+0x7c>
    if(killed(pr)){
    80005102:	8552                	mv	a0,s4
    80005104:	ffffd097          	auipc	ra,0xffffd
    80005108:	610080e7          	jalr	1552(ra) # 80002714 <killed>
    8000510c:	e10d                	bnez	a0,8000512e <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000510e:	85a6                	mv	a1,s1
    80005110:	854e                	mv	a0,s3
    80005112:	ffffd097          	auipc	ra,0xffffd
    80005116:	35a080e7          	jalr	858(ra) # 8000246c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000511a:	2184a703          	lw	a4,536(s1)
    8000511e:	21c4a783          	lw	a5,540(s1)
    80005122:	fcf70de3          	beq	a4,a5,800050fc <piperead+0x3c>
    80005126:	e85a                	sd	s6,16(sp)
    80005128:	a819                	j	8000513e <piperead+0x7e>
    8000512a:	e85a                	sd	s6,16(sp)
    8000512c:	a809                	j	8000513e <piperead+0x7e>
      release(&pi->lock);
    8000512e:	8526                	mv	a0,s1
    80005130:	ffffc097          	auipc	ra,0xffffc
    80005134:	bbc080e7          	jalr	-1092(ra) # 80000cec <release>
      return -1;
    80005138:	59fd                	li	s3,-1
    8000513a:	a0a5                	j	800051a2 <piperead+0xe2>
    8000513c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000513e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005140:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005142:	05505463          	blez	s5,8000518a <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80005146:	2184a783          	lw	a5,536(s1)
    8000514a:	21c4a703          	lw	a4,540(s1)
    8000514e:	02f70e63          	beq	a4,a5,8000518a <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005152:	0017871b          	addiw	a4,a5,1
    80005156:	20e4ac23          	sw	a4,536(s1)
    8000515a:	1ff7f793          	andi	a5,a5,511
    8000515e:	97a6                	add	a5,a5,s1
    80005160:	0187c783          	lbu	a5,24(a5)
    80005164:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005168:	4685                	li	a3,1
    8000516a:	fbf40613          	addi	a2,s0,-65
    8000516e:	85ca                	mv	a1,s2
    80005170:	050a3503          	ld	a0,80(s4)
    80005174:	ffffc097          	auipc	ra,0xffffc
    80005178:	56e080e7          	jalr	1390(ra) # 800016e2 <copyout>
    8000517c:	01650763          	beq	a0,s6,8000518a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005180:	2985                	addiw	s3,s3,1
    80005182:	0905                	addi	s2,s2,1
    80005184:	fd3a91e3          	bne	s5,s3,80005146 <piperead+0x86>
    80005188:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000518a:	21c48513          	addi	a0,s1,540
    8000518e:	ffffd097          	auipc	ra,0xffffd
    80005192:	342080e7          	jalr	834(ra) # 800024d0 <wakeup>
  release(&pi->lock);
    80005196:	8526                	mv	a0,s1
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	b54080e7          	jalr	-1196(ra) # 80000cec <release>
    800051a0:	6b42                	ld	s6,16(sp)
  return i;
}
    800051a2:	854e                	mv	a0,s3
    800051a4:	60a6                	ld	ra,72(sp)
    800051a6:	6406                	ld	s0,64(sp)
    800051a8:	74e2                	ld	s1,56(sp)
    800051aa:	7942                	ld	s2,48(sp)
    800051ac:	79a2                	ld	s3,40(sp)
    800051ae:	7a02                	ld	s4,32(sp)
    800051b0:	6ae2                	ld	s5,24(sp)
    800051b2:	6161                	addi	sp,sp,80
    800051b4:	8082                	ret

00000000800051b6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e422                	sd	s0,8(sp)
    800051ba:	0800                	addi	s0,sp,16
    800051bc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800051be:	8905                	andi	a0,a0,1
    800051c0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800051c2:	8b89                	andi	a5,a5,2
    800051c4:	c399                	beqz	a5,800051ca <flags2perm+0x14>
      perm |= PTE_W;
    800051c6:	00456513          	ori	a0,a0,4
    return perm;
}
    800051ca:	6422                	ld	s0,8(sp)
    800051cc:	0141                	addi	sp,sp,16
    800051ce:	8082                	ret

00000000800051d0 <exec>:

int
exec(char *path, char **argv)
{
    800051d0:	df010113          	addi	sp,sp,-528
    800051d4:	20113423          	sd	ra,520(sp)
    800051d8:	20813023          	sd	s0,512(sp)
    800051dc:	ffa6                	sd	s1,504(sp)
    800051de:	fbca                	sd	s2,496(sp)
    800051e0:	0c00                	addi	s0,sp,528
    800051e2:	892a                	mv	s2,a0
    800051e4:	dea43c23          	sd	a0,-520(s0)
    800051e8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800051ec:	ffffd097          	auipc	ra,0xffffd
    800051f0:	aa8080e7          	jalr	-1368(ra) # 80001c94 <myproc>
    800051f4:	84aa                	mv	s1,a0

  begin_op();
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	43a080e7          	jalr	1082(ra) # 80004630 <begin_op>

  if((ip = namei(path)) == 0){
    800051fe:	854a                	mv	a0,s2
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	230080e7          	jalr	560(ra) # 80004430 <namei>
    80005208:	c135                	beqz	a0,8000526c <exec+0x9c>
    8000520a:	f3d2                	sd	s4,480(sp)
    8000520c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000520e:	fffff097          	auipc	ra,0xfffff
    80005212:	a54080e7          	jalr	-1452(ra) # 80003c62 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005216:	04000713          	li	a4,64
    8000521a:	4681                	li	a3,0
    8000521c:	e5040613          	addi	a2,s0,-432
    80005220:	4581                	li	a1,0
    80005222:	8552                	mv	a0,s4
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	cf6080e7          	jalr	-778(ra) # 80003f1a <readi>
    8000522c:	04000793          	li	a5,64
    80005230:	00f51a63          	bne	a0,a5,80005244 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005234:	e5042703          	lw	a4,-432(s0)
    80005238:	464c47b7          	lui	a5,0x464c4
    8000523c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005240:	02f70c63          	beq	a4,a5,80005278 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005244:	8552                	mv	a0,s4
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	c82080e7          	jalr	-894(ra) # 80003ec8 <iunlockput>
    end_op();
    8000524e:	fffff097          	auipc	ra,0xfffff
    80005252:	45c080e7          	jalr	1116(ra) # 800046aa <end_op>
  }
  return -1;
    80005256:	557d                	li	a0,-1
    80005258:	7a1e                	ld	s4,480(sp)
}
    8000525a:	20813083          	ld	ra,520(sp)
    8000525e:	20013403          	ld	s0,512(sp)
    80005262:	74fe                	ld	s1,504(sp)
    80005264:	795e                	ld	s2,496(sp)
    80005266:	21010113          	addi	sp,sp,528
    8000526a:	8082                	ret
    end_op();
    8000526c:	fffff097          	auipc	ra,0xfffff
    80005270:	43e080e7          	jalr	1086(ra) # 800046aa <end_op>
    return -1;
    80005274:	557d                	li	a0,-1
    80005276:	b7d5                	j	8000525a <exec+0x8a>
    80005278:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000527a:	8526                	mv	a0,s1
    8000527c:	ffffd097          	auipc	ra,0xffffd
    80005280:	adc080e7          	jalr	-1316(ra) # 80001d58 <proc_pagetable>
    80005284:	8b2a                	mv	s6,a0
    80005286:	30050f63          	beqz	a0,800055a4 <exec+0x3d4>
    8000528a:	f7ce                	sd	s3,488(sp)
    8000528c:	efd6                	sd	s5,472(sp)
    8000528e:	e7de                	sd	s7,456(sp)
    80005290:	e3e2                	sd	s8,448(sp)
    80005292:	ff66                	sd	s9,440(sp)
    80005294:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005296:	e7042d03          	lw	s10,-400(s0)
    8000529a:	e8845783          	lhu	a5,-376(s0)
    8000529e:	14078d63          	beqz	a5,800053f8 <exec+0x228>
    800052a2:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052a4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052a6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800052a8:	6c85                	lui	s9,0x1
    800052aa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800052ae:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800052b2:	6a85                	lui	s5,0x1
    800052b4:	a0b5                	j	80005320 <exec+0x150>
      panic("loadseg: address should exist");
    800052b6:	00003517          	auipc	a0,0x3
    800052ba:	3ea50513          	addi	a0,a0,1002 # 800086a0 <etext+0x6a0>
    800052be:	ffffb097          	auipc	ra,0xffffb
    800052c2:	2a2080e7          	jalr	674(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800052c6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800052c8:	8726                	mv	a4,s1
    800052ca:	012c06bb          	addw	a3,s8,s2
    800052ce:	4581                	li	a1,0
    800052d0:	8552                	mv	a0,s4
    800052d2:	fffff097          	auipc	ra,0xfffff
    800052d6:	c48080e7          	jalr	-952(ra) # 80003f1a <readi>
    800052da:	2501                	sext.w	a0,a0
    800052dc:	28a49863          	bne	s1,a0,8000556c <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    800052e0:	012a893b          	addw	s2,s5,s2
    800052e4:	03397563          	bgeu	s2,s3,8000530e <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800052e8:	02091593          	slli	a1,s2,0x20
    800052ec:	9181                	srli	a1,a1,0x20
    800052ee:	95de                	add	a1,a1,s7
    800052f0:	855a                	mv	a0,s6
    800052f2:	ffffc097          	auipc	ra,0xffffc
    800052f6:	dc4080e7          	jalr	-572(ra) # 800010b6 <walkaddr>
    800052fa:	862a                	mv	a2,a0
    if(pa == 0)
    800052fc:	dd4d                	beqz	a0,800052b6 <exec+0xe6>
    if(sz - i < PGSIZE)
    800052fe:	412984bb          	subw	s1,s3,s2
    80005302:	0004879b          	sext.w	a5,s1
    80005306:	fcfcf0e3          	bgeu	s9,a5,800052c6 <exec+0xf6>
    8000530a:	84d6                	mv	s1,s5
    8000530c:	bf6d                	j	800052c6 <exec+0xf6>
    sz = sz1;
    8000530e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005312:	2d85                	addiw	s11,s11,1
    80005314:	038d0d1b          	addiw	s10,s10,56
    80005318:	e8845783          	lhu	a5,-376(s0)
    8000531c:	08fdd663          	bge	s11,a5,800053a8 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005320:	2d01                	sext.w	s10,s10
    80005322:	03800713          	li	a4,56
    80005326:	86ea                	mv	a3,s10
    80005328:	e1840613          	addi	a2,s0,-488
    8000532c:	4581                	li	a1,0
    8000532e:	8552                	mv	a0,s4
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	bea080e7          	jalr	-1046(ra) # 80003f1a <readi>
    80005338:	03800793          	li	a5,56
    8000533c:	20f51063          	bne	a0,a5,8000553c <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80005340:	e1842783          	lw	a5,-488(s0)
    80005344:	4705                	li	a4,1
    80005346:	fce796e3          	bne	a5,a4,80005312 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000534a:	e4043483          	ld	s1,-448(s0)
    8000534e:	e3843783          	ld	a5,-456(s0)
    80005352:	1ef4e963          	bltu	s1,a5,80005544 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005356:	e2843783          	ld	a5,-472(s0)
    8000535a:	94be                	add	s1,s1,a5
    8000535c:	1ef4e863          	bltu	s1,a5,8000554c <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005360:	df043703          	ld	a4,-528(s0)
    80005364:	8ff9                	and	a5,a5,a4
    80005366:	1e079763          	bnez	a5,80005554 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000536a:	e1c42503          	lw	a0,-484(s0)
    8000536e:	00000097          	auipc	ra,0x0
    80005372:	e48080e7          	jalr	-440(ra) # 800051b6 <flags2perm>
    80005376:	86aa                	mv	a3,a0
    80005378:	8626                	mv	a2,s1
    8000537a:	85ca                	mv	a1,s2
    8000537c:	855a                	mv	a0,s6
    8000537e:	ffffc097          	auipc	ra,0xffffc
    80005382:	0fc080e7          	jalr	252(ra) # 8000147a <uvmalloc>
    80005386:	e0a43423          	sd	a0,-504(s0)
    8000538a:	1c050963          	beqz	a0,8000555c <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000538e:	e2843b83          	ld	s7,-472(s0)
    80005392:	e2042c03          	lw	s8,-480(s0)
    80005396:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000539a:	00098463          	beqz	s3,800053a2 <exec+0x1d2>
    8000539e:	4901                	li	s2,0
    800053a0:	b7a1                	j	800052e8 <exec+0x118>
    sz = sz1;
    800053a2:	e0843903          	ld	s2,-504(s0)
    800053a6:	b7b5                	j	80005312 <exec+0x142>
    800053a8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800053aa:	8552                	mv	a0,s4
    800053ac:	fffff097          	auipc	ra,0xfffff
    800053b0:	b1c080e7          	jalr	-1252(ra) # 80003ec8 <iunlockput>
  end_op();
    800053b4:	fffff097          	auipc	ra,0xfffff
    800053b8:	2f6080e7          	jalr	758(ra) # 800046aa <end_op>
  p = myproc();
    800053bc:	ffffd097          	auipc	ra,0xffffd
    800053c0:	8d8080e7          	jalr	-1832(ra) # 80001c94 <myproc>
    800053c4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800053c6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800053ca:	6985                	lui	s3,0x1
    800053cc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800053ce:	99ca                	add	s3,s3,s2
    800053d0:	77fd                	lui	a5,0xfffff
    800053d2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800053d6:	4691                	li	a3,4
    800053d8:	6609                	lui	a2,0x2
    800053da:	964e                	add	a2,a2,s3
    800053dc:	85ce                	mv	a1,s3
    800053de:	855a                	mv	a0,s6
    800053e0:	ffffc097          	auipc	ra,0xffffc
    800053e4:	09a080e7          	jalr	154(ra) # 8000147a <uvmalloc>
    800053e8:	892a                	mv	s2,a0
    800053ea:	e0a43423          	sd	a0,-504(s0)
    800053ee:	e519                	bnez	a0,800053fc <exec+0x22c>
  if(pagetable)
    800053f0:	e1343423          	sd	s3,-504(s0)
    800053f4:	4a01                	li	s4,0
    800053f6:	aaa5                	j	8000556e <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053f8:	4901                	li	s2,0
    800053fa:	bf45                	j	800053aa <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800053fc:	75f9                	lui	a1,0xffffe
    800053fe:	95aa                	add	a1,a1,a0
    80005400:	855a                	mv	a0,s6
    80005402:	ffffc097          	auipc	ra,0xffffc
    80005406:	2ae080e7          	jalr	686(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000540a:	7bfd                	lui	s7,0xfffff
    8000540c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000540e:	e0043783          	ld	a5,-512(s0)
    80005412:	6388                	ld	a0,0(a5)
    80005414:	c52d                	beqz	a0,8000547e <exec+0x2ae>
    80005416:	e9040993          	addi	s3,s0,-368
    8000541a:	f9040c13          	addi	s8,s0,-112
    8000541e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005420:	ffffc097          	auipc	ra,0xffffc
    80005424:	a88080e7          	jalr	-1400(ra) # 80000ea8 <strlen>
    80005428:	0015079b          	addiw	a5,a0,1
    8000542c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005430:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005434:	13796863          	bltu	s2,s7,80005564 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005438:	e0043d03          	ld	s10,-512(s0)
    8000543c:	000d3a03          	ld	s4,0(s10)
    80005440:	8552                	mv	a0,s4
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	a66080e7          	jalr	-1434(ra) # 80000ea8 <strlen>
    8000544a:	0015069b          	addiw	a3,a0,1
    8000544e:	8652                	mv	a2,s4
    80005450:	85ca                	mv	a1,s2
    80005452:	855a                	mv	a0,s6
    80005454:	ffffc097          	auipc	ra,0xffffc
    80005458:	28e080e7          	jalr	654(ra) # 800016e2 <copyout>
    8000545c:	10054663          	bltz	a0,80005568 <exec+0x398>
    ustack[argc] = sp;
    80005460:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005464:	0485                	addi	s1,s1,1
    80005466:	008d0793          	addi	a5,s10,8
    8000546a:	e0f43023          	sd	a5,-512(s0)
    8000546e:	008d3503          	ld	a0,8(s10)
    80005472:	c909                	beqz	a0,80005484 <exec+0x2b4>
    if(argc >= MAXARG)
    80005474:	09a1                	addi	s3,s3,8
    80005476:	fb8995e3          	bne	s3,s8,80005420 <exec+0x250>
  ip = 0;
    8000547a:	4a01                	li	s4,0
    8000547c:	a8cd                	j	8000556e <exec+0x39e>
  sp = sz;
    8000547e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005482:	4481                	li	s1,0
  ustack[argc] = 0;
    80005484:	00349793          	slli	a5,s1,0x3
    80005488:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda450>
    8000548c:	97a2                	add	a5,a5,s0
    8000548e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005492:	00148693          	addi	a3,s1,1
    80005496:	068e                	slli	a3,a3,0x3
    80005498:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000549c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800054a0:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800054a4:	f57966e3          	bltu	s2,s7,800053f0 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800054a8:	e9040613          	addi	a2,s0,-368
    800054ac:	85ca                	mv	a1,s2
    800054ae:	855a                	mv	a0,s6
    800054b0:	ffffc097          	auipc	ra,0xffffc
    800054b4:	232080e7          	jalr	562(ra) # 800016e2 <copyout>
    800054b8:	0e054863          	bltz	a0,800055a8 <exec+0x3d8>
  p->trapframe->a1 = sp;
    800054bc:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800054c0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800054c4:	df843783          	ld	a5,-520(s0)
    800054c8:	0007c703          	lbu	a4,0(a5)
    800054cc:	cf11                	beqz	a4,800054e8 <exec+0x318>
    800054ce:	0785                	addi	a5,a5,1
    if(*s == '/')
    800054d0:	02f00693          	li	a3,47
    800054d4:	a039                	j	800054e2 <exec+0x312>
      last = s+1;
    800054d6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800054da:	0785                	addi	a5,a5,1
    800054dc:	fff7c703          	lbu	a4,-1(a5)
    800054e0:	c701                	beqz	a4,800054e8 <exec+0x318>
    if(*s == '/')
    800054e2:	fed71ce3          	bne	a4,a3,800054da <exec+0x30a>
    800054e6:	bfc5                	j	800054d6 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800054e8:	4641                	li	a2,16
    800054ea:	df843583          	ld	a1,-520(s0)
    800054ee:	158a8513          	addi	a0,s5,344
    800054f2:	ffffc097          	auipc	ra,0xffffc
    800054f6:	984080e7          	jalr	-1660(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    800054fa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800054fe:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005502:	e0843783          	ld	a5,-504(s0)
    80005506:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000550a:	058ab783          	ld	a5,88(s5)
    8000550e:	e6843703          	ld	a4,-408(s0)
    80005512:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005514:	058ab783          	ld	a5,88(s5)
    80005518:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000551c:	85e6                	mv	a1,s9
    8000551e:	ffffd097          	auipc	ra,0xffffd
    80005522:	8d6080e7          	jalr	-1834(ra) # 80001df4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005526:	0004851b          	sext.w	a0,s1
    8000552a:	79be                	ld	s3,488(sp)
    8000552c:	7a1e                	ld	s4,480(sp)
    8000552e:	6afe                	ld	s5,472(sp)
    80005530:	6b5e                	ld	s6,464(sp)
    80005532:	6bbe                	ld	s7,456(sp)
    80005534:	6c1e                	ld	s8,448(sp)
    80005536:	7cfa                	ld	s9,440(sp)
    80005538:	7d5a                	ld	s10,432(sp)
    8000553a:	b305                	j	8000525a <exec+0x8a>
    8000553c:	e1243423          	sd	s2,-504(s0)
    80005540:	7dba                	ld	s11,424(sp)
    80005542:	a035                	j	8000556e <exec+0x39e>
    80005544:	e1243423          	sd	s2,-504(s0)
    80005548:	7dba                	ld	s11,424(sp)
    8000554a:	a015                	j	8000556e <exec+0x39e>
    8000554c:	e1243423          	sd	s2,-504(s0)
    80005550:	7dba                	ld	s11,424(sp)
    80005552:	a831                	j	8000556e <exec+0x39e>
    80005554:	e1243423          	sd	s2,-504(s0)
    80005558:	7dba                	ld	s11,424(sp)
    8000555a:	a811                	j	8000556e <exec+0x39e>
    8000555c:	e1243423          	sd	s2,-504(s0)
    80005560:	7dba                	ld	s11,424(sp)
    80005562:	a031                	j	8000556e <exec+0x39e>
  ip = 0;
    80005564:	4a01                	li	s4,0
    80005566:	a021                	j	8000556e <exec+0x39e>
    80005568:	4a01                	li	s4,0
  if(pagetable)
    8000556a:	a011                	j	8000556e <exec+0x39e>
    8000556c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000556e:	e0843583          	ld	a1,-504(s0)
    80005572:	855a                	mv	a0,s6
    80005574:	ffffd097          	auipc	ra,0xffffd
    80005578:	880080e7          	jalr	-1920(ra) # 80001df4 <proc_freepagetable>
  return -1;
    8000557c:	557d                	li	a0,-1
  if(ip){
    8000557e:	000a1b63          	bnez	s4,80005594 <exec+0x3c4>
    80005582:	79be                	ld	s3,488(sp)
    80005584:	7a1e                	ld	s4,480(sp)
    80005586:	6afe                	ld	s5,472(sp)
    80005588:	6b5e                	ld	s6,464(sp)
    8000558a:	6bbe                	ld	s7,456(sp)
    8000558c:	6c1e                	ld	s8,448(sp)
    8000558e:	7cfa                	ld	s9,440(sp)
    80005590:	7d5a                	ld	s10,432(sp)
    80005592:	b1e1                	j	8000525a <exec+0x8a>
    80005594:	79be                	ld	s3,488(sp)
    80005596:	6afe                	ld	s5,472(sp)
    80005598:	6b5e                	ld	s6,464(sp)
    8000559a:	6bbe                	ld	s7,456(sp)
    8000559c:	6c1e                	ld	s8,448(sp)
    8000559e:	7cfa                	ld	s9,440(sp)
    800055a0:	7d5a                	ld	s10,432(sp)
    800055a2:	b14d                	j	80005244 <exec+0x74>
    800055a4:	6b5e                	ld	s6,464(sp)
    800055a6:	b979                	j	80005244 <exec+0x74>
  sz = sz1;
    800055a8:	e0843983          	ld	s3,-504(s0)
    800055ac:	b591                	j	800053f0 <exec+0x220>

00000000800055ae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800055ae:	7179                	addi	sp,sp,-48
    800055b0:	f406                	sd	ra,40(sp)
    800055b2:	f022                	sd	s0,32(sp)
    800055b4:	ec26                	sd	s1,24(sp)
    800055b6:	e84a                	sd	s2,16(sp)
    800055b8:	1800                	addi	s0,sp,48
    800055ba:	892e                	mv	s2,a1
    800055bc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800055be:	fdc40593          	addi	a1,s0,-36
    800055c2:	ffffe097          	auipc	ra,0xffffe
    800055c6:	a6a080e7          	jalr	-1430(ra) # 8000302c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800055ca:	fdc42703          	lw	a4,-36(s0)
    800055ce:	47bd                	li	a5,15
    800055d0:	02e7eb63          	bltu	a5,a4,80005606 <argfd+0x58>
    800055d4:	ffffc097          	auipc	ra,0xffffc
    800055d8:	6c0080e7          	jalr	1728(ra) # 80001c94 <myproc>
    800055dc:	fdc42703          	lw	a4,-36(s0)
    800055e0:	01a70793          	addi	a5,a4,26
    800055e4:	078e                	slli	a5,a5,0x3
    800055e6:	953e                	add	a0,a0,a5
    800055e8:	611c                	ld	a5,0(a0)
    800055ea:	c385                	beqz	a5,8000560a <argfd+0x5c>
    return -1;
  if(pfd)
    800055ec:	00090463          	beqz	s2,800055f4 <argfd+0x46>
    *pfd = fd;
    800055f0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055f4:	4501                	li	a0,0
  if(pf)
    800055f6:	c091                	beqz	s1,800055fa <argfd+0x4c>
    *pf = f;
    800055f8:	e09c                	sd	a5,0(s1)
}
    800055fa:	70a2                	ld	ra,40(sp)
    800055fc:	7402                	ld	s0,32(sp)
    800055fe:	64e2                	ld	s1,24(sp)
    80005600:	6942                	ld	s2,16(sp)
    80005602:	6145                	addi	sp,sp,48
    80005604:	8082                	ret
    return -1;
    80005606:	557d                	li	a0,-1
    80005608:	bfcd                	j	800055fa <argfd+0x4c>
    8000560a:	557d                	li	a0,-1
    8000560c:	b7fd                	j	800055fa <argfd+0x4c>

000000008000560e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000560e:	1101                	addi	sp,sp,-32
    80005610:	ec06                	sd	ra,24(sp)
    80005612:	e822                	sd	s0,16(sp)
    80005614:	e426                	sd	s1,8(sp)
    80005616:	1000                	addi	s0,sp,32
    80005618:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000561a:	ffffc097          	auipc	ra,0xffffc
    8000561e:	67a080e7          	jalr	1658(ra) # 80001c94 <myproc>
    80005622:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005624:	0d050793          	addi	a5,a0,208
    80005628:	4501                	li	a0,0
    8000562a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000562c:	6398                	ld	a4,0(a5)
    8000562e:	cb19                	beqz	a4,80005644 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005630:	2505                	addiw	a0,a0,1
    80005632:	07a1                	addi	a5,a5,8
    80005634:	fed51ce3          	bne	a0,a3,8000562c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005638:	557d                	li	a0,-1
}
    8000563a:	60e2                	ld	ra,24(sp)
    8000563c:	6442                	ld	s0,16(sp)
    8000563e:	64a2                	ld	s1,8(sp)
    80005640:	6105                	addi	sp,sp,32
    80005642:	8082                	ret
      p->ofile[fd] = f;
    80005644:	01a50793          	addi	a5,a0,26
    80005648:	078e                	slli	a5,a5,0x3
    8000564a:	963e                	add	a2,a2,a5
    8000564c:	e204                	sd	s1,0(a2)
      return fd;
    8000564e:	b7f5                	j	8000563a <fdalloc+0x2c>

0000000080005650 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005650:	715d                	addi	sp,sp,-80
    80005652:	e486                	sd	ra,72(sp)
    80005654:	e0a2                	sd	s0,64(sp)
    80005656:	fc26                	sd	s1,56(sp)
    80005658:	f84a                	sd	s2,48(sp)
    8000565a:	f44e                	sd	s3,40(sp)
    8000565c:	ec56                	sd	s5,24(sp)
    8000565e:	e85a                	sd	s6,16(sp)
    80005660:	0880                	addi	s0,sp,80
    80005662:	8b2e                	mv	s6,a1
    80005664:	89b2                	mv	s3,a2
    80005666:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005668:	fb040593          	addi	a1,s0,-80
    8000566c:	fffff097          	auipc	ra,0xfffff
    80005670:	de2080e7          	jalr	-542(ra) # 8000444e <nameiparent>
    80005674:	84aa                	mv	s1,a0
    80005676:	14050e63          	beqz	a0,800057d2 <create+0x182>
    return 0;

  ilock(dp);
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	5e8080e7          	jalr	1512(ra) # 80003c62 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005682:	4601                	li	a2,0
    80005684:	fb040593          	addi	a1,s0,-80
    80005688:	8526                	mv	a0,s1
    8000568a:	fffff097          	auipc	ra,0xfffff
    8000568e:	ae4080e7          	jalr	-1308(ra) # 8000416e <dirlookup>
    80005692:	8aaa                	mv	s5,a0
    80005694:	c539                	beqz	a0,800056e2 <create+0x92>
    iunlockput(dp);
    80005696:	8526                	mv	a0,s1
    80005698:	fffff097          	auipc	ra,0xfffff
    8000569c:	830080e7          	jalr	-2000(ra) # 80003ec8 <iunlockput>
    ilock(ip);
    800056a0:	8556                	mv	a0,s5
    800056a2:	ffffe097          	auipc	ra,0xffffe
    800056a6:	5c0080e7          	jalr	1472(ra) # 80003c62 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800056aa:	4789                	li	a5,2
    800056ac:	02fb1463          	bne	s6,a5,800056d4 <create+0x84>
    800056b0:	044ad783          	lhu	a5,68(s5)
    800056b4:	37f9                	addiw	a5,a5,-2
    800056b6:	17c2                	slli	a5,a5,0x30
    800056b8:	93c1                	srli	a5,a5,0x30
    800056ba:	4705                	li	a4,1
    800056bc:	00f76c63          	bltu	a4,a5,800056d4 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800056c0:	8556                	mv	a0,s5
    800056c2:	60a6                	ld	ra,72(sp)
    800056c4:	6406                	ld	s0,64(sp)
    800056c6:	74e2                	ld	s1,56(sp)
    800056c8:	7942                	ld	s2,48(sp)
    800056ca:	79a2                	ld	s3,40(sp)
    800056cc:	6ae2                	ld	s5,24(sp)
    800056ce:	6b42                	ld	s6,16(sp)
    800056d0:	6161                	addi	sp,sp,80
    800056d2:	8082                	ret
    iunlockput(ip);
    800056d4:	8556                	mv	a0,s5
    800056d6:	ffffe097          	auipc	ra,0xffffe
    800056da:	7f2080e7          	jalr	2034(ra) # 80003ec8 <iunlockput>
    return 0;
    800056de:	4a81                	li	s5,0
    800056e0:	b7c5                	j	800056c0 <create+0x70>
    800056e2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800056e4:	85da                	mv	a1,s6
    800056e6:	4088                	lw	a0,0(s1)
    800056e8:	ffffe097          	auipc	ra,0xffffe
    800056ec:	3d6080e7          	jalr	982(ra) # 80003abe <ialloc>
    800056f0:	8a2a                	mv	s4,a0
    800056f2:	c531                	beqz	a0,8000573e <create+0xee>
  ilock(ip);
    800056f4:	ffffe097          	auipc	ra,0xffffe
    800056f8:	56e080e7          	jalr	1390(ra) # 80003c62 <ilock>
  ip->major = major;
    800056fc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005700:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005704:	4905                	li	s2,1
    80005706:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000570a:	8552                	mv	a0,s4
    8000570c:	ffffe097          	auipc	ra,0xffffe
    80005710:	48a080e7          	jalr	1162(ra) # 80003b96 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005714:	032b0d63          	beq	s6,s2,8000574e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005718:	004a2603          	lw	a2,4(s4)
    8000571c:	fb040593          	addi	a1,s0,-80
    80005720:	8526                	mv	a0,s1
    80005722:	fffff097          	auipc	ra,0xfffff
    80005726:	c5c080e7          	jalr	-932(ra) # 8000437e <dirlink>
    8000572a:	08054163          	bltz	a0,800057ac <create+0x15c>
  iunlockput(dp);
    8000572e:	8526                	mv	a0,s1
    80005730:	ffffe097          	auipc	ra,0xffffe
    80005734:	798080e7          	jalr	1944(ra) # 80003ec8 <iunlockput>
  return ip;
    80005738:	8ad2                	mv	s5,s4
    8000573a:	7a02                	ld	s4,32(sp)
    8000573c:	b751                	j	800056c0 <create+0x70>
    iunlockput(dp);
    8000573e:	8526                	mv	a0,s1
    80005740:	ffffe097          	auipc	ra,0xffffe
    80005744:	788080e7          	jalr	1928(ra) # 80003ec8 <iunlockput>
    return 0;
    80005748:	8ad2                	mv	s5,s4
    8000574a:	7a02                	ld	s4,32(sp)
    8000574c:	bf95                	j	800056c0 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000574e:	004a2603          	lw	a2,4(s4)
    80005752:	00003597          	auipc	a1,0x3
    80005756:	f6e58593          	addi	a1,a1,-146 # 800086c0 <etext+0x6c0>
    8000575a:	8552                	mv	a0,s4
    8000575c:	fffff097          	auipc	ra,0xfffff
    80005760:	c22080e7          	jalr	-990(ra) # 8000437e <dirlink>
    80005764:	04054463          	bltz	a0,800057ac <create+0x15c>
    80005768:	40d0                	lw	a2,4(s1)
    8000576a:	00003597          	auipc	a1,0x3
    8000576e:	f5e58593          	addi	a1,a1,-162 # 800086c8 <etext+0x6c8>
    80005772:	8552                	mv	a0,s4
    80005774:	fffff097          	auipc	ra,0xfffff
    80005778:	c0a080e7          	jalr	-1014(ra) # 8000437e <dirlink>
    8000577c:	02054863          	bltz	a0,800057ac <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005780:	004a2603          	lw	a2,4(s4)
    80005784:	fb040593          	addi	a1,s0,-80
    80005788:	8526                	mv	a0,s1
    8000578a:	fffff097          	auipc	ra,0xfffff
    8000578e:	bf4080e7          	jalr	-1036(ra) # 8000437e <dirlink>
    80005792:	00054d63          	bltz	a0,800057ac <create+0x15c>
    dp->nlink++;  // for ".."
    80005796:	04a4d783          	lhu	a5,74(s1)
    8000579a:	2785                	addiw	a5,a5,1
    8000579c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800057a0:	8526                	mv	a0,s1
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	3f4080e7          	jalr	1012(ra) # 80003b96 <iupdate>
    800057aa:	b751                	j	8000572e <create+0xde>
  ip->nlink = 0;
    800057ac:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800057b0:	8552                	mv	a0,s4
    800057b2:	ffffe097          	auipc	ra,0xffffe
    800057b6:	3e4080e7          	jalr	996(ra) # 80003b96 <iupdate>
  iunlockput(ip);
    800057ba:	8552                	mv	a0,s4
    800057bc:	ffffe097          	auipc	ra,0xffffe
    800057c0:	70c080e7          	jalr	1804(ra) # 80003ec8 <iunlockput>
  iunlockput(dp);
    800057c4:	8526                	mv	a0,s1
    800057c6:	ffffe097          	auipc	ra,0xffffe
    800057ca:	702080e7          	jalr	1794(ra) # 80003ec8 <iunlockput>
  return 0;
    800057ce:	7a02                	ld	s4,32(sp)
    800057d0:	bdc5                	j	800056c0 <create+0x70>
    return 0;
    800057d2:	8aaa                	mv	s5,a0
    800057d4:	b5f5                	j	800056c0 <create+0x70>

00000000800057d6 <sys_dup>:
{
    800057d6:	7179                	addi	sp,sp,-48
    800057d8:	f406                	sd	ra,40(sp)
    800057da:	f022                	sd	s0,32(sp)
    800057dc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800057de:	fd840613          	addi	a2,s0,-40
    800057e2:	4581                	li	a1,0
    800057e4:	4501                	li	a0,0
    800057e6:	00000097          	auipc	ra,0x0
    800057ea:	dc8080e7          	jalr	-568(ra) # 800055ae <argfd>
    return -1;
    800057ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800057f0:	02054763          	bltz	a0,8000581e <sys_dup+0x48>
    800057f4:	ec26                	sd	s1,24(sp)
    800057f6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800057f8:	fd843903          	ld	s2,-40(s0)
    800057fc:	854a                	mv	a0,s2
    800057fe:	00000097          	auipc	ra,0x0
    80005802:	e10080e7          	jalr	-496(ra) # 8000560e <fdalloc>
    80005806:	84aa                	mv	s1,a0
    return -1;
    80005808:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000580a:	00054f63          	bltz	a0,80005828 <sys_dup+0x52>
  filedup(f);
    8000580e:	854a                	mv	a0,s2
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	298080e7          	jalr	664(ra) # 80004aa8 <filedup>
  return fd;
    80005818:	87a6                	mv	a5,s1
    8000581a:	64e2                	ld	s1,24(sp)
    8000581c:	6942                	ld	s2,16(sp)
}
    8000581e:	853e                	mv	a0,a5
    80005820:	70a2                	ld	ra,40(sp)
    80005822:	7402                	ld	s0,32(sp)
    80005824:	6145                	addi	sp,sp,48
    80005826:	8082                	ret
    80005828:	64e2                	ld	s1,24(sp)
    8000582a:	6942                	ld	s2,16(sp)
    8000582c:	bfcd                	j	8000581e <sys_dup+0x48>

000000008000582e <sys_read>:
{
    8000582e:	7179                	addi	sp,sp,-48
    80005830:	f406                	sd	ra,40(sp)
    80005832:	f022                	sd	s0,32(sp)
    80005834:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005836:	fd840593          	addi	a1,s0,-40
    8000583a:	4505                	li	a0,1
    8000583c:	ffffe097          	auipc	ra,0xffffe
    80005840:	810080e7          	jalr	-2032(ra) # 8000304c <argaddr>
  argint(2, &n);
    80005844:	fe440593          	addi	a1,s0,-28
    80005848:	4509                	li	a0,2
    8000584a:	ffffd097          	auipc	ra,0xffffd
    8000584e:	7e2080e7          	jalr	2018(ra) # 8000302c <argint>
  if(argfd(0, 0, &f) < 0)
    80005852:	fe840613          	addi	a2,s0,-24
    80005856:	4581                	li	a1,0
    80005858:	4501                	li	a0,0
    8000585a:	00000097          	auipc	ra,0x0
    8000585e:	d54080e7          	jalr	-684(ra) # 800055ae <argfd>
    80005862:	87aa                	mv	a5,a0
    return -1;
    80005864:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005866:	0007cc63          	bltz	a5,8000587e <sys_read+0x50>
  return fileread(f, p, n);
    8000586a:	fe442603          	lw	a2,-28(s0)
    8000586e:	fd843583          	ld	a1,-40(s0)
    80005872:	fe843503          	ld	a0,-24(s0)
    80005876:	fffff097          	auipc	ra,0xfffff
    8000587a:	3d8080e7          	jalr	984(ra) # 80004c4e <fileread>
}
    8000587e:	70a2                	ld	ra,40(sp)
    80005880:	7402                	ld	s0,32(sp)
    80005882:	6145                	addi	sp,sp,48
    80005884:	8082                	ret

0000000080005886 <sys_write>:
{
    80005886:	7179                	addi	sp,sp,-48
    80005888:	f406                	sd	ra,40(sp)
    8000588a:	f022                	sd	s0,32(sp)
    8000588c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000588e:	fd840593          	addi	a1,s0,-40
    80005892:	4505                	li	a0,1
    80005894:	ffffd097          	auipc	ra,0xffffd
    80005898:	7b8080e7          	jalr	1976(ra) # 8000304c <argaddr>
  argint(2, &n);
    8000589c:	fe440593          	addi	a1,s0,-28
    800058a0:	4509                	li	a0,2
    800058a2:	ffffd097          	auipc	ra,0xffffd
    800058a6:	78a080e7          	jalr	1930(ra) # 8000302c <argint>
  if(argfd(0, 0, &f) < 0)
    800058aa:	fe840613          	addi	a2,s0,-24
    800058ae:	4581                	li	a1,0
    800058b0:	4501                	li	a0,0
    800058b2:	00000097          	auipc	ra,0x0
    800058b6:	cfc080e7          	jalr	-772(ra) # 800055ae <argfd>
    800058ba:	87aa                	mv	a5,a0
    return -1;
    800058bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058be:	0007cc63          	bltz	a5,800058d6 <sys_write+0x50>
  return filewrite(f, p, n);
    800058c2:	fe442603          	lw	a2,-28(s0)
    800058c6:	fd843583          	ld	a1,-40(s0)
    800058ca:	fe843503          	ld	a0,-24(s0)
    800058ce:	fffff097          	auipc	ra,0xfffff
    800058d2:	452080e7          	jalr	1106(ra) # 80004d20 <filewrite>
}
    800058d6:	70a2                	ld	ra,40(sp)
    800058d8:	7402                	ld	s0,32(sp)
    800058da:	6145                	addi	sp,sp,48
    800058dc:	8082                	ret

00000000800058de <sys_close>:
{
    800058de:	1101                	addi	sp,sp,-32
    800058e0:	ec06                	sd	ra,24(sp)
    800058e2:	e822                	sd	s0,16(sp)
    800058e4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800058e6:	fe040613          	addi	a2,s0,-32
    800058ea:	fec40593          	addi	a1,s0,-20
    800058ee:	4501                	li	a0,0
    800058f0:	00000097          	auipc	ra,0x0
    800058f4:	cbe080e7          	jalr	-834(ra) # 800055ae <argfd>
    return -1;
    800058f8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800058fa:	02054463          	bltz	a0,80005922 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800058fe:	ffffc097          	auipc	ra,0xffffc
    80005902:	396080e7          	jalr	918(ra) # 80001c94 <myproc>
    80005906:	fec42783          	lw	a5,-20(s0)
    8000590a:	07e9                	addi	a5,a5,26
    8000590c:	078e                	slli	a5,a5,0x3
    8000590e:	953e                	add	a0,a0,a5
    80005910:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005914:	fe043503          	ld	a0,-32(s0)
    80005918:	fffff097          	auipc	ra,0xfffff
    8000591c:	1e2080e7          	jalr	482(ra) # 80004afa <fileclose>
  return 0;
    80005920:	4781                	li	a5,0
}
    80005922:	853e                	mv	a0,a5
    80005924:	60e2                	ld	ra,24(sp)
    80005926:	6442                	ld	s0,16(sp)
    80005928:	6105                	addi	sp,sp,32
    8000592a:	8082                	ret

000000008000592c <sys_fstat>:
{
    8000592c:	1101                	addi	sp,sp,-32
    8000592e:	ec06                	sd	ra,24(sp)
    80005930:	e822                	sd	s0,16(sp)
    80005932:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005934:	fe040593          	addi	a1,s0,-32
    80005938:	4505                	li	a0,1
    8000593a:	ffffd097          	auipc	ra,0xffffd
    8000593e:	712080e7          	jalr	1810(ra) # 8000304c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005942:	fe840613          	addi	a2,s0,-24
    80005946:	4581                	li	a1,0
    80005948:	4501                	li	a0,0
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	c64080e7          	jalr	-924(ra) # 800055ae <argfd>
    80005952:	87aa                	mv	a5,a0
    return -1;
    80005954:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005956:	0007ca63          	bltz	a5,8000596a <sys_fstat+0x3e>
  return filestat(f, st);
    8000595a:	fe043583          	ld	a1,-32(s0)
    8000595e:	fe843503          	ld	a0,-24(s0)
    80005962:	fffff097          	auipc	ra,0xfffff
    80005966:	27a080e7          	jalr	634(ra) # 80004bdc <filestat>
}
    8000596a:	60e2                	ld	ra,24(sp)
    8000596c:	6442                	ld	s0,16(sp)
    8000596e:	6105                	addi	sp,sp,32
    80005970:	8082                	ret

0000000080005972 <sys_link>:
{
    80005972:	7169                	addi	sp,sp,-304
    80005974:	f606                	sd	ra,296(sp)
    80005976:	f222                	sd	s0,288(sp)
    80005978:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000597a:	08000613          	li	a2,128
    8000597e:	ed040593          	addi	a1,s0,-304
    80005982:	4501                	li	a0,0
    80005984:	ffffd097          	auipc	ra,0xffffd
    80005988:	6e8080e7          	jalr	1768(ra) # 8000306c <argstr>
    return -1;
    8000598c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000598e:	12054663          	bltz	a0,80005aba <sys_link+0x148>
    80005992:	08000613          	li	a2,128
    80005996:	f5040593          	addi	a1,s0,-176
    8000599a:	4505                	li	a0,1
    8000599c:	ffffd097          	auipc	ra,0xffffd
    800059a0:	6d0080e7          	jalr	1744(ra) # 8000306c <argstr>
    return -1;
    800059a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059a6:	10054a63          	bltz	a0,80005aba <sys_link+0x148>
    800059aa:	ee26                	sd	s1,280(sp)
  begin_op();
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	c84080e7          	jalr	-892(ra) # 80004630 <begin_op>
  if((ip = namei(old)) == 0){
    800059b4:	ed040513          	addi	a0,s0,-304
    800059b8:	fffff097          	auipc	ra,0xfffff
    800059bc:	a78080e7          	jalr	-1416(ra) # 80004430 <namei>
    800059c0:	84aa                	mv	s1,a0
    800059c2:	c949                	beqz	a0,80005a54 <sys_link+0xe2>
  ilock(ip);
    800059c4:	ffffe097          	auipc	ra,0xffffe
    800059c8:	29e080e7          	jalr	670(ra) # 80003c62 <ilock>
  if(ip->type == T_DIR){
    800059cc:	04449703          	lh	a4,68(s1)
    800059d0:	4785                	li	a5,1
    800059d2:	08f70863          	beq	a4,a5,80005a62 <sys_link+0xf0>
    800059d6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800059d8:	04a4d783          	lhu	a5,74(s1)
    800059dc:	2785                	addiw	a5,a5,1
    800059de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059e2:	8526                	mv	a0,s1
    800059e4:	ffffe097          	auipc	ra,0xffffe
    800059e8:	1b2080e7          	jalr	434(ra) # 80003b96 <iupdate>
  iunlock(ip);
    800059ec:	8526                	mv	a0,s1
    800059ee:	ffffe097          	auipc	ra,0xffffe
    800059f2:	33a080e7          	jalr	826(ra) # 80003d28 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800059f6:	fd040593          	addi	a1,s0,-48
    800059fa:	f5040513          	addi	a0,s0,-176
    800059fe:	fffff097          	auipc	ra,0xfffff
    80005a02:	a50080e7          	jalr	-1456(ra) # 8000444e <nameiparent>
    80005a06:	892a                	mv	s2,a0
    80005a08:	cd35                	beqz	a0,80005a84 <sys_link+0x112>
  ilock(dp);
    80005a0a:	ffffe097          	auipc	ra,0xffffe
    80005a0e:	258080e7          	jalr	600(ra) # 80003c62 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a12:	00092703          	lw	a4,0(s2)
    80005a16:	409c                	lw	a5,0(s1)
    80005a18:	06f71163          	bne	a4,a5,80005a7a <sys_link+0x108>
    80005a1c:	40d0                	lw	a2,4(s1)
    80005a1e:	fd040593          	addi	a1,s0,-48
    80005a22:	854a                	mv	a0,s2
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	95a080e7          	jalr	-1702(ra) # 8000437e <dirlink>
    80005a2c:	04054763          	bltz	a0,80005a7a <sys_link+0x108>
  iunlockput(dp);
    80005a30:	854a                	mv	a0,s2
    80005a32:	ffffe097          	auipc	ra,0xffffe
    80005a36:	496080e7          	jalr	1174(ra) # 80003ec8 <iunlockput>
  iput(ip);
    80005a3a:	8526                	mv	a0,s1
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	3e4080e7          	jalr	996(ra) # 80003e20 <iput>
  end_op();
    80005a44:	fffff097          	auipc	ra,0xfffff
    80005a48:	c66080e7          	jalr	-922(ra) # 800046aa <end_op>
  return 0;
    80005a4c:	4781                	li	a5,0
    80005a4e:	64f2                	ld	s1,280(sp)
    80005a50:	6952                	ld	s2,272(sp)
    80005a52:	a0a5                	j	80005aba <sys_link+0x148>
    end_op();
    80005a54:	fffff097          	auipc	ra,0xfffff
    80005a58:	c56080e7          	jalr	-938(ra) # 800046aa <end_op>
    return -1;
    80005a5c:	57fd                	li	a5,-1
    80005a5e:	64f2                	ld	s1,280(sp)
    80005a60:	a8a9                	j	80005aba <sys_link+0x148>
    iunlockput(ip);
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	464080e7          	jalr	1124(ra) # 80003ec8 <iunlockput>
    end_op();
    80005a6c:	fffff097          	auipc	ra,0xfffff
    80005a70:	c3e080e7          	jalr	-962(ra) # 800046aa <end_op>
    return -1;
    80005a74:	57fd                	li	a5,-1
    80005a76:	64f2                	ld	s1,280(sp)
    80005a78:	a089                	j	80005aba <sys_link+0x148>
    iunlockput(dp);
    80005a7a:	854a                	mv	a0,s2
    80005a7c:	ffffe097          	auipc	ra,0xffffe
    80005a80:	44c080e7          	jalr	1100(ra) # 80003ec8 <iunlockput>
  ilock(ip);
    80005a84:	8526                	mv	a0,s1
    80005a86:	ffffe097          	auipc	ra,0xffffe
    80005a8a:	1dc080e7          	jalr	476(ra) # 80003c62 <ilock>
  ip->nlink--;
    80005a8e:	04a4d783          	lhu	a5,74(s1)
    80005a92:	37fd                	addiw	a5,a5,-1
    80005a94:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a98:	8526                	mv	a0,s1
    80005a9a:	ffffe097          	auipc	ra,0xffffe
    80005a9e:	0fc080e7          	jalr	252(ra) # 80003b96 <iupdate>
  iunlockput(ip);
    80005aa2:	8526                	mv	a0,s1
    80005aa4:	ffffe097          	auipc	ra,0xffffe
    80005aa8:	424080e7          	jalr	1060(ra) # 80003ec8 <iunlockput>
  end_op();
    80005aac:	fffff097          	auipc	ra,0xfffff
    80005ab0:	bfe080e7          	jalr	-1026(ra) # 800046aa <end_op>
  return -1;
    80005ab4:	57fd                	li	a5,-1
    80005ab6:	64f2                	ld	s1,280(sp)
    80005ab8:	6952                	ld	s2,272(sp)
}
    80005aba:	853e                	mv	a0,a5
    80005abc:	70b2                	ld	ra,296(sp)
    80005abe:	7412                	ld	s0,288(sp)
    80005ac0:	6155                	addi	sp,sp,304
    80005ac2:	8082                	ret

0000000080005ac4 <sys_unlink>:
{
    80005ac4:	7151                	addi	sp,sp,-240
    80005ac6:	f586                	sd	ra,232(sp)
    80005ac8:	f1a2                	sd	s0,224(sp)
    80005aca:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005acc:	08000613          	li	a2,128
    80005ad0:	f3040593          	addi	a1,s0,-208
    80005ad4:	4501                	li	a0,0
    80005ad6:	ffffd097          	auipc	ra,0xffffd
    80005ada:	596080e7          	jalr	1430(ra) # 8000306c <argstr>
    80005ade:	1a054a63          	bltz	a0,80005c92 <sys_unlink+0x1ce>
    80005ae2:	eda6                	sd	s1,216(sp)
  begin_op();
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	b4c080e7          	jalr	-1204(ra) # 80004630 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005aec:	fb040593          	addi	a1,s0,-80
    80005af0:	f3040513          	addi	a0,s0,-208
    80005af4:	fffff097          	auipc	ra,0xfffff
    80005af8:	95a080e7          	jalr	-1702(ra) # 8000444e <nameiparent>
    80005afc:	84aa                	mv	s1,a0
    80005afe:	cd71                	beqz	a0,80005bda <sys_unlink+0x116>
  ilock(dp);
    80005b00:	ffffe097          	auipc	ra,0xffffe
    80005b04:	162080e7          	jalr	354(ra) # 80003c62 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005b08:	00003597          	auipc	a1,0x3
    80005b0c:	bb858593          	addi	a1,a1,-1096 # 800086c0 <etext+0x6c0>
    80005b10:	fb040513          	addi	a0,s0,-80
    80005b14:	ffffe097          	auipc	ra,0xffffe
    80005b18:	640080e7          	jalr	1600(ra) # 80004154 <namecmp>
    80005b1c:	14050c63          	beqz	a0,80005c74 <sys_unlink+0x1b0>
    80005b20:	00003597          	auipc	a1,0x3
    80005b24:	ba858593          	addi	a1,a1,-1112 # 800086c8 <etext+0x6c8>
    80005b28:	fb040513          	addi	a0,s0,-80
    80005b2c:	ffffe097          	auipc	ra,0xffffe
    80005b30:	628080e7          	jalr	1576(ra) # 80004154 <namecmp>
    80005b34:	14050063          	beqz	a0,80005c74 <sys_unlink+0x1b0>
    80005b38:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005b3a:	f2c40613          	addi	a2,s0,-212
    80005b3e:	fb040593          	addi	a1,s0,-80
    80005b42:	8526                	mv	a0,s1
    80005b44:	ffffe097          	auipc	ra,0xffffe
    80005b48:	62a080e7          	jalr	1578(ra) # 8000416e <dirlookup>
    80005b4c:	892a                	mv	s2,a0
    80005b4e:	12050263          	beqz	a0,80005c72 <sys_unlink+0x1ae>
  ilock(ip);
    80005b52:	ffffe097          	auipc	ra,0xffffe
    80005b56:	110080e7          	jalr	272(ra) # 80003c62 <ilock>
  if(ip->nlink < 1)
    80005b5a:	04a91783          	lh	a5,74(s2)
    80005b5e:	08f05563          	blez	a5,80005be8 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b62:	04491703          	lh	a4,68(s2)
    80005b66:	4785                	li	a5,1
    80005b68:	08f70963          	beq	a4,a5,80005bfa <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005b6c:	4641                	li	a2,16
    80005b6e:	4581                	li	a1,0
    80005b70:	fc040513          	addi	a0,s0,-64
    80005b74:	ffffb097          	auipc	ra,0xffffb
    80005b78:	1c0080e7          	jalr	448(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b7c:	4741                	li	a4,16
    80005b7e:	f2c42683          	lw	a3,-212(s0)
    80005b82:	fc040613          	addi	a2,s0,-64
    80005b86:	4581                	li	a1,0
    80005b88:	8526                	mv	a0,s1
    80005b8a:	ffffe097          	auipc	ra,0xffffe
    80005b8e:	4a0080e7          	jalr	1184(ra) # 8000402a <writei>
    80005b92:	47c1                	li	a5,16
    80005b94:	0af51b63          	bne	a0,a5,80005c4a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005b98:	04491703          	lh	a4,68(s2)
    80005b9c:	4785                	li	a5,1
    80005b9e:	0af70f63          	beq	a4,a5,80005c5c <sys_unlink+0x198>
  iunlockput(dp);
    80005ba2:	8526                	mv	a0,s1
    80005ba4:	ffffe097          	auipc	ra,0xffffe
    80005ba8:	324080e7          	jalr	804(ra) # 80003ec8 <iunlockput>
  ip->nlink--;
    80005bac:	04a95783          	lhu	a5,74(s2)
    80005bb0:	37fd                	addiw	a5,a5,-1
    80005bb2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005bb6:	854a                	mv	a0,s2
    80005bb8:	ffffe097          	auipc	ra,0xffffe
    80005bbc:	fde080e7          	jalr	-34(ra) # 80003b96 <iupdate>
  iunlockput(ip);
    80005bc0:	854a                	mv	a0,s2
    80005bc2:	ffffe097          	auipc	ra,0xffffe
    80005bc6:	306080e7          	jalr	774(ra) # 80003ec8 <iunlockput>
  end_op();
    80005bca:	fffff097          	auipc	ra,0xfffff
    80005bce:	ae0080e7          	jalr	-1312(ra) # 800046aa <end_op>
  return 0;
    80005bd2:	4501                	li	a0,0
    80005bd4:	64ee                	ld	s1,216(sp)
    80005bd6:	694e                	ld	s2,208(sp)
    80005bd8:	a84d                	j	80005c8a <sys_unlink+0x1c6>
    end_op();
    80005bda:	fffff097          	auipc	ra,0xfffff
    80005bde:	ad0080e7          	jalr	-1328(ra) # 800046aa <end_op>
    return -1;
    80005be2:	557d                	li	a0,-1
    80005be4:	64ee                	ld	s1,216(sp)
    80005be6:	a055                	j	80005c8a <sys_unlink+0x1c6>
    80005be8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005bea:	00003517          	auipc	a0,0x3
    80005bee:	ae650513          	addi	a0,a0,-1306 # 800086d0 <etext+0x6d0>
    80005bf2:	ffffb097          	auipc	ra,0xffffb
    80005bf6:	96e080e7          	jalr	-1682(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bfa:	04c92703          	lw	a4,76(s2)
    80005bfe:	02000793          	li	a5,32
    80005c02:	f6e7f5e3          	bgeu	a5,a4,80005b6c <sys_unlink+0xa8>
    80005c06:	e5ce                	sd	s3,200(sp)
    80005c08:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c0c:	4741                	li	a4,16
    80005c0e:	86ce                	mv	a3,s3
    80005c10:	f1840613          	addi	a2,s0,-232
    80005c14:	4581                	li	a1,0
    80005c16:	854a                	mv	a0,s2
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	302080e7          	jalr	770(ra) # 80003f1a <readi>
    80005c20:	47c1                	li	a5,16
    80005c22:	00f51c63          	bne	a0,a5,80005c3a <sys_unlink+0x176>
    if(de.inum != 0)
    80005c26:	f1845783          	lhu	a5,-232(s0)
    80005c2a:	e7b5                	bnez	a5,80005c96 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005c2c:	29c1                	addiw	s3,s3,16
    80005c2e:	04c92783          	lw	a5,76(s2)
    80005c32:	fcf9ede3          	bltu	s3,a5,80005c0c <sys_unlink+0x148>
    80005c36:	69ae                	ld	s3,200(sp)
    80005c38:	bf15                	j	80005b6c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005c3a:	00003517          	auipc	a0,0x3
    80005c3e:	aae50513          	addi	a0,a0,-1362 # 800086e8 <etext+0x6e8>
    80005c42:	ffffb097          	auipc	ra,0xffffb
    80005c46:	91e080e7          	jalr	-1762(ra) # 80000560 <panic>
    80005c4a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005c4c:	00003517          	auipc	a0,0x3
    80005c50:	ab450513          	addi	a0,a0,-1356 # 80008700 <etext+0x700>
    80005c54:	ffffb097          	auipc	ra,0xffffb
    80005c58:	90c080e7          	jalr	-1780(ra) # 80000560 <panic>
    dp->nlink--;
    80005c5c:	04a4d783          	lhu	a5,74(s1)
    80005c60:	37fd                	addiw	a5,a5,-1
    80005c62:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c66:	8526                	mv	a0,s1
    80005c68:	ffffe097          	auipc	ra,0xffffe
    80005c6c:	f2e080e7          	jalr	-210(ra) # 80003b96 <iupdate>
    80005c70:	bf0d                	j	80005ba2 <sys_unlink+0xde>
    80005c72:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005c74:	8526                	mv	a0,s1
    80005c76:	ffffe097          	auipc	ra,0xffffe
    80005c7a:	252080e7          	jalr	594(ra) # 80003ec8 <iunlockput>
  end_op();
    80005c7e:	fffff097          	auipc	ra,0xfffff
    80005c82:	a2c080e7          	jalr	-1492(ra) # 800046aa <end_op>
  return -1;
    80005c86:	557d                	li	a0,-1
    80005c88:	64ee                	ld	s1,216(sp)
}
    80005c8a:	70ae                	ld	ra,232(sp)
    80005c8c:	740e                	ld	s0,224(sp)
    80005c8e:	616d                	addi	sp,sp,240
    80005c90:	8082                	ret
    return -1;
    80005c92:	557d                	li	a0,-1
    80005c94:	bfdd                	j	80005c8a <sys_unlink+0x1c6>
    iunlockput(ip);
    80005c96:	854a                	mv	a0,s2
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	230080e7          	jalr	560(ra) # 80003ec8 <iunlockput>
    goto bad;
    80005ca0:	694e                	ld	s2,208(sp)
    80005ca2:	69ae                	ld	s3,200(sp)
    80005ca4:	bfc1                	j	80005c74 <sys_unlink+0x1b0>

0000000080005ca6 <sys_open>:

uint64
sys_open(void)
{
    80005ca6:	7131                	addi	sp,sp,-192
    80005ca8:	fd06                	sd	ra,184(sp)
    80005caa:	f922                	sd	s0,176(sp)
    80005cac:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005cae:	f4c40593          	addi	a1,s0,-180
    80005cb2:	4505                	li	a0,1
    80005cb4:	ffffd097          	auipc	ra,0xffffd
    80005cb8:	378080e7          	jalr	888(ra) # 8000302c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005cbc:	08000613          	li	a2,128
    80005cc0:	f5040593          	addi	a1,s0,-176
    80005cc4:	4501                	li	a0,0
    80005cc6:	ffffd097          	auipc	ra,0xffffd
    80005cca:	3a6080e7          	jalr	934(ra) # 8000306c <argstr>
    80005cce:	87aa                	mv	a5,a0
    return -1;
    80005cd0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005cd2:	0a07ce63          	bltz	a5,80005d8e <sys_open+0xe8>
    80005cd6:	f526                	sd	s1,168(sp)

  begin_op();
    80005cd8:	fffff097          	auipc	ra,0xfffff
    80005cdc:	958080e7          	jalr	-1704(ra) # 80004630 <begin_op>

  if(omode & O_CREATE){
    80005ce0:	f4c42783          	lw	a5,-180(s0)
    80005ce4:	2007f793          	andi	a5,a5,512
    80005ce8:	cfd5                	beqz	a5,80005da4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005cea:	4681                	li	a3,0
    80005cec:	4601                	li	a2,0
    80005cee:	4589                	li	a1,2
    80005cf0:	f5040513          	addi	a0,s0,-176
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	95c080e7          	jalr	-1700(ra) # 80005650 <create>
    80005cfc:	84aa                	mv	s1,a0
    if(ip == 0){
    80005cfe:	cd41                	beqz	a0,80005d96 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d00:	04449703          	lh	a4,68(s1)
    80005d04:	478d                	li	a5,3
    80005d06:	00f71763          	bne	a4,a5,80005d14 <sys_open+0x6e>
    80005d0a:	0464d703          	lhu	a4,70(s1)
    80005d0e:	47a5                	li	a5,9
    80005d10:	0ee7e163          	bltu	a5,a4,80005df2 <sys_open+0x14c>
    80005d14:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d16:	fffff097          	auipc	ra,0xfffff
    80005d1a:	d28080e7          	jalr	-728(ra) # 80004a3e <filealloc>
    80005d1e:	892a                	mv	s2,a0
    80005d20:	c97d                	beqz	a0,80005e16 <sys_open+0x170>
    80005d22:	ed4e                	sd	s3,152(sp)
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	8ea080e7          	jalr	-1814(ra) # 8000560e <fdalloc>
    80005d2c:	89aa                	mv	s3,a0
    80005d2e:	0c054e63          	bltz	a0,80005e0a <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005d32:	04449703          	lh	a4,68(s1)
    80005d36:	478d                	li	a5,3
    80005d38:	0ef70c63          	beq	a4,a5,80005e30 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005d3c:	4789                	li	a5,2
    80005d3e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005d42:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005d46:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005d4a:	f4c42783          	lw	a5,-180(s0)
    80005d4e:	0017c713          	xori	a4,a5,1
    80005d52:	8b05                	andi	a4,a4,1
    80005d54:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d58:	0037f713          	andi	a4,a5,3
    80005d5c:	00e03733          	snez	a4,a4
    80005d60:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d64:	4007f793          	andi	a5,a5,1024
    80005d68:	c791                	beqz	a5,80005d74 <sys_open+0xce>
    80005d6a:	04449703          	lh	a4,68(s1)
    80005d6e:	4789                	li	a5,2
    80005d70:	0cf70763          	beq	a4,a5,80005e3e <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005d74:	8526                	mv	a0,s1
    80005d76:	ffffe097          	auipc	ra,0xffffe
    80005d7a:	fb2080e7          	jalr	-78(ra) # 80003d28 <iunlock>
  end_op();
    80005d7e:	fffff097          	auipc	ra,0xfffff
    80005d82:	92c080e7          	jalr	-1748(ra) # 800046aa <end_op>

  return fd;
    80005d86:	854e                	mv	a0,s3
    80005d88:	74aa                	ld	s1,168(sp)
    80005d8a:	790a                	ld	s2,160(sp)
    80005d8c:	69ea                	ld	s3,152(sp)
}
    80005d8e:	70ea                	ld	ra,184(sp)
    80005d90:	744a                	ld	s0,176(sp)
    80005d92:	6129                	addi	sp,sp,192
    80005d94:	8082                	ret
      end_op();
    80005d96:	fffff097          	auipc	ra,0xfffff
    80005d9a:	914080e7          	jalr	-1772(ra) # 800046aa <end_op>
      return -1;
    80005d9e:	557d                	li	a0,-1
    80005da0:	74aa                	ld	s1,168(sp)
    80005da2:	b7f5                	j	80005d8e <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005da4:	f5040513          	addi	a0,s0,-176
    80005da8:	ffffe097          	auipc	ra,0xffffe
    80005dac:	688080e7          	jalr	1672(ra) # 80004430 <namei>
    80005db0:	84aa                	mv	s1,a0
    80005db2:	c90d                	beqz	a0,80005de4 <sys_open+0x13e>
    ilock(ip);
    80005db4:	ffffe097          	auipc	ra,0xffffe
    80005db8:	eae080e7          	jalr	-338(ra) # 80003c62 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005dbc:	04449703          	lh	a4,68(s1)
    80005dc0:	4785                	li	a5,1
    80005dc2:	f2f71fe3          	bne	a4,a5,80005d00 <sys_open+0x5a>
    80005dc6:	f4c42783          	lw	a5,-180(s0)
    80005dca:	d7a9                	beqz	a5,80005d14 <sys_open+0x6e>
      iunlockput(ip);
    80005dcc:	8526                	mv	a0,s1
    80005dce:	ffffe097          	auipc	ra,0xffffe
    80005dd2:	0fa080e7          	jalr	250(ra) # 80003ec8 <iunlockput>
      end_op();
    80005dd6:	fffff097          	auipc	ra,0xfffff
    80005dda:	8d4080e7          	jalr	-1836(ra) # 800046aa <end_op>
      return -1;
    80005dde:	557d                	li	a0,-1
    80005de0:	74aa                	ld	s1,168(sp)
    80005de2:	b775                	j	80005d8e <sys_open+0xe8>
      end_op();
    80005de4:	fffff097          	auipc	ra,0xfffff
    80005de8:	8c6080e7          	jalr	-1850(ra) # 800046aa <end_op>
      return -1;
    80005dec:	557d                	li	a0,-1
    80005dee:	74aa                	ld	s1,168(sp)
    80005df0:	bf79                	j	80005d8e <sys_open+0xe8>
    iunlockput(ip);
    80005df2:	8526                	mv	a0,s1
    80005df4:	ffffe097          	auipc	ra,0xffffe
    80005df8:	0d4080e7          	jalr	212(ra) # 80003ec8 <iunlockput>
    end_op();
    80005dfc:	fffff097          	auipc	ra,0xfffff
    80005e00:	8ae080e7          	jalr	-1874(ra) # 800046aa <end_op>
    return -1;
    80005e04:	557d                	li	a0,-1
    80005e06:	74aa                	ld	s1,168(sp)
    80005e08:	b759                	j	80005d8e <sys_open+0xe8>
      fileclose(f);
    80005e0a:	854a                	mv	a0,s2
    80005e0c:	fffff097          	auipc	ra,0xfffff
    80005e10:	cee080e7          	jalr	-786(ra) # 80004afa <fileclose>
    80005e14:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005e16:	8526                	mv	a0,s1
    80005e18:	ffffe097          	auipc	ra,0xffffe
    80005e1c:	0b0080e7          	jalr	176(ra) # 80003ec8 <iunlockput>
    end_op();
    80005e20:	fffff097          	auipc	ra,0xfffff
    80005e24:	88a080e7          	jalr	-1910(ra) # 800046aa <end_op>
    return -1;
    80005e28:	557d                	li	a0,-1
    80005e2a:	74aa                	ld	s1,168(sp)
    80005e2c:	790a                	ld	s2,160(sp)
    80005e2e:	b785                	j	80005d8e <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005e30:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005e34:	04649783          	lh	a5,70(s1)
    80005e38:	02f91223          	sh	a5,36(s2)
    80005e3c:	b729                	j	80005d46 <sys_open+0xa0>
    itrunc(ip);
    80005e3e:	8526                	mv	a0,s1
    80005e40:	ffffe097          	auipc	ra,0xffffe
    80005e44:	f34080e7          	jalr	-204(ra) # 80003d74 <itrunc>
    80005e48:	b735                	j	80005d74 <sys_open+0xce>

0000000080005e4a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005e4a:	7175                	addi	sp,sp,-144
    80005e4c:	e506                	sd	ra,136(sp)
    80005e4e:	e122                	sd	s0,128(sp)
    80005e50:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e52:	ffffe097          	auipc	ra,0xffffe
    80005e56:	7de080e7          	jalr	2014(ra) # 80004630 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e5a:	08000613          	li	a2,128
    80005e5e:	f7040593          	addi	a1,s0,-144
    80005e62:	4501                	li	a0,0
    80005e64:	ffffd097          	auipc	ra,0xffffd
    80005e68:	208080e7          	jalr	520(ra) # 8000306c <argstr>
    80005e6c:	02054963          	bltz	a0,80005e9e <sys_mkdir+0x54>
    80005e70:	4681                	li	a3,0
    80005e72:	4601                	li	a2,0
    80005e74:	4585                	li	a1,1
    80005e76:	f7040513          	addi	a0,s0,-144
    80005e7a:	fffff097          	auipc	ra,0xfffff
    80005e7e:	7d6080e7          	jalr	2006(ra) # 80005650 <create>
    80005e82:	cd11                	beqz	a0,80005e9e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e84:	ffffe097          	auipc	ra,0xffffe
    80005e88:	044080e7          	jalr	68(ra) # 80003ec8 <iunlockput>
  end_op();
    80005e8c:	fffff097          	auipc	ra,0xfffff
    80005e90:	81e080e7          	jalr	-2018(ra) # 800046aa <end_op>
  return 0;
    80005e94:	4501                	li	a0,0
}
    80005e96:	60aa                	ld	ra,136(sp)
    80005e98:	640a                	ld	s0,128(sp)
    80005e9a:	6149                	addi	sp,sp,144
    80005e9c:	8082                	ret
    end_op();
    80005e9e:	fffff097          	auipc	ra,0xfffff
    80005ea2:	80c080e7          	jalr	-2036(ra) # 800046aa <end_op>
    return -1;
    80005ea6:	557d                	li	a0,-1
    80005ea8:	b7fd                	j	80005e96 <sys_mkdir+0x4c>

0000000080005eaa <sys_mknod>:

uint64
sys_mknod(void)
{
    80005eaa:	7135                	addi	sp,sp,-160
    80005eac:	ed06                	sd	ra,152(sp)
    80005eae:	e922                	sd	s0,144(sp)
    80005eb0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005eb2:	ffffe097          	auipc	ra,0xffffe
    80005eb6:	77e080e7          	jalr	1918(ra) # 80004630 <begin_op>
  argint(1, &major);
    80005eba:	f6c40593          	addi	a1,s0,-148
    80005ebe:	4505                	li	a0,1
    80005ec0:	ffffd097          	auipc	ra,0xffffd
    80005ec4:	16c080e7          	jalr	364(ra) # 8000302c <argint>
  argint(2, &minor);
    80005ec8:	f6840593          	addi	a1,s0,-152
    80005ecc:	4509                	li	a0,2
    80005ece:	ffffd097          	auipc	ra,0xffffd
    80005ed2:	15e080e7          	jalr	350(ra) # 8000302c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005ed6:	08000613          	li	a2,128
    80005eda:	f7040593          	addi	a1,s0,-144
    80005ede:	4501                	li	a0,0
    80005ee0:	ffffd097          	auipc	ra,0xffffd
    80005ee4:	18c080e7          	jalr	396(ra) # 8000306c <argstr>
    80005ee8:	02054b63          	bltz	a0,80005f1e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005eec:	f6841683          	lh	a3,-152(s0)
    80005ef0:	f6c41603          	lh	a2,-148(s0)
    80005ef4:	458d                	li	a1,3
    80005ef6:	f7040513          	addi	a0,s0,-144
    80005efa:	fffff097          	auipc	ra,0xfffff
    80005efe:	756080e7          	jalr	1878(ra) # 80005650 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f02:	cd11                	beqz	a0,80005f1e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f04:	ffffe097          	auipc	ra,0xffffe
    80005f08:	fc4080e7          	jalr	-60(ra) # 80003ec8 <iunlockput>
  end_op();
    80005f0c:	ffffe097          	auipc	ra,0xffffe
    80005f10:	79e080e7          	jalr	1950(ra) # 800046aa <end_op>
  return 0;
    80005f14:	4501                	li	a0,0
}
    80005f16:	60ea                	ld	ra,152(sp)
    80005f18:	644a                	ld	s0,144(sp)
    80005f1a:	610d                	addi	sp,sp,160
    80005f1c:	8082                	ret
    end_op();
    80005f1e:	ffffe097          	auipc	ra,0xffffe
    80005f22:	78c080e7          	jalr	1932(ra) # 800046aa <end_op>
    return -1;
    80005f26:	557d                	li	a0,-1
    80005f28:	b7fd                	j	80005f16 <sys_mknod+0x6c>

0000000080005f2a <sys_chdir>:

uint64
sys_chdir(void)
{
    80005f2a:	7135                	addi	sp,sp,-160
    80005f2c:	ed06                	sd	ra,152(sp)
    80005f2e:	e922                	sd	s0,144(sp)
    80005f30:	e14a                	sd	s2,128(sp)
    80005f32:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f34:	ffffc097          	auipc	ra,0xffffc
    80005f38:	d60080e7          	jalr	-672(ra) # 80001c94 <myproc>
    80005f3c:	892a                	mv	s2,a0
  
  begin_op();
    80005f3e:	ffffe097          	auipc	ra,0xffffe
    80005f42:	6f2080e7          	jalr	1778(ra) # 80004630 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f46:	08000613          	li	a2,128
    80005f4a:	f6040593          	addi	a1,s0,-160
    80005f4e:	4501                	li	a0,0
    80005f50:	ffffd097          	auipc	ra,0xffffd
    80005f54:	11c080e7          	jalr	284(ra) # 8000306c <argstr>
    80005f58:	04054d63          	bltz	a0,80005fb2 <sys_chdir+0x88>
    80005f5c:	e526                	sd	s1,136(sp)
    80005f5e:	f6040513          	addi	a0,s0,-160
    80005f62:	ffffe097          	auipc	ra,0xffffe
    80005f66:	4ce080e7          	jalr	1230(ra) # 80004430 <namei>
    80005f6a:	84aa                	mv	s1,a0
    80005f6c:	c131                	beqz	a0,80005fb0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f6e:	ffffe097          	auipc	ra,0xffffe
    80005f72:	cf4080e7          	jalr	-780(ra) # 80003c62 <ilock>
  if(ip->type != T_DIR){
    80005f76:	04449703          	lh	a4,68(s1)
    80005f7a:	4785                	li	a5,1
    80005f7c:	04f71163          	bne	a4,a5,80005fbe <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f80:	8526                	mv	a0,s1
    80005f82:	ffffe097          	auipc	ra,0xffffe
    80005f86:	da6080e7          	jalr	-602(ra) # 80003d28 <iunlock>
  iput(p->cwd);
    80005f8a:	15093503          	ld	a0,336(s2)
    80005f8e:	ffffe097          	auipc	ra,0xffffe
    80005f92:	e92080e7          	jalr	-366(ra) # 80003e20 <iput>
  end_op();
    80005f96:	ffffe097          	auipc	ra,0xffffe
    80005f9a:	714080e7          	jalr	1812(ra) # 800046aa <end_op>
  p->cwd = ip;
    80005f9e:	14993823          	sd	s1,336(s2)
  return 0;
    80005fa2:	4501                	li	a0,0
    80005fa4:	64aa                	ld	s1,136(sp)
}
    80005fa6:	60ea                	ld	ra,152(sp)
    80005fa8:	644a                	ld	s0,144(sp)
    80005faa:	690a                	ld	s2,128(sp)
    80005fac:	610d                	addi	sp,sp,160
    80005fae:	8082                	ret
    80005fb0:	64aa                	ld	s1,136(sp)
    end_op();
    80005fb2:	ffffe097          	auipc	ra,0xffffe
    80005fb6:	6f8080e7          	jalr	1784(ra) # 800046aa <end_op>
    return -1;
    80005fba:	557d                	li	a0,-1
    80005fbc:	b7ed                	j	80005fa6 <sys_chdir+0x7c>
    iunlockput(ip);
    80005fbe:	8526                	mv	a0,s1
    80005fc0:	ffffe097          	auipc	ra,0xffffe
    80005fc4:	f08080e7          	jalr	-248(ra) # 80003ec8 <iunlockput>
    end_op();
    80005fc8:	ffffe097          	auipc	ra,0xffffe
    80005fcc:	6e2080e7          	jalr	1762(ra) # 800046aa <end_op>
    return -1;
    80005fd0:	557d                	li	a0,-1
    80005fd2:	64aa                	ld	s1,136(sp)
    80005fd4:	bfc9                	j	80005fa6 <sys_chdir+0x7c>

0000000080005fd6 <sys_exec>:

uint64
sys_exec(void)
{
    80005fd6:	7121                	addi	sp,sp,-448
    80005fd8:	ff06                	sd	ra,440(sp)
    80005fda:	fb22                	sd	s0,432(sp)
    80005fdc:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005fde:	e4840593          	addi	a1,s0,-440
    80005fe2:	4505                	li	a0,1
    80005fe4:	ffffd097          	auipc	ra,0xffffd
    80005fe8:	068080e7          	jalr	104(ra) # 8000304c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005fec:	08000613          	li	a2,128
    80005ff0:	f5040593          	addi	a1,s0,-176
    80005ff4:	4501                	li	a0,0
    80005ff6:	ffffd097          	auipc	ra,0xffffd
    80005ffa:	076080e7          	jalr	118(ra) # 8000306c <argstr>
    80005ffe:	87aa                	mv	a5,a0
    return -1;
    80006000:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006002:	0e07c263          	bltz	a5,800060e6 <sys_exec+0x110>
    80006006:	f726                	sd	s1,424(sp)
    80006008:	f34a                	sd	s2,416(sp)
    8000600a:	ef4e                	sd	s3,408(sp)
    8000600c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000600e:	10000613          	li	a2,256
    80006012:	4581                	li	a1,0
    80006014:	e5040513          	addi	a0,s0,-432
    80006018:	ffffb097          	auipc	ra,0xffffb
    8000601c:	d1c080e7          	jalr	-740(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006020:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80006024:	89a6                	mv	s3,s1
    80006026:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006028:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000602c:	00391513          	slli	a0,s2,0x3
    80006030:	e4040593          	addi	a1,s0,-448
    80006034:	e4843783          	ld	a5,-440(s0)
    80006038:	953e                	add	a0,a0,a5
    8000603a:	ffffd097          	auipc	ra,0xffffd
    8000603e:	f54080e7          	jalr	-172(ra) # 80002f8e <fetchaddr>
    80006042:	02054a63          	bltz	a0,80006076 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80006046:	e4043783          	ld	a5,-448(s0)
    8000604a:	c7b9                	beqz	a5,80006098 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000604c:	ffffb097          	auipc	ra,0xffffb
    80006050:	afc080e7          	jalr	-1284(ra) # 80000b48 <kalloc>
    80006054:	85aa                	mv	a1,a0
    80006056:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000605a:	cd11                	beqz	a0,80006076 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000605c:	6605                	lui	a2,0x1
    8000605e:	e4043503          	ld	a0,-448(s0)
    80006062:	ffffd097          	auipc	ra,0xffffd
    80006066:	f7e080e7          	jalr	-130(ra) # 80002fe0 <fetchstr>
    8000606a:	00054663          	bltz	a0,80006076 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000606e:	0905                	addi	s2,s2,1
    80006070:	09a1                	addi	s3,s3,8
    80006072:	fb491de3          	bne	s2,s4,8000602c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006076:	f5040913          	addi	s2,s0,-176
    8000607a:	6088                	ld	a0,0(s1)
    8000607c:	c125                	beqz	a0,800060dc <sys_exec+0x106>
    kfree(argv[i]);
    8000607e:	ffffb097          	auipc	ra,0xffffb
    80006082:	9cc080e7          	jalr	-1588(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006086:	04a1                	addi	s1,s1,8
    80006088:	ff2499e3          	bne	s1,s2,8000607a <sys_exec+0xa4>
  return -1;
    8000608c:	557d                	li	a0,-1
    8000608e:	74ba                	ld	s1,424(sp)
    80006090:	791a                	ld	s2,416(sp)
    80006092:	69fa                	ld	s3,408(sp)
    80006094:	6a5a                	ld	s4,400(sp)
    80006096:	a881                	j	800060e6 <sys_exec+0x110>
      argv[i] = 0;
    80006098:	0009079b          	sext.w	a5,s2
    8000609c:	078e                	slli	a5,a5,0x3
    8000609e:	fd078793          	addi	a5,a5,-48
    800060a2:	97a2                	add	a5,a5,s0
    800060a4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800060a8:	e5040593          	addi	a1,s0,-432
    800060ac:	f5040513          	addi	a0,s0,-176
    800060b0:	fffff097          	auipc	ra,0xfffff
    800060b4:	120080e7          	jalr	288(ra) # 800051d0 <exec>
    800060b8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060ba:	f5040993          	addi	s3,s0,-176
    800060be:	6088                	ld	a0,0(s1)
    800060c0:	c901                	beqz	a0,800060d0 <sys_exec+0xfa>
    kfree(argv[i]);
    800060c2:	ffffb097          	auipc	ra,0xffffb
    800060c6:	988080e7          	jalr	-1656(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060ca:	04a1                	addi	s1,s1,8
    800060cc:	ff3499e3          	bne	s1,s3,800060be <sys_exec+0xe8>
  return ret;
    800060d0:	854a                	mv	a0,s2
    800060d2:	74ba                	ld	s1,424(sp)
    800060d4:	791a                	ld	s2,416(sp)
    800060d6:	69fa                	ld	s3,408(sp)
    800060d8:	6a5a                	ld	s4,400(sp)
    800060da:	a031                	j	800060e6 <sys_exec+0x110>
  return -1;
    800060dc:	557d                	li	a0,-1
    800060de:	74ba                	ld	s1,424(sp)
    800060e0:	791a                	ld	s2,416(sp)
    800060e2:	69fa                	ld	s3,408(sp)
    800060e4:	6a5a                	ld	s4,400(sp)
}
    800060e6:	70fa                	ld	ra,440(sp)
    800060e8:	745a                	ld	s0,432(sp)
    800060ea:	6139                	addi	sp,sp,448
    800060ec:	8082                	ret

00000000800060ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800060ee:	7139                	addi	sp,sp,-64
    800060f0:	fc06                	sd	ra,56(sp)
    800060f2:	f822                	sd	s0,48(sp)
    800060f4:	f426                	sd	s1,40(sp)
    800060f6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060f8:	ffffc097          	auipc	ra,0xffffc
    800060fc:	b9c080e7          	jalr	-1124(ra) # 80001c94 <myproc>
    80006100:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006102:	fd840593          	addi	a1,s0,-40
    80006106:	4501                	li	a0,0
    80006108:	ffffd097          	auipc	ra,0xffffd
    8000610c:	f44080e7          	jalr	-188(ra) # 8000304c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006110:	fc840593          	addi	a1,s0,-56
    80006114:	fd040513          	addi	a0,s0,-48
    80006118:	fffff097          	auipc	ra,0xfffff
    8000611c:	d50080e7          	jalr	-688(ra) # 80004e68 <pipealloc>
    return -1;
    80006120:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006122:	0c054463          	bltz	a0,800061ea <sys_pipe+0xfc>
  fd0 = -1;
    80006126:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000612a:	fd043503          	ld	a0,-48(s0)
    8000612e:	fffff097          	auipc	ra,0xfffff
    80006132:	4e0080e7          	jalr	1248(ra) # 8000560e <fdalloc>
    80006136:	fca42223          	sw	a0,-60(s0)
    8000613a:	08054b63          	bltz	a0,800061d0 <sys_pipe+0xe2>
    8000613e:	fc843503          	ld	a0,-56(s0)
    80006142:	fffff097          	auipc	ra,0xfffff
    80006146:	4cc080e7          	jalr	1228(ra) # 8000560e <fdalloc>
    8000614a:	fca42023          	sw	a0,-64(s0)
    8000614e:	06054863          	bltz	a0,800061be <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006152:	4691                	li	a3,4
    80006154:	fc440613          	addi	a2,s0,-60
    80006158:	fd843583          	ld	a1,-40(s0)
    8000615c:	68a8                	ld	a0,80(s1)
    8000615e:	ffffb097          	auipc	ra,0xffffb
    80006162:	584080e7          	jalr	1412(ra) # 800016e2 <copyout>
    80006166:	02054063          	bltz	a0,80006186 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000616a:	4691                	li	a3,4
    8000616c:	fc040613          	addi	a2,s0,-64
    80006170:	fd843583          	ld	a1,-40(s0)
    80006174:	0591                	addi	a1,a1,4
    80006176:	68a8                	ld	a0,80(s1)
    80006178:	ffffb097          	auipc	ra,0xffffb
    8000617c:	56a080e7          	jalr	1386(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006180:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006182:	06055463          	bgez	a0,800061ea <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006186:	fc442783          	lw	a5,-60(s0)
    8000618a:	07e9                	addi	a5,a5,26
    8000618c:	078e                	slli	a5,a5,0x3
    8000618e:	97a6                	add	a5,a5,s1
    80006190:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006194:	fc042783          	lw	a5,-64(s0)
    80006198:	07e9                	addi	a5,a5,26
    8000619a:	078e                	slli	a5,a5,0x3
    8000619c:	94be                	add	s1,s1,a5
    8000619e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800061a2:	fd043503          	ld	a0,-48(s0)
    800061a6:	fffff097          	auipc	ra,0xfffff
    800061aa:	954080e7          	jalr	-1708(ra) # 80004afa <fileclose>
    fileclose(wf);
    800061ae:	fc843503          	ld	a0,-56(s0)
    800061b2:	fffff097          	auipc	ra,0xfffff
    800061b6:	948080e7          	jalr	-1720(ra) # 80004afa <fileclose>
    return -1;
    800061ba:	57fd                	li	a5,-1
    800061bc:	a03d                	j	800061ea <sys_pipe+0xfc>
    if(fd0 >= 0)
    800061be:	fc442783          	lw	a5,-60(s0)
    800061c2:	0007c763          	bltz	a5,800061d0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800061c6:	07e9                	addi	a5,a5,26
    800061c8:	078e                	slli	a5,a5,0x3
    800061ca:	97a6                	add	a5,a5,s1
    800061cc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800061d0:	fd043503          	ld	a0,-48(s0)
    800061d4:	fffff097          	auipc	ra,0xfffff
    800061d8:	926080e7          	jalr	-1754(ra) # 80004afa <fileclose>
    fileclose(wf);
    800061dc:	fc843503          	ld	a0,-56(s0)
    800061e0:	fffff097          	auipc	ra,0xfffff
    800061e4:	91a080e7          	jalr	-1766(ra) # 80004afa <fileclose>
    return -1;
    800061e8:	57fd                	li	a5,-1
}
    800061ea:	853e                	mv	a0,a5
    800061ec:	70e2                	ld	ra,56(sp)
    800061ee:	7442                	ld	s0,48(sp)
    800061f0:	74a2                	ld	s1,40(sp)
    800061f2:	6121                	addi	sp,sp,64
    800061f4:	8082                	ret
	...

0000000080006200 <kernelvec>:
    80006200:	7111                	addi	sp,sp,-256
    80006202:	e006                	sd	ra,0(sp)
    80006204:	e40a                	sd	sp,8(sp)
    80006206:	e80e                	sd	gp,16(sp)
    80006208:	ec12                	sd	tp,24(sp)
    8000620a:	f016                	sd	t0,32(sp)
    8000620c:	f41a                	sd	t1,40(sp)
    8000620e:	f81e                	sd	t2,48(sp)
    80006210:	fc22                	sd	s0,56(sp)
    80006212:	e0a6                	sd	s1,64(sp)
    80006214:	e4aa                	sd	a0,72(sp)
    80006216:	e8ae                	sd	a1,80(sp)
    80006218:	ecb2                	sd	a2,88(sp)
    8000621a:	f0b6                	sd	a3,96(sp)
    8000621c:	f4ba                	sd	a4,104(sp)
    8000621e:	f8be                	sd	a5,112(sp)
    80006220:	fcc2                	sd	a6,120(sp)
    80006222:	e146                	sd	a7,128(sp)
    80006224:	e54a                	sd	s2,136(sp)
    80006226:	e94e                	sd	s3,144(sp)
    80006228:	ed52                	sd	s4,152(sp)
    8000622a:	f156                	sd	s5,160(sp)
    8000622c:	f55a                	sd	s6,168(sp)
    8000622e:	f95e                	sd	s7,176(sp)
    80006230:	fd62                	sd	s8,184(sp)
    80006232:	e1e6                	sd	s9,192(sp)
    80006234:	e5ea                	sd	s10,200(sp)
    80006236:	e9ee                	sd	s11,208(sp)
    80006238:	edf2                	sd	t3,216(sp)
    8000623a:	f1f6                	sd	t4,224(sp)
    8000623c:	f5fa                	sd	t5,232(sp)
    8000623e:	f9fe                	sd	t6,240(sp)
    80006240:	c19fc0ef          	jal	80002e58 <kerneltrap>
    80006244:	6082                	ld	ra,0(sp)
    80006246:	6122                	ld	sp,8(sp)
    80006248:	61c2                	ld	gp,16(sp)
    8000624a:	7282                	ld	t0,32(sp)
    8000624c:	7322                	ld	t1,40(sp)
    8000624e:	73c2                	ld	t2,48(sp)
    80006250:	7462                	ld	s0,56(sp)
    80006252:	6486                	ld	s1,64(sp)
    80006254:	6526                	ld	a0,72(sp)
    80006256:	65c6                	ld	a1,80(sp)
    80006258:	6666                	ld	a2,88(sp)
    8000625a:	7686                	ld	a3,96(sp)
    8000625c:	7726                	ld	a4,104(sp)
    8000625e:	77c6                	ld	a5,112(sp)
    80006260:	7866                	ld	a6,120(sp)
    80006262:	688a                	ld	a7,128(sp)
    80006264:	692a                	ld	s2,136(sp)
    80006266:	69ca                	ld	s3,144(sp)
    80006268:	6a6a                	ld	s4,152(sp)
    8000626a:	7a8a                	ld	s5,160(sp)
    8000626c:	7b2a                	ld	s6,168(sp)
    8000626e:	7bca                	ld	s7,176(sp)
    80006270:	7c6a                	ld	s8,184(sp)
    80006272:	6c8e                	ld	s9,192(sp)
    80006274:	6d2e                	ld	s10,200(sp)
    80006276:	6dce                	ld	s11,208(sp)
    80006278:	6e6e                	ld	t3,216(sp)
    8000627a:	7e8e                	ld	t4,224(sp)
    8000627c:	7f2e                	ld	t5,232(sp)
    8000627e:	7fce                	ld	t6,240(sp)
    80006280:	6111                	addi	sp,sp,256
    80006282:	10200073          	sret
    80006286:	00000013          	nop
    8000628a:	00000013          	nop
    8000628e:	0001                	nop

0000000080006290 <timervec>:
    80006290:	34051573          	csrrw	a0,mscratch,a0
    80006294:	e10c                	sd	a1,0(a0)
    80006296:	e510                	sd	a2,8(a0)
    80006298:	e914                	sd	a3,16(a0)
    8000629a:	6d0c                	ld	a1,24(a0)
    8000629c:	7110                	ld	a2,32(a0)
    8000629e:	6194                	ld	a3,0(a1)
    800062a0:	96b2                	add	a3,a3,a2
    800062a2:	e194                	sd	a3,0(a1)
    800062a4:	4589                	li	a1,2
    800062a6:	14459073          	csrw	sip,a1
    800062aa:	6914                	ld	a3,16(a0)
    800062ac:	6510                	ld	a2,8(a0)
    800062ae:	610c                	ld	a1,0(a0)
    800062b0:	34051573          	csrrw	a0,mscratch,a0
    800062b4:	30200073          	mret
	...

00000000800062ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800062ba:	1141                	addi	sp,sp,-16
    800062bc:	e422                	sd	s0,8(sp)
    800062be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800062c0:	0c0007b7          	lui	a5,0xc000
    800062c4:	4705                	li	a4,1
    800062c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800062c8:	0c0007b7          	lui	a5,0xc000
    800062cc:	c3d8                	sw	a4,4(a5)
}
    800062ce:	6422                	ld	s0,8(sp)
    800062d0:	0141                	addi	sp,sp,16
    800062d2:	8082                	ret

00000000800062d4 <plicinithart>:

void
plicinithart(void)
{
    800062d4:	1141                	addi	sp,sp,-16
    800062d6:	e406                	sd	ra,8(sp)
    800062d8:	e022                	sd	s0,0(sp)
    800062da:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800062dc:	ffffc097          	auipc	ra,0xffffc
    800062e0:	98c080e7          	jalr	-1652(ra) # 80001c68 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800062e4:	0085171b          	slliw	a4,a0,0x8
    800062e8:	0c0027b7          	lui	a5,0xc002
    800062ec:	97ba                	add	a5,a5,a4
    800062ee:	40200713          	li	a4,1026
    800062f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800062f6:	00d5151b          	slliw	a0,a0,0xd
    800062fa:	0c2017b7          	lui	a5,0xc201
    800062fe:	97aa                	add	a5,a5,a0
    80006300:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006304:	60a2                	ld	ra,8(sp)
    80006306:	6402                	ld	s0,0(sp)
    80006308:	0141                	addi	sp,sp,16
    8000630a:	8082                	ret

000000008000630c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000630c:	1141                	addi	sp,sp,-16
    8000630e:	e406                	sd	ra,8(sp)
    80006310:	e022                	sd	s0,0(sp)
    80006312:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006314:	ffffc097          	auipc	ra,0xffffc
    80006318:	954080e7          	jalr	-1708(ra) # 80001c68 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000631c:	00d5151b          	slliw	a0,a0,0xd
    80006320:	0c2017b7          	lui	a5,0xc201
    80006324:	97aa                	add	a5,a5,a0
  return irq;
}
    80006326:	43c8                	lw	a0,4(a5)
    80006328:	60a2                	ld	ra,8(sp)
    8000632a:	6402                	ld	s0,0(sp)
    8000632c:	0141                	addi	sp,sp,16
    8000632e:	8082                	ret

0000000080006330 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006330:	1101                	addi	sp,sp,-32
    80006332:	ec06                	sd	ra,24(sp)
    80006334:	e822                	sd	s0,16(sp)
    80006336:	e426                	sd	s1,8(sp)
    80006338:	1000                	addi	s0,sp,32
    8000633a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000633c:	ffffc097          	auipc	ra,0xffffc
    80006340:	92c080e7          	jalr	-1748(ra) # 80001c68 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006344:	00d5151b          	slliw	a0,a0,0xd
    80006348:	0c2017b7          	lui	a5,0xc201
    8000634c:	97aa                	add	a5,a5,a0
    8000634e:	c3c4                	sw	s1,4(a5)
}
    80006350:	60e2                	ld	ra,24(sp)
    80006352:	6442                	ld	s0,16(sp)
    80006354:	64a2                	ld	s1,8(sp)
    80006356:	6105                	addi	sp,sp,32
    80006358:	8082                	ret

000000008000635a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000635a:	1141                	addi	sp,sp,-16
    8000635c:	e406                	sd	ra,8(sp)
    8000635e:	e022                	sd	s0,0(sp)
    80006360:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006362:	479d                	li	a5,7
    80006364:	04a7cc63          	blt	a5,a0,800063bc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006368:	0001e797          	auipc	a5,0x1e
    8000636c:	69878793          	addi	a5,a5,1688 # 80024a00 <disk>
    80006370:	97aa                	add	a5,a5,a0
    80006372:	0187c783          	lbu	a5,24(a5)
    80006376:	ebb9                	bnez	a5,800063cc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006378:	00451693          	slli	a3,a0,0x4
    8000637c:	0001e797          	auipc	a5,0x1e
    80006380:	68478793          	addi	a5,a5,1668 # 80024a00 <disk>
    80006384:	6398                	ld	a4,0(a5)
    80006386:	9736                	add	a4,a4,a3
    80006388:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000638c:	6398                	ld	a4,0(a5)
    8000638e:	9736                	add	a4,a4,a3
    80006390:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006394:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006398:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000639c:	97aa                	add	a5,a5,a0
    8000639e:	4705                	li	a4,1
    800063a0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800063a4:	0001e517          	auipc	a0,0x1e
    800063a8:	67450513          	addi	a0,a0,1652 # 80024a18 <disk+0x18>
    800063ac:	ffffc097          	auipc	ra,0xffffc
    800063b0:	124080e7          	jalr	292(ra) # 800024d0 <wakeup>
}
    800063b4:	60a2                	ld	ra,8(sp)
    800063b6:	6402                	ld	s0,0(sp)
    800063b8:	0141                	addi	sp,sp,16
    800063ba:	8082                	ret
    panic("free_desc 1");
    800063bc:	00002517          	auipc	a0,0x2
    800063c0:	35450513          	addi	a0,a0,852 # 80008710 <etext+0x710>
    800063c4:	ffffa097          	auipc	ra,0xffffa
    800063c8:	19c080e7          	jalr	412(ra) # 80000560 <panic>
    panic("free_desc 2");
    800063cc:	00002517          	auipc	a0,0x2
    800063d0:	35450513          	addi	a0,a0,852 # 80008720 <etext+0x720>
    800063d4:	ffffa097          	auipc	ra,0xffffa
    800063d8:	18c080e7          	jalr	396(ra) # 80000560 <panic>

00000000800063dc <virtio_disk_init>:
{
    800063dc:	1101                	addi	sp,sp,-32
    800063de:	ec06                	sd	ra,24(sp)
    800063e0:	e822                	sd	s0,16(sp)
    800063e2:	e426                	sd	s1,8(sp)
    800063e4:	e04a                	sd	s2,0(sp)
    800063e6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800063e8:	00002597          	auipc	a1,0x2
    800063ec:	34858593          	addi	a1,a1,840 # 80008730 <etext+0x730>
    800063f0:	0001e517          	auipc	a0,0x1e
    800063f4:	73850513          	addi	a0,a0,1848 # 80024b28 <disk+0x128>
    800063f8:	ffffa097          	auipc	ra,0xffffa
    800063fc:	7b0080e7          	jalr	1968(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006400:	100017b7          	lui	a5,0x10001
    80006404:	4398                	lw	a4,0(a5)
    80006406:	2701                	sext.w	a4,a4
    80006408:	747277b7          	lui	a5,0x74727
    8000640c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006410:	18f71c63          	bne	a4,a5,800065a8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006414:	100017b7          	lui	a5,0x10001
    80006418:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000641a:	439c                	lw	a5,0(a5)
    8000641c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000641e:	4709                	li	a4,2
    80006420:	18e79463          	bne	a5,a4,800065a8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006424:	100017b7          	lui	a5,0x10001
    80006428:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000642a:	439c                	lw	a5,0(a5)
    8000642c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000642e:	16e79d63          	bne	a5,a4,800065a8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006432:	100017b7          	lui	a5,0x10001
    80006436:	47d8                	lw	a4,12(a5)
    80006438:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000643a:	554d47b7          	lui	a5,0x554d4
    8000643e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006442:	16f71363          	bne	a4,a5,800065a8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006446:	100017b7          	lui	a5,0x10001
    8000644a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000644e:	4705                	li	a4,1
    80006450:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006452:	470d                	li	a4,3
    80006454:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006456:	10001737          	lui	a4,0x10001
    8000645a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000645c:	c7ffe737          	lui	a4,0xc7ffe
    80006460:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9c1f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006464:	8ef9                	and	a3,a3,a4
    80006466:	10001737          	lui	a4,0x10001
    8000646a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000646c:	472d                	li	a4,11
    8000646e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006470:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006474:	439c                	lw	a5,0(a5)
    80006476:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000647a:	8ba1                	andi	a5,a5,8
    8000647c:	12078e63          	beqz	a5,800065b8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006480:	100017b7          	lui	a5,0x10001
    80006484:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006488:	100017b7          	lui	a5,0x10001
    8000648c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006490:	439c                	lw	a5,0(a5)
    80006492:	2781                	sext.w	a5,a5
    80006494:	12079a63          	bnez	a5,800065c8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006498:	100017b7          	lui	a5,0x10001
    8000649c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800064a0:	439c                	lw	a5,0(a5)
    800064a2:	2781                	sext.w	a5,a5
  if(max == 0)
    800064a4:	12078a63          	beqz	a5,800065d8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800064a8:	471d                	li	a4,7
    800064aa:	12f77f63          	bgeu	a4,a5,800065e8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800064ae:	ffffa097          	auipc	ra,0xffffa
    800064b2:	69a080e7          	jalr	1690(ra) # 80000b48 <kalloc>
    800064b6:	0001e497          	auipc	s1,0x1e
    800064ba:	54a48493          	addi	s1,s1,1354 # 80024a00 <disk>
    800064be:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800064c0:	ffffa097          	auipc	ra,0xffffa
    800064c4:	688080e7          	jalr	1672(ra) # 80000b48 <kalloc>
    800064c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800064ca:	ffffa097          	auipc	ra,0xffffa
    800064ce:	67e080e7          	jalr	1662(ra) # 80000b48 <kalloc>
    800064d2:	87aa                	mv	a5,a0
    800064d4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800064d6:	6088                	ld	a0,0(s1)
    800064d8:	12050063          	beqz	a0,800065f8 <virtio_disk_init+0x21c>
    800064dc:	0001e717          	auipc	a4,0x1e
    800064e0:	52c73703          	ld	a4,1324(a4) # 80024a08 <disk+0x8>
    800064e4:	10070a63          	beqz	a4,800065f8 <virtio_disk_init+0x21c>
    800064e8:	10078863          	beqz	a5,800065f8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800064ec:	6605                	lui	a2,0x1
    800064ee:	4581                	li	a1,0
    800064f0:	ffffb097          	auipc	ra,0xffffb
    800064f4:	844080e7          	jalr	-1980(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    800064f8:	0001e497          	auipc	s1,0x1e
    800064fc:	50848493          	addi	s1,s1,1288 # 80024a00 <disk>
    80006500:	6605                	lui	a2,0x1
    80006502:	4581                	li	a1,0
    80006504:	6488                	ld	a0,8(s1)
    80006506:	ffffb097          	auipc	ra,0xffffb
    8000650a:	82e080e7          	jalr	-2002(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    8000650e:	6605                	lui	a2,0x1
    80006510:	4581                	li	a1,0
    80006512:	6888                	ld	a0,16(s1)
    80006514:	ffffb097          	auipc	ra,0xffffb
    80006518:	820080e7          	jalr	-2016(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000651c:	100017b7          	lui	a5,0x10001
    80006520:	4721                	li	a4,8
    80006522:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006524:	4098                	lw	a4,0(s1)
    80006526:	100017b7          	lui	a5,0x10001
    8000652a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000652e:	40d8                	lw	a4,4(s1)
    80006530:	100017b7          	lui	a5,0x10001
    80006534:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006538:	649c                	ld	a5,8(s1)
    8000653a:	0007869b          	sext.w	a3,a5
    8000653e:	10001737          	lui	a4,0x10001
    80006542:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006546:	9781                	srai	a5,a5,0x20
    80006548:	10001737          	lui	a4,0x10001
    8000654c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006550:	689c                	ld	a5,16(s1)
    80006552:	0007869b          	sext.w	a3,a5
    80006556:	10001737          	lui	a4,0x10001
    8000655a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000655e:	9781                	srai	a5,a5,0x20
    80006560:	10001737          	lui	a4,0x10001
    80006564:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006568:	10001737          	lui	a4,0x10001
    8000656c:	4785                	li	a5,1
    8000656e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006570:	00f48c23          	sb	a5,24(s1)
    80006574:	00f48ca3          	sb	a5,25(s1)
    80006578:	00f48d23          	sb	a5,26(s1)
    8000657c:	00f48da3          	sb	a5,27(s1)
    80006580:	00f48e23          	sb	a5,28(s1)
    80006584:	00f48ea3          	sb	a5,29(s1)
    80006588:	00f48f23          	sb	a5,30(s1)
    8000658c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006590:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006594:	100017b7          	lui	a5,0x10001
    80006598:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000659c:	60e2                	ld	ra,24(sp)
    8000659e:	6442                	ld	s0,16(sp)
    800065a0:	64a2                	ld	s1,8(sp)
    800065a2:	6902                	ld	s2,0(sp)
    800065a4:	6105                	addi	sp,sp,32
    800065a6:	8082                	ret
    panic("could not find virtio disk");
    800065a8:	00002517          	auipc	a0,0x2
    800065ac:	19850513          	addi	a0,a0,408 # 80008740 <etext+0x740>
    800065b0:	ffffa097          	auipc	ra,0xffffa
    800065b4:	fb0080e7          	jalr	-80(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800065b8:	00002517          	auipc	a0,0x2
    800065bc:	1a850513          	addi	a0,a0,424 # 80008760 <etext+0x760>
    800065c0:	ffffa097          	auipc	ra,0xffffa
    800065c4:	fa0080e7          	jalr	-96(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800065c8:	00002517          	auipc	a0,0x2
    800065cc:	1b850513          	addi	a0,a0,440 # 80008780 <etext+0x780>
    800065d0:	ffffa097          	auipc	ra,0xffffa
    800065d4:	f90080e7          	jalr	-112(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800065d8:	00002517          	auipc	a0,0x2
    800065dc:	1c850513          	addi	a0,a0,456 # 800087a0 <etext+0x7a0>
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	f80080e7          	jalr	-128(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800065e8:	00002517          	auipc	a0,0x2
    800065ec:	1d850513          	addi	a0,a0,472 # 800087c0 <etext+0x7c0>
    800065f0:	ffffa097          	auipc	ra,0xffffa
    800065f4:	f70080e7          	jalr	-144(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800065f8:	00002517          	auipc	a0,0x2
    800065fc:	1e850513          	addi	a0,a0,488 # 800087e0 <etext+0x7e0>
    80006600:	ffffa097          	auipc	ra,0xffffa
    80006604:	f60080e7          	jalr	-160(ra) # 80000560 <panic>

0000000080006608 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006608:	7159                	addi	sp,sp,-112
    8000660a:	f486                	sd	ra,104(sp)
    8000660c:	f0a2                	sd	s0,96(sp)
    8000660e:	eca6                	sd	s1,88(sp)
    80006610:	e8ca                	sd	s2,80(sp)
    80006612:	e4ce                	sd	s3,72(sp)
    80006614:	e0d2                	sd	s4,64(sp)
    80006616:	fc56                	sd	s5,56(sp)
    80006618:	f85a                	sd	s6,48(sp)
    8000661a:	f45e                	sd	s7,40(sp)
    8000661c:	f062                	sd	s8,32(sp)
    8000661e:	ec66                	sd	s9,24(sp)
    80006620:	1880                	addi	s0,sp,112
    80006622:	8a2a                	mv	s4,a0
    80006624:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006626:	00c52c83          	lw	s9,12(a0)
    8000662a:	001c9c9b          	slliw	s9,s9,0x1
    8000662e:	1c82                	slli	s9,s9,0x20
    80006630:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006634:	0001e517          	auipc	a0,0x1e
    80006638:	4f450513          	addi	a0,a0,1268 # 80024b28 <disk+0x128>
    8000663c:	ffffa097          	auipc	ra,0xffffa
    80006640:	5fc080e7          	jalr	1532(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    80006644:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006646:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006648:	0001eb17          	auipc	s6,0x1e
    8000664c:	3b8b0b13          	addi	s6,s6,952 # 80024a00 <disk>
  for(int i = 0; i < 3; i++){
    80006650:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006652:	0001ec17          	auipc	s8,0x1e
    80006656:	4d6c0c13          	addi	s8,s8,1238 # 80024b28 <disk+0x128>
    8000665a:	a0ad                	j	800066c4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000665c:	00fb0733          	add	a4,s6,a5
    80006660:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006664:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006666:	0207c563          	bltz	a5,80006690 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000666a:	2905                	addiw	s2,s2,1
    8000666c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000666e:	05590f63          	beq	s2,s5,800066cc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006672:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006674:	0001e717          	auipc	a4,0x1e
    80006678:	38c70713          	addi	a4,a4,908 # 80024a00 <disk>
    8000667c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000667e:	01874683          	lbu	a3,24(a4)
    80006682:	fee9                	bnez	a3,8000665c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006684:	2785                	addiw	a5,a5,1
    80006686:	0705                	addi	a4,a4,1
    80006688:	fe979be3          	bne	a5,s1,8000667e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000668c:	57fd                	li	a5,-1
    8000668e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006690:	03205163          	blez	s2,800066b2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006694:	f9042503          	lw	a0,-112(s0)
    80006698:	00000097          	auipc	ra,0x0
    8000669c:	cc2080e7          	jalr	-830(ra) # 8000635a <free_desc>
      for(int j = 0; j < i; j++)
    800066a0:	4785                	li	a5,1
    800066a2:	0127d863          	bge	a5,s2,800066b2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800066a6:	f9442503          	lw	a0,-108(s0)
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	cb0080e7          	jalr	-848(ra) # 8000635a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800066b2:	85e2                	mv	a1,s8
    800066b4:	0001e517          	auipc	a0,0x1e
    800066b8:	36450513          	addi	a0,a0,868 # 80024a18 <disk+0x18>
    800066bc:	ffffc097          	auipc	ra,0xffffc
    800066c0:	db0080e7          	jalr	-592(ra) # 8000246c <sleep>
  for(int i = 0; i < 3; i++){
    800066c4:	f9040613          	addi	a2,s0,-112
    800066c8:	894e                	mv	s2,s3
    800066ca:	b765                	j	80006672 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800066cc:	f9042503          	lw	a0,-112(s0)
    800066d0:	00451693          	slli	a3,a0,0x4

  if(write)
    800066d4:	0001e797          	auipc	a5,0x1e
    800066d8:	32c78793          	addi	a5,a5,812 # 80024a00 <disk>
    800066dc:	00a50713          	addi	a4,a0,10
    800066e0:	0712                	slli	a4,a4,0x4
    800066e2:	973e                	add	a4,a4,a5
    800066e4:	01703633          	snez	a2,s7
    800066e8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800066ea:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800066ee:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800066f2:	6398                	ld	a4,0(a5)
    800066f4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800066f6:	0a868613          	addi	a2,a3,168
    800066fa:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800066fc:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800066fe:	6390                	ld	a2,0(a5)
    80006700:	00d605b3          	add	a1,a2,a3
    80006704:	4741                	li	a4,16
    80006706:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006708:	4805                	li	a6,1
    8000670a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000670e:	f9442703          	lw	a4,-108(s0)
    80006712:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006716:	0712                	slli	a4,a4,0x4
    80006718:	963a                	add	a2,a2,a4
    8000671a:	058a0593          	addi	a1,s4,88
    8000671e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006720:	0007b883          	ld	a7,0(a5)
    80006724:	9746                	add	a4,a4,a7
    80006726:	40000613          	li	a2,1024
    8000672a:	c710                	sw	a2,8(a4)
  if(write)
    8000672c:	001bb613          	seqz	a2,s7
    80006730:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006734:	00166613          	ori	a2,a2,1
    80006738:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000673c:	f9842583          	lw	a1,-104(s0)
    80006740:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006744:	00250613          	addi	a2,a0,2
    80006748:	0612                	slli	a2,a2,0x4
    8000674a:	963e                	add	a2,a2,a5
    8000674c:	577d                	li	a4,-1
    8000674e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006752:	0592                	slli	a1,a1,0x4
    80006754:	98ae                	add	a7,a7,a1
    80006756:	03068713          	addi	a4,a3,48
    8000675a:	973e                	add	a4,a4,a5
    8000675c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006760:	6398                	ld	a4,0(a5)
    80006762:	972e                	add	a4,a4,a1
    80006764:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006768:	4689                	li	a3,2
    8000676a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000676e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006772:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006776:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000677a:	6794                	ld	a3,8(a5)
    8000677c:	0026d703          	lhu	a4,2(a3)
    80006780:	8b1d                	andi	a4,a4,7
    80006782:	0706                	slli	a4,a4,0x1
    80006784:	96ba                	add	a3,a3,a4
    80006786:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000678a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000678e:	6798                	ld	a4,8(a5)
    80006790:	00275783          	lhu	a5,2(a4)
    80006794:	2785                	addiw	a5,a5,1
    80006796:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000679a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000679e:	100017b7          	lui	a5,0x10001
    800067a2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800067a6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800067aa:	0001e917          	auipc	s2,0x1e
    800067ae:	37e90913          	addi	s2,s2,894 # 80024b28 <disk+0x128>
  while(b->disk == 1) {
    800067b2:	4485                	li	s1,1
    800067b4:	01079c63          	bne	a5,a6,800067cc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800067b8:	85ca                	mv	a1,s2
    800067ba:	8552                	mv	a0,s4
    800067bc:	ffffc097          	auipc	ra,0xffffc
    800067c0:	cb0080e7          	jalr	-848(ra) # 8000246c <sleep>
  while(b->disk == 1) {
    800067c4:	004a2783          	lw	a5,4(s4)
    800067c8:	fe9788e3          	beq	a5,s1,800067b8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800067cc:	f9042903          	lw	s2,-112(s0)
    800067d0:	00290713          	addi	a4,s2,2
    800067d4:	0712                	slli	a4,a4,0x4
    800067d6:	0001e797          	auipc	a5,0x1e
    800067da:	22a78793          	addi	a5,a5,554 # 80024a00 <disk>
    800067de:	97ba                	add	a5,a5,a4
    800067e0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800067e4:	0001e997          	auipc	s3,0x1e
    800067e8:	21c98993          	addi	s3,s3,540 # 80024a00 <disk>
    800067ec:	00491713          	slli	a4,s2,0x4
    800067f0:	0009b783          	ld	a5,0(s3)
    800067f4:	97ba                	add	a5,a5,a4
    800067f6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800067fa:	854a                	mv	a0,s2
    800067fc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006800:	00000097          	auipc	ra,0x0
    80006804:	b5a080e7          	jalr	-1190(ra) # 8000635a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006808:	8885                	andi	s1,s1,1
    8000680a:	f0ed                	bnez	s1,800067ec <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000680c:	0001e517          	auipc	a0,0x1e
    80006810:	31c50513          	addi	a0,a0,796 # 80024b28 <disk+0x128>
    80006814:	ffffa097          	auipc	ra,0xffffa
    80006818:	4d8080e7          	jalr	1240(ra) # 80000cec <release>
}
    8000681c:	70a6                	ld	ra,104(sp)
    8000681e:	7406                	ld	s0,96(sp)
    80006820:	64e6                	ld	s1,88(sp)
    80006822:	6946                	ld	s2,80(sp)
    80006824:	69a6                	ld	s3,72(sp)
    80006826:	6a06                	ld	s4,64(sp)
    80006828:	7ae2                	ld	s5,56(sp)
    8000682a:	7b42                	ld	s6,48(sp)
    8000682c:	7ba2                	ld	s7,40(sp)
    8000682e:	7c02                	ld	s8,32(sp)
    80006830:	6ce2                	ld	s9,24(sp)
    80006832:	6165                	addi	sp,sp,112
    80006834:	8082                	ret

0000000080006836 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006836:	1101                	addi	sp,sp,-32
    80006838:	ec06                	sd	ra,24(sp)
    8000683a:	e822                	sd	s0,16(sp)
    8000683c:	e426                	sd	s1,8(sp)
    8000683e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006840:	0001e497          	auipc	s1,0x1e
    80006844:	1c048493          	addi	s1,s1,448 # 80024a00 <disk>
    80006848:	0001e517          	auipc	a0,0x1e
    8000684c:	2e050513          	addi	a0,a0,736 # 80024b28 <disk+0x128>
    80006850:	ffffa097          	auipc	ra,0xffffa
    80006854:	3e8080e7          	jalr	1000(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006858:	100017b7          	lui	a5,0x10001
    8000685c:	53b8                	lw	a4,96(a5)
    8000685e:	8b0d                	andi	a4,a4,3
    80006860:	100017b7          	lui	a5,0x10001
    80006864:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006866:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000686a:	689c                	ld	a5,16(s1)
    8000686c:	0204d703          	lhu	a4,32(s1)
    80006870:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006874:	04f70863          	beq	a4,a5,800068c4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006878:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000687c:	6898                	ld	a4,16(s1)
    8000687e:	0204d783          	lhu	a5,32(s1)
    80006882:	8b9d                	andi	a5,a5,7
    80006884:	078e                	slli	a5,a5,0x3
    80006886:	97ba                	add	a5,a5,a4
    80006888:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000688a:	00278713          	addi	a4,a5,2
    8000688e:	0712                	slli	a4,a4,0x4
    80006890:	9726                	add	a4,a4,s1
    80006892:	01074703          	lbu	a4,16(a4)
    80006896:	e721                	bnez	a4,800068de <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006898:	0789                	addi	a5,a5,2
    8000689a:	0792                	slli	a5,a5,0x4
    8000689c:	97a6                	add	a5,a5,s1
    8000689e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800068a0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800068a4:	ffffc097          	auipc	ra,0xffffc
    800068a8:	c2c080e7          	jalr	-980(ra) # 800024d0 <wakeup>

    disk.used_idx += 1;
    800068ac:	0204d783          	lhu	a5,32(s1)
    800068b0:	2785                	addiw	a5,a5,1
    800068b2:	17c2                	slli	a5,a5,0x30
    800068b4:	93c1                	srli	a5,a5,0x30
    800068b6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800068ba:	6898                	ld	a4,16(s1)
    800068bc:	00275703          	lhu	a4,2(a4)
    800068c0:	faf71ce3          	bne	a4,a5,80006878 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800068c4:	0001e517          	auipc	a0,0x1e
    800068c8:	26450513          	addi	a0,a0,612 # 80024b28 <disk+0x128>
    800068cc:	ffffa097          	auipc	ra,0xffffa
    800068d0:	420080e7          	jalr	1056(ra) # 80000cec <release>
}
    800068d4:	60e2                	ld	ra,24(sp)
    800068d6:	6442                	ld	s0,16(sp)
    800068d8:	64a2                	ld	s1,8(sp)
    800068da:	6105                	addi	sp,sp,32
    800068dc:	8082                	ret
      panic("virtio_disk_intr status");
    800068de:	00002517          	auipc	a0,0x2
    800068e2:	f1a50513          	addi	a0,a0,-230 # 800087f8 <etext+0x7f8>
    800068e6:	ffffa097          	auipc	ra,0xffffa
    800068ea:	c7a080e7          	jalr	-902(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
