
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	5f013103          	ld	sp,1520(sp) # 8000b5f0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    asm volatile("csrr %0, mhartid" : "=r"(x));
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
    80000054:	61070713          	addi	a4,a4,1552 # 8000b660 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void
w_mscratch(uint64 x)
{
    asm volatile("csrw mscratch, %0" : : "r"(x));
    8000005e:	34071073          	csrw	mscratch,a4
    asm volatile("csrw mtvec, %0" : : "r"(x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	55e78793          	addi	a5,a5,1374 # 800065c0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    80000076:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
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
    asm volatile("csrr %0, mstatus" : "=r"(x));
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb9d17>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000a8:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	0f478793          	addi	a5,a5,244 # 800011a0 <main>
    800000b4:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c6:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    800000d2:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
    asm volatile("mv tp, %0" : : "r"(x));
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
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	8ee080e7          	jalr	-1810(ra) # 80002a18 <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
            break;
        uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7f6080e7          	jalr	2038(ra) # 80000930 <uartputc>
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
    80000190:	61450513          	addi	a0,a0,1556 # 800137a0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	d72080e7          	jalr	-654(ra) # 80000f06 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	60448493          	addi	s1,s1,1540 # 800137a0 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	69490913          	addi	s2,s2,1684 # 80013838 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	c4c080e7          	jalr	-948(ra) # 80001e08 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	69e080e7          	jalr	1694(ra) # 80002862 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	3e8080e7          	jalr	1000(ra) # 800025ba <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	5b870713          	addi	a4,a4,1464 # 800137a0 <cons>
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
    8000021e:	7a8080e7          	jalr	1960(ra) # 800029c2 <either_copyout>
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
    8000023a:	56a50513          	addi	a0,a0,1386 # 800137a0 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	d7c080e7          	jalr	-644(ra) # 80000fba <release>
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
    80000268:	5cf72a23          	sw	a5,1492(a4) # 80013838 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	52650513          	addi	a0,a0,1318 # 800137a0 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	d38080e7          	jalr	-712(ra) # 80000fba <release>
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
    800002a8:	5ae080e7          	jalr	1454(ra) # 80000852 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
        uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	59c080e7          	jalr	1436(ra) # 80000852 <uartputc_sync>
        uartputc_sync(' ');
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	590080e7          	jalr	1424(ra) # 80000852 <uartputc_sync>
        uartputc_sync('\b');
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	586080e7          	jalr	1414(ra) # 80000852 <uartputc_sync>
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
    800002e6:	4be50513          	addi	a0,a0,1214 # 800137a0 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	c1c080e7          	jalr	-996(ra) # 80000f06 <acquire>

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
    8000030c:	766080e7          	jalr	1894(ra) # 80002a6e <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	49050513          	addi	a0,a0,1168 # 800137a0 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	ca2080e7          	jalr	-862(ra) # 80000fba <release>
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
    80000336:	46e70713          	addi	a4,a4,1134 # 800137a0 <cons>
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
    80000360:	44478793          	addi	a5,a5,1092 # 800137a0 <cons>
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
    8000038e:	4ae7a783          	lw	a5,1198(a5) # 80013838 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	40070713          	addi	a4,a4,1024 # 800137a0 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	3f048493          	addi	s1,s1,1008 # 800137a0 <cons>
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
    800003fa:	3aa70713          	addi	a4,a4,938 # 800137a0 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	42f72a23          	sw	a5,1076(a4) # 80013840 <cons+0xa0>
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
    80000436:	36e78793          	addi	a5,a5,878 # 800137a0 <cons>
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
    8000045a:	3ec7a323          	sw	a2,998(a5) # 8001383c <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	3da50513          	addi	a0,a0,986 # 80013838 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	1b8080e7          	jalr	440(ra) # 8000261e <wakeup>
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
    8000047c:	b9858593          	addi	a1,a1,-1128 # 80008010 <__func__.1+0x8>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	32050513          	addi	a0,a0,800 # 800137a0 <cons>
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	9ee080e7          	jalr	-1554(ra) # 80000e76 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	366080e7          	jalr	870(ra) # 800007f6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00043797          	auipc	a5,0x43
    8000049c:	4b878793          	addi	a5,a5,1208 # 80043950 <devsw>
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

    if (sign && (sign = xx < 0))
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
    do
    {
        buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	39260613          	addi	a2,a2,914 # 80008868 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

    if (sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
        buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

    while (--i >= 0)
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
    while (--i >= 0)
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
    if (sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
        x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    if (locking)
        release(&pr.lock);
}

void panic(char *s, ...)
{
    80000560:	711d                	addi	sp,sp,-96
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
    8000056c:	e40c                	sd	a1,8(s0)
    8000056e:	e810                	sd	a2,16(s0)
    80000570:	ec14                	sd	a3,24(s0)
    80000572:	f018                	sd	a4,32(s0)
    80000574:	f41c                	sd	a5,40(s0)
    80000576:	03043823          	sd	a6,48(s0)
    8000057a:	03143c23          	sd	a7,56(s0)
    pr.locking = 0;
    8000057e:	00013797          	auipc	a5,0x13
    80000582:	2e07a123          	sw	zero,738(a5) # 80013860 <pr+0x18>
    printf("panic: ");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	a9250513          	addi	a0,a0,-1390 # 80008018 <__func__.1+0x10>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	02e080e7          	jalr	46(ra) # 800005bc <printf>
    printf(s);
    80000596:	8526                	mv	a0,s1
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	024080e7          	jalr	36(ra) # 800005bc <printf>
    printf("\n");
    800005a0:	00008517          	auipc	a0,0x8
    800005a4:	a8050513          	addi	a0,a0,-1408 # 80008020 <__func__.1+0x18>
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	014080e7          	jalr	20(ra) # 800005bc <printf>
    panicked = 1; // freeze uart output from other CPUs
    800005b0:	4785                	li	a5,1
    800005b2:	0000b717          	auipc	a4,0xb
    800005b6:	04f72f23          	sw	a5,94(a4) # 8000b610 <panicked>
    for (;;)
    800005ba:	a001                	j	800005ba <panic+0x5a>

00000000800005bc <printf>:
{
    800005bc:	7131                	addi	sp,sp,-192
    800005be:	fc86                	sd	ra,120(sp)
    800005c0:	f8a2                	sd	s0,112(sp)
    800005c2:	e8d2                	sd	s4,80(sp)
    800005c4:	f06a                	sd	s10,32(sp)
    800005c6:	0100                	addi	s0,sp,128
    800005c8:	8a2a                	mv	s4,a0
    800005ca:	e40c                	sd	a1,8(s0)
    800005cc:	e810                	sd	a2,16(s0)
    800005ce:	ec14                	sd	a3,24(s0)
    800005d0:	f018                	sd	a4,32(s0)
    800005d2:	f41c                	sd	a5,40(s0)
    800005d4:	03043823          	sd	a6,48(s0)
    800005d8:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    800005dc:	00013d17          	auipc	s10,0x13
    800005e0:	284d2d03          	lw	s10,644(s10) # 80013860 <pr+0x18>
    if (locking)
    800005e4:	040d1463          	bnez	s10,8000062c <printf+0x70>
    if (fmt == 0)
    800005e8:	040a0b63          	beqz	s4,8000063e <printf+0x82>
    va_start(ap, fmt);
    800005ec:	00840793          	addi	a5,s0,8
    800005f0:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005f4:	000a4503          	lbu	a0,0(s4)
    800005f8:	18050b63          	beqz	a0,8000078e <printf+0x1d2>
    800005fc:	f4a6                	sd	s1,104(sp)
    800005fe:	f0ca                	sd	s2,96(sp)
    80000600:	ecce                	sd	s3,88(sp)
    80000602:	e4d6                	sd	s5,72(sp)
    80000604:	e0da                	sd	s6,64(sp)
    80000606:	fc5e                	sd	s7,56(sp)
    80000608:	f862                	sd	s8,48(sp)
    8000060a:	f466                	sd	s9,40(sp)
    8000060c:	ec6e                	sd	s11,24(sp)
    8000060e:	4981                	li	s3,0
        if (c != '%')
    80000610:	02500b13          	li	s6,37
        switch (c)
    80000614:	07000b93          	li	s7,112
    consputc('x');
    80000618:	4cc1                	li	s9,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000061a:	00008a97          	auipc	s5,0x8
    8000061e:	24ea8a93          	addi	s5,s5,590 # 80008868 <digits>
        switch (c)
    80000622:	07300c13          	li	s8,115
    80000626:	06400d93          	li	s11,100
    8000062a:	a0b1                	j	80000676 <printf+0xba>
        acquire(&pr.lock);
    8000062c:	00013517          	auipc	a0,0x13
    80000630:	21c50513          	addi	a0,a0,540 # 80013848 <pr>
    80000634:	00001097          	auipc	ra,0x1
    80000638:	8d2080e7          	jalr	-1838(ra) # 80000f06 <acquire>
    8000063c:	b775                	j	800005e8 <printf+0x2c>
    8000063e:	f4a6                	sd	s1,104(sp)
    80000640:	f0ca                	sd	s2,96(sp)
    80000642:	ecce                	sd	s3,88(sp)
    80000644:	e4d6                	sd	s5,72(sp)
    80000646:	e0da                	sd	s6,64(sp)
    80000648:	fc5e                	sd	s7,56(sp)
    8000064a:	f862                	sd	s8,48(sp)
    8000064c:	f466                	sd	s9,40(sp)
    8000064e:	ec6e                	sd	s11,24(sp)
        panic("null fmt");
    80000650:	00008517          	auipc	a0,0x8
    80000654:	9e050513          	addi	a0,a0,-1568 # 80008030 <__func__.1+0x28>
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f08080e7          	jalr	-248(ra) # 80000560 <panic>
            consputc(c);
    80000660:	00000097          	auipc	ra,0x0
    80000664:	c34080e7          	jalr	-972(ra) # 80000294 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c503          	lbu	a0,0(a5)
    80000672:	10050563          	beqz	a0,8000077c <printf+0x1c0>
        if (c != '%')
    80000676:	ff6515e3          	bne	a0,s6,80000660 <printf+0xa4>
        c = fmt[++i] & 0xff;
    8000067a:	2985                	addiw	s3,s3,1
    8000067c:	013a07b3          	add	a5,s4,s3
    80000680:	0007c783          	lbu	a5,0(a5)
    80000684:	0007849b          	sext.w	s1,a5
        if (c == 0)
    80000688:	10078b63          	beqz	a5,8000079e <printf+0x1e2>
        switch (c)
    8000068c:	05778a63          	beq	a5,s7,800006e0 <printf+0x124>
    80000690:	02fbf663          	bgeu	s7,a5,800006bc <printf+0x100>
    80000694:	09878863          	beq	a5,s8,80000724 <printf+0x168>
    80000698:	07800713          	li	a4,120
    8000069c:	0ce79563          	bne	a5,a4,80000766 <printf+0x1aa>
            printint(va_arg(ap, int), 16, 1);
    800006a0:	f8843783          	ld	a5,-120(s0)
    800006a4:	00878713          	addi	a4,a5,8
    800006a8:	f8e43423          	sd	a4,-120(s0)
    800006ac:	4605                	li	a2,1
    800006ae:	85e6                	mv	a1,s9
    800006b0:	4388                	lw	a0,0(a5)
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	e0a080e7          	jalr	-502(ra) # 800004bc <printint>
            break;
    800006ba:	b77d                	j	80000668 <printf+0xac>
        switch (c)
    800006bc:	09678f63          	beq	a5,s6,8000075a <printf+0x19e>
    800006c0:	0bb79363          	bne	a5,s11,80000766 <printf+0x1aa>
            printint(va_arg(ap, int), 10, 1);
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	4605                	li	a2,1
    800006d2:	45a9                	li	a1,10
    800006d4:	4388                	lw	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	de6080e7          	jalr	-538(ra) # 800004bc <printint>
            break;
    800006de:	b769                	j	80000668 <printf+0xac>
            printptr(va_arg(ap, uint64));
    800006e0:	f8843783          	ld	a5,-120(s0)
    800006e4:	00878713          	addi	a4,a5,8
    800006e8:	f8e43423          	sd	a4,-120(s0)
    800006ec:	0007b903          	ld	s2,0(a5)
    consputc('0');
    800006f0:	03000513          	li	a0,48
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	ba0080e7          	jalr	-1120(ra) # 80000294 <consputc>
    consputc('x');
    800006fc:	07800513          	li	a0,120
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b94080e7          	jalr	-1132(ra) # 80000294 <consputc>
    80000708:	84e6                	mv	s1,s9
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000070a:	03c95793          	srli	a5,s2,0x3c
    8000070e:	97d6                	add	a5,a5,s5
    80000710:	0007c503          	lbu	a0,0(a5)
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b80080e7          	jalr	-1152(ra) # 80000294 <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000071c:	0912                	slli	s2,s2,0x4
    8000071e:	34fd                	addiw	s1,s1,-1
    80000720:	f4ed                	bnez	s1,8000070a <printf+0x14e>
    80000722:	b799                	j	80000668 <printf+0xac>
            if ((s = va_arg(ap, char *)) == 0)
    80000724:	f8843783          	ld	a5,-120(s0)
    80000728:	00878713          	addi	a4,a5,8
    8000072c:	f8e43423          	sd	a4,-120(s0)
    80000730:	6384                	ld	s1,0(a5)
    80000732:	cc89                	beqz	s1,8000074c <printf+0x190>
            for (; *s; s++)
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	d905                	beqz	a0,80000668 <printf+0xac>
                consputc(*s);
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b5a080e7          	jalr	-1190(ra) # 80000294 <consputc>
            for (; *s; s++)
    80000742:	0485                	addi	s1,s1,1
    80000744:	0004c503          	lbu	a0,0(s1)
    80000748:	f96d                	bnez	a0,8000073a <printf+0x17e>
    8000074a:	bf39                	j	80000668 <printf+0xac>
                s = "(null)";
    8000074c:	00008497          	auipc	s1,0x8
    80000750:	8dc48493          	addi	s1,s1,-1828 # 80008028 <__func__.1+0x20>
            for (; *s; s++)
    80000754:	02800513          	li	a0,40
    80000758:	b7cd                	j	8000073a <printf+0x17e>
            consputc('%');
    8000075a:	855a                	mv	a0,s6
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	b38080e7          	jalr	-1224(ra) # 80000294 <consputc>
            break;
    80000764:	b711                	j	80000668 <printf+0xac>
            consputc('%');
    80000766:	855a                	mv	a0,s6
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	b2c080e7          	jalr	-1236(ra) # 80000294 <consputc>
            consputc(c);
    80000770:	8526                	mv	a0,s1
    80000772:	00000097          	auipc	ra,0x0
    80000776:	b22080e7          	jalr	-1246(ra) # 80000294 <consputc>
            break;
    8000077a:	b5fd                	j	80000668 <printf+0xac>
    8000077c:	74a6                	ld	s1,104(sp)
    8000077e:	7906                	ld	s2,96(sp)
    80000780:	69e6                	ld	s3,88(sp)
    80000782:	6aa6                	ld	s5,72(sp)
    80000784:	6b06                	ld	s6,64(sp)
    80000786:	7be2                	ld	s7,56(sp)
    80000788:	7c42                	ld	s8,48(sp)
    8000078a:	7ca2                	ld	s9,40(sp)
    8000078c:	6de2                	ld	s11,24(sp)
    if (locking)
    8000078e:	020d1263          	bnez	s10,800007b2 <printf+0x1f6>
}
    80000792:	70e6                	ld	ra,120(sp)
    80000794:	7446                	ld	s0,112(sp)
    80000796:	6a46                	ld	s4,80(sp)
    80000798:	7d02                	ld	s10,32(sp)
    8000079a:	6129                	addi	sp,sp,192
    8000079c:	8082                	ret
    8000079e:	74a6                	ld	s1,104(sp)
    800007a0:	7906                	ld	s2,96(sp)
    800007a2:	69e6                	ld	s3,88(sp)
    800007a4:	6aa6                	ld	s5,72(sp)
    800007a6:	6b06                	ld	s6,64(sp)
    800007a8:	7be2                	ld	s7,56(sp)
    800007aa:	7c42                	ld	s8,48(sp)
    800007ac:	7ca2                	ld	s9,40(sp)
    800007ae:	6de2                	ld	s11,24(sp)
    800007b0:	bff9                	j	8000078e <printf+0x1d2>
        release(&pr.lock);
    800007b2:	00013517          	auipc	a0,0x13
    800007b6:	09650513          	addi	a0,a0,150 # 80013848 <pr>
    800007ba:	00001097          	auipc	ra,0x1
    800007be:	800080e7          	jalr	-2048(ra) # 80000fba <release>
}
    800007c2:	bfc1                	j	80000792 <printf+0x1d6>

00000000800007c4 <printfinit>:
        ;
}

void printfinit(void)
{
    800007c4:	1101                	addi	sp,sp,-32
    800007c6:	ec06                	sd	ra,24(sp)
    800007c8:	e822                	sd	s0,16(sp)
    800007ca:	e426                	sd	s1,8(sp)
    800007cc:	1000                	addi	s0,sp,32
    initlock(&pr.lock, "pr");
    800007ce:	00013497          	auipc	s1,0x13
    800007d2:	07a48493          	addi	s1,s1,122 # 80013848 <pr>
    800007d6:	00008597          	auipc	a1,0x8
    800007da:	86a58593          	addi	a1,a1,-1942 # 80008040 <__func__.1+0x38>
    800007de:	8526                	mv	a0,s1
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	696080e7          	jalr	1686(ra) # 80000e76 <initlock>
    pr.locking = 1;
    800007e8:	4785                	li	a5,1
    800007ea:	cc9c                	sw	a5,24(s1)
}
    800007ec:	60e2                	ld	ra,24(sp)
    800007ee:	6442                	ld	s0,16(sp)
    800007f0:	64a2                	ld	s1,8(sp)
    800007f2:	6105                	addi	sp,sp,32
    800007f4:	8082                	ret

00000000800007f6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007f6:	1141                	addi	sp,sp,-16
    800007f8:	e406                	sd	ra,8(sp)
    800007fa:	e022                	sd	s0,0(sp)
    800007fc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007fe:	100007b7          	lui	a5,0x10000
    80000802:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000806:	10000737          	lui	a4,0x10000
    8000080a:	f8000693          	li	a3,-128
    8000080e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000812:	468d                	li	a3,3
    80000814:	10000637          	lui	a2,0x10000
    80000818:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000081c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000820:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000824:	10000737          	lui	a4,0x10000
    80000828:	461d                	li	a2,7
    8000082a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000832:	00008597          	auipc	a1,0x8
    80000836:	81658593          	addi	a1,a1,-2026 # 80008048 <__func__.1+0x40>
    8000083a:	00013517          	auipc	a0,0x13
    8000083e:	02e50513          	addi	a0,a0,46 # 80013868 <uart_tx_lock>
    80000842:	00000097          	auipc	ra,0x0
    80000846:	634080e7          	jalr	1588(ra) # 80000e76 <initlock>
}
    8000084a:	60a2                	ld	ra,8(sp)
    8000084c:	6402                	ld	s0,0(sp)
    8000084e:	0141                	addi	sp,sp,16
    80000850:	8082                	ret

0000000080000852 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000852:	1101                	addi	sp,sp,-32
    80000854:	ec06                	sd	ra,24(sp)
    80000856:	e822                	sd	s0,16(sp)
    80000858:	e426                	sd	s1,8(sp)
    8000085a:	1000                	addi	s0,sp,32
    8000085c:	84aa                	mv	s1,a0
  push_off();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	65c080e7          	jalr	1628(ra) # 80000eba <push_off>

  if(panicked){
    80000866:	0000b797          	auipc	a5,0xb
    8000086a:	daa7a783          	lw	a5,-598(a5) # 8000b610 <panicked>
    8000086e:	eb85                	bnez	a5,8000089e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000870:	10000737          	lui	a4,0x10000
    80000874:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000876:	00074783          	lbu	a5,0(a4)
    8000087a:	0207f793          	andi	a5,a5,32
    8000087e:	dfe5                	beqz	a5,80000876 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000880:	0ff4f513          	zext.b	a0,s1
    80000884:	100007b7          	lui	a5,0x10000
    80000888:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	6ce080e7          	jalr	1742(ra) # 80000f5a <pop_off>
}
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    for(;;)
    8000089e:	a001                	j	8000089e <uartputc_sync+0x4c>

00000000800008a0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a0:	0000b797          	auipc	a5,0xb
    800008a4:	d787b783          	ld	a5,-648(a5) # 8000b618 <uart_tx_r>
    800008a8:	0000b717          	auipc	a4,0xb
    800008ac:	d7873703          	ld	a4,-648(a4) # 8000b620 <uart_tx_w>
    800008b0:	06f70f63          	beq	a4,a5,8000092e <uartstart+0x8e>
{
    800008b4:	7139                	addi	sp,sp,-64
    800008b6:	fc06                	sd	ra,56(sp)
    800008b8:	f822                	sd	s0,48(sp)
    800008ba:	f426                	sd	s1,40(sp)
    800008bc:	f04a                	sd	s2,32(sp)
    800008be:	ec4e                	sd	s3,24(sp)
    800008c0:	e852                	sd	s4,16(sp)
    800008c2:	e456                	sd	s5,8(sp)
    800008c4:	e05a                	sd	s6,0(sp)
    800008c6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c8:	10000937          	lui	s2,0x10000
    800008cc:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ce:	00013a97          	auipc	s5,0x13
    800008d2:	f9aa8a93          	addi	s5,s5,-102 # 80013868 <uart_tx_lock>
    uart_tx_r += 1;
    800008d6:	0000b497          	auipc	s1,0xb
    800008da:	d4248493          	addi	s1,s1,-702 # 8000b618 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008de:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e2:	0000b997          	auipc	s3,0xb
    800008e6:	d3e98993          	addi	s3,s3,-706 # 8000b620 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ea:	00094703          	lbu	a4,0(s2)
    800008ee:	02077713          	andi	a4,a4,32
    800008f2:	c705                	beqz	a4,8000091a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f4:	01f7f713          	andi	a4,a5,31
    800008f8:	9756                	add	a4,a4,s5
    800008fa:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008fe:	0785                	addi	a5,a5,1
    80000900:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000902:	8526                	mv	a0,s1
    80000904:	00002097          	auipc	ra,0x2
    80000908:	d1a080e7          	jalr	-742(ra) # 8000261e <wakeup>
    WriteReg(THR, c);
    8000090c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000910:	609c                	ld	a5,0(s1)
    80000912:	0009b703          	ld	a4,0(s3)
    80000916:	fcf71ae3          	bne	a4,a5,800008ea <uartstart+0x4a>
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
    8000092e:	8082                	ret

0000000080000930 <uartputc>:
{
    80000930:	7179                	addi	sp,sp,-48
    80000932:	f406                	sd	ra,40(sp)
    80000934:	f022                	sd	s0,32(sp)
    80000936:	ec26                	sd	s1,24(sp)
    80000938:	e84a                	sd	s2,16(sp)
    8000093a:	e44e                	sd	s3,8(sp)
    8000093c:	e052                	sd	s4,0(sp)
    8000093e:	1800                	addi	s0,sp,48
    80000940:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000942:	00013517          	auipc	a0,0x13
    80000946:	f2650513          	addi	a0,a0,-218 # 80013868 <uart_tx_lock>
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	5bc080e7          	jalr	1468(ra) # 80000f06 <acquire>
  if(panicked){
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	cbe7a783          	lw	a5,-834(a5) # 8000b610 <panicked>
    8000095a:	e7c9                	bnez	a5,800009e4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095c:	0000b717          	auipc	a4,0xb
    80000960:	cc473703          	ld	a4,-828(a4) # 8000b620 <uart_tx_w>
    80000964:	0000b797          	auipc	a5,0xb
    80000968:	cb47b783          	ld	a5,-844(a5) # 8000b618 <uart_tx_r>
    8000096c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000970:	00013997          	auipc	s3,0x13
    80000974:	ef898993          	addi	s3,s3,-264 # 80013868 <uart_tx_lock>
    80000978:	0000b497          	auipc	s1,0xb
    8000097c:	ca048493          	addi	s1,s1,-864 # 8000b618 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000980:	0000b917          	auipc	s2,0xb
    80000984:	ca090913          	addi	s2,s2,-864 # 8000b620 <uart_tx_w>
    80000988:	00e79f63          	bne	a5,a4,800009a6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000098c:	85ce                	mv	a1,s3
    8000098e:	8526                	mv	a0,s1
    80000990:	00002097          	auipc	ra,0x2
    80000994:	c2a080e7          	jalr	-982(ra) # 800025ba <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000998:	00093703          	ld	a4,0(s2)
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	02078793          	addi	a5,a5,32
    800009a2:	fee785e3          	beq	a5,a4,8000098c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a6:	00013497          	auipc	s1,0x13
    800009aa:	ec248493          	addi	s1,s1,-318 # 80013868 <uart_tx_lock>
    800009ae:	01f77793          	andi	a5,a4,31
    800009b2:	97a6                	add	a5,a5,s1
    800009b4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009b8:	0705                	addi	a4,a4,1
    800009ba:	0000b797          	auipc	a5,0xb
    800009be:	c6e7b323          	sd	a4,-922(a5) # 8000b620 <uart_tx_w>
  uartstart();
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	ede080e7          	jalr	-290(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	5ee080e7          	jalr	1518(ra) # 80000fba <release>
}
    800009d4:	70a2                	ld	ra,40(sp)
    800009d6:	7402                	ld	s0,32(sp)
    800009d8:	64e2                	ld	s1,24(sp)
    800009da:	6942                	ld	s2,16(sp)
    800009dc:	69a2                	ld	s3,8(sp)
    800009de:	6a02                	ld	s4,0(sp)
    800009e0:	6145                	addi	sp,sp,48
    800009e2:	8082                	ret
    for(;;)
    800009e4:	a001                	j	800009e4 <uartputc+0xb4>

00000000800009e6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e6:	1141                	addi	sp,sp,-16
    800009e8:	e422                	sd	s0,8(sp)
    800009ea:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009f2:	0007c783          	lbu	a5,0(a5)
    800009f6:	8b85                	andi	a5,a5,1
    800009f8:	cb81                	beqz	a5,80000a08 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009fa:	100007b7          	lui	a5,0x10000
    800009fe:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a02:	6422                	ld	s0,8(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return -1;
    80000a08:	557d                	li	a0,-1
    80000a0a:	bfe5                	j	80000a02 <uartgetc+0x1c>

0000000080000a0c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a16:	54fd                	li	s1,-1
    80000a18:	a029                	j	80000a22 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a1a:	00000097          	auipc	ra,0x0
    80000a1e:	8bc080e7          	jalr	-1860(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	fc4080e7          	jalr	-60(ra) # 800009e6 <uartgetc>
    if(c == -1)
    80000a2a:	fe9518e3          	bne	a0,s1,80000a1a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a2e:	00013497          	auipc	s1,0x13
    80000a32:	e3a48493          	addi	s1,s1,-454 # 80013868 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	4ce080e7          	jalr	1230(ra) # 80000f06 <acquire>
  uartstart();
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	e60080e7          	jalr	-416(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    80000a48:	8526                	mv	a0,s1
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	570080e7          	jalr	1392(ra) # 80000fba <release>
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <refindex>:
#define NPAGES ((PHYSTOP-KERNBASE)/PGSIZE)
struct spinlock refcountlock;
int refcount[NPAGES];

int refindex(void *pa){
    if (((uint64)pa % PGSIZE) != 0 || (uint64)pa < KERNBASE || (uint64)pa >= PHYSTOP)
    80000a5c:	03451793          	slli	a5,a0,0x34
    80000a60:	eb99                	bnez	a5,80000a76 <refindex+0x1a>
    80000a62:	800007b7          	lui	a5,0x80000
    80000a66:	953e                	add	a0,a0,a5
    80000a68:	080007b7          	lui	a5,0x8000
    80000a6c:	00f57563          	bgeu	a0,a5,80000a76 <refindex+0x1a>
        panic("refindex");
    return ((uint64) pa - KERNBASE) / PGSIZE;
    80000a70:	8131                	srli	a0,a0,0xc
}
    80000a72:	2501                	sext.w	a0,a0
    80000a74:	8082                	ret
int refindex(void *pa){
    80000a76:	1141                	addi	sp,sp,-16
    80000a78:	e406                	sd	ra,8(sp)
    80000a7a:	e022                	sd	s0,0(sp)
    80000a7c:	0800                	addi	s0,sp,16
        panic("refindex");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	5d250513          	addi	a0,a0,1490 # 80008050 <__func__.1+0x48>
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	ada080e7          	jalr	-1318(ra) # 80000560 <panic>

0000000080000a8e <getrefcount>:
int getrefcount(uint64 pa){
    80000a8e:	1101                	addi	sp,sp,-32
    80000a90:	ec06                	sd	ra,24(sp)
    80000a92:	e822                	sd	s0,16(sp)
    80000a94:	e426                	sd	s1,8(sp)
    80000a96:	e04a                	sd	s2,0(sp)
    80000a98:	1000                	addi	s0,sp,32
    80000a9a:	84aa                	mv	s1,a0
    int count;
    acquire(&refcountlock);
    80000a9c:	00013917          	auipc	s2,0x13
    80000aa0:	e0490913          	addi	s2,s2,-508 # 800138a0 <refcountlock>
    80000aa4:	854a                	mv	a0,s2
    80000aa6:	00000097          	auipc	ra,0x0
    80000aaa:	460080e7          	jalr	1120(ra) # 80000f06 <acquire>
    count = refcount[refindex((void*)pa)];
    80000aae:	8526                	mv	a0,s1
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	fac080e7          	jalr	-84(ra) # 80000a5c <refindex>
    80000ab8:	050a                	slli	a0,a0,0x2
    80000aba:	00013797          	auipc	a5,0x13
    80000abe:	e1e78793          	addi	a5,a5,-482 # 800138d8 <refcount>
    80000ac2:	97aa                	add	a5,a5,a0
    80000ac4:	4384                	lw	s1,0(a5)
    release(&refcountlock);
    80000ac6:	854a                	mv	a0,s2
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	4f2080e7          	jalr	1266(ra) # 80000fba <release>
    return count;
}
    80000ad0:	8526                	mv	a0,s1
    80000ad2:	60e2                	ld	ra,24(sp)
    80000ad4:	6442                	ld	s0,16(sp)
    80000ad6:	64a2                	ld	s1,8(sp)
    80000ad8:	6902                	ld	s2,0(sp)
    80000ada:	6105                	addi	sp,sp,32
    80000adc:	8082                	ret

0000000080000ade <decrefcount>:
void decrefcount(uint64 pa){
    80000ade:	1101                	addi	sp,sp,-32
    80000ae0:	ec06                	sd	ra,24(sp)
    80000ae2:	e822                	sd	s0,16(sp)
    80000ae4:	e426                	sd	s1,8(sp)
    80000ae6:	e04a                	sd	s2,0(sp)
    80000ae8:	1000                	addi	s0,sp,32
    80000aea:	84aa                	mv	s1,a0
    acquire(&refcountlock);
    80000aec:	00013917          	auipc	s2,0x13
    80000af0:	db490913          	addi	s2,s2,-588 # 800138a0 <refcountlock>
    80000af4:	854a                	mv	a0,s2
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	410080e7          	jalr	1040(ra) # 80000f06 <acquire>
    refcount[refindex((void*)pa)]--;
    80000afe:	8526                	mv	a0,s1
    80000b00:	00000097          	auipc	ra,0x0
    80000b04:	f5c080e7          	jalr	-164(ra) # 80000a5c <refindex>
    80000b08:	050a                	slli	a0,a0,0x2
    80000b0a:	00013797          	auipc	a5,0x13
    80000b0e:	dce78793          	addi	a5,a5,-562 # 800138d8 <refcount>
    80000b12:	97aa                	add	a5,a5,a0
    80000b14:	4398                	lw	a4,0(a5)
    80000b16:	377d                	addiw	a4,a4,-1
    80000b18:	c398                	sw	a4,0(a5)
    release(&refcountlock);
    80000b1a:	854a                	mv	a0,s2
    80000b1c:	00000097          	auipc	ra,0x0
    80000b20:	49e080e7          	jalr	1182(ra) # 80000fba <release>
}
    80000b24:	60e2                	ld	ra,24(sp)
    80000b26:	6442                	ld	s0,16(sp)
    80000b28:	64a2                	ld	s1,8(sp)
    80000b2a:	6902                	ld	s2,0(sp)
    80000b2c:	6105                	addi	sp,sp,32
    80000b2e:	8082                	ret

0000000080000b30 <increfcount>:
void increfcount(uint64 pa){
    80000b30:	1101                	addi	sp,sp,-32
    80000b32:	ec06                	sd	ra,24(sp)
    80000b34:	e822                	sd	s0,16(sp)
    80000b36:	e426                	sd	s1,8(sp)
    80000b38:	e04a                	sd	s2,0(sp)
    80000b3a:	1000                	addi	s0,sp,32
    80000b3c:	84aa                	mv	s1,a0
    acquire(&refcountlock);
    80000b3e:	00013917          	auipc	s2,0x13
    80000b42:	d6290913          	addi	s2,s2,-670 # 800138a0 <refcountlock>
    80000b46:	854a                	mv	a0,s2
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	3be080e7          	jalr	958(ra) # 80000f06 <acquire>
    refcount[refindex((void*)pa)]++;
    80000b50:	8526                	mv	a0,s1
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	f0a080e7          	jalr	-246(ra) # 80000a5c <refindex>
    80000b5a:	050a                	slli	a0,a0,0x2
    80000b5c:	00013797          	auipc	a5,0x13
    80000b60:	d7c78793          	addi	a5,a5,-644 # 800138d8 <refcount>
    80000b64:	97aa                	add	a5,a5,a0
    80000b66:	4398                	lw	a4,0(a5)
    80000b68:	2705                	addiw	a4,a4,1
    80000b6a:	c398                	sw	a4,0(a5)
    release(&refcountlock);
    80000b6c:	854a                	mv	a0,s2
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	44c080e7          	jalr	1100(ra) # 80000fba <release>
}
    80000b76:	60e2                	ld	ra,24(sp)
    80000b78:	6442                	ld	s0,16(sp)
    80000b7a:	64a2                	ld	s1,8(sp)
    80000b7c:	6902                	ld	s2,0(sp)
    80000b7e:	6105                	addi	sp,sp,32
    80000b80:	8082                	ret

0000000080000b82 <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000b82:	7179                	addi	sp,sp,-48
    80000b84:	f406                	sd	ra,40(sp)
    80000b86:	f022                	sd	s0,32(sp)
    80000b88:	ec26                	sd	s1,24(sp)
    80000b8a:	1800                	addi	s0,sp,48
    80000b8c:	84aa                	mv	s1,a0
    if (MAX_PAGES != 0)
    80000b8e:	0000b797          	auipc	a5,0xb
    80000b92:	aa27b783          	ld	a5,-1374(a5) # 8000b630 <MAX_PAGES>
    80000b96:	c799                	beqz	a5,80000ba4 <kfree+0x22>
        assert(FREE_PAGES < MAX_PAGES);
    80000b98:	0000b717          	auipc	a4,0xb
    80000b9c:	a9073703          	ld	a4,-1392(a4) # 8000b628 <FREE_PAGES>
    80000ba0:	08f77863          	bgeu	a4,a5,80000c30 <kfree+0xae>
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000ba4:	03449793          	slli	a5,s1,0x34
    80000ba8:	e3e1                	bnez	a5,80000c68 <kfree+0xe6>
    80000baa:	00044797          	auipc	a5,0x44
    80000bae:	f3e78793          	addi	a5,a5,-194 # 80044ae8 <end>
    80000bb2:	0af4eb63          	bltu	s1,a5,80000c68 <kfree+0xe6>
    80000bb6:	47c5                	li	a5,17
    80000bb8:	07ee                	slli	a5,a5,0x1b
    80000bba:	0af4f763          	bgeu	s1,a5,80000c68 <kfree+0xe6>
    80000bbe:	e84a                	sd	s2,16(sp)
        panic("kfree");

    int i = refindex(pa);
    80000bc0:	8526                	mv	a0,s1
    80000bc2:	00000097          	auipc	ra,0x0
    80000bc6:	e9a080e7          	jalr	-358(ra) # 80000a5c <refindex>
    80000bca:	892a                	mv	s2,a0
    int empty;

    acquire(&refcountlock);
    80000bcc:	00013517          	auipc	a0,0x13
    80000bd0:	cd450513          	addi	a0,a0,-812 # 800138a0 <refcountlock>
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	332080e7          	jalr	818(ra) # 80000f06 <acquire>
    if(refcount[i] > 0) refcount[i]--;
    80000bdc:	00291713          	slli	a4,s2,0x2
    80000be0:	00013797          	auipc	a5,0x13
    80000be4:	cf878793          	addi	a5,a5,-776 # 800138d8 <refcount>
    80000be8:	97ba                	add	a5,a5,a4
    80000bea:	439c                	lw	a5,0(a5)
    80000bec:	00f05a63          	blez	a5,80000c00 <kfree+0x7e>
    80000bf0:	86ba                	mv	a3,a4
    80000bf2:	00013717          	auipc	a4,0x13
    80000bf6:	ce670713          	addi	a4,a4,-794 # 800138d8 <refcount>
    80000bfa:	9736                	add	a4,a4,a3
    80000bfc:	37fd                	addiw	a5,a5,-1
    80000bfe:	c31c                	sw	a5,0(a4)
    empty = refcount[i] == 0;
    80000c00:	090a                	slli	s2,s2,0x2
    80000c02:	00013797          	auipc	a5,0x13
    80000c06:	cd678793          	addi	a5,a5,-810 # 800138d8 <refcount>
    80000c0a:	97ca                	add	a5,a5,s2
    80000c0c:	0007a903          	lw	s2,0(a5)
    release(&refcountlock);
    80000c10:	00013517          	auipc	a0,0x13
    80000c14:	c9050513          	addi	a0,a0,-880 # 800138a0 <refcountlock>
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	3a2080e7          	jalr	930(ra) # 80000fba <release>
    if(!empty) return;
    80000c20:	04090e63          	beqz	s2,80000c7c <kfree+0xfa>
    80000c24:	6942                	ld	s2,16(sp)
    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    FREE_PAGES++;
    release(&kmem.lock);
}
    80000c26:	70a2                	ld	ra,40(sp)
    80000c28:	7402                	ld	s0,32(sp)
    80000c2a:	64e2                	ld	s1,24(sp)
    80000c2c:	6145                	addi	sp,sp,48
    80000c2e:	8082                	ret
    80000c30:	e84a                	sd	s2,16(sp)
    80000c32:	e44e                	sd	s3,8(sp)
        assert(FREE_PAGES < MAX_PAGES);
    80000c34:	05300693          	li	a3,83
    80000c38:	00007617          	auipc	a2,0x7
    80000c3c:	3d060613          	addi	a2,a2,976 # 80008008 <__func__.1>
    80000c40:	00007597          	auipc	a1,0x7
    80000c44:	42058593          	addi	a1,a1,1056 # 80008060 <__func__.1+0x58>
    80000c48:	00007517          	auipc	a0,0x7
    80000c4c:	42850513          	addi	a0,a0,1064 # 80008070 <__func__.1+0x68>
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	96c080e7          	jalr	-1684(ra) # 800005bc <printf>
    80000c58:	00007517          	auipc	a0,0x7
    80000c5c:	42850513          	addi	a0,a0,1064 # 80008080 <__func__.1+0x78>
    80000c60:	00000097          	auipc	ra,0x0
    80000c64:	900080e7          	jalr	-1792(ra) # 80000560 <panic>
    80000c68:	e84a                	sd	s2,16(sp)
    80000c6a:	e44e                	sd	s3,8(sp)
        panic("kfree");
    80000c6c:	00007517          	auipc	a0,0x7
    80000c70:	42450513          	addi	a0,a0,1060 # 80008090 <__func__.1+0x88>
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	8ec080e7          	jalr	-1812(ra) # 80000560 <panic>
    80000c7c:	e44e                	sd	s3,8(sp)
    memset(pa, 1, PGSIZE);
    80000c7e:	6605                	lui	a2,0x1
    80000c80:	4585                	li	a1,1
    80000c82:	8526                	mv	a0,s1
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	37e080e7          	jalr	894(ra) # 80001002 <memset>
    acquire(&kmem.lock);
    80000c8c:	00013997          	auipc	s3,0x13
    80000c90:	c1498993          	addi	s3,s3,-1004 # 800138a0 <refcountlock>
    80000c94:	00013917          	auipc	s2,0x13
    80000c98:	c2490913          	addi	s2,s2,-988 # 800138b8 <kmem>
    80000c9c:	854a                	mv	a0,s2
    80000c9e:	00000097          	auipc	ra,0x0
    80000ca2:	268080e7          	jalr	616(ra) # 80000f06 <acquire>
    r->next = kmem.freelist;
    80000ca6:	0309b783          	ld	a5,48(s3)
    80000caa:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000cac:	0299b823          	sd	s1,48(s3)
    FREE_PAGES++;
    80000cb0:	0000b717          	auipc	a4,0xb
    80000cb4:	97870713          	addi	a4,a4,-1672 # 8000b628 <FREE_PAGES>
    80000cb8:	631c                	ld	a5,0(a4)
    80000cba:	0785                	addi	a5,a5,1
    80000cbc:	e31c                	sd	a5,0(a4)
    release(&kmem.lock);
    80000cbe:	854a                	mv	a0,s2
    80000cc0:	00000097          	auipc	ra,0x0
    80000cc4:	2fa080e7          	jalr	762(ra) # 80000fba <release>
    80000cc8:	69a2                	ld	s3,8(sp)
    80000cca:	bfa9                	j	80000c24 <kfree+0xa2>

0000000080000ccc <freerange>:
{
    80000ccc:	7179                	addi	sp,sp,-48
    80000cce:	f406                	sd	ra,40(sp)
    80000cd0:	f022                	sd	s0,32(sp)
    80000cd2:	ec26                	sd	s1,24(sp)
    80000cd4:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000cd6:	6785                	lui	a5,0x1
    80000cd8:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000cdc:	00e504b3          	add	s1,a0,a4
    80000ce0:	777d                	lui	a4,0xfffff
    80000ce2:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ce4:	94be                	add	s1,s1,a5
    80000ce6:	0295e463          	bltu	a1,s1,80000d0e <freerange+0x42>
    80000cea:	e84a                	sd	s2,16(sp)
    80000cec:	e44e                	sd	s3,8(sp)
    80000cee:	e052                	sd	s4,0(sp)
    80000cf0:	892e                	mv	s2,a1
        kfree(p);
    80000cf2:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000cf4:	6985                	lui	s3,0x1
        kfree(p);
    80000cf6:	01448533          	add	a0,s1,s4
    80000cfa:	00000097          	auipc	ra,0x0
    80000cfe:	e88080e7          	jalr	-376(ra) # 80000b82 <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000d02:	94ce                	add	s1,s1,s3
    80000d04:	fe9979e3          	bgeu	s2,s1,80000cf6 <freerange+0x2a>
    80000d08:	6942                	ld	s2,16(sp)
    80000d0a:	69a2                	ld	s3,8(sp)
    80000d0c:	6a02                	ld	s4,0(sp)
}
    80000d0e:	70a2                	ld	ra,40(sp)
    80000d10:	7402                	ld	s0,32(sp)
    80000d12:	64e2                	ld	s1,24(sp)
    80000d14:	6145                	addi	sp,sp,48
    80000d16:	8082                	ret

0000000080000d18 <kinit>:
{
    80000d18:	1141                	addi	sp,sp,-16
    80000d1a:	e406                	sd	ra,8(sp)
    80000d1c:	e022                	sd	s0,0(sp)
    80000d1e:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000d20:	00007597          	auipc	a1,0x7
    80000d24:	37858593          	addi	a1,a1,888 # 80008098 <__func__.1+0x90>
    80000d28:	00013517          	auipc	a0,0x13
    80000d2c:	b9050513          	addi	a0,a0,-1136 # 800138b8 <kmem>
    80000d30:	00000097          	auipc	ra,0x0
    80000d34:	146080e7          	jalr	326(ra) # 80000e76 <initlock>
    initlock(&refcountlock, "refcount");
    80000d38:	00007597          	auipc	a1,0x7
    80000d3c:	36858593          	addi	a1,a1,872 # 800080a0 <__func__.1+0x98>
    80000d40:	00013517          	auipc	a0,0x13
    80000d44:	b6050513          	addi	a0,a0,-1184 # 800138a0 <refcountlock>
    80000d48:	00000097          	auipc	ra,0x0
    80000d4c:	12e080e7          	jalr	302(ra) # 80000e76 <initlock>
    freerange(end, (void *)PHYSTOP);
    80000d50:	45c5                	li	a1,17
    80000d52:	05ee                	slli	a1,a1,0x1b
    80000d54:	00044517          	auipc	a0,0x44
    80000d58:	d9450513          	addi	a0,a0,-620 # 80044ae8 <end>
    80000d5c:	00000097          	auipc	ra,0x0
    80000d60:	f70080e7          	jalr	-144(ra) # 80000ccc <freerange>
    MAX_PAGES = FREE_PAGES;
    80000d64:	0000b797          	auipc	a5,0xb
    80000d68:	8c47b783          	ld	a5,-1852(a5) # 8000b628 <FREE_PAGES>
    80000d6c:	0000b717          	auipc	a4,0xb
    80000d70:	8cf73223          	sd	a5,-1852(a4) # 8000b630 <MAX_PAGES>
}
    80000d74:	60a2                	ld	ra,8(sp)
    80000d76:	6402                	ld	s0,0(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000d7c:	7179                	addi	sp,sp,-48
    80000d7e:	f406                	sd	ra,40(sp)
    80000d80:	f022                	sd	s0,32(sp)
    80000d82:	ec26                	sd	s1,24(sp)
    80000d84:	e84a                	sd	s2,16(sp)
    80000d86:	e44e                	sd	s3,8(sp)
    80000d88:	1800                	addi	s0,sp,48
    assert(FREE_PAGES > 0);
    80000d8a:	0000b797          	auipc	a5,0xb
    80000d8e:	89e7b783          	ld	a5,-1890(a5) # 8000b628 <FREE_PAGES>
    80000d92:	cfd9                	beqz	a5,80000e30 <kalloc+0xb4>
    struct run *r;

    acquire(&kmem.lock);
    80000d94:	00013517          	auipc	a0,0x13
    80000d98:	b2450513          	addi	a0,a0,-1244 # 800138b8 <kmem>
    80000d9c:	00000097          	auipc	ra,0x0
    80000da0:	16a080e7          	jalr	362(ra) # 80000f06 <acquire>
    r = kmem.freelist;
    80000da4:	00013917          	auipc	s2,0x13
    80000da8:	b2c93903          	ld	s2,-1236(s2) # 800138d0 <kmem+0x18>
    if (r)
    80000dac:	0a090c63          	beqz	s2,80000e64 <kalloc+0xe8>
        kmem.freelist = r->next;
    80000db0:	00093783          	ld	a5,0(s2)
    80000db4:	00013717          	auipc	a4,0x13
    80000db8:	b0f73e23          	sd	a5,-1252(a4) # 800138d0 <kmem+0x18>
    release(&kmem.lock);
    80000dbc:	00013517          	auipc	a0,0x13
    80000dc0:	afc50513          	addi	a0,a0,-1284 # 800138b8 <kmem>
    80000dc4:	00000097          	auipc	ra,0x0
    80000dc8:	1f6080e7          	jalr	502(ra) # 80000fba <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000dcc:	6605                	lui	a2,0x1
    80000dce:	4595                	li	a1,5
    80000dd0:	854a                	mv	a0,s2
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	230080e7          	jalr	560(ra) # 80001002 <memset>
    FREE_PAGES--;
    80000dda:	0000b717          	auipc	a4,0xb
    80000dde:	84e70713          	addi	a4,a4,-1970 # 8000b628 <FREE_PAGES>
    80000de2:	631c                	ld	a5,0(a4)
    80000de4:	17fd                	addi	a5,a5,-1
    80000de6:	e31c                	sd	a5,0(a4)

    int i = refindex((void*) r);
    80000de8:	854a                	mv	a0,s2
    80000dea:	00000097          	auipc	ra,0x0
    80000dee:	c72080e7          	jalr	-910(ra) # 80000a5c <refindex>
    80000df2:	84aa                	mv	s1,a0
    acquire(&refcountlock);
    80000df4:	00013997          	auipc	s3,0x13
    80000df8:	aac98993          	addi	s3,s3,-1364 # 800138a0 <refcountlock>
    80000dfc:	854e                	mv	a0,s3
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	108080e7          	jalr	264(ra) # 80000f06 <acquire>
    refcount[i] = 1;
    80000e06:	048a                	slli	s1,s1,0x2
    80000e08:	00013797          	auipc	a5,0x13
    80000e0c:	ad078793          	addi	a5,a5,-1328 # 800138d8 <refcount>
    80000e10:	97a6                	add	a5,a5,s1
    80000e12:	4705                	li	a4,1
    80000e14:	c398                	sw	a4,0(a5)
    release(&refcountlock);
    80000e16:	854e                	mv	a0,s3
    80000e18:	00000097          	auipc	ra,0x0
    80000e1c:	1a2080e7          	jalr	418(ra) # 80000fba <release>

    return (void *)r;
}
    80000e20:	854a                	mv	a0,s2
    80000e22:	70a2                	ld	ra,40(sp)
    80000e24:	7402                	ld	s0,32(sp)
    80000e26:	64e2                	ld	s1,24(sp)
    80000e28:	6942                	ld	s2,16(sp)
    80000e2a:	69a2                	ld	s3,8(sp)
    80000e2c:	6145                	addi	sp,sp,48
    80000e2e:	8082                	ret
    assert(FREE_PAGES > 0);
    80000e30:	07500693          	li	a3,117
    80000e34:	00007617          	auipc	a2,0x7
    80000e38:	1cc60613          	addi	a2,a2,460 # 80008000 <etext>
    80000e3c:	00007597          	auipc	a1,0x7
    80000e40:	22458593          	addi	a1,a1,548 # 80008060 <__func__.1+0x58>
    80000e44:	00007517          	auipc	a0,0x7
    80000e48:	22c50513          	addi	a0,a0,556 # 80008070 <__func__.1+0x68>
    80000e4c:	fffff097          	auipc	ra,0xfffff
    80000e50:	770080e7          	jalr	1904(ra) # 800005bc <printf>
    80000e54:	00007517          	auipc	a0,0x7
    80000e58:	22c50513          	addi	a0,a0,556 # 80008080 <__func__.1+0x78>
    80000e5c:	fffff097          	auipc	ra,0xfffff
    80000e60:	704080e7          	jalr	1796(ra) # 80000560 <panic>
    release(&kmem.lock);
    80000e64:	00013517          	auipc	a0,0x13
    80000e68:	a5450513          	addi	a0,a0,-1452 # 800138b8 <kmem>
    80000e6c:	00000097          	auipc	ra,0x0
    80000e70:	14e080e7          	jalr	334(ra) # 80000fba <release>
    if (r)
    80000e74:	b79d                	j	80000dda <kalloc+0x5e>

0000000080000e76 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000e7c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000e7e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000e82:	00053823          	sd	zero,16(a0)
}
    80000e86:	6422                	ld	s0,8(sp)
    80000e88:	0141                	addi	sp,sp,16
    80000e8a:	8082                	ret

0000000080000e8c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000e8c:	411c                	lw	a5,0(a0)
    80000e8e:	e399                	bnez	a5,80000e94 <holding+0x8>
    80000e90:	4501                	li	a0,0
  return r;
}
    80000e92:	8082                	ret
{
    80000e94:	1101                	addi	sp,sp,-32
    80000e96:	ec06                	sd	ra,24(sp)
    80000e98:	e822                	sd	s0,16(sp)
    80000e9a:	e426                	sd	s1,8(sp)
    80000e9c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000e9e:	6904                	ld	s1,16(a0)
    80000ea0:	00001097          	auipc	ra,0x1
    80000ea4:	f4c080e7          	jalr	-180(ra) # 80001dec <mycpu>
    80000ea8:	40a48533          	sub	a0,s1,a0
    80000eac:	00153513          	seqz	a0,a0
}
    80000eb0:	60e2                	ld	ra,24(sp)
    80000eb2:	6442                	ld	s0,16(sp)
    80000eb4:	64a2                	ld	s1,8(sp)
    80000eb6:	6105                	addi	sp,sp,32
    80000eb8:	8082                	ret

0000000080000eba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000eba:	1101                	addi	sp,sp,-32
    80000ebc:	ec06                	sd	ra,24(sp)
    80000ebe:	e822                	sd	s0,16(sp)
    80000ec0:	e426                	sd	s1,8(sp)
    80000ec2:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000ec4:	100024f3          	csrr	s1,sstatus
    80000ec8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ecc:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000ece:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ed2:	00001097          	auipc	ra,0x1
    80000ed6:	f1a080e7          	jalr	-230(ra) # 80001dec <mycpu>
    80000eda:	5d3c                	lw	a5,120(a0)
    80000edc:	cf89                	beqz	a5,80000ef6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ede:	00001097          	auipc	ra,0x1
    80000ee2:	f0e080e7          	jalr	-242(ra) # 80001dec <mycpu>
    80000ee6:	5d3c                	lw	a5,120(a0)
    80000ee8:	2785                	addiw	a5,a5,1
    80000eea:	dd3c                	sw	a5,120(a0)
}
    80000eec:	60e2                	ld	ra,24(sp)
    80000eee:	6442                	ld	s0,16(sp)
    80000ef0:	64a2                	ld	s1,8(sp)
    80000ef2:	6105                	addi	sp,sp,32
    80000ef4:	8082                	ret
    mycpu()->intena = old;
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	ef6080e7          	jalr	-266(ra) # 80001dec <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000efe:	8085                	srli	s1,s1,0x1
    80000f00:	8885                	andi	s1,s1,1
    80000f02:	dd64                	sw	s1,124(a0)
    80000f04:	bfe9                	j	80000ede <push_off+0x24>

0000000080000f06 <acquire>:
{
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	1000                	addi	s0,sp,32
    80000f10:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	fa8080e7          	jalr	-88(ra) # 80000eba <push_off>
  if(holding(lk))
    80000f1a:	8526                	mv	a0,s1
    80000f1c:	00000097          	auipc	ra,0x0
    80000f20:	f70080e7          	jalr	-144(ra) # 80000e8c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f24:	4705                	li	a4,1
  if(holding(lk))
    80000f26:	e115                	bnez	a0,80000f4a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000f28:	87ba                	mv	a5,a4
    80000f2a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000f2e:	2781                	sext.w	a5,a5
    80000f30:	ffe5                	bnez	a5,80000f28 <acquire+0x22>
  __sync_synchronize();
    80000f32:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000f36:	00001097          	auipc	ra,0x1
    80000f3a:	eb6080e7          	jalr	-330(ra) # 80001dec <mycpu>
    80000f3e:	e888                	sd	a0,16(s1)
}
    80000f40:	60e2                	ld	ra,24(sp)
    80000f42:	6442                	ld	s0,16(sp)
    80000f44:	64a2                	ld	s1,8(sp)
    80000f46:	6105                	addi	sp,sp,32
    80000f48:	8082                	ret
    panic("acquire");
    80000f4a:	00007517          	auipc	a0,0x7
    80000f4e:	16650513          	addi	a0,a0,358 # 800080b0 <__func__.1+0xa8>
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	60e080e7          	jalr	1550(ra) # 80000560 <panic>

0000000080000f5a <pop_off>:

void
pop_off(void)
{
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e406                	sd	ra,8(sp)
    80000f5e:	e022                	sd	s0,0(sp)
    80000f60:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000f62:	00001097          	auipc	ra,0x1
    80000f66:	e8a080e7          	jalr	-374(ra) # 80001dec <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000f6a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000f6e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000f70:	e78d                	bnez	a5,80000f9a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000f72:	5d3c                	lw	a5,120(a0)
    80000f74:	02f05b63          	blez	a5,80000faa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000f78:	37fd                	addiw	a5,a5,-1
    80000f7a:	0007871b          	sext.w	a4,a5
    80000f7e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000f80:	eb09                	bnez	a4,80000f92 <pop_off+0x38>
    80000f82:	5d7c                	lw	a5,124(a0)
    80000f84:	c799                	beqz	a5,80000f92 <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000f86:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000f8a:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000f8e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000f92:	60a2                	ld	ra,8(sp)
    80000f94:	6402                	ld	s0,0(sp)
    80000f96:	0141                	addi	sp,sp,16
    80000f98:	8082                	ret
    panic("pop_off - interruptible");
    80000f9a:	00007517          	auipc	a0,0x7
    80000f9e:	11e50513          	addi	a0,a0,286 # 800080b8 <__func__.1+0xb0>
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5be080e7          	jalr	1470(ra) # 80000560 <panic>
    panic("pop_off");
    80000faa:	00007517          	auipc	a0,0x7
    80000fae:	12650513          	addi	a0,a0,294 # 800080d0 <__func__.1+0xc8>
    80000fb2:	fffff097          	auipc	ra,0xfffff
    80000fb6:	5ae080e7          	jalr	1454(ra) # 80000560 <panic>

0000000080000fba <release>:
{
    80000fba:	1101                	addi	sp,sp,-32
    80000fbc:	ec06                	sd	ra,24(sp)
    80000fbe:	e822                	sd	s0,16(sp)
    80000fc0:	e426                	sd	s1,8(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000fc6:	00000097          	auipc	ra,0x0
    80000fca:	ec6080e7          	jalr	-314(ra) # 80000e8c <holding>
    80000fce:	c115                	beqz	a0,80000ff2 <release+0x38>
  lk->cpu = 0;
    80000fd0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000fd4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000fd8:	0310000f          	fence	rw,w
    80000fdc:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	f7a080e7          	jalr	-134(ra) # 80000f5a <pop_off>
}
    80000fe8:	60e2                	ld	ra,24(sp)
    80000fea:	6442                	ld	s0,16(sp)
    80000fec:	64a2                	ld	s1,8(sp)
    80000fee:	6105                	addi	sp,sp,32
    80000ff0:	8082                	ret
    panic("release");
    80000ff2:	00007517          	auipc	a0,0x7
    80000ff6:	0e650513          	addi	a0,a0,230 # 800080d8 <__func__.1+0xd0>
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	566080e7          	jalr	1382(ra) # 80000560 <panic>

0000000080001002 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001002:	1141                	addi	sp,sp,-16
    80001004:	e422                	sd	s0,8(sp)
    80001006:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80001008:	ca19                	beqz	a2,8000101e <memset+0x1c>
    8000100a:	87aa                	mv	a5,a0
    8000100c:	1602                	slli	a2,a2,0x20
    8000100e:	9201                	srli	a2,a2,0x20
    80001010:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80001014:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80001018:	0785                	addi	a5,a5,1
    8000101a:	fee79de3          	bne	a5,a4,80001014 <memset+0x12>
  }
  return dst;
}
    8000101e:	6422                	ld	s0,8(sp)
    80001020:	0141                	addi	sp,sp,16
    80001022:	8082                	ret

0000000080001024 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80001024:	1141                	addi	sp,sp,-16
    80001026:	e422                	sd	s0,8(sp)
    80001028:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000102a:	ca05                	beqz	a2,8000105a <memcmp+0x36>
    8000102c:	fff6069b          	addiw	a3,a2,-1
    80001030:	1682                	slli	a3,a3,0x20
    80001032:	9281                	srli	a3,a3,0x20
    80001034:	0685                	addi	a3,a3,1
    80001036:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80001038:	00054783          	lbu	a5,0(a0)
    8000103c:	0005c703          	lbu	a4,0(a1)
    80001040:	00e79863          	bne	a5,a4,80001050 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80001044:	0505                	addi	a0,a0,1
    80001046:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80001048:	fed518e3          	bne	a0,a3,80001038 <memcmp+0x14>
  }

  return 0;
    8000104c:	4501                	li	a0,0
    8000104e:	a019                	j	80001054 <memcmp+0x30>
      return *s1 - *s2;
    80001050:	40e7853b          	subw	a0,a5,a4
}
    80001054:	6422                	ld	s0,8(sp)
    80001056:	0141                	addi	sp,sp,16
    80001058:	8082                	ret
  return 0;
    8000105a:	4501                	li	a0,0
    8000105c:	bfe5                	j	80001054 <memcmp+0x30>

000000008000105e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000105e:	1141                	addi	sp,sp,-16
    80001060:	e422                	sd	s0,8(sp)
    80001062:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80001064:	c205                	beqz	a2,80001084 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80001066:	02a5e263          	bltu	a1,a0,8000108a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000106a:	1602                	slli	a2,a2,0x20
    8000106c:	9201                	srli	a2,a2,0x20
    8000106e:	00c587b3          	add	a5,a1,a2
{
    80001072:	872a                	mv	a4,a0
      *d++ = *s++;
    80001074:	0585                	addi	a1,a1,1
    80001076:	0705                	addi	a4,a4,1
    80001078:	fff5c683          	lbu	a3,-1(a1)
    8000107c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80001080:	feb79ae3          	bne	a5,a1,80001074 <memmove+0x16>

  return dst;
}
    80001084:	6422                	ld	s0,8(sp)
    80001086:	0141                	addi	sp,sp,16
    80001088:	8082                	ret
  if(s < d && s + n > d){
    8000108a:	02061693          	slli	a3,a2,0x20
    8000108e:	9281                	srli	a3,a3,0x20
    80001090:	00d58733          	add	a4,a1,a3
    80001094:	fce57be3          	bgeu	a0,a4,8000106a <memmove+0xc>
    d += n;
    80001098:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000109a:	fff6079b          	addiw	a5,a2,-1
    8000109e:	1782                	slli	a5,a5,0x20
    800010a0:	9381                	srli	a5,a5,0x20
    800010a2:	fff7c793          	not	a5,a5
    800010a6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800010a8:	177d                	addi	a4,a4,-1
    800010aa:	16fd                	addi	a3,a3,-1
    800010ac:	00074603          	lbu	a2,0(a4)
    800010b0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800010b4:	fef71ae3          	bne	a4,a5,800010a8 <memmove+0x4a>
    800010b8:	b7f1                	j	80001084 <memmove+0x26>

00000000800010ba <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800010ba:	1141                	addi	sp,sp,-16
    800010bc:	e406                	sd	ra,8(sp)
    800010be:	e022                	sd	s0,0(sp)
    800010c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	f9c080e7          	jalr	-100(ra) # 8000105e <memmove>
}
    800010ca:	60a2                	ld	ra,8(sp)
    800010cc:	6402                	ld	s0,0(sp)
    800010ce:	0141                	addi	sp,sp,16
    800010d0:	8082                	ret

00000000800010d2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800010d2:	1141                	addi	sp,sp,-16
    800010d4:	e422                	sd	s0,8(sp)
    800010d6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800010d8:	ce11                	beqz	a2,800010f4 <strncmp+0x22>
    800010da:	00054783          	lbu	a5,0(a0)
    800010de:	cf89                	beqz	a5,800010f8 <strncmp+0x26>
    800010e0:	0005c703          	lbu	a4,0(a1)
    800010e4:	00f71a63          	bne	a4,a5,800010f8 <strncmp+0x26>
    n--, p++, q++;
    800010e8:	367d                	addiw	a2,a2,-1
    800010ea:	0505                	addi	a0,a0,1
    800010ec:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800010ee:	f675                	bnez	a2,800010da <strncmp+0x8>
  if(n == 0)
    return 0;
    800010f0:	4501                	li	a0,0
    800010f2:	a801                	j	80001102 <strncmp+0x30>
    800010f4:	4501                	li	a0,0
    800010f6:	a031                	j	80001102 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800010f8:	00054503          	lbu	a0,0(a0)
    800010fc:	0005c783          	lbu	a5,0(a1)
    80001100:	9d1d                	subw	a0,a0,a5
}
    80001102:	6422                	ld	s0,8(sp)
    80001104:	0141                	addi	sp,sp,16
    80001106:	8082                	ret

0000000080001108 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80001108:	1141                	addi	sp,sp,-16
    8000110a:	e422                	sd	s0,8(sp)
    8000110c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000110e:	87aa                	mv	a5,a0
    80001110:	86b2                	mv	a3,a2
    80001112:	367d                	addiw	a2,a2,-1
    80001114:	02d05563          	blez	a3,8000113e <strncpy+0x36>
    80001118:	0785                	addi	a5,a5,1
    8000111a:	0005c703          	lbu	a4,0(a1)
    8000111e:	fee78fa3          	sb	a4,-1(a5)
    80001122:	0585                	addi	a1,a1,1
    80001124:	f775                	bnez	a4,80001110 <strncpy+0x8>
    ;
  while(n-- > 0)
    80001126:	873e                	mv	a4,a5
    80001128:	9fb5                	addw	a5,a5,a3
    8000112a:	37fd                	addiw	a5,a5,-1
    8000112c:	00c05963          	blez	a2,8000113e <strncpy+0x36>
    *s++ = 0;
    80001130:	0705                	addi	a4,a4,1
    80001132:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80001136:	40e786bb          	subw	a3,a5,a4
    8000113a:	fed04be3          	bgtz	a3,80001130 <strncpy+0x28>
  return os;
}
    8000113e:	6422                	ld	s0,8(sp)
    80001140:	0141                	addi	sp,sp,16
    80001142:	8082                	ret

0000000080001144 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001144:	1141                	addi	sp,sp,-16
    80001146:	e422                	sd	s0,8(sp)
    80001148:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000114a:	02c05363          	blez	a2,80001170 <safestrcpy+0x2c>
    8000114e:	fff6069b          	addiw	a3,a2,-1
    80001152:	1682                	slli	a3,a3,0x20
    80001154:	9281                	srli	a3,a3,0x20
    80001156:	96ae                	add	a3,a3,a1
    80001158:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000115a:	00d58963          	beq	a1,a3,8000116c <safestrcpy+0x28>
    8000115e:	0585                	addi	a1,a1,1
    80001160:	0785                	addi	a5,a5,1
    80001162:	fff5c703          	lbu	a4,-1(a1)
    80001166:	fee78fa3          	sb	a4,-1(a5)
    8000116a:	fb65                	bnez	a4,8000115a <safestrcpy+0x16>
    ;
  *s = 0;
    8000116c:	00078023          	sb	zero,0(a5)
  return os;
}
    80001170:	6422                	ld	s0,8(sp)
    80001172:	0141                	addi	sp,sp,16
    80001174:	8082                	ret

0000000080001176 <strlen>:

int
strlen(const char *s)
{
    80001176:	1141                	addi	sp,sp,-16
    80001178:	e422                	sd	s0,8(sp)
    8000117a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000117c:	00054783          	lbu	a5,0(a0)
    80001180:	cf91                	beqz	a5,8000119c <strlen+0x26>
    80001182:	0505                	addi	a0,a0,1
    80001184:	87aa                	mv	a5,a0
    80001186:	86be                	mv	a3,a5
    80001188:	0785                	addi	a5,a5,1
    8000118a:	fff7c703          	lbu	a4,-1(a5)
    8000118e:	ff65                	bnez	a4,80001186 <strlen+0x10>
    80001190:	40a6853b          	subw	a0,a3,a0
    80001194:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80001196:	6422                	ld	s0,8(sp)
    80001198:	0141                	addi	sp,sp,16
    8000119a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000119c:	4501                	li	a0,0
    8000119e:	bfe5                	j	80001196 <strlen+0x20>

00000000800011a0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800011a0:	1141                	addi	sp,sp,-16
    800011a2:	e406                	sd	ra,8(sp)
    800011a4:	e022                	sd	s0,0(sp)
    800011a6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800011a8:	00001097          	auipc	ra,0x1
    800011ac:	c34080e7          	jalr	-972(ra) # 80001ddc <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800011b0:	0000a717          	auipc	a4,0xa
    800011b4:	48870713          	addi	a4,a4,1160 # 8000b638 <started>
  if(cpuid() == 0){
    800011b8:	c139                	beqz	a0,800011fe <main+0x5e>
    while(started == 0)
    800011ba:	431c                	lw	a5,0(a4)
    800011bc:	2781                	sext.w	a5,a5
    800011be:	dff5                	beqz	a5,800011ba <main+0x1a>
      ;
    __sync_synchronize();
    800011c0:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800011c4:	00001097          	auipc	ra,0x1
    800011c8:	c18080e7          	jalr	-1000(ra) # 80001ddc <cpuid>
    800011cc:	85aa                	mv	a1,a0
    800011ce:	00007517          	auipc	a0,0x7
    800011d2:	f2a50513          	addi	a0,a0,-214 # 800080f8 <__func__.1+0xf0>
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	3e6080e7          	jalr	998(ra) # 800005bc <printf>
    kvminithart();    // turn on paging
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	0d8080e7          	jalr	216(ra) # 800012b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    800011e6:	00002097          	auipc	ra,0x2
    800011ea:	b46080e7          	jalr	-1210(ra) # 80002d2c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800011ee:	00005097          	auipc	ra,0x5
    800011f2:	416080e7          	jalr	1046(ra) # 80006604 <plicinithart>
  }

  scheduler();        
    800011f6:	00001097          	auipc	ra,0x1
    800011fa:	2a2080e7          	jalr	674(ra) # 80002498 <scheduler>
    consoleinit();
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	272080e7          	jalr	626(ra) # 80000470 <consoleinit>
    printfinit();
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	5be080e7          	jalr	1470(ra) # 800007c4 <printfinit>
    printf("\n");
    8000120e:	00007517          	auipc	a0,0x7
    80001212:	e1250513          	addi	a0,a0,-494 # 80008020 <__func__.1+0x18>
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	3a6080e7          	jalr	934(ra) # 800005bc <printf>
    printf("xv6 kernel is booting\n");
    8000121e:	00007517          	auipc	a0,0x7
    80001222:	ec250513          	addi	a0,a0,-318 # 800080e0 <__func__.1+0xd8>
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	396080e7          	jalr	918(ra) # 800005bc <printf>
    printf("\n");
    8000122e:	00007517          	auipc	a0,0x7
    80001232:	df250513          	addi	a0,a0,-526 # 80008020 <__func__.1+0x18>
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	386080e7          	jalr	902(ra) # 800005bc <printf>
    kinit();         // physical page allocator
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	ada080e7          	jalr	-1318(ra) # 80000d18 <kinit>
    kvminit();       // create kernel page table
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	326080e7          	jalr	806(ra) # 8000156c <kvminit>
    kvminithart();   // turn on paging
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	068080e7          	jalr	104(ra) # 800012b6 <kvminithart>
    procinit();      // process table
    80001256:	00001097          	auipc	ra,0x1
    8000125a:	aa0080e7          	jalr	-1376(ra) # 80001cf6 <procinit>
    trapinit();      // trap vectors
    8000125e:	00002097          	auipc	ra,0x2
    80001262:	aa6080e7          	jalr	-1370(ra) # 80002d04 <trapinit>
    trapinithart();  // install kernel trap vector
    80001266:	00002097          	auipc	ra,0x2
    8000126a:	ac6080e7          	jalr	-1338(ra) # 80002d2c <trapinithart>
    plicinit();      // set up interrupt controller
    8000126e:	00005097          	auipc	ra,0x5
    80001272:	37c080e7          	jalr	892(ra) # 800065ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001276:	00005097          	auipc	ra,0x5
    8000127a:	38e080e7          	jalr	910(ra) # 80006604 <plicinithart>
    binit();         // buffer cache
    8000127e:	00002097          	auipc	ra,0x2
    80001282:	452080e7          	jalr	1106(ra) # 800036d0 <binit>
    iinit();         // inode table
    80001286:	00003097          	auipc	ra,0x3
    8000128a:	b08080e7          	jalr	-1272(ra) # 80003d8e <iinit>
    fileinit();      // file table
    8000128e:	00004097          	auipc	ra,0x4
    80001292:	ab8080e7          	jalr	-1352(ra) # 80004d46 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001296:	00005097          	auipc	ra,0x5
    8000129a:	476080e7          	jalr	1142(ra) # 8000670c <virtio_disk_init>
    userinit();      // first user process
    8000129e:	00001097          	auipc	ra,0x1
    800012a2:	e42080e7          	jalr	-446(ra) # 800020e0 <userinit>
    __sync_synchronize();
    800012a6:	0330000f          	fence	rw,rw
    started = 1;
    800012aa:	4785                	li	a5,1
    800012ac:	0000a717          	auipc	a4,0xa
    800012b0:	38f72623          	sw	a5,908(a4) # 8000b638 <started>
    800012b4:	b789                	j	800011f6 <main+0x56>

00000000800012b6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800012b6:	1141                	addi	sp,sp,-16
    800012b8:	e422                	sd	s0,8(sp)
    800012ba:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    800012bc:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800012c0:	0000a797          	auipc	a5,0xa
    800012c4:	3807b783          	ld	a5,896(a5) # 8000b640 <kernel_pagetable>
    800012c8:	83b1                	srli	a5,a5,0xc
    800012ca:	577d                	li	a4,-1
    800012cc:	177e                	slli	a4,a4,0x3f
    800012ce:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    800012d0:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    800012d4:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800012d8:	6422                	ld	s0,8(sp)
    800012da:	0141                	addi	sp,sp,16
    800012dc:	8082                	ret

00000000800012de <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800012de:	7139                	addi	sp,sp,-64
    800012e0:	fc06                	sd	ra,56(sp)
    800012e2:	f822                	sd	s0,48(sp)
    800012e4:	f426                	sd	s1,40(sp)
    800012e6:	f04a                	sd	s2,32(sp)
    800012e8:	ec4e                	sd	s3,24(sp)
    800012ea:	e852                	sd	s4,16(sp)
    800012ec:	e456                	sd	s5,8(sp)
    800012ee:	e05a                	sd	s6,0(sp)
    800012f0:	0080                	addi	s0,sp,64
    800012f2:	84aa                	mv	s1,a0
    800012f4:	89ae                	mv	s3,a1
    800012f6:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800012f8:	57fd                	li	a5,-1
    800012fa:	83e9                	srli	a5,a5,0x1a
    800012fc:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800012fe:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001300:	04b7f263          	bgeu	a5,a1,80001344 <walk+0x66>
    panic("walk");
    80001304:	00007517          	auipc	a0,0x7
    80001308:	e0c50513          	addi	a0,a0,-500 # 80008110 <__func__.1+0x108>
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	254080e7          	jalr	596(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001314:	060a8663          	beqz	s5,80001380 <walk+0xa2>
    80001318:	00000097          	auipc	ra,0x0
    8000131c:	a64080e7          	jalr	-1436(ra) # 80000d7c <kalloc>
    80001320:	84aa                	mv	s1,a0
    80001322:	c529                	beqz	a0,8000136c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001324:	6605                	lui	a2,0x1
    80001326:	4581                	li	a1,0
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	cda080e7          	jalr	-806(ra) # 80001002 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001330:	00c4d793          	srli	a5,s1,0xc
    80001334:	07aa                	slli	a5,a5,0xa
    80001336:	0017e793          	ori	a5,a5,1
    8000133a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000133e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffba50f>
    80001340:	036a0063          	beq	s4,s6,80001360 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001344:	0149d933          	srl	s2,s3,s4
    80001348:	1ff97913          	andi	s2,s2,511
    8000134c:	090e                	slli	s2,s2,0x3
    8000134e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001350:	00093483          	ld	s1,0(s2)
    80001354:	0014f793          	andi	a5,s1,1
    80001358:	dfd5                	beqz	a5,80001314 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000135a:	80a9                	srli	s1,s1,0xa
    8000135c:	04b2                	slli	s1,s1,0xc
    8000135e:	b7c5                	j	8000133e <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001360:	00c9d513          	srli	a0,s3,0xc
    80001364:	1ff57513          	andi	a0,a0,511
    80001368:	050e                	slli	a0,a0,0x3
    8000136a:	9526                	add	a0,a0,s1
}
    8000136c:	70e2                	ld	ra,56(sp)
    8000136e:	7442                	ld	s0,48(sp)
    80001370:	74a2                	ld	s1,40(sp)
    80001372:	7902                	ld	s2,32(sp)
    80001374:	69e2                	ld	s3,24(sp)
    80001376:	6a42                	ld	s4,16(sp)
    80001378:	6aa2                	ld	s5,8(sp)
    8000137a:	6b02                	ld	s6,0(sp)
    8000137c:	6121                	addi	sp,sp,64
    8000137e:	8082                	ret
        return 0;
    80001380:	4501                	li	a0,0
    80001382:	b7ed                	j	8000136c <walk+0x8e>

0000000080001384 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001384:	57fd                	li	a5,-1
    80001386:	83e9                	srli	a5,a5,0x1a
    80001388:	00b7f463          	bgeu	a5,a1,80001390 <walkaddr+0xc>
    return 0;
    8000138c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000138e:	8082                	ret
{
    80001390:	1141                	addi	sp,sp,-16
    80001392:	e406                	sd	ra,8(sp)
    80001394:	e022                	sd	s0,0(sp)
    80001396:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001398:	4601                	li	a2,0
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	f44080e7          	jalr	-188(ra) # 800012de <walk>
  if(pte == 0)
    800013a2:	c105                	beqz	a0,800013c2 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800013a4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800013a6:	0117f693          	andi	a3,a5,17
    800013aa:	4745                	li	a4,17
    return 0;
    800013ac:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800013ae:	00e68663          	beq	a3,a4,800013ba <walkaddr+0x36>
}
    800013b2:	60a2                	ld	ra,8(sp)
    800013b4:	6402                	ld	s0,0(sp)
    800013b6:	0141                	addi	sp,sp,16
    800013b8:	8082                	ret
  pa = PTE2PA(*pte);
    800013ba:	83a9                	srli	a5,a5,0xa
    800013bc:	00c79513          	slli	a0,a5,0xc
  return pa;
    800013c0:	bfcd                	j	800013b2 <walkaddr+0x2e>
    return 0;
    800013c2:	4501                	li	a0,0
    800013c4:	b7fd                	j	800013b2 <walkaddr+0x2e>

00000000800013c6 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800013c6:	715d                	addi	sp,sp,-80
    800013c8:	e486                	sd	ra,72(sp)
    800013ca:	e0a2                	sd	s0,64(sp)
    800013cc:	fc26                	sd	s1,56(sp)
    800013ce:	f84a                	sd	s2,48(sp)
    800013d0:	f44e                	sd	s3,40(sp)
    800013d2:	f052                	sd	s4,32(sp)
    800013d4:	ec56                	sd	s5,24(sp)
    800013d6:	e85a                	sd	s6,16(sp)
    800013d8:	e45e                	sd	s7,8(sp)
    800013da:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800013dc:	c639                	beqz	a2,8000142a <mappages+0x64>
    800013de:	8aaa                	mv	s5,a0
    800013e0:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800013e2:	777d                	lui	a4,0xfffff
    800013e4:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800013e8:	fff58993          	addi	s3,a1,-1
    800013ec:	99b2                	add	s3,s3,a2
    800013ee:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800013f2:	893e                	mv	s2,a5
    800013f4:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800013f8:	6b85                	lui	s7,0x1
    800013fa:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800013fe:	4605                	li	a2,1
    80001400:	85ca                	mv	a1,s2
    80001402:	8556                	mv	a0,s5
    80001404:	00000097          	auipc	ra,0x0
    80001408:	eda080e7          	jalr	-294(ra) # 800012de <walk>
    8000140c:	cd1d                	beqz	a0,8000144a <mappages+0x84>
    if(*pte & PTE_V)
    8000140e:	611c                	ld	a5,0(a0)
    80001410:	8b85                	andi	a5,a5,1
    80001412:	e785                	bnez	a5,8000143a <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001414:	80b1                	srli	s1,s1,0xc
    80001416:	04aa                	slli	s1,s1,0xa
    80001418:	0164e4b3          	or	s1,s1,s6
    8000141c:	0014e493          	ori	s1,s1,1
    80001420:	e104                	sd	s1,0(a0)
    if(a == last)
    80001422:	05390063          	beq	s2,s3,80001462 <mappages+0x9c>
    a += PGSIZE;
    80001426:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001428:	bfc9                	j	800013fa <mappages+0x34>
    panic("mappages: size");
    8000142a:	00007517          	auipc	a0,0x7
    8000142e:	cee50513          	addi	a0,a0,-786 # 80008118 <__func__.1+0x110>
    80001432:	fffff097          	auipc	ra,0xfffff
    80001436:	12e080e7          	jalr	302(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000143a:	00007517          	auipc	a0,0x7
    8000143e:	cee50513          	addi	a0,a0,-786 # 80008128 <__func__.1+0x120>
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	11e080e7          	jalr	286(ra) # 80000560 <panic>
      return -1;
    8000144a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000144c:	60a6                	ld	ra,72(sp)
    8000144e:	6406                	ld	s0,64(sp)
    80001450:	74e2                	ld	s1,56(sp)
    80001452:	7942                	ld	s2,48(sp)
    80001454:	79a2                	ld	s3,40(sp)
    80001456:	7a02                	ld	s4,32(sp)
    80001458:	6ae2                	ld	s5,24(sp)
    8000145a:	6b42                	ld	s6,16(sp)
    8000145c:	6ba2                	ld	s7,8(sp)
    8000145e:	6161                	addi	sp,sp,80
    80001460:	8082                	ret
  return 0;
    80001462:	4501                	li	a0,0
    80001464:	b7e5                	j	8000144c <mappages+0x86>

0000000080001466 <kvmmap>:
{
    80001466:	1141                	addi	sp,sp,-16
    80001468:	e406                	sd	ra,8(sp)
    8000146a:	e022                	sd	s0,0(sp)
    8000146c:	0800                	addi	s0,sp,16
    8000146e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001470:	86b2                	mv	a3,a2
    80001472:	863e                	mv	a2,a5
    80001474:	00000097          	auipc	ra,0x0
    80001478:	f52080e7          	jalr	-174(ra) # 800013c6 <mappages>
    8000147c:	e509                	bnez	a0,80001486 <kvmmap+0x20>
}
    8000147e:	60a2                	ld	ra,8(sp)
    80001480:	6402                	ld	s0,0(sp)
    80001482:	0141                	addi	sp,sp,16
    80001484:	8082                	ret
    panic("kvmmap");
    80001486:	00007517          	auipc	a0,0x7
    8000148a:	cb250513          	addi	a0,a0,-846 # 80008138 <__func__.1+0x130>
    8000148e:	fffff097          	auipc	ra,0xfffff
    80001492:	0d2080e7          	jalr	210(ra) # 80000560 <panic>

0000000080001496 <kvmmake>:
{
    80001496:	1101                	addi	sp,sp,-32
    80001498:	ec06                	sd	ra,24(sp)
    8000149a:	e822                	sd	s0,16(sp)
    8000149c:	e426                	sd	s1,8(sp)
    8000149e:	e04a                	sd	s2,0(sp)
    800014a0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800014a2:	00000097          	auipc	ra,0x0
    800014a6:	8da080e7          	jalr	-1830(ra) # 80000d7c <kalloc>
    800014aa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800014ac:	6605                	lui	a2,0x1
    800014ae:	4581                	li	a1,0
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	b52080e7          	jalr	-1198(ra) # 80001002 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800014b8:	4719                	li	a4,6
    800014ba:	6685                	lui	a3,0x1
    800014bc:	10000637          	lui	a2,0x10000
    800014c0:	100005b7          	lui	a1,0x10000
    800014c4:	8526                	mv	a0,s1
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	fa0080e7          	jalr	-96(ra) # 80001466 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800014ce:	4719                	li	a4,6
    800014d0:	6685                	lui	a3,0x1
    800014d2:	10001637          	lui	a2,0x10001
    800014d6:	100015b7          	lui	a1,0x10001
    800014da:	8526                	mv	a0,s1
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	f8a080e7          	jalr	-118(ra) # 80001466 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800014e4:	4719                	li	a4,6
    800014e6:	004006b7          	lui	a3,0x400
    800014ea:	0c000637          	lui	a2,0xc000
    800014ee:	0c0005b7          	lui	a1,0xc000
    800014f2:	8526                	mv	a0,s1
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	f72080e7          	jalr	-142(ra) # 80001466 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800014fc:	00007917          	auipc	s2,0x7
    80001500:	b0490913          	addi	s2,s2,-1276 # 80008000 <etext>
    80001504:	4729                	li	a4,10
    80001506:	80007697          	auipc	a3,0x80007
    8000150a:	afa68693          	addi	a3,a3,-1286 # 8000 <_entry-0x7fff8000>
    8000150e:	4605                	li	a2,1
    80001510:	067e                	slli	a2,a2,0x1f
    80001512:	85b2                	mv	a1,a2
    80001514:	8526                	mv	a0,s1
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	f50080e7          	jalr	-176(ra) # 80001466 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000151e:	46c5                	li	a3,17
    80001520:	06ee                	slli	a3,a3,0x1b
    80001522:	4719                	li	a4,6
    80001524:	412686b3          	sub	a3,a3,s2
    80001528:	864a                	mv	a2,s2
    8000152a:	85ca                	mv	a1,s2
    8000152c:	8526                	mv	a0,s1
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	f38080e7          	jalr	-200(ra) # 80001466 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001536:	4729                	li	a4,10
    80001538:	6685                	lui	a3,0x1
    8000153a:	00006617          	auipc	a2,0x6
    8000153e:	ac660613          	addi	a2,a2,-1338 # 80007000 <_trampoline>
    80001542:	040005b7          	lui	a1,0x4000
    80001546:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001548:	05b2                	slli	a1,a1,0xc
    8000154a:	8526                	mv	a0,s1
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	f1a080e7          	jalr	-230(ra) # 80001466 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001554:	8526                	mv	a0,s1
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	6fc080e7          	jalr	1788(ra) # 80001c52 <proc_mapstacks>
}
    8000155e:	8526                	mv	a0,s1
    80001560:	60e2                	ld	ra,24(sp)
    80001562:	6442                	ld	s0,16(sp)
    80001564:	64a2                	ld	s1,8(sp)
    80001566:	6902                	ld	s2,0(sp)
    80001568:	6105                	addi	sp,sp,32
    8000156a:	8082                	ret

000000008000156c <kvminit>:
{
    8000156c:	1141                	addi	sp,sp,-16
    8000156e:	e406                	sd	ra,8(sp)
    80001570:	e022                	sd	s0,0(sp)
    80001572:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001574:	00000097          	auipc	ra,0x0
    80001578:	f22080e7          	jalr	-222(ra) # 80001496 <kvmmake>
    8000157c:	0000a797          	auipc	a5,0xa
    80001580:	0ca7b223          	sd	a0,196(a5) # 8000b640 <kernel_pagetable>
}
    80001584:	60a2                	ld	ra,8(sp)
    80001586:	6402                	ld	s0,0(sp)
    80001588:	0141                	addi	sp,sp,16
    8000158a:	8082                	ret

000000008000158c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000158c:	715d                	addi	sp,sp,-80
    8000158e:	e486                	sd	ra,72(sp)
    80001590:	e0a2                	sd	s0,64(sp)
    80001592:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001594:	03459793          	slli	a5,a1,0x34
    80001598:	e39d                	bnez	a5,800015be <uvmunmap+0x32>
    8000159a:	f84a                	sd	s2,48(sp)
    8000159c:	f44e                	sd	s3,40(sp)
    8000159e:	f052                	sd	s4,32(sp)
    800015a0:	ec56                	sd	s5,24(sp)
    800015a2:	e85a                	sd	s6,16(sp)
    800015a4:	e45e                	sd	s7,8(sp)
    800015a6:	8a2a                	mv	s4,a0
    800015a8:	892e                	mv	s2,a1
    800015aa:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800015ac:	0632                	slli	a2,a2,0xc
    800015ae:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800015b2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800015b4:	6b05                	lui	s6,0x1
    800015b6:	0935fb63          	bgeu	a1,s3,8000164c <uvmunmap+0xc0>
    800015ba:	fc26                	sd	s1,56(sp)
    800015bc:	a8a9                	j	80001616 <uvmunmap+0x8a>
    800015be:	fc26                	sd	s1,56(sp)
    800015c0:	f84a                	sd	s2,48(sp)
    800015c2:	f44e                	sd	s3,40(sp)
    800015c4:	f052                	sd	s4,32(sp)
    800015c6:	ec56                	sd	s5,24(sp)
    800015c8:	e85a                	sd	s6,16(sp)
    800015ca:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800015cc:	00007517          	auipc	a0,0x7
    800015d0:	b7450513          	addi	a0,a0,-1164 # 80008140 <__func__.1+0x138>
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	f8c080e7          	jalr	-116(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    800015dc:	00007517          	auipc	a0,0x7
    800015e0:	b7c50513          	addi	a0,a0,-1156 # 80008158 <__func__.1+0x150>
    800015e4:	fffff097          	auipc	ra,0xfffff
    800015e8:	f7c080e7          	jalr	-132(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    800015ec:	00007517          	auipc	a0,0x7
    800015f0:	b7c50513          	addi	a0,a0,-1156 # 80008168 <__func__.1+0x160>
    800015f4:	fffff097          	auipc	ra,0xfffff
    800015f8:	f6c080e7          	jalr	-148(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    800015fc:	00007517          	auipc	a0,0x7
    80001600:	b8450513          	addi	a0,a0,-1148 # 80008180 <__func__.1+0x178>
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	f5c080e7          	jalr	-164(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000160c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001610:	995a                	add	s2,s2,s6
    80001612:	03397c63          	bgeu	s2,s3,8000164a <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001616:	4601                	li	a2,0
    80001618:	85ca                	mv	a1,s2
    8000161a:	8552                	mv	a0,s4
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	cc2080e7          	jalr	-830(ra) # 800012de <walk>
    80001624:	84aa                	mv	s1,a0
    80001626:	d95d                	beqz	a0,800015dc <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001628:	6108                	ld	a0,0(a0)
    8000162a:	00157793          	andi	a5,a0,1
    8000162e:	dfdd                	beqz	a5,800015ec <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001630:	3ff57793          	andi	a5,a0,1023
    80001634:	fd7784e3          	beq	a5,s7,800015fc <uvmunmap+0x70>
    if(do_free){
    80001638:	fc0a8ae3          	beqz	s5,8000160c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000163c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000163e:	0532                	slli	a0,a0,0xc
    80001640:	fffff097          	auipc	ra,0xfffff
    80001644:	542080e7          	jalr	1346(ra) # 80000b82 <kfree>
    80001648:	b7d1                	j	8000160c <uvmunmap+0x80>
    8000164a:	74e2                	ld	s1,56(sp)
    8000164c:	7942                	ld	s2,48(sp)
    8000164e:	79a2                	ld	s3,40(sp)
    80001650:	7a02                	ld	s4,32(sp)
    80001652:	6ae2                	ld	s5,24(sp)
    80001654:	6b42                	ld	s6,16(sp)
    80001656:	6ba2                	ld	s7,8(sp)
  }
}
    80001658:	60a6                	ld	ra,72(sp)
    8000165a:	6406                	ld	s0,64(sp)
    8000165c:	6161                	addi	sp,sp,80
    8000165e:	8082                	ret

0000000080001660 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001660:	1101                	addi	sp,sp,-32
    80001662:	ec06                	sd	ra,24(sp)
    80001664:	e822                	sd	s0,16(sp)
    80001666:	e426                	sd	s1,8(sp)
    80001668:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000166a:	fffff097          	auipc	ra,0xfffff
    8000166e:	712080e7          	jalr	1810(ra) # 80000d7c <kalloc>
    80001672:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001674:	c519                	beqz	a0,80001682 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001676:	6605                	lui	a2,0x1
    80001678:	4581                	li	a1,0
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	988080e7          	jalr	-1656(ra) # 80001002 <memset>
  return pagetable;
}
    80001682:	8526                	mv	a0,s1
    80001684:	60e2                	ld	ra,24(sp)
    80001686:	6442                	ld	s0,16(sp)
    80001688:	64a2                	ld	s1,8(sp)
    8000168a:	6105                	addi	sp,sp,32
    8000168c:	8082                	ret

000000008000168e <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000168e:	7179                	addi	sp,sp,-48
    80001690:	f406                	sd	ra,40(sp)
    80001692:	f022                	sd	s0,32(sp)
    80001694:	ec26                	sd	s1,24(sp)
    80001696:	e84a                	sd	s2,16(sp)
    80001698:	e44e                	sd	s3,8(sp)
    8000169a:	e052                	sd	s4,0(sp)
    8000169c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000169e:	6785                	lui	a5,0x1
    800016a0:	04f67863          	bgeu	a2,a5,800016f0 <uvmfirst+0x62>
    800016a4:	8a2a                	mv	s4,a0
    800016a6:	89ae                	mv	s3,a1
    800016a8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800016aa:	fffff097          	auipc	ra,0xfffff
    800016ae:	6d2080e7          	jalr	1746(ra) # 80000d7c <kalloc>
    800016b2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800016b4:	6605                	lui	a2,0x1
    800016b6:	4581                	li	a1,0
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	94a080e7          	jalr	-1718(ra) # 80001002 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800016c0:	4779                	li	a4,30
    800016c2:	86ca                	mv	a3,s2
    800016c4:	6605                	lui	a2,0x1
    800016c6:	4581                	li	a1,0
    800016c8:	8552                	mv	a0,s4
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	cfc080e7          	jalr	-772(ra) # 800013c6 <mappages>
  memmove(mem, src, sz);
    800016d2:	8626                	mv	a2,s1
    800016d4:	85ce                	mv	a1,s3
    800016d6:	854a                	mv	a0,s2
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	986080e7          	jalr	-1658(ra) # 8000105e <memmove>
}
    800016e0:	70a2                	ld	ra,40(sp)
    800016e2:	7402                	ld	s0,32(sp)
    800016e4:	64e2                	ld	s1,24(sp)
    800016e6:	6942                	ld	s2,16(sp)
    800016e8:	69a2                	ld	s3,8(sp)
    800016ea:	6a02                	ld	s4,0(sp)
    800016ec:	6145                	addi	sp,sp,48
    800016ee:	8082                	ret
    panic("uvmfirst: more than a page");
    800016f0:	00007517          	auipc	a0,0x7
    800016f4:	aa850513          	addi	a0,a0,-1368 # 80008198 <__func__.1+0x190>
    800016f8:	fffff097          	auipc	ra,0xfffff
    800016fc:	e68080e7          	jalr	-408(ra) # 80000560 <panic>

0000000080001700 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001700:	1101                	addi	sp,sp,-32
    80001702:	ec06                	sd	ra,24(sp)
    80001704:	e822                	sd	s0,16(sp)
    80001706:	e426                	sd	s1,8(sp)
    80001708:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000170a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000170c:	00b67d63          	bgeu	a2,a1,80001726 <uvmdealloc+0x26>
    80001710:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001712:	6785                	lui	a5,0x1
    80001714:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001716:	00f60733          	add	a4,a2,a5
    8000171a:	76fd                	lui	a3,0xfffff
    8000171c:	8f75                	and	a4,a4,a3
    8000171e:	97ae                	add	a5,a5,a1
    80001720:	8ff5                	and	a5,a5,a3
    80001722:	00f76863          	bltu	a4,a5,80001732 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001726:	8526                	mv	a0,s1
    80001728:	60e2                	ld	ra,24(sp)
    8000172a:	6442                	ld	s0,16(sp)
    8000172c:	64a2                	ld	s1,8(sp)
    8000172e:	6105                	addi	sp,sp,32
    80001730:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001732:	8f99                	sub	a5,a5,a4
    80001734:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001736:	4685                	li	a3,1
    80001738:	0007861b          	sext.w	a2,a5
    8000173c:	85ba                	mv	a1,a4
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	e4e080e7          	jalr	-434(ra) # 8000158c <uvmunmap>
    80001746:	b7c5                	j	80001726 <uvmdealloc+0x26>

0000000080001748 <uvmalloc>:
  if(newsz < oldsz)
    80001748:	0ab66b63          	bltu	a2,a1,800017fe <uvmalloc+0xb6>
{
    8000174c:	7139                	addi	sp,sp,-64
    8000174e:	fc06                	sd	ra,56(sp)
    80001750:	f822                	sd	s0,48(sp)
    80001752:	ec4e                	sd	s3,24(sp)
    80001754:	e852                	sd	s4,16(sp)
    80001756:	e456                	sd	s5,8(sp)
    80001758:	0080                	addi	s0,sp,64
    8000175a:	8aaa                	mv	s5,a0
    8000175c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000175e:	6785                	lui	a5,0x1
    80001760:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001762:	95be                	add	a1,a1,a5
    80001764:	77fd                	lui	a5,0xfffff
    80001766:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000176a:	08c9fc63          	bgeu	s3,a2,80001802 <uvmalloc+0xba>
    8000176e:	f426                	sd	s1,40(sp)
    80001770:	f04a                	sd	s2,32(sp)
    80001772:	e05a                	sd	s6,0(sp)
    80001774:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001776:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000177a:	fffff097          	auipc	ra,0xfffff
    8000177e:	602080e7          	jalr	1538(ra) # 80000d7c <kalloc>
    80001782:	84aa                	mv	s1,a0
    if(mem == 0){
    80001784:	c915                	beqz	a0,800017b8 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80001786:	6605                	lui	a2,0x1
    80001788:	4581                	li	a1,0
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	878080e7          	jalr	-1928(ra) # 80001002 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001792:	875a                	mv	a4,s6
    80001794:	86a6                	mv	a3,s1
    80001796:	6605                	lui	a2,0x1
    80001798:	85ca                	mv	a1,s2
    8000179a:	8556                	mv	a0,s5
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	c2a080e7          	jalr	-982(ra) # 800013c6 <mappages>
    800017a4:	ed05                	bnez	a0,800017dc <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800017a6:	6785                	lui	a5,0x1
    800017a8:	993e                	add	s2,s2,a5
    800017aa:	fd4968e3          	bltu	s2,s4,8000177a <uvmalloc+0x32>
  return newsz;
    800017ae:	8552                	mv	a0,s4
    800017b0:	74a2                	ld	s1,40(sp)
    800017b2:	7902                	ld	s2,32(sp)
    800017b4:	6b02                	ld	s6,0(sp)
    800017b6:	a821                	j	800017ce <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800017b8:	864e                	mv	a2,s3
    800017ba:	85ca                	mv	a1,s2
    800017bc:	8556                	mv	a0,s5
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	f42080e7          	jalr	-190(ra) # 80001700 <uvmdealloc>
      return 0;
    800017c6:	4501                	li	a0,0
    800017c8:	74a2                	ld	s1,40(sp)
    800017ca:	7902                	ld	s2,32(sp)
    800017cc:	6b02                	ld	s6,0(sp)
}
    800017ce:	70e2                	ld	ra,56(sp)
    800017d0:	7442                	ld	s0,48(sp)
    800017d2:	69e2                	ld	s3,24(sp)
    800017d4:	6a42                	ld	s4,16(sp)
    800017d6:	6aa2                	ld	s5,8(sp)
    800017d8:	6121                	addi	sp,sp,64
    800017da:	8082                	ret
      kfree(mem);
    800017dc:	8526                	mv	a0,s1
    800017de:	fffff097          	auipc	ra,0xfffff
    800017e2:	3a4080e7          	jalr	932(ra) # 80000b82 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800017e6:	864e                	mv	a2,s3
    800017e8:	85ca                	mv	a1,s2
    800017ea:	8556                	mv	a0,s5
    800017ec:	00000097          	auipc	ra,0x0
    800017f0:	f14080e7          	jalr	-236(ra) # 80001700 <uvmdealloc>
      return 0;
    800017f4:	4501                	li	a0,0
    800017f6:	74a2                	ld	s1,40(sp)
    800017f8:	7902                	ld	s2,32(sp)
    800017fa:	6b02                	ld	s6,0(sp)
    800017fc:	bfc9                	j	800017ce <uvmalloc+0x86>
    return oldsz;
    800017fe:	852e                	mv	a0,a1
}
    80001800:	8082                	ret
  return newsz;
    80001802:	8532                	mv	a0,a2
    80001804:	b7e9                	j	800017ce <uvmalloc+0x86>

0000000080001806 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001806:	7179                	addi	sp,sp,-48
    80001808:	f406                	sd	ra,40(sp)
    8000180a:	f022                	sd	s0,32(sp)
    8000180c:	ec26                	sd	s1,24(sp)
    8000180e:	e84a                	sd	s2,16(sp)
    80001810:	e44e                	sd	s3,8(sp)
    80001812:	e052                	sd	s4,0(sp)
    80001814:	1800                	addi	s0,sp,48
    80001816:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001818:	84aa                	mv	s1,a0
    8000181a:	6905                	lui	s2,0x1
    8000181c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000181e:	4985                	li	s3,1
    80001820:	a829                	j	8000183a <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001822:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001824:	00c79513          	slli	a0,a5,0xc
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	fde080e7          	jalr	-34(ra) # 80001806 <freewalk>
      pagetable[i] = 0;
    80001830:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001834:	04a1                	addi	s1,s1,8
    80001836:	03248163          	beq	s1,s2,80001858 <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000183a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000183c:	00f7f713          	andi	a4,a5,15
    80001840:	ff3701e3          	beq	a4,s3,80001822 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001844:	8b85                	andi	a5,a5,1
    80001846:	d7fd                	beqz	a5,80001834 <freewalk+0x2e>
      panic("freewalk: leaf");
    80001848:	00007517          	auipc	a0,0x7
    8000184c:	97050513          	addi	a0,a0,-1680 # 800081b8 <__func__.1+0x1b0>
    80001850:	fffff097          	auipc	ra,0xfffff
    80001854:	d10080e7          	jalr	-752(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    80001858:	8552                	mv	a0,s4
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	328080e7          	jalr	808(ra) # 80000b82 <kfree>
}
    80001862:	70a2                	ld	ra,40(sp)
    80001864:	7402                	ld	s0,32(sp)
    80001866:	64e2                	ld	s1,24(sp)
    80001868:	6942                	ld	s2,16(sp)
    8000186a:	69a2                	ld	s3,8(sp)
    8000186c:	6a02                	ld	s4,0(sp)
    8000186e:	6145                	addi	sp,sp,48
    80001870:	8082                	ret

0000000080001872 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001872:	1101                	addi	sp,sp,-32
    80001874:	ec06                	sd	ra,24(sp)
    80001876:	e822                	sd	s0,16(sp)
    80001878:	e426                	sd	s1,8(sp)
    8000187a:	1000                	addi	s0,sp,32
    8000187c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000187e:	e999                	bnez	a1,80001894 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001880:	8526                	mv	a0,s1
    80001882:	00000097          	auipc	ra,0x0
    80001886:	f84080e7          	jalr	-124(ra) # 80001806 <freewalk>
}
    8000188a:	60e2                	ld	ra,24(sp)
    8000188c:	6442                	ld	s0,16(sp)
    8000188e:	64a2                	ld	s1,8(sp)
    80001890:	6105                	addi	sp,sp,32
    80001892:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001894:	6785                	lui	a5,0x1
    80001896:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001898:	95be                	add	a1,a1,a5
    8000189a:	4685                	li	a3,1
    8000189c:	00c5d613          	srli	a2,a1,0xc
    800018a0:	4581                	li	a1,0
    800018a2:	00000097          	auipc	ra,0x0
    800018a6:	cea080e7          	jalr	-790(ra) # 8000158c <uvmunmap>
    800018aa:	bfd9                	j	80001880 <uvmfree+0xe>

00000000800018ac <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    800018ac:	c669                	beqz	a2,80001976 <uvmcopy+0xca>
{
    800018ae:	7139                	addi	sp,sp,-64
    800018b0:	fc06                	sd	ra,56(sp)
    800018b2:	f822                	sd	s0,48(sp)
    800018b4:	f426                	sd	s1,40(sp)
    800018b6:	f04a                	sd	s2,32(sp)
    800018b8:	ec4e                	sd	s3,24(sp)
    800018ba:	e852                	sd	s4,16(sp)
    800018bc:	e456                	sd	s5,8(sp)
    800018be:	e05a                	sd	s6,0(sp)
    800018c0:	0080                	addi	s0,sp,64
    800018c2:	8b2a                	mv	s6,a0
    800018c4:	8aae                	mv	s5,a1
    800018c6:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800018c8:	4981                	li	s3,0
    800018ca:	a091                	j	8000190e <uvmcopy+0x62>
    if((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    800018cc:	00007517          	auipc	a0,0x7
    800018d0:	8fc50513          	addi	a0,a0,-1796 # 800081c8 <__func__.1+0x1c0>
    800018d4:	fffff097          	auipc	ra,0xfffff
    800018d8:	c8c080e7          	jalr	-884(ra) # 80000560 <panic>
    if((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    800018dc:	00007517          	auipc	a0,0x7
    800018e0:	90c50513          	addi	a0,a0,-1780 # 800081e8 <__func__.1+0x1e0>
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	c7c080e7          	jalr	-900(ra) # 80000560 <panic>
    if(*pte & PTE_W){
      *pte &= ~PTE_W;
      *pte |= PTE_COW;
    }

    flags = PTE_FLAGS(*pte);
    800018ec:	00093703          	ld	a4,0(s2) # 1000 <_entry-0x7ffff000>
    //if((mem = kalloc()) == 0) goto err;

    //memmove(mem, (char*)pa, PGSIZE);

    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    800018f0:	3ff77713          	andi	a4,a4,1023
    800018f4:	86a6                	mv	a3,s1
    800018f6:	6605                	lui	a2,0x1
    800018f8:	85ce                	mv	a1,s3
    800018fa:	8556                	mv	a0,s5
    800018fc:	00000097          	auipc	ra,0x0
    80001900:	aca080e7          	jalr	-1334(ra) # 800013c6 <mappages>
    80001904:	e529                	bnez	a0,8000194e <uvmcopy+0xa2>
  for(i = 0; i < sz; i += PGSIZE){
    80001906:	6785                	lui	a5,0x1
    80001908:	99be                	add	s3,s3,a5
    8000190a:	0549fc63          	bgeu	s3,s4,80001962 <uvmcopy+0xb6>
    if((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    8000190e:	4601                	li	a2,0
    80001910:	85ce                	mv	a1,s3
    80001912:	855a                	mv	a0,s6
    80001914:	00000097          	auipc	ra,0x0
    80001918:	9ca080e7          	jalr	-1590(ra) # 800012de <walk>
    8000191c:	892a                	mv	s2,a0
    8000191e:	d55d                	beqz	a0,800018cc <uvmcopy+0x20>
    if((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80001920:	6114                	ld	a3,0(a0)
    80001922:	0016f793          	andi	a5,a3,1
    80001926:	dbdd                	beqz	a5,800018dc <uvmcopy+0x30>
    pa = PTE2PA(*pte);
    80001928:	82a9                	srli	a3,a3,0xa
    8000192a:	00c69493          	slli	s1,a3,0xc
    increfcount(pa);
    8000192e:	8526                	mv	a0,s1
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	200080e7          	jalr	512(ra) # 80000b30 <increfcount>
    if(*pte & PTE_W){
    80001938:	00093783          	ld	a5,0(s2)
    8000193c:	0047f713          	andi	a4,a5,4
    80001940:	d755                	beqz	a4,800018ec <uvmcopy+0x40>
      *pte &= ~PTE_W;
    80001942:	9bed                	andi	a5,a5,-5
      *pte |= PTE_COW;
    80001944:	2007e793          	ori	a5,a5,512
    80001948:	00f93023          	sd	a5,0(s2)
    8000194c:	b745                	j	800018ec <uvmcopy+0x40>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000194e:	4685                	li	a3,1
    80001950:	00c9d613          	srli	a2,s3,0xc
    80001954:	4581                	li	a1,0
    80001956:	8556                	mv	a0,s5
    80001958:	00000097          	auipc	ra,0x0
    8000195c:	c34080e7          	jalr	-972(ra) # 8000158c <uvmunmap>
  return -1;
    80001960:	557d                	li	a0,-1
}
    80001962:	70e2                	ld	ra,56(sp)
    80001964:	7442                	ld	s0,48(sp)
    80001966:	74a2                	ld	s1,40(sp)
    80001968:	7902                	ld	s2,32(sp)
    8000196a:	69e2                	ld	s3,24(sp)
    8000196c:	6a42                	ld	s4,16(sp)
    8000196e:	6aa2                	ld	s5,8(sp)
    80001970:	6b02                	ld	s6,0(sp)
    80001972:	6121                	addi	sp,sp,64
    80001974:	8082                	ret
  return 0;
    80001976:	4501                	li	a0,0
}
    80001978:	8082                	ret

000000008000197a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000197a:	1141                	addi	sp,sp,-16
    8000197c:	e406                	sd	ra,8(sp)
    8000197e:	e022                	sd	s0,0(sp)
    80001980:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001982:	4601                	li	a2,0
    80001984:	00000097          	auipc	ra,0x0
    80001988:	95a080e7          	jalr	-1702(ra) # 800012de <walk>
  if(pte == 0)
    8000198c:	c901                	beqz	a0,8000199c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000198e:	611c                	ld	a5,0(a0)
    80001990:	9bbd                	andi	a5,a5,-17
    80001992:	e11c                	sd	a5,0(a0)
}
    80001994:	60a2                	ld	ra,8(sp)
    80001996:	6402                	ld	s0,0(sp)
    80001998:	0141                	addi	sp,sp,16
    8000199a:	8082                	ret
    panic("uvmclear");
    8000199c:	00007517          	auipc	a0,0x7
    800019a0:	86c50513          	addi	a0,a0,-1940 # 80008208 <__func__.1+0x200>
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	bbc080e7          	jalr	-1092(ra) # 80000560 <panic>

00000000800019ac <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800019ac:	c6bd                	beqz	a3,80001a1a <copyout+0x6e>
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	e062                	sd	s8,0(sp)
    800019c4:	0880                	addi	s0,sp,80
    800019c6:	8b2a                	mv	s6,a0
    800019c8:	8c2e                	mv	s8,a1
    800019ca:	8a32                	mv	s4,a2
    800019cc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800019ce:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800019d0:	6a85                	lui	s5,0x1
    800019d2:	a015                	j	800019f6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800019d4:	9562                	add	a0,a0,s8
    800019d6:	0004861b          	sext.w	a2,s1
    800019da:	85d2                	mv	a1,s4
    800019dc:	41250533          	sub	a0,a0,s2
    800019e0:	fffff097          	auipc	ra,0xfffff
    800019e4:	67e080e7          	jalr	1662(ra) # 8000105e <memmove>

    len -= n;
    800019e8:	409989b3          	sub	s3,s3,s1
    src += n;
    800019ec:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800019ee:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800019f2:	02098263          	beqz	s3,80001a16 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800019f6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800019fa:	85ca                	mv	a1,s2
    800019fc:	855a                	mv	a0,s6
    800019fe:	00000097          	auipc	ra,0x0
    80001a02:	986080e7          	jalr	-1658(ra) # 80001384 <walkaddr>
    if(pa0 == 0)
    80001a06:	cd01                	beqz	a0,80001a1e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001a08:	418904b3          	sub	s1,s2,s8
    80001a0c:	94d6                	add	s1,s1,s5
    if(n > len)
    80001a0e:	fc99f3e3          	bgeu	s3,s1,800019d4 <copyout+0x28>
    80001a12:	84ce                	mv	s1,s3
    80001a14:	b7c1                	j	800019d4 <copyout+0x28>
  }
  return 0;
    80001a16:	4501                	li	a0,0
    80001a18:	a021                	j	80001a20 <copyout+0x74>
    80001a1a:	4501                	li	a0,0
}
    80001a1c:	8082                	ret
      return -1;
    80001a1e:	557d                	li	a0,-1
}
    80001a20:	60a6                	ld	ra,72(sp)
    80001a22:	6406                	ld	s0,64(sp)
    80001a24:	74e2                	ld	s1,56(sp)
    80001a26:	7942                	ld	s2,48(sp)
    80001a28:	79a2                	ld	s3,40(sp)
    80001a2a:	7a02                	ld	s4,32(sp)
    80001a2c:	6ae2                	ld	s5,24(sp)
    80001a2e:	6b42                	ld	s6,16(sp)
    80001a30:	6ba2                	ld	s7,8(sp)
    80001a32:	6c02                	ld	s8,0(sp)
    80001a34:	6161                	addi	sp,sp,80
    80001a36:	8082                	ret

0000000080001a38 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001a38:	caa5                	beqz	a3,80001aa8 <copyin+0x70>
{
    80001a3a:	715d                	addi	sp,sp,-80
    80001a3c:	e486                	sd	ra,72(sp)
    80001a3e:	e0a2                	sd	s0,64(sp)
    80001a40:	fc26                	sd	s1,56(sp)
    80001a42:	f84a                	sd	s2,48(sp)
    80001a44:	f44e                	sd	s3,40(sp)
    80001a46:	f052                	sd	s4,32(sp)
    80001a48:	ec56                	sd	s5,24(sp)
    80001a4a:	e85a                	sd	s6,16(sp)
    80001a4c:	e45e                	sd	s7,8(sp)
    80001a4e:	e062                	sd	s8,0(sp)
    80001a50:	0880                	addi	s0,sp,80
    80001a52:	8b2a                	mv	s6,a0
    80001a54:	8a2e                	mv	s4,a1
    80001a56:	8c32                	mv	s8,a2
    80001a58:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001a5a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a5c:	6a85                	lui	s5,0x1
    80001a5e:	a01d                	j	80001a84 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a60:	018505b3          	add	a1,a0,s8
    80001a64:	0004861b          	sext.w	a2,s1
    80001a68:	412585b3          	sub	a1,a1,s2
    80001a6c:	8552                	mv	a0,s4
    80001a6e:	fffff097          	auipc	ra,0xfffff
    80001a72:	5f0080e7          	jalr	1520(ra) # 8000105e <memmove>

    len -= n;
    80001a76:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001a7a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a7c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001a80:	02098263          	beqz	s3,80001aa4 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001a84:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a88:	85ca                	mv	a1,s2
    80001a8a:	855a                	mv	a0,s6
    80001a8c:	00000097          	auipc	ra,0x0
    80001a90:	8f8080e7          	jalr	-1800(ra) # 80001384 <walkaddr>
    if(pa0 == 0)
    80001a94:	cd01                	beqz	a0,80001aac <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001a96:	418904b3          	sub	s1,s2,s8
    80001a9a:	94d6                	add	s1,s1,s5
    if(n > len)
    80001a9c:	fc99f2e3          	bgeu	s3,s1,80001a60 <copyin+0x28>
    80001aa0:	84ce                	mv	s1,s3
    80001aa2:	bf7d                	j	80001a60 <copyin+0x28>
  }
  return 0;
    80001aa4:	4501                	li	a0,0
    80001aa6:	a021                	j	80001aae <copyin+0x76>
    80001aa8:	4501                	li	a0,0
}
    80001aaa:	8082                	ret
      return -1;
    80001aac:	557d                	li	a0,-1
}
    80001aae:	60a6                	ld	ra,72(sp)
    80001ab0:	6406                	ld	s0,64(sp)
    80001ab2:	74e2                	ld	s1,56(sp)
    80001ab4:	7942                	ld	s2,48(sp)
    80001ab6:	79a2                	ld	s3,40(sp)
    80001ab8:	7a02                	ld	s4,32(sp)
    80001aba:	6ae2                	ld	s5,24(sp)
    80001abc:	6b42                	ld	s6,16(sp)
    80001abe:	6ba2                	ld	s7,8(sp)
    80001ac0:	6c02                	ld	s8,0(sp)
    80001ac2:	6161                	addi	sp,sp,80
    80001ac4:	8082                	ret

0000000080001ac6 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001ac6:	cacd                	beqz	a3,80001b78 <copyinstr+0xb2>
{
    80001ac8:	715d                	addi	sp,sp,-80
    80001aca:	e486                	sd	ra,72(sp)
    80001acc:	e0a2                	sd	s0,64(sp)
    80001ace:	fc26                	sd	s1,56(sp)
    80001ad0:	f84a                	sd	s2,48(sp)
    80001ad2:	f44e                	sd	s3,40(sp)
    80001ad4:	f052                	sd	s4,32(sp)
    80001ad6:	ec56                	sd	s5,24(sp)
    80001ad8:	e85a                	sd	s6,16(sp)
    80001ada:	e45e                	sd	s7,8(sp)
    80001adc:	0880                	addi	s0,sp,80
    80001ade:	8a2a                	mv	s4,a0
    80001ae0:	8b2e                	mv	s6,a1
    80001ae2:	8bb2                	mv	s7,a2
    80001ae4:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001ae6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001ae8:	6985                	lui	s3,0x1
    80001aea:	a825                	j	80001b22 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001aec:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001af0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001af2:	37fd                	addiw	a5,a5,-1
    80001af4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001af8:	60a6                	ld	ra,72(sp)
    80001afa:	6406                	ld	s0,64(sp)
    80001afc:	74e2                	ld	s1,56(sp)
    80001afe:	7942                	ld	s2,48(sp)
    80001b00:	79a2                	ld	s3,40(sp)
    80001b02:	7a02                	ld	s4,32(sp)
    80001b04:	6ae2                	ld	s5,24(sp)
    80001b06:	6b42                	ld	s6,16(sp)
    80001b08:	6ba2                	ld	s7,8(sp)
    80001b0a:	6161                	addi	sp,sp,80
    80001b0c:	8082                	ret
    80001b0e:	fff90713          	addi	a4,s2,-1
    80001b12:	9742                	add	a4,a4,a6
      --max;
    80001b14:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001b18:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001b1c:	04e58663          	beq	a1,a4,80001b68 <copyinstr+0xa2>
{
    80001b20:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001b22:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001b26:	85a6                	mv	a1,s1
    80001b28:	8552                	mv	a0,s4
    80001b2a:	00000097          	auipc	ra,0x0
    80001b2e:	85a080e7          	jalr	-1958(ra) # 80001384 <walkaddr>
    if(pa0 == 0)
    80001b32:	cd0d                	beqz	a0,80001b6c <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001b34:	417486b3          	sub	a3,s1,s7
    80001b38:	96ce                	add	a3,a3,s3
    if(n > max)
    80001b3a:	00d97363          	bgeu	s2,a3,80001b40 <copyinstr+0x7a>
    80001b3e:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001b40:	955e                	add	a0,a0,s7
    80001b42:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001b44:	c695                	beqz	a3,80001b70 <copyinstr+0xaa>
    80001b46:	87da                	mv	a5,s6
    80001b48:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001b4a:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001b4e:	96da                	add	a3,a3,s6
    80001b50:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001b52:	00f60733          	add	a4,a2,a5
    80001b56:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffba518>
    80001b5a:	db49                	beqz	a4,80001aec <copyinstr+0x26>
        *dst = *p;
    80001b5c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001b60:	0785                	addi	a5,a5,1
    while(n > 0){
    80001b62:	fed797e3          	bne	a5,a3,80001b50 <copyinstr+0x8a>
    80001b66:	b765                	j	80001b0e <copyinstr+0x48>
    80001b68:	4781                	li	a5,0
    80001b6a:	b761                	j	80001af2 <copyinstr+0x2c>
      return -1;
    80001b6c:	557d                	li	a0,-1
    80001b6e:	b769                	j	80001af8 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001b70:	6b85                	lui	s7,0x1
    80001b72:	9ba6                	add	s7,s7,s1
    80001b74:	87da                	mv	a5,s6
    80001b76:	b76d                	j	80001b20 <copyinstr+0x5a>
  int got_null = 0;
    80001b78:	4781                	li	a5,0
  if(got_null){
    80001b7a:	37fd                	addiw	a5,a5,-1
    80001b7c:	0007851b          	sext.w	a0,a5
}
    80001b80:	8082                	ret

0000000080001b82 <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    80001b82:	715d                	addi	sp,sp,-80
    80001b84:	e486                	sd	ra,72(sp)
    80001b86:	e0a2                	sd	s0,64(sp)
    80001b88:	fc26                	sd	s1,56(sp)
    80001b8a:	f84a                	sd	s2,48(sp)
    80001b8c:	f44e                	sd	s3,40(sp)
    80001b8e:	f052                	sd	s4,32(sp)
    80001b90:	ec56                	sd	s5,24(sp)
    80001b92:	e85a                	sd	s6,16(sp)
    80001b94:	e45e                	sd	s7,8(sp)
    80001b96:	e062                	sd	s8,0(sp)
    80001b98:	0880                	addi	s0,sp,80
    asm volatile("mv %0, tp" : "=r"(x));
    80001b9a:	8792                	mv	a5,tp
    int id = r_tp();
    80001b9c:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001b9e:	00032a97          	auipc	s5,0x32
    80001ba2:	d3aa8a93          	addi	s5,s5,-710 # 800338d8 <cpus>
    80001ba6:	00779713          	slli	a4,a5,0x7
    80001baa:	00ea86b3          	add	a3,s5,a4
    80001bae:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffba518>
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001bb2:	0721                	addi	a4,a4,8
    80001bb4:	9aba                	add	s5,s5,a4
                c->proc = p;
    80001bb6:	8936                	mv	s2,a3
                // check if we are still the right scheduler (or if schedset changed)
                if (sched_pointer != &rr_scheduler)
    80001bb8:	0000ac17          	auipc	s8,0xa
    80001bbc:	9c0c0c13          	addi	s8,s8,-1600 # 8000b578 <sched_pointer>
    80001bc0:	00000b97          	auipc	s7,0x0
    80001bc4:	fc2b8b93          	addi	s7,s7,-62 # 80001b82 <rr_scheduler>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001bc8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001bcc:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001bd0:	10079073          	csrw	sstatus,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001bd4:	00032497          	auipc	s1,0x32
    80001bd8:	13448493          	addi	s1,s1,308 # 80033d08 <proc>
            if (p->state == RUNNABLE)
    80001bdc:	498d                	li	s3,3
                p->state = RUNNING;
    80001bde:	4b11                	li	s6,4
        for (p = proc; p < &proc[NPROC]; p++)
    80001be0:	00038a17          	auipc	s4,0x38
    80001be4:	b28a0a13          	addi	s4,s4,-1240 # 80039708 <tickslock>
    80001be8:	a81d                	j	80001c1e <rr_scheduler+0x9c>
                {
                    release(&p->lock);
    80001bea:	8526                	mv	a0,s1
    80001bec:	fffff097          	auipc	ra,0xfffff
    80001bf0:	3ce080e7          	jalr	974(ra) # 80000fba <release>
                c->proc = 0;
            }
            release(&p->lock);
        }
    }
}
    80001bf4:	60a6                	ld	ra,72(sp)
    80001bf6:	6406                	ld	s0,64(sp)
    80001bf8:	74e2                	ld	s1,56(sp)
    80001bfa:	7942                	ld	s2,48(sp)
    80001bfc:	79a2                	ld	s3,40(sp)
    80001bfe:	7a02                	ld	s4,32(sp)
    80001c00:	6ae2                	ld	s5,24(sp)
    80001c02:	6b42                	ld	s6,16(sp)
    80001c04:	6ba2                	ld	s7,8(sp)
    80001c06:	6c02                	ld	s8,0(sp)
    80001c08:	6161                	addi	sp,sp,80
    80001c0a:	8082                	ret
            release(&p->lock);
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	fffff097          	auipc	ra,0xfffff
    80001c12:	3ac080e7          	jalr	940(ra) # 80000fba <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001c16:	16848493          	addi	s1,s1,360
    80001c1a:	fb4487e3          	beq	s1,s4,80001bc8 <rr_scheduler+0x46>
            acquire(&p->lock);
    80001c1e:	8526                	mv	a0,s1
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	2e6080e7          	jalr	742(ra) # 80000f06 <acquire>
            if (p->state == RUNNABLE)
    80001c28:	4c9c                	lw	a5,24(s1)
    80001c2a:	ff3791e3          	bne	a5,s3,80001c0c <rr_scheduler+0x8a>
                p->state = RUNNING;
    80001c2e:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    80001c32:	00993023          	sd	s1,0(s2)
                swtch(&c->context, &p->context);
    80001c36:	06048593          	addi	a1,s1,96
    80001c3a:	8556                	mv	a0,s5
    80001c3c:	00001097          	auipc	ra,0x1
    80001c40:	05e080e7          	jalr	94(ra) # 80002c9a <swtch>
                if (sched_pointer != &rr_scheduler)
    80001c44:	000c3783          	ld	a5,0(s8)
    80001c48:	fb7791e3          	bne	a5,s7,80001bea <rr_scheduler+0x68>
                c->proc = 0;
    80001c4c:	00093023          	sd	zero,0(s2)
    80001c50:	bf75                	j	80001c0c <rr_scheduler+0x8a>

0000000080001c52 <proc_mapstacks>:
{
    80001c52:	7139                	addi	sp,sp,-64
    80001c54:	fc06                	sd	ra,56(sp)
    80001c56:	f822                	sd	s0,48(sp)
    80001c58:	f426                	sd	s1,40(sp)
    80001c5a:	f04a                	sd	s2,32(sp)
    80001c5c:	ec4e                	sd	s3,24(sp)
    80001c5e:	e852                	sd	s4,16(sp)
    80001c60:	e456                	sd	s5,8(sp)
    80001c62:	e05a                	sd	s6,0(sp)
    80001c64:	0080                	addi	s0,sp,64
    80001c66:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001c68:	00032497          	auipc	s1,0x32
    80001c6c:	0a048493          	addi	s1,s1,160 # 80033d08 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001c70:	8b26                	mv	s6,s1
    80001c72:	04fa5937          	lui	s2,0x4fa5
    80001c76:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001c7a:	0932                	slli	s2,s2,0xc
    80001c7c:	fa590913          	addi	s2,s2,-91
    80001c80:	0932                	slli	s2,s2,0xc
    80001c82:	fa590913          	addi	s2,s2,-91
    80001c86:	0932                	slli	s2,s2,0xc
    80001c88:	fa590913          	addi	s2,s2,-91
    80001c8c:	040009b7          	lui	s3,0x4000
    80001c90:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001c92:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001c94:	00038a97          	auipc	s5,0x38
    80001c98:	a74a8a93          	addi	s5,s5,-1420 # 80039708 <tickslock>
        char *pa = kalloc();
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	0e0080e7          	jalr	224(ra) # 80000d7c <kalloc>
    80001ca4:	862a                	mv	a2,a0
        if (pa == 0)
    80001ca6:	c121                	beqz	a0,80001ce6 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001ca8:	416485b3          	sub	a1,s1,s6
    80001cac:	858d                	srai	a1,a1,0x3
    80001cae:	032585b3          	mul	a1,a1,s2
    80001cb2:	2585                	addiw	a1,a1,1
    80001cb4:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001cb8:	4719                	li	a4,6
    80001cba:	6685                	lui	a3,0x1
    80001cbc:	40b985b3          	sub	a1,s3,a1
    80001cc0:	8552                	mv	a0,s4
    80001cc2:	fffff097          	auipc	ra,0xfffff
    80001cc6:	7a4080e7          	jalr	1956(ra) # 80001466 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001cca:	16848493          	addi	s1,s1,360
    80001cce:	fd5497e3          	bne	s1,s5,80001c9c <proc_mapstacks+0x4a>
}
    80001cd2:	70e2                	ld	ra,56(sp)
    80001cd4:	7442                	ld	s0,48(sp)
    80001cd6:	74a2                	ld	s1,40(sp)
    80001cd8:	7902                	ld	s2,32(sp)
    80001cda:	69e2                	ld	s3,24(sp)
    80001cdc:	6a42                	ld	s4,16(sp)
    80001cde:	6aa2                	ld	s5,8(sp)
    80001ce0:	6b02                	ld	s6,0(sp)
    80001ce2:	6121                	addi	sp,sp,64
    80001ce4:	8082                	ret
            panic("kalloc");
    80001ce6:	00006517          	auipc	a0,0x6
    80001cea:	53250513          	addi	a0,a0,1330 # 80008218 <__func__.1+0x210>
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	872080e7          	jalr	-1934(ra) # 80000560 <panic>

0000000080001cf6 <procinit>:
{
    80001cf6:	7139                	addi	sp,sp,-64
    80001cf8:	fc06                	sd	ra,56(sp)
    80001cfa:	f822                	sd	s0,48(sp)
    80001cfc:	f426                	sd	s1,40(sp)
    80001cfe:	f04a                	sd	s2,32(sp)
    80001d00:	ec4e                	sd	s3,24(sp)
    80001d02:	e852                	sd	s4,16(sp)
    80001d04:	e456                	sd	s5,8(sp)
    80001d06:	e05a                	sd	s6,0(sp)
    80001d08:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001d0a:	00006597          	auipc	a1,0x6
    80001d0e:	51658593          	addi	a1,a1,1302 # 80008220 <__func__.1+0x218>
    80001d12:	00032517          	auipc	a0,0x32
    80001d16:	fc650513          	addi	a0,a0,-58 # 80033cd8 <pid_lock>
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	15c080e7          	jalr	348(ra) # 80000e76 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001d22:	00006597          	auipc	a1,0x6
    80001d26:	50658593          	addi	a1,a1,1286 # 80008228 <__func__.1+0x220>
    80001d2a:	00032517          	auipc	a0,0x32
    80001d2e:	fc650513          	addi	a0,a0,-58 # 80033cf0 <wait_lock>
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	144080e7          	jalr	324(ra) # 80000e76 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d3a:	00032497          	auipc	s1,0x32
    80001d3e:	fce48493          	addi	s1,s1,-50 # 80033d08 <proc>
        initlock(&p->lock, "proc");
    80001d42:	00006b17          	auipc	s6,0x6
    80001d46:	4f6b0b13          	addi	s6,s6,1270 # 80008238 <__func__.1+0x230>
        p->kstack = KSTACK((int)(p - proc));
    80001d4a:	8aa6                	mv	s5,s1
    80001d4c:	04fa5937          	lui	s2,0x4fa5
    80001d50:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001d54:	0932                	slli	s2,s2,0xc
    80001d56:	fa590913          	addi	s2,s2,-91
    80001d5a:	0932                	slli	s2,s2,0xc
    80001d5c:	fa590913          	addi	s2,s2,-91
    80001d60:	0932                	slli	s2,s2,0xc
    80001d62:	fa590913          	addi	s2,s2,-91
    80001d66:	040009b7          	lui	s3,0x4000
    80001d6a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001d6c:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001d6e:	00038a17          	auipc	s4,0x38
    80001d72:	99aa0a13          	addi	s4,s4,-1638 # 80039708 <tickslock>
        initlock(&p->lock, "proc");
    80001d76:	85da                	mv	a1,s6
    80001d78:	8526                	mv	a0,s1
    80001d7a:	fffff097          	auipc	ra,0xfffff
    80001d7e:	0fc080e7          	jalr	252(ra) # 80000e76 <initlock>
        p->state = UNUSED;
    80001d82:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001d86:	415487b3          	sub	a5,s1,s5
    80001d8a:	878d                	srai	a5,a5,0x3
    80001d8c:	032787b3          	mul	a5,a5,s2
    80001d90:	2785                	addiw	a5,a5,1
    80001d92:	00d7979b          	slliw	a5,a5,0xd
    80001d96:	40f987b3          	sub	a5,s3,a5
    80001d9a:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001d9c:	16848493          	addi	s1,s1,360
    80001da0:	fd449be3          	bne	s1,s4,80001d76 <procinit+0x80>
}
    80001da4:	70e2                	ld	ra,56(sp)
    80001da6:	7442                	ld	s0,48(sp)
    80001da8:	74a2                	ld	s1,40(sp)
    80001daa:	7902                	ld	s2,32(sp)
    80001dac:	69e2                	ld	s3,24(sp)
    80001dae:	6a42                	ld	s4,16(sp)
    80001db0:	6aa2                	ld	s5,8(sp)
    80001db2:	6b02                	ld	s6,0(sp)
    80001db4:	6121                	addi	sp,sp,64
    80001db6:	8082                	ret

0000000080001db8 <copy_array>:
{
    80001db8:	1141                	addi	sp,sp,-16
    80001dba:	e422                	sd	s0,8(sp)
    80001dbc:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001dbe:	00c05c63          	blez	a2,80001dd6 <copy_array+0x1e>
    80001dc2:	87aa                	mv	a5,a0
    80001dc4:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001dc6:	0007c703          	lbu	a4,0(a5)
    80001dca:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001dce:	0785                	addi	a5,a5,1
    80001dd0:	0585                	addi	a1,a1,1
    80001dd2:	fea79ae3          	bne	a5,a0,80001dc6 <copy_array+0xe>
}
    80001dd6:	6422                	ld	s0,8(sp)
    80001dd8:	0141                	addi	sp,sp,16
    80001dda:	8082                	ret

0000000080001ddc <cpuid>:
{
    80001ddc:	1141                	addi	sp,sp,-16
    80001dde:	e422                	sd	s0,8(sp)
    80001de0:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80001de2:	8512                	mv	a0,tp
}
    80001de4:	2501                	sext.w	a0,a0
    80001de6:	6422                	ld	s0,8(sp)
    80001de8:	0141                	addi	sp,sp,16
    80001dea:	8082                	ret

0000000080001dec <mycpu>:
{
    80001dec:	1141                	addi	sp,sp,-16
    80001dee:	e422                	sd	s0,8(sp)
    80001df0:	0800                	addi	s0,sp,16
    80001df2:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001df4:	2781                	sext.w	a5,a5
    80001df6:	079e                	slli	a5,a5,0x7
}
    80001df8:	00032517          	auipc	a0,0x32
    80001dfc:	ae050513          	addi	a0,a0,-1312 # 800338d8 <cpus>
    80001e00:	953e                	add	a0,a0,a5
    80001e02:	6422                	ld	s0,8(sp)
    80001e04:	0141                	addi	sp,sp,16
    80001e06:	8082                	ret

0000000080001e08 <myproc>:
{
    80001e08:	1101                	addi	sp,sp,-32
    80001e0a:	ec06                	sd	ra,24(sp)
    80001e0c:	e822                	sd	s0,16(sp)
    80001e0e:	e426                	sd	s1,8(sp)
    80001e10:	1000                	addi	s0,sp,32
    push_off();
    80001e12:	fffff097          	auipc	ra,0xfffff
    80001e16:	0a8080e7          	jalr	168(ra) # 80000eba <push_off>
    80001e1a:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001e1c:	2781                	sext.w	a5,a5
    80001e1e:	079e                	slli	a5,a5,0x7
    80001e20:	00032717          	auipc	a4,0x32
    80001e24:	ab870713          	addi	a4,a4,-1352 # 800338d8 <cpus>
    80001e28:	97ba                	add	a5,a5,a4
    80001e2a:	6384                	ld	s1,0(a5)
    pop_off();
    80001e2c:	fffff097          	auipc	ra,0xfffff
    80001e30:	12e080e7          	jalr	302(ra) # 80000f5a <pop_off>
}
    80001e34:	8526                	mv	a0,s1
    80001e36:	60e2                	ld	ra,24(sp)
    80001e38:	6442                	ld	s0,16(sp)
    80001e3a:	64a2                	ld	s1,8(sp)
    80001e3c:	6105                	addi	sp,sp,32
    80001e3e:	8082                	ret

0000000080001e40 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001e40:	1141                	addi	sp,sp,-16
    80001e42:	e406                	sd	ra,8(sp)
    80001e44:	e022                	sd	s0,0(sp)
    80001e46:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001e48:	00000097          	auipc	ra,0x0
    80001e4c:	fc0080e7          	jalr	-64(ra) # 80001e08 <myproc>
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	16a080e7          	jalr	362(ra) # 80000fba <release>

    if (first)
    80001e58:	00009797          	auipc	a5,0x9
    80001e5c:	7187a783          	lw	a5,1816(a5) # 8000b570 <first.1>
    80001e60:	eb89                	bnez	a5,80001e72 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001e62:	00001097          	auipc	ra,0x1
    80001e66:	ee2080e7          	jalr	-286(ra) # 80002d44 <usertrapret>
}
    80001e6a:	60a2                	ld	ra,8(sp)
    80001e6c:	6402                	ld	s0,0(sp)
    80001e6e:	0141                	addi	sp,sp,16
    80001e70:	8082                	ret
        first = 0;
    80001e72:	00009797          	auipc	a5,0x9
    80001e76:	6e07af23          	sw	zero,1790(a5) # 8000b570 <first.1>
        fsinit(ROOTDEV);
    80001e7a:	4505                	li	a0,1
    80001e7c:	00002097          	auipc	ra,0x2
    80001e80:	e92080e7          	jalr	-366(ra) # 80003d0e <fsinit>
    80001e84:	bff9                	j	80001e62 <forkret+0x22>

0000000080001e86 <allocpid>:
{
    80001e86:	1101                	addi	sp,sp,-32
    80001e88:	ec06                	sd	ra,24(sp)
    80001e8a:	e822                	sd	s0,16(sp)
    80001e8c:	e426                	sd	s1,8(sp)
    80001e8e:	e04a                	sd	s2,0(sp)
    80001e90:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001e92:	00032917          	auipc	s2,0x32
    80001e96:	e4690913          	addi	s2,s2,-442 # 80033cd8 <pid_lock>
    80001e9a:	854a                	mv	a0,s2
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	06a080e7          	jalr	106(ra) # 80000f06 <acquire>
    pid = nextpid;
    80001ea4:	00009797          	auipc	a5,0x9
    80001ea8:	6dc78793          	addi	a5,a5,1756 # 8000b580 <nextpid>
    80001eac:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001eae:	0014871b          	addiw	a4,s1,1
    80001eb2:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001eb4:	854a                	mv	a0,s2
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	104080e7          	jalr	260(ra) # 80000fba <release>
}
    80001ebe:	8526                	mv	a0,s1
    80001ec0:	60e2                	ld	ra,24(sp)
    80001ec2:	6442                	ld	s0,16(sp)
    80001ec4:	64a2                	ld	s1,8(sp)
    80001ec6:	6902                	ld	s2,0(sp)
    80001ec8:	6105                	addi	sp,sp,32
    80001eca:	8082                	ret

0000000080001ecc <proc_pagetable>:
{
    80001ecc:	1101                	addi	sp,sp,-32
    80001ece:	ec06                	sd	ra,24(sp)
    80001ed0:	e822                	sd	s0,16(sp)
    80001ed2:	e426                	sd	s1,8(sp)
    80001ed4:	e04a                	sd	s2,0(sp)
    80001ed6:	1000                	addi	s0,sp,32
    80001ed8:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	786080e7          	jalr	1926(ra) # 80001660 <uvmcreate>
    80001ee2:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001ee4:	c121                	beqz	a0,80001f24 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ee6:	4729                	li	a4,10
    80001ee8:	00005697          	auipc	a3,0x5
    80001eec:	11868693          	addi	a3,a3,280 # 80007000 <_trampoline>
    80001ef0:	6605                	lui	a2,0x1
    80001ef2:	040005b7          	lui	a1,0x4000
    80001ef6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ef8:	05b2                	slli	a1,a1,0xc
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	4cc080e7          	jalr	1228(ra) # 800013c6 <mappages>
    80001f02:	02054863          	bltz	a0,80001f32 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001f06:	4719                	li	a4,6
    80001f08:	05893683          	ld	a3,88(s2)
    80001f0c:	6605                	lui	a2,0x1
    80001f0e:	020005b7          	lui	a1,0x2000
    80001f12:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f14:	05b6                	slli	a1,a1,0xd
    80001f16:	8526                	mv	a0,s1
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	4ae080e7          	jalr	1198(ra) # 800013c6 <mappages>
    80001f20:	02054163          	bltz	a0,80001f42 <proc_pagetable+0x76>
}
    80001f24:	8526                	mv	a0,s1
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6902                	ld	s2,0(sp)
    80001f2e:	6105                	addi	sp,sp,32
    80001f30:	8082                	ret
        uvmfree(pagetable, 0);
    80001f32:	4581                	li	a1,0
    80001f34:	8526                	mv	a0,s1
    80001f36:	00000097          	auipc	ra,0x0
    80001f3a:	93c080e7          	jalr	-1732(ra) # 80001872 <uvmfree>
        return 0;
    80001f3e:	4481                	li	s1,0
    80001f40:	b7d5                	j	80001f24 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f42:	4681                	li	a3,0
    80001f44:	4605                	li	a2,1
    80001f46:	040005b7          	lui	a1,0x4000
    80001f4a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f4c:	05b2                	slli	a1,a1,0xc
    80001f4e:	8526                	mv	a0,s1
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	63c080e7          	jalr	1596(ra) # 8000158c <uvmunmap>
        uvmfree(pagetable, 0);
    80001f58:	4581                	li	a1,0
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	916080e7          	jalr	-1770(ra) # 80001872 <uvmfree>
        return 0;
    80001f64:	4481                	li	s1,0
    80001f66:	bf7d                	j	80001f24 <proc_pagetable+0x58>

0000000080001f68 <proc_freepagetable>:
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	e04a                	sd	s2,0(sp)
    80001f72:	1000                	addi	s0,sp,32
    80001f74:	84aa                	mv	s1,a0
    80001f76:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f78:	4681                	li	a3,0
    80001f7a:	4605                	li	a2,1
    80001f7c:	040005b7          	lui	a1,0x4000
    80001f80:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f82:	05b2                	slli	a1,a1,0xc
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	608080e7          	jalr	1544(ra) # 8000158c <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f8c:	4681                	li	a3,0
    80001f8e:	4605                	li	a2,1
    80001f90:	020005b7          	lui	a1,0x2000
    80001f94:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f96:	05b6                	slli	a1,a1,0xd
    80001f98:	8526                	mv	a0,s1
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	5f2080e7          	jalr	1522(ra) # 8000158c <uvmunmap>
    uvmfree(pagetable, sz);
    80001fa2:	85ca                	mv	a1,s2
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	8cc080e7          	jalr	-1844(ra) # 80001872 <uvmfree>
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6902                	ld	s2,0(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret

0000000080001fba <freeproc>:
{
    80001fba:	1101                	addi	sp,sp,-32
    80001fbc:	ec06                	sd	ra,24(sp)
    80001fbe:	e822                	sd	s0,16(sp)
    80001fc0:	e426                	sd	s1,8(sp)
    80001fc2:	1000                	addi	s0,sp,32
    80001fc4:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001fc6:	6d28                	ld	a0,88(a0)
    80001fc8:	c509                	beqz	a0,80001fd2 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	bb8080e7          	jalr	-1096(ra) # 80000b82 <kfree>
    p->trapframe = 0;
    80001fd2:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001fd6:	68a8                	ld	a0,80(s1)
    80001fd8:	c511                	beqz	a0,80001fe4 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001fda:	64ac                	ld	a1,72(s1)
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	f8c080e7          	jalr	-116(ra) # 80001f68 <proc_freepagetable>
    p->pagetable = 0;
    80001fe4:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001fe8:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001fec:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001ff0:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001ff4:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001ff8:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001ffc:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80002000:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80002004:	0004ac23          	sw	zero,24(s1)
}
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6105                	addi	sp,sp,32
    80002010:	8082                	ret

0000000080002012 <allocproc>:
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	e04a                	sd	s2,0(sp)
    8000201c:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    8000201e:	00032497          	auipc	s1,0x32
    80002022:	cea48493          	addi	s1,s1,-790 # 80033d08 <proc>
    80002026:	00037917          	auipc	s2,0x37
    8000202a:	6e290913          	addi	s2,s2,1762 # 80039708 <tickslock>
        acquire(&p->lock);
    8000202e:	8526                	mv	a0,s1
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	ed6080e7          	jalr	-298(ra) # 80000f06 <acquire>
        if (p->state == UNUSED)
    80002038:	4c9c                	lw	a5,24(s1)
    8000203a:	cf81                	beqz	a5,80002052 <allocproc+0x40>
            release(&p->lock);
    8000203c:	8526                	mv	a0,s1
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	f7c080e7          	jalr	-132(ra) # 80000fba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002046:	16848493          	addi	s1,s1,360
    8000204a:	ff2492e3          	bne	s1,s2,8000202e <allocproc+0x1c>
    return 0;
    8000204e:	4481                	li	s1,0
    80002050:	a889                	j	800020a2 <allocproc+0x90>
    p->pid = allocpid();
    80002052:	00000097          	auipc	ra,0x0
    80002056:	e34080e7          	jalr	-460(ra) # 80001e86 <allocpid>
    8000205a:	d888                	sw	a0,48(s1)
    p->state = USED;
    8000205c:	4785                	li	a5,1
    8000205e:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80002060:	fffff097          	auipc	ra,0xfffff
    80002064:	d1c080e7          	jalr	-740(ra) # 80000d7c <kalloc>
    80002068:	892a                	mv	s2,a0
    8000206a:	eca8                	sd	a0,88(s1)
    8000206c:	c131                	beqz	a0,800020b0 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    8000206e:	8526                	mv	a0,s1
    80002070:	00000097          	auipc	ra,0x0
    80002074:	e5c080e7          	jalr	-420(ra) # 80001ecc <proc_pagetable>
    80002078:	892a                	mv	s2,a0
    8000207a:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    8000207c:	c531                	beqz	a0,800020c8 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    8000207e:	07000613          	li	a2,112
    80002082:	4581                	li	a1,0
    80002084:	06048513          	addi	a0,s1,96
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	f7a080e7          	jalr	-134(ra) # 80001002 <memset>
    p->context.ra = (uint64)forkret;
    80002090:	00000797          	auipc	a5,0x0
    80002094:	db078793          	addi	a5,a5,-592 # 80001e40 <forkret>
    80002098:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    8000209a:	60bc                	ld	a5,64(s1)
    8000209c:	6705                	lui	a4,0x1
    8000209e:	97ba                	add	a5,a5,a4
    800020a0:	f4bc                	sd	a5,104(s1)
}
    800020a2:	8526                	mv	a0,s1
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6902                	ld	s2,0(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret
        freeproc(p);
    800020b0:	8526                	mv	a0,s1
    800020b2:	00000097          	auipc	ra,0x0
    800020b6:	f08080e7          	jalr	-248(ra) # 80001fba <freeproc>
        release(&p->lock);
    800020ba:	8526                	mv	a0,s1
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	efe080e7          	jalr	-258(ra) # 80000fba <release>
        return 0;
    800020c4:	84ca                	mv	s1,s2
    800020c6:	bff1                	j	800020a2 <allocproc+0x90>
        freeproc(p);
    800020c8:	8526                	mv	a0,s1
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	ef0080e7          	jalr	-272(ra) # 80001fba <freeproc>
        release(&p->lock);
    800020d2:	8526                	mv	a0,s1
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	ee6080e7          	jalr	-282(ra) # 80000fba <release>
        return 0;
    800020dc:	84ca                	mv	s1,s2
    800020de:	b7d1                	j	800020a2 <allocproc+0x90>

00000000800020e0 <userinit>:
{
    800020e0:	1101                	addi	sp,sp,-32
    800020e2:	ec06                	sd	ra,24(sp)
    800020e4:	e822                	sd	s0,16(sp)
    800020e6:	e426                	sd	s1,8(sp)
    800020e8:	1000                	addi	s0,sp,32
    p = allocproc();
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	f28080e7          	jalr	-216(ra) # 80002012 <allocproc>
    800020f2:	84aa                	mv	s1,a0
    initproc = p;
    800020f4:	00009797          	auipc	a5,0x9
    800020f8:	54a7ba23          	sd	a0,1364(a5) # 8000b648 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800020fc:	03400613          	li	a2,52
    80002100:	00009597          	auipc	a1,0x9
    80002104:	49058593          	addi	a1,a1,1168 # 8000b590 <initcode>
    80002108:	6928                	ld	a0,80(a0)
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	584080e7          	jalr	1412(ra) # 8000168e <uvmfirst>
    p->sz = PGSIZE;
    80002112:	6785                	lui	a5,0x1
    80002114:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80002116:	6cb8                	ld	a4,88(s1)
    80002118:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    8000211c:	6cb8                	ld	a4,88(s1)
    8000211e:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80002120:	4641                	li	a2,16
    80002122:	00006597          	auipc	a1,0x6
    80002126:	11e58593          	addi	a1,a1,286 # 80008240 <__func__.1+0x238>
    8000212a:	15848513          	addi	a0,s1,344
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	016080e7          	jalr	22(ra) # 80001144 <safestrcpy>
    p->cwd = namei("/");
    80002136:	00006517          	auipc	a0,0x6
    8000213a:	11a50513          	addi	a0,a0,282 # 80008250 <__func__.1+0x248>
    8000213e:	00002097          	auipc	ra,0x2
    80002142:	622080e7          	jalr	1570(ra) # 80004760 <namei>
    80002146:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    8000214a:	478d                	li	a5,3
    8000214c:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000214e:	8526                	mv	a0,s1
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	e6a080e7          	jalr	-406(ra) # 80000fba <release>
}
    80002158:	60e2                	ld	ra,24(sp)
    8000215a:	6442                	ld	s0,16(sp)
    8000215c:	64a2                	ld	s1,8(sp)
    8000215e:	6105                	addi	sp,sp,32
    80002160:	8082                	ret

0000000080002162 <growproc>:
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	e426                	sd	s1,8(sp)
    8000216a:	e04a                	sd	s2,0(sp)
    8000216c:	1000                	addi	s0,sp,32
    8000216e:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002170:	00000097          	auipc	ra,0x0
    80002174:	c98080e7          	jalr	-872(ra) # 80001e08 <myproc>
    80002178:	84aa                	mv	s1,a0
    sz = p->sz;
    8000217a:	652c                	ld	a1,72(a0)
    if (n > 0)
    8000217c:	01204c63          	bgtz	s2,80002194 <growproc+0x32>
    else if (n < 0)
    80002180:	02094663          	bltz	s2,800021ac <growproc+0x4a>
    p->sz = sz;
    80002184:	e4ac                	sd	a1,72(s1)
    return 0;
    80002186:	4501                	li	a0,0
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	64a2                	ld	s1,8(sp)
    8000218e:	6902                	ld	s2,0(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002194:	4691                	li	a3,4
    80002196:	00b90633          	add	a2,s2,a1
    8000219a:	6928                	ld	a0,80(a0)
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	5ac080e7          	jalr	1452(ra) # 80001748 <uvmalloc>
    800021a4:	85aa                	mv	a1,a0
    800021a6:	fd79                	bnez	a0,80002184 <growproc+0x22>
            return -1;
    800021a8:	557d                	li	a0,-1
    800021aa:	bff9                	j	80002188 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800021ac:	00b90633          	add	a2,s2,a1
    800021b0:	6928                	ld	a0,80(a0)
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	54e080e7          	jalr	1358(ra) # 80001700 <uvmdealloc>
    800021ba:	85aa                	mv	a1,a0
    800021bc:	b7e1                	j	80002184 <growproc+0x22>

00000000800021be <ps>:
{
    800021be:	715d                	addi	sp,sp,-80
    800021c0:	e486                	sd	ra,72(sp)
    800021c2:	e0a2                	sd	s0,64(sp)
    800021c4:	fc26                	sd	s1,56(sp)
    800021c6:	f84a                	sd	s2,48(sp)
    800021c8:	f44e                	sd	s3,40(sp)
    800021ca:	f052                	sd	s4,32(sp)
    800021cc:	ec56                	sd	s5,24(sp)
    800021ce:	e85a                	sd	s6,16(sp)
    800021d0:	e45e                	sd	s7,8(sp)
    800021d2:	e062                	sd	s8,0(sp)
    800021d4:	0880                	addi	s0,sp,80
    800021d6:	84aa                	mv	s1,a0
    800021d8:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    800021da:	00000097          	auipc	ra,0x0
    800021de:	c2e080e7          	jalr	-978(ra) # 80001e08 <myproc>
        return result;
    800021e2:	4901                	li	s2,0
    if (count == 0)
    800021e4:	0c0b8663          	beqz	s7,800022b0 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    800021e8:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    800021ec:	003b951b          	slliw	a0,s7,0x3
    800021f0:	0175053b          	addw	a0,a0,s7
    800021f4:	0025151b          	slliw	a0,a0,0x2
    800021f8:	2501                	sext.w	a0,a0
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	f68080e7          	jalr	-152(ra) # 80002162 <growproc>
    80002202:	12054f63          	bltz	a0,80002340 <ps+0x182>
    struct user_proc loc_result[count];
    80002206:	003b9a13          	slli	s4,s7,0x3
    8000220a:	9a5e                	add	s4,s4,s7
    8000220c:	0a0a                	slli	s4,s4,0x2
    8000220e:	00fa0793          	addi	a5,s4,15
    80002212:	8391                	srli	a5,a5,0x4
    80002214:	0792                	slli	a5,a5,0x4
    80002216:	40f10133          	sub	sp,sp,a5
    8000221a:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    8000221c:	16800793          	li	a5,360
    80002220:	02f484b3          	mul	s1,s1,a5
    80002224:	00032797          	auipc	a5,0x32
    80002228:	ae478793          	addi	a5,a5,-1308 # 80033d08 <proc>
    8000222c:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    8000222e:	00037797          	auipc	a5,0x37
    80002232:	4da78793          	addi	a5,a5,1242 # 80039708 <tickslock>
        return result;
    80002236:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80002238:	06f4fc63          	bgeu	s1,a5,800022b0 <ps+0xf2>
    acquire(&wait_lock);
    8000223c:	00032517          	auipc	a0,0x32
    80002240:	ab450513          	addi	a0,a0,-1356 # 80033cf0 <wait_lock>
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	cc2080e7          	jalr	-830(ra) # 80000f06 <acquire>
        if (localCount == count)
    8000224c:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    80002250:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80002252:	00037c17          	auipc	s8,0x37
    80002256:	4b6c0c13          	addi	s8,s8,1206 # 80039708 <tickslock>
    8000225a:	a851                	j	800022ee <ps+0x130>
            loc_result[localCount].state = UNUSED;
    8000225c:	00399793          	slli	a5,s3,0x3
    80002260:	97ce                	add	a5,a5,s3
    80002262:	078a                	slli	a5,a5,0x2
    80002264:	97d6                	add	a5,a5,s5
    80002266:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    8000226a:	8526                	mv	a0,s1
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	d4e080e7          	jalr	-690(ra) # 80000fba <release>
    release(&wait_lock);
    80002274:	00032517          	auipc	a0,0x32
    80002278:	a7c50513          	addi	a0,a0,-1412 # 80033cf0 <wait_lock>
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	d3e080e7          	jalr	-706(ra) # 80000fba <release>
    if (localCount < count)
    80002284:	0179f963          	bgeu	s3,s7,80002296 <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80002288:	00399793          	slli	a5,s3,0x3
    8000228c:	97ce                	add	a5,a5,s3
    8000228e:	078a                	slli	a5,a5,0x2
    80002290:	97d6                	add	a5,a5,s5
    80002292:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80002296:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	b70080e7          	jalr	-1168(ra) # 80001e08 <myproc>
    800022a0:	86d2                	mv	a3,s4
    800022a2:	8656                	mv	a2,s5
    800022a4:	85da                	mv	a1,s6
    800022a6:	6928                	ld	a0,80(a0)
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	704080e7          	jalr	1796(ra) # 800019ac <copyout>
}
    800022b0:	854a                	mv	a0,s2
    800022b2:	fb040113          	addi	sp,s0,-80
    800022b6:	60a6                	ld	ra,72(sp)
    800022b8:	6406                	ld	s0,64(sp)
    800022ba:	74e2                	ld	s1,56(sp)
    800022bc:	7942                	ld	s2,48(sp)
    800022be:	79a2                	ld	s3,40(sp)
    800022c0:	7a02                	ld	s4,32(sp)
    800022c2:	6ae2                	ld	s5,24(sp)
    800022c4:	6b42                	ld	s6,16(sp)
    800022c6:	6ba2                	ld	s7,8(sp)
    800022c8:	6c02                	ld	s8,0(sp)
    800022ca:	6161                	addi	sp,sp,80
    800022cc:	8082                	ret
        release(&p->lock);
    800022ce:	8526                	mv	a0,s1
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	cea080e7          	jalr	-790(ra) # 80000fba <release>
        localCount++;
    800022d8:	2985                	addiw	s3,s3,1
    800022da:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    800022de:	16848493          	addi	s1,s1,360
    800022e2:	f984f9e3          	bgeu	s1,s8,80002274 <ps+0xb6>
        if (localCount == count)
    800022e6:	02490913          	addi	s2,s2,36
    800022ea:	053b8d63          	beq	s7,s3,80002344 <ps+0x186>
        acquire(&p->lock);
    800022ee:	8526                	mv	a0,s1
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	c16080e7          	jalr	-1002(ra) # 80000f06 <acquire>
        if (p->state == UNUSED)
    800022f8:	4c9c                	lw	a5,24(s1)
    800022fa:	d3ad                	beqz	a5,8000225c <ps+0x9e>
        loc_result[localCount].state = p->state;
    800022fc:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002300:	549c                	lw	a5,40(s1)
    80002302:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002306:	54dc                	lw	a5,44(s1)
    80002308:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000230c:	589c                	lw	a5,48(s1)
    8000230e:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002312:	4641                	li	a2,16
    80002314:	85ca                	mv	a1,s2
    80002316:	15848513          	addi	a0,s1,344
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	a9e080e7          	jalr	-1378(ra) # 80001db8 <copy_array>
        if (p->parent != 0) // init
    80002322:	7c88                	ld	a0,56(s1)
    80002324:	d54d                	beqz	a0,800022ce <ps+0x110>
            acquire(&p->parent->lock);
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	be0080e7          	jalr	-1056(ra) # 80000f06 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    8000232e:	7c88                	ld	a0,56(s1)
    80002330:	591c                	lw	a5,48(a0)
    80002332:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	c84080e7          	jalr	-892(ra) # 80000fba <release>
    8000233e:	bf41                	j	800022ce <ps+0x110>
        return result;
    80002340:	4901                	li	s2,0
    80002342:	b7bd                	j	800022b0 <ps+0xf2>
    release(&wait_lock);
    80002344:	00032517          	auipc	a0,0x32
    80002348:	9ac50513          	addi	a0,a0,-1620 # 80033cf0 <wait_lock>
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	c6e080e7          	jalr	-914(ra) # 80000fba <release>
    if (localCount < count)
    80002354:	b789                	j	80002296 <ps+0xd8>

0000000080002356 <fork>:
{
    80002356:	7139                	addi	sp,sp,-64
    80002358:	fc06                	sd	ra,56(sp)
    8000235a:	f822                	sd	s0,48(sp)
    8000235c:	f04a                	sd	s2,32(sp)
    8000235e:	e456                	sd	s5,8(sp)
    80002360:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002362:	00000097          	auipc	ra,0x0
    80002366:	aa6080e7          	jalr	-1370(ra) # 80001e08 <myproc>
    8000236a:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    8000236c:	00000097          	auipc	ra,0x0
    80002370:	ca6080e7          	jalr	-858(ra) # 80002012 <allocproc>
    80002374:	12050063          	beqz	a0,80002494 <fork+0x13e>
    80002378:	e852                	sd	s4,16(sp)
    8000237a:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000237c:	048ab603          	ld	a2,72(s5)
    80002380:	692c                	ld	a1,80(a0)
    80002382:	050ab503          	ld	a0,80(s5)
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	526080e7          	jalr	1318(ra) # 800018ac <uvmcopy>
    8000238e:	04054a63          	bltz	a0,800023e2 <fork+0x8c>
    80002392:	f426                	sd	s1,40(sp)
    80002394:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    80002396:	048ab783          	ld	a5,72(s5)
    8000239a:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    8000239e:	058ab683          	ld	a3,88(s5)
    800023a2:	87b6                	mv	a5,a3
    800023a4:	058a3703          	ld	a4,88(s4)
    800023a8:	12068693          	addi	a3,a3,288
    800023ac:	0007b803          	ld	a6,0(a5)
    800023b0:	6788                	ld	a0,8(a5)
    800023b2:	6b8c                	ld	a1,16(a5)
    800023b4:	6f90                	ld	a2,24(a5)
    800023b6:	01073023          	sd	a6,0(a4)
    800023ba:	e708                	sd	a0,8(a4)
    800023bc:	eb0c                	sd	a1,16(a4)
    800023be:	ef10                	sd	a2,24(a4)
    800023c0:	02078793          	addi	a5,a5,32
    800023c4:	02070713          	addi	a4,a4,32
    800023c8:	fed792e3          	bne	a5,a3,800023ac <fork+0x56>
    np->trapframe->a0 = 0;
    800023cc:	058a3783          	ld	a5,88(s4)
    800023d0:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800023d4:	0d0a8493          	addi	s1,s5,208
    800023d8:	0d0a0913          	addi	s2,s4,208
    800023dc:	150a8993          	addi	s3,s5,336
    800023e0:	a015                	j	80002404 <fork+0xae>
        freeproc(np);
    800023e2:	8552                	mv	a0,s4
    800023e4:	00000097          	auipc	ra,0x0
    800023e8:	bd6080e7          	jalr	-1066(ra) # 80001fba <freeproc>
        release(&np->lock);
    800023ec:	8552                	mv	a0,s4
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	bcc080e7          	jalr	-1076(ra) # 80000fba <release>
        return -1;
    800023f6:	597d                	li	s2,-1
    800023f8:	6a42                	ld	s4,16(sp)
    800023fa:	a071                	j	80002486 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    800023fc:	04a1                	addi	s1,s1,8
    800023fe:	0921                	addi	s2,s2,8
    80002400:	01348b63          	beq	s1,s3,80002416 <fork+0xc0>
        if (p->ofile[i])
    80002404:	6088                	ld	a0,0(s1)
    80002406:	d97d                	beqz	a0,800023fc <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002408:	00003097          	auipc	ra,0x3
    8000240c:	9d0080e7          	jalr	-1584(ra) # 80004dd8 <filedup>
    80002410:	00a93023          	sd	a0,0(s2)
    80002414:	b7e5                	j	800023fc <fork+0xa6>
    np->cwd = idup(p->cwd);
    80002416:	150ab503          	ld	a0,336(s5)
    8000241a:	00002097          	auipc	ra,0x2
    8000241e:	b3a080e7          	jalr	-1222(ra) # 80003f54 <idup>
    80002422:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002426:	4641                	li	a2,16
    80002428:	158a8593          	addi	a1,s5,344
    8000242c:	158a0513          	addi	a0,s4,344
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	d14080e7          	jalr	-748(ra) # 80001144 <safestrcpy>
    pid = np->pid;
    80002438:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000243c:	8552                	mv	a0,s4
    8000243e:	fffff097          	auipc	ra,0xfffff
    80002442:	b7c080e7          	jalr	-1156(ra) # 80000fba <release>
    acquire(&wait_lock);
    80002446:	00032497          	auipc	s1,0x32
    8000244a:	8aa48493          	addi	s1,s1,-1878 # 80033cf0 <wait_lock>
    8000244e:	8526                	mv	a0,s1
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	ab6080e7          	jalr	-1354(ra) # 80000f06 <acquire>
    np->parent = p;
    80002458:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    8000245c:	8526                	mv	a0,s1
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	b5c080e7          	jalr	-1188(ra) # 80000fba <release>
    acquire(&np->lock);
    80002466:	8552                	mv	a0,s4
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	a9e080e7          	jalr	-1378(ra) # 80000f06 <acquire>
    np->state = RUNNABLE;
    80002470:	478d                	li	a5,3
    80002472:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80002476:	8552                	mv	a0,s4
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	b42080e7          	jalr	-1214(ra) # 80000fba <release>
    return pid;
    80002480:	74a2                	ld	s1,40(sp)
    80002482:	69e2                	ld	s3,24(sp)
    80002484:	6a42                	ld	s4,16(sp)
}
    80002486:	854a                	mv	a0,s2
    80002488:	70e2                	ld	ra,56(sp)
    8000248a:	7442                	ld	s0,48(sp)
    8000248c:	7902                	ld	s2,32(sp)
    8000248e:	6aa2                	ld	s5,8(sp)
    80002490:	6121                	addi	sp,sp,64
    80002492:	8082                	ret
        return -1;
    80002494:	597d                	li	s2,-1
    80002496:	bfc5                	j	80002486 <fork+0x130>

0000000080002498 <scheduler>:
{
    80002498:	1101                	addi	sp,sp,-32
    8000249a:	ec06                	sd	ra,24(sp)
    8000249c:	e822                	sd	s0,16(sp)
    8000249e:	e426                	sd	s1,8(sp)
    800024a0:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800024a2:	00009497          	auipc	s1,0x9
    800024a6:	0d648493          	addi	s1,s1,214 # 8000b578 <sched_pointer>
    800024aa:	609c                	ld	a5,0(s1)
    800024ac:	9782                	jalr	a5
    while (1)
    800024ae:	bff5                	j	800024aa <scheduler+0x12>

00000000800024b0 <sched>:
{
    800024b0:	7179                	addi	sp,sp,-48
    800024b2:	f406                	sd	ra,40(sp)
    800024b4:	f022                	sd	s0,32(sp)
    800024b6:	ec26                	sd	s1,24(sp)
    800024b8:	e84a                	sd	s2,16(sp)
    800024ba:	e44e                	sd	s3,8(sp)
    800024bc:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800024be:	00000097          	auipc	ra,0x0
    800024c2:	94a080e7          	jalr	-1718(ra) # 80001e08 <myproc>
    800024c6:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800024c8:	fffff097          	auipc	ra,0xfffff
    800024cc:	9c4080e7          	jalr	-1596(ra) # 80000e8c <holding>
    800024d0:	c53d                	beqz	a0,8000253e <sched+0x8e>
    800024d2:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800024d4:	2781                	sext.w	a5,a5
    800024d6:	079e                	slli	a5,a5,0x7
    800024d8:	00031717          	auipc	a4,0x31
    800024dc:	40070713          	addi	a4,a4,1024 # 800338d8 <cpus>
    800024e0:	97ba                	add	a5,a5,a4
    800024e2:	5fb8                	lw	a4,120(a5)
    800024e4:	4785                	li	a5,1
    800024e6:	06f71463          	bne	a4,a5,8000254e <sched+0x9e>
    if (p->state == RUNNING)
    800024ea:	4c98                	lw	a4,24(s1)
    800024ec:	4791                	li	a5,4
    800024ee:	06f70863          	beq	a4,a5,8000255e <sched+0xae>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800024f2:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800024f6:	8b89                	andi	a5,a5,2
    if (intr_get())
    800024f8:	ebbd                	bnez	a5,8000256e <sched+0xbe>
    asm volatile("mv %0, tp" : "=r"(x));
    800024fa:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800024fc:	00031917          	auipc	s2,0x31
    80002500:	3dc90913          	addi	s2,s2,988 # 800338d8 <cpus>
    80002504:	2781                	sext.w	a5,a5
    80002506:	079e                	slli	a5,a5,0x7
    80002508:	97ca                	add	a5,a5,s2
    8000250a:	07c7a983          	lw	s3,124(a5)
    8000250e:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002510:	2581                	sext.w	a1,a1
    80002512:	059e                	slli	a1,a1,0x7
    80002514:	05a1                	addi	a1,a1,8
    80002516:	95ca                	add	a1,a1,s2
    80002518:	06048513          	addi	a0,s1,96
    8000251c:	00000097          	auipc	ra,0x0
    80002520:	77e080e7          	jalr	1918(ra) # 80002c9a <swtch>
    80002524:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002526:	2781                	sext.w	a5,a5
    80002528:	079e                	slli	a5,a5,0x7
    8000252a:	993e                	add	s2,s2,a5
    8000252c:	07392e23          	sw	s3,124(s2)
}
    80002530:	70a2                	ld	ra,40(sp)
    80002532:	7402                	ld	s0,32(sp)
    80002534:	64e2                	ld	s1,24(sp)
    80002536:	6942                	ld	s2,16(sp)
    80002538:	69a2                	ld	s3,8(sp)
    8000253a:	6145                	addi	sp,sp,48
    8000253c:	8082                	ret
        panic("sched p->lock");
    8000253e:	00006517          	auipc	a0,0x6
    80002542:	d1a50513          	addi	a0,a0,-742 # 80008258 <__func__.1+0x250>
    80002546:	ffffe097          	auipc	ra,0xffffe
    8000254a:	01a080e7          	jalr	26(ra) # 80000560 <panic>
        panic("sched locks");
    8000254e:	00006517          	auipc	a0,0x6
    80002552:	d1a50513          	addi	a0,a0,-742 # 80008268 <__func__.1+0x260>
    80002556:	ffffe097          	auipc	ra,0xffffe
    8000255a:	00a080e7          	jalr	10(ra) # 80000560 <panic>
        panic("sched running");
    8000255e:	00006517          	auipc	a0,0x6
    80002562:	d1a50513          	addi	a0,a0,-742 # 80008278 <__func__.1+0x270>
    80002566:	ffffe097          	auipc	ra,0xffffe
    8000256a:	ffa080e7          	jalr	-6(ra) # 80000560 <panic>
        panic("sched interruptible");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	d1a50513          	addi	a0,a0,-742 # 80008288 <__func__.1+0x280>
    80002576:	ffffe097          	auipc	ra,0xffffe
    8000257a:	fea080e7          	jalr	-22(ra) # 80000560 <panic>

000000008000257e <yield>:
{
    8000257e:	1101                	addi	sp,sp,-32
    80002580:	ec06                	sd	ra,24(sp)
    80002582:	e822                	sd	s0,16(sp)
    80002584:	e426                	sd	s1,8(sp)
    80002586:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80002588:	00000097          	auipc	ra,0x0
    8000258c:	880080e7          	jalr	-1920(ra) # 80001e08 <myproc>
    80002590:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002592:	fffff097          	auipc	ra,0xfffff
    80002596:	974080e7          	jalr	-1676(ra) # 80000f06 <acquire>
    p->state = RUNNABLE;
    8000259a:	478d                	li	a5,3
    8000259c:	cc9c                	sw	a5,24(s1)
    sched();
    8000259e:	00000097          	auipc	ra,0x0
    800025a2:	f12080e7          	jalr	-238(ra) # 800024b0 <sched>
    release(&p->lock);
    800025a6:	8526                	mv	a0,s1
    800025a8:	fffff097          	auipc	ra,0xfffff
    800025ac:	a12080e7          	jalr	-1518(ra) # 80000fba <release>
}
    800025b0:	60e2                	ld	ra,24(sp)
    800025b2:	6442                	ld	s0,16(sp)
    800025b4:	64a2                	ld	s1,8(sp)
    800025b6:	6105                	addi	sp,sp,32
    800025b8:	8082                	ret

00000000800025ba <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800025ba:	7179                	addi	sp,sp,-48
    800025bc:	f406                	sd	ra,40(sp)
    800025be:	f022                	sd	s0,32(sp)
    800025c0:	ec26                	sd	s1,24(sp)
    800025c2:	e84a                	sd	s2,16(sp)
    800025c4:	e44e                	sd	s3,8(sp)
    800025c6:	1800                	addi	s0,sp,48
    800025c8:	89aa                	mv	s3,a0
    800025ca:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800025cc:	00000097          	auipc	ra,0x0
    800025d0:	83c080e7          	jalr	-1988(ra) # 80001e08 <myproc>
    800025d4:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800025d6:	fffff097          	auipc	ra,0xfffff
    800025da:	930080e7          	jalr	-1744(ra) # 80000f06 <acquire>
    release(lk);
    800025de:	854a                	mv	a0,s2
    800025e0:	fffff097          	auipc	ra,0xfffff
    800025e4:	9da080e7          	jalr	-1574(ra) # 80000fba <release>

    // Go to sleep.
    p->chan = chan;
    800025e8:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800025ec:	4789                	li	a5,2
    800025ee:	cc9c                	sw	a5,24(s1)

    sched();
    800025f0:	00000097          	auipc	ra,0x0
    800025f4:	ec0080e7          	jalr	-320(ra) # 800024b0 <sched>

    // Tidy up.
    p->chan = 0;
    800025f8:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800025fc:	8526                	mv	a0,s1
    800025fe:	fffff097          	auipc	ra,0xfffff
    80002602:	9bc080e7          	jalr	-1604(ra) # 80000fba <release>
    acquire(lk);
    80002606:	854a                	mv	a0,s2
    80002608:	fffff097          	auipc	ra,0xfffff
    8000260c:	8fe080e7          	jalr	-1794(ra) # 80000f06 <acquire>
}
    80002610:	70a2                	ld	ra,40(sp)
    80002612:	7402                	ld	s0,32(sp)
    80002614:	64e2                	ld	s1,24(sp)
    80002616:	6942                	ld	s2,16(sp)
    80002618:	69a2                	ld	s3,8(sp)
    8000261a:	6145                	addi	sp,sp,48
    8000261c:	8082                	ret

000000008000261e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000261e:	7139                	addi	sp,sp,-64
    80002620:	fc06                	sd	ra,56(sp)
    80002622:	f822                	sd	s0,48(sp)
    80002624:	f426                	sd	s1,40(sp)
    80002626:	f04a                	sd	s2,32(sp)
    80002628:	ec4e                	sd	s3,24(sp)
    8000262a:	e852                	sd	s4,16(sp)
    8000262c:	e456                	sd	s5,8(sp)
    8000262e:	0080                	addi	s0,sp,64
    80002630:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002632:	00031497          	auipc	s1,0x31
    80002636:	6d648493          	addi	s1,s1,1750 # 80033d08 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    8000263a:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000263c:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000263e:	00037917          	auipc	s2,0x37
    80002642:	0ca90913          	addi	s2,s2,202 # 80039708 <tickslock>
    80002646:	a811                	j	8000265a <wakeup+0x3c>
            }
            release(&p->lock);
    80002648:	8526                	mv	a0,s1
    8000264a:	fffff097          	auipc	ra,0xfffff
    8000264e:	970080e7          	jalr	-1680(ra) # 80000fba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002652:	16848493          	addi	s1,s1,360
    80002656:	03248663          	beq	s1,s2,80002682 <wakeup+0x64>
        if (p != myproc())
    8000265a:	fffff097          	auipc	ra,0xfffff
    8000265e:	7ae080e7          	jalr	1966(ra) # 80001e08 <myproc>
    80002662:	fea488e3          	beq	s1,a0,80002652 <wakeup+0x34>
            acquire(&p->lock);
    80002666:	8526                	mv	a0,s1
    80002668:	fffff097          	auipc	ra,0xfffff
    8000266c:	89e080e7          	jalr	-1890(ra) # 80000f06 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80002670:	4c9c                	lw	a5,24(s1)
    80002672:	fd379be3          	bne	a5,s3,80002648 <wakeup+0x2a>
    80002676:	709c                	ld	a5,32(s1)
    80002678:	fd4798e3          	bne	a5,s4,80002648 <wakeup+0x2a>
                p->state = RUNNABLE;
    8000267c:	0154ac23          	sw	s5,24(s1)
    80002680:	b7e1                	j	80002648 <wakeup+0x2a>
        }
    }
}
    80002682:	70e2                	ld	ra,56(sp)
    80002684:	7442                	ld	s0,48(sp)
    80002686:	74a2                	ld	s1,40(sp)
    80002688:	7902                	ld	s2,32(sp)
    8000268a:	69e2                	ld	s3,24(sp)
    8000268c:	6a42                	ld	s4,16(sp)
    8000268e:	6aa2                	ld	s5,8(sp)
    80002690:	6121                	addi	sp,sp,64
    80002692:	8082                	ret

0000000080002694 <reparent>:
{
    80002694:	7179                	addi	sp,sp,-48
    80002696:	f406                	sd	ra,40(sp)
    80002698:	f022                	sd	s0,32(sp)
    8000269a:	ec26                	sd	s1,24(sp)
    8000269c:	e84a                	sd	s2,16(sp)
    8000269e:	e44e                	sd	s3,8(sp)
    800026a0:	e052                	sd	s4,0(sp)
    800026a2:	1800                	addi	s0,sp,48
    800026a4:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800026a6:	00031497          	auipc	s1,0x31
    800026aa:	66248493          	addi	s1,s1,1634 # 80033d08 <proc>
            pp->parent = initproc;
    800026ae:	00009a17          	auipc	s4,0x9
    800026b2:	f9aa0a13          	addi	s4,s4,-102 # 8000b648 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800026b6:	00037997          	auipc	s3,0x37
    800026ba:	05298993          	addi	s3,s3,82 # 80039708 <tickslock>
    800026be:	a029                	j	800026c8 <reparent+0x34>
    800026c0:	16848493          	addi	s1,s1,360
    800026c4:	01348d63          	beq	s1,s3,800026de <reparent+0x4a>
        if (pp->parent == p)
    800026c8:	7c9c                	ld	a5,56(s1)
    800026ca:	ff279be3          	bne	a5,s2,800026c0 <reparent+0x2c>
            pp->parent = initproc;
    800026ce:	000a3503          	ld	a0,0(s4)
    800026d2:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800026d4:	00000097          	auipc	ra,0x0
    800026d8:	f4a080e7          	jalr	-182(ra) # 8000261e <wakeup>
    800026dc:	b7d5                	j	800026c0 <reparent+0x2c>
}
    800026de:	70a2                	ld	ra,40(sp)
    800026e0:	7402                	ld	s0,32(sp)
    800026e2:	64e2                	ld	s1,24(sp)
    800026e4:	6942                	ld	s2,16(sp)
    800026e6:	69a2                	ld	s3,8(sp)
    800026e8:	6a02                	ld	s4,0(sp)
    800026ea:	6145                	addi	sp,sp,48
    800026ec:	8082                	ret

00000000800026ee <exit>:
{
    800026ee:	7179                	addi	sp,sp,-48
    800026f0:	f406                	sd	ra,40(sp)
    800026f2:	f022                	sd	s0,32(sp)
    800026f4:	ec26                	sd	s1,24(sp)
    800026f6:	e84a                	sd	s2,16(sp)
    800026f8:	e44e                	sd	s3,8(sp)
    800026fa:	e052                	sd	s4,0(sp)
    800026fc:	1800                	addi	s0,sp,48
    800026fe:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002700:	fffff097          	auipc	ra,0xfffff
    80002704:	708080e7          	jalr	1800(ra) # 80001e08 <myproc>
    80002708:	89aa                	mv	s3,a0
    if (p == initproc)
    8000270a:	00009797          	auipc	a5,0x9
    8000270e:	f3e7b783          	ld	a5,-194(a5) # 8000b648 <initproc>
    80002712:	0d050493          	addi	s1,a0,208
    80002716:	15050913          	addi	s2,a0,336
    8000271a:	02a79363          	bne	a5,a0,80002740 <exit+0x52>
        panic("init exiting");
    8000271e:	00006517          	auipc	a0,0x6
    80002722:	b8250513          	addi	a0,a0,-1150 # 800082a0 <__func__.1+0x298>
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	e3a080e7          	jalr	-454(ra) # 80000560 <panic>
            fileclose(f);
    8000272e:	00002097          	auipc	ra,0x2
    80002732:	6fc080e7          	jalr	1788(ra) # 80004e2a <fileclose>
            p->ofile[fd] = 0;
    80002736:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    8000273a:	04a1                	addi	s1,s1,8
    8000273c:	01248563          	beq	s1,s2,80002746 <exit+0x58>
        if (p->ofile[fd])
    80002740:	6088                	ld	a0,0(s1)
    80002742:	f575                	bnez	a0,8000272e <exit+0x40>
    80002744:	bfdd                	j	8000273a <exit+0x4c>
    begin_op();
    80002746:	00002097          	auipc	ra,0x2
    8000274a:	21a080e7          	jalr	538(ra) # 80004960 <begin_op>
    iput(p->cwd);
    8000274e:	1509b503          	ld	a0,336(s3)
    80002752:	00002097          	auipc	ra,0x2
    80002756:	9fe080e7          	jalr	-1538(ra) # 80004150 <iput>
    end_op();
    8000275a:	00002097          	auipc	ra,0x2
    8000275e:	280080e7          	jalr	640(ra) # 800049da <end_op>
    p->cwd = 0;
    80002762:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80002766:	00031497          	auipc	s1,0x31
    8000276a:	58a48493          	addi	s1,s1,1418 # 80033cf0 <wait_lock>
    8000276e:	8526                	mv	a0,s1
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	796080e7          	jalr	1942(ra) # 80000f06 <acquire>
    reparent(p);
    80002778:	854e                	mv	a0,s3
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	f1a080e7          	jalr	-230(ra) # 80002694 <reparent>
    wakeup(p->parent);
    80002782:	0389b503          	ld	a0,56(s3)
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	e98080e7          	jalr	-360(ra) # 8000261e <wakeup>
    acquire(&p->lock);
    8000278e:	854e                	mv	a0,s3
    80002790:	ffffe097          	auipc	ra,0xffffe
    80002794:	776080e7          	jalr	1910(ra) # 80000f06 <acquire>
    p->xstate = status;
    80002798:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000279c:	4795                	li	a5,5
    8000279e:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800027a2:	8526                	mv	a0,s1
    800027a4:	fffff097          	auipc	ra,0xfffff
    800027a8:	816080e7          	jalr	-2026(ra) # 80000fba <release>
    sched();
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	d04080e7          	jalr	-764(ra) # 800024b0 <sched>
    panic("zombie exit");
    800027b4:	00006517          	auipc	a0,0x6
    800027b8:	afc50513          	addi	a0,a0,-1284 # 800082b0 <__func__.1+0x2a8>
    800027bc:	ffffe097          	auipc	ra,0xffffe
    800027c0:	da4080e7          	jalr	-604(ra) # 80000560 <panic>

00000000800027c4 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800027c4:	7179                	addi	sp,sp,-48
    800027c6:	f406                	sd	ra,40(sp)
    800027c8:	f022                	sd	s0,32(sp)
    800027ca:	ec26                	sd	s1,24(sp)
    800027cc:	e84a                	sd	s2,16(sp)
    800027ce:	e44e                	sd	s3,8(sp)
    800027d0:	1800                	addi	s0,sp,48
    800027d2:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800027d4:	00031497          	auipc	s1,0x31
    800027d8:	53448493          	addi	s1,s1,1332 # 80033d08 <proc>
    800027dc:	00037997          	auipc	s3,0x37
    800027e0:	f2c98993          	addi	s3,s3,-212 # 80039708 <tickslock>
    {
        acquire(&p->lock);
    800027e4:	8526                	mv	a0,s1
    800027e6:	ffffe097          	auipc	ra,0xffffe
    800027ea:	720080e7          	jalr	1824(ra) # 80000f06 <acquire>
        if (p->pid == pid)
    800027ee:	589c                	lw	a5,48(s1)
    800027f0:	01278d63          	beq	a5,s2,8000280a <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800027f4:	8526                	mv	a0,s1
    800027f6:	ffffe097          	auipc	ra,0xffffe
    800027fa:	7c4080e7          	jalr	1988(ra) # 80000fba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800027fe:	16848493          	addi	s1,s1,360
    80002802:	ff3491e3          	bne	s1,s3,800027e4 <kill+0x20>
    }
    return -1;
    80002806:	557d                	li	a0,-1
    80002808:	a829                	j	80002822 <kill+0x5e>
            p->killed = 1;
    8000280a:	4785                	li	a5,1
    8000280c:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000280e:	4c98                	lw	a4,24(s1)
    80002810:	4789                	li	a5,2
    80002812:	00f70f63          	beq	a4,a5,80002830 <kill+0x6c>
            release(&p->lock);
    80002816:	8526                	mv	a0,s1
    80002818:	ffffe097          	auipc	ra,0xffffe
    8000281c:	7a2080e7          	jalr	1954(ra) # 80000fba <release>
            return 0;
    80002820:	4501                	li	a0,0
}
    80002822:	70a2                	ld	ra,40(sp)
    80002824:	7402                	ld	s0,32(sp)
    80002826:	64e2                	ld	s1,24(sp)
    80002828:	6942                	ld	s2,16(sp)
    8000282a:	69a2                	ld	s3,8(sp)
    8000282c:	6145                	addi	sp,sp,48
    8000282e:	8082                	ret
                p->state = RUNNABLE;
    80002830:	478d                	li	a5,3
    80002832:	cc9c                	sw	a5,24(s1)
    80002834:	b7cd                	j	80002816 <kill+0x52>

0000000080002836 <setkilled>:

void setkilled(struct proc *p)
{
    80002836:	1101                	addi	sp,sp,-32
    80002838:	ec06                	sd	ra,24(sp)
    8000283a:	e822                	sd	s0,16(sp)
    8000283c:	e426                	sd	s1,8(sp)
    8000283e:	1000                	addi	s0,sp,32
    80002840:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002842:	ffffe097          	auipc	ra,0xffffe
    80002846:	6c4080e7          	jalr	1732(ra) # 80000f06 <acquire>
    p->killed = 1;
    8000284a:	4785                	li	a5,1
    8000284c:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000284e:	8526                	mv	a0,s1
    80002850:	ffffe097          	auipc	ra,0xffffe
    80002854:	76a080e7          	jalr	1898(ra) # 80000fba <release>
}
    80002858:	60e2                	ld	ra,24(sp)
    8000285a:	6442                	ld	s0,16(sp)
    8000285c:	64a2                	ld	s1,8(sp)
    8000285e:	6105                	addi	sp,sp,32
    80002860:	8082                	ret

0000000080002862 <killed>:

int killed(struct proc *p)
{
    80002862:	1101                	addi	sp,sp,-32
    80002864:	ec06                	sd	ra,24(sp)
    80002866:	e822                	sd	s0,16(sp)
    80002868:	e426                	sd	s1,8(sp)
    8000286a:	e04a                	sd	s2,0(sp)
    8000286c:	1000                	addi	s0,sp,32
    8000286e:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	696080e7          	jalr	1686(ra) # 80000f06 <acquire>
    k = p->killed;
    80002878:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    8000287c:	8526                	mv	a0,s1
    8000287e:	ffffe097          	auipc	ra,0xffffe
    80002882:	73c080e7          	jalr	1852(ra) # 80000fba <release>
    return k;
}
    80002886:	854a                	mv	a0,s2
    80002888:	60e2                	ld	ra,24(sp)
    8000288a:	6442                	ld	s0,16(sp)
    8000288c:	64a2                	ld	s1,8(sp)
    8000288e:	6902                	ld	s2,0(sp)
    80002890:	6105                	addi	sp,sp,32
    80002892:	8082                	ret

0000000080002894 <wait>:
{
    80002894:	715d                	addi	sp,sp,-80
    80002896:	e486                	sd	ra,72(sp)
    80002898:	e0a2                	sd	s0,64(sp)
    8000289a:	fc26                	sd	s1,56(sp)
    8000289c:	f84a                	sd	s2,48(sp)
    8000289e:	f44e                	sd	s3,40(sp)
    800028a0:	f052                	sd	s4,32(sp)
    800028a2:	ec56                	sd	s5,24(sp)
    800028a4:	e85a                	sd	s6,16(sp)
    800028a6:	e45e                	sd	s7,8(sp)
    800028a8:	e062                	sd	s8,0(sp)
    800028aa:	0880                	addi	s0,sp,80
    800028ac:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800028ae:	fffff097          	auipc	ra,0xfffff
    800028b2:	55a080e7          	jalr	1370(ra) # 80001e08 <myproc>
    800028b6:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800028b8:	00031517          	auipc	a0,0x31
    800028bc:	43850513          	addi	a0,a0,1080 # 80033cf0 <wait_lock>
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	646080e7          	jalr	1606(ra) # 80000f06 <acquire>
        havekids = 0;
    800028c8:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    800028ca:	4a15                	li	s4,5
                havekids = 1;
    800028cc:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800028ce:	00037997          	auipc	s3,0x37
    800028d2:	e3a98993          	addi	s3,s3,-454 # 80039708 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800028d6:	00031c17          	auipc	s8,0x31
    800028da:	41ac0c13          	addi	s8,s8,1050 # 80033cf0 <wait_lock>
    800028de:	a0d1                	j	800029a2 <wait+0x10e>
                    pid = pp->pid;
    800028e0:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800028e4:	000b0e63          	beqz	s6,80002900 <wait+0x6c>
    800028e8:	4691                	li	a3,4
    800028ea:	02c48613          	addi	a2,s1,44
    800028ee:	85da                	mv	a1,s6
    800028f0:	05093503          	ld	a0,80(s2)
    800028f4:	fffff097          	auipc	ra,0xfffff
    800028f8:	0b8080e7          	jalr	184(ra) # 800019ac <copyout>
    800028fc:	04054163          	bltz	a0,8000293e <wait+0xaa>
                    freeproc(pp);
    80002900:	8526                	mv	a0,s1
    80002902:	fffff097          	auipc	ra,0xfffff
    80002906:	6b8080e7          	jalr	1720(ra) # 80001fba <freeproc>
                    release(&pp->lock);
    8000290a:	8526                	mv	a0,s1
    8000290c:	ffffe097          	auipc	ra,0xffffe
    80002910:	6ae080e7          	jalr	1710(ra) # 80000fba <release>
                    release(&wait_lock);
    80002914:	00031517          	auipc	a0,0x31
    80002918:	3dc50513          	addi	a0,a0,988 # 80033cf0 <wait_lock>
    8000291c:	ffffe097          	auipc	ra,0xffffe
    80002920:	69e080e7          	jalr	1694(ra) # 80000fba <release>
}
    80002924:	854e                	mv	a0,s3
    80002926:	60a6                	ld	ra,72(sp)
    80002928:	6406                	ld	s0,64(sp)
    8000292a:	74e2                	ld	s1,56(sp)
    8000292c:	7942                	ld	s2,48(sp)
    8000292e:	79a2                	ld	s3,40(sp)
    80002930:	7a02                	ld	s4,32(sp)
    80002932:	6ae2                	ld	s5,24(sp)
    80002934:	6b42                	ld	s6,16(sp)
    80002936:	6ba2                	ld	s7,8(sp)
    80002938:	6c02                	ld	s8,0(sp)
    8000293a:	6161                	addi	sp,sp,80
    8000293c:	8082                	ret
                        release(&pp->lock);
    8000293e:	8526                	mv	a0,s1
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	67a080e7          	jalr	1658(ra) # 80000fba <release>
                        release(&wait_lock);
    80002948:	00031517          	auipc	a0,0x31
    8000294c:	3a850513          	addi	a0,a0,936 # 80033cf0 <wait_lock>
    80002950:	ffffe097          	auipc	ra,0xffffe
    80002954:	66a080e7          	jalr	1642(ra) # 80000fba <release>
                        return -1;
    80002958:	59fd                	li	s3,-1
    8000295a:	b7e9                	j	80002924 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000295c:	16848493          	addi	s1,s1,360
    80002960:	03348463          	beq	s1,s3,80002988 <wait+0xf4>
            if (pp->parent == p)
    80002964:	7c9c                	ld	a5,56(s1)
    80002966:	ff279be3          	bne	a5,s2,8000295c <wait+0xc8>
                acquire(&pp->lock);
    8000296a:	8526                	mv	a0,s1
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	59a080e7          	jalr	1434(ra) # 80000f06 <acquire>
                if (pp->state == ZOMBIE)
    80002974:	4c9c                	lw	a5,24(s1)
    80002976:	f74785e3          	beq	a5,s4,800028e0 <wait+0x4c>
                release(&pp->lock);
    8000297a:	8526                	mv	a0,s1
    8000297c:	ffffe097          	auipc	ra,0xffffe
    80002980:	63e080e7          	jalr	1598(ra) # 80000fba <release>
                havekids = 1;
    80002984:	8756                	mv	a4,s5
    80002986:	bfd9                	j	8000295c <wait+0xc8>
        if (!havekids || killed(p))
    80002988:	c31d                	beqz	a4,800029ae <wait+0x11a>
    8000298a:	854a                	mv	a0,s2
    8000298c:	00000097          	auipc	ra,0x0
    80002990:	ed6080e7          	jalr	-298(ra) # 80002862 <killed>
    80002994:	ed09                	bnez	a0,800029ae <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002996:	85e2                	mv	a1,s8
    80002998:	854a                	mv	a0,s2
    8000299a:	00000097          	auipc	ra,0x0
    8000299e:	c20080e7          	jalr	-992(ra) # 800025ba <sleep>
        havekids = 0;
    800029a2:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800029a4:	00031497          	auipc	s1,0x31
    800029a8:	36448493          	addi	s1,s1,868 # 80033d08 <proc>
    800029ac:	bf65                	j	80002964 <wait+0xd0>
            release(&wait_lock);
    800029ae:	00031517          	auipc	a0,0x31
    800029b2:	34250513          	addi	a0,a0,834 # 80033cf0 <wait_lock>
    800029b6:	ffffe097          	auipc	ra,0xffffe
    800029ba:	604080e7          	jalr	1540(ra) # 80000fba <release>
            return -1;
    800029be:	59fd                	li	s3,-1
    800029c0:	b795                	j	80002924 <wait+0x90>

00000000800029c2 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800029c2:	7179                	addi	sp,sp,-48
    800029c4:	f406                	sd	ra,40(sp)
    800029c6:	f022                	sd	s0,32(sp)
    800029c8:	ec26                	sd	s1,24(sp)
    800029ca:	e84a                	sd	s2,16(sp)
    800029cc:	e44e                	sd	s3,8(sp)
    800029ce:	e052                	sd	s4,0(sp)
    800029d0:	1800                	addi	s0,sp,48
    800029d2:	84aa                	mv	s1,a0
    800029d4:	892e                	mv	s2,a1
    800029d6:	89b2                	mv	s3,a2
    800029d8:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800029da:	fffff097          	auipc	ra,0xfffff
    800029de:	42e080e7          	jalr	1070(ra) # 80001e08 <myproc>
    if (user_dst)
    800029e2:	c08d                	beqz	s1,80002a04 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    800029e4:	86d2                	mv	a3,s4
    800029e6:	864e                	mv	a2,s3
    800029e8:	85ca                	mv	a1,s2
    800029ea:	6928                	ld	a0,80(a0)
    800029ec:	fffff097          	auipc	ra,0xfffff
    800029f0:	fc0080e7          	jalr	-64(ra) # 800019ac <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    800029f4:	70a2                	ld	ra,40(sp)
    800029f6:	7402                	ld	s0,32(sp)
    800029f8:	64e2                	ld	s1,24(sp)
    800029fa:	6942                	ld	s2,16(sp)
    800029fc:	69a2                	ld	s3,8(sp)
    800029fe:	6a02                	ld	s4,0(sp)
    80002a00:	6145                	addi	sp,sp,48
    80002a02:	8082                	ret
        memmove((char *)dst, src, len);
    80002a04:	000a061b          	sext.w	a2,s4
    80002a08:	85ce                	mv	a1,s3
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	ffffe097          	auipc	ra,0xffffe
    80002a10:	652080e7          	jalr	1618(ra) # 8000105e <memmove>
        return 0;
    80002a14:	8526                	mv	a0,s1
    80002a16:	bff9                	j	800029f4 <either_copyout+0x32>

0000000080002a18 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a18:	7179                	addi	sp,sp,-48
    80002a1a:	f406                	sd	ra,40(sp)
    80002a1c:	f022                	sd	s0,32(sp)
    80002a1e:	ec26                	sd	s1,24(sp)
    80002a20:	e84a                	sd	s2,16(sp)
    80002a22:	e44e                	sd	s3,8(sp)
    80002a24:	e052                	sd	s4,0(sp)
    80002a26:	1800                	addi	s0,sp,48
    80002a28:	892a                	mv	s2,a0
    80002a2a:	84ae                	mv	s1,a1
    80002a2c:	89b2                	mv	s3,a2
    80002a2e:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002a30:	fffff097          	auipc	ra,0xfffff
    80002a34:	3d8080e7          	jalr	984(ra) # 80001e08 <myproc>
    if (user_src)
    80002a38:	c08d                	beqz	s1,80002a5a <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002a3a:	86d2                	mv	a3,s4
    80002a3c:	864e                	mv	a2,s3
    80002a3e:	85ca                	mv	a1,s2
    80002a40:	6928                	ld	a0,80(a0)
    80002a42:	fffff097          	auipc	ra,0xfffff
    80002a46:	ff6080e7          	jalr	-10(ra) # 80001a38 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002a4a:	70a2                	ld	ra,40(sp)
    80002a4c:	7402                	ld	s0,32(sp)
    80002a4e:	64e2                	ld	s1,24(sp)
    80002a50:	6942                	ld	s2,16(sp)
    80002a52:	69a2                	ld	s3,8(sp)
    80002a54:	6a02                	ld	s4,0(sp)
    80002a56:	6145                	addi	sp,sp,48
    80002a58:	8082                	ret
        memmove(dst, (char *)src, len);
    80002a5a:	000a061b          	sext.w	a2,s4
    80002a5e:	85ce                	mv	a1,s3
    80002a60:	854a                	mv	a0,s2
    80002a62:	ffffe097          	auipc	ra,0xffffe
    80002a66:	5fc080e7          	jalr	1532(ra) # 8000105e <memmove>
        return 0;
    80002a6a:	8526                	mv	a0,s1
    80002a6c:	bff9                	j	80002a4a <either_copyin+0x32>

0000000080002a6e <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002a6e:	715d                	addi	sp,sp,-80
    80002a70:	e486                	sd	ra,72(sp)
    80002a72:	e0a2                	sd	s0,64(sp)
    80002a74:	fc26                	sd	s1,56(sp)
    80002a76:	f84a                	sd	s2,48(sp)
    80002a78:	f44e                	sd	s3,40(sp)
    80002a7a:	f052                	sd	s4,32(sp)
    80002a7c:	ec56                	sd	s5,24(sp)
    80002a7e:	e85a                	sd	s6,16(sp)
    80002a80:	e45e                	sd	s7,8(sp)
    80002a82:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002a84:	00005517          	auipc	a0,0x5
    80002a88:	59c50513          	addi	a0,a0,1436 # 80008020 <__func__.1+0x18>
    80002a8c:	ffffe097          	auipc	ra,0xffffe
    80002a90:	b30080e7          	jalr	-1232(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a94:	00031497          	auipc	s1,0x31
    80002a98:	3cc48493          	addi	s1,s1,972 # 80033e60 <proc+0x158>
    80002a9c:	00037917          	auipc	s2,0x37
    80002aa0:	dc490913          	addi	s2,s2,-572 # 80039860 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002aa4:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002aa6:	00006997          	auipc	s3,0x6
    80002aaa:	81a98993          	addi	s3,s3,-2022 # 800082c0 <__func__.1+0x2b8>
        printf("%d <%s %s", p->pid, state, p->name);
    80002aae:	00006a97          	auipc	s5,0x6
    80002ab2:	81aa8a93          	addi	s5,s5,-2022 # 800082c8 <__func__.1+0x2c0>
        printf("\n");
    80002ab6:	00005a17          	auipc	s4,0x5
    80002aba:	56aa0a13          	addi	s4,s4,1386 # 80008020 <__func__.1+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002abe:	00006b97          	auipc	s7,0x6
    80002ac2:	dc2b8b93          	addi	s7,s7,-574 # 80008880 <states.0>
    80002ac6:	a00d                	j	80002ae8 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002ac8:	ed86a583          	lw	a1,-296(a3)
    80002acc:	8556                	mv	a0,s5
    80002ace:	ffffe097          	auipc	ra,0xffffe
    80002ad2:	aee080e7          	jalr	-1298(ra) # 800005bc <printf>
        printf("\n");
    80002ad6:	8552                	mv	a0,s4
    80002ad8:	ffffe097          	auipc	ra,0xffffe
    80002adc:	ae4080e7          	jalr	-1308(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002ae0:	16848493          	addi	s1,s1,360
    80002ae4:	03248263          	beq	s1,s2,80002b08 <procdump+0x9a>
        if (p->state == UNUSED)
    80002ae8:	86a6                	mv	a3,s1
    80002aea:	ec04a783          	lw	a5,-320(s1)
    80002aee:	dbed                	beqz	a5,80002ae0 <procdump+0x72>
            state = "???";
    80002af0:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002af2:	fcfb6be3          	bltu	s6,a5,80002ac8 <procdump+0x5a>
    80002af6:	02079713          	slli	a4,a5,0x20
    80002afa:	01d75793          	srli	a5,a4,0x1d
    80002afe:	97de                	add	a5,a5,s7
    80002b00:	6390                	ld	a2,0(a5)
    80002b02:	f279                	bnez	a2,80002ac8 <procdump+0x5a>
            state = "???";
    80002b04:	864e                	mv	a2,s3
    80002b06:	b7c9                	j	80002ac8 <procdump+0x5a>
    }
}
    80002b08:	60a6                	ld	ra,72(sp)
    80002b0a:	6406                	ld	s0,64(sp)
    80002b0c:	74e2                	ld	s1,56(sp)
    80002b0e:	7942                	ld	s2,48(sp)
    80002b10:	79a2                	ld	s3,40(sp)
    80002b12:	7a02                	ld	s4,32(sp)
    80002b14:	6ae2                	ld	s5,24(sp)
    80002b16:	6b42                	ld	s6,16(sp)
    80002b18:	6ba2                	ld	s7,8(sp)
    80002b1a:	6161                	addi	sp,sp,80
    80002b1c:	8082                	ret

0000000080002b1e <schedls>:

void schedls()
{
    80002b1e:	1141                	addi	sp,sp,-16
    80002b20:	e406                	sd	ra,8(sp)
    80002b22:	e022                	sd	s0,0(sp)
    80002b24:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002b26:	00005517          	auipc	a0,0x5
    80002b2a:	7b250513          	addi	a0,a0,1970 # 800082d8 <__func__.1+0x2d0>
    80002b2e:	ffffe097          	auipc	ra,0xffffe
    80002b32:	a8e080e7          	jalr	-1394(ra) # 800005bc <printf>
    printf("====================================\n");
    80002b36:	00005517          	auipc	a0,0x5
    80002b3a:	7ca50513          	addi	a0,a0,1994 # 80008300 <__func__.1+0x2f8>
    80002b3e:	ffffe097          	auipc	ra,0xffffe
    80002b42:	a7e080e7          	jalr	-1410(ra) # 800005bc <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002b46:	00009717          	auipc	a4,0x9
    80002b4a:	a9273703          	ld	a4,-1390(a4) # 8000b5d8 <available_schedulers+0x10>
    80002b4e:	00009797          	auipc	a5,0x9
    80002b52:	a2a7b783          	ld	a5,-1494(a5) # 8000b578 <sched_pointer>
    80002b56:	04f70663          	beq	a4,a5,80002ba2 <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002b5a:	00005517          	auipc	a0,0x5
    80002b5e:	7d650513          	addi	a0,a0,2006 # 80008330 <__func__.1+0x328>
    80002b62:	ffffe097          	auipc	ra,0xffffe
    80002b66:	a5a080e7          	jalr	-1446(ra) # 800005bc <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002b6a:	00009617          	auipc	a2,0x9
    80002b6e:	a7662603          	lw	a2,-1418(a2) # 8000b5e0 <available_schedulers+0x18>
    80002b72:	00009597          	auipc	a1,0x9
    80002b76:	a5658593          	addi	a1,a1,-1450 # 8000b5c8 <available_schedulers>
    80002b7a:	00005517          	auipc	a0,0x5
    80002b7e:	7be50513          	addi	a0,a0,1982 # 80008338 <__func__.1+0x330>
    80002b82:	ffffe097          	auipc	ra,0xffffe
    80002b86:	a3a080e7          	jalr	-1478(ra) # 800005bc <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002b8a:	00005517          	auipc	a0,0x5
    80002b8e:	7b650513          	addi	a0,a0,1974 # 80008340 <__func__.1+0x338>
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	a2a080e7          	jalr	-1494(ra) # 800005bc <printf>
}
    80002b9a:	60a2                	ld	ra,8(sp)
    80002b9c:	6402                	ld	s0,0(sp)
    80002b9e:	0141                	addi	sp,sp,16
    80002ba0:	8082                	ret
            printf("[*]\t");
    80002ba2:	00005517          	auipc	a0,0x5
    80002ba6:	78650513          	addi	a0,a0,1926 # 80008328 <__func__.1+0x320>
    80002baa:	ffffe097          	auipc	ra,0xffffe
    80002bae:	a12080e7          	jalr	-1518(ra) # 800005bc <printf>
    80002bb2:	bf65                	j	80002b6a <schedls+0x4c>

0000000080002bb4 <schedset>:

void schedset(int id)
{
    80002bb4:	1141                	addi	sp,sp,-16
    80002bb6:	e406                	sd	ra,8(sp)
    80002bb8:	e022                	sd	s0,0(sp)
    80002bba:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002bbc:	e90d                	bnez	a0,80002bee <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002bbe:	00009797          	auipc	a5,0x9
    80002bc2:	a1a7b783          	ld	a5,-1510(a5) # 8000b5d8 <available_schedulers+0x10>
    80002bc6:	00009717          	auipc	a4,0x9
    80002bca:	9af73923          	sd	a5,-1614(a4) # 8000b578 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002bce:	00009597          	auipc	a1,0x9
    80002bd2:	9fa58593          	addi	a1,a1,-1542 # 8000b5c8 <available_schedulers>
    80002bd6:	00005517          	auipc	a0,0x5
    80002bda:	7aa50513          	addi	a0,a0,1962 # 80008380 <__func__.1+0x378>
    80002bde:	ffffe097          	auipc	ra,0xffffe
    80002be2:	9de080e7          	jalr	-1570(ra) # 800005bc <printf>
}
    80002be6:	60a2                	ld	ra,8(sp)
    80002be8:	6402                	ld	s0,0(sp)
    80002bea:	0141                	addi	sp,sp,16
    80002bec:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002bee:	00005517          	auipc	a0,0x5
    80002bf2:	76a50513          	addi	a0,a0,1898 # 80008358 <__func__.1+0x350>
    80002bf6:	ffffe097          	auipc	ra,0xffffe
    80002bfa:	9c6080e7          	jalr	-1594(ra) # 800005bc <printf>
        return;
    80002bfe:	b7e5                	j	80002be6 <schedset+0x32>

0000000080002c00 <vatopa>:

uint64 vatopa(uint64 va, int pid){
    80002c00:	7179                	addi	sp,sp,-48
    80002c02:	f406                	sd	ra,40(sp)
    80002c04:	f022                	sd	s0,32(sp)
    80002c06:	ec26                	sd	s1,24(sp)
    80002c08:	e84a                	sd	s2,16(sp)
    80002c0a:	e44e                	sd	s3,8(sp)
    80002c0c:	e052                	sd	s4,0(sp)
    80002c0e:	1800                	addi	s0,sp,48
    80002c10:	8a2a                	mv	s4,a0
    80002c12:	89ae                	mv	s3,a1
    if(pid == 0){
        pagetable = myproc()->pagetable;
    }
    else{
        struct proc *p;
        for(p = proc; p < &proc[NPROC]; p++){
    80002c14:	00031497          	auipc	s1,0x31
    80002c18:	0f448493          	addi	s1,s1,244 # 80033d08 <proc>
    80002c1c:	00037917          	auipc	s2,0x37
    80002c20:	aec90913          	addi	s2,s2,-1300 # 80039708 <tickslock>
    if(pid == 0){
    80002c24:	e18d                	bnez	a1,80002c46 <vatopa+0x46>
        pagetable = myproc()->pagetable;
    80002c26:	fffff097          	auipc	ra,0xfffff
    80002c2a:	1e2080e7          	jalr	482(ra) # 80001e08 <myproc>
    80002c2e:	05053903          	ld	s2,80(a0)
    80002c32:	a81d                	j	80002c68 <vatopa+0x68>
            if(p->state != UNUSED && p->pid == pid){
                pagetable = p->pagetable;
                release(&p->lock);
                break;
            }
            release(&p->lock);
    80002c34:	8526                	mv	a0,s1
    80002c36:	ffffe097          	auipc	ra,0xffffe
    80002c3a:	384080e7          	jalr	900(ra) # 80000fba <release>
        for(p = proc; p < &proc[NPROC]; p++){
    80002c3e:	16848493          	addi	s1,s1,360
    80002c42:	05248863          	beq	s1,s2,80002c92 <vatopa+0x92>
            acquire(&p->lock);
    80002c46:	8526                	mv	a0,s1
    80002c48:	ffffe097          	auipc	ra,0xffffe
    80002c4c:	2be080e7          	jalr	702(ra) # 80000f06 <acquire>
            if(p->state != UNUSED && p->pid == pid){
    80002c50:	4c9c                	lw	a5,24(s1)
    80002c52:	d3ed                	beqz	a5,80002c34 <vatopa+0x34>
    80002c54:	589c                	lw	a5,48(s1)
    80002c56:	fd379fe3          	bne	a5,s3,80002c34 <vatopa+0x34>
                pagetable = p->pagetable;
    80002c5a:	0504b903          	ld	s2,80(s1)
                release(&p->lock);
    80002c5e:	8526                	mv	a0,s1
    80002c60:	ffffe097          	auipc	ra,0xffffe
    80002c64:	35a080e7          	jalr	858(ra) # 80000fba <release>
        }
    }
    if(pagetable == 0) return 0;
    80002c68:	02090763          	beqz	s2,80002c96 <vatopa+0x96>
    uint64 pa0 = walkaddr(pagetable, va);
    80002c6c:	85d2                	mv	a1,s4
    80002c6e:	854a                	mv	a0,s2
    80002c70:	ffffe097          	auipc	ra,0xffffe
    80002c74:	714080e7          	jalr	1812(ra) # 80001384 <walkaddr>
    if(pa0 == 0) return 0;
    80002c78:	c509                	beqz	a0,80002c82 <vatopa+0x82>
    return pa0 + (va & (PGSIZE -1));
    80002c7a:	1a52                	slli	s4,s4,0x34
    80002c7c:	034a5a13          	srli	s4,s4,0x34
    80002c80:	9552                	add	a0,a0,s4
    80002c82:	70a2                	ld	ra,40(sp)
    80002c84:	7402                	ld	s0,32(sp)
    80002c86:	64e2                	ld	s1,24(sp)
    80002c88:	6942                	ld	s2,16(sp)
    80002c8a:	69a2                	ld	s3,8(sp)
    80002c8c:	6a02                	ld	s4,0(sp)
    80002c8e:	6145                	addi	sp,sp,48
    80002c90:	8082                	ret
    if(pagetable == 0) return 0;
    80002c92:	4501                	li	a0,0
    80002c94:	b7fd                	j	80002c82 <vatopa+0x82>
    80002c96:	4501                	li	a0,0
    80002c98:	b7ed                	j	80002c82 <vatopa+0x82>

0000000080002c9a <swtch>:
    80002c9a:	00153023          	sd	ra,0(a0)
    80002c9e:	00253423          	sd	sp,8(a0)
    80002ca2:	e900                	sd	s0,16(a0)
    80002ca4:	ed04                	sd	s1,24(a0)
    80002ca6:	03253023          	sd	s2,32(a0)
    80002caa:	03353423          	sd	s3,40(a0)
    80002cae:	03453823          	sd	s4,48(a0)
    80002cb2:	03553c23          	sd	s5,56(a0)
    80002cb6:	05653023          	sd	s6,64(a0)
    80002cba:	05753423          	sd	s7,72(a0)
    80002cbe:	05853823          	sd	s8,80(a0)
    80002cc2:	05953c23          	sd	s9,88(a0)
    80002cc6:	07a53023          	sd	s10,96(a0)
    80002cca:	07b53423          	sd	s11,104(a0)
    80002cce:	0005b083          	ld	ra,0(a1)
    80002cd2:	0085b103          	ld	sp,8(a1)
    80002cd6:	6980                	ld	s0,16(a1)
    80002cd8:	6d84                	ld	s1,24(a1)
    80002cda:	0205b903          	ld	s2,32(a1)
    80002cde:	0285b983          	ld	s3,40(a1)
    80002ce2:	0305ba03          	ld	s4,48(a1)
    80002ce6:	0385ba83          	ld	s5,56(a1)
    80002cea:	0405bb03          	ld	s6,64(a1)
    80002cee:	0485bb83          	ld	s7,72(a1)
    80002cf2:	0505bc03          	ld	s8,80(a1)
    80002cf6:	0585bc83          	ld	s9,88(a1)
    80002cfa:	0605bd03          	ld	s10,96(a1)
    80002cfe:	0685bd83          	ld	s11,104(a1)
    80002d02:	8082                	ret

0000000080002d04 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002d04:	1141                	addi	sp,sp,-16
    80002d06:	e406                	sd	ra,8(sp)
    80002d08:	e022                	sd	s0,0(sp)
    80002d0a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002d0c:	00005597          	auipc	a1,0x5
    80002d10:	6cc58593          	addi	a1,a1,1740 # 800083d8 <__func__.1+0x3d0>
    80002d14:	00037517          	auipc	a0,0x37
    80002d18:	9f450513          	addi	a0,a0,-1548 # 80039708 <tickslock>
    80002d1c:	ffffe097          	auipc	ra,0xffffe
    80002d20:	15a080e7          	jalr	346(ra) # 80000e76 <initlock>
}
    80002d24:	60a2                	ld	ra,8(sp)
    80002d26:	6402                	ld	s0,0(sp)
    80002d28:	0141                	addi	sp,sp,16
    80002d2a:	8082                	ret

0000000080002d2c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002d2c:	1141                	addi	sp,sp,-16
    80002d2e:	e422                	sd	s0,8(sp)
    80002d30:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002d32:	00003797          	auipc	a5,0x3
    80002d36:	7fe78793          	addi	a5,a5,2046 # 80006530 <kernelvec>
    80002d3a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002d3e:	6422                	ld	s0,8(sp)
    80002d40:	0141                	addi	sp,sp,16
    80002d42:	8082                	ret

0000000080002d44 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002d44:	1141                	addi	sp,sp,-16
    80002d46:	e406                	sd	ra,8(sp)
    80002d48:	e022                	sd	s0,0(sp)
    80002d4a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d4c:	fffff097          	auipc	ra,0xfffff
    80002d50:	0bc080e7          	jalr	188(ra) # 80001e08 <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d54:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d58:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d5a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002d5e:	00004697          	auipc	a3,0x4
    80002d62:	2a268693          	addi	a3,a3,674 # 80007000 <_trampoline>
    80002d66:	00004717          	auipc	a4,0x4
    80002d6a:	29a70713          	addi	a4,a4,666 # 80007000 <_trampoline>
    80002d6e:	8f15                	sub	a4,a4,a3
    80002d70:	040007b7          	lui	a5,0x4000
    80002d74:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002d76:	07b2                	slli	a5,a5,0xc
    80002d78:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002d7a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002d7e:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002d80:	18002673          	csrr	a2,satp
    80002d84:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002d86:	6d30                	ld	a2,88(a0)
    80002d88:	6138                	ld	a4,64(a0)
    80002d8a:	6585                	lui	a1,0x1
    80002d8c:	972e                	add	a4,a4,a1
    80002d8e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002d90:	6d38                	ld	a4,88(a0)
    80002d92:	00000617          	auipc	a2,0x0
    80002d96:	13860613          	addi	a2,a2,312 # 80002eca <usertrap>
    80002d9a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002d9c:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002d9e:	8612                	mv	a2,tp
    80002da0:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002da2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002da6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002daa:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002dae:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002db2:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002db4:	6f18                	ld	a4,24(a4)
    80002db6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002dba:	6928                	ld	a0,80(a0)
    80002dbc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002dbe:	00004717          	auipc	a4,0x4
    80002dc2:	2de70713          	addi	a4,a4,734 # 8000709c <userret>
    80002dc6:	8f15                	sub	a4,a4,a3
    80002dc8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002dca:	577d                	li	a4,-1
    80002dcc:	177e                	slli	a4,a4,0x3f
    80002dce:	8d59                	or	a0,a0,a4
    80002dd0:	9782                	jalr	a5
}
    80002dd2:	60a2                	ld	ra,8(sp)
    80002dd4:	6402                	ld	s0,0(sp)
    80002dd6:	0141                	addi	sp,sp,16
    80002dd8:	8082                	ret

0000000080002dda <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002de4:	00037497          	auipc	s1,0x37
    80002de8:	92448493          	addi	s1,s1,-1756 # 80039708 <tickslock>
    80002dec:	8526                	mv	a0,s1
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	118080e7          	jalr	280(ra) # 80000f06 <acquire>
  ticks++;
    80002df6:	00009517          	auipc	a0,0x9
    80002dfa:	85a50513          	addi	a0,a0,-1958 # 8000b650 <ticks>
    80002dfe:	411c                	lw	a5,0(a0)
    80002e00:	2785                	addiw	a5,a5,1
    80002e02:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002e04:	00000097          	auipc	ra,0x0
    80002e08:	81a080e7          	jalr	-2022(ra) # 8000261e <wakeup>
  release(&tickslock);
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	ffffe097          	auipc	ra,0xffffe
    80002e12:	1ac080e7          	jalr	428(ra) # 80000fba <release>
}
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6105                	addi	sp,sp,32
    80002e1e:	8082                	ret

0000000080002e20 <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80002e20:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002e24:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002e26:	0a07d163          	bgez	a5,80002ec8 <devintr+0xa8>
{
    80002e2a:	1101                	addi	sp,sp,-32
    80002e2c:	ec06                	sd	ra,24(sp)
    80002e2e:	e822                	sd	s0,16(sp)
    80002e30:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002e32:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002e36:	46a5                	li	a3,9
    80002e38:	00d70c63          	beq	a4,a3,80002e50 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002e3c:	577d                	li	a4,-1
    80002e3e:	177e                	slli	a4,a4,0x3f
    80002e40:	0705                	addi	a4,a4,1
    return 0;
    80002e42:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002e44:	06e78163          	beq	a5,a4,80002ea6 <devintr+0x86>
  }
}
    80002e48:	60e2                	ld	ra,24(sp)
    80002e4a:	6442                	ld	s0,16(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret
    80002e50:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	7ea080e7          	jalr	2026(ra) # 8000663c <plic_claim>
    80002e5a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002e5c:	47a9                	li	a5,10
    80002e5e:	00f50963          	beq	a0,a5,80002e70 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002e62:	4785                	li	a5,1
    80002e64:	00f50b63          	beq	a0,a5,80002e7a <devintr+0x5a>
    return 1;
    80002e68:	4505                	li	a0,1
    } else if(irq){
    80002e6a:	ec89                	bnez	s1,80002e84 <devintr+0x64>
    80002e6c:	64a2                	ld	s1,8(sp)
    80002e6e:	bfe9                	j	80002e48 <devintr+0x28>
      uartintr();
    80002e70:	ffffe097          	auipc	ra,0xffffe
    80002e74:	b9c080e7          	jalr	-1124(ra) # 80000a0c <uartintr>
    if(irq)
    80002e78:	a839                	j	80002e96 <devintr+0x76>
      virtio_disk_intr();
    80002e7a:	00004097          	auipc	ra,0x4
    80002e7e:	cec080e7          	jalr	-788(ra) # 80006b66 <virtio_disk_intr>
    if(irq)
    80002e82:	a811                	j	80002e96 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002e84:	85a6                	mv	a1,s1
    80002e86:	00005517          	auipc	a0,0x5
    80002e8a:	55a50513          	addi	a0,a0,1370 # 800083e0 <__func__.1+0x3d8>
    80002e8e:	ffffd097          	auipc	ra,0xffffd
    80002e92:	72e080e7          	jalr	1838(ra) # 800005bc <printf>
      plic_complete(irq);
    80002e96:	8526                	mv	a0,s1
    80002e98:	00003097          	auipc	ra,0x3
    80002e9c:	7c8080e7          	jalr	1992(ra) # 80006660 <plic_complete>
    return 1;
    80002ea0:	4505                	li	a0,1
    80002ea2:	64a2                	ld	s1,8(sp)
    80002ea4:	b755                	j	80002e48 <devintr+0x28>
    if(cpuid() == 0){
    80002ea6:	fffff097          	auipc	ra,0xfffff
    80002eaa:	f36080e7          	jalr	-202(ra) # 80001ddc <cpuid>
    80002eae:	c901                	beqz	a0,80002ebe <devintr+0x9e>
    asm volatile("csrr %0, sip" : "=r"(x));
    80002eb0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002eb4:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80002eb6:	14479073          	csrw	sip,a5
    return 2;
    80002eba:	4509                	li	a0,2
    80002ebc:	b771                	j	80002e48 <devintr+0x28>
      clockintr();
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	f1c080e7          	jalr	-228(ra) # 80002dda <clockintr>
    80002ec6:	b7ed                	j	80002eb0 <devintr+0x90>
}
    80002ec8:	8082                	ret

0000000080002eca <usertrap>:
{
    80002eca:	7179                	addi	sp,sp,-48
    80002ecc:	f406                	sd	ra,40(sp)
    80002ece:	f022                	sd	s0,32(sp)
    80002ed0:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ed2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002ed6:	1007f793          	andi	a5,a5,256
    80002eda:	ebb9                	bnez	a5,80002f30 <usertrap+0x66>
    80002edc:	ec26                	sd	s1,24(sp)
    80002ede:	e84a                	sd	s2,16(sp)
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002ee0:	00003797          	auipc	a5,0x3
    80002ee4:	65078793          	addi	a5,a5,1616 # 80006530 <kernelvec>
    80002ee8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	f1c080e7          	jalr	-228(ra) # 80001e08 <myproc>
    80002ef4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002ef6:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002ef8:	14102773          	csrr	a4,sepc
    80002efc:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80002efe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002f02:	47a1                	li	a5,8
    80002f04:	04f70263          	beq	a4,a5,80002f48 <usertrap+0x7e>
    80002f08:	14202773          	csrr	a4,scause
  else if(r_scause() == 15){
    80002f0c:	47bd                	li	a5,15
    80002f0e:	08f70763          	beq	a4,a5,80002f9c <usertrap+0xd2>
  else if((which_dev = devintr()) != 0){
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	f0e080e7          	jalr	-242(ra) # 80002e20 <devintr>
    80002f1a:	892a                	mv	s2,a0
    80002f1c:	14050363          	beqz	a0,80003062 <usertrap+0x198>
  if(killed(p))
    80002f20:	8526                	mv	a0,s1
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	940080e7          	jalr	-1728(ra) # 80002862 <killed>
    80002f2a:	16050f63          	beqz	a0,800030a8 <usertrap+0x1de>
    80002f2e:	aa85                	j	8000309e <usertrap+0x1d4>
    80002f30:	ec26                	sd	s1,24(sp)
    80002f32:	e84a                	sd	s2,16(sp)
    80002f34:	e44e                	sd	s3,8(sp)
    80002f36:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    80002f38:	00005517          	auipc	a0,0x5
    80002f3c:	4c850513          	addi	a0,a0,1224 # 80008400 <__func__.1+0x3f8>
    80002f40:	ffffd097          	auipc	ra,0xffffd
    80002f44:	620080e7          	jalr	1568(ra) # 80000560 <panic>
    if(killed(p))
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	91a080e7          	jalr	-1766(ra) # 80002862 <killed>
    80002f50:	e121                	bnez	a0,80002f90 <usertrap+0xc6>
    p->trapframe->epc += 4;
    80002f52:	6cb8                	ld	a4,88(s1)
    80002f54:	6f1c                	ld	a5,24(a4)
    80002f56:	0791                	addi	a5,a5,4
    80002f58:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f5a:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002f5e:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002f62:	10079073          	csrw	sstatus,a5
    syscall();
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	3a2080e7          	jalr	930(ra) # 80003308 <syscall>
  if(killed(p))
    80002f6e:	8526                	mv	a0,s1
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	8f2080e7          	jalr	-1806(ra) # 80002862 <killed>
    80002f78:	12051263          	bnez	a0,8000309c <usertrap+0x1d2>
  usertrapret();
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	dc8080e7          	jalr	-568(ra) # 80002d44 <usertrapret>
    80002f84:	64e2                	ld	s1,24(sp)
    80002f86:	6942                	ld	s2,16(sp)
}
    80002f88:	70a2                	ld	ra,40(sp)
    80002f8a:	7402                	ld	s0,32(sp)
    80002f8c:	6145                	addi	sp,sp,48
    80002f8e:	8082                	ret
      exit(-1);
    80002f90:	557d                	li	a0,-1
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	75c080e7          	jalr	1884(ra) # 800026ee <exit>
    80002f9a:	bf65                	j	80002f52 <usertrap+0x88>
    80002f9c:	e44e                	sd	s3,8(sp)
    80002f9e:	e052                	sd	s4,0(sp)
    asm volatile("csrr %0, stval" : "=r"(x));
    80002fa0:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80002fa4:	77fd                	lui	a5,0xfffff
    80002fa6:	00f9f9b3          	and	s3,s3,a5
    acquire(&p->lock);
    80002faa:	ffffe097          	auipc	ra,0xffffe
    80002fae:	f5c080e7          	jalr	-164(ra) # 80000f06 <acquire>
    pagetable_t pgtable = p->pagetable;
    80002fb2:	0504b903          	ld	s2,80(s1)
    int pid = p->pid;
    80002fb6:	0304aa03          	lw	s4,48(s1)
    release(&p->lock);
    80002fba:	8526                	mv	a0,s1
    80002fbc:	ffffe097          	auipc	ra,0xffffe
    80002fc0:	ffe080e7          	jalr	-2(ra) # 80000fba <release>
    pte_t *pgentry = walk(pgtable, va, 0);
    80002fc4:	4601                	li	a2,0
    80002fc6:	85ce                	mv	a1,s3
    80002fc8:	854a                	mv	a0,s2
    80002fca:	ffffe097          	auipc	ra,0xffffe
    80002fce:	314080e7          	jalr	788(ra) # 800012de <walk>
    80002fd2:	892a                	mv	s2,a0
    if(pgentry && (PTE_COW & *pgentry)){
    80002fd4:	c175                	beqz	a0,800030b8 <usertrap+0x1ee>
    80002fd6:	611c                	ld	a5,0(a0)
    80002fd8:	2007f793          	andi	a5,a5,512
    80002fdc:	e781                	bnez	a5,80002fe4 <usertrap+0x11a>
    80002fde:	69a2                	ld	s3,8(sp)
    80002fe0:	6a02                	ld	s4,0(sp)
    80002fe2:	b771                	j	80002f6e <usertrap+0xa4>
      uint64 pa = vatopa(va, pid);
    80002fe4:	85d2                	mv	a1,s4
    80002fe6:	854e                	mv	a0,s3
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	c18080e7          	jalr	-1000(ra) # 80002c00 <vatopa>
    80002ff0:	8a2a                	mv	s4,a0
      int refcount = getrefcount(pa);
    80002ff2:	ffffe097          	auipc	ra,0xffffe
    80002ff6:	a9c080e7          	jalr	-1380(ra) # 80000a8e <getrefcount>
      *pgentry &= ~PTE_COW;
    80002ffa:	00093783          	ld	a5,0(s2)
    80002ffe:	dff7f793          	andi	a5,a5,-513
      *pgentry |= PTE_W;
    80003002:	0047e793          	ori	a5,a5,4
    80003006:	00f93023          	sd	a5,0(s2)
      if(refcount > 1 ){
    8000300a:	4785                	li	a5,1
    8000300c:	00a7c563          	blt	a5,a0,80003016 <usertrap+0x14c>
    80003010:	69a2                	ld	s3,8(sp)
    80003012:	6a02                	ld	s4,0(sp)
    80003014:	bfa9                	j	80002f6e <usertrap+0xa4>
        decrefcount(pa);
    80003016:	8552                	mv	a0,s4
    80003018:	ffffe097          	auipc	ra,0xffffe
    8000301c:	ac6080e7          	jalr	-1338(ra) # 80000ade <decrefcount>
        void* new = kalloc();
    80003020:	ffffe097          	auipc	ra,0xffffe
    80003024:	d5c080e7          	jalr	-676(ra) # 80000d7c <kalloc>
    80003028:	89aa                	mv	s3,a0
        if(new == 0){
    8000302a:	c505                	beqz	a0,80003052 <usertrap+0x188>
        memmove(new, (void*) pa, PGSIZE);
    8000302c:	6605                	lui	a2,0x1
    8000302e:	85d2                	mv	a1,s4
    80003030:	ffffe097          	auipc	ra,0xffffe
    80003034:	02e080e7          	jalr	46(ra) # 8000105e <memmove>
        *pgentry = PA2PTE(new) | flags;
    80003038:	00c9d793          	srli	a5,s3,0xc
    8000303c:	07aa                	slli	a5,a5,0xa
        uint flags = PTE_FLAGS(*pgentry);
    8000303e:	00093703          	ld	a4,0(s2)
        *pgentry = PA2PTE(new) | flags;
    80003042:	3ff77713          	andi	a4,a4,1023
    80003046:	8fd9                	or	a5,a5,a4
    80003048:	00f93023          	sd	a5,0(s2)
    8000304c:	69a2                	ld	s3,8(sp)
    8000304e:	6a02                	ld	s4,0(sp)
    80003050:	bf39                	j	80002f6e <usertrap+0xa4>
          panic("oh shit");
    80003052:	00005517          	auipc	a0,0x5
    80003056:	3ce50513          	addi	a0,a0,974 # 80008420 <__func__.1+0x418>
    8000305a:	ffffd097          	auipc	ra,0xffffd
    8000305e:	506080e7          	jalr	1286(ra) # 80000560 <panic>
    asm volatile("csrr %0, scause" : "=r"(x));
    80003062:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003066:	5890                	lw	a2,48(s1)
    80003068:	00005517          	auipc	a0,0x5
    8000306c:	3c050513          	addi	a0,a0,960 # 80008428 <__func__.1+0x420>
    80003070:	ffffd097          	auipc	ra,0xffffd
    80003074:	54c080e7          	jalr	1356(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80003078:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    8000307c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003080:	00005517          	auipc	a0,0x5
    80003084:	3d850513          	addi	a0,a0,984 # 80008458 <__func__.1+0x450>
    80003088:	ffffd097          	auipc	ra,0xffffd
    8000308c:	534080e7          	jalr	1332(ra) # 800005bc <printf>
    setkilled(p);
    80003090:	8526                	mv	a0,s1
    80003092:	fffff097          	auipc	ra,0xfffff
    80003096:	7a4080e7          	jalr	1956(ra) # 80002836 <setkilled>
    8000309a:	bdd1                	j	80002f6e <usertrap+0xa4>
  if(killed(p))
    8000309c:	4901                	li	s2,0
    exit(-1);
    8000309e:	557d                	li	a0,-1
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	64e080e7          	jalr	1614(ra) # 800026ee <exit>
  if(which_dev == 2)
    800030a8:	4789                	li	a5,2
    800030aa:	ecf919e3          	bne	s2,a5,80002f7c <usertrap+0xb2>
    yield();
    800030ae:	fffff097          	auipc	ra,0xfffff
    800030b2:	4d0080e7          	jalr	1232(ra) # 8000257e <yield>
    800030b6:	b5d9                	j	80002f7c <usertrap+0xb2>
    800030b8:	69a2                	ld	s3,8(sp)
    800030ba:	6a02                	ld	s4,0(sp)
    800030bc:	bd4d                	j	80002f6e <usertrap+0xa4>

00000000800030be <kerneltrap>:
{
    800030be:	7179                	addi	sp,sp,-48
    800030c0:	f406                	sd	ra,40(sp)
    800030c2:	f022                	sd	s0,32(sp)
    800030c4:	ec26                	sd	s1,24(sp)
    800030c6:	e84a                	sd	s2,16(sp)
    800030c8:	e44e                	sd	s3,8(sp)
    800030ca:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    800030cc:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800030d0:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    800030d4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800030d8:	1004f793          	andi	a5,s1,256
    800030dc:	cb85                	beqz	a5,8000310c <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800030de:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800030e2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800030e4:	ef85                	bnez	a5,8000311c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	d3a080e7          	jalr	-710(ra) # 80002e20 <devintr>
    800030ee:	cd1d                	beqz	a0,8000312c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030f0:	4789                	li	a5,2
    800030f2:	06f50a63          	beq	a0,a5,80003166 <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    800030f6:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800030fa:	10049073          	csrw	sstatus,s1
}
    800030fe:	70a2                	ld	ra,40(sp)
    80003100:	7402                	ld	s0,32(sp)
    80003102:	64e2                	ld	s1,24(sp)
    80003104:	6942                	ld	s2,16(sp)
    80003106:	69a2                	ld	s3,8(sp)
    80003108:	6145                	addi	sp,sp,48
    8000310a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	36c50513          	addi	a0,a0,876 # 80008478 <__func__.1+0x470>
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	44c080e7          	jalr	1100(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    8000311c:	00005517          	auipc	a0,0x5
    80003120:	38450513          	addi	a0,a0,900 # 800084a0 <__func__.1+0x498>
    80003124:	ffffd097          	auipc	ra,0xffffd
    80003128:	43c080e7          	jalr	1084(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    8000312c:	85ce                	mv	a1,s3
    8000312e:	00005517          	auipc	a0,0x5
    80003132:	39250513          	addi	a0,a0,914 # 800084c0 <__func__.1+0x4b8>
    80003136:	ffffd097          	auipc	ra,0xffffd
    8000313a:	486080e7          	jalr	1158(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    8000313e:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80003142:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003146:	00005517          	auipc	a0,0x5
    8000314a:	38a50513          	addi	a0,a0,906 # 800084d0 <__func__.1+0x4c8>
    8000314e:	ffffd097          	auipc	ra,0xffffd
    80003152:	46e080e7          	jalr	1134(ra) # 800005bc <printf>
    panic("kerneltrap");
    80003156:	00005517          	auipc	a0,0x5
    8000315a:	39250513          	addi	a0,a0,914 # 800084e8 <__func__.1+0x4e0>
    8000315e:	ffffd097          	auipc	ra,0xffffd
    80003162:	402080e7          	jalr	1026(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	ca2080e7          	jalr	-862(ra) # 80001e08 <myproc>
    8000316e:	d541                	beqz	a0,800030f6 <kerneltrap+0x38>
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	c98080e7          	jalr	-872(ra) # 80001e08 <myproc>
    80003178:	4d18                	lw	a4,24(a0)
    8000317a:	4791                	li	a5,4
    8000317c:	f6f71de3          	bne	a4,a5,800030f6 <kerneltrap+0x38>
    yield();
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	3fe080e7          	jalr	1022(ra) # 8000257e <yield>
    80003188:	b7bd                	j	800030f6 <kerneltrap+0x38>

000000008000318a <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	addi	s0,sp,32
    80003194:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003196:	fffff097          	auipc	ra,0xfffff
    8000319a:	c72080e7          	jalr	-910(ra) # 80001e08 <myproc>
    switch (n)
    8000319e:	4795                	li	a5,5
    800031a0:	0497e163          	bltu	a5,s1,800031e2 <argraw+0x58>
    800031a4:	048a                	slli	s1,s1,0x2
    800031a6:	00005717          	auipc	a4,0x5
    800031aa:	70a70713          	addi	a4,a4,1802 # 800088b0 <states.0+0x30>
    800031ae:	94ba                	add	s1,s1,a4
    800031b0:	409c                	lw	a5,0(s1)
    800031b2:	97ba                	add	a5,a5,a4
    800031b4:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    800031b6:	6d3c                	ld	a5,88(a0)
    800031b8:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    800031ba:	60e2                	ld	ra,24(sp)
    800031bc:	6442                	ld	s0,16(sp)
    800031be:	64a2                	ld	s1,8(sp)
    800031c0:	6105                	addi	sp,sp,32
    800031c2:	8082                	ret
        return p->trapframe->a1;
    800031c4:	6d3c                	ld	a5,88(a0)
    800031c6:	7fa8                	ld	a0,120(a5)
    800031c8:	bfcd                	j	800031ba <argraw+0x30>
        return p->trapframe->a2;
    800031ca:	6d3c                	ld	a5,88(a0)
    800031cc:	63c8                	ld	a0,128(a5)
    800031ce:	b7f5                	j	800031ba <argraw+0x30>
        return p->trapframe->a3;
    800031d0:	6d3c                	ld	a5,88(a0)
    800031d2:	67c8                	ld	a0,136(a5)
    800031d4:	b7dd                	j	800031ba <argraw+0x30>
        return p->trapframe->a4;
    800031d6:	6d3c                	ld	a5,88(a0)
    800031d8:	6bc8                	ld	a0,144(a5)
    800031da:	b7c5                	j	800031ba <argraw+0x30>
        return p->trapframe->a5;
    800031dc:	6d3c                	ld	a5,88(a0)
    800031de:	6fc8                	ld	a0,152(a5)
    800031e0:	bfe9                	j	800031ba <argraw+0x30>
    panic("argraw");
    800031e2:	00005517          	auipc	a0,0x5
    800031e6:	31650513          	addi	a0,a0,790 # 800084f8 <__func__.1+0x4f0>
    800031ea:	ffffd097          	auipc	ra,0xffffd
    800031ee:	376080e7          	jalr	886(ra) # 80000560 <panic>

00000000800031f2 <fetchaddr>:
{
    800031f2:	1101                	addi	sp,sp,-32
    800031f4:	ec06                	sd	ra,24(sp)
    800031f6:	e822                	sd	s0,16(sp)
    800031f8:	e426                	sd	s1,8(sp)
    800031fa:	e04a                	sd	s2,0(sp)
    800031fc:	1000                	addi	s0,sp,32
    800031fe:	84aa                	mv	s1,a0
    80003200:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	c06080e7          	jalr	-1018(ra) # 80001e08 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000320a:	653c                	ld	a5,72(a0)
    8000320c:	02f4f863          	bgeu	s1,a5,8000323c <fetchaddr+0x4a>
    80003210:	00848713          	addi	a4,s1,8
    80003214:	02e7e663          	bltu	a5,a4,80003240 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003218:	46a1                	li	a3,8
    8000321a:	8626                	mv	a2,s1
    8000321c:	85ca                	mv	a1,s2
    8000321e:	6928                	ld	a0,80(a0)
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	818080e7          	jalr	-2024(ra) # 80001a38 <copyin>
    80003228:	00a03533          	snez	a0,a0
    8000322c:	40a00533          	neg	a0,a0
}
    80003230:	60e2                	ld	ra,24(sp)
    80003232:	6442                	ld	s0,16(sp)
    80003234:	64a2                	ld	s1,8(sp)
    80003236:	6902                	ld	s2,0(sp)
    80003238:	6105                	addi	sp,sp,32
    8000323a:	8082                	ret
        return -1;
    8000323c:	557d                	li	a0,-1
    8000323e:	bfcd                	j	80003230 <fetchaddr+0x3e>
    80003240:	557d                	li	a0,-1
    80003242:	b7fd                	j	80003230 <fetchaddr+0x3e>

0000000080003244 <fetchstr>:
{
    80003244:	7179                	addi	sp,sp,-48
    80003246:	f406                	sd	ra,40(sp)
    80003248:	f022                	sd	s0,32(sp)
    8000324a:	ec26                	sd	s1,24(sp)
    8000324c:	e84a                	sd	s2,16(sp)
    8000324e:	e44e                	sd	s3,8(sp)
    80003250:	1800                	addi	s0,sp,48
    80003252:	892a                	mv	s2,a0
    80003254:	84ae                	mv	s1,a1
    80003256:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	bb0080e7          	jalr	-1104(ra) # 80001e08 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80003260:	86ce                	mv	a3,s3
    80003262:	864a                	mv	a2,s2
    80003264:	85a6                	mv	a1,s1
    80003266:	6928                	ld	a0,80(a0)
    80003268:	fffff097          	auipc	ra,0xfffff
    8000326c:	85e080e7          	jalr	-1954(ra) # 80001ac6 <copyinstr>
    80003270:	00054e63          	bltz	a0,8000328c <fetchstr+0x48>
    return strlen(buf);
    80003274:	8526                	mv	a0,s1
    80003276:	ffffe097          	auipc	ra,0xffffe
    8000327a:	f00080e7          	jalr	-256(ra) # 80001176 <strlen>
}
    8000327e:	70a2                	ld	ra,40(sp)
    80003280:	7402                	ld	s0,32(sp)
    80003282:	64e2                	ld	s1,24(sp)
    80003284:	6942                	ld	s2,16(sp)
    80003286:	69a2                	ld	s3,8(sp)
    80003288:	6145                	addi	sp,sp,48
    8000328a:	8082                	ret
        return -1;
    8000328c:	557d                	li	a0,-1
    8000328e:	bfc5                	j	8000327e <fetchstr+0x3a>

0000000080003290 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003290:	1101                	addi	sp,sp,-32
    80003292:	ec06                	sd	ra,24(sp)
    80003294:	e822                	sd	s0,16(sp)
    80003296:	e426                	sd	s1,8(sp)
    80003298:	1000                	addi	s0,sp,32
    8000329a:	84ae                	mv	s1,a1
    *ip = argraw(n);
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	eee080e7          	jalr	-274(ra) # 8000318a <argraw>
    800032a4:	c088                	sw	a0,0(s1)
}
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret

00000000800032b0 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800032b0:	1101                	addi	sp,sp,-32
    800032b2:	ec06                	sd	ra,24(sp)
    800032b4:	e822                	sd	s0,16(sp)
    800032b6:	e426                	sd	s1,8(sp)
    800032b8:	1000                	addi	s0,sp,32
    800032ba:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	ece080e7          	jalr	-306(ra) # 8000318a <argraw>
    800032c4:	e088                	sd	a0,0(s1)
}
    800032c6:	60e2                	ld	ra,24(sp)
    800032c8:	6442                	ld	s0,16(sp)
    800032ca:	64a2                	ld	s1,8(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800032d0:	7179                	addi	sp,sp,-48
    800032d2:	f406                	sd	ra,40(sp)
    800032d4:	f022                	sd	s0,32(sp)
    800032d6:	ec26                	sd	s1,24(sp)
    800032d8:	e84a                	sd	s2,16(sp)
    800032da:	1800                	addi	s0,sp,48
    800032dc:	84ae                	mv	s1,a1
    800032de:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800032e0:	fd840593          	addi	a1,s0,-40
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	fcc080e7          	jalr	-52(ra) # 800032b0 <argaddr>
    return fetchstr(addr, buf, max);
    800032ec:	864a                	mv	a2,s2
    800032ee:	85a6                	mv	a1,s1
    800032f0:	fd843503          	ld	a0,-40(s0)
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	f50080e7          	jalr	-176(ra) # 80003244 <fetchstr>
}
    800032fc:	70a2                	ld	ra,40(sp)
    800032fe:	7402                	ld	s0,32(sp)
    80003300:	64e2                	ld	s1,24(sp)
    80003302:	6942                	ld	s2,16(sp)
    80003304:	6145                	addi	sp,sp,48
    80003306:	8082                	ret

0000000080003308 <syscall>:
    [SYS_pfreepages] sys_pfreepages,
    [SYS_va2pa] sys_va2pa,
};

void syscall(void)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	e426                	sd	s1,8(sp)
    80003310:	e04a                	sd	s2,0(sp)
    80003312:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003314:	fffff097          	auipc	ra,0xfffff
    80003318:	af4080e7          	jalr	-1292(ra) # 80001e08 <myproc>
    8000331c:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000331e:	05853903          	ld	s2,88(a0)
    80003322:	0a893783          	ld	a5,168(s2)
    80003326:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000332a:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffba517>
    8000332c:	4765                	li	a4,25
    8000332e:	00f76f63          	bltu	a4,a5,8000334c <syscall+0x44>
    80003332:	00369713          	slli	a4,a3,0x3
    80003336:	00005797          	auipc	a5,0x5
    8000333a:	59278793          	addi	a5,a5,1426 # 800088c8 <syscalls>
    8000333e:	97ba                	add	a5,a5,a4
    80003340:	639c                	ld	a5,0(a5)
    80003342:	c789                	beqz	a5,8000334c <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003344:	9782                	jalr	a5
    80003346:	06a93823          	sd	a0,112(s2)
    8000334a:	a839                	j	80003368 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000334c:	15848613          	addi	a2,s1,344
    80003350:	588c                	lw	a1,48(s1)
    80003352:	00005517          	auipc	a0,0x5
    80003356:	1ae50513          	addi	a0,a0,430 # 80008500 <__func__.1+0x4f8>
    8000335a:	ffffd097          	auipc	ra,0xffffd
    8000335e:	262080e7          	jalr	610(ra) # 800005bc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003362:	6cbc                	ld	a5,88(s1)
    80003364:	577d                	li	a4,-1
    80003366:	fbb8                	sd	a4,112(a5)
    }
}
    80003368:	60e2                	ld	ra,24(sp)
    8000336a:	6442                	ld	s0,16(sp)
    8000336c:	64a2                	ld	s1,8(sp)
    8000336e:	6902                	ld	s2,0(sp)
    80003370:	6105                	addi	sp,sp,32
    80003372:	8082                	ret

0000000080003374 <sys_exit>:
extern uint64 FREE_PAGES; // kalloc.c keeps track of those
extern struct proc proc[NPROC];

uint64
sys_exit(void)
{
    80003374:	1101                	addi	sp,sp,-32
    80003376:	ec06                	sd	ra,24(sp)
    80003378:	e822                	sd	s0,16(sp)
    8000337a:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    8000337c:	fec40593          	addi	a1,s0,-20
    80003380:	4501                	li	a0,0
    80003382:	00000097          	auipc	ra,0x0
    80003386:	f0e080e7          	jalr	-242(ra) # 80003290 <argint>
    exit(n);
    8000338a:	fec42503          	lw	a0,-20(s0)
    8000338e:	fffff097          	auipc	ra,0xfffff
    80003392:	360080e7          	jalr	864(ra) # 800026ee <exit>
    return 0; // not reached
}
    80003396:	4501                	li	a0,0
    80003398:	60e2                	ld	ra,24(sp)
    8000339a:	6442                	ld	s0,16(sp)
    8000339c:	6105                	addi	sp,sp,32
    8000339e:	8082                	ret

00000000800033a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800033a0:	1141                	addi	sp,sp,-16
    800033a2:	e406                	sd	ra,8(sp)
    800033a4:	e022                	sd	s0,0(sp)
    800033a6:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	a60080e7          	jalr	-1440(ra) # 80001e08 <myproc>
}
    800033b0:	5908                	lw	a0,48(a0)
    800033b2:	60a2                	ld	ra,8(sp)
    800033b4:	6402                	ld	s0,0(sp)
    800033b6:	0141                	addi	sp,sp,16
    800033b8:	8082                	ret

00000000800033ba <sys_fork>:

uint64
sys_fork(void)
{
    800033ba:	1141                	addi	sp,sp,-16
    800033bc:	e406                	sd	ra,8(sp)
    800033be:	e022                	sd	s0,0(sp)
    800033c0:	0800                	addi	s0,sp,16
    return fork();
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	f94080e7          	jalr	-108(ra) # 80002356 <fork>
}
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <sys_wait>:

uint64
sys_wait(void)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    800033da:	fe840593          	addi	a1,s0,-24
    800033de:	4501                	li	a0,0
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	ed0080e7          	jalr	-304(ra) # 800032b0 <argaddr>
    return wait(p);
    800033e8:	fe843503          	ld	a0,-24(s0)
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	4a8080e7          	jalr	1192(ra) # 80002894 <wait>
}
    800033f4:	60e2                	ld	ra,24(sp)
    800033f6:	6442                	ld	s0,16(sp)
    800033f8:	6105                	addi	sp,sp,32
    800033fa:	8082                	ret

00000000800033fc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800033fc:	7179                	addi	sp,sp,-48
    800033fe:	f406                	sd	ra,40(sp)
    80003400:	f022                	sd	s0,32(sp)
    80003402:	ec26                	sd	s1,24(sp)
    80003404:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003406:	fdc40593          	addi	a1,s0,-36
    8000340a:	4501                	li	a0,0
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	e84080e7          	jalr	-380(ra) # 80003290 <argint>
    addr = myproc()->sz;
    80003414:	fffff097          	auipc	ra,0xfffff
    80003418:	9f4080e7          	jalr	-1548(ra) # 80001e08 <myproc>
    8000341c:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    8000341e:	fdc42503          	lw	a0,-36(s0)
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	d40080e7          	jalr	-704(ra) # 80002162 <growproc>
    8000342a:	00054863          	bltz	a0,8000343a <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    8000342e:	8526                	mv	a0,s1
    80003430:	70a2                	ld	ra,40(sp)
    80003432:	7402                	ld	s0,32(sp)
    80003434:	64e2                	ld	s1,24(sp)
    80003436:	6145                	addi	sp,sp,48
    80003438:	8082                	ret
        return -1;
    8000343a:	54fd                	li	s1,-1
    8000343c:	bfcd                	j	8000342e <sys_sbrk+0x32>

000000008000343e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000343e:	7139                	addi	sp,sp,-64
    80003440:	fc06                	sd	ra,56(sp)
    80003442:	f822                	sd	s0,48(sp)
    80003444:	f04a                	sd	s2,32(sp)
    80003446:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    80003448:	fcc40593          	addi	a1,s0,-52
    8000344c:	4501                	li	a0,0
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	e42080e7          	jalr	-446(ra) # 80003290 <argint>
    acquire(&tickslock);
    80003456:	00036517          	auipc	a0,0x36
    8000345a:	2b250513          	addi	a0,a0,690 # 80039708 <tickslock>
    8000345e:	ffffe097          	auipc	ra,0xffffe
    80003462:	aa8080e7          	jalr	-1368(ra) # 80000f06 <acquire>
    ticks0 = ticks;
    80003466:	00008917          	auipc	s2,0x8
    8000346a:	1ea92903          	lw	s2,490(s2) # 8000b650 <ticks>
    while (ticks - ticks0 < n)
    8000346e:	fcc42783          	lw	a5,-52(s0)
    80003472:	c3b9                	beqz	a5,800034b8 <sys_sleep+0x7a>
    80003474:	f426                	sd	s1,40(sp)
    80003476:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80003478:	00036997          	auipc	s3,0x36
    8000347c:	29098993          	addi	s3,s3,656 # 80039708 <tickslock>
    80003480:	00008497          	auipc	s1,0x8
    80003484:	1d048493          	addi	s1,s1,464 # 8000b650 <ticks>
        if (killed(myproc()))
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	980080e7          	jalr	-1664(ra) # 80001e08 <myproc>
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	3d2080e7          	jalr	978(ra) # 80002862 <killed>
    80003498:	ed15                	bnez	a0,800034d4 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000349a:	85ce                	mv	a1,s3
    8000349c:	8526                	mv	a0,s1
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	11c080e7          	jalr	284(ra) # 800025ba <sleep>
    while (ticks - ticks0 < n)
    800034a6:	409c                	lw	a5,0(s1)
    800034a8:	412787bb          	subw	a5,a5,s2
    800034ac:	fcc42703          	lw	a4,-52(s0)
    800034b0:	fce7ece3          	bltu	a5,a4,80003488 <sys_sleep+0x4a>
    800034b4:	74a2                	ld	s1,40(sp)
    800034b6:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800034b8:	00036517          	auipc	a0,0x36
    800034bc:	25050513          	addi	a0,a0,592 # 80039708 <tickslock>
    800034c0:	ffffe097          	auipc	ra,0xffffe
    800034c4:	afa080e7          	jalr	-1286(ra) # 80000fba <release>
    return 0;
    800034c8:	4501                	li	a0,0
}
    800034ca:	70e2                	ld	ra,56(sp)
    800034cc:	7442                	ld	s0,48(sp)
    800034ce:	7902                	ld	s2,32(sp)
    800034d0:	6121                	addi	sp,sp,64
    800034d2:	8082                	ret
            release(&tickslock);
    800034d4:	00036517          	auipc	a0,0x36
    800034d8:	23450513          	addi	a0,a0,564 # 80039708 <tickslock>
    800034dc:	ffffe097          	auipc	ra,0xffffe
    800034e0:	ade080e7          	jalr	-1314(ra) # 80000fba <release>
            return -1;
    800034e4:	557d                	li	a0,-1
    800034e6:	74a2                	ld	s1,40(sp)
    800034e8:	69e2                	ld	s3,24(sp)
    800034ea:	b7c5                	j	800034ca <sys_sleep+0x8c>

00000000800034ec <sys_kill>:

uint64
sys_kill(void)
{
    800034ec:	1101                	addi	sp,sp,-32
    800034ee:	ec06                	sd	ra,24(sp)
    800034f0:	e822                	sd	s0,16(sp)
    800034f2:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800034f4:	fec40593          	addi	a1,s0,-20
    800034f8:	4501                	li	a0,0
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	d96080e7          	jalr	-618(ra) # 80003290 <argint>
    return kill(pid);
    80003502:	fec42503          	lw	a0,-20(s0)
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	2be080e7          	jalr	702(ra) # 800027c4 <kill>
}
    8000350e:	60e2                	ld	ra,24(sp)
    80003510:	6442                	ld	s0,16(sp)
    80003512:	6105                	addi	sp,sp,32
    80003514:	8082                	ret

0000000080003516 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	e426                	sd	s1,8(sp)
    8000351e:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    80003520:	00036517          	auipc	a0,0x36
    80003524:	1e850513          	addi	a0,a0,488 # 80039708 <tickslock>
    80003528:	ffffe097          	auipc	ra,0xffffe
    8000352c:	9de080e7          	jalr	-1570(ra) # 80000f06 <acquire>
    xticks = ticks;
    80003530:	00008497          	auipc	s1,0x8
    80003534:	1204a483          	lw	s1,288(s1) # 8000b650 <ticks>
    release(&tickslock);
    80003538:	00036517          	auipc	a0,0x36
    8000353c:	1d050513          	addi	a0,a0,464 # 80039708 <tickslock>
    80003540:	ffffe097          	auipc	ra,0xffffe
    80003544:	a7a080e7          	jalr	-1414(ra) # 80000fba <release>
    return xticks;
}
    80003548:	02049513          	slli	a0,s1,0x20
    8000354c:	9101                	srli	a0,a0,0x20
    8000354e:	60e2                	ld	ra,24(sp)
    80003550:	6442                	ld	s0,16(sp)
    80003552:	64a2                	ld	s1,8(sp)
    80003554:	6105                	addi	sp,sp,32
    80003556:	8082                	ret

0000000080003558 <sys_ps>:

void *
sys_ps(void)
{
    80003558:	1101                	addi	sp,sp,-32
    8000355a:	ec06                	sd	ra,24(sp)
    8000355c:	e822                	sd	s0,16(sp)
    8000355e:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003560:	fe042623          	sw	zero,-20(s0)
    80003564:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    80003568:	fec40593          	addi	a1,s0,-20
    8000356c:	4501                	li	a0,0
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	d22080e7          	jalr	-734(ra) # 80003290 <argint>
    argint(1, &count);
    80003576:	fe840593          	addi	a1,s0,-24
    8000357a:	4505                	li	a0,1
    8000357c:	00000097          	auipc	ra,0x0
    80003580:	d14080e7          	jalr	-748(ra) # 80003290 <argint>
    return ps((uint8)start, (uint8)count);
    80003584:	fe844583          	lbu	a1,-24(s0)
    80003588:	fec44503          	lbu	a0,-20(s0)
    8000358c:	fffff097          	auipc	ra,0xfffff
    80003590:	c32080e7          	jalr	-974(ra) # 800021be <ps>
}
    80003594:	60e2                	ld	ra,24(sp)
    80003596:	6442                	ld	s0,16(sp)
    80003598:	6105                	addi	sp,sp,32
    8000359a:	8082                	ret

000000008000359c <sys_schedls>:

uint64 sys_schedls(void)
{
    8000359c:	1141                	addi	sp,sp,-16
    8000359e:	e406                	sd	ra,8(sp)
    800035a0:	e022                	sd	s0,0(sp)
    800035a2:	0800                	addi	s0,sp,16
    schedls();
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	57a080e7          	jalr	1402(ra) # 80002b1e <schedls>
    return 0;
}
    800035ac:	4501                	li	a0,0
    800035ae:	60a2                	ld	ra,8(sp)
    800035b0:	6402                	ld	s0,0(sp)
    800035b2:	0141                	addi	sp,sp,16
    800035b4:	8082                	ret

00000000800035b6 <sys_schedset>:

uint64 sys_schedset(void)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	1000                	addi	s0,sp,32
    int id = 0;
    800035be:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    800035c2:	fec40593          	addi	a1,s0,-20
    800035c6:	4501                	li	a0,0
    800035c8:	00000097          	auipc	ra,0x0
    800035cc:	cc8080e7          	jalr	-824(ra) # 80003290 <argint>
    schedset(id - 1);
    800035d0:	fec42503          	lw	a0,-20(s0)
    800035d4:	357d                	addiw	a0,a0,-1
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	5de080e7          	jalr	1502(ra) # 80002bb4 <schedset>
    return 0;
}
    800035de:	4501                	li	a0,0
    800035e0:	60e2                	ld	ra,24(sp)
    800035e2:	6442                	ld	s0,16(sp)
    800035e4:	6105                	addi	sp,sp,32
    800035e6:	8082                	ret

00000000800035e8 <sys_va2pa>:

uint64 sys_va2pa(void){
    800035e8:	7179                	addi	sp,sp,-48
    800035ea:	f406                	sd	ra,40(sp)
    800035ec:	f022                	sd	s0,32(sp)
    800035ee:	ec26                	sd	s1,24(sp)
    800035f0:	e84a                	sd	s2,16(sp)
    800035f2:	1800                	addi	s0,sp,48
 
    int pid = 0;
    800035f4:	fc042e23          	sw	zero,-36(s0)
    uint64 va = 0;
    800035f8:	fc043823          	sd	zero,-48(s0)
    argaddr(0, &va);
    800035fc:	fd040593          	addi	a1,s0,-48
    80003600:	4501                	li	a0,0
    80003602:	00000097          	auipc	ra,0x0
    80003606:	cae080e7          	jalr	-850(ra) # 800032b0 <argaddr>
    argint(1, &pid);
    8000360a:	fdc40593          	addi	a1,s0,-36
    8000360e:	4505                	li	a0,1
    80003610:	00000097          	auipc	ra,0x0
    80003614:	c80080e7          	jalr	-896(ra) # 80003290 <argint>

    pagetable_t pagetable = 0;

    if(pid == 0){
    80003618:	fdc42783          	lw	a5,-36(s0)
        pagetable = myproc()->pagetable;
    }
    else{
        struct proc *p;
        for(p = proc; p < &proc[NPROC]; p++){
    8000361c:	00030497          	auipc	s1,0x30
    80003620:	6ec48493          	addi	s1,s1,1772 # 80033d08 <proc>
    80003624:	00036917          	auipc	s2,0x36
    80003628:	0e490913          	addi	s2,s2,228 # 80039708 <tickslock>
    if(pid == 0){
    8000362c:	e38d                	bnez	a5,8000364e <sys_va2pa+0x66>
        pagetable = myproc()->pagetable;
    8000362e:	ffffe097          	auipc	ra,0xffffe
    80003632:	7da080e7          	jalr	2010(ra) # 80001e08 <myproc>
    80003636:	05053903          	ld	s2,80(a0)
    8000363a:	a82d                	j	80003674 <sys_va2pa+0x8c>
            if(p->state != UNUSED && p->pid == pid){
                pagetable = p->pagetable;
                release(&p->lock);
                break;
            }
            release(&p->lock);
    8000363c:	8526                	mv	a0,s1
    8000363e:	ffffe097          	auipc	ra,0xffffe
    80003642:	97c080e7          	jalr	-1668(ra) # 80000fba <release>
        for(p = proc; p < &proc[NPROC]; p++){
    80003646:	16848493          	addi	s1,s1,360
    8000364a:	05248a63          	beq	s1,s2,8000369e <sys_va2pa+0xb6>
            acquire(&p->lock);
    8000364e:	8526                	mv	a0,s1
    80003650:	ffffe097          	auipc	ra,0xffffe
    80003654:	8b6080e7          	jalr	-1866(ra) # 80000f06 <acquire>
            if(p->state != UNUSED && p->pid == pid){
    80003658:	4c9c                	lw	a5,24(s1)
    8000365a:	d3ed                	beqz	a5,8000363c <sys_va2pa+0x54>
    8000365c:	5898                	lw	a4,48(s1)
    8000365e:	fdc42783          	lw	a5,-36(s0)
    80003662:	fcf71de3          	bne	a4,a5,8000363c <sys_va2pa+0x54>
                pagetable = p->pagetable;
    80003666:	0504b903          	ld	s2,80(s1)
                release(&p->lock);
    8000366a:	8526                	mv	a0,s1
    8000366c:	ffffe097          	auipc	ra,0xffffe
    80003670:	94e080e7          	jalr	-1714(ra) # 80000fba <release>
        }
    }
    if(pagetable == 0) return 0;
    80003674:	02090763          	beqz	s2,800036a2 <sys_va2pa+0xba>
    uint64 pa0 = walkaddr(pagetable, va);
    80003678:	fd043583          	ld	a1,-48(s0)
    8000367c:	854a                	mv	a0,s2
    8000367e:	ffffe097          	auipc	ra,0xffffe
    80003682:	d06080e7          	jalr	-762(ra) # 80001384 <walkaddr>
    if(pa0 == 0) return 0;
    80003686:	c511                	beqz	a0,80003692 <sys_va2pa+0xaa>
    return pa0 + (va & (PGSIZE -1));
    80003688:	fd043783          	ld	a5,-48(s0)
    8000368c:	17d2                	slli	a5,a5,0x34
    8000368e:	93d1                	srli	a5,a5,0x34
    80003690:	953e                	add	a0,a0,a5
}
    80003692:	70a2                	ld	ra,40(sp)
    80003694:	7402                	ld	s0,32(sp)
    80003696:	64e2                	ld	s1,24(sp)
    80003698:	6942                	ld	s2,16(sp)
    8000369a:	6145                	addi	sp,sp,48
    8000369c:	8082                	ret
    if(pagetable == 0) return 0;
    8000369e:	4501                	li	a0,0
    800036a0:	bfcd                	j	80003692 <sys_va2pa+0xaa>
    800036a2:	4501                	li	a0,0
    800036a4:	b7fd                	j	80003692 <sys_va2pa+0xaa>

00000000800036a6 <sys_pfreepages>:

uint64 sys_pfreepages(void)
{
    800036a6:	1141                	addi	sp,sp,-16
    800036a8:	e406                	sd	ra,8(sp)
    800036aa:	e022                	sd	s0,0(sp)
    800036ac:	0800                	addi	s0,sp,16
    printf("%d\n", FREE_PAGES);
    800036ae:	00008597          	auipc	a1,0x8
    800036b2:	f7a5b583          	ld	a1,-134(a1) # 8000b628 <FREE_PAGES>
    800036b6:	00005517          	auipc	a0,0x5
    800036ba:	e6a50513          	addi	a0,a0,-406 # 80008520 <__func__.1+0x518>
    800036be:	ffffd097          	auipc	ra,0xffffd
    800036c2:	efe080e7          	jalr	-258(ra) # 800005bc <printf>
    return 0;
}
    800036c6:	4501                	li	a0,0
    800036c8:	60a2                	ld	ra,8(sp)
    800036ca:	6402                	ld	s0,0(sp)
    800036cc:	0141                	addi	sp,sp,16
    800036ce:	8082                	ret

00000000800036d0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800036d0:	7179                	addi	sp,sp,-48
    800036d2:	f406                	sd	ra,40(sp)
    800036d4:	f022                	sd	s0,32(sp)
    800036d6:	ec26                	sd	s1,24(sp)
    800036d8:	e84a                	sd	s2,16(sp)
    800036da:	e44e                	sd	s3,8(sp)
    800036dc:	e052                	sd	s4,0(sp)
    800036de:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800036e0:	00005597          	auipc	a1,0x5
    800036e4:	e4858593          	addi	a1,a1,-440 # 80008528 <__func__.1+0x520>
    800036e8:	00036517          	auipc	a0,0x36
    800036ec:	03850513          	addi	a0,a0,56 # 80039720 <bcache>
    800036f0:	ffffd097          	auipc	ra,0xffffd
    800036f4:	786080e7          	jalr	1926(ra) # 80000e76 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800036f8:	0003e797          	auipc	a5,0x3e
    800036fc:	02878793          	addi	a5,a5,40 # 80041720 <bcache+0x8000>
    80003700:	0003e717          	auipc	a4,0x3e
    80003704:	28870713          	addi	a4,a4,648 # 80041988 <bcache+0x8268>
    80003708:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000370c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003710:	00036497          	auipc	s1,0x36
    80003714:	02848493          	addi	s1,s1,40 # 80039738 <bcache+0x18>
    b->next = bcache.head.next;
    80003718:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000371a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000371c:	00005a17          	auipc	s4,0x5
    80003720:	e14a0a13          	addi	s4,s4,-492 # 80008530 <__func__.1+0x528>
    b->next = bcache.head.next;
    80003724:	2b893783          	ld	a5,696(s2)
    80003728:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000372a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000372e:	85d2                	mv	a1,s4
    80003730:	01048513          	addi	a0,s1,16
    80003734:	00001097          	auipc	ra,0x1
    80003738:	4e8080e7          	jalr	1256(ra) # 80004c1c <initsleeplock>
    bcache.head.next->prev = b;
    8000373c:	2b893783          	ld	a5,696(s2)
    80003740:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003742:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003746:	45848493          	addi	s1,s1,1112
    8000374a:	fd349de3          	bne	s1,s3,80003724 <binit+0x54>
  }
}
    8000374e:	70a2                	ld	ra,40(sp)
    80003750:	7402                	ld	s0,32(sp)
    80003752:	64e2                	ld	s1,24(sp)
    80003754:	6942                	ld	s2,16(sp)
    80003756:	69a2                	ld	s3,8(sp)
    80003758:	6a02                	ld	s4,0(sp)
    8000375a:	6145                	addi	sp,sp,48
    8000375c:	8082                	ret

000000008000375e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000375e:	7179                	addi	sp,sp,-48
    80003760:	f406                	sd	ra,40(sp)
    80003762:	f022                	sd	s0,32(sp)
    80003764:	ec26                	sd	s1,24(sp)
    80003766:	e84a                	sd	s2,16(sp)
    80003768:	e44e                	sd	s3,8(sp)
    8000376a:	1800                	addi	s0,sp,48
    8000376c:	892a                	mv	s2,a0
    8000376e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003770:	00036517          	auipc	a0,0x36
    80003774:	fb050513          	addi	a0,a0,-80 # 80039720 <bcache>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	78e080e7          	jalr	1934(ra) # 80000f06 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003780:	0003e497          	auipc	s1,0x3e
    80003784:	2584b483          	ld	s1,600(s1) # 800419d8 <bcache+0x82b8>
    80003788:	0003e797          	auipc	a5,0x3e
    8000378c:	20078793          	addi	a5,a5,512 # 80041988 <bcache+0x8268>
    80003790:	02f48f63          	beq	s1,a5,800037ce <bread+0x70>
    80003794:	873e                	mv	a4,a5
    80003796:	a021                	j	8000379e <bread+0x40>
    80003798:	68a4                	ld	s1,80(s1)
    8000379a:	02e48a63          	beq	s1,a4,800037ce <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000379e:	449c                	lw	a5,8(s1)
    800037a0:	ff279ce3          	bne	a5,s2,80003798 <bread+0x3a>
    800037a4:	44dc                	lw	a5,12(s1)
    800037a6:	ff3799e3          	bne	a5,s3,80003798 <bread+0x3a>
      b->refcnt++;
    800037aa:	40bc                	lw	a5,64(s1)
    800037ac:	2785                	addiw	a5,a5,1
    800037ae:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800037b0:	00036517          	auipc	a0,0x36
    800037b4:	f7050513          	addi	a0,a0,-144 # 80039720 <bcache>
    800037b8:	ffffe097          	auipc	ra,0xffffe
    800037bc:	802080e7          	jalr	-2046(ra) # 80000fba <release>
      acquiresleep(&b->lock);
    800037c0:	01048513          	addi	a0,s1,16
    800037c4:	00001097          	auipc	ra,0x1
    800037c8:	492080e7          	jalr	1170(ra) # 80004c56 <acquiresleep>
      return b;
    800037cc:	a8b9                	j	8000382a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037ce:	0003e497          	auipc	s1,0x3e
    800037d2:	2024b483          	ld	s1,514(s1) # 800419d0 <bcache+0x82b0>
    800037d6:	0003e797          	auipc	a5,0x3e
    800037da:	1b278793          	addi	a5,a5,434 # 80041988 <bcache+0x8268>
    800037de:	00f48863          	beq	s1,a5,800037ee <bread+0x90>
    800037e2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800037e4:	40bc                	lw	a5,64(s1)
    800037e6:	cf81                	beqz	a5,800037fe <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037e8:	64a4                	ld	s1,72(s1)
    800037ea:	fee49de3          	bne	s1,a4,800037e4 <bread+0x86>
  panic("bget: no buffers");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	d4a50513          	addi	a0,a0,-694 # 80008538 <__func__.1+0x530>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	d6a080e7          	jalr	-662(ra) # 80000560 <panic>
      b->dev = dev;
    800037fe:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003802:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003806:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000380a:	4785                	li	a5,1
    8000380c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000380e:	00036517          	auipc	a0,0x36
    80003812:	f1250513          	addi	a0,a0,-238 # 80039720 <bcache>
    80003816:	ffffd097          	auipc	ra,0xffffd
    8000381a:	7a4080e7          	jalr	1956(ra) # 80000fba <release>
      acquiresleep(&b->lock);
    8000381e:	01048513          	addi	a0,s1,16
    80003822:	00001097          	auipc	ra,0x1
    80003826:	434080e7          	jalr	1076(ra) # 80004c56 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000382a:	409c                	lw	a5,0(s1)
    8000382c:	cb89                	beqz	a5,8000383e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000382e:	8526                	mv	a0,s1
    80003830:	70a2                	ld	ra,40(sp)
    80003832:	7402                	ld	s0,32(sp)
    80003834:	64e2                	ld	s1,24(sp)
    80003836:	6942                	ld	s2,16(sp)
    80003838:	69a2                	ld	s3,8(sp)
    8000383a:	6145                	addi	sp,sp,48
    8000383c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000383e:	4581                	li	a1,0
    80003840:	8526                	mv	a0,s1
    80003842:	00003097          	auipc	ra,0x3
    80003846:	0f6080e7          	jalr	246(ra) # 80006938 <virtio_disk_rw>
    b->valid = 1;
    8000384a:	4785                	li	a5,1
    8000384c:	c09c                	sw	a5,0(s1)
  return b;
    8000384e:	b7c5                	j	8000382e <bread+0xd0>

0000000080003850 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003850:	1101                	addi	sp,sp,-32
    80003852:	ec06                	sd	ra,24(sp)
    80003854:	e822                	sd	s0,16(sp)
    80003856:	e426                	sd	s1,8(sp)
    80003858:	1000                	addi	s0,sp,32
    8000385a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000385c:	0541                	addi	a0,a0,16
    8000385e:	00001097          	auipc	ra,0x1
    80003862:	492080e7          	jalr	1170(ra) # 80004cf0 <holdingsleep>
    80003866:	cd01                	beqz	a0,8000387e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003868:	4585                	li	a1,1
    8000386a:	8526                	mv	a0,s1
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	0cc080e7          	jalr	204(ra) # 80006938 <virtio_disk_rw>
}
    80003874:	60e2                	ld	ra,24(sp)
    80003876:	6442                	ld	s0,16(sp)
    80003878:	64a2                	ld	s1,8(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret
    panic("bwrite");
    8000387e:	00005517          	auipc	a0,0x5
    80003882:	cd250513          	addi	a0,a0,-814 # 80008550 <__func__.1+0x548>
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	cda080e7          	jalr	-806(ra) # 80000560 <panic>

000000008000388e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
    8000389a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000389c:	01050913          	addi	s2,a0,16
    800038a0:	854a                	mv	a0,s2
    800038a2:	00001097          	auipc	ra,0x1
    800038a6:	44e080e7          	jalr	1102(ra) # 80004cf0 <holdingsleep>
    800038aa:	c925                	beqz	a0,8000391a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800038ac:	854a                	mv	a0,s2
    800038ae:	00001097          	auipc	ra,0x1
    800038b2:	3fe080e7          	jalr	1022(ra) # 80004cac <releasesleep>

  acquire(&bcache.lock);
    800038b6:	00036517          	auipc	a0,0x36
    800038ba:	e6a50513          	addi	a0,a0,-406 # 80039720 <bcache>
    800038be:	ffffd097          	auipc	ra,0xffffd
    800038c2:	648080e7          	jalr	1608(ra) # 80000f06 <acquire>
  b->refcnt--;
    800038c6:	40bc                	lw	a5,64(s1)
    800038c8:	37fd                	addiw	a5,a5,-1
    800038ca:	0007871b          	sext.w	a4,a5
    800038ce:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800038d0:	e71d                	bnez	a4,800038fe <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800038d2:	68b8                	ld	a4,80(s1)
    800038d4:	64bc                	ld	a5,72(s1)
    800038d6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800038d8:	68b8                	ld	a4,80(s1)
    800038da:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800038dc:	0003e797          	auipc	a5,0x3e
    800038e0:	e4478793          	addi	a5,a5,-444 # 80041720 <bcache+0x8000>
    800038e4:	2b87b703          	ld	a4,696(a5)
    800038e8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800038ea:	0003e717          	auipc	a4,0x3e
    800038ee:	09e70713          	addi	a4,a4,158 # 80041988 <bcache+0x8268>
    800038f2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800038f4:	2b87b703          	ld	a4,696(a5)
    800038f8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800038fa:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800038fe:	00036517          	auipc	a0,0x36
    80003902:	e2250513          	addi	a0,a0,-478 # 80039720 <bcache>
    80003906:	ffffd097          	auipc	ra,0xffffd
    8000390a:	6b4080e7          	jalr	1716(ra) # 80000fba <release>
}
    8000390e:	60e2                	ld	ra,24(sp)
    80003910:	6442                	ld	s0,16(sp)
    80003912:	64a2                	ld	s1,8(sp)
    80003914:	6902                	ld	s2,0(sp)
    80003916:	6105                	addi	sp,sp,32
    80003918:	8082                	ret
    panic("brelse");
    8000391a:	00005517          	auipc	a0,0x5
    8000391e:	c3e50513          	addi	a0,a0,-962 # 80008558 <__func__.1+0x550>
    80003922:	ffffd097          	auipc	ra,0xffffd
    80003926:	c3e080e7          	jalr	-962(ra) # 80000560 <panic>

000000008000392a <bpin>:

void
bpin(struct buf *b) {
    8000392a:	1101                	addi	sp,sp,-32
    8000392c:	ec06                	sd	ra,24(sp)
    8000392e:	e822                	sd	s0,16(sp)
    80003930:	e426                	sd	s1,8(sp)
    80003932:	1000                	addi	s0,sp,32
    80003934:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003936:	00036517          	auipc	a0,0x36
    8000393a:	dea50513          	addi	a0,a0,-534 # 80039720 <bcache>
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	5c8080e7          	jalr	1480(ra) # 80000f06 <acquire>
  b->refcnt++;
    80003946:	40bc                	lw	a5,64(s1)
    80003948:	2785                	addiw	a5,a5,1
    8000394a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000394c:	00036517          	auipc	a0,0x36
    80003950:	dd450513          	addi	a0,a0,-556 # 80039720 <bcache>
    80003954:	ffffd097          	auipc	ra,0xffffd
    80003958:	666080e7          	jalr	1638(ra) # 80000fba <release>
}
    8000395c:	60e2                	ld	ra,24(sp)
    8000395e:	6442                	ld	s0,16(sp)
    80003960:	64a2                	ld	s1,8(sp)
    80003962:	6105                	addi	sp,sp,32
    80003964:	8082                	ret

0000000080003966 <bunpin>:

void
bunpin(struct buf *b) {
    80003966:	1101                	addi	sp,sp,-32
    80003968:	ec06                	sd	ra,24(sp)
    8000396a:	e822                	sd	s0,16(sp)
    8000396c:	e426                	sd	s1,8(sp)
    8000396e:	1000                	addi	s0,sp,32
    80003970:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003972:	00036517          	auipc	a0,0x36
    80003976:	dae50513          	addi	a0,a0,-594 # 80039720 <bcache>
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	58c080e7          	jalr	1420(ra) # 80000f06 <acquire>
  b->refcnt--;
    80003982:	40bc                	lw	a5,64(s1)
    80003984:	37fd                	addiw	a5,a5,-1
    80003986:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003988:	00036517          	auipc	a0,0x36
    8000398c:	d9850513          	addi	a0,a0,-616 # 80039720 <bcache>
    80003990:	ffffd097          	auipc	ra,0xffffd
    80003994:	62a080e7          	jalr	1578(ra) # 80000fba <release>
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6105                	addi	sp,sp,32
    800039a0:	8082                	ret

00000000800039a2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800039a2:	1101                	addi	sp,sp,-32
    800039a4:	ec06                	sd	ra,24(sp)
    800039a6:	e822                	sd	s0,16(sp)
    800039a8:	e426                	sd	s1,8(sp)
    800039aa:	e04a                	sd	s2,0(sp)
    800039ac:	1000                	addi	s0,sp,32
    800039ae:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800039b0:	00d5d59b          	srliw	a1,a1,0xd
    800039b4:	0003e797          	auipc	a5,0x3e
    800039b8:	4487a783          	lw	a5,1096(a5) # 80041dfc <sb+0x1c>
    800039bc:	9dbd                	addw	a1,a1,a5
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	da0080e7          	jalr	-608(ra) # 8000375e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800039c6:	0074f713          	andi	a4,s1,7
    800039ca:	4785                	li	a5,1
    800039cc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800039d0:	14ce                	slli	s1,s1,0x33
    800039d2:	90d9                	srli	s1,s1,0x36
    800039d4:	00950733          	add	a4,a0,s1
    800039d8:	05874703          	lbu	a4,88(a4)
    800039dc:	00e7f6b3          	and	a3,a5,a4
    800039e0:	c69d                	beqz	a3,80003a0e <bfree+0x6c>
    800039e2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800039e4:	94aa                	add	s1,s1,a0
    800039e6:	fff7c793          	not	a5,a5
    800039ea:	8f7d                	and	a4,a4,a5
    800039ec:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800039f0:	00001097          	auipc	ra,0x1
    800039f4:	148080e7          	jalr	328(ra) # 80004b38 <log_write>
  brelse(bp);
    800039f8:	854a                	mv	a0,s2
    800039fa:	00000097          	auipc	ra,0x0
    800039fe:	e94080e7          	jalr	-364(ra) # 8000388e <brelse>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6902                	ld	s2,0(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret
    panic("freeing free block");
    80003a0e:	00005517          	auipc	a0,0x5
    80003a12:	b5250513          	addi	a0,a0,-1198 # 80008560 <__func__.1+0x558>
    80003a16:	ffffd097          	auipc	ra,0xffffd
    80003a1a:	b4a080e7          	jalr	-1206(ra) # 80000560 <panic>

0000000080003a1e <balloc>:
{
    80003a1e:	711d                	addi	sp,sp,-96
    80003a20:	ec86                	sd	ra,88(sp)
    80003a22:	e8a2                	sd	s0,80(sp)
    80003a24:	e4a6                	sd	s1,72(sp)
    80003a26:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003a28:	0003e797          	auipc	a5,0x3e
    80003a2c:	3bc7a783          	lw	a5,956(a5) # 80041de4 <sb+0x4>
    80003a30:	10078f63          	beqz	a5,80003b4e <balloc+0x130>
    80003a34:	e0ca                	sd	s2,64(sp)
    80003a36:	fc4e                	sd	s3,56(sp)
    80003a38:	f852                	sd	s4,48(sp)
    80003a3a:	f456                	sd	s5,40(sp)
    80003a3c:	f05a                	sd	s6,32(sp)
    80003a3e:	ec5e                	sd	s7,24(sp)
    80003a40:	e862                	sd	s8,16(sp)
    80003a42:	e466                	sd	s9,8(sp)
    80003a44:	8baa                	mv	s7,a0
    80003a46:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003a48:	0003eb17          	auipc	s6,0x3e
    80003a4c:	398b0b13          	addi	s6,s6,920 # 80041de0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a50:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003a52:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a54:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003a56:	6c89                	lui	s9,0x2
    80003a58:	a061                	j	80003ae0 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003a5a:	97ca                	add	a5,a5,s2
    80003a5c:	8e55                	or	a2,a2,a3
    80003a5e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003a62:	854a                	mv	a0,s2
    80003a64:	00001097          	auipc	ra,0x1
    80003a68:	0d4080e7          	jalr	212(ra) # 80004b38 <log_write>
        brelse(bp);
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	e20080e7          	jalr	-480(ra) # 8000388e <brelse>
  bp = bread(dev, bno);
    80003a76:	85a6                	mv	a1,s1
    80003a78:	855e                	mv	a0,s7
    80003a7a:	00000097          	auipc	ra,0x0
    80003a7e:	ce4080e7          	jalr	-796(ra) # 8000375e <bread>
    80003a82:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003a84:	40000613          	li	a2,1024
    80003a88:	4581                	li	a1,0
    80003a8a:	05850513          	addi	a0,a0,88
    80003a8e:	ffffd097          	auipc	ra,0xffffd
    80003a92:	574080e7          	jalr	1396(ra) # 80001002 <memset>
  log_write(bp);
    80003a96:	854a                	mv	a0,s2
    80003a98:	00001097          	auipc	ra,0x1
    80003a9c:	0a0080e7          	jalr	160(ra) # 80004b38 <log_write>
  brelse(bp);
    80003aa0:	854a                	mv	a0,s2
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	dec080e7          	jalr	-532(ra) # 8000388e <brelse>
}
    80003aaa:	6906                	ld	s2,64(sp)
    80003aac:	79e2                	ld	s3,56(sp)
    80003aae:	7a42                	ld	s4,48(sp)
    80003ab0:	7aa2                	ld	s5,40(sp)
    80003ab2:	7b02                	ld	s6,32(sp)
    80003ab4:	6be2                	ld	s7,24(sp)
    80003ab6:	6c42                	ld	s8,16(sp)
    80003ab8:	6ca2                	ld	s9,8(sp)
}
    80003aba:	8526                	mv	a0,s1
    80003abc:	60e6                	ld	ra,88(sp)
    80003abe:	6446                	ld	s0,80(sp)
    80003ac0:	64a6                	ld	s1,72(sp)
    80003ac2:	6125                	addi	sp,sp,96
    80003ac4:	8082                	ret
    brelse(bp);
    80003ac6:	854a                	mv	a0,s2
    80003ac8:	00000097          	auipc	ra,0x0
    80003acc:	dc6080e7          	jalr	-570(ra) # 8000388e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003ad0:	015c87bb          	addw	a5,s9,s5
    80003ad4:	00078a9b          	sext.w	s5,a5
    80003ad8:	004b2703          	lw	a4,4(s6)
    80003adc:	06eaf163          	bgeu	s5,a4,80003b3e <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003ae0:	41fad79b          	sraiw	a5,s5,0x1f
    80003ae4:	0137d79b          	srliw	a5,a5,0x13
    80003ae8:	015787bb          	addw	a5,a5,s5
    80003aec:	40d7d79b          	sraiw	a5,a5,0xd
    80003af0:	01cb2583          	lw	a1,28(s6)
    80003af4:	9dbd                	addw	a1,a1,a5
    80003af6:	855e                	mv	a0,s7
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	c66080e7          	jalr	-922(ra) # 8000375e <bread>
    80003b00:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b02:	004b2503          	lw	a0,4(s6)
    80003b06:	000a849b          	sext.w	s1,s5
    80003b0a:	8762                	mv	a4,s8
    80003b0c:	faa4fde3          	bgeu	s1,a0,80003ac6 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003b10:	00777693          	andi	a3,a4,7
    80003b14:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003b18:	41f7579b          	sraiw	a5,a4,0x1f
    80003b1c:	01d7d79b          	srliw	a5,a5,0x1d
    80003b20:	9fb9                	addw	a5,a5,a4
    80003b22:	4037d79b          	sraiw	a5,a5,0x3
    80003b26:	00f90633          	add	a2,s2,a5
    80003b2a:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003b2e:	00c6f5b3          	and	a1,a3,a2
    80003b32:	d585                	beqz	a1,80003a5a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b34:	2705                	addiw	a4,a4,1
    80003b36:	2485                	addiw	s1,s1,1
    80003b38:	fd471ae3          	bne	a4,s4,80003b0c <balloc+0xee>
    80003b3c:	b769                	j	80003ac6 <balloc+0xa8>
    80003b3e:	6906                	ld	s2,64(sp)
    80003b40:	79e2                	ld	s3,56(sp)
    80003b42:	7a42                	ld	s4,48(sp)
    80003b44:	7aa2                	ld	s5,40(sp)
    80003b46:	7b02                	ld	s6,32(sp)
    80003b48:	6be2                	ld	s7,24(sp)
    80003b4a:	6c42                	ld	s8,16(sp)
    80003b4c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003b4e:	00005517          	auipc	a0,0x5
    80003b52:	a2a50513          	addi	a0,a0,-1494 # 80008578 <__func__.1+0x570>
    80003b56:	ffffd097          	auipc	ra,0xffffd
    80003b5a:	a66080e7          	jalr	-1434(ra) # 800005bc <printf>
  return 0;
    80003b5e:	4481                	li	s1,0
    80003b60:	bfa9                	j	80003aba <balloc+0x9c>

0000000080003b62 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003b62:	7179                	addi	sp,sp,-48
    80003b64:	f406                	sd	ra,40(sp)
    80003b66:	f022                	sd	s0,32(sp)
    80003b68:	ec26                	sd	s1,24(sp)
    80003b6a:	e84a                	sd	s2,16(sp)
    80003b6c:	e44e                	sd	s3,8(sp)
    80003b6e:	1800                	addi	s0,sp,48
    80003b70:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003b72:	47ad                	li	a5,11
    80003b74:	02b7e863          	bltu	a5,a1,80003ba4 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003b78:	02059793          	slli	a5,a1,0x20
    80003b7c:	01e7d593          	srli	a1,a5,0x1e
    80003b80:	00b504b3          	add	s1,a0,a1
    80003b84:	0504a903          	lw	s2,80(s1)
    80003b88:	08091263          	bnez	s2,80003c0c <bmap+0xaa>
      addr = balloc(ip->dev);
    80003b8c:	4108                	lw	a0,0(a0)
    80003b8e:	00000097          	auipc	ra,0x0
    80003b92:	e90080e7          	jalr	-368(ra) # 80003a1e <balloc>
    80003b96:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003b9a:	06090963          	beqz	s2,80003c0c <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003b9e:	0524a823          	sw	s2,80(s1)
    80003ba2:	a0ad                	j	80003c0c <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003ba4:	ff45849b          	addiw	s1,a1,-12
    80003ba8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003bac:	0ff00793          	li	a5,255
    80003bb0:	08e7e863          	bltu	a5,a4,80003c40 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003bb4:	08052903          	lw	s2,128(a0)
    80003bb8:	00091f63          	bnez	s2,80003bd6 <bmap+0x74>
      addr = balloc(ip->dev);
    80003bbc:	4108                	lw	a0,0(a0)
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	e60080e7          	jalr	-416(ra) # 80003a1e <balloc>
    80003bc6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003bca:	04090163          	beqz	s2,80003c0c <bmap+0xaa>
    80003bce:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003bd0:	0929a023          	sw	s2,128(s3)
    80003bd4:	a011                	j	80003bd8 <bmap+0x76>
    80003bd6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003bd8:	85ca                	mv	a1,s2
    80003bda:	0009a503          	lw	a0,0(s3)
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	b80080e7          	jalr	-1152(ra) # 8000375e <bread>
    80003be6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003be8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003bec:	02049713          	slli	a4,s1,0x20
    80003bf0:	01e75593          	srli	a1,a4,0x1e
    80003bf4:	00b784b3          	add	s1,a5,a1
    80003bf8:	0004a903          	lw	s2,0(s1)
    80003bfc:	02090063          	beqz	s2,80003c1c <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003c00:	8552                	mv	a0,s4
    80003c02:	00000097          	auipc	ra,0x0
    80003c06:	c8c080e7          	jalr	-884(ra) # 8000388e <brelse>
    return addr;
    80003c0a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6145                	addi	sp,sp,48
    80003c1a:	8082                	ret
      addr = balloc(ip->dev);
    80003c1c:	0009a503          	lw	a0,0(s3)
    80003c20:	00000097          	auipc	ra,0x0
    80003c24:	dfe080e7          	jalr	-514(ra) # 80003a1e <balloc>
    80003c28:	0005091b          	sext.w	s2,a0
      if(addr){
    80003c2c:	fc090ae3          	beqz	s2,80003c00 <bmap+0x9e>
        a[bn] = addr;
    80003c30:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003c34:	8552                	mv	a0,s4
    80003c36:	00001097          	auipc	ra,0x1
    80003c3a:	f02080e7          	jalr	-254(ra) # 80004b38 <log_write>
    80003c3e:	b7c9                	j	80003c00 <bmap+0x9e>
    80003c40:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003c42:	00005517          	auipc	a0,0x5
    80003c46:	94e50513          	addi	a0,a0,-1714 # 80008590 <__func__.1+0x588>
    80003c4a:	ffffd097          	auipc	ra,0xffffd
    80003c4e:	916080e7          	jalr	-1770(ra) # 80000560 <panic>

0000000080003c52 <iget>:
{
    80003c52:	7179                	addi	sp,sp,-48
    80003c54:	f406                	sd	ra,40(sp)
    80003c56:	f022                	sd	s0,32(sp)
    80003c58:	ec26                	sd	s1,24(sp)
    80003c5a:	e84a                	sd	s2,16(sp)
    80003c5c:	e44e                	sd	s3,8(sp)
    80003c5e:	e052                	sd	s4,0(sp)
    80003c60:	1800                	addi	s0,sp,48
    80003c62:	89aa                	mv	s3,a0
    80003c64:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003c66:	0003e517          	auipc	a0,0x3e
    80003c6a:	19a50513          	addi	a0,a0,410 # 80041e00 <itable>
    80003c6e:	ffffd097          	auipc	ra,0xffffd
    80003c72:	298080e7          	jalr	664(ra) # 80000f06 <acquire>
  empty = 0;
    80003c76:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c78:	0003e497          	auipc	s1,0x3e
    80003c7c:	1a048493          	addi	s1,s1,416 # 80041e18 <itable+0x18>
    80003c80:	00040697          	auipc	a3,0x40
    80003c84:	c2868693          	addi	a3,a3,-984 # 800438a8 <log>
    80003c88:	a039                	j	80003c96 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003c8a:	02090b63          	beqz	s2,80003cc0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c8e:	08848493          	addi	s1,s1,136
    80003c92:	02d48a63          	beq	s1,a3,80003cc6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003c96:	449c                	lw	a5,8(s1)
    80003c98:	fef059e3          	blez	a5,80003c8a <iget+0x38>
    80003c9c:	4098                	lw	a4,0(s1)
    80003c9e:	ff3716e3          	bne	a4,s3,80003c8a <iget+0x38>
    80003ca2:	40d8                	lw	a4,4(s1)
    80003ca4:	ff4713e3          	bne	a4,s4,80003c8a <iget+0x38>
      ip->ref++;
    80003ca8:	2785                	addiw	a5,a5,1
    80003caa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003cac:	0003e517          	auipc	a0,0x3e
    80003cb0:	15450513          	addi	a0,a0,340 # 80041e00 <itable>
    80003cb4:	ffffd097          	auipc	ra,0xffffd
    80003cb8:	306080e7          	jalr	774(ra) # 80000fba <release>
      return ip;
    80003cbc:	8926                	mv	s2,s1
    80003cbe:	a03d                	j	80003cec <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003cc0:	f7f9                	bnez	a5,80003c8e <iget+0x3c>
      empty = ip;
    80003cc2:	8926                	mv	s2,s1
    80003cc4:	b7e9                	j	80003c8e <iget+0x3c>
  if(empty == 0)
    80003cc6:	02090c63          	beqz	s2,80003cfe <iget+0xac>
  ip->dev = dev;
    80003cca:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003cce:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003cd2:	4785                	li	a5,1
    80003cd4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003cd8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003cdc:	0003e517          	auipc	a0,0x3e
    80003ce0:	12450513          	addi	a0,a0,292 # 80041e00 <itable>
    80003ce4:	ffffd097          	auipc	ra,0xffffd
    80003ce8:	2d6080e7          	jalr	726(ra) # 80000fba <release>
}
    80003cec:	854a                	mv	a0,s2
    80003cee:	70a2                	ld	ra,40(sp)
    80003cf0:	7402                	ld	s0,32(sp)
    80003cf2:	64e2                	ld	s1,24(sp)
    80003cf4:	6942                	ld	s2,16(sp)
    80003cf6:	69a2                	ld	s3,8(sp)
    80003cf8:	6a02                	ld	s4,0(sp)
    80003cfa:	6145                	addi	sp,sp,48
    80003cfc:	8082                	ret
    panic("iget: no inodes");
    80003cfe:	00005517          	auipc	a0,0x5
    80003d02:	8aa50513          	addi	a0,a0,-1878 # 800085a8 <__func__.1+0x5a0>
    80003d06:	ffffd097          	auipc	ra,0xffffd
    80003d0a:	85a080e7          	jalr	-1958(ra) # 80000560 <panic>

0000000080003d0e <fsinit>:
fsinit(int dev) {
    80003d0e:	7179                	addi	sp,sp,-48
    80003d10:	f406                	sd	ra,40(sp)
    80003d12:	f022                	sd	s0,32(sp)
    80003d14:	ec26                	sd	s1,24(sp)
    80003d16:	e84a                	sd	s2,16(sp)
    80003d18:	e44e                	sd	s3,8(sp)
    80003d1a:	1800                	addi	s0,sp,48
    80003d1c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d1e:	4585                	li	a1,1
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	a3e080e7          	jalr	-1474(ra) # 8000375e <bread>
    80003d28:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003d2a:	0003e997          	auipc	s3,0x3e
    80003d2e:	0b698993          	addi	s3,s3,182 # 80041de0 <sb>
    80003d32:	02000613          	li	a2,32
    80003d36:	05850593          	addi	a1,a0,88
    80003d3a:	854e                	mv	a0,s3
    80003d3c:	ffffd097          	auipc	ra,0xffffd
    80003d40:	322080e7          	jalr	802(ra) # 8000105e <memmove>
  brelse(bp);
    80003d44:	8526                	mv	a0,s1
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	b48080e7          	jalr	-1208(ra) # 8000388e <brelse>
  if(sb.magic != FSMAGIC)
    80003d4e:	0009a703          	lw	a4,0(s3)
    80003d52:	102037b7          	lui	a5,0x10203
    80003d56:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d5a:	02f71263          	bne	a4,a5,80003d7e <fsinit+0x70>
  initlog(dev, &sb);
    80003d5e:	0003e597          	auipc	a1,0x3e
    80003d62:	08258593          	addi	a1,a1,130 # 80041de0 <sb>
    80003d66:	854a                	mv	a0,s2
    80003d68:	00001097          	auipc	ra,0x1
    80003d6c:	b60080e7          	jalr	-1184(ra) # 800048c8 <initlog>
}
    80003d70:	70a2                	ld	ra,40(sp)
    80003d72:	7402                	ld	s0,32(sp)
    80003d74:	64e2                	ld	s1,24(sp)
    80003d76:	6942                	ld	s2,16(sp)
    80003d78:	69a2                	ld	s3,8(sp)
    80003d7a:	6145                	addi	sp,sp,48
    80003d7c:	8082                	ret
    panic("invalid file system");
    80003d7e:	00005517          	auipc	a0,0x5
    80003d82:	83a50513          	addi	a0,a0,-1990 # 800085b8 <__func__.1+0x5b0>
    80003d86:	ffffc097          	auipc	ra,0xffffc
    80003d8a:	7da080e7          	jalr	2010(ra) # 80000560 <panic>

0000000080003d8e <iinit>:
{
    80003d8e:	7179                	addi	sp,sp,-48
    80003d90:	f406                	sd	ra,40(sp)
    80003d92:	f022                	sd	s0,32(sp)
    80003d94:	ec26                	sd	s1,24(sp)
    80003d96:	e84a                	sd	s2,16(sp)
    80003d98:	e44e                	sd	s3,8(sp)
    80003d9a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003d9c:	00005597          	auipc	a1,0x5
    80003da0:	83458593          	addi	a1,a1,-1996 # 800085d0 <__func__.1+0x5c8>
    80003da4:	0003e517          	auipc	a0,0x3e
    80003da8:	05c50513          	addi	a0,a0,92 # 80041e00 <itable>
    80003dac:	ffffd097          	auipc	ra,0xffffd
    80003db0:	0ca080e7          	jalr	202(ra) # 80000e76 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003db4:	0003e497          	auipc	s1,0x3e
    80003db8:	07448493          	addi	s1,s1,116 # 80041e28 <itable+0x28>
    80003dbc:	00040997          	auipc	s3,0x40
    80003dc0:	afc98993          	addi	s3,s3,-1284 # 800438b8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003dc4:	00005917          	auipc	s2,0x5
    80003dc8:	81490913          	addi	s2,s2,-2028 # 800085d8 <__func__.1+0x5d0>
    80003dcc:	85ca                	mv	a1,s2
    80003dce:	8526                	mv	a0,s1
    80003dd0:	00001097          	auipc	ra,0x1
    80003dd4:	e4c080e7          	jalr	-436(ra) # 80004c1c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003dd8:	08848493          	addi	s1,s1,136
    80003ddc:	ff3498e3          	bne	s1,s3,80003dcc <iinit+0x3e>
}
    80003de0:	70a2                	ld	ra,40(sp)
    80003de2:	7402                	ld	s0,32(sp)
    80003de4:	64e2                	ld	s1,24(sp)
    80003de6:	6942                	ld	s2,16(sp)
    80003de8:	69a2                	ld	s3,8(sp)
    80003dea:	6145                	addi	sp,sp,48
    80003dec:	8082                	ret

0000000080003dee <ialloc>:
{
    80003dee:	7139                	addi	sp,sp,-64
    80003df0:	fc06                	sd	ra,56(sp)
    80003df2:	f822                	sd	s0,48(sp)
    80003df4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003df6:	0003e717          	auipc	a4,0x3e
    80003dfa:	ff672703          	lw	a4,-10(a4) # 80041dec <sb+0xc>
    80003dfe:	4785                	li	a5,1
    80003e00:	06e7f463          	bgeu	a5,a4,80003e68 <ialloc+0x7a>
    80003e04:	f426                	sd	s1,40(sp)
    80003e06:	f04a                	sd	s2,32(sp)
    80003e08:	ec4e                	sd	s3,24(sp)
    80003e0a:	e852                	sd	s4,16(sp)
    80003e0c:	e456                	sd	s5,8(sp)
    80003e0e:	e05a                	sd	s6,0(sp)
    80003e10:	8aaa                	mv	s5,a0
    80003e12:	8b2e                	mv	s6,a1
    80003e14:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003e16:	0003ea17          	auipc	s4,0x3e
    80003e1a:	fcaa0a13          	addi	s4,s4,-54 # 80041de0 <sb>
    80003e1e:	00495593          	srli	a1,s2,0x4
    80003e22:	018a2783          	lw	a5,24(s4)
    80003e26:	9dbd                	addw	a1,a1,a5
    80003e28:	8556                	mv	a0,s5
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	934080e7          	jalr	-1740(ra) # 8000375e <bread>
    80003e32:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003e34:	05850993          	addi	s3,a0,88
    80003e38:	00f97793          	andi	a5,s2,15
    80003e3c:	079a                	slli	a5,a5,0x6
    80003e3e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003e40:	00099783          	lh	a5,0(s3)
    80003e44:	cf9d                	beqz	a5,80003e82 <ialloc+0x94>
    brelse(bp);
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	a48080e7          	jalr	-1464(ra) # 8000388e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e4e:	0905                	addi	s2,s2,1
    80003e50:	00ca2703          	lw	a4,12(s4)
    80003e54:	0009079b          	sext.w	a5,s2
    80003e58:	fce7e3e3          	bltu	a5,a4,80003e1e <ialloc+0x30>
    80003e5c:	74a2                	ld	s1,40(sp)
    80003e5e:	7902                	ld	s2,32(sp)
    80003e60:	69e2                	ld	s3,24(sp)
    80003e62:	6a42                	ld	s4,16(sp)
    80003e64:	6aa2                	ld	s5,8(sp)
    80003e66:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003e68:	00004517          	auipc	a0,0x4
    80003e6c:	77850513          	addi	a0,a0,1912 # 800085e0 <__func__.1+0x5d8>
    80003e70:	ffffc097          	auipc	ra,0xffffc
    80003e74:	74c080e7          	jalr	1868(ra) # 800005bc <printf>
  return 0;
    80003e78:	4501                	li	a0,0
}
    80003e7a:	70e2                	ld	ra,56(sp)
    80003e7c:	7442                	ld	s0,48(sp)
    80003e7e:	6121                	addi	sp,sp,64
    80003e80:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003e82:	04000613          	li	a2,64
    80003e86:	4581                	li	a1,0
    80003e88:	854e                	mv	a0,s3
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	178080e7          	jalr	376(ra) # 80001002 <memset>
      dip->type = type;
    80003e92:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003e96:	8526                	mv	a0,s1
    80003e98:	00001097          	auipc	ra,0x1
    80003e9c:	ca0080e7          	jalr	-864(ra) # 80004b38 <log_write>
      brelse(bp);
    80003ea0:	8526                	mv	a0,s1
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	9ec080e7          	jalr	-1556(ra) # 8000388e <brelse>
      return iget(dev, inum);
    80003eaa:	0009059b          	sext.w	a1,s2
    80003eae:	8556                	mv	a0,s5
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	da2080e7          	jalr	-606(ra) # 80003c52 <iget>
    80003eb8:	74a2                	ld	s1,40(sp)
    80003eba:	7902                	ld	s2,32(sp)
    80003ebc:	69e2                	ld	s3,24(sp)
    80003ebe:	6a42                	ld	s4,16(sp)
    80003ec0:	6aa2                	ld	s5,8(sp)
    80003ec2:	6b02                	ld	s6,0(sp)
    80003ec4:	bf5d                	j	80003e7a <ialloc+0x8c>

0000000080003ec6 <iupdate>:
{
    80003ec6:	1101                	addi	sp,sp,-32
    80003ec8:	ec06                	sd	ra,24(sp)
    80003eca:	e822                	sd	s0,16(sp)
    80003ecc:	e426                	sd	s1,8(sp)
    80003ece:	e04a                	sd	s2,0(sp)
    80003ed0:	1000                	addi	s0,sp,32
    80003ed2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ed4:	415c                	lw	a5,4(a0)
    80003ed6:	0047d79b          	srliw	a5,a5,0x4
    80003eda:	0003e597          	auipc	a1,0x3e
    80003ede:	f1e5a583          	lw	a1,-226(a1) # 80041df8 <sb+0x18>
    80003ee2:	9dbd                	addw	a1,a1,a5
    80003ee4:	4108                	lw	a0,0(a0)
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	878080e7          	jalr	-1928(ra) # 8000375e <bread>
    80003eee:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ef0:	05850793          	addi	a5,a0,88
    80003ef4:	40d8                	lw	a4,4(s1)
    80003ef6:	8b3d                	andi	a4,a4,15
    80003ef8:	071a                	slli	a4,a4,0x6
    80003efa:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003efc:	04449703          	lh	a4,68(s1)
    80003f00:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003f04:	04649703          	lh	a4,70(s1)
    80003f08:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003f0c:	04849703          	lh	a4,72(s1)
    80003f10:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003f14:	04a49703          	lh	a4,74(s1)
    80003f18:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003f1c:	44f8                	lw	a4,76(s1)
    80003f1e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003f20:	03400613          	li	a2,52
    80003f24:	05048593          	addi	a1,s1,80
    80003f28:	00c78513          	addi	a0,a5,12
    80003f2c:	ffffd097          	auipc	ra,0xffffd
    80003f30:	132080e7          	jalr	306(ra) # 8000105e <memmove>
  log_write(bp);
    80003f34:	854a                	mv	a0,s2
    80003f36:	00001097          	auipc	ra,0x1
    80003f3a:	c02080e7          	jalr	-1022(ra) # 80004b38 <log_write>
  brelse(bp);
    80003f3e:	854a                	mv	a0,s2
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	94e080e7          	jalr	-1714(ra) # 8000388e <brelse>
}
    80003f48:	60e2                	ld	ra,24(sp)
    80003f4a:	6442                	ld	s0,16(sp)
    80003f4c:	64a2                	ld	s1,8(sp)
    80003f4e:	6902                	ld	s2,0(sp)
    80003f50:	6105                	addi	sp,sp,32
    80003f52:	8082                	ret

0000000080003f54 <idup>:
{
    80003f54:	1101                	addi	sp,sp,-32
    80003f56:	ec06                	sd	ra,24(sp)
    80003f58:	e822                	sd	s0,16(sp)
    80003f5a:	e426                	sd	s1,8(sp)
    80003f5c:	1000                	addi	s0,sp,32
    80003f5e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f60:	0003e517          	auipc	a0,0x3e
    80003f64:	ea050513          	addi	a0,a0,-352 # 80041e00 <itable>
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	f9e080e7          	jalr	-98(ra) # 80000f06 <acquire>
  ip->ref++;
    80003f70:	449c                	lw	a5,8(s1)
    80003f72:	2785                	addiw	a5,a5,1
    80003f74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f76:	0003e517          	auipc	a0,0x3e
    80003f7a:	e8a50513          	addi	a0,a0,-374 # 80041e00 <itable>
    80003f7e:	ffffd097          	auipc	ra,0xffffd
    80003f82:	03c080e7          	jalr	60(ra) # 80000fba <release>
}
    80003f86:	8526                	mv	a0,s1
    80003f88:	60e2                	ld	ra,24(sp)
    80003f8a:	6442                	ld	s0,16(sp)
    80003f8c:	64a2                	ld	s1,8(sp)
    80003f8e:	6105                	addi	sp,sp,32
    80003f90:	8082                	ret

0000000080003f92 <ilock>:
{
    80003f92:	1101                	addi	sp,sp,-32
    80003f94:	ec06                	sd	ra,24(sp)
    80003f96:	e822                	sd	s0,16(sp)
    80003f98:	e426                	sd	s1,8(sp)
    80003f9a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003f9c:	c10d                	beqz	a0,80003fbe <ilock+0x2c>
    80003f9e:	84aa                	mv	s1,a0
    80003fa0:	451c                	lw	a5,8(a0)
    80003fa2:	00f05e63          	blez	a5,80003fbe <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003fa6:	0541                	addi	a0,a0,16
    80003fa8:	00001097          	auipc	ra,0x1
    80003fac:	cae080e7          	jalr	-850(ra) # 80004c56 <acquiresleep>
  if(ip->valid == 0){
    80003fb0:	40bc                	lw	a5,64(s1)
    80003fb2:	cf99                	beqz	a5,80003fd0 <ilock+0x3e>
}
    80003fb4:	60e2                	ld	ra,24(sp)
    80003fb6:	6442                	ld	s0,16(sp)
    80003fb8:	64a2                	ld	s1,8(sp)
    80003fba:	6105                	addi	sp,sp,32
    80003fbc:	8082                	ret
    80003fbe:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003fc0:	00004517          	auipc	a0,0x4
    80003fc4:	63850513          	addi	a0,a0,1592 # 800085f8 <__func__.1+0x5f0>
    80003fc8:	ffffc097          	auipc	ra,0xffffc
    80003fcc:	598080e7          	jalr	1432(ra) # 80000560 <panic>
    80003fd0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003fd2:	40dc                	lw	a5,4(s1)
    80003fd4:	0047d79b          	srliw	a5,a5,0x4
    80003fd8:	0003e597          	auipc	a1,0x3e
    80003fdc:	e205a583          	lw	a1,-480(a1) # 80041df8 <sb+0x18>
    80003fe0:	9dbd                	addw	a1,a1,a5
    80003fe2:	4088                	lw	a0,0(s1)
    80003fe4:	fffff097          	auipc	ra,0xfffff
    80003fe8:	77a080e7          	jalr	1914(ra) # 8000375e <bread>
    80003fec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003fee:	05850593          	addi	a1,a0,88
    80003ff2:	40dc                	lw	a5,4(s1)
    80003ff4:	8bbd                	andi	a5,a5,15
    80003ff6:	079a                	slli	a5,a5,0x6
    80003ff8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ffa:	00059783          	lh	a5,0(a1)
    80003ffe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004002:	00259783          	lh	a5,2(a1)
    80004006:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000400a:	00459783          	lh	a5,4(a1)
    8000400e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004012:	00659783          	lh	a5,6(a1)
    80004016:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000401a:	459c                	lw	a5,8(a1)
    8000401c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000401e:	03400613          	li	a2,52
    80004022:	05b1                	addi	a1,a1,12
    80004024:	05048513          	addi	a0,s1,80
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	036080e7          	jalr	54(ra) # 8000105e <memmove>
    brelse(bp);
    80004030:	854a                	mv	a0,s2
    80004032:	00000097          	auipc	ra,0x0
    80004036:	85c080e7          	jalr	-1956(ra) # 8000388e <brelse>
    ip->valid = 1;
    8000403a:	4785                	li	a5,1
    8000403c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000403e:	04449783          	lh	a5,68(s1)
    80004042:	c399                	beqz	a5,80004048 <ilock+0xb6>
    80004044:	6902                	ld	s2,0(sp)
    80004046:	b7bd                	j	80003fb4 <ilock+0x22>
      panic("ilock: no type");
    80004048:	00004517          	auipc	a0,0x4
    8000404c:	5b850513          	addi	a0,a0,1464 # 80008600 <__func__.1+0x5f8>
    80004050:	ffffc097          	auipc	ra,0xffffc
    80004054:	510080e7          	jalr	1296(ra) # 80000560 <panic>

0000000080004058 <iunlock>:
{
    80004058:	1101                	addi	sp,sp,-32
    8000405a:	ec06                	sd	ra,24(sp)
    8000405c:	e822                	sd	s0,16(sp)
    8000405e:	e426                	sd	s1,8(sp)
    80004060:	e04a                	sd	s2,0(sp)
    80004062:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004064:	c905                	beqz	a0,80004094 <iunlock+0x3c>
    80004066:	84aa                	mv	s1,a0
    80004068:	01050913          	addi	s2,a0,16
    8000406c:	854a                	mv	a0,s2
    8000406e:	00001097          	auipc	ra,0x1
    80004072:	c82080e7          	jalr	-894(ra) # 80004cf0 <holdingsleep>
    80004076:	cd19                	beqz	a0,80004094 <iunlock+0x3c>
    80004078:	449c                	lw	a5,8(s1)
    8000407a:	00f05d63          	blez	a5,80004094 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000407e:	854a                	mv	a0,s2
    80004080:	00001097          	auipc	ra,0x1
    80004084:	c2c080e7          	jalr	-980(ra) # 80004cac <releasesleep>
}
    80004088:	60e2                	ld	ra,24(sp)
    8000408a:	6442                	ld	s0,16(sp)
    8000408c:	64a2                	ld	s1,8(sp)
    8000408e:	6902                	ld	s2,0(sp)
    80004090:	6105                	addi	sp,sp,32
    80004092:	8082                	ret
    panic("iunlock");
    80004094:	00004517          	auipc	a0,0x4
    80004098:	57c50513          	addi	a0,a0,1404 # 80008610 <__func__.1+0x608>
    8000409c:	ffffc097          	auipc	ra,0xffffc
    800040a0:	4c4080e7          	jalr	1220(ra) # 80000560 <panic>

00000000800040a4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800040a4:	7179                	addi	sp,sp,-48
    800040a6:	f406                	sd	ra,40(sp)
    800040a8:	f022                	sd	s0,32(sp)
    800040aa:	ec26                	sd	s1,24(sp)
    800040ac:	e84a                	sd	s2,16(sp)
    800040ae:	e44e                	sd	s3,8(sp)
    800040b0:	1800                	addi	s0,sp,48
    800040b2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800040b4:	05050493          	addi	s1,a0,80
    800040b8:	08050913          	addi	s2,a0,128
    800040bc:	a021                	j	800040c4 <itrunc+0x20>
    800040be:	0491                	addi	s1,s1,4
    800040c0:	01248d63          	beq	s1,s2,800040da <itrunc+0x36>
    if(ip->addrs[i]){
    800040c4:	408c                	lw	a1,0(s1)
    800040c6:	dde5                	beqz	a1,800040be <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800040c8:	0009a503          	lw	a0,0(s3)
    800040cc:	00000097          	auipc	ra,0x0
    800040d0:	8d6080e7          	jalr	-1834(ra) # 800039a2 <bfree>
      ip->addrs[i] = 0;
    800040d4:	0004a023          	sw	zero,0(s1)
    800040d8:	b7dd                	j	800040be <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800040da:	0809a583          	lw	a1,128(s3)
    800040de:	ed99                	bnez	a1,800040fc <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800040e0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800040e4:	854e                	mv	a0,s3
    800040e6:	00000097          	auipc	ra,0x0
    800040ea:	de0080e7          	jalr	-544(ra) # 80003ec6 <iupdate>
}
    800040ee:	70a2                	ld	ra,40(sp)
    800040f0:	7402                	ld	s0,32(sp)
    800040f2:	64e2                	ld	s1,24(sp)
    800040f4:	6942                	ld	s2,16(sp)
    800040f6:	69a2                	ld	s3,8(sp)
    800040f8:	6145                	addi	sp,sp,48
    800040fa:	8082                	ret
    800040fc:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800040fe:	0009a503          	lw	a0,0(s3)
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	65c080e7          	jalr	1628(ra) # 8000375e <bread>
    8000410a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000410c:	05850493          	addi	s1,a0,88
    80004110:	45850913          	addi	s2,a0,1112
    80004114:	a021                	j	8000411c <itrunc+0x78>
    80004116:	0491                	addi	s1,s1,4
    80004118:	01248b63          	beq	s1,s2,8000412e <itrunc+0x8a>
      if(a[j])
    8000411c:	408c                	lw	a1,0(s1)
    8000411e:	dde5                	beqz	a1,80004116 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80004120:	0009a503          	lw	a0,0(s3)
    80004124:	00000097          	auipc	ra,0x0
    80004128:	87e080e7          	jalr	-1922(ra) # 800039a2 <bfree>
    8000412c:	b7ed                	j	80004116 <itrunc+0x72>
    brelse(bp);
    8000412e:	8552                	mv	a0,s4
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	75e080e7          	jalr	1886(ra) # 8000388e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004138:	0809a583          	lw	a1,128(s3)
    8000413c:	0009a503          	lw	a0,0(s3)
    80004140:	00000097          	auipc	ra,0x0
    80004144:	862080e7          	jalr	-1950(ra) # 800039a2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004148:	0809a023          	sw	zero,128(s3)
    8000414c:	6a02                	ld	s4,0(sp)
    8000414e:	bf49                	j	800040e0 <itrunc+0x3c>

0000000080004150 <iput>:
{
    80004150:	1101                	addi	sp,sp,-32
    80004152:	ec06                	sd	ra,24(sp)
    80004154:	e822                	sd	s0,16(sp)
    80004156:	e426                	sd	s1,8(sp)
    80004158:	1000                	addi	s0,sp,32
    8000415a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000415c:	0003e517          	auipc	a0,0x3e
    80004160:	ca450513          	addi	a0,a0,-860 # 80041e00 <itable>
    80004164:	ffffd097          	auipc	ra,0xffffd
    80004168:	da2080e7          	jalr	-606(ra) # 80000f06 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000416c:	4498                	lw	a4,8(s1)
    8000416e:	4785                	li	a5,1
    80004170:	02f70263          	beq	a4,a5,80004194 <iput+0x44>
  ip->ref--;
    80004174:	449c                	lw	a5,8(s1)
    80004176:	37fd                	addiw	a5,a5,-1
    80004178:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000417a:	0003e517          	auipc	a0,0x3e
    8000417e:	c8650513          	addi	a0,a0,-890 # 80041e00 <itable>
    80004182:	ffffd097          	auipc	ra,0xffffd
    80004186:	e38080e7          	jalr	-456(ra) # 80000fba <release>
}
    8000418a:	60e2                	ld	ra,24(sp)
    8000418c:	6442                	ld	s0,16(sp)
    8000418e:	64a2                	ld	s1,8(sp)
    80004190:	6105                	addi	sp,sp,32
    80004192:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004194:	40bc                	lw	a5,64(s1)
    80004196:	dff9                	beqz	a5,80004174 <iput+0x24>
    80004198:	04a49783          	lh	a5,74(s1)
    8000419c:	ffe1                	bnez	a5,80004174 <iput+0x24>
    8000419e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800041a0:	01048913          	addi	s2,s1,16
    800041a4:	854a                	mv	a0,s2
    800041a6:	00001097          	auipc	ra,0x1
    800041aa:	ab0080e7          	jalr	-1360(ra) # 80004c56 <acquiresleep>
    release(&itable.lock);
    800041ae:	0003e517          	auipc	a0,0x3e
    800041b2:	c5250513          	addi	a0,a0,-942 # 80041e00 <itable>
    800041b6:	ffffd097          	auipc	ra,0xffffd
    800041ba:	e04080e7          	jalr	-508(ra) # 80000fba <release>
    itrunc(ip);
    800041be:	8526                	mv	a0,s1
    800041c0:	00000097          	auipc	ra,0x0
    800041c4:	ee4080e7          	jalr	-284(ra) # 800040a4 <itrunc>
    ip->type = 0;
    800041c8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800041cc:	8526                	mv	a0,s1
    800041ce:	00000097          	auipc	ra,0x0
    800041d2:	cf8080e7          	jalr	-776(ra) # 80003ec6 <iupdate>
    ip->valid = 0;
    800041d6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800041da:	854a                	mv	a0,s2
    800041dc:	00001097          	auipc	ra,0x1
    800041e0:	ad0080e7          	jalr	-1328(ra) # 80004cac <releasesleep>
    acquire(&itable.lock);
    800041e4:	0003e517          	auipc	a0,0x3e
    800041e8:	c1c50513          	addi	a0,a0,-996 # 80041e00 <itable>
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	d1a080e7          	jalr	-742(ra) # 80000f06 <acquire>
    800041f4:	6902                	ld	s2,0(sp)
    800041f6:	bfbd                	j	80004174 <iput+0x24>

00000000800041f8 <iunlockput>:
{
    800041f8:	1101                	addi	sp,sp,-32
    800041fa:	ec06                	sd	ra,24(sp)
    800041fc:	e822                	sd	s0,16(sp)
    800041fe:	e426                	sd	s1,8(sp)
    80004200:	1000                	addi	s0,sp,32
    80004202:	84aa                	mv	s1,a0
  iunlock(ip);
    80004204:	00000097          	auipc	ra,0x0
    80004208:	e54080e7          	jalr	-428(ra) # 80004058 <iunlock>
  iput(ip);
    8000420c:	8526                	mv	a0,s1
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	f42080e7          	jalr	-190(ra) # 80004150 <iput>
}
    80004216:	60e2                	ld	ra,24(sp)
    80004218:	6442                	ld	s0,16(sp)
    8000421a:	64a2                	ld	s1,8(sp)
    8000421c:	6105                	addi	sp,sp,32
    8000421e:	8082                	ret

0000000080004220 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004220:	1141                	addi	sp,sp,-16
    80004222:	e422                	sd	s0,8(sp)
    80004224:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004226:	411c                	lw	a5,0(a0)
    80004228:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000422a:	415c                	lw	a5,4(a0)
    8000422c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000422e:	04451783          	lh	a5,68(a0)
    80004232:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004236:	04a51783          	lh	a5,74(a0)
    8000423a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000423e:	04c56783          	lwu	a5,76(a0)
    80004242:	e99c                	sd	a5,16(a1)
}
    80004244:	6422                	ld	s0,8(sp)
    80004246:	0141                	addi	sp,sp,16
    80004248:	8082                	ret

000000008000424a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000424a:	457c                	lw	a5,76(a0)
    8000424c:	10d7e563          	bltu	a5,a3,80004356 <readi+0x10c>
{
    80004250:	7159                	addi	sp,sp,-112
    80004252:	f486                	sd	ra,104(sp)
    80004254:	f0a2                	sd	s0,96(sp)
    80004256:	eca6                	sd	s1,88(sp)
    80004258:	e0d2                	sd	s4,64(sp)
    8000425a:	fc56                	sd	s5,56(sp)
    8000425c:	f85a                	sd	s6,48(sp)
    8000425e:	f45e                	sd	s7,40(sp)
    80004260:	1880                	addi	s0,sp,112
    80004262:	8b2a                	mv	s6,a0
    80004264:	8bae                	mv	s7,a1
    80004266:	8a32                	mv	s4,a2
    80004268:	84b6                	mv	s1,a3
    8000426a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000426c:	9f35                	addw	a4,a4,a3
    return 0;
    8000426e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004270:	0cd76a63          	bltu	a4,a3,80004344 <readi+0xfa>
    80004274:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004276:	00e7f463          	bgeu	a5,a4,8000427e <readi+0x34>
    n = ip->size - off;
    8000427a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000427e:	0a0a8963          	beqz	s5,80004330 <readi+0xe6>
    80004282:	e8ca                	sd	s2,80(sp)
    80004284:	f062                	sd	s8,32(sp)
    80004286:	ec66                	sd	s9,24(sp)
    80004288:	e86a                	sd	s10,16(sp)
    8000428a:	e46e                	sd	s11,8(sp)
    8000428c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000428e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004292:	5c7d                	li	s8,-1
    80004294:	a82d                	j	800042ce <readi+0x84>
    80004296:	020d1d93          	slli	s11,s10,0x20
    8000429a:	020ddd93          	srli	s11,s11,0x20
    8000429e:	05890613          	addi	a2,s2,88
    800042a2:	86ee                	mv	a3,s11
    800042a4:	963a                	add	a2,a2,a4
    800042a6:	85d2                	mv	a1,s4
    800042a8:	855e                	mv	a0,s7
    800042aa:	ffffe097          	auipc	ra,0xffffe
    800042ae:	718080e7          	jalr	1816(ra) # 800029c2 <either_copyout>
    800042b2:	05850d63          	beq	a0,s8,8000430c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800042b6:	854a                	mv	a0,s2
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	5d6080e7          	jalr	1494(ra) # 8000388e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800042c0:	013d09bb          	addw	s3,s10,s3
    800042c4:	009d04bb          	addw	s1,s10,s1
    800042c8:	9a6e                	add	s4,s4,s11
    800042ca:	0559fd63          	bgeu	s3,s5,80004324 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    800042ce:	00a4d59b          	srliw	a1,s1,0xa
    800042d2:	855a                	mv	a0,s6
    800042d4:	00000097          	auipc	ra,0x0
    800042d8:	88e080e7          	jalr	-1906(ra) # 80003b62 <bmap>
    800042dc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800042e0:	c9b1                	beqz	a1,80004334 <readi+0xea>
    bp = bread(ip->dev, addr);
    800042e2:	000b2503          	lw	a0,0(s6)
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	478080e7          	jalr	1144(ra) # 8000375e <bread>
    800042ee:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800042f0:	3ff4f713          	andi	a4,s1,1023
    800042f4:	40ec87bb          	subw	a5,s9,a4
    800042f8:	413a86bb          	subw	a3,s5,s3
    800042fc:	8d3e                	mv	s10,a5
    800042fe:	2781                	sext.w	a5,a5
    80004300:	0006861b          	sext.w	a2,a3
    80004304:	f8f679e3          	bgeu	a2,a5,80004296 <readi+0x4c>
    80004308:	8d36                	mv	s10,a3
    8000430a:	b771                	j	80004296 <readi+0x4c>
      brelse(bp);
    8000430c:	854a                	mv	a0,s2
    8000430e:	fffff097          	auipc	ra,0xfffff
    80004312:	580080e7          	jalr	1408(ra) # 8000388e <brelse>
      tot = -1;
    80004316:	59fd                	li	s3,-1
      break;
    80004318:	6946                	ld	s2,80(sp)
    8000431a:	7c02                	ld	s8,32(sp)
    8000431c:	6ce2                	ld	s9,24(sp)
    8000431e:	6d42                	ld	s10,16(sp)
    80004320:	6da2                	ld	s11,8(sp)
    80004322:	a831                	j	8000433e <readi+0xf4>
    80004324:	6946                	ld	s2,80(sp)
    80004326:	7c02                	ld	s8,32(sp)
    80004328:	6ce2                	ld	s9,24(sp)
    8000432a:	6d42                	ld	s10,16(sp)
    8000432c:	6da2                	ld	s11,8(sp)
    8000432e:	a801                	j	8000433e <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004330:	89d6                	mv	s3,s5
    80004332:	a031                	j	8000433e <readi+0xf4>
    80004334:	6946                	ld	s2,80(sp)
    80004336:	7c02                	ld	s8,32(sp)
    80004338:	6ce2                	ld	s9,24(sp)
    8000433a:	6d42                	ld	s10,16(sp)
    8000433c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000433e:	0009851b          	sext.w	a0,s3
    80004342:	69a6                	ld	s3,72(sp)
}
    80004344:	70a6                	ld	ra,104(sp)
    80004346:	7406                	ld	s0,96(sp)
    80004348:	64e6                	ld	s1,88(sp)
    8000434a:	6a06                	ld	s4,64(sp)
    8000434c:	7ae2                	ld	s5,56(sp)
    8000434e:	7b42                	ld	s6,48(sp)
    80004350:	7ba2                	ld	s7,40(sp)
    80004352:	6165                	addi	sp,sp,112
    80004354:	8082                	ret
    return 0;
    80004356:	4501                	li	a0,0
}
    80004358:	8082                	ret

000000008000435a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000435a:	457c                	lw	a5,76(a0)
    8000435c:	10d7ee63          	bltu	a5,a3,80004478 <writei+0x11e>
{
    80004360:	7159                	addi	sp,sp,-112
    80004362:	f486                	sd	ra,104(sp)
    80004364:	f0a2                	sd	s0,96(sp)
    80004366:	e8ca                	sd	s2,80(sp)
    80004368:	e0d2                	sd	s4,64(sp)
    8000436a:	fc56                	sd	s5,56(sp)
    8000436c:	f85a                	sd	s6,48(sp)
    8000436e:	f45e                	sd	s7,40(sp)
    80004370:	1880                	addi	s0,sp,112
    80004372:	8aaa                	mv	s5,a0
    80004374:	8bae                	mv	s7,a1
    80004376:	8a32                	mv	s4,a2
    80004378:	8936                	mv	s2,a3
    8000437a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000437c:	00e687bb          	addw	a5,a3,a4
    80004380:	0ed7ee63          	bltu	a5,a3,8000447c <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004384:	00043737          	lui	a4,0x43
    80004388:	0ef76c63          	bltu	a4,a5,80004480 <writei+0x126>
    8000438c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000438e:	0c0b0d63          	beqz	s6,80004468 <writei+0x10e>
    80004392:	eca6                	sd	s1,88(sp)
    80004394:	f062                	sd	s8,32(sp)
    80004396:	ec66                	sd	s9,24(sp)
    80004398:	e86a                	sd	s10,16(sp)
    8000439a:	e46e                	sd	s11,8(sp)
    8000439c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000439e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800043a2:	5c7d                	li	s8,-1
    800043a4:	a091                	j	800043e8 <writei+0x8e>
    800043a6:	020d1d93          	slli	s11,s10,0x20
    800043aa:	020ddd93          	srli	s11,s11,0x20
    800043ae:	05848513          	addi	a0,s1,88
    800043b2:	86ee                	mv	a3,s11
    800043b4:	8652                	mv	a2,s4
    800043b6:	85de                	mv	a1,s7
    800043b8:	953a                	add	a0,a0,a4
    800043ba:	ffffe097          	auipc	ra,0xffffe
    800043be:	65e080e7          	jalr	1630(ra) # 80002a18 <either_copyin>
    800043c2:	07850263          	beq	a0,s8,80004426 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800043c6:	8526                	mv	a0,s1
    800043c8:	00000097          	auipc	ra,0x0
    800043cc:	770080e7          	jalr	1904(ra) # 80004b38 <log_write>
    brelse(bp);
    800043d0:	8526                	mv	a0,s1
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	4bc080e7          	jalr	1212(ra) # 8000388e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043da:	013d09bb          	addw	s3,s10,s3
    800043de:	012d093b          	addw	s2,s10,s2
    800043e2:	9a6e                	add	s4,s4,s11
    800043e4:	0569f663          	bgeu	s3,s6,80004430 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800043e8:	00a9559b          	srliw	a1,s2,0xa
    800043ec:	8556                	mv	a0,s5
    800043ee:	fffff097          	auipc	ra,0xfffff
    800043f2:	774080e7          	jalr	1908(ra) # 80003b62 <bmap>
    800043f6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800043fa:	c99d                	beqz	a1,80004430 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800043fc:	000aa503          	lw	a0,0(s5)
    80004400:	fffff097          	auipc	ra,0xfffff
    80004404:	35e080e7          	jalr	862(ra) # 8000375e <bread>
    80004408:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000440a:	3ff97713          	andi	a4,s2,1023
    8000440e:	40ec87bb          	subw	a5,s9,a4
    80004412:	413b06bb          	subw	a3,s6,s3
    80004416:	8d3e                	mv	s10,a5
    80004418:	2781                	sext.w	a5,a5
    8000441a:	0006861b          	sext.w	a2,a3
    8000441e:	f8f674e3          	bgeu	a2,a5,800043a6 <writei+0x4c>
    80004422:	8d36                	mv	s10,a3
    80004424:	b749                	j	800043a6 <writei+0x4c>
      brelse(bp);
    80004426:	8526                	mv	a0,s1
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	466080e7          	jalr	1126(ra) # 8000388e <brelse>
  }

  if(off > ip->size)
    80004430:	04caa783          	lw	a5,76(s5)
    80004434:	0327fc63          	bgeu	a5,s2,8000446c <writei+0x112>
    ip->size = off;
    80004438:	052aa623          	sw	s2,76(s5)
    8000443c:	64e6                	ld	s1,88(sp)
    8000443e:	7c02                	ld	s8,32(sp)
    80004440:	6ce2                	ld	s9,24(sp)
    80004442:	6d42                	ld	s10,16(sp)
    80004444:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004446:	8556                	mv	a0,s5
    80004448:	00000097          	auipc	ra,0x0
    8000444c:	a7e080e7          	jalr	-1410(ra) # 80003ec6 <iupdate>

  return tot;
    80004450:	0009851b          	sext.w	a0,s3
    80004454:	69a6                	ld	s3,72(sp)
}
    80004456:	70a6                	ld	ra,104(sp)
    80004458:	7406                	ld	s0,96(sp)
    8000445a:	6946                	ld	s2,80(sp)
    8000445c:	6a06                	ld	s4,64(sp)
    8000445e:	7ae2                	ld	s5,56(sp)
    80004460:	7b42                	ld	s6,48(sp)
    80004462:	7ba2                	ld	s7,40(sp)
    80004464:	6165                	addi	sp,sp,112
    80004466:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004468:	89da                	mv	s3,s6
    8000446a:	bff1                	j	80004446 <writei+0xec>
    8000446c:	64e6                	ld	s1,88(sp)
    8000446e:	7c02                	ld	s8,32(sp)
    80004470:	6ce2                	ld	s9,24(sp)
    80004472:	6d42                	ld	s10,16(sp)
    80004474:	6da2                	ld	s11,8(sp)
    80004476:	bfc1                	j	80004446 <writei+0xec>
    return -1;
    80004478:	557d                	li	a0,-1
}
    8000447a:	8082                	ret
    return -1;
    8000447c:	557d                	li	a0,-1
    8000447e:	bfe1                	j	80004456 <writei+0xfc>
    return -1;
    80004480:	557d                	li	a0,-1
    80004482:	bfd1                	j	80004456 <writei+0xfc>

0000000080004484 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004484:	1141                	addi	sp,sp,-16
    80004486:	e406                	sd	ra,8(sp)
    80004488:	e022                	sd	s0,0(sp)
    8000448a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000448c:	4639                	li	a2,14
    8000448e:	ffffd097          	auipc	ra,0xffffd
    80004492:	c44080e7          	jalr	-956(ra) # 800010d2 <strncmp>
}
    80004496:	60a2                	ld	ra,8(sp)
    80004498:	6402                	ld	s0,0(sp)
    8000449a:	0141                	addi	sp,sp,16
    8000449c:	8082                	ret

000000008000449e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000449e:	7139                	addi	sp,sp,-64
    800044a0:	fc06                	sd	ra,56(sp)
    800044a2:	f822                	sd	s0,48(sp)
    800044a4:	f426                	sd	s1,40(sp)
    800044a6:	f04a                	sd	s2,32(sp)
    800044a8:	ec4e                	sd	s3,24(sp)
    800044aa:	e852                	sd	s4,16(sp)
    800044ac:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800044ae:	04451703          	lh	a4,68(a0)
    800044b2:	4785                	li	a5,1
    800044b4:	00f71a63          	bne	a4,a5,800044c8 <dirlookup+0x2a>
    800044b8:	892a                	mv	s2,a0
    800044ba:	89ae                	mv	s3,a1
    800044bc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800044be:	457c                	lw	a5,76(a0)
    800044c0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800044c2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044c4:	e79d                	bnez	a5,800044f2 <dirlookup+0x54>
    800044c6:	a8a5                	j	8000453e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800044c8:	00004517          	auipc	a0,0x4
    800044cc:	15050513          	addi	a0,a0,336 # 80008618 <__func__.1+0x610>
    800044d0:	ffffc097          	auipc	ra,0xffffc
    800044d4:	090080e7          	jalr	144(ra) # 80000560 <panic>
      panic("dirlookup read");
    800044d8:	00004517          	auipc	a0,0x4
    800044dc:	15850513          	addi	a0,a0,344 # 80008630 <__func__.1+0x628>
    800044e0:	ffffc097          	auipc	ra,0xffffc
    800044e4:	080080e7          	jalr	128(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044e8:	24c1                	addiw	s1,s1,16
    800044ea:	04c92783          	lw	a5,76(s2)
    800044ee:	04f4f763          	bgeu	s1,a5,8000453c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044f2:	4741                	li	a4,16
    800044f4:	86a6                	mv	a3,s1
    800044f6:	fc040613          	addi	a2,s0,-64
    800044fa:	4581                	li	a1,0
    800044fc:	854a                	mv	a0,s2
    800044fe:	00000097          	auipc	ra,0x0
    80004502:	d4c080e7          	jalr	-692(ra) # 8000424a <readi>
    80004506:	47c1                	li	a5,16
    80004508:	fcf518e3          	bne	a0,a5,800044d8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000450c:	fc045783          	lhu	a5,-64(s0)
    80004510:	dfe1                	beqz	a5,800044e8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004512:	fc240593          	addi	a1,s0,-62
    80004516:	854e                	mv	a0,s3
    80004518:	00000097          	auipc	ra,0x0
    8000451c:	f6c080e7          	jalr	-148(ra) # 80004484 <namecmp>
    80004520:	f561                	bnez	a0,800044e8 <dirlookup+0x4a>
      if(poff)
    80004522:	000a0463          	beqz	s4,8000452a <dirlookup+0x8c>
        *poff = off;
    80004526:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000452a:	fc045583          	lhu	a1,-64(s0)
    8000452e:	00092503          	lw	a0,0(s2)
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	720080e7          	jalr	1824(ra) # 80003c52 <iget>
    8000453a:	a011                	j	8000453e <dirlookup+0xa0>
  return 0;
    8000453c:	4501                	li	a0,0
}
    8000453e:	70e2                	ld	ra,56(sp)
    80004540:	7442                	ld	s0,48(sp)
    80004542:	74a2                	ld	s1,40(sp)
    80004544:	7902                	ld	s2,32(sp)
    80004546:	69e2                	ld	s3,24(sp)
    80004548:	6a42                	ld	s4,16(sp)
    8000454a:	6121                	addi	sp,sp,64
    8000454c:	8082                	ret

000000008000454e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000454e:	711d                	addi	sp,sp,-96
    80004550:	ec86                	sd	ra,88(sp)
    80004552:	e8a2                	sd	s0,80(sp)
    80004554:	e4a6                	sd	s1,72(sp)
    80004556:	e0ca                	sd	s2,64(sp)
    80004558:	fc4e                	sd	s3,56(sp)
    8000455a:	f852                	sd	s4,48(sp)
    8000455c:	f456                	sd	s5,40(sp)
    8000455e:	f05a                	sd	s6,32(sp)
    80004560:	ec5e                	sd	s7,24(sp)
    80004562:	e862                	sd	s8,16(sp)
    80004564:	e466                	sd	s9,8(sp)
    80004566:	1080                	addi	s0,sp,96
    80004568:	84aa                	mv	s1,a0
    8000456a:	8b2e                	mv	s6,a1
    8000456c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000456e:	00054703          	lbu	a4,0(a0)
    80004572:	02f00793          	li	a5,47
    80004576:	02f70263          	beq	a4,a5,8000459a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000457a:	ffffe097          	auipc	ra,0xffffe
    8000457e:	88e080e7          	jalr	-1906(ra) # 80001e08 <myproc>
    80004582:	15053503          	ld	a0,336(a0)
    80004586:	00000097          	auipc	ra,0x0
    8000458a:	9ce080e7          	jalr	-1586(ra) # 80003f54 <idup>
    8000458e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004590:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004594:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004596:	4b85                	li	s7,1
    80004598:	a875                	j	80004654 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000459a:	4585                	li	a1,1
    8000459c:	4505                	li	a0,1
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	6b4080e7          	jalr	1716(ra) # 80003c52 <iget>
    800045a6:	8a2a                	mv	s4,a0
    800045a8:	b7e5                	j	80004590 <namex+0x42>
      iunlockput(ip);
    800045aa:	8552                	mv	a0,s4
    800045ac:	00000097          	auipc	ra,0x0
    800045b0:	c4c080e7          	jalr	-948(ra) # 800041f8 <iunlockput>
      return 0;
    800045b4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800045b6:	8552                	mv	a0,s4
    800045b8:	60e6                	ld	ra,88(sp)
    800045ba:	6446                	ld	s0,80(sp)
    800045bc:	64a6                	ld	s1,72(sp)
    800045be:	6906                	ld	s2,64(sp)
    800045c0:	79e2                	ld	s3,56(sp)
    800045c2:	7a42                	ld	s4,48(sp)
    800045c4:	7aa2                	ld	s5,40(sp)
    800045c6:	7b02                	ld	s6,32(sp)
    800045c8:	6be2                	ld	s7,24(sp)
    800045ca:	6c42                	ld	s8,16(sp)
    800045cc:	6ca2                	ld	s9,8(sp)
    800045ce:	6125                	addi	sp,sp,96
    800045d0:	8082                	ret
      iunlock(ip);
    800045d2:	8552                	mv	a0,s4
    800045d4:	00000097          	auipc	ra,0x0
    800045d8:	a84080e7          	jalr	-1404(ra) # 80004058 <iunlock>
      return ip;
    800045dc:	bfe9                	j	800045b6 <namex+0x68>
      iunlockput(ip);
    800045de:	8552                	mv	a0,s4
    800045e0:	00000097          	auipc	ra,0x0
    800045e4:	c18080e7          	jalr	-1000(ra) # 800041f8 <iunlockput>
      return 0;
    800045e8:	8a4e                	mv	s4,s3
    800045ea:	b7f1                	j	800045b6 <namex+0x68>
  len = path - s;
    800045ec:	40998633          	sub	a2,s3,s1
    800045f0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800045f4:	099c5863          	bge	s8,s9,80004684 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800045f8:	4639                	li	a2,14
    800045fa:	85a6                	mv	a1,s1
    800045fc:	8556                	mv	a0,s5
    800045fe:	ffffd097          	auipc	ra,0xffffd
    80004602:	a60080e7          	jalr	-1440(ra) # 8000105e <memmove>
    80004606:	84ce                	mv	s1,s3
  while(*path == '/')
    80004608:	0004c783          	lbu	a5,0(s1)
    8000460c:	01279763          	bne	a5,s2,8000461a <namex+0xcc>
    path++;
    80004610:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004612:	0004c783          	lbu	a5,0(s1)
    80004616:	ff278de3          	beq	a5,s2,80004610 <namex+0xc2>
    ilock(ip);
    8000461a:	8552                	mv	a0,s4
    8000461c:	00000097          	auipc	ra,0x0
    80004620:	976080e7          	jalr	-1674(ra) # 80003f92 <ilock>
    if(ip->type != T_DIR){
    80004624:	044a1783          	lh	a5,68(s4)
    80004628:	f97791e3          	bne	a5,s7,800045aa <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000462c:	000b0563          	beqz	s6,80004636 <namex+0xe8>
    80004630:	0004c783          	lbu	a5,0(s1)
    80004634:	dfd9                	beqz	a5,800045d2 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004636:	4601                	li	a2,0
    80004638:	85d6                	mv	a1,s5
    8000463a:	8552                	mv	a0,s4
    8000463c:	00000097          	auipc	ra,0x0
    80004640:	e62080e7          	jalr	-414(ra) # 8000449e <dirlookup>
    80004644:	89aa                	mv	s3,a0
    80004646:	dd41                	beqz	a0,800045de <namex+0x90>
    iunlockput(ip);
    80004648:	8552                	mv	a0,s4
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	bae080e7          	jalr	-1106(ra) # 800041f8 <iunlockput>
    ip = next;
    80004652:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004654:	0004c783          	lbu	a5,0(s1)
    80004658:	01279763          	bne	a5,s2,80004666 <namex+0x118>
    path++;
    8000465c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000465e:	0004c783          	lbu	a5,0(s1)
    80004662:	ff278de3          	beq	a5,s2,8000465c <namex+0x10e>
  if(*path == 0)
    80004666:	cb9d                	beqz	a5,8000469c <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004668:	0004c783          	lbu	a5,0(s1)
    8000466c:	89a6                	mv	s3,s1
  len = path - s;
    8000466e:	4c81                	li	s9,0
    80004670:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004672:	01278963          	beq	a5,s2,80004684 <namex+0x136>
    80004676:	dbbd                	beqz	a5,800045ec <namex+0x9e>
    path++;
    80004678:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000467a:	0009c783          	lbu	a5,0(s3)
    8000467e:	ff279ce3          	bne	a5,s2,80004676 <namex+0x128>
    80004682:	b7ad                	j	800045ec <namex+0x9e>
    memmove(name, s, len);
    80004684:	2601                	sext.w	a2,a2
    80004686:	85a6                	mv	a1,s1
    80004688:	8556                	mv	a0,s5
    8000468a:	ffffd097          	auipc	ra,0xffffd
    8000468e:	9d4080e7          	jalr	-1580(ra) # 8000105e <memmove>
    name[len] = 0;
    80004692:	9cd6                	add	s9,s9,s5
    80004694:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004698:	84ce                	mv	s1,s3
    8000469a:	b7bd                	j	80004608 <namex+0xba>
  if(nameiparent){
    8000469c:	f00b0de3          	beqz	s6,800045b6 <namex+0x68>
    iput(ip);
    800046a0:	8552                	mv	a0,s4
    800046a2:	00000097          	auipc	ra,0x0
    800046a6:	aae080e7          	jalr	-1362(ra) # 80004150 <iput>
    return 0;
    800046aa:	4a01                	li	s4,0
    800046ac:	b729                	j	800045b6 <namex+0x68>

00000000800046ae <dirlink>:
{
    800046ae:	7139                	addi	sp,sp,-64
    800046b0:	fc06                	sd	ra,56(sp)
    800046b2:	f822                	sd	s0,48(sp)
    800046b4:	f04a                	sd	s2,32(sp)
    800046b6:	ec4e                	sd	s3,24(sp)
    800046b8:	e852                	sd	s4,16(sp)
    800046ba:	0080                	addi	s0,sp,64
    800046bc:	892a                	mv	s2,a0
    800046be:	8a2e                	mv	s4,a1
    800046c0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800046c2:	4601                	li	a2,0
    800046c4:	00000097          	auipc	ra,0x0
    800046c8:	dda080e7          	jalr	-550(ra) # 8000449e <dirlookup>
    800046cc:	ed25                	bnez	a0,80004744 <dirlink+0x96>
    800046ce:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800046d0:	04c92483          	lw	s1,76(s2)
    800046d4:	c49d                	beqz	s1,80004702 <dirlink+0x54>
    800046d6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046d8:	4741                	li	a4,16
    800046da:	86a6                	mv	a3,s1
    800046dc:	fc040613          	addi	a2,s0,-64
    800046e0:	4581                	li	a1,0
    800046e2:	854a                	mv	a0,s2
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	b66080e7          	jalr	-1178(ra) # 8000424a <readi>
    800046ec:	47c1                	li	a5,16
    800046ee:	06f51163          	bne	a0,a5,80004750 <dirlink+0xa2>
    if(de.inum == 0)
    800046f2:	fc045783          	lhu	a5,-64(s0)
    800046f6:	c791                	beqz	a5,80004702 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800046f8:	24c1                	addiw	s1,s1,16
    800046fa:	04c92783          	lw	a5,76(s2)
    800046fe:	fcf4ede3          	bltu	s1,a5,800046d8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004702:	4639                	li	a2,14
    80004704:	85d2                	mv	a1,s4
    80004706:	fc240513          	addi	a0,s0,-62
    8000470a:	ffffd097          	auipc	ra,0xffffd
    8000470e:	9fe080e7          	jalr	-1538(ra) # 80001108 <strncpy>
  de.inum = inum;
    80004712:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004716:	4741                	li	a4,16
    80004718:	86a6                	mv	a3,s1
    8000471a:	fc040613          	addi	a2,s0,-64
    8000471e:	4581                	li	a1,0
    80004720:	854a                	mv	a0,s2
    80004722:	00000097          	auipc	ra,0x0
    80004726:	c38080e7          	jalr	-968(ra) # 8000435a <writei>
    8000472a:	1541                	addi	a0,a0,-16
    8000472c:	00a03533          	snez	a0,a0
    80004730:	40a00533          	neg	a0,a0
    80004734:	74a2                	ld	s1,40(sp)
}
    80004736:	70e2                	ld	ra,56(sp)
    80004738:	7442                	ld	s0,48(sp)
    8000473a:	7902                	ld	s2,32(sp)
    8000473c:	69e2                	ld	s3,24(sp)
    8000473e:	6a42                	ld	s4,16(sp)
    80004740:	6121                	addi	sp,sp,64
    80004742:	8082                	ret
    iput(ip);
    80004744:	00000097          	auipc	ra,0x0
    80004748:	a0c080e7          	jalr	-1524(ra) # 80004150 <iput>
    return -1;
    8000474c:	557d                	li	a0,-1
    8000474e:	b7e5                	j	80004736 <dirlink+0x88>
      panic("dirlink read");
    80004750:	00004517          	auipc	a0,0x4
    80004754:	ef050513          	addi	a0,a0,-272 # 80008640 <__func__.1+0x638>
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	e08080e7          	jalr	-504(ra) # 80000560 <panic>

0000000080004760 <namei>:

struct inode*
namei(char *path)
{
    80004760:	1101                	addi	sp,sp,-32
    80004762:	ec06                	sd	ra,24(sp)
    80004764:	e822                	sd	s0,16(sp)
    80004766:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004768:	fe040613          	addi	a2,s0,-32
    8000476c:	4581                	li	a1,0
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	de0080e7          	jalr	-544(ra) # 8000454e <namex>
}
    80004776:	60e2                	ld	ra,24(sp)
    80004778:	6442                	ld	s0,16(sp)
    8000477a:	6105                	addi	sp,sp,32
    8000477c:	8082                	ret

000000008000477e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000477e:	1141                	addi	sp,sp,-16
    80004780:	e406                	sd	ra,8(sp)
    80004782:	e022                	sd	s0,0(sp)
    80004784:	0800                	addi	s0,sp,16
    80004786:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004788:	4585                	li	a1,1
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	dc4080e7          	jalr	-572(ra) # 8000454e <namex>
}
    80004792:	60a2                	ld	ra,8(sp)
    80004794:	6402                	ld	s0,0(sp)
    80004796:	0141                	addi	sp,sp,16
    80004798:	8082                	ret

000000008000479a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000479a:	1101                	addi	sp,sp,-32
    8000479c:	ec06                	sd	ra,24(sp)
    8000479e:	e822                	sd	s0,16(sp)
    800047a0:	e426                	sd	s1,8(sp)
    800047a2:	e04a                	sd	s2,0(sp)
    800047a4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800047a6:	0003f917          	auipc	s2,0x3f
    800047aa:	10290913          	addi	s2,s2,258 # 800438a8 <log>
    800047ae:	01892583          	lw	a1,24(s2)
    800047b2:	02892503          	lw	a0,40(s2)
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	fa8080e7          	jalr	-88(ra) # 8000375e <bread>
    800047be:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800047c0:	02c92603          	lw	a2,44(s2)
    800047c4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800047c6:	00c05f63          	blez	a2,800047e4 <write_head+0x4a>
    800047ca:	0003f717          	auipc	a4,0x3f
    800047ce:	10e70713          	addi	a4,a4,270 # 800438d8 <log+0x30>
    800047d2:	87aa                	mv	a5,a0
    800047d4:	060a                	slli	a2,a2,0x2
    800047d6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800047d8:	4314                	lw	a3,0(a4)
    800047da:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800047dc:	0711                	addi	a4,a4,4
    800047de:	0791                	addi	a5,a5,4
    800047e0:	fec79ce3          	bne	a5,a2,800047d8 <write_head+0x3e>
  }
  bwrite(buf);
    800047e4:	8526                	mv	a0,s1
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	06a080e7          	jalr	106(ra) # 80003850 <bwrite>
  brelse(buf);
    800047ee:	8526                	mv	a0,s1
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	09e080e7          	jalr	158(ra) # 8000388e <brelse>
}
    800047f8:	60e2                	ld	ra,24(sp)
    800047fa:	6442                	ld	s0,16(sp)
    800047fc:	64a2                	ld	s1,8(sp)
    800047fe:	6902                	ld	s2,0(sp)
    80004800:	6105                	addi	sp,sp,32
    80004802:	8082                	ret

0000000080004804 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004804:	0003f797          	auipc	a5,0x3f
    80004808:	0d07a783          	lw	a5,208(a5) # 800438d4 <log+0x2c>
    8000480c:	0af05d63          	blez	a5,800048c6 <install_trans+0xc2>
{
    80004810:	7139                	addi	sp,sp,-64
    80004812:	fc06                	sd	ra,56(sp)
    80004814:	f822                	sd	s0,48(sp)
    80004816:	f426                	sd	s1,40(sp)
    80004818:	f04a                	sd	s2,32(sp)
    8000481a:	ec4e                	sd	s3,24(sp)
    8000481c:	e852                	sd	s4,16(sp)
    8000481e:	e456                	sd	s5,8(sp)
    80004820:	e05a                	sd	s6,0(sp)
    80004822:	0080                	addi	s0,sp,64
    80004824:	8b2a                	mv	s6,a0
    80004826:	0003fa97          	auipc	s5,0x3f
    8000482a:	0b2a8a93          	addi	s5,s5,178 # 800438d8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000482e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004830:	0003f997          	auipc	s3,0x3f
    80004834:	07898993          	addi	s3,s3,120 # 800438a8 <log>
    80004838:	a00d                	j	8000485a <install_trans+0x56>
    brelse(lbuf);
    8000483a:	854a                	mv	a0,s2
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	052080e7          	jalr	82(ra) # 8000388e <brelse>
    brelse(dbuf);
    80004844:	8526                	mv	a0,s1
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	048080e7          	jalr	72(ra) # 8000388e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000484e:	2a05                	addiw	s4,s4,1
    80004850:	0a91                	addi	s5,s5,4
    80004852:	02c9a783          	lw	a5,44(s3)
    80004856:	04fa5e63          	bge	s4,a5,800048b2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000485a:	0189a583          	lw	a1,24(s3)
    8000485e:	014585bb          	addw	a1,a1,s4
    80004862:	2585                	addiw	a1,a1,1
    80004864:	0289a503          	lw	a0,40(s3)
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	ef6080e7          	jalr	-266(ra) # 8000375e <bread>
    80004870:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004872:	000aa583          	lw	a1,0(s5)
    80004876:	0289a503          	lw	a0,40(s3)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	ee4080e7          	jalr	-284(ra) # 8000375e <bread>
    80004882:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004884:	40000613          	li	a2,1024
    80004888:	05890593          	addi	a1,s2,88
    8000488c:	05850513          	addi	a0,a0,88
    80004890:	ffffc097          	auipc	ra,0xffffc
    80004894:	7ce080e7          	jalr	1998(ra) # 8000105e <memmove>
    bwrite(dbuf);  // write dst to disk
    80004898:	8526                	mv	a0,s1
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	fb6080e7          	jalr	-74(ra) # 80003850 <bwrite>
    if(recovering == 0)
    800048a2:	f80b1ce3          	bnez	s6,8000483a <install_trans+0x36>
      bunpin(dbuf);
    800048a6:	8526                	mv	a0,s1
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	0be080e7          	jalr	190(ra) # 80003966 <bunpin>
    800048b0:	b769                	j	8000483a <install_trans+0x36>
}
    800048b2:	70e2                	ld	ra,56(sp)
    800048b4:	7442                	ld	s0,48(sp)
    800048b6:	74a2                	ld	s1,40(sp)
    800048b8:	7902                	ld	s2,32(sp)
    800048ba:	69e2                	ld	s3,24(sp)
    800048bc:	6a42                	ld	s4,16(sp)
    800048be:	6aa2                	ld	s5,8(sp)
    800048c0:	6b02                	ld	s6,0(sp)
    800048c2:	6121                	addi	sp,sp,64
    800048c4:	8082                	ret
    800048c6:	8082                	ret

00000000800048c8 <initlog>:
{
    800048c8:	7179                	addi	sp,sp,-48
    800048ca:	f406                	sd	ra,40(sp)
    800048cc:	f022                	sd	s0,32(sp)
    800048ce:	ec26                	sd	s1,24(sp)
    800048d0:	e84a                	sd	s2,16(sp)
    800048d2:	e44e                	sd	s3,8(sp)
    800048d4:	1800                	addi	s0,sp,48
    800048d6:	892a                	mv	s2,a0
    800048d8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800048da:	0003f497          	auipc	s1,0x3f
    800048de:	fce48493          	addi	s1,s1,-50 # 800438a8 <log>
    800048e2:	00004597          	auipc	a1,0x4
    800048e6:	d6e58593          	addi	a1,a1,-658 # 80008650 <__func__.1+0x648>
    800048ea:	8526                	mv	a0,s1
    800048ec:	ffffc097          	auipc	ra,0xffffc
    800048f0:	58a080e7          	jalr	1418(ra) # 80000e76 <initlock>
  log.start = sb->logstart;
    800048f4:	0149a583          	lw	a1,20(s3)
    800048f8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800048fa:	0109a783          	lw	a5,16(s3)
    800048fe:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004900:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004904:	854a                	mv	a0,s2
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	e58080e7          	jalr	-424(ra) # 8000375e <bread>
  log.lh.n = lh->n;
    8000490e:	4d30                	lw	a2,88(a0)
    80004910:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004912:	00c05f63          	blez	a2,80004930 <initlog+0x68>
    80004916:	87aa                	mv	a5,a0
    80004918:	0003f717          	auipc	a4,0x3f
    8000491c:	fc070713          	addi	a4,a4,-64 # 800438d8 <log+0x30>
    80004920:	060a                	slli	a2,a2,0x2
    80004922:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004924:	4ff4                	lw	a3,92(a5)
    80004926:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004928:	0791                	addi	a5,a5,4
    8000492a:	0711                	addi	a4,a4,4
    8000492c:	fec79ce3          	bne	a5,a2,80004924 <initlog+0x5c>
  brelse(buf);
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	f5e080e7          	jalr	-162(ra) # 8000388e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004938:	4505                	li	a0,1
    8000493a:	00000097          	auipc	ra,0x0
    8000493e:	eca080e7          	jalr	-310(ra) # 80004804 <install_trans>
  log.lh.n = 0;
    80004942:	0003f797          	auipc	a5,0x3f
    80004946:	f807a923          	sw	zero,-110(a5) # 800438d4 <log+0x2c>
  write_head(); // clear the log
    8000494a:	00000097          	auipc	ra,0x0
    8000494e:	e50080e7          	jalr	-432(ra) # 8000479a <write_head>
}
    80004952:	70a2                	ld	ra,40(sp)
    80004954:	7402                	ld	s0,32(sp)
    80004956:	64e2                	ld	s1,24(sp)
    80004958:	6942                	ld	s2,16(sp)
    8000495a:	69a2                	ld	s3,8(sp)
    8000495c:	6145                	addi	sp,sp,48
    8000495e:	8082                	ret

0000000080004960 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004960:	1101                	addi	sp,sp,-32
    80004962:	ec06                	sd	ra,24(sp)
    80004964:	e822                	sd	s0,16(sp)
    80004966:	e426                	sd	s1,8(sp)
    80004968:	e04a                	sd	s2,0(sp)
    8000496a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000496c:	0003f517          	auipc	a0,0x3f
    80004970:	f3c50513          	addi	a0,a0,-196 # 800438a8 <log>
    80004974:	ffffc097          	auipc	ra,0xffffc
    80004978:	592080e7          	jalr	1426(ra) # 80000f06 <acquire>
  while(1){
    if(log.committing){
    8000497c:	0003f497          	auipc	s1,0x3f
    80004980:	f2c48493          	addi	s1,s1,-212 # 800438a8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004984:	4979                	li	s2,30
    80004986:	a039                	j	80004994 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004988:	85a6                	mv	a1,s1
    8000498a:	8526                	mv	a0,s1
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	c2e080e7          	jalr	-978(ra) # 800025ba <sleep>
    if(log.committing){
    80004994:	50dc                	lw	a5,36(s1)
    80004996:	fbed                	bnez	a5,80004988 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004998:	5098                	lw	a4,32(s1)
    8000499a:	2705                	addiw	a4,a4,1
    8000499c:	0027179b          	slliw	a5,a4,0x2
    800049a0:	9fb9                	addw	a5,a5,a4
    800049a2:	0017979b          	slliw	a5,a5,0x1
    800049a6:	54d4                	lw	a3,44(s1)
    800049a8:	9fb5                	addw	a5,a5,a3
    800049aa:	00f95963          	bge	s2,a5,800049bc <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800049ae:	85a6                	mv	a1,s1
    800049b0:	8526                	mv	a0,s1
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	c08080e7          	jalr	-1016(ra) # 800025ba <sleep>
    800049ba:	bfe9                	j	80004994 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800049bc:	0003f517          	auipc	a0,0x3f
    800049c0:	eec50513          	addi	a0,a0,-276 # 800438a8 <log>
    800049c4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	5f4080e7          	jalr	1524(ra) # 80000fba <release>
      break;
    }
  }
}
    800049ce:	60e2                	ld	ra,24(sp)
    800049d0:	6442                	ld	s0,16(sp)
    800049d2:	64a2                	ld	s1,8(sp)
    800049d4:	6902                	ld	s2,0(sp)
    800049d6:	6105                	addi	sp,sp,32
    800049d8:	8082                	ret

00000000800049da <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800049da:	7139                	addi	sp,sp,-64
    800049dc:	fc06                	sd	ra,56(sp)
    800049de:	f822                	sd	s0,48(sp)
    800049e0:	f426                	sd	s1,40(sp)
    800049e2:	f04a                	sd	s2,32(sp)
    800049e4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800049e6:	0003f497          	auipc	s1,0x3f
    800049ea:	ec248493          	addi	s1,s1,-318 # 800438a8 <log>
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffc097          	auipc	ra,0xffffc
    800049f4:	516080e7          	jalr	1302(ra) # 80000f06 <acquire>
  log.outstanding -= 1;
    800049f8:	509c                	lw	a5,32(s1)
    800049fa:	37fd                	addiw	a5,a5,-1
    800049fc:	0007891b          	sext.w	s2,a5
    80004a00:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004a02:	50dc                	lw	a5,36(s1)
    80004a04:	e7b9                	bnez	a5,80004a52 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004a06:	06091163          	bnez	s2,80004a68 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004a0a:	0003f497          	auipc	s1,0x3f
    80004a0e:	e9e48493          	addi	s1,s1,-354 # 800438a8 <log>
    80004a12:	4785                	li	a5,1
    80004a14:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	5a2080e7          	jalr	1442(ra) # 80000fba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004a20:	54dc                	lw	a5,44(s1)
    80004a22:	06f04763          	bgtz	a5,80004a90 <end_op+0xb6>
    acquire(&log.lock);
    80004a26:	0003f497          	auipc	s1,0x3f
    80004a2a:	e8248493          	addi	s1,s1,-382 # 800438a8 <log>
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffc097          	auipc	ra,0xffffc
    80004a34:	4d6080e7          	jalr	1238(ra) # 80000f06 <acquire>
    log.committing = 0;
    80004a38:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004a3c:	8526                	mv	a0,s1
    80004a3e:	ffffe097          	auipc	ra,0xffffe
    80004a42:	be0080e7          	jalr	-1056(ra) # 8000261e <wakeup>
    release(&log.lock);
    80004a46:	8526                	mv	a0,s1
    80004a48:	ffffc097          	auipc	ra,0xffffc
    80004a4c:	572080e7          	jalr	1394(ra) # 80000fba <release>
}
    80004a50:	a815                	j	80004a84 <end_op+0xaa>
    80004a52:	ec4e                	sd	s3,24(sp)
    80004a54:	e852                	sd	s4,16(sp)
    80004a56:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	c0050513          	addi	a0,a0,-1024 # 80008658 <__func__.1+0x650>
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	b00080e7          	jalr	-1280(ra) # 80000560 <panic>
    wakeup(&log);
    80004a68:	0003f497          	auipc	s1,0x3f
    80004a6c:	e4048493          	addi	s1,s1,-448 # 800438a8 <log>
    80004a70:	8526                	mv	a0,s1
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	bac080e7          	jalr	-1108(ra) # 8000261e <wakeup>
  release(&log.lock);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	53e080e7          	jalr	1342(ra) # 80000fba <release>
}
    80004a84:	70e2                	ld	ra,56(sp)
    80004a86:	7442                	ld	s0,48(sp)
    80004a88:	74a2                	ld	s1,40(sp)
    80004a8a:	7902                	ld	s2,32(sp)
    80004a8c:	6121                	addi	sp,sp,64
    80004a8e:	8082                	ret
    80004a90:	ec4e                	sd	s3,24(sp)
    80004a92:	e852                	sd	s4,16(sp)
    80004a94:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a96:	0003fa97          	auipc	s5,0x3f
    80004a9a:	e42a8a93          	addi	s5,s5,-446 # 800438d8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004a9e:	0003fa17          	auipc	s4,0x3f
    80004aa2:	e0aa0a13          	addi	s4,s4,-502 # 800438a8 <log>
    80004aa6:	018a2583          	lw	a1,24(s4)
    80004aaa:	012585bb          	addw	a1,a1,s2
    80004aae:	2585                	addiw	a1,a1,1
    80004ab0:	028a2503          	lw	a0,40(s4)
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	caa080e7          	jalr	-854(ra) # 8000375e <bread>
    80004abc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004abe:	000aa583          	lw	a1,0(s5)
    80004ac2:	028a2503          	lw	a0,40(s4)
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	c98080e7          	jalr	-872(ra) # 8000375e <bread>
    80004ace:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004ad0:	40000613          	li	a2,1024
    80004ad4:	05850593          	addi	a1,a0,88
    80004ad8:	05848513          	addi	a0,s1,88
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	582080e7          	jalr	1410(ra) # 8000105e <memmove>
    bwrite(to);  // write the log
    80004ae4:	8526                	mv	a0,s1
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	d6a080e7          	jalr	-662(ra) # 80003850 <bwrite>
    brelse(from);
    80004aee:	854e                	mv	a0,s3
    80004af0:	fffff097          	auipc	ra,0xfffff
    80004af4:	d9e080e7          	jalr	-610(ra) # 8000388e <brelse>
    brelse(to);
    80004af8:	8526                	mv	a0,s1
    80004afa:	fffff097          	auipc	ra,0xfffff
    80004afe:	d94080e7          	jalr	-620(ra) # 8000388e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b02:	2905                	addiw	s2,s2,1
    80004b04:	0a91                	addi	s5,s5,4
    80004b06:	02ca2783          	lw	a5,44(s4)
    80004b0a:	f8f94ee3          	blt	s2,a5,80004aa6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004b0e:	00000097          	auipc	ra,0x0
    80004b12:	c8c080e7          	jalr	-884(ra) # 8000479a <write_head>
    install_trans(0); // Now install writes to home locations
    80004b16:	4501                	li	a0,0
    80004b18:	00000097          	auipc	ra,0x0
    80004b1c:	cec080e7          	jalr	-788(ra) # 80004804 <install_trans>
    log.lh.n = 0;
    80004b20:	0003f797          	auipc	a5,0x3f
    80004b24:	da07aa23          	sw	zero,-588(a5) # 800438d4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004b28:	00000097          	auipc	ra,0x0
    80004b2c:	c72080e7          	jalr	-910(ra) # 8000479a <write_head>
    80004b30:	69e2                	ld	s3,24(sp)
    80004b32:	6a42                	ld	s4,16(sp)
    80004b34:	6aa2                	ld	s5,8(sp)
    80004b36:	bdc5                	j	80004a26 <end_op+0x4c>

0000000080004b38 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004b38:	1101                	addi	sp,sp,-32
    80004b3a:	ec06                	sd	ra,24(sp)
    80004b3c:	e822                	sd	s0,16(sp)
    80004b3e:	e426                	sd	s1,8(sp)
    80004b40:	e04a                	sd	s2,0(sp)
    80004b42:	1000                	addi	s0,sp,32
    80004b44:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004b46:	0003f917          	auipc	s2,0x3f
    80004b4a:	d6290913          	addi	s2,s2,-670 # 800438a8 <log>
    80004b4e:	854a                	mv	a0,s2
    80004b50:	ffffc097          	auipc	ra,0xffffc
    80004b54:	3b6080e7          	jalr	950(ra) # 80000f06 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004b58:	02c92603          	lw	a2,44(s2)
    80004b5c:	47f5                	li	a5,29
    80004b5e:	06c7c563          	blt	a5,a2,80004bc8 <log_write+0x90>
    80004b62:	0003f797          	auipc	a5,0x3f
    80004b66:	d627a783          	lw	a5,-670(a5) # 800438c4 <log+0x1c>
    80004b6a:	37fd                	addiw	a5,a5,-1
    80004b6c:	04f65e63          	bge	a2,a5,80004bc8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004b70:	0003f797          	auipc	a5,0x3f
    80004b74:	d587a783          	lw	a5,-680(a5) # 800438c8 <log+0x20>
    80004b78:	06f05063          	blez	a5,80004bd8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004b7c:	4781                	li	a5,0
    80004b7e:	06c05563          	blez	a2,80004be8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b82:	44cc                	lw	a1,12(s1)
    80004b84:	0003f717          	auipc	a4,0x3f
    80004b88:	d5470713          	addi	a4,a4,-684 # 800438d8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b8c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b8e:	4314                	lw	a3,0(a4)
    80004b90:	04b68c63          	beq	a3,a1,80004be8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004b94:	2785                	addiw	a5,a5,1
    80004b96:	0711                	addi	a4,a4,4
    80004b98:	fef61be3          	bne	a2,a5,80004b8e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004b9c:	0621                	addi	a2,a2,8
    80004b9e:	060a                	slli	a2,a2,0x2
    80004ba0:	0003f797          	auipc	a5,0x3f
    80004ba4:	d0878793          	addi	a5,a5,-760 # 800438a8 <log>
    80004ba8:	97b2                	add	a5,a5,a2
    80004baa:	44d8                	lw	a4,12(s1)
    80004bac:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	d7a080e7          	jalr	-646(ra) # 8000392a <bpin>
    log.lh.n++;
    80004bb8:	0003f717          	auipc	a4,0x3f
    80004bbc:	cf070713          	addi	a4,a4,-784 # 800438a8 <log>
    80004bc0:	575c                	lw	a5,44(a4)
    80004bc2:	2785                	addiw	a5,a5,1
    80004bc4:	d75c                	sw	a5,44(a4)
    80004bc6:	a82d                	j	80004c00 <log_write+0xc8>
    panic("too big a transaction");
    80004bc8:	00004517          	auipc	a0,0x4
    80004bcc:	aa050513          	addi	a0,a0,-1376 # 80008668 <__func__.1+0x660>
    80004bd0:	ffffc097          	auipc	ra,0xffffc
    80004bd4:	990080e7          	jalr	-1648(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004bd8:	00004517          	auipc	a0,0x4
    80004bdc:	aa850513          	addi	a0,a0,-1368 # 80008680 <__func__.1+0x678>
    80004be0:	ffffc097          	auipc	ra,0xffffc
    80004be4:	980080e7          	jalr	-1664(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004be8:	00878693          	addi	a3,a5,8
    80004bec:	068a                	slli	a3,a3,0x2
    80004bee:	0003f717          	auipc	a4,0x3f
    80004bf2:	cba70713          	addi	a4,a4,-838 # 800438a8 <log>
    80004bf6:	9736                	add	a4,a4,a3
    80004bf8:	44d4                	lw	a3,12(s1)
    80004bfa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004bfc:	faf609e3          	beq	a2,a5,80004bae <log_write+0x76>
  }
  release(&log.lock);
    80004c00:	0003f517          	auipc	a0,0x3f
    80004c04:	ca850513          	addi	a0,a0,-856 # 800438a8 <log>
    80004c08:	ffffc097          	auipc	ra,0xffffc
    80004c0c:	3b2080e7          	jalr	946(ra) # 80000fba <release>
}
    80004c10:	60e2                	ld	ra,24(sp)
    80004c12:	6442                	ld	s0,16(sp)
    80004c14:	64a2                	ld	s1,8(sp)
    80004c16:	6902                	ld	s2,0(sp)
    80004c18:	6105                	addi	sp,sp,32
    80004c1a:	8082                	ret

0000000080004c1c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004c1c:	1101                	addi	sp,sp,-32
    80004c1e:	ec06                	sd	ra,24(sp)
    80004c20:	e822                	sd	s0,16(sp)
    80004c22:	e426                	sd	s1,8(sp)
    80004c24:	e04a                	sd	s2,0(sp)
    80004c26:	1000                	addi	s0,sp,32
    80004c28:	84aa                	mv	s1,a0
    80004c2a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004c2c:	00004597          	auipc	a1,0x4
    80004c30:	a7458593          	addi	a1,a1,-1420 # 800086a0 <__func__.1+0x698>
    80004c34:	0521                	addi	a0,a0,8
    80004c36:	ffffc097          	auipc	ra,0xffffc
    80004c3a:	240080e7          	jalr	576(ra) # 80000e76 <initlock>
  lk->name = name;
    80004c3e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004c42:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c46:	0204a423          	sw	zero,40(s1)
}
    80004c4a:	60e2                	ld	ra,24(sp)
    80004c4c:	6442                	ld	s0,16(sp)
    80004c4e:	64a2                	ld	s1,8(sp)
    80004c50:	6902                	ld	s2,0(sp)
    80004c52:	6105                	addi	sp,sp,32
    80004c54:	8082                	ret

0000000080004c56 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004c56:	1101                	addi	sp,sp,-32
    80004c58:	ec06                	sd	ra,24(sp)
    80004c5a:	e822                	sd	s0,16(sp)
    80004c5c:	e426                	sd	s1,8(sp)
    80004c5e:	e04a                	sd	s2,0(sp)
    80004c60:	1000                	addi	s0,sp,32
    80004c62:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c64:	00850913          	addi	s2,a0,8
    80004c68:	854a                	mv	a0,s2
    80004c6a:	ffffc097          	auipc	ra,0xffffc
    80004c6e:	29c080e7          	jalr	668(ra) # 80000f06 <acquire>
  while (lk->locked) {
    80004c72:	409c                	lw	a5,0(s1)
    80004c74:	cb89                	beqz	a5,80004c86 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004c76:	85ca                	mv	a1,s2
    80004c78:	8526                	mv	a0,s1
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	940080e7          	jalr	-1728(ra) # 800025ba <sleep>
  while (lk->locked) {
    80004c82:	409c                	lw	a5,0(s1)
    80004c84:	fbed                	bnez	a5,80004c76 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c86:	4785                	li	a5,1
    80004c88:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c8a:	ffffd097          	auipc	ra,0xffffd
    80004c8e:	17e080e7          	jalr	382(ra) # 80001e08 <myproc>
    80004c92:	591c                	lw	a5,48(a0)
    80004c94:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffc097          	auipc	ra,0xffffc
    80004c9c:	322080e7          	jalr	802(ra) # 80000fba <release>
}
    80004ca0:	60e2                	ld	ra,24(sp)
    80004ca2:	6442                	ld	s0,16(sp)
    80004ca4:	64a2                	ld	s1,8(sp)
    80004ca6:	6902                	ld	s2,0(sp)
    80004ca8:	6105                	addi	sp,sp,32
    80004caa:	8082                	ret

0000000080004cac <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004cac:	1101                	addi	sp,sp,-32
    80004cae:	ec06                	sd	ra,24(sp)
    80004cb0:	e822                	sd	s0,16(sp)
    80004cb2:	e426                	sd	s1,8(sp)
    80004cb4:	e04a                	sd	s2,0(sp)
    80004cb6:	1000                	addi	s0,sp,32
    80004cb8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004cba:	00850913          	addi	s2,a0,8
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	ffffc097          	auipc	ra,0xffffc
    80004cc4:	246080e7          	jalr	582(ra) # 80000f06 <acquire>
  lk->locked = 0;
    80004cc8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004ccc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	94c080e7          	jalr	-1716(ra) # 8000261e <wakeup>
  release(&lk->lk);
    80004cda:	854a                	mv	a0,s2
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	2de080e7          	jalr	734(ra) # 80000fba <release>
}
    80004ce4:	60e2                	ld	ra,24(sp)
    80004ce6:	6442                	ld	s0,16(sp)
    80004ce8:	64a2                	ld	s1,8(sp)
    80004cea:	6902                	ld	s2,0(sp)
    80004cec:	6105                	addi	sp,sp,32
    80004cee:	8082                	ret

0000000080004cf0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004cf0:	7179                	addi	sp,sp,-48
    80004cf2:	f406                	sd	ra,40(sp)
    80004cf4:	f022                	sd	s0,32(sp)
    80004cf6:	ec26                	sd	s1,24(sp)
    80004cf8:	e84a                	sd	s2,16(sp)
    80004cfa:	1800                	addi	s0,sp,48
    80004cfc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004cfe:	00850913          	addi	s2,a0,8
    80004d02:	854a                	mv	a0,s2
    80004d04:	ffffc097          	auipc	ra,0xffffc
    80004d08:	202080e7          	jalr	514(ra) # 80000f06 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004d0c:	409c                	lw	a5,0(s1)
    80004d0e:	ef91                	bnez	a5,80004d2a <holdingsleep+0x3a>
    80004d10:	4481                	li	s1,0
  release(&lk->lk);
    80004d12:	854a                	mv	a0,s2
    80004d14:	ffffc097          	auipc	ra,0xffffc
    80004d18:	2a6080e7          	jalr	678(ra) # 80000fba <release>
  return r;
}
    80004d1c:	8526                	mv	a0,s1
    80004d1e:	70a2                	ld	ra,40(sp)
    80004d20:	7402                	ld	s0,32(sp)
    80004d22:	64e2                	ld	s1,24(sp)
    80004d24:	6942                	ld	s2,16(sp)
    80004d26:	6145                	addi	sp,sp,48
    80004d28:	8082                	ret
    80004d2a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004d2c:	0284a983          	lw	s3,40(s1)
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	0d8080e7          	jalr	216(ra) # 80001e08 <myproc>
    80004d38:	5904                	lw	s1,48(a0)
    80004d3a:	413484b3          	sub	s1,s1,s3
    80004d3e:	0014b493          	seqz	s1,s1
    80004d42:	69a2                	ld	s3,8(sp)
    80004d44:	b7f9                	j	80004d12 <holdingsleep+0x22>

0000000080004d46 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004d46:	1141                	addi	sp,sp,-16
    80004d48:	e406                	sd	ra,8(sp)
    80004d4a:	e022                	sd	s0,0(sp)
    80004d4c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004d4e:	00004597          	auipc	a1,0x4
    80004d52:	96258593          	addi	a1,a1,-1694 # 800086b0 <__func__.1+0x6a8>
    80004d56:	0003f517          	auipc	a0,0x3f
    80004d5a:	c9a50513          	addi	a0,a0,-870 # 800439f0 <ftable>
    80004d5e:	ffffc097          	auipc	ra,0xffffc
    80004d62:	118080e7          	jalr	280(ra) # 80000e76 <initlock>
}
    80004d66:	60a2                	ld	ra,8(sp)
    80004d68:	6402                	ld	s0,0(sp)
    80004d6a:	0141                	addi	sp,sp,16
    80004d6c:	8082                	ret

0000000080004d6e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d6e:	1101                	addi	sp,sp,-32
    80004d70:	ec06                	sd	ra,24(sp)
    80004d72:	e822                	sd	s0,16(sp)
    80004d74:	e426                	sd	s1,8(sp)
    80004d76:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d78:	0003f517          	auipc	a0,0x3f
    80004d7c:	c7850513          	addi	a0,a0,-904 # 800439f0 <ftable>
    80004d80:	ffffc097          	auipc	ra,0xffffc
    80004d84:	186080e7          	jalr	390(ra) # 80000f06 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d88:	0003f497          	auipc	s1,0x3f
    80004d8c:	c8048493          	addi	s1,s1,-896 # 80043a08 <ftable+0x18>
    80004d90:	00040717          	auipc	a4,0x40
    80004d94:	c1870713          	addi	a4,a4,-1000 # 800449a8 <disk>
    if(f->ref == 0){
    80004d98:	40dc                	lw	a5,4(s1)
    80004d9a:	cf99                	beqz	a5,80004db8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d9c:	02848493          	addi	s1,s1,40
    80004da0:	fee49ce3          	bne	s1,a4,80004d98 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004da4:	0003f517          	auipc	a0,0x3f
    80004da8:	c4c50513          	addi	a0,a0,-948 # 800439f0 <ftable>
    80004dac:	ffffc097          	auipc	ra,0xffffc
    80004db0:	20e080e7          	jalr	526(ra) # 80000fba <release>
  return 0;
    80004db4:	4481                	li	s1,0
    80004db6:	a819                	j	80004dcc <filealloc+0x5e>
      f->ref = 1;
    80004db8:	4785                	li	a5,1
    80004dba:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004dbc:	0003f517          	auipc	a0,0x3f
    80004dc0:	c3450513          	addi	a0,a0,-972 # 800439f0 <ftable>
    80004dc4:	ffffc097          	auipc	ra,0xffffc
    80004dc8:	1f6080e7          	jalr	502(ra) # 80000fba <release>
}
    80004dcc:	8526                	mv	a0,s1
    80004dce:	60e2                	ld	ra,24(sp)
    80004dd0:	6442                	ld	s0,16(sp)
    80004dd2:	64a2                	ld	s1,8(sp)
    80004dd4:	6105                	addi	sp,sp,32
    80004dd6:	8082                	ret

0000000080004dd8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004dd8:	1101                	addi	sp,sp,-32
    80004dda:	ec06                	sd	ra,24(sp)
    80004ddc:	e822                	sd	s0,16(sp)
    80004dde:	e426                	sd	s1,8(sp)
    80004de0:	1000                	addi	s0,sp,32
    80004de2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004de4:	0003f517          	auipc	a0,0x3f
    80004de8:	c0c50513          	addi	a0,a0,-1012 # 800439f0 <ftable>
    80004dec:	ffffc097          	auipc	ra,0xffffc
    80004df0:	11a080e7          	jalr	282(ra) # 80000f06 <acquire>
  if(f->ref < 1)
    80004df4:	40dc                	lw	a5,4(s1)
    80004df6:	02f05263          	blez	a5,80004e1a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004dfa:	2785                	addiw	a5,a5,1
    80004dfc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004dfe:	0003f517          	auipc	a0,0x3f
    80004e02:	bf250513          	addi	a0,a0,-1038 # 800439f0 <ftable>
    80004e06:	ffffc097          	auipc	ra,0xffffc
    80004e0a:	1b4080e7          	jalr	436(ra) # 80000fba <release>
  return f;
}
    80004e0e:	8526                	mv	a0,s1
    80004e10:	60e2                	ld	ra,24(sp)
    80004e12:	6442                	ld	s0,16(sp)
    80004e14:	64a2                	ld	s1,8(sp)
    80004e16:	6105                	addi	sp,sp,32
    80004e18:	8082                	ret
    panic("filedup");
    80004e1a:	00004517          	auipc	a0,0x4
    80004e1e:	89e50513          	addi	a0,a0,-1890 # 800086b8 <__func__.1+0x6b0>
    80004e22:	ffffb097          	auipc	ra,0xffffb
    80004e26:	73e080e7          	jalr	1854(ra) # 80000560 <panic>

0000000080004e2a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004e2a:	7139                	addi	sp,sp,-64
    80004e2c:	fc06                	sd	ra,56(sp)
    80004e2e:	f822                	sd	s0,48(sp)
    80004e30:	f426                	sd	s1,40(sp)
    80004e32:	0080                	addi	s0,sp,64
    80004e34:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004e36:	0003f517          	auipc	a0,0x3f
    80004e3a:	bba50513          	addi	a0,a0,-1094 # 800439f0 <ftable>
    80004e3e:	ffffc097          	auipc	ra,0xffffc
    80004e42:	0c8080e7          	jalr	200(ra) # 80000f06 <acquire>
  if(f->ref < 1)
    80004e46:	40dc                	lw	a5,4(s1)
    80004e48:	04f05c63          	blez	a5,80004ea0 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004e4c:	37fd                	addiw	a5,a5,-1
    80004e4e:	0007871b          	sext.w	a4,a5
    80004e52:	c0dc                	sw	a5,4(s1)
    80004e54:	06e04263          	bgtz	a4,80004eb8 <fileclose+0x8e>
    80004e58:	f04a                	sd	s2,32(sp)
    80004e5a:	ec4e                	sd	s3,24(sp)
    80004e5c:	e852                	sd	s4,16(sp)
    80004e5e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e60:	0004a903          	lw	s2,0(s1)
    80004e64:	0094ca83          	lbu	s5,9(s1)
    80004e68:	0104ba03          	ld	s4,16(s1)
    80004e6c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004e70:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e74:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e78:	0003f517          	auipc	a0,0x3f
    80004e7c:	b7850513          	addi	a0,a0,-1160 # 800439f0 <ftable>
    80004e80:	ffffc097          	auipc	ra,0xffffc
    80004e84:	13a080e7          	jalr	314(ra) # 80000fba <release>

  if(ff.type == FD_PIPE){
    80004e88:	4785                	li	a5,1
    80004e8a:	04f90463          	beq	s2,a5,80004ed2 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e8e:	3979                	addiw	s2,s2,-2
    80004e90:	4785                	li	a5,1
    80004e92:	0527fb63          	bgeu	a5,s2,80004ee8 <fileclose+0xbe>
    80004e96:	7902                	ld	s2,32(sp)
    80004e98:	69e2                	ld	s3,24(sp)
    80004e9a:	6a42                	ld	s4,16(sp)
    80004e9c:	6aa2                	ld	s5,8(sp)
    80004e9e:	a02d                	j	80004ec8 <fileclose+0x9e>
    80004ea0:	f04a                	sd	s2,32(sp)
    80004ea2:	ec4e                	sd	s3,24(sp)
    80004ea4:	e852                	sd	s4,16(sp)
    80004ea6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004ea8:	00004517          	auipc	a0,0x4
    80004eac:	81850513          	addi	a0,a0,-2024 # 800086c0 <__func__.1+0x6b8>
    80004eb0:	ffffb097          	auipc	ra,0xffffb
    80004eb4:	6b0080e7          	jalr	1712(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004eb8:	0003f517          	auipc	a0,0x3f
    80004ebc:	b3850513          	addi	a0,a0,-1224 # 800439f0 <ftable>
    80004ec0:	ffffc097          	auipc	ra,0xffffc
    80004ec4:	0fa080e7          	jalr	250(ra) # 80000fba <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004ec8:	70e2                	ld	ra,56(sp)
    80004eca:	7442                	ld	s0,48(sp)
    80004ecc:	74a2                	ld	s1,40(sp)
    80004ece:	6121                	addi	sp,sp,64
    80004ed0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ed2:	85d6                	mv	a1,s5
    80004ed4:	8552                	mv	a0,s4
    80004ed6:	00000097          	auipc	ra,0x0
    80004eda:	3a2080e7          	jalr	930(ra) # 80005278 <pipeclose>
    80004ede:	7902                	ld	s2,32(sp)
    80004ee0:	69e2                	ld	s3,24(sp)
    80004ee2:	6a42                	ld	s4,16(sp)
    80004ee4:	6aa2                	ld	s5,8(sp)
    80004ee6:	b7cd                	j	80004ec8 <fileclose+0x9e>
    begin_op();
    80004ee8:	00000097          	auipc	ra,0x0
    80004eec:	a78080e7          	jalr	-1416(ra) # 80004960 <begin_op>
    iput(ff.ip);
    80004ef0:	854e                	mv	a0,s3
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	25e080e7          	jalr	606(ra) # 80004150 <iput>
    end_op();
    80004efa:	00000097          	auipc	ra,0x0
    80004efe:	ae0080e7          	jalr	-1312(ra) # 800049da <end_op>
    80004f02:	7902                	ld	s2,32(sp)
    80004f04:	69e2                	ld	s3,24(sp)
    80004f06:	6a42                	ld	s4,16(sp)
    80004f08:	6aa2                	ld	s5,8(sp)
    80004f0a:	bf7d                	j	80004ec8 <fileclose+0x9e>

0000000080004f0c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004f0c:	715d                	addi	sp,sp,-80
    80004f0e:	e486                	sd	ra,72(sp)
    80004f10:	e0a2                	sd	s0,64(sp)
    80004f12:	fc26                	sd	s1,56(sp)
    80004f14:	f44e                	sd	s3,40(sp)
    80004f16:	0880                	addi	s0,sp,80
    80004f18:	84aa                	mv	s1,a0
    80004f1a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	eec080e7          	jalr	-276(ra) # 80001e08 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004f24:	409c                	lw	a5,0(s1)
    80004f26:	37f9                	addiw	a5,a5,-2
    80004f28:	4705                	li	a4,1
    80004f2a:	04f76863          	bltu	a4,a5,80004f7a <filestat+0x6e>
    80004f2e:	f84a                	sd	s2,48(sp)
    80004f30:	892a                	mv	s2,a0
    ilock(f->ip);
    80004f32:	6c88                	ld	a0,24(s1)
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	05e080e7          	jalr	94(ra) # 80003f92 <ilock>
    stati(f->ip, &st);
    80004f3c:	fb840593          	addi	a1,s0,-72
    80004f40:	6c88                	ld	a0,24(s1)
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	2de080e7          	jalr	734(ra) # 80004220 <stati>
    iunlock(f->ip);
    80004f4a:	6c88                	ld	a0,24(s1)
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	10c080e7          	jalr	268(ra) # 80004058 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004f54:	46e1                	li	a3,24
    80004f56:	fb840613          	addi	a2,s0,-72
    80004f5a:	85ce                	mv	a1,s3
    80004f5c:	05093503          	ld	a0,80(s2)
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	a4c080e7          	jalr	-1460(ra) # 800019ac <copyout>
    80004f68:	41f5551b          	sraiw	a0,a0,0x1f
    80004f6c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004f6e:	60a6                	ld	ra,72(sp)
    80004f70:	6406                	ld	s0,64(sp)
    80004f72:	74e2                	ld	s1,56(sp)
    80004f74:	79a2                	ld	s3,40(sp)
    80004f76:	6161                	addi	sp,sp,80
    80004f78:	8082                	ret
  return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	bfcd                	j	80004f6e <filestat+0x62>

0000000080004f7e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f7e:	7179                	addi	sp,sp,-48
    80004f80:	f406                	sd	ra,40(sp)
    80004f82:	f022                	sd	s0,32(sp)
    80004f84:	e84a                	sd	s2,16(sp)
    80004f86:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f88:	00854783          	lbu	a5,8(a0)
    80004f8c:	cbc5                	beqz	a5,8000503c <fileread+0xbe>
    80004f8e:	ec26                	sd	s1,24(sp)
    80004f90:	e44e                	sd	s3,8(sp)
    80004f92:	84aa                	mv	s1,a0
    80004f94:	89ae                	mv	s3,a1
    80004f96:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f98:	411c                	lw	a5,0(a0)
    80004f9a:	4705                	li	a4,1
    80004f9c:	04e78963          	beq	a5,a4,80004fee <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004fa0:	470d                	li	a4,3
    80004fa2:	04e78f63          	beq	a5,a4,80005000 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004fa6:	4709                	li	a4,2
    80004fa8:	08e79263          	bne	a5,a4,8000502c <fileread+0xae>
    ilock(f->ip);
    80004fac:	6d08                	ld	a0,24(a0)
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	fe4080e7          	jalr	-28(ra) # 80003f92 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004fb6:	874a                	mv	a4,s2
    80004fb8:	5094                	lw	a3,32(s1)
    80004fba:	864e                	mv	a2,s3
    80004fbc:	4585                	li	a1,1
    80004fbe:	6c88                	ld	a0,24(s1)
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	28a080e7          	jalr	650(ra) # 8000424a <readi>
    80004fc8:	892a                	mv	s2,a0
    80004fca:	00a05563          	blez	a0,80004fd4 <fileread+0x56>
      f->off += r;
    80004fce:	509c                	lw	a5,32(s1)
    80004fd0:	9fa9                	addw	a5,a5,a0
    80004fd2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004fd4:	6c88                	ld	a0,24(s1)
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	082080e7          	jalr	130(ra) # 80004058 <iunlock>
    80004fde:	64e2                	ld	s1,24(sp)
    80004fe0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	70a2                	ld	ra,40(sp)
    80004fe6:	7402                	ld	s0,32(sp)
    80004fe8:	6942                	ld	s2,16(sp)
    80004fea:	6145                	addi	sp,sp,48
    80004fec:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004fee:	6908                	ld	a0,16(a0)
    80004ff0:	00000097          	auipc	ra,0x0
    80004ff4:	400080e7          	jalr	1024(ra) # 800053f0 <piperead>
    80004ff8:	892a                	mv	s2,a0
    80004ffa:	64e2                	ld	s1,24(sp)
    80004ffc:	69a2                	ld	s3,8(sp)
    80004ffe:	b7d5                	j	80004fe2 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005000:	02451783          	lh	a5,36(a0)
    80005004:	03079693          	slli	a3,a5,0x30
    80005008:	92c1                	srli	a3,a3,0x30
    8000500a:	4725                	li	a4,9
    8000500c:	02d76a63          	bltu	a4,a3,80005040 <fileread+0xc2>
    80005010:	0792                	slli	a5,a5,0x4
    80005012:	0003f717          	auipc	a4,0x3f
    80005016:	93e70713          	addi	a4,a4,-1730 # 80043950 <devsw>
    8000501a:	97ba                	add	a5,a5,a4
    8000501c:	639c                	ld	a5,0(a5)
    8000501e:	c78d                	beqz	a5,80005048 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80005020:	4505                	li	a0,1
    80005022:	9782                	jalr	a5
    80005024:	892a                	mv	s2,a0
    80005026:	64e2                	ld	s1,24(sp)
    80005028:	69a2                	ld	s3,8(sp)
    8000502a:	bf65                	j	80004fe2 <fileread+0x64>
    panic("fileread");
    8000502c:	00003517          	auipc	a0,0x3
    80005030:	6a450513          	addi	a0,a0,1700 # 800086d0 <__func__.1+0x6c8>
    80005034:	ffffb097          	auipc	ra,0xffffb
    80005038:	52c080e7          	jalr	1324(ra) # 80000560 <panic>
    return -1;
    8000503c:	597d                	li	s2,-1
    8000503e:	b755                	j	80004fe2 <fileread+0x64>
      return -1;
    80005040:	597d                	li	s2,-1
    80005042:	64e2                	ld	s1,24(sp)
    80005044:	69a2                	ld	s3,8(sp)
    80005046:	bf71                	j	80004fe2 <fileread+0x64>
    80005048:	597d                	li	s2,-1
    8000504a:	64e2                	ld	s1,24(sp)
    8000504c:	69a2                	ld	s3,8(sp)
    8000504e:	bf51                	j	80004fe2 <fileread+0x64>

0000000080005050 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005050:	00954783          	lbu	a5,9(a0)
    80005054:	12078963          	beqz	a5,80005186 <filewrite+0x136>
{
    80005058:	715d                	addi	sp,sp,-80
    8000505a:	e486                	sd	ra,72(sp)
    8000505c:	e0a2                	sd	s0,64(sp)
    8000505e:	f84a                	sd	s2,48(sp)
    80005060:	f052                	sd	s4,32(sp)
    80005062:	e85a                	sd	s6,16(sp)
    80005064:	0880                	addi	s0,sp,80
    80005066:	892a                	mv	s2,a0
    80005068:	8b2e                	mv	s6,a1
    8000506a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000506c:	411c                	lw	a5,0(a0)
    8000506e:	4705                	li	a4,1
    80005070:	02e78763          	beq	a5,a4,8000509e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005074:	470d                	li	a4,3
    80005076:	02e78a63          	beq	a5,a4,800050aa <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000507a:	4709                	li	a4,2
    8000507c:	0ee79863          	bne	a5,a4,8000516c <filewrite+0x11c>
    80005080:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005082:	0cc05463          	blez	a2,8000514a <filewrite+0xfa>
    80005086:	fc26                	sd	s1,56(sp)
    80005088:	ec56                	sd	s5,24(sp)
    8000508a:	e45e                	sd	s7,8(sp)
    8000508c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000508e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80005090:	6b85                	lui	s7,0x1
    80005092:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005096:	6c05                	lui	s8,0x1
    80005098:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000509c:	a851                	j	80005130 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000509e:	6908                	ld	a0,16(a0)
    800050a0:	00000097          	auipc	ra,0x0
    800050a4:	248080e7          	jalr	584(ra) # 800052e8 <pipewrite>
    800050a8:	a85d                	j	8000515e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800050aa:	02451783          	lh	a5,36(a0)
    800050ae:	03079693          	slli	a3,a5,0x30
    800050b2:	92c1                	srli	a3,a3,0x30
    800050b4:	4725                	li	a4,9
    800050b6:	0cd76a63          	bltu	a4,a3,8000518a <filewrite+0x13a>
    800050ba:	0792                	slli	a5,a5,0x4
    800050bc:	0003f717          	auipc	a4,0x3f
    800050c0:	89470713          	addi	a4,a4,-1900 # 80043950 <devsw>
    800050c4:	97ba                	add	a5,a5,a4
    800050c6:	679c                	ld	a5,8(a5)
    800050c8:	c3f9                	beqz	a5,8000518e <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    800050ca:	4505                	li	a0,1
    800050cc:	9782                	jalr	a5
    800050ce:	a841                	j	8000515e <filewrite+0x10e>
      if(n1 > max)
    800050d0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800050d4:	00000097          	auipc	ra,0x0
    800050d8:	88c080e7          	jalr	-1908(ra) # 80004960 <begin_op>
      ilock(f->ip);
    800050dc:	01893503          	ld	a0,24(s2)
    800050e0:	fffff097          	auipc	ra,0xfffff
    800050e4:	eb2080e7          	jalr	-334(ra) # 80003f92 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800050e8:	8756                	mv	a4,s5
    800050ea:	02092683          	lw	a3,32(s2)
    800050ee:	01698633          	add	a2,s3,s6
    800050f2:	4585                	li	a1,1
    800050f4:	01893503          	ld	a0,24(s2)
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	262080e7          	jalr	610(ra) # 8000435a <writei>
    80005100:	84aa                	mv	s1,a0
    80005102:	00a05763          	blez	a0,80005110 <filewrite+0xc0>
        f->off += r;
    80005106:	02092783          	lw	a5,32(s2)
    8000510a:	9fa9                	addw	a5,a5,a0
    8000510c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005110:	01893503          	ld	a0,24(s2)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	f44080e7          	jalr	-188(ra) # 80004058 <iunlock>
      end_op();
    8000511c:	00000097          	auipc	ra,0x0
    80005120:	8be080e7          	jalr	-1858(ra) # 800049da <end_op>

      if(r != n1){
    80005124:	029a9563          	bne	s5,s1,8000514e <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80005128:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000512c:	0149da63          	bge	s3,s4,80005140 <filewrite+0xf0>
      int n1 = n - i;
    80005130:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80005134:	0004879b          	sext.w	a5,s1
    80005138:	f8fbdce3          	bge	s7,a5,800050d0 <filewrite+0x80>
    8000513c:	84e2                	mv	s1,s8
    8000513e:	bf49                	j	800050d0 <filewrite+0x80>
    80005140:	74e2                	ld	s1,56(sp)
    80005142:	6ae2                	ld	s5,24(sp)
    80005144:	6ba2                	ld	s7,8(sp)
    80005146:	6c02                	ld	s8,0(sp)
    80005148:	a039                	j	80005156 <filewrite+0x106>
    int i = 0;
    8000514a:	4981                	li	s3,0
    8000514c:	a029                	j	80005156 <filewrite+0x106>
    8000514e:	74e2                	ld	s1,56(sp)
    80005150:	6ae2                	ld	s5,24(sp)
    80005152:	6ba2                	ld	s7,8(sp)
    80005154:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80005156:	033a1e63          	bne	s4,s3,80005192 <filewrite+0x142>
    8000515a:	8552                	mv	a0,s4
    8000515c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000515e:	60a6                	ld	ra,72(sp)
    80005160:	6406                	ld	s0,64(sp)
    80005162:	7942                	ld	s2,48(sp)
    80005164:	7a02                	ld	s4,32(sp)
    80005166:	6b42                	ld	s6,16(sp)
    80005168:	6161                	addi	sp,sp,80
    8000516a:	8082                	ret
    8000516c:	fc26                	sd	s1,56(sp)
    8000516e:	f44e                	sd	s3,40(sp)
    80005170:	ec56                	sd	s5,24(sp)
    80005172:	e45e                	sd	s7,8(sp)
    80005174:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80005176:	00003517          	auipc	a0,0x3
    8000517a:	56a50513          	addi	a0,a0,1386 # 800086e0 <__func__.1+0x6d8>
    8000517e:	ffffb097          	auipc	ra,0xffffb
    80005182:	3e2080e7          	jalr	994(ra) # 80000560 <panic>
    return -1;
    80005186:	557d                	li	a0,-1
}
    80005188:	8082                	ret
      return -1;
    8000518a:	557d                	li	a0,-1
    8000518c:	bfc9                	j	8000515e <filewrite+0x10e>
    8000518e:	557d                	li	a0,-1
    80005190:	b7f9                	j	8000515e <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80005192:	557d                	li	a0,-1
    80005194:	79a2                	ld	s3,40(sp)
    80005196:	b7e1                	j	8000515e <filewrite+0x10e>

0000000080005198 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005198:	7179                	addi	sp,sp,-48
    8000519a:	f406                	sd	ra,40(sp)
    8000519c:	f022                	sd	s0,32(sp)
    8000519e:	ec26                	sd	s1,24(sp)
    800051a0:	e052                	sd	s4,0(sp)
    800051a2:	1800                	addi	s0,sp,48
    800051a4:	84aa                	mv	s1,a0
    800051a6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800051a8:	0005b023          	sd	zero,0(a1)
    800051ac:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800051b0:	00000097          	auipc	ra,0x0
    800051b4:	bbe080e7          	jalr	-1090(ra) # 80004d6e <filealloc>
    800051b8:	e088                	sd	a0,0(s1)
    800051ba:	cd49                	beqz	a0,80005254 <pipealloc+0xbc>
    800051bc:	00000097          	auipc	ra,0x0
    800051c0:	bb2080e7          	jalr	-1102(ra) # 80004d6e <filealloc>
    800051c4:	00aa3023          	sd	a0,0(s4)
    800051c8:	c141                	beqz	a0,80005248 <pipealloc+0xb0>
    800051ca:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800051cc:	ffffc097          	auipc	ra,0xffffc
    800051d0:	bb0080e7          	jalr	-1104(ra) # 80000d7c <kalloc>
    800051d4:	892a                	mv	s2,a0
    800051d6:	c13d                	beqz	a0,8000523c <pipealloc+0xa4>
    800051d8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800051da:	4985                	li	s3,1
    800051dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800051e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800051e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800051e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800051ec:	00003597          	auipc	a1,0x3
    800051f0:	50458593          	addi	a1,a1,1284 # 800086f0 <__func__.1+0x6e8>
    800051f4:	ffffc097          	auipc	ra,0xffffc
    800051f8:	c82080e7          	jalr	-894(ra) # 80000e76 <initlock>
  (*f0)->type = FD_PIPE;
    800051fc:	609c                	ld	a5,0(s1)
    800051fe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005202:	609c                	ld	a5,0(s1)
    80005204:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005208:	609c                	ld	a5,0(s1)
    8000520a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000520e:	609c                	ld	a5,0(s1)
    80005210:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005214:	000a3783          	ld	a5,0(s4)
    80005218:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000521c:	000a3783          	ld	a5,0(s4)
    80005220:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005224:	000a3783          	ld	a5,0(s4)
    80005228:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000522c:	000a3783          	ld	a5,0(s4)
    80005230:	0127b823          	sd	s2,16(a5)
  return 0;
    80005234:	4501                	li	a0,0
    80005236:	6942                	ld	s2,16(sp)
    80005238:	69a2                	ld	s3,8(sp)
    8000523a:	a03d                	j	80005268 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000523c:	6088                	ld	a0,0(s1)
    8000523e:	c119                	beqz	a0,80005244 <pipealloc+0xac>
    80005240:	6942                	ld	s2,16(sp)
    80005242:	a029                	j	8000524c <pipealloc+0xb4>
    80005244:	6942                	ld	s2,16(sp)
    80005246:	a039                	j	80005254 <pipealloc+0xbc>
    80005248:	6088                	ld	a0,0(s1)
    8000524a:	c50d                	beqz	a0,80005274 <pipealloc+0xdc>
    fileclose(*f0);
    8000524c:	00000097          	auipc	ra,0x0
    80005250:	bde080e7          	jalr	-1058(ra) # 80004e2a <fileclose>
  if(*f1)
    80005254:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005258:	557d                	li	a0,-1
  if(*f1)
    8000525a:	c799                	beqz	a5,80005268 <pipealloc+0xd0>
    fileclose(*f1);
    8000525c:	853e                	mv	a0,a5
    8000525e:	00000097          	auipc	ra,0x0
    80005262:	bcc080e7          	jalr	-1076(ra) # 80004e2a <fileclose>
  return -1;
    80005266:	557d                	li	a0,-1
}
    80005268:	70a2                	ld	ra,40(sp)
    8000526a:	7402                	ld	s0,32(sp)
    8000526c:	64e2                	ld	s1,24(sp)
    8000526e:	6a02                	ld	s4,0(sp)
    80005270:	6145                	addi	sp,sp,48
    80005272:	8082                	ret
  return -1;
    80005274:	557d                	li	a0,-1
    80005276:	bfcd                	j	80005268 <pipealloc+0xd0>

0000000080005278 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005278:	1101                	addi	sp,sp,-32
    8000527a:	ec06                	sd	ra,24(sp)
    8000527c:	e822                	sd	s0,16(sp)
    8000527e:	e426                	sd	s1,8(sp)
    80005280:	e04a                	sd	s2,0(sp)
    80005282:	1000                	addi	s0,sp,32
    80005284:	84aa                	mv	s1,a0
    80005286:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	c7e080e7          	jalr	-898(ra) # 80000f06 <acquire>
  if(writable){
    80005290:	02090d63          	beqz	s2,800052ca <pipeclose+0x52>
    pi->writeopen = 0;
    80005294:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005298:	21848513          	addi	a0,s1,536
    8000529c:	ffffd097          	auipc	ra,0xffffd
    800052a0:	382080e7          	jalr	898(ra) # 8000261e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800052a4:	2204b783          	ld	a5,544(s1)
    800052a8:	eb95                	bnez	a5,800052dc <pipeclose+0x64>
    release(&pi->lock);
    800052aa:	8526                	mv	a0,s1
    800052ac:	ffffc097          	auipc	ra,0xffffc
    800052b0:	d0e080e7          	jalr	-754(ra) # 80000fba <release>
    kfree((char*)pi);
    800052b4:	8526                	mv	a0,s1
    800052b6:	ffffc097          	auipc	ra,0xffffc
    800052ba:	8cc080e7          	jalr	-1844(ra) # 80000b82 <kfree>
  } else
    release(&pi->lock);
}
    800052be:	60e2                	ld	ra,24(sp)
    800052c0:	6442                	ld	s0,16(sp)
    800052c2:	64a2                	ld	s1,8(sp)
    800052c4:	6902                	ld	s2,0(sp)
    800052c6:	6105                	addi	sp,sp,32
    800052c8:	8082                	ret
    pi->readopen = 0;
    800052ca:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800052ce:	21c48513          	addi	a0,s1,540
    800052d2:	ffffd097          	auipc	ra,0xffffd
    800052d6:	34c080e7          	jalr	844(ra) # 8000261e <wakeup>
    800052da:	b7e9                	j	800052a4 <pipeclose+0x2c>
    release(&pi->lock);
    800052dc:	8526                	mv	a0,s1
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	cdc080e7          	jalr	-804(ra) # 80000fba <release>
}
    800052e6:	bfe1                	j	800052be <pipeclose+0x46>

00000000800052e8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800052e8:	711d                	addi	sp,sp,-96
    800052ea:	ec86                	sd	ra,88(sp)
    800052ec:	e8a2                	sd	s0,80(sp)
    800052ee:	e4a6                	sd	s1,72(sp)
    800052f0:	e0ca                	sd	s2,64(sp)
    800052f2:	fc4e                	sd	s3,56(sp)
    800052f4:	f852                	sd	s4,48(sp)
    800052f6:	f456                	sd	s5,40(sp)
    800052f8:	1080                	addi	s0,sp,96
    800052fa:	84aa                	mv	s1,a0
    800052fc:	8aae                	mv	s5,a1
    800052fe:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005300:	ffffd097          	auipc	ra,0xffffd
    80005304:	b08080e7          	jalr	-1272(ra) # 80001e08 <myproc>
    80005308:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000530a:	8526                	mv	a0,s1
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	bfa080e7          	jalr	-1030(ra) # 80000f06 <acquire>
  while(i < n){
    80005314:	0d405863          	blez	s4,800053e4 <pipewrite+0xfc>
    80005318:	f05a                	sd	s6,32(sp)
    8000531a:	ec5e                	sd	s7,24(sp)
    8000531c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000531e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005320:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005322:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005326:	21c48b93          	addi	s7,s1,540
    8000532a:	a089                	j	8000536c <pipewrite+0x84>
      release(&pi->lock);
    8000532c:	8526                	mv	a0,s1
    8000532e:	ffffc097          	auipc	ra,0xffffc
    80005332:	c8c080e7          	jalr	-884(ra) # 80000fba <release>
      return -1;
    80005336:	597d                	li	s2,-1
    80005338:	7b02                	ld	s6,32(sp)
    8000533a:	6be2                	ld	s7,24(sp)
    8000533c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000533e:	854a                	mv	a0,s2
    80005340:	60e6                	ld	ra,88(sp)
    80005342:	6446                	ld	s0,80(sp)
    80005344:	64a6                	ld	s1,72(sp)
    80005346:	6906                	ld	s2,64(sp)
    80005348:	79e2                	ld	s3,56(sp)
    8000534a:	7a42                	ld	s4,48(sp)
    8000534c:	7aa2                	ld	s5,40(sp)
    8000534e:	6125                	addi	sp,sp,96
    80005350:	8082                	ret
      wakeup(&pi->nread);
    80005352:	8562                	mv	a0,s8
    80005354:	ffffd097          	auipc	ra,0xffffd
    80005358:	2ca080e7          	jalr	714(ra) # 8000261e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000535c:	85a6                	mv	a1,s1
    8000535e:	855e                	mv	a0,s7
    80005360:	ffffd097          	auipc	ra,0xffffd
    80005364:	25a080e7          	jalr	602(ra) # 800025ba <sleep>
  while(i < n){
    80005368:	05495f63          	bge	s2,s4,800053c6 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    8000536c:	2204a783          	lw	a5,544(s1)
    80005370:	dfd5                	beqz	a5,8000532c <pipewrite+0x44>
    80005372:	854e                	mv	a0,s3
    80005374:	ffffd097          	auipc	ra,0xffffd
    80005378:	4ee080e7          	jalr	1262(ra) # 80002862 <killed>
    8000537c:	f945                	bnez	a0,8000532c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000537e:	2184a783          	lw	a5,536(s1)
    80005382:	21c4a703          	lw	a4,540(s1)
    80005386:	2007879b          	addiw	a5,a5,512
    8000538a:	fcf704e3          	beq	a4,a5,80005352 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000538e:	4685                	li	a3,1
    80005390:	01590633          	add	a2,s2,s5
    80005394:	faf40593          	addi	a1,s0,-81
    80005398:	0509b503          	ld	a0,80(s3)
    8000539c:	ffffc097          	auipc	ra,0xffffc
    800053a0:	69c080e7          	jalr	1692(ra) # 80001a38 <copyin>
    800053a4:	05650263          	beq	a0,s6,800053e8 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800053a8:	21c4a783          	lw	a5,540(s1)
    800053ac:	0017871b          	addiw	a4,a5,1
    800053b0:	20e4ae23          	sw	a4,540(s1)
    800053b4:	1ff7f793          	andi	a5,a5,511
    800053b8:	97a6                	add	a5,a5,s1
    800053ba:	faf44703          	lbu	a4,-81(s0)
    800053be:	00e78c23          	sb	a4,24(a5)
      i++;
    800053c2:	2905                	addiw	s2,s2,1
    800053c4:	b755                	j	80005368 <pipewrite+0x80>
    800053c6:	7b02                	ld	s6,32(sp)
    800053c8:	6be2                	ld	s7,24(sp)
    800053ca:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800053cc:	21848513          	addi	a0,s1,536
    800053d0:	ffffd097          	auipc	ra,0xffffd
    800053d4:	24e080e7          	jalr	590(ra) # 8000261e <wakeup>
  release(&pi->lock);
    800053d8:	8526                	mv	a0,s1
    800053da:	ffffc097          	auipc	ra,0xffffc
    800053de:	be0080e7          	jalr	-1056(ra) # 80000fba <release>
  return i;
    800053e2:	bfb1                	j	8000533e <pipewrite+0x56>
  int i = 0;
    800053e4:	4901                	li	s2,0
    800053e6:	b7dd                	j	800053cc <pipewrite+0xe4>
    800053e8:	7b02                	ld	s6,32(sp)
    800053ea:	6be2                	ld	s7,24(sp)
    800053ec:	6c42                	ld	s8,16(sp)
    800053ee:	bff9                	j	800053cc <pipewrite+0xe4>

00000000800053f0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800053f0:	715d                	addi	sp,sp,-80
    800053f2:	e486                	sd	ra,72(sp)
    800053f4:	e0a2                	sd	s0,64(sp)
    800053f6:	fc26                	sd	s1,56(sp)
    800053f8:	f84a                	sd	s2,48(sp)
    800053fa:	f44e                	sd	s3,40(sp)
    800053fc:	f052                	sd	s4,32(sp)
    800053fe:	ec56                	sd	s5,24(sp)
    80005400:	0880                	addi	s0,sp,80
    80005402:	84aa                	mv	s1,a0
    80005404:	892e                	mv	s2,a1
    80005406:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005408:	ffffd097          	auipc	ra,0xffffd
    8000540c:	a00080e7          	jalr	-1536(ra) # 80001e08 <myproc>
    80005410:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005412:	8526                	mv	a0,s1
    80005414:	ffffc097          	auipc	ra,0xffffc
    80005418:	af2080e7          	jalr	-1294(ra) # 80000f06 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000541c:	2184a703          	lw	a4,536(s1)
    80005420:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005424:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005428:	02f71963          	bne	a4,a5,8000545a <piperead+0x6a>
    8000542c:	2244a783          	lw	a5,548(s1)
    80005430:	cf95                	beqz	a5,8000546c <piperead+0x7c>
    if(killed(pr)){
    80005432:	8552                	mv	a0,s4
    80005434:	ffffd097          	auipc	ra,0xffffd
    80005438:	42e080e7          	jalr	1070(ra) # 80002862 <killed>
    8000543c:	e10d                	bnez	a0,8000545e <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000543e:	85a6                	mv	a1,s1
    80005440:	854e                	mv	a0,s3
    80005442:	ffffd097          	auipc	ra,0xffffd
    80005446:	178080e7          	jalr	376(ra) # 800025ba <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000544a:	2184a703          	lw	a4,536(s1)
    8000544e:	21c4a783          	lw	a5,540(s1)
    80005452:	fcf70de3          	beq	a4,a5,8000542c <piperead+0x3c>
    80005456:	e85a                	sd	s6,16(sp)
    80005458:	a819                	j	8000546e <piperead+0x7e>
    8000545a:	e85a                	sd	s6,16(sp)
    8000545c:	a809                	j	8000546e <piperead+0x7e>
      release(&pi->lock);
    8000545e:	8526                	mv	a0,s1
    80005460:	ffffc097          	auipc	ra,0xffffc
    80005464:	b5a080e7          	jalr	-1190(ra) # 80000fba <release>
      return -1;
    80005468:	59fd                	li	s3,-1
    8000546a:	a0a5                	j	800054d2 <piperead+0xe2>
    8000546c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000546e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005470:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005472:	05505463          	blez	s5,800054ba <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80005476:	2184a783          	lw	a5,536(s1)
    8000547a:	21c4a703          	lw	a4,540(s1)
    8000547e:	02f70e63          	beq	a4,a5,800054ba <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005482:	0017871b          	addiw	a4,a5,1
    80005486:	20e4ac23          	sw	a4,536(s1)
    8000548a:	1ff7f793          	andi	a5,a5,511
    8000548e:	97a6                	add	a5,a5,s1
    80005490:	0187c783          	lbu	a5,24(a5)
    80005494:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005498:	4685                	li	a3,1
    8000549a:	fbf40613          	addi	a2,s0,-65
    8000549e:	85ca                	mv	a1,s2
    800054a0:	050a3503          	ld	a0,80(s4)
    800054a4:	ffffc097          	auipc	ra,0xffffc
    800054a8:	508080e7          	jalr	1288(ra) # 800019ac <copyout>
    800054ac:	01650763          	beq	a0,s6,800054ba <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800054b0:	2985                	addiw	s3,s3,1
    800054b2:	0905                	addi	s2,s2,1
    800054b4:	fd3a91e3          	bne	s5,s3,80005476 <piperead+0x86>
    800054b8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800054ba:	21c48513          	addi	a0,s1,540
    800054be:	ffffd097          	auipc	ra,0xffffd
    800054c2:	160080e7          	jalr	352(ra) # 8000261e <wakeup>
  release(&pi->lock);
    800054c6:	8526                	mv	a0,s1
    800054c8:	ffffc097          	auipc	ra,0xffffc
    800054cc:	af2080e7          	jalr	-1294(ra) # 80000fba <release>
    800054d0:	6b42                	ld	s6,16(sp)
  return i;
}
    800054d2:	854e                	mv	a0,s3
    800054d4:	60a6                	ld	ra,72(sp)
    800054d6:	6406                	ld	s0,64(sp)
    800054d8:	74e2                	ld	s1,56(sp)
    800054da:	7942                	ld	s2,48(sp)
    800054dc:	79a2                	ld	s3,40(sp)
    800054de:	7a02                	ld	s4,32(sp)
    800054e0:	6ae2                	ld	s5,24(sp)
    800054e2:	6161                	addi	sp,sp,80
    800054e4:	8082                	ret

00000000800054e6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800054e6:	1141                	addi	sp,sp,-16
    800054e8:	e422                	sd	s0,8(sp)
    800054ea:	0800                	addi	s0,sp,16
    800054ec:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800054ee:	8905                	andi	a0,a0,1
    800054f0:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800054f2:	8b89                	andi	a5,a5,2
    800054f4:	c399                	beqz	a5,800054fa <flags2perm+0x14>
      perm |= PTE_W;
    800054f6:	00456513          	ori	a0,a0,4
    return perm;
}
    800054fa:	6422                	ld	s0,8(sp)
    800054fc:	0141                	addi	sp,sp,16
    800054fe:	8082                	ret

0000000080005500 <exec>:

int
exec(char *path, char **argv)
{
    80005500:	df010113          	addi	sp,sp,-528
    80005504:	20113423          	sd	ra,520(sp)
    80005508:	20813023          	sd	s0,512(sp)
    8000550c:	ffa6                	sd	s1,504(sp)
    8000550e:	fbca                	sd	s2,496(sp)
    80005510:	0c00                	addi	s0,sp,528
    80005512:	892a                	mv	s2,a0
    80005514:	dea43c23          	sd	a0,-520(s0)
    80005518:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000551c:	ffffd097          	auipc	ra,0xffffd
    80005520:	8ec080e7          	jalr	-1812(ra) # 80001e08 <myproc>
    80005524:	84aa                	mv	s1,a0

  begin_op();
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	43a080e7          	jalr	1082(ra) # 80004960 <begin_op>

  if((ip = namei(path)) == 0){
    8000552e:	854a                	mv	a0,s2
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	230080e7          	jalr	560(ra) # 80004760 <namei>
    80005538:	c135                	beqz	a0,8000559c <exec+0x9c>
    8000553a:	f3d2                	sd	s4,480(sp)
    8000553c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000553e:	fffff097          	auipc	ra,0xfffff
    80005542:	a54080e7          	jalr	-1452(ra) # 80003f92 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005546:	04000713          	li	a4,64
    8000554a:	4681                	li	a3,0
    8000554c:	e5040613          	addi	a2,s0,-432
    80005550:	4581                	li	a1,0
    80005552:	8552                	mv	a0,s4
    80005554:	fffff097          	auipc	ra,0xfffff
    80005558:	cf6080e7          	jalr	-778(ra) # 8000424a <readi>
    8000555c:	04000793          	li	a5,64
    80005560:	00f51a63          	bne	a0,a5,80005574 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005564:	e5042703          	lw	a4,-432(s0)
    80005568:	464c47b7          	lui	a5,0x464c4
    8000556c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005570:	02f70c63          	beq	a4,a5,800055a8 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005574:	8552                	mv	a0,s4
    80005576:	fffff097          	auipc	ra,0xfffff
    8000557a:	c82080e7          	jalr	-894(ra) # 800041f8 <iunlockput>
    end_op();
    8000557e:	fffff097          	auipc	ra,0xfffff
    80005582:	45c080e7          	jalr	1116(ra) # 800049da <end_op>
  }
  return -1;
    80005586:	557d                	li	a0,-1
    80005588:	7a1e                	ld	s4,480(sp)
}
    8000558a:	20813083          	ld	ra,520(sp)
    8000558e:	20013403          	ld	s0,512(sp)
    80005592:	74fe                	ld	s1,504(sp)
    80005594:	795e                	ld	s2,496(sp)
    80005596:	21010113          	addi	sp,sp,528
    8000559a:	8082                	ret
    end_op();
    8000559c:	fffff097          	auipc	ra,0xfffff
    800055a0:	43e080e7          	jalr	1086(ra) # 800049da <end_op>
    return -1;
    800055a4:	557d                	li	a0,-1
    800055a6:	b7d5                	j	8000558a <exec+0x8a>
    800055a8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800055aa:	8526                	mv	a0,s1
    800055ac:	ffffd097          	auipc	ra,0xffffd
    800055b0:	920080e7          	jalr	-1760(ra) # 80001ecc <proc_pagetable>
    800055b4:	8b2a                	mv	s6,a0
    800055b6:	30050f63          	beqz	a0,800058d4 <exec+0x3d4>
    800055ba:	f7ce                	sd	s3,488(sp)
    800055bc:	efd6                	sd	s5,472(sp)
    800055be:	e7de                	sd	s7,456(sp)
    800055c0:	e3e2                	sd	s8,448(sp)
    800055c2:	ff66                	sd	s9,440(sp)
    800055c4:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055c6:	e7042d03          	lw	s10,-400(s0)
    800055ca:	e8845783          	lhu	a5,-376(s0)
    800055ce:	14078d63          	beqz	a5,80005728 <exec+0x228>
    800055d2:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055d4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055d6:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800055d8:	6c85                	lui	s9,0x1
    800055da:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800055de:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800055e2:	6a85                	lui	s5,0x1
    800055e4:	a0b5                	j	80005650 <exec+0x150>
      panic("loadseg: address should exist");
    800055e6:	00003517          	auipc	a0,0x3
    800055ea:	11250513          	addi	a0,a0,274 # 800086f8 <__func__.1+0x6f0>
    800055ee:	ffffb097          	auipc	ra,0xffffb
    800055f2:	f72080e7          	jalr	-142(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800055f6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800055f8:	8726                	mv	a4,s1
    800055fa:	012c06bb          	addw	a3,s8,s2
    800055fe:	4581                	li	a1,0
    80005600:	8552                	mv	a0,s4
    80005602:	fffff097          	auipc	ra,0xfffff
    80005606:	c48080e7          	jalr	-952(ra) # 8000424a <readi>
    8000560a:	2501                	sext.w	a0,a0
    8000560c:	28a49863          	bne	s1,a0,8000589c <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80005610:	012a893b          	addw	s2,s5,s2
    80005614:	03397563          	bgeu	s2,s3,8000563e <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005618:	02091593          	slli	a1,s2,0x20
    8000561c:	9181                	srli	a1,a1,0x20
    8000561e:	95de                	add	a1,a1,s7
    80005620:	855a                	mv	a0,s6
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	d62080e7          	jalr	-670(ra) # 80001384 <walkaddr>
    8000562a:	862a                	mv	a2,a0
    if(pa == 0)
    8000562c:	dd4d                	beqz	a0,800055e6 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000562e:	412984bb          	subw	s1,s3,s2
    80005632:	0004879b          	sext.w	a5,s1
    80005636:	fcfcf0e3          	bgeu	s9,a5,800055f6 <exec+0xf6>
    8000563a:	84d6                	mv	s1,s5
    8000563c:	bf6d                	j	800055f6 <exec+0xf6>
    sz = sz1;
    8000563e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005642:	2d85                	addiw	s11,s11,1
    80005644:	038d0d1b          	addiw	s10,s10,56
    80005648:	e8845783          	lhu	a5,-376(s0)
    8000564c:	08fdd663          	bge	s11,a5,800056d8 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005650:	2d01                	sext.w	s10,s10
    80005652:	03800713          	li	a4,56
    80005656:	86ea                	mv	a3,s10
    80005658:	e1840613          	addi	a2,s0,-488
    8000565c:	4581                	li	a1,0
    8000565e:	8552                	mv	a0,s4
    80005660:	fffff097          	auipc	ra,0xfffff
    80005664:	bea080e7          	jalr	-1046(ra) # 8000424a <readi>
    80005668:	03800793          	li	a5,56
    8000566c:	20f51063          	bne	a0,a5,8000586c <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80005670:	e1842783          	lw	a5,-488(s0)
    80005674:	4705                	li	a4,1
    80005676:	fce796e3          	bne	a5,a4,80005642 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000567a:	e4043483          	ld	s1,-448(s0)
    8000567e:	e3843783          	ld	a5,-456(s0)
    80005682:	1ef4e963          	bltu	s1,a5,80005874 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005686:	e2843783          	ld	a5,-472(s0)
    8000568a:	94be                	add	s1,s1,a5
    8000568c:	1ef4e863          	bltu	s1,a5,8000587c <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005690:	df043703          	ld	a4,-528(s0)
    80005694:	8ff9                	and	a5,a5,a4
    80005696:	1e079763          	bnez	a5,80005884 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000569a:	e1c42503          	lw	a0,-484(s0)
    8000569e:	00000097          	auipc	ra,0x0
    800056a2:	e48080e7          	jalr	-440(ra) # 800054e6 <flags2perm>
    800056a6:	86aa                	mv	a3,a0
    800056a8:	8626                	mv	a2,s1
    800056aa:	85ca                	mv	a1,s2
    800056ac:	855a                	mv	a0,s6
    800056ae:	ffffc097          	auipc	ra,0xffffc
    800056b2:	09a080e7          	jalr	154(ra) # 80001748 <uvmalloc>
    800056b6:	e0a43423          	sd	a0,-504(s0)
    800056ba:	1c050963          	beqz	a0,8000588c <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800056be:	e2843b83          	ld	s7,-472(s0)
    800056c2:	e2042c03          	lw	s8,-480(s0)
    800056c6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800056ca:	00098463          	beqz	s3,800056d2 <exec+0x1d2>
    800056ce:	4901                	li	s2,0
    800056d0:	b7a1                	j	80005618 <exec+0x118>
    sz = sz1;
    800056d2:	e0843903          	ld	s2,-504(s0)
    800056d6:	b7b5                	j	80005642 <exec+0x142>
    800056d8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800056da:	8552                	mv	a0,s4
    800056dc:	fffff097          	auipc	ra,0xfffff
    800056e0:	b1c080e7          	jalr	-1252(ra) # 800041f8 <iunlockput>
  end_op();
    800056e4:	fffff097          	auipc	ra,0xfffff
    800056e8:	2f6080e7          	jalr	758(ra) # 800049da <end_op>
  p = myproc();
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	71c080e7          	jalr	1820(ra) # 80001e08 <myproc>
    800056f4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800056f6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800056fa:	6985                	lui	s3,0x1
    800056fc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800056fe:	99ca                	add	s3,s3,s2
    80005700:	77fd                	lui	a5,0xfffff
    80005702:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005706:	4691                	li	a3,4
    80005708:	6609                	lui	a2,0x2
    8000570a:	964e                	add	a2,a2,s3
    8000570c:	85ce                	mv	a1,s3
    8000570e:	855a                	mv	a0,s6
    80005710:	ffffc097          	auipc	ra,0xffffc
    80005714:	038080e7          	jalr	56(ra) # 80001748 <uvmalloc>
    80005718:	892a                	mv	s2,a0
    8000571a:	e0a43423          	sd	a0,-504(s0)
    8000571e:	e519                	bnez	a0,8000572c <exec+0x22c>
  if(pagetable)
    80005720:	e1343423          	sd	s3,-504(s0)
    80005724:	4a01                	li	s4,0
    80005726:	aaa5                	j	8000589e <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005728:	4901                	li	s2,0
    8000572a:	bf45                	j	800056da <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000572c:	75f9                	lui	a1,0xffffe
    8000572e:	95aa                	add	a1,a1,a0
    80005730:	855a                	mv	a0,s6
    80005732:	ffffc097          	auipc	ra,0xffffc
    80005736:	248080e7          	jalr	584(ra) # 8000197a <uvmclear>
  stackbase = sp - PGSIZE;
    8000573a:	7bfd                	lui	s7,0xfffff
    8000573c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000573e:	e0043783          	ld	a5,-512(s0)
    80005742:	6388                	ld	a0,0(a5)
    80005744:	c52d                	beqz	a0,800057ae <exec+0x2ae>
    80005746:	e9040993          	addi	s3,s0,-368
    8000574a:	f9040c13          	addi	s8,s0,-112
    8000574e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005750:	ffffc097          	auipc	ra,0xffffc
    80005754:	a26080e7          	jalr	-1498(ra) # 80001176 <strlen>
    80005758:	0015079b          	addiw	a5,a0,1
    8000575c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005760:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005764:	13796863          	bltu	s2,s7,80005894 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005768:	e0043d03          	ld	s10,-512(s0)
    8000576c:	000d3a03          	ld	s4,0(s10)
    80005770:	8552                	mv	a0,s4
    80005772:	ffffc097          	auipc	ra,0xffffc
    80005776:	a04080e7          	jalr	-1532(ra) # 80001176 <strlen>
    8000577a:	0015069b          	addiw	a3,a0,1
    8000577e:	8652                	mv	a2,s4
    80005780:	85ca                	mv	a1,s2
    80005782:	855a                	mv	a0,s6
    80005784:	ffffc097          	auipc	ra,0xffffc
    80005788:	228080e7          	jalr	552(ra) # 800019ac <copyout>
    8000578c:	10054663          	bltz	a0,80005898 <exec+0x398>
    ustack[argc] = sp;
    80005790:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005794:	0485                	addi	s1,s1,1
    80005796:	008d0793          	addi	a5,s10,8
    8000579a:	e0f43023          	sd	a5,-512(s0)
    8000579e:	008d3503          	ld	a0,8(s10)
    800057a2:	c909                	beqz	a0,800057b4 <exec+0x2b4>
    if(argc >= MAXARG)
    800057a4:	09a1                	addi	s3,s3,8
    800057a6:	fb8995e3          	bne	s3,s8,80005750 <exec+0x250>
  ip = 0;
    800057aa:	4a01                	li	s4,0
    800057ac:	a8cd                	j	8000589e <exec+0x39e>
  sp = sz;
    800057ae:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800057b2:	4481                	li	s1,0
  ustack[argc] = 0;
    800057b4:	00349793          	slli	a5,s1,0x3
    800057b8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffba4a8>
    800057bc:	97a2                	add	a5,a5,s0
    800057be:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800057c2:	00148693          	addi	a3,s1,1
    800057c6:	068e                	slli	a3,a3,0x3
    800057c8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800057cc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800057d0:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800057d4:	f57966e3          	bltu	s2,s7,80005720 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800057d8:	e9040613          	addi	a2,s0,-368
    800057dc:	85ca                	mv	a1,s2
    800057de:	855a                	mv	a0,s6
    800057e0:	ffffc097          	auipc	ra,0xffffc
    800057e4:	1cc080e7          	jalr	460(ra) # 800019ac <copyout>
    800057e8:	0e054863          	bltz	a0,800058d8 <exec+0x3d8>
  p->trapframe->a1 = sp;
    800057ec:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800057f0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800057f4:	df843783          	ld	a5,-520(s0)
    800057f8:	0007c703          	lbu	a4,0(a5)
    800057fc:	cf11                	beqz	a4,80005818 <exec+0x318>
    800057fe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005800:	02f00693          	li	a3,47
    80005804:	a039                	j	80005812 <exec+0x312>
      last = s+1;
    80005806:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000580a:	0785                	addi	a5,a5,1
    8000580c:	fff7c703          	lbu	a4,-1(a5)
    80005810:	c701                	beqz	a4,80005818 <exec+0x318>
    if(*s == '/')
    80005812:	fed71ce3          	bne	a4,a3,8000580a <exec+0x30a>
    80005816:	bfc5                	j	80005806 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005818:	4641                	li	a2,16
    8000581a:	df843583          	ld	a1,-520(s0)
    8000581e:	158a8513          	addi	a0,s5,344
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	922080e7          	jalr	-1758(ra) # 80001144 <safestrcpy>
  oldpagetable = p->pagetable;
    8000582a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000582e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005832:	e0843783          	ld	a5,-504(s0)
    80005836:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000583a:	058ab783          	ld	a5,88(s5)
    8000583e:	e6843703          	ld	a4,-408(s0)
    80005842:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005844:	058ab783          	ld	a5,88(s5)
    80005848:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000584c:	85e6                	mv	a1,s9
    8000584e:	ffffc097          	auipc	ra,0xffffc
    80005852:	71a080e7          	jalr	1818(ra) # 80001f68 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005856:	0004851b          	sext.w	a0,s1
    8000585a:	79be                	ld	s3,488(sp)
    8000585c:	7a1e                	ld	s4,480(sp)
    8000585e:	6afe                	ld	s5,472(sp)
    80005860:	6b5e                	ld	s6,464(sp)
    80005862:	6bbe                	ld	s7,456(sp)
    80005864:	6c1e                	ld	s8,448(sp)
    80005866:	7cfa                	ld	s9,440(sp)
    80005868:	7d5a                	ld	s10,432(sp)
    8000586a:	b305                	j	8000558a <exec+0x8a>
    8000586c:	e1243423          	sd	s2,-504(s0)
    80005870:	7dba                	ld	s11,424(sp)
    80005872:	a035                	j	8000589e <exec+0x39e>
    80005874:	e1243423          	sd	s2,-504(s0)
    80005878:	7dba                	ld	s11,424(sp)
    8000587a:	a015                	j	8000589e <exec+0x39e>
    8000587c:	e1243423          	sd	s2,-504(s0)
    80005880:	7dba                	ld	s11,424(sp)
    80005882:	a831                	j	8000589e <exec+0x39e>
    80005884:	e1243423          	sd	s2,-504(s0)
    80005888:	7dba                	ld	s11,424(sp)
    8000588a:	a811                	j	8000589e <exec+0x39e>
    8000588c:	e1243423          	sd	s2,-504(s0)
    80005890:	7dba                	ld	s11,424(sp)
    80005892:	a031                	j	8000589e <exec+0x39e>
  ip = 0;
    80005894:	4a01                	li	s4,0
    80005896:	a021                	j	8000589e <exec+0x39e>
    80005898:	4a01                	li	s4,0
  if(pagetable)
    8000589a:	a011                	j	8000589e <exec+0x39e>
    8000589c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000589e:	e0843583          	ld	a1,-504(s0)
    800058a2:	855a                	mv	a0,s6
    800058a4:	ffffc097          	auipc	ra,0xffffc
    800058a8:	6c4080e7          	jalr	1732(ra) # 80001f68 <proc_freepagetable>
  return -1;
    800058ac:	557d                	li	a0,-1
  if(ip){
    800058ae:	000a1b63          	bnez	s4,800058c4 <exec+0x3c4>
    800058b2:	79be                	ld	s3,488(sp)
    800058b4:	7a1e                	ld	s4,480(sp)
    800058b6:	6afe                	ld	s5,472(sp)
    800058b8:	6b5e                	ld	s6,464(sp)
    800058ba:	6bbe                	ld	s7,456(sp)
    800058bc:	6c1e                	ld	s8,448(sp)
    800058be:	7cfa                	ld	s9,440(sp)
    800058c0:	7d5a                	ld	s10,432(sp)
    800058c2:	b1e1                	j	8000558a <exec+0x8a>
    800058c4:	79be                	ld	s3,488(sp)
    800058c6:	6afe                	ld	s5,472(sp)
    800058c8:	6b5e                	ld	s6,464(sp)
    800058ca:	6bbe                	ld	s7,456(sp)
    800058cc:	6c1e                	ld	s8,448(sp)
    800058ce:	7cfa                	ld	s9,440(sp)
    800058d0:	7d5a                	ld	s10,432(sp)
    800058d2:	b14d                	j	80005574 <exec+0x74>
    800058d4:	6b5e                	ld	s6,464(sp)
    800058d6:	b979                	j	80005574 <exec+0x74>
  sz = sz1;
    800058d8:	e0843983          	ld	s3,-504(s0)
    800058dc:	b591                	j	80005720 <exec+0x220>

00000000800058de <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800058de:	7179                	addi	sp,sp,-48
    800058e0:	f406                	sd	ra,40(sp)
    800058e2:	f022                	sd	s0,32(sp)
    800058e4:	ec26                	sd	s1,24(sp)
    800058e6:	e84a                	sd	s2,16(sp)
    800058e8:	1800                	addi	s0,sp,48
    800058ea:	892e                	mv	s2,a1
    800058ec:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800058ee:	fdc40593          	addi	a1,s0,-36
    800058f2:	ffffe097          	auipc	ra,0xffffe
    800058f6:	99e080e7          	jalr	-1634(ra) # 80003290 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800058fa:	fdc42703          	lw	a4,-36(s0)
    800058fe:	47bd                	li	a5,15
    80005900:	02e7eb63          	bltu	a5,a4,80005936 <argfd+0x58>
    80005904:	ffffc097          	auipc	ra,0xffffc
    80005908:	504080e7          	jalr	1284(ra) # 80001e08 <myproc>
    8000590c:	fdc42703          	lw	a4,-36(s0)
    80005910:	01a70793          	addi	a5,a4,26
    80005914:	078e                	slli	a5,a5,0x3
    80005916:	953e                	add	a0,a0,a5
    80005918:	611c                	ld	a5,0(a0)
    8000591a:	c385                	beqz	a5,8000593a <argfd+0x5c>
    return -1;
  if(pfd)
    8000591c:	00090463          	beqz	s2,80005924 <argfd+0x46>
    *pfd = fd;
    80005920:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005924:	4501                	li	a0,0
  if(pf)
    80005926:	c091                	beqz	s1,8000592a <argfd+0x4c>
    *pf = f;
    80005928:	e09c                	sd	a5,0(s1)
}
    8000592a:	70a2                	ld	ra,40(sp)
    8000592c:	7402                	ld	s0,32(sp)
    8000592e:	64e2                	ld	s1,24(sp)
    80005930:	6942                	ld	s2,16(sp)
    80005932:	6145                	addi	sp,sp,48
    80005934:	8082                	ret
    return -1;
    80005936:	557d                	li	a0,-1
    80005938:	bfcd                	j	8000592a <argfd+0x4c>
    8000593a:	557d                	li	a0,-1
    8000593c:	b7fd                	j	8000592a <argfd+0x4c>

000000008000593e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000593e:	1101                	addi	sp,sp,-32
    80005940:	ec06                	sd	ra,24(sp)
    80005942:	e822                	sd	s0,16(sp)
    80005944:	e426                	sd	s1,8(sp)
    80005946:	1000                	addi	s0,sp,32
    80005948:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000594a:	ffffc097          	auipc	ra,0xffffc
    8000594e:	4be080e7          	jalr	1214(ra) # 80001e08 <myproc>
    80005952:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005954:	0d050793          	addi	a5,a0,208
    80005958:	4501                	li	a0,0
    8000595a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000595c:	6398                	ld	a4,0(a5)
    8000595e:	cb19                	beqz	a4,80005974 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005960:	2505                	addiw	a0,a0,1
    80005962:	07a1                	addi	a5,a5,8
    80005964:	fed51ce3          	bne	a0,a3,8000595c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005968:	557d                	li	a0,-1
}
    8000596a:	60e2                	ld	ra,24(sp)
    8000596c:	6442                	ld	s0,16(sp)
    8000596e:	64a2                	ld	s1,8(sp)
    80005970:	6105                	addi	sp,sp,32
    80005972:	8082                	ret
      p->ofile[fd] = f;
    80005974:	01a50793          	addi	a5,a0,26
    80005978:	078e                	slli	a5,a5,0x3
    8000597a:	963e                	add	a2,a2,a5
    8000597c:	e204                	sd	s1,0(a2)
      return fd;
    8000597e:	b7f5                	j	8000596a <fdalloc+0x2c>

0000000080005980 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005980:	715d                	addi	sp,sp,-80
    80005982:	e486                	sd	ra,72(sp)
    80005984:	e0a2                	sd	s0,64(sp)
    80005986:	fc26                	sd	s1,56(sp)
    80005988:	f84a                	sd	s2,48(sp)
    8000598a:	f44e                	sd	s3,40(sp)
    8000598c:	ec56                	sd	s5,24(sp)
    8000598e:	e85a                	sd	s6,16(sp)
    80005990:	0880                	addi	s0,sp,80
    80005992:	8b2e                	mv	s6,a1
    80005994:	89b2                	mv	s3,a2
    80005996:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005998:	fb040593          	addi	a1,s0,-80
    8000599c:	fffff097          	auipc	ra,0xfffff
    800059a0:	de2080e7          	jalr	-542(ra) # 8000477e <nameiparent>
    800059a4:	84aa                	mv	s1,a0
    800059a6:	14050e63          	beqz	a0,80005b02 <create+0x182>
    return 0;

  ilock(dp);
    800059aa:	ffffe097          	auipc	ra,0xffffe
    800059ae:	5e8080e7          	jalr	1512(ra) # 80003f92 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800059b2:	4601                	li	a2,0
    800059b4:	fb040593          	addi	a1,s0,-80
    800059b8:	8526                	mv	a0,s1
    800059ba:	fffff097          	auipc	ra,0xfffff
    800059be:	ae4080e7          	jalr	-1308(ra) # 8000449e <dirlookup>
    800059c2:	8aaa                	mv	s5,a0
    800059c4:	c539                	beqz	a0,80005a12 <create+0x92>
    iunlockput(dp);
    800059c6:	8526                	mv	a0,s1
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	830080e7          	jalr	-2000(ra) # 800041f8 <iunlockput>
    ilock(ip);
    800059d0:	8556                	mv	a0,s5
    800059d2:	ffffe097          	auipc	ra,0xffffe
    800059d6:	5c0080e7          	jalr	1472(ra) # 80003f92 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800059da:	4789                	li	a5,2
    800059dc:	02fb1463          	bne	s6,a5,80005a04 <create+0x84>
    800059e0:	044ad783          	lhu	a5,68(s5)
    800059e4:	37f9                	addiw	a5,a5,-2
    800059e6:	17c2                	slli	a5,a5,0x30
    800059e8:	93c1                	srli	a5,a5,0x30
    800059ea:	4705                	li	a4,1
    800059ec:	00f76c63          	bltu	a4,a5,80005a04 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800059f0:	8556                	mv	a0,s5
    800059f2:	60a6                	ld	ra,72(sp)
    800059f4:	6406                	ld	s0,64(sp)
    800059f6:	74e2                	ld	s1,56(sp)
    800059f8:	7942                	ld	s2,48(sp)
    800059fa:	79a2                	ld	s3,40(sp)
    800059fc:	6ae2                	ld	s5,24(sp)
    800059fe:	6b42                	ld	s6,16(sp)
    80005a00:	6161                	addi	sp,sp,80
    80005a02:	8082                	ret
    iunlockput(ip);
    80005a04:	8556                	mv	a0,s5
    80005a06:	ffffe097          	auipc	ra,0xffffe
    80005a0a:	7f2080e7          	jalr	2034(ra) # 800041f8 <iunlockput>
    return 0;
    80005a0e:	4a81                	li	s5,0
    80005a10:	b7c5                	j	800059f0 <create+0x70>
    80005a12:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005a14:	85da                	mv	a1,s6
    80005a16:	4088                	lw	a0,0(s1)
    80005a18:	ffffe097          	auipc	ra,0xffffe
    80005a1c:	3d6080e7          	jalr	982(ra) # 80003dee <ialloc>
    80005a20:	8a2a                	mv	s4,a0
    80005a22:	c531                	beqz	a0,80005a6e <create+0xee>
  ilock(ip);
    80005a24:	ffffe097          	auipc	ra,0xffffe
    80005a28:	56e080e7          	jalr	1390(ra) # 80003f92 <ilock>
  ip->major = major;
    80005a2c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005a30:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005a34:	4905                	li	s2,1
    80005a36:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005a3a:	8552                	mv	a0,s4
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	48a080e7          	jalr	1162(ra) # 80003ec6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005a44:	032b0d63          	beq	s6,s2,80005a7e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a48:	004a2603          	lw	a2,4(s4)
    80005a4c:	fb040593          	addi	a1,s0,-80
    80005a50:	8526                	mv	a0,s1
    80005a52:	fffff097          	auipc	ra,0xfffff
    80005a56:	c5c080e7          	jalr	-932(ra) # 800046ae <dirlink>
    80005a5a:	08054163          	bltz	a0,80005adc <create+0x15c>
  iunlockput(dp);
    80005a5e:	8526                	mv	a0,s1
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	798080e7          	jalr	1944(ra) # 800041f8 <iunlockput>
  return ip;
    80005a68:	8ad2                	mv	s5,s4
    80005a6a:	7a02                	ld	s4,32(sp)
    80005a6c:	b751                	j	800059f0 <create+0x70>
    iunlockput(dp);
    80005a6e:	8526                	mv	a0,s1
    80005a70:	ffffe097          	auipc	ra,0xffffe
    80005a74:	788080e7          	jalr	1928(ra) # 800041f8 <iunlockput>
    return 0;
    80005a78:	8ad2                	mv	s5,s4
    80005a7a:	7a02                	ld	s4,32(sp)
    80005a7c:	bf95                	j	800059f0 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005a7e:	004a2603          	lw	a2,4(s4)
    80005a82:	00003597          	auipc	a1,0x3
    80005a86:	c9658593          	addi	a1,a1,-874 # 80008718 <__func__.1+0x710>
    80005a8a:	8552                	mv	a0,s4
    80005a8c:	fffff097          	auipc	ra,0xfffff
    80005a90:	c22080e7          	jalr	-990(ra) # 800046ae <dirlink>
    80005a94:	04054463          	bltz	a0,80005adc <create+0x15c>
    80005a98:	40d0                	lw	a2,4(s1)
    80005a9a:	00003597          	auipc	a1,0x3
    80005a9e:	c8658593          	addi	a1,a1,-890 # 80008720 <__func__.1+0x718>
    80005aa2:	8552                	mv	a0,s4
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	c0a080e7          	jalr	-1014(ra) # 800046ae <dirlink>
    80005aac:	02054863          	bltz	a0,80005adc <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005ab0:	004a2603          	lw	a2,4(s4)
    80005ab4:	fb040593          	addi	a1,s0,-80
    80005ab8:	8526                	mv	a0,s1
    80005aba:	fffff097          	auipc	ra,0xfffff
    80005abe:	bf4080e7          	jalr	-1036(ra) # 800046ae <dirlink>
    80005ac2:	00054d63          	bltz	a0,80005adc <create+0x15c>
    dp->nlink++;  // for ".."
    80005ac6:	04a4d783          	lhu	a5,74(s1)
    80005aca:	2785                	addiw	a5,a5,1
    80005acc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005ad0:	8526                	mv	a0,s1
    80005ad2:	ffffe097          	auipc	ra,0xffffe
    80005ad6:	3f4080e7          	jalr	1012(ra) # 80003ec6 <iupdate>
    80005ada:	b751                	j	80005a5e <create+0xde>
  ip->nlink = 0;
    80005adc:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005ae0:	8552                	mv	a0,s4
    80005ae2:	ffffe097          	auipc	ra,0xffffe
    80005ae6:	3e4080e7          	jalr	996(ra) # 80003ec6 <iupdate>
  iunlockput(ip);
    80005aea:	8552                	mv	a0,s4
    80005aec:	ffffe097          	auipc	ra,0xffffe
    80005af0:	70c080e7          	jalr	1804(ra) # 800041f8 <iunlockput>
  iunlockput(dp);
    80005af4:	8526                	mv	a0,s1
    80005af6:	ffffe097          	auipc	ra,0xffffe
    80005afa:	702080e7          	jalr	1794(ra) # 800041f8 <iunlockput>
  return 0;
    80005afe:	7a02                	ld	s4,32(sp)
    80005b00:	bdc5                	j	800059f0 <create+0x70>
    return 0;
    80005b02:	8aaa                	mv	s5,a0
    80005b04:	b5f5                	j	800059f0 <create+0x70>

0000000080005b06 <sys_dup>:
{
    80005b06:	7179                	addi	sp,sp,-48
    80005b08:	f406                	sd	ra,40(sp)
    80005b0a:	f022                	sd	s0,32(sp)
    80005b0c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005b0e:	fd840613          	addi	a2,s0,-40
    80005b12:	4581                	li	a1,0
    80005b14:	4501                	li	a0,0
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	dc8080e7          	jalr	-568(ra) # 800058de <argfd>
    return -1;
    80005b1e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005b20:	02054763          	bltz	a0,80005b4e <sys_dup+0x48>
    80005b24:	ec26                	sd	s1,24(sp)
    80005b26:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005b28:	fd843903          	ld	s2,-40(s0)
    80005b2c:	854a                	mv	a0,s2
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	e10080e7          	jalr	-496(ra) # 8000593e <fdalloc>
    80005b36:	84aa                	mv	s1,a0
    return -1;
    80005b38:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005b3a:	00054f63          	bltz	a0,80005b58 <sys_dup+0x52>
  filedup(f);
    80005b3e:	854a                	mv	a0,s2
    80005b40:	fffff097          	auipc	ra,0xfffff
    80005b44:	298080e7          	jalr	664(ra) # 80004dd8 <filedup>
  return fd;
    80005b48:	87a6                	mv	a5,s1
    80005b4a:	64e2                	ld	s1,24(sp)
    80005b4c:	6942                	ld	s2,16(sp)
}
    80005b4e:	853e                	mv	a0,a5
    80005b50:	70a2                	ld	ra,40(sp)
    80005b52:	7402                	ld	s0,32(sp)
    80005b54:	6145                	addi	sp,sp,48
    80005b56:	8082                	ret
    80005b58:	64e2                	ld	s1,24(sp)
    80005b5a:	6942                	ld	s2,16(sp)
    80005b5c:	bfcd                	j	80005b4e <sys_dup+0x48>

0000000080005b5e <sys_read>:
{
    80005b5e:	7179                	addi	sp,sp,-48
    80005b60:	f406                	sd	ra,40(sp)
    80005b62:	f022                	sd	s0,32(sp)
    80005b64:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005b66:	fd840593          	addi	a1,s0,-40
    80005b6a:	4505                	li	a0,1
    80005b6c:	ffffd097          	auipc	ra,0xffffd
    80005b70:	744080e7          	jalr	1860(ra) # 800032b0 <argaddr>
  argint(2, &n);
    80005b74:	fe440593          	addi	a1,s0,-28
    80005b78:	4509                	li	a0,2
    80005b7a:	ffffd097          	auipc	ra,0xffffd
    80005b7e:	716080e7          	jalr	1814(ra) # 80003290 <argint>
  if(argfd(0, 0, &f) < 0)
    80005b82:	fe840613          	addi	a2,s0,-24
    80005b86:	4581                	li	a1,0
    80005b88:	4501                	li	a0,0
    80005b8a:	00000097          	auipc	ra,0x0
    80005b8e:	d54080e7          	jalr	-684(ra) # 800058de <argfd>
    80005b92:	87aa                	mv	a5,a0
    return -1;
    80005b94:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b96:	0007cc63          	bltz	a5,80005bae <sys_read+0x50>
  return fileread(f, p, n);
    80005b9a:	fe442603          	lw	a2,-28(s0)
    80005b9e:	fd843583          	ld	a1,-40(s0)
    80005ba2:	fe843503          	ld	a0,-24(s0)
    80005ba6:	fffff097          	auipc	ra,0xfffff
    80005baa:	3d8080e7          	jalr	984(ra) # 80004f7e <fileread>
}
    80005bae:	70a2                	ld	ra,40(sp)
    80005bb0:	7402                	ld	s0,32(sp)
    80005bb2:	6145                	addi	sp,sp,48
    80005bb4:	8082                	ret

0000000080005bb6 <sys_write>:
{
    80005bb6:	7179                	addi	sp,sp,-48
    80005bb8:	f406                	sd	ra,40(sp)
    80005bba:	f022                	sd	s0,32(sp)
    80005bbc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005bbe:	fd840593          	addi	a1,s0,-40
    80005bc2:	4505                	li	a0,1
    80005bc4:	ffffd097          	auipc	ra,0xffffd
    80005bc8:	6ec080e7          	jalr	1772(ra) # 800032b0 <argaddr>
  argint(2, &n);
    80005bcc:	fe440593          	addi	a1,s0,-28
    80005bd0:	4509                	li	a0,2
    80005bd2:	ffffd097          	auipc	ra,0xffffd
    80005bd6:	6be080e7          	jalr	1726(ra) # 80003290 <argint>
  if(argfd(0, 0, &f) < 0)
    80005bda:	fe840613          	addi	a2,s0,-24
    80005bde:	4581                	li	a1,0
    80005be0:	4501                	li	a0,0
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	cfc080e7          	jalr	-772(ra) # 800058de <argfd>
    80005bea:	87aa                	mv	a5,a0
    return -1;
    80005bec:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005bee:	0007cc63          	bltz	a5,80005c06 <sys_write+0x50>
  return filewrite(f, p, n);
    80005bf2:	fe442603          	lw	a2,-28(s0)
    80005bf6:	fd843583          	ld	a1,-40(s0)
    80005bfa:	fe843503          	ld	a0,-24(s0)
    80005bfe:	fffff097          	auipc	ra,0xfffff
    80005c02:	452080e7          	jalr	1106(ra) # 80005050 <filewrite>
}
    80005c06:	70a2                	ld	ra,40(sp)
    80005c08:	7402                	ld	s0,32(sp)
    80005c0a:	6145                	addi	sp,sp,48
    80005c0c:	8082                	ret

0000000080005c0e <sys_close>:
{
    80005c0e:	1101                	addi	sp,sp,-32
    80005c10:	ec06                	sd	ra,24(sp)
    80005c12:	e822                	sd	s0,16(sp)
    80005c14:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005c16:	fe040613          	addi	a2,s0,-32
    80005c1a:	fec40593          	addi	a1,s0,-20
    80005c1e:	4501                	li	a0,0
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	cbe080e7          	jalr	-834(ra) # 800058de <argfd>
    return -1;
    80005c28:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005c2a:	02054463          	bltz	a0,80005c52 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005c2e:	ffffc097          	auipc	ra,0xffffc
    80005c32:	1da080e7          	jalr	474(ra) # 80001e08 <myproc>
    80005c36:	fec42783          	lw	a5,-20(s0)
    80005c3a:	07e9                	addi	a5,a5,26
    80005c3c:	078e                	slli	a5,a5,0x3
    80005c3e:	953e                	add	a0,a0,a5
    80005c40:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005c44:	fe043503          	ld	a0,-32(s0)
    80005c48:	fffff097          	auipc	ra,0xfffff
    80005c4c:	1e2080e7          	jalr	482(ra) # 80004e2a <fileclose>
  return 0;
    80005c50:	4781                	li	a5,0
}
    80005c52:	853e                	mv	a0,a5
    80005c54:	60e2                	ld	ra,24(sp)
    80005c56:	6442                	ld	s0,16(sp)
    80005c58:	6105                	addi	sp,sp,32
    80005c5a:	8082                	ret

0000000080005c5c <sys_fstat>:
{
    80005c5c:	1101                	addi	sp,sp,-32
    80005c5e:	ec06                	sd	ra,24(sp)
    80005c60:	e822                	sd	s0,16(sp)
    80005c62:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005c64:	fe040593          	addi	a1,s0,-32
    80005c68:	4505                	li	a0,1
    80005c6a:	ffffd097          	auipc	ra,0xffffd
    80005c6e:	646080e7          	jalr	1606(ra) # 800032b0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005c72:	fe840613          	addi	a2,s0,-24
    80005c76:	4581                	li	a1,0
    80005c78:	4501                	li	a0,0
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	c64080e7          	jalr	-924(ra) # 800058de <argfd>
    80005c82:	87aa                	mv	a5,a0
    return -1;
    80005c84:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c86:	0007ca63          	bltz	a5,80005c9a <sys_fstat+0x3e>
  return filestat(f, st);
    80005c8a:	fe043583          	ld	a1,-32(s0)
    80005c8e:	fe843503          	ld	a0,-24(s0)
    80005c92:	fffff097          	auipc	ra,0xfffff
    80005c96:	27a080e7          	jalr	634(ra) # 80004f0c <filestat>
}
    80005c9a:	60e2                	ld	ra,24(sp)
    80005c9c:	6442                	ld	s0,16(sp)
    80005c9e:	6105                	addi	sp,sp,32
    80005ca0:	8082                	ret

0000000080005ca2 <sys_link>:
{
    80005ca2:	7169                	addi	sp,sp,-304
    80005ca4:	f606                	sd	ra,296(sp)
    80005ca6:	f222                	sd	s0,288(sp)
    80005ca8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005caa:	08000613          	li	a2,128
    80005cae:	ed040593          	addi	a1,s0,-304
    80005cb2:	4501                	li	a0,0
    80005cb4:	ffffd097          	auipc	ra,0xffffd
    80005cb8:	61c080e7          	jalr	1564(ra) # 800032d0 <argstr>
    return -1;
    80005cbc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005cbe:	12054663          	bltz	a0,80005dea <sys_link+0x148>
    80005cc2:	08000613          	li	a2,128
    80005cc6:	f5040593          	addi	a1,s0,-176
    80005cca:	4505                	li	a0,1
    80005ccc:	ffffd097          	auipc	ra,0xffffd
    80005cd0:	604080e7          	jalr	1540(ra) # 800032d0 <argstr>
    return -1;
    80005cd4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005cd6:	10054a63          	bltz	a0,80005dea <sys_link+0x148>
    80005cda:	ee26                	sd	s1,280(sp)
  begin_op();
    80005cdc:	fffff097          	auipc	ra,0xfffff
    80005ce0:	c84080e7          	jalr	-892(ra) # 80004960 <begin_op>
  if((ip = namei(old)) == 0){
    80005ce4:	ed040513          	addi	a0,s0,-304
    80005ce8:	fffff097          	auipc	ra,0xfffff
    80005cec:	a78080e7          	jalr	-1416(ra) # 80004760 <namei>
    80005cf0:	84aa                	mv	s1,a0
    80005cf2:	c949                	beqz	a0,80005d84 <sys_link+0xe2>
  ilock(ip);
    80005cf4:	ffffe097          	auipc	ra,0xffffe
    80005cf8:	29e080e7          	jalr	670(ra) # 80003f92 <ilock>
  if(ip->type == T_DIR){
    80005cfc:	04449703          	lh	a4,68(s1)
    80005d00:	4785                	li	a5,1
    80005d02:	08f70863          	beq	a4,a5,80005d92 <sys_link+0xf0>
    80005d06:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005d08:	04a4d783          	lhu	a5,74(s1)
    80005d0c:	2785                	addiw	a5,a5,1
    80005d0e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d12:	8526                	mv	a0,s1
    80005d14:	ffffe097          	auipc	ra,0xffffe
    80005d18:	1b2080e7          	jalr	434(ra) # 80003ec6 <iupdate>
  iunlock(ip);
    80005d1c:	8526                	mv	a0,s1
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	33a080e7          	jalr	826(ra) # 80004058 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005d26:	fd040593          	addi	a1,s0,-48
    80005d2a:	f5040513          	addi	a0,s0,-176
    80005d2e:	fffff097          	auipc	ra,0xfffff
    80005d32:	a50080e7          	jalr	-1456(ra) # 8000477e <nameiparent>
    80005d36:	892a                	mv	s2,a0
    80005d38:	cd35                	beqz	a0,80005db4 <sys_link+0x112>
  ilock(dp);
    80005d3a:	ffffe097          	auipc	ra,0xffffe
    80005d3e:	258080e7          	jalr	600(ra) # 80003f92 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005d42:	00092703          	lw	a4,0(s2)
    80005d46:	409c                	lw	a5,0(s1)
    80005d48:	06f71163          	bne	a4,a5,80005daa <sys_link+0x108>
    80005d4c:	40d0                	lw	a2,4(s1)
    80005d4e:	fd040593          	addi	a1,s0,-48
    80005d52:	854a                	mv	a0,s2
    80005d54:	fffff097          	auipc	ra,0xfffff
    80005d58:	95a080e7          	jalr	-1702(ra) # 800046ae <dirlink>
    80005d5c:	04054763          	bltz	a0,80005daa <sys_link+0x108>
  iunlockput(dp);
    80005d60:	854a                	mv	a0,s2
    80005d62:	ffffe097          	auipc	ra,0xffffe
    80005d66:	496080e7          	jalr	1174(ra) # 800041f8 <iunlockput>
  iput(ip);
    80005d6a:	8526                	mv	a0,s1
    80005d6c:	ffffe097          	auipc	ra,0xffffe
    80005d70:	3e4080e7          	jalr	996(ra) # 80004150 <iput>
  end_op();
    80005d74:	fffff097          	auipc	ra,0xfffff
    80005d78:	c66080e7          	jalr	-922(ra) # 800049da <end_op>
  return 0;
    80005d7c:	4781                	li	a5,0
    80005d7e:	64f2                	ld	s1,280(sp)
    80005d80:	6952                	ld	s2,272(sp)
    80005d82:	a0a5                	j	80005dea <sys_link+0x148>
    end_op();
    80005d84:	fffff097          	auipc	ra,0xfffff
    80005d88:	c56080e7          	jalr	-938(ra) # 800049da <end_op>
    return -1;
    80005d8c:	57fd                	li	a5,-1
    80005d8e:	64f2                	ld	s1,280(sp)
    80005d90:	a8a9                	j	80005dea <sys_link+0x148>
    iunlockput(ip);
    80005d92:	8526                	mv	a0,s1
    80005d94:	ffffe097          	auipc	ra,0xffffe
    80005d98:	464080e7          	jalr	1124(ra) # 800041f8 <iunlockput>
    end_op();
    80005d9c:	fffff097          	auipc	ra,0xfffff
    80005da0:	c3e080e7          	jalr	-962(ra) # 800049da <end_op>
    return -1;
    80005da4:	57fd                	li	a5,-1
    80005da6:	64f2                	ld	s1,280(sp)
    80005da8:	a089                	j	80005dea <sys_link+0x148>
    iunlockput(dp);
    80005daa:	854a                	mv	a0,s2
    80005dac:	ffffe097          	auipc	ra,0xffffe
    80005db0:	44c080e7          	jalr	1100(ra) # 800041f8 <iunlockput>
  ilock(ip);
    80005db4:	8526                	mv	a0,s1
    80005db6:	ffffe097          	auipc	ra,0xffffe
    80005dba:	1dc080e7          	jalr	476(ra) # 80003f92 <ilock>
  ip->nlink--;
    80005dbe:	04a4d783          	lhu	a5,74(s1)
    80005dc2:	37fd                	addiw	a5,a5,-1
    80005dc4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005dc8:	8526                	mv	a0,s1
    80005dca:	ffffe097          	auipc	ra,0xffffe
    80005dce:	0fc080e7          	jalr	252(ra) # 80003ec6 <iupdate>
  iunlockput(ip);
    80005dd2:	8526                	mv	a0,s1
    80005dd4:	ffffe097          	auipc	ra,0xffffe
    80005dd8:	424080e7          	jalr	1060(ra) # 800041f8 <iunlockput>
  end_op();
    80005ddc:	fffff097          	auipc	ra,0xfffff
    80005de0:	bfe080e7          	jalr	-1026(ra) # 800049da <end_op>
  return -1;
    80005de4:	57fd                	li	a5,-1
    80005de6:	64f2                	ld	s1,280(sp)
    80005de8:	6952                	ld	s2,272(sp)
}
    80005dea:	853e                	mv	a0,a5
    80005dec:	70b2                	ld	ra,296(sp)
    80005dee:	7412                	ld	s0,288(sp)
    80005df0:	6155                	addi	sp,sp,304
    80005df2:	8082                	ret

0000000080005df4 <sys_unlink>:
{
    80005df4:	7151                	addi	sp,sp,-240
    80005df6:	f586                	sd	ra,232(sp)
    80005df8:	f1a2                	sd	s0,224(sp)
    80005dfa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005dfc:	08000613          	li	a2,128
    80005e00:	f3040593          	addi	a1,s0,-208
    80005e04:	4501                	li	a0,0
    80005e06:	ffffd097          	auipc	ra,0xffffd
    80005e0a:	4ca080e7          	jalr	1226(ra) # 800032d0 <argstr>
    80005e0e:	1a054a63          	bltz	a0,80005fc2 <sys_unlink+0x1ce>
    80005e12:	eda6                	sd	s1,216(sp)
  begin_op();
    80005e14:	fffff097          	auipc	ra,0xfffff
    80005e18:	b4c080e7          	jalr	-1204(ra) # 80004960 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005e1c:	fb040593          	addi	a1,s0,-80
    80005e20:	f3040513          	addi	a0,s0,-208
    80005e24:	fffff097          	auipc	ra,0xfffff
    80005e28:	95a080e7          	jalr	-1702(ra) # 8000477e <nameiparent>
    80005e2c:	84aa                	mv	s1,a0
    80005e2e:	cd71                	beqz	a0,80005f0a <sys_unlink+0x116>
  ilock(dp);
    80005e30:	ffffe097          	auipc	ra,0xffffe
    80005e34:	162080e7          	jalr	354(ra) # 80003f92 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005e38:	00003597          	auipc	a1,0x3
    80005e3c:	8e058593          	addi	a1,a1,-1824 # 80008718 <__func__.1+0x710>
    80005e40:	fb040513          	addi	a0,s0,-80
    80005e44:	ffffe097          	auipc	ra,0xffffe
    80005e48:	640080e7          	jalr	1600(ra) # 80004484 <namecmp>
    80005e4c:	14050c63          	beqz	a0,80005fa4 <sys_unlink+0x1b0>
    80005e50:	00003597          	auipc	a1,0x3
    80005e54:	8d058593          	addi	a1,a1,-1840 # 80008720 <__func__.1+0x718>
    80005e58:	fb040513          	addi	a0,s0,-80
    80005e5c:	ffffe097          	auipc	ra,0xffffe
    80005e60:	628080e7          	jalr	1576(ra) # 80004484 <namecmp>
    80005e64:	14050063          	beqz	a0,80005fa4 <sys_unlink+0x1b0>
    80005e68:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005e6a:	f2c40613          	addi	a2,s0,-212
    80005e6e:	fb040593          	addi	a1,s0,-80
    80005e72:	8526                	mv	a0,s1
    80005e74:	ffffe097          	auipc	ra,0xffffe
    80005e78:	62a080e7          	jalr	1578(ra) # 8000449e <dirlookup>
    80005e7c:	892a                	mv	s2,a0
    80005e7e:	12050263          	beqz	a0,80005fa2 <sys_unlink+0x1ae>
  ilock(ip);
    80005e82:	ffffe097          	auipc	ra,0xffffe
    80005e86:	110080e7          	jalr	272(ra) # 80003f92 <ilock>
  if(ip->nlink < 1)
    80005e8a:	04a91783          	lh	a5,74(s2)
    80005e8e:	08f05563          	blez	a5,80005f18 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005e92:	04491703          	lh	a4,68(s2)
    80005e96:	4785                	li	a5,1
    80005e98:	08f70963          	beq	a4,a5,80005f2a <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005e9c:	4641                	li	a2,16
    80005e9e:	4581                	li	a1,0
    80005ea0:	fc040513          	addi	a0,s0,-64
    80005ea4:	ffffb097          	auipc	ra,0xffffb
    80005ea8:	15e080e7          	jalr	350(ra) # 80001002 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005eac:	4741                	li	a4,16
    80005eae:	f2c42683          	lw	a3,-212(s0)
    80005eb2:	fc040613          	addi	a2,s0,-64
    80005eb6:	4581                	li	a1,0
    80005eb8:	8526                	mv	a0,s1
    80005eba:	ffffe097          	auipc	ra,0xffffe
    80005ebe:	4a0080e7          	jalr	1184(ra) # 8000435a <writei>
    80005ec2:	47c1                	li	a5,16
    80005ec4:	0af51b63          	bne	a0,a5,80005f7a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005ec8:	04491703          	lh	a4,68(s2)
    80005ecc:	4785                	li	a5,1
    80005ece:	0af70f63          	beq	a4,a5,80005f8c <sys_unlink+0x198>
  iunlockput(dp);
    80005ed2:	8526                	mv	a0,s1
    80005ed4:	ffffe097          	auipc	ra,0xffffe
    80005ed8:	324080e7          	jalr	804(ra) # 800041f8 <iunlockput>
  ip->nlink--;
    80005edc:	04a95783          	lhu	a5,74(s2)
    80005ee0:	37fd                	addiw	a5,a5,-1
    80005ee2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005ee6:	854a                	mv	a0,s2
    80005ee8:	ffffe097          	auipc	ra,0xffffe
    80005eec:	fde080e7          	jalr	-34(ra) # 80003ec6 <iupdate>
  iunlockput(ip);
    80005ef0:	854a                	mv	a0,s2
    80005ef2:	ffffe097          	auipc	ra,0xffffe
    80005ef6:	306080e7          	jalr	774(ra) # 800041f8 <iunlockput>
  end_op();
    80005efa:	fffff097          	auipc	ra,0xfffff
    80005efe:	ae0080e7          	jalr	-1312(ra) # 800049da <end_op>
  return 0;
    80005f02:	4501                	li	a0,0
    80005f04:	64ee                	ld	s1,216(sp)
    80005f06:	694e                	ld	s2,208(sp)
    80005f08:	a84d                	j	80005fba <sys_unlink+0x1c6>
    end_op();
    80005f0a:	fffff097          	auipc	ra,0xfffff
    80005f0e:	ad0080e7          	jalr	-1328(ra) # 800049da <end_op>
    return -1;
    80005f12:	557d                	li	a0,-1
    80005f14:	64ee                	ld	s1,216(sp)
    80005f16:	a055                	j	80005fba <sys_unlink+0x1c6>
    80005f18:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005f1a:	00003517          	auipc	a0,0x3
    80005f1e:	80e50513          	addi	a0,a0,-2034 # 80008728 <__func__.1+0x720>
    80005f22:	ffffa097          	auipc	ra,0xffffa
    80005f26:	63e080e7          	jalr	1598(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f2a:	04c92703          	lw	a4,76(s2)
    80005f2e:	02000793          	li	a5,32
    80005f32:	f6e7f5e3          	bgeu	a5,a4,80005e9c <sys_unlink+0xa8>
    80005f36:	e5ce                	sd	s3,200(sp)
    80005f38:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f3c:	4741                	li	a4,16
    80005f3e:	86ce                	mv	a3,s3
    80005f40:	f1840613          	addi	a2,s0,-232
    80005f44:	4581                	li	a1,0
    80005f46:	854a                	mv	a0,s2
    80005f48:	ffffe097          	auipc	ra,0xffffe
    80005f4c:	302080e7          	jalr	770(ra) # 8000424a <readi>
    80005f50:	47c1                	li	a5,16
    80005f52:	00f51c63          	bne	a0,a5,80005f6a <sys_unlink+0x176>
    if(de.inum != 0)
    80005f56:	f1845783          	lhu	a5,-232(s0)
    80005f5a:	e7b5                	bnez	a5,80005fc6 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f5c:	29c1                	addiw	s3,s3,16
    80005f5e:	04c92783          	lw	a5,76(s2)
    80005f62:	fcf9ede3          	bltu	s3,a5,80005f3c <sys_unlink+0x148>
    80005f66:	69ae                	ld	s3,200(sp)
    80005f68:	bf15                	j	80005e9c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005f6a:	00002517          	auipc	a0,0x2
    80005f6e:	7d650513          	addi	a0,a0,2006 # 80008740 <__func__.1+0x738>
    80005f72:	ffffa097          	auipc	ra,0xffffa
    80005f76:	5ee080e7          	jalr	1518(ra) # 80000560 <panic>
    80005f7a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005f7c:	00002517          	auipc	a0,0x2
    80005f80:	7dc50513          	addi	a0,a0,2012 # 80008758 <__func__.1+0x750>
    80005f84:	ffffa097          	auipc	ra,0xffffa
    80005f88:	5dc080e7          	jalr	1500(ra) # 80000560 <panic>
    dp->nlink--;
    80005f8c:	04a4d783          	lhu	a5,74(s1)
    80005f90:	37fd                	addiw	a5,a5,-1
    80005f92:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005f96:	8526                	mv	a0,s1
    80005f98:	ffffe097          	auipc	ra,0xffffe
    80005f9c:	f2e080e7          	jalr	-210(ra) # 80003ec6 <iupdate>
    80005fa0:	bf0d                	j	80005ed2 <sys_unlink+0xde>
    80005fa2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005fa4:	8526                	mv	a0,s1
    80005fa6:	ffffe097          	auipc	ra,0xffffe
    80005faa:	252080e7          	jalr	594(ra) # 800041f8 <iunlockput>
  end_op();
    80005fae:	fffff097          	auipc	ra,0xfffff
    80005fb2:	a2c080e7          	jalr	-1492(ra) # 800049da <end_op>
  return -1;
    80005fb6:	557d                	li	a0,-1
    80005fb8:	64ee                	ld	s1,216(sp)
}
    80005fba:	70ae                	ld	ra,232(sp)
    80005fbc:	740e                	ld	s0,224(sp)
    80005fbe:	616d                	addi	sp,sp,240
    80005fc0:	8082                	ret
    return -1;
    80005fc2:	557d                	li	a0,-1
    80005fc4:	bfdd                	j	80005fba <sys_unlink+0x1c6>
    iunlockput(ip);
    80005fc6:	854a                	mv	a0,s2
    80005fc8:	ffffe097          	auipc	ra,0xffffe
    80005fcc:	230080e7          	jalr	560(ra) # 800041f8 <iunlockput>
    goto bad;
    80005fd0:	694e                	ld	s2,208(sp)
    80005fd2:	69ae                	ld	s3,200(sp)
    80005fd4:	bfc1                	j	80005fa4 <sys_unlink+0x1b0>

0000000080005fd6 <sys_open>:

uint64
sys_open(void)
{
    80005fd6:	7131                	addi	sp,sp,-192
    80005fd8:	fd06                	sd	ra,184(sp)
    80005fda:	f922                	sd	s0,176(sp)
    80005fdc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005fde:	f4c40593          	addi	a1,s0,-180
    80005fe2:	4505                	li	a0,1
    80005fe4:	ffffd097          	auipc	ra,0xffffd
    80005fe8:	2ac080e7          	jalr	684(ra) # 80003290 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005fec:	08000613          	li	a2,128
    80005ff0:	f5040593          	addi	a1,s0,-176
    80005ff4:	4501                	li	a0,0
    80005ff6:	ffffd097          	auipc	ra,0xffffd
    80005ffa:	2da080e7          	jalr	730(ra) # 800032d0 <argstr>
    80005ffe:	87aa                	mv	a5,a0
    return -1;
    80006000:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006002:	0a07ce63          	bltz	a5,800060be <sys_open+0xe8>
    80006006:	f526                	sd	s1,168(sp)

  begin_op();
    80006008:	fffff097          	auipc	ra,0xfffff
    8000600c:	958080e7          	jalr	-1704(ra) # 80004960 <begin_op>

  if(omode & O_CREATE){
    80006010:	f4c42783          	lw	a5,-180(s0)
    80006014:	2007f793          	andi	a5,a5,512
    80006018:	cfd5                	beqz	a5,800060d4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    8000601a:	4681                	li	a3,0
    8000601c:	4601                	li	a2,0
    8000601e:	4589                	li	a1,2
    80006020:	f5040513          	addi	a0,s0,-176
    80006024:	00000097          	auipc	ra,0x0
    80006028:	95c080e7          	jalr	-1700(ra) # 80005980 <create>
    8000602c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000602e:	cd41                	beqz	a0,800060c6 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006030:	04449703          	lh	a4,68(s1)
    80006034:	478d                	li	a5,3
    80006036:	00f71763          	bne	a4,a5,80006044 <sys_open+0x6e>
    8000603a:	0464d703          	lhu	a4,70(s1)
    8000603e:	47a5                	li	a5,9
    80006040:	0ee7e163          	bltu	a5,a4,80006122 <sys_open+0x14c>
    80006044:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006046:	fffff097          	auipc	ra,0xfffff
    8000604a:	d28080e7          	jalr	-728(ra) # 80004d6e <filealloc>
    8000604e:	892a                	mv	s2,a0
    80006050:	c97d                	beqz	a0,80006146 <sys_open+0x170>
    80006052:	ed4e                	sd	s3,152(sp)
    80006054:	00000097          	auipc	ra,0x0
    80006058:	8ea080e7          	jalr	-1814(ra) # 8000593e <fdalloc>
    8000605c:	89aa                	mv	s3,a0
    8000605e:	0c054e63          	bltz	a0,8000613a <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006062:	04449703          	lh	a4,68(s1)
    80006066:	478d                	li	a5,3
    80006068:	0ef70c63          	beq	a4,a5,80006160 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000606c:	4789                	li	a5,2
    8000606e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006072:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006076:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000607a:	f4c42783          	lw	a5,-180(s0)
    8000607e:	0017c713          	xori	a4,a5,1
    80006082:	8b05                	andi	a4,a4,1
    80006084:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006088:	0037f713          	andi	a4,a5,3
    8000608c:	00e03733          	snez	a4,a4
    80006090:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006094:	4007f793          	andi	a5,a5,1024
    80006098:	c791                	beqz	a5,800060a4 <sys_open+0xce>
    8000609a:	04449703          	lh	a4,68(s1)
    8000609e:	4789                	li	a5,2
    800060a0:	0cf70763          	beq	a4,a5,8000616e <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    800060a4:	8526                	mv	a0,s1
    800060a6:	ffffe097          	auipc	ra,0xffffe
    800060aa:	fb2080e7          	jalr	-78(ra) # 80004058 <iunlock>
  end_op();
    800060ae:	fffff097          	auipc	ra,0xfffff
    800060b2:	92c080e7          	jalr	-1748(ra) # 800049da <end_op>

  return fd;
    800060b6:	854e                	mv	a0,s3
    800060b8:	74aa                	ld	s1,168(sp)
    800060ba:	790a                	ld	s2,160(sp)
    800060bc:	69ea                	ld	s3,152(sp)
}
    800060be:	70ea                	ld	ra,184(sp)
    800060c0:	744a                	ld	s0,176(sp)
    800060c2:	6129                	addi	sp,sp,192
    800060c4:	8082                	ret
      end_op();
    800060c6:	fffff097          	auipc	ra,0xfffff
    800060ca:	914080e7          	jalr	-1772(ra) # 800049da <end_op>
      return -1;
    800060ce:	557d                	li	a0,-1
    800060d0:	74aa                	ld	s1,168(sp)
    800060d2:	b7f5                	j	800060be <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    800060d4:	f5040513          	addi	a0,s0,-176
    800060d8:	ffffe097          	auipc	ra,0xffffe
    800060dc:	688080e7          	jalr	1672(ra) # 80004760 <namei>
    800060e0:	84aa                	mv	s1,a0
    800060e2:	c90d                	beqz	a0,80006114 <sys_open+0x13e>
    ilock(ip);
    800060e4:	ffffe097          	auipc	ra,0xffffe
    800060e8:	eae080e7          	jalr	-338(ra) # 80003f92 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800060ec:	04449703          	lh	a4,68(s1)
    800060f0:	4785                	li	a5,1
    800060f2:	f2f71fe3          	bne	a4,a5,80006030 <sys_open+0x5a>
    800060f6:	f4c42783          	lw	a5,-180(s0)
    800060fa:	d7a9                	beqz	a5,80006044 <sys_open+0x6e>
      iunlockput(ip);
    800060fc:	8526                	mv	a0,s1
    800060fe:	ffffe097          	auipc	ra,0xffffe
    80006102:	0fa080e7          	jalr	250(ra) # 800041f8 <iunlockput>
      end_op();
    80006106:	fffff097          	auipc	ra,0xfffff
    8000610a:	8d4080e7          	jalr	-1836(ra) # 800049da <end_op>
      return -1;
    8000610e:	557d                	li	a0,-1
    80006110:	74aa                	ld	s1,168(sp)
    80006112:	b775                	j	800060be <sys_open+0xe8>
      end_op();
    80006114:	fffff097          	auipc	ra,0xfffff
    80006118:	8c6080e7          	jalr	-1850(ra) # 800049da <end_op>
      return -1;
    8000611c:	557d                	li	a0,-1
    8000611e:	74aa                	ld	s1,168(sp)
    80006120:	bf79                	j	800060be <sys_open+0xe8>
    iunlockput(ip);
    80006122:	8526                	mv	a0,s1
    80006124:	ffffe097          	auipc	ra,0xffffe
    80006128:	0d4080e7          	jalr	212(ra) # 800041f8 <iunlockput>
    end_op();
    8000612c:	fffff097          	auipc	ra,0xfffff
    80006130:	8ae080e7          	jalr	-1874(ra) # 800049da <end_op>
    return -1;
    80006134:	557d                	li	a0,-1
    80006136:	74aa                	ld	s1,168(sp)
    80006138:	b759                	j	800060be <sys_open+0xe8>
      fileclose(f);
    8000613a:	854a                	mv	a0,s2
    8000613c:	fffff097          	auipc	ra,0xfffff
    80006140:	cee080e7          	jalr	-786(ra) # 80004e2a <fileclose>
    80006144:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006146:	8526                	mv	a0,s1
    80006148:	ffffe097          	auipc	ra,0xffffe
    8000614c:	0b0080e7          	jalr	176(ra) # 800041f8 <iunlockput>
    end_op();
    80006150:	fffff097          	auipc	ra,0xfffff
    80006154:	88a080e7          	jalr	-1910(ra) # 800049da <end_op>
    return -1;
    80006158:	557d                	li	a0,-1
    8000615a:	74aa                	ld	s1,168(sp)
    8000615c:	790a                	ld	s2,160(sp)
    8000615e:	b785                	j	800060be <sys_open+0xe8>
    f->type = FD_DEVICE;
    80006160:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80006164:	04649783          	lh	a5,70(s1)
    80006168:	02f91223          	sh	a5,36(s2)
    8000616c:	b729                	j	80006076 <sys_open+0xa0>
    itrunc(ip);
    8000616e:	8526                	mv	a0,s1
    80006170:	ffffe097          	auipc	ra,0xffffe
    80006174:	f34080e7          	jalr	-204(ra) # 800040a4 <itrunc>
    80006178:	b735                	j	800060a4 <sys_open+0xce>

000000008000617a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000617a:	7175                	addi	sp,sp,-144
    8000617c:	e506                	sd	ra,136(sp)
    8000617e:	e122                	sd	s0,128(sp)
    80006180:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006182:	ffffe097          	auipc	ra,0xffffe
    80006186:	7de080e7          	jalr	2014(ra) # 80004960 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000618a:	08000613          	li	a2,128
    8000618e:	f7040593          	addi	a1,s0,-144
    80006192:	4501                	li	a0,0
    80006194:	ffffd097          	auipc	ra,0xffffd
    80006198:	13c080e7          	jalr	316(ra) # 800032d0 <argstr>
    8000619c:	02054963          	bltz	a0,800061ce <sys_mkdir+0x54>
    800061a0:	4681                	li	a3,0
    800061a2:	4601                	li	a2,0
    800061a4:	4585                	li	a1,1
    800061a6:	f7040513          	addi	a0,s0,-144
    800061aa:	fffff097          	auipc	ra,0xfffff
    800061ae:	7d6080e7          	jalr	2006(ra) # 80005980 <create>
    800061b2:	cd11                	beqz	a0,800061ce <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800061b4:	ffffe097          	auipc	ra,0xffffe
    800061b8:	044080e7          	jalr	68(ra) # 800041f8 <iunlockput>
  end_op();
    800061bc:	fffff097          	auipc	ra,0xfffff
    800061c0:	81e080e7          	jalr	-2018(ra) # 800049da <end_op>
  return 0;
    800061c4:	4501                	li	a0,0
}
    800061c6:	60aa                	ld	ra,136(sp)
    800061c8:	640a                	ld	s0,128(sp)
    800061ca:	6149                	addi	sp,sp,144
    800061cc:	8082                	ret
    end_op();
    800061ce:	fffff097          	auipc	ra,0xfffff
    800061d2:	80c080e7          	jalr	-2036(ra) # 800049da <end_op>
    return -1;
    800061d6:	557d                	li	a0,-1
    800061d8:	b7fd                	j	800061c6 <sys_mkdir+0x4c>

00000000800061da <sys_mknod>:

uint64
sys_mknod(void)
{
    800061da:	7135                	addi	sp,sp,-160
    800061dc:	ed06                	sd	ra,152(sp)
    800061de:	e922                	sd	s0,144(sp)
    800061e0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800061e2:	ffffe097          	auipc	ra,0xffffe
    800061e6:	77e080e7          	jalr	1918(ra) # 80004960 <begin_op>
  argint(1, &major);
    800061ea:	f6c40593          	addi	a1,s0,-148
    800061ee:	4505                	li	a0,1
    800061f0:	ffffd097          	auipc	ra,0xffffd
    800061f4:	0a0080e7          	jalr	160(ra) # 80003290 <argint>
  argint(2, &minor);
    800061f8:	f6840593          	addi	a1,s0,-152
    800061fc:	4509                	li	a0,2
    800061fe:	ffffd097          	auipc	ra,0xffffd
    80006202:	092080e7          	jalr	146(ra) # 80003290 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006206:	08000613          	li	a2,128
    8000620a:	f7040593          	addi	a1,s0,-144
    8000620e:	4501                	li	a0,0
    80006210:	ffffd097          	auipc	ra,0xffffd
    80006214:	0c0080e7          	jalr	192(ra) # 800032d0 <argstr>
    80006218:	02054b63          	bltz	a0,8000624e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000621c:	f6841683          	lh	a3,-152(s0)
    80006220:	f6c41603          	lh	a2,-148(s0)
    80006224:	458d                	li	a1,3
    80006226:	f7040513          	addi	a0,s0,-144
    8000622a:	fffff097          	auipc	ra,0xfffff
    8000622e:	756080e7          	jalr	1878(ra) # 80005980 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006232:	cd11                	beqz	a0,8000624e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006234:	ffffe097          	auipc	ra,0xffffe
    80006238:	fc4080e7          	jalr	-60(ra) # 800041f8 <iunlockput>
  end_op();
    8000623c:	ffffe097          	auipc	ra,0xffffe
    80006240:	79e080e7          	jalr	1950(ra) # 800049da <end_op>
  return 0;
    80006244:	4501                	li	a0,0
}
    80006246:	60ea                	ld	ra,152(sp)
    80006248:	644a                	ld	s0,144(sp)
    8000624a:	610d                	addi	sp,sp,160
    8000624c:	8082                	ret
    end_op();
    8000624e:	ffffe097          	auipc	ra,0xffffe
    80006252:	78c080e7          	jalr	1932(ra) # 800049da <end_op>
    return -1;
    80006256:	557d                	li	a0,-1
    80006258:	b7fd                	j	80006246 <sys_mknod+0x6c>

000000008000625a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000625a:	7135                	addi	sp,sp,-160
    8000625c:	ed06                	sd	ra,152(sp)
    8000625e:	e922                	sd	s0,144(sp)
    80006260:	e14a                	sd	s2,128(sp)
    80006262:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006264:	ffffc097          	auipc	ra,0xffffc
    80006268:	ba4080e7          	jalr	-1116(ra) # 80001e08 <myproc>
    8000626c:	892a                	mv	s2,a0
  
  begin_op();
    8000626e:	ffffe097          	auipc	ra,0xffffe
    80006272:	6f2080e7          	jalr	1778(ra) # 80004960 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006276:	08000613          	li	a2,128
    8000627a:	f6040593          	addi	a1,s0,-160
    8000627e:	4501                	li	a0,0
    80006280:	ffffd097          	auipc	ra,0xffffd
    80006284:	050080e7          	jalr	80(ra) # 800032d0 <argstr>
    80006288:	04054d63          	bltz	a0,800062e2 <sys_chdir+0x88>
    8000628c:	e526                	sd	s1,136(sp)
    8000628e:	f6040513          	addi	a0,s0,-160
    80006292:	ffffe097          	auipc	ra,0xffffe
    80006296:	4ce080e7          	jalr	1230(ra) # 80004760 <namei>
    8000629a:	84aa                	mv	s1,a0
    8000629c:	c131                	beqz	a0,800062e0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000629e:	ffffe097          	auipc	ra,0xffffe
    800062a2:	cf4080e7          	jalr	-780(ra) # 80003f92 <ilock>
  if(ip->type != T_DIR){
    800062a6:	04449703          	lh	a4,68(s1)
    800062aa:	4785                	li	a5,1
    800062ac:	04f71163          	bne	a4,a5,800062ee <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800062b0:	8526                	mv	a0,s1
    800062b2:	ffffe097          	auipc	ra,0xffffe
    800062b6:	da6080e7          	jalr	-602(ra) # 80004058 <iunlock>
  iput(p->cwd);
    800062ba:	15093503          	ld	a0,336(s2)
    800062be:	ffffe097          	auipc	ra,0xffffe
    800062c2:	e92080e7          	jalr	-366(ra) # 80004150 <iput>
  end_op();
    800062c6:	ffffe097          	auipc	ra,0xffffe
    800062ca:	714080e7          	jalr	1812(ra) # 800049da <end_op>
  p->cwd = ip;
    800062ce:	14993823          	sd	s1,336(s2)
  return 0;
    800062d2:	4501                	li	a0,0
    800062d4:	64aa                	ld	s1,136(sp)
}
    800062d6:	60ea                	ld	ra,152(sp)
    800062d8:	644a                	ld	s0,144(sp)
    800062da:	690a                	ld	s2,128(sp)
    800062dc:	610d                	addi	sp,sp,160
    800062de:	8082                	ret
    800062e0:	64aa                	ld	s1,136(sp)
    end_op();
    800062e2:	ffffe097          	auipc	ra,0xffffe
    800062e6:	6f8080e7          	jalr	1784(ra) # 800049da <end_op>
    return -1;
    800062ea:	557d                	li	a0,-1
    800062ec:	b7ed                	j	800062d6 <sys_chdir+0x7c>
    iunlockput(ip);
    800062ee:	8526                	mv	a0,s1
    800062f0:	ffffe097          	auipc	ra,0xffffe
    800062f4:	f08080e7          	jalr	-248(ra) # 800041f8 <iunlockput>
    end_op();
    800062f8:	ffffe097          	auipc	ra,0xffffe
    800062fc:	6e2080e7          	jalr	1762(ra) # 800049da <end_op>
    return -1;
    80006300:	557d                	li	a0,-1
    80006302:	64aa                	ld	s1,136(sp)
    80006304:	bfc9                	j	800062d6 <sys_chdir+0x7c>

0000000080006306 <sys_exec>:

uint64
sys_exec(void)
{
    80006306:	7121                	addi	sp,sp,-448
    80006308:	ff06                	sd	ra,440(sp)
    8000630a:	fb22                	sd	s0,432(sp)
    8000630c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000630e:	e4840593          	addi	a1,s0,-440
    80006312:	4505                	li	a0,1
    80006314:	ffffd097          	auipc	ra,0xffffd
    80006318:	f9c080e7          	jalr	-100(ra) # 800032b0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000631c:	08000613          	li	a2,128
    80006320:	f5040593          	addi	a1,s0,-176
    80006324:	4501                	li	a0,0
    80006326:	ffffd097          	auipc	ra,0xffffd
    8000632a:	faa080e7          	jalr	-86(ra) # 800032d0 <argstr>
    8000632e:	87aa                	mv	a5,a0
    return -1;
    80006330:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006332:	0e07c263          	bltz	a5,80006416 <sys_exec+0x110>
    80006336:	f726                	sd	s1,424(sp)
    80006338:	f34a                	sd	s2,416(sp)
    8000633a:	ef4e                	sd	s3,408(sp)
    8000633c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000633e:	10000613          	li	a2,256
    80006342:	4581                	li	a1,0
    80006344:	e5040513          	addi	a0,s0,-432
    80006348:	ffffb097          	auipc	ra,0xffffb
    8000634c:	cba080e7          	jalr	-838(ra) # 80001002 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006350:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80006354:	89a6                	mv	s3,s1
    80006356:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006358:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000635c:	00391513          	slli	a0,s2,0x3
    80006360:	e4040593          	addi	a1,s0,-448
    80006364:	e4843783          	ld	a5,-440(s0)
    80006368:	953e                	add	a0,a0,a5
    8000636a:	ffffd097          	auipc	ra,0xffffd
    8000636e:	e88080e7          	jalr	-376(ra) # 800031f2 <fetchaddr>
    80006372:	02054a63          	bltz	a0,800063a6 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80006376:	e4043783          	ld	a5,-448(s0)
    8000637a:	c7b9                	beqz	a5,800063c8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000637c:	ffffb097          	auipc	ra,0xffffb
    80006380:	a00080e7          	jalr	-1536(ra) # 80000d7c <kalloc>
    80006384:	85aa                	mv	a1,a0
    80006386:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000638a:	cd11                	beqz	a0,800063a6 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000638c:	6605                	lui	a2,0x1
    8000638e:	e4043503          	ld	a0,-448(s0)
    80006392:	ffffd097          	auipc	ra,0xffffd
    80006396:	eb2080e7          	jalr	-334(ra) # 80003244 <fetchstr>
    8000639a:	00054663          	bltz	a0,800063a6 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000639e:	0905                	addi	s2,s2,1
    800063a0:	09a1                	addi	s3,s3,8
    800063a2:	fb491de3          	bne	s2,s4,8000635c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063a6:	f5040913          	addi	s2,s0,-176
    800063aa:	6088                	ld	a0,0(s1)
    800063ac:	c125                	beqz	a0,8000640c <sys_exec+0x106>
    kfree(argv[i]);
    800063ae:	ffffa097          	auipc	ra,0xffffa
    800063b2:	7d4080e7          	jalr	2004(ra) # 80000b82 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063b6:	04a1                	addi	s1,s1,8
    800063b8:	ff2499e3          	bne	s1,s2,800063aa <sys_exec+0xa4>
  return -1;
    800063bc:	557d                	li	a0,-1
    800063be:	74ba                	ld	s1,424(sp)
    800063c0:	791a                	ld	s2,416(sp)
    800063c2:	69fa                	ld	s3,408(sp)
    800063c4:	6a5a                	ld	s4,400(sp)
    800063c6:	a881                	j	80006416 <sys_exec+0x110>
      argv[i] = 0;
    800063c8:	0009079b          	sext.w	a5,s2
    800063cc:	078e                	slli	a5,a5,0x3
    800063ce:	fd078793          	addi	a5,a5,-48
    800063d2:	97a2                	add	a5,a5,s0
    800063d4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800063d8:	e5040593          	addi	a1,s0,-432
    800063dc:	f5040513          	addi	a0,s0,-176
    800063e0:	fffff097          	auipc	ra,0xfffff
    800063e4:	120080e7          	jalr	288(ra) # 80005500 <exec>
    800063e8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063ea:	f5040993          	addi	s3,s0,-176
    800063ee:	6088                	ld	a0,0(s1)
    800063f0:	c901                	beqz	a0,80006400 <sys_exec+0xfa>
    kfree(argv[i]);
    800063f2:	ffffa097          	auipc	ra,0xffffa
    800063f6:	790080e7          	jalr	1936(ra) # 80000b82 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063fa:	04a1                	addi	s1,s1,8
    800063fc:	ff3499e3          	bne	s1,s3,800063ee <sys_exec+0xe8>
  return ret;
    80006400:	854a                	mv	a0,s2
    80006402:	74ba                	ld	s1,424(sp)
    80006404:	791a                	ld	s2,416(sp)
    80006406:	69fa                	ld	s3,408(sp)
    80006408:	6a5a                	ld	s4,400(sp)
    8000640a:	a031                	j	80006416 <sys_exec+0x110>
  return -1;
    8000640c:	557d                	li	a0,-1
    8000640e:	74ba                	ld	s1,424(sp)
    80006410:	791a                	ld	s2,416(sp)
    80006412:	69fa                	ld	s3,408(sp)
    80006414:	6a5a                	ld	s4,400(sp)
}
    80006416:	70fa                	ld	ra,440(sp)
    80006418:	745a                	ld	s0,432(sp)
    8000641a:	6139                	addi	sp,sp,448
    8000641c:	8082                	ret

000000008000641e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000641e:	7139                	addi	sp,sp,-64
    80006420:	fc06                	sd	ra,56(sp)
    80006422:	f822                	sd	s0,48(sp)
    80006424:	f426                	sd	s1,40(sp)
    80006426:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006428:	ffffc097          	auipc	ra,0xffffc
    8000642c:	9e0080e7          	jalr	-1568(ra) # 80001e08 <myproc>
    80006430:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006432:	fd840593          	addi	a1,s0,-40
    80006436:	4501                	li	a0,0
    80006438:	ffffd097          	auipc	ra,0xffffd
    8000643c:	e78080e7          	jalr	-392(ra) # 800032b0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006440:	fc840593          	addi	a1,s0,-56
    80006444:	fd040513          	addi	a0,s0,-48
    80006448:	fffff097          	auipc	ra,0xfffff
    8000644c:	d50080e7          	jalr	-688(ra) # 80005198 <pipealloc>
    return -1;
    80006450:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006452:	0c054463          	bltz	a0,8000651a <sys_pipe+0xfc>
  fd0 = -1;
    80006456:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000645a:	fd043503          	ld	a0,-48(s0)
    8000645e:	fffff097          	auipc	ra,0xfffff
    80006462:	4e0080e7          	jalr	1248(ra) # 8000593e <fdalloc>
    80006466:	fca42223          	sw	a0,-60(s0)
    8000646a:	08054b63          	bltz	a0,80006500 <sys_pipe+0xe2>
    8000646e:	fc843503          	ld	a0,-56(s0)
    80006472:	fffff097          	auipc	ra,0xfffff
    80006476:	4cc080e7          	jalr	1228(ra) # 8000593e <fdalloc>
    8000647a:	fca42023          	sw	a0,-64(s0)
    8000647e:	06054863          	bltz	a0,800064ee <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006482:	4691                	li	a3,4
    80006484:	fc440613          	addi	a2,s0,-60
    80006488:	fd843583          	ld	a1,-40(s0)
    8000648c:	68a8                	ld	a0,80(s1)
    8000648e:	ffffb097          	auipc	ra,0xffffb
    80006492:	51e080e7          	jalr	1310(ra) # 800019ac <copyout>
    80006496:	02054063          	bltz	a0,800064b6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000649a:	4691                	li	a3,4
    8000649c:	fc040613          	addi	a2,s0,-64
    800064a0:	fd843583          	ld	a1,-40(s0)
    800064a4:	0591                	addi	a1,a1,4
    800064a6:	68a8                	ld	a0,80(s1)
    800064a8:	ffffb097          	auipc	ra,0xffffb
    800064ac:	504080e7          	jalr	1284(ra) # 800019ac <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800064b0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800064b2:	06055463          	bgez	a0,8000651a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800064b6:	fc442783          	lw	a5,-60(s0)
    800064ba:	07e9                	addi	a5,a5,26
    800064bc:	078e                	slli	a5,a5,0x3
    800064be:	97a6                	add	a5,a5,s1
    800064c0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800064c4:	fc042783          	lw	a5,-64(s0)
    800064c8:	07e9                	addi	a5,a5,26
    800064ca:	078e                	slli	a5,a5,0x3
    800064cc:	94be                	add	s1,s1,a5
    800064ce:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800064d2:	fd043503          	ld	a0,-48(s0)
    800064d6:	fffff097          	auipc	ra,0xfffff
    800064da:	954080e7          	jalr	-1708(ra) # 80004e2a <fileclose>
    fileclose(wf);
    800064de:	fc843503          	ld	a0,-56(s0)
    800064e2:	fffff097          	auipc	ra,0xfffff
    800064e6:	948080e7          	jalr	-1720(ra) # 80004e2a <fileclose>
    return -1;
    800064ea:	57fd                	li	a5,-1
    800064ec:	a03d                	j	8000651a <sys_pipe+0xfc>
    if(fd0 >= 0)
    800064ee:	fc442783          	lw	a5,-60(s0)
    800064f2:	0007c763          	bltz	a5,80006500 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800064f6:	07e9                	addi	a5,a5,26
    800064f8:	078e                	slli	a5,a5,0x3
    800064fa:	97a6                	add	a5,a5,s1
    800064fc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006500:	fd043503          	ld	a0,-48(s0)
    80006504:	fffff097          	auipc	ra,0xfffff
    80006508:	926080e7          	jalr	-1754(ra) # 80004e2a <fileclose>
    fileclose(wf);
    8000650c:	fc843503          	ld	a0,-56(s0)
    80006510:	fffff097          	auipc	ra,0xfffff
    80006514:	91a080e7          	jalr	-1766(ra) # 80004e2a <fileclose>
    return -1;
    80006518:	57fd                	li	a5,-1
}
    8000651a:	853e                	mv	a0,a5
    8000651c:	70e2                	ld	ra,56(sp)
    8000651e:	7442                	ld	s0,48(sp)
    80006520:	74a2                	ld	s1,40(sp)
    80006522:	6121                	addi	sp,sp,64
    80006524:	8082                	ret
	...

0000000080006530 <kernelvec>:
    80006530:	7111                	addi	sp,sp,-256
    80006532:	e006                	sd	ra,0(sp)
    80006534:	e40a                	sd	sp,8(sp)
    80006536:	e80e                	sd	gp,16(sp)
    80006538:	ec12                	sd	tp,24(sp)
    8000653a:	f016                	sd	t0,32(sp)
    8000653c:	f41a                	sd	t1,40(sp)
    8000653e:	f81e                	sd	t2,48(sp)
    80006540:	fc22                	sd	s0,56(sp)
    80006542:	e0a6                	sd	s1,64(sp)
    80006544:	e4aa                	sd	a0,72(sp)
    80006546:	e8ae                	sd	a1,80(sp)
    80006548:	ecb2                	sd	a2,88(sp)
    8000654a:	f0b6                	sd	a3,96(sp)
    8000654c:	f4ba                	sd	a4,104(sp)
    8000654e:	f8be                	sd	a5,112(sp)
    80006550:	fcc2                	sd	a6,120(sp)
    80006552:	e146                	sd	a7,128(sp)
    80006554:	e54a                	sd	s2,136(sp)
    80006556:	e94e                	sd	s3,144(sp)
    80006558:	ed52                	sd	s4,152(sp)
    8000655a:	f156                	sd	s5,160(sp)
    8000655c:	f55a                	sd	s6,168(sp)
    8000655e:	f95e                	sd	s7,176(sp)
    80006560:	fd62                	sd	s8,184(sp)
    80006562:	e1e6                	sd	s9,192(sp)
    80006564:	e5ea                	sd	s10,200(sp)
    80006566:	e9ee                	sd	s11,208(sp)
    80006568:	edf2                	sd	t3,216(sp)
    8000656a:	f1f6                	sd	t4,224(sp)
    8000656c:	f5fa                	sd	t5,232(sp)
    8000656e:	f9fe                	sd	t6,240(sp)
    80006570:	b4ffc0ef          	jal	800030be <kerneltrap>
    80006574:	6082                	ld	ra,0(sp)
    80006576:	6122                	ld	sp,8(sp)
    80006578:	61c2                	ld	gp,16(sp)
    8000657a:	7282                	ld	t0,32(sp)
    8000657c:	7322                	ld	t1,40(sp)
    8000657e:	73c2                	ld	t2,48(sp)
    80006580:	7462                	ld	s0,56(sp)
    80006582:	6486                	ld	s1,64(sp)
    80006584:	6526                	ld	a0,72(sp)
    80006586:	65c6                	ld	a1,80(sp)
    80006588:	6666                	ld	a2,88(sp)
    8000658a:	7686                	ld	a3,96(sp)
    8000658c:	7726                	ld	a4,104(sp)
    8000658e:	77c6                	ld	a5,112(sp)
    80006590:	7866                	ld	a6,120(sp)
    80006592:	688a                	ld	a7,128(sp)
    80006594:	692a                	ld	s2,136(sp)
    80006596:	69ca                	ld	s3,144(sp)
    80006598:	6a6a                	ld	s4,152(sp)
    8000659a:	7a8a                	ld	s5,160(sp)
    8000659c:	7b2a                	ld	s6,168(sp)
    8000659e:	7bca                	ld	s7,176(sp)
    800065a0:	7c6a                	ld	s8,184(sp)
    800065a2:	6c8e                	ld	s9,192(sp)
    800065a4:	6d2e                	ld	s10,200(sp)
    800065a6:	6dce                	ld	s11,208(sp)
    800065a8:	6e6e                	ld	t3,216(sp)
    800065aa:	7e8e                	ld	t4,224(sp)
    800065ac:	7f2e                	ld	t5,232(sp)
    800065ae:	7fce                	ld	t6,240(sp)
    800065b0:	6111                	addi	sp,sp,256
    800065b2:	10200073          	sret
    800065b6:	00000013          	nop
    800065ba:	00000013          	nop
    800065be:	0001                	nop

00000000800065c0 <timervec>:
    800065c0:	34051573          	csrrw	a0,mscratch,a0
    800065c4:	e10c                	sd	a1,0(a0)
    800065c6:	e510                	sd	a2,8(a0)
    800065c8:	e914                	sd	a3,16(a0)
    800065ca:	6d0c                	ld	a1,24(a0)
    800065cc:	7110                	ld	a2,32(a0)
    800065ce:	6194                	ld	a3,0(a1)
    800065d0:	96b2                	add	a3,a3,a2
    800065d2:	e194                	sd	a3,0(a1)
    800065d4:	4589                	li	a1,2
    800065d6:	14459073          	csrw	sip,a1
    800065da:	6914                	ld	a3,16(a0)
    800065dc:	6510                	ld	a2,8(a0)
    800065de:	610c                	ld	a1,0(a0)
    800065e0:	34051573          	csrrw	a0,mscratch,a0
    800065e4:	30200073          	mret
	...

00000000800065ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800065ea:	1141                	addi	sp,sp,-16
    800065ec:	e422                	sd	s0,8(sp)
    800065ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800065f0:	0c0007b7          	lui	a5,0xc000
    800065f4:	4705                	li	a4,1
    800065f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800065f8:	0c0007b7          	lui	a5,0xc000
    800065fc:	c3d8                	sw	a4,4(a5)
}
    800065fe:	6422                	ld	s0,8(sp)
    80006600:	0141                	addi	sp,sp,16
    80006602:	8082                	ret

0000000080006604 <plicinithart>:

void
plicinithart(void)
{
    80006604:	1141                	addi	sp,sp,-16
    80006606:	e406                	sd	ra,8(sp)
    80006608:	e022                	sd	s0,0(sp)
    8000660a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000660c:	ffffb097          	auipc	ra,0xffffb
    80006610:	7d0080e7          	jalr	2000(ra) # 80001ddc <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006614:	0085171b          	slliw	a4,a0,0x8
    80006618:	0c0027b7          	lui	a5,0xc002
    8000661c:	97ba                	add	a5,a5,a4
    8000661e:	40200713          	li	a4,1026
    80006622:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006626:	00d5151b          	slliw	a0,a0,0xd
    8000662a:	0c2017b7          	lui	a5,0xc201
    8000662e:	97aa                	add	a5,a5,a0
    80006630:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006634:	60a2                	ld	ra,8(sp)
    80006636:	6402                	ld	s0,0(sp)
    80006638:	0141                	addi	sp,sp,16
    8000663a:	8082                	ret

000000008000663c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000663c:	1141                	addi	sp,sp,-16
    8000663e:	e406                	sd	ra,8(sp)
    80006640:	e022                	sd	s0,0(sp)
    80006642:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006644:	ffffb097          	auipc	ra,0xffffb
    80006648:	798080e7          	jalr	1944(ra) # 80001ddc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000664c:	00d5151b          	slliw	a0,a0,0xd
    80006650:	0c2017b7          	lui	a5,0xc201
    80006654:	97aa                	add	a5,a5,a0
  return irq;
}
    80006656:	43c8                	lw	a0,4(a5)
    80006658:	60a2                	ld	ra,8(sp)
    8000665a:	6402                	ld	s0,0(sp)
    8000665c:	0141                	addi	sp,sp,16
    8000665e:	8082                	ret

0000000080006660 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006660:	1101                	addi	sp,sp,-32
    80006662:	ec06                	sd	ra,24(sp)
    80006664:	e822                	sd	s0,16(sp)
    80006666:	e426                	sd	s1,8(sp)
    80006668:	1000                	addi	s0,sp,32
    8000666a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000666c:	ffffb097          	auipc	ra,0xffffb
    80006670:	770080e7          	jalr	1904(ra) # 80001ddc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006674:	00d5151b          	slliw	a0,a0,0xd
    80006678:	0c2017b7          	lui	a5,0xc201
    8000667c:	97aa                	add	a5,a5,a0
    8000667e:	c3c4                	sw	s1,4(a5)
}
    80006680:	60e2                	ld	ra,24(sp)
    80006682:	6442                	ld	s0,16(sp)
    80006684:	64a2                	ld	s1,8(sp)
    80006686:	6105                	addi	sp,sp,32
    80006688:	8082                	ret

000000008000668a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000668a:	1141                	addi	sp,sp,-16
    8000668c:	e406                	sd	ra,8(sp)
    8000668e:	e022                	sd	s0,0(sp)
    80006690:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006692:	479d                	li	a5,7
    80006694:	04a7cc63          	blt	a5,a0,800066ec <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006698:	0003e797          	auipc	a5,0x3e
    8000669c:	31078793          	addi	a5,a5,784 # 800449a8 <disk>
    800066a0:	97aa                	add	a5,a5,a0
    800066a2:	0187c783          	lbu	a5,24(a5)
    800066a6:	ebb9                	bnez	a5,800066fc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800066a8:	00451693          	slli	a3,a0,0x4
    800066ac:	0003e797          	auipc	a5,0x3e
    800066b0:	2fc78793          	addi	a5,a5,764 # 800449a8 <disk>
    800066b4:	6398                	ld	a4,0(a5)
    800066b6:	9736                	add	a4,a4,a3
    800066b8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800066bc:	6398                	ld	a4,0(a5)
    800066be:	9736                	add	a4,a4,a3
    800066c0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800066c4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800066c8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800066cc:	97aa                	add	a5,a5,a0
    800066ce:	4705                	li	a4,1
    800066d0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800066d4:	0003e517          	auipc	a0,0x3e
    800066d8:	2ec50513          	addi	a0,a0,748 # 800449c0 <disk+0x18>
    800066dc:	ffffc097          	auipc	ra,0xffffc
    800066e0:	f42080e7          	jalr	-190(ra) # 8000261e <wakeup>
}
    800066e4:	60a2                	ld	ra,8(sp)
    800066e6:	6402                	ld	s0,0(sp)
    800066e8:	0141                	addi	sp,sp,16
    800066ea:	8082                	ret
    panic("free_desc 1");
    800066ec:	00002517          	auipc	a0,0x2
    800066f0:	07c50513          	addi	a0,a0,124 # 80008768 <__func__.1+0x760>
    800066f4:	ffffa097          	auipc	ra,0xffffa
    800066f8:	e6c080e7          	jalr	-404(ra) # 80000560 <panic>
    panic("free_desc 2");
    800066fc:	00002517          	auipc	a0,0x2
    80006700:	07c50513          	addi	a0,a0,124 # 80008778 <__func__.1+0x770>
    80006704:	ffffa097          	auipc	ra,0xffffa
    80006708:	e5c080e7          	jalr	-420(ra) # 80000560 <panic>

000000008000670c <virtio_disk_init>:
{
    8000670c:	1101                	addi	sp,sp,-32
    8000670e:	ec06                	sd	ra,24(sp)
    80006710:	e822                	sd	s0,16(sp)
    80006712:	e426                	sd	s1,8(sp)
    80006714:	e04a                	sd	s2,0(sp)
    80006716:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006718:	00002597          	auipc	a1,0x2
    8000671c:	07058593          	addi	a1,a1,112 # 80008788 <__func__.1+0x780>
    80006720:	0003e517          	auipc	a0,0x3e
    80006724:	3b050513          	addi	a0,a0,944 # 80044ad0 <disk+0x128>
    80006728:	ffffa097          	auipc	ra,0xffffa
    8000672c:	74e080e7          	jalr	1870(ra) # 80000e76 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006730:	100017b7          	lui	a5,0x10001
    80006734:	4398                	lw	a4,0(a5)
    80006736:	2701                	sext.w	a4,a4
    80006738:	747277b7          	lui	a5,0x74727
    8000673c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006740:	18f71c63          	bne	a4,a5,800068d8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006744:	100017b7          	lui	a5,0x10001
    80006748:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000674a:	439c                	lw	a5,0(a5)
    8000674c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000674e:	4709                	li	a4,2
    80006750:	18e79463          	bne	a5,a4,800068d8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006754:	100017b7          	lui	a5,0x10001
    80006758:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000675a:	439c                	lw	a5,0(a5)
    8000675c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000675e:	16e79d63          	bne	a5,a4,800068d8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006762:	100017b7          	lui	a5,0x10001
    80006766:	47d8                	lw	a4,12(a5)
    80006768:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000676a:	554d47b7          	lui	a5,0x554d4
    8000676e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006772:	16f71363          	bne	a4,a5,800068d8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006776:	100017b7          	lui	a5,0x10001
    8000677a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000677e:	4705                	li	a4,1
    80006780:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006782:	470d                	li	a4,3
    80006784:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006786:	10001737          	lui	a4,0x10001
    8000678a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000678c:	c7ffe737          	lui	a4,0xc7ffe
    80006790:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb9c77>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006794:	8ef9                	and	a3,a3,a4
    80006796:	10001737          	lui	a4,0x10001
    8000679a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000679c:	472d                	li	a4,11
    8000679e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800067a0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800067a4:	439c                	lw	a5,0(a5)
    800067a6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800067aa:	8ba1                	andi	a5,a5,8
    800067ac:	12078e63          	beqz	a5,800068e8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800067b0:	100017b7          	lui	a5,0x10001
    800067b4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800067b8:	100017b7          	lui	a5,0x10001
    800067bc:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800067c0:	439c                	lw	a5,0(a5)
    800067c2:	2781                	sext.w	a5,a5
    800067c4:	12079a63          	bnez	a5,800068f8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800067c8:	100017b7          	lui	a5,0x10001
    800067cc:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800067d0:	439c                	lw	a5,0(a5)
    800067d2:	2781                	sext.w	a5,a5
  if(max == 0)
    800067d4:	12078a63          	beqz	a5,80006908 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800067d8:	471d                	li	a4,7
    800067da:	12f77f63          	bgeu	a4,a5,80006918 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800067de:	ffffa097          	auipc	ra,0xffffa
    800067e2:	59e080e7          	jalr	1438(ra) # 80000d7c <kalloc>
    800067e6:	0003e497          	auipc	s1,0x3e
    800067ea:	1c248493          	addi	s1,s1,450 # 800449a8 <disk>
    800067ee:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800067f0:	ffffa097          	auipc	ra,0xffffa
    800067f4:	58c080e7          	jalr	1420(ra) # 80000d7c <kalloc>
    800067f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800067fa:	ffffa097          	auipc	ra,0xffffa
    800067fe:	582080e7          	jalr	1410(ra) # 80000d7c <kalloc>
    80006802:	87aa                	mv	a5,a0
    80006804:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006806:	6088                	ld	a0,0(s1)
    80006808:	12050063          	beqz	a0,80006928 <virtio_disk_init+0x21c>
    8000680c:	0003e717          	auipc	a4,0x3e
    80006810:	1a473703          	ld	a4,420(a4) # 800449b0 <disk+0x8>
    80006814:	10070a63          	beqz	a4,80006928 <virtio_disk_init+0x21c>
    80006818:	10078863          	beqz	a5,80006928 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000681c:	6605                	lui	a2,0x1
    8000681e:	4581                	li	a1,0
    80006820:	ffffa097          	auipc	ra,0xffffa
    80006824:	7e2080e7          	jalr	2018(ra) # 80001002 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006828:	0003e497          	auipc	s1,0x3e
    8000682c:	18048493          	addi	s1,s1,384 # 800449a8 <disk>
    80006830:	6605                	lui	a2,0x1
    80006832:	4581                	li	a1,0
    80006834:	6488                	ld	a0,8(s1)
    80006836:	ffffa097          	auipc	ra,0xffffa
    8000683a:	7cc080e7          	jalr	1996(ra) # 80001002 <memset>
  memset(disk.used, 0, PGSIZE);
    8000683e:	6605                	lui	a2,0x1
    80006840:	4581                	li	a1,0
    80006842:	6888                	ld	a0,16(s1)
    80006844:	ffffa097          	auipc	ra,0xffffa
    80006848:	7be080e7          	jalr	1982(ra) # 80001002 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000684c:	100017b7          	lui	a5,0x10001
    80006850:	4721                	li	a4,8
    80006852:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006854:	4098                	lw	a4,0(s1)
    80006856:	100017b7          	lui	a5,0x10001
    8000685a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000685e:	40d8                	lw	a4,4(s1)
    80006860:	100017b7          	lui	a5,0x10001
    80006864:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006868:	649c                	ld	a5,8(s1)
    8000686a:	0007869b          	sext.w	a3,a5
    8000686e:	10001737          	lui	a4,0x10001
    80006872:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006876:	9781                	srai	a5,a5,0x20
    80006878:	10001737          	lui	a4,0x10001
    8000687c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006880:	689c                	ld	a5,16(s1)
    80006882:	0007869b          	sext.w	a3,a5
    80006886:	10001737          	lui	a4,0x10001
    8000688a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000688e:	9781                	srai	a5,a5,0x20
    80006890:	10001737          	lui	a4,0x10001
    80006894:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006898:	10001737          	lui	a4,0x10001
    8000689c:	4785                	li	a5,1
    8000689e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800068a0:	00f48c23          	sb	a5,24(s1)
    800068a4:	00f48ca3          	sb	a5,25(s1)
    800068a8:	00f48d23          	sb	a5,26(s1)
    800068ac:	00f48da3          	sb	a5,27(s1)
    800068b0:	00f48e23          	sb	a5,28(s1)
    800068b4:	00f48ea3          	sb	a5,29(s1)
    800068b8:	00f48f23          	sb	a5,30(s1)
    800068bc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800068c0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800068c4:	100017b7          	lui	a5,0x10001
    800068c8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800068cc:	60e2                	ld	ra,24(sp)
    800068ce:	6442                	ld	s0,16(sp)
    800068d0:	64a2                	ld	s1,8(sp)
    800068d2:	6902                	ld	s2,0(sp)
    800068d4:	6105                	addi	sp,sp,32
    800068d6:	8082                	ret
    panic("could not find virtio disk");
    800068d8:	00002517          	auipc	a0,0x2
    800068dc:	ec050513          	addi	a0,a0,-320 # 80008798 <__func__.1+0x790>
    800068e0:	ffffa097          	auipc	ra,0xffffa
    800068e4:	c80080e7          	jalr	-896(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800068e8:	00002517          	auipc	a0,0x2
    800068ec:	ed050513          	addi	a0,a0,-304 # 800087b8 <__func__.1+0x7b0>
    800068f0:	ffffa097          	auipc	ra,0xffffa
    800068f4:	c70080e7          	jalr	-912(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800068f8:	00002517          	auipc	a0,0x2
    800068fc:	ee050513          	addi	a0,a0,-288 # 800087d8 <__func__.1+0x7d0>
    80006900:	ffffa097          	auipc	ra,0xffffa
    80006904:	c60080e7          	jalr	-928(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006908:	00002517          	auipc	a0,0x2
    8000690c:	ef050513          	addi	a0,a0,-272 # 800087f8 <__func__.1+0x7f0>
    80006910:	ffffa097          	auipc	ra,0xffffa
    80006914:	c50080e7          	jalr	-944(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006918:	00002517          	auipc	a0,0x2
    8000691c:	f0050513          	addi	a0,a0,-256 # 80008818 <__func__.1+0x810>
    80006920:	ffffa097          	auipc	ra,0xffffa
    80006924:	c40080e7          	jalr	-960(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006928:	00002517          	auipc	a0,0x2
    8000692c:	f1050513          	addi	a0,a0,-240 # 80008838 <__func__.1+0x830>
    80006930:	ffffa097          	auipc	ra,0xffffa
    80006934:	c30080e7          	jalr	-976(ra) # 80000560 <panic>

0000000080006938 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006938:	7159                	addi	sp,sp,-112
    8000693a:	f486                	sd	ra,104(sp)
    8000693c:	f0a2                	sd	s0,96(sp)
    8000693e:	eca6                	sd	s1,88(sp)
    80006940:	e8ca                	sd	s2,80(sp)
    80006942:	e4ce                	sd	s3,72(sp)
    80006944:	e0d2                	sd	s4,64(sp)
    80006946:	fc56                	sd	s5,56(sp)
    80006948:	f85a                	sd	s6,48(sp)
    8000694a:	f45e                	sd	s7,40(sp)
    8000694c:	f062                	sd	s8,32(sp)
    8000694e:	ec66                	sd	s9,24(sp)
    80006950:	1880                	addi	s0,sp,112
    80006952:	8a2a                	mv	s4,a0
    80006954:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006956:	00c52c83          	lw	s9,12(a0)
    8000695a:	001c9c9b          	slliw	s9,s9,0x1
    8000695e:	1c82                	slli	s9,s9,0x20
    80006960:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006964:	0003e517          	auipc	a0,0x3e
    80006968:	16c50513          	addi	a0,a0,364 # 80044ad0 <disk+0x128>
    8000696c:	ffffa097          	auipc	ra,0xffffa
    80006970:	59a080e7          	jalr	1434(ra) # 80000f06 <acquire>
  for(int i = 0; i < 3; i++){
    80006974:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006976:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006978:	0003eb17          	auipc	s6,0x3e
    8000697c:	030b0b13          	addi	s6,s6,48 # 800449a8 <disk>
  for(int i = 0; i < 3; i++){
    80006980:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006982:	0003ec17          	auipc	s8,0x3e
    80006986:	14ec0c13          	addi	s8,s8,334 # 80044ad0 <disk+0x128>
    8000698a:	a0ad                	j	800069f4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000698c:	00fb0733          	add	a4,s6,a5
    80006990:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006994:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006996:	0207c563          	bltz	a5,800069c0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000699a:	2905                	addiw	s2,s2,1
    8000699c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000699e:	05590f63          	beq	s2,s5,800069fc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800069a2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800069a4:	0003e717          	auipc	a4,0x3e
    800069a8:	00470713          	addi	a4,a4,4 # 800449a8 <disk>
    800069ac:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800069ae:	01874683          	lbu	a3,24(a4)
    800069b2:	fee9                	bnez	a3,8000698c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800069b4:	2785                	addiw	a5,a5,1
    800069b6:	0705                	addi	a4,a4,1
    800069b8:	fe979be3          	bne	a5,s1,800069ae <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800069bc:	57fd                	li	a5,-1
    800069be:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800069c0:	03205163          	blez	s2,800069e2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800069c4:	f9042503          	lw	a0,-112(s0)
    800069c8:	00000097          	auipc	ra,0x0
    800069cc:	cc2080e7          	jalr	-830(ra) # 8000668a <free_desc>
      for(int j = 0; j < i; j++)
    800069d0:	4785                	li	a5,1
    800069d2:	0127d863          	bge	a5,s2,800069e2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800069d6:	f9442503          	lw	a0,-108(s0)
    800069da:	00000097          	auipc	ra,0x0
    800069de:	cb0080e7          	jalr	-848(ra) # 8000668a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800069e2:	85e2                	mv	a1,s8
    800069e4:	0003e517          	auipc	a0,0x3e
    800069e8:	fdc50513          	addi	a0,a0,-36 # 800449c0 <disk+0x18>
    800069ec:	ffffc097          	auipc	ra,0xffffc
    800069f0:	bce080e7          	jalr	-1074(ra) # 800025ba <sleep>
  for(int i = 0; i < 3; i++){
    800069f4:	f9040613          	addi	a2,s0,-112
    800069f8:	894e                	mv	s2,s3
    800069fa:	b765                	j	800069a2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800069fc:	f9042503          	lw	a0,-112(s0)
    80006a00:	00451693          	slli	a3,a0,0x4

  if(write)
    80006a04:	0003e797          	auipc	a5,0x3e
    80006a08:	fa478793          	addi	a5,a5,-92 # 800449a8 <disk>
    80006a0c:	00a50713          	addi	a4,a0,10
    80006a10:	0712                	slli	a4,a4,0x4
    80006a12:	973e                	add	a4,a4,a5
    80006a14:	01703633          	snez	a2,s7
    80006a18:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006a1a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006a1e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006a22:	6398                	ld	a4,0(a5)
    80006a24:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006a26:	0a868613          	addi	a2,a3,168
    80006a2a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006a2c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006a2e:	6390                	ld	a2,0(a5)
    80006a30:	00d605b3          	add	a1,a2,a3
    80006a34:	4741                	li	a4,16
    80006a36:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006a38:	4805                	li	a6,1
    80006a3a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006a3e:	f9442703          	lw	a4,-108(s0)
    80006a42:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006a46:	0712                	slli	a4,a4,0x4
    80006a48:	963a                	add	a2,a2,a4
    80006a4a:	058a0593          	addi	a1,s4,88
    80006a4e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006a50:	0007b883          	ld	a7,0(a5)
    80006a54:	9746                	add	a4,a4,a7
    80006a56:	40000613          	li	a2,1024
    80006a5a:	c710                	sw	a2,8(a4)
  if(write)
    80006a5c:	001bb613          	seqz	a2,s7
    80006a60:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006a64:	00166613          	ori	a2,a2,1
    80006a68:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006a6c:	f9842583          	lw	a1,-104(s0)
    80006a70:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006a74:	00250613          	addi	a2,a0,2
    80006a78:	0612                	slli	a2,a2,0x4
    80006a7a:	963e                	add	a2,a2,a5
    80006a7c:	577d                	li	a4,-1
    80006a7e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006a82:	0592                	slli	a1,a1,0x4
    80006a84:	98ae                	add	a7,a7,a1
    80006a86:	03068713          	addi	a4,a3,48
    80006a8a:	973e                	add	a4,a4,a5
    80006a8c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006a90:	6398                	ld	a4,0(a5)
    80006a92:	972e                	add	a4,a4,a1
    80006a94:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006a98:	4689                	li	a3,2
    80006a9a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006a9e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006aa2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006aa6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006aaa:	6794                	ld	a3,8(a5)
    80006aac:	0026d703          	lhu	a4,2(a3)
    80006ab0:	8b1d                	andi	a4,a4,7
    80006ab2:	0706                	slli	a4,a4,0x1
    80006ab4:	96ba                	add	a3,a3,a4
    80006ab6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006aba:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006abe:	6798                	ld	a4,8(a5)
    80006ac0:	00275783          	lhu	a5,2(a4)
    80006ac4:	2785                	addiw	a5,a5,1
    80006ac6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006aca:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006ace:	100017b7          	lui	a5,0x10001
    80006ad2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006ad6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006ada:	0003e917          	auipc	s2,0x3e
    80006ade:	ff690913          	addi	s2,s2,-10 # 80044ad0 <disk+0x128>
  while(b->disk == 1) {
    80006ae2:	4485                	li	s1,1
    80006ae4:	01079c63          	bne	a5,a6,80006afc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006ae8:	85ca                	mv	a1,s2
    80006aea:	8552                	mv	a0,s4
    80006aec:	ffffc097          	auipc	ra,0xffffc
    80006af0:	ace080e7          	jalr	-1330(ra) # 800025ba <sleep>
  while(b->disk == 1) {
    80006af4:	004a2783          	lw	a5,4(s4)
    80006af8:	fe9788e3          	beq	a5,s1,80006ae8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006afc:	f9042903          	lw	s2,-112(s0)
    80006b00:	00290713          	addi	a4,s2,2
    80006b04:	0712                	slli	a4,a4,0x4
    80006b06:	0003e797          	auipc	a5,0x3e
    80006b0a:	ea278793          	addi	a5,a5,-350 # 800449a8 <disk>
    80006b0e:	97ba                	add	a5,a5,a4
    80006b10:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006b14:	0003e997          	auipc	s3,0x3e
    80006b18:	e9498993          	addi	s3,s3,-364 # 800449a8 <disk>
    80006b1c:	00491713          	slli	a4,s2,0x4
    80006b20:	0009b783          	ld	a5,0(s3)
    80006b24:	97ba                	add	a5,a5,a4
    80006b26:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006b2a:	854a                	mv	a0,s2
    80006b2c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006b30:	00000097          	auipc	ra,0x0
    80006b34:	b5a080e7          	jalr	-1190(ra) # 8000668a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006b38:	8885                	andi	s1,s1,1
    80006b3a:	f0ed                	bnez	s1,80006b1c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006b3c:	0003e517          	auipc	a0,0x3e
    80006b40:	f9450513          	addi	a0,a0,-108 # 80044ad0 <disk+0x128>
    80006b44:	ffffa097          	auipc	ra,0xffffa
    80006b48:	476080e7          	jalr	1142(ra) # 80000fba <release>
}
    80006b4c:	70a6                	ld	ra,104(sp)
    80006b4e:	7406                	ld	s0,96(sp)
    80006b50:	64e6                	ld	s1,88(sp)
    80006b52:	6946                	ld	s2,80(sp)
    80006b54:	69a6                	ld	s3,72(sp)
    80006b56:	6a06                	ld	s4,64(sp)
    80006b58:	7ae2                	ld	s5,56(sp)
    80006b5a:	7b42                	ld	s6,48(sp)
    80006b5c:	7ba2                	ld	s7,40(sp)
    80006b5e:	7c02                	ld	s8,32(sp)
    80006b60:	6ce2                	ld	s9,24(sp)
    80006b62:	6165                	addi	sp,sp,112
    80006b64:	8082                	ret

0000000080006b66 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006b66:	1101                	addi	sp,sp,-32
    80006b68:	ec06                	sd	ra,24(sp)
    80006b6a:	e822                	sd	s0,16(sp)
    80006b6c:	e426                	sd	s1,8(sp)
    80006b6e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006b70:	0003e497          	auipc	s1,0x3e
    80006b74:	e3848493          	addi	s1,s1,-456 # 800449a8 <disk>
    80006b78:	0003e517          	auipc	a0,0x3e
    80006b7c:	f5850513          	addi	a0,a0,-168 # 80044ad0 <disk+0x128>
    80006b80:	ffffa097          	auipc	ra,0xffffa
    80006b84:	386080e7          	jalr	902(ra) # 80000f06 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006b88:	100017b7          	lui	a5,0x10001
    80006b8c:	53b8                	lw	a4,96(a5)
    80006b8e:	8b0d                	andi	a4,a4,3
    80006b90:	100017b7          	lui	a5,0x10001
    80006b94:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006b96:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006b9a:	689c                	ld	a5,16(s1)
    80006b9c:	0204d703          	lhu	a4,32(s1)
    80006ba0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006ba4:	04f70863          	beq	a4,a5,80006bf4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006ba8:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006bac:	6898                	ld	a4,16(s1)
    80006bae:	0204d783          	lhu	a5,32(s1)
    80006bb2:	8b9d                	andi	a5,a5,7
    80006bb4:	078e                	slli	a5,a5,0x3
    80006bb6:	97ba                	add	a5,a5,a4
    80006bb8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006bba:	00278713          	addi	a4,a5,2
    80006bbe:	0712                	slli	a4,a4,0x4
    80006bc0:	9726                	add	a4,a4,s1
    80006bc2:	01074703          	lbu	a4,16(a4)
    80006bc6:	e721                	bnez	a4,80006c0e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006bc8:	0789                	addi	a5,a5,2
    80006bca:	0792                	slli	a5,a5,0x4
    80006bcc:	97a6                	add	a5,a5,s1
    80006bce:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006bd0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006bd4:	ffffc097          	auipc	ra,0xffffc
    80006bd8:	a4a080e7          	jalr	-1462(ra) # 8000261e <wakeup>

    disk.used_idx += 1;
    80006bdc:	0204d783          	lhu	a5,32(s1)
    80006be0:	2785                	addiw	a5,a5,1
    80006be2:	17c2                	slli	a5,a5,0x30
    80006be4:	93c1                	srli	a5,a5,0x30
    80006be6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006bea:	6898                	ld	a4,16(s1)
    80006bec:	00275703          	lhu	a4,2(a4)
    80006bf0:	faf71ce3          	bne	a4,a5,80006ba8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006bf4:	0003e517          	auipc	a0,0x3e
    80006bf8:	edc50513          	addi	a0,a0,-292 # 80044ad0 <disk+0x128>
    80006bfc:	ffffa097          	auipc	ra,0xffffa
    80006c00:	3be080e7          	jalr	958(ra) # 80000fba <release>
}
    80006c04:	60e2                	ld	ra,24(sp)
    80006c06:	6442                	ld	s0,16(sp)
    80006c08:	64a2                	ld	s1,8(sp)
    80006c0a:	6105                	addi	sp,sp,32
    80006c0c:	8082                	ret
      panic("virtio_disk_intr status");
    80006c0e:	00002517          	auipc	a0,0x2
    80006c12:	c4250513          	addi	a0,a0,-958 # 80008850 <__func__.1+0x848>
    80006c16:	ffffa097          	auipc	ra,0xffffa
    80006c1a:	94a080e7          	jalr	-1718(ra) # 80000560 <panic>
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
