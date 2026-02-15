
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	46013103          	ld	sp,1120(sp) # 8000b460 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000054:	47070713          	addi	a4,a4,1136 # 8000b4c0 <timer_scratch>
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
    80000066:	0ce78793          	addi	a5,a5,206 # 80006130 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9ecf>
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
    8000012e:	642080e7          	jalr	1602(ra) # 8000276c <either_copyin>
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
    80000190:	47450513          	addi	a0,a0,1140 # 80013600 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	46448493          	addi	s1,s1,1124 # 80013600 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	4f490913          	addi	s2,s2,1268 # 80013698 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	97a080e7          	jalr	-1670(ra) # 80001b36 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	3f2080e7          	jalr	1010(ra) # 800025b6 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	13c080e7          	jalr	316(ra) # 8000230e <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	41870713          	addi	a4,a4,1048 # 80013600 <cons>
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
    8000021e:	4fc080e7          	jalr	1276(ra) # 80002716 <either_copyout>
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
    8000023a:	3ca50513          	addi	a0,a0,970 # 80013600 <cons>
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
    80000268:	42f72a23          	sw	a5,1076(a4) # 80013698 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	38650513          	addi	a0,a0,902 # 80013600 <cons>
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
    800002e6:	31e50513          	addi	a0,a0,798 # 80013600 <cons>
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
    8000030c:	4ba080e7          	jalr	1210(ra) # 800027c2 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	2f050513          	addi	a0,a0,752 # 80013600 <cons>
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
    80000336:	2ce70713          	addi	a4,a4,718 # 80013600 <cons>
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
    80000360:	2a478793          	addi	a5,a5,676 # 80013600 <cons>
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
    8000038e:	30e7a783          	lw	a5,782(a5) # 80013698 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	26070713          	addi	a4,a4,608 # 80013600 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	25048493          	addi	s1,s1,592 # 80013600 <cons>
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
    800003fa:	20a70713          	addi	a4,a4,522 # 80013600 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	28f72a23          	sw	a5,660(a4) # 800136a0 <cons+0xa0>
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
    80000436:	1ce78793          	addi	a5,a5,462 # 80013600 <cons>
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
    8000045a:	24c7a323          	sw	a2,582(a5) # 8001369c <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	23a50513          	addi	a0,a0,570 # 80013698 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	f0c080e7          	jalr	-244(ra) # 80002372 <wakeup>
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
    80000484:	18050513          	addi	a0,a0,384 # 80013600 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00023797          	auipc	a5,0x23
    8000049c:	30078793          	addi	a5,a5,768 # 80023798 <devsw>
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
    80000570:	1407aa23          	sw	zero,340(a5) # 800136c0 <pr+0x18>
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
    800005a4:	eef72023          	sw	a5,-288(a4) # 8000b480 <panicked>
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
    800005ce:	0f6d2d03          	lw	s10,246(s10) # 800136c0 <pr+0x18>
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
    8000061e:	08e50513          	addi	a0,a0,142 # 800136a8 <pr>
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
    800007a4:	f0850513          	addi	a0,a0,-248 # 800136a8 <pr>
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
    800007c0:	eec48493          	addi	s1,s1,-276 # 800136a8 <pr>
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
    8000082c:	ea050513          	addi	a0,a0,-352 # 800136c8 <uart_tx_lock>
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
    80000858:	c2c7a783          	lw	a5,-980(a5) # 8000b480 <panicked>
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
    80000892:	bfa7b783          	ld	a5,-1030(a5) # 8000b488 <uart_tx_r>
    80000896:	0000b717          	auipc	a4,0xb
    8000089a:	bfa73703          	ld	a4,-1030(a4) # 8000b490 <uart_tx_w>
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
    800008c0:	e0ca8a93          	addi	s5,s5,-500 # 800136c8 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000b497          	auipc	s1,0xb
    800008c8:	bc448493          	addi	s1,s1,-1084 # 8000b488 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000b997          	auipc	s3,0xb
    800008d4:	bc098993          	addi	s3,s3,-1088 # 8000b490 <uart_tx_w>
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
    800008f6:	a80080e7          	jalr	-1408(ra) # 80002372 <wakeup>
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
    80000934:	d9850513          	addi	a0,a0,-616 # 800136c8 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	300080e7          	jalr	768(ra) # 80000c38 <acquire>
  if(panicked){
    80000940:	0000b797          	auipc	a5,0xb
    80000944:	b407a783          	lw	a5,-1216(a5) # 8000b480 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000b717          	auipc	a4,0xb
    8000094e:	b4673703          	ld	a4,-1210(a4) # 8000b490 <uart_tx_w>
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	b367b783          	ld	a5,-1226(a5) # 8000b488 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00013997          	auipc	s3,0x13
    80000962:	d6a98993          	addi	s3,s3,-662 # 800136c8 <uart_tx_lock>
    80000966:	0000b497          	auipc	s1,0xb
    8000096a:	b2248493          	addi	s1,s1,-1246 # 8000b488 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000b917          	auipc	s2,0xb
    80000972:	b2290913          	addi	s2,s2,-1246 # 8000b490 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	990080e7          	jalr	-1648(ra) # 8000230e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00013497          	auipc	s1,0x13
    80000998:	d3448493          	addi	s1,s1,-716 # 800136c8 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000b797          	auipc	a5,0xb
    800009ac:	aee7b423          	sd	a4,-1304(a5) # 8000b490 <uart_tx_w>
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
    80000a20:	cac48493          	addi	s1,s1,-852 # 800136c8 <uart_tx_lock>
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
    80000a62:	ed278793          	addi	a5,a5,-302 # 80024930 <end>
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
    80000a82:	c8290913          	addi	s2,s2,-894 # 80013700 <kmem>
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
    80000b20:	be450513          	addi	a0,a0,-1052 # 80013700 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00024517          	auipc	a0,0x24
    80000b34:	e0050513          	addi	a0,a0,-512 # 80024930 <end>
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
    80000b56:	bae48493          	addi	s1,s1,-1106 # 80013700 <kmem>
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
    80000b6e:	b9650513          	addi	a0,a0,-1130 # 80013700 <kmem>
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
    80000b9a:	b6a50513          	addi	a0,a0,-1174 # 80013700 <kmem>
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
    80000bd6:	f48080e7          	jalr	-184(ra) # 80001b1a <mycpu>
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
    80000c08:	f16080e7          	jalr	-234(ra) # 80001b1a <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	f0a080e7          	jalr	-246(ra) # 80001b1a <mycpu>
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
    80000c2c:	ef2080e7          	jalr	-270(ra) # 80001b1a <mycpu>
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
    80000c6c:	eb2080e7          	jalr	-334(ra) # 80001b1a <mycpu>
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
    80000c98:	e86080e7          	jalr	-378(ra) # 80001b1a <mycpu>
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
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda6d1>
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
    80000ede:	c30080e7          	jalr	-976(ra) # 80001b0a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ee2:	0000a717          	auipc	a4,0xa
    80000ee6:	5b670713          	addi	a4,a4,1462 # 8000b498 <started>
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
    80000efa:	c14080e7          	jalr	-1004(ra) # 80001b0a <cpuid>
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
    80000f1c:	b32080e7          	jalr	-1230(ra) # 80002a4a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	254080e7          	jalr	596(ra) # 80006174 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	29e080e7          	jalr	670(ra) # 800021c6 <scheduler>
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
    80000f8c:	a9c080e7          	jalr	-1380(ra) # 80001a24 <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	a92080e7          	jalr	-1390(ra) # 80002a22 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	ab2080e7          	jalr	-1358(ra) # 80002a4a <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	1ba080e7          	jalr	442(ra) # 8000615a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	1cc080e7          	jalr	460(ra) # 80006174 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	292080e7          	jalr	658(ra) # 80003242 <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	948080e7          	jalr	-1720(ra) # 80003900 <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	8f8080e7          	jalr	-1800(ra) # 800048b8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	2b4080e7          	jalr	692(ra) # 8000627c <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	e3e080e7          	jalr	-450(ra) # 80001e0e <userinit>
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    started = 1;
    80000fdc:	4785                	li	a5,1
    80000fde:	0000a717          	auipc	a4,0xa
    80000fe2:	4af72d23          	sw	a5,1210(a4) # 8000b498 <started>
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
    80000ff6:	4ae7b783          	ld	a5,1198(a5) # 8000b4a0 <kernel_pagetable>
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
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda6c7>
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
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	6f8080e7          	jalr	1784(ra) # 80001980 <proc_mapstacks>
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
    800012b2:	1ea7b923          	sd	a0,498(a5) # 8000b4a0 <kernel_pagetable>
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
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda6d0>
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
        (*sched_pointer)();
        old_scheduler = sched_pointer;
    }
}

void mlfq_scheduler(void){
    800018b8:	1141                	addi	sp,sp,-16
    800018ba:	e422                	sd	s0,8(sp)
    800018bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018c2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018c6:	10079073          	csrw	sstatus,a5

    //struct proc *p;
    //struct cpu *c = mycpu;

    intr_on();
}
    800018ca:	6422                	ld	s0,8(sp)
    800018cc:	0141                	addi	sp,sp,16
    800018ce:	8082                	ret

00000000800018d0 <rr_scheduler>:


void rr_scheduler(void)
{
    800018d0:	7139                	addi	sp,sp,-64
    800018d2:	fc06                	sd	ra,56(sp)
    800018d4:	f822                	sd	s0,48(sp)
    800018d6:	f426                	sd	s1,40(sp)
    800018d8:	f04a                	sd	s2,32(sp)
    800018da:	ec4e                	sd	s3,24(sp)
    800018dc:	e852                	sd	s4,16(sp)
    800018de:	e456                	sd	s5,8(sp)
    800018e0:	e05a                	sd	s6,0(sp)
    800018e2:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    800018e4:	8792                	mv	a5,tp
    int id = r_tp();
    800018e6:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    800018e8:	00012a97          	auipc	s5,0x12
    800018ec:	e38a8a93          	addi	s5,s5,-456 # 80013720 <cpus>
    800018f0:	00779713          	slli	a4,a5,0x7
    800018f4:	00ea86b3          	add	a3,s5,a4
    800018f8:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffda6d0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018fc:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001900:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001904:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    80001908:	0721                	addi	a4,a4,8
    8000190a:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    8000190c:	00012497          	auipc	s1,0x12
    80001910:	24448493          	addi	s1,s1,580 # 80013b50 <proc>
        if (p->state == RUNNABLE)
    80001914:	498d                	li	s3,3
            p->state = RUNNING;
    80001916:	4b11                	li	s6,4
            c->proc = p;
    80001918:	079e                	slli	a5,a5,0x7
    8000191a:	00012a17          	auipc	s4,0x12
    8000191e:	e06a0a13          	addi	s4,s4,-506 # 80013720 <cpus>
    80001922:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001924:	00018917          	auipc	s2,0x18
    80001928:	c2c90913          	addi	s2,s2,-980 # 80019550 <tickslock>
    8000192c:	a811                	j	80001940 <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    8000192e:	8526                	mv	a0,s1
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	3bc080e7          	jalr	956(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001938:	16848493          	addi	s1,s1,360
    8000193c:	03248863          	beq	s1,s2,8000196c <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001940:	8526                	mv	a0,s1
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	2f6080e7          	jalr	758(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    8000194a:	4c9c                	lw	a5,24(s1)
    8000194c:	ff3791e3          	bne	a5,s3,8000192e <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001950:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001954:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001958:	06048593          	addi	a1,s1,96
    8000195c:	8556                	mv	a0,s5
    8000195e:	00001097          	auipc	ra,0x1
    80001962:	05a080e7          	jalr	90(ra) # 800029b8 <swtch>
            c->proc = 0;
    80001966:	000a3023          	sd	zero,0(s4)
    8000196a:	b7d1                	j	8000192e <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    8000196c:	70e2                	ld	ra,56(sp)
    8000196e:	7442                	ld	s0,48(sp)
    80001970:	74a2                	ld	s1,40(sp)
    80001972:	7902                	ld	s2,32(sp)
    80001974:	69e2                	ld	s3,24(sp)
    80001976:	6a42                	ld	s4,16(sp)
    80001978:	6aa2                	ld	s5,8(sp)
    8000197a:	6b02                	ld	s6,0(sp)
    8000197c:	6121                	addi	sp,sp,64
    8000197e:	8082                	ret

0000000080001980 <proc_mapstacks>:
{
    80001980:	7139                	addi	sp,sp,-64
    80001982:	fc06                	sd	ra,56(sp)
    80001984:	f822                	sd	s0,48(sp)
    80001986:	f426                	sd	s1,40(sp)
    80001988:	f04a                	sd	s2,32(sp)
    8000198a:	ec4e                	sd	s3,24(sp)
    8000198c:	e852                	sd	s4,16(sp)
    8000198e:	e456                	sd	s5,8(sp)
    80001990:	e05a                	sd	s6,0(sp)
    80001992:	0080                	addi	s0,sp,64
    80001994:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001996:	00012497          	auipc	s1,0x12
    8000199a:	1ba48493          	addi	s1,s1,442 # 80013b50 <proc>
        uint64 va = KSTACK((int)(p - proc));
    8000199e:	8b26                	mv	s6,s1
    800019a0:	04fa5937          	lui	s2,0x4fa5
    800019a4:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    800019a8:	0932                	slli	s2,s2,0xc
    800019aa:	fa590913          	addi	s2,s2,-91
    800019ae:	0932                	slli	s2,s2,0xc
    800019b0:	fa590913          	addi	s2,s2,-91
    800019b4:	0932                	slli	s2,s2,0xc
    800019b6:	fa590913          	addi	s2,s2,-91
    800019ba:	040009b7          	lui	s3,0x4000
    800019be:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019c0:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    800019c2:	00018a97          	auipc	s5,0x18
    800019c6:	b8ea8a93          	addi	s5,s5,-1138 # 80019550 <tickslock>
        char *pa = kalloc();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	17e080e7          	jalr	382(ra) # 80000b48 <kalloc>
    800019d2:	862a                	mv	a2,a0
        if (pa == 0)
    800019d4:	c121                	beqz	a0,80001a14 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    800019d6:	416485b3          	sub	a1,s1,s6
    800019da:	858d                	srai	a1,a1,0x3
    800019dc:	032585b3          	mul	a1,a1,s2
    800019e0:	2585                	addiw	a1,a1,1
    800019e2:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019e6:	4719                	li	a4,6
    800019e8:	6685                	lui	a3,0x1
    800019ea:	40b985b3          	sub	a1,s3,a1
    800019ee:	8552                	mv	a0,s4
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	7a8080e7          	jalr	1960(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    800019f8:	16848493          	addi	s1,s1,360
    800019fc:	fd5497e3          	bne	s1,s5,800019ca <proc_mapstacks+0x4a>
}
    80001a00:	70e2                	ld	ra,56(sp)
    80001a02:	7442                	ld	s0,48(sp)
    80001a04:	74a2                	ld	s1,40(sp)
    80001a06:	7902                	ld	s2,32(sp)
    80001a08:	69e2                	ld	s3,24(sp)
    80001a0a:	6a42                	ld	s4,16(sp)
    80001a0c:	6aa2                	ld	s5,8(sp)
    80001a0e:	6b02                	ld	s6,0(sp)
    80001a10:	6121                	addi	sp,sp,64
    80001a12:	8082                	ret
            panic("kalloc");
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	7a450513          	addi	a0,a0,1956 # 800081b8 <etext+0x1b8>
    80001a1c:	fffff097          	auipc	ra,0xfffff
    80001a20:	b44080e7          	jalr	-1212(ra) # 80000560 <panic>

0000000080001a24 <procinit>:
{
    80001a24:	7139                	addi	sp,sp,-64
    80001a26:	fc06                	sd	ra,56(sp)
    80001a28:	f822                	sd	s0,48(sp)
    80001a2a:	f426                	sd	s1,40(sp)
    80001a2c:	f04a                	sd	s2,32(sp)
    80001a2e:	ec4e                	sd	s3,24(sp)
    80001a30:	e852                	sd	s4,16(sp)
    80001a32:	e456                	sd	s5,8(sp)
    80001a34:	e05a                	sd	s6,0(sp)
    80001a36:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001a38:	00006597          	auipc	a1,0x6
    80001a3c:	78858593          	addi	a1,a1,1928 # 800081c0 <etext+0x1c0>
    80001a40:	00012517          	auipc	a0,0x12
    80001a44:	0e050513          	addi	a0,a0,224 # 80013b20 <pid_lock>
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	160080e7          	jalr	352(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001a50:	00006597          	auipc	a1,0x6
    80001a54:	77858593          	addi	a1,a1,1912 # 800081c8 <etext+0x1c8>
    80001a58:	00012517          	auipc	a0,0x12
    80001a5c:	0e050513          	addi	a0,a0,224 # 80013b38 <wait_lock>
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	148080e7          	jalr	328(ra) # 80000ba8 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a68:	00012497          	auipc	s1,0x12
    80001a6c:	0e848493          	addi	s1,s1,232 # 80013b50 <proc>
        initlock(&p->lock, "proc");
    80001a70:	00006b17          	auipc	s6,0x6
    80001a74:	768b0b13          	addi	s6,s6,1896 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001a78:	8aa6                	mv	s5,s1
    80001a7a:	04fa5937          	lui	s2,0x4fa5
    80001a7e:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001a82:	0932                	slli	s2,s2,0xc
    80001a84:	fa590913          	addi	s2,s2,-91
    80001a88:	0932                	slli	s2,s2,0xc
    80001a8a:	fa590913          	addi	s2,s2,-91
    80001a8e:	0932                	slli	s2,s2,0xc
    80001a90:	fa590913          	addi	s2,s2,-91
    80001a94:	040009b7          	lui	s3,0x4000
    80001a98:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a9a:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001a9c:	00018a17          	auipc	s4,0x18
    80001aa0:	ab4a0a13          	addi	s4,s4,-1356 # 80019550 <tickslock>
        initlock(&p->lock, "proc");
    80001aa4:	85da                	mv	a1,s6
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	100080e7          	jalr	256(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80001ab0:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001ab4:	415487b3          	sub	a5,s1,s5
    80001ab8:	878d                	srai	a5,a5,0x3
    80001aba:	032787b3          	mul	a5,a5,s2
    80001abe:	2785                	addiw	a5,a5,1
    80001ac0:	00d7979b          	slliw	a5,a5,0xd
    80001ac4:	40f987b3          	sub	a5,s3,a5
    80001ac8:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001aca:	16848493          	addi	s1,s1,360
    80001ace:	fd449be3          	bne	s1,s4,80001aa4 <procinit+0x80>
}
    80001ad2:	70e2                	ld	ra,56(sp)
    80001ad4:	7442                	ld	s0,48(sp)
    80001ad6:	74a2                	ld	s1,40(sp)
    80001ad8:	7902                	ld	s2,32(sp)
    80001ada:	69e2                	ld	s3,24(sp)
    80001adc:	6a42                	ld	s4,16(sp)
    80001ade:	6aa2                	ld	s5,8(sp)
    80001ae0:	6b02                	ld	s6,0(sp)
    80001ae2:	6121                	addi	sp,sp,64
    80001ae4:	8082                	ret

0000000080001ae6 <copy_array>:
{
    80001ae6:	1141                	addi	sp,sp,-16
    80001ae8:	e422                	sd	s0,8(sp)
    80001aea:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001aec:	00c05c63          	blez	a2,80001b04 <copy_array+0x1e>
    80001af0:	87aa                	mv	a5,a0
    80001af2:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001af4:	0007c703          	lbu	a4,0(a5)
    80001af8:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001afc:	0785                	addi	a5,a5,1
    80001afe:	0585                	addi	a1,a1,1
    80001b00:	fea79ae3          	bne	a5,a0,80001af4 <copy_array+0xe>
}
    80001b04:	6422                	ld	s0,8(sp)
    80001b06:	0141                	addi	sp,sp,16
    80001b08:	8082                	ret

0000000080001b0a <cpuid>:
{
    80001b0a:	1141                	addi	sp,sp,-16
    80001b0c:	e422                	sd	s0,8(sp)
    80001b0e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b10:	8512                	mv	a0,tp
}
    80001b12:	2501                	sext.w	a0,a0
    80001b14:	6422                	ld	s0,8(sp)
    80001b16:	0141                	addi	sp,sp,16
    80001b18:	8082                	ret

0000000080001b1a <mycpu>:
{
    80001b1a:	1141                	addi	sp,sp,-16
    80001b1c:	e422                	sd	s0,8(sp)
    80001b1e:	0800                	addi	s0,sp,16
    80001b20:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001b22:	2781                	sext.w	a5,a5
    80001b24:	079e                	slli	a5,a5,0x7
}
    80001b26:	00012517          	auipc	a0,0x12
    80001b2a:	bfa50513          	addi	a0,a0,-1030 # 80013720 <cpus>
    80001b2e:	953e                	add	a0,a0,a5
    80001b30:	6422                	ld	s0,8(sp)
    80001b32:	0141                	addi	sp,sp,16
    80001b34:	8082                	ret

0000000080001b36 <myproc>:
{
    80001b36:	1101                	addi	sp,sp,-32
    80001b38:	ec06                	sd	ra,24(sp)
    80001b3a:	e822                	sd	s0,16(sp)
    80001b3c:	e426                	sd	s1,8(sp)
    80001b3e:	1000                	addi	s0,sp,32
    push_off();
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	0ac080e7          	jalr	172(ra) # 80000bec <push_off>
    80001b48:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001b4a:	2781                	sext.w	a5,a5
    80001b4c:	079e                	slli	a5,a5,0x7
    80001b4e:	00012717          	auipc	a4,0x12
    80001b52:	bd270713          	addi	a4,a4,-1070 # 80013720 <cpus>
    80001b56:	97ba                	add	a5,a5,a4
    80001b58:	6384                	ld	s1,0(a5)
    pop_off();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	132080e7          	jalr	306(ra) # 80000c8c <pop_off>
}
    80001b62:	8526                	mv	a0,s1
    80001b64:	60e2                	ld	ra,24(sp)
    80001b66:	6442                	ld	s0,16(sp)
    80001b68:	64a2                	ld	s1,8(sp)
    80001b6a:	6105                	addi	sp,sp,32
    80001b6c:	8082                	ret

0000000080001b6e <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001b6e:	1141                	addi	sp,sp,-16
    80001b70:	e406                	sd	ra,8(sp)
    80001b72:	e022                	sd	s0,0(sp)
    80001b74:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001b76:	00000097          	auipc	ra,0x0
    80001b7a:	fc0080e7          	jalr	-64(ra) # 80001b36 <myproc>
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	16e080e7          	jalr	366(ra) # 80000cec <release>

    if (first)
    80001b86:	0000a797          	auipc	a5,0xa
    80001b8a:	83a7a783          	lw	a5,-1990(a5) # 8000b3c0 <first.1>
    80001b8e:	eb89                	bnez	a5,80001ba0 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001b90:	00001097          	auipc	ra,0x1
    80001b94:	ed2080e7          	jalr	-302(ra) # 80002a62 <usertrapret>
}
    80001b98:	60a2                	ld	ra,8(sp)
    80001b9a:	6402                	ld	s0,0(sp)
    80001b9c:	0141                	addi	sp,sp,16
    80001b9e:	8082                	ret
        first = 0;
    80001ba0:	0000a797          	auipc	a5,0xa
    80001ba4:	8207a023          	sw	zero,-2016(a5) # 8000b3c0 <first.1>
        fsinit(ROOTDEV);
    80001ba8:	4505                	li	a0,1
    80001baa:	00002097          	auipc	ra,0x2
    80001bae:	cd6080e7          	jalr	-810(ra) # 80003880 <fsinit>
    80001bb2:	bff9                	j	80001b90 <forkret+0x22>

0000000080001bb4 <allocpid>:
{
    80001bb4:	1101                	addi	sp,sp,-32
    80001bb6:	ec06                	sd	ra,24(sp)
    80001bb8:	e822                	sd	s0,16(sp)
    80001bba:	e426                	sd	s1,8(sp)
    80001bbc:	e04a                	sd	s2,0(sp)
    80001bbe:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001bc0:	00012917          	auipc	s2,0x12
    80001bc4:	f6090913          	addi	s2,s2,-160 # 80013b20 <pid_lock>
    80001bc8:	854a                	mv	a0,s2
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	06e080e7          	jalr	110(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001bd2:	00009797          	auipc	a5,0x9
    80001bd6:	7fe78793          	addi	a5,a5,2046 # 8000b3d0 <nextpid>
    80001bda:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001bdc:	0014871b          	addiw	a4,s1,1
    80001be0:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001be2:	854a                	mv	a0,s2
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	108080e7          	jalr	264(ra) # 80000cec <release>
}
    80001bec:	8526                	mv	a0,s1
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	64a2                	ld	s1,8(sp)
    80001bf4:	6902                	ld	s2,0(sp)
    80001bf6:	6105                	addi	sp,sp,32
    80001bf8:	8082                	ret

0000000080001bfa <proc_pagetable>:
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	e04a                	sd	s2,0(sp)
    80001c04:	1000                	addi	s0,sp,32
    80001c06:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	78a080e7          	jalr	1930(ra) # 80001392 <uvmcreate>
    80001c10:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001c12:	c121                	beqz	a0,80001c52 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c14:	4729                	li	a4,10
    80001c16:	00005697          	auipc	a3,0x5
    80001c1a:	3ea68693          	addi	a3,a3,1002 # 80007000 <_trampoline>
    80001c1e:	6605                	lui	a2,0x1
    80001c20:	040005b7          	lui	a1,0x4000
    80001c24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c26:	05b2                	slli	a1,a1,0xc
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	4d0080e7          	jalr	1232(ra) # 800010f8 <mappages>
    80001c30:	02054863          	bltz	a0,80001c60 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c34:	4719                	li	a4,6
    80001c36:	05893683          	ld	a3,88(s2)
    80001c3a:	6605                	lui	a2,0x1
    80001c3c:	020005b7          	lui	a1,0x2000
    80001c40:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c42:	05b6                	slli	a1,a1,0xd
    80001c44:	8526                	mv	a0,s1
    80001c46:	fffff097          	auipc	ra,0xfffff
    80001c4a:	4b2080e7          	jalr	1202(ra) # 800010f8 <mappages>
    80001c4e:	02054163          	bltz	a0,80001c70 <proc_pagetable+0x76>
}
    80001c52:	8526                	mv	a0,s1
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6902                	ld	s2,0(sp)
    80001c5c:	6105                	addi	sp,sp,32
    80001c5e:	8082                	ret
        uvmfree(pagetable, 0);
    80001c60:	4581                	li	a1,0
    80001c62:	8526                	mv	a0,s1
    80001c64:	00000097          	auipc	ra,0x0
    80001c68:	940080e7          	jalr	-1728(ra) # 800015a4 <uvmfree>
        return 0;
    80001c6c:	4481                	li	s1,0
    80001c6e:	b7d5                	j	80001c52 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c70:	4681                	li	a3,0
    80001c72:	4605                	li	a2,1
    80001c74:	040005b7          	lui	a1,0x4000
    80001c78:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c7a:	05b2                	slli	a1,a1,0xc
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	640080e7          	jalr	1600(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001c86:	4581                	li	a1,0
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00000097          	auipc	ra,0x0
    80001c8e:	91a080e7          	jalr	-1766(ra) # 800015a4 <uvmfree>
        return 0;
    80001c92:	4481                	li	s1,0
    80001c94:	bf7d                	j	80001c52 <proc_pagetable+0x58>

0000000080001c96 <proc_freepagetable>:
{
    80001c96:	1101                	addi	sp,sp,-32
    80001c98:	ec06                	sd	ra,24(sp)
    80001c9a:	e822                	sd	s0,16(sp)
    80001c9c:	e426                	sd	s1,8(sp)
    80001c9e:	e04a                	sd	s2,0(sp)
    80001ca0:	1000                	addi	s0,sp,32
    80001ca2:	84aa                	mv	s1,a0
    80001ca4:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ca6:	4681                	li	a3,0
    80001ca8:	4605                	li	a2,1
    80001caa:	040005b7          	lui	a1,0x4000
    80001cae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cb0:	05b2                	slli	a1,a1,0xc
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	60c080e7          	jalr	1548(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001cba:	4681                	li	a3,0
    80001cbc:	4605                	li	a2,1
    80001cbe:	020005b7          	lui	a1,0x2000
    80001cc2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001cc4:	05b6                	slli	a1,a1,0xd
    80001cc6:	8526                	mv	a0,s1
    80001cc8:	fffff097          	auipc	ra,0xfffff
    80001ccc:	5f6080e7          	jalr	1526(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001cd0:	85ca                	mv	a1,s2
    80001cd2:	8526                	mv	a0,s1
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	8d0080e7          	jalr	-1840(ra) # 800015a4 <uvmfree>
}
    80001cdc:	60e2                	ld	ra,24(sp)
    80001cde:	6442                	ld	s0,16(sp)
    80001ce0:	64a2                	ld	s1,8(sp)
    80001ce2:	6902                	ld	s2,0(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret

0000000080001ce8 <freeproc>:
{
    80001ce8:	1101                	addi	sp,sp,-32
    80001cea:	ec06                	sd	ra,24(sp)
    80001cec:	e822                	sd	s0,16(sp)
    80001cee:	e426                	sd	s1,8(sp)
    80001cf0:	1000                	addi	s0,sp,32
    80001cf2:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001cf4:	6d28                	ld	a0,88(a0)
    80001cf6:	c509                	beqz	a0,80001d00 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001cf8:	fffff097          	auipc	ra,0xfffff
    80001cfc:	d52080e7          	jalr	-686(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001d00:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001d04:	68a8                	ld	a0,80(s1)
    80001d06:	c511                	beqz	a0,80001d12 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001d08:	64ac                	ld	a1,72(s1)
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	f8c080e7          	jalr	-116(ra) # 80001c96 <proc_freepagetable>
    p->pagetable = 0;
    80001d12:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001d16:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001d1a:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001d1e:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001d22:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001d26:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001d2a:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001d2e:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001d32:	0004ac23          	sw	zero,24(s1)
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6105                	addi	sp,sp,32
    80001d3e:	8082                	ret

0000000080001d40 <allocproc>:
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	e04a                	sd	s2,0(sp)
    80001d4a:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001d4c:	00012497          	auipc	s1,0x12
    80001d50:	e0448493          	addi	s1,s1,-508 # 80013b50 <proc>
    80001d54:	00017917          	auipc	s2,0x17
    80001d58:	7fc90913          	addi	s2,s2,2044 # 80019550 <tickslock>
        acquire(&p->lock);
    80001d5c:	8526                	mv	a0,s1
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	eda080e7          	jalr	-294(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001d66:	4c9c                	lw	a5,24(s1)
    80001d68:	cf81                	beqz	a5,80001d80 <allocproc+0x40>
            release(&p->lock);
    80001d6a:	8526                	mv	a0,s1
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	f80080e7          	jalr	-128(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d74:	16848493          	addi	s1,s1,360
    80001d78:	ff2492e3          	bne	s1,s2,80001d5c <allocproc+0x1c>
    return 0;
    80001d7c:	4481                	li	s1,0
    80001d7e:	a889                	j	80001dd0 <allocproc+0x90>
    p->pid = allocpid();
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	e34080e7          	jalr	-460(ra) # 80001bb4 <allocpid>
    80001d88:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001d8a:	4785                	li	a5,1
    80001d8c:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	dba080e7          	jalr	-582(ra) # 80000b48 <kalloc>
    80001d96:	892a                	mv	s2,a0
    80001d98:	eca8                	sd	a0,88(s1)
    80001d9a:	c131                	beqz	a0,80001dde <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	e5c080e7          	jalr	-420(ra) # 80001bfa <proc_pagetable>
    80001da6:	892a                	mv	s2,a0
    80001da8:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001daa:	c531                	beqz	a0,80001df6 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001dac:	07000613          	li	a2,112
    80001db0:	4581                	li	a1,0
    80001db2:	06048513          	addi	a0,s1,96
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	f7e080e7          	jalr	-130(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001dbe:	00000797          	auipc	a5,0x0
    80001dc2:	db078793          	addi	a5,a5,-592 # 80001b6e <forkret>
    80001dc6:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001dc8:	60bc                	ld	a5,64(s1)
    80001dca:	6705                	lui	a4,0x1
    80001dcc:	97ba                	add	a5,a5,a4
    80001dce:	f4bc                	sd	a5,104(s1)
}
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	60e2                	ld	ra,24(sp)
    80001dd4:	6442                	ld	s0,16(sp)
    80001dd6:	64a2                	ld	s1,8(sp)
    80001dd8:	6902                	ld	s2,0(sp)
    80001dda:	6105                	addi	sp,sp,32
    80001ddc:	8082                	ret
        freeproc(p);
    80001dde:	8526                	mv	a0,s1
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	f08080e7          	jalr	-248(ra) # 80001ce8 <freeproc>
        release(&p->lock);
    80001de8:	8526                	mv	a0,s1
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	f02080e7          	jalr	-254(ra) # 80000cec <release>
        return 0;
    80001df2:	84ca                	mv	s1,s2
    80001df4:	bff1                	j	80001dd0 <allocproc+0x90>
        freeproc(p);
    80001df6:	8526                	mv	a0,s1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	ef0080e7          	jalr	-272(ra) # 80001ce8 <freeproc>
        release(&p->lock);
    80001e00:	8526                	mv	a0,s1
    80001e02:	fffff097          	auipc	ra,0xfffff
    80001e06:	eea080e7          	jalr	-278(ra) # 80000cec <release>
        return 0;
    80001e0a:	84ca                	mv	s1,s2
    80001e0c:	b7d1                	j	80001dd0 <allocproc+0x90>

0000000080001e0e <userinit>:
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	e426                	sd	s1,8(sp)
    80001e16:	1000                	addi	s0,sp,32
    p = allocproc();
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	f28080e7          	jalr	-216(ra) # 80001d40 <allocproc>
    80001e20:	84aa                	mv	s1,a0
    initproc = p;
    80001e22:	00009797          	auipc	a5,0x9
    80001e26:	68a7b323          	sd	a0,1670(a5) # 8000b4a8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001e2a:	03400613          	li	a2,52
    80001e2e:	00009597          	auipc	a1,0x9
    80001e32:	5b258593          	addi	a1,a1,1458 # 8000b3e0 <initcode>
    80001e36:	6928                	ld	a0,80(a0)
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	588080e7          	jalr	1416(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80001e40:	6785                	lui	a5,0x1
    80001e42:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001e44:	6cb8                	ld	a4,88(s1)
    80001e46:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001e4a:	6cb8                	ld	a4,88(s1)
    80001e4c:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e4e:	4641                	li	a2,16
    80001e50:	00006597          	auipc	a1,0x6
    80001e54:	39058593          	addi	a1,a1,912 # 800081e0 <etext+0x1e0>
    80001e58:	15848513          	addi	a0,s1,344
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	01a080e7          	jalr	26(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    80001e64:	00006517          	auipc	a0,0x6
    80001e68:	38c50513          	addi	a0,a0,908 # 800081f0 <etext+0x1f0>
    80001e6c:	00002097          	auipc	ra,0x2
    80001e70:	466080e7          	jalr	1126(ra) # 800042d2 <namei>
    80001e74:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001e78:	478d                	li	a5,3
    80001e7a:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001e7c:	8526                	mv	a0,s1
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	e6e080e7          	jalr	-402(ra) # 80000cec <release>
}
    80001e86:	60e2                	ld	ra,24(sp)
    80001e88:	6442                	ld	s0,16(sp)
    80001e8a:	64a2                	ld	s1,8(sp)
    80001e8c:	6105                	addi	sp,sp,32
    80001e8e:	8082                	ret

0000000080001e90 <growproc>:
{
    80001e90:	1101                	addi	sp,sp,-32
    80001e92:	ec06                	sd	ra,24(sp)
    80001e94:	e822                	sd	s0,16(sp)
    80001e96:	e426                	sd	s1,8(sp)
    80001e98:	e04a                	sd	s2,0(sp)
    80001e9a:	1000                	addi	s0,sp,32
    80001e9c:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001e9e:	00000097          	auipc	ra,0x0
    80001ea2:	c98080e7          	jalr	-872(ra) # 80001b36 <myproc>
    80001ea6:	84aa                	mv	s1,a0
    sz = p->sz;
    80001ea8:	652c                	ld	a1,72(a0)
    if (n > 0)
    80001eaa:	01204c63          	bgtz	s2,80001ec2 <growproc+0x32>
    else if (n < 0)
    80001eae:	02094663          	bltz	s2,80001eda <growproc+0x4a>
    p->sz = sz;
    80001eb2:	e4ac                	sd	a1,72(s1)
    return 0;
    80001eb4:	4501                	li	a0,0
}
    80001eb6:	60e2                	ld	ra,24(sp)
    80001eb8:	6442                	ld	s0,16(sp)
    80001eba:	64a2                	ld	s1,8(sp)
    80001ebc:	6902                	ld	s2,0(sp)
    80001ebe:	6105                	addi	sp,sp,32
    80001ec0:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001ec2:	4691                	li	a3,4
    80001ec4:	00b90633          	add	a2,s2,a1
    80001ec8:	6928                	ld	a0,80(a0)
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	5b0080e7          	jalr	1456(ra) # 8000147a <uvmalloc>
    80001ed2:	85aa                	mv	a1,a0
    80001ed4:	fd79                	bnez	a0,80001eb2 <growproc+0x22>
            return -1;
    80001ed6:	557d                	li	a0,-1
    80001ed8:	bff9                	j	80001eb6 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001eda:	00b90633          	add	a2,s2,a1
    80001ede:	6928                	ld	a0,80(a0)
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	552080e7          	jalr	1362(ra) # 80001432 <uvmdealloc>
    80001ee8:	85aa                	mv	a1,a0
    80001eea:	b7e1                	j	80001eb2 <growproc+0x22>

0000000080001eec <ps>:
{
    80001eec:	715d                	addi	sp,sp,-80
    80001eee:	e486                	sd	ra,72(sp)
    80001ef0:	e0a2                	sd	s0,64(sp)
    80001ef2:	fc26                	sd	s1,56(sp)
    80001ef4:	f84a                	sd	s2,48(sp)
    80001ef6:	f44e                	sd	s3,40(sp)
    80001ef8:	f052                	sd	s4,32(sp)
    80001efa:	ec56                	sd	s5,24(sp)
    80001efc:	e85a                	sd	s6,16(sp)
    80001efe:	e45e                	sd	s7,8(sp)
    80001f00:	e062                	sd	s8,0(sp)
    80001f02:	0880                	addi	s0,sp,80
    80001f04:	84aa                	mv	s1,a0
    80001f06:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	c2e080e7          	jalr	-978(ra) # 80001b36 <myproc>
        return result;
    80001f10:	4901                	li	s2,0
    if (count == 0)
    80001f12:	0c0b8663          	beqz	s7,80001fde <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80001f16:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80001f1a:	003b951b          	slliw	a0,s7,0x3
    80001f1e:	0175053b          	addw	a0,a0,s7
    80001f22:	0025151b          	slliw	a0,a0,0x2
    80001f26:	2501                	sext.w	a0,a0
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	f68080e7          	jalr	-152(ra) # 80001e90 <growproc>
    80001f30:	12054f63          	bltz	a0,8000206e <ps+0x182>
    struct user_proc loc_result[count];
    80001f34:	003b9a13          	slli	s4,s7,0x3
    80001f38:	9a5e                	add	s4,s4,s7
    80001f3a:	0a0a                	slli	s4,s4,0x2
    80001f3c:	00fa0793          	addi	a5,s4,15
    80001f40:	8391                	srli	a5,a5,0x4
    80001f42:	0792                	slli	a5,a5,0x4
    80001f44:	40f10133          	sub	sp,sp,a5
    80001f48:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    80001f4a:	16800793          	li	a5,360
    80001f4e:	02f484b3          	mul	s1,s1,a5
    80001f52:	00012797          	auipc	a5,0x12
    80001f56:	bfe78793          	addi	a5,a5,-1026 # 80013b50 <proc>
    80001f5a:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80001f5c:	00017797          	auipc	a5,0x17
    80001f60:	5f478793          	addi	a5,a5,1524 # 80019550 <tickslock>
        return result;
    80001f64:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80001f66:	06f4fc63          	bgeu	s1,a5,80001fde <ps+0xf2>
    acquire(&wait_lock);
    80001f6a:	00012517          	auipc	a0,0x12
    80001f6e:	bce50513          	addi	a0,a0,-1074 # 80013b38 <wait_lock>
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	cc6080e7          	jalr	-826(ra) # 80000c38 <acquire>
        if (localCount == count)
    80001f7a:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    80001f7e:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80001f80:	00017c17          	auipc	s8,0x17
    80001f84:	5d0c0c13          	addi	s8,s8,1488 # 80019550 <tickslock>
    80001f88:	a851                	j	8000201c <ps+0x130>
            loc_result[localCount].state = UNUSED;
    80001f8a:	00399793          	slli	a5,s3,0x3
    80001f8e:	97ce                	add	a5,a5,s3
    80001f90:	078a                	slli	a5,a5,0x2
    80001f92:	97d6                	add	a5,a5,s5
    80001f94:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80001f98:	8526                	mv	a0,s1
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	d52080e7          	jalr	-686(ra) # 80000cec <release>
    release(&wait_lock);
    80001fa2:	00012517          	auipc	a0,0x12
    80001fa6:	b9650513          	addi	a0,a0,-1130 # 80013b38 <wait_lock>
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	d42080e7          	jalr	-702(ra) # 80000cec <release>
    if (localCount < count)
    80001fb2:	0179f963          	bgeu	s3,s7,80001fc4 <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80001fb6:	00399793          	slli	a5,s3,0x3
    80001fba:	97ce                	add	a5,a5,s3
    80001fbc:	078a                	slli	a5,a5,0x2
    80001fbe:	97d6                	add	a5,a5,s5
    80001fc0:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80001fc4:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	b70080e7          	jalr	-1168(ra) # 80001b36 <myproc>
    80001fce:	86d2                	mv	a3,s4
    80001fd0:	8656                	mv	a2,s5
    80001fd2:	85da                	mv	a1,s6
    80001fd4:	6928                	ld	a0,80(a0)
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	70c080e7          	jalr	1804(ra) # 800016e2 <copyout>
}
    80001fde:	854a                	mv	a0,s2
    80001fe0:	fb040113          	addi	sp,s0,-80
    80001fe4:	60a6                	ld	ra,72(sp)
    80001fe6:	6406                	ld	s0,64(sp)
    80001fe8:	74e2                	ld	s1,56(sp)
    80001fea:	7942                	ld	s2,48(sp)
    80001fec:	79a2                	ld	s3,40(sp)
    80001fee:	7a02                	ld	s4,32(sp)
    80001ff0:	6ae2                	ld	s5,24(sp)
    80001ff2:	6b42                	ld	s6,16(sp)
    80001ff4:	6ba2                	ld	s7,8(sp)
    80001ff6:	6c02                	ld	s8,0(sp)
    80001ff8:	6161                	addi	sp,sp,80
    80001ffa:	8082                	ret
        release(&p->lock);
    80001ffc:	8526                	mv	a0,s1
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	cee080e7          	jalr	-786(ra) # 80000cec <release>
        localCount++;
    80002006:	2985                	addiw	s3,s3,1
    80002008:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    8000200c:	16848493          	addi	s1,s1,360
    80002010:	f984f9e3          	bgeu	s1,s8,80001fa2 <ps+0xb6>
        if (localCount == count)
    80002014:	02490913          	addi	s2,s2,36
    80002018:	053b8d63          	beq	s7,s3,80002072 <ps+0x186>
        acquire(&p->lock);
    8000201c:	8526                	mv	a0,s1
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	c1a080e7          	jalr	-998(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80002026:	4c9c                	lw	a5,24(s1)
    80002028:	d3ad                	beqz	a5,80001f8a <ps+0x9e>
        loc_result[localCount].state = p->state;
    8000202a:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    8000202e:	549c                	lw	a5,40(s1)
    80002030:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002034:	54dc                	lw	a5,44(s1)
    80002036:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000203a:	589c                	lw	a5,48(s1)
    8000203c:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002040:	4641                	li	a2,16
    80002042:	85ca                	mv	a1,s2
    80002044:	15848513          	addi	a0,s1,344
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	a9e080e7          	jalr	-1378(ra) # 80001ae6 <copy_array>
        if (p->parent != 0) // init
    80002050:	7c88                	ld	a0,56(s1)
    80002052:	d54d                	beqz	a0,80001ffc <ps+0x110>
            acquire(&p->parent->lock);
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	be4080e7          	jalr	-1052(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    8000205c:	7c88                	ld	a0,56(s1)
    8000205e:	591c                	lw	a5,48(a0)
    80002060:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	c88080e7          	jalr	-888(ra) # 80000cec <release>
    8000206c:	bf41                	j	80001ffc <ps+0x110>
        return result;
    8000206e:	4901                	li	s2,0
    80002070:	b7bd                	j	80001fde <ps+0xf2>
    release(&wait_lock);
    80002072:	00012517          	auipc	a0,0x12
    80002076:	ac650513          	addi	a0,a0,-1338 # 80013b38 <wait_lock>
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	c72080e7          	jalr	-910(ra) # 80000cec <release>
    if (localCount < count)
    80002082:	b789                	j	80001fc4 <ps+0xd8>

0000000080002084 <fork>:
{
    80002084:	7139                	addi	sp,sp,-64
    80002086:	fc06                	sd	ra,56(sp)
    80002088:	f822                	sd	s0,48(sp)
    8000208a:	f04a                	sd	s2,32(sp)
    8000208c:	e456                	sd	s5,8(sp)
    8000208e:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002090:	00000097          	auipc	ra,0x0
    80002094:	aa6080e7          	jalr	-1370(ra) # 80001b36 <myproc>
    80002098:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    8000209a:	00000097          	auipc	ra,0x0
    8000209e:	ca6080e7          	jalr	-858(ra) # 80001d40 <allocproc>
    800020a2:	12050063          	beqz	a0,800021c2 <fork+0x13e>
    800020a6:	e852                	sd	s4,16(sp)
    800020a8:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800020aa:	048ab603          	ld	a2,72(s5)
    800020ae:	692c                	ld	a1,80(a0)
    800020b0:	050ab503          	ld	a0,80(s5)
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	52a080e7          	jalr	1322(ra) # 800015de <uvmcopy>
    800020bc:	04054a63          	bltz	a0,80002110 <fork+0x8c>
    800020c0:	f426                	sd	s1,40(sp)
    800020c2:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800020c4:	048ab783          	ld	a5,72(s5)
    800020c8:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800020cc:	058ab683          	ld	a3,88(s5)
    800020d0:	87b6                	mv	a5,a3
    800020d2:	058a3703          	ld	a4,88(s4)
    800020d6:	12068693          	addi	a3,a3,288
    800020da:	0007b803          	ld	a6,0(a5)
    800020de:	6788                	ld	a0,8(a5)
    800020e0:	6b8c                	ld	a1,16(a5)
    800020e2:	6f90                	ld	a2,24(a5)
    800020e4:	01073023          	sd	a6,0(a4)
    800020e8:	e708                	sd	a0,8(a4)
    800020ea:	eb0c                	sd	a1,16(a4)
    800020ec:	ef10                	sd	a2,24(a4)
    800020ee:	02078793          	addi	a5,a5,32
    800020f2:	02070713          	addi	a4,a4,32
    800020f6:	fed792e3          	bne	a5,a3,800020da <fork+0x56>
    np->trapframe->a0 = 0;
    800020fa:	058a3783          	ld	a5,88(s4)
    800020fe:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80002102:	0d0a8493          	addi	s1,s5,208
    80002106:	0d0a0913          	addi	s2,s4,208
    8000210a:	150a8993          	addi	s3,s5,336
    8000210e:	a015                	j	80002132 <fork+0xae>
        freeproc(np);
    80002110:	8552                	mv	a0,s4
    80002112:	00000097          	auipc	ra,0x0
    80002116:	bd6080e7          	jalr	-1066(ra) # 80001ce8 <freeproc>
        release(&np->lock);
    8000211a:	8552                	mv	a0,s4
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	bd0080e7          	jalr	-1072(ra) # 80000cec <release>
        return -1;
    80002124:	597d                	li	s2,-1
    80002126:	6a42                	ld	s4,16(sp)
    80002128:	a071                	j	800021b4 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    8000212a:	04a1                	addi	s1,s1,8
    8000212c:	0921                	addi	s2,s2,8
    8000212e:	01348b63          	beq	s1,s3,80002144 <fork+0xc0>
        if (p->ofile[i])
    80002132:	6088                	ld	a0,0(s1)
    80002134:	d97d                	beqz	a0,8000212a <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002136:	00003097          	auipc	ra,0x3
    8000213a:	814080e7          	jalr	-2028(ra) # 8000494a <filedup>
    8000213e:	00a93023          	sd	a0,0(s2)
    80002142:	b7e5                	j	8000212a <fork+0xa6>
    np->cwd = idup(p->cwd);
    80002144:	150ab503          	ld	a0,336(s5)
    80002148:	00002097          	auipc	ra,0x2
    8000214c:	97e080e7          	jalr	-1666(ra) # 80003ac6 <idup>
    80002150:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002154:	4641                	li	a2,16
    80002156:	158a8593          	addi	a1,s5,344
    8000215a:	158a0513          	addi	a0,s4,344
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	d18080e7          	jalr	-744(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    80002166:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000216a:	8552                	mv	a0,s4
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	b80080e7          	jalr	-1152(ra) # 80000cec <release>
    acquire(&wait_lock);
    80002174:	00012497          	auipc	s1,0x12
    80002178:	9c448493          	addi	s1,s1,-1596 # 80013b38 <wait_lock>
    8000217c:	8526                	mv	a0,s1
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	aba080e7          	jalr	-1350(ra) # 80000c38 <acquire>
    np->parent = p;
    80002186:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    8000218a:	8526                	mv	a0,s1
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	b60080e7          	jalr	-1184(ra) # 80000cec <release>
    acquire(&np->lock);
    80002194:	8552                	mv	a0,s4
    80002196:	fffff097          	auipc	ra,0xfffff
    8000219a:	aa2080e7          	jalr	-1374(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    8000219e:	478d                	li	a5,3
    800021a0:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800021a4:	8552                	mv	a0,s4
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	b46080e7          	jalr	-1210(ra) # 80000cec <release>
    return pid;
    800021ae:	74a2                	ld	s1,40(sp)
    800021b0:	69e2                	ld	s3,24(sp)
    800021b2:	6a42                	ld	s4,16(sp)
}
    800021b4:	854a                	mv	a0,s2
    800021b6:	70e2                	ld	ra,56(sp)
    800021b8:	7442                	ld	s0,48(sp)
    800021ba:	7902                	ld	s2,32(sp)
    800021bc:	6aa2                	ld	s5,8(sp)
    800021be:	6121                	addi	sp,sp,64
    800021c0:	8082                	ret
        return -1;
    800021c2:	597d                	li	s2,-1
    800021c4:	bfc5                	j	800021b4 <fork+0x130>

00000000800021c6 <scheduler>:
{
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	e426                	sd	s1,8(sp)
    800021ce:	e04a                	sd	s2,0(sp)
    800021d0:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    800021d2:	00009797          	auipc	a5,0x9
    800021d6:	1f67b783          	ld	a5,502(a5) # 8000b3c8 <sched_pointer>
        if (old_scheduler != sched_pointer)
    800021da:	00009497          	auipc	s1,0x9
    800021de:	1ee48493          	addi	s1,s1,494 # 8000b3c8 <sched_pointer>
            printf("Scheduler switched\n");
    800021e2:	00006917          	auipc	s2,0x6
    800021e6:	01690913          	addi	s2,s2,22 # 800081f8 <etext+0x1f8>
    800021ea:	a809                	j	800021fc <scheduler+0x36>
    800021ec:	854a                	mv	a0,s2
    800021ee:	ffffe097          	auipc	ra,0xffffe
    800021f2:	3bc080e7          	jalr	956(ra) # 800005aa <printf>
        (*sched_pointer)();
    800021f6:	609c                	ld	a5,0(s1)
    800021f8:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800021fa:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    800021fc:	6098                	ld	a4,0(s1)
    800021fe:	fef717e3          	bne	a4,a5,800021ec <scheduler+0x26>
    80002202:	bfd5                	j	800021f6 <scheduler+0x30>

0000000080002204 <sched>:
{
    80002204:	7179                	addi	sp,sp,-48
    80002206:	f406                	sd	ra,40(sp)
    80002208:	f022                	sd	s0,32(sp)
    8000220a:	ec26                	sd	s1,24(sp)
    8000220c:	e84a                	sd	s2,16(sp)
    8000220e:	e44e                	sd	s3,8(sp)
    80002210:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002212:	00000097          	auipc	ra,0x0
    80002216:	924080e7          	jalr	-1756(ra) # 80001b36 <myproc>
    8000221a:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	9a2080e7          	jalr	-1630(ra) # 80000bbe <holding>
    80002224:	c53d                	beqz	a0,80002292 <sched+0x8e>
    80002226:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002228:	2781                	sext.w	a5,a5
    8000222a:	079e                	slli	a5,a5,0x7
    8000222c:	00011717          	auipc	a4,0x11
    80002230:	4f470713          	addi	a4,a4,1268 # 80013720 <cpus>
    80002234:	97ba                	add	a5,a5,a4
    80002236:	5fb8                	lw	a4,120(a5)
    80002238:	4785                	li	a5,1
    8000223a:	06f71463          	bne	a4,a5,800022a2 <sched+0x9e>
    if (p->state == RUNNING)
    8000223e:	4c98                	lw	a4,24(s1)
    80002240:	4791                	li	a5,4
    80002242:	06f70863          	beq	a4,a5,800022b2 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002246:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000224a:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000224c:	ebbd                	bnez	a5,800022c2 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000224e:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002250:	00011917          	auipc	s2,0x11
    80002254:	4d090913          	addi	s2,s2,1232 # 80013720 <cpus>
    80002258:	2781                	sext.w	a5,a5
    8000225a:	079e                	slli	a5,a5,0x7
    8000225c:	97ca                	add	a5,a5,s2
    8000225e:	07c7a983          	lw	s3,124(a5)
    80002262:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002264:	2581                	sext.w	a1,a1
    80002266:	059e                	slli	a1,a1,0x7
    80002268:	05a1                	addi	a1,a1,8
    8000226a:	95ca                	add	a1,a1,s2
    8000226c:	06048513          	addi	a0,s1,96
    80002270:	00000097          	auipc	ra,0x0
    80002274:	748080e7          	jalr	1864(ra) # 800029b8 <swtch>
    80002278:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000227a:	2781                	sext.w	a5,a5
    8000227c:	079e                	slli	a5,a5,0x7
    8000227e:	993e                	add	s2,s2,a5
    80002280:	07392e23          	sw	s3,124(s2)
}
    80002284:	70a2                	ld	ra,40(sp)
    80002286:	7402                	ld	s0,32(sp)
    80002288:	64e2                	ld	s1,24(sp)
    8000228a:	6942                	ld	s2,16(sp)
    8000228c:	69a2                	ld	s3,8(sp)
    8000228e:	6145                	addi	sp,sp,48
    80002290:	8082                	ret
        panic("sched p->lock");
    80002292:	00006517          	auipc	a0,0x6
    80002296:	f7e50513          	addi	a0,a0,-130 # 80008210 <etext+0x210>
    8000229a:	ffffe097          	auipc	ra,0xffffe
    8000229e:	2c6080e7          	jalr	710(ra) # 80000560 <panic>
        panic("sched locks");
    800022a2:	00006517          	auipc	a0,0x6
    800022a6:	f7e50513          	addi	a0,a0,-130 # 80008220 <etext+0x220>
    800022aa:	ffffe097          	auipc	ra,0xffffe
    800022ae:	2b6080e7          	jalr	694(ra) # 80000560 <panic>
        panic("sched running");
    800022b2:	00006517          	auipc	a0,0x6
    800022b6:	f7e50513          	addi	a0,a0,-130 # 80008230 <etext+0x230>
    800022ba:	ffffe097          	auipc	ra,0xffffe
    800022be:	2a6080e7          	jalr	678(ra) # 80000560 <panic>
        panic("sched interruptible");
    800022c2:	00006517          	auipc	a0,0x6
    800022c6:	f7e50513          	addi	a0,a0,-130 # 80008240 <etext+0x240>
    800022ca:	ffffe097          	auipc	ra,0xffffe
    800022ce:	296080e7          	jalr	662(ra) # 80000560 <panic>

00000000800022d2 <yield>:
{
    800022d2:	1101                	addi	sp,sp,-32
    800022d4:	ec06                	sd	ra,24(sp)
    800022d6:	e822                	sd	s0,16(sp)
    800022d8:	e426                	sd	s1,8(sp)
    800022da:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800022dc:	00000097          	auipc	ra,0x0
    800022e0:	85a080e7          	jalr	-1958(ra) # 80001b36 <myproc>
    800022e4:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	952080e7          	jalr	-1710(ra) # 80000c38 <acquire>
    p->state = RUNNABLE;
    800022ee:	478d                	li	a5,3
    800022f0:	cc9c                	sw	a5,24(s1)
    sched();
    800022f2:	00000097          	auipc	ra,0x0
    800022f6:	f12080e7          	jalr	-238(ra) # 80002204 <sched>
    release(&p->lock);
    800022fa:	8526                	mv	a0,s1
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	9f0080e7          	jalr	-1552(ra) # 80000cec <release>
}
    80002304:	60e2                	ld	ra,24(sp)
    80002306:	6442                	ld	s0,16(sp)
    80002308:	64a2                	ld	s1,8(sp)
    8000230a:	6105                	addi	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000230e:	7179                	addi	sp,sp,-48
    80002310:	f406                	sd	ra,40(sp)
    80002312:	f022                	sd	s0,32(sp)
    80002314:	ec26                	sd	s1,24(sp)
    80002316:	e84a                	sd	s2,16(sp)
    80002318:	e44e                	sd	s3,8(sp)
    8000231a:	1800                	addi	s0,sp,48
    8000231c:	89aa                	mv	s3,a0
    8000231e:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002320:	00000097          	auipc	ra,0x0
    80002324:	816080e7          	jalr	-2026(ra) # 80001b36 <myproc>
    80002328:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	90e080e7          	jalr	-1778(ra) # 80000c38 <acquire>
    release(lk);
    80002332:	854a                	mv	a0,s2
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	9b8080e7          	jalr	-1608(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    8000233c:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002340:	4789                	li	a5,2
    80002342:	cc9c                	sw	a5,24(s1)

    sched();
    80002344:	00000097          	auipc	ra,0x0
    80002348:	ec0080e7          	jalr	-320(ra) # 80002204 <sched>

    // Tidy up.
    p->chan = 0;
    8000234c:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	99a080e7          	jalr	-1638(ra) # 80000cec <release>
    acquire(lk);
    8000235a:	854a                	mv	a0,s2
    8000235c:	fffff097          	auipc	ra,0xfffff
    80002360:	8dc080e7          	jalr	-1828(ra) # 80000c38 <acquire>
}
    80002364:	70a2                	ld	ra,40(sp)
    80002366:	7402                	ld	s0,32(sp)
    80002368:	64e2                	ld	s1,24(sp)
    8000236a:	6942                	ld	s2,16(sp)
    8000236c:	69a2                	ld	s3,8(sp)
    8000236e:	6145                	addi	sp,sp,48
    80002370:	8082                	ret

0000000080002372 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002372:	7139                	addi	sp,sp,-64
    80002374:	fc06                	sd	ra,56(sp)
    80002376:	f822                	sd	s0,48(sp)
    80002378:	f426                	sd	s1,40(sp)
    8000237a:	f04a                	sd	s2,32(sp)
    8000237c:	ec4e                	sd	s3,24(sp)
    8000237e:	e852                	sd	s4,16(sp)
    80002380:	e456                	sd	s5,8(sp)
    80002382:	0080                	addi	s0,sp,64
    80002384:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002386:	00011497          	auipc	s1,0x11
    8000238a:	7ca48493          	addi	s1,s1,1994 # 80013b50 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    8000238e:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002390:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002392:	00017917          	auipc	s2,0x17
    80002396:	1be90913          	addi	s2,s2,446 # 80019550 <tickslock>
    8000239a:	a811                	j	800023ae <wakeup+0x3c>
            }
            release(&p->lock);
    8000239c:	8526                	mv	a0,s1
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	94e080e7          	jalr	-1714(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800023a6:	16848493          	addi	s1,s1,360
    800023aa:	03248663          	beq	s1,s2,800023d6 <wakeup+0x64>
        if (p != myproc())
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	788080e7          	jalr	1928(ra) # 80001b36 <myproc>
    800023b6:	fea488e3          	beq	s1,a0,800023a6 <wakeup+0x34>
            acquire(&p->lock);
    800023ba:	8526                	mv	a0,s1
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	87c080e7          	jalr	-1924(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800023c4:	4c9c                	lw	a5,24(s1)
    800023c6:	fd379be3          	bne	a5,s3,8000239c <wakeup+0x2a>
    800023ca:	709c                	ld	a5,32(s1)
    800023cc:	fd4798e3          	bne	a5,s4,8000239c <wakeup+0x2a>
                p->state = RUNNABLE;
    800023d0:	0154ac23          	sw	s5,24(s1)
    800023d4:	b7e1                	j	8000239c <wakeup+0x2a>
        }
    }
}
    800023d6:	70e2                	ld	ra,56(sp)
    800023d8:	7442                	ld	s0,48(sp)
    800023da:	74a2                	ld	s1,40(sp)
    800023dc:	7902                	ld	s2,32(sp)
    800023de:	69e2                	ld	s3,24(sp)
    800023e0:	6a42                	ld	s4,16(sp)
    800023e2:	6aa2                	ld	s5,8(sp)
    800023e4:	6121                	addi	sp,sp,64
    800023e6:	8082                	ret

00000000800023e8 <reparent>:
{
    800023e8:	7179                	addi	sp,sp,-48
    800023ea:	f406                	sd	ra,40(sp)
    800023ec:	f022                	sd	s0,32(sp)
    800023ee:	ec26                	sd	s1,24(sp)
    800023f0:	e84a                	sd	s2,16(sp)
    800023f2:	e44e                	sd	s3,8(sp)
    800023f4:	e052                	sd	s4,0(sp)
    800023f6:	1800                	addi	s0,sp,48
    800023f8:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800023fa:	00011497          	auipc	s1,0x11
    800023fe:	75648493          	addi	s1,s1,1878 # 80013b50 <proc>
            pp->parent = initproc;
    80002402:	00009a17          	auipc	s4,0x9
    80002406:	0a6a0a13          	addi	s4,s4,166 # 8000b4a8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000240a:	00017997          	auipc	s3,0x17
    8000240e:	14698993          	addi	s3,s3,326 # 80019550 <tickslock>
    80002412:	a029                	j	8000241c <reparent+0x34>
    80002414:	16848493          	addi	s1,s1,360
    80002418:	01348d63          	beq	s1,s3,80002432 <reparent+0x4a>
        if (pp->parent == p)
    8000241c:	7c9c                	ld	a5,56(s1)
    8000241e:	ff279be3          	bne	a5,s2,80002414 <reparent+0x2c>
            pp->parent = initproc;
    80002422:	000a3503          	ld	a0,0(s4)
    80002426:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002428:	00000097          	auipc	ra,0x0
    8000242c:	f4a080e7          	jalr	-182(ra) # 80002372 <wakeup>
    80002430:	b7d5                	j	80002414 <reparent+0x2c>
}
    80002432:	70a2                	ld	ra,40(sp)
    80002434:	7402                	ld	s0,32(sp)
    80002436:	64e2                	ld	s1,24(sp)
    80002438:	6942                	ld	s2,16(sp)
    8000243a:	69a2                	ld	s3,8(sp)
    8000243c:	6a02                	ld	s4,0(sp)
    8000243e:	6145                	addi	sp,sp,48
    80002440:	8082                	ret

0000000080002442 <exit>:
{
    80002442:	7179                	addi	sp,sp,-48
    80002444:	f406                	sd	ra,40(sp)
    80002446:	f022                	sd	s0,32(sp)
    80002448:	ec26                	sd	s1,24(sp)
    8000244a:	e84a                	sd	s2,16(sp)
    8000244c:	e44e                	sd	s3,8(sp)
    8000244e:	e052                	sd	s4,0(sp)
    80002450:	1800                	addi	s0,sp,48
    80002452:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002454:	fffff097          	auipc	ra,0xfffff
    80002458:	6e2080e7          	jalr	1762(ra) # 80001b36 <myproc>
    8000245c:	89aa                	mv	s3,a0
    if (p == initproc)
    8000245e:	00009797          	auipc	a5,0x9
    80002462:	04a7b783          	ld	a5,74(a5) # 8000b4a8 <initproc>
    80002466:	0d050493          	addi	s1,a0,208
    8000246a:	15050913          	addi	s2,a0,336
    8000246e:	02a79363          	bne	a5,a0,80002494 <exit+0x52>
        panic("init exiting");
    80002472:	00006517          	auipc	a0,0x6
    80002476:	de650513          	addi	a0,a0,-538 # 80008258 <etext+0x258>
    8000247a:	ffffe097          	auipc	ra,0xffffe
    8000247e:	0e6080e7          	jalr	230(ra) # 80000560 <panic>
            fileclose(f);
    80002482:	00002097          	auipc	ra,0x2
    80002486:	51a080e7          	jalr	1306(ra) # 8000499c <fileclose>
            p->ofile[fd] = 0;
    8000248a:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    8000248e:	04a1                	addi	s1,s1,8
    80002490:	01248563          	beq	s1,s2,8000249a <exit+0x58>
        if (p->ofile[fd])
    80002494:	6088                	ld	a0,0(s1)
    80002496:	f575                	bnez	a0,80002482 <exit+0x40>
    80002498:	bfdd                	j	8000248e <exit+0x4c>
    begin_op();
    8000249a:	00002097          	auipc	ra,0x2
    8000249e:	038080e7          	jalr	56(ra) # 800044d2 <begin_op>
    iput(p->cwd);
    800024a2:	1509b503          	ld	a0,336(s3)
    800024a6:	00002097          	auipc	ra,0x2
    800024aa:	81c080e7          	jalr	-2020(ra) # 80003cc2 <iput>
    end_op();
    800024ae:	00002097          	auipc	ra,0x2
    800024b2:	09e080e7          	jalr	158(ra) # 8000454c <end_op>
    p->cwd = 0;
    800024b6:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800024ba:	00011497          	auipc	s1,0x11
    800024be:	67e48493          	addi	s1,s1,1662 # 80013b38 <wait_lock>
    800024c2:	8526                	mv	a0,s1
    800024c4:	ffffe097          	auipc	ra,0xffffe
    800024c8:	774080e7          	jalr	1908(ra) # 80000c38 <acquire>
    reparent(p);
    800024cc:	854e                	mv	a0,s3
    800024ce:	00000097          	auipc	ra,0x0
    800024d2:	f1a080e7          	jalr	-230(ra) # 800023e8 <reparent>
    wakeup(p->parent);
    800024d6:	0389b503          	ld	a0,56(s3)
    800024da:	00000097          	auipc	ra,0x0
    800024de:	e98080e7          	jalr	-360(ra) # 80002372 <wakeup>
    acquire(&p->lock);
    800024e2:	854e                	mv	a0,s3
    800024e4:	ffffe097          	auipc	ra,0xffffe
    800024e8:	754080e7          	jalr	1876(ra) # 80000c38 <acquire>
    p->xstate = status;
    800024ec:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800024f0:	4795                	li	a5,5
    800024f2:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	7f4080e7          	jalr	2036(ra) # 80000cec <release>
    sched();
    80002500:	00000097          	auipc	ra,0x0
    80002504:	d04080e7          	jalr	-764(ra) # 80002204 <sched>
    panic("zombie exit");
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	d6050513          	addi	a0,a0,-672 # 80008268 <etext+0x268>
    80002510:	ffffe097          	auipc	ra,0xffffe
    80002514:	050080e7          	jalr	80(ra) # 80000560 <panic>

0000000080002518 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002518:	7179                	addi	sp,sp,-48
    8000251a:	f406                	sd	ra,40(sp)
    8000251c:	f022                	sd	s0,32(sp)
    8000251e:	ec26                	sd	s1,24(sp)
    80002520:	e84a                	sd	s2,16(sp)
    80002522:	e44e                	sd	s3,8(sp)
    80002524:	1800                	addi	s0,sp,48
    80002526:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002528:	00011497          	auipc	s1,0x11
    8000252c:	62848493          	addi	s1,s1,1576 # 80013b50 <proc>
    80002530:	00017997          	auipc	s3,0x17
    80002534:	02098993          	addi	s3,s3,32 # 80019550 <tickslock>
    {
        acquire(&p->lock);
    80002538:	8526                	mv	a0,s1
    8000253a:	ffffe097          	auipc	ra,0xffffe
    8000253e:	6fe080e7          	jalr	1790(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    80002542:	589c                	lw	a5,48(s1)
    80002544:	01278d63          	beq	a5,s2,8000255e <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002548:	8526                	mv	a0,s1
    8000254a:	ffffe097          	auipc	ra,0xffffe
    8000254e:	7a2080e7          	jalr	1954(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002552:	16848493          	addi	s1,s1,360
    80002556:	ff3491e3          	bne	s1,s3,80002538 <kill+0x20>
    }
    return -1;
    8000255a:	557d                	li	a0,-1
    8000255c:	a829                	j	80002576 <kill+0x5e>
            p->killed = 1;
    8000255e:	4785                	li	a5,1
    80002560:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80002562:	4c98                	lw	a4,24(s1)
    80002564:	4789                	li	a5,2
    80002566:	00f70f63          	beq	a4,a5,80002584 <kill+0x6c>
            release(&p->lock);
    8000256a:	8526                	mv	a0,s1
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	780080e7          	jalr	1920(ra) # 80000cec <release>
            return 0;
    80002574:	4501                	li	a0,0
}
    80002576:	70a2                	ld	ra,40(sp)
    80002578:	7402                	ld	s0,32(sp)
    8000257a:	64e2                	ld	s1,24(sp)
    8000257c:	6942                	ld	s2,16(sp)
    8000257e:	69a2                	ld	s3,8(sp)
    80002580:	6145                	addi	sp,sp,48
    80002582:	8082                	ret
                p->state = RUNNABLE;
    80002584:	478d                	li	a5,3
    80002586:	cc9c                	sw	a5,24(s1)
    80002588:	b7cd                	j	8000256a <kill+0x52>

000000008000258a <setkilled>:

void setkilled(struct proc *p)
{
    8000258a:	1101                	addi	sp,sp,-32
    8000258c:	ec06                	sd	ra,24(sp)
    8000258e:	e822                	sd	s0,16(sp)
    80002590:	e426                	sd	s1,8(sp)
    80002592:	1000                	addi	s0,sp,32
    80002594:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	6a2080e7          	jalr	1698(ra) # 80000c38 <acquire>
    p->killed = 1;
    8000259e:	4785                	li	a5,1
    800025a0:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800025a2:	8526                	mv	a0,s1
    800025a4:	ffffe097          	auipc	ra,0xffffe
    800025a8:	748080e7          	jalr	1864(ra) # 80000cec <release>
}
    800025ac:	60e2                	ld	ra,24(sp)
    800025ae:	6442                	ld	s0,16(sp)
    800025b0:	64a2                	ld	s1,8(sp)
    800025b2:	6105                	addi	sp,sp,32
    800025b4:	8082                	ret

00000000800025b6 <killed>:

int killed(struct proc *p)
{
    800025b6:	1101                	addi	sp,sp,-32
    800025b8:	ec06                	sd	ra,24(sp)
    800025ba:	e822                	sd	s0,16(sp)
    800025bc:	e426                	sd	s1,8(sp)
    800025be:	e04a                	sd	s2,0(sp)
    800025c0:	1000                	addi	s0,sp,32
    800025c2:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	674080e7          	jalr	1652(ra) # 80000c38 <acquire>
    k = p->killed;
    800025cc:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800025d0:	8526                	mv	a0,s1
    800025d2:	ffffe097          	auipc	ra,0xffffe
    800025d6:	71a080e7          	jalr	1818(ra) # 80000cec <release>
    return k;
}
    800025da:	854a                	mv	a0,s2
    800025dc:	60e2                	ld	ra,24(sp)
    800025de:	6442                	ld	s0,16(sp)
    800025e0:	64a2                	ld	s1,8(sp)
    800025e2:	6902                	ld	s2,0(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <wait>:
{
    800025e8:	715d                	addi	sp,sp,-80
    800025ea:	e486                	sd	ra,72(sp)
    800025ec:	e0a2                	sd	s0,64(sp)
    800025ee:	fc26                	sd	s1,56(sp)
    800025f0:	f84a                	sd	s2,48(sp)
    800025f2:	f44e                	sd	s3,40(sp)
    800025f4:	f052                	sd	s4,32(sp)
    800025f6:	ec56                	sd	s5,24(sp)
    800025f8:	e85a                	sd	s6,16(sp)
    800025fa:	e45e                	sd	s7,8(sp)
    800025fc:	e062                	sd	s8,0(sp)
    800025fe:	0880                	addi	s0,sp,80
    80002600:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80002602:	fffff097          	auipc	ra,0xfffff
    80002606:	534080e7          	jalr	1332(ra) # 80001b36 <myproc>
    8000260a:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000260c:	00011517          	auipc	a0,0x11
    80002610:	52c50513          	addi	a0,a0,1324 # 80013b38 <wait_lock>
    80002614:	ffffe097          	auipc	ra,0xffffe
    80002618:	624080e7          	jalr	1572(ra) # 80000c38 <acquire>
        havekids = 0;
    8000261c:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    8000261e:	4a15                	li	s4,5
                havekids = 1;
    80002620:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002622:	00017997          	auipc	s3,0x17
    80002626:	f2e98993          	addi	s3,s3,-210 # 80019550 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000262a:	00011c17          	auipc	s8,0x11
    8000262e:	50ec0c13          	addi	s8,s8,1294 # 80013b38 <wait_lock>
    80002632:	a0d1                	j	800026f6 <wait+0x10e>
                    pid = pp->pid;
    80002634:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002638:	000b0e63          	beqz	s6,80002654 <wait+0x6c>
    8000263c:	4691                	li	a3,4
    8000263e:	02c48613          	addi	a2,s1,44
    80002642:	85da                	mv	a1,s6
    80002644:	05093503          	ld	a0,80(s2)
    80002648:	fffff097          	auipc	ra,0xfffff
    8000264c:	09a080e7          	jalr	154(ra) # 800016e2 <copyout>
    80002650:	04054163          	bltz	a0,80002692 <wait+0xaa>
                    freeproc(pp);
    80002654:	8526                	mv	a0,s1
    80002656:	fffff097          	auipc	ra,0xfffff
    8000265a:	692080e7          	jalr	1682(ra) # 80001ce8 <freeproc>
                    release(&pp->lock);
    8000265e:	8526                	mv	a0,s1
    80002660:	ffffe097          	auipc	ra,0xffffe
    80002664:	68c080e7          	jalr	1676(ra) # 80000cec <release>
                    release(&wait_lock);
    80002668:	00011517          	auipc	a0,0x11
    8000266c:	4d050513          	addi	a0,a0,1232 # 80013b38 <wait_lock>
    80002670:	ffffe097          	auipc	ra,0xffffe
    80002674:	67c080e7          	jalr	1660(ra) # 80000cec <release>
}
    80002678:	854e                	mv	a0,s3
    8000267a:	60a6                	ld	ra,72(sp)
    8000267c:	6406                	ld	s0,64(sp)
    8000267e:	74e2                	ld	s1,56(sp)
    80002680:	7942                	ld	s2,48(sp)
    80002682:	79a2                	ld	s3,40(sp)
    80002684:	7a02                	ld	s4,32(sp)
    80002686:	6ae2                	ld	s5,24(sp)
    80002688:	6b42                	ld	s6,16(sp)
    8000268a:	6ba2                	ld	s7,8(sp)
    8000268c:	6c02                	ld	s8,0(sp)
    8000268e:	6161                	addi	sp,sp,80
    80002690:	8082                	ret
                        release(&pp->lock);
    80002692:	8526                	mv	a0,s1
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	658080e7          	jalr	1624(ra) # 80000cec <release>
                        release(&wait_lock);
    8000269c:	00011517          	auipc	a0,0x11
    800026a0:	49c50513          	addi	a0,a0,1180 # 80013b38 <wait_lock>
    800026a4:	ffffe097          	auipc	ra,0xffffe
    800026a8:	648080e7          	jalr	1608(ra) # 80000cec <release>
                        return -1;
    800026ac:	59fd                	li	s3,-1
    800026ae:	b7e9                	j	80002678 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800026b0:	16848493          	addi	s1,s1,360
    800026b4:	03348463          	beq	s1,s3,800026dc <wait+0xf4>
            if (pp->parent == p)
    800026b8:	7c9c                	ld	a5,56(s1)
    800026ba:	ff279be3          	bne	a5,s2,800026b0 <wait+0xc8>
                acquire(&pp->lock);
    800026be:	8526                	mv	a0,s1
    800026c0:	ffffe097          	auipc	ra,0xffffe
    800026c4:	578080e7          	jalr	1400(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    800026c8:	4c9c                	lw	a5,24(s1)
    800026ca:	f74785e3          	beq	a5,s4,80002634 <wait+0x4c>
                release(&pp->lock);
    800026ce:	8526                	mv	a0,s1
    800026d0:	ffffe097          	auipc	ra,0xffffe
    800026d4:	61c080e7          	jalr	1564(ra) # 80000cec <release>
                havekids = 1;
    800026d8:	8756                	mv	a4,s5
    800026da:	bfd9                	j	800026b0 <wait+0xc8>
        if (!havekids || killed(p))
    800026dc:	c31d                	beqz	a4,80002702 <wait+0x11a>
    800026de:	854a                	mv	a0,s2
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	ed6080e7          	jalr	-298(ra) # 800025b6 <killed>
    800026e8:	ed09                	bnez	a0,80002702 <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800026ea:	85e2                	mv	a1,s8
    800026ec:	854a                	mv	a0,s2
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	c20080e7          	jalr	-992(ra) # 8000230e <sleep>
        havekids = 0;
    800026f6:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800026f8:	00011497          	auipc	s1,0x11
    800026fc:	45848493          	addi	s1,s1,1112 # 80013b50 <proc>
    80002700:	bf65                	j	800026b8 <wait+0xd0>
            release(&wait_lock);
    80002702:	00011517          	auipc	a0,0x11
    80002706:	43650513          	addi	a0,a0,1078 # 80013b38 <wait_lock>
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	5e2080e7          	jalr	1506(ra) # 80000cec <release>
            return -1;
    80002712:	59fd                	li	s3,-1
    80002714:	b795                	j	80002678 <wait+0x90>

0000000080002716 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002716:	7179                	addi	sp,sp,-48
    80002718:	f406                	sd	ra,40(sp)
    8000271a:	f022                	sd	s0,32(sp)
    8000271c:	ec26                	sd	s1,24(sp)
    8000271e:	e84a                	sd	s2,16(sp)
    80002720:	e44e                	sd	s3,8(sp)
    80002722:	e052                	sd	s4,0(sp)
    80002724:	1800                	addi	s0,sp,48
    80002726:	84aa                	mv	s1,a0
    80002728:	892e                	mv	s2,a1
    8000272a:	89b2                	mv	s3,a2
    8000272c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000272e:	fffff097          	auipc	ra,0xfffff
    80002732:	408080e7          	jalr	1032(ra) # 80001b36 <myproc>
    if (user_dst)
    80002736:	c08d                	beqz	s1,80002758 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002738:	86d2                	mv	a3,s4
    8000273a:	864e                	mv	a2,s3
    8000273c:	85ca                	mv	a1,s2
    8000273e:	6928                	ld	a0,80(a0)
    80002740:	fffff097          	auipc	ra,0xfffff
    80002744:	fa2080e7          	jalr	-94(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002748:	70a2                	ld	ra,40(sp)
    8000274a:	7402                	ld	s0,32(sp)
    8000274c:	64e2                	ld	s1,24(sp)
    8000274e:	6942                	ld	s2,16(sp)
    80002750:	69a2                	ld	s3,8(sp)
    80002752:	6a02                	ld	s4,0(sp)
    80002754:	6145                	addi	sp,sp,48
    80002756:	8082                	ret
        memmove((char *)dst, src, len);
    80002758:	000a061b          	sext.w	a2,s4
    8000275c:	85ce                	mv	a1,s3
    8000275e:	854a                	mv	a0,s2
    80002760:	ffffe097          	auipc	ra,0xffffe
    80002764:	630080e7          	jalr	1584(ra) # 80000d90 <memmove>
        return 0;
    80002768:	8526                	mv	a0,s1
    8000276a:	bff9                	j	80002748 <either_copyout+0x32>

000000008000276c <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000276c:	7179                	addi	sp,sp,-48
    8000276e:	f406                	sd	ra,40(sp)
    80002770:	f022                	sd	s0,32(sp)
    80002772:	ec26                	sd	s1,24(sp)
    80002774:	e84a                	sd	s2,16(sp)
    80002776:	e44e                	sd	s3,8(sp)
    80002778:	e052                	sd	s4,0(sp)
    8000277a:	1800                	addi	s0,sp,48
    8000277c:	892a                	mv	s2,a0
    8000277e:	84ae                	mv	s1,a1
    80002780:	89b2                	mv	s3,a2
    80002782:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002784:	fffff097          	auipc	ra,0xfffff
    80002788:	3b2080e7          	jalr	946(ra) # 80001b36 <myproc>
    if (user_src)
    8000278c:	c08d                	beqz	s1,800027ae <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    8000278e:	86d2                	mv	a3,s4
    80002790:	864e                	mv	a2,s3
    80002792:	85ca                	mv	a1,s2
    80002794:	6928                	ld	a0,80(a0)
    80002796:	fffff097          	auipc	ra,0xfffff
    8000279a:	fd8080e7          	jalr	-40(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    8000279e:	70a2                	ld	ra,40(sp)
    800027a0:	7402                	ld	s0,32(sp)
    800027a2:	64e2                	ld	s1,24(sp)
    800027a4:	6942                	ld	s2,16(sp)
    800027a6:	69a2                	ld	s3,8(sp)
    800027a8:	6a02                	ld	s4,0(sp)
    800027aa:	6145                	addi	sp,sp,48
    800027ac:	8082                	ret
        memmove(dst, (char *)src, len);
    800027ae:	000a061b          	sext.w	a2,s4
    800027b2:	85ce                	mv	a1,s3
    800027b4:	854a                	mv	a0,s2
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	5da080e7          	jalr	1498(ra) # 80000d90 <memmove>
        return 0;
    800027be:	8526                	mv	a0,s1
    800027c0:	bff9                	j	8000279e <either_copyin+0x32>

00000000800027c2 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800027c2:	715d                	addi	sp,sp,-80
    800027c4:	e486                	sd	ra,72(sp)
    800027c6:	e0a2                	sd	s0,64(sp)
    800027c8:	fc26                	sd	s1,56(sp)
    800027ca:	f84a                	sd	s2,48(sp)
    800027cc:	f44e                	sd	s3,40(sp)
    800027ce:	f052                	sd	s4,32(sp)
    800027d0:	ec56                	sd	s5,24(sp)
    800027d2:	e85a                	sd	s6,16(sp)
    800027d4:	e45e                	sd	s7,8(sp)
    800027d6:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800027d8:	00006517          	auipc	a0,0x6
    800027dc:	83850513          	addi	a0,a0,-1992 # 80008010 <etext+0x10>
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	dca080e7          	jalr	-566(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800027e8:	00011497          	auipc	s1,0x11
    800027ec:	4c048493          	addi	s1,s1,1216 # 80013ca8 <proc+0x158>
    800027f0:	00017917          	auipc	s2,0x17
    800027f4:	eb890913          	addi	s2,s2,-328 # 800196a8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027f8:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800027fa:	00006997          	auipc	s3,0x6
    800027fe:	a7e98993          	addi	s3,s3,-1410 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    80002802:	00006a97          	auipc	s5,0x6
    80002806:	a7ea8a93          	addi	s5,s5,-1410 # 80008280 <etext+0x280>
        printf("\n");
    8000280a:	00006a17          	auipc	s4,0x6
    8000280e:	806a0a13          	addi	s4,s4,-2042 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002812:	00006b97          	auipc	s7,0x6
    80002816:	016b8b93          	addi	s7,s7,22 # 80008828 <states.0>
    8000281a:	a00d                	j	8000283c <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    8000281c:	ed86a583          	lw	a1,-296(a3)
    80002820:	8556                	mv	a0,s5
    80002822:	ffffe097          	auipc	ra,0xffffe
    80002826:	d88080e7          	jalr	-632(ra) # 800005aa <printf>
        printf("\n");
    8000282a:	8552                	mv	a0,s4
    8000282c:	ffffe097          	auipc	ra,0xffffe
    80002830:	d7e080e7          	jalr	-642(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002834:	16848493          	addi	s1,s1,360
    80002838:	03248263          	beq	s1,s2,8000285c <procdump+0x9a>
        if (p->state == UNUSED)
    8000283c:	86a6                	mv	a3,s1
    8000283e:	ec04a783          	lw	a5,-320(s1)
    80002842:	dbed                	beqz	a5,80002834 <procdump+0x72>
            state = "???";
    80002844:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002846:	fcfb6be3          	bltu	s6,a5,8000281c <procdump+0x5a>
    8000284a:	02079713          	slli	a4,a5,0x20
    8000284e:	01d75793          	srli	a5,a4,0x1d
    80002852:	97de                	add	a5,a5,s7
    80002854:	6390                	ld	a2,0(a5)
    80002856:	f279                	bnez	a2,8000281c <procdump+0x5a>
            state = "???";
    80002858:	864e                	mv	a2,s3
    8000285a:	b7c9                	j	8000281c <procdump+0x5a>
    }
}
    8000285c:	60a6                	ld	ra,72(sp)
    8000285e:	6406                	ld	s0,64(sp)
    80002860:	74e2                	ld	s1,56(sp)
    80002862:	7942                	ld	s2,48(sp)
    80002864:	79a2                	ld	s3,40(sp)
    80002866:	7a02                	ld	s4,32(sp)
    80002868:	6ae2                	ld	s5,24(sp)
    8000286a:	6b42                	ld	s6,16(sp)
    8000286c:	6ba2                	ld	s7,8(sp)
    8000286e:	6161                	addi	sp,sp,80
    80002870:	8082                	ret

0000000080002872 <schedls>:

void schedls()
{
    80002872:	1101                	addi	sp,sp,-32
    80002874:	ec06                	sd	ra,24(sp)
    80002876:	e822                	sd	s0,16(sp)
    80002878:	e426                	sd	s1,8(sp)
    8000287a:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    8000287c:	00006517          	auipc	a0,0x6
    80002880:	a1450513          	addi	a0,a0,-1516 # 80008290 <etext+0x290>
    80002884:	ffffe097          	auipc	ra,0xffffe
    80002888:	d26080e7          	jalr	-730(ra) # 800005aa <printf>
    printf("====================================\n");
    8000288c:	00006517          	auipc	a0,0x6
    80002890:	a2c50513          	addi	a0,a0,-1492 # 800082b8 <etext+0x2b8>
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	d16080e7          	jalr	-746(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    8000289c:	00009717          	auipc	a4,0x9
    800028a0:	b8c73703          	ld	a4,-1140(a4) # 8000b428 <available_schedulers+0x10>
    800028a4:	00009797          	auipc	a5,0x9
    800028a8:	b247b783          	ld	a5,-1244(a5) # 8000b3c8 <sched_pointer>
    800028ac:	08f70763          	beq	a4,a5,8000293a <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	a3050513          	addi	a0,a0,-1488 # 800082e0 <etext+0x2e0>
    800028b8:	ffffe097          	auipc	ra,0xffffe
    800028bc:	cf2080e7          	jalr	-782(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    800028c0:	00009497          	auipc	s1,0x9
    800028c4:	b2048493          	addi	s1,s1,-1248 # 8000b3e0 <initcode>
    800028c8:	48b0                	lw	a2,80(s1)
    800028ca:	00009597          	auipc	a1,0x9
    800028ce:	b4e58593          	addi	a1,a1,-1202 # 8000b418 <available_schedulers>
    800028d2:	00006517          	auipc	a0,0x6
    800028d6:	a1e50513          	addi	a0,a0,-1506 # 800082f0 <etext+0x2f0>
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	cd0080e7          	jalr	-816(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    800028e2:	74b8                	ld	a4,104(s1)
    800028e4:	00009797          	auipc	a5,0x9
    800028e8:	ae47b783          	ld	a5,-1308(a5) # 8000b3c8 <sched_pointer>
    800028ec:	06f70063          	beq	a4,a5,8000294c <schedls+0xda>
            printf("   \t");
    800028f0:	00006517          	auipc	a0,0x6
    800028f4:	9f050513          	addi	a0,a0,-1552 # 800082e0 <etext+0x2e0>
    800028f8:	ffffe097          	auipc	ra,0xffffe
    800028fc:	cb2080e7          	jalr	-846(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002900:	00009617          	auipc	a2,0x9
    80002904:	b5062603          	lw	a2,-1200(a2) # 8000b450 <available_schedulers+0x38>
    80002908:	00009597          	auipc	a1,0x9
    8000290c:	b3058593          	addi	a1,a1,-1232 # 8000b438 <available_schedulers+0x20>
    80002910:	00006517          	auipc	a0,0x6
    80002914:	9e050513          	addi	a0,a0,-1568 # 800082f0 <etext+0x2f0>
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	c92080e7          	jalr	-878(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	9d850513          	addi	a0,a0,-1576 # 800082f8 <etext+0x2f8>
    80002928:	ffffe097          	auipc	ra,0xffffe
    8000292c:	c82080e7          	jalr	-894(ra) # 800005aa <printf>
}
    80002930:	60e2                	ld	ra,24(sp)
    80002932:	6442                	ld	s0,16(sp)
    80002934:	64a2                	ld	s1,8(sp)
    80002936:	6105                	addi	sp,sp,32
    80002938:	8082                	ret
            printf("[*]\t");
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	9ae50513          	addi	a0,a0,-1618 # 800082e8 <etext+0x2e8>
    80002942:	ffffe097          	auipc	ra,0xffffe
    80002946:	c68080e7          	jalr	-920(ra) # 800005aa <printf>
    8000294a:	bf9d                	j	800028c0 <schedls+0x4e>
    8000294c:	00006517          	auipc	a0,0x6
    80002950:	99c50513          	addi	a0,a0,-1636 # 800082e8 <etext+0x2e8>
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	c56080e7          	jalr	-938(ra) # 800005aa <printf>
    8000295c:	b755                	j	80002900 <schedls+0x8e>

000000008000295e <schedset>:

void schedset(int id)
{
    8000295e:	1141                	addi	sp,sp,-16
    80002960:	e406                	sd	ra,8(sp)
    80002962:	e022                	sd	s0,0(sp)
    80002964:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002966:	4705                	li	a4,1
    80002968:	02a76f63          	bltu	a4,a0,800029a6 <schedset+0x48>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    8000296c:	00551793          	slli	a5,a0,0x5
    80002970:	00009717          	auipc	a4,0x9
    80002974:	a7070713          	addi	a4,a4,-1424 # 8000b3e0 <initcode>
    80002978:	973e                	add	a4,a4,a5
    8000297a:	6738                	ld	a4,72(a4)
    8000297c:	00009697          	auipc	a3,0x9
    80002980:	a4e6b623          	sd	a4,-1460(a3) # 8000b3c8 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002984:	00009597          	auipc	a1,0x9
    80002988:	a9458593          	addi	a1,a1,-1388 # 8000b418 <available_schedulers>
    8000298c:	95be                	add	a1,a1,a5
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	9aa50513          	addi	a0,a0,-1622 # 80008338 <etext+0x338>
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	c14080e7          	jalr	-1004(ra) # 800005aa <printf>
    8000299e:	60a2                	ld	ra,8(sp)
    800029a0:	6402                	ld	s0,0(sp)
    800029a2:	0141                	addi	sp,sp,16
    800029a4:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    800029a6:	00006517          	auipc	a0,0x6
    800029aa:	96a50513          	addi	a0,a0,-1686 # 80008310 <etext+0x310>
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	bfc080e7          	jalr	-1028(ra) # 800005aa <printf>
        return;
    800029b6:	b7e5                	j	8000299e <schedset+0x40>

00000000800029b8 <swtch>:
    800029b8:	00153023          	sd	ra,0(a0)
    800029bc:	00253423          	sd	sp,8(a0)
    800029c0:	e900                	sd	s0,16(a0)
    800029c2:	ed04                	sd	s1,24(a0)
    800029c4:	03253023          	sd	s2,32(a0)
    800029c8:	03353423          	sd	s3,40(a0)
    800029cc:	03453823          	sd	s4,48(a0)
    800029d0:	03553c23          	sd	s5,56(a0)
    800029d4:	05653023          	sd	s6,64(a0)
    800029d8:	05753423          	sd	s7,72(a0)
    800029dc:	05853823          	sd	s8,80(a0)
    800029e0:	05953c23          	sd	s9,88(a0)
    800029e4:	07a53023          	sd	s10,96(a0)
    800029e8:	07b53423          	sd	s11,104(a0)
    800029ec:	0005b083          	ld	ra,0(a1)
    800029f0:	0085b103          	ld	sp,8(a1)
    800029f4:	6980                	ld	s0,16(a1)
    800029f6:	6d84                	ld	s1,24(a1)
    800029f8:	0205b903          	ld	s2,32(a1)
    800029fc:	0285b983          	ld	s3,40(a1)
    80002a00:	0305ba03          	ld	s4,48(a1)
    80002a04:	0385ba83          	ld	s5,56(a1)
    80002a08:	0405bb03          	ld	s6,64(a1)
    80002a0c:	0485bb83          	ld	s7,72(a1)
    80002a10:	0505bc03          	ld	s8,80(a1)
    80002a14:	0585bc83          	ld	s9,88(a1)
    80002a18:	0605bd03          	ld	s10,96(a1)
    80002a1c:	0685bd83          	ld	s11,104(a1)
    80002a20:	8082                	ret

0000000080002a22 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002a22:	1141                	addi	sp,sp,-16
    80002a24:	e406                	sd	ra,8(sp)
    80002a26:	e022                	sd	s0,0(sp)
    80002a28:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002a2a:	00006597          	auipc	a1,0x6
    80002a2e:	96658593          	addi	a1,a1,-1690 # 80008390 <etext+0x390>
    80002a32:	00017517          	auipc	a0,0x17
    80002a36:	b1e50513          	addi	a0,a0,-1250 # 80019550 <tickslock>
    80002a3a:	ffffe097          	auipc	ra,0xffffe
    80002a3e:	16e080e7          	jalr	366(ra) # 80000ba8 <initlock>
}
    80002a42:	60a2                	ld	ra,8(sp)
    80002a44:	6402                	ld	s0,0(sp)
    80002a46:	0141                	addi	sp,sp,16
    80002a48:	8082                	ret

0000000080002a4a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002a4a:	1141                	addi	sp,sp,-16
    80002a4c:	e422                	sd	s0,8(sp)
    80002a4e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a50:	00003797          	auipc	a5,0x3
    80002a54:	65078793          	addi	a5,a5,1616 # 800060a0 <kernelvec>
    80002a58:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002a5c:	6422                	ld	s0,8(sp)
    80002a5e:	0141                	addi	sp,sp,16
    80002a60:	8082                	ret

0000000080002a62 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002a62:	1141                	addi	sp,sp,-16
    80002a64:	e406                	sd	ra,8(sp)
    80002a66:	e022                	sd	s0,0(sp)
    80002a68:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002a6a:	fffff097          	auipc	ra,0xfffff
    80002a6e:	0cc080e7          	jalr	204(ra) # 80001b36 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a78:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002a7c:	00004697          	auipc	a3,0x4
    80002a80:	58468693          	addi	a3,a3,1412 # 80007000 <_trampoline>
    80002a84:	00004717          	auipc	a4,0x4
    80002a88:	57c70713          	addi	a4,a4,1404 # 80007000 <_trampoline>
    80002a8c:	8f15                	sub	a4,a4,a3
    80002a8e:	040007b7          	lui	a5,0x4000
    80002a92:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002a94:	07b2                	slli	a5,a5,0xc
    80002a96:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a98:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a9c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a9e:	18002673          	csrr	a2,satp
    80002aa2:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002aa4:	6d30                	ld	a2,88(a0)
    80002aa6:	6138                	ld	a4,64(a0)
    80002aa8:	6585                	lui	a1,0x1
    80002aaa:	972e                	add	a4,a4,a1
    80002aac:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002aae:	6d38                	ld	a4,88(a0)
    80002ab0:	00000617          	auipc	a2,0x0
    80002ab4:	13860613          	addi	a2,a2,312 # 80002be8 <usertrap>
    80002ab8:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002aba:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002abc:	8612                	mv	a2,tp
    80002abe:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ac0:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ac4:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ac8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002acc:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002ad0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ad2:	6f18                	ld	a4,24(a4)
    80002ad4:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002ad8:	6928                	ld	a0,80(a0)
    80002ada:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002adc:	00004717          	auipc	a4,0x4
    80002ae0:	5c070713          	addi	a4,a4,1472 # 8000709c <userret>
    80002ae4:	8f15                	sub	a4,a4,a3
    80002ae6:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002ae8:	577d                	li	a4,-1
    80002aea:	177e                	slli	a4,a4,0x3f
    80002aec:	8d59                	or	a0,a0,a4
    80002aee:	9782                	jalr	a5
}
    80002af0:	60a2                	ld	ra,8(sp)
    80002af2:	6402                	ld	s0,0(sp)
    80002af4:	0141                	addi	sp,sp,16
    80002af6:	8082                	ret

0000000080002af8 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002b02:	00017497          	auipc	s1,0x17
    80002b06:	a4e48493          	addi	s1,s1,-1458 # 80019550 <tickslock>
    80002b0a:	8526                	mv	a0,s1
    80002b0c:	ffffe097          	auipc	ra,0xffffe
    80002b10:	12c080e7          	jalr	300(ra) # 80000c38 <acquire>
    ticks++;
    80002b14:	00009517          	auipc	a0,0x9
    80002b18:	99c50513          	addi	a0,a0,-1636 # 8000b4b0 <ticks>
    80002b1c:	411c                	lw	a5,0(a0)
    80002b1e:	2785                	addiw	a5,a5,1
    80002b20:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	850080e7          	jalr	-1968(ra) # 80002372 <wakeup>
    release(&tickslock);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	ffffe097          	auipc	ra,0xffffe
    80002b30:	1c0080e7          	jalr	448(ra) # 80000cec <release>
}
    80002b34:	60e2                	ld	ra,24(sp)
    80002b36:	6442                	ld	s0,16(sp)
    80002b38:	64a2                	ld	s1,8(sp)
    80002b3a:	6105                	addi	sp,sp,32
    80002b3c:	8082                	ret

0000000080002b3e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b3e:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002b42:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002b44:	0a07d163          	bgez	a5,80002be6 <devintr+0xa8>
{
    80002b48:	1101                	addi	sp,sp,-32
    80002b4a:	ec06                	sd	ra,24(sp)
    80002b4c:	e822                	sd	s0,16(sp)
    80002b4e:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002b50:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002b54:	46a5                	li	a3,9
    80002b56:	00d70c63          	beq	a4,a3,80002b6e <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002b5a:	577d                	li	a4,-1
    80002b5c:	177e                	slli	a4,a4,0x3f
    80002b5e:	0705                	addi	a4,a4,1
        return 0;
    80002b60:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002b62:	06e78163          	beq	a5,a4,80002bc4 <devintr+0x86>
    }
}
    80002b66:	60e2                	ld	ra,24(sp)
    80002b68:	6442                	ld	s0,16(sp)
    80002b6a:	6105                	addi	sp,sp,32
    80002b6c:	8082                	ret
    80002b6e:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002b70:	00003097          	auipc	ra,0x3
    80002b74:	63c080e7          	jalr	1596(ra) # 800061ac <plic_claim>
    80002b78:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002b7a:	47a9                	li	a5,10
    80002b7c:	00f50963          	beq	a0,a5,80002b8e <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002b80:	4785                	li	a5,1
    80002b82:	00f50b63          	beq	a0,a5,80002b98 <devintr+0x5a>
        return 1;
    80002b86:	4505                	li	a0,1
        else if (irq)
    80002b88:	ec89                	bnez	s1,80002ba2 <devintr+0x64>
    80002b8a:	64a2                	ld	s1,8(sp)
    80002b8c:	bfe9                	j	80002b66 <devintr+0x28>
            uartintr();
    80002b8e:	ffffe097          	auipc	ra,0xffffe
    80002b92:	e6c080e7          	jalr	-404(ra) # 800009fa <uartintr>
        if (irq)
    80002b96:	a839                	j	80002bb4 <devintr+0x76>
            virtio_disk_intr();
    80002b98:	00004097          	auipc	ra,0x4
    80002b9c:	b3e080e7          	jalr	-1218(ra) # 800066d6 <virtio_disk_intr>
        if (irq)
    80002ba0:	a811                	j	80002bb4 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002ba2:	85a6                	mv	a1,s1
    80002ba4:	00005517          	auipc	a0,0x5
    80002ba8:	7f450513          	addi	a0,a0,2036 # 80008398 <etext+0x398>
    80002bac:	ffffe097          	auipc	ra,0xffffe
    80002bb0:	9fe080e7          	jalr	-1538(ra) # 800005aa <printf>
            plic_complete(irq);
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	00003097          	auipc	ra,0x3
    80002bba:	61a080e7          	jalr	1562(ra) # 800061d0 <plic_complete>
        return 1;
    80002bbe:	4505                	li	a0,1
    80002bc0:	64a2                	ld	s1,8(sp)
    80002bc2:	b755                	j	80002b66 <devintr+0x28>
        if (cpuid() == 0)
    80002bc4:	fffff097          	auipc	ra,0xfffff
    80002bc8:	f46080e7          	jalr	-186(ra) # 80001b0a <cpuid>
    80002bcc:	c901                	beqz	a0,80002bdc <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002bce:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002bd2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002bd4:	14479073          	csrw	sip,a5
        return 2;
    80002bd8:	4509                	li	a0,2
    80002bda:	b771                	j	80002b66 <devintr+0x28>
            clockintr();
    80002bdc:	00000097          	auipc	ra,0x0
    80002be0:	f1c080e7          	jalr	-228(ra) # 80002af8 <clockintr>
    80002be4:	b7ed                	j	80002bce <devintr+0x90>
}
    80002be6:	8082                	ret

0000000080002be8 <usertrap>:
{
    80002be8:	1101                	addi	sp,sp,-32
    80002bea:	ec06                	sd	ra,24(sp)
    80002bec:	e822                	sd	s0,16(sp)
    80002bee:	e426                	sd	s1,8(sp)
    80002bf0:	e04a                	sd	s2,0(sp)
    80002bf2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bf4:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002bf8:	1007f793          	andi	a5,a5,256
    80002bfc:	e3b1                	bnez	a5,80002c40 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bfe:	00003797          	auipc	a5,0x3
    80002c02:	4a278793          	addi	a5,a5,1186 # 800060a0 <kernelvec>
    80002c06:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002c0a:	fffff097          	auipc	ra,0xfffff
    80002c0e:	f2c080e7          	jalr	-212(ra) # 80001b36 <myproc>
    80002c12:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002c14:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c16:	14102773          	csrr	a4,sepc
    80002c1a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c1c:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002c20:	47a1                	li	a5,8
    80002c22:	02f70763          	beq	a4,a5,80002c50 <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	f18080e7          	jalr	-232(ra) # 80002b3e <devintr>
    80002c2e:	892a                	mv	s2,a0
    80002c30:	c151                	beqz	a0,80002cb4 <usertrap+0xcc>
    if (killed(p))
    80002c32:	8526                	mv	a0,s1
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	982080e7          	jalr	-1662(ra) # 800025b6 <killed>
    80002c3c:	c929                	beqz	a0,80002c8e <usertrap+0xa6>
    80002c3e:	a099                	j	80002c84 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002c40:	00005517          	auipc	a0,0x5
    80002c44:	77850513          	addi	a0,a0,1912 # 800083b8 <etext+0x3b8>
    80002c48:	ffffe097          	auipc	ra,0xffffe
    80002c4c:	918080e7          	jalr	-1768(ra) # 80000560 <panic>
        if (killed(p))
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	966080e7          	jalr	-1690(ra) # 800025b6 <killed>
    80002c58:	e921                	bnez	a0,80002ca8 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002c5a:	6cb8                	ld	a4,88(s1)
    80002c5c:	6f1c                	ld	a5,24(a4)
    80002c5e:	0791                	addi	a5,a5,4
    80002c60:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c6a:	10079073          	csrw	sstatus,a5
        syscall();
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	2d8080e7          	jalr	728(ra) # 80002f46 <syscall>
    if (killed(p))
    80002c76:	8526                	mv	a0,s1
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	93e080e7          	jalr	-1730(ra) # 800025b6 <killed>
    80002c80:	c911                	beqz	a0,80002c94 <usertrap+0xac>
    80002c82:	4901                	li	s2,0
        exit(-1);
    80002c84:	557d                	li	a0,-1
    80002c86:	fffff097          	auipc	ra,0xfffff
    80002c8a:	7bc080e7          	jalr	1980(ra) # 80002442 <exit>
    if (which_dev == 2)
    80002c8e:	4789                	li	a5,2
    80002c90:	04f90f63          	beq	s2,a5,80002cee <usertrap+0x106>
    usertrapret();
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	dce080e7          	jalr	-562(ra) # 80002a62 <usertrapret>
}
    80002c9c:	60e2                	ld	ra,24(sp)
    80002c9e:	6442                	ld	s0,16(sp)
    80002ca0:	64a2                	ld	s1,8(sp)
    80002ca2:	6902                	ld	s2,0(sp)
    80002ca4:	6105                	addi	sp,sp,32
    80002ca6:	8082                	ret
            exit(-1);
    80002ca8:	557d                	li	a0,-1
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	798080e7          	jalr	1944(ra) # 80002442 <exit>
    80002cb2:	b765                	j	80002c5a <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cb4:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002cb8:	5890                	lw	a2,48(s1)
    80002cba:	00005517          	auipc	a0,0x5
    80002cbe:	71e50513          	addi	a0,a0,1822 # 800083d8 <etext+0x3d8>
    80002cc2:	ffffe097          	auipc	ra,0xffffe
    80002cc6:	8e8080e7          	jalr	-1816(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cca:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cce:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002cd2:	00005517          	auipc	a0,0x5
    80002cd6:	73650513          	addi	a0,a0,1846 # 80008408 <etext+0x408>
    80002cda:	ffffe097          	auipc	ra,0xffffe
    80002cde:	8d0080e7          	jalr	-1840(ra) # 800005aa <printf>
        setkilled(p);
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	8a6080e7          	jalr	-1882(ra) # 8000258a <setkilled>
    80002cec:	b769                	j	80002c76 <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002cee:	4505                	li	a0,1
    80002cf0:	fffff097          	auipc	ra,0xfffff
    80002cf4:	5e2080e7          	jalr	1506(ra) # 800022d2 <yield>
    80002cf8:	bf71                	j	80002c94 <usertrap+0xac>

0000000080002cfa <kerneltrap>:
{
    80002cfa:	7179                	addi	sp,sp,-48
    80002cfc:	f406                	sd	ra,40(sp)
    80002cfe:	f022                	sd	s0,32(sp)
    80002d00:	ec26                	sd	s1,24(sp)
    80002d02:	e84a                	sd	s2,16(sp)
    80002d04:	e44e                	sd	s3,8(sp)
    80002d06:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d08:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d0c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d10:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002d14:	1004f793          	andi	a5,s1,256
    80002d18:	cb85                	beqz	a5,80002d48 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d1a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d1e:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002d20:	ef85                	bnez	a5,80002d58 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	e1c080e7          	jalr	-484(ra) # 80002b3e <devintr>
    80002d2a:	cd1d                	beqz	a0,80002d68 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d2c:	4789                	li	a5,2
    80002d2e:	06f50a63          	beq	a0,a5,80002da2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d32:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d36:	10049073          	csrw	sstatus,s1
}
    80002d3a:	70a2                	ld	ra,40(sp)
    80002d3c:	7402                	ld	s0,32(sp)
    80002d3e:	64e2                	ld	s1,24(sp)
    80002d40:	6942                	ld	s2,16(sp)
    80002d42:	69a2                	ld	s3,8(sp)
    80002d44:	6145                	addi	sp,sp,48
    80002d46:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002d48:	00005517          	auipc	a0,0x5
    80002d4c:	6e050513          	addi	a0,a0,1760 # 80008428 <etext+0x428>
    80002d50:	ffffe097          	auipc	ra,0xffffe
    80002d54:	810080e7          	jalr	-2032(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002d58:	00005517          	auipc	a0,0x5
    80002d5c:	6f850513          	addi	a0,a0,1784 # 80008450 <etext+0x450>
    80002d60:	ffffe097          	auipc	ra,0xffffe
    80002d64:	800080e7          	jalr	-2048(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002d68:	85ce                	mv	a1,s3
    80002d6a:	00005517          	auipc	a0,0x5
    80002d6e:	70650513          	addi	a0,a0,1798 # 80008470 <etext+0x470>
    80002d72:	ffffe097          	auipc	ra,0xffffe
    80002d76:	838080e7          	jalr	-1992(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d7e:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d82:	00005517          	auipc	a0,0x5
    80002d86:	6fe50513          	addi	a0,a0,1790 # 80008480 <etext+0x480>
    80002d8a:	ffffe097          	auipc	ra,0xffffe
    80002d8e:	820080e7          	jalr	-2016(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002d92:	00005517          	auipc	a0,0x5
    80002d96:	70650513          	addi	a0,a0,1798 # 80008498 <etext+0x498>
    80002d9a:	ffffd097          	auipc	ra,0xffffd
    80002d9e:	7c6080e7          	jalr	1990(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002da2:	fffff097          	auipc	ra,0xfffff
    80002da6:	d94080e7          	jalr	-620(ra) # 80001b36 <myproc>
    80002daa:	d541                	beqz	a0,80002d32 <kerneltrap+0x38>
    80002dac:	fffff097          	auipc	ra,0xfffff
    80002db0:	d8a080e7          	jalr	-630(ra) # 80001b36 <myproc>
    80002db4:	4d18                	lw	a4,24(a0)
    80002db6:	4791                	li	a5,4
    80002db8:	f6f71de3          	bne	a4,a5,80002d32 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002dbc:	4509                	li	a0,2
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	514080e7          	jalr	1300(ra) # 800022d2 <yield>
    80002dc6:	b7b5                	j	80002d32 <kerneltrap+0x38>

0000000080002dc8 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002dc8:	1101                	addi	sp,sp,-32
    80002dca:	ec06                	sd	ra,24(sp)
    80002dcc:	e822                	sd	s0,16(sp)
    80002dce:	e426                	sd	s1,8(sp)
    80002dd0:	1000                	addi	s0,sp,32
    80002dd2:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	d62080e7          	jalr	-670(ra) # 80001b36 <myproc>
    switch (n)
    80002ddc:	4795                	li	a5,5
    80002dde:	0497e163          	bltu	a5,s1,80002e20 <argraw+0x58>
    80002de2:	048a                	slli	s1,s1,0x2
    80002de4:	00006717          	auipc	a4,0x6
    80002de8:	a7470713          	addi	a4,a4,-1420 # 80008858 <states.0+0x30>
    80002dec:	94ba                	add	s1,s1,a4
    80002dee:	409c                	lw	a5,0(s1)
    80002df0:	97ba                	add	a5,a5,a4
    80002df2:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002df4:	6d3c                	ld	a5,88(a0)
    80002df6:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6105                	addi	sp,sp,32
    80002e00:	8082                	ret
        return p->trapframe->a1;
    80002e02:	6d3c                	ld	a5,88(a0)
    80002e04:	7fa8                	ld	a0,120(a5)
    80002e06:	bfcd                	j	80002df8 <argraw+0x30>
        return p->trapframe->a2;
    80002e08:	6d3c                	ld	a5,88(a0)
    80002e0a:	63c8                	ld	a0,128(a5)
    80002e0c:	b7f5                	j	80002df8 <argraw+0x30>
        return p->trapframe->a3;
    80002e0e:	6d3c                	ld	a5,88(a0)
    80002e10:	67c8                	ld	a0,136(a5)
    80002e12:	b7dd                	j	80002df8 <argraw+0x30>
        return p->trapframe->a4;
    80002e14:	6d3c                	ld	a5,88(a0)
    80002e16:	6bc8                	ld	a0,144(a5)
    80002e18:	b7c5                	j	80002df8 <argraw+0x30>
        return p->trapframe->a5;
    80002e1a:	6d3c                	ld	a5,88(a0)
    80002e1c:	6fc8                	ld	a0,152(a5)
    80002e1e:	bfe9                	j	80002df8 <argraw+0x30>
    panic("argraw");
    80002e20:	00005517          	auipc	a0,0x5
    80002e24:	68850513          	addi	a0,a0,1672 # 800084a8 <etext+0x4a8>
    80002e28:	ffffd097          	auipc	ra,0xffffd
    80002e2c:	738080e7          	jalr	1848(ra) # 80000560 <panic>

0000000080002e30 <fetchaddr>:
{
    80002e30:	1101                	addi	sp,sp,-32
    80002e32:	ec06                	sd	ra,24(sp)
    80002e34:	e822                	sd	s0,16(sp)
    80002e36:	e426                	sd	s1,8(sp)
    80002e38:	e04a                	sd	s2,0(sp)
    80002e3a:	1000                	addi	s0,sp,32
    80002e3c:	84aa                	mv	s1,a0
    80002e3e:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	cf6080e7          	jalr	-778(ra) # 80001b36 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002e48:	653c                	ld	a5,72(a0)
    80002e4a:	02f4f863          	bgeu	s1,a5,80002e7a <fetchaddr+0x4a>
    80002e4e:	00848713          	addi	a4,s1,8
    80002e52:	02e7e663          	bltu	a5,a4,80002e7e <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e56:	46a1                	li	a3,8
    80002e58:	8626                	mv	a2,s1
    80002e5a:	85ca                	mv	a1,s2
    80002e5c:	6928                	ld	a0,80(a0)
    80002e5e:	fffff097          	auipc	ra,0xfffff
    80002e62:	910080e7          	jalr	-1776(ra) # 8000176e <copyin>
    80002e66:	00a03533          	snez	a0,a0
    80002e6a:	40a00533          	neg	a0,a0
}
    80002e6e:	60e2                	ld	ra,24(sp)
    80002e70:	6442                	ld	s0,16(sp)
    80002e72:	64a2                	ld	s1,8(sp)
    80002e74:	6902                	ld	s2,0(sp)
    80002e76:	6105                	addi	sp,sp,32
    80002e78:	8082                	ret
        return -1;
    80002e7a:	557d                	li	a0,-1
    80002e7c:	bfcd                	j	80002e6e <fetchaddr+0x3e>
    80002e7e:	557d                	li	a0,-1
    80002e80:	b7fd                	j	80002e6e <fetchaddr+0x3e>

0000000080002e82 <fetchstr>:
{
    80002e82:	7179                	addi	sp,sp,-48
    80002e84:	f406                	sd	ra,40(sp)
    80002e86:	f022                	sd	s0,32(sp)
    80002e88:	ec26                	sd	s1,24(sp)
    80002e8a:	e84a                	sd	s2,16(sp)
    80002e8c:	e44e                	sd	s3,8(sp)
    80002e8e:	1800                	addi	s0,sp,48
    80002e90:	892a                	mv	s2,a0
    80002e92:	84ae                	mv	s1,a1
    80002e94:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	ca0080e7          	jalr	-864(ra) # 80001b36 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002e9e:	86ce                	mv	a3,s3
    80002ea0:	864a                	mv	a2,s2
    80002ea2:	85a6                	mv	a1,s1
    80002ea4:	6928                	ld	a0,80(a0)
    80002ea6:	fffff097          	auipc	ra,0xfffff
    80002eaa:	956080e7          	jalr	-1706(ra) # 800017fc <copyinstr>
    80002eae:	00054e63          	bltz	a0,80002eca <fetchstr+0x48>
    return strlen(buf);
    80002eb2:	8526                	mv	a0,s1
    80002eb4:	ffffe097          	auipc	ra,0xffffe
    80002eb8:	ff4080e7          	jalr	-12(ra) # 80000ea8 <strlen>
}
    80002ebc:	70a2                	ld	ra,40(sp)
    80002ebe:	7402                	ld	s0,32(sp)
    80002ec0:	64e2                	ld	s1,24(sp)
    80002ec2:	6942                	ld	s2,16(sp)
    80002ec4:	69a2                	ld	s3,8(sp)
    80002ec6:	6145                	addi	sp,sp,48
    80002ec8:	8082                	ret
        return -1;
    80002eca:	557d                	li	a0,-1
    80002ecc:	bfc5                	j	80002ebc <fetchstr+0x3a>

0000000080002ece <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002ece:	1101                	addi	sp,sp,-32
    80002ed0:	ec06                	sd	ra,24(sp)
    80002ed2:	e822                	sd	s0,16(sp)
    80002ed4:	e426                	sd	s1,8(sp)
    80002ed6:	1000                	addi	s0,sp,32
    80002ed8:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002eda:	00000097          	auipc	ra,0x0
    80002ede:	eee080e7          	jalr	-274(ra) # 80002dc8 <argraw>
    80002ee2:	c088                	sw	a0,0(s1)
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6105                	addi	sp,sp,32
    80002eec:	8082                	ret

0000000080002eee <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002eee:	1101                	addi	sp,sp,-32
    80002ef0:	ec06                	sd	ra,24(sp)
    80002ef2:	e822                	sd	s0,16(sp)
    80002ef4:	e426                	sd	s1,8(sp)
    80002ef6:	1000                	addi	s0,sp,32
    80002ef8:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	ece080e7          	jalr	-306(ra) # 80002dc8 <argraw>
    80002f02:	e088                	sd	a0,0(s1)
}
    80002f04:	60e2                	ld	ra,24(sp)
    80002f06:	6442                	ld	s0,16(sp)
    80002f08:	64a2                	ld	s1,8(sp)
    80002f0a:	6105                	addi	sp,sp,32
    80002f0c:	8082                	ret

0000000080002f0e <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002f0e:	7179                	addi	sp,sp,-48
    80002f10:	f406                	sd	ra,40(sp)
    80002f12:	f022                	sd	s0,32(sp)
    80002f14:	ec26                	sd	s1,24(sp)
    80002f16:	e84a                	sd	s2,16(sp)
    80002f18:	1800                	addi	s0,sp,48
    80002f1a:	84ae                	mv	s1,a1
    80002f1c:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002f1e:	fd840593          	addi	a1,s0,-40
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	fcc080e7          	jalr	-52(ra) # 80002eee <argaddr>
    return fetchstr(addr, buf, max);
    80002f2a:	864a                	mv	a2,s2
    80002f2c:	85a6                	mv	a1,s1
    80002f2e:	fd843503          	ld	a0,-40(s0)
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	f50080e7          	jalr	-176(ra) # 80002e82 <fetchstr>
}
    80002f3a:	70a2                	ld	ra,40(sp)
    80002f3c:	7402                	ld	s0,32(sp)
    80002f3e:	64e2                	ld	s1,24(sp)
    80002f40:	6942                	ld	s2,16(sp)
    80002f42:	6145                	addi	sp,sp,48
    80002f44:	8082                	ret

0000000080002f46 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    80002f46:	1101                	addi	sp,sp,-32
    80002f48:	ec06                	sd	ra,24(sp)
    80002f4a:	e822                	sd	s0,16(sp)
    80002f4c:	e426                	sd	s1,8(sp)
    80002f4e:	e04a                	sd	s2,0(sp)
    80002f50:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	be4080e7          	jalr	-1052(ra) # 80001b36 <myproc>
    80002f5a:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002f5c:	05853903          	ld	s2,88(a0)
    80002f60:	0a893783          	ld	a5,168(s2)
    80002f64:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002f68:	37fd                	addiw	a5,a5,-1
    80002f6a:	4761                	li	a4,24
    80002f6c:	00f76f63          	bltu	a4,a5,80002f8a <syscall+0x44>
    80002f70:	00369713          	slli	a4,a3,0x3
    80002f74:	00006797          	auipc	a5,0x6
    80002f78:	8fc78793          	addi	a5,a5,-1796 # 80008870 <syscalls>
    80002f7c:	97ba                	add	a5,a5,a4
    80002f7e:	639c                	ld	a5,0(a5)
    80002f80:	c789                	beqz	a5,80002f8a <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002f82:	9782                	jalr	a5
    80002f84:	06a93823          	sd	a0,112(s2)
    80002f88:	a839                	j	80002fa6 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002f8a:	15848613          	addi	a2,s1,344
    80002f8e:	588c                	lw	a1,48(s1)
    80002f90:	00005517          	auipc	a0,0x5
    80002f94:	52050513          	addi	a0,a0,1312 # 800084b0 <etext+0x4b0>
    80002f98:	ffffd097          	auipc	ra,0xffffd
    80002f9c:	612080e7          	jalr	1554(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002fa0:	6cbc                	ld	a5,88(s1)
    80002fa2:	577d                	li	a4,-1
    80002fa4:	fbb8                	sd	a4,112(a5)
    }
}
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	64a2                	ld	s1,8(sp)
    80002fac:	6902                	ld	s2,0(sp)
    80002fae:	6105                	addi	sp,sp,32
    80002fb0:	8082                	ret

0000000080002fb2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002fb2:	1101                	addi	sp,sp,-32
    80002fb4:	ec06                	sd	ra,24(sp)
    80002fb6:	e822                	sd	s0,16(sp)
    80002fb8:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80002fba:	fec40593          	addi	a1,s0,-20
    80002fbe:	4501                	li	a0,0
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	f0e080e7          	jalr	-242(ra) # 80002ece <argint>
    exit(n);
    80002fc8:	fec42503          	lw	a0,-20(s0)
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	476080e7          	jalr	1142(ra) # 80002442 <exit>
    return 0; // not reached
}
    80002fd4:	4501                	li	a0,0
    80002fd6:	60e2                	ld	ra,24(sp)
    80002fd8:	6442                	ld	s0,16(sp)
    80002fda:	6105                	addi	sp,sp,32
    80002fdc:	8082                	ret

0000000080002fde <sys_getpid>:

uint64
sys_getpid(void)
{
    80002fde:	1141                	addi	sp,sp,-16
    80002fe0:	e406                	sd	ra,8(sp)
    80002fe2:	e022                	sd	s0,0(sp)
    80002fe4:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	b50080e7          	jalr	-1200(ra) # 80001b36 <myproc>
}
    80002fee:	5908                	lw	a0,48(a0)
    80002ff0:	60a2                	ld	ra,8(sp)
    80002ff2:	6402                	ld	s0,0(sp)
    80002ff4:	0141                	addi	sp,sp,16
    80002ff6:	8082                	ret

0000000080002ff8 <sys_fork>:

uint64
sys_fork(void)
{
    80002ff8:	1141                	addi	sp,sp,-16
    80002ffa:	e406                	sd	ra,8(sp)
    80002ffc:	e022                	sd	s0,0(sp)
    80002ffe:	0800                	addi	s0,sp,16
    return fork();
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	084080e7          	jalr	132(ra) # 80002084 <fork>
}
    80003008:	60a2                	ld	ra,8(sp)
    8000300a:	6402                	ld	s0,0(sp)
    8000300c:	0141                	addi	sp,sp,16
    8000300e:	8082                	ret

0000000080003010 <sys_wait>:

uint64
sys_wait(void)
{
    80003010:	1101                	addi	sp,sp,-32
    80003012:	ec06                	sd	ra,24(sp)
    80003014:	e822                	sd	s0,16(sp)
    80003016:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80003018:	fe840593          	addi	a1,s0,-24
    8000301c:	4501                	li	a0,0
    8000301e:	00000097          	auipc	ra,0x0
    80003022:	ed0080e7          	jalr	-304(ra) # 80002eee <argaddr>
    return wait(p);
    80003026:	fe843503          	ld	a0,-24(s0)
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	5be080e7          	jalr	1470(ra) # 800025e8 <wait>
}
    80003032:	60e2                	ld	ra,24(sp)
    80003034:	6442                	ld	s0,16(sp)
    80003036:	6105                	addi	sp,sp,32
    80003038:	8082                	ret

000000008000303a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000303a:	7179                	addi	sp,sp,-48
    8000303c:	f406                	sd	ra,40(sp)
    8000303e:	f022                	sd	s0,32(sp)
    80003040:	ec26                	sd	s1,24(sp)
    80003042:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003044:	fdc40593          	addi	a1,s0,-36
    80003048:	4501                	li	a0,0
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	e84080e7          	jalr	-380(ra) # 80002ece <argint>
    addr = myproc()->sz;
    80003052:	fffff097          	auipc	ra,0xfffff
    80003056:	ae4080e7          	jalr	-1308(ra) # 80001b36 <myproc>
    8000305a:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    8000305c:	fdc42503          	lw	a0,-36(s0)
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	e30080e7          	jalr	-464(ra) # 80001e90 <growproc>
    80003068:	00054863          	bltz	a0,80003078 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000306c:	8526                	mv	a0,s1
    8000306e:	70a2                	ld	ra,40(sp)
    80003070:	7402                	ld	s0,32(sp)
    80003072:	64e2                	ld	s1,24(sp)
    80003074:	6145                	addi	sp,sp,48
    80003076:	8082                	ret
        return -1;
    80003078:	54fd                	li	s1,-1
    8000307a:	bfcd                	j	8000306c <sys_sbrk+0x32>

000000008000307c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000307c:	7139                	addi	sp,sp,-64
    8000307e:	fc06                	sd	ra,56(sp)
    80003080:	f822                	sd	s0,48(sp)
    80003082:	f04a                	sd	s2,32(sp)
    80003084:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003086:	fcc40593          	addi	a1,s0,-52
    8000308a:	4501                	li	a0,0
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	e42080e7          	jalr	-446(ra) # 80002ece <argint>
    acquire(&tickslock);
    80003094:	00016517          	auipc	a0,0x16
    80003098:	4bc50513          	addi	a0,a0,1212 # 80019550 <tickslock>
    8000309c:	ffffe097          	auipc	ra,0xffffe
    800030a0:	b9c080e7          	jalr	-1124(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    800030a4:	00008917          	auipc	s2,0x8
    800030a8:	40c92903          	lw	s2,1036(s2) # 8000b4b0 <ticks>
    while (ticks - ticks0 < n)
    800030ac:	fcc42783          	lw	a5,-52(s0)
    800030b0:	c3b9                	beqz	a5,800030f6 <sys_sleep+0x7a>
    800030b2:	f426                	sd	s1,40(sp)
    800030b4:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800030b6:	00016997          	auipc	s3,0x16
    800030ba:	49a98993          	addi	s3,s3,1178 # 80019550 <tickslock>
    800030be:	00008497          	auipc	s1,0x8
    800030c2:	3f248493          	addi	s1,s1,1010 # 8000b4b0 <ticks>
        if (killed(myproc()))
    800030c6:	fffff097          	auipc	ra,0xfffff
    800030ca:	a70080e7          	jalr	-1424(ra) # 80001b36 <myproc>
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	4e8080e7          	jalr	1256(ra) # 800025b6 <killed>
    800030d6:	ed15                	bnez	a0,80003112 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    800030d8:	85ce                	mv	a1,s3
    800030da:	8526                	mv	a0,s1
    800030dc:	fffff097          	auipc	ra,0xfffff
    800030e0:	232080e7          	jalr	562(ra) # 8000230e <sleep>
    while (ticks - ticks0 < n)
    800030e4:	409c                	lw	a5,0(s1)
    800030e6:	412787bb          	subw	a5,a5,s2
    800030ea:	fcc42703          	lw	a4,-52(s0)
    800030ee:	fce7ece3          	bltu	a5,a4,800030c6 <sys_sleep+0x4a>
    800030f2:	74a2                	ld	s1,40(sp)
    800030f4:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800030f6:	00016517          	auipc	a0,0x16
    800030fa:	45a50513          	addi	a0,a0,1114 # 80019550 <tickslock>
    800030fe:	ffffe097          	auipc	ra,0xffffe
    80003102:	bee080e7          	jalr	-1042(ra) # 80000cec <release>
    return 0;
    80003106:	4501                	li	a0,0
}
    80003108:	70e2                	ld	ra,56(sp)
    8000310a:	7442                	ld	s0,48(sp)
    8000310c:	7902                	ld	s2,32(sp)
    8000310e:	6121                	addi	sp,sp,64
    80003110:	8082                	ret
            release(&tickslock);
    80003112:	00016517          	auipc	a0,0x16
    80003116:	43e50513          	addi	a0,a0,1086 # 80019550 <tickslock>
    8000311a:	ffffe097          	auipc	ra,0xffffe
    8000311e:	bd2080e7          	jalr	-1070(ra) # 80000cec <release>
            return -1;
    80003122:	557d                	li	a0,-1
    80003124:	74a2                	ld	s1,40(sp)
    80003126:	69e2                	ld	s3,24(sp)
    80003128:	b7c5                	j	80003108 <sys_sleep+0x8c>

000000008000312a <sys_kill>:

uint64
sys_kill(void)
{
    8000312a:	1101                	addi	sp,sp,-32
    8000312c:	ec06                	sd	ra,24(sp)
    8000312e:	e822                	sd	s0,16(sp)
    80003130:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80003132:	fec40593          	addi	a1,s0,-20
    80003136:	4501                	li	a0,0
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	d96080e7          	jalr	-618(ra) # 80002ece <argint>
    return kill(pid);
    80003140:	fec42503          	lw	a0,-20(s0)
    80003144:	fffff097          	auipc	ra,0xfffff
    80003148:	3d4080e7          	jalr	980(ra) # 80002518 <kill>
}
    8000314c:	60e2                	ld	ra,24(sp)
    8000314e:	6442                	ld	s0,16(sp)
    80003150:	6105                	addi	sp,sp,32
    80003152:	8082                	ret

0000000080003154 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003154:	1101                	addi	sp,sp,-32
    80003156:	ec06                	sd	ra,24(sp)
    80003158:	e822                	sd	s0,16(sp)
    8000315a:	e426                	sd	s1,8(sp)
    8000315c:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000315e:	00016517          	auipc	a0,0x16
    80003162:	3f250513          	addi	a0,a0,1010 # 80019550 <tickslock>
    80003166:	ffffe097          	auipc	ra,0xffffe
    8000316a:	ad2080e7          	jalr	-1326(ra) # 80000c38 <acquire>
    xticks = ticks;
    8000316e:	00008497          	auipc	s1,0x8
    80003172:	3424a483          	lw	s1,834(s1) # 8000b4b0 <ticks>
    release(&tickslock);
    80003176:	00016517          	auipc	a0,0x16
    8000317a:	3da50513          	addi	a0,a0,986 # 80019550 <tickslock>
    8000317e:	ffffe097          	auipc	ra,0xffffe
    80003182:	b6e080e7          	jalr	-1170(ra) # 80000cec <release>
    return xticks;
}
    80003186:	02049513          	slli	a0,s1,0x20
    8000318a:	9101                	srli	a0,a0,0x20
    8000318c:	60e2                	ld	ra,24(sp)
    8000318e:	6442                	ld	s0,16(sp)
    80003190:	64a2                	ld	s1,8(sp)
    80003192:	6105                	addi	sp,sp,32
    80003194:	8082                	ret

0000000080003196 <sys_ps>:

void *
sys_ps(void)
{
    80003196:	1101                	addi	sp,sp,-32
    80003198:	ec06                	sd	ra,24(sp)
    8000319a:	e822                	sd	s0,16(sp)
    8000319c:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    8000319e:	fe042623          	sw	zero,-20(s0)
    800031a2:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    800031a6:	fec40593          	addi	a1,s0,-20
    800031aa:	4501                	li	a0,0
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	d22080e7          	jalr	-734(ra) # 80002ece <argint>
    argint(1, &count);
    800031b4:	fe840593          	addi	a1,s0,-24
    800031b8:	4505                	li	a0,1
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	d14080e7          	jalr	-748(ra) # 80002ece <argint>
    return ps((uint8)start, (uint8)count);
    800031c2:	fe844583          	lbu	a1,-24(s0)
    800031c6:	fec44503          	lbu	a0,-20(s0)
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	d22080e7          	jalr	-734(ra) # 80001eec <ps>
}
    800031d2:	60e2                	ld	ra,24(sp)
    800031d4:	6442                	ld	s0,16(sp)
    800031d6:	6105                	addi	sp,sp,32
    800031d8:	8082                	ret

00000000800031da <sys_schedls>:

uint64 sys_schedls(void)
{
    800031da:	1141                	addi	sp,sp,-16
    800031dc:	e406                	sd	ra,8(sp)
    800031de:	e022                	sd	s0,0(sp)
    800031e0:	0800                	addi	s0,sp,16
    schedls();
    800031e2:	fffff097          	auipc	ra,0xfffff
    800031e6:	690080e7          	jalr	1680(ra) # 80002872 <schedls>
    return 0;
}
    800031ea:	4501                	li	a0,0
    800031ec:	60a2                	ld	ra,8(sp)
    800031ee:	6402                	ld	s0,0(sp)
    800031f0:	0141                	addi	sp,sp,16
    800031f2:	8082                	ret

00000000800031f4 <sys_schedset>:

uint64 sys_schedset(void)
{
    800031f4:	1101                	addi	sp,sp,-32
    800031f6:	ec06                	sd	ra,24(sp)
    800031f8:	e822                	sd	s0,16(sp)
    800031fa:	1000                	addi	s0,sp,32
    int id = 0;
    800031fc:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003200:	fec40593          	addi	a1,s0,-20
    80003204:	4501                	li	a0,0
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	cc8080e7          	jalr	-824(ra) # 80002ece <argint>
    schedset(id - 1);
    8000320e:	fec42503          	lw	a0,-20(s0)
    80003212:	357d                	addiw	a0,a0,-1
    80003214:	fffff097          	auipc	ra,0xfffff
    80003218:	74a080e7          	jalr	1866(ra) # 8000295e <schedset>
    return 0;
}
    8000321c:	4501                	li	a0,0
    8000321e:	60e2                	ld	ra,24(sp)
    80003220:	6442                	ld	s0,16(sp)
    80003222:	6105                	addi	sp,sp,32
    80003224:	8082                	ret

0000000080003226 <sys_yield>:

uint64 sys_yield(void)
{
    80003226:	1141                	addi	sp,sp,-16
    80003228:	e406                	sd	ra,8(sp)
    8000322a:	e022                	sd	s0,0(sp)
    8000322c:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    8000322e:	4509                	li	a0,2
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	0a2080e7          	jalr	162(ra) # 800022d2 <yield>
    return 0;
    80003238:	4501                	li	a0,0
    8000323a:	60a2                	ld	ra,8(sp)
    8000323c:	6402                	ld	s0,0(sp)
    8000323e:	0141                	addi	sp,sp,16
    80003240:	8082                	ret

0000000080003242 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003242:	7179                	addi	sp,sp,-48
    80003244:	f406                	sd	ra,40(sp)
    80003246:	f022                	sd	s0,32(sp)
    80003248:	ec26                	sd	s1,24(sp)
    8000324a:	e84a                	sd	s2,16(sp)
    8000324c:	e44e                	sd	s3,8(sp)
    8000324e:	e052                	sd	s4,0(sp)
    80003250:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003252:	00005597          	auipc	a1,0x5
    80003256:	27e58593          	addi	a1,a1,638 # 800084d0 <etext+0x4d0>
    8000325a:	00016517          	auipc	a0,0x16
    8000325e:	30e50513          	addi	a0,a0,782 # 80019568 <bcache>
    80003262:	ffffe097          	auipc	ra,0xffffe
    80003266:	946080e7          	jalr	-1722(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000326a:	0001e797          	auipc	a5,0x1e
    8000326e:	2fe78793          	addi	a5,a5,766 # 80021568 <bcache+0x8000>
    80003272:	0001e717          	auipc	a4,0x1e
    80003276:	55e70713          	addi	a4,a4,1374 # 800217d0 <bcache+0x8268>
    8000327a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000327e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003282:	00016497          	auipc	s1,0x16
    80003286:	2fe48493          	addi	s1,s1,766 # 80019580 <bcache+0x18>
    b->next = bcache.head.next;
    8000328a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000328c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000328e:	00005a17          	auipc	s4,0x5
    80003292:	24aa0a13          	addi	s4,s4,586 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    80003296:	2b893783          	ld	a5,696(s2)
    8000329a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000329c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800032a0:	85d2                	mv	a1,s4
    800032a2:	01048513          	addi	a0,s1,16
    800032a6:	00001097          	auipc	ra,0x1
    800032aa:	4e8080e7          	jalr	1256(ra) # 8000478e <initsleeplock>
    bcache.head.next->prev = b;
    800032ae:	2b893783          	ld	a5,696(s2)
    800032b2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800032b4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032b8:	45848493          	addi	s1,s1,1112
    800032bc:	fd349de3          	bne	s1,s3,80003296 <binit+0x54>
  }
}
    800032c0:	70a2                	ld	ra,40(sp)
    800032c2:	7402                	ld	s0,32(sp)
    800032c4:	64e2                	ld	s1,24(sp)
    800032c6:	6942                	ld	s2,16(sp)
    800032c8:	69a2                	ld	s3,8(sp)
    800032ca:	6a02                	ld	s4,0(sp)
    800032cc:	6145                	addi	sp,sp,48
    800032ce:	8082                	ret

00000000800032d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	e84a                	sd	s2,16(sp)
    800032da:	e44e                	sd	s3,8(sp)
    800032dc:	1800                	addi	s0,sp,48
    800032de:	892a                	mv	s2,a0
    800032e0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800032e2:	00016517          	auipc	a0,0x16
    800032e6:	28650513          	addi	a0,a0,646 # 80019568 <bcache>
    800032ea:	ffffe097          	auipc	ra,0xffffe
    800032ee:	94e080e7          	jalr	-1714(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800032f2:	0001e497          	auipc	s1,0x1e
    800032f6:	52e4b483          	ld	s1,1326(s1) # 80021820 <bcache+0x82b8>
    800032fa:	0001e797          	auipc	a5,0x1e
    800032fe:	4d678793          	addi	a5,a5,1238 # 800217d0 <bcache+0x8268>
    80003302:	02f48f63          	beq	s1,a5,80003340 <bread+0x70>
    80003306:	873e                	mv	a4,a5
    80003308:	a021                	j	80003310 <bread+0x40>
    8000330a:	68a4                	ld	s1,80(s1)
    8000330c:	02e48a63          	beq	s1,a4,80003340 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003310:	449c                	lw	a5,8(s1)
    80003312:	ff279ce3          	bne	a5,s2,8000330a <bread+0x3a>
    80003316:	44dc                	lw	a5,12(s1)
    80003318:	ff3799e3          	bne	a5,s3,8000330a <bread+0x3a>
      b->refcnt++;
    8000331c:	40bc                	lw	a5,64(s1)
    8000331e:	2785                	addiw	a5,a5,1
    80003320:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003322:	00016517          	auipc	a0,0x16
    80003326:	24650513          	addi	a0,a0,582 # 80019568 <bcache>
    8000332a:	ffffe097          	auipc	ra,0xffffe
    8000332e:	9c2080e7          	jalr	-1598(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003332:	01048513          	addi	a0,s1,16
    80003336:	00001097          	auipc	ra,0x1
    8000333a:	492080e7          	jalr	1170(ra) # 800047c8 <acquiresleep>
      return b;
    8000333e:	a8b9                	j	8000339c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003340:	0001e497          	auipc	s1,0x1e
    80003344:	4d84b483          	ld	s1,1240(s1) # 80021818 <bcache+0x82b0>
    80003348:	0001e797          	auipc	a5,0x1e
    8000334c:	48878793          	addi	a5,a5,1160 # 800217d0 <bcache+0x8268>
    80003350:	00f48863          	beq	s1,a5,80003360 <bread+0x90>
    80003354:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003356:	40bc                	lw	a5,64(s1)
    80003358:	cf81                	beqz	a5,80003370 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000335a:	64a4                	ld	s1,72(s1)
    8000335c:	fee49de3          	bne	s1,a4,80003356 <bread+0x86>
  panic("bget: no buffers");
    80003360:	00005517          	auipc	a0,0x5
    80003364:	18050513          	addi	a0,a0,384 # 800084e0 <etext+0x4e0>
    80003368:	ffffd097          	auipc	ra,0xffffd
    8000336c:	1f8080e7          	jalr	504(ra) # 80000560 <panic>
      b->dev = dev;
    80003370:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003374:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003378:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000337c:	4785                	li	a5,1
    8000337e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003380:	00016517          	auipc	a0,0x16
    80003384:	1e850513          	addi	a0,a0,488 # 80019568 <bcache>
    80003388:	ffffe097          	auipc	ra,0xffffe
    8000338c:	964080e7          	jalr	-1692(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003390:	01048513          	addi	a0,s1,16
    80003394:	00001097          	auipc	ra,0x1
    80003398:	434080e7          	jalr	1076(ra) # 800047c8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000339c:	409c                	lw	a5,0(s1)
    8000339e:	cb89                	beqz	a5,800033b0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800033a0:	8526                	mv	a0,s1
    800033a2:	70a2                	ld	ra,40(sp)
    800033a4:	7402                	ld	s0,32(sp)
    800033a6:	64e2                	ld	s1,24(sp)
    800033a8:	6942                	ld	s2,16(sp)
    800033aa:	69a2                	ld	s3,8(sp)
    800033ac:	6145                	addi	sp,sp,48
    800033ae:	8082                	ret
    virtio_disk_rw(b, 0);
    800033b0:	4581                	li	a1,0
    800033b2:	8526                	mv	a0,s1
    800033b4:	00003097          	auipc	ra,0x3
    800033b8:	0f4080e7          	jalr	244(ra) # 800064a8 <virtio_disk_rw>
    b->valid = 1;
    800033bc:	4785                	li	a5,1
    800033be:	c09c                	sw	a5,0(s1)
  return b;
    800033c0:	b7c5                	j	800033a0 <bread+0xd0>

00000000800033c2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800033c2:	1101                	addi	sp,sp,-32
    800033c4:	ec06                	sd	ra,24(sp)
    800033c6:	e822                	sd	s0,16(sp)
    800033c8:	e426                	sd	s1,8(sp)
    800033ca:	1000                	addi	s0,sp,32
    800033cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033ce:	0541                	addi	a0,a0,16
    800033d0:	00001097          	auipc	ra,0x1
    800033d4:	492080e7          	jalr	1170(ra) # 80004862 <holdingsleep>
    800033d8:	cd01                	beqz	a0,800033f0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800033da:	4585                	li	a1,1
    800033dc:	8526                	mv	a0,s1
    800033de:	00003097          	auipc	ra,0x3
    800033e2:	0ca080e7          	jalr	202(ra) # 800064a8 <virtio_disk_rw>
}
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	64a2                	ld	s1,8(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret
    panic("bwrite");
    800033f0:	00005517          	auipc	a0,0x5
    800033f4:	10850513          	addi	a0,a0,264 # 800084f8 <etext+0x4f8>
    800033f8:	ffffd097          	auipc	ra,0xffffd
    800033fc:	168080e7          	jalr	360(ra) # 80000560 <panic>

0000000080003400 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	e426                	sd	s1,8(sp)
    80003408:	e04a                	sd	s2,0(sp)
    8000340a:	1000                	addi	s0,sp,32
    8000340c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000340e:	01050913          	addi	s2,a0,16
    80003412:	854a                	mv	a0,s2
    80003414:	00001097          	auipc	ra,0x1
    80003418:	44e080e7          	jalr	1102(ra) # 80004862 <holdingsleep>
    8000341c:	c925                	beqz	a0,8000348c <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000341e:	854a                	mv	a0,s2
    80003420:	00001097          	auipc	ra,0x1
    80003424:	3fe080e7          	jalr	1022(ra) # 8000481e <releasesleep>

  acquire(&bcache.lock);
    80003428:	00016517          	auipc	a0,0x16
    8000342c:	14050513          	addi	a0,a0,320 # 80019568 <bcache>
    80003430:	ffffe097          	auipc	ra,0xffffe
    80003434:	808080e7          	jalr	-2040(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003438:	40bc                	lw	a5,64(s1)
    8000343a:	37fd                	addiw	a5,a5,-1
    8000343c:	0007871b          	sext.w	a4,a5
    80003440:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003442:	e71d                	bnez	a4,80003470 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003444:	68b8                	ld	a4,80(s1)
    80003446:	64bc                	ld	a5,72(s1)
    80003448:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000344a:	68b8                	ld	a4,80(s1)
    8000344c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000344e:	0001e797          	auipc	a5,0x1e
    80003452:	11a78793          	addi	a5,a5,282 # 80021568 <bcache+0x8000>
    80003456:	2b87b703          	ld	a4,696(a5)
    8000345a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000345c:	0001e717          	auipc	a4,0x1e
    80003460:	37470713          	addi	a4,a4,884 # 800217d0 <bcache+0x8268>
    80003464:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003466:	2b87b703          	ld	a4,696(a5)
    8000346a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000346c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003470:	00016517          	auipc	a0,0x16
    80003474:	0f850513          	addi	a0,a0,248 # 80019568 <bcache>
    80003478:	ffffe097          	auipc	ra,0xffffe
    8000347c:	874080e7          	jalr	-1932(ra) # 80000cec <release>
}
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	64a2                	ld	s1,8(sp)
    80003486:	6902                	ld	s2,0(sp)
    80003488:	6105                	addi	sp,sp,32
    8000348a:	8082                	ret
    panic("brelse");
    8000348c:	00005517          	auipc	a0,0x5
    80003490:	07450513          	addi	a0,a0,116 # 80008500 <etext+0x500>
    80003494:	ffffd097          	auipc	ra,0xffffd
    80003498:	0cc080e7          	jalr	204(ra) # 80000560 <panic>

000000008000349c <bpin>:

void
bpin(struct buf *b) {
    8000349c:	1101                	addi	sp,sp,-32
    8000349e:	ec06                	sd	ra,24(sp)
    800034a0:	e822                	sd	s0,16(sp)
    800034a2:	e426                	sd	s1,8(sp)
    800034a4:	1000                	addi	s0,sp,32
    800034a6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800034a8:	00016517          	auipc	a0,0x16
    800034ac:	0c050513          	addi	a0,a0,192 # 80019568 <bcache>
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	788080e7          	jalr	1928(ra) # 80000c38 <acquire>
  b->refcnt++;
    800034b8:	40bc                	lw	a5,64(s1)
    800034ba:	2785                	addiw	a5,a5,1
    800034bc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034be:	00016517          	auipc	a0,0x16
    800034c2:	0aa50513          	addi	a0,a0,170 # 80019568 <bcache>
    800034c6:	ffffe097          	auipc	ra,0xffffe
    800034ca:	826080e7          	jalr	-2010(ra) # 80000cec <release>
}
    800034ce:	60e2                	ld	ra,24(sp)
    800034d0:	6442                	ld	s0,16(sp)
    800034d2:	64a2                	ld	s1,8(sp)
    800034d4:	6105                	addi	sp,sp,32
    800034d6:	8082                	ret

00000000800034d8 <bunpin>:

void
bunpin(struct buf *b) {
    800034d8:	1101                	addi	sp,sp,-32
    800034da:	ec06                	sd	ra,24(sp)
    800034dc:	e822                	sd	s0,16(sp)
    800034de:	e426                	sd	s1,8(sp)
    800034e0:	1000                	addi	s0,sp,32
    800034e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800034e4:	00016517          	auipc	a0,0x16
    800034e8:	08450513          	addi	a0,a0,132 # 80019568 <bcache>
    800034ec:	ffffd097          	auipc	ra,0xffffd
    800034f0:	74c080e7          	jalr	1868(ra) # 80000c38 <acquire>
  b->refcnt--;
    800034f4:	40bc                	lw	a5,64(s1)
    800034f6:	37fd                	addiw	a5,a5,-1
    800034f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034fa:	00016517          	auipc	a0,0x16
    800034fe:	06e50513          	addi	a0,a0,110 # 80019568 <bcache>
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	7ea080e7          	jalr	2026(ra) # 80000cec <release>
}
    8000350a:	60e2                	ld	ra,24(sp)
    8000350c:	6442                	ld	s0,16(sp)
    8000350e:	64a2                	ld	s1,8(sp)
    80003510:	6105                	addi	sp,sp,32
    80003512:	8082                	ret

0000000080003514 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003514:	1101                	addi	sp,sp,-32
    80003516:	ec06                	sd	ra,24(sp)
    80003518:	e822                	sd	s0,16(sp)
    8000351a:	e426                	sd	s1,8(sp)
    8000351c:	e04a                	sd	s2,0(sp)
    8000351e:	1000                	addi	s0,sp,32
    80003520:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003522:	00d5d59b          	srliw	a1,a1,0xd
    80003526:	0001e797          	auipc	a5,0x1e
    8000352a:	71e7a783          	lw	a5,1822(a5) # 80021c44 <sb+0x1c>
    8000352e:	9dbd                	addw	a1,a1,a5
    80003530:	00000097          	auipc	ra,0x0
    80003534:	da0080e7          	jalr	-608(ra) # 800032d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003538:	0074f713          	andi	a4,s1,7
    8000353c:	4785                	li	a5,1
    8000353e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003542:	14ce                	slli	s1,s1,0x33
    80003544:	90d9                	srli	s1,s1,0x36
    80003546:	00950733          	add	a4,a0,s1
    8000354a:	05874703          	lbu	a4,88(a4)
    8000354e:	00e7f6b3          	and	a3,a5,a4
    80003552:	c69d                	beqz	a3,80003580 <bfree+0x6c>
    80003554:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003556:	94aa                	add	s1,s1,a0
    80003558:	fff7c793          	not	a5,a5
    8000355c:	8f7d                	and	a4,a4,a5
    8000355e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003562:	00001097          	auipc	ra,0x1
    80003566:	148080e7          	jalr	328(ra) # 800046aa <log_write>
  brelse(bp);
    8000356a:	854a                	mv	a0,s2
    8000356c:	00000097          	auipc	ra,0x0
    80003570:	e94080e7          	jalr	-364(ra) # 80003400 <brelse>
}
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	64a2                	ld	s1,8(sp)
    8000357a:	6902                	ld	s2,0(sp)
    8000357c:	6105                	addi	sp,sp,32
    8000357e:	8082                	ret
    panic("freeing free block");
    80003580:	00005517          	auipc	a0,0x5
    80003584:	f8850513          	addi	a0,a0,-120 # 80008508 <etext+0x508>
    80003588:	ffffd097          	auipc	ra,0xffffd
    8000358c:	fd8080e7          	jalr	-40(ra) # 80000560 <panic>

0000000080003590 <balloc>:
{
    80003590:	711d                	addi	sp,sp,-96
    80003592:	ec86                	sd	ra,88(sp)
    80003594:	e8a2                	sd	s0,80(sp)
    80003596:	e4a6                	sd	s1,72(sp)
    80003598:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000359a:	0001e797          	auipc	a5,0x1e
    8000359e:	6927a783          	lw	a5,1682(a5) # 80021c2c <sb+0x4>
    800035a2:	10078f63          	beqz	a5,800036c0 <balloc+0x130>
    800035a6:	e0ca                	sd	s2,64(sp)
    800035a8:	fc4e                	sd	s3,56(sp)
    800035aa:	f852                	sd	s4,48(sp)
    800035ac:	f456                	sd	s5,40(sp)
    800035ae:	f05a                	sd	s6,32(sp)
    800035b0:	ec5e                	sd	s7,24(sp)
    800035b2:	e862                	sd	s8,16(sp)
    800035b4:	e466                	sd	s9,8(sp)
    800035b6:	8baa                	mv	s7,a0
    800035b8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800035ba:	0001eb17          	auipc	s6,0x1e
    800035be:	66eb0b13          	addi	s6,s6,1646 # 80021c28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035c2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800035c4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035c6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800035c8:	6c89                	lui	s9,0x2
    800035ca:	a061                	j	80003652 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800035cc:	97ca                	add	a5,a5,s2
    800035ce:	8e55                	or	a2,a2,a3
    800035d0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800035d4:	854a                	mv	a0,s2
    800035d6:	00001097          	auipc	ra,0x1
    800035da:	0d4080e7          	jalr	212(ra) # 800046aa <log_write>
        brelse(bp);
    800035de:	854a                	mv	a0,s2
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	e20080e7          	jalr	-480(ra) # 80003400 <brelse>
  bp = bread(dev, bno);
    800035e8:	85a6                	mv	a1,s1
    800035ea:	855e                	mv	a0,s7
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	ce4080e7          	jalr	-796(ra) # 800032d0 <bread>
    800035f4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800035f6:	40000613          	li	a2,1024
    800035fa:	4581                	li	a1,0
    800035fc:	05850513          	addi	a0,a0,88
    80003600:	ffffd097          	auipc	ra,0xffffd
    80003604:	734080e7          	jalr	1844(ra) # 80000d34 <memset>
  log_write(bp);
    80003608:	854a                	mv	a0,s2
    8000360a:	00001097          	auipc	ra,0x1
    8000360e:	0a0080e7          	jalr	160(ra) # 800046aa <log_write>
  brelse(bp);
    80003612:	854a                	mv	a0,s2
    80003614:	00000097          	auipc	ra,0x0
    80003618:	dec080e7          	jalr	-532(ra) # 80003400 <brelse>
}
    8000361c:	6906                	ld	s2,64(sp)
    8000361e:	79e2                	ld	s3,56(sp)
    80003620:	7a42                	ld	s4,48(sp)
    80003622:	7aa2                	ld	s5,40(sp)
    80003624:	7b02                	ld	s6,32(sp)
    80003626:	6be2                	ld	s7,24(sp)
    80003628:	6c42                	ld	s8,16(sp)
    8000362a:	6ca2                	ld	s9,8(sp)
}
    8000362c:	8526                	mv	a0,s1
    8000362e:	60e6                	ld	ra,88(sp)
    80003630:	6446                	ld	s0,80(sp)
    80003632:	64a6                	ld	s1,72(sp)
    80003634:	6125                	addi	sp,sp,96
    80003636:	8082                	ret
    brelse(bp);
    80003638:	854a                	mv	a0,s2
    8000363a:	00000097          	auipc	ra,0x0
    8000363e:	dc6080e7          	jalr	-570(ra) # 80003400 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003642:	015c87bb          	addw	a5,s9,s5
    80003646:	00078a9b          	sext.w	s5,a5
    8000364a:	004b2703          	lw	a4,4(s6)
    8000364e:	06eaf163          	bgeu	s5,a4,800036b0 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003652:	41fad79b          	sraiw	a5,s5,0x1f
    80003656:	0137d79b          	srliw	a5,a5,0x13
    8000365a:	015787bb          	addw	a5,a5,s5
    8000365e:	40d7d79b          	sraiw	a5,a5,0xd
    80003662:	01cb2583          	lw	a1,28(s6)
    80003666:	9dbd                	addw	a1,a1,a5
    80003668:	855e                	mv	a0,s7
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	c66080e7          	jalr	-922(ra) # 800032d0 <bread>
    80003672:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003674:	004b2503          	lw	a0,4(s6)
    80003678:	000a849b          	sext.w	s1,s5
    8000367c:	8762                	mv	a4,s8
    8000367e:	faa4fde3          	bgeu	s1,a0,80003638 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003682:	00777693          	andi	a3,a4,7
    80003686:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000368a:	41f7579b          	sraiw	a5,a4,0x1f
    8000368e:	01d7d79b          	srliw	a5,a5,0x1d
    80003692:	9fb9                	addw	a5,a5,a4
    80003694:	4037d79b          	sraiw	a5,a5,0x3
    80003698:	00f90633          	add	a2,s2,a5
    8000369c:	05864603          	lbu	a2,88(a2)
    800036a0:	00c6f5b3          	and	a1,a3,a2
    800036a4:	d585                	beqz	a1,800035cc <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036a6:	2705                	addiw	a4,a4,1
    800036a8:	2485                	addiw	s1,s1,1
    800036aa:	fd471ae3          	bne	a4,s4,8000367e <balloc+0xee>
    800036ae:	b769                	j	80003638 <balloc+0xa8>
    800036b0:	6906                	ld	s2,64(sp)
    800036b2:	79e2                	ld	s3,56(sp)
    800036b4:	7a42                	ld	s4,48(sp)
    800036b6:	7aa2                	ld	s5,40(sp)
    800036b8:	7b02                	ld	s6,32(sp)
    800036ba:	6be2                	ld	s7,24(sp)
    800036bc:	6c42                	ld	s8,16(sp)
    800036be:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800036c0:	00005517          	auipc	a0,0x5
    800036c4:	e6050513          	addi	a0,a0,-416 # 80008520 <etext+0x520>
    800036c8:	ffffd097          	auipc	ra,0xffffd
    800036cc:	ee2080e7          	jalr	-286(ra) # 800005aa <printf>
  return 0;
    800036d0:	4481                	li	s1,0
    800036d2:	bfa9                	j	8000362c <balloc+0x9c>

00000000800036d4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800036d4:	7179                	addi	sp,sp,-48
    800036d6:	f406                	sd	ra,40(sp)
    800036d8:	f022                	sd	s0,32(sp)
    800036da:	ec26                	sd	s1,24(sp)
    800036dc:	e84a                	sd	s2,16(sp)
    800036de:	e44e                	sd	s3,8(sp)
    800036e0:	1800                	addi	s0,sp,48
    800036e2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800036e4:	47ad                	li	a5,11
    800036e6:	02b7e863          	bltu	a5,a1,80003716 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800036ea:	02059793          	slli	a5,a1,0x20
    800036ee:	01e7d593          	srli	a1,a5,0x1e
    800036f2:	00b504b3          	add	s1,a0,a1
    800036f6:	0504a903          	lw	s2,80(s1)
    800036fa:	08091263          	bnez	s2,8000377e <bmap+0xaa>
      addr = balloc(ip->dev);
    800036fe:	4108                	lw	a0,0(a0)
    80003700:	00000097          	auipc	ra,0x0
    80003704:	e90080e7          	jalr	-368(ra) # 80003590 <balloc>
    80003708:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000370c:	06090963          	beqz	s2,8000377e <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003710:	0524a823          	sw	s2,80(s1)
    80003714:	a0ad                	j	8000377e <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003716:	ff45849b          	addiw	s1,a1,-12
    8000371a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000371e:	0ff00793          	li	a5,255
    80003722:	08e7e863          	bltu	a5,a4,800037b2 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003726:	08052903          	lw	s2,128(a0)
    8000372a:	00091f63          	bnez	s2,80003748 <bmap+0x74>
      addr = balloc(ip->dev);
    8000372e:	4108                	lw	a0,0(a0)
    80003730:	00000097          	auipc	ra,0x0
    80003734:	e60080e7          	jalr	-416(ra) # 80003590 <balloc>
    80003738:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000373c:	04090163          	beqz	s2,8000377e <bmap+0xaa>
    80003740:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003742:	0929a023          	sw	s2,128(s3)
    80003746:	a011                	j	8000374a <bmap+0x76>
    80003748:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000374a:	85ca                	mv	a1,s2
    8000374c:	0009a503          	lw	a0,0(s3)
    80003750:	00000097          	auipc	ra,0x0
    80003754:	b80080e7          	jalr	-1152(ra) # 800032d0 <bread>
    80003758:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000375a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000375e:	02049713          	slli	a4,s1,0x20
    80003762:	01e75593          	srli	a1,a4,0x1e
    80003766:	00b784b3          	add	s1,a5,a1
    8000376a:	0004a903          	lw	s2,0(s1)
    8000376e:	02090063          	beqz	s2,8000378e <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003772:	8552                	mv	a0,s4
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c8c080e7          	jalr	-884(ra) # 80003400 <brelse>
    return addr;
    8000377c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000377e:	854a                	mv	a0,s2
    80003780:	70a2                	ld	ra,40(sp)
    80003782:	7402                	ld	s0,32(sp)
    80003784:	64e2                	ld	s1,24(sp)
    80003786:	6942                	ld	s2,16(sp)
    80003788:	69a2                	ld	s3,8(sp)
    8000378a:	6145                	addi	sp,sp,48
    8000378c:	8082                	ret
      addr = balloc(ip->dev);
    8000378e:	0009a503          	lw	a0,0(s3)
    80003792:	00000097          	auipc	ra,0x0
    80003796:	dfe080e7          	jalr	-514(ra) # 80003590 <balloc>
    8000379a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000379e:	fc090ae3          	beqz	s2,80003772 <bmap+0x9e>
        a[bn] = addr;
    800037a2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800037a6:	8552                	mv	a0,s4
    800037a8:	00001097          	auipc	ra,0x1
    800037ac:	f02080e7          	jalr	-254(ra) # 800046aa <log_write>
    800037b0:	b7c9                	j	80003772 <bmap+0x9e>
    800037b2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800037b4:	00005517          	auipc	a0,0x5
    800037b8:	d8450513          	addi	a0,a0,-636 # 80008538 <etext+0x538>
    800037bc:	ffffd097          	auipc	ra,0xffffd
    800037c0:	da4080e7          	jalr	-604(ra) # 80000560 <panic>

00000000800037c4 <iget>:
{
    800037c4:	7179                	addi	sp,sp,-48
    800037c6:	f406                	sd	ra,40(sp)
    800037c8:	f022                	sd	s0,32(sp)
    800037ca:	ec26                	sd	s1,24(sp)
    800037cc:	e84a                	sd	s2,16(sp)
    800037ce:	e44e                	sd	s3,8(sp)
    800037d0:	e052                	sd	s4,0(sp)
    800037d2:	1800                	addi	s0,sp,48
    800037d4:	89aa                	mv	s3,a0
    800037d6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800037d8:	0001e517          	auipc	a0,0x1e
    800037dc:	47050513          	addi	a0,a0,1136 # 80021c48 <itable>
    800037e0:	ffffd097          	auipc	ra,0xffffd
    800037e4:	458080e7          	jalr	1112(ra) # 80000c38 <acquire>
  empty = 0;
    800037e8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800037ea:	0001e497          	auipc	s1,0x1e
    800037ee:	47648493          	addi	s1,s1,1142 # 80021c60 <itable+0x18>
    800037f2:	00020697          	auipc	a3,0x20
    800037f6:	efe68693          	addi	a3,a3,-258 # 800236f0 <log>
    800037fa:	a039                	j	80003808 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037fc:	02090b63          	beqz	s2,80003832 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003800:	08848493          	addi	s1,s1,136
    80003804:	02d48a63          	beq	s1,a3,80003838 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003808:	449c                	lw	a5,8(s1)
    8000380a:	fef059e3          	blez	a5,800037fc <iget+0x38>
    8000380e:	4098                	lw	a4,0(s1)
    80003810:	ff3716e3          	bne	a4,s3,800037fc <iget+0x38>
    80003814:	40d8                	lw	a4,4(s1)
    80003816:	ff4713e3          	bne	a4,s4,800037fc <iget+0x38>
      ip->ref++;
    8000381a:	2785                	addiw	a5,a5,1
    8000381c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000381e:	0001e517          	auipc	a0,0x1e
    80003822:	42a50513          	addi	a0,a0,1066 # 80021c48 <itable>
    80003826:	ffffd097          	auipc	ra,0xffffd
    8000382a:	4c6080e7          	jalr	1222(ra) # 80000cec <release>
      return ip;
    8000382e:	8926                	mv	s2,s1
    80003830:	a03d                	j	8000385e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003832:	f7f9                	bnez	a5,80003800 <iget+0x3c>
      empty = ip;
    80003834:	8926                	mv	s2,s1
    80003836:	b7e9                	j	80003800 <iget+0x3c>
  if(empty == 0)
    80003838:	02090c63          	beqz	s2,80003870 <iget+0xac>
  ip->dev = dev;
    8000383c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003840:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003844:	4785                	li	a5,1
    80003846:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000384a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000384e:	0001e517          	auipc	a0,0x1e
    80003852:	3fa50513          	addi	a0,a0,1018 # 80021c48 <itable>
    80003856:	ffffd097          	auipc	ra,0xffffd
    8000385a:	496080e7          	jalr	1174(ra) # 80000cec <release>
}
    8000385e:	854a                	mv	a0,s2
    80003860:	70a2                	ld	ra,40(sp)
    80003862:	7402                	ld	s0,32(sp)
    80003864:	64e2                	ld	s1,24(sp)
    80003866:	6942                	ld	s2,16(sp)
    80003868:	69a2                	ld	s3,8(sp)
    8000386a:	6a02                	ld	s4,0(sp)
    8000386c:	6145                	addi	sp,sp,48
    8000386e:	8082                	ret
    panic("iget: no inodes");
    80003870:	00005517          	auipc	a0,0x5
    80003874:	ce050513          	addi	a0,a0,-800 # 80008550 <etext+0x550>
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	ce8080e7          	jalr	-792(ra) # 80000560 <panic>

0000000080003880 <fsinit>:
fsinit(int dev) {
    80003880:	7179                	addi	sp,sp,-48
    80003882:	f406                	sd	ra,40(sp)
    80003884:	f022                	sd	s0,32(sp)
    80003886:	ec26                	sd	s1,24(sp)
    80003888:	e84a                	sd	s2,16(sp)
    8000388a:	e44e                	sd	s3,8(sp)
    8000388c:	1800                	addi	s0,sp,48
    8000388e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003890:	4585                	li	a1,1
    80003892:	00000097          	auipc	ra,0x0
    80003896:	a3e080e7          	jalr	-1474(ra) # 800032d0 <bread>
    8000389a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000389c:	0001e997          	auipc	s3,0x1e
    800038a0:	38c98993          	addi	s3,s3,908 # 80021c28 <sb>
    800038a4:	02000613          	li	a2,32
    800038a8:	05850593          	addi	a1,a0,88
    800038ac:	854e                	mv	a0,s3
    800038ae:	ffffd097          	auipc	ra,0xffffd
    800038b2:	4e2080e7          	jalr	1250(ra) # 80000d90 <memmove>
  brelse(bp);
    800038b6:	8526                	mv	a0,s1
    800038b8:	00000097          	auipc	ra,0x0
    800038bc:	b48080e7          	jalr	-1208(ra) # 80003400 <brelse>
  if(sb.magic != FSMAGIC)
    800038c0:	0009a703          	lw	a4,0(s3)
    800038c4:	102037b7          	lui	a5,0x10203
    800038c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800038cc:	02f71263          	bne	a4,a5,800038f0 <fsinit+0x70>
  initlog(dev, &sb);
    800038d0:	0001e597          	auipc	a1,0x1e
    800038d4:	35858593          	addi	a1,a1,856 # 80021c28 <sb>
    800038d8:	854a                	mv	a0,s2
    800038da:	00001097          	auipc	ra,0x1
    800038de:	b60080e7          	jalr	-1184(ra) # 8000443a <initlog>
}
    800038e2:	70a2                	ld	ra,40(sp)
    800038e4:	7402                	ld	s0,32(sp)
    800038e6:	64e2                	ld	s1,24(sp)
    800038e8:	6942                	ld	s2,16(sp)
    800038ea:	69a2                	ld	s3,8(sp)
    800038ec:	6145                	addi	sp,sp,48
    800038ee:	8082                	ret
    panic("invalid file system");
    800038f0:	00005517          	auipc	a0,0x5
    800038f4:	c7050513          	addi	a0,a0,-912 # 80008560 <etext+0x560>
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	c68080e7          	jalr	-920(ra) # 80000560 <panic>

0000000080003900 <iinit>:
{
    80003900:	7179                	addi	sp,sp,-48
    80003902:	f406                	sd	ra,40(sp)
    80003904:	f022                	sd	s0,32(sp)
    80003906:	ec26                	sd	s1,24(sp)
    80003908:	e84a                	sd	s2,16(sp)
    8000390a:	e44e                	sd	s3,8(sp)
    8000390c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000390e:	00005597          	auipc	a1,0x5
    80003912:	c6a58593          	addi	a1,a1,-918 # 80008578 <etext+0x578>
    80003916:	0001e517          	auipc	a0,0x1e
    8000391a:	33250513          	addi	a0,a0,818 # 80021c48 <itable>
    8000391e:	ffffd097          	auipc	ra,0xffffd
    80003922:	28a080e7          	jalr	650(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003926:	0001e497          	auipc	s1,0x1e
    8000392a:	34a48493          	addi	s1,s1,842 # 80021c70 <itable+0x28>
    8000392e:	00020997          	auipc	s3,0x20
    80003932:	dd298993          	addi	s3,s3,-558 # 80023700 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003936:	00005917          	auipc	s2,0x5
    8000393a:	c4a90913          	addi	s2,s2,-950 # 80008580 <etext+0x580>
    8000393e:	85ca                	mv	a1,s2
    80003940:	8526                	mv	a0,s1
    80003942:	00001097          	auipc	ra,0x1
    80003946:	e4c080e7          	jalr	-436(ra) # 8000478e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000394a:	08848493          	addi	s1,s1,136
    8000394e:	ff3498e3          	bne	s1,s3,8000393e <iinit+0x3e>
}
    80003952:	70a2                	ld	ra,40(sp)
    80003954:	7402                	ld	s0,32(sp)
    80003956:	64e2                	ld	s1,24(sp)
    80003958:	6942                	ld	s2,16(sp)
    8000395a:	69a2                	ld	s3,8(sp)
    8000395c:	6145                	addi	sp,sp,48
    8000395e:	8082                	ret

0000000080003960 <ialloc>:
{
    80003960:	7139                	addi	sp,sp,-64
    80003962:	fc06                	sd	ra,56(sp)
    80003964:	f822                	sd	s0,48(sp)
    80003966:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003968:	0001e717          	auipc	a4,0x1e
    8000396c:	2cc72703          	lw	a4,716(a4) # 80021c34 <sb+0xc>
    80003970:	4785                	li	a5,1
    80003972:	06e7f463          	bgeu	a5,a4,800039da <ialloc+0x7a>
    80003976:	f426                	sd	s1,40(sp)
    80003978:	f04a                	sd	s2,32(sp)
    8000397a:	ec4e                	sd	s3,24(sp)
    8000397c:	e852                	sd	s4,16(sp)
    8000397e:	e456                	sd	s5,8(sp)
    80003980:	e05a                	sd	s6,0(sp)
    80003982:	8aaa                	mv	s5,a0
    80003984:	8b2e                	mv	s6,a1
    80003986:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003988:	0001ea17          	auipc	s4,0x1e
    8000398c:	2a0a0a13          	addi	s4,s4,672 # 80021c28 <sb>
    80003990:	00495593          	srli	a1,s2,0x4
    80003994:	018a2783          	lw	a5,24(s4)
    80003998:	9dbd                	addw	a1,a1,a5
    8000399a:	8556                	mv	a0,s5
    8000399c:	00000097          	auipc	ra,0x0
    800039a0:	934080e7          	jalr	-1740(ra) # 800032d0 <bread>
    800039a4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800039a6:	05850993          	addi	s3,a0,88
    800039aa:	00f97793          	andi	a5,s2,15
    800039ae:	079a                	slli	a5,a5,0x6
    800039b0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800039b2:	00099783          	lh	a5,0(s3)
    800039b6:	cf9d                	beqz	a5,800039f4 <ialloc+0x94>
    brelse(bp);
    800039b8:	00000097          	auipc	ra,0x0
    800039bc:	a48080e7          	jalr	-1464(ra) # 80003400 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800039c0:	0905                	addi	s2,s2,1
    800039c2:	00ca2703          	lw	a4,12(s4)
    800039c6:	0009079b          	sext.w	a5,s2
    800039ca:	fce7e3e3          	bltu	a5,a4,80003990 <ialloc+0x30>
    800039ce:	74a2                	ld	s1,40(sp)
    800039d0:	7902                	ld	s2,32(sp)
    800039d2:	69e2                	ld	s3,24(sp)
    800039d4:	6a42                	ld	s4,16(sp)
    800039d6:	6aa2                	ld	s5,8(sp)
    800039d8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800039da:	00005517          	auipc	a0,0x5
    800039de:	bae50513          	addi	a0,a0,-1106 # 80008588 <etext+0x588>
    800039e2:	ffffd097          	auipc	ra,0xffffd
    800039e6:	bc8080e7          	jalr	-1080(ra) # 800005aa <printf>
  return 0;
    800039ea:	4501                	li	a0,0
}
    800039ec:	70e2                	ld	ra,56(sp)
    800039ee:	7442                	ld	s0,48(sp)
    800039f0:	6121                	addi	sp,sp,64
    800039f2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800039f4:	04000613          	li	a2,64
    800039f8:	4581                	li	a1,0
    800039fa:	854e                	mv	a0,s3
    800039fc:	ffffd097          	auipc	ra,0xffffd
    80003a00:	338080e7          	jalr	824(ra) # 80000d34 <memset>
      dip->type = type;
    80003a04:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003a08:	8526                	mv	a0,s1
    80003a0a:	00001097          	auipc	ra,0x1
    80003a0e:	ca0080e7          	jalr	-864(ra) # 800046aa <log_write>
      brelse(bp);
    80003a12:	8526                	mv	a0,s1
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	9ec080e7          	jalr	-1556(ra) # 80003400 <brelse>
      return iget(dev, inum);
    80003a1c:	0009059b          	sext.w	a1,s2
    80003a20:	8556                	mv	a0,s5
    80003a22:	00000097          	auipc	ra,0x0
    80003a26:	da2080e7          	jalr	-606(ra) # 800037c4 <iget>
    80003a2a:	74a2                	ld	s1,40(sp)
    80003a2c:	7902                	ld	s2,32(sp)
    80003a2e:	69e2                	ld	s3,24(sp)
    80003a30:	6a42                	ld	s4,16(sp)
    80003a32:	6aa2                	ld	s5,8(sp)
    80003a34:	6b02                	ld	s6,0(sp)
    80003a36:	bf5d                	j	800039ec <ialloc+0x8c>

0000000080003a38 <iupdate>:
{
    80003a38:	1101                	addi	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	e04a                	sd	s2,0(sp)
    80003a42:	1000                	addi	s0,sp,32
    80003a44:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a46:	415c                	lw	a5,4(a0)
    80003a48:	0047d79b          	srliw	a5,a5,0x4
    80003a4c:	0001e597          	auipc	a1,0x1e
    80003a50:	1f45a583          	lw	a1,500(a1) # 80021c40 <sb+0x18>
    80003a54:	9dbd                	addw	a1,a1,a5
    80003a56:	4108                	lw	a0,0(a0)
    80003a58:	00000097          	auipc	ra,0x0
    80003a5c:	878080e7          	jalr	-1928(ra) # 800032d0 <bread>
    80003a60:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a62:	05850793          	addi	a5,a0,88
    80003a66:	40d8                	lw	a4,4(s1)
    80003a68:	8b3d                	andi	a4,a4,15
    80003a6a:	071a                	slli	a4,a4,0x6
    80003a6c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003a6e:	04449703          	lh	a4,68(s1)
    80003a72:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003a76:	04649703          	lh	a4,70(s1)
    80003a7a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003a7e:	04849703          	lh	a4,72(s1)
    80003a82:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003a86:	04a49703          	lh	a4,74(s1)
    80003a8a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003a8e:	44f8                	lw	a4,76(s1)
    80003a90:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a92:	03400613          	li	a2,52
    80003a96:	05048593          	addi	a1,s1,80
    80003a9a:	00c78513          	addi	a0,a5,12
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	2f2080e7          	jalr	754(ra) # 80000d90 <memmove>
  log_write(bp);
    80003aa6:	854a                	mv	a0,s2
    80003aa8:	00001097          	auipc	ra,0x1
    80003aac:	c02080e7          	jalr	-1022(ra) # 800046aa <log_write>
  brelse(bp);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00000097          	auipc	ra,0x0
    80003ab6:	94e080e7          	jalr	-1714(ra) # 80003400 <brelse>
}
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6902                	ld	s2,0(sp)
    80003ac2:	6105                	addi	sp,sp,32
    80003ac4:	8082                	ret

0000000080003ac6 <idup>:
{
    80003ac6:	1101                	addi	sp,sp,-32
    80003ac8:	ec06                	sd	ra,24(sp)
    80003aca:	e822                	sd	s0,16(sp)
    80003acc:	e426                	sd	s1,8(sp)
    80003ace:	1000                	addi	s0,sp,32
    80003ad0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003ad2:	0001e517          	auipc	a0,0x1e
    80003ad6:	17650513          	addi	a0,a0,374 # 80021c48 <itable>
    80003ada:	ffffd097          	auipc	ra,0xffffd
    80003ade:	15e080e7          	jalr	350(ra) # 80000c38 <acquire>
  ip->ref++;
    80003ae2:	449c                	lw	a5,8(s1)
    80003ae4:	2785                	addiw	a5,a5,1
    80003ae6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ae8:	0001e517          	auipc	a0,0x1e
    80003aec:	16050513          	addi	a0,a0,352 # 80021c48 <itable>
    80003af0:	ffffd097          	auipc	ra,0xffffd
    80003af4:	1fc080e7          	jalr	508(ra) # 80000cec <release>
}
    80003af8:	8526                	mv	a0,s1
    80003afa:	60e2                	ld	ra,24(sp)
    80003afc:	6442                	ld	s0,16(sp)
    80003afe:	64a2                	ld	s1,8(sp)
    80003b00:	6105                	addi	sp,sp,32
    80003b02:	8082                	ret

0000000080003b04 <ilock>:
{
    80003b04:	1101                	addi	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003b0e:	c10d                	beqz	a0,80003b30 <ilock+0x2c>
    80003b10:	84aa                	mv	s1,a0
    80003b12:	451c                	lw	a5,8(a0)
    80003b14:	00f05e63          	blez	a5,80003b30 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003b18:	0541                	addi	a0,a0,16
    80003b1a:	00001097          	auipc	ra,0x1
    80003b1e:	cae080e7          	jalr	-850(ra) # 800047c8 <acquiresleep>
  if(ip->valid == 0){
    80003b22:	40bc                	lw	a5,64(s1)
    80003b24:	cf99                	beqz	a5,80003b42 <ilock+0x3e>
}
    80003b26:	60e2                	ld	ra,24(sp)
    80003b28:	6442                	ld	s0,16(sp)
    80003b2a:	64a2                	ld	s1,8(sp)
    80003b2c:	6105                	addi	sp,sp,32
    80003b2e:	8082                	ret
    80003b30:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003b32:	00005517          	auipc	a0,0x5
    80003b36:	a6e50513          	addi	a0,a0,-1426 # 800085a0 <etext+0x5a0>
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	a26080e7          	jalr	-1498(ra) # 80000560 <panic>
    80003b42:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b44:	40dc                	lw	a5,4(s1)
    80003b46:	0047d79b          	srliw	a5,a5,0x4
    80003b4a:	0001e597          	auipc	a1,0x1e
    80003b4e:	0f65a583          	lw	a1,246(a1) # 80021c40 <sb+0x18>
    80003b52:	9dbd                	addw	a1,a1,a5
    80003b54:	4088                	lw	a0,0(s1)
    80003b56:	fffff097          	auipc	ra,0xfffff
    80003b5a:	77a080e7          	jalr	1914(ra) # 800032d0 <bread>
    80003b5e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b60:	05850593          	addi	a1,a0,88
    80003b64:	40dc                	lw	a5,4(s1)
    80003b66:	8bbd                	andi	a5,a5,15
    80003b68:	079a                	slli	a5,a5,0x6
    80003b6a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003b6c:	00059783          	lh	a5,0(a1)
    80003b70:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003b74:	00259783          	lh	a5,2(a1)
    80003b78:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003b7c:	00459783          	lh	a5,4(a1)
    80003b80:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003b84:	00659783          	lh	a5,6(a1)
    80003b88:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b8c:	459c                	lw	a5,8(a1)
    80003b8e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b90:	03400613          	li	a2,52
    80003b94:	05b1                	addi	a1,a1,12
    80003b96:	05048513          	addi	a0,s1,80
    80003b9a:	ffffd097          	auipc	ra,0xffffd
    80003b9e:	1f6080e7          	jalr	502(ra) # 80000d90 <memmove>
    brelse(bp);
    80003ba2:	854a                	mv	a0,s2
    80003ba4:	00000097          	auipc	ra,0x0
    80003ba8:	85c080e7          	jalr	-1956(ra) # 80003400 <brelse>
    ip->valid = 1;
    80003bac:	4785                	li	a5,1
    80003bae:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003bb0:	04449783          	lh	a5,68(s1)
    80003bb4:	c399                	beqz	a5,80003bba <ilock+0xb6>
    80003bb6:	6902                	ld	s2,0(sp)
    80003bb8:	b7bd                	j	80003b26 <ilock+0x22>
      panic("ilock: no type");
    80003bba:	00005517          	auipc	a0,0x5
    80003bbe:	9ee50513          	addi	a0,a0,-1554 # 800085a8 <etext+0x5a8>
    80003bc2:	ffffd097          	auipc	ra,0xffffd
    80003bc6:	99e080e7          	jalr	-1634(ra) # 80000560 <panic>

0000000080003bca <iunlock>:
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	e426                	sd	s1,8(sp)
    80003bd2:	e04a                	sd	s2,0(sp)
    80003bd4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003bd6:	c905                	beqz	a0,80003c06 <iunlock+0x3c>
    80003bd8:	84aa                	mv	s1,a0
    80003bda:	01050913          	addi	s2,a0,16
    80003bde:	854a                	mv	a0,s2
    80003be0:	00001097          	auipc	ra,0x1
    80003be4:	c82080e7          	jalr	-894(ra) # 80004862 <holdingsleep>
    80003be8:	cd19                	beqz	a0,80003c06 <iunlock+0x3c>
    80003bea:	449c                	lw	a5,8(s1)
    80003bec:	00f05d63          	blez	a5,80003c06 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003bf0:	854a                	mv	a0,s2
    80003bf2:	00001097          	auipc	ra,0x1
    80003bf6:	c2c080e7          	jalr	-980(ra) # 8000481e <releasesleep>
}
    80003bfa:	60e2                	ld	ra,24(sp)
    80003bfc:	6442                	ld	s0,16(sp)
    80003bfe:	64a2                	ld	s1,8(sp)
    80003c00:	6902                	ld	s2,0(sp)
    80003c02:	6105                	addi	sp,sp,32
    80003c04:	8082                	ret
    panic("iunlock");
    80003c06:	00005517          	auipc	a0,0x5
    80003c0a:	9b250513          	addi	a0,a0,-1614 # 800085b8 <etext+0x5b8>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	952080e7          	jalr	-1710(ra) # 80000560 <panic>

0000000080003c16 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003c16:	7179                	addi	sp,sp,-48
    80003c18:	f406                	sd	ra,40(sp)
    80003c1a:	f022                	sd	s0,32(sp)
    80003c1c:	ec26                	sd	s1,24(sp)
    80003c1e:	e84a                	sd	s2,16(sp)
    80003c20:	e44e                	sd	s3,8(sp)
    80003c22:	1800                	addi	s0,sp,48
    80003c24:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003c26:	05050493          	addi	s1,a0,80
    80003c2a:	08050913          	addi	s2,a0,128
    80003c2e:	a021                	j	80003c36 <itrunc+0x20>
    80003c30:	0491                	addi	s1,s1,4
    80003c32:	01248d63          	beq	s1,s2,80003c4c <itrunc+0x36>
    if(ip->addrs[i]){
    80003c36:	408c                	lw	a1,0(s1)
    80003c38:	dde5                	beqz	a1,80003c30 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003c3a:	0009a503          	lw	a0,0(s3)
    80003c3e:	00000097          	auipc	ra,0x0
    80003c42:	8d6080e7          	jalr	-1834(ra) # 80003514 <bfree>
      ip->addrs[i] = 0;
    80003c46:	0004a023          	sw	zero,0(s1)
    80003c4a:	b7dd                	j	80003c30 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003c4c:	0809a583          	lw	a1,128(s3)
    80003c50:	ed99                	bnez	a1,80003c6e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003c52:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003c56:	854e                	mv	a0,s3
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	de0080e7          	jalr	-544(ra) # 80003a38 <iupdate>
}
    80003c60:	70a2                	ld	ra,40(sp)
    80003c62:	7402                	ld	s0,32(sp)
    80003c64:	64e2                	ld	s1,24(sp)
    80003c66:	6942                	ld	s2,16(sp)
    80003c68:	69a2                	ld	s3,8(sp)
    80003c6a:	6145                	addi	sp,sp,48
    80003c6c:	8082                	ret
    80003c6e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003c70:	0009a503          	lw	a0,0(s3)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	65c080e7          	jalr	1628(ra) # 800032d0 <bread>
    80003c7c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003c7e:	05850493          	addi	s1,a0,88
    80003c82:	45850913          	addi	s2,a0,1112
    80003c86:	a021                	j	80003c8e <itrunc+0x78>
    80003c88:	0491                	addi	s1,s1,4
    80003c8a:	01248b63          	beq	s1,s2,80003ca0 <itrunc+0x8a>
      if(a[j])
    80003c8e:	408c                	lw	a1,0(s1)
    80003c90:	dde5                	beqz	a1,80003c88 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003c92:	0009a503          	lw	a0,0(s3)
    80003c96:	00000097          	auipc	ra,0x0
    80003c9a:	87e080e7          	jalr	-1922(ra) # 80003514 <bfree>
    80003c9e:	b7ed                	j	80003c88 <itrunc+0x72>
    brelse(bp);
    80003ca0:	8552                	mv	a0,s4
    80003ca2:	fffff097          	auipc	ra,0xfffff
    80003ca6:	75e080e7          	jalr	1886(ra) # 80003400 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003caa:	0809a583          	lw	a1,128(s3)
    80003cae:	0009a503          	lw	a0,0(s3)
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	862080e7          	jalr	-1950(ra) # 80003514 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003cba:	0809a023          	sw	zero,128(s3)
    80003cbe:	6a02                	ld	s4,0(sp)
    80003cc0:	bf49                	j	80003c52 <itrunc+0x3c>

0000000080003cc2 <iput>:
{
    80003cc2:	1101                	addi	sp,sp,-32
    80003cc4:	ec06                	sd	ra,24(sp)
    80003cc6:	e822                	sd	s0,16(sp)
    80003cc8:	e426                	sd	s1,8(sp)
    80003cca:	1000                	addi	s0,sp,32
    80003ccc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cce:	0001e517          	auipc	a0,0x1e
    80003cd2:	f7a50513          	addi	a0,a0,-134 # 80021c48 <itable>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	f62080e7          	jalr	-158(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003cde:	4498                	lw	a4,8(s1)
    80003ce0:	4785                	li	a5,1
    80003ce2:	02f70263          	beq	a4,a5,80003d06 <iput+0x44>
  ip->ref--;
    80003ce6:	449c                	lw	a5,8(s1)
    80003ce8:	37fd                	addiw	a5,a5,-1
    80003cea:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003cec:	0001e517          	auipc	a0,0x1e
    80003cf0:	f5c50513          	addi	a0,a0,-164 # 80021c48 <itable>
    80003cf4:	ffffd097          	auipc	ra,0xffffd
    80003cf8:	ff8080e7          	jalr	-8(ra) # 80000cec <release>
}
    80003cfc:	60e2                	ld	ra,24(sp)
    80003cfe:	6442                	ld	s0,16(sp)
    80003d00:	64a2                	ld	s1,8(sp)
    80003d02:	6105                	addi	sp,sp,32
    80003d04:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d06:	40bc                	lw	a5,64(s1)
    80003d08:	dff9                	beqz	a5,80003ce6 <iput+0x24>
    80003d0a:	04a49783          	lh	a5,74(s1)
    80003d0e:	ffe1                	bnez	a5,80003ce6 <iput+0x24>
    80003d10:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003d12:	01048913          	addi	s2,s1,16
    80003d16:	854a                	mv	a0,s2
    80003d18:	00001097          	auipc	ra,0x1
    80003d1c:	ab0080e7          	jalr	-1360(ra) # 800047c8 <acquiresleep>
    release(&itable.lock);
    80003d20:	0001e517          	auipc	a0,0x1e
    80003d24:	f2850513          	addi	a0,a0,-216 # 80021c48 <itable>
    80003d28:	ffffd097          	auipc	ra,0xffffd
    80003d2c:	fc4080e7          	jalr	-60(ra) # 80000cec <release>
    itrunc(ip);
    80003d30:	8526                	mv	a0,s1
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	ee4080e7          	jalr	-284(ra) # 80003c16 <itrunc>
    ip->type = 0;
    80003d3a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003d3e:	8526                	mv	a0,s1
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	cf8080e7          	jalr	-776(ra) # 80003a38 <iupdate>
    ip->valid = 0;
    80003d48:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003d4c:	854a                	mv	a0,s2
    80003d4e:	00001097          	auipc	ra,0x1
    80003d52:	ad0080e7          	jalr	-1328(ra) # 8000481e <releasesleep>
    acquire(&itable.lock);
    80003d56:	0001e517          	auipc	a0,0x1e
    80003d5a:	ef250513          	addi	a0,a0,-270 # 80021c48 <itable>
    80003d5e:	ffffd097          	auipc	ra,0xffffd
    80003d62:	eda080e7          	jalr	-294(ra) # 80000c38 <acquire>
    80003d66:	6902                	ld	s2,0(sp)
    80003d68:	bfbd                	j	80003ce6 <iput+0x24>

0000000080003d6a <iunlockput>:
{
    80003d6a:	1101                	addi	sp,sp,-32
    80003d6c:	ec06                	sd	ra,24(sp)
    80003d6e:	e822                	sd	s0,16(sp)
    80003d70:	e426                	sd	s1,8(sp)
    80003d72:	1000                	addi	s0,sp,32
    80003d74:	84aa                	mv	s1,a0
  iunlock(ip);
    80003d76:	00000097          	auipc	ra,0x0
    80003d7a:	e54080e7          	jalr	-428(ra) # 80003bca <iunlock>
  iput(ip);
    80003d7e:	8526                	mv	a0,s1
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	f42080e7          	jalr	-190(ra) # 80003cc2 <iput>
}
    80003d88:	60e2                	ld	ra,24(sp)
    80003d8a:	6442                	ld	s0,16(sp)
    80003d8c:	64a2                	ld	s1,8(sp)
    80003d8e:	6105                	addi	sp,sp,32
    80003d90:	8082                	ret

0000000080003d92 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d92:	1141                	addi	sp,sp,-16
    80003d94:	e422                	sd	s0,8(sp)
    80003d96:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d98:	411c                	lw	a5,0(a0)
    80003d9a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003d9c:	415c                	lw	a5,4(a0)
    80003d9e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003da0:	04451783          	lh	a5,68(a0)
    80003da4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003da8:	04a51783          	lh	a5,74(a0)
    80003dac:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003db0:	04c56783          	lwu	a5,76(a0)
    80003db4:	e99c                	sd	a5,16(a1)
}
    80003db6:	6422                	ld	s0,8(sp)
    80003db8:	0141                	addi	sp,sp,16
    80003dba:	8082                	ret

0000000080003dbc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dbc:	457c                	lw	a5,76(a0)
    80003dbe:	10d7e563          	bltu	a5,a3,80003ec8 <readi+0x10c>
{
    80003dc2:	7159                	addi	sp,sp,-112
    80003dc4:	f486                	sd	ra,104(sp)
    80003dc6:	f0a2                	sd	s0,96(sp)
    80003dc8:	eca6                	sd	s1,88(sp)
    80003dca:	e0d2                	sd	s4,64(sp)
    80003dcc:	fc56                	sd	s5,56(sp)
    80003dce:	f85a                	sd	s6,48(sp)
    80003dd0:	f45e                	sd	s7,40(sp)
    80003dd2:	1880                	addi	s0,sp,112
    80003dd4:	8b2a                	mv	s6,a0
    80003dd6:	8bae                	mv	s7,a1
    80003dd8:	8a32                	mv	s4,a2
    80003dda:	84b6                	mv	s1,a3
    80003ddc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003dde:	9f35                	addw	a4,a4,a3
    return 0;
    80003de0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003de2:	0cd76a63          	bltu	a4,a3,80003eb6 <readi+0xfa>
    80003de6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003de8:	00e7f463          	bgeu	a5,a4,80003df0 <readi+0x34>
    n = ip->size - off;
    80003dec:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003df0:	0a0a8963          	beqz	s5,80003ea2 <readi+0xe6>
    80003df4:	e8ca                	sd	s2,80(sp)
    80003df6:	f062                	sd	s8,32(sp)
    80003df8:	ec66                	sd	s9,24(sp)
    80003dfa:	e86a                	sd	s10,16(sp)
    80003dfc:	e46e                	sd	s11,8(sp)
    80003dfe:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e00:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e04:	5c7d                	li	s8,-1
    80003e06:	a82d                	j	80003e40 <readi+0x84>
    80003e08:	020d1d93          	slli	s11,s10,0x20
    80003e0c:	020ddd93          	srli	s11,s11,0x20
    80003e10:	05890613          	addi	a2,s2,88
    80003e14:	86ee                	mv	a3,s11
    80003e16:	963a                	add	a2,a2,a4
    80003e18:	85d2                	mv	a1,s4
    80003e1a:	855e                	mv	a0,s7
    80003e1c:	fffff097          	auipc	ra,0xfffff
    80003e20:	8fa080e7          	jalr	-1798(ra) # 80002716 <either_copyout>
    80003e24:	05850d63          	beq	a0,s8,80003e7e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003e28:	854a                	mv	a0,s2
    80003e2a:	fffff097          	auipc	ra,0xfffff
    80003e2e:	5d6080e7          	jalr	1494(ra) # 80003400 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e32:	013d09bb          	addw	s3,s10,s3
    80003e36:	009d04bb          	addw	s1,s10,s1
    80003e3a:	9a6e                	add	s4,s4,s11
    80003e3c:	0559fd63          	bgeu	s3,s5,80003e96 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003e40:	00a4d59b          	srliw	a1,s1,0xa
    80003e44:	855a                	mv	a0,s6
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	88e080e7          	jalr	-1906(ra) # 800036d4 <bmap>
    80003e4e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003e52:	c9b1                	beqz	a1,80003ea6 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003e54:	000b2503          	lw	a0,0(s6)
    80003e58:	fffff097          	auipc	ra,0xfffff
    80003e5c:	478080e7          	jalr	1144(ra) # 800032d0 <bread>
    80003e60:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e62:	3ff4f713          	andi	a4,s1,1023
    80003e66:	40ec87bb          	subw	a5,s9,a4
    80003e6a:	413a86bb          	subw	a3,s5,s3
    80003e6e:	8d3e                	mv	s10,a5
    80003e70:	2781                	sext.w	a5,a5
    80003e72:	0006861b          	sext.w	a2,a3
    80003e76:	f8f679e3          	bgeu	a2,a5,80003e08 <readi+0x4c>
    80003e7a:	8d36                	mv	s10,a3
    80003e7c:	b771                	j	80003e08 <readi+0x4c>
      brelse(bp);
    80003e7e:	854a                	mv	a0,s2
    80003e80:	fffff097          	auipc	ra,0xfffff
    80003e84:	580080e7          	jalr	1408(ra) # 80003400 <brelse>
      tot = -1;
    80003e88:	59fd                	li	s3,-1
      break;
    80003e8a:	6946                	ld	s2,80(sp)
    80003e8c:	7c02                	ld	s8,32(sp)
    80003e8e:	6ce2                	ld	s9,24(sp)
    80003e90:	6d42                	ld	s10,16(sp)
    80003e92:	6da2                	ld	s11,8(sp)
    80003e94:	a831                	j	80003eb0 <readi+0xf4>
    80003e96:	6946                	ld	s2,80(sp)
    80003e98:	7c02                	ld	s8,32(sp)
    80003e9a:	6ce2                	ld	s9,24(sp)
    80003e9c:	6d42                	ld	s10,16(sp)
    80003e9e:	6da2                	ld	s11,8(sp)
    80003ea0:	a801                	j	80003eb0 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ea2:	89d6                	mv	s3,s5
    80003ea4:	a031                	j	80003eb0 <readi+0xf4>
    80003ea6:	6946                	ld	s2,80(sp)
    80003ea8:	7c02                	ld	s8,32(sp)
    80003eaa:	6ce2                	ld	s9,24(sp)
    80003eac:	6d42                	ld	s10,16(sp)
    80003eae:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003eb0:	0009851b          	sext.w	a0,s3
    80003eb4:	69a6                	ld	s3,72(sp)
}
    80003eb6:	70a6                	ld	ra,104(sp)
    80003eb8:	7406                	ld	s0,96(sp)
    80003eba:	64e6                	ld	s1,88(sp)
    80003ebc:	6a06                	ld	s4,64(sp)
    80003ebe:	7ae2                	ld	s5,56(sp)
    80003ec0:	7b42                	ld	s6,48(sp)
    80003ec2:	7ba2                	ld	s7,40(sp)
    80003ec4:	6165                	addi	sp,sp,112
    80003ec6:	8082                	ret
    return 0;
    80003ec8:	4501                	li	a0,0
}
    80003eca:	8082                	ret

0000000080003ecc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ecc:	457c                	lw	a5,76(a0)
    80003ece:	10d7ee63          	bltu	a5,a3,80003fea <writei+0x11e>
{
    80003ed2:	7159                	addi	sp,sp,-112
    80003ed4:	f486                	sd	ra,104(sp)
    80003ed6:	f0a2                	sd	s0,96(sp)
    80003ed8:	e8ca                	sd	s2,80(sp)
    80003eda:	e0d2                	sd	s4,64(sp)
    80003edc:	fc56                	sd	s5,56(sp)
    80003ede:	f85a                	sd	s6,48(sp)
    80003ee0:	f45e                	sd	s7,40(sp)
    80003ee2:	1880                	addi	s0,sp,112
    80003ee4:	8aaa                	mv	s5,a0
    80003ee6:	8bae                	mv	s7,a1
    80003ee8:	8a32                	mv	s4,a2
    80003eea:	8936                	mv	s2,a3
    80003eec:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003eee:	00e687bb          	addw	a5,a3,a4
    80003ef2:	0ed7ee63          	bltu	a5,a3,80003fee <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ef6:	00043737          	lui	a4,0x43
    80003efa:	0ef76c63          	bltu	a4,a5,80003ff2 <writei+0x126>
    80003efe:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f00:	0c0b0d63          	beqz	s6,80003fda <writei+0x10e>
    80003f04:	eca6                	sd	s1,88(sp)
    80003f06:	f062                	sd	s8,32(sp)
    80003f08:	ec66                	sd	s9,24(sp)
    80003f0a:	e86a                	sd	s10,16(sp)
    80003f0c:	e46e                	sd	s11,8(sp)
    80003f0e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f10:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f14:	5c7d                	li	s8,-1
    80003f16:	a091                	j	80003f5a <writei+0x8e>
    80003f18:	020d1d93          	slli	s11,s10,0x20
    80003f1c:	020ddd93          	srli	s11,s11,0x20
    80003f20:	05848513          	addi	a0,s1,88
    80003f24:	86ee                	mv	a3,s11
    80003f26:	8652                	mv	a2,s4
    80003f28:	85de                	mv	a1,s7
    80003f2a:	953a                	add	a0,a0,a4
    80003f2c:	fffff097          	auipc	ra,0xfffff
    80003f30:	840080e7          	jalr	-1984(ra) # 8000276c <either_copyin>
    80003f34:	07850263          	beq	a0,s8,80003f98 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003f38:	8526                	mv	a0,s1
    80003f3a:	00000097          	auipc	ra,0x0
    80003f3e:	770080e7          	jalr	1904(ra) # 800046aa <log_write>
    brelse(bp);
    80003f42:	8526                	mv	a0,s1
    80003f44:	fffff097          	auipc	ra,0xfffff
    80003f48:	4bc080e7          	jalr	1212(ra) # 80003400 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f4c:	013d09bb          	addw	s3,s10,s3
    80003f50:	012d093b          	addw	s2,s10,s2
    80003f54:	9a6e                	add	s4,s4,s11
    80003f56:	0569f663          	bgeu	s3,s6,80003fa2 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003f5a:	00a9559b          	srliw	a1,s2,0xa
    80003f5e:	8556                	mv	a0,s5
    80003f60:	fffff097          	auipc	ra,0xfffff
    80003f64:	774080e7          	jalr	1908(ra) # 800036d4 <bmap>
    80003f68:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f6c:	c99d                	beqz	a1,80003fa2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003f6e:	000aa503          	lw	a0,0(s5)
    80003f72:	fffff097          	auipc	ra,0xfffff
    80003f76:	35e080e7          	jalr	862(ra) # 800032d0 <bread>
    80003f7a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f7c:	3ff97713          	andi	a4,s2,1023
    80003f80:	40ec87bb          	subw	a5,s9,a4
    80003f84:	413b06bb          	subw	a3,s6,s3
    80003f88:	8d3e                	mv	s10,a5
    80003f8a:	2781                	sext.w	a5,a5
    80003f8c:	0006861b          	sext.w	a2,a3
    80003f90:	f8f674e3          	bgeu	a2,a5,80003f18 <writei+0x4c>
    80003f94:	8d36                	mv	s10,a3
    80003f96:	b749                	j	80003f18 <writei+0x4c>
      brelse(bp);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	fffff097          	auipc	ra,0xfffff
    80003f9e:	466080e7          	jalr	1126(ra) # 80003400 <brelse>
  }

  if(off > ip->size)
    80003fa2:	04caa783          	lw	a5,76(s5)
    80003fa6:	0327fc63          	bgeu	a5,s2,80003fde <writei+0x112>
    ip->size = off;
    80003faa:	052aa623          	sw	s2,76(s5)
    80003fae:	64e6                	ld	s1,88(sp)
    80003fb0:	7c02                	ld	s8,32(sp)
    80003fb2:	6ce2                	ld	s9,24(sp)
    80003fb4:	6d42                	ld	s10,16(sp)
    80003fb6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003fb8:	8556                	mv	a0,s5
    80003fba:	00000097          	auipc	ra,0x0
    80003fbe:	a7e080e7          	jalr	-1410(ra) # 80003a38 <iupdate>

  return tot;
    80003fc2:	0009851b          	sext.w	a0,s3
    80003fc6:	69a6                	ld	s3,72(sp)
}
    80003fc8:	70a6                	ld	ra,104(sp)
    80003fca:	7406                	ld	s0,96(sp)
    80003fcc:	6946                	ld	s2,80(sp)
    80003fce:	6a06                	ld	s4,64(sp)
    80003fd0:	7ae2                	ld	s5,56(sp)
    80003fd2:	7b42                	ld	s6,48(sp)
    80003fd4:	7ba2                	ld	s7,40(sp)
    80003fd6:	6165                	addi	sp,sp,112
    80003fd8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fda:	89da                	mv	s3,s6
    80003fdc:	bff1                	j	80003fb8 <writei+0xec>
    80003fde:	64e6                	ld	s1,88(sp)
    80003fe0:	7c02                	ld	s8,32(sp)
    80003fe2:	6ce2                	ld	s9,24(sp)
    80003fe4:	6d42                	ld	s10,16(sp)
    80003fe6:	6da2                	ld	s11,8(sp)
    80003fe8:	bfc1                	j	80003fb8 <writei+0xec>
    return -1;
    80003fea:	557d                	li	a0,-1
}
    80003fec:	8082                	ret
    return -1;
    80003fee:	557d                	li	a0,-1
    80003ff0:	bfe1                	j	80003fc8 <writei+0xfc>
    return -1;
    80003ff2:	557d                	li	a0,-1
    80003ff4:	bfd1                	j	80003fc8 <writei+0xfc>

0000000080003ff6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ff6:	1141                	addi	sp,sp,-16
    80003ff8:	e406                	sd	ra,8(sp)
    80003ffa:	e022                	sd	s0,0(sp)
    80003ffc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ffe:	4639                	li	a2,14
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	e04080e7          	jalr	-508(ra) # 80000e04 <strncmp>
}
    80004008:	60a2                	ld	ra,8(sp)
    8000400a:	6402                	ld	s0,0(sp)
    8000400c:	0141                	addi	sp,sp,16
    8000400e:	8082                	ret

0000000080004010 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004010:	7139                	addi	sp,sp,-64
    80004012:	fc06                	sd	ra,56(sp)
    80004014:	f822                	sd	s0,48(sp)
    80004016:	f426                	sd	s1,40(sp)
    80004018:	f04a                	sd	s2,32(sp)
    8000401a:	ec4e                	sd	s3,24(sp)
    8000401c:	e852                	sd	s4,16(sp)
    8000401e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004020:	04451703          	lh	a4,68(a0)
    80004024:	4785                	li	a5,1
    80004026:	00f71a63          	bne	a4,a5,8000403a <dirlookup+0x2a>
    8000402a:	892a                	mv	s2,a0
    8000402c:	89ae                	mv	s3,a1
    8000402e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004030:	457c                	lw	a5,76(a0)
    80004032:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004034:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004036:	e79d                	bnez	a5,80004064 <dirlookup+0x54>
    80004038:	a8a5                	j	800040b0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000403a:	00004517          	auipc	a0,0x4
    8000403e:	58650513          	addi	a0,a0,1414 # 800085c0 <etext+0x5c0>
    80004042:	ffffc097          	auipc	ra,0xffffc
    80004046:	51e080e7          	jalr	1310(ra) # 80000560 <panic>
      panic("dirlookup read");
    8000404a:	00004517          	auipc	a0,0x4
    8000404e:	58e50513          	addi	a0,a0,1422 # 800085d8 <etext+0x5d8>
    80004052:	ffffc097          	auipc	ra,0xffffc
    80004056:	50e080e7          	jalr	1294(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000405a:	24c1                	addiw	s1,s1,16
    8000405c:	04c92783          	lw	a5,76(s2)
    80004060:	04f4f763          	bgeu	s1,a5,800040ae <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004064:	4741                	li	a4,16
    80004066:	86a6                	mv	a3,s1
    80004068:	fc040613          	addi	a2,s0,-64
    8000406c:	4581                	li	a1,0
    8000406e:	854a                	mv	a0,s2
    80004070:	00000097          	auipc	ra,0x0
    80004074:	d4c080e7          	jalr	-692(ra) # 80003dbc <readi>
    80004078:	47c1                	li	a5,16
    8000407a:	fcf518e3          	bne	a0,a5,8000404a <dirlookup+0x3a>
    if(de.inum == 0)
    8000407e:	fc045783          	lhu	a5,-64(s0)
    80004082:	dfe1                	beqz	a5,8000405a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004084:	fc240593          	addi	a1,s0,-62
    80004088:	854e                	mv	a0,s3
    8000408a:	00000097          	auipc	ra,0x0
    8000408e:	f6c080e7          	jalr	-148(ra) # 80003ff6 <namecmp>
    80004092:	f561                	bnez	a0,8000405a <dirlookup+0x4a>
      if(poff)
    80004094:	000a0463          	beqz	s4,8000409c <dirlookup+0x8c>
        *poff = off;
    80004098:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000409c:	fc045583          	lhu	a1,-64(s0)
    800040a0:	00092503          	lw	a0,0(s2)
    800040a4:	fffff097          	auipc	ra,0xfffff
    800040a8:	720080e7          	jalr	1824(ra) # 800037c4 <iget>
    800040ac:	a011                	j	800040b0 <dirlookup+0xa0>
  return 0;
    800040ae:	4501                	li	a0,0
}
    800040b0:	70e2                	ld	ra,56(sp)
    800040b2:	7442                	ld	s0,48(sp)
    800040b4:	74a2                	ld	s1,40(sp)
    800040b6:	7902                	ld	s2,32(sp)
    800040b8:	69e2                	ld	s3,24(sp)
    800040ba:	6a42                	ld	s4,16(sp)
    800040bc:	6121                	addi	sp,sp,64
    800040be:	8082                	ret

00000000800040c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800040c0:	711d                	addi	sp,sp,-96
    800040c2:	ec86                	sd	ra,88(sp)
    800040c4:	e8a2                	sd	s0,80(sp)
    800040c6:	e4a6                	sd	s1,72(sp)
    800040c8:	e0ca                	sd	s2,64(sp)
    800040ca:	fc4e                	sd	s3,56(sp)
    800040cc:	f852                	sd	s4,48(sp)
    800040ce:	f456                	sd	s5,40(sp)
    800040d0:	f05a                	sd	s6,32(sp)
    800040d2:	ec5e                	sd	s7,24(sp)
    800040d4:	e862                	sd	s8,16(sp)
    800040d6:	e466                	sd	s9,8(sp)
    800040d8:	1080                	addi	s0,sp,96
    800040da:	84aa                	mv	s1,a0
    800040dc:	8b2e                	mv	s6,a1
    800040de:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800040e0:	00054703          	lbu	a4,0(a0)
    800040e4:	02f00793          	li	a5,47
    800040e8:	02f70263          	beq	a4,a5,8000410c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800040ec:	ffffe097          	auipc	ra,0xffffe
    800040f0:	a4a080e7          	jalr	-1462(ra) # 80001b36 <myproc>
    800040f4:	15053503          	ld	a0,336(a0)
    800040f8:	00000097          	auipc	ra,0x0
    800040fc:	9ce080e7          	jalr	-1586(ra) # 80003ac6 <idup>
    80004100:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004102:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004106:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004108:	4b85                	li	s7,1
    8000410a:	a875                	j	800041c6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000410c:	4585                	li	a1,1
    8000410e:	4505                	li	a0,1
    80004110:	fffff097          	auipc	ra,0xfffff
    80004114:	6b4080e7          	jalr	1716(ra) # 800037c4 <iget>
    80004118:	8a2a                	mv	s4,a0
    8000411a:	b7e5                	j	80004102 <namex+0x42>
      iunlockput(ip);
    8000411c:	8552                	mv	a0,s4
    8000411e:	00000097          	auipc	ra,0x0
    80004122:	c4c080e7          	jalr	-948(ra) # 80003d6a <iunlockput>
      return 0;
    80004126:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004128:	8552                	mv	a0,s4
    8000412a:	60e6                	ld	ra,88(sp)
    8000412c:	6446                	ld	s0,80(sp)
    8000412e:	64a6                	ld	s1,72(sp)
    80004130:	6906                	ld	s2,64(sp)
    80004132:	79e2                	ld	s3,56(sp)
    80004134:	7a42                	ld	s4,48(sp)
    80004136:	7aa2                	ld	s5,40(sp)
    80004138:	7b02                	ld	s6,32(sp)
    8000413a:	6be2                	ld	s7,24(sp)
    8000413c:	6c42                	ld	s8,16(sp)
    8000413e:	6ca2                	ld	s9,8(sp)
    80004140:	6125                	addi	sp,sp,96
    80004142:	8082                	ret
      iunlock(ip);
    80004144:	8552                	mv	a0,s4
    80004146:	00000097          	auipc	ra,0x0
    8000414a:	a84080e7          	jalr	-1404(ra) # 80003bca <iunlock>
      return ip;
    8000414e:	bfe9                	j	80004128 <namex+0x68>
      iunlockput(ip);
    80004150:	8552                	mv	a0,s4
    80004152:	00000097          	auipc	ra,0x0
    80004156:	c18080e7          	jalr	-1000(ra) # 80003d6a <iunlockput>
      return 0;
    8000415a:	8a4e                	mv	s4,s3
    8000415c:	b7f1                	j	80004128 <namex+0x68>
  len = path - s;
    8000415e:	40998633          	sub	a2,s3,s1
    80004162:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004166:	099c5863          	bge	s8,s9,800041f6 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000416a:	4639                	li	a2,14
    8000416c:	85a6                	mv	a1,s1
    8000416e:	8556                	mv	a0,s5
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	c20080e7          	jalr	-992(ra) # 80000d90 <memmove>
    80004178:	84ce                	mv	s1,s3
  while(*path == '/')
    8000417a:	0004c783          	lbu	a5,0(s1)
    8000417e:	01279763          	bne	a5,s2,8000418c <namex+0xcc>
    path++;
    80004182:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004184:	0004c783          	lbu	a5,0(s1)
    80004188:	ff278de3          	beq	a5,s2,80004182 <namex+0xc2>
    ilock(ip);
    8000418c:	8552                	mv	a0,s4
    8000418e:	00000097          	auipc	ra,0x0
    80004192:	976080e7          	jalr	-1674(ra) # 80003b04 <ilock>
    if(ip->type != T_DIR){
    80004196:	044a1783          	lh	a5,68(s4)
    8000419a:	f97791e3          	bne	a5,s7,8000411c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000419e:	000b0563          	beqz	s6,800041a8 <namex+0xe8>
    800041a2:	0004c783          	lbu	a5,0(s1)
    800041a6:	dfd9                	beqz	a5,80004144 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800041a8:	4601                	li	a2,0
    800041aa:	85d6                	mv	a1,s5
    800041ac:	8552                	mv	a0,s4
    800041ae:	00000097          	auipc	ra,0x0
    800041b2:	e62080e7          	jalr	-414(ra) # 80004010 <dirlookup>
    800041b6:	89aa                	mv	s3,a0
    800041b8:	dd41                	beqz	a0,80004150 <namex+0x90>
    iunlockput(ip);
    800041ba:	8552                	mv	a0,s4
    800041bc:	00000097          	auipc	ra,0x0
    800041c0:	bae080e7          	jalr	-1106(ra) # 80003d6a <iunlockput>
    ip = next;
    800041c4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800041c6:	0004c783          	lbu	a5,0(s1)
    800041ca:	01279763          	bne	a5,s2,800041d8 <namex+0x118>
    path++;
    800041ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041d0:	0004c783          	lbu	a5,0(s1)
    800041d4:	ff278de3          	beq	a5,s2,800041ce <namex+0x10e>
  if(*path == 0)
    800041d8:	cb9d                	beqz	a5,8000420e <namex+0x14e>
  while(*path != '/' && *path != 0)
    800041da:	0004c783          	lbu	a5,0(s1)
    800041de:	89a6                	mv	s3,s1
  len = path - s;
    800041e0:	4c81                	li	s9,0
    800041e2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800041e4:	01278963          	beq	a5,s2,800041f6 <namex+0x136>
    800041e8:	dbbd                	beqz	a5,8000415e <namex+0x9e>
    path++;
    800041ea:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800041ec:	0009c783          	lbu	a5,0(s3)
    800041f0:	ff279ce3          	bne	a5,s2,800041e8 <namex+0x128>
    800041f4:	b7ad                	j	8000415e <namex+0x9e>
    memmove(name, s, len);
    800041f6:	2601                	sext.w	a2,a2
    800041f8:	85a6                	mv	a1,s1
    800041fa:	8556                	mv	a0,s5
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	b94080e7          	jalr	-1132(ra) # 80000d90 <memmove>
    name[len] = 0;
    80004204:	9cd6                	add	s9,s9,s5
    80004206:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000420a:	84ce                	mv	s1,s3
    8000420c:	b7bd                	j	8000417a <namex+0xba>
  if(nameiparent){
    8000420e:	f00b0de3          	beqz	s6,80004128 <namex+0x68>
    iput(ip);
    80004212:	8552                	mv	a0,s4
    80004214:	00000097          	auipc	ra,0x0
    80004218:	aae080e7          	jalr	-1362(ra) # 80003cc2 <iput>
    return 0;
    8000421c:	4a01                	li	s4,0
    8000421e:	b729                	j	80004128 <namex+0x68>

0000000080004220 <dirlink>:
{
    80004220:	7139                	addi	sp,sp,-64
    80004222:	fc06                	sd	ra,56(sp)
    80004224:	f822                	sd	s0,48(sp)
    80004226:	f04a                	sd	s2,32(sp)
    80004228:	ec4e                	sd	s3,24(sp)
    8000422a:	e852                	sd	s4,16(sp)
    8000422c:	0080                	addi	s0,sp,64
    8000422e:	892a                	mv	s2,a0
    80004230:	8a2e                	mv	s4,a1
    80004232:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004234:	4601                	li	a2,0
    80004236:	00000097          	auipc	ra,0x0
    8000423a:	dda080e7          	jalr	-550(ra) # 80004010 <dirlookup>
    8000423e:	ed25                	bnez	a0,800042b6 <dirlink+0x96>
    80004240:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004242:	04c92483          	lw	s1,76(s2)
    80004246:	c49d                	beqz	s1,80004274 <dirlink+0x54>
    80004248:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000424a:	4741                	li	a4,16
    8000424c:	86a6                	mv	a3,s1
    8000424e:	fc040613          	addi	a2,s0,-64
    80004252:	4581                	li	a1,0
    80004254:	854a                	mv	a0,s2
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	b66080e7          	jalr	-1178(ra) # 80003dbc <readi>
    8000425e:	47c1                	li	a5,16
    80004260:	06f51163          	bne	a0,a5,800042c2 <dirlink+0xa2>
    if(de.inum == 0)
    80004264:	fc045783          	lhu	a5,-64(s0)
    80004268:	c791                	beqz	a5,80004274 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000426a:	24c1                	addiw	s1,s1,16
    8000426c:	04c92783          	lw	a5,76(s2)
    80004270:	fcf4ede3          	bltu	s1,a5,8000424a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004274:	4639                	li	a2,14
    80004276:	85d2                	mv	a1,s4
    80004278:	fc240513          	addi	a0,s0,-62
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	bbe080e7          	jalr	-1090(ra) # 80000e3a <strncpy>
  de.inum = inum;
    80004284:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004288:	4741                	li	a4,16
    8000428a:	86a6                	mv	a3,s1
    8000428c:	fc040613          	addi	a2,s0,-64
    80004290:	4581                	li	a1,0
    80004292:	854a                	mv	a0,s2
    80004294:	00000097          	auipc	ra,0x0
    80004298:	c38080e7          	jalr	-968(ra) # 80003ecc <writei>
    8000429c:	1541                	addi	a0,a0,-16
    8000429e:	00a03533          	snez	a0,a0
    800042a2:	40a00533          	neg	a0,a0
    800042a6:	74a2                	ld	s1,40(sp)
}
    800042a8:	70e2                	ld	ra,56(sp)
    800042aa:	7442                	ld	s0,48(sp)
    800042ac:	7902                	ld	s2,32(sp)
    800042ae:	69e2                	ld	s3,24(sp)
    800042b0:	6a42                	ld	s4,16(sp)
    800042b2:	6121                	addi	sp,sp,64
    800042b4:	8082                	ret
    iput(ip);
    800042b6:	00000097          	auipc	ra,0x0
    800042ba:	a0c080e7          	jalr	-1524(ra) # 80003cc2 <iput>
    return -1;
    800042be:	557d                	li	a0,-1
    800042c0:	b7e5                	j	800042a8 <dirlink+0x88>
      panic("dirlink read");
    800042c2:	00004517          	auipc	a0,0x4
    800042c6:	32650513          	addi	a0,a0,806 # 800085e8 <etext+0x5e8>
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	296080e7          	jalr	662(ra) # 80000560 <panic>

00000000800042d2 <namei>:

struct inode*
namei(char *path)
{
    800042d2:	1101                	addi	sp,sp,-32
    800042d4:	ec06                	sd	ra,24(sp)
    800042d6:	e822                	sd	s0,16(sp)
    800042d8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800042da:	fe040613          	addi	a2,s0,-32
    800042de:	4581                	li	a1,0
    800042e0:	00000097          	auipc	ra,0x0
    800042e4:	de0080e7          	jalr	-544(ra) # 800040c0 <namex>
}
    800042e8:	60e2                	ld	ra,24(sp)
    800042ea:	6442                	ld	s0,16(sp)
    800042ec:	6105                	addi	sp,sp,32
    800042ee:	8082                	ret

00000000800042f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800042f0:	1141                	addi	sp,sp,-16
    800042f2:	e406                	sd	ra,8(sp)
    800042f4:	e022                	sd	s0,0(sp)
    800042f6:	0800                	addi	s0,sp,16
    800042f8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800042fa:	4585                	li	a1,1
    800042fc:	00000097          	auipc	ra,0x0
    80004300:	dc4080e7          	jalr	-572(ra) # 800040c0 <namex>
}
    80004304:	60a2                	ld	ra,8(sp)
    80004306:	6402                	ld	s0,0(sp)
    80004308:	0141                	addi	sp,sp,16
    8000430a:	8082                	ret

000000008000430c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000430c:	1101                	addi	sp,sp,-32
    8000430e:	ec06                	sd	ra,24(sp)
    80004310:	e822                	sd	s0,16(sp)
    80004312:	e426                	sd	s1,8(sp)
    80004314:	e04a                	sd	s2,0(sp)
    80004316:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004318:	0001f917          	auipc	s2,0x1f
    8000431c:	3d890913          	addi	s2,s2,984 # 800236f0 <log>
    80004320:	01892583          	lw	a1,24(s2)
    80004324:	02892503          	lw	a0,40(s2)
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	fa8080e7          	jalr	-88(ra) # 800032d0 <bread>
    80004330:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004332:	02c92603          	lw	a2,44(s2)
    80004336:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004338:	00c05f63          	blez	a2,80004356 <write_head+0x4a>
    8000433c:	0001f717          	auipc	a4,0x1f
    80004340:	3e470713          	addi	a4,a4,996 # 80023720 <log+0x30>
    80004344:	87aa                	mv	a5,a0
    80004346:	060a                	slli	a2,a2,0x2
    80004348:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000434a:	4314                	lw	a3,0(a4)
    8000434c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000434e:	0711                	addi	a4,a4,4
    80004350:	0791                	addi	a5,a5,4
    80004352:	fec79ce3          	bne	a5,a2,8000434a <write_head+0x3e>
  }
  bwrite(buf);
    80004356:	8526                	mv	a0,s1
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	06a080e7          	jalr	106(ra) # 800033c2 <bwrite>
  brelse(buf);
    80004360:	8526                	mv	a0,s1
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	09e080e7          	jalr	158(ra) # 80003400 <brelse>
}
    8000436a:	60e2                	ld	ra,24(sp)
    8000436c:	6442                	ld	s0,16(sp)
    8000436e:	64a2                	ld	s1,8(sp)
    80004370:	6902                	ld	s2,0(sp)
    80004372:	6105                	addi	sp,sp,32
    80004374:	8082                	ret

0000000080004376 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004376:	0001f797          	auipc	a5,0x1f
    8000437a:	3a67a783          	lw	a5,934(a5) # 8002371c <log+0x2c>
    8000437e:	0af05d63          	blez	a5,80004438 <install_trans+0xc2>
{
    80004382:	7139                	addi	sp,sp,-64
    80004384:	fc06                	sd	ra,56(sp)
    80004386:	f822                	sd	s0,48(sp)
    80004388:	f426                	sd	s1,40(sp)
    8000438a:	f04a                	sd	s2,32(sp)
    8000438c:	ec4e                	sd	s3,24(sp)
    8000438e:	e852                	sd	s4,16(sp)
    80004390:	e456                	sd	s5,8(sp)
    80004392:	e05a                	sd	s6,0(sp)
    80004394:	0080                	addi	s0,sp,64
    80004396:	8b2a                	mv	s6,a0
    80004398:	0001fa97          	auipc	s5,0x1f
    8000439c:	388a8a93          	addi	s5,s5,904 # 80023720 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043a0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043a2:	0001f997          	auipc	s3,0x1f
    800043a6:	34e98993          	addi	s3,s3,846 # 800236f0 <log>
    800043aa:	a00d                	j	800043cc <install_trans+0x56>
    brelse(lbuf);
    800043ac:	854a                	mv	a0,s2
    800043ae:	fffff097          	auipc	ra,0xfffff
    800043b2:	052080e7          	jalr	82(ra) # 80003400 <brelse>
    brelse(dbuf);
    800043b6:	8526                	mv	a0,s1
    800043b8:	fffff097          	auipc	ra,0xfffff
    800043bc:	048080e7          	jalr	72(ra) # 80003400 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043c0:	2a05                	addiw	s4,s4,1
    800043c2:	0a91                	addi	s5,s5,4
    800043c4:	02c9a783          	lw	a5,44(s3)
    800043c8:	04fa5e63          	bge	s4,a5,80004424 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043cc:	0189a583          	lw	a1,24(s3)
    800043d0:	014585bb          	addw	a1,a1,s4
    800043d4:	2585                	addiw	a1,a1,1
    800043d6:	0289a503          	lw	a0,40(s3)
    800043da:	fffff097          	auipc	ra,0xfffff
    800043de:	ef6080e7          	jalr	-266(ra) # 800032d0 <bread>
    800043e2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800043e4:	000aa583          	lw	a1,0(s5)
    800043e8:	0289a503          	lw	a0,40(s3)
    800043ec:	fffff097          	auipc	ra,0xfffff
    800043f0:	ee4080e7          	jalr	-284(ra) # 800032d0 <bread>
    800043f4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043f6:	40000613          	li	a2,1024
    800043fa:	05890593          	addi	a1,s2,88
    800043fe:	05850513          	addi	a0,a0,88
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	98e080e7          	jalr	-1650(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000440a:	8526                	mv	a0,s1
    8000440c:	fffff097          	auipc	ra,0xfffff
    80004410:	fb6080e7          	jalr	-74(ra) # 800033c2 <bwrite>
    if(recovering == 0)
    80004414:	f80b1ce3          	bnez	s6,800043ac <install_trans+0x36>
      bunpin(dbuf);
    80004418:	8526                	mv	a0,s1
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	0be080e7          	jalr	190(ra) # 800034d8 <bunpin>
    80004422:	b769                	j	800043ac <install_trans+0x36>
}
    80004424:	70e2                	ld	ra,56(sp)
    80004426:	7442                	ld	s0,48(sp)
    80004428:	74a2                	ld	s1,40(sp)
    8000442a:	7902                	ld	s2,32(sp)
    8000442c:	69e2                	ld	s3,24(sp)
    8000442e:	6a42                	ld	s4,16(sp)
    80004430:	6aa2                	ld	s5,8(sp)
    80004432:	6b02                	ld	s6,0(sp)
    80004434:	6121                	addi	sp,sp,64
    80004436:	8082                	ret
    80004438:	8082                	ret

000000008000443a <initlog>:
{
    8000443a:	7179                	addi	sp,sp,-48
    8000443c:	f406                	sd	ra,40(sp)
    8000443e:	f022                	sd	s0,32(sp)
    80004440:	ec26                	sd	s1,24(sp)
    80004442:	e84a                	sd	s2,16(sp)
    80004444:	e44e                	sd	s3,8(sp)
    80004446:	1800                	addi	s0,sp,48
    80004448:	892a                	mv	s2,a0
    8000444a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000444c:	0001f497          	auipc	s1,0x1f
    80004450:	2a448493          	addi	s1,s1,676 # 800236f0 <log>
    80004454:	00004597          	auipc	a1,0x4
    80004458:	1a458593          	addi	a1,a1,420 # 800085f8 <etext+0x5f8>
    8000445c:	8526                	mv	a0,s1
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	74a080e7          	jalr	1866(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    80004466:	0149a583          	lw	a1,20(s3)
    8000446a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000446c:	0109a783          	lw	a5,16(s3)
    80004470:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004472:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004476:	854a                	mv	a0,s2
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	e58080e7          	jalr	-424(ra) # 800032d0 <bread>
  log.lh.n = lh->n;
    80004480:	4d30                	lw	a2,88(a0)
    80004482:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004484:	00c05f63          	blez	a2,800044a2 <initlog+0x68>
    80004488:	87aa                	mv	a5,a0
    8000448a:	0001f717          	auipc	a4,0x1f
    8000448e:	29670713          	addi	a4,a4,662 # 80023720 <log+0x30>
    80004492:	060a                	slli	a2,a2,0x2
    80004494:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004496:	4ff4                	lw	a3,92(a5)
    80004498:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000449a:	0791                	addi	a5,a5,4
    8000449c:	0711                	addi	a4,a4,4
    8000449e:	fec79ce3          	bne	a5,a2,80004496 <initlog+0x5c>
  brelse(buf);
    800044a2:	fffff097          	auipc	ra,0xfffff
    800044a6:	f5e080e7          	jalr	-162(ra) # 80003400 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800044aa:	4505                	li	a0,1
    800044ac:	00000097          	auipc	ra,0x0
    800044b0:	eca080e7          	jalr	-310(ra) # 80004376 <install_trans>
  log.lh.n = 0;
    800044b4:	0001f797          	auipc	a5,0x1f
    800044b8:	2607a423          	sw	zero,616(a5) # 8002371c <log+0x2c>
  write_head(); // clear the log
    800044bc:	00000097          	auipc	ra,0x0
    800044c0:	e50080e7          	jalr	-432(ra) # 8000430c <write_head>
}
    800044c4:	70a2                	ld	ra,40(sp)
    800044c6:	7402                	ld	s0,32(sp)
    800044c8:	64e2                	ld	s1,24(sp)
    800044ca:	6942                	ld	s2,16(sp)
    800044cc:	69a2                	ld	s3,8(sp)
    800044ce:	6145                	addi	sp,sp,48
    800044d0:	8082                	ret

00000000800044d2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800044d2:	1101                	addi	sp,sp,-32
    800044d4:	ec06                	sd	ra,24(sp)
    800044d6:	e822                	sd	s0,16(sp)
    800044d8:	e426                	sd	s1,8(sp)
    800044da:	e04a                	sd	s2,0(sp)
    800044dc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800044de:	0001f517          	auipc	a0,0x1f
    800044e2:	21250513          	addi	a0,a0,530 # 800236f0 <log>
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	752080e7          	jalr	1874(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    800044ee:	0001f497          	auipc	s1,0x1f
    800044f2:	20248493          	addi	s1,s1,514 # 800236f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800044f6:	4979                	li	s2,30
    800044f8:	a039                	j	80004506 <begin_op+0x34>
      sleep(&log, &log.lock);
    800044fa:	85a6                	mv	a1,s1
    800044fc:	8526                	mv	a0,s1
    800044fe:	ffffe097          	auipc	ra,0xffffe
    80004502:	e10080e7          	jalr	-496(ra) # 8000230e <sleep>
    if(log.committing){
    80004506:	50dc                	lw	a5,36(s1)
    80004508:	fbed                	bnez	a5,800044fa <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000450a:	5098                	lw	a4,32(s1)
    8000450c:	2705                	addiw	a4,a4,1
    8000450e:	0027179b          	slliw	a5,a4,0x2
    80004512:	9fb9                	addw	a5,a5,a4
    80004514:	0017979b          	slliw	a5,a5,0x1
    80004518:	54d4                	lw	a3,44(s1)
    8000451a:	9fb5                	addw	a5,a5,a3
    8000451c:	00f95963          	bge	s2,a5,8000452e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004520:	85a6                	mv	a1,s1
    80004522:	8526                	mv	a0,s1
    80004524:	ffffe097          	auipc	ra,0xffffe
    80004528:	dea080e7          	jalr	-534(ra) # 8000230e <sleep>
    8000452c:	bfe9                	j	80004506 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000452e:	0001f517          	auipc	a0,0x1f
    80004532:	1c250513          	addi	a0,a0,450 # 800236f0 <log>
    80004536:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004538:	ffffc097          	auipc	ra,0xffffc
    8000453c:	7b4080e7          	jalr	1972(ra) # 80000cec <release>
      break;
    }
  }
}
    80004540:	60e2                	ld	ra,24(sp)
    80004542:	6442                	ld	s0,16(sp)
    80004544:	64a2                	ld	s1,8(sp)
    80004546:	6902                	ld	s2,0(sp)
    80004548:	6105                	addi	sp,sp,32
    8000454a:	8082                	ret

000000008000454c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000454c:	7139                	addi	sp,sp,-64
    8000454e:	fc06                	sd	ra,56(sp)
    80004550:	f822                	sd	s0,48(sp)
    80004552:	f426                	sd	s1,40(sp)
    80004554:	f04a                	sd	s2,32(sp)
    80004556:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004558:	0001f497          	auipc	s1,0x1f
    8000455c:	19848493          	addi	s1,s1,408 # 800236f0 <log>
    80004560:	8526                	mv	a0,s1
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	6d6080e7          	jalr	1750(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    8000456a:	509c                	lw	a5,32(s1)
    8000456c:	37fd                	addiw	a5,a5,-1
    8000456e:	0007891b          	sext.w	s2,a5
    80004572:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004574:	50dc                	lw	a5,36(s1)
    80004576:	e7b9                	bnez	a5,800045c4 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004578:	06091163          	bnez	s2,800045da <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000457c:	0001f497          	auipc	s1,0x1f
    80004580:	17448493          	addi	s1,s1,372 # 800236f0 <log>
    80004584:	4785                	li	a5,1
    80004586:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004588:	8526                	mv	a0,s1
    8000458a:	ffffc097          	auipc	ra,0xffffc
    8000458e:	762080e7          	jalr	1890(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004592:	54dc                	lw	a5,44(s1)
    80004594:	06f04763          	bgtz	a5,80004602 <end_op+0xb6>
    acquire(&log.lock);
    80004598:	0001f497          	auipc	s1,0x1f
    8000459c:	15848493          	addi	s1,s1,344 # 800236f0 <log>
    800045a0:	8526                	mv	a0,s1
    800045a2:	ffffc097          	auipc	ra,0xffffc
    800045a6:	696080e7          	jalr	1686(ra) # 80000c38 <acquire>
    log.committing = 0;
    800045aa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800045ae:	8526                	mv	a0,s1
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	dc2080e7          	jalr	-574(ra) # 80002372 <wakeup>
    release(&log.lock);
    800045b8:	8526                	mv	a0,s1
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	732080e7          	jalr	1842(ra) # 80000cec <release>
}
    800045c2:	a815                	j	800045f6 <end_op+0xaa>
    800045c4:	ec4e                	sd	s3,24(sp)
    800045c6:	e852                	sd	s4,16(sp)
    800045c8:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800045ca:	00004517          	auipc	a0,0x4
    800045ce:	03650513          	addi	a0,a0,54 # 80008600 <etext+0x600>
    800045d2:	ffffc097          	auipc	ra,0xffffc
    800045d6:	f8e080e7          	jalr	-114(ra) # 80000560 <panic>
    wakeup(&log);
    800045da:	0001f497          	auipc	s1,0x1f
    800045de:	11648493          	addi	s1,s1,278 # 800236f0 <log>
    800045e2:	8526                	mv	a0,s1
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	d8e080e7          	jalr	-626(ra) # 80002372 <wakeup>
  release(&log.lock);
    800045ec:	8526                	mv	a0,s1
    800045ee:	ffffc097          	auipc	ra,0xffffc
    800045f2:	6fe080e7          	jalr	1790(ra) # 80000cec <release>
}
    800045f6:	70e2                	ld	ra,56(sp)
    800045f8:	7442                	ld	s0,48(sp)
    800045fa:	74a2                	ld	s1,40(sp)
    800045fc:	7902                	ld	s2,32(sp)
    800045fe:	6121                	addi	sp,sp,64
    80004600:	8082                	ret
    80004602:	ec4e                	sd	s3,24(sp)
    80004604:	e852                	sd	s4,16(sp)
    80004606:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004608:	0001fa97          	auipc	s5,0x1f
    8000460c:	118a8a93          	addi	s5,s5,280 # 80023720 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004610:	0001fa17          	auipc	s4,0x1f
    80004614:	0e0a0a13          	addi	s4,s4,224 # 800236f0 <log>
    80004618:	018a2583          	lw	a1,24(s4)
    8000461c:	012585bb          	addw	a1,a1,s2
    80004620:	2585                	addiw	a1,a1,1
    80004622:	028a2503          	lw	a0,40(s4)
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	caa080e7          	jalr	-854(ra) # 800032d0 <bread>
    8000462e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004630:	000aa583          	lw	a1,0(s5)
    80004634:	028a2503          	lw	a0,40(s4)
    80004638:	fffff097          	auipc	ra,0xfffff
    8000463c:	c98080e7          	jalr	-872(ra) # 800032d0 <bread>
    80004640:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004642:	40000613          	li	a2,1024
    80004646:	05850593          	addi	a1,a0,88
    8000464a:	05848513          	addi	a0,s1,88
    8000464e:	ffffc097          	auipc	ra,0xffffc
    80004652:	742080e7          	jalr	1858(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    80004656:	8526                	mv	a0,s1
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	d6a080e7          	jalr	-662(ra) # 800033c2 <bwrite>
    brelse(from);
    80004660:	854e                	mv	a0,s3
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	d9e080e7          	jalr	-610(ra) # 80003400 <brelse>
    brelse(to);
    8000466a:	8526                	mv	a0,s1
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	d94080e7          	jalr	-620(ra) # 80003400 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004674:	2905                	addiw	s2,s2,1
    80004676:	0a91                	addi	s5,s5,4
    80004678:	02ca2783          	lw	a5,44(s4)
    8000467c:	f8f94ee3          	blt	s2,a5,80004618 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004680:	00000097          	auipc	ra,0x0
    80004684:	c8c080e7          	jalr	-884(ra) # 8000430c <write_head>
    install_trans(0); // Now install writes to home locations
    80004688:	4501                	li	a0,0
    8000468a:	00000097          	auipc	ra,0x0
    8000468e:	cec080e7          	jalr	-788(ra) # 80004376 <install_trans>
    log.lh.n = 0;
    80004692:	0001f797          	auipc	a5,0x1f
    80004696:	0807a523          	sw	zero,138(a5) # 8002371c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000469a:	00000097          	auipc	ra,0x0
    8000469e:	c72080e7          	jalr	-910(ra) # 8000430c <write_head>
    800046a2:	69e2                	ld	s3,24(sp)
    800046a4:	6a42                	ld	s4,16(sp)
    800046a6:	6aa2                	ld	s5,8(sp)
    800046a8:	bdc5                	j	80004598 <end_op+0x4c>

00000000800046aa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800046aa:	1101                	addi	sp,sp,-32
    800046ac:	ec06                	sd	ra,24(sp)
    800046ae:	e822                	sd	s0,16(sp)
    800046b0:	e426                	sd	s1,8(sp)
    800046b2:	e04a                	sd	s2,0(sp)
    800046b4:	1000                	addi	s0,sp,32
    800046b6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800046b8:	0001f917          	auipc	s2,0x1f
    800046bc:	03890913          	addi	s2,s2,56 # 800236f0 <log>
    800046c0:	854a                	mv	a0,s2
    800046c2:	ffffc097          	auipc	ra,0xffffc
    800046c6:	576080e7          	jalr	1398(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800046ca:	02c92603          	lw	a2,44(s2)
    800046ce:	47f5                	li	a5,29
    800046d0:	06c7c563          	blt	a5,a2,8000473a <log_write+0x90>
    800046d4:	0001f797          	auipc	a5,0x1f
    800046d8:	0387a783          	lw	a5,56(a5) # 8002370c <log+0x1c>
    800046dc:	37fd                	addiw	a5,a5,-1
    800046de:	04f65e63          	bge	a2,a5,8000473a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800046e2:	0001f797          	auipc	a5,0x1f
    800046e6:	02e7a783          	lw	a5,46(a5) # 80023710 <log+0x20>
    800046ea:	06f05063          	blez	a5,8000474a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800046ee:	4781                	li	a5,0
    800046f0:	06c05563          	blez	a2,8000475a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800046f4:	44cc                	lw	a1,12(s1)
    800046f6:	0001f717          	auipc	a4,0x1f
    800046fa:	02a70713          	addi	a4,a4,42 # 80023720 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800046fe:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004700:	4314                	lw	a3,0(a4)
    80004702:	04b68c63          	beq	a3,a1,8000475a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004706:	2785                	addiw	a5,a5,1
    80004708:	0711                	addi	a4,a4,4
    8000470a:	fef61be3          	bne	a2,a5,80004700 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000470e:	0621                	addi	a2,a2,8
    80004710:	060a                	slli	a2,a2,0x2
    80004712:	0001f797          	auipc	a5,0x1f
    80004716:	fde78793          	addi	a5,a5,-34 # 800236f0 <log>
    8000471a:	97b2                	add	a5,a5,a2
    8000471c:	44d8                	lw	a4,12(s1)
    8000471e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004720:	8526                	mv	a0,s1
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	d7a080e7          	jalr	-646(ra) # 8000349c <bpin>
    log.lh.n++;
    8000472a:	0001f717          	auipc	a4,0x1f
    8000472e:	fc670713          	addi	a4,a4,-58 # 800236f0 <log>
    80004732:	575c                	lw	a5,44(a4)
    80004734:	2785                	addiw	a5,a5,1
    80004736:	d75c                	sw	a5,44(a4)
    80004738:	a82d                	j	80004772 <log_write+0xc8>
    panic("too big a transaction");
    8000473a:	00004517          	auipc	a0,0x4
    8000473e:	ed650513          	addi	a0,a0,-298 # 80008610 <etext+0x610>
    80004742:	ffffc097          	auipc	ra,0xffffc
    80004746:	e1e080e7          	jalr	-482(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    8000474a:	00004517          	auipc	a0,0x4
    8000474e:	ede50513          	addi	a0,a0,-290 # 80008628 <etext+0x628>
    80004752:	ffffc097          	auipc	ra,0xffffc
    80004756:	e0e080e7          	jalr	-498(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    8000475a:	00878693          	addi	a3,a5,8
    8000475e:	068a                	slli	a3,a3,0x2
    80004760:	0001f717          	auipc	a4,0x1f
    80004764:	f9070713          	addi	a4,a4,-112 # 800236f0 <log>
    80004768:	9736                	add	a4,a4,a3
    8000476a:	44d4                	lw	a3,12(s1)
    8000476c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000476e:	faf609e3          	beq	a2,a5,80004720 <log_write+0x76>
  }
  release(&log.lock);
    80004772:	0001f517          	auipc	a0,0x1f
    80004776:	f7e50513          	addi	a0,a0,-130 # 800236f0 <log>
    8000477a:	ffffc097          	auipc	ra,0xffffc
    8000477e:	572080e7          	jalr	1394(ra) # 80000cec <release>
}
    80004782:	60e2                	ld	ra,24(sp)
    80004784:	6442                	ld	s0,16(sp)
    80004786:	64a2                	ld	s1,8(sp)
    80004788:	6902                	ld	s2,0(sp)
    8000478a:	6105                	addi	sp,sp,32
    8000478c:	8082                	ret

000000008000478e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000478e:	1101                	addi	sp,sp,-32
    80004790:	ec06                	sd	ra,24(sp)
    80004792:	e822                	sd	s0,16(sp)
    80004794:	e426                	sd	s1,8(sp)
    80004796:	e04a                	sd	s2,0(sp)
    80004798:	1000                	addi	s0,sp,32
    8000479a:	84aa                	mv	s1,a0
    8000479c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000479e:	00004597          	auipc	a1,0x4
    800047a2:	eaa58593          	addi	a1,a1,-342 # 80008648 <etext+0x648>
    800047a6:	0521                	addi	a0,a0,8
    800047a8:	ffffc097          	auipc	ra,0xffffc
    800047ac:	400080e7          	jalr	1024(ra) # 80000ba8 <initlock>
  lk->name = name;
    800047b0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800047b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047b8:	0204a423          	sw	zero,40(s1)
}
    800047bc:	60e2                	ld	ra,24(sp)
    800047be:	6442                	ld	s0,16(sp)
    800047c0:	64a2                	ld	s1,8(sp)
    800047c2:	6902                	ld	s2,0(sp)
    800047c4:	6105                	addi	sp,sp,32
    800047c6:	8082                	ret

00000000800047c8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800047c8:	1101                	addi	sp,sp,-32
    800047ca:	ec06                	sd	ra,24(sp)
    800047cc:	e822                	sd	s0,16(sp)
    800047ce:	e426                	sd	s1,8(sp)
    800047d0:	e04a                	sd	s2,0(sp)
    800047d2:	1000                	addi	s0,sp,32
    800047d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047d6:	00850913          	addi	s2,a0,8
    800047da:	854a                	mv	a0,s2
    800047dc:	ffffc097          	auipc	ra,0xffffc
    800047e0:	45c080e7          	jalr	1116(ra) # 80000c38 <acquire>
  while (lk->locked) {
    800047e4:	409c                	lw	a5,0(s1)
    800047e6:	cb89                	beqz	a5,800047f8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800047e8:	85ca                	mv	a1,s2
    800047ea:	8526                	mv	a0,s1
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	b22080e7          	jalr	-1246(ra) # 8000230e <sleep>
  while (lk->locked) {
    800047f4:	409c                	lw	a5,0(s1)
    800047f6:	fbed                	bnez	a5,800047e8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800047f8:	4785                	li	a5,1
    800047fa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800047fc:	ffffd097          	auipc	ra,0xffffd
    80004800:	33a080e7          	jalr	826(ra) # 80001b36 <myproc>
    80004804:	591c                	lw	a5,48(a0)
    80004806:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004808:	854a                	mv	a0,s2
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	4e2080e7          	jalr	1250(ra) # 80000cec <release>
}
    80004812:	60e2                	ld	ra,24(sp)
    80004814:	6442                	ld	s0,16(sp)
    80004816:	64a2                	ld	s1,8(sp)
    80004818:	6902                	ld	s2,0(sp)
    8000481a:	6105                	addi	sp,sp,32
    8000481c:	8082                	ret

000000008000481e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000481e:	1101                	addi	sp,sp,-32
    80004820:	ec06                	sd	ra,24(sp)
    80004822:	e822                	sd	s0,16(sp)
    80004824:	e426                	sd	s1,8(sp)
    80004826:	e04a                	sd	s2,0(sp)
    80004828:	1000                	addi	s0,sp,32
    8000482a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000482c:	00850913          	addi	s2,a0,8
    80004830:	854a                	mv	a0,s2
    80004832:	ffffc097          	auipc	ra,0xffffc
    80004836:	406080e7          	jalr	1030(ra) # 80000c38 <acquire>
  lk->locked = 0;
    8000483a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000483e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004842:	8526                	mv	a0,s1
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	b2e080e7          	jalr	-1234(ra) # 80002372 <wakeup>
  release(&lk->lk);
    8000484c:	854a                	mv	a0,s2
    8000484e:	ffffc097          	auipc	ra,0xffffc
    80004852:	49e080e7          	jalr	1182(ra) # 80000cec <release>
}
    80004856:	60e2                	ld	ra,24(sp)
    80004858:	6442                	ld	s0,16(sp)
    8000485a:	64a2                	ld	s1,8(sp)
    8000485c:	6902                	ld	s2,0(sp)
    8000485e:	6105                	addi	sp,sp,32
    80004860:	8082                	ret

0000000080004862 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004862:	7179                	addi	sp,sp,-48
    80004864:	f406                	sd	ra,40(sp)
    80004866:	f022                	sd	s0,32(sp)
    80004868:	ec26                	sd	s1,24(sp)
    8000486a:	e84a                	sd	s2,16(sp)
    8000486c:	1800                	addi	s0,sp,48
    8000486e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004870:	00850913          	addi	s2,a0,8
    80004874:	854a                	mv	a0,s2
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	3c2080e7          	jalr	962(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000487e:	409c                	lw	a5,0(s1)
    80004880:	ef91                	bnez	a5,8000489c <holdingsleep+0x3a>
    80004882:	4481                	li	s1,0
  release(&lk->lk);
    80004884:	854a                	mv	a0,s2
    80004886:	ffffc097          	auipc	ra,0xffffc
    8000488a:	466080e7          	jalr	1126(ra) # 80000cec <release>
  return r;
}
    8000488e:	8526                	mv	a0,s1
    80004890:	70a2                	ld	ra,40(sp)
    80004892:	7402                	ld	s0,32(sp)
    80004894:	64e2                	ld	s1,24(sp)
    80004896:	6942                	ld	s2,16(sp)
    80004898:	6145                	addi	sp,sp,48
    8000489a:	8082                	ret
    8000489c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000489e:	0284a983          	lw	s3,40(s1)
    800048a2:	ffffd097          	auipc	ra,0xffffd
    800048a6:	294080e7          	jalr	660(ra) # 80001b36 <myproc>
    800048aa:	5904                	lw	s1,48(a0)
    800048ac:	413484b3          	sub	s1,s1,s3
    800048b0:	0014b493          	seqz	s1,s1
    800048b4:	69a2                	ld	s3,8(sp)
    800048b6:	b7f9                	j	80004884 <holdingsleep+0x22>

00000000800048b8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800048b8:	1141                	addi	sp,sp,-16
    800048ba:	e406                	sd	ra,8(sp)
    800048bc:	e022                	sd	s0,0(sp)
    800048be:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800048c0:	00004597          	auipc	a1,0x4
    800048c4:	d9858593          	addi	a1,a1,-616 # 80008658 <etext+0x658>
    800048c8:	0001f517          	auipc	a0,0x1f
    800048cc:	f7050513          	addi	a0,a0,-144 # 80023838 <ftable>
    800048d0:	ffffc097          	auipc	ra,0xffffc
    800048d4:	2d8080e7          	jalr	728(ra) # 80000ba8 <initlock>
}
    800048d8:	60a2                	ld	ra,8(sp)
    800048da:	6402                	ld	s0,0(sp)
    800048dc:	0141                	addi	sp,sp,16
    800048de:	8082                	ret

00000000800048e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800048e0:	1101                	addi	sp,sp,-32
    800048e2:	ec06                	sd	ra,24(sp)
    800048e4:	e822                	sd	s0,16(sp)
    800048e6:	e426                	sd	s1,8(sp)
    800048e8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800048ea:	0001f517          	auipc	a0,0x1f
    800048ee:	f4e50513          	addi	a0,a0,-178 # 80023838 <ftable>
    800048f2:	ffffc097          	auipc	ra,0xffffc
    800048f6:	346080e7          	jalr	838(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048fa:	0001f497          	auipc	s1,0x1f
    800048fe:	f5648493          	addi	s1,s1,-170 # 80023850 <ftable+0x18>
    80004902:	00020717          	auipc	a4,0x20
    80004906:	eee70713          	addi	a4,a4,-274 # 800247f0 <disk>
    if(f->ref == 0){
    8000490a:	40dc                	lw	a5,4(s1)
    8000490c:	cf99                	beqz	a5,8000492a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000490e:	02848493          	addi	s1,s1,40
    80004912:	fee49ce3          	bne	s1,a4,8000490a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004916:	0001f517          	auipc	a0,0x1f
    8000491a:	f2250513          	addi	a0,a0,-222 # 80023838 <ftable>
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	3ce080e7          	jalr	974(ra) # 80000cec <release>
  return 0;
    80004926:	4481                	li	s1,0
    80004928:	a819                	j	8000493e <filealloc+0x5e>
      f->ref = 1;
    8000492a:	4785                	li	a5,1
    8000492c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000492e:	0001f517          	auipc	a0,0x1f
    80004932:	f0a50513          	addi	a0,a0,-246 # 80023838 <ftable>
    80004936:	ffffc097          	auipc	ra,0xffffc
    8000493a:	3b6080e7          	jalr	950(ra) # 80000cec <release>
}
    8000493e:	8526                	mv	a0,s1
    80004940:	60e2                	ld	ra,24(sp)
    80004942:	6442                	ld	s0,16(sp)
    80004944:	64a2                	ld	s1,8(sp)
    80004946:	6105                	addi	sp,sp,32
    80004948:	8082                	ret

000000008000494a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000494a:	1101                	addi	sp,sp,-32
    8000494c:	ec06                	sd	ra,24(sp)
    8000494e:	e822                	sd	s0,16(sp)
    80004950:	e426                	sd	s1,8(sp)
    80004952:	1000                	addi	s0,sp,32
    80004954:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004956:	0001f517          	auipc	a0,0x1f
    8000495a:	ee250513          	addi	a0,a0,-286 # 80023838 <ftable>
    8000495e:	ffffc097          	auipc	ra,0xffffc
    80004962:	2da080e7          	jalr	730(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004966:	40dc                	lw	a5,4(s1)
    80004968:	02f05263          	blez	a5,8000498c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000496c:	2785                	addiw	a5,a5,1
    8000496e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004970:	0001f517          	auipc	a0,0x1f
    80004974:	ec850513          	addi	a0,a0,-312 # 80023838 <ftable>
    80004978:	ffffc097          	auipc	ra,0xffffc
    8000497c:	374080e7          	jalr	884(ra) # 80000cec <release>
  return f;
}
    80004980:	8526                	mv	a0,s1
    80004982:	60e2                	ld	ra,24(sp)
    80004984:	6442                	ld	s0,16(sp)
    80004986:	64a2                	ld	s1,8(sp)
    80004988:	6105                	addi	sp,sp,32
    8000498a:	8082                	ret
    panic("filedup");
    8000498c:	00004517          	auipc	a0,0x4
    80004990:	cd450513          	addi	a0,a0,-812 # 80008660 <etext+0x660>
    80004994:	ffffc097          	auipc	ra,0xffffc
    80004998:	bcc080e7          	jalr	-1076(ra) # 80000560 <panic>

000000008000499c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000499c:	7139                	addi	sp,sp,-64
    8000499e:	fc06                	sd	ra,56(sp)
    800049a0:	f822                	sd	s0,48(sp)
    800049a2:	f426                	sd	s1,40(sp)
    800049a4:	0080                	addi	s0,sp,64
    800049a6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800049a8:	0001f517          	auipc	a0,0x1f
    800049ac:	e9050513          	addi	a0,a0,-368 # 80023838 <ftable>
    800049b0:	ffffc097          	auipc	ra,0xffffc
    800049b4:	288080e7          	jalr	648(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    800049b8:	40dc                	lw	a5,4(s1)
    800049ba:	04f05c63          	blez	a5,80004a12 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    800049be:	37fd                	addiw	a5,a5,-1
    800049c0:	0007871b          	sext.w	a4,a5
    800049c4:	c0dc                	sw	a5,4(s1)
    800049c6:	06e04263          	bgtz	a4,80004a2a <fileclose+0x8e>
    800049ca:	f04a                	sd	s2,32(sp)
    800049cc:	ec4e                	sd	s3,24(sp)
    800049ce:	e852                	sd	s4,16(sp)
    800049d0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800049d2:	0004a903          	lw	s2,0(s1)
    800049d6:	0094ca83          	lbu	s5,9(s1)
    800049da:	0104ba03          	ld	s4,16(s1)
    800049de:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800049e2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800049e6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800049ea:	0001f517          	auipc	a0,0x1f
    800049ee:	e4e50513          	addi	a0,a0,-434 # 80023838 <ftable>
    800049f2:	ffffc097          	auipc	ra,0xffffc
    800049f6:	2fa080e7          	jalr	762(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    800049fa:	4785                	li	a5,1
    800049fc:	04f90463          	beq	s2,a5,80004a44 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a00:	3979                	addiw	s2,s2,-2
    80004a02:	4785                	li	a5,1
    80004a04:	0527fb63          	bgeu	a5,s2,80004a5a <fileclose+0xbe>
    80004a08:	7902                	ld	s2,32(sp)
    80004a0a:	69e2                	ld	s3,24(sp)
    80004a0c:	6a42                	ld	s4,16(sp)
    80004a0e:	6aa2                	ld	s5,8(sp)
    80004a10:	a02d                	j	80004a3a <fileclose+0x9e>
    80004a12:	f04a                	sd	s2,32(sp)
    80004a14:	ec4e                	sd	s3,24(sp)
    80004a16:	e852                	sd	s4,16(sp)
    80004a18:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004a1a:	00004517          	auipc	a0,0x4
    80004a1e:	c4e50513          	addi	a0,a0,-946 # 80008668 <etext+0x668>
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	b3e080e7          	jalr	-1218(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004a2a:	0001f517          	auipc	a0,0x1f
    80004a2e:	e0e50513          	addi	a0,a0,-498 # 80023838 <ftable>
    80004a32:	ffffc097          	auipc	ra,0xffffc
    80004a36:	2ba080e7          	jalr	698(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004a3a:	70e2                	ld	ra,56(sp)
    80004a3c:	7442                	ld	s0,48(sp)
    80004a3e:	74a2                	ld	s1,40(sp)
    80004a40:	6121                	addi	sp,sp,64
    80004a42:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004a44:	85d6                	mv	a1,s5
    80004a46:	8552                	mv	a0,s4
    80004a48:	00000097          	auipc	ra,0x0
    80004a4c:	3a2080e7          	jalr	930(ra) # 80004dea <pipeclose>
    80004a50:	7902                	ld	s2,32(sp)
    80004a52:	69e2                	ld	s3,24(sp)
    80004a54:	6a42                	ld	s4,16(sp)
    80004a56:	6aa2                	ld	s5,8(sp)
    80004a58:	b7cd                	j	80004a3a <fileclose+0x9e>
    begin_op();
    80004a5a:	00000097          	auipc	ra,0x0
    80004a5e:	a78080e7          	jalr	-1416(ra) # 800044d2 <begin_op>
    iput(ff.ip);
    80004a62:	854e                	mv	a0,s3
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	25e080e7          	jalr	606(ra) # 80003cc2 <iput>
    end_op();
    80004a6c:	00000097          	auipc	ra,0x0
    80004a70:	ae0080e7          	jalr	-1312(ra) # 8000454c <end_op>
    80004a74:	7902                	ld	s2,32(sp)
    80004a76:	69e2                	ld	s3,24(sp)
    80004a78:	6a42                	ld	s4,16(sp)
    80004a7a:	6aa2                	ld	s5,8(sp)
    80004a7c:	bf7d                	j	80004a3a <fileclose+0x9e>

0000000080004a7e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a7e:	715d                	addi	sp,sp,-80
    80004a80:	e486                	sd	ra,72(sp)
    80004a82:	e0a2                	sd	s0,64(sp)
    80004a84:	fc26                	sd	s1,56(sp)
    80004a86:	f44e                	sd	s3,40(sp)
    80004a88:	0880                	addi	s0,sp,80
    80004a8a:	84aa                	mv	s1,a0
    80004a8c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	0a8080e7          	jalr	168(ra) # 80001b36 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a96:	409c                	lw	a5,0(s1)
    80004a98:	37f9                	addiw	a5,a5,-2
    80004a9a:	4705                	li	a4,1
    80004a9c:	04f76863          	bltu	a4,a5,80004aec <filestat+0x6e>
    80004aa0:	f84a                	sd	s2,48(sp)
    80004aa2:	892a                	mv	s2,a0
    ilock(f->ip);
    80004aa4:	6c88                	ld	a0,24(s1)
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	05e080e7          	jalr	94(ra) # 80003b04 <ilock>
    stati(f->ip, &st);
    80004aae:	fb840593          	addi	a1,s0,-72
    80004ab2:	6c88                	ld	a0,24(s1)
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	2de080e7          	jalr	734(ra) # 80003d92 <stati>
    iunlock(f->ip);
    80004abc:	6c88                	ld	a0,24(s1)
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	10c080e7          	jalr	268(ra) # 80003bca <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ac6:	46e1                	li	a3,24
    80004ac8:	fb840613          	addi	a2,s0,-72
    80004acc:	85ce                	mv	a1,s3
    80004ace:	05093503          	ld	a0,80(s2)
    80004ad2:	ffffd097          	auipc	ra,0xffffd
    80004ad6:	c10080e7          	jalr	-1008(ra) # 800016e2 <copyout>
    80004ada:	41f5551b          	sraiw	a0,a0,0x1f
    80004ade:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004ae0:	60a6                	ld	ra,72(sp)
    80004ae2:	6406                	ld	s0,64(sp)
    80004ae4:	74e2                	ld	s1,56(sp)
    80004ae6:	79a2                	ld	s3,40(sp)
    80004ae8:	6161                	addi	sp,sp,80
    80004aea:	8082                	ret
  return -1;
    80004aec:	557d                	li	a0,-1
    80004aee:	bfcd                	j	80004ae0 <filestat+0x62>

0000000080004af0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004af0:	7179                	addi	sp,sp,-48
    80004af2:	f406                	sd	ra,40(sp)
    80004af4:	f022                	sd	s0,32(sp)
    80004af6:	e84a                	sd	s2,16(sp)
    80004af8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004afa:	00854783          	lbu	a5,8(a0)
    80004afe:	cbc5                	beqz	a5,80004bae <fileread+0xbe>
    80004b00:	ec26                	sd	s1,24(sp)
    80004b02:	e44e                	sd	s3,8(sp)
    80004b04:	84aa                	mv	s1,a0
    80004b06:	89ae                	mv	s3,a1
    80004b08:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b0a:	411c                	lw	a5,0(a0)
    80004b0c:	4705                	li	a4,1
    80004b0e:	04e78963          	beq	a5,a4,80004b60 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b12:	470d                	li	a4,3
    80004b14:	04e78f63          	beq	a5,a4,80004b72 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b18:	4709                	li	a4,2
    80004b1a:	08e79263          	bne	a5,a4,80004b9e <fileread+0xae>
    ilock(f->ip);
    80004b1e:	6d08                	ld	a0,24(a0)
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	fe4080e7          	jalr	-28(ra) # 80003b04 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b28:	874a                	mv	a4,s2
    80004b2a:	5094                	lw	a3,32(s1)
    80004b2c:	864e                	mv	a2,s3
    80004b2e:	4585                	li	a1,1
    80004b30:	6c88                	ld	a0,24(s1)
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	28a080e7          	jalr	650(ra) # 80003dbc <readi>
    80004b3a:	892a                	mv	s2,a0
    80004b3c:	00a05563          	blez	a0,80004b46 <fileread+0x56>
      f->off += r;
    80004b40:	509c                	lw	a5,32(s1)
    80004b42:	9fa9                	addw	a5,a5,a0
    80004b44:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004b46:	6c88                	ld	a0,24(s1)
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	082080e7          	jalr	130(ra) # 80003bca <iunlock>
    80004b50:	64e2                	ld	s1,24(sp)
    80004b52:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004b54:	854a                	mv	a0,s2
    80004b56:	70a2                	ld	ra,40(sp)
    80004b58:	7402                	ld	s0,32(sp)
    80004b5a:	6942                	ld	s2,16(sp)
    80004b5c:	6145                	addi	sp,sp,48
    80004b5e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004b60:	6908                	ld	a0,16(a0)
    80004b62:	00000097          	auipc	ra,0x0
    80004b66:	400080e7          	jalr	1024(ra) # 80004f62 <piperead>
    80004b6a:	892a                	mv	s2,a0
    80004b6c:	64e2                	ld	s1,24(sp)
    80004b6e:	69a2                	ld	s3,8(sp)
    80004b70:	b7d5                	j	80004b54 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b72:	02451783          	lh	a5,36(a0)
    80004b76:	03079693          	slli	a3,a5,0x30
    80004b7a:	92c1                	srli	a3,a3,0x30
    80004b7c:	4725                	li	a4,9
    80004b7e:	02d76a63          	bltu	a4,a3,80004bb2 <fileread+0xc2>
    80004b82:	0792                	slli	a5,a5,0x4
    80004b84:	0001f717          	auipc	a4,0x1f
    80004b88:	c1470713          	addi	a4,a4,-1004 # 80023798 <devsw>
    80004b8c:	97ba                	add	a5,a5,a4
    80004b8e:	639c                	ld	a5,0(a5)
    80004b90:	c78d                	beqz	a5,80004bba <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004b92:	4505                	li	a0,1
    80004b94:	9782                	jalr	a5
    80004b96:	892a                	mv	s2,a0
    80004b98:	64e2                	ld	s1,24(sp)
    80004b9a:	69a2                	ld	s3,8(sp)
    80004b9c:	bf65                	j	80004b54 <fileread+0x64>
    panic("fileread");
    80004b9e:	00004517          	auipc	a0,0x4
    80004ba2:	ada50513          	addi	a0,a0,-1318 # 80008678 <etext+0x678>
    80004ba6:	ffffc097          	auipc	ra,0xffffc
    80004baa:	9ba080e7          	jalr	-1606(ra) # 80000560 <panic>
    return -1;
    80004bae:	597d                	li	s2,-1
    80004bb0:	b755                	j	80004b54 <fileread+0x64>
      return -1;
    80004bb2:	597d                	li	s2,-1
    80004bb4:	64e2                	ld	s1,24(sp)
    80004bb6:	69a2                	ld	s3,8(sp)
    80004bb8:	bf71                	j	80004b54 <fileread+0x64>
    80004bba:	597d                	li	s2,-1
    80004bbc:	64e2                	ld	s1,24(sp)
    80004bbe:	69a2                	ld	s3,8(sp)
    80004bc0:	bf51                	j	80004b54 <fileread+0x64>

0000000080004bc2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004bc2:	00954783          	lbu	a5,9(a0)
    80004bc6:	12078963          	beqz	a5,80004cf8 <filewrite+0x136>
{
    80004bca:	715d                	addi	sp,sp,-80
    80004bcc:	e486                	sd	ra,72(sp)
    80004bce:	e0a2                	sd	s0,64(sp)
    80004bd0:	f84a                	sd	s2,48(sp)
    80004bd2:	f052                	sd	s4,32(sp)
    80004bd4:	e85a                	sd	s6,16(sp)
    80004bd6:	0880                	addi	s0,sp,80
    80004bd8:	892a                	mv	s2,a0
    80004bda:	8b2e                	mv	s6,a1
    80004bdc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004bde:	411c                	lw	a5,0(a0)
    80004be0:	4705                	li	a4,1
    80004be2:	02e78763          	beq	a5,a4,80004c10 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004be6:	470d                	li	a4,3
    80004be8:	02e78a63          	beq	a5,a4,80004c1c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004bec:	4709                	li	a4,2
    80004bee:	0ee79863          	bne	a5,a4,80004cde <filewrite+0x11c>
    80004bf2:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004bf4:	0cc05463          	blez	a2,80004cbc <filewrite+0xfa>
    80004bf8:	fc26                	sd	s1,56(sp)
    80004bfa:	ec56                	sd	s5,24(sp)
    80004bfc:	e45e                	sd	s7,8(sp)
    80004bfe:	e062                	sd	s8,0(sp)
    int i = 0;
    80004c00:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004c02:	6b85                	lui	s7,0x1
    80004c04:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004c08:	6c05                	lui	s8,0x1
    80004c0a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004c0e:	a851                	j	80004ca2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004c10:	6908                	ld	a0,16(a0)
    80004c12:	00000097          	auipc	ra,0x0
    80004c16:	248080e7          	jalr	584(ra) # 80004e5a <pipewrite>
    80004c1a:	a85d                	j	80004cd0 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c1c:	02451783          	lh	a5,36(a0)
    80004c20:	03079693          	slli	a3,a5,0x30
    80004c24:	92c1                	srli	a3,a3,0x30
    80004c26:	4725                	li	a4,9
    80004c28:	0cd76a63          	bltu	a4,a3,80004cfc <filewrite+0x13a>
    80004c2c:	0792                	slli	a5,a5,0x4
    80004c2e:	0001f717          	auipc	a4,0x1f
    80004c32:	b6a70713          	addi	a4,a4,-1174 # 80023798 <devsw>
    80004c36:	97ba                	add	a5,a5,a4
    80004c38:	679c                	ld	a5,8(a5)
    80004c3a:	c3f9                	beqz	a5,80004d00 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004c3c:	4505                	li	a0,1
    80004c3e:	9782                	jalr	a5
    80004c40:	a841                	j	80004cd0 <filewrite+0x10e>
      if(n1 > max)
    80004c42:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004c46:	00000097          	auipc	ra,0x0
    80004c4a:	88c080e7          	jalr	-1908(ra) # 800044d2 <begin_op>
      ilock(f->ip);
    80004c4e:	01893503          	ld	a0,24(s2)
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	eb2080e7          	jalr	-334(ra) # 80003b04 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004c5a:	8756                	mv	a4,s5
    80004c5c:	02092683          	lw	a3,32(s2)
    80004c60:	01698633          	add	a2,s3,s6
    80004c64:	4585                	li	a1,1
    80004c66:	01893503          	ld	a0,24(s2)
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	262080e7          	jalr	610(ra) # 80003ecc <writei>
    80004c72:	84aa                	mv	s1,a0
    80004c74:	00a05763          	blez	a0,80004c82 <filewrite+0xc0>
        f->off += r;
    80004c78:	02092783          	lw	a5,32(s2)
    80004c7c:	9fa9                	addw	a5,a5,a0
    80004c7e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c82:	01893503          	ld	a0,24(s2)
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	f44080e7          	jalr	-188(ra) # 80003bca <iunlock>
      end_op();
    80004c8e:	00000097          	auipc	ra,0x0
    80004c92:	8be080e7          	jalr	-1858(ra) # 8000454c <end_op>

      if(r != n1){
    80004c96:	029a9563          	bne	s5,s1,80004cc0 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004c9a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004c9e:	0149da63          	bge	s3,s4,80004cb2 <filewrite+0xf0>
      int n1 = n - i;
    80004ca2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004ca6:	0004879b          	sext.w	a5,s1
    80004caa:	f8fbdce3          	bge	s7,a5,80004c42 <filewrite+0x80>
    80004cae:	84e2                	mv	s1,s8
    80004cb0:	bf49                	j	80004c42 <filewrite+0x80>
    80004cb2:	74e2                	ld	s1,56(sp)
    80004cb4:	6ae2                	ld	s5,24(sp)
    80004cb6:	6ba2                	ld	s7,8(sp)
    80004cb8:	6c02                	ld	s8,0(sp)
    80004cba:	a039                	j	80004cc8 <filewrite+0x106>
    int i = 0;
    80004cbc:	4981                	li	s3,0
    80004cbe:	a029                	j	80004cc8 <filewrite+0x106>
    80004cc0:	74e2                	ld	s1,56(sp)
    80004cc2:	6ae2                	ld	s5,24(sp)
    80004cc4:	6ba2                	ld	s7,8(sp)
    80004cc6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004cc8:	033a1e63          	bne	s4,s3,80004d04 <filewrite+0x142>
    80004ccc:	8552                	mv	a0,s4
    80004cce:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004cd0:	60a6                	ld	ra,72(sp)
    80004cd2:	6406                	ld	s0,64(sp)
    80004cd4:	7942                	ld	s2,48(sp)
    80004cd6:	7a02                	ld	s4,32(sp)
    80004cd8:	6b42                	ld	s6,16(sp)
    80004cda:	6161                	addi	sp,sp,80
    80004cdc:	8082                	ret
    80004cde:	fc26                	sd	s1,56(sp)
    80004ce0:	f44e                	sd	s3,40(sp)
    80004ce2:	ec56                	sd	s5,24(sp)
    80004ce4:	e45e                	sd	s7,8(sp)
    80004ce6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004ce8:	00004517          	auipc	a0,0x4
    80004cec:	9a050513          	addi	a0,a0,-1632 # 80008688 <etext+0x688>
    80004cf0:	ffffc097          	auipc	ra,0xffffc
    80004cf4:	870080e7          	jalr	-1936(ra) # 80000560 <panic>
    return -1;
    80004cf8:	557d                	li	a0,-1
}
    80004cfa:	8082                	ret
      return -1;
    80004cfc:	557d                	li	a0,-1
    80004cfe:	bfc9                	j	80004cd0 <filewrite+0x10e>
    80004d00:	557d                	li	a0,-1
    80004d02:	b7f9                	j	80004cd0 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004d04:	557d                	li	a0,-1
    80004d06:	79a2                	ld	s3,40(sp)
    80004d08:	b7e1                	j	80004cd0 <filewrite+0x10e>

0000000080004d0a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d0a:	7179                	addi	sp,sp,-48
    80004d0c:	f406                	sd	ra,40(sp)
    80004d0e:	f022                	sd	s0,32(sp)
    80004d10:	ec26                	sd	s1,24(sp)
    80004d12:	e052                	sd	s4,0(sp)
    80004d14:	1800                	addi	s0,sp,48
    80004d16:	84aa                	mv	s1,a0
    80004d18:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d1a:	0005b023          	sd	zero,0(a1)
    80004d1e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d22:	00000097          	auipc	ra,0x0
    80004d26:	bbe080e7          	jalr	-1090(ra) # 800048e0 <filealloc>
    80004d2a:	e088                	sd	a0,0(s1)
    80004d2c:	cd49                	beqz	a0,80004dc6 <pipealloc+0xbc>
    80004d2e:	00000097          	auipc	ra,0x0
    80004d32:	bb2080e7          	jalr	-1102(ra) # 800048e0 <filealloc>
    80004d36:	00aa3023          	sd	a0,0(s4)
    80004d3a:	c141                	beqz	a0,80004dba <pipealloc+0xb0>
    80004d3c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d3e:	ffffc097          	auipc	ra,0xffffc
    80004d42:	e0a080e7          	jalr	-502(ra) # 80000b48 <kalloc>
    80004d46:	892a                	mv	s2,a0
    80004d48:	c13d                	beqz	a0,80004dae <pipealloc+0xa4>
    80004d4a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004d4c:	4985                	li	s3,1
    80004d4e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004d52:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004d56:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004d5a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004d5e:	00004597          	auipc	a1,0x4
    80004d62:	93a58593          	addi	a1,a1,-1734 # 80008698 <etext+0x698>
    80004d66:	ffffc097          	auipc	ra,0xffffc
    80004d6a:	e42080e7          	jalr	-446(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004d6e:	609c                	ld	a5,0(s1)
    80004d70:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004d74:	609c                	ld	a5,0(s1)
    80004d76:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004d7a:	609c                	ld	a5,0(s1)
    80004d7c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d80:	609c                	ld	a5,0(s1)
    80004d82:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d86:	000a3783          	ld	a5,0(s4)
    80004d8a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d8e:	000a3783          	ld	a5,0(s4)
    80004d92:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d96:	000a3783          	ld	a5,0(s4)
    80004d9a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004d9e:	000a3783          	ld	a5,0(s4)
    80004da2:	0127b823          	sd	s2,16(a5)
  return 0;
    80004da6:	4501                	li	a0,0
    80004da8:	6942                	ld	s2,16(sp)
    80004daa:	69a2                	ld	s3,8(sp)
    80004dac:	a03d                	j	80004dda <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004dae:	6088                	ld	a0,0(s1)
    80004db0:	c119                	beqz	a0,80004db6 <pipealloc+0xac>
    80004db2:	6942                	ld	s2,16(sp)
    80004db4:	a029                	j	80004dbe <pipealloc+0xb4>
    80004db6:	6942                	ld	s2,16(sp)
    80004db8:	a039                	j	80004dc6 <pipealloc+0xbc>
    80004dba:	6088                	ld	a0,0(s1)
    80004dbc:	c50d                	beqz	a0,80004de6 <pipealloc+0xdc>
    fileclose(*f0);
    80004dbe:	00000097          	auipc	ra,0x0
    80004dc2:	bde080e7          	jalr	-1058(ra) # 8000499c <fileclose>
  if(*f1)
    80004dc6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004dca:	557d                	li	a0,-1
  if(*f1)
    80004dcc:	c799                	beqz	a5,80004dda <pipealloc+0xd0>
    fileclose(*f1);
    80004dce:	853e                	mv	a0,a5
    80004dd0:	00000097          	auipc	ra,0x0
    80004dd4:	bcc080e7          	jalr	-1076(ra) # 8000499c <fileclose>
  return -1;
    80004dd8:	557d                	li	a0,-1
}
    80004dda:	70a2                	ld	ra,40(sp)
    80004ddc:	7402                	ld	s0,32(sp)
    80004dde:	64e2                	ld	s1,24(sp)
    80004de0:	6a02                	ld	s4,0(sp)
    80004de2:	6145                	addi	sp,sp,48
    80004de4:	8082                	ret
  return -1;
    80004de6:	557d                	li	a0,-1
    80004de8:	bfcd                	j	80004dda <pipealloc+0xd0>

0000000080004dea <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004dea:	1101                	addi	sp,sp,-32
    80004dec:	ec06                	sd	ra,24(sp)
    80004dee:	e822                	sd	s0,16(sp)
    80004df0:	e426                	sd	s1,8(sp)
    80004df2:	e04a                	sd	s2,0(sp)
    80004df4:	1000                	addi	s0,sp,32
    80004df6:	84aa                	mv	s1,a0
    80004df8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004dfa:	ffffc097          	auipc	ra,0xffffc
    80004dfe:	e3e080e7          	jalr	-450(ra) # 80000c38 <acquire>
  if(writable){
    80004e02:	02090d63          	beqz	s2,80004e3c <pipeclose+0x52>
    pi->writeopen = 0;
    80004e06:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e0a:	21848513          	addi	a0,s1,536
    80004e0e:	ffffd097          	auipc	ra,0xffffd
    80004e12:	564080e7          	jalr	1380(ra) # 80002372 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e16:	2204b783          	ld	a5,544(s1)
    80004e1a:	eb95                	bnez	a5,80004e4e <pipeclose+0x64>
    release(&pi->lock);
    80004e1c:	8526                	mv	a0,s1
    80004e1e:	ffffc097          	auipc	ra,0xffffc
    80004e22:	ece080e7          	jalr	-306(ra) # 80000cec <release>
    kfree((char*)pi);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffc097          	auipc	ra,0xffffc
    80004e2c:	c22080e7          	jalr	-990(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80004e30:	60e2                	ld	ra,24(sp)
    80004e32:	6442                	ld	s0,16(sp)
    80004e34:	64a2                	ld	s1,8(sp)
    80004e36:	6902                	ld	s2,0(sp)
    80004e38:	6105                	addi	sp,sp,32
    80004e3a:	8082                	ret
    pi->readopen = 0;
    80004e3c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e40:	21c48513          	addi	a0,s1,540
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	52e080e7          	jalr	1326(ra) # 80002372 <wakeup>
    80004e4c:	b7e9                	j	80004e16 <pipeclose+0x2c>
    release(&pi->lock);
    80004e4e:	8526                	mv	a0,s1
    80004e50:	ffffc097          	auipc	ra,0xffffc
    80004e54:	e9c080e7          	jalr	-356(ra) # 80000cec <release>
}
    80004e58:	bfe1                	j	80004e30 <pipeclose+0x46>

0000000080004e5a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004e5a:	711d                	addi	sp,sp,-96
    80004e5c:	ec86                	sd	ra,88(sp)
    80004e5e:	e8a2                	sd	s0,80(sp)
    80004e60:	e4a6                	sd	s1,72(sp)
    80004e62:	e0ca                	sd	s2,64(sp)
    80004e64:	fc4e                	sd	s3,56(sp)
    80004e66:	f852                	sd	s4,48(sp)
    80004e68:	f456                	sd	s5,40(sp)
    80004e6a:	1080                	addi	s0,sp,96
    80004e6c:	84aa                	mv	s1,a0
    80004e6e:	8aae                	mv	s5,a1
    80004e70:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	cc4080e7          	jalr	-828(ra) # 80001b36 <myproc>
    80004e7a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004e7c:	8526                	mv	a0,s1
    80004e7e:	ffffc097          	auipc	ra,0xffffc
    80004e82:	dba080e7          	jalr	-582(ra) # 80000c38 <acquire>
  while(i < n){
    80004e86:	0d405863          	blez	s4,80004f56 <pipewrite+0xfc>
    80004e8a:	f05a                	sd	s6,32(sp)
    80004e8c:	ec5e                	sd	s7,24(sp)
    80004e8e:	e862                	sd	s8,16(sp)
  int i = 0;
    80004e90:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e92:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e94:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e98:	21c48b93          	addi	s7,s1,540
    80004e9c:	a089                	j	80004ede <pipewrite+0x84>
      release(&pi->lock);
    80004e9e:	8526                	mv	a0,s1
    80004ea0:	ffffc097          	auipc	ra,0xffffc
    80004ea4:	e4c080e7          	jalr	-436(ra) # 80000cec <release>
      return -1;
    80004ea8:	597d                	li	s2,-1
    80004eaa:	7b02                	ld	s6,32(sp)
    80004eac:	6be2                	ld	s7,24(sp)
    80004eae:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004eb0:	854a                	mv	a0,s2
    80004eb2:	60e6                	ld	ra,88(sp)
    80004eb4:	6446                	ld	s0,80(sp)
    80004eb6:	64a6                	ld	s1,72(sp)
    80004eb8:	6906                	ld	s2,64(sp)
    80004eba:	79e2                	ld	s3,56(sp)
    80004ebc:	7a42                	ld	s4,48(sp)
    80004ebe:	7aa2                	ld	s5,40(sp)
    80004ec0:	6125                	addi	sp,sp,96
    80004ec2:	8082                	ret
      wakeup(&pi->nread);
    80004ec4:	8562                	mv	a0,s8
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	4ac080e7          	jalr	1196(ra) # 80002372 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ece:	85a6                	mv	a1,s1
    80004ed0:	855e                	mv	a0,s7
    80004ed2:	ffffd097          	auipc	ra,0xffffd
    80004ed6:	43c080e7          	jalr	1084(ra) # 8000230e <sleep>
  while(i < n){
    80004eda:	05495f63          	bge	s2,s4,80004f38 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004ede:	2204a783          	lw	a5,544(s1)
    80004ee2:	dfd5                	beqz	a5,80004e9e <pipewrite+0x44>
    80004ee4:	854e                	mv	a0,s3
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	6d0080e7          	jalr	1744(ra) # 800025b6 <killed>
    80004eee:	f945                	bnez	a0,80004e9e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ef0:	2184a783          	lw	a5,536(s1)
    80004ef4:	21c4a703          	lw	a4,540(s1)
    80004ef8:	2007879b          	addiw	a5,a5,512
    80004efc:	fcf704e3          	beq	a4,a5,80004ec4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f00:	4685                	li	a3,1
    80004f02:	01590633          	add	a2,s2,s5
    80004f06:	faf40593          	addi	a1,s0,-81
    80004f0a:	0509b503          	ld	a0,80(s3)
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	860080e7          	jalr	-1952(ra) # 8000176e <copyin>
    80004f16:	05650263          	beq	a0,s6,80004f5a <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f1a:	21c4a783          	lw	a5,540(s1)
    80004f1e:	0017871b          	addiw	a4,a5,1
    80004f22:	20e4ae23          	sw	a4,540(s1)
    80004f26:	1ff7f793          	andi	a5,a5,511
    80004f2a:	97a6                	add	a5,a5,s1
    80004f2c:	faf44703          	lbu	a4,-81(s0)
    80004f30:	00e78c23          	sb	a4,24(a5)
      i++;
    80004f34:	2905                	addiw	s2,s2,1
    80004f36:	b755                	j	80004eda <pipewrite+0x80>
    80004f38:	7b02                	ld	s6,32(sp)
    80004f3a:	6be2                	ld	s7,24(sp)
    80004f3c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004f3e:	21848513          	addi	a0,s1,536
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	430080e7          	jalr	1072(ra) # 80002372 <wakeup>
  release(&pi->lock);
    80004f4a:	8526                	mv	a0,s1
    80004f4c:	ffffc097          	auipc	ra,0xffffc
    80004f50:	da0080e7          	jalr	-608(ra) # 80000cec <release>
  return i;
    80004f54:	bfb1                	j	80004eb0 <pipewrite+0x56>
  int i = 0;
    80004f56:	4901                	li	s2,0
    80004f58:	b7dd                	j	80004f3e <pipewrite+0xe4>
    80004f5a:	7b02                	ld	s6,32(sp)
    80004f5c:	6be2                	ld	s7,24(sp)
    80004f5e:	6c42                	ld	s8,16(sp)
    80004f60:	bff9                	j	80004f3e <pipewrite+0xe4>

0000000080004f62 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f62:	715d                	addi	sp,sp,-80
    80004f64:	e486                	sd	ra,72(sp)
    80004f66:	e0a2                	sd	s0,64(sp)
    80004f68:	fc26                	sd	s1,56(sp)
    80004f6a:	f84a                	sd	s2,48(sp)
    80004f6c:	f44e                	sd	s3,40(sp)
    80004f6e:	f052                	sd	s4,32(sp)
    80004f70:	ec56                	sd	s5,24(sp)
    80004f72:	0880                	addi	s0,sp,80
    80004f74:	84aa                	mv	s1,a0
    80004f76:	892e                	mv	s2,a1
    80004f78:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004f7a:	ffffd097          	auipc	ra,0xffffd
    80004f7e:	bbc080e7          	jalr	-1092(ra) # 80001b36 <myproc>
    80004f82:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004f84:	8526                	mv	a0,s1
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	cb2080e7          	jalr	-846(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f8e:	2184a703          	lw	a4,536(s1)
    80004f92:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f96:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f9a:	02f71963          	bne	a4,a5,80004fcc <piperead+0x6a>
    80004f9e:	2244a783          	lw	a5,548(s1)
    80004fa2:	cf95                	beqz	a5,80004fde <piperead+0x7c>
    if(killed(pr)){
    80004fa4:	8552                	mv	a0,s4
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	610080e7          	jalr	1552(ra) # 800025b6 <killed>
    80004fae:	e10d                	bnez	a0,80004fd0 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004fb0:	85a6                	mv	a1,s1
    80004fb2:	854e                	mv	a0,s3
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	35a080e7          	jalr	858(ra) # 8000230e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004fbc:	2184a703          	lw	a4,536(s1)
    80004fc0:	21c4a783          	lw	a5,540(s1)
    80004fc4:	fcf70de3          	beq	a4,a5,80004f9e <piperead+0x3c>
    80004fc8:	e85a                	sd	s6,16(sp)
    80004fca:	a819                	j	80004fe0 <piperead+0x7e>
    80004fcc:	e85a                	sd	s6,16(sp)
    80004fce:	a809                	j	80004fe0 <piperead+0x7e>
      release(&pi->lock);
    80004fd0:	8526                	mv	a0,s1
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	d1a080e7          	jalr	-742(ra) # 80000cec <release>
      return -1;
    80004fda:	59fd                	li	s3,-1
    80004fdc:	a0a5                	j	80005044 <piperead+0xe2>
    80004fde:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fe0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004fe2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fe4:	05505463          	blez	s5,8000502c <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004fe8:	2184a783          	lw	a5,536(s1)
    80004fec:	21c4a703          	lw	a4,540(s1)
    80004ff0:	02f70e63          	beq	a4,a5,8000502c <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ff4:	0017871b          	addiw	a4,a5,1
    80004ff8:	20e4ac23          	sw	a4,536(s1)
    80004ffc:	1ff7f793          	andi	a5,a5,511
    80005000:	97a6                	add	a5,a5,s1
    80005002:	0187c783          	lbu	a5,24(a5)
    80005006:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000500a:	4685                	li	a3,1
    8000500c:	fbf40613          	addi	a2,s0,-65
    80005010:	85ca                	mv	a1,s2
    80005012:	050a3503          	ld	a0,80(s4)
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	6cc080e7          	jalr	1740(ra) # 800016e2 <copyout>
    8000501e:	01650763          	beq	a0,s6,8000502c <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005022:	2985                	addiw	s3,s3,1
    80005024:	0905                	addi	s2,s2,1
    80005026:	fd3a91e3          	bne	s5,s3,80004fe8 <piperead+0x86>
    8000502a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000502c:	21c48513          	addi	a0,s1,540
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	342080e7          	jalr	834(ra) # 80002372 <wakeup>
  release(&pi->lock);
    80005038:	8526                	mv	a0,s1
    8000503a:	ffffc097          	auipc	ra,0xffffc
    8000503e:	cb2080e7          	jalr	-846(ra) # 80000cec <release>
    80005042:	6b42                	ld	s6,16(sp)
  return i;
}
    80005044:	854e                	mv	a0,s3
    80005046:	60a6                	ld	ra,72(sp)
    80005048:	6406                	ld	s0,64(sp)
    8000504a:	74e2                	ld	s1,56(sp)
    8000504c:	7942                	ld	s2,48(sp)
    8000504e:	79a2                	ld	s3,40(sp)
    80005050:	7a02                	ld	s4,32(sp)
    80005052:	6ae2                	ld	s5,24(sp)
    80005054:	6161                	addi	sp,sp,80
    80005056:	8082                	ret

0000000080005058 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005058:	1141                	addi	sp,sp,-16
    8000505a:	e422                	sd	s0,8(sp)
    8000505c:	0800                	addi	s0,sp,16
    8000505e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005060:	8905                	andi	a0,a0,1
    80005062:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005064:	8b89                	andi	a5,a5,2
    80005066:	c399                	beqz	a5,8000506c <flags2perm+0x14>
      perm |= PTE_W;
    80005068:	00456513          	ori	a0,a0,4
    return perm;
}
    8000506c:	6422                	ld	s0,8(sp)
    8000506e:	0141                	addi	sp,sp,16
    80005070:	8082                	ret

0000000080005072 <exec>:

int
exec(char *path, char **argv)
{
    80005072:	df010113          	addi	sp,sp,-528
    80005076:	20113423          	sd	ra,520(sp)
    8000507a:	20813023          	sd	s0,512(sp)
    8000507e:	ffa6                	sd	s1,504(sp)
    80005080:	fbca                	sd	s2,496(sp)
    80005082:	0c00                	addi	s0,sp,528
    80005084:	892a                	mv	s2,a0
    80005086:	dea43c23          	sd	a0,-520(s0)
    8000508a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	aa8080e7          	jalr	-1368(ra) # 80001b36 <myproc>
    80005096:	84aa                	mv	s1,a0

  begin_op();
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	43a080e7          	jalr	1082(ra) # 800044d2 <begin_op>

  if((ip = namei(path)) == 0){
    800050a0:	854a                	mv	a0,s2
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	230080e7          	jalr	560(ra) # 800042d2 <namei>
    800050aa:	c135                	beqz	a0,8000510e <exec+0x9c>
    800050ac:	f3d2                	sd	s4,480(sp)
    800050ae:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	a54080e7          	jalr	-1452(ra) # 80003b04 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800050b8:	04000713          	li	a4,64
    800050bc:	4681                	li	a3,0
    800050be:	e5040613          	addi	a2,s0,-432
    800050c2:	4581                	li	a1,0
    800050c4:	8552                	mv	a0,s4
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	cf6080e7          	jalr	-778(ra) # 80003dbc <readi>
    800050ce:	04000793          	li	a5,64
    800050d2:	00f51a63          	bne	a0,a5,800050e6 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800050d6:	e5042703          	lw	a4,-432(s0)
    800050da:	464c47b7          	lui	a5,0x464c4
    800050de:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800050e2:	02f70c63          	beq	a4,a5,8000511a <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800050e6:	8552                	mv	a0,s4
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	c82080e7          	jalr	-894(ra) # 80003d6a <iunlockput>
    end_op();
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	45c080e7          	jalr	1116(ra) # 8000454c <end_op>
  }
  return -1;
    800050f8:	557d                	li	a0,-1
    800050fa:	7a1e                	ld	s4,480(sp)
}
    800050fc:	20813083          	ld	ra,520(sp)
    80005100:	20013403          	ld	s0,512(sp)
    80005104:	74fe                	ld	s1,504(sp)
    80005106:	795e                	ld	s2,496(sp)
    80005108:	21010113          	addi	sp,sp,528
    8000510c:	8082                	ret
    end_op();
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	43e080e7          	jalr	1086(ra) # 8000454c <end_op>
    return -1;
    80005116:	557d                	li	a0,-1
    80005118:	b7d5                	j	800050fc <exec+0x8a>
    8000511a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000511c:	8526                	mv	a0,s1
    8000511e:	ffffd097          	auipc	ra,0xffffd
    80005122:	adc080e7          	jalr	-1316(ra) # 80001bfa <proc_pagetable>
    80005126:	8b2a                	mv	s6,a0
    80005128:	30050f63          	beqz	a0,80005446 <exec+0x3d4>
    8000512c:	f7ce                	sd	s3,488(sp)
    8000512e:	efd6                	sd	s5,472(sp)
    80005130:	e7de                	sd	s7,456(sp)
    80005132:	e3e2                	sd	s8,448(sp)
    80005134:	ff66                	sd	s9,440(sp)
    80005136:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005138:	e7042d03          	lw	s10,-400(s0)
    8000513c:	e8845783          	lhu	a5,-376(s0)
    80005140:	14078d63          	beqz	a5,8000529a <exec+0x228>
    80005144:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005146:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005148:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000514a:	6c85                	lui	s9,0x1
    8000514c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005150:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005154:	6a85                	lui	s5,0x1
    80005156:	a0b5                	j	800051c2 <exec+0x150>
      panic("loadseg: address should exist");
    80005158:	00003517          	auipc	a0,0x3
    8000515c:	54850513          	addi	a0,a0,1352 # 800086a0 <etext+0x6a0>
    80005160:	ffffb097          	auipc	ra,0xffffb
    80005164:	400080e7          	jalr	1024(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005168:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000516a:	8726                	mv	a4,s1
    8000516c:	012c06bb          	addw	a3,s8,s2
    80005170:	4581                	li	a1,0
    80005172:	8552                	mv	a0,s4
    80005174:	fffff097          	auipc	ra,0xfffff
    80005178:	c48080e7          	jalr	-952(ra) # 80003dbc <readi>
    8000517c:	2501                	sext.w	a0,a0
    8000517e:	28a49863          	bne	s1,a0,8000540e <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80005182:	012a893b          	addw	s2,s5,s2
    80005186:	03397563          	bgeu	s2,s3,800051b0 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000518a:	02091593          	slli	a1,s2,0x20
    8000518e:	9181                	srli	a1,a1,0x20
    80005190:	95de                	add	a1,a1,s7
    80005192:	855a                	mv	a0,s6
    80005194:	ffffc097          	auipc	ra,0xffffc
    80005198:	f22080e7          	jalr	-222(ra) # 800010b6 <walkaddr>
    8000519c:	862a                	mv	a2,a0
    if(pa == 0)
    8000519e:	dd4d                	beqz	a0,80005158 <exec+0xe6>
    if(sz - i < PGSIZE)
    800051a0:	412984bb          	subw	s1,s3,s2
    800051a4:	0004879b          	sext.w	a5,s1
    800051a8:	fcfcf0e3          	bgeu	s9,a5,80005168 <exec+0xf6>
    800051ac:	84d6                	mv	s1,s5
    800051ae:	bf6d                	j	80005168 <exec+0xf6>
    sz = sz1;
    800051b0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051b4:	2d85                	addiw	s11,s11,1
    800051b6:	038d0d1b          	addiw	s10,s10,56
    800051ba:	e8845783          	lhu	a5,-376(s0)
    800051be:	08fdd663          	bge	s11,a5,8000524a <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800051c2:	2d01                	sext.w	s10,s10
    800051c4:	03800713          	li	a4,56
    800051c8:	86ea                	mv	a3,s10
    800051ca:	e1840613          	addi	a2,s0,-488
    800051ce:	4581                	li	a1,0
    800051d0:	8552                	mv	a0,s4
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	bea080e7          	jalr	-1046(ra) # 80003dbc <readi>
    800051da:	03800793          	li	a5,56
    800051de:	20f51063          	bne	a0,a5,800053de <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800051e2:	e1842783          	lw	a5,-488(s0)
    800051e6:	4705                	li	a4,1
    800051e8:	fce796e3          	bne	a5,a4,800051b4 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800051ec:	e4043483          	ld	s1,-448(s0)
    800051f0:	e3843783          	ld	a5,-456(s0)
    800051f4:	1ef4e963          	bltu	s1,a5,800053e6 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800051f8:	e2843783          	ld	a5,-472(s0)
    800051fc:	94be                	add	s1,s1,a5
    800051fe:	1ef4e863          	bltu	s1,a5,800053ee <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005202:	df043703          	ld	a4,-528(s0)
    80005206:	8ff9                	and	a5,a5,a4
    80005208:	1e079763          	bnez	a5,800053f6 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000520c:	e1c42503          	lw	a0,-484(s0)
    80005210:	00000097          	auipc	ra,0x0
    80005214:	e48080e7          	jalr	-440(ra) # 80005058 <flags2perm>
    80005218:	86aa                	mv	a3,a0
    8000521a:	8626                	mv	a2,s1
    8000521c:	85ca                	mv	a1,s2
    8000521e:	855a                	mv	a0,s6
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	25a080e7          	jalr	602(ra) # 8000147a <uvmalloc>
    80005228:	e0a43423          	sd	a0,-504(s0)
    8000522c:	1c050963          	beqz	a0,800053fe <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005230:	e2843b83          	ld	s7,-472(s0)
    80005234:	e2042c03          	lw	s8,-480(s0)
    80005238:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000523c:	00098463          	beqz	s3,80005244 <exec+0x1d2>
    80005240:	4901                	li	s2,0
    80005242:	b7a1                	j	8000518a <exec+0x118>
    sz = sz1;
    80005244:	e0843903          	ld	s2,-504(s0)
    80005248:	b7b5                	j	800051b4 <exec+0x142>
    8000524a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000524c:	8552                	mv	a0,s4
    8000524e:	fffff097          	auipc	ra,0xfffff
    80005252:	b1c080e7          	jalr	-1252(ra) # 80003d6a <iunlockput>
  end_op();
    80005256:	fffff097          	auipc	ra,0xfffff
    8000525a:	2f6080e7          	jalr	758(ra) # 8000454c <end_op>
  p = myproc();
    8000525e:	ffffd097          	auipc	ra,0xffffd
    80005262:	8d8080e7          	jalr	-1832(ra) # 80001b36 <myproc>
    80005266:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005268:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000526c:	6985                	lui	s3,0x1
    8000526e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005270:	99ca                	add	s3,s3,s2
    80005272:	77fd                	lui	a5,0xfffff
    80005274:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005278:	4691                	li	a3,4
    8000527a:	6609                	lui	a2,0x2
    8000527c:	964e                	add	a2,a2,s3
    8000527e:	85ce                	mv	a1,s3
    80005280:	855a                	mv	a0,s6
    80005282:	ffffc097          	auipc	ra,0xffffc
    80005286:	1f8080e7          	jalr	504(ra) # 8000147a <uvmalloc>
    8000528a:	892a                	mv	s2,a0
    8000528c:	e0a43423          	sd	a0,-504(s0)
    80005290:	e519                	bnez	a0,8000529e <exec+0x22c>
  if(pagetable)
    80005292:	e1343423          	sd	s3,-504(s0)
    80005296:	4a01                	li	s4,0
    80005298:	aaa5                	j	80005410 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000529a:	4901                	li	s2,0
    8000529c:	bf45                	j	8000524c <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000529e:	75f9                	lui	a1,0xffffe
    800052a0:	95aa                	add	a1,a1,a0
    800052a2:	855a                	mv	a0,s6
    800052a4:	ffffc097          	auipc	ra,0xffffc
    800052a8:	40c080e7          	jalr	1036(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    800052ac:	7bfd                	lui	s7,0xfffff
    800052ae:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800052b0:	e0043783          	ld	a5,-512(s0)
    800052b4:	6388                	ld	a0,0(a5)
    800052b6:	c52d                	beqz	a0,80005320 <exec+0x2ae>
    800052b8:	e9040993          	addi	s3,s0,-368
    800052bc:	f9040c13          	addi	s8,s0,-112
    800052c0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800052c2:	ffffc097          	auipc	ra,0xffffc
    800052c6:	be6080e7          	jalr	-1050(ra) # 80000ea8 <strlen>
    800052ca:	0015079b          	addiw	a5,a0,1
    800052ce:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800052d2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800052d6:	13796863          	bltu	s2,s7,80005406 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800052da:	e0043d03          	ld	s10,-512(s0)
    800052de:	000d3a03          	ld	s4,0(s10)
    800052e2:	8552                	mv	a0,s4
    800052e4:	ffffc097          	auipc	ra,0xffffc
    800052e8:	bc4080e7          	jalr	-1084(ra) # 80000ea8 <strlen>
    800052ec:	0015069b          	addiw	a3,a0,1
    800052f0:	8652                	mv	a2,s4
    800052f2:	85ca                	mv	a1,s2
    800052f4:	855a                	mv	a0,s6
    800052f6:	ffffc097          	auipc	ra,0xffffc
    800052fa:	3ec080e7          	jalr	1004(ra) # 800016e2 <copyout>
    800052fe:	10054663          	bltz	a0,8000540a <exec+0x398>
    ustack[argc] = sp;
    80005302:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005306:	0485                	addi	s1,s1,1
    80005308:	008d0793          	addi	a5,s10,8
    8000530c:	e0f43023          	sd	a5,-512(s0)
    80005310:	008d3503          	ld	a0,8(s10)
    80005314:	c909                	beqz	a0,80005326 <exec+0x2b4>
    if(argc >= MAXARG)
    80005316:	09a1                	addi	s3,s3,8
    80005318:	fb8995e3          	bne	s3,s8,800052c2 <exec+0x250>
  ip = 0;
    8000531c:	4a01                	li	s4,0
    8000531e:	a8cd                	j	80005410 <exec+0x39e>
  sp = sz;
    80005320:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005324:	4481                	li	s1,0
  ustack[argc] = 0;
    80005326:	00349793          	slli	a5,s1,0x3
    8000532a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda660>
    8000532e:	97a2                	add	a5,a5,s0
    80005330:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005334:	00148693          	addi	a3,s1,1
    80005338:	068e                	slli	a3,a3,0x3
    8000533a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000533e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005342:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005346:	f57966e3          	bltu	s2,s7,80005292 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000534a:	e9040613          	addi	a2,s0,-368
    8000534e:	85ca                	mv	a1,s2
    80005350:	855a                	mv	a0,s6
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	390080e7          	jalr	912(ra) # 800016e2 <copyout>
    8000535a:	0e054863          	bltz	a0,8000544a <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000535e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005362:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005366:	df843783          	ld	a5,-520(s0)
    8000536a:	0007c703          	lbu	a4,0(a5)
    8000536e:	cf11                	beqz	a4,8000538a <exec+0x318>
    80005370:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005372:	02f00693          	li	a3,47
    80005376:	a039                	j	80005384 <exec+0x312>
      last = s+1;
    80005378:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000537c:	0785                	addi	a5,a5,1
    8000537e:	fff7c703          	lbu	a4,-1(a5)
    80005382:	c701                	beqz	a4,8000538a <exec+0x318>
    if(*s == '/')
    80005384:	fed71ce3          	bne	a4,a3,8000537c <exec+0x30a>
    80005388:	bfc5                	j	80005378 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    8000538a:	4641                	li	a2,16
    8000538c:	df843583          	ld	a1,-520(s0)
    80005390:	158a8513          	addi	a0,s5,344
    80005394:	ffffc097          	auipc	ra,0xffffc
    80005398:	ae2080e7          	jalr	-1310(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    8000539c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800053a0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800053a4:	e0843783          	ld	a5,-504(s0)
    800053a8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800053ac:	058ab783          	ld	a5,88(s5)
    800053b0:	e6843703          	ld	a4,-408(s0)
    800053b4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800053b6:	058ab783          	ld	a5,88(s5)
    800053ba:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800053be:	85e6                	mv	a1,s9
    800053c0:	ffffd097          	auipc	ra,0xffffd
    800053c4:	8d6080e7          	jalr	-1834(ra) # 80001c96 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053c8:	0004851b          	sext.w	a0,s1
    800053cc:	79be                	ld	s3,488(sp)
    800053ce:	7a1e                	ld	s4,480(sp)
    800053d0:	6afe                	ld	s5,472(sp)
    800053d2:	6b5e                	ld	s6,464(sp)
    800053d4:	6bbe                	ld	s7,456(sp)
    800053d6:	6c1e                	ld	s8,448(sp)
    800053d8:	7cfa                	ld	s9,440(sp)
    800053da:	7d5a                	ld	s10,432(sp)
    800053dc:	b305                	j	800050fc <exec+0x8a>
    800053de:	e1243423          	sd	s2,-504(s0)
    800053e2:	7dba                	ld	s11,424(sp)
    800053e4:	a035                	j	80005410 <exec+0x39e>
    800053e6:	e1243423          	sd	s2,-504(s0)
    800053ea:	7dba                	ld	s11,424(sp)
    800053ec:	a015                	j	80005410 <exec+0x39e>
    800053ee:	e1243423          	sd	s2,-504(s0)
    800053f2:	7dba                	ld	s11,424(sp)
    800053f4:	a831                	j	80005410 <exec+0x39e>
    800053f6:	e1243423          	sd	s2,-504(s0)
    800053fa:	7dba                	ld	s11,424(sp)
    800053fc:	a811                	j	80005410 <exec+0x39e>
    800053fe:	e1243423          	sd	s2,-504(s0)
    80005402:	7dba                	ld	s11,424(sp)
    80005404:	a031                	j	80005410 <exec+0x39e>
  ip = 0;
    80005406:	4a01                	li	s4,0
    80005408:	a021                	j	80005410 <exec+0x39e>
    8000540a:	4a01                	li	s4,0
  if(pagetable)
    8000540c:	a011                	j	80005410 <exec+0x39e>
    8000540e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005410:	e0843583          	ld	a1,-504(s0)
    80005414:	855a                	mv	a0,s6
    80005416:	ffffd097          	auipc	ra,0xffffd
    8000541a:	880080e7          	jalr	-1920(ra) # 80001c96 <proc_freepagetable>
  return -1;
    8000541e:	557d                	li	a0,-1
  if(ip){
    80005420:	000a1b63          	bnez	s4,80005436 <exec+0x3c4>
    80005424:	79be                	ld	s3,488(sp)
    80005426:	7a1e                	ld	s4,480(sp)
    80005428:	6afe                	ld	s5,472(sp)
    8000542a:	6b5e                	ld	s6,464(sp)
    8000542c:	6bbe                	ld	s7,456(sp)
    8000542e:	6c1e                	ld	s8,448(sp)
    80005430:	7cfa                	ld	s9,440(sp)
    80005432:	7d5a                	ld	s10,432(sp)
    80005434:	b1e1                	j	800050fc <exec+0x8a>
    80005436:	79be                	ld	s3,488(sp)
    80005438:	6afe                	ld	s5,472(sp)
    8000543a:	6b5e                	ld	s6,464(sp)
    8000543c:	6bbe                	ld	s7,456(sp)
    8000543e:	6c1e                	ld	s8,448(sp)
    80005440:	7cfa                	ld	s9,440(sp)
    80005442:	7d5a                	ld	s10,432(sp)
    80005444:	b14d                	j	800050e6 <exec+0x74>
    80005446:	6b5e                	ld	s6,464(sp)
    80005448:	b979                	j	800050e6 <exec+0x74>
  sz = sz1;
    8000544a:	e0843983          	ld	s3,-504(s0)
    8000544e:	b591                	j	80005292 <exec+0x220>

0000000080005450 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005450:	7179                	addi	sp,sp,-48
    80005452:	f406                	sd	ra,40(sp)
    80005454:	f022                	sd	s0,32(sp)
    80005456:	ec26                	sd	s1,24(sp)
    80005458:	e84a                	sd	s2,16(sp)
    8000545a:	1800                	addi	s0,sp,48
    8000545c:	892e                	mv	s2,a1
    8000545e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005460:	fdc40593          	addi	a1,s0,-36
    80005464:	ffffe097          	auipc	ra,0xffffe
    80005468:	a6a080e7          	jalr	-1430(ra) # 80002ece <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000546c:	fdc42703          	lw	a4,-36(s0)
    80005470:	47bd                	li	a5,15
    80005472:	02e7eb63          	bltu	a5,a4,800054a8 <argfd+0x58>
    80005476:	ffffc097          	auipc	ra,0xffffc
    8000547a:	6c0080e7          	jalr	1728(ra) # 80001b36 <myproc>
    8000547e:	fdc42703          	lw	a4,-36(s0)
    80005482:	01a70793          	addi	a5,a4,26
    80005486:	078e                	slli	a5,a5,0x3
    80005488:	953e                	add	a0,a0,a5
    8000548a:	611c                	ld	a5,0(a0)
    8000548c:	c385                	beqz	a5,800054ac <argfd+0x5c>
    return -1;
  if(pfd)
    8000548e:	00090463          	beqz	s2,80005496 <argfd+0x46>
    *pfd = fd;
    80005492:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005496:	4501                	li	a0,0
  if(pf)
    80005498:	c091                	beqz	s1,8000549c <argfd+0x4c>
    *pf = f;
    8000549a:	e09c                	sd	a5,0(s1)
}
    8000549c:	70a2                	ld	ra,40(sp)
    8000549e:	7402                	ld	s0,32(sp)
    800054a0:	64e2                	ld	s1,24(sp)
    800054a2:	6942                	ld	s2,16(sp)
    800054a4:	6145                	addi	sp,sp,48
    800054a6:	8082                	ret
    return -1;
    800054a8:	557d                	li	a0,-1
    800054aa:	bfcd                	j	8000549c <argfd+0x4c>
    800054ac:	557d                	li	a0,-1
    800054ae:	b7fd                	j	8000549c <argfd+0x4c>

00000000800054b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800054b0:	1101                	addi	sp,sp,-32
    800054b2:	ec06                	sd	ra,24(sp)
    800054b4:	e822                	sd	s0,16(sp)
    800054b6:	e426                	sd	s1,8(sp)
    800054b8:	1000                	addi	s0,sp,32
    800054ba:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054bc:	ffffc097          	auipc	ra,0xffffc
    800054c0:	67a080e7          	jalr	1658(ra) # 80001b36 <myproc>
    800054c4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800054c6:	0d050793          	addi	a5,a0,208
    800054ca:	4501                	li	a0,0
    800054cc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800054ce:	6398                	ld	a4,0(a5)
    800054d0:	cb19                	beqz	a4,800054e6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800054d2:	2505                	addiw	a0,a0,1
    800054d4:	07a1                	addi	a5,a5,8
    800054d6:	fed51ce3          	bne	a0,a3,800054ce <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800054da:	557d                	li	a0,-1
}
    800054dc:	60e2                	ld	ra,24(sp)
    800054de:	6442                	ld	s0,16(sp)
    800054e0:	64a2                	ld	s1,8(sp)
    800054e2:	6105                	addi	sp,sp,32
    800054e4:	8082                	ret
      p->ofile[fd] = f;
    800054e6:	01a50793          	addi	a5,a0,26
    800054ea:	078e                	slli	a5,a5,0x3
    800054ec:	963e                	add	a2,a2,a5
    800054ee:	e204                	sd	s1,0(a2)
      return fd;
    800054f0:	b7f5                	j	800054dc <fdalloc+0x2c>

00000000800054f2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800054f2:	715d                	addi	sp,sp,-80
    800054f4:	e486                	sd	ra,72(sp)
    800054f6:	e0a2                	sd	s0,64(sp)
    800054f8:	fc26                	sd	s1,56(sp)
    800054fa:	f84a                	sd	s2,48(sp)
    800054fc:	f44e                	sd	s3,40(sp)
    800054fe:	ec56                	sd	s5,24(sp)
    80005500:	e85a                	sd	s6,16(sp)
    80005502:	0880                	addi	s0,sp,80
    80005504:	8b2e                	mv	s6,a1
    80005506:	89b2                	mv	s3,a2
    80005508:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000550a:	fb040593          	addi	a1,s0,-80
    8000550e:	fffff097          	auipc	ra,0xfffff
    80005512:	de2080e7          	jalr	-542(ra) # 800042f0 <nameiparent>
    80005516:	84aa                	mv	s1,a0
    80005518:	14050e63          	beqz	a0,80005674 <create+0x182>
    return 0;

  ilock(dp);
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	5e8080e7          	jalr	1512(ra) # 80003b04 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005524:	4601                	li	a2,0
    80005526:	fb040593          	addi	a1,s0,-80
    8000552a:	8526                	mv	a0,s1
    8000552c:	fffff097          	auipc	ra,0xfffff
    80005530:	ae4080e7          	jalr	-1308(ra) # 80004010 <dirlookup>
    80005534:	8aaa                	mv	s5,a0
    80005536:	c539                	beqz	a0,80005584 <create+0x92>
    iunlockput(dp);
    80005538:	8526                	mv	a0,s1
    8000553a:	fffff097          	auipc	ra,0xfffff
    8000553e:	830080e7          	jalr	-2000(ra) # 80003d6a <iunlockput>
    ilock(ip);
    80005542:	8556                	mv	a0,s5
    80005544:	ffffe097          	auipc	ra,0xffffe
    80005548:	5c0080e7          	jalr	1472(ra) # 80003b04 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000554c:	4789                	li	a5,2
    8000554e:	02fb1463          	bne	s6,a5,80005576 <create+0x84>
    80005552:	044ad783          	lhu	a5,68(s5)
    80005556:	37f9                	addiw	a5,a5,-2
    80005558:	17c2                	slli	a5,a5,0x30
    8000555a:	93c1                	srli	a5,a5,0x30
    8000555c:	4705                	li	a4,1
    8000555e:	00f76c63          	bltu	a4,a5,80005576 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005562:	8556                	mv	a0,s5
    80005564:	60a6                	ld	ra,72(sp)
    80005566:	6406                	ld	s0,64(sp)
    80005568:	74e2                	ld	s1,56(sp)
    8000556a:	7942                	ld	s2,48(sp)
    8000556c:	79a2                	ld	s3,40(sp)
    8000556e:	6ae2                	ld	s5,24(sp)
    80005570:	6b42                	ld	s6,16(sp)
    80005572:	6161                	addi	sp,sp,80
    80005574:	8082                	ret
    iunlockput(ip);
    80005576:	8556                	mv	a0,s5
    80005578:	ffffe097          	auipc	ra,0xffffe
    8000557c:	7f2080e7          	jalr	2034(ra) # 80003d6a <iunlockput>
    return 0;
    80005580:	4a81                	li	s5,0
    80005582:	b7c5                	j	80005562 <create+0x70>
    80005584:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005586:	85da                	mv	a1,s6
    80005588:	4088                	lw	a0,0(s1)
    8000558a:	ffffe097          	auipc	ra,0xffffe
    8000558e:	3d6080e7          	jalr	982(ra) # 80003960 <ialloc>
    80005592:	8a2a                	mv	s4,a0
    80005594:	c531                	beqz	a0,800055e0 <create+0xee>
  ilock(ip);
    80005596:	ffffe097          	auipc	ra,0xffffe
    8000559a:	56e080e7          	jalr	1390(ra) # 80003b04 <ilock>
  ip->major = major;
    8000559e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800055a2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800055a6:	4905                	li	s2,1
    800055a8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800055ac:	8552                	mv	a0,s4
    800055ae:	ffffe097          	auipc	ra,0xffffe
    800055b2:	48a080e7          	jalr	1162(ra) # 80003a38 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800055b6:	032b0d63          	beq	s6,s2,800055f0 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800055ba:	004a2603          	lw	a2,4(s4)
    800055be:	fb040593          	addi	a1,s0,-80
    800055c2:	8526                	mv	a0,s1
    800055c4:	fffff097          	auipc	ra,0xfffff
    800055c8:	c5c080e7          	jalr	-932(ra) # 80004220 <dirlink>
    800055cc:	08054163          	bltz	a0,8000564e <create+0x15c>
  iunlockput(dp);
    800055d0:	8526                	mv	a0,s1
    800055d2:	ffffe097          	auipc	ra,0xffffe
    800055d6:	798080e7          	jalr	1944(ra) # 80003d6a <iunlockput>
  return ip;
    800055da:	8ad2                	mv	s5,s4
    800055dc:	7a02                	ld	s4,32(sp)
    800055de:	b751                	j	80005562 <create+0x70>
    iunlockput(dp);
    800055e0:	8526                	mv	a0,s1
    800055e2:	ffffe097          	auipc	ra,0xffffe
    800055e6:	788080e7          	jalr	1928(ra) # 80003d6a <iunlockput>
    return 0;
    800055ea:	8ad2                	mv	s5,s4
    800055ec:	7a02                	ld	s4,32(sp)
    800055ee:	bf95                	j	80005562 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800055f0:	004a2603          	lw	a2,4(s4)
    800055f4:	00003597          	auipc	a1,0x3
    800055f8:	0cc58593          	addi	a1,a1,204 # 800086c0 <etext+0x6c0>
    800055fc:	8552                	mv	a0,s4
    800055fe:	fffff097          	auipc	ra,0xfffff
    80005602:	c22080e7          	jalr	-990(ra) # 80004220 <dirlink>
    80005606:	04054463          	bltz	a0,8000564e <create+0x15c>
    8000560a:	40d0                	lw	a2,4(s1)
    8000560c:	00003597          	auipc	a1,0x3
    80005610:	0bc58593          	addi	a1,a1,188 # 800086c8 <etext+0x6c8>
    80005614:	8552                	mv	a0,s4
    80005616:	fffff097          	auipc	ra,0xfffff
    8000561a:	c0a080e7          	jalr	-1014(ra) # 80004220 <dirlink>
    8000561e:	02054863          	bltz	a0,8000564e <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005622:	004a2603          	lw	a2,4(s4)
    80005626:	fb040593          	addi	a1,s0,-80
    8000562a:	8526                	mv	a0,s1
    8000562c:	fffff097          	auipc	ra,0xfffff
    80005630:	bf4080e7          	jalr	-1036(ra) # 80004220 <dirlink>
    80005634:	00054d63          	bltz	a0,8000564e <create+0x15c>
    dp->nlink++;  // for ".."
    80005638:	04a4d783          	lhu	a5,74(s1)
    8000563c:	2785                	addiw	a5,a5,1
    8000563e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005642:	8526                	mv	a0,s1
    80005644:	ffffe097          	auipc	ra,0xffffe
    80005648:	3f4080e7          	jalr	1012(ra) # 80003a38 <iupdate>
    8000564c:	b751                	j	800055d0 <create+0xde>
  ip->nlink = 0;
    8000564e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005652:	8552                	mv	a0,s4
    80005654:	ffffe097          	auipc	ra,0xffffe
    80005658:	3e4080e7          	jalr	996(ra) # 80003a38 <iupdate>
  iunlockput(ip);
    8000565c:	8552                	mv	a0,s4
    8000565e:	ffffe097          	auipc	ra,0xffffe
    80005662:	70c080e7          	jalr	1804(ra) # 80003d6a <iunlockput>
  iunlockput(dp);
    80005666:	8526                	mv	a0,s1
    80005668:	ffffe097          	auipc	ra,0xffffe
    8000566c:	702080e7          	jalr	1794(ra) # 80003d6a <iunlockput>
  return 0;
    80005670:	7a02                	ld	s4,32(sp)
    80005672:	bdc5                	j	80005562 <create+0x70>
    return 0;
    80005674:	8aaa                	mv	s5,a0
    80005676:	b5f5                	j	80005562 <create+0x70>

0000000080005678 <sys_dup>:
{
    80005678:	7179                	addi	sp,sp,-48
    8000567a:	f406                	sd	ra,40(sp)
    8000567c:	f022                	sd	s0,32(sp)
    8000567e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005680:	fd840613          	addi	a2,s0,-40
    80005684:	4581                	li	a1,0
    80005686:	4501                	li	a0,0
    80005688:	00000097          	auipc	ra,0x0
    8000568c:	dc8080e7          	jalr	-568(ra) # 80005450 <argfd>
    return -1;
    80005690:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005692:	02054763          	bltz	a0,800056c0 <sys_dup+0x48>
    80005696:	ec26                	sd	s1,24(sp)
    80005698:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000569a:	fd843903          	ld	s2,-40(s0)
    8000569e:	854a                	mv	a0,s2
    800056a0:	00000097          	auipc	ra,0x0
    800056a4:	e10080e7          	jalr	-496(ra) # 800054b0 <fdalloc>
    800056a8:	84aa                	mv	s1,a0
    return -1;
    800056aa:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800056ac:	00054f63          	bltz	a0,800056ca <sys_dup+0x52>
  filedup(f);
    800056b0:	854a                	mv	a0,s2
    800056b2:	fffff097          	auipc	ra,0xfffff
    800056b6:	298080e7          	jalr	664(ra) # 8000494a <filedup>
  return fd;
    800056ba:	87a6                	mv	a5,s1
    800056bc:	64e2                	ld	s1,24(sp)
    800056be:	6942                	ld	s2,16(sp)
}
    800056c0:	853e                	mv	a0,a5
    800056c2:	70a2                	ld	ra,40(sp)
    800056c4:	7402                	ld	s0,32(sp)
    800056c6:	6145                	addi	sp,sp,48
    800056c8:	8082                	ret
    800056ca:	64e2                	ld	s1,24(sp)
    800056cc:	6942                	ld	s2,16(sp)
    800056ce:	bfcd                	j	800056c0 <sys_dup+0x48>

00000000800056d0 <sys_read>:
{
    800056d0:	7179                	addi	sp,sp,-48
    800056d2:	f406                	sd	ra,40(sp)
    800056d4:	f022                	sd	s0,32(sp)
    800056d6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800056d8:	fd840593          	addi	a1,s0,-40
    800056dc:	4505                	li	a0,1
    800056de:	ffffe097          	auipc	ra,0xffffe
    800056e2:	810080e7          	jalr	-2032(ra) # 80002eee <argaddr>
  argint(2, &n);
    800056e6:	fe440593          	addi	a1,s0,-28
    800056ea:	4509                	li	a0,2
    800056ec:	ffffd097          	auipc	ra,0xffffd
    800056f0:	7e2080e7          	jalr	2018(ra) # 80002ece <argint>
  if(argfd(0, 0, &f) < 0)
    800056f4:	fe840613          	addi	a2,s0,-24
    800056f8:	4581                	li	a1,0
    800056fa:	4501                	li	a0,0
    800056fc:	00000097          	auipc	ra,0x0
    80005700:	d54080e7          	jalr	-684(ra) # 80005450 <argfd>
    80005704:	87aa                	mv	a5,a0
    return -1;
    80005706:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005708:	0007cc63          	bltz	a5,80005720 <sys_read+0x50>
  return fileread(f, p, n);
    8000570c:	fe442603          	lw	a2,-28(s0)
    80005710:	fd843583          	ld	a1,-40(s0)
    80005714:	fe843503          	ld	a0,-24(s0)
    80005718:	fffff097          	auipc	ra,0xfffff
    8000571c:	3d8080e7          	jalr	984(ra) # 80004af0 <fileread>
}
    80005720:	70a2                	ld	ra,40(sp)
    80005722:	7402                	ld	s0,32(sp)
    80005724:	6145                	addi	sp,sp,48
    80005726:	8082                	ret

0000000080005728 <sys_write>:
{
    80005728:	7179                	addi	sp,sp,-48
    8000572a:	f406                	sd	ra,40(sp)
    8000572c:	f022                	sd	s0,32(sp)
    8000572e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005730:	fd840593          	addi	a1,s0,-40
    80005734:	4505                	li	a0,1
    80005736:	ffffd097          	auipc	ra,0xffffd
    8000573a:	7b8080e7          	jalr	1976(ra) # 80002eee <argaddr>
  argint(2, &n);
    8000573e:	fe440593          	addi	a1,s0,-28
    80005742:	4509                	li	a0,2
    80005744:	ffffd097          	auipc	ra,0xffffd
    80005748:	78a080e7          	jalr	1930(ra) # 80002ece <argint>
  if(argfd(0, 0, &f) < 0)
    8000574c:	fe840613          	addi	a2,s0,-24
    80005750:	4581                	li	a1,0
    80005752:	4501                	li	a0,0
    80005754:	00000097          	auipc	ra,0x0
    80005758:	cfc080e7          	jalr	-772(ra) # 80005450 <argfd>
    8000575c:	87aa                	mv	a5,a0
    return -1;
    8000575e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005760:	0007cc63          	bltz	a5,80005778 <sys_write+0x50>
  return filewrite(f, p, n);
    80005764:	fe442603          	lw	a2,-28(s0)
    80005768:	fd843583          	ld	a1,-40(s0)
    8000576c:	fe843503          	ld	a0,-24(s0)
    80005770:	fffff097          	auipc	ra,0xfffff
    80005774:	452080e7          	jalr	1106(ra) # 80004bc2 <filewrite>
}
    80005778:	70a2                	ld	ra,40(sp)
    8000577a:	7402                	ld	s0,32(sp)
    8000577c:	6145                	addi	sp,sp,48
    8000577e:	8082                	ret

0000000080005780 <sys_close>:
{
    80005780:	1101                	addi	sp,sp,-32
    80005782:	ec06                	sd	ra,24(sp)
    80005784:	e822                	sd	s0,16(sp)
    80005786:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005788:	fe040613          	addi	a2,s0,-32
    8000578c:	fec40593          	addi	a1,s0,-20
    80005790:	4501                	li	a0,0
    80005792:	00000097          	auipc	ra,0x0
    80005796:	cbe080e7          	jalr	-834(ra) # 80005450 <argfd>
    return -1;
    8000579a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000579c:	02054463          	bltz	a0,800057c4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800057a0:	ffffc097          	auipc	ra,0xffffc
    800057a4:	396080e7          	jalr	918(ra) # 80001b36 <myproc>
    800057a8:	fec42783          	lw	a5,-20(s0)
    800057ac:	07e9                	addi	a5,a5,26
    800057ae:	078e                	slli	a5,a5,0x3
    800057b0:	953e                	add	a0,a0,a5
    800057b2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800057b6:	fe043503          	ld	a0,-32(s0)
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	1e2080e7          	jalr	482(ra) # 8000499c <fileclose>
  return 0;
    800057c2:	4781                	li	a5,0
}
    800057c4:	853e                	mv	a0,a5
    800057c6:	60e2                	ld	ra,24(sp)
    800057c8:	6442                	ld	s0,16(sp)
    800057ca:	6105                	addi	sp,sp,32
    800057cc:	8082                	ret

00000000800057ce <sys_fstat>:
{
    800057ce:	1101                	addi	sp,sp,-32
    800057d0:	ec06                	sd	ra,24(sp)
    800057d2:	e822                	sd	s0,16(sp)
    800057d4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800057d6:	fe040593          	addi	a1,s0,-32
    800057da:	4505                	li	a0,1
    800057dc:	ffffd097          	auipc	ra,0xffffd
    800057e0:	712080e7          	jalr	1810(ra) # 80002eee <argaddr>
  if(argfd(0, 0, &f) < 0)
    800057e4:	fe840613          	addi	a2,s0,-24
    800057e8:	4581                	li	a1,0
    800057ea:	4501                	li	a0,0
    800057ec:	00000097          	auipc	ra,0x0
    800057f0:	c64080e7          	jalr	-924(ra) # 80005450 <argfd>
    800057f4:	87aa                	mv	a5,a0
    return -1;
    800057f6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800057f8:	0007ca63          	bltz	a5,8000580c <sys_fstat+0x3e>
  return filestat(f, st);
    800057fc:	fe043583          	ld	a1,-32(s0)
    80005800:	fe843503          	ld	a0,-24(s0)
    80005804:	fffff097          	auipc	ra,0xfffff
    80005808:	27a080e7          	jalr	634(ra) # 80004a7e <filestat>
}
    8000580c:	60e2                	ld	ra,24(sp)
    8000580e:	6442                	ld	s0,16(sp)
    80005810:	6105                	addi	sp,sp,32
    80005812:	8082                	ret

0000000080005814 <sys_link>:
{
    80005814:	7169                	addi	sp,sp,-304
    80005816:	f606                	sd	ra,296(sp)
    80005818:	f222                	sd	s0,288(sp)
    8000581a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000581c:	08000613          	li	a2,128
    80005820:	ed040593          	addi	a1,s0,-304
    80005824:	4501                	li	a0,0
    80005826:	ffffd097          	auipc	ra,0xffffd
    8000582a:	6e8080e7          	jalr	1768(ra) # 80002f0e <argstr>
    return -1;
    8000582e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005830:	12054663          	bltz	a0,8000595c <sys_link+0x148>
    80005834:	08000613          	li	a2,128
    80005838:	f5040593          	addi	a1,s0,-176
    8000583c:	4505                	li	a0,1
    8000583e:	ffffd097          	auipc	ra,0xffffd
    80005842:	6d0080e7          	jalr	1744(ra) # 80002f0e <argstr>
    return -1;
    80005846:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005848:	10054a63          	bltz	a0,8000595c <sys_link+0x148>
    8000584c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000584e:	fffff097          	auipc	ra,0xfffff
    80005852:	c84080e7          	jalr	-892(ra) # 800044d2 <begin_op>
  if((ip = namei(old)) == 0){
    80005856:	ed040513          	addi	a0,s0,-304
    8000585a:	fffff097          	auipc	ra,0xfffff
    8000585e:	a78080e7          	jalr	-1416(ra) # 800042d2 <namei>
    80005862:	84aa                	mv	s1,a0
    80005864:	c949                	beqz	a0,800058f6 <sys_link+0xe2>
  ilock(ip);
    80005866:	ffffe097          	auipc	ra,0xffffe
    8000586a:	29e080e7          	jalr	670(ra) # 80003b04 <ilock>
  if(ip->type == T_DIR){
    8000586e:	04449703          	lh	a4,68(s1)
    80005872:	4785                	li	a5,1
    80005874:	08f70863          	beq	a4,a5,80005904 <sys_link+0xf0>
    80005878:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000587a:	04a4d783          	lhu	a5,74(s1)
    8000587e:	2785                	addiw	a5,a5,1
    80005880:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005884:	8526                	mv	a0,s1
    80005886:	ffffe097          	auipc	ra,0xffffe
    8000588a:	1b2080e7          	jalr	434(ra) # 80003a38 <iupdate>
  iunlock(ip);
    8000588e:	8526                	mv	a0,s1
    80005890:	ffffe097          	auipc	ra,0xffffe
    80005894:	33a080e7          	jalr	826(ra) # 80003bca <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005898:	fd040593          	addi	a1,s0,-48
    8000589c:	f5040513          	addi	a0,s0,-176
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	a50080e7          	jalr	-1456(ra) # 800042f0 <nameiparent>
    800058a8:	892a                	mv	s2,a0
    800058aa:	cd35                	beqz	a0,80005926 <sys_link+0x112>
  ilock(dp);
    800058ac:	ffffe097          	auipc	ra,0xffffe
    800058b0:	258080e7          	jalr	600(ra) # 80003b04 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800058b4:	00092703          	lw	a4,0(s2)
    800058b8:	409c                	lw	a5,0(s1)
    800058ba:	06f71163          	bne	a4,a5,8000591c <sys_link+0x108>
    800058be:	40d0                	lw	a2,4(s1)
    800058c0:	fd040593          	addi	a1,s0,-48
    800058c4:	854a                	mv	a0,s2
    800058c6:	fffff097          	auipc	ra,0xfffff
    800058ca:	95a080e7          	jalr	-1702(ra) # 80004220 <dirlink>
    800058ce:	04054763          	bltz	a0,8000591c <sys_link+0x108>
  iunlockput(dp);
    800058d2:	854a                	mv	a0,s2
    800058d4:	ffffe097          	auipc	ra,0xffffe
    800058d8:	496080e7          	jalr	1174(ra) # 80003d6a <iunlockput>
  iput(ip);
    800058dc:	8526                	mv	a0,s1
    800058de:	ffffe097          	auipc	ra,0xffffe
    800058e2:	3e4080e7          	jalr	996(ra) # 80003cc2 <iput>
  end_op();
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	c66080e7          	jalr	-922(ra) # 8000454c <end_op>
  return 0;
    800058ee:	4781                	li	a5,0
    800058f0:	64f2                	ld	s1,280(sp)
    800058f2:	6952                	ld	s2,272(sp)
    800058f4:	a0a5                	j	8000595c <sys_link+0x148>
    end_op();
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	c56080e7          	jalr	-938(ra) # 8000454c <end_op>
    return -1;
    800058fe:	57fd                	li	a5,-1
    80005900:	64f2                	ld	s1,280(sp)
    80005902:	a8a9                	j	8000595c <sys_link+0x148>
    iunlockput(ip);
    80005904:	8526                	mv	a0,s1
    80005906:	ffffe097          	auipc	ra,0xffffe
    8000590a:	464080e7          	jalr	1124(ra) # 80003d6a <iunlockput>
    end_op();
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	c3e080e7          	jalr	-962(ra) # 8000454c <end_op>
    return -1;
    80005916:	57fd                	li	a5,-1
    80005918:	64f2                	ld	s1,280(sp)
    8000591a:	a089                	j	8000595c <sys_link+0x148>
    iunlockput(dp);
    8000591c:	854a                	mv	a0,s2
    8000591e:	ffffe097          	auipc	ra,0xffffe
    80005922:	44c080e7          	jalr	1100(ra) # 80003d6a <iunlockput>
  ilock(ip);
    80005926:	8526                	mv	a0,s1
    80005928:	ffffe097          	auipc	ra,0xffffe
    8000592c:	1dc080e7          	jalr	476(ra) # 80003b04 <ilock>
  ip->nlink--;
    80005930:	04a4d783          	lhu	a5,74(s1)
    80005934:	37fd                	addiw	a5,a5,-1
    80005936:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000593a:	8526                	mv	a0,s1
    8000593c:	ffffe097          	auipc	ra,0xffffe
    80005940:	0fc080e7          	jalr	252(ra) # 80003a38 <iupdate>
  iunlockput(ip);
    80005944:	8526                	mv	a0,s1
    80005946:	ffffe097          	auipc	ra,0xffffe
    8000594a:	424080e7          	jalr	1060(ra) # 80003d6a <iunlockput>
  end_op();
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	bfe080e7          	jalr	-1026(ra) # 8000454c <end_op>
  return -1;
    80005956:	57fd                	li	a5,-1
    80005958:	64f2                	ld	s1,280(sp)
    8000595a:	6952                	ld	s2,272(sp)
}
    8000595c:	853e                	mv	a0,a5
    8000595e:	70b2                	ld	ra,296(sp)
    80005960:	7412                	ld	s0,288(sp)
    80005962:	6155                	addi	sp,sp,304
    80005964:	8082                	ret

0000000080005966 <sys_unlink>:
{
    80005966:	7151                	addi	sp,sp,-240
    80005968:	f586                	sd	ra,232(sp)
    8000596a:	f1a2                	sd	s0,224(sp)
    8000596c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000596e:	08000613          	li	a2,128
    80005972:	f3040593          	addi	a1,s0,-208
    80005976:	4501                	li	a0,0
    80005978:	ffffd097          	auipc	ra,0xffffd
    8000597c:	596080e7          	jalr	1430(ra) # 80002f0e <argstr>
    80005980:	1a054a63          	bltz	a0,80005b34 <sys_unlink+0x1ce>
    80005984:	eda6                	sd	s1,216(sp)
  begin_op();
    80005986:	fffff097          	auipc	ra,0xfffff
    8000598a:	b4c080e7          	jalr	-1204(ra) # 800044d2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000598e:	fb040593          	addi	a1,s0,-80
    80005992:	f3040513          	addi	a0,s0,-208
    80005996:	fffff097          	auipc	ra,0xfffff
    8000599a:	95a080e7          	jalr	-1702(ra) # 800042f0 <nameiparent>
    8000599e:	84aa                	mv	s1,a0
    800059a0:	cd71                	beqz	a0,80005a7c <sys_unlink+0x116>
  ilock(dp);
    800059a2:	ffffe097          	auipc	ra,0xffffe
    800059a6:	162080e7          	jalr	354(ra) # 80003b04 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800059aa:	00003597          	auipc	a1,0x3
    800059ae:	d1658593          	addi	a1,a1,-746 # 800086c0 <etext+0x6c0>
    800059b2:	fb040513          	addi	a0,s0,-80
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	640080e7          	jalr	1600(ra) # 80003ff6 <namecmp>
    800059be:	14050c63          	beqz	a0,80005b16 <sys_unlink+0x1b0>
    800059c2:	00003597          	auipc	a1,0x3
    800059c6:	d0658593          	addi	a1,a1,-762 # 800086c8 <etext+0x6c8>
    800059ca:	fb040513          	addi	a0,s0,-80
    800059ce:	ffffe097          	auipc	ra,0xffffe
    800059d2:	628080e7          	jalr	1576(ra) # 80003ff6 <namecmp>
    800059d6:	14050063          	beqz	a0,80005b16 <sys_unlink+0x1b0>
    800059da:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800059dc:	f2c40613          	addi	a2,s0,-212
    800059e0:	fb040593          	addi	a1,s0,-80
    800059e4:	8526                	mv	a0,s1
    800059e6:	ffffe097          	auipc	ra,0xffffe
    800059ea:	62a080e7          	jalr	1578(ra) # 80004010 <dirlookup>
    800059ee:	892a                	mv	s2,a0
    800059f0:	12050263          	beqz	a0,80005b14 <sys_unlink+0x1ae>
  ilock(ip);
    800059f4:	ffffe097          	auipc	ra,0xffffe
    800059f8:	110080e7          	jalr	272(ra) # 80003b04 <ilock>
  if(ip->nlink < 1)
    800059fc:	04a91783          	lh	a5,74(s2)
    80005a00:	08f05563          	blez	a5,80005a8a <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005a04:	04491703          	lh	a4,68(s2)
    80005a08:	4785                	li	a5,1
    80005a0a:	08f70963          	beq	a4,a5,80005a9c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005a0e:	4641                	li	a2,16
    80005a10:	4581                	li	a1,0
    80005a12:	fc040513          	addi	a0,s0,-64
    80005a16:	ffffb097          	auipc	ra,0xffffb
    80005a1a:	31e080e7          	jalr	798(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a1e:	4741                	li	a4,16
    80005a20:	f2c42683          	lw	a3,-212(s0)
    80005a24:	fc040613          	addi	a2,s0,-64
    80005a28:	4581                	li	a1,0
    80005a2a:	8526                	mv	a0,s1
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	4a0080e7          	jalr	1184(ra) # 80003ecc <writei>
    80005a34:	47c1                	li	a5,16
    80005a36:	0af51b63          	bne	a0,a5,80005aec <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005a3a:	04491703          	lh	a4,68(s2)
    80005a3e:	4785                	li	a5,1
    80005a40:	0af70f63          	beq	a4,a5,80005afe <sys_unlink+0x198>
  iunlockput(dp);
    80005a44:	8526                	mv	a0,s1
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	324080e7          	jalr	804(ra) # 80003d6a <iunlockput>
  ip->nlink--;
    80005a4e:	04a95783          	lhu	a5,74(s2)
    80005a52:	37fd                	addiw	a5,a5,-1
    80005a54:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a58:	854a                	mv	a0,s2
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	fde080e7          	jalr	-34(ra) # 80003a38 <iupdate>
  iunlockput(ip);
    80005a62:	854a                	mv	a0,s2
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	306080e7          	jalr	774(ra) # 80003d6a <iunlockput>
  end_op();
    80005a6c:	fffff097          	auipc	ra,0xfffff
    80005a70:	ae0080e7          	jalr	-1312(ra) # 8000454c <end_op>
  return 0;
    80005a74:	4501                	li	a0,0
    80005a76:	64ee                	ld	s1,216(sp)
    80005a78:	694e                	ld	s2,208(sp)
    80005a7a:	a84d                	j	80005b2c <sys_unlink+0x1c6>
    end_op();
    80005a7c:	fffff097          	auipc	ra,0xfffff
    80005a80:	ad0080e7          	jalr	-1328(ra) # 8000454c <end_op>
    return -1;
    80005a84:	557d                	li	a0,-1
    80005a86:	64ee                	ld	s1,216(sp)
    80005a88:	a055                	j	80005b2c <sys_unlink+0x1c6>
    80005a8a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005a8c:	00003517          	auipc	a0,0x3
    80005a90:	c4450513          	addi	a0,a0,-956 # 800086d0 <etext+0x6d0>
    80005a94:	ffffb097          	auipc	ra,0xffffb
    80005a98:	acc080e7          	jalr	-1332(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a9c:	04c92703          	lw	a4,76(s2)
    80005aa0:	02000793          	li	a5,32
    80005aa4:	f6e7f5e3          	bgeu	a5,a4,80005a0e <sys_unlink+0xa8>
    80005aa8:	e5ce                	sd	s3,200(sp)
    80005aaa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005aae:	4741                	li	a4,16
    80005ab0:	86ce                	mv	a3,s3
    80005ab2:	f1840613          	addi	a2,s0,-232
    80005ab6:	4581                	li	a1,0
    80005ab8:	854a                	mv	a0,s2
    80005aba:	ffffe097          	auipc	ra,0xffffe
    80005abe:	302080e7          	jalr	770(ra) # 80003dbc <readi>
    80005ac2:	47c1                	li	a5,16
    80005ac4:	00f51c63          	bne	a0,a5,80005adc <sys_unlink+0x176>
    if(de.inum != 0)
    80005ac8:	f1845783          	lhu	a5,-232(s0)
    80005acc:	e7b5                	bnez	a5,80005b38 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ace:	29c1                	addiw	s3,s3,16
    80005ad0:	04c92783          	lw	a5,76(s2)
    80005ad4:	fcf9ede3          	bltu	s3,a5,80005aae <sys_unlink+0x148>
    80005ad8:	69ae                	ld	s3,200(sp)
    80005ada:	bf15                	j	80005a0e <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005adc:	00003517          	auipc	a0,0x3
    80005ae0:	c0c50513          	addi	a0,a0,-1012 # 800086e8 <etext+0x6e8>
    80005ae4:	ffffb097          	auipc	ra,0xffffb
    80005ae8:	a7c080e7          	jalr	-1412(ra) # 80000560 <panic>
    80005aec:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005aee:	00003517          	auipc	a0,0x3
    80005af2:	c1250513          	addi	a0,a0,-1006 # 80008700 <etext+0x700>
    80005af6:	ffffb097          	auipc	ra,0xffffb
    80005afa:	a6a080e7          	jalr	-1430(ra) # 80000560 <panic>
    dp->nlink--;
    80005afe:	04a4d783          	lhu	a5,74(s1)
    80005b02:	37fd                	addiw	a5,a5,-1
    80005b04:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b08:	8526                	mv	a0,s1
    80005b0a:	ffffe097          	auipc	ra,0xffffe
    80005b0e:	f2e080e7          	jalr	-210(ra) # 80003a38 <iupdate>
    80005b12:	bf0d                	j	80005a44 <sys_unlink+0xde>
    80005b14:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005b16:	8526                	mv	a0,s1
    80005b18:	ffffe097          	auipc	ra,0xffffe
    80005b1c:	252080e7          	jalr	594(ra) # 80003d6a <iunlockput>
  end_op();
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	a2c080e7          	jalr	-1492(ra) # 8000454c <end_op>
  return -1;
    80005b28:	557d                	li	a0,-1
    80005b2a:	64ee                	ld	s1,216(sp)
}
    80005b2c:	70ae                	ld	ra,232(sp)
    80005b2e:	740e                	ld	s0,224(sp)
    80005b30:	616d                	addi	sp,sp,240
    80005b32:	8082                	ret
    return -1;
    80005b34:	557d                	li	a0,-1
    80005b36:	bfdd                	j	80005b2c <sys_unlink+0x1c6>
    iunlockput(ip);
    80005b38:	854a                	mv	a0,s2
    80005b3a:	ffffe097          	auipc	ra,0xffffe
    80005b3e:	230080e7          	jalr	560(ra) # 80003d6a <iunlockput>
    goto bad;
    80005b42:	694e                	ld	s2,208(sp)
    80005b44:	69ae                	ld	s3,200(sp)
    80005b46:	bfc1                	j	80005b16 <sys_unlink+0x1b0>

0000000080005b48 <sys_open>:

uint64
sys_open(void)
{
    80005b48:	7131                	addi	sp,sp,-192
    80005b4a:	fd06                	sd	ra,184(sp)
    80005b4c:	f922                	sd	s0,176(sp)
    80005b4e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005b50:	f4c40593          	addi	a1,s0,-180
    80005b54:	4505                	li	a0,1
    80005b56:	ffffd097          	auipc	ra,0xffffd
    80005b5a:	378080e7          	jalr	888(ra) # 80002ece <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b5e:	08000613          	li	a2,128
    80005b62:	f5040593          	addi	a1,s0,-176
    80005b66:	4501                	li	a0,0
    80005b68:	ffffd097          	auipc	ra,0xffffd
    80005b6c:	3a6080e7          	jalr	934(ra) # 80002f0e <argstr>
    80005b70:	87aa                	mv	a5,a0
    return -1;
    80005b72:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b74:	0a07ce63          	bltz	a5,80005c30 <sys_open+0xe8>
    80005b78:	f526                	sd	s1,168(sp)

  begin_op();
    80005b7a:	fffff097          	auipc	ra,0xfffff
    80005b7e:	958080e7          	jalr	-1704(ra) # 800044d2 <begin_op>

  if(omode & O_CREATE){
    80005b82:	f4c42783          	lw	a5,-180(s0)
    80005b86:	2007f793          	andi	a5,a5,512
    80005b8a:	cfd5                	beqz	a5,80005c46 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005b8c:	4681                	li	a3,0
    80005b8e:	4601                	li	a2,0
    80005b90:	4589                	li	a1,2
    80005b92:	f5040513          	addi	a0,s0,-176
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	95c080e7          	jalr	-1700(ra) # 800054f2 <create>
    80005b9e:	84aa                	mv	s1,a0
    if(ip == 0){
    80005ba0:	cd41                	beqz	a0,80005c38 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005ba2:	04449703          	lh	a4,68(s1)
    80005ba6:	478d                	li	a5,3
    80005ba8:	00f71763          	bne	a4,a5,80005bb6 <sys_open+0x6e>
    80005bac:	0464d703          	lhu	a4,70(s1)
    80005bb0:	47a5                	li	a5,9
    80005bb2:	0ee7e163          	bltu	a5,a4,80005c94 <sys_open+0x14c>
    80005bb6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005bb8:	fffff097          	auipc	ra,0xfffff
    80005bbc:	d28080e7          	jalr	-728(ra) # 800048e0 <filealloc>
    80005bc0:	892a                	mv	s2,a0
    80005bc2:	c97d                	beqz	a0,80005cb8 <sys_open+0x170>
    80005bc4:	ed4e                	sd	s3,152(sp)
    80005bc6:	00000097          	auipc	ra,0x0
    80005bca:	8ea080e7          	jalr	-1814(ra) # 800054b0 <fdalloc>
    80005bce:	89aa                	mv	s3,a0
    80005bd0:	0c054e63          	bltz	a0,80005cac <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005bd4:	04449703          	lh	a4,68(s1)
    80005bd8:	478d                	li	a5,3
    80005bda:	0ef70c63          	beq	a4,a5,80005cd2 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005bde:	4789                	li	a5,2
    80005be0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005be4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005be8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005bec:	f4c42783          	lw	a5,-180(s0)
    80005bf0:	0017c713          	xori	a4,a5,1
    80005bf4:	8b05                	andi	a4,a4,1
    80005bf6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005bfa:	0037f713          	andi	a4,a5,3
    80005bfe:	00e03733          	snez	a4,a4
    80005c02:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005c06:	4007f793          	andi	a5,a5,1024
    80005c0a:	c791                	beqz	a5,80005c16 <sys_open+0xce>
    80005c0c:	04449703          	lh	a4,68(s1)
    80005c10:	4789                	li	a5,2
    80005c12:	0cf70763          	beq	a4,a5,80005ce0 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005c16:	8526                	mv	a0,s1
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	fb2080e7          	jalr	-78(ra) # 80003bca <iunlock>
  end_op();
    80005c20:	fffff097          	auipc	ra,0xfffff
    80005c24:	92c080e7          	jalr	-1748(ra) # 8000454c <end_op>

  return fd;
    80005c28:	854e                	mv	a0,s3
    80005c2a:	74aa                	ld	s1,168(sp)
    80005c2c:	790a                	ld	s2,160(sp)
    80005c2e:	69ea                	ld	s3,152(sp)
}
    80005c30:	70ea                	ld	ra,184(sp)
    80005c32:	744a                	ld	s0,176(sp)
    80005c34:	6129                	addi	sp,sp,192
    80005c36:	8082                	ret
      end_op();
    80005c38:	fffff097          	auipc	ra,0xfffff
    80005c3c:	914080e7          	jalr	-1772(ra) # 8000454c <end_op>
      return -1;
    80005c40:	557d                	li	a0,-1
    80005c42:	74aa                	ld	s1,168(sp)
    80005c44:	b7f5                	j	80005c30 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005c46:	f5040513          	addi	a0,s0,-176
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	688080e7          	jalr	1672(ra) # 800042d2 <namei>
    80005c52:	84aa                	mv	s1,a0
    80005c54:	c90d                	beqz	a0,80005c86 <sys_open+0x13e>
    ilock(ip);
    80005c56:	ffffe097          	auipc	ra,0xffffe
    80005c5a:	eae080e7          	jalr	-338(ra) # 80003b04 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c5e:	04449703          	lh	a4,68(s1)
    80005c62:	4785                	li	a5,1
    80005c64:	f2f71fe3          	bne	a4,a5,80005ba2 <sys_open+0x5a>
    80005c68:	f4c42783          	lw	a5,-180(s0)
    80005c6c:	d7a9                	beqz	a5,80005bb6 <sys_open+0x6e>
      iunlockput(ip);
    80005c6e:	8526                	mv	a0,s1
    80005c70:	ffffe097          	auipc	ra,0xffffe
    80005c74:	0fa080e7          	jalr	250(ra) # 80003d6a <iunlockput>
      end_op();
    80005c78:	fffff097          	auipc	ra,0xfffff
    80005c7c:	8d4080e7          	jalr	-1836(ra) # 8000454c <end_op>
      return -1;
    80005c80:	557d                	li	a0,-1
    80005c82:	74aa                	ld	s1,168(sp)
    80005c84:	b775                	j	80005c30 <sys_open+0xe8>
      end_op();
    80005c86:	fffff097          	auipc	ra,0xfffff
    80005c8a:	8c6080e7          	jalr	-1850(ra) # 8000454c <end_op>
      return -1;
    80005c8e:	557d                	li	a0,-1
    80005c90:	74aa                	ld	s1,168(sp)
    80005c92:	bf79                	j	80005c30 <sys_open+0xe8>
    iunlockput(ip);
    80005c94:	8526                	mv	a0,s1
    80005c96:	ffffe097          	auipc	ra,0xffffe
    80005c9a:	0d4080e7          	jalr	212(ra) # 80003d6a <iunlockput>
    end_op();
    80005c9e:	fffff097          	auipc	ra,0xfffff
    80005ca2:	8ae080e7          	jalr	-1874(ra) # 8000454c <end_op>
    return -1;
    80005ca6:	557d                	li	a0,-1
    80005ca8:	74aa                	ld	s1,168(sp)
    80005caa:	b759                	j	80005c30 <sys_open+0xe8>
      fileclose(f);
    80005cac:	854a                	mv	a0,s2
    80005cae:	fffff097          	auipc	ra,0xfffff
    80005cb2:	cee080e7          	jalr	-786(ra) # 8000499c <fileclose>
    80005cb6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005cb8:	8526                	mv	a0,s1
    80005cba:	ffffe097          	auipc	ra,0xffffe
    80005cbe:	0b0080e7          	jalr	176(ra) # 80003d6a <iunlockput>
    end_op();
    80005cc2:	fffff097          	auipc	ra,0xfffff
    80005cc6:	88a080e7          	jalr	-1910(ra) # 8000454c <end_op>
    return -1;
    80005cca:	557d                	li	a0,-1
    80005ccc:	74aa                	ld	s1,168(sp)
    80005cce:	790a                	ld	s2,160(sp)
    80005cd0:	b785                	j	80005c30 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005cd2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005cd6:	04649783          	lh	a5,70(s1)
    80005cda:	02f91223          	sh	a5,36(s2)
    80005cde:	b729                	j	80005be8 <sys_open+0xa0>
    itrunc(ip);
    80005ce0:	8526                	mv	a0,s1
    80005ce2:	ffffe097          	auipc	ra,0xffffe
    80005ce6:	f34080e7          	jalr	-204(ra) # 80003c16 <itrunc>
    80005cea:	b735                	j	80005c16 <sys_open+0xce>

0000000080005cec <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005cec:	7175                	addi	sp,sp,-144
    80005cee:	e506                	sd	ra,136(sp)
    80005cf0:	e122                	sd	s0,128(sp)
    80005cf2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005cf4:	ffffe097          	auipc	ra,0xffffe
    80005cf8:	7de080e7          	jalr	2014(ra) # 800044d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005cfc:	08000613          	li	a2,128
    80005d00:	f7040593          	addi	a1,s0,-144
    80005d04:	4501                	li	a0,0
    80005d06:	ffffd097          	auipc	ra,0xffffd
    80005d0a:	208080e7          	jalr	520(ra) # 80002f0e <argstr>
    80005d0e:	02054963          	bltz	a0,80005d40 <sys_mkdir+0x54>
    80005d12:	4681                	li	a3,0
    80005d14:	4601                	li	a2,0
    80005d16:	4585                	li	a1,1
    80005d18:	f7040513          	addi	a0,s0,-144
    80005d1c:	fffff097          	auipc	ra,0xfffff
    80005d20:	7d6080e7          	jalr	2006(ra) # 800054f2 <create>
    80005d24:	cd11                	beqz	a0,80005d40 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d26:	ffffe097          	auipc	ra,0xffffe
    80005d2a:	044080e7          	jalr	68(ra) # 80003d6a <iunlockput>
  end_op();
    80005d2e:	fffff097          	auipc	ra,0xfffff
    80005d32:	81e080e7          	jalr	-2018(ra) # 8000454c <end_op>
  return 0;
    80005d36:	4501                	li	a0,0
}
    80005d38:	60aa                	ld	ra,136(sp)
    80005d3a:	640a                	ld	s0,128(sp)
    80005d3c:	6149                	addi	sp,sp,144
    80005d3e:	8082                	ret
    end_op();
    80005d40:	fffff097          	auipc	ra,0xfffff
    80005d44:	80c080e7          	jalr	-2036(ra) # 8000454c <end_op>
    return -1;
    80005d48:	557d                	li	a0,-1
    80005d4a:	b7fd                	j	80005d38 <sys_mkdir+0x4c>

0000000080005d4c <sys_mknod>:

uint64
sys_mknod(void)
{
    80005d4c:	7135                	addi	sp,sp,-160
    80005d4e:	ed06                	sd	ra,152(sp)
    80005d50:	e922                	sd	s0,144(sp)
    80005d52:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d54:	ffffe097          	auipc	ra,0xffffe
    80005d58:	77e080e7          	jalr	1918(ra) # 800044d2 <begin_op>
  argint(1, &major);
    80005d5c:	f6c40593          	addi	a1,s0,-148
    80005d60:	4505                	li	a0,1
    80005d62:	ffffd097          	auipc	ra,0xffffd
    80005d66:	16c080e7          	jalr	364(ra) # 80002ece <argint>
  argint(2, &minor);
    80005d6a:	f6840593          	addi	a1,s0,-152
    80005d6e:	4509                	li	a0,2
    80005d70:	ffffd097          	auipc	ra,0xffffd
    80005d74:	15e080e7          	jalr	350(ra) # 80002ece <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d78:	08000613          	li	a2,128
    80005d7c:	f7040593          	addi	a1,s0,-144
    80005d80:	4501                	li	a0,0
    80005d82:	ffffd097          	auipc	ra,0xffffd
    80005d86:	18c080e7          	jalr	396(ra) # 80002f0e <argstr>
    80005d8a:	02054b63          	bltz	a0,80005dc0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d8e:	f6841683          	lh	a3,-152(s0)
    80005d92:	f6c41603          	lh	a2,-148(s0)
    80005d96:	458d                	li	a1,3
    80005d98:	f7040513          	addi	a0,s0,-144
    80005d9c:	fffff097          	auipc	ra,0xfffff
    80005da0:	756080e7          	jalr	1878(ra) # 800054f2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005da4:	cd11                	beqz	a0,80005dc0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005da6:	ffffe097          	auipc	ra,0xffffe
    80005daa:	fc4080e7          	jalr	-60(ra) # 80003d6a <iunlockput>
  end_op();
    80005dae:	ffffe097          	auipc	ra,0xffffe
    80005db2:	79e080e7          	jalr	1950(ra) # 8000454c <end_op>
  return 0;
    80005db6:	4501                	li	a0,0
}
    80005db8:	60ea                	ld	ra,152(sp)
    80005dba:	644a                	ld	s0,144(sp)
    80005dbc:	610d                	addi	sp,sp,160
    80005dbe:	8082                	ret
    end_op();
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	78c080e7          	jalr	1932(ra) # 8000454c <end_op>
    return -1;
    80005dc8:	557d                	li	a0,-1
    80005dca:	b7fd                	j	80005db8 <sys_mknod+0x6c>

0000000080005dcc <sys_chdir>:

uint64
sys_chdir(void)
{
    80005dcc:	7135                	addi	sp,sp,-160
    80005dce:	ed06                	sd	ra,152(sp)
    80005dd0:	e922                	sd	s0,144(sp)
    80005dd2:	e14a                	sd	s2,128(sp)
    80005dd4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005dd6:	ffffc097          	auipc	ra,0xffffc
    80005dda:	d60080e7          	jalr	-672(ra) # 80001b36 <myproc>
    80005dde:	892a                	mv	s2,a0
  
  begin_op();
    80005de0:	ffffe097          	auipc	ra,0xffffe
    80005de4:	6f2080e7          	jalr	1778(ra) # 800044d2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005de8:	08000613          	li	a2,128
    80005dec:	f6040593          	addi	a1,s0,-160
    80005df0:	4501                	li	a0,0
    80005df2:	ffffd097          	auipc	ra,0xffffd
    80005df6:	11c080e7          	jalr	284(ra) # 80002f0e <argstr>
    80005dfa:	04054d63          	bltz	a0,80005e54 <sys_chdir+0x88>
    80005dfe:	e526                	sd	s1,136(sp)
    80005e00:	f6040513          	addi	a0,s0,-160
    80005e04:	ffffe097          	auipc	ra,0xffffe
    80005e08:	4ce080e7          	jalr	1230(ra) # 800042d2 <namei>
    80005e0c:	84aa                	mv	s1,a0
    80005e0e:	c131                	beqz	a0,80005e52 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005e10:	ffffe097          	auipc	ra,0xffffe
    80005e14:	cf4080e7          	jalr	-780(ra) # 80003b04 <ilock>
  if(ip->type != T_DIR){
    80005e18:	04449703          	lh	a4,68(s1)
    80005e1c:	4785                	li	a5,1
    80005e1e:	04f71163          	bne	a4,a5,80005e60 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005e22:	8526                	mv	a0,s1
    80005e24:	ffffe097          	auipc	ra,0xffffe
    80005e28:	da6080e7          	jalr	-602(ra) # 80003bca <iunlock>
  iput(p->cwd);
    80005e2c:	15093503          	ld	a0,336(s2)
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	e92080e7          	jalr	-366(ra) # 80003cc2 <iput>
  end_op();
    80005e38:	ffffe097          	auipc	ra,0xffffe
    80005e3c:	714080e7          	jalr	1812(ra) # 8000454c <end_op>
  p->cwd = ip;
    80005e40:	14993823          	sd	s1,336(s2)
  return 0;
    80005e44:	4501                	li	a0,0
    80005e46:	64aa                	ld	s1,136(sp)
}
    80005e48:	60ea                	ld	ra,152(sp)
    80005e4a:	644a                	ld	s0,144(sp)
    80005e4c:	690a                	ld	s2,128(sp)
    80005e4e:	610d                	addi	sp,sp,160
    80005e50:	8082                	ret
    80005e52:	64aa                	ld	s1,136(sp)
    end_op();
    80005e54:	ffffe097          	auipc	ra,0xffffe
    80005e58:	6f8080e7          	jalr	1784(ra) # 8000454c <end_op>
    return -1;
    80005e5c:	557d                	li	a0,-1
    80005e5e:	b7ed                	j	80005e48 <sys_chdir+0x7c>
    iunlockput(ip);
    80005e60:	8526                	mv	a0,s1
    80005e62:	ffffe097          	auipc	ra,0xffffe
    80005e66:	f08080e7          	jalr	-248(ra) # 80003d6a <iunlockput>
    end_op();
    80005e6a:	ffffe097          	auipc	ra,0xffffe
    80005e6e:	6e2080e7          	jalr	1762(ra) # 8000454c <end_op>
    return -1;
    80005e72:	557d                	li	a0,-1
    80005e74:	64aa                	ld	s1,136(sp)
    80005e76:	bfc9                	j	80005e48 <sys_chdir+0x7c>

0000000080005e78 <sys_exec>:

uint64
sys_exec(void)
{
    80005e78:	7121                	addi	sp,sp,-448
    80005e7a:	ff06                	sd	ra,440(sp)
    80005e7c:	fb22                	sd	s0,432(sp)
    80005e7e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005e80:	e4840593          	addi	a1,s0,-440
    80005e84:	4505                	li	a0,1
    80005e86:	ffffd097          	auipc	ra,0xffffd
    80005e8a:	068080e7          	jalr	104(ra) # 80002eee <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005e8e:	08000613          	li	a2,128
    80005e92:	f5040593          	addi	a1,s0,-176
    80005e96:	4501                	li	a0,0
    80005e98:	ffffd097          	auipc	ra,0xffffd
    80005e9c:	076080e7          	jalr	118(ra) # 80002f0e <argstr>
    80005ea0:	87aa                	mv	a5,a0
    return -1;
    80005ea2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ea4:	0e07c263          	bltz	a5,80005f88 <sys_exec+0x110>
    80005ea8:	f726                	sd	s1,424(sp)
    80005eaa:	f34a                	sd	s2,416(sp)
    80005eac:	ef4e                	sd	s3,408(sp)
    80005eae:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005eb0:	10000613          	li	a2,256
    80005eb4:	4581                	li	a1,0
    80005eb6:	e5040513          	addi	a0,s0,-432
    80005eba:	ffffb097          	auipc	ra,0xffffb
    80005ebe:	e7a080e7          	jalr	-390(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ec2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005ec6:	89a6                	mv	s3,s1
    80005ec8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005eca:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ece:	00391513          	slli	a0,s2,0x3
    80005ed2:	e4040593          	addi	a1,s0,-448
    80005ed6:	e4843783          	ld	a5,-440(s0)
    80005eda:	953e                	add	a0,a0,a5
    80005edc:	ffffd097          	auipc	ra,0xffffd
    80005ee0:	f54080e7          	jalr	-172(ra) # 80002e30 <fetchaddr>
    80005ee4:	02054a63          	bltz	a0,80005f18 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005ee8:	e4043783          	ld	a5,-448(s0)
    80005eec:	c7b9                	beqz	a5,80005f3a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005eee:	ffffb097          	auipc	ra,0xffffb
    80005ef2:	c5a080e7          	jalr	-934(ra) # 80000b48 <kalloc>
    80005ef6:	85aa                	mv	a1,a0
    80005ef8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005efc:	cd11                	beqz	a0,80005f18 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005efe:	6605                	lui	a2,0x1
    80005f00:	e4043503          	ld	a0,-448(s0)
    80005f04:	ffffd097          	auipc	ra,0xffffd
    80005f08:	f7e080e7          	jalr	-130(ra) # 80002e82 <fetchstr>
    80005f0c:	00054663          	bltz	a0,80005f18 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005f10:	0905                	addi	s2,s2,1
    80005f12:	09a1                	addi	s3,s3,8
    80005f14:	fb491de3          	bne	s2,s4,80005ece <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f18:	f5040913          	addi	s2,s0,-176
    80005f1c:	6088                	ld	a0,0(s1)
    80005f1e:	c125                	beqz	a0,80005f7e <sys_exec+0x106>
    kfree(argv[i]);
    80005f20:	ffffb097          	auipc	ra,0xffffb
    80005f24:	b2a080e7          	jalr	-1238(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f28:	04a1                	addi	s1,s1,8
    80005f2a:	ff2499e3          	bne	s1,s2,80005f1c <sys_exec+0xa4>
  return -1;
    80005f2e:	557d                	li	a0,-1
    80005f30:	74ba                	ld	s1,424(sp)
    80005f32:	791a                	ld	s2,416(sp)
    80005f34:	69fa                	ld	s3,408(sp)
    80005f36:	6a5a                	ld	s4,400(sp)
    80005f38:	a881                	j	80005f88 <sys_exec+0x110>
      argv[i] = 0;
    80005f3a:	0009079b          	sext.w	a5,s2
    80005f3e:	078e                	slli	a5,a5,0x3
    80005f40:	fd078793          	addi	a5,a5,-48
    80005f44:	97a2                	add	a5,a5,s0
    80005f46:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005f4a:	e5040593          	addi	a1,s0,-432
    80005f4e:	f5040513          	addi	a0,s0,-176
    80005f52:	fffff097          	auipc	ra,0xfffff
    80005f56:	120080e7          	jalr	288(ra) # 80005072 <exec>
    80005f5a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f5c:	f5040993          	addi	s3,s0,-176
    80005f60:	6088                	ld	a0,0(s1)
    80005f62:	c901                	beqz	a0,80005f72 <sys_exec+0xfa>
    kfree(argv[i]);
    80005f64:	ffffb097          	auipc	ra,0xffffb
    80005f68:	ae6080e7          	jalr	-1306(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005f6c:	04a1                	addi	s1,s1,8
    80005f6e:	ff3499e3          	bne	s1,s3,80005f60 <sys_exec+0xe8>
  return ret;
    80005f72:	854a                	mv	a0,s2
    80005f74:	74ba                	ld	s1,424(sp)
    80005f76:	791a                	ld	s2,416(sp)
    80005f78:	69fa                	ld	s3,408(sp)
    80005f7a:	6a5a                	ld	s4,400(sp)
    80005f7c:	a031                	j	80005f88 <sys_exec+0x110>
  return -1;
    80005f7e:	557d                	li	a0,-1
    80005f80:	74ba                	ld	s1,424(sp)
    80005f82:	791a                	ld	s2,416(sp)
    80005f84:	69fa                	ld	s3,408(sp)
    80005f86:	6a5a                	ld	s4,400(sp)
}
    80005f88:	70fa                	ld	ra,440(sp)
    80005f8a:	745a                	ld	s0,432(sp)
    80005f8c:	6139                	addi	sp,sp,448
    80005f8e:	8082                	ret

0000000080005f90 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f90:	7139                	addi	sp,sp,-64
    80005f92:	fc06                	sd	ra,56(sp)
    80005f94:	f822                	sd	s0,48(sp)
    80005f96:	f426                	sd	s1,40(sp)
    80005f98:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005f9a:	ffffc097          	auipc	ra,0xffffc
    80005f9e:	b9c080e7          	jalr	-1124(ra) # 80001b36 <myproc>
    80005fa2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005fa4:	fd840593          	addi	a1,s0,-40
    80005fa8:	4501                	li	a0,0
    80005faa:	ffffd097          	auipc	ra,0xffffd
    80005fae:	f44080e7          	jalr	-188(ra) # 80002eee <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005fb2:	fc840593          	addi	a1,s0,-56
    80005fb6:	fd040513          	addi	a0,s0,-48
    80005fba:	fffff097          	auipc	ra,0xfffff
    80005fbe:	d50080e7          	jalr	-688(ra) # 80004d0a <pipealloc>
    return -1;
    80005fc2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005fc4:	0c054463          	bltz	a0,8000608c <sys_pipe+0xfc>
  fd0 = -1;
    80005fc8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005fcc:	fd043503          	ld	a0,-48(s0)
    80005fd0:	fffff097          	auipc	ra,0xfffff
    80005fd4:	4e0080e7          	jalr	1248(ra) # 800054b0 <fdalloc>
    80005fd8:	fca42223          	sw	a0,-60(s0)
    80005fdc:	08054b63          	bltz	a0,80006072 <sys_pipe+0xe2>
    80005fe0:	fc843503          	ld	a0,-56(s0)
    80005fe4:	fffff097          	auipc	ra,0xfffff
    80005fe8:	4cc080e7          	jalr	1228(ra) # 800054b0 <fdalloc>
    80005fec:	fca42023          	sw	a0,-64(s0)
    80005ff0:	06054863          	bltz	a0,80006060 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ff4:	4691                	li	a3,4
    80005ff6:	fc440613          	addi	a2,s0,-60
    80005ffa:	fd843583          	ld	a1,-40(s0)
    80005ffe:	68a8                	ld	a0,80(s1)
    80006000:	ffffb097          	auipc	ra,0xffffb
    80006004:	6e2080e7          	jalr	1762(ra) # 800016e2 <copyout>
    80006008:	02054063          	bltz	a0,80006028 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000600c:	4691                	li	a3,4
    8000600e:	fc040613          	addi	a2,s0,-64
    80006012:	fd843583          	ld	a1,-40(s0)
    80006016:	0591                	addi	a1,a1,4
    80006018:	68a8                	ld	a0,80(s1)
    8000601a:	ffffb097          	auipc	ra,0xffffb
    8000601e:	6c8080e7          	jalr	1736(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006022:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006024:	06055463          	bgez	a0,8000608c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006028:	fc442783          	lw	a5,-60(s0)
    8000602c:	07e9                	addi	a5,a5,26
    8000602e:	078e                	slli	a5,a5,0x3
    80006030:	97a6                	add	a5,a5,s1
    80006032:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006036:	fc042783          	lw	a5,-64(s0)
    8000603a:	07e9                	addi	a5,a5,26
    8000603c:	078e                	slli	a5,a5,0x3
    8000603e:	94be                	add	s1,s1,a5
    80006040:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006044:	fd043503          	ld	a0,-48(s0)
    80006048:	fffff097          	auipc	ra,0xfffff
    8000604c:	954080e7          	jalr	-1708(ra) # 8000499c <fileclose>
    fileclose(wf);
    80006050:	fc843503          	ld	a0,-56(s0)
    80006054:	fffff097          	auipc	ra,0xfffff
    80006058:	948080e7          	jalr	-1720(ra) # 8000499c <fileclose>
    return -1;
    8000605c:	57fd                	li	a5,-1
    8000605e:	a03d                	j	8000608c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006060:	fc442783          	lw	a5,-60(s0)
    80006064:	0007c763          	bltz	a5,80006072 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006068:	07e9                	addi	a5,a5,26
    8000606a:	078e                	slli	a5,a5,0x3
    8000606c:	97a6                	add	a5,a5,s1
    8000606e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006072:	fd043503          	ld	a0,-48(s0)
    80006076:	fffff097          	auipc	ra,0xfffff
    8000607a:	926080e7          	jalr	-1754(ra) # 8000499c <fileclose>
    fileclose(wf);
    8000607e:	fc843503          	ld	a0,-56(s0)
    80006082:	fffff097          	auipc	ra,0xfffff
    80006086:	91a080e7          	jalr	-1766(ra) # 8000499c <fileclose>
    return -1;
    8000608a:	57fd                	li	a5,-1
}
    8000608c:	853e                	mv	a0,a5
    8000608e:	70e2                	ld	ra,56(sp)
    80006090:	7442                	ld	s0,48(sp)
    80006092:	74a2                	ld	s1,40(sp)
    80006094:	6121                	addi	sp,sp,64
    80006096:	8082                	ret
	...

00000000800060a0 <kernelvec>:
    800060a0:	7111                	addi	sp,sp,-256
    800060a2:	e006                	sd	ra,0(sp)
    800060a4:	e40a                	sd	sp,8(sp)
    800060a6:	e80e                	sd	gp,16(sp)
    800060a8:	ec12                	sd	tp,24(sp)
    800060aa:	f016                	sd	t0,32(sp)
    800060ac:	f41a                	sd	t1,40(sp)
    800060ae:	f81e                	sd	t2,48(sp)
    800060b0:	fc22                	sd	s0,56(sp)
    800060b2:	e0a6                	sd	s1,64(sp)
    800060b4:	e4aa                	sd	a0,72(sp)
    800060b6:	e8ae                	sd	a1,80(sp)
    800060b8:	ecb2                	sd	a2,88(sp)
    800060ba:	f0b6                	sd	a3,96(sp)
    800060bc:	f4ba                	sd	a4,104(sp)
    800060be:	f8be                	sd	a5,112(sp)
    800060c0:	fcc2                	sd	a6,120(sp)
    800060c2:	e146                	sd	a7,128(sp)
    800060c4:	e54a                	sd	s2,136(sp)
    800060c6:	e94e                	sd	s3,144(sp)
    800060c8:	ed52                	sd	s4,152(sp)
    800060ca:	f156                	sd	s5,160(sp)
    800060cc:	f55a                	sd	s6,168(sp)
    800060ce:	f95e                	sd	s7,176(sp)
    800060d0:	fd62                	sd	s8,184(sp)
    800060d2:	e1e6                	sd	s9,192(sp)
    800060d4:	e5ea                	sd	s10,200(sp)
    800060d6:	e9ee                	sd	s11,208(sp)
    800060d8:	edf2                	sd	t3,216(sp)
    800060da:	f1f6                	sd	t4,224(sp)
    800060dc:	f5fa                	sd	t5,232(sp)
    800060de:	f9fe                	sd	t6,240(sp)
    800060e0:	c1bfc0ef          	jal	80002cfa <kerneltrap>
    800060e4:	6082                	ld	ra,0(sp)
    800060e6:	6122                	ld	sp,8(sp)
    800060e8:	61c2                	ld	gp,16(sp)
    800060ea:	7282                	ld	t0,32(sp)
    800060ec:	7322                	ld	t1,40(sp)
    800060ee:	73c2                	ld	t2,48(sp)
    800060f0:	7462                	ld	s0,56(sp)
    800060f2:	6486                	ld	s1,64(sp)
    800060f4:	6526                	ld	a0,72(sp)
    800060f6:	65c6                	ld	a1,80(sp)
    800060f8:	6666                	ld	a2,88(sp)
    800060fa:	7686                	ld	a3,96(sp)
    800060fc:	7726                	ld	a4,104(sp)
    800060fe:	77c6                	ld	a5,112(sp)
    80006100:	7866                	ld	a6,120(sp)
    80006102:	688a                	ld	a7,128(sp)
    80006104:	692a                	ld	s2,136(sp)
    80006106:	69ca                	ld	s3,144(sp)
    80006108:	6a6a                	ld	s4,152(sp)
    8000610a:	7a8a                	ld	s5,160(sp)
    8000610c:	7b2a                	ld	s6,168(sp)
    8000610e:	7bca                	ld	s7,176(sp)
    80006110:	7c6a                	ld	s8,184(sp)
    80006112:	6c8e                	ld	s9,192(sp)
    80006114:	6d2e                	ld	s10,200(sp)
    80006116:	6dce                	ld	s11,208(sp)
    80006118:	6e6e                	ld	t3,216(sp)
    8000611a:	7e8e                	ld	t4,224(sp)
    8000611c:	7f2e                	ld	t5,232(sp)
    8000611e:	7fce                	ld	t6,240(sp)
    80006120:	6111                	addi	sp,sp,256
    80006122:	10200073          	sret
    80006126:	00000013          	nop
    8000612a:	00000013          	nop
    8000612e:	0001                	nop

0000000080006130 <timervec>:
    80006130:	34051573          	csrrw	a0,mscratch,a0
    80006134:	e10c                	sd	a1,0(a0)
    80006136:	e510                	sd	a2,8(a0)
    80006138:	e914                	sd	a3,16(a0)
    8000613a:	6d0c                	ld	a1,24(a0)
    8000613c:	7110                	ld	a2,32(a0)
    8000613e:	6194                	ld	a3,0(a1)
    80006140:	96b2                	add	a3,a3,a2
    80006142:	e194                	sd	a3,0(a1)
    80006144:	4589                	li	a1,2
    80006146:	14459073          	csrw	sip,a1
    8000614a:	6914                	ld	a3,16(a0)
    8000614c:	6510                	ld	a2,8(a0)
    8000614e:	610c                	ld	a1,0(a0)
    80006150:	34051573          	csrrw	a0,mscratch,a0
    80006154:	30200073          	mret
	...

000000008000615a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000615a:	1141                	addi	sp,sp,-16
    8000615c:	e422                	sd	s0,8(sp)
    8000615e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006160:	0c0007b7          	lui	a5,0xc000
    80006164:	4705                	li	a4,1
    80006166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006168:	0c0007b7          	lui	a5,0xc000
    8000616c:	c3d8                	sw	a4,4(a5)
}
    8000616e:	6422                	ld	s0,8(sp)
    80006170:	0141                	addi	sp,sp,16
    80006172:	8082                	ret

0000000080006174 <plicinithart>:

void
plicinithart(void)
{
    80006174:	1141                	addi	sp,sp,-16
    80006176:	e406                	sd	ra,8(sp)
    80006178:	e022                	sd	s0,0(sp)
    8000617a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000617c:	ffffc097          	auipc	ra,0xffffc
    80006180:	98e080e7          	jalr	-1650(ra) # 80001b0a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006184:	0085171b          	slliw	a4,a0,0x8
    80006188:	0c0027b7          	lui	a5,0xc002
    8000618c:	97ba                	add	a5,a5,a4
    8000618e:	40200713          	li	a4,1026
    80006192:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006196:	00d5151b          	slliw	a0,a0,0xd
    8000619a:	0c2017b7          	lui	a5,0xc201
    8000619e:	97aa                	add	a5,a5,a0
    800061a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800061a4:	60a2                	ld	ra,8(sp)
    800061a6:	6402                	ld	s0,0(sp)
    800061a8:	0141                	addi	sp,sp,16
    800061aa:	8082                	ret

00000000800061ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800061ac:	1141                	addi	sp,sp,-16
    800061ae:	e406                	sd	ra,8(sp)
    800061b0:	e022                	sd	s0,0(sp)
    800061b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800061b4:	ffffc097          	auipc	ra,0xffffc
    800061b8:	956080e7          	jalr	-1706(ra) # 80001b0a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800061bc:	00d5151b          	slliw	a0,a0,0xd
    800061c0:	0c2017b7          	lui	a5,0xc201
    800061c4:	97aa                	add	a5,a5,a0
  return irq;
}
    800061c6:	43c8                	lw	a0,4(a5)
    800061c8:	60a2                	ld	ra,8(sp)
    800061ca:	6402                	ld	s0,0(sp)
    800061cc:	0141                	addi	sp,sp,16
    800061ce:	8082                	ret

00000000800061d0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800061d0:	1101                	addi	sp,sp,-32
    800061d2:	ec06                	sd	ra,24(sp)
    800061d4:	e822                	sd	s0,16(sp)
    800061d6:	e426                	sd	s1,8(sp)
    800061d8:	1000                	addi	s0,sp,32
    800061da:	84aa                	mv	s1,a0
  int hart = cpuid();
    800061dc:	ffffc097          	auipc	ra,0xffffc
    800061e0:	92e080e7          	jalr	-1746(ra) # 80001b0a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800061e4:	00d5151b          	slliw	a0,a0,0xd
    800061e8:	0c2017b7          	lui	a5,0xc201
    800061ec:	97aa                	add	a5,a5,a0
    800061ee:	c3c4                	sw	s1,4(a5)
}
    800061f0:	60e2                	ld	ra,24(sp)
    800061f2:	6442                	ld	s0,16(sp)
    800061f4:	64a2                	ld	s1,8(sp)
    800061f6:	6105                	addi	sp,sp,32
    800061f8:	8082                	ret

00000000800061fa <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800061fa:	1141                	addi	sp,sp,-16
    800061fc:	e406                	sd	ra,8(sp)
    800061fe:	e022                	sd	s0,0(sp)
    80006200:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006202:	479d                	li	a5,7
    80006204:	04a7cc63          	blt	a5,a0,8000625c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006208:	0001e797          	auipc	a5,0x1e
    8000620c:	5e878793          	addi	a5,a5,1512 # 800247f0 <disk>
    80006210:	97aa                	add	a5,a5,a0
    80006212:	0187c783          	lbu	a5,24(a5)
    80006216:	ebb9                	bnez	a5,8000626c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006218:	00451693          	slli	a3,a0,0x4
    8000621c:	0001e797          	auipc	a5,0x1e
    80006220:	5d478793          	addi	a5,a5,1492 # 800247f0 <disk>
    80006224:	6398                	ld	a4,0(a5)
    80006226:	9736                	add	a4,a4,a3
    80006228:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000622c:	6398                	ld	a4,0(a5)
    8000622e:	9736                	add	a4,a4,a3
    80006230:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006234:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006238:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000623c:	97aa                	add	a5,a5,a0
    8000623e:	4705                	li	a4,1
    80006240:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006244:	0001e517          	auipc	a0,0x1e
    80006248:	5c450513          	addi	a0,a0,1476 # 80024808 <disk+0x18>
    8000624c:	ffffc097          	auipc	ra,0xffffc
    80006250:	126080e7          	jalr	294(ra) # 80002372 <wakeup>
}
    80006254:	60a2                	ld	ra,8(sp)
    80006256:	6402                	ld	s0,0(sp)
    80006258:	0141                	addi	sp,sp,16
    8000625a:	8082                	ret
    panic("free_desc 1");
    8000625c:	00002517          	auipc	a0,0x2
    80006260:	4b450513          	addi	a0,a0,1204 # 80008710 <etext+0x710>
    80006264:	ffffa097          	auipc	ra,0xffffa
    80006268:	2fc080e7          	jalr	764(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000626c:	00002517          	auipc	a0,0x2
    80006270:	4b450513          	addi	a0,a0,1204 # 80008720 <etext+0x720>
    80006274:	ffffa097          	auipc	ra,0xffffa
    80006278:	2ec080e7          	jalr	748(ra) # 80000560 <panic>

000000008000627c <virtio_disk_init>:
{
    8000627c:	1101                	addi	sp,sp,-32
    8000627e:	ec06                	sd	ra,24(sp)
    80006280:	e822                	sd	s0,16(sp)
    80006282:	e426                	sd	s1,8(sp)
    80006284:	e04a                	sd	s2,0(sp)
    80006286:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006288:	00002597          	auipc	a1,0x2
    8000628c:	4a858593          	addi	a1,a1,1192 # 80008730 <etext+0x730>
    80006290:	0001e517          	auipc	a0,0x1e
    80006294:	68850513          	addi	a0,a0,1672 # 80024918 <disk+0x128>
    80006298:	ffffb097          	auipc	ra,0xffffb
    8000629c:	910080e7          	jalr	-1776(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062a0:	100017b7          	lui	a5,0x10001
    800062a4:	4398                	lw	a4,0(a5)
    800062a6:	2701                	sext.w	a4,a4
    800062a8:	747277b7          	lui	a5,0x74727
    800062ac:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800062b0:	18f71c63          	bne	a4,a5,80006448 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800062b4:	100017b7          	lui	a5,0x10001
    800062b8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800062ba:	439c                	lw	a5,0(a5)
    800062bc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800062be:	4709                	li	a4,2
    800062c0:	18e79463          	bne	a5,a4,80006448 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062c4:	100017b7          	lui	a5,0x10001
    800062c8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800062ca:	439c                	lw	a5,0(a5)
    800062cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800062ce:	16e79d63          	bne	a5,a4,80006448 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800062d2:	100017b7          	lui	a5,0x10001
    800062d6:	47d8                	lw	a4,12(a5)
    800062d8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800062da:	554d47b7          	lui	a5,0x554d4
    800062de:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800062e2:	16f71363          	bne	a4,a5,80006448 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062e6:	100017b7          	lui	a5,0x10001
    800062ea:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800062ee:	4705                	li	a4,1
    800062f0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800062f2:	470d                	li	a4,3
    800062f4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800062f6:	10001737          	lui	a4,0x10001
    800062fa:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800062fc:	c7ffe737          	lui	a4,0xc7ffe
    80006300:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9e2f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006304:	8ef9                	and	a3,a3,a4
    80006306:	10001737          	lui	a4,0x10001
    8000630a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000630c:	472d                	li	a4,11
    8000630e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006310:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006314:	439c                	lw	a5,0(a5)
    80006316:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000631a:	8ba1                	andi	a5,a5,8
    8000631c:	12078e63          	beqz	a5,80006458 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006320:	100017b7          	lui	a5,0x10001
    80006324:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006328:	100017b7          	lui	a5,0x10001
    8000632c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006330:	439c                	lw	a5,0(a5)
    80006332:	2781                	sext.w	a5,a5
    80006334:	12079a63          	bnez	a5,80006468 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006338:	100017b7          	lui	a5,0x10001
    8000633c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006340:	439c                	lw	a5,0(a5)
    80006342:	2781                	sext.w	a5,a5
  if(max == 0)
    80006344:	12078a63          	beqz	a5,80006478 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006348:	471d                	li	a4,7
    8000634a:	12f77f63          	bgeu	a4,a5,80006488 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000634e:	ffffa097          	auipc	ra,0xffffa
    80006352:	7fa080e7          	jalr	2042(ra) # 80000b48 <kalloc>
    80006356:	0001e497          	auipc	s1,0x1e
    8000635a:	49a48493          	addi	s1,s1,1178 # 800247f0 <disk>
    8000635e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006360:	ffffa097          	auipc	ra,0xffffa
    80006364:	7e8080e7          	jalr	2024(ra) # 80000b48 <kalloc>
    80006368:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000636a:	ffffa097          	auipc	ra,0xffffa
    8000636e:	7de080e7          	jalr	2014(ra) # 80000b48 <kalloc>
    80006372:	87aa                	mv	a5,a0
    80006374:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006376:	6088                	ld	a0,0(s1)
    80006378:	12050063          	beqz	a0,80006498 <virtio_disk_init+0x21c>
    8000637c:	0001e717          	auipc	a4,0x1e
    80006380:	47c73703          	ld	a4,1148(a4) # 800247f8 <disk+0x8>
    80006384:	10070a63          	beqz	a4,80006498 <virtio_disk_init+0x21c>
    80006388:	10078863          	beqz	a5,80006498 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000638c:	6605                	lui	a2,0x1
    8000638e:	4581                	li	a1,0
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	9a4080e7          	jalr	-1628(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006398:	0001e497          	auipc	s1,0x1e
    8000639c:	45848493          	addi	s1,s1,1112 # 800247f0 <disk>
    800063a0:	6605                	lui	a2,0x1
    800063a2:	4581                	li	a1,0
    800063a4:	6488                	ld	a0,8(s1)
    800063a6:	ffffb097          	auipc	ra,0xffffb
    800063aa:	98e080e7          	jalr	-1650(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    800063ae:	6605                	lui	a2,0x1
    800063b0:	4581                	li	a1,0
    800063b2:	6888                	ld	a0,16(s1)
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	980080e7          	jalr	-1664(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800063bc:	100017b7          	lui	a5,0x10001
    800063c0:	4721                	li	a4,8
    800063c2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800063c4:	4098                	lw	a4,0(s1)
    800063c6:	100017b7          	lui	a5,0x10001
    800063ca:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800063ce:	40d8                	lw	a4,4(s1)
    800063d0:	100017b7          	lui	a5,0x10001
    800063d4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800063d8:	649c                	ld	a5,8(s1)
    800063da:	0007869b          	sext.w	a3,a5
    800063de:	10001737          	lui	a4,0x10001
    800063e2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800063e6:	9781                	srai	a5,a5,0x20
    800063e8:	10001737          	lui	a4,0x10001
    800063ec:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800063f0:	689c                	ld	a5,16(s1)
    800063f2:	0007869b          	sext.w	a3,a5
    800063f6:	10001737          	lui	a4,0x10001
    800063fa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800063fe:	9781                	srai	a5,a5,0x20
    80006400:	10001737          	lui	a4,0x10001
    80006404:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006408:	10001737          	lui	a4,0x10001
    8000640c:	4785                	li	a5,1
    8000640e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006410:	00f48c23          	sb	a5,24(s1)
    80006414:	00f48ca3          	sb	a5,25(s1)
    80006418:	00f48d23          	sb	a5,26(s1)
    8000641c:	00f48da3          	sb	a5,27(s1)
    80006420:	00f48e23          	sb	a5,28(s1)
    80006424:	00f48ea3          	sb	a5,29(s1)
    80006428:	00f48f23          	sb	a5,30(s1)
    8000642c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006430:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006434:	100017b7          	lui	a5,0x10001
    80006438:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000643c:	60e2                	ld	ra,24(sp)
    8000643e:	6442                	ld	s0,16(sp)
    80006440:	64a2                	ld	s1,8(sp)
    80006442:	6902                	ld	s2,0(sp)
    80006444:	6105                	addi	sp,sp,32
    80006446:	8082                	ret
    panic("could not find virtio disk");
    80006448:	00002517          	auipc	a0,0x2
    8000644c:	2f850513          	addi	a0,a0,760 # 80008740 <etext+0x740>
    80006450:	ffffa097          	auipc	ra,0xffffa
    80006454:	110080e7          	jalr	272(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006458:	00002517          	auipc	a0,0x2
    8000645c:	30850513          	addi	a0,a0,776 # 80008760 <etext+0x760>
    80006460:	ffffa097          	auipc	ra,0xffffa
    80006464:	100080e7          	jalr	256(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006468:	00002517          	auipc	a0,0x2
    8000646c:	31850513          	addi	a0,a0,792 # 80008780 <etext+0x780>
    80006470:	ffffa097          	auipc	ra,0xffffa
    80006474:	0f0080e7          	jalr	240(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006478:	00002517          	auipc	a0,0x2
    8000647c:	32850513          	addi	a0,a0,808 # 800087a0 <etext+0x7a0>
    80006480:	ffffa097          	auipc	ra,0xffffa
    80006484:	0e0080e7          	jalr	224(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006488:	00002517          	auipc	a0,0x2
    8000648c:	33850513          	addi	a0,a0,824 # 800087c0 <etext+0x7c0>
    80006490:	ffffa097          	auipc	ra,0xffffa
    80006494:	0d0080e7          	jalr	208(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006498:	00002517          	auipc	a0,0x2
    8000649c:	34850513          	addi	a0,a0,840 # 800087e0 <etext+0x7e0>
    800064a0:	ffffa097          	auipc	ra,0xffffa
    800064a4:	0c0080e7          	jalr	192(ra) # 80000560 <panic>

00000000800064a8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800064a8:	7159                	addi	sp,sp,-112
    800064aa:	f486                	sd	ra,104(sp)
    800064ac:	f0a2                	sd	s0,96(sp)
    800064ae:	eca6                	sd	s1,88(sp)
    800064b0:	e8ca                	sd	s2,80(sp)
    800064b2:	e4ce                	sd	s3,72(sp)
    800064b4:	e0d2                	sd	s4,64(sp)
    800064b6:	fc56                	sd	s5,56(sp)
    800064b8:	f85a                	sd	s6,48(sp)
    800064ba:	f45e                	sd	s7,40(sp)
    800064bc:	f062                	sd	s8,32(sp)
    800064be:	ec66                	sd	s9,24(sp)
    800064c0:	1880                	addi	s0,sp,112
    800064c2:	8a2a                	mv	s4,a0
    800064c4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800064c6:	00c52c83          	lw	s9,12(a0)
    800064ca:	001c9c9b          	slliw	s9,s9,0x1
    800064ce:	1c82                	slli	s9,s9,0x20
    800064d0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800064d4:	0001e517          	auipc	a0,0x1e
    800064d8:	44450513          	addi	a0,a0,1092 # 80024918 <disk+0x128>
    800064dc:	ffffa097          	auipc	ra,0xffffa
    800064e0:	75c080e7          	jalr	1884(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    800064e4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800064e6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800064e8:	0001eb17          	auipc	s6,0x1e
    800064ec:	308b0b13          	addi	s6,s6,776 # 800247f0 <disk>
  for(int i = 0; i < 3; i++){
    800064f0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800064f2:	0001ec17          	auipc	s8,0x1e
    800064f6:	426c0c13          	addi	s8,s8,1062 # 80024918 <disk+0x128>
    800064fa:	a0ad                	j	80006564 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800064fc:	00fb0733          	add	a4,s6,a5
    80006500:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006504:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006506:	0207c563          	bltz	a5,80006530 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000650a:	2905                	addiw	s2,s2,1
    8000650c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000650e:	05590f63          	beq	s2,s5,8000656c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006512:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006514:	0001e717          	auipc	a4,0x1e
    80006518:	2dc70713          	addi	a4,a4,732 # 800247f0 <disk>
    8000651c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000651e:	01874683          	lbu	a3,24(a4)
    80006522:	fee9                	bnez	a3,800064fc <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006524:	2785                	addiw	a5,a5,1
    80006526:	0705                	addi	a4,a4,1
    80006528:	fe979be3          	bne	a5,s1,8000651e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000652c:	57fd                	li	a5,-1
    8000652e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006530:	03205163          	blez	s2,80006552 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006534:	f9042503          	lw	a0,-112(s0)
    80006538:	00000097          	auipc	ra,0x0
    8000653c:	cc2080e7          	jalr	-830(ra) # 800061fa <free_desc>
      for(int j = 0; j < i; j++)
    80006540:	4785                	li	a5,1
    80006542:	0127d863          	bge	a5,s2,80006552 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006546:	f9442503          	lw	a0,-108(s0)
    8000654a:	00000097          	auipc	ra,0x0
    8000654e:	cb0080e7          	jalr	-848(ra) # 800061fa <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006552:	85e2                	mv	a1,s8
    80006554:	0001e517          	auipc	a0,0x1e
    80006558:	2b450513          	addi	a0,a0,692 # 80024808 <disk+0x18>
    8000655c:	ffffc097          	auipc	ra,0xffffc
    80006560:	db2080e7          	jalr	-590(ra) # 8000230e <sleep>
  for(int i = 0; i < 3; i++){
    80006564:	f9040613          	addi	a2,s0,-112
    80006568:	894e                	mv	s2,s3
    8000656a:	b765                	j	80006512 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000656c:	f9042503          	lw	a0,-112(s0)
    80006570:	00451693          	slli	a3,a0,0x4

  if(write)
    80006574:	0001e797          	auipc	a5,0x1e
    80006578:	27c78793          	addi	a5,a5,636 # 800247f0 <disk>
    8000657c:	00a50713          	addi	a4,a0,10
    80006580:	0712                	slli	a4,a4,0x4
    80006582:	973e                	add	a4,a4,a5
    80006584:	01703633          	snez	a2,s7
    80006588:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000658a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000658e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006592:	6398                	ld	a4,0(a5)
    80006594:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006596:	0a868613          	addi	a2,a3,168
    8000659a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000659c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000659e:	6390                	ld	a2,0(a5)
    800065a0:	00d605b3          	add	a1,a2,a3
    800065a4:	4741                	li	a4,16
    800065a6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065a8:	4805                	li	a6,1
    800065aa:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800065ae:	f9442703          	lw	a4,-108(s0)
    800065b2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800065b6:	0712                	slli	a4,a4,0x4
    800065b8:	963a                	add	a2,a2,a4
    800065ba:	058a0593          	addi	a1,s4,88
    800065be:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800065c0:	0007b883          	ld	a7,0(a5)
    800065c4:	9746                	add	a4,a4,a7
    800065c6:	40000613          	li	a2,1024
    800065ca:	c710                	sw	a2,8(a4)
  if(write)
    800065cc:	001bb613          	seqz	a2,s7
    800065d0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800065d4:	00166613          	ori	a2,a2,1
    800065d8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800065dc:	f9842583          	lw	a1,-104(s0)
    800065e0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800065e4:	00250613          	addi	a2,a0,2
    800065e8:	0612                	slli	a2,a2,0x4
    800065ea:	963e                	add	a2,a2,a5
    800065ec:	577d                	li	a4,-1
    800065ee:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800065f2:	0592                	slli	a1,a1,0x4
    800065f4:	98ae                	add	a7,a7,a1
    800065f6:	03068713          	addi	a4,a3,48
    800065fa:	973e                	add	a4,a4,a5
    800065fc:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006600:	6398                	ld	a4,0(a5)
    80006602:	972e                	add	a4,a4,a1
    80006604:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006608:	4689                	li	a3,2
    8000660a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000660e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006612:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006616:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000661a:	6794                	ld	a3,8(a5)
    8000661c:	0026d703          	lhu	a4,2(a3)
    80006620:	8b1d                	andi	a4,a4,7
    80006622:	0706                	slli	a4,a4,0x1
    80006624:	96ba                	add	a3,a3,a4
    80006626:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000662a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000662e:	6798                	ld	a4,8(a5)
    80006630:	00275783          	lhu	a5,2(a4)
    80006634:	2785                	addiw	a5,a5,1
    80006636:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000663a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000663e:	100017b7          	lui	a5,0x10001
    80006642:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006646:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000664a:	0001e917          	auipc	s2,0x1e
    8000664e:	2ce90913          	addi	s2,s2,718 # 80024918 <disk+0x128>
  while(b->disk == 1) {
    80006652:	4485                	li	s1,1
    80006654:	01079c63          	bne	a5,a6,8000666c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006658:	85ca                	mv	a1,s2
    8000665a:	8552                	mv	a0,s4
    8000665c:	ffffc097          	auipc	ra,0xffffc
    80006660:	cb2080e7          	jalr	-846(ra) # 8000230e <sleep>
  while(b->disk == 1) {
    80006664:	004a2783          	lw	a5,4(s4)
    80006668:	fe9788e3          	beq	a5,s1,80006658 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000666c:	f9042903          	lw	s2,-112(s0)
    80006670:	00290713          	addi	a4,s2,2
    80006674:	0712                	slli	a4,a4,0x4
    80006676:	0001e797          	auipc	a5,0x1e
    8000667a:	17a78793          	addi	a5,a5,378 # 800247f0 <disk>
    8000667e:	97ba                	add	a5,a5,a4
    80006680:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006684:	0001e997          	auipc	s3,0x1e
    80006688:	16c98993          	addi	s3,s3,364 # 800247f0 <disk>
    8000668c:	00491713          	slli	a4,s2,0x4
    80006690:	0009b783          	ld	a5,0(s3)
    80006694:	97ba                	add	a5,a5,a4
    80006696:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000669a:	854a                	mv	a0,s2
    8000669c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800066a0:	00000097          	auipc	ra,0x0
    800066a4:	b5a080e7          	jalr	-1190(ra) # 800061fa <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800066a8:	8885                	andi	s1,s1,1
    800066aa:	f0ed                	bnez	s1,8000668c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800066ac:	0001e517          	auipc	a0,0x1e
    800066b0:	26c50513          	addi	a0,a0,620 # 80024918 <disk+0x128>
    800066b4:	ffffa097          	auipc	ra,0xffffa
    800066b8:	638080e7          	jalr	1592(ra) # 80000cec <release>
}
    800066bc:	70a6                	ld	ra,104(sp)
    800066be:	7406                	ld	s0,96(sp)
    800066c0:	64e6                	ld	s1,88(sp)
    800066c2:	6946                	ld	s2,80(sp)
    800066c4:	69a6                	ld	s3,72(sp)
    800066c6:	6a06                	ld	s4,64(sp)
    800066c8:	7ae2                	ld	s5,56(sp)
    800066ca:	7b42                	ld	s6,48(sp)
    800066cc:	7ba2                	ld	s7,40(sp)
    800066ce:	7c02                	ld	s8,32(sp)
    800066d0:	6ce2                	ld	s9,24(sp)
    800066d2:	6165                	addi	sp,sp,112
    800066d4:	8082                	ret

00000000800066d6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800066d6:	1101                	addi	sp,sp,-32
    800066d8:	ec06                	sd	ra,24(sp)
    800066da:	e822                	sd	s0,16(sp)
    800066dc:	e426                	sd	s1,8(sp)
    800066de:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800066e0:	0001e497          	auipc	s1,0x1e
    800066e4:	11048493          	addi	s1,s1,272 # 800247f0 <disk>
    800066e8:	0001e517          	auipc	a0,0x1e
    800066ec:	23050513          	addi	a0,a0,560 # 80024918 <disk+0x128>
    800066f0:	ffffa097          	auipc	ra,0xffffa
    800066f4:	548080e7          	jalr	1352(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800066f8:	100017b7          	lui	a5,0x10001
    800066fc:	53b8                	lw	a4,96(a5)
    800066fe:	8b0d                	andi	a4,a4,3
    80006700:	100017b7          	lui	a5,0x10001
    80006704:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006706:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000670a:	689c                	ld	a5,16(s1)
    8000670c:	0204d703          	lhu	a4,32(s1)
    80006710:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006714:	04f70863          	beq	a4,a5,80006764 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006718:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000671c:	6898                	ld	a4,16(s1)
    8000671e:	0204d783          	lhu	a5,32(s1)
    80006722:	8b9d                	andi	a5,a5,7
    80006724:	078e                	slli	a5,a5,0x3
    80006726:	97ba                	add	a5,a5,a4
    80006728:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000672a:	00278713          	addi	a4,a5,2
    8000672e:	0712                	slli	a4,a4,0x4
    80006730:	9726                	add	a4,a4,s1
    80006732:	01074703          	lbu	a4,16(a4)
    80006736:	e721                	bnez	a4,8000677e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006738:	0789                	addi	a5,a5,2
    8000673a:	0792                	slli	a5,a5,0x4
    8000673c:	97a6                	add	a5,a5,s1
    8000673e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006740:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006744:	ffffc097          	auipc	ra,0xffffc
    80006748:	c2e080e7          	jalr	-978(ra) # 80002372 <wakeup>

    disk.used_idx += 1;
    8000674c:	0204d783          	lhu	a5,32(s1)
    80006750:	2785                	addiw	a5,a5,1
    80006752:	17c2                	slli	a5,a5,0x30
    80006754:	93c1                	srli	a5,a5,0x30
    80006756:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000675a:	6898                	ld	a4,16(s1)
    8000675c:	00275703          	lhu	a4,2(a4)
    80006760:	faf71ce3          	bne	a4,a5,80006718 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006764:	0001e517          	auipc	a0,0x1e
    80006768:	1b450513          	addi	a0,a0,436 # 80024918 <disk+0x128>
    8000676c:	ffffa097          	auipc	ra,0xffffa
    80006770:	580080e7          	jalr	1408(ra) # 80000cec <release>
}
    80006774:	60e2                	ld	ra,24(sp)
    80006776:	6442                	ld	s0,16(sp)
    80006778:	64a2                	ld	s1,8(sp)
    8000677a:	6105                	addi	sp,sp,32
    8000677c:	8082                	ret
      panic("virtio_disk_intr status");
    8000677e:	00002517          	auipc	a0,0x2
    80006782:	07a50513          	addi	a0,a0,122 # 800087f8 <etext+0x7f8>
    80006786:	ffffa097          	auipc	ra,0xffffa
    8000678a:	dda080e7          	jalr	-550(ra) # 80000560 <panic>
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
