
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	41013103          	ld	sp,1040(sp) # 8000b410 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000054:	42070713          	addi	a4,a4,1056 # 8000b470 <timer_scratch>
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
    80000066:	04e78793          	addi	a5,a5,78 # 800060b0 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9f1f>
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
    8000012e:	62a080e7          	jalr	1578(ra) # 80002754 <either_copyin>
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
    80000190:	42450513          	addi	a0,a0,1060 # 800135b0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	41448493          	addi	s1,s1,1044 # 800135b0 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	4a490913          	addi	s2,s2,1188 # 80013648 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	962080e7          	jalr	-1694(ra) # 80001b1e <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	3da080e7          	jalr	986(ra) # 8000259e <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	124080e7          	jalr	292(ra) # 800022f6 <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	3c870713          	addi	a4,a4,968 # 800135b0 <cons>
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
    8000021e:	4e4080e7          	jalr	1252(ra) # 800026fe <either_copyout>
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
    8000023a:	37a50513          	addi	a0,a0,890 # 800135b0 <cons>
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
    80000268:	3ef72223          	sw	a5,996(a4) # 80013648 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	33650513          	addi	a0,a0,822 # 800135b0 <cons>
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
    800002e6:	2ce50513          	addi	a0,a0,718 # 800135b0 <cons>
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
    8000030c:	4a2080e7          	jalr	1186(ra) # 800027aa <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	2a050513          	addi	a0,a0,672 # 800135b0 <cons>
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
    80000336:	27e70713          	addi	a4,a4,638 # 800135b0 <cons>
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
    80000360:	25478793          	addi	a5,a5,596 # 800135b0 <cons>
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
    8000038e:	2be7a783          	lw	a5,702(a5) # 80013648 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	21070713          	addi	a4,a4,528 # 800135b0 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	20048493          	addi	s1,s1,512 # 800135b0 <cons>
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
    800003fa:	1ba70713          	addi	a4,a4,442 # 800135b0 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	24f72223          	sw	a5,580(a4) # 80013650 <cons+0xa0>
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
    80000436:	17e78793          	addi	a5,a5,382 # 800135b0 <cons>
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
    8000045a:	1ec7ab23          	sw	a2,502(a5) # 8001364c <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	1ea50513          	addi	a0,a0,490 # 80013648 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	ef4080e7          	jalr	-268(ra) # 8000235a <wakeup>
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
    80000484:	13050513          	addi	a0,a0,304 # 800135b0 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00023797          	auipc	a5,0x23
    8000049c:	2b078793          	addi	a5,a5,688 # 80023748 <devsw>
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
    80000570:	1007a223          	sw	zero,260(a5) # 80013670 <pr+0x18>
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
    800005a4:	e8f72823          	sw	a5,-368(a4) # 8000b430 <panicked>
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
    800005ce:	0a6d2d03          	lw	s10,166(s10) # 80013670 <pr+0x18>
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
    8000061e:	03e50513          	addi	a0,a0,62 # 80013658 <pr>
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
    800007a4:	eb850513          	addi	a0,a0,-328 # 80013658 <pr>
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
    800007c0:	e9c48493          	addi	s1,s1,-356 # 80013658 <pr>
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
    8000082c:	e5050513          	addi	a0,a0,-432 # 80013678 <uart_tx_lock>
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
    80000858:	bdc7a783          	lw	a5,-1060(a5) # 8000b430 <panicked>
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
    80000892:	baa7b783          	ld	a5,-1110(a5) # 8000b438 <uart_tx_r>
    80000896:	0000b717          	auipc	a4,0xb
    8000089a:	baa73703          	ld	a4,-1110(a4) # 8000b440 <uart_tx_w>
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
    800008c0:	dbca8a93          	addi	s5,s5,-580 # 80013678 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000b497          	auipc	s1,0xb
    800008c8:	b7448493          	addi	s1,s1,-1164 # 8000b438 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000b997          	auipc	s3,0xb
    800008d4:	b7098993          	addi	s3,s3,-1168 # 8000b440 <uart_tx_w>
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
    800008f6:	a68080e7          	jalr	-1432(ra) # 8000235a <wakeup>
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
    80000934:	d4850513          	addi	a0,a0,-696 # 80013678 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	300080e7          	jalr	768(ra) # 80000c38 <acquire>
  if(panicked){
    80000940:	0000b797          	auipc	a5,0xb
    80000944:	af07a783          	lw	a5,-1296(a5) # 8000b430 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000b717          	auipc	a4,0xb
    8000094e:	af673703          	ld	a4,-1290(a4) # 8000b440 <uart_tx_w>
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	ae67b783          	ld	a5,-1306(a5) # 8000b438 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00013997          	auipc	s3,0x13
    80000962:	d1a98993          	addi	s3,s3,-742 # 80013678 <uart_tx_lock>
    80000966:	0000b497          	auipc	s1,0xb
    8000096a:	ad248493          	addi	s1,s1,-1326 # 8000b438 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000b917          	auipc	s2,0xb
    80000972:	ad290913          	addi	s2,s2,-1326 # 8000b440 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	978080e7          	jalr	-1672(ra) # 800022f6 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00013497          	auipc	s1,0x13
    80000998:	ce448493          	addi	s1,s1,-796 # 80013678 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000b797          	auipc	a5,0xb
    800009ac:	a8e7bc23          	sd	a4,-1384(a5) # 8000b440 <uart_tx_w>
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
    80000a20:	c5c48493          	addi	s1,s1,-932 # 80013678 <uart_tx_lock>
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
    80000a62:	e8278793          	addi	a5,a5,-382 # 800248e0 <end>
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
    80000a82:	c3290913          	addi	s2,s2,-974 # 800136b0 <kmem>
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
    80000b20:	b9450513          	addi	a0,a0,-1132 # 800136b0 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00024517          	auipc	a0,0x24
    80000b34:	db050513          	addi	a0,a0,-592 # 800248e0 <end>
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
    80000b56:	b5e48493          	addi	s1,s1,-1186 # 800136b0 <kmem>
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
    80000b6e:	b4650513          	addi	a0,a0,-1210 # 800136b0 <kmem>
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
    80000b9a:	b1a50513          	addi	a0,a0,-1254 # 800136b0 <kmem>
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
    80000bd6:	f30080e7          	jalr	-208(ra) # 80001b02 <mycpu>
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
    80000c08:	efe080e7          	jalr	-258(ra) # 80001b02 <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	ef2080e7          	jalr	-270(ra) # 80001b02 <mycpu>
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
    80000c2c:	eda080e7          	jalr	-294(ra) # 80001b02 <mycpu>
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
    80000c6c:	e9a080e7          	jalr	-358(ra) # 80001b02 <mycpu>
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
    80000c98:	e6e080e7          	jalr	-402(ra) # 80001b02 <mycpu>
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
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda721>
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
    80000ede:	c18080e7          	jalr	-1000(ra) # 80001af2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ee2:	0000a717          	auipc	a4,0xa
    80000ee6:	56670713          	addi	a4,a4,1382 # 8000b448 <started>
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
    80000efa:	bfc080e7          	jalr	-1028(ra) # 80001af2 <cpuid>
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
    80000f1c:	ab6080e7          	jalr	-1354(ra) # 800029ce <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	1d4080e7          	jalr	468(ra) # 800060f4 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	286080e7          	jalr	646(ra) # 800021ae <scheduler>
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
    80000f8c:	a84080e7          	jalr	-1404(ra) # 80001a0c <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	a16080e7          	jalr	-1514(ra) # 800029a6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	a36080e7          	jalr	-1482(ra) # 800029ce <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	13a080e7          	jalr	314(ra) # 800060da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	14c080e7          	jalr	332(ra) # 800060f4 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	216080e7          	jalr	534(ra) # 800031c6 <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	8cc080e7          	jalr	-1844(ra) # 80003884 <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	87c080e7          	jalr	-1924(ra) # 8000483c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	234080e7          	jalr	564(ra) # 800061fc <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	e26080e7          	jalr	-474(ra) # 80001df6 <userinit>
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    started = 1;
    80000fdc:	4785                	li	a5,1
    80000fde:	0000a717          	auipc	a4,0xa
    80000fe2:	46f72523          	sw	a5,1130(a4) # 8000b448 <started>
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
    80000ff6:	45e7b783          	ld	a5,1118(a5) # 8000b450 <kernel_pagetable>
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
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda717>
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
    8000128c:	6e0080e7          	jalr	1760(ra) # 80001968 <proc_mapstacks>
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
    800012b2:	1aa7b123          	sd	a0,418(a5) # 8000b450 <kernel_pagetable>
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
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda720>
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

00000000800018b8 <rr_scheduler>:
        old_scheduler = sched_pointer;
    }
}

void rr_scheduler(void)
{
    800018b8:	7139                	addi	sp,sp,-64
    800018ba:	fc06                	sd	ra,56(sp)
    800018bc:	f822                	sd	s0,48(sp)
    800018be:	f426                	sd	s1,40(sp)
    800018c0:	f04a                	sd	s2,32(sp)
    800018c2:	ec4e                	sd	s3,24(sp)
    800018c4:	e852                	sd	s4,16(sp)
    800018c6:	e456                	sd	s5,8(sp)
    800018c8:	e05a                	sd	s6,0(sp)
    800018ca:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    800018cc:	8792                	mv	a5,tp
    int id = r_tp();
    800018ce:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    800018d0:	00012a97          	auipc	s5,0x12
    800018d4:	e00a8a93          	addi	s5,s5,-512 # 800136d0 <cpus>
    800018d8:	00779713          	slli	a4,a5,0x7
    800018dc:	00ea86b3          	add	a3,s5,a4
    800018e0:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffda720>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e4:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018e8:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018ec:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    800018f0:	0721                	addi	a4,a4,8
    800018f2:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    800018f4:	00012497          	auipc	s1,0x12
    800018f8:	20c48493          	addi	s1,s1,524 # 80013b00 <proc>
        if (p->state == RUNNABLE)
    800018fc:	498d                	li	s3,3
            p->state = RUNNING;
    800018fe:	4b11                	li	s6,4
            c->proc = p;
    80001900:	079e                	slli	a5,a5,0x7
    80001902:	00012a17          	auipc	s4,0x12
    80001906:	dcea0a13          	addi	s4,s4,-562 # 800136d0 <cpus>
    8000190a:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    8000190c:	00018917          	auipc	s2,0x18
    80001910:	bf490913          	addi	s2,s2,-1036 # 80019500 <tickslock>
    80001914:	a811                	j	80001928 <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    80001916:	8526                	mv	a0,s1
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	3d4080e7          	jalr	980(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001920:	16848493          	addi	s1,s1,360
    80001924:	03248863          	beq	s1,s2,80001954 <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	30e080e7          	jalr	782(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    80001932:	4c9c                	lw	a5,24(s1)
    80001934:	ff3791e3          	bne	a5,s3,80001916 <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001938:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    8000193c:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    80001940:	06048593          	addi	a1,s1,96
    80001944:	8556                	mv	a0,s5
    80001946:	00001097          	auipc	ra,0x1
    8000194a:	ff6080e7          	jalr	-10(ra) # 8000293c <swtch>
            c->proc = 0;
    8000194e:	000a3023          	sd	zero,0(s4)
    80001952:	b7d1                	j	80001916 <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    80001954:	70e2                	ld	ra,56(sp)
    80001956:	7442                	ld	s0,48(sp)
    80001958:	74a2                	ld	s1,40(sp)
    8000195a:	7902                	ld	s2,32(sp)
    8000195c:	69e2                	ld	s3,24(sp)
    8000195e:	6a42                	ld	s4,16(sp)
    80001960:	6aa2                	ld	s5,8(sp)
    80001962:	6b02                	ld	s6,0(sp)
    80001964:	6121                	addi	sp,sp,64
    80001966:	8082                	ret

0000000080001968 <proc_mapstacks>:
{
    80001968:	7139                	addi	sp,sp,-64
    8000196a:	fc06                	sd	ra,56(sp)
    8000196c:	f822                	sd	s0,48(sp)
    8000196e:	f426                	sd	s1,40(sp)
    80001970:	f04a                	sd	s2,32(sp)
    80001972:	ec4e                	sd	s3,24(sp)
    80001974:	e852                	sd	s4,16(sp)
    80001976:	e456                	sd	s5,8(sp)
    80001978:	e05a                	sd	s6,0(sp)
    8000197a:	0080                	addi	s0,sp,64
    8000197c:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    8000197e:	00012497          	auipc	s1,0x12
    80001982:	18248493          	addi	s1,s1,386 # 80013b00 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001986:	8b26                	mv	s6,s1
    80001988:	04fa5937          	lui	s2,0x4fa5
    8000198c:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001990:	0932                	slli	s2,s2,0xc
    80001992:	fa590913          	addi	s2,s2,-91
    80001996:	0932                	slli	s2,s2,0xc
    80001998:	fa590913          	addi	s2,s2,-91
    8000199c:	0932                	slli	s2,s2,0xc
    8000199e:	fa590913          	addi	s2,s2,-91
    800019a2:	040009b7          	lui	s3,0x4000
    800019a6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800019a8:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    800019aa:	00018a97          	auipc	s5,0x18
    800019ae:	b56a8a93          	addi	s5,s5,-1194 # 80019500 <tickslock>
        char *pa = kalloc();
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	196080e7          	jalr	406(ra) # 80000b48 <kalloc>
    800019ba:	862a                	mv	a2,a0
        if (pa == 0)
    800019bc:	c121                	beqz	a0,800019fc <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    800019be:	416485b3          	sub	a1,s1,s6
    800019c2:	858d                	srai	a1,a1,0x3
    800019c4:	032585b3          	mul	a1,a1,s2
    800019c8:	2585                	addiw	a1,a1,1
    800019ca:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019ce:	4719                	li	a4,6
    800019d0:	6685                	lui	a3,0x1
    800019d2:	40b985b3          	sub	a1,s3,a1
    800019d6:	8552                	mv	a0,s4
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	7c0080e7          	jalr	1984(ra) # 80001198 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    800019e0:	16848493          	addi	s1,s1,360
    800019e4:	fd5497e3          	bne	s1,s5,800019b2 <proc_mapstacks+0x4a>
}
    800019e8:	70e2                	ld	ra,56(sp)
    800019ea:	7442                	ld	s0,48(sp)
    800019ec:	74a2                	ld	s1,40(sp)
    800019ee:	7902                	ld	s2,32(sp)
    800019f0:	69e2                	ld	s3,24(sp)
    800019f2:	6a42                	ld	s4,16(sp)
    800019f4:	6aa2                	ld	s5,8(sp)
    800019f6:	6b02                	ld	s6,0(sp)
    800019f8:	6121                	addi	sp,sp,64
    800019fa:	8082                	ret
            panic("kalloc");
    800019fc:	00006517          	auipc	a0,0x6
    80001a00:	7bc50513          	addi	a0,a0,1980 # 800081b8 <etext+0x1b8>
    80001a04:	fffff097          	auipc	ra,0xfffff
    80001a08:	b5c080e7          	jalr	-1188(ra) # 80000560 <panic>

0000000080001a0c <procinit>:
{
    80001a0c:	7139                	addi	sp,sp,-64
    80001a0e:	fc06                	sd	ra,56(sp)
    80001a10:	f822                	sd	s0,48(sp)
    80001a12:	f426                	sd	s1,40(sp)
    80001a14:	f04a                	sd	s2,32(sp)
    80001a16:	ec4e                	sd	s3,24(sp)
    80001a18:	e852                	sd	s4,16(sp)
    80001a1a:	e456                	sd	s5,8(sp)
    80001a1c:	e05a                	sd	s6,0(sp)
    80001a1e:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001a20:	00006597          	auipc	a1,0x6
    80001a24:	7a058593          	addi	a1,a1,1952 # 800081c0 <etext+0x1c0>
    80001a28:	00012517          	auipc	a0,0x12
    80001a2c:	0a850513          	addi	a0,a0,168 # 80013ad0 <pid_lock>
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	178080e7          	jalr	376(ra) # 80000ba8 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001a38:	00006597          	auipc	a1,0x6
    80001a3c:	79058593          	addi	a1,a1,1936 # 800081c8 <etext+0x1c8>
    80001a40:	00012517          	auipc	a0,0x12
    80001a44:	0a850513          	addi	a0,a0,168 # 80013ae8 <wait_lock>
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	160080e7          	jalr	352(ra) # 80000ba8 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a50:	00012497          	auipc	s1,0x12
    80001a54:	0b048493          	addi	s1,s1,176 # 80013b00 <proc>
        initlock(&p->lock, "proc");
    80001a58:	00006b17          	auipc	s6,0x6
    80001a5c:	780b0b13          	addi	s6,s6,1920 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001a60:	8aa6                	mv	s5,s1
    80001a62:	04fa5937          	lui	s2,0x4fa5
    80001a66:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001a6a:	0932                	slli	s2,s2,0xc
    80001a6c:	fa590913          	addi	s2,s2,-91
    80001a70:	0932                	slli	s2,s2,0xc
    80001a72:	fa590913          	addi	s2,s2,-91
    80001a76:	0932                	slli	s2,s2,0xc
    80001a78:	fa590913          	addi	s2,s2,-91
    80001a7c:	040009b7          	lui	s3,0x4000
    80001a80:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a82:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001a84:	00018a17          	auipc	s4,0x18
    80001a88:	a7ca0a13          	addi	s4,s4,-1412 # 80019500 <tickslock>
        initlock(&p->lock, "proc");
    80001a8c:	85da                	mv	a1,s6
    80001a8e:	8526                	mv	a0,s1
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	118080e7          	jalr	280(ra) # 80000ba8 <initlock>
        p->state = UNUSED;
    80001a98:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001a9c:	415487b3          	sub	a5,s1,s5
    80001aa0:	878d                	srai	a5,a5,0x3
    80001aa2:	032787b3          	mul	a5,a5,s2
    80001aa6:	2785                	addiw	a5,a5,1
    80001aa8:	00d7979b          	slliw	a5,a5,0xd
    80001aac:	40f987b3          	sub	a5,s3,a5
    80001ab0:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001ab2:	16848493          	addi	s1,s1,360
    80001ab6:	fd449be3          	bne	s1,s4,80001a8c <procinit+0x80>
}
    80001aba:	70e2                	ld	ra,56(sp)
    80001abc:	7442                	ld	s0,48(sp)
    80001abe:	74a2                	ld	s1,40(sp)
    80001ac0:	7902                	ld	s2,32(sp)
    80001ac2:	69e2                	ld	s3,24(sp)
    80001ac4:	6a42                	ld	s4,16(sp)
    80001ac6:	6aa2                	ld	s5,8(sp)
    80001ac8:	6b02                	ld	s6,0(sp)
    80001aca:	6121                	addi	sp,sp,64
    80001acc:	8082                	ret

0000000080001ace <copy_array>:
{
    80001ace:	1141                	addi	sp,sp,-16
    80001ad0:	e422                	sd	s0,8(sp)
    80001ad2:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001ad4:	00c05c63          	blez	a2,80001aec <copy_array+0x1e>
    80001ad8:	87aa                	mv	a5,a0
    80001ada:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001adc:	0007c703          	lbu	a4,0(a5)
    80001ae0:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001ae4:	0785                	addi	a5,a5,1
    80001ae6:	0585                	addi	a1,a1,1
    80001ae8:	fea79ae3          	bne	a5,a0,80001adc <copy_array+0xe>
}
    80001aec:	6422                	ld	s0,8(sp)
    80001aee:	0141                	addi	sp,sp,16
    80001af0:	8082                	ret

0000000080001af2 <cpuid>:
{
    80001af2:	1141                	addi	sp,sp,-16
    80001af4:	e422                	sd	s0,8(sp)
    80001af6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001af8:	8512                	mv	a0,tp
}
    80001afa:	2501                	sext.w	a0,a0
    80001afc:	6422                	ld	s0,8(sp)
    80001afe:	0141                	addi	sp,sp,16
    80001b00:	8082                	ret

0000000080001b02 <mycpu>:
{
    80001b02:	1141                	addi	sp,sp,-16
    80001b04:	e422                	sd	s0,8(sp)
    80001b06:	0800                	addi	s0,sp,16
    80001b08:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001b0a:	2781                	sext.w	a5,a5
    80001b0c:	079e                	slli	a5,a5,0x7
}
    80001b0e:	00012517          	auipc	a0,0x12
    80001b12:	bc250513          	addi	a0,a0,-1086 # 800136d0 <cpus>
    80001b16:	953e                	add	a0,a0,a5
    80001b18:	6422                	ld	s0,8(sp)
    80001b1a:	0141                	addi	sp,sp,16
    80001b1c:	8082                	ret

0000000080001b1e <myproc>:
{
    80001b1e:	1101                	addi	sp,sp,-32
    80001b20:	ec06                	sd	ra,24(sp)
    80001b22:	e822                	sd	s0,16(sp)
    80001b24:	e426                	sd	s1,8(sp)
    80001b26:	1000                	addi	s0,sp,32
    push_off();
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	0c4080e7          	jalr	196(ra) # 80000bec <push_off>
    80001b30:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001b32:	2781                	sext.w	a5,a5
    80001b34:	079e                	slli	a5,a5,0x7
    80001b36:	00012717          	auipc	a4,0x12
    80001b3a:	b9a70713          	addi	a4,a4,-1126 # 800136d0 <cpus>
    80001b3e:	97ba                	add	a5,a5,a4
    80001b40:	6384                	ld	s1,0(a5)
    pop_off();
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	14a080e7          	jalr	330(ra) # 80000c8c <pop_off>
}
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	60e2                	ld	ra,24(sp)
    80001b4e:	6442                	ld	s0,16(sp)
    80001b50:	64a2                	ld	s1,8(sp)
    80001b52:	6105                	addi	sp,sp,32
    80001b54:	8082                	ret

0000000080001b56 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001b56:	1141                	addi	sp,sp,-16
    80001b58:	e406                	sd	ra,8(sp)
    80001b5a:	e022                	sd	s0,0(sp)
    80001b5c:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001b5e:	00000097          	auipc	ra,0x0
    80001b62:	fc0080e7          	jalr	-64(ra) # 80001b1e <myproc>
    80001b66:	fffff097          	auipc	ra,0xfffff
    80001b6a:	186080e7          	jalr	390(ra) # 80000cec <release>

    if (first)
    80001b6e:	0000a797          	auipc	a5,0xa
    80001b72:	8227a783          	lw	a5,-2014(a5) # 8000b390 <first.1>
    80001b76:	eb89                	bnez	a5,80001b88 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001b78:	00001097          	auipc	ra,0x1
    80001b7c:	e6e080e7          	jalr	-402(ra) # 800029e6 <usertrapret>
}
    80001b80:	60a2                	ld	ra,8(sp)
    80001b82:	6402                	ld	s0,0(sp)
    80001b84:	0141                	addi	sp,sp,16
    80001b86:	8082                	ret
        first = 0;
    80001b88:	0000a797          	auipc	a5,0xa
    80001b8c:	8007a423          	sw	zero,-2040(a5) # 8000b390 <first.1>
        fsinit(ROOTDEV);
    80001b90:	4505                	li	a0,1
    80001b92:	00002097          	auipc	ra,0x2
    80001b96:	c72080e7          	jalr	-910(ra) # 80003804 <fsinit>
    80001b9a:	bff9                	j	80001b78 <forkret+0x22>

0000000080001b9c <allocpid>:
{
    80001b9c:	1101                	addi	sp,sp,-32
    80001b9e:	ec06                	sd	ra,24(sp)
    80001ba0:	e822                	sd	s0,16(sp)
    80001ba2:	e426                	sd	s1,8(sp)
    80001ba4:	e04a                	sd	s2,0(sp)
    80001ba6:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001ba8:	00012917          	auipc	s2,0x12
    80001bac:	f2890913          	addi	s2,s2,-216 # 80013ad0 <pid_lock>
    80001bb0:	854a                	mv	a0,s2
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	086080e7          	jalr	134(ra) # 80000c38 <acquire>
    pid = nextpid;
    80001bba:	00009797          	auipc	a5,0x9
    80001bbe:	7e678793          	addi	a5,a5,2022 # 8000b3a0 <nextpid>
    80001bc2:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001bc4:	0014871b          	addiw	a4,s1,1
    80001bc8:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001bca:	854a                	mv	a0,s2
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	120080e7          	jalr	288(ra) # 80000cec <release>
}
    80001bd4:	8526                	mv	a0,s1
    80001bd6:	60e2                	ld	ra,24(sp)
    80001bd8:	6442                	ld	s0,16(sp)
    80001bda:	64a2                	ld	s1,8(sp)
    80001bdc:	6902                	ld	s2,0(sp)
    80001bde:	6105                	addi	sp,sp,32
    80001be0:	8082                	ret

0000000080001be2 <proc_pagetable>:
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	e426                	sd	s1,8(sp)
    80001bea:	e04a                	sd	s2,0(sp)
    80001bec:	1000                	addi	s0,sp,32
    80001bee:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001bf0:	fffff097          	auipc	ra,0xfffff
    80001bf4:	7a2080e7          	jalr	1954(ra) # 80001392 <uvmcreate>
    80001bf8:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001bfa:	c121                	beqz	a0,80001c3a <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bfc:	4729                	li	a4,10
    80001bfe:	00005697          	auipc	a3,0x5
    80001c02:	40268693          	addi	a3,a3,1026 # 80007000 <_trampoline>
    80001c06:	6605                	lui	a2,0x1
    80001c08:	040005b7          	lui	a1,0x4000
    80001c0c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c0e:	05b2                	slli	a1,a1,0xc
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	4e8080e7          	jalr	1256(ra) # 800010f8 <mappages>
    80001c18:	02054863          	bltz	a0,80001c48 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c1c:	4719                	li	a4,6
    80001c1e:	05893683          	ld	a3,88(s2)
    80001c22:	6605                	lui	a2,0x1
    80001c24:	020005b7          	lui	a1,0x2000
    80001c28:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c2a:	05b6                	slli	a1,a1,0xd
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	fffff097          	auipc	ra,0xfffff
    80001c32:	4ca080e7          	jalr	1226(ra) # 800010f8 <mappages>
    80001c36:	02054163          	bltz	a0,80001c58 <proc_pagetable+0x76>
}
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6902                	ld	s2,0(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
        uvmfree(pagetable, 0);
    80001c48:	4581                	li	a1,0
    80001c4a:	8526                	mv	a0,s1
    80001c4c:	00000097          	auipc	ra,0x0
    80001c50:	958080e7          	jalr	-1704(ra) # 800015a4 <uvmfree>
        return 0;
    80001c54:	4481                	li	s1,0
    80001c56:	b7d5                	j	80001c3a <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c58:	4681                	li	a3,0
    80001c5a:	4605                	li	a2,1
    80001c5c:	040005b7          	lui	a1,0x4000
    80001c60:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c62:	05b2                	slli	a1,a1,0xc
    80001c64:	8526                	mv	a0,s1
    80001c66:	fffff097          	auipc	ra,0xfffff
    80001c6a:	658080e7          	jalr	1624(ra) # 800012be <uvmunmap>
        uvmfree(pagetable, 0);
    80001c6e:	4581                	li	a1,0
    80001c70:	8526                	mv	a0,s1
    80001c72:	00000097          	auipc	ra,0x0
    80001c76:	932080e7          	jalr	-1742(ra) # 800015a4 <uvmfree>
        return 0;
    80001c7a:	4481                	li	s1,0
    80001c7c:	bf7d                	j	80001c3a <proc_pagetable+0x58>

0000000080001c7e <proc_freepagetable>:
{
    80001c7e:	1101                	addi	sp,sp,-32
    80001c80:	ec06                	sd	ra,24(sp)
    80001c82:	e822                	sd	s0,16(sp)
    80001c84:	e426                	sd	s1,8(sp)
    80001c86:	e04a                	sd	s2,0(sp)
    80001c88:	1000                	addi	s0,sp,32
    80001c8a:	84aa                	mv	s1,a0
    80001c8c:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c8e:	4681                	li	a3,0
    80001c90:	4605                	li	a2,1
    80001c92:	040005b7          	lui	a1,0x4000
    80001c96:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c98:	05b2                	slli	a1,a1,0xc
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	624080e7          	jalr	1572(ra) # 800012be <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ca2:	4681                	li	a3,0
    80001ca4:	4605                	li	a2,1
    80001ca6:	020005b7          	lui	a1,0x2000
    80001caa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001cac:	05b6                	slli	a1,a1,0xd
    80001cae:	8526                	mv	a0,s1
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	60e080e7          	jalr	1550(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, sz);
    80001cb8:	85ca                	mv	a1,s2
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00000097          	auipc	ra,0x0
    80001cc0:	8e8080e7          	jalr	-1816(ra) # 800015a4 <uvmfree>
}
    80001cc4:	60e2                	ld	ra,24(sp)
    80001cc6:	6442                	ld	s0,16(sp)
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	6902                	ld	s2,0(sp)
    80001ccc:	6105                	addi	sp,sp,32
    80001cce:	8082                	ret

0000000080001cd0 <freeproc>:
{
    80001cd0:	1101                	addi	sp,sp,-32
    80001cd2:	ec06                	sd	ra,24(sp)
    80001cd4:	e822                	sd	s0,16(sp)
    80001cd6:	e426                	sd	s1,8(sp)
    80001cd8:	1000                	addi	s0,sp,32
    80001cda:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001cdc:	6d28                	ld	a0,88(a0)
    80001cde:	c509                	beqz	a0,80001ce8 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	d6a080e7          	jalr	-662(ra) # 80000a4a <kfree>
    p->trapframe = 0;
    80001ce8:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001cec:	68a8                	ld	a0,80(s1)
    80001cee:	c511                	beqz	a0,80001cfa <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001cf0:	64ac                	ld	a1,72(s1)
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	f8c080e7          	jalr	-116(ra) # 80001c7e <proc_freepagetable>
    p->pagetable = 0;
    80001cfa:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001cfe:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001d02:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001d06:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001d0a:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001d0e:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001d12:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001d16:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001d1a:	0004ac23          	sw	zero,24(s1)
}
    80001d1e:	60e2                	ld	ra,24(sp)
    80001d20:	6442                	ld	s0,16(sp)
    80001d22:	64a2                	ld	s1,8(sp)
    80001d24:	6105                	addi	sp,sp,32
    80001d26:	8082                	ret

0000000080001d28 <allocproc>:
{
    80001d28:	1101                	addi	sp,sp,-32
    80001d2a:	ec06                	sd	ra,24(sp)
    80001d2c:	e822                	sd	s0,16(sp)
    80001d2e:	e426                	sd	s1,8(sp)
    80001d30:	e04a                	sd	s2,0(sp)
    80001d32:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001d34:	00012497          	auipc	s1,0x12
    80001d38:	dcc48493          	addi	s1,s1,-564 # 80013b00 <proc>
    80001d3c:	00017917          	auipc	s2,0x17
    80001d40:	7c490913          	addi	s2,s2,1988 # 80019500 <tickslock>
        acquire(&p->lock);
    80001d44:	8526                	mv	a0,s1
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	ef2080e7          	jalr	-270(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    80001d4e:	4c9c                	lw	a5,24(s1)
    80001d50:	cf81                	beqz	a5,80001d68 <allocproc+0x40>
            release(&p->lock);
    80001d52:	8526                	mv	a0,s1
    80001d54:	fffff097          	auipc	ra,0xfffff
    80001d58:	f98080e7          	jalr	-104(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d5c:	16848493          	addi	s1,s1,360
    80001d60:	ff2492e3          	bne	s1,s2,80001d44 <allocproc+0x1c>
    return 0;
    80001d64:	4481                	li	s1,0
    80001d66:	a889                	j	80001db8 <allocproc+0x90>
    p->pid = allocpid();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	e34080e7          	jalr	-460(ra) # 80001b9c <allocpid>
    80001d70:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001d72:	4785                	li	a5,1
    80001d74:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	dd2080e7          	jalr	-558(ra) # 80000b48 <kalloc>
    80001d7e:	892a                	mv	s2,a0
    80001d80:	eca8                	sd	a0,88(s1)
    80001d82:	c131                	beqz	a0,80001dc6 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001d84:	8526                	mv	a0,s1
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	e5c080e7          	jalr	-420(ra) # 80001be2 <proc_pagetable>
    80001d8e:	892a                	mv	s2,a0
    80001d90:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001d92:	c531                	beqz	a0,80001dde <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001d94:	07000613          	li	a2,112
    80001d98:	4581                	li	a1,0
    80001d9a:	06048513          	addi	a0,s1,96
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	f96080e7          	jalr	-106(ra) # 80000d34 <memset>
    p->context.ra = (uint64)forkret;
    80001da6:	00000797          	auipc	a5,0x0
    80001daa:	db078793          	addi	a5,a5,-592 # 80001b56 <forkret>
    80001dae:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001db0:	60bc                	ld	a5,64(s1)
    80001db2:	6705                	lui	a4,0x1
    80001db4:	97ba                	add	a5,a5,a4
    80001db6:	f4bc                	sd	a5,104(s1)
}
    80001db8:	8526                	mv	a0,s1
    80001dba:	60e2                	ld	ra,24(sp)
    80001dbc:	6442                	ld	s0,16(sp)
    80001dbe:	64a2                	ld	s1,8(sp)
    80001dc0:	6902                	ld	s2,0(sp)
    80001dc2:	6105                	addi	sp,sp,32
    80001dc4:	8082                	ret
        freeproc(p);
    80001dc6:	8526                	mv	a0,s1
    80001dc8:	00000097          	auipc	ra,0x0
    80001dcc:	f08080e7          	jalr	-248(ra) # 80001cd0 <freeproc>
        release(&p->lock);
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	f1a080e7          	jalr	-230(ra) # 80000cec <release>
        return 0;
    80001dda:	84ca                	mv	s1,s2
    80001ddc:	bff1                	j	80001db8 <allocproc+0x90>
        freeproc(p);
    80001dde:	8526                	mv	a0,s1
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	ef0080e7          	jalr	-272(ra) # 80001cd0 <freeproc>
        release(&p->lock);
    80001de8:	8526                	mv	a0,s1
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	f02080e7          	jalr	-254(ra) # 80000cec <release>
        return 0;
    80001df2:	84ca                	mv	s1,s2
    80001df4:	b7d1                	j	80001db8 <allocproc+0x90>

0000000080001df6 <userinit>:
{
    80001df6:	1101                	addi	sp,sp,-32
    80001df8:	ec06                	sd	ra,24(sp)
    80001dfa:	e822                	sd	s0,16(sp)
    80001dfc:	e426                	sd	s1,8(sp)
    80001dfe:	1000                	addi	s0,sp,32
    p = allocproc();
    80001e00:	00000097          	auipc	ra,0x0
    80001e04:	f28080e7          	jalr	-216(ra) # 80001d28 <allocproc>
    80001e08:	84aa                	mv	s1,a0
    initproc = p;
    80001e0a:	00009797          	auipc	a5,0x9
    80001e0e:	64a7b723          	sd	a0,1614(a5) # 8000b458 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001e12:	03400613          	li	a2,52
    80001e16:	00009597          	auipc	a1,0x9
    80001e1a:	59a58593          	addi	a1,a1,1434 # 8000b3b0 <initcode>
    80001e1e:	6928                	ld	a0,80(a0)
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	5a0080e7          	jalr	1440(ra) # 800013c0 <uvmfirst>
    p->sz = PGSIZE;
    80001e28:	6785                	lui	a5,0x1
    80001e2a:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001e2c:	6cb8                	ld	a4,88(s1)
    80001e2e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001e32:	6cb8                	ld	a4,88(s1)
    80001e34:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e36:	4641                	li	a2,16
    80001e38:	00006597          	auipc	a1,0x6
    80001e3c:	3a858593          	addi	a1,a1,936 # 800081e0 <etext+0x1e0>
    80001e40:	15848513          	addi	a0,s1,344
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	032080e7          	jalr	50(ra) # 80000e76 <safestrcpy>
    p->cwd = namei("/");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	3a450513          	addi	a0,a0,932 # 800081f0 <etext+0x1f0>
    80001e54:	00002097          	auipc	ra,0x2
    80001e58:	402080e7          	jalr	1026(ra) # 80004256 <namei>
    80001e5c:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001e60:	478d                	li	a5,3
    80001e62:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001e64:	8526                	mv	a0,s1
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	e86080e7          	jalr	-378(ra) # 80000cec <release>
}
    80001e6e:	60e2                	ld	ra,24(sp)
    80001e70:	6442                	ld	s0,16(sp)
    80001e72:	64a2                	ld	s1,8(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret

0000000080001e78 <growproc>:
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	e04a                	sd	s2,0(sp)
    80001e82:	1000                	addi	s0,sp,32
    80001e84:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	c98080e7          	jalr	-872(ra) # 80001b1e <myproc>
    80001e8e:	84aa                	mv	s1,a0
    sz = p->sz;
    80001e90:	652c                	ld	a1,72(a0)
    if (n > 0)
    80001e92:	01204c63          	bgtz	s2,80001eaa <growproc+0x32>
    else if (n < 0)
    80001e96:	02094663          	bltz	s2,80001ec2 <growproc+0x4a>
    p->sz = sz;
    80001e9a:	e4ac                	sd	a1,72(s1)
    return 0;
    80001e9c:	4501                	li	a0,0
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6902                	ld	s2,0(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001eaa:	4691                	li	a3,4
    80001eac:	00b90633          	add	a2,s2,a1
    80001eb0:	6928                	ld	a0,80(a0)
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	5c8080e7          	jalr	1480(ra) # 8000147a <uvmalloc>
    80001eba:	85aa                	mv	a1,a0
    80001ebc:	fd79                	bnez	a0,80001e9a <growproc+0x22>
            return -1;
    80001ebe:	557d                	li	a0,-1
    80001ec0:	bff9                	j	80001e9e <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ec2:	00b90633          	add	a2,s2,a1
    80001ec6:	6928                	ld	a0,80(a0)
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	56a080e7          	jalr	1386(ra) # 80001432 <uvmdealloc>
    80001ed0:	85aa                	mv	a1,a0
    80001ed2:	b7e1                	j	80001e9a <growproc+0x22>

0000000080001ed4 <ps>:
{
    80001ed4:	715d                	addi	sp,sp,-80
    80001ed6:	e486                	sd	ra,72(sp)
    80001ed8:	e0a2                	sd	s0,64(sp)
    80001eda:	fc26                	sd	s1,56(sp)
    80001edc:	f84a                	sd	s2,48(sp)
    80001ede:	f44e                	sd	s3,40(sp)
    80001ee0:	f052                	sd	s4,32(sp)
    80001ee2:	ec56                	sd	s5,24(sp)
    80001ee4:	e85a                	sd	s6,16(sp)
    80001ee6:	e45e                	sd	s7,8(sp)
    80001ee8:	e062                	sd	s8,0(sp)
    80001eea:	0880                	addi	s0,sp,80
    80001eec:	84aa                	mv	s1,a0
    80001eee:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	c2e080e7          	jalr	-978(ra) # 80001b1e <myproc>
        return result;
    80001ef8:	4901                	li	s2,0
    if (count == 0)
    80001efa:	0c0b8663          	beqz	s7,80001fc6 <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80001efe:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80001f02:	003b951b          	slliw	a0,s7,0x3
    80001f06:	0175053b          	addw	a0,a0,s7
    80001f0a:	0025151b          	slliw	a0,a0,0x2
    80001f0e:	2501                	sext.w	a0,a0
    80001f10:	00000097          	auipc	ra,0x0
    80001f14:	f68080e7          	jalr	-152(ra) # 80001e78 <growproc>
    80001f18:	12054f63          	bltz	a0,80002056 <ps+0x182>
    struct user_proc loc_result[count];
    80001f1c:	003b9a13          	slli	s4,s7,0x3
    80001f20:	9a5e                	add	s4,s4,s7
    80001f22:	0a0a                	slli	s4,s4,0x2
    80001f24:	00fa0793          	addi	a5,s4,15
    80001f28:	8391                	srli	a5,a5,0x4
    80001f2a:	0792                	slli	a5,a5,0x4
    80001f2c:	40f10133          	sub	sp,sp,a5
    80001f30:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    80001f32:	16800793          	li	a5,360
    80001f36:	02f484b3          	mul	s1,s1,a5
    80001f3a:	00012797          	auipc	a5,0x12
    80001f3e:	bc678793          	addi	a5,a5,-1082 # 80013b00 <proc>
    80001f42:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80001f44:	00017797          	auipc	a5,0x17
    80001f48:	5bc78793          	addi	a5,a5,1468 # 80019500 <tickslock>
        return result;
    80001f4c:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80001f4e:	06f4fc63          	bgeu	s1,a5,80001fc6 <ps+0xf2>
    acquire(&wait_lock);
    80001f52:	00012517          	auipc	a0,0x12
    80001f56:	b9650513          	addi	a0,a0,-1130 # 80013ae8 <wait_lock>
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	cde080e7          	jalr	-802(ra) # 80000c38 <acquire>
        if (localCount == count)
    80001f62:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    80001f66:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80001f68:	00017c17          	auipc	s8,0x17
    80001f6c:	598c0c13          	addi	s8,s8,1432 # 80019500 <tickslock>
    80001f70:	a851                	j	80002004 <ps+0x130>
            loc_result[localCount].state = UNUSED;
    80001f72:	00399793          	slli	a5,s3,0x3
    80001f76:	97ce                	add	a5,a5,s3
    80001f78:	078a                	slli	a5,a5,0x2
    80001f7a:	97d6                	add	a5,a5,s5
    80001f7c:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80001f80:	8526                	mv	a0,s1
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	d6a080e7          	jalr	-662(ra) # 80000cec <release>
    release(&wait_lock);
    80001f8a:	00012517          	auipc	a0,0x12
    80001f8e:	b5e50513          	addi	a0,a0,-1186 # 80013ae8 <wait_lock>
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	d5a080e7          	jalr	-678(ra) # 80000cec <release>
    if (localCount < count)
    80001f9a:	0179f963          	bgeu	s3,s7,80001fac <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80001f9e:	00399793          	slli	a5,s3,0x3
    80001fa2:	97ce                	add	a5,a5,s3
    80001fa4:	078a                	slli	a5,a5,0x2
    80001fa6:	97d6                	add	a5,a5,s5
    80001fa8:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80001fac:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	b70080e7          	jalr	-1168(ra) # 80001b1e <myproc>
    80001fb6:	86d2                	mv	a3,s4
    80001fb8:	8656                	mv	a2,s5
    80001fba:	85da                	mv	a1,s6
    80001fbc:	6928                	ld	a0,80(a0)
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	724080e7          	jalr	1828(ra) # 800016e2 <copyout>
}
    80001fc6:	854a                	mv	a0,s2
    80001fc8:	fb040113          	addi	sp,s0,-80
    80001fcc:	60a6                	ld	ra,72(sp)
    80001fce:	6406                	ld	s0,64(sp)
    80001fd0:	74e2                	ld	s1,56(sp)
    80001fd2:	7942                	ld	s2,48(sp)
    80001fd4:	79a2                	ld	s3,40(sp)
    80001fd6:	7a02                	ld	s4,32(sp)
    80001fd8:	6ae2                	ld	s5,24(sp)
    80001fda:	6b42                	ld	s6,16(sp)
    80001fdc:	6ba2                	ld	s7,8(sp)
    80001fde:	6c02                	ld	s8,0(sp)
    80001fe0:	6161                	addi	sp,sp,80
    80001fe2:	8082                	ret
        release(&p->lock);
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	d06080e7          	jalr	-762(ra) # 80000cec <release>
        localCount++;
    80001fee:	2985                	addiw	s3,s3,1
    80001ff0:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    80001ff4:	16848493          	addi	s1,s1,360
    80001ff8:	f984f9e3          	bgeu	s1,s8,80001f8a <ps+0xb6>
        if (localCount == count)
    80001ffc:	02490913          	addi	s2,s2,36
    80002000:	053b8d63          	beq	s7,s3,8000205a <ps+0x186>
        acquire(&p->lock);
    80002004:	8526                	mv	a0,s1
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	c32080e7          	jalr	-974(ra) # 80000c38 <acquire>
        if (p->state == UNUSED)
    8000200e:	4c9c                	lw	a5,24(s1)
    80002010:	d3ad                	beqz	a5,80001f72 <ps+0x9e>
        loc_result[localCount].state = p->state;
    80002012:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    80002016:	549c                	lw	a5,40(s1)
    80002018:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    8000201c:	54dc                	lw	a5,44(s1)
    8000201e:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    80002022:	589c                	lw	a5,48(s1)
    80002024:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002028:	4641                	li	a2,16
    8000202a:	85ca                	mv	a1,s2
    8000202c:	15848513          	addi	a0,s1,344
    80002030:	00000097          	auipc	ra,0x0
    80002034:	a9e080e7          	jalr	-1378(ra) # 80001ace <copy_array>
        if (p->parent != 0) // init
    80002038:	7c88                	ld	a0,56(s1)
    8000203a:	d54d                	beqz	a0,80001fe4 <ps+0x110>
            acquire(&p->parent->lock);
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	bfc080e7          	jalr	-1028(ra) # 80000c38 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80002044:	7c88                	ld	a0,56(s1)
    80002046:	591c                	lw	a5,48(a0)
    80002048:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	ca0080e7          	jalr	-864(ra) # 80000cec <release>
    80002054:	bf41                	j	80001fe4 <ps+0x110>
        return result;
    80002056:	4901                	li	s2,0
    80002058:	b7bd                	j	80001fc6 <ps+0xf2>
    release(&wait_lock);
    8000205a:	00012517          	auipc	a0,0x12
    8000205e:	a8e50513          	addi	a0,a0,-1394 # 80013ae8 <wait_lock>
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	c8a080e7          	jalr	-886(ra) # 80000cec <release>
    if (localCount < count)
    8000206a:	b789                	j	80001fac <ps+0xd8>

000000008000206c <fork>:
{
    8000206c:	7139                	addi	sp,sp,-64
    8000206e:	fc06                	sd	ra,56(sp)
    80002070:	f822                	sd	s0,48(sp)
    80002072:	f04a                	sd	s2,32(sp)
    80002074:	e456                	sd	s5,8(sp)
    80002076:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	aa6080e7          	jalr	-1370(ra) # 80001b1e <myproc>
    80002080:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002082:	00000097          	auipc	ra,0x0
    80002086:	ca6080e7          	jalr	-858(ra) # 80001d28 <allocproc>
    8000208a:	12050063          	beqz	a0,800021aa <fork+0x13e>
    8000208e:	e852                	sd	s4,16(sp)
    80002090:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002092:	048ab603          	ld	a2,72(s5)
    80002096:	692c                	ld	a1,80(a0)
    80002098:	050ab503          	ld	a0,80(s5)
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	542080e7          	jalr	1346(ra) # 800015de <uvmcopy>
    800020a4:	04054a63          	bltz	a0,800020f8 <fork+0x8c>
    800020a8:	f426                	sd	s1,40(sp)
    800020aa:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800020ac:	048ab783          	ld	a5,72(s5)
    800020b0:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800020b4:	058ab683          	ld	a3,88(s5)
    800020b8:	87b6                	mv	a5,a3
    800020ba:	058a3703          	ld	a4,88(s4)
    800020be:	12068693          	addi	a3,a3,288
    800020c2:	0007b803          	ld	a6,0(a5)
    800020c6:	6788                	ld	a0,8(a5)
    800020c8:	6b8c                	ld	a1,16(a5)
    800020ca:	6f90                	ld	a2,24(a5)
    800020cc:	01073023          	sd	a6,0(a4)
    800020d0:	e708                	sd	a0,8(a4)
    800020d2:	eb0c                	sd	a1,16(a4)
    800020d4:	ef10                	sd	a2,24(a4)
    800020d6:	02078793          	addi	a5,a5,32
    800020da:	02070713          	addi	a4,a4,32
    800020de:	fed792e3          	bne	a5,a3,800020c2 <fork+0x56>
    np->trapframe->a0 = 0;
    800020e2:	058a3783          	ld	a5,88(s4)
    800020e6:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800020ea:	0d0a8493          	addi	s1,s5,208
    800020ee:	0d0a0913          	addi	s2,s4,208
    800020f2:	150a8993          	addi	s3,s5,336
    800020f6:	a015                	j	8000211a <fork+0xae>
        freeproc(np);
    800020f8:	8552                	mv	a0,s4
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	bd6080e7          	jalr	-1066(ra) # 80001cd0 <freeproc>
        release(&np->lock);
    80002102:	8552                	mv	a0,s4
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	be8080e7          	jalr	-1048(ra) # 80000cec <release>
        return -1;
    8000210c:	597d                	li	s2,-1
    8000210e:	6a42                	ld	s4,16(sp)
    80002110:	a071                	j	8000219c <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002112:	04a1                	addi	s1,s1,8
    80002114:	0921                	addi	s2,s2,8
    80002116:	01348b63          	beq	s1,s3,8000212c <fork+0xc0>
        if (p->ofile[i])
    8000211a:	6088                	ld	a0,0(s1)
    8000211c:	d97d                	beqz	a0,80002112 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    8000211e:	00002097          	auipc	ra,0x2
    80002122:	7b0080e7          	jalr	1968(ra) # 800048ce <filedup>
    80002126:	00a93023          	sd	a0,0(s2)
    8000212a:	b7e5                	j	80002112 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000212c:	150ab503          	ld	a0,336(s5)
    80002130:	00002097          	auipc	ra,0x2
    80002134:	91a080e7          	jalr	-1766(ra) # 80003a4a <idup>
    80002138:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000213c:	4641                	li	a2,16
    8000213e:	158a8593          	addi	a1,s5,344
    80002142:	158a0513          	addi	a0,s4,344
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	d30080e7          	jalr	-720(ra) # 80000e76 <safestrcpy>
    pid = np->pid;
    8000214e:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80002152:	8552                	mv	a0,s4
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	b98080e7          	jalr	-1128(ra) # 80000cec <release>
    acquire(&wait_lock);
    8000215c:	00012497          	auipc	s1,0x12
    80002160:	98c48493          	addi	s1,s1,-1652 # 80013ae8 <wait_lock>
    80002164:	8526                	mv	a0,s1
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	ad2080e7          	jalr	-1326(ra) # 80000c38 <acquire>
    np->parent = p;
    8000216e:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    80002172:	8526                	mv	a0,s1
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	b78080e7          	jalr	-1160(ra) # 80000cec <release>
    acquire(&np->lock);
    8000217c:	8552                	mv	a0,s4
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	aba080e7          	jalr	-1350(ra) # 80000c38 <acquire>
    np->state = RUNNABLE;
    80002186:	478d                	li	a5,3
    80002188:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    8000218c:	8552                	mv	a0,s4
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	b5e080e7          	jalr	-1186(ra) # 80000cec <release>
    return pid;
    80002196:	74a2                	ld	s1,40(sp)
    80002198:	69e2                	ld	s3,24(sp)
    8000219a:	6a42                	ld	s4,16(sp)
}
    8000219c:	854a                	mv	a0,s2
    8000219e:	70e2                	ld	ra,56(sp)
    800021a0:	7442                	ld	s0,48(sp)
    800021a2:	7902                	ld	s2,32(sp)
    800021a4:	6aa2                	ld	s5,8(sp)
    800021a6:	6121                	addi	sp,sp,64
    800021a8:	8082                	ret
        return -1;
    800021aa:	597d                	li	s2,-1
    800021ac:	bfc5                	j	8000219c <fork+0x130>

00000000800021ae <scheduler>:
{
    800021ae:	1101                	addi	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	e426                	sd	s1,8(sp)
    800021b6:	e04a                	sd	s2,0(sp)
    800021b8:	1000                	addi	s0,sp,32
    void (*old_scheduler)(void) = sched_pointer;
    800021ba:	00009797          	auipc	a5,0x9
    800021be:	1de7b783          	ld	a5,478(a5) # 8000b398 <sched_pointer>
        if (old_scheduler != sched_pointer)
    800021c2:	00009497          	auipc	s1,0x9
    800021c6:	1d648493          	addi	s1,s1,470 # 8000b398 <sched_pointer>
            printf("Scheduler switched\n");
    800021ca:	00006917          	auipc	s2,0x6
    800021ce:	02e90913          	addi	s2,s2,46 # 800081f8 <etext+0x1f8>
    800021d2:	a809                	j	800021e4 <scheduler+0x36>
    800021d4:	854a                	mv	a0,s2
    800021d6:	ffffe097          	auipc	ra,0xffffe
    800021da:	3d4080e7          	jalr	980(ra) # 800005aa <printf>
        (*sched_pointer)();
    800021de:	609c                	ld	a5,0(s1)
    800021e0:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800021e2:	609c                	ld	a5,0(s1)
        if (old_scheduler != sched_pointer)
    800021e4:	6098                	ld	a4,0(s1)
    800021e6:	fef717e3          	bne	a4,a5,800021d4 <scheduler+0x26>
    800021ea:	bfd5                	j	800021de <scheduler+0x30>

00000000800021ec <sched>:
{
    800021ec:	7179                	addi	sp,sp,-48
    800021ee:	f406                	sd	ra,40(sp)
    800021f0:	f022                	sd	s0,32(sp)
    800021f2:	ec26                	sd	s1,24(sp)
    800021f4:	e84a                	sd	s2,16(sp)
    800021f6:	e44e                	sd	s3,8(sp)
    800021f8:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	924080e7          	jalr	-1756(ra) # 80001b1e <myproc>
    80002202:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	9ba080e7          	jalr	-1606(ra) # 80000bbe <holding>
    8000220c:	c53d                	beqz	a0,8000227a <sched+0x8e>
    8000220e:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002210:	2781                	sext.w	a5,a5
    80002212:	079e                	slli	a5,a5,0x7
    80002214:	00011717          	auipc	a4,0x11
    80002218:	4bc70713          	addi	a4,a4,1212 # 800136d0 <cpus>
    8000221c:	97ba                	add	a5,a5,a4
    8000221e:	5fb8                	lw	a4,120(a5)
    80002220:	4785                	li	a5,1
    80002222:	06f71463          	bne	a4,a5,8000228a <sched+0x9e>
    if (p->state == RUNNING)
    80002226:	4c98                	lw	a4,24(s1)
    80002228:	4791                	li	a5,4
    8000222a:	06f70863          	beq	a4,a5,8000229a <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000222e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002232:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002234:	ebbd                	bnez	a5,800022aa <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002236:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002238:	00011917          	auipc	s2,0x11
    8000223c:	49890913          	addi	s2,s2,1176 # 800136d0 <cpus>
    80002240:	2781                	sext.w	a5,a5
    80002242:	079e                	slli	a5,a5,0x7
    80002244:	97ca                	add	a5,a5,s2
    80002246:	07c7a983          	lw	s3,124(a5)
    8000224a:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000224c:	2581                	sext.w	a1,a1
    8000224e:	059e                	slli	a1,a1,0x7
    80002250:	05a1                	addi	a1,a1,8
    80002252:	95ca                	add	a1,a1,s2
    80002254:	06048513          	addi	a0,s1,96
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	6e4080e7          	jalr	1764(ra) # 8000293c <swtch>
    80002260:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002262:	2781                	sext.w	a5,a5
    80002264:	079e                	slli	a5,a5,0x7
    80002266:	993e                	add	s2,s2,a5
    80002268:	07392e23          	sw	s3,124(s2)
}
    8000226c:	70a2                	ld	ra,40(sp)
    8000226e:	7402                	ld	s0,32(sp)
    80002270:	64e2                	ld	s1,24(sp)
    80002272:	6942                	ld	s2,16(sp)
    80002274:	69a2                	ld	s3,8(sp)
    80002276:	6145                	addi	sp,sp,48
    80002278:	8082                	ret
        panic("sched p->lock");
    8000227a:	00006517          	auipc	a0,0x6
    8000227e:	f9650513          	addi	a0,a0,-106 # 80008210 <etext+0x210>
    80002282:	ffffe097          	auipc	ra,0xffffe
    80002286:	2de080e7          	jalr	734(ra) # 80000560 <panic>
        panic("sched locks");
    8000228a:	00006517          	auipc	a0,0x6
    8000228e:	f9650513          	addi	a0,a0,-106 # 80008220 <etext+0x220>
    80002292:	ffffe097          	auipc	ra,0xffffe
    80002296:	2ce080e7          	jalr	718(ra) # 80000560 <panic>
        panic("sched running");
    8000229a:	00006517          	auipc	a0,0x6
    8000229e:	f9650513          	addi	a0,a0,-106 # 80008230 <etext+0x230>
    800022a2:	ffffe097          	auipc	ra,0xffffe
    800022a6:	2be080e7          	jalr	702(ra) # 80000560 <panic>
        panic("sched interruptible");
    800022aa:	00006517          	auipc	a0,0x6
    800022ae:	f9650513          	addi	a0,a0,-106 # 80008240 <etext+0x240>
    800022b2:	ffffe097          	auipc	ra,0xffffe
    800022b6:	2ae080e7          	jalr	686(ra) # 80000560 <panic>

00000000800022ba <yield>:
{
    800022ba:	1101                	addi	sp,sp,-32
    800022bc:	ec06                	sd	ra,24(sp)
    800022be:	e822                	sd	s0,16(sp)
    800022c0:	e426                	sd	s1,8(sp)
    800022c2:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	85a080e7          	jalr	-1958(ra) # 80001b1e <myproc>
    800022cc:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	96a080e7          	jalr	-1686(ra) # 80000c38 <acquire>
    p->state = RUNNABLE;
    800022d6:	478d                	li	a5,3
    800022d8:	cc9c                	sw	a5,24(s1)
    sched();
    800022da:	00000097          	auipc	ra,0x0
    800022de:	f12080e7          	jalr	-238(ra) # 800021ec <sched>
    release(&p->lock);
    800022e2:	8526                	mv	a0,s1
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	a08080e7          	jalr	-1528(ra) # 80000cec <release>
}
    800022ec:	60e2                	ld	ra,24(sp)
    800022ee:	6442                	ld	s0,16(sp)
    800022f0:	64a2                	ld	s1,8(sp)
    800022f2:	6105                	addi	sp,sp,32
    800022f4:	8082                	ret

00000000800022f6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800022f6:	7179                	addi	sp,sp,-48
    800022f8:	f406                	sd	ra,40(sp)
    800022fa:	f022                	sd	s0,32(sp)
    800022fc:	ec26                	sd	s1,24(sp)
    800022fe:	e84a                	sd	s2,16(sp)
    80002300:	e44e                	sd	s3,8(sp)
    80002302:	1800                	addi	s0,sp,48
    80002304:	89aa                	mv	s3,a0
    80002306:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	816080e7          	jalr	-2026(ra) # 80001b1e <myproc>
    80002310:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	926080e7          	jalr	-1754(ra) # 80000c38 <acquire>
    release(lk);
    8000231a:	854a                	mv	a0,s2
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	9d0080e7          	jalr	-1584(ra) # 80000cec <release>

    // Go to sleep.
    p->chan = chan;
    80002324:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80002328:	4789                	li	a5,2
    8000232a:	cc9c                	sw	a5,24(s1)

    sched();
    8000232c:	00000097          	auipc	ra,0x0
    80002330:	ec0080e7          	jalr	-320(ra) # 800021ec <sched>

    // Tidy up.
    p->chan = 0;
    80002334:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002338:	8526                	mv	a0,s1
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	9b2080e7          	jalr	-1614(ra) # 80000cec <release>
    acquire(lk);
    80002342:	854a                	mv	a0,s2
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	8f4080e7          	jalr	-1804(ra) # 80000c38 <acquire>
}
    8000234c:	70a2                	ld	ra,40(sp)
    8000234e:	7402                	ld	s0,32(sp)
    80002350:	64e2                	ld	s1,24(sp)
    80002352:	6942                	ld	s2,16(sp)
    80002354:	69a2                	ld	s3,8(sp)
    80002356:	6145                	addi	sp,sp,48
    80002358:	8082                	ret

000000008000235a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000235a:	7139                	addi	sp,sp,-64
    8000235c:	fc06                	sd	ra,56(sp)
    8000235e:	f822                	sd	s0,48(sp)
    80002360:	f426                	sd	s1,40(sp)
    80002362:	f04a                	sd	s2,32(sp)
    80002364:	ec4e                	sd	s3,24(sp)
    80002366:	e852                	sd	s4,16(sp)
    80002368:	e456                	sd	s5,8(sp)
    8000236a:	0080                	addi	s0,sp,64
    8000236c:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000236e:	00011497          	auipc	s1,0x11
    80002372:	79248493          	addi	s1,s1,1938 # 80013b00 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002376:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002378:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000237a:	00017917          	auipc	s2,0x17
    8000237e:	18690913          	addi	s2,s2,390 # 80019500 <tickslock>
    80002382:	a811                	j	80002396 <wakeup+0x3c>
            }
            release(&p->lock);
    80002384:	8526                	mv	a0,s1
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	966080e7          	jalr	-1690(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000238e:	16848493          	addi	s1,s1,360
    80002392:	03248663          	beq	s1,s2,800023be <wakeup+0x64>
        if (p != myproc())
    80002396:	fffff097          	auipc	ra,0xfffff
    8000239a:	788080e7          	jalr	1928(ra) # 80001b1e <myproc>
    8000239e:	fea488e3          	beq	s1,a0,8000238e <wakeup+0x34>
            acquire(&p->lock);
    800023a2:	8526                	mv	a0,s1
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	894080e7          	jalr	-1900(ra) # 80000c38 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800023ac:	4c9c                	lw	a5,24(s1)
    800023ae:	fd379be3          	bne	a5,s3,80002384 <wakeup+0x2a>
    800023b2:	709c                	ld	a5,32(s1)
    800023b4:	fd4798e3          	bne	a5,s4,80002384 <wakeup+0x2a>
                p->state = RUNNABLE;
    800023b8:	0154ac23          	sw	s5,24(s1)
    800023bc:	b7e1                	j	80002384 <wakeup+0x2a>
        }
    }
}
    800023be:	70e2                	ld	ra,56(sp)
    800023c0:	7442                	ld	s0,48(sp)
    800023c2:	74a2                	ld	s1,40(sp)
    800023c4:	7902                	ld	s2,32(sp)
    800023c6:	69e2                	ld	s3,24(sp)
    800023c8:	6a42                	ld	s4,16(sp)
    800023ca:	6aa2                	ld	s5,8(sp)
    800023cc:	6121                	addi	sp,sp,64
    800023ce:	8082                	ret

00000000800023d0 <reparent>:
{
    800023d0:	7179                	addi	sp,sp,-48
    800023d2:	f406                	sd	ra,40(sp)
    800023d4:	f022                	sd	s0,32(sp)
    800023d6:	ec26                	sd	s1,24(sp)
    800023d8:	e84a                	sd	s2,16(sp)
    800023da:	e44e                	sd	s3,8(sp)
    800023dc:	e052                	sd	s4,0(sp)
    800023de:	1800                	addi	s0,sp,48
    800023e0:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800023e2:	00011497          	auipc	s1,0x11
    800023e6:	71e48493          	addi	s1,s1,1822 # 80013b00 <proc>
            pp->parent = initproc;
    800023ea:	00009a17          	auipc	s4,0x9
    800023ee:	06ea0a13          	addi	s4,s4,110 # 8000b458 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800023f2:	00017997          	auipc	s3,0x17
    800023f6:	10e98993          	addi	s3,s3,270 # 80019500 <tickslock>
    800023fa:	a029                	j	80002404 <reparent+0x34>
    800023fc:	16848493          	addi	s1,s1,360
    80002400:	01348d63          	beq	s1,s3,8000241a <reparent+0x4a>
        if (pp->parent == p)
    80002404:	7c9c                	ld	a5,56(s1)
    80002406:	ff279be3          	bne	a5,s2,800023fc <reparent+0x2c>
            pp->parent = initproc;
    8000240a:	000a3503          	ld	a0,0(s4)
    8000240e:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80002410:	00000097          	auipc	ra,0x0
    80002414:	f4a080e7          	jalr	-182(ra) # 8000235a <wakeup>
    80002418:	b7d5                	j	800023fc <reparent+0x2c>
}
    8000241a:	70a2                	ld	ra,40(sp)
    8000241c:	7402                	ld	s0,32(sp)
    8000241e:	64e2                	ld	s1,24(sp)
    80002420:	6942                	ld	s2,16(sp)
    80002422:	69a2                	ld	s3,8(sp)
    80002424:	6a02                	ld	s4,0(sp)
    80002426:	6145                	addi	sp,sp,48
    80002428:	8082                	ret

000000008000242a <exit>:
{
    8000242a:	7179                	addi	sp,sp,-48
    8000242c:	f406                	sd	ra,40(sp)
    8000242e:	f022                	sd	s0,32(sp)
    80002430:	ec26                	sd	s1,24(sp)
    80002432:	e84a                	sd	s2,16(sp)
    80002434:	e44e                	sd	s3,8(sp)
    80002436:	e052                	sd	s4,0(sp)
    80002438:	1800                	addi	s0,sp,48
    8000243a:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	6e2080e7          	jalr	1762(ra) # 80001b1e <myproc>
    80002444:	89aa                	mv	s3,a0
    if (p == initproc)
    80002446:	00009797          	auipc	a5,0x9
    8000244a:	0127b783          	ld	a5,18(a5) # 8000b458 <initproc>
    8000244e:	0d050493          	addi	s1,a0,208
    80002452:	15050913          	addi	s2,a0,336
    80002456:	02a79363          	bne	a5,a0,8000247c <exit+0x52>
        panic("init exiting");
    8000245a:	00006517          	auipc	a0,0x6
    8000245e:	dfe50513          	addi	a0,a0,-514 # 80008258 <etext+0x258>
    80002462:	ffffe097          	auipc	ra,0xffffe
    80002466:	0fe080e7          	jalr	254(ra) # 80000560 <panic>
            fileclose(f);
    8000246a:	00002097          	auipc	ra,0x2
    8000246e:	4b6080e7          	jalr	1206(ra) # 80004920 <fileclose>
            p->ofile[fd] = 0;
    80002472:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80002476:	04a1                	addi	s1,s1,8
    80002478:	01248563          	beq	s1,s2,80002482 <exit+0x58>
        if (p->ofile[fd])
    8000247c:	6088                	ld	a0,0(s1)
    8000247e:	f575                	bnez	a0,8000246a <exit+0x40>
    80002480:	bfdd                	j	80002476 <exit+0x4c>
    begin_op();
    80002482:	00002097          	auipc	ra,0x2
    80002486:	fd4080e7          	jalr	-44(ra) # 80004456 <begin_op>
    iput(p->cwd);
    8000248a:	1509b503          	ld	a0,336(s3)
    8000248e:	00001097          	auipc	ra,0x1
    80002492:	7b8080e7          	jalr	1976(ra) # 80003c46 <iput>
    end_op();
    80002496:	00002097          	auipc	ra,0x2
    8000249a:	03a080e7          	jalr	58(ra) # 800044d0 <end_op>
    p->cwd = 0;
    8000249e:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800024a2:	00011497          	auipc	s1,0x11
    800024a6:	64648493          	addi	s1,s1,1606 # 80013ae8 <wait_lock>
    800024aa:	8526                	mv	a0,s1
    800024ac:	ffffe097          	auipc	ra,0xffffe
    800024b0:	78c080e7          	jalr	1932(ra) # 80000c38 <acquire>
    reparent(p);
    800024b4:	854e                	mv	a0,s3
    800024b6:	00000097          	auipc	ra,0x0
    800024ba:	f1a080e7          	jalr	-230(ra) # 800023d0 <reparent>
    wakeup(p->parent);
    800024be:	0389b503          	ld	a0,56(s3)
    800024c2:	00000097          	auipc	ra,0x0
    800024c6:	e98080e7          	jalr	-360(ra) # 8000235a <wakeup>
    acquire(&p->lock);
    800024ca:	854e                	mv	a0,s3
    800024cc:	ffffe097          	auipc	ra,0xffffe
    800024d0:	76c080e7          	jalr	1900(ra) # 80000c38 <acquire>
    p->xstate = status;
    800024d4:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800024d8:	4795                	li	a5,5
    800024da:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800024de:	8526                	mv	a0,s1
    800024e0:	fffff097          	auipc	ra,0xfffff
    800024e4:	80c080e7          	jalr	-2036(ra) # 80000cec <release>
    sched();
    800024e8:	00000097          	auipc	ra,0x0
    800024ec:	d04080e7          	jalr	-764(ra) # 800021ec <sched>
    panic("zombie exit");
    800024f0:	00006517          	auipc	a0,0x6
    800024f4:	d7850513          	addi	a0,a0,-648 # 80008268 <etext+0x268>
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	068080e7          	jalr	104(ra) # 80000560 <panic>

0000000080002500 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002500:	7179                	addi	sp,sp,-48
    80002502:	f406                	sd	ra,40(sp)
    80002504:	f022                	sd	s0,32(sp)
    80002506:	ec26                	sd	s1,24(sp)
    80002508:	e84a                	sd	s2,16(sp)
    8000250a:	e44e                	sd	s3,8(sp)
    8000250c:	1800                	addi	s0,sp,48
    8000250e:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002510:	00011497          	auipc	s1,0x11
    80002514:	5f048493          	addi	s1,s1,1520 # 80013b00 <proc>
    80002518:	00017997          	auipc	s3,0x17
    8000251c:	fe898993          	addi	s3,s3,-24 # 80019500 <tickslock>
    {
        acquire(&p->lock);
    80002520:	8526                	mv	a0,s1
    80002522:	ffffe097          	auipc	ra,0xffffe
    80002526:	716080e7          	jalr	1814(ra) # 80000c38 <acquire>
        if (p->pid == pid)
    8000252a:	589c                	lw	a5,48(s1)
    8000252c:	01278d63          	beq	a5,s2,80002546 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002530:	8526                	mv	a0,s1
    80002532:	ffffe097          	auipc	ra,0xffffe
    80002536:	7ba080e7          	jalr	1978(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000253a:	16848493          	addi	s1,s1,360
    8000253e:	ff3491e3          	bne	s1,s3,80002520 <kill+0x20>
    }
    return -1;
    80002542:	557d                	li	a0,-1
    80002544:	a829                	j	8000255e <kill+0x5e>
            p->killed = 1;
    80002546:	4785                	li	a5,1
    80002548:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000254a:	4c98                	lw	a4,24(s1)
    8000254c:	4789                	li	a5,2
    8000254e:	00f70f63          	beq	a4,a5,8000256c <kill+0x6c>
            release(&p->lock);
    80002552:	8526                	mv	a0,s1
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	798080e7          	jalr	1944(ra) # 80000cec <release>
            return 0;
    8000255c:	4501                	li	a0,0
}
    8000255e:	70a2                	ld	ra,40(sp)
    80002560:	7402                	ld	s0,32(sp)
    80002562:	64e2                	ld	s1,24(sp)
    80002564:	6942                	ld	s2,16(sp)
    80002566:	69a2                	ld	s3,8(sp)
    80002568:	6145                	addi	sp,sp,48
    8000256a:	8082                	ret
                p->state = RUNNABLE;
    8000256c:	478d                	li	a5,3
    8000256e:	cc9c                	sw	a5,24(s1)
    80002570:	b7cd                	j	80002552 <kill+0x52>

0000000080002572 <setkilled>:

void setkilled(struct proc *p)
{
    80002572:	1101                	addi	sp,sp,-32
    80002574:	ec06                	sd	ra,24(sp)
    80002576:	e822                	sd	s0,16(sp)
    80002578:	e426                	sd	s1,8(sp)
    8000257a:	1000                	addi	s0,sp,32
    8000257c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000257e:	ffffe097          	auipc	ra,0xffffe
    80002582:	6ba080e7          	jalr	1722(ra) # 80000c38 <acquire>
    p->killed = 1;
    80002586:	4785                	li	a5,1
    80002588:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000258a:	8526                	mv	a0,s1
    8000258c:	ffffe097          	auipc	ra,0xffffe
    80002590:	760080e7          	jalr	1888(ra) # 80000cec <release>
}
    80002594:	60e2                	ld	ra,24(sp)
    80002596:	6442                	ld	s0,16(sp)
    80002598:	64a2                	ld	s1,8(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret

000000008000259e <killed>:

int killed(struct proc *p)
{
    8000259e:	1101                	addi	sp,sp,-32
    800025a0:	ec06                	sd	ra,24(sp)
    800025a2:	e822                	sd	s0,16(sp)
    800025a4:	e426                	sd	s1,8(sp)
    800025a6:	e04a                	sd	s2,0(sp)
    800025a8:	1000                	addi	s0,sp,32
    800025aa:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800025ac:	ffffe097          	auipc	ra,0xffffe
    800025b0:	68c080e7          	jalr	1676(ra) # 80000c38 <acquire>
    k = p->killed;
    800025b4:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800025b8:	8526                	mv	a0,s1
    800025ba:	ffffe097          	auipc	ra,0xffffe
    800025be:	732080e7          	jalr	1842(ra) # 80000cec <release>
    return k;
}
    800025c2:	854a                	mv	a0,s2
    800025c4:	60e2                	ld	ra,24(sp)
    800025c6:	6442                	ld	s0,16(sp)
    800025c8:	64a2                	ld	s1,8(sp)
    800025ca:	6902                	ld	s2,0(sp)
    800025cc:	6105                	addi	sp,sp,32
    800025ce:	8082                	ret

00000000800025d0 <wait>:
{
    800025d0:	715d                	addi	sp,sp,-80
    800025d2:	e486                	sd	ra,72(sp)
    800025d4:	e0a2                	sd	s0,64(sp)
    800025d6:	fc26                	sd	s1,56(sp)
    800025d8:	f84a                	sd	s2,48(sp)
    800025da:	f44e                	sd	s3,40(sp)
    800025dc:	f052                	sd	s4,32(sp)
    800025de:	ec56                	sd	s5,24(sp)
    800025e0:	e85a                	sd	s6,16(sp)
    800025e2:	e45e                	sd	s7,8(sp)
    800025e4:	e062                	sd	s8,0(sp)
    800025e6:	0880                	addi	s0,sp,80
    800025e8:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800025ea:	fffff097          	auipc	ra,0xfffff
    800025ee:	534080e7          	jalr	1332(ra) # 80001b1e <myproc>
    800025f2:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800025f4:	00011517          	auipc	a0,0x11
    800025f8:	4f450513          	addi	a0,a0,1268 # 80013ae8 <wait_lock>
    800025fc:	ffffe097          	auipc	ra,0xffffe
    80002600:	63c080e7          	jalr	1596(ra) # 80000c38 <acquire>
        havekids = 0;
    80002604:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80002606:	4a15                	li	s4,5
                havekids = 1;
    80002608:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000260a:	00017997          	auipc	s3,0x17
    8000260e:	ef698993          	addi	s3,s3,-266 # 80019500 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002612:	00011c17          	auipc	s8,0x11
    80002616:	4d6c0c13          	addi	s8,s8,1238 # 80013ae8 <wait_lock>
    8000261a:	a0d1                	j	800026de <wait+0x10e>
                    pid = pp->pid;
    8000261c:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002620:	000b0e63          	beqz	s6,8000263c <wait+0x6c>
    80002624:	4691                	li	a3,4
    80002626:	02c48613          	addi	a2,s1,44
    8000262a:	85da                	mv	a1,s6
    8000262c:	05093503          	ld	a0,80(s2)
    80002630:	fffff097          	auipc	ra,0xfffff
    80002634:	0b2080e7          	jalr	178(ra) # 800016e2 <copyout>
    80002638:	04054163          	bltz	a0,8000267a <wait+0xaa>
                    freeproc(pp);
    8000263c:	8526                	mv	a0,s1
    8000263e:	fffff097          	auipc	ra,0xfffff
    80002642:	692080e7          	jalr	1682(ra) # 80001cd0 <freeproc>
                    release(&pp->lock);
    80002646:	8526                	mv	a0,s1
    80002648:	ffffe097          	auipc	ra,0xffffe
    8000264c:	6a4080e7          	jalr	1700(ra) # 80000cec <release>
                    release(&wait_lock);
    80002650:	00011517          	auipc	a0,0x11
    80002654:	49850513          	addi	a0,a0,1176 # 80013ae8 <wait_lock>
    80002658:	ffffe097          	auipc	ra,0xffffe
    8000265c:	694080e7          	jalr	1684(ra) # 80000cec <release>
}
    80002660:	854e                	mv	a0,s3
    80002662:	60a6                	ld	ra,72(sp)
    80002664:	6406                	ld	s0,64(sp)
    80002666:	74e2                	ld	s1,56(sp)
    80002668:	7942                	ld	s2,48(sp)
    8000266a:	79a2                	ld	s3,40(sp)
    8000266c:	7a02                	ld	s4,32(sp)
    8000266e:	6ae2                	ld	s5,24(sp)
    80002670:	6b42                	ld	s6,16(sp)
    80002672:	6ba2                	ld	s7,8(sp)
    80002674:	6c02                	ld	s8,0(sp)
    80002676:	6161                	addi	sp,sp,80
    80002678:	8082                	ret
                        release(&pp->lock);
    8000267a:	8526                	mv	a0,s1
    8000267c:	ffffe097          	auipc	ra,0xffffe
    80002680:	670080e7          	jalr	1648(ra) # 80000cec <release>
                        release(&wait_lock);
    80002684:	00011517          	auipc	a0,0x11
    80002688:	46450513          	addi	a0,a0,1124 # 80013ae8 <wait_lock>
    8000268c:	ffffe097          	auipc	ra,0xffffe
    80002690:	660080e7          	jalr	1632(ra) # 80000cec <release>
                        return -1;
    80002694:	59fd                	li	s3,-1
    80002696:	b7e9                	j	80002660 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002698:	16848493          	addi	s1,s1,360
    8000269c:	03348463          	beq	s1,s3,800026c4 <wait+0xf4>
            if (pp->parent == p)
    800026a0:	7c9c                	ld	a5,56(s1)
    800026a2:	ff279be3          	bne	a5,s2,80002698 <wait+0xc8>
                acquire(&pp->lock);
    800026a6:	8526                	mv	a0,s1
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	590080e7          	jalr	1424(ra) # 80000c38 <acquire>
                if (pp->state == ZOMBIE)
    800026b0:	4c9c                	lw	a5,24(s1)
    800026b2:	f74785e3          	beq	a5,s4,8000261c <wait+0x4c>
                release(&pp->lock);
    800026b6:	8526                	mv	a0,s1
    800026b8:	ffffe097          	auipc	ra,0xffffe
    800026bc:	634080e7          	jalr	1588(ra) # 80000cec <release>
                havekids = 1;
    800026c0:	8756                	mv	a4,s5
    800026c2:	bfd9                	j	80002698 <wait+0xc8>
        if (!havekids || killed(p))
    800026c4:	c31d                	beqz	a4,800026ea <wait+0x11a>
    800026c6:	854a                	mv	a0,s2
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	ed6080e7          	jalr	-298(ra) # 8000259e <killed>
    800026d0:	ed09                	bnez	a0,800026ea <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800026d2:	85e2                	mv	a1,s8
    800026d4:	854a                	mv	a0,s2
    800026d6:	00000097          	auipc	ra,0x0
    800026da:	c20080e7          	jalr	-992(ra) # 800022f6 <sleep>
        havekids = 0;
    800026de:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800026e0:	00011497          	auipc	s1,0x11
    800026e4:	42048493          	addi	s1,s1,1056 # 80013b00 <proc>
    800026e8:	bf65                	j	800026a0 <wait+0xd0>
            release(&wait_lock);
    800026ea:	00011517          	auipc	a0,0x11
    800026ee:	3fe50513          	addi	a0,a0,1022 # 80013ae8 <wait_lock>
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	5fa080e7          	jalr	1530(ra) # 80000cec <release>
            return -1;
    800026fa:	59fd                	li	s3,-1
    800026fc:	b795                	j	80002660 <wait+0x90>

00000000800026fe <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800026fe:	7179                	addi	sp,sp,-48
    80002700:	f406                	sd	ra,40(sp)
    80002702:	f022                	sd	s0,32(sp)
    80002704:	ec26                	sd	s1,24(sp)
    80002706:	e84a                	sd	s2,16(sp)
    80002708:	e44e                	sd	s3,8(sp)
    8000270a:	e052                	sd	s4,0(sp)
    8000270c:	1800                	addi	s0,sp,48
    8000270e:	84aa                	mv	s1,a0
    80002710:	892e                	mv	s2,a1
    80002712:	89b2                	mv	s3,a2
    80002714:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80002716:	fffff097          	auipc	ra,0xfffff
    8000271a:	408080e7          	jalr	1032(ra) # 80001b1e <myproc>
    if (user_dst)
    8000271e:	c08d                	beqz	s1,80002740 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002720:	86d2                	mv	a3,s4
    80002722:	864e                	mv	a2,s3
    80002724:	85ca                	mv	a1,s2
    80002726:	6928                	ld	a0,80(a0)
    80002728:	fffff097          	auipc	ra,0xfffff
    8000272c:	fba080e7          	jalr	-70(ra) # 800016e2 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002730:	70a2                	ld	ra,40(sp)
    80002732:	7402                	ld	s0,32(sp)
    80002734:	64e2                	ld	s1,24(sp)
    80002736:	6942                	ld	s2,16(sp)
    80002738:	69a2                	ld	s3,8(sp)
    8000273a:	6a02                	ld	s4,0(sp)
    8000273c:	6145                	addi	sp,sp,48
    8000273e:	8082                	ret
        memmove((char *)dst, src, len);
    80002740:	000a061b          	sext.w	a2,s4
    80002744:	85ce                	mv	a1,s3
    80002746:	854a                	mv	a0,s2
    80002748:	ffffe097          	auipc	ra,0xffffe
    8000274c:	648080e7          	jalr	1608(ra) # 80000d90 <memmove>
        return 0;
    80002750:	8526                	mv	a0,s1
    80002752:	bff9                	j	80002730 <either_copyout+0x32>

0000000080002754 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002754:	7179                	addi	sp,sp,-48
    80002756:	f406                	sd	ra,40(sp)
    80002758:	f022                	sd	s0,32(sp)
    8000275a:	ec26                	sd	s1,24(sp)
    8000275c:	e84a                	sd	s2,16(sp)
    8000275e:	e44e                	sd	s3,8(sp)
    80002760:	e052                	sd	s4,0(sp)
    80002762:	1800                	addi	s0,sp,48
    80002764:	892a                	mv	s2,a0
    80002766:	84ae                	mv	s1,a1
    80002768:	89b2                	mv	s3,a2
    8000276a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000276c:	fffff097          	auipc	ra,0xfffff
    80002770:	3b2080e7          	jalr	946(ra) # 80001b1e <myproc>
    if (user_src)
    80002774:	c08d                	beqz	s1,80002796 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002776:	86d2                	mv	a3,s4
    80002778:	864e                	mv	a2,s3
    8000277a:	85ca                	mv	a1,s2
    8000277c:	6928                	ld	a0,80(a0)
    8000277e:	fffff097          	auipc	ra,0xfffff
    80002782:	ff0080e7          	jalr	-16(ra) # 8000176e <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002786:	70a2                	ld	ra,40(sp)
    80002788:	7402                	ld	s0,32(sp)
    8000278a:	64e2                	ld	s1,24(sp)
    8000278c:	6942                	ld	s2,16(sp)
    8000278e:	69a2                	ld	s3,8(sp)
    80002790:	6a02                	ld	s4,0(sp)
    80002792:	6145                	addi	sp,sp,48
    80002794:	8082                	ret
        memmove(dst, (char *)src, len);
    80002796:	000a061b          	sext.w	a2,s4
    8000279a:	85ce                	mv	a1,s3
    8000279c:	854a                	mv	a0,s2
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	5f2080e7          	jalr	1522(ra) # 80000d90 <memmove>
        return 0;
    800027a6:	8526                	mv	a0,s1
    800027a8:	bff9                	j	80002786 <either_copyin+0x32>

00000000800027aa <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800027aa:	715d                	addi	sp,sp,-80
    800027ac:	e486                	sd	ra,72(sp)
    800027ae:	e0a2                	sd	s0,64(sp)
    800027b0:	fc26                	sd	s1,56(sp)
    800027b2:	f84a                	sd	s2,48(sp)
    800027b4:	f44e                	sd	s3,40(sp)
    800027b6:	f052                	sd	s4,32(sp)
    800027b8:	ec56                	sd	s5,24(sp)
    800027ba:	e85a                	sd	s6,16(sp)
    800027bc:	e45e                	sd	s7,8(sp)
    800027be:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800027c0:	00006517          	auipc	a0,0x6
    800027c4:	85050513          	addi	a0,a0,-1968 # 80008010 <etext+0x10>
    800027c8:	ffffe097          	auipc	ra,0xffffe
    800027cc:	de2080e7          	jalr	-542(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800027d0:	00011497          	auipc	s1,0x11
    800027d4:	48848493          	addi	s1,s1,1160 # 80013c58 <proc+0x158>
    800027d8:	00017917          	auipc	s2,0x17
    800027dc:	e8090913          	addi	s2,s2,-384 # 80019658 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027e0:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800027e2:	00006997          	auipc	s3,0x6
    800027e6:	a9698993          	addi	s3,s3,-1386 # 80008278 <etext+0x278>
        printf("%d <%s %s", p->pid, state, p->name);
    800027ea:	00006a97          	auipc	s5,0x6
    800027ee:	a96a8a93          	addi	s5,s5,-1386 # 80008280 <etext+0x280>
        printf("\n");
    800027f2:	00006a17          	auipc	s4,0x6
    800027f6:	81ea0a13          	addi	s4,s4,-2018 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027fa:	00006b97          	auipc	s7,0x6
    800027fe:	02eb8b93          	addi	s7,s7,46 # 80008828 <states.0>
    80002802:	a00d                	j	80002824 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002804:	ed86a583          	lw	a1,-296(a3)
    80002808:	8556                	mv	a0,s5
    8000280a:	ffffe097          	auipc	ra,0xffffe
    8000280e:	da0080e7          	jalr	-608(ra) # 800005aa <printf>
        printf("\n");
    80002812:	8552                	mv	a0,s4
    80002814:	ffffe097          	auipc	ra,0xffffe
    80002818:	d96080e7          	jalr	-618(ra) # 800005aa <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    8000281c:	16848493          	addi	s1,s1,360
    80002820:	03248263          	beq	s1,s2,80002844 <procdump+0x9a>
        if (p->state == UNUSED)
    80002824:	86a6                	mv	a3,s1
    80002826:	ec04a783          	lw	a5,-320(s1)
    8000282a:	dbed                	beqz	a5,8000281c <procdump+0x72>
            state = "???";
    8000282c:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000282e:	fcfb6be3          	bltu	s6,a5,80002804 <procdump+0x5a>
    80002832:	02079713          	slli	a4,a5,0x20
    80002836:	01d75793          	srli	a5,a4,0x1d
    8000283a:	97de                	add	a5,a5,s7
    8000283c:	6390                	ld	a2,0(a5)
    8000283e:	f279                	bnez	a2,80002804 <procdump+0x5a>
            state = "???";
    80002840:	864e                	mv	a2,s3
    80002842:	b7c9                	j	80002804 <procdump+0x5a>
    }
}
    80002844:	60a6                	ld	ra,72(sp)
    80002846:	6406                	ld	s0,64(sp)
    80002848:	74e2                	ld	s1,56(sp)
    8000284a:	7942                	ld	s2,48(sp)
    8000284c:	79a2                	ld	s3,40(sp)
    8000284e:	7a02                	ld	s4,32(sp)
    80002850:	6ae2                	ld	s5,24(sp)
    80002852:	6b42                	ld	s6,16(sp)
    80002854:	6ba2                	ld	s7,8(sp)
    80002856:	6161                	addi	sp,sp,80
    80002858:	8082                	ret

000000008000285a <schedls>:

void schedls()
{
    8000285a:	1141                	addi	sp,sp,-16
    8000285c:	e406                	sd	ra,8(sp)
    8000285e:	e022                	sd	s0,0(sp)
    80002860:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002862:	00006517          	auipc	a0,0x6
    80002866:	a2e50513          	addi	a0,a0,-1490 # 80008290 <etext+0x290>
    8000286a:	ffffe097          	auipc	ra,0xffffe
    8000286e:	d40080e7          	jalr	-704(ra) # 800005aa <printf>
    printf("====================================\n");
    80002872:	00006517          	auipc	a0,0x6
    80002876:	a4650513          	addi	a0,a0,-1466 # 800082b8 <etext+0x2b8>
    8000287a:	ffffe097          	auipc	ra,0xffffe
    8000287e:	d30080e7          	jalr	-720(ra) # 800005aa <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002882:	00009717          	auipc	a4,0x9
    80002886:	b7673703          	ld	a4,-1162(a4) # 8000b3f8 <available_schedulers+0x10>
    8000288a:	00009797          	auipc	a5,0x9
    8000288e:	b0e7b783          	ld	a5,-1266(a5) # 8000b398 <sched_pointer>
    80002892:	04f70663          	beq	a4,a5,800028de <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002896:	00006517          	auipc	a0,0x6
    8000289a:	a5250513          	addi	a0,a0,-1454 # 800082e8 <etext+0x2e8>
    8000289e:	ffffe097          	auipc	ra,0xffffe
    800028a2:	d0c080e7          	jalr	-756(ra) # 800005aa <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    800028a6:	00009617          	auipc	a2,0x9
    800028aa:	b5a62603          	lw	a2,-1190(a2) # 8000b400 <available_schedulers+0x18>
    800028ae:	00009597          	auipc	a1,0x9
    800028b2:	b3a58593          	addi	a1,a1,-1222 # 8000b3e8 <available_schedulers>
    800028b6:	00006517          	auipc	a0,0x6
    800028ba:	a3a50513          	addi	a0,a0,-1478 # 800082f0 <etext+0x2f0>
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	cec080e7          	jalr	-788(ra) # 800005aa <printf>
    }
    printf("\n*: current scheduler\n\n");
    800028c6:	00006517          	auipc	a0,0x6
    800028ca:	a3250513          	addi	a0,a0,-1486 # 800082f8 <etext+0x2f8>
    800028ce:	ffffe097          	auipc	ra,0xffffe
    800028d2:	cdc080e7          	jalr	-804(ra) # 800005aa <printf>
}
    800028d6:	60a2                	ld	ra,8(sp)
    800028d8:	6402                	ld	s0,0(sp)
    800028da:	0141                	addi	sp,sp,16
    800028dc:	8082                	ret
            printf("[*]\t");
    800028de:	00006517          	auipc	a0,0x6
    800028e2:	a0250513          	addi	a0,a0,-1534 # 800082e0 <etext+0x2e0>
    800028e6:	ffffe097          	auipc	ra,0xffffe
    800028ea:	cc4080e7          	jalr	-828(ra) # 800005aa <printf>
    800028ee:	bf65                	j	800028a6 <schedls+0x4c>

00000000800028f0 <schedset>:

void schedset(int id)
{
    800028f0:	1141                	addi	sp,sp,-16
    800028f2:	e406                	sd	ra,8(sp)
    800028f4:	e022                	sd	s0,0(sp)
    800028f6:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    800028f8:	e90d                	bnez	a0,8000292a <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    800028fa:	00009797          	auipc	a5,0x9
    800028fe:	afe7b783          	ld	a5,-1282(a5) # 8000b3f8 <available_schedulers+0x10>
    80002902:	00009717          	auipc	a4,0x9
    80002906:	a8f73b23          	sd	a5,-1386(a4) # 8000b398 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    8000290a:	00009597          	auipc	a1,0x9
    8000290e:	ade58593          	addi	a1,a1,-1314 # 8000b3e8 <available_schedulers>
    80002912:	00006517          	auipc	a0,0x6
    80002916:	a2650513          	addi	a0,a0,-1498 # 80008338 <etext+0x338>
    8000291a:	ffffe097          	auipc	ra,0xffffe
    8000291e:	c90080e7          	jalr	-880(ra) # 800005aa <printf>
    80002922:	60a2                	ld	ra,8(sp)
    80002924:	6402                	ld	s0,0(sp)
    80002926:	0141                	addi	sp,sp,16
    80002928:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	9e650513          	addi	a0,a0,-1562 # 80008310 <etext+0x310>
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	c78080e7          	jalr	-904(ra) # 800005aa <printf>
        return;
    8000293a:	b7e5                	j	80002922 <schedset+0x32>

000000008000293c <swtch>:
    8000293c:	00153023          	sd	ra,0(a0)
    80002940:	00253423          	sd	sp,8(a0)
    80002944:	e900                	sd	s0,16(a0)
    80002946:	ed04                	sd	s1,24(a0)
    80002948:	03253023          	sd	s2,32(a0)
    8000294c:	03353423          	sd	s3,40(a0)
    80002950:	03453823          	sd	s4,48(a0)
    80002954:	03553c23          	sd	s5,56(a0)
    80002958:	05653023          	sd	s6,64(a0)
    8000295c:	05753423          	sd	s7,72(a0)
    80002960:	05853823          	sd	s8,80(a0)
    80002964:	05953c23          	sd	s9,88(a0)
    80002968:	07a53023          	sd	s10,96(a0)
    8000296c:	07b53423          	sd	s11,104(a0)
    80002970:	0005b083          	ld	ra,0(a1)
    80002974:	0085b103          	ld	sp,8(a1)
    80002978:	6980                	ld	s0,16(a1)
    8000297a:	6d84                	ld	s1,24(a1)
    8000297c:	0205b903          	ld	s2,32(a1)
    80002980:	0285b983          	ld	s3,40(a1)
    80002984:	0305ba03          	ld	s4,48(a1)
    80002988:	0385ba83          	ld	s5,56(a1)
    8000298c:	0405bb03          	ld	s6,64(a1)
    80002990:	0485bb83          	ld	s7,72(a1)
    80002994:	0505bc03          	ld	s8,80(a1)
    80002998:	0585bc83          	ld	s9,88(a1)
    8000299c:	0605bd03          	ld	s10,96(a1)
    800029a0:	0685bd83          	ld	s11,104(a1)
    800029a4:	8082                	ret

00000000800029a6 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    800029a6:	1141                	addi	sp,sp,-16
    800029a8:	e406                	sd	ra,8(sp)
    800029aa:	e022                	sd	s0,0(sp)
    800029ac:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    800029ae:	00006597          	auipc	a1,0x6
    800029b2:	9e258593          	addi	a1,a1,-1566 # 80008390 <etext+0x390>
    800029b6:	00017517          	auipc	a0,0x17
    800029ba:	b4a50513          	addi	a0,a0,-1206 # 80019500 <tickslock>
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	1ea080e7          	jalr	490(ra) # 80000ba8 <initlock>
}
    800029c6:	60a2                	ld	ra,8(sp)
    800029c8:	6402                	ld	s0,0(sp)
    800029ca:	0141                	addi	sp,sp,16
    800029cc:	8082                	ret

00000000800029ce <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    800029ce:	1141                	addi	sp,sp,-16
    800029d0:	e422                	sd	s0,8(sp)
    800029d2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029d4:	00003797          	auipc	a5,0x3
    800029d8:	64c78793          	addi	a5,a5,1612 # 80006020 <kernelvec>
    800029dc:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    800029e0:	6422                	ld	s0,8(sp)
    800029e2:	0141                	addi	sp,sp,16
    800029e4:	8082                	ret

00000000800029e6 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    800029e6:	1141                	addi	sp,sp,-16
    800029e8:	e406                	sd	ra,8(sp)
    800029ea:	e022                	sd	s0,0(sp)
    800029ec:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    800029ee:	fffff097          	auipc	ra,0xfffff
    800029f2:	130080e7          	jalr	304(ra) # 80001b1e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800029fa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029fc:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002a00:	00004697          	auipc	a3,0x4
    80002a04:	60068693          	addi	a3,a3,1536 # 80007000 <_trampoline>
    80002a08:	00004717          	auipc	a4,0x4
    80002a0c:	5f870713          	addi	a4,a4,1528 # 80007000 <_trampoline>
    80002a10:	8f15                	sub	a4,a4,a3
    80002a12:	040007b7          	lui	a5,0x4000
    80002a16:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002a18:	07b2                	slli	a5,a5,0xc
    80002a1a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a1c:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a20:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a22:	18002673          	csrr	a2,satp
    80002a26:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002a28:	6d30                	ld	a2,88(a0)
    80002a2a:	6138                	ld	a4,64(a0)
    80002a2c:	6585                	lui	a1,0x1
    80002a2e:	972e                	add	a4,a4,a1
    80002a30:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002a32:	6d38                	ld	a4,88(a0)
    80002a34:	00000617          	auipc	a2,0x0
    80002a38:	13860613          	addi	a2,a2,312 # 80002b6c <usertrap>
    80002a3c:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002a3e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002a40:	8612                	mv	a2,tp
    80002a42:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a44:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002a48:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002a4c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a50:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002a54:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a56:	6f18                	ld	a4,24(a4)
    80002a58:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002a5c:	6928                	ld	a0,80(a0)
    80002a5e:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002a60:	00004717          	auipc	a4,0x4
    80002a64:	63c70713          	addi	a4,a4,1596 # 8000709c <userret>
    80002a68:	8f15                	sub	a4,a4,a3
    80002a6a:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002a6c:	577d                	li	a4,-1
    80002a6e:	177e                	slli	a4,a4,0x3f
    80002a70:	8d59                	or	a0,a0,a4
    80002a72:	9782                	jalr	a5
}
    80002a74:	60a2                	ld	ra,8(sp)
    80002a76:	6402                	ld	s0,0(sp)
    80002a78:	0141                	addi	sp,sp,16
    80002a7a:	8082                	ret

0000000080002a7c <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002a7c:	1101                	addi	sp,sp,-32
    80002a7e:	ec06                	sd	ra,24(sp)
    80002a80:	e822                	sd	s0,16(sp)
    80002a82:	e426                	sd	s1,8(sp)
    80002a84:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80002a86:	00017497          	auipc	s1,0x17
    80002a8a:	a7a48493          	addi	s1,s1,-1414 # 80019500 <tickslock>
    80002a8e:	8526                	mv	a0,s1
    80002a90:	ffffe097          	auipc	ra,0xffffe
    80002a94:	1a8080e7          	jalr	424(ra) # 80000c38 <acquire>
    ticks++;
    80002a98:	00009517          	auipc	a0,0x9
    80002a9c:	9c850513          	addi	a0,a0,-1592 # 8000b460 <ticks>
    80002aa0:	411c                	lw	a5,0(a0)
    80002aa2:	2785                	addiw	a5,a5,1
    80002aa4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	8b4080e7          	jalr	-1868(ra) # 8000235a <wakeup>
    release(&tickslock);
    80002aae:	8526                	mv	a0,s1
    80002ab0:	ffffe097          	auipc	ra,0xffffe
    80002ab4:	23c080e7          	jalr	572(ra) # 80000cec <release>
}
    80002ab8:	60e2                	ld	ra,24(sp)
    80002aba:	6442                	ld	s0,16(sp)
    80002abc:	64a2                	ld	s1,8(sp)
    80002abe:	6105                	addi	sp,sp,32
    80002ac0:	8082                	ret

0000000080002ac2 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ac2:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002ac6:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002ac8:	0a07d163          	bgez	a5,80002b6a <devintr+0xa8>
{
    80002acc:	1101                	addi	sp,sp,-32
    80002ace:	ec06                	sd	ra,24(sp)
    80002ad0:	e822                	sd	s0,16(sp)
    80002ad2:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002ad4:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002ad8:	46a5                	li	a3,9
    80002ada:	00d70c63          	beq	a4,a3,80002af2 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002ade:	577d                	li	a4,-1
    80002ae0:	177e                	slli	a4,a4,0x3f
    80002ae2:	0705                	addi	a4,a4,1
        return 0;
    80002ae4:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002ae6:	06e78163          	beq	a5,a4,80002b48 <devintr+0x86>
    }
}
    80002aea:	60e2                	ld	ra,24(sp)
    80002aec:	6442                	ld	s0,16(sp)
    80002aee:	6105                	addi	sp,sp,32
    80002af0:	8082                	ret
    80002af2:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002af4:	00003097          	auipc	ra,0x3
    80002af8:	638080e7          	jalr	1592(ra) # 8000612c <plic_claim>
    80002afc:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002afe:	47a9                	li	a5,10
    80002b00:	00f50963          	beq	a0,a5,80002b12 <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80002b04:	4785                	li	a5,1
    80002b06:	00f50b63          	beq	a0,a5,80002b1c <devintr+0x5a>
        return 1;
    80002b0a:	4505                	li	a0,1
        else if (irq)
    80002b0c:	ec89                	bnez	s1,80002b26 <devintr+0x64>
    80002b0e:	64a2                	ld	s1,8(sp)
    80002b10:	bfe9                	j	80002aea <devintr+0x28>
            uartintr();
    80002b12:	ffffe097          	auipc	ra,0xffffe
    80002b16:	ee8080e7          	jalr	-280(ra) # 800009fa <uartintr>
        if (irq)
    80002b1a:	a839                	j	80002b38 <devintr+0x76>
            virtio_disk_intr();
    80002b1c:	00004097          	auipc	ra,0x4
    80002b20:	b3a080e7          	jalr	-1222(ra) # 80006656 <virtio_disk_intr>
        if (irq)
    80002b24:	a811                	j	80002b38 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80002b26:	85a6                	mv	a1,s1
    80002b28:	00006517          	auipc	a0,0x6
    80002b2c:	87050513          	addi	a0,a0,-1936 # 80008398 <etext+0x398>
    80002b30:	ffffe097          	auipc	ra,0xffffe
    80002b34:	a7a080e7          	jalr	-1414(ra) # 800005aa <printf>
            plic_complete(irq);
    80002b38:	8526                	mv	a0,s1
    80002b3a:	00003097          	auipc	ra,0x3
    80002b3e:	616080e7          	jalr	1558(ra) # 80006150 <plic_complete>
        return 1;
    80002b42:	4505                	li	a0,1
    80002b44:	64a2                	ld	s1,8(sp)
    80002b46:	b755                	j	80002aea <devintr+0x28>
        if (cpuid() == 0)
    80002b48:	fffff097          	auipc	ra,0xfffff
    80002b4c:	faa080e7          	jalr	-86(ra) # 80001af2 <cpuid>
    80002b50:	c901                	beqz	a0,80002b60 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002b52:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002b56:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002b58:	14479073          	csrw	sip,a5
        return 2;
    80002b5c:	4509                	li	a0,2
    80002b5e:	b771                	j	80002aea <devintr+0x28>
            clockintr();
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	f1c080e7          	jalr	-228(ra) # 80002a7c <clockintr>
    80002b68:	b7ed                	j	80002b52 <devintr+0x90>
}
    80002b6a:	8082                	ret

0000000080002b6c <usertrap>:
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	e04a                	sd	s2,0(sp)
    80002b76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b78:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002b7c:	1007f793          	andi	a5,a5,256
    80002b80:	e3b1                	bnez	a5,80002bc4 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b82:	00003797          	auipc	a5,0x3
    80002b86:	49e78793          	addi	a5,a5,1182 # 80006020 <kernelvec>
    80002b8a:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002b8e:	fffff097          	auipc	ra,0xfffff
    80002b92:	f90080e7          	jalr	-112(ra) # 80001b1e <myproc>
    80002b96:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002b98:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b9a:	14102773          	csrr	a4,sepc
    80002b9e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ba0:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002ba4:	47a1                	li	a5,8
    80002ba6:	02f70763          	beq	a4,a5,80002bd4 <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	f18080e7          	jalr	-232(ra) # 80002ac2 <devintr>
    80002bb2:	892a                	mv	s2,a0
    80002bb4:	c151                	beqz	a0,80002c38 <usertrap+0xcc>
    if (killed(p))
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	9e6080e7          	jalr	-1562(ra) # 8000259e <killed>
    80002bc0:	c929                	beqz	a0,80002c12 <usertrap+0xa6>
    80002bc2:	a099                	j	80002c08 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002bc4:	00005517          	auipc	a0,0x5
    80002bc8:	7f450513          	addi	a0,a0,2036 # 800083b8 <etext+0x3b8>
    80002bcc:	ffffe097          	auipc	ra,0xffffe
    80002bd0:	994080e7          	jalr	-1644(ra) # 80000560 <panic>
        if (killed(p))
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	9ca080e7          	jalr	-1590(ra) # 8000259e <killed>
    80002bdc:	e921                	bnez	a0,80002c2c <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002bde:	6cb8                	ld	a4,88(s1)
    80002be0:	6f1c                	ld	a5,24(a4)
    80002be2:	0791                	addi	a5,a5,4
    80002be4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002bea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bee:	10079073          	csrw	sstatus,a5
        syscall();
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	2d8080e7          	jalr	728(ra) # 80002eca <syscall>
    if (killed(p))
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	00000097          	auipc	ra,0x0
    80002c00:	9a2080e7          	jalr	-1630(ra) # 8000259e <killed>
    80002c04:	c911                	beqz	a0,80002c18 <usertrap+0xac>
    80002c06:	4901                	li	s2,0
        exit(-1);
    80002c08:	557d                	li	a0,-1
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	820080e7          	jalr	-2016(ra) # 8000242a <exit>
    if (which_dev == 2)
    80002c12:	4789                	li	a5,2
    80002c14:	04f90f63          	beq	s2,a5,80002c72 <usertrap+0x106>
    usertrapret();
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	dce080e7          	jalr	-562(ra) # 800029e6 <usertrapret>
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret
            exit(-1);
    80002c2c:	557d                	li	a0,-1
    80002c2e:	fffff097          	auipc	ra,0xfffff
    80002c32:	7fc080e7          	jalr	2044(ra) # 8000242a <exit>
    80002c36:	b765                	j	80002bde <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c38:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002c3c:	5890                	lw	a2,48(s1)
    80002c3e:	00005517          	auipc	a0,0x5
    80002c42:	79a50513          	addi	a0,a0,1946 # 800083d8 <etext+0x3d8>
    80002c46:	ffffe097          	auipc	ra,0xffffe
    80002c4a:	964080e7          	jalr	-1692(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c4e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c52:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c56:	00005517          	auipc	a0,0x5
    80002c5a:	7b250513          	addi	a0,a0,1970 # 80008408 <etext+0x408>
    80002c5e:	ffffe097          	auipc	ra,0xffffe
    80002c62:	94c080e7          	jalr	-1716(ra) # 800005aa <printf>
        setkilled(p);
    80002c66:	8526                	mv	a0,s1
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	90a080e7          	jalr	-1782(ra) # 80002572 <setkilled>
    80002c70:	b769                	j	80002bfa <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002c72:	4505                	li	a0,1
    80002c74:	fffff097          	auipc	ra,0xfffff
    80002c78:	646080e7          	jalr	1606(ra) # 800022ba <yield>
    80002c7c:	bf71                	j	80002c18 <usertrap+0xac>

0000000080002c7e <kerneltrap>:
{
    80002c7e:	7179                	addi	sp,sp,-48
    80002c80:	f406                	sd	ra,40(sp)
    80002c82:	f022                	sd	s0,32(sp)
    80002c84:	ec26                	sd	s1,24(sp)
    80002c86:	e84a                	sd	s2,16(sp)
    80002c88:	e44e                	sd	s3,8(sp)
    80002c8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c8c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c90:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c94:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80002c98:	1004f793          	andi	a5,s1,256
    80002c9c:	cb85                	beqz	a5,80002ccc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c9e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ca2:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002ca4:	ef85                	bnez	a5,80002cdc <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80002ca6:	00000097          	auipc	ra,0x0
    80002caa:	e1c080e7          	jalr	-484(ra) # 80002ac2 <devintr>
    80002cae:	cd1d                	beqz	a0,80002cec <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002cb0:	4789                	li	a5,2
    80002cb2:	06f50a63          	beq	a0,a5,80002d26 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cb6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cba:	10049073          	csrw	sstatus,s1
}
    80002cbe:	70a2                	ld	ra,40(sp)
    80002cc0:	7402                	ld	s0,32(sp)
    80002cc2:	64e2                	ld	s1,24(sp)
    80002cc4:	6942                	ld	s2,16(sp)
    80002cc6:	69a2                	ld	s3,8(sp)
    80002cc8:	6145                	addi	sp,sp,48
    80002cca:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002ccc:	00005517          	auipc	a0,0x5
    80002cd0:	75c50513          	addi	a0,a0,1884 # 80008428 <etext+0x428>
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	88c080e7          	jalr	-1908(ra) # 80000560 <panic>
        panic("kerneltrap: interrupts enabled");
    80002cdc:	00005517          	auipc	a0,0x5
    80002ce0:	77450513          	addi	a0,a0,1908 # 80008450 <etext+0x450>
    80002ce4:	ffffe097          	auipc	ra,0xffffe
    80002ce8:	87c080e7          	jalr	-1924(ra) # 80000560 <panic>
        printf("scause %p\n", scause);
    80002cec:	85ce                	mv	a1,s3
    80002cee:	00005517          	auipc	a0,0x5
    80002cf2:	78250513          	addi	a0,a0,1922 # 80008470 <etext+0x470>
    80002cf6:	ffffe097          	auipc	ra,0xffffe
    80002cfa:	8b4080e7          	jalr	-1868(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cfe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d02:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d06:	00005517          	auipc	a0,0x5
    80002d0a:	77a50513          	addi	a0,a0,1914 # 80008480 <etext+0x480>
    80002d0e:	ffffe097          	auipc	ra,0xffffe
    80002d12:	89c080e7          	jalr	-1892(ra) # 800005aa <printf>
        panic("kerneltrap");
    80002d16:	00005517          	auipc	a0,0x5
    80002d1a:	78250513          	addi	a0,a0,1922 # 80008498 <etext+0x498>
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	842080e7          	jalr	-1982(ra) # 80000560 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	df8080e7          	jalr	-520(ra) # 80001b1e <myproc>
    80002d2e:	d541                	beqz	a0,80002cb6 <kerneltrap+0x38>
    80002d30:	fffff097          	auipc	ra,0xfffff
    80002d34:	dee080e7          	jalr	-530(ra) # 80001b1e <myproc>
    80002d38:	4d18                	lw	a4,24(a0)
    80002d3a:	4791                	li	a5,4
    80002d3c:	f6f71de3          	bne	a4,a5,80002cb6 <kerneltrap+0x38>
        yield(YIELD_OTHER);
    80002d40:	4509                	li	a0,2
    80002d42:	fffff097          	auipc	ra,0xfffff
    80002d46:	578080e7          	jalr	1400(ra) # 800022ba <yield>
    80002d4a:	b7b5                	j	80002cb6 <kerneltrap+0x38>

0000000080002d4c <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	1000                	addi	s0,sp,32
    80002d56:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	dc6080e7          	jalr	-570(ra) # 80001b1e <myproc>
    switch (n)
    80002d60:	4795                	li	a5,5
    80002d62:	0497e163          	bltu	a5,s1,80002da4 <argraw+0x58>
    80002d66:	048a                	slli	s1,s1,0x2
    80002d68:	00006717          	auipc	a4,0x6
    80002d6c:	af070713          	addi	a4,a4,-1296 # 80008858 <states.0+0x30>
    80002d70:	94ba                	add	s1,s1,a4
    80002d72:	409c                	lw	a5,0(s1)
    80002d74:	97ba                	add	a5,a5,a4
    80002d76:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002d78:	6d3c                	ld	a5,88(a0)
    80002d7a:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002d7c:	60e2                	ld	ra,24(sp)
    80002d7e:	6442                	ld	s0,16(sp)
    80002d80:	64a2                	ld	s1,8(sp)
    80002d82:	6105                	addi	sp,sp,32
    80002d84:	8082                	ret
        return p->trapframe->a1;
    80002d86:	6d3c                	ld	a5,88(a0)
    80002d88:	7fa8                	ld	a0,120(a5)
    80002d8a:	bfcd                	j	80002d7c <argraw+0x30>
        return p->trapframe->a2;
    80002d8c:	6d3c                	ld	a5,88(a0)
    80002d8e:	63c8                	ld	a0,128(a5)
    80002d90:	b7f5                	j	80002d7c <argraw+0x30>
        return p->trapframe->a3;
    80002d92:	6d3c                	ld	a5,88(a0)
    80002d94:	67c8                	ld	a0,136(a5)
    80002d96:	b7dd                	j	80002d7c <argraw+0x30>
        return p->trapframe->a4;
    80002d98:	6d3c                	ld	a5,88(a0)
    80002d9a:	6bc8                	ld	a0,144(a5)
    80002d9c:	b7c5                	j	80002d7c <argraw+0x30>
        return p->trapframe->a5;
    80002d9e:	6d3c                	ld	a5,88(a0)
    80002da0:	6fc8                	ld	a0,152(a5)
    80002da2:	bfe9                	j	80002d7c <argraw+0x30>
    panic("argraw");
    80002da4:	00005517          	auipc	a0,0x5
    80002da8:	70450513          	addi	a0,a0,1796 # 800084a8 <etext+0x4a8>
    80002dac:	ffffd097          	auipc	ra,0xffffd
    80002db0:	7b4080e7          	jalr	1972(ra) # 80000560 <panic>

0000000080002db4 <fetchaddr>:
{
    80002db4:	1101                	addi	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	e426                	sd	s1,8(sp)
    80002dbc:	e04a                	sd	s2,0(sp)
    80002dbe:	1000                	addi	s0,sp,32
    80002dc0:	84aa                	mv	s1,a0
    80002dc2:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002dc4:	fffff097          	auipc	ra,0xfffff
    80002dc8:	d5a080e7          	jalr	-678(ra) # 80001b1e <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002dcc:	653c                	ld	a5,72(a0)
    80002dce:	02f4f863          	bgeu	s1,a5,80002dfe <fetchaddr+0x4a>
    80002dd2:	00848713          	addi	a4,s1,8
    80002dd6:	02e7e663          	bltu	a5,a4,80002e02 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002dda:	46a1                	li	a3,8
    80002ddc:	8626                	mv	a2,s1
    80002dde:	85ca                	mv	a1,s2
    80002de0:	6928                	ld	a0,80(a0)
    80002de2:	fffff097          	auipc	ra,0xfffff
    80002de6:	98c080e7          	jalr	-1652(ra) # 8000176e <copyin>
    80002dea:	00a03533          	snez	a0,a0
    80002dee:	40a00533          	neg	a0,a0
}
    80002df2:	60e2                	ld	ra,24(sp)
    80002df4:	6442                	ld	s0,16(sp)
    80002df6:	64a2                	ld	s1,8(sp)
    80002df8:	6902                	ld	s2,0(sp)
    80002dfa:	6105                	addi	sp,sp,32
    80002dfc:	8082                	ret
        return -1;
    80002dfe:	557d                	li	a0,-1
    80002e00:	bfcd                	j	80002df2 <fetchaddr+0x3e>
    80002e02:	557d                	li	a0,-1
    80002e04:	b7fd                	j	80002df2 <fetchaddr+0x3e>

0000000080002e06 <fetchstr>:
{
    80002e06:	7179                	addi	sp,sp,-48
    80002e08:	f406                	sd	ra,40(sp)
    80002e0a:	f022                	sd	s0,32(sp)
    80002e0c:	ec26                	sd	s1,24(sp)
    80002e0e:	e84a                	sd	s2,16(sp)
    80002e10:	e44e                	sd	s3,8(sp)
    80002e12:	1800                	addi	s0,sp,48
    80002e14:	892a                	mv	s2,a0
    80002e16:	84ae                	mv	s1,a1
    80002e18:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002e1a:	fffff097          	auipc	ra,0xfffff
    80002e1e:	d04080e7          	jalr	-764(ra) # 80001b1e <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002e22:	86ce                	mv	a3,s3
    80002e24:	864a                	mv	a2,s2
    80002e26:	85a6                	mv	a1,s1
    80002e28:	6928                	ld	a0,80(a0)
    80002e2a:	fffff097          	auipc	ra,0xfffff
    80002e2e:	9d2080e7          	jalr	-1582(ra) # 800017fc <copyinstr>
    80002e32:	00054e63          	bltz	a0,80002e4e <fetchstr+0x48>
    return strlen(buf);
    80002e36:	8526                	mv	a0,s1
    80002e38:	ffffe097          	auipc	ra,0xffffe
    80002e3c:	070080e7          	jalr	112(ra) # 80000ea8 <strlen>
}
    80002e40:	70a2                	ld	ra,40(sp)
    80002e42:	7402                	ld	s0,32(sp)
    80002e44:	64e2                	ld	s1,24(sp)
    80002e46:	6942                	ld	s2,16(sp)
    80002e48:	69a2                	ld	s3,8(sp)
    80002e4a:	6145                	addi	sp,sp,48
    80002e4c:	8082                	ret
        return -1;
    80002e4e:	557d                	li	a0,-1
    80002e50:	bfc5                	j	80002e40 <fetchstr+0x3a>

0000000080002e52 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002e52:	1101                	addi	sp,sp,-32
    80002e54:	ec06                	sd	ra,24(sp)
    80002e56:	e822                	sd	s0,16(sp)
    80002e58:	e426                	sd	s1,8(sp)
    80002e5a:	1000                	addi	s0,sp,32
    80002e5c:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	eee080e7          	jalr	-274(ra) # 80002d4c <argraw>
    80002e66:	c088                	sw	a0,0(s1)
}
    80002e68:	60e2                	ld	ra,24(sp)
    80002e6a:	6442                	ld	s0,16(sp)
    80002e6c:	64a2                	ld	s1,8(sp)
    80002e6e:	6105                	addi	sp,sp,32
    80002e70:	8082                	ret

0000000080002e72 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002e72:	1101                	addi	sp,sp,-32
    80002e74:	ec06                	sd	ra,24(sp)
    80002e76:	e822                	sd	s0,16(sp)
    80002e78:	e426                	sd	s1,8(sp)
    80002e7a:	1000                	addi	s0,sp,32
    80002e7c:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	ece080e7          	jalr	-306(ra) # 80002d4c <argraw>
    80002e86:	e088                	sd	a0,0(s1)
}
    80002e88:	60e2                	ld	ra,24(sp)
    80002e8a:	6442                	ld	s0,16(sp)
    80002e8c:	64a2                	ld	s1,8(sp)
    80002e8e:	6105                	addi	sp,sp,32
    80002e90:	8082                	ret

0000000080002e92 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002e92:	7179                	addi	sp,sp,-48
    80002e94:	f406                	sd	ra,40(sp)
    80002e96:	f022                	sd	s0,32(sp)
    80002e98:	ec26                	sd	s1,24(sp)
    80002e9a:	e84a                	sd	s2,16(sp)
    80002e9c:	1800                	addi	s0,sp,48
    80002e9e:	84ae                	mv	s1,a1
    80002ea0:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002ea2:	fd840593          	addi	a1,s0,-40
    80002ea6:	00000097          	auipc	ra,0x0
    80002eaa:	fcc080e7          	jalr	-52(ra) # 80002e72 <argaddr>
    return fetchstr(addr, buf, max);
    80002eae:	864a                	mv	a2,s2
    80002eb0:	85a6                	mv	a1,s1
    80002eb2:	fd843503          	ld	a0,-40(s0)
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	f50080e7          	jalr	-176(ra) # 80002e06 <fetchstr>
}
    80002ebe:	70a2                	ld	ra,40(sp)
    80002ec0:	7402                	ld	s0,32(sp)
    80002ec2:	64e2                	ld	s1,24(sp)
    80002ec4:	6942                	ld	s2,16(sp)
    80002ec6:	6145                	addi	sp,sp,48
    80002ec8:	8082                	ret

0000000080002eca <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	e426                	sd	s1,8(sp)
    80002ed2:	e04a                	sd	s2,0(sp)
    80002ed4:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	c48080e7          	jalr	-952(ra) # 80001b1e <myproc>
    80002ede:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002ee0:	05853903          	ld	s2,88(a0)
    80002ee4:	0a893783          	ld	a5,168(s2)
    80002ee8:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002eec:	37fd                	addiw	a5,a5,-1
    80002eee:	4761                	li	a4,24
    80002ef0:	00f76f63          	bltu	a4,a5,80002f0e <syscall+0x44>
    80002ef4:	00369713          	slli	a4,a3,0x3
    80002ef8:	00006797          	auipc	a5,0x6
    80002efc:	97878793          	addi	a5,a5,-1672 # 80008870 <syscalls>
    80002f00:	97ba                	add	a5,a5,a4
    80002f02:	639c                	ld	a5,0(a5)
    80002f04:	c789                	beqz	a5,80002f0e <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002f06:	9782                	jalr	a5
    80002f08:	06a93823          	sd	a0,112(s2)
    80002f0c:	a839                	j	80002f2a <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002f0e:	15848613          	addi	a2,s1,344
    80002f12:	588c                	lw	a1,48(s1)
    80002f14:	00005517          	auipc	a0,0x5
    80002f18:	59c50513          	addi	a0,a0,1436 # 800084b0 <etext+0x4b0>
    80002f1c:	ffffd097          	auipc	ra,0xffffd
    80002f20:	68e080e7          	jalr	1678(ra) # 800005aa <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002f24:	6cbc                	ld	a5,88(s1)
    80002f26:	577d                	li	a4,-1
    80002f28:	fbb8                	sd	a4,112(a5)
    }
}
    80002f2a:	60e2                	ld	ra,24(sp)
    80002f2c:	6442                	ld	s0,16(sp)
    80002f2e:	64a2                	ld	s1,8(sp)
    80002f30:	6902                	ld	s2,0(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002f36:	1101                	addi	sp,sp,-32
    80002f38:	ec06                	sd	ra,24(sp)
    80002f3a:	e822                	sd	s0,16(sp)
    80002f3c:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80002f3e:	fec40593          	addi	a1,s0,-20
    80002f42:	4501                	li	a0,0
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	f0e080e7          	jalr	-242(ra) # 80002e52 <argint>
    exit(n);
    80002f4c:	fec42503          	lw	a0,-20(s0)
    80002f50:	fffff097          	auipc	ra,0xfffff
    80002f54:	4da080e7          	jalr	1242(ra) # 8000242a <exit>
    return 0; // not reached
}
    80002f58:	4501                	li	a0,0
    80002f5a:	60e2                	ld	ra,24(sp)
    80002f5c:	6442                	ld	s0,16(sp)
    80002f5e:	6105                	addi	sp,sp,32
    80002f60:	8082                	ret

0000000080002f62 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f62:	1141                	addi	sp,sp,-16
    80002f64:	e406                	sd	ra,8(sp)
    80002f66:	e022                	sd	s0,0(sp)
    80002f68:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	bb4080e7          	jalr	-1100(ra) # 80001b1e <myproc>
}
    80002f72:	5908                	lw	a0,48(a0)
    80002f74:	60a2                	ld	ra,8(sp)
    80002f76:	6402                	ld	s0,0(sp)
    80002f78:	0141                	addi	sp,sp,16
    80002f7a:	8082                	ret

0000000080002f7c <sys_fork>:

uint64
sys_fork(void)
{
    80002f7c:	1141                	addi	sp,sp,-16
    80002f7e:	e406                	sd	ra,8(sp)
    80002f80:	e022                	sd	s0,0(sp)
    80002f82:	0800                	addi	s0,sp,16
    return fork();
    80002f84:	fffff097          	auipc	ra,0xfffff
    80002f88:	0e8080e7          	jalr	232(ra) # 8000206c <fork>
}
    80002f8c:	60a2                	ld	ra,8(sp)
    80002f8e:	6402                	ld	s0,0(sp)
    80002f90:	0141                	addi	sp,sp,16
    80002f92:	8082                	ret

0000000080002f94 <sys_wait>:

uint64
sys_wait(void)
{
    80002f94:	1101                	addi	sp,sp,-32
    80002f96:	ec06                	sd	ra,24(sp)
    80002f98:	e822                	sd	s0,16(sp)
    80002f9a:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80002f9c:	fe840593          	addi	a1,s0,-24
    80002fa0:	4501                	li	a0,0
    80002fa2:	00000097          	auipc	ra,0x0
    80002fa6:	ed0080e7          	jalr	-304(ra) # 80002e72 <argaddr>
    return wait(p);
    80002faa:	fe843503          	ld	a0,-24(s0)
    80002fae:	fffff097          	auipc	ra,0xfffff
    80002fb2:	622080e7          	jalr	1570(ra) # 800025d0 <wait>
}
    80002fb6:	60e2                	ld	ra,24(sp)
    80002fb8:	6442                	ld	s0,16(sp)
    80002fba:	6105                	addi	sp,sp,32
    80002fbc:	8082                	ret

0000000080002fbe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002fbe:	7179                	addi	sp,sp,-48
    80002fc0:	f406                	sd	ra,40(sp)
    80002fc2:	f022                	sd	s0,32(sp)
    80002fc4:	ec26                	sd	s1,24(sp)
    80002fc6:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80002fc8:	fdc40593          	addi	a1,s0,-36
    80002fcc:	4501                	li	a0,0
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	e84080e7          	jalr	-380(ra) # 80002e52 <argint>
    addr = myproc()->sz;
    80002fd6:	fffff097          	auipc	ra,0xfffff
    80002fda:	b48080e7          	jalr	-1208(ra) # 80001b1e <myproc>
    80002fde:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    80002fe0:	fdc42503          	lw	a0,-36(s0)
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	e94080e7          	jalr	-364(ra) # 80001e78 <growproc>
    80002fec:	00054863          	bltz	a0,80002ffc <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	70a2                	ld	ra,40(sp)
    80002ff4:	7402                	ld	s0,32(sp)
    80002ff6:	64e2                	ld	s1,24(sp)
    80002ff8:	6145                	addi	sp,sp,48
    80002ffa:	8082                	ret
        return -1;
    80002ffc:	54fd                	li	s1,-1
    80002ffe:	bfcd                	j	80002ff0 <sys_sbrk+0x32>

0000000080003000 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003000:	7139                	addi	sp,sp,-64
    80003002:	fc06                	sd	ra,56(sp)
    80003004:	f822                	sd	s0,48(sp)
    80003006:	f04a                	sd	s2,32(sp)
    80003008:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    8000300a:	fcc40593          	addi	a1,s0,-52
    8000300e:	4501                	li	a0,0
    80003010:	00000097          	auipc	ra,0x0
    80003014:	e42080e7          	jalr	-446(ra) # 80002e52 <argint>
    acquire(&tickslock);
    80003018:	00016517          	auipc	a0,0x16
    8000301c:	4e850513          	addi	a0,a0,1256 # 80019500 <tickslock>
    80003020:	ffffe097          	auipc	ra,0xffffe
    80003024:	c18080e7          	jalr	-1000(ra) # 80000c38 <acquire>
    ticks0 = ticks;
    80003028:	00008917          	auipc	s2,0x8
    8000302c:	43892903          	lw	s2,1080(s2) # 8000b460 <ticks>
    while (ticks - ticks0 < n)
    80003030:	fcc42783          	lw	a5,-52(s0)
    80003034:	c3b9                	beqz	a5,8000307a <sys_sleep+0x7a>
    80003036:	f426                	sd	s1,40(sp)
    80003038:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000303a:	00016997          	auipc	s3,0x16
    8000303e:	4c698993          	addi	s3,s3,1222 # 80019500 <tickslock>
    80003042:	00008497          	auipc	s1,0x8
    80003046:	41e48493          	addi	s1,s1,1054 # 8000b460 <ticks>
        if (killed(myproc()))
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	ad4080e7          	jalr	-1324(ra) # 80001b1e <myproc>
    80003052:	fffff097          	auipc	ra,0xfffff
    80003056:	54c080e7          	jalr	1356(ra) # 8000259e <killed>
    8000305a:	ed15                	bnez	a0,80003096 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000305c:	85ce                	mv	a1,s3
    8000305e:	8526                	mv	a0,s1
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	296080e7          	jalr	662(ra) # 800022f6 <sleep>
    while (ticks - ticks0 < n)
    80003068:	409c                	lw	a5,0(s1)
    8000306a:	412787bb          	subw	a5,a5,s2
    8000306e:	fcc42703          	lw	a4,-52(s0)
    80003072:	fce7ece3          	bltu	a5,a4,8000304a <sys_sleep+0x4a>
    80003076:	74a2                	ld	s1,40(sp)
    80003078:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    8000307a:	00016517          	auipc	a0,0x16
    8000307e:	48650513          	addi	a0,a0,1158 # 80019500 <tickslock>
    80003082:	ffffe097          	auipc	ra,0xffffe
    80003086:	c6a080e7          	jalr	-918(ra) # 80000cec <release>
    return 0;
    8000308a:	4501                	li	a0,0
}
    8000308c:	70e2                	ld	ra,56(sp)
    8000308e:	7442                	ld	s0,48(sp)
    80003090:	7902                	ld	s2,32(sp)
    80003092:	6121                	addi	sp,sp,64
    80003094:	8082                	ret
            release(&tickslock);
    80003096:	00016517          	auipc	a0,0x16
    8000309a:	46a50513          	addi	a0,a0,1130 # 80019500 <tickslock>
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	c4e080e7          	jalr	-946(ra) # 80000cec <release>
            return -1;
    800030a6:	557d                	li	a0,-1
    800030a8:	74a2                	ld	s1,40(sp)
    800030aa:	69e2                	ld	s3,24(sp)
    800030ac:	b7c5                	j	8000308c <sys_sleep+0x8c>

00000000800030ae <sys_kill>:

uint64
sys_kill(void)
{
    800030ae:	1101                	addi	sp,sp,-32
    800030b0:	ec06                	sd	ra,24(sp)
    800030b2:	e822                	sd	s0,16(sp)
    800030b4:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800030b6:	fec40593          	addi	a1,s0,-20
    800030ba:	4501                	li	a0,0
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	d96080e7          	jalr	-618(ra) # 80002e52 <argint>
    return kill(pid);
    800030c4:	fec42503          	lw	a0,-20(s0)
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	438080e7          	jalr	1080(ra) # 80002500 <kill>
}
    800030d0:	60e2                	ld	ra,24(sp)
    800030d2:	6442                	ld	s0,16(sp)
    800030d4:	6105                	addi	sp,sp,32
    800030d6:	8082                	ret

00000000800030d8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800030d8:	1101                	addi	sp,sp,-32
    800030da:	ec06                	sd	ra,24(sp)
    800030dc:	e822                	sd	s0,16(sp)
    800030de:	e426                	sd	s1,8(sp)
    800030e0:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800030e2:	00016517          	auipc	a0,0x16
    800030e6:	41e50513          	addi	a0,a0,1054 # 80019500 <tickslock>
    800030ea:	ffffe097          	auipc	ra,0xffffe
    800030ee:	b4e080e7          	jalr	-1202(ra) # 80000c38 <acquire>
    xticks = ticks;
    800030f2:	00008497          	auipc	s1,0x8
    800030f6:	36e4a483          	lw	s1,878(s1) # 8000b460 <ticks>
    release(&tickslock);
    800030fa:	00016517          	auipc	a0,0x16
    800030fe:	40650513          	addi	a0,a0,1030 # 80019500 <tickslock>
    80003102:	ffffe097          	auipc	ra,0xffffe
    80003106:	bea080e7          	jalr	-1046(ra) # 80000cec <release>
    return xticks;
}
    8000310a:	02049513          	slli	a0,s1,0x20
    8000310e:	9101                	srli	a0,a0,0x20
    80003110:	60e2                	ld	ra,24(sp)
    80003112:	6442                	ld	s0,16(sp)
    80003114:	64a2                	ld	s1,8(sp)
    80003116:	6105                	addi	sp,sp,32
    80003118:	8082                	ret

000000008000311a <sys_ps>:

void *
sys_ps(void)
{
    8000311a:	1101                	addi	sp,sp,-32
    8000311c:	ec06                	sd	ra,24(sp)
    8000311e:	e822                	sd	s0,16(sp)
    80003120:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003122:	fe042623          	sw	zero,-20(s0)
    80003126:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    8000312a:	fec40593          	addi	a1,s0,-20
    8000312e:	4501                	li	a0,0
    80003130:	00000097          	auipc	ra,0x0
    80003134:	d22080e7          	jalr	-734(ra) # 80002e52 <argint>
    argint(1, &count);
    80003138:	fe840593          	addi	a1,s0,-24
    8000313c:	4505                	li	a0,1
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	d14080e7          	jalr	-748(ra) # 80002e52 <argint>
    return ps((uint8)start, (uint8)count);
    80003146:	fe844583          	lbu	a1,-24(s0)
    8000314a:	fec44503          	lbu	a0,-20(s0)
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	d86080e7          	jalr	-634(ra) # 80001ed4 <ps>
}
    80003156:	60e2                	ld	ra,24(sp)
    80003158:	6442                	ld	s0,16(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret

000000008000315e <sys_schedls>:

uint64 sys_schedls(void)
{
    8000315e:	1141                	addi	sp,sp,-16
    80003160:	e406                	sd	ra,8(sp)
    80003162:	e022                	sd	s0,0(sp)
    80003164:	0800                	addi	s0,sp,16
    schedls();
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	6f4080e7          	jalr	1780(ra) # 8000285a <schedls>
    return 0;
}
    8000316e:	4501                	li	a0,0
    80003170:	60a2                	ld	ra,8(sp)
    80003172:	6402                	ld	s0,0(sp)
    80003174:	0141                	addi	sp,sp,16
    80003176:	8082                	ret

0000000080003178 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003178:	1101                	addi	sp,sp,-32
    8000317a:	ec06                	sd	ra,24(sp)
    8000317c:	e822                	sd	s0,16(sp)
    8000317e:	1000                	addi	s0,sp,32
    int id = 0;
    80003180:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003184:	fec40593          	addi	a1,s0,-20
    80003188:	4501                	li	a0,0
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	cc8080e7          	jalr	-824(ra) # 80002e52 <argint>
    schedset(id - 1);
    80003192:	fec42503          	lw	a0,-20(s0)
    80003196:	357d                	addiw	a0,a0,-1
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	758080e7          	jalr	1880(ra) # 800028f0 <schedset>
    return 0;
}
    800031a0:	4501                	li	a0,0
    800031a2:	60e2                	ld	ra,24(sp)
    800031a4:	6442                	ld	s0,16(sp)
    800031a6:	6105                	addi	sp,sp,32
    800031a8:	8082                	ret

00000000800031aa <sys_yield>:

uint64 sys_yield(void)
{
    800031aa:	1141                	addi	sp,sp,-16
    800031ac:	e406                	sd	ra,8(sp)
    800031ae:	e022                	sd	s0,0(sp)
    800031b0:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    800031b2:	4509                	li	a0,2
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	106080e7          	jalr	262(ra) # 800022ba <yield>
    return 0;
    800031bc:	4501                	li	a0,0
    800031be:	60a2                	ld	ra,8(sp)
    800031c0:	6402                	ld	s0,0(sp)
    800031c2:	0141                	addi	sp,sp,16
    800031c4:	8082                	ret

00000000800031c6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800031c6:	7179                	addi	sp,sp,-48
    800031c8:	f406                	sd	ra,40(sp)
    800031ca:	f022                	sd	s0,32(sp)
    800031cc:	ec26                	sd	s1,24(sp)
    800031ce:	e84a                	sd	s2,16(sp)
    800031d0:	e44e                	sd	s3,8(sp)
    800031d2:	e052                	sd	s4,0(sp)
    800031d4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800031d6:	00005597          	auipc	a1,0x5
    800031da:	2fa58593          	addi	a1,a1,762 # 800084d0 <etext+0x4d0>
    800031de:	00016517          	auipc	a0,0x16
    800031e2:	33a50513          	addi	a0,a0,826 # 80019518 <bcache>
    800031e6:	ffffe097          	auipc	ra,0xffffe
    800031ea:	9c2080e7          	jalr	-1598(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800031ee:	0001e797          	auipc	a5,0x1e
    800031f2:	32a78793          	addi	a5,a5,810 # 80021518 <bcache+0x8000>
    800031f6:	0001e717          	auipc	a4,0x1e
    800031fa:	58a70713          	addi	a4,a4,1418 # 80021780 <bcache+0x8268>
    800031fe:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003202:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003206:	00016497          	auipc	s1,0x16
    8000320a:	32a48493          	addi	s1,s1,810 # 80019530 <bcache+0x18>
    b->next = bcache.head.next;
    8000320e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003210:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003212:	00005a17          	auipc	s4,0x5
    80003216:	2c6a0a13          	addi	s4,s4,710 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    8000321a:	2b893783          	ld	a5,696(s2)
    8000321e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003220:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003224:	85d2                	mv	a1,s4
    80003226:	01048513          	addi	a0,s1,16
    8000322a:	00001097          	auipc	ra,0x1
    8000322e:	4e8080e7          	jalr	1256(ra) # 80004712 <initsleeplock>
    bcache.head.next->prev = b;
    80003232:	2b893783          	ld	a5,696(s2)
    80003236:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003238:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000323c:	45848493          	addi	s1,s1,1112
    80003240:	fd349de3          	bne	s1,s3,8000321a <binit+0x54>
  }
}
    80003244:	70a2                	ld	ra,40(sp)
    80003246:	7402                	ld	s0,32(sp)
    80003248:	64e2                	ld	s1,24(sp)
    8000324a:	6942                	ld	s2,16(sp)
    8000324c:	69a2                	ld	s3,8(sp)
    8000324e:	6a02                	ld	s4,0(sp)
    80003250:	6145                	addi	sp,sp,48
    80003252:	8082                	ret

0000000080003254 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003254:	7179                	addi	sp,sp,-48
    80003256:	f406                	sd	ra,40(sp)
    80003258:	f022                	sd	s0,32(sp)
    8000325a:	ec26                	sd	s1,24(sp)
    8000325c:	e84a                	sd	s2,16(sp)
    8000325e:	e44e                	sd	s3,8(sp)
    80003260:	1800                	addi	s0,sp,48
    80003262:	892a                	mv	s2,a0
    80003264:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003266:	00016517          	auipc	a0,0x16
    8000326a:	2b250513          	addi	a0,a0,690 # 80019518 <bcache>
    8000326e:	ffffe097          	auipc	ra,0xffffe
    80003272:	9ca080e7          	jalr	-1590(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003276:	0001e497          	auipc	s1,0x1e
    8000327a:	55a4b483          	ld	s1,1370(s1) # 800217d0 <bcache+0x82b8>
    8000327e:	0001e797          	auipc	a5,0x1e
    80003282:	50278793          	addi	a5,a5,1282 # 80021780 <bcache+0x8268>
    80003286:	02f48f63          	beq	s1,a5,800032c4 <bread+0x70>
    8000328a:	873e                	mv	a4,a5
    8000328c:	a021                	j	80003294 <bread+0x40>
    8000328e:	68a4                	ld	s1,80(s1)
    80003290:	02e48a63          	beq	s1,a4,800032c4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003294:	449c                	lw	a5,8(s1)
    80003296:	ff279ce3          	bne	a5,s2,8000328e <bread+0x3a>
    8000329a:	44dc                	lw	a5,12(s1)
    8000329c:	ff3799e3          	bne	a5,s3,8000328e <bread+0x3a>
      b->refcnt++;
    800032a0:	40bc                	lw	a5,64(s1)
    800032a2:	2785                	addiw	a5,a5,1
    800032a4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032a6:	00016517          	auipc	a0,0x16
    800032aa:	27250513          	addi	a0,a0,626 # 80019518 <bcache>
    800032ae:	ffffe097          	auipc	ra,0xffffe
    800032b2:	a3e080e7          	jalr	-1474(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    800032b6:	01048513          	addi	a0,s1,16
    800032ba:	00001097          	auipc	ra,0x1
    800032be:	492080e7          	jalr	1170(ra) # 8000474c <acquiresleep>
      return b;
    800032c2:	a8b9                	j	80003320 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032c4:	0001e497          	auipc	s1,0x1e
    800032c8:	5044b483          	ld	s1,1284(s1) # 800217c8 <bcache+0x82b0>
    800032cc:	0001e797          	auipc	a5,0x1e
    800032d0:	4b478793          	addi	a5,a5,1204 # 80021780 <bcache+0x8268>
    800032d4:	00f48863          	beq	s1,a5,800032e4 <bread+0x90>
    800032d8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800032da:	40bc                	lw	a5,64(s1)
    800032dc:	cf81                	beqz	a5,800032f4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032de:	64a4                	ld	s1,72(s1)
    800032e0:	fee49de3          	bne	s1,a4,800032da <bread+0x86>
  panic("bget: no buffers");
    800032e4:	00005517          	auipc	a0,0x5
    800032e8:	1fc50513          	addi	a0,a0,508 # 800084e0 <etext+0x4e0>
    800032ec:	ffffd097          	auipc	ra,0xffffd
    800032f0:	274080e7          	jalr	628(ra) # 80000560 <panic>
      b->dev = dev;
    800032f4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800032f8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800032fc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003300:	4785                	li	a5,1
    80003302:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003304:	00016517          	auipc	a0,0x16
    80003308:	21450513          	addi	a0,a0,532 # 80019518 <bcache>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	9e0080e7          	jalr	-1568(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003314:	01048513          	addi	a0,s1,16
    80003318:	00001097          	auipc	ra,0x1
    8000331c:	434080e7          	jalr	1076(ra) # 8000474c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003320:	409c                	lw	a5,0(s1)
    80003322:	cb89                	beqz	a5,80003334 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003324:	8526                	mv	a0,s1
    80003326:	70a2                	ld	ra,40(sp)
    80003328:	7402                	ld	s0,32(sp)
    8000332a:	64e2                	ld	s1,24(sp)
    8000332c:	6942                	ld	s2,16(sp)
    8000332e:	69a2                	ld	s3,8(sp)
    80003330:	6145                	addi	sp,sp,48
    80003332:	8082                	ret
    virtio_disk_rw(b, 0);
    80003334:	4581                	li	a1,0
    80003336:	8526                	mv	a0,s1
    80003338:	00003097          	auipc	ra,0x3
    8000333c:	0f0080e7          	jalr	240(ra) # 80006428 <virtio_disk_rw>
    b->valid = 1;
    80003340:	4785                	li	a5,1
    80003342:	c09c                	sw	a5,0(s1)
  return b;
    80003344:	b7c5                	j	80003324 <bread+0xd0>

0000000080003346 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003346:	1101                	addi	sp,sp,-32
    80003348:	ec06                	sd	ra,24(sp)
    8000334a:	e822                	sd	s0,16(sp)
    8000334c:	e426                	sd	s1,8(sp)
    8000334e:	1000                	addi	s0,sp,32
    80003350:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003352:	0541                	addi	a0,a0,16
    80003354:	00001097          	auipc	ra,0x1
    80003358:	492080e7          	jalr	1170(ra) # 800047e6 <holdingsleep>
    8000335c:	cd01                	beqz	a0,80003374 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000335e:	4585                	li	a1,1
    80003360:	8526                	mv	a0,s1
    80003362:	00003097          	auipc	ra,0x3
    80003366:	0c6080e7          	jalr	198(ra) # 80006428 <virtio_disk_rw>
}
    8000336a:	60e2                	ld	ra,24(sp)
    8000336c:	6442                	ld	s0,16(sp)
    8000336e:	64a2                	ld	s1,8(sp)
    80003370:	6105                	addi	sp,sp,32
    80003372:	8082                	ret
    panic("bwrite");
    80003374:	00005517          	auipc	a0,0x5
    80003378:	18450513          	addi	a0,a0,388 # 800084f8 <etext+0x4f8>
    8000337c:	ffffd097          	auipc	ra,0xffffd
    80003380:	1e4080e7          	jalr	484(ra) # 80000560 <panic>

0000000080003384 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003384:	1101                	addi	sp,sp,-32
    80003386:	ec06                	sd	ra,24(sp)
    80003388:	e822                	sd	s0,16(sp)
    8000338a:	e426                	sd	s1,8(sp)
    8000338c:	e04a                	sd	s2,0(sp)
    8000338e:	1000                	addi	s0,sp,32
    80003390:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003392:	01050913          	addi	s2,a0,16
    80003396:	854a                	mv	a0,s2
    80003398:	00001097          	auipc	ra,0x1
    8000339c:	44e080e7          	jalr	1102(ra) # 800047e6 <holdingsleep>
    800033a0:	c925                	beqz	a0,80003410 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800033a2:	854a                	mv	a0,s2
    800033a4:	00001097          	auipc	ra,0x1
    800033a8:	3fe080e7          	jalr	1022(ra) # 800047a2 <releasesleep>

  acquire(&bcache.lock);
    800033ac:	00016517          	auipc	a0,0x16
    800033b0:	16c50513          	addi	a0,a0,364 # 80019518 <bcache>
    800033b4:	ffffe097          	auipc	ra,0xffffe
    800033b8:	884080e7          	jalr	-1916(ra) # 80000c38 <acquire>
  b->refcnt--;
    800033bc:	40bc                	lw	a5,64(s1)
    800033be:	37fd                	addiw	a5,a5,-1
    800033c0:	0007871b          	sext.w	a4,a5
    800033c4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800033c6:	e71d                	bnez	a4,800033f4 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800033c8:	68b8                	ld	a4,80(s1)
    800033ca:	64bc                	ld	a5,72(s1)
    800033cc:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800033ce:	68b8                	ld	a4,80(s1)
    800033d0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800033d2:	0001e797          	auipc	a5,0x1e
    800033d6:	14678793          	addi	a5,a5,326 # 80021518 <bcache+0x8000>
    800033da:	2b87b703          	ld	a4,696(a5)
    800033de:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800033e0:	0001e717          	auipc	a4,0x1e
    800033e4:	3a070713          	addi	a4,a4,928 # 80021780 <bcache+0x8268>
    800033e8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800033ea:	2b87b703          	ld	a4,696(a5)
    800033ee:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800033f0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800033f4:	00016517          	auipc	a0,0x16
    800033f8:	12450513          	addi	a0,a0,292 # 80019518 <bcache>
    800033fc:	ffffe097          	auipc	ra,0xffffe
    80003400:	8f0080e7          	jalr	-1808(ra) # 80000cec <release>
}
    80003404:	60e2                	ld	ra,24(sp)
    80003406:	6442                	ld	s0,16(sp)
    80003408:	64a2                	ld	s1,8(sp)
    8000340a:	6902                	ld	s2,0(sp)
    8000340c:	6105                	addi	sp,sp,32
    8000340e:	8082                	ret
    panic("brelse");
    80003410:	00005517          	auipc	a0,0x5
    80003414:	0f050513          	addi	a0,a0,240 # 80008500 <etext+0x500>
    80003418:	ffffd097          	auipc	ra,0xffffd
    8000341c:	148080e7          	jalr	328(ra) # 80000560 <panic>

0000000080003420 <bpin>:

void
bpin(struct buf *b) {
    80003420:	1101                	addi	sp,sp,-32
    80003422:	ec06                	sd	ra,24(sp)
    80003424:	e822                	sd	s0,16(sp)
    80003426:	e426                	sd	s1,8(sp)
    80003428:	1000                	addi	s0,sp,32
    8000342a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000342c:	00016517          	auipc	a0,0x16
    80003430:	0ec50513          	addi	a0,a0,236 # 80019518 <bcache>
    80003434:	ffffe097          	auipc	ra,0xffffe
    80003438:	804080e7          	jalr	-2044(ra) # 80000c38 <acquire>
  b->refcnt++;
    8000343c:	40bc                	lw	a5,64(s1)
    8000343e:	2785                	addiw	a5,a5,1
    80003440:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003442:	00016517          	auipc	a0,0x16
    80003446:	0d650513          	addi	a0,a0,214 # 80019518 <bcache>
    8000344a:	ffffe097          	auipc	ra,0xffffe
    8000344e:	8a2080e7          	jalr	-1886(ra) # 80000cec <release>
}
    80003452:	60e2                	ld	ra,24(sp)
    80003454:	6442                	ld	s0,16(sp)
    80003456:	64a2                	ld	s1,8(sp)
    80003458:	6105                	addi	sp,sp,32
    8000345a:	8082                	ret

000000008000345c <bunpin>:

void
bunpin(struct buf *b) {
    8000345c:	1101                	addi	sp,sp,-32
    8000345e:	ec06                	sd	ra,24(sp)
    80003460:	e822                	sd	s0,16(sp)
    80003462:	e426                	sd	s1,8(sp)
    80003464:	1000                	addi	s0,sp,32
    80003466:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003468:	00016517          	auipc	a0,0x16
    8000346c:	0b050513          	addi	a0,a0,176 # 80019518 <bcache>
    80003470:	ffffd097          	auipc	ra,0xffffd
    80003474:	7c8080e7          	jalr	1992(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003478:	40bc                	lw	a5,64(s1)
    8000347a:	37fd                	addiw	a5,a5,-1
    8000347c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000347e:	00016517          	auipc	a0,0x16
    80003482:	09a50513          	addi	a0,a0,154 # 80019518 <bcache>
    80003486:	ffffe097          	auipc	ra,0xffffe
    8000348a:	866080e7          	jalr	-1946(ra) # 80000cec <release>
}
    8000348e:	60e2                	ld	ra,24(sp)
    80003490:	6442                	ld	s0,16(sp)
    80003492:	64a2                	ld	s1,8(sp)
    80003494:	6105                	addi	sp,sp,32
    80003496:	8082                	ret

0000000080003498 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003498:	1101                	addi	sp,sp,-32
    8000349a:	ec06                	sd	ra,24(sp)
    8000349c:	e822                	sd	s0,16(sp)
    8000349e:	e426                	sd	s1,8(sp)
    800034a0:	e04a                	sd	s2,0(sp)
    800034a2:	1000                	addi	s0,sp,32
    800034a4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800034a6:	00d5d59b          	srliw	a1,a1,0xd
    800034aa:	0001e797          	auipc	a5,0x1e
    800034ae:	74a7a783          	lw	a5,1866(a5) # 80021bf4 <sb+0x1c>
    800034b2:	9dbd                	addw	a1,a1,a5
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	da0080e7          	jalr	-608(ra) # 80003254 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800034bc:	0074f713          	andi	a4,s1,7
    800034c0:	4785                	li	a5,1
    800034c2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800034c6:	14ce                	slli	s1,s1,0x33
    800034c8:	90d9                	srli	s1,s1,0x36
    800034ca:	00950733          	add	a4,a0,s1
    800034ce:	05874703          	lbu	a4,88(a4)
    800034d2:	00e7f6b3          	and	a3,a5,a4
    800034d6:	c69d                	beqz	a3,80003504 <bfree+0x6c>
    800034d8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800034da:	94aa                	add	s1,s1,a0
    800034dc:	fff7c793          	not	a5,a5
    800034e0:	8f7d                	and	a4,a4,a5
    800034e2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800034e6:	00001097          	auipc	ra,0x1
    800034ea:	148080e7          	jalr	328(ra) # 8000462e <log_write>
  brelse(bp);
    800034ee:	854a                	mv	a0,s2
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	e94080e7          	jalr	-364(ra) # 80003384 <brelse>
}
    800034f8:	60e2                	ld	ra,24(sp)
    800034fa:	6442                	ld	s0,16(sp)
    800034fc:	64a2                	ld	s1,8(sp)
    800034fe:	6902                	ld	s2,0(sp)
    80003500:	6105                	addi	sp,sp,32
    80003502:	8082                	ret
    panic("freeing free block");
    80003504:	00005517          	auipc	a0,0x5
    80003508:	00450513          	addi	a0,a0,4 # 80008508 <etext+0x508>
    8000350c:	ffffd097          	auipc	ra,0xffffd
    80003510:	054080e7          	jalr	84(ra) # 80000560 <panic>

0000000080003514 <balloc>:
{
    80003514:	711d                	addi	sp,sp,-96
    80003516:	ec86                	sd	ra,88(sp)
    80003518:	e8a2                	sd	s0,80(sp)
    8000351a:	e4a6                	sd	s1,72(sp)
    8000351c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000351e:	0001e797          	auipc	a5,0x1e
    80003522:	6be7a783          	lw	a5,1726(a5) # 80021bdc <sb+0x4>
    80003526:	10078f63          	beqz	a5,80003644 <balloc+0x130>
    8000352a:	e0ca                	sd	s2,64(sp)
    8000352c:	fc4e                	sd	s3,56(sp)
    8000352e:	f852                	sd	s4,48(sp)
    80003530:	f456                	sd	s5,40(sp)
    80003532:	f05a                	sd	s6,32(sp)
    80003534:	ec5e                	sd	s7,24(sp)
    80003536:	e862                	sd	s8,16(sp)
    80003538:	e466                	sd	s9,8(sp)
    8000353a:	8baa                	mv	s7,a0
    8000353c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000353e:	0001eb17          	auipc	s6,0x1e
    80003542:	69ab0b13          	addi	s6,s6,1690 # 80021bd8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003546:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003548:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000354a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000354c:	6c89                	lui	s9,0x2
    8000354e:	a061                	j	800035d6 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003550:	97ca                	add	a5,a5,s2
    80003552:	8e55                	or	a2,a2,a3
    80003554:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003558:	854a                	mv	a0,s2
    8000355a:	00001097          	auipc	ra,0x1
    8000355e:	0d4080e7          	jalr	212(ra) # 8000462e <log_write>
        brelse(bp);
    80003562:	854a                	mv	a0,s2
    80003564:	00000097          	auipc	ra,0x0
    80003568:	e20080e7          	jalr	-480(ra) # 80003384 <brelse>
  bp = bread(dev, bno);
    8000356c:	85a6                	mv	a1,s1
    8000356e:	855e                	mv	a0,s7
    80003570:	00000097          	auipc	ra,0x0
    80003574:	ce4080e7          	jalr	-796(ra) # 80003254 <bread>
    80003578:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000357a:	40000613          	li	a2,1024
    8000357e:	4581                	li	a1,0
    80003580:	05850513          	addi	a0,a0,88
    80003584:	ffffd097          	auipc	ra,0xffffd
    80003588:	7b0080e7          	jalr	1968(ra) # 80000d34 <memset>
  log_write(bp);
    8000358c:	854a                	mv	a0,s2
    8000358e:	00001097          	auipc	ra,0x1
    80003592:	0a0080e7          	jalr	160(ra) # 8000462e <log_write>
  brelse(bp);
    80003596:	854a                	mv	a0,s2
    80003598:	00000097          	auipc	ra,0x0
    8000359c:	dec080e7          	jalr	-532(ra) # 80003384 <brelse>
}
    800035a0:	6906                	ld	s2,64(sp)
    800035a2:	79e2                	ld	s3,56(sp)
    800035a4:	7a42                	ld	s4,48(sp)
    800035a6:	7aa2                	ld	s5,40(sp)
    800035a8:	7b02                	ld	s6,32(sp)
    800035aa:	6be2                	ld	s7,24(sp)
    800035ac:	6c42                	ld	s8,16(sp)
    800035ae:	6ca2                	ld	s9,8(sp)
}
    800035b0:	8526                	mv	a0,s1
    800035b2:	60e6                	ld	ra,88(sp)
    800035b4:	6446                	ld	s0,80(sp)
    800035b6:	64a6                	ld	s1,72(sp)
    800035b8:	6125                	addi	sp,sp,96
    800035ba:	8082                	ret
    brelse(bp);
    800035bc:	854a                	mv	a0,s2
    800035be:	00000097          	auipc	ra,0x0
    800035c2:	dc6080e7          	jalr	-570(ra) # 80003384 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800035c6:	015c87bb          	addw	a5,s9,s5
    800035ca:	00078a9b          	sext.w	s5,a5
    800035ce:	004b2703          	lw	a4,4(s6)
    800035d2:	06eaf163          	bgeu	s5,a4,80003634 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800035d6:	41fad79b          	sraiw	a5,s5,0x1f
    800035da:	0137d79b          	srliw	a5,a5,0x13
    800035de:	015787bb          	addw	a5,a5,s5
    800035e2:	40d7d79b          	sraiw	a5,a5,0xd
    800035e6:	01cb2583          	lw	a1,28(s6)
    800035ea:	9dbd                	addw	a1,a1,a5
    800035ec:	855e                	mv	a0,s7
    800035ee:	00000097          	auipc	ra,0x0
    800035f2:	c66080e7          	jalr	-922(ra) # 80003254 <bread>
    800035f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035f8:	004b2503          	lw	a0,4(s6)
    800035fc:	000a849b          	sext.w	s1,s5
    80003600:	8762                	mv	a4,s8
    80003602:	faa4fde3          	bgeu	s1,a0,800035bc <balloc+0xa8>
      m = 1 << (bi % 8);
    80003606:	00777693          	andi	a3,a4,7
    8000360a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000360e:	41f7579b          	sraiw	a5,a4,0x1f
    80003612:	01d7d79b          	srliw	a5,a5,0x1d
    80003616:	9fb9                	addw	a5,a5,a4
    80003618:	4037d79b          	sraiw	a5,a5,0x3
    8000361c:	00f90633          	add	a2,s2,a5
    80003620:	05864603          	lbu	a2,88(a2)
    80003624:	00c6f5b3          	and	a1,a3,a2
    80003628:	d585                	beqz	a1,80003550 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000362a:	2705                	addiw	a4,a4,1
    8000362c:	2485                	addiw	s1,s1,1
    8000362e:	fd471ae3          	bne	a4,s4,80003602 <balloc+0xee>
    80003632:	b769                	j	800035bc <balloc+0xa8>
    80003634:	6906                	ld	s2,64(sp)
    80003636:	79e2                	ld	s3,56(sp)
    80003638:	7a42                	ld	s4,48(sp)
    8000363a:	7aa2                	ld	s5,40(sp)
    8000363c:	7b02                	ld	s6,32(sp)
    8000363e:	6be2                	ld	s7,24(sp)
    80003640:	6c42                	ld	s8,16(sp)
    80003642:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003644:	00005517          	auipc	a0,0x5
    80003648:	edc50513          	addi	a0,a0,-292 # 80008520 <etext+0x520>
    8000364c:	ffffd097          	auipc	ra,0xffffd
    80003650:	f5e080e7          	jalr	-162(ra) # 800005aa <printf>
  return 0;
    80003654:	4481                	li	s1,0
    80003656:	bfa9                	j	800035b0 <balloc+0x9c>

0000000080003658 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003658:	7179                	addi	sp,sp,-48
    8000365a:	f406                	sd	ra,40(sp)
    8000365c:	f022                	sd	s0,32(sp)
    8000365e:	ec26                	sd	s1,24(sp)
    80003660:	e84a                	sd	s2,16(sp)
    80003662:	e44e                	sd	s3,8(sp)
    80003664:	1800                	addi	s0,sp,48
    80003666:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003668:	47ad                	li	a5,11
    8000366a:	02b7e863          	bltu	a5,a1,8000369a <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000366e:	02059793          	slli	a5,a1,0x20
    80003672:	01e7d593          	srli	a1,a5,0x1e
    80003676:	00b504b3          	add	s1,a0,a1
    8000367a:	0504a903          	lw	s2,80(s1)
    8000367e:	08091263          	bnez	s2,80003702 <bmap+0xaa>
      addr = balloc(ip->dev);
    80003682:	4108                	lw	a0,0(a0)
    80003684:	00000097          	auipc	ra,0x0
    80003688:	e90080e7          	jalr	-368(ra) # 80003514 <balloc>
    8000368c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003690:	06090963          	beqz	s2,80003702 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003694:	0524a823          	sw	s2,80(s1)
    80003698:	a0ad                	j	80003702 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000369a:	ff45849b          	addiw	s1,a1,-12
    8000369e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800036a2:	0ff00793          	li	a5,255
    800036a6:	08e7e863          	bltu	a5,a4,80003736 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800036aa:	08052903          	lw	s2,128(a0)
    800036ae:	00091f63          	bnez	s2,800036cc <bmap+0x74>
      addr = balloc(ip->dev);
    800036b2:	4108                	lw	a0,0(a0)
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	e60080e7          	jalr	-416(ra) # 80003514 <balloc>
    800036bc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800036c0:	04090163          	beqz	s2,80003702 <bmap+0xaa>
    800036c4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800036c6:	0929a023          	sw	s2,128(s3)
    800036ca:	a011                	j	800036ce <bmap+0x76>
    800036cc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800036ce:	85ca                	mv	a1,s2
    800036d0:	0009a503          	lw	a0,0(s3)
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	b80080e7          	jalr	-1152(ra) # 80003254 <bread>
    800036dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800036de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800036e2:	02049713          	slli	a4,s1,0x20
    800036e6:	01e75593          	srli	a1,a4,0x1e
    800036ea:	00b784b3          	add	s1,a5,a1
    800036ee:	0004a903          	lw	s2,0(s1)
    800036f2:	02090063          	beqz	s2,80003712 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800036f6:	8552                	mv	a0,s4
    800036f8:	00000097          	auipc	ra,0x0
    800036fc:	c8c080e7          	jalr	-884(ra) # 80003384 <brelse>
    return addr;
    80003700:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003702:	854a                	mv	a0,s2
    80003704:	70a2                	ld	ra,40(sp)
    80003706:	7402                	ld	s0,32(sp)
    80003708:	64e2                	ld	s1,24(sp)
    8000370a:	6942                	ld	s2,16(sp)
    8000370c:	69a2                	ld	s3,8(sp)
    8000370e:	6145                	addi	sp,sp,48
    80003710:	8082                	ret
      addr = balloc(ip->dev);
    80003712:	0009a503          	lw	a0,0(s3)
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	dfe080e7          	jalr	-514(ra) # 80003514 <balloc>
    8000371e:	0005091b          	sext.w	s2,a0
      if(addr){
    80003722:	fc090ae3          	beqz	s2,800036f6 <bmap+0x9e>
        a[bn] = addr;
    80003726:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000372a:	8552                	mv	a0,s4
    8000372c:	00001097          	auipc	ra,0x1
    80003730:	f02080e7          	jalr	-254(ra) # 8000462e <log_write>
    80003734:	b7c9                	j	800036f6 <bmap+0x9e>
    80003736:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003738:	00005517          	auipc	a0,0x5
    8000373c:	e0050513          	addi	a0,a0,-512 # 80008538 <etext+0x538>
    80003740:	ffffd097          	auipc	ra,0xffffd
    80003744:	e20080e7          	jalr	-480(ra) # 80000560 <panic>

0000000080003748 <iget>:
{
    80003748:	7179                	addi	sp,sp,-48
    8000374a:	f406                	sd	ra,40(sp)
    8000374c:	f022                	sd	s0,32(sp)
    8000374e:	ec26                	sd	s1,24(sp)
    80003750:	e84a                	sd	s2,16(sp)
    80003752:	e44e                	sd	s3,8(sp)
    80003754:	e052                	sd	s4,0(sp)
    80003756:	1800                	addi	s0,sp,48
    80003758:	89aa                	mv	s3,a0
    8000375a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000375c:	0001e517          	auipc	a0,0x1e
    80003760:	49c50513          	addi	a0,a0,1180 # 80021bf8 <itable>
    80003764:	ffffd097          	auipc	ra,0xffffd
    80003768:	4d4080e7          	jalr	1236(ra) # 80000c38 <acquire>
  empty = 0;
    8000376c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000376e:	0001e497          	auipc	s1,0x1e
    80003772:	4a248493          	addi	s1,s1,1186 # 80021c10 <itable+0x18>
    80003776:	00020697          	auipc	a3,0x20
    8000377a:	f2a68693          	addi	a3,a3,-214 # 800236a0 <log>
    8000377e:	a039                	j	8000378c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003780:	02090b63          	beqz	s2,800037b6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003784:	08848493          	addi	s1,s1,136
    80003788:	02d48a63          	beq	s1,a3,800037bc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000378c:	449c                	lw	a5,8(s1)
    8000378e:	fef059e3          	blez	a5,80003780 <iget+0x38>
    80003792:	4098                	lw	a4,0(s1)
    80003794:	ff3716e3          	bne	a4,s3,80003780 <iget+0x38>
    80003798:	40d8                	lw	a4,4(s1)
    8000379a:	ff4713e3          	bne	a4,s4,80003780 <iget+0x38>
      ip->ref++;
    8000379e:	2785                	addiw	a5,a5,1
    800037a0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800037a2:	0001e517          	auipc	a0,0x1e
    800037a6:	45650513          	addi	a0,a0,1110 # 80021bf8 <itable>
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	542080e7          	jalr	1346(ra) # 80000cec <release>
      return ip;
    800037b2:	8926                	mv	s2,s1
    800037b4:	a03d                	j	800037e2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800037b6:	f7f9                	bnez	a5,80003784 <iget+0x3c>
      empty = ip;
    800037b8:	8926                	mv	s2,s1
    800037ba:	b7e9                	j	80003784 <iget+0x3c>
  if(empty == 0)
    800037bc:	02090c63          	beqz	s2,800037f4 <iget+0xac>
  ip->dev = dev;
    800037c0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800037c4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800037c8:	4785                	li	a5,1
    800037ca:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800037ce:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800037d2:	0001e517          	auipc	a0,0x1e
    800037d6:	42650513          	addi	a0,a0,1062 # 80021bf8 <itable>
    800037da:	ffffd097          	auipc	ra,0xffffd
    800037de:	512080e7          	jalr	1298(ra) # 80000cec <release>
}
    800037e2:	854a                	mv	a0,s2
    800037e4:	70a2                	ld	ra,40(sp)
    800037e6:	7402                	ld	s0,32(sp)
    800037e8:	64e2                	ld	s1,24(sp)
    800037ea:	6942                	ld	s2,16(sp)
    800037ec:	69a2                	ld	s3,8(sp)
    800037ee:	6a02                	ld	s4,0(sp)
    800037f0:	6145                	addi	sp,sp,48
    800037f2:	8082                	ret
    panic("iget: no inodes");
    800037f4:	00005517          	auipc	a0,0x5
    800037f8:	d5c50513          	addi	a0,a0,-676 # 80008550 <etext+0x550>
    800037fc:	ffffd097          	auipc	ra,0xffffd
    80003800:	d64080e7          	jalr	-668(ra) # 80000560 <panic>

0000000080003804 <fsinit>:
fsinit(int dev) {
    80003804:	7179                	addi	sp,sp,-48
    80003806:	f406                	sd	ra,40(sp)
    80003808:	f022                	sd	s0,32(sp)
    8000380a:	ec26                	sd	s1,24(sp)
    8000380c:	e84a                	sd	s2,16(sp)
    8000380e:	e44e                	sd	s3,8(sp)
    80003810:	1800                	addi	s0,sp,48
    80003812:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003814:	4585                	li	a1,1
    80003816:	00000097          	auipc	ra,0x0
    8000381a:	a3e080e7          	jalr	-1474(ra) # 80003254 <bread>
    8000381e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003820:	0001e997          	auipc	s3,0x1e
    80003824:	3b898993          	addi	s3,s3,952 # 80021bd8 <sb>
    80003828:	02000613          	li	a2,32
    8000382c:	05850593          	addi	a1,a0,88
    80003830:	854e                	mv	a0,s3
    80003832:	ffffd097          	auipc	ra,0xffffd
    80003836:	55e080e7          	jalr	1374(ra) # 80000d90 <memmove>
  brelse(bp);
    8000383a:	8526                	mv	a0,s1
    8000383c:	00000097          	auipc	ra,0x0
    80003840:	b48080e7          	jalr	-1208(ra) # 80003384 <brelse>
  if(sb.magic != FSMAGIC)
    80003844:	0009a703          	lw	a4,0(s3)
    80003848:	102037b7          	lui	a5,0x10203
    8000384c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003850:	02f71263          	bne	a4,a5,80003874 <fsinit+0x70>
  initlog(dev, &sb);
    80003854:	0001e597          	auipc	a1,0x1e
    80003858:	38458593          	addi	a1,a1,900 # 80021bd8 <sb>
    8000385c:	854a                	mv	a0,s2
    8000385e:	00001097          	auipc	ra,0x1
    80003862:	b60080e7          	jalr	-1184(ra) # 800043be <initlog>
}
    80003866:	70a2                	ld	ra,40(sp)
    80003868:	7402                	ld	s0,32(sp)
    8000386a:	64e2                	ld	s1,24(sp)
    8000386c:	6942                	ld	s2,16(sp)
    8000386e:	69a2                	ld	s3,8(sp)
    80003870:	6145                	addi	sp,sp,48
    80003872:	8082                	ret
    panic("invalid file system");
    80003874:	00005517          	auipc	a0,0x5
    80003878:	cec50513          	addi	a0,a0,-788 # 80008560 <etext+0x560>
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	ce4080e7          	jalr	-796(ra) # 80000560 <panic>

0000000080003884 <iinit>:
{
    80003884:	7179                	addi	sp,sp,-48
    80003886:	f406                	sd	ra,40(sp)
    80003888:	f022                	sd	s0,32(sp)
    8000388a:	ec26                	sd	s1,24(sp)
    8000388c:	e84a                	sd	s2,16(sp)
    8000388e:	e44e                	sd	s3,8(sp)
    80003890:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003892:	00005597          	auipc	a1,0x5
    80003896:	ce658593          	addi	a1,a1,-794 # 80008578 <etext+0x578>
    8000389a:	0001e517          	auipc	a0,0x1e
    8000389e:	35e50513          	addi	a0,a0,862 # 80021bf8 <itable>
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	306080e7          	jalr	774(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800038aa:	0001e497          	auipc	s1,0x1e
    800038ae:	37648493          	addi	s1,s1,886 # 80021c20 <itable+0x28>
    800038b2:	00020997          	auipc	s3,0x20
    800038b6:	dfe98993          	addi	s3,s3,-514 # 800236b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800038ba:	00005917          	auipc	s2,0x5
    800038be:	cc690913          	addi	s2,s2,-826 # 80008580 <etext+0x580>
    800038c2:	85ca                	mv	a1,s2
    800038c4:	8526                	mv	a0,s1
    800038c6:	00001097          	auipc	ra,0x1
    800038ca:	e4c080e7          	jalr	-436(ra) # 80004712 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800038ce:	08848493          	addi	s1,s1,136
    800038d2:	ff3498e3          	bne	s1,s3,800038c2 <iinit+0x3e>
}
    800038d6:	70a2                	ld	ra,40(sp)
    800038d8:	7402                	ld	s0,32(sp)
    800038da:	64e2                	ld	s1,24(sp)
    800038dc:	6942                	ld	s2,16(sp)
    800038de:	69a2                	ld	s3,8(sp)
    800038e0:	6145                	addi	sp,sp,48
    800038e2:	8082                	ret

00000000800038e4 <ialloc>:
{
    800038e4:	7139                	addi	sp,sp,-64
    800038e6:	fc06                	sd	ra,56(sp)
    800038e8:	f822                	sd	s0,48(sp)
    800038ea:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800038ec:	0001e717          	auipc	a4,0x1e
    800038f0:	2f872703          	lw	a4,760(a4) # 80021be4 <sb+0xc>
    800038f4:	4785                	li	a5,1
    800038f6:	06e7f463          	bgeu	a5,a4,8000395e <ialloc+0x7a>
    800038fa:	f426                	sd	s1,40(sp)
    800038fc:	f04a                	sd	s2,32(sp)
    800038fe:	ec4e                	sd	s3,24(sp)
    80003900:	e852                	sd	s4,16(sp)
    80003902:	e456                	sd	s5,8(sp)
    80003904:	e05a                	sd	s6,0(sp)
    80003906:	8aaa                	mv	s5,a0
    80003908:	8b2e                	mv	s6,a1
    8000390a:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000390c:	0001ea17          	auipc	s4,0x1e
    80003910:	2cca0a13          	addi	s4,s4,716 # 80021bd8 <sb>
    80003914:	00495593          	srli	a1,s2,0x4
    80003918:	018a2783          	lw	a5,24(s4)
    8000391c:	9dbd                	addw	a1,a1,a5
    8000391e:	8556                	mv	a0,s5
    80003920:	00000097          	auipc	ra,0x0
    80003924:	934080e7          	jalr	-1740(ra) # 80003254 <bread>
    80003928:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000392a:	05850993          	addi	s3,a0,88
    8000392e:	00f97793          	andi	a5,s2,15
    80003932:	079a                	slli	a5,a5,0x6
    80003934:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003936:	00099783          	lh	a5,0(s3)
    8000393a:	cf9d                	beqz	a5,80003978 <ialloc+0x94>
    brelse(bp);
    8000393c:	00000097          	auipc	ra,0x0
    80003940:	a48080e7          	jalr	-1464(ra) # 80003384 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003944:	0905                	addi	s2,s2,1
    80003946:	00ca2703          	lw	a4,12(s4)
    8000394a:	0009079b          	sext.w	a5,s2
    8000394e:	fce7e3e3          	bltu	a5,a4,80003914 <ialloc+0x30>
    80003952:	74a2                	ld	s1,40(sp)
    80003954:	7902                	ld	s2,32(sp)
    80003956:	69e2                	ld	s3,24(sp)
    80003958:	6a42                	ld	s4,16(sp)
    8000395a:	6aa2                	ld	s5,8(sp)
    8000395c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	c2a50513          	addi	a0,a0,-982 # 80008588 <etext+0x588>
    80003966:	ffffd097          	auipc	ra,0xffffd
    8000396a:	c44080e7          	jalr	-956(ra) # 800005aa <printf>
  return 0;
    8000396e:	4501                	li	a0,0
}
    80003970:	70e2                	ld	ra,56(sp)
    80003972:	7442                	ld	s0,48(sp)
    80003974:	6121                	addi	sp,sp,64
    80003976:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003978:	04000613          	li	a2,64
    8000397c:	4581                	li	a1,0
    8000397e:	854e                	mv	a0,s3
    80003980:	ffffd097          	auipc	ra,0xffffd
    80003984:	3b4080e7          	jalr	948(ra) # 80000d34 <memset>
      dip->type = type;
    80003988:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000398c:	8526                	mv	a0,s1
    8000398e:	00001097          	auipc	ra,0x1
    80003992:	ca0080e7          	jalr	-864(ra) # 8000462e <log_write>
      brelse(bp);
    80003996:	8526                	mv	a0,s1
    80003998:	00000097          	auipc	ra,0x0
    8000399c:	9ec080e7          	jalr	-1556(ra) # 80003384 <brelse>
      return iget(dev, inum);
    800039a0:	0009059b          	sext.w	a1,s2
    800039a4:	8556                	mv	a0,s5
    800039a6:	00000097          	auipc	ra,0x0
    800039aa:	da2080e7          	jalr	-606(ra) # 80003748 <iget>
    800039ae:	74a2                	ld	s1,40(sp)
    800039b0:	7902                	ld	s2,32(sp)
    800039b2:	69e2                	ld	s3,24(sp)
    800039b4:	6a42                	ld	s4,16(sp)
    800039b6:	6aa2                	ld	s5,8(sp)
    800039b8:	6b02                	ld	s6,0(sp)
    800039ba:	bf5d                	j	80003970 <ialloc+0x8c>

00000000800039bc <iupdate>:
{
    800039bc:	1101                	addi	sp,sp,-32
    800039be:	ec06                	sd	ra,24(sp)
    800039c0:	e822                	sd	s0,16(sp)
    800039c2:	e426                	sd	s1,8(sp)
    800039c4:	e04a                	sd	s2,0(sp)
    800039c6:	1000                	addi	s0,sp,32
    800039c8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039ca:	415c                	lw	a5,4(a0)
    800039cc:	0047d79b          	srliw	a5,a5,0x4
    800039d0:	0001e597          	auipc	a1,0x1e
    800039d4:	2205a583          	lw	a1,544(a1) # 80021bf0 <sb+0x18>
    800039d8:	9dbd                	addw	a1,a1,a5
    800039da:	4108                	lw	a0,0(a0)
    800039dc:	00000097          	auipc	ra,0x0
    800039e0:	878080e7          	jalr	-1928(ra) # 80003254 <bread>
    800039e4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039e6:	05850793          	addi	a5,a0,88
    800039ea:	40d8                	lw	a4,4(s1)
    800039ec:	8b3d                	andi	a4,a4,15
    800039ee:	071a                	slli	a4,a4,0x6
    800039f0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800039f2:	04449703          	lh	a4,68(s1)
    800039f6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800039fa:	04649703          	lh	a4,70(s1)
    800039fe:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003a02:	04849703          	lh	a4,72(s1)
    80003a06:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003a0a:	04a49703          	lh	a4,74(s1)
    80003a0e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003a12:	44f8                	lw	a4,76(s1)
    80003a14:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a16:	03400613          	li	a2,52
    80003a1a:	05048593          	addi	a1,s1,80
    80003a1e:	00c78513          	addi	a0,a5,12
    80003a22:	ffffd097          	auipc	ra,0xffffd
    80003a26:	36e080e7          	jalr	878(ra) # 80000d90 <memmove>
  log_write(bp);
    80003a2a:	854a                	mv	a0,s2
    80003a2c:	00001097          	auipc	ra,0x1
    80003a30:	c02080e7          	jalr	-1022(ra) # 8000462e <log_write>
  brelse(bp);
    80003a34:	854a                	mv	a0,s2
    80003a36:	00000097          	auipc	ra,0x0
    80003a3a:	94e080e7          	jalr	-1714(ra) # 80003384 <brelse>
}
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6902                	ld	s2,0(sp)
    80003a46:	6105                	addi	sp,sp,32
    80003a48:	8082                	ret

0000000080003a4a <idup>:
{
    80003a4a:	1101                	addi	sp,sp,-32
    80003a4c:	ec06                	sd	ra,24(sp)
    80003a4e:	e822                	sd	s0,16(sp)
    80003a50:	e426                	sd	s1,8(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a56:	0001e517          	auipc	a0,0x1e
    80003a5a:	1a250513          	addi	a0,a0,418 # 80021bf8 <itable>
    80003a5e:	ffffd097          	auipc	ra,0xffffd
    80003a62:	1da080e7          	jalr	474(ra) # 80000c38 <acquire>
  ip->ref++;
    80003a66:	449c                	lw	a5,8(s1)
    80003a68:	2785                	addiw	a5,a5,1
    80003a6a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a6c:	0001e517          	auipc	a0,0x1e
    80003a70:	18c50513          	addi	a0,a0,396 # 80021bf8 <itable>
    80003a74:	ffffd097          	auipc	ra,0xffffd
    80003a78:	278080e7          	jalr	632(ra) # 80000cec <release>
}
    80003a7c:	8526                	mv	a0,s1
    80003a7e:	60e2                	ld	ra,24(sp)
    80003a80:	6442                	ld	s0,16(sp)
    80003a82:	64a2                	ld	s1,8(sp)
    80003a84:	6105                	addi	sp,sp,32
    80003a86:	8082                	ret

0000000080003a88 <ilock>:
{
    80003a88:	1101                	addi	sp,sp,-32
    80003a8a:	ec06                	sd	ra,24(sp)
    80003a8c:	e822                	sd	s0,16(sp)
    80003a8e:	e426                	sd	s1,8(sp)
    80003a90:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a92:	c10d                	beqz	a0,80003ab4 <ilock+0x2c>
    80003a94:	84aa                	mv	s1,a0
    80003a96:	451c                	lw	a5,8(a0)
    80003a98:	00f05e63          	blez	a5,80003ab4 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003a9c:	0541                	addi	a0,a0,16
    80003a9e:	00001097          	auipc	ra,0x1
    80003aa2:	cae080e7          	jalr	-850(ra) # 8000474c <acquiresleep>
  if(ip->valid == 0){
    80003aa6:	40bc                	lw	a5,64(s1)
    80003aa8:	cf99                	beqz	a5,80003ac6 <ilock+0x3e>
}
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret
    80003ab4:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003ab6:	00005517          	auipc	a0,0x5
    80003aba:	aea50513          	addi	a0,a0,-1302 # 800085a0 <etext+0x5a0>
    80003abe:	ffffd097          	auipc	ra,0xffffd
    80003ac2:	aa2080e7          	jalr	-1374(ra) # 80000560 <panic>
    80003ac6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ac8:	40dc                	lw	a5,4(s1)
    80003aca:	0047d79b          	srliw	a5,a5,0x4
    80003ace:	0001e597          	auipc	a1,0x1e
    80003ad2:	1225a583          	lw	a1,290(a1) # 80021bf0 <sb+0x18>
    80003ad6:	9dbd                	addw	a1,a1,a5
    80003ad8:	4088                	lw	a0,0(s1)
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	77a080e7          	jalr	1914(ra) # 80003254 <bread>
    80003ae2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ae4:	05850593          	addi	a1,a0,88
    80003ae8:	40dc                	lw	a5,4(s1)
    80003aea:	8bbd                	andi	a5,a5,15
    80003aec:	079a                	slli	a5,a5,0x6
    80003aee:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003af0:	00059783          	lh	a5,0(a1)
    80003af4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003af8:	00259783          	lh	a5,2(a1)
    80003afc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003b00:	00459783          	lh	a5,4(a1)
    80003b04:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003b08:	00659783          	lh	a5,6(a1)
    80003b0c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b10:	459c                	lw	a5,8(a1)
    80003b12:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b14:	03400613          	li	a2,52
    80003b18:	05b1                	addi	a1,a1,12
    80003b1a:	05048513          	addi	a0,s1,80
    80003b1e:	ffffd097          	auipc	ra,0xffffd
    80003b22:	272080e7          	jalr	626(ra) # 80000d90 <memmove>
    brelse(bp);
    80003b26:	854a                	mv	a0,s2
    80003b28:	00000097          	auipc	ra,0x0
    80003b2c:	85c080e7          	jalr	-1956(ra) # 80003384 <brelse>
    ip->valid = 1;
    80003b30:	4785                	li	a5,1
    80003b32:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003b34:	04449783          	lh	a5,68(s1)
    80003b38:	c399                	beqz	a5,80003b3e <ilock+0xb6>
    80003b3a:	6902                	ld	s2,0(sp)
    80003b3c:	b7bd                	j	80003aaa <ilock+0x22>
      panic("ilock: no type");
    80003b3e:	00005517          	auipc	a0,0x5
    80003b42:	a6a50513          	addi	a0,a0,-1430 # 800085a8 <etext+0x5a8>
    80003b46:	ffffd097          	auipc	ra,0xffffd
    80003b4a:	a1a080e7          	jalr	-1510(ra) # 80000560 <panic>

0000000080003b4e <iunlock>:
{
    80003b4e:	1101                	addi	sp,sp,-32
    80003b50:	ec06                	sd	ra,24(sp)
    80003b52:	e822                	sd	s0,16(sp)
    80003b54:	e426                	sd	s1,8(sp)
    80003b56:	e04a                	sd	s2,0(sp)
    80003b58:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b5a:	c905                	beqz	a0,80003b8a <iunlock+0x3c>
    80003b5c:	84aa                	mv	s1,a0
    80003b5e:	01050913          	addi	s2,a0,16
    80003b62:	854a                	mv	a0,s2
    80003b64:	00001097          	auipc	ra,0x1
    80003b68:	c82080e7          	jalr	-894(ra) # 800047e6 <holdingsleep>
    80003b6c:	cd19                	beqz	a0,80003b8a <iunlock+0x3c>
    80003b6e:	449c                	lw	a5,8(s1)
    80003b70:	00f05d63          	blez	a5,80003b8a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003b74:	854a                	mv	a0,s2
    80003b76:	00001097          	auipc	ra,0x1
    80003b7a:	c2c080e7          	jalr	-980(ra) # 800047a2 <releasesleep>
}
    80003b7e:	60e2                	ld	ra,24(sp)
    80003b80:	6442                	ld	s0,16(sp)
    80003b82:	64a2                	ld	s1,8(sp)
    80003b84:	6902                	ld	s2,0(sp)
    80003b86:	6105                	addi	sp,sp,32
    80003b88:	8082                	ret
    panic("iunlock");
    80003b8a:	00005517          	auipc	a0,0x5
    80003b8e:	a2e50513          	addi	a0,a0,-1490 # 800085b8 <etext+0x5b8>
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	9ce080e7          	jalr	-1586(ra) # 80000560 <panic>

0000000080003b9a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b9a:	7179                	addi	sp,sp,-48
    80003b9c:	f406                	sd	ra,40(sp)
    80003b9e:	f022                	sd	s0,32(sp)
    80003ba0:	ec26                	sd	s1,24(sp)
    80003ba2:	e84a                	sd	s2,16(sp)
    80003ba4:	e44e                	sd	s3,8(sp)
    80003ba6:	1800                	addi	s0,sp,48
    80003ba8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003baa:	05050493          	addi	s1,a0,80
    80003bae:	08050913          	addi	s2,a0,128
    80003bb2:	a021                	j	80003bba <itrunc+0x20>
    80003bb4:	0491                	addi	s1,s1,4
    80003bb6:	01248d63          	beq	s1,s2,80003bd0 <itrunc+0x36>
    if(ip->addrs[i]){
    80003bba:	408c                	lw	a1,0(s1)
    80003bbc:	dde5                	beqz	a1,80003bb4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003bbe:	0009a503          	lw	a0,0(s3)
    80003bc2:	00000097          	auipc	ra,0x0
    80003bc6:	8d6080e7          	jalr	-1834(ra) # 80003498 <bfree>
      ip->addrs[i] = 0;
    80003bca:	0004a023          	sw	zero,0(s1)
    80003bce:	b7dd                	j	80003bb4 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003bd0:	0809a583          	lw	a1,128(s3)
    80003bd4:	ed99                	bnez	a1,80003bf2 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003bd6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003bda:	854e                	mv	a0,s3
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	de0080e7          	jalr	-544(ra) # 800039bc <iupdate>
}
    80003be4:	70a2                	ld	ra,40(sp)
    80003be6:	7402                	ld	s0,32(sp)
    80003be8:	64e2                	ld	s1,24(sp)
    80003bea:	6942                	ld	s2,16(sp)
    80003bec:	69a2                	ld	s3,8(sp)
    80003bee:	6145                	addi	sp,sp,48
    80003bf0:	8082                	ret
    80003bf2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003bf4:	0009a503          	lw	a0,0(s3)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	65c080e7          	jalr	1628(ra) # 80003254 <bread>
    80003c00:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003c02:	05850493          	addi	s1,a0,88
    80003c06:	45850913          	addi	s2,a0,1112
    80003c0a:	a021                	j	80003c12 <itrunc+0x78>
    80003c0c:	0491                	addi	s1,s1,4
    80003c0e:	01248b63          	beq	s1,s2,80003c24 <itrunc+0x8a>
      if(a[j])
    80003c12:	408c                	lw	a1,0(s1)
    80003c14:	dde5                	beqz	a1,80003c0c <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003c16:	0009a503          	lw	a0,0(s3)
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	87e080e7          	jalr	-1922(ra) # 80003498 <bfree>
    80003c22:	b7ed                	j	80003c0c <itrunc+0x72>
    brelse(bp);
    80003c24:	8552                	mv	a0,s4
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	75e080e7          	jalr	1886(ra) # 80003384 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003c2e:	0809a583          	lw	a1,128(s3)
    80003c32:	0009a503          	lw	a0,0(s3)
    80003c36:	00000097          	auipc	ra,0x0
    80003c3a:	862080e7          	jalr	-1950(ra) # 80003498 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003c3e:	0809a023          	sw	zero,128(s3)
    80003c42:	6a02                	ld	s4,0(sp)
    80003c44:	bf49                	j	80003bd6 <itrunc+0x3c>

0000000080003c46 <iput>:
{
    80003c46:	1101                	addi	sp,sp,-32
    80003c48:	ec06                	sd	ra,24(sp)
    80003c4a:	e822                	sd	s0,16(sp)
    80003c4c:	e426                	sd	s1,8(sp)
    80003c4e:	1000                	addi	s0,sp,32
    80003c50:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c52:	0001e517          	auipc	a0,0x1e
    80003c56:	fa650513          	addi	a0,a0,-90 # 80021bf8 <itable>
    80003c5a:	ffffd097          	auipc	ra,0xffffd
    80003c5e:	fde080e7          	jalr	-34(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c62:	4498                	lw	a4,8(s1)
    80003c64:	4785                	li	a5,1
    80003c66:	02f70263          	beq	a4,a5,80003c8a <iput+0x44>
  ip->ref--;
    80003c6a:	449c                	lw	a5,8(s1)
    80003c6c:	37fd                	addiw	a5,a5,-1
    80003c6e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c70:	0001e517          	auipc	a0,0x1e
    80003c74:	f8850513          	addi	a0,a0,-120 # 80021bf8 <itable>
    80003c78:	ffffd097          	auipc	ra,0xffffd
    80003c7c:	074080e7          	jalr	116(ra) # 80000cec <release>
}
    80003c80:	60e2                	ld	ra,24(sp)
    80003c82:	6442                	ld	s0,16(sp)
    80003c84:	64a2                	ld	s1,8(sp)
    80003c86:	6105                	addi	sp,sp,32
    80003c88:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c8a:	40bc                	lw	a5,64(s1)
    80003c8c:	dff9                	beqz	a5,80003c6a <iput+0x24>
    80003c8e:	04a49783          	lh	a5,74(s1)
    80003c92:	ffe1                	bnez	a5,80003c6a <iput+0x24>
    80003c94:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003c96:	01048913          	addi	s2,s1,16
    80003c9a:	854a                	mv	a0,s2
    80003c9c:	00001097          	auipc	ra,0x1
    80003ca0:	ab0080e7          	jalr	-1360(ra) # 8000474c <acquiresleep>
    release(&itable.lock);
    80003ca4:	0001e517          	auipc	a0,0x1e
    80003ca8:	f5450513          	addi	a0,a0,-172 # 80021bf8 <itable>
    80003cac:	ffffd097          	auipc	ra,0xffffd
    80003cb0:	040080e7          	jalr	64(ra) # 80000cec <release>
    itrunc(ip);
    80003cb4:	8526                	mv	a0,s1
    80003cb6:	00000097          	auipc	ra,0x0
    80003cba:	ee4080e7          	jalr	-284(ra) # 80003b9a <itrunc>
    ip->type = 0;
    80003cbe:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003cc2:	8526                	mv	a0,s1
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	cf8080e7          	jalr	-776(ra) # 800039bc <iupdate>
    ip->valid = 0;
    80003ccc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003cd0:	854a                	mv	a0,s2
    80003cd2:	00001097          	auipc	ra,0x1
    80003cd6:	ad0080e7          	jalr	-1328(ra) # 800047a2 <releasesleep>
    acquire(&itable.lock);
    80003cda:	0001e517          	auipc	a0,0x1e
    80003cde:	f1e50513          	addi	a0,a0,-226 # 80021bf8 <itable>
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	f56080e7          	jalr	-170(ra) # 80000c38 <acquire>
    80003cea:	6902                	ld	s2,0(sp)
    80003cec:	bfbd                	j	80003c6a <iput+0x24>

0000000080003cee <iunlockput>:
{
    80003cee:	1101                	addi	sp,sp,-32
    80003cf0:	ec06                	sd	ra,24(sp)
    80003cf2:	e822                	sd	s0,16(sp)
    80003cf4:	e426                	sd	s1,8(sp)
    80003cf6:	1000                	addi	s0,sp,32
    80003cf8:	84aa                	mv	s1,a0
  iunlock(ip);
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	e54080e7          	jalr	-428(ra) # 80003b4e <iunlock>
  iput(ip);
    80003d02:	8526                	mv	a0,s1
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	f42080e7          	jalr	-190(ra) # 80003c46 <iput>
}
    80003d0c:	60e2                	ld	ra,24(sp)
    80003d0e:	6442                	ld	s0,16(sp)
    80003d10:	64a2                	ld	s1,8(sp)
    80003d12:	6105                	addi	sp,sp,32
    80003d14:	8082                	ret

0000000080003d16 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d16:	1141                	addi	sp,sp,-16
    80003d18:	e422                	sd	s0,8(sp)
    80003d1a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d1c:	411c                	lw	a5,0(a0)
    80003d1e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003d20:	415c                	lw	a5,4(a0)
    80003d22:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003d24:	04451783          	lh	a5,68(a0)
    80003d28:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003d2c:	04a51783          	lh	a5,74(a0)
    80003d30:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003d34:	04c56783          	lwu	a5,76(a0)
    80003d38:	e99c                	sd	a5,16(a1)
}
    80003d3a:	6422                	ld	s0,8(sp)
    80003d3c:	0141                	addi	sp,sp,16
    80003d3e:	8082                	ret

0000000080003d40 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d40:	457c                	lw	a5,76(a0)
    80003d42:	10d7e563          	bltu	a5,a3,80003e4c <readi+0x10c>
{
    80003d46:	7159                	addi	sp,sp,-112
    80003d48:	f486                	sd	ra,104(sp)
    80003d4a:	f0a2                	sd	s0,96(sp)
    80003d4c:	eca6                	sd	s1,88(sp)
    80003d4e:	e0d2                	sd	s4,64(sp)
    80003d50:	fc56                	sd	s5,56(sp)
    80003d52:	f85a                	sd	s6,48(sp)
    80003d54:	f45e                	sd	s7,40(sp)
    80003d56:	1880                	addi	s0,sp,112
    80003d58:	8b2a                	mv	s6,a0
    80003d5a:	8bae                	mv	s7,a1
    80003d5c:	8a32                	mv	s4,a2
    80003d5e:	84b6                	mv	s1,a3
    80003d60:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003d62:	9f35                	addw	a4,a4,a3
    return 0;
    80003d64:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d66:	0cd76a63          	bltu	a4,a3,80003e3a <readi+0xfa>
    80003d6a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003d6c:	00e7f463          	bgeu	a5,a4,80003d74 <readi+0x34>
    n = ip->size - off;
    80003d70:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d74:	0a0a8963          	beqz	s5,80003e26 <readi+0xe6>
    80003d78:	e8ca                	sd	s2,80(sp)
    80003d7a:	f062                	sd	s8,32(sp)
    80003d7c:	ec66                	sd	s9,24(sp)
    80003d7e:	e86a                	sd	s10,16(sp)
    80003d80:	e46e                	sd	s11,8(sp)
    80003d82:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d84:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d88:	5c7d                	li	s8,-1
    80003d8a:	a82d                	j	80003dc4 <readi+0x84>
    80003d8c:	020d1d93          	slli	s11,s10,0x20
    80003d90:	020ddd93          	srli	s11,s11,0x20
    80003d94:	05890613          	addi	a2,s2,88
    80003d98:	86ee                	mv	a3,s11
    80003d9a:	963a                	add	a2,a2,a4
    80003d9c:	85d2                	mv	a1,s4
    80003d9e:	855e                	mv	a0,s7
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	95e080e7          	jalr	-1698(ra) # 800026fe <either_copyout>
    80003da8:	05850d63          	beq	a0,s8,80003e02 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003dac:	854a                	mv	a0,s2
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	5d6080e7          	jalr	1494(ra) # 80003384 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003db6:	013d09bb          	addw	s3,s10,s3
    80003dba:	009d04bb          	addw	s1,s10,s1
    80003dbe:	9a6e                	add	s4,s4,s11
    80003dc0:	0559fd63          	bgeu	s3,s5,80003e1a <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003dc4:	00a4d59b          	srliw	a1,s1,0xa
    80003dc8:	855a                	mv	a0,s6
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	88e080e7          	jalr	-1906(ra) # 80003658 <bmap>
    80003dd2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003dd6:	c9b1                	beqz	a1,80003e2a <readi+0xea>
    bp = bread(ip->dev, addr);
    80003dd8:	000b2503          	lw	a0,0(s6)
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	478080e7          	jalr	1144(ra) # 80003254 <bread>
    80003de4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003de6:	3ff4f713          	andi	a4,s1,1023
    80003dea:	40ec87bb          	subw	a5,s9,a4
    80003dee:	413a86bb          	subw	a3,s5,s3
    80003df2:	8d3e                	mv	s10,a5
    80003df4:	2781                	sext.w	a5,a5
    80003df6:	0006861b          	sext.w	a2,a3
    80003dfa:	f8f679e3          	bgeu	a2,a5,80003d8c <readi+0x4c>
    80003dfe:	8d36                	mv	s10,a3
    80003e00:	b771                	j	80003d8c <readi+0x4c>
      brelse(bp);
    80003e02:	854a                	mv	a0,s2
    80003e04:	fffff097          	auipc	ra,0xfffff
    80003e08:	580080e7          	jalr	1408(ra) # 80003384 <brelse>
      tot = -1;
    80003e0c:	59fd                	li	s3,-1
      break;
    80003e0e:	6946                	ld	s2,80(sp)
    80003e10:	7c02                	ld	s8,32(sp)
    80003e12:	6ce2                	ld	s9,24(sp)
    80003e14:	6d42                	ld	s10,16(sp)
    80003e16:	6da2                	ld	s11,8(sp)
    80003e18:	a831                	j	80003e34 <readi+0xf4>
    80003e1a:	6946                	ld	s2,80(sp)
    80003e1c:	7c02                	ld	s8,32(sp)
    80003e1e:	6ce2                	ld	s9,24(sp)
    80003e20:	6d42                	ld	s10,16(sp)
    80003e22:	6da2                	ld	s11,8(sp)
    80003e24:	a801                	j	80003e34 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e26:	89d6                	mv	s3,s5
    80003e28:	a031                	j	80003e34 <readi+0xf4>
    80003e2a:	6946                	ld	s2,80(sp)
    80003e2c:	7c02                	ld	s8,32(sp)
    80003e2e:	6ce2                	ld	s9,24(sp)
    80003e30:	6d42                	ld	s10,16(sp)
    80003e32:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003e34:	0009851b          	sext.w	a0,s3
    80003e38:	69a6                	ld	s3,72(sp)
}
    80003e3a:	70a6                	ld	ra,104(sp)
    80003e3c:	7406                	ld	s0,96(sp)
    80003e3e:	64e6                	ld	s1,88(sp)
    80003e40:	6a06                	ld	s4,64(sp)
    80003e42:	7ae2                	ld	s5,56(sp)
    80003e44:	7b42                	ld	s6,48(sp)
    80003e46:	7ba2                	ld	s7,40(sp)
    80003e48:	6165                	addi	sp,sp,112
    80003e4a:	8082                	ret
    return 0;
    80003e4c:	4501                	li	a0,0
}
    80003e4e:	8082                	ret

0000000080003e50 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e50:	457c                	lw	a5,76(a0)
    80003e52:	10d7ee63          	bltu	a5,a3,80003f6e <writei+0x11e>
{
    80003e56:	7159                	addi	sp,sp,-112
    80003e58:	f486                	sd	ra,104(sp)
    80003e5a:	f0a2                	sd	s0,96(sp)
    80003e5c:	e8ca                	sd	s2,80(sp)
    80003e5e:	e0d2                	sd	s4,64(sp)
    80003e60:	fc56                	sd	s5,56(sp)
    80003e62:	f85a                	sd	s6,48(sp)
    80003e64:	f45e                	sd	s7,40(sp)
    80003e66:	1880                	addi	s0,sp,112
    80003e68:	8aaa                	mv	s5,a0
    80003e6a:	8bae                	mv	s7,a1
    80003e6c:	8a32                	mv	s4,a2
    80003e6e:	8936                	mv	s2,a3
    80003e70:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e72:	00e687bb          	addw	a5,a3,a4
    80003e76:	0ed7ee63          	bltu	a5,a3,80003f72 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e7a:	00043737          	lui	a4,0x43
    80003e7e:	0ef76c63          	bltu	a4,a5,80003f76 <writei+0x126>
    80003e82:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e84:	0c0b0d63          	beqz	s6,80003f5e <writei+0x10e>
    80003e88:	eca6                	sd	s1,88(sp)
    80003e8a:	f062                	sd	s8,32(sp)
    80003e8c:	ec66                	sd	s9,24(sp)
    80003e8e:	e86a                	sd	s10,16(sp)
    80003e90:	e46e                	sd	s11,8(sp)
    80003e92:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e94:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e98:	5c7d                	li	s8,-1
    80003e9a:	a091                	j	80003ede <writei+0x8e>
    80003e9c:	020d1d93          	slli	s11,s10,0x20
    80003ea0:	020ddd93          	srli	s11,s11,0x20
    80003ea4:	05848513          	addi	a0,s1,88
    80003ea8:	86ee                	mv	a3,s11
    80003eaa:	8652                	mv	a2,s4
    80003eac:	85de                	mv	a1,s7
    80003eae:	953a                	add	a0,a0,a4
    80003eb0:	fffff097          	auipc	ra,0xfffff
    80003eb4:	8a4080e7          	jalr	-1884(ra) # 80002754 <either_copyin>
    80003eb8:	07850263          	beq	a0,s8,80003f1c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	770080e7          	jalr	1904(ra) # 8000462e <log_write>
    brelse(bp);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	fffff097          	auipc	ra,0xfffff
    80003ecc:	4bc080e7          	jalr	1212(ra) # 80003384 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ed0:	013d09bb          	addw	s3,s10,s3
    80003ed4:	012d093b          	addw	s2,s10,s2
    80003ed8:	9a6e                	add	s4,s4,s11
    80003eda:	0569f663          	bgeu	s3,s6,80003f26 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003ede:	00a9559b          	srliw	a1,s2,0xa
    80003ee2:	8556                	mv	a0,s5
    80003ee4:	fffff097          	auipc	ra,0xfffff
    80003ee8:	774080e7          	jalr	1908(ra) # 80003658 <bmap>
    80003eec:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ef0:	c99d                	beqz	a1,80003f26 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003ef2:	000aa503          	lw	a0,0(s5)
    80003ef6:	fffff097          	auipc	ra,0xfffff
    80003efa:	35e080e7          	jalr	862(ra) # 80003254 <bread>
    80003efe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f00:	3ff97713          	andi	a4,s2,1023
    80003f04:	40ec87bb          	subw	a5,s9,a4
    80003f08:	413b06bb          	subw	a3,s6,s3
    80003f0c:	8d3e                	mv	s10,a5
    80003f0e:	2781                	sext.w	a5,a5
    80003f10:	0006861b          	sext.w	a2,a3
    80003f14:	f8f674e3          	bgeu	a2,a5,80003e9c <writei+0x4c>
    80003f18:	8d36                	mv	s10,a3
    80003f1a:	b749                	j	80003e9c <writei+0x4c>
      brelse(bp);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	fffff097          	auipc	ra,0xfffff
    80003f22:	466080e7          	jalr	1126(ra) # 80003384 <brelse>
  }

  if(off > ip->size)
    80003f26:	04caa783          	lw	a5,76(s5)
    80003f2a:	0327fc63          	bgeu	a5,s2,80003f62 <writei+0x112>
    ip->size = off;
    80003f2e:	052aa623          	sw	s2,76(s5)
    80003f32:	64e6                	ld	s1,88(sp)
    80003f34:	7c02                	ld	s8,32(sp)
    80003f36:	6ce2                	ld	s9,24(sp)
    80003f38:	6d42                	ld	s10,16(sp)
    80003f3a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003f3c:	8556                	mv	a0,s5
    80003f3e:	00000097          	auipc	ra,0x0
    80003f42:	a7e080e7          	jalr	-1410(ra) # 800039bc <iupdate>

  return tot;
    80003f46:	0009851b          	sext.w	a0,s3
    80003f4a:	69a6                	ld	s3,72(sp)
}
    80003f4c:	70a6                	ld	ra,104(sp)
    80003f4e:	7406                	ld	s0,96(sp)
    80003f50:	6946                	ld	s2,80(sp)
    80003f52:	6a06                	ld	s4,64(sp)
    80003f54:	7ae2                	ld	s5,56(sp)
    80003f56:	7b42                	ld	s6,48(sp)
    80003f58:	7ba2                	ld	s7,40(sp)
    80003f5a:	6165                	addi	sp,sp,112
    80003f5c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f5e:	89da                	mv	s3,s6
    80003f60:	bff1                	j	80003f3c <writei+0xec>
    80003f62:	64e6                	ld	s1,88(sp)
    80003f64:	7c02                	ld	s8,32(sp)
    80003f66:	6ce2                	ld	s9,24(sp)
    80003f68:	6d42                	ld	s10,16(sp)
    80003f6a:	6da2                	ld	s11,8(sp)
    80003f6c:	bfc1                	j	80003f3c <writei+0xec>
    return -1;
    80003f6e:	557d                	li	a0,-1
}
    80003f70:	8082                	ret
    return -1;
    80003f72:	557d                	li	a0,-1
    80003f74:	bfe1                	j	80003f4c <writei+0xfc>
    return -1;
    80003f76:	557d                	li	a0,-1
    80003f78:	bfd1                	j	80003f4c <writei+0xfc>

0000000080003f7a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003f7a:	1141                	addi	sp,sp,-16
    80003f7c:	e406                	sd	ra,8(sp)
    80003f7e:	e022                	sd	s0,0(sp)
    80003f80:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f82:	4639                	li	a2,14
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	e80080e7          	jalr	-384(ra) # 80000e04 <strncmp>
}
    80003f8c:	60a2                	ld	ra,8(sp)
    80003f8e:	6402                	ld	s0,0(sp)
    80003f90:	0141                	addi	sp,sp,16
    80003f92:	8082                	ret

0000000080003f94 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f94:	7139                	addi	sp,sp,-64
    80003f96:	fc06                	sd	ra,56(sp)
    80003f98:	f822                	sd	s0,48(sp)
    80003f9a:	f426                	sd	s1,40(sp)
    80003f9c:	f04a                	sd	s2,32(sp)
    80003f9e:	ec4e                	sd	s3,24(sp)
    80003fa0:	e852                	sd	s4,16(sp)
    80003fa2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003fa4:	04451703          	lh	a4,68(a0)
    80003fa8:	4785                	li	a5,1
    80003faa:	00f71a63          	bne	a4,a5,80003fbe <dirlookup+0x2a>
    80003fae:	892a                	mv	s2,a0
    80003fb0:	89ae                	mv	s3,a1
    80003fb2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fb4:	457c                	lw	a5,76(a0)
    80003fb6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003fb8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fba:	e79d                	bnez	a5,80003fe8 <dirlookup+0x54>
    80003fbc:	a8a5                	j	80004034 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003fbe:	00004517          	auipc	a0,0x4
    80003fc2:	60250513          	addi	a0,a0,1538 # 800085c0 <etext+0x5c0>
    80003fc6:	ffffc097          	auipc	ra,0xffffc
    80003fca:	59a080e7          	jalr	1434(ra) # 80000560 <panic>
      panic("dirlookup read");
    80003fce:	00004517          	auipc	a0,0x4
    80003fd2:	60a50513          	addi	a0,a0,1546 # 800085d8 <etext+0x5d8>
    80003fd6:	ffffc097          	auipc	ra,0xffffc
    80003fda:	58a080e7          	jalr	1418(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fde:	24c1                	addiw	s1,s1,16
    80003fe0:	04c92783          	lw	a5,76(s2)
    80003fe4:	04f4f763          	bgeu	s1,a5,80004032 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fe8:	4741                	li	a4,16
    80003fea:	86a6                	mv	a3,s1
    80003fec:	fc040613          	addi	a2,s0,-64
    80003ff0:	4581                	li	a1,0
    80003ff2:	854a                	mv	a0,s2
    80003ff4:	00000097          	auipc	ra,0x0
    80003ff8:	d4c080e7          	jalr	-692(ra) # 80003d40 <readi>
    80003ffc:	47c1                	li	a5,16
    80003ffe:	fcf518e3          	bne	a0,a5,80003fce <dirlookup+0x3a>
    if(de.inum == 0)
    80004002:	fc045783          	lhu	a5,-64(s0)
    80004006:	dfe1                	beqz	a5,80003fde <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004008:	fc240593          	addi	a1,s0,-62
    8000400c:	854e                	mv	a0,s3
    8000400e:	00000097          	auipc	ra,0x0
    80004012:	f6c080e7          	jalr	-148(ra) # 80003f7a <namecmp>
    80004016:	f561                	bnez	a0,80003fde <dirlookup+0x4a>
      if(poff)
    80004018:	000a0463          	beqz	s4,80004020 <dirlookup+0x8c>
        *poff = off;
    8000401c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004020:	fc045583          	lhu	a1,-64(s0)
    80004024:	00092503          	lw	a0,0(s2)
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	720080e7          	jalr	1824(ra) # 80003748 <iget>
    80004030:	a011                	j	80004034 <dirlookup+0xa0>
  return 0;
    80004032:	4501                	li	a0,0
}
    80004034:	70e2                	ld	ra,56(sp)
    80004036:	7442                	ld	s0,48(sp)
    80004038:	74a2                	ld	s1,40(sp)
    8000403a:	7902                	ld	s2,32(sp)
    8000403c:	69e2                	ld	s3,24(sp)
    8000403e:	6a42                	ld	s4,16(sp)
    80004040:	6121                	addi	sp,sp,64
    80004042:	8082                	ret

0000000080004044 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004044:	711d                	addi	sp,sp,-96
    80004046:	ec86                	sd	ra,88(sp)
    80004048:	e8a2                	sd	s0,80(sp)
    8000404a:	e4a6                	sd	s1,72(sp)
    8000404c:	e0ca                	sd	s2,64(sp)
    8000404e:	fc4e                	sd	s3,56(sp)
    80004050:	f852                	sd	s4,48(sp)
    80004052:	f456                	sd	s5,40(sp)
    80004054:	f05a                	sd	s6,32(sp)
    80004056:	ec5e                	sd	s7,24(sp)
    80004058:	e862                	sd	s8,16(sp)
    8000405a:	e466                	sd	s9,8(sp)
    8000405c:	1080                	addi	s0,sp,96
    8000405e:	84aa                	mv	s1,a0
    80004060:	8b2e                	mv	s6,a1
    80004062:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004064:	00054703          	lbu	a4,0(a0)
    80004068:	02f00793          	li	a5,47
    8000406c:	02f70263          	beq	a4,a5,80004090 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004070:	ffffe097          	auipc	ra,0xffffe
    80004074:	aae080e7          	jalr	-1362(ra) # 80001b1e <myproc>
    80004078:	15053503          	ld	a0,336(a0)
    8000407c:	00000097          	auipc	ra,0x0
    80004080:	9ce080e7          	jalr	-1586(ra) # 80003a4a <idup>
    80004084:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004086:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000408a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000408c:	4b85                	li	s7,1
    8000408e:	a875                	j	8000414a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80004090:	4585                	li	a1,1
    80004092:	4505                	li	a0,1
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	6b4080e7          	jalr	1716(ra) # 80003748 <iget>
    8000409c:	8a2a                	mv	s4,a0
    8000409e:	b7e5                	j	80004086 <namex+0x42>
      iunlockput(ip);
    800040a0:	8552                	mv	a0,s4
    800040a2:	00000097          	auipc	ra,0x0
    800040a6:	c4c080e7          	jalr	-948(ra) # 80003cee <iunlockput>
      return 0;
    800040aa:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800040ac:	8552                	mv	a0,s4
    800040ae:	60e6                	ld	ra,88(sp)
    800040b0:	6446                	ld	s0,80(sp)
    800040b2:	64a6                	ld	s1,72(sp)
    800040b4:	6906                	ld	s2,64(sp)
    800040b6:	79e2                	ld	s3,56(sp)
    800040b8:	7a42                	ld	s4,48(sp)
    800040ba:	7aa2                	ld	s5,40(sp)
    800040bc:	7b02                	ld	s6,32(sp)
    800040be:	6be2                	ld	s7,24(sp)
    800040c0:	6c42                	ld	s8,16(sp)
    800040c2:	6ca2                	ld	s9,8(sp)
    800040c4:	6125                	addi	sp,sp,96
    800040c6:	8082                	ret
      iunlock(ip);
    800040c8:	8552                	mv	a0,s4
    800040ca:	00000097          	auipc	ra,0x0
    800040ce:	a84080e7          	jalr	-1404(ra) # 80003b4e <iunlock>
      return ip;
    800040d2:	bfe9                	j	800040ac <namex+0x68>
      iunlockput(ip);
    800040d4:	8552                	mv	a0,s4
    800040d6:	00000097          	auipc	ra,0x0
    800040da:	c18080e7          	jalr	-1000(ra) # 80003cee <iunlockput>
      return 0;
    800040de:	8a4e                	mv	s4,s3
    800040e0:	b7f1                	j	800040ac <namex+0x68>
  len = path - s;
    800040e2:	40998633          	sub	a2,s3,s1
    800040e6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800040ea:	099c5863          	bge	s8,s9,8000417a <namex+0x136>
    memmove(name, s, DIRSIZ);
    800040ee:	4639                	li	a2,14
    800040f0:	85a6                	mv	a1,s1
    800040f2:	8556                	mv	a0,s5
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	c9c080e7          	jalr	-868(ra) # 80000d90 <memmove>
    800040fc:	84ce                	mv	s1,s3
  while(*path == '/')
    800040fe:	0004c783          	lbu	a5,0(s1)
    80004102:	01279763          	bne	a5,s2,80004110 <namex+0xcc>
    path++;
    80004106:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004108:	0004c783          	lbu	a5,0(s1)
    8000410c:	ff278de3          	beq	a5,s2,80004106 <namex+0xc2>
    ilock(ip);
    80004110:	8552                	mv	a0,s4
    80004112:	00000097          	auipc	ra,0x0
    80004116:	976080e7          	jalr	-1674(ra) # 80003a88 <ilock>
    if(ip->type != T_DIR){
    8000411a:	044a1783          	lh	a5,68(s4)
    8000411e:	f97791e3          	bne	a5,s7,800040a0 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004122:	000b0563          	beqz	s6,8000412c <namex+0xe8>
    80004126:	0004c783          	lbu	a5,0(s1)
    8000412a:	dfd9                	beqz	a5,800040c8 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000412c:	4601                	li	a2,0
    8000412e:	85d6                	mv	a1,s5
    80004130:	8552                	mv	a0,s4
    80004132:	00000097          	auipc	ra,0x0
    80004136:	e62080e7          	jalr	-414(ra) # 80003f94 <dirlookup>
    8000413a:	89aa                	mv	s3,a0
    8000413c:	dd41                	beqz	a0,800040d4 <namex+0x90>
    iunlockput(ip);
    8000413e:	8552                	mv	a0,s4
    80004140:	00000097          	auipc	ra,0x0
    80004144:	bae080e7          	jalr	-1106(ra) # 80003cee <iunlockput>
    ip = next;
    80004148:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000414a:	0004c783          	lbu	a5,0(s1)
    8000414e:	01279763          	bne	a5,s2,8000415c <namex+0x118>
    path++;
    80004152:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004154:	0004c783          	lbu	a5,0(s1)
    80004158:	ff278de3          	beq	a5,s2,80004152 <namex+0x10e>
  if(*path == 0)
    8000415c:	cb9d                	beqz	a5,80004192 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000415e:	0004c783          	lbu	a5,0(s1)
    80004162:	89a6                	mv	s3,s1
  len = path - s;
    80004164:	4c81                	li	s9,0
    80004166:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004168:	01278963          	beq	a5,s2,8000417a <namex+0x136>
    8000416c:	dbbd                	beqz	a5,800040e2 <namex+0x9e>
    path++;
    8000416e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004170:	0009c783          	lbu	a5,0(s3)
    80004174:	ff279ce3          	bne	a5,s2,8000416c <namex+0x128>
    80004178:	b7ad                	j	800040e2 <namex+0x9e>
    memmove(name, s, len);
    8000417a:	2601                	sext.w	a2,a2
    8000417c:	85a6                	mv	a1,s1
    8000417e:	8556                	mv	a0,s5
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	c10080e7          	jalr	-1008(ra) # 80000d90 <memmove>
    name[len] = 0;
    80004188:	9cd6                	add	s9,s9,s5
    8000418a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000418e:	84ce                	mv	s1,s3
    80004190:	b7bd                	j	800040fe <namex+0xba>
  if(nameiparent){
    80004192:	f00b0de3          	beqz	s6,800040ac <namex+0x68>
    iput(ip);
    80004196:	8552                	mv	a0,s4
    80004198:	00000097          	auipc	ra,0x0
    8000419c:	aae080e7          	jalr	-1362(ra) # 80003c46 <iput>
    return 0;
    800041a0:	4a01                	li	s4,0
    800041a2:	b729                	j	800040ac <namex+0x68>

00000000800041a4 <dirlink>:
{
    800041a4:	7139                	addi	sp,sp,-64
    800041a6:	fc06                	sd	ra,56(sp)
    800041a8:	f822                	sd	s0,48(sp)
    800041aa:	f04a                	sd	s2,32(sp)
    800041ac:	ec4e                	sd	s3,24(sp)
    800041ae:	e852                	sd	s4,16(sp)
    800041b0:	0080                	addi	s0,sp,64
    800041b2:	892a                	mv	s2,a0
    800041b4:	8a2e                	mv	s4,a1
    800041b6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800041b8:	4601                	li	a2,0
    800041ba:	00000097          	auipc	ra,0x0
    800041be:	dda080e7          	jalr	-550(ra) # 80003f94 <dirlookup>
    800041c2:	ed25                	bnez	a0,8000423a <dirlink+0x96>
    800041c4:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041c6:	04c92483          	lw	s1,76(s2)
    800041ca:	c49d                	beqz	s1,800041f8 <dirlink+0x54>
    800041cc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ce:	4741                	li	a4,16
    800041d0:	86a6                	mv	a3,s1
    800041d2:	fc040613          	addi	a2,s0,-64
    800041d6:	4581                	li	a1,0
    800041d8:	854a                	mv	a0,s2
    800041da:	00000097          	auipc	ra,0x0
    800041de:	b66080e7          	jalr	-1178(ra) # 80003d40 <readi>
    800041e2:	47c1                	li	a5,16
    800041e4:	06f51163          	bne	a0,a5,80004246 <dirlink+0xa2>
    if(de.inum == 0)
    800041e8:	fc045783          	lhu	a5,-64(s0)
    800041ec:	c791                	beqz	a5,800041f8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041ee:	24c1                	addiw	s1,s1,16
    800041f0:	04c92783          	lw	a5,76(s2)
    800041f4:	fcf4ede3          	bltu	s1,a5,800041ce <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800041f8:	4639                	li	a2,14
    800041fa:	85d2                	mv	a1,s4
    800041fc:	fc240513          	addi	a0,s0,-62
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	c3a080e7          	jalr	-966(ra) # 80000e3a <strncpy>
  de.inum = inum;
    80004208:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000420c:	4741                	li	a4,16
    8000420e:	86a6                	mv	a3,s1
    80004210:	fc040613          	addi	a2,s0,-64
    80004214:	4581                	li	a1,0
    80004216:	854a                	mv	a0,s2
    80004218:	00000097          	auipc	ra,0x0
    8000421c:	c38080e7          	jalr	-968(ra) # 80003e50 <writei>
    80004220:	1541                	addi	a0,a0,-16
    80004222:	00a03533          	snez	a0,a0
    80004226:	40a00533          	neg	a0,a0
    8000422a:	74a2                	ld	s1,40(sp)
}
    8000422c:	70e2                	ld	ra,56(sp)
    8000422e:	7442                	ld	s0,48(sp)
    80004230:	7902                	ld	s2,32(sp)
    80004232:	69e2                	ld	s3,24(sp)
    80004234:	6a42                	ld	s4,16(sp)
    80004236:	6121                	addi	sp,sp,64
    80004238:	8082                	ret
    iput(ip);
    8000423a:	00000097          	auipc	ra,0x0
    8000423e:	a0c080e7          	jalr	-1524(ra) # 80003c46 <iput>
    return -1;
    80004242:	557d                	li	a0,-1
    80004244:	b7e5                	j	8000422c <dirlink+0x88>
      panic("dirlink read");
    80004246:	00004517          	auipc	a0,0x4
    8000424a:	3a250513          	addi	a0,a0,930 # 800085e8 <etext+0x5e8>
    8000424e:	ffffc097          	auipc	ra,0xffffc
    80004252:	312080e7          	jalr	786(ra) # 80000560 <panic>

0000000080004256 <namei>:

struct inode*
namei(char *path)
{
    80004256:	1101                	addi	sp,sp,-32
    80004258:	ec06                	sd	ra,24(sp)
    8000425a:	e822                	sd	s0,16(sp)
    8000425c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000425e:	fe040613          	addi	a2,s0,-32
    80004262:	4581                	li	a1,0
    80004264:	00000097          	auipc	ra,0x0
    80004268:	de0080e7          	jalr	-544(ra) # 80004044 <namex>
}
    8000426c:	60e2                	ld	ra,24(sp)
    8000426e:	6442                	ld	s0,16(sp)
    80004270:	6105                	addi	sp,sp,32
    80004272:	8082                	ret

0000000080004274 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004274:	1141                	addi	sp,sp,-16
    80004276:	e406                	sd	ra,8(sp)
    80004278:	e022                	sd	s0,0(sp)
    8000427a:	0800                	addi	s0,sp,16
    8000427c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000427e:	4585                	li	a1,1
    80004280:	00000097          	auipc	ra,0x0
    80004284:	dc4080e7          	jalr	-572(ra) # 80004044 <namex>
}
    80004288:	60a2                	ld	ra,8(sp)
    8000428a:	6402                	ld	s0,0(sp)
    8000428c:	0141                	addi	sp,sp,16
    8000428e:	8082                	ret

0000000080004290 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004290:	1101                	addi	sp,sp,-32
    80004292:	ec06                	sd	ra,24(sp)
    80004294:	e822                	sd	s0,16(sp)
    80004296:	e426                	sd	s1,8(sp)
    80004298:	e04a                	sd	s2,0(sp)
    8000429a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000429c:	0001f917          	auipc	s2,0x1f
    800042a0:	40490913          	addi	s2,s2,1028 # 800236a0 <log>
    800042a4:	01892583          	lw	a1,24(s2)
    800042a8:	02892503          	lw	a0,40(s2)
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	fa8080e7          	jalr	-88(ra) # 80003254 <bread>
    800042b4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800042b6:	02c92603          	lw	a2,44(s2)
    800042ba:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800042bc:	00c05f63          	blez	a2,800042da <write_head+0x4a>
    800042c0:	0001f717          	auipc	a4,0x1f
    800042c4:	41070713          	addi	a4,a4,1040 # 800236d0 <log+0x30>
    800042c8:	87aa                	mv	a5,a0
    800042ca:	060a                	slli	a2,a2,0x2
    800042cc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800042ce:	4314                	lw	a3,0(a4)
    800042d0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800042d2:	0711                	addi	a4,a4,4
    800042d4:	0791                	addi	a5,a5,4
    800042d6:	fec79ce3          	bne	a5,a2,800042ce <write_head+0x3e>
  }
  bwrite(buf);
    800042da:	8526                	mv	a0,s1
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	06a080e7          	jalr	106(ra) # 80003346 <bwrite>
  brelse(buf);
    800042e4:	8526                	mv	a0,s1
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	09e080e7          	jalr	158(ra) # 80003384 <brelse>
}
    800042ee:	60e2                	ld	ra,24(sp)
    800042f0:	6442                	ld	s0,16(sp)
    800042f2:	64a2                	ld	s1,8(sp)
    800042f4:	6902                	ld	s2,0(sp)
    800042f6:	6105                	addi	sp,sp,32
    800042f8:	8082                	ret

00000000800042fa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800042fa:	0001f797          	auipc	a5,0x1f
    800042fe:	3d27a783          	lw	a5,978(a5) # 800236cc <log+0x2c>
    80004302:	0af05d63          	blez	a5,800043bc <install_trans+0xc2>
{
    80004306:	7139                	addi	sp,sp,-64
    80004308:	fc06                	sd	ra,56(sp)
    8000430a:	f822                	sd	s0,48(sp)
    8000430c:	f426                	sd	s1,40(sp)
    8000430e:	f04a                	sd	s2,32(sp)
    80004310:	ec4e                	sd	s3,24(sp)
    80004312:	e852                	sd	s4,16(sp)
    80004314:	e456                	sd	s5,8(sp)
    80004316:	e05a                	sd	s6,0(sp)
    80004318:	0080                	addi	s0,sp,64
    8000431a:	8b2a                	mv	s6,a0
    8000431c:	0001fa97          	auipc	s5,0x1f
    80004320:	3b4a8a93          	addi	s5,s5,948 # 800236d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004324:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004326:	0001f997          	auipc	s3,0x1f
    8000432a:	37a98993          	addi	s3,s3,890 # 800236a0 <log>
    8000432e:	a00d                	j	80004350 <install_trans+0x56>
    brelse(lbuf);
    80004330:	854a                	mv	a0,s2
    80004332:	fffff097          	auipc	ra,0xfffff
    80004336:	052080e7          	jalr	82(ra) # 80003384 <brelse>
    brelse(dbuf);
    8000433a:	8526                	mv	a0,s1
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	048080e7          	jalr	72(ra) # 80003384 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004344:	2a05                	addiw	s4,s4,1
    80004346:	0a91                	addi	s5,s5,4
    80004348:	02c9a783          	lw	a5,44(s3)
    8000434c:	04fa5e63          	bge	s4,a5,800043a8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004350:	0189a583          	lw	a1,24(s3)
    80004354:	014585bb          	addw	a1,a1,s4
    80004358:	2585                	addiw	a1,a1,1
    8000435a:	0289a503          	lw	a0,40(s3)
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	ef6080e7          	jalr	-266(ra) # 80003254 <bread>
    80004366:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004368:	000aa583          	lw	a1,0(s5)
    8000436c:	0289a503          	lw	a0,40(s3)
    80004370:	fffff097          	auipc	ra,0xfffff
    80004374:	ee4080e7          	jalr	-284(ra) # 80003254 <bread>
    80004378:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000437a:	40000613          	li	a2,1024
    8000437e:	05890593          	addi	a1,s2,88
    80004382:	05850513          	addi	a0,a0,88
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	a0a080e7          	jalr	-1526(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000438e:	8526                	mv	a0,s1
    80004390:	fffff097          	auipc	ra,0xfffff
    80004394:	fb6080e7          	jalr	-74(ra) # 80003346 <bwrite>
    if(recovering == 0)
    80004398:	f80b1ce3          	bnez	s6,80004330 <install_trans+0x36>
      bunpin(dbuf);
    8000439c:	8526                	mv	a0,s1
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	0be080e7          	jalr	190(ra) # 8000345c <bunpin>
    800043a6:	b769                	j	80004330 <install_trans+0x36>
}
    800043a8:	70e2                	ld	ra,56(sp)
    800043aa:	7442                	ld	s0,48(sp)
    800043ac:	74a2                	ld	s1,40(sp)
    800043ae:	7902                	ld	s2,32(sp)
    800043b0:	69e2                	ld	s3,24(sp)
    800043b2:	6a42                	ld	s4,16(sp)
    800043b4:	6aa2                	ld	s5,8(sp)
    800043b6:	6b02                	ld	s6,0(sp)
    800043b8:	6121                	addi	sp,sp,64
    800043ba:	8082                	ret
    800043bc:	8082                	ret

00000000800043be <initlog>:
{
    800043be:	7179                	addi	sp,sp,-48
    800043c0:	f406                	sd	ra,40(sp)
    800043c2:	f022                	sd	s0,32(sp)
    800043c4:	ec26                	sd	s1,24(sp)
    800043c6:	e84a                	sd	s2,16(sp)
    800043c8:	e44e                	sd	s3,8(sp)
    800043ca:	1800                	addi	s0,sp,48
    800043cc:	892a                	mv	s2,a0
    800043ce:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800043d0:	0001f497          	auipc	s1,0x1f
    800043d4:	2d048493          	addi	s1,s1,720 # 800236a0 <log>
    800043d8:	00004597          	auipc	a1,0x4
    800043dc:	22058593          	addi	a1,a1,544 # 800085f8 <etext+0x5f8>
    800043e0:	8526                	mv	a0,s1
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	7c6080e7          	jalr	1990(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    800043ea:	0149a583          	lw	a1,20(s3)
    800043ee:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800043f0:	0109a783          	lw	a5,16(s3)
    800043f4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800043f6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800043fa:	854a                	mv	a0,s2
    800043fc:	fffff097          	auipc	ra,0xfffff
    80004400:	e58080e7          	jalr	-424(ra) # 80003254 <bread>
  log.lh.n = lh->n;
    80004404:	4d30                	lw	a2,88(a0)
    80004406:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004408:	00c05f63          	blez	a2,80004426 <initlog+0x68>
    8000440c:	87aa                	mv	a5,a0
    8000440e:	0001f717          	auipc	a4,0x1f
    80004412:	2c270713          	addi	a4,a4,706 # 800236d0 <log+0x30>
    80004416:	060a                	slli	a2,a2,0x2
    80004418:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000441a:	4ff4                	lw	a3,92(a5)
    8000441c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000441e:	0791                	addi	a5,a5,4
    80004420:	0711                	addi	a4,a4,4
    80004422:	fec79ce3          	bne	a5,a2,8000441a <initlog+0x5c>
  brelse(buf);
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	f5e080e7          	jalr	-162(ra) # 80003384 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000442e:	4505                	li	a0,1
    80004430:	00000097          	auipc	ra,0x0
    80004434:	eca080e7          	jalr	-310(ra) # 800042fa <install_trans>
  log.lh.n = 0;
    80004438:	0001f797          	auipc	a5,0x1f
    8000443c:	2807aa23          	sw	zero,660(a5) # 800236cc <log+0x2c>
  write_head(); // clear the log
    80004440:	00000097          	auipc	ra,0x0
    80004444:	e50080e7          	jalr	-432(ra) # 80004290 <write_head>
}
    80004448:	70a2                	ld	ra,40(sp)
    8000444a:	7402                	ld	s0,32(sp)
    8000444c:	64e2                	ld	s1,24(sp)
    8000444e:	6942                	ld	s2,16(sp)
    80004450:	69a2                	ld	s3,8(sp)
    80004452:	6145                	addi	sp,sp,48
    80004454:	8082                	ret

0000000080004456 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004456:	1101                	addi	sp,sp,-32
    80004458:	ec06                	sd	ra,24(sp)
    8000445a:	e822                	sd	s0,16(sp)
    8000445c:	e426                	sd	s1,8(sp)
    8000445e:	e04a                	sd	s2,0(sp)
    80004460:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004462:	0001f517          	auipc	a0,0x1f
    80004466:	23e50513          	addi	a0,a0,574 # 800236a0 <log>
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	7ce080e7          	jalr	1998(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    80004472:	0001f497          	auipc	s1,0x1f
    80004476:	22e48493          	addi	s1,s1,558 # 800236a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000447a:	4979                	li	s2,30
    8000447c:	a039                	j	8000448a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000447e:	85a6                	mv	a1,s1
    80004480:	8526                	mv	a0,s1
    80004482:	ffffe097          	auipc	ra,0xffffe
    80004486:	e74080e7          	jalr	-396(ra) # 800022f6 <sleep>
    if(log.committing){
    8000448a:	50dc                	lw	a5,36(s1)
    8000448c:	fbed                	bnez	a5,8000447e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000448e:	5098                	lw	a4,32(s1)
    80004490:	2705                	addiw	a4,a4,1
    80004492:	0027179b          	slliw	a5,a4,0x2
    80004496:	9fb9                	addw	a5,a5,a4
    80004498:	0017979b          	slliw	a5,a5,0x1
    8000449c:	54d4                	lw	a3,44(s1)
    8000449e:	9fb5                	addw	a5,a5,a3
    800044a0:	00f95963          	bge	s2,a5,800044b2 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800044a4:	85a6                	mv	a1,s1
    800044a6:	8526                	mv	a0,s1
    800044a8:	ffffe097          	auipc	ra,0xffffe
    800044ac:	e4e080e7          	jalr	-434(ra) # 800022f6 <sleep>
    800044b0:	bfe9                	j	8000448a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800044b2:	0001f517          	auipc	a0,0x1f
    800044b6:	1ee50513          	addi	a0,a0,494 # 800236a0 <log>
    800044ba:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800044bc:	ffffd097          	auipc	ra,0xffffd
    800044c0:	830080e7          	jalr	-2000(ra) # 80000cec <release>
      break;
    }
  }
}
    800044c4:	60e2                	ld	ra,24(sp)
    800044c6:	6442                	ld	s0,16(sp)
    800044c8:	64a2                	ld	s1,8(sp)
    800044ca:	6902                	ld	s2,0(sp)
    800044cc:	6105                	addi	sp,sp,32
    800044ce:	8082                	ret

00000000800044d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800044d0:	7139                	addi	sp,sp,-64
    800044d2:	fc06                	sd	ra,56(sp)
    800044d4:	f822                	sd	s0,48(sp)
    800044d6:	f426                	sd	s1,40(sp)
    800044d8:	f04a                	sd	s2,32(sp)
    800044da:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800044dc:	0001f497          	auipc	s1,0x1f
    800044e0:	1c448493          	addi	s1,s1,452 # 800236a0 <log>
    800044e4:	8526                	mv	a0,s1
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	752080e7          	jalr	1874(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    800044ee:	509c                	lw	a5,32(s1)
    800044f0:	37fd                	addiw	a5,a5,-1
    800044f2:	0007891b          	sext.w	s2,a5
    800044f6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800044f8:	50dc                	lw	a5,36(s1)
    800044fa:	e7b9                	bnez	a5,80004548 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800044fc:	06091163          	bnez	s2,8000455e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004500:	0001f497          	auipc	s1,0x1f
    80004504:	1a048493          	addi	s1,s1,416 # 800236a0 <log>
    80004508:	4785                	li	a5,1
    8000450a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000450c:	8526                	mv	a0,s1
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	7de080e7          	jalr	2014(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004516:	54dc                	lw	a5,44(s1)
    80004518:	06f04763          	bgtz	a5,80004586 <end_op+0xb6>
    acquire(&log.lock);
    8000451c:	0001f497          	auipc	s1,0x1f
    80004520:	18448493          	addi	s1,s1,388 # 800236a0 <log>
    80004524:	8526                	mv	a0,s1
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	712080e7          	jalr	1810(ra) # 80000c38 <acquire>
    log.committing = 0;
    8000452e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004532:	8526                	mv	a0,s1
    80004534:	ffffe097          	auipc	ra,0xffffe
    80004538:	e26080e7          	jalr	-474(ra) # 8000235a <wakeup>
    release(&log.lock);
    8000453c:	8526                	mv	a0,s1
    8000453e:	ffffc097          	auipc	ra,0xffffc
    80004542:	7ae080e7          	jalr	1966(ra) # 80000cec <release>
}
    80004546:	a815                	j	8000457a <end_op+0xaa>
    80004548:	ec4e                	sd	s3,24(sp)
    8000454a:	e852                	sd	s4,16(sp)
    8000454c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000454e:	00004517          	auipc	a0,0x4
    80004552:	0b250513          	addi	a0,a0,178 # 80008600 <etext+0x600>
    80004556:	ffffc097          	auipc	ra,0xffffc
    8000455a:	00a080e7          	jalr	10(ra) # 80000560 <panic>
    wakeup(&log);
    8000455e:	0001f497          	auipc	s1,0x1f
    80004562:	14248493          	addi	s1,s1,322 # 800236a0 <log>
    80004566:	8526                	mv	a0,s1
    80004568:	ffffe097          	auipc	ra,0xffffe
    8000456c:	df2080e7          	jalr	-526(ra) # 8000235a <wakeup>
  release(&log.lock);
    80004570:	8526                	mv	a0,s1
    80004572:	ffffc097          	auipc	ra,0xffffc
    80004576:	77a080e7          	jalr	1914(ra) # 80000cec <release>
}
    8000457a:	70e2                	ld	ra,56(sp)
    8000457c:	7442                	ld	s0,48(sp)
    8000457e:	74a2                	ld	s1,40(sp)
    80004580:	7902                	ld	s2,32(sp)
    80004582:	6121                	addi	sp,sp,64
    80004584:	8082                	ret
    80004586:	ec4e                	sd	s3,24(sp)
    80004588:	e852                	sd	s4,16(sp)
    8000458a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000458c:	0001fa97          	auipc	s5,0x1f
    80004590:	144a8a93          	addi	s5,s5,324 # 800236d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004594:	0001fa17          	auipc	s4,0x1f
    80004598:	10ca0a13          	addi	s4,s4,268 # 800236a0 <log>
    8000459c:	018a2583          	lw	a1,24(s4)
    800045a0:	012585bb          	addw	a1,a1,s2
    800045a4:	2585                	addiw	a1,a1,1
    800045a6:	028a2503          	lw	a0,40(s4)
    800045aa:	fffff097          	auipc	ra,0xfffff
    800045ae:	caa080e7          	jalr	-854(ra) # 80003254 <bread>
    800045b2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800045b4:	000aa583          	lw	a1,0(s5)
    800045b8:	028a2503          	lw	a0,40(s4)
    800045bc:	fffff097          	auipc	ra,0xfffff
    800045c0:	c98080e7          	jalr	-872(ra) # 80003254 <bread>
    800045c4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800045c6:	40000613          	li	a2,1024
    800045ca:	05850593          	addi	a1,a0,88
    800045ce:	05848513          	addi	a0,s1,88
    800045d2:	ffffc097          	auipc	ra,0xffffc
    800045d6:	7be080e7          	jalr	1982(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    800045da:	8526                	mv	a0,s1
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	d6a080e7          	jalr	-662(ra) # 80003346 <bwrite>
    brelse(from);
    800045e4:	854e                	mv	a0,s3
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	d9e080e7          	jalr	-610(ra) # 80003384 <brelse>
    brelse(to);
    800045ee:	8526                	mv	a0,s1
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	d94080e7          	jalr	-620(ra) # 80003384 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045f8:	2905                	addiw	s2,s2,1
    800045fa:	0a91                	addi	s5,s5,4
    800045fc:	02ca2783          	lw	a5,44(s4)
    80004600:	f8f94ee3          	blt	s2,a5,8000459c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004604:	00000097          	auipc	ra,0x0
    80004608:	c8c080e7          	jalr	-884(ra) # 80004290 <write_head>
    install_trans(0); // Now install writes to home locations
    8000460c:	4501                	li	a0,0
    8000460e:	00000097          	auipc	ra,0x0
    80004612:	cec080e7          	jalr	-788(ra) # 800042fa <install_trans>
    log.lh.n = 0;
    80004616:	0001f797          	auipc	a5,0x1f
    8000461a:	0a07ab23          	sw	zero,182(a5) # 800236cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000461e:	00000097          	auipc	ra,0x0
    80004622:	c72080e7          	jalr	-910(ra) # 80004290 <write_head>
    80004626:	69e2                	ld	s3,24(sp)
    80004628:	6a42                	ld	s4,16(sp)
    8000462a:	6aa2                	ld	s5,8(sp)
    8000462c:	bdc5                	j	8000451c <end_op+0x4c>

000000008000462e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000462e:	1101                	addi	sp,sp,-32
    80004630:	ec06                	sd	ra,24(sp)
    80004632:	e822                	sd	s0,16(sp)
    80004634:	e426                	sd	s1,8(sp)
    80004636:	e04a                	sd	s2,0(sp)
    80004638:	1000                	addi	s0,sp,32
    8000463a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000463c:	0001f917          	auipc	s2,0x1f
    80004640:	06490913          	addi	s2,s2,100 # 800236a0 <log>
    80004644:	854a                	mv	a0,s2
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	5f2080e7          	jalr	1522(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000464e:	02c92603          	lw	a2,44(s2)
    80004652:	47f5                	li	a5,29
    80004654:	06c7c563          	blt	a5,a2,800046be <log_write+0x90>
    80004658:	0001f797          	auipc	a5,0x1f
    8000465c:	0647a783          	lw	a5,100(a5) # 800236bc <log+0x1c>
    80004660:	37fd                	addiw	a5,a5,-1
    80004662:	04f65e63          	bge	a2,a5,800046be <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004666:	0001f797          	auipc	a5,0x1f
    8000466a:	05a7a783          	lw	a5,90(a5) # 800236c0 <log+0x20>
    8000466e:	06f05063          	blez	a5,800046ce <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004672:	4781                	li	a5,0
    80004674:	06c05563          	blez	a2,800046de <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004678:	44cc                	lw	a1,12(s1)
    8000467a:	0001f717          	auipc	a4,0x1f
    8000467e:	05670713          	addi	a4,a4,86 # 800236d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004682:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004684:	4314                	lw	a3,0(a4)
    80004686:	04b68c63          	beq	a3,a1,800046de <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000468a:	2785                	addiw	a5,a5,1
    8000468c:	0711                	addi	a4,a4,4
    8000468e:	fef61be3          	bne	a2,a5,80004684 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004692:	0621                	addi	a2,a2,8
    80004694:	060a                	slli	a2,a2,0x2
    80004696:	0001f797          	auipc	a5,0x1f
    8000469a:	00a78793          	addi	a5,a5,10 # 800236a0 <log>
    8000469e:	97b2                	add	a5,a5,a2
    800046a0:	44d8                	lw	a4,12(s1)
    800046a2:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800046a4:	8526                	mv	a0,s1
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	d7a080e7          	jalr	-646(ra) # 80003420 <bpin>
    log.lh.n++;
    800046ae:	0001f717          	auipc	a4,0x1f
    800046b2:	ff270713          	addi	a4,a4,-14 # 800236a0 <log>
    800046b6:	575c                	lw	a5,44(a4)
    800046b8:	2785                	addiw	a5,a5,1
    800046ba:	d75c                	sw	a5,44(a4)
    800046bc:	a82d                	j	800046f6 <log_write+0xc8>
    panic("too big a transaction");
    800046be:	00004517          	auipc	a0,0x4
    800046c2:	f5250513          	addi	a0,a0,-174 # 80008610 <etext+0x610>
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	e9a080e7          	jalr	-358(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    800046ce:	00004517          	auipc	a0,0x4
    800046d2:	f5a50513          	addi	a0,a0,-166 # 80008628 <etext+0x628>
    800046d6:	ffffc097          	auipc	ra,0xffffc
    800046da:	e8a080e7          	jalr	-374(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    800046de:	00878693          	addi	a3,a5,8
    800046e2:	068a                	slli	a3,a3,0x2
    800046e4:	0001f717          	auipc	a4,0x1f
    800046e8:	fbc70713          	addi	a4,a4,-68 # 800236a0 <log>
    800046ec:	9736                	add	a4,a4,a3
    800046ee:	44d4                	lw	a3,12(s1)
    800046f0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800046f2:	faf609e3          	beq	a2,a5,800046a4 <log_write+0x76>
  }
  release(&log.lock);
    800046f6:	0001f517          	auipc	a0,0x1f
    800046fa:	faa50513          	addi	a0,a0,-86 # 800236a0 <log>
    800046fe:	ffffc097          	auipc	ra,0xffffc
    80004702:	5ee080e7          	jalr	1518(ra) # 80000cec <release>
}
    80004706:	60e2                	ld	ra,24(sp)
    80004708:	6442                	ld	s0,16(sp)
    8000470a:	64a2                	ld	s1,8(sp)
    8000470c:	6902                	ld	s2,0(sp)
    8000470e:	6105                	addi	sp,sp,32
    80004710:	8082                	ret

0000000080004712 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004712:	1101                	addi	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	e426                	sd	s1,8(sp)
    8000471a:	e04a                	sd	s2,0(sp)
    8000471c:	1000                	addi	s0,sp,32
    8000471e:	84aa                	mv	s1,a0
    80004720:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004722:	00004597          	auipc	a1,0x4
    80004726:	f2658593          	addi	a1,a1,-218 # 80008648 <etext+0x648>
    8000472a:	0521                	addi	a0,a0,8
    8000472c:	ffffc097          	auipc	ra,0xffffc
    80004730:	47c080e7          	jalr	1148(ra) # 80000ba8 <initlock>
  lk->name = name;
    80004734:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004738:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000473c:	0204a423          	sw	zero,40(s1)
}
    80004740:	60e2                	ld	ra,24(sp)
    80004742:	6442                	ld	s0,16(sp)
    80004744:	64a2                	ld	s1,8(sp)
    80004746:	6902                	ld	s2,0(sp)
    80004748:	6105                	addi	sp,sp,32
    8000474a:	8082                	ret

000000008000474c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000474c:	1101                	addi	sp,sp,-32
    8000474e:	ec06                	sd	ra,24(sp)
    80004750:	e822                	sd	s0,16(sp)
    80004752:	e426                	sd	s1,8(sp)
    80004754:	e04a                	sd	s2,0(sp)
    80004756:	1000                	addi	s0,sp,32
    80004758:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000475a:	00850913          	addi	s2,a0,8
    8000475e:	854a                	mv	a0,s2
    80004760:	ffffc097          	auipc	ra,0xffffc
    80004764:	4d8080e7          	jalr	1240(ra) # 80000c38 <acquire>
  while (lk->locked) {
    80004768:	409c                	lw	a5,0(s1)
    8000476a:	cb89                	beqz	a5,8000477c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000476c:	85ca                	mv	a1,s2
    8000476e:	8526                	mv	a0,s1
    80004770:	ffffe097          	auipc	ra,0xffffe
    80004774:	b86080e7          	jalr	-1146(ra) # 800022f6 <sleep>
  while (lk->locked) {
    80004778:	409c                	lw	a5,0(s1)
    8000477a:	fbed                	bnez	a5,8000476c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000477c:	4785                	li	a5,1
    8000477e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004780:	ffffd097          	auipc	ra,0xffffd
    80004784:	39e080e7          	jalr	926(ra) # 80001b1e <myproc>
    80004788:	591c                	lw	a5,48(a0)
    8000478a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000478c:	854a                	mv	a0,s2
    8000478e:	ffffc097          	auipc	ra,0xffffc
    80004792:	55e080e7          	jalr	1374(ra) # 80000cec <release>
}
    80004796:	60e2                	ld	ra,24(sp)
    80004798:	6442                	ld	s0,16(sp)
    8000479a:	64a2                	ld	s1,8(sp)
    8000479c:	6902                	ld	s2,0(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800047a2:	1101                	addi	sp,sp,-32
    800047a4:	ec06                	sd	ra,24(sp)
    800047a6:	e822                	sd	s0,16(sp)
    800047a8:	e426                	sd	s1,8(sp)
    800047aa:	e04a                	sd	s2,0(sp)
    800047ac:	1000                	addi	s0,sp,32
    800047ae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047b0:	00850913          	addi	s2,a0,8
    800047b4:	854a                	mv	a0,s2
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	482080e7          	jalr	1154(ra) # 80000c38 <acquire>
  lk->locked = 0;
    800047be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047c2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800047c6:	8526                	mv	a0,s1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	b92080e7          	jalr	-1134(ra) # 8000235a <wakeup>
  release(&lk->lk);
    800047d0:	854a                	mv	a0,s2
    800047d2:	ffffc097          	auipc	ra,0xffffc
    800047d6:	51a080e7          	jalr	1306(ra) # 80000cec <release>
}
    800047da:	60e2                	ld	ra,24(sp)
    800047dc:	6442                	ld	s0,16(sp)
    800047de:	64a2                	ld	s1,8(sp)
    800047e0:	6902                	ld	s2,0(sp)
    800047e2:	6105                	addi	sp,sp,32
    800047e4:	8082                	ret

00000000800047e6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800047e6:	7179                	addi	sp,sp,-48
    800047e8:	f406                	sd	ra,40(sp)
    800047ea:	f022                	sd	s0,32(sp)
    800047ec:	ec26                	sd	s1,24(sp)
    800047ee:	e84a                	sd	s2,16(sp)
    800047f0:	1800                	addi	s0,sp,48
    800047f2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800047f4:	00850913          	addi	s2,a0,8
    800047f8:	854a                	mv	a0,s2
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	43e080e7          	jalr	1086(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004802:	409c                	lw	a5,0(s1)
    80004804:	ef91                	bnez	a5,80004820 <holdingsleep+0x3a>
    80004806:	4481                	li	s1,0
  release(&lk->lk);
    80004808:	854a                	mv	a0,s2
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	4e2080e7          	jalr	1250(ra) # 80000cec <release>
  return r;
}
    80004812:	8526                	mv	a0,s1
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	64e2                	ld	s1,24(sp)
    8000481a:	6942                	ld	s2,16(sp)
    8000481c:	6145                	addi	sp,sp,48
    8000481e:	8082                	ret
    80004820:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004822:	0284a983          	lw	s3,40(s1)
    80004826:	ffffd097          	auipc	ra,0xffffd
    8000482a:	2f8080e7          	jalr	760(ra) # 80001b1e <myproc>
    8000482e:	5904                	lw	s1,48(a0)
    80004830:	413484b3          	sub	s1,s1,s3
    80004834:	0014b493          	seqz	s1,s1
    80004838:	69a2                	ld	s3,8(sp)
    8000483a:	b7f9                	j	80004808 <holdingsleep+0x22>

000000008000483c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000483c:	1141                	addi	sp,sp,-16
    8000483e:	e406                	sd	ra,8(sp)
    80004840:	e022                	sd	s0,0(sp)
    80004842:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004844:	00004597          	auipc	a1,0x4
    80004848:	e1458593          	addi	a1,a1,-492 # 80008658 <etext+0x658>
    8000484c:	0001f517          	auipc	a0,0x1f
    80004850:	f9c50513          	addi	a0,a0,-100 # 800237e8 <ftable>
    80004854:	ffffc097          	auipc	ra,0xffffc
    80004858:	354080e7          	jalr	852(ra) # 80000ba8 <initlock>
}
    8000485c:	60a2                	ld	ra,8(sp)
    8000485e:	6402                	ld	s0,0(sp)
    80004860:	0141                	addi	sp,sp,16
    80004862:	8082                	ret

0000000080004864 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004864:	1101                	addi	sp,sp,-32
    80004866:	ec06                	sd	ra,24(sp)
    80004868:	e822                	sd	s0,16(sp)
    8000486a:	e426                	sd	s1,8(sp)
    8000486c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000486e:	0001f517          	auipc	a0,0x1f
    80004872:	f7a50513          	addi	a0,a0,-134 # 800237e8 <ftable>
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	3c2080e7          	jalr	962(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000487e:	0001f497          	auipc	s1,0x1f
    80004882:	f8248493          	addi	s1,s1,-126 # 80023800 <ftable+0x18>
    80004886:	00020717          	auipc	a4,0x20
    8000488a:	f1a70713          	addi	a4,a4,-230 # 800247a0 <disk>
    if(f->ref == 0){
    8000488e:	40dc                	lw	a5,4(s1)
    80004890:	cf99                	beqz	a5,800048ae <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004892:	02848493          	addi	s1,s1,40
    80004896:	fee49ce3          	bne	s1,a4,8000488e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000489a:	0001f517          	auipc	a0,0x1f
    8000489e:	f4e50513          	addi	a0,a0,-178 # 800237e8 <ftable>
    800048a2:	ffffc097          	auipc	ra,0xffffc
    800048a6:	44a080e7          	jalr	1098(ra) # 80000cec <release>
  return 0;
    800048aa:	4481                	li	s1,0
    800048ac:	a819                	j	800048c2 <filealloc+0x5e>
      f->ref = 1;
    800048ae:	4785                	li	a5,1
    800048b0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800048b2:	0001f517          	auipc	a0,0x1f
    800048b6:	f3650513          	addi	a0,a0,-202 # 800237e8 <ftable>
    800048ba:	ffffc097          	auipc	ra,0xffffc
    800048be:	432080e7          	jalr	1074(ra) # 80000cec <release>
}
    800048c2:	8526                	mv	a0,s1
    800048c4:	60e2                	ld	ra,24(sp)
    800048c6:	6442                	ld	s0,16(sp)
    800048c8:	64a2                	ld	s1,8(sp)
    800048ca:	6105                	addi	sp,sp,32
    800048cc:	8082                	ret

00000000800048ce <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800048ce:	1101                	addi	sp,sp,-32
    800048d0:	ec06                	sd	ra,24(sp)
    800048d2:	e822                	sd	s0,16(sp)
    800048d4:	e426                	sd	s1,8(sp)
    800048d6:	1000                	addi	s0,sp,32
    800048d8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800048da:	0001f517          	auipc	a0,0x1f
    800048de:	f0e50513          	addi	a0,a0,-242 # 800237e8 <ftable>
    800048e2:	ffffc097          	auipc	ra,0xffffc
    800048e6:	356080e7          	jalr	854(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    800048ea:	40dc                	lw	a5,4(s1)
    800048ec:	02f05263          	blez	a5,80004910 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800048f0:	2785                	addiw	a5,a5,1
    800048f2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800048f4:	0001f517          	auipc	a0,0x1f
    800048f8:	ef450513          	addi	a0,a0,-268 # 800237e8 <ftable>
    800048fc:	ffffc097          	auipc	ra,0xffffc
    80004900:	3f0080e7          	jalr	1008(ra) # 80000cec <release>
  return f;
}
    80004904:	8526                	mv	a0,s1
    80004906:	60e2                	ld	ra,24(sp)
    80004908:	6442                	ld	s0,16(sp)
    8000490a:	64a2                	ld	s1,8(sp)
    8000490c:	6105                	addi	sp,sp,32
    8000490e:	8082                	ret
    panic("filedup");
    80004910:	00004517          	auipc	a0,0x4
    80004914:	d5050513          	addi	a0,a0,-688 # 80008660 <etext+0x660>
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	c48080e7          	jalr	-952(ra) # 80000560 <panic>

0000000080004920 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004920:	7139                	addi	sp,sp,-64
    80004922:	fc06                	sd	ra,56(sp)
    80004924:	f822                	sd	s0,48(sp)
    80004926:	f426                	sd	s1,40(sp)
    80004928:	0080                	addi	s0,sp,64
    8000492a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000492c:	0001f517          	auipc	a0,0x1f
    80004930:	ebc50513          	addi	a0,a0,-324 # 800237e8 <ftable>
    80004934:	ffffc097          	auipc	ra,0xffffc
    80004938:	304080e7          	jalr	772(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    8000493c:	40dc                	lw	a5,4(s1)
    8000493e:	04f05c63          	blez	a5,80004996 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004942:	37fd                	addiw	a5,a5,-1
    80004944:	0007871b          	sext.w	a4,a5
    80004948:	c0dc                	sw	a5,4(s1)
    8000494a:	06e04263          	bgtz	a4,800049ae <fileclose+0x8e>
    8000494e:	f04a                	sd	s2,32(sp)
    80004950:	ec4e                	sd	s3,24(sp)
    80004952:	e852                	sd	s4,16(sp)
    80004954:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004956:	0004a903          	lw	s2,0(s1)
    8000495a:	0094ca83          	lbu	s5,9(s1)
    8000495e:	0104ba03          	ld	s4,16(s1)
    80004962:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004966:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000496a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000496e:	0001f517          	auipc	a0,0x1f
    80004972:	e7a50513          	addi	a0,a0,-390 # 800237e8 <ftable>
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	376080e7          	jalr	886(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    8000497e:	4785                	li	a5,1
    80004980:	04f90463          	beq	s2,a5,800049c8 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004984:	3979                	addiw	s2,s2,-2
    80004986:	4785                	li	a5,1
    80004988:	0527fb63          	bgeu	a5,s2,800049de <fileclose+0xbe>
    8000498c:	7902                	ld	s2,32(sp)
    8000498e:	69e2                	ld	s3,24(sp)
    80004990:	6a42                	ld	s4,16(sp)
    80004992:	6aa2                	ld	s5,8(sp)
    80004994:	a02d                	j	800049be <fileclose+0x9e>
    80004996:	f04a                	sd	s2,32(sp)
    80004998:	ec4e                	sd	s3,24(sp)
    8000499a:	e852                	sd	s4,16(sp)
    8000499c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000499e:	00004517          	auipc	a0,0x4
    800049a2:	cca50513          	addi	a0,a0,-822 # 80008668 <etext+0x668>
    800049a6:	ffffc097          	auipc	ra,0xffffc
    800049aa:	bba080e7          	jalr	-1094(ra) # 80000560 <panic>
    release(&ftable.lock);
    800049ae:	0001f517          	auipc	a0,0x1f
    800049b2:	e3a50513          	addi	a0,a0,-454 # 800237e8 <ftable>
    800049b6:	ffffc097          	auipc	ra,0xffffc
    800049ba:	336080e7          	jalr	822(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800049be:	70e2                	ld	ra,56(sp)
    800049c0:	7442                	ld	s0,48(sp)
    800049c2:	74a2                	ld	s1,40(sp)
    800049c4:	6121                	addi	sp,sp,64
    800049c6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800049c8:	85d6                	mv	a1,s5
    800049ca:	8552                	mv	a0,s4
    800049cc:	00000097          	auipc	ra,0x0
    800049d0:	3a2080e7          	jalr	930(ra) # 80004d6e <pipeclose>
    800049d4:	7902                	ld	s2,32(sp)
    800049d6:	69e2                	ld	s3,24(sp)
    800049d8:	6a42                	ld	s4,16(sp)
    800049da:	6aa2                	ld	s5,8(sp)
    800049dc:	b7cd                	j	800049be <fileclose+0x9e>
    begin_op();
    800049de:	00000097          	auipc	ra,0x0
    800049e2:	a78080e7          	jalr	-1416(ra) # 80004456 <begin_op>
    iput(ff.ip);
    800049e6:	854e                	mv	a0,s3
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	25e080e7          	jalr	606(ra) # 80003c46 <iput>
    end_op();
    800049f0:	00000097          	auipc	ra,0x0
    800049f4:	ae0080e7          	jalr	-1312(ra) # 800044d0 <end_op>
    800049f8:	7902                	ld	s2,32(sp)
    800049fa:	69e2                	ld	s3,24(sp)
    800049fc:	6a42                	ld	s4,16(sp)
    800049fe:	6aa2                	ld	s5,8(sp)
    80004a00:	bf7d                	j	800049be <fileclose+0x9e>

0000000080004a02 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a02:	715d                	addi	sp,sp,-80
    80004a04:	e486                	sd	ra,72(sp)
    80004a06:	e0a2                	sd	s0,64(sp)
    80004a08:	fc26                	sd	s1,56(sp)
    80004a0a:	f44e                	sd	s3,40(sp)
    80004a0c:	0880                	addi	s0,sp,80
    80004a0e:	84aa                	mv	s1,a0
    80004a10:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a12:	ffffd097          	auipc	ra,0xffffd
    80004a16:	10c080e7          	jalr	268(ra) # 80001b1e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a1a:	409c                	lw	a5,0(s1)
    80004a1c:	37f9                	addiw	a5,a5,-2
    80004a1e:	4705                	li	a4,1
    80004a20:	04f76863          	bltu	a4,a5,80004a70 <filestat+0x6e>
    80004a24:	f84a                	sd	s2,48(sp)
    80004a26:	892a                	mv	s2,a0
    ilock(f->ip);
    80004a28:	6c88                	ld	a0,24(s1)
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	05e080e7          	jalr	94(ra) # 80003a88 <ilock>
    stati(f->ip, &st);
    80004a32:	fb840593          	addi	a1,s0,-72
    80004a36:	6c88                	ld	a0,24(s1)
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	2de080e7          	jalr	734(ra) # 80003d16 <stati>
    iunlock(f->ip);
    80004a40:	6c88                	ld	a0,24(s1)
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	10c080e7          	jalr	268(ra) # 80003b4e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004a4a:	46e1                	li	a3,24
    80004a4c:	fb840613          	addi	a2,s0,-72
    80004a50:	85ce                	mv	a1,s3
    80004a52:	05093503          	ld	a0,80(s2)
    80004a56:	ffffd097          	auipc	ra,0xffffd
    80004a5a:	c8c080e7          	jalr	-884(ra) # 800016e2 <copyout>
    80004a5e:	41f5551b          	sraiw	a0,a0,0x1f
    80004a62:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004a64:	60a6                	ld	ra,72(sp)
    80004a66:	6406                	ld	s0,64(sp)
    80004a68:	74e2                	ld	s1,56(sp)
    80004a6a:	79a2                	ld	s3,40(sp)
    80004a6c:	6161                	addi	sp,sp,80
    80004a6e:	8082                	ret
  return -1;
    80004a70:	557d                	li	a0,-1
    80004a72:	bfcd                	j	80004a64 <filestat+0x62>

0000000080004a74 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004a74:	7179                	addi	sp,sp,-48
    80004a76:	f406                	sd	ra,40(sp)
    80004a78:	f022                	sd	s0,32(sp)
    80004a7a:	e84a                	sd	s2,16(sp)
    80004a7c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a7e:	00854783          	lbu	a5,8(a0)
    80004a82:	cbc5                	beqz	a5,80004b32 <fileread+0xbe>
    80004a84:	ec26                	sd	s1,24(sp)
    80004a86:	e44e                	sd	s3,8(sp)
    80004a88:	84aa                	mv	s1,a0
    80004a8a:	89ae                	mv	s3,a1
    80004a8c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a8e:	411c                	lw	a5,0(a0)
    80004a90:	4705                	li	a4,1
    80004a92:	04e78963          	beq	a5,a4,80004ae4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a96:	470d                	li	a4,3
    80004a98:	04e78f63          	beq	a5,a4,80004af6 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a9c:	4709                	li	a4,2
    80004a9e:	08e79263          	bne	a5,a4,80004b22 <fileread+0xae>
    ilock(f->ip);
    80004aa2:	6d08                	ld	a0,24(a0)
    80004aa4:	fffff097          	auipc	ra,0xfffff
    80004aa8:	fe4080e7          	jalr	-28(ra) # 80003a88 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004aac:	874a                	mv	a4,s2
    80004aae:	5094                	lw	a3,32(s1)
    80004ab0:	864e                	mv	a2,s3
    80004ab2:	4585                	li	a1,1
    80004ab4:	6c88                	ld	a0,24(s1)
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	28a080e7          	jalr	650(ra) # 80003d40 <readi>
    80004abe:	892a                	mv	s2,a0
    80004ac0:	00a05563          	blez	a0,80004aca <fileread+0x56>
      f->off += r;
    80004ac4:	509c                	lw	a5,32(s1)
    80004ac6:	9fa9                	addw	a5,a5,a0
    80004ac8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004aca:	6c88                	ld	a0,24(s1)
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	082080e7          	jalr	130(ra) # 80003b4e <iunlock>
    80004ad4:	64e2                	ld	s1,24(sp)
    80004ad6:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004ad8:	854a                	mv	a0,s2
    80004ada:	70a2                	ld	ra,40(sp)
    80004adc:	7402                	ld	s0,32(sp)
    80004ade:	6942                	ld	s2,16(sp)
    80004ae0:	6145                	addi	sp,sp,48
    80004ae2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004ae4:	6908                	ld	a0,16(a0)
    80004ae6:	00000097          	auipc	ra,0x0
    80004aea:	400080e7          	jalr	1024(ra) # 80004ee6 <piperead>
    80004aee:	892a                	mv	s2,a0
    80004af0:	64e2                	ld	s1,24(sp)
    80004af2:	69a2                	ld	s3,8(sp)
    80004af4:	b7d5                	j	80004ad8 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004af6:	02451783          	lh	a5,36(a0)
    80004afa:	03079693          	slli	a3,a5,0x30
    80004afe:	92c1                	srli	a3,a3,0x30
    80004b00:	4725                	li	a4,9
    80004b02:	02d76a63          	bltu	a4,a3,80004b36 <fileread+0xc2>
    80004b06:	0792                	slli	a5,a5,0x4
    80004b08:	0001f717          	auipc	a4,0x1f
    80004b0c:	c4070713          	addi	a4,a4,-960 # 80023748 <devsw>
    80004b10:	97ba                	add	a5,a5,a4
    80004b12:	639c                	ld	a5,0(a5)
    80004b14:	c78d                	beqz	a5,80004b3e <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004b16:	4505                	li	a0,1
    80004b18:	9782                	jalr	a5
    80004b1a:	892a                	mv	s2,a0
    80004b1c:	64e2                	ld	s1,24(sp)
    80004b1e:	69a2                	ld	s3,8(sp)
    80004b20:	bf65                	j	80004ad8 <fileread+0x64>
    panic("fileread");
    80004b22:	00004517          	auipc	a0,0x4
    80004b26:	b5650513          	addi	a0,a0,-1194 # 80008678 <etext+0x678>
    80004b2a:	ffffc097          	auipc	ra,0xffffc
    80004b2e:	a36080e7          	jalr	-1482(ra) # 80000560 <panic>
    return -1;
    80004b32:	597d                	li	s2,-1
    80004b34:	b755                	j	80004ad8 <fileread+0x64>
      return -1;
    80004b36:	597d                	li	s2,-1
    80004b38:	64e2                	ld	s1,24(sp)
    80004b3a:	69a2                	ld	s3,8(sp)
    80004b3c:	bf71                	j	80004ad8 <fileread+0x64>
    80004b3e:	597d                	li	s2,-1
    80004b40:	64e2                	ld	s1,24(sp)
    80004b42:	69a2                	ld	s3,8(sp)
    80004b44:	bf51                	j	80004ad8 <fileread+0x64>

0000000080004b46 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004b46:	00954783          	lbu	a5,9(a0)
    80004b4a:	12078963          	beqz	a5,80004c7c <filewrite+0x136>
{
    80004b4e:	715d                	addi	sp,sp,-80
    80004b50:	e486                	sd	ra,72(sp)
    80004b52:	e0a2                	sd	s0,64(sp)
    80004b54:	f84a                	sd	s2,48(sp)
    80004b56:	f052                	sd	s4,32(sp)
    80004b58:	e85a                	sd	s6,16(sp)
    80004b5a:	0880                	addi	s0,sp,80
    80004b5c:	892a                	mv	s2,a0
    80004b5e:	8b2e                	mv	s6,a1
    80004b60:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b62:	411c                	lw	a5,0(a0)
    80004b64:	4705                	li	a4,1
    80004b66:	02e78763          	beq	a5,a4,80004b94 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b6a:	470d                	li	a4,3
    80004b6c:	02e78a63          	beq	a5,a4,80004ba0 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b70:	4709                	li	a4,2
    80004b72:	0ee79863          	bne	a5,a4,80004c62 <filewrite+0x11c>
    80004b76:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004b78:	0cc05463          	blez	a2,80004c40 <filewrite+0xfa>
    80004b7c:	fc26                	sd	s1,56(sp)
    80004b7e:	ec56                	sd	s5,24(sp)
    80004b80:	e45e                	sd	s7,8(sp)
    80004b82:	e062                	sd	s8,0(sp)
    int i = 0;
    80004b84:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004b86:	6b85                	lui	s7,0x1
    80004b88:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004b8c:	6c05                	lui	s8,0x1
    80004b8e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004b92:	a851                	j	80004c26 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004b94:	6908                	ld	a0,16(a0)
    80004b96:	00000097          	auipc	ra,0x0
    80004b9a:	248080e7          	jalr	584(ra) # 80004dde <pipewrite>
    80004b9e:	a85d                	j	80004c54 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004ba0:	02451783          	lh	a5,36(a0)
    80004ba4:	03079693          	slli	a3,a5,0x30
    80004ba8:	92c1                	srli	a3,a3,0x30
    80004baa:	4725                	li	a4,9
    80004bac:	0cd76a63          	bltu	a4,a3,80004c80 <filewrite+0x13a>
    80004bb0:	0792                	slli	a5,a5,0x4
    80004bb2:	0001f717          	auipc	a4,0x1f
    80004bb6:	b9670713          	addi	a4,a4,-1130 # 80023748 <devsw>
    80004bba:	97ba                	add	a5,a5,a4
    80004bbc:	679c                	ld	a5,8(a5)
    80004bbe:	c3f9                	beqz	a5,80004c84 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004bc0:	4505                	li	a0,1
    80004bc2:	9782                	jalr	a5
    80004bc4:	a841                	j	80004c54 <filewrite+0x10e>
      if(n1 > max)
    80004bc6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004bca:	00000097          	auipc	ra,0x0
    80004bce:	88c080e7          	jalr	-1908(ra) # 80004456 <begin_op>
      ilock(f->ip);
    80004bd2:	01893503          	ld	a0,24(s2)
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	eb2080e7          	jalr	-334(ra) # 80003a88 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004bde:	8756                	mv	a4,s5
    80004be0:	02092683          	lw	a3,32(s2)
    80004be4:	01698633          	add	a2,s3,s6
    80004be8:	4585                	li	a1,1
    80004bea:	01893503          	ld	a0,24(s2)
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	262080e7          	jalr	610(ra) # 80003e50 <writei>
    80004bf6:	84aa                	mv	s1,a0
    80004bf8:	00a05763          	blez	a0,80004c06 <filewrite+0xc0>
        f->off += r;
    80004bfc:	02092783          	lw	a5,32(s2)
    80004c00:	9fa9                	addw	a5,a5,a0
    80004c02:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c06:	01893503          	ld	a0,24(s2)
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	f44080e7          	jalr	-188(ra) # 80003b4e <iunlock>
      end_op();
    80004c12:	00000097          	auipc	ra,0x0
    80004c16:	8be080e7          	jalr	-1858(ra) # 800044d0 <end_op>

      if(r != n1){
    80004c1a:	029a9563          	bne	s5,s1,80004c44 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004c1e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004c22:	0149da63          	bge	s3,s4,80004c36 <filewrite+0xf0>
      int n1 = n - i;
    80004c26:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004c2a:	0004879b          	sext.w	a5,s1
    80004c2e:	f8fbdce3          	bge	s7,a5,80004bc6 <filewrite+0x80>
    80004c32:	84e2                	mv	s1,s8
    80004c34:	bf49                	j	80004bc6 <filewrite+0x80>
    80004c36:	74e2                	ld	s1,56(sp)
    80004c38:	6ae2                	ld	s5,24(sp)
    80004c3a:	6ba2                	ld	s7,8(sp)
    80004c3c:	6c02                	ld	s8,0(sp)
    80004c3e:	a039                	j	80004c4c <filewrite+0x106>
    int i = 0;
    80004c40:	4981                	li	s3,0
    80004c42:	a029                	j	80004c4c <filewrite+0x106>
    80004c44:	74e2                	ld	s1,56(sp)
    80004c46:	6ae2                	ld	s5,24(sp)
    80004c48:	6ba2                	ld	s7,8(sp)
    80004c4a:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004c4c:	033a1e63          	bne	s4,s3,80004c88 <filewrite+0x142>
    80004c50:	8552                	mv	a0,s4
    80004c52:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004c54:	60a6                	ld	ra,72(sp)
    80004c56:	6406                	ld	s0,64(sp)
    80004c58:	7942                	ld	s2,48(sp)
    80004c5a:	7a02                	ld	s4,32(sp)
    80004c5c:	6b42                	ld	s6,16(sp)
    80004c5e:	6161                	addi	sp,sp,80
    80004c60:	8082                	ret
    80004c62:	fc26                	sd	s1,56(sp)
    80004c64:	f44e                	sd	s3,40(sp)
    80004c66:	ec56                	sd	s5,24(sp)
    80004c68:	e45e                	sd	s7,8(sp)
    80004c6a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004c6c:	00004517          	auipc	a0,0x4
    80004c70:	a1c50513          	addi	a0,a0,-1508 # 80008688 <etext+0x688>
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	8ec080e7          	jalr	-1812(ra) # 80000560 <panic>
    return -1;
    80004c7c:	557d                	li	a0,-1
}
    80004c7e:	8082                	ret
      return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	bfc9                	j	80004c54 <filewrite+0x10e>
    80004c84:	557d                	li	a0,-1
    80004c86:	b7f9                	j	80004c54 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004c88:	557d                	li	a0,-1
    80004c8a:	79a2                	ld	s3,40(sp)
    80004c8c:	b7e1                	j	80004c54 <filewrite+0x10e>

0000000080004c8e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c8e:	7179                	addi	sp,sp,-48
    80004c90:	f406                	sd	ra,40(sp)
    80004c92:	f022                	sd	s0,32(sp)
    80004c94:	ec26                	sd	s1,24(sp)
    80004c96:	e052                	sd	s4,0(sp)
    80004c98:	1800                	addi	s0,sp,48
    80004c9a:	84aa                	mv	s1,a0
    80004c9c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c9e:	0005b023          	sd	zero,0(a1)
    80004ca2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ca6:	00000097          	auipc	ra,0x0
    80004caa:	bbe080e7          	jalr	-1090(ra) # 80004864 <filealloc>
    80004cae:	e088                	sd	a0,0(s1)
    80004cb0:	cd49                	beqz	a0,80004d4a <pipealloc+0xbc>
    80004cb2:	00000097          	auipc	ra,0x0
    80004cb6:	bb2080e7          	jalr	-1102(ra) # 80004864 <filealloc>
    80004cba:	00aa3023          	sd	a0,0(s4)
    80004cbe:	c141                	beqz	a0,80004d3e <pipealloc+0xb0>
    80004cc0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004cc2:	ffffc097          	auipc	ra,0xffffc
    80004cc6:	e86080e7          	jalr	-378(ra) # 80000b48 <kalloc>
    80004cca:	892a                	mv	s2,a0
    80004ccc:	c13d                	beqz	a0,80004d32 <pipealloc+0xa4>
    80004cce:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004cd0:	4985                	li	s3,1
    80004cd2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004cd6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004cda:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004cde:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ce2:	00004597          	auipc	a1,0x4
    80004ce6:	9b658593          	addi	a1,a1,-1610 # 80008698 <etext+0x698>
    80004cea:	ffffc097          	auipc	ra,0xffffc
    80004cee:	ebe080e7          	jalr	-322(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004cf2:	609c                	ld	a5,0(s1)
    80004cf4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004cf8:	609c                	ld	a5,0(s1)
    80004cfa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004cfe:	609c                	ld	a5,0(s1)
    80004d00:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d04:	609c                	ld	a5,0(s1)
    80004d06:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d0a:	000a3783          	ld	a5,0(s4)
    80004d0e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d12:	000a3783          	ld	a5,0(s4)
    80004d16:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d1a:	000a3783          	ld	a5,0(s4)
    80004d1e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004d22:	000a3783          	ld	a5,0(s4)
    80004d26:	0127b823          	sd	s2,16(a5)
  return 0;
    80004d2a:	4501                	li	a0,0
    80004d2c:	6942                	ld	s2,16(sp)
    80004d2e:	69a2                	ld	s3,8(sp)
    80004d30:	a03d                	j	80004d5e <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004d32:	6088                	ld	a0,0(s1)
    80004d34:	c119                	beqz	a0,80004d3a <pipealloc+0xac>
    80004d36:	6942                	ld	s2,16(sp)
    80004d38:	a029                	j	80004d42 <pipealloc+0xb4>
    80004d3a:	6942                	ld	s2,16(sp)
    80004d3c:	a039                	j	80004d4a <pipealloc+0xbc>
    80004d3e:	6088                	ld	a0,0(s1)
    80004d40:	c50d                	beqz	a0,80004d6a <pipealloc+0xdc>
    fileclose(*f0);
    80004d42:	00000097          	auipc	ra,0x0
    80004d46:	bde080e7          	jalr	-1058(ra) # 80004920 <fileclose>
  if(*f1)
    80004d4a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004d4e:	557d                	li	a0,-1
  if(*f1)
    80004d50:	c799                	beqz	a5,80004d5e <pipealloc+0xd0>
    fileclose(*f1);
    80004d52:	853e                	mv	a0,a5
    80004d54:	00000097          	auipc	ra,0x0
    80004d58:	bcc080e7          	jalr	-1076(ra) # 80004920 <fileclose>
  return -1;
    80004d5c:	557d                	li	a0,-1
}
    80004d5e:	70a2                	ld	ra,40(sp)
    80004d60:	7402                	ld	s0,32(sp)
    80004d62:	64e2                	ld	s1,24(sp)
    80004d64:	6a02                	ld	s4,0(sp)
    80004d66:	6145                	addi	sp,sp,48
    80004d68:	8082                	ret
  return -1;
    80004d6a:	557d                	li	a0,-1
    80004d6c:	bfcd                	j	80004d5e <pipealloc+0xd0>

0000000080004d6e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004d6e:	1101                	addi	sp,sp,-32
    80004d70:	ec06                	sd	ra,24(sp)
    80004d72:	e822                	sd	s0,16(sp)
    80004d74:	e426                	sd	s1,8(sp)
    80004d76:	e04a                	sd	s2,0(sp)
    80004d78:	1000                	addi	s0,sp,32
    80004d7a:	84aa                	mv	s1,a0
    80004d7c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004d7e:	ffffc097          	auipc	ra,0xffffc
    80004d82:	eba080e7          	jalr	-326(ra) # 80000c38 <acquire>
  if(writable){
    80004d86:	02090d63          	beqz	s2,80004dc0 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d8a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004d8e:	21848513          	addi	a0,s1,536
    80004d92:	ffffd097          	auipc	ra,0xffffd
    80004d96:	5c8080e7          	jalr	1480(ra) # 8000235a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d9a:	2204b783          	ld	a5,544(s1)
    80004d9e:	eb95                	bnez	a5,80004dd2 <pipeclose+0x64>
    release(&pi->lock);
    80004da0:	8526                	mv	a0,s1
    80004da2:	ffffc097          	auipc	ra,0xffffc
    80004da6:	f4a080e7          	jalr	-182(ra) # 80000cec <release>
    kfree((char*)pi);
    80004daa:	8526                	mv	a0,s1
    80004dac:	ffffc097          	auipc	ra,0xffffc
    80004db0:	c9e080e7          	jalr	-866(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80004db4:	60e2                	ld	ra,24(sp)
    80004db6:	6442                	ld	s0,16(sp)
    80004db8:	64a2                	ld	s1,8(sp)
    80004dba:	6902                	ld	s2,0(sp)
    80004dbc:	6105                	addi	sp,sp,32
    80004dbe:	8082                	ret
    pi->readopen = 0;
    80004dc0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004dc4:	21c48513          	addi	a0,s1,540
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	592080e7          	jalr	1426(ra) # 8000235a <wakeup>
    80004dd0:	b7e9                	j	80004d9a <pipeclose+0x2c>
    release(&pi->lock);
    80004dd2:	8526                	mv	a0,s1
    80004dd4:	ffffc097          	auipc	ra,0xffffc
    80004dd8:	f18080e7          	jalr	-232(ra) # 80000cec <release>
}
    80004ddc:	bfe1                	j	80004db4 <pipeclose+0x46>

0000000080004dde <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004dde:	711d                	addi	sp,sp,-96
    80004de0:	ec86                	sd	ra,88(sp)
    80004de2:	e8a2                	sd	s0,80(sp)
    80004de4:	e4a6                	sd	s1,72(sp)
    80004de6:	e0ca                	sd	s2,64(sp)
    80004de8:	fc4e                	sd	s3,56(sp)
    80004dea:	f852                	sd	s4,48(sp)
    80004dec:	f456                	sd	s5,40(sp)
    80004dee:	1080                	addi	s0,sp,96
    80004df0:	84aa                	mv	s1,a0
    80004df2:	8aae                	mv	s5,a1
    80004df4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	d28080e7          	jalr	-728(ra) # 80001b1e <myproc>
    80004dfe:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004e00:	8526                	mv	a0,s1
    80004e02:	ffffc097          	auipc	ra,0xffffc
    80004e06:	e36080e7          	jalr	-458(ra) # 80000c38 <acquire>
  while(i < n){
    80004e0a:	0d405863          	blez	s4,80004eda <pipewrite+0xfc>
    80004e0e:	f05a                	sd	s6,32(sp)
    80004e10:	ec5e                	sd	s7,24(sp)
    80004e12:	e862                	sd	s8,16(sp)
  int i = 0;
    80004e14:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e16:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e18:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e1c:	21c48b93          	addi	s7,s1,540
    80004e20:	a089                	j	80004e62 <pipewrite+0x84>
      release(&pi->lock);
    80004e22:	8526                	mv	a0,s1
    80004e24:	ffffc097          	auipc	ra,0xffffc
    80004e28:	ec8080e7          	jalr	-312(ra) # 80000cec <release>
      return -1;
    80004e2c:	597d                	li	s2,-1
    80004e2e:	7b02                	ld	s6,32(sp)
    80004e30:	6be2                	ld	s7,24(sp)
    80004e32:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004e34:	854a                	mv	a0,s2
    80004e36:	60e6                	ld	ra,88(sp)
    80004e38:	6446                	ld	s0,80(sp)
    80004e3a:	64a6                	ld	s1,72(sp)
    80004e3c:	6906                	ld	s2,64(sp)
    80004e3e:	79e2                	ld	s3,56(sp)
    80004e40:	7a42                	ld	s4,48(sp)
    80004e42:	7aa2                	ld	s5,40(sp)
    80004e44:	6125                	addi	sp,sp,96
    80004e46:	8082                	ret
      wakeup(&pi->nread);
    80004e48:	8562                	mv	a0,s8
    80004e4a:	ffffd097          	auipc	ra,0xffffd
    80004e4e:	510080e7          	jalr	1296(ra) # 8000235a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004e52:	85a6                	mv	a1,s1
    80004e54:	855e                	mv	a0,s7
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	4a0080e7          	jalr	1184(ra) # 800022f6 <sleep>
  while(i < n){
    80004e5e:	05495f63          	bge	s2,s4,80004ebc <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004e62:	2204a783          	lw	a5,544(s1)
    80004e66:	dfd5                	beqz	a5,80004e22 <pipewrite+0x44>
    80004e68:	854e                	mv	a0,s3
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	734080e7          	jalr	1844(ra) # 8000259e <killed>
    80004e72:	f945                	bnez	a0,80004e22 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004e74:	2184a783          	lw	a5,536(s1)
    80004e78:	21c4a703          	lw	a4,540(s1)
    80004e7c:	2007879b          	addiw	a5,a5,512
    80004e80:	fcf704e3          	beq	a4,a5,80004e48 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e84:	4685                	li	a3,1
    80004e86:	01590633          	add	a2,s2,s5
    80004e8a:	faf40593          	addi	a1,s0,-81
    80004e8e:	0509b503          	ld	a0,80(s3)
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	8dc080e7          	jalr	-1828(ra) # 8000176e <copyin>
    80004e9a:	05650263          	beq	a0,s6,80004ede <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e9e:	21c4a783          	lw	a5,540(s1)
    80004ea2:	0017871b          	addiw	a4,a5,1
    80004ea6:	20e4ae23          	sw	a4,540(s1)
    80004eaa:	1ff7f793          	andi	a5,a5,511
    80004eae:	97a6                	add	a5,a5,s1
    80004eb0:	faf44703          	lbu	a4,-81(s0)
    80004eb4:	00e78c23          	sb	a4,24(a5)
      i++;
    80004eb8:	2905                	addiw	s2,s2,1
    80004eba:	b755                	j	80004e5e <pipewrite+0x80>
    80004ebc:	7b02                	ld	s6,32(sp)
    80004ebe:	6be2                	ld	s7,24(sp)
    80004ec0:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004ec2:	21848513          	addi	a0,s1,536
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	494080e7          	jalr	1172(ra) # 8000235a <wakeup>
  release(&pi->lock);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	ffffc097          	auipc	ra,0xffffc
    80004ed4:	e1c080e7          	jalr	-484(ra) # 80000cec <release>
  return i;
    80004ed8:	bfb1                	j	80004e34 <pipewrite+0x56>
  int i = 0;
    80004eda:	4901                	li	s2,0
    80004edc:	b7dd                	j	80004ec2 <pipewrite+0xe4>
    80004ede:	7b02                	ld	s6,32(sp)
    80004ee0:	6be2                	ld	s7,24(sp)
    80004ee2:	6c42                	ld	s8,16(sp)
    80004ee4:	bff9                	j	80004ec2 <pipewrite+0xe4>

0000000080004ee6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ee6:	715d                	addi	sp,sp,-80
    80004ee8:	e486                	sd	ra,72(sp)
    80004eea:	e0a2                	sd	s0,64(sp)
    80004eec:	fc26                	sd	s1,56(sp)
    80004eee:	f84a                	sd	s2,48(sp)
    80004ef0:	f44e                	sd	s3,40(sp)
    80004ef2:	f052                	sd	s4,32(sp)
    80004ef4:	ec56                	sd	s5,24(sp)
    80004ef6:	0880                	addi	s0,sp,80
    80004ef8:	84aa                	mv	s1,a0
    80004efa:	892e                	mv	s2,a1
    80004efc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	c20080e7          	jalr	-992(ra) # 80001b1e <myproc>
    80004f06:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004f08:	8526                	mv	a0,s1
    80004f0a:	ffffc097          	auipc	ra,0xffffc
    80004f0e:	d2e080e7          	jalr	-722(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f12:	2184a703          	lw	a4,536(s1)
    80004f16:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f1a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f1e:	02f71963          	bne	a4,a5,80004f50 <piperead+0x6a>
    80004f22:	2244a783          	lw	a5,548(s1)
    80004f26:	cf95                	beqz	a5,80004f62 <piperead+0x7c>
    if(killed(pr)){
    80004f28:	8552                	mv	a0,s4
    80004f2a:	ffffd097          	auipc	ra,0xffffd
    80004f2e:	674080e7          	jalr	1652(ra) # 8000259e <killed>
    80004f32:	e10d                	bnez	a0,80004f54 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f34:	85a6                	mv	a1,s1
    80004f36:	854e                	mv	a0,s3
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	3be080e7          	jalr	958(ra) # 800022f6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f40:	2184a703          	lw	a4,536(s1)
    80004f44:	21c4a783          	lw	a5,540(s1)
    80004f48:	fcf70de3          	beq	a4,a5,80004f22 <piperead+0x3c>
    80004f4c:	e85a                	sd	s6,16(sp)
    80004f4e:	a819                	j	80004f64 <piperead+0x7e>
    80004f50:	e85a                	sd	s6,16(sp)
    80004f52:	a809                	j	80004f64 <piperead+0x7e>
      release(&pi->lock);
    80004f54:	8526                	mv	a0,s1
    80004f56:	ffffc097          	auipc	ra,0xffffc
    80004f5a:	d96080e7          	jalr	-618(ra) # 80000cec <release>
      return -1;
    80004f5e:	59fd                	li	s3,-1
    80004f60:	a0a5                	j	80004fc8 <piperead+0xe2>
    80004f62:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f64:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f66:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f68:	05505463          	blez	s5,80004fb0 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004f6c:	2184a783          	lw	a5,536(s1)
    80004f70:	21c4a703          	lw	a4,540(s1)
    80004f74:	02f70e63          	beq	a4,a5,80004fb0 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004f78:	0017871b          	addiw	a4,a5,1
    80004f7c:	20e4ac23          	sw	a4,536(s1)
    80004f80:	1ff7f793          	andi	a5,a5,511
    80004f84:	97a6                	add	a5,a5,s1
    80004f86:	0187c783          	lbu	a5,24(a5)
    80004f8a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f8e:	4685                	li	a3,1
    80004f90:	fbf40613          	addi	a2,s0,-65
    80004f94:	85ca                	mv	a1,s2
    80004f96:	050a3503          	ld	a0,80(s4)
    80004f9a:	ffffc097          	auipc	ra,0xffffc
    80004f9e:	748080e7          	jalr	1864(ra) # 800016e2 <copyout>
    80004fa2:	01650763          	beq	a0,s6,80004fb0 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fa6:	2985                	addiw	s3,s3,1
    80004fa8:	0905                	addi	s2,s2,1
    80004faa:	fd3a91e3          	bne	s5,s3,80004f6c <piperead+0x86>
    80004fae:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004fb0:	21c48513          	addi	a0,s1,540
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	3a6080e7          	jalr	934(ra) # 8000235a <wakeup>
  release(&pi->lock);
    80004fbc:	8526                	mv	a0,s1
    80004fbe:	ffffc097          	auipc	ra,0xffffc
    80004fc2:	d2e080e7          	jalr	-722(ra) # 80000cec <release>
    80004fc6:	6b42                	ld	s6,16(sp)
  return i;
}
    80004fc8:	854e                	mv	a0,s3
    80004fca:	60a6                	ld	ra,72(sp)
    80004fcc:	6406                	ld	s0,64(sp)
    80004fce:	74e2                	ld	s1,56(sp)
    80004fd0:	7942                	ld	s2,48(sp)
    80004fd2:	79a2                	ld	s3,40(sp)
    80004fd4:	7a02                	ld	s4,32(sp)
    80004fd6:	6ae2                	ld	s5,24(sp)
    80004fd8:	6161                	addi	sp,sp,80
    80004fda:	8082                	ret

0000000080004fdc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004fdc:	1141                	addi	sp,sp,-16
    80004fde:	e422                	sd	s0,8(sp)
    80004fe0:	0800                	addi	s0,sp,16
    80004fe2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004fe4:	8905                	andi	a0,a0,1
    80004fe6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004fe8:	8b89                	andi	a5,a5,2
    80004fea:	c399                	beqz	a5,80004ff0 <flags2perm+0x14>
      perm |= PTE_W;
    80004fec:	00456513          	ori	a0,a0,4
    return perm;
}
    80004ff0:	6422                	ld	s0,8(sp)
    80004ff2:	0141                	addi	sp,sp,16
    80004ff4:	8082                	ret

0000000080004ff6 <exec>:

int
exec(char *path, char **argv)
{
    80004ff6:	df010113          	addi	sp,sp,-528
    80004ffa:	20113423          	sd	ra,520(sp)
    80004ffe:	20813023          	sd	s0,512(sp)
    80005002:	ffa6                	sd	s1,504(sp)
    80005004:	fbca                	sd	s2,496(sp)
    80005006:	0c00                	addi	s0,sp,528
    80005008:	892a                	mv	s2,a0
    8000500a:	dea43c23          	sd	a0,-520(s0)
    8000500e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	b0c080e7          	jalr	-1268(ra) # 80001b1e <myproc>
    8000501a:	84aa                	mv	s1,a0

  begin_op();
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	43a080e7          	jalr	1082(ra) # 80004456 <begin_op>

  if((ip = namei(path)) == 0){
    80005024:	854a                	mv	a0,s2
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	230080e7          	jalr	560(ra) # 80004256 <namei>
    8000502e:	c135                	beqz	a0,80005092 <exec+0x9c>
    80005030:	f3d2                	sd	s4,480(sp)
    80005032:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	a54080e7          	jalr	-1452(ra) # 80003a88 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000503c:	04000713          	li	a4,64
    80005040:	4681                	li	a3,0
    80005042:	e5040613          	addi	a2,s0,-432
    80005046:	4581                	li	a1,0
    80005048:	8552                	mv	a0,s4
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	cf6080e7          	jalr	-778(ra) # 80003d40 <readi>
    80005052:	04000793          	li	a5,64
    80005056:	00f51a63          	bne	a0,a5,8000506a <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000505a:	e5042703          	lw	a4,-432(s0)
    8000505e:	464c47b7          	lui	a5,0x464c4
    80005062:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005066:	02f70c63          	beq	a4,a5,8000509e <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000506a:	8552                	mv	a0,s4
    8000506c:	fffff097          	auipc	ra,0xfffff
    80005070:	c82080e7          	jalr	-894(ra) # 80003cee <iunlockput>
    end_op();
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	45c080e7          	jalr	1116(ra) # 800044d0 <end_op>
  }
  return -1;
    8000507c:	557d                	li	a0,-1
    8000507e:	7a1e                	ld	s4,480(sp)
}
    80005080:	20813083          	ld	ra,520(sp)
    80005084:	20013403          	ld	s0,512(sp)
    80005088:	74fe                	ld	s1,504(sp)
    8000508a:	795e                	ld	s2,496(sp)
    8000508c:	21010113          	addi	sp,sp,528
    80005090:	8082                	ret
    end_op();
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	43e080e7          	jalr	1086(ra) # 800044d0 <end_op>
    return -1;
    8000509a:	557d                	li	a0,-1
    8000509c:	b7d5                	j	80005080 <exec+0x8a>
    8000509e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800050a0:	8526                	mv	a0,s1
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	b40080e7          	jalr	-1216(ra) # 80001be2 <proc_pagetable>
    800050aa:	8b2a                	mv	s6,a0
    800050ac:	30050f63          	beqz	a0,800053ca <exec+0x3d4>
    800050b0:	f7ce                	sd	s3,488(sp)
    800050b2:	efd6                	sd	s5,472(sp)
    800050b4:	e7de                	sd	s7,456(sp)
    800050b6:	e3e2                	sd	s8,448(sp)
    800050b8:	ff66                	sd	s9,440(sp)
    800050ba:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050bc:	e7042d03          	lw	s10,-400(s0)
    800050c0:	e8845783          	lhu	a5,-376(s0)
    800050c4:	14078d63          	beqz	a5,8000521e <exec+0x228>
    800050c8:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800050ca:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050cc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800050ce:	6c85                	lui	s9,0x1
    800050d0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800050d4:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800050d8:	6a85                	lui	s5,0x1
    800050da:	a0b5                	j	80005146 <exec+0x150>
      panic("loadseg: address should exist");
    800050dc:	00003517          	auipc	a0,0x3
    800050e0:	5c450513          	addi	a0,a0,1476 # 800086a0 <etext+0x6a0>
    800050e4:	ffffb097          	auipc	ra,0xffffb
    800050e8:	47c080e7          	jalr	1148(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800050ec:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800050ee:	8726                	mv	a4,s1
    800050f0:	012c06bb          	addw	a3,s8,s2
    800050f4:	4581                	li	a1,0
    800050f6:	8552                	mv	a0,s4
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	c48080e7          	jalr	-952(ra) # 80003d40 <readi>
    80005100:	2501                	sext.w	a0,a0
    80005102:	28a49863          	bne	s1,a0,80005392 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80005106:	012a893b          	addw	s2,s5,s2
    8000510a:	03397563          	bgeu	s2,s3,80005134 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000510e:	02091593          	slli	a1,s2,0x20
    80005112:	9181                	srli	a1,a1,0x20
    80005114:	95de                	add	a1,a1,s7
    80005116:	855a                	mv	a0,s6
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	f9e080e7          	jalr	-98(ra) # 800010b6 <walkaddr>
    80005120:	862a                	mv	a2,a0
    if(pa == 0)
    80005122:	dd4d                	beqz	a0,800050dc <exec+0xe6>
    if(sz - i < PGSIZE)
    80005124:	412984bb          	subw	s1,s3,s2
    80005128:	0004879b          	sext.w	a5,s1
    8000512c:	fcfcf0e3          	bgeu	s9,a5,800050ec <exec+0xf6>
    80005130:	84d6                	mv	s1,s5
    80005132:	bf6d                	j	800050ec <exec+0xf6>
    sz = sz1;
    80005134:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005138:	2d85                	addiw	s11,s11,1
    8000513a:	038d0d1b          	addiw	s10,s10,56
    8000513e:	e8845783          	lhu	a5,-376(s0)
    80005142:	08fdd663          	bge	s11,a5,800051ce <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005146:	2d01                	sext.w	s10,s10
    80005148:	03800713          	li	a4,56
    8000514c:	86ea                	mv	a3,s10
    8000514e:	e1840613          	addi	a2,s0,-488
    80005152:	4581                	li	a1,0
    80005154:	8552                	mv	a0,s4
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	bea080e7          	jalr	-1046(ra) # 80003d40 <readi>
    8000515e:	03800793          	li	a5,56
    80005162:	20f51063          	bne	a0,a5,80005362 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80005166:	e1842783          	lw	a5,-488(s0)
    8000516a:	4705                	li	a4,1
    8000516c:	fce796e3          	bne	a5,a4,80005138 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80005170:	e4043483          	ld	s1,-448(s0)
    80005174:	e3843783          	ld	a5,-456(s0)
    80005178:	1ef4e963          	bltu	s1,a5,8000536a <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000517c:	e2843783          	ld	a5,-472(s0)
    80005180:	94be                	add	s1,s1,a5
    80005182:	1ef4e863          	bltu	s1,a5,80005372 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005186:	df043703          	ld	a4,-528(s0)
    8000518a:	8ff9                	and	a5,a5,a4
    8000518c:	1e079763          	bnez	a5,8000537a <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005190:	e1c42503          	lw	a0,-484(s0)
    80005194:	00000097          	auipc	ra,0x0
    80005198:	e48080e7          	jalr	-440(ra) # 80004fdc <flags2perm>
    8000519c:	86aa                	mv	a3,a0
    8000519e:	8626                	mv	a2,s1
    800051a0:	85ca                	mv	a1,s2
    800051a2:	855a                	mv	a0,s6
    800051a4:	ffffc097          	auipc	ra,0xffffc
    800051a8:	2d6080e7          	jalr	726(ra) # 8000147a <uvmalloc>
    800051ac:	e0a43423          	sd	a0,-504(s0)
    800051b0:	1c050963          	beqz	a0,80005382 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800051b4:	e2843b83          	ld	s7,-472(s0)
    800051b8:	e2042c03          	lw	s8,-480(s0)
    800051bc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800051c0:	00098463          	beqz	s3,800051c8 <exec+0x1d2>
    800051c4:	4901                	li	s2,0
    800051c6:	b7a1                	j	8000510e <exec+0x118>
    sz = sz1;
    800051c8:	e0843903          	ld	s2,-504(s0)
    800051cc:	b7b5                	j	80005138 <exec+0x142>
    800051ce:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800051d0:	8552                	mv	a0,s4
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	b1c080e7          	jalr	-1252(ra) # 80003cee <iunlockput>
  end_op();
    800051da:	fffff097          	auipc	ra,0xfffff
    800051de:	2f6080e7          	jalr	758(ra) # 800044d0 <end_op>
  p = myproc();
    800051e2:	ffffd097          	auipc	ra,0xffffd
    800051e6:	93c080e7          	jalr	-1732(ra) # 80001b1e <myproc>
    800051ea:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800051ec:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800051f0:	6985                	lui	s3,0x1
    800051f2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800051f4:	99ca                	add	s3,s3,s2
    800051f6:	77fd                	lui	a5,0xfffff
    800051f8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800051fc:	4691                	li	a3,4
    800051fe:	6609                	lui	a2,0x2
    80005200:	964e                	add	a2,a2,s3
    80005202:	85ce                	mv	a1,s3
    80005204:	855a                	mv	a0,s6
    80005206:	ffffc097          	auipc	ra,0xffffc
    8000520a:	274080e7          	jalr	628(ra) # 8000147a <uvmalloc>
    8000520e:	892a                	mv	s2,a0
    80005210:	e0a43423          	sd	a0,-504(s0)
    80005214:	e519                	bnez	a0,80005222 <exec+0x22c>
  if(pagetable)
    80005216:	e1343423          	sd	s3,-504(s0)
    8000521a:	4a01                	li	s4,0
    8000521c:	aaa5                	j	80005394 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000521e:	4901                	li	s2,0
    80005220:	bf45                	j	800051d0 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005222:	75f9                	lui	a1,0xffffe
    80005224:	95aa                	add	a1,a1,a0
    80005226:	855a                	mv	a0,s6
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	488080e7          	jalr	1160(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    80005230:	7bfd                	lui	s7,0xfffff
    80005232:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80005234:	e0043783          	ld	a5,-512(s0)
    80005238:	6388                	ld	a0,0(a5)
    8000523a:	c52d                	beqz	a0,800052a4 <exec+0x2ae>
    8000523c:	e9040993          	addi	s3,s0,-368
    80005240:	f9040c13          	addi	s8,s0,-112
    80005244:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005246:	ffffc097          	auipc	ra,0xffffc
    8000524a:	c62080e7          	jalr	-926(ra) # 80000ea8 <strlen>
    8000524e:	0015079b          	addiw	a5,a0,1
    80005252:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005256:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000525a:	13796863          	bltu	s2,s7,8000538a <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000525e:	e0043d03          	ld	s10,-512(s0)
    80005262:	000d3a03          	ld	s4,0(s10)
    80005266:	8552                	mv	a0,s4
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	c40080e7          	jalr	-960(ra) # 80000ea8 <strlen>
    80005270:	0015069b          	addiw	a3,a0,1
    80005274:	8652                	mv	a2,s4
    80005276:	85ca                	mv	a1,s2
    80005278:	855a                	mv	a0,s6
    8000527a:	ffffc097          	auipc	ra,0xffffc
    8000527e:	468080e7          	jalr	1128(ra) # 800016e2 <copyout>
    80005282:	10054663          	bltz	a0,8000538e <exec+0x398>
    ustack[argc] = sp;
    80005286:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000528a:	0485                	addi	s1,s1,1
    8000528c:	008d0793          	addi	a5,s10,8
    80005290:	e0f43023          	sd	a5,-512(s0)
    80005294:	008d3503          	ld	a0,8(s10)
    80005298:	c909                	beqz	a0,800052aa <exec+0x2b4>
    if(argc >= MAXARG)
    8000529a:	09a1                	addi	s3,s3,8
    8000529c:	fb8995e3          	bne	s3,s8,80005246 <exec+0x250>
  ip = 0;
    800052a0:	4a01                	li	s4,0
    800052a2:	a8cd                	j	80005394 <exec+0x39e>
  sp = sz;
    800052a4:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800052a8:	4481                	li	s1,0
  ustack[argc] = 0;
    800052aa:	00349793          	slli	a5,s1,0x3
    800052ae:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda6b0>
    800052b2:	97a2                	add	a5,a5,s0
    800052b4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800052b8:	00148693          	addi	a3,s1,1
    800052bc:	068e                	slli	a3,a3,0x3
    800052be:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800052c2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800052c6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800052ca:	f57966e3          	bltu	s2,s7,80005216 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800052ce:	e9040613          	addi	a2,s0,-368
    800052d2:	85ca                	mv	a1,s2
    800052d4:	855a                	mv	a0,s6
    800052d6:	ffffc097          	auipc	ra,0xffffc
    800052da:	40c080e7          	jalr	1036(ra) # 800016e2 <copyout>
    800052de:	0e054863          	bltz	a0,800053ce <exec+0x3d8>
  p->trapframe->a1 = sp;
    800052e2:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800052e6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800052ea:	df843783          	ld	a5,-520(s0)
    800052ee:	0007c703          	lbu	a4,0(a5)
    800052f2:	cf11                	beqz	a4,8000530e <exec+0x318>
    800052f4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800052f6:	02f00693          	li	a3,47
    800052fa:	a039                	j	80005308 <exec+0x312>
      last = s+1;
    800052fc:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005300:	0785                	addi	a5,a5,1
    80005302:	fff7c703          	lbu	a4,-1(a5)
    80005306:	c701                	beqz	a4,8000530e <exec+0x318>
    if(*s == '/')
    80005308:	fed71ce3          	bne	a4,a3,80005300 <exec+0x30a>
    8000530c:	bfc5                	j	800052fc <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    8000530e:	4641                	li	a2,16
    80005310:	df843583          	ld	a1,-520(s0)
    80005314:	158a8513          	addi	a0,s5,344
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	b5e080e7          	jalr	-1186(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    80005320:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005324:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005328:	e0843783          	ld	a5,-504(s0)
    8000532c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005330:	058ab783          	ld	a5,88(s5)
    80005334:	e6843703          	ld	a4,-408(s0)
    80005338:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000533a:	058ab783          	ld	a5,88(s5)
    8000533e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005342:	85e6                	mv	a1,s9
    80005344:	ffffd097          	auipc	ra,0xffffd
    80005348:	93a080e7          	jalr	-1734(ra) # 80001c7e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000534c:	0004851b          	sext.w	a0,s1
    80005350:	79be                	ld	s3,488(sp)
    80005352:	7a1e                	ld	s4,480(sp)
    80005354:	6afe                	ld	s5,472(sp)
    80005356:	6b5e                	ld	s6,464(sp)
    80005358:	6bbe                	ld	s7,456(sp)
    8000535a:	6c1e                	ld	s8,448(sp)
    8000535c:	7cfa                	ld	s9,440(sp)
    8000535e:	7d5a                	ld	s10,432(sp)
    80005360:	b305                	j	80005080 <exec+0x8a>
    80005362:	e1243423          	sd	s2,-504(s0)
    80005366:	7dba                	ld	s11,424(sp)
    80005368:	a035                	j	80005394 <exec+0x39e>
    8000536a:	e1243423          	sd	s2,-504(s0)
    8000536e:	7dba                	ld	s11,424(sp)
    80005370:	a015                	j	80005394 <exec+0x39e>
    80005372:	e1243423          	sd	s2,-504(s0)
    80005376:	7dba                	ld	s11,424(sp)
    80005378:	a831                	j	80005394 <exec+0x39e>
    8000537a:	e1243423          	sd	s2,-504(s0)
    8000537e:	7dba                	ld	s11,424(sp)
    80005380:	a811                	j	80005394 <exec+0x39e>
    80005382:	e1243423          	sd	s2,-504(s0)
    80005386:	7dba                	ld	s11,424(sp)
    80005388:	a031                	j	80005394 <exec+0x39e>
  ip = 0;
    8000538a:	4a01                	li	s4,0
    8000538c:	a021                	j	80005394 <exec+0x39e>
    8000538e:	4a01                	li	s4,0
  if(pagetable)
    80005390:	a011                	j	80005394 <exec+0x39e>
    80005392:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005394:	e0843583          	ld	a1,-504(s0)
    80005398:	855a                	mv	a0,s6
    8000539a:	ffffd097          	auipc	ra,0xffffd
    8000539e:	8e4080e7          	jalr	-1820(ra) # 80001c7e <proc_freepagetable>
  return -1;
    800053a2:	557d                	li	a0,-1
  if(ip){
    800053a4:	000a1b63          	bnez	s4,800053ba <exec+0x3c4>
    800053a8:	79be                	ld	s3,488(sp)
    800053aa:	7a1e                	ld	s4,480(sp)
    800053ac:	6afe                	ld	s5,472(sp)
    800053ae:	6b5e                	ld	s6,464(sp)
    800053b0:	6bbe                	ld	s7,456(sp)
    800053b2:	6c1e                	ld	s8,448(sp)
    800053b4:	7cfa                	ld	s9,440(sp)
    800053b6:	7d5a                	ld	s10,432(sp)
    800053b8:	b1e1                	j	80005080 <exec+0x8a>
    800053ba:	79be                	ld	s3,488(sp)
    800053bc:	6afe                	ld	s5,472(sp)
    800053be:	6b5e                	ld	s6,464(sp)
    800053c0:	6bbe                	ld	s7,456(sp)
    800053c2:	6c1e                	ld	s8,448(sp)
    800053c4:	7cfa                	ld	s9,440(sp)
    800053c6:	7d5a                	ld	s10,432(sp)
    800053c8:	b14d                	j	8000506a <exec+0x74>
    800053ca:	6b5e                	ld	s6,464(sp)
    800053cc:	b979                	j	8000506a <exec+0x74>
  sz = sz1;
    800053ce:	e0843983          	ld	s3,-504(s0)
    800053d2:	b591                	j	80005216 <exec+0x220>

00000000800053d4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800053d4:	7179                	addi	sp,sp,-48
    800053d6:	f406                	sd	ra,40(sp)
    800053d8:	f022                	sd	s0,32(sp)
    800053da:	ec26                	sd	s1,24(sp)
    800053dc:	e84a                	sd	s2,16(sp)
    800053de:	1800                	addi	s0,sp,48
    800053e0:	892e                	mv	s2,a1
    800053e2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800053e4:	fdc40593          	addi	a1,s0,-36
    800053e8:	ffffe097          	auipc	ra,0xffffe
    800053ec:	a6a080e7          	jalr	-1430(ra) # 80002e52 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800053f0:	fdc42703          	lw	a4,-36(s0)
    800053f4:	47bd                	li	a5,15
    800053f6:	02e7eb63          	bltu	a5,a4,8000542c <argfd+0x58>
    800053fa:	ffffc097          	auipc	ra,0xffffc
    800053fe:	724080e7          	jalr	1828(ra) # 80001b1e <myproc>
    80005402:	fdc42703          	lw	a4,-36(s0)
    80005406:	01a70793          	addi	a5,a4,26
    8000540a:	078e                	slli	a5,a5,0x3
    8000540c:	953e                	add	a0,a0,a5
    8000540e:	611c                	ld	a5,0(a0)
    80005410:	c385                	beqz	a5,80005430 <argfd+0x5c>
    return -1;
  if(pfd)
    80005412:	00090463          	beqz	s2,8000541a <argfd+0x46>
    *pfd = fd;
    80005416:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000541a:	4501                	li	a0,0
  if(pf)
    8000541c:	c091                	beqz	s1,80005420 <argfd+0x4c>
    *pf = f;
    8000541e:	e09c                	sd	a5,0(s1)
}
    80005420:	70a2                	ld	ra,40(sp)
    80005422:	7402                	ld	s0,32(sp)
    80005424:	64e2                	ld	s1,24(sp)
    80005426:	6942                	ld	s2,16(sp)
    80005428:	6145                	addi	sp,sp,48
    8000542a:	8082                	ret
    return -1;
    8000542c:	557d                	li	a0,-1
    8000542e:	bfcd                	j	80005420 <argfd+0x4c>
    80005430:	557d                	li	a0,-1
    80005432:	b7fd                	j	80005420 <argfd+0x4c>

0000000080005434 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005434:	1101                	addi	sp,sp,-32
    80005436:	ec06                	sd	ra,24(sp)
    80005438:	e822                	sd	s0,16(sp)
    8000543a:	e426                	sd	s1,8(sp)
    8000543c:	1000                	addi	s0,sp,32
    8000543e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005440:	ffffc097          	auipc	ra,0xffffc
    80005444:	6de080e7          	jalr	1758(ra) # 80001b1e <myproc>
    80005448:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000544a:	0d050793          	addi	a5,a0,208
    8000544e:	4501                	li	a0,0
    80005450:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005452:	6398                	ld	a4,0(a5)
    80005454:	cb19                	beqz	a4,8000546a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005456:	2505                	addiw	a0,a0,1
    80005458:	07a1                	addi	a5,a5,8
    8000545a:	fed51ce3          	bne	a0,a3,80005452 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000545e:	557d                	li	a0,-1
}
    80005460:	60e2                	ld	ra,24(sp)
    80005462:	6442                	ld	s0,16(sp)
    80005464:	64a2                	ld	s1,8(sp)
    80005466:	6105                	addi	sp,sp,32
    80005468:	8082                	ret
      p->ofile[fd] = f;
    8000546a:	01a50793          	addi	a5,a0,26
    8000546e:	078e                	slli	a5,a5,0x3
    80005470:	963e                	add	a2,a2,a5
    80005472:	e204                	sd	s1,0(a2)
      return fd;
    80005474:	b7f5                	j	80005460 <fdalloc+0x2c>

0000000080005476 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005476:	715d                	addi	sp,sp,-80
    80005478:	e486                	sd	ra,72(sp)
    8000547a:	e0a2                	sd	s0,64(sp)
    8000547c:	fc26                	sd	s1,56(sp)
    8000547e:	f84a                	sd	s2,48(sp)
    80005480:	f44e                	sd	s3,40(sp)
    80005482:	ec56                	sd	s5,24(sp)
    80005484:	e85a                	sd	s6,16(sp)
    80005486:	0880                	addi	s0,sp,80
    80005488:	8b2e                	mv	s6,a1
    8000548a:	89b2                	mv	s3,a2
    8000548c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000548e:	fb040593          	addi	a1,s0,-80
    80005492:	fffff097          	auipc	ra,0xfffff
    80005496:	de2080e7          	jalr	-542(ra) # 80004274 <nameiparent>
    8000549a:	84aa                	mv	s1,a0
    8000549c:	14050e63          	beqz	a0,800055f8 <create+0x182>
    return 0;

  ilock(dp);
    800054a0:	ffffe097          	auipc	ra,0xffffe
    800054a4:	5e8080e7          	jalr	1512(ra) # 80003a88 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800054a8:	4601                	li	a2,0
    800054aa:	fb040593          	addi	a1,s0,-80
    800054ae:	8526                	mv	a0,s1
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	ae4080e7          	jalr	-1308(ra) # 80003f94 <dirlookup>
    800054b8:	8aaa                	mv	s5,a0
    800054ba:	c539                	beqz	a0,80005508 <create+0x92>
    iunlockput(dp);
    800054bc:	8526                	mv	a0,s1
    800054be:	fffff097          	auipc	ra,0xfffff
    800054c2:	830080e7          	jalr	-2000(ra) # 80003cee <iunlockput>
    ilock(ip);
    800054c6:	8556                	mv	a0,s5
    800054c8:	ffffe097          	auipc	ra,0xffffe
    800054cc:	5c0080e7          	jalr	1472(ra) # 80003a88 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800054d0:	4789                	li	a5,2
    800054d2:	02fb1463          	bne	s6,a5,800054fa <create+0x84>
    800054d6:	044ad783          	lhu	a5,68(s5)
    800054da:	37f9                	addiw	a5,a5,-2
    800054dc:	17c2                	slli	a5,a5,0x30
    800054de:	93c1                	srli	a5,a5,0x30
    800054e0:	4705                	li	a4,1
    800054e2:	00f76c63          	bltu	a4,a5,800054fa <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800054e6:	8556                	mv	a0,s5
    800054e8:	60a6                	ld	ra,72(sp)
    800054ea:	6406                	ld	s0,64(sp)
    800054ec:	74e2                	ld	s1,56(sp)
    800054ee:	7942                	ld	s2,48(sp)
    800054f0:	79a2                	ld	s3,40(sp)
    800054f2:	6ae2                	ld	s5,24(sp)
    800054f4:	6b42                	ld	s6,16(sp)
    800054f6:	6161                	addi	sp,sp,80
    800054f8:	8082                	ret
    iunlockput(ip);
    800054fa:	8556                	mv	a0,s5
    800054fc:	ffffe097          	auipc	ra,0xffffe
    80005500:	7f2080e7          	jalr	2034(ra) # 80003cee <iunlockput>
    return 0;
    80005504:	4a81                	li	s5,0
    80005506:	b7c5                	j	800054e6 <create+0x70>
    80005508:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000550a:	85da                	mv	a1,s6
    8000550c:	4088                	lw	a0,0(s1)
    8000550e:	ffffe097          	auipc	ra,0xffffe
    80005512:	3d6080e7          	jalr	982(ra) # 800038e4 <ialloc>
    80005516:	8a2a                	mv	s4,a0
    80005518:	c531                	beqz	a0,80005564 <create+0xee>
  ilock(ip);
    8000551a:	ffffe097          	auipc	ra,0xffffe
    8000551e:	56e080e7          	jalr	1390(ra) # 80003a88 <ilock>
  ip->major = major;
    80005522:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005526:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000552a:	4905                	li	s2,1
    8000552c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005530:	8552                	mv	a0,s4
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	48a080e7          	jalr	1162(ra) # 800039bc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000553a:	032b0d63          	beq	s6,s2,80005574 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000553e:	004a2603          	lw	a2,4(s4)
    80005542:	fb040593          	addi	a1,s0,-80
    80005546:	8526                	mv	a0,s1
    80005548:	fffff097          	auipc	ra,0xfffff
    8000554c:	c5c080e7          	jalr	-932(ra) # 800041a4 <dirlink>
    80005550:	08054163          	bltz	a0,800055d2 <create+0x15c>
  iunlockput(dp);
    80005554:	8526                	mv	a0,s1
    80005556:	ffffe097          	auipc	ra,0xffffe
    8000555a:	798080e7          	jalr	1944(ra) # 80003cee <iunlockput>
  return ip;
    8000555e:	8ad2                	mv	s5,s4
    80005560:	7a02                	ld	s4,32(sp)
    80005562:	b751                	j	800054e6 <create+0x70>
    iunlockput(dp);
    80005564:	8526                	mv	a0,s1
    80005566:	ffffe097          	auipc	ra,0xffffe
    8000556a:	788080e7          	jalr	1928(ra) # 80003cee <iunlockput>
    return 0;
    8000556e:	8ad2                	mv	s5,s4
    80005570:	7a02                	ld	s4,32(sp)
    80005572:	bf95                	j	800054e6 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005574:	004a2603          	lw	a2,4(s4)
    80005578:	00003597          	auipc	a1,0x3
    8000557c:	14858593          	addi	a1,a1,328 # 800086c0 <etext+0x6c0>
    80005580:	8552                	mv	a0,s4
    80005582:	fffff097          	auipc	ra,0xfffff
    80005586:	c22080e7          	jalr	-990(ra) # 800041a4 <dirlink>
    8000558a:	04054463          	bltz	a0,800055d2 <create+0x15c>
    8000558e:	40d0                	lw	a2,4(s1)
    80005590:	00003597          	auipc	a1,0x3
    80005594:	13858593          	addi	a1,a1,312 # 800086c8 <etext+0x6c8>
    80005598:	8552                	mv	a0,s4
    8000559a:	fffff097          	auipc	ra,0xfffff
    8000559e:	c0a080e7          	jalr	-1014(ra) # 800041a4 <dirlink>
    800055a2:	02054863          	bltz	a0,800055d2 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800055a6:	004a2603          	lw	a2,4(s4)
    800055aa:	fb040593          	addi	a1,s0,-80
    800055ae:	8526                	mv	a0,s1
    800055b0:	fffff097          	auipc	ra,0xfffff
    800055b4:	bf4080e7          	jalr	-1036(ra) # 800041a4 <dirlink>
    800055b8:	00054d63          	bltz	a0,800055d2 <create+0x15c>
    dp->nlink++;  // for ".."
    800055bc:	04a4d783          	lhu	a5,74(s1)
    800055c0:	2785                	addiw	a5,a5,1
    800055c2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800055c6:	8526                	mv	a0,s1
    800055c8:	ffffe097          	auipc	ra,0xffffe
    800055cc:	3f4080e7          	jalr	1012(ra) # 800039bc <iupdate>
    800055d0:	b751                	j	80005554 <create+0xde>
  ip->nlink = 0;
    800055d2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800055d6:	8552                	mv	a0,s4
    800055d8:	ffffe097          	auipc	ra,0xffffe
    800055dc:	3e4080e7          	jalr	996(ra) # 800039bc <iupdate>
  iunlockput(ip);
    800055e0:	8552                	mv	a0,s4
    800055e2:	ffffe097          	auipc	ra,0xffffe
    800055e6:	70c080e7          	jalr	1804(ra) # 80003cee <iunlockput>
  iunlockput(dp);
    800055ea:	8526                	mv	a0,s1
    800055ec:	ffffe097          	auipc	ra,0xffffe
    800055f0:	702080e7          	jalr	1794(ra) # 80003cee <iunlockput>
  return 0;
    800055f4:	7a02                	ld	s4,32(sp)
    800055f6:	bdc5                	j	800054e6 <create+0x70>
    return 0;
    800055f8:	8aaa                	mv	s5,a0
    800055fa:	b5f5                	j	800054e6 <create+0x70>

00000000800055fc <sys_dup>:
{
    800055fc:	7179                	addi	sp,sp,-48
    800055fe:	f406                	sd	ra,40(sp)
    80005600:	f022                	sd	s0,32(sp)
    80005602:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005604:	fd840613          	addi	a2,s0,-40
    80005608:	4581                	li	a1,0
    8000560a:	4501                	li	a0,0
    8000560c:	00000097          	auipc	ra,0x0
    80005610:	dc8080e7          	jalr	-568(ra) # 800053d4 <argfd>
    return -1;
    80005614:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005616:	02054763          	bltz	a0,80005644 <sys_dup+0x48>
    8000561a:	ec26                	sd	s1,24(sp)
    8000561c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000561e:	fd843903          	ld	s2,-40(s0)
    80005622:	854a                	mv	a0,s2
    80005624:	00000097          	auipc	ra,0x0
    80005628:	e10080e7          	jalr	-496(ra) # 80005434 <fdalloc>
    8000562c:	84aa                	mv	s1,a0
    return -1;
    8000562e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005630:	00054f63          	bltz	a0,8000564e <sys_dup+0x52>
  filedup(f);
    80005634:	854a                	mv	a0,s2
    80005636:	fffff097          	auipc	ra,0xfffff
    8000563a:	298080e7          	jalr	664(ra) # 800048ce <filedup>
  return fd;
    8000563e:	87a6                	mv	a5,s1
    80005640:	64e2                	ld	s1,24(sp)
    80005642:	6942                	ld	s2,16(sp)
}
    80005644:	853e                	mv	a0,a5
    80005646:	70a2                	ld	ra,40(sp)
    80005648:	7402                	ld	s0,32(sp)
    8000564a:	6145                	addi	sp,sp,48
    8000564c:	8082                	ret
    8000564e:	64e2                	ld	s1,24(sp)
    80005650:	6942                	ld	s2,16(sp)
    80005652:	bfcd                	j	80005644 <sys_dup+0x48>

0000000080005654 <sys_read>:
{
    80005654:	7179                	addi	sp,sp,-48
    80005656:	f406                	sd	ra,40(sp)
    80005658:	f022                	sd	s0,32(sp)
    8000565a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000565c:	fd840593          	addi	a1,s0,-40
    80005660:	4505                	li	a0,1
    80005662:	ffffe097          	auipc	ra,0xffffe
    80005666:	810080e7          	jalr	-2032(ra) # 80002e72 <argaddr>
  argint(2, &n);
    8000566a:	fe440593          	addi	a1,s0,-28
    8000566e:	4509                	li	a0,2
    80005670:	ffffd097          	auipc	ra,0xffffd
    80005674:	7e2080e7          	jalr	2018(ra) # 80002e52 <argint>
  if(argfd(0, 0, &f) < 0)
    80005678:	fe840613          	addi	a2,s0,-24
    8000567c:	4581                	li	a1,0
    8000567e:	4501                	li	a0,0
    80005680:	00000097          	auipc	ra,0x0
    80005684:	d54080e7          	jalr	-684(ra) # 800053d4 <argfd>
    80005688:	87aa                	mv	a5,a0
    return -1;
    8000568a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000568c:	0007cc63          	bltz	a5,800056a4 <sys_read+0x50>
  return fileread(f, p, n);
    80005690:	fe442603          	lw	a2,-28(s0)
    80005694:	fd843583          	ld	a1,-40(s0)
    80005698:	fe843503          	ld	a0,-24(s0)
    8000569c:	fffff097          	auipc	ra,0xfffff
    800056a0:	3d8080e7          	jalr	984(ra) # 80004a74 <fileread>
}
    800056a4:	70a2                	ld	ra,40(sp)
    800056a6:	7402                	ld	s0,32(sp)
    800056a8:	6145                	addi	sp,sp,48
    800056aa:	8082                	ret

00000000800056ac <sys_write>:
{
    800056ac:	7179                	addi	sp,sp,-48
    800056ae:	f406                	sd	ra,40(sp)
    800056b0:	f022                	sd	s0,32(sp)
    800056b2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800056b4:	fd840593          	addi	a1,s0,-40
    800056b8:	4505                	li	a0,1
    800056ba:	ffffd097          	auipc	ra,0xffffd
    800056be:	7b8080e7          	jalr	1976(ra) # 80002e72 <argaddr>
  argint(2, &n);
    800056c2:	fe440593          	addi	a1,s0,-28
    800056c6:	4509                	li	a0,2
    800056c8:	ffffd097          	auipc	ra,0xffffd
    800056cc:	78a080e7          	jalr	1930(ra) # 80002e52 <argint>
  if(argfd(0, 0, &f) < 0)
    800056d0:	fe840613          	addi	a2,s0,-24
    800056d4:	4581                	li	a1,0
    800056d6:	4501                	li	a0,0
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	cfc080e7          	jalr	-772(ra) # 800053d4 <argfd>
    800056e0:	87aa                	mv	a5,a0
    return -1;
    800056e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056e4:	0007cc63          	bltz	a5,800056fc <sys_write+0x50>
  return filewrite(f, p, n);
    800056e8:	fe442603          	lw	a2,-28(s0)
    800056ec:	fd843583          	ld	a1,-40(s0)
    800056f0:	fe843503          	ld	a0,-24(s0)
    800056f4:	fffff097          	auipc	ra,0xfffff
    800056f8:	452080e7          	jalr	1106(ra) # 80004b46 <filewrite>
}
    800056fc:	70a2                	ld	ra,40(sp)
    800056fe:	7402                	ld	s0,32(sp)
    80005700:	6145                	addi	sp,sp,48
    80005702:	8082                	ret

0000000080005704 <sys_close>:
{
    80005704:	1101                	addi	sp,sp,-32
    80005706:	ec06                	sd	ra,24(sp)
    80005708:	e822                	sd	s0,16(sp)
    8000570a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000570c:	fe040613          	addi	a2,s0,-32
    80005710:	fec40593          	addi	a1,s0,-20
    80005714:	4501                	li	a0,0
    80005716:	00000097          	auipc	ra,0x0
    8000571a:	cbe080e7          	jalr	-834(ra) # 800053d4 <argfd>
    return -1;
    8000571e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005720:	02054463          	bltz	a0,80005748 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005724:	ffffc097          	auipc	ra,0xffffc
    80005728:	3fa080e7          	jalr	1018(ra) # 80001b1e <myproc>
    8000572c:	fec42783          	lw	a5,-20(s0)
    80005730:	07e9                	addi	a5,a5,26
    80005732:	078e                	slli	a5,a5,0x3
    80005734:	953e                	add	a0,a0,a5
    80005736:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000573a:	fe043503          	ld	a0,-32(s0)
    8000573e:	fffff097          	auipc	ra,0xfffff
    80005742:	1e2080e7          	jalr	482(ra) # 80004920 <fileclose>
  return 0;
    80005746:	4781                	li	a5,0
}
    80005748:	853e                	mv	a0,a5
    8000574a:	60e2                	ld	ra,24(sp)
    8000574c:	6442                	ld	s0,16(sp)
    8000574e:	6105                	addi	sp,sp,32
    80005750:	8082                	ret

0000000080005752 <sys_fstat>:
{
    80005752:	1101                	addi	sp,sp,-32
    80005754:	ec06                	sd	ra,24(sp)
    80005756:	e822                	sd	s0,16(sp)
    80005758:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000575a:	fe040593          	addi	a1,s0,-32
    8000575e:	4505                	li	a0,1
    80005760:	ffffd097          	auipc	ra,0xffffd
    80005764:	712080e7          	jalr	1810(ra) # 80002e72 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005768:	fe840613          	addi	a2,s0,-24
    8000576c:	4581                	li	a1,0
    8000576e:	4501                	li	a0,0
    80005770:	00000097          	auipc	ra,0x0
    80005774:	c64080e7          	jalr	-924(ra) # 800053d4 <argfd>
    80005778:	87aa                	mv	a5,a0
    return -1;
    8000577a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000577c:	0007ca63          	bltz	a5,80005790 <sys_fstat+0x3e>
  return filestat(f, st);
    80005780:	fe043583          	ld	a1,-32(s0)
    80005784:	fe843503          	ld	a0,-24(s0)
    80005788:	fffff097          	auipc	ra,0xfffff
    8000578c:	27a080e7          	jalr	634(ra) # 80004a02 <filestat>
}
    80005790:	60e2                	ld	ra,24(sp)
    80005792:	6442                	ld	s0,16(sp)
    80005794:	6105                	addi	sp,sp,32
    80005796:	8082                	ret

0000000080005798 <sys_link>:
{
    80005798:	7169                	addi	sp,sp,-304
    8000579a:	f606                	sd	ra,296(sp)
    8000579c:	f222                	sd	s0,288(sp)
    8000579e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057a0:	08000613          	li	a2,128
    800057a4:	ed040593          	addi	a1,s0,-304
    800057a8:	4501                	li	a0,0
    800057aa:	ffffd097          	auipc	ra,0xffffd
    800057ae:	6e8080e7          	jalr	1768(ra) # 80002e92 <argstr>
    return -1;
    800057b2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057b4:	12054663          	bltz	a0,800058e0 <sys_link+0x148>
    800057b8:	08000613          	li	a2,128
    800057bc:	f5040593          	addi	a1,s0,-176
    800057c0:	4505                	li	a0,1
    800057c2:	ffffd097          	auipc	ra,0xffffd
    800057c6:	6d0080e7          	jalr	1744(ra) # 80002e92 <argstr>
    return -1;
    800057ca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057cc:	10054a63          	bltz	a0,800058e0 <sys_link+0x148>
    800057d0:	ee26                	sd	s1,280(sp)
  begin_op();
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	c84080e7          	jalr	-892(ra) # 80004456 <begin_op>
  if((ip = namei(old)) == 0){
    800057da:	ed040513          	addi	a0,s0,-304
    800057de:	fffff097          	auipc	ra,0xfffff
    800057e2:	a78080e7          	jalr	-1416(ra) # 80004256 <namei>
    800057e6:	84aa                	mv	s1,a0
    800057e8:	c949                	beqz	a0,8000587a <sys_link+0xe2>
  ilock(ip);
    800057ea:	ffffe097          	auipc	ra,0xffffe
    800057ee:	29e080e7          	jalr	670(ra) # 80003a88 <ilock>
  if(ip->type == T_DIR){
    800057f2:	04449703          	lh	a4,68(s1)
    800057f6:	4785                	li	a5,1
    800057f8:	08f70863          	beq	a4,a5,80005888 <sys_link+0xf0>
    800057fc:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800057fe:	04a4d783          	lhu	a5,74(s1)
    80005802:	2785                	addiw	a5,a5,1
    80005804:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005808:	8526                	mv	a0,s1
    8000580a:	ffffe097          	auipc	ra,0xffffe
    8000580e:	1b2080e7          	jalr	434(ra) # 800039bc <iupdate>
  iunlock(ip);
    80005812:	8526                	mv	a0,s1
    80005814:	ffffe097          	auipc	ra,0xffffe
    80005818:	33a080e7          	jalr	826(ra) # 80003b4e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000581c:	fd040593          	addi	a1,s0,-48
    80005820:	f5040513          	addi	a0,s0,-176
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	a50080e7          	jalr	-1456(ra) # 80004274 <nameiparent>
    8000582c:	892a                	mv	s2,a0
    8000582e:	cd35                	beqz	a0,800058aa <sys_link+0x112>
  ilock(dp);
    80005830:	ffffe097          	auipc	ra,0xffffe
    80005834:	258080e7          	jalr	600(ra) # 80003a88 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005838:	00092703          	lw	a4,0(s2)
    8000583c:	409c                	lw	a5,0(s1)
    8000583e:	06f71163          	bne	a4,a5,800058a0 <sys_link+0x108>
    80005842:	40d0                	lw	a2,4(s1)
    80005844:	fd040593          	addi	a1,s0,-48
    80005848:	854a                	mv	a0,s2
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	95a080e7          	jalr	-1702(ra) # 800041a4 <dirlink>
    80005852:	04054763          	bltz	a0,800058a0 <sys_link+0x108>
  iunlockput(dp);
    80005856:	854a                	mv	a0,s2
    80005858:	ffffe097          	auipc	ra,0xffffe
    8000585c:	496080e7          	jalr	1174(ra) # 80003cee <iunlockput>
  iput(ip);
    80005860:	8526                	mv	a0,s1
    80005862:	ffffe097          	auipc	ra,0xffffe
    80005866:	3e4080e7          	jalr	996(ra) # 80003c46 <iput>
  end_op();
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	c66080e7          	jalr	-922(ra) # 800044d0 <end_op>
  return 0;
    80005872:	4781                	li	a5,0
    80005874:	64f2                	ld	s1,280(sp)
    80005876:	6952                	ld	s2,272(sp)
    80005878:	a0a5                	j	800058e0 <sys_link+0x148>
    end_op();
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	c56080e7          	jalr	-938(ra) # 800044d0 <end_op>
    return -1;
    80005882:	57fd                	li	a5,-1
    80005884:	64f2                	ld	s1,280(sp)
    80005886:	a8a9                	j	800058e0 <sys_link+0x148>
    iunlockput(ip);
    80005888:	8526                	mv	a0,s1
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	464080e7          	jalr	1124(ra) # 80003cee <iunlockput>
    end_op();
    80005892:	fffff097          	auipc	ra,0xfffff
    80005896:	c3e080e7          	jalr	-962(ra) # 800044d0 <end_op>
    return -1;
    8000589a:	57fd                	li	a5,-1
    8000589c:	64f2                	ld	s1,280(sp)
    8000589e:	a089                	j	800058e0 <sys_link+0x148>
    iunlockput(dp);
    800058a0:	854a                	mv	a0,s2
    800058a2:	ffffe097          	auipc	ra,0xffffe
    800058a6:	44c080e7          	jalr	1100(ra) # 80003cee <iunlockput>
  ilock(ip);
    800058aa:	8526                	mv	a0,s1
    800058ac:	ffffe097          	auipc	ra,0xffffe
    800058b0:	1dc080e7          	jalr	476(ra) # 80003a88 <ilock>
  ip->nlink--;
    800058b4:	04a4d783          	lhu	a5,74(s1)
    800058b8:	37fd                	addiw	a5,a5,-1
    800058ba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058be:	8526                	mv	a0,s1
    800058c0:	ffffe097          	auipc	ra,0xffffe
    800058c4:	0fc080e7          	jalr	252(ra) # 800039bc <iupdate>
  iunlockput(ip);
    800058c8:	8526                	mv	a0,s1
    800058ca:	ffffe097          	auipc	ra,0xffffe
    800058ce:	424080e7          	jalr	1060(ra) # 80003cee <iunlockput>
  end_op();
    800058d2:	fffff097          	auipc	ra,0xfffff
    800058d6:	bfe080e7          	jalr	-1026(ra) # 800044d0 <end_op>
  return -1;
    800058da:	57fd                	li	a5,-1
    800058dc:	64f2                	ld	s1,280(sp)
    800058de:	6952                	ld	s2,272(sp)
}
    800058e0:	853e                	mv	a0,a5
    800058e2:	70b2                	ld	ra,296(sp)
    800058e4:	7412                	ld	s0,288(sp)
    800058e6:	6155                	addi	sp,sp,304
    800058e8:	8082                	ret

00000000800058ea <sys_unlink>:
{
    800058ea:	7151                	addi	sp,sp,-240
    800058ec:	f586                	sd	ra,232(sp)
    800058ee:	f1a2                	sd	s0,224(sp)
    800058f0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800058f2:	08000613          	li	a2,128
    800058f6:	f3040593          	addi	a1,s0,-208
    800058fa:	4501                	li	a0,0
    800058fc:	ffffd097          	auipc	ra,0xffffd
    80005900:	596080e7          	jalr	1430(ra) # 80002e92 <argstr>
    80005904:	1a054a63          	bltz	a0,80005ab8 <sys_unlink+0x1ce>
    80005908:	eda6                	sd	s1,216(sp)
  begin_op();
    8000590a:	fffff097          	auipc	ra,0xfffff
    8000590e:	b4c080e7          	jalr	-1204(ra) # 80004456 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005912:	fb040593          	addi	a1,s0,-80
    80005916:	f3040513          	addi	a0,s0,-208
    8000591a:	fffff097          	auipc	ra,0xfffff
    8000591e:	95a080e7          	jalr	-1702(ra) # 80004274 <nameiparent>
    80005922:	84aa                	mv	s1,a0
    80005924:	cd71                	beqz	a0,80005a00 <sys_unlink+0x116>
  ilock(dp);
    80005926:	ffffe097          	auipc	ra,0xffffe
    8000592a:	162080e7          	jalr	354(ra) # 80003a88 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000592e:	00003597          	auipc	a1,0x3
    80005932:	d9258593          	addi	a1,a1,-622 # 800086c0 <etext+0x6c0>
    80005936:	fb040513          	addi	a0,s0,-80
    8000593a:	ffffe097          	auipc	ra,0xffffe
    8000593e:	640080e7          	jalr	1600(ra) # 80003f7a <namecmp>
    80005942:	14050c63          	beqz	a0,80005a9a <sys_unlink+0x1b0>
    80005946:	00003597          	auipc	a1,0x3
    8000594a:	d8258593          	addi	a1,a1,-638 # 800086c8 <etext+0x6c8>
    8000594e:	fb040513          	addi	a0,s0,-80
    80005952:	ffffe097          	auipc	ra,0xffffe
    80005956:	628080e7          	jalr	1576(ra) # 80003f7a <namecmp>
    8000595a:	14050063          	beqz	a0,80005a9a <sys_unlink+0x1b0>
    8000595e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005960:	f2c40613          	addi	a2,s0,-212
    80005964:	fb040593          	addi	a1,s0,-80
    80005968:	8526                	mv	a0,s1
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	62a080e7          	jalr	1578(ra) # 80003f94 <dirlookup>
    80005972:	892a                	mv	s2,a0
    80005974:	12050263          	beqz	a0,80005a98 <sys_unlink+0x1ae>
  ilock(ip);
    80005978:	ffffe097          	auipc	ra,0xffffe
    8000597c:	110080e7          	jalr	272(ra) # 80003a88 <ilock>
  if(ip->nlink < 1)
    80005980:	04a91783          	lh	a5,74(s2)
    80005984:	08f05563          	blez	a5,80005a0e <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005988:	04491703          	lh	a4,68(s2)
    8000598c:	4785                	li	a5,1
    8000598e:	08f70963          	beq	a4,a5,80005a20 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005992:	4641                	li	a2,16
    80005994:	4581                	li	a1,0
    80005996:	fc040513          	addi	a0,s0,-64
    8000599a:	ffffb097          	auipc	ra,0xffffb
    8000599e:	39a080e7          	jalr	922(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800059a2:	4741                	li	a4,16
    800059a4:	f2c42683          	lw	a3,-212(s0)
    800059a8:	fc040613          	addi	a2,s0,-64
    800059ac:	4581                	li	a1,0
    800059ae:	8526                	mv	a0,s1
    800059b0:	ffffe097          	auipc	ra,0xffffe
    800059b4:	4a0080e7          	jalr	1184(ra) # 80003e50 <writei>
    800059b8:	47c1                	li	a5,16
    800059ba:	0af51b63          	bne	a0,a5,80005a70 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    800059be:	04491703          	lh	a4,68(s2)
    800059c2:	4785                	li	a5,1
    800059c4:	0af70f63          	beq	a4,a5,80005a82 <sys_unlink+0x198>
  iunlockput(dp);
    800059c8:	8526                	mv	a0,s1
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	324080e7          	jalr	804(ra) # 80003cee <iunlockput>
  ip->nlink--;
    800059d2:	04a95783          	lhu	a5,74(s2)
    800059d6:	37fd                	addiw	a5,a5,-1
    800059d8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800059dc:	854a                	mv	a0,s2
    800059de:	ffffe097          	auipc	ra,0xffffe
    800059e2:	fde080e7          	jalr	-34(ra) # 800039bc <iupdate>
  iunlockput(ip);
    800059e6:	854a                	mv	a0,s2
    800059e8:	ffffe097          	auipc	ra,0xffffe
    800059ec:	306080e7          	jalr	774(ra) # 80003cee <iunlockput>
  end_op();
    800059f0:	fffff097          	auipc	ra,0xfffff
    800059f4:	ae0080e7          	jalr	-1312(ra) # 800044d0 <end_op>
  return 0;
    800059f8:	4501                	li	a0,0
    800059fa:	64ee                	ld	s1,216(sp)
    800059fc:	694e                	ld	s2,208(sp)
    800059fe:	a84d                	j	80005ab0 <sys_unlink+0x1c6>
    end_op();
    80005a00:	fffff097          	auipc	ra,0xfffff
    80005a04:	ad0080e7          	jalr	-1328(ra) # 800044d0 <end_op>
    return -1;
    80005a08:	557d                	li	a0,-1
    80005a0a:	64ee                	ld	s1,216(sp)
    80005a0c:	a055                	j	80005ab0 <sys_unlink+0x1c6>
    80005a0e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005a10:	00003517          	auipc	a0,0x3
    80005a14:	cc050513          	addi	a0,a0,-832 # 800086d0 <etext+0x6d0>
    80005a18:	ffffb097          	auipc	ra,0xffffb
    80005a1c:	b48080e7          	jalr	-1208(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a20:	04c92703          	lw	a4,76(s2)
    80005a24:	02000793          	li	a5,32
    80005a28:	f6e7f5e3          	bgeu	a5,a4,80005992 <sys_unlink+0xa8>
    80005a2c:	e5ce                	sd	s3,200(sp)
    80005a2e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a32:	4741                	li	a4,16
    80005a34:	86ce                	mv	a3,s3
    80005a36:	f1840613          	addi	a2,s0,-232
    80005a3a:	4581                	li	a1,0
    80005a3c:	854a                	mv	a0,s2
    80005a3e:	ffffe097          	auipc	ra,0xffffe
    80005a42:	302080e7          	jalr	770(ra) # 80003d40 <readi>
    80005a46:	47c1                	li	a5,16
    80005a48:	00f51c63          	bne	a0,a5,80005a60 <sys_unlink+0x176>
    if(de.inum != 0)
    80005a4c:	f1845783          	lhu	a5,-232(s0)
    80005a50:	e7b5                	bnez	a5,80005abc <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a52:	29c1                	addiw	s3,s3,16
    80005a54:	04c92783          	lw	a5,76(s2)
    80005a58:	fcf9ede3          	bltu	s3,a5,80005a32 <sys_unlink+0x148>
    80005a5c:	69ae                	ld	s3,200(sp)
    80005a5e:	bf15                	j	80005992 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005a60:	00003517          	auipc	a0,0x3
    80005a64:	c8850513          	addi	a0,a0,-888 # 800086e8 <etext+0x6e8>
    80005a68:	ffffb097          	auipc	ra,0xffffb
    80005a6c:	af8080e7          	jalr	-1288(ra) # 80000560 <panic>
    80005a70:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005a72:	00003517          	auipc	a0,0x3
    80005a76:	c8e50513          	addi	a0,a0,-882 # 80008700 <etext+0x700>
    80005a7a:	ffffb097          	auipc	ra,0xffffb
    80005a7e:	ae6080e7          	jalr	-1306(ra) # 80000560 <panic>
    dp->nlink--;
    80005a82:	04a4d783          	lhu	a5,74(s1)
    80005a86:	37fd                	addiw	a5,a5,-1
    80005a88:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a8c:	8526                	mv	a0,s1
    80005a8e:	ffffe097          	auipc	ra,0xffffe
    80005a92:	f2e080e7          	jalr	-210(ra) # 800039bc <iupdate>
    80005a96:	bf0d                	j	800059c8 <sys_unlink+0xde>
    80005a98:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005a9a:	8526                	mv	a0,s1
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	252080e7          	jalr	594(ra) # 80003cee <iunlockput>
  end_op();
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	a2c080e7          	jalr	-1492(ra) # 800044d0 <end_op>
  return -1;
    80005aac:	557d                	li	a0,-1
    80005aae:	64ee                	ld	s1,216(sp)
}
    80005ab0:	70ae                	ld	ra,232(sp)
    80005ab2:	740e                	ld	s0,224(sp)
    80005ab4:	616d                	addi	sp,sp,240
    80005ab6:	8082                	ret
    return -1;
    80005ab8:	557d                	li	a0,-1
    80005aba:	bfdd                	j	80005ab0 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005abc:	854a                	mv	a0,s2
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	230080e7          	jalr	560(ra) # 80003cee <iunlockput>
    goto bad;
    80005ac6:	694e                	ld	s2,208(sp)
    80005ac8:	69ae                	ld	s3,200(sp)
    80005aca:	bfc1                	j	80005a9a <sys_unlink+0x1b0>

0000000080005acc <sys_open>:

uint64
sys_open(void)
{
    80005acc:	7131                	addi	sp,sp,-192
    80005ace:	fd06                	sd	ra,184(sp)
    80005ad0:	f922                	sd	s0,176(sp)
    80005ad2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005ad4:	f4c40593          	addi	a1,s0,-180
    80005ad8:	4505                	li	a0,1
    80005ada:	ffffd097          	auipc	ra,0xffffd
    80005ade:	378080e7          	jalr	888(ra) # 80002e52 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ae2:	08000613          	li	a2,128
    80005ae6:	f5040593          	addi	a1,s0,-176
    80005aea:	4501                	li	a0,0
    80005aec:	ffffd097          	auipc	ra,0xffffd
    80005af0:	3a6080e7          	jalr	934(ra) # 80002e92 <argstr>
    80005af4:	87aa                	mv	a5,a0
    return -1;
    80005af6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005af8:	0a07ce63          	bltz	a5,80005bb4 <sys_open+0xe8>
    80005afc:	f526                	sd	s1,168(sp)

  begin_op();
    80005afe:	fffff097          	auipc	ra,0xfffff
    80005b02:	958080e7          	jalr	-1704(ra) # 80004456 <begin_op>

  if(omode & O_CREATE){
    80005b06:	f4c42783          	lw	a5,-180(s0)
    80005b0a:	2007f793          	andi	a5,a5,512
    80005b0e:	cfd5                	beqz	a5,80005bca <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005b10:	4681                	li	a3,0
    80005b12:	4601                	li	a2,0
    80005b14:	4589                	li	a1,2
    80005b16:	f5040513          	addi	a0,s0,-176
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	95c080e7          	jalr	-1700(ra) # 80005476 <create>
    80005b22:	84aa                	mv	s1,a0
    if(ip == 0){
    80005b24:	cd41                	beqz	a0,80005bbc <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005b26:	04449703          	lh	a4,68(s1)
    80005b2a:	478d                	li	a5,3
    80005b2c:	00f71763          	bne	a4,a5,80005b3a <sys_open+0x6e>
    80005b30:	0464d703          	lhu	a4,70(s1)
    80005b34:	47a5                	li	a5,9
    80005b36:	0ee7e163          	bltu	a5,a4,80005c18 <sys_open+0x14c>
    80005b3a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b3c:	fffff097          	auipc	ra,0xfffff
    80005b40:	d28080e7          	jalr	-728(ra) # 80004864 <filealloc>
    80005b44:	892a                	mv	s2,a0
    80005b46:	c97d                	beqz	a0,80005c3c <sys_open+0x170>
    80005b48:	ed4e                	sd	s3,152(sp)
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	8ea080e7          	jalr	-1814(ra) # 80005434 <fdalloc>
    80005b52:	89aa                	mv	s3,a0
    80005b54:	0c054e63          	bltz	a0,80005c30 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005b58:	04449703          	lh	a4,68(s1)
    80005b5c:	478d                	li	a5,3
    80005b5e:	0ef70c63          	beq	a4,a5,80005c56 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005b62:	4789                	li	a5,2
    80005b64:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005b68:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005b6c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005b70:	f4c42783          	lw	a5,-180(s0)
    80005b74:	0017c713          	xori	a4,a5,1
    80005b78:	8b05                	andi	a4,a4,1
    80005b7a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b7e:	0037f713          	andi	a4,a5,3
    80005b82:	00e03733          	snez	a4,a4
    80005b86:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005b8a:	4007f793          	andi	a5,a5,1024
    80005b8e:	c791                	beqz	a5,80005b9a <sys_open+0xce>
    80005b90:	04449703          	lh	a4,68(s1)
    80005b94:	4789                	li	a5,2
    80005b96:	0cf70763          	beq	a4,a5,80005c64 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005b9a:	8526                	mv	a0,s1
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	fb2080e7          	jalr	-78(ra) # 80003b4e <iunlock>
  end_op();
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	92c080e7          	jalr	-1748(ra) # 800044d0 <end_op>

  return fd;
    80005bac:	854e                	mv	a0,s3
    80005bae:	74aa                	ld	s1,168(sp)
    80005bb0:	790a                	ld	s2,160(sp)
    80005bb2:	69ea                	ld	s3,152(sp)
}
    80005bb4:	70ea                	ld	ra,184(sp)
    80005bb6:	744a                	ld	s0,176(sp)
    80005bb8:	6129                	addi	sp,sp,192
    80005bba:	8082                	ret
      end_op();
    80005bbc:	fffff097          	auipc	ra,0xfffff
    80005bc0:	914080e7          	jalr	-1772(ra) # 800044d0 <end_op>
      return -1;
    80005bc4:	557d                	li	a0,-1
    80005bc6:	74aa                	ld	s1,168(sp)
    80005bc8:	b7f5                	j	80005bb4 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005bca:	f5040513          	addi	a0,s0,-176
    80005bce:	ffffe097          	auipc	ra,0xffffe
    80005bd2:	688080e7          	jalr	1672(ra) # 80004256 <namei>
    80005bd6:	84aa                	mv	s1,a0
    80005bd8:	c90d                	beqz	a0,80005c0a <sys_open+0x13e>
    ilock(ip);
    80005bda:	ffffe097          	auipc	ra,0xffffe
    80005bde:	eae080e7          	jalr	-338(ra) # 80003a88 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005be2:	04449703          	lh	a4,68(s1)
    80005be6:	4785                	li	a5,1
    80005be8:	f2f71fe3          	bne	a4,a5,80005b26 <sys_open+0x5a>
    80005bec:	f4c42783          	lw	a5,-180(s0)
    80005bf0:	d7a9                	beqz	a5,80005b3a <sys_open+0x6e>
      iunlockput(ip);
    80005bf2:	8526                	mv	a0,s1
    80005bf4:	ffffe097          	auipc	ra,0xffffe
    80005bf8:	0fa080e7          	jalr	250(ra) # 80003cee <iunlockput>
      end_op();
    80005bfc:	fffff097          	auipc	ra,0xfffff
    80005c00:	8d4080e7          	jalr	-1836(ra) # 800044d0 <end_op>
      return -1;
    80005c04:	557d                	li	a0,-1
    80005c06:	74aa                	ld	s1,168(sp)
    80005c08:	b775                	j	80005bb4 <sys_open+0xe8>
      end_op();
    80005c0a:	fffff097          	auipc	ra,0xfffff
    80005c0e:	8c6080e7          	jalr	-1850(ra) # 800044d0 <end_op>
      return -1;
    80005c12:	557d                	li	a0,-1
    80005c14:	74aa                	ld	s1,168(sp)
    80005c16:	bf79                	j	80005bb4 <sys_open+0xe8>
    iunlockput(ip);
    80005c18:	8526                	mv	a0,s1
    80005c1a:	ffffe097          	auipc	ra,0xffffe
    80005c1e:	0d4080e7          	jalr	212(ra) # 80003cee <iunlockput>
    end_op();
    80005c22:	fffff097          	auipc	ra,0xfffff
    80005c26:	8ae080e7          	jalr	-1874(ra) # 800044d0 <end_op>
    return -1;
    80005c2a:	557d                	li	a0,-1
    80005c2c:	74aa                	ld	s1,168(sp)
    80005c2e:	b759                	j	80005bb4 <sys_open+0xe8>
      fileclose(f);
    80005c30:	854a                	mv	a0,s2
    80005c32:	fffff097          	auipc	ra,0xfffff
    80005c36:	cee080e7          	jalr	-786(ra) # 80004920 <fileclose>
    80005c3a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005c3c:	8526                	mv	a0,s1
    80005c3e:	ffffe097          	auipc	ra,0xffffe
    80005c42:	0b0080e7          	jalr	176(ra) # 80003cee <iunlockput>
    end_op();
    80005c46:	fffff097          	auipc	ra,0xfffff
    80005c4a:	88a080e7          	jalr	-1910(ra) # 800044d0 <end_op>
    return -1;
    80005c4e:	557d                	li	a0,-1
    80005c50:	74aa                	ld	s1,168(sp)
    80005c52:	790a                	ld	s2,160(sp)
    80005c54:	b785                	j	80005bb4 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005c56:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005c5a:	04649783          	lh	a5,70(s1)
    80005c5e:	02f91223          	sh	a5,36(s2)
    80005c62:	b729                	j	80005b6c <sys_open+0xa0>
    itrunc(ip);
    80005c64:	8526                	mv	a0,s1
    80005c66:	ffffe097          	auipc	ra,0xffffe
    80005c6a:	f34080e7          	jalr	-204(ra) # 80003b9a <itrunc>
    80005c6e:	b735                	j	80005b9a <sys_open+0xce>

0000000080005c70 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005c70:	7175                	addi	sp,sp,-144
    80005c72:	e506                	sd	ra,136(sp)
    80005c74:	e122                	sd	s0,128(sp)
    80005c76:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005c78:	ffffe097          	auipc	ra,0xffffe
    80005c7c:	7de080e7          	jalr	2014(ra) # 80004456 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005c80:	08000613          	li	a2,128
    80005c84:	f7040593          	addi	a1,s0,-144
    80005c88:	4501                	li	a0,0
    80005c8a:	ffffd097          	auipc	ra,0xffffd
    80005c8e:	208080e7          	jalr	520(ra) # 80002e92 <argstr>
    80005c92:	02054963          	bltz	a0,80005cc4 <sys_mkdir+0x54>
    80005c96:	4681                	li	a3,0
    80005c98:	4601                	li	a2,0
    80005c9a:	4585                	li	a1,1
    80005c9c:	f7040513          	addi	a0,s0,-144
    80005ca0:	fffff097          	auipc	ra,0xfffff
    80005ca4:	7d6080e7          	jalr	2006(ra) # 80005476 <create>
    80005ca8:	cd11                	beqz	a0,80005cc4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005caa:	ffffe097          	auipc	ra,0xffffe
    80005cae:	044080e7          	jalr	68(ra) # 80003cee <iunlockput>
  end_op();
    80005cb2:	fffff097          	auipc	ra,0xfffff
    80005cb6:	81e080e7          	jalr	-2018(ra) # 800044d0 <end_op>
  return 0;
    80005cba:	4501                	li	a0,0
}
    80005cbc:	60aa                	ld	ra,136(sp)
    80005cbe:	640a                	ld	s0,128(sp)
    80005cc0:	6149                	addi	sp,sp,144
    80005cc2:	8082                	ret
    end_op();
    80005cc4:	fffff097          	auipc	ra,0xfffff
    80005cc8:	80c080e7          	jalr	-2036(ra) # 800044d0 <end_op>
    return -1;
    80005ccc:	557d                	li	a0,-1
    80005cce:	b7fd                	j	80005cbc <sys_mkdir+0x4c>

0000000080005cd0 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005cd0:	7135                	addi	sp,sp,-160
    80005cd2:	ed06                	sd	ra,152(sp)
    80005cd4:	e922                	sd	s0,144(sp)
    80005cd6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005cd8:	ffffe097          	auipc	ra,0xffffe
    80005cdc:	77e080e7          	jalr	1918(ra) # 80004456 <begin_op>
  argint(1, &major);
    80005ce0:	f6c40593          	addi	a1,s0,-148
    80005ce4:	4505                	li	a0,1
    80005ce6:	ffffd097          	auipc	ra,0xffffd
    80005cea:	16c080e7          	jalr	364(ra) # 80002e52 <argint>
  argint(2, &minor);
    80005cee:	f6840593          	addi	a1,s0,-152
    80005cf2:	4509                	li	a0,2
    80005cf4:	ffffd097          	auipc	ra,0xffffd
    80005cf8:	15e080e7          	jalr	350(ra) # 80002e52 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005cfc:	08000613          	li	a2,128
    80005d00:	f7040593          	addi	a1,s0,-144
    80005d04:	4501                	li	a0,0
    80005d06:	ffffd097          	auipc	ra,0xffffd
    80005d0a:	18c080e7          	jalr	396(ra) # 80002e92 <argstr>
    80005d0e:	02054b63          	bltz	a0,80005d44 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d12:	f6841683          	lh	a3,-152(s0)
    80005d16:	f6c41603          	lh	a2,-148(s0)
    80005d1a:	458d                	li	a1,3
    80005d1c:	f7040513          	addi	a0,s0,-144
    80005d20:	fffff097          	auipc	ra,0xfffff
    80005d24:	756080e7          	jalr	1878(ra) # 80005476 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d28:	cd11                	beqz	a0,80005d44 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d2a:	ffffe097          	auipc	ra,0xffffe
    80005d2e:	fc4080e7          	jalr	-60(ra) # 80003cee <iunlockput>
  end_op();
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	79e080e7          	jalr	1950(ra) # 800044d0 <end_op>
  return 0;
    80005d3a:	4501                	li	a0,0
}
    80005d3c:	60ea                	ld	ra,152(sp)
    80005d3e:	644a                	ld	s0,144(sp)
    80005d40:	610d                	addi	sp,sp,160
    80005d42:	8082                	ret
    end_op();
    80005d44:	ffffe097          	auipc	ra,0xffffe
    80005d48:	78c080e7          	jalr	1932(ra) # 800044d0 <end_op>
    return -1;
    80005d4c:	557d                	li	a0,-1
    80005d4e:	b7fd                	j	80005d3c <sys_mknod+0x6c>

0000000080005d50 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d50:	7135                	addi	sp,sp,-160
    80005d52:	ed06                	sd	ra,152(sp)
    80005d54:	e922                	sd	s0,144(sp)
    80005d56:	e14a                	sd	s2,128(sp)
    80005d58:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005d5a:	ffffc097          	auipc	ra,0xffffc
    80005d5e:	dc4080e7          	jalr	-572(ra) # 80001b1e <myproc>
    80005d62:	892a                	mv	s2,a0
  
  begin_op();
    80005d64:	ffffe097          	auipc	ra,0xffffe
    80005d68:	6f2080e7          	jalr	1778(ra) # 80004456 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005d6c:	08000613          	li	a2,128
    80005d70:	f6040593          	addi	a1,s0,-160
    80005d74:	4501                	li	a0,0
    80005d76:	ffffd097          	auipc	ra,0xffffd
    80005d7a:	11c080e7          	jalr	284(ra) # 80002e92 <argstr>
    80005d7e:	04054d63          	bltz	a0,80005dd8 <sys_chdir+0x88>
    80005d82:	e526                	sd	s1,136(sp)
    80005d84:	f6040513          	addi	a0,s0,-160
    80005d88:	ffffe097          	auipc	ra,0xffffe
    80005d8c:	4ce080e7          	jalr	1230(ra) # 80004256 <namei>
    80005d90:	84aa                	mv	s1,a0
    80005d92:	c131                	beqz	a0,80005dd6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d94:	ffffe097          	auipc	ra,0xffffe
    80005d98:	cf4080e7          	jalr	-780(ra) # 80003a88 <ilock>
  if(ip->type != T_DIR){
    80005d9c:	04449703          	lh	a4,68(s1)
    80005da0:	4785                	li	a5,1
    80005da2:	04f71163          	bne	a4,a5,80005de4 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005da6:	8526                	mv	a0,s1
    80005da8:	ffffe097          	auipc	ra,0xffffe
    80005dac:	da6080e7          	jalr	-602(ra) # 80003b4e <iunlock>
  iput(p->cwd);
    80005db0:	15093503          	ld	a0,336(s2)
    80005db4:	ffffe097          	auipc	ra,0xffffe
    80005db8:	e92080e7          	jalr	-366(ra) # 80003c46 <iput>
  end_op();
    80005dbc:	ffffe097          	auipc	ra,0xffffe
    80005dc0:	714080e7          	jalr	1812(ra) # 800044d0 <end_op>
  p->cwd = ip;
    80005dc4:	14993823          	sd	s1,336(s2)
  return 0;
    80005dc8:	4501                	li	a0,0
    80005dca:	64aa                	ld	s1,136(sp)
}
    80005dcc:	60ea                	ld	ra,152(sp)
    80005dce:	644a                	ld	s0,144(sp)
    80005dd0:	690a                	ld	s2,128(sp)
    80005dd2:	610d                	addi	sp,sp,160
    80005dd4:	8082                	ret
    80005dd6:	64aa                	ld	s1,136(sp)
    end_op();
    80005dd8:	ffffe097          	auipc	ra,0xffffe
    80005ddc:	6f8080e7          	jalr	1784(ra) # 800044d0 <end_op>
    return -1;
    80005de0:	557d                	li	a0,-1
    80005de2:	b7ed                	j	80005dcc <sys_chdir+0x7c>
    iunlockput(ip);
    80005de4:	8526                	mv	a0,s1
    80005de6:	ffffe097          	auipc	ra,0xffffe
    80005dea:	f08080e7          	jalr	-248(ra) # 80003cee <iunlockput>
    end_op();
    80005dee:	ffffe097          	auipc	ra,0xffffe
    80005df2:	6e2080e7          	jalr	1762(ra) # 800044d0 <end_op>
    return -1;
    80005df6:	557d                	li	a0,-1
    80005df8:	64aa                	ld	s1,136(sp)
    80005dfa:	bfc9                	j	80005dcc <sys_chdir+0x7c>

0000000080005dfc <sys_exec>:

uint64
sys_exec(void)
{
    80005dfc:	7121                	addi	sp,sp,-448
    80005dfe:	ff06                	sd	ra,440(sp)
    80005e00:	fb22                	sd	s0,432(sp)
    80005e02:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005e04:	e4840593          	addi	a1,s0,-440
    80005e08:	4505                	li	a0,1
    80005e0a:	ffffd097          	auipc	ra,0xffffd
    80005e0e:	068080e7          	jalr	104(ra) # 80002e72 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005e12:	08000613          	li	a2,128
    80005e16:	f5040593          	addi	a1,s0,-176
    80005e1a:	4501                	li	a0,0
    80005e1c:	ffffd097          	auipc	ra,0xffffd
    80005e20:	076080e7          	jalr	118(ra) # 80002e92 <argstr>
    80005e24:	87aa                	mv	a5,a0
    return -1;
    80005e26:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005e28:	0e07c263          	bltz	a5,80005f0c <sys_exec+0x110>
    80005e2c:	f726                	sd	s1,424(sp)
    80005e2e:	f34a                	sd	s2,416(sp)
    80005e30:	ef4e                	sd	s3,408(sp)
    80005e32:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005e34:	10000613          	li	a2,256
    80005e38:	4581                	li	a1,0
    80005e3a:	e5040513          	addi	a0,s0,-432
    80005e3e:	ffffb097          	auipc	ra,0xffffb
    80005e42:	ef6080e7          	jalr	-266(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e46:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005e4a:	89a6                	mv	s3,s1
    80005e4c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005e4e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e52:	00391513          	slli	a0,s2,0x3
    80005e56:	e4040593          	addi	a1,s0,-448
    80005e5a:	e4843783          	ld	a5,-440(s0)
    80005e5e:	953e                	add	a0,a0,a5
    80005e60:	ffffd097          	auipc	ra,0xffffd
    80005e64:	f54080e7          	jalr	-172(ra) # 80002db4 <fetchaddr>
    80005e68:	02054a63          	bltz	a0,80005e9c <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005e6c:	e4043783          	ld	a5,-448(s0)
    80005e70:	c7b9                	beqz	a5,80005ebe <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005e72:	ffffb097          	auipc	ra,0xffffb
    80005e76:	cd6080e7          	jalr	-810(ra) # 80000b48 <kalloc>
    80005e7a:	85aa                	mv	a1,a0
    80005e7c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e80:	cd11                	beqz	a0,80005e9c <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e82:	6605                	lui	a2,0x1
    80005e84:	e4043503          	ld	a0,-448(s0)
    80005e88:	ffffd097          	auipc	ra,0xffffd
    80005e8c:	f7e080e7          	jalr	-130(ra) # 80002e06 <fetchstr>
    80005e90:	00054663          	bltz	a0,80005e9c <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005e94:	0905                	addi	s2,s2,1
    80005e96:	09a1                	addi	s3,s3,8
    80005e98:	fb491de3          	bne	s2,s4,80005e52 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e9c:	f5040913          	addi	s2,s0,-176
    80005ea0:	6088                	ld	a0,0(s1)
    80005ea2:	c125                	beqz	a0,80005f02 <sys_exec+0x106>
    kfree(argv[i]);
    80005ea4:	ffffb097          	auipc	ra,0xffffb
    80005ea8:	ba6080e7          	jalr	-1114(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005eac:	04a1                	addi	s1,s1,8
    80005eae:	ff2499e3          	bne	s1,s2,80005ea0 <sys_exec+0xa4>
  return -1;
    80005eb2:	557d                	li	a0,-1
    80005eb4:	74ba                	ld	s1,424(sp)
    80005eb6:	791a                	ld	s2,416(sp)
    80005eb8:	69fa                	ld	s3,408(sp)
    80005eba:	6a5a                	ld	s4,400(sp)
    80005ebc:	a881                	j	80005f0c <sys_exec+0x110>
      argv[i] = 0;
    80005ebe:	0009079b          	sext.w	a5,s2
    80005ec2:	078e                	slli	a5,a5,0x3
    80005ec4:	fd078793          	addi	a5,a5,-48
    80005ec8:	97a2                	add	a5,a5,s0
    80005eca:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005ece:	e5040593          	addi	a1,s0,-432
    80005ed2:	f5040513          	addi	a0,s0,-176
    80005ed6:	fffff097          	auipc	ra,0xfffff
    80005eda:	120080e7          	jalr	288(ra) # 80004ff6 <exec>
    80005ede:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ee0:	f5040993          	addi	s3,s0,-176
    80005ee4:	6088                	ld	a0,0(s1)
    80005ee6:	c901                	beqz	a0,80005ef6 <sys_exec+0xfa>
    kfree(argv[i]);
    80005ee8:	ffffb097          	auipc	ra,0xffffb
    80005eec:	b62080e7          	jalr	-1182(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ef0:	04a1                	addi	s1,s1,8
    80005ef2:	ff3499e3          	bne	s1,s3,80005ee4 <sys_exec+0xe8>
  return ret;
    80005ef6:	854a                	mv	a0,s2
    80005ef8:	74ba                	ld	s1,424(sp)
    80005efa:	791a                	ld	s2,416(sp)
    80005efc:	69fa                	ld	s3,408(sp)
    80005efe:	6a5a                	ld	s4,400(sp)
    80005f00:	a031                	j	80005f0c <sys_exec+0x110>
  return -1;
    80005f02:	557d                	li	a0,-1
    80005f04:	74ba                	ld	s1,424(sp)
    80005f06:	791a                	ld	s2,416(sp)
    80005f08:	69fa                	ld	s3,408(sp)
    80005f0a:	6a5a                	ld	s4,400(sp)
}
    80005f0c:	70fa                	ld	ra,440(sp)
    80005f0e:	745a                	ld	s0,432(sp)
    80005f10:	6139                	addi	sp,sp,448
    80005f12:	8082                	ret

0000000080005f14 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005f14:	7139                	addi	sp,sp,-64
    80005f16:	fc06                	sd	ra,56(sp)
    80005f18:	f822                	sd	s0,48(sp)
    80005f1a:	f426                	sd	s1,40(sp)
    80005f1c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005f1e:	ffffc097          	auipc	ra,0xffffc
    80005f22:	c00080e7          	jalr	-1024(ra) # 80001b1e <myproc>
    80005f26:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005f28:	fd840593          	addi	a1,s0,-40
    80005f2c:	4501                	li	a0,0
    80005f2e:	ffffd097          	auipc	ra,0xffffd
    80005f32:	f44080e7          	jalr	-188(ra) # 80002e72 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005f36:	fc840593          	addi	a1,s0,-56
    80005f3a:	fd040513          	addi	a0,s0,-48
    80005f3e:	fffff097          	auipc	ra,0xfffff
    80005f42:	d50080e7          	jalr	-688(ra) # 80004c8e <pipealloc>
    return -1;
    80005f46:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005f48:	0c054463          	bltz	a0,80006010 <sys_pipe+0xfc>
  fd0 = -1;
    80005f4c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f50:	fd043503          	ld	a0,-48(s0)
    80005f54:	fffff097          	auipc	ra,0xfffff
    80005f58:	4e0080e7          	jalr	1248(ra) # 80005434 <fdalloc>
    80005f5c:	fca42223          	sw	a0,-60(s0)
    80005f60:	08054b63          	bltz	a0,80005ff6 <sys_pipe+0xe2>
    80005f64:	fc843503          	ld	a0,-56(s0)
    80005f68:	fffff097          	auipc	ra,0xfffff
    80005f6c:	4cc080e7          	jalr	1228(ra) # 80005434 <fdalloc>
    80005f70:	fca42023          	sw	a0,-64(s0)
    80005f74:	06054863          	bltz	a0,80005fe4 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f78:	4691                	li	a3,4
    80005f7a:	fc440613          	addi	a2,s0,-60
    80005f7e:	fd843583          	ld	a1,-40(s0)
    80005f82:	68a8                	ld	a0,80(s1)
    80005f84:	ffffb097          	auipc	ra,0xffffb
    80005f88:	75e080e7          	jalr	1886(ra) # 800016e2 <copyout>
    80005f8c:	02054063          	bltz	a0,80005fac <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f90:	4691                	li	a3,4
    80005f92:	fc040613          	addi	a2,s0,-64
    80005f96:	fd843583          	ld	a1,-40(s0)
    80005f9a:	0591                	addi	a1,a1,4
    80005f9c:	68a8                	ld	a0,80(s1)
    80005f9e:	ffffb097          	auipc	ra,0xffffb
    80005fa2:	744080e7          	jalr	1860(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005fa6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005fa8:	06055463          	bgez	a0,80006010 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005fac:	fc442783          	lw	a5,-60(s0)
    80005fb0:	07e9                	addi	a5,a5,26
    80005fb2:	078e                	slli	a5,a5,0x3
    80005fb4:	97a6                	add	a5,a5,s1
    80005fb6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005fba:	fc042783          	lw	a5,-64(s0)
    80005fbe:	07e9                	addi	a5,a5,26
    80005fc0:	078e                	slli	a5,a5,0x3
    80005fc2:	94be                	add	s1,s1,a5
    80005fc4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005fc8:	fd043503          	ld	a0,-48(s0)
    80005fcc:	fffff097          	auipc	ra,0xfffff
    80005fd0:	954080e7          	jalr	-1708(ra) # 80004920 <fileclose>
    fileclose(wf);
    80005fd4:	fc843503          	ld	a0,-56(s0)
    80005fd8:	fffff097          	auipc	ra,0xfffff
    80005fdc:	948080e7          	jalr	-1720(ra) # 80004920 <fileclose>
    return -1;
    80005fe0:	57fd                	li	a5,-1
    80005fe2:	a03d                	j	80006010 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005fe4:	fc442783          	lw	a5,-60(s0)
    80005fe8:	0007c763          	bltz	a5,80005ff6 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005fec:	07e9                	addi	a5,a5,26
    80005fee:	078e                	slli	a5,a5,0x3
    80005ff0:	97a6                	add	a5,a5,s1
    80005ff2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005ff6:	fd043503          	ld	a0,-48(s0)
    80005ffa:	fffff097          	auipc	ra,0xfffff
    80005ffe:	926080e7          	jalr	-1754(ra) # 80004920 <fileclose>
    fileclose(wf);
    80006002:	fc843503          	ld	a0,-56(s0)
    80006006:	fffff097          	auipc	ra,0xfffff
    8000600a:	91a080e7          	jalr	-1766(ra) # 80004920 <fileclose>
    return -1;
    8000600e:	57fd                	li	a5,-1
}
    80006010:	853e                	mv	a0,a5
    80006012:	70e2                	ld	ra,56(sp)
    80006014:	7442                	ld	s0,48(sp)
    80006016:	74a2                	ld	s1,40(sp)
    80006018:	6121                	addi	sp,sp,64
    8000601a:	8082                	ret
    8000601c:	0000                	unimp
	...

0000000080006020 <kernelvec>:
    80006020:	7111                	addi	sp,sp,-256
    80006022:	e006                	sd	ra,0(sp)
    80006024:	e40a                	sd	sp,8(sp)
    80006026:	e80e                	sd	gp,16(sp)
    80006028:	ec12                	sd	tp,24(sp)
    8000602a:	f016                	sd	t0,32(sp)
    8000602c:	f41a                	sd	t1,40(sp)
    8000602e:	f81e                	sd	t2,48(sp)
    80006030:	fc22                	sd	s0,56(sp)
    80006032:	e0a6                	sd	s1,64(sp)
    80006034:	e4aa                	sd	a0,72(sp)
    80006036:	e8ae                	sd	a1,80(sp)
    80006038:	ecb2                	sd	a2,88(sp)
    8000603a:	f0b6                	sd	a3,96(sp)
    8000603c:	f4ba                	sd	a4,104(sp)
    8000603e:	f8be                	sd	a5,112(sp)
    80006040:	fcc2                	sd	a6,120(sp)
    80006042:	e146                	sd	a7,128(sp)
    80006044:	e54a                	sd	s2,136(sp)
    80006046:	e94e                	sd	s3,144(sp)
    80006048:	ed52                	sd	s4,152(sp)
    8000604a:	f156                	sd	s5,160(sp)
    8000604c:	f55a                	sd	s6,168(sp)
    8000604e:	f95e                	sd	s7,176(sp)
    80006050:	fd62                	sd	s8,184(sp)
    80006052:	e1e6                	sd	s9,192(sp)
    80006054:	e5ea                	sd	s10,200(sp)
    80006056:	e9ee                	sd	s11,208(sp)
    80006058:	edf2                	sd	t3,216(sp)
    8000605a:	f1f6                	sd	t4,224(sp)
    8000605c:	f5fa                	sd	t5,232(sp)
    8000605e:	f9fe                	sd	t6,240(sp)
    80006060:	c1ffc0ef          	jal	80002c7e <kerneltrap>
    80006064:	6082                	ld	ra,0(sp)
    80006066:	6122                	ld	sp,8(sp)
    80006068:	61c2                	ld	gp,16(sp)
    8000606a:	7282                	ld	t0,32(sp)
    8000606c:	7322                	ld	t1,40(sp)
    8000606e:	73c2                	ld	t2,48(sp)
    80006070:	7462                	ld	s0,56(sp)
    80006072:	6486                	ld	s1,64(sp)
    80006074:	6526                	ld	a0,72(sp)
    80006076:	65c6                	ld	a1,80(sp)
    80006078:	6666                	ld	a2,88(sp)
    8000607a:	7686                	ld	a3,96(sp)
    8000607c:	7726                	ld	a4,104(sp)
    8000607e:	77c6                	ld	a5,112(sp)
    80006080:	7866                	ld	a6,120(sp)
    80006082:	688a                	ld	a7,128(sp)
    80006084:	692a                	ld	s2,136(sp)
    80006086:	69ca                	ld	s3,144(sp)
    80006088:	6a6a                	ld	s4,152(sp)
    8000608a:	7a8a                	ld	s5,160(sp)
    8000608c:	7b2a                	ld	s6,168(sp)
    8000608e:	7bca                	ld	s7,176(sp)
    80006090:	7c6a                	ld	s8,184(sp)
    80006092:	6c8e                	ld	s9,192(sp)
    80006094:	6d2e                	ld	s10,200(sp)
    80006096:	6dce                	ld	s11,208(sp)
    80006098:	6e6e                	ld	t3,216(sp)
    8000609a:	7e8e                	ld	t4,224(sp)
    8000609c:	7f2e                	ld	t5,232(sp)
    8000609e:	7fce                	ld	t6,240(sp)
    800060a0:	6111                	addi	sp,sp,256
    800060a2:	10200073          	sret
    800060a6:	00000013          	nop
    800060aa:	00000013          	nop
    800060ae:	0001                	nop

00000000800060b0 <timervec>:
    800060b0:	34051573          	csrrw	a0,mscratch,a0
    800060b4:	e10c                	sd	a1,0(a0)
    800060b6:	e510                	sd	a2,8(a0)
    800060b8:	e914                	sd	a3,16(a0)
    800060ba:	6d0c                	ld	a1,24(a0)
    800060bc:	7110                	ld	a2,32(a0)
    800060be:	6194                	ld	a3,0(a1)
    800060c0:	96b2                	add	a3,a3,a2
    800060c2:	e194                	sd	a3,0(a1)
    800060c4:	4589                	li	a1,2
    800060c6:	14459073          	csrw	sip,a1
    800060ca:	6914                	ld	a3,16(a0)
    800060cc:	6510                	ld	a2,8(a0)
    800060ce:	610c                	ld	a1,0(a0)
    800060d0:	34051573          	csrrw	a0,mscratch,a0
    800060d4:	30200073          	mret
	...

00000000800060da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800060da:	1141                	addi	sp,sp,-16
    800060dc:	e422                	sd	s0,8(sp)
    800060de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800060e0:	0c0007b7          	lui	a5,0xc000
    800060e4:	4705                	li	a4,1
    800060e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800060e8:	0c0007b7          	lui	a5,0xc000
    800060ec:	c3d8                	sw	a4,4(a5)
}
    800060ee:	6422                	ld	s0,8(sp)
    800060f0:	0141                	addi	sp,sp,16
    800060f2:	8082                	ret

00000000800060f4 <plicinithart>:

void
plicinithart(void)
{
    800060f4:	1141                	addi	sp,sp,-16
    800060f6:	e406                	sd	ra,8(sp)
    800060f8:	e022                	sd	s0,0(sp)
    800060fa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060fc:	ffffc097          	auipc	ra,0xffffc
    80006100:	9f6080e7          	jalr	-1546(ra) # 80001af2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006104:	0085171b          	slliw	a4,a0,0x8
    80006108:	0c0027b7          	lui	a5,0xc002
    8000610c:	97ba                	add	a5,a5,a4
    8000610e:	40200713          	li	a4,1026
    80006112:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006116:	00d5151b          	slliw	a0,a0,0xd
    8000611a:	0c2017b7          	lui	a5,0xc201
    8000611e:	97aa                	add	a5,a5,a0
    80006120:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006124:	60a2                	ld	ra,8(sp)
    80006126:	6402                	ld	s0,0(sp)
    80006128:	0141                	addi	sp,sp,16
    8000612a:	8082                	ret

000000008000612c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000612c:	1141                	addi	sp,sp,-16
    8000612e:	e406                	sd	ra,8(sp)
    80006130:	e022                	sd	s0,0(sp)
    80006132:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006134:	ffffc097          	auipc	ra,0xffffc
    80006138:	9be080e7          	jalr	-1602(ra) # 80001af2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000613c:	00d5151b          	slliw	a0,a0,0xd
    80006140:	0c2017b7          	lui	a5,0xc201
    80006144:	97aa                	add	a5,a5,a0
  return irq;
}
    80006146:	43c8                	lw	a0,4(a5)
    80006148:	60a2                	ld	ra,8(sp)
    8000614a:	6402                	ld	s0,0(sp)
    8000614c:	0141                	addi	sp,sp,16
    8000614e:	8082                	ret

0000000080006150 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006150:	1101                	addi	sp,sp,-32
    80006152:	ec06                	sd	ra,24(sp)
    80006154:	e822                	sd	s0,16(sp)
    80006156:	e426                	sd	s1,8(sp)
    80006158:	1000                	addi	s0,sp,32
    8000615a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000615c:	ffffc097          	auipc	ra,0xffffc
    80006160:	996080e7          	jalr	-1642(ra) # 80001af2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006164:	00d5151b          	slliw	a0,a0,0xd
    80006168:	0c2017b7          	lui	a5,0xc201
    8000616c:	97aa                	add	a5,a5,a0
    8000616e:	c3c4                	sw	s1,4(a5)
}
    80006170:	60e2                	ld	ra,24(sp)
    80006172:	6442                	ld	s0,16(sp)
    80006174:	64a2                	ld	s1,8(sp)
    80006176:	6105                	addi	sp,sp,32
    80006178:	8082                	ret

000000008000617a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000617a:	1141                	addi	sp,sp,-16
    8000617c:	e406                	sd	ra,8(sp)
    8000617e:	e022                	sd	s0,0(sp)
    80006180:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006182:	479d                	li	a5,7
    80006184:	04a7cc63          	blt	a5,a0,800061dc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006188:	0001e797          	auipc	a5,0x1e
    8000618c:	61878793          	addi	a5,a5,1560 # 800247a0 <disk>
    80006190:	97aa                	add	a5,a5,a0
    80006192:	0187c783          	lbu	a5,24(a5)
    80006196:	ebb9                	bnez	a5,800061ec <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006198:	00451693          	slli	a3,a0,0x4
    8000619c:	0001e797          	auipc	a5,0x1e
    800061a0:	60478793          	addi	a5,a5,1540 # 800247a0 <disk>
    800061a4:	6398                	ld	a4,0(a5)
    800061a6:	9736                	add	a4,a4,a3
    800061a8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800061ac:	6398                	ld	a4,0(a5)
    800061ae:	9736                	add	a4,a4,a3
    800061b0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800061b4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800061b8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800061bc:	97aa                	add	a5,a5,a0
    800061be:	4705                	li	a4,1
    800061c0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800061c4:	0001e517          	auipc	a0,0x1e
    800061c8:	5f450513          	addi	a0,a0,1524 # 800247b8 <disk+0x18>
    800061cc:	ffffc097          	auipc	ra,0xffffc
    800061d0:	18e080e7          	jalr	398(ra) # 8000235a <wakeup>
}
    800061d4:	60a2                	ld	ra,8(sp)
    800061d6:	6402                	ld	s0,0(sp)
    800061d8:	0141                	addi	sp,sp,16
    800061da:	8082                	ret
    panic("free_desc 1");
    800061dc:	00002517          	auipc	a0,0x2
    800061e0:	53450513          	addi	a0,a0,1332 # 80008710 <etext+0x710>
    800061e4:	ffffa097          	auipc	ra,0xffffa
    800061e8:	37c080e7          	jalr	892(ra) # 80000560 <panic>
    panic("free_desc 2");
    800061ec:	00002517          	auipc	a0,0x2
    800061f0:	53450513          	addi	a0,a0,1332 # 80008720 <etext+0x720>
    800061f4:	ffffa097          	auipc	ra,0xffffa
    800061f8:	36c080e7          	jalr	876(ra) # 80000560 <panic>

00000000800061fc <virtio_disk_init>:
{
    800061fc:	1101                	addi	sp,sp,-32
    800061fe:	ec06                	sd	ra,24(sp)
    80006200:	e822                	sd	s0,16(sp)
    80006202:	e426                	sd	s1,8(sp)
    80006204:	e04a                	sd	s2,0(sp)
    80006206:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006208:	00002597          	auipc	a1,0x2
    8000620c:	52858593          	addi	a1,a1,1320 # 80008730 <etext+0x730>
    80006210:	0001e517          	auipc	a0,0x1e
    80006214:	6b850513          	addi	a0,a0,1720 # 800248c8 <disk+0x128>
    80006218:	ffffb097          	auipc	ra,0xffffb
    8000621c:	990080e7          	jalr	-1648(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006220:	100017b7          	lui	a5,0x10001
    80006224:	4398                	lw	a4,0(a5)
    80006226:	2701                	sext.w	a4,a4
    80006228:	747277b7          	lui	a5,0x74727
    8000622c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006230:	18f71c63          	bne	a4,a5,800063c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006234:	100017b7          	lui	a5,0x10001
    80006238:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000623a:	439c                	lw	a5,0(a5)
    8000623c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000623e:	4709                	li	a4,2
    80006240:	18e79463          	bne	a5,a4,800063c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006244:	100017b7          	lui	a5,0x10001
    80006248:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000624a:	439c                	lw	a5,0(a5)
    8000624c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000624e:	16e79d63          	bne	a5,a4,800063c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006252:	100017b7          	lui	a5,0x10001
    80006256:	47d8                	lw	a4,12(a5)
    80006258:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000625a:	554d47b7          	lui	a5,0x554d4
    8000625e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006262:	16f71363          	bne	a4,a5,800063c8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006266:	100017b7          	lui	a5,0x10001
    8000626a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000626e:	4705                	li	a4,1
    80006270:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006272:	470d                	li	a4,3
    80006274:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006276:	10001737          	lui	a4,0x10001
    8000627a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000627c:	c7ffe737          	lui	a4,0xc7ffe
    80006280:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9e7f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006284:	8ef9                	and	a3,a3,a4
    80006286:	10001737          	lui	a4,0x10001
    8000628a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000628c:	472d                	li	a4,11
    8000628e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006290:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006294:	439c                	lw	a5,0(a5)
    80006296:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000629a:	8ba1                	andi	a5,a5,8
    8000629c:	12078e63          	beqz	a5,800063d8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800062a0:	100017b7          	lui	a5,0x10001
    800062a4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800062a8:	100017b7          	lui	a5,0x10001
    800062ac:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800062b0:	439c                	lw	a5,0(a5)
    800062b2:	2781                	sext.w	a5,a5
    800062b4:	12079a63          	bnez	a5,800063e8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800062b8:	100017b7          	lui	a5,0x10001
    800062bc:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800062c0:	439c                	lw	a5,0(a5)
    800062c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800062c4:	12078a63          	beqz	a5,800063f8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800062c8:	471d                	li	a4,7
    800062ca:	12f77f63          	bgeu	a4,a5,80006408 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	87a080e7          	jalr	-1926(ra) # 80000b48 <kalloc>
    800062d6:	0001e497          	auipc	s1,0x1e
    800062da:	4ca48493          	addi	s1,s1,1226 # 800247a0 <disk>
    800062de:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800062e0:	ffffb097          	auipc	ra,0xffffb
    800062e4:	868080e7          	jalr	-1944(ra) # 80000b48 <kalloc>
    800062e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800062ea:	ffffb097          	auipc	ra,0xffffb
    800062ee:	85e080e7          	jalr	-1954(ra) # 80000b48 <kalloc>
    800062f2:	87aa                	mv	a5,a0
    800062f4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800062f6:	6088                	ld	a0,0(s1)
    800062f8:	12050063          	beqz	a0,80006418 <virtio_disk_init+0x21c>
    800062fc:	0001e717          	auipc	a4,0x1e
    80006300:	4ac73703          	ld	a4,1196(a4) # 800247a8 <disk+0x8>
    80006304:	10070a63          	beqz	a4,80006418 <virtio_disk_init+0x21c>
    80006308:	10078863          	beqz	a5,80006418 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000630c:	6605                	lui	a2,0x1
    8000630e:	4581                	li	a1,0
    80006310:	ffffb097          	auipc	ra,0xffffb
    80006314:	a24080e7          	jalr	-1500(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006318:	0001e497          	auipc	s1,0x1e
    8000631c:	48848493          	addi	s1,s1,1160 # 800247a0 <disk>
    80006320:	6605                	lui	a2,0x1
    80006322:	4581                	li	a1,0
    80006324:	6488                	ld	a0,8(s1)
    80006326:	ffffb097          	auipc	ra,0xffffb
    8000632a:	a0e080e7          	jalr	-1522(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    8000632e:	6605                	lui	a2,0x1
    80006330:	4581                	li	a1,0
    80006332:	6888                	ld	a0,16(s1)
    80006334:	ffffb097          	auipc	ra,0xffffb
    80006338:	a00080e7          	jalr	-1536(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000633c:	100017b7          	lui	a5,0x10001
    80006340:	4721                	li	a4,8
    80006342:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006344:	4098                	lw	a4,0(s1)
    80006346:	100017b7          	lui	a5,0x10001
    8000634a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000634e:	40d8                	lw	a4,4(s1)
    80006350:	100017b7          	lui	a5,0x10001
    80006354:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006358:	649c                	ld	a5,8(s1)
    8000635a:	0007869b          	sext.w	a3,a5
    8000635e:	10001737          	lui	a4,0x10001
    80006362:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006366:	9781                	srai	a5,a5,0x20
    80006368:	10001737          	lui	a4,0x10001
    8000636c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006370:	689c                	ld	a5,16(s1)
    80006372:	0007869b          	sext.w	a3,a5
    80006376:	10001737          	lui	a4,0x10001
    8000637a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000637e:	9781                	srai	a5,a5,0x20
    80006380:	10001737          	lui	a4,0x10001
    80006384:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006388:	10001737          	lui	a4,0x10001
    8000638c:	4785                	li	a5,1
    8000638e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006390:	00f48c23          	sb	a5,24(s1)
    80006394:	00f48ca3          	sb	a5,25(s1)
    80006398:	00f48d23          	sb	a5,26(s1)
    8000639c:	00f48da3          	sb	a5,27(s1)
    800063a0:	00f48e23          	sb	a5,28(s1)
    800063a4:	00f48ea3          	sb	a5,29(s1)
    800063a8:	00f48f23          	sb	a5,30(s1)
    800063ac:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800063b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800063b4:	100017b7          	lui	a5,0x10001
    800063b8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800063bc:	60e2                	ld	ra,24(sp)
    800063be:	6442                	ld	s0,16(sp)
    800063c0:	64a2                	ld	s1,8(sp)
    800063c2:	6902                	ld	s2,0(sp)
    800063c4:	6105                	addi	sp,sp,32
    800063c6:	8082                	ret
    panic("could not find virtio disk");
    800063c8:	00002517          	auipc	a0,0x2
    800063cc:	37850513          	addi	a0,a0,888 # 80008740 <etext+0x740>
    800063d0:	ffffa097          	auipc	ra,0xffffa
    800063d4:	190080e7          	jalr	400(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800063d8:	00002517          	auipc	a0,0x2
    800063dc:	38850513          	addi	a0,a0,904 # 80008760 <etext+0x760>
    800063e0:	ffffa097          	auipc	ra,0xffffa
    800063e4:	180080e7          	jalr	384(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800063e8:	00002517          	auipc	a0,0x2
    800063ec:	39850513          	addi	a0,a0,920 # 80008780 <etext+0x780>
    800063f0:	ffffa097          	auipc	ra,0xffffa
    800063f4:	170080e7          	jalr	368(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800063f8:	00002517          	auipc	a0,0x2
    800063fc:	3a850513          	addi	a0,a0,936 # 800087a0 <etext+0x7a0>
    80006400:	ffffa097          	auipc	ra,0xffffa
    80006404:	160080e7          	jalr	352(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006408:	00002517          	auipc	a0,0x2
    8000640c:	3b850513          	addi	a0,a0,952 # 800087c0 <etext+0x7c0>
    80006410:	ffffa097          	auipc	ra,0xffffa
    80006414:	150080e7          	jalr	336(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006418:	00002517          	auipc	a0,0x2
    8000641c:	3c850513          	addi	a0,a0,968 # 800087e0 <etext+0x7e0>
    80006420:	ffffa097          	auipc	ra,0xffffa
    80006424:	140080e7          	jalr	320(ra) # 80000560 <panic>

0000000080006428 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006428:	7159                	addi	sp,sp,-112
    8000642a:	f486                	sd	ra,104(sp)
    8000642c:	f0a2                	sd	s0,96(sp)
    8000642e:	eca6                	sd	s1,88(sp)
    80006430:	e8ca                	sd	s2,80(sp)
    80006432:	e4ce                	sd	s3,72(sp)
    80006434:	e0d2                	sd	s4,64(sp)
    80006436:	fc56                	sd	s5,56(sp)
    80006438:	f85a                	sd	s6,48(sp)
    8000643a:	f45e                	sd	s7,40(sp)
    8000643c:	f062                	sd	s8,32(sp)
    8000643e:	ec66                	sd	s9,24(sp)
    80006440:	1880                	addi	s0,sp,112
    80006442:	8a2a                	mv	s4,a0
    80006444:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006446:	00c52c83          	lw	s9,12(a0)
    8000644a:	001c9c9b          	slliw	s9,s9,0x1
    8000644e:	1c82                	slli	s9,s9,0x20
    80006450:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006454:	0001e517          	auipc	a0,0x1e
    80006458:	47450513          	addi	a0,a0,1140 # 800248c8 <disk+0x128>
    8000645c:	ffffa097          	auipc	ra,0xffffa
    80006460:	7dc080e7          	jalr	2012(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    80006464:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006466:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006468:	0001eb17          	auipc	s6,0x1e
    8000646c:	338b0b13          	addi	s6,s6,824 # 800247a0 <disk>
  for(int i = 0; i < 3; i++){
    80006470:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006472:	0001ec17          	auipc	s8,0x1e
    80006476:	456c0c13          	addi	s8,s8,1110 # 800248c8 <disk+0x128>
    8000647a:	a0ad                	j	800064e4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000647c:	00fb0733          	add	a4,s6,a5
    80006480:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006484:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006486:	0207c563          	bltz	a5,800064b0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000648a:	2905                	addiw	s2,s2,1
    8000648c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000648e:	05590f63          	beq	s2,s5,800064ec <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006492:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006494:	0001e717          	auipc	a4,0x1e
    80006498:	30c70713          	addi	a4,a4,780 # 800247a0 <disk>
    8000649c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000649e:	01874683          	lbu	a3,24(a4)
    800064a2:	fee9                	bnez	a3,8000647c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800064a4:	2785                	addiw	a5,a5,1
    800064a6:	0705                	addi	a4,a4,1
    800064a8:	fe979be3          	bne	a5,s1,8000649e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800064ac:	57fd                	li	a5,-1
    800064ae:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800064b0:	03205163          	blez	s2,800064d2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800064b4:	f9042503          	lw	a0,-112(s0)
    800064b8:	00000097          	auipc	ra,0x0
    800064bc:	cc2080e7          	jalr	-830(ra) # 8000617a <free_desc>
      for(int j = 0; j < i; j++)
    800064c0:	4785                	li	a5,1
    800064c2:	0127d863          	bge	a5,s2,800064d2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800064c6:	f9442503          	lw	a0,-108(s0)
    800064ca:	00000097          	auipc	ra,0x0
    800064ce:	cb0080e7          	jalr	-848(ra) # 8000617a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800064d2:	85e2                	mv	a1,s8
    800064d4:	0001e517          	auipc	a0,0x1e
    800064d8:	2e450513          	addi	a0,a0,740 # 800247b8 <disk+0x18>
    800064dc:	ffffc097          	auipc	ra,0xffffc
    800064e0:	e1a080e7          	jalr	-486(ra) # 800022f6 <sleep>
  for(int i = 0; i < 3; i++){
    800064e4:	f9040613          	addi	a2,s0,-112
    800064e8:	894e                	mv	s2,s3
    800064ea:	b765                	j	80006492 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064ec:	f9042503          	lw	a0,-112(s0)
    800064f0:	00451693          	slli	a3,a0,0x4

  if(write)
    800064f4:	0001e797          	auipc	a5,0x1e
    800064f8:	2ac78793          	addi	a5,a5,684 # 800247a0 <disk>
    800064fc:	00a50713          	addi	a4,a0,10
    80006500:	0712                	slli	a4,a4,0x4
    80006502:	973e                	add	a4,a4,a5
    80006504:	01703633          	snez	a2,s7
    80006508:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000650a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000650e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006512:	6398                	ld	a4,0(a5)
    80006514:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006516:	0a868613          	addi	a2,a3,168
    8000651a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000651c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000651e:	6390                	ld	a2,0(a5)
    80006520:	00d605b3          	add	a1,a2,a3
    80006524:	4741                	li	a4,16
    80006526:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006528:	4805                	li	a6,1
    8000652a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000652e:	f9442703          	lw	a4,-108(s0)
    80006532:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006536:	0712                	slli	a4,a4,0x4
    80006538:	963a                	add	a2,a2,a4
    8000653a:	058a0593          	addi	a1,s4,88
    8000653e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006540:	0007b883          	ld	a7,0(a5)
    80006544:	9746                	add	a4,a4,a7
    80006546:	40000613          	li	a2,1024
    8000654a:	c710                	sw	a2,8(a4)
  if(write)
    8000654c:	001bb613          	seqz	a2,s7
    80006550:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006554:	00166613          	ori	a2,a2,1
    80006558:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000655c:	f9842583          	lw	a1,-104(s0)
    80006560:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006564:	00250613          	addi	a2,a0,2
    80006568:	0612                	slli	a2,a2,0x4
    8000656a:	963e                	add	a2,a2,a5
    8000656c:	577d                	li	a4,-1
    8000656e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006572:	0592                	slli	a1,a1,0x4
    80006574:	98ae                	add	a7,a7,a1
    80006576:	03068713          	addi	a4,a3,48
    8000657a:	973e                	add	a4,a4,a5
    8000657c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006580:	6398                	ld	a4,0(a5)
    80006582:	972e                	add	a4,a4,a1
    80006584:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006588:	4689                	li	a3,2
    8000658a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000658e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006592:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006596:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000659a:	6794                	ld	a3,8(a5)
    8000659c:	0026d703          	lhu	a4,2(a3)
    800065a0:	8b1d                	andi	a4,a4,7
    800065a2:	0706                	slli	a4,a4,0x1
    800065a4:	96ba                	add	a3,a3,a4
    800065a6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800065aa:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800065ae:	6798                	ld	a4,8(a5)
    800065b0:	00275783          	lhu	a5,2(a4)
    800065b4:	2785                	addiw	a5,a5,1
    800065b6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800065ba:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800065be:	100017b7          	lui	a5,0x10001
    800065c2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800065c6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800065ca:	0001e917          	auipc	s2,0x1e
    800065ce:	2fe90913          	addi	s2,s2,766 # 800248c8 <disk+0x128>
  while(b->disk == 1) {
    800065d2:	4485                	li	s1,1
    800065d4:	01079c63          	bne	a5,a6,800065ec <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800065d8:	85ca                	mv	a1,s2
    800065da:	8552                	mv	a0,s4
    800065dc:	ffffc097          	auipc	ra,0xffffc
    800065e0:	d1a080e7          	jalr	-742(ra) # 800022f6 <sleep>
  while(b->disk == 1) {
    800065e4:	004a2783          	lw	a5,4(s4)
    800065e8:	fe9788e3          	beq	a5,s1,800065d8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800065ec:	f9042903          	lw	s2,-112(s0)
    800065f0:	00290713          	addi	a4,s2,2
    800065f4:	0712                	slli	a4,a4,0x4
    800065f6:	0001e797          	auipc	a5,0x1e
    800065fa:	1aa78793          	addi	a5,a5,426 # 800247a0 <disk>
    800065fe:	97ba                	add	a5,a5,a4
    80006600:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006604:	0001e997          	auipc	s3,0x1e
    80006608:	19c98993          	addi	s3,s3,412 # 800247a0 <disk>
    8000660c:	00491713          	slli	a4,s2,0x4
    80006610:	0009b783          	ld	a5,0(s3)
    80006614:	97ba                	add	a5,a5,a4
    80006616:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000661a:	854a                	mv	a0,s2
    8000661c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006620:	00000097          	auipc	ra,0x0
    80006624:	b5a080e7          	jalr	-1190(ra) # 8000617a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006628:	8885                	andi	s1,s1,1
    8000662a:	f0ed                	bnez	s1,8000660c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000662c:	0001e517          	auipc	a0,0x1e
    80006630:	29c50513          	addi	a0,a0,668 # 800248c8 <disk+0x128>
    80006634:	ffffa097          	auipc	ra,0xffffa
    80006638:	6b8080e7          	jalr	1720(ra) # 80000cec <release>
}
    8000663c:	70a6                	ld	ra,104(sp)
    8000663e:	7406                	ld	s0,96(sp)
    80006640:	64e6                	ld	s1,88(sp)
    80006642:	6946                	ld	s2,80(sp)
    80006644:	69a6                	ld	s3,72(sp)
    80006646:	6a06                	ld	s4,64(sp)
    80006648:	7ae2                	ld	s5,56(sp)
    8000664a:	7b42                	ld	s6,48(sp)
    8000664c:	7ba2                	ld	s7,40(sp)
    8000664e:	7c02                	ld	s8,32(sp)
    80006650:	6ce2                	ld	s9,24(sp)
    80006652:	6165                	addi	sp,sp,112
    80006654:	8082                	ret

0000000080006656 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006656:	1101                	addi	sp,sp,-32
    80006658:	ec06                	sd	ra,24(sp)
    8000665a:	e822                	sd	s0,16(sp)
    8000665c:	e426                	sd	s1,8(sp)
    8000665e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006660:	0001e497          	auipc	s1,0x1e
    80006664:	14048493          	addi	s1,s1,320 # 800247a0 <disk>
    80006668:	0001e517          	auipc	a0,0x1e
    8000666c:	26050513          	addi	a0,a0,608 # 800248c8 <disk+0x128>
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	5c8080e7          	jalr	1480(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006678:	100017b7          	lui	a5,0x10001
    8000667c:	53b8                	lw	a4,96(a5)
    8000667e:	8b0d                	andi	a4,a4,3
    80006680:	100017b7          	lui	a5,0x10001
    80006684:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006686:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000668a:	689c                	ld	a5,16(s1)
    8000668c:	0204d703          	lhu	a4,32(s1)
    80006690:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006694:	04f70863          	beq	a4,a5,800066e4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006698:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000669c:	6898                	ld	a4,16(s1)
    8000669e:	0204d783          	lhu	a5,32(s1)
    800066a2:	8b9d                	andi	a5,a5,7
    800066a4:	078e                	slli	a5,a5,0x3
    800066a6:	97ba                	add	a5,a5,a4
    800066a8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800066aa:	00278713          	addi	a4,a5,2
    800066ae:	0712                	slli	a4,a4,0x4
    800066b0:	9726                	add	a4,a4,s1
    800066b2:	01074703          	lbu	a4,16(a4)
    800066b6:	e721                	bnez	a4,800066fe <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800066b8:	0789                	addi	a5,a5,2
    800066ba:	0792                	slli	a5,a5,0x4
    800066bc:	97a6                	add	a5,a5,s1
    800066be:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800066c0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800066c4:	ffffc097          	auipc	ra,0xffffc
    800066c8:	c96080e7          	jalr	-874(ra) # 8000235a <wakeup>

    disk.used_idx += 1;
    800066cc:	0204d783          	lhu	a5,32(s1)
    800066d0:	2785                	addiw	a5,a5,1
    800066d2:	17c2                	slli	a5,a5,0x30
    800066d4:	93c1                	srli	a5,a5,0x30
    800066d6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800066da:	6898                	ld	a4,16(s1)
    800066dc:	00275703          	lhu	a4,2(a4)
    800066e0:	faf71ce3          	bne	a4,a5,80006698 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800066e4:	0001e517          	auipc	a0,0x1e
    800066e8:	1e450513          	addi	a0,a0,484 # 800248c8 <disk+0x128>
    800066ec:	ffffa097          	auipc	ra,0xffffa
    800066f0:	600080e7          	jalr	1536(ra) # 80000cec <release>
}
    800066f4:	60e2                	ld	ra,24(sp)
    800066f6:	6442                	ld	s0,16(sp)
    800066f8:	64a2                	ld	s1,8(sp)
    800066fa:	6105                	addi	sp,sp,32
    800066fc:	8082                	ret
      panic("virtio_disk_intr status");
    800066fe:	00002517          	auipc	a0,0x2
    80006702:	0fa50513          	addi	a0,a0,250 # 800087f8 <etext+0x7f8>
    80006706:	ffffa097          	auipc	ra,0xffffa
    8000670a:	e5a080e7          	jalr	-422(ra) # 80000560 <panic>
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
