
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
    80000066:	1de78793          	addi	a5,a5,478 # 80006240 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9ccf>
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
    8000012e:	74c080e7          	jalr	1868(ra) # 80002876 <either_copyin>
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
    800001c0:	a84080e7          	jalr	-1404(ra) # 80001c40 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	4fc080e7          	jalr	1276(ra) # 800026c0 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	246080e7          	jalr	582(ra) # 80002418 <sleep>
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
    8000021e:	606080e7          	jalr	1542(ra) # 80002820 <either_copyout>
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
    8000030c:	5c4080e7          	jalr	1476(ra) # 800028cc <procdump>
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
    8000046a:	016080e7          	jalr	22(ra) # 8000247c <wakeup>
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
    8000049c:	50078793          	addi	a5,a5,1280 # 80023998 <devsw>
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
    800008f6:	b8a080e7          	jalr	-1142(ra) # 8000247c <wakeup>
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
    80000982:	a9a080e7          	jalr	-1382(ra) # 80002418 <sleep>
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
    80000a62:	0d278793          	addi	a5,a5,210 # 80024b30 <end>
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
    80000b34:	00050513          	mv	a0,a0
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
    80000bd6:	052080e7          	jalr	82(ra) # 80001c24 <mycpu>
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
    80000c08:	020080e7          	jalr	32(ra) # 80001c24 <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	014080e7          	jalr	20(ra) # 80001c24 <mycpu>
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
    80000c2c:	ffc080e7          	jalr	-4(ra) # 80001c24 <mycpu>
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
    80000c6c:	fbc080e7          	jalr	-68(ra) # 80001c24 <mycpu>
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
    80000c98:	f90080e7          	jalr	-112(ra) # 80001c24 <mycpu>
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
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda4d1>
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
    80000ede:	d3a080e7          	jalr	-710(ra) # 80001c14 <cpuid>
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
    80000efa:	d1e080e7          	jalr	-738(ra) # 80001c14 <cpuid>
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
    80000f1c:	c3c080e7          	jalr	-964(ra) # 80002b54 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	364080e7          	jalr	868(ra) # 80006284 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	3a8080e7          	jalr	936(ra) # 800022d0 <scheduler>
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
    80000f8c:	ba6080e7          	jalr	-1114(ra) # 80001b2e <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	b9c080e7          	jalr	-1124(ra) # 80002b2c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	bbc080e7          	jalr	-1092(ra) # 80002b54 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	2ca080e7          	jalr	714(ra) # 8000626a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	2dc080e7          	jalr	732(ra) # 80006284 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	39c080e7          	jalr	924(ra) # 8000334c <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	a52080e7          	jalr	-1454(ra) # 80003a0a <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	a02080e7          	jalr	-1534(ra) # 800049c2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	3c4080e7          	jalr	964(ra) # 8000638c <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	f48080e7          	jalr	-184(ra) # 80001f18 <userinit>
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
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda4c7>
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
    8000128c:	802080e7          	jalr	-2046(ra) # 80001a8a <proc_mapstacks>
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
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda4d0>
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
        old_scheduler = sched_pointer;
    }
}
#define NQUEUES 4
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
    800018d0:	1880                	addi	s0,sp,112
  asm volatile("mv %0, tp" : "=r" (x) );
    800018d2:	8792                	mv	a5,tp
    int id = r_tp();
    800018d4:	2781                	sext.w	a5,a5
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
    800018d6:	00012697          	auipc	a3,0x12
    800018da:	e4a68693          	addi	a3,a3,-438 # 80013720 <cpus>
    800018de:	00779713          	slli	a4,a5,0x7
    800018e2:	00e68633          	add	a2,a3,a4
    800018e6:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
    // Step 2: if we found one, run it
    if(best){
      best->state = RUNNING;
      c->proc = best;

      swtch(&c->context, &best->context);
    800018ea:	0721                	addi	a4,a4,8
    800018ec:	00e68cb3          	add	s9,a3,a4
    int best_pri = NQUEUES;  // larger than any valid priority
    800018f0:	4b11                	li	s6,4
    struct proc *best = 0;
    800018f2:	4b81                	li	s7,0
      if(p->state == RUNNABLE){
    800018f4:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++){
    800018f6:	00018917          	auipc	s2,0x18
    800018fa:	e5a90913          	addi	s2,s2,-422 # 80019750 <tickslock>
      c->proc = best;
    800018fe:	8c32                	mv	s8,a2
    80001900:	a881                	j	80001950 <mlfq_scheduler+0x98>
      release(&p->lock);
    80001902:	8526                	mv	a0,s1
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	3e8080e7          	jalr	1000(ra) # 80000cec <release>
    for(p = proc; p < &proc[NPROC]; p++){
    8000190c:	17048493          	addi	s1,s1,368
    80001910:	03248e63          	beq	s1,s2,8000194c <mlfq_scheduler+0x94>
      acquire(&p->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	322080e7          	jalr	802(ra) # 80000c38 <acquire>
      if(p->state == RUNNABLE){
    8000191e:	4c9c                	lw	a5,24(s1)
    80001920:	ff3791e3          	bne	a5,s3,80001902 <mlfq_scheduler+0x4a>
        if(p->priority < best_pri){
    80001924:	1684a783          	lw	a5,360(s1)
    80001928:	fd47dde3          	bge	a5,s4,80001902 <mlfq_scheduler+0x4a>
          if(best)
    8000192c:	000a8763          	beqz	s5,8000193a <mlfq_scheduler+0x82>
            release(&best->lock);
    80001930:	8556                	mv	a0,s5
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	3ba080e7          	jalr	954(ra) # 80000cec <release>
          best_pri = p->priority;
    8000193a:	1684aa03          	lw	s4,360(s1)
    for(p = proc; p < &proc[NPROC]; p++){
    8000193e:	17048793          	addi	a5,s1,368
    80001942:	03278563          	beq	a5,s2,8000196c <mlfq_scheduler+0xb4>
          best = p;
    80001946:	8aa6                	mv	s5,s1
    for(p = proc; p < &proc[NPROC]; p++){
    80001948:	84be                	mv	s1,a5
    8000194a:	b7e9                	j	80001914 <mlfq_scheduler+0x5c>
    if(best){
    8000194c:	000a9f63          	bnez	s5,8000196a <mlfq_scheduler+0xb2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001950:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001954:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001958:	10079073          	csrw	sstatus,a5
    int best_pri = NQUEUES;  // larger than any valid priority
    8000195c:	8a5a                	mv	s4,s6
    struct proc *best = 0;
    8000195e:	8ade                	mv	s5,s7
    for(p = proc; p < &proc[NPROC]; p++){
    80001960:	00012497          	auipc	s1,0x12
    80001964:	1f048493          	addi	s1,s1,496 # 80013b50 <proc>
    80001968:	b775                	j	80001914 <mlfq_scheduler+0x5c>
    8000196a:	84d6                	mv	s1,s5
      best->state = RUNNING;
    8000196c:	0164ac23          	sw	s6,24(s1)
      c->proc = best;
    80001970:	009c3023          	sd	s1,0(s8)
      swtch(&c->context, &best->context);
    80001974:	06048593          	addi	a1,s1,96
    80001978:	8566                	mv	a0,s9
    8000197a:	00001097          	auipc	ra,0x1
    8000197e:	148080e7          	jalr	328(ra) # 80002ac2 <swtch>

      // We're back after process yielded or got preempted
      c->proc = 0;
    80001982:	000c3023          	sd	zero,0(s8)

      best->ticks_used++;
    80001986:	16c4a783          	lw	a5,364(s1)
    8000198a:	2785                	addiw	a5,a5,1
    8000198c:	0007869b          	sext.w	a3,a5
    80001990:	16f4a623          	sw	a5,364(s1)

      int slices[] = {8, 16, 32};  // must match NQUEUES
    80001994:	47a1                	li	a5,8
    80001996:	f8f42823          	sw	a5,-112(s0)
    8000199a:	47c1                	li	a5,16
    8000199c:	f8f42a23          	sw	a5,-108(s0)
    800019a0:	02000793          	li	a5,32
    800019a4:	f8f42c23          	sw	a5,-104(s0)

      if(best->priority < NQUEUES-1 &&
    800019a8:	1684a783          	lw	a5,360(s1)
    800019ac:	4709                	li	a4,2
    800019ae:	02f74063          	blt	a4,a5,800019ce <mlfq_scheduler+0x116>
         best->ticks_used >= slices[best->priority]){
    800019b2:	00279713          	slli	a4,a5,0x2
    800019b6:	fa070713          	addi	a4,a4,-96
    800019ba:	9722                	add	a4,a4,s0
      if(best->priority < NQUEUES-1 &&
    800019bc:	ff072703          	lw	a4,-16(a4)
    800019c0:	00e6c763          	blt	a3,a4,800019ce <mlfq_scheduler+0x116>
        best->priority++;
    800019c4:	2785                	addiw	a5,a5,1
    800019c6:	16f4a423          	sw	a5,360(s1)
        best->ticks_used = 0;
    800019ca:	1604a623          	sw	zero,364(s1)
      }

      release(&best->lock);
    800019ce:	8526                	mv	a0,s1
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	31c080e7          	jalr	796(ra) # 80000cec <release>
    800019d8:	bfa5                	j	80001950 <mlfq_scheduler+0x98>

00000000800019da <rr_scheduler>:
    }
  }
}
void rr_scheduler(void)
{
    800019da:	7139                	addi	sp,sp,-64
    800019dc:	fc06                	sd	ra,56(sp)
    800019de:	f822                	sd	s0,48(sp)
    800019e0:	f426                	sd	s1,40(sp)
    800019e2:	f04a                	sd	s2,32(sp)
    800019e4:	ec4e                	sd	s3,24(sp)
    800019e6:	e852                	sd	s4,16(sp)
    800019e8:	e456                	sd	s5,8(sp)
    800019ea:	e05a                	sd	s6,0(sp)
    800019ec:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    800019ee:	8792                	mv	a5,tp
    int id = r_tp();
    800019f0:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    800019f2:	00012a97          	auipc	s5,0x12
    800019f6:	d2ea8a93          	addi	s5,s5,-722 # 80013720 <cpus>
    800019fa:	00779713          	slli	a4,a5,0x7
    800019fe:	00ea86b3          	add	a3,s5,a4
    80001a02:	0006b023          	sd	zero,0(a3)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a06:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a0a:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a0e:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    80001a12:	0721                	addi	a4,a4,8
    80001a14:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    80001a16:	00012497          	auipc	s1,0x12
    80001a1a:	13a48493          	addi	s1,s1,314 # 80013b50 <proc>
        if (p->state == RUNNABLE)
    80001a1e:	498d                	li	s3,3
            p->state = RUNNING;
    80001a20:	4b11                	li	s6,4
            c->proc = p;
    80001a22:	079e                	slli	a5,a5,0x7
    80001a24:	00012a17          	auipc	s4,0x12
    80001a28:	cfca0a13          	addi	s4,s4,-772 # 80013720 <cpus>
    80001a2c:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001a2e:	00018917          	auipc	s2,0x18
    80001a32:	d2290913          	addi	s2,s2,-734 # 80019750 <tickslock>
    80001a36:	a811                	j	80001a4a <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    80001a38:	8526                	mv	a0,s1
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	2b2080e7          	jalr	690(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a42:	17048493          	addi	s1,s1,368
    80001a46:	03248863          	beq	s1,s2,80001a76 <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	1ec080e7          	jalr	492(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    80001a54:	4c9c                	lw	a5,24(s1)
    80001a56:	ff3791e3          	bne	a5,s3,80001a38 <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001a5a:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001a5e:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001a62:	06048593          	addi	a1,s1,96
    80001a66:	8556                	mv	a0,s5
    80001a68:	00001097          	auipc	ra,0x1
    80001a6c:	05a080e7          	jalr	90(ra) # 80002ac2 <swtch>
            c->proc = 0;
    80001a70:	000a3023          	sd	zero,0(s4)
    80001a74:	b7d1                	j	80001a38 <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    80001a76:	70e2                	ld	ra,56(sp)
    80001a78:	7442                	ld	s0,48(sp)
    80001a7a:	74a2                	ld	s1,40(sp)
    80001a7c:	7902                	ld	s2,32(sp)
    80001a7e:	69e2                	ld	s3,24(sp)
    80001a80:	6a42                	ld	s4,16(sp)
    80001a82:	6aa2                	ld	s5,8(sp)
    80001a84:	6b02                	ld	s6,0(sp)
    80001a86:	6121                	addi	sp,sp,64
    80001a88:	8082                	ret

0000000080001a8a <proc_mapstacks>:
{
    80001a8a:	7139                	addi	sp,sp,-64
    80001a8c:	fc06                	sd	ra,56(sp)
    80001a8e:	f822                	sd	s0,48(sp)
    80001a90:	f426                	sd	s1,40(sp)
    80001a92:	f04a                	sd	s2,32(sp)
    80001a94:	ec4e                	sd	s3,24(sp)
    80001a96:	e852                	sd	s4,16(sp)
    80001a98:	e456                	sd	s5,8(sp)
    80001a9a:	e05a                	sd	s6,0(sp)
    80001a9c:	0080                	addi	s0,sp,64
    80001a9e:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001aa0:	00012497          	auipc	s1,0x12
    80001aa4:	0b048493          	addi	s1,s1,176 # 80013b50 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001aa8:	8b26                	mv	s6,s1
    80001aaa:	ff4df937          	lui	s2,0xff4df
    80001aae:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e8d>
    80001ab2:	0936                	slli	s2,s2,0xd
    80001ab4:	6f590913          	addi	s2,s2,1781
    80001ab8:	0936                	slli	s2,s2,0xd
    80001aba:	bd390913          	addi	s2,s2,-1069
    80001abe:	0932                	slli	s2,s2,0xc
    80001ac0:	7a790913          	addi	s2,s2,1959
    80001ac4:	040009b7          	lui	s3,0x4000
    80001ac8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001aca:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001acc:	00018a97          	auipc	s5,0x18
    80001ad0:	c84a8a93          	addi	s5,s5,-892 # 80019750 <tickslock>
        char *pa = kalloc();
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	074080e7          	jalr	116(ra) # 80000b48 <kalloc>
    80001adc:	862a                	mv	a2,a0
        if (pa == 0)
    80001ade:	c121                	beqz	a0,80001b1e <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001ae0:	416485b3          	sub	a1,s1,s6
    80001ae4:	8591                	srai	a1,a1,0x4
    80001ae6:	032585b3          	mul	a1,a1,s2
    80001aea:	2585                	addiw	a1,a1,1
    80001aec:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001af0:	4719                	li	a4,6
    80001af2:	6685                	lui	a3,0x1
    80001af4:	40b985b3          	sub	a1,s3,a1
    80001af8:	8552                	mv	a0,s4
    80001afa:	fffff097          	auipc	ra,0xfffff
    80001afe:	69e080e7          	jalr	1694(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b02:	17048493          	addi	s1,s1,368
    80001b06:	fd5497e3          	bne	s1,s5,80001ad4 <proc_mapstacks+0x4a>
}
    80001b0a:	70e2                	ld	ra,56(sp)
    80001b0c:	7442                	ld	s0,48(sp)
    80001b0e:	74a2                	ld	s1,40(sp)
    80001b10:	7902                	ld	s2,32(sp)
    80001b12:	69e2                	ld	s3,24(sp)
    80001b14:	6a42                	ld	s4,16(sp)
    80001b16:	6aa2                	ld	s5,8(sp)
    80001b18:	6b02                	ld	s6,0(sp)
    80001b1a:	6121                	addi	sp,sp,64
    80001b1c:	8082                	ret
            panic("kalloc");
    80001b1e:	00006517          	auipc	a0,0x6
    80001b22:	69a50513          	addi	a0,a0,1690 # 800081b8 <etext+0x1b8>
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	a3a080e7          	jalr	-1478(ra) # 80000560 <panic>

0000000080001b2e <procinit>:
{
    80001b2e:	7139                	addi	sp,sp,-64
    80001b30:	fc06                	sd	ra,56(sp)
    80001b32:	f822                	sd	s0,48(sp)
    80001b34:	f426                	sd	s1,40(sp)
    80001b36:	f04a                	sd	s2,32(sp)
    80001b38:	ec4e                	sd	s3,24(sp)
    80001b3a:	e852                	sd	s4,16(sp)
    80001b3c:	e456                	sd	s5,8(sp)
    80001b3e:	e05a                	sd	s6,0(sp)
    80001b40:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001b42:	00006597          	auipc	a1,0x6
    80001b46:	67e58593          	addi	a1,a1,1662 # 800081c0 <etext+0x1c0>
    80001b4a:	00012517          	auipc	a0,0x12
    80001b4e:	fd650513          	addi	a0,a0,-42 # 80013b20 <pid_lock>
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	056080e7          	jalr	86(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001b5a:	00006597          	auipc	a1,0x6
    80001b5e:	66e58593          	addi	a1,a1,1646 # 800081c8 <etext+0x1c8>
    80001b62:	00012517          	auipc	a0,0x12
    80001b66:	fd650513          	addi	a0,a0,-42 # 80013b38 <wait_lock>
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	03e080e7          	jalr	62(ra) # 80000ba8 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b72:	00012497          	auipc	s1,0x12
    80001b76:	fde48493          	addi	s1,s1,-34 # 80013b50 <proc>
        initlock(&p->lock, "proc");
    80001b7a:	00006b17          	auipc	s6,0x6
    80001b7e:	65eb0b13          	addi	s6,s6,1630 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001b82:	8aa6                	mv	s5,s1
    80001b84:	ff4df937          	lui	s2,0xff4df
    80001b88:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9e8d>
    80001b8c:	0936                	slli	s2,s2,0xd
    80001b8e:	6f590913          	addi	s2,s2,1781
    80001b92:	0936                	slli	s2,s2,0xd
    80001b94:	bd390913          	addi	s2,s2,-1069
    80001b98:	0932                	slli	s2,s2,0xc
    80001b9a:	7a790913          	addi	s2,s2,1959
    80001b9e:	040009b7          	lui	s3,0x4000
    80001ba2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ba4:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001ba6:	00018a17          	auipc	s4,0x18
    80001baa:	baaa0a13          	addi	s4,s4,-1110 # 80019750 <tickslock>
        initlock(&p->lock, "proc");
    80001bae:	85da                	mv	a1,s6
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	ff6080e7          	jalr	-10(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80001bba:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001bbe:	415487b3          	sub	a5,s1,s5
    80001bc2:	8791                	srai	a5,a5,0x4
    80001bc4:	032787b3          	mul	a5,a5,s2
    80001bc8:	2785                	addiw	a5,a5,1
    80001bca:	00d7979b          	slliw	a5,a5,0xd
    80001bce:	40f987b3          	sub	a5,s3,a5
    80001bd2:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001bd4:	17048493          	addi	s1,s1,368
    80001bd8:	fd449be3          	bne	s1,s4,80001bae <procinit+0x80>
}
    80001bdc:	70e2                	ld	ra,56(sp)
    80001bde:	7442                	ld	s0,48(sp)
    80001be0:	74a2                	ld	s1,40(sp)
    80001be2:	7902                	ld	s2,32(sp)
    80001be4:	69e2                	ld	s3,24(sp)
    80001be6:	6a42                	ld	s4,16(sp)
    80001be8:	6aa2                	ld	s5,8(sp)
    80001bea:	6b02                	ld	s6,0(sp)
    80001bec:	6121                	addi	sp,sp,64
    80001bee:	8082                	ret

0000000080001bf0 <copy_array>:
{
    80001bf0:	1141                	addi	sp,sp,-16
    80001bf2:	e422                	sd	s0,8(sp)
    80001bf4:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001bf6:	00c05c63          	blez	a2,80001c0e <copy_array+0x1e>
    80001bfa:	87aa                	mv	a5,a0
    80001bfc:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001bfe:	0007c703          	lbu	a4,0(a5)
    80001c02:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001c06:	0785                	addi	a5,a5,1
    80001c08:	0585                	addi	a1,a1,1
    80001c0a:	fea79ae3          	bne	a5,a0,80001bfe <copy_array+0xe>
}
    80001c0e:	6422                	ld	s0,8(sp)
    80001c10:	0141                	addi	sp,sp,16
    80001c12:	8082                	ret

0000000080001c14 <cpuid>:
{
    80001c14:	1141                	addi	sp,sp,-16
    80001c16:	e422                	sd	s0,8(sp)
    80001c18:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1a:	8512                	mv	a0,tp
}
    80001c1c:	2501                	sext.w	a0,a0
    80001c1e:	6422                	ld	s0,8(sp)
    80001c20:	0141                	addi	sp,sp,16
    80001c22:	8082                	ret

0000000080001c24 <mycpu>:
{
    80001c24:	1141                	addi	sp,sp,-16
    80001c26:	e422                	sd	s0,8(sp)
    80001c28:	0800                	addi	s0,sp,16
    80001c2a:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001c2c:	2781                	sext.w	a5,a5
    80001c2e:	079e                	slli	a5,a5,0x7
}
    80001c30:	00012517          	auipc	a0,0x12
    80001c34:	af050513          	addi	a0,a0,-1296 # 80013720 <cpus>
    80001c38:	953e                	add	a0,a0,a5
    80001c3a:	6422                	ld	s0,8(sp)
    80001c3c:	0141                	addi	sp,sp,16
    80001c3e:	8082                	ret

0000000080001c40 <myproc>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
    push_off();
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	fa2080e7          	jalr	-94(ra) # 80000bec <push_off>
    80001c52:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001c54:	2781                	sext.w	a5,a5
    80001c56:	079e                	slli	a5,a5,0x7
    80001c58:	00012717          	auipc	a4,0x12
    80001c5c:	ac870713          	addi	a4,a4,-1336 # 80013720 <cpus>
    80001c60:	97ba                	add	a5,a5,a4
    80001c62:	6384                	ld	s1,0(a5)
    pop_off();
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	028080e7          	jalr	40(ra) # 80000c8c <pop_off>
}
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	60e2                	ld	ra,24(sp)
    80001c70:	6442                	ld	s0,16(sp)
    80001c72:	64a2                	ld	s1,8(sp)
    80001c74:	6105                	addi	sp,sp,32
    80001c76:	8082                	ret

0000000080001c78 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c78:	1141                	addi	sp,sp,-16
    80001c7a:	e406                	sd	ra,8(sp)
    80001c7c:	e022                	sd	s0,0(sp)
    80001c7e:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	fc0080e7          	jalr	-64(ra) # 80001c40 <myproc>
    80001c88:	fffff097          	auipc	ra,0xfffff
    80001c8c:	064080e7          	jalr	100(ra) # 80000cec <release>

    if (first)
    80001c90:	00009797          	auipc	a5,0x9
    80001c94:	7307a783          	lw	a5,1840(a5) # 8000b3c0 <first.1>
    80001c98:	eb89                	bnez	a5,80001caa <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001c9a:	00001097          	auipc	ra,0x1
    80001c9e:	ed2080e7          	jalr	-302(ra) # 80002b6c <usertrapret>
}
    80001ca2:	60a2                	ld	ra,8(sp)
    80001ca4:	6402                	ld	s0,0(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret
        first = 0;
    80001caa:	00009797          	auipc	a5,0x9
    80001cae:	7007ab23          	sw	zero,1814(a5) # 8000b3c0 <first.1>
        fsinit(ROOTDEV);
    80001cb2:	4505                	li	a0,1
    80001cb4:	00002097          	auipc	ra,0x2
    80001cb8:	cd6080e7          	jalr	-810(ra) # 8000398a <fsinit>
    80001cbc:	bff9                	j	80001c9a <forkret+0x22>

0000000080001cbe <allocpid>:
{
    80001cbe:	1101                	addi	sp,sp,-32
    80001cc0:	ec06                	sd	ra,24(sp)
    80001cc2:	e822                	sd	s0,16(sp)
    80001cc4:	e426                	sd	s1,8(sp)
    80001cc6:	e04a                	sd	s2,0(sp)
    80001cc8:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001cca:	00012917          	auipc	s2,0x12
    80001cce:	e5690913          	addi	s2,s2,-426 # 80013b20 <pid_lock>
    80001cd2:	854a                	mv	a0,s2
    80001cd4:	fffff097          	auipc	ra,0xfffff
    80001cd8:	f64080e7          	jalr	-156(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001cdc:	00009797          	auipc	a5,0x9
    80001ce0:	6f478793          	addi	a5,a5,1780 # 8000b3d0 <nextpid>
    80001ce4:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001ce6:	0014871b          	addiw	a4,s1,1
    80001cea:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001cec:	854a                	mv	a0,s2
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	ffe080e7          	jalr	-2(ra) # 80000cec <release>
}
    80001cf6:	8526                	mv	a0,s1
    80001cf8:	60e2                	ld	ra,24(sp)
    80001cfa:	6442                	ld	s0,16(sp)
    80001cfc:	64a2                	ld	s1,8(sp)
    80001cfe:	6902                	ld	s2,0(sp)
    80001d00:	6105                	addi	sp,sp,32
    80001d02:	8082                	ret

0000000080001d04 <proc_pagetable>:
{
    80001d04:	1101                	addi	sp,sp,-32
    80001d06:	ec06                	sd	ra,24(sp)
    80001d08:	e822                	sd	s0,16(sp)
    80001d0a:	e426                	sd	s1,8(sp)
    80001d0c:	e04a                	sd	s2,0(sp)
    80001d0e:	1000                	addi	s0,sp,32
    80001d10:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	680080e7          	jalr	1664(ra) # 80001392 <uvmcreate>
    80001d1a:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001d1c:	c121                	beqz	a0,80001d5c <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001d1e:	4729                	li	a4,10
    80001d20:	00005697          	auipc	a3,0x5
    80001d24:	2e068693          	addi	a3,a3,736 # 80007000 <_trampoline>
    80001d28:	6605                	lui	a2,0x1
    80001d2a:	040005b7          	lui	a1,0x4000
    80001d2e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d30:	05b2                	slli	a1,a1,0xc
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	3c6080e7          	jalr	966(ra) # 800010f8 <mappages>
    80001d3a:	02054863          	bltz	a0,80001d6a <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d3e:	4719                	li	a4,6
    80001d40:	05893683          	ld	a3,88(s2)
    80001d44:	6605                	lui	a2,0x1
    80001d46:	020005b7          	lui	a1,0x2000
    80001d4a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d4c:	05b6                	slli	a1,a1,0xd
    80001d4e:	8526                	mv	a0,s1
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	3a8080e7          	jalr	936(ra) # 800010f8 <mappages>
    80001d58:	02054163          	bltz	a0,80001d7a <proc_pagetable+0x76>
}
    80001d5c:	8526                	mv	a0,s1
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	64a2                	ld	s1,8(sp)
    80001d64:	6902                	ld	s2,0(sp)
    80001d66:	6105                	addi	sp,sp,32
    80001d68:	8082                	ret
        uvmfree(pagetable, 0);
    80001d6a:	4581                	li	a1,0
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	836080e7          	jalr	-1994(ra) # 800015a4 <uvmfree>
        return 0;
    80001d76:	4481                	li	s1,0
    80001d78:	b7d5                	j	80001d5c <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d7a:	4681                	li	a3,0
    80001d7c:	4605                	li	a2,1
    80001d7e:	040005b7          	lui	a1,0x4000
    80001d82:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d84:	05b2                	slli	a1,a1,0xc
    80001d86:	8526                	mv	a0,s1
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	536080e7          	jalr	1334(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001d90:	4581                	li	a1,0
    80001d92:	8526                	mv	a0,s1
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	810080e7          	jalr	-2032(ra) # 800015a4 <uvmfree>
        return 0;
    80001d9c:	4481                	li	s1,0
    80001d9e:	bf7d                	j	80001d5c <proc_pagetable+0x58>

0000000080001da0 <proc_freepagetable>:
{
    80001da0:	1101                	addi	sp,sp,-32
    80001da2:	ec06                	sd	ra,24(sp)
    80001da4:	e822                	sd	s0,16(sp)
    80001da6:	e426                	sd	s1,8(sp)
    80001da8:	e04a                	sd	s2,0(sp)
    80001daa:	1000                	addi	s0,sp,32
    80001dac:	84aa                	mv	s1,a0
    80001dae:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001db0:	4681                	li	a3,0
    80001db2:	4605                	li	a2,1
    80001db4:	040005b7          	lui	a1,0x4000
    80001db8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001dba:	05b2                	slli	a1,a1,0xc
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	502080e7          	jalr	1282(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001dc4:	4681                	li	a3,0
    80001dc6:	4605                	li	a2,1
    80001dc8:	020005b7          	lui	a1,0x2000
    80001dcc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001dce:	05b6                	slli	a1,a1,0xd
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	4ec080e7          	jalr	1260(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001dda:	85ca                	mv	a1,s2
    80001ddc:	8526                	mv	a0,s1
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	7c6080e7          	jalr	1990(ra) # 800015a4 <uvmfree>
}
    80001de6:	60e2                	ld	ra,24(sp)
    80001de8:	6442                	ld	s0,16(sp)
    80001dea:	64a2                	ld	s1,8(sp)
    80001dec:	6902                	ld	s2,0(sp)
    80001dee:	6105                	addi	sp,sp,32
    80001df0:	8082                	ret

0000000080001df2 <freeproc>:
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	1000                	addi	s0,sp,32
    80001dfc:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001dfe:	6d28                	ld	a0,88(a0)
    80001e00:	c509                	beqz	a0,80001e0a <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001e02:	fffff097          	auipc	ra,0xfffff
    80001e06:	c48080e7          	jalr	-952(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001e0a:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001e0e:	68a8                	ld	a0,80(s1)
    80001e10:	c511                	beqz	a0,80001e1c <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001e12:	64ac                	ld	a1,72(s1)
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	f8c080e7          	jalr	-116(ra) # 80001da0 <proc_freepagetable>
    p->pagetable = 0;
    80001e1c:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001e20:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001e24:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001e28:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001e2c:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001e30:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001e34:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001e38:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001e3c:	0004ac23          	sw	zero,24(s1)
}
    80001e40:	60e2                	ld	ra,24(sp)
    80001e42:	6442                	ld	s0,16(sp)
    80001e44:	64a2                	ld	s1,8(sp)
    80001e46:	6105                	addi	sp,sp,32
    80001e48:	8082                	ret

0000000080001e4a <allocproc>:
{
    80001e4a:	1101                	addi	sp,sp,-32
    80001e4c:	ec06                	sd	ra,24(sp)
    80001e4e:	e822                	sd	s0,16(sp)
    80001e50:	e426                	sd	s1,8(sp)
    80001e52:	e04a                	sd	s2,0(sp)
    80001e54:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001e56:	00012497          	auipc	s1,0x12
    80001e5a:	cfa48493          	addi	s1,s1,-774 # 80013b50 <proc>
    80001e5e:	00018917          	auipc	s2,0x18
    80001e62:	8f290913          	addi	s2,s2,-1806 # 80019750 <tickslock>
        acquire(&p->lock);
    80001e66:	8526                	mv	a0,s1
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	dd0080e7          	jalr	-560(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001e70:	4c9c                	lw	a5,24(s1)
    80001e72:	cf81                	beqz	a5,80001e8a <allocproc+0x40>
            release(&p->lock);
    80001e74:	8526                	mv	a0,s1
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	e76080e7          	jalr	-394(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001e7e:	17048493          	addi	s1,s1,368
    80001e82:	ff2492e3          	bne	s1,s2,80001e66 <allocproc+0x1c>
    return 0;
    80001e86:	4481                	li	s1,0
    80001e88:	a889                	j	80001eda <allocproc+0x90>
    p->pid = allocpid();
    80001e8a:	00000097          	auipc	ra,0x0
    80001e8e:	e34080e7          	jalr	-460(ra) # 80001cbe <allocpid>
    80001e92:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001e94:	4785                	li	a5,1
    80001e96:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	cb0080e7          	jalr	-848(ra) # 80000b48 <kalloc>
    80001ea0:	892a                	mv	s2,a0
    80001ea2:	eca8                	sd	a0,88(s1)
    80001ea4:	c131                	beqz	a0,80001ee8 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001ea6:	8526                	mv	a0,s1
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	e5c080e7          	jalr	-420(ra) # 80001d04 <proc_pagetable>
    80001eb0:	892a                	mv	s2,a0
    80001eb2:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001eb4:	c531                	beqz	a0,80001f00 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001eb6:	07000613          	li	a2,112
    80001eba:	4581                	li	a1,0
    80001ebc:	06048513          	addi	a0,s1,96
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	e74080e7          	jalr	-396(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001ec8:	00000797          	auipc	a5,0x0
    80001ecc:	db078793          	addi	a5,a5,-592 # 80001c78 <forkret>
    80001ed0:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001ed2:	60bc                	ld	a5,64(s1)
    80001ed4:	6705                	lui	a4,0x1
    80001ed6:	97ba                	add	a5,a5,a4
    80001ed8:	f4bc                	sd	a5,104(s1)
}
    80001eda:	8526                	mv	a0,s1
    80001edc:	60e2                	ld	ra,24(sp)
    80001ede:	6442                	ld	s0,16(sp)
    80001ee0:	64a2                	ld	s1,8(sp)
    80001ee2:	6902                	ld	s2,0(sp)
    80001ee4:	6105                	addi	sp,sp,32
    80001ee6:	8082                	ret
        freeproc(p);
    80001ee8:	8526                	mv	a0,s1
    80001eea:	00000097          	auipc	ra,0x0
    80001eee:	f08080e7          	jalr	-248(ra) # 80001df2 <freeproc>
        release(&p->lock);
    80001ef2:	8526                	mv	a0,s1
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	df8080e7          	jalr	-520(ra) # 80000cec <release>
        return 0;
    80001efc:	84ca                	mv	s1,s2
    80001efe:	bff1                	j	80001eda <allocproc+0x90>
        freeproc(p);
    80001f00:	8526                	mv	a0,s1
    80001f02:	00000097          	auipc	ra,0x0
    80001f06:	ef0080e7          	jalr	-272(ra) # 80001df2 <freeproc>
        release(&p->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	de0080e7          	jalr	-544(ra) # 80000cec <release>
        return 0;
    80001f14:	84ca                	mv	s1,s2
    80001f16:	b7d1                	j	80001eda <allocproc+0x90>

0000000080001f18 <userinit>:
{
    80001f18:	1101                	addi	sp,sp,-32
    80001f1a:	ec06                	sd	ra,24(sp)
    80001f1c:	e822                	sd	s0,16(sp)
    80001f1e:	e426                	sd	s1,8(sp)
    80001f20:	1000                	addi	s0,sp,32
    p = allocproc();
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	f28080e7          	jalr	-216(ra) # 80001e4a <allocproc>
    80001f2a:	84aa                	mv	s1,a0
    initproc = p;
    80001f2c:	00009797          	auipc	a5,0x9
    80001f30:	56a7be23          	sd	a0,1404(a5) # 8000b4a8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f34:	03400613          	li	a2,52
    80001f38:	00009597          	auipc	a1,0x9
    80001f3c:	4a858593          	addi	a1,a1,1192 # 8000b3e0 <initcode>
    80001f40:	6928                	ld	a0,80(a0)
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	47e080e7          	jalr	1150(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80001f4a:	6785                	lui	a5,0x1
    80001f4c:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001f4e:	6cb8                	ld	a4,88(s1)
    80001f50:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001f54:	6cb8                	ld	a4,88(s1)
    80001f56:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f58:	4641                	li	a2,16
    80001f5a:	00006597          	auipc	a1,0x6
    80001f5e:	28658593          	addi	a1,a1,646 # 800081e0 <etext+0x1e0>
    80001f62:	15848513          	addi	a0,s1,344
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	f10080e7          	jalr	-240(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    80001f6e:	00006517          	auipc	a0,0x6
    80001f72:	28250513          	addi	a0,a0,642 # 800081f0 <etext+0x1f0>
    80001f76:	00002097          	auipc	ra,0x2
    80001f7a:	466080e7          	jalr	1126(ra) # 800043dc <namei>
    80001f7e:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001f82:	478d                	li	a5,3
    80001f84:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001f86:	8526                	mv	a0,s1
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	d64080e7          	jalr	-668(ra) # 80000cec <release>
}
    80001f90:	60e2                	ld	ra,24(sp)
    80001f92:	6442                	ld	s0,16(sp)
    80001f94:	64a2                	ld	s1,8(sp)
    80001f96:	6105                	addi	sp,sp,32
    80001f98:	8082                	ret

0000000080001f9a <growproc>:
{
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	e04a                	sd	s2,0(sp)
    80001fa4:	1000                	addi	s0,sp,32
    80001fa6:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	c98080e7          	jalr	-872(ra) # 80001c40 <myproc>
    80001fb0:	84aa                	mv	s1,a0
    sz = p->sz;
    80001fb2:	652c                	ld	a1,72(a0)
    if (n > 0)
    80001fb4:	01204c63          	bgtz	s2,80001fcc <growproc+0x32>
    else if (n < 0)
    80001fb8:	02094663          	bltz	s2,80001fe4 <growproc+0x4a>
    p->sz = sz;
    80001fbc:	e4ac                	sd	a1,72(s1)
    return 0;
    80001fbe:	4501                	li	a0,0
}
    80001fc0:	60e2                	ld	ra,24(sp)
    80001fc2:	6442                	ld	s0,16(sp)
    80001fc4:	64a2                	ld	s1,8(sp)
    80001fc6:	6902                	ld	s2,0(sp)
    80001fc8:	6105                	addi	sp,sp,32
    80001fca:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001fcc:	4691                	li	a3,4
    80001fce:	00b90633          	add	a2,s2,a1
    80001fd2:	6928                	ld	a0,80(a0)
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	4a6080e7          	jalr	1190(ra) # 8000147a <uvmalloc>
    80001fdc:	85aa                	mv	a1,a0
    80001fde:	fd79                	bnez	a0,80001fbc <growproc+0x22>
            return -1;
    80001fe0:	557d                	li	a0,-1
    80001fe2:	bff9                	j	80001fc0 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fe4:	00b90633          	add	a2,s2,a1
    80001fe8:	6928                	ld	a0,80(a0)
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	448080e7          	jalr	1096(ra) # 80001432 <uvmdealloc>
    80001ff2:	85aa                	mv	a1,a0
    80001ff4:	b7e1                	j	80001fbc <growproc+0x22>

0000000080001ff6 <ps>:
{
    80001ff6:	715d                	addi	sp,sp,-80
    80001ff8:	e486                	sd	ra,72(sp)
    80001ffa:	e0a2                	sd	s0,64(sp)
    80001ffc:	fc26                	sd	s1,56(sp)
    80001ffe:	f84a                	sd	s2,48(sp)
    80002000:	f44e                	sd	s3,40(sp)
    80002002:	f052                	sd	s4,32(sp)
    80002004:	ec56                	sd	s5,24(sp)
    80002006:	e85a                	sd	s6,16(sp)
    80002008:	e45e                	sd	s7,8(sp)
    8000200a:	e062                	sd	s8,0(sp)
    8000200c:	0880                	addi	s0,sp,80
    8000200e:	84aa                	mv	s1,a0
    80002010:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80002012:	00000097          	auipc	ra,0x0
    80002016:	c2e080e7          	jalr	-978(ra) # 80001c40 <myproc>
        return result;
    8000201a:	4901                	li	s2,0
    if (count == 0)
    8000201c:	0c0b8663          	beqz	s7,800020e8 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80002020:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80002024:	003b951b          	slliw	a0,s7,0x3
    80002028:	0175053b          	addw	a0,a0,s7
    8000202c:	0025151b          	slliw	a0,a0,0x2
    80002030:	2501                	sext.w	a0,a0
    80002032:	00000097          	auipc	ra,0x0
    80002036:	f68080e7          	jalr	-152(ra) # 80001f9a <growproc>
    8000203a:	12054f63          	bltz	a0,80002178 <ps+0x182>
    struct user_proc loc_result[count];
    8000203e:	003b9a13          	slli	s4,s7,0x3
    80002042:	9a5e                	add	s4,s4,s7
    80002044:	0a0a                	slli	s4,s4,0x2
    80002046:	00fa0793          	addi	a5,s4,15
    8000204a:	8391                	srli	a5,a5,0x4
    8000204c:	0792                	slli	a5,a5,0x4
    8000204e:	40f10133          	sub	sp,sp,a5
    80002052:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    80002054:	17000793          	li	a5,368
    80002058:	02f484b3          	mul	s1,s1,a5
    8000205c:	00012797          	auipc	a5,0x12
    80002060:	af478793          	addi	a5,a5,-1292 # 80013b50 <proc>
    80002064:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002066:	00017797          	auipc	a5,0x17
    8000206a:	6ea78793          	addi	a5,a5,1770 # 80019750 <tickslock>
        return result;
    8000206e:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80002070:	06f4fc63          	bgeu	s1,a5,800020e8 <ps+0xf2>
    acquire(&wait_lock);
    80002074:	00012517          	auipc	a0,0x12
    80002078:	ac450513          	addi	a0,a0,-1340 # 80013b38 <wait_lock>
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	bbc080e7          	jalr	-1092(ra) # 80000c38 <acquire>
        if (localCount == count)
    80002084:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    80002088:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    8000208a:	00017c17          	auipc	s8,0x17
    8000208e:	6c6c0c13          	addi	s8,s8,1734 # 80019750 <tickslock>
    80002092:	a851                	j	80002126 <ps+0x130>
            loc_result[localCount].state = UNUSED;
    80002094:	00399793          	slli	a5,s3,0x3
    80002098:	97ce                	add	a5,a5,s3
    8000209a:	078a                	slli	a5,a5,0x2
    8000209c:	97d6                	add	a5,a5,s5
    8000209e:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800020a2:	8526                	mv	a0,s1
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	c48080e7          	jalr	-952(ra) # 80000cec <release>
    release(&wait_lock);
    800020ac:	00012517          	auipc	a0,0x12
    800020b0:	a8c50513          	addi	a0,a0,-1396 # 80013b38 <wait_lock>
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	c38080e7          	jalr	-968(ra) # 80000cec <release>
    if (localCount < count)
    800020bc:	0179f963          	bgeu	s3,s7,800020ce <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    800020c0:	00399793          	slli	a5,s3,0x3
    800020c4:	97ce                	add	a5,a5,s3
    800020c6:	078a                	slli	a5,a5,0x2
    800020c8:	97d6                	add	a5,a5,s5
    800020ca:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    800020ce:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	b70080e7          	jalr	-1168(ra) # 80001c40 <myproc>
    800020d8:	86d2                	mv	a3,s4
    800020da:	8656                	mv	a2,s5
    800020dc:	85da                	mv	a1,s6
    800020de:	6928                	ld	a0,80(a0)
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	602080e7          	jalr	1538(ra) # 800016e2 <copyout>
}
    800020e8:	854a                	mv	a0,s2
    800020ea:	fb040113          	addi	sp,s0,-80
    800020ee:	60a6                	ld	ra,72(sp)
    800020f0:	6406                	ld	s0,64(sp)
    800020f2:	74e2                	ld	s1,56(sp)
    800020f4:	7942                	ld	s2,48(sp)
    800020f6:	79a2                	ld	s3,40(sp)
    800020f8:	7a02                	ld	s4,32(sp)
    800020fa:	6ae2                	ld	s5,24(sp)
    800020fc:	6b42                	ld	s6,16(sp)
    800020fe:	6ba2                	ld	s7,8(sp)
    80002100:	6c02                	ld	s8,0(sp)
    80002102:	6161                	addi	sp,sp,80
    80002104:	8082                	ret
        release(&p->lock);
    80002106:	8526                	mv	a0,s1
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	be4080e7          	jalr	-1052(ra) # 80000cec <release>
        localCount++;
    80002110:	2985                	addiw	s3,s3,1
    80002112:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    80002116:	17048493          	addi	s1,s1,368
    8000211a:	f984f9e3          	bgeu	s1,s8,800020ac <ps+0xb6>
        if (localCount == count)
    8000211e:	02490913          	addi	s2,s2,36
    80002122:	053b8d63          	beq	s7,s3,8000217c <ps+0x186>
        acquire(&p->lock);
    80002126:	8526                	mv	a0,s1
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	b10080e7          	jalr	-1264(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80002130:	4c9c                	lw	a5,24(s1)
    80002132:	d3ad                	beqz	a5,80002094 <ps+0x9e>
        loc_result[localCount].state = p->state;
    80002134:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002138:	549c                	lw	a5,40(s1)
    8000213a:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    8000213e:	54dc                	lw	a5,44(s1)
    80002140:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    80002144:	589c                	lw	a5,48(s1)
    80002146:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    8000214a:	4641                	li	a2,16
    8000214c:	85ca                	mv	a1,s2
    8000214e:	15848513          	addi	a0,s1,344
    80002152:	00000097          	auipc	ra,0x0
    80002156:	a9e080e7          	jalr	-1378(ra) # 80001bf0 <copy_array>
        if (p->parent != 0) // init
    8000215a:	7c88                	ld	a0,56(s1)
    8000215c:	d54d                	beqz	a0,80002106 <ps+0x110>
            acquire(&p->parent->lock);
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	ada080e7          	jalr	-1318(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80002166:	7c88                	ld	a0,56(s1)
    80002168:	591c                	lw	a5,48(a0)
    8000216a:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	b7e080e7          	jalr	-1154(ra) # 80000cec <release>
    80002176:	bf41                	j	80002106 <ps+0x110>
        return result;
    80002178:	4901                	li	s2,0
    8000217a:	b7bd                	j	800020e8 <ps+0xf2>
    release(&wait_lock);
    8000217c:	00012517          	auipc	a0,0x12
    80002180:	9bc50513          	addi	a0,a0,-1604 # 80013b38 <wait_lock>
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	b68080e7          	jalr	-1176(ra) # 80000cec <release>
    if (localCount < count)
    8000218c:	b789                	j	800020ce <ps+0xd8>

000000008000218e <fork>:
{
    8000218e:	7139                	addi	sp,sp,-64
    80002190:	fc06                	sd	ra,56(sp)
    80002192:	f822                	sd	s0,48(sp)
    80002194:	f04a                	sd	s2,32(sp)
    80002196:	e456                	sd	s5,8(sp)
    80002198:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	aa6080e7          	jalr	-1370(ra) # 80001c40 <myproc>
    800021a2:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	ca6080e7          	jalr	-858(ra) # 80001e4a <allocproc>
    800021ac:	12050063          	beqz	a0,800022cc <fork+0x13e>
    800021b0:	e852                	sd	s4,16(sp)
    800021b2:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800021b4:	048ab603          	ld	a2,72(s5)
    800021b8:	692c                	ld	a1,80(a0)
    800021ba:	050ab503          	ld	a0,80(s5)
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	420080e7          	jalr	1056(ra) # 800015de <uvmcopy>
    800021c6:	04054a63          	bltz	a0,8000221a <fork+0x8c>
    800021ca:	f426                	sd	s1,40(sp)
    800021cc:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800021ce:	048ab783          	ld	a5,72(s5)
    800021d2:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800021d6:	058ab683          	ld	a3,88(s5)
    800021da:	87b6                	mv	a5,a3
    800021dc:	058a3703          	ld	a4,88(s4)
    800021e0:	12068693          	addi	a3,a3,288
    800021e4:	0007b803          	ld	a6,0(a5)
    800021e8:	6788                	ld	a0,8(a5)
    800021ea:	6b8c                	ld	a1,16(a5)
    800021ec:	6f90                	ld	a2,24(a5)
    800021ee:	01073023          	sd	a6,0(a4)
    800021f2:	e708                	sd	a0,8(a4)
    800021f4:	eb0c                	sd	a1,16(a4)
    800021f6:	ef10                	sd	a2,24(a4)
    800021f8:	02078793          	addi	a5,a5,32
    800021fc:	02070713          	addi	a4,a4,32
    80002200:	fed792e3          	bne	a5,a3,800021e4 <fork+0x56>
    np->trapframe->a0 = 0;
    80002204:	058a3783          	ld	a5,88(s4)
    80002208:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000220c:	0d0a8493          	addi	s1,s5,208
    80002210:	0d0a0913          	addi	s2,s4,208
    80002214:	150a8993          	addi	s3,s5,336
    80002218:	a015                	j	8000223c <fork+0xae>
        freeproc(np);
    8000221a:	8552                	mv	a0,s4
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	bd6080e7          	jalr	-1066(ra) # 80001df2 <freeproc>
        release(&np->lock);
    80002224:	8552                	mv	a0,s4
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	ac6080e7          	jalr	-1338(ra) # 80000cec <release>
        return -1;
    8000222e:	597d                	li	s2,-1
    80002230:	6a42                	ld	s4,16(sp)
    80002232:	a071                	j	800022be <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002234:	04a1                	addi	s1,s1,8
    80002236:	0921                	addi	s2,s2,8
    80002238:	01348b63          	beq	s1,s3,8000224e <fork+0xc0>
        if (p->ofile[i])
    8000223c:	6088                	ld	a0,0(s1)
    8000223e:	d97d                	beqz	a0,80002234 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002240:	00003097          	auipc	ra,0x3
    80002244:	814080e7          	jalr	-2028(ra) # 80004a54 <filedup>
    80002248:	00a93023          	sd	a0,0(s2)
    8000224c:	b7e5                	j	80002234 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000224e:	150ab503          	ld	a0,336(s5)
    80002252:	00002097          	auipc	ra,0x2
    80002256:	97e080e7          	jalr	-1666(ra) # 80003bd0 <idup>
    8000225a:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000225e:	4641                	li	a2,16
    80002260:	158a8593          	addi	a1,s5,344
    80002264:	158a0513          	addi	a0,s4,344
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	c0e080e7          	jalr	-1010(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    80002270:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002274:	8552                	mv	a0,s4
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	a76080e7          	jalr	-1418(ra) # 80000cec <release>
    acquire(&wait_lock);
    8000227e:	00012497          	auipc	s1,0x12
    80002282:	8ba48493          	addi	s1,s1,-1862 # 80013b38 <wait_lock>
    80002286:	8526                	mv	a0,s1
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	9b0080e7          	jalr	-1616(ra) # 80000c38 <acquire>
    np->parent = p;
    80002290:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80002294:	8526                	mv	a0,s1
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	a56080e7          	jalr	-1450(ra) # 80000cec <release>
    acquire(&np->lock);
    8000229e:	8552                	mv	a0,s4
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	998080e7          	jalr	-1640(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    800022a8:	478d                	li	a5,3
    800022aa:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800022ae:	8552                	mv	a0,s4
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	a3c080e7          	jalr	-1476(ra) # 80000cec <release>
    return pid;
    800022b8:	74a2                	ld	s1,40(sp)
    800022ba:	69e2                	ld	s3,24(sp)
    800022bc:	6a42                	ld	s4,16(sp)
}
    800022be:	854a                	mv	a0,s2
    800022c0:	70e2                	ld	ra,56(sp)
    800022c2:	7442                	ld	s0,48(sp)
    800022c4:	7902                	ld	s2,32(sp)
    800022c6:	6aa2                	ld	s5,8(sp)
    800022c8:	6121                	addi	sp,sp,64
    800022ca:	8082                	ret
        return -1;
    800022cc:	597d                	li	s2,-1
    800022ce:	bfc5                	j	800022be <fork+0x130>

00000000800022d0 <scheduler>:
{
    800022d0:	1101                	addi	sp,sp,-32
    800022d2:	ec06                	sd	ra,24(sp)
    800022d4:	e822                	sd	s0,16(sp)
    800022d6:	e426                	sd	s1,8(sp)
    800022d8:	e04a                	sd	s2,0(sp)
    800022da:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    800022dc:	00009797          	auipc	a5,0x9
    800022e0:	0ec7b783          	ld	a5,236(a5) # 8000b3c8 <sched_pointer>
        if (old_scheduler != sched_pointer)
    800022e4:	00009497          	auipc	s1,0x9
    800022e8:	0e448493          	addi	s1,s1,228 # 8000b3c8 <sched_pointer>
            printf("Scheduler switched\n");
    800022ec:	00006917          	auipc	s2,0x6
    800022f0:	f0c90913          	addi	s2,s2,-244 # 800081f8 <etext+0x1f8>
    800022f4:	a809                	j	80002306 <scheduler+0x36>
    800022f6:	854a                	mv	a0,s2
    800022f8:	ffffe097          	auipc	ra,0xffffe
    800022fc:	2b2080e7          	jalr	690(ra) # 800005aa <printf>
        (*sched_pointer)();
    80002300:	609c                	ld	a5,0(s1)
    80002302:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    80002304:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    80002306:	6098                	ld	a4,0(s1)
    80002308:	fef717e3          	bne	a4,a5,800022f6 <scheduler+0x26>
    8000230c:	bfd5                	j	80002300 <scheduler+0x30>

000000008000230e <sched>:
{
    8000230e:	7179                	addi	sp,sp,-48
    80002310:	f406                	sd	ra,40(sp)
    80002312:	f022                	sd	s0,32(sp)
    80002314:	ec26                	sd	s1,24(sp)
    80002316:	e84a                	sd	s2,16(sp)
    80002318:	e44e                	sd	s3,8(sp)
    8000231a:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8000231c:	00000097          	auipc	ra,0x0
    80002320:	924080e7          	jalr	-1756(ra) # 80001c40 <myproc>
    80002324:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	898080e7          	jalr	-1896(ra) # 80000bbe <holding>
    8000232e:	c53d                	beqz	a0,8000239c <sched+0x8e>
    80002330:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002332:	2781                	sext.w	a5,a5
    80002334:	079e                	slli	a5,a5,0x7
    80002336:	00011717          	auipc	a4,0x11
    8000233a:	3ea70713          	addi	a4,a4,1002 # 80013720 <cpus>
    8000233e:	97ba                	add	a5,a5,a4
    80002340:	5fb8                	lw	a4,120(a5)
    80002342:	4785                	li	a5,1
    80002344:	06f71463          	bne	a4,a5,800023ac <sched+0x9e>
    if (p->state == RUNNING)
    80002348:	4c98                	lw	a4,24(s1)
    8000234a:	4791                	li	a5,4
    8000234c:	06f70863          	beq	a4,a5,800023bc <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002350:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002354:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002356:	ebbd                	bnez	a5,800023cc <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002358:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000235a:	00011917          	auipc	s2,0x11
    8000235e:	3c690913          	addi	s2,s2,966 # 80013720 <cpus>
    80002362:	2781                	sext.w	a5,a5
    80002364:	079e                	slli	a5,a5,0x7
    80002366:	97ca                	add	a5,a5,s2
    80002368:	07c7a983          	lw	s3,124(a5)
    8000236c:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000236e:	2581                	sext.w	a1,a1
    80002370:	059e                	slli	a1,a1,0x7
    80002372:	05a1                	addi	a1,a1,8
    80002374:	95ca                	add	a1,a1,s2
    80002376:	06048513          	addi	a0,s1,96
    8000237a:	00000097          	auipc	ra,0x0
    8000237e:	748080e7          	jalr	1864(ra) # 80002ac2 <swtch>
    80002382:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002384:	2781                	sext.w	a5,a5
    80002386:	079e                	slli	a5,a5,0x7
    80002388:	993e                	add	s2,s2,a5
    8000238a:	07392e23          	sw	s3,124(s2)
}
    8000238e:	70a2                	ld	ra,40(sp)
    80002390:	7402                	ld	s0,32(sp)
    80002392:	64e2                	ld	s1,24(sp)
    80002394:	6942                	ld	s2,16(sp)
    80002396:	69a2                	ld	s3,8(sp)
    80002398:	6145                	addi	sp,sp,48
    8000239a:	8082                	ret
        panic("sched p->lock");
    8000239c:	00006517          	auipc	a0,0x6
    800023a0:	e7450513          	addi	a0,a0,-396 # 80008210 <etext+0x210>
    800023a4:	ffffe097          	auipc	ra,0xffffe
    800023a8:	1bc080e7          	jalr	444(ra) # 80000560 <panic>
        panic("sched locks");
    800023ac:	00006517          	auipc	a0,0x6
    800023b0:	e7450513          	addi	a0,a0,-396 # 80008220 <etext+0x220>
    800023b4:	ffffe097          	auipc	ra,0xffffe
    800023b8:	1ac080e7          	jalr	428(ra) # 80000560 <panic>
        panic("sched running");
    800023bc:	00006517          	auipc	a0,0x6
    800023c0:	e7450513          	addi	a0,a0,-396 # 80008230 <etext+0x230>
    800023c4:	ffffe097          	auipc	ra,0xffffe
    800023c8:	19c080e7          	jalr	412(ra) # 80000560 <panic>
        panic("sched interruptible");
    800023cc:	00006517          	auipc	a0,0x6
    800023d0:	e7450513          	addi	a0,a0,-396 # 80008240 <etext+0x240>
    800023d4:	ffffe097          	auipc	ra,0xffffe
    800023d8:	18c080e7          	jalr	396(ra) # 80000560 <panic>

00000000800023dc <yield>:
{
    800023dc:	1101                	addi	sp,sp,-32
    800023de:	ec06                	sd	ra,24(sp)
    800023e0:	e822                	sd	s0,16(sp)
    800023e2:	e426                	sd	s1,8(sp)
    800023e4:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800023e6:	00000097          	auipc	ra,0x0
    800023ea:	85a080e7          	jalr	-1958(ra) # 80001c40 <myproc>
    800023ee:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	848080e7          	jalr	-1976(ra) # 80000c38 <acquire>
    p->state = RUNNABLE;
    800023f8:	478d                	li	a5,3
    800023fa:	cc9c                	sw	a5,24(s1)
    sched();
    800023fc:	00000097          	auipc	ra,0x0
    80002400:	f12080e7          	jalr	-238(ra) # 8000230e <sched>
    release(&p->lock);
    80002404:	8526                	mv	a0,s1
    80002406:	fffff097          	auipc	ra,0xfffff
    8000240a:	8e6080e7          	jalr	-1818(ra) # 80000cec <release>
}
    8000240e:	60e2                	ld	ra,24(sp)
    80002410:	6442                	ld	s0,16(sp)
    80002412:	64a2                	ld	s1,8(sp)
    80002414:	6105                	addi	sp,sp,32
    80002416:	8082                	ret

0000000080002418 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002418:	7179                	addi	sp,sp,-48
    8000241a:	f406                	sd	ra,40(sp)
    8000241c:	f022                	sd	s0,32(sp)
    8000241e:	ec26                	sd	s1,24(sp)
    80002420:	e84a                	sd	s2,16(sp)
    80002422:	e44e                	sd	s3,8(sp)
    80002424:	1800                	addi	s0,sp,48
    80002426:	89aa                	mv	s3,a0
    80002428:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000242a:	00000097          	auipc	ra,0x0
    8000242e:	816080e7          	jalr	-2026(ra) # 80001c40 <myproc>
    80002432:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	804080e7          	jalr	-2044(ra) # 80000c38 <acquire>
    release(lk);
    8000243c:	854a                	mv	a0,s2
    8000243e:	fffff097          	auipc	ra,0xfffff
    80002442:	8ae080e7          	jalr	-1874(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    80002446:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000244a:	4789                	li	a5,2
    8000244c:	cc9c                	sw	a5,24(s1)

    sched();
    8000244e:	00000097          	auipc	ra,0x0
    80002452:	ec0080e7          	jalr	-320(ra) # 8000230e <sched>

    // Tidy up.
    p->chan = 0;
    80002456:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000245a:	8526                	mv	a0,s1
    8000245c:	fffff097          	auipc	ra,0xfffff
    80002460:	890080e7          	jalr	-1904(ra) # 80000cec <release>
    acquire(lk);
    80002464:	854a                	mv	a0,s2
    80002466:	ffffe097          	auipc	ra,0xffffe
    8000246a:	7d2080e7          	jalr	2002(ra) # 80000c38 <acquire>
}
    8000246e:	70a2                	ld	ra,40(sp)
    80002470:	7402                	ld	s0,32(sp)
    80002472:	64e2                	ld	s1,24(sp)
    80002474:	6942                	ld	s2,16(sp)
    80002476:	69a2                	ld	s3,8(sp)
    80002478:	6145                	addi	sp,sp,48
    8000247a:	8082                	ret

000000008000247c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000247c:	7139                	addi	sp,sp,-64
    8000247e:	fc06                	sd	ra,56(sp)
    80002480:	f822                	sd	s0,48(sp)
    80002482:	f426                	sd	s1,40(sp)
    80002484:	f04a                	sd	s2,32(sp)
    80002486:	ec4e                	sd	s3,24(sp)
    80002488:	e852                	sd	s4,16(sp)
    8000248a:	e456                	sd	s5,8(sp)
    8000248c:	0080                	addi	s0,sp,64
    8000248e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002490:	00011497          	auipc	s1,0x11
    80002494:	6c048493          	addi	s1,s1,1728 # 80013b50 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002498:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000249a:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000249c:	00017917          	auipc	s2,0x17
    800024a0:	2b490913          	addi	s2,s2,692 # 80019750 <tickslock>
    800024a4:	a811                	j	800024b8 <wakeup+0x3c>
            }
            release(&p->lock);
    800024a6:	8526                	mv	a0,s1
    800024a8:	fffff097          	auipc	ra,0xfffff
    800024ac:	844080e7          	jalr	-1980(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800024b0:	17048493          	addi	s1,s1,368
    800024b4:	03248663          	beq	s1,s2,800024e0 <wakeup+0x64>
        if (p != myproc())
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	788080e7          	jalr	1928(ra) # 80001c40 <myproc>
    800024c0:	fea488e3          	beq	s1,a0,800024b0 <wakeup+0x34>
            acquire(&p->lock);
    800024c4:	8526                	mv	a0,s1
    800024c6:	ffffe097          	auipc	ra,0xffffe
    800024ca:	772080e7          	jalr	1906(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800024ce:	4c9c                	lw	a5,24(s1)
    800024d0:	fd379be3          	bne	a5,s3,800024a6 <wakeup+0x2a>
    800024d4:	709c                	ld	a5,32(s1)
    800024d6:	fd4798e3          	bne	a5,s4,800024a6 <wakeup+0x2a>
                p->state = RUNNABLE;
    800024da:	0154ac23          	sw	s5,24(s1)
    800024de:	b7e1                	j	800024a6 <wakeup+0x2a>
        }
    }
}
    800024e0:	70e2                	ld	ra,56(sp)
    800024e2:	7442                	ld	s0,48(sp)
    800024e4:	74a2                	ld	s1,40(sp)
    800024e6:	7902                	ld	s2,32(sp)
    800024e8:	69e2                	ld	s3,24(sp)
    800024ea:	6a42                	ld	s4,16(sp)
    800024ec:	6aa2                	ld	s5,8(sp)
    800024ee:	6121                	addi	sp,sp,64
    800024f0:	8082                	ret

00000000800024f2 <reparent>:
{
    800024f2:	7179                	addi	sp,sp,-48
    800024f4:	f406                	sd	ra,40(sp)
    800024f6:	f022                	sd	s0,32(sp)
    800024f8:	ec26                	sd	s1,24(sp)
    800024fa:	e84a                	sd	s2,16(sp)
    800024fc:	e44e                	sd	s3,8(sp)
    800024fe:	e052                	sd	s4,0(sp)
    80002500:	1800                	addi	s0,sp,48
    80002502:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002504:	00011497          	auipc	s1,0x11
    80002508:	64c48493          	addi	s1,s1,1612 # 80013b50 <proc>
            pp->parent = initproc;
    8000250c:	00009a17          	auipc	s4,0x9
    80002510:	f9ca0a13          	addi	s4,s4,-100 # 8000b4a8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002514:	00017997          	auipc	s3,0x17
    80002518:	23c98993          	addi	s3,s3,572 # 80019750 <tickslock>
    8000251c:	a029                	j	80002526 <reparent+0x34>
    8000251e:	17048493          	addi	s1,s1,368
    80002522:	01348d63          	beq	s1,s3,8000253c <reparent+0x4a>
        if (pp->parent == p)
    80002526:	7c9c                	ld	a5,56(s1)
    80002528:	ff279be3          	bne	a5,s2,8000251e <reparent+0x2c>
            pp->parent = initproc;
    8000252c:	000a3503          	ld	a0,0(s4)
    80002530:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002532:	00000097          	auipc	ra,0x0
    80002536:	f4a080e7          	jalr	-182(ra) # 8000247c <wakeup>
    8000253a:	b7d5                	j	8000251e <reparent+0x2c>
}
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6a02                	ld	s4,0(sp)
    80002548:	6145                	addi	sp,sp,48
    8000254a:	8082                	ret

000000008000254c <exit>:
{
    8000254c:	7179                	addi	sp,sp,-48
    8000254e:	f406                	sd	ra,40(sp)
    80002550:	f022                	sd	s0,32(sp)
    80002552:	ec26                	sd	s1,24(sp)
    80002554:	e84a                	sd	s2,16(sp)
    80002556:	e44e                	sd	s3,8(sp)
    80002558:	e052                	sd	s4,0(sp)
    8000255a:	1800                	addi	s0,sp,48
    8000255c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000255e:	fffff097          	auipc	ra,0xfffff
    80002562:	6e2080e7          	jalr	1762(ra) # 80001c40 <myproc>
    80002566:	89aa                	mv	s3,a0
    if (p == initproc)
    80002568:	00009797          	auipc	a5,0x9
    8000256c:	f407b783          	ld	a5,-192(a5) # 8000b4a8 <initproc>
    80002570:	0d050493          	addi	s1,a0,208
    80002574:	15050913          	addi	s2,a0,336
    80002578:	02a79363          	bne	a5,a0,8000259e <exit+0x52>
        panic("init exiting");
    8000257c:	00006517          	auipc	a0,0x6
    80002580:	cdc50513          	addi	a0,a0,-804 # 80008258 <etext+0x258>
    80002584:	ffffe097          	auipc	ra,0xffffe
    80002588:	fdc080e7          	jalr	-36(ra) # 80000560 <panic>
            fileclose(f);
    8000258c:	00002097          	auipc	ra,0x2
    80002590:	51a080e7          	jalr	1306(ra) # 80004aa6 <fileclose>
            p->ofile[fd] = 0;
    80002594:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80002598:	04a1                	addi	s1,s1,8
    8000259a:	01248563          	beq	s1,s2,800025a4 <exit+0x58>
        if (p->ofile[fd])
    8000259e:	6088                	ld	a0,0(s1)
    800025a0:	f575                	bnez	a0,8000258c <exit+0x40>
    800025a2:	bfdd                	j	80002598 <exit+0x4c>
    begin_op();
    800025a4:	00002097          	auipc	ra,0x2
    800025a8:	038080e7          	jalr	56(ra) # 800045dc <begin_op>
    iput(p->cwd);
    800025ac:	1509b503          	ld	a0,336(s3)
    800025b0:	00002097          	auipc	ra,0x2
    800025b4:	81c080e7          	jalr	-2020(ra) # 80003dcc <iput>
    end_op();
    800025b8:	00002097          	auipc	ra,0x2
    800025bc:	09e080e7          	jalr	158(ra) # 80004656 <end_op>
    p->cwd = 0;
    800025c0:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800025c4:	00011497          	auipc	s1,0x11
    800025c8:	57448493          	addi	s1,s1,1396 # 80013b38 <wait_lock>
    800025cc:	8526                	mv	a0,s1
    800025ce:	ffffe097          	auipc	ra,0xffffe
    800025d2:	66a080e7          	jalr	1642(ra) # 80000c38 <acquire>
    reparent(p);
    800025d6:	854e                	mv	a0,s3
    800025d8:	00000097          	auipc	ra,0x0
    800025dc:	f1a080e7          	jalr	-230(ra) # 800024f2 <reparent>
    wakeup(p->parent);
    800025e0:	0389b503          	ld	a0,56(s3)
    800025e4:	00000097          	auipc	ra,0x0
    800025e8:	e98080e7          	jalr	-360(ra) # 8000247c <wakeup>
    acquire(&p->lock);
    800025ec:	854e                	mv	a0,s3
    800025ee:	ffffe097          	auipc	ra,0xffffe
    800025f2:	64a080e7          	jalr	1610(ra) # 80000c38 <acquire>
    p->xstate = status;
    800025f6:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800025fa:	4795                	li	a5,5
    800025fc:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80002600:	8526                	mv	a0,s1
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	6ea080e7          	jalr	1770(ra) # 80000cec <release>
    sched();
    8000260a:	00000097          	auipc	ra,0x0
    8000260e:	d04080e7          	jalr	-764(ra) # 8000230e <sched>
    panic("zombie exit");
    80002612:	00006517          	auipc	a0,0x6
    80002616:	c5650513          	addi	a0,a0,-938 # 80008268 <etext+0x268>
    8000261a:	ffffe097          	auipc	ra,0xffffe
    8000261e:	f46080e7          	jalr	-186(ra) # 80000560 <panic>

0000000080002622 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002622:	7179                	addi	sp,sp,-48
    80002624:	f406                	sd	ra,40(sp)
    80002626:	f022                	sd	s0,32(sp)
    80002628:	ec26                	sd	s1,24(sp)
    8000262a:	e84a                	sd	s2,16(sp)
    8000262c:	e44e                	sd	s3,8(sp)
    8000262e:	1800                	addi	s0,sp,48
    80002630:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002632:	00011497          	auipc	s1,0x11
    80002636:	51e48493          	addi	s1,s1,1310 # 80013b50 <proc>
    8000263a:	00017997          	auipc	s3,0x17
    8000263e:	11698993          	addi	s3,s3,278 # 80019750 <tickslock>
    {
        acquire(&p->lock);
    80002642:	8526                	mv	a0,s1
    80002644:	ffffe097          	auipc	ra,0xffffe
    80002648:	5f4080e7          	jalr	1524(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    8000264c:	589c                	lw	a5,48(s1)
    8000264e:	01278d63          	beq	a5,s2,80002668 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002652:	8526                	mv	a0,s1
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	698080e7          	jalr	1688(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000265c:	17048493          	addi	s1,s1,368
    80002660:	ff3491e3          	bne	s1,s3,80002642 <kill+0x20>
    }
    return -1;
    80002664:	557d                	li	a0,-1
    80002666:	a829                	j	80002680 <kill+0x5e>
            p->killed = 1;
    80002668:	4785                	li	a5,1
    8000266a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000266c:	4c98                	lw	a4,24(s1)
    8000266e:	4789                	li	a5,2
    80002670:	00f70f63          	beq	a4,a5,8000268e <kill+0x6c>
            release(&p->lock);
    80002674:	8526                	mv	a0,s1
    80002676:	ffffe097          	auipc	ra,0xffffe
    8000267a:	676080e7          	jalr	1654(ra) # 80000cec <release>
            return 0;
    8000267e:	4501                	li	a0,0
}
    80002680:	70a2                	ld	ra,40(sp)
    80002682:	7402                	ld	s0,32(sp)
    80002684:	64e2                	ld	s1,24(sp)
    80002686:	6942                	ld	s2,16(sp)
    80002688:	69a2                	ld	s3,8(sp)
    8000268a:	6145                	addi	sp,sp,48
    8000268c:	8082                	ret
                p->state = RUNNABLE;
    8000268e:	478d                	li	a5,3
    80002690:	cc9c                	sw	a5,24(s1)
    80002692:	b7cd                	j	80002674 <kill+0x52>

0000000080002694 <setkilled>:

void setkilled(struct proc *p)
{
    80002694:	1101                	addi	sp,sp,-32
    80002696:	ec06                	sd	ra,24(sp)
    80002698:	e822                	sd	s0,16(sp)
    8000269a:	e426                	sd	s1,8(sp)
    8000269c:	1000                	addi	s0,sp,32
    8000269e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800026a0:	ffffe097          	auipc	ra,0xffffe
    800026a4:	598080e7          	jalr	1432(ra) # 80000c38 <acquire>
    p->killed = 1;
    800026a8:	4785                	li	a5,1
    800026aa:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800026ac:	8526                	mv	a0,s1
    800026ae:	ffffe097          	auipc	ra,0xffffe
    800026b2:	63e080e7          	jalr	1598(ra) # 80000cec <release>
}
    800026b6:	60e2                	ld	ra,24(sp)
    800026b8:	6442                	ld	s0,16(sp)
    800026ba:	64a2                	ld	s1,8(sp)
    800026bc:	6105                	addi	sp,sp,32
    800026be:	8082                	ret

00000000800026c0 <killed>:

int killed(struct proc *p)
{
    800026c0:	1101                	addi	sp,sp,-32
    800026c2:	ec06                	sd	ra,24(sp)
    800026c4:	e822                	sd	s0,16(sp)
    800026c6:	e426                	sd	s1,8(sp)
    800026c8:	e04a                	sd	s2,0(sp)
    800026ca:	1000                	addi	s0,sp,32
    800026cc:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800026ce:	ffffe097          	auipc	ra,0xffffe
    800026d2:	56a080e7          	jalr	1386(ra) # 80000c38 <acquire>
    k = p->killed;
    800026d6:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800026da:	8526                	mv	a0,s1
    800026dc:	ffffe097          	auipc	ra,0xffffe
    800026e0:	610080e7          	jalr	1552(ra) # 80000cec <release>
    return k;
}
    800026e4:	854a                	mv	a0,s2
    800026e6:	60e2                	ld	ra,24(sp)
    800026e8:	6442                	ld	s0,16(sp)
    800026ea:	64a2                	ld	s1,8(sp)
    800026ec:	6902                	ld	s2,0(sp)
    800026ee:	6105                	addi	sp,sp,32
    800026f0:	8082                	ret

00000000800026f2 <wait>:
{
    800026f2:	715d                	addi	sp,sp,-80
    800026f4:	e486                	sd	ra,72(sp)
    800026f6:	e0a2                	sd	s0,64(sp)
    800026f8:	fc26                	sd	s1,56(sp)
    800026fa:	f84a                	sd	s2,48(sp)
    800026fc:	f44e                	sd	s3,40(sp)
    800026fe:	f052                	sd	s4,32(sp)
    80002700:	ec56                	sd	s5,24(sp)
    80002702:	e85a                	sd	s6,16(sp)
    80002704:	e45e                	sd	s7,8(sp)
    80002706:	e062                	sd	s8,0(sp)
    80002708:	0880                	addi	s0,sp,80
    8000270a:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000270c:	fffff097          	auipc	ra,0xfffff
    80002710:	534080e7          	jalr	1332(ra) # 80001c40 <myproc>
    80002714:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002716:	00011517          	auipc	a0,0x11
    8000271a:	42250513          	addi	a0,a0,1058 # 80013b38 <wait_lock>
    8000271e:	ffffe097          	auipc	ra,0xffffe
    80002722:	51a080e7          	jalr	1306(ra) # 80000c38 <acquire>
        havekids = 0;
    80002726:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80002728:	4a15                	li	s4,5
                havekids = 1;
    8000272a:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000272c:	00017997          	auipc	s3,0x17
    80002730:	02498993          	addi	s3,s3,36 # 80019750 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002734:	00011c17          	auipc	s8,0x11
    80002738:	404c0c13          	addi	s8,s8,1028 # 80013b38 <wait_lock>
    8000273c:	a0d1                	j	80002800 <wait+0x10e>
                    pid = pp->pid;
    8000273e:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002742:	000b0e63          	beqz	s6,8000275e <wait+0x6c>
    80002746:	4691                	li	a3,4
    80002748:	02c48613          	addi	a2,s1,44
    8000274c:	85da                	mv	a1,s6
    8000274e:	05093503          	ld	a0,80(s2)
    80002752:	fffff097          	auipc	ra,0xfffff
    80002756:	f90080e7          	jalr	-112(ra) # 800016e2 <copyout>
    8000275a:	04054163          	bltz	a0,8000279c <wait+0xaa>
                    freeproc(pp);
    8000275e:	8526                	mv	a0,s1
    80002760:	fffff097          	auipc	ra,0xfffff
    80002764:	692080e7          	jalr	1682(ra) # 80001df2 <freeproc>
                    release(&pp->lock);
    80002768:	8526                	mv	a0,s1
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	582080e7          	jalr	1410(ra) # 80000cec <release>
                    release(&wait_lock);
    80002772:	00011517          	auipc	a0,0x11
    80002776:	3c650513          	addi	a0,a0,966 # 80013b38 <wait_lock>
    8000277a:	ffffe097          	auipc	ra,0xffffe
    8000277e:	572080e7          	jalr	1394(ra) # 80000cec <release>
}
    80002782:	854e                	mv	a0,s3
    80002784:	60a6                	ld	ra,72(sp)
    80002786:	6406                	ld	s0,64(sp)
    80002788:	74e2                	ld	s1,56(sp)
    8000278a:	7942                	ld	s2,48(sp)
    8000278c:	79a2                	ld	s3,40(sp)
    8000278e:	7a02                	ld	s4,32(sp)
    80002790:	6ae2                	ld	s5,24(sp)
    80002792:	6b42                	ld	s6,16(sp)
    80002794:	6ba2                	ld	s7,8(sp)
    80002796:	6c02                	ld	s8,0(sp)
    80002798:	6161                	addi	sp,sp,80
    8000279a:	8082                	ret
                        release(&pp->lock);
    8000279c:	8526                	mv	a0,s1
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	54e080e7          	jalr	1358(ra) # 80000cec <release>
                        release(&wait_lock);
    800027a6:	00011517          	auipc	a0,0x11
    800027aa:	39250513          	addi	a0,a0,914 # 80013b38 <wait_lock>
    800027ae:	ffffe097          	auipc	ra,0xffffe
    800027b2:	53e080e7          	jalr	1342(ra) # 80000cec <release>
                        return -1;
    800027b6:	59fd                	li	s3,-1
    800027b8:	b7e9                	j	80002782 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027ba:	17048493          	addi	s1,s1,368
    800027be:	03348463          	beq	s1,s3,800027e6 <wait+0xf4>
            if (pp->parent == p)
    800027c2:	7c9c                	ld	a5,56(s1)
    800027c4:	ff279be3          	bne	a5,s2,800027ba <wait+0xc8>
                acquire(&pp->lock);
    800027c8:	8526                	mv	a0,s1
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	46e080e7          	jalr	1134(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    800027d2:	4c9c                	lw	a5,24(s1)
    800027d4:	f74785e3          	beq	a5,s4,8000273e <wait+0x4c>
                release(&pp->lock);
    800027d8:	8526                	mv	a0,s1
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	512080e7          	jalr	1298(ra) # 80000cec <release>
                havekids = 1;
    800027e2:	8756                	mv	a4,s5
    800027e4:	bfd9                	j	800027ba <wait+0xc8>
        if (!havekids || killed(p))
    800027e6:	c31d                	beqz	a4,8000280c <wait+0x11a>
    800027e8:	854a                	mv	a0,s2
    800027ea:	00000097          	auipc	ra,0x0
    800027ee:	ed6080e7          	jalr	-298(ra) # 800026c0 <killed>
    800027f2:	ed09                	bnez	a0,8000280c <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800027f4:	85e2                	mv	a1,s8
    800027f6:	854a                	mv	a0,s2
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	c20080e7          	jalr	-992(ra) # 80002418 <sleep>
        havekids = 0;
    80002800:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002802:	00011497          	auipc	s1,0x11
    80002806:	34e48493          	addi	s1,s1,846 # 80013b50 <proc>
    8000280a:	bf65                	j	800027c2 <wait+0xd0>
            release(&wait_lock);
    8000280c:	00011517          	auipc	a0,0x11
    80002810:	32c50513          	addi	a0,a0,812 # 80013b38 <wait_lock>
    80002814:	ffffe097          	auipc	ra,0xffffe
    80002818:	4d8080e7          	jalr	1240(ra) # 80000cec <release>
            return -1;
    8000281c:	59fd                	li	s3,-1
    8000281e:	b795                	j	80002782 <wait+0x90>

0000000080002820 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002820:	7179                	addi	sp,sp,-48
    80002822:	f406                	sd	ra,40(sp)
    80002824:	f022                	sd	s0,32(sp)
    80002826:	ec26                	sd	s1,24(sp)
    80002828:	e84a                	sd	s2,16(sp)
    8000282a:	e44e                	sd	s3,8(sp)
    8000282c:	e052                	sd	s4,0(sp)
    8000282e:	1800                	addi	s0,sp,48
    80002830:	84aa                	mv	s1,a0
    80002832:	892e                	mv	s2,a1
    80002834:	89b2                	mv	s3,a2
    80002836:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002838:	fffff097          	auipc	ra,0xfffff
    8000283c:	408080e7          	jalr	1032(ra) # 80001c40 <myproc>
    if (user_dst)
    80002840:	c08d                	beqz	s1,80002862 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002842:	86d2                	mv	a3,s4
    80002844:	864e                	mv	a2,s3
    80002846:	85ca                	mv	a1,s2
    80002848:	6928                	ld	a0,80(a0)
    8000284a:	fffff097          	auipc	ra,0xfffff
    8000284e:	e98080e7          	jalr	-360(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002852:	70a2                	ld	ra,40(sp)
    80002854:	7402                	ld	s0,32(sp)
    80002856:	64e2                	ld	s1,24(sp)
    80002858:	6942                	ld	s2,16(sp)
    8000285a:	69a2                	ld	s3,8(sp)
    8000285c:	6a02                	ld	s4,0(sp)
    8000285e:	6145                	addi	sp,sp,48
    80002860:	8082                	ret
        memmove((char *)dst, src, len);
    80002862:	000a061b          	sext.w	a2,s4
    80002866:	85ce                	mv	a1,s3
    80002868:	854a                	mv	a0,s2
    8000286a:	ffffe097          	auipc	ra,0xffffe
    8000286e:	526080e7          	jalr	1318(ra) # 80000d90 <memmove>
        return 0;
    80002872:	8526                	mv	a0,s1
    80002874:	bff9                	j	80002852 <either_copyout+0x32>

0000000080002876 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002876:	7179                	addi	sp,sp,-48
    80002878:	f406                	sd	ra,40(sp)
    8000287a:	f022                	sd	s0,32(sp)
    8000287c:	ec26                	sd	s1,24(sp)
    8000287e:	e84a                	sd	s2,16(sp)
    80002880:	e44e                	sd	s3,8(sp)
    80002882:	e052                	sd	s4,0(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	892a                	mv	s2,a0
    80002888:	84ae                	mv	s1,a1
    8000288a:	89b2                	mv	s3,a2
    8000288c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000288e:	fffff097          	auipc	ra,0xfffff
    80002892:	3b2080e7          	jalr	946(ra) # 80001c40 <myproc>
    if (user_src)
    80002896:	c08d                	beqz	s1,800028b8 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002898:	86d2                	mv	a3,s4
    8000289a:	864e                	mv	a2,s3
    8000289c:	85ca                	mv	a1,s2
    8000289e:	6928                	ld	a0,80(a0)
    800028a0:	fffff097          	auipc	ra,0xfffff
    800028a4:	ece080e7          	jalr	-306(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800028a8:	70a2                	ld	ra,40(sp)
    800028aa:	7402                	ld	s0,32(sp)
    800028ac:	64e2                	ld	s1,24(sp)
    800028ae:	6942                	ld	s2,16(sp)
    800028b0:	69a2                	ld	s3,8(sp)
    800028b2:	6a02                	ld	s4,0(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret
        memmove(dst, (char *)src, len);
    800028b8:	000a061b          	sext.w	a2,s4
    800028bc:	85ce                	mv	a1,s3
    800028be:	854a                	mv	a0,s2
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	4d0080e7          	jalr	1232(ra) # 80000d90 <memmove>
        return 0;
    800028c8:	8526                	mv	a0,s1
    800028ca:	bff9                	j	800028a8 <either_copyin+0x32>

00000000800028cc <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800028cc:	715d                	addi	sp,sp,-80
    800028ce:	e486                	sd	ra,72(sp)
    800028d0:	e0a2                	sd	s0,64(sp)
    800028d2:	fc26                	sd	s1,56(sp)
    800028d4:	f84a                	sd	s2,48(sp)
    800028d6:	f44e                	sd	s3,40(sp)
    800028d8:	f052                	sd	s4,32(sp)
    800028da:	ec56                	sd	s5,24(sp)
    800028dc:	e85a                	sd	s6,16(sp)
    800028de:	e45e                	sd	s7,8(sp)
    800028e0:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800028e2:	00005517          	auipc	a0,0x5
    800028e6:	72e50513          	addi	a0,a0,1838 # 80008010 <etext+0x10>
    800028ea:	ffffe097          	auipc	ra,0xffffe
    800028ee:	cc0080e7          	jalr	-832(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800028f2:	00011497          	auipc	s1,0x11
    800028f6:	3b648493          	addi	s1,s1,950 # 80013ca8 <proc+0x158>
    800028fa:	00017917          	auipc	s2,0x17
    800028fe:	fae90913          	addi	s2,s2,-82 # 800198a8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002902:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002904:	00006997          	auipc	s3,0x6
    80002908:	97498993          	addi	s3,s3,-1676 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    8000290c:	00006a97          	auipc	s5,0x6
    80002910:	974a8a93          	addi	s5,s5,-1676 # 80008280 <etext+0x280>
        printf("\n");
    80002914:	00005a17          	auipc	s4,0x5
    80002918:	6fca0a13          	addi	s4,s4,1788 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000291c:	00006b97          	auipc	s7,0x6
    80002920:	f0cb8b93          	addi	s7,s7,-244 # 80008828 <states.0>
    80002924:	a00d                	j	80002946 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002926:	ed86a583          	lw	a1,-296(a3)
    8000292a:	8556                	mv	a0,s5
    8000292c:	ffffe097          	auipc	ra,0xffffe
    80002930:	c7e080e7          	jalr	-898(ra) # 800005aa <printf>
        printf("\n");
    80002934:	8552                	mv	a0,s4
    80002936:	ffffe097          	auipc	ra,0xffffe
    8000293a:	c74080e7          	jalr	-908(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    8000293e:	17048493          	addi	s1,s1,368
    80002942:	03248263          	beq	s1,s2,80002966 <procdump+0x9a>
        if (p->state == UNUSED)
    80002946:	86a6                	mv	a3,s1
    80002948:	ec04a783          	lw	a5,-320(s1)
    8000294c:	dbed                	beqz	a5,8000293e <procdump+0x72>
            state = "???";
    8000294e:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002950:	fcfb6be3          	bltu	s6,a5,80002926 <procdump+0x5a>
    80002954:	02079713          	slli	a4,a5,0x20
    80002958:	01d75793          	srli	a5,a4,0x1d
    8000295c:	97de                	add	a5,a5,s7
    8000295e:	6390                	ld	a2,0(a5)
    80002960:	f279                	bnez	a2,80002926 <procdump+0x5a>
            state = "???";
    80002962:	864e                	mv	a2,s3
    80002964:	b7c9                	j	80002926 <procdump+0x5a>
    }
}
    80002966:	60a6                	ld	ra,72(sp)
    80002968:	6406                	ld	s0,64(sp)
    8000296a:	74e2                	ld	s1,56(sp)
    8000296c:	7942                	ld	s2,48(sp)
    8000296e:	79a2                	ld	s3,40(sp)
    80002970:	7a02                	ld	s4,32(sp)
    80002972:	6ae2                	ld	s5,24(sp)
    80002974:	6b42                	ld	s6,16(sp)
    80002976:	6ba2                	ld	s7,8(sp)
    80002978:	6161                	addi	sp,sp,80
    8000297a:	8082                	ret

000000008000297c <schedls>:

void schedls()
{
    8000297c:	1101                	addi	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	e426                	sd	s1,8(sp)
    80002984:	1000                	addi	s0,sp,32
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002986:	00006517          	auipc	a0,0x6
    8000298a:	90a50513          	addi	a0,a0,-1782 # 80008290 <etext+0x290>
    8000298e:	ffffe097          	auipc	ra,0xffffe
    80002992:	c1c080e7          	jalr	-996(ra) # 800005aa <printf>
    printf("====================================\n");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	92250513          	addi	a0,a0,-1758 # 800082b8 <etext+0x2b8>
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	c0c080e7          	jalr	-1012(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    800029a6:	00009717          	auipc	a4,0x9
    800029aa:	a8273703          	ld	a4,-1406(a4) # 8000b428 <available_schedulers+0x10>
    800029ae:	00009797          	auipc	a5,0x9
    800029b2:	a1a7b783          	ld	a5,-1510(a5) # 8000b3c8 <sched_pointer>
    800029b6:	08f70763          	beq	a4,a5,80002a44 <schedls+0xc8>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	92650513          	addi	a0,a0,-1754 # 800082e0 <etext+0x2e0>
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	be8080e7          	jalr	-1048(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    800029ca:	00009497          	auipc	s1,0x9
    800029ce:	a1648493          	addi	s1,s1,-1514 # 8000b3e0 <initcode>
    800029d2:	48b0                	lw	a2,80(s1)
    800029d4:	00009597          	auipc	a1,0x9
    800029d8:	a4458593          	addi	a1,a1,-1468 # 8000b418 <available_schedulers>
    800029dc:	00006517          	auipc	a0,0x6
    800029e0:	91450513          	addi	a0,a0,-1772 # 800082f0 <etext+0x2f0>
    800029e4:	ffffe097          	auipc	ra,0xffffe
    800029e8:	bc6080e7          	jalr	-1082(ra) # 800005aa <printf>
        if (available_schedulers[i].impl == sched_pointer)
    800029ec:	74b8                	ld	a4,104(s1)
    800029ee:	00009797          	auipc	a5,0x9
    800029f2:	9da7b783          	ld	a5,-1574(a5) # 8000b3c8 <sched_pointer>
    800029f6:	06f70063          	beq	a4,a5,80002a56 <schedls+0xda>
            printf("   \t");
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	8e650513          	addi	a0,a0,-1818 # 800082e0 <etext+0x2e0>
    80002a02:	ffffe097          	auipc	ra,0xffffe
    80002a06:	ba8080e7          	jalr	-1112(ra) # 800005aa <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002a0a:	00009617          	auipc	a2,0x9
    80002a0e:	a4662603          	lw	a2,-1466(a2) # 8000b450 <available_schedulers+0x38>
    80002a12:	00009597          	auipc	a1,0x9
    80002a16:	a2658593          	addi	a1,a1,-1498 # 8000b438 <available_schedulers+0x20>
    80002a1a:	00006517          	auipc	a0,0x6
    80002a1e:	8d650513          	addi	a0,a0,-1834 # 800082f0 <etext+0x2f0>
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	b88080e7          	jalr	-1144(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002a2a:	00006517          	auipc	a0,0x6
    80002a2e:	8ce50513          	addi	a0,a0,-1842 # 800082f8 <etext+0x2f8>
    80002a32:	ffffe097          	auipc	ra,0xffffe
    80002a36:	b78080e7          	jalr	-1160(ra) # 800005aa <printf>
}
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	64a2                	ld	s1,8(sp)
    80002a40:	6105                	addi	sp,sp,32
    80002a42:	8082                	ret
            printf("[*]\t");
    80002a44:	00006517          	auipc	a0,0x6
    80002a48:	8a450513          	addi	a0,a0,-1884 # 800082e8 <etext+0x2e8>
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	b5e080e7          	jalr	-1186(ra) # 800005aa <printf>
    80002a54:	bf9d                	j	800029ca <schedls+0x4e>
    80002a56:	00006517          	auipc	a0,0x6
    80002a5a:	89250513          	addi	a0,a0,-1902 # 800082e8 <etext+0x2e8>
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	b4c080e7          	jalr	-1204(ra) # 800005aa <printf>
    80002a66:	b755                	j	80002a0a <schedls+0x8e>

0000000080002a68 <schedset>:

void schedset(int id)
{
    80002a68:	1141                	addi	sp,sp,-16
    80002a6a:	e406                	sd	ra,8(sp)
    80002a6c:	e022                	sd	s0,0(sp)
    80002a6e:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002a70:	4705                	li	a4,1
    80002a72:	02a76f63          	bltu	a4,a0,80002ab0 <schedset+0x48>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002a76:	00551793          	slli	a5,a0,0x5
    80002a7a:	00009717          	auipc	a4,0x9
    80002a7e:	96670713          	addi	a4,a4,-1690 # 8000b3e0 <initcode>
    80002a82:	973e                	add	a4,a4,a5
    80002a84:	6738                	ld	a4,72(a4)
    80002a86:	00009697          	auipc	a3,0x9
    80002a8a:	94e6b123          	sd	a4,-1726(a3) # 8000b3c8 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002a8e:	00009597          	auipc	a1,0x9
    80002a92:	98a58593          	addi	a1,a1,-1654 # 8000b418 <available_schedulers>
    80002a96:	95be                	add	a1,a1,a5
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	8a050513          	addi	a0,a0,-1888 # 80008338 <etext+0x338>
    80002aa0:	ffffe097          	auipc	ra,0xffffe
    80002aa4:	b0a080e7          	jalr	-1270(ra) # 800005aa <printf>
    80002aa8:	60a2                	ld	ra,8(sp)
    80002aaa:	6402                	ld	s0,0(sp)
    80002aac:	0141                	addi	sp,sp,16
    80002aae:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002ab0:	00006517          	auipc	a0,0x6
    80002ab4:	86050513          	addi	a0,a0,-1952 # 80008310 <etext+0x310>
    80002ab8:	ffffe097          	auipc	ra,0xffffe
    80002abc:	af2080e7          	jalr	-1294(ra) # 800005aa <printf>
        return;
    80002ac0:	b7e5                	j	80002aa8 <schedset+0x40>

0000000080002ac2 <swtch>:
    80002ac2:	00153023          	sd	ra,0(a0)
    80002ac6:	00253423          	sd	sp,8(a0)
    80002aca:	e900                	sd	s0,16(a0)
    80002acc:	ed04                	sd	s1,24(a0)
    80002ace:	03253023          	sd	s2,32(a0)
    80002ad2:	03353423          	sd	s3,40(a0)
    80002ad6:	03453823          	sd	s4,48(a0)
    80002ada:	03553c23          	sd	s5,56(a0)
    80002ade:	05653023          	sd	s6,64(a0)
    80002ae2:	05753423          	sd	s7,72(a0)
    80002ae6:	05853823          	sd	s8,80(a0)
    80002aea:	05953c23          	sd	s9,88(a0)
    80002aee:	07a53023          	sd	s10,96(a0)
    80002af2:	07b53423          	sd	s11,104(a0)
    80002af6:	0005b083          	ld	ra,0(a1)
    80002afa:	0085b103          	ld	sp,8(a1)
    80002afe:	6980                	ld	s0,16(a1)
    80002b00:	6d84                	ld	s1,24(a1)
    80002b02:	0205b903          	ld	s2,32(a1)
    80002b06:	0285b983          	ld	s3,40(a1)
    80002b0a:	0305ba03          	ld	s4,48(a1)
    80002b0e:	0385ba83          	ld	s5,56(a1)
    80002b12:	0405bb03          	ld	s6,64(a1)
    80002b16:	0485bb83          	ld	s7,72(a1)
    80002b1a:	0505bc03          	ld	s8,80(a1)
    80002b1e:	0585bc83          	ld	s9,88(a1)
    80002b22:	0605bd03          	ld	s10,96(a1)
    80002b26:	0685bd83          	ld	s11,104(a1)
    80002b2a:	8082                	ret

0000000080002b2c <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b2c:	1141                	addi	sp,sp,-16
    80002b2e:	e406                	sd	ra,8(sp)
    80002b30:	e022                	sd	s0,0(sp)
    80002b32:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002b34:	00006597          	auipc	a1,0x6
    80002b38:	85c58593          	addi	a1,a1,-1956 # 80008390 <etext+0x390>
    80002b3c:	00017517          	auipc	a0,0x17
    80002b40:	c1450513          	addi	a0,a0,-1004 # 80019750 <tickslock>
    80002b44:	ffffe097          	auipc	ra,0xffffe
    80002b48:	064080e7          	jalr	100(ra) # 80000ba8 <initlock>
}
    80002b4c:	60a2                	ld	ra,8(sp)
    80002b4e:	6402                	ld	s0,0(sp)
    80002b50:	0141                	addi	sp,sp,16
    80002b52:	8082                	ret

0000000080002b54 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002b54:	1141                	addi	sp,sp,-16
    80002b56:	e422                	sd	s0,8(sp)
    80002b58:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b5a:	00003797          	auipc	a5,0x3
    80002b5e:	65678793          	addi	a5,a5,1622 # 800061b0 <kernelvec>
    80002b62:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002b66:	6422                	ld	s0,8(sp)
    80002b68:	0141                	addi	sp,sp,16
    80002b6a:	8082                	ret

0000000080002b6c <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002b6c:	1141                	addi	sp,sp,-16
    80002b6e:	e406                	sd	ra,8(sp)
    80002b70:	e022                	sd	s0,0(sp)
    80002b72:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002b74:	fffff097          	auipc	ra,0xfffff
    80002b78:	0cc080e7          	jalr	204(ra) # 80001c40 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b80:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b82:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b86:	00004697          	auipc	a3,0x4
    80002b8a:	47a68693          	addi	a3,a3,1146 # 80007000 <_trampoline>
    80002b8e:	00004717          	auipc	a4,0x4
    80002b92:	47270713          	addi	a4,a4,1138 # 80007000 <_trampoline>
    80002b96:	8f15                	sub	a4,a4,a3
    80002b98:	040007b7          	lui	a5,0x4000
    80002b9c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b9e:	07b2                	slli	a5,a5,0xc
    80002ba0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ba2:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ba6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ba8:	18002673          	csrr	a2,satp
    80002bac:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002bae:	6d30                	ld	a2,88(a0)
    80002bb0:	6138                	ld	a4,64(a0)
    80002bb2:	6585                	lui	a1,0x1
    80002bb4:	972e                	add	a4,a4,a1
    80002bb6:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002bb8:	6d38                	ld	a4,88(a0)
    80002bba:	00000617          	auipc	a2,0x0
    80002bbe:	13860613          	addi	a2,a2,312 # 80002cf2 <usertrap>
    80002bc2:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002bc4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bc6:	8612                	mv	a2,tp
    80002bc8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bca:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bce:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bd2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bd6:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002bda:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bdc:	6f18                	ld	a4,24(a4)
    80002bde:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002be2:	6928                	ld	a0,80(a0)
    80002be4:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002be6:	00004717          	auipc	a4,0x4
    80002bea:	4b670713          	addi	a4,a4,1206 # 8000709c <userret>
    80002bee:	8f15                	sub	a4,a4,a3
    80002bf0:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002bf2:	577d                	li	a4,-1
    80002bf4:	177e                	slli	a4,a4,0x3f
    80002bf6:	8d59                	or	a0,a0,a4
    80002bf8:	9782                	jalr	a5
}
    80002bfa:	60a2                	ld	ra,8(sp)
    80002bfc:	6402                	ld	s0,0(sp)
    80002bfe:	0141                	addi	sp,sp,16
    80002c00:	8082                	ret

0000000080002c02 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002c02:	1101                	addi	sp,sp,-32
    80002c04:	ec06                	sd	ra,24(sp)
    80002c06:	e822                	sd	s0,16(sp)
    80002c08:	e426                	sd	s1,8(sp)
    80002c0a:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002c0c:	00017497          	auipc	s1,0x17
    80002c10:	b4448493          	addi	s1,s1,-1212 # 80019750 <tickslock>
    80002c14:	8526                	mv	a0,s1
    80002c16:	ffffe097          	auipc	ra,0xffffe
    80002c1a:	022080e7          	jalr	34(ra) # 80000c38 <acquire>
    ticks++;
    80002c1e:	00009517          	auipc	a0,0x9
    80002c22:	89250513          	addi	a0,a0,-1902 # 8000b4b0 <ticks>
    80002c26:	411c                	lw	a5,0(a0)
    80002c28:	2785                	addiw	a5,a5,1
    80002c2a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	850080e7          	jalr	-1968(ra) # 8000247c <wakeup>
    release(&tickslock);
    80002c34:	8526                	mv	a0,s1
    80002c36:	ffffe097          	auipc	ra,0xffffe
    80002c3a:	0b6080e7          	jalr	182(ra) # 80000cec <release>
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6105                	addi	sp,sp,32
    80002c46:	8082                	ret

0000000080002c48 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c48:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002c4c:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002c4e:	0a07d163          	bgez	a5,80002cf0 <devintr+0xa8>
{
    80002c52:	1101                	addi	sp,sp,-32
    80002c54:	ec06                	sd	ra,24(sp)
    80002c56:	e822                	sd	s0,16(sp)
    80002c58:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002c5a:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002c5e:	46a5                	li	a3,9
    80002c60:	00d70c63          	beq	a4,a3,80002c78 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002c64:	577d                	li	a4,-1
    80002c66:	177e                	slli	a4,a4,0x3f
    80002c68:	0705                	addi	a4,a4,1
        return 0;
    80002c6a:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002c6c:	06e78163          	beq	a5,a4,80002cce <devintr+0x86>
    }
}
    80002c70:	60e2                	ld	ra,24(sp)
    80002c72:	6442                	ld	s0,16(sp)
    80002c74:	6105                	addi	sp,sp,32
    80002c76:	8082                	ret
    80002c78:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002c7a:	00003097          	auipc	ra,0x3
    80002c7e:	642080e7          	jalr	1602(ra) # 800062bc <plic_claim>
    80002c82:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002c84:	47a9                	li	a5,10
    80002c86:	00f50963          	beq	a0,a5,80002c98 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002c8a:	4785                	li	a5,1
    80002c8c:	00f50b63          	beq	a0,a5,80002ca2 <devintr+0x5a>
        return 1;
    80002c90:	4505                	li	a0,1
        else if (irq)
    80002c92:	ec89                	bnez	s1,80002cac <devintr+0x64>
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	bfe9                	j	80002c70 <devintr+0x28>
            uartintr();
    80002c98:	ffffe097          	auipc	ra,0xffffe
    80002c9c:	d62080e7          	jalr	-670(ra) # 800009fa <uartintr>
        if (irq)
    80002ca0:	a839                	j	80002cbe <devintr+0x76>
            virtio_disk_intr();
    80002ca2:	00004097          	auipc	ra,0x4
    80002ca6:	b44080e7          	jalr	-1212(ra) # 800067e6 <virtio_disk_intr>
        if (irq)
    80002caa:	a811                	j	80002cbe <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002cac:	85a6                	mv	a1,s1
    80002cae:	00005517          	auipc	a0,0x5
    80002cb2:	6ea50513          	addi	a0,a0,1770 # 80008398 <etext+0x398>
    80002cb6:	ffffe097          	auipc	ra,0xffffe
    80002cba:	8f4080e7          	jalr	-1804(ra) # 800005aa <printf>
            plic_complete(irq);
    80002cbe:	8526                	mv	a0,s1
    80002cc0:	00003097          	auipc	ra,0x3
    80002cc4:	620080e7          	jalr	1568(ra) # 800062e0 <plic_complete>
        return 1;
    80002cc8:	4505                	li	a0,1
    80002cca:	64a2                	ld	s1,8(sp)
    80002ccc:	b755                	j	80002c70 <devintr+0x28>
        if (cpuid() == 0)
    80002cce:	fffff097          	auipc	ra,0xfffff
    80002cd2:	f46080e7          	jalr	-186(ra) # 80001c14 <cpuid>
    80002cd6:	c901                	beqz	a0,80002ce6 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cd8:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002cdc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002cde:	14479073          	csrw	sip,a5
        return 2;
    80002ce2:	4509                	li	a0,2
    80002ce4:	b771                	j	80002c70 <devintr+0x28>
            clockintr();
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	f1c080e7          	jalr	-228(ra) # 80002c02 <clockintr>
    80002cee:	b7ed                	j	80002cd8 <devintr+0x90>
}
    80002cf0:	8082                	ret

0000000080002cf2 <usertrap>:
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	e04a                	sd	s2,0(sp)
    80002cfc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cfe:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002d02:	1007f793          	andi	a5,a5,256
    80002d06:	e3b1                	bnez	a5,80002d4a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d08:	00003797          	auipc	a5,0x3
    80002d0c:	4a878793          	addi	a5,a5,1192 # 800061b0 <kernelvec>
    80002d10:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002d14:	fffff097          	auipc	ra,0xfffff
    80002d18:	f2c080e7          	jalr	-212(ra) # 80001c40 <myproc>
    80002d1c:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002d1e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d20:	14102773          	csrr	a4,sepc
    80002d24:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d26:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002d2a:	47a1                	li	a5,8
    80002d2c:	02f70763          	beq	a4,a5,80002d5a <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	f18080e7          	jalr	-232(ra) # 80002c48 <devintr>
    80002d38:	892a                	mv	s2,a0
    80002d3a:	c151                	beqz	a0,80002dbe <usertrap+0xcc>
    if (killed(p))
    80002d3c:	8526                	mv	a0,s1
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	982080e7          	jalr	-1662(ra) # 800026c0 <killed>
    80002d46:	c929                	beqz	a0,80002d98 <usertrap+0xa6>
    80002d48:	a099                	j	80002d8e <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002d4a:	00005517          	auipc	a0,0x5
    80002d4e:	66e50513          	addi	a0,a0,1646 # 800083b8 <etext+0x3b8>
    80002d52:	ffffe097          	auipc	ra,0xffffe
    80002d56:	80e080e7          	jalr	-2034(ra) # 80000560 <panic>
        if (killed(p))
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	966080e7          	jalr	-1690(ra) # 800026c0 <killed>
    80002d62:	e921                	bnez	a0,80002db2 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002d64:	6cb8                	ld	a4,88(s1)
    80002d66:	6f1c                	ld	a5,24(a4)
    80002d68:	0791                	addi	a5,a5,4
    80002d6a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d70:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d74:	10079073          	csrw	sstatus,a5
        syscall();
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	2d8080e7          	jalr	728(ra) # 80003050 <syscall>
    if (killed(p))
    80002d80:	8526                	mv	a0,s1
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	93e080e7          	jalr	-1730(ra) # 800026c0 <killed>
    80002d8a:	c911                	beqz	a0,80002d9e <usertrap+0xac>
    80002d8c:	4901                	li	s2,0
        exit(-1);
    80002d8e:	557d                	li	a0,-1
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	7bc080e7          	jalr	1980(ra) # 8000254c <exit>
    if (which_dev == 2)
    80002d98:	4789                	li	a5,2
    80002d9a:	04f90f63          	beq	s2,a5,80002df8 <usertrap+0x106>
    usertrapret();
    80002d9e:	00000097          	auipc	ra,0x0
    80002da2:	dce080e7          	jalr	-562(ra) # 80002b6c <usertrapret>
}
    80002da6:	60e2                	ld	ra,24(sp)
    80002da8:	6442                	ld	s0,16(sp)
    80002daa:	64a2                	ld	s1,8(sp)
    80002dac:	6902                	ld	s2,0(sp)
    80002dae:	6105                	addi	sp,sp,32
    80002db0:	8082                	ret
            exit(-1);
    80002db2:	557d                	li	a0,-1
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	798080e7          	jalr	1944(ra) # 8000254c <exit>
    80002dbc:	b765                	j	80002d64 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dbe:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002dc2:	5890                	lw	a2,48(s1)
    80002dc4:	00005517          	auipc	a0,0x5
    80002dc8:	61450513          	addi	a0,a0,1556 # 800083d8 <etext+0x3d8>
    80002dcc:	ffffd097          	auipc	ra,0xffffd
    80002dd0:	7de080e7          	jalr	2014(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dd4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dd8:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ddc:	00005517          	auipc	a0,0x5
    80002de0:	62c50513          	addi	a0,a0,1580 # 80008408 <etext+0x408>
    80002de4:	ffffd097          	auipc	ra,0xffffd
    80002de8:	7c6080e7          	jalr	1990(ra) # 800005aa <printf>
        setkilled(p);
    80002dec:	8526                	mv	a0,s1
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	8a6080e7          	jalr	-1882(ra) # 80002694 <setkilled>
    80002df6:	b769                	j	80002d80 <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002df8:	4505                	li	a0,1
    80002dfa:	fffff097          	auipc	ra,0xfffff
    80002dfe:	5e2080e7          	jalr	1506(ra) # 800023dc <yield>
    80002e02:	bf71                	j	80002d9e <usertrap+0xac>

0000000080002e04 <kerneltrap>:
{
    80002e04:	7179                	addi	sp,sp,-48
    80002e06:	f406                	sd	ra,40(sp)
    80002e08:	f022                	sd	s0,32(sp)
    80002e0a:	ec26                	sd	s1,24(sp)
    80002e0c:	e84a                	sd	s2,16(sp)
    80002e0e:	e44e                	sd	s3,8(sp)
    80002e10:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e12:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e16:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e1a:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002e1e:	1004f793          	andi	a5,s1,256
    80002e22:	cb85                	beqz	a5,80002e52 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e24:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e28:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002e2a:	ef85                	bnez	a5,80002e62 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	e1c080e7          	jalr	-484(ra) # 80002c48 <devintr>
    80002e34:	cd1d                	beqz	a0,80002e72 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e36:	4789                	li	a5,2
    80002e38:	06f50a63          	beq	a0,a5,80002eac <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e3c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e40:	10049073          	csrw	sstatus,s1
}
    80002e44:	70a2                	ld	ra,40(sp)
    80002e46:	7402                	ld	s0,32(sp)
    80002e48:	64e2                	ld	s1,24(sp)
    80002e4a:	6942                	ld	s2,16(sp)
    80002e4c:	69a2                	ld	s3,8(sp)
    80002e4e:	6145                	addi	sp,sp,48
    80002e50:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002e52:	00005517          	auipc	a0,0x5
    80002e56:	5d650513          	addi	a0,a0,1494 # 80008428 <etext+0x428>
    80002e5a:	ffffd097          	auipc	ra,0xffffd
    80002e5e:	706080e7          	jalr	1798(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002e62:	00005517          	auipc	a0,0x5
    80002e66:	5ee50513          	addi	a0,a0,1518 # 80008450 <etext+0x450>
    80002e6a:	ffffd097          	auipc	ra,0xffffd
    80002e6e:	6f6080e7          	jalr	1782(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002e72:	85ce                	mv	a1,s3
    80002e74:	00005517          	auipc	a0,0x5
    80002e78:	5fc50513          	addi	a0,a0,1532 # 80008470 <etext+0x470>
    80002e7c:	ffffd097          	auipc	ra,0xffffd
    80002e80:	72e080e7          	jalr	1838(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e88:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e8c:	00005517          	auipc	a0,0x5
    80002e90:	5f450513          	addi	a0,a0,1524 # 80008480 <etext+0x480>
    80002e94:	ffffd097          	auipc	ra,0xffffd
    80002e98:	716080e7          	jalr	1814(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002e9c:	00005517          	auipc	a0,0x5
    80002ea0:	5fc50513          	addi	a0,a0,1532 # 80008498 <etext+0x498>
    80002ea4:	ffffd097          	auipc	ra,0xffffd
    80002ea8:	6bc080e7          	jalr	1724(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002eac:	fffff097          	auipc	ra,0xfffff
    80002eb0:	d94080e7          	jalr	-620(ra) # 80001c40 <myproc>
    80002eb4:	d541                	beqz	a0,80002e3c <kerneltrap+0x38>
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	d8a080e7          	jalr	-630(ra) # 80001c40 <myproc>
    80002ebe:	4d18                	lw	a4,24(a0)
    80002ec0:	4791                	li	a5,4
    80002ec2:	f6f71de3          	bne	a4,a5,80002e3c <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002ec6:	4509                	li	a0,2
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	514080e7          	jalr	1300(ra) # 800023dc <yield>
    80002ed0:	b7b5                	j	80002e3c <kerneltrap+0x38>

0000000080002ed2 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002ed2:	1101                	addi	sp,sp,-32
    80002ed4:	ec06                	sd	ra,24(sp)
    80002ed6:	e822                	sd	s0,16(sp)
    80002ed8:	e426                	sd	s1,8(sp)
    80002eda:	1000                	addi	s0,sp,32
    80002edc:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	d62080e7          	jalr	-670(ra) # 80001c40 <myproc>
    switch (n)
    80002ee6:	4795                	li	a5,5
    80002ee8:	0497e163          	bltu	a5,s1,80002f2a <argraw+0x58>
    80002eec:	048a                	slli	s1,s1,0x2
    80002eee:	00006717          	auipc	a4,0x6
    80002ef2:	96a70713          	addi	a4,a4,-1686 # 80008858 <states.0+0x30>
    80002ef6:	94ba                	add	s1,s1,a4
    80002ef8:	409c                	lw	a5,0(s1)
    80002efa:	97ba                	add	a5,a5,a4
    80002efc:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002efe:	6d3c                	ld	a5,88(a0)
    80002f00:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002f02:	60e2                	ld	ra,24(sp)
    80002f04:	6442                	ld	s0,16(sp)
    80002f06:	64a2                	ld	s1,8(sp)
    80002f08:	6105                	addi	sp,sp,32
    80002f0a:	8082                	ret
        return p->trapframe->a1;
    80002f0c:	6d3c                	ld	a5,88(a0)
    80002f0e:	7fa8                	ld	a0,120(a5)
    80002f10:	bfcd                	j	80002f02 <argraw+0x30>
        return p->trapframe->a2;
    80002f12:	6d3c                	ld	a5,88(a0)
    80002f14:	63c8                	ld	a0,128(a5)
    80002f16:	b7f5                	j	80002f02 <argraw+0x30>
        return p->trapframe->a3;
    80002f18:	6d3c                	ld	a5,88(a0)
    80002f1a:	67c8                	ld	a0,136(a5)
    80002f1c:	b7dd                	j	80002f02 <argraw+0x30>
        return p->trapframe->a4;
    80002f1e:	6d3c                	ld	a5,88(a0)
    80002f20:	6bc8                	ld	a0,144(a5)
    80002f22:	b7c5                	j	80002f02 <argraw+0x30>
        return p->trapframe->a5;
    80002f24:	6d3c                	ld	a5,88(a0)
    80002f26:	6fc8                	ld	a0,152(a5)
    80002f28:	bfe9                	j	80002f02 <argraw+0x30>
    panic("argraw");
    80002f2a:	00005517          	auipc	a0,0x5
    80002f2e:	57e50513          	addi	a0,a0,1406 # 800084a8 <etext+0x4a8>
    80002f32:	ffffd097          	auipc	ra,0xffffd
    80002f36:	62e080e7          	jalr	1582(ra) # 80000560 <panic>

0000000080002f3a <fetchaddr>:
{
    80002f3a:	1101                	addi	sp,sp,-32
    80002f3c:	ec06                	sd	ra,24(sp)
    80002f3e:	e822                	sd	s0,16(sp)
    80002f40:	e426                	sd	s1,8(sp)
    80002f42:	e04a                	sd	s2,0(sp)
    80002f44:	1000                	addi	s0,sp,32
    80002f46:	84aa                	mv	s1,a0
    80002f48:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	cf6080e7          	jalr	-778(ra) # 80001c40 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002f52:	653c                	ld	a5,72(a0)
    80002f54:	02f4f863          	bgeu	s1,a5,80002f84 <fetchaddr+0x4a>
    80002f58:	00848713          	addi	a4,s1,8
    80002f5c:	02e7e663          	bltu	a5,a4,80002f88 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f60:	46a1                	li	a3,8
    80002f62:	8626                	mv	a2,s1
    80002f64:	85ca                	mv	a1,s2
    80002f66:	6928                	ld	a0,80(a0)
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	806080e7          	jalr	-2042(ra) # 8000176e <copyin>
    80002f70:	00a03533          	snez	a0,a0
    80002f74:	40a00533          	neg	a0,a0
}
    80002f78:	60e2                	ld	ra,24(sp)
    80002f7a:	6442                	ld	s0,16(sp)
    80002f7c:	64a2                	ld	s1,8(sp)
    80002f7e:	6902                	ld	s2,0(sp)
    80002f80:	6105                	addi	sp,sp,32
    80002f82:	8082                	ret
        return -1;
    80002f84:	557d                	li	a0,-1
    80002f86:	bfcd                	j	80002f78 <fetchaddr+0x3e>
    80002f88:	557d                	li	a0,-1
    80002f8a:	b7fd                	j	80002f78 <fetchaddr+0x3e>

0000000080002f8c <fetchstr>:
{
    80002f8c:	7179                	addi	sp,sp,-48
    80002f8e:	f406                	sd	ra,40(sp)
    80002f90:	f022                	sd	s0,32(sp)
    80002f92:	ec26                	sd	s1,24(sp)
    80002f94:	e84a                	sd	s2,16(sp)
    80002f96:	e44e                	sd	s3,8(sp)
    80002f98:	1800                	addi	s0,sp,48
    80002f9a:	892a                	mv	s2,a0
    80002f9c:	84ae                	mv	s1,a1
    80002f9e:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	ca0080e7          	jalr	-864(ra) # 80001c40 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002fa8:	86ce                	mv	a3,s3
    80002faa:	864a                	mv	a2,s2
    80002fac:	85a6                	mv	a1,s1
    80002fae:	6928                	ld	a0,80(a0)
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	84c080e7          	jalr	-1972(ra) # 800017fc <copyinstr>
    80002fb8:	00054e63          	bltz	a0,80002fd4 <fetchstr+0x48>
    return strlen(buf);
    80002fbc:	8526                	mv	a0,s1
    80002fbe:	ffffe097          	auipc	ra,0xffffe
    80002fc2:	eea080e7          	jalr	-278(ra) # 80000ea8 <strlen>
}
    80002fc6:	70a2                	ld	ra,40(sp)
    80002fc8:	7402                	ld	s0,32(sp)
    80002fca:	64e2                	ld	s1,24(sp)
    80002fcc:	6942                	ld	s2,16(sp)
    80002fce:	69a2                	ld	s3,8(sp)
    80002fd0:	6145                	addi	sp,sp,48
    80002fd2:	8082                	ret
        return -1;
    80002fd4:	557d                	li	a0,-1
    80002fd6:	bfc5                	j	80002fc6 <fetchstr+0x3a>

0000000080002fd8 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002fd8:	1101                	addi	sp,sp,-32
    80002fda:	ec06                	sd	ra,24(sp)
    80002fdc:	e822                	sd	s0,16(sp)
    80002fde:	e426                	sd	s1,8(sp)
    80002fe0:	1000                	addi	s0,sp,32
    80002fe2:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	eee080e7          	jalr	-274(ra) # 80002ed2 <argraw>
    80002fec:	c088                	sw	a0,0(s1)
}
    80002fee:	60e2                	ld	ra,24(sp)
    80002ff0:	6442                	ld	s0,16(sp)
    80002ff2:	64a2                	ld	s1,8(sp)
    80002ff4:	6105                	addi	sp,sp,32
    80002ff6:	8082                	ret

0000000080002ff8 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002ff8:	1101                	addi	sp,sp,-32
    80002ffa:	ec06                	sd	ra,24(sp)
    80002ffc:	e822                	sd	s0,16(sp)
    80002ffe:	e426                	sd	s1,8(sp)
    80003000:	1000                	addi	s0,sp,32
    80003002:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003004:	00000097          	auipc	ra,0x0
    80003008:	ece080e7          	jalr	-306(ra) # 80002ed2 <argraw>
    8000300c:	e088                	sd	a0,0(s1)
}
    8000300e:	60e2                	ld	ra,24(sp)
    80003010:	6442                	ld	s0,16(sp)
    80003012:	64a2                	ld	s1,8(sp)
    80003014:	6105                	addi	sp,sp,32
    80003016:	8082                	ret

0000000080003018 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80003018:	7179                	addi	sp,sp,-48
    8000301a:	f406                	sd	ra,40(sp)
    8000301c:	f022                	sd	s0,32(sp)
    8000301e:	ec26                	sd	s1,24(sp)
    80003020:	e84a                	sd	s2,16(sp)
    80003022:	1800                	addi	s0,sp,48
    80003024:	84ae                	mv	s1,a1
    80003026:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80003028:	fd840593          	addi	a1,s0,-40
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	fcc080e7          	jalr	-52(ra) # 80002ff8 <argaddr>
    return fetchstr(addr, buf, max);
    80003034:	864a                	mv	a2,s2
    80003036:	85a6                	mv	a1,s1
    80003038:	fd843503          	ld	a0,-40(s0)
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	f50080e7          	jalr	-176(ra) # 80002f8c <fetchstr>
}
    80003044:	70a2                	ld	ra,40(sp)
    80003046:	7402                	ld	s0,32(sp)
    80003048:	64e2                	ld	s1,24(sp)
    8000304a:	6942                	ld	s2,16(sp)
    8000304c:	6145                	addi	sp,sp,48
    8000304e:	8082                	ret

0000000080003050 <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    80003050:	1101                	addi	sp,sp,-32
    80003052:	ec06                	sd	ra,24(sp)
    80003054:	e822                	sd	s0,16(sp)
    80003056:	e426                	sd	s1,8(sp)
    80003058:	e04a                	sd	s2,0(sp)
    8000305a:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	be4080e7          	jalr	-1052(ra) # 80001c40 <myproc>
    80003064:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003066:	05853903          	ld	s2,88(a0)
    8000306a:	0a893783          	ld	a5,168(s2)
    8000306e:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80003072:	37fd                	addiw	a5,a5,-1
    80003074:	4761                	li	a4,24
    80003076:	00f76f63          	bltu	a4,a5,80003094 <syscall+0x44>
    8000307a:	00369713          	slli	a4,a3,0x3
    8000307e:	00005797          	auipc	a5,0x5
    80003082:	7f278793          	addi	a5,a5,2034 # 80008870 <syscalls>
    80003086:	97ba                	add	a5,a5,a4
    80003088:	639c                	ld	a5,0(a5)
    8000308a:	c789                	beqz	a5,80003094 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    8000308c:	9782                	jalr	a5
    8000308e:	06a93823          	sd	a0,112(s2)
    80003092:	a839                	j	800030b0 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003094:	15848613          	addi	a2,s1,344
    80003098:	588c                	lw	a1,48(s1)
    8000309a:	00005517          	auipc	a0,0x5
    8000309e:	41650513          	addi	a0,a0,1046 # 800084b0 <etext+0x4b0>
    800030a2:	ffffd097          	auipc	ra,0xffffd
    800030a6:	508080e7          	jalr	1288(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800030aa:	6cbc                	ld	a5,88(s1)
    800030ac:	577d                	li	a4,-1
    800030ae:	fbb8                	sd	a4,112(a5)
    }
}
    800030b0:	60e2                	ld	ra,24(sp)
    800030b2:	6442                	ld	s0,16(sp)
    800030b4:	64a2                	ld	s1,8(sp)
    800030b6:	6902                	ld	s2,0(sp)
    800030b8:	6105                	addi	sp,sp,32
    800030ba:	8082                	ret

00000000800030bc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800030bc:	1101                	addi	sp,sp,-32
    800030be:	ec06                	sd	ra,24(sp)
    800030c0:	e822                	sd	s0,16(sp)
    800030c2:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800030c4:	fec40593          	addi	a1,s0,-20
    800030c8:	4501                	li	a0,0
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	f0e080e7          	jalr	-242(ra) # 80002fd8 <argint>
    exit(n);
    800030d2:	fec42503          	lw	a0,-20(s0)
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	476080e7          	jalr	1142(ra) # 8000254c <exit>
    return 0; // not reached
}
    800030de:	4501                	li	a0,0
    800030e0:	60e2                	ld	ra,24(sp)
    800030e2:	6442                	ld	s0,16(sp)
    800030e4:	6105                	addi	sp,sp,32
    800030e6:	8082                	ret

00000000800030e8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800030e8:	1141                	addi	sp,sp,-16
    800030ea:	e406                	sd	ra,8(sp)
    800030ec:	e022                	sd	s0,0(sp)
    800030ee:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800030f0:	fffff097          	auipc	ra,0xfffff
    800030f4:	b50080e7          	jalr	-1200(ra) # 80001c40 <myproc>
}
    800030f8:	5908                	lw	a0,48(a0)
    800030fa:	60a2                	ld	ra,8(sp)
    800030fc:	6402                	ld	s0,0(sp)
    800030fe:	0141                	addi	sp,sp,16
    80003100:	8082                	ret

0000000080003102 <sys_fork>:

uint64
sys_fork(void)
{
    80003102:	1141                	addi	sp,sp,-16
    80003104:	e406                	sd	ra,8(sp)
    80003106:	e022                	sd	s0,0(sp)
    80003108:	0800                	addi	s0,sp,16
    return fork();
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	084080e7          	jalr	132(ra) # 8000218e <fork>
}
    80003112:	60a2                	ld	ra,8(sp)
    80003114:	6402                	ld	s0,0(sp)
    80003116:	0141                	addi	sp,sp,16
    80003118:	8082                	ret

000000008000311a <sys_wait>:

uint64
sys_wait(void)
{
    8000311a:	1101                	addi	sp,sp,-32
    8000311c:	ec06                	sd	ra,24(sp)
    8000311e:	e822                	sd	s0,16(sp)
    80003120:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80003122:	fe840593          	addi	a1,s0,-24
    80003126:	4501                	li	a0,0
    80003128:	00000097          	auipc	ra,0x0
    8000312c:	ed0080e7          	jalr	-304(ra) # 80002ff8 <argaddr>
    return wait(p);
    80003130:	fe843503          	ld	a0,-24(s0)
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	5be080e7          	jalr	1470(ra) # 800026f2 <wait>
}
    8000313c:	60e2                	ld	ra,24(sp)
    8000313e:	6442                	ld	s0,16(sp)
    80003140:	6105                	addi	sp,sp,32
    80003142:	8082                	ret

0000000080003144 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003144:	7179                	addi	sp,sp,-48
    80003146:	f406                	sd	ra,40(sp)
    80003148:	f022                	sd	s0,32(sp)
    8000314a:	ec26                	sd	s1,24(sp)
    8000314c:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    8000314e:	fdc40593          	addi	a1,s0,-36
    80003152:	4501                	li	a0,0
    80003154:	00000097          	auipc	ra,0x0
    80003158:	e84080e7          	jalr	-380(ra) # 80002fd8 <argint>
    addr = myproc()->sz;
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	ae4080e7          	jalr	-1308(ra) # 80001c40 <myproc>
    80003164:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    80003166:	fdc42503          	lw	a0,-36(s0)
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	e30080e7          	jalr	-464(ra) # 80001f9a <growproc>
    80003172:	00054863          	bltz	a0,80003182 <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80003176:	8526                	mv	a0,s1
    80003178:	70a2                	ld	ra,40(sp)
    8000317a:	7402                	ld	s0,32(sp)
    8000317c:	64e2                	ld	s1,24(sp)
    8000317e:	6145                	addi	sp,sp,48
    80003180:	8082                	ret
        return -1;
    80003182:	54fd                	li	s1,-1
    80003184:	bfcd                	j	80003176 <sys_sbrk+0x32>

0000000080003186 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003186:	7139                	addi	sp,sp,-64
    80003188:	fc06                	sd	ra,56(sp)
    8000318a:	f822                	sd	s0,48(sp)
    8000318c:	f04a                	sd	s2,32(sp)
    8000318e:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003190:	fcc40593          	addi	a1,s0,-52
    80003194:	4501                	li	a0,0
    80003196:	00000097          	auipc	ra,0x0
    8000319a:	e42080e7          	jalr	-446(ra) # 80002fd8 <argint>
    acquire(&tickslock);
    8000319e:	00016517          	auipc	a0,0x16
    800031a2:	5b250513          	addi	a0,a0,1458 # 80019750 <tickslock>
    800031a6:	ffffe097          	auipc	ra,0xffffe
    800031aa:	a92080e7          	jalr	-1390(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    800031ae:	00008917          	auipc	s2,0x8
    800031b2:	30292903          	lw	s2,770(s2) # 8000b4b0 <ticks>
    while (ticks - ticks0 < n)
    800031b6:	fcc42783          	lw	a5,-52(s0)
    800031ba:	c3b9                	beqz	a5,80003200 <sys_sleep+0x7a>
    800031bc:	f426                	sd	s1,40(sp)
    800031be:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800031c0:	00016997          	auipc	s3,0x16
    800031c4:	59098993          	addi	s3,s3,1424 # 80019750 <tickslock>
    800031c8:	00008497          	auipc	s1,0x8
    800031cc:	2e848493          	addi	s1,s1,744 # 8000b4b0 <ticks>
        if (killed(myproc()))
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	a70080e7          	jalr	-1424(ra) # 80001c40 <myproc>
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	4e8080e7          	jalr	1256(ra) # 800026c0 <killed>
    800031e0:	ed15                	bnez	a0,8000321c <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    800031e2:	85ce                	mv	a1,s3
    800031e4:	8526                	mv	a0,s1
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	232080e7          	jalr	562(ra) # 80002418 <sleep>
    while (ticks - ticks0 < n)
    800031ee:	409c                	lw	a5,0(s1)
    800031f0:	412787bb          	subw	a5,a5,s2
    800031f4:	fcc42703          	lw	a4,-52(s0)
    800031f8:	fce7ece3          	bltu	a5,a4,800031d0 <sys_sleep+0x4a>
    800031fc:	74a2                	ld	s1,40(sp)
    800031fe:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003200:	00016517          	auipc	a0,0x16
    80003204:	55050513          	addi	a0,a0,1360 # 80019750 <tickslock>
    80003208:	ffffe097          	auipc	ra,0xffffe
    8000320c:	ae4080e7          	jalr	-1308(ra) # 80000cec <release>
    return 0;
    80003210:	4501                	li	a0,0
}
    80003212:	70e2                	ld	ra,56(sp)
    80003214:	7442                	ld	s0,48(sp)
    80003216:	7902                	ld	s2,32(sp)
    80003218:	6121                	addi	sp,sp,64
    8000321a:	8082                	ret
            release(&tickslock);
    8000321c:	00016517          	auipc	a0,0x16
    80003220:	53450513          	addi	a0,a0,1332 # 80019750 <tickslock>
    80003224:	ffffe097          	auipc	ra,0xffffe
    80003228:	ac8080e7          	jalr	-1336(ra) # 80000cec <release>
            return -1;
    8000322c:	557d                	li	a0,-1
    8000322e:	74a2                	ld	s1,40(sp)
    80003230:	69e2                	ld	s3,24(sp)
    80003232:	b7c5                	j	80003212 <sys_sleep+0x8c>

0000000080003234 <sys_kill>:

uint64
sys_kill(void)
{
    80003234:	1101                	addi	sp,sp,-32
    80003236:	ec06                	sd	ra,24(sp)
    80003238:	e822                	sd	s0,16(sp)
    8000323a:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    8000323c:	fec40593          	addi	a1,s0,-20
    80003240:	4501                	li	a0,0
    80003242:	00000097          	auipc	ra,0x0
    80003246:	d96080e7          	jalr	-618(ra) # 80002fd8 <argint>
    return kill(pid);
    8000324a:	fec42503          	lw	a0,-20(s0)
    8000324e:	fffff097          	auipc	ra,0xfffff
    80003252:	3d4080e7          	jalr	980(ra) # 80002622 <kill>
}
    80003256:	60e2                	ld	ra,24(sp)
    80003258:	6442                	ld	s0,16(sp)
    8000325a:	6105                	addi	sp,sp,32
    8000325c:	8082                	ret

000000008000325e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000325e:	1101                	addi	sp,sp,-32
    80003260:	ec06                	sd	ra,24(sp)
    80003262:	e822                	sd	s0,16(sp)
    80003264:	e426                	sd	s1,8(sp)
    80003266:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80003268:	00016517          	auipc	a0,0x16
    8000326c:	4e850513          	addi	a0,a0,1256 # 80019750 <tickslock>
    80003270:	ffffe097          	auipc	ra,0xffffe
    80003274:	9c8080e7          	jalr	-1592(ra) # 80000c38 <acquire>
    xticks = ticks;
    80003278:	00008497          	auipc	s1,0x8
    8000327c:	2384a483          	lw	s1,568(s1) # 8000b4b0 <ticks>
    release(&tickslock);
    80003280:	00016517          	auipc	a0,0x16
    80003284:	4d050513          	addi	a0,a0,1232 # 80019750 <tickslock>
    80003288:	ffffe097          	auipc	ra,0xffffe
    8000328c:	a64080e7          	jalr	-1436(ra) # 80000cec <release>
    return xticks;
}
    80003290:	02049513          	slli	a0,s1,0x20
    80003294:	9101                	srli	a0,a0,0x20
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	64a2                	ld	s1,8(sp)
    8000329c:	6105                	addi	sp,sp,32
    8000329e:	8082                	ret

00000000800032a0 <sys_ps>:

void *
sys_ps(void)
{
    800032a0:	1101                	addi	sp,sp,-32
    800032a2:	ec06                	sd	ra,24(sp)
    800032a4:	e822                	sd	s0,16(sp)
    800032a6:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    800032a8:	fe042623          	sw	zero,-20(s0)
    800032ac:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    800032b0:	fec40593          	addi	a1,s0,-20
    800032b4:	4501                	li	a0,0
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	d22080e7          	jalr	-734(ra) # 80002fd8 <argint>
    argint(1, &count);
    800032be:	fe840593          	addi	a1,s0,-24
    800032c2:	4505                	li	a0,1
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	d14080e7          	jalr	-748(ra) # 80002fd8 <argint>
    return ps((uint8)start, (uint8)count);
    800032cc:	fe844583          	lbu	a1,-24(s0)
    800032d0:	fec44503          	lbu	a0,-20(s0)
    800032d4:	fffff097          	auipc	ra,0xfffff
    800032d8:	d22080e7          	jalr	-734(ra) # 80001ff6 <ps>
}
    800032dc:	60e2                	ld	ra,24(sp)
    800032de:	6442                	ld	s0,16(sp)
    800032e0:	6105                	addi	sp,sp,32
    800032e2:	8082                	ret

00000000800032e4 <sys_schedls>:

uint64 sys_schedls(void)
{
    800032e4:	1141                	addi	sp,sp,-16
    800032e6:	e406                	sd	ra,8(sp)
    800032e8:	e022                	sd	s0,0(sp)
    800032ea:	0800                	addi	s0,sp,16
    schedls();
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	690080e7          	jalr	1680(ra) # 8000297c <schedls>
    return 0;
}
    800032f4:	4501                	li	a0,0
    800032f6:	60a2                	ld	ra,8(sp)
    800032f8:	6402                	ld	s0,0(sp)
    800032fa:	0141                	addi	sp,sp,16
    800032fc:	8082                	ret

00000000800032fe <sys_schedset>:

uint64 sys_schedset(void)
{
    800032fe:	1101                	addi	sp,sp,-32
    80003300:	ec06                	sd	ra,24(sp)
    80003302:	e822                	sd	s0,16(sp)
    80003304:	1000                	addi	s0,sp,32
    int id = 0;
    80003306:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    8000330a:	fec40593          	addi	a1,s0,-20
    8000330e:	4501                	li	a0,0
    80003310:	00000097          	auipc	ra,0x0
    80003314:	cc8080e7          	jalr	-824(ra) # 80002fd8 <argint>
    schedset(id - 1);
    80003318:	fec42503          	lw	a0,-20(s0)
    8000331c:	357d                	addiw	a0,a0,-1
    8000331e:	fffff097          	auipc	ra,0xfffff
    80003322:	74a080e7          	jalr	1866(ra) # 80002a68 <schedset>
    return 0;
}
    80003326:	4501                	li	a0,0
    80003328:	60e2                	ld	ra,24(sp)
    8000332a:	6442                	ld	s0,16(sp)
    8000332c:	6105                	addi	sp,sp,32
    8000332e:	8082                	ret

0000000080003330 <sys_yield>:

uint64 sys_yield(void)
{
    80003330:	1141                	addi	sp,sp,-16
    80003332:	e406                	sd	ra,8(sp)
    80003334:	e022                	sd	s0,0(sp)
    80003336:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    80003338:	4509                	li	a0,2
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	0a2080e7          	jalr	162(ra) # 800023dc <yield>
    return 0;
    80003342:	4501                	li	a0,0
    80003344:	60a2                	ld	ra,8(sp)
    80003346:	6402                	ld	s0,0(sp)
    80003348:	0141                	addi	sp,sp,16
    8000334a:	8082                	ret

000000008000334c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000334c:	7179                	addi	sp,sp,-48
    8000334e:	f406                	sd	ra,40(sp)
    80003350:	f022                	sd	s0,32(sp)
    80003352:	ec26                	sd	s1,24(sp)
    80003354:	e84a                	sd	s2,16(sp)
    80003356:	e44e                	sd	s3,8(sp)
    80003358:	e052                	sd	s4,0(sp)
    8000335a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000335c:	00005597          	auipc	a1,0x5
    80003360:	17458593          	addi	a1,a1,372 # 800084d0 <etext+0x4d0>
    80003364:	00016517          	auipc	a0,0x16
    80003368:	40450513          	addi	a0,a0,1028 # 80019768 <bcache>
    8000336c:	ffffe097          	auipc	ra,0xffffe
    80003370:	83c080e7          	jalr	-1988(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003374:	0001e797          	auipc	a5,0x1e
    80003378:	3f478793          	addi	a5,a5,1012 # 80021768 <bcache+0x8000>
    8000337c:	0001e717          	auipc	a4,0x1e
    80003380:	65470713          	addi	a4,a4,1620 # 800219d0 <bcache+0x8268>
    80003384:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003388:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000338c:	00016497          	auipc	s1,0x16
    80003390:	3f448493          	addi	s1,s1,1012 # 80019780 <bcache+0x18>
    b->next = bcache.head.next;
    80003394:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003396:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003398:	00005a17          	auipc	s4,0x5
    8000339c:	140a0a13          	addi	s4,s4,320 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    800033a0:	2b893783          	ld	a5,696(s2)
    800033a4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033a6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033aa:	85d2                	mv	a1,s4
    800033ac:	01048513          	addi	a0,s1,16
    800033b0:	00001097          	auipc	ra,0x1
    800033b4:	4e8080e7          	jalr	1256(ra) # 80004898 <initsleeplock>
    bcache.head.next->prev = b;
    800033b8:	2b893783          	ld	a5,696(s2)
    800033bc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033be:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033c2:	45848493          	addi	s1,s1,1112
    800033c6:	fd349de3          	bne	s1,s3,800033a0 <binit+0x54>
  }
}
    800033ca:	70a2                	ld	ra,40(sp)
    800033cc:	7402                	ld	s0,32(sp)
    800033ce:	64e2                	ld	s1,24(sp)
    800033d0:	6942                	ld	s2,16(sp)
    800033d2:	69a2                	ld	s3,8(sp)
    800033d4:	6a02                	ld	s4,0(sp)
    800033d6:	6145                	addi	sp,sp,48
    800033d8:	8082                	ret

00000000800033da <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033da:	7179                	addi	sp,sp,-48
    800033dc:	f406                	sd	ra,40(sp)
    800033de:	f022                	sd	s0,32(sp)
    800033e0:	ec26                	sd	s1,24(sp)
    800033e2:	e84a                	sd	s2,16(sp)
    800033e4:	e44e                	sd	s3,8(sp)
    800033e6:	1800                	addi	s0,sp,48
    800033e8:	892a                	mv	s2,a0
    800033ea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033ec:	00016517          	auipc	a0,0x16
    800033f0:	37c50513          	addi	a0,a0,892 # 80019768 <bcache>
    800033f4:	ffffe097          	auipc	ra,0xffffe
    800033f8:	844080e7          	jalr	-1980(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800033fc:	0001e497          	auipc	s1,0x1e
    80003400:	6244b483          	ld	s1,1572(s1) # 80021a20 <bcache+0x82b8>
    80003404:	0001e797          	auipc	a5,0x1e
    80003408:	5cc78793          	addi	a5,a5,1484 # 800219d0 <bcache+0x8268>
    8000340c:	02f48f63          	beq	s1,a5,8000344a <bread+0x70>
    80003410:	873e                	mv	a4,a5
    80003412:	a021                	j	8000341a <bread+0x40>
    80003414:	68a4                	ld	s1,80(s1)
    80003416:	02e48a63          	beq	s1,a4,8000344a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000341a:	449c                	lw	a5,8(s1)
    8000341c:	ff279ce3          	bne	a5,s2,80003414 <bread+0x3a>
    80003420:	44dc                	lw	a5,12(s1)
    80003422:	ff3799e3          	bne	a5,s3,80003414 <bread+0x3a>
      b->refcnt++;
    80003426:	40bc                	lw	a5,64(s1)
    80003428:	2785                	addiw	a5,a5,1
    8000342a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000342c:	00016517          	auipc	a0,0x16
    80003430:	33c50513          	addi	a0,a0,828 # 80019768 <bcache>
    80003434:	ffffe097          	auipc	ra,0xffffe
    80003438:	8b8080e7          	jalr	-1864(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    8000343c:	01048513          	addi	a0,s1,16
    80003440:	00001097          	auipc	ra,0x1
    80003444:	492080e7          	jalr	1170(ra) # 800048d2 <acquiresleep>
      return b;
    80003448:	a8b9                	j	800034a6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000344a:	0001e497          	auipc	s1,0x1e
    8000344e:	5ce4b483          	ld	s1,1486(s1) # 80021a18 <bcache+0x82b0>
    80003452:	0001e797          	auipc	a5,0x1e
    80003456:	57e78793          	addi	a5,a5,1406 # 800219d0 <bcache+0x8268>
    8000345a:	00f48863          	beq	s1,a5,8000346a <bread+0x90>
    8000345e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003460:	40bc                	lw	a5,64(s1)
    80003462:	cf81                	beqz	a5,8000347a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003464:	64a4                	ld	s1,72(s1)
    80003466:	fee49de3          	bne	s1,a4,80003460 <bread+0x86>
  panic("bget: no buffers");
    8000346a:	00005517          	auipc	a0,0x5
    8000346e:	07650513          	addi	a0,a0,118 # 800084e0 <etext+0x4e0>
    80003472:	ffffd097          	auipc	ra,0xffffd
    80003476:	0ee080e7          	jalr	238(ra) # 80000560 <panic>
      b->dev = dev;
    8000347a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000347e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003482:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003486:	4785                	li	a5,1
    80003488:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000348a:	00016517          	auipc	a0,0x16
    8000348e:	2de50513          	addi	a0,a0,734 # 80019768 <bcache>
    80003492:	ffffe097          	auipc	ra,0xffffe
    80003496:	85a080e7          	jalr	-1958(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    8000349a:	01048513          	addi	a0,s1,16
    8000349e:	00001097          	auipc	ra,0x1
    800034a2:	434080e7          	jalr	1076(ra) # 800048d2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034a6:	409c                	lw	a5,0(s1)
    800034a8:	cb89                	beqz	a5,800034ba <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034aa:	8526                	mv	a0,s1
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	6145                	addi	sp,sp,48
    800034b8:	8082                	ret
    virtio_disk_rw(b, 0);
    800034ba:	4581                	li	a1,0
    800034bc:	8526                	mv	a0,s1
    800034be:	00003097          	auipc	ra,0x3
    800034c2:	0fa080e7          	jalr	250(ra) # 800065b8 <virtio_disk_rw>
    b->valid = 1;
    800034c6:	4785                	li	a5,1
    800034c8:	c09c                	sw	a5,0(s1)
  return b;
    800034ca:	b7c5                	j	800034aa <bread+0xd0>

00000000800034cc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800034cc:	1101                	addi	sp,sp,-32
    800034ce:	ec06                	sd	ra,24(sp)
    800034d0:	e822                	sd	s0,16(sp)
    800034d2:	e426                	sd	s1,8(sp)
    800034d4:	1000                	addi	s0,sp,32
    800034d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034d8:	0541                	addi	a0,a0,16
    800034da:	00001097          	auipc	ra,0x1
    800034de:	492080e7          	jalr	1170(ra) # 8000496c <holdingsleep>
    800034e2:	cd01                	beqz	a0,800034fa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034e4:	4585                	li	a1,1
    800034e6:	8526                	mv	a0,s1
    800034e8:	00003097          	auipc	ra,0x3
    800034ec:	0d0080e7          	jalr	208(ra) # 800065b8 <virtio_disk_rw>
}
    800034f0:	60e2                	ld	ra,24(sp)
    800034f2:	6442                	ld	s0,16(sp)
    800034f4:	64a2                	ld	s1,8(sp)
    800034f6:	6105                	addi	sp,sp,32
    800034f8:	8082                	ret
    panic("bwrite");
    800034fa:	00005517          	auipc	a0,0x5
    800034fe:	ffe50513          	addi	a0,a0,-2 # 800084f8 <etext+0x4f8>
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	05e080e7          	jalr	94(ra) # 80000560 <panic>

000000008000350a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000350a:	1101                	addi	sp,sp,-32
    8000350c:	ec06                	sd	ra,24(sp)
    8000350e:	e822                	sd	s0,16(sp)
    80003510:	e426                	sd	s1,8(sp)
    80003512:	e04a                	sd	s2,0(sp)
    80003514:	1000                	addi	s0,sp,32
    80003516:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003518:	01050913          	addi	s2,a0,16
    8000351c:	854a                	mv	a0,s2
    8000351e:	00001097          	auipc	ra,0x1
    80003522:	44e080e7          	jalr	1102(ra) # 8000496c <holdingsleep>
    80003526:	c925                	beqz	a0,80003596 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003528:	854a                	mv	a0,s2
    8000352a:	00001097          	auipc	ra,0x1
    8000352e:	3fe080e7          	jalr	1022(ra) # 80004928 <releasesleep>

  acquire(&bcache.lock);
    80003532:	00016517          	auipc	a0,0x16
    80003536:	23650513          	addi	a0,a0,566 # 80019768 <bcache>
    8000353a:	ffffd097          	auipc	ra,0xffffd
    8000353e:	6fe080e7          	jalr	1790(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003542:	40bc                	lw	a5,64(s1)
    80003544:	37fd                	addiw	a5,a5,-1
    80003546:	0007871b          	sext.w	a4,a5
    8000354a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000354c:	e71d                	bnez	a4,8000357a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000354e:	68b8                	ld	a4,80(s1)
    80003550:	64bc                	ld	a5,72(s1)
    80003552:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003554:	68b8                	ld	a4,80(s1)
    80003556:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003558:	0001e797          	auipc	a5,0x1e
    8000355c:	21078793          	addi	a5,a5,528 # 80021768 <bcache+0x8000>
    80003560:	2b87b703          	ld	a4,696(a5)
    80003564:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003566:	0001e717          	auipc	a4,0x1e
    8000356a:	46a70713          	addi	a4,a4,1130 # 800219d0 <bcache+0x8268>
    8000356e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003570:	2b87b703          	ld	a4,696(a5)
    80003574:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003576:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000357a:	00016517          	auipc	a0,0x16
    8000357e:	1ee50513          	addi	a0,a0,494 # 80019768 <bcache>
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	76a080e7          	jalr	1898(ra) # 80000cec <release>
}
    8000358a:	60e2                	ld	ra,24(sp)
    8000358c:	6442                	ld	s0,16(sp)
    8000358e:	64a2                	ld	s1,8(sp)
    80003590:	6902                	ld	s2,0(sp)
    80003592:	6105                	addi	sp,sp,32
    80003594:	8082                	ret
    panic("brelse");
    80003596:	00005517          	auipc	a0,0x5
    8000359a:	f6a50513          	addi	a0,a0,-150 # 80008500 <etext+0x500>
    8000359e:	ffffd097          	auipc	ra,0xffffd
    800035a2:	fc2080e7          	jalr	-62(ra) # 80000560 <panic>

00000000800035a6 <bpin>:

void
bpin(struct buf *b) {
    800035a6:	1101                	addi	sp,sp,-32
    800035a8:	ec06                	sd	ra,24(sp)
    800035aa:	e822                	sd	s0,16(sp)
    800035ac:	e426                	sd	s1,8(sp)
    800035ae:	1000                	addi	s0,sp,32
    800035b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035b2:	00016517          	auipc	a0,0x16
    800035b6:	1b650513          	addi	a0,a0,438 # 80019768 <bcache>
    800035ba:	ffffd097          	auipc	ra,0xffffd
    800035be:	67e080e7          	jalr	1662(ra) # 80000c38 <acquire>
  b->refcnt++;
    800035c2:	40bc                	lw	a5,64(s1)
    800035c4:	2785                	addiw	a5,a5,1
    800035c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035c8:	00016517          	auipc	a0,0x16
    800035cc:	1a050513          	addi	a0,a0,416 # 80019768 <bcache>
    800035d0:	ffffd097          	auipc	ra,0xffffd
    800035d4:	71c080e7          	jalr	1820(ra) # 80000cec <release>
}
    800035d8:	60e2                	ld	ra,24(sp)
    800035da:	6442                	ld	s0,16(sp)
    800035dc:	64a2                	ld	s1,8(sp)
    800035de:	6105                	addi	sp,sp,32
    800035e0:	8082                	ret

00000000800035e2 <bunpin>:

void
bunpin(struct buf *b) {
    800035e2:	1101                	addi	sp,sp,-32
    800035e4:	ec06                	sd	ra,24(sp)
    800035e6:	e822                	sd	s0,16(sp)
    800035e8:	e426                	sd	s1,8(sp)
    800035ea:	1000                	addi	s0,sp,32
    800035ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035ee:	00016517          	auipc	a0,0x16
    800035f2:	17a50513          	addi	a0,a0,378 # 80019768 <bcache>
    800035f6:	ffffd097          	auipc	ra,0xffffd
    800035fa:	642080e7          	jalr	1602(ra) # 80000c38 <acquire>
  b->refcnt--;
    800035fe:	40bc                	lw	a5,64(s1)
    80003600:	37fd                	addiw	a5,a5,-1
    80003602:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003604:	00016517          	auipc	a0,0x16
    80003608:	16450513          	addi	a0,a0,356 # 80019768 <bcache>
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	6e0080e7          	jalr	1760(ra) # 80000cec <release>
}
    80003614:	60e2                	ld	ra,24(sp)
    80003616:	6442                	ld	s0,16(sp)
    80003618:	64a2                	ld	s1,8(sp)
    8000361a:	6105                	addi	sp,sp,32
    8000361c:	8082                	ret

000000008000361e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000361e:	1101                	addi	sp,sp,-32
    80003620:	ec06                	sd	ra,24(sp)
    80003622:	e822                	sd	s0,16(sp)
    80003624:	e426                	sd	s1,8(sp)
    80003626:	e04a                	sd	s2,0(sp)
    80003628:	1000                	addi	s0,sp,32
    8000362a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000362c:	00d5d59b          	srliw	a1,a1,0xd
    80003630:	0001f797          	auipc	a5,0x1f
    80003634:	8147a783          	lw	a5,-2028(a5) # 80021e44 <sb+0x1c>
    80003638:	9dbd                	addw	a1,a1,a5
    8000363a:	00000097          	auipc	ra,0x0
    8000363e:	da0080e7          	jalr	-608(ra) # 800033da <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003642:	0074f713          	andi	a4,s1,7
    80003646:	4785                	li	a5,1
    80003648:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000364c:	14ce                	slli	s1,s1,0x33
    8000364e:	90d9                	srli	s1,s1,0x36
    80003650:	00950733          	add	a4,a0,s1
    80003654:	05874703          	lbu	a4,88(a4)
    80003658:	00e7f6b3          	and	a3,a5,a4
    8000365c:	c69d                	beqz	a3,8000368a <bfree+0x6c>
    8000365e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003660:	94aa                	add	s1,s1,a0
    80003662:	fff7c793          	not	a5,a5
    80003666:	8f7d                	and	a4,a4,a5
    80003668:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000366c:	00001097          	auipc	ra,0x1
    80003670:	148080e7          	jalr	328(ra) # 800047b4 <log_write>
  brelse(bp);
    80003674:	854a                	mv	a0,s2
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	e94080e7          	jalr	-364(ra) # 8000350a <brelse>
}
    8000367e:	60e2                	ld	ra,24(sp)
    80003680:	6442                	ld	s0,16(sp)
    80003682:	64a2                	ld	s1,8(sp)
    80003684:	6902                	ld	s2,0(sp)
    80003686:	6105                	addi	sp,sp,32
    80003688:	8082                	ret
    panic("freeing free block");
    8000368a:	00005517          	auipc	a0,0x5
    8000368e:	e7e50513          	addi	a0,a0,-386 # 80008508 <etext+0x508>
    80003692:	ffffd097          	auipc	ra,0xffffd
    80003696:	ece080e7          	jalr	-306(ra) # 80000560 <panic>

000000008000369a <balloc>:
{
    8000369a:	711d                	addi	sp,sp,-96
    8000369c:	ec86                	sd	ra,88(sp)
    8000369e:	e8a2                	sd	s0,80(sp)
    800036a0:	e4a6                	sd	s1,72(sp)
    800036a2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800036a4:	0001e797          	auipc	a5,0x1e
    800036a8:	7887a783          	lw	a5,1928(a5) # 80021e2c <sb+0x4>
    800036ac:	10078f63          	beqz	a5,800037ca <balloc+0x130>
    800036b0:	e0ca                	sd	s2,64(sp)
    800036b2:	fc4e                	sd	s3,56(sp)
    800036b4:	f852                	sd	s4,48(sp)
    800036b6:	f456                	sd	s5,40(sp)
    800036b8:	f05a                	sd	s6,32(sp)
    800036ba:	ec5e                	sd	s7,24(sp)
    800036bc:	e862                	sd	s8,16(sp)
    800036be:	e466                	sd	s9,8(sp)
    800036c0:	8baa                	mv	s7,a0
    800036c2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800036c4:	0001eb17          	auipc	s6,0x1e
    800036c8:	764b0b13          	addi	s6,s6,1892 # 80021e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036cc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036ce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036d0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036d2:	6c89                	lui	s9,0x2
    800036d4:	a061                	j	8000375c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800036d6:	97ca                	add	a5,a5,s2
    800036d8:	8e55                	or	a2,a2,a3
    800036da:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800036de:	854a                	mv	a0,s2
    800036e0:	00001097          	auipc	ra,0x1
    800036e4:	0d4080e7          	jalr	212(ra) # 800047b4 <log_write>
        brelse(bp);
    800036e8:	854a                	mv	a0,s2
    800036ea:	00000097          	auipc	ra,0x0
    800036ee:	e20080e7          	jalr	-480(ra) # 8000350a <brelse>
  bp = bread(dev, bno);
    800036f2:	85a6                	mv	a1,s1
    800036f4:	855e                	mv	a0,s7
    800036f6:	00000097          	auipc	ra,0x0
    800036fa:	ce4080e7          	jalr	-796(ra) # 800033da <bread>
    800036fe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003700:	40000613          	li	a2,1024
    80003704:	4581                	li	a1,0
    80003706:	05850513          	addi	a0,a0,88
    8000370a:	ffffd097          	auipc	ra,0xffffd
    8000370e:	62a080e7          	jalr	1578(ra) # 80000d34 <memset>
  log_write(bp);
    80003712:	854a                	mv	a0,s2
    80003714:	00001097          	auipc	ra,0x1
    80003718:	0a0080e7          	jalr	160(ra) # 800047b4 <log_write>
  brelse(bp);
    8000371c:	854a                	mv	a0,s2
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	dec080e7          	jalr	-532(ra) # 8000350a <brelse>
}
    80003726:	6906                	ld	s2,64(sp)
    80003728:	79e2                	ld	s3,56(sp)
    8000372a:	7a42                	ld	s4,48(sp)
    8000372c:	7aa2                	ld	s5,40(sp)
    8000372e:	7b02                	ld	s6,32(sp)
    80003730:	6be2                	ld	s7,24(sp)
    80003732:	6c42                	ld	s8,16(sp)
    80003734:	6ca2                	ld	s9,8(sp)
}
    80003736:	8526                	mv	a0,s1
    80003738:	60e6                	ld	ra,88(sp)
    8000373a:	6446                	ld	s0,80(sp)
    8000373c:	64a6                	ld	s1,72(sp)
    8000373e:	6125                	addi	sp,sp,96
    80003740:	8082                	ret
    brelse(bp);
    80003742:	854a                	mv	a0,s2
    80003744:	00000097          	auipc	ra,0x0
    80003748:	dc6080e7          	jalr	-570(ra) # 8000350a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000374c:	015c87bb          	addw	a5,s9,s5
    80003750:	00078a9b          	sext.w	s5,a5
    80003754:	004b2703          	lw	a4,4(s6)
    80003758:	06eaf163          	bgeu	s5,a4,800037ba <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    8000375c:	41fad79b          	sraiw	a5,s5,0x1f
    80003760:	0137d79b          	srliw	a5,a5,0x13
    80003764:	015787bb          	addw	a5,a5,s5
    80003768:	40d7d79b          	sraiw	a5,a5,0xd
    8000376c:	01cb2583          	lw	a1,28(s6)
    80003770:	9dbd                	addw	a1,a1,a5
    80003772:	855e                	mv	a0,s7
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c66080e7          	jalr	-922(ra) # 800033da <bread>
    8000377c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000377e:	004b2503          	lw	a0,4(s6)
    80003782:	000a849b          	sext.w	s1,s5
    80003786:	8762                	mv	a4,s8
    80003788:	faa4fde3          	bgeu	s1,a0,80003742 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000378c:	00777693          	andi	a3,a4,7
    80003790:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003794:	41f7579b          	sraiw	a5,a4,0x1f
    80003798:	01d7d79b          	srliw	a5,a5,0x1d
    8000379c:	9fb9                	addw	a5,a5,a4
    8000379e:	4037d79b          	sraiw	a5,a5,0x3
    800037a2:	00f90633          	add	a2,s2,a5
    800037a6:	05864603          	lbu	a2,88(a2)
    800037aa:	00c6f5b3          	and	a1,a3,a2
    800037ae:	d585                	beqz	a1,800036d6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b0:	2705                	addiw	a4,a4,1
    800037b2:	2485                	addiw	s1,s1,1
    800037b4:	fd471ae3          	bne	a4,s4,80003788 <balloc+0xee>
    800037b8:	b769                	j	80003742 <balloc+0xa8>
    800037ba:	6906                	ld	s2,64(sp)
    800037bc:	79e2                	ld	s3,56(sp)
    800037be:	7a42                	ld	s4,48(sp)
    800037c0:	7aa2                	ld	s5,40(sp)
    800037c2:	7b02                	ld	s6,32(sp)
    800037c4:	6be2                	ld	s7,24(sp)
    800037c6:	6c42                	ld	s8,16(sp)
    800037c8:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800037ca:	00005517          	auipc	a0,0x5
    800037ce:	d5650513          	addi	a0,a0,-682 # 80008520 <etext+0x520>
    800037d2:	ffffd097          	auipc	ra,0xffffd
    800037d6:	dd8080e7          	jalr	-552(ra) # 800005aa <printf>
  return 0;
    800037da:	4481                	li	s1,0
    800037dc:	bfa9                	j	80003736 <balloc+0x9c>

00000000800037de <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800037de:	7179                	addi	sp,sp,-48
    800037e0:	f406                	sd	ra,40(sp)
    800037e2:	f022                	sd	s0,32(sp)
    800037e4:	ec26                	sd	s1,24(sp)
    800037e6:	e84a                	sd	s2,16(sp)
    800037e8:	e44e                	sd	s3,8(sp)
    800037ea:	1800                	addi	s0,sp,48
    800037ec:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037ee:	47ad                	li	a5,11
    800037f0:	02b7e863          	bltu	a5,a1,80003820 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800037f4:	02059793          	slli	a5,a1,0x20
    800037f8:	01e7d593          	srli	a1,a5,0x1e
    800037fc:	00b504b3          	add	s1,a0,a1
    80003800:	0504a903          	lw	s2,80(s1)
    80003804:	08091263          	bnez	s2,80003888 <bmap+0xaa>
      addr = balloc(ip->dev);
    80003808:	4108                	lw	a0,0(a0)
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	e90080e7          	jalr	-368(ra) # 8000369a <balloc>
    80003812:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003816:	06090963          	beqz	s2,80003888 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    8000381a:	0524a823          	sw	s2,80(s1)
    8000381e:	a0ad                	j	80003888 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003820:	ff45849b          	addiw	s1,a1,-12
    80003824:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003828:	0ff00793          	li	a5,255
    8000382c:	08e7e863          	bltu	a5,a4,800038bc <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003830:	08052903          	lw	s2,128(a0)
    80003834:	00091f63          	bnez	s2,80003852 <bmap+0x74>
      addr = balloc(ip->dev);
    80003838:	4108                	lw	a0,0(a0)
    8000383a:	00000097          	auipc	ra,0x0
    8000383e:	e60080e7          	jalr	-416(ra) # 8000369a <balloc>
    80003842:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003846:	04090163          	beqz	s2,80003888 <bmap+0xaa>
    8000384a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000384c:	0929a023          	sw	s2,128(s3)
    80003850:	a011                	j	80003854 <bmap+0x76>
    80003852:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003854:	85ca                	mv	a1,s2
    80003856:	0009a503          	lw	a0,0(s3)
    8000385a:	00000097          	auipc	ra,0x0
    8000385e:	b80080e7          	jalr	-1152(ra) # 800033da <bread>
    80003862:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003864:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003868:	02049713          	slli	a4,s1,0x20
    8000386c:	01e75593          	srli	a1,a4,0x1e
    80003870:	00b784b3          	add	s1,a5,a1
    80003874:	0004a903          	lw	s2,0(s1)
    80003878:	02090063          	beqz	s2,80003898 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000387c:	8552                	mv	a0,s4
    8000387e:	00000097          	auipc	ra,0x0
    80003882:	c8c080e7          	jalr	-884(ra) # 8000350a <brelse>
    return addr;
    80003886:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003888:	854a                	mv	a0,s2
    8000388a:	70a2                	ld	ra,40(sp)
    8000388c:	7402                	ld	s0,32(sp)
    8000388e:	64e2                	ld	s1,24(sp)
    80003890:	6942                	ld	s2,16(sp)
    80003892:	69a2                	ld	s3,8(sp)
    80003894:	6145                	addi	sp,sp,48
    80003896:	8082                	ret
      addr = balloc(ip->dev);
    80003898:	0009a503          	lw	a0,0(s3)
    8000389c:	00000097          	auipc	ra,0x0
    800038a0:	dfe080e7          	jalr	-514(ra) # 8000369a <balloc>
    800038a4:	0005091b          	sext.w	s2,a0
      if(addr){
    800038a8:	fc090ae3          	beqz	s2,8000387c <bmap+0x9e>
        a[bn] = addr;
    800038ac:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800038b0:	8552                	mv	a0,s4
    800038b2:	00001097          	auipc	ra,0x1
    800038b6:	f02080e7          	jalr	-254(ra) # 800047b4 <log_write>
    800038ba:	b7c9                	j	8000387c <bmap+0x9e>
    800038bc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800038be:	00005517          	auipc	a0,0x5
    800038c2:	c7a50513          	addi	a0,a0,-902 # 80008538 <etext+0x538>
    800038c6:	ffffd097          	auipc	ra,0xffffd
    800038ca:	c9a080e7          	jalr	-870(ra) # 80000560 <panic>

00000000800038ce <iget>:
{
    800038ce:	7179                	addi	sp,sp,-48
    800038d0:	f406                	sd	ra,40(sp)
    800038d2:	f022                	sd	s0,32(sp)
    800038d4:	ec26                	sd	s1,24(sp)
    800038d6:	e84a                	sd	s2,16(sp)
    800038d8:	e44e                	sd	s3,8(sp)
    800038da:	e052                	sd	s4,0(sp)
    800038dc:	1800                	addi	s0,sp,48
    800038de:	89aa                	mv	s3,a0
    800038e0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800038e2:	0001e517          	auipc	a0,0x1e
    800038e6:	56650513          	addi	a0,a0,1382 # 80021e48 <itable>
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	34e080e7          	jalr	846(ra) # 80000c38 <acquire>
  empty = 0;
    800038f2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038f4:	0001e497          	auipc	s1,0x1e
    800038f8:	56c48493          	addi	s1,s1,1388 # 80021e60 <itable+0x18>
    800038fc:	00020697          	auipc	a3,0x20
    80003900:	ff468693          	addi	a3,a3,-12 # 800238f0 <log>
    80003904:	a039                	j	80003912 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003906:	02090b63          	beqz	s2,8000393c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000390a:	08848493          	addi	s1,s1,136
    8000390e:	02d48a63          	beq	s1,a3,80003942 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003912:	449c                	lw	a5,8(s1)
    80003914:	fef059e3          	blez	a5,80003906 <iget+0x38>
    80003918:	4098                	lw	a4,0(s1)
    8000391a:	ff3716e3          	bne	a4,s3,80003906 <iget+0x38>
    8000391e:	40d8                	lw	a4,4(s1)
    80003920:	ff4713e3          	bne	a4,s4,80003906 <iget+0x38>
      ip->ref++;
    80003924:	2785                	addiw	a5,a5,1
    80003926:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003928:	0001e517          	auipc	a0,0x1e
    8000392c:	52050513          	addi	a0,a0,1312 # 80021e48 <itable>
    80003930:	ffffd097          	auipc	ra,0xffffd
    80003934:	3bc080e7          	jalr	956(ra) # 80000cec <release>
      return ip;
    80003938:	8926                	mv	s2,s1
    8000393a:	a03d                	j	80003968 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000393c:	f7f9                	bnez	a5,8000390a <iget+0x3c>
      empty = ip;
    8000393e:	8926                	mv	s2,s1
    80003940:	b7e9                	j	8000390a <iget+0x3c>
  if(empty == 0)
    80003942:	02090c63          	beqz	s2,8000397a <iget+0xac>
  ip->dev = dev;
    80003946:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000394a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000394e:	4785                	li	a5,1
    80003950:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003954:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003958:	0001e517          	auipc	a0,0x1e
    8000395c:	4f050513          	addi	a0,a0,1264 # 80021e48 <itable>
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	38c080e7          	jalr	908(ra) # 80000cec <release>
}
    80003968:	854a                	mv	a0,s2
    8000396a:	70a2                	ld	ra,40(sp)
    8000396c:	7402                	ld	s0,32(sp)
    8000396e:	64e2                	ld	s1,24(sp)
    80003970:	6942                	ld	s2,16(sp)
    80003972:	69a2                	ld	s3,8(sp)
    80003974:	6a02                	ld	s4,0(sp)
    80003976:	6145                	addi	sp,sp,48
    80003978:	8082                	ret
    panic("iget: no inodes");
    8000397a:	00005517          	auipc	a0,0x5
    8000397e:	bd650513          	addi	a0,a0,-1066 # 80008550 <etext+0x550>
    80003982:	ffffd097          	auipc	ra,0xffffd
    80003986:	bde080e7          	jalr	-1058(ra) # 80000560 <panic>

000000008000398a <fsinit>:
fsinit(int dev) {
    8000398a:	7179                	addi	sp,sp,-48
    8000398c:	f406                	sd	ra,40(sp)
    8000398e:	f022                	sd	s0,32(sp)
    80003990:	ec26                	sd	s1,24(sp)
    80003992:	e84a                	sd	s2,16(sp)
    80003994:	e44e                	sd	s3,8(sp)
    80003996:	1800                	addi	s0,sp,48
    80003998:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000399a:	4585                	li	a1,1
    8000399c:	00000097          	auipc	ra,0x0
    800039a0:	a3e080e7          	jalr	-1474(ra) # 800033da <bread>
    800039a4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039a6:	0001e997          	auipc	s3,0x1e
    800039aa:	48298993          	addi	s3,s3,1154 # 80021e28 <sb>
    800039ae:	02000613          	li	a2,32
    800039b2:	05850593          	addi	a1,a0,88
    800039b6:	854e                	mv	a0,s3
    800039b8:	ffffd097          	auipc	ra,0xffffd
    800039bc:	3d8080e7          	jalr	984(ra) # 80000d90 <memmove>
  brelse(bp);
    800039c0:	8526                	mv	a0,s1
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	b48080e7          	jalr	-1208(ra) # 8000350a <brelse>
  if(sb.magic != FSMAGIC)
    800039ca:	0009a703          	lw	a4,0(s3)
    800039ce:	102037b7          	lui	a5,0x10203
    800039d2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800039d6:	02f71263          	bne	a4,a5,800039fa <fsinit+0x70>
  initlog(dev, &sb);
    800039da:	0001e597          	auipc	a1,0x1e
    800039de:	44e58593          	addi	a1,a1,1102 # 80021e28 <sb>
    800039e2:	854a                	mv	a0,s2
    800039e4:	00001097          	auipc	ra,0x1
    800039e8:	b60080e7          	jalr	-1184(ra) # 80004544 <initlog>
}
    800039ec:	70a2                	ld	ra,40(sp)
    800039ee:	7402                	ld	s0,32(sp)
    800039f0:	64e2                	ld	s1,24(sp)
    800039f2:	6942                	ld	s2,16(sp)
    800039f4:	69a2                	ld	s3,8(sp)
    800039f6:	6145                	addi	sp,sp,48
    800039f8:	8082                	ret
    panic("invalid file system");
    800039fa:	00005517          	auipc	a0,0x5
    800039fe:	b6650513          	addi	a0,a0,-1178 # 80008560 <etext+0x560>
    80003a02:	ffffd097          	auipc	ra,0xffffd
    80003a06:	b5e080e7          	jalr	-1186(ra) # 80000560 <panic>

0000000080003a0a <iinit>:
{
    80003a0a:	7179                	addi	sp,sp,-48
    80003a0c:	f406                	sd	ra,40(sp)
    80003a0e:	f022                	sd	s0,32(sp)
    80003a10:	ec26                	sd	s1,24(sp)
    80003a12:	e84a                	sd	s2,16(sp)
    80003a14:	e44e                	sd	s3,8(sp)
    80003a16:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a18:	00005597          	auipc	a1,0x5
    80003a1c:	b6058593          	addi	a1,a1,-1184 # 80008578 <etext+0x578>
    80003a20:	0001e517          	auipc	a0,0x1e
    80003a24:	42850513          	addi	a0,a0,1064 # 80021e48 <itable>
    80003a28:	ffffd097          	auipc	ra,0xffffd
    80003a2c:	180080e7          	jalr	384(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a30:	0001e497          	auipc	s1,0x1e
    80003a34:	44048493          	addi	s1,s1,1088 # 80021e70 <itable+0x28>
    80003a38:	00020997          	auipc	s3,0x20
    80003a3c:	ec898993          	addi	s3,s3,-312 # 80023900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a40:	00005917          	auipc	s2,0x5
    80003a44:	b4090913          	addi	s2,s2,-1216 # 80008580 <etext+0x580>
    80003a48:	85ca                	mv	a1,s2
    80003a4a:	8526                	mv	a0,s1
    80003a4c:	00001097          	auipc	ra,0x1
    80003a50:	e4c080e7          	jalr	-436(ra) # 80004898 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a54:	08848493          	addi	s1,s1,136
    80003a58:	ff3498e3          	bne	s1,s3,80003a48 <iinit+0x3e>
}
    80003a5c:	70a2                	ld	ra,40(sp)
    80003a5e:	7402                	ld	s0,32(sp)
    80003a60:	64e2                	ld	s1,24(sp)
    80003a62:	6942                	ld	s2,16(sp)
    80003a64:	69a2                	ld	s3,8(sp)
    80003a66:	6145                	addi	sp,sp,48
    80003a68:	8082                	ret

0000000080003a6a <ialloc>:
{
    80003a6a:	7139                	addi	sp,sp,-64
    80003a6c:	fc06                	sd	ra,56(sp)
    80003a6e:	f822                	sd	s0,48(sp)
    80003a70:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a72:	0001e717          	auipc	a4,0x1e
    80003a76:	3c272703          	lw	a4,962(a4) # 80021e34 <sb+0xc>
    80003a7a:	4785                	li	a5,1
    80003a7c:	06e7f463          	bgeu	a5,a4,80003ae4 <ialloc+0x7a>
    80003a80:	f426                	sd	s1,40(sp)
    80003a82:	f04a                	sd	s2,32(sp)
    80003a84:	ec4e                	sd	s3,24(sp)
    80003a86:	e852                	sd	s4,16(sp)
    80003a88:	e456                	sd	s5,8(sp)
    80003a8a:	e05a                	sd	s6,0(sp)
    80003a8c:	8aaa                	mv	s5,a0
    80003a8e:	8b2e                	mv	s6,a1
    80003a90:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a92:	0001ea17          	auipc	s4,0x1e
    80003a96:	396a0a13          	addi	s4,s4,918 # 80021e28 <sb>
    80003a9a:	00495593          	srli	a1,s2,0x4
    80003a9e:	018a2783          	lw	a5,24(s4)
    80003aa2:	9dbd                	addw	a1,a1,a5
    80003aa4:	8556                	mv	a0,s5
    80003aa6:	00000097          	auipc	ra,0x0
    80003aaa:	934080e7          	jalr	-1740(ra) # 800033da <bread>
    80003aae:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003ab0:	05850993          	addi	s3,a0,88
    80003ab4:	00f97793          	andi	a5,s2,15
    80003ab8:	079a                	slli	a5,a5,0x6
    80003aba:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003abc:	00099783          	lh	a5,0(s3)
    80003ac0:	cf9d                	beqz	a5,80003afe <ialloc+0x94>
    brelse(bp);
    80003ac2:	00000097          	auipc	ra,0x0
    80003ac6:	a48080e7          	jalr	-1464(ra) # 8000350a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003aca:	0905                	addi	s2,s2,1
    80003acc:	00ca2703          	lw	a4,12(s4)
    80003ad0:	0009079b          	sext.w	a5,s2
    80003ad4:	fce7e3e3          	bltu	a5,a4,80003a9a <ialloc+0x30>
    80003ad8:	74a2                	ld	s1,40(sp)
    80003ada:	7902                	ld	s2,32(sp)
    80003adc:	69e2                	ld	s3,24(sp)
    80003ade:	6a42                	ld	s4,16(sp)
    80003ae0:	6aa2                	ld	s5,8(sp)
    80003ae2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003ae4:	00005517          	auipc	a0,0x5
    80003ae8:	aa450513          	addi	a0,a0,-1372 # 80008588 <etext+0x588>
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	abe080e7          	jalr	-1346(ra) # 800005aa <printf>
  return 0;
    80003af4:	4501                	li	a0,0
}
    80003af6:	70e2                	ld	ra,56(sp)
    80003af8:	7442                	ld	s0,48(sp)
    80003afa:	6121                	addi	sp,sp,64
    80003afc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003afe:	04000613          	li	a2,64
    80003b02:	4581                	li	a1,0
    80003b04:	854e                	mv	a0,s3
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	22e080e7          	jalr	558(ra) # 80000d34 <memset>
      dip->type = type;
    80003b0e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b12:	8526                	mv	a0,s1
    80003b14:	00001097          	auipc	ra,0x1
    80003b18:	ca0080e7          	jalr	-864(ra) # 800047b4 <log_write>
      brelse(bp);
    80003b1c:	8526                	mv	a0,s1
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	9ec080e7          	jalr	-1556(ra) # 8000350a <brelse>
      return iget(dev, inum);
    80003b26:	0009059b          	sext.w	a1,s2
    80003b2a:	8556                	mv	a0,s5
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	da2080e7          	jalr	-606(ra) # 800038ce <iget>
    80003b34:	74a2                	ld	s1,40(sp)
    80003b36:	7902                	ld	s2,32(sp)
    80003b38:	69e2                	ld	s3,24(sp)
    80003b3a:	6a42                	ld	s4,16(sp)
    80003b3c:	6aa2                	ld	s5,8(sp)
    80003b3e:	6b02                	ld	s6,0(sp)
    80003b40:	bf5d                	j	80003af6 <ialloc+0x8c>

0000000080003b42 <iupdate>:
{
    80003b42:	1101                	addi	sp,sp,-32
    80003b44:	ec06                	sd	ra,24(sp)
    80003b46:	e822                	sd	s0,16(sp)
    80003b48:	e426                	sd	s1,8(sp)
    80003b4a:	e04a                	sd	s2,0(sp)
    80003b4c:	1000                	addi	s0,sp,32
    80003b4e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b50:	415c                	lw	a5,4(a0)
    80003b52:	0047d79b          	srliw	a5,a5,0x4
    80003b56:	0001e597          	auipc	a1,0x1e
    80003b5a:	2ea5a583          	lw	a1,746(a1) # 80021e40 <sb+0x18>
    80003b5e:	9dbd                	addw	a1,a1,a5
    80003b60:	4108                	lw	a0,0(a0)
    80003b62:	00000097          	auipc	ra,0x0
    80003b66:	878080e7          	jalr	-1928(ra) # 800033da <bread>
    80003b6a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b6c:	05850793          	addi	a5,a0,88
    80003b70:	40d8                	lw	a4,4(s1)
    80003b72:	8b3d                	andi	a4,a4,15
    80003b74:	071a                	slli	a4,a4,0x6
    80003b76:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b78:	04449703          	lh	a4,68(s1)
    80003b7c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b80:	04649703          	lh	a4,70(s1)
    80003b84:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003b88:	04849703          	lh	a4,72(s1)
    80003b8c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003b90:	04a49703          	lh	a4,74(s1)
    80003b94:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b98:	44f8                	lw	a4,76(s1)
    80003b9a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b9c:	03400613          	li	a2,52
    80003ba0:	05048593          	addi	a1,s1,80
    80003ba4:	00c78513          	addi	a0,a5,12
    80003ba8:	ffffd097          	auipc	ra,0xffffd
    80003bac:	1e8080e7          	jalr	488(ra) # 80000d90 <memmove>
  log_write(bp);
    80003bb0:	854a                	mv	a0,s2
    80003bb2:	00001097          	auipc	ra,0x1
    80003bb6:	c02080e7          	jalr	-1022(ra) # 800047b4 <log_write>
  brelse(bp);
    80003bba:	854a                	mv	a0,s2
    80003bbc:	00000097          	auipc	ra,0x0
    80003bc0:	94e080e7          	jalr	-1714(ra) # 8000350a <brelse>
}
    80003bc4:	60e2                	ld	ra,24(sp)
    80003bc6:	6442                	ld	s0,16(sp)
    80003bc8:	64a2                	ld	s1,8(sp)
    80003bca:	6902                	ld	s2,0(sp)
    80003bcc:	6105                	addi	sp,sp,32
    80003bce:	8082                	ret

0000000080003bd0 <idup>:
{
    80003bd0:	1101                	addi	sp,sp,-32
    80003bd2:	ec06                	sd	ra,24(sp)
    80003bd4:	e822                	sd	s0,16(sp)
    80003bd6:	e426                	sd	s1,8(sp)
    80003bd8:	1000                	addi	s0,sp,32
    80003bda:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003bdc:	0001e517          	auipc	a0,0x1e
    80003be0:	26c50513          	addi	a0,a0,620 # 80021e48 <itable>
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	054080e7          	jalr	84(ra) # 80000c38 <acquire>
  ip->ref++;
    80003bec:	449c                	lw	a5,8(s1)
    80003bee:	2785                	addiw	a5,a5,1
    80003bf0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003bf2:	0001e517          	auipc	a0,0x1e
    80003bf6:	25650513          	addi	a0,a0,598 # 80021e48 <itable>
    80003bfa:	ffffd097          	auipc	ra,0xffffd
    80003bfe:	0f2080e7          	jalr	242(ra) # 80000cec <release>
}
    80003c02:	8526                	mv	a0,s1
    80003c04:	60e2                	ld	ra,24(sp)
    80003c06:	6442                	ld	s0,16(sp)
    80003c08:	64a2                	ld	s1,8(sp)
    80003c0a:	6105                	addi	sp,sp,32
    80003c0c:	8082                	ret

0000000080003c0e <ilock>:
{
    80003c0e:	1101                	addi	sp,sp,-32
    80003c10:	ec06                	sd	ra,24(sp)
    80003c12:	e822                	sd	s0,16(sp)
    80003c14:	e426                	sd	s1,8(sp)
    80003c16:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c18:	c10d                	beqz	a0,80003c3a <ilock+0x2c>
    80003c1a:	84aa                	mv	s1,a0
    80003c1c:	451c                	lw	a5,8(a0)
    80003c1e:	00f05e63          	blez	a5,80003c3a <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003c22:	0541                	addi	a0,a0,16
    80003c24:	00001097          	auipc	ra,0x1
    80003c28:	cae080e7          	jalr	-850(ra) # 800048d2 <acquiresleep>
  if(ip->valid == 0){
    80003c2c:	40bc                	lw	a5,64(s1)
    80003c2e:	cf99                	beqz	a5,80003c4c <ilock+0x3e>
}
    80003c30:	60e2                	ld	ra,24(sp)
    80003c32:	6442                	ld	s0,16(sp)
    80003c34:	64a2                	ld	s1,8(sp)
    80003c36:	6105                	addi	sp,sp,32
    80003c38:	8082                	ret
    80003c3a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003c3c:	00005517          	auipc	a0,0x5
    80003c40:	96450513          	addi	a0,a0,-1692 # 800085a0 <etext+0x5a0>
    80003c44:	ffffd097          	auipc	ra,0xffffd
    80003c48:	91c080e7          	jalr	-1764(ra) # 80000560 <panic>
    80003c4c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c4e:	40dc                	lw	a5,4(s1)
    80003c50:	0047d79b          	srliw	a5,a5,0x4
    80003c54:	0001e597          	auipc	a1,0x1e
    80003c58:	1ec5a583          	lw	a1,492(a1) # 80021e40 <sb+0x18>
    80003c5c:	9dbd                	addw	a1,a1,a5
    80003c5e:	4088                	lw	a0,0(s1)
    80003c60:	fffff097          	auipc	ra,0xfffff
    80003c64:	77a080e7          	jalr	1914(ra) # 800033da <bread>
    80003c68:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c6a:	05850593          	addi	a1,a0,88
    80003c6e:	40dc                	lw	a5,4(s1)
    80003c70:	8bbd                	andi	a5,a5,15
    80003c72:	079a                	slli	a5,a5,0x6
    80003c74:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c76:	00059783          	lh	a5,0(a1)
    80003c7a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c7e:	00259783          	lh	a5,2(a1)
    80003c82:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c86:	00459783          	lh	a5,4(a1)
    80003c8a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c8e:	00659783          	lh	a5,6(a1)
    80003c92:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c96:	459c                	lw	a5,8(a1)
    80003c98:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c9a:	03400613          	li	a2,52
    80003c9e:	05b1                	addi	a1,a1,12
    80003ca0:	05048513          	addi	a0,s1,80
    80003ca4:	ffffd097          	auipc	ra,0xffffd
    80003ca8:	0ec080e7          	jalr	236(ra) # 80000d90 <memmove>
    brelse(bp);
    80003cac:	854a                	mv	a0,s2
    80003cae:	00000097          	auipc	ra,0x0
    80003cb2:	85c080e7          	jalr	-1956(ra) # 8000350a <brelse>
    ip->valid = 1;
    80003cb6:	4785                	li	a5,1
    80003cb8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003cba:	04449783          	lh	a5,68(s1)
    80003cbe:	c399                	beqz	a5,80003cc4 <ilock+0xb6>
    80003cc0:	6902                	ld	s2,0(sp)
    80003cc2:	b7bd                	j	80003c30 <ilock+0x22>
      panic("ilock: no type");
    80003cc4:	00005517          	auipc	a0,0x5
    80003cc8:	8e450513          	addi	a0,a0,-1820 # 800085a8 <etext+0x5a8>
    80003ccc:	ffffd097          	auipc	ra,0xffffd
    80003cd0:	894080e7          	jalr	-1900(ra) # 80000560 <panic>

0000000080003cd4 <iunlock>:
{
    80003cd4:	1101                	addi	sp,sp,-32
    80003cd6:	ec06                	sd	ra,24(sp)
    80003cd8:	e822                	sd	s0,16(sp)
    80003cda:	e426                	sd	s1,8(sp)
    80003cdc:	e04a                	sd	s2,0(sp)
    80003cde:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003ce0:	c905                	beqz	a0,80003d10 <iunlock+0x3c>
    80003ce2:	84aa                	mv	s1,a0
    80003ce4:	01050913          	addi	s2,a0,16
    80003ce8:	854a                	mv	a0,s2
    80003cea:	00001097          	auipc	ra,0x1
    80003cee:	c82080e7          	jalr	-894(ra) # 8000496c <holdingsleep>
    80003cf2:	cd19                	beqz	a0,80003d10 <iunlock+0x3c>
    80003cf4:	449c                	lw	a5,8(s1)
    80003cf6:	00f05d63          	blez	a5,80003d10 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003cfa:	854a                	mv	a0,s2
    80003cfc:	00001097          	auipc	ra,0x1
    80003d00:	c2c080e7          	jalr	-980(ra) # 80004928 <releasesleep>
}
    80003d04:	60e2                	ld	ra,24(sp)
    80003d06:	6442                	ld	s0,16(sp)
    80003d08:	64a2                	ld	s1,8(sp)
    80003d0a:	6902                	ld	s2,0(sp)
    80003d0c:	6105                	addi	sp,sp,32
    80003d0e:	8082                	ret
    panic("iunlock");
    80003d10:	00005517          	auipc	a0,0x5
    80003d14:	8a850513          	addi	a0,a0,-1880 # 800085b8 <etext+0x5b8>
    80003d18:	ffffd097          	auipc	ra,0xffffd
    80003d1c:	848080e7          	jalr	-1976(ra) # 80000560 <panic>

0000000080003d20 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d20:	7179                	addi	sp,sp,-48
    80003d22:	f406                	sd	ra,40(sp)
    80003d24:	f022                	sd	s0,32(sp)
    80003d26:	ec26                	sd	s1,24(sp)
    80003d28:	e84a                	sd	s2,16(sp)
    80003d2a:	e44e                	sd	s3,8(sp)
    80003d2c:	1800                	addi	s0,sp,48
    80003d2e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d30:	05050493          	addi	s1,a0,80
    80003d34:	08050913          	addi	s2,a0,128
    80003d38:	a021                	j	80003d40 <itrunc+0x20>
    80003d3a:	0491                	addi	s1,s1,4
    80003d3c:	01248d63          	beq	s1,s2,80003d56 <itrunc+0x36>
    if(ip->addrs[i]){
    80003d40:	408c                	lw	a1,0(s1)
    80003d42:	dde5                	beqz	a1,80003d3a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003d44:	0009a503          	lw	a0,0(s3)
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	8d6080e7          	jalr	-1834(ra) # 8000361e <bfree>
      ip->addrs[i] = 0;
    80003d50:	0004a023          	sw	zero,0(s1)
    80003d54:	b7dd                	j	80003d3a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d56:	0809a583          	lw	a1,128(s3)
    80003d5a:	ed99                	bnez	a1,80003d78 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d5c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d60:	854e                	mv	a0,s3
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	de0080e7          	jalr	-544(ra) # 80003b42 <iupdate>
}
    80003d6a:	70a2                	ld	ra,40(sp)
    80003d6c:	7402                	ld	s0,32(sp)
    80003d6e:	64e2                	ld	s1,24(sp)
    80003d70:	6942                	ld	s2,16(sp)
    80003d72:	69a2                	ld	s3,8(sp)
    80003d74:	6145                	addi	sp,sp,48
    80003d76:	8082                	ret
    80003d78:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d7a:	0009a503          	lw	a0,0(s3)
    80003d7e:	fffff097          	auipc	ra,0xfffff
    80003d82:	65c080e7          	jalr	1628(ra) # 800033da <bread>
    80003d86:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d88:	05850493          	addi	s1,a0,88
    80003d8c:	45850913          	addi	s2,a0,1112
    80003d90:	a021                	j	80003d98 <itrunc+0x78>
    80003d92:	0491                	addi	s1,s1,4
    80003d94:	01248b63          	beq	s1,s2,80003daa <itrunc+0x8a>
      if(a[j])
    80003d98:	408c                	lw	a1,0(s1)
    80003d9a:	dde5                	beqz	a1,80003d92 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003d9c:	0009a503          	lw	a0,0(s3)
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	87e080e7          	jalr	-1922(ra) # 8000361e <bfree>
    80003da8:	b7ed                	j	80003d92 <itrunc+0x72>
    brelse(bp);
    80003daa:	8552                	mv	a0,s4
    80003dac:	fffff097          	auipc	ra,0xfffff
    80003db0:	75e080e7          	jalr	1886(ra) # 8000350a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003db4:	0809a583          	lw	a1,128(s3)
    80003db8:	0009a503          	lw	a0,0(s3)
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	862080e7          	jalr	-1950(ra) # 8000361e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003dc4:	0809a023          	sw	zero,128(s3)
    80003dc8:	6a02                	ld	s4,0(sp)
    80003dca:	bf49                	j	80003d5c <itrunc+0x3c>

0000000080003dcc <iput>:
{
    80003dcc:	1101                	addi	sp,sp,-32
    80003dce:	ec06                	sd	ra,24(sp)
    80003dd0:	e822                	sd	s0,16(sp)
    80003dd2:	e426                	sd	s1,8(sp)
    80003dd4:	1000                	addi	s0,sp,32
    80003dd6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003dd8:	0001e517          	auipc	a0,0x1e
    80003ddc:	07050513          	addi	a0,a0,112 # 80021e48 <itable>
    80003de0:	ffffd097          	auipc	ra,0xffffd
    80003de4:	e58080e7          	jalr	-424(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003de8:	4498                	lw	a4,8(s1)
    80003dea:	4785                	li	a5,1
    80003dec:	02f70263          	beq	a4,a5,80003e10 <iput+0x44>
  ip->ref--;
    80003df0:	449c                	lw	a5,8(s1)
    80003df2:	37fd                	addiw	a5,a5,-1
    80003df4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003df6:	0001e517          	auipc	a0,0x1e
    80003dfa:	05250513          	addi	a0,a0,82 # 80021e48 <itable>
    80003dfe:	ffffd097          	auipc	ra,0xffffd
    80003e02:	eee080e7          	jalr	-274(ra) # 80000cec <release>
}
    80003e06:	60e2                	ld	ra,24(sp)
    80003e08:	6442                	ld	s0,16(sp)
    80003e0a:	64a2                	ld	s1,8(sp)
    80003e0c:	6105                	addi	sp,sp,32
    80003e0e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e10:	40bc                	lw	a5,64(s1)
    80003e12:	dff9                	beqz	a5,80003df0 <iput+0x24>
    80003e14:	04a49783          	lh	a5,74(s1)
    80003e18:	ffe1                	bnez	a5,80003df0 <iput+0x24>
    80003e1a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003e1c:	01048913          	addi	s2,s1,16
    80003e20:	854a                	mv	a0,s2
    80003e22:	00001097          	auipc	ra,0x1
    80003e26:	ab0080e7          	jalr	-1360(ra) # 800048d2 <acquiresleep>
    release(&itable.lock);
    80003e2a:	0001e517          	auipc	a0,0x1e
    80003e2e:	01e50513          	addi	a0,a0,30 # 80021e48 <itable>
    80003e32:	ffffd097          	auipc	ra,0xffffd
    80003e36:	eba080e7          	jalr	-326(ra) # 80000cec <release>
    itrunc(ip);
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	ee4080e7          	jalr	-284(ra) # 80003d20 <itrunc>
    ip->type = 0;
    80003e44:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e48:	8526                	mv	a0,s1
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	cf8080e7          	jalr	-776(ra) # 80003b42 <iupdate>
    ip->valid = 0;
    80003e52:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e56:	854a                	mv	a0,s2
    80003e58:	00001097          	auipc	ra,0x1
    80003e5c:	ad0080e7          	jalr	-1328(ra) # 80004928 <releasesleep>
    acquire(&itable.lock);
    80003e60:	0001e517          	auipc	a0,0x1e
    80003e64:	fe850513          	addi	a0,a0,-24 # 80021e48 <itable>
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	dd0080e7          	jalr	-560(ra) # 80000c38 <acquire>
    80003e70:	6902                	ld	s2,0(sp)
    80003e72:	bfbd                	j	80003df0 <iput+0x24>

0000000080003e74 <iunlockput>:
{
    80003e74:	1101                	addi	sp,sp,-32
    80003e76:	ec06                	sd	ra,24(sp)
    80003e78:	e822                	sd	s0,16(sp)
    80003e7a:	e426                	sd	s1,8(sp)
    80003e7c:	1000                	addi	s0,sp,32
    80003e7e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	e54080e7          	jalr	-428(ra) # 80003cd4 <iunlock>
  iput(ip);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	f42080e7          	jalr	-190(ra) # 80003dcc <iput>
}
    80003e92:	60e2                	ld	ra,24(sp)
    80003e94:	6442                	ld	s0,16(sp)
    80003e96:	64a2                	ld	s1,8(sp)
    80003e98:	6105                	addi	sp,sp,32
    80003e9a:	8082                	ret

0000000080003e9c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003e9c:	1141                	addi	sp,sp,-16
    80003e9e:	e422                	sd	s0,8(sp)
    80003ea0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ea2:	411c                	lw	a5,0(a0)
    80003ea4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003ea6:	415c                	lw	a5,4(a0)
    80003ea8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003eaa:	04451783          	lh	a5,68(a0)
    80003eae:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003eb2:	04a51783          	lh	a5,74(a0)
    80003eb6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003eba:	04c56783          	lwu	a5,76(a0)
    80003ebe:	e99c                	sd	a5,16(a1)
}
    80003ec0:	6422                	ld	s0,8(sp)
    80003ec2:	0141                	addi	sp,sp,16
    80003ec4:	8082                	ret

0000000080003ec6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ec6:	457c                	lw	a5,76(a0)
    80003ec8:	10d7e563          	bltu	a5,a3,80003fd2 <readi+0x10c>
{
    80003ecc:	7159                	addi	sp,sp,-112
    80003ece:	f486                	sd	ra,104(sp)
    80003ed0:	f0a2                	sd	s0,96(sp)
    80003ed2:	eca6                	sd	s1,88(sp)
    80003ed4:	e0d2                	sd	s4,64(sp)
    80003ed6:	fc56                	sd	s5,56(sp)
    80003ed8:	f85a                	sd	s6,48(sp)
    80003eda:	f45e                	sd	s7,40(sp)
    80003edc:	1880                	addi	s0,sp,112
    80003ede:	8b2a                	mv	s6,a0
    80003ee0:	8bae                	mv	s7,a1
    80003ee2:	8a32                	mv	s4,a2
    80003ee4:	84b6                	mv	s1,a3
    80003ee6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003ee8:	9f35                	addw	a4,a4,a3
    return 0;
    80003eea:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003eec:	0cd76a63          	bltu	a4,a3,80003fc0 <readi+0xfa>
    80003ef0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003ef2:	00e7f463          	bgeu	a5,a4,80003efa <readi+0x34>
    n = ip->size - off;
    80003ef6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003efa:	0a0a8963          	beqz	s5,80003fac <readi+0xe6>
    80003efe:	e8ca                	sd	s2,80(sp)
    80003f00:	f062                	sd	s8,32(sp)
    80003f02:	ec66                	sd	s9,24(sp)
    80003f04:	e86a                	sd	s10,16(sp)
    80003f06:	e46e                	sd	s11,8(sp)
    80003f08:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f0a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f0e:	5c7d                	li	s8,-1
    80003f10:	a82d                	j	80003f4a <readi+0x84>
    80003f12:	020d1d93          	slli	s11,s10,0x20
    80003f16:	020ddd93          	srli	s11,s11,0x20
    80003f1a:	05890613          	addi	a2,s2,88
    80003f1e:	86ee                	mv	a3,s11
    80003f20:	963a                	add	a2,a2,a4
    80003f22:	85d2                	mv	a1,s4
    80003f24:	855e                	mv	a0,s7
    80003f26:	fffff097          	auipc	ra,0xfffff
    80003f2a:	8fa080e7          	jalr	-1798(ra) # 80002820 <either_copyout>
    80003f2e:	05850d63          	beq	a0,s8,80003f88 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f32:	854a                	mv	a0,s2
    80003f34:	fffff097          	auipc	ra,0xfffff
    80003f38:	5d6080e7          	jalr	1494(ra) # 8000350a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f3c:	013d09bb          	addw	s3,s10,s3
    80003f40:	009d04bb          	addw	s1,s10,s1
    80003f44:	9a6e                	add	s4,s4,s11
    80003f46:	0559fd63          	bgeu	s3,s5,80003fa0 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003f4a:	00a4d59b          	srliw	a1,s1,0xa
    80003f4e:	855a                	mv	a0,s6
    80003f50:	00000097          	auipc	ra,0x0
    80003f54:	88e080e7          	jalr	-1906(ra) # 800037de <bmap>
    80003f58:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f5c:	c9b1                	beqz	a1,80003fb0 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003f5e:	000b2503          	lw	a0,0(s6)
    80003f62:	fffff097          	auipc	ra,0xfffff
    80003f66:	478080e7          	jalr	1144(ra) # 800033da <bread>
    80003f6a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f6c:	3ff4f713          	andi	a4,s1,1023
    80003f70:	40ec87bb          	subw	a5,s9,a4
    80003f74:	413a86bb          	subw	a3,s5,s3
    80003f78:	8d3e                	mv	s10,a5
    80003f7a:	2781                	sext.w	a5,a5
    80003f7c:	0006861b          	sext.w	a2,a3
    80003f80:	f8f679e3          	bgeu	a2,a5,80003f12 <readi+0x4c>
    80003f84:	8d36                	mv	s10,a3
    80003f86:	b771                	j	80003f12 <readi+0x4c>
      brelse(bp);
    80003f88:	854a                	mv	a0,s2
    80003f8a:	fffff097          	auipc	ra,0xfffff
    80003f8e:	580080e7          	jalr	1408(ra) # 8000350a <brelse>
      tot = -1;
    80003f92:	59fd                	li	s3,-1
      break;
    80003f94:	6946                	ld	s2,80(sp)
    80003f96:	7c02                	ld	s8,32(sp)
    80003f98:	6ce2                	ld	s9,24(sp)
    80003f9a:	6d42                	ld	s10,16(sp)
    80003f9c:	6da2                	ld	s11,8(sp)
    80003f9e:	a831                	j	80003fba <readi+0xf4>
    80003fa0:	6946                	ld	s2,80(sp)
    80003fa2:	7c02                	ld	s8,32(sp)
    80003fa4:	6ce2                	ld	s9,24(sp)
    80003fa6:	6d42                	ld	s10,16(sp)
    80003fa8:	6da2                	ld	s11,8(sp)
    80003faa:	a801                	j	80003fba <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fac:	89d6                	mv	s3,s5
    80003fae:	a031                	j	80003fba <readi+0xf4>
    80003fb0:	6946                	ld	s2,80(sp)
    80003fb2:	7c02                	ld	s8,32(sp)
    80003fb4:	6ce2                	ld	s9,24(sp)
    80003fb6:	6d42                	ld	s10,16(sp)
    80003fb8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003fba:	0009851b          	sext.w	a0,s3
    80003fbe:	69a6                	ld	s3,72(sp)
}
    80003fc0:	70a6                	ld	ra,104(sp)
    80003fc2:	7406                	ld	s0,96(sp)
    80003fc4:	64e6                	ld	s1,88(sp)
    80003fc6:	6a06                	ld	s4,64(sp)
    80003fc8:	7ae2                	ld	s5,56(sp)
    80003fca:	7b42                	ld	s6,48(sp)
    80003fcc:	7ba2                	ld	s7,40(sp)
    80003fce:	6165                	addi	sp,sp,112
    80003fd0:	8082                	ret
    return 0;
    80003fd2:	4501                	li	a0,0
}
    80003fd4:	8082                	ret

0000000080003fd6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fd6:	457c                	lw	a5,76(a0)
    80003fd8:	10d7ee63          	bltu	a5,a3,800040f4 <writei+0x11e>
{
    80003fdc:	7159                	addi	sp,sp,-112
    80003fde:	f486                	sd	ra,104(sp)
    80003fe0:	f0a2                	sd	s0,96(sp)
    80003fe2:	e8ca                	sd	s2,80(sp)
    80003fe4:	e0d2                	sd	s4,64(sp)
    80003fe6:	fc56                	sd	s5,56(sp)
    80003fe8:	f85a                	sd	s6,48(sp)
    80003fea:	f45e                	sd	s7,40(sp)
    80003fec:	1880                	addi	s0,sp,112
    80003fee:	8aaa                	mv	s5,a0
    80003ff0:	8bae                	mv	s7,a1
    80003ff2:	8a32                	mv	s4,a2
    80003ff4:	8936                	mv	s2,a3
    80003ff6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ff8:	00e687bb          	addw	a5,a3,a4
    80003ffc:	0ed7ee63          	bltu	a5,a3,800040f8 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004000:	00043737          	lui	a4,0x43
    80004004:	0ef76c63          	bltu	a4,a5,800040fc <writei+0x126>
    80004008:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000400a:	0c0b0d63          	beqz	s6,800040e4 <writei+0x10e>
    8000400e:	eca6                	sd	s1,88(sp)
    80004010:	f062                	sd	s8,32(sp)
    80004012:	ec66                	sd	s9,24(sp)
    80004014:	e86a                	sd	s10,16(sp)
    80004016:	e46e                	sd	s11,8(sp)
    80004018:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000401a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000401e:	5c7d                	li	s8,-1
    80004020:	a091                	j	80004064 <writei+0x8e>
    80004022:	020d1d93          	slli	s11,s10,0x20
    80004026:	020ddd93          	srli	s11,s11,0x20
    8000402a:	05848513          	addi	a0,s1,88
    8000402e:	86ee                	mv	a3,s11
    80004030:	8652                	mv	a2,s4
    80004032:	85de                	mv	a1,s7
    80004034:	953a                	add	a0,a0,a4
    80004036:	fffff097          	auipc	ra,0xfffff
    8000403a:	840080e7          	jalr	-1984(ra) # 80002876 <either_copyin>
    8000403e:	07850263          	beq	a0,s8,800040a2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004042:	8526                	mv	a0,s1
    80004044:	00000097          	auipc	ra,0x0
    80004048:	770080e7          	jalr	1904(ra) # 800047b4 <log_write>
    brelse(bp);
    8000404c:	8526                	mv	a0,s1
    8000404e:	fffff097          	auipc	ra,0xfffff
    80004052:	4bc080e7          	jalr	1212(ra) # 8000350a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004056:	013d09bb          	addw	s3,s10,s3
    8000405a:	012d093b          	addw	s2,s10,s2
    8000405e:	9a6e                	add	s4,s4,s11
    80004060:	0569f663          	bgeu	s3,s6,800040ac <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004064:	00a9559b          	srliw	a1,s2,0xa
    80004068:	8556                	mv	a0,s5
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	774080e7          	jalr	1908(ra) # 800037de <bmap>
    80004072:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004076:	c99d                	beqz	a1,800040ac <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004078:	000aa503          	lw	a0,0(s5)
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	35e080e7          	jalr	862(ra) # 800033da <bread>
    80004084:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004086:	3ff97713          	andi	a4,s2,1023
    8000408a:	40ec87bb          	subw	a5,s9,a4
    8000408e:	413b06bb          	subw	a3,s6,s3
    80004092:	8d3e                	mv	s10,a5
    80004094:	2781                	sext.w	a5,a5
    80004096:	0006861b          	sext.w	a2,a3
    8000409a:	f8f674e3          	bgeu	a2,a5,80004022 <writei+0x4c>
    8000409e:	8d36                	mv	s10,a3
    800040a0:	b749                	j	80004022 <writei+0x4c>
      brelse(bp);
    800040a2:	8526                	mv	a0,s1
    800040a4:	fffff097          	auipc	ra,0xfffff
    800040a8:	466080e7          	jalr	1126(ra) # 8000350a <brelse>
  }

  if(off > ip->size)
    800040ac:	04caa783          	lw	a5,76(s5)
    800040b0:	0327fc63          	bgeu	a5,s2,800040e8 <writei+0x112>
    ip->size = off;
    800040b4:	052aa623          	sw	s2,76(s5)
    800040b8:	64e6                	ld	s1,88(sp)
    800040ba:	7c02                	ld	s8,32(sp)
    800040bc:	6ce2                	ld	s9,24(sp)
    800040be:	6d42                	ld	s10,16(sp)
    800040c0:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800040c2:	8556                	mv	a0,s5
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	a7e080e7          	jalr	-1410(ra) # 80003b42 <iupdate>

  return tot;
    800040cc:	0009851b          	sext.w	a0,s3
    800040d0:	69a6                	ld	s3,72(sp)
}
    800040d2:	70a6                	ld	ra,104(sp)
    800040d4:	7406                	ld	s0,96(sp)
    800040d6:	6946                	ld	s2,80(sp)
    800040d8:	6a06                	ld	s4,64(sp)
    800040da:	7ae2                	ld	s5,56(sp)
    800040dc:	7b42                	ld	s6,48(sp)
    800040de:	7ba2                	ld	s7,40(sp)
    800040e0:	6165                	addi	sp,sp,112
    800040e2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040e4:	89da                	mv	s3,s6
    800040e6:	bff1                	j	800040c2 <writei+0xec>
    800040e8:	64e6                	ld	s1,88(sp)
    800040ea:	7c02                	ld	s8,32(sp)
    800040ec:	6ce2                	ld	s9,24(sp)
    800040ee:	6d42                	ld	s10,16(sp)
    800040f0:	6da2                	ld	s11,8(sp)
    800040f2:	bfc1                	j	800040c2 <writei+0xec>
    return -1;
    800040f4:	557d                	li	a0,-1
}
    800040f6:	8082                	ret
    return -1;
    800040f8:	557d                	li	a0,-1
    800040fa:	bfe1                	j	800040d2 <writei+0xfc>
    return -1;
    800040fc:	557d                	li	a0,-1
    800040fe:	bfd1                	j	800040d2 <writei+0xfc>

0000000080004100 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004100:	1141                	addi	sp,sp,-16
    80004102:	e406                	sd	ra,8(sp)
    80004104:	e022                	sd	s0,0(sp)
    80004106:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004108:	4639                	li	a2,14
    8000410a:	ffffd097          	auipc	ra,0xffffd
    8000410e:	cfa080e7          	jalr	-774(ra) # 80000e04 <strncmp>
}
    80004112:	60a2                	ld	ra,8(sp)
    80004114:	6402                	ld	s0,0(sp)
    80004116:	0141                	addi	sp,sp,16
    80004118:	8082                	ret

000000008000411a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000411a:	7139                	addi	sp,sp,-64
    8000411c:	fc06                	sd	ra,56(sp)
    8000411e:	f822                	sd	s0,48(sp)
    80004120:	f426                	sd	s1,40(sp)
    80004122:	f04a                	sd	s2,32(sp)
    80004124:	ec4e                	sd	s3,24(sp)
    80004126:	e852                	sd	s4,16(sp)
    80004128:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000412a:	04451703          	lh	a4,68(a0)
    8000412e:	4785                	li	a5,1
    80004130:	00f71a63          	bne	a4,a5,80004144 <dirlookup+0x2a>
    80004134:	892a                	mv	s2,a0
    80004136:	89ae                	mv	s3,a1
    80004138:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000413a:	457c                	lw	a5,76(a0)
    8000413c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000413e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004140:	e79d                	bnez	a5,8000416e <dirlookup+0x54>
    80004142:	a8a5                	j	800041ba <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004144:	00004517          	auipc	a0,0x4
    80004148:	47c50513          	addi	a0,a0,1148 # 800085c0 <etext+0x5c0>
    8000414c:	ffffc097          	auipc	ra,0xffffc
    80004150:	414080e7          	jalr	1044(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004154:	00004517          	auipc	a0,0x4
    80004158:	48450513          	addi	a0,a0,1156 # 800085d8 <etext+0x5d8>
    8000415c:	ffffc097          	auipc	ra,0xffffc
    80004160:	404080e7          	jalr	1028(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004164:	24c1                	addiw	s1,s1,16
    80004166:	04c92783          	lw	a5,76(s2)
    8000416a:	04f4f763          	bgeu	s1,a5,800041b8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000416e:	4741                	li	a4,16
    80004170:	86a6                	mv	a3,s1
    80004172:	fc040613          	addi	a2,s0,-64
    80004176:	4581                	li	a1,0
    80004178:	854a                	mv	a0,s2
    8000417a:	00000097          	auipc	ra,0x0
    8000417e:	d4c080e7          	jalr	-692(ra) # 80003ec6 <readi>
    80004182:	47c1                	li	a5,16
    80004184:	fcf518e3          	bne	a0,a5,80004154 <dirlookup+0x3a>
    if(de.inum == 0)
    80004188:	fc045783          	lhu	a5,-64(s0)
    8000418c:	dfe1                	beqz	a5,80004164 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000418e:	fc240593          	addi	a1,s0,-62
    80004192:	854e                	mv	a0,s3
    80004194:	00000097          	auipc	ra,0x0
    80004198:	f6c080e7          	jalr	-148(ra) # 80004100 <namecmp>
    8000419c:	f561                	bnez	a0,80004164 <dirlookup+0x4a>
      if(poff)
    8000419e:	000a0463          	beqz	s4,800041a6 <dirlookup+0x8c>
        *poff = off;
    800041a2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041a6:	fc045583          	lhu	a1,-64(s0)
    800041aa:	00092503          	lw	a0,0(s2)
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	720080e7          	jalr	1824(ra) # 800038ce <iget>
    800041b6:	a011                	j	800041ba <dirlookup+0xa0>
  return 0;
    800041b8:	4501                	li	a0,0
}
    800041ba:	70e2                	ld	ra,56(sp)
    800041bc:	7442                	ld	s0,48(sp)
    800041be:	74a2                	ld	s1,40(sp)
    800041c0:	7902                	ld	s2,32(sp)
    800041c2:	69e2                	ld	s3,24(sp)
    800041c4:	6a42                	ld	s4,16(sp)
    800041c6:	6121                	addi	sp,sp,64
    800041c8:	8082                	ret

00000000800041ca <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800041ca:	711d                	addi	sp,sp,-96
    800041cc:	ec86                	sd	ra,88(sp)
    800041ce:	e8a2                	sd	s0,80(sp)
    800041d0:	e4a6                	sd	s1,72(sp)
    800041d2:	e0ca                	sd	s2,64(sp)
    800041d4:	fc4e                	sd	s3,56(sp)
    800041d6:	f852                	sd	s4,48(sp)
    800041d8:	f456                	sd	s5,40(sp)
    800041da:	f05a                	sd	s6,32(sp)
    800041dc:	ec5e                	sd	s7,24(sp)
    800041de:	e862                	sd	s8,16(sp)
    800041e0:	e466                	sd	s9,8(sp)
    800041e2:	1080                	addi	s0,sp,96
    800041e4:	84aa                	mv	s1,a0
    800041e6:	8b2e                	mv	s6,a1
    800041e8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800041ea:	00054703          	lbu	a4,0(a0)
    800041ee:	02f00793          	li	a5,47
    800041f2:	02f70263          	beq	a4,a5,80004216 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800041f6:	ffffe097          	auipc	ra,0xffffe
    800041fa:	a4a080e7          	jalr	-1462(ra) # 80001c40 <myproc>
    800041fe:	15053503          	ld	a0,336(a0)
    80004202:	00000097          	auipc	ra,0x0
    80004206:	9ce080e7          	jalr	-1586(ra) # 80003bd0 <idup>
    8000420a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000420c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004210:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004212:	4b85                	li	s7,1
    80004214:	a875                	j	800042d0 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80004216:	4585                	li	a1,1
    80004218:	4505                	li	a0,1
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	6b4080e7          	jalr	1716(ra) # 800038ce <iget>
    80004222:	8a2a                	mv	s4,a0
    80004224:	b7e5                	j	8000420c <namex+0x42>
      iunlockput(ip);
    80004226:	8552                	mv	a0,s4
    80004228:	00000097          	auipc	ra,0x0
    8000422c:	c4c080e7          	jalr	-948(ra) # 80003e74 <iunlockput>
      return 0;
    80004230:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004232:	8552                	mv	a0,s4
    80004234:	60e6                	ld	ra,88(sp)
    80004236:	6446                	ld	s0,80(sp)
    80004238:	64a6                	ld	s1,72(sp)
    8000423a:	6906                	ld	s2,64(sp)
    8000423c:	79e2                	ld	s3,56(sp)
    8000423e:	7a42                	ld	s4,48(sp)
    80004240:	7aa2                	ld	s5,40(sp)
    80004242:	7b02                	ld	s6,32(sp)
    80004244:	6be2                	ld	s7,24(sp)
    80004246:	6c42                	ld	s8,16(sp)
    80004248:	6ca2                	ld	s9,8(sp)
    8000424a:	6125                	addi	sp,sp,96
    8000424c:	8082                	ret
      iunlock(ip);
    8000424e:	8552                	mv	a0,s4
    80004250:	00000097          	auipc	ra,0x0
    80004254:	a84080e7          	jalr	-1404(ra) # 80003cd4 <iunlock>
      return ip;
    80004258:	bfe9                	j	80004232 <namex+0x68>
      iunlockput(ip);
    8000425a:	8552                	mv	a0,s4
    8000425c:	00000097          	auipc	ra,0x0
    80004260:	c18080e7          	jalr	-1000(ra) # 80003e74 <iunlockput>
      return 0;
    80004264:	8a4e                	mv	s4,s3
    80004266:	b7f1                	j	80004232 <namex+0x68>
  len = path - s;
    80004268:	40998633          	sub	a2,s3,s1
    8000426c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004270:	099c5863          	bge	s8,s9,80004300 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004274:	4639                	li	a2,14
    80004276:	85a6                	mv	a1,s1
    80004278:	8556                	mv	a0,s5
    8000427a:	ffffd097          	auipc	ra,0xffffd
    8000427e:	b16080e7          	jalr	-1258(ra) # 80000d90 <memmove>
    80004282:	84ce                	mv	s1,s3
  while(*path == '/')
    80004284:	0004c783          	lbu	a5,0(s1)
    80004288:	01279763          	bne	a5,s2,80004296 <namex+0xcc>
    path++;
    8000428c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000428e:	0004c783          	lbu	a5,0(s1)
    80004292:	ff278de3          	beq	a5,s2,8000428c <namex+0xc2>
    ilock(ip);
    80004296:	8552                	mv	a0,s4
    80004298:	00000097          	auipc	ra,0x0
    8000429c:	976080e7          	jalr	-1674(ra) # 80003c0e <ilock>
    if(ip->type != T_DIR){
    800042a0:	044a1783          	lh	a5,68(s4)
    800042a4:	f97791e3          	bne	a5,s7,80004226 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800042a8:	000b0563          	beqz	s6,800042b2 <namex+0xe8>
    800042ac:	0004c783          	lbu	a5,0(s1)
    800042b0:	dfd9                	beqz	a5,8000424e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800042b2:	4601                	li	a2,0
    800042b4:	85d6                	mv	a1,s5
    800042b6:	8552                	mv	a0,s4
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	e62080e7          	jalr	-414(ra) # 8000411a <dirlookup>
    800042c0:	89aa                	mv	s3,a0
    800042c2:	dd41                	beqz	a0,8000425a <namex+0x90>
    iunlockput(ip);
    800042c4:	8552                	mv	a0,s4
    800042c6:	00000097          	auipc	ra,0x0
    800042ca:	bae080e7          	jalr	-1106(ra) # 80003e74 <iunlockput>
    ip = next;
    800042ce:	8a4e                	mv	s4,s3
  while(*path == '/')
    800042d0:	0004c783          	lbu	a5,0(s1)
    800042d4:	01279763          	bne	a5,s2,800042e2 <namex+0x118>
    path++;
    800042d8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042da:	0004c783          	lbu	a5,0(s1)
    800042de:	ff278de3          	beq	a5,s2,800042d8 <namex+0x10e>
  if(*path == 0)
    800042e2:	cb9d                	beqz	a5,80004318 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800042e4:	0004c783          	lbu	a5,0(s1)
    800042e8:	89a6                	mv	s3,s1
  len = path - s;
    800042ea:	4c81                	li	s9,0
    800042ec:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800042ee:	01278963          	beq	a5,s2,80004300 <namex+0x136>
    800042f2:	dbbd                	beqz	a5,80004268 <namex+0x9e>
    path++;
    800042f4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800042f6:	0009c783          	lbu	a5,0(s3)
    800042fa:	ff279ce3          	bne	a5,s2,800042f2 <namex+0x128>
    800042fe:	b7ad                	j	80004268 <namex+0x9e>
    memmove(name, s, len);
    80004300:	2601                	sext.w	a2,a2
    80004302:	85a6                	mv	a1,s1
    80004304:	8556                	mv	a0,s5
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	a8a080e7          	jalr	-1398(ra) # 80000d90 <memmove>
    name[len] = 0;
    8000430e:	9cd6                	add	s9,s9,s5
    80004310:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004314:	84ce                	mv	s1,s3
    80004316:	b7bd                	j	80004284 <namex+0xba>
  if(nameiparent){
    80004318:	f00b0de3          	beqz	s6,80004232 <namex+0x68>
    iput(ip);
    8000431c:	8552                	mv	a0,s4
    8000431e:	00000097          	auipc	ra,0x0
    80004322:	aae080e7          	jalr	-1362(ra) # 80003dcc <iput>
    return 0;
    80004326:	4a01                	li	s4,0
    80004328:	b729                	j	80004232 <namex+0x68>

000000008000432a <dirlink>:
{
    8000432a:	7139                	addi	sp,sp,-64
    8000432c:	fc06                	sd	ra,56(sp)
    8000432e:	f822                	sd	s0,48(sp)
    80004330:	f04a                	sd	s2,32(sp)
    80004332:	ec4e                	sd	s3,24(sp)
    80004334:	e852                	sd	s4,16(sp)
    80004336:	0080                	addi	s0,sp,64
    80004338:	892a                	mv	s2,a0
    8000433a:	8a2e                	mv	s4,a1
    8000433c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000433e:	4601                	li	a2,0
    80004340:	00000097          	auipc	ra,0x0
    80004344:	dda080e7          	jalr	-550(ra) # 8000411a <dirlookup>
    80004348:	ed25                	bnez	a0,800043c0 <dirlink+0x96>
    8000434a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000434c:	04c92483          	lw	s1,76(s2)
    80004350:	c49d                	beqz	s1,8000437e <dirlink+0x54>
    80004352:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004354:	4741                	li	a4,16
    80004356:	86a6                	mv	a3,s1
    80004358:	fc040613          	addi	a2,s0,-64
    8000435c:	4581                	li	a1,0
    8000435e:	854a                	mv	a0,s2
    80004360:	00000097          	auipc	ra,0x0
    80004364:	b66080e7          	jalr	-1178(ra) # 80003ec6 <readi>
    80004368:	47c1                	li	a5,16
    8000436a:	06f51163          	bne	a0,a5,800043cc <dirlink+0xa2>
    if(de.inum == 0)
    8000436e:	fc045783          	lhu	a5,-64(s0)
    80004372:	c791                	beqz	a5,8000437e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004374:	24c1                	addiw	s1,s1,16
    80004376:	04c92783          	lw	a5,76(s2)
    8000437a:	fcf4ede3          	bltu	s1,a5,80004354 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000437e:	4639                	li	a2,14
    80004380:	85d2                	mv	a1,s4
    80004382:	fc240513          	addi	a0,s0,-62
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	ab4080e7          	jalr	-1356(ra) # 80000e3a <strncpy>
  de.inum = inum;
    8000438e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004392:	4741                	li	a4,16
    80004394:	86a6                	mv	a3,s1
    80004396:	fc040613          	addi	a2,s0,-64
    8000439a:	4581                	li	a1,0
    8000439c:	854a                	mv	a0,s2
    8000439e:	00000097          	auipc	ra,0x0
    800043a2:	c38080e7          	jalr	-968(ra) # 80003fd6 <writei>
    800043a6:	1541                	addi	a0,a0,-16
    800043a8:	00a03533          	snez	a0,a0
    800043ac:	40a00533          	neg	a0,a0
    800043b0:	74a2                	ld	s1,40(sp)
}
    800043b2:	70e2                	ld	ra,56(sp)
    800043b4:	7442                	ld	s0,48(sp)
    800043b6:	7902                	ld	s2,32(sp)
    800043b8:	69e2                	ld	s3,24(sp)
    800043ba:	6a42                	ld	s4,16(sp)
    800043bc:	6121                	addi	sp,sp,64
    800043be:	8082                	ret
    iput(ip);
    800043c0:	00000097          	auipc	ra,0x0
    800043c4:	a0c080e7          	jalr	-1524(ra) # 80003dcc <iput>
    return -1;
    800043c8:	557d                	li	a0,-1
    800043ca:	b7e5                	j	800043b2 <dirlink+0x88>
      panic("dirlink read");
    800043cc:	00004517          	auipc	a0,0x4
    800043d0:	21c50513          	addi	a0,a0,540 # 800085e8 <etext+0x5e8>
    800043d4:	ffffc097          	auipc	ra,0xffffc
    800043d8:	18c080e7          	jalr	396(ra) # 80000560 <panic>

00000000800043dc <namei>:

struct inode*
namei(char *path)
{
    800043dc:	1101                	addi	sp,sp,-32
    800043de:	ec06                	sd	ra,24(sp)
    800043e0:	e822                	sd	s0,16(sp)
    800043e2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800043e4:	fe040613          	addi	a2,s0,-32
    800043e8:	4581                	li	a1,0
    800043ea:	00000097          	auipc	ra,0x0
    800043ee:	de0080e7          	jalr	-544(ra) # 800041ca <namex>
}
    800043f2:	60e2                	ld	ra,24(sp)
    800043f4:	6442                	ld	s0,16(sp)
    800043f6:	6105                	addi	sp,sp,32
    800043f8:	8082                	ret

00000000800043fa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800043fa:	1141                	addi	sp,sp,-16
    800043fc:	e406                	sd	ra,8(sp)
    800043fe:	e022                	sd	s0,0(sp)
    80004400:	0800                	addi	s0,sp,16
    80004402:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004404:	4585                	li	a1,1
    80004406:	00000097          	auipc	ra,0x0
    8000440a:	dc4080e7          	jalr	-572(ra) # 800041ca <namex>
}
    8000440e:	60a2                	ld	ra,8(sp)
    80004410:	6402                	ld	s0,0(sp)
    80004412:	0141                	addi	sp,sp,16
    80004414:	8082                	ret

0000000080004416 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004416:	1101                	addi	sp,sp,-32
    80004418:	ec06                	sd	ra,24(sp)
    8000441a:	e822                	sd	s0,16(sp)
    8000441c:	e426                	sd	s1,8(sp)
    8000441e:	e04a                	sd	s2,0(sp)
    80004420:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004422:	0001f917          	auipc	s2,0x1f
    80004426:	4ce90913          	addi	s2,s2,1230 # 800238f0 <log>
    8000442a:	01892583          	lw	a1,24(s2)
    8000442e:	02892503          	lw	a0,40(s2)
    80004432:	fffff097          	auipc	ra,0xfffff
    80004436:	fa8080e7          	jalr	-88(ra) # 800033da <bread>
    8000443a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000443c:	02c92603          	lw	a2,44(s2)
    80004440:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004442:	00c05f63          	blez	a2,80004460 <write_head+0x4a>
    80004446:	0001f717          	auipc	a4,0x1f
    8000444a:	4da70713          	addi	a4,a4,1242 # 80023920 <log+0x30>
    8000444e:	87aa                	mv	a5,a0
    80004450:	060a                	slli	a2,a2,0x2
    80004452:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004454:	4314                	lw	a3,0(a4)
    80004456:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004458:	0711                	addi	a4,a4,4
    8000445a:	0791                	addi	a5,a5,4
    8000445c:	fec79ce3          	bne	a5,a2,80004454 <write_head+0x3e>
  }
  bwrite(buf);
    80004460:	8526                	mv	a0,s1
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	06a080e7          	jalr	106(ra) # 800034cc <bwrite>
  brelse(buf);
    8000446a:	8526                	mv	a0,s1
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	09e080e7          	jalr	158(ra) # 8000350a <brelse>
}
    80004474:	60e2                	ld	ra,24(sp)
    80004476:	6442                	ld	s0,16(sp)
    80004478:	64a2                	ld	s1,8(sp)
    8000447a:	6902                	ld	s2,0(sp)
    8000447c:	6105                	addi	sp,sp,32
    8000447e:	8082                	ret

0000000080004480 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004480:	0001f797          	auipc	a5,0x1f
    80004484:	49c7a783          	lw	a5,1180(a5) # 8002391c <log+0x2c>
    80004488:	0af05d63          	blez	a5,80004542 <install_trans+0xc2>
{
    8000448c:	7139                	addi	sp,sp,-64
    8000448e:	fc06                	sd	ra,56(sp)
    80004490:	f822                	sd	s0,48(sp)
    80004492:	f426                	sd	s1,40(sp)
    80004494:	f04a                	sd	s2,32(sp)
    80004496:	ec4e                	sd	s3,24(sp)
    80004498:	e852                	sd	s4,16(sp)
    8000449a:	e456                	sd	s5,8(sp)
    8000449c:	e05a                	sd	s6,0(sp)
    8000449e:	0080                	addi	s0,sp,64
    800044a0:	8b2a                	mv	s6,a0
    800044a2:	0001fa97          	auipc	s5,0x1f
    800044a6:	47ea8a93          	addi	s5,s5,1150 # 80023920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044aa:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044ac:	0001f997          	auipc	s3,0x1f
    800044b0:	44498993          	addi	s3,s3,1092 # 800238f0 <log>
    800044b4:	a00d                	j	800044d6 <install_trans+0x56>
    brelse(lbuf);
    800044b6:	854a                	mv	a0,s2
    800044b8:	fffff097          	auipc	ra,0xfffff
    800044bc:	052080e7          	jalr	82(ra) # 8000350a <brelse>
    brelse(dbuf);
    800044c0:	8526                	mv	a0,s1
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	048080e7          	jalr	72(ra) # 8000350a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ca:	2a05                	addiw	s4,s4,1
    800044cc:	0a91                	addi	s5,s5,4
    800044ce:	02c9a783          	lw	a5,44(s3)
    800044d2:	04fa5e63          	bge	s4,a5,8000452e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044d6:	0189a583          	lw	a1,24(s3)
    800044da:	014585bb          	addw	a1,a1,s4
    800044de:	2585                	addiw	a1,a1,1
    800044e0:	0289a503          	lw	a0,40(s3)
    800044e4:	fffff097          	auipc	ra,0xfffff
    800044e8:	ef6080e7          	jalr	-266(ra) # 800033da <bread>
    800044ec:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800044ee:	000aa583          	lw	a1,0(s5)
    800044f2:	0289a503          	lw	a0,40(s3)
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	ee4080e7          	jalr	-284(ra) # 800033da <bread>
    800044fe:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004500:	40000613          	li	a2,1024
    80004504:	05890593          	addi	a1,s2,88
    80004508:	05850513          	addi	a0,a0,88
    8000450c:	ffffd097          	auipc	ra,0xffffd
    80004510:	884080e7          	jalr	-1916(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004514:	8526                	mv	a0,s1
    80004516:	fffff097          	auipc	ra,0xfffff
    8000451a:	fb6080e7          	jalr	-74(ra) # 800034cc <bwrite>
    if(recovering == 0)
    8000451e:	f80b1ce3          	bnez	s6,800044b6 <install_trans+0x36>
      bunpin(dbuf);
    80004522:	8526                	mv	a0,s1
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	0be080e7          	jalr	190(ra) # 800035e2 <bunpin>
    8000452c:	b769                	j	800044b6 <install_trans+0x36>
}
    8000452e:	70e2                	ld	ra,56(sp)
    80004530:	7442                	ld	s0,48(sp)
    80004532:	74a2                	ld	s1,40(sp)
    80004534:	7902                	ld	s2,32(sp)
    80004536:	69e2                	ld	s3,24(sp)
    80004538:	6a42                	ld	s4,16(sp)
    8000453a:	6aa2                	ld	s5,8(sp)
    8000453c:	6b02                	ld	s6,0(sp)
    8000453e:	6121                	addi	sp,sp,64
    80004540:	8082                	ret
    80004542:	8082                	ret

0000000080004544 <initlog>:
{
    80004544:	7179                	addi	sp,sp,-48
    80004546:	f406                	sd	ra,40(sp)
    80004548:	f022                	sd	s0,32(sp)
    8000454a:	ec26                	sd	s1,24(sp)
    8000454c:	e84a                	sd	s2,16(sp)
    8000454e:	e44e                	sd	s3,8(sp)
    80004550:	1800                	addi	s0,sp,48
    80004552:	892a                	mv	s2,a0
    80004554:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004556:	0001f497          	auipc	s1,0x1f
    8000455a:	39a48493          	addi	s1,s1,922 # 800238f0 <log>
    8000455e:	00004597          	auipc	a1,0x4
    80004562:	09a58593          	addi	a1,a1,154 # 800085f8 <etext+0x5f8>
    80004566:	8526                	mv	a0,s1
    80004568:	ffffc097          	auipc	ra,0xffffc
    8000456c:	640080e7          	jalr	1600(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    80004570:	0149a583          	lw	a1,20(s3)
    80004574:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004576:	0109a783          	lw	a5,16(s3)
    8000457a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000457c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004580:	854a                	mv	a0,s2
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	e58080e7          	jalr	-424(ra) # 800033da <bread>
  log.lh.n = lh->n;
    8000458a:	4d30                	lw	a2,88(a0)
    8000458c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000458e:	00c05f63          	blez	a2,800045ac <initlog+0x68>
    80004592:	87aa                	mv	a5,a0
    80004594:	0001f717          	auipc	a4,0x1f
    80004598:	38c70713          	addi	a4,a4,908 # 80023920 <log+0x30>
    8000459c:	060a                	slli	a2,a2,0x2
    8000459e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800045a0:	4ff4                	lw	a3,92(a5)
    800045a2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045a4:	0791                	addi	a5,a5,4
    800045a6:	0711                	addi	a4,a4,4
    800045a8:	fec79ce3          	bne	a5,a2,800045a0 <initlog+0x5c>
  brelse(buf);
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	f5e080e7          	jalr	-162(ra) # 8000350a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045b4:	4505                	li	a0,1
    800045b6:	00000097          	auipc	ra,0x0
    800045ba:	eca080e7          	jalr	-310(ra) # 80004480 <install_trans>
  log.lh.n = 0;
    800045be:	0001f797          	auipc	a5,0x1f
    800045c2:	3407af23          	sw	zero,862(a5) # 8002391c <log+0x2c>
  write_head(); // clear the log
    800045c6:	00000097          	auipc	ra,0x0
    800045ca:	e50080e7          	jalr	-432(ra) # 80004416 <write_head>
}
    800045ce:	70a2                	ld	ra,40(sp)
    800045d0:	7402                	ld	s0,32(sp)
    800045d2:	64e2                	ld	s1,24(sp)
    800045d4:	6942                	ld	s2,16(sp)
    800045d6:	69a2                	ld	s3,8(sp)
    800045d8:	6145                	addi	sp,sp,48
    800045da:	8082                	ret

00000000800045dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800045dc:	1101                	addi	sp,sp,-32
    800045de:	ec06                	sd	ra,24(sp)
    800045e0:	e822                	sd	s0,16(sp)
    800045e2:	e426                	sd	s1,8(sp)
    800045e4:	e04a                	sd	s2,0(sp)
    800045e6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800045e8:	0001f517          	auipc	a0,0x1f
    800045ec:	30850513          	addi	a0,a0,776 # 800238f0 <log>
    800045f0:	ffffc097          	auipc	ra,0xffffc
    800045f4:	648080e7          	jalr	1608(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    800045f8:	0001f497          	auipc	s1,0x1f
    800045fc:	2f848493          	addi	s1,s1,760 # 800238f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004600:	4979                	li	s2,30
    80004602:	a039                	j	80004610 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004604:	85a6                	mv	a1,s1
    80004606:	8526                	mv	a0,s1
    80004608:	ffffe097          	auipc	ra,0xffffe
    8000460c:	e10080e7          	jalr	-496(ra) # 80002418 <sleep>
    if(log.committing){
    80004610:	50dc                	lw	a5,36(s1)
    80004612:	fbed                	bnez	a5,80004604 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004614:	5098                	lw	a4,32(s1)
    80004616:	2705                	addiw	a4,a4,1
    80004618:	0027179b          	slliw	a5,a4,0x2
    8000461c:	9fb9                	addw	a5,a5,a4
    8000461e:	0017979b          	slliw	a5,a5,0x1
    80004622:	54d4                	lw	a3,44(s1)
    80004624:	9fb5                	addw	a5,a5,a3
    80004626:	00f95963          	bge	s2,a5,80004638 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000462a:	85a6                	mv	a1,s1
    8000462c:	8526                	mv	a0,s1
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	dea080e7          	jalr	-534(ra) # 80002418 <sleep>
    80004636:	bfe9                	j	80004610 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004638:	0001f517          	auipc	a0,0x1f
    8000463c:	2b850513          	addi	a0,a0,696 # 800238f0 <log>
    80004640:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	6aa080e7          	jalr	1706(ra) # 80000cec <release>
      break;
    }
  }
}
    8000464a:	60e2                	ld	ra,24(sp)
    8000464c:	6442                	ld	s0,16(sp)
    8000464e:	64a2                	ld	s1,8(sp)
    80004650:	6902                	ld	s2,0(sp)
    80004652:	6105                	addi	sp,sp,32
    80004654:	8082                	ret

0000000080004656 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004656:	7139                	addi	sp,sp,-64
    80004658:	fc06                	sd	ra,56(sp)
    8000465a:	f822                	sd	s0,48(sp)
    8000465c:	f426                	sd	s1,40(sp)
    8000465e:	f04a                	sd	s2,32(sp)
    80004660:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004662:	0001f497          	auipc	s1,0x1f
    80004666:	28e48493          	addi	s1,s1,654 # 800238f0 <log>
    8000466a:	8526                	mv	a0,s1
    8000466c:	ffffc097          	auipc	ra,0xffffc
    80004670:	5cc080e7          	jalr	1484(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    80004674:	509c                	lw	a5,32(s1)
    80004676:	37fd                	addiw	a5,a5,-1
    80004678:	0007891b          	sext.w	s2,a5
    8000467c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000467e:	50dc                	lw	a5,36(s1)
    80004680:	e7b9                	bnez	a5,800046ce <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004682:	06091163          	bnez	s2,800046e4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004686:	0001f497          	auipc	s1,0x1f
    8000468a:	26a48493          	addi	s1,s1,618 # 800238f0 <log>
    8000468e:	4785                	li	a5,1
    80004690:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004692:	8526                	mv	a0,s1
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	658080e7          	jalr	1624(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000469c:	54dc                	lw	a5,44(s1)
    8000469e:	06f04763          	bgtz	a5,8000470c <end_op+0xb6>
    acquire(&log.lock);
    800046a2:	0001f497          	auipc	s1,0x1f
    800046a6:	24e48493          	addi	s1,s1,590 # 800238f0 <log>
    800046aa:	8526                	mv	a0,s1
    800046ac:	ffffc097          	auipc	ra,0xffffc
    800046b0:	58c080e7          	jalr	1420(ra) # 80000c38 <acquire>
    log.committing = 0;
    800046b4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046b8:	8526                	mv	a0,s1
    800046ba:	ffffe097          	auipc	ra,0xffffe
    800046be:	dc2080e7          	jalr	-574(ra) # 8000247c <wakeup>
    release(&log.lock);
    800046c2:	8526                	mv	a0,s1
    800046c4:	ffffc097          	auipc	ra,0xffffc
    800046c8:	628080e7          	jalr	1576(ra) # 80000cec <release>
}
    800046cc:	a815                	j	80004700 <end_op+0xaa>
    800046ce:	ec4e                	sd	s3,24(sp)
    800046d0:	e852                	sd	s4,16(sp)
    800046d2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800046d4:	00004517          	auipc	a0,0x4
    800046d8:	f2c50513          	addi	a0,a0,-212 # 80008600 <etext+0x600>
    800046dc:	ffffc097          	auipc	ra,0xffffc
    800046e0:	e84080e7          	jalr	-380(ra) # 80000560 <panic>
    wakeup(&log);
    800046e4:	0001f497          	auipc	s1,0x1f
    800046e8:	20c48493          	addi	s1,s1,524 # 800238f0 <log>
    800046ec:	8526                	mv	a0,s1
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	d8e080e7          	jalr	-626(ra) # 8000247c <wakeup>
  release(&log.lock);
    800046f6:	8526                	mv	a0,s1
    800046f8:	ffffc097          	auipc	ra,0xffffc
    800046fc:	5f4080e7          	jalr	1524(ra) # 80000cec <release>
}
    80004700:	70e2                	ld	ra,56(sp)
    80004702:	7442                	ld	s0,48(sp)
    80004704:	74a2                	ld	s1,40(sp)
    80004706:	7902                	ld	s2,32(sp)
    80004708:	6121                	addi	sp,sp,64
    8000470a:	8082                	ret
    8000470c:	ec4e                	sd	s3,24(sp)
    8000470e:	e852                	sd	s4,16(sp)
    80004710:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004712:	0001fa97          	auipc	s5,0x1f
    80004716:	20ea8a93          	addi	s5,s5,526 # 80023920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000471a:	0001fa17          	auipc	s4,0x1f
    8000471e:	1d6a0a13          	addi	s4,s4,470 # 800238f0 <log>
    80004722:	018a2583          	lw	a1,24(s4)
    80004726:	012585bb          	addw	a1,a1,s2
    8000472a:	2585                	addiw	a1,a1,1
    8000472c:	028a2503          	lw	a0,40(s4)
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	caa080e7          	jalr	-854(ra) # 800033da <bread>
    80004738:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000473a:	000aa583          	lw	a1,0(s5)
    8000473e:	028a2503          	lw	a0,40(s4)
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	c98080e7          	jalr	-872(ra) # 800033da <bread>
    8000474a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000474c:	40000613          	li	a2,1024
    80004750:	05850593          	addi	a1,a0,88
    80004754:	05848513          	addi	a0,s1,88
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	638080e7          	jalr	1592(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    80004760:	8526                	mv	a0,s1
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	d6a080e7          	jalr	-662(ra) # 800034cc <bwrite>
    brelse(from);
    8000476a:	854e                	mv	a0,s3
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	d9e080e7          	jalr	-610(ra) # 8000350a <brelse>
    brelse(to);
    80004774:	8526                	mv	a0,s1
    80004776:	fffff097          	auipc	ra,0xfffff
    8000477a:	d94080e7          	jalr	-620(ra) # 8000350a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000477e:	2905                	addiw	s2,s2,1
    80004780:	0a91                	addi	s5,s5,4
    80004782:	02ca2783          	lw	a5,44(s4)
    80004786:	f8f94ee3          	blt	s2,a5,80004722 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	c8c080e7          	jalr	-884(ra) # 80004416 <write_head>
    install_trans(0); // Now install writes to home locations
    80004792:	4501                	li	a0,0
    80004794:	00000097          	auipc	ra,0x0
    80004798:	cec080e7          	jalr	-788(ra) # 80004480 <install_trans>
    log.lh.n = 0;
    8000479c:	0001f797          	auipc	a5,0x1f
    800047a0:	1807a023          	sw	zero,384(a5) # 8002391c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800047a4:	00000097          	auipc	ra,0x0
    800047a8:	c72080e7          	jalr	-910(ra) # 80004416 <write_head>
    800047ac:	69e2                	ld	s3,24(sp)
    800047ae:	6a42                	ld	s4,16(sp)
    800047b0:	6aa2                	ld	s5,8(sp)
    800047b2:	bdc5                	j	800046a2 <end_op+0x4c>

00000000800047b4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800047b4:	1101                	addi	sp,sp,-32
    800047b6:	ec06                	sd	ra,24(sp)
    800047b8:	e822                	sd	s0,16(sp)
    800047ba:	e426                	sd	s1,8(sp)
    800047bc:	e04a                	sd	s2,0(sp)
    800047be:	1000                	addi	s0,sp,32
    800047c0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800047c2:	0001f917          	auipc	s2,0x1f
    800047c6:	12e90913          	addi	s2,s2,302 # 800238f0 <log>
    800047ca:	854a                	mv	a0,s2
    800047cc:	ffffc097          	auipc	ra,0xffffc
    800047d0:	46c080e7          	jalr	1132(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800047d4:	02c92603          	lw	a2,44(s2)
    800047d8:	47f5                	li	a5,29
    800047da:	06c7c563          	blt	a5,a2,80004844 <log_write+0x90>
    800047de:	0001f797          	auipc	a5,0x1f
    800047e2:	12e7a783          	lw	a5,302(a5) # 8002390c <log+0x1c>
    800047e6:	37fd                	addiw	a5,a5,-1
    800047e8:	04f65e63          	bge	a2,a5,80004844 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800047ec:	0001f797          	auipc	a5,0x1f
    800047f0:	1247a783          	lw	a5,292(a5) # 80023910 <log+0x20>
    800047f4:	06f05063          	blez	a5,80004854 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047f8:	4781                	li	a5,0
    800047fa:	06c05563          	blez	a2,80004864 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047fe:	44cc                	lw	a1,12(s1)
    80004800:	0001f717          	auipc	a4,0x1f
    80004804:	12070713          	addi	a4,a4,288 # 80023920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004808:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000480a:	4314                	lw	a3,0(a4)
    8000480c:	04b68c63          	beq	a3,a1,80004864 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004810:	2785                	addiw	a5,a5,1
    80004812:	0711                	addi	a4,a4,4
    80004814:	fef61be3          	bne	a2,a5,8000480a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004818:	0621                	addi	a2,a2,8
    8000481a:	060a                	slli	a2,a2,0x2
    8000481c:	0001f797          	auipc	a5,0x1f
    80004820:	0d478793          	addi	a5,a5,212 # 800238f0 <log>
    80004824:	97b2                	add	a5,a5,a2
    80004826:	44d8                	lw	a4,12(s1)
    80004828:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000482a:	8526                	mv	a0,s1
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	d7a080e7          	jalr	-646(ra) # 800035a6 <bpin>
    log.lh.n++;
    80004834:	0001f717          	auipc	a4,0x1f
    80004838:	0bc70713          	addi	a4,a4,188 # 800238f0 <log>
    8000483c:	575c                	lw	a5,44(a4)
    8000483e:	2785                	addiw	a5,a5,1
    80004840:	d75c                	sw	a5,44(a4)
    80004842:	a82d                	j	8000487c <log_write+0xc8>
    panic("too big a transaction");
    80004844:	00004517          	auipc	a0,0x4
    80004848:	dcc50513          	addi	a0,a0,-564 # 80008610 <etext+0x610>
    8000484c:	ffffc097          	auipc	ra,0xffffc
    80004850:	d14080e7          	jalr	-748(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004854:	00004517          	auipc	a0,0x4
    80004858:	dd450513          	addi	a0,a0,-556 # 80008628 <etext+0x628>
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	d04080e7          	jalr	-764(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004864:	00878693          	addi	a3,a5,8
    80004868:	068a                	slli	a3,a3,0x2
    8000486a:	0001f717          	auipc	a4,0x1f
    8000486e:	08670713          	addi	a4,a4,134 # 800238f0 <log>
    80004872:	9736                	add	a4,a4,a3
    80004874:	44d4                	lw	a3,12(s1)
    80004876:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004878:	faf609e3          	beq	a2,a5,8000482a <log_write+0x76>
  }
  release(&log.lock);
    8000487c:	0001f517          	auipc	a0,0x1f
    80004880:	07450513          	addi	a0,a0,116 # 800238f0 <log>
    80004884:	ffffc097          	auipc	ra,0xffffc
    80004888:	468080e7          	jalr	1128(ra) # 80000cec <release>
}
    8000488c:	60e2                	ld	ra,24(sp)
    8000488e:	6442                	ld	s0,16(sp)
    80004890:	64a2                	ld	s1,8(sp)
    80004892:	6902                	ld	s2,0(sp)
    80004894:	6105                	addi	sp,sp,32
    80004896:	8082                	ret

0000000080004898 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004898:	1101                	addi	sp,sp,-32
    8000489a:	ec06                	sd	ra,24(sp)
    8000489c:	e822                	sd	s0,16(sp)
    8000489e:	e426                	sd	s1,8(sp)
    800048a0:	e04a                	sd	s2,0(sp)
    800048a2:	1000                	addi	s0,sp,32
    800048a4:	84aa                	mv	s1,a0
    800048a6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048a8:	00004597          	auipc	a1,0x4
    800048ac:	da058593          	addi	a1,a1,-608 # 80008648 <etext+0x648>
    800048b0:	0521                	addi	a0,a0,8
    800048b2:	ffffc097          	auipc	ra,0xffffc
    800048b6:	2f6080e7          	jalr	758(ra) # 80000ba8 <initlock>
  lk->name = name;
    800048ba:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048c2:	0204a423          	sw	zero,40(s1)
}
    800048c6:	60e2                	ld	ra,24(sp)
    800048c8:	6442                	ld	s0,16(sp)
    800048ca:	64a2                	ld	s1,8(sp)
    800048cc:	6902                	ld	s2,0(sp)
    800048ce:	6105                	addi	sp,sp,32
    800048d0:	8082                	ret

00000000800048d2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800048d2:	1101                	addi	sp,sp,-32
    800048d4:	ec06                	sd	ra,24(sp)
    800048d6:	e822                	sd	s0,16(sp)
    800048d8:	e426                	sd	s1,8(sp)
    800048da:	e04a                	sd	s2,0(sp)
    800048dc:	1000                	addi	s0,sp,32
    800048de:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048e0:	00850913          	addi	s2,a0,8
    800048e4:	854a                	mv	a0,s2
    800048e6:	ffffc097          	auipc	ra,0xffffc
    800048ea:	352080e7          	jalr	850(ra) # 80000c38 <acquire>
  while (lk->locked) {
    800048ee:	409c                	lw	a5,0(s1)
    800048f0:	cb89                	beqz	a5,80004902 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800048f2:	85ca                	mv	a1,s2
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	b22080e7          	jalr	-1246(ra) # 80002418 <sleep>
  while (lk->locked) {
    800048fe:	409c                	lw	a5,0(s1)
    80004900:	fbed                	bnez	a5,800048f2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004902:	4785                	li	a5,1
    80004904:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004906:	ffffd097          	auipc	ra,0xffffd
    8000490a:	33a080e7          	jalr	826(ra) # 80001c40 <myproc>
    8000490e:	591c                	lw	a5,48(a0)
    80004910:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004912:	854a                	mv	a0,s2
    80004914:	ffffc097          	auipc	ra,0xffffc
    80004918:	3d8080e7          	jalr	984(ra) # 80000cec <release>
}
    8000491c:	60e2                	ld	ra,24(sp)
    8000491e:	6442                	ld	s0,16(sp)
    80004920:	64a2                	ld	s1,8(sp)
    80004922:	6902                	ld	s2,0(sp)
    80004924:	6105                	addi	sp,sp,32
    80004926:	8082                	ret

0000000080004928 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004928:	1101                	addi	sp,sp,-32
    8000492a:	ec06                	sd	ra,24(sp)
    8000492c:	e822                	sd	s0,16(sp)
    8000492e:	e426                	sd	s1,8(sp)
    80004930:	e04a                	sd	s2,0(sp)
    80004932:	1000                	addi	s0,sp,32
    80004934:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004936:	00850913          	addi	s2,a0,8
    8000493a:	854a                	mv	a0,s2
    8000493c:	ffffc097          	auipc	ra,0xffffc
    80004940:	2fc080e7          	jalr	764(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004944:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004948:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	b2e080e7          	jalr	-1234(ra) # 8000247c <wakeup>
  release(&lk->lk);
    80004956:	854a                	mv	a0,s2
    80004958:	ffffc097          	auipc	ra,0xffffc
    8000495c:	394080e7          	jalr	916(ra) # 80000cec <release>
}
    80004960:	60e2                	ld	ra,24(sp)
    80004962:	6442                	ld	s0,16(sp)
    80004964:	64a2                	ld	s1,8(sp)
    80004966:	6902                	ld	s2,0(sp)
    80004968:	6105                	addi	sp,sp,32
    8000496a:	8082                	ret

000000008000496c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000496c:	7179                	addi	sp,sp,-48
    8000496e:	f406                	sd	ra,40(sp)
    80004970:	f022                	sd	s0,32(sp)
    80004972:	ec26                	sd	s1,24(sp)
    80004974:	e84a                	sd	s2,16(sp)
    80004976:	1800                	addi	s0,sp,48
    80004978:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000497a:	00850913          	addi	s2,a0,8
    8000497e:	854a                	mv	a0,s2
    80004980:	ffffc097          	auipc	ra,0xffffc
    80004984:	2b8080e7          	jalr	696(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004988:	409c                	lw	a5,0(s1)
    8000498a:	ef91                	bnez	a5,800049a6 <holdingsleep+0x3a>
    8000498c:	4481                	li	s1,0
  release(&lk->lk);
    8000498e:	854a                	mv	a0,s2
    80004990:	ffffc097          	auipc	ra,0xffffc
    80004994:	35c080e7          	jalr	860(ra) # 80000cec <release>
  return r;
}
    80004998:	8526                	mv	a0,s1
    8000499a:	70a2                	ld	ra,40(sp)
    8000499c:	7402                	ld	s0,32(sp)
    8000499e:	64e2                	ld	s1,24(sp)
    800049a0:	6942                	ld	s2,16(sp)
    800049a2:	6145                	addi	sp,sp,48
    800049a4:	8082                	ret
    800049a6:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800049a8:	0284a983          	lw	s3,40(s1)
    800049ac:	ffffd097          	auipc	ra,0xffffd
    800049b0:	294080e7          	jalr	660(ra) # 80001c40 <myproc>
    800049b4:	5904                	lw	s1,48(a0)
    800049b6:	413484b3          	sub	s1,s1,s3
    800049ba:	0014b493          	seqz	s1,s1
    800049be:	69a2                	ld	s3,8(sp)
    800049c0:	b7f9                	j	8000498e <holdingsleep+0x22>

00000000800049c2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049c2:	1141                	addi	sp,sp,-16
    800049c4:	e406                	sd	ra,8(sp)
    800049c6:	e022                	sd	s0,0(sp)
    800049c8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800049ca:	00004597          	auipc	a1,0x4
    800049ce:	c8e58593          	addi	a1,a1,-882 # 80008658 <etext+0x658>
    800049d2:	0001f517          	auipc	a0,0x1f
    800049d6:	06650513          	addi	a0,a0,102 # 80023a38 <ftable>
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	1ce080e7          	jalr	462(ra) # 80000ba8 <initlock>
}
    800049e2:	60a2                	ld	ra,8(sp)
    800049e4:	6402                	ld	s0,0(sp)
    800049e6:	0141                	addi	sp,sp,16
    800049e8:	8082                	ret

00000000800049ea <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800049ea:	1101                	addi	sp,sp,-32
    800049ec:	ec06                	sd	ra,24(sp)
    800049ee:	e822                	sd	s0,16(sp)
    800049f0:	e426                	sd	s1,8(sp)
    800049f2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049f4:	0001f517          	auipc	a0,0x1f
    800049f8:	04450513          	addi	a0,a0,68 # 80023a38 <ftable>
    800049fc:	ffffc097          	auipc	ra,0xffffc
    80004a00:	23c080e7          	jalr	572(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a04:	0001f497          	auipc	s1,0x1f
    80004a08:	04c48493          	addi	s1,s1,76 # 80023a50 <ftable+0x18>
    80004a0c:	00020717          	auipc	a4,0x20
    80004a10:	fe470713          	addi	a4,a4,-28 # 800249f0 <disk>
    if(f->ref == 0){
    80004a14:	40dc                	lw	a5,4(s1)
    80004a16:	cf99                	beqz	a5,80004a34 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a18:	02848493          	addi	s1,s1,40
    80004a1c:	fee49ce3          	bne	s1,a4,80004a14 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a20:	0001f517          	auipc	a0,0x1f
    80004a24:	01850513          	addi	a0,a0,24 # 80023a38 <ftable>
    80004a28:	ffffc097          	auipc	ra,0xffffc
    80004a2c:	2c4080e7          	jalr	708(ra) # 80000cec <release>
  return 0;
    80004a30:	4481                	li	s1,0
    80004a32:	a819                	j	80004a48 <filealloc+0x5e>
      f->ref = 1;
    80004a34:	4785                	li	a5,1
    80004a36:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a38:	0001f517          	auipc	a0,0x1f
    80004a3c:	00050513          	mv	a0,a0
    80004a40:	ffffc097          	auipc	ra,0xffffc
    80004a44:	2ac080e7          	jalr	684(ra) # 80000cec <release>
}
    80004a48:	8526                	mv	a0,s1
    80004a4a:	60e2                	ld	ra,24(sp)
    80004a4c:	6442                	ld	s0,16(sp)
    80004a4e:	64a2                	ld	s1,8(sp)
    80004a50:	6105                	addi	sp,sp,32
    80004a52:	8082                	ret

0000000080004a54 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a54:	1101                	addi	sp,sp,-32
    80004a56:	ec06                	sd	ra,24(sp)
    80004a58:	e822                	sd	s0,16(sp)
    80004a5a:	e426                	sd	s1,8(sp)
    80004a5c:	1000                	addi	s0,sp,32
    80004a5e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a60:	0001f517          	auipc	a0,0x1f
    80004a64:	fd850513          	addi	a0,a0,-40 # 80023a38 <ftable>
    80004a68:	ffffc097          	auipc	ra,0xffffc
    80004a6c:	1d0080e7          	jalr	464(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004a70:	40dc                	lw	a5,4(s1)
    80004a72:	02f05263          	blez	a5,80004a96 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a76:	2785                	addiw	a5,a5,1
    80004a78:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a7a:	0001f517          	auipc	a0,0x1f
    80004a7e:	fbe50513          	addi	a0,a0,-66 # 80023a38 <ftable>
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	26a080e7          	jalr	618(ra) # 80000cec <release>
  return f;
}
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	60e2                	ld	ra,24(sp)
    80004a8e:	6442                	ld	s0,16(sp)
    80004a90:	64a2                	ld	s1,8(sp)
    80004a92:	6105                	addi	sp,sp,32
    80004a94:	8082                	ret
    panic("filedup");
    80004a96:	00004517          	auipc	a0,0x4
    80004a9a:	bca50513          	addi	a0,a0,-1078 # 80008660 <etext+0x660>
    80004a9e:	ffffc097          	auipc	ra,0xffffc
    80004aa2:	ac2080e7          	jalr	-1342(ra) # 80000560 <panic>

0000000080004aa6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004aa6:	7139                	addi	sp,sp,-64
    80004aa8:	fc06                	sd	ra,56(sp)
    80004aaa:	f822                	sd	s0,48(sp)
    80004aac:	f426                	sd	s1,40(sp)
    80004aae:	0080                	addi	s0,sp,64
    80004ab0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ab2:	0001f517          	auipc	a0,0x1f
    80004ab6:	f8650513          	addi	a0,a0,-122 # 80023a38 <ftable>
    80004aba:	ffffc097          	auipc	ra,0xffffc
    80004abe:	17e080e7          	jalr	382(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004ac2:	40dc                	lw	a5,4(s1)
    80004ac4:	04f05c63          	blez	a5,80004b1c <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004ac8:	37fd                	addiw	a5,a5,-1
    80004aca:	0007871b          	sext.w	a4,a5
    80004ace:	c0dc                	sw	a5,4(s1)
    80004ad0:	06e04263          	bgtz	a4,80004b34 <fileclose+0x8e>
    80004ad4:	f04a                	sd	s2,32(sp)
    80004ad6:	ec4e                	sd	s3,24(sp)
    80004ad8:	e852                	sd	s4,16(sp)
    80004ada:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004adc:	0004a903          	lw	s2,0(s1)
    80004ae0:	0094ca83          	lbu	s5,9(s1)
    80004ae4:	0104ba03          	ld	s4,16(s1)
    80004ae8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004aec:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004af0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004af4:	0001f517          	auipc	a0,0x1f
    80004af8:	f4450513          	addi	a0,a0,-188 # 80023a38 <ftable>
    80004afc:	ffffc097          	auipc	ra,0xffffc
    80004b00:	1f0080e7          	jalr	496(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004b04:	4785                	li	a5,1
    80004b06:	04f90463          	beq	s2,a5,80004b4e <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b0a:	3979                	addiw	s2,s2,-2
    80004b0c:	4785                	li	a5,1
    80004b0e:	0527fb63          	bgeu	a5,s2,80004b64 <fileclose+0xbe>
    80004b12:	7902                	ld	s2,32(sp)
    80004b14:	69e2                	ld	s3,24(sp)
    80004b16:	6a42                	ld	s4,16(sp)
    80004b18:	6aa2                	ld	s5,8(sp)
    80004b1a:	a02d                	j	80004b44 <fileclose+0x9e>
    80004b1c:	f04a                	sd	s2,32(sp)
    80004b1e:	ec4e                	sd	s3,24(sp)
    80004b20:	e852                	sd	s4,16(sp)
    80004b22:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004b24:	00004517          	auipc	a0,0x4
    80004b28:	b4450513          	addi	a0,a0,-1212 # 80008668 <etext+0x668>
    80004b2c:	ffffc097          	auipc	ra,0xffffc
    80004b30:	a34080e7          	jalr	-1484(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004b34:	0001f517          	auipc	a0,0x1f
    80004b38:	f0450513          	addi	a0,a0,-252 # 80023a38 <ftable>
    80004b3c:	ffffc097          	auipc	ra,0xffffc
    80004b40:	1b0080e7          	jalr	432(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004b44:	70e2                	ld	ra,56(sp)
    80004b46:	7442                	ld	s0,48(sp)
    80004b48:	74a2                	ld	s1,40(sp)
    80004b4a:	6121                	addi	sp,sp,64
    80004b4c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b4e:	85d6                	mv	a1,s5
    80004b50:	8552                	mv	a0,s4
    80004b52:	00000097          	auipc	ra,0x0
    80004b56:	3a2080e7          	jalr	930(ra) # 80004ef4 <pipeclose>
    80004b5a:	7902                	ld	s2,32(sp)
    80004b5c:	69e2                	ld	s3,24(sp)
    80004b5e:	6a42                	ld	s4,16(sp)
    80004b60:	6aa2                	ld	s5,8(sp)
    80004b62:	b7cd                	j	80004b44 <fileclose+0x9e>
    begin_op();
    80004b64:	00000097          	auipc	ra,0x0
    80004b68:	a78080e7          	jalr	-1416(ra) # 800045dc <begin_op>
    iput(ff.ip);
    80004b6c:	854e                	mv	a0,s3
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	25e080e7          	jalr	606(ra) # 80003dcc <iput>
    end_op();
    80004b76:	00000097          	auipc	ra,0x0
    80004b7a:	ae0080e7          	jalr	-1312(ra) # 80004656 <end_op>
    80004b7e:	7902                	ld	s2,32(sp)
    80004b80:	69e2                	ld	s3,24(sp)
    80004b82:	6a42                	ld	s4,16(sp)
    80004b84:	6aa2                	ld	s5,8(sp)
    80004b86:	bf7d                	j	80004b44 <fileclose+0x9e>

0000000080004b88 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b88:	715d                	addi	sp,sp,-80
    80004b8a:	e486                	sd	ra,72(sp)
    80004b8c:	e0a2                	sd	s0,64(sp)
    80004b8e:	fc26                	sd	s1,56(sp)
    80004b90:	f44e                	sd	s3,40(sp)
    80004b92:	0880                	addi	s0,sp,80
    80004b94:	84aa                	mv	s1,a0
    80004b96:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b98:	ffffd097          	auipc	ra,0xffffd
    80004b9c:	0a8080e7          	jalr	168(ra) # 80001c40 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ba0:	409c                	lw	a5,0(s1)
    80004ba2:	37f9                	addiw	a5,a5,-2
    80004ba4:	4705                	li	a4,1
    80004ba6:	04f76863          	bltu	a4,a5,80004bf6 <filestat+0x6e>
    80004baa:	f84a                	sd	s2,48(sp)
    80004bac:	892a                	mv	s2,a0
    ilock(f->ip);
    80004bae:	6c88                	ld	a0,24(s1)
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	05e080e7          	jalr	94(ra) # 80003c0e <ilock>
    stati(f->ip, &st);
    80004bb8:	fb840593          	addi	a1,s0,-72
    80004bbc:	6c88                	ld	a0,24(s1)
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	2de080e7          	jalr	734(ra) # 80003e9c <stati>
    iunlock(f->ip);
    80004bc6:	6c88                	ld	a0,24(s1)
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	10c080e7          	jalr	268(ra) # 80003cd4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004bd0:	46e1                	li	a3,24
    80004bd2:	fb840613          	addi	a2,s0,-72
    80004bd6:	85ce                	mv	a1,s3
    80004bd8:	05093503          	ld	a0,80(s2)
    80004bdc:	ffffd097          	auipc	ra,0xffffd
    80004be0:	b06080e7          	jalr	-1274(ra) # 800016e2 <copyout>
    80004be4:	41f5551b          	sraiw	a0,a0,0x1f
    80004be8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004bea:	60a6                	ld	ra,72(sp)
    80004bec:	6406                	ld	s0,64(sp)
    80004bee:	74e2                	ld	s1,56(sp)
    80004bf0:	79a2                	ld	s3,40(sp)
    80004bf2:	6161                	addi	sp,sp,80
    80004bf4:	8082                	ret
  return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	bfcd                	j	80004bea <filestat+0x62>

0000000080004bfa <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004bfa:	7179                	addi	sp,sp,-48
    80004bfc:	f406                	sd	ra,40(sp)
    80004bfe:	f022                	sd	s0,32(sp)
    80004c00:	e84a                	sd	s2,16(sp)
    80004c02:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c04:	00854783          	lbu	a5,8(a0)
    80004c08:	cbc5                	beqz	a5,80004cb8 <fileread+0xbe>
    80004c0a:	ec26                	sd	s1,24(sp)
    80004c0c:	e44e                	sd	s3,8(sp)
    80004c0e:	84aa                	mv	s1,a0
    80004c10:	89ae                	mv	s3,a1
    80004c12:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c14:	411c                	lw	a5,0(a0)
    80004c16:	4705                	li	a4,1
    80004c18:	04e78963          	beq	a5,a4,80004c6a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c1c:	470d                	li	a4,3
    80004c1e:	04e78f63          	beq	a5,a4,80004c7c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c22:	4709                	li	a4,2
    80004c24:	08e79263          	bne	a5,a4,80004ca8 <fileread+0xae>
    ilock(f->ip);
    80004c28:	6d08                	ld	a0,24(a0)
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	fe4080e7          	jalr	-28(ra) # 80003c0e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c32:	874a                	mv	a4,s2
    80004c34:	5094                	lw	a3,32(s1)
    80004c36:	864e                	mv	a2,s3
    80004c38:	4585                	li	a1,1
    80004c3a:	6c88                	ld	a0,24(s1)
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	28a080e7          	jalr	650(ra) # 80003ec6 <readi>
    80004c44:	892a                	mv	s2,a0
    80004c46:	00a05563          	blez	a0,80004c50 <fileread+0x56>
      f->off += r;
    80004c4a:	509c                	lw	a5,32(s1)
    80004c4c:	9fa9                	addw	a5,a5,a0
    80004c4e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c50:	6c88                	ld	a0,24(s1)
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	082080e7          	jalr	130(ra) # 80003cd4 <iunlock>
    80004c5a:	64e2                	ld	s1,24(sp)
    80004c5c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004c5e:	854a                	mv	a0,s2
    80004c60:	70a2                	ld	ra,40(sp)
    80004c62:	7402                	ld	s0,32(sp)
    80004c64:	6942                	ld	s2,16(sp)
    80004c66:	6145                	addi	sp,sp,48
    80004c68:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c6a:	6908                	ld	a0,16(a0)
    80004c6c:	00000097          	auipc	ra,0x0
    80004c70:	400080e7          	jalr	1024(ra) # 8000506c <piperead>
    80004c74:	892a                	mv	s2,a0
    80004c76:	64e2                	ld	s1,24(sp)
    80004c78:	69a2                	ld	s3,8(sp)
    80004c7a:	b7d5                	j	80004c5e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c7c:	02451783          	lh	a5,36(a0)
    80004c80:	03079693          	slli	a3,a5,0x30
    80004c84:	92c1                	srli	a3,a3,0x30
    80004c86:	4725                	li	a4,9
    80004c88:	02d76a63          	bltu	a4,a3,80004cbc <fileread+0xc2>
    80004c8c:	0792                	slli	a5,a5,0x4
    80004c8e:	0001f717          	auipc	a4,0x1f
    80004c92:	d0a70713          	addi	a4,a4,-758 # 80023998 <devsw>
    80004c96:	97ba                	add	a5,a5,a4
    80004c98:	639c                	ld	a5,0(a5)
    80004c9a:	c78d                	beqz	a5,80004cc4 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004c9c:	4505                	li	a0,1
    80004c9e:	9782                	jalr	a5
    80004ca0:	892a                	mv	s2,a0
    80004ca2:	64e2                	ld	s1,24(sp)
    80004ca4:	69a2                	ld	s3,8(sp)
    80004ca6:	bf65                	j	80004c5e <fileread+0x64>
    panic("fileread");
    80004ca8:	00004517          	auipc	a0,0x4
    80004cac:	9d050513          	addi	a0,a0,-1584 # 80008678 <etext+0x678>
    80004cb0:	ffffc097          	auipc	ra,0xffffc
    80004cb4:	8b0080e7          	jalr	-1872(ra) # 80000560 <panic>
    return -1;
    80004cb8:	597d                	li	s2,-1
    80004cba:	b755                	j	80004c5e <fileread+0x64>
      return -1;
    80004cbc:	597d                	li	s2,-1
    80004cbe:	64e2                	ld	s1,24(sp)
    80004cc0:	69a2                	ld	s3,8(sp)
    80004cc2:	bf71                	j	80004c5e <fileread+0x64>
    80004cc4:	597d                	li	s2,-1
    80004cc6:	64e2                	ld	s1,24(sp)
    80004cc8:	69a2                	ld	s3,8(sp)
    80004cca:	bf51                	j	80004c5e <fileread+0x64>

0000000080004ccc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004ccc:	00954783          	lbu	a5,9(a0)
    80004cd0:	12078963          	beqz	a5,80004e02 <filewrite+0x136>
{
    80004cd4:	715d                	addi	sp,sp,-80
    80004cd6:	e486                	sd	ra,72(sp)
    80004cd8:	e0a2                	sd	s0,64(sp)
    80004cda:	f84a                	sd	s2,48(sp)
    80004cdc:	f052                	sd	s4,32(sp)
    80004cde:	e85a                	sd	s6,16(sp)
    80004ce0:	0880                	addi	s0,sp,80
    80004ce2:	892a                	mv	s2,a0
    80004ce4:	8b2e                	mv	s6,a1
    80004ce6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ce8:	411c                	lw	a5,0(a0)
    80004cea:	4705                	li	a4,1
    80004cec:	02e78763          	beq	a5,a4,80004d1a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cf0:	470d                	li	a4,3
    80004cf2:	02e78a63          	beq	a5,a4,80004d26 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cf6:	4709                	li	a4,2
    80004cf8:	0ee79863          	bne	a5,a4,80004de8 <filewrite+0x11c>
    80004cfc:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004cfe:	0cc05463          	blez	a2,80004dc6 <filewrite+0xfa>
    80004d02:	fc26                	sd	s1,56(sp)
    80004d04:	ec56                	sd	s5,24(sp)
    80004d06:	e45e                	sd	s7,8(sp)
    80004d08:	e062                	sd	s8,0(sp)
    int i = 0;
    80004d0a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004d0c:	6b85                	lui	s7,0x1
    80004d0e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004d12:	6c05                	lui	s8,0x1
    80004d14:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004d18:	a851                	j	80004dac <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004d1a:	6908                	ld	a0,16(a0)
    80004d1c:	00000097          	auipc	ra,0x0
    80004d20:	248080e7          	jalr	584(ra) # 80004f64 <pipewrite>
    80004d24:	a85d                	j	80004dda <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d26:	02451783          	lh	a5,36(a0)
    80004d2a:	03079693          	slli	a3,a5,0x30
    80004d2e:	92c1                	srli	a3,a3,0x30
    80004d30:	4725                	li	a4,9
    80004d32:	0cd76a63          	bltu	a4,a3,80004e06 <filewrite+0x13a>
    80004d36:	0792                	slli	a5,a5,0x4
    80004d38:	0001f717          	auipc	a4,0x1f
    80004d3c:	c6070713          	addi	a4,a4,-928 # 80023998 <devsw>
    80004d40:	97ba                	add	a5,a5,a4
    80004d42:	679c                	ld	a5,8(a5)
    80004d44:	c3f9                	beqz	a5,80004e0a <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004d46:	4505                	li	a0,1
    80004d48:	9782                	jalr	a5
    80004d4a:	a841                	j	80004dda <filewrite+0x10e>
      if(n1 > max)
    80004d4c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004d50:	00000097          	auipc	ra,0x0
    80004d54:	88c080e7          	jalr	-1908(ra) # 800045dc <begin_op>
      ilock(f->ip);
    80004d58:	01893503          	ld	a0,24(s2)
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	eb2080e7          	jalr	-334(ra) # 80003c0e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d64:	8756                	mv	a4,s5
    80004d66:	02092683          	lw	a3,32(s2)
    80004d6a:	01698633          	add	a2,s3,s6
    80004d6e:	4585                	li	a1,1
    80004d70:	01893503          	ld	a0,24(s2)
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	262080e7          	jalr	610(ra) # 80003fd6 <writei>
    80004d7c:	84aa                	mv	s1,a0
    80004d7e:	00a05763          	blez	a0,80004d8c <filewrite+0xc0>
        f->off += r;
    80004d82:	02092783          	lw	a5,32(s2)
    80004d86:	9fa9                	addw	a5,a5,a0
    80004d88:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d8c:	01893503          	ld	a0,24(s2)
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	f44080e7          	jalr	-188(ra) # 80003cd4 <iunlock>
      end_op();
    80004d98:	00000097          	auipc	ra,0x0
    80004d9c:	8be080e7          	jalr	-1858(ra) # 80004656 <end_op>

      if(r != n1){
    80004da0:	029a9563          	bne	s5,s1,80004dca <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004da4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004da8:	0149da63          	bge	s3,s4,80004dbc <filewrite+0xf0>
      int n1 = n - i;
    80004dac:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004db0:	0004879b          	sext.w	a5,s1
    80004db4:	f8fbdce3          	bge	s7,a5,80004d4c <filewrite+0x80>
    80004db8:	84e2                	mv	s1,s8
    80004dba:	bf49                	j	80004d4c <filewrite+0x80>
    80004dbc:	74e2                	ld	s1,56(sp)
    80004dbe:	6ae2                	ld	s5,24(sp)
    80004dc0:	6ba2                	ld	s7,8(sp)
    80004dc2:	6c02                	ld	s8,0(sp)
    80004dc4:	a039                	j	80004dd2 <filewrite+0x106>
    int i = 0;
    80004dc6:	4981                	li	s3,0
    80004dc8:	a029                	j	80004dd2 <filewrite+0x106>
    80004dca:	74e2                	ld	s1,56(sp)
    80004dcc:	6ae2                	ld	s5,24(sp)
    80004dce:	6ba2                	ld	s7,8(sp)
    80004dd0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004dd2:	033a1e63          	bne	s4,s3,80004e0e <filewrite+0x142>
    80004dd6:	8552                	mv	a0,s4
    80004dd8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004dda:	60a6                	ld	ra,72(sp)
    80004ddc:	6406                	ld	s0,64(sp)
    80004dde:	7942                	ld	s2,48(sp)
    80004de0:	7a02                	ld	s4,32(sp)
    80004de2:	6b42                	ld	s6,16(sp)
    80004de4:	6161                	addi	sp,sp,80
    80004de6:	8082                	ret
    80004de8:	fc26                	sd	s1,56(sp)
    80004dea:	f44e                	sd	s3,40(sp)
    80004dec:	ec56                	sd	s5,24(sp)
    80004dee:	e45e                	sd	s7,8(sp)
    80004df0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004df2:	00004517          	auipc	a0,0x4
    80004df6:	89650513          	addi	a0,a0,-1898 # 80008688 <etext+0x688>
    80004dfa:	ffffb097          	auipc	ra,0xffffb
    80004dfe:	766080e7          	jalr	1894(ra) # 80000560 <panic>
    return -1;
    80004e02:	557d                	li	a0,-1
}
    80004e04:	8082                	ret
      return -1;
    80004e06:	557d                	li	a0,-1
    80004e08:	bfc9                	j	80004dda <filewrite+0x10e>
    80004e0a:	557d                	li	a0,-1
    80004e0c:	b7f9                	j	80004dda <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004e0e:	557d                	li	a0,-1
    80004e10:	79a2                	ld	s3,40(sp)
    80004e12:	b7e1                	j	80004dda <filewrite+0x10e>

0000000080004e14 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e14:	7179                	addi	sp,sp,-48
    80004e16:	f406                	sd	ra,40(sp)
    80004e18:	f022                	sd	s0,32(sp)
    80004e1a:	ec26                	sd	s1,24(sp)
    80004e1c:	e052                	sd	s4,0(sp)
    80004e1e:	1800                	addi	s0,sp,48
    80004e20:	84aa                	mv	s1,a0
    80004e22:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e24:	0005b023          	sd	zero,0(a1)
    80004e28:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e2c:	00000097          	auipc	ra,0x0
    80004e30:	bbe080e7          	jalr	-1090(ra) # 800049ea <filealloc>
    80004e34:	e088                	sd	a0,0(s1)
    80004e36:	cd49                	beqz	a0,80004ed0 <pipealloc+0xbc>
    80004e38:	00000097          	auipc	ra,0x0
    80004e3c:	bb2080e7          	jalr	-1102(ra) # 800049ea <filealloc>
    80004e40:	00aa3023          	sd	a0,0(s4)
    80004e44:	c141                	beqz	a0,80004ec4 <pipealloc+0xb0>
    80004e46:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e48:	ffffc097          	auipc	ra,0xffffc
    80004e4c:	d00080e7          	jalr	-768(ra) # 80000b48 <kalloc>
    80004e50:	892a                	mv	s2,a0
    80004e52:	c13d                	beqz	a0,80004eb8 <pipealloc+0xa4>
    80004e54:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004e56:	4985                	li	s3,1
    80004e58:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e5c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e60:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e64:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e68:	00004597          	auipc	a1,0x4
    80004e6c:	83058593          	addi	a1,a1,-2000 # 80008698 <etext+0x698>
    80004e70:	ffffc097          	auipc	ra,0xffffc
    80004e74:	d38080e7          	jalr	-712(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004e78:	609c                	ld	a5,0(s1)
    80004e7a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e7e:	609c                	ld	a5,0(s1)
    80004e80:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e84:	609c                	ld	a5,0(s1)
    80004e86:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e8a:	609c                	ld	a5,0(s1)
    80004e8c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e90:	000a3783          	ld	a5,0(s4)
    80004e94:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e98:	000a3783          	ld	a5,0(s4)
    80004e9c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ea0:	000a3783          	ld	a5,0(s4)
    80004ea4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ea8:	000a3783          	ld	a5,0(s4)
    80004eac:	0127b823          	sd	s2,16(a5)
  return 0;
    80004eb0:	4501                	li	a0,0
    80004eb2:	6942                	ld	s2,16(sp)
    80004eb4:	69a2                	ld	s3,8(sp)
    80004eb6:	a03d                	j	80004ee4 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004eb8:	6088                	ld	a0,0(s1)
    80004eba:	c119                	beqz	a0,80004ec0 <pipealloc+0xac>
    80004ebc:	6942                	ld	s2,16(sp)
    80004ebe:	a029                	j	80004ec8 <pipealloc+0xb4>
    80004ec0:	6942                	ld	s2,16(sp)
    80004ec2:	a039                	j	80004ed0 <pipealloc+0xbc>
    80004ec4:	6088                	ld	a0,0(s1)
    80004ec6:	c50d                	beqz	a0,80004ef0 <pipealloc+0xdc>
    fileclose(*f0);
    80004ec8:	00000097          	auipc	ra,0x0
    80004ecc:	bde080e7          	jalr	-1058(ra) # 80004aa6 <fileclose>
  if(*f1)
    80004ed0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ed4:	557d                	li	a0,-1
  if(*f1)
    80004ed6:	c799                	beqz	a5,80004ee4 <pipealloc+0xd0>
    fileclose(*f1);
    80004ed8:	853e                	mv	a0,a5
    80004eda:	00000097          	auipc	ra,0x0
    80004ede:	bcc080e7          	jalr	-1076(ra) # 80004aa6 <fileclose>
  return -1;
    80004ee2:	557d                	li	a0,-1
}
    80004ee4:	70a2                	ld	ra,40(sp)
    80004ee6:	7402                	ld	s0,32(sp)
    80004ee8:	64e2                	ld	s1,24(sp)
    80004eea:	6a02                	ld	s4,0(sp)
    80004eec:	6145                	addi	sp,sp,48
    80004eee:	8082                	ret
  return -1;
    80004ef0:	557d                	li	a0,-1
    80004ef2:	bfcd                	j	80004ee4 <pipealloc+0xd0>

0000000080004ef4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ef4:	1101                	addi	sp,sp,-32
    80004ef6:	ec06                	sd	ra,24(sp)
    80004ef8:	e822                	sd	s0,16(sp)
    80004efa:	e426                	sd	s1,8(sp)
    80004efc:	e04a                	sd	s2,0(sp)
    80004efe:	1000                	addi	s0,sp,32
    80004f00:	84aa                	mv	s1,a0
    80004f02:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f04:	ffffc097          	auipc	ra,0xffffc
    80004f08:	d34080e7          	jalr	-716(ra) # 80000c38 <acquire>
  if(writable){
    80004f0c:	02090d63          	beqz	s2,80004f46 <pipeclose+0x52>
    pi->writeopen = 0;
    80004f10:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f14:	21848513          	addi	a0,s1,536
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	564080e7          	jalr	1380(ra) # 8000247c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f20:	2204b783          	ld	a5,544(s1)
    80004f24:	eb95                	bnez	a5,80004f58 <pipeclose+0x64>
    release(&pi->lock);
    80004f26:	8526                	mv	a0,s1
    80004f28:	ffffc097          	auipc	ra,0xffffc
    80004f2c:	dc4080e7          	jalr	-572(ra) # 80000cec <release>
    kfree((char*)pi);
    80004f30:	8526                	mv	a0,s1
    80004f32:	ffffc097          	auipc	ra,0xffffc
    80004f36:	b18080e7          	jalr	-1256(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80004f3a:	60e2                	ld	ra,24(sp)
    80004f3c:	6442                	ld	s0,16(sp)
    80004f3e:	64a2                	ld	s1,8(sp)
    80004f40:	6902                	ld	s2,0(sp)
    80004f42:	6105                	addi	sp,sp,32
    80004f44:	8082                	ret
    pi->readopen = 0;
    80004f46:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f4a:	21c48513          	addi	a0,s1,540
    80004f4e:	ffffd097          	auipc	ra,0xffffd
    80004f52:	52e080e7          	jalr	1326(ra) # 8000247c <wakeup>
    80004f56:	b7e9                	j	80004f20 <pipeclose+0x2c>
    release(&pi->lock);
    80004f58:	8526                	mv	a0,s1
    80004f5a:	ffffc097          	auipc	ra,0xffffc
    80004f5e:	d92080e7          	jalr	-622(ra) # 80000cec <release>
}
    80004f62:	bfe1                	j	80004f3a <pipeclose+0x46>

0000000080004f64 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f64:	711d                	addi	sp,sp,-96
    80004f66:	ec86                	sd	ra,88(sp)
    80004f68:	e8a2                	sd	s0,80(sp)
    80004f6a:	e4a6                	sd	s1,72(sp)
    80004f6c:	e0ca                	sd	s2,64(sp)
    80004f6e:	fc4e                	sd	s3,56(sp)
    80004f70:	f852                	sd	s4,48(sp)
    80004f72:	f456                	sd	s5,40(sp)
    80004f74:	1080                	addi	s0,sp,96
    80004f76:	84aa                	mv	s1,a0
    80004f78:	8aae                	mv	s5,a1
    80004f7a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f7c:	ffffd097          	auipc	ra,0xffffd
    80004f80:	cc4080e7          	jalr	-828(ra) # 80001c40 <myproc>
    80004f84:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f86:	8526                	mv	a0,s1
    80004f88:	ffffc097          	auipc	ra,0xffffc
    80004f8c:	cb0080e7          	jalr	-848(ra) # 80000c38 <acquire>
  while(i < n){
    80004f90:	0d405863          	blez	s4,80005060 <pipewrite+0xfc>
    80004f94:	f05a                	sd	s6,32(sp)
    80004f96:	ec5e                	sd	s7,24(sp)
    80004f98:	e862                	sd	s8,16(sp)
  int i = 0;
    80004f9a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004f9c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f9e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004fa2:	21c48b93          	addi	s7,s1,540
    80004fa6:	a089                	j	80004fe8 <pipewrite+0x84>
      release(&pi->lock);
    80004fa8:	8526                	mv	a0,s1
    80004faa:	ffffc097          	auipc	ra,0xffffc
    80004fae:	d42080e7          	jalr	-702(ra) # 80000cec <release>
      return -1;
    80004fb2:	597d                	li	s2,-1
    80004fb4:	7b02                	ld	s6,32(sp)
    80004fb6:	6be2                	ld	s7,24(sp)
    80004fb8:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004fba:	854a                	mv	a0,s2
    80004fbc:	60e6                	ld	ra,88(sp)
    80004fbe:	6446                	ld	s0,80(sp)
    80004fc0:	64a6                	ld	s1,72(sp)
    80004fc2:	6906                	ld	s2,64(sp)
    80004fc4:	79e2                	ld	s3,56(sp)
    80004fc6:	7a42                	ld	s4,48(sp)
    80004fc8:	7aa2                	ld	s5,40(sp)
    80004fca:	6125                	addi	sp,sp,96
    80004fcc:	8082                	ret
      wakeup(&pi->nread);
    80004fce:	8562                	mv	a0,s8
    80004fd0:	ffffd097          	auipc	ra,0xffffd
    80004fd4:	4ac080e7          	jalr	1196(ra) # 8000247c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004fd8:	85a6                	mv	a1,s1
    80004fda:	855e                	mv	a0,s7
    80004fdc:	ffffd097          	auipc	ra,0xffffd
    80004fe0:	43c080e7          	jalr	1084(ra) # 80002418 <sleep>
  while(i < n){
    80004fe4:	05495f63          	bge	s2,s4,80005042 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004fe8:	2204a783          	lw	a5,544(s1)
    80004fec:	dfd5                	beqz	a5,80004fa8 <pipewrite+0x44>
    80004fee:	854e                	mv	a0,s3
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	6d0080e7          	jalr	1744(ra) # 800026c0 <killed>
    80004ff8:	f945                	bnez	a0,80004fa8 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ffa:	2184a783          	lw	a5,536(s1)
    80004ffe:	21c4a703          	lw	a4,540(s1)
    80005002:	2007879b          	addiw	a5,a5,512
    80005006:	fcf704e3          	beq	a4,a5,80004fce <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000500a:	4685                	li	a3,1
    8000500c:	01590633          	add	a2,s2,s5
    80005010:	faf40593          	addi	a1,s0,-81
    80005014:	0509b503          	ld	a0,80(s3)
    80005018:	ffffc097          	auipc	ra,0xffffc
    8000501c:	756080e7          	jalr	1878(ra) # 8000176e <copyin>
    80005020:	05650263          	beq	a0,s6,80005064 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005024:	21c4a783          	lw	a5,540(s1)
    80005028:	0017871b          	addiw	a4,a5,1
    8000502c:	20e4ae23          	sw	a4,540(s1)
    80005030:	1ff7f793          	andi	a5,a5,511
    80005034:	97a6                	add	a5,a5,s1
    80005036:	faf44703          	lbu	a4,-81(s0)
    8000503a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000503e:	2905                	addiw	s2,s2,1
    80005040:	b755                	j	80004fe4 <pipewrite+0x80>
    80005042:	7b02                	ld	s6,32(sp)
    80005044:	6be2                	ld	s7,24(sp)
    80005046:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005048:	21848513          	addi	a0,s1,536
    8000504c:	ffffd097          	auipc	ra,0xffffd
    80005050:	430080e7          	jalr	1072(ra) # 8000247c <wakeup>
  release(&pi->lock);
    80005054:	8526                	mv	a0,s1
    80005056:	ffffc097          	auipc	ra,0xffffc
    8000505a:	c96080e7          	jalr	-874(ra) # 80000cec <release>
  return i;
    8000505e:	bfb1                	j	80004fba <pipewrite+0x56>
  int i = 0;
    80005060:	4901                	li	s2,0
    80005062:	b7dd                	j	80005048 <pipewrite+0xe4>
    80005064:	7b02                	ld	s6,32(sp)
    80005066:	6be2                	ld	s7,24(sp)
    80005068:	6c42                	ld	s8,16(sp)
    8000506a:	bff9                	j	80005048 <pipewrite+0xe4>

000000008000506c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000506c:	715d                	addi	sp,sp,-80
    8000506e:	e486                	sd	ra,72(sp)
    80005070:	e0a2                	sd	s0,64(sp)
    80005072:	fc26                	sd	s1,56(sp)
    80005074:	f84a                	sd	s2,48(sp)
    80005076:	f44e                	sd	s3,40(sp)
    80005078:	f052                	sd	s4,32(sp)
    8000507a:	ec56                	sd	s5,24(sp)
    8000507c:	0880                	addi	s0,sp,80
    8000507e:	84aa                	mv	s1,a0
    80005080:	892e                	mv	s2,a1
    80005082:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	bbc080e7          	jalr	-1092(ra) # 80001c40 <myproc>
    8000508c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000508e:	8526                	mv	a0,s1
    80005090:	ffffc097          	auipc	ra,0xffffc
    80005094:	ba8080e7          	jalr	-1112(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005098:	2184a703          	lw	a4,536(s1)
    8000509c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050a0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050a4:	02f71963          	bne	a4,a5,800050d6 <piperead+0x6a>
    800050a8:	2244a783          	lw	a5,548(s1)
    800050ac:	cf95                	beqz	a5,800050e8 <piperead+0x7c>
    if(killed(pr)){
    800050ae:	8552                	mv	a0,s4
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	610080e7          	jalr	1552(ra) # 800026c0 <killed>
    800050b8:	e10d                	bnez	a0,800050da <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050ba:	85a6                	mv	a1,s1
    800050bc:	854e                	mv	a0,s3
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	35a080e7          	jalr	858(ra) # 80002418 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050c6:	2184a703          	lw	a4,536(s1)
    800050ca:	21c4a783          	lw	a5,540(s1)
    800050ce:	fcf70de3          	beq	a4,a5,800050a8 <piperead+0x3c>
    800050d2:	e85a                	sd	s6,16(sp)
    800050d4:	a819                	j	800050ea <piperead+0x7e>
    800050d6:	e85a                	sd	s6,16(sp)
    800050d8:	a809                	j	800050ea <piperead+0x7e>
      release(&pi->lock);
    800050da:	8526                	mv	a0,s1
    800050dc:	ffffc097          	auipc	ra,0xffffc
    800050e0:	c10080e7          	jalr	-1008(ra) # 80000cec <release>
      return -1;
    800050e4:	59fd                	li	s3,-1
    800050e6:	a0a5                	j	8000514e <piperead+0xe2>
    800050e8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050ec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050ee:	05505463          	blez	s5,80005136 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800050f2:	2184a783          	lw	a5,536(s1)
    800050f6:	21c4a703          	lw	a4,540(s1)
    800050fa:	02f70e63          	beq	a4,a5,80005136 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800050fe:	0017871b          	addiw	a4,a5,1
    80005102:	20e4ac23          	sw	a4,536(s1)
    80005106:	1ff7f793          	andi	a5,a5,511
    8000510a:	97a6                	add	a5,a5,s1
    8000510c:	0187c783          	lbu	a5,24(a5)
    80005110:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005114:	4685                	li	a3,1
    80005116:	fbf40613          	addi	a2,s0,-65
    8000511a:	85ca                	mv	a1,s2
    8000511c:	050a3503          	ld	a0,80(s4)
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	5c2080e7          	jalr	1474(ra) # 800016e2 <copyout>
    80005128:	01650763          	beq	a0,s6,80005136 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000512c:	2985                	addiw	s3,s3,1
    8000512e:	0905                	addi	s2,s2,1
    80005130:	fd3a91e3          	bne	s5,s3,800050f2 <piperead+0x86>
    80005134:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005136:	21c48513          	addi	a0,s1,540
    8000513a:	ffffd097          	auipc	ra,0xffffd
    8000513e:	342080e7          	jalr	834(ra) # 8000247c <wakeup>
  release(&pi->lock);
    80005142:	8526                	mv	a0,s1
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	ba8080e7          	jalr	-1112(ra) # 80000cec <release>
    8000514c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000514e:	854e                	mv	a0,s3
    80005150:	60a6                	ld	ra,72(sp)
    80005152:	6406                	ld	s0,64(sp)
    80005154:	74e2                	ld	s1,56(sp)
    80005156:	7942                	ld	s2,48(sp)
    80005158:	79a2                	ld	s3,40(sp)
    8000515a:	7a02                	ld	s4,32(sp)
    8000515c:	6ae2                	ld	s5,24(sp)
    8000515e:	6161                	addi	sp,sp,80
    80005160:	8082                	ret

0000000080005162 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005162:	1141                	addi	sp,sp,-16
    80005164:	e422                	sd	s0,8(sp)
    80005166:	0800                	addi	s0,sp,16
    80005168:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000516a:	8905                	andi	a0,a0,1
    8000516c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000516e:	8b89                	andi	a5,a5,2
    80005170:	c399                	beqz	a5,80005176 <flags2perm+0x14>
      perm |= PTE_W;
    80005172:	00456513          	ori	a0,a0,4
    return perm;
}
    80005176:	6422                	ld	s0,8(sp)
    80005178:	0141                	addi	sp,sp,16
    8000517a:	8082                	ret

000000008000517c <exec>:

int
exec(char *path, char **argv)
{
    8000517c:	df010113          	addi	sp,sp,-528
    80005180:	20113423          	sd	ra,520(sp)
    80005184:	20813023          	sd	s0,512(sp)
    80005188:	ffa6                	sd	s1,504(sp)
    8000518a:	fbca                	sd	s2,496(sp)
    8000518c:	0c00                	addi	s0,sp,528
    8000518e:	892a                	mv	s2,a0
    80005190:	dea43c23          	sd	a0,-520(s0)
    80005194:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005198:	ffffd097          	auipc	ra,0xffffd
    8000519c:	aa8080e7          	jalr	-1368(ra) # 80001c40 <myproc>
    800051a0:	84aa                	mv	s1,a0

  begin_op();
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	43a080e7          	jalr	1082(ra) # 800045dc <begin_op>

  if((ip = namei(path)) == 0){
    800051aa:	854a                	mv	a0,s2
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	230080e7          	jalr	560(ra) # 800043dc <namei>
    800051b4:	c135                	beqz	a0,80005218 <exec+0x9c>
    800051b6:	f3d2                	sd	s4,480(sp)
    800051b8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	a54080e7          	jalr	-1452(ra) # 80003c0e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800051c2:	04000713          	li	a4,64
    800051c6:	4681                	li	a3,0
    800051c8:	e5040613          	addi	a2,s0,-432
    800051cc:	4581                	li	a1,0
    800051ce:	8552                	mv	a0,s4
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	cf6080e7          	jalr	-778(ra) # 80003ec6 <readi>
    800051d8:	04000793          	li	a5,64
    800051dc:	00f51a63          	bne	a0,a5,800051f0 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800051e0:	e5042703          	lw	a4,-432(s0)
    800051e4:	464c47b7          	lui	a5,0x464c4
    800051e8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800051ec:	02f70c63          	beq	a4,a5,80005224 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800051f0:	8552                	mv	a0,s4
    800051f2:	fffff097          	auipc	ra,0xfffff
    800051f6:	c82080e7          	jalr	-894(ra) # 80003e74 <iunlockput>
    end_op();
    800051fa:	fffff097          	auipc	ra,0xfffff
    800051fe:	45c080e7          	jalr	1116(ra) # 80004656 <end_op>
  }
  return -1;
    80005202:	557d                	li	a0,-1
    80005204:	7a1e                	ld	s4,480(sp)
}
    80005206:	20813083          	ld	ra,520(sp)
    8000520a:	20013403          	ld	s0,512(sp)
    8000520e:	74fe                	ld	s1,504(sp)
    80005210:	795e                	ld	s2,496(sp)
    80005212:	21010113          	addi	sp,sp,528
    80005216:	8082                	ret
    end_op();
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	43e080e7          	jalr	1086(ra) # 80004656 <end_op>
    return -1;
    80005220:	557d                	li	a0,-1
    80005222:	b7d5                	j	80005206 <exec+0x8a>
    80005224:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005226:	8526                	mv	a0,s1
    80005228:	ffffd097          	auipc	ra,0xffffd
    8000522c:	adc080e7          	jalr	-1316(ra) # 80001d04 <proc_pagetable>
    80005230:	8b2a                	mv	s6,a0
    80005232:	30050f63          	beqz	a0,80005550 <exec+0x3d4>
    80005236:	f7ce                	sd	s3,488(sp)
    80005238:	efd6                	sd	s5,472(sp)
    8000523a:	e7de                	sd	s7,456(sp)
    8000523c:	e3e2                	sd	s8,448(sp)
    8000523e:	ff66                	sd	s9,440(sp)
    80005240:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005242:	e7042d03          	lw	s10,-400(s0)
    80005246:	e8845783          	lhu	a5,-376(s0)
    8000524a:	14078d63          	beqz	a5,800053a4 <exec+0x228>
    8000524e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005250:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005252:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005254:	6c85                	lui	s9,0x1
    80005256:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000525a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000525e:	6a85                	lui	s5,0x1
    80005260:	a0b5                	j	800052cc <exec+0x150>
      panic("loadseg: address should exist");
    80005262:	00003517          	auipc	a0,0x3
    80005266:	43e50513          	addi	a0,a0,1086 # 800086a0 <etext+0x6a0>
    8000526a:	ffffb097          	auipc	ra,0xffffb
    8000526e:	2f6080e7          	jalr	758(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005272:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005274:	8726                	mv	a4,s1
    80005276:	012c06bb          	addw	a3,s8,s2
    8000527a:	4581                	li	a1,0
    8000527c:	8552                	mv	a0,s4
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	c48080e7          	jalr	-952(ra) # 80003ec6 <readi>
    80005286:	2501                	sext.w	a0,a0
    80005288:	28a49863          	bne	s1,a0,80005518 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000528c:	012a893b          	addw	s2,s5,s2
    80005290:	03397563          	bgeu	s2,s3,800052ba <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005294:	02091593          	slli	a1,s2,0x20
    80005298:	9181                	srli	a1,a1,0x20
    8000529a:	95de                	add	a1,a1,s7
    8000529c:	855a                	mv	a0,s6
    8000529e:	ffffc097          	auipc	ra,0xffffc
    800052a2:	e18080e7          	jalr	-488(ra) # 800010b6 <walkaddr>
    800052a6:	862a                	mv	a2,a0
    if(pa == 0)
    800052a8:	dd4d                	beqz	a0,80005262 <exec+0xe6>
    if(sz - i < PGSIZE)
    800052aa:	412984bb          	subw	s1,s3,s2
    800052ae:	0004879b          	sext.w	a5,s1
    800052b2:	fcfcf0e3          	bgeu	s9,a5,80005272 <exec+0xf6>
    800052b6:	84d6                	mv	s1,s5
    800052b8:	bf6d                	j	80005272 <exec+0xf6>
    sz = sz1;
    800052ba:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052be:	2d85                	addiw	s11,s11,1
    800052c0:	038d0d1b          	addiw	s10,s10,56
    800052c4:	e8845783          	lhu	a5,-376(s0)
    800052c8:	08fdd663          	bge	s11,a5,80005354 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800052cc:	2d01                	sext.w	s10,s10
    800052ce:	03800713          	li	a4,56
    800052d2:	86ea                	mv	a3,s10
    800052d4:	e1840613          	addi	a2,s0,-488
    800052d8:	4581                	li	a1,0
    800052da:	8552                	mv	a0,s4
    800052dc:	fffff097          	auipc	ra,0xfffff
    800052e0:	bea080e7          	jalr	-1046(ra) # 80003ec6 <readi>
    800052e4:	03800793          	li	a5,56
    800052e8:	20f51063          	bne	a0,a5,800054e8 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800052ec:	e1842783          	lw	a5,-488(s0)
    800052f0:	4705                	li	a4,1
    800052f2:	fce796e3          	bne	a5,a4,800052be <exec+0x142>
    if(ph.memsz < ph.filesz)
    800052f6:	e4043483          	ld	s1,-448(s0)
    800052fa:	e3843783          	ld	a5,-456(s0)
    800052fe:	1ef4e963          	bltu	s1,a5,800054f0 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005302:	e2843783          	ld	a5,-472(s0)
    80005306:	94be                	add	s1,s1,a5
    80005308:	1ef4e863          	bltu	s1,a5,800054f8 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    8000530c:	df043703          	ld	a4,-528(s0)
    80005310:	8ff9                	and	a5,a5,a4
    80005312:	1e079763          	bnez	a5,80005500 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005316:	e1c42503          	lw	a0,-484(s0)
    8000531a:	00000097          	auipc	ra,0x0
    8000531e:	e48080e7          	jalr	-440(ra) # 80005162 <flags2perm>
    80005322:	86aa                	mv	a3,a0
    80005324:	8626                	mv	a2,s1
    80005326:	85ca                	mv	a1,s2
    80005328:	855a                	mv	a0,s6
    8000532a:	ffffc097          	auipc	ra,0xffffc
    8000532e:	150080e7          	jalr	336(ra) # 8000147a <uvmalloc>
    80005332:	e0a43423          	sd	a0,-504(s0)
    80005336:	1c050963          	beqz	a0,80005508 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000533a:	e2843b83          	ld	s7,-472(s0)
    8000533e:	e2042c03          	lw	s8,-480(s0)
    80005342:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005346:	00098463          	beqz	s3,8000534e <exec+0x1d2>
    8000534a:	4901                	li	s2,0
    8000534c:	b7a1                	j	80005294 <exec+0x118>
    sz = sz1;
    8000534e:	e0843903          	ld	s2,-504(s0)
    80005352:	b7b5                	j	800052be <exec+0x142>
    80005354:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005356:	8552                	mv	a0,s4
    80005358:	fffff097          	auipc	ra,0xfffff
    8000535c:	b1c080e7          	jalr	-1252(ra) # 80003e74 <iunlockput>
  end_op();
    80005360:	fffff097          	auipc	ra,0xfffff
    80005364:	2f6080e7          	jalr	758(ra) # 80004656 <end_op>
  p = myproc();
    80005368:	ffffd097          	auipc	ra,0xffffd
    8000536c:	8d8080e7          	jalr	-1832(ra) # 80001c40 <myproc>
    80005370:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005372:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80005376:	6985                	lui	s3,0x1
    80005378:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000537a:	99ca                	add	s3,s3,s2
    8000537c:	77fd                	lui	a5,0xfffff
    8000537e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005382:	4691                	li	a3,4
    80005384:	6609                	lui	a2,0x2
    80005386:	964e                	add	a2,a2,s3
    80005388:	85ce                	mv	a1,s3
    8000538a:	855a                	mv	a0,s6
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	0ee080e7          	jalr	238(ra) # 8000147a <uvmalloc>
    80005394:	892a                	mv	s2,a0
    80005396:	e0a43423          	sd	a0,-504(s0)
    8000539a:	e519                	bnez	a0,800053a8 <exec+0x22c>
  if(pagetable)
    8000539c:	e1343423          	sd	s3,-504(s0)
    800053a0:	4a01                	li	s4,0
    800053a2:	aaa5                	j	8000551a <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053a4:	4901                	li	s2,0
    800053a6:	bf45                	j	80005356 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800053a8:	75f9                	lui	a1,0xffffe
    800053aa:	95aa                	add	a1,a1,a0
    800053ac:	855a                	mv	a0,s6
    800053ae:	ffffc097          	auipc	ra,0xffffc
    800053b2:	302080e7          	jalr	770(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    800053b6:	7bfd                	lui	s7,0xfffff
    800053b8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800053ba:	e0043783          	ld	a5,-512(s0)
    800053be:	6388                	ld	a0,0(a5)
    800053c0:	c52d                	beqz	a0,8000542a <exec+0x2ae>
    800053c2:	e9040993          	addi	s3,s0,-368
    800053c6:	f9040c13          	addi	s8,s0,-112
    800053ca:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	adc080e7          	jalr	-1316(ra) # 80000ea8 <strlen>
    800053d4:	0015079b          	addiw	a5,a0,1
    800053d8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800053dc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800053e0:	13796863          	bltu	s2,s7,80005510 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800053e4:	e0043d03          	ld	s10,-512(s0)
    800053e8:	000d3a03          	ld	s4,0(s10)
    800053ec:	8552                	mv	a0,s4
    800053ee:	ffffc097          	auipc	ra,0xffffc
    800053f2:	aba080e7          	jalr	-1350(ra) # 80000ea8 <strlen>
    800053f6:	0015069b          	addiw	a3,a0,1
    800053fa:	8652                	mv	a2,s4
    800053fc:	85ca                	mv	a1,s2
    800053fe:	855a                	mv	a0,s6
    80005400:	ffffc097          	auipc	ra,0xffffc
    80005404:	2e2080e7          	jalr	738(ra) # 800016e2 <copyout>
    80005408:	10054663          	bltz	a0,80005514 <exec+0x398>
    ustack[argc] = sp;
    8000540c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005410:	0485                	addi	s1,s1,1
    80005412:	008d0793          	addi	a5,s10,8
    80005416:	e0f43023          	sd	a5,-512(s0)
    8000541a:	008d3503          	ld	a0,8(s10)
    8000541e:	c909                	beqz	a0,80005430 <exec+0x2b4>
    if(argc >= MAXARG)
    80005420:	09a1                	addi	s3,s3,8
    80005422:	fb8995e3          	bne	s3,s8,800053cc <exec+0x250>
  ip = 0;
    80005426:	4a01                	li	s4,0
    80005428:	a8cd                	j	8000551a <exec+0x39e>
  sp = sz;
    8000542a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000542e:	4481                	li	s1,0
  ustack[argc] = 0;
    80005430:	00349793          	slli	a5,s1,0x3
    80005434:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda460>
    80005438:	97a2                	add	a5,a5,s0
    8000543a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000543e:	00148693          	addi	a3,s1,1
    80005442:	068e                	slli	a3,a3,0x3
    80005444:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005448:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000544c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005450:	f57966e3          	bltu	s2,s7,8000539c <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005454:	e9040613          	addi	a2,s0,-368
    80005458:	85ca                	mv	a1,s2
    8000545a:	855a                	mv	a0,s6
    8000545c:	ffffc097          	auipc	ra,0xffffc
    80005460:	286080e7          	jalr	646(ra) # 800016e2 <copyout>
    80005464:	0e054863          	bltz	a0,80005554 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80005468:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000546c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005470:	df843783          	ld	a5,-520(s0)
    80005474:	0007c703          	lbu	a4,0(a5)
    80005478:	cf11                	beqz	a4,80005494 <exec+0x318>
    8000547a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000547c:	02f00693          	li	a3,47
    80005480:	a039                	j	8000548e <exec+0x312>
      last = s+1;
    80005482:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005486:	0785                	addi	a5,a5,1
    80005488:	fff7c703          	lbu	a4,-1(a5)
    8000548c:	c701                	beqz	a4,80005494 <exec+0x318>
    if(*s == '/')
    8000548e:	fed71ce3          	bne	a4,a3,80005486 <exec+0x30a>
    80005492:	bfc5                	j	80005482 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005494:	4641                	li	a2,16
    80005496:	df843583          	ld	a1,-520(s0)
    8000549a:	158a8513          	addi	a0,s5,344
    8000549e:	ffffc097          	auipc	ra,0xffffc
    800054a2:	9d8080e7          	jalr	-1576(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    800054a6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800054aa:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800054ae:	e0843783          	ld	a5,-504(s0)
    800054b2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800054b6:	058ab783          	ld	a5,88(s5)
    800054ba:	e6843703          	ld	a4,-408(s0)
    800054be:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800054c0:	058ab783          	ld	a5,88(s5)
    800054c4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800054c8:	85e6                	mv	a1,s9
    800054ca:	ffffd097          	auipc	ra,0xffffd
    800054ce:	8d6080e7          	jalr	-1834(ra) # 80001da0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800054d2:	0004851b          	sext.w	a0,s1
    800054d6:	79be                	ld	s3,488(sp)
    800054d8:	7a1e                	ld	s4,480(sp)
    800054da:	6afe                	ld	s5,472(sp)
    800054dc:	6b5e                	ld	s6,464(sp)
    800054de:	6bbe                	ld	s7,456(sp)
    800054e0:	6c1e                	ld	s8,448(sp)
    800054e2:	7cfa                	ld	s9,440(sp)
    800054e4:	7d5a                	ld	s10,432(sp)
    800054e6:	b305                	j	80005206 <exec+0x8a>
    800054e8:	e1243423          	sd	s2,-504(s0)
    800054ec:	7dba                	ld	s11,424(sp)
    800054ee:	a035                	j	8000551a <exec+0x39e>
    800054f0:	e1243423          	sd	s2,-504(s0)
    800054f4:	7dba                	ld	s11,424(sp)
    800054f6:	a015                	j	8000551a <exec+0x39e>
    800054f8:	e1243423          	sd	s2,-504(s0)
    800054fc:	7dba                	ld	s11,424(sp)
    800054fe:	a831                	j	8000551a <exec+0x39e>
    80005500:	e1243423          	sd	s2,-504(s0)
    80005504:	7dba                	ld	s11,424(sp)
    80005506:	a811                	j	8000551a <exec+0x39e>
    80005508:	e1243423          	sd	s2,-504(s0)
    8000550c:	7dba                	ld	s11,424(sp)
    8000550e:	a031                	j	8000551a <exec+0x39e>
  ip = 0;
    80005510:	4a01                	li	s4,0
    80005512:	a021                	j	8000551a <exec+0x39e>
    80005514:	4a01                	li	s4,0
  if(pagetable)
    80005516:	a011                	j	8000551a <exec+0x39e>
    80005518:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000551a:	e0843583          	ld	a1,-504(s0)
    8000551e:	855a                	mv	a0,s6
    80005520:	ffffd097          	auipc	ra,0xffffd
    80005524:	880080e7          	jalr	-1920(ra) # 80001da0 <proc_freepagetable>
  return -1;
    80005528:	557d                	li	a0,-1
  if(ip){
    8000552a:	000a1b63          	bnez	s4,80005540 <exec+0x3c4>
    8000552e:	79be                	ld	s3,488(sp)
    80005530:	7a1e                	ld	s4,480(sp)
    80005532:	6afe                	ld	s5,472(sp)
    80005534:	6b5e                	ld	s6,464(sp)
    80005536:	6bbe                	ld	s7,456(sp)
    80005538:	6c1e                	ld	s8,448(sp)
    8000553a:	7cfa                	ld	s9,440(sp)
    8000553c:	7d5a                	ld	s10,432(sp)
    8000553e:	b1e1                	j	80005206 <exec+0x8a>
    80005540:	79be                	ld	s3,488(sp)
    80005542:	6afe                	ld	s5,472(sp)
    80005544:	6b5e                	ld	s6,464(sp)
    80005546:	6bbe                	ld	s7,456(sp)
    80005548:	6c1e                	ld	s8,448(sp)
    8000554a:	7cfa                	ld	s9,440(sp)
    8000554c:	7d5a                	ld	s10,432(sp)
    8000554e:	b14d                	j	800051f0 <exec+0x74>
    80005550:	6b5e                	ld	s6,464(sp)
    80005552:	b979                	j	800051f0 <exec+0x74>
  sz = sz1;
    80005554:	e0843983          	ld	s3,-504(s0)
    80005558:	b591                	j	8000539c <exec+0x220>

000000008000555a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000555a:	7179                	addi	sp,sp,-48
    8000555c:	f406                	sd	ra,40(sp)
    8000555e:	f022                	sd	s0,32(sp)
    80005560:	ec26                	sd	s1,24(sp)
    80005562:	e84a                	sd	s2,16(sp)
    80005564:	1800                	addi	s0,sp,48
    80005566:	892e                	mv	s2,a1
    80005568:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000556a:	fdc40593          	addi	a1,s0,-36
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	a6a080e7          	jalr	-1430(ra) # 80002fd8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005576:	fdc42703          	lw	a4,-36(s0)
    8000557a:	47bd                	li	a5,15
    8000557c:	02e7eb63          	bltu	a5,a4,800055b2 <argfd+0x58>
    80005580:	ffffc097          	auipc	ra,0xffffc
    80005584:	6c0080e7          	jalr	1728(ra) # 80001c40 <myproc>
    80005588:	fdc42703          	lw	a4,-36(s0)
    8000558c:	01a70793          	addi	a5,a4,26
    80005590:	078e                	slli	a5,a5,0x3
    80005592:	953e                	add	a0,a0,a5
    80005594:	611c                	ld	a5,0(a0)
    80005596:	c385                	beqz	a5,800055b6 <argfd+0x5c>
    return -1;
  if(pfd)
    80005598:	00090463          	beqz	s2,800055a0 <argfd+0x46>
    *pfd = fd;
    8000559c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055a0:	4501                	li	a0,0
  if(pf)
    800055a2:	c091                	beqz	s1,800055a6 <argfd+0x4c>
    *pf = f;
    800055a4:	e09c                	sd	a5,0(s1)
}
    800055a6:	70a2                	ld	ra,40(sp)
    800055a8:	7402                	ld	s0,32(sp)
    800055aa:	64e2                	ld	s1,24(sp)
    800055ac:	6942                	ld	s2,16(sp)
    800055ae:	6145                	addi	sp,sp,48
    800055b0:	8082                	ret
    return -1;
    800055b2:	557d                	li	a0,-1
    800055b4:	bfcd                	j	800055a6 <argfd+0x4c>
    800055b6:	557d                	li	a0,-1
    800055b8:	b7fd                	j	800055a6 <argfd+0x4c>

00000000800055ba <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055ba:	1101                	addi	sp,sp,-32
    800055bc:	ec06                	sd	ra,24(sp)
    800055be:	e822                	sd	s0,16(sp)
    800055c0:	e426                	sd	s1,8(sp)
    800055c2:	1000                	addi	s0,sp,32
    800055c4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055c6:	ffffc097          	auipc	ra,0xffffc
    800055ca:	67a080e7          	jalr	1658(ra) # 80001c40 <myproc>
    800055ce:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800055d0:	0d050793          	addi	a5,a0,208
    800055d4:	4501                	li	a0,0
    800055d6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800055d8:	6398                	ld	a4,0(a5)
    800055da:	cb19                	beqz	a4,800055f0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800055dc:	2505                	addiw	a0,a0,1
    800055de:	07a1                	addi	a5,a5,8
    800055e0:	fed51ce3          	bne	a0,a3,800055d8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800055e4:	557d                	li	a0,-1
}
    800055e6:	60e2                	ld	ra,24(sp)
    800055e8:	6442                	ld	s0,16(sp)
    800055ea:	64a2                	ld	s1,8(sp)
    800055ec:	6105                	addi	sp,sp,32
    800055ee:	8082                	ret
      p->ofile[fd] = f;
    800055f0:	01a50793          	addi	a5,a0,26
    800055f4:	078e                	slli	a5,a5,0x3
    800055f6:	963e                	add	a2,a2,a5
    800055f8:	e204                	sd	s1,0(a2)
      return fd;
    800055fa:	b7f5                	j	800055e6 <fdalloc+0x2c>

00000000800055fc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800055fc:	715d                	addi	sp,sp,-80
    800055fe:	e486                	sd	ra,72(sp)
    80005600:	e0a2                	sd	s0,64(sp)
    80005602:	fc26                	sd	s1,56(sp)
    80005604:	f84a                	sd	s2,48(sp)
    80005606:	f44e                	sd	s3,40(sp)
    80005608:	ec56                	sd	s5,24(sp)
    8000560a:	e85a                	sd	s6,16(sp)
    8000560c:	0880                	addi	s0,sp,80
    8000560e:	8b2e                	mv	s6,a1
    80005610:	89b2                	mv	s3,a2
    80005612:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005614:	fb040593          	addi	a1,s0,-80
    80005618:	fffff097          	auipc	ra,0xfffff
    8000561c:	de2080e7          	jalr	-542(ra) # 800043fa <nameiparent>
    80005620:	84aa                	mv	s1,a0
    80005622:	14050e63          	beqz	a0,8000577e <create+0x182>
    return 0;

  ilock(dp);
    80005626:	ffffe097          	auipc	ra,0xffffe
    8000562a:	5e8080e7          	jalr	1512(ra) # 80003c0e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000562e:	4601                	li	a2,0
    80005630:	fb040593          	addi	a1,s0,-80
    80005634:	8526                	mv	a0,s1
    80005636:	fffff097          	auipc	ra,0xfffff
    8000563a:	ae4080e7          	jalr	-1308(ra) # 8000411a <dirlookup>
    8000563e:	8aaa                	mv	s5,a0
    80005640:	c539                	beqz	a0,8000568e <create+0x92>
    iunlockput(dp);
    80005642:	8526                	mv	a0,s1
    80005644:	fffff097          	auipc	ra,0xfffff
    80005648:	830080e7          	jalr	-2000(ra) # 80003e74 <iunlockput>
    ilock(ip);
    8000564c:	8556                	mv	a0,s5
    8000564e:	ffffe097          	auipc	ra,0xffffe
    80005652:	5c0080e7          	jalr	1472(ra) # 80003c0e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005656:	4789                	li	a5,2
    80005658:	02fb1463          	bne	s6,a5,80005680 <create+0x84>
    8000565c:	044ad783          	lhu	a5,68(s5)
    80005660:	37f9                	addiw	a5,a5,-2
    80005662:	17c2                	slli	a5,a5,0x30
    80005664:	93c1                	srli	a5,a5,0x30
    80005666:	4705                	li	a4,1
    80005668:	00f76c63          	bltu	a4,a5,80005680 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000566c:	8556                	mv	a0,s5
    8000566e:	60a6                	ld	ra,72(sp)
    80005670:	6406                	ld	s0,64(sp)
    80005672:	74e2                	ld	s1,56(sp)
    80005674:	7942                	ld	s2,48(sp)
    80005676:	79a2                	ld	s3,40(sp)
    80005678:	6ae2                	ld	s5,24(sp)
    8000567a:	6b42                	ld	s6,16(sp)
    8000567c:	6161                	addi	sp,sp,80
    8000567e:	8082                	ret
    iunlockput(ip);
    80005680:	8556                	mv	a0,s5
    80005682:	ffffe097          	auipc	ra,0xffffe
    80005686:	7f2080e7          	jalr	2034(ra) # 80003e74 <iunlockput>
    return 0;
    8000568a:	4a81                	li	s5,0
    8000568c:	b7c5                	j	8000566c <create+0x70>
    8000568e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005690:	85da                	mv	a1,s6
    80005692:	4088                	lw	a0,0(s1)
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	3d6080e7          	jalr	982(ra) # 80003a6a <ialloc>
    8000569c:	8a2a                	mv	s4,a0
    8000569e:	c531                	beqz	a0,800056ea <create+0xee>
  ilock(ip);
    800056a0:	ffffe097          	auipc	ra,0xffffe
    800056a4:	56e080e7          	jalr	1390(ra) # 80003c0e <ilock>
  ip->major = major;
    800056a8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800056ac:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800056b0:	4905                	li	s2,1
    800056b2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800056b6:	8552                	mv	a0,s4
    800056b8:	ffffe097          	auipc	ra,0xffffe
    800056bc:	48a080e7          	jalr	1162(ra) # 80003b42 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056c0:	032b0d63          	beq	s6,s2,800056fa <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800056c4:	004a2603          	lw	a2,4(s4)
    800056c8:	fb040593          	addi	a1,s0,-80
    800056cc:	8526                	mv	a0,s1
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	c5c080e7          	jalr	-932(ra) # 8000432a <dirlink>
    800056d6:	08054163          	bltz	a0,80005758 <create+0x15c>
  iunlockput(dp);
    800056da:	8526                	mv	a0,s1
    800056dc:	ffffe097          	auipc	ra,0xffffe
    800056e0:	798080e7          	jalr	1944(ra) # 80003e74 <iunlockput>
  return ip;
    800056e4:	8ad2                	mv	s5,s4
    800056e6:	7a02                	ld	s4,32(sp)
    800056e8:	b751                	j	8000566c <create+0x70>
    iunlockput(dp);
    800056ea:	8526                	mv	a0,s1
    800056ec:	ffffe097          	auipc	ra,0xffffe
    800056f0:	788080e7          	jalr	1928(ra) # 80003e74 <iunlockput>
    return 0;
    800056f4:	8ad2                	mv	s5,s4
    800056f6:	7a02                	ld	s4,32(sp)
    800056f8:	bf95                	j	8000566c <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056fa:	004a2603          	lw	a2,4(s4)
    800056fe:	00003597          	auipc	a1,0x3
    80005702:	fc258593          	addi	a1,a1,-62 # 800086c0 <etext+0x6c0>
    80005706:	8552                	mv	a0,s4
    80005708:	fffff097          	auipc	ra,0xfffff
    8000570c:	c22080e7          	jalr	-990(ra) # 8000432a <dirlink>
    80005710:	04054463          	bltz	a0,80005758 <create+0x15c>
    80005714:	40d0                	lw	a2,4(s1)
    80005716:	00003597          	auipc	a1,0x3
    8000571a:	fb258593          	addi	a1,a1,-78 # 800086c8 <etext+0x6c8>
    8000571e:	8552                	mv	a0,s4
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	c0a080e7          	jalr	-1014(ra) # 8000432a <dirlink>
    80005728:	02054863          	bltz	a0,80005758 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000572c:	004a2603          	lw	a2,4(s4)
    80005730:	fb040593          	addi	a1,s0,-80
    80005734:	8526                	mv	a0,s1
    80005736:	fffff097          	auipc	ra,0xfffff
    8000573a:	bf4080e7          	jalr	-1036(ra) # 8000432a <dirlink>
    8000573e:	00054d63          	bltz	a0,80005758 <create+0x15c>
    dp->nlink++;  // for ".."
    80005742:	04a4d783          	lhu	a5,74(s1)
    80005746:	2785                	addiw	a5,a5,1
    80005748:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000574c:	8526                	mv	a0,s1
    8000574e:	ffffe097          	auipc	ra,0xffffe
    80005752:	3f4080e7          	jalr	1012(ra) # 80003b42 <iupdate>
    80005756:	b751                	j	800056da <create+0xde>
  ip->nlink = 0;
    80005758:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000575c:	8552                	mv	a0,s4
    8000575e:	ffffe097          	auipc	ra,0xffffe
    80005762:	3e4080e7          	jalr	996(ra) # 80003b42 <iupdate>
  iunlockput(ip);
    80005766:	8552                	mv	a0,s4
    80005768:	ffffe097          	auipc	ra,0xffffe
    8000576c:	70c080e7          	jalr	1804(ra) # 80003e74 <iunlockput>
  iunlockput(dp);
    80005770:	8526                	mv	a0,s1
    80005772:	ffffe097          	auipc	ra,0xffffe
    80005776:	702080e7          	jalr	1794(ra) # 80003e74 <iunlockput>
  return 0;
    8000577a:	7a02                	ld	s4,32(sp)
    8000577c:	bdc5                	j	8000566c <create+0x70>
    return 0;
    8000577e:	8aaa                	mv	s5,a0
    80005780:	b5f5                	j	8000566c <create+0x70>

0000000080005782 <sys_dup>:
{
    80005782:	7179                	addi	sp,sp,-48
    80005784:	f406                	sd	ra,40(sp)
    80005786:	f022                	sd	s0,32(sp)
    80005788:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000578a:	fd840613          	addi	a2,s0,-40
    8000578e:	4581                	li	a1,0
    80005790:	4501                	li	a0,0
    80005792:	00000097          	auipc	ra,0x0
    80005796:	dc8080e7          	jalr	-568(ra) # 8000555a <argfd>
    return -1;
    8000579a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000579c:	02054763          	bltz	a0,800057ca <sys_dup+0x48>
    800057a0:	ec26                	sd	s1,24(sp)
    800057a2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800057a4:	fd843903          	ld	s2,-40(s0)
    800057a8:	854a                	mv	a0,s2
    800057aa:	00000097          	auipc	ra,0x0
    800057ae:	e10080e7          	jalr	-496(ra) # 800055ba <fdalloc>
    800057b2:	84aa                	mv	s1,a0
    return -1;
    800057b4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057b6:	00054f63          	bltz	a0,800057d4 <sys_dup+0x52>
  filedup(f);
    800057ba:	854a                	mv	a0,s2
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	298080e7          	jalr	664(ra) # 80004a54 <filedup>
  return fd;
    800057c4:	87a6                	mv	a5,s1
    800057c6:	64e2                	ld	s1,24(sp)
    800057c8:	6942                	ld	s2,16(sp)
}
    800057ca:	853e                	mv	a0,a5
    800057cc:	70a2                	ld	ra,40(sp)
    800057ce:	7402                	ld	s0,32(sp)
    800057d0:	6145                	addi	sp,sp,48
    800057d2:	8082                	ret
    800057d4:	64e2                	ld	s1,24(sp)
    800057d6:	6942                	ld	s2,16(sp)
    800057d8:	bfcd                	j	800057ca <sys_dup+0x48>

00000000800057da <sys_read>:
{
    800057da:	7179                	addi	sp,sp,-48
    800057dc:	f406                	sd	ra,40(sp)
    800057de:	f022                	sd	s0,32(sp)
    800057e0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057e2:	fd840593          	addi	a1,s0,-40
    800057e6:	4505                	li	a0,1
    800057e8:	ffffe097          	auipc	ra,0xffffe
    800057ec:	810080e7          	jalr	-2032(ra) # 80002ff8 <argaddr>
  argint(2, &n);
    800057f0:	fe440593          	addi	a1,s0,-28
    800057f4:	4509                	li	a0,2
    800057f6:	ffffd097          	auipc	ra,0xffffd
    800057fa:	7e2080e7          	jalr	2018(ra) # 80002fd8 <argint>
  if(argfd(0, 0, &f) < 0)
    800057fe:	fe840613          	addi	a2,s0,-24
    80005802:	4581                	li	a1,0
    80005804:	4501                	li	a0,0
    80005806:	00000097          	auipc	ra,0x0
    8000580a:	d54080e7          	jalr	-684(ra) # 8000555a <argfd>
    8000580e:	87aa                	mv	a5,a0
    return -1;
    80005810:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005812:	0007cc63          	bltz	a5,8000582a <sys_read+0x50>
  return fileread(f, p, n);
    80005816:	fe442603          	lw	a2,-28(s0)
    8000581a:	fd843583          	ld	a1,-40(s0)
    8000581e:	fe843503          	ld	a0,-24(s0)
    80005822:	fffff097          	auipc	ra,0xfffff
    80005826:	3d8080e7          	jalr	984(ra) # 80004bfa <fileread>
}
    8000582a:	70a2                	ld	ra,40(sp)
    8000582c:	7402                	ld	s0,32(sp)
    8000582e:	6145                	addi	sp,sp,48
    80005830:	8082                	ret

0000000080005832 <sys_write>:
{
    80005832:	7179                	addi	sp,sp,-48
    80005834:	f406                	sd	ra,40(sp)
    80005836:	f022                	sd	s0,32(sp)
    80005838:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000583a:	fd840593          	addi	a1,s0,-40
    8000583e:	4505                	li	a0,1
    80005840:	ffffd097          	auipc	ra,0xffffd
    80005844:	7b8080e7          	jalr	1976(ra) # 80002ff8 <argaddr>
  argint(2, &n);
    80005848:	fe440593          	addi	a1,s0,-28
    8000584c:	4509                	li	a0,2
    8000584e:	ffffd097          	auipc	ra,0xffffd
    80005852:	78a080e7          	jalr	1930(ra) # 80002fd8 <argint>
  if(argfd(0, 0, &f) < 0)
    80005856:	fe840613          	addi	a2,s0,-24
    8000585a:	4581                	li	a1,0
    8000585c:	4501                	li	a0,0
    8000585e:	00000097          	auipc	ra,0x0
    80005862:	cfc080e7          	jalr	-772(ra) # 8000555a <argfd>
    80005866:	87aa                	mv	a5,a0
    return -1;
    80005868:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000586a:	0007cc63          	bltz	a5,80005882 <sys_write+0x50>
  return filewrite(f, p, n);
    8000586e:	fe442603          	lw	a2,-28(s0)
    80005872:	fd843583          	ld	a1,-40(s0)
    80005876:	fe843503          	ld	a0,-24(s0)
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	452080e7          	jalr	1106(ra) # 80004ccc <filewrite>
}
    80005882:	70a2                	ld	ra,40(sp)
    80005884:	7402                	ld	s0,32(sp)
    80005886:	6145                	addi	sp,sp,48
    80005888:	8082                	ret

000000008000588a <sys_close>:
{
    8000588a:	1101                	addi	sp,sp,-32
    8000588c:	ec06                	sd	ra,24(sp)
    8000588e:	e822                	sd	s0,16(sp)
    80005890:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005892:	fe040613          	addi	a2,s0,-32
    80005896:	fec40593          	addi	a1,s0,-20
    8000589a:	4501                	li	a0,0
    8000589c:	00000097          	auipc	ra,0x0
    800058a0:	cbe080e7          	jalr	-834(ra) # 8000555a <argfd>
    return -1;
    800058a4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800058a6:	02054463          	bltz	a0,800058ce <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800058aa:	ffffc097          	auipc	ra,0xffffc
    800058ae:	396080e7          	jalr	918(ra) # 80001c40 <myproc>
    800058b2:	fec42783          	lw	a5,-20(s0)
    800058b6:	07e9                	addi	a5,a5,26
    800058b8:	078e                	slli	a5,a5,0x3
    800058ba:	953e                	add	a0,a0,a5
    800058bc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800058c0:	fe043503          	ld	a0,-32(s0)
    800058c4:	fffff097          	auipc	ra,0xfffff
    800058c8:	1e2080e7          	jalr	482(ra) # 80004aa6 <fileclose>
  return 0;
    800058cc:	4781                	li	a5,0
}
    800058ce:	853e                	mv	a0,a5
    800058d0:	60e2                	ld	ra,24(sp)
    800058d2:	6442                	ld	s0,16(sp)
    800058d4:	6105                	addi	sp,sp,32
    800058d6:	8082                	ret

00000000800058d8 <sys_fstat>:
{
    800058d8:	1101                	addi	sp,sp,-32
    800058da:	ec06                	sd	ra,24(sp)
    800058dc:	e822                	sd	s0,16(sp)
    800058de:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800058e0:	fe040593          	addi	a1,s0,-32
    800058e4:	4505                	li	a0,1
    800058e6:	ffffd097          	auipc	ra,0xffffd
    800058ea:	712080e7          	jalr	1810(ra) # 80002ff8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800058ee:	fe840613          	addi	a2,s0,-24
    800058f2:	4581                	li	a1,0
    800058f4:	4501                	li	a0,0
    800058f6:	00000097          	auipc	ra,0x0
    800058fa:	c64080e7          	jalr	-924(ra) # 8000555a <argfd>
    800058fe:	87aa                	mv	a5,a0
    return -1;
    80005900:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005902:	0007ca63          	bltz	a5,80005916 <sys_fstat+0x3e>
  return filestat(f, st);
    80005906:	fe043583          	ld	a1,-32(s0)
    8000590a:	fe843503          	ld	a0,-24(s0)
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	27a080e7          	jalr	634(ra) # 80004b88 <filestat>
}
    80005916:	60e2                	ld	ra,24(sp)
    80005918:	6442                	ld	s0,16(sp)
    8000591a:	6105                	addi	sp,sp,32
    8000591c:	8082                	ret

000000008000591e <sys_link>:
{
    8000591e:	7169                	addi	sp,sp,-304
    80005920:	f606                	sd	ra,296(sp)
    80005922:	f222                	sd	s0,288(sp)
    80005924:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005926:	08000613          	li	a2,128
    8000592a:	ed040593          	addi	a1,s0,-304
    8000592e:	4501                	li	a0,0
    80005930:	ffffd097          	auipc	ra,0xffffd
    80005934:	6e8080e7          	jalr	1768(ra) # 80003018 <argstr>
    return -1;
    80005938:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000593a:	12054663          	bltz	a0,80005a66 <sys_link+0x148>
    8000593e:	08000613          	li	a2,128
    80005942:	f5040593          	addi	a1,s0,-176
    80005946:	4505                	li	a0,1
    80005948:	ffffd097          	auipc	ra,0xffffd
    8000594c:	6d0080e7          	jalr	1744(ra) # 80003018 <argstr>
    return -1;
    80005950:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005952:	10054a63          	bltz	a0,80005a66 <sys_link+0x148>
    80005956:	ee26                	sd	s1,280(sp)
  begin_op();
    80005958:	fffff097          	auipc	ra,0xfffff
    8000595c:	c84080e7          	jalr	-892(ra) # 800045dc <begin_op>
  if((ip = namei(old)) == 0){
    80005960:	ed040513          	addi	a0,s0,-304
    80005964:	fffff097          	auipc	ra,0xfffff
    80005968:	a78080e7          	jalr	-1416(ra) # 800043dc <namei>
    8000596c:	84aa                	mv	s1,a0
    8000596e:	c949                	beqz	a0,80005a00 <sys_link+0xe2>
  ilock(ip);
    80005970:	ffffe097          	auipc	ra,0xffffe
    80005974:	29e080e7          	jalr	670(ra) # 80003c0e <ilock>
  if(ip->type == T_DIR){
    80005978:	04449703          	lh	a4,68(s1)
    8000597c:	4785                	li	a5,1
    8000597e:	08f70863          	beq	a4,a5,80005a0e <sys_link+0xf0>
    80005982:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005984:	04a4d783          	lhu	a5,74(s1)
    80005988:	2785                	addiw	a5,a5,1
    8000598a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000598e:	8526                	mv	a0,s1
    80005990:	ffffe097          	auipc	ra,0xffffe
    80005994:	1b2080e7          	jalr	434(ra) # 80003b42 <iupdate>
  iunlock(ip);
    80005998:	8526                	mv	a0,s1
    8000599a:	ffffe097          	auipc	ra,0xffffe
    8000599e:	33a080e7          	jalr	826(ra) # 80003cd4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800059a2:	fd040593          	addi	a1,s0,-48
    800059a6:	f5040513          	addi	a0,s0,-176
    800059aa:	fffff097          	auipc	ra,0xfffff
    800059ae:	a50080e7          	jalr	-1456(ra) # 800043fa <nameiparent>
    800059b2:	892a                	mv	s2,a0
    800059b4:	cd35                	beqz	a0,80005a30 <sys_link+0x112>
  ilock(dp);
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	258080e7          	jalr	600(ra) # 80003c0e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059be:	00092703          	lw	a4,0(s2)
    800059c2:	409c                	lw	a5,0(s1)
    800059c4:	06f71163          	bne	a4,a5,80005a26 <sys_link+0x108>
    800059c8:	40d0                	lw	a2,4(s1)
    800059ca:	fd040593          	addi	a1,s0,-48
    800059ce:	854a                	mv	a0,s2
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	95a080e7          	jalr	-1702(ra) # 8000432a <dirlink>
    800059d8:	04054763          	bltz	a0,80005a26 <sys_link+0x108>
  iunlockput(dp);
    800059dc:	854a                	mv	a0,s2
    800059de:	ffffe097          	auipc	ra,0xffffe
    800059e2:	496080e7          	jalr	1174(ra) # 80003e74 <iunlockput>
  iput(ip);
    800059e6:	8526                	mv	a0,s1
    800059e8:	ffffe097          	auipc	ra,0xffffe
    800059ec:	3e4080e7          	jalr	996(ra) # 80003dcc <iput>
  end_op();
    800059f0:	fffff097          	auipc	ra,0xfffff
    800059f4:	c66080e7          	jalr	-922(ra) # 80004656 <end_op>
  return 0;
    800059f8:	4781                	li	a5,0
    800059fa:	64f2                	ld	s1,280(sp)
    800059fc:	6952                	ld	s2,272(sp)
    800059fe:	a0a5                	j	80005a66 <sys_link+0x148>
    end_op();
    80005a00:	fffff097          	auipc	ra,0xfffff
    80005a04:	c56080e7          	jalr	-938(ra) # 80004656 <end_op>
    return -1;
    80005a08:	57fd                	li	a5,-1
    80005a0a:	64f2                	ld	s1,280(sp)
    80005a0c:	a8a9                	j	80005a66 <sys_link+0x148>
    iunlockput(ip);
    80005a0e:	8526                	mv	a0,s1
    80005a10:	ffffe097          	auipc	ra,0xffffe
    80005a14:	464080e7          	jalr	1124(ra) # 80003e74 <iunlockput>
    end_op();
    80005a18:	fffff097          	auipc	ra,0xfffff
    80005a1c:	c3e080e7          	jalr	-962(ra) # 80004656 <end_op>
    return -1;
    80005a20:	57fd                	li	a5,-1
    80005a22:	64f2                	ld	s1,280(sp)
    80005a24:	a089                	j	80005a66 <sys_link+0x148>
    iunlockput(dp);
    80005a26:	854a                	mv	a0,s2
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	44c080e7          	jalr	1100(ra) # 80003e74 <iunlockput>
  ilock(ip);
    80005a30:	8526                	mv	a0,s1
    80005a32:	ffffe097          	auipc	ra,0xffffe
    80005a36:	1dc080e7          	jalr	476(ra) # 80003c0e <ilock>
  ip->nlink--;
    80005a3a:	04a4d783          	lhu	a5,74(s1)
    80005a3e:	37fd                	addiw	a5,a5,-1
    80005a40:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a44:	8526                	mv	a0,s1
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	0fc080e7          	jalr	252(ra) # 80003b42 <iupdate>
  iunlockput(ip);
    80005a4e:	8526                	mv	a0,s1
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	424080e7          	jalr	1060(ra) # 80003e74 <iunlockput>
  end_op();
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	bfe080e7          	jalr	-1026(ra) # 80004656 <end_op>
  return -1;
    80005a60:	57fd                	li	a5,-1
    80005a62:	64f2                	ld	s1,280(sp)
    80005a64:	6952                	ld	s2,272(sp)
}
    80005a66:	853e                	mv	a0,a5
    80005a68:	70b2                	ld	ra,296(sp)
    80005a6a:	7412                	ld	s0,288(sp)
    80005a6c:	6155                	addi	sp,sp,304
    80005a6e:	8082                	ret

0000000080005a70 <sys_unlink>:
{
    80005a70:	7151                	addi	sp,sp,-240
    80005a72:	f586                	sd	ra,232(sp)
    80005a74:	f1a2                	sd	s0,224(sp)
    80005a76:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a78:	08000613          	li	a2,128
    80005a7c:	f3040593          	addi	a1,s0,-208
    80005a80:	4501                	li	a0,0
    80005a82:	ffffd097          	auipc	ra,0xffffd
    80005a86:	596080e7          	jalr	1430(ra) # 80003018 <argstr>
    80005a8a:	1a054a63          	bltz	a0,80005c3e <sys_unlink+0x1ce>
    80005a8e:	eda6                	sd	s1,216(sp)
  begin_op();
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	b4c080e7          	jalr	-1204(ra) # 800045dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a98:	fb040593          	addi	a1,s0,-80
    80005a9c:	f3040513          	addi	a0,s0,-208
    80005aa0:	fffff097          	auipc	ra,0xfffff
    80005aa4:	95a080e7          	jalr	-1702(ra) # 800043fa <nameiparent>
    80005aa8:	84aa                	mv	s1,a0
    80005aaa:	cd71                	beqz	a0,80005b86 <sys_unlink+0x116>
  ilock(dp);
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	162080e7          	jalr	354(ra) # 80003c0e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ab4:	00003597          	auipc	a1,0x3
    80005ab8:	c0c58593          	addi	a1,a1,-1012 # 800086c0 <etext+0x6c0>
    80005abc:	fb040513          	addi	a0,s0,-80
    80005ac0:	ffffe097          	auipc	ra,0xffffe
    80005ac4:	640080e7          	jalr	1600(ra) # 80004100 <namecmp>
    80005ac8:	14050c63          	beqz	a0,80005c20 <sys_unlink+0x1b0>
    80005acc:	00003597          	auipc	a1,0x3
    80005ad0:	bfc58593          	addi	a1,a1,-1028 # 800086c8 <etext+0x6c8>
    80005ad4:	fb040513          	addi	a0,s0,-80
    80005ad8:	ffffe097          	auipc	ra,0xffffe
    80005adc:	628080e7          	jalr	1576(ra) # 80004100 <namecmp>
    80005ae0:	14050063          	beqz	a0,80005c20 <sys_unlink+0x1b0>
    80005ae4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ae6:	f2c40613          	addi	a2,s0,-212
    80005aea:	fb040593          	addi	a1,s0,-80
    80005aee:	8526                	mv	a0,s1
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	62a080e7          	jalr	1578(ra) # 8000411a <dirlookup>
    80005af8:	892a                	mv	s2,a0
    80005afa:	12050263          	beqz	a0,80005c1e <sys_unlink+0x1ae>
  ilock(ip);
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	110080e7          	jalr	272(ra) # 80003c0e <ilock>
  if(ip->nlink < 1)
    80005b06:	04a91783          	lh	a5,74(s2)
    80005b0a:	08f05563          	blez	a5,80005b94 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b0e:	04491703          	lh	a4,68(s2)
    80005b12:	4785                	li	a5,1
    80005b14:	08f70963          	beq	a4,a5,80005ba6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005b18:	4641                	li	a2,16
    80005b1a:	4581                	li	a1,0
    80005b1c:	fc040513          	addi	a0,s0,-64
    80005b20:	ffffb097          	auipc	ra,0xffffb
    80005b24:	214080e7          	jalr	532(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b28:	4741                	li	a4,16
    80005b2a:	f2c42683          	lw	a3,-212(s0)
    80005b2e:	fc040613          	addi	a2,s0,-64
    80005b32:	4581                	li	a1,0
    80005b34:	8526                	mv	a0,s1
    80005b36:	ffffe097          	auipc	ra,0xffffe
    80005b3a:	4a0080e7          	jalr	1184(ra) # 80003fd6 <writei>
    80005b3e:	47c1                	li	a5,16
    80005b40:	0af51b63          	bne	a0,a5,80005bf6 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005b44:	04491703          	lh	a4,68(s2)
    80005b48:	4785                	li	a5,1
    80005b4a:	0af70f63          	beq	a4,a5,80005c08 <sys_unlink+0x198>
  iunlockput(dp);
    80005b4e:	8526                	mv	a0,s1
    80005b50:	ffffe097          	auipc	ra,0xffffe
    80005b54:	324080e7          	jalr	804(ra) # 80003e74 <iunlockput>
  ip->nlink--;
    80005b58:	04a95783          	lhu	a5,74(s2)
    80005b5c:	37fd                	addiw	a5,a5,-1
    80005b5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b62:	854a                	mv	a0,s2
    80005b64:	ffffe097          	auipc	ra,0xffffe
    80005b68:	fde080e7          	jalr	-34(ra) # 80003b42 <iupdate>
  iunlockput(ip);
    80005b6c:	854a                	mv	a0,s2
    80005b6e:	ffffe097          	auipc	ra,0xffffe
    80005b72:	306080e7          	jalr	774(ra) # 80003e74 <iunlockput>
  end_op();
    80005b76:	fffff097          	auipc	ra,0xfffff
    80005b7a:	ae0080e7          	jalr	-1312(ra) # 80004656 <end_op>
  return 0;
    80005b7e:	4501                	li	a0,0
    80005b80:	64ee                	ld	s1,216(sp)
    80005b82:	694e                	ld	s2,208(sp)
    80005b84:	a84d                	j	80005c36 <sys_unlink+0x1c6>
    end_op();
    80005b86:	fffff097          	auipc	ra,0xfffff
    80005b8a:	ad0080e7          	jalr	-1328(ra) # 80004656 <end_op>
    return -1;
    80005b8e:	557d                	li	a0,-1
    80005b90:	64ee                	ld	s1,216(sp)
    80005b92:	a055                	j	80005c36 <sys_unlink+0x1c6>
    80005b94:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005b96:	00003517          	auipc	a0,0x3
    80005b9a:	b3a50513          	addi	a0,a0,-1222 # 800086d0 <etext+0x6d0>
    80005b9e:	ffffb097          	auipc	ra,0xffffb
    80005ba2:	9c2080e7          	jalr	-1598(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ba6:	04c92703          	lw	a4,76(s2)
    80005baa:	02000793          	li	a5,32
    80005bae:	f6e7f5e3          	bgeu	a5,a4,80005b18 <sys_unlink+0xa8>
    80005bb2:	e5ce                	sd	s3,200(sp)
    80005bb4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bb8:	4741                	li	a4,16
    80005bba:	86ce                	mv	a3,s3
    80005bbc:	f1840613          	addi	a2,s0,-232
    80005bc0:	4581                	li	a1,0
    80005bc2:	854a                	mv	a0,s2
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	302080e7          	jalr	770(ra) # 80003ec6 <readi>
    80005bcc:	47c1                	li	a5,16
    80005bce:	00f51c63          	bne	a0,a5,80005be6 <sys_unlink+0x176>
    if(de.inum != 0)
    80005bd2:	f1845783          	lhu	a5,-232(s0)
    80005bd6:	e7b5                	bnez	a5,80005c42 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bd8:	29c1                	addiw	s3,s3,16
    80005bda:	04c92783          	lw	a5,76(s2)
    80005bde:	fcf9ede3          	bltu	s3,a5,80005bb8 <sys_unlink+0x148>
    80005be2:	69ae                	ld	s3,200(sp)
    80005be4:	bf15                	j	80005b18 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005be6:	00003517          	auipc	a0,0x3
    80005bea:	b0250513          	addi	a0,a0,-1278 # 800086e8 <etext+0x6e8>
    80005bee:	ffffb097          	auipc	ra,0xffffb
    80005bf2:	972080e7          	jalr	-1678(ra) # 80000560 <panic>
    80005bf6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005bf8:	00003517          	auipc	a0,0x3
    80005bfc:	b0850513          	addi	a0,a0,-1272 # 80008700 <etext+0x700>
    80005c00:	ffffb097          	auipc	ra,0xffffb
    80005c04:	960080e7          	jalr	-1696(ra) # 80000560 <panic>
    dp->nlink--;
    80005c08:	04a4d783          	lhu	a5,74(s1)
    80005c0c:	37fd                	addiw	a5,a5,-1
    80005c0e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c12:	8526                	mv	a0,s1
    80005c14:	ffffe097          	auipc	ra,0xffffe
    80005c18:	f2e080e7          	jalr	-210(ra) # 80003b42 <iupdate>
    80005c1c:	bf0d                	j	80005b4e <sys_unlink+0xde>
    80005c1e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005c20:	8526                	mv	a0,s1
    80005c22:	ffffe097          	auipc	ra,0xffffe
    80005c26:	252080e7          	jalr	594(ra) # 80003e74 <iunlockput>
  end_op();
    80005c2a:	fffff097          	auipc	ra,0xfffff
    80005c2e:	a2c080e7          	jalr	-1492(ra) # 80004656 <end_op>
  return -1;
    80005c32:	557d                	li	a0,-1
    80005c34:	64ee                	ld	s1,216(sp)
}
    80005c36:	70ae                	ld	ra,232(sp)
    80005c38:	740e                	ld	s0,224(sp)
    80005c3a:	616d                	addi	sp,sp,240
    80005c3c:	8082                	ret
    return -1;
    80005c3e:	557d                	li	a0,-1
    80005c40:	bfdd                	j	80005c36 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005c42:	854a                	mv	a0,s2
    80005c44:	ffffe097          	auipc	ra,0xffffe
    80005c48:	230080e7          	jalr	560(ra) # 80003e74 <iunlockput>
    goto bad;
    80005c4c:	694e                	ld	s2,208(sp)
    80005c4e:	69ae                	ld	s3,200(sp)
    80005c50:	bfc1                	j	80005c20 <sys_unlink+0x1b0>

0000000080005c52 <sys_open>:

uint64
sys_open(void)
{
    80005c52:	7131                	addi	sp,sp,-192
    80005c54:	fd06                	sd	ra,184(sp)
    80005c56:	f922                	sd	s0,176(sp)
    80005c58:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005c5a:	f4c40593          	addi	a1,s0,-180
    80005c5e:	4505                	li	a0,1
    80005c60:	ffffd097          	auipc	ra,0xffffd
    80005c64:	378080e7          	jalr	888(ra) # 80002fd8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c68:	08000613          	li	a2,128
    80005c6c:	f5040593          	addi	a1,s0,-176
    80005c70:	4501                	li	a0,0
    80005c72:	ffffd097          	auipc	ra,0xffffd
    80005c76:	3a6080e7          	jalr	934(ra) # 80003018 <argstr>
    80005c7a:	87aa                	mv	a5,a0
    return -1;
    80005c7c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c7e:	0a07ce63          	bltz	a5,80005d3a <sys_open+0xe8>
    80005c82:	f526                	sd	s1,168(sp)

  begin_op();
    80005c84:	fffff097          	auipc	ra,0xfffff
    80005c88:	958080e7          	jalr	-1704(ra) # 800045dc <begin_op>

  if(omode & O_CREATE){
    80005c8c:	f4c42783          	lw	a5,-180(s0)
    80005c90:	2007f793          	andi	a5,a5,512
    80005c94:	cfd5                	beqz	a5,80005d50 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c96:	4681                	li	a3,0
    80005c98:	4601                	li	a2,0
    80005c9a:	4589                	li	a1,2
    80005c9c:	f5040513          	addi	a0,s0,-176
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	95c080e7          	jalr	-1700(ra) # 800055fc <create>
    80005ca8:	84aa                	mv	s1,a0
    if(ip == 0){
    80005caa:	cd41                	beqz	a0,80005d42 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005cac:	04449703          	lh	a4,68(s1)
    80005cb0:	478d                	li	a5,3
    80005cb2:	00f71763          	bne	a4,a5,80005cc0 <sys_open+0x6e>
    80005cb6:	0464d703          	lhu	a4,70(s1)
    80005cba:	47a5                	li	a5,9
    80005cbc:	0ee7e163          	bltu	a5,a4,80005d9e <sys_open+0x14c>
    80005cc0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005cc2:	fffff097          	auipc	ra,0xfffff
    80005cc6:	d28080e7          	jalr	-728(ra) # 800049ea <filealloc>
    80005cca:	892a                	mv	s2,a0
    80005ccc:	c97d                	beqz	a0,80005dc2 <sys_open+0x170>
    80005cce:	ed4e                	sd	s3,152(sp)
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	8ea080e7          	jalr	-1814(ra) # 800055ba <fdalloc>
    80005cd8:	89aa                	mv	s3,a0
    80005cda:	0c054e63          	bltz	a0,80005db6 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005cde:	04449703          	lh	a4,68(s1)
    80005ce2:	478d                	li	a5,3
    80005ce4:	0ef70c63          	beq	a4,a5,80005ddc <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005ce8:	4789                	li	a5,2
    80005cea:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005cee:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005cf2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005cf6:	f4c42783          	lw	a5,-180(s0)
    80005cfa:	0017c713          	xori	a4,a5,1
    80005cfe:	8b05                	andi	a4,a4,1
    80005d00:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d04:	0037f713          	andi	a4,a5,3
    80005d08:	00e03733          	snez	a4,a4
    80005d0c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d10:	4007f793          	andi	a5,a5,1024
    80005d14:	c791                	beqz	a5,80005d20 <sys_open+0xce>
    80005d16:	04449703          	lh	a4,68(s1)
    80005d1a:	4789                	li	a5,2
    80005d1c:	0cf70763          	beq	a4,a5,80005dea <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005d20:	8526                	mv	a0,s1
    80005d22:	ffffe097          	auipc	ra,0xffffe
    80005d26:	fb2080e7          	jalr	-78(ra) # 80003cd4 <iunlock>
  end_op();
    80005d2a:	fffff097          	auipc	ra,0xfffff
    80005d2e:	92c080e7          	jalr	-1748(ra) # 80004656 <end_op>

  return fd;
    80005d32:	854e                	mv	a0,s3
    80005d34:	74aa                	ld	s1,168(sp)
    80005d36:	790a                	ld	s2,160(sp)
    80005d38:	69ea                	ld	s3,152(sp)
}
    80005d3a:	70ea                	ld	ra,184(sp)
    80005d3c:	744a                	ld	s0,176(sp)
    80005d3e:	6129                	addi	sp,sp,192
    80005d40:	8082                	ret
      end_op();
    80005d42:	fffff097          	auipc	ra,0xfffff
    80005d46:	914080e7          	jalr	-1772(ra) # 80004656 <end_op>
      return -1;
    80005d4a:	557d                	li	a0,-1
    80005d4c:	74aa                	ld	s1,168(sp)
    80005d4e:	b7f5                	j	80005d3a <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005d50:	f5040513          	addi	a0,s0,-176
    80005d54:	ffffe097          	auipc	ra,0xffffe
    80005d58:	688080e7          	jalr	1672(ra) # 800043dc <namei>
    80005d5c:	84aa                	mv	s1,a0
    80005d5e:	c90d                	beqz	a0,80005d90 <sys_open+0x13e>
    ilock(ip);
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	eae080e7          	jalr	-338(ra) # 80003c0e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005d68:	04449703          	lh	a4,68(s1)
    80005d6c:	4785                	li	a5,1
    80005d6e:	f2f71fe3          	bne	a4,a5,80005cac <sys_open+0x5a>
    80005d72:	f4c42783          	lw	a5,-180(s0)
    80005d76:	d7a9                	beqz	a5,80005cc0 <sys_open+0x6e>
      iunlockput(ip);
    80005d78:	8526                	mv	a0,s1
    80005d7a:	ffffe097          	auipc	ra,0xffffe
    80005d7e:	0fa080e7          	jalr	250(ra) # 80003e74 <iunlockput>
      end_op();
    80005d82:	fffff097          	auipc	ra,0xfffff
    80005d86:	8d4080e7          	jalr	-1836(ra) # 80004656 <end_op>
      return -1;
    80005d8a:	557d                	li	a0,-1
    80005d8c:	74aa                	ld	s1,168(sp)
    80005d8e:	b775                	j	80005d3a <sys_open+0xe8>
      end_op();
    80005d90:	fffff097          	auipc	ra,0xfffff
    80005d94:	8c6080e7          	jalr	-1850(ra) # 80004656 <end_op>
      return -1;
    80005d98:	557d                	li	a0,-1
    80005d9a:	74aa                	ld	s1,168(sp)
    80005d9c:	bf79                	j	80005d3a <sys_open+0xe8>
    iunlockput(ip);
    80005d9e:	8526                	mv	a0,s1
    80005da0:	ffffe097          	auipc	ra,0xffffe
    80005da4:	0d4080e7          	jalr	212(ra) # 80003e74 <iunlockput>
    end_op();
    80005da8:	fffff097          	auipc	ra,0xfffff
    80005dac:	8ae080e7          	jalr	-1874(ra) # 80004656 <end_op>
    return -1;
    80005db0:	557d                	li	a0,-1
    80005db2:	74aa                	ld	s1,168(sp)
    80005db4:	b759                	j	80005d3a <sys_open+0xe8>
      fileclose(f);
    80005db6:	854a                	mv	a0,s2
    80005db8:	fffff097          	auipc	ra,0xfffff
    80005dbc:	cee080e7          	jalr	-786(ra) # 80004aa6 <fileclose>
    80005dc0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005dc2:	8526                	mv	a0,s1
    80005dc4:	ffffe097          	auipc	ra,0xffffe
    80005dc8:	0b0080e7          	jalr	176(ra) # 80003e74 <iunlockput>
    end_op();
    80005dcc:	fffff097          	auipc	ra,0xfffff
    80005dd0:	88a080e7          	jalr	-1910(ra) # 80004656 <end_op>
    return -1;
    80005dd4:	557d                	li	a0,-1
    80005dd6:	74aa                	ld	s1,168(sp)
    80005dd8:	790a                	ld	s2,160(sp)
    80005dda:	b785                	j	80005d3a <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005ddc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005de0:	04649783          	lh	a5,70(s1)
    80005de4:	02f91223          	sh	a5,36(s2)
    80005de8:	b729                	j	80005cf2 <sys_open+0xa0>
    itrunc(ip);
    80005dea:	8526                	mv	a0,s1
    80005dec:	ffffe097          	auipc	ra,0xffffe
    80005df0:	f34080e7          	jalr	-204(ra) # 80003d20 <itrunc>
    80005df4:	b735                	j	80005d20 <sys_open+0xce>

0000000080005df6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005df6:	7175                	addi	sp,sp,-144
    80005df8:	e506                	sd	ra,136(sp)
    80005dfa:	e122                	sd	s0,128(sp)
    80005dfc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005dfe:	ffffe097          	auipc	ra,0xffffe
    80005e02:	7de080e7          	jalr	2014(ra) # 800045dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e06:	08000613          	li	a2,128
    80005e0a:	f7040593          	addi	a1,s0,-144
    80005e0e:	4501                	li	a0,0
    80005e10:	ffffd097          	auipc	ra,0xffffd
    80005e14:	208080e7          	jalr	520(ra) # 80003018 <argstr>
    80005e18:	02054963          	bltz	a0,80005e4a <sys_mkdir+0x54>
    80005e1c:	4681                	li	a3,0
    80005e1e:	4601                	li	a2,0
    80005e20:	4585                	li	a1,1
    80005e22:	f7040513          	addi	a0,s0,-144
    80005e26:	fffff097          	auipc	ra,0xfffff
    80005e2a:	7d6080e7          	jalr	2006(ra) # 800055fc <create>
    80005e2e:	cd11                	beqz	a0,80005e4a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	044080e7          	jalr	68(ra) # 80003e74 <iunlockput>
  end_op();
    80005e38:	fffff097          	auipc	ra,0xfffff
    80005e3c:	81e080e7          	jalr	-2018(ra) # 80004656 <end_op>
  return 0;
    80005e40:	4501                	li	a0,0
}
    80005e42:	60aa                	ld	ra,136(sp)
    80005e44:	640a                	ld	s0,128(sp)
    80005e46:	6149                	addi	sp,sp,144
    80005e48:	8082                	ret
    end_op();
    80005e4a:	fffff097          	auipc	ra,0xfffff
    80005e4e:	80c080e7          	jalr	-2036(ra) # 80004656 <end_op>
    return -1;
    80005e52:	557d                	li	a0,-1
    80005e54:	b7fd                	j	80005e42 <sys_mkdir+0x4c>

0000000080005e56 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e56:	7135                	addi	sp,sp,-160
    80005e58:	ed06                	sd	ra,152(sp)
    80005e5a:	e922                	sd	s0,144(sp)
    80005e5c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e5e:	ffffe097          	auipc	ra,0xffffe
    80005e62:	77e080e7          	jalr	1918(ra) # 800045dc <begin_op>
  argint(1, &major);
    80005e66:	f6c40593          	addi	a1,s0,-148
    80005e6a:	4505                	li	a0,1
    80005e6c:	ffffd097          	auipc	ra,0xffffd
    80005e70:	16c080e7          	jalr	364(ra) # 80002fd8 <argint>
  argint(2, &minor);
    80005e74:	f6840593          	addi	a1,s0,-152
    80005e78:	4509                	li	a0,2
    80005e7a:	ffffd097          	auipc	ra,0xffffd
    80005e7e:	15e080e7          	jalr	350(ra) # 80002fd8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e82:	08000613          	li	a2,128
    80005e86:	f7040593          	addi	a1,s0,-144
    80005e8a:	4501                	li	a0,0
    80005e8c:	ffffd097          	auipc	ra,0xffffd
    80005e90:	18c080e7          	jalr	396(ra) # 80003018 <argstr>
    80005e94:	02054b63          	bltz	a0,80005eca <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e98:	f6841683          	lh	a3,-152(s0)
    80005e9c:	f6c41603          	lh	a2,-148(s0)
    80005ea0:	458d                	li	a1,3
    80005ea2:	f7040513          	addi	a0,s0,-144
    80005ea6:	fffff097          	auipc	ra,0xfffff
    80005eaa:	756080e7          	jalr	1878(ra) # 800055fc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005eae:	cd11                	beqz	a0,80005eca <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005eb0:	ffffe097          	auipc	ra,0xffffe
    80005eb4:	fc4080e7          	jalr	-60(ra) # 80003e74 <iunlockput>
  end_op();
    80005eb8:	ffffe097          	auipc	ra,0xffffe
    80005ebc:	79e080e7          	jalr	1950(ra) # 80004656 <end_op>
  return 0;
    80005ec0:	4501                	li	a0,0
}
    80005ec2:	60ea                	ld	ra,152(sp)
    80005ec4:	644a                	ld	s0,144(sp)
    80005ec6:	610d                	addi	sp,sp,160
    80005ec8:	8082                	ret
    end_op();
    80005eca:	ffffe097          	auipc	ra,0xffffe
    80005ece:	78c080e7          	jalr	1932(ra) # 80004656 <end_op>
    return -1;
    80005ed2:	557d                	li	a0,-1
    80005ed4:	b7fd                	j	80005ec2 <sys_mknod+0x6c>

0000000080005ed6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005ed6:	7135                	addi	sp,sp,-160
    80005ed8:	ed06                	sd	ra,152(sp)
    80005eda:	e922                	sd	s0,144(sp)
    80005edc:	e14a                	sd	s2,128(sp)
    80005ede:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ee0:	ffffc097          	auipc	ra,0xffffc
    80005ee4:	d60080e7          	jalr	-672(ra) # 80001c40 <myproc>
    80005ee8:	892a                	mv	s2,a0
  
  begin_op();
    80005eea:	ffffe097          	auipc	ra,0xffffe
    80005eee:	6f2080e7          	jalr	1778(ra) # 800045dc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ef2:	08000613          	li	a2,128
    80005ef6:	f6040593          	addi	a1,s0,-160
    80005efa:	4501                	li	a0,0
    80005efc:	ffffd097          	auipc	ra,0xffffd
    80005f00:	11c080e7          	jalr	284(ra) # 80003018 <argstr>
    80005f04:	04054d63          	bltz	a0,80005f5e <sys_chdir+0x88>
    80005f08:	e526                	sd	s1,136(sp)
    80005f0a:	f6040513          	addi	a0,s0,-160
    80005f0e:	ffffe097          	auipc	ra,0xffffe
    80005f12:	4ce080e7          	jalr	1230(ra) # 800043dc <namei>
    80005f16:	84aa                	mv	s1,a0
    80005f18:	c131                	beqz	a0,80005f5c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f1a:	ffffe097          	auipc	ra,0xffffe
    80005f1e:	cf4080e7          	jalr	-780(ra) # 80003c0e <ilock>
  if(ip->type != T_DIR){
    80005f22:	04449703          	lh	a4,68(s1)
    80005f26:	4785                	li	a5,1
    80005f28:	04f71163          	bne	a4,a5,80005f6a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f2c:	8526                	mv	a0,s1
    80005f2e:	ffffe097          	auipc	ra,0xffffe
    80005f32:	da6080e7          	jalr	-602(ra) # 80003cd4 <iunlock>
  iput(p->cwd);
    80005f36:	15093503          	ld	a0,336(s2)
    80005f3a:	ffffe097          	auipc	ra,0xffffe
    80005f3e:	e92080e7          	jalr	-366(ra) # 80003dcc <iput>
  end_op();
    80005f42:	ffffe097          	auipc	ra,0xffffe
    80005f46:	714080e7          	jalr	1812(ra) # 80004656 <end_op>
  p->cwd = ip;
    80005f4a:	14993823          	sd	s1,336(s2)
  return 0;
    80005f4e:	4501                	li	a0,0
    80005f50:	64aa                	ld	s1,136(sp)
}
    80005f52:	60ea                	ld	ra,152(sp)
    80005f54:	644a                	ld	s0,144(sp)
    80005f56:	690a                	ld	s2,128(sp)
    80005f58:	610d                	addi	sp,sp,160
    80005f5a:	8082                	ret
    80005f5c:	64aa                	ld	s1,136(sp)
    end_op();
    80005f5e:	ffffe097          	auipc	ra,0xffffe
    80005f62:	6f8080e7          	jalr	1784(ra) # 80004656 <end_op>
    return -1;
    80005f66:	557d                	li	a0,-1
    80005f68:	b7ed                	j	80005f52 <sys_chdir+0x7c>
    iunlockput(ip);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	ffffe097          	auipc	ra,0xffffe
    80005f70:	f08080e7          	jalr	-248(ra) # 80003e74 <iunlockput>
    end_op();
    80005f74:	ffffe097          	auipc	ra,0xffffe
    80005f78:	6e2080e7          	jalr	1762(ra) # 80004656 <end_op>
    return -1;
    80005f7c:	557d                	li	a0,-1
    80005f7e:	64aa                	ld	s1,136(sp)
    80005f80:	bfc9                	j	80005f52 <sys_chdir+0x7c>

0000000080005f82 <sys_exec>:

uint64
sys_exec(void)
{
    80005f82:	7121                	addi	sp,sp,-448
    80005f84:	ff06                	sd	ra,440(sp)
    80005f86:	fb22                	sd	s0,432(sp)
    80005f88:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005f8a:	e4840593          	addi	a1,s0,-440
    80005f8e:	4505                	li	a0,1
    80005f90:	ffffd097          	auipc	ra,0xffffd
    80005f94:	068080e7          	jalr	104(ra) # 80002ff8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005f98:	08000613          	li	a2,128
    80005f9c:	f5040593          	addi	a1,s0,-176
    80005fa0:	4501                	li	a0,0
    80005fa2:	ffffd097          	auipc	ra,0xffffd
    80005fa6:	076080e7          	jalr	118(ra) # 80003018 <argstr>
    80005faa:	87aa                	mv	a5,a0
    return -1;
    80005fac:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005fae:	0e07c263          	bltz	a5,80006092 <sys_exec+0x110>
    80005fb2:	f726                	sd	s1,424(sp)
    80005fb4:	f34a                	sd	s2,416(sp)
    80005fb6:	ef4e                	sd	s3,408(sp)
    80005fb8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005fba:	10000613          	li	a2,256
    80005fbe:	4581                	li	a1,0
    80005fc0:	e5040513          	addi	a0,s0,-432
    80005fc4:	ffffb097          	auipc	ra,0xffffb
    80005fc8:	d70080e7          	jalr	-656(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005fcc:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005fd0:	89a6                	mv	s3,s1
    80005fd2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005fd4:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fd8:	00391513          	slli	a0,s2,0x3
    80005fdc:	e4040593          	addi	a1,s0,-448
    80005fe0:	e4843783          	ld	a5,-440(s0)
    80005fe4:	953e                	add	a0,a0,a5
    80005fe6:	ffffd097          	auipc	ra,0xffffd
    80005fea:	f54080e7          	jalr	-172(ra) # 80002f3a <fetchaddr>
    80005fee:	02054a63          	bltz	a0,80006022 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005ff2:	e4043783          	ld	a5,-448(s0)
    80005ff6:	c7b9                	beqz	a5,80006044 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ff8:	ffffb097          	auipc	ra,0xffffb
    80005ffc:	b50080e7          	jalr	-1200(ra) # 80000b48 <kalloc>
    80006000:	85aa                	mv	a1,a0
    80006002:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006006:	cd11                	beqz	a0,80006022 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006008:	6605                	lui	a2,0x1
    8000600a:	e4043503          	ld	a0,-448(s0)
    8000600e:	ffffd097          	auipc	ra,0xffffd
    80006012:	f7e080e7          	jalr	-130(ra) # 80002f8c <fetchstr>
    80006016:	00054663          	bltz	a0,80006022 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000601a:	0905                	addi	s2,s2,1
    8000601c:	09a1                	addi	s3,s3,8
    8000601e:	fb491de3          	bne	s2,s4,80005fd8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006022:	f5040913          	addi	s2,s0,-176
    80006026:	6088                	ld	a0,0(s1)
    80006028:	c125                	beqz	a0,80006088 <sys_exec+0x106>
    kfree(argv[i]);
    8000602a:	ffffb097          	auipc	ra,0xffffb
    8000602e:	a20080e7          	jalr	-1504(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006032:	04a1                	addi	s1,s1,8
    80006034:	ff2499e3          	bne	s1,s2,80006026 <sys_exec+0xa4>
  return -1;
    80006038:	557d                	li	a0,-1
    8000603a:	74ba                	ld	s1,424(sp)
    8000603c:	791a                	ld	s2,416(sp)
    8000603e:	69fa                	ld	s3,408(sp)
    80006040:	6a5a                	ld	s4,400(sp)
    80006042:	a881                	j	80006092 <sys_exec+0x110>
      argv[i] = 0;
    80006044:	0009079b          	sext.w	a5,s2
    80006048:	078e                	slli	a5,a5,0x3
    8000604a:	fd078793          	addi	a5,a5,-48
    8000604e:	97a2                	add	a5,a5,s0
    80006050:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006054:	e5040593          	addi	a1,s0,-432
    80006058:	f5040513          	addi	a0,s0,-176
    8000605c:	fffff097          	auipc	ra,0xfffff
    80006060:	120080e7          	jalr	288(ra) # 8000517c <exec>
    80006064:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006066:	f5040993          	addi	s3,s0,-176
    8000606a:	6088                	ld	a0,0(s1)
    8000606c:	c901                	beqz	a0,8000607c <sys_exec+0xfa>
    kfree(argv[i]);
    8000606e:	ffffb097          	auipc	ra,0xffffb
    80006072:	9dc080e7          	jalr	-1572(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006076:	04a1                	addi	s1,s1,8
    80006078:	ff3499e3          	bne	s1,s3,8000606a <sys_exec+0xe8>
  return ret;
    8000607c:	854a                	mv	a0,s2
    8000607e:	74ba                	ld	s1,424(sp)
    80006080:	791a                	ld	s2,416(sp)
    80006082:	69fa                	ld	s3,408(sp)
    80006084:	6a5a                	ld	s4,400(sp)
    80006086:	a031                	j	80006092 <sys_exec+0x110>
  return -1;
    80006088:	557d                	li	a0,-1
    8000608a:	74ba                	ld	s1,424(sp)
    8000608c:	791a                	ld	s2,416(sp)
    8000608e:	69fa                	ld	s3,408(sp)
    80006090:	6a5a                	ld	s4,400(sp)
}
    80006092:	70fa                	ld	ra,440(sp)
    80006094:	745a                	ld	s0,432(sp)
    80006096:	6139                	addi	sp,sp,448
    80006098:	8082                	ret

000000008000609a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000609a:	7139                	addi	sp,sp,-64
    8000609c:	fc06                	sd	ra,56(sp)
    8000609e:	f822                	sd	s0,48(sp)
    800060a0:	f426                	sd	s1,40(sp)
    800060a2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060a4:	ffffc097          	auipc	ra,0xffffc
    800060a8:	b9c080e7          	jalr	-1124(ra) # 80001c40 <myproc>
    800060ac:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800060ae:	fd840593          	addi	a1,s0,-40
    800060b2:	4501                	li	a0,0
    800060b4:	ffffd097          	auipc	ra,0xffffd
    800060b8:	f44080e7          	jalr	-188(ra) # 80002ff8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800060bc:	fc840593          	addi	a1,s0,-56
    800060c0:	fd040513          	addi	a0,s0,-48
    800060c4:	fffff097          	auipc	ra,0xfffff
    800060c8:	d50080e7          	jalr	-688(ra) # 80004e14 <pipealloc>
    return -1;
    800060cc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800060ce:	0c054463          	bltz	a0,80006196 <sys_pipe+0xfc>
  fd0 = -1;
    800060d2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800060d6:	fd043503          	ld	a0,-48(s0)
    800060da:	fffff097          	auipc	ra,0xfffff
    800060de:	4e0080e7          	jalr	1248(ra) # 800055ba <fdalloc>
    800060e2:	fca42223          	sw	a0,-60(s0)
    800060e6:	08054b63          	bltz	a0,8000617c <sys_pipe+0xe2>
    800060ea:	fc843503          	ld	a0,-56(s0)
    800060ee:	fffff097          	auipc	ra,0xfffff
    800060f2:	4cc080e7          	jalr	1228(ra) # 800055ba <fdalloc>
    800060f6:	fca42023          	sw	a0,-64(s0)
    800060fa:	06054863          	bltz	a0,8000616a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060fe:	4691                	li	a3,4
    80006100:	fc440613          	addi	a2,s0,-60
    80006104:	fd843583          	ld	a1,-40(s0)
    80006108:	68a8                	ld	a0,80(s1)
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	5d8080e7          	jalr	1496(ra) # 800016e2 <copyout>
    80006112:	02054063          	bltz	a0,80006132 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006116:	4691                	li	a3,4
    80006118:	fc040613          	addi	a2,s0,-64
    8000611c:	fd843583          	ld	a1,-40(s0)
    80006120:	0591                	addi	a1,a1,4
    80006122:	68a8                	ld	a0,80(s1)
    80006124:	ffffb097          	auipc	ra,0xffffb
    80006128:	5be080e7          	jalr	1470(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000612c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000612e:	06055463          	bgez	a0,80006196 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006132:	fc442783          	lw	a5,-60(s0)
    80006136:	07e9                	addi	a5,a5,26
    80006138:	078e                	slli	a5,a5,0x3
    8000613a:	97a6                	add	a5,a5,s1
    8000613c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006140:	fc042783          	lw	a5,-64(s0)
    80006144:	07e9                	addi	a5,a5,26
    80006146:	078e                	slli	a5,a5,0x3
    80006148:	94be                	add	s1,s1,a5
    8000614a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000614e:	fd043503          	ld	a0,-48(s0)
    80006152:	fffff097          	auipc	ra,0xfffff
    80006156:	954080e7          	jalr	-1708(ra) # 80004aa6 <fileclose>
    fileclose(wf);
    8000615a:	fc843503          	ld	a0,-56(s0)
    8000615e:	fffff097          	auipc	ra,0xfffff
    80006162:	948080e7          	jalr	-1720(ra) # 80004aa6 <fileclose>
    return -1;
    80006166:	57fd                	li	a5,-1
    80006168:	a03d                	j	80006196 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000616a:	fc442783          	lw	a5,-60(s0)
    8000616e:	0007c763          	bltz	a5,8000617c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006172:	07e9                	addi	a5,a5,26
    80006174:	078e                	slli	a5,a5,0x3
    80006176:	97a6                	add	a5,a5,s1
    80006178:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000617c:	fd043503          	ld	a0,-48(s0)
    80006180:	fffff097          	auipc	ra,0xfffff
    80006184:	926080e7          	jalr	-1754(ra) # 80004aa6 <fileclose>
    fileclose(wf);
    80006188:	fc843503          	ld	a0,-56(s0)
    8000618c:	fffff097          	auipc	ra,0xfffff
    80006190:	91a080e7          	jalr	-1766(ra) # 80004aa6 <fileclose>
    return -1;
    80006194:	57fd                	li	a5,-1
}
    80006196:	853e                	mv	a0,a5
    80006198:	70e2                	ld	ra,56(sp)
    8000619a:	7442                	ld	s0,48(sp)
    8000619c:	74a2                	ld	s1,40(sp)
    8000619e:	6121                	addi	sp,sp,64
    800061a0:	8082                	ret
	...

00000000800061b0 <kernelvec>:
    800061b0:	7111                	addi	sp,sp,-256
    800061b2:	e006                	sd	ra,0(sp)
    800061b4:	e40a                	sd	sp,8(sp)
    800061b6:	e80e                	sd	gp,16(sp)
    800061b8:	ec12                	sd	tp,24(sp)
    800061ba:	f016                	sd	t0,32(sp)
    800061bc:	f41a                	sd	t1,40(sp)
    800061be:	f81e                	sd	t2,48(sp)
    800061c0:	fc22                	sd	s0,56(sp)
    800061c2:	e0a6                	sd	s1,64(sp)
    800061c4:	e4aa                	sd	a0,72(sp)
    800061c6:	e8ae                	sd	a1,80(sp)
    800061c8:	ecb2                	sd	a2,88(sp)
    800061ca:	f0b6                	sd	a3,96(sp)
    800061cc:	f4ba                	sd	a4,104(sp)
    800061ce:	f8be                	sd	a5,112(sp)
    800061d0:	fcc2                	sd	a6,120(sp)
    800061d2:	e146                	sd	a7,128(sp)
    800061d4:	e54a                	sd	s2,136(sp)
    800061d6:	e94e                	sd	s3,144(sp)
    800061d8:	ed52                	sd	s4,152(sp)
    800061da:	f156                	sd	s5,160(sp)
    800061dc:	f55a                	sd	s6,168(sp)
    800061de:	f95e                	sd	s7,176(sp)
    800061e0:	fd62                	sd	s8,184(sp)
    800061e2:	e1e6                	sd	s9,192(sp)
    800061e4:	e5ea                	sd	s10,200(sp)
    800061e6:	e9ee                	sd	s11,208(sp)
    800061e8:	edf2                	sd	t3,216(sp)
    800061ea:	f1f6                	sd	t4,224(sp)
    800061ec:	f5fa                	sd	t5,232(sp)
    800061ee:	f9fe                	sd	t6,240(sp)
    800061f0:	c15fc0ef          	jal	80002e04 <kerneltrap>
    800061f4:	6082                	ld	ra,0(sp)
    800061f6:	6122                	ld	sp,8(sp)
    800061f8:	61c2                	ld	gp,16(sp)
    800061fa:	7282                	ld	t0,32(sp)
    800061fc:	7322                	ld	t1,40(sp)
    800061fe:	73c2                	ld	t2,48(sp)
    80006200:	7462                	ld	s0,56(sp)
    80006202:	6486                	ld	s1,64(sp)
    80006204:	6526                	ld	a0,72(sp)
    80006206:	65c6                	ld	a1,80(sp)
    80006208:	6666                	ld	a2,88(sp)
    8000620a:	7686                	ld	a3,96(sp)
    8000620c:	7726                	ld	a4,104(sp)
    8000620e:	77c6                	ld	a5,112(sp)
    80006210:	7866                	ld	a6,120(sp)
    80006212:	688a                	ld	a7,128(sp)
    80006214:	692a                	ld	s2,136(sp)
    80006216:	69ca                	ld	s3,144(sp)
    80006218:	6a6a                	ld	s4,152(sp)
    8000621a:	7a8a                	ld	s5,160(sp)
    8000621c:	7b2a                	ld	s6,168(sp)
    8000621e:	7bca                	ld	s7,176(sp)
    80006220:	7c6a                	ld	s8,184(sp)
    80006222:	6c8e                	ld	s9,192(sp)
    80006224:	6d2e                	ld	s10,200(sp)
    80006226:	6dce                	ld	s11,208(sp)
    80006228:	6e6e                	ld	t3,216(sp)
    8000622a:	7e8e                	ld	t4,224(sp)
    8000622c:	7f2e                	ld	t5,232(sp)
    8000622e:	7fce                	ld	t6,240(sp)
    80006230:	6111                	addi	sp,sp,256
    80006232:	10200073          	sret
    80006236:	00000013          	nop
    8000623a:	00000013          	nop
    8000623e:	0001                	nop

0000000080006240 <timervec>:
    80006240:	34051573          	csrrw	a0,mscratch,a0
    80006244:	e10c                	sd	a1,0(a0)
    80006246:	e510                	sd	a2,8(a0)
    80006248:	e914                	sd	a3,16(a0)
    8000624a:	6d0c                	ld	a1,24(a0)
    8000624c:	7110                	ld	a2,32(a0)
    8000624e:	6194                	ld	a3,0(a1)
    80006250:	96b2                	add	a3,a3,a2
    80006252:	e194                	sd	a3,0(a1)
    80006254:	4589                	li	a1,2
    80006256:	14459073          	csrw	sip,a1
    8000625a:	6914                	ld	a3,16(a0)
    8000625c:	6510                	ld	a2,8(a0)
    8000625e:	610c                	ld	a1,0(a0)
    80006260:	34051573          	csrrw	a0,mscratch,a0
    80006264:	30200073          	mret
	...

000000008000626a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000626a:	1141                	addi	sp,sp,-16
    8000626c:	e422                	sd	s0,8(sp)
    8000626e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006270:	0c0007b7          	lui	a5,0xc000
    80006274:	4705                	li	a4,1
    80006276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006278:	0c0007b7          	lui	a5,0xc000
    8000627c:	c3d8                	sw	a4,4(a5)
}
    8000627e:	6422                	ld	s0,8(sp)
    80006280:	0141                	addi	sp,sp,16
    80006282:	8082                	ret

0000000080006284 <plicinithart>:

void
plicinithart(void)
{
    80006284:	1141                	addi	sp,sp,-16
    80006286:	e406                	sd	ra,8(sp)
    80006288:	e022                	sd	s0,0(sp)
    8000628a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000628c:	ffffc097          	auipc	ra,0xffffc
    80006290:	988080e7          	jalr	-1656(ra) # 80001c14 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006294:	0085171b          	slliw	a4,a0,0x8
    80006298:	0c0027b7          	lui	a5,0xc002
    8000629c:	97ba                	add	a5,a5,a4
    8000629e:	40200713          	li	a4,1026
    800062a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800062a6:	00d5151b          	slliw	a0,a0,0xd
    800062aa:	0c2017b7          	lui	a5,0xc201
    800062ae:	97aa                	add	a5,a5,a0
    800062b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800062b4:	60a2                	ld	ra,8(sp)
    800062b6:	6402                	ld	s0,0(sp)
    800062b8:	0141                	addi	sp,sp,16
    800062ba:	8082                	ret

00000000800062bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800062bc:	1141                	addi	sp,sp,-16
    800062be:	e406                	sd	ra,8(sp)
    800062c0:	e022                	sd	s0,0(sp)
    800062c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800062c4:	ffffc097          	auipc	ra,0xffffc
    800062c8:	950080e7          	jalr	-1712(ra) # 80001c14 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800062cc:	00d5151b          	slliw	a0,a0,0xd
    800062d0:	0c2017b7          	lui	a5,0xc201
    800062d4:	97aa                	add	a5,a5,a0
  return irq;
}
    800062d6:	43c8                	lw	a0,4(a5)
    800062d8:	60a2                	ld	ra,8(sp)
    800062da:	6402                	ld	s0,0(sp)
    800062dc:	0141                	addi	sp,sp,16
    800062de:	8082                	ret

00000000800062e0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800062e0:	1101                	addi	sp,sp,-32
    800062e2:	ec06                	sd	ra,24(sp)
    800062e4:	e822                	sd	s0,16(sp)
    800062e6:	e426                	sd	s1,8(sp)
    800062e8:	1000                	addi	s0,sp,32
    800062ea:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062ec:	ffffc097          	auipc	ra,0xffffc
    800062f0:	928080e7          	jalr	-1752(ra) # 80001c14 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062f4:	00d5151b          	slliw	a0,a0,0xd
    800062f8:	0c2017b7          	lui	a5,0xc201
    800062fc:	97aa                	add	a5,a5,a0
    800062fe:	c3c4                	sw	s1,4(a5)
}
    80006300:	60e2                	ld	ra,24(sp)
    80006302:	6442                	ld	s0,16(sp)
    80006304:	64a2                	ld	s1,8(sp)
    80006306:	6105                	addi	sp,sp,32
    80006308:	8082                	ret

000000008000630a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000630a:	1141                	addi	sp,sp,-16
    8000630c:	e406                	sd	ra,8(sp)
    8000630e:	e022                	sd	s0,0(sp)
    80006310:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006312:	479d                	li	a5,7
    80006314:	04a7cc63          	blt	a5,a0,8000636c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006318:	0001e797          	auipc	a5,0x1e
    8000631c:	6d878793          	addi	a5,a5,1752 # 800249f0 <disk>
    80006320:	97aa                	add	a5,a5,a0
    80006322:	0187c783          	lbu	a5,24(a5)
    80006326:	ebb9                	bnez	a5,8000637c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006328:	00451693          	slli	a3,a0,0x4
    8000632c:	0001e797          	auipc	a5,0x1e
    80006330:	6c478793          	addi	a5,a5,1732 # 800249f0 <disk>
    80006334:	6398                	ld	a4,0(a5)
    80006336:	9736                	add	a4,a4,a3
    80006338:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000633c:	6398                	ld	a4,0(a5)
    8000633e:	9736                	add	a4,a4,a3
    80006340:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006344:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006348:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000634c:	97aa                	add	a5,a5,a0
    8000634e:	4705                	li	a4,1
    80006350:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006354:	0001e517          	auipc	a0,0x1e
    80006358:	6b450513          	addi	a0,a0,1716 # 80024a08 <disk+0x18>
    8000635c:	ffffc097          	auipc	ra,0xffffc
    80006360:	120080e7          	jalr	288(ra) # 8000247c <wakeup>
}
    80006364:	60a2                	ld	ra,8(sp)
    80006366:	6402                	ld	s0,0(sp)
    80006368:	0141                	addi	sp,sp,16
    8000636a:	8082                	ret
    panic("free_desc 1");
    8000636c:	00002517          	auipc	a0,0x2
    80006370:	3a450513          	addi	a0,a0,932 # 80008710 <etext+0x710>
    80006374:	ffffa097          	auipc	ra,0xffffa
    80006378:	1ec080e7          	jalr	492(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000637c:	00002517          	auipc	a0,0x2
    80006380:	3a450513          	addi	a0,a0,932 # 80008720 <etext+0x720>
    80006384:	ffffa097          	auipc	ra,0xffffa
    80006388:	1dc080e7          	jalr	476(ra) # 80000560 <panic>

000000008000638c <virtio_disk_init>:
{
    8000638c:	1101                	addi	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	e04a                	sd	s2,0(sp)
    80006396:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006398:	00002597          	auipc	a1,0x2
    8000639c:	39858593          	addi	a1,a1,920 # 80008730 <etext+0x730>
    800063a0:	0001e517          	auipc	a0,0x1e
    800063a4:	77850513          	addi	a0,a0,1912 # 80024b18 <disk+0x128>
    800063a8:	ffffb097          	auipc	ra,0xffffb
    800063ac:	800080e7          	jalr	-2048(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063b0:	100017b7          	lui	a5,0x10001
    800063b4:	4398                	lw	a4,0(a5)
    800063b6:	2701                	sext.w	a4,a4
    800063b8:	747277b7          	lui	a5,0x74727
    800063bc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800063c0:	18f71c63          	bne	a4,a5,80006558 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800063c4:	100017b7          	lui	a5,0x10001
    800063c8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800063ca:	439c                	lw	a5,0(a5)
    800063cc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800063ce:	4709                	li	a4,2
    800063d0:	18e79463          	bne	a5,a4,80006558 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063d4:	100017b7          	lui	a5,0x10001
    800063d8:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800063da:	439c                	lw	a5,0(a5)
    800063dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800063de:	16e79d63          	bne	a5,a4,80006558 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800063e2:	100017b7          	lui	a5,0x10001
    800063e6:	47d8                	lw	a4,12(a5)
    800063e8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063ea:	554d47b7          	lui	a5,0x554d4
    800063ee:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800063f2:	16f71363          	bne	a4,a5,80006558 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063f6:	100017b7          	lui	a5,0x10001
    800063fa:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063fe:	4705                	li	a4,1
    80006400:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006402:	470d                	li	a4,3
    80006404:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006406:	10001737          	lui	a4,0x10001
    8000640a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000640c:	c7ffe737          	lui	a4,0xc7ffe
    80006410:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9c2f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006414:	8ef9                	and	a3,a3,a4
    80006416:	10001737          	lui	a4,0x10001
    8000641a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000641c:	472d                	li	a4,11
    8000641e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006420:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006424:	439c                	lw	a5,0(a5)
    80006426:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000642a:	8ba1                	andi	a5,a5,8
    8000642c:	12078e63          	beqz	a5,80006568 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006430:	100017b7          	lui	a5,0x10001
    80006434:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006438:	100017b7          	lui	a5,0x10001
    8000643c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006440:	439c                	lw	a5,0(a5)
    80006442:	2781                	sext.w	a5,a5
    80006444:	12079a63          	bnez	a5,80006578 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006448:	100017b7          	lui	a5,0x10001
    8000644c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006450:	439c                	lw	a5,0(a5)
    80006452:	2781                	sext.w	a5,a5
  if(max == 0)
    80006454:	12078a63          	beqz	a5,80006588 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006458:	471d                	li	a4,7
    8000645a:	12f77f63          	bgeu	a4,a5,80006598 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000645e:	ffffa097          	auipc	ra,0xffffa
    80006462:	6ea080e7          	jalr	1770(ra) # 80000b48 <kalloc>
    80006466:	0001e497          	auipc	s1,0x1e
    8000646a:	58a48493          	addi	s1,s1,1418 # 800249f0 <disk>
    8000646e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006470:	ffffa097          	auipc	ra,0xffffa
    80006474:	6d8080e7          	jalr	1752(ra) # 80000b48 <kalloc>
    80006478:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000647a:	ffffa097          	auipc	ra,0xffffa
    8000647e:	6ce080e7          	jalr	1742(ra) # 80000b48 <kalloc>
    80006482:	87aa                	mv	a5,a0
    80006484:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006486:	6088                	ld	a0,0(s1)
    80006488:	12050063          	beqz	a0,800065a8 <virtio_disk_init+0x21c>
    8000648c:	0001e717          	auipc	a4,0x1e
    80006490:	56c73703          	ld	a4,1388(a4) # 800249f8 <disk+0x8>
    80006494:	10070a63          	beqz	a4,800065a8 <virtio_disk_init+0x21c>
    80006498:	10078863          	beqz	a5,800065a8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000649c:	6605                	lui	a2,0x1
    8000649e:	4581                	li	a1,0
    800064a0:	ffffb097          	auipc	ra,0xffffb
    800064a4:	894080e7          	jalr	-1900(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    800064a8:	0001e497          	auipc	s1,0x1e
    800064ac:	54848493          	addi	s1,s1,1352 # 800249f0 <disk>
    800064b0:	6605                	lui	a2,0x1
    800064b2:	4581                	li	a1,0
    800064b4:	6488                	ld	a0,8(s1)
    800064b6:	ffffb097          	auipc	ra,0xffffb
    800064ba:	87e080e7          	jalr	-1922(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    800064be:	6605                	lui	a2,0x1
    800064c0:	4581                	li	a1,0
    800064c2:	6888                	ld	a0,16(s1)
    800064c4:	ffffb097          	auipc	ra,0xffffb
    800064c8:	870080e7          	jalr	-1936(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800064cc:	100017b7          	lui	a5,0x10001
    800064d0:	4721                	li	a4,8
    800064d2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800064d4:	4098                	lw	a4,0(s1)
    800064d6:	100017b7          	lui	a5,0x10001
    800064da:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800064de:	40d8                	lw	a4,4(s1)
    800064e0:	100017b7          	lui	a5,0x10001
    800064e4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800064e8:	649c                	ld	a5,8(s1)
    800064ea:	0007869b          	sext.w	a3,a5
    800064ee:	10001737          	lui	a4,0x10001
    800064f2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800064f6:	9781                	srai	a5,a5,0x20
    800064f8:	10001737          	lui	a4,0x10001
    800064fc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006500:	689c                	ld	a5,16(s1)
    80006502:	0007869b          	sext.w	a3,a5
    80006506:	10001737          	lui	a4,0x10001
    8000650a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000650e:	9781                	srai	a5,a5,0x20
    80006510:	10001737          	lui	a4,0x10001
    80006514:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006518:	10001737          	lui	a4,0x10001
    8000651c:	4785                	li	a5,1
    8000651e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006520:	00f48c23          	sb	a5,24(s1)
    80006524:	00f48ca3          	sb	a5,25(s1)
    80006528:	00f48d23          	sb	a5,26(s1)
    8000652c:	00f48da3          	sb	a5,27(s1)
    80006530:	00f48e23          	sb	a5,28(s1)
    80006534:	00f48ea3          	sb	a5,29(s1)
    80006538:	00f48f23          	sb	a5,30(s1)
    8000653c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006540:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006544:	100017b7          	lui	a5,0x10001
    80006548:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000654c:	60e2                	ld	ra,24(sp)
    8000654e:	6442                	ld	s0,16(sp)
    80006550:	64a2                	ld	s1,8(sp)
    80006552:	6902                	ld	s2,0(sp)
    80006554:	6105                	addi	sp,sp,32
    80006556:	8082                	ret
    panic("could not find virtio disk");
    80006558:	00002517          	auipc	a0,0x2
    8000655c:	1e850513          	addi	a0,a0,488 # 80008740 <etext+0x740>
    80006560:	ffffa097          	auipc	ra,0xffffa
    80006564:	000080e7          	jalr	ra # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006568:	00002517          	auipc	a0,0x2
    8000656c:	1f850513          	addi	a0,a0,504 # 80008760 <etext+0x760>
    80006570:	ffffa097          	auipc	ra,0xffffa
    80006574:	ff0080e7          	jalr	-16(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006578:	00002517          	auipc	a0,0x2
    8000657c:	20850513          	addi	a0,a0,520 # 80008780 <etext+0x780>
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	fe0080e7          	jalr	-32(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006588:	00002517          	auipc	a0,0x2
    8000658c:	21850513          	addi	a0,a0,536 # 800087a0 <etext+0x7a0>
    80006590:	ffffa097          	auipc	ra,0xffffa
    80006594:	fd0080e7          	jalr	-48(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006598:	00002517          	auipc	a0,0x2
    8000659c:	22850513          	addi	a0,a0,552 # 800087c0 <etext+0x7c0>
    800065a0:	ffffa097          	auipc	ra,0xffffa
    800065a4:	fc0080e7          	jalr	-64(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800065a8:	00002517          	auipc	a0,0x2
    800065ac:	23850513          	addi	a0,a0,568 # 800087e0 <etext+0x7e0>
    800065b0:	ffffa097          	auipc	ra,0xffffa
    800065b4:	fb0080e7          	jalr	-80(ra) # 80000560 <panic>

00000000800065b8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800065b8:	7159                	addi	sp,sp,-112
    800065ba:	f486                	sd	ra,104(sp)
    800065bc:	f0a2                	sd	s0,96(sp)
    800065be:	eca6                	sd	s1,88(sp)
    800065c0:	e8ca                	sd	s2,80(sp)
    800065c2:	e4ce                	sd	s3,72(sp)
    800065c4:	e0d2                	sd	s4,64(sp)
    800065c6:	fc56                	sd	s5,56(sp)
    800065c8:	f85a                	sd	s6,48(sp)
    800065ca:	f45e                	sd	s7,40(sp)
    800065cc:	f062                	sd	s8,32(sp)
    800065ce:	ec66                	sd	s9,24(sp)
    800065d0:	1880                	addi	s0,sp,112
    800065d2:	8a2a                	mv	s4,a0
    800065d4:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800065d6:	00c52c83          	lw	s9,12(a0)
    800065da:	001c9c9b          	slliw	s9,s9,0x1
    800065de:	1c82                	slli	s9,s9,0x20
    800065e0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800065e4:	0001e517          	auipc	a0,0x1e
    800065e8:	53450513          	addi	a0,a0,1332 # 80024b18 <disk+0x128>
    800065ec:	ffffa097          	auipc	ra,0xffffa
    800065f0:	64c080e7          	jalr	1612(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    800065f4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800065f6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800065f8:	0001eb17          	auipc	s6,0x1e
    800065fc:	3f8b0b13          	addi	s6,s6,1016 # 800249f0 <disk>
  for(int i = 0; i < 3; i++){
    80006600:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006602:	0001ec17          	auipc	s8,0x1e
    80006606:	516c0c13          	addi	s8,s8,1302 # 80024b18 <disk+0x128>
    8000660a:	a0ad                	j	80006674 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000660c:	00fb0733          	add	a4,s6,a5
    80006610:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006614:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006616:	0207c563          	bltz	a5,80006640 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000661a:	2905                	addiw	s2,s2,1
    8000661c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000661e:	05590f63          	beq	s2,s5,8000667c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006622:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006624:	0001e717          	auipc	a4,0x1e
    80006628:	3cc70713          	addi	a4,a4,972 # 800249f0 <disk>
    8000662c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000662e:	01874683          	lbu	a3,24(a4)
    80006632:	fee9                	bnez	a3,8000660c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006634:	2785                	addiw	a5,a5,1
    80006636:	0705                	addi	a4,a4,1
    80006638:	fe979be3          	bne	a5,s1,8000662e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000663c:	57fd                	li	a5,-1
    8000663e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006640:	03205163          	blez	s2,80006662 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006644:	f9042503          	lw	a0,-112(s0)
    80006648:	00000097          	auipc	ra,0x0
    8000664c:	cc2080e7          	jalr	-830(ra) # 8000630a <free_desc>
      for(int j = 0; j < i; j++)
    80006650:	4785                	li	a5,1
    80006652:	0127d863          	bge	a5,s2,80006662 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006656:	f9442503          	lw	a0,-108(s0)
    8000665a:	00000097          	auipc	ra,0x0
    8000665e:	cb0080e7          	jalr	-848(ra) # 8000630a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006662:	85e2                	mv	a1,s8
    80006664:	0001e517          	auipc	a0,0x1e
    80006668:	3a450513          	addi	a0,a0,932 # 80024a08 <disk+0x18>
    8000666c:	ffffc097          	auipc	ra,0xffffc
    80006670:	dac080e7          	jalr	-596(ra) # 80002418 <sleep>
  for(int i = 0; i < 3; i++){
    80006674:	f9040613          	addi	a2,s0,-112
    80006678:	894e                	mv	s2,s3
    8000667a:	b765                	j	80006622 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000667c:	f9042503          	lw	a0,-112(s0)
    80006680:	00451693          	slli	a3,a0,0x4

  if(write)
    80006684:	0001e797          	auipc	a5,0x1e
    80006688:	36c78793          	addi	a5,a5,876 # 800249f0 <disk>
    8000668c:	00a50713          	addi	a4,a0,10
    80006690:	0712                	slli	a4,a4,0x4
    80006692:	973e                	add	a4,a4,a5
    80006694:	01703633          	snez	a2,s7
    80006698:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000669a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000669e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800066a2:	6398                	ld	a4,0(a5)
    800066a4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800066a6:	0a868613          	addi	a2,a3,168
    800066aa:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800066ac:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800066ae:	6390                	ld	a2,0(a5)
    800066b0:	00d605b3          	add	a1,a2,a3
    800066b4:	4741                	li	a4,16
    800066b6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800066b8:	4805                	li	a6,1
    800066ba:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800066be:	f9442703          	lw	a4,-108(s0)
    800066c2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800066c6:	0712                	slli	a4,a4,0x4
    800066c8:	963a                	add	a2,a2,a4
    800066ca:	058a0593          	addi	a1,s4,88
    800066ce:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800066d0:	0007b883          	ld	a7,0(a5)
    800066d4:	9746                	add	a4,a4,a7
    800066d6:	40000613          	li	a2,1024
    800066da:	c710                	sw	a2,8(a4)
  if(write)
    800066dc:	001bb613          	seqz	a2,s7
    800066e0:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800066e4:	00166613          	ori	a2,a2,1
    800066e8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800066ec:	f9842583          	lw	a1,-104(s0)
    800066f0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800066f4:	00250613          	addi	a2,a0,2
    800066f8:	0612                	slli	a2,a2,0x4
    800066fa:	963e                	add	a2,a2,a5
    800066fc:	577d                	li	a4,-1
    800066fe:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006702:	0592                	slli	a1,a1,0x4
    80006704:	98ae                	add	a7,a7,a1
    80006706:	03068713          	addi	a4,a3,48
    8000670a:	973e                	add	a4,a4,a5
    8000670c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006710:	6398                	ld	a4,0(a5)
    80006712:	972e                	add	a4,a4,a1
    80006714:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006718:	4689                	li	a3,2
    8000671a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000671e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006722:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006726:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000672a:	6794                	ld	a3,8(a5)
    8000672c:	0026d703          	lhu	a4,2(a3)
    80006730:	8b1d                	andi	a4,a4,7
    80006732:	0706                	slli	a4,a4,0x1
    80006734:	96ba                	add	a3,a3,a4
    80006736:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000673a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000673e:	6798                	ld	a4,8(a5)
    80006740:	00275783          	lhu	a5,2(a4)
    80006744:	2785                	addiw	a5,a5,1
    80006746:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000674a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000674e:	100017b7          	lui	a5,0x10001
    80006752:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006756:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000675a:	0001e917          	auipc	s2,0x1e
    8000675e:	3be90913          	addi	s2,s2,958 # 80024b18 <disk+0x128>
  while(b->disk == 1) {
    80006762:	4485                	li	s1,1
    80006764:	01079c63          	bne	a5,a6,8000677c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006768:	85ca                	mv	a1,s2
    8000676a:	8552                	mv	a0,s4
    8000676c:	ffffc097          	auipc	ra,0xffffc
    80006770:	cac080e7          	jalr	-852(ra) # 80002418 <sleep>
  while(b->disk == 1) {
    80006774:	004a2783          	lw	a5,4(s4)
    80006778:	fe9788e3          	beq	a5,s1,80006768 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000677c:	f9042903          	lw	s2,-112(s0)
    80006780:	00290713          	addi	a4,s2,2
    80006784:	0712                	slli	a4,a4,0x4
    80006786:	0001e797          	auipc	a5,0x1e
    8000678a:	26a78793          	addi	a5,a5,618 # 800249f0 <disk>
    8000678e:	97ba                	add	a5,a5,a4
    80006790:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006794:	0001e997          	auipc	s3,0x1e
    80006798:	25c98993          	addi	s3,s3,604 # 800249f0 <disk>
    8000679c:	00491713          	slli	a4,s2,0x4
    800067a0:	0009b783          	ld	a5,0(s3)
    800067a4:	97ba                	add	a5,a5,a4
    800067a6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800067aa:	854a                	mv	a0,s2
    800067ac:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800067b0:	00000097          	auipc	ra,0x0
    800067b4:	b5a080e7          	jalr	-1190(ra) # 8000630a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800067b8:	8885                	andi	s1,s1,1
    800067ba:	f0ed                	bnez	s1,8000679c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800067bc:	0001e517          	auipc	a0,0x1e
    800067c0:	35c50513          	addi	a0,a0,860 # 80024b18 <disk+0x128>
    800067c4:	ffffa097          	auipc	ra,0xffffa
    800067c8:	528080e7          	jalr	1320(ra) # 80000cec <release>
}
    800067cc:	70a6                	ld	ra,104(sp)
    800067ce:	7406                	ld	s0,96(sp)
    800067d0:	64e6                	ld	s1,88(sp)
    800067d2:	6946                	ld	s2,80(sp)
    800067d4:	69a6                	ld	s3,72(sp)
    800067d6:	6a06                	ld	s4,64(sp)
    800067d8:	7ae2                	ld	s5,56(sp)
    800067da:	7b42                	ld	s6,48(sp)
    800067dc:	7ba2                	ld	s7,40(sp)
    800067de:	7c02                	ld	s8,32(sp)
    800067e0:	6ce2                	ld	s9,24(sp)
    800067e2:	6165                	addi	sp,sp,112
    800067e4:	8082                	ret

00000000800067e6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800067e6:	1101                	addi	sp,sp,-32
    800067e8:	ec06                	sd	ra,24(sp)
    800067ea:	e822                	sd	s0,16(sp)
    800067ec:	e426                	sd	s1,8(sp)
    800067ee:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800067f0:	0001e497          	auipc	s1,0x1e
    800067f4:	20048493          	addi	s1,s1,512 # 800249f0 <disk>
    800067f8:	0001e517          	auipc	a0,0x1e
    800067fc:	32050513          	addi	a0,a0,800 # 80024b18 <disk+0x128>
    80006800:	ffffa097          	auipc	ra,0xffffa
    80006804:	438080e7          	jalr	1080(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006808:	100017b7          	lui	a5,0x10001
    8000680c:	53b8                	lw	a4,96(a5)
    8000680e:	8b0d                	andi	a4,a4,3
    80006810:	100017b7          	lui	a5,0x10001
    80006814:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006816:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000681a:	689c                	ld	a5,16(s1)
    8000681c:	0204d703          	lhu	a4,32(s1)
    80006820:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006824:	04f70863          	beq	a4,a5,80006874 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006828:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000682c:	6898                	ld	a4,16(s1)
    8000682e:	0204d783          	lhu	a5,32(s1)
    80006832:	8b9d                	andi	a5,a5,7
    80006834:	078e                	slli	a5,a5,0x3
    80006836:	97ba                	add	a5,a5,a4
    80006838:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000683a:	00278713          	addi	a4,a5,2
    8000683e:	0712                	slli	a4,a4,0x4
    80006840:	9726                	add	a4,a4,s1
    80006842:	01074703          	lbu	a4,16(a4)
    80006846:	e721                	bnez	a4,8000688e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006848:	0789                	addi	a5,a5,2
    8000684a:	0792                	slli	a5,a5,0x4
    8000684c:	97a6                	add	a5,a5,s1
    8000684e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006850:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006854:	ffffc097          	auipc	ra,0xffffc
    80006858:	c28080e7          	jalr	-984(ra) # 8000247c <wakeup>

    disk.used_idx += 1;
    8000685c:	0204d783          	lhu	a5,32(s1)
    80006860:	2785                	addiw	a5,a5,1
    80006862:	17c2                	slli	a5,a5,0x30
    80006864:	93c1                	srli	a5,a5,0x30
    80006866:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000686a:	6898                	ld	a4,16(s1)
    8000686c:	00275703          	lhu	a4,2(a4)
    80006870:	faf71ce3          	bne	a4,a5,80006828 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006874:	0001e517          	auipc	a0,0x1e
    80006878:	2a450513          	addi	a0,a0,676 # 80024b18 <disk+0x128>
    8000687c:	ffffa097          	auipc	ra,0xffffa
    80006880:	470080e7          	jalr	1136(ra) # 80000cec <release>
}
    80006884:	60e2                	ld	ra,24(sp)
    80006886:	6442                	ld	s0,16(sp)
    80006888:	64a2                	ld	s1,8(sp)
    8000688a:	6105                	addi	sp,sp,32
    8000688c:	8082                	ret
      panic("virtio_disk_intr status");
    8000688e:	00002517          	auipc	a0,0x2
    80006892:	f6a50513          	addi	a0,a0,-150 # 800087f8 <etext+0x7f8>
    80006896:	ffffa097          	auipc	ra,0xffffa
    8000689a:	cca080e7          	jalr	-822(ra) # 80000560 <panic>
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
