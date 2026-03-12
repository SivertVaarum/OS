
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	48013103          	ld	sp,1152(sp) # 8000b480 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000054:	4a070713          	addi	a4,a4,1184 # 8000b4f0 <timer_scratch>
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
    80000066:	1de78793          	addi	a5,a5,478 # 80006240 <timervec>
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
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9e9f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000a8:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	eee78793          	addi	a5,a5,-274 # 80000f9a <main>
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
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	6ec080e7          	jalr	1772(ra) # 80002816 <either_copyin>
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
    80000190:	4a450513          	addi	a0,a0,1188 # 80013630 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	b6c080e7          	jalr	-1172(ra) # 80000d00 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	49448493          	addi	s1,s1,1172 # 80013630 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	52490913          	addi	s2,s2,1316 # 800136c8 <cons+0x98>
    while (n > 0)
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
        while (cons.r == cons.w)
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
            if (killed(myproc()))
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	a4a080e7          	jalr	-1462(ra) # 80001c06 <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	49c080e7          	jalr	1180(ra) # 80002660 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
            sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	1e6080e7          	jalr	486(ra) # 800023b8 <sleep>
        while (cons.r == cons.w)
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	44870713          	addi	a4,a4,1096 # 80013630 <cons>
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
    8000021e:	5a6080e7          	jalr	1446(ra) # 800027c0 <either_copyout>
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
    8000023a:	3fa50513          	addi	a0,a0,1018 # 80013630 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	b76080e7          	jalr	-1162(ra) # 80000db4 <release>
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
    80000268:	46f72223          	sw	a5,1124(a4) # 800136c8 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
    release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	3b650513          	addi	a0,a0,950 # 80013630 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	b32080e7          	jalr	-1230(ra) # 80000db4 <release>
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
    800002e6:	34e50513          	addi	a0,a0,846 # 80013630 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	a16080e7          	jalr	-1514(ra) # 80000d00 <acquire>

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
    8000030c:	564080e7          	jalr	1380(ra) # 8000286c <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	32050513          	addi	a0,a0,800 # 80013630 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	a9c080e7          	jalr	-1380(ra) # 80000db4 <release>
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
    80000336:	2fe70713          	addi	a4,a4,766 # 80013630 <cons>
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
    80000360:	2d478793          	addi	a5,a5,724 # 80013630 <cons>
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
    8000038e:	33e7a783          	lw	a5,830(a5) # 800136c8 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	29070713          	addi	a4,a4,656 # 80013630 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	28048493          	addi	s1,s1,640 # 80013630 <cons>
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
    800003fa:	23a70713          	addi	a4,a4,570 # 80013630 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
            cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	2cf72223          	sw	a5,708(a4) # 800136d0 <cons+0xa0>
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
    80000436:	1fe78793          	addi	a5,a5,510 # 80013630 <cons>
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
    8000045a:	26c7ab23          	sw	a2,630(a5) # 800136cc <cons+0x9c>
                wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	26a50513          	addi	a0,a0,618 # 800136c8 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	fb6080e7          	jalr	-74(ra) # 8000241c <wakeup>
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
    80000484:	1b050513          	addi	a0,a0,432 # 80013630 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	7e8080e7          	jalr	2024(ra) # 80000c70 <initlock>

    uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	366080e7          	jalr	870(ra) # 800007f6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    80000498:	00023797          	auipc	a5,0x23
    8000049c:	33078793          	addi	a5,a5,816 # 800237c8 <devsw>
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
    800004da:	36a60613          	addi	a2,a2,874 # 80008840 <digits>
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
    80000582:	1607a923          	sw	zero,370(a5) # 800136f0 <pr+0x18>
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
    800005b6:	eef72723          	sw	a5,-274(a4) # 8000b4a0 <panicked>
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
    800005e0:	114d2d03          	lw	s10,276(s10) # 800136f0 <pr+0x18>
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
    8000061e:	226a8a93          	addi	s5,s5,550 # 80008840 <digits>
        switch (c)
    80000622:	07300c13          	li	s8,115
    80000626:	06400d93          	li	s11,100
    8000062a:	a0b1                	j	80000676 <printf+0xba>
        acquire(&pr.lock);
    8000062c:	00013517          	auipc	a0,0x13
    80000630:	0ac50513          	addi	a0,a0,172 # 800136d8 <pr>
    80000634:	00000097          	auipc	ra,0x0
    80000638:	6cc080e7          	jalr	1740(ra) # 80000d00 <acquire>
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
    800007b6:	f2650513          	addi	a0,a0,-218 # 800136d8 <pr>
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	5fa080e7          	jalr	1530(ra) # 80000db4 <release>
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
    800007d2:	f0a48493          	addi	s1,s1,-246 # 800136d8 <pr>
    800007d6:	00008597          	auipc	a1,0x8
    800007da:	86a58593          	addi	a1,a1,-1942 # 80008040 <__func__.1+0x38>
    800007de:	8526                	mv	a0,s1
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	490080e7          	jalr	1168(ra) # 80000c70 <initlock>
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
    8000083e:	ebe50513          	addi	a0,a0,-322 # 800136f8 <uart_tx_lock>
    80000842:	00000097          	auipc	ra,0x0
    80000846:	42e080e7          	jalr	1070(ra) # 80000c70 <initlock>
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
    80000862:	456080e7          	jalr	1110(ra) # 80000cb4 <push_off>

  if(panicked){
    80000866:	0000b797          	auipc	a5,0xb
    8000086a:	c3a7a783          	lw	a5,-966(a5) # 8000b4a0 <panicked>
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
    80000890:	4c8080e7          	jalr	1224(ra) # 80000d54 <pop_off>
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
    800008a4:	c087b783          	ld	a5,-1016(a5) # 8000b4a8 <uart_tx_r>
    800008a8:	0000b717          	auipc	a4,0xb
    800008ac:	c0873703          	ld	a4,-1016(a4) # 8000b4b0 <uart_tx_w>
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
    800008d2:	e2aa8a93          	addi	s5,s5,-470 # 800136f8 <uart_tx_lock>
    uart_tx_r += 1;
    800008d6:	0000b497          	auipc	s1,0xb
    800008da:	bd248493          	addi	s1,s1,-1070 # 8000b4a8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008de:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e2:	0000b997          	auipc	s3,0xb
    800008e6:	bce98993          	addi	s3,s3,-1074 # 8000b4b0 <uart_tx_w>
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
    80000908:	b18080e7          	jalr	-1256(ra) # 8000241c <wakeup>
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
    80000946:	db650513          	addi	a0,a0,-586 # 800136f8 <uart_tx_lock>
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	3b6080e7          	jalr	950(ra) # 80000d00 <acquire>
  if(panicked){
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	b4e7a783          	lw	a5,-1202(a5) # 8000b4a0 <panicked>
    8000095a:	e7c9                	bnez	a5,800009e4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095c:	0000b717          	auipc	a4,0xb
    80000960:	b5473703          	ld	a4,-1196(a4) # 8000b4b0 <uart_tx_w>
    80000964:	0000b797          	auipc	a5,0xb
    80000968:	b447b783          	ld	a5,-1212(a5) # 8000b4a8 <uart_tx_r>
    8000096c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000970:	00013997          	auipc	s3,0x13
    80000974:	d8898993          	addi	s3,s3,-632 # 800136f8 <uart_tx_lock>
    80000978:	0000b497          	auipc	s1,0xb
    8000097c:	b3048493          	addi	s1,s1,-1232 # 8000b4a8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000980:	0000b917          	auipc	s2,0xb
    80000984:	b3090913          	addi	s2,s2,-1232 # 8000b4b0 <uart_tx_w>
    80000988:	00e79f63          	bne	a5,a4,800009a6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000098c:	85ce                	mv	a1,s3
    8000098e:	8526                	mv	a0,s1
    80000990:	00002097          	auipc	ra,0x2
    80000994:	a28080e7          	jalr	-1496(ra) # 800023b8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000998:	00093703          	ld	a4,0(s2)
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	02078793          	addi	a5,a5,32
    800009a2:	fee785e3          	beq	a5,a4,8000098c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a6:	00013497          	auipc	s1,0x13
    800009aa:	d5248493          	addi	s1,s1,-686 # 800136f8 <uart_tx_lock>
    800009ae:	01f77793          	andi	a5,a4,31
    800009b2:	97a6                	add	a5,a5,s1
    800009b4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009b8:	0705                	addi	a4,a4,1
    800009ba:	0000b797          	auipc	a5,0xb
    800009be:	aee7bb23          	sd	a4,-1290(a5) # 8000b4b0 <uart_tx_w>
  uartstart();
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	ede080e7          	jalr	-290(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	3e8080e7          	jalr	1000(ra) # 80000db4 <release>
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
    80000a32:	cca48493          	addi	s1,s1,-822 # 800136f8 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	2c8080e7          	jalr	712(ra) # 80000d00 <acquire>
  uartstart();
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	e60080e7          	jalr	-416(ra) # 800008a0 <uartstart>
  release(&uart_tx_lock);
    80000a48:	8526                	mv	a0,s1
    80000a4a:	00000097          	auipc	ra,0x0
    80000a4e:	36a080e7          	jalr	874(ra) # 80000db4 <release>
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
    80000a68:	84aa                	mv	s1,a0
    if (MAX_PAGES != 0)
    80000a6a:	0000b797          	auipc	a5,0xb
    80000a6e:	a567b783          	ld	a5,-1450(a5) # 8000b4c0 <MAX_PAGES>
    80000a72:	c799                	beqz	a5,80000a80 <kfree+0x24>
        assert(FREE_PAGES < MAX_PAGES);
    80000a74:	0000b717          	auipc	a4,0xb
    80000a78:	a4473703          	ld	a4,-1468(a4) # 8000b4b8 <FREE_PAGES>
    80000a7c:	06f77663          	bgeu	a4,a5,80000ae8 <kfree+0x8c>
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a80:	03449793          	slli	a5,s1,0x34
    80000a84:	efc1                	bnez	a5,80000b1c <kfree+0xc0>
    80000a86:	00024797          	auipc	a5,0x24
    80000a8a:	eda78793          	addi	a5,a5,-294 # 80024960 <end>
    80000a8e:	08f4e763          	bltu	s1,a5,80000b1c <kfree+0xc0>
    80000a92:	47c5                	li	a5,17
    80000a94:	07ee                	slli	a5,a5,0x1b
    80000a96:	08f4f363          	bgeu	s1,a5,80000b1c <kfree+0xc0>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    80000a9a:	6605                	lui	a2,0x1
    80000a9c:	4585                	li	a1,1
    80000a9e:	8526                	mv	a0,s1
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	35c080e7          	jalr	860(ra) # 80000dfc <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000aa8:	00013917          	auipc	s2,0x13
    80000aac:	c8890913          	addi	s2,s2,-888 # 80013730 <kmem>
    80000ab0:	854a                	mv	a0,s2
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	24e080e7          	jalr	590(ra) # 80000d00 <acquire>
    r->next = kmem.freelist;
    80000aba:	01893783          	ld	a5,24(s2)
    80000abe:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000ac0:	00993c23          	sd	s1,24(s2)
    FREE_PAGES++;
    80000ac4:	0000b717          	auipc	a4,0xb
    80000ac8:	9f470713          	addi	a4,a4,-1548 # 8000b4b8 <FREE_PAGES>
    80000acc:	631c                	ld	a5,0(a4)
    80000ace:	0785                	addi	a5,a5,1
    80000ad0:	e31c                	sd	a5,0(a4)
    release(&kmem.lock);
    80000ad2:	854a                	mv	a0,s2
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	2e0080e7          	jalr	736(ra) # 80000db4 <release>
}
    80000adc:	60e2                	ld	ra,24(sp)
    80000ade:	6442                	ld	s0,16(sp)
    80000ae0:	64a2                	ld	s1,8(sp)
    80000ae2:	6902                	ld	s2,0(sp)
    80000ae4:	6105                	addi	sp,sp,32
    80000ae6:	8082                	ret
        assert(FREE_PAGES < MAX_PAGES);
    80000ae8:	03700693          	li	a3,55
    80000aec:	00007617          	auipc	a2,0x7
    80000af0:	51c60613          	addi	a2,a2,1308 # 80008008 <__func__.1>
    80000af4:	00007597          	auipc	a1,0x7
    80000af8:	55c58593          	addi	a1,a1,1372 # 80008050 <__func__.1+0x48>
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	56450513          	addi	a0,a0,1380 # 80008060 <__func__.1+0x58>
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	ab8080e7          	jalr	-1352(ra) # 800005bc <printf>
    80000b0c:	00007517          	auipc	a0,0x7
    80000b10:	56450513          	addi	a0,a0,1380 # 80008070 <__func__.1+0x68>
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	a4c080e7          	jalr	-1460(ra) # 80000560 <panic>
        panic("kfree");
    80000b1c:	00007517          	auipc	a0,0x7
    80000b20:	56450513          	addi	a0,a0,1380 # 80008080 <__func__.1+0x78>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	a3c080e7          	jalr	-1476(ra) # 80000560 <panic>

0000000080000b2c <freerange>:
{
    80000b2c:	7179                	addi	sp,sp,-48
    80000b2e:	f406                	sd	ra,40(sp)
    80000b30:	f022                	sd	s0,32(sp)
    80000b32:	ec26                	sd	s1,24(sp)
    80000b34:	1800                	addi	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000b36:	6785                	lui	a5,0x1
    80000b38:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b3c:	00e504b3          	add	s1,a0,a4
    80000b40:	777d                	lui	a4,0xfffff
    80000b42:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b44:	94be                	add	s1,s1,a5
    80000b46:	0295e463          	bltu	a1,s1,80000b6e <freerange+0x42>
    80000b4a:	e84a                	sd	s2,16(sp)
    80000b4c:	e44e                	sd	s3,8(sp)
    80000b4e:	e052                	sd	s4,0(sp)
    80000b50:	892e                	mv	s2,a1
        kfree(p);
    80000b52:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b54:	6985                	lui	s3,0x1
        kfree(p);
    80000b56:	01448533          	add	a0,s1,s4
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	f02080e7          	jalr	-254(ra) # 80000a5c <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000b62:	94ce                	add	s1,s1,s3
    80000b64:	fe9979e3          	bgeu	s2,s1,80000b56 <freerange+0x2a>
    80000b68:	6942                	ld	s2,16(sp)
    80000b6a:	69a2                	ld	s3,8(sp)
    80000b6c:	6a02                	ld	s4,0(sp)
}
    80000b6e:	70a2                	ld	ra,40(sp)
    80000b70:	7402                	ld	s0,32(sp)
    80000b72:	64e2                	ld	s1,24(sp)
    80000b74:	6145                	addi	sp,sp,48
    80000b76:	8082                	ret

0000000080000b78 <kinit>:
{
    80000b78:	1141                	addi	sp,sp,-16
    80000b7a:	e406                	sd	ra,8(sp)
    80000b7c:	e022                	sd	s0,0(sp)
    80000b7e:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000b80:	00007597          	auipc	a1,0x7
    80000b84:	50858593          	addi	a1,a1,1288 # 80008088 <__func__.1+0x80>
    80000b88:	00013517          	auipc	a0,0x13
    80000b8c:	ba850513          	addi	a0,a0,-1112 # 80013730 <kmem>
    80000b90:	00000097          	auipc	ra,0x0
    80000b94:	0e0080e7          	jalr	224(ra) # 80000c70 <initlock>
    freerange(end, (void *)PHYSTOP);
    80000b98:	45c5                	li	a1,17
    80000b9a:	05ee                	slli	a1,a1,0x1b
    80000b9c:	00024517          	auipc	a0,0x24
    80000ba0:	dc450513          	addi	a0,a0,-572 # 80024960 <end>
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	f88080e7          	jalr	-120(ra) # 80000b2c <freerange>
    MAX_PAGES = FREE_PAGES;
    80000bac:	0000b797          	auipc	a5,0xb
    80000bb0:	90c7b783          	ld	a5,-1780(a5) # 8000b4b8 <FREE_PAGES>
    80000bb4:	0000b717          	auipc	a4,0xb
    80000bb8:	90f73623          	sd	a5,-1780(a4) # 8000b4c0 <MAX_PAGES>
}
    80000bbc:	60a2                	ld	ra,8(sp)
    80000bbe:	6402                	ld	s0,0(sp)
    80000bc0:	0141                	addi	sp,sp,16
    80000bc2:	8082                	ret

0000000080000bc4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000bc4:	1101                	addi	sp,sp,-32
    80000bc6:	ec06                	sd	ra,24(sp)
    80000bc8:	e822                	sd	s0,16(sp)
    80000bca:	e426                	sd	s1,8(sp)
    80000bcc:	1000                	addi	s0,sp,32
    assert(FREE_PAGES > 0);
    80000bce:	0000b797          	auipc	a5,0xb
    80000bd2:	8ea7b783          	ld	a5,-1814(a5) # 8000b4b8 <FREE_PAGES>
    80000bd6:	cbb1                	beqz	a5,80000c2a <kalloc+0x66>
    struct run *r;

    acquire(&kmem.lock);
    80000bd8:	00013497          	auipc	s1,0x13
    80000bdc:	b5848493          	addi	s1,s1,-1192 # 80013730 <kmem>
    80000be0:	8526                	mv	a0,s1
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	11e080e7          	jalr	286(ra) # 80000d00 <acquire>
    r = kmem.freelist;
    80000bea:	6c84                	ld	s1,24(s1)
    if (r)
    80000bec:	c8ad                	beqz	s1,80000c5e <kalloc+0x9a>
        kmem.freelist = r->next;
    80000bee:	609c                	ld	a5,0(s1)
    80000bf0:	00013517          	auipc	a0,0x13
    80000bf4:	b4050513          	addi	a0,a0,-1216 # 80013730 <kmem>
    80000bf8:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000bfa:	00000097          	auipc	ra,0x0
    80000bfe:	1ba080e7          	jalr	442(ra) # 80000db4 <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000c02:	6605                	lui	a2,0x1
    80000c04:	4595                	li	a1,5
    80000c06:	8526                	mv	a0,s1
    80000c08:	00000097          	auipc	ra,0x0
    80000c0c:	1f4080e7          	jalr	500(ra) # 80000dfc <memset>
    FREE_PAGES--;
    80000c10:	0000b717          	auipc	a4,0xb
    80000c14:	8a870713          	addi	a4,a4,-1880 # 8000b4b8 <FREE_PAGES>
    80000c18:	631c                	ld	a5,0(a4)
    80000c1a:	17fd                	addi	a5,a5,-1
    80000c1c:	e31c                	sd	a5,0(a4)
    return (void *)r;
}
    80000c1e:	8526                	mv	a0,s1
    80000c20:	60e2                	ld	ra,24(sp)
    80000c22:	6442                	ld	s0,16(sp)
    80000c24:	64a2                	ld	s1,8(sp)
    80000c26:	6105                	addi	sp,sp,32
    80000c28:	8082                	ret
    assert(FREE_PAGES > 0);
    80000c2a:	04f00693          	li	a3,79
    80000c2e:	00007617          	auipc	a2,0x7
    80000c32:	3d260613          	addi	a2,a2,978 # 80008000 <etext>
    80000c36:	00007597          	auipc	a1,0x7
    80000c3a:	41a58593          	addi	a1,a1,1050 # 80008050 <__func__.1+0x48>
    80000c3e:	00007517          	auipc	a0,0x7
    80000c42:	42250513          	addi	a0,a0,1058 # 80008060 <__func__.1+0x58>
    80000c46:	00000097          	auipc	ra,0x0
    80000c4a:	976080e7          	jalr	-1674(ra) # 800005bc <printf>
    80000c4e:	00007517          	auipc	a0,0x7
    80000c52:	42250513          	addi	a0,a0,1058 # 80008070 <__func__.1+0x68>
    80000c56:	00000097          	auipc	ra,0x0
    80000c5a:	90a080e7          	jalr	-1782(ra) # 80000560 <panic>
    release(&kmem.lock);
    80000c5e:	00013517          	auipc	a0,0x13
    80000c62:	ad250513          	addi	a0,a0,-1326 # 80013730 <kmem>
    80000c66:	00000097          	auipc	ra,0x0
    80000c6a:	14e080e7          	jalr	334(ra) # 80000db4 <release>
    if (r)
    80000c6e:	b74d                	j	80000c10 <kalloc+0x4c>

0000000080000c70 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c70:	1141                	addi	sp,sp,-16
    80000c72:	e422                	sd	s0,8(sp)
    80000c74:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c76:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c78:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c7c:	00053823          	sd	zero,16(a0)
}
    80000c80:	6422                	ld	s0,8(sp)
    80000c82:	0141                	addi	sp,sp,16
    80000c84:	8082                	ret

0000000080000c86 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c86:	411c                	lw	a5,0(a0)
    80000c88:	e399                	bnez	a5,80000c8e <holding+0x8>
    80000c8a:	4501                	li	a0,0
  return r;
}
    80000c8c:	8082                	ret
{
    80000c8e:	1101                	addi	sp,sp,-32
    80000c90:	ec06                	sd	ra,24(sp)
    80000c92:	e822                	sd	s0,16(sp)
    80000c94:	e426                	sd	s1,8(sp)
    80000c96:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c98:	6904                	ld	s1,16(a0)
    80000c9a:	00001097          	auipc	ra,0x1
    80000c9e:	f50080e7          	jalr	-176(ra) # 80001bea <mycpu>
    80000ca2:	40a48533          	sub	a0,s1,a0
    80000ca6:	00153513          	seqz	a0,a0
}
    80000caa:	60e2                	ld	ra,24(sp)
    80000cac:	6442                	ld	s0,16(sp)
    80000cae:	64a2                	ld	s1,8(sp)
    80000cb0:	6105                	addi	sp,sp,32
    80000cb2:	8082                	ret

0000000080000cb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cb4:	1101                	addi	sp,sp,-32
    80000cb6:	ec06                	sd	ra,24(sp)
    80000cb8:	e822                	sd	s0,16(sp)
    80000cba:	e426                	sd	s1,8(sp)
    80000cbc:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000cbe:	100024f3          	csrr	s1,sstatus
    80000cc2:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000cc6:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000cc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ccc:	00001097          	auipc	ra,0x1
    80000cd0:	f1e080e7          	jalr	-226(ra) # 80001bea <mycpu>
    80000cd4:	5d3c                	lw	a5,120(a0)
    80000cd6:	cf89                	beqz	a5,80000cf0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000cd8:	00001097          	auipc	ra,0x1
    80000cdc:	f12080e7          	jalr	-238(ra) # 80001bea <mycpu>
    80000ce0:	5d3c                	lw	a5,120(a0)
    80000ce2:	2785                	addiw	a5,a5,1
    80000ce4:	dd3c                	sw	a5,120(a0)
}
    80000ce6:	60e2                	ld	ra,24(sp)
    80000ce8:	6442                	ld	s0,16(sp)
    80000cea:	64a2                	ld	s1,8(sp)
    80000cec:	6105                	addi	sp,sp,32
    80000cee:	8082                	ret
    mycpu()->intena = old;
    80000cf0:	00001097          	auipc	ra,0x1
    80000cf4:	efa080e7          	jalr	-262(ra) # 80001bea <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000cf8:	8085                	srli	s1,s1,0x1
    80000cfa:	8885                	andi	s1,s1,1
    80000cfc:	dd64                	sw	s1,124(a0)
    80000cfe:	bfe9                	j	80000cd8 <push_off+0x24>

0000000080000d00 <acquire>:
{
    80000d00:	1101                	addi	sp,sp,-32
    80000d02:	ec06                	sd	ra,24(sp)
    80000d04:	e822                	sd	s0,16(sp)
    80000d06:	e426                	sd	s1,8(sp)
    80000d08:	1000                	addi	s0,sp,32
    80000d0a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d0c:	00000097          	auipc	ra,0x0
    80000d10:	fa8080e7          	jalr	-88(ra) # 80000cb4 <push_off>
  if(holding(lk))
    80000d14:	8526                	mv	a0,s1
    80000d16:	00000097          	auipc	ra,0x0
    80000d1a:	f70080e7          	jalr	-144(ra) # 80000c86 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d1e:	4705                	li	a4,1
  if(holding(lk))
    80000d20:	e115                	bnez	a0,80000d44 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d22:	87ba                	mv	a5,a4
    80000d24:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d28:	2781                	sext.w	a5,a5
    80000d2a:	ffe5                	bnez	a5,80000d22 <acquire+0x22>
  __sync_synchronize();
    80000d2c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000d30:	00001097          	auipc	ra,0x1
    80000d34:	eba080e7          	jalr	-326(ra) # 80001bea <mycpu>
    80000d38:	e888                	sd	a0,16(s1)
}
    80000d3a:	60e2                	ld	ra,24(sp)
    80000d3c:	6442                	ld	s0,16(sp)
    80000d3e:	64a2                	ld	s1,8(sp)
    80000d40:	6105                	addi	sp,sp,32
    80000d42:	8082                	ret
    panic("acquire");
    80000d44:	00007517          	auipc	a0,0x7
    80000d48:	34c50513          	addi	a0,a0,844 # 80008090 <__func__.1+0x88>
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	814080e7          	jalr	-2028(ra) # 80000560 <panic>

0000000080000d54 <pop_off>:

void
pop_off(void)
{
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e406                	sd	ra,8(sp)
    80000d58:	e022                	sd	s0,0(sp)
    80000d5a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d5c:	00001097          	auipc	ra,0x1
    80000d60:	e8e080e7          	jalr	-370(ra) # 80001bea <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d64:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000d68:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d6a:	e78d                	bnez	a5,80000d94 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d6c:	5d3c                	lw	a5,120(a0)
    80000d6e:	02f05b63          	blez	a5,80000da4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d72:	37fd                	addiw	a5,a5,-1
    80000d74:	0007871b          	sext.w	a4,a5
    80000d78:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d7a:	eb09                	bnez	a4,80000d8c <pop_off+0x38>
    80000d7c:	5d7c                	lw	a5,124(a0)
    80000d7e:	c799                	beqz	a5,80000d8c <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d80:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d84:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000d88:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret
    panic("pop_off - interruptible");
    80000d94:	00007517          	auipc	a0,0x7
    80000d98:	30450513          	addi	a0,a0,772 # 80008098 <__func__.1+0x90>
    80000d9c:	fffff097          	auipc	ra,0xfffff
    80000da0:	7c4080e7          	jalr	1988(ra) # 80000560 <panic>
    panic("pop_off");
    80000da4:	00007517          	auipc	a0,0x7
    80000da8:	30c50513          	addi	a0,a0,780 # 800080b0 <__func__.1+0xa8>
    80000dac:	fffff097          	auipc	ra,0xfffff
    80000db0:	7b4080e7          	jalr	1972(ra) # 80000560 <panic>

0000000080000db4 <release>:
{
    80000db4:	1101                	addi	sp,sp,-32
    80000db6:	ec06                	sd	ra,24(sp)
    80000db8:	e822                	sd	s0,16(sp)
    80000dba:	e426                	sd	s1,8(sp)
    80000dbc:	1000                	addi	s0,sp,32
    80000dbe:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000dc0:	00000097          	auipc	ra,0x0
    80000dc4:	ec6080e7          	jalr	-314(ra) # 80000c86 <holding>
    80000dc8:	c115                	beqz	a0,80000dec <release+0x38>
  lk->cpu = 0;
    80000dca:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000dce:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000dd2:	0310000f          	fence	rw,w
    80000dd6:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000dda:	00000097          	auipc	ra,0x0
    80000dde:	f7a080e7          	jalr	-134(ra) # 80000d54 <pop_off>
}
    80000de2:	60e2                	ld	ra,24(sp)
    80000de4:	6442                	ld	s0,16(sp)
    80000de6:	64a2                	ld	s1,8(sp)
    80000de8:	6105                	addi	sp,sp,32
    80000dea:	8082                	ret
    panic("release");
    80000dec:	00007517          	auipc	a0,0x7
    80000df0:	2cc50513          	addi	a0,a0,716 # 800080b8 <__func__.1+0xb0>
    80000df4:	fffff097          	auipc	ra,0xfffff
    80000df8:	76c080e7          	jalr	1900(ra) # 80000560 <panic>

0000000080000dfc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000dfc:	1141                	addi	sp,sp,-16
    80000dfe:	e422                	sd	s0,8(sp)
    80000e00:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e02:	ca19                	beqz	a2,80000e18 <memset+0x1c>
    80000e04:	87aa                	mv	a5,a0
    80000e06:	1602                	slli	a2,a2,0x20
    80000e08:	9201                	srli	a2,a2,0x20
    80000e0a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e0e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e12:	0785                	addi	a5,a5,1
    80000e14:	fee79de3          	bne	a5,a4,80000e0e <memset+0x12>
  }
  return dst;
}
    80000e18:	6422                	ld	s0,8(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e24:	ca05                	beqz	a2,80000e54 <memcmp+0x36>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	0685                	addi	a3,a3,1
    80000e30:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e32:	00054783          	lbu	a5,0(a0)
    80000e36:	0005c703          	lbu	a4,0(a1)
    80000e3a:	00e79863          	bne	a5,a4,80000e4a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e3e:	0505                	addi	a0,a0,1
    80000e40:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e42:	fed518e3          	bne	a0,a3,80000e32 <memcmp+0x14>
  }

  return 0;
    80000e46:	4501                	li	a0,0
    80000e48:	a019                	j	80000e4e <memcmp+0x30>
      return *s1 - *s2;
    80000e4a:	40e7853b          	subw	a0,a5,a4
}
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret
  return 0;
    80000e54:	4501                	li	a0,0
    80000e56:	bfe5                	j	80000e4e <memcmp+0x30>

0000000080000e58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e58:	1141                	addi	sp,sp,-16
    80000e5a:	e422                	sd	s0,8(sp)
    80000e5c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e5e:	c205                	beqz	a2,80000e7e <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e60:	02a5e263          	bltu	a1,a0,80000e84 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e64:	1602                	slli	a2,a2,0x20
    80000e66:	9201                	srli	a2,a2,0x20
    80000e68:	00c587b3          	add	a5,a1,a2
{
    80000e6c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e6e:	0585                	addi	a1,a1,1
    80000e70:	0705                	addi	a4,a4,1
    80000e72:	fff5c683          	lbu	a3,-1(a1)
    80000e76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e7a:	feb79ae3          	bne	a5,a1,80000e6e <memmove+0x16>

  return dst;
}
    80000e7e:	6422                	ld	s0,8(sp)
    80000e80:	0141                	addi	sp,sp,16
    80000e82:	8082                	ret
  if(s < d && s + n > d){
    80000e84:	02061693          	slli	a3,a2,0x20
    80000e88:	9281                	srli	a3,a3,0x20
    80000e8a:	00d58733          	add	a4,a1,a3
    80000e8e:	fce57be3          	bgeu	a0,a4,80000e64 <memmove+0xc>
    d += n;
    80000e92:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e94:	fff6079b          	addiw	a5,a2,-1
    80000e98:	1782                	slli	a5,a5,0x20
    80000e9a:	9381                	srli	a5,a5,0x20
    80000e9c:	fff7c793          	not	a5,a5
    80000ea0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000ea2:	177d                	addi	a4,a4,-1
    80000ea4:	16fd                	addi	a3,a3,-1
    80000ea6:	00074603          	lbu	a2,0(a4)
    80000eaa:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000eae:	fef71ae3          	bne	a4,a5,80000ea2 <memmove+0x4a>
    80000eb2:	b7f1                	j	80000e7e <memmove+0x26>

0000000080000eb4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	f9c080e7          	jalr	-100(ra) # 80000e58 <memmove>
}
    80000ec4:	60a2                	ld	ra,8(sp)
    80000ec6:	6402                	ld	s0,0(sp)
    80000ec8:	0141                	addi	sp,sp,16
    80000eca:	8082                	ret

0000000080000ecc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000ecc:	1141                	addi	sp,sp,-16
    80000ece:	e422                	sd	s0,8(sp)
    80000ed0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ed2:	ce11                	beqz	a2,80000eee <strncmp+0x22>
    80000ed4:	00054783          	lbu	a5,0(a0)
    80000ed8:	cf89                	beqz	a5,80000ef2 <strncmp+0x26>
    80000eda:	0005c703          	lbu	a4,0(a1)
    80000ede:	00f71a63          	bne	a4,a5,80000ef2 <strncmp+0x26>
    n--, p++, q++;
    80000ee2:	367d                	addiw	a2,a2,-1
    80000ee4:	0505                	addi	a0,a0,1
    80000ee6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000ee8:	f675                	bnez	a2,80000ed4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000eea:	4501                	li	a0,0
    80000eec:	a801                	j	80000efc <strncmp+0x30>
    80000eee:	4501                	li	a0,0
    80000ef0:	a031                	j	80000efc <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000ef2:	00054503          	lbu	a0,0(a0)
    80000ef6:	0005c783          	lbu	a5,0(a1)
    80000efa:	9d1d                	subw	a0,a0,a5
}
    80000efc:	6422                	ld	s0,8(sp)
    80000efe:	0141                	addi	sp,sp,16
    80000f00:	8082                	ret

0000000080000f02 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f02:	1141                	addi	sp,sp,-16
    80000f04:	e422                	sd	s0,8(sp)
    80000f06:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f08:	87aa                	mv	a5,a0
    80000f0a:	86b2                	mv	a3,a2
    80000f0c:	367d                	addiw	a2,a2,-1
    80000f0e:	02d05563          	blez	a3,80000f38 <strncpy+0x36>
    80000f12:	0785                	addi	a5,a5,1
    80000f14:	0005c703          	lbu	a4,0(a1)
    80000f18:	fee78fa3          	sb	a4,-1(a5)
    80000f1c:	0585                	addi	a1,a1,1
    80000f1e:	f775                	bnez	a4,80000f0a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f20:	873e                	mv	a4,a5
    80000f22:	9fb5                	addw	a5,a5,a3
    80000f24:	37fd                	addiw	a5,a5,-1
    80000f26:	00c05963          	blez	a2,80000f38 <strncpy+0x36>
    *s++ = 0;
    80000f2a:	0705                	addi	a4,a4,1
    80000f2c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f30:	40e786bb          	subw	a3,a5,a4
    80000f34:	fed04be3          	bgtz	a3,80000f2a <strncpy+0x28>
  return os;
}
    80000f38:	6422                	ld	s0,8(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e422                	sd	s0,8(sp)
    80000f42:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f44:	02c05363          	blez	a2,80000f6a <safestrcpy+0x2c>
    80000f48:	fff6069b          	addiw	a3,a2,-1
    80000f4c:	1682                	slli	a3,a3,0x20
    80000f4e:	9281                	srli	a3,a3,0x20
    80000f50:	96ae                	add	a3,a3,a1
    80000f52:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f54:	00d58963          	beq	a1,a3,80000f66 <safestrcpy+0x28>
    80000f58:	0585                	addi	a1,a1,1
    80000f5a:	0785                	addi	a5,a5,1
    80000f5c:	fff5c703          	lbu	a4,-1(a1)
    80000f60:	fee78fa3          	sb	a4,-1(a5)
    80000f64:	fb65                	bnez	a4,80000f54 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f66:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f6a:	6422                	ld	s0,8(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret

0000000080000f70 <strlen>:

int
strlen(const char *s)
{
    80000f70:	1141                	addi	sp,sp,-16
    80000f72:	e422                	sd	s0,8(sp)
    80000f74:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f76:	00054783          	lbu	a5,0(a0)
    80000f7a:	cf91                	beqz	a5,80000f96 <strlen+0x26>
    80000f7c:	0505                	addi	a0,a0,1
    80000f7e:	87aa                	mv	a5,a0
    80000f80:	86be                	mv	a3,a5
    80000f82:	0785                	addi	a5,a5,1
    80000f84:	fff7c703          	lbu	a4,-1(a5)
    80000f88:	ff65                	bnez	a4,80000f80 <strlen+0x10>
    80000f8a:	40a6853b          	subw	a0,a3,a0
    80000f8e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000f90:	6422                	ld	s0,8(sp)
    80000f92:	0141                	addi	sp,sp,16
    80000f94:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f96:	4501                	li	a0,0
    80000f98:	bfe5                	j	80000f90 <strlen+0x20>

0000000080000f9a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f9a:	1141                	addi	sp,sp,-16
    80000f9c:	e406                	sd	ra,8(sp)
    80000f9e:	e022                	sd	s0,0(sp)
    80000fa0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fa2:	00001097          	auipc	ra,0x1
    80000fa6:	c38080e7          	jalr	-968(ra) # 80001bda <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000faa:	0000a717          	auipc	a4,0xa
    80000fae:	51e70713          	addi	a4,a4,1310 # 8000b4c8 <started>
  if(cpuid() == 0){
    80000fb2:	c139                	beqz	a0,80000ff8 <main+0x5e>
    while(started == 0)
    80000fb4:	431c                	lw	a5,0(a4)
    80000fb6:	2781                	sext.w	a5,a5
    80000fb8:	dff5                	beqz	a5,80000fb4 <main+0x1a>
      ;
    __sync_synchronize();
    80000fba:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000fbe:	00001097          	auipc	ra,0x1
    80000fc2:	c1c080e7          	jalr	-996(ra) # 80001bda <cpuid>
    80000fc6:	85aa                	mv	a1,a0
    80000fc8:	00007517          	auipc	a0,0x7
    80000fcc:	11050513          	addi	a0,a0,272 # 800080d8 <__func__.1+0xd0>
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	5ec080e7          	jalr	1516(ra) # 800005bc <printf>
    kvminithart();    // turn on paging
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	0d8080e7          	jalr	216(ra) # 800010b0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000fe0:	00002097          	auipc	ra,0x2
    80000fe4:	ab0080e7          	jalr	-1360(ra) # 80002a90 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000fe8:	00005097          	auipc	ra,0x5
    80000fec:	29c080e7          	jalr	668(ra) # 80006284 <plicinithart>
  }

  scheduler();        
    80000ff0:	00001097          	auipc	ra,0x1
    80000ff4:	2a6080e7          	jalr	678(ra) # 80002296 <scheduler>
    consoleinit();
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	478080e7          	jalr	1144(ra) # 80000470 <consoleinit>
    printfinit();
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	7c4080e7          	jalr	1988(ra) # 800007c4 <printfinit>
    printf("\n");
    80001008:	00007517          	auipc	a0,0x7
    8000100c:	01850513          	addi	a0,a0,24 # 80008020 <__func__.1+0x18>
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	5ac080e7          	jalr	1452(ra) # 800005bc <printf>
    printf("xv6 kernel is booting\n");
    80001018:	00007517          	auipc	a0,0x7
    8000101c:	0a850513          	addi	a0,a0,168 # 800080c0 <__func__.1+0xb8>
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	59c080e7          	jalr	1436(ra) # 800005bc <printf>
    printf("\n");
    80001028:	00007517          	auipc	a0,0x7
    8000102c:	ff850513          	addi	a0,a0,-8 # 80008020 <__func__.1+0x18>
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	58c080e7          	jalr	1420(ra) # 800005bc <printf>
    kinit();         // physical page allocator
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	b40080e7          	jalr	-1216(ra) # 80000b78 <kinit>
    kvminit();       // create kernel page table
    80001040:	00000097          	auipc	ra,0x0
    80001044:	326080e7          	jalr	806(ra) # 80001366 <kvminit>
    kvminithart();   // turn on paging
    80001048:	00000097          	auipc	ra,0x0
    8000104c:	068080e7          	jalr	104(ra) # 800010b0 <kvminithart>
    procinit();      // process table
    80001050:	00001097          	auipc	ra,0x1
    80001054:	aa4080e7          	jalr	-1372(ra) # 80001af4 <procinit>
    trapinit();      // trap vectors
    80001058:	00002097          	auipc	ra,0x2
    8000105c:	a10080e7          	jalr	-1520(ra) # 80002a68 <trapinit>
    trapinithart();  // install kernel trap vector
    80001060:	00002097          	auipc	ra,0x2
    80001064:	a30080e7          	jalr	-1488(ra) # 80002a90 <trapinithart>
    plicinit();      // set up interrupt controller
    80001068:	00005097          	auipc	ra,0x5
    8000106c:	202080e7          	jalr	514(ra) # 8000626a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001070:	00005097          	auipc	ra,0x5
    80001074:	214080e7          	jalr	532(ra) # 80006284 <plicinithart>
    binit();         // buffer cache
    80001078:	00002097          	auipc	ra,0x2
    8000107c:	2d8080e7          	jalr	728(ra) # 80003350 <binit>
    iinit();         // inode table
    80001080:	00003097          	auipc	ra,0x3
    80001084:	98e080e7          	jalr	-1650(ra) # 80003a0e <iinit>
    fileinit();      // file table
    80001088:	00004097          	auipc	ra,0x4
    8000108c:	93e080e7          	jalr	-1730(ra) # 800049c6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001090:	00005097          	auipc	ra,0x5
    80001094:	2fc080e7          	jalr	764(ra) # 8000638c <virtio_disk_init>
    userinit();      // first user process
    80001098:	00001097          	auipc	ra,0x1
    8000109c:	e46080e7          	jalr	-442(ra) # 80001ede <userinit>
    __sync_synchronize();
    800010a0:	0330000f          	fence	rw,rw
    started = 1;
    800010a4:	4785                	li	a5,1
    800010a6:	0000a717          	auipc	a4,0xa
    800010aa:	42f72123          	sw	a5,1058(a4) # 8000b4c8 <started>
    800010ae:	b789                	j	80000ff0 <main+0x56>

00000000800010b0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800010b0:	1141                	addi	sp,sp,-16
    800010b2:	e422                	sd	s0,8(sp)
    800010b4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    800010b6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800010ba:	0000a797          	auipc	a5,0xa
    800010be:	4167b783          	ld	a5,1046(a5) # 8000b4d0 <kernel_pagetable>
    800010c2:	83b1                	srli	a5,a5,0xc
    800010c4:	577d                	li	a4,-1
    800010c6:	177e                	slli	a4,a4,0x3f
    800010c8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    800010ca:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    800010ce:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010d2:	6422                	ld	s0,8(sp)
    800010d4:	0141                	addi	sp,sp,16
    800010d6:	8082                	ret

00000000800010d8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010d8:	7139                	addi	sp,sp,-64
    800010da:	fc06                	sd	ra,56(sp)
    800010dc:	f822                	sd	s0,48(sp)
    800010de:	f426                	sd	s1,40(sp)
    800010e0:	f04a                	sd	s2,32(sp)
    800010e2:	ec4e                	sd	s3,24(sp)
    800010e4:	e852                	sd	s4,16(sp)
    800010e6:	e456                	sd	s5,8(sp)
    800010e8:	e05a                	sd	s6,0(sp)
    800010ea:	0080                	addi	s0,sp,64
    800010ec:	84aa                	mv	s1,a0
    800010ee:	89ae                	mv	s3,a1
    800010f0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010f2:	57fd                	li	a5,-1
    800010f4:	83e9                	srli	a5,a5,0x1a
    800010f6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010f8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010fa:	04b7f263          	bgeu	a5,a1,8000113e <walk+0x66>
    panic("walk");
    800010fe:	00007517          	auipc	a0,0x7
    80001102:	ff250513          	addi	a0,a0,-14 # 800080f0 <__func__.1+0xe8>
    80001106:	fffff097          	auipc	ra,0xfffff
    8000110a:	45a080e7          	jalr	1114(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000110e:	060a8663          	beqz	s5,8000117a <walk+0xa2>
    80001112:	00000097          	auipc	ra,0x0
    80001116:	ab2080e7          	jalr	-1358(ra) # 80000bc4 <kalloc>
    8000111a:	84aa                	mv	s1,a0
    8000111c:	c529                	beqz	a0,80001166 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000111e:	6605                	lui	a2,0x1
    80001120:	4581                	li	a1,0
    80001122:	00000097          	auipc	ra,0x0
    80001126:	cda080e7          	jalr	-806(ra) # 80000dfc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000112a:	00c4d793          	srli	a5,s1,0xc
    8000112e:	07aa                	slli	a5,a5,0xa
    80001130:	0017e793          	ori	a5,a5,1
    80001134:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001138:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda697>
    8000113a:	036a0063          	beq	s4,s6,8000115a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000113e:	0149d933          	srl	s2,s3,s4
    80001142:	1ff97913          	andi	s2,s2,511
    80001146:	090e                	slli	s2,s2,0x3
    80001148:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000114a:	00093483          	ld	s1,0(s2)
    8000114e:	0014f793          	andi	a5,s1,1
    80001152:	dfd5                	beqz	a5,8000110e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001154:	80a9                	srli	s1,s1,0xa
    80001156:	04b2                	slli	s1,s1,0xc
    80001158:	b7c5                	j	80001138 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000115a:	00c9d513          	srli	a0,s3,0xc
    8000115e:	1ff57513          	andi	a0,a0,511
    80001162:	050e                	slli	a0,a0,0x3
    80001164:	9526                	add	a0,a0,s1
}
    80001166:	70e2                	ld	ra,56(sp)
    80001168:	7442                	ld	s0,48(sp)
    8000116a:	74a2                	ld	s1,40(sp)
    8000116c:	7902                	ld	s2,32(sp)
    8000116e:	69e2                	ld	s3,24(sp)
    80001170:	6a42                	ld	s4,16(sp)
    80001172:	6aa2                	ld	s5,8(sp)
    80001174:	6b02                	ld	s6,0(sp)
    80001176:	6121                	addi	sp,sp,64
    80001178:	8082                	ret
        return 0;
    8000117a:	4501                	li	a0,0
    8000117c:	b7ed                	j	80001166 <walk+0x8e>

000000008000117e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000117e:	57fd                	li	a5,-1
    80001180:	83e9                	srli	a5,a5,0x1a
    80001182:	00b7f463          	bgeu	a5,a1,8000118a <walkaddr+0xc>
    return 0;
    80001186:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001188:	8082                	ret
{
    8000118a:	1141                	addi	sp,sp,-16
    8000118c:	e406                	sd	ra,8(sp)
    8000118e:	e022                	sd	s0,0(sp)
    80001190:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001192:	4601                	li	a2,0
    80001194:	00000097          	auipc	ra,0x0
    80001198:	f44080e7          	jalr	-188(ra) # 800010d8 <walk>
  if(pte == 0)
    8000119c:	c105                	beqz	a0,800011bc <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000119e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800011a0:	0117f693          	andi	a3,a5,17
    800011a4:	4745                	li	a4,17
    return 0;
    800011a6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800011a8:	00e68663          	beq	a3,a4,800011b4 <walkaddr+0x36>
}
    800011ac:	60a2                	ld	ra,8(sp)
    800011ae:	6402                	ld	s0,0(sp)
    800011b0:	0141                	addi	sp,sp,16
    800011b2:	8082                	ret
  pa = PTE2PA(*pte);
    800011b4:	83a9                	srli	a5,a5,0xa
    800011b6:	00c79513          	slli	a0,a5,0xc
  return pa;
    800011ba:	bfcd                	j	800011ac <walkaddr+0x2e>
    return 0;
    800011bc:	4501                	li	a0,0
    800011be:	b7fd                	j	800011ac <walkaddr+0x2e>

00000000800011c0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800011c0:	715d                	addi	sp,sp,-80
    800011c2:	e486                	sd	ra,72(sp)
    800011c4:	e0a2                	sd	s0,64(sp)
    800011c6:	fc26                	sd	s1,56(sp)
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800011d6:	c639                	beqz	a2,80001224 <mappages+0x64>
    800011d8:	8aaa                	mv	s5,a0
    800011da:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800011dc:	777d                	lui	a4,0xfffff
    800011de:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011e2:	fff58993          	addi	s3,a1,-1
    800011e6:	99b2                	add	s3,s3,a2
    800011e8:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011ec:	893e                	mv	s2,a5
    800011ee:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011f2:	6b85                	lui	s7,0x1
    800011f4:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800011f8:	4605                	li	a2,1
    800011fa:	85ca                	mv	a1,s2
    800011fc:	8556                	mv	a0,s5
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	eda080e7          	jalr	-294(ra) # 800010d8 <walk>
    80001206:	cd1d                	beqz	a0,80001244 <mappages+0x84>
    if(*pte & PTE_V)
    80001208:	611c                	ld	a5,0(a0)
    8000120a:	8b85                	andi	a5,a5,1
    8000120c:	e785                	bnez	a5,80001234 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000120e:	80b1                	srli	s1,s1,0xc
    80001210:	04aa                	slli	s1,s1,0xa
    80001212:	0164e4b3          	or	s1,s1,s6
    80001216:	0014e493          	ori	s1,s1,1
    8000121a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000121c:	05390063          	beq	s2,s3,8000125c <mappages+0x9c>
    a += PGSIZE;
    80001220:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001222:	bfc9                	j	800011f4 <mappages+0x34>
    panic("mappages: size");
    80001224:	00007517          	auipc	a0,0x7
    80001228:	ed450513          	addi	a0,a0,-300 # 800080f8 <__func__.1+0xf0>
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	334080e7          	jalr	820(ra) # 80000560 <panic>
      panic("mappages: remap");
    80001234:	00007517          	auipc	a0,0x7
    80001238:	ed450513          	addi	a0,a0,-300 # 80008108 <__func__.1+0x100>
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	324080e7          	jalr	804(ra) # 80000560 <panic>
      return -1;
    80001244:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001246:	60a6                	ld	ra,72(sp)
    80001248:	6406                	ld	s0,64(sp)
    8000124a:	74e2                	ld	s1,56(sp)
    8000124c:	7942                	ld	s2,48(sp)
    8000124e:	79a2                	ld	s3,40(sp)
    80001250:	7a02                	ld	s4,32(sp)
    80001252:	6ae2                	ld	s5,24(sp)
    80001254:	6b42                	ld	s6,16(sp)
    80001256:	6ba2                	ld	s7,8(sp)
    80001258:	6161                	addi	sp,sp,80
    8000125a:	8082                	ret
  return 0;
    8000125c:	4501                	li	a0,0
    8000125e:	b7e5                	j	80001246 <mappages+0x86>

0000000080001260 <kvmmap>:
{
    80001260:	1141                	addi	sp,sp,-16
    80001262:	e406                	sd	ra,8(sp)
    80001264:	e022                	sd	s0,0(sp)
    80001266:	0800                	addi	s0,sp,16
    80001268:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000126a:	86b2                	mv	a3,a2
    8000126c:	863e                	mv	a2,a5
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	f52080e7          	jalr	-174(ra) # 800011c0 <mappages>
    80001276:	e509                	bnez	a0,80001280 <kvmmap+0x20>
}
    80001278:	60a2                	ld	ra,8(sp)
    8000127a:	6402                	ld	s0,0(sp)
    8000127c:	0141                	addi	sp,sp,16
    8000127e:	8082                	ret
    panic("kvmmap");
    80001280:	00007517          	auipc	a0,0x7
    80001284:	e9850513          	addi	a0,a0,-360 # 80008118 <__func__.1+0x110>
    80001288:	fffff097          	auipc	ra,0xfffff
    8000128c:	2d8080e7          	jalr	728(ra) # 80000560 <panic>

0000000080001290 <kvmmake>:
{
    80001290:	1101                	addi	sp,sp,-32
    80001292:	ec06                	sd	ra,24(sp)
    80001294:	e822                	sd	s0,16(sp)
    80001296:	e426                	sd	s1,8(sp)
    80001298:	e04a                	sd	s2,0(sp)
    8000129a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	928080e7          	jalr	-1752(ra) # 80000bc4 <kalloc>
    800012a4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800012a6:	6605                	lui	a2,0x1
    800012a8:	4581                	li	a1,0
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	b52080e7          	jalr	-1198(ra) # 80000dfc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012b2:	4719                	li	a4,6
    800012b4:	6685                	lui	a3,0x1
    800012b6:	10000637          	lui	a2,0x10000
    800012ba:	100005b7          	lui	a1,0x10000
    800012be:	8526                	mv	a0,s1
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	fa0080e7          	jalr	-96(ra) # 80001260 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012c8:	4719                	li	a4,6
    800012ca:	6685                	lui	a3,0x1
    800012cc:	10001637          	lui	a2,0x10001
    800012d0:	100015b7          	lui	a1,0x10001
    800012d4:	8526                	mv	a0,s1
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	f8a080e7          	jalr	-118(ra) # 80001260 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012de:	4719                	li	a4,6
    800012e0:	004006b7          	lui	a3,0x400
    800012e4:	0c000637          	lui	a2,0xc000
    800012e8:	0c0005b7          	lui	a1,0xc000
    800012ec:	8526                	mv	a0,s1
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	f72080e7          	jalr	-142(ra) # 80001260 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012f6:	00007917          	auipc	s2,0x7
    800012fa:	d0a90913          	addi	s2,s2,-758 # 80008000 <etext>
    800012fe:	4729                	li	a4,10
    80001300:	80007697          	auipc	a3,0x80007
    80001304:	d0068693          	addi	a3,a3,-768 # 8000 <_entry-0x7fff8000>
    80001308:	4605                	li	a2,1
    8000130a:	067e                	slli	a2,a2,0x1f
    8000130c:	85b2                	mv	a1,a2
    8000130e:	8526                	mv	a0,s1
    80001310:	00000097          	auipc	ra,0x0
    80001314:	f50080e7          	jalr	-176(ra) # 80001260 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001318:	46c5                	li	a3,17
    8000131a:	06ee                	slli	a3,a3,0x1b
    8000131c:	4719                	li	a4,6
    8000131e:	412686b3          	sub	a3,a3,s2
    80001322:	864a                	mv	a2,s2
    80001324:	85ca                	mv	a1,s2
    80001326:	8526                	mv	a0,s1
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	f38080e7          	jalr	-200(ra) # 80001260 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001330:	4729                	li	a4,10
    80001332:	6685                	lui	a3,0x1
    80001334:	00006617          	auipc	a2,0x6
    80001338:	ccc60613          	addi	a2,a2,-820 # 80007000 <_trampoline>
    8000133c:	040005b7          	lui	a1,0x4000
    80001340:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001342:	05b2                	slli	a1,a1,0xc
    80001344:	8526                	mv	a0,s1
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	f1a080e7          	jalr	-230(ra) # 80001260 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000134e:	8526                	mv	a0,s1
    80001350:	00000097          	auipc	ra,0x0
    80001354:	700080e7          	jalr	1792(ra) # 80001a50 <proc_mapstacks>
}
    80001358:	8526                	mv	a0,s1
    8000135a:	60e2                	ld	ra,24(sp)
    8000135c:	6442                	ld	s0,16(sp)
    8000135e:	64a2                	ld	s1,8(sp)
    80001360:	6902                	ld	s2,0(sp)
    80001362:	6105                	addi	sp,sp,32
    80001364:	8082                	ret

0000000080001366 <kvminit>:
{
    80001366:	1141                	addi	sp,sp,-16
    80001368:	e406                	sd	ra,8(sp)
    8000136a:	e022                	sd	s0,0(sp)
    8000136c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	f22080e7          	jalr	-222(ra) # 80001290 <kvmmake>
    80001376:	0000a797          	auipc	a5,0xa
    8000137a:	14a7bd23          	sd	a0,346(a5) # 8000b4d0 <kernel_pagetable>
}
    8000137e:	60a2                	ld	ra,8(sp)
    80001380:	6402                	ld	s0,0(sp)
    80001382:	0141                	addi	sp,sp,16
    80001384:	8082                	ret

0000000080001386 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001386:	715d                	addi	sp,sp,-80
    80001388:	e486                	sd	ra,72(sp)
    8000138a:	e0a2                	sd	s0,64(sp)
    8000138c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000138e:	03459793          	slli	a5,a1,0x34
    80001392:	e39d                	bnez	a5,800013b8 <uvmunmap+0x32>
    80001394:	f84a                	sd	s2,48(sp)
    80001396:	f44e                	sd	s3,40(sp)
    80001398:	f052                	sd	s4,32(sp)
    8000139a:	ec56                	sd	s5,24(sp)
    8000139c:	e85a                	sd	s6,16(sp)
    8000139e:	e45e                	sd	s7,8(sp)
    800013a0:	8a2a                	mv	s4,a0
    800013a2:	892e                	mv	s2,a1
    800013a4:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013a6:	0632                	slli	a2,a2,0xc
    800013a8:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800013ac:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013ae:	6b05                	lui	s6,0x1
    800013b0:	0935fb63          	bgeu	a1,s3,80001446 <uvmunmap+0xc0>
    800013b4:	fc26                	sd	s1,56(sp)
    800013b6:	a8a9                	j	80001410 <uvmunmap+0x8a>
    800013b8:	fc26                	sd	s1,56(sp)
    800013ba:	f84a                	sd	s2,48(sp)
    800013bc:	f44e                	sd	s3,40(sp)
    800013be:	f052                	sd	s4,32(sp)
    800013c0:	ec56                	sd	s5,24(sp)
    800013c2:	e85a                	sd	s6,16(sp)
    800013c4:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800013c6:	00007517          	auipc	a0,0x7
    800013ca:	d5a50513          	addi	a0,a0,-678 # 80008120 <__func__.1+0x118>
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	192080e7          	jalr	402(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    800013d6:	00007517          	auipc	a0,0x7
    800013da:	d6250513          	addi	a0,a0,-670 # 80008138 <__func__.1+0x130>
    800013de:	fffff097          	auipc	ra,0xfffff
    800013e2:	182080e7          	jalr	386(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    800013e6:	00007517          	auipc	a0,0x7
    800013ea:	d6250513          	addi	a0,a0,-670 # 80008148 <__func__.1+0x140>
    800013ee:	fffff097          	auipc	ra,0xfffff
    800013f2:	172080e7          	jalr	370(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    800013f6:	00007517          	auipc	a0,0x7
    800013fa:	d6a50513          	addi	a0,a0,-662 # 80008160 <__func__.1+0x158>
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	162080e7          	jalr	354(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001406:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000140a:	995a                	add	s2,s2,s6
    8000140c:	03397c63          	bgeu	s2,s3,80001444 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001410:	4601                	li	a2,0
    80001412:	85ca                	mv	a1,s2
    80001414:	8552                	mv	a0,s4
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	cc2080e7          	jalr	-830(ra) # 800010d8 <walk>
    8000141e:	84aa                	mv	s1,a0
    80001420:	d95d                	beqz	a0,800013d6 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001422:	6108                	ld	a0,0(a0)
    80001424:	00157793          	andi	a5,a0,1
    80001428:	dfdd                	beqz	a5,800013e6 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000142a:	3ff57793          	andi	a5,a0,1023
    8000142e:	fd7784e3          	beq	a5,s7,800013f6 <uvmunmap+0x70>
    if(do_free){
    80001432:	fc0a8ae3          	beqz	s5,80001406 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001436:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001438:	0532                	slli	a0,a0,0xc
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	622080e7          	jalr	1570(ra) # 80000a5c <kfree>
    80001442:	b7d1                	j	80001406 <uvmunmap+0x80>
    80001444:	74e2                	ld	s1,56(sp)
    80001446:	7942                	ld	s2,48(sp)
    80001448:	79a2                	ld	s3,40(sp)
    8000144a:	7a02                	ld	s4,32(sp)
    8000144c:	6ae2                	ld	s5,24(sp)
    8000144e:	6b42                	ld	s6,16(sp)
    80001450:	6ba2                	ld	s7,8(sp)
  }
}
    80001452:	60a6                	ld	ra,72(sp)
    80001454:	6406                	ld	s0,64(sp)
    80001456:	6161                	addi	sp,sp,80
    80001458:	8082                	ret

000000008000145a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000145a:	1101                	addi	sp,sp,-32
    8000145c:	ec06                	sd	ra,24(sp)
    8000145e:	e822                	sd	s0,16(sp)
    80001460:	e426                	sd	s1,8(sp)
    80001462:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001464:	fffff097          	auipc	ra,0xfffff
    80001468:	760080e7          	jalr	1888(ra) # 80000bc4 <kalloc>
    8000146c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000146e:	c519                	beqz	a0,8000147c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001470:	6605                	lui	a2,0x1
    80001472:	4581                	li	a1,0
    80001474:	00000097          	auipc	ra,0x0
    80001478:	988080e7          	jalr	-1656(ra) # 80000dfc <memset>
  return pagetable;
}
    8000147c:	8526                	mv	a0,s1
    8000147e:	60e2                	ld	ra,24(sp)
    80001480:	6442                	ld	s0,16(sp)
    80001482:	64a2                	ld	s1,8(sp)
    80001484:	6105                	addi	sp,sp,32
    80001486:	8082                	ret

0000000080001488 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001488:	7179                	addi	sp,sp,-48
    8000148a:	f406                	sd	ra,40(sp)
    8000148c:	f022                	sd	s0,32(sp)
    8000148e:	ec26                	sd	s1,24(sp)
    80001490:	e84a                	sd	s2,16(sp)
    80001492:	e44e                	sd	s3,8(sp)
    80001494:	e052                	sd	s4,0(sp)
    80001496:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001498:	6785                	lui	a5,0x1
    8000149a:	04f67863          	bgeu	a2,a5,800014ea <uvmfirst+0x62>
    8000149e:	8a2a                	mv	s4,a0
    800014a0:	89ae                	mv	s3,a1
    800014a2:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800014a4:	fffff097          	auipc	ra,0xfffff
    800014a8:	720080e7          	jalr	1824(ra) # 80000bc4 <kalloc>
    800014ac:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014ae:	6605                	lui	a2,0x1
    800014b0:	4581                	li	a1,0
    800014b2:	00000097          	auipc	ra,0x0
    800014b6:	94a080e7          	jalr	-1718(ra) # 80000dfc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800014ba:	4779                	li	a4,30
    800014bc:	86ca                	mv	a3,s2
    800014be:	6605                	lui	a2,0x1
    800014c0:	4581                	li	a1,0
    800014c2:	8552                	mv	a0,s4
    800014c4:	00000097          	auipc	ra,0x0
    800014c8:	cfc080e7          	jalr	-772(ra) # 800011c0 <mappages>
  memmove(mem, src, sz);
    800014cc:	8626                	mv	a2,s1
    800014ce:	85ce                	mv	a1,s3
    800014d0:	854a                	mv	a0,s2
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	986080e7          	jalr	-1658(ra) # 80000e58 <memmove>
}
    800014da:	70a2                	ld	ra,40(sp)
    800014dc:	7402                	ld	s0,32(sp)
    800014de:	64e2                	ld	s1,24(sp)
    800014e0:	6942                	ld	s2,16(sp)
    800014e2:	69a2                	ld	s3,8(sp)
    800014e4:	6a02                	ld	s4,0(sp)
    800014e6:	6145                	addi	sp,sp,48
    800014e8:	8082                	ret
    panic("uvmfirst: more than a page");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	c8e50513          	addi	a0,a0,-882 # 80008178 <__func__.1+0x170>
    800014f2:	fffff097          	auipc	ra,0xfffff
    800014f6:	06e080e7          	jalr	110(ra) # 80000560 <panic>

00000000800014fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014fa:	1101                	addi	sp,sp,-32
    800014fc:	ec06                	sd	ra,24(sp)
    800014fe:	e822                	sd	s0,16(sp)
    80001500:	e426                	sd	s1,8(sp)
    80001502:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001504:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001506:	00b67d63          	bgeu	a2,a1,80001520 <uvmdealloc+0x26>
    8000150a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000150c:	6785                	lui	a5,0x1
    8000150e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001510:	00f60733          	add	a4,a2,a5
    80001514:	76fd                	lui	a3,0xfffff
    80001516:	8f75                	and	a4,a4,a3
    80001518:	97ae                	add	a5,a5,a1
    8000151a:	8ff5                	and	a5,a5,a3
    8000151c:	00f76863          	bltu	a4,a5,8000152c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001520:	8526                	mv	a0,s1
    80001522:	60e2                	ld	ra,24(sp)
    80001524:	6442                	ld	s0,16(sp)
    80001526:	64a2                	ld	s1,8(sp)
    80001528:	6105                	addi	sp,sp,32
    8000152a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000152c:	8f99                	sub	a5,a5,a4
    8000152e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001530:	4685                	li	a3,1
    80001532:	0007861b          	sext.w	a2,a5
    80001536:	85ba                	mv	a1,a4
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	e4e080e7          	jalr	-434(ra) # 80001386 <uvmunmap>
    80001540:	b7c5                	j	80001520 <uvmdealloc+0x26>

0000000080001542 <uvmalloc>:
  if(newsz < oldsz)
    80001542:	0ab66b63          	bltu	a2,a1,800015f8 <uvmalloc+0xb6>
{
    80001546:	7139                	addi	sp,sp,-64
    80001548:	fc06                	sd	ra,56(sp)
    8000154a:	f822                	sd	s0,48(sp)
    8000154c:	ec4e                	sd	s3,24(sp)
    8000154e:	e852                	sd	s4,16(sp)
    80001550:	e456                	sd	s5,8(sp)
    80001552:	0080                	addi	s0,sp,64
    80001554:	8aaa                	mv	s5,a0
    80001556:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001558:	6785                	lui	a5,0x1
    8000155a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000155c:	95be                	add	a1,a1,a5
    8000155e:	77fd                	lui	a5,0xfffff
    80001560:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001564:	08c9fc63          	bgeu	s3,a2,800015fc <uvmalloc+0xba>
    80001568:	f426                	sd	s1,40(sp)
    8000156a:	f04a                	sd	s2,32(sp)
    8000156c:	e05a                	sd	s6,0(sp)
    8000156e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001570:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001574:	fffff097          	auipc	ra,0xfffff
    80001578:	650080e7          	jalr	1616(ra) # 80000bc4 <kalloc>
    8000157c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000157e:	c915                	beqz	a0,800015b2 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80001580:	6605                	lui	a2,0x1
    80001582:	4581                	li	a1,0
    80001584:	00000097          	auipc	ra,0x0
    80001588:	878080e7          	jalr	-1928(ra) # 80000dfc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000158c:	875a                	mv	a4,s6
    8000158e:	86a6                	mv	a3,s1
    80001590:	6605                	lui	a2,0x1
    80001592:	85ca                	mv	a1,s2
    80001594:	8556                	mv	a0,s5
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	c2a080e7          	jalr	-982(ra) # 800011c0 <mappages>
    8000159e:	ed05                	bnez	a0,800015d6 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015a0:	6785                	lui	a5,0x1
    800015a2:	993e                	add	s2,s2,a5
    800015a4:	fd4968e3          	bltu	s2,s4,80001574 <uvmalloc+0x32>
  return newsz;
    800015a8:	8552                	mv	a0,s4
    800015aa:	74a2                	ld	s1,40(sp)
    800015ac:	7902                	ld	s2,32(sp)
    800015ae:	6b02                	ld	s6,0(sp)
    800015b0:	a821                	j	800015c8 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800015b2:	864e                	mv	a2,s3
    800015b4:	85ca                	mv	a1,s2
    800015b6:	8556                	mv	a0,s5
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	f42080e7          	jalr	-190(ra) # 800014fa <uvmdealloc>
      return 0;
    800015c0:	4501                	li	a0,0
    800015c2:	74a2                	ld	s1,40(sp)
    800015c4:	7902                	ld	s2,32(sp)
    800015c6:	6b02                	ld	s6,0(sp)
}
    800015c8:	70e2                	ld	ra,56(sp)
    800015ca:	7442                	ld	s0,48(sp)
    800015cc:	69e2                	ld	s3,24(sp)
    800015ce:	6a42                	ld	s4,16(sp)
    800015d0:	6aa2                	ld	s5,8(sp)
    800015d2:	6121                	addi	sp,sp,64
    800015d4:	8082                	ret
      kfree(mem);
    800015d6:	8526                	mv	a0,s1
    800015d8:	fffff097          	auipc	ra,0xfffff
    800015dc:	484080e7          	jalr	1156(ra) # 80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015e0:	864e                	mv	a2,s3
    800015e2:	85ca                	mv	a1,s2
    800015e4:	8556                	mv	a0,s5
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	f14080e7          	jalr	-236(ra) # 800014fa <uvmdealloc>
      return 0;
    800015ee:	4501                	li	a0,0
    800015f0:	74a2                	ld	s1,40(sp)
    800015f2:	7902                	ld	s2,32(sp)
    800015f4:	6b02                	ld	s6,0(sp)
    800015f6:	bfc9                	j	800015c8 <uvmalloc+0x86>
    return oldsz;
    800015f8:	852e                	mv	a0,a1
}
    800015fa:	8082                	ret
  return newsz;
    800015fc:	8532                	mv	a0,a2
    800015fe:	b7e9                	j	800015c8 <uvmalloc+0x86>

0000000080001600 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001600:	7179                	addi	sp,sp,-48
    80001602:	f406                	sd	ra,40(sp)
    80001604:	f022                	sd	s0,32(sp)
    80001606:	ec26                	sd	s1,24(sp)
    80001608:	e84a                	sd	s2,16(sp)
    8000160a:	e44e                	sd	s3,8(sp)
    8000160c:	e052                	sd	s4,0(sp)
    8000160e:	1800                	addi	s0,sp,48
    80001610:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001612:	84aa                	mv	s1,a0
    80001614:	6905                	lui	s2,0x1
    80001616:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001618:	4985                	li	s3,1
    8000161a:	a829                	j	80001634 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000161c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000161e:	00c79513          	slli	a0,a5,0xc
    80001622:	00000097          	auipc	ra,0x0
    80001626:	fde080e7          	jalr	-34(ra) # 80001600 <freewalk>
      pagetable[i] = 0;
    8000162a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000162e:	04a1                	addi	s1,s1,8
    80001630:	03248163          	beq	s1,s2,80001652 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001634:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001636:	00f7f713          	andi	a4,a5,15
    8000163a:	ff3701e3          	beq	a4,s3,8000161c <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000163e:	8b85                	andi	a5,a5,1
    80001640:	d7fd                	beqz	a5,8000162e <freewalk+0x2e>
      panic("freewalk: leaf");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	b5650513          	addi	a0,a0,-1194 # 80008198 <__func__.1+0x190>
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	f16080e7          	jalr	-234(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    80001652:	8552                	mv	a0,s4
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	408080e7          	jalr	1032(ra) # 80000a5c <kfree>
}
    8000165c:	70a2                	ld	ra,40(sp)
    8000165e:	7402                	ld	s0,32(sp)
    80001660:	64e2                	ld	s1,24(sp)
    80001662:	6942                	ld	s2,16(sp)
    80001664:	69a2                	ld	s3,8(sp)
    80001666:	6a02                	ld	s4,0(sp)
    80001668:	6145                	addi	sp,sp,48
    8000166a:	8082                	ret

000000008000166c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000166c:	1101                	addi	sp,sp,-32
    8000166e:	ec06                	sd	ra,24(sp)
    80001670:	e822                	sd	s0,16(sp)
    80001672:	e426                	sd	s1,8(sp)
    80001674:	1000                	addi	s0,sp,32
    80001676:	84aa                	mv	s1,a0
  if(sz > 0)
    80001678:	e999                	bnez	a1,8000168e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000167a:	8526                	mv	a0,s1
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	f84080e7          	jalr	-124(ra) # 80001600 <freewalk>
}
    80001684:	60e2                	ld	ra,24(sp)
    80001686:	6442                	ld	s0,16(sp)
    80001688:	64a2                	ld	s1,8(sp)
    8000168a:	6105                	addi	sp,sp,32
    8000168c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000168e:	6785                	lui	a5,0x1
    80001690:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001692:	95be                	add	a1,a1,a5
    80001694:	4685                	li	a3,1
    80001696:	00c5d613          	srli	a2,a1,0xc
    8000169a:	4581                	li	a1,0
    8000169c:	00000097          	auipc	ra,0x0
    800016a0:	cea080e7          	jalr	-790(ra) # 80001386 <uvmunmap>
    800016a4:	bfd9                	j	8000167a <uvmfree+0xe>

00000000800016a6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800016a6:	c679                	beqz	a2,80001774 <uvmcopy+0xce>
{
    800016a8:	715d                	addi	sp,sp,-80
    800016aa:	e486                	sd	ra,72(sp)
    800016ac:	e0a2                	sd	s0,64(sp)
    800016ae:	fc26                	sd	s1,56(sp)
    800016b0:	f84a                	sd	s2,48(sp)
    800016b2:	f44e                	sd	s3,40(sp)
    800016b4:	f052                	sd	s4,32(sp)
    800016b6:	ec56                	sd	s5,24(sp)
    800016b8:	e85a                	sd	s6,16(sp)
    800016ba:	e45e                	sd	s7,8(sp)
    800016bc:	0880                	addi	s0,sp,80
    800016be:	8b2a                	mv	s6,a0
    800016c0:	8aae                	mv	s5,a1
    800016c2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800016c4:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800016c6:	4601                	li	a2,0
    800016c8:	85ce                	mv	a1,s3
    800016ca:	855a                	mv	a0,s6
    800016cc:	00000097          	auipc	ra,0x0
    800016d0:	a0c080e7          	jalr	-1524(ra) # 800010d8 <walk>
    800016d4:	c531                	beqz	a0,80001720 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800016d6:	6118                	ld	a4,0(a0)
    800016d8:	00177793          	andi	a5,a4,1
    800016dc:	cbb1                	beqz	a5,80001730 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800016de:	00a75593          	srli	a1,a4,0xa
    800016e2:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800016e6:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	4da080e7          	jalr	1242(ra) # 80000bc4 <kalloc>
    800016f2:	892a                	mv	s2,a0
    800016f4:	c939                	beqz	a0,8000174a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800016f6:	6605                	lui	a2,0x1
    800016f8:	85de                	mv	a1,s7
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	75e080e7          	jalr	1886(ra) # 80000e58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001702:	8726                	mv	a4,s1
    80001704:	86ca                	mv	a3,s2
    80001706:	6605                	lui	a2,0x1
    80001708:	85ce                	mv	a1,s3
    8000170a:	8556                	mv	a0,s5
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	ab4080e7          	jalr	-1356(ra) # 800011c0 <mappages>
    80001714:	e515                	bnez	a0,80001740 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001716:	6785                	lui	a5,0x1
    80001718:	99be                	add	s3,s3,a5
    8000171a:	fb49e6e3          	bltu	s3,s4,800016c6 <uvmcopy+0x20>
    8000171e:	a081                	j	8000175e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001720:	00007517          	auipc	a0,0x7
    80001724:	a8850513          	addi	a0,a0,-1400 # 800081a8 <__func__.1+0x1a0>
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	e38080e7          	jalr	-456(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001730:	00007517          	auipc	a0,0x7
    80001734:	a9850513          	addi	a0,a0,-1384 # 800081c8 <__func__.1+0x1c0>
    80001738:	fffff097          	auipc	ra,0xfffff
    8000173c:	e28080e7          	jalr	-472(ra) # 80000560 <panic>
      kfree(mem);
    80001740:	854a                	mv	a0,s2
    80001742:	fffff097          	auipc	ra,0xfffff
    80001746:	31a080e7          	jalr	794(ra) # 80000a5c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000174a:	4685                	li	a3,1
    8000174c:	00c9d613          	srli	a2,s3,0xc
    80001750:	4581                	li	a1,0
    80001752:	8556                	mv	a0,s5
    80001754:	00000097          	auipc	ra,0x0
    80001758:	c32080e7          	jalr	-974(ra) # 80001386 <uvmunmap>
  return -1;
    8000175c:	557d                	li	a0,-1
}
    8000175e:	60a6                	ld	ra,72(sp)
    80001760:	6406                	ld	s0,64(sp)
    80001762:	74e2                	ld	s1,56(sp)
    80001764:	7942                	ld	s2,48(sp)
    80001766:	79a2                	ld	s3,40(sp)
    80001768:	7a02                	ld	s4,32(sp)
    8000176a:	6ae2                	ld	s5,24(sp)
    8000176c:	6b42                	ld	s6,16(sp)
    8000176e:	6ba2                	ld	s7,8(sp)
    80001770:	6161                	addi	sp,sp,80
    80001772:	8082                	ret
  return 0;
    80001774:	4501                	li	a0,0
}
    80001776:	8082                	ret

0000000080001778 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001778:	1141                	addi	sp,sp,-16
    8000177a:	e406                	sd	ra,8(sp)
    8000177c:	e022                	sd	s0,0(sp)
    8000177e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001780:	4601                	li	a2,0
    80001782:	00000097          	auipc	ra,0x0
    80001786:	956080e7          	jalr	-1706(ra) # 800010d8 <walk>
  if(pte == 0)
    8000178a:	c901                	beqz	a0,8000179a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000178c:	611c                	ld	a5,0(a0)
    8000178e:	9bbd                	andi	a5,a5,-17
    80001790:	e11c                	sd	a5,0(a0)
}
    80001792:	60a2                	ld	ra,8(sp)
    80001794:	6402                	ld	s0,0(sp)
    80001796:	0141                	addi	sp,sp,16
    80001798:	8082                	ret
    panic("uvmclear");
    8000179a:	00007517          	auipc	a0,0x7
    8000179e:	a4e50513          	addi	a0,a0,-1458 # 800081e8 <__func__.1+0x1e0>
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	dbe080e7          	jalr	-578(ra) # 80000560 <panic>

00000000800017aa <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017aa:	c6bd                	beqz	a3,80001818 <copyout+0x6e>
{
    800017ac:	715d                	addi	sp,sp,-80
    800017ae:	e486                	sd	ra,72(sp)
    800017b0:	e0a2                	sd	s0,64(sp)
    800017b2:	fc26                	sd	s1,56(sp)
    800017b4:	f84a                	sd	s2,48(sp)
    800017b6:	f44e                	sd	s3,40(sp)
    800017b8:	f052                	sd	s4,32(sp)
    800017ba:	ec56                	sd	s5,24(sp)
    800017bc:	e85a                	sd	s6,16(sp)
    800017be:	e45e                	sd	s7,8(sp)
    800017c0:	e062                	sd	s8,0(sp)
    800017c2:	0880                	addi	s0,sp,80
    800017c4:	8b2a                	mv	s6,a0
    800017c6:	8c2e                	mv	s8,a1
    800017c8:	8a32                	mv	s4,a2
    800017ca:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800017cc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800017ce:	6a85                	lui	s5,0x1
    800017d0:	a015                	j	800017f4 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800017d2:	9562                	add	a0,a0,s8
    800017d4:	0004861b          	sext.w	a2,s1
    800017d8:	85d2                	mv	a1,s4
    800017da:	41250533          	sub	a0,a0,s2
    800017de:	fffff097          	auipc	ra,0xfffff
    800017e2:	67a080e7          	jalr	1658(ra) # 80000e58 <memmove>

    len -= n;
    800017e6:	409989b3          	sub	s3,s3,s1
    src += n;
    800017ea:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800017ec:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017f0:	02098263          	beqz	s3,80001814 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800017f4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017f8:	85ca                	mv	a1,s2
    800017fa:	855a                	mv	a0,s6
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	982080e7          	jalr	-1662(ra) # 8000117e <walkaddr>
    if(pa0 == 0)
    80001804:	cd01                	beqz	a0,8000181c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001806:	418904b3          	sub	s1,s2,s8
    8000180a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000180c:	fc99f3e3          	bgeu	s3,s1,800017d2 <copyout+0x28>
    80001810:	84ce                	mv	s1,s3
    80001812:	b7c1                	j	800017d2 <copyout+0x28>
  }
  return 0;
    80001814:	4501                	li	a0,0
    80001816:	a021                	j	8000181e <copyout+0x74>
    80001818:	4501                	li	a0,0
}
    8000181a:	8082                	ret
      return -1;
    8000181c:	557d                	li	a0,-1
}
    8000181e:	60a6                	ld	ra,72(sp)
    80001820:	6406                	ld	s0,64(sp)
    80001822:	74e2                	ld	s1,56(sp)
    80001824:	7942                	ld	s2,48(sp)
    80001826:	79a2                	ld	s3,40(sp)
    80001828:	7a02                	ld	s4,32(sp)
    8000182a:	6ae2                	ld	s5,24(sp)
    8000182c:	6b42                	ld	s6,16(sp)
    8000182e:	6ba2                	ld	s7,8(sp)
    80001830:	6c02                	ld	s8,0(sp)
    80001832:	6161                	addi	sp,sp,80
    80001834:	8082                	ret

0000000080001836 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001836:	caa5                	beqz	a3,800018a6 <copyin+0x70>
{
    80001838:	715d                	addi	sp,sp,-80
    8000183a:	e486                	sd	ra,72(sp)
    8000183c:	e0a2                	sd	s0,64(sp)
    8000183e:	fc26                	sd	s1,56(sp)
    80001840:	f84a                	sd	s2,48(sp)
    80001842:	f44e                	sd	s3,40(sp)
    80001844:	f052                	sd	s4,32(sp)
    80001846:	ec56                	sd	s5,24(sp)
    80001848:	e85a                	sd	s6,16(sp)
    8000184a:	e45e                	sd	s7,8(sp)
    8000184c:	e062                	sd	s8,0(sp)
    8000184e:	0880                	addi	s0,sp,80
    80001850:	8b2a                	mv	s6,a0
    80001852:	8a2e                	mv	s4,a1
    80001854:	8c32                	mv	s8,a2
    80001856:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001858:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000185a:	6a85                	lui	s5,0x1
    8000185c:	a01d                	j	80001882 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000185e:	018505b3          	add	a1,a0,s8
    80001862:	0004861b          	sext.w	a2,s1
    80001866:	412585b3          	sub	a1,a1,s2
    8000186a:	8552                	mv	a0,s4
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	5ec080e7          	jalr	1516(ra) # 80000e58 <memmove>

    len -= n;
    80001874:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001878:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000187a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000187e:	02098263          	beqz	s3,800018a2 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001882:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001886:	85ca                	mv	a1,s2
    80001888:	855a                	mv	a0,s6
    8000188a:	00000097          	auipc	ra,0x0
    8000188e:	8f4080e7          	jalr	-1804(ra) # 8000117e <walkaddr>
    if(pa0 == 0)
    80001892:	cd01                	beqz	a0,800018aa <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001894:	418904b3          	sub	s1,s2,s8
    80001898:	94d6                	add	s1,s1,s5
    if(n > len)
    8000189a:	fc99f2e3          	bgeu	s3,s1,8000185e <copyin+0x28>
    8000189e:	84ce                	mv	s1,s3
    800018a0:	bf7d                	j	8000185e <copyin+0x28>
  }
  return 0;
    800018a2:	4501                	li	a0,0
    800018a4:	a021                	j	800018ac <copyin+0x76>
    800018a6:	4501                	li	a0,0
}
    800018a8:	8082                	ret
      return -1;
    800018aa:	557d                	li	a0,-1
}
    800018ac:	60a6                	ld	ra,72(sp)
    800018ae:	6406                	ld	s0,64(sp)
    800018b0:	74e2                	ld	s1,56(sp)
    800018b2:	7942                	ld	s2,48(sp)
    800018b4:	79a2                	ld	s3,40(sp)
    800018b6:	7a02                	ld	s4,32(sp)
    800018b8:	6ae2                	ld	s5,24(sp)
    800018ba:	6b42                	ld	s6,16(sp)
    800018bc:	6ba2                	ld	s7,8(sp)
    800018be:	6c02                	ld	s8,0(sp)
    800018c0:	6161                	addi	sp,sp,80
    800018c2:	8082                	ret

00000000800018c4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800018c4:	cacd                	beqz	a3,80001976 <copyinstr+0xb2>
{
    800018c6:	715d                	addi	sp,sp,-80
    800018c8:	e486                	sd	ra,72(sp)
    800018ca:	e0a2                	sd	s0,64(sp)
    800018cc:	fc26                	sd	s1,56(sp)
    800018ce:	f84a                	sd	s2,48(sp)
    800018d0:	f44e                	sd	s3,40(sp)
    800018d2:	f052                	sd	s4,32(sp)
    800018d4:	ec56                	sd	s5,24(sp)
    800018d6:	e85a                	sd	s6,16(sp)
    800018d8:	e45e                	sd	s7,8(sp)
    800018da:	0880                	addi	s0,sp,80
    800018dc:	8a2a                	mv	s4,a0
    800018de:	8b2e                	mv	s6,a1
    800018e0:	8bb2                	mv	s7,a2
    800018e2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800018e4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800018e6:	6985                	lui	s3,0x1
    800018e8:	a825                	j	80001920 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800018ea:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800018ee:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800018f0:	37fd                	addiw	a5,a5,-1
    800018f2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800018f6:	60a6                	ld	ra,72(sp)
    800018f8:	6406                	ld	s0,64(sp)
    800018fa:	74e2                	ld	s1,56(sp)
    800018fc:	7942                	ld	s2,48(sp)
    800018fe:	79a2                	ld	s3,40(sp)
    80001900:	7a02                	ld	s4,32(sp)
    80001902:	6ae2                	ld	s5,24(sp)
    80001904:	6b42                	ld	s6,16(sp)
    80001906:	6ba2                	ld	s7,8(sp)
    80001908:	6161                	addi	sp,sp,80
    8000190a:	8082                	ret
    8000190c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001910:	9742                	add	a4,a4,a6
      --max;
    80001912:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001916:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000191a:	04e58663          	beq	a1,a4,80001966 <copyinstr+0xa2>
{
    8000191e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001920:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001924:	85a6                	mv	a1,s1
    80001926:	8552                	mv	a0,s4
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	856080e7          	jalr	-1962(ra) # 8000117e <walkaddr>
    if(pa0 == 0)
    80001930:	cd0d                	beqz	a0,8000196a <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001932:	417486b3          	sub	a3,s1,s7
    80001936:	96ce                	add	a3,a3,s3
    if(n > max)
    80001938:	00d97363          	bgeu	s2,a3,8000193e <copyinstr+0x7a>
    8000193c:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    8000193e:	955e                	add	a0,a0,s7
    80001940:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001942:	c695                	beqz	a3,8000196e <copyinstr+0xaa>
    80001944:	87da                	mv	a5,s6
    80001946:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001948:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000194c:	96da                	add	a3,a3,s6
    8000194e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001950:	00f60733          	add	a4,a2,a5
    80001954:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffda6a0>
    80001958:	db49                	beqz	a4,800018ea <copyinstr+0x26>
        *dst = *p;
    8000195a:	00e78023          	sb	a4,0(a5)
      dst++;
    8000195e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001960:	fed797e3          	bne	a5,a3,8000194e <copyinstr+0x8a>
    80001964:	b765                	j	8000190c <copyinstr+0x48>
    80001966:	4781                	li	a5,0
    80001968:	b761                	j	800018f0 <copyinstr+0x2c>
      return -1;
    8000196a:	557d                	li	a0,-1
    8000196c:	b769                	j	800018f6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000196e:	6b85                	lui	s7,0x1
    80001970:	9ba6                	add	s7,s7,s1
    80001972:	87da                	mv	a5,s6
    80001974:	b76d                	j	8000191e <copyinstr+0x5a>
  int got_null = 0;
    80001976:	4781                	li	a5,0
  if(got_null){
    80001978:	37fd                	addiw	a5,a5,-1
    8000197a:	0007851b          	sext.w	a0,a5
}
    8000197e:	8082                	ret

0000000080001980 <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    80001980:	715d                	addi	sp,sp,-80
    80001982:	e486                	sd	ra,72(sp)
    80001984:	e0a2                	sd	s0,64(sp)
    80001986:	fc26                	sd	s1,56(sp)
    80001988:	f84a                	sd	s2,48(sp)
    8000198a:	f44e                	sd	s3,40(sp)
    8000198c:	f052                	sd	s4,32(sp)
    8000198e:	ec56                	sd	s5,24(sp)
    80001990:	e85a                	sd	s6,16(sp)
    80001992:	e45e                	sd	s7,8(sp)
    80001994:	e062                	sd	s8,0(sp)
    80001996:	0880                	addi	s0,sp,80
    asm volatile("mv %0, tp" : "=r"(x));
    80001998:	8792                	mv	a5,tp
    int id = r_tp();
    8000199a:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    8000199c:	00012a97          	auipc	s5,0x12
    800019a0:	db4a8a93          	addi	s5,s5,-588 # 80013750 <cpus>
    800019a4:	00779713          	slli	a4,a5,0x7
    800019a8:	00ea86b3          	add	a3,s5,a4
    800019ac:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffda6a0>
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    800019b0:	0721                	addi	a4,a4,8
    800019b2:	9aba                	add	s5,s5,a4
                c->proc = p;
    800019b4:	8936                	mv	s2,a3
                // check if we are still the right scheduler (or if schedset changed)
                if (sched_pointer != &rr_scheduler)
    800019b6:	0000ac17          	auipc	s8,0xa
    800019ba:	a52c0c13          	addi	s8,s8,-1454 # 8000b408 <sched_pointer>
    800019be:	00000b97          	auipc	s7,0x0
    800019c2:	fc2b8b93          	addi	s7,s7,-62 # 80001980 <rr_scheduler>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800019c6:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019ca:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800019ce:	10079073          	csrw	sstatus,a5
        for (p = proc; p < &proc[NPROC]; p++)
    800019d2:	00012497          	auipc	s1,0x12
    800019d6:	1ae48493          	addi	s1,s1,430 # 80013b80 <proc>
            if (p->state == RUNNABLE)
    800019da:	498d                	li	s3,3
                p->state = RUNNING;
    800019dc:	4b11                	li	s6,4
        for (p = proc; p < &proc[NPROC]; p++)
    800019de:	00018a17          	auipc	s4,0x18
    800019e2:	ba2a0a13          	addi	s4,s4,-1118 # 80019580 <tickslock>
    800019e6:	a81d                	j	80001a1c <rr_scheduler+0x9c>
                {
                    release(&p->lock);
    800019e8:	8526                	mv	a0,s1
    800019ea:	fffff097          	auipc	ra,0xfffff
    800019ee:	3ca080e7          	jalr	970(ra) # 80000db4 <release>
                c->proc = 0;
            }
            release(&p->lock);
        }
    }
}
    800019f2:	60a6                	ld	ra,72(sp)
    800019f4:	6406                	ld	s0,64(sp)
    800019f6:	74e2                	ld	s1,56(sp)
    800019f8:	7942                	ld	s2,48(sp)
    800019fa:	79a2                	ld	s3,40(sp)
    800019fc:	7a02                	ld	s4,32(sp)
    800019fe:	6ae2                	ld	s5,24(sp)
    80001a00:	6b42                	ld	s6,16(sp)
    80001a02:	6ba2                	ld	s7,8(sp)
    80001a04:	6c02                	ld	s8,0(sp)
    80001a06:	6161                	addi	sp,sp,80
    80001a08:	8082                	ret
            release(&p->lock);
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	3a8080e7          	jalr	936(ra) # 80000db4 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001a14:	16848493          	addi	s1,s1,360
    80001a18:	fb4487e3          	beq	s1,s4,800019c6 <rr_scheduler+0x46>
            acquire(&p->lock);
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	2e2080e7          	jalr	738(ra) # 80000d00 <acquire>
            if (p->state == RUNNABLE)
    80001a26:	4c9c                	lw	a5,24(s1)
    80001a28:	ff3791e3          	bne	a5,s3,80001a0a <rr_scheduler+0x8a>
                p->state = RUNNING;
    80001a2c:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    80001a30:	00993023          	sd	s1,0(s2)
                swtch(&c->context, &p->context);
    80001a34:	06048593          	addi	a1,s1,96
    80001a38:	8556                	mv	a0,s5
    80001a3a:	00001097          	auipc	ra,0x1
    80001a3e:	fc4080e7          	jalr	-60(ra) # 800029fe <swtch>
                if (sched_pointer != &rr_scheduler)
    80001a42:	000c3783          	ld	a5,0(s8)
    80001a46:	fb7791e3          	bne	a5,s7,800019e8 <rr_scheduler+0x68>
                c->proc = 0;
    80001a4a:	00093023          	sd	zero,0(s2)
    80001a4e:	bf75                	j	80001a0a <rr_scheduler+0x8a>

0000000080001a50 <proc_mapstacks>:
{
    80001a50:	7139                	addi	sp,sp,-64
    80001a52:	fc06                	sd	ra,56(sp)
    80001a54:	f822                	sd	s0,48(sp)
    80001a56:	f426                	sd	s1,40(sp)
    80001a58:	f04a                	sd	s2,32(sp)
    80001a5a:	ec4e                	sd	s3,24(sp)
    80001a5c:	e852                	sd	s4,16(sp)
    80001a5e:	e456                	sd	s5,8(sp)
    80001a60:	e05a                	sd	s6,0(sp)
    80001a62:	0080                	addi	s0,sp,64
    80001a64:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001a66:	00012497          	auipc	s1,0x12
    80001a6a:	11a48493          	addi	s1,s1,282 # 80013b80 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001a6e:	8b26                	mv	s6,s1
    80001a70:	04fa5937          	lui	s2,0x4fa5
    80001a74:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001a78:	0932                	slli	s2,s2,0xc
    80001a7a:	fa590913          	addi	s2,s2,-91
    80001a7e:	0932                	slli	s2,s2,0xc
    80001a80:	fa590913          	addi	s2,s2,-91
    80001a84:	0932                	slli	s2,s2,0xc
    80001a86:	fa590913          	addi	s2,s2,-91
    80001a8a:	040009b7          	lui	s3,0x4000
    80001a8e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a90:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001a92:	00018a97          	auipc	s5,0x18
    80001a96:	aeea8a93          	addi	s5,s5,-1298 # 80019580 <tickslock>
        char *pa = kalloc();
    80001a9a:	fffff097          	auipc	ra,0xfffff
    80001a9e:	12a080e7          	jalr	298(ra) # 80000bc4 <kalloc>
    80001aa2:	862a                	mv	a2,a0
        if (pa == 0)
    80001aa4:	c121                	beqz	a0,80001ae4 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80001aa6:	416485b3          	sub	a1,s1,s6
    80001aaa:	858d                	srai	a1,a1,0x3
    80001aac:	032585b3          	mul	a1,a1,s2
    80001ab0:	2585                	addiw	a1,a1,1
    80001ab2:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ab6:	4719                	li	a4,6
    80001ab8:	6685                	lui	a3,0x1
    80001aba:	40b985b3          	sub	a1,s3,a1
    80001abe:	8552                	mv	a0,s4
    80001ac0:	fffff097          	auipc	ra,0xfffff
    80001ac4:	7a0080e7          	jalr	1952(ra) # 80001260 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001ac8:	16848493          	addi	s1,s1,360
    80001acc:	fd5497e3          	bne	s1,s5,80001a9a <proc_mapstacks+0x4a>
}
    80001ad0:	70e2                	ld	ra,56(sp)
    80001ad2:	7442                	ld	s0,48(sp)
    80001ad4:	74a2                	ld	s1,40(sp)
    80001ad6:	7902                	ld	s2,32(sp)
    80001ad8:	69e2                	ld	s3,24(sp)
    80001ada:	6a42                	ld	s4,16(sp)
    80001adc:	6aa2                	ld	s5,8(sp)
    80001ade:	6b02                	ld	s6,0(sp)
    80001ae0:	6121                	addi	sp,sp,64
    80001ae2:	8082                	ret
            panic("kalloc");
    80001ae4:	00006517          	auipc	a0,0x6
    80001ae8:	71450513          	addi	a0,a0,1812 # 800081f8 <__func__.1+0x1f0>
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	a74080e7          	jalr	-1420(ra) # 80000560 <panic>

0000000080001af4 <procinit>:
{
    80001af4:	7139                	addi	sp,sp,-64
    80001af6:	fc06                	sd	ra,56(sp)
    80001af8:	f822                	sd	s0,48(sp)
    80001afa:	f426                	sd	s1,40(sp)
    80001afc:	f04a                	sd	s2,32(sp)
    80001afe:	ec4e                	sd	s3,24(sp)
    80001b00:	e852                	sd	s4,16(sp)
    80001b02:	e456                	sd	s5,8(sp)
    80001b04:	e05a                	sd	s6,0(sp)
    80001b06:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001b08:	00006597          	auipc	a1,0x6
    80001b0c:	6f858593          	addi	a1,a1,1784 # 80008200 <__func__.1+0x1f8>
    80001b10:	00012517          	auipc	a0,0x12
    80001b14:	04050513          	addi	a0,a0,64 # 80013b50 <pid_lock>
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	158080e7          	jalr	344(ra) # 80000c70 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001b20:	00006597          	auipc	a1,0x6
    80001b24:	6e858593          	addi	a1,a1,1768 # 80008208 <__func__.1+0x200>
    80001b28:	00012517          	auipc	a0,0x12
    80001b2c:	04050513          	addi	a0,a0,64 # 80013b68 <wait_lock>
    80001b30:	fffff097          	auipc	ra,0xfffff
    80001b34:	140080e7          	jalr	320(ra) # 80000c70 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b38:	00012497          	auipc	s1,0x12
    80001b3c:	04848493          	addi	s1,s1,72 # 80013b80 <proc>
        initlock(&p->lock, "proc");
    80001b40:	00006b17          	auipc	s6,0x6
    80001b44:	6d8b0b13          	addi	s6,s6,1752 # 80008218 <__func__.1+0x210>
        p->kstack = KSTACK((int)(p - proc));
    80001b48:	8aa6                	mv	s5,s1
    80001b4a:	04fa5937          	lui	s2,0x4fa5
    80001b4e:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001b52:	0932                	slli	s2,s2,0xc
    80001b54:	fa590913          	addi	s2,s2,-91
    80001b58:	0932                	slli	s2,s2,0xc
    80001b5a:	fa590913          	addi	s2,s2,-91
    80001b5e:	0932                	slli	s2,s2,0xc
    80001b60:	fa590913          	addi	s2,s2,-91
    80001b64:	040009b7          	lui	s3,0x4000
    80001b68:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b6a:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001b6c:	00018a17          	auipc	s4,0x18
    80001b70:	a14a0a13          	addi	s4,s4,-1516 # 80019580 <tickslock>
        initlock(&p->lock, "proc");
    80001b74:	85da                	mv	a1,s6
    80001b76:	8526                	mv	a0,s1
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	0f8080e7          	jalr	248(ra) # 80000c70 <initlock>
        p->state = UNUSED;
    80001b80:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001b84:	415487b3          	sub	a5,s1,s5
    80001b88:	878d                	srai	a5,a5,0x3
    80001b8a:	032787b3          	mul	a5,a5,s2
    80001b8e:	2785                	addiw	a5,a5,1
    80001b90:	00d7979b          	slliw	a5,a5,0xd
    80001b94:	40f987b3          	sub	a5,s3,a5
    80001b98:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001b9a:	16848493          	addi	s1,s1,360
    80001b9e:	fd449be3          	bne	s1,s4,80001b74 <procinit+0x80>
}
    80001ba2:	70e2                	ld	ra,56(sp)
    80001ba4:	7442                	ld	s0,48(sp)
    80001ba6:	74a2                	ld	s1,40(sp)
    80001ba8:	7902                	ld	s2,32(sp)
    80001baa:	69e2                	ld	s3,24(sp)
    80001bac:	6a42                	ld	s4,16(sp)
    80001bae:	6aa2                	ld	s5,8(sp)
    80001bb0:	6b02                	ld	s6,0(sp)
    80001bb2:	6121                	addi	sp,sp,64
    80001bb4:	8082                	ret

0000000080001bb6 <copy_array>:
{
    80001bb6:	1141                	addi	sp,sp,-16
    80001bb8:	e422                	sd	s0,8(sp)
    80001bba:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001bbc:	00c05c63          	blez	a2,80001bd4 <copy_array+0x1e>
    80001bc0:	87aa                	mv	a5,a0
    80001bc2:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001bc4:	0007c703          	lbu	a4,0(a5)
    80001bc8:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001bcc:	0785                	addi	a5,a5,1
    80001bce:	0585                	addi	a1,a1,1
    80001bd0:	fea79ae3          	bne	a5,a0,80001bc4 <copy_array+0xe>
}
    80001bd4:	6422                	ld	s0,8(sp)
    80001bd6:	0141                	addi	sp,sp,16
    80001bd8:	8082                	ret

0000000080001bda <cpuid>:
{
    80001bda:	1141                	addi	sp,sp,-16
    80001bdc:	e422                	sd	s0,8(sp)
    80001bde:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80001be0:	8512                	mv	a0,tp
}
    80001be2:	2501                	sext.w	a0,a0
    80001be4:	6422                	ld	s0,8(sp)
    80001be6:	0141                	addi	sp,sp,16
    80001be8:	8082                	ret

0000000080001bea <mycpu>:
{
    80001bea:	1141                	addi	sp,sp,-16
    80001bec:	e422                	sd	s0,8(sp)
    80001bee:	0800                	addi	s0,sp,16
    80001bf0:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001bf2:	2781                	sext.w	a5,a5
    80001bf4:	079e                	slli	a5,a5,0x7
}
    80001bf6:	00012517          	auipc	a0,0x12
    80001bfa:	b5a50513          	addi	a0,a0,-1190 # 80013750 <cpus>
    80001bfe:	953e                	add	a0,a0,a5
    80001c00:	6422                	ld	s0,8(sp)
    80001c02:	0141                	addi	sp,sp,16
    80001c04:	8082                	ret

0000000080001c06 <myproc>:
{
    80001c06:	1101                	addi	sp,sp,-32
    80001c08:	ec06                	sd	ra,24(sp)
    80001c0a:	e822                	sd	s0,16(sp)
    80001c0c:	e426                	sd	s1,8(sp)
    80001c0e:	1000                	addi	s0,sp,32
    push_off();
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	0a4080e7          	jalr	164(ra) # 80000cb4 <push_off>
    80001c18:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001c1a:	2781                	sext.w	a5,a5
    80001c1c:	079e                	slli	a5,a5,0x7
    80001c1e:	00012717          	auipc	a4,0x12
    80001c22:	b3270713          	addi	a4,a4,-1230 # 80013750 <cpus>
    80001c26:	97ba                	add	a5,a5,a4
    80001c28:	6384                	ld	s1,0(a5)
    pop_off();
    80001c2a:	fffff097          	auipc	ra,0xfffff
    80001c2e:	12a080e7          	jalr	298(ra) # 80000d54 <pop_off>
}
    80001c32:	8526                	mv	a0,s1
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c3e:	1141                	addi	sp,sp,-16
    80001c40:	e406                	sd	ra,8(sp)
    80001c42:	e022                	sd	s0,0(sp)
    80001c44:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001c46:	00000097          	auipc	ra,0x0
    80001c4a:	fc0080e7          	jalr	-64(ra) # 80001c06 <myproc>
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	166080e7          	jalr	358(ra) # 80000db4 <release>

    if (first)
    80001c56:	00009797          	auipc	a5,0x9
    80001c5a:	7aa7a783          	lw	a5,1962(a5) # 8000b400 <first.1>
    80001c5e:	eb89                	bnez	a5,80001c70 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001c60:	00001097          	auipc	ra,0x1
    80001c64:	e48080e7          	jalr	-440(ra) # 80002aa8 <usertrapret>
}
    80001c68:	60a2                	ld	ra,8(sp)
    80001c6a:	6402                	ld	s0,0(sp)
    80001c6c:	0141                	addi	sp,sp,16
    80001c6e:	8082                	ret
        first = 0;
    80001c70:	00009797          	auipc	a5,0x9
    80001c74:	7807a823          	sw	zero,1936(a5) # 8000b400 <first.1>
        fsinit(ROOTDEV);
    80001c78:	4505                	li	a0,1
    80001c7a:	00002097          	auipc	ra,0x2
    80001c7e:	d14080e7          	jalr	-748(ra) # 8000398e <fsinit>
    80001c82:	bff9                	j	80001c60 <forkret+0x22>

0000000080001c84 <allocpid>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	e04a                	sd	s2,0(sp)
    80001c8e:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001c90:	00012917          	auipc	s2,0x12
    80001c94:	ec090913          	addi	s2,s2,-320 # 80013b50 <pid_lock>
    80001c98:	854a                	mv	a0,s2
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	066080e7          	jalr	102(ra) # 80000d00 <acquire>
    pid = nextpid;
    80001ca2:	00009797          	auipc	a5,0x9
    80001ca6:	76e78793          	addi	a5,a5,1902 # 8000b410 <nextpid>
    80001caa:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001cac:	0014871b          	addiw	a4,s1,1
    80001cb0:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001cb2:	854a                	mv	a0,s2
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	100080e7          	jalr	256(ra) # 80000db4 <release>
}
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	60e2                	ld	ra,24(sp)
    80001cc0:	6442                	ld	s0,16(sp)
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	6902                	ld	s2,0(sp)
    80001cc6:	6105                	addi	sp,sp,32
    80001cc8:	8082                	ret

0000000080001cca <proc_pagetable>:
{
    80001cca:	1101                	addi	sp,sp,-32
    80001ccc:	ec06                	sd	ra,24(sp)
    80001cce:	e822                	sd	s0,16(sp)
    80001cd0:	e426                	sd	s1,8(sp)
    80001cd2:	e04a                	sd	s2,0(sp)
    80001cd4:	1000                	addi	s0,sp,32
    80001cd6:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	782080e7          	jalr	1922(ra) # 8000145a <uvmcreate>
    80001ce0:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001ce2:	c121                	beqz	a0,80001d22 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ce4:	4729                	li	a4,10
    80001ce6:	00005697          	auipc	a3,0x5
    80001cea:	31a68693          	addi	a3,a3,794 # 80007000 <_trampoline>
    80001cee:	6605                	lui	a2,0x1
    80001cf0:	040005b7          	lui	a1,0x4000
    80001cf4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cf6:	05b2                	slli	a1,a1,0xc
    80001cf8:	fffff097          	auipc	ra,0xfffff
    80001cfc:	4c8080e7          	jalr	1224(ra) # 800011c0 <mappages>
    80001d00:	02054863          	bltz	a0,80001d30 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d04:	4719                	li	a4,6
    80001d06:	05893683          	ld	a3,88(s2)
    80001d0a:	6605                	lui	a2,0x1
    80001d0c:	020005b7          	lui	a1,0x2000
    80001d10:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d12:	05b6                	slli	a1,a1,0xd
    80001d14:	8526                	mv	a0,s1
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	4aa080e7          	jalr	1194(ra) # 800011c0 <mappages>
    80001d1e:	02054163          	bltz	a0,80001d40 <proc_pagetable+0x76>
}
    80001d22:	8526                	mv	a0,s1
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	64a2                	ld	s1,8(sp)
    80001d2a:	6902                	ld	s2,0(sp)
    80001d2c:	6105                	addi	sp,sp,32
    80001d2e:	8082                	ret
        uvmfree(pagetable, 0);
    80001d30:	4581                	li	a1,0
    80001d32:	8526                	mv	a0,s1
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	938080e7          	jalr	-1736(ra) # 8000166c <uvmfree>
        return 0;
    80001d3c:	4481                	li	s1,0
    80001d3e:	b7d5                	j	80001d22 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d40:	4681                	li	a3,0
    80001d42:	4605                	li	a2,1
    80001d44:	040005b7          	lui	a1,0x4000
    80001d48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d4a:	05b2                	slli	a1,a1,0xc
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	638080e7          	jalr	1592(ra) # 80001386 <uvmunmap>
        uvmfree(pagetable, 0);
    80001d56:	4581                	li	a1,0
    80001d58:	8526                	mv	a0,s1
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	912080e7          	jalr	-1774(ra) # 8000166c <uvmfree>
        return 0;
    80001d62:	4481                	li	s1,0
    80001d64:	bf7d                	j	80001d22 <proc_pagetable+0x58>

0000000080001d66 <proc_freepagetable>:
{
    80001d66:	1101                	addi	sp,sp,-32
    80001d68:	ec06                	sd	ra,24(sp)
    80001d6a:	e822                	sd	s0,16(sp)
    80001d6c:	e426                	sd	s1,8(sp)
    80001d6e:	e04a                	sd	s2,0(sp)
    80001d70:	1000                	addi	s0,sp,32
    80001d72:	84aa                	mv	s1,a0
    80001d74:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d76:	4681                	li	a3,0
    80001d78:	4605                	li	a2,1
    80001d7a:	040005b7          	lui	a1,0x4000
    80001d7e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d80:	05b2                	slli	a1,a1,0xc
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	604080e7          	jalr	1540(ra) # 80001386 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d8a:	4681                	li	a3,0
    80001d8c:	4605                	li	a2,1
    80001d8e:	020005b7          	lui	a1,0x2000
    80001d92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d94:	05b6                	slli	a1,a1,0xd
    80001d96:	8526                	mv	a0,s1
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	5ee080e7          	jalr	1518(ra) # 80001386 <uvmunmap>
    uvmfree(pagetable, sz);
    80001da0:	85ca                	mv	a1,s2
    80001da2:	8526                	mv	a0,s1
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	8c8080e7          	jalr	-1848(ra) # 8000166c <uvmfree>
}
    80001dac:	60e2                	ld	ra,24(sp)
    80001dae:	6442                	ld	s0,16(sp)
    80001db0:	64a2                	ld	s1,8(sp)
    80001db2:	6902                	ld	s2,0(sp)
    80001db4:	6105                	addi	sp,sp,32
    80001db6:	8082                	ret

0000000080001db8 <freeproc>:
{
    80001db8:	1101                	addi	sp,sp,-32
    80001dba:	ec06                	sd	ra,24(sp)
    80001dbc:	e822                	sd	s0,16(sp)
    80001dbe:	e426                	sd	s1,8(sp)
    80001dc0:	1000                	addi	s0,sp,32
    80001dc2:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001dc4:	6d28                	ld	a0,88(a0)
    80001dc6:	c509                	beqz	a0,80001dd0 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	c94080e7          	jalr	-876(ra) # 80000a5c <kfree>
    p->trapframe = 0;
    80001dd0:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001dd4:	68a8                	ld	a0,80(s1)
    80001dd6:	c511                	beqz	a0,80001de2 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001dd8:	64ac                	ld	a1,72(s1)
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	f8c080e7          	jalr	-116(ra) # 80001d66 <proc_freepagetable>
    p->pagetable = 0;
    80001de2:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001de6:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001dea:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001dee:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001df2:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001df6:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001dfa:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001dfe:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001e02:	0004ac23          	sw	zero,24(s1)
}
    80001e06:	60e2                	ld	ra,24(sp)
    80001e08:	6442                	ld	s0,16(sp)
    80001e0a:	64a2                	ld	s1,8(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret

0000000080001e10 <allocproc>:
{
    80001e10:	1101                	addi	sp,sp,-32
    80001e12:	ec06                	sd	ra,24(sp)
    80001e14:	e822                	sd	s0,16(sp)
    80001e16:	e426                	sd	s1,8(sp)
    80001e18:	e04a                	sd	s2,0(sp)
    80001e1a:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001e1c:	00012497          	auipc	s1,0x12
    80001e20:	d6448493          	addi	s1,s1,-668 # 80013b80 <proc>
    80001e24:	00017917          	auipc	s2,0x17
    80001e28:	75c90913          	addi	s2,s2,1884 # 80019580 <tickslock>
        acquire(&p->lock);
    80001e2c:	8526                	mv	a0,s1
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	ed2080e7          	jalr	-302(ra) # 80000d00 <acquire>
        if (p->state == UNUSED)
    80001e36:	4c9c                	lw	a5,24(s1)
    80001e38:	cf81                	beqz	a5,80001e50 <allocproc+0x40>
            release(&p->lock);
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	f78080e7          	jalr	-136(ra) # 80000db4 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001e44:	16848493          	addi	s1,s1,360
    80001e48:	ff2492e3          	bne	s1,s2,80001e2c <allocproc+0x1c>
    return 0;
    80001e4c:	4481                	li	s1,0
    80001e4e:	a889                	j	80001ea0 <allocproc+0x90>
    p->pid = allocpid();
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	e34080e7          	jalr	-460(ra) # 80001c84 <allocpid>
    80001e58:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001e5a:	4785                	li	a5,1
    80001e5c:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	d66080e7          	jalr	-666(ra) # 80000bc4 <kalloc>
    80001e66:	892a                	mv	s2,a0
    80001e68:	eca8                	sd	a0,88(s1)
    80001e6a:	c131                	beqz	a0,80001eae <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80001e6c:	8526                	mv	a0,s1
    80001e6e:	00000097          	auipc	ra,0x0
    80001e72:	e5c080e7          	jalr	-420(ra) # 80001cca <proc_pagetable>
    80001e76:	892a                	mv	s2,a0
    80001e78:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001e7a:	c531                	beqz	a0,80001ec6 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80001e7c:	07000613          	li	a2,112
    80001e80:	4581                	li	a1,0
    80001e82:	06048513          	addi	a0,s1,96
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	f76080e7          	jalr	-138(ra) # 80000dfc <memset>
    p->context.ra = (uint64)forkret;
    80001e8e:	00000797          	auipc	a5,0x0
    80001e92:	db078793          	addi	a5,a5,-592 # 80001c3e <forkret>
    80001e96:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001e98:	60bc                	ld	a5,64(s1)
    80001e9a:	6705                	lui	a4,0x1
    80001e9c:	97ba                	add	a5,a5,a4
    80001e9e:	f4bc                	sd	a5,104(s1)
}
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	60e2                	ld	ra,24(sp)
    80001ea4:	6442                	ld	s0,16(sp)
    80001ea6:	64a2                	ld	s1,8(sp)
    80001ea8:	6902                	ld	s2,0(sp)
    80001eaa:	6105                	addi	sp,sp,32
    80001eac:	8082                	ret
        freeproc(p);
    80001eae:	8526                	mv	a0,s1
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	f08080e7          	jalr	-248(ra) # 80001db8 <freeproc>
        release(&p->lock);
    80001eb8:	8526                	mv	a0,s1
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	efa080e7          	jalr	-262(ra) # 80000db4 <release>
        return 0;
    80001ec2:	84ca                	mv	s1,s2
    80001ec4:	bff1                	j	80001ea0 <allocproc+0x90>
        freeproc(p);
    80001ec6:	8526                	mv	a0,s1
    80001ec8:	00000097          	auipc	ra,0x0
    80001ecc:	ef0080e7          	jalr	-272(ra) # 80001db8 <freeproc>
        release(&p->lock);
    80001ed0:	8526                	mv	a0,s1
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	ee2080e7          	jalr	-286(ra) # 80000db4 <release>
        return 0;
    80001eda:	84ca                	mv	s1,s2
    80001edc:	b7d1                	j	80001ea0 <allocproc+0x90>

0000000080001ede <userinit>:
{
    80001ede:	1101                	addi	sp,sp,-32
    80001ee0:	ec06                	sd	ra,24(sp)
    80001ee2:	e822                	sd	s0,16(sp)
    80001ee4:	e426                	sd	s1,8(sp)
    80001ee6:	1000                	addi	s0,sp,32
    p = allocproc();
    80001ee8:	00000097          	auipc	ra,0x0
    80001eec:	f28080e7          	jalr	-216(ra) # 80001e10 <allocproc>
    80001ef0:	84aa                	mv	s1,a0
    initproc = p;
    80001ef2:	00009797          	auipc	a5,0x9
    80001ef6:	5ea7b323          	sd	a0,1510(a5) # 8000b4d8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001efa:	03400613          	li	a2,52
    80001efe:	00009597          	auipc	a1,0x9
    80001f02:	52258593          	addi	a1,a1,1314 # 8000b420 <initcode>
    80001f06:	6928                	ld	a0,80(a0)
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	580080e7          	jalr	1408(ra) # 80001488 <uvmfirst>
    p->sz = PGSIZE;
    80001f10:	6785                	lui	a5,0x1
    80001f12:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001f14:	6cb8                	ld	a4,88(s1)
    80001f16:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001f1a:	6cb8                	ld	a4,88(s1)
    80001f1c:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f1e:	4641                	li	a2,16
    80001f20:	00006597          	auipc	a1,0x6
    80001f24:	30058593          	addi	a1,a1,768 # 80008220 <__func__.1+0x218>
    80001f28:	15848513          	addi	a0,s1,344
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	012080e7          	jalr	18(ra) # 80000f3e <safestrcpy>
    p->cwd = namei("/");
    80001f34:	00006517          	auipc	a0,0x6
    80001f38:	2fc50513          	addi	a0,a0,764 # 80008230 <__func__.1+0x228>
    80001f3c:	00002097          	auipc	ra,0x2
    80001f40:	4a4080e7          	jalr	1188(ra) # 800043e0 <namei>
    80001f44:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001f48:	478d                	li	a5,3
    80001f4a:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	e66080e7          	jalr	-410(ra) # 80000db4 <release>
}
    80001f56:	60e2                	ld	ra,24(sp)
    80001f58:	6442                	ld	s0,16(sp)
    80001f5a:	64a2                	ld	s1,8(sp)
    80001f5c:	6105                	addi	sp,sp,32
    80001f5e:	8082                	ret

0000000080001f60 <growproc>:
{
    80001f60:	1101                	addi	sp,sp,-32
    80001f62:	ec06                	sd	ra,24(sp)
    80001f64:	e822                	sd	s0,16(sp)
    80001f66:	e426                	sd	s1,8(sp)
    80001f68:	e04a                	sd	s2,0(sp)
    80001f6a:	1000                	addi	s0,sp,32
    80001f6c:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	c98080e7          	jalr	-872(ra) # 80001c06 <myproc>
    80001f76:	84aa                	mv	s1,a0
    sz = p->sz;
    80001f78:	652c                	ld	a1,72(a0)
    if (n > 0)
    80001f7a:	01204c63          	bgtz	s2,80001f92 <growproc+0x32>
    else if (n < 0)
    80001f7e:	02094663          	bltz	s2,80001faa <growproc+0x4a>
    p->sz = sz;
    80001f82:	e4ac                	sd	a1,72(s1)
    return 0;
    80001f84:	4501                	li	a0,0
}
    80001f86:	60e2                	ld	ra,24(sp)
    80001f88:	6442                	ld	s0,16(sp)
    80001f8a:	64a2                	ld	s1,8(sp)
    80001f8c:	6902                	ld	s2,0(sp)
    80001f8e:	6105                	addi	sp,sp,32
    80001f90:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001f92:	4691                	li	a3,4
    80001f94:	00b90633          	add	a2,s2,a1
    80001f98:	6928                	ld	a0,80(a0)
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	5a8080e7          	jalr	1448(ra) # 80001542 <uvmalloc>
    80001fa2:	85aa                	mv	a1,a0
    80001fa4:	fd79                	bnez	a0,80001f82 <growproc+0x22>
            return -1;
    80001fa6:	557d                	li	a0,-1
    80001fa8:	bff9                	j	80001f86 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001faa:	00b90633          	add	a2,s2,a1
    80001fae:	6928                	ld	a0,80(a0)
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	54a080e7          	jalr	1354(ra) # 800014fa <uvmdealloc>
    80001fb8:	85aa                	mv	a1,a0
    80001fba:	b7e1                	j	80001f82 <growproc+0x22>

0000000080001fbc <ps>:
{
    80001fbc:	715d                	addi	sp,sp,-80
    80001fbe:	e486                	sd	ra,72(sp)
    80001fc0:	e0a2                	sd	s0,64(sp)
    80001fc2:	fc26                	sd	s1,56(sp)
    80001fc4:	f84a                	sd	s2,48(sp)
    80001fc6:	f44e                	sd	s3,40(sp)
    80001fc8:	f052                	sd	s4,32(sp)
    80001fca:	ec56                	sd	s5,24(sp)
    80001fcc:	e85a                	sd	s6,16(sp)
    80001fce:	e45e                	sd	s7,8(sp)
    80001fd0:	e062                	sd	s8,0(sp)
    80001fd2:	0880                	addi	s0,sp,80
    80001fd4:	84aa                	mv	s1,a0
    80001fd6:	8bae                	mv	s7,a1
    void *result = (void *)myproc()->sz;
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	c2e080e7          	jalr	-978(ra) # 80001c06 <myproc>
        return result;
    80001fe0:	4901                	li	s2,0
    if (count == 0)
    80001fe2:	0c0b8663          	beqz	s7,800020ae <ps+0xf2>
    void *result = (void *)myproc()->sz;
    80001fe6:	04853b03          	ld	s6,72(a0)
    if (growproc(count * sizeof(struct user_proc)) < 0)
    80001fea:	003b951b          	slliw	a0,s7,0x3
    80001fee:	0175053b          	addw	a0,a0,s7
    80001ff2:	0025151b          	slliw	a0,a0,0x2
    80001ff6:	2501                	sext.w	a0,a0
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	f68080e7          	jalr	-152(ra) # 80001f60 <growproc>
    80002000:	12054f63          	bltz	a0,8000213e <ps+0x182>
    struct user_proc loc_result[count];
    80002004:	003b9a13          	slli	s4,s7,0x3
    80002008:	9a5e                	add	s4,s4,s7
    8000200a:	0a0a                	slli	s4,s4,0x2
    8000200c:	00fa0793          	addi	a5,s4,15
    80002010:	8391                	srli	a5,a5,0x4
    80002012:	0792                	slli	a5,a5,0x4
    80002014:	40f10133          	sub	sp,sp,a5
    80002018:	8a8a                	mv	s5,sp
    struct proc *p = proc + start;
    8000201a:	16800793          	li	a5,360
    8000201e:	02f484b3          	mul	s1,s1,a5
    80002022:	00012797          	auipc	a5,0x12
    80002026:	b5e78793          	addi	a5,a5,-1186 # 80013b80 <proc>
    8000202a:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    8000202c:	00017797          	auipc	a5,0x17
    80002030:	55478793          	addi	a5,a5,1364 # 80019580 <tickslock>
        return result;
    80002034:	4901                	li	s2,0
    if (p >= &proc[NPROC])
    80002036:	06f4fc63          	bgeu	s1,a5,800020ae <ps+0xf2>
    acquire(&wait_lock);
    8000203a:	00012517          	auipc	a0,0x12
    8000203e:	b2e50513          	addi	a0,a0,-1234 # 80013b68 <wait_lock>
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	cbe080e7          	jalr	-834(ra) # 80000d00 <acquire>
        if (localCount == count)
    8000204a:	014a8913          	addi	s2,s5,20
    uint8 localCount = 0;
    8000204e:	4981                	li	s3,0
    for (; p < &proc[NPROC]; p++)
    80002050:	00017c17          	auipc	s8,0x17
    80002054:	530c0c13          	addi	s8,s8,1328 # 80019580 <tickslock>
    80002058:	a851                	j	800020ec <ps+0x130>
            loc_result[localCount].state = UNUSED;
    8000205a:	00399793          	slli	a5,s3,0x3
    8000205e:	97ce                	add	a5,a5,s3
    80002060:	078a                	slli	a5,a5,0x2
    80002062:	97d6                	add	a5,a5,s5
    80002064:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80002068:	8526                	mv	a0,s1
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	d4a080e7          	jalr	-694(ra) # 80000db4 <release>
    release(&wait_lock);
    80002072:	00012517          	auipc	a0,0x12
    80002076:	af650513          	addi	a0,a0,-1290 # 80013b68 <wait_lock>
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	d3a080e7          	jalr	-710(ra) # 80000db4 <release>
    if (localCount < count)
    80002082:	0179f963          	bgeu	s3,s7,80002094 <ps+0xd8>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80002086:	00399793          	slli	a5,s3,0x3
    8000208a:	97ce                	add	a5,a5,s3
    8000208c:	078a                	slli	a5,a5,0x2
    8000208e:	97d6                	add	a5,a5,s5
    80002090:	0007a023          	sw	zero,0(a5)
    void *result = (void *)myproc()->sz;
    80002094:	895a                	mv	s2,s6
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80002096:	00000097          	auipc	ra,0x0
    8000209a:	b70080e7          	jalr	-1168(ra) # 80001c06 <myproc>
    8000209e:	86d2                	mv	a3,s4
    800020a0:	8656                	mv	a2,s5
    800020a2:	85da                	mv	a1,s6
    800020a4:	6928                	ld	a0,80(a0)
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	704080e7          	jalr	1796(ra) # 800017aa <copyout>
}
    800020ae:	854a                	mv	a0,s2
    800020b0:	fb040113          	addi	sp,s0,-80
    800020b4:	60a6                	ld	ra,72(sp)
    800020b6:	6406                	ld	s0,64(sp)
    800020b8:	74e2                	ld	s1,56(sp)
    800020ba:	7942                	ld	s2,48(sp)
    800020bc:	79a2                	ld	s3,40(sp)
    800020be:	7a02                	ld	s4,32(sp)
    800020c0:	6ae2                	ld	s5,24(sp)
    800020c2:	6b42                	ld	s6,16(sp)
    800020c4:	6ba2                	ld	s7,8(sp)
    800020c6:	6c02                	ld	s8,0(sp)
    800020c8:	6161                	addi	sp,sp,80
    800020ca:	8082                	ret
        release(&p->lock);
    800020cc:	8526                	mv	a0,s1
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	ce6080e7          	jalr	-794(ra) # 80000db4 <release>
        localCount++;
    800020d6:	2985                	addiw	s3,s3,1
    800020d8:	0ff9f993          	zext.b	s3,s3
    for (; p < &proc[NPROC]; p++)
    800020dc:	16848493          	addi	s1,s1,360
    800020e0:	f984f9e3          	bgeu	s1,s8,80002072 <ps+0xb6>
        if (localCount == count)
    800020e4:	02490913          	addi	s2,s2,36
    800020e8:	053b8d63          	beq	s7,s3,80002142 <ps+0x186>
        acquire(&p->lock);
    800020ec:	8526                	mv	a0,s1
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	c12080e7          	jalr	-1006(ra) # 80000d00 <acquire>
        if (p->state == UNUSED)
    800020f6:	4c9c                	lw	a5,24(s1)
    800020f8:	d3ad                	beqz	a5,8000205a <ps+0x9e>
        loc_result[localCount].state = p->state;
    800020fa:	fef92623          	sw	a5,-20(s2)
        loc_result[localCount].killed = p->killed;
    800020fe:	549c                	lw	a5,40(s1)
    80002100:	fef92823          	sw	a5,-16(s2)
        loc_result[localCount].xstate = p->xstate;
    80002104:	54dc                	lw	a5,44(s1)
    80002106:	fef92a23          	sw	a5,-12(s2)
        loc_result[localCount].pid = p->pid;
    8000210a:	589c                	lw	a5,48(s1)
    8000210c:	fef92c23          	sw	a5,-8(s2)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002110:	4641                	li	a2,16
    80002112:	85ca                	mv	a1,s2
    80002114:	15848513          	addi	a0,s1,344
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	a9e080e7          	jalr	-1378(ra) # 80001bb6 <copy_array>
        if (p->parent != 0) // init
    80002120:	7c88                	ld	a0,56(s1)
    80002122:	d54d                	beqz	a0,800020cc <ps+0x110>
            acquire(&p->parent->lock);
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	bdc080e7          	jalr	-1060(ra) # 80000d00 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    8000212c:	7c88                	ld	a0,56(s1)
    8000212e:	591c                	lw	a5,48(a0)
    80002130:	fef92e23          	sw	a5,-4(s2)
            release(&p->parent->lock);
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	c80080e7          	jalr	-896(ra) # 80000db4 <release>
    8000213c:	bf41                	j	800020cc <ps+0x110>
        return result;
    8000213e:	4901                	li	s2,0
    80002140:	b7bd                	j	800020ae <ps+0xf2>
    release(&wait_lock);
    80002142:	00012517          	auipc	a0,0x12
    80002146:	a2650513          	addi	a0,a0,-1498 # 80013b68 <wait_lock>
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	c6a080e7          	jalr	-918(ra) # 80000db4 <release>
    if (localCount < count)
    80002152:	b789                	j	80002094 <ps+0xd8>

0000000080002154 <fork>:
{
    80002154:	7139                	addi	sp,sp,-64
    80002156:	fc06                	sd	ra,56(sp)
    80002158:	f822                	sd	s0,48(sp)
    8000215a:	f04a                	sd	s2,32(sp)
    8000215c:	e456                	sd	s5,8(sp)
    8000215e:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002160:	00000097          	auipc	ra,0x0
    80002164:	aa6080e7          	jalr	-1370(ra) # 80001c06 <myproc>
    80002168:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	ca6080e7          	jalr	-858(ra) # 80001e10 <allocproc>
    80002172:	12050063          	beqz	a0,80002292 <fork+0x13e>
    80002176:	e852                	sd	s4,16(sp)
    80002178:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000217a:	048ab603          	ld	a2,72(s5)
    8000217e:	692c                	ld	a1,80(a0)
    80002180:	050ab503          	ld	a0,80(s5)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	522080e7          	jalr	1314(ra) # 800016a6 <uvmcopy>
    8000218c:	04054a63          	bltz	a0,800021e0 <fork+0x8c>
    80002190:	f426                	sd	s1,40(sp)
    80002192:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    80002194:	048ab783          	ld	a5,72(s5)
    80002198:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    8000219c:	058ab683          	ld	a3,88(s5)
    800021a0:	87b6                	mv	a5,a3
    800021a2:	058a3703          	ld	a4,88(s4)
    800021a6:	12068693          	addi	a3,a3,288
    800021aa:	0007b803          	ld	a6,0(a5)
    800021ae:	6788                	ld	a0,8(a5)
    800021b0:	6b8c                	ld	a1,16(a5)
    800021b2:	6f90                	ld	a2,24(a5)
    800021b4:	01073023          	sd	a6,0(a4)
    800021b8:	e708                	sd	a0,8(a4)
    800021ba:	eb0c                	sd	a1,16(a4)
    800021bc:	ef10                	sd	a2,24(a4)
    800021be:	02078793          	addi	a5,a5,32
    800021c2:	02070713          	addi	a4,a4,32
    800021c6:	fed792e3          	bne	a5,a3,800021aa <fork+0x56>
    np->trapframe->a0 = 0;
    800021ca:	058a3783          	ld	a5,88(s4)
    800021ce:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800021d2:	0d0a8493          	addi	s1,s5,208
    800021d6:	0d0a0913          	addi	s2,s4,208
    800021da:	150a8993          	addi	s3,s5,336
    800021de:	a015                	j	80002202 <fork+0xae>
        freeproc(np);
    800021e0:	8552                	mv	a0,s4
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	bd6080e7          	jalr	-1066(ra) # 80001db8 <freeproc>
        release(&np->lock);
    800021ea:	8552                	mv	a0,s4
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	bc8080e7          	jalr	-1080(ra) # 80000db4 <release>
        return -1;
    800021f4:	597d                	li	s2,-1
    800021f6:	6a42                	ld	s4,16(sp)
    800021f8:	a071                	j	80002284 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    800021fa:	04a1                	addi	s1,s1,8
    800021fc:	0921                	addi	s2,s2,8
    800021fe:	01348b63          	beq	s1,s3,80002214 <fork+0xc0>
        if (p->ofile[i])
    80002202:	6088                	ld	a0,0(s1)
    80002204:	d97d                	beqz	a0,800021fa <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    80002206:	00003097          	auipc	ra,0x3
    8000220a:	852080e7          	jalr	-1966(ra) # 80004a58 <filedup>
    8000220e:	00a93023          	sd	a0,0(s2)
    80002212:	b7e5                	j	800021fa <fork+0xa6>
    np->cwd = idup(p->cwd);
    80002214:	150ab503          	ld	a0,336(s5)
    80002218:	00002097          	auipc	ra,0x2
    8000221c:	9bc080e7          	jalr	-1604(ra) # 80003bd4 <idup>
    80002220:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002224:	4641                	li	a2,16
    80002226:	158a8593          	addi	a1,s5,344
    8000222a:	158a0513          	addi	a0,s4,344
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	d10080e7          	jalr	-752(ra) # 80000f3e <safestrcpy>
    pid = np->pid;
    80002236:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000223a:	8552                	mv	a0,s4
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	b78080e7          	jalr	-1160(ra) # 80000db4 <release>
    acquire(&wait_lock);
    80002244:	00012497          	auipc	s1,0x12
    80002248:	92448493          	addi	s1,s1,-1756 # 80013b68 <wait_lock>
    8000224c:	8526                	mv	a0,s1
    8000224e:	fffff097          	auipc	ra,0xfffff
    80002252:	ab2080e7          	jalr	-1358(ra) # 80000d00 <acquire>
    np->parent = p;
    80002256:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    8000225a:	8526                	mv	a0,s1
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	b58080e7          	jalr	-1192(ra) # 80000db4 <release>
    acquire(&np->lock);
    80002264:	8552                	mv	a0,s4
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	a9a080e7          	jalr	-1382(ra) # 80000d00 <acquire>
    np->state = RUNNABLE;
    8000226e:	478d                	li	a5,3
    80002270:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80002274:	8552                	mv	a0,s4
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	b3e080e7          	jalr	-1218(ra) # 80000db4 <release>
    return pid;
    8000227e:	74a2                	ld	s1,40(sp)
    80002280:	69e2                	ld	s3,24(sp)
    80002282:	6a42                	ld	s4,16(sp)
}
    80002284:	854a                	mv	a0,s2
    80002286:	70e2                	ld	ra,56(sp)
    80002288:	7442                	ld	s0,48(sp)
    8000228a:	7902                	ld	s2,32(sp)
    8000228c:	6aa2                	ld	s5,8(sp)
    8000228e:	6121                	addi	sp,sp,64
    80002290:	8082                	ret
        return -1;
    80002292:	597d                	li	s2,-1
    80002294:	bfc5                	j	80002284 <fork+0x130>

0000000080002296 <scheduler>:
{
    80002296:	1101                	addi	sp,sp,-32
    80002298:	ec06                	sd	ra,24(sp)
    8000229a:	e822                	sd	s0,16(sp)
    8000229c:	e426                	sd	s1,8(sp)
    8000229e:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800022a0:	00009497          	auipc	s1,0x9
    800022a4:	16848493          	addi	s1,s1,360 # 8000b408 <sched_pointer>
    800022a8:	609c                	ld	a5,0(s1)
    800022aa:	9782                	jalr	a5
    while (1)
    800022ac:	bff5                	j	800022a8 <scheduler+0x12>

00000000800022ae <sched>:
{
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	e84a                	sd	s2,16(sp)
    800022b8:	e44e                	sd	s3,8(sp)
    800022ba:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	94a080e7          	jalr	-1718(ra) # 80001c06 <myproc>
    800022c4:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	9c0080e7          	jalr	-1600(ra) # 80000c86 <holding>
    800022ce:	c53d                	beqz	a0,8000233c <sched+0x8e>
    800022d0:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800022d2:	2781                	sext.w	a5,a5
    800022d4:	079e                	slli	a5,a5,0x7
    800022d6:	00011717          	auipc	a4,0x11
    800022da:	47a70713          	addi	a4,a4,1146 # 80013750 <cpus>
    800022de:	97ba                	add	a5,a5,a4
    800022e0:	5fb8                	lw	a4,120(a5)
    800022e2:	4785                	li	a5,1
    800022e4:	06f71463          	bne	a4,a5,8000234c <sched+0x9e>
    if (p->state == RUNNING)
    800022e8:	4c98                	lw	a4,24(s1)
    800022ea:	4791                	li	a5,4
    800022ec:	06f70863          	beq	a4,a5,8000235c <sched+0xae>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800022f0:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800022f4:	8b89                	andi	a5,a5,2
    if (intr_get())
    800022f6:	ebbd                	bnez	a5,8000236c <sched+0xbe>
    asm volatile("mv %0, tp" : "=r"(x));
    800022f8:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800022fa:	00011917          	auipc	s2,0x11
    800022fe:	45690913          	addi	s2,s2,1110 # 80013750 <cpus>
    80002302:	2781                	sext.w	a5,a5
    80002304:	079e                	slli	a5,a5,0x7
    80002306:	97ca                	add	a5,a5,s2
    80002308:	07c7a983          	lw	s3,124(a5)
    8000230c:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000230e:	2581                	sext.w	a1,a1
    80002310:	059e                	slli	a1,a1,0x7
    80002312:	05a1                	addi	a1,a1,8
    80002314:	95ca                	add	a1,a1,s2
    80002316:	06048513          	addi	a0,s1,96
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	6e4080e7          	jalr	1764(ra) # 800029fe <swtch>
    80002322:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80002324:	2781                	sext.w	a5,a5
    80002326:	079e                	slli	a5,a5,0x7
    80002328:	993e                	add	s2,s2,a5
    8000232a:	07392e23          	sw	s3,124(s2)
}
    8000232e:	70a2                	ld	ra,40(sp)
    80002330:	7402                	ld	s0,32(sp)
    80002332:	64e2                	ld	s1,24(sp)
    80002334:	6942                	ld	s2,16(sp)
    80002336:	69a2                	ld	s3,8(sp)
    80002338:	6145                	addi	sp,sp,48
    8000233a:	8082                	ret
        panic("sched p->lock");
    8000233c:	00006517          	auipc	a0,0x6
    80002340:	efc50513          	addi	a0,a0,-260 # 80008238 <__func__.1+0x230>
    80002344:	ffffe097          	auipc	ra,0xffffe
    80002348:	21c080e7          	jalr	540(ra) # 80000560 <panic>
        panic("sched locks");
    8000234c:	00006517          	auipc	a0,0x6
    80002350:	efc50513          	addi	a0,a0,-260 # 80008248 <__func__.1+0x240>
    80002354:	ffffe097          	auipc	ra,0xffffe
    80002358:	20c080e7          	jalr	524(ra) # 80000560 <panic>
        panic("sched running");
    8000235c:	00006517          	auipc	a0,0x6
    80002360:	efc50513          	addi	a0,a0,-260 # 80008258 <__func__.1+0x250>
    80002364:	ffffe097          	auipc	ra,0xffffe
    80002368:	1fc080e7          	jalr	508(ra) # 80000560 <panic>
        panic("sched interruptible");
    8000236c:	00006517          	auipc	a0,0x6
    80002370:	efc50513          	addi	a0,a0,-260 # 80008268 <__func__.1+0x260>
    80002374:	ffffe097          	auipc	ra,0xffffe
    80002378:	1ec080e7          	jalr	492(ra) # 80000560 <panic>

000000008000237c <yield>:
{
    8000237c:	1101                	addi	sp,sp,-32
    8000237e:	ec06                	sd	ra,24(sp)
    80002380:	e822                	sd	s0,16(sp)
    80002382:	e426                	sd	s1,8(sp)
    80002384:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80002386:	00000097          	auipc	ra,0x0
    8000238a:	880080e7          	jalr	-1920(ra) # 80001c06 <myproc>
    8000238e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	970080e7          	jalr	-1680(ra) # 80000d00 <acquire>
    p->state = RUNNABLE;
    80002398:	478d                	li	a5,3
    8000239a:	cc9c                	sw	a5,24(s1)
    sched();
    8000239c:	00000097          	auipc	ra,0x0
    800023a0:	f12080e7          	jalr	-238(ra) # 800022ae <sched>
    release(&p->lock);
    800023a4:	8526                	mv	a0,s1
    800023a6:	fffff097          	auipc	ra,0xfffff
    800023aa:	a0e080e7          	jalr	-1522(ra) # 80000db4 <release>
}
    800023ae:	60e2                	ld	ra,24(sp)
    800023b0:	6442                	ld	s0,16(sp)
    800023b2:	64a2                	ld	s1,8(sp)
    800023b4:	6105                	addi	sp,sp,32
    800023b6:	8082                	ret

00000000800023b8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800023b8:	7179                	addi	sp,sp,-48
    800023ba:	f406                	sd	ra,40(sp)
    800023bc:	f022                	sd	s0,32(sp)
    800023be:	ec26                	sd	s1,24(sp)
    800023c0:	e84a                	sd	s2,16(sp)
    800023c2:	e44e                	sd	s3,8(sp)
    800023c4:	1800                	addi	s0,sp,48
    800023c6:	89aa                	mv	s3,a0
    800023c8:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800023ca:	00000097          	auipc	ra,0x0
    800023ce:	83c080e7          	jalr	-1988(ra) # 80001c06 <myproc>
    800023d2:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	92c080e7          	jalr	-1748(ra) # 80000d00 <acquire>
    release(lk);
    800023dc:	854a                	mv	a0,s2
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	9d6080e7          	jalr	-1578(ra) # 80000db4 <release>

    // Go to sleep.
    p->chan = chan;
    800023e6:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800023ea:	4789                	li	a5,2
    800023ec:	cc9c                	sw	a5,24(s1)

    sched();
    800023ee:	00000097          	auipc	ra,0x0
    800023f2:	ec0080e7          	jalr	-320(ra) # 800022ae <sched>

    // Tidy up.
    p->chan = 0;
    800023f6:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	9b8080e7          	jalr	-1608(ra) # 80000db4 <release>
    acquire(lk);
    80002404:	854a                	mv	a0,s2
    80002406:	fffff097          	auipc	ra,0xfffff
    8000240a:	8fa080e7          	jalr	-1798(ra) # 80000d00 <acquire>
}
    8000240e:	70a2                	ld	ra,40(sp)
    80002410:	7402                	ld	s0,32(sp)
    80002412:	64e2                	ld	s1,24(sp)
    80002414:	6942                	ld	s2,16(sp)
    80002416:	69a2                	ld	s3,8(sp)
    80002418:	6145                	addi	sp,sp,48
    8000241a:	8082                	ret

000000008000241c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000241c:	7139                	addi	sp,sp,-64
    8000241e:	fc06                	sd	ra,56(sp)
    80002420:	f822                	sd	s0,48(sp)
    80002422:	f426                	sd	s1,40(sp)
    80002424:	f04a                	sd	s2,32(sp)
    80002426:	ec4e                	sd	s3,24(sp)
    80002428:	e852                	sd	s4,16(sp)
    8000242a:	e456                	sd	s5,8(sp)
    8000242c:	0080                	addi	s0,sp,64
    8000242e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002430:	00011497          	auipc	s1,0x11
    80002434:	75048493          	addi	s1,s1,1872 # 80013b80 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002438:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000243a:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000243c:	00017917          	auipc	s2,0x17
    80002440:	14490913          	addi	s2,s2,324 # 80019580 <tickslock>
    80002444:	a811                	j	80002458 <wakeup+0x3c>
            }
            release(&p->lock);
    80002446:	8526                	mv	a0,s1
    80002448:	fffff097          	auipc	ra,0xfffff
    8000244c:	96c080e7          	jalr	-1684(ra) # 80000db4 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002450:	16848493          	addi	s1,s1,360
    80002454:	03248663          	beq	s1,s2,80002480 <wakeup+0x64>
        if (p != myproc())
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	7ae080e7          	jalr	1966(ra) # 80001c06 <myproc>
    80002460:	fea488e3          	beq	s1,a0,80002450 <wakeup+0x34>
            acquire(&p->lock);
    80002464:	8526                	mv	a0,s1
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	89a080e7          	jalr	-1894(ra) # 80000d00 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000246e:	4c9c                	lw	a5,24(s1)
    80002470:	fd379be3          	bne	a5,s3,80002446 <wakeup+0x2a>
    80002474:	709c                	ld	a5,32(s1)
    80002476:	fd4798e3          	bne	a5,s4,80002446 <wakeup+0x2a>
                p->state = RUNNABLE;
    8000247a:	0154ac23          	sw	s5,24(s1)
    8000247e:	b7e1                	j	80002446 <wakeup+0x2a>
        }
    }
}
    80002480:	70e2                	ld	ra,56(sp)
    80002482:	7442                	ld	s0,48(sp)
    80002484:	74a2                	ld	s1,40(sp)
    80002486:	7902                	ld	s2,32(sp)
    80002488:	69e2                	ld	s3,24(sp)
    8000248a:	6a42                	ld	s4,16(sp)
    8000248c:	6aa2                	ld	s5,8(sp)
    8000248e:	6121                	addi	sp,sp,64
    80002490:	8082                	ret

0000000080002492 <reparent>:
{
    80002492:	7179                	addi	sp,sp,-48
    80002494:	f406                	sd	ra,40(sp)
    80002496:	f022                	sd	s0,32(sp)
    80002498:	ec26                	sd	s1,24(sp)
    8000249a:	e84a                	sd	s2,16(sp)
    8000249c:	e44e                	sd	s3,8(sp)
    8000249e:	e052                	sd	s4,0(sp)
    800024a0:	1800                	addi	s0,sp,48
    800024a2:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800024a4:	00011497          	auipc	s1,0x11
    800024a8:	6dc48493          	addi	s1,s1,1756 # 80013b80 <proc>
            pp->parent = initproc;
    800024ac:	00009a17          	auipc	s4,0x9
    800024b0:	02ca0a13          	addi	s4,s4,44 # 8000b4d8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800024b4:	00017997          	auipc	s3,0x17
    800024b8:	0cc98993          	addi	s3,s3,204 # 80019580 <tickslock>
    800024bc:	a029                	j	800024c6 <reparent+0x34>
    800024be:	16848493          	addi	s1,s1,360
    800024c2:	01348d63          	beq	s1,s3,800024dc <reparent+0x4a>
        if (pp->parent == p)
    800024c6:	7c9c                	ld	a5,56(s1)
    800024c8:	ff279be3          	bne	a5,s2,800024be <reparent+0x2c>
            pp->parent = initproc;
    800024cc:	000a3503          	ld	a0,0(s4)
    800024d0:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800024d2:	00000097          	auipc	ra,0x0
    800024d6:	f4a080e7          	jalr	-182(ra) # 8000241c <wakeup>
    800024da:	b7d5                	j	800024be <reparent+0x2c>
}
    800024dc:	70a2                	ld	ra,40(sp)
    800024de:	7402                	ld	s0,32(sp)
    800024e0:	64e2                	ld	s1,24(sp)
    800024e2:	6942                	ld	s2,16(sp)
    800024e4:	69a2                	ld	s3,8(sp)
    800024e6:	6a02                	ld	s4,0(sp)
    800024e8:	6145                	addi	sp,sp,48
    800024ea:	8082                	ret

00000000800024ec <exit>:
{
    800024ec:	7179                	addi	sp,sp,-48
    800024ee:	f406                	sd	ra,40(sp)
    800024f0:	f022                	sd	s0,32(sp)
    800024f2:	ec26                	sd	s1,24(sp)
    800024f4:	e84a                	sd	s2,16(sp)
    800024f6:	e44e                	sd	s3,8(sp)
    800024f8:	e052                	sd	s4,0(sp)
    800024fa:	1800                	addi	s0,sp,48
    800024fc:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	708080e7          	jalr	1800(ra) # 80001c06 <myproc>
    80002506:	89aa                	mv	s3,a0
    if (p == initproc)
    80002508:	00009797          	auipc	a5,0x9
    8000250c:	fd07b783          	ld	a5,-48(a5) # 8000b4d8 <initproc>
    80002510:	0d050493          	addi	s1,a0,208
    80002514:	15050913          	addi	s2,a0,336
    80002518:	02a79363          	bne	a5,a0,8000253e <exit+0x52>
        panic("init exiting");
    8000251c:	00006517          	auipc	a0,0x6
    80002520:	d6450513          	addi	a0,a0,-668 # 80008280 <__func__.1+0x278>
    80002524:	ffffe097          	auipc	ra,0xffffe
    80002528:	03c080e7          	jalr	60(ra) # 80000560 <panic>
            fileclose(f);
    8000252c:	00002097          	auipc	ra,0x2
    80002530:	57e080e7          	jalr	1406(ra) # 80004aaa <fileclose>
            p->ofile[fd] = 0;
    80002534:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80002538:	04a1                	addi	s1,s1,8
    8000253a:	01248563          	beq	s1,s2,80002544 <exit+0x58>
        if (p->ofile[fd])
    8000253e:	6088                	ld	a0,0(s1)
    80002540:	f575                	bnez	a0,8000252c <exit+0x40>
    80002542:	bfdd                	j	80002538 <exit+0x4c>
    begin_op();
    80002544:	00002097          	auipc	ra,0x2
    80002548:	09c080e7          	jalr	156(ra) # 800045e0 <begin_op>
    iput(p->cwd);
    8000254c:	1509b503          	ld	a0,336(s3)
    80002550:	00002097          	auipc	ra,0x2
    80002554:	880080e7          	jalr	-1920(ra) # 80003dd0 <iput>
    end_op();
    80002558:	00002097          	auipc	ra,0x2
    8000255c:	102080e7          	jalr	258(ra) # 8000465a <end_op>
    p->cwd = 0;
    80002560:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80002564:	00011497          	auipc	s1,0x11
    80002568:	60448493          	addi	s1,s1,1540 # 80013b68 <wait_lock>
    8000256c:	8526                	mv	a0,s1
    8000256e:	ffffe097          	auipc	ra,0xffffe
    80002572:	792080e7          	jalr	1938(ra) # 80000d00 <acquire>
    reparent(p);
    80002576:	854e                	mv	a0,s3
    80002578:	00000097          	auipc	ra,0x0
    8000257c:	f1a080e7          	jalr	-230(ra) # 80002492 <reparent>
    wakeup(p->parent);
    80002580:	0389b503          	ld	a0,56(s3)
    80002584:	00000097          	auipc	ra,0x0
    80002588:	e98080e7          	jalr	-360(ra) # 8000241c <wakeup>
    acquire(&p->lock);
    8000258c:	854e                	mv	a0,s3
    8000258e:	ffffe097          	auipc	ra,0xffffe
    80002592:	772080e7          	jalr	1906(ra) # 80000d00 <acquire>
    p->xstate = status;
    80002596:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000259a:	4795                	li	a5,5
    8000259c:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800025a0:	8526                	mv	a0,s1
    800025a2:	fffff097          	auipc	ra,0xfffff
    800025a6:	812080e7          	jalr	-2030(ra) # 80000db4 <release>
    sched();
    800025aa:	00000097          	auipc	ra,0x0
    800025ae:	d04080e7          	jalr	-764(ra) # 800022ae <sched>
    panic("zombie exit");
    800025b2:	00006517          	auipc	a0,0x6
    800025b6:	cde50513          	addi	a0,a0,-802 # 80008290 <__func__.1+0x288>
    800025ba:	ffffe097          	auipc	ra,0xffffe
    800025be:	fa6080e7          	jalr	-90(ra) # 80000560 <panic>

00000000800025c2 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800025c2:	7179                	addi	sp,sp,-48
    800025c4:	f406                	sd	ra,40(sp)
    800025c6:	f022                	sd	s0,32(sp)
    800025c8:	ec26                	sd	s1,24(sp)
    800025ca:	e84a                	sd	s2,16(sp)
    800025cc:	e44e                	sd	s3,8(sp)
    800025ce:	1800                	addi	s0,sp,48
    800025d0:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800025d2:	00011497          	auipc	s1,0x11
    800025d6:	5ae48493          	addi	s1,s1,1454 # 80013b80 <proc>
    800025da:	00017997          	auipc	s3,0x17
    800025de:	fa698993          	addi	s3,s3,-90 # 80019580 <tickslock>
    {
        acquire(&p->lock);
    800025e2:	8526                	mv	a0,s1
    800025e4:	ffffe097          	auipc	ra,0xffffe
    800025e8:	71c080e7          	jalr	1820(ra) # 80000d00 <acquire>
        if (p->pid == pid)
    800025ec:	589c                	lw	a5,48(s1)
    800025ee:	01278d63          	beq	a5,s2,80002608 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800025f2:	8526                	mv	a0,s1
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	7c0080e7          	jalr	1984(ra) # 80000db4 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800025fc:	16848493          	addi	s1,s1,360
    80002600:	ff3491e3          	bne	s1,s3,800025e2 <kill+0x20>
    }
    return -1;
    80002604:	557d                	li	a0,-1
    80002606:	a829                	j	80002620 <kill+0x5e>
            p->killed = 1;
    80002608:	4785                	li	a5,1
    8000260a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000260c:	4c98                	lw	a4,24(s1)
    8000260e:	4789                	li	a5,2
    80002610:	00f70f63          	beq	a4,a5,8000262e <kill+0x6c>
            release(&p->lock);
    80002614:	8526                	mv	a0,s1
    80002616:	ffffe097          	auipc	ra,0xffffe
    8000261a:	79e080e7          	jalr	1950(ra) # 80000db4 <release>
            return 0;
    8000261e:	4501                	li	a0,0
}
    80002620:	70a2                	ld	ra,40(sp)
    80002622:	7402                	ld	s0,32(sp)
    80002624:	64e2                	ld	s1,24(sp)
    80002626:	6942                	ld	s2,16(sp)
    80002628:	69a2                	ld	s3,8(sp)
    8000262a:	6145                	addi	sp,sp,48
    8000262c:	8082                	ret
                p->state = RUNNABLE;
    8000262e:	478d                	li	a5,3
    80002630:	cc9c                	sw	a5,24(s1)
    80002632:	b7cd                	j	80002614 <kill+0x52>

0000000080002634 <setkilled>:

void setkilled(struct proc *p)
{
    80002634:	1101                	addi	sp,sp,-32
    80002636:	ec06                	sd	ra,24(sp)
    80002638:	e822                	sd	s0,16(sp)
    8000263a:	e426                	sd	s1,8(sp)
    8000263c:	1000                	addi	s0,sp,32
    8000263e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	6c0080e7          	jalr	1728(ra) # 80000d00 <acquire>
    p->killed = 1;
    80002648:	4785                	li	a5,1
    8000264a:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000264c:	8526                	mv	a0,s1
    8000264e:	ffffe097          	auipc	ra,0xffffe
    80002652:	766080e7          	jalr	1894(ra) # 80000db4 <release>
}
    80002656:	60e2                	ld	ra,24(sp)
    80002658:	6442                	ld	s0,16(sp)
    8000265a:	64a2                	ld	s1,8(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret

0000000080002660 <killed>:

int killed(struct proc *p)
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	e04a                	sd	s2,0(sp)
    8000266a:	1000                	addi	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    8000266e:	ffffe097          	auipc	ra,0xffffe
    80002672:	692080e7          	jalr	1682(ra) # 80000d00 <acquire>
    k = p->killed;
    80002676:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    8000267a:	8526                	mv	a0,s1
    8000267c:	ffffe097          	auipc	ra,0xffffe
    80002680:	738080e7          	jalr	1848(ra) # 80000db4 <release>
    return k;
}
    80002684:	854a                	mv	a0,s2
    80002686:	60e2                	ld	ra,24(sp)
    80002688:	6442                	ld	s0,16(sp)
    8000268a:	64a2                	ld	s1,8(sp)
    8000268c:	6902                	ld	s2,0(sp)
    8000268e:	6105                	addi	sp,sp,32
    80002690:	8082                	ret

0000000080002692 <wait>:
{
    80002692:	715d                	addi	sp,sp,-80
    80002694:	e486                	sd	ra,72(sp)
    80002696:	e0a2                	sd	s0,64(sp)
    80002698:	fc26                	sd	s1,56(sp)
    8000269a:	f84a                	sd	s2,48(sp)
    8000269c:	f44e                	sd	s3,40(sp)
    8000269e:	f052                	sd	s4,32(sp)
    800026a0:	ec56                	sd	s5,24(sp)
    800026a2:	e85a                	sd	s6,16(sp)
    800026a4:	e45e                	sd	s7,8(sp)
    800026a6:	e062                	sd	s8,0(sp)
    800026a8:	0880                	addi	s0,sp,80
    800026aa:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800026ac:	fffff097          	auipc	ra,0xfffff
    800026b0:	55a080e7          	jalr	1370(ra) # 80001c06 <myproc>
    800026b4:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800026b6:	00011517          	auipc	a0,0x11
    800026ba:	4b250513          	addi	a0,a0,1202 # 80013b68 <wait_lock>
    800026be:	ffffe097          	auipc	ra,0xffffe
    800026c2:	642080e7          	jalr	1602(ra) # 80000d00 <acquire>
        havekids = 0;
    800026c6:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    800026c8:	4a15                	li	s4,5
                havekids = 1;
    800026ca:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800026cc:	00017997          	auipc	s3,0x17
    800026d0:	eb498993          	addi	s3,s3,-332 # 80019580 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800026d4:	00011c17          	auipc	s8,0x11
    800026d8:	494c0c13          	addi	s8,s8,1172 # 80013b68 <wait_lock>
    800026dc:	a0d1                	j	800027a0 <wait+0x10e>
                    pid = pp->pid;
    800026de:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800026e2:	000b0e63          	beqz	s6,800026fe <wait+0x6c>
    800026e6:	4691                	li	a3,4
    800026e8:	02c48613          	addi	a2,s1,44
    800026ec:	85da                	mv	a1,s6
    800026ee:	05093503          	ld	a0,80(s2)
    800026f2:	fffff097          	auipc	ra,0xfffff
    800026f6:	0b8080e7          	jalr	184(ra) # 800017aa <copyout>
    800026fa:	04054163          	bltz	a0,8000273c <wait+0xaa>
                    freeproc(pp);
    800026fe:	8526                	mv	a0,s1
    80002700:	fffff097          	auipc	ra,0xfffff
    80002704:	6b8080e7          	jalr	1720(ra) # 80001db8 <freeproc>
                    release(&pp->lock);
    80002708:	8526                	mv	a0,s1
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	6aa080e7          	jalr	1706(ra) # 80000db4 <release>
                    release(&wait_lock);
    80002712:	00011517          	auipc	a0,0x11
    80002716:	45650513          	addi	a0,a0,1110 # 80013b68 <wait_lock>
    8000271a:	ffffe097          	auipc	ra,0xffffe
    8000271e:	69a080e7          	jalr	1690(ra) # 80000db4 <release>
}
    80002722:	854e                	mv	a0,s3
    80002724:	60a6                	ld	ra,72(sp)
    80002726:	6406                	ld	s0,64(sp)
    80002728:	74e2                	ld	s1,56(sp)
    8000272a:	7942                	ld	s2,48(sp)
    8000272c:	79a2                	ld	s3,40(sp)
    8000272e:	7a02                	ld	s4,32(sp)
    80002730:	6ae2                	ld	s5,24(sp)
    80002732:	6b42                	ld	s6,16(sp)
    80002734:	6ba2                	ld	s7,8(sp)
    80002736:	6c02                	ld	s8,0(sp)
    80002738:	6161                	addi	sp,sp,80
    8000273a:	8082                	ret
                        release(&pp->lock);
    8000273c:	8526                	mv	a0,s1
    8000273e:	ffffe097          	auipc	ra,0xffffe
    80002742:	676080e7          	jalr	1654(ra) # 80000db4 <release>
                        release(&wait_lock);
    80002746:	00011517          	auipc	a0,0x11
    8000274a:	42250513          	addi	a0,a0,1058 # 80013b68 <wait_lock>
    8000274e:	ffffe097          	auipc	ra,0xffffe
    80002752:	666080e7          	jalr	1638(ra) # 80000db4 <release>
                        return -1;
    80002756:	59fd                	li	s3,-1
    80002758:	b7e9                	j	80002722 <wait+0x90>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000275a:	16848493          	addi	s1,s1,360
    8000275e:	03348463          	beq	s1,s3,80002786 <wait+0xf4>
            if (pp->parent == p)
    80002762:	7c9c                	ld	a5,56(s1)
    80002764:	ff279be3          	bne	a5,s2,8000275a <wait+0xc8>
                acquire(&pp->lock);
    80002768:	8526                	mv	a0,s1
    8000276a:	ffffe097          	auipc	ra,0xffffe
    8000276e:	596080e7          	jalr	1430(ra) # 80000d00 <acquire>
                if (pp->state == ZOMBIE)
    80002772:	4c9c                	lw	a5,24(s1)
    80002774:	f74785e3          	beq	a5,s4,800026de <wait+0x4c>
                release(&pp->lock);
    80002778:	8526                	mv	a0,s1
    8000277a:	ffffe097          	auipc	ra,0xffffe
    8000277e:	63a080e7          	jalr	1594(ra) # 80000db4 <release>
                havekids = 1;
    80002782:	8756                	mv	a4,s5
    80002784:	bfd9                	j	8000275a <wait+0xc8>
        if (!havekids || killed(p))
    80002786:	c31d                	beqz	a4,800027ac <wait+0x11a>
    80002788:	854a                	mv	a0,s2
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	ed6080e7          	jalr	-298(ra) # 80002660 <killed>
    80002792:	ed09                	bnez	a0,800027ac <wait+0x11a>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002794:	85e2                	mv	a1,s8
    80002796:	854a                	mv	a0,s2
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	c20080e7          	jalr	-992(ra) # 800023b8 <sleep>
        havekids = 0;
    800027a0:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800027a2:	00011497          	auipc	s1,0x11
    800027a6:	3de48493          	addi	s1,s1,990 # 80013b80 <proc>
    800027aa:	bf65                	j	80002762 <wait+0xd0>
            release(&wait_lock);
    800027ac:	00011517          	auipc	a0,0x11
    800027b0:	3bc50513          	addi	a0,a0,956 # 80013b68 <wait_lock>
    800027b4:	ffffe097          	auipc	ra,0xffffe
    800027b8:	600080e7          	jalr	1536(ra) # 80000db4 <release>
            return -1;
    800027bc:	59fd                	li	s3,-1
    800027be:	b795                	j	80002722 <wait+0x90>

00000000800027c0 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800027c0:	7179                	addi	sp,sp,-48
    800027c2:	f406                	sd	ra,40(sp)
    800027c4:	f022                	sd	s0,32(sp)
    800027c6:	ec26                	sd	s1,24(sp)
    800027c8:	e84a                	sd	s2,16(sp)
    800027ca:	e44e                	sd	s3,8(sp)
    800027cc:	e052                	sd	s4,0(sp)
    800027ce:	1800                	addi	s0,sp,48
    800027d0:	84aa                	mv	s1,a0
    800027d2:	892e                	mv	s2,a1
    800027d4:	89b2                	mv	s3,a2
    800027d6:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800027d8:	fffff097          	auipc	ra,0xfffff
    800027dc:	42e080e7          	jalr	1070(ra) # 80001c06 <myproc>
    if (user_dst)
    800027e0:	c08d                	beqz	s1,80002802 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    800027e2:	86d2                	mv	a3,s4
    800027e4:	864e                	mv	a2,s3
    800027e6:	85ca                	mv	a1,s2
    800027e8:	6928                	ld	a0,80(a0)
    800027ea:	fffff097          	auipc	ra,0xfffff
    800027ee:	fc0080e7          	jalr	-64(ra) # 800017aa <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    800027f2:	70a2                	ld	ra,40(sp)
    800027f4:	7402                	ld	s0,32(sp)
    800027f6:	64e2                	ld	s1,24(sp)
    800027f8:	6942                	ld	s2,16(sp)
    800027fa:	69a2                	ld	s3,8(sp)
    800027fc:	6a02                	ld	s4,0(sp)
    800027fe:	6145                	addi	sp,sp,48
    80002800:	8082                	ret
        memmove((char *)dst, src, len);
    80002802:	000a061b          	sext.w	a2,s4
    80002806:	85ce                	mv	a1,s3
    80002808:	854a                	mv	a0,s2
    8000280a:	ffffe097          	auipc	ra,0xffffe
    8000280e:	64e080e7          	jalr	1614(ra) # 80000e58 <memmove>
        return 0;
    80002812:	8526                	mv	a0,s1
    80002814:	bff9                	j	800027f2 <either_copyout+0x32>

0000000080002816 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002816:	7179                	addi	sp,sp,-48
    80002818:	f406                	sd	ra,40(sp)
    8000281a:	f022                	sd	s0,32(sp)
    8000281c:	ec26                	sd	s1,24(sp)
    8000281e:	e84a                	sd	s2,16(sp)
    80002820:	e44e                	sd	s3,8(sp)
    80002822:	e052                	sd	s4,0(sp)
    80002824:	1800                	addi	s0,sp,48
    80002826:	892a                	mv	s2,a0
    80002828:	84ae                	mv	s1,a1
    8000282a:	89b2                	mv	s3,a2
    8000282c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000282e:	fffff097          	auipc	ra,0xfffff
    80002832:	3d8080e7          	jalr	984(ra) # 80001c06 <myproc>
    if (user_src)
    80002836:	c08d                	beqz	s1,80002858 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002838:	86d2                	mv	a3,s4
    8000283a:	864e                	mv	a2,s3
    8000283c:	85ca                	mv	a1,s2
    8000283e:	6928                	ld	a0,80(a0)
    80002840:	fffff097          	auipc	ra,0xfffff
    80002844:	ff6080e7          	jalr	-10(ra) # 80001836 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002848:	70a2                	ld	ra,40(sp)
    8000284a:	7402                	ld	s0,32(sp)
    8000284c:	64e2                	ld	s1,24(sp)
    8000284e:	6942                	ld	s2,16(sp)
    80002850:	69a2                	ld	s3,8(sp)
    80002852:	6a02                	ld	s4,0(sp)
    80002854:	6145                	addi	sp,sp,48
    80002856:	8082                	ret
        memmove(dst, (char *)src, len);
    80002858:	000a061b          	sext.w	a2,s4
    8000285c:	85ce                	mv	a1,s3
    8000285e:	854a                	mv	a0,s2
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	5f8080e7          	jalr	1528(ra) # 80000e58 <memmove>
        return 0;
    80002868:	8526                	mv	a0,s1
    8000286a:	bff9                	j	80002848 <either_copyin+0x32>

000000008000286c <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    8000286c:	715d                	addi	sp,sp,-80
    8000286e:	e486                	sd	ra,72(sp)
    80002870:	e0a2                	sd	s0,64(sp)
    80002872:	fc26                	sd	s1,56(sp)
    80002874:	f84a                	sd	s2,48(sp)
    80002876:	f44e                	sd	s3,40(sp)
    80002878:	f052                	sd	s4,32(sp)
    8000287a:	ec56                	sd	s5,24(sp)
    8000287c:	e85a                	sd	s6,16(sp)
    8000287e:	e45e                	sd	s7,8(sp)
    80002880:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002882:	00005517          	auipc	a0,0x5
    80002886:	79e50513          	addi	a0,a0,1950 # 80008020 <__func__.1+0x18>
    8000288a:	ffffe097          	auipc	ra,0xffffe
    8000288e:	d32080e7          	jalr	-718(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002892:	00011497          	auipc	s1,0x11
    80002896:	44648493          	addi	s1,s1,1094 # 80013cd8 <proc+0x158>
    8000289a:	00017917          	auipc	s2,0x17
    8000289e:	e3e90913          	addi	s2,s2,-450 # 800196d8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028a2:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800028a4:	00006997          	auipc	s3,0x6
    800028a8:	9fc98993          	addi	s3,s3,-1540 # 800082a0 <__func__.1+0x298>
        printf("%d <%s %s", p->pid, state, p->name);
    800028ac:	00006a97          	auipc	s5,0x6
    800028b0:	9fca8a93          	addi	s5,s5,-1540 # 800082a8 <__func__.1+0x2a0>
        printf("\n");
    800028b4:	00005a17          	auipc	s4,0x5
    800028b8:	76ca0a13          	addi	s4,s4,1900 # 80008020 <__func__.1+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028bc:	00006b97          	auipc	s7,0x6
    800028c0:	f9cb8b93          	addi	s7,s7,-100 # 80008858 <states.0>
    800028c4:	a00d                	j	800028e6 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    800028c6:	ed86a583          	lw	a1,-296(a3)
    800028ca:	8556                	mv	a0,s5
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	cf0080e7          	jalr	-784(ra) # 800005bc <printf>
        printf("\n");
    800028d4:	8552                	mv	a0,s4
    800028d6:	ffffe097          	auipc	ra,0xffffe
    800028da:	ce6080e7          	jalr	-794(ra) # 800005bc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800028de:	16848493          	addi	s1,s1,360
    800028e2:	03248263          	beq	s1,s2,80002906 <procdump+0x9a>
        if (p->state == UNUSED)
    800028e6:	86a6                	mv	a3,s1
    800028e8:	ec04a783          	lw	a5,-320(s1)
    800028ec:	dbed                	beqz	a5,800028de <procdump+0x72>
            state = "???";
    800028ee:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800028f0:	fcfb6be3          	bltu	s6,a5,800028c6 <procdump+0x5a>
    800028f4:	02079713          	slli	a4,a5,0x20
    800028f8:	01d75793          	srli	a5,a4,0x1d
    800028fc:	97de                	add	a5,a5,s7
    800028fe:	6390                	ld	a2,0(a5)
    80002900:	f279                	bnez	a2,800028c6 <procdump+0x5a>
            state = "???";
    80002902:	864e                	mv	a2,s3
    80002904:	b7c9                	j	800028c6 <procdump+0x5a>
    }
}
    80002906:	60a6                	ld	ra,72(sp)
    80002908:	6406                	ld	s0,64(sp)
    8000290a:	74e2                	ld	s1,56(sp)
    8000290c:	7942                	ld	s2,48(sp)
    8000290e:	79a2                	ld	s3,40(sp)
    80002910:	7a02                	ld	s4,32(sp)
    80002912:	6ae2                	ld	s5,24(sp)
    80002914:	6b42                	ld	s6,16(sp)
    80002916:	6ba2                	ld	s7,8(sp)
    80002918:	6161                	addi	sp,sp,80
    8000291a:	8082                	ret

000000008000291c <schedls>:

void schedls()
{
    8000291c:	1141                	addi	sp,sp,-16
    8000291e:	e406                	sd	ra,8(sp)
    80002920:	e022                	sd	s0,0(sp)
    80002922:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002924:	00006517          	auipc	a0,0x6
    80002928:	99450513          	addi	a0,a0,-1644 # 800082b8 <__func__.1+0x2b0>
    8000292c:	ffffe097          	auipc	ra,0xffffe
    80002930:	c90080e7          	jalr	-880(ra) # 800005bc <printf>
    printf("====================================\n");
    80002934:	00006517          	auipc	a0,0x6
    80002938:	9ac50513          	addi	a0,a0,-1620 # 800082e0 <__func__.1+0x2d8>
    8000293c:	ffffe097          	auipc	ra,0xffffe
    80002940:	c80080e7          	jalr	-896(ra) # 800005bc <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002944:	00009717          	auipc	a4,0x9
    80002948:	b2473703          	ld	a4,-1244(a4) # 8000b468 <available_schedulers+0x10>
    8000294c:	00009797          	auipc	a5,0x9
    80002950:	abc7b783          	ld	a5,-1348(a5) # 8000b408 <sched_pointer>
    80002954:	04f70663          	beq	a4,a5,800029a0 <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002958:	00006517          	auipc	a0,0x6
    8000295c:	9b850513          	addi	a0,a0,-1608 # 80008310 <__func__.1+0x308>
    80002960:	ffffe097          	auipc	ra,0xffffe
    80002964:	c5c080e7          	jalr	-932(ra) # 800005bc <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002968:	00009617          	auipc	a2,0x9
    8000296c:	b0862603          	lw	a2,-1272(a2) # 8000b470 <available_schedulers+0x18>
    80002970:	00009597          	auipc	a1,0x9
    80002974:	ae858593          	addi	a1,a1,-1304 # 8000b458 <available_schedulers>
    80002978:	00006517          	auipc	a0,0x6
    8000297c:	9a050513          	addi	a0,a0,-1632 # 80008318 <__func__.1+0x310>
    80002980:	ffffe097          	auipc	ra,0xffffe
    80002984:	c3c080e7          	jalr	-964(ra) # 800005bc <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	99850513          	addi	a0,a0,-1640 # 80008320 <__func__.1+0x318>
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	c2c080e7          	jalr	-980(ra) # 800005bc <printf>
}
    80002998:	60a2                	ld	ra,8(sp)
    8000299a:	6402                	ld	s0,0(sp)
    8000299c:	0141                	addi	sp,sp,16
    8000299e:	8082                	ret
            printf("[*]\t");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	96850513          	addi	a0,a0,-1688 # 80008308 <__func__.1+0x300>
    800029a8:	ffffe097          	auipc	ra,0xffffe
    800029ac:	c14080e7          	jalr	-1004(ra) # 800005bc <printf>
    800029b0:	bf65                	j	80002968 <schedls+0x4c>

00000000800029b2 <schedset>:

void schedset(int id)
{
    800029b2:	1141                	addi	sp,sp,-16
    800029b4:	e406                	sd	ra,8(sp)
    800029b6:	e022                	sd	s0,0(sp)
    800029b8:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    800029ba:	e90d                	bnez	a0,800029ec <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    800029bc:	00009797          	auipc	a5,0x9
    800029c0:	aac7b783          	ld	a5,-1364(a5) # 8000b468 <available_schedulers+0x10>
    800029c4:	00009717          	auipc	a4,0x9
    800029c8:	a4f73223          	sd	a5,-1468(a4) # 8000b408 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    800029cc:	00009597          	auipc	a1,0x9
    800029d0:	a8c58593          	addi	a1,a1,-1396 # 8000b458 <available_schedulers>
    800029d4:	00006517          	auipc	a0,0x6
    800029d8:	98c50513          	addi	a0,a0,-1652 # 80008360 <__func__.1+0x358>
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	be0080e7          	jalr	-1056(ra) # 800005bc <printf>
    800029e4:	60a2                	ld	ra,8(sp)
    800029e6:	6402                	ld	s0,0(sp)
    800029e8:	0141                	addi	sp,sp,16
    800029ea:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    800029ec:	00006517          	auipc	a0,0x6
    800029f0:	94c50513          	addi	a0,a0,-1716 # 80008338 <__func__.1+0x330>
    800029f4:	ffffe097          	auipc	ra,0xffffe
    800029f8:	bc8080e7          	jalr	-1080(ra) # 800005bc <printf>
        return;
    800029fc:	b7e5                	j	800029e4 <schedset+0x32>

00000000800029fe <swtch>:
    800029fe:	00153023          	sd	ra,0(a0)
    80002a02:	00253423          	sd	sp,8(a0)
    80002a06:	e900                	sd	s0,16(a0)
    80002a08:	ed04                	sd	s1,24(a0)
    80002a0a:	03253023          	sd	s2,32(a0)
    80002a0e:	03353423          	sd	s3,40(a0)
    80002a12:	03453823          	sd	s4,48(a0)
    80002a16:	03553c23          	sd	s5,56(a0)
    80002a1a:	05653023          	sd	s6,64(a0)
    80002a1e:	05753423          	sd	s7,72(a0)
    80002a22:	05853823          	sd	s8,80(a0)
    80002a26:	05953c23          	sd	s9,88(a0)
    80002a2a:	07a53023          	sd	s10,96(a0)
    80002a2e:	07b53423          	sd	s11,104(a0)
    80002a32:	0005b083          	ld	ra,0(a1)
    80002a36:	0085b103          	ld	sp,8(a1)
    80002a3a:	6980                	ld	s0,16(a1)
    80002a3c:	6d84                	ld	s1,24(a1)
    80002a3e:	0205b903          	ld	s2,32(a1)
    80002a42:	0285b983          	ld	s3,40(a1)
    80002a46:	0305ba03          	ld	s4,48(a1)
    80002a4a:	0385ba83          	ld	s5,56(a1)
    80002a4e:	0405bb03          	ld	s6,64(a1)
    80002a52:	0485bb83          	ld	s7,72(a1)
    80002a56:	0505bc03          	ld	s8,80(a1)
    80002a5a:	0585bc83          	ld	s9,88(a1)
    80002a5e:	0605bd03          	ld	s10,96(a1)
    80002a62:	0685bd83          	ld	s11,104(a1)
    80002a66:	8082                	ret

0000000080002a68 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a68:	1141                	addi	sp,sp,-16
    80002a6a:	e406                	sd	ra,8(sp)
    80002a6c:	e022                	sd	s0,0(sp)
    80002a6e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a70:	00006597          	auipc	a1,0x6
    80002a74:	94858593          	addi	a1,a1,-1720 # 800083b8 <__func__.1+0x3b0>
    80002a78:	00017517          	auipc	a0,0x17
    80002a7c:	b0850513          	addi	a0,a0,-1272 # 80019580 <tickslock>
    80002a80:	ffffe097          	auipc	ra,0xffffe
    80002a84:	1f0080e7          	jalr	496(ra) # 80000c70 <initlock>
}
    80002a88:	60a2                	ld	ra,8(sp)
    80002a8a:	6402                	ld	s0,0(sp)
    80002a8c:	0141                	addi	sp,sp,16
    80002a8e:	8082                	ret

0000000080002a90 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a90:	1141                	addi	sp,sp,-16
    80002a92:	e422                	sd	s0,8(sp)
    80002a94:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002a96:	00003797          	auipc	a5,0x3
    80002a9a:	71a78793          	addi	a5,a5,1818 # 800061b0 <kernelvec>
    80002a9e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002aa2:	6422                	ld	s0,8(sp)
    80002aa4:	0141                	addi	sp,sp,16
    80002aa6:	8082                	ret

0000000080002aa8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002aa8:	1141                	addi	sp,sp,-16
    80002aaa:	e406                	sd	ra,8(sp)
    80002aac:	e022                	sd	s0,0(sp)
    80002aae:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002ab0:	fffff097          	auipc	ra,0xfffff
    80002ab4:	156080e7          	jalr	342(ra) # 80001c06 <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ab8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002abc:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002abe:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002ac2:	00004697          	auipc	a3,0x4
    80002ac6:	53e68693          	addi	a3,a3,1342 # 80007000 <_trampoline>
    80002aca:	00004717          	auipc	a4,0x4
    80002ace:	53670713          	addi	a4,a4,1334 # 80007000 <_trampoline>
    80002ad2:	8f15                	sub	a4,a4,a3
    80002ad4:	040007b7          	lui	a5,0x4000
    80002ad8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002ada:	07b2                	slli	a5,a5,0xc
    80002adc:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002ade:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ae2:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002ae4:	18002673          	csrr	a2,satp
    80002ae8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002aea:	6d30                	ld	a2,88(a0)
    80002aec:	6138                	ld	a4,64(a0)
    80002aee:	6585                	lui	a1,0x1
    80002af0:	972e                	add	a4,a4,a1
    80002af2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002af4:	6d38                	ld	a4,88(a0)
    80002af6:	00000617          	auipc	a2,0x0
    80002afa:	13860613          	addi	a2,a2,312 # 80002c2e <usertrap>
    80002afe:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002b00:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002b02:	8612                	mv	a2,tp
    80002b04:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b06:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b0a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b0e:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b12:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b16:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002b18:	6f18                	ld	a4,24(a4)
    80002b1a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002b1e:	6928                	ld	a0,80(a0)
    80002b20:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002b22:	00004717          	auipc	a4,0x4
    80002b26:	57a70713          	addi	a4,a4,1402 # 8000709c <userret>
    80002b2a:	8f15                	sub	a4,a4,a3
    80002b2c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002b2e:	577d                	li	a4,-1
    80002b30:	177e                	slli	a4,a4,0x3f
    80002b32:	8d59                	or	a0,a0,a4
    80002b34:	9782                	jalr	a5
}
    80002b36:	60a2                	ld	ra,8(sp)
    80002b38:	6402                	ld	s0,0(sp)
    80002b3a:	0141                	addi	sp,sp,16
    80002b3c:	8082                	ret

0000000080002b3e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b3e:	1101                	addi	sp,sp,-32
    80002b40:	ec06                	sd	ra,24(sp)
    80002b42:	e822                	sd	s0,16(sp)
    80002b44:	e426                	sd	s1,8(sp)
    80002b46:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002b48:	00017497          	auipc	s1,0x17
    80002b4c:	a3848493          	addi	s1,s1,-1480 # 80019580 <tickslock>
    80002b50:	8526                	mv	a0,s1
    80002b52:	ffffe097          	auipc	ra,0xffffe
    80002b56:	1ae080e7          	jalr	430(ra) # 80000d00 <acquire>
  ticks++;
    80002b5a:	00009517          	auipc	a0,0x9
    80002b5e:	98650513          	addi	a0,a0,-1658 # 8000b4e0 <ticks>
    80002b62:	411c                	lw	a5,0(a0)
    80002b64:	2785                	addiw	a5,a5,1
    80002b66:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	8b4080e7          	jalr	-1868(ra) # 8000241c <wakeup>
  release(&tickslock);
    80002b70:	8526                	mv	a0,s1
    80002b72:	ffffe097          	auipc	ra,0xffffe
    80002b76:	242080e7          	jalr	578(ra) # 80000db4 <release>
}
    80002b7a:	60e2                	ld	ra,24(sp)
    80002b7c:	6442                	ld	s0,16(sp)
    80002b7e:	64a2                	ld	s1,8(sp)
    80002b80:	6105                	addi	sp,sp,32
    80002b82:	8082                	ret

0000000080002b84 <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80002b84:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b88:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002b8a:	0a07d163          	bgez	a5,80002c2c <devintr+0xa8>
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002b96:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002b9a:	46a5                	li	a3,9
    80002b9c:	00d70c63          	beq	a4,a3,80002bb4 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002ba0:	577d                	li	a4,-1
    80002ba2:	177e                	slli	a4,a4,0x3f
    80002ba4:	0705                	addi	a4,a4,1
    return 0;
    80002ba6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002ba8:	06e78163          	beq	a5,a4,80002c0a <devintr+0x86>
  }
}
    80002bac:	60e2                	ld	ra,24(sp)
    80002bae:	6442                	ld	s0,16(sp)
    80002bb0:	6105                	addi	sp,sp,32
    80002bb2:	8082                	ret
    80002bb4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002bb6:	00003097          	auipc	ra,0x3
    80002bba:	706080e7          	jalr	1798(ra) # 800062bc <plic_claim>
    80002bbe:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002bc0:	47a9                	li	a5,10
    80002bc2:	00f50963          	beq	a0,a5,80002bd4 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002bc6:	4785                	li	a5,1
    80002bc8:	00f50b63          	beq	a0,a5,80002bde <devintr+0x5a>
    return 1;
    80002bcc:	4505                	li	a0,1
    } else if(irq){
    80002bce:	ec89                	bnez	s1,80002be8 <devintr+0x64>
    80002bd0:	64a2                	ld	s1,8(sp)
    80002bd2:	bfe9                	j	80002bac <devintr+0x28>
      uartintr();
    80002bd4:	ffffe097          	auipc	ra,0xffffe
    80002bd8:	e38080e7          	jalr	-456(ra) # 80000a0c <uartintr>
    if(irq)
    80002bdc:	a839                	j	80002bfa <devintr+0x76>
      virtio_disk_intr();
    80002bde:	00004097          	auipc	ra,0x4
    80002be2:	c08080e7          	jalr	-1016(ra) # 800067e6 <virtio_disk_intr>
    if(irq)
    80002be6:	a811                	j	80002bfa <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002be8:	85a6                	mv	a1,s1
    80002bea:	00005517          	auipc	a0,0x5
    80002bee:	7d650513          	addi	a0,a0,2006 # 800083c0 <__func__.1+0x3b8>
    80002bf2:	ffffe097          	auipc	ra,0xffffe
    80002bf6:	9ca080e7          	jalr	-1590(ra) # 800005bc <printf>
      plic_complete(irq);
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	00003097          	auipc	ra,0x3
    80002c00:	6e4080e7          	jalr	1764(ra) # 800062e0 <plic_complete>
    return 1;
    80002c04:	4505                	li	a0,1
    80002c06:	64a2                	ld	s1,8(sp)
    80002c08:	b755                	j	80002bac <devintr+0x28>
    if(cpuid() == 0){
    80002c0a:	fffff097          	auipc	ra,0xfffff
    80002c0e:	fd0080e7          	jalr	-48(ra) # 80001bda <cpuid>
    80002c12:	c901                	beqz	a0,80002c22 <devintr+0x9e>
    asm volatile("csrr %0, sip" : "=r"(x));
    80002c14:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002c18:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80002c1a:	14479073          	csrw	sip,a5
    return 2;
    80002c1e:	4509                	li	a0,2
    80002c20:	b771                	j	80002bac <devintr+0x28>
      clockintr();
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	f1c080e7          	jalr	-228(ra) # 80002b3e <clockintr>
    80002c2a:	b7ed                	j	80002c14 <devintr+0x90>
}
    80002c2c:	8082                	ret

0000000080002c2e <usertrap>:
{
    80002c2e:	1101                	addi	sp,sp,-32
    80002c30:	ec06                	sd	ra,24(sp)
    80002c32:	e822                	sd	s0,16(sp)
    80002c34:	e426                	sd	s1,8(sp)
    80002c36:	e04a                	sd	s2,0(sp)
    80002c38:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c3a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c3e:	1007f793          	andi	a5,a5,256
    80002c42:	e3b1                	bnez	a5,80002c86 <usertrap+0x58>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002c44:	00003797          	auipc	a5,0x3
    80002c48:	56c78793          	addi	a5,a5,1388 # 800061b0 <kernelvec>
    80002c4c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	fb6080e7          	jalr	-74(ra) # 80001c06 <myproc>
    80002c58:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c5a:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002c5c:	14102773          	csrr	a4,sepc
    80002c60:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80002c62:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c66:	47a1                	li	a5,8
    80002c68:	02f70763          	beq	a4,a5,80002c96 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	f18080e7          	jalr	-232(ra) # 80002b84 <devintr>
    80002c74:	892a                	mv	s2,a0
    80002c76:	c151                	beqz	a0,80002cfa <usertrap+0xcc>
  if(killed(p))
    80002c78:	8526                	mv	a0,s1
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	9e6080e7          	jalr	-1562(ra) # 80002660 <killed>
    80002c82:	c929                	beqz	a0,80002cd4 <usertrap+0xa6>
    80002c84:	a099                	j	80002cca <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002c86:	00005517          	auipc	a0,0x5
    80002c8a:	75a50513          	addi	a0,a0,1882 # 800083e0 <__func__.1+0x3d8>
    80002c8e:	ffffe097          	auipc	ra,0xffffe
    80002c92:	8d2080e7          	jalr	-1838(ra) # 80000560 <panic>
    if(killed(p))
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	9ca080e7          	jalr	-1590(ra) # 80002660 <killed>
    80002c9e:	e921                	bnez	a0,80002cee <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002ca0:	6cb8                	ld	a4,88(s1)
    80002ca2:	6f1c                	ld	a5,24(a4)
    80002ca4:	0791                	addi	a5,a5,4
    80002ca6:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002ca8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002cac:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002cb0:	10079073          	csrw	sstatus,a5
    syscall();
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	2d4080e7          	jalr	724(ra) # 80002f88 <syscall>
  if(killed(p))
    80002cbc:	8526                	mv	a0,s1
    80002cbe:	00000097          	auipc	ra,0x0
    80002cc2:	9a2080e7          	jalr	-1630(ra) # 80002660 <killed>
    80002cc6:	c911                	beqz	a0,80002cda <usertrap+0xac>
    80002cc8:	4901                	li	s2,0
    exit(-1);
    80002cca:	557d                	li	a0,-1
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	820080e7          	jalr	-2016(ra) # 800024ec <exit>
  if(which_dev == 2)
    80002cd4:	4789                	li	a5,2
    80002cd6:	04f90f63          	beq	s2,a5,80002d34 <usertrap+0x106>
  usertrapret();
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	dce080e7          	jalr	-562(ra) # 80002aa8 <usertrapret>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret
      exit(-1);
    80002cee:	557d                	li	a0,-1
    80002cf0:	fffff097          	auipc	ra,0xfffff
    80002cf4:	7fc080e7          	jalr	2044(ra) # 800024ec <exit>
    80002cf8:	b765                	j	80002ca0 <usertrap+0x72>
    asm volatile("csrr %0, scause" : "=r"(x));
    80002cfa:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002cfe:	5890                	lw	a2,48(s1)
    80002d00:	00005517          	auipc	a0,0x5
    80002d04:	70050513          	addi	a0,a0,1792 # 80008400 <__func__.1+0x3f8>
    80002d08:	ffffe097          	auipc	ra,0xffffe
    80002d0c:	8b4080e7          	jalr	-1868(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002d10:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002d14:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d18:	00005517          	auipc	a0,0x5
    80002d1c:	71850513          	addi	a0,a0,1816 # 80008430 <__func__.1+0x428>
    80002d20:	ffffe097          	auipc	ra,0xffffe
    80002d24:	89c080e7          	jalr	-1892(ra) # 800005bc <printf>
    setkilled(p);
    80002d28:	8526                	mv	a0,s1
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	90a080e7          	jalr	-1782(ra) # 80002634 <setkilled>
    80002d32:	b769                	j	80002cbc <usertrap+0x8e>
    yield();
    80002d34:	fffff097          	auipc	ra,0xfffff
    80002d38:	648080e7          	jalr	1608(ra) # 8000237c <yield>
    80002d3c:	bf79                	j	80002cda <usertrap+0xac>

0000000080002d3e <kerneltrap>:
{
    80002d3e:	7179                	addi	sp,sp,-48
    80002d40:	f406                	sd	ra,40(sp)
    80002d42:	f022                	sd	s0,32(sp)
    80002d44:	ec26                	sd	s1,24(sp)
    80002d46:	e84a                	sd	s2,16(sp)
    80002d48:	e44e                	sd	s3,8(sp)
    80002d4a:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002d4c:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d50:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80002d54:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002d58:	1004f793          	andi	a5,s1,256
    80002d5c:	cb85                	beqz	a5,80002d8c <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002d5e:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80002d62:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d64:	ef85                	bnez	a5,80002d9c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	e1e080e7          	jalr	-482(ra) # 80002b84 <devintr>
    80002d6e:	cd1d                	beqz	a0,80002dac <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d70:	4789                	li	a5,2
    80002d72:	06f50a63          	beq	a0,a5,80002de6 <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002d76:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002d7a:	10049073          	csrw	sstatus,s1
}
    80002d7e:	70a2                	ld	ra,40(sp)
    80002d80:	7402                	ld	s0,32(sp)
    80002d82:	64e2                	ld	s1,24(sp)
    80002d84:	6942                	ld	s2,16(sp)
    80002d86:	69a2                	ld	s3,8(sp)
    80002d88:	6145                	addi	sp,sp,48
    80002d8a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d8c:	00005517          	auipc	a0,0x5
    80002d90:	6c450513          	addi	a0,a0,1732 # 80008450 <__func__.1+0x448>
    80002d94:	ffffd097          	auipc	ra,0xffffd
    80002d98:	7cc080e7          	jalr	1996(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    80002d9c:	00005517          	auipc	a0,0x5
    80002da0:	6dc50513          	addi	a0,a0,1756 # 80008478 <__func__.1+0x470>
    80002da4:	ffffd097          	auipc	ra,0xffffd
    80002da8:	7bc080e7          	jalr	1980(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    80002dac:	85ce                	mv	a1,s3
    80002dae:	00005517          	auipc	a0,0x5
    80002db2:	6ea50513          	addi	a0,a0,1770 # 80008498 <__func__.1+0x490>
    80002db6:	ffffe097          	auipc	ra,0xffffe
    80002dba:	806080e7          	jalr	-2042(ra) # 800005bc <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002dbe:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80002dc2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dc6:	00005517          	auipc	a0,0x5
    80002dca:	6e250513          	addi	a0,a0,1762 # 800084a8 <__func__.1+0x4a0>
    80002dce:	ffffd097          	auipc	ra,0xffffd
    80002dd2:	7ee080e7          	jalr	2030(ra) # 800005bc <printf>
    panic("kerneltrap");
    80002dd6:	00005517          	auipc	a0,0x5
    80002dda:	6ea50513          	addi	a0,a0,1770 # 800084c0 <__func__.1+0x4b8>
    80002dde:	ffffd097          	auipc	ra,0xffffd
    80002de2:	782080e7          	jalr	1922(ra) # 80000560 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	e20080e7          	jalr	-480(ra) # 80001c06 <myproc>
    80002dee:	d541                	beqz	a0,80002d76 <kerneltrap+0x38>
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	e16080e7          	jalr	-490(ra) # 80001c06 <myproc>
    80002df8:	4d18                	lw	a4,24(a0)
    80002dfa:	4791                	li	a5,4
    80002dfc:	f6f71de3          	bne	a4,a5,80002d76 <kerneltrap+0x38>
    yield();
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	57c080e7          	jalr	1404(ra) # 8000237c <yield>
    80002e08:	b7bd                	j	80002d76 <kerneltrap+0x38>

0000000080002e0a <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e0a:	1101                	addi	sp,sp,-32
    80002e0c:	ec06                	sd	ra,24(sp)
    80002e0e:	e822                	sd	s0,16(sp)
    80002e10:	e426                	sd	s1,8(sp)
    80002e12:	1000                	addi	s0,sp,32
    80002e14:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	df0080e7          	jalr	-528(ra) # 80001c06 <myproc>
    switch (n)
    80002e1e:	4795                	li	a5,5
    80002e20:	0497e163          	bltu	a5,s1,80002e62 <argraw+0x58>
    80002e24:	048a                	slli	s1,s1,0x2
    80002e26:	00006717          	auipc	a4,0x6
    80002e2a:	a6270713          	addi	a4,a4,-1438 # 80008888 <states.0+0x30>
    80002e2e:	94ba                	add	s1,s1,a4
    80002e30:	409c                	lw	a5,0(s1)
    80002e32:	97ba                	add	a5,a5,a4
    80002e34:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80002e36:	6d3c                	ld	a5,88(a0)
    80002e38:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002e3a:	60e2                	ld	ra,24(sp)
    80002e3c:	6442                	ld	s0,16(sp)
    80002e3e:	64a2                	ld	s1,8(sp)
    80002e40:	6105                	addi	sp,sp,32
    80002e42:	8082                	ret
        return p->trapframe->a1;
    80002e44:	6d3c                	ld	a5,88(a0)
    80002e46:	7fa8                	ld	a0,120(a5)
    80002e48:	bfcd                	j	80002e3a <argraw+0x30>
        return p->trapframe->a2;
    80002e4a:	6d3c                	ld	a5,88(a0)
    80002e4c:	63c8                	ld	a0,128(a5)
    80002e4e:	b7f5                	j	80002e3a <argraw+0x30>
        return p->trapframe->a3;
    80002e50:	6d3c                	ld	a5,88(a0)
    80002e52:	67c8                	ld	a0,136(a5)
    80002e54:	b7dd                	j	80002e3a <argraw+0x30>
        return p->trapframe->a4;
    80002e56:	6d3c                	ld	a5,88(a0)
    80002e58:	6bc8                	ld	a0,144(a5)
    80002e5a:	b7c5                	j	80002e3a <argraw+0x30>
        return p->trapframe->a5;
    80002e5c:	6d3c                	ld	a5,88(a0)
    80002e5e:	6fc8                	ld	a0,152(a5)
    80002e60:	bfe9                	j	80002e3a <argraw+0x30>
    panic("argraw");
    80002e62:	00005517          	auipc	a0,0x5
    80002e66:	66e50513          	addi	a0,a0,1646 # 800084d0 <__func__.1+0x4c8>
    80002e6a:	ffffd097          	auipc	ra,0xffffd
    80002e6e:	6f6080e7          	jalr	1782(ra) # 80000560 <panic>

0000000080002e72 <fetchaddr>:
{
    80002e72:	1101                	addi	sp,sp,-32
    80002e74:	ec06                	sd	ra,24(sp)
    80002e76:	e822                	sd	s0,16(sp)
    80002e78:	e426                	sd	s1,8(sp)
    80002e7a:	e04a                	sd	s2,0(sp)
    80002e7c:	1000                	addi	s0,sp,32
    80002e7e:	84aa                	mv	s1,a0
    80002e80:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002e82:	fffff097          	auipc	ra,0xfffff
    80002e86:	d84080e7          	jalr	-636(ra) # 80001c06 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002e8a:	653c                	ld	a5,72(a0)
    80002e8c:	02f4f863          	bgeu	s1,a5,80002ebc <fetchaddr+0x4a>
    80002e90:	00848713          	addi	a4,s1,8
    80002e94:	02e7e663          	bltu	a5,a4,80002ec0 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e98:	46a1                	li	a3,8
    80002e9a:	8626                	mv	a2,s1
    80002e9c:	85ca                	mv	a1,s2
    80002e9e:	6928                	ld	a0,80(a0)
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	996080e7          	jalr	-1642(ra) # 80001836 <copyin>
    80002ea8:	00a03533          	snez	a0,a0
    80002eac:	40a00533          	neg	a0,a0
}
    80002eb0:	60e2                	ld	ra,24(sp)
    80002eb2:	6442                	ld	s0,16(sp)
    80002eb4:	64a2                	ld	s1,8(sp)
    80002eb6:	6902                	ld	s2,0(sp)
    80002eb8:	6105                	addi	sp,sp,32
    80002eba:	8082                	ret
        return -1;
    80002ebc:	557d                	li	a0,-1
    80002ebe:	bfcd                	j	80002eb0 <fetchaddr+0x3e>
    80002ec0:	557d                	li	a0,-1
    80002ec2:	b7fd                	j	80002eb0 <fetchaddr+0x3e>

0000000080002ec4 <fetchstr>:
{
    80002ec4:	7179                	addi	sp,sp,-48
    80002ec6:	f406                	sd	ra,40(sp)
    80002ec8:	f022                	sd	s0,32(sp)
    80002eca:	ec26                	sd	s1,24(sp)
    80002ecc:	e84a                	sd	s2,16(sp)
    80002ece:	e44e                	sd	s3,8(sp)
    80002ed0:	1800                	addi	s0,sp,48
    80002ed2:	892a                	mv	s2,a0
    80002ed4:	84ae                	mv	s1,a1
    80002ed6:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	d2e080e7          	jalr	-722(ra) # 80001c06 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002ee0:	86ce                	mv	a3,s3
    80002ee2:	864a                	mv	a2,s2
    80002ee4:	85a6                	mv	a1,s1
    80002ee6:	6928                	ld	a0,80(a0)
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	9dc080e7          	jalr	-1572(ra) # 800018c4 <copyinstr>
    80002ef0:	00054e63          	bltz	a0,80002f0c <fetchstr+0x48>
    return strlen(buf);
    80002ef4:	8526                	mv	a0,s1
    80002ef6:	ffffe097          	auipc	ra,0xffffe
    80002efa:	07a080e7          	jalr	122(ra) # 80000f70 <strlen>
}
    80002efe:	70a2                	ld	ra,40(sp)
    80002f00:	7402                	ld	s0,32(sp)
    80002f02:	64e2                	ld	s1,24(sp)
    80002f04:	6942                	ld	s2,16(sp)
    80002f06:	69a2                	ld	s3,8(sp)
    80002f08:	6145                	addi	sp,sp,48
    80002f0a:	8082                	ret
        return -1;
    80002f0c:	557d                	li	a0,-1
    80002f0e:	bfc5                	j	80002efe <fetchstr+0x3a>

0000000080002f10 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002f10:	1101                	addi	sp,sp,-32
    80002f12:	ec06                	sd	ra,24(sp)
    80002f14:	e822                	sd	s0,16(sp)
    80002f16:	e426                	sd	s1,8(sp)
    80002f18:	1000                	addi	s0,sp,32
    80002f1a:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	eee080e7          	jalr	-274(ra) # 80002e0a <argraw>
    80002f24:	c088                	sw	a0,0(s1)
}
    80002f26:	60e2                	ld	ra,24(sp)
    80002f28:	6442                	ld	s0,16(sp)
    80002f2a:	64a2                	ld	s1,8(sp)
    80002f2c:	6105                	addi	sp,sp,32
    80002f2e:	8082                	ret

0000000080002f30 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002f30:	1101                	addi	sp,sp,-32
    80002f32:	ec06                	sd	ra,24(sp)
    80002f34:	e822                	sd	s0,16(sp)
    80002f36:	e426                	sd	s1,8(sp)
    80002f38:	1000                	addi	s0,sp,32
    80002f3a:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002f3c:	00000097          	auipc	ra,0x0
    80002f40:	ece080e7          	jalr	-306(ra) # 80002e0a <argraw>
    80002f44:	e088                	sd	a0,0(s1)
}
    80002f46:	60e2                	ld	ra,24(sp)
    80002f48:	6442                	ld	s0,16(sp)
    80002f4a:	64a2                	ld	s1,8(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret

0000000080002f50 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002f50:	7179                	addi	sp,sp,-48
    80002f52:	f406                	sd	ra,40(sp)
    80002f54:	f022                	sd	s0,32(sp)
    80002f56:	ec26                	sd	s1,24(sp)
    80002f58:	e84a                	sd	s2,16(sp)
    80002f5a:	1800                	addi	s0,sp,48
    80002f5c:	84ae                	mv	s1,a1
    80002f5e:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002f60:	fd840593          	addi	a1,s0,-40
    80002f64:	00000097          	auipc	ra,0x0
    80002f68:	fcc080e7          	jalr	-52(ra) # 80002f30 <argaddr>
    return fetchstr(addr, buf, max);
    80002f6c:	864a                	mv	a2,s2
    80002f6e:	85a6                	mv	a1,s1
    80002f70:	fd843503          	ld	a0,-40(s0)
    80002f74:	00000097          	auipc	ra,0x0
    80002f78:	f50080e7          	jalr	-176(ra) # 80002ec4 <fetchstr>
}
    80002f7c:	70a2                	ld	ra,40(sp)
    80002f7e:	7402                	ld	s0,32(sp)
    80002f80:	64e2                	ld	s1,24(sp)
    80002f82:	6942                	ld	s2,16(sp)
    80002f84:	6145                	addi	sp,sp,48
    80002f86:	8082                	ret

0000000080002f88 <syscall>:
    [SYS_pfreepages] sys_pfreepages,
    [SYS_va2pa] sys_va2pa,
};

void syscall(void)
{
    80002f88:	1101                	addi	sp,sp,-32
    80002f8a:	ec06                	sd	ra,24(sp)
    80002f8c:	e822                	sd	s0,16(sp)
    80002f8e:	e426                	sd	s1,8(sp)
    80002f90:	e04a                	sd	s2,0(sp)
    80002f92:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	c72080e7          	jalr	-910(ra) # 80001c06 <myproc>
    80002f9c:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002f9e:	05853903          	ld	s2,88(a0)
    80002fa2:	0a893783          	ld	a5,168(s2)
    80002fa6:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002faa:	37fd                	addiw	a5,a5,-1
    80002fac:	4765                	li	a4,25
    80002fae:	00f76f63          	bltu	a4,a5,80002fcc <syscall+0x44>
    80002fb2:	00369713          	slli	a4,a3,0x3
    80002fb6:	00006797          	auipc	a5,0x6
    80002fba:	8ea78793          	addi	a5,a5,-1814 # 800088a0 <syscalls>
    80002fbe:	97ba                	add	a5,a5,a4
    80002fc0:	639c                	ld	a5,0(a5)
    80002fc2:	c789                	beqz	a5,80002fcc <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002fc4:	9782                	jalr	a5
    80002fc6:	06a93823          	sd	a0,112(s2)
    80002fca:	a839                	j	80002fe8 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002fcc:	15848613          	addi	a2,s1,344
    80002fd0:	588c                	lw	a1,48(s1)
    80002fd2:	00005517          	auipc	a0,0x5
    80002fd6:	50650513          	addi	a0,a0,1286 # 800084d8 <__func__.1+0x4d0>
    80002fda:	ffffd097          	auipc	ra,0xffffd
    80002fde:	5e2080e7          	jalr	1506(ra) # 800005bc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002fe2:	6cbc                	ld	a5,88(s1)
    80002fe4:	577d                	li	a4,-1
    80002fe6:	fbb8                	sd	a4,112(a5)
    }
}
    80002fe8:	60e2                	ld	ra,24(sp)
    80002fea:	6442                	ld	s0,16(sp)
    80002fec:	64a2                	ld	s1,8(sp)
    80002fee:	6902                	ld	s2,0(sp)
    80002ff0:	6105                	addi	sp,sp,32
    80002ff2:	8082                	ret

0000000080002ff4 <sys_exit>:
extern uint64 FREE_PAGES; // kalloc.c keeps track of those
extern struct proc proc[NPROC];

uint64
sys_exit(void)
{
    80002ff4:	1101                	addi	sp,sp,-32
    80002ff6:	ec06                	sd	ra,24(sp)
    80002ff8:	e822                	sd	s0,16(sp)
    80002ffa:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    80002ffc:	fec40593          	addi	a1,s0,-20
    80003000:	4501                	li	a0,0
    80003002:	00000097          	auipc	ra,0x0
    80003006:	f0e080e7          	jalr	-242(ra) # 80002f10 <argint>
    exit(n);
    8000300a:	fec42503          	lw	a0,-20(s0)
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	4de080e7          	jalr	1246(ra) # 800024ec <exit>
    return 0; // not reached
}
    80003016:	4501                	li	a0,0
    80003018:	60e2                	ld	ra,24(sp)
    8000301a:	6442                	ld	s0,16(sp)
    8000301c:	6105                	addi	sp,sp,32
    8000301e:	8082                	ret

0000000080003020 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003020:	1141                	addi	sp,sp,-16
    80003022:	e406                	sd	ra,8(sp)
    80003024:	e022                	sd	s0,0(sp)
    80003026:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	bde080e7          	jalr	-1058(ra) # 80001c06 <myproc>
}
    80003030:	5908                	lw	a0,48(a0)
    80003032:	60a2                	ld	ra,8(sp)
    80003034:	6402                	ld	s0,0(sp)
    80003036:	0141                	addi	sp,sp,16
    80003038:	8082                	ret

000000008000303a <sys_fork>:

uint64
sys_fork(void)
{
    8000303a:	1141                	addi	sp,sp,-16
    8000303c:	e406                	sd	ra,8(sp)
    8000303e:	e022                	sd	s0,0(sp)
    80003040:	0800                	addi	s0,sp,16
    return fork();
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	112080e7          	jalr	274(ra) # 80002154 <fork>
}
    8000304a:	60a2                	ld	ra,8(sp)
    8000304c:	6402                	ld	s0,0(sp)
    8000304e:	0141                	addi	sp,sp,16
    80003050:	8082                	ret

0000000080003052 <sys_wait>:

uint64
sys_wait(void)
{
    80003052:	1101                	addi	sp,sp,-32
    80003054:	ec06                	sd	ra,24(sp)
    80003056:	e822                	sd	s0,16(sp)
    80003058:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    8000305a:	fe840593          	addi	a1,s0,-24
    8000305e:	4501                	li	a0,0
    80003060:	00000097          	auipc	ra,0x0
    80003064:	ed0080e7          	jalr	-304(ra) # 80002f30 <argaddr>
    return wait(p);
    80003068:	fe843503          	ld	a0,-24(s0)
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	626080e7          	jalr	1574(ra) # 80002692 <wait>
}
    80003074:	60e2                	ld	ra,24(sp)
    80003076:	6442                	ld	s0,16(sp)
    80003078:	6105                	addi	sp,sp,32
    8000307a:	8082                	ret

000000008000307c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000307c:	7179                	addi	sp,sp,-48
    8000307e:	f406                	sd	ra,40(sp)
    80003080:	f022                	sd	s0,32(sp)
    80003082:	ec26                	sd	s1,24(sp)
    80003084:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    80003086:	fdc40593          	addi	a1,s0,-36
    8000308a:	4501                	li	a0,0
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	e84080e7          	jalr	-380(ra) # 80002f10 <argint>
    addr = myproc()->sz;
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	b72080e7          	jalr	-1166(ra) # 80001c06 <myproc>
    8000309c:	6524                	ld	s1,72(a0)
    if (growproc(n) < 0)
    8000309e:	fdc42503          	lw	a0,-36(s0)
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	ebe080e7          	jalr	-322(ra) # 80001f60 <growproc>
    800030aa:	00054863          	bltz	a0,800030ba <sys_sbrk+0x3e>
        return -1;
    return addr;
}
    800030ae:	8526                	mv	a0,s1
    800030b0:	70a2                	ld	ra,40(sp)
    800030b2:	7402                	ld	s0,32(sp)
    800030b4:	64e2                	ld	s1,24(sp)
    800030b6:	6145                	addi	sp,sp,48
    800030b8:	8082                	ret
        return -1;
    800030ba:	54fd                	li	s1,-1
    800030bc:	bfcd                	j	800030ae <sys_sbrk+0x32>

00000000800030be <sys_sleep>:

uint64
sys_sleep(void)
{
    800030be:	7139                	addi	sp,sp,-64
    800030c0:	fc06                	sd	ra,56(sp)
    800030c2:	f822                	sd	s0,48(sp)
    800030c4:	f04a                	sd	s2,32(sp)
    800030c6:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    800030c8:	fcc40593          	addi	a1,s0,-52
    800030cc:	4501                	li	a0,0
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	e42080e7          	jalr	-446(ra) # 80002f10 <argint>
    acquire(&tickslock);
    800030d6:	00016517          	auipc	a0,0x16
    800030da:	4aa50513          	addi	a0,a0,1194 # 80019580 <tickslock>
    800030de:	ffffe097          	auipc	ra,0xffffe
    800030e2:	c22080e7          	jalr	-990(ra) # 80000d00 <acquire>
    ticks0 = ticks;
    800030e6:	00008917          	auipc	s2,0x8
    800030ea:	3fa92903          	lw	s2,1018(s2) # 8000b4e0 <ticks>
    while (ticks - ticks0 < n)
    800030ee:	fcc42783          	lw	a5,-52(s0)
    800030f2:	c3b9                	beqz	a5,80003138 <sys_sleep+0x7a>
    800030f4:	f426                	sd	s1,40(sp)
    800030f6:	ec4e                	sd	s3,24(sp)
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800030f8:	00016997          	auipc	s3,0x16
    800030fc:	48898993          	addi	s3,s3,1160 # 80019580 <tickslock>
    80003100:	00008497          	auipc	s1,0x8
    80003104:	3e048493          	addi	s1,s1,992 # 8000b4e0 <ticks>
        if (killed(myproc()))
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	afe080e7          	jalr	-1282(ra) # 80001c06 <myproc>
    80003110:	fffff097          	auipc	ra,0xfffff
    80003114:	550080e7          	jalr	1360(ra) # 80002660 <killed>
    80003118:	ed15                	bnez	a0,80003154 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000311a:	85ce                	mv	a1,s3
    8000311c:	8526                	mv	a0,s1
    8000311e:	fffff097          	auipc	ra,0xfffff
    80003122:	29a080e7          	jalr	666(ra) # 800023b8 <sleep>
    while (ticks - ticks0 < n)
    80003126:	409c                	lw	a5,0(s1)
    80003128:	412787bb          	subw	a5,a5,s2
    8000312c:	fcc42703          	lw	a4,-52(s0)
    80003130:	fce7ece3          	bltu	a5,a4,80003108 <sys_sleep+0x4a>
    80003134:	74a2                	ld	s1,40(sp)
    80003136:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003138:	00016517          	auipc	a0,0x16
    8000313c:	44850513          	addi	a0,a0,1096 # 80019580 <tickslock>
    80003140:	ffffe097          	auipc	ra,0xffffe
    80003144:	c74080e7          	jalr	-908(ra) # 80000db4 <release>
    return 0;
    80003148:	4501                	li	a0,0
}
    8000314a:	70e2                	ld	ra,56(sp)
    8000314c:	7442                	ld	s0,48(sp)
    8000314e:	7902                	ld	s2,32(sp)
    80003150:	6121                	addi	sp,sp,64
    80003152:	8082                	ret
            release(&tickslock);
    80003154:	00016517          	auipc	a0,0x16
    80003158:	42c50513          	addi	a0,a0,1068 # 80019580 <tickslock>
    8000315c:	ffffe097          	auipc	ra,0xffffe
    80003160:	c58080e7          	jalr	-936(ra) # 80000db4 <release>
            return -1;
    80003164:	557d                	li	a0,-1
    80003166:	74a2                	ld	s1,40(sp)
    80003168:	69e2                	ld	s3,24(sp)
    8000316a:	b7c5                	j	8000314a <sys_sleep+0x8c>

000000008000316c <sys_kill>:

uint64
sys_kill(void)
{
    8000316c:	1101                	addi	sp,sp,-32
    8000316e:	ec06                	sd	ra,24(sp)
    80003170:	e822                	sd	s0,16(sp)
    80003172:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    80003174:	fec40593          	addi	a1,s0,-20
    80003178:	4501                	li	a0,0
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	d96080e7          	jalr	-618(ra) # 80002f10 <argint>
    return kill(pid);
    80003182:	fec42503          	lw	a0,-20(s0)
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	43c080e7          	jalr	1084(ra) # 800025c2 <kill>
}
    8000318e:	60e2                	ld	ra,24(sp)
    80003190:	6442                	ld	s0,16(sp)
    80003192:	6105                	addi	sp,sp,32
    80003194:	8082                	ret

0000000080003196 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003196:	1101                	addi	sp,sp,-32
    80003198:	ec06                	sd	ra,24(sp)
    8000319a:	e822                	sd	s0,16(sp)
    8000319c:	e426                	sd	s1,8(sp)
    8000319e:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800031a0:	00016517          	auipc	a0,0x16
    800031a4:	3e050513          	addi	a0,a0,992 # 80019580 <tickslock>
    800031a8:	ffffe097          	auipc	ra,0xffffe
    800031ac:	b58080e7          	jalr	-1192(ra) # 80000d00 <acquire>
    xticks = ticks;
    800031b0:	00008497          	auipc	s1,0x8
    800031b4:	3304a483          	lw	s1,816(s1) # 8000b4e0 <ticks>
    release(&tickslock);
    800031b8:	00016517          	auipc	a0,0x16
    800031bc:	3c850513          	addi	a0,a0,968 # 80019580 <tickslock>
    800031c0:	ffffe097          	auipc	ra,0xffffe
    800031c4:	bf4080e7          	jalr	-1036(ra) # 80000db4 <release>
    return xticks;
}
    800031c8:	02049513          	slli	a0,s1,0x20
    800031cc:	9101                	srli	a0,a0,0x20
    800031ce:	60e2                	ld	ra,24(sp)
    800031d0:	6442                	ld	s0,16(sp)
    800031d2:	64a2                	ld	s1,8(sp)
    800031d4:	6105                	addi	sp,sp,32
    800031d6:	8082                	ret

00000000800031d8 <sys_ps>:

void *
sys_ps(void)
{
    800031d8:	1101                	addi	sp,sp,-32
    800031da:	ec06                	sd	ra,24(sp)
    800031dc:	e822                	sd	s0,16(sp)
    800031de:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    800031e0:	fe042623          	sw	zero,-20(s0)
    800031e4:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    800031e8:	fec40593          	addi	a1,s0,-20
    800031ec:	4501                	li	a0,0
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	d22080e7          	jalr	-734(ra) # 80002f10 <argint>
    argint(1, &count);
    800031f6:	fe840593          	addi	a1,s0,-24
    800031fa:	4505                	li	a0,1
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	d14080e7          	jalr	-748(ra) # 80002f10 <argint>
    return ps((uint8)start, (uint8)count);
    80003204:	fe844583          	lbu	a1,-24(s0)
    80003208:	fec44503          	lbu	a0,-20(s0)
    8000320c:	fffff097          	auipc	ra,0xfffff
    80003210:	db0080e7          	jalr	-592(ra) # 80001fbc <ps>
}
    80003214:	60e2                	ld	ra,24(sp)
    80003216:	6442                	ld	s0,16(sp)
    80003218:	6105                	addi	sp,sp,32
    8000321a:	8082                	ret

000000008000321c <sys_schedls>:

uint64 sys_schedls(void)
{
    8000321c:	1141                	addi	sp,sp,-16
    8000321e:	e406                	sd	ra,8(sp)
    80003220:	e022                	sd	s0,0(sp)
    80003222:	0800                	addi	s0,sp,16
    schedls();
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	6f8080e7          	jalr	1784(ra) # 8000291c <schedls>
    return 0;
}
    8000322c:	4501                	li	a0,0
    8000322e:	60a2                	ld	ra,8(sp)
    80003230:	6402                	ld	s0,0(sp)
    80003232:	0141                	addi	sp,sp,16
    80003234:	8082                	ret

0000000080003236 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003236:	1101                	addi	sp,sp,-32
    80003238:	ec06                	sd	ra,24(sp)
    8000323a:	e822                	sd	s0,16(sp)
    8000323c:	1000                	addi	s0,sp,32
    int id = 0;
    8000323e:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003242:	fec40593          	addi	a1,s0,-20
    80003246:	4501                	li	a0,0
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	cc8080e7          	jalr	-824(ra) # 80002f10 <argint>
    schedset(id - 1);
    80003250:	fec42503          	lw	a0,-20(s0)
    80003254:	357d                	addiw	a0,a0,-1
    80003256:	fffff097          	auipc	ra,0xfffff
    8000325a:	75c080e7          	jalr	1884(ra) # 800029b2 <schedset>
    return 0;
}
    8000325e:	4501                	li	a0,0
    80003260:	60e2                	ld	ra,24(sp)
    80003262:	6442                	ld	s0,16(sp)
    80003264:	6105                	addi	sp,sp,32
    80003266:	8082                	ret

0000000080003268 <sys_va2pa>:

uint64 sys_va2pa(void){
    80003268:	7179                	addi	sp,sp,-48
    8000326a:	f406                	sd	ra,40(sp)
    8000326c:	f022                	sd	s0,32(sp)
    8000326e:	ec26                	sd	s1,24(sp)
    80003270:	e84a                	sd	s2,16(sp)
    80003272:	1800                	addi	s0,sp,48
 
    int pid = 0;
    80003274:	fc042e23          	sw	zero,-36(s0)
    uint64 va = 0;
    80003278:	fc043823          	sd	zero,-48(s0)
    argaddr(0, &va);
    8000327c:	fd040593          	addi	a1,s0,-48
    80003280:	4501                	li	a0,0
    80003282:	00000097          	auipc	ra,0x0
    80003286:	cae080e7          	jalr	-850(ra) # 80002f30 <argaddr>
    argint(1, &pid);
    8000328a:	fdc40593          	addi	a1,s0,-36
    8000328e:	4505                	li	a0,1
    80003290:	00000097          	auipc	ra,0x0
    80003294:	c80080e7          	jalr	-896(ra) # 80002f10 <argint>

    pagetable_t pagetable = 0;

    if(pid == 0){
    80003298:	fdc42783          	lw	a5,-36(s0)
        pagetable = myproc()->pagetable;
    }
    else{
        struct proc *p;
        for(p = proc; p < &proc[NPROC]; p++){
    8000329c:	00011497          	auipc	s1,0x11
    800032a0:	8e448493          	addi	s1,s1,-1820 # 80013b80 <proc>
    800032a4:	00016917          	auipc	s2,0x16
    800032a8:	2dc90913          	addi	s2,s2,732 # 80019580 <tickslock>
    if(pid == 0){
    800032ac:	e38d                	bnez	a5,800032ce <sys_va2pa+0x66>
        pagetable = myproc()->pagetable;
    800032ae:	fffff097          	auipc	ra,0xfffff
    800032b2:	958080e7          	jalr	-1704(ra) # 80001c06 <myproc>
    800032b6:	05053903          	ld	s2,80(a0)
    800032ba:	a82d                	j	800032f4 <sys_va2pa+0x8c>
            if(p->state != UNUSED && p->pid == pid){
                pagetable = p->pagetable;
                release(&p->lock);
                break;
            }
            release(&p->lock);
    800032bc:	8526                	mv	a0,s1
    800032be:	ffffe097          	auipc	ra,0xffffe
    800032c2:	af6080e7          	jalr	-1290(ra) # 80000db4 <release>
        for(p = proc; p < &proc[NPROC]; p++){
    800032c6:	16848493          	addi	s1,s1,360
    800032ca:	05248a63          	beq	s1,s2,8000331e <sys_va2pa+0xb6>
            acquire(&p->lock);
    800032ce:	8526                	mv	a0,s1
    800032d0:	ffffe097          	auipc	ra,0xffffe
    800032d4:	a30080e7          	jalr	-1488(ra) # 80000d00 <acquire>
            if(p->state != UNUSED && p->pid == pid){
    800032d8:	4c9c                	lw	a5,24(s1)
    800032da:	d3ed                	beqz	a5,800032bc <sys_va2pa+0x54>
    800032dc:	5898                	lw	a4,48(s1)
    800032de:	fdc42783          	lw	a5,-36(s0)
    800032e2:	fcf71de3          	bne	a4,a5,800032bc <sys_va2pa+0x54>
                pagetable = p->pagetable;
    800032e6:	0504b903          	ld	s2,80(s1)
                release(&p->lock);
    800032ea:	8526                	mv	a0,s1
    800032ec:	ffffe097          	auipc	ra,0xffffe
    800032f0:	ac8080e7          	jalr	-1336(ra) # 80000db4 <release>
        }
    }
    if(pagetable == 0) return 0;
    800032f4:	02090763          	beqz	s2,80003322 <sys_va2pa+0xba>
    uint64 pa0 = walkaddr(pagetable, va);
    800032f8:	fd043583          	ld	a1,-48(s0)
    800032fc:	854a                	mv	a0,s2
    800032fe:	ffffe097          	auipc	ra,0xffffe
    80003302:	e80080e7          	jalr	-384(ra) # 8000117e <walkaddr>
    if(pa0 == 0) return 0;
    80003306:	c511                	beqz	a0,80003312 <sys_va2pa+0xaa>
    return pa0 + (va & (PGSIZE -1));
    80003308:	fd043783          	ld	a5,-48(s0)
    8000330c:	17d2                	slli	a5,a5,0x34
    8000330e:	93d1                	srli	a5,a5,0x34
    80003310:	953e                	add	a0,a0,a5
}
    80003312:	70a2                	ld	ra,40(sp)
    80003314:	7402                	ld	s0,32(sp)
    80003316:	64e2                	ld	s1,24(sp)
    80003318:	6942                	ld	s2,16(sp)
    8000331a:	6145                	addi	sp,sp,48
    8000331c:	8082                	ret
    if(pagetable == 0) return 0;
    8000331e:	4501                	li	a0,0
    80003320:	bfcd                	j	80003312 <sys_va2pa+0xaa>
    80003322:	4501                	li	a0,0
    80003324:	b7fd                	j	80003312 <sys_va2pa+0xaa>

0000000080003326 <sys_pfreepages>:

uint64 sys_pfreepages(void)
{
    80003326:	1141                	addi	sp,sp,-16
    80003328:	e406                	sd	ra,8(sp)
    8000332a:	e022                	sd	s0,0(sp)
    8000332c:	0800                	addi	s0,sp,16
    printf("%d\n", FREE_PAGES);
    8000332e:	00008597          	auipc	a1,0x8
    80003332:	18a5b583          	ld	a1,394(a1) # 8000b4b8 <FREE_PAGES>
    80003336:	00005517          	auipc	a0,0x5
    8000333a:	1c250513          	addi	a0,a0,450 # 800084f8 <__func__.1+0x4f0>
    8000333e:	ffffd097          	auipc	ra,0xffffd
    80003342:	27e080e7          	jalr	638(ra) # 800005bc <printf>
    return 0;
}
    80003346:	4501                	li	a0,0
    80003348:	60a2                	ld	ra,8(sp)
    8000334a:	6402                	ld	s0,0(sp)
    8000334c:	0141                	addi	sp,sp,16
    8000334e:	8082                	ret

0000000080003350 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003350:	7179                	addi	sp,sp,-48
    80003352:	f406                	sd	ra,40(sp)
    80003354:	f022                	sd	s0,32(sp)
    80003356:	ec26                	sd	s1,24(sp)
    80003358:	e84a                	sd	s2,16(sp)
    8000335a:	e44e                	sd	s3,8(sp)
    8000335c:	e052                	sd	s4,0(sp)
    8000335e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003360:	00005597          	auipc	a1,0x5
    80003364:	1a058593          	addi	a1,a1,416 # 80008500 <__func__.1+0x4f8>
    80003368:	00016517          	auipc	a0,0x16
    8000336c:	23050513          	addi	a0,a0,560 # 80019598 <bcache>
    80003370:	ffffe097          	auipc	ra,0xffffe
    80003374:	900080e7          	jalr	-1792(ra) # 80000c70 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003378:	0001e797          	auipc	a5,0x1e
    8000337c:	22078793          	addi	a5,a5,544 # 80021598 <bcache+0x8000>
    80003380:	0001e717          	auipc	a4,0x1e
    80003384:	48070713          	addi	a4,a4,1152 # 80021800 <bcache+0x8268>
    80003388:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000338c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003390:	00016497          	auipc	s1,0x16
    80003394:	22048493          	addi	s1,s1,544 # 800195b0 <bcache+0x18>
    b->next = bcache.head.next;
    80003398:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000339a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000339c:	00005a17          	auipc	s4,0x5
    800033a0:	16ca0a13          	addi	s4,s4,364 # 80008508 <__func__.1+0x500>
    b->next = bcache.head.next;
    800033a4:	2b893783          	ld	a5,696(s2)
    800033a8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033aa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033ae:	85d2                	mv	a1,s4
    800033b0:	01048513          	addi	a0,s1,16
    800033b4:	00001097          	auipc	ra,0x1
    800033b8:	4e8080e7          	jalr	1256(ra) # 8000489c <initsleeplock>
    bcache.head.next->prev = b;
    800033bc:	2b893783          	ld	a5,696(s2)
    800033c0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033c2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033c6:	45848493          	addi	s1,s1,1112
    800033ca:	fd349de3          	bne	s1,s3,800033a4 <binit+0x54>
  }
}
    800033ce:	70a2                	ld	ra,40(sp)
    800033d0:	7402                	ld	s0,32(sp)
    800033d2:	64e2                	ld	s1,24(sp)
    800033d4:	6942                	ld	s2,16(sp)
    800033d6:	69a2                	ld	s3,8(sp)
    800033d8:	6a02                	ld	s4,0(sp)
    800033da:	6145                	addi	sp,sp,48
    800033dc:	8082                	ret

00000000800033de <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800033de:	7179                	addi	sp,sp,-48
    800033e0:	f406                	sd	ra,40(sp)
    800033e2:	f022                	sd	s0,32(sp)
    800033e4:	ec26                	sd	s1,24(sp)
    800033e6:	e84a                	sd	s2,16(sp)
    800033e8:	e44e                	sd	s3,8(sp)
    800033ea:	1800                	addi	s0,sp,48
    800033ec:	892a                	mv	s2,a0
    800033ee:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800033f0:	00016517          	auipc	a0,0x16
    800033f4:	1a850513          	addi	a0,a0,424 # 80019598 <bcache>
    800033f8:	ffffe097          	auipc	ra,0xffffe
    800033fc:	908080e7          	jalr	-1784(ra) # 80000d00 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003400:	0001e497          	auipc	s1,0x1e
    80003404:	4504b483          	ld	s1,1104(s1) # 80021850 <bcache+0x82b8>
    80003408:	0001e797          	auipc	a5,0x1e
    8000340c:	3f878793          	addi	a5,a5,1016 # 80021800 <bcache+0x8268>
    80003410:	02f48f63          	beq	s1,a5,8000344e <bread+0x70>
    80003414:	873e                	mv	a4,a5
    80003416:	a021                	j	8000341e <bread+0x40>
    80003418:	68a4                	ld	s1,80(s1)
    8000341a:	02e48a63          	beq	s1,a4,8000344e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000341e:	449c                	lw	a5,8(s1)
    80003420:	ff279ce3          	bne	a5,s2,80003418 <bread+0x3a>
    80003424:	44dc                	lw	a5,12(s1)
    80003426:	ff3799e3          	bne	a5,s3,80003418 <bread+0x3a>
      b->refcnt++;
    8000342a:	40bc                	lw	a5,64(s1)
    8000342c:	2785                	addiw	a5,a5,1
    8000342e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003430:	00016517          	auipc	a0,0x16
    80003434:	16850513          	addi	a0,a0,360 # 80019598 <bcache>
    80003438:	ffffe097          	auipc	ra,0xffffe
    8000343c:	97c080e7          	jalr	-1668(ra) # 80000db4 <release>
      acquiresleep(&b->lock);
    80003440:	01048513          	addi	a0,s1,16
    80003444:	00001097          	auipc	ra,0x1
    80003448:	492080e7          	jalr	1170(ra) # 800048d6 <acquiresleep>
      return b;
    8000344c:	a8b9                	j	800034aa <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000344e:	0001e497          	auipc	s1,0x1e
    80003452:	3fa4b483          	ld	s1,1018(s1) # 80021848 <bcache+0x82b0>
    80003456:	0001e797          	auipc	a5,0x1e
    8000345a:	3aa78793          	addi	a5,a5,938 # 80021800 <bcache+0x8268>
    8000345e:	00f48863          	beq	s1,a5,8000346e <bread+0x90>
    80003462:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003464:	40bc                	lw	a5,64(s1)
    80003466:	cf81                	beqz	a5,8000347e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003468:	64a4                	ld	s1,72(s1)
    8000346a:	fee49de3          	bne	s1,a4,80003464 <bread+0x86>
  panic("bget: no buffers");
    8000346e:	00005517          	auipc	a0,0x5
    80003472:	0a250513          	addi	a0,a0,162 # 80008510 <__func__.1+0x508>
    80003476:	ffffd097          	auipc	ra,0xffffd
    8000347a:	0ea080e7          	jalr	234(ra) # 80000560 <panic>
      b->dev = dev;
    8000347e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003482:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003486:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000348a:	4785                	li	a5,1
    8000348c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000348e:	00016517          	auipc	a0,0x16
    80003492:	10a50513          	addi	a0,a0,266 # 80019598 <bcache>
    80003496:	ffffe097          	auipc	ra,0xffffe
    8000349a:	91e080e7          	jalr	-1762(ra) # 80000db4 <release>
      acquiresleep(&b->lock);
    8000349e:	01048513          	addi	a0,s1,16
    800034a2:	00001097          	auipc	ra,0x1
    800034a6:	434080e7          	jalr	1076(ra) # 800048d6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034aa:	409c                	lw	a5,0(s1)
    800034ac:	cb89                	beqz	a5,800034be <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034ae:	8526                	mv	a0,s1
    800034b0:	70a2                	ld	ra,40(sp)
    800034b2:	7402                	ld	s0,32(sp)
    800034b4:	64e2                	ld	s1,24(sp)
    800034b6:	6942                	ld	s2,16(sp)
    800034b8:	69a2                	ld	s3,8(sp)
    800034ba:	6145                	addi	sp,sp,48
    800034bc:	8082                	ret
    virtio_disk_rw(b, 0);
    800034be:	4581                	li	a1,0
    800034c0:	8526                	mv	a0,s1
    800034c2:	00003097          	auipc	ra,0x3
    800034c6:	0f6080e7          	jalr	246(ra) # 800065b8 <virtio_disk_rw>
    b->valid = 1;
    800034ca:	4785                	li	a5,1
    800034cc:	c09c                	sw	a5,0(s1)
  return b;
    800034ce:	b7c5                	j	800034ae <bread+0xd0>

00000000800034d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800034d0:	1101                	addi	sp,sp,-32
    800034d2:	ec06                	sd	ra,24(sp)
    800034d4:	e822                	sd	s0,16(sp)
    800034d6:	e426                	sd	s1,8(sp)
    800034d8:	1000                	addi	s0,sp,32
    800034da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034dc:	0541                	addi	a0,a0,16
    800034de:	00001097          	auipc	ra,0x1
    800034e2:	492080e7          	jalr	1170(ra) # 80004970 <holdingsleep>
    800034e6:	cd01                	beqz	a0,800034fe <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034e8:	4585                	li	a1,1
    800034ea:	8526                	mv	a0,s1
    800034ec:	00003097          	auipc	ra,0x3
    800034f0:	0cc080e7          	jalr	204(ra) # 800065b8 <virtio_disk_rw>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	64a2                	ld	s1,8(sp)
    800034fa:	6105                	addi	sp,sp,32
    800034fc:	8082                	ret
    panic("bwrite");
    800034fe:	00005517          	auipc	a0,0x5
    80003502:	02a50513          	addi	a0,a0,42 # 80008528 <__func__.1+0x520>
    80003506:	ffffd097          	auipc	ra,0xffffd
    8000350a:	05a080e7          	jalr	90(ra) # 80000560 <panic>

000000008000350e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000350e:	1101                	addi	sp,sp,-32
    80003510:	ec06                	sd	ra,24(sp)
    80003512:	e822                	sd	s0,16(sp)
    80003514:	e426                	sd	s1,8(sp)
    80003516:	e04a                	sd	s2,0(sp)
    80003518:	1000                	addi	s0,sp,32
    8000351a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000351c:	01050913          	addi	s2,a0,16
    80003520:	854a                	mv	a0,s2
    80003522:	00001097          	auipc	ra,0x1
    80003526:	44e080e7          	jalr	1102(ra) # 80004970 <holdingsleep>
    8000352a:	c925                	beqz	a0,8000359a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000352c:	854a                	mv	a0,s2
    8000352e:	00001097          	auipc	ra,0x1
    80003532:	3fe080e7          	jalr	1022(ra) # 8000492c <releasesleep>

  acquire(&bcache.lock);
    80003536:	00016517          	auipc	a0,0x16
    8000353a:	06250513          	addi	a0,a0,98 # 80019598 <bcache>
    8000353e:	ffffd097          	auipc	ra,0xffffd
    80003542:	7c2080e7          	jalr	1986(ra) # 80000d00 <acquire>
  b->refcnt--;
    80003546:	40bc                	lw	a5,64(s1)
    80003548:	37fd                	addiw	a5,a5,-1
    8000354a:	0007871b          	sext.w	a4,a5
    8000354e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003550:	e71d                	bnez	a4,8000357e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003552:	68b8                	ld	a4,80(s1)
    80003554:	64bc                	ld	a5,72(s1)
    80003556:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003558:	68b8                	ld	a4,80(s1)
    8000355a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000355c:	0001e797          	auipc	a5,0x1e
    80003560:	03c78793          	addi	a5,a5,60 # 80021598 <bcache+0x8000>
    80003564:	2b87b703          	ld	a4,696(a5)
    80003568:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000356a:	0001e717          	auipc	a4,0x1e
    8000356e:	29670713          	addi	a4,a4,662 # 80021800 <bcache+0x8268>
    80003572:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003574:	2b87b703          	ld	a4,696(a5)
    80003578:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000357a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000357e:	00016517          	auipc	a0,0x16
    80003582:	01a50513          	addi	a0,a0,26 # 80019598 <bcache>
    80003586:	ffffe097          	auipc	ra,0xffffe
    8000358a:	82e080e7          	jalr	-2002(ra) # 80000db4 <release>
}
    8000358e:	60e2                	ld	ra,24(sp)
    80003590:	6442                	ld	s0,16(sp)
    80003592:	64a2                	ld	s1,8(sp)
    80003594:	6902                	ld	s2,0(sp)
    80003596:	6105                	addi	sp,sp,32
    80003598:	8082                	ret
    panic("brelse");
    8000359a:	00005517          	auipc	a0,0x5
    8000359e:	f9650513          	addi	a0,a0,-106 # 80008530 <__func__.1+0x528>
    800035a2:	ffffd097          	auipc	ra,0xffffd
    800035a6:	fbe080e7          	jalr	-66(ra) # 80000560 <panic>

00000000800035aa <bpin>:

void
bpin(struct buf *b) {
    800035aa:	1101                	addi	sp,sp,-32
    800035ac:	ec06                	sd	ra,24(sp)
    800035ae:	e822                	sd	s0,16(sp)
    800035b0:	e426                	sd	s1,8(sp)
    800035b2:	1000                	addi	s0,sp,32
    800035b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035b6:	00016517          	auipc	a0,0x16
    800035ba:	fe250513          	addi	a0,a0,-30 # 80019598 <bcache>
    800035be:	ffffd097          	auipc	ra,0xffffd
    800035c2:	742080e7          	jalr	1858(ra) # 80000d00 <acquire>
  b->refcnt++;
    800035c6:	40bc                	lw	a5,64(s1)
    800035c8:	2785                	addiw	a5,a5,1
    800035ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035cc:	00016517          	auipc	a0,0x16
    800035d0:	fcc50513          	addi	a0,a0,-52 # 80019598 <bcache>
    800035d4:	ffffd097          	auipc	ra,0xffffd
    800035d8:	7e0080e7          	jalr	2016(ra) # 80000db4 <release>
}
    800035dc:	60e2                	ld	ra,24(sp)
    800035de:	6442                	ld	s0,16(sp)
    800035e0:	64a2                	ld	s1,8(sp)
    800035e2:	6105                	addi	sp,sp,32
    800035e4:	8082                	ret

00000000800035e6 <bunpin>:

void
bunpin(struct buf *b) {
    800035e6:	1101                	addi	sp,sp,-32
    800035e8:	ec06                	sd	ra,24(sp)
    800035ea:	e822                	sd	s0,16(sp)
    800035ec:	e426                	sd	s1,8(sp)
    800035ee:	1000                	addi	s0,sp,32
    800035f0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035f2:	00016517          	auipc	a0,0x16
    800035f6:	fa650513          	addi	a0,a0,-90 # 80019598 <bcache>
    800035fa:	ffffd097          	auipc	ra,0xffffd
    800035fe:	706080e7          	jalr	1798(ra) # 80000d00 <acquire>
  b->refcnt--;
    80003602:	40bc                	lw	a5,64(s1)
    80003604:	37fd                	addiw	a5,a5,-1
    80003606:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003608:	00016517          	auipc	a0,0x16
    8000360c:	f9050513          	addi	a0,a0,-112 # 80019598 <bcache>
    80003610:	ffffd097          	auipc	ra,0xffffd
    80003614:	7a4080e7          	jalr	1956(ra) # 80000db4 <release>
}
    80003618:	60e2                	ld	ra,24(sp)
    8000361a:	6442                	ld	s0,16(sp)
    8000361c:	64a2                	ld	s1,8(sp)
    8000361e:	6105                	addi	sp,sp,32
    80003620:	8082                	ret

0000000080003622 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003622:	1101                	addi	sp,sp,-32
    80003624:	ec06                	sd	ra,24(sp)
    80003626:	e822                	sd	s0,16(sp)
    80003628:	e426                	sd	s1,8(sp)
    8000362a:	e04a                	sd	s2,0(sp)
    8000362c:	1000                	addi	s0,sp,32
    8000362e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003630:	00d5d59b          	srliw	a1,a1,0xd
    80003634:	0001e797          	auipc	a5,0x1e
    80003638:	6407a783          	lw	a5,1600(a5) # 80021c74 <sb+0x1c>
    8000363c:	9dbd                	addw	a1,a1,a5
    8000363e:	00000097          	auipc	ra,0x0
    80003642:	da0080e7          	jalr	-608(ra) # 800033de <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003646:	0074f713          	andi	a4,s1,7
    8000364a:	4785                	li	a5,1
    8000364c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003650:	14ce                	slli	s1,s1,0x33
    80003652:	90d9                	srli	s1,s1,0x36
    80003654:	00950733          	add	a4,a0,s1
    80003658:	05874703          	lbu	a4,88(a4)
    8000365c:	00e7f6b3          	and	a3,a5,a4
    80003660:	c69d                	beqz	a3,8000368e <bfree+0x6c>
    80003662:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003664:	94aa                	add	s1,s1,a0
    80003666:	fff7c793          	not	a5,a5
    8000366a:	8f7d                	and	a4,a4,a5
    8000366c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003670:	00001097          	auipc	ra,0x1
    80003674:	148080e7          	jalr	328(ra) # 800047b8 <log_write>
  brelse(bp);
    80003678:	854a                	mv	a0,s2
    8000367a:	00000097          	auipc	ra,0x0
    8000367e:	e94080e7          	jalr	-364(ra) # 8000350e <brelse>
}
    80003682:	60e2                	ld	ra,24(sp)
    80003684:	6442                	ld	s0,16(sp)
    80003686:	64a2                	ld	s1,8(sp)
    80003688:	6902                	ld	s2,0(sp)
    8000368a:	6105                	addi	sp,sp,32
    8000368c:	8082                	ret
    panic("freeing free block");
    8000368e:	00005517          	auipc	a0,0x5
    80003692:	eaa50513          	addi	a0,a0,-342 # 80008538 <__func__.1+0x530>
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	eca080e7          	jalr	-310(ra) # 80000560 <panic>

000000008000369e <balloc>:
{
    8000369e:	711d                	addi	sp,sp,-96
    800036a0:	ec86                	sd	ra,88(sp)
    800036a2:	e8a2                	sd	s0,80(sp)
    800036a4:	e4a6                	sd	s1,72(sp)
    800036a6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800036a8:	0001e797          	auipc	a5,0x1e
    800036ac:	5b47a783          	lw	a5,1460(a5) # 80021c5c <sb+0x4>
    800036b0:	10078f63          	beqz	a5,800037ce <balloc+0x130>
    800036b4:	e0ca                	sd	s2,64(sp)
    800036b6:	fc4e                	sd	s3,56(sp)
    800036b8:	f852                	sd	s4,48(sp)
    800036ba:	f456                	sd	s5,40(sp)
    800036bc:	f05a                	sd	s6,32(sp)
    800036be:	ec5e                	sd	s7,24(sp)
    800036c0:	e862                	sd	s8,16(sp)
    800036c2:	e466                	sd	s9,8(sp)
    800036c4:	8baa                	mv	s7,a0
    800036c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800036c8:	0001eb17          	auipc	s6,0x1e
    800036cc:	590b0b13          	addi	s6,s6,1424 # 80021c58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036d0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800036d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800036d6:	6c89                	lui	s9,0x2
    800036d8:	a061                	j	80003760 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800036da:	97ca                	add	a5,a5,s2
    800036dc:	8e55                	or	a2,a2,a3
    800036de:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800036e2:	854a                	mv	a0,s2
    800036e4:	00001097          	auipc	ra,0x1
    800036e8:	0d4080e7          	jalr	212(ra) # 800047b8 <log_write>
        brelse(bp);
    800036ec:	854a                	mv	a0,s2
    800036ee:	00000097          	auipc	ra,0x0
    800036f2:	e20080e7          	jalr	-480(ra) # 8000350e <brelse>
  bp = bread(dev, bno);
    800036f6:	85a6                	mv	a1,s1
    800036f8:	855e                	mv	a0,s7
    800036fa:	00000097          	auipc	ra,0x0
    800036fe:	ce4080e7          	jalr	-796(ra) # 800033de <bread>
    80003702:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003704:	40000613          	li	a2,1024
    80003708:	4581                	li	a1,0
    8000370a:	05850513          	addi	a0,a0,88
    8000370e:	ffffd097          	auipc	ra,0xffffd
    80003712:	6ee080e7          	jalr	1774(ra) # 80000dfc <memset>
  log_write(bp);
    80003716:	854a                	mv	a0,s2
    80003718:	00001097          	auipc	ra,0x1
    8000371c:	0a0080e7          	jalr	160(ra) # 800047b8 <log_write>
  brelse(bp);
    80003720:	854a                	mv	a0,s2
    80003722:	00000097          	auipc	ra,0x0
    80003726:	dec080e7          	jalr	-532(ra) # 8000350e <brelse>
}
    8000372a:	6906                	ld	s2,64(sp)
    8000372c:	79e2                	ld	s3,56(sp)
    8000372e:	7a42                	ld	s4,48(sp)
    80003730:	7aa2                	ld	s5,40(sp)
    80003732:	7b02                	ld	s6,32(sp)
    80003734:	6be2                	ld	s7,24(sp)
    80003736:	6c42                	ld	s8,16(sp)
    80003738:	6ca2                	ld	s9,8(sp)
}
    8000373a:	8526                	mv	a0,s1
    8000373c:	60e6                	ld	ra,88(sp)
    8000373e:	6446                	ld	s0,80(sp)
    80003740:	64a6                	ld	s1,72(sp)
    80003742:	6125                	addi	sp,sp,96
    80003744:	8082                	ret
    brelse(bp);
    80003746:	854a                	mv	a0,s2
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	dc6080e7          	jalr	-570(ra) # 8000350e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003750:	015c87bb          	addw	a5,s9,s5
    80003754:	00078a9b          	sext.w	s5,a5
    80003758:	004b2703          	lw	a4,4(s6)
    8000375c:	06eaf163          	bgeu	s5,a4,800037be <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003760:	41fad79b          	sraiw	a5,s5,0x1f
    80003764:	0137d79b          	srliw	a5,a5,0x13
    80003768:	015787bb          	addw	a5,a5,s5
    8000376c:	40d7d79b          	sraiw	a5,a5,0xd
    80003770:	01cb2583          	lw	a1,28(s6)
    80003774:	9dbd                	addw	a1,a1,a5
    80003776:	855e                	mv	a0,s7
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	c66080e7          	jalr	-922(ra) # 800033de <bread>
    80003780:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003782:	004b2503          	lw	a0,4(s6)
    80003786:	000a849b          	sext.w	s1,s5
    8000378a:	8762                	mv	a4,s8
    8000378c:	faa4fde3          	bgeu	s1,a0,80003746 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003790:	00777693          	andi	a3,a4,7
    80003794:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003798:	41f7579b          	sraiw	a5,a4,0x1f
    8000379c:	01d7d79b          	srliw	a5,a5,0x1d
    800037a0:	9fb9                	addw	a5,a5,a4
    800037a2:	4037d79b          	sraiw	a5,a5,0x3
    800037a6:	00f90633          	add	a2,s2,a5
    800037aa:	05864603          	lbu	a2,88(a2)
    800037ae:	00c6f5b3          	and	a1,a3,a2
    800037b2:	d585                	beqz	a1,800036da <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037b4:	2705                	addiw	a4,a4,1
    800037b6:	2485                	addiw	s1,s1,1
    800037b8:	fd471ae3          	bne	a4,s4,8000378c <balloc+0xee>
    800037bc:	b769                	j	80003746 <balloc+0xa8>
    800037be:	6906                	ld	s2,64(sp)
    800037c0:	79e2                	ld	s3,56(sp)
    800037c2:	7a42                	ld	s4,48(sp)
    800037c4:	7aa2                	ld	s5,40(sp)
    800037c6:	7b02                	ld	s6,32(sp)
    800037c8:	6be2                	ld	s7,24(sp)
    800037ca:	6c42                	ld	s8,16(sp)
    800037cc:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800037ce:	00005517          	auipc	a0,0x5
    800037d2:	d8250513          	addi	a0,a0,-638 # 80008550 <__func__.1+0x548>
    800037d6:	ffffd097          	auipc	ra,0xffffd
    800037da:	de6080e7          	jalr	-538(ra) # 800005bc <printf>
  return 0;
    800037de:	4481                	li	s1,0
    800037e0:	bfa9                	j	8000373a <balloc+0x9c>

00000000800037e2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800037e2:	7179                	addi	sp,sp,-48
    800037e4:	f406                	sd	ra,40(sp)
    800037e6:	f022                	sd	s0,32(sp)
    800037e8:	ec26                	sd	s1,24(sp)
    800037ea:	e84a                	sd	s2,16(sp)
    800037ec:	e44e                	sd	s3,8(sp)
    800037ee:	1800                	addi	s0,sp,48
    800037f0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800037f2:	47ad                	li	a5,11
    800037f4:	02b7e863          	bltu	a5,a1,80003824 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800037f8:	02059793          	slli	a5,a1,0x20
    800037fc:	01e7d593          	srli	a1,a5,0x1e
    80003800:	00b504b3          	add	s1,a0,a1
    80003804:	0504a903          	lw	s2,80(s1)
    80003808:	08091263          	bnez	s2,8000388c <bmap+0xaa>
      addr = balloc(ip->dev);
    8000380c:	4108                	lw	a0,0(a0)
    8000380e:	00000097          	auipc	ra,0x0
    80003812:	e90080e7          	jalr	-368(ra) # 8000369e <balloc>
    80003816:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000381a:	06090963          	beqz	s2,8000388c <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    8000381e:	0524a823          	sw	s2,80(s1)
    80003822:	a0ad                	j	8000388c <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003824:	ff45849b          	addiw	s1,a1,-12
    80003828:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000382c:	0ff00793          	li	a5,255
    80003830:	08e7e863          	bltu	a5,a4,800038c0 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003834:	08052903          	lw	s2,128(a0)
    80003838:	00091f63          	bnez	s2,80003856 <bmap+0x74>
      addr = balloc(ip->dev);
    8000383c:	4108                	lw	a0,0(a0)
    8000383e:	00000097          	auipc	ra,0x0
    80003842:	e60080e7          	jalr	-416(ra) # 8000369e <balloc>
    80003846:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000384a:	04090163          	beqz	s2,8000388c <bmap+0xaa>
    8000384e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003850:	0929a023          	sw	s2,128(s3)
    80003854:	a011                	j	80003858 <bmap+0x76>
    80003856:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003858:	85ca                	mv	a1,s2
    8000385a:	0009a503          	lw	a0,0(s3)
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	b80080e7          	jalr	-1152(ra) # 800033de <bread>
    80003866:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003868:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000386c:	02049713          	slli	a4,s1,0x20
    80003870:	01e75593          	srli	a1,a4,0x1e
    80003874:	00b784b3          	add	s1,a5,a1
    80003878:	0004a903          	lw	s2,0(s1)
    8000387c:	02090063          	beqz	s2,8000389c <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003880:	8552                	mv	a0,s4
    80003882:	00000097          	auipc	ra,0x0
    80003886:	c8c080e7          	jalr	-884(ra) # 8000350e <brelse>
    return addr;
    8000388a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000388c:	854a                	mv	a0,s2
    8000388e:	70a2                	ld	ra,40(sp)
    80003890:	7402                	ld	s0,32(sp)
    80003892:	64e2                	ld	s1,24(sp)
    80003894:	6942                	ld	s2,16(sp)
    80003896:	69a2                	ld	s3,8(sp)
    80003898:	6145                	addi	sp,sp,48
    8000389a:	8082                	ret
      addr = balloc(ip->dev);
    8000389c:	0009a503          	lw	a0,0(s3)
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	dfe080e7          	jalr	-514(ra) # 8000369e <balloc>
    800038a8:	0005091b          	sext.w	s2,a0
      if(addr){
    800038ac:	fc090ae3          	beqz	s2,80003880 <bmap+0x9e>
        a[bn] = addr;
    800038b0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800038b4:	8552                	mv	a0,s4
    800038b6:	00001097          	auipc	ra,0x1
    800038ba:	f02080e7          	jalr	-254(ra) # 800047b8 <log_write>
    800038be:	b7c9                	j	80003880 <bmap+0x9e>
    800038c0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800038c2:	00005517          	auipc	a0,0x5
    800038c6:	ca650513          	addi	a0,a0,-858 # 80008568 <__func__.1+0x560>
    800038ca:	ffffd097          	auipc	ra,0xffffd
    800038ce:	c96080e7          	jalr	-874(ra) # 80000560 <panic>

00000000800038d2 <iget>:
{
    800038d2:	7179                	addi	sp,sp,-48
    800038d4:	f406                	sd	ra,40(sp)
    800038d6:	f022                	sd	s0,32(sp)
    800038d8:	ec26                	sd	s1,24(sp)
    800038da:	e84a                	sd	s2,16(sp)
    800038dc:	e44e                	sd	s3,8(sp)
    800038de:	e052                	sd	s4,0(sp)
    800038e0:	1800                	addi	s0,sp,48
    800038e2:	89aa                	mv	s3,a0
    800038e4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800038e6:	0001e517          	auipc	a0,0x1e
    800038ea:	39250513          	addi	a0,a0,914 # 80021c78 <itable>
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	412080e7          	jalr	1042(ra) # 80000d00 <acquire>
  empty = 0;
    800038f6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800038f8:	0001e497          	auipc	s1,0x1e
    800038fc:	39848493          	addi	s1,s1,920 # 80021c90 <itable+0x18>
    80003900:	00020697          	auipc	a3,0x20
    80003904:	e2068693          	addi	a3,a3,-480 # 80023720 <log>
    80003908:	a039                	j	80003916 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000390a:	02090b63          	beqz	s2,80003940 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000390e:	08848493          	addi	s1,s1,136
    80003912:	02d48a63          	beq	s1,a3,80003946 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003916:	449c                	lw	a5,8(s1)
    80003918:	fef059e3          	blez	a5,8000390a <iget+0x38>
    8000391c:	4098                	lw	a4,0(s1)
    8000391e:	ff3716e3          	bne	a4,s3,8000390a <iget+0x38>
    80003922:	40d8                	lw	a4,4(s1)
    80003924:	ff4713e3          	bne	a4,s4,8000390a <iget+0x38>
      ip->ref++;
    80003928:	2785                	addiw	a5,a5,1
    8000392a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000392c:	0001e517          	auipc	a0,0x1e
    80003930:	34c50513          	addi	a0,a0,844 # 80021c78 <itable>
    80003934:	ffffd097          	auipc	ra,0xffffd
    80003938:	480080e7          	jalr	1152(ra) # 80000db4 <release>
      return ip;
    8000393c:	8926                	mv	s2,s1
    8000393e:	a03d                	j	8000396c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003940:	f7f9                	bnez	a5,8000390e <iget+0x3c>
      empty = ip;
    80003942:	8926                	mv	s2,s1
    80003944:	b7e9                	j	8000390e <iget+0x3c>
  if(empty == 0)
    80003946:	02090c63          	beqz	s2,8000397e <iget+0xac>
  ip->dev = dev;
    8000394a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000394e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003952:	4785                	li	a5,1
    80003954:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003958:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000395c:	0001e517          	auipc	a0,0x1e
    80003960:	31c50513          	addi	a0,a0,796 # 80021c78 <itable>
    80003964:	ffffd097          	auipc	ra,0xffffd
    80003968:	450080e7          	jalr	1104(ra) # 80000db4 <release>
}
    8000396c:	854a                	mv	a0,s2
    8000396e:	70a2                	ld	ra,40(sp)
    80003970:	7402                	ld	s0,32(sp)
    80003972:	64e2                	ld	s1,24(sp)
    80003974:	6942                	ld	s2,16(sp)
    80003976:	69a2                	ld	s3,8(sp)
    80003978:	6a02                	ld	s4,0(sp)
    8000397a:	6145                	addi	sp,sp,48
    8000397c:	8082                	ret
    panic("iget: no inodes");
    8000397e:	00005517          	auipc	a0,0x5
    80003982:	c0250513          	addi	a0,a0,-1022 # 80008580 <__func__.1+0x578>
    80003986:	ffffd097          	auipc	ra,0xffffd
    8000398a:	bda080e7          	jalr	-1062(ra) # 80000560 <panic>

000000008000398e <fsinit>:
fsinit(int dev) {
    8000398e:	7179                	addi	sp,sp,-48
    80003990:	f406                	sd	ra,40(sp)
    80003992:	f022                	sd	s0,32(sp)
    80003994:	ec26                	sd	s1,24(sp)
    80003996:	e84a                	sd	s2,16(sp)
    80003998:	e44e                	sd	s3,8(sp)
    8000399a:	1800                	addi	s0,sp,48
    8000399c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000399e:	4585                	li	a1,1
    800039a0:	00000097          	auipc	ra,0x0
    800039a4:	a3e080e7          	jalr	-1474(ra) # 800033de <bread>
    800039a8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800039aa:	0001e997          	auipc	s3,0x1e
    800039ae:	2ae98993          	addi	s3,s3,686 # 80021c58 <sb>
    800039b2:	02000613          	li	a2,32
    800039b6:	05850593          	addi	a1,a0,88
    800039ba:	854e                	mv	a0,s3
    800039bc:	ffffd097          	auipc	ra,0xffffd
    800039c0:	49c080e7          	jalr	1180(ra) # 80000e58 <memmove>
  brelse(bp);
    800039c4:	8526                	mv	a0,s1
    800039c6:	00000097          	auipc	ra,0x0
    800039ca:	b48080e7          	jalr	-1208(ra) # 8000350e <brelse>
  if(sb.magic != FSMAGIC)
    800039ce:	0009a703          	lw	a4,0(s3)
    800039d2:	102037b7          	lui	a5,0x10203
    800039d6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800039da:	02f71263          	bne	a4,a5,800039fe <fsinit+0x70>
  initlog(dev, &sb);
    800039de:	0001e597          	auipc	a1,0x1e
    800039e2:	27a58593          	addi	a1,a1,634 # 80021c58 <sb>
    800039e6:	854a                	mv	a0,s2
    800039e8:	00001097          	auipc	ra,0x1
    800039ec:	b60080e7          	jalr	-1184(ra) # 80004548 <initlog>
}
    800039f0:	70a2                	ld	ra,40(sp)
    800039f2:	7402                	ld	s0,32(sp)
    800039f4:	64e2                	ld	s1,24(sp)
    800039f6:	6942                	ld	s2,16(sp)
    800039f8:	69a2                	ld	s3,8(sp)
    800039fa:	6145                	addi	sp,sp,48
    800039fc:	8082                	ret
    panic("invalid file system");
    800039fe:	00005517          	auipc	a0,0x5
    80003a02:	b9250513          	addi	a0,a0,-1134 # 80008590 <__func__.1+0x588>
    80003a06:	ffffd097          	auipc	ra,0xffffd
    80003a0a:	b5a080e7          	jalr	-1190(ra) # 80000560 <panic>

0000000080003a0e <iinit>:
{
    80003a0e:	7179                	addi	sp,sp,-48
    80003a10:	f406                	sd	ra,40(sp)
    80003a12:	f022                	sd	s0,32(sp)
    80003a14:	ec26                	sd	s1,24(sp)
    80003a16:	e84a                	sd	s2,16(sp)
    80003a18:	e44e                	sd	s3,8(sp)
    80003a1a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a1c:	00005597          	auipc	a1,0x5
    80003a20:	b8c58593          	addi	a1,a1,-1140 # 800085a8 <__func__.1+0x5a0>
    80003a24:	0001e517          	auipc	a0,0x1e
    80003a28:	25450513          	addi	a0,a0,596 # 80021c78 <itable>
    80003a2c:	ffffd097          	auipc	ra,0xffffd
    80003a30:	244080e7          	jalr	580(ra) # 80000c70 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003a34:	0001e497          	auipc	s1,0x1e
    80003a38:	26c48493          	addi	s1,s1,620 # 80021ca0 <itable+0x28>
    80003a3c:	00020997          	auipc	s3,0x20
    80003a40:	cf498993          	addi	s3,s3,-780 # 80023730 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003a44:	00005917          	auipc	s2,0x5
    80003a48:	b6c90913          	addi	s2,s2,-1172 # 800085b0 <__func__.1+0x5a8>
    80003a4c:	85ca                	mv	a1,s2
    80003a4e:	8526                	mv	a0,s1
    80003a50:	00001097          	auipc	ra,0x1
    80003a54:	e4c080e7          	jalr	-436(ra) # 8000489c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003a58:	08848493          	addi	s1,s1,136
    80003a5c:	ff3498e3          	bne	s1,s3,80003a4c <iinit+0x3e>
}
    80003a60:	70a2                	ld	ra,40(sp)
    80003a62:	7402                	ld	s0,32(sp)
    80003a64:	64e2                	ld	s1,24(sp)
    80003a66:	6942                	ld	s2,16(sp)
    80003a68:	69a2                	ld	s3,8(sp)
    80003a6a:	6145                	addi	sp,sp,48
    80003a6c:	8082                	ret

0000000080003a6e <ialloc>:
{
    80003a6e:	7139                	addi	sp,sp,-64
    80003a70:	fc06                	sd	ra,56(sp)
    80003a72:	f822                	sd	s0,48(sp)
    80003a74:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003a76:	0001e717          	auipc	a4,0x1e
    80003a7a:	1ee72703          	lw	a4,494(a4) # 80021c64 <sb+0xc>
    80003a7e:	4785                	li	a5,1
    80003a80:	06e7f463          	bgeu	a5,a4,80003ae8 <ialloc+0x7a>
    80003a84:	f426                	sd	s1,40(sp)
    80003a86:	f04a                	sd	s2,32(sp)
    80003a88:	ec4e                	sd	s3,24(sp)
    80003a8a:	e852                	sd	s4,16(sp)
    80003a8c:	e456                	sd	s5,8(sp)
    80003a8e:	e05a                	sd	s6,0(sp)
    80003a90:	8aaa                	mv	s5,a0
    80003a92:	8b2e                	mv	s6,a1
    80003a94:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003a96:	0001ea17          	auipc	s4,0x1e
    80003a9a:	1c2a0a13          	addi	s4,s4,450 # 80021c58 <sb>
    80003a9e:	00495593          	srli	a1,s2,0x4
    80003aa2:	018a2783          	lw	a5,24(s4)
    80003aa6:	9dbd                	addw	a1,a1,a5
    80003aa8:	8556                	mv	a0,s5
    80003aaa:	00000097          	auipc	ra,0x0
    80003aae:	934080e7          	jalr	-1740(ra) # 800033de <bread>
    80003ab2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003ab4:	05850993          	addi	s3,a0,88
    80003ab8:	00f97793          	andi	a5,s2,15
    80003abc:	079a                	slli	a5,a5,0x6
    80003abe:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003ac0:	00099783          	lh	a5,0(s3)
    80003ac4:	cf9d                	beqz	a5,80003b02 <ialloc+0x94>
    brelse(bp);
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	a48080e7          	jalr	-1464(ra) # 8000350e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ace:	0905                	addi	s2,s2,1
    80003ad0:	00ca2703          	lw	a4,12(s4)
    80003ad4:	0009079b          	sext.w	a5,s2
    80003ad8:	fce7e3e3          	bltu	a5,a4,80003a9e <ialloc+0x30>
    80003adc:	74a2                	ld	s1,40(sp)
    80003ade:	7902                	ld	s2,32(sp)
    80003ae0:	69e2                	ld	s3,24(sp)
    80003ae2:	6a42                	ld	s4,16(sp)
    80003ae4:	6aa2                	ld	s5,8(sp)
    80003ae6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003ae8:	00005517          	auipc	a0,0x5
    80003aec:	ad050513          	addi	a0,a0,-1328 # 800085b8 <__func__.1+0x5b0>
    80003af0:	ffffd097          	auipc	ra,0xffffd
    80003af4:	acc080e7          	jalr	-1332(ra) # 800005bc <printf>
  return 0;
    80003af8:	4501                	li	a0,0
}
    80003afa:	70e2                	ld	ra,56(sp)
    80003afc:	7442                	ld	s0,48(sp)
    80003afe:	6121                	addi	sp,sp,64
    80003b00:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b02:	04000613          	li	a2,64
    80003b06:	4581                	li	a1,0
    80003b08:	854e                	mv	a0,s3
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	2f2080e7          	jalr	754(ra) # 80000dfc <memset>
      dip->type = type;
    80003b12:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b16:	8526                	mv	a0,s1
    80003b18:	00001097          	auipc	ra,0x1
    80003b1c:	ca0080e7          	jalr	-864(ra) # 800047b8 <log_write>
      brelse(bp);
    80003b20:	8526                	mv	a0,s1
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	9ec080e7          	jalr	-1556(ra) # 8000350e <brelse>
      return iget(dev, inum);
    80003b2a:	0009059b          	sext.w	a1,s2
    80003b2e:	8556                	mv	a0,s5
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	da2080e7          	jalr	-606(ra) # 800038d2 <iget>
    80003b38:	74a2                	ld	s1,40(sp)
    80003b3a:	7902                	ld	s2,32(sp)
    80003b3c:	69e2                	ld	s3,24(sp)
    80003b3e:	6a42                	ld	s4,16(sp)
    80003b40:	6aa2                	ld	s5,8(sp)
    80003b42:	6b02                	ld	s6,0(sp)
    80003b44:	bf5d                	j	80003afa <ialloc+0x8c>

0000000080003b46 <iupdate>:
{
    80003b46:	1101                	addi	sp,sp,-32
    80003b48:	ec06                	sd	ra,24(sp)
    80003b4a:	e822                	sd	s0,16(sp)
    80003b4c:	e426                	sd	s1,8(sp)
    80003b4e:	e04a                	sd	s2,0(sp)
    80003b50:	1000                	addi	s0,sp,32
    80003b52:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b54:	415c                	lw	a5,4(a0)
    80003b56:	0047d79b          	srliw	a5,a5,0x4
    80003b5a:	0001e597          	auipc	a1,0x1e
    80003b5e:	1165a583          	lw	a1,278(a1) # 80021c70 <sb+0x18>
    80003b62:	9dbd                	addw	a1,a1,a5
    80003b64:	4108                	lw	a0,0(a0)
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	878080e7          	jalr	-1928(ra) # 800033de <bread>
    80003b6e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b70:	05850793          	addi	a5,a0,88
    80003b74:	40d8                	lw	a4,4(s1)
    80003b76:	8b3d                	andi	a4,a4,15
    80003b78:	071a                	slli	a4,a4,0x6
    80003b7a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003b7c:	04449703          	lh	a4,68(s1)
    80003b80:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003b84:	04649703          	lh	a4,70(s1)
    80003b88:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003b8c:	04849703          	lh	a4,72(s1)
    80003b90:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003b94:	04a49703          	lh	a4,74(s1)
    80003b98:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b9c:	44f8                	lw	a4,76(s1)
    80003b9e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003ba0:	03400613          	li	a2,52
    80003ba4:	05048593          	addi	a1,s1,80
    80003ba8:	00c78513          	addi	a0,a5,12
    80003bac:	ffffd097          	auipc	ra,0xffffd
    80003bb0:	2ac080e7          	jalr	684(ra) # 80000e58 <memmove>
  log_write(bp);
    80003bb4:	854a                	mv	a0,s2
    80003bb6:	00001097          	auipc	ra,0x1
    80003bba:	c02080e7          	jalr	-1022(ra) # 800047b8 <log_write>
  brelse(bp);
    80003bbe:	854a                	mv	a0,s2
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	94e080e7          	jalr	-1714(ra) # 8000350e <brelse>
}
    80003bc8:	60e2                	ld	ra,24(sp)
    80003bca:	6442                	ld	s0,16(sp)
    80003bcc:	64a2                	ld	s1,8(sp)
    80003bce:	6902                	ld	s2,0(sp)
    80003bd0:	6105                	addi	sp,sp,32
    80003bd2:	8082                	ret

0000000080003bd4 <idup>:
{
    80003bd4:	1101                	addi	sp,sp,-32
    80003bd6:	ec06                	sd	ra,24(sp)
    80003bd8:	e822                	sd	s0,16(sp)
    80003bda:	e426                	sd	s1,8(sp)
    80003bdc:	1000                	addi	s0,sp,32
    80003bde:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003be0:	0001e517          	auipc	a0,0x1e
    80003be4:	09850513          	addi	a0,a0,152 # 80021c78 <itable>
    80003be8:	ffffd097          	auipc	ra,0xffffd
    80003bec:	118080e7          	jalr	280(ra) # 80000d00 <acquire>
  ip->ref++;
    80003bf0:	449c                	lw	a5,8(s1)
    80003bf2:	2785                	addiw	a5,a5,1
    80003bf4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003bf6:	0001e517          	auipc	a0,0x1e
    80003bfa:	08250513          	addi	a0,a0,130 # 80021c78 <itable>
    80003bfe:	ffffd097          	auipc	ra,0xffffd
    80003c02:	1b6080e7          	jalr	438(ra) # 80000db4 <release>
}
    80003c06:	8526                	mv	a0,s1
    80003c08:	60e2                	ld	ra,24(sp)
    80003c0a:	6442                	ld	s0,16(sp)
    80003c0c:	64a2                	ld	s1,8(sp)
    80003c0e:	6105                	addi	sp,sp,32
    80003c10:	8082                	ret

0000000080003c12 <ilock>:
{
    80003c12:	1101                	addi	sp,sp,-32
    80003c14:	ec06                	sd	ra,24(sp)
    80003c16:	e822                	sd	s0,16(sp)
    80003c18:	e426                	sd	s1,8(sp)
    80003c1a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c1c:	c10d                	beqz	a0,80003c3e <ilock+0x2c>
    80003c1e:	84aa                	mv	s1,a0
    80003c20:	451c                	lw	a5,8(a0)
    80003c22:	00f05e63          	blez	a5,80003c3e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003c26:	0541                	addi	a0,a0,16
    80003c28:	00001097          	auipc	ra,0x1
    80003c2c:	cae080e7          	jalr	-850(ra) # 800048d6 <acquiresleep>
  if(ip->valid == 0){
    80003c30:	40bc                	lw	a5,64(s1)
    80003c32:	cf99                	beqz	a5,80003c50 <ilock+0x3e>
}
    80003c34:	60e2                	ld	ra,24(sp)
    80003c36:	6442                	ld	s0,16(sp)
    80003c38:	64a2                	ld	s1,8(sp)
    80003c3a:	6105                	addi	sp,sp,32
    80003c3c:	8082                	ret
    80003c3e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003c40:	00005517          	auipc	a0,0x5
    80003c44:	99050513          	addi	a0,a0,-1648 # 800085d0 <__func__.1+0x5c8>
    80003c48:	ffffd097          	auipc	ra,0xffffd
    80003c4c:	918080e7          	jalr	-1768(ra) # 80000560 <panic>
    80003c50:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c52:	40dc                	lw	a5,4(s1)
    80003c54:	0047d79b          	srliw	a5,a5,0x4
    80003c58:	0001e597          	auipc	a1,0x1e
    80003c5c:	0185a583          	lw	a1,24(a1) # 80021c70 <sb+0x18>
    80003c60:	9dbd                	addw	a1,a1,a5
    80003c62:	4088                	lw	a0,0(s1)
    80003c64:	fffff097          	auipc	ra,0xfffff
    80003c68:	77a080e7          	jalr	1914(ra) # 800033de <bread>
    80003c6c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c6e:	05850593          	addi	a1,a0,88
    80003c72:	40dc                	lw	a5,4(s1)
    80003c74:	8bbd                	andi	a5,a5,15
    80003c76:	079a                	slli	a5,a5,0x6
    80003c78:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003c7a:	00059783          	lh	a5,0(a1)
    80003c7e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003c82:	00259783          	lh	a5,2(a1)
    80003c86:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003c8a:	00459783          	lh	a5,4(a1)
    80003c8e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003c92:	00659783          	lh	a5,6(a1)
    80003c96:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003c9a:	459c                	lw	a5,8(a1)
    80003c9c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003c9e:	03400613          	li	a2,52
    80003ca2:	05b1                	addi	a1,a1,12
    80003ca4:	05048513          	addi	a0,s1,80
    80003ca8:	ffffd097          	auipc	ra,0xffffd
    80003cac:	1b0080e7          	jalr	432(ra) # 80000e58 <memmove>
    brelse(bp);
    80003cb0:	854a                	mv	a0,s2
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	85c080e7          	jalr	-1956(ra) # 8000350e <brelse>
    ip->valid = 1;
    80003cba:	4785                	li	a5,1
    80003cbc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003cbe:	04449783          	lh	a5,68(s1)
    80003cc2:	c399                	beqz	a5,80003cc8 <ilock+0xb6>
    80003cc4:	6902                	ld	s2,0(sp)
    80003cc6:	b7bd                	j	80003c34 <ilock+0x22>
      panic("ilock: no type");
    80003cc8:	00005517          	auipc	a0,0x5
    80003ccc:	91050513          	addi	a0,a0,-1776 # 800085d8 <__func__.1+0x5d0>
    80003cd0:	ffffd097          	auipc	ra,0xffffd
    80003cd4:	890080e7          	jalr	-1904(ra) # 80000560 <panic>

0000000080003cd8 <iunlock>:
{
    80003cd8:	1101                	addi	sp,sp,-32
    80003cda:	ec06                	sd	ra,24(sp)
    80003cdc:	e822                	sd	s0,16(sp)
    80003cde:	e426                	sd	s1,8(sp)
    80003ce0:	e04a                	sd	s2,0(sp)
    80003ce2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003ce4:	c905                	beqz	a0,80003d14 <iunlock+0x3c>
    80003ce6:	84aa                	mv	s1,a0
    80003ce8:	01050913          	addi	s2,a0,16
    80003cec:	854a                	mv	a0,s2
    80003cee:	00001097          	auipc	ra,0x1
    80003cf2:	c82080e7          	jalr	-894(ra) # 80004970 <holdingsleep>
    80003cf6:	cd19                	beqz	a0,80003d14 <iunlock+0x3c>
    80003cf8:	449c                	lw	a5,8(s1)
    80003cfa:	00f05d63          	blez	a5,80003d14 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003cfe:	854a                	mv	a0,s2
    80003d00:	00001097          	auipc	ra,0x1
    80003d04:	c2c080e7          	jalr	-980(ra) # 8000492c <releasesleep>
}
    80003d08:	60e2                	ld	ra,24(sp)
    80003d0a:	6442                	ld	s0,16(sp)
    80003d0c:	64a2                	ld	s1,8(sp)
    80003d0e:	6902                	ld	s2,0(sp)
    80003d10:	6105                	addi	sp,sp,32
    80003d12:	8082                	ret
    panic("iunlock");
    80003d14:	00005517          	auipc	a0,0x5
    80003d18:	8d450513          	addi	a0,a0,-1836 # 800085e8 <__func__.1+0x5e0>
    80003d1c:	ffffd097          	auipc	ra,0xffffd
    80003d20:	844080e7          	jalr	-1980(ra) # 80000560 <panic>

0000000080003d24 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d24:	7179                	addi	sp,sp,-48
    80003d26:	f406                	sd	ra,40(sp)
    80003d28:	f022                	sd	s0,32(sp)
    80003d2a:	ec26                	sd	s1,24(sp)
    80003d2c:	e84a                	sd	s2,16(sp)
    80003d2e:	e44e                	sd	s3,8(sp)
    80003d30:	1800                	addi	s0,sp,48
    80003d32:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003d34:	05050493          	addi	s1,a0,80
    80003d38:	08050913          	addi	s2,a0,128
    80003d3c:	a021                	j	80003d44 <itrunc+0x20>
    80003d3e:	0491                	addi	s1,s1,4
    80003d40:	01248d63          	beq	s1,s2,80003d5a <itrunc+0x36>
    if(ip->addrs[i]){
    80003d44:	408c                	lw	a1,0(s1)
    80003d46:	dde5                	beqz	a1,80003d3e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003d48:	0009a503          	lw	a0,0(s3)
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	8d6080e7          	jalr	-1834(ra) # 80003622 <bfree>
      ip->addrs[i] = 0;
    80003d54:	0004a023          	sw	zero,0(s1)
    80003d58:	b7dd                	j	80003d3e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003d5a:	0809a583          	lw	a1,128(s3)
    80003d5e:	ed99                	bnez	a1,80003d7c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003d60:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003d64:	854e                	mv	a0,s3
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	de0080e7          	jalr	-544(ra) # 80003b46 <iupdate>
}
    80003d6e:	70a2                	ld	ra,40(sp)
    80003d70:	7402                	ld	s0,32(sp)
    80003d72:	64e2                	ld	s1,24(sp)
    80003d74:	6942                	ld	s2,16(sp)
    80003d76:	69a2                	ld	s3,8(sp)
    80003d78:	6145                	addi	sp,sp,48
    80003d7a:	8082                	ret
    80003d7c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003d7e:	0009a503          	lw	a0,0(s3)
    80003d82:	fffff097          	auipc	ra,0xfffff
    80003d86:	65c080e7          	jalr	1628(ra) # 800033de <bread>
    80003d8a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003d8c:	05850493          	addi	s1,a0,88
    80003d90:	45850913          	addi	s2,a0,1112
    80003d94:	a021                	j	80003d9c <itrunc+0x78>
    80003d96:	0491                	addi	s1,s1,4
    80003d98:	01248b63          	beq	s1,s2,80003dae <itrunc+0x8a>
      if(a[j])
    80003d9c:	408c                	lw	a1,0(s1)
    80003d9e:	dde5                	beqz	a1,80003d96 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003da0:	0009a503          	lw	a0,0(s3)
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	87e080e7          	jalr	-1922(ra) # 80003622 <bfree>
    80003dac:	b7ed                	j	80003d96 <itrunc+0x72>
    brelse(bp);
    80003dae:	8552                	mv	a0,s4
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	75e080e7          	jalr	1886(ra) # 8000350e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003db8:	0809a583          	lw	a1,128(s3)
    80003dbc:	0009a503          	lw	a0,0(s3)
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	862080e7          	jalr	-1950(ra) # 80003622 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003dc8:	0809a023          	sw	zero,128(s3)
    80003dcc:	6a02                	ld	s4,0(sp)
    80003dce:	bf49                	j	80003d60 <itrunc+0x3c>

0000000080003dd0 <iput>:
{
    80003dd0:	1101                	addi	sp,sp,-32
    80003dd2:	ec06                	sd	ra,24(sp)
    80003dd4:	e822                	sd	s0,16(sp)
    80003dd6:	e426                	sd	s1,8(sp)
    80003dd8:	1000                	addi	s0,sp,32
    80003dda:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003ddc:	0001e517          	auipc	a0,0x1e
    80003de0:	e9c50513          	addi	a0,a0,-356 # 80021c78 <itable>
    80003de4:	ffffd097          	auipc	ra,0xffffd
    80003de8:	f1c080e7          	jalr	-228(ra) # 80000d00 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003dec:	4498                	lw	a4,8(s1)
    80003dee:	4785                	li	a5,1
    80003df0:	02f70263          	beq	a4,a5,80003e14 <iput+0x44>
  ip->ref--;
    80003df4:	449c                	lw	a5,8(s1)
    80003df6:	37fd                	addiw	a5,a5,-1
    80003df8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003dfa:	0001e517          	auipc	a0,0x1e
    80003dfe:	e7e50513          	addi	a0,a0,-386 # 80021c78 <itable>
    80003e02:	ffffd097          	auipc	ra,0xffffd
    80003e06:	fb2080e7          	jalr	-78(ra) # 80000db4 <release>
}
    80003e0a:	60e2                	ld	ra,24(sp)
    80003e0c:	6442                	ld	s0,16(sp)
    80003e0e:	64a2                	ld	s1,8(sp)
    80003e10:	6105                	addi	sp,sp,32
    80003e12:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e14:	40bc                	lw	a5,64(s1)
    80003e16:	dff9                	beqz	a5,80003df4 <iput+0x24>
    80003e18:	04a49783          	lh	a5,74(s1)
    80003e1c:	ffe1                	bnez	a5,80003df4 <iput+0x24>
    80003e1e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003e20:	01048913          	addi	s2,s1,16
    80003e24:	854a                	mv	a0,s2
    80003e26:	00001097          	auipc	ra,0x1
    80003e2a:	ab0080e7          	jalr	-1360(ra) # 800048d6 <acquiresleep>
    release(&itable.lock);
    80003e2e:	0001e517          	auipc	a0,0x1e
    80003e32:	e4a50513          	addi	a0,a0,-438 # 80021c78 <itable>
    80003e36:	ffffd097          	auipc	ra,0xffffd
    80003e3a:	f7e080e7          	jalr	-130(ra) # 80000db4 <release>
    itrunc(ip);
    80003e3e:	8526                	mv	a0,s1
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	ee4080e7          	jalr	-284(ra) # 80003d24 <itrunc>
    ip->type = 0;
    80003e48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	cf8080e7          	jalr	-776(ra) # 80003b46 <iupdate>
    ip->valid = 0;
    80003e56:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003e5a:	854a                	mv	a0,s2
    80003e5c:	00001097          	auipc	ra,0x1
    80003e60:	ad0080e7          	jalr	-1328(ra) # 8000492c <releasesleep>
    acquire(&itable.lock);
    80003e64:	0001e517          	auipc	a0,0x1e
    80003e68:	e1450513          	addi	a0,a0,-492 # 80021c78 <itable>
    80003e6c:	ffffd097          	auipc	ra,0xffffd
    80003e70:	e94080e7          	jalr	-364(ra) # 80000d00 <acquire>
    80003e74:	6902                	ld	s2,0(sp)
    80003e76:	bfbd                	j	80003df4 <iput+0x24>

0000000080003e78 <iunlockput>:
{
    80003e78:	1101                	addi	sp,sp,-32
    80003e7a:	ec06                	sd	ra,24(sp)
    80003e7c:	e822                	sd	s0,16(sp)
    80003e7e:	e426                	sd	s1,8(sp)
    80003e80:	1000                	addi	s0,sp,32
    80003e82:	84aa                	mv	s1,a0
  iunlock(ip);
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	e54080e7          	jalr	-428(ra) # 80003cd8 <iunlock>
  iput(ip);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	00000097          	auipc	ra,0x0
    80003e92:	f42080e7          	jalr	-190(ra) # 80003dd0 <iput>
}
    80003e96:	60e2                	ld	ra,24(sp)
    80003e98:	6442                	ld	s0,16(sp)
    80003e9a:	64a2                	ld	s1,8(sp)
    80003e9c:	6105                	addi	sp,sp,32
    80003e9e:	8082                	ret

0000000080003ea0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003ea0:	1141                	addi	sp,sp,-16
    80003ea2:	e422                	sd	s0,8(sp)
    80003ea4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ea6:	411c                	lw	a5,0(a0)
    80003ea8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003eaa:	415c                	lw	a5,4(a0)
    80003eac:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003eae:	04451783          	lh	a5,68(a0)
    80003eb2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003eb6:	04a51783          	lh	a5,74(a0)
    80003eba:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003ebe:	04c56783          	lwu	a5,76(a0)
    80003ec2:	e99c                	sd	a5,16(a1)
}
    80003ec4:	6422                	ld	s0,8(sp)
    80003ec6:	0141                	addi	sp,sp,16
    80003ec8:	8082                	ret

0000000080003eca <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003eca:	457c                	lw	a5,76(a0)
    80003ecc:	10d7e563          	bltu	a5,a3,80003fd6 <readi+0x10c>
{
    80003ed0:	7159                	addi	sp,sp,-112
    80003ed2:	f486                	sd	ra,104(sp)
    80003ed4:	f0a2                	sd	s0,96(sp)
    80003ed6:	eca6                	sd	s1,88(sp)
    80003ed8:	e0d2                	sd	s4,64(sp)
    80003eda:	fc56                	sd	s5,56(sp)
    80003edc:	f85a                	sd	s6,48(sp)
    80003ede:	f45e                	sd	s7,40(sp)
    80003ee0:	1880                	addi	s0,sp,112
    80003ee2:	8b2a                	mv	s6,a0
    80003ee4:	8bae                	mv	s7,a1
    80003ee6:	8a32                	mv	s4,a2
    80003ee8:	84b6                	mv	s1,a3
    80003eea:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003eec:	9f35                	addw	a4,a4,a3
    return 0;
    80003eee:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003ef0:	0cd76a63          	bltu	a4,a3,80003fc4 <readi+0xfa>
    80003ef4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003ef6:	00e7f463          	bgeu	a5,a4,80003efe <readi+0x34>
    n = ip->size - off;
    80003efa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003efe:	0a0a8963          	beqz	s5,80003fb0 <readi+0xe6>
    80003f02:	e8ca                	sd	s2,80(sp)
    80003f04:	f062                	sd	s8,32(sp)
    80003f06:	ec66                	sd	s9,24(sp)
    80003f08:	e86a                	sd	s10,16(sp)
    80003f0a:	e46e                	sd	s11,8(sp)
    80003f0c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f0e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f12:	5c7d                	li	s8,-1
    80003f14:	a82d                	j	80003f4e <readi+0x84>
    80003f16:	020d1d93          	slli	s11,s10,0x20
    80003f1a:	020ddd93          	srli	s11,s11,0x20
    80003f1e:	05890613          	addi	a2,s2,88
    80003f22:	86ee                	mv	a3,s11
    80003f24:	963a                	add	a2,a2,a4
    80003f26:	85d2                	mv	a1,s4
    80003f28:	855e                	mv	a0,s7
    80003f2a:	fffff097          	auipc	ra,0xfffff
    80003f2e:	896080e7          	jalr	-1898(ra) # 800027c0 <either_copyout>
    80003f32:	05850d63          	beq	a0,s8,80003f8c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003f36:	854a                	mv	a0,s2
    80003f38:	fffff097          	auipc	ra,0xfffff
    80003f3c:	5d6080e7          	jalr	1494(ra) # 8000350e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f40:	013d09bb          	addw	s3,s10,s3
    80003f44:	009d04bb          	addw	s1,s10,s1
    80003f48:	9a6e                	add	s4,s4,s11
    80003f4a:	0559fd63          	bgeu	s3,s5,80003fa4 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003f4e:	00a4d59b          	srliw	a1,s1,0xa
    80003f52:	855a                	mv	a0,s6
    80003f54:	00000097          	auipc	ra,0x0
    80003f58:	88e080e7          	jalr	-1906(ra) # 800037e2 <bmap>
    80003f5c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f60:	c9b1                	beqz	a1,80003fb4 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003f62:	000b2503          	lw	a0,0(s6)
    80003f66:	fffff097          	auipc	ra,0xfffff
    80003f6a:	478080e7          	jalr	1144(ra) # 800033de <bread>
    80003f6e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f70:	3ff4f713          	andi	a4,s1,1023
    80003f74:	40ec87bb          	subw	a5,s9,a4
    80003f78:	413a86bb          	subw	a3,s5,s3
    80003f7c:	8d3e                	mv	s10,a5
    80003f7e:	2781                	sext.w	a5,a5
    80003f80:	0006861b          	sext.w	a2,a3
    80003f84:	f8f679e3          	bgeu	a2,a5,80003f16 <readi+0x4c>
    80003f88:	8d36                	mv	s10,a3
    80003f8a:	b771                	j	80003f16 <readi+0x4c>
      brelse(bp);
    80003f8c:	854a                	mv	a0,s2
    80003f8e:	fffff097          	auipc	ra,0xfffff
    80003f92:	580080e7          	jalr	1408(ra) # 8000350e <brelse>
      tot = -1;
    80003f96:	59fd                	li	s3,-1
      break;
    80003f98:	6946                	ld	s2,80(sp)
    80003f9a:	7c02                	ld	s8,32(sp)
    80003f9c:	6ce2                	ld	s9,24(sp)
    80003f9e:	6d42                	ld	s10,16(sp)
    80003fa0:	6da2                	ld	s11,8(sp)
    80003fa2:	a831                	j	80003fbe <readi+0xf4>
    80003fa4:	6946                	ld	s2,80(sp)
    80003fa6:	7c02                	ld	s8,32(sp)
    80003fa8:	6ce2                	ld	s9,24(sp)
    80003faa:	6d42                	ld	s10,16(sp)
    80003fac:	6da2                	ld	s11,8(sp)
    80003fae:	a801                	j	80003fbe <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fb0:	89d6                	mv	s3,s5
    80003fb2:	a031                	j	80003fbe <readi+0xf4>
    80003fb4:	6946                	ld	s2,80(sp)
    80003fb6:	7c02                	ld	s8,32(sp)
    80003fb8:	6ce2                	ld	s9,24(sp)
    80003fba:	6d42                	ld	s10,16(sp)
    80003fbc:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003fbe:	0009851b          	sext.w	a0,s3
    80003fc2:	69a6                	ld	s3,72(sp)
}
    80003fc4:	70a6                	ld	ra,104(sp)
    80003fc6:	7406                	ld	s0,96(sp)
    80003fc8:	64e6                	ld	s1,88(sp)
    80003fca:	6a06                	ld	s4,64(sp)
    80003fcc:	7ae2                	ld	s5,56(sp)
    80003fce:	7b42                	ld	s6,48(sp)
    80003fd0:	7ba2                	ld	s7,40(sp)
    80003fd2:	6165                	addi	sp,sp,112
    80003fd4:	8082                	ret
    return 0;
    80003fd6:	4501                	li	a0,0
}
    80003fd8:	8082                	ret

0000000080003fda <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fda:	457c                	lw	a5,76(a0)
    80003fdc:	10d7ee63          	bltu	a5,a3,800040f8 <writei+0x11e>
{
    80003fe0:	7159                	addi	sp,sp,-112
    80003fe2:	f486                	sd	ra,104(sp)
    80003fe4:	f0a2                	sd	s0,96(sp)
    80003fe6:	e8ca                	sd	s2,80(sp)
    80003fe8:	e0d2                	sd	s4,64(sp)
    80003fea:	fc56                	sd	s5,56(sp)
    80003fec:	f85a                	sd	s6,48(sp)
    80003fee:	f45e                	sd	s7,40(sp)
    80003ff0:	1880                	addi	s0,sp,112
    80003ff2:	8aaa                	mv	s5,a0
    80003ff4:	8bae                	mv	s7,a1
    80003ff6:	8a32                	mv	s4,a2
    80003ff8:	8936                	mv	s2,a3
    80003ffa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ffc:	00e687bb          	addw	a5,a3,a4
    80004000:	0ed7ee63          	bltu	a5,a3,800040fc <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004004:	00043737          	lui	a4,0x43
    80004008:	0ef76c63          	bltu	a4,a5,80004100 <writei+0x126>
    8000400c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000400e:	0c0b0d63          	beqz	s6,800040e8 <writei+0x10e>
    80004012:	eca6                	sd	s1,88(sp)
    80004014:	f062                	sd	s8,32(sp)
    80004016:	ec66                	sd	s9,24(sp)
    80004018:	e86a                	sd	s10,16(sp)
    8000401a:	e46e                	sd	s11,8(sp)
    8000401c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000401e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004022:	5c7d                	li	s8,-1
    80004024:	a091                	j	80004068 <writei+0x8e>
    80004026:	020d1d93          	slli	s11,s10,0x20
    8000402a:	020ddd93          	srli	s11,s11,0x20
    8000402e:	05848513          	addi	a0,s1,88
    80004032:	86ee                	mv	a3,s11
    80004034:	8652                	mv	a2,s4
    80004036:	85de                	mv	a1,s7
    80004038:	953a                	add	a0,a0,a4
    8000403a:	ffffe097          	auipc	ra,0xffffe
    8000403e:	7dc080e7          	jalr	2012(ra) # 80002816 <either_copyin>
    80004042:	07850263          	beq	a0,s8,800040a6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004046:	8526                	mv	a0,s1
    80004048:	00000097          	auipc	ra,0x0
    8000404c:	770080e7          	jalr	1904(ra) # 800047b8 <log_write>
    brelse(bp);
    80004050:	8526                	mv	a0,s1
    80004052:	fffff097          	auipc	ra,0xfffff
    80004056:	4bc080e7          	jalr	1212(ra) # 8000350e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000405a:	013d09bb          	addw	s3,s10,s3
    8000405e:	012d093b          	addw	s2,s10,s2
    80004062:	9a6e                	add	s4,s4,s11
    80004064:	0569f663          	bgeu	s3,s6,800040b0 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80004068:	00a9559b          	srliw	a1,s2,0xa
    8000406c:	8556                	mv	a0,s5
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	774080e7          	jalr	1908(ra) # 800037e2 <bmap>
    80004076:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000407a:	c99d                	beqz	a1,800040b0 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000407c:	000aa503          	lw	a0,0(s5)
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	35e080e7          	jalr	862(ra) # 800033de <bread>
    80004088:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000408a:	3ff97713          	andi	a4,s2,1023
    8000408e:	40ec87bb          	subw	a5,s9,a4
    80004092:	413b06bb          	subw	a3,s6,s3
    80004096:	8d3e                	mv	s10,a5
    80004098:	2781                	sext.w	a5,a5
    8000409a:	0006861b          	sext.w	a2,a3
    8000409e:	f8f674e3          	bgeu	a2,a5,80004026 <writei+0x4c>
    800040a2:	8d36                	mv	s10,a3
    800040a4:	b749                	j	80004026 <writei+0x4c>
      brelse(bp);
    800040a6:	8526                	mv	a0,s1
    800040a8:	fffff097          	auipc	ra,0xfffff
    800040ac:	466080e7          	jalr	1126(ra) # 8000350e <brelse>
  }

  if(off > ip->size)
    800040b0:	04caa783          	lw	a5,76(s5)
    800040b4:	0327fc63          	bgeu	a5,s2,800040ec <writei+0x112>
    ip->size = off;
    800040b8:	052aa623          	sw	s2,76(s5)
    800040bc:	64e6                	ld	s1,88(sp)
    800040be:	7c02                	ld	s8,32(sp)
    800040c0:	6ce2                	ld	s9,24(sp)
    800040c2:	6d42                	ld	s10,16(sp)
    800040c4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800040c6:	8556                	mv	a0,s5
    800040c8:	00000097          	auipc	ra,0x0
    800040cc:	a7e080e7          	jalr	-1410(ra) # 80003b46 <iupdate>

  return tot;
    800040d0:	0009851b          	sext.w	a0,s3
    800040d4:	69a6                	ld	s3,72(sp)
}
    800040d6:	70a6                	ld	ra,104(sp)
    800040d8:	7406                	ld	s0,96(sp)
    800040da:	6946                	ld	s2,80(sp)
    800040dc:	6a06                	ld	s4,64(sp)
    800040de:	7ae2                	ld	s5,56(sp)
    800040e0:	7b42                	ld	s6,48(sp)
    800040e2:	7ba2                	ld	s7,40(sp)
    800040e4:	6165                	addi	sp,sp,112
    800040e6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040e8:	89da                	mv	s3,s6
    800040ea:	bff1                	j	800040c6 <writei+0xec>
    800040ec:	64e6                	ld	s1,88(sp)
    800040ee:	7c02                	ld	s8,32(sp)
    800040f0:	6ce2                	ld	s9,24(sp)
    800040f2:	6d42                	ld	s10,16(sp)
    800040f4:	6da2                	ld	s11,8(sp)
    800040f6:	bfc1                	j	800040c6 <writei+0xec>
    return -1;
    800040f8:	557d                	li	a0,-1
}
    800040fa:	8082                	ret
    return -1;
    800040fc:	557d                	li	a0,-1
    800040fe:	bfe1                	j	800040d6 <writei+0xfc>
    return -1;
    80004100:	557d                	li	a0,-1
    80004102:	bfd1                	j	800040d6 <writei+0xfc>

0000000080004104 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004104:	1141                	addi	sp,sp,-16
    80004106:	e406                	sd	ra,8(sp)
    80004108:	e022                	sd	s0,0(sp)
    8000410a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000410c:	4639                	li	a2,14
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	dbe080e7          	jalr	-578(ra) # 80000ecc <strncmp>
}
    80004116:	60a2                	ld	ra,8(sp)
    80004118:	6402                	ld	s0,0(sp)
    8000411a:	0141                	addi	sp,sp,16
    8000411c:	8082                	ret

000000008000411e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000411e:	7139                	addi	sp,sp,-64
    80004120:	fc06                	sd	ra,56(sp)
    80004122:	f822                	sd	s0,48(sp)
    80004124:	f426                	sd	s1,40(sp)
    80004126:	f04a                	sd	s2,32(sp)
    80004128:	ec4e                	sd	s3,24(sp)
    8000412a:	e852                	sd	s4,16(sp)
    8000412c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000412e:	04451703          	lh	a4,68(a0)
    80004132:	4785                	li	a5,1
    80004134:	00f71a63          	bne	a4,a5,80004148 <dirlookup+0x2a>
    80004138:	892a                	mv	s2,a0
    8000413a:	89ae                	mv	s3,a1
    8000413c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000413e:	457c                	lw	a5,76(a0)
    80004140:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004142:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004144:	e79d                	bnez	a5,80004172 <dirlookup+0x54>
    80004146:	a8a5                	j	800041be <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004148:	00004517          	auipc	a0,0x4
    8000414c:	4a850513          	addi	a0,a0,1192 # 800085f0 <__func__.1+0x5e8>
    80004150:	ffffc097          	auipc	ra,0xffffc
    80004154:	410080e7          	jalr	1040(ra) # 80000560 <panic>
      panic("dirlookup read");
    80004158:	00004517          	auipc	a0,0x4
    8000415c:	4b050513          	addi	a0,a0,1200 # 80008608 <__func__.1+0x600>
    80004160:	ffffc097          	auipc	ra,0xffffc
    80004164:	400080e7          	jalr	1024(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004168:	24c1                	addiw	s1,s1,16
    8000416a:	04c92783          	lw	a5,76(s2)
    8000416e:	04f4f763          	bgeu	s1,a5,800041bc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004172:	4741                	li	a4,16
    80004174:	86a6                	mv	a3,s1
    80004176:	fc040613          	addi	a2,s0,-64
    8000417a:	4581                	li	a1,0
    8000417c:	854a                	mv	a0,s2
    8000417e:	00000097          	auipc	ra,0x0
    80004182:	d4c080e7          	jalr	-692(ra) # 80003eca <readi>
    80004186:	47c1                	li	a5,16
    80004188:	fcf518e3          	bne	a0,a5,80004158 <dirlookup+0x3a>
    if(de.inum == 0)
    8000418c:	fc045783          	lhu	a5,-64(s0)
    80004190:	dfe1                	beqz	a5,80004168 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004192:	fc240593          	addi	a1,s0,-62
    80004196:	854e                	mv	a0,s3
    80004198:	00000097          	auipc	ra,0x0
    8000419c:	f6c080e7          	jalr	-148(ra) # 80004104 <namecmp>
    800041a0:	f561                	bnez	a0,80004168 <dirlookup+0x4a>
      if(poff)
    800041a2:	000a0463          	beqz	s4,800041aa <dirlookup+0x8c>
        *poff = off;
    800041a6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041aa:	fc045583          	lhu	a1,-64(s0)
    800041ae:	00092503          	lw	a0,0(s2)
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	720080e7          	jalr	1824(ra) # 800038d2 <iget>
    800041ba:	a011                	j	800041be <dirlookup+0xa0>
  return 0;
    800041bc:	4501                	li	a0,0
}
    800041be:	70e2                	ld	ra,56(sp)
    800041c0:	7442                	ld	s0,48(sp)
    800041c2:	74a2                	ld	s1,40(sp)
    800041c4:	7902                	ld	s2,32(sp)
    800041c6:	69e2                	ld	s3,24(sp)
    800041c8:	6a42                	ld	s4,16(sp)
    800041ca:	6121                	addi	sp,sp,64
    800041cc:	8082                	ret

00000000800041ce <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800041ce:	711d                	addi	sp,sp,-96
    800041d0:	ec86                	sd	ra,88(sp)
    800041d2:	e8a2                	sd	s0,80(sp)
    800041d4:	e4a6                	sd	s1,72(sp)
    800041d6:	e0ca                	sd	s2,64(sp)
    800041d8:	fc4e                	sd	s3,56(sp)
    800041da:	f852                	sd	s4,48(sp)
    800041dc:	f456                	sd	s5,40(sp)
    800041de:	f05a                	sd	s6,32(sp)
    800041e0:	ec5e                	sd	s7,24(sp)
    800041e2:	e862                	sd	s8,16(sp)
    800041e4:	e466                	sd	s9,8(sp)
    800041e6:	1080                	addi	s0,sp,96
    800041e8:	84aa                	mv	s1,a0
    800041ea:	8b2e                	mv	s6,a1
    800041ec:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800041ee:	00054703          	lbu	a4,0(a0)
    800041f2:	02f00793          	li	a5,47
    800041f6:	02f70263          	beq	a4,a5,8000421a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800041fa:	ffffe097          	auipc	ra,0xffffe
    800041fe:	a0c080e7          	jalr	-1524(ra) # 80001c06 <myproc>
    80004202:	15053503          	ld	a0,336(a0)
    80004206:	00000097          	auipc	ra,0x0
    8000420a:	9ce080e7          	jalr	-1586(ra) # 80003bd4 <idup>
    8000420e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004210:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004214:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004216:	4b85                	li	s7,1
    80004218:	a875                	j	800042d4 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000421a:	4585                	li	a1,1
    8000421c:	4505                	li	a0,1
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	6b4080e7          	jalr	1716(ra) # 800038d2 <iget>
    80004226:	8a2a                	mv	s4,a0
    80004228:	b7e5                	j	80004210 <namex+0x42>
      iunlockput(ip);
    8000422a:	8552                	mv	a0,s4
    8000422c:	00000097          	auipc	ra,0x0
    80004230:	c4c080e7          	jalr	-948(ra) # 80003e78 <iunlockput>
      return 0;
    80004234:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004236:	8552                	mv	a0,s4
    80004238:	60e6                	ld	ra,88(sp)
    8000423a:	6446                	ld	s0,80(sp)
    8000423c:	64a6                	ld	s1,72(sp)
    8000423e:	6906                	ld	s2,64(sp)
    80004240:	79e2                	ld	s3,56(sp)
    80004242:	7a42                	ld	s4,48(sp)
    80004244:	7aa2                	ld	s5,40(sp)
    80004246:	7b02                	ld	s6,32(sp)
    80004248:	6be2                	ld	s7,24(sp)
    8000424a:	6c42                	ld	s8,16(sp)
    8000424c:	6ca2                	ld	s9,8(sp)
    8000424e:	6125                	addi	sp,sp,96
    80004250:	8082                	ret
      iunlock(ip);
    80004252:	8552                	mv	a0,s4
    80004254:	00000097          	auipc	ra,0x0
    80004258:	a84080e7          	jalr	-1404(ra) # 80003cd8 <iunlock>
      return ip;
    8000425c:	bfe9                	j	80004236 <namex+0x68>
      iunlockput(ip);
    8000425e:	8552                	mv	a0,s4
    80004260:	00000097          	auipc	ra,0x0
    80004264:	c18080e7          	jalr	-1000(ra) # 80003e78 <iunlockput>
      return 0;
    80004268:	8a4e                	mv	s4,s3
    8000426a:	b7f1                	j	80004236 <namex+0x68>
  len = path - s;
    8000426c:	40998633          	sub	a2,s3,s1
    80004270:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004274:	099c5863          	bge	s8,s9,80004304 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004278:	4639                	li	a2,14
    8000427a:	85a6                	mv	a1,s1
    8000427c:	8556                	mv	a0,s5
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	bda080e7          	jalr	-1062(ra) # 80000e58 <memmove>
    80004286:	84ce                	mv	s1,s3
  while(*path == '/')
    80004288:	0004c783          	lbu	a5,0(s1)
    8000428c:	01279763          	bne	a5,s2,8000429a <namex+0xcc>
    path++;
    80004290:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004292:	0004c783          	lbu	a5,0(s1)
    80004296:	ff278de3          	beq	a5,s2,80004290 <namex+0xc2>
    ilock(ip);
    8000429a:	8552                	mv	a0,s4
    8000429c:	00000097          	auipc	ra,0x0
    800042a0:	976080e7          	jalr	-1674(ra) # 80003c12 <ilock>
    if(ip->type != T_DIR){
    800042a4:	044a1783          	lh	a5,68(s4)
    800042a8:	f97791e3          	bne	a5,s7,8000422a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800042ac:	000b0563          	beqz	s6,800042b6 <namex+0xe8>
    800042b0:	0004c783          	lbu	a5,0(s1)
    800042b4:	dfd9                	beqz	a5,80004252 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800042b6:	4601                	li	a2,0
    800042b8:	85d6                	mv	a1,s5
    800042ba:	8552                	mv	a0,s4
    800042bc:	00000097          	auipc	ra,0x0
    800042c0:	e62080e7          	jalr	-414(ra) # 8000411e <dirlookup>
    800042c4:	89aa                	mv	s3,a0
    800042c6:	dd41                	beqz	a0,8000425e <namex+0x90>
    iunlockput(ip);
    800042c8:	8552                	mv	a0,s4
    800042ca:	00000097          	auipc	ra,0x0
    800042ce:	bae080e7          	jalr	-1106(ra) # 80003e78 <iunlockput>
    ip = next;
    800042d2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800042d4:	0004c783          	lbu	a5,0(s1)
    800042d8:	01279763          	bne	a5,s2,800042e6 <namex+0x118>
    path++;
    800042dc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042de:	0004c783          	lbu	a5,0(s1)
    800042e2:	ff278de3          	beq	a5,s2,800042dc <namex+0x10e>
  if(*path == 0)
    800042e6:	cb9d                	beqz	a5,8000431c <namex+0x14e>
  while(*path != '/' && *path != 0)
    800042e8:	0004c783          	lbu	a5,0(s1)
    800042ec:	89a6                	mv	s3,s1
  len = path - s;
    800042ee:	4c81                	li	s9,0
    800042f0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800042f2:	01278963          	beq	a5,s2,80004304 <namex+0x136>
    800042f6:	dbbd                	beqz	a5,8000426c <namex+0x9e>
    path++;
    800042f8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800042fa:	0009c783          	lbu	a5,0(s3)
    800042fe:	ff279ce3          	bne	a5,s2,800042f6 <namex+0x128>
    80004302:	b7ad                	j	8000426c <namex+0x9e>
    memmove(name, s, len);
    80004304:	2601                	sext.w	a2,a2
    80004306:	85a6                	mv	a1,s1
    80004308:	8556                	mv	a0,s5
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	b4e080e7          	jalr	-1202(ra) # 80000e58 <memmove>
    name[len] = 0;
    80004312:	9cd6                	add	s9,s9,s5
    80004314:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004318:	84ce                	mv	s1,s3
    8000431a:	b7bd                	j	80004288 <namex+0xba>
  if(nameiparent){
    8000431c:	f00b0de3          	beqz	s6,80004236 <namex+0x68>
    iput(ip);
    80004320:	8552                	mv	a0,s4
    80004322:	00000097          	auipc	ra,0x0
    80004326:	aae080e7          	jalr	-1362(ra) # 80003dd0 <iput>
    return 0;
    8000432a:	4a01                	li	s4,0
    8000432c:	b729                	j	80004236 <namex+0x68>

000000008000432e <dirlink>:
{
    8000432e:	7139                	addi	sp,sp,-64
    80004330:	fc06                	sd	ra,56(sp)
    80004332:	f822                	sd	s0,48(sp)
    80004334:	f04a                	sd	s2,32(sp)
    80004336:	ec4e                	sd	s3,24(sp)
    80004338:	e852                	sd	s4,16(sp)
    8000433a:	0080                	addi	s0,sp,64
    8000433c:	892a                	mv	s2,a0
    8000433e:	8a2e                	mv	s4,a1
    80004340:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004342:	4601                	li	a2,0
    80004344:	00000097          	auipc	ra,0x0
    80004348:	dda080e7          	jalr	-550(ra) # 8000411e <dirlookup>
    8000434c:	ed25                	bnez	a0,800043c4 <dirlink+0x96>
    8000434e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004350:	04c92483          	lw	s1,76(s2)
    80004354:	c49d                	beqz	s1,80004382 <dirlink+0x54>
    80004356:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004358:	4741                	li	a4,16
    8000435a:	86a6                	mv	a3,s1
    8000435c:	fc040613          	addi	a2,s0,-64
    80004360:	4581                	li	a1,0
    80004362:	854a                	mv	a0,s2
    80004364:	00000097          	auipc	ra,0x0
    80004368:	b66080e7          	jalr	-1178(ra) # 80003eca <readi>
    8000436c:	47c1                	li	a5,16
    8000436e:	06f51163          	bne	a0,a5,800043d0 <dirlink+0xa2>
    if(de.inum == 0)
    80004372:	fc045783          	lhu	a5,-64(s0)
    80004376:	c791                	beqz	a5,80004382 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004378:	24c1                	addiw	s1,s1,16
    8000437a:	04c92783          	lw	a5,76(s2)
    8000437e:	fcf4ede3          	bltu	s1,a5,80004358 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004382:	4639                	li	a2,14
    80004384:	85d2                	mv	a1,s4
    80004386:	fc240513          	addi	a0,s0,-62
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	b78080e7          	jalr	-1160(ra) # 80000f02 <strncpy>
  de.inum = inum;
    80004392:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004396:	4741                	li	a4,16
    80004398:	86a6                	mv	a3,s1
    8000439a:	fc040613          	addi	a2,s0,-64
    8000439e:	4581                	li	a1,0
    800043a0:	854a                	mv	a0,s2
    800043a2:	00000097          	auipc	ra,0x0
    800043a6:	c38080e7          	jalr	-968(ra) # 80003fda <writei>
    800043aa:	1541                	addi	a0,a0,-16
    800043ac:	00a03533          	snez	a0,a0
    800043b0:	40a00533          	neg	a0,a0
    800043b4:	74a2                	ld	s1,40(sp)
}
    800043b6:	70e2                	ld	ra,56(sp)
    800043b8:	7442                	ld	s0,48(sp)
    800043ba:	7902                	ld	s2,32(sp)
    800043bc:	69e2                	ld	s3,24(sp)
    800043be:	6a42                	ld	s4,16(sp)
    800043c0:	6121                	addi	sp,sp,64
    800043c2:	8082                	ret
    iput(ip);
    800043c4:	00000097          	auipc	ra,0x0
    800043c8:	a0c080e7          	jalr	-1524(ra) # 80003dd0 <iput>
    return -1;
    800043cc:	557d                	li	a0,-1
    800043ce:	b7e5                	j	800043b6 <dirlink+0x88>
      panic("dirlink read");
    800043d0:	00004517          	auipc	a0,0x4
    800043d4:	24850513          	addi	a0,a0,584 # 80008618 <__func__.1+0x610>
    800043d8:	ffffc097          	auipc	ra,0xffffc
    800043dc:	188080e7          	jalr	392(ra) # 80000560 <panic>

00000000800043e0 <namei>:

struct inode*
namei(char *path)
{
    800043e0:	1101                	addi	sp,sp,-32
    800043e2:	ec06                	sd	ra,24(sp)
    800043e4:	e822                	sd	s0,16(sp)
    800043e6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800043e8:	fe040613          	addi	a2,s0,-32
    800043ec:	4581                	li	a1,0
    800043ee:	00000097          	auipc	ra,0x0
    800043f2:	de0080e7          	jalr	-544(ra) # 800041ce <namex>
}
    800043f6:	60e2                	ld	ra,24(sp)
    800043f8:	6442                	ld	s0,16(sp)
    800043fa:	6105                	addi	sp,sp,32
    800043fc:	8082                	ret

00000000800043fe <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800043fe:	1141                	addi	sp,sp,-16
    80004400:	e406                	sd	ra,8(sp)
    80004402:	e022                	sd	s0,0(sp)
    80004404:	0800                	addi	s0,sp,16
    80004406:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004408:	4585                	li	a1,1
    8000440a:	00000097          	auipc	ra,0x0
    8000440e:	dc4080e7          	jalr	-572(ra) # 800041ce <namex>
}
    80004412:	60a2                	ld	ra,8(sp)
    80004414:	6402                	ld	s0,0(sp)
    80004416:	0141                	addi	sp,sp,16
    80004418:	8082                	ret

000000008000441a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000441a:	1101                	addi	sp,sp,-32
    8000441c:	ec06                	sd	ra,24(sp)
    8000441e:	e822                	sd	s0,16(sp)
    80004420:	e426                	sd	s1,8(sp)
    80004422:	e04a                	sd	s2,0(sp)
    80004424:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004426:	0001f917          	auipc	s2,0x1f
    8000442a:	2fa90913          	addi	s2,s2,762 # 80023720 <log>
    8000442e:	01892583          	lw	a1,24(s2)
    80004432:	02892503          	lw	a0,40(s2)
    80004436:	fffff097          	auipc	ra,0xfffff
    8000443a:	fa8080e7          	jalr	-88(ra) # 800033de <bread>
    8000443e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004440:	02c92603          	lw	a2,44(s2)
    80004444:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004446:	00c05f63          	blez	a2,80004464 <write_head+0x4a>
    8000444a:	0001f717          	auipc	a4,0x1f
    8000444e:	30670713          	addi	a4,a4,774 # 80023750 <log+0x30>
    80004452:	87aa                	mv	a5,a0
    80004454:	060a                	slli	a2,a2,0x2
    80004456:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004458:	4314                	lw	a3,0(a4)
    8000445a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000445c:	0711                	addi	a4,a4,4
    8000445e:	0791                	addi	a5,a5,4
    80004460:	fec79ce3          	bne	a5,a2,80004458 <write_head+0x3e>
  }
  bwrite(buf);
    80004464:	8526                	mv	a0,s1
    80004466:	fffff097          	auipc	ra,0xfffff
    8000446a:	06a080e7          	jalr	106(ra) # 800034d0 <bwrite>
  brelse(buf);
    8000446e:	8526                	mv	a0,s1
    80004470:	fffff097          	auipc	ra,0xfffff
    80004474:	09e080e7          	jalr	158(ra) # 8000350e <brelse>
}
    80004478:	60e2                	ld	ra,24(sp)
    8000447a:	6442                	ld	s0,16(sp)
    8000447c:	64a2                	ld	s1,8(sp)
    8000447e:	6902                	ld	s2,0(sp)
    80004480:	6105                	addi	sp,sp,32
    80004482:	8082                	ret

0000000080004484 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004484:	0001f797          	auipc	a5,0x1f
    80004488:	2c87a783          	lw	a5,712(a5) # 8002374c <log+0x2c>
    8000448c:	0af05d63          	blez	a5,80004546 <install_trans+0xc2>
{
    80004490:	7139                	addi	sp,sp,-64
    80004492:	fc06                	sd	ra,56(sp)
    80004494:	f822                	sd	s0,48(sp)
    80004496:	f426                	sd	s1,40(sp)
    80004498:	f04a                	sd	s2,32(sp)
    8000449a:	ec4e                	sd	s3,24(sp)
    8000449c:	e852                	sd	s4,16(sp)
    8000449e:	e456                	sd	s5,8(sp)
    800044a0:	e05a                	sd	s6,0(sp)
    800044a2:	0080                	addi	s0,sp,64
    800044a4:	8b2a                	mv	s6,a0
    800044a6:	0001fa97          	auipc	s5,0x1f
    800044aa:	2aaa8a93          	addi	s5,s5,682 # 80023750 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ae:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044b0:	0001f997          	auipc	s3,0x1f
    800044b4:	27098993          	addi	s3,s3,624 # 80023720 <log>
    800044b8:	a00d                	j	800044da <install_trans+0x56>
    brelse(lbuf);
    800044ba:	854a                	mv	a0,s2
    800044bc:	fffff097          	auipc	ra,0xfffff
    800044c0:	052080e7          	jalr	82(ra) # 8000350e <brelse>
    brelse(dbuf);
    800044c4:	8526                	mv	a0,s1
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	048080e7          	jalr	72(ra) # 8000350e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044ce:	2a05                	addiw	s4,s4,1
    800044d0:	0a91                	addi	s5,s5,4
    800044d2:	02c9a783          	lw	a5,44(s3)
    800044d6:	04fa5e63          	bge	s4,a5,80004532 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800044da:	0189a583          	lw	a1,24(s3)
    800044de:	014585bb          	addw	a1,a1,s4
    800044e2:	2585                	addiw	a1,a1,1
    800044e4:	0289a503          	lw	a0,40(s3)
    800044e8:	fffff097          	auipc	ra,0xfffff
    800044ec:	ef6080e7          	jalr	-266(ra) # 800033de <bread>
    800044f0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800044f2:	000aa583          	lw	a1,0(s5)
    800044f6:	0289a503          	lw	a0,40(s3)
    800044fa:	fffff097          	auipc	ra,0xfffff
    800044fe:	ee4080e7          	jalr	-284(ra) # 800033de <bread>
    80004502:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004504:	40000613          	li	a2,1024
    80004508:	05890593          	addi	a1,s2,88
    8000450c:	05850513          	addi	a0,a0,88
    80004510:	ffffd097          	auipc	ra,0xffffd
    80004514:	948080e7          	jalr	-1720(ra) # 80000e58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004518:	8526                	mv	a0,s1
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	fb6080e7          	jalr	-74(ra) # 800034d0 <bwrite>
    if(recovering == 0)
    80004522:	f80b1ce3          	bnez	s6,800044ba <install_trans+0x36>
      bunpin(dbuf);
    80004526:	8526                	mv	a0,s1
    80004528:	fffff097          	auipc	ra,0xfffff
    8000452c:	0be080e7          	jalr	190(ra) # 800035e6 <bunpin>
    80004530:	b769                	j	800044ba <install_trans+0x36>
}
    80004532:	70e2                	ld	ra,56(sp)
    80004534:	7442                	ld	s0,48(sp)
    80004536:	74a2                	ld	s1,40(sp)
    80004538:	7902                	ld	s2,32(sp)
    8000453a:	69e2                	ld	s3,24(sp)
    8000453c:	6a42                	ld	s4,16(sp)
    8000453e:	6aa2                	ld	s5,8(sp)
    80004540:	6b02                	ld	s6,0(sp)
    80004542:	6121                	addi	sp,sp,64
    80004544:	8082                	ret
    80004546:	8082                	ret

0000000080004548 <initlog>:
{
    80004548:	7179                	addi	sp,sp,-48
    8000454a:	f406                	sd	ra,40(sp)
    8000454c:	f022                	sd	s0,32(sp)
    8000454e:	ec26                	sd	s1,24(sp)
    80004550:	e84a                	sd	s2,16(sp)
    80004552:	e44e                	sd	s3,8(sp)
    80004554:	1800                	addi	s0,sp,48
    80004556:	892a                	mv	s2,a0
    80004558:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000455a:	0001f497          	auipc	s1,0x1f
    8000455e:	1c648493          	addi	s1,s1,454 # 80023720 <log>
    80004562:	00004597          	auipc	a1,0x4
    80004566:	0c658593          	addi	a1,a1,198 # 80008628 <__func__.1+0x620>
    8000456a:	8526                	mv	a0,s1
    8000456c:	ffffc097          	auipc	ra,0xffffc
    80004570:	704080e7          	jalr	1796(ra) # 80000c70 <initlock>
  log.start = sb->logstart;
    80004574:	0149a583          	lw	a1,20(s3)
    80004578:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000457a:	0109a783          	lw	a5,16(s3)
    8000457e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004580:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004584:	854a                	mv	a0,s2
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	e58080e7          	jalr	-424(ra) # 800033de <bread>
  log.lh.n = lh->n;
    8000458e:	4d30                	lw	a2,88(a0)
    80004590:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004592:	00c05f63          	blez	a2,800045b0 <initlog+0x68>
    80004596:	87aa                	mv	a5,a0
    80004598:	0001f717          	auipc	a4,0x1f
    8000459c:	1b870713          	addi	a4,a4,440 # 80023750 <log+0x30>
    800045a0:	060a                	slli	a2,a2,0x2
    800045a2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800045a4:	4ff4                	lw	a3,92(a5)
    800045a6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045a8:	0791                	addi	a5,a5,4
    800045aa:	0711                	addi	a4,a4,4
    800045ac:	fec79ce3          	bne	a5,a2,800045a4 <initlog+0x5c>
  brelse(buf);
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	f5e080e7          	jalr	-162(ra) # 8000350e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045b8:	4505                	li	a0,1
    800045ba:	00000097          	auipc	ra,0x0
    800045be:	eca080e7          	jalr	-310(ra) # 80004484 <install_trans>
  log.lh.n = 0;
    800045c2:	0001f797          	auipc	a5,0x1f
    800045c6:	1807a523          	sw	zero,394(a5) # 8002374c <log+0x2c>
  write_head(); // clear the log
    800045ca:	00000097          	auipc	ra,0x0
    800045ce:	e50080e7          	jalr	-432(ra) # 8000441a <write_head>
}
    800045d2:	70a2                	ld	ra,40(sp)
    800045d4:	7402                	ld	s0,32(sp)
    800045d6:	64e2                	ld	s1,24(sp)
    800045d8:	6942                	ld	s2,16(sp)
    800045da:	69a2                	ld	s3,8(sp)
    800045dc:	6145                	addi	sp,sp,48
    800045de:	8082                	ret

00000000800045e0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800045e0:	1101                	addi	sp,sp,-32
    800045e2:	ec06                	sd	ra,24(sp)
    800045e4:	e822                	sd	s0,16(sp)
    800045e6:	e426                	sd	s1,8(sp)
    800045e8:	e04a                	sd	s2,0(sp)
    800045ea:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800045ec:	0001f517          	auipc	a0,0x1f
    800045f0:	13450513          	addi	a0,a0,308 # 80023720 <log>
    800045f4:	ffffc097          	auipc	ra,0xffffc
    800045f8:	70c080e7          	jalr	1804(ra) # 80000d00 <acquire>
  while(1){
    if(log.committing){
    800045fc:	0001f497          	auipc	s1,0x1f
    80004600:	12448493          	addi	s1,s1,292 # 80023720 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004604:	4979                	li	s2,30
    80004606:	a039                	j	80004614 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004608:	85a6                	mv	a1,s1
    8000460a:	8526                	mv	a0,s1
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	dac080e7          	jalr	-596(ra) # 800023b8 <sleep>
    if(log.committing){
    80004614:	50dc                	lw	a5,36(s1)
    80004616:	fbed                	bnez	a5,80004608 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004618:	5098                	lw	a4,32(s1)
    8000461a:	2705                	addiw	a4,a4,1
    8000461c:	0027179b          	slliw	a5,a4,0x2
    80004620:	9fb9                	addw	a5,a5,a4
    80004622:	0017979b          	slliw	a5,a5,0x1
    80004626:	54d4                	lw	a3,44(s1)
    80004628:	9fb5                	addw	a5,a5,a3
    8000462a:	00f95963          	bge	s2,a5,8000463c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000462e:	85a6                	mv	a1,s1
    80004630:	8526                	mv	a0,s1
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	d86080e7          	jalr	-634(ra) # 800023b8 <sleep>
    8000463a:	bfe9                	j	80004614 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000463c:	0001f517          	auipc	a0,0x1f
    80004640:	0e450513          	addi	a0,a0,228 # 80023720 <log>
    80004644:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	76e080e7          	jalr	1902(ra) # 80000db4 <release>
      break;
    }
  }
}
    8000464e:	60e2                	ld	ra,24(sp)
    80004650:	6442                	ld	s0,16(sp)
    80004652:	64a2                	ld	s1,8(sp)
    80004654:	6902                	ld	s2,0(sp)
    80004656:	6105                	addi	sp,sp,32
    80004658:	8082                	ret

000000008000465a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000465a:	7139                	addi	sp,sp,-64
    8000465c:	fc06                	sd	ra,56(sp)
    8000465e:	f822                	sd	s0,48(sp)
    80004660:	f426                	sd	s1,40(sp)
    80004662:	f04a                	sd	s2,32(sp)
    80004664:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004666:	0001f497          	auipc	s1,0x1f
    8000466a:	0ba48493          	addi	s1,s1,186 # 80023720 <log>
    8000466e:	8526                	mv	a0,s1
    80004670:	ffffc097          	auipc	ra,0xffffc
    80004674:	690080e7          	jalr	1680(ra) # 80000d00 <acquire>
  log.outstanding -= 1;
    80004678:	509c                	lw	a5,32(s1)
    8000467a:	37fd                	addiw	a5,a5,-1
    8000467c:	0007891b          	sext.w	s2,a5
    80004680:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004682:	50dc                	lw	a5,36(s1)
    80004684:	e7b9                	bnez	a5,800046d2 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004686:	06091163          	bnez	s2,800046e8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000468a:	0001f497          	auipc	s1,0x1f
    8000468e:	09648493          	addi	s1,s1,150 # 80023720 <log>
    80004692:	4785                	li	a5,1
    80004694:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004696:	8526                	mv	a0,s1
    80004698:	ffffc097          	auipc	ra,0xffffc
    8000469c:	71c080e7          	jalr	1820(ra) # 80000db4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800046a0:	54dc                	lw	a5,44(s1)
    800046a2:	06f04763          	bgtz	a5,80004710 <end_op+0xb6>
    acquire(&log.lock);
    800046a6:	0001f497          	auipc	s1,0x1f
    800046aa:	07a48493          	addi	s1,s1,122 # 80023720 <log>
    800046ae:	8526                	mv	a0,s1
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	650080e7          	jalr	1616(ra) # 80000d00 <acquire>
    log.committing = 0;
    800046b8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046bc:	8526                	mv	a0,s1
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	d5e080e7          	jalr	-674(ra) # 8000241c <wakeup>
    release(&log.lock);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffc097          	auipc	ra,0xffffc
    800046cc:	6ec080e7          	jalr	1772(ra) # 80000db4 <release>
}
    800046d0:	a815                	j	80004704 <end_op+0xaa>
    800046d2:	ec4e                	sd	s3,24(sp)
    800046d4:	e852                	sd	s4,16(sp)
    800046d6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800046d8:	00004517          	auipc	a0,0x4
    800046dc:	f5850513          	addi	a0,a0,-168 # 80008630 <__func__.1+0x628>
    800046e0:	ffffc097          	auipc	ra,0xffffc
    800046e4:	e80080e7          	jalr	-384(ra) # 80000560 <panic>
    wakeup(&log);
    800046e8:	0001f497          	auipc	s1,0x1f
    800046ec:	03848493          	addi	s1,s1,56 # 80023720 <log>
    800046f0:	8526                	mv	a0,s1
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	d2a080e7          	jalr	-726(ra) # 8000241c <wakeup>
  release(&log.lock);
    800046fa:	8526                	mv	a0,s1
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	6b8080e7          	jalr	1720(ra) # 80000db4 <release>
}
    80004704:	70e2                	ld	ra,56(sp)
    80004706:	7442                	ld	s0,48(sp)
    80004708:	74a2                	ld	s1,40(sp)
    8000470a:	7902                	ld	s2,32(sp)
    8000470c:	6121                	addi	sp,sp,64
    8000470e:	8082                	ret
    80004710:	ec4e                	sd	s3,24(sp)
    80004712:	e852                	sd	s4,16(sp)
    80004714:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004716:	0001fa97          	auipc	s5,0x1f
    8000471a:	03aa8a93          	addi	s5,s5,58 # 80023750 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000471e:	0001fa17          	auipc	s4,0x1f
    80004722:	002a0a13          	addi	s4,s4,2 # 80023720 <log>
    80004726:	018a2583          	lw	a1,24(s4)
    8000472a:	012585bb          	addw	a1,a1,s2
    8000472e:	2585                	addiw	a1,a1,1
    80004730:	028a2503          	lw	a0,40(s4)
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	caa080e7          	jalr	-854(ra) # 800033de <bread>
    8000473c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000473e:	000aa583          	lw	a1,0(s5)
    80004742:	028a2503          	lw	a0,40(s4)
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	c98080e7          	jalr	-872(ra) # 800033de <bread>
    8000474e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004750:	40000613          	li	a2,1024
    80004754:	05850593          	addi	a1,a0,88
    80004758:	05848513          	addi	a0,s1,88
    8000475c:	ffffc097          	auipc	ra,0xffffc
    80004760:	6fc080e7          	jalr	1788(ra) # 80000e58 <memmove>
    bwrite(to);  // write the log
    80004764:	8526                	mv	a0,s1
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	d6a080e7          	jalr	-662(ra) # 800034d0 <bwrite>
    brelse(from);
    8000476e:	854e                	mv	a0,s3
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	d9e080e7          	jalr	-610(ra) # 8000350e <brelse>
    brelse(to);
    80004778:	8526                	mv	a0,s1
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	d94080e7          	jalr	-620(ra) # 8000350e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004782:	2905                	addiw	s2,s2,1
    80004784:	0a91                	addi	s5,s5,4
    80004786:	02ca2783          	lw	a5,44(s4)
    8000478a:	f8f94ee3          	blt	s2,a5,80004726 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000478e:	00000097          	auipc	ra,0x0
    80004792:	c8c080e7          	jalr	-884(ra) # 8000441a <write_head>
    install_trans(0); // Now install writes to home locations
    80004796:	4501                	li	a0,0
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	cec080e7          	jalr	-788(ra) # 80004484 <install_trans>
    log.lh.n = 0;
    800047a0:	0001f797          	auipc	a5,0x1f
    800047a4:	fa07a623          	sw	zero,-84(a5) # 8002374c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	c72080e7          	jalr	-910(ra) # 8000441a <write_head>
    800047b0:	69e2                	ld	s3,24(sp)
    800047b2:	6a42                	ld	s4,16(sp)
    800047b4:	6aa2                	ld	s5,8(sp)
    800047b6:	bdc5                	j	800046a6 <end_op+0x4c>

00000000800047b8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800047b8:	1101                	addi	sp,sp,-32
    800047ba:	ec06                	sd	ra,24(sp)
    800047bc:	e822                	sd	s0,16(sp)
    800047be:	e426                	sd	s1,8(sp)
    800047c0:	e04a                	sd	s2,0(sp)
    800047c2:	1000                	addi	s0,sp,32
    800047c4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800047c6:	0001f917          	auipc	s2,0x1f
    800047ca:	f5a90913          	addi	s2,s2,-166 # 80023720 <log>
    800047ce:	854a                	mv	a0,s2
    800047d0:	ffffc097          	auipc	ra,0xffffc
    800047d4:	530080e7          	jalr	1328(ra) # 80000d00 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800047d8:	02c92603          	lw	a2,44(s2)
    800047dc:	47f5                	li	a5,29
    800047de:	06c7c563          	blt	a5,a2,80004848 <log_write+0x90>
    800047e2:	0001f797          	auipc	a5,0x1f
    800047e6:	f5a7a783          	lw	a5,-166(a5) # 8002373c <log+0x1c>
    800047ea:	37fd                	addiw	a5,a5,-1
    800047ec:	04f65e63          	bge	a2,a5,80004848 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800047f0:	0001f797          	auipc	a5,0x1f
    800047f4:	f507a783          	lw	a5,-176(a5) # 80023740 <log+0x20>
    800047f8:	06f05063          	blez	a5,80004858 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047fc:	4781                	li	a5,0
    800047fe:	06c05563          	blez	a2,80004868 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004802:	44cc                	lw	a1,12(s1)
    80004804:	0001f717          	auipc	a4,0x1f
    80004808:	f4c70713          	addi	a4,a4,-180 # 80023750 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000480c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000480e:	4314                	lw	a3,0(a4)
    80004810:	04b68c63          	beq	a3,a1,80004868 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004814:	2785                	addiw	a5,a5,1
    80004816:	0711                	addi	a4,a4,4
    80004818:	fef61be3          	bne	a2,a5,8000480e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000481c:	0621                	addi	a2,a2,8
    8000481e:	060a                	slli	a2,a2,0x2
    80004820:	0001f797          	auipc	a5,0x1f
    80004824:	f0078793          	addi	a5,a5,-256 # 80023720 <log>
    80004828:	97b2                	add	a5,a5,a2
    8000482a:	44d8                	lw	a4,12(s1)
    8000482c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000482e:	8526                	mv	a0,s1
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	d7a080e7          	jalr	-646(ra) # 800035aa <bpin>
    log.lh.n++;
    80004838:	0001f717          	auipc	a4,0x1f
    8000483c:	ee870713          	addi	a4,a4,-280 # 80023720 <log>
    80004840:	575c                	lw	a5,44(a4)
    80004842:	2785                	addiw	a5,a5,1
    80004844:	d75c                	sw	a5,44(a4)
    80004846:	a82d                	j	80004880 <log_write+0xc8>
    panic("too big a transaction");
    80004848:	00004517          	auipc	a0,0x4
    8000484c:	df850513          	addi	a0,a0,-520 # 80008640 <__func__.1+0x638>
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	d10080e7          	jalr	-752(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004858:	00004517          	auipc	a0,0x4
    8000485c:	e0050513          	addi	a0,a0,-512 # 80008658 <__func__.1+0x650>
    80004860:	ffffc097          	auipc	ra,0xffffc
    80004864:	d00080e7          	jalr	-768(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004868:	00878693          	addi	a3,a5,8
    8000486c:	068a                	slli	a3,a3,0x2
    8000486e:	0001f717          	auipc	a4,0x1f
    80004872:	eb270713          	addi	a4,a4,-334 # 80023720 <log>
    80004876:	9736                	add	a4,a4,a3
    80004878:	44d4                	lw	a3,12(s1)
    8000487a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000487c:	faf609e3          	beq	a2,a5,8000482e <log_write+0x76>
  }
  release(&log.lock);
    80004880:	0001f517          	auipc	a0,0x1f
    80004884:	ea050513          	addi	a0,a0,-352 # 80023720 <log>
    80004888:	ffffc097          	auipc	ra,0xffffc
    8000488c:	52c080e7          	jalr	1324(ra) # 80000db4 <release>
}
    80004890:	60e2                	ld	ra,24(sp)
    80004892:	6442                	ld	s0,16(sp)
    80004894:	64a2                	ld	s1,8(sp)
    80004896:	6902                	ld	s2,0(sp)
    80004898:	6105                	addi	sp,sp,32
    8000489a:	8082                	ret

000000008000489c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000489c:	1101                	addi	sp,sp,-32
    8000489e:	ec06                	sd	ra,24(sp)
    800048a0:	e822                	sd	s0,16(sp)
    800048a2:	e426                	sd	s1,8(sp)
    800048a4:	e04a                	sd	s2,0(sp)
    800048a6:	1000                	addi	s0,sp,32
    800048a8:	84aa                	mv	s1,a0
    800048aa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048ac:	00004597          	auipc	a1,0x4
    800048b0:	dcc58593          	addi	a1,a1,-564 # 80008678 <__func__.1+0x670>
    800048b4:	0521                	addi	a0,a0,8
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	3ba080e7          	jalr	954(ra) # 80000c70 <initlock>
  lk->name = name;
    800048be:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048c2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048c6:	0204a423          	sw	zero,40(s1)
}
    800048ca:	60e2                	ld	ra,24(sp)
    800048cc:	6442                	ld	s0,16(sp)
    800048ce:	64a2                	ld	s1,8(sp)
    800048d0:	6902                	ld	s2,0(sp)
    800048d2:	6105                	addi	sp,sp,32
    800048d4:	8082                	ret

00000000800048d6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800048d6:	1101                	addi	sp,sp,-32
    800048d8:	ec06                	sd	ra,24(sp)
    800048da:	e822                	sd	s0,16(sp)
    800048dc:	e426                	sd	s1,8(sp)
    800048de:	e04a                	sd	s2,0(sp)
    800048e0:	1000                	addi	s0,sp,32
    800048e2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048e4:	00850913          	addi	s2,a0,8
    800048e8:	854a                	mv	a0,s2
    800048ea:	ffffc097          	auipc	ra,0xffffc
    800048ee:	416080e7          	jalr	1046(ra) # 80000d00 <acquire>
  while (lk->locked) {
    800048f2:	409c                	lw	a5,0(s1)
    800048f4:	cb89                	beqz	a5,80004906 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800048f6:	85ca                	mv	a1,s2
    800048f8:	8526                	mv	a0,s1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	abe080e7          	jalr	-1346(ra) # 800023b8 <sleep>
  while (lk->locked) {
    80004902:	409c                	lw	a5,0(s1)
    80004904:	fbed                	bnez	a5,800048f6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004906:	4785                	li	a5,1
    80004908:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000490a:	ffffd097          	auipc	ra,0xffffd
    8000490e:	2fc080e7          	jalr	764(ra) # 80001c06 <myproc>
    80004912:	591c                	lw	a5,48(a0)
    80004914:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004916:	854a                	mv	a0,s2
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	49c080e7          	jalr	1180(ra) # 80000db4 <release>
}
    80004920:	60e2                	ld	ra,24(sp)
    80004922:	6442                	ld	s0,16(sp)
    80004924:	64a2                	ld	s1,8(sp)
    80004926:	6902                	ld	s2,0(sp)
    80004928:	6105                	addi	sp,sp,32
    8000492a:	8082                	ret

000000008000492c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000492c:	1101                	addi	sp,sp,-32
    8000492e:	ec06                	sd	ra,24(sp)
    80004930:	e822                	sd	s0,16(sp)
    80004932:	e426                	sd	s1,8(sp)
    80004934:	e04a                	sd	s2,0(sp)
    80004936:	1000                	addi	s0,sp,32
    80004938:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000493a:	00850913          	addi	s2,a0,8
    8000493e:	854a                	mv	a0,s2
    80004940:	ffffc097          	auipc	ra,0xffffc
    80004944:	3c0080e7          	jalr	960(ra) # 80000d00 <acquire>
  lk->locked = 0;
    80004948:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000494c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	aca080e7          	jalr	-1334(ra) # 8000241c <wakeup>
  release(&lk->lk);
    8000495a:	854a                	mv	a0,s2
    8000495c:	ffffc097          	auipc	ra,0xffffc
    80004960:	458080e7          	jalr	1112(ra) # 80000db4 <release>
}
    80004964:	60e2                	ld	ra,24(sp)
    80004966:	6442                	ld	s0,16(sp)
    80004968:	64a2                	ld	s1,8(sp)
    8000496a:	6902                	ld	s2,0(sp)
    8000496c:	6105                	addi	sp,sp,32
    8000496e:	8082                	ret

0000000080004970 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004970:	7179                	addi	sp,sp,-48
    80004972:	f406                	sd	ra,40(sp)
    80004974:	f022                	sd	s0,32(sp)
    80004976:	ec26                	sd	s1,24(sp)
    80004978:	e84a                	sd	s2,16(sp)
    8000497a:	1800                	addi	s0,sp,48
    8000497c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000497e:	00850913          	addi	s2,a0,8
    80004982:	854a                	mv	a0,s2
    80004984:	ffffc097          	auipc	ra,0xffffc
    80004988:	37c080e7          	jalr	892(ra) # 80000d00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000498c:	409c                	lw	a5,0(s1)
    8000498e:	ef91                	bnez	a5,800049aa <holdingsleep+0x3a>
    80004990:	4481                	li	s1,0
  release(&lk->lk);
    80004992:	854a                	mv	a0,s2
    80004994:	ffffc097          	auipc	ra,0xffffc
    80004998:	420080e7          	jalr	1056(ra) # 80000db4 <release>
  return r;
}
    8000499c:	8526                	mv	a0,s1
    8000499e:	70a2                	ld	ra,40(sp)
    800049a0:	7402                	ld	s0,32(sp)
    800049a2:	64e2                	ld	s1,24(sp)
    800049a4:	6942                	ld	s2,16(sp)
    800049a6:	6145                	addi	sp,sp,48
    800049a8:	8082                	ret
    800049aa:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800049ac:	0284a983          	lw	s3,40(s1)
    800049b0:	ffffd097          	auipc	ra,0xffffd
    800049b4:	256080e7          	jalr	598(ra) # 80001c06 <myproc>
    800049b8:	5904                	lw	s1,48(a0)
    800049ba:	413484b3          	sub	s1,s1,s3
    800049be:	0014b493          	seqz	s1,s1
    800049c2:	69a2                	ld	s3,8(sp)
    800049c4:	b7f9                	j	80004992 <holdingsleep+0x22>

00000000800049c6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049c6:	1141                	addi	sp,sp,-16
    800049c8:	e406                	sd	ra,8(sp)
    800049ca:	e022                	sd	s0,0(sp)
    800049cc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800049ce:	00004597          	auipc	a1,0x4
    800049d2:	cba58593          	addi	a1,a1,-838 # 80008688 <__func__.1+0x680>
    800049d6:	0001f517          	auipc	a0,0x1f
    800049da:	e9250513          	addi	a0,a0,-366 # 80023868 <ftable>
    800049de:	ffffc097          	auipc	ra,0xffffc
    800049e2:	292080e7          	jalr	658(ra) # 80000c70 <initlock>
}
    800049e6:	60a2                	ld	ra,8(sp)
    800049e8:	6402                	ld	s0,0(sp)
    800049ea:	0141                	addi	sp,sp,16
    800049ec:	8082                	ret

00000000800049ee <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800049ee:	1101                	addi	sp,sp,-32
    800049f0:	ec06                	sd	ra,24(sp)
    800049f2:	e822                	sd	s0,16(sp)
    800049f4:	e426                	sd	s1,8(sp)
    800049f6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049f8:	0001f517          	auipc	a0,0x1f
    800049fc:	e7050513          	addi	a0,a0,-400 # 80023868 <ftable>
    80004a00:	ffffc097          	auipc	ra,0xffffc
    80004a04:	300080e7          	jalr	768(ra) # 80000d00 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a08:	0001f497          	auipc	s1,0x1f
    80004a0c:	e7848493          	addi	s1,s1,-392 # 80023880 <ftable+0x18>
    80004a10:	00020717          	auipc	a4,0x20
    80004a14:	e1070713          	addi	a4,a4,-496 # 80024820 <disk>
    if(f->ref == 0){
    80004a18:	40dc                	lw	a5,4(s1)
    80004a1a:	cf99                	beqz	a5,80004a38 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a1c:	02848493          	addi	s1,s1,40
    80004a20:	fee49ce3          	bne	s1,a4,80004a18 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a24:	0001f517          	auipc	a0,0x1f
    80004a28:	e4450513          	addi	a0,a0,-444 # 80023868 <ftable>
    80004a2c:	ffffc097          	auipc	ra,0xffffc
    80004a30:	388080e7          	jalr	904(ra) # 80000db4 <release>
  return 0;
    80004a34:	4481                	li	s1,0
    80004a36:	a819                	j	80004a4c <filealloc+0x5e>
      f->ref = 1;
    80004a38:	4785                	li	a5,1
    80004a3a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a3c:	0001f517          	auipc	a0,0x1f
    80004a40:	e2c50513          	addi	a0,a0,-468 # 80023868 <ftable>
    80004a44:	ffffc097          	auipc	ra,0xffffc
    80004a48:	370080e7          	jalr	880(ra) # 80000db4 <release>
}
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	60e2                	ld	ra,24(sp)
    80004a50:	6442                	ld	s0,16(sp)
    80004a52:	64a2                	ld	s1,8(sp)
    80004a54:	6105                	addi	sp,sp,32
    80004a56:	8082                	ret

0000000080004a58 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004a58:	1101                	addi	sp,sp,-32
    80004a5a:	ec06                	sd	ra,24(sp)
    80004a5c:	e822                	sd	s0,16(sp)
    80004a5e:	e426                	sd	s1,8(sp)
    80004a60:	1000                	addi	s0,sp,32
    80004a62:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a64:	0001f517          	auipc	a0,0x1f
    80004a68:	e0450513          	addi	a0,a0,-508 # 80023868 <ftable>
    80004a6c:	ffffc097          	auipc	ra,0xffffc
    80004a70:	294080e7          	jalr	660(ra) # 80000d00 <acquire>
  if(f->ref < 1)
    80004a74:	40dc                	lw	a5,4(s1)
    80004a76:	02f05263          	blez	a5,80004a9a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004a7a:	2785                	addiw	a5,a5,1
    80004a7c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a7e:	0001f517          	auipc	a0,0x1f
    80004a82:	dea50513          	addi	a0,a0,-534 # 80023868 <ftable>
    80004a86:	ffffc097          	auipc	ra,0xffffc
    80004a8a:	32e080e7          	jalr	814(ra) # 80000db4 <release>
  return f;
}
    80004a8e:	8526                	mv	a0,s1
    80004a90:	60e2                	ld	ra,24(sp)
    80004a92:	6442                	ld	s0,16(sp)
    80004a94:	64a2                	ld	s1,8(sp)
    80004a96:	6105                	addi	sp,sp,32
    80004a98:	8082                	ret
    panic("filedup");
    80004a9a:	00004517          	auipc	a0,0x4
    80004a9e:	bf650513          	addi	a0,a0,-1034 # 80008690 <__func__.1+0x688>
    80004aa2:	ffffc097          	auipc	ra,0xffffc
    80004aa6:	abe080e7          	jalr	-1346(ra) # 80000560 <panic>

0000000080004aaa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004aaa:	7139                	addi	sp,sp,-64
    80004aac:	fc06                	sd	ra,56(sp)
    80004aae:	f822                	sd	s0,48(sp)
    80004ab0:	f426                	sd	s1,40(sp)
    80004ab2:	0080                	addi	s0,sp,64
    80004ab4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004ab6:	0001f517          	auipc	a0,0x1f
    80004aba:	db250513          	addi	a0,a0,-590 # 80023868 <ftable>
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	242080e7          	jalr	578(ra) # 80000d00 <acquire>
  if(f->ref < 1)
    80004ac6:	40dc                	lw	a5,4(s1)
    80004ac8:	04f05c63          	blez	a5,80004b20 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004acc:	37fd                	addiw	a5,a5,-1
    80004ace:	0007871b          	sext.w	a4,a5
    80004ad2:	c0dc                	sw	a5,4(s1)
    80004ad4:	06e04263          	bgtz	a4,80004b38 <fileclose+0x8e>
    80004ad8:	f04a                	sd	s2,32(sp)
    80004ada:	ec4e                	sd	s3,24(sp)
    80004adc:	e852                	sd	s4,16(sp)
    80004ade:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004ae0:	0004a903          	lw	s2,0(s1)
    80004ae4:	0094ca83          	lbu	s5,9(s1)
    80004ae8:	0104ba03          	ld	s4,16(s1)
    80004aec:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004af0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004af4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004af8:	0001f517          	auipc	a0,0x1f
    80004afc:	d7050513          	addi	a0,a0,-656 # 80023868 <ftable>
    80004b00:	ffffc097          	auipc	ra,0xffffc
    80004b04:	2b4080e7          	jalr	692(ra) # 80000db4 <release>

  if(ff.type == FD_PIPE){
    80004b08:	4785                	li	a5,1
    80004b0a:	04f90463          	beq	s2,a5,80004b52 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b0e:	3979                	addiw	s2,s2,-2
    80004b10:	4785                	li	a5,1
    80004b12:	0527fb63          	bgeu	a5,s2,80004b68 <fileclose+0xbe>
    80004b16:	7902                	ld	s2,32(sp)
    80004b18:	69e2                	ld	s3,24(sp)
    80004b1a:	6a42                	ld	s4,16(sp)
    80004b1c:	6aa2                	ld	s5,8(sp)
    80004b1e:	a02d                	j	80004b48 <fileclose+0x9e>
    80004b20:	f04a                	sd	s2,32(sp)
    80004b22:	ec4e                	sd	s3,24(sp)
    80004b24:	e852                	sd	s4,16(sp)
    80004b26:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004b28:	00004517          	auipc	a0,0x4
    80004b2c:	b7050513          	addi	a0,a0,-1168 # 80008698 <__func__.1+0x690>
    80004b30:	ffffc097          	auipc	ra,0xffffc
    80004b34:	a30080e7          	jalr	-1488(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004b38:	0001f517          	auipc	a0,0x1f
    80004b3c:	d3050513          	addi	a0,a0,-720 # 80023868 <ftable>
    80004b40:	ffffc097          	auipc	ra,0xffffc
    80004b44:	274080e7          	jalr	628(ra) # 80000db4 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004b48:	70e2                	ld	ra,56(sp)
    80004b4a:	7442                	ld	s0,48(sp)
    80004b4c:	74a2                	ld	s1,40(sp)
    80004b4e:	6121                	addi	sp,sp,64
    80004b50:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b52:	85d6                	mv	a1,s5
    80004b54:	8552                	mv	a0,s4
    80004b56:	00000097          	auipc	ra,0x0
    80004b5a:	3a2080e7          	jalr	930(ra) # 80004ef8 <pipeclose>
    80004b5e:	7902                	ld	s2,32(sp)
    80004b60:	69e2                	ld	s3,24(sp)
    80004b62:	6a42                	ld	s4,16(sp)
    80004b64:	6aa2                	ld	s5,8(sp)
    80004b66:	b7cd                	j	80004b48 <fileclose+0x9e>
    begin_op();
    80004b68:	00000097          	auipc	ra,0x0
    80004b6c:	a78080e7          	jalr	-1416(ra) # 800045e0 <begin_op>
    iput(ff.ip);
    80004b70:	854e                	mv	a0,s3
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	25e080e7          	jalr	606(ra) # 80003dd0 <iput>
    end_op();
    80004b7a:	00000097          	auipc	ra,0x0
    80004b7e:	ae0080e7          	jalr	-1312(ra) # 8000465a <end_op>
    80004b82:	7902                	ld	s2,32(sp)
    80004b84:	69e2                	ld	s3,24(sp)
    80004b86:	6a42                	ld	s4,16(sp)
    80004b88:	6aa2                	ld	s5,8(sp)
    80004b8a:	bf7d                	j	80004b48 <fileclose+0x9e>

0000000080004b8c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b8c:	715d                	addi	sp,sp,-80
    80004b8e:	e486                	sd	ra,72(sp)
    80004b90:	e0a2                	sd	s0,64(sp)
    80004b92:	fc26                	sd	s1,56(sp)
    80004b94:	f44e                	sd	s3,40(sp)
    80004b96:	0880                	addi	s0,sp,80
    80004b98:	84aa                	mv	s1,a0
    80004b9a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	06a080e7          	jalr	106(ra) # 80001c06 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ba4:	409c                	lw	a5,0(s1)
    80004ba6:	37f9                	addiw	a5,a5,-2
    80004ba8:	4705                	li	a4,1
    80004baa:	04f76863          	bltu	a4,a5,80004bfa <filestat+0x6e>
    80004bae:	f84a                	sd	s2,48(sp)
    80004bb0:	892a                	mv	s2,a0
    ilock(f->ip);
    80004bb2:	6c88                	ld	a0,24(s1)
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	05e080e7          	jalr	94(ra) # 80003c12 <ilock>
    stati(f->ip, &st);
    80004bbc:	fb840593          	addi	a1,s0,-72
    80004bc0:	6c88                	ld	a0,24(s1)
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	2de080e7          	jalr	734(ra) # 80003ea0 <stati>
    iunlock(f->ip);
    80004bca:	6c88                	ld	a0,24(s1)
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	10c080e7          	jalr	268(ra) # 80003cd8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004bd4:	46e1                	li	a3,24
    80004bd6:	fb840613          	addi	a2,s0,-72
    80004bda:	85ce                	mv	a1,s3
    80004bdc:	05093503          	ld	a0,80(s2)
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	bca080e7          	jalr	-1078(ra) # 800017aa <copyout>
    80004be8:	41f5551b          	sraiw	a0,a0,0x1f
    80004bec:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004bee:	60a6                	ld	ra,72(sp)
    80004bf0:	6406                	ld	s0,64(sp)
    80004bf2:	74e2                	ld	s1,56(sp)
    80004bf4:	79a2                	ld	s3,40(sp)
    80004bf6:	6161                	addi	sp,sp,80
    80004bf8:	8082                	ret
  return -1;
    80004bfa:	557d                	li	a0,-1
    80004bfc:	bfcd                	j	80004bee <filestat+0x62>

0000000080004bfe <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004bfe:	7179                	addi	sp,sp,-48
    80004c00:	f406                	sd	ra,40(sp)
    80004c02:	f022                	sd	s0,32(sp)
    80004c04:	e84a                	sd	s2,16(sp)
    80004c06:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c08:	00854783          	lbu	a5,8(a0)
    80004c0c:	cbc5                	beqz	a5,80004cbc <fileread+0xbe>
    80004c0e:	ec26                	sd	s1,24(sp)
    80004c10:	e44e                	sd	s3,8(sp)
    80004c12:	84aa                	mv	s1,a0
    80004c14:	89ae                	mv	s3,a1
    80004c16:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c18:	411c                	lw	a5,0(a0)
    80004c1a:	4705                	li	a4,1
    80004c1c:	04e78963          	beq	a5,a4,80004c6e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c20:	470d                	li	a4,3
    80004c22:	04e78f63          	beq	a5,a4,80004c80 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c26:	4709                	li	a4,2
    80004c28:	08e79263          	bne	a5,a4,80004cac <fileread+0xae>
    ilock(f->ip);
    80004c2c:	6d08                	ld	a0,24(a0)
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	fe4080e7          	jalr	-28(ra) # 80003c12 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c36:	874a                	mv	a4,s2
    80004c38:	5094                	lw	a3,32(s1)
    80004c3a:	864e                	mv	a2,s3
    80004c3c:	4585                	li	a1,1
    80004c3e:	6c88                	ld	a0,24(s1)
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	28a080e7          	jalr	650(ra) # 80003eca <readi>
    80004c48:	892a                	mv	s2,a0
    80004c4a:	00a05563          	blez	a0,80004c54 <fileread+0x56>
      f->off += r;
    80004c4e:	509c                	lw	a5,32(s1)
    80004c50:	9fa9                	addw	a5,a5,a0
    80004c52:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c54:	6c88                	ld	a0,24(s1)
    80004c56:	fffff097          	auipc	ra,0xfffff
    80004c5a:	082080e7          	jalr	130(ra) # 80003cd8 <iunlock>
    80004c5e:	64e2                	ld	s1,24(sp)
    80004c60:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004c62:	854a                	mv	a0,s2
    80004c64:	70a2                	ld	ra,40(sp)
    80004c66:	7402                	ld	s0,32(sp)
    80004c68:	6942                	ld	s2,16(sp)
    80004c6a:	6145                	addi	sp,sp,48
    80004c6c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c6e:	6908                	ld	a0,16(a0)
    80004c70:	00000097          	auipc	ra,0x0
    80004c74:	400080e7          	jalr	1024(ra) # 80005070 <piperead>
    80004c78:	892a                	mv	s2,a0
    80004c7a:	64e2                	ld	s1,24(sp)
    80004c7c:	69a2                	ld	s3,8(sp)
    80004c7e:	b7d5                	j	80004c62 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c80:	02451783          	lh	a5,36(a0)
    80004c84:	03079693          	slli	a3,a5,0x30
    80004c88:	92c1                	srli	a3,a3,0x30
    80004c8a:	4725                	li	a4,9
    80004c8c:	02d76a63          	bltu	a4,a3,80004cc0 <fileread+0xc2>
    80004c90:	0792                	slli	a5,a5,0x4
    80004c92:	0001f717          	auipc	a4,0x1f
    80004c96:	b3670713          	addi	a4,a4,-1226 # 800237c8 <devsw>
    80004c9a:	97ba                	add	a5,a5,a4
    80004c9c:	639c                	ld	a5,0(a5)
    80004c9e:	c78d                	beqz	a5,80004cc8 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004ca0:	4505                	li	a0,1
    80004ca2:	9782                	jalr	a5
    80004ca4:	892a                	mv	s2,a0
    80004ca6:	64e2                	ld	s1,24(sp)
    80004ca8:	69a2                	ld	s3,8(sp)
    80004caa:	bf65                	j	80004c62 <fileread+0x64>
    panic("fileread");
    80004cac:	00004517          	auipc	a0,0x4
    80004cb0:	9fc50513          	addi	a0,a0,-1540 # 800086a8 <__func__.1+0x6a0>
    80004cb4:	ffffc097          	auipc	ra,0xffffc
    80004cb8:	8ac080e7          	jalr	-1876(ra) # 80000560 <panic>
    return -1;
    80004cbc:	597d                	li	s2,-1
    80004cbe:	b755                	j	80004c62 <fileread+0x64>
      return -1;
    80004cc0:	597d                	li	s2,-1
    80004cc2:	64e2                	ld	s1,24(sp)
    80004cc4:	69a2                	ld	s3,8(sp)
    80004cc6:	bf71                	j	80004c62 <fileread+0x64>
    80004cc8:	597d                	li	s2,-1
    80004cca:	64e2                	ld	s1,24(sp)
    80004ccc:	69a2                	ld	s3,8(sp)
    80004cce:	bf51                	j	80004c62 <fileread+0x64>

0000000080004cd0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004cd0:	00954783          	lbu	a5,9(a0)
    80004cd4:	12078963          	beqz	a5,80004e06 <filewrite+0x136>
{
    80004cd8:	715d                	addi	sp,sp,-80
    80004cda:	e486                	sd	ra,72(sp)
    80004cdc:	e0a2                	sd	s0,64(sp)
    80004cde:	f84a                	sd	s2,48(sp)
    80004ce0:	f052                	sd	s4,32(sp)
    80004ce2:	e85a                	sd	s6,16(sp)
    80004ce4:	0880                	addi	s0,sp,80
    80004ce6:	892a                	mv	s2,a0
    80004ce8:	8b2e                	mv	s6,a1
    80004cea:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cec:	411c                	lw	a5,0(a0)
    80004cee:	4705                	li	a4,1
    80004cf0:	02e78763          	beq	a5,a4,80004d1e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cf4:	470d                	li	a4,3
    80004cf6:	02e78a63          	beq	a5,a4,80004d2a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cfa:	4709                	li	a4,2
    80004cfc:	0ee79863          	bne	a5,a4,80004dec <filewrite+0x11c>
    80004d00:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d02:	0cc05463          	blez	a2,80004dca <filewrite+0xfa>
    80004d06:	fc26                	sd	s1,56(sp)
    80004d08:	ec56                	sd	s5,24(sp)
    80004d0a:	e45e                	sd	s7,8(sp)
    80004d0c:	e062                	sd	s8,0(sp)
    int i = 0;
    80004d0e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004d10:	6b85                	lui	s7,0x1
    80004d12:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004d16:	6c05                	lui	s8,0x1
    80004d18:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004d1c:	a851                	j	80004db0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004d1e:	6908                	ld	a0,16(a0)
    80004d20:	00000097          	auipc	ra,0x0
    80004d24:	248080e7          	jalr	584(ra) # 80004f68 <pipewrite>
    80004d28:	a85d                	j	80004dde <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d2a:	02451783          	lh	a5,36(a0)
    80004d2e:	03079693          	slli	a3,a5,0x30
    80004d32:	92c1                	srli	a3,a3,0x30
    80004d34:	4725                	li	a4,9
    80004d36:	0cd76a63          	bltu	a4,a3,80004e0a <filewrite+0x13a>
    80004d3a:	0792                	slli	a5,a5,0x4
    80004d3c:	0001f717          	auipc	a4,0x1f
    80004d40:	a8c70713          	addi	a4,a4,-1396 # 800237c8 <devsw>
    80004d44:	97ba                	add	a5,a5,a4
    80004d46:	679c                	ld	a5,8(a5)
    80004d48:	c3f9                	beqz	a5,80004e0e <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004d4a:	4505                	li	a0,1
    80004d4c:	9782                	jalr	a5
    80004d4e:	a841                	j	80004dde <filewrite+0x10e>
      if(n1 > max)
    80004d50:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004d54:	00000097          	auipc	ra,0x0
    80004d58:	88c080e7          	jalr	-1908(ra) # 800045e0 <begin_op>
      ilock(f->ip);
    80004d5c:	01893503          	ld	a0,24(s2)
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	eb2080e7          	jalr	-334(ra) # 80003c12 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d68:	8756                	mv	a4,s5
    80004d6a:	02092683          	lw	a3,32(s2)
    80004d6e:	01698633          	add	a2,s3,s6
    80004d72:	4585                	li	a1,1
    80004d74:	01893503          	ld	a0,24(s2)
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	262080e7          	jalr	610(ra) # 80003fda <writei>
    80004d80:	84aa                	mv	s1,a0
    80004d82:	00a05763          	blez	a0,80004d90 <filewrite+0xc0>
        f->off += r;
    80004d86:	02092783          	lw	a5,32(s2)
    80004d8a:	9fa9                	addw	a5,a5,a0
    80004d8c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d90:	01893503          	ld	a0,24(s2)
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	f44080e7          	jalr	-188(ra) # 80003cd8 <iunlock>
      end_op();
    80004d9c:	00000097          	auipc	ra,0x0
    80004da0:	8be080e7          	jalr	-1858(ra) # 8000465a <end_op>

      if(r != n1){
    80004da4:	029a9563          	bne	s5,s1,80004dce <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004da8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004dac:	0149da63          	bge	s3,s4,80004dc0 <filewrite+0xf0>
      int n1 = n - i;
    80004db0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004db4:	0004879b          	sext.w	a5,s1
    80004db8:	f8fbdce3          	bge	s7,a5,80004d50 <filewrite+0x80>
    80004dbc:	84e2                	mv	s1,s8
    80004dbe:	bf49                	j	80004d50 <filewrite+0x80>
    80004dc0:	74e2                	ld	s1,56(sp)
    80004dc2:	6ae2                	ld	s5,24(sp)
    80004dc4:	6ba2                	ld	s7,8(sp)
    80004dc6:	6c02                	ld	s8,0(sp)
    80004dc8:	a039                	j	80004dd6 <filewrite+0x106>
    int i = 0;
    80004dca:	4981                	li	s3,0
    80004dcc:	a029                	j	80004dd6 <filewrite+0x106>
    80004dce:	74e2                	ld	s1,56(sp)
    80004dd0:	6ae2                	ld	s5,24(sp)
    80004dd2:	6ba2                	ld	s7,8(sp)
    80004dd4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004dd6:	033a1e63          	bne	s4,s3,80004e12 <filewrite+0x142>
    80004dda:	8552                	mv	a0,s4
    80004ddc:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004dde:	60a6                	ld	ra,72(sp)
    80004de0:	6406                	ld	s0,64(sp)
    80004de2:	7942                	ld	s2,48(sp)
    80004de4:	7a02                	ld	s4,32(sp)
    80004de6:	6b42                	ld	s6,16(sp)
    80004de8:	6161                	addi	sp,sp,80
    80004dea:	8082                	ret
    80004dec:	fc26                	sd	s1,56(sp)
    80004dee:	f44e                	sd	s3,40(sp)
    80004df0:	ec56                	sd	s5,24(sp)
    80004df2:	e45e                	sd	s7,8(sp)
    80004df4:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004df6:	00004517          	auipc	a0,0x4
    80004dfa:	8c250513          	addi	a0,a0,-1854 # 800086b8 <__func__.1+0x6b0>
    80004dfe:	ffffb097          	auipc	ra,0xffffb
    80004e02:	762080e7          	jalr	1890(ra) # 80000560 <panic>
    return -1;
    80004e06:	557d                	li	a0,-1
}
    80004e08:	8082                	ret
      return -1;
    80004e0a:	557d                	li	a0,-1
    80004e0c:	bfc9                	j	80004dde <filewrite+0x10e>
    80004e0e:	557d                	li	a0,-1
    80004e10:	b7f9                	j	80004dde <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004e12:	557d                	li	a0,-1
    80004e14:	79a2                	ld	s3,40(sp)
    80004e16:	b7e1                	j	80004dde <filewrite+0x10e>

0000000080004e18 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e18:	7179                	addi	sp,sp,-48
    80004e1a:	f406                	sd	ra,40(sp)
    80004e1c:	f022                	sd	s0,32(sp)
    80004e1e:	ec26                	sd	s1,24(sp)
    80004e20:	e052                	sd	s4,0(sp)
    80004e22:	1800                	addi	s0,sp,48
    80004e24:	84aa                	mv	s1,a0
    80004e26:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e28:	0005b023          	sd	zero,0(a1)
    80004e2c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e30:	00000097          	auipc	ra,0x0
    80004e34:	bbe080e7          	jalr	-1090(ra) # 800049ee <filealloc>
    80004e38:	e088                	sd	a0,0(s1)
    80004e3a:	cd49                	beqz	a0,80004ed4 <pipealloc+0xbc>
    80004e3c:	00000097          	auipc	ra,0x0
    80004e40:	bb2080e7          	jalr	-1102(ra) # 800049ee <filealloc>
    80004e44:	00aa3023          	sd	a0,0(s4)
    80004e48:	c141                	beqz	a0,80004ec8 <pipealloc+0xb0>
    80004e4a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e4c:	ffffc097          	auipc	ra,0xffffc
    80004e50:	d78080e7          	jalr	-648(ra) # 80000bc4 <kalloc>
    80004e54:	892a                	mv	s2,a0
    80004e56:	c13d                	beqz	a0,80004ebc <pipealloc+0xa4>
    80004e58:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004e5a:	4985                	li	s3,1
    80004e5c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e60:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e64:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e68:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e6c:	00004597          	auipc	a1,0x4
    80004e70:	85c58593          	addi	a1,a1,-1956 # 800086c8 <__func__.1+0x6c0>
    80004e74:	ffffc097          	auipc	ra,0xffffc
    80004e78:	dfc080e7          	jalr	-516(ra) # 80000c70 <initlock>
  (*f0)->type = FD_PIPE;
    80004e7c:	609c                	ld	a5,0(s1)
    80004e7e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e82:	609c                	ld	a5,0(s1)
    80004e84:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e88:	609c                	ld	a5,0(s1)
    80004e8a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e8e:	609c                	ld	a5,0(s1)
    80004e90:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e94:	000a3783          	ld	a5,0(s4)
    80004e98:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e9c:	000a3783          	ld	a5,0(s4)
    80004ea0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ea4:	000a3783          	ld	a5,0(s4)
    80004ea8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004eac:	000a3783          	ld	a5,0(s4)
    80004eb0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004eb4:	4501                	li	a0,0
    80004eb6:	6942                	ld	s2,16(sp)
    80004eb8:	69a2                	ld	s3,8(sp)
    80004eba:	a03d                	j	80004ee8 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ebc:	6088                	ld	a0,0(s1)
    80004ebe:	c119                	beqz	a0,80004ec4 <pipealloc+0xac>
    80004ec0:	6942                	ld	s2,16(sp)
    80004ec2:	a029                	j	80004ecc <pipealloc+0xb4>
    80004ec4:	6942                	ld	s2,16(sp)
    80004ec6:	a039                	j	80004ed4 <pipealloc+0xbc>
    80004ec8:	6088                	ld	a0,0(s1)
    80004eca:	c50d                	beqz	a0,80004ef4 <pipealloc+0xdc>
    fileclose(*f0);
    80004ecc:	00000097          	auipc	ra,0x0
    80004ed0:	bde080e7          	jalr	-1058(ra) # 80004aaa <fileclose>
  if(*f1)
    80004ed4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ed8:	557d                	li	a0,-1
  if(*f1)
    80004eda:	c799                	beqz	a5,80004ee8 <pipealloc+0xd0>
    fileclose(*f1);
    80004edc:	853e                	mv	a0,a5
    80004ede:	00000097          	auipc	ra,0x0
    80004ee2:	bcc080e7          	jalr	-1076(ra) # 80004aaa <fileclose>
  return -1;
    80004ee6:	557d                	li	a0,-1
}
    80004ee8:	70a2                	ld	ra,40(sp)
    80004eea:	7402                	ld	s0,32(sp)
    80004eec:	64e2                	ld	s1,24(sp)
    80004eee:	6a02                	ld	s4,0(sp)
    80004ef0:	6145                	addi	sp,sp,48
    80004ef2:	8082                	ret
  return -1;
    80004ef4:	557d                	li	a0,-1
    80004ef6:	bfcd                	j	80004ee8 <pipealloc+0xd0>

0000000080004ef8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ef8:	1101                	addi	sp,sp,-32
    80004efa:	ec06                	sd	ra,24(sp)
    80004efc:	e822                	sd	s0,16(sp)
    80004efe:	e426                	sd	s1,8(sp)
    80004f00:	e04a                	sd	s2,0(sp)
    80004f02:	1000                	addi	s0,sp,32
    80004f04:	84aa                	mv	s1,a0
    80004f06:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	df8080e7          	jalr	-520(ra) # 80000d00 <acquire>
  if(writable){
    80004f10:	02090d63          	beqz	s2,80004f4a <pipeclose+0x52>
    pi->writeopen = 0;
    80004f14:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f18:	21848513          	addi	a0,s1,536
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	500080e7          	jalr	1280(ra) # 8000241c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f24:	2204b783          	ld	a5,544(s1)
    80004f28:	eb95                	bnez	a5,80004f5c <pipeclose+0x64>
    release(&pi->lock);
    80004f2a:	8526                	mv	a0,s1
    80004f2c:	ffffc097          	auipc	ra,0xffffc
    80004f30:	e88080e7          	jalr	-376(ra) # 80000db4 <release>
    kfree((char*)pi);
    80004f34:	8526                	mv	a0,s1
    80004f36:	ffffc097          	auipc	ra,0xffffc
    80004f3a:	b26080e7          	jalr	-1242(ra) # 80000a5c <kfree>
  } else
    release(&pi->lock);
}
    80004f3e:	60e2                	ld	ra,24(sp)
    80004f40:	6442                	ld	s0,16(sp)
    80004f42:	64a2                	ld	s1,8(sp)
    80004f44:	6902                	ld	s2,0(sp)
    80004f46:	6105                	addi	sp,sp,32
    80004f48:	8082                	ret
    pi->readopen = 0;
    80004f4a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f4e:	21c48513          	addi	a0,s1,540
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	4ca080e7          	jalr	1226(ra) # 8000241c <wakeup>
    80004f5a:	b7e9                	j	80004f24 <pipeclose+0x2c>
    release(&pi->lock);
    80004f5c:	8526                	mv	a0,s1
    80004f5e:	ffffc097          	auipc	ra,0xffffc
    80004f62:	e56080e7          	jalr	-426(ra) # 80000db4 <release>
}
    80004f66:	bfe1                	j	80004f3e <pipeclose+0x46>

0000000080004f68 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f68:	711d                	addi	sp,sp,-96
    80004f6a:	ec86                	sd	ra,88(sp)
    80004f6c:	e8a2                	sd	s0,80(sp)
    80004f6e:	e4a6                	sd	s1,72(sp)
    80004f70:	e0ca                	sd	s2,64(sp)
    80004f72:	fc4e                	sd	s3,56(sp)
    80004f74:	f852                	sd	s4,48(sp)
    80004f76:	f456                	sd	s5,40(sp)
    80004f78:	1080                	addi	s0,sp,96
    80004f7a:	84aa                	mv	s1,a0
    80004f7c:	8aae                	mv	s5,a1
    80004f7e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f80:	ffffd097          	auipc	ra,0xffffd
    80004f84:	c86080e7          	jalr	-890(ra) # 80001c06 <myproc>
    80004f88:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f8a:	8526                	mv	a0,s1
    80004f8c:	ffffc097          	auipc	ra,0xffffc
    80004f90:	d74080e7          	jalr	-652(ra) # 80000d00 <acquire>
  while(i < n){
    80004f94:	0d405863          	blez	s4,80005064 <pipewrite+0xfc>
    80004f98:	f05a                	sd	s6,32(sp)
    80004f9a:	ec5e                	sd	s7,24(sp)
    80004f9c:	e862                	sd	s8,16(sp)
  int i = 0;
    80004f9e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004fa0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004fa2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004fa6:	21c48b93          	addi	s7,s1,540
    80004faa:	a089                	j	80004fec <pipewrite+0x84>
      release(&pi->lock);
    80004fac:	8526                	mv	a0,s1
    80004fae:	ffffc097          	auipc	ra,0xffffc
    80004fb2:	e06080e7          	jalr	-506(ra) # 80000db4 <release>
      return -1;
    80004fb6:	597d                	li	s2,-1
    80004fb8:	7b02                	ld	s6,32(sp)
    80004fba:	6be2                	ld	s7,24(sp)
    80004fbc:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004fbe:	854a                	mv	a0,s2
    80004fc0:	60e6                	ld	ra,88(sp)
    80004fc2:	6446                	ld	s0,80(sp)
    80004fc4:	64a6                	ld	s1,72(sp)
    80004fc6:	6906                	ld	s2,64(sp)
    80004fc8:	79e2                	ld	s3,56(sp)
    80004fca:	7a42                	ld	s4,48(sp)
    80004fcc:	7aa2                	ld	s5,40(sp)
    80004fce:	6125                	addi	sp,sp,96
    80004fd0:	8082                	ret
      wakeup(&pi->nread);
    80004fd2:	8562                	mv	a0,s8
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	448080e7          	jalr	1096(ra) # 8000241c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004fdc:	85a6                	mv	a1,s1
    80004fde:	855e                	mv	a0,s7
    80004fe0:	ffffd097          	auipc	ra,0xffffd
    80004fe4:	3d8080e7          	jalr	984(ra) # 800023b8 <sleep>
  while(i < n){
    80004fe8:	05495f63          	bge	s2,s4,80005046 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004fec:	2204a783          	lw	a5,544(s1)
    80004ff0:	dfd5                	beqz	a5,80004fac <pipewrite+0x44>
    80004ff2:	854e                	mv	a0,s3
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	66c080e7          	jalr	1644(ra) # 80002660 <killed>
    80004ffc:	f945                	bnez	a0,80004fac <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ffe:	2184a783          	lw	a5,536(s1)
    80005002:	21c4a703          	lw	a4,540(s1)
    80005006:	2007879b          	addiw	a5,a5,512
    8000500a:	fcf704e3          	beq	a4,a5,80004fd2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000500e:	4685                	li	a3,1
    80005010:	01590633          	add	a2,s2,s5
    80005014:	faf40593          	addi	a1,s0,-81
    80005018:	0509b503          	ld	a0,80(s3)
    8000501c:	ffffd097          	auipc	ra,0xffffd
    80005020:	81a080e7          	jalr	-2022(ra) # 80001836 <copyin>
    80005024:	05650263          	beq	a0,s6,80005068 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005028:	21c4a783          	lw	a5,540(s1)
    8000502c:	0017871b          	addiw	a4,a5,1
    80005030:	20e4ae23          	sw	a4,540(s1)
    80005034:	1ff7f793          	andi	a5,a5,511
    80005038:	97a6                	add	a5,a5,s1
    8000503a:	faf44703          	lbu	a4,-81(s0)
    8000503e:	00e78c23          	sb	a4,24(a5)
      i++;
    80005042:	2905                	addiw	s2,s2,1
    80005044:	b755                	j	80004fe8 <pipewrite+0x80>
    80005046:	7b02                	ld	s6,32(sp)
    80005048:	6be2                	ld	s7,24(sp)
    8000504a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000504c:	21848513          	addi	a0,s1,536
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	3cc080e7          	jalr	972(ra) # 8000241c <wakeup>
  release(&pi->lock);
    80005058:	8526                	mv	a0,s1
    8000505a:	ffffc097          	auipc	ra,0xffffc
    8000505e:	d5a080e7          	jalr	-678(ra) # 80000db4 <release>
  return i;
    80005062:	bfb1                	j	80004fbe <pipewrite+0x56>
  int i = 0;
    80005064:	4901                	li	s2,0
    80005066:	b7dd                	j	8000504c <pipewrite+0xe4>
    80005068:	7b02                	ld	s6,32(sp)
    8000506a:	6be2                	ld	s7,24(sp)
    8000506c:	6c42                	ld	s8,16(sp)
    8000506e:	bff9                	j	8000504c <pipewrite+0xe4>

0000000080005070 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005070:	715d                	addi	sp,sp,-80
    80005072:	e486                	sd	ra,72(sp)
    80005074:	e0a2                	sd	s0,64(sp)
    80005076:	fc26                	sd	s1,56(sp)
    80005078:	f84a                	sd	s2,48(sp)
    8000507a:	f44e                	sd	s3,40(sp)
    8000507c:	f052                	sd	s4,32(sp)
    8000507e:	ec56                	sd	s5,24(sp)
    80005080:	0880                	addi	s0,sp,80
    80005082:	84aa                	mv	s1,a0
    80005084:	892e                	mv	s2,a1
    80005086:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005088:	ffffd097          	auipc	ra,0xffffd
    8000508c:	b7e080e7          	jalr	-1154(ra) # 80001c06 <myproc>
    80005090:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005092:	8526                	mv	a0,s1
    80005094:	ffffc097          	auipc	ra,0xffffc
    80005098:	c6c080e7          	jalr	-916(ra) # 80000d00 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000509c:	2184a703          	lw	a4,536(s1)
    800050a0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050a4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050a8:	02f71963          	bne	a4,a5,800050da <piperead+0x6a>
    800050ac:	2244a783          	lw	a5,548(s1)
    800050b0:	cf95                	beqz	a5,800050ec <piperead+0x7c>
    if(killed(pr)){
    800050b2:	8552                	mv	a0,s4
    800050b4:	ffffd097          	auipc	ra,0xffffd
    800050b8:	5ac080e7          	jalr	1452(ra) # 80002660 <killed>
    800050bc:	e10d                	bnez	a0,800050de <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050be:	85a6                	mv	a1,s1
    800050c0:	854e                	mv	a0,s3
    800050c2:	ffffd097          	auipc	ra,0xffffd
    800050c6:	2f6080e7          	jalr	758(ra) # 800023b8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050ca:	2184a703          	lw	a4,536(s1)
    800050ce:	21c4a783          	lw	a5,540(s1)
    800050d2:	fcf70de3          	beq	a4,a5,800050ac <piperead+0x3c>
    800050d6:	e85a                	sd	s6,16(sp)
    800050d8:	a819                	j	800050ee <piperead+0x7e>
    800050da:	e85a                	sd	s6,16(sp)
    800050dc:	a809                	j	800050ee <piperead+0x7e>
      release(&pi->lock);
    800050de:	8526                	mv	a0,s1
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	cd4080e7          	jalr	-812(ra) # 80000db4 <release>
      return -1;
    800050e8:	59fd                	li	s3,-1
    800050ea:	a0a5                	j	80005152 <piperead+0xe2>
    800050ec:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050ee:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050f0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050f2:	05505463          	blez	s5,8000513a <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800050f6:	2184a783          	lw	a5,536(s1)
    800050fa:	21c4a703          	lw	a4,540(s1)
    800050fe:	02f70e63          	beq	a4,a5,8000513a <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005102:	0017871b          	addiw	a4,a5,1
    80005106:	20e4ac23          	sw	a4,536(s1)
    8000510a:	1ff7f793          	andi	a5,a5,511
    8000510e:	97a6                	add	a5,a5,s1
    80005110:	0187c783          	lbu	a5,24(a5)
    80005114:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005118:	4685                	li	a3,1
    8000511a:	fbf40613          	addi	a2,s0,-65
    8000511e:	85ca                	mv	a1,s2
    80005120:	050a3503          	ld	a0,80(s4)
    80005124:	ffffc097          	auipc	ra,0xffffc
    80005128:	686080e7          	jalr	1670(ra) # 800017aa <copyout>
    8000512c:	01650763          	beq	a0,s6,8000513a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005130:	2985                	addiw	s3,s3,1
    80005132:	0905                	addi	s2,s2,1
    80005134:	fd3a91e3          	bne	s5,s3,800050f6 <piperead+0x86>
    80005138:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000513a:	21c48513          	addi	a0,s1,540
    8000513e:	ffffd097          	auipc	ra,0xffffd
    80005142:	2de080e7          	jalr	734(ra) # 8000241c <wakeup>
  release(&pi->lock);
    80005146:	8526                	mv	a0,s1
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	c6c080e7          	jalr	-916(ra) # 80000db4 <release>
    80005150:	6b42                	ld	s6,16(sp)
  return i;
}
    80005152:	854e                	mv	a0,s3
    80005154:	60a6                	ld	ra,72(sp)
    80005156:	6406                	ld	s0,64(sp)
    80005158:	74e2                	ld	s1,56(sp)
    8000515a:	7942                	ld	s2,48(sp)
    8000515c:	79a2                	ld	s3,40(sp)
    8000515e:	7a02                	ld	s4,32(sp)
    80005160:	6ae2                	ld	s5,24(sp)
    80005162:	6161                	addi	sp,sp,80
    80005164:	8082                	ret

0000000080005166 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005166:	1141                	addi	sp,sp,-16
    80005168:	e422                	sd	s0,8(sp)
    8000516a:	0800                	addi	s0,sp,16
    8000516c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000516e:	8905                	andi	a0,a0,1
    80005170:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005172:	8b89                	andi	a5,a5,2
    80005174:	c399                	beqz	a5,8000517a <flags2perm+0x14>
      perm |= PTE_W;
    80005176:	00456513          	ori	a0,a0,4
    return perm;
}
    8000517a:	6422                	ld	s0,8(sp)
    8000517c:	0141                	addi	sp,sp,16
    8000517e:	8082                	ret

0000000080005180 <exec>:

int
exec(char *path, char **argv)
{
    80005180:	df010113          	addi	sp,sp,-528
    80005184:	20113423          	sd	ra,520(sp)
    80005188:	20813023          	sd	s0,512(sp)
    8000518c:	ffa6                	sd	s1,504(sp)
    8000518e:	fbca                	sd	s2,496(sp)
    80005190:	0c00                	addi	s0,sp,528
    80005192:	892a                	mv	s2,a0
    80005194:	dea43c23          	sd	a0,-520(s0)
    80005198:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000519c:	ffffd097          	auipc	ra,0xffffd
    800051a0:	a6a080e7          	jalr	-1430(ra) # 80001c06 <myproc>
    800051a4:	84aa                	mv	s1,a0

  begin_op();
    800051a6:	fffff097          	auipc	ra,0xfffff
    800051aa:	43a080e7          	jalr	1082(ra) # 800045e0 <begin_op>

  if((ip = namei(path)) == 0){
    800051ae:	854a                	mv	a0,s2
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	230080e7          	jalr	560(ra) # 800043e0 <namei>
    800051b8:	c135                	beqz	a0,8000521c <exec+0x9c>
    800051ba:	f3d2                	sd	s4,480(sp)
    800051bc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800051be:	fffff097          	auipc	ra,0xfffff
    800051c2:	a54080e7          	jalr	-1452(ra) # 80003c12 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800051c6:	04000713          	li	a4,64
    800051ca:	4681                	li	a3,0
    800051cc:	e5040613          	addi	a2,s0,-432
    800051d0:	4581                	li	a1,0
    800051d2:	8552                	mv	a0,s4
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	cf6080e7          	jalr	-778(ra) # 80003eca <readi>
    800051dc:	04000793          	li	a5,64
    800051e0:	00f51a63          	bne	a0,a5,800051f4 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800051e4:	e5042703          	lw	a4,-432(s0)
    800051e8:	464c47b7          	lui	a5,0x464c4
    800051ec:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800051f0:	02f70c63          	beq	a4,a5,80005228 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800051f4:	8552                	mv	a0,s4
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	c82080e7          	jalr	-894(ra) # 80003e78 <iunlockput>
    end_op();
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	45c080e7          	jalr	1116(ra) # 8000465a <end_op>
  }
  return -1;
    80005206:	557d                	li	a0,-1
    80005208:	7a1e                	ld	s4,480(sp)
}
    8000520a:	20813083          	ld	ra,520(sp)
    8000520e:	20013403          	ld	s0,512(sp)
    80005212:	74fe                	ld	s1,504(sp)
    80005214:	795e                	ld	s2,496(sp)
    80005216:	21010113          	addi	sp,sp,528
    8000521a:	8082                	ret
    end_op();
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	43e080e7          	jalr	1086(ra) # 8000465a <end_op>
    return -1;
    80005224:	557d                	li	a0,-1
    80005226:	b7d5                	j	8000520a <exec+0x8a>
    80005228:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000522a:	8526                	mv	a0,s1
    8000522c:	ffffd097          	auipc	ra,0xffffd
    80005230:	a9e080e7          	jalr	-1378(ra) # 80001cca <proc_pagetable>
    80005234:	8b2a                	mv	s6,a0
    80005236:	30050f63          	beqz	a0,80005554 <exec+0x3d4>
    8000523a:	f7ce                	sd	s3,488(sp)
    8000523c:	efd6                	sd	s5,472(sp)
    8000523e:	e7de                	sd	s7,456(sp)
    80005240:	e3e2                	sd	s8,448(sp)
    80005242:	ff66                	sd	s9,440(sp)
    80005244:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005246:	e7042d03          	lw	s10,-400(s0)
    8000524a:	e8845783          	lhu	a5,-376(s0)
    8000524e:	14078d63          	beqz	a5,800053a8 <exec+0x228>
    80005252:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005254:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005256:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80005258:	6c85                	lui	s9,0x1
    8000525a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000525e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005262:	6a85                	lui	s5,0x1
    80005264:	a0b5                	j	800052d0 <exec+0x150>
      panic("loadseg: address should exist");
    80005266:	00003517          	auipc	a0,0x3
    8000526a:	46a50513          	addi	a0,a0,1130 # 800086d0 <__func__.1+0x6c8>
    8000526e:	ffffb097          	auipc	ra,0xffffb
    80005272:	2f2080e7          	jalr	754(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    80005276:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005278:	8726                	mv	a4,s1
    8000527a:	012c06bb          	addw	a3,s8,s2
    8000527e:	4581                	li	a1,0
    80005280:	8552                	mv	a0,s4
    80005282:	fffff097          	auipc	ra,0xfffff
    80005286:	c48080e7          	jalr	-952(ra) # 80003eca <readi>
    8000528a:	2501                	sext.w	a0,a0
    8000528c:	28a49863          	bne	s1,a0,8000551c <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80005290:	012a893b          	addw	s2,s5,s2
    80005294:	03397563          	bgeu	s2,s3,800052be <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80005298:	02091593          	slli	a1,s2,0x20
    8000529c:	9181                	srli	a1,a1,0x20
    8000529e:	95de                	add	a1,a1,s7
    800052a0:	855a                	mv	a0,s6
    800052a2:	ffffc097          	auipc	ra,0xffffc
    800052a6:	edc080e7          	jalr	-292(ra) # 8000117e <walkaddr>
    800052aa:	862a                	mv	a2,a0
    if(pa == 0)
    800052ac:	dd4d                	beqz	a0,80005266 <exec+0xe6>
    if(sz - i < PGSIZE)
    800052ae:	412984bb          	subw	s1,s3,s2
    800052b2:	0004879b          	sext.w	a5,s1
    800052b6:	fcfcf0e3          	bgeu	s9,a5,80005276 <exec+0xf6>
    800052ba:	84d6                	mv	s1,s5
    800052bc:	bf6d                	j	80005276 <exec+0xf6>
    sz = sz1;
    800052be:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052c2:	2d85                	addiw	s11,s11,1
    800052c4:	038d0d1b          	addiw	s10,s10,56
    800052c8:	e8845783          	lhu	a5,-376(s0)
    800052cc:	08fdd663          	bge	s11,a5,80005358 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800052d0:	2d01                	sext.w	s10,s10
    800052d2:	03800713          	li	a4,56
    800052d6:	86ea                	mv	a3,s10
    800052d8:	e1840613          	addi	a2,s0,-488
    800052dc:	4581                	li	a1,0
    800052de:	8552                	mv	a0,s4
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	bea080e7          	jalr	-1046(ra) # 80003eca <readi>
    800052e8:	03800793          	li	a5,56
    800052ec:	20f51063          	bne	a0,a5,800054ec <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800052f0:	e1842783          	lw	a5,-488(s0)
    800052f4:	4705                	li	a4,1
    800052f6:	fce796e3          	bne	a5,a4,800052c2 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800052fa:	e4043483          	ld	s1,-448(s0)
    800052fe:	e3843783          	ld	a5,-456(s0)
    80005302:	1ef4e963          	bltu	s1,a5,800054f4 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005306:	e2843783          	ld	a5,-472(s0)
    8000530a:	94be                	add	s1,s1,a5
    8000530c:	1ef4e863          	bltu	s1,a5,800054fc <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005310:	df043703          	ld	a4,-528(s0)
    80005314:	8ff9                	and	a5,a5,a4
    80005316:	1e079763          	bnez	a5,80005504 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000531a:	e1c42503          	lw	a0,-484(s0)
    8000531e:	00000097          	auipc	ra,0x0
    80005322:	e48080e7          	jalr	-440(ra) # 80005166 <flags2perm>
    80005326:	86aa                	mv	a3,a0
    80005328:	8626                	mv	a2,s1
    8000532a:	85ca                	mv	a1,s2
    8000532c:	855a                	mv	a0,s6
    8000532e:	ffffc097          	auipc	ra,0xffffc
    80005332:	214080e7          	jalr	532(ra) # 80001542 <uvmalloc>
    80005336:	e0a43423          	sd	a0,-504(s0)
    8000533a:	1c050963          	beqz	a0,8000550c <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000533e:	e2843b83          	ld	s7,-472(s0)
    80005342:	e2042c03          	lw	s8,-480(s0)
    80005346:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000534a:	00098463          	beqz	s3,80005352 <exec+0x1d2>
    8000534e:	4901                	li	s2,0
    80005350:	b7a1                	j	80005298 <exec+0x118>
    sz = sz1;
    80005352:	e0843903          	ld	s2,-504(s0)
    80005356:	b7b5                	j	800052c2 <exec+0x142>
    80005358:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000535a:	8552                	mv	a0,s4
    8000535c:	fffff097          	auipc	ra,0xfffff
    80005360:	b1c080e7          	jalr	-1252(ra) # 80003e78 <iunlockput>
  end_op();
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	2f6080e7          	jalr	758(ra) # 8000465a <end_op>
  p = myproc();
    8000536c:	ffffd097          	auipc	ra,0xffffd
    80005370:	89a080e7          	jalr	-1894(ra) # 80001c06 <myproc>
    80005374:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005376:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000537a:	6985                	lui	s3,0x1
    8000537c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000537e:	99ca                	add	s3,s3,s2
    80005380:	77fd                	lui	a5,0xfffff
    80005382:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005386:	4691                	li	a3,4
    80005388:	6609                	lui	a2,0x2
    8000538a:	964e                	add	a2,a2,s3
    8000538c:	85ce                	mv	a1,s3
    8000538e:	855a                	mv	a0,s6
    80005390:	ffffc097          	auipc	ra,0xffffc
    80005394:	1b2080e7          	jalr	434(ra) # 80001542 <uvmalloc>
    80005398:	892a                	mv	s2,a0
    8000539a:	e0a43423          	sd	a0,-504(s0)
    8000539e:	e519                	bnez	a0,800053ac <exec+0x22c>
  if(pagetable)
    800053a0:	e1343423          	sd	s3,-504(s0)
    800053a4:	4a01                	li	s4,0
    800053a6:	aaa5                	j	8000551e <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800053a8:	4901                	li	s2,0
    800053aa:	bf45                	j	8000535a <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800053ac:	75f9                	lui	a1,0xffffe
    800053ae:	95aa                	add	a1,a1,a0
    800053b0:	855a                	mv	a0,s6
    800053b2:	ffffc097          	auipc	ra,0xffffc
    800053b6:	3c6080e7          	jalr	966(ra) # 80001778 <uvmclear>
  stackbase = sp - PGSIZE;
    800053ba:	7bfd                	lui	s7,0xfffff
    800053bc:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800053be:	e0043783          	ld	a5,-512(s0)
    800053c2:	6388                	ld	a0,0(a5)
    800053c4:	c52d                	beqz	a0,8000542e <exec+0x2ae>
    800053c6:	e9040993          	addi	s3,s0,-368
    800053ca:	f9040c13          	addi	s8,s0,-112
    800053ce:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	ba0080e7          	jalr	-1120(ra) # 80000f70 <strlen>
    800053d8:	0015079b          	addiw	a5,a0,1
    800053dc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800053e0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800053e4:	13796863          	bltu	s2,s7,80005514 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800053e8:	e0043d03          	ld	s10,-512(s0)
    800053ec:	000d3a03          	ld	s4,0(s10)
    800053f0:	8552                	mv	a0,s4
    800053f2:	ffffc097          	auipc	ra,0xffffc
    800053f6:	b7e080e7          	jalr	-1154(ra) # 80000f70 <strlen>
    800053fa:	0015069b          	addiw	a3,a0,1
    800053fe:	8652                	mv	a2,s4
    80005400:	85ca                	mv	a1,s2
    80005402:	855a                	mv	a0,s6
    80005404:	ffffc097          	auipc	ra,0xffffc
    80005408:	3a6080e7          	jalr	934(ra) # 800017aa <copyout>
    8000540c:	10054663          	bltz	a0,80005518 <exec+0x398>
    ustack[argc] = sp;
    80005410:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005414:	0485                	addi	s1,s1,1
    80005416:	008d0793          	addi	a5,s10,8
    8000541a:	e0f43023          	sd	a5,-512(s0)
    8000541e:	008d3503          	ld	a0,8(s10)
    80005422:	c909                	beqz	a0,80005434 <exec+0x2b4>
    if(argc >= MAXARG)
    80005424:	09a1                	addi	s3,s3,8
    80005426:	fb8995e3          	bne	s3,s8,800053d0 <exec+0x250>
  ip = 0;
    8000542a:	4a01                	li	s4,0
    8000542c:	a8cd                	j	8000551e <exec+0x39e>
  sp = sz;
    8000542e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005432:	4481                	li	s1,0
  ustack[argc] = 0;
    80005434:	00349793          	slli	a5,s1,0x3
    80005438:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda630>
    8000543c:	97a2                	add	a5,a5,s0
    8000543e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005442:	00148693          	addi	a3,s1,1
    80005446:	068e                	slli	a3,a3,0x3
    80005448:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000544c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005450:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005454:	f57966e3          	bltu	s2,s7,800053a0 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005458:	e9040613          	addi	a2,s0,-368
    8000545c:	85ca                	mv	a1,s2
    8000545e:	855a                	mv	a0,s6
    80005460:	ffffc097          	auipc	ra,0xffffc
    80005464:	34a080e7          	jalr	842(ra) # 800017aa <copyout>
    80005468:	0e054863          	bltz	a0,80005558 <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000546c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005470:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005474:	df843783          	ld	a5,-520(s0)
    80005478:	0007c703          	lbu	a4,0(a5)
    8000547c:	cf11                	beqz	a4,80005498 <exec+0x318>
    8000547e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005480:	02f00693          	li	a3,47
    80005484:	a039                	j	80005492 <exec+0x312>
      last = s+1;
    80005486:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000548a:	0785                	addi	a5,a5,1
    8000548c:	fff7c703          	lbu	a4,-1(a5)
    80005490:	c701                	beqz	a4,80005498 <exec+0x318>
    if(*s == '/')
    80005492:	fed71ce3          	bne	a4,a3,8000548a <exec+0x30a>
    80005496:	bfc5                	j	80005486 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80005498:	4641                	li	a2,16
    8000549a:	df843583          	ld	a1,-520(s0)
    8000549e:	158a8513          	addi	a0,s5,344
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	a9c080e7          	jalr	-1380(ra) # 80000f3e <safestrcpy>
  oldpagetable = p->pagetable;
    800054aa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800054ae:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800054b2:	e0843783          	ld	a5,-504(s0)
    800054b6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800054ba:	058ab783          	ld	a5,88(s5)
    800054be:	e6843703          	ld	a4,-408(s0)
    800054c2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800054c4:	058ab783          	ld	a5,88(s5)
    800054c8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800054cc:	85e6                	mv	a1,s9
    800054ce:	ffffd097          	auipc	ra,0xffffd
    800054d2:	898080e7          	jalr	-1896(ra) # 80001d66 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800054d6:	0004851b          	sext.w	a0,s1
    800054da:	79be                	ld	s3,488(sp)
    800054dc:	7a1e                	ld	s4,480(sp)
    800054de:	6afe                	ld	s5,472(sp)
    800054e0:	6b5e                	ld	s6,464(sp)
    800054e2:	6bbe                	ld	s7,456(sp)
    800054e4:	6c1e                	ld	s8,448(sp)
    800054e6:	7cfa                	ld	s9,440(sp)
    800054e8:	7d5a                	ld	s10,432(sp)
    800054ea:	b305                	j	8000520a <exec+0x8a>
    800054ec:	e1243423          	sd	s2,-504(s0)
    800054f0:	7dba                	ld	s11,424(sp)
    800054f2:	a035                	j	8000551e <exec+0x39e>
    800054f4:	e1243423          	sd	s2,-504(s0)
    800054f8:	7dba                	ld	s11,424(sp)
    800054fa:	a015                	j	8000551e <exec+0x39e>
    800054fc:	e1243423          	sd	s2,-504(s0)
    80005500:	7dba                	ld	s11,424(sp)
    80005502:	a831                	j	8000551e <exec+0x39e>
    80005504:	e1243423          	sd	s2,-504(s0)
    80005508:	7dba                	ld	s11,424(sp)
    8000550a:	a811                	j	8000551e <exec+0x39e>
    8000550c:	e1243423          	sd	s2,-504(s0)
    80005510:	7dba                	ld	s11,424(sp)
    80005512:	a031                	j	8000551e <exec+0x39e>
  ip = 0;
    80005514:	4a01                	li	s4,0
    80005516:	a021                	j	8000551e <exec+0x39e>
    80005518:	4a01                	li	s4,0
  if(pagetable)
    8000551a:	a011                	j	8000551e <exec+0x39e>
    8000551c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000551e:	e0843583          	ld	a1,-504(s0)
    80005522:	855a                	mv	a0,s6
    80005524:	ffffd097          	auipc	ra,0xffffd
    80005528:	842080e7          	jalr	-1982(ra) # 80001d66 <proc_freepagetable>
  return -1;
    8000552c:	557d                	li	a0,-1
  if(ip){
    8000552e:	000a1b63          	bnez	s4,80005544 <exec+0x3c4>
    80005532:	79be                	ld	s3,488(sp)
    80005534:	7a1e                	ld	s4,480(sp)
    80005536:	6afe                	ld	s5,472(sp)
    80005538:	6b5e                	ld	s6,464(sp)
    8000553a:	6bbe                	ld	s7,456(sp)
    8000553c:	6c1e                	ld	s8,448(sp)
    8000553e:	7cfa                	ld	s9,440(sp)
    80005540:	7d5a                	ld	s10,432(sp)
    80005542:	b1e1                	j	8000520a <exec+0x8a>
    80005544:	79be                	ld	s3,488(sp)
    80005546:	6afe                	ld	s5,472(sp)
    80005548:	6b5e                	ld	s6,464(sp)
    8000554a:	6bbe                	ld	s7,456(sp)
    8000554c:	6c1e                	ld	s8,448(sp)
    8000554e:	7cfa                	ld	s9,440(sp)
    80005550:	7d5a                	ld	s10,432(sp)
    80005552:	b14d                	j	800051f4 <exec+0x74>
    80005554:	6b5e                	ld	s6,464(sp)
    80005556:	b979                	j	800051f4 <exec+0x74>
  sz = sz1;
    80005558:	e0843983          	ld	s3,-504(s0)
    8000555c:	b591                	j	800053a0 <exec+0x220>

000000008000555e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000555e:	7179                	addi	sp,sp,-48
    80005560:	f406                	sd	ra,40(sp)
    80005562:	f022                	sd	s0,32(sp)
    80005564:	ec26                	sd	s1,24(sp)
    80005566:	e84a                	sd	s2,16(sp)
    80005568:	1800                	addi	s0,sp,48
    8000556a:	892e                	mv	s2,a1
    8000556c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000556e:	fdc40593          	addi	a1,s0,-36
    80005572:	ffffe097          	auipc	ra,0xffffe
    80005576:	99e080e7          	jalr	-1634(ra) # 80002f10 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000557a:	fdc42703          	lw	a4,-36(s0)
    8000557e:	47bd                	li	a5,15
    80005580:	02e7eb63          	bltu	a5,a4,800055b6 <argfd+0x58>
    80005584:	ffffc097          	auipc	ra,0xffffc
    80005588:	682080e7          	jalr	1666(ra) # 80001c06 <myproc>
    8000558c:	fdc42703          	lw	a4,-36(s0)
    80005590:	01a70793          	addi	a5,a4,26
    80005594:	078e                	slli	a5,a5,0x3
    80005596:	953e                	add	a0,a0,a5
    80005598:	611c                	ld	a5,0(a0)
    8000559a:	c385                	beqz	a5,800055ba <argfd+0x5c>
    return -1;
  if(pfd)
    8000559c:	00090463          	beqz	s2,800055a4 <argfd+0x46>
    *pfd = fd;
    800055a0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055a4:	4501                	li	a0,0
  if(pf)
    800055a6:	c091                	beqz	s1,800055aa <argfd+0x4c>
    *pf = f;
    800055a8:	e09c                	sd	a5,0(s1)
}
    800055aa:	70a2                	ld	ra,40(sp)
    800055ac:	7402                	ld	s0,32(sp)
    800055ae:	64e2                	ld	s1,24(sp)
    800055b0:	6942                	ld	s2,16(sp)
    800055b2:	6145                	addi	sp,sp,48
    800055b4:	8082                	ret
    return -1;
    800055b6:	557d                	li	a0,-1
    800055b8:	bfcd                	j	800055aa <argfd+0x4c>
    800055ba:	557d                	li	a0,-1
    800055bc:	b7fd                	j	800055aa <argfd+0x4c>

00000000800055be <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055be:	1101                	addi	sp,sp,-32
    800055c0:	ec06                	sd	ra,24(sp)
    800055c2:	e822                	sd	s0,16(sp)
    800055c4:	e426                	sd	s1,8(sp)
    800055c6:	1000                	addi	s0,sp,32
    800055c8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055ca:	ffffc097          	auipc	ra,0xffffc
    800055ce:	63c080e7          	jalr	1596(ra) # 80001c06 <myproc>
    800055d2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800055d4:	0d050793          	addi	a5,a0,208
    800055d8:	4501                	li	a0,0
    800055da:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800055dc:	6398                	ld	a4,0(a5)
    800055de:	cb19                	beqz	a4,800055f4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800055e0:	2505                	addiw	a0,a0,1
    800055e2:	07a1                	addi	a5,a5,8
    800055e4:	fed51ce3          	bne	a0,a3,800055dc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800055e8:	557d                	li	a0,-1
}
    800055ea:	60e2                	ld	ra,24(sp)
    800055ec:	6442                	ld	s0,16(sp)
    800055ee:	64a2                	ld	s1,8(sp)
    800055f0:	6105                	addi	sp,sp,32
    800055f2:	8082                	ret
      p->ofile[fd] = f;
    800055f4:	01a50793          	addi	a5,a0,26
    800055f8:	078e                	slli	a5,a5,0x3
    800055fa:	963e                	add	a2,a2,a5
    800055fc:	e204                	sd	s1,0(a2)
      return fd;
    800055fe:	b7f5                	j	800055ea <fdalloc+0x2c>

0000000080005600 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005600:	715d                	addi	sp,sp,-80
    80005602:	e486                	sd	ra,72(sp)
    80005604:	e0a2                	sd	s0,64(sp)
    80005606:	fc26                	sd	s1,56(sp)
    80005608:	f84a                	sd	s2,48(sp)
    8000560a:	f44e                	sd	s3,40(sp)
    8000560c:	ec56                	sd	s5,24(sp)
    8000560e:	e85a                	sd	s6,16(sp)
    80005610:	0880                	addi	s0,sp,80
    80005612:	8b2e                	mv	s6,a1
    80005614:	89b2                	mv	s3,a2
    80005616:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005618:	fb040593          	addi	a1,s0,-80
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	de2080e7          	jalr	-542(ra) # 800043fe <nameiparent>
    80005624:	84aa                	mv	s1,a0
    80005626:	14050e63          	beqz	a0,80005782 <create+0x182>
    return 0;

  ilock(dp);
    8000562a:	ffffe097          	auipc	ra,0xffffe
    8000562e:	5e8080e7          	jalr	1512(ra) # 80003c12 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005632:	4601                	li	a2,0
    80005634:	fb040593          	addi	a1,s0,-80
    80005638:	8526                	mv	a0,s1
    8000563a:	fffff097          	auipc	ra,0xfffff
    8000563e:	ae4080e7          	jalr	-1308(ra) # 8000411e <dirlookup>
    80005642:	8aaa                	mv	s5,a0
    80005644:	c539                	beqz	a0,80005692 <create+0x92>
    iunlockput(dp);
    80005646:	8526                	mv	a0,s1
    80005648:	fffff097          	auipc	ra,0xfffff
    8000564c:	830080e7          	jalr	-2000(ra) # 80003e78 <iunlockput>
    ilock(ip);
    80005650:	8556                	mv	a0,s5
    80005652:	ffffe097          	auipc	ra,0xffffe
    80005656:	5c0080e7          	jalr	1472(ra) # 80003c12 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000565a:	4789                	li	a5,2
    8000565c:	02fb1463          	bne	s6,a5,80005684 <create+0x84>
    80005660:	044ad783          	lhu	a5,68(s5)
    80005664:	37f9                	addiw	a5,a5,-2
    80005666:	17c2                	slli	a5,a5,0x30
    80005668:	93c1                	srli	a5,a5,0x30
    8000566a:	4705                	li	a4,1
    8000566c:	00f76c63          	bltu	a4,a5,80005684 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005670:	8556                	mv	a0,s5
    80005672:	60a6                	ld	ra,72(sp)
    80005674:	6406                	ld	s0,64(sp)
    80005676:	74e2                	ld	s1,56(sp)
    80005678:	7942                	ld	s2,48(sp)
    8000567a:	79a2                	ld	s3,40(sp)
    8000567c:	6ae2                	ld	s5,24(sp)
    8000567e:	6b42                	ld	s6,16(sp)
    80005680:	6161                	addi	sp,sp,80
    80005682:	8082                	ret
    iunlockput(ip);
    80005684:	8556                	mv	a0,s5
    80005686:	ffffe097          	auipc	ra,0xffffe
    8000568a:	7f2080e7          	jalr	2034(ra) # 80003e78 <iunlockput>
    return 0;
    8000568e:	4a81                	li	s5,0
    80005690:	b7c5                	j	80005670 <create+0x70>
    80005692:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005694:	85da                	mv	a1,s6
    80005696:	4088                	lw	a0,0(s1)
    80005698:	ffffe097          	auipc	ra,0xffffe
    8000569c:	3d6080e7          	jalr	982(ra) # 80003a6e <ialloc>
    800056a0:	8a2a                	mv	s4,a0
    800056a2:	c531                	beqz	a0,800056ee <create+0xee>
  ilock(ip);
    800056a4:	ffffe097          	auipc	ra,0xffffe
    800056a8:	56e080e7          	jalr	1390(ra) # 80003c12 <ilock>
  ip->major = major;
    800056ac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800056b0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800056b4:	4905                	li	s2,1
    800056b6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800056ba:	8552                	mv	a0,s4
    800056bc:	ffffe097          	auipc	ra,0xffffe
    800056c0:	48a080e7          	jalr	1162(ra) # 80003b46 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056c4:	032b0d63          	beq	s6,s2,800056fe <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800056c8:	004a2603          	lw	a2,4(s4)
    800056cc:	fb040593          	addi	a1,s0,-80
    800056d0:	8526                	mv	a0,s1
    800056d2:	fffff097          	auipc	ra,0xfffff
    800056d6:	c5c080e7          	jalr	-932(ra) # 8000432e <dirlink>
    800056da:	08054163          	bltz	a0,8000575c <create+0x15c>
  iunlockput(dp);
    800056de:	8526                	mv	a0,s1
    800056e0:	ffffe097          	auipc	ra,0xffffe
    800056e4:	798080e7          	jalr	1944(ra) # 80003e78 <iunlockput>
  return ip;
    800056e8:	8ad2                	mv	s5,s4
    800056ea:	7a02                	ld	s4,32(sp)
    800056ec:	b751                	j	80005670 <create+0x70>
    iunlockput(dp);
    800056ee:	8526                	mv	a0,s1
    800056f0:	ffffe097          	auipc	ra,0xffffe
    800056f4:	788080e7          	jalr	1928(ra) # 80003e78 <iunlockput>
    return 0;
    800056f8:	8ad2                	mv	s5,s4
    800056fa:	7a02                	ld	s4,32(sp)
    800056fc:	bf95                	j	80005670 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056fe:	004a2603          	lw	a2,4(s4)
    80005702:	00003597          	auipc	a1,0x3
    80005706:	fee58593          	addi	a1,a1,-18 # 800086f0 <__func__.1+0x6e8>
    8000570a:	8552                	mv	a0,s4
    8000570c:	fffff097          	auipc	ra,0xfffff
    80005710:	c22080e7          	jalr	-990(ra) # 8000432e <dirlink>
    80005714:	04054463          	bltz	a0,8000575c <create+0x15c>
    80005718:	40d0                	lw	a2,4(s1)
    8000571a:	00003597          	auipc	a1,0x3
    8000571e:	fde58593          	addi	a1,a1,-34 # 800086f8 <__func__.1+0x6f0>
    80005722:	8552                	mv	a0,s4
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	c0a080e7          	jalr	-1014(ra) # 8000432e <dirlink>
    8000572c:	02054863          	bltz	a0,8000575c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005730:	004a2603          	lw	a2,4(s4)
    80005734:	fb040593          	addi	a1,s0,-80
    80005738:	8526                	mv	a0,s1
    8000573a:	fffff097          	auipc	ra,0xfffff
    8000573e:	bf4080e7          	jalr	-1036(ra) # 8000432e <dirlink>
    80005742:	00054d63          	bltz	a0,8000575c <create+0x15c>
    dp->nlink++;  // for ".."
    80005746:	04a4d783          	lhu	a5,74(s1)
    8000574a:	2785                	addiw	a5,a5,1
    8000574c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005750:	8526                	mv	a0,s1
    80005752:	ffffe097          	auipc	ra,0xffffe
    80005756:	3f4080e7          	jalr	1012(ra) # 80003b46 <iupdate>
    8000575a:	b751                	j	800056de <create+0xde>
  ip->nlink = 0;
    8000575c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005760:	8552                	mv	a0,s4
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	3e4080e7          	jalr	996(ra) # 80003b46 <iupdate>
  iunlockput(ip);
    8000576a:	8552                	mv	a0,s4
    8000576c:	ffffe097          	auipc	ra,0xffffe
    80005770:	70c080e7          	jalr	1804(ra) # 80003e78 <iunlockput>
  iunlockput(dp);
    80005774:	8526                	mv	a0,s1
    80005776:	ffffe097          	auipc	ra,0xffffe
    8000577a:	702080e7          	jalr	1794(ra) # 80003e78 <iunlockput>
  return 0;
    8000577e:	7a02                	ld	s4,32(sp)
    80005780:	bdc5                	j	80005670 <create+0x70>
    return 0;
    80005782:	8aaa                	mv	s5,a0
    80005784:	b5f5                	j	80005670 <create+0x70>

0000000080005786 <sys_dup>:
{
    80005786:	7179                	addi	sp,sp,-48
    80005788:	f406                	sd	ra,40(sp)
    8000578a:	f022                	sd	s0,32(sp)
    8000578c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000578e:	fd840613          	addi	a2,s0,-40
    80005792:	4581                	li	a1,0
    80005794:	4501                	li	a0,0
    80005796:	00000097          	auipc	ra,0x0
    8000579a:	dc8080e7          	jalr	-568(ra) # 8000555e <argfd>
    return -1;
    8000579e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800057a0:	02054763          	bltz	a0,800057ce <sys_dup+0x48>
    800057a4:	ec26                	sd	s1,24(sp)
    800057a6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800057a8:	fd843903          	ld	s2,-40(s0)
    800057ac:	854a                	mv	a0,s2
    800057ae:	00000097          	auipc	ra,0x0
    800057b2:	e10080e7          	jalr	-496(ra) # 800055be <fdalloc>
    800057b6:	84aa                	mv	s1,a0
    return -1;
    800057b8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057ba:	00054f63          	bltz	a0,800057d8 <sys_dup+0x52>
  filedup(f);
    800057be:	854a                	mv	a0,s2
    800057c0:	fffff097          	auipc	ra,0xfffff
    800057c4:	298080e7          	jalr	664(ra) # 80004a58 <filedup>
  return fd;
    800057c8:	87a6                	mv	a5,s1
    800057ca:	64e2                	ld	s1,24(sp)
    800057cc:	6942                	ld	s2,16(sp)
}
    800057ce:	853e                	mv	a0,a5
    800057d0:	70a2                	ld	ra,40(sp)
    800057d2:	7402                	ld	s0,32(sp)
    800057d4:	6145                	addi	sp,sp,48
    800057d6:	8082                	ret
    800057d8:	64e2                	ld	s1,24(sp)
    800057da:	6942                	ld	s2,16(sp)
    800057dc:	bfcd                	j	800057ce <sys_dup+0x48>

00000000800057de <sys_read>:
{
    800057de:	7179                	addi	sp,sp,-48
    800057e0:	f406                	sd	ra,40(sp)
    800057e2:	f022                	sd	s0,32(sp)
    800057e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057e6:	fd840593          	addi	a1,s0,-40
    800057ea:	4505                	li	a0,1
    800057ec:	ffffd097          	auipc	ra,0xffffd
    800057f0:	744080e7          	jalr	1860(ra) # 80002f30 <argaddr>
  argint(2, &n);
    800057f4:	fe440593          	addi	a1,s0,-28
    800057f8:	4509                	li	a0,2
    800057fa:	ffffd097          	auipc	ra,0xffffd
    800057fe:	716080e7          	jalr	1814(ra) # 80002f10 <argint>
  if(argfd(0, 0, &f) < 0)
    80005802:	fe840613          	addi	a2,s0,-24
    80005806:	4581                	li	a1,0
    80005808:	4501                	li	a0,0
    8000580a:	00000097          	auipc	ra,0x0
    8000580e:	d54080e7          	jalr	-684(ra) # 8000555e <argfd>
    80005812:	87aa                	mv	a5,a0
    return -1;
    80005814:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005816:	0007cc63          	bltz	a5,8000582e <sys_read+0x50>
  return fileread(f, p, n);
    8000581a:	fe442603          	lw	a2,-28(s0)
    8000581e:	fd843583          	ld	a1,-40(s0)
    80005822:	fe843503          	ld	a0,-24(s0)
    80005826:	fffff097          	auipc	ra,0xfffff
    8000582a:	3d8080e7          	jalr	984(ra) # 80004bfe <fileread>
}
    8000582e:	70a2                	ld	ra,40(sp)
    80005830:	7402                	ld	s0,32(sp)
    80005832:	6145                	addi	sp,sp,48
    80005834:	8082                	ret

0000000080005836 <sys_write>:
{
    80005836:	7179                	addi	sp,sp,-48
    80005838:	f406                	sd	ra,40(sp)
    8000583a:	f022                	sd	s0,32(sp)
    8000583c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000583e:	fd840593          	addi	a1,s0,-40
    80005842:	4505                	li	a0,1
    80005844:	ffffd097          	auipc	ra,0xffffd
    80005848:	6ec080e7          	jalr	1772(ra) # 80002f30 <argaddr>
  argint(2, &n);
    8000584c:	fe440593          	addi	a1,s0,-28
    80005850:	4509                	li	a0,2
    80005852:	ffffd097          	auipc	ra,0xffffd
    80005856:	6be080e7          	jalr	1726(ra) # 80002f10 <argint>
  if(argfd(0, 0, &f) < 0)
    8000585a:	fe840613          	addi	a2,s0,-24
    8000585e:	4581                	li	a1,0
    80005860:	4501                	li	a0,0
    80005862:	00000097          	auipc	ra,0x0
    80005866:	cfc080e7          	jalr	-772(ra) # 8000555e <argfd>
    8000586a:	87aa                	mv	a5,a0
    return -1;
    8000586c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000586e:	0007cc63          	bltz	a5,80005886 <sys_write+0x50>
  return filewrite(f, p, n);
    80005872:	fe442603          	lw	a2,-28(s0)
    80005876:	fd843583          	ld	a1,-40(s0)
    8000587a:	fe843503          	ld	a0,-24(s0)
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	452080e7          	jalr	1106(ra) # 80004cd0 <filewrite>
}
    80005886:	70a2                	ld	ra,40(sp)
    80005888:	7402                	ld	s0,32(sp)
    8000588a:	6145                	addi	sp,sp,48
    8000588c:	8082                	ret

000000008000588e <sys_close>:
{
    8000588e:	1101                	addi	sp,sp,-32
    80005890:	ec06                	sd	ra,24(sp)
    80005892:	e822                	sd	s0,16(sp)
    80005894:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005896:	fe040613          	addi	a2,s0,-32
    8000589a:	fec40593          	addi	a1,s0,-20
    8000589e:	4501                	li	a0,0
    800058a0:	00000097          	auipc	ra,0x0
    800058a4:	cbe080e7          	jalr	-834(ra) # 8000555e <argfd>
    return -1;
    800058a8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800058aa:	02054463          	bltz	a0,800058d2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800058ae:	ffffc097          	auipc	ra,0xffffc
    800058b2:	358080e7          	jalr	856(ra) # 80001c06 <myproc>
    800058b6:	fec42783          	lw	a5,-20(s0)
    800058ba:	07e9                	addi	a5,a5,26
    800058bc:	078e                	slli	a5,a5,0x3
    800058be:	953e                	add	a0,a0,a5
    800058c0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800058c4:	fe043503          	ld	a0,-32(s0)
    800058c8:	fffff097          	auipc	ra,0xfffff
    800058cc:	1e2080e7          	jalr	482(ra) # 80004aaa <fileclose>
  return 0;
    800058d0:	4781                	li	a5,0
}
    800058d2:	853e                	mv	a0,a5
    800058d4:	60e2                	ld	ra,24(sp)
    800058d6:	6442                	ld	s0,16(sp)
    800058d8:	6105                	addi	sp,sp,32
    800058da:	8082                	ret

00000000800058dc <sys_fstat>:
{
    800058dc:	1101                	addi	sp,sp,-32
    800058de:	ec06                	sd	ra,24(sp)
    800058e0:	e822                	sd	s0,16(sp)
    800058e2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800058e4:	fe040593          	addi	a1,s0,-32
    800058e8:	4505                	li	a0,1
    800058ea:	ffffd097          	auipc	ra,0xffffd
    800058ee:	646080e7          	jalr	1606(ra) # 80002f30 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800058f2:	fe840613          	addi	a2,s0,-24
    800058f6:	4581                	li	a1,0
    800058f8:	4501                	li	a0,0
    800058fa:	00000097          	auipc	ra,0x0
    800058fe:	c64080e7          	jalr	-924(ra) # 8000555e <argfd>
    80005902:	87aa                	mv	a5,a0
    return -1;
    80005904:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005906:	0007ca63          	bltz	a5,8000591a <sys_fstat+0x3e>
  return filestat(f, st);
    8000590a:	fe043583          	ld	a1,-32(s0)
    8000590e:	fe843503          	ld	a0,-24(s0)
    80005912:	fffff097          	auipc	ra,0xfffff
    80005916:	27a080e7          	jalr	634(ra) # 80004b8c <filestat>
}
    8000591a:	60e2                	ld	ra,24(sp)
    8000591c:	6442                	ld	s0,16(sp)
    8000591e:	6105                	addi	sp,sp,32
    80005920:	8082                	ret

0000000080005922 <sys_link>:
{
    80005922:	7169                	addi	sp,sp,-304
    80005924:	f606                	sd	ra,296(sp)
    80005926:	f222                	sd	s0,288(sp)
    80005928:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000592a:	08000613          	li	a2,128
    8000592e:	ed040593          	addi	a1,s0,-304
    80005932:	4501                	li	a0,0
    80005934:	ffffd097          	auipc	ra,0xffffd
    80005938:	61c080e7          	jalr	1564(ra) # 80002f50 <argstr>
    return -1;
    8000593c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000593e:	12054663          	bltz	a0,80005a6a <sys_link+0x148>
    80005942:	08000613          	li	a2,128
    80005946:	f5040593          	addi	a1,s0,-176
    8000594a:	4505                	li	a0,1
    8000594c:	ffffd097          	auipc	ra,0xffffd
    80005950:	604080e7          	jalr	1540(ra) # 80002f50 <argstr>
    return -1;
    80005954:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005956:	10054a63          	bltz	a0,80005a6a <sys_link+0x148>
    8000595a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	c84080e7          	jalr	-892(ra) # 800045e0 <begin_op>
  if((ip = namei(old)) == 0){
    80005964:	ed040513          	addi	a0,s0,-304
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	a78080e7          	jalr	-1416(ra) # 800043e0 <namei>
    80005970:	84aa                	mv	s1,a0
    80005972:	c949                	beqz	a0,80005a04 <sys_link+0xe2>
  ilock(ip);
    80005974:	ffffe097          	auipc	ra,0xffffe
    80005978:	29e080e7          	jalr	670(ra) # 80003c12 <ilock>
  if(ip->type == T_DIR){
    8000597c:	04449703          	lh	a4,68(s1)
    80005980:	4785                	li	a5,1
    80005982:	08f70863          	beq	a4,a5,80005a12 <sys_link+0xf0>
    80005986:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005988:	04a4d783          	lhu	a5,74(s1)
    8000598c:	2785                	addiw	a5,a5,1
    8000598e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005992:	8526                	mv	a0,s1
    80005994:	ffffe097          	auipc	ra,0xffffe
    80005998:	1b2080e7          	jalr	434(ra) # 80003b46 <iupdate>
  iunlock(ip);
    8000599c:	8526                	mv	a0,s1
    8000599e:	ffffe097          	auipc	ra,0xffffe
    800059a2:	33a080e7          	jalr	826(ra) # 80003cd8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800059a6:	fd040593          	addi	a1,s0,-48
    800059aa:	f5040513          	addi	a0,s0,-176
    800059ae:	fffff097          	auipc	ra,0xfffff
    800059b2:	a50080e7          	jalr	-1456(ra) # 800043fe <nameiparent>
    800059b6:	892a                	mv	s2,a0
    800059b8:	cd35                	beqz	a0,80005a34 <sys_link+0x112>
  ilock(dp);
    800059ba:	ffffe097          	auipc	ra,0xffffe
    800059be:	258080e7          	jalr	600(ra) # 80003c12 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059c2:	00092703          	lw	a4,0(s2)
    800059c6:	409c                	lw	a5,0(s1)
    800059c8:	06f71163          	bne	a4,a5,80005a2a <sys_link+0x108>
    800059cc:	40d0                	lw	a2,4(s1)
    800059ce:	fd040593          	addi	a1,s0,-48
    800059d2:	854a                	mv	a0,s2
    800059d4:	fffff097          	auipc	ra,0xfffff
    800059d8:	95a080e7          	jalr	-1702(ra) # 8000432e <dirlink>
    800059dc:	04054763          	bltz	a0,80005a2a <sys_link+0x108>
  iunlockput(dp);
    800059e0:	854a                	mv	a0,s2
    800059e2:	ffffe097          	auipc	ra,0xffffe
    800059e6:	496080e7          	jalr	1174(ra) # 80003e78 <iunlockput>
  iput(ip);
    800059ea:	8526                	mv	a0,s1
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	3e4080e7          	jalr	996(ra) # 80003dd0 <iput>
  end_op();
    800059f4:	fffff097          	auipc	ra,0xfffff
    800059f8:	c66080e7          	jalr	-922(ra) # 8000465a <end_op>
  return 0;
    800059fc:	4781                	li	a5,0
    800059fe:	64f2                	ld	s1,280(sp)
    80005a00:	6952                	ld	s2,272(sp)
    80005a02:	a0a5                	j	80005a6a <sys_link+0x148>
    end_op();
    80005a04:	fffff097          	auipc	ra,0xfffff
    80005a08:	c56080e7          	jalr	-938(ra) # 8000465a <end_op>
    return -1;
    80005a0c:	57fd                	li	a5,-1
    80005a0e:	64f2                	ld	s1,280(sp)
    80005a10:	a8a9                	j	80005a6a <sys_link+0x148>
    iunlockput(ip);
    80005a12:	8526                	mv	a0,s1
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	464080e7          	jalr	1124(ra) # 80003e78 <iunlockput>
    end_op();
    80005a1c:	fffff097          	auipc	ra,0xfffff
    80005a20:	c3e080e7          	jalr	-962(ra) # 8000465a <end_op>
    return -1;
    80005a24:	57fd                	li	a5,-1
    80005a26:	64f2                	ld	s1,280(sp)
    80005a28:	a089                	j	80005a6a <sys_link+0x148>
    iunlockput(dp);
    80005a2a:	854a                	mv	a0,s2
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	44c080e7          	jalr	1100(ra) # 80003e78 <iunlockput>
  ilock(ip);
    80005a34:	8526                	mv	a0,s1
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	1dc080e7          	jalr	476(ra) # 80003c12 <ilock>
  ip->nlink--;
    80005a3e:	04a4d783          	lhu	a5,74(s1)
    80005a42:	37fd                	addiw	a5,a5,-1
    80005a44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a48:	8526                	mv	a0,s1
    80005a4a:	ffffe097          	auipc	ra,0xffffe
    80005a4e:	0fc080e7          	jalr	252(ra) # 80003b46 <iupdate>
  iunlockput(ip);
    80005a52:	8526                	mv	a0,s1
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	424080e7          	jalr	1060(ra) # 80003e78 <iunlockput>
  end_op();
    80005a5c:	fffff097          	auipc	ra,0xfffff
    80005a60:	bfe080e7          	jalr	-1026(ra) # 8000465a <end_op>
  return -1;
    80005a64:	57fd                	li	a5,-1
    80005a66:	64f2                	ld	s1,280(sp)
    80005a68:	6952                	ld	s2,272(sp)
}
    80005a6a:	853e                	mv	a0,a5
    80005a6c:	70b2                	ld	ra,296(sp)
    80005a6e:	7412                	ld	s0,288(sp)
    80005a70:	6155                	addi	sp,sp,304
    80005a72:	8082                	ret

0000000080005a74 <sys_unlink>:
{
    80005a74:	7151                	addi	sp,sp,-240
    80005a76:	f586                	sd	ra,232(sp)
    80005a78:	f1a2                	sd	s0,224(sp)
    80005a7a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a7c:	08000613          	li	a2,128
    80005a80:	f3040593          	addi	a1,s0,-208
    80005a84:	4501                	li	a0,0
    80005a86:	ffffd097          	auipc	ra,0xffffd
    80005a8a:	4ca080e7          	jalr	1226(ra) # 80002f50 <argstr>
    80005a8e:	1a054a63          	bltz	a0,80005c42 <sys_unlink+0x1ce>
    80005a92:	eda6                	sd	s1,216(sp)
  begin_op();
    80005a94:	fffff097          	auipc	ra,0xfffff
    80005a98:	b4c080e7          	jalr	-1204(ra) # 800045e0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a9c:	fb040593          	addi	a1,s0,-80
    80005aa0:	f3040513          	addi	a0,s0,-208
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	95a080e7          	jalr	-1702(ra) # 800043fe <nameiparent>
    80005aac:	84aa                	mv	s1,a0
    80005aae:	cd71                	beqz	a0,80005b8a <sys_unlink+0x116>
  ilock(dp);
    80005ab0:	ffffe097          	auipc	ra,0xffffe
    80005ab4:	162080e7          	jalr	354(ra) # 80003c12 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ab8:	00003597          	auipc	a1,0x3
    80005abc:	c3858593          	addi	a1,a1,-968 # 800086f0 <__func__.1+0x6e8>
    80005ac0:	fb040513          	addi	a0,s0,-80
    80005ac4:	ffffe097          	auipc	ra,0xffffe
    80005ac8:	640080e7          	jalr	1600(ra) # 80004104 <namecmp>
    80005acc:	14050c63          	beqz	a0,80005c24 <sys_unlink+0x1b0>
    80005ad0:	00003597          	auipc	a1,0x3
    80005ad4:	c2858593          	addi	a1,a1,-984 # 800086f8 <__func__.1+0x6f0>
    80005ad8:	fb040513          	addi	a0,s0,-80
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	628080e7          	jalr	1576(ra) # 80004104 <namecmp>
    80005ae4:	14050063          	beqz	a0,80005c24 <sys_unlink+0x1b0>
    80005ae8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005aea:	f2c40613          	addi	a2,s0,-212
    80005aee:	fb040593          	addi	a1,s0,-80
    80005af2:	8526                	mv	a0,s1
    80005af4:	ffffe097          	auipc	ra,0xffffe
    80005af8:	62a080e7          	jalr	1578(ra) # 8000411e <dirlookup>
    80005afc:	892a                	mv	s2,a0
    80005afe:	12050263          	beqz	a0,80005c22 <sys_unlink+0x1ae>
  ilock(ip);
    80005b02:	ffffe097          	auipc	ra,0xffffe
    80005b06:	110080e7          	jalr	272(ra) # 80003c12 <ilock>
  if(ip->nlink < 1)
    80005b0a:	04a91783          	lh	a5,74(s2)
    80005b0e:	08f05563          	blez	a5,80005b98 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b12:	04491703          	lh	a4,68(s2)
    80005b16:	4785                	li	a5,1
    80005b18:	08f70963          	beq	a4,a5,80005baa <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005b1c:	4641                	li	a2,16
    80005b1e:	4581                	li	a1,0
    80005b20:	fc040513          	addi	a0,s0,-64
    80005b24:	ffffb097          	auipc	ra,0xffffb
    80005b28:	2d8080e7          	jalr	728(ra) # 80000dfc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b2c:	4741                	li	a4,16
    80005b2e:	f2c42683          	lw	a3,-212(s0)
    80005b32:	fc040613          	addi	a2,s0,-64
    80005b36:	4581                	li	a1,0
    80005b38:	8526                	mv	a0,s1
    80005b3a:	ffffe097          	auipc	ra,0xffffe
    80005b3e:	4a0080e7          	jalr	1184(ra) # 80003fda <writei>
    80005b42:	47c1                	li	a5,16
    80005b44:	0af51b63          	bne	a0,a5,80005bfa <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005b48:	04491703          	lh	a4,68(s2)
    80005b4c:	4785                	li	a5,1
    80005b4e:	0af70f63          	beq	a4,a5,80005c0c <sys_unlink+0x198>
  iunlockput(dp);
    80005b52:	8526                	mv	a0,s1
    80005b54:	ffffe097          	auipc	ra,0xffffe
    80005b58:	324080e7          	jalr	804(ra) # 80003e78 <iunlockput>
  ip->nlink--;
    80005b5c:	04a95783          	lhu	a5,74(s2)
    80005b60:	37fd                	addiw	a5,a5,-1
    80005b62:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b66:	854a                	mv	a0,s2
    80005b68:	ffffe097          	auipc	ra,0xffffe
    80005b6c:	fde080e7          	jalr	-34(ra) # 80003b46 <iupdate>
  iunlockput(ip);
    80005b70:	854a                	mv	a0,s2
    80005b72:	ffffe097          	auipc	ra,0xffffe
    80005b76:	306080e7          	jalr	774(ra) # 80003e78 <iunlockput>
  end_op();
    80005b7a:	fffff097          	auipc	ra,0xfffff
    80005b7e:	ae0080e7          	jalr	-1312(ra) # 8000465a <end_op>
  return 0;
    80005b82:	4501                	li	a0,0
    80005b84:	64ee                	ld	s1,216(sp)
    80005b86:	694e                	ld	s2,208(sp)
    80005b88:	a84d                	j	80005c3a <sys_unlink+0x1c6>
    end_op();
    80005b8a:	fffff097          	auipc	ra,0xfffff
    80005b8e:	ad0080e7          	jalr	-1328(ra) # 8000465a <end_op>
    return -1;
    80005b92:	557d                	li	a0,-1
    80005b94:	64ee                	ld	s1,216(sp)
    80005b96:	a055                	j	80005c3a <sys_unlink+0x1c6>
    80005b98:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005b9a:	00003517          	auipc	a0,0x3
    80005b9e:	b6650513          	addi	a0,a0,-1178 # 80008700 <__func__.1+0x6f8>
    80005ba2:	ffffb097          	auipc	ra,0xffffb
    80005ba6:	9be080e7          	jalr	-1602(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005baa:	04c92703          	lw	a4,76(s2)
    80005bae:	02000793          	li	a5,32
    80005bb2:	f6e7f5e3          	bgeu	a5,a4,80005b1c <sys_unlink+0xa8>
    80005bb6:	e5ce                	sd	s3,200(sp)
    80005bb8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bbc:	4741                	li	a4,16
    80005bbe:	86ce                	mv	a3,s3
    80005bc0:	f1840613          	addi	a2,s0,-232
    80005bc4:	4581                	li	a1,0
    80005bc6:	854a                	mv	a0,s2
    80005bc8:	ffffe097          	auipc	ra,0xffffe
    80005bcc:	302080e7          	jalr	770(ra) # 80003eca <readi>
    80005bd0:	47c1                	li	a5,16
    80005bd2:	00f51c63          	bne	a0,a5,80005bea <sys_unlink+0x176>
    if(de.inum != 0)
    80005bd6:	f1845783          	lhu	a5,-232(s0)
    80005bda:	e7b5                	bnez	a5,80005c46 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bdc:	29c1                	addiw	s3,s3,16
    80005bde:	04c92783          	lw	a5,76(s2)
    80005be2:	fcf9ede3          	bltu	s3,a5,80005bbc <sys_unlink+0x148>
    80005be6:	69ae                	ld	s3,200(sp)
    80005be8:	bf15                	j	80005b1c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005bea:	00003517          	auipc	a0,0x3
    80005bee:	b2e50513          	addi	a0,a0,-1234 # 80008718 <__func__.1+0x710>
    80005bf2:	ffffb097          	auipc	ra,0xffffb
    80005bf6:	96e080e7          	jalr	-1682(ra) # 80000560 <panic>
    80005bfa:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005bfc:	00003517          	auipc	a0,0x3
    80005c00:	b3450513          	addi	a0,a0,-1228 # 80008730 <__func__.1+0x728>
    80005c04:	ffffb097          	auipc	ra,0xffffb
    80005c08:	95c080e7          	jalr	-1700(ra) # 80000560 <panic>
    dp->nlink--;
    80005c0c:	04a4d783          	lhu	a5,74(s1)
    80005c10:	37fd                	addiw	a5,a5,-1
    80005c12:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005c16:	8526                	mv	a0,s1
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	f2e080e7          	jalr	-210(ra) # 80003b46 <iupdate>
    80005c20:	bf0d                	j	80005b52 <sys_unlink+0xde>
    80005c22:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005c24:	8526                	mv	a0,s1
    80005c26:	ffffe097          	auipc	ra,0xffffe
    80005c2a:	252080e7          	jalr	594(ra) # 80003e78 <iunlockput>
  end_op();
    80005c2e:	fffff097          	auipc	ra,0xfffff
    80005c32:	a2c080e7          	jalr	-1492(ra) # 8000465a <end_op>
  return -1;
    80005c36:	557d                	li	a0,-1
    80005c38:	64ee                	ld	s1,216(sp)
}
    80005c3a:	70ae                	ld	ra,232(sp)
    80005c3c:	740e                	ld	s0,224(sp)
    80005c3e:	616d                	addi	sp,sp,240
    80005c40:	8082                	ret
    return -1;
    80005c42:	557d                	li	a0,-1
    80005c44:	bfdd                	j	80005c3a <sys_unlink+0x1c6>
    iunlockput(ip);
    80005c46:	854a                	mv	a0,s2
    80005c48:	ffffe097          	auipc	ra,0xffffe
    80005c4c:	230080e7          	jalr	560(ra) # 80003e78 <iunlockput>
    goto bad;
    80005c50:	694e                	ld	s2,208(sp)
    80005c52:	69ae                	ld	s3,200(sp)
    80005c54:	bfc1                	j	80005c24 <sys_unlink+0x1b0>

0000000080005c56 <sys_open>:

uint64
sys_open(void)
{
    80005c56:	7131                	addi	sp,sp,-192
    80005c58:	fd06                	sd	ra,184(sp)
    80005c5a:	f922                	sd	s0,176(sp)
    80005c5c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005c5e:	f4c40593          	addi	a1,s0,-180
    80005c62:	4505                	li	a0,1
    80005c64:	ffffd097          	auipc	ra,0xffffd
    80005c68:	2ac080e7          	jalr	684(ra) # 80002f10 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c6c:	08000613          	li	a2,128
    80005c70:	f5040593          	addi	a1,s0,-176
    80005c74:	4501                	li	a0,0
    80005c76:	ffffd097          	auipc	ra,0xffffd
    80005c7a:	2da080e7          	jalr	730(ra) # 80002f50 <argstr>
    80005c7e:	87aa                	mv	a5,a0
    return -1;
    80005c80:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c82:	0a07ce63          	bltz	a5,80005d3e <sys_open+0xe8>
    80005c86:	f526                	sd	s1,168(sp)

  begin_op();
    80005c88:	fffff097          	auipc	ra,0xfffff
    80005c8c:	958080e7          	jalr	-1704(ra) # 800045e0 <begin_op>

  if(omode & O_CREATE){
    80005c90:	f4c42783          	lw	a5,-180(s0)
    80005c94:	2007f793          	andi	a5,a5,512
    80005c98:	cfd5                	beqz	a5,80005d54 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c9a:	4681                	li	a3,0
    80005c9c:	4601                	li	a2,0
    80005c9e:	4589                	li	a1,2
    80005ca0:	f5040513          	addi	a0,s0,-176
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	95c080e7          	jalr	-1700(ra) # 80005600 <create>
    80005cac:	84aa                	mv	s1,a0
    if(ip == 0){
    80005cae:	cd41                	beqz	a0,80005d46 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005cb0:	04449703          	lh	a4,68(s1)
    80005cb4:	478d                	li	a5,3
    80005cb6:	00f71763          	bne	a4,a5,80005cc4 <sys_open+0x6e>
    80005cba:	0464d703          	lhu	a4,70(s1)
    80005cbe:	47a5                	li	a5,9
    80005cc0:	0ee7e163          	bltu	a5,a4,80005da2 <sys_open+0x14c>
    80005cc4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005cc6:	fffff097          	auipc	ra,0xfffff
    80005cca:	d28080e7          	jalr	-728(ra) # 800049ee <filealloc>
    80005cce:	892a                	mv	s2,a0
    80005cd0:	c97d                	beqz	a0,80005dc6 <sys_open+0x170>
    80005cd2:	ed4e                	sd	s3,152(sp)
    80005cd4:	00000097          	auipc	ra,0x0
    80005cd8:	8ea080e7          	jalr	-1814(ra) # 800055be <fdalloc>
    80005cdc:	89aa                	mv	s3,a0
    80005cde:	0c054e63          	bltz	a0,80005dba <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005ce2:	04449703          	lh	a4,68(s1)
    80005ce6:	478d                	li	a5,3
    80005ce8:	0ef70c63          	beq	a4,a5,80005de0 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005cec:	4789                	li	a5,2
    80005cee:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005cf2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005cf6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005cfa:	f4c42783          	lw	a5,-180(s0)
    80005cfe:	0017c713          	xori	a4,a5,1
    80005d02:	8b05                	andi	a4,a4,1
    80005d04:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005d08:	0037f713          	andi	a4,a5,3
    80005d0c:	00e03733          	snez	a4,a4
    80005d10:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005d14:	4007f793          	andi	a5,a5,1024
    80005d18:	c791                	beqz	a5,80005d24 <sys_open+0xce>
    80005d1a:	04449703          	lh	a4,68(s1)
    80005d1e:	4789                	li	a5,2
    80005d20:	0cf70763          	beq	a4,a5,80005dee <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005d24:	8526                	mv	a0,s1
    80005d26:	ffffe097          	auipc	ra,0xffffe
    80005d2a:	fb2080e7          	jalr	-78(ra) # 80003cd8 <iunlock>
  end_op();
    80005d2e:	fffff097          	auipc	ra,0xfffff
    80005d32:	92c080e7          	jalr	-1748(ra) # 8000465a <end_op>

  return fd;
    80005d36:	854e                	mv	a0,s3
    80005d38:	74aa                	ld	s1,168(sp)
    80005d3a:	790a                	ld	s2,160(sp)
    80005d3c:	69ea                	ld	s3,152(sp)
}
    80005d3e:	70ea                	ld	ra,184(sp)
    80005d40:	744a                	ld	s0,176(sp)
    80005d42:	6129                	addi	sp,sp,192
    80005d44:	8082                	ret
      end_op();
    80005d46:	fffff097          	auipc	ra,0xfffff
    80005d4a:	914080e7          	jalr	-1772(ra) # 8000465a <end_op>
      return -1;
    80005d4e:	557d                	li	a0,-1
    80005d50:	74aa                	ld	s1,168(sp)
    80005d52:	b7f5                	j	80005d3e <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005d54:	f5040513          	addi	a0,s0,-176
    80005d58:	ffffe097          	auipc	ra,0xffffe
    80005d5c:	688080e7          	jalr	1672(ra) # 800043e0 <namei>
    80005d60:	84aa                	mv	s1,a0
    80005d62:	c90d                	beqz	a0,80005d94 <sys_open+0x13e>
    ilock(ip);
    80005d64:	ffffe097          	auipc	ra,0xffffe
    80005d68:	eae080e7          	jalr	-338(ra) # 80003c12 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005d6c:	04449703          	lh	a4,68(s1)
    80005d70:	4785                	li	a5,1
    80005d72:	f2f71fe3          	bne	a4,a5,80005cb0 <sys_open+0x5a>
    80005d76:	f4c42783          	lw	a5,-180(s0)
    80005d7a:	d7a9                	beqz	a5,80005cc4 <sys_open+0x6e>
      iunlockput(ip);
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	ffffe097          	auipc	ra,0xffffe
    80005d82:	0fa080e7          	jalr	250(ra) # 80003e78 <iunlockput>
      end_op();
    80005d86:	fffff097          	auipc	ra,0xfffff
    80005d8a:	8d4080e7          	jalr	-1836(ra) # 8000465a <end_op>
      return -1;
    80005d8e:	557d                	li	a0,-1
    80005d90:	74aa                	ld	s1,168(sp)
    80005d92:	b775                	j	80005d3e <sys_open+0xe8>
      end_op();
    80005d94:	fffff097          	auipc	ra,0xfffff
    80005d98:	8c6080e7          	jalr	-1850(ra) # 8000465a <end_op>
      return -1;
    80005d9c:	557d                	li	a0,-1
    80005d9e:	74aa                	ld	s1,168(sp)
    80005da0:	bf79                	j	80005d3e <sys_open+0xe8>
    iunlockput(ip);
    80005da2:	8526                	mv	a0,s1
    80005da4:	ffffe097          	auipc	ra,0xffffe
    80005da8:	0d4080e7          	jalr	212(ra) # 80003e78 <iunlockput>
    end_op();
    80005dac:	fffff097          	auipc	ra,0xfffff
    80005db0:	8ae080e7          	jalr	-1874(ra) # 8000465a <end_op>
    return -1;
    80005db4:	557d                	li	a0,-1
    80005db6:	74aa                	ld	s1,168(sp)
    80005db8:	b759                	j	80005d3e <sys_open+0xe8>
      fileclose(f);
    80005dba:	854a                	mv	a0,s2
    80005dbc:	fffff097          	auipc	ra,0xfffff
    80005dc0:	cee080e7          	jalr	-786(ra) # 80004aaa <fileclose>
    80005dc4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005dc6:	8526                	mv	a0,s1
    80005dc8:	ffffe097          	auipc	ra,0xffffe
    80005dcc:	0b0080e7          	jalr	176(ra) # 80003e78 <iunlockput>
    end_op();
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	88a080e7          	jalr	-1910(ra) # 8000465a <end_op>
    return -1;
    80005dd8:	557d                	li	a0,-1
    80005dda:	74aa                	ld	s1,168(sp)
    80005ddc:	790a                	ld	s2,160(sp)
    80005dde:	b785                	j	80005d3e <sys_open+0xe8>
    f->type = FD_DEVICE;
    80005de0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005de4:	04649783          	lh	a5,70(s1)
    80005de8:	02f91223          	sh	a5,36(s2)
    80005dec:	b729                	j	80005cf6 <sys_open+0xa0>
    itrunc(ip);
    80005dee:	8526                	mv	a0,s1
    80005df0:	ffffe097          	auipc	ra,0xffffe
    80005df4:	f34080e7          	jalr	-204(ra) # 80003d24 <itrunc>
    80005df8:	b735                	j	80005d24 <sys_open+0xce>

0000000080005dfa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005dfa:	7175                	addi	sp,sp,-144
    80005dfc:	e506                	sd	ra,136(sp)
    80005dfe:	e122                	sd	s0,128(sp)
    80005e00:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e02:	ffffe097          	auipc	ra,0xffffe
    80005e06:	7de080e7          	jalr	2014(ra) # 800045e0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e0a:	08000613          	li	a2,128
    80005e0e:	f7040593          	addi	a1,s0,-144
    80005e12:	4501                	li	a0,0
    80005e14:	ffffd097          	auipc	ra,0xffffd
    80005e18:	13c080e7          	jalr	316(ra) # 80002f50 <argstr>
    80005e1c:	02054963          	bltz	a0,80005e4e <sys_mkdir+0x54>
    80005e20:	4681                	li	a3,0
    80005e22:	4601                	li	a2,0
    80005e24:	4585                	li	a1,1
    80005e26:	f7040513          	addi	a0,s0,-144
    80005e2a:	fffff097          	auipc	ra,0xfffff
    80005e2e:	7d6080e7          	jalr	2006(ra) # 80005600 <create>
    80005e32:	cd11                	beqz	a0,80005e4e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e34:	ffffe097          	auipc	ra,0xffffe
    80005e38:	044080e7          	jalr	68(ra) # 80003e78 <iunlockput>
  end_op();
    80005e3c:	fffff097          	auipc	ra,0xfffff
    80005e40:	81e080e7          	jalr	-2018(ra) # 8000465a <end_op>
  return 0;
    80005e44:	4501                	li	a0,0
}
    80005e46:	60aa                	ld	ra,136(sp)
    80005e48:	640a                	ld	s0,128(sp)
    80005e4a:	6149                	addi	sp,sp,144
    80005e4c:	8082                	ret
    end_op();
    80005e4e:	fffff097          	auipc	ra,0xfffff
    80005e52:	80c080e7          	jalr	-2036(ra) # 8000465a <end_op>
    return -1;
    80005e56:	557d                	li	a0,-1
    80005e58:	b7fd                	j	80005e46 <sys_mkdir+0x4c>

0000000080005e5a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e5a:	7135                	addi	sp,sp,-160
    80005e5c:	ed06                	sd	ra,152(sp)
    80005e5e:	e922                	sd	s0,144(sp)
    80005e60:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e62:	ffffe097          	auipc	ra,0xffffe
    80005e66:	77e080e7          	jalr	1918(ra) # 800045e0 <begin_op>
  argint(1, &major);
    80005e6a:	f6c40593          	addi	a1,s0,-148
    80005e6e:	4505                	li	a0,1
    80005e70:	ffffd097          	auipc	ra,0xffffd
    80005e74:	0a0080e7          	jalr	160(ra) # 80002f10 <argint>
  argint(2, &minor);
    80005e78:	f6840593          	addi	a1,s0,-152
    80005e7c:	4509                	li	a0,2
    80005e7e:	ffffd097          	auipc	ra,0xffffd
    80005e82:	092080e7          	jalr	146(ra) # 80002f10 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e86:	08000613          	li	a2,128
    80005e8a:	f7040593          	addi	a1,s0,-144
    80005e8e:	4501                	li	a0,0
    80005e90:	ffffd097          	auipc	ra,0xffffd
    80005e94:	0c0080e7          	jalr	192(ra) # 80002f50 <argstr>
    80005e98:	02054b63          	bltz	a0,80005ece <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e9c:	f6841683          	lh	a3,-152(s0)
    80005ea0:	f6c41603          	lh	a2,-148(s0)
    80005ea4:	458d                	li	a1,3
    80005ea6:	f7040513          	addi	a0,s0,-144
    80005eaa:	fffff097          	auipc	ra,0xfffff
    80005eae:	756080e7          	jalr	1878(ra) # 80005600 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005eb2:	cd11                	beqz	a0,80005ece <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005eb4:	ffffe097          	auipc	ra,0xffffe
    80005eb8:	fc4080e7          	jalr	-60(ra) # 80003e78 <iunlockput>
  end_op();
    80005ebc:	ffffe097          	auipc	ra,0xffffe
    80005ec0:	79e080e7          	jalr	1950(ra) # 8000465a <end_op>
  return 0;
    80005ec4:	4501                	li	a0,0
}
    80005ec6:	60ea                	ld	ra,152(sp)
    80005ec8:	644a                	ld	s0,144(sp)
    80005eca:	610d                	addi	sp,sp,160
    80005ecc:	8082                	ret
    end_op();
    80005ece:	ffffe097          	auipc	ra,0xffffe
    80005ed2:	78c080e7          	jalr	1932(ra) # 8000465a <end_op>
    return -1;
    80005ed6:	557d                	li	a0,-1
    80005ed8:	b7fd                	j	80005ec6 <sys_mknod+0x6c>

0000000080005eda <sys_chdir>:

uint64
sys_chdir(void)
{
    80005eda:	7135                	addi	sp,sp,-160
    80005edc:	ed06                	sd	ra,152(sp)
    80005ede:	e922                	sd	s0,144(sp)
    80005ee0:	e14a                	sd	s2,128(sp)
    80005ee2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ee4:	ffffc097          	auipc	ra,0xffffc
    80005ee8:	d22080e7          	jalr	-734(ra) # 80001c06 <myproc>
    80005eec:	892a                	mv	s2,a0
  
  begin_op();
    80005eee:	ffffe097          	auipc	ra,0xffffe
    80005ef2:	6f2080e7          	jalr	1778(ra) # 800045e0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ef6:	08000613          	li	a2,128
    80005efa:	f6040593          	addi	a1,s0,-160
    80005efe:	4501                	li	a0,0
    80005f00:	ffffd097          	auipc	ra,0xffffd
    80005f04:	050080e7          	jalr	80(ra) # 80002f50 <argstr>
    80005f08:	04054d63          	bltz	a0,80005f62 <sys_chdir+0x88>
    80005f0c:	e526                	sd	s1,136(sp)
    80005f0e:	f6040513          	addi	a0,s0,-160
    80005f12:	ffffe097          	auipc	ra,0xffffe
    80005f16:	4ce080e7          	jalr	1230(ra) # 800043e0 <namei>
    80005f1a:	84aa                	mv	s1,a0
    80005f1c:	c131                	beqz	a0,80005f60 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f1e:	ffffe097          	auipc	ra,0xffffe
    80005f22:	cf4080e7          	jalr	-780(ra) # 80003c12 <ilock>
  if(ip->type != T_DIR){
    80005f26:	04449703          	lh	a4,68(s1)
    80005f2a:	4785                	li	a5,1
    80005f2c:	04f71163          	bne	a4,a5,80005f6e <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f30:	8526                	mv	a0,s1
    80005f32:	ffffe097          	auipc	ra,0xffffe
    80005f36:	da6080e7          	jalr	-602(ra) # 80003cd8 <iunlock>
  iput(p->cwd);
    80005f3a:	15093503          	ld	a0,336(s2)
    80005f3e:	ffffe097          	auipc	ra,0xffffe
    80005f42:	e92080e7          	jalr	-366(ra) # 80003dd0 <iput>
  end_op();
    80005f46:	ffffe097          	auipc	ra,0xffffe
    80005f4a:	714080e7          	jalr	1812(ra) # 8000465a <end_op>
  p->cwd = ip;
    80005f4e:	14993823          	sd	s1,336(s2)
  return 0;
    80005f52:	4501                	li	a0,0
    80005f54:	64aa                	ld	s1,136(sp)
}
    80005f56:	60ea                	ld	ra,152(sp)
    80005f58:	644a                	ld	s0,144(sp)
    80005f5a:	690a                	ld	s2,128(sp)
    80005f5c:	610d                	addi	sp,sp,160
    80005f5e:	8082                	ret
    80005f60:	64aa                	ld	s1,136(sp)
    end_op();
    80005f62:	ffffe097          	auipc	ra,0xffffe
    80005f66:	6f8080e7          	jalr	1784(ra) # 8000465a <end_op>
    return -1;
    80005f6a:	557d                	li	a0,-1
    80005f6c:	b7ed                	j	80005f56 <sys_chdir+0x7c>
    iunlockput(ip);
    80005f6e:	8526                	mv	a0,s1
    80005f70:	ffffe097          	auipc	ra,0xffffe
    80005f74:	f08080e7          	jalr	-248(ra) # 80003e78 <iunlockput>
    end_op();
    80005f78:	ffffe097          	auipc	ra,0xffffe
    80005f7c:	6e2080e7          	jalr	1762(ra) # 8000465a <end_op>
    return -1;
    80005f80:	557d                	li	a0,-1
    80005f82:	64aa                	ld	s1,136(sp)
    80005f84:	bfc9                	j	80005f56 <sys_chdir+0x7c>

0000000080005f86 <sys_exec>:

uint64
sys_exec(void)
{
    80005f86:	7121                	addi	sp,sp,-448
    80005f88:	ff06                	sd	ra,440(sp)
    80005f8a:	fb22                	sd	s0,432(sp)
    80005f8c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005f8e:	e4840593          	addi	a1,s0,-440
    80005f92:	4505                	li	a0,1
    80005f94:	ffffd097          	auipc	ra,0xffffd
    80005f98:	f9c080e7          	jalr	-100(ra) # 80002f30 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005f9c:	08000613          	li	a2,128
    80005fa0:	f5040593          	addi	a1,s0,-176
    80005fa4:	4501                	li	a0,0
    80005fa6:	ffffd097          	auipc	ra,0xffffd
    80005faa:	faa080e7          	jalr	-86(ra) # 80002f50 <argstr>
    80005fae:	87aa                	mv	a5,a0
    return -1;
    80005fb0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005fb2:	0e07c263          	bltz	a5,80006096 <sys_exec+0x110>
    80005fb6:	f726                	sd	s1,424(sp)
    80005fb8:	f34a                	sd	s2,416(sp)
    80005fba:	ef4e                	sd	s3,408(sp)
    80005fbc:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005fbe:	10000613          	li	a2,256
    80005fc2:	4581                	li	a1,0
    80005fc4:	e5040513          	addi	a0,s0,-432
    80005fc8:	ffffb097          	auipc	ra,0xffffb
    80005fcc:	e34080e7          	jalr	-460(ra) # 80000dfc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005fd0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005fd4:	89a6                	mv	s3,s1
    80005fd6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005fd8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fdc:	00391513          	slli	a0,s2,0x3
    80005fe0:	e4040593          	addi	a1,s0,-448
    80005fe4:	e4843783          	ld	a5,-440(s0)
    80005fe8:	953e                	add	a0,a0,a5
    80005fea:	ffffd097          	auipc	ra,0xffffd
    80005fee:	e88080e7          	jalr	-376(ra) # 80002e72 <fetchaddr>
    80005ff2:	02054a63          	bltz	a0,80006026 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005ff6:	e4043783          	ld	a5,-448(s0)
    80005ffa:	c7b9                	beqz	a5,80006048 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ffc:	ffffb097          	auipc	ra,0xffffb
    80006000:	bc8080e7          	jalr	-1080(ra) # 80000bc4 <kalloc>
    80006004:	85aa                	mv	a1,a0
    80006006:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000600a:	cd11                	beqz	a0,80006026 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000600c:	6605                	lui	a2,0x1
    8000600e:	e4043503          	ld	a0,-448(s0)
    80006012:	ffffd097          	auipc	ra,0xffffd
    80006016:	eb2080e7          	jalr	-334(ra) # 80002ec4 <fetchstr>
    8000601a:	00054663          	bltz	a0,80006026 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000601e:	0905                	addi	s2,s2,1
    80006020:	09a1                	addi	s3,s3,8
    80006022:	fb491de3          	bne	s2,s4,80005fdc <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006026:	f5040913          	addi	s2,s0,-176
    8000602a:	6088                	ld	a0,0(s1)
    8000602c:	c125                	beqz	a0,8000608c <sys_exec+0x106>
    kfree(argv[i]);
    8000602e:	ffffb097          	auipc	ra,0xffffb
    80006032:	a2e080e7          	jalr	-1490(ra) # 80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006036:	04a1                	addi	s1,s1,8
    80006038:	ff2499e3          	bne	s1,s2,8000602a <sys_exec+0xa4>
  return -1;
    8000603c:	557d                	li	a0,-1
    8000603e:	74ba                	ld	s1,424(sp)
    80006040:	791a                	ld	s2,416(sp)
    80006042:	69fa                	ld	s3,408(sp)
    80006044:	6a5a                	ld	s4,400(sp)
    80006046:	a881                	j	80006096 <sys_exec+0x110>
      argv[i] = 0;
    80006048:	0009079b          	sext.w	a5,s2
    8000604c:	078e                	slli	a5,a5,0x3
    8000604e:	fd078793          	addi	a5,a5,-48
    80006052:	97a2                	add	a5,a5,s0
    80006054:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006058:	e5040593          	addi	a1,s0,-432
    8000605c:	f5040513          	addi	a0,s0,-176
    80006060:	fffff097          	auipc	ra,0xfffff
    80006064:	120080e7          	jalr	288(ra) # 80005180 <exec>
    80006068:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000606a:	f5040993          	addi	s3,s0,-176
    8000606e:	6088                	ld	a0,0(s1)
    80006070:	c901                	beqz	a0,80006080 <sys_exec+0xfa>
    kfree(argv[i]);
    80006072:	ffffb097          	auipc	ra,0xffffb
    80006076:	9ea080e7          	jalr	-1558(ra) # 80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000607a:	04a1                	addi	s1,s1,8
    8000607c:	ff3499e3          	bne	s1,s3,8000606e <sys_exec+0xe8>
  return ret;
    80006080:	854a                	mv	a0,s2
    80006082:	74ba                	ld	s1,424(sp)
    80006084:	791a                	ld	s2,416(sp)
    80006086:	69fa                	ld	s3,408(sp)
    80006088:	6a5a                	ld	s4,400(sp)
    8000608a:	a031                	j	80006096 <sys_exec+0x110>
  return -1;
    8000608c:	557d                	li	a0,-1
    8000608e:	74ba                	ld	s1,424(sp)
    80006090:	791a                	ld	s2,416(sp)
    80006092:	69fa                	ld	s3,408(sp)
    80006094:	6a5a                	ld	s4,400(sp)
}
    80006096:	70fa                	ld	ra,440(sp)
    80006098:	745a                	ld	s0,432(sp)
    8000609a:	6139                	addi	sp,sp,448
    8000609c:	8082                	ret

000000008000609e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000609e:	7139                	addi	sp,sp,-64
    800060a0:	fc06                	sd	ra,56(sp)
    800060a2:	f822                	sd	s0,48(sp)
    800060a4:	f426                	sd	s1,40(sp)
    800060a6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060a8:	ffffc097          	auipc	ra,0xffffc
    800060ac:	b5e080e7          	jalr	-1186(ra) # 80001c06 <myproc>
    800060b0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800060b2:	fd840593          	addi	a1,s0,-40
    800060b6:	4501                	li	a0,0
    800060b8:	ffffd097          	auipc	ra,0xffffd
    800060bc:	e78080e7          	jalr	-392(ra) # 80002f30 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800060c0:	fc840593          	addi	a1,s0,-56
    800060c4:	fd040513          	addi	a0,s0,-48
    800060c8:	fffff097          	auipc	ra,0xfffff
    800060cc:	d50080e7          	jalr	-688(ra) # 80004e18 <pipealloc>
    return -1;
    800060d0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800060d2:	0c054463          	bltz	a0,8000619a <sys_pipe+0xfc>
  fd0 = -1;
    800060d6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800060da:	fd043503          	ld	a0,-48(s0)
    800060de:	fffff097          	auipc	ra,0xfffff
    800060e2:	4e0080e7          	jalr	1248(ra) # 800055be <fdalloc>
    800060e6:	fca42223          	sw	a0,-60(s0)
    800060ea:	08054b63          	bltz	a0,80006180 <sys_pipe+0xe2>
    800060ee:	fc843503          	ld	a0,-56(s0)
    800060f2:	fffff097          	auipc	ra,0xfffff
    800060f6:	4cc080e7          	jalr	1228(ra) # 800055be <fdalloc>
    800060fa:	fca42023          	sw	a0,-64(s0)
    800060fe:	06054863          	bltz	a0,8000616e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006102:	4691                	li	a3,4
    80006104:	fc440613          	addi	a2,s0,-60
    80006108:	fd843583          	ld	a1,-40(s0)
    8000610c:	68a8                	ld	a0,80(s1)
    8000610e:	ffffb097          	auipc	ra,0xffffb
    80006112:	69c080e7          	jalr	1692(ra) # 800017aa <copyout>
    80006116:	02054063          	bltz	a0,80006136 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000611a:	4691                	li	a3,4
    8000611c:	fc040613          	addi	a2,s0,-64
    80006120:	fd843583          	ld	a1,-40(s0)
    80006124:	0591                	addi	a1,a1,4
    80006126:	68a8                	ld	a0,80(s1)
    80006128:	ffffb097          	auipc	ra,0xffffb
    8000612c:	682080e7          	jalr	1666(ra) # 800017aa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006130:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006132:	06055463          	bgez	a0,8000619a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006136:	fc442783          	lw	a5,-60(s0)
    8000613a:	07e9                	addi	a5,a5,26
    8000613c:	078e                	slli	a5,a5,0x3
    8000613e:	97a6                	add	a5,a5,s1
    80006140:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006144:	fc042783          	lw	a5,-64(s0)
    80006148:	07e9                	addi	a5,a5,26
    8000614a:	078e                	slli	a5,a5,0x3
    8000614c:	94be                	add	s1,s1,a5
    8000614e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006152:	fd043503          	ld	a0,-48(s0)
    80006156:	fffff097          	auipc	ra,0xfffff
    8000615a:	954080e7          	jalr	-1708(ra) # 80004aaa <fileclose>
    fileclose(wf);
    8000615e:	fc843503          	ld	a0,-56(s0)
    80006162:	fffff097          	auipc	ra,0xfffff
    80006166:	948080e7          	jalr	-1720(ra) # 80004aaa <fileclose>
    return -1;
    8000616a:	57fd                	li	a5,-1
    8000616c:	a03d                	j	8000619a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000616e:	fc442783          	lw	a5,-60(s0)
    80006172:	0007c763          	bltz	a5,80006180 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006176:	07e9                	addi	a5,a5,26
    80006178:	078e                	slli	a5,a5,0x3
    8000617a:	97a6                	add	a5,a5,s1
    8000617c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006180:	fd043503          	ld	a0,-48(s0)
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	926080e7          	jalr	-1754(ra) # 80004aaa <fileclose>
    fileclose(wf);
    8000618c:	fc843503          	ld	a0,-56(s0)
    80006190:	fffff097          	auipc	ra,0xfffff
    80006194:	91a080e7          	jalr	-1766(ra) # 80004aaa <fileclose>
    return -1;
    80006198:	57fd                	li	a5,-1
}
    8000619a:	853e                	mv	a0,a5
    8000619c:	70e2                	ld	ra,56(sp)
    8000619e:	7442                	ld	s0,48(sp)
    800061a0:	74a2                	ld	s1,40(sp)
    800061a2:	6121                	addi	sp,sp,64
    800061a4:	8082                	ret
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
    800061f0:	b4ffc0ef          	jal	80002d3e <kerneltrap>
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
    80006290:	94e080e7          	jalr	-1714(ra) # 80001bda <cpuid>
  
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
    800062c8:	916080e7          	jalr	-1770(ra) # 80001bda <cpuid>
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
    800062f0:	8ee080e7          	jalr	-1810(ra) # 80001bda <cpuid>
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
    8000631c:	50878793          	addi	a5,a5,1288 # 80024820 <disk>
    80006320:	97aa                	add	a5,a5,a0
    80006322:	0187c783          	lbu	a5,24(a5)
    80006326:	ebb9                	bnez	a5,8000637c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006328:	00451693          	slli	a3,a0,0x4
    8000632c:	0001e797          	auipc	a5,0x1e
    80006330:	4f478793          	addi	a5,a5,1268 # 80024820 <disk>
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
    80006358:	4e450513          	addi	a0,a0,1252 # 80024838 <disk+0x18>
    8000635c:	ffffc097          	auipc	ra,0xffffc
    80006360:	0c0080e7          	jalr	192(ra) # 8000241c <wakeup>
}
    80006364:	60a2                	ld	ra,8(sp)
    80006366:	6402                	ld	s0,0(sp)
    80006368:	0141                	addi	sp,sp,16
    8000636a:	8082                	ret
    panic("free_desc 1");
    8000636c:	00002517          	auipc	a0,0x2
    80006370:	3d450513          	addi	a0,a0,980 # 80008740 <__func__.1+0x738>
    80006374:	ffffa097          	auipc	ra,0xffffa
    80006378:	1ec080e7          	jalr	492(ra) # 80000560 <panic>
    panic("free_desc 2");
    8000637c:	00002517          	auipc	a0,0x2
    80006380:	3d450513          	addi	a0,a0,980 # 80008750 <__func__.1+0x748>
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
    8000639c:	3c858593          	addi	a1,a1,968 # 80008760 <__func__.1+0x758>
    800063a0:	0001e517          	auipc	a0,0x1e
    800063a4:	5a850513          	addi	a0,a0,1448 # 80024948 <disk+0x128>
    800063a8:	ffffb097          	auipc	ra,0xffffb
    800063ac:	8c8080e7          	jalr	-1848(ra) # 80000c70 <initlock>
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
    80006410:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9dff>
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
    80006462:	766080e7          	jalr	1894(ra) # 80000bc4 <kalloc>
    80006466:	0001e497          	auipc	s1,0x1e
    8000646a:	3ba48493          	addi	s1,s1,954 # 80024820 <disk>
    8000646e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006470:	ffffa097          	auipc	ra,0xffffa
    80006474:	754080e7          	jalr	1876(ra) # 80000bc4 <kalloc>
    80006478:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000647a:	ffffa097          	auipc	ra,0xffffa
    8000647e:	74a080e7          	jalr	1866(ra) # 80000bc4 <kalloc>
    80006482:	87aa                	mv	a5,a0
    80006484:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006486:	6088                	ld	a0,0(s1)
    80006488:	12050063          	beqz	a0,800065a8 <virtio_disk_init+0x21c>
    8000648c:	0001e717          	auipc	a4,0x1e
    80006490:	39c73703          	ld	a4,924(a4) # 80024828 <disk+0x8>
    80006494:	10070a63          	beqz	a4,800065a8 <virtio_disk_init+0x21c>
    80006498:	10078863          	beqz	a5,800065a8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000649c:	6605                	lui	a2,0x1
    8000649e:	4581                	li	a1,0
    800064a0:	ffffb097          	auipc	ra,0xffffb
    800064a4:	95c080e7          	jalr	-1700(ra) # 80000dfc <memset>
  memset(disk.avail, 0, PGSIZE);
    800064a8:	0001e497          	auipc	s1,0x1e
    800064ac:	37848493          	addi	s1,s1,888 # 80024820 <disk>
    800064b0:	6605                	lui	a2,0x1
    800064b2:	4581                	li	a1,0
    800064b4:	6488                	ld	a0,8(s1)
    800064b6:	ffffb097          	auipc	ra,0xffffb
    800064ba:	946080e7          	jalr	-1722(ra) # 80000dfc <memset>
  memset(disk.used, 0, PGSIZE);
    800064be:	6605                	lui	a2,0x1
    800064c0:	4581                	li	a1,0
    800064c2:	6888                	ld	a0,16(s1)
    800064c4:	ffffb097          	auipc	ra,0xffffb
    800064c8:	938080e7          	jalr	-1736(ra) # 80000dfc <memset>
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
    8000655c:	21850513          	addi	a0,a0,536 # 80008770 <__func__.1+0x768>
    80006560:	ffffa097          	auipc	ra,0xffffa
    80006564:	000080e7          	jalr	ra # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006568:	00002517          	auipc	a0,0x2
    8000656c:	22850513          	addi	a0,a0,552 # 80008790 <__func__.1+0x788>
    80006570:	ffffa097          	auipc	ra,0xffffa
    80006574:	ff0080e7          	jalr	-16(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    80006578:	00002517          	auipc	a0,0x2
    8000657c:	23850513          	addi	a0,a0,568 # 800087b0 <__func__.1+0x7a8>
    80006580:	ffffa097          	auipc	ra,0xffffa
    80006584:	fe0080e7          	jalr	-32(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    80006588:	00002517          	auipc	a0,0x2
    8000658c:	24850513          	addi	a0,a0,584 # 800087d0 <__func__.1+0x7c8>
    80006590:	ffffa097          	auipc	ra,0xffffa
    80006594:	fd0080e7          	jalr	-48(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    80006598:	00002517          	auipc	a0,0x2
    8000659c:	25850513          	addi	a0,a0,600 # 800087f0 <__func__.1+0x7e8>
    800065a0:	ffffa097          	auipc	ra,0xffffa
    800065a4:	fc0080e7          	jalr	-64(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800065a8:	00002517          	auipc	a0,0x2
    800065ac:	26850513          	addi	a0,a0,616 # 80008810 <__func__.1+0x808>
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
    800065e8:	36450513          	addi	a0,a0,868 # 80024948 <disk+0x128>
    800065ec:	ffffa097          	auipc	ra,0xffffa
    800065f0:	714080e7          	jalr	1812(ra) # 80000d00 <acquire>
  for(int i = 0; i < 3; i++){
    800065f4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800065f6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800065f8:	0001eb17          	auipc	s6,0x1e
    800065fc:	228b0b13          	addi	s6,s6,552 # 80024820 <disk>
  for(int i = 0; i < 3; i++){
    80006600:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006602:	0001ec17          	auipc	s8,0x1e
    80006606:	346c0c13          	addi	s8,s8,838 # 80024948 <disk+0x128>
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
    80006628:	1fc70713          	addi	a4,a4,508 # 80024820 <disk>
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
    80006668:	1d450513          	addi	a0,a0,468 # 80024838 <disk+0x18>
    8000666c:	ffffc097          	auipc	ra,0xffffc
    80006670:	d4c080e7          	jalr	-692(ra) # 800023b8 <sleep>
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
    80006688:	19c78793          	addi	a5,a5,412 # 80024820 <disk>
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
    8000675e:	1ee90913          	addi	s2,s2,494 # 80024948 <disk+0x128>
  while(b->disk == 1) {
    80006762:	4485                	li	s1,1
    80006764:	01079c63          	bne	a5,a6,8000677c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006768:	85ca                	mv	a1,s2
    8000676a:	8552                	mv	a0,s4
    8000676c:	ffffc097          	auipc	ra,0xffffc
    80006770:	c4c080e7          	jalr	-948(ra) # 800023b8 <sleep>
  while(b->disk == 1) {
    80006774:	004a2783          	lw	a5,4(s4)
    80006778:	fe9788e3          	beq	a5,s1,80006768 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000677c:	f9042903          	lw	s2,-112(s0)
    80006780:	00290713          	addi	a4,s2,2
    80006784:	0712                	slli	a4,a4,0x4
    80006786:	0001e797          	auipc	a5,0x1e
    8000678a:	09a78793          	addi	a5,a5,154 # 80024820 <disk>
    8000678e:	97ba                	add	a5,a5,a4
    80006790:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006794:	0001e997          	auipc	s3,0x1e
    80006798:	08c98993          	addi	s3,s3,140 # 80024820 <disk>
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
    800067c0:	18c50513          	addi	a0,a0,396 # 80024948 <disk+0x128>
    800067c4:	ffffa097          	auipc	ra,0xffffa
    800067c8:	5f0080e7          	jalr	1520(ra) # 80000db4 <release>
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
    800067f4:	03048493          	addi	s1,s1,48 # 80024820 <disk>
    800067f8:	0001e517          	auipc	a0,0x1e
    800067fc:	15050513          	addi	a0,a0,336 # 80024948 <disk+0x128>
    80006800:	ffffa097          	auipc	ra,0xffffa
    80006804:	500080e7          	jalr	1280(ra) # 80000d00 <acquire>
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
    80006858:	bc8080e7          	jalr	-1080(ra) # 8000241c <wakeup>

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
    80006878:	0d450513          	addi	a0,a0,212 # 80024948 <disk+0x128>
    8000687c:	ffffa097          	auipc	ra,0xffffa
    80006880:	538080e7          	jalr	1336(ra) # 80000db4 <release>
}
    80006884:	60e2                	ld	ra,24(sp)
    80006886:	6442                	ld	s0,16(sp)
    80006888:	64a2                	ld	s1,8(sp)
    8000688a:	6105                	addi	sp,sp,32
    8000688c:	8082                	ret
      panic("virtio_disk_intr status");
    8000688e:	00002517          	auipc	a0,0x2
    80006892:	f9a50513          	addi	a0,a0,-102 # 80008828 <__func__.1+0x820>
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
