
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000e117          	auipc	sp,0xe
    80000004:	e5013103          	ld	sp,-432(sp) # 8000de50 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1a4000ef          	jal	800001ba <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <r_mhartid>:
#ifndef __ASSEMBLER__

// which hart (core) is this?
static inline uint64
r_mhartid()
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec22                	sd	s0,24(sp)
    80000020:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	fef43423          	sd	a5,-24(s0)
  return x;
    8000002a:	fe843783          	ld	a5,-24(s0)
}
    8000002e:	853e                	mv	a0,a5
    80000030:	6462                	ld	s0,24(sp)
    80000032:	6105                	addi	sp,sp,32
    80000034:	8082                	ret

0000000080000036 <r_mstatus>:
#define MSTATUS_MPP_U (0L << 11)
#define MSTATUS_MIE (1L << 3)    // machine-mode interrupt enable.

static inline uint64
r_mstatus()
{
    80000036:	1101                	addi	sp,sp,-32
    80000038:	ec22                	sd	s0,24(sp)
    8000003a:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000003c:	300027f3          	csrr	a5,mstatus
    80000040:	fef43423          	sd	a5,-24(s0)
  return x;
    80000044:	fe843783          	ld	a5,-24(s0)
}
    80000048:	853e                	mv	a0,a5
    8000004a:	6462                	ld	s0,24(sp)
    8000004c:	6105                	addi	sp,sp,32
    8000004e:	8082                	ret

0000000080000050 <w_mstatus>:

static inline void 
w_mstatus(uint64 x)
{
    80000050:	1101                	addi	sp,sp,-32
    80000052:	ec22                	sd	s0,24(sp)
    80000054:	1000                	addi	s0,sp,32
    80000056:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000005a:	fe843783          	ld	a5,-24(s0)
    8000005e:	30079073          	csrw	mstatus,a5
}
    80000062:	0001                	nop
    80000064:	6462                	ld	s0,24(sp)
    80000066:	6105                	addi	sp,sp,32
    80000068:	8082                	ret

000000008000006a <w_mepc>:
// machine exception program counter, holds the
// instruction address to which a return from
// exception will go.
static inline void 
w_mepc(uint64 x)
{
    8000006a:	1101                	addi	sp,sp,-32
    8000006c:	ec22                	sd	s0,24(sp)
    8000006e:	1000                	addi	s0,sp,32
    80000070:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000074:	fe843783          	ld	a5,-24(s0)
    80000078:	34179073          	csrw	mepc,a5
}
    8000007c:	0001                	nop
    8000007e:	6462                	ld	s0,24(sp)
    80000080:	6105                	addi	sp,sp,32
    80000082:	8082                	ret

0000000080000084 <r_sie>:
#define SIE_SEIE (1L << 9) // external
#define SIE_STIE (1L << 5) // timer
#define SIE_SSIE (1L << 1) // software
static inline uint64
r_sie()
{
    80000084:	1101                	addi	sp,sp,-32
    80000086:	ec22                	sd	s0,24(sp)
    80000088:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000008a:	104027f3          	csrr	a5,sie
    8000008e:	fef43423          	sd	a5,-24(s0)
  return x;
    80000092:	fe843783          	ld	a5,-24(s0)
}
    80000096:	853e                	mv	a0,a5
    80000098:	6462                	ld	s0,24(sp)
    8000009a:	6105                	addi	sp,sp,32
    8000009c:	8082                	ret

000000008000009e <w_sie>:

static inline void 
w_sie(uint64 x)
{
    8000009e:	1101                	addi	sp,sp,-32
    800000a0:	ec22                	sd	s0,24(sp)
    800000a2:	1000                	addi	s0,sp,32
    800000a4:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a8:	fe843783          	ld	a5,-24(s0)
    800000ac:	10479073          	csrw	sie,a5
}
    800000b0:	0001                	nop
    800000b2:	6462                	ld	s0,24(sp)
    800000b4:	6105                	addi	sp,sp,32
    800000b6:	8082                	ret

00000000800000b8 <r_mie>:
#define MIE_MEIE (1L << 11) // external
#define MIE_MTIE (1L << 7)  // timer
#define MIE_MSIE (1L << 3)  // software
static inline uint64
r_mie()
{
    800000b8:	1101                	addi	sp,sp,-32
    800000ba:	ec22                	sd	s0,24(sp)
    800000bc:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    800000be:	304027f3          	csrr	a5,mie
    800000c2:	fef43423          	sd	a5,-24(s0)
  return x;
    800000c6:	fe843783          	ld	a5,-24(s0)
}
    800000ca:	853e                	mv	a0,a5
    800000cc:	6462                	ld	s0,24(sp)
    800000ce:	6105                	addi	sp,sp,32
    800000d0:	8082                	ret

00000000800000d2 <w_mie>:

static inline void 
w_mie(uint64 x)
{
    800000d2:	1101                	addi	sp,sp,-32
    800000d4:	ec22                	sd	s0,24(sp)
    800000d6:	1000                	addi	s0,sp,32
    800000d8:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mie, %0" : : "r" (x));
    800000dc:	fe843783          	ld	a5,-24(s0)
    800000e0:	30479073          	csrw	mie,a5
}
    800000e4:	0001                	nop
    800000e6:	6462                	ld	s0,24(sp)
    800000e8:	6105                	addi	sp,sp,32
    800000ea:	8082                	ret

00000000800000ec <w_medeleg>:
  return x;
}

static inline void 
w_medeleg(uint64 x)
{
    800000ec:	1101                	addi	sp,sp,-32
    800000ee:	ec22                	sd	s0,24(sp)
    800000f0:	1000                	addi	s0,sp,32
    800000f2:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000f6:	fe843783          	ld	a5,-24(s0)
    800000fa:	30279073          	csrw	medeleg,a5
}
    800000fe:	0001                	nop
    80000100:	6462                	ld	s0,24(sp)
    80000102:	6105                	addi	sp,sp,32
    80000104:	8082                	ret

0000000080000106 <w_mideleg>:
  return x;
}

static inline void 
w_mideleg(uint64 x)
{
    80000106:	1101                	addi	sp,sp,-32
    80000108:	ec22                	sd	s0,24(sp)
    8000010a:	1000                	addi	s0,sp,32
    8000010c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80000110:	fe843783          	ld	a5,-24(s0)
    80000114:	30379073          	csrw	mideleg,a5
}
    80000118:	0001                	nop
    8000011a:	6462                	ld	s0,24(sp)
    8000011c:	6105                	addi	sp,sp,32
    8000011e:	8082                	ret

0000000080000120 <w_mtvec>:
}

// Machine-mode interrupt vector
static inline void 
w_mtvec(uint64 x)
{
    80000120:	1101                	addi	sp,sp,-32
    80000122:	ec22                	sd	s0,24(sp)
    80000124:	1000                	addi	s0,sp,32
    80000126:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000012a:	fe843783          	ld	a5,-24(s0)
    8000012e:	30579073          	csrw	mtvec,a5
}
    80000132:	0001                	nop
    80000134:	6462                	ld	s0,24(sp)
    80000136:	6105                	addi	sp,sp,32
    80000138:	8082                	ret

000000008000013a <w_pmpcfg0>:

// Physical Memory Protection
static inline void
w_pmpcfg0(uint64 x)
{
    8000013a:	1101                	addi	sp,sp,-32
    8000013c:	ec22                	sd	s0,24(sp)
    8000013e:	1000                	addi	s0,sp,32
    80000140:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000144:	fe843783          	ld	a5,-24(s0)
    80000148:	3a079073          	csrw	pmpcfg0,a5
}
    8000014c:	0001                	nop
    8000014e:	6462                	ld	s0,24(sp)
    80000150:	6105                	addi	sp,sp,32
    80000152:	8082                	ret

0000000080000154 <w_pmpaddr0>:

static inline void
w_pmpaddr0(uint64 x)
{
    80000154:	1101                	addi	sp,sp,-32
    80000156:	ec22                	sd	s0,24(sp)
    80000158:	1000                	addi	s0,sp,32
    8000015a:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000015e:	fe843783          	ld	a5,-24(s0)
    80000162:	3b079073          	csrw	pmpaddr0,a5
}
    80000166:	0001                	nop
    80000168:	6462                	ld	s0,24(sp)
    8000016a:	6105                	addi	sp,sp,32
    8000016c:	8082                	ret

000000008000016e <w_satp>:

// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
    8000016e:	1101                	addi	sp,sp,-32
    80000170:	ec22                	sd	s0,24(sp)
    80000172:	1000                	addi	s0,sp,32
    80000174:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80000178:	fe843783          	ld	a5,-24(s0)
    8000017c:	18079073          	csrw	satp,a5
}
    80000180:	0001                	nop
    80000182:	6462                	ld	s0,24(sp)
    80000184:	6105                	addi	sp,sp,32
    80000186:	8082                	ret

0000000080000188 <w_mscratch>:
  return x;
}

static inline void 
w_mscratch(uint64 x)
{
    80000188:	1101                	addi	sp,sp,-32
    8000018a:	ec22                	sd	s0,24(sp)
    8000018c:	1000                	addi	s0,sp,32
    8000018e:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000192:	fe843783          	ld	a5,-24(s0)
    80000196:	34079073          	csrw	mscratch,a5
}
    8000019a:	0001                	nop
    8000019c:	6462                	ld	s0,24(sp)
    8000019e:	6105                	addi	sp,sp,32
    800001a0:	8082                	ret

00000000800001a2 <w_tp>:
  return x;
}

static inline void 
w_tp(uint64 x)
{
    800001a2:	1101                	addi	sp,sp,-32
    800001a4:	ec22                	sd	s0,24(sp)
    800001a6:	1000                	addi	s0,sp,32
    800001a8:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    800001ac:	fe843783          	ld	a5,-24(s0)
    800001b0:	823e                	mv	tp,a5
}
    800001b2:	0001                	nop
    800001b4:	6462                	ld	s0,24(sp)
    800001b6:	6105                	addi	sp,sp,32
    800001b8:	8082                	ret

00000000800001ba <start>:
extern void timervec();

// entry.S jumps here in machine mode on stack0.
void
start()
{
    800001ba:	1101                	addi	sp,sp,-32
    800001bc:	ec06                	sd	ra,24(sp)
    800001be:	e822                	sd	s0,16(sp)
    800001c0:	1000                	addi	s0,sp,32
  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
    800001c2:	00000097          	auipc	ra,0x0
    800001c6:	e74080e7          	jalr	-396(ra) # 80000036 <r_mstatus>
    800001ca:	fea43423          	sd	a0,-24(s0)
  x &= ~MSTATUS_MPP_MASK;
    800001ce:	fe843703          	ld	a4,-24(s0)
    800001d2:	77f9                	lui	a5,0xffffe
    800001d4:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7ffd74e7>
    800001d8:	8ff9                	and	a5,a5,a4
    800001da:	fef43423          	sd	a5,-24(s0)
  x |= MSTATUS_MPP_S;
    800001de:	fe843703          	ld	a4,-24(s0)
    800001e2:	6785                	lui	a5,0x1
    800001e4:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    800001e8:	8fd9                	or	a5,a5,a4
    800001ea:	fef43423          	sd	a5,-24(s0)
  w_mstatus(x);
    800001ee:	fe843503          	ld	a0,-24(s0)
    800001f2:	00000097          	auipc	ra,0x0
    800001f6:	e5e080e7          	jalr	-418(ra) # 80000050 <w_mstatus>

  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);
    800001fa:	00001797          	auipc	a5,0x1
    800001fe:	60e78793          	addi	a5,a5,1550 # 80001808 <main>
    80000202:	853e                	mv	a0,a5
    80000204:	00000097          	auipc	ra,0x0
    80000208:	e66080e7          	jalr	-410(ra) # 8000006a <w_mepc>

  // disable paging for now.
  w_satp(0);
    8000020c:	4501                	li	a0,0
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	f60080e7          	jalr	-160(ra) # 8000016e <w_satp>

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
    80000216:	67c1                	lui	a5,0x10
    80000218:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000021c:	00000097          	auipc	ra,0x0
    80000220:	ed0080e7          	jalr	-304(ra) # 800000ec <w_medeleg>
  w_mideleg(0xffff);
    80000224:	67c1                	lui	a5,0x10
    80000226:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    8000022a:	00000097          	auipc	ra,0x0
    8000022e:	edc080e7          	jalr	-292(ra) # 80000106 <w_mideleg>
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000232:	00000097          	auipc	ra,0x0
    80000236:	e52080e7          	jalr	-430(ra) # 80000084 <r_sie>
    8000023a:	87aa                	mv	a5,a0
    8000023c:	2227e793          	ori	a5,a5,546
    80000240:	853e                	mv	a0,a5
    80000242:	00000097          	auipc	ra,0x0
    80000246:	e5c080e7          	jalr	-420(ra) # 8000009e <w_sie>

  // configure Physical Memory Protection to give supervisor mode
  // access to all of physical memory.
  w_pmpaddr0(0x3fffffffffffffull);
    8000024a:	57fd                	li	a5,-1
    8000024c:	00a7d513          	srli	a0,a5,0xa
    80000250:	00000097          	auipc	ra,0x0
    80000254:	f04080e7          	jalr	-252(ra) # 80000154 <w_pmpaddr0>
  w_pmpcfg0(0xf);
    80000258:	453d                	li	a0,15
    8000025a:	00000097          	auipc	ra,0x0
    8000025e:	ee0080e7          	jalr	-288(ra) # 8000013a <w_pmpcfg0>

  // ask for clock interrupts.
  timerinit();
    80000262:	00000097          	auipc	ra,0x0
    80000266:	032080e7          	jalr	50(ra) # 80000294 <timerinit>

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
    8000026a:	00000097          	auipc	ra,0x0
    8000026e:	db2080e7          	jalr	-590(ra) # 8000001c <r_mhartid>
    80000272:	87aa                	mv	a5,a0
    80000274:	fef42223          	sw	a5,-28(s0)
  w_tp(id);
    80000278:	fe442783          	lw	a5,-28(s0)
    8000027c:	853e                	mv	a0,a5
    8000027e:	00000097          	auipc	ra,0x0
    80000282:	f24080e7          	jalr	-220(ra) # 800001a2 <w_tp>

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    80000286:	30200073          	mret
}
    8000028a:	0001                	nop
    8000028c:	60e2                	ld	ra,24(sp)
    8000028e:	6442                	ld	s0,16(sp)
    80000290:	6105                	addi	sp,sp,32
    80000292:	8082                	ret

0000000080000294 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80000294:	1101                	addi	sp,sp,-32
    80000296:	ec06                	sd	ra,24(sp)
    80000298:	e822                	sd	s0,16(sp)
    8000029a:	1000                	addi	s0,sp,32
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	d80080e7          	jalr	-640(ra) # 8000001c <r_mhartid>
    800002a4:	87aa                	mv	a5,a0
    800002a6:	fef42623          	sw	a5,-20(s0)

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
    800002aa:	000f47b7          	lui	a5,0xf4
    800002ae:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x7ff0bdc0>
    800002b2:	fef42423          	sw	a5,-24(s0)
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800002b6:	0200c7b7          	lui	a5,0x200c
    800002ba:	17e1                	addi	a5,a5,-8 # 200bff8 <_entry-0x7dff4008>
    800002bc:	6398                	ld	a4,0(a5)
    800002be:	fe842783          	lw	a5,-24(s0)
    800002c2:	fec42683          	lw	a3,-20(s0)
    800002c6:	0036969b          	slliw	a3,a3,0x3
    800002ca:	2681                	sext.w	a3,a3
    800002cc:	8636                	mv	a2,a3
    800002ce:	020046b7          	lui	a3,0x2004
    800002d2:	96b2                	add	a3,a3,a2
    800002d4:	97ba                	add	a5,a5,a4
    800002d6:	e29c                	sd	a5,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800002d8:	fec42703          	lw	a4,-20(s0)
    800002dc:	87ba                	mv	a5,a4
    800002de:	078a                	slli	a5,a5,0x2
    800002e0:	97ba                	add	a5,a5,a4
    800002e2:	078e                	slli	a5,a5,0x3
    800002e4:	00016717          	auipc	a4,0x16
    800002e8:	bbc70713          	addi	a4,a4,-1092 # 80015ea0 <timer_scratch>
    800002ec:	97ba                	add	a5,a5,a4
    800002ee:	fef43023          	sd	a5,-32(s0)
  scratch[3] = CLINT_MTIMECMP(id);
    800002f2:	fec42783          	lw	a5,-20(s0)
    800002f6:	0037979b          	slliw	a5,a5,0x3
    800002fa:	2781                	sext.w	a5,a5
    800002fc:	873e                	mv	a4,a5
    800002fe:	020047b7          	lui	a5,0x2004
    80000302:	973e                	add	a4,a4,a5
    80000304:	fe043783          	ld	a5,-32(s0)
    80000308:	07e1                	addi	a5,a5,24 # 2004018 <_entry-0x7dffbfe8>
    8000030a:	e398                	sd	a4,0(a5)
  scratch[4] = interval;
    8000030c:	fe043783          	ld	a5,-32(s0)
    80000310:	02078793          	addi	a5,a5,32
    80000314:	fe842703          	lw	a4,-24(s0)
    80000318:	e398                	sd	a4,0(a5)
  w_mscratch((uint64)scratch);
    8000031a:	fe043783          	ld	a5,-32(s0)
    8000031e:	853e                	mv	a0,a5
    80000320:	00000097          	auipc	ra,0x0
    80000324:	e68080e7          	jalr	-408(ra) # 80000188 <w_mscratch>

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);
    80000328:	00008797          	auipc	a5,0x8
    8000032c:	5c878793          	addi	a5,a5,1480 # 800088f0 <timervec>
    80000330:	853e                	mv	a0,a5
    80000332:	00000097          	auipc	ra,0x0
    80000336:	dee080e7          	jalr	-530(ra) # 80000120 <w_mtvec>

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000033a:	00000097          	auipc	ra,0x0
    8000033e:	cfc080e7          	jalr	-772(ra) # 80000036 <r_mstatus>
    80000342:	87aa                	mv	a5,a0
    80000344:	0087e793          	ori	a5,a5,8
    80000348:	853e                	mv	a0,a5
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	d06080e7          	jalr	-762(ra) # 80000050 <w_mstatus>

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000352:	00000097          	auipc	ra,0x0
    80000356:	d66080e7          	jalr	-666(ra) # 800000b8 <r_mie>
    8000035a:	87aa                	mv	a5,a0
    8000035c:	0807e793          	ori	a5,a5,128
    80000360:	853e                	mv	a0,a5
    80000362:	00000097          	auipc	ra,0x0
    80000366:	d70080e7          	jalr	-656(ra) # 800000d2 <w_mie>
}
    8000036a:	0001                	nop
    8000036c:	60e2                	ld	ra,24(sp)
    8000036e:	6442                	ld	s0,16(sp)
    80000370:	6105                	addi	sp,sp,32
    80000372:	8082                	ret

0000000080000374 <consputc>:
// called by printf(), and to echo input characters,
// but not from write().
//
void
consputc(int c)
{
    80000374:	1101                	addi	sp,sp,-32
    80000376:	ec06                	sd	ra,24(sp)
    80000378:	e822                	sd	s0,16(sp)
    8000037a:	1000                	addi	s0,sp,32
    8000037c:	87aa                	mv	a5,a0
    8000037e:	fef42623          	sw	a5,-20(s0)
  if(c == BACKSPACE){
    80000382:	fec42783          	lw	a5,-20(s0)
    80000386:	0007871b          	sext.w	a4,a5
    8000038a:	10000793          	li	a5,256
    8000038e:	02f71363          	bne	a4,a5,800003b4 <consputc+0x40>
    // if the user typed backspace, overwrite with a space.
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000392:	4521                	li	a0,8
    80000394:	00001097          	auipc	ra,0x1
    80000398:	aba080e7          	jalr	-1350(ra) # 80000e4e <uartputc_sync>
    8000039c:	02000513          	li	a0,32
    800003a0:	00001097          	auipc	ra,0x1
    800003a4:	aae080e7          	jalr	-1362(ra) # 80000e4e <uartputc_sync>
    800003a8:	4521                	li	a0,8
    800003aa:	00001097          	auipc	ra,0x1
    800003ae:	aa4080e7          	jalr	-1372(ra) # 80000e4e <uartputc_sync>
  } else {
    uartputc_sync(c);
  }
}
    800003b2:	a801                	j	800003c2 <consputc+0x4e>
    uartputc_sync(c);
    800003b4:	fec42783          	lw	a5,-20(s0)
    800003b8:	853e                	mv	a0,a5
    800003ba:	00001097          	auipc	ra,0x1
    800003be:	a94080e7          	jalr	-1388(ra) # 80000e4e <uartputc_sync>
}
    800003c2:	0001                	nop
    800003c4:	60e2                	ld	ra,24(sp)
    800003c6:	6442                	ld	s0,16(sp)
    800003c8:	6105                	addi	sp,sp,32
    800003ca:	8082                	ret

00000000800003cc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800003cc:	7179                	addi	sp,sp,-48
    800003ce:	f406                	sd	ra,40(sp)
    800003d0:	f022                	sd	s0,32(sp)
    800003d2:	1800                	addi	s0,sp,48
    800003d4:	87aa                	mv	a5,a0
    800003d6:	fcb43823          	sd	a1,-48(s0)
    800003da:	8732                	mv	a4,a2
    800003dc:	fcf42e23          	sw	a5,-36(s0)
    800003e0:	87ba                	mv	a5,a4
    800003e2:	fcf42c23          	sw	a5,-40(s0)
  int i;

  for(i = 0; i < n; i++){
    800003e6:	fe042623          	sw	zero,-20(s0)
    800003ea:	a0a1                	j	80000432 <consolewrite+0x66>
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800003ec:	fec42703          	lw	a4,-20(s0)
    800003f0:	fd043783          	ld	a5,-48(s0)
    800003f4:	00f70633          	add	a2,a4,a5
    800003f8:	fdc42703          	lw	a4,-36(s0)
    800003fc:	feb40793          	addi	a5,s0,-21
    80000400:	4685                	li	a3,1
    80000402:	85ba                	mv	a1,a4
    80000404:	853e                	mv	a0,a5
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	2a0080e7          	jalr	672(ra) # 800036a6 <either_copyin>
    8000040e:	87aa                	mv	a5,a0
    80000410:	873e                	mv	a4,a5
    80000412:	57fd                	li	a5,-1
    80000414:	02f70963          	beq	a4,a5,80000446 <consolewrite+0x7a>
      break;
    uartputc(c);
    80000418:	feb44783          	lbu	a5,-21(s0)
    8000041c:	2781                	sext.w	a5,a5
    8000041e:	853e                	mv	a0,a5
    80000420:	00001097          	auipc	ra,0x1
    80000424:	96e080e7          	jalr	-1682(ra) # 80000d8e <uartputc>
  for(i = 0; i < n; i++){
    80000428:	fec42783          	lw	a5,-20(s0)
    8000042c:	2785                	addiw	a5,a5,1
    8000042e:	fef42623          	sw	a5,-20(s0)
    80000432:	fec42783          	lw	a5,-20(s0)
    80000436:	873e                	mv	a4,a5
    80000438:	fd842783          	lw	a5,-40(s0)
    8000043c:	2701                	sext.w	a4,a4
    8000043e:	2781                	sext.w	a5,a5
    80000440:	faf746e3          	blt	a4,a5,800003ec <consolewrite+0x20>
    80000444:	a011                	j	80000448 <consolewrite+0x7c>
      break;
    80000446:	0001                	nop
  }

  return i;
    80000448:	fec42783          	lw	a5,-20(s0)
}
    8000044c:	853e                	mv	a0,a5
    8000044e:	70a2                	ld	ra,40(sp)
    80000450:	7402                	ld	s0,32(sp)
    80000452:	6145                	addi	sp,sp,48
    80000454:	8082                	ret

0000000080000456 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000456:	7179                	addi	sp,sp,-48
    80000458:	f406                	sd	ra,40(sp)
    8000045a:	f022                	sd	s0,32(sp)
    8000045c:	1800                	addi	s0,sp,48
    8000045e:	87aa                	mv	a5,a0
    80000460:	fcb43823          	sd	a1,-48(s0)
    80000464:	8732                	mv	a4,a2
    80000466:	fcf42e23          	sw	a5,-36(s0)
    8000046a:	87ba                	mv	a5,a4
    8000046c:	fcf42c23          	sw	a5,-40(s0)
  uint target;
  int c;
  char cbuf;

  target = n;
    80000470:	fd842783          	lw	a5,-40(s0)
    80000474:	fef42623          	sw	a5,-20(s0)
  acquire(&cons.lock);
    80000478:	00016517          	auipc	a0,0x16
    8000047c:	b6850513          	addi	a0,a0,-1176 # 80015fe0 <cons>
    80000480:	00001097          	auipc	ra,0x1
    80000484:	dfe080e7          	jalr	-514(ra) # 8000127e <acquire>
  while(n > 0){
    80000488:	a23d                	j	800005b6 <consoleread+0x160>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
      if(killed(myproc())){
    8000048a:	00002097          	auipc	ra,0x2
    8000048e:	3bc080e7          	jalr	956(ra) # 80002846 <myproc>
    80000492:	87aa                	mv	a5,a0
    80000494:	853e                	mv	a0,a5
    80000496:	00003097          	auipc	ra,0x3
    8000049a:	15c080e7          	jalr	348(ra) # 800035f2 <killed>
    8000049e:	87aa                	mv	a5,a0
    800004a0:	cb99                	beqz	a5,800004b6 <consoleread+0x60>
        release(&cons.lock);
    800004a2:	00016517          	auipc	a0,0x16
    800004a6:	b3e50513          	addi	a0,a0,-1218 # 80015fe0 <cons>
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	e38080e7          	jalr	-456(ra) # 800012e2 <release>
        return -1;
    800004b2:	57fd                	li	a5,-1
    800004b4:	aa25                	j	800005ec <consoleread+0x196>
      }
      sleep(&cons.r, &cons.lock);
    800004b6:	00016597          	auipc	a1,0x16
    800004ba:	b2a58593          	addi	a1,a1,-1238 # 80015fe0 <cons>
    800004be:	00016517          	auipc	a0,0x16
    800004c2:	bba50513          	addi	a0,a0,-1094 # 80016078 <cons+0x98>
    800004c6:	00003097          	auipc	ra,0x3
    800004ca:	f42080e7          	jalr	-190(ra) # 80003408 <sleep>
    while(cons.r == cons.w){
    800004ce:	00016797          	auipc	a5,0x16
    800004d2:	b1278793          	addi	a5,a5,-1262 # 80015fe0 <cons>
    800004d6:	0987a703          	lw	a4,152(a5)
    800004da:	00016797          	auipc	a5,0x16
    800004de:	b0678793          	addi	a5,a5,-1274 # 80015fe0 <cons>
    800004e2:	09c7a783          	lw	a5,156(a5)
    800004e6:	faf702e3          	beq	a4,a5,8000048a <consoleread+0x34>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800004ea:	00016797          	auipc	a5,0x16
    800004ee:	af678793          	addi	a5,a5,-1290 # 80015fe0 <cons>
    800004f2:	0987a783          	lw	a5,152(a5)
    800004f6:	2781                	sext.w	a5,a5
    800004f8:	0017871b          	addiw	a4,a5,1
    800004fc:	0007069b          	sext.w	a3,a4
    80000500:	00016717          	auipc	a4,0x16
    80000504:	ae070713          	addi	a4,a4,-1312 # 80015fe0 <cons>
    80000508:	08d72c23          	sw	a3,152(a4)
    8000050c:	07f7f793          	andi	a5,a5,127
    80000510:	2781                	sext.w	a5,a5
    80000512:	00016717          	auipc	a4,0x16
    80000516:	ace70713          	addi	a4,a4,-1330 # 80015fe0 <cons>
    8000051a:	1782                	slli	a5,a5,0x20
    8000051c:	9381                	srli	a5,a5,0x20
    8000051e:	97ba                	add	a5,a5,a4
    80000520:	0187c783          	lbu	a5,24(a5)
    80000524:	fef42423          	sw	a5,-24(s0)

    if(c == C('D')){  // end-of-file
    80000528:	fe842783          	lw	a5,-24(s0)
    8000052c:	0007871b          	sext.w	a4,a5
    80000530:	4791                	li	a5,4
    80000532:	02f71963          	bne	a4,a5,80000564 <consoleread+0x10e>
      if(n < target){
    80000536:	fd842703          	lw	a4,-40(s0)
    8000053a:	fec42783          	lw	a5,-20(s0)
    8000053e:	2781                	sext.w	a5,a5
    80000540:	08f77163          	bgeu	a4,a5,800005c2 <consoleread+0x16c>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        cons.r--;
    80000544:	00016797          	auipc	a5,0x16
    80000548:	a9c78793          	addi	a5,a5,-1380 # 80015fe0 <cons>
    8000054c:	0987a783          	lw	a5,152(a5)
    80000550:	37fd                	addiw	a5,a5,-1
    80000552:	0007871b          	sext.w	a4,a5
    80000556:	00016797          	auipc	a5,0x16
    8000055a:	a8a78793          	addi	a5,a5,-1398 # 80015fe0 <cons>
    8000055e:	08e7ac23          	sw	a4,152(a5)
      }
      break;
    80000562:	a085                	j	800005c2 <consoleread+0x16c>
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000564:	fe842783          	lw	a5,-24(s0)
    80000568:	0ff7f793          	zext.b	a5,a5
    8000056c:	fef403a3          	sb	a5,-25(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000570:	fe740713          	addi	a4,s0,-25
    80000574:	fdc42783          	lw	a5,-36(s0)
    80000578:	4685                	li	a3,1
    8000057a:	863a                	mv	a2,a4
    8000057c:	fd043583          	ld	a1,-48(s0)
    80000580:	853e                	mv	a0,a5
    80000582:	00003097          	auipc	ra,0x3
    80000586:	0b0080e7          	jalr	176(ra) # 80003632 <either_copyout>
    8000058a:	87aa                	mv	a5,a0
    8000058c:	873e                	mv	a4,a5
    8000058e:	57fd                	li	a5,-1
    80000590:	02f70b63          	beq	a4,a5,800005c6 <consoleread+0x170>
      break;

    dst++;
    80000594:	fd043783          	ld	a5,-48(s0)
    80000598:	0785                	addi	a5,a5,1
    8000059a:	fcf43823          	sd	a5,-48(s0)
    --n;
    8000059e:	fd842783          	lw	a5,-40(s0)
    800005a2:	37fd                	addiw	a5,a5,-1
    800005a4:	fcf42c23          	sw	a5,-40(s0)

    if(c == '\n'){
    800005a8:	fe842783          	lw	a5,-24(s0)
    800005ac:	0007871b          	sext.w	a4,a5
    800005b0:	47a9                	li	a5,10
    800005b2:	00f70c63          	beq	a4,a5,800005ca <consoleread+0x174>
  while(n > 0){
    800005b6:	fd842783          	lw	a5,-40(s0)
    800005ba:	2781                	sext.w	a5,a5
    800005bc:	f0f049e3          	bgtz	a5,800004ce <consoleread+0x78>
    800005c0:	a031                	j	800005cc <consoleread+0x176>
      break;
    800005c2:	0001                	nop
    800005c4:	a021                	j	800005cc <consoleread+0x176>
      break;
    800005c6:	0001                	nop
    800005c8:	a011                	j	800005cc <consoleread+0x176>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    800005ca:	0001                	nop
    }
  }
  release(&cons.lock);
    800005cc:	00016517          	auipc	a0,0x16
    800005d0:	a1450513          	addi	a0,a0,-1516 # 80015fe0 <cons>
    800005d4:	00001097          	auipc	ra,0x1
    800005d8:	d0e080e7          	jalr	-754(ra) # 800012e2 <release>

  return target - n;
    800005dc:	fd842783          	lw	a5,-40(s0)
    800005e0:	fec42703          	lw	a4,-20(s0)
    800005e4:	40f707bb          	subw	a5,a4,a5
    800005e8:	2781                	sext.w	a5,a5
    800005ea:	2781                	sext.w	a5,a5
}
    800005ec:	853e                	mv	a0,a5
    800005ee:	70a2                	ld	ra,40(sp)
    800005f0:	7402                	ld	s0,32(sp)
    800005f2:	6145                	addi	sp,sp,48
    800005f4:	8082                	ret

00000000800005f6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800005f6:	1101                	addi	sp,sp,-32
    800005f8:	ec06                	sd	ra,24(sp)
    800005fa:	e822                	sd	s0,16(sp)
    800005fc:	1000                	addi	s0,sp,32
    800005fe:	87aa                	mv	a5,a0
    80000600:	fef42623          	sw	a5,-20(s0)
  acquire(&cons.lock);
    80000604:	00016517          	auipc	a0,0x16
    80000608:	9dc50513          	addi	a0,a0,-1572 # 80015fe0 <cons>
    8000060c:	00001097          	auipc	ra,0x1
    80000610:	c72080e7          	jalr	-910(ra) # 8000127e <acquire>

  switch(c){
    80000614:	fec42783          	lw	a5,-20(s0)
    80000618:	0007871b          	sext.w	a4,a5
    8000061c:	07f00793          	li	a5,127
    80000620:	0cf70763          	beq	a4,a5,800006ee <consoleintr+0xf8>
    80000624:	fec42783          	lw	a5,-20(s0)
    80000628:	0007871b          	sext.w	a4,a5
    8000062c:	07f00793          	li	a5,127
    80000630:	10e7c363          	blt	a5,a4,80000736 <consoleintr+0x140>
    80000634:	fec42783          	lw	a5,-20(s0)
    80000638:	0007871b          	sext.w	a4,a5
    8000063c:	47d5                	li	a5,21
    8000063e:	06f70163          	beq	a4,a5,800006a0 <consoleintr+0xaa>
    80000642:	fec42783          	lw	a5,-20(s0)
    80000646:	0007871b          	sext.w	a4,a5
    8000064a:	47d5                	li	a5,21
    8000064c:	0ee7c563          	blt	a5,a4,80000736 <consoleintr+0x140>
    80000650:	fec42783          	lw	a5,-20(s0)
    80000654:	0007871b          	sext.w	a4,a5
    80000658:	47a1                	li	a5,8
    8000065a:	08f70a63          	beq	a4,a5,800006ee <consoleintr+0xf8>
    8000065e:	fec42783          	lw	a5,-20(s0)
    80000662:	0007871b          	sext.w	a4,a5
    80000666:	47c1                	li	a5,16
    80000668:	0cf71763          	bne	a4,a5,80000736 <consoleintr+0x140>
  case C('P'):  // Print process list.
    procdump();
    8000066c:	00003097          	auipc	ra,0x3
    80000670:	0ae080e7          	jalr	174(ra) # 8000371a <procdump>
    break;
    80000674:	aad9                	j	8000084a <consoleintr+0x254>
  case C('U'):  // Kill line.
    while(cons.e != cons.w &&
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
      cons.e--;
    80000676:	00016797          	auipc	a5,0x16
    8000067a:	96a78793          	addi	a5,a5,-1686 # 80015fe0 <cons>
    8000067e:	0a07a783          	lw	a5,160(a5)
    80000682:	37fd                	addiw	a5,a5,-1
    80000684:	0007871b          	sext.w	a4,a5
    80000688:	00016797          	auipc	a5,0x16
    8000068c:	95878793          	addi	a5,a5,-1704 # 80015fe0 <cons>
    80000690:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    80000694:	10000513          	li	a0,256
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	cdc080e7          	jalr	-804(ra) # 80000374 <consputc>
    while(cons.e != cons.w &&
    800006a0:	00016797          	auipc	a5,0x16
    800006a4:	94078793          	addi	a5,a5,-1728 # 80015fe0 <cons>
    800006a8:	0a07a703          	lw	a4,160(a5)
    800006ac:	00016797          	auipc	a5,0x16
    800006b0:	93478793          	addi	a5,a5,-1740 # 80015fe0 <cons>
    800006b4:	09c7a783          	lw	a5,156(a5)
    800006b8:	18f70463          	beq	a4,a5,80000840 <consoleintr+0x24a>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800006bc:	00016797          	auipc	a5,0x16
    800006c0:	92478793          	addi	a5,a5,-1756 # 80015fe0 <cons>
    800006c4:	0a07a783          	lw	a5,160(a5)
    800006c8:	37fd                	addiw	a5,a5,-1
    800006ca:	2781                	sext.w	a5,a5
    800006cc:	07f7f793          	andi	a5,a5,127
    800006d0:	2781                	sext.w	a5,a5
    800006d2:	00016717          	auipc	a4,0x16
    800006d6:	90e70713          	addi	a4,a4,-1778 # 80015fe0 <cons>
    800006da:	1782                	slli	a5,a5,0x20
    800006dc:	9381                	srli	a5,a5,0x20
    800006de:	97ba                	add	a5,a5,a4
    800006e0:	0187c783          	lbu	a5,24(a5)
    while(cons.e != cons.w &&
    800006e4:	873e                	mv	a4,a5
    800006e6:	47a9                	li	a5,10
    800006e8:	f8f717e3          	bne	a4,a5,80000676 <consoleintr+0x80>
    }
    break;
    800006ec:	aa91                	j	80000840 <consoleintr+0x24a>
  case C('H'): // Backspace
  case '\x7f': // Delete key
    if(cons.e != cons.w){
    800006ee:	00016797          	auipc	a5,0x16
    800006f2:	8f278793          	addi	a5,a5,-1806 # 80015fe0 <cons>
    800006f6:	0a07a703          	lw	a4,160(a5)
    800006fa:	00016797          	auipc	a5,0x16
    800006fe:	8e678793          	addi	a5,a5,-1818 # 80015fe0 <cons>
    80000702:	09c7a783          	lw	a5,156(a5)
    80000706:	12f70f63          	beq	a4,a5,80000844 <consoleintr+0x24e>
      cons.e--;
    8000070a:	00016797          	auipc	a5,0x16
    8000070e:	8d678793          	addi	a5,a5,-1834 # 80015fe0 <cons>
    80000712:	0a07a783          	lw	a5,160(a5)
    80000716:	37fd                	addiw	a5,a5,-1
    80000718:	0007871b          	sext.w	a4,a5
    8000071c:	00016797          	auipc	a5,0x16
    80000720:	8c478793          	addi	a5,a5,-1852 # 80015fe0 <cons>
    80000724:	0ae7a023          	sw	a4,160(a5)
      consputc(BACKSPACE);
    80000728:	10000513          	li	a0,256
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	c48080e7          	jalr	-952(ra) # 80000374 <consputc>
    }
    break;
    80000734:	aa01                	j	80000844 <consoleintr+0x24e>
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000736:	fec42783          	lw	a5,-20(s0)
    8000073a:	2781                	sext.w	a5,a5
    8000073c:	10078663          	beqz	a5,80000848 <consoleintr+0x252>
    80000740:	00016797          	auipc	a5,0x16
    80000744:	8a078793          	addi	a5,a5,-1888 # 80015fe0 <cons>
    80000748:	0a07a703          	lw	a4,160(a5)
    8000074c:	00016797          	auipc	a5,0x16
    80000750:	89478793          	addi	a5,a5,-1900 # 80015fe0 <cons>
    80000754:	0987a783          	lw	a5,152(a5)
    80000758:	40f707bb          	subw	a5,a4,a5
    8000075c:	2781                	sext.w	a5,a5
    8000075e:	873e                	mv	a4,a5
    80000760:	07f00793          	li	a5,127
    80000764:	0ee7e263          	bltu	a5,a4,80000848 <consoleintr+0x252>
      c = (c == '\r') ? '\n' : c;
    80000768:	fec42783          	lw	a5,-20(s0)
    8000076c:	0007871b          	sext.w	a4,a5
    80000770:	47b5                	li	a5,13
    80000772:	00f70563          	beq	a4,a5,8000077c <consoleintr+0x186>
    80000776:	fec42783          	lw	a5,-20(s0)
    8000077a:	a011                	j	8000077e <consoleintr+0x188>
    8000077c:	47a9                	li	a5,10
    8000077e:	fef42623          	sw	a5,-20(s0)

      // echo back to the user.
      consputc(c);
    80000782:	fec42783          	lw	a5,-20(s0)
    80000786:	853e                	mv	a0,a5
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	bec080e7          	jalr	-1044(ra) # 80000374 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000790:	00016797          	auipc	a5,0x16
    80000794:	85078793          	addi	a5,a5,-1968 # 80015fe0 <cons>
    80000798:	0a07a783          	lw	a5,160(a5)
    8000079c:	2781                	sext.w	a5,a5
    8000079e:	0017871b          	addiw	a4,a5,1
    800007a2:	0007069b          	sext.w	a3,a4
    800007a6:	00016717          	auipc	a4,0x16
    800007aa:	83a70713          	addi	a4,a4,-1990 # 80015fe0 <cons>
    800007ae:	0ad72023          	sw	a3,160(a4)
    800007b2:	07f7f793          	andi	a5,a5,127
    800007b6:	2781                	sext.w	a5,a5
    800007b8:	fec42703          	lw	a4,-20(s0)
    800007bc:	0ff77713          	zext.b	a4,a4
    800007c0:	00016697          	auipc	a3,0x16
    800007c4:	82068693          	addi	a3,a3,-2016 # 80015fe0 <cons>
    800007c8:	1782                	slli	a5,a5,0x20
    800007ca:	9381                	srli	a5,a5,0x20
    800007cc:	97b6                	add	a5,a5,a3
    800007ce:	00e78c23          	sb	a4,24(a5)

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800007d2:	fec42783          	lw	a5,-20(s0)
    800007d6:	0007871b          	sext.w	a4,a5
    800007da:	47a9                	li	a5,10
    800007dc:	02f70d63          	beq	a4,a5,80000816 <consoleintr+0x220>
    800007e0:	fec42783          	lw	a5,-20(s0)
    800007e4:	0007871b          	sext.w	a4,a5
    800007e8:	4791                	li	a5,4
    800007ea:	02f70663          	beq	a4,a5,80000816 <consoleintr+0x220>
    800007ee:	00015797          	auipc	a5,0x15
    800007f2:	7f278793          	addi	a5,a5,2034 # 80015fe0 <cons>
    800007f6:	0a07a703          	lw	a4,160(a5)
    800007fa:	00015797          	auipc	a5,0x15
    800007fe:	7e678793          	addi	a5,a5,2022 # 80015fe0 <cons>
    80000802:	0987a783          	lw	a5,152(a5)
    80000806:	40f707bb          	subw	a5,a4,a5
    8000080a:	2781                	sext.w	a5,a5
    8000080c:	873e                	mv	a4,a5
    8000080e:	08000793          	li	a5,128
    80000812:	02f71b63          	bne	a4,a5,80000848 <consoleintr+0x252>
        // wake up consoleread() if a whole line (or end-of-file)
        // has arrived.
        cons.w = cons.e;
    80000816:	00015797          	auipc	a5,0x15
    8000081a:	7ca78793          	addi	a5,a5,1994 # 80015fe0 <cons>
    8000081e:	0a07a703          	lw	a4,160(a5)
    80000822:	00015797          	auipc	a5,0x15
    80000826:	7be78793          	addi	a5,a5,1982 # 80015fe0 <cons>
    8000082a:	08e7ae23          	sw	a4,156(a5)
        wakeup(&cons.r);
    8000082e:	00016517          	auipc	a0,0x16
    80000832:	84a50513          	addi	a0,a0,-1974 # 80016078 <cons+0x98>
    80000836:	00003097          	auipc	ra,0x3
    8000083a:	c4e080e7          	jalr	-946(ra) # 80003484 <wakeup>
      }
    }
    break;
    8000083e:	a029                	j	80000848 <consoleintr+0x252>
    break;
    80000840:	0001                	nop
    80000842:	a021                	j	8000084a <consoleintr+0x254>
    break;
    80000844:	0001                	nop
    80000846:	a011                	j	8000084a <consoleintr+0x254>
    break;
    80000848:	0001                	nop
  }
  
  release(&cons.lock);
    8000084a:	00015517          	auipc	a0,0x15
    8000084e:	79650513          	addi	a0,a0,1942 # 80015fe0 <cons>
    80000852:	00001097          	auipc	ra,0x1
    80000856:	a90080e7          	jalr	-1392(ra) # 800012e2 <release>
}
    8000085a:	0001                	nop
    8000085c:	60e2                	ld	ra,24(sp)
    8000085e:	6442                	ld	s0,16(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <consoleinit>:

void
consoleinit(void)
{
    80000864:	1141                	addi	sp,sp,-16
    80000866:	e406                	sd	ra,8(sp)
    80000868:	e022                	sd	s0,0(sp)
    8000086a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000086c:	0000a597          	auipc	a1,0xa
    80000870:	79458593          	addi	a1,a1,1940 # 8000b000 <etext>
    80000874:	00015517          	auipc	a0,0x15
    80000878:	76c50513          	addi	a0,a0,1900 # 80015fe0 <cons>
    8000087c:	00001097          	auipc	ra,0x1
    80000880:	9d2080e7          	jalr	-1582(ra) # 8000124e <initlock>

  uartinit();
    80000884:	00000097          	auipc	ra,0x0
    80000888:	490080e7          	jalr	1168(ra) # 80000d14 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000088c:	00026797          	auipc	a5,0x26
    80000890:	8f478793          	addi	a5,a5,-1804 # 80026180 <devsw>
    80000894:	00000717          	auipc	a4,0x0
    80000898:	bc270713          	addi	a4,a4,-1086 # 80000456 <consoleread>
    8000089c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000089e:	00026797          	auipc	a5,0x26
    800008a2:	8e278793          	addi	a5,a5,-1822 # 80026180 <devsw>
    800008a6:	00000717          	auipc	a4,0x0
    800008aa:	b2670713          	addi	a4,a4,-1242 # 800003cc <consolewrite>
    800008ae:	ef98                	sd	a4,24(a5)
}
    800008b0:	0001                	nop
    800008b2:	60a2                	ld	ra,8(sp)
    800008b4:	6402                	ld	s0,0(sp)
    800008b6:	0141                	addi	sp,sp,16
    800008b8:	8082                	ret

00000000800008ba <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	0080                	addi	s0,sp,64
    800008c2:	87aa                	mv	a5,a0
    800008c4:	86ae                	mv	a3,a1
    800008c6:	8732                	mv	a4,a2
    800008c8:	fcf42623          	sw	a5,-52(s0)
    800008cc:	87b6                	mv	a5,a3
    800008ce:	fcf42423          	sw	a5,-56(s0)
    800008d2:	87ba                	mv	a5,a4
    800008d4:	fcf42223          	sw	a5,-60(s0)
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800008d8:	fc442783          	lw	a5,-60(s0)
    800008dc:	2781                	sext.w	a5,a5
    800008de:	c78d                	beqz	a5,80000908 <printint+0x4e>
    800008e0:	fcc42783          	lw	a5,-52(s0)
    800008e4:	01f7d79b          	srliw	a5,a5,0x1f
    800008e8:	0ff7f793          	zext.b	a5,a5
    800008ec:	fcf42223          	sw	a5,-60(s0)
    800008f0:	fc442783          	lw	a5,-60(s0)
    800008f4:	2781                	sext.w	a5,a5
    800008f6:	cb89                	beqz	a5,80000908 <printint+0x4e>
    x = -xx;
    800008f8:	fcc42783          	lw	a5,-52(s0)
    800008fc:	40f007bb          	negw	a5,a5
    80000900:	2781                	sext.w	a5,a5
    80000902:	fef42423          	sw	a5,-24(s0)
    80000906:	a029                	j	80000910 <printint+0x56>
  else
    x = xx;
    80000908:	fcc42783          	lw	a5,-52(s0)
    8000090c:	fef42423          	sw	a5,-24(s0)

  i = 0;
    80000910:	fe042623          	sw	zero,-20(s0)
  do {
    buf[i++] = digits[x % base];
    80000914:	fc842783          	lw	a5,-56(s0)
    80000918:	fe842703          	lw	a4,-24(s0)
    8000091c:	02f777bb          	remuw	a5,a4,a5
    80000920:	0007861b          	sext.w	a2,a5
    80000924:	fec42783          	lw	a5,-20(s0)
    80000928:	0017871b          	addiw	a4,a5,1
    8000092c:	fee42623          	sw	a4,-20(s0)
    80000930:	0000d697          	auipc	a3,0xd
    80000934:	3e068693          	addi	a3,a3,992 # 8000dd10 <digits>
    80000938:	02061713          	slli	a4,a2,0x20
    8000093c:	9301                	srli	a4,a4,0x20
    8000093e:	9736                	add	a4,a4,a3
    80000940:	00074703          	lbu	a4,0(a4)
    80000944:	17c1                	addi	a5,a5,-16
    80000946:	97a2                	add	a5,a5,s0
    80000948:	fee78423          	sb	a4,-24(a5)
  } while((x /= base) != 0);
    8000094c:	fc842783          	lw	a5,-56(s0)
    80000950:	fe842703          	lw	a4,-24(s0)
    80000954:	02f757bb          	divuw	a5,a4,a5
    80000958:	fef42423          	sw	a5,-24(s0)
    8000095c:	fe842783          	lw	a5,-24(s0)
    80000960:	2781                	sext.w	a5,a5
    80000962:	fbcd                	bnez	a5,80000914 <printint+0x5a>

  if(sign)
    80000964:	fc442783          	lw	a5,-60(s0)
    80000968:	2781                	sext.w	a5,a5
    8000096a:	cb95                	beqz	a5,8000099e <printint+0xe4>
    buf[i++] = '-';
    8000096c:	fec42783          	lw	a5,-20(s0)
    80000970:	0017871b          	addiw	a4,a5,1
    80000974:	fee42623          	sw	a4,-20(s0)
    80000978:	17c1                	addi	a5,a5,-16
    8000097a:	97a2                	add	a5,a5,s0
    8000097c:	02d00713          	li	a4,45
    80000980:	fee78423          	sb	a4,-24(a5)

  while(--i >= 0)
    80000984:	a829                	j	8000099e <printint+0xe4>
    consputc(buf[i]);
    80000986:	fec42783          	lw	a5,-20(s0)
    8000098a:	17c1                	addi	a5,a5,-16
    8000098c:	97a2                	add	a5,a5,s0
    8000098e:	fe87c783          	lbu	a5,-24(a5)
    80000992:	2781                	sext.w	a5,a5
    80000994:	853e                	mv	a0,a5
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	9de080e7          	jalr	-1570(ra) # 80000374 <consputc>
  while(--i >= 0)
    8000099e:	fec42783          	lw	a5,-20(s0)
    800009a2:	37fd                	addiw	a5,a5,-1
    800009a4:	fef42623          	sw	a5,-20(s0)
    800009a8:	fec42783          	lw	a5,-20(s0)
    800009ac:	2781                	sext.w	a5,a5
    800009ae:	fc07dce3          	bgez	a5,80000986 <printint+0xcc>
}
    800009b2:	0001                	nop
    800009b4:	0001                	nop
    800009b6:	70e2                	ld	ra,56(sp)
    800009b8:	7442                	ld	s0,48(sp)
    800009ba:	6121                	addi	sp,sp,64
    800009bc:	8082                	ret

00000000800009be <printptr>:

static void
printptr(uint64 x)
{
    800009be:	7179                	addi	sp,sp,-48
    800009c0:	f406                	sd	ra,40(sp)
    800009c2:	f022                	sd	s0,32(sp)
    800009c4:	1800                	addi	s0,sp,48
    800009c6:	fca43c23          	sd	a0,-40(s0)
  int i;
  consputc('0');
    800009ca:	03000513          	li	a0,48
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	9a6080e7          	jalr	-1626(ra) # 80000374 <consputc>
  consputc('x');
    800009d6:	07800513          	li	a0,120
    800009da:	00000097          	auipc	ra,0x0
    800009de:	99a080e7          	jalr	-1638(ra) # 80000374 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800009e2:	fe042623          	sw	zero,-20(s0)
    800009e6:	a81d                	j	80000a1c <printptr+0x5e>
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800009e8:	fd843783          	ld	a5,-40(s0)
    800009ec:	93f1                	srli	a5,a5,0x3c
    800009ee:	0000d717          	auipc	a4,0xd
    800009f2:	32270713          	addi	a4,a4,802 # 8000dd10 <digits>
    800009f6:	97ba                	add	a5,a5,a4
    800009f8:	0007c783          	lbu	a5,0(a5)
    800009fc:	2781                	sext.w	a5,a5
    800009fe:	853e                	mv	a0,a5
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	974080e7          	jalr	-1676(ra) # 80000374 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000a08:	fec42783          	lw	a5,-20(s0)
    80000a0c:	2785                	addiw	a5,a5,1
    80000a0e:	fef42623          	sw	a5,-20(s0)
    80000a12:	fd843783          	ld	a5,-40(s0)
    80000a16:	0792                	slli	a5,a5,0x4
    80000a18:	fcf43c23          	sd	a5,-40(s0)
    80000a1c:	fec42783          	lw	a5,-20(s0)
    80000a20:	873e                	mv	a4,a5
    80000a22:	47bd                	li	a5,15
    80000a24:	fce7f2e3          	bgeu	a5,a4,800009e8 <printptr+0x2a>
}
    80000a28:	0001                	nop
    80000a2a:	0001                	nop
    80000a2c:	70a2                	ld	ra,40(sp)
    80000a2e:	7402                	ld	s0,32(sp)
    80000a30:	6145                	addi	sp,sp,48
    80000a32:	8082                	ret

0000000080000a34 <printf>:

// Print to the console. only understands %d, %x, %p, %s.
void
printf(char *fmt, ...)
{
    80000a34:	7119                	addi	sp,sp,-128
    80000a36:	fc06                	sd	ra,56(sp)
    80000a38:	f822                	sd	s0,48(sp)
    80000a3a:	0080                	addi	s0,sp,64
    80000a3c:	fca43423          	sd	a0,-56(s0)
    80000a40:	e40c                	sd	a1,8(s0)
    80000a42:	e810                	sd	a2,16(s0)
    80000a44:	ec14                	sd	a3,24(s0)
    80000a46:	f018                	sd	a4,32(s0)
    80000a48:	f41c                	sd	a5,40(s0)
    80000a4a:	03043823          	sd	a6,48(s0)
    80000a4e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, c, locking;
  char *s;

  locking = pr.locking;
    80000a52:	00015797          	auipc	a5,0x15
    80000a56:	63678793          	addi	a5,a5,1590 # 80016088 <pr>
    80000a5a:	4f9c                	lw	a5,24(a5)
    80000a5c:	fcf42e23          	sw	a5,-36(s0)
  if(locking)
    80000a60:	fdc42783          	lw	a5,-36(s0)
    80000a64:	2781                	sext.w	a5,a5
    80000a66:	cb89                	beqz	a5,80000a78 <printf+0x44>
    acquire(&pr.lock);
    80000a68:	00015517          	auipc	a0,0x15
    80000a6c:	62050513          	addi	a0,a0,1568 # 80016088 <pr>
    80000a70:	00001097          	auipc	ra,0x1
    80000a74:	80e080e7          	jalr	-2034(ra) # 8000127e <acquire>

  if (fmt == 0)
    80000a78:	fc843783          	ld	a5,-56(s0)
    80000a7c:	eb89                	bnez	a5,80000a8e <printf+0x5a>
    panic("null fmt");
    80000a7e:	0000a517          	auipc	a0,0xa
    80000a82:	58a50513          	addi	a0,a0,1418 # 8000b008 <etext+0x8>
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	204080e7          	jalr	516(ra) # 80000c8a <panic>

  va_start(ap, fmt);
    80000a8e:	04040793          	addi	a5,s0,64
    80000a92:	fcf43023          	sd	a5,-64(s0)
    80000a96:	fc043783          	ld	a5,-64(s0)
    80000a9a:	fc878793          	addi	a5,a5,-56
    80000a9e:	fcf43823          	sd	a5,-48(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000aa2:	fe042623          	sw	zero,-20(s0)
    80000aa6:	a24d                	j	80000c48 <printf+0x214>
    if(c != '%'){
    80000aa8:	fd842783          	lw	a5,-40(s0)
    80000aac:	0007871b          	sext.w	a4,a5
    80000ab0:	02500793          	li	a5,37
    80000ab4:	00f70a63          	beq	a4,a5,80000ac8 <printf+0x94>
      consputc(c);
    80000ab8:	fd842783          	lw	a5,-40(s0)
    80000abc:	853e                	mv	a0,a5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	8b6080e7          	jalr	-1866(ra) # 80000374 <consputc>
      continue;
    80000ac6:	aaa5                	j	80000c3e <printf+0x20a>
    }
    c = fmt[++i] & 0xff;
    80000ac8:	fec42783          	lw	a5,-20(s0)
    80000acc:	2785                	addiw	a5,a5,1
    80000ace:	fef42623          	sw	a5,-20(s0)
    80000ad2:	fec42783          	lw	a5,-20(s0)
    80000ad6:	fc843703          	ld	a4,-56(s0)
    80000ada:	97ba                	add	a5,a5,a4
    80000adc:	0007c783          	lbu	a5,0(a5)
    80000ae0:	fcf42c23          	sw	a5,-40(s0)
    if(c == 0)
    80000ae4:	fd842783          	lw	a5,-40(s0)
    80000ae8:	2781                	sext.w	a5,a5
    80000aea:	16078e63          	beqz	a5,80000c66 <printf+0x232>
      break;
    switch(c){
    80000aee:	fd842783          	lw	a5,-40(s0)
    80000af2:	0007871b          	sext.w	a4,a5
    80000af6:	07800793          	li	a5,120
    80000afa:	08f70963          	beq	a4,a5,80000b8c <printf+0x158>
    80000afe:	fd842783          	lw	a5,-40(s0)
    80000b02:	0007871b          	sext.w	a4,a5
    80000b06:	07800793          	li	a5,120
    80000b0a:	10e7cc63          	blt	a5,a4,80000c22 <printf+0x1ee>
    80000b0e:	fd842783          	lw	a5,-40(s0)
    80000b12:	0007871b          	sext.w	a4,a5
    80000b16:	07300793          	li	a5,115
    80000b1a:	0af70563          	beq	a4,a5,80000bc4 <printf+0x190>
    80000b1e:	fd842783          	lw	a5,-40(s0)
    80000b22:	0007871b          	sext.w	a4,a5
    80000b26:	07300793          	li	a5,115
    80000b2a:	0ee7cc63          	blt	a5,a4,80000c22 <printf+0x1ee>
    80000b2e:	fd842783          	lw	a5,-40(s0)
    80000b32:	0007871b          	sext.w	a4,a5
    80000b36:	07000793          	li	a5,112
    80000b3a:	06f70863          	beq	a4,a5,80000baa <printf+0x176>
    80000b3e:	fd842783          	lw	a5,-40(s0)
    80000b42:	0007871b          	sext.w	a4,a5
    80000b46:	07000793          	li	a5,112
    80000b4a:	0ce7cc63          	blt	a5,a4,80000c22 <printf+0x1ee>
    80000b4e:	fd842783          	lw	a5,-40(s0)
    80000b52:	0007871b          	sext.w	a4,a5
    80000b56:	02500793          	li	a5,37
    80000b5a:	0af70d63          	beq	a4,a5,80000c14 <printf+0x1e0>
    80000b5e:	fd842783          	lw	a5,-40(s0)
    80000b62:	0007871b          	sext.w	a4,a5
    80000b66:	06400793          	li	a5,100
    80000b6a:	0af71c63          	bne	a4,a5,80000c22 <printf+0x1ee>
    case 'd':
      printint(va_arg(ap, int), 10, 1);
    80000b6e:	fd043783          	ld	a5,-48(s0)
    80000b72:	00878713          	addi	a4,a5,8
    80000b76:	fce43823          	sd	a4,-48(s0)
    80000b7a:	439c                	lw	a5,0(a5)
    80000b7c:	4605                	li	a2,1
    80000b7e:	45a9                	li	a1,10
    80000b80:	853e                	mv	a0,a5
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	d38080e7          	jalr	-712(ra) # 800008ba <printint>
      break;
    80000b8a:	a855                	j	80000c3e <printf+0x20a>
    case 'x':
      printint(va_arg(ap, int), 16, 1);
    80000b8c:	fd043783          	ld	a5,-48(s0)
    80000b90:	00878713          	addi	a4,a5,8
    80000b94:	fce43823          	sd	a4,-48(s0)
    80000b98:	439c                	lw	a5,0(a5)
    80000b9a:	4605                	li	a2,1
    80000b9c:	45c1                	li	a1,16
    80000b9e:	853e                	mv	a0,a5
    80000ba0:	00000097          	auipc	ra,0x0
    80000ba4:	d1a080e7          	jalr	-742(ra) # 800008ba <printint>
      break;
    80000ba8:	a859                	j	80000c3e <printf+0x20a>
    case 'p':
      printptr(va_arg(ap, uint64));
    80000baa:	fd043783          	ld	a5,-48(s0)
    80000bae:	00878713          	addi	a4,a5,8
    80000bb2:	fce43823          	sd	a4,-48(s0)
    80000bb6:	639c                	ld	a5,0(a5)
    80000bb8:	853e                	mv	a0,a5
    80000bba:	00000097          	auipc	ra,0x0
    80000bbe:	e04080e7          	jalr	-508(ra) # 800009be <printptr>
      break;
    80000bc2:	a8b5                	j	80000c3e <printf+0x20a>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80000bc4:	fd043783          	ld	a5,-48(s0)
    80000bc8:	00878713          	addi	a4,a5,8
    80000bcc:	fce43823          	sd	a4,-48(s0)
    80000bd0:	639c                	ld	a5,0(a5)
    80000bd2:	fef43023          	sd	a5,-32(s0)
    80000bd6:	fe043783          	ld	a5,-32(s0)
    80000bda:	e79d                	bnez	a5,80000c08 <printf+0x1d4>
        s = "(null)";
    80000bdc:	0000a797          	auipc	a5,0xa
    80000be0:	43c78793          	addi	a5,a5,1084 # 8000b018 <etext+0x18>
    80000be4:	fef43023          	sd	a5,-32(s0)
      for(; *s; s++)
    80000be8:	a005                	j	80000c08 <printf+0x1d4>
        consputc(*s);
    80000bea:	fe043783          	ld	a5,-32(s0)
    80000bee:	0007c783          	lbu	a5,0(a5)
    80000bf2:	2781                	sext.w	a5,a5
    80000bf4:	853e                	mv	a0,a5
    80000bf6:	fffff097          	auipc	ra,0xfffff
    80000bfa:	77e080e7          	jalr	1918(ra) # 80000374 <consputc>
      for(; *s; s++)
    80000bfe:	fe043783          	ld	a5,-32(s0)
    80000c02:	0785                	addi	a5,a5,1
    80000c04:	fef43023          	sd	a5,-32(s0)
    80000c08:	fe043783          	ld	a5,-32(s0)
    80000c0c:	0007c783          	lbu	a5,0(a5)
    80000c10:	ffe9                	bnez	a5,80000bea <printf+0x1b6>
      break;
    80000c12:	a035                	j	80000c3e <printf+0x20a>
    case '%':
      consputc('%');
    80000c14:	02500513          	li	a0,37
    80000c18:	fffff097          	auipc	ra,0xfffff
    80000c1c:	75c080e7          	jalr	1884(ra) # 80000374 <consputc>
      break;
    80000c20:	a839                	j	80000c3e <printf+0x20a>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000c22:	02500513          	li	a0,37
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	74e080e7          	jalr	1870(ra) # 80000374 <consputc>
      consputc(c);
    80000c2e:	fd842783          	lw	a5,-40(s0)
    80000c32:	853e                	mv	a0,a5
    80000c34:	fffff097          	auipc	ra,0xfffff
    80000c38:	740080e7          	jalr	1856(ra) # 80000374 <consputc>
      break;
    80000c3c:	0001                	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000c3e:	fec42783          	lw	a5,-20(s0)
    80000c42:	2785                	addiw	a5,a5,1
    80000c44:	fef42623          	sw	a5,-20(s0)
    80000c48:	fec42783          	lw	a5,-20(s0)
    80000c4c:	fc843703          	ld	a4,-56(s0)
    80000c50:	97ba                	add	a5,a5,a4
    80000c52:	0007c783          	lbu	a5,0(a5)
    80000c56:	fcf42c23          	sw	a5,-40(s0)
    80000c5a:	fd842783          	lw	a5,-40(s0)
    80000c5e:	2781                	sext.w	a5,a5
    80000c60:	e40794e3          	bnez	a5,80000aa8 <printf+0x74>
    80000c64:	a011                	j	80000c68 <printf+0x234>
      break;
    80000c66:	0001                	nop
    }
  }
  va_end(ap);

  if(locking)
    80000c68:	fdc42783          	lw	a5,-36(s0)
    80000c6c:	2781                	sext.w	a5,a5
    80000c6e:	cb89                	beqz	a5,80000c80 <printf+0x24c>
    release(&pr.lock);
    80000c70:	00015517          	auipc	a0,0x15
    80000c74:	41850513          	addi	a0,a0,1048 # 80016088 <pr>
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	66a080e7          	jalr	1642(ra) # 800012e2 <release>
}
    80000c80:	0001                	nop
    80000c82:	70e2                	ld	ra,56(sp)
    80000c84:	7442                	ld	s0,48(sp)
    80000c86:	6109                	addi	sp,sp,128
    80000c88:	8082                	ret

0000000080000c8a <panic>:

void
panic(char *s)
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	1000                	addi	s0,sp,32
    80000c92:	fea43423          	sd	a0,-24(s0)
  pr.locking = 0;
    80000c96:	00015797          	auipc	a5,0x15
    80000c9a:	3f278793          	addi	a5,a5,1010 # 80016088 <pr>
    80000c9e:	0007ac23          	sw	zero,24(a5)
  printf("panic: ");
    80000ca2:	0000a517          	auipc	a0,0xa
    80000ca6:	37e50513          	addi	a0,a0,894 # 8000b020 <etext+0x20>
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	d8a080e7          	jalr	-630(ra) # 80000a34 <printf>
  printf(s);
    80000cb2:	fe843503          	ld	a0,-24(s0)
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	d7e080e7          	jalr	-642(ra) # 80000a34 <printf>
  printf("\n");
    80000cbe:	0000a517          	auipc	a0,0xa
    80000cc2:	36a50513          	addi	a0,a0,874 # 8000b028 <etext+0x28>
    80000cc6:	00000097          	auipc	ra,0x0
    80000cca:	d6e080e7          	jalr	-658(ra) # 80000a34 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000cce:	0000d797          	auipc	a5,0xd
    80000cd2:	1a278793          	addi	a5,a5,418 # 8000de70 <panicked>
    80000cd6:	4705                	li	a4,1
    80000cd8:	c398                	sw	a4,0(a5)
  for(;;)
    80000cda:	0001                	nop
    80000cdc:	bffd                	j	80000cda <panic+0x50>

0000000080000cde <printfinit>:
    ;
}

void
printfinit(void)
{
    80000cde:	1141                	addi	sp,sp,-16
    80000ce0:	e406                	sd	ra,8(sp)
    80000ce2:	e022                	sd	s0,0(sp)
    80000ce4:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000ce6:	0000a597          	auipc	a1,0xa
    80000cea:	34a58593          	addi	a1,a1,842 # 8000b030 <etext+0x30>
    80000cee:	00015517          	auipc	a0,0x15
    80000cf2:	39a50513          	addi	a0,a0,922 # 80016088 <pr>
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	558080e7          	jalr	1368(ra) # 8000124e <initlock>
  pr.locking = 1;
    80000cfe:	00015797          	auipc	a5,0x15
    80000d02:	38a78793          	addi	a5,a5,906 # 80016088 <pr>
    80000d06:	4705                	li	a4,1
    80000d08:	cf98                	sw	a4,24(a5)
}
    80000d0a:	0001                	nop
    80000d0c:	60a2                	ld	ra,8(sp)
    80000d0e:	6402                	ld	s0,0(sp)
    80000d10:	0141                	addi	sp,sp,16
    80000d12:	8082                	ret

0000000080000d14 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000d14:	1141                	addi	sp,sp,-16
    80000d16:	e406                	sd	ra,8(sp)
    80000d18:	e022                	sd	s0,0(sp)
    80000d1a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000d1c:	100007b7          	lui	a5,0x10000
    80000d20:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d22:	00078023          	sb	zero,0(a5)

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000d26:	100007b7          	lui	a5,0x10000
    80000d2a:	078d                	addi	a5,a5,3 # 10000003 <_entry-0x6ffffffd>
    80000d2c:	f8000713          	li	a4,-128
    80000d30:	00e78023          	sb	a4,0(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000d34:	100007b7          	lui	a5,0x10000
    80000d38:	470d                	li	a4,3
    80000d3a:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000d3e:	100007b7          	lui	a5,0x10000
    80000d42:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d44:	00078023          	sb	zero,0(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000d48:	100007b7          	lui	a5,0x10000
    80000d4c:	078d                	addi	a5,a5,3 # 10000003 <_entry-0x6ffffffd>
    80000d4e:	470d                	li	a4,3
    80000d50:	00e78023          	sb	a4,0(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000d54:	100007b7          	lui	a5,0x10000
    80000d58:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000d5a:	471d                	li	a4,7
    80000d5c:	00e78023          	sb	a4,0(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000d60:	100007b7          	lui	a5,0x10000
    80000d64:	0785                	addi	a5,a5,1 # 10000001 <_entry-0x6fffffff>
    80000d66:	470d                	li	a4,3
    80000d68:	00e78023          	sb	a4,0(a5)

  initlock(&uart_tx_lock, "uart");
    80000d6c:	0000a597          	auipc	a1,0xa
    80000d70:	2cc58593          	addi	a1,a1,716 # 8000b038 <etext+0x38>
    80000d74:	00015517          	auipc	a0,0x15
    80000d78:	33450513          	addi	a0,a0,820 # 800160a8 <uart_tx_lock>
    80000d7c:	00000097          	auipc	ra,0x0
    80000d80:	4d2080e7          	jalr	1234(ra) # 8000124e <initlock>
}
    80000d84:	0001                	nop
    80000d86:	60a2                	ld	ra,8(sp)
    80000d88:	6402                	ld	s0,0(sp)
    80000d8a:	0141                	addi	sp,sp,16
    80000d8c:	8082                	ret

0000000080000d8e <uartputc>:
// because it may block, it can't be called
// from interrupts; it's only suitable for use
// by write().
void
uartputc(int c)
{
    80000d8e:	1101                	addi	sp,sp,-32
    80000d90:	ec06                	sd	ra,24(sp)
    80000d92:	e822                	sd	s0,16(sp)
    80000d94:	1000                	addi	s0,sp,32
    80000d96:	87aa                	mv	a5,a0
    80000d98:	fef42623          	sw	a5,-20(s0)
  acquire(&uart_tx_lock);
    80000d9c:	00015517          	auipc	a0,0x15
    80000da0:	30c50513          	addi	a0,a0,780 # 800160a8 <uart_tx_lock>
    80000da4:	00000097          	auipc	ra,0x0
    80000da8:	4da080e7          	jalr	1242(ra) # 8000127e <acquire>

  if(panicked){
    80000dac:	0000d797          	auipc	a5,0xd
    80000db0:	0c478793          	addi	a5,a5,196 # 8000de70 <panicked>
    80000db4:	439c                	lw	a5,0(a5)
    80000db6:	2781                	sext.w	a5,a5
    80000db8:	cf99                	beqz	a5,80000dd6 <uartputc+0x48>
    for(;;)
    80000dba:	0001                	nop
    80000dbc:	bffd                	j	80000dba <uartputc+0x2c>
      ;
  }
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    // buffer is full.
    // wait for uartstart() to open up space in the buffer.
    sleep(&uart_tx_r, &uart_tx_lock);
    80000dbe:	00015597          	auipc	a1,0x15
    80000dc2:	2ea58593          	addi	a1,a1,746 # 800160a8 <uart_tx_lock>
    80000dc6:	0000d517          	auipc	a0,0xd
    80000dca:	0ba50513          	addi	a0,a0,186 # 8000de80 <uart_tx_r>
    80000dce:	00002097          	auipc	ra,0x2
    80000dd2:	63a080e7          	jalr	1594(ra) # 80003408 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000dd6:	0000d797          	auipc	a5,0xd
    80000dda:	0aa78793          	addi	a5,a5,170 # 8000de80 <uart_tx_r>
    80000dde:	639c                	ld	a5,0(a5)
    80000de0:	02078713          	addi	a4,a5,32
    80000de4:	0000d797          	auipc	a5,0xd
    80000de8:	09478793          	addi	a5,a5,148 # 8000de78 <uart_tx_w>
    80000dec:	639c                	ld	a5,0(a5)
    80000dee:	fcf708e3          	beq	a4,a5,80000dbe <uartputc+0x30>
  }
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000df2:	0000d797          	auipc	a5,0xd
    80000df6:	08678793          	addi	a5,a5,134 # 8000de78 <uart_tx_w>
    80000dfa:	639c                	ld	a5,0(a5)
    80000dfc:	8bfd                	andi	a5,a5,31
    80000dfe:	fec42703          	lw	a4,-20(s0)
    80000e02:	0ff77713          	zext.b	a4,a4
    80000e06:	00015697          	auipc	a3,0x15
    80000e0a:	2ba68693          	addi	a3,a3,698 # 800160c0 <uart_tx_buf>
    80000e0e:	97b6                	add	a5,a5,a3
    80000e10:	00e78023          	sb	a4,0(a5)
  uart_tx_w += 1;
    80000e14:	0000d797          	auipc	a5,0xd
    80000e18:	06478793          	addi	a5,a5,100 # 8000de78 <uart_tx_w>
    80000e1c:	639c                	ld	a5,0(a5)
    80000e1e:	00178713          	addi	a4,a5,1
    80000e22:	0000d797          	auipc	a5,0xd
    80000e26:	05678793          	addi	a5,a5,86 # 8000de78 <uart_tx_w>
    80000e2a:	e398                	sd	a4,0(a5)
  uartstart();
    80000e2c:	00000097          	auipc	ra,0x0
    80000e30:	086080e7          	jalr	134(ra) # 80000eb2 <uartstart>
  release(&uart_tx_lock);
    80000e34:	00015517          	auipc	a0,0x15
    80000e38:	27450513          	addi	a0,a0,628 # 800160a8 <uart_tx_lock>
    80000e3c:	00000097          	auipc	ra,0x0
    80000e40:	4a6080e7          	jalr	1190(ra) # 800012e2 <release>
}
    80000e44:	0001                	nop
    80000e46:	60e2                	ld	ra,24(sp)
    80000e48:	6442                	ld	s0,16(sp)
    80000e4a:	6105                	addi	sp,sp,32
    80000e4c:	8082                	ret

0000000080000e4e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000e4e:	1101                	addi	sp,sp,-32
    80000e50:	ec06                	sd	ra,24(sp)
    80000e52:	e822                	sd	s0,16(sp)
    80000e54:	1000                	addi	s0,sp,32
    80000e56:	87aa                	mv	a5,a0
    80000e58:	fef42623          	sw	a5,-20(s0)
  push_off();
    80000e5c:	00000097          	auipc	ra,0x0
    80000e60:	520080e7          	jalr	1312(ra) # 8000137c <push_off>

  if(panicked){
    80000e64:	0000d797          	auipc	a5,0xd
    80000e68:	00c78793          	addi	a5,a5,12 # 8000de70 <panicked>
    80000e6c:	439c                	lw	a5,0(a5)
    80000e6e:	2781                	sext.w	a5,a5
    80000e70:	c399                	beqz	a5,80000e76 <uartputc_sync+0x28>
    for(;;)
    80000e72:	0001                	nop
    80000e74:	bffd                	j	80000e72 <uartputc_sync+0x24>
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000e76:	0001                	nop
    80000e78:	100007b7          	lui	a5,0x10000
    80000e7c:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000e7e:	0007c783          	lbu	a5,0(a5)
    80000e82:	0ff7f793          	zext.b	a5,a5
    80000e86:	2781                	sext.w	a5,a5
    80000e88:	0207f793          	andi	a5,a5,32
    80000e8c:	2781                	sext.w	a5,a5
    80000e8e:	d7ed                	beqz	a5,80000e78 <uartputc_sync+0x2a>
    ;
  WriteReg(THR, c);
    80000e90:	100007b7          	lui	a5,0x10000
    80000e94:	fec42703          	lw	a4,-20(s0)
    80000e98:	0ff77713          	zext.b	a4,a4
    80000e9c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000ea0:	00000097          	auipc	ra,0x0
    80000ea4:	534080e7          	jalr	1332(ra) # 800013d4 <pop_off>
}
    80000ea8:	0001                	nop
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	6105                	addi	sp,sp,32
    80000eb0:	8082                	ret

0000000080000eb2 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void
uartstart()
{
    80000eb2:	1101                	addi	sp,sp,-32
    80000eb4:	ec06                	sd	ra,24(sp)
    80000eb6:	e822                	sd	s0,16(sp)
    80000eb8:	1000                	addi	s0,sp,32
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000eba:	0000d797          	auipc	a5,0xd
    80000ebe:	fbe78793          	addi	a5,a5,-66 # 8000de78 <uart_tx_w>
    80000ec2:	6398                	ld	a4,0(a5)
    80000ec4:	0000d797          	auipc	a5,0xd
    80000ec8:	fbc78793          	addi	a5,a5,-68 # 8000de80 <uart_tx_r>
    80000ecc:	639c                	ld	a5,0(a5)
    80000ece:	06f70a63          	beq	a4,a5,80000f42 <uartstart+0x90>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000ed2:	100007b7          	lui	a5,0x10000
    80000ed6:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000ed8:	0007c783          	lbu	a5,0(a5)
    80000edc:	0ff7f793          	zext.b	a5,a5
    80000ee0:	2781                	sext.w	a5,a5
    80000ee2:	0207f793          	andi	a5,a5,32
    80000ee6:	2781                	sext.w	a5,a5
    80000ee8:	cfb9                	beqz	a5,80000f46 <uartstart+0x94>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000eea:	0000d797          	auipc	a5,0xd
    80000eee:	f9678793          	addi	a5,a5,-106 # 8000de80 <uart_tx_r>
    80000ef2:	639c                	ld	a5,0(a5)
    80000ef4:	8bfd                	andi	a5,a5,31
    80000ef6:	00015717          	auipc	a4,0x15
    80000efa:	1ca70713          	addi	a4,a4,458 # 800160c0 <uart_tx_buf>
    80000efe:	97ba                	add	a5,a5,a4
    80000f00:	0007c783          	lbu	a5,0(a5)
    80000f04:	fef42623          	sw	a5,-20(s0)
    uart_tx_r += 1;
    80000f08:	0000d797          	auipc	a5,0xd
    80000f0c:	f7878793          	addi	a5,a5,-136 # 8000de80 <uart_tx_r>
    80000f10:	639c                	ld	a5,0(a5)
    80000f12:	00178713          	addi	a4,a5,1
    80000f16:	0000d797          	auipc	a5,0xd
    80000f1a:	f6a78793          	addi	a5,a5,-150 # 8000de80 <uart_tx_r>
    80000f1e:	e398                	sd	a4,0(a5)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000f20:	0000d517          	auipc	a0,0xd
    80000f24:	f6050513          	addi	a0,a0,-160 # 8000de80 <uart_tx_r>
    80000f28:	00002097          	auipc	ra,0x2
    80000f2c:	55c080e7          	jalr	1372(ra) # 80003484 <wakeup>
    
    WriteReg(THR, c);
    80000f30:	100007b7          	lui	a5,0x10000
    80000f34:	fec42703          	lw	a4,-20(s0)
    80000f38:	0ff77713          	zext.b	a4,a4
    80000f3c:	00e78023          	sb	a4,0(a5) # 10000000 <_entry-0x70000000>
  while(1){
    80000f40:	bfad                	j	80000eba <uartstart+0x8>
      return;
    80000f42:	0001                	nop
    80000f44:	a011                	j	80000f48 <uartstart+0x96>
      return;
    80000f46:	0001                	nop
  }
}
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	6105                	addi	sp,sp,32
    80000f4e:	8082                	ret

0000000080000f50 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000f50:	1141                	addi	sp,sp,-16
    80000f52:	e422                	sd	s0,8(sp)
    80000f54:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000f56:	100007b7          	lui	a5,0x10000
    80000f5a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000f5c:	0007c783          	lbu	a5,0(a5)
    80000f60:	0ff7f793          	zext.b	a5,a5
    80000f64:	2781                	sext.w	a5,a5
    80000f66:	8b85                	andi	a5,a5,1
    80000f68:	2781                	sext.w	a5,a5
    80000f6a:	cb89                	beqz	a5,80000f7c <uartgetc+0x2c>
    // input data is ready.
    return ReadReg(RHR);
    80000f6c:	100007b7          	lui	a5,0x10000
    80000f70:	0007c783          	lbu	a5,0(a5) # 10000000 <_entry-0x70000000>
    80000f74:	0ff7f793          	zext.b	a5,a5
    80000f78:	2781                	sext.w	a5,a5
    80000f7a:	a011                	j	80000f7e <uartgetc+0x2e>
  } else {
    return -1;
    80000f7c:	57fd                	li	a5,-1
  }
}
    80000f7e:	853e                	mv	a0,a5
    80000f80:	6422                	ld	s0,8(sp)
    80000f82:	0141                	addi	sp,sp,16
    80000f84:	8082                	ret

0000000080000f86 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000f86:	1101                	addi	sp,sp,-32
    80000f88:	ec06                	sd	ra,24(sp)
    80000f8a:	e822                	sd	s0,16(sp)
    80000f8c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    80000f8e:	00000097          	auipc	ra,0x0
    80000f92:	fc2080e7          	jalr	-62(ra) # 80000f50 <uartgetc>
    80000f96:	87aa                	mv	a5,a0
    80000f98:	fef42623          	sw	a5,-20(s0)
    if(c == -1)
    80000f9c:	fec42783          	lw	a5,-20(s0)
    80000fa0:	0007871b          	sext.w	a4,a5
    80000fa4:	57fd                	li	a5,-1
    80000fa6:	00f70a63          	beq	a4,a5,80000fba <uartintr+0x34>
      break;
    consoleintr(c);
    80000faa:	fec42783          	lw	a5,-20(s0)
    80000fae:	853e                	mv	a0,a5
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	646080e7          	jalr	1606(ra) # 800005f6 <consoleintr>
  while(1){
    80000fb8:	bfd9                	j	80000f8e <uartintr+0x8>
      break;
    80000fba:	0001                	nop
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000fbc:	00015517          	auipc	a0,0x15
    80000fc0:	0ec50513          	addi	a0,a0,236 # 800160a8 <uart_tx_lock>
    80000fc4:	00000097          	auipc	ra,0x0
    80000fc8:	2ba080e7          	jalr	698(ra) # 8000127e <acquire>
  uartstart();
    80000fcc:	00000097          	auipc	ra,0x0
    80000fd0:	ee6080e7          	jalr	-282(ra) # 80000eb2 <uartstart>
  release(&uart_tx_lock);
    80000fd4:	00015517          	auipc	a0,0x15
    80000fd8:	0d450513          	addi	a0,a0,212 # 800160a8 <uart_tx_lock>
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	306080e7          	jalr	774(ra) # 800012e2 <release>
}
    80000fe4:	0001                	nop
    80000fe6:	60e2                	ld	ra,24(sp)
    80000fe8:	6442                	ld	s0,16(sp)
    80000fea:	6105                	addi	sp,sp,32
    80000fec:	8082                	ret

0000000080000fee <kinit>:
  struct run *freelist;
} kmem;

void
kinit()
{
    80000fee:	1141                	addi	sp,sp,-16
    80000ff0:	e406                	sd	ra,8(sp)
    80000ff2:	e022                	sd	s0,0(sp)
    80000ff4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ff6:	0000a597          	auipc	a1,0xa
    80000ffa:	04a58593          	addi	a1,a1,74 # 8000b040 <etext+0x40>
    80000ffe:	00015517          	auipc	a0,0x15
    80001002:	0e250513          	addi	a0,a0,226 # 800160e0 <kmem>
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	248080e7          	jalr	584(ra) # 8000124e <initlock>
  freerange(end, (void*)PHYSTOP);
    8000100e:	47c5                	li	a5,17
    80001010:	01b79593          	slli	a1,a5,0x1b
    80001014:	00026517          	auipc	a0,0x26
    80001018:	30450513          	addi	a0,a0,772 # 80027318 <end>
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	012080e7          	jalr	18(ra) # 8000102e <freerange>
}
    80001024:	0001                	nop
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret

000000008000102e <freerange>:

void
freerange(void *pa_start, void *pa_end)
{
    8000102e:	7179                	addi	sp,sp,-48
    80001030:	f406                	sd	ra,40(sp)
    80001032:	f022                	sd	s0,32(sp)
    80001034:	1800                	addi	s0,sp,48
    80001036:	fca43c23          	sd	a0,-40(s0)
    8000103a:	fcb43823          	sd	a1,-48(s0)
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000103e:	fd843703          	ld	a4,-40(s0)
    80001042:	6785                	lui	a5,0x1
    80001044:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001046:	973e                	add	a4,a4,a5
    80001048:	77fd                	lui	a5,0xfffff
    8000104a:	8ff9                	and	a5,a5,a4
    8000104c:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80001050:	a829                	j	8000106a <freerange+0x3c>
    kfree(p);
    80001052:	fe843503          	ld	a0,-24(s0)
    80001056:	00000097          	auipc	ra,0x0
    8000105a:	030080e7          	jalr	48(ra) # 80001086 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000105e:	fe843703          	ld	a4,-24(s0)
    80001062:	6785                	lui	a5,0x1
    80001064:	97ba                	add	a5,a5,a4
    80001066:	fef43423          	sd	a5,-24(s0)
    8000106a:	fe843703          	ld	a4,-24(s0)
    8000106e:	6785                	lui	a5,0x1
    80001070:	97ba                	add	a5,a5,a4
    80001072:	fd043703          	ld	a4,-48(s0)
    80001076:	fcf77ee3          	bgeu	a4,a5,80001052 <freerange+0x24>
}
    8000107a:	0001                	nop
    8000107c:	0001                	nop
    8000107e:	70a2                	ld	ra,40(sp)
    80001080:	7402                	ld	s0,32(sp)
    80001082:	6145                	addi	sp,sp,48
    80001084:	8082                	ret

0000000080001086 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80001086:	7179                	addi	sp,sp,-48
    80001088:	f406                	sd	ra,40(sp)
    8000108a:	f022                	sd	s0,32(sp)
    8000108c:	1800                	addi	s0,sp,48
    8000108e:	fca43c23          	sd	a0,-40(s0)
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80001092:	fd843703          	ld	a4,-40(s0)
    80001096:	6785                	lui	a5,0x1
    80001098:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000109a:	8ff9                	and	a5,a5,a4
    8000109c:	ef99                	bnez	a5,800010ba <kfree+0x34>
    8000109e:	fd843703          	ld	a4,-40(s0)
    800010a2:	00026797          	auipc	a5,0x26
    800010a6:	27678793          	addi	a5,a5,630 # 80027318 <end>
    800010aa:	00f76863          	bltu	a4,a5,800010ba <kfree+0x34>
    800010ae:	fd843703          	ld	a4,-40(s0)
    800010b2:	47c5                	li	a5,17
    800010b4:	07ee                	slli	a5,a5,0x1b
    800010b6:	00f76a63          	bltu	a4,a5,800010ca <kfree+0x44>
    panic("kfree");
    800010ba:	0000a517          	auipc	a0,0xa
    800010be:	f8e50513          	addi	a0,a0,-114 # 8000b048 <etext+0x48>
    800010c2:	00000097          	auipc	ra,0x0
    800010c6:	bc8080e7          	jalr	-1080(ra) # 80000c8a <panic>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800010ca:	6605                	lui	a2,0x1
    800010cc:	4585                	li	a1,1
    800010ce:	fd843503          	ld	a0,-40(s0)
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	380080e7          	jalr	896(ra) # 80001452 <memset>

  r = (struct run*)pa;
    800010da:	fd843783          	ld	a5,-40(s0)
    800010de:	fef43423          	sd	a5,-24(s0)

  acquire(&kmem.lock);
    800010e2:	00015517          	auipc	a0,0x15
    800010e6:	ffe50513          	addi	a0,a0,-2 # 800160e0 <kmem>
    800010ea:	00000097          	auipc	ra,0x0
    800010ee:	194080e7          	jalr	404(ra) # 8000127e <acquire>
  r->next = kmem.freelist;
    800010f2:	00015797          	auipc	a5,0x15
    800010f6:	fee78793          	addi	a5,a5,-18 # 800160e0 <kmem>
    800010fa:	6f98                	ld	a4,24(a5)
    800010fc:	fe843783          	ld	a5,-24(s0)
    80001100:	e398                	sd	a4,0(a5)
  kmem.freelist = r;
    80001102:	00015797          	auipc	a5,0x15
    80001106:	fde78793          	addi	a5,a5,-34 # 800160e0 <kmem>
    8000110a:	fe843703          	ld	a4,-24(s0)
    8000110e:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    80001110:	00015517          	auipc	a0,0x15
    80001114:	fd050513          	addi	a0,a0,-48 # 800160e0 <kmem>
    80001118:	00000097          	auipc	ra,0x0
    8000111c:	1ca080e7          	jalr	458(ra) # 800012e2 <release>
}
    80001120:	0001                	nop
    80001122:	70a2                	ld	ra,40(sp)
    80001124:	7402                	ld	s0,32(sp)
    80001126:	6145                	addi	sp,sp,48
    80001128:	8082                	ret

000000008000112a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80001132:	00015517          	auipc	a0,0x15
    80001136:	fae50513          	addi	a0,a0,-82 # 800160e0 <kmem>
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	144080e7          	jalr	324(ra) # 8000127e <acquire>
  r = kmem.freelist;
    80001142:	00015797          	auipc	a5,0x15
    80001146:	f9e78793          	addi	a5,a5,-98 # 800160e0 <kmem>
    8000114a:	6f9c                	ld	a5,24(a5)
    8000114c:	fef43423          	sd	a5,-24(s0)
  if(r)
    80001150:	fe843783          	ld	a5,-24(s0)
    80001154:	cb89                	beqz	a5,80001166 <kalloc+0x3c>
    kmem.freelist = r->next;
    80001156:	fe843783          	ld	a5,-24(s0)
    8000115a:	6398                	ld	a4,0(a5)
    8000115c:	00015797          	auipc	a5,0x15
    80001160:	f8478793          	addi	a5,a5,-124 # 800160e0 <kmem>
    80001164:	ef98                	sd	a4,24(a5)
  release(&kmem.lock);
    80001166:	00015517          	auipc	a0,0x15
    8000116a:	f7a50513          	addi	a0,a0,-134 # 800160e0 <kmem>
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	174080e7          	jalr	372(ra) # 800012e2 <release>

  if(r)
    80001176:	fe843783          	ld	a5,-24(s0)
    8000117a:	cb89                	beqz	a5,8000118c <kalloc+0x62>
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000117c:	6605                	lui	a2,0x1
    8000117e:	4595                	li	a1,5
    80001180:	fe843503          	ld	a0,-24(s0)
    80001184:	00000097          	auipc	ra,0x0
    80001188:	2ce080e7          	jalr	718(ra) # 80001452 <memset>
  return (void*)r;
    8000118c:	fe843783          	ld	a5,-24(s0)
}
    80001190:	853e                	mv	a0,a5
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	6105                	addi	sp,sp,32
    80001198:	8082                	ret

000000008000119a <r_sstatus>:
{
    8000119a:	1101                	addi	sp,sp,-32
    8000119c:	ec22                	sd	s0,24(sp)
    8000119e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011a0:	100027f3          	csrr	a5,sstatus
    800011a4:	fef43423          	sd	a5,-24(s0)
  return x;
    800011a8:	fe843783          	ld	a5,-24(s0)
}
    800011ac:	853e                	mv	a0,a5
    800011ae:	6462                	ld	s0,24(sp)
    800011b0:	6105                	addi	sp,sp,32
    800011b2:	8082                	ret

00000000800011b4 <w_sstatus>:
{
    800011b4:	1101                	addi	sp,sp,-32
    800011b6:	ec22                	sd	s0,24(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011be:	fe843783          	ld	a5,-24(s0)
    800011c2:	10079073          	csrw	sstatus,a5
}
    800011c6:	0001                	nop
    800011c8:	6462                	ld	s0,24(sp)
    800011ca:	6105                	addi	sp,sp,32
    800011cc:	8082                	ret

00000000800011ce <intr_on>:
{
    800011ce:	1141                	addi	sp,sp,-16
    800011d0:	e406                	sd	ra,8(sp)
    800011d2:	e022                	sd	s0,0(sp)
    800011d4:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800011d6:	00000097          	auipc	ra,0x0
    800011da:	fc4080e7          	jalr	-60(ra) # 8000119a <r_sstatus>
    800011de:	87aa                	mv	a5,a0
    800011e0:	0027e793          	ori	a5,a5,2
    800011e4:	853e                	mv	a0,a5
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	fce080e7          	jalr	-50(ra) # 800011b4 <w_sstatus>
}
    800011ee:	0001                	nop
    800011f0:	60a2                	ld	ra,8(sp)
    800011f2:	6402                	ld	s0,0(sp)
    800011f4:	0141                	addi	sp,sp,16
    800011f6:	8082                	ret

00000000800011f8 <intr_off>:
{
    800011f8:	1141                	addi	sp,sp,-16
    800011fa:	e406                	sd	ra,8(sp)
    800011fc:	e022                	sd	s0,0(sp)
    800011fe:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001200:	00000097          	auipc	ra,0x0
    80001204:	f9a080e7          	jalr	-102(ra) # 8000119a <r_sstatus>
    80001208:	87aa                	mv	a5,a0
    8000120a:	9bf5                	andi	a5,a5,-3
    8000120c:	853e                	mv	a0,a5
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	fa6080e7          	jalr	-90(ra) # 800011b4 <w_sstatus>
}
    80001216:	0001                	nop
    80001218:	60a2                	ld	ra,8(sp)
    8000121a:	6402                	ld	s0,0(sp)
    8000121c:	0141                	addi	sp,sp,16
    8000121e:	8082                	ret

0000000080001220 <intr_get>:
{
    80001220:	1101                	addi	sp,sp,-32
    80001222:	ec06                	sd	ra,24(sp)
    80001224:	e822                	sd	s0,16(sp)
    80001226:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	f72080e7          	jalr	-142(ra) # 8000119a <r_sstatus>
    80001230:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80001234:	fe843783          	ld	a5,-24(s0)
    80001238:	8b89                	andi	a5,a5,2
    8000123a:	00f037b3          	snez	a5,a5
    8000123e:	0ff7f793          	zext.b	a5,a5
    80001242:	2781                	sext.w	a5,a5
}
    80001244:	853e                	mv	a0,a5
    80001246:	60e2                	ld	ra,24(sp)
    80001248:	6442                	ld	s0,16(sp)
    8000124a:	6105                	addi	sp,sp,32
    8000124c:	8082                	ret

000000008000124e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000124e:	1101                	addi	sp,sp,-32
    80001250:	ec22                	sd	s0,24(sp)
    80001252:	1000                	addi	s0,sp,32
    80001254:	fea43423          	sd	a0,-24(s0)
    80001258:	feb43023          	sd	a1,-32(s0)
  lk->name = name;
    8000125c:	fe843783          	ld	a5,-24(s0)
    80001260:	fe043703          	ld	a4,-32(s0)
    80001264:	e798                	sd	a4,8(a5)
  lk->locked = 0;
    80001266:	fe843783          	ld	a5,-24(s0)
    8000126a:	0007a023          	sw	zero,0(a5)
  lk->cpu = 0;
    8000126e:	fe843783          	ld	a5,-24(s0)
    80001272:	0007b823          	sd	zero,16(a5)
}
    80001276:	0001                	nop
    80001278:	6462                	ld	s0,24(sp)
    8000127a:	6105                	addi	sp,sp,32
    8000127c:	8082                	ret

000000008000127e <acquire>:

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void
acquire(struct spinlock *lk)
{
    8000127e:	1101                	addi	sp,sp,-32
    80001280:	ec06                	sd	ra,24(sp)
    80001282:	e822                	sd	s0,16(sp)
    80001284:	1000                	addi	s0,sp,32
    80001286:	fea43423          	sd	a0,-24(s0)
  push_off(); // disable interrupts to avoid deadlock.
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	0f2080e7          	jalr	242(ra) # 8000137c <push_off>
  if(holding(lk))
    80001292:	fe843503          	ld	a0,-24(s0)
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	0a2080e7          	jalr	162(ra) # 80001338 <holding>
    8000129e:	87aa                	mv	a5,a0
    800012a0:	cb89                	beqz	a5,800012b2 <acquire+0x34>
    panic("acquire");
    800012a2:	0000a517          	auipc	a0,0xa
    800012a6:	dae50513          	addi	a0,a0,-594 # 8000b050 <etext+0x50>
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	9e0080e7          	jalr	-1568(ra) # 80000c8a <panic>

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800012b2:	0001                	nop
    800012b4:	fe843783          	ld	a5,-24(s0)
    800012b8:	4705                	li	a4,1
    800012ba:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    800012be:	0007079b          	sext.w	a5,a4
    800012c2:	fbed                	bnez	a5,800012b4 <acquire+0x36>

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    800012c4:	0330000f          	fence	rw,rw

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu();
    800012c8:	00001097          	auipc	ra,0x1
    800012cc:	544080e7          	jalr	1348(ra) # 8000280c <mycpu>
    800012d0:	872a                	mv	a4,a0
    800012d2:	fe843783          	ld	a5,-24(s0)
    800012d6:	eb98                	sd	a4,16(a5)
}
    800012d8:	0001                	nop
    800012da:	60e2                	ld	ra,24(sp)
    800012dc:	6442                	ld	s0,16(sp)
    800012de:	6105                	addi	sp,sp,32
    800012e0:	8082                	ret

00000000800012e2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
    800012e2:	1101                	addi	sp,sp,-32
    800012e4:	ec06                	sd	ra,24(sp)
    800012e6:	e822                	sd	s0,16(sp)
    800012e8:	1000                	addi	s0,sp,32
    800012ea:	fea43423          	sd	a0,-24(s0)
  if(!holding(lk))
    800012ee:	fe843503          	ld	a0,-24(s0)
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	046080e7          	jalr	70(ra) # 80001338 <holding>
    800012fa:	87aa                	mv	a5,a0
    800012fc:	eb89                	bnez	a5,8000130e <release+0x2c>
    panic("release");
    800012fe:	0000a517          	auipc	a0,0xa
    80001302:	d5a50513          	addi	a0,a0,-678 # 8000b058 <etext+0x58>
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	984080e7          	jalr	-1660(ra) # 80000c8a <panic>

  lk->cpu = 0;
    8000130e:	fe843783          	ld	a5,-24(s0)
    80001312:	0007b823          	sd	zero,16(a5)
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();
    80001316:	0330000f          	fence	rw,rw
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lk->locked);
    8000131a:	fe843783          	ld	a5,-24(s0)
    8000131e:	0310000f          	fence	rw,w
    80001322:	0007a023          	sw	zero,0(a5)

  pop_off();
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	0ae080e7          	jalr	174(ra) # 800013d4 <pop_off>
}
    8000132e:	0001                	nop
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	6105                	addi	sp,sp,32
    80001336:	8082                	ret

0000000080001338 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
    80001338:	7139                	addi	sp,sp,-64
    8000133a:	fc06                	sd	ra,56(sp)
    8000133c:	f822                	sd	s0,48(sp)
    8000133e:	f426                	sd	s1,40(sp)
    80001340:	0080                	addi	s0,sp,64
    80001342:	fca43423          	sd	a0,-56(s0)
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80001346:	fc843783          	ld	a5,-56(s0)
    8000134a:	439c                	lw	a5,0(a5)
    8000134c:	cf89                	beqz	a5,80001366 <holding+0x2e>
    8000134e:	fc843783          	ld	a5,-56(s0)
    80001352:	6b84                	ld	s1,16(a5)
    80001354:	00001097          	auipc	ra,0x1
    80001358:	4b8080e7          	jalr	1208(ra) # 8000280c <mycpu>
    8000135c:	87aa                	mv	a5,a0
    8000135e:	00f49463          	bne	s1,a5,80001366 <holding+0x2e>
    80001362:	4785                	li	a5,1
    80001364:	a011                	j	80001368 <holding+0x30>
    80001366:	4781                	li	a5,0
    80001368:	fcf42e23          	sw	a5,-36(s0)
  return r;
    8000136c:	fdc42783          	lw	a5,-36(s0)
}
    80001370:	853e                	mv	a0,a5
    80001372:	70e2                	ld	ra,56(sp)
    80001374:	7442                	ld	s0,48(sp)
    80001376:	74a2                	ld	s1,40(sp)
    80001378:	6121                	addi	sp,sp,64
    8000137a:	8082                	ret

000000008000137c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000137c:	1101                	addi	sp,sp,-32
    8000137e:	ec06                	sd	ra,24(sp)
    80001380:	e822                	sd	s0,16(sp)
    80001382:	1000                	addi	s0,sp,32
  int old = intr_get();
    80001384:	00000097          	auipc	ra,0x0
    80001388:	e9c080e7          	jalr	-356(ra) # 80001220 <intr_get>
    8000138c:	87aa                	mv	a5,a0
    8000138e:	fef42623          	sw	a5,-20(s0)

  intr_off();
    80001392:	00000097          	auipc	ra,0x0
    80001396:	e66080e7          	jalr	-410(ra) # 800011f8 <intr_off>
  if(mycpu()->noff == 0)
    8000139a:	00001097          	auipc	ra,0x1
    8000139e:	472080e7          	jalr	1138(ra) # 8000280c <mycpu>
    800013a2:	87aa                	mv	a5,a0
    800013a4:	5fbc                	lw	a5,120(a5)
    800013a6:	eb89                	bnez	a5,800013b8 <push_off+0x3c>
    mycpu()->intena = old;
    800013a8:	00001097          	auipc	ra,0x1
    800013ac:	464080e7          	jalr	1124(ra) # 8000280c <mycpu>
    800013b0:	872a                	mv	a4,a0
    800013b2:	fec42783          	lw	a5,-20(s0)
    800013b6:	df7c                	sw	a5,124(a4)
  mycpu()->noff += 1;
    800013b8:	00001097          	auipc	ra,0x1
    800013bc:	454080e7          	jalr	1108(ra) # 8000280c <mycpu>
    800013c0:	87aa                	mv	a5,a0
    800013c2:	5fb8                	lw	a4,120(a5)
    800013c4:	2705                	addiw	a4,a4,1
    800013c6:	2701                	sext.w	a4,a4
    800013c8:	dfb8                	sw	a4,120(a5)
}
    800013ca:	0001                	nop
    800013cc:	60e2                	ld	ra,24(sp)
    800013ce:	6442                	ld	s0,16(sp)
    800013d0:	6105                	addi	sp,sp,32
    800013d2:	8082                	ret

00000000800013d4 <pop_off>:

void
pop_off(void)
{
    800013d4:	1101                	addi	sp,sp,-32
    800013d6:	ec06                	sd	ra,24(sp)
    800013d8:	e822                	sd	s0,16(sp)
    800013da:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    800013dc:	00001097          	auipc	ra,0x1
    800013e0:	430080e7          	jalr	1072(ra) # 8000280c <mycpu>
    800013e4:	fea43423          	sd	a0,-24(s0)
  if(intr_get())
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	e38080e7          	jalr	-456(ra) # 80001220 <intr_get>
    800013f0:	87aa                	mv	a5,a0
    800013f2:	cb89                	beqz	a5,80001404 <pop_off+0x30>
    panic("pop_off - interruptible");
    800013f4:	0000a517          	auipc	a0,0xa
    800013f8:	c6c50513          	addi	a0,a0,-916 # 8000b060 <etext+0x60>
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	88e080e7          	jalr	-1906(ra) # 80000c8a <panic>
  if(c->noff < 1)
    80001404:	fe843783          	ld	a5,-24(s0)
    80001408:	5fbc                	lw	a5,120(a5)
    8000140a:	00f04a63          	bgtz	a5,8000141e <pop_off+0x4a>
    panic("pop_off");
    8000140e:	0000a517          	auipc	a0,0xa
    80001412:	c6a50513          	addi	a0,a0,-918 # 8000b078 <etext+0x78>
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	874080e7          	jalr	-1932(ra) # 80000c8a <panic>
  c->noff -= 1;
    8000141e:	fe843783          	ld	a5,-24(s0)
    80001422:	5fbc                	lw	a5,120(a5)
    80001424:	37fd                	addiw	a5,a5,-1
    80001426:	0007871b          	sext.w	a4,a5
    8000142a:	fe843783          	ld	a5,-24(s0)
    8000142e:	dfb8                	sw	a4,120(a5)
  if(c->noff == 0 && c->intena)
    80001430:	fe843783          	ld	a5,-24(s0)
    80001434:	5fbc                	lw	a5,120(a5)
    80001436:	eb89                	bnez	a5,80001448 <pop_off+0x74>
    80001438:	fe843783          	ld	a5,-24(s0)
    8000143c:	5ffc                	lw	a5,124(a5)
    8000143e:	c789                	beqz	a5,80001448 <pop_off+0x74>
    intr_on();
    80001440:	00000097          	auipc	ra,0x0
    80001444:	d8e080e7          	jalr	-626(ra) # 800011ce <intr_on>
}
    80001448:	0001                	nop
    8000144a:	60e2                	ld	ra,24(sp)
    8000144c:	6442                	ld	s0,16(sp)
    8000144e:	6105                	addi	sp,sp,32
    80001450:	8082                	ret

0000000080001452 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80001452:	7179                	addi	sp,sp,-48
    80001454:	f422                	sd	s0,40(sp)
    80001456:	1800                	addi	s0,sp,48
    80001458:	fca43c23          	sd	a0,-40(s0)
    8000145c:	87ae                	mv	a5,a1
    8000145e:	8732                	mv	a4,a2
    80001460:	fcf42a23          	sw	a5,-44(s0)
    80001464:	87ba                	mv	a5,a4
    80001466:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    8000146a:	fd843783          	ld	a5,-40(s0)
    8000146e:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    80001472:	fe042623          	sw	zero,-20(s0)
    80001476:	a00d                	j	80001498 <memset+0x46>
    cdst[i] = c;
    80001478:	fec42783          	lw	a5,-20(s0)
    8000147c:	fe043703          	ld	a4,-32(s0)
    80001480:	97ba                	add	a5,a5,a4
    80001482:	fd442703          	lw	a4,-44(s0)
    80001486:	0ff77713          	zext.b	a4,a4
    8000148a:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    8000148e:	fec42783          	lw	a5,-20(s0)
    80001492:	2785                	addiw	a5,a5,1
    80001494:	fef42623          	sw	a5,-20(s0)
    80001498:	fec42703          	lw	a4,-20(s0)
    8000149c:	fd042783          	lw	a5,-48(s0)
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	fcf76be3          	bltu	a4,a5,80001478 <memset+0x26>
  }
  return dst;
    800014a6:	fd843783          	ld	a5,-40(s0)
}
    800014aa:	853e                	mv	a0,a5
    800014ac:	7422                	ld	s0,40(sp)
    800014ae:	6145                	addi	sp,sp,48
    800014b0:	8082                	ret

00000000800014b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800014b2:	7139                	addi	sp,sp,-64
    800014b4:	fc22                	sd	s0,56(sp)
    800014b6:	0080                	addi	s0,sp,64
    800014b8:	fca43c23          	sd	a0,-40(s0)
    800014bc:	fcb43823          	sd	a1,-48(s0)
    800014c0:	87b2                	mv	a5,a2
    800014c2:	fcf42623          	sw	a5,-52(s0)
  const uchar *s1, *s2;

  s1 = v1;
    800014c6:	fd843783          	ld	a5,-40(s0)
    800014ca:	fef43423          	sd	a5,-24(s0)
  s2 = v2;
    800014ce:	fd043783          	ld	a5,-48(s0)
    800014d2:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    800014d6:	a0a1                	j	8000151e <memcmp+0x6c>
    if(*s1 != *s2)
    800014d8:	fe843783          	ld	a5,-24(s0)
    800014dc:	0007c703          	lbu	a4,0(a5)
    800014e0:	fe043783          	ld	a5,-32(s0)
    800014e4:	0007c783          	lbu	a5,0(a5)
    800014e8:	02f70163          	beq	a4,a5,8000150a <memcmp+0x58>
      return *s1 - *s2;
    800014ec:	fe843783          	ld	a5,-24(s0)
    800014f0:	0007c783          	lbu	a5,0(a5)
    800014f4:	0007871b          	sext.w	a4,a5
    800014f8:	fe043783          	ld	a5,-32(s0)
    800014fc:	0007c783          	lbu	a5,0(a5)
    80001500:	2781                	sext.w	a5,a5
    80001502:	40f707bb          	subw	a5,a4,a5
    80001506:	2781                	sext.w	a5,a5
    80001508:	a01d                	j	8000152e <memcmp+0x7c>
    s1++, s2++;
    8000150a:	fe843783          	ld	a5,-24(s0)
    8000150e:	0785                	addi	a5,a5,1
    80001510:	fef43423          	sd	a5,-24(s0)
    80001514:	fe043783          	ld	a5,-32(s0)
    80001518:	0785                	addi	a5,a5,1
    8000151a:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    8000151e:	fcc42783          	lw	a5,-52(s0)
    80001522:	fff7871b          	addiw	a4,a5,-1
    80001526:	fce42623          	sw	a4,-52(s0)
    8000152a:	f7dd                	bnez	a5,800014d8 <memcmp+0x26>
  }

  return 0;
    8000152c:	4781                	li	a5,0
}
    8000152e:	853e                	mv	a0,a5
    80001530:	7462                	ld	s0,56(sp)
    80001532:	6121                	addi	sp,sp,64
    80001534:	8082                	ret

0000000080001536 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80001536:	7139                	addi	sp,sp,-64
    80001538:	fc22                	sd	s0,56(sp)
    8000153a:	0080                	addi	s0,sp,64
    8000153c:	fca43c23          	sd	a0,-40(s0)
    80001540:	fcb43823          	sd	a1,-48(s0)
    80001544:	87b2                	mv	a5,a2
    80001546:	fcf42623          	sw	a5,-52(s0)
  const char *s;
  char *d;

  if(n == 0)
    8000154a:	fcc42783          	lw	a5,-52(s0)
    8000154e:	2781                	sext.w	a5,a5
    80001550:	e781                	bnez	a5,80001558 <memmove+0x22>
    return dst;
    80001552:	fd843783          	ld	a5,-40(s0)
    80001556:	a855                	j	8000160a <memmove+0xd4>
  
  s = src;
    80001558:	fd043783          	ld	a5,-48(s0)
    8000155c:	fef43423          	sd	a5,-24(s0)
  d = dst;
    80001560:	fd843783          	ld	a5,-40(s0)
    80001564:	fef43023          	sd	a5,-32(s0)
  if(s < d && s + n > d){
    80001568:	fe843703          	ld	a4,-24(s0)
    8000156c:	fe043783          	ld	a5,-32(s0)
    80001570:	08f77463          	bgeu	a4,a5,800015f8 <memmove+0xc2>
    80001574:	fcc46783          	lwu	a5,-52(s0)
    80001578:	fe843703          	ld	a4,-24(s0)
    8000157c:	97ba                	add	a5,a5,a4
    8000157e:	fe043703          	ld	a4,-32(s0)
    80001582:	06f77b63          	bgeu	a4,a5,800015f8 <memmove+0xc2>
    s += n;
    80001586:	fcc46783          	lwu	a5,-52(s0)
    8000158a:	fe843703          	ld	a4,-24(s0)
    8000158e:	97ba                	add	a5,a5,a4
    80001590:	fef43423          	sd	a5,-24(s0)
    d += n;
    80001594:	fcc46783          	lwu	a5,-52(s0)
    80001598:	fe043703          	ld	a4,-32(s0)
    8000159c:	97ba                	add	a5,a5,a4
    8000159e:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    800015a2:	a01d                	j	800015c8 <memmove+0x92>
      *--d = *--s;
    800015a4:	fe843783          	ld	a5,-24(s0)
    800015a8:	17fd                	addi	a5,a5,-1
    800015aa:	fef43423          	sd	a5,-24(s0)
    800015ae:	fe043783          	ld	a5,-32(s0)
    800015b2:	17fd                	addi	a5,a5,-1
    800015b4:	fef43023          	sd	a5,-32(s0)
    800015b8:	fe843783          	ld	a5,-24(s0)
    800015bc:	0007c703          	lbu	a4,0(a5)
    800015c0:	fe043783          	ld	a5,-32(s0)
    800015c4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    800015c8:	fcc42783          	lw	a5,-52(s0)
    800015cc:	fff7871b          	addiw	a4,a5,-1
    800015d0:	fce42623          	sw	a4,-52(s0)
    800015d4:	fbe1                	bnez	a5,800015a4 <memmove+0x6e>
  if(s < d && s + n > d){
    800015d6:	a805                	j	80001606 <memmove+0xd0>
  } else
    while(n-- > 0)
      *d++ = *s++;
    800015d8:	fe843703          	ld	a4,-24(s0)
    800015dc:	00170793          	addi	a5,a4,1
    800015e0:	fef43423          	sd	a5,-24(s0)
    800015e4:	fe043783          	ld	a5,-32(s0)
    800015e8:	00178693          	addi	a3,a5,1
    800015ec:	fed43023          	sd	a3,-32(s0)
    800015f0:	00074703          	lbu	a4,0(a4)
    800015f4:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    800015f8:	fcc42783          	lw	a5,-52(s0)
    800015fc:	fff7871b          	addiw	a4,a5,-1
    80001600:	fce42623          	sw	a4,-52(s0)
    80001604:	fbf1                	bnez	a5,800015d8 <memmove+0xa2>

  return dst;
    80001606:	fd843783          	ld	a5,-40(s0)
}
    8000160a:	853e                	mv	a0,a5
    8000160c:	7462                	ld	s0,56(sp)
    8000160e:	6121                	addi	sp,sp,64
    80001610:	8082                	ret

0000000080001612 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001612:	7179                	addi	sp,sp,-48
    80001614:	f406                	sd	ra,40(sp)
    80001616:	f022                	sd	s0,32(sp)
    80001618:	1800                	addi	s0,sp,48
    8000161a:	fea43423          	sd	a0,-24(s0)
    8000161e:	feb43023          	sd	a1,-32(s0)
    80001622:	87b2                	mv	a5,a2
    80001624:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    80001628:	fdc42783          	lw	a5,-36(s0)
    8000162c:	863e                	mv	a2,a5
    8000162e:	fe043583          	ld	a1,-32(s0)
    80001632:	fe843503          	ld	a0,-24(s0)
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	f00080e7          	jalr	-256(ra) # 80001536 <memmove>
    8000163e:	87aa                	mv	a5,a0
}
    80001640:	853e                	mv	a0,a5
    80001642:	70a2                	ld	ra,40(sp)
    80001644:	7402                	ld	s0,32(sp)
    80001646:	6145                	addi	sp,sp,48
    80001648:	8082                	ret

000000008000164a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000164a:	7179                	addi	sp,sp,-48
    8000164c:	f422                	sd	s0,40(sp)
    8000164e:	1800                	addi	s0,sp,48
    80001650:	fea43423          	sd	a0,-24(s0)
    80001654:	feb43023          	sd	a1,-32(s0)
    80001658:	87b2                	mv	a5,a2
    8000165a:	fcf42e23          	sw	a5,-36(s0)
  while(n > 0 && *p && *p == *q)
    8000165e:	a005                	j	8000167e <strncmp+0x34>
    n--, p++, q++;
    80001660:	fdc42783          	lw	a5,-36(s0)
    80001664:	37fd                	addiw	a5,a5,-1
    80001666:	fcf42e23          	sw	a5,-36(s0)
    8000166a:	fe843783          	ld	a5,-24(s0)
    8000166e:	0785                	addi	a5,a5,1
    80001670:	fef43423          	sd	a5,-24(s0)
    80001674:	fe043783          	ld	a5,-32(s0)
    80001678:	0785                	addi	a5,a5,1
    8000167a:	fef43023          	sd	a5,-32(s0)
  while(n > 0 && *p && *p == *q)
    8000167e:	fdc42783          	lw	a5,-36(s0)
    80001682:	2781                	sext.w	a5,a5
    80001684:	c385                	beqz	a5,800016a4 <strncmp+0x5a>
    80001686:	fe843783          	ld	a5,-24(s0)
    8000168a:	0007c783          	lbu	a5,0(a5)
    8000168e:	cb99                	beqz	a5,800016a4 <strncmp+0x5a>
    80001690:	fe843783          	ld	a5,-24(s0)
    80001694:	0007c703          	lbu	a4,0(a5)
    80001698:	fe043783          	ld	a5,-32(s0)
    8000169c:	0007c783          	lbu	a5,0(a5)
    800016a0:	fcf700e3          	beq	a4,a5,80001660 <strncmp+0x16>
  if(n == 0)
    800016a4:	fdc42783          	lw	a5,-36(s0)
    800016a8:	2781                	sext.w	a5,a5
    800016aa:	e399                	bnez	a5,800016b0 <strncmp+0x66>
    return 0;
    800016ac:	4781                	li	a5,0
    800016ae:	a839                	j	800016cc <strncmp+0x82>
  return (uchar)*p - (uchar)*q;
    800016b0:	fe843783          	ld	a5,-24(s0)
    800016b4:	0007c783          	lbu	a5,0(a5)
    800016b8:	0007871b          	sext.w	a4,a5
    800016bc:	fe043783          	ld	a5,-32(s0)
    800016c0:	0007c783          	lbu	a5,0(a5)
    800016c4:	2781                	sext.w	a5,a5
    800016c6:	40f707bb          	subw	a5,a4,a5
    800016ca:	2781                	sext.w	a5,a5
}
    800016cc:	853e                	mv	a0,a5
    800016ce:	7422                	ld	s0,40(sp)
    800016d0:	6145                	addi	sp,sp,48
    800016d2:	8082                	ret

00000000800016d4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800016d4:	7139                	addi	sp,sp,-64
    800016d6:	fc22                	sd	s0,56(sp)
    800016d8:	0080                	addi	s0,sp,64
    800016da:	fca43c23          	sd	a0,-40(s0)
    800016de:	fcb43823          	sd	a1,-48(s0)
    800016e2:	87b2                	mv	a5,a2
    800016e4:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    800016e8:	fd843783          	ld	a5,-40(s0)
    800016ec:	fef43423          	sd	a5,-24(s0)
  while(n-- > 0 && (*s++ = *t++) != 0)
    800016f0:	0001                	nop
    800016f2:	fcc42783          	lw	a5,-52(s0)
    800016f6:	fff7871b          	addiw	a4,a5,-1
    800016fa:	fce42623          	sw	a4,-52(s0)
    800016fe:	02f05e63          	blez	a5,8000173a <strncpy+0x66>
    80001702:	fd043703          	ld	a4,-48(s0)
    80001706:	00170793          	addi	a5,a4,1
    8000170a:	fcf43823          	sd	a5,-48(s0)
    8000170e:	fd843783          	ld	a5,-40(s0)
    80001712:	00178693          	addi	a3,a5,1
    80001716:	fcd43c23          	sd	a3,-40(s0)
    8000171a:	00074703          	lbu	a4,0(a4)
    8000171e:	00e78023          	sb	a4,0(a5)
    80001722:	0007c783          	lbu	a5,0(a5)
    80001726:	f7f1                	bnez	a5,800016f2 <strncpy+0x1e>
    ;
  while(n-- > 0)
    80001728:	a809                	j	8000173a <strncpy+0x66>
    *s++ = 0;
    8000172a:	fd843783          	ld	a5,-40(s0)
    8000172e:	00178713          	addi	a4,a5,1
    80001732:	fce43c23          	sd	a4,-40(s0)
    80001736:	00078023          	sb	zero,0(a5)
  while(n-- > 0)
    8000173a:	fcc42783          	lw	a5,-52(s0)
    8000173e:	fff7871b          	addiw	a4,a5,-1
    80001742:	fce42623          	sw	a4,-52(s0)
    80001746:	fef042e3          	bgtz	a5,8000172a <strncpy+0x56>
  return os;
    8000174a:	fe843783          	ld	a5,-24(s0)
}
    8000174e:	853e                	mv	a0,a5
    80001750:	7462                	ld	s0,56(sp)
    80001752:	6121                	addi	sp,sp,64
    80001754:	8082                	ret

0000000080001756 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001756:	7139                	addi	sp,sp,-64
    80001758:	fc22                	sd	s0,56(sp)
    8000175a:	0080                	addi	s0,sp,64
    8000175c:	fca43c23          	sd	a0,-40(s0)
    80001760:	fcb43823          	sd	a1,-48(s0)
    80001764:	87b2                	mv	a5,a2
    80001766:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    8000176a:	fd843783          	ld	a5,-40(s0)
    8000176e:	fef43423          	sd	a5,-24(s0)
  if(n <= 0)
    80001772:	fcc42783          	lw	a5,-52(s0)
    80001776:	2781                	sext.w	a5,a5
    80001778:	00f04563          	bgtz	a5,80001782 <safestrcpy+0x2c>
    return os;
    8000177c:	fe843783          	ld	a5,-24(s0)
    80001780:	a0a9                	j	800017ca <safestrcpy+0x74>
  while(--n > 0 && (*s++ = *t++) != 0)
    80001782:	0001                	nop
    80001784:	fcc42783          	lw	a5,-52(s0)
    80001788:	37fd                	addiw	a5,a5,-1
    8000178a:	fcf42623          	sw	a5,-52(s0)
    8000178e:	fcc42783          	lw	a5,-52(s0)
    80001792:	2781                	sext.w	a5,a5
    80001794:	02f05563          	blez	a5,800017be <safestrcpy+0x68>
    80001798:	fd043703          	ld	a4,-48(s0)
    8000179c:	00170793          	addi	a5,a4,1
    800017a0:	fcf43823          	sd	a5,-48(s0)
    800017a4:	fd843783          	ld	a5,-40(s0)
    800017a8:	00178693          	addi	a3,a5,1
    800017ac:	fcd43c23          	sd	a3,-40(s0)
    800017b0:	00074703          	lbu	a4,0(a4)
    800017b4:	00e78023          	sb	a4,0(a5)
    800017b8:	0007c783          	lbu	a5,0(a5)
    800017bc:	f7e1                	bnez	a5,80001784 <safestrcpy+0x2e>
    ;
  *s = 0;
    800017be:	fd843783          	ld	a5,-40(s0)
    800017c2:	00078023          	sb	zero,0(a5)
  return os;
    800017c6:	fe843783          	ld	a5,-24(s0)
}
    800017ca:	853e                	mv	a0,a5
    800017cc:	7462                	ld	s0,56(sp)
    800017ce:	6121                	addi	sp,sp,64
    800017d0:	8082                	ret

00000000800017d2 <strlen>:

int
strlen(const char *s)
{
    800017d2:	7179                	addi	sp,sp,-48
    800017d4:	f422                	sd	s0,40(sp)
    800017d6:	1800                	addi	s0,sp,48
    800017d8:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    800017dc:	fe042623          	sw	zero,-20(s0)
    800017e0:	a031                	j	800017ec <strlen+0x1a>
    800017e2:	fec42783          	lw	a5,-20(s0)
    800017e6:	2785                	addiw	a5,a5,1
    800017e8:	fef42623          	sw	a5,-20(s0)
    800017ec:	fec42783          	lw	a5,-20(s0)
    800017f0:	fd843703          	ld	a4,-40(s0)
    800017f4:	97ba                	add	a5,a5,a4
    800017f6:	0007c783          	lbu	a5,0(a5)
    800017fa:	f7e5                	bnez	a5,800017e2 <strlen+0x10>
    ;
  return n;
    800017fc:	fec42783          	lw	a5,-20(s0)
}
    80001800:	853e                	mv	a0,a5
    80001802:	7422                	ld	s0,40(sp)
    80001804:	6145                	addi	sp,sp,48
    80001806:	8082                	ret

0000000080001808 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001808:	1141                	addi	sp,sp,-16
    8000180a:	e406                	sd	ra,8(sp)
    8000180c:	e022                	sd	s0,0(sp)
    8000180e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001810:	00001097          	auipc	ra,0x1
    80001814:	fd8080e7          	jalr	-40(ra) # 800027e8 <cpuid>
    80001818:	87aa                	mv	a5,a0
    8000181a:	efd5                	bnez	a5,800018d6 <main+0xce>
    consoleinit();
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	048080e7          	jalr	72(ra) # 80000864 <consoleinit>
    printfinit();
    80001824:	fffff097          	auipc	ra,0xfffff
    80001828:	4ba080e7          	jalr	1210(ra) # 80000cde <printfinit>
    printf("\n");
    8000182c:	0000a517          	auipc	a0,0xa
    80001830:	85450513          	addi	a0,a0,-1964 # 8000b080 <etext+0x80>
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	200080e7          	jalr	512(ra) # 80000a34 <printf>
    printf("xv6 kernel is booting\n");
    8000183c:	0000a517          	auipc	a0,0xa
    80001840:	84c50513          	addi	a0,a0,-1972 # 8000b088 <etext+0x88>
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	1f0080e7          	jalr	496(ra) # 80000a34 <printf>
    printf("\n");
    8000184c:	0000a517          	auipc	a0,0xa
    80001850:	83450513          	addi	a0,a0,-1996 # 8000b080 <etext+0x80>
    80001854:	fffff097          	auipc	ra,0xfffff
    80001858:	1e0080e7          	jalr	480(ra) # 80000a34 <printf>
    kinit();         // physical page allocator
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	792080e7          	jalr	1938(ra) # 80000fee <kinit>
    kvminit();       // create kernel page table
    80001864:	00000097          	auipc	ra,0x0
    80001868:	1f4080e7          	jalr	500(ra) # 80001a58 <kvminit>
    kvminithart();   // turn on paging
    8000186c:	00000097          	auipc	ra,0x0
    80001870:	212080e7          	jalr	530(ra) # 80001a7e <kvminithart>
    procinit();      // process table
    80001874:	00001097          	auipc	ra,0x1
    80001878:	ea6080e7          	jalr	-346(ra) # 8000271a <procinit>
    trapinit();      // trap vectors
    8000187c:	00002097          	auipc	ra,0x2
    80001880:	248080e7          	jalr	584(ra) # 80003ac4 <trapinit>
    trapinithart();  // install kernel trap vector
    80001884:	00002097          	auipc	ra,0x2
    80001888:	26a080e7          	jalr	618(ra) # 80003aee <trapinithart>
    plicinit();      // set up interrupt controller
    8000188c:	00007097          	auipc	ra,0x7
    80001890:	08e080e7          	jalr	142(ra) # 8000891a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001894:	00007097          	auipc	ra,0x7
    80001898:	0aa080e7          	jalr	170(ra) # 8000893e <plicinithart>
    binit();         // buffer cache
    8000189c:	00003097          	auipc	ra,0x3
    800018a0:	c62080e7          	jalr	-926(ra) # 800044fe <binit>
    iinit();         // inode table
    800018a4:	00003097          	auipc	ra,0x3
    800018a8:	498080e7          	jalr	1176(ra) # 80004d3c <iinit>
    fileinit();      // file table
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	e76080e7          	jalr	-394(ra) # 80006722 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800018b4:	00007097          	auipc	ra,0x7
    800018b8:	15e080e7          	jalr	350(ra) # 80008a12 <virtio_disk_init>
    userinit();      // first user process
    800018bc:	00001097          	auipc	ra,0x1
    800018c0:	30a080e7          	jalr	778(ra) # 80002bc6 <userinit>
    __sync_synchronize();
    800018c4:	0330000f          	fence	rw,rw
    started = 1;
    800018c8:	00015797          	auipc	a5,0x15
    800018cc:	83878793          	addi	a5,a5,-1992 # 80016100 <started>
    800018d0:	4705                	li	a4,1
    800018d2:	c398                	sw	a4,0(a5)
    800018d4:	a0a9                	j	8000191e <main+0x116>
  } else {
    while(started == 0)
    800018d6:	0001                	nop
    800018d8:	00015797          	auipc	a5,0x15
    800018dc:	82878793          	addi	a5,a5,-2008 # 80016100 <started>
    800018e0:	439c                	lw	a5,0(a5)
    800018e2:	2781                	sext.w	a5,a5
    800018e4:	dbf5                	beqz	a5,800018d8 <main+0xd0>
      ;
    __sync_synchronize();
    800018e6:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800018ea:	00001097          	auipc	ra,0x1
    800018ee:	efe080e7          	jalr	-258(ra) # 800027e8 <cpuid>
    800018f2:	87aa                	mv	a5,a0
    800018f4:	85be                	mv	a1,a5
    800018f6:	00009517          	auipc	a0,0x9
    800018fa:	7aa50513          	addi	a0,a0,1962 # 8000b0a0 <etext+0xa0>
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	136080e7          	jalr	310(ra) # 80000a34 <printf>
    kvminithart();    // turn on paging
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	178080e7          	jalr	376(ra) # 80001a7e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000190e:	00002097          	auipc	ra,0x2
    80001912:	1e0080e7          	jalr	480(ra) # 80003aee <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001916:	00007097          	auipc	ra,0x7
    8000191a:	028080e7          	jalr	40(ra) # 8000893e <plicinithart>
  }

  scheduler();        
    8000191e:	00002097          	auipc	ra,0x2
    80001922:	8be080e7          	jalr	-1858(ra) # 800031dc <scheduler>

0000000080001926 <w_satp>:
{
    80001926:	1101                	addi	sp,sp,-32
    80001928:	ec22                	sd	s0,24(sp)
    8000192a:	1000                	addi	s0,sp,32
    8000192c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw satp, %0" : : "r" (x));
    80001930:	fe843783          	ld	a5,-24(s0)
    80001934:	18079073          	csrw	satp,a5
}
    80001938:	0001                	nop
    8000193a:	6462                	ld	s0,24(sp)
    8000193c:	6105                	addi	sp,sp,32
    8000193e:	8082                	ret

0000000080001940 <sfence_vma>:
}

// flush the TLB.
static inline void
sfence_vma()
{
    80001940:	1141                	addi	sp,sp,-16
    80001942:	e422                	sd	s0,8(sp)
    80001944:	0800                	addi	s0,sp,16
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001946:	12000073          	sfence.vma
}
    8000194a:	0001                	nop
    8000194c:	6422                	ld	s0,8(sp)
    8000194e:	0141                	addi	sp,sp,16
    80001950:	8082                	ret

0000000080001952 <kvmmake>:
extern char trampoline[]; // trampoline.S

// Make a direct-map page table for the kernel.
pagetable_t
kvmmake(void)
{
    80001952:	1101                	addi	sp,sp,-32
    80001954:	ec06                	sd	ra,24(sp)
    80001956:	e822                	sd	s0,16(sp)
    80001958:	1000                	addi	s0,sp,32
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t) kalloc();
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	7d0080e7          	jalr	2000(ra) # 8000112a <kalloc>
    80001962:	fea43423          	sd	a0,-24(s0)
  memset(kpgtbl, 0, PGSIZE);
    80001966:	6605                	lui	a2,0x1
    80001968:	4581                	li	a1,0
    8000196a:	fe843503          	ld	a0,-24(s0)
    8000196e:	00000097          	auipc	ra,0x0
    80001972:	ae4080e7          	jalr	-1308(ra) # 80001452 <memset>

  // uart registers
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001976:	4719                	li	a4,6
    80001978:	6685                	lui	a3,0x1
    8000197a:	10000637          	lui	a2,0x10000
    8000197e:	100005b7          	lui	a1,0x10000
    80001982:	fe843503          	ld	a0,-24(s0)
    80001986:	00000097          	auipc	ra,0x0
    8000198a:	2a2080e7          	jalr	674(ra) # 80001c28 <kvmmap>

  // virtio mmio disk interface
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000198e:	4719                	li	a4,6
    80001990:	6685                	lui	a3,0x1
    80001992:	10001637          	lui	a2,0x10001
    80001996:	100015b7          	lui	a1,0x10001
    8000199a:	fe843503          	ld	a0,-24(s0)
    8000199e:	00000097          	auipc	ra,0x0
    800019a2:	28a080e7          	jalr	650(ra) # 80001c28 <kvmmap>

  // PLIC
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800019a6:	4719                	li	a4,6
    800019a8:	004006b7          	lui	a3,0x400
    800019ac:	0c000637          	lui	a2,0xc000
    800019b0:	0c0005b7          	lui	a1,0xc000
    800019b4:	fe843503          	ld	a0,-24(s0)
    800019b8:	00000097          	auipc	ra,0x0
    800019bc:	270080e7          	jalr	624(ra) # 80001c28 <kvmmap>

  // map kernel text executable and read-only.
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800019c0:	00009717          	auipc	a4,0x9
    800019c4:	64070713          	addi	a4,a4,1600 # 8000b000 <etext>
    800019c8:	800007b7          	lui	a5,0x80000
    800019cc:	97ba                	add	a5,a5,a4
    800019ce:	4729                	li	a4,10
    800019d0:	86be                	mv	a3,a5
    800019d2:	4785                	li	a5,1
    800019d4:	01f79613          	slli	a2,a5,0x1f
    800019d8:	4785                	li	a5,1
    800019da:	01f79593          	slli	a1,a5,0x1f
    800019de:	fe843503          	ld	a0,-24(s0)
    800019e2:	00000097          	auipc	ra,0x0
    800019e6:	246080e7          	jalr	582(ra) # 80001c28 <kvmmap>

  // map kernel data and the physical RAM we'll make use of.
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800019ea:	00009597          	auipc	a1,0x9
    800019ee:	61658593          	addi	a1,a1,1558 # 8000b000 <etext>
    800019f2:	00009617          	auipc	a2,0x9
    800019f6:	60e60613          	addi	a2,a2,1550 # 8000b000 <etext>
    800019fa:	00009797          	auipc	a5,0x9
    800019fe:	60678793          	addi	a5,a5,1542 # 8000b000 <etext>
    80001a02:	4745                	li	a4,17
    80001a04:	076e                	slli	a4,a4,0x1b
    80001a06:	40f707b3          	sub	a5,a4,a5
    80001a0a:	4719                	li	a4,6
    80001a0c:	86be                	mv	a3,a5
    80001a0e:	fe843503          	ld	a0,-24(s0)
    80001a12:	00000097          	auipc	ra,0x0
    80001a16:	216080e7          	jalr	534(ra) # 80001c28 <kvmmap>

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001a1a:	00008797          	auipc	a5,0x8
    80001a1e:	5e678793          	addi	a5,a5,1510 # 8000a000 <_trampoline>
    80001a22:	4729                	li	a4,10
    80001a24:	6685                	lui	a3,0x1
    80001a26:	863e                	mv	a2,a5
    80001a28:	040007b7          	lui	a5,0x4000
    80001a2c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001a2e:	00c79593          	slli	a1,a5,0xc
    80001a32:	fe843503          	ld	a0,-24(s0)
    80001a36:	00000097          	auipc	ra,0x0
    80001a3a:	1f2080e7          	jalr	498(ra) # 80001c28 <kvmmap>

  // allocate and map a kernel stack for each process.
  proc_mapstacks(kpgtbl);
    80001a3e:	fe843503          	ld	a0,-24(s0)
    80001a42:	00001097          	auipc	ra,0x1
    80001a46:	c1c080e7          	jalr	-996(ra) # 8000265e <proc_mapstacks>
  
  return kpgtbl;
    80001a4a:	fe843783          	ld	a5,-24(s0)
}
    80001a4e:	853e                	mv	a0,a5
    80001a50:	60e2                	ld	ra,24(sp)
    80001a52:	6442                	ld	s0,16(sp)
    80001a54:	6105                	addi	sp,sp,32
    80001a56:	8082                	ret

0000000080001a58 <kvminit>:

// Initialize the one kernel_pagetable
void
kvminit(void)
{
    80001a58:	1141                	addi	sp,sp,-16
    80001a5a:	e406                	sd	ra,8(sp)
    80001a5c:	e022                	sd	s0,0(sp)
    80001a5e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	ef2080e7          	jalr	-270(ra) # 80001952 <kvmmake>
    80001a68:	872a                	mv	a4,a0
    80001a6a:	0000c797          	auipc	a5,0xc
    80001a6e:	41e78793          	addi	a5,a5,1054 # 8000de88 <kernel_pagetable>
    80001a72:	e398                	sd	a4,0(a5)
}
    80001a74:	0001                	nop
    80001a76:	60a2                	ld	ra,8(sp)
    80001a78:	6402                	ld	s0,0(sp)
    80001a7a:	0141                	addi	sp,sp,16
    80001a7c:	8082                	ret

0000000080001a7e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001a7e:	1141                	addi	sp,sp,-16
    80001a80:	e406                	sd	ra,8(sp)
    80001a82:	e022                	sd	s0,0(sp)
    80001a84:	0800                	addi	s0,sp,16
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();
    80001a86:	00000097          	auipc	ra,0x0
    80001a8a:	eba080e7          	jalr	-326(ra) # 80001940 <sfence_vma>

  w_satp(MAKE_SATP(kernel_pagetable));
    80001a8e:	0000c797          	auipc	a5,0xc
    80001a92:	3fa78793          	addi	a5,a5,1018 # 8000de88 <kernel_pagetable>
    80001a96:	639c                	ld	a5,0(a5)
    80001a98:	00c7d713          	srli	a4,a5,0xc
    80001a9c:	57fd                	li	a5,-1
    80001a9e:	17fe                	slli	a5,a5,0x3f
    80001aa0:	8fd9                	or	a5,a5,a4
    80001aa2:	853e                	mv	a0,a5
    80001aa4:	00000097          	auipc	ra,0x0
    80001aa8:	e82080e7          	jalr	-382(ra) # 80001926 <w_satp>

  // flush stale entries from the TLB.
  sfence_vma();
    80001aac:	00000097          	auipc	ra,0x0
    80001ab0:	e94080e7          	jalr	-364(ra) # 80001940 <sfence_vma>
}
    80001ab4:	0001                	nop
    80001ab6:	60a2                	ld	ra,8(sp)
    80001ab8:	6402                	ld	s0,0(sp)
    80001aba:	0141                	addi	sp,sp,16
    80001abc:	8082                	ret

0000000080001abe <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001abe:	7139                	addi	sp,sp,-64
    80001ac0:	fc06                	sd	ra,56(sp)
    80001ac2:	f822                	sd	s0,48(sp)
    80001ac4:	0080                	addi	s0,sp,64
    80001ac6:	fca43c23          	sd	a0,-40(s0)
    80001aca:	fcb43823          	sd	a1,-48(s0)
    80001ace:	87b2                	mv	a5,a2
    80001ad0:	fcf42623          	sw	a5,-52(s0)
  if(va >= MAXVA)
    80001ad4:	fd043703          	ld	a4,-48(s0)
    80001ad8:	57fd                	li	a5,-1
    80001ada:	83e9                	srli	a5,a5,0x1a
    80001adc:	00e7fa63          	bgeu	a5,a4,80001af0 <walk+0x32>
    panic("walk");
    80001ae0:	00009517          	auipc	a0,0x9
    80001ae4:	5d850513          	addi	a0,a0,1496 # 8000b0b8 <etext+0xb8>
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	1a2080e7          	jalr	418(ra) # 80000c8a <panic>

  for(int level = 2; level > 0; level--) {
    80001af0:	4789                	li	a5,2
    80001af2:	fef42623          	sw	a5,-20(s0)
    80001af6:	a851                	j	80001b8a <walk+0xcc>
    pte_t *pte = &pagetable[PX(level, va)];
    80001af8:	fec42783          	lw	a5,-20(s0)
    80001afc:	873e                	mv	a4,a5
    80001afe:	87ba                	mv	a5,a4
    80001b00:	0037979b          	slliw	a5,a5,0x3
    80001b04:	9fb9                	addw	a5,a5,a4
    80001b06:	2781                	sext.w	a5,a5
    80001b08:	27b1                	addiw	a5,a5,12
    80001b0a:	2781                	sext.w	a5,a5
    80001b0c:	873e                	mv	a4,a5
    80001b0e:	fd043783          	ld	a5,-48(s0)
    80001b12:	00e7d7b3          	srl	a5,a5,a4
    80001b16:	1ff7f793          	andi	a5,a5,511
    80001b1a:	078e                	slli	a5,a5,0x3
    80001b1c:	fd843703          	ld	a4,-40(s0)
    80001b20:	97ba                	add	a5,a5,a4
    80001b22:	fef43023          	sd	a5,-32(s0)
    if(*pte & PTE_V) {
    80001b26:	fe043783          	ld	a5,-32(s0)
    80001b2a:	639c                	ld	a5,0(a5)
    80001b2c:	8b85                	andi	a5,a5,1
    80001b2e:	cb89                	beqz	a5,80001b40 <walk+0x82>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001b30:	fe043783          	ld	a5,-32(s0)
    80001b34:	639c                	ld	a5,0(a5)
    80001b36:	83a9                	srli	a5,a5,0xa
    80001b38:	07b2                	slli	a5,a5,0xc
    80001b3a:	fcf43c23          	sd	a5,-40(s0)
    80001b3e:	a089                	j	80001b80 <walk+0xc2>
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001b40:	fcc42783          	lw	a5,-52(s0)
    80001b44:	2781                	sext.w	a5,a5
    80001b46:	cb91                	beqz	a5,80001b5a <walk+0x9c>
    80001b48:	fffff097          	auipc	ra,0xfffff
    80001b4c:	5e2080e7          	jalr	1506(ra) # 8000112a <kalloc>
    80001b50:	fca43c23          	sd	a0,-40(s0)
    80001b54:	fd843783          	ld	a5,-40(s0)
    80001b58:	e399                	bnez	a5,80001b5e <walk+0xa0>
        return 0;
    80001b5a:	4781                	li	a5,0
    80001b5c:	a0a9                	j	80001ba6 <walk+0xe8>
      memset(pagetable, 0, PGSIZE);
    80001b5e:	6605                	lui	a2,0x1
    80001b60:	4581                	li	a1,0
    80001b62:	fd843503          	ld	a0,-40(s0)
    80001b66:	00000097          	auipc	ra,0x0
    80001b6a:	8ec080e7          	jalr	-1812(ra) # 80001452 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001b6e:	fd843783          	ld	a5,-40(s0)
    80001b72:	83b1                	srli	a5,a5,0xc
    80001b74:	07aa                	slli	a5,a5,0xa
    80001b76:	0017e713          	ori	a4,a5,1
    80001b7a:	fe043783          	ld	a5,-32(s0)
    80001b7e:	e398                	sd	a4,0(a5)
  for(int level = 2; level > 0; level--) {
    80001b80:	fec42783          	lw	a5,-20(s0)
    80001b84:	37fd                	addiw	a5,a5,-1
    80001b86:	fef42623          	sw	a5,-20(s0)
    80001b8a:	fec42783          	lw	a5,-20(s0)
    80001b8e:	2781                	sext.w	a5,a5
    80001b90:	f6f044e3          	bgtz	a5,80001af8 <walk+0x3a>
    }
  }
  return &pagetable[PX(0, va)];
    80001b94:	fd043783          	ld	a5,-48(s0)
    80001b98:	83b1                	srli	a5,a5,0xc
    80001b9a:	1ff7f793          	andi	a5,a5,511
    80001b9e:	078e                	slli	a5,a5,0x3
    80001ba0:	fd843703          	ld	a4,-40(s0)
    80001ba4:	97ba                	add	a5,a5,a4
}
    80001ba6:	853e                	mv	a0,a5
    80001ba8:	70e2                	ld	ra,56(sp)
    80001baa:	7442                	ld	s0,48(sp)
    80001bac:	6121                	addi	sp,sp,64
    80001bae:	8082                	ret

0000000080001bb0 <walkaddr>:
// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
    80001bb0:	7179                	addi	sp,sp,-48
    80001bb2:	f406                	sd	ra,40(sp)
    80001bb4:	f022                	sd	s0,32(sp)
    80001bb6:	1800                	addi	s0,sp,48
    80001bb8:	fca43c23          	sd	a0,-40(s0)
    80001bbc:	fcb43823          	sd	a1,-48(s0)
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001bc0:	fd043703          	ld	a4,-48(s0)
    80001bc4:	57fd                	li	a5,-1
    80001bc6:	83e9                	srli	a5,a5,0x1a
    80001bc8:	00e7f463          	bgeu	a5,a4,80001bd0 <walkaddr+0x20>
    return 0;
    80001bcc:	4781                	li	a5,0
    80001bce:	a881                	j	80001c1e <walkaddr+0x6e>

  pte = walk(pagetable, va, 0);
    80001bd0:	4601                	li	a2,0
    80001bd2:	fd043583          	ld	a1,-48(s0)
    80001bd6:	fd843503          	ld	a0,-40(s0)
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	ee4080e7          	jalr	-284(ra) # 80001abe <walk>
    80001be2:	fea43423          	sd	a0,-24(s0)
  if(pte == 0)
    80001be6:	fe843783          	ld	a5,-24(s0)
    80001bea:	e399                	bnez	a5,80001bf0 <walkaddr+0x40>
    return 0;
    80001bec:	4781                	li	a5,0
    80001bee:	a805                	j	80001c1e <walkaddr+0x6e>
  if((*pte & PTE_V) == 0)
    80001bf0:	fe843783          	ld	a5,-24(s0)
    80001bf4:	639c                	ld	a5,0(a5)
    80001bf6:	8b85                	andi	a5,a5,1
    80001bf8:	e399                	bnez	a5,80001bfe <walkaddr+0x4e>
    return 0;
    80001bfa:	4781                	li	a5,0
    80001bfc:	a00d                	j	80001c1e <walkaddr+0x6e>
  if((*pte & PTE_U) == 0)
    80001bfe:	fe843783          	ld	a5,-24(s0)
    80001c02:	639c                	ld	a5,0(a5)
    80001c04:	8bc1                	andi	a5,a5,16
    80001c06:	e399                	bnez	a5,80001c0c <walkaddr+0x5c>
    return 0;
    80001c08:	4781                	li	a5,0
    80001c0a:	a811                	j	80001c1e <walkaddr+0x6e>
  pa = PTE2PA(*pte);
    80001c0c:	fe843783          	ld	a5,-24(s0)
    80001c10:	639c                	ld	a5,0(a5)
    80001c12:	83a9                	srli	a5,a5,0xa
    80001c14:	07b2                	slli	a5,a5,0xc
    80001c16:	fef43023          	sd	a5,-32(s0)
  return pa;
    80001c1a:	fe043783          	ld	a5,-32(s0)
}
    80001c1e:	853e                	mv	a0,a5
    80001c20:	70a2                	ld	ra,40(sp)
    80001c22:	7402                	ld	s0,32(sp)
    80001c24:	6145                	addi	sp,sp,48
    80001c26:	8082                	ret

0000000080001c28 <kvmmap>:
// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void
kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
    80001c28:	7139                	addi	sp,sp,-64
    80001c2a:	fc06                	sd	ra,56(sp)
    80001c2c:	f822                	sd	s0,48(sp)
    80001c2e:	0080                	addi	s0,sp,64
    80001c30:	fea43423          	sd	a0,-24(s0)
    80001c34:	feb43023          	sd	a1,-32(s0)
    80001c38:	fcc43c23          	sd	a2,-40(s0)
    80001c3c:	fcd43823          	sd	a3,-48(s0)
    80001c40:	87ba                	mv	a5,a4
    80001c42:	fcf42623          	sw	a5,-52(s0)
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001c46:	fcc42783          	lw	a5,-52(s0)
    80001c4a:	873e                	mv	a4,a5
    80001c4c:	fd843683          	ld	a3,-40(s0)
    80001c50:	fd043603          	ld	a2,-48(s0)
    80001c54:	fe043583          	ld	a1,-32(s0)
    80001c58:	fe843503          	ld	a0,-24(s0)
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	026080e7          	jalr	38(ra) # 80001c82 <mappages>
    80001c64:	87aa                	mv	a5,a0
    80001c66:	cb89                	beqz	a5,80001c78 <kvmmap+0x50>
    panic("kvmmap");
    80001c68:	00009517          	auipc	a0,0x9
    80001c6c:	45850513          	addi	a0,a0,1112 # 8000b0c0 <etext+0xc0>
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	01a080e7          	jalr	26(ra) # 80000c8a <panic>
}
    80001c78:	0001                	nop
    80001c7a:	70e2                	ld	ra,56(sp)
    80001c7c:	7442                	ld	s0,48(sp)
    80001c7e:	6121                	addi	sp,sp,64
    80001c80:	8082                	ret

0000000080001c82 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001c82:	711d                	addi	sp,sp,-96
    80001c84:	ec86                	sd	ra,88(sp)
    80001c86:	e8a2                	sd	s0,80(sp)
    80001c88:	1080                	addi	s0,sp,96
    80001c8a:	fca43423          	sd	a0,-56(s0)
    80001c8e:	fcb43023          	sd	a1,-64(s0)
    80001c92:	fac43c23          	sd	a2,-72(s0)
    80001c96:	fad43823          	sd	a3,-80(s0)
    80001c9a:	87ba                	mv	a5,a4
    80001c9c:	faf42623          	sw	a5,-84(s0)
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001ca0:	fb843783          	ld	a5,-72(s0)
    80001ca4:	eb89                	bnez	a5,80001cb6 <mappages+0x34>
    panic("mappages: size");
    80001ca6:	00009517          	auipc	a0,0x9
    80001caa:	42250513          	addi	a0,a0,1058 # 8000b0c8 <etext+0xc8>
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	fdc080e7          	jalr	-36(ra) # 80000c8a <panic>
  
  a = PGROUNDDOWN(va);
    80001cb6:	fc043703          	ld	a4,-64(s0)
    80001cba:	77fd                	lui	a5,0xfffff
    80001cbc:	8ff9                	and	a5,a5,a4
    80001cbe:	fef43423          	sd	a5,-24(s0)
  last = PGROUNDDOWN(va + size - 1);
    80001cc2:	fc043703          	ld	a4,-64(s0)
    80001cc6:	fb843783          	ld	a5,-72(s0)
    80001cca:	97ba                	add	a5,a5,a4
    80001ccc:	fff78713          	addi	a4,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd7ce7>
    80001cd0:	77fd                	lui	a5,0xfffff
    80001cd2:	8ff9                	and	a5,a5,a4
    80001cd4:	fef43023          	sd	a5,-32(s0)
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001cd8:	4605                	li	a2,1
    80001cda:	fe843583          	ld	a1,-24(s0)
    80001cde:	fc843503          	ld	a0,-56(s0)
    80001ce2:	00000097          	auipc	ra,0x0
    80001ce6:	ddc080e7          	jalr	-548(ra) # 80001abe <walk>
    80001cea:	fca43c23          	sd	a0,-40(s0)
    80001cee:	fd843783          	ld	a5,-40(s0)
    80001cf2:	e399                	bnez	a5,80001cf8 <mappages+0x76>
      return -1;
    80001cf4:	57fd                	li	a5,-1
    80001cf6:	a085                	j	80001d56 <mappages+0xd4>
    if(*pte & PTE_V)
    80001cf8:	fd843783          	ld	a5,-40(s0)
    80001cfc:	639c                	ld	a5,0(a5)
    80001cfe:	8b85                	andi	a5,a5,1
    80001d00:	cb89                	beqz	a5,80001d12 <mappages+0x90>
      panic("mappages: remap");
    80001d02:	00009517          	auipc	a0,0x9
    80001d06:	3d650513          	addi	a0,a0,982 # 8000b0d8 <etext+0xd8>
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	f80080e7          	jalr	-128(ra) # 80000c8a <panic>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001d12:	fb043783          	ld	a5,-80(s0)
    80001d16:	83b1                	srli	a5,a5,0xc
    80001d18:	00a79713          	slli	a4,a5,0xa
    80001d1c:	fac42783          	lw	a5,-84(s0)
    80001d20:	8fd9                	or	a5,a5,a4
    80001d22:	0017e713          	ori	a4,a5,1
    80001d26:	fd843783          	ld	a5,-40(s0)
    80001d2a:	e398                	sd	a4,0(a5)
    if(a == last)
    80001d2c:	fe843703          	ld	a4,-24(s0)
    80001d30:	fe043783          	ld	a5,-32(s0)
    80001d34:	00f70f63          	beq	a4,a5,80001d52 <mappages+0xd0>
      break;
    a += PGSIZE;
    80001d38:	fe843703          	ld	a4,-24(s0)
    80001d3c:	6785                	lui	a5,0x1
    80001d3e:	97ba                	add	a5,a5,a4
    80001d40:	fef43423          	sd	a5,-24(s0)
    pa += PGSIZE;
    80001d44:	fb043703          	ld	a4,-80(s0)
    80001d48:	6785                	lui	a5,0x1
    80001d4a:	97ba                	add	a5,a5,a4
    80001d4c:	faf43823          	sd	a5,-80(s0)
    if((pte = walk(pagetable, a, 1)) == 0)
    80001d50:	b761                	j	80001cd8 <mappages+0x56>
      break;
    80001d52:	0001                	nop
  }
  return 0;
    80001d54:	4781                	li	a5,0
}
    80001d56:	853e                	mv	a0,a5
    80001d58:	60e6                	ld	ra,88(sp)
    80001d5a:	6446                	ld	s0,80(sp)
    80001d5c:	6125                	addi	sp,sp,96
    80001d5e:	8082                	ret

0000000080001d60 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001d60:	715d                	addi	sp,sp,-80
    80001d62:	e486                	sd	ra,72(sp)
    80001d64:	e0a2                	sd	s0,64(sp)
    80001d66:	0880                	addi	s0,sp,80
    80001d68:	fca43423          	sd	a0,-56(s0)
    80001d6c:	fcb43023          	sd	a1,-64(s0)
    80001d70:	fac43c23          	sd	a2,-72(s0)
    80001d74:	87b6                	mv	a5,a3
    80001d76:	faf42a23          	sw	a5,-76(s0)
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001d7a:	fc043703          	ld	a4,-64(s0)
    80001d7e:	6785                	lui	a5,0x1
    80001d80:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001d82:	8ff9                	and	a5,a5,a4
    80001d84:	cb89                	beqz	a5,80001d96 <uvmunmap+0x36>
    panic("uvmunmap: not aligned");
    80001d86:	00009517          	auipc	a0,0x9
    80001d8a:	36250513          	addi	a0,a0,866 # 8000b0e8 <etext+0xe8>
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	efc080e7          	jalr	-260(ra) # 80000c8a <panic>

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001d96:	fc043783          	ld	a5,-64(s0)
    80001d9a:	fef43423          	sd	a5,-24(s0)
    80001d9e:	a045                	j	80001e3e <uvmunmap+0xde>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001da0:	4601                	li	a2,0
    80001da2:	fe843583          	ld	a1,-24(s0)
    80001da6:	fc843503          	ld	a0,-56(s0)
    80001daa:	00000097          	auipc	ra,0x0
    80001dae:	d14080e7          	jalr	-748(ra) # 80001abe <walk>
    80001db2:	fea43023          	sd	a0,-32(s0)
    80001db6:	fe043783          	ld	a5,-32(s0)
    80001dba:	eb89                	bnez	a5,80001dcc <uvmunmap+0x6c>
      panic("uvmunmap: walk");
    80001dbc:	00009517          	auipc	a0,0x9
    80001dc0:	34450513          	addi	a0,a0,836 # 8000b100 <etext+0x100>
    80001dc4:	fffff097          	auipc	ra,0xfffff
    80001dc8:	ec6080e7          	jalr	-314(ra) # 80000c8a <panic>
    if((*pte & PTE_V) == 0)
    80001dcc:	fe043783          	ld	a5,-32(s0)
    80001dd0:	639c                	ld	a5,0(a5)
    80001dd2:	8b85                	andi	a5,a5,1
    80001dd4:	eb89                	bnez	a5,80001de6 <uvmunmap+0x86>
      panic("uvmunmap: not mapped");
    80001dd6:	00009517          	auipc	a0,0x9
    80001dda:	33a50513          	addi	a0,a0,826 # 8000b110 <etext+0x110>
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	eac080e7          	jalr	-340(ra) # 80000c8a <panic>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001de6:	fe043783          	ld	a5,-32(s0)
    80001dea:	639c                	ld	a5,0(a5)
    80001dec:	3ff7f713          	andi	a4,a5,1023
    80001df0:	4785                	li	a5,1
    80001df2:	00f71a63          	bne	a4,a5,80001e06 <uvmunmap+0xa6>
      panic("uvmunmap: not a leaf");
    80001df6:	00009517          	auipc	a0,0x9
    80001dfa:	33250513          	addi	a0,a0,818 # 8000b128 <etext+0x128>
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	e8c080e7          	jalr	-372(ra) # 80000c8a <panic>
    if(do_free){
    80001e06:	fb442783          	lw	a5,-76(s0)
    80001e0a:	2781                	sext.w	a5,a5
    80001e0c:	cf99                	beqz	a5,80001e2a <uvmunmap+0xca>
      uint64 pa = PTE2PA(*pte);
    80001e0e:	fe043783          	ld	a5,-32(s0)
    80001e12:	639c                	ld	a5,0(a5)
    80001e14:	83a9                	srli	a5,a5,0xa
    80001e16:	07b2                	slli	a5,a5,0xc
    80001e18:	fcf43c23          	sd	a5,-40(s0)
      kfree((void*)pa);
    80001e1c:	fd843783          	ld	a5,-40(s0)
    80001e20:	853e                	mv	a0,a5
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	264080e7          	jalr	612(ra) # 80001086 <kfree>
    }
    *pte = 0;
    80001e2a:	fe043783          	ld	a5,-32(s0)
    80001e2e:	0007b023          	sd	zero,0(a5)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001e32:	fe843703          	ld	a4,-24(s0)
    80001e36:	6785                	lui	a5,0x1
    80001e38:	97ba                	add	a5,a5,a4
    80001e3a:	fef43423          	sd	a5,-24(s0)
    80001e3e:	fb843783          	ld	a5,-72(s0)
    80001e42:	00c79713          	slli	a4,a5,0xc
    80001e46:	fc043783          	ld	a5,-64(s0)
    80001e4a:	97ba                	add	a5,a5,a4
    80001e4c:	fe843703          	ld	a4,-24(s0)
    80001e50:	f4f768e3          	bltu	a4,a5,80001da0 <uvmunmap+0x40>
  }
}
    80001e54:	0001                	nop
    80001e56:	0001                	nop
    80001e58:	60a6                	ld	ra,72(sp)
    80001e5a:	6406                	ld	s0,64(sp)
    80001e5c:	6161                	addi	sp,sp,80
    80001e5e:	8082                	ret

0000000080001e60 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	2c2080e7          	jalr	706(ra) # 8000112a <kalloc>
    80001e70:	fea43423          	sd	a0,-24(s0)
  if(pagetable == 0)
    80001e74:	fe843783          	ld	a5,-24(s0)
    80001e78:	e399                	bnez	a5,80001e7e <uvmcreate+0x1e>
    return 0;
    80001e7a:	4781                	li	a5,0
    80001e7c:	a819                	j	80001e92 <uvmcreate+0x32>
  memset(pagetable, 0, PGSIZE);
    80001e7e:	6605                	lui	a2,0x1
    80001e80:	4581                	li	a1,0
    80001e82:	fe843503          	ld	a0,-24(s0)
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	5cc080e7          	jalr	1484(ra) # 80001452 <memset>
  return pagetable;
    80001e8e:	fe843783          	ld	a5,-24(s0)
}
    80001e92:	853e                	mv	a0,a5
    80001e94:	60e2                	ld	ra,24(sp)
    80001e96:	6442                	ld	s0,16(sp)
    80001e98:	6105                	addi	sp,sp,32
    80001e9a:	8082                	ret

0000000080001e9c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001e9c:	7139                	addi	sp,sp,-64
    80001e9e:	fc06                	sd	ra,56(sp)
    80001ea0:	f822                	sd	s0,48(sp)
    80001ea2:	0080                	addi	s0,sp,64
    80001ea4:	fca43c23          	sd	a0,-40(s0)
    80001ea8:	fcb43823          	sd	a1,-48(s0)
    80001eac:	87b2                	mv	a5,a2
    80001eae:	fcf42623          	sw	a5,-52(s0)
  char *mem;

  if(sz >= PGSIZE)
    80001eb2:	fcc42783          	lw	a5,-52(s0)
    80001eb6:	0007871b          	sext.w	a4,a5
    80001eba:	6785                	lui	a5,0x1
    80001ebc:	00f76a63          	bltu	a4,a5,80001ed0 <uvmfirst+0x34>
    panic("uvmfirst: more than a page");
    80001ec0:	00009517          	auipc	a0,0x9
    80001ec4:	28050513          	addi	a0,a0,640 # 8000b140 <etext+0x140>
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	dc2080e7          	jalr	-574(ra) # 80000c8a <panic>
  mem = kalloc();
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	25a080e7          	jalr	602(ra) # 8000112a <kalloc>
    80001ed8:	fea43423          	sd	a0,-24(s0)
  memset(mem, 0, PGSIZE);
    80001edc:	6605                	lui	a2,0x1
    80001ede:	4581                	li	a1,0
    80001ee0:	fe843503          	ld	a0,-24(s0)
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	56e080e7          	jalr	1390(ra) # 80001452 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001eec:	fe843783          	ld	a5,-24(s0)
    80001ef0:	4779                	li	a4,30
    80001ef2:	86be                	mv	a3,a5
    80001ef4:	6605                	lui	a2,0x1
    80001ef6:	4581                	li	a1,0
    80001ef8:	fd843503          	ld	a0,-40(s0)
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	d86080e7          	jalr	-634(ra) # 80001c82 <mappages>
  memmove(mem, src, sz);
    80001f04:	fcc42783          	lw	a5,-52(s0)
    80001f08:	863e                	mv	a2,a5
    80001f0a:	fd043583          	ld	a1,-48(s0)
    80001f0e:	fe843503          	ld	a0,-24(s0)
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	624080e7          	jalr	1572(ra) # 80001536 <memmove>
}
    80001f1a:	0001                	nop
    80001f1c:	70e2                	ld	ra,56(sp)
    80001f1e:	7442                	ld	s0,48(sp)
    80001f20:	6121                	addi	sp,sp,64
    80001f22:	8082                	ret

0000000080001f24 <uvmalloc>:

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
    80001f24:	7139                	addi	sp,sp,-64
    80001f26:	fc06                	sd	ra,56(sp)
    80001f28:	f822                	sd	s0,48(sp)
    80001f2a:	0080                	addi	s0,sp,64
    80001f2c:	fca43c23          	sd	a0,-40(s0)
    80001f30:	fcb43823          	sd	a1,-48(s0)
    80001f34:	fcc43423          	sd	a2,-56(s0)
    80001f38:	87b6                	mv	a5,a3
    80001f3a:	fcf42223          	sw	a5,-60(s0)
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    80001f3e:	fc843703          	ld	a4,-56(s0)
    80001f42:	fd043783          	ld	a5,-48(s0)
    80001f46:	00f77563          	bgeu	a4,a5,80001f50 <uvmalloc+0x2c>
    return oldsz;
    80001f4a:	fd043783          	ld	a5,-48(s0)
    80001f4e:	a87d                	j	8000200c <uvmalloc+0xe8>

  oldsz = PGROUNDUP(oldsz);
    80001f50:	fd043703          	ld	a4,-48(s0)
    80001f54:	6785                	lui	a5,0x1
    80001f56:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001f58:	973e                	add	a4,a4,a5
    80001f5a:	77fd                	lui	a5,0xfffff
    80001f5c:	8ff9                	and	a5,a5,a4
    80001f5e:	fcf43823          	sd	a5,-48(s0)
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001f62:	fd043783          	ld	a5,-48(s0)
    80001f66:	fef43423          	sd	a5,-24(s0)
    80001f6a:	a849                	j	80001ffc <uvmalloc+0xd8>
    mem = kalloc();
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	1be080e7          	jalr	446(ra) # 8000112a <kalloc>
    80001f74:	fea43023          	sd	a0,-32(s0)
    if(mem == 0){
    80001f78:	fe043783          	ld	a5,-32(s0)
    80001f7c:	ef89                	bnez	a5,80001f96 <uvmalloc+0x72>
      uvmdealloc(pagetable, a, oldsz);
    80001f7e:	fd043603          	ld	a2,-48(s0)
    80001f82:	fe843583          	ld	a1,-24(s0)
    80001f86:	fd843503          	ld	a0,-40(s0)
    80001f8a:	00000097          	auipc	ra,0x0
    80001f8e:	08c080e7          	jalr	140(ra) # 80002016 <uvmdealloc>
      return 0;
    80001f92:	4781                	li	a5,0
    80001f94:	a8a5                	j	8000200c <uvmalloc+0xe8>
    }
    memset(mem, 0, PGSIZE);
    80001f96:	6605                	lui	a2,0x1
    80001f98:	4581                	li	a1,0
    80001f9a:	fe043503          	ld	a0,-32(s0)
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	4b4080e7          	jalr	1204(ra) # 80001452 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001fa6:	fe043783          	ld	a5,-32(s0)
    80001faa:	fc442703          	lw	a4,-60(s0)
    80001fae:	01276713          	ori	a4,a4,18
    80001fb2:	2701                	sext.w	a4,a4
    80001fb4:	86be                	mv	a3,a5
    80001fb6:	6605                	lui	a2,0x1
    80001fb8:	fe843583          	ld	a1,-24(s0)
    80001fbc:	fd843503          	ld	a0,-40(s0)
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	cc2080e7          	jalr	-830(ra) # 80001c82 <mappages>
    80001fc8:	87aa                	mv	a5,a0
    80001fca:	c39d                	beqz	a5,80001ff0 <uvmalloc+0xcc>
      kfree(mem);
    80001fcc:	fe043503          	ld	a0,-32(s0)
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	0b6080e7          	jalr	182(ra) # 80001086 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001fd8:	fd043603          	ld	a2,-48(s0)
    80001fdc:	fe843583          	ld	a1,-24(s0)
    80001fe0:	fd843503          	ld	a0,-40(s0)
    80001fe4:	00000097          	auipc	ra,0x0
    80001fe8:	032080e7          	jalr	50(ra) # 80002016 <uvmdealloc>
      return 0;
    80001fec:	4781                	li	a5,0
    80001fee:	a839                	j	8000200c <uvmalloc+0xe8>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001ff0:	fe843703          	ld	a4,-24(s0)
    80001ff4:	6785                	lui	a5,0x1
    80001ff6:	97ba                	add	a5,a5,a4
    80001ff8:	fef43423          	sd	a5,-24(s0)
    80001ffc:	fe843703          	ld	a4,-24(s0)
    80002000:	fc843783          	ld	a5,-56(s0)
    80002004:	f6f764e3          	bltu	a4,a5,80001f6c <uvmalloc+0x48>
    }
  }
  return newsz;
    80002008:	fc843783          	ld	a5,-56(s0)
}
    8000200c:	853e                	mv	a0,a5
    8000200e:	70e2                	ld	ra,56(sp)
    80002010:	7442                	ld	s0,48(sp)
    80002012:	6121                	addi	sp,sp,64
    80002014:	8082                	ret

0000000080002016 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80002016:	7139                	addi	sp,sp,-64
    80002018:	fc06                	sd	ra,56(sp)
    8000201a:	f822                	sd	s0,48(sp)
    8000201c:	0080                	addi	s0,sp,64
    8000201e:	fca43c23          	sd	a0,-40(s0)
    80002022:	fcb43823          	sd	a1,-48(s0)
    80002026:	fcc43423          	sd	a2,-56(s0)
  if(newsz >= oldsz)
    8000202a:	fc843703          	ld	a4,-56(s0)
    8000202e:	fd043783          	ld	a5,-48(s0)
    80002032:	00f76563          	bltu	a4,a5,8000203c <uvmdealloc+0x26>
    return oldsz;
    80002036:	fd043783          	ld	a5,-48(s0)
    8000203a:	a885                	j	800020aa <uvmdealloc+0x94>

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000203c:	fc843703          	ld	a4,-56(s0)
    80002040:	6785                	lui	a5,0x1
    80002042:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002044:	973e                	add	a4,a4,a5
    80002046:	77fd                	lui	a5,0xfffff
    80002048:	8f7d                	and	a4,a4,a5
    8000204a:	fd043683          	ld	a3,-48(s0)
    8000204e:	6785                	lui	a5,0x1
    80002050:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002052:	96be                	add	a3,a3,a5
    80002054:	77fd                	lui	a5,0xfffff
    80002056:	8ff5                	and	a5,a5,a3
    80002058:	04f77763          	bgeu	a4,a5,800020a6 <uvmdealloc+0x90>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000205c:	fd043703          	ld	a4,-48(s0)
    80002060:	6785                	lui	a5,0x1
    80002062:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002064:	973e                	add	a4,a4,a5
    80002066:	77fd                	lui	a5,0xfffff
    80002068:	8f7d                	and	a4,a4,a5
    8000206a:	fc843683          	ld	a3,-56(s0)
    8000206e:	6785                	lui	a5,0x1
    80002070:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002072:	96be                	add	a3,a3,a5
    80002074:	77fd                	lui	a5,0xfffff
    80002076:	8ff5                	and	a5,a5,a3
    80002078:	40f707b3          	sub	a5,a4,a5
    8000207c:	83b1                	srli	a5,a5,0xc
    8000207e:	fef42623          	sw	a5,-20(s0)
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80002082:	fc843703          	ld	a4,-56(s0)
    80002086:	6785                	lui	a5,0x1
    80002088:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000208a:	973e                	add	a4,a4,a5
    8000208c:	77fd                	lui	a5,0xfffff
    8000208e:	8ff9                	and	a5,a5,a4
    80002090:	fec42703          	lw	a4,-20(s0)
    80002094:	4685                	li	a3,1
    80002096:	863a                	mv	a2,a4
    80002098:	85be                	mv	a1,a5
    8000209a:	fd843503          	ld	a0,-40(s0)
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	cc2080e7          	jalr	-830(ra) # 80001d60 <uvmunmap>
  }

  return newsz;
    800020a6:	fc843783          	ld	a5,-56(s0)
}
    800020aa:	853e                	mv	a0,a5
    800020ac:	70e2                	ld	ra,56(sp)
    800020ae:	7442                	ld	s0,48(sp)
    800020b0:	6121                	addi	sp,sp,64
    800020b2:	8082                	ret

00000000800020b4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800020b4:	7139                	addi	sp,sp,-64
    800020b6:	fc06                	sd	ra,56(sp)
    800020b8:	f822                	sd	s0,48(sp)
    800020ba:	0080                	addi	s0,sp,64
    800020bc:	fca43423          	sd	a0,-56(s0)
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800020c0:	fe042623          	sw	zero,-20(s0)
    800020c4:	a88d                	j	80002136 <freewalk+0x82>
    pte_t pte = pagetable[i];
    800020c6:	fec42783          	lw	a5,-20(s0)
    800020ca:	078e                	slli	a5,a5,0x3
    800020cc:	fc843703          	ld	a4,-56(s0)
    800020d0:	97ba                	add	a5,a5,a4
    800020d2:	639c                	ld	a5,0(a5)
    800020d4:	fef43023          	sd	a5,-32(s0)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800020d8:	fe043783          	ld	a5,-32(s0)
    800020dc:	8b85                	andi	a5,a5,1
    800020de:	cb9d                	beqz	a5,80002114 <freewalk+0x60>
    800020e0:	fe043783          	ld	a5,-32(s0)
    800020e4:	8bb9                	andi	a5,a5,14
    800020e6:	e79d                	bnez	a5,80002114 <freewalk+0x60>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800020e8:	fe043783          	ld	a5,-32(s0)
    800020ec:	83a9                	srli	a5,a5,0xa
    800020ee:	07b2                	slli	a5,a5,0xc
    800020f0:	fcf43c23          	sd	a5,-40(s0)
      freewalk((pagetable_t)child);
    800020f4:	fd843783          	ld	a5,-40(s0)
    800020f8:	853e                	mv	a0,a5
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	fba080e7          	jalr	-70(ra) # 800020b4 <freewalk>
      pagetable[i] = 0;
    80002102:	fec42783          	lw	a5,-20(s0)
    80002106:	078e                	slli	a5,a5,0x3
    80002108:	fc843703          	ld	a4,-56(s0)
    8000210c:	97ba                	add	a5,a5,a4
    8000210e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffd7ce8>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80002112:	a829                	j	8000212c <freewalk+0x78>
    } else if(pte & PTE_V){
    80002114:	fe043783          	ld	a5,-32(s0)
    80002118:	8b85                	andi	a5,a5,1
    8000211a:	cb89                	beqz	a5,8000212c <freewalk+0x78>
      panic("freewalk: leaf");
    8000211c:	00009517          	auipc	a0,0x9
    80002120:	04450513          	addi	a0,a0,68 # 8000b160 <etext+0x160>
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	b66080e7          	jalr	-1178(ra) # 80000c8a <panic>
  for(int i = 0; i < 512; i++){
    8000212c:	fec42783          	lw	a5,-20(s0)
    80002130:	2785                	addiw	a5,a5,1
    80002132:	fef42623          	sw	a5,-20(s0)
    80002136:	fec42783          	lw	a5,-20(s0)
    8000213a:	0007871b          	sext.w	a4,a5
    8000213e:	1ff00793          	li	a5,511
    80002142:	f8e7d2e3          	bge	a5,a4,800020c6 <freewalk+0x12>
    }
  }
  kfree((void*)pagetable);
    80002146:	fc843503          	ld	a0,-56(s0)
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	f3c080e7          	jalr	-196(ra) # 80001086 <kfree>
}
    80002152:	0001                	nop
    80002154:	70e2                	ld	ra,56(sp)
    80002156:	7442                	ld	s0,48(sp)
    80002158:	6121                	addi	sp,sp,64
    8000215a:	8082                	ret

000000008000215c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	1000                	addi	s0,sp,32
    80002164:	fea43423          	sd	a0,-24(s0)
    80002168:	feb43023          	sd	a1,-32(s0)
  if(sz > 0)
    8000216c:	fe043783          	ld	a5,-32(s0)
    80002170:	c385                	beqz	a5,80002190 <uvmfree+0x34>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80002172:	fe043703          	ld	a4,-32(s0)
    80002176:	6785                	lui	a5,0x1
    80002178:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000217a:	97ba                	add	a5,a5,a4
    8000217c:	83b1                	srli	a5,a5,0xc
    8000217e:	4685                	li	a3,1
    80002180:	863e                	mv	a2,a5
    80002182:	4581                	li	a1,0
    80002184:	fe843503          	ld	a0,-24(s0)
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	bd8080e7          	jalr	-1064(ra) # 80001d60 <uvmunmap>
  freewalk(pagetable);
    80002190:	fe843503          	ld	a0,-24(s0)
    80002194:	00000097          	auipc	ra,0x0
    80002198:	f20080e7          	jalr	-224(ra) # 800020b4 <freewalk>
}
    8000219c:	0001                	nop
    8000219e:	60e2                	ld	ra,24(sp)
    800021a0:	6442                	ld	s0,16(sp)
    800021a2:	6105                	addi	sp,sp,32
    800021a4:	8082                	ret

00000000800021a6 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    800021a6:	711d                	addi	sp,sp,-96
    800021a8:	ec86                	sd	ra,88(sp)
    800021aa:	e8a2                	sd	s0,80(sp)
    800021ac:	1080                	addi	s0,sp,96
    800021ae:	faa43c23          	sd	a0,-72(s0)
    800021b2:	fab43823          	sd	a1,-80(s0)
    800021b6:	fac43423          	sd	a2,-88(s0)
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800021ba:	fe043423          	sd	zero,-24(s0)
    800021be:	a0d9                	j	80002284 <uvmcopy+0xde>
    if((pte = walk(old, i, 0)) == 0)
    800021c0:	4601                	li	a2,0
    800021c2:	fe843583          	ld	a1,-24(s0)
    800021c6:	fb843503          	ld	a0,-72(s0)
    800021ca:	00000097          	auipc	ra,0x0
    800021ce:	8f4080e7          	jalr	-1804(ra) # 80001abe <walk>
    800021d2:	fea43023          	sd	a0,-32(s0)
    800021d6:	fe043783          	ld	a5,-32(s0)
    800021da:	eb89                	bnez	a5,800021ec <uvmcopy+0x46>
      panic("uvmcopy: pte should exist");
    800021dc:	00009517          	auipc	a0,0x9
    800021e0:	f9450513          	addi	a0,a0,-108 # 8000b170 <etext+0x170>
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	aa6080e7          	jalr	-1370(ra) # 80000c8a <panic>
    if((*pte & PTE_V) == 0)
    800021ec:	fe043783          	ld	a5,-32(s0)
    800021f0:	639c                	ld	a5,0(a5)
    800021f2:	8b85                	andi	a5,a5,1
    800021f4:	eb89                	bnez	a5,80002206 <uvmcopy+0x60>
      panic("uvmcopy: page not present");
    800021f6:	00009517          	auipc	a0,0x9
    800021fa:	f9a50513          	addi	a0,a0,-102 # 8000b190 <etext+0x190>
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	a8c080e7          	jalr	-1396(ra) # 80000c8a <panic>
    pa = PTE2PA(*pte);
    80002206:	fe043783          	ld	a5,-32(s0)
    8000220a:	639c                	ld	a5,0(a5)
    8000220c:	83a9                	srli	a5,a5,0xa
    8000220e:	07b2                	slli	a5,a5,0xc
    80002210:	fcf43c23          	sd	a5,-40(s0)
    flags = PTE_FLAGS(*pte);
    80002214:	fe043783          	ld	a5,-32(s0)
    80002218:	639c                	ld	a5,0(a5)
    8000221a:	2781                	sext.w	a5,a5
    8000221c:	3ff7f793          	andi	a5,a5,1023
    80002220:	fcf42a23          	sw	a5,-44(s0)
    if((mem = kalloc()) == 0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	f06080e7          	jalr	-250(ra) # 8000112a <kalloc>
    8000222c:	fca43423          	sd	a0,-56(s0)
    80002230:	fc843783          	ld	a5,-56(s0)
    80002234:	c3a5                	beqz	a5,80002294 <uvmcopy+0xee>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80002236:	fd843783          	ld	a5,-40(s0)
    8000223a:	6605                	lui	a2,0x1
    8000223c:	85be                	mv	a1,a5
    8000223e:	fc843503          	ld	a0,-56(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	2f4080e7          	jalr	756(ra) # 80001536 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000224a:	fc843783          	ld	a5,-56(s0)
    8000224e:	fd442703          	lw	a4,-44(s0)
    80002252:	86be                	mv	a3,a5
    80002254:	6605                	lui	a2,0x1
    80002256:	fe843583          	ld	a1,-24(s0)
    8000225a:	fb043503          	ld	a0,-80(s0)
    8000225e:	00000097          	auipc	ra,0x0
    80002262:	a24080e7          	jalr	-1500(ra) # 80001c82 <mappages>
    80002266:	87aa                	mv	a5,a0
    80002268:	cb81                	beqz	a5,80002278 <uvmcopy+0xd2>
      kfree(mem);
    8000226a:	fc843503          	ld	a0,-56(s0)
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	e18080e7          	jalr	-488(ra) # 80001086 <kfree>
      goto err;
    80002276:	a005                	j	80002296 <uvmcopy+0xf0>
  for(i = 0; i < sz; i += PGSIZE){
    80002278:	fe843703          	ld	a4,-24(s0)
    8000227c:	6785                	lui	a5,0x1
    8000227e:	97ba                	add	a5,a5,a4
    80002280:	fef43423          	sd	a5,-24(s0)
    80002284:	fe843703          	ld	a4,-24(s0)
    80002288:	fa843783          	ld	a5,-88(s0)
    8000228c:	f2f76ae3          	bltu	a4,a5,800021c0 <uvmcopy+0x1a>
    }
  }
  return 0;
    80002290:	4781                	li	a5,0
    80002292:	a839                	j	800022b0 <uvmcopy+0x10a>
      goto err;
    80002294:	0001                	nop

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80002296:	fe843783          	ld	a5,-24(s0)
    8000229a:	83b1                	srli	a5,a5,0xc
    8000229c:	4685                	li	a3,1
    8000229e:	863e                	mv	a2,a5
    800022a0:	4581                	li	a1,0
    800022a2:	fb043503          	ld	a0,-80(s0)
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	aba080e7          	jalr	-1350(ra) # 80001d60 <uvmunmap>
  return -1;
    800022ae:	57fd                	li	a5,-1
}
    800022b0:	853e                	mv	a0,a5
    800022b2:	60e6                	ld	ra,88(sp)
    800022b4:	6446                	ld	s0,80(sp)
    800022b6:	6125                	addi	sp,sp,96
    800022b8:	8082                	ret

00000000800022ba <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800022ba:	7179                	addi	sp,sp,-48
    800022bc:	f406                	sd	ra,40(sp)
    800022be:	f022                	sd	s0,32(sp)
    800022c0:	1800                	addi	s0,sp,48
    800022c2:	fca43c23          	sd	a0,-40(s0)
    800022c6:	fcb43823          	sd	a1,-48(s0)
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800022ca:	4601                	li	a2,0
    800022cc:	fd043583          	ld	a1,-48(s0)
    800022d0:	fd843503          	ld	a0,-40(s0)
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	7ea080e7          	jalr	2026(ra) # 80001abe <walk>
    800022dc:	fea43423          	sd	a0,-24(s0)
  if(pte == 0)
    800022e0:	fe843783          	ld	a5,-24(s0)
    800022e4:	eb89                	bnez	a5,800022f6 <uvmclear+0x3c>
    panic("uvmclear");
    800022e6:	00009517          	auipc	a0,0x9
    800022ea:	eca50513          	addi	a0,a0,-310 # 8000b1b0 <etext+0x1b0>
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	99c080e7          	jalr	-1636(ra) # 80000c8a <panic>
  *pte &= ~PTE_U;
    800022f6:	fe843783          	ld	a5,-24(s0)
    800022fa:	639c                	ld	a5,0(a5)
    800022fc:	fef7f713          	andi	a4,a5,-17
    80002300:	fe843783          	ld	a5,-24(s0)
    80002304:	e398                	sd	a4,0(a5)
}
    80002306:	0001                	nop
    80002308:	70a2                	ld	ra,40(sp)
    8000230a:	7402                	ld	s0,32(sp)
    8000230c:	6145                	addi	sp,sp,48
    8000230e:	8082                	ret

0000000080002310 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80002310:	715d                	addi	sp,sp,-80
    80002312:	e486                	sd	ra,72(sp)
    80002314:	e0a2                	sd	s0,64(sp)
    80002316:	0880                	addi	s0,sp,80
    80002318:	fca43423          	sd	a0,-56(s0)
    8000231c:	fcb43023          	sd	a1,-64(s0)
    80002320:	fac43c23          	sd	a2,-72(s0)
    80002324:	fad43823          	sd	a3,-80(s0)
  uint64 n, va0, pa0;

  while(len > 0){
    80002328:	a055                	j	800023cc <copyout+0xbc>
    va0 = PGROUNDDOWN(dstva);
    8000232a:	fc043703          	ld	a4,-64(s0)
    8000232e:	77fd                	lui	a5,0xfffff
    80002330:	8ff9                	and	a5,a5,a4
    80002332:	fef43023          	sd	a5,-32(s0)
    pa0 = walkaddr(pagetable, va0);
    80002336:	fe043583          	ld	a1,-32(s0)
    8000233a:	fc843503          	ld	a0,-56(s0)
    8000233e:	00000097          	auipc	ra,0x0
    80002342:	872080e7          	jalr	-1934(ra) # 80001bb0 <walkaddr>
    80002346:	fca43c23          	sd	a0,-40(s0)
    if(pa0 == 0)
    8000234a:	fd843783          	ld	a5,-40(s0)
    8000234e:	e399                	bnez	a5,80002354 <copyout+0x44>
      return -1;
    80002350:	57fd                	li	a5,-1
    80002352:	a049                	j	800023d4 <copyout+0xc4>
    n = PGSIZE - (dstva - va0);
    80002354:	fe043703          	ld	a4,-32(s0)
    80002358:	fc043783          	ld	a5,-64(s0)
    8000235c:	8f1d                	sub	a4,a4,a5
    8000235e:	6785                	lui	a5,0x1
    80002360:	97ba                	add	a5,a5,a4
    80002362:	fef43423          	sd	a5,-24(s0)
    if(n > len)
    80002366:	fe843703          	ld	a4,-24(s0)
    8000236a:	fb043783          	ld	a5,-80(s0)
    8000236e:	00e7f663          	bgeu	a5,a4,8000237a <copyout+0x6a>
      n = len;
    80002372:	fb043783          	ld	a5,-80(s0)
    80002376:	fef43423          	sd	a5,-24(s0)
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000237a:	fc043703          	ld	a4,-64(s0)
    8000237e:	fe043783          	ld	a5,-32(s0)
    80002382:	8f1d                	sub	a4,a4,a5
    80002384:	fd843783          	ld	a5,-40(s0)
    80002388:	97ba                	add	a5,a5,a4
    8000238a:	873e                	mv	a4,a5
    8000238c:	fe843783          	ld	a5,-24(s0)
    80002390:	2781                	sext.w	a5,a5
    80002392:	863e                	mv	a2,a5
    80002394:	fb843583          	ld	a1,-72(s0)
    80002398:	853a                	mv	a0,a4
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	19c080e7          	jalr	412(ra) # 80001536 <memmove>

    len -= n;
    800023a2:	fb043703          	ld	a4,-80(s0)
    800023a6:	fe843783          	ld	a5,-24(s0)
    800023aa:	40f707b3          	sub	a5,a4,a5
    800023ae:	faf43823          	sd	a5,-80(s0)
    src += n;
    800023b2:	fb843703          	ld	a4,-72(s0)
    800023b6:	fe843783          	ld	a5,-24(s0)
    800023ba:	97ba                	add	a5,a5,a4
    800023bc:	faf43c23          	sd	a5,-72(s0)
    dstva = va0 + PGSIZE;
    800023c0:	fe043703          	ld	a4,-32(s0)
    800023c4:	6785                	lui	a5,0x1
    800023c6:	97ba                	add	a5,a5,a4
    800023c8:	fcf43023          	sd	a5,-64(s0)
  while(len > 0){
    800023cc:	fb043783          	ld	a5,-80(s0)
    800023d0:	ffa9                	bnez	a5,8000232a <copyout+0x1a>
  }
  return 0;
    800023d2:	4781                	li	a5,0
}
    800023d4:	853e                	mv	a0,a5
    800023d6:	60a6                	ld	ra,72(sp)
    800023d8:	6406                	ld	s0,64(sp)
    800023da:	6161                	addi	sp,sp,80
    800023dc:	8082                	ret

00000000800023de <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    800023de:	715d                	addi	sp,sp,-80
    800023e0:	e486                	sd	ra,72(sp)
    800023e2:	e0a2                	sd	s0,64(sp)
    800023e4:	0880                	addi	s0,sp,80
    800023e6:	fca43423          	sd	a0,-56(s0)
    800023ea:	fcb43023          	sd	a1,-64(s0)
    800023ee:	fac43c23          	sd	a2,-72(s0)
    800023f2:	fad43823          	sd	a3,-80(s0)
  uint64 n, va0, pa0;

  while(len > 0){
    800023f6:	a055                	j	8000249a <copyin+0xbc>
    va0 = PGROUNDDOWN(srcva);
    800023f8:	fb843703          	ld	a4,-72(s0)
    800023fc:	77fd                	lui	a5,0xfffff
    800023fe:	8ff9                	and	a5,a5,a4
    80002400:	fef43023          	sd	a5,-32(s0)
    pa0 = walkaddr(pagetable, va0);
    80002404:	fe043583          	ld	a1,-32(s0)
    80002408:	fc843503          	ld	a0,-56(s0)
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	7a4080e7          	jalr	1956(ra) # 80001bb0 <walkaddr>
    80002414:	fca43c23          	sd	a0,-40(s0)
    if(pa0 == 0)
    80002418:	fd843783          	ld	a5,-40(s0)
    8000241c:	e399                	bnez	a5,80002422 <copyin+0x44>
      return -1;
    8000241e:	57fd                	li	a5,-1
    80002420:	a049                	j	800024a2 <copyin+0xc4>
    n = PGSIZE - (srcva - va0);
    80002422:	fe043703          	ld	a4,-32(s0)
    80002426:	fb843783          	ld	a5,-72(s0)
    8000242a:	8f1d                	sub	a4,a4,a5
    8000242c:	6785                	lui	a5,0x1
    8000242e:	97ba                	add	a5,a5,a4
    80002430:	fef43423          	sd	a5,-24(s0)
    if(n > len)
    80002434:	fe843703          	ld	a4,-24(s0)
    80002438:	fb043783          	ld	a5,-80(s0)
    8000243c:	00e7f663          	bgeu	a5,a4,80002448 <copyin+0x6a>
      n = len;
    80002440:	fb043783          	ld	a5,-80(s0)
    80002444:	fef43423          	sd	a5,-24(s0)
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80002448:	fb843703          	ld	a4,-72(s0)
    8000244c:	fe043783          	ld	a5,-32(s0)
    80002450:	8f1d                	sub	a4,a4,a5
    80002452:	fd843783          	ld	a5,-40(s0)
    80002456:	97ba                	add	a5,a5,a4
    80002458:	873e                	mv	a4,a5
    8000245a:	fe843783          	ld	a5,-24(s0)
    8000245e:	2781                	sext.w	a5,a5
    80002460:	863e                	mv	a2,a5
    80002462:	85ba                	mv	a1,a4
    80002464:	fc043503          	ld	a0,-64(s0)
    80002468:	fffff097          	auipc	ra,0xfffff
    8000246c:	0ce080e7          	jalr	206(ra) # 80001536 <memmove>

    len -= n;
    80002470:	fb043703          	ld	a4,-80(s0)
    80002474:	fe843783          	ld	a5,-24(s0)
    80002478:	40f707b3          	sub	a5,a4,a5
    8000247c:	faf43823          	sd	a5,-80(s0)
    dst += n;
    80002480:	fc043703          	ld	a4,-64(s0)
    80002484:	fe843783          	ld	a5,-24(s0)
    80002488:	97ba                	add	a5,a5,a4
    8000248a:	fcf43023          	sd	a5,-64(s0)
    srcva = va0 + PGSIZE;
    8000248e:	fe043703          	ld	a4,-32(s0)
    80002492:	6785                	lui	a5,0x1
    80002494:	97ba                	add	a5,a5,a4
    80002496:	faf43c23          	sd	a5,-72(s0)
  while(len > 0){
    8000249a:	fb043783          	ld	a5,-80(s0)
    8000249e:	ffa9                	bnez	a5,800023f8 <copyin+0x1a>
  }
  return 0;
    800024a0:	4781                	li	a5,0
}
    800024a2:	853e                	mv	a0,a5
    800024a4:	60a6                	ld	ra,72(sp)
    800024a6:	6406                	ld	s0,64(sp)
    800024a8:	6161                	addi	sp,sp,80
    800024aa:	8082                	ret

00000000800024ac <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800024ac:	711d                	addi	sp,sp,-96
    800024ae:	ec86                	sd	ra,88(sp)
    800024b0:	e8a2                	sd	s0,80(sp)
    800024b2:	1080                	addi	s0,sp,96
    800024b4:	faa43c23          	sd	a0,-72(s0)
    800024b8:	fab43823          	sd	a1,-80(s0)
    800024bc:	fac43423          	sd	a2,-88(s0)
    800024c0:	fad43023          	sd	a3,-96(s0)
  uint64 n, va0, pa0;
  int got_null = 0;
    800024c4:	fe042223          	sw	zero,-28(s0)

  while(got_null == 0 && max > 0){
    800024c8:	a0f1                	j	80002594 <copyinstr+0xe8>
    va0 = PGROUNDDOWN(srcva);
    800024ca:	fa843703          	ld	a4,-88(s0)
    800024ce:	77fd                	lui	a5,0xfffff
    800024d0:	8ff9                	and	a5,a5,a4
    800024d2:	fcf43823          	sd	a5,-48(s0)
    pa0 = walkaddr(pagetable, va0);
    800024d6:	fd043583          	ld	a1,-48(s0)
    800024da:	fb843503          	ld	a0,-72(s0)
    800024de:	fffff097          	auipc	ra,0xfffff
    800024e2:	6d2080e7          	jalr	1746(ra) # 80001bb0 <walkaddr>
    800024e6:	fca43423          	sd	a0,-56(s0)
    if(pa0 == 0)
    800024ea:	fc843783          	ld	a5,-56(s0)
    800024ee:	e399                	bnez	a5,800024f4 <copyinstr+0x48>
      return -1;
    800024f0:	57fd                	li	a5,-1
    800024f2:	a87d                	j	800025b0 <copyinstr+0x104>
    n = PGSIZE - (srcva - va0);
    800024f4:	fd043703          	ld	a4,-48(s0)
    800024f8:	fa843783          	ld	a5,-88(s0)
    800024fc:	8f1d                	sub	a4,a4,a5
    800024fe:	6785                	lui	a5,0x1
    80002500:	97ba                	add	a5,a5,a4
    80002502:	fef43423          	sd	a5,-24(s0)
    if(n > max)
    80002506:	fe843703          	ld	a4,-24(s0)
    8000250a:	fa043783          	ld	a5,-96(s0)
    8000250e:	00e7f663          	bgeu	a5,a4,8000251a <copyinstr+0x6e>
      n = max;
    80002512:	fa043783          	ld	a5,-96(s0)
    80002516:	fef43423          	sd	a5,-24(s0)

    char *p = (char *) (pa0 + (srcva - va0));
    8000251a:	fa843703          	ld	a4,-88(s0)
    8000251e:	fd043783          	ld	a5,-48(s0)
    80002522:	8f1d                	sub	a4,a4,a5
    80002524:	fc843783          	ld	a5,-56(s0)
    80002528:	97ba                	add	a5,a5,a4
    8000252a:	fcf43c23          	sd	a5,-40(s0)
    while(n > 0){
    8000252e:	a891                	j	80002582 <copyinstr+0xd6>
      if(*p == '\0'){
    80002530:	fd843783          	ld	a5,-40(s0)
    80002534:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x7ffff000>
    80002538:	eb89                	bnez	a5,8000254a <copyinstr+0x9e>
        *dst = '\0';
    8000253a:	fb043783          	ld	a5,-80(s0)
    8000253e:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80002542:	4785                	li	a5,1
    80002544:	fef42223          	sw	a5,-28(s0)
        break;
    80002548:	a081                	j	80002588 <copyinstr+0xdc>
      } else {
        *dst = *p;
    8000254a:	fd843783          	ld	a5,-40(s0)
    8000254e:	0007c703          	lbu	a4,0(a5)
    80002552:	fb043783          	ld	a5,-80(s0)
    80002556:	00e78023          	sb	a4,0(a5)
      }
      --n;
    8000255a:	fe843783          	ld	a5,-24(s0)
    8000255e:	17fd                	addi	a5,a5,-1
    80002560:	fef43423          	sd	a5,-24(s0)
      --max;
    80002564:	fa043783          	ld	a5,-96(s0)
    80002568:	17fd                	addi	a5,a5,-1
    8000256a:	faf43023          	sd	a5,-96(s0)
      p++;
    8000256e:	fd843783          	ld	a5,-40(s0)
    80002572:	0785                	addi	a5,a5,1
    80002574:	fcf43c23          	sd	a5,-40(s0)
      dst++;
    80002578:	fb043783          	ld	a5,-80(s0)
    8000257c:	0785                	addi	a5,a5,1
    8000257e:	faf43823          	sd	a5,-80(s0)
    while(n > 0){
    80002582:	fe843783          	ld	a5,-24(s0)
    80002586:	f7cd                	bnez	a5,80002530 <copyinstr+0x84>
    }

    srcva = va0 + PGSIZE;
    80002588:	fd043703          	ld	a4,-48(s0)
    8000258c:	6785                	lui	a5,0x1
    8000258e:	97ba                	add	a5,a5,a4
    80002590:	faf43423          	sd	a5,-88(s0)
  while(got_null == 0 && max > 0){
    80002594:	fe442783          	lw	a5,-28(s0)
    80002598:	2781                	sext.w	a5,a5
    8000259a:	e781                	bnez	a5,800025a2 <copyinstr+0xf6>
    8000259c:	fa043783          	ld	a5,-96(s0)
    800025a0:	f78d                	bnez	a5,800024ca <copyinstr+0x1e>
  }
  if(got_null){
    800025a2:	fe442783          	lw	a5,-28(s0)
    800025a6:	2781                	sext.w	a5,a5
    800025a8:	c399                	beqz	a5,800025ae <copyinstr+0x102>
    return 0;
    800025aa:	4781                	li	a5,0
    800025ac:	a011                	j	800025b0 <copyinstr+0x104>
  } else {
    return -1;
    800025ae:	57fd                	li	a5,-1
  }
}
    800025b0:	853e                	mv	a0,a5
    800025b2:	60e6                	ld	ra,88(sp)
    800025b4:	6446                	ld	s0,80(sp)
    800025b6:	6125                	addi	sp,sp,96
    800025b8:	8082                	ret

00000000800025ba <r_sstatus>:
{
    800025ba:	1101                	addi	sp,sp,-32
    800025bc:	ec22                	sd	s0,24(sp)
    800025be:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c0:	100027f3          	csrr	a5,sstatus
    800025c4:	fef43423          	sd	a5,-24(s0)
  return x;
    800025c8:	fe843783          	ld	a5,-24(s0)
}
    800025cc:	853e                	mv	a0,a5
    800025ce:	6462                	ld	s0,24(sp)
    800025d0:	6105                	addi	sp,sp,32
    800025d2:	8082                	ret

00000000800025d4 <w_sstatus>:
{
    800025d4:	1101                	addi	sp,sp,-32
    800025d6:	ec22                	sd	s0,24(sp)
    800025d8:	1000                	addi	s0,sp,32
    800025da:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025de:	fe843783          	ld	a5,-24(s0)
    800025e2:	10079073          	csrw	sstatus,a5
}
    800025e6:	0001                	nop
    800025e8:	6462                	ld	s0,24(sp)
    800025ea:	6105                	addi	sp,sp,32
    800025ec:	8082                	ret

00000000800025ee <intr_on>:
{
    800025ee:	1141                	addi	sp,sp,-16
    800025f0:	e406                	sd	ra,8(sp)
    800025f2:	e022                	sd	s0,0(sp)
    800025f4:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025f6:	00000097          	auipc	ra,0x0
    800025fa:	fc4080e7          	jalr	-60(ra) # 800025ba <r_sstatus>
    800025fe:	87aa                	mv	a5,a0
    80002600:	0027e793          	ori	a5,a5,2
    80002604:	853e                	mv	a0,a5
    80002606:	00000097          	auipc	ra,0x0
    8000260a:	fce080e7          	jalr	-50(ra) # 800025d4 <w_sstatus>
}
    8000260e:	0001                	nop
    80002610:	60a2                	ld	ra,8(sp)
    80002612:	6402                	ld	s0,0(sp)
    80002614:	0141                	addi	sp,sp,16
    80002616:	8082                	ret

0000000080002618 <intr_get>:
{
    80002618:	1101                	addi	sp,sp,-32
    8000261a:	ec06                	sd	ra,24(sp)
    8000261c:	e822                	sd	s0,16(sp)
    8000261e:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80002620:	00000097          	auipc	ra,0x0
    80002624:	f9a080e7          	jalr	-102(ra) # 800025ba <r_sstatus>
    80002628:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    8000262c:	fe843783          	ld	a5,-24(s0)
    80002630:	8b89                	andi	a5,a5,2
    80002632:	00f037b3          	snez	a5,a5
    80002636:	0ff7f793          	zext.b	a5,a5
    8000263a:	2781                	sext.w	a5,a5
}
    8000263c:	853e                	mv	a0,a5
    8000263e:	60e2                	ld	ra,24(sp)
    80002640:	6442                	ld	s0,16(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret

0000000080002646 <r_tp>:
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec22                	sd	s0,24(sp)
    8000264a:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    8000264c:	8792                	mv	a5,tp
    8000264e:	fef43423          	sd	a5,-24(s0)
  return x;
    80002652:	fe843783          	ld	a5,-24(s0)
}
    80002656:	853e                	mv	a0,a5
    80002658:	6462                	ld	s0,24(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret

000000008000265e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000265e:	7139                	addi	sp,sp,-64
    80002660:	fc06                	sd	ra,56(sp)
    80002662:	f822                	sd	s0,48(sp)
    80002664:	0080                	addi	s0,sp,64
    80002666:	fca43423          	sd	a0,-56(s0)
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000266a:	00014797          	auipc	a5,0x14
    8000266e:	e9e78793          	addi	a5,a5,-354 # 80016508 <proc>
    80002672:	fef43423          	sd	a5,-24(s0)
    80002676:	a061                	j	800026fe <proc_mapstacks+0xa0>
    char *pa = kalloc();
    80002678:	fffff097          	auipc	ra,0xfffff
    8000267c:	ab2080e7          	jalr	-1358(ra) # 8000112a <kalloc>
    80002680:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    80002684:	fe043783          	ld	a5,-32(s0)
    80002688:	eb89                	bnez	a5,8000269a <proc_mapstacks+0x3c>
      panic("kalloc");
    8000268a:	00009517          	auipc	a0,0x9
    8000268e:	b3650513          	addi	a0,a0,-1226 # 8000b1c0 <etext+0x1c0>
    80002692:	ffffe097          	auipc	ra,0xffffe
    80002696:	5f8080e7          	jalr	1528(ra) # 80000c8a <panic>
    uint64 va = KSTACK((int) (p - proc));
    8000269a:	fe843703          	ld	a4,-24(s0)
    8000269e:	00014797          	auipc	a5,0x14
    800026a2:	e6a78793          	addi	a5,a5,-406 # 80016508 <proc>
    800026a6:	40f707b3          	sub	a5,a4,a5
    800026aa:	4037d713          	srai	a4,a5,0x3
    800026ae:	00009797          	auipc	a5,0x9
    800026b2:	c1a78793          	addi	a5,a5,-998 # 8000b2c8 <etext+0x2c8>
    800026b6:	639c                	ld	a5,0(a5)
    800026b8:	02f707b3          	mul	a5,a4,a5
    800026bc:	2781                	sext.w	a5,a5
    800026be:	2785                	addiw	a5,a5,1
    800026c0:	2781                	sext.w	a5,a5
    800026c2:	00d7979b          	slliw	a5,a5,0xd
    800026c6:	2781                	sext.w	a5,a5
    800026c8:	873e                	mv	a4,a5
    800026ca:	040007b7          	lui	a5,0x4000
    800026ce:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800026d0:	07b2                	slli	a5,a5,0xc
    800026d2:	8f99                	sub	a5,a5,a4
    800026d4:	fcf43c23          	sd	a5,-40(s0)
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800026d8:	fe043783          	ld	a5,-32(s0)
    800026dc:	4719                	li	a4,6
    800026de:	6685                	lui	a3,0x1
    800026e0:	863e                	mv	a2,a5
    800026e2:	fd843583          	ld	a1,-40(s0)
    800026e6:	fc843503          	ld	a0,-56(s0)
    800026ea:	fffff097          	auipc	ra,0xfffff
    800026ee:	53e080e7          	jalr	1342(ra) # 80001c28 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800026f2:	fe843783          	ld	a5,-24(s0)
    800026f6:	16878793          	addi	a5,a5,360
    800026fa:	fef43423          	sd	a5,-24(s0)
    800026fe:	fe843703          	ld	a4,-24(s0)
    80002702:	0001a797          	auipc	a5,0x1a
    80002706:	80678793          	addi	a5,a5,-2042 # 8001bf08 <pid_lock>
    8000270a:	f6f767e3          	bltu	a4,a5,80002678 <proc_mapstacks+0x1a>
  }
}
    8000270e:	0001                	nop
    80002710:	0001                	nop
    80002712:	70e2                	ld	ra,56(sp)
    80002714:	7442                	ld	s0,48(sp)
    80002716:	6121                	addi	sp,sp,64
    80002718:	8082                	ret

000000008000271a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000271a:	1101                	addi	sp,sp,-32
    8000271c:	ec06                	sd	ra,24(sp)
    8000271e:	e822                	sd	s0,16(sp)
    80002720:	1000                	addi	s0,sp,32
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80002722:	00009597          	auipc	a1,0x9
    80002726:	aa658593          	addi	a1,a1,-1370 # 8000b1c8 <etext+0x1c8>
    8000272a:	00019517          	auipc	a0,0x19
    8000272e:	7de50513          	addi	a0,a0,2014 # 8001bf08 <pid_lock>
    80002732:	fffff097          	auipc	ra,0xfffff
    80002736:	b1c080e7          	jalr	-1252(ra) # 8000124e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000273a:	00009597          	auipc	a1,0x9
    8000273e:	a9658593          	addi	a1,a1,-1386 # 8000b1d0 <etext+0x1d0>
    80002742:	00019517          	auipc	a0,0x19
    80002746:	7de50513          	addi	a0,a0,2014 # 8001bf20 <wait_lock>
    8000274a:	fffff097          	auipc	ra,0xfffff
    8000274e:	b04080e7          	jalr	-1276(ra) # 8000124e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002752:	00014797          	auipc	a5,0x14
    80002756:	db678793          	addi	a5,a5,-586 # 80016508 <proc>
    8000275a:	fef43423          	sd	a5,-24(s0)
    8000275e:	a0bd                	j	800027cc <procinit+0xb2>
      initlock(&p->lock, "proc");
    80002760:	fe843783          	ld	a5,-24(s0)
    80002764:	00009597          	auipc	a1,0x9
    80002768:	a7c58593          	addi	a1,a1,-1412 # 8000b1e0 <etext+0x1e0>
    8000276c:	853e                	mv	a0,a5
    8000276e:	fffff097          	auipc	ra,0xfffff
    80002772:	ae0080e7          	jalr	-1312(ra) # 8000124e <initlock>
      p->state = UNUSED;
    80002776:	fe843783          	ld	a5,-24(s0)
    8000277a:	0007ac23          	sw	zero,24(a5)
      p->kstack = KSTACK((int) (p - proc));
    8000277e:	fe843703          	ld	a4,-24(s0)
    80002782:	00014797          	auipc	a5,0x14
    80002786:	d8678793          	addi	a5,a5,-634 # 80016508 <proc>
    8000278a:	40f707b3          	sub	a5,a4,a5
    8000278e:	4037d713          	srai	a4,a5,0x3
    80002792:	00009797          	auipc	a5,0x9
    80002796:	b3678793          	addi	a5,a5,-1226 # 8000b2c8 <etext+0x2c8>
    8000279a:	639c                	ld	a5,0(a5)
    8000279c:	02f707b3          	mul	a5,a4,a5
    800027a0:	2781                	sext.w	a5,a5
    800027a2:	2785                	addiw	a5,a5,1
    800027a4:	2781                	sext.w	a5,a5
    800027a6:	00d7979b          	slliw	a5,a5,0xd
    800027aa:	2781                	sext.w	a5,a5
    800027ac:	873e                	mv	a4,a5
    800027ae:	040007b7          	lui	a5,0x4000
    800027b2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027b4:	07b2                	slli	a5,a5,0xc
    800027b6:	8f99                	sub	a5,a5,a4
    800027b8:	873e                	mv	a4,a5
    800027ba:	fe843783          	ld	a5,-24(s0)
    800027be:	e3b8                	sd	a4,64(a5)
  for(p = proc; p < &proc[NPROC]; p++) {
    800027c0:	fe843783          	ld	a5,-24(s0)
    800027c4:	16878793          	addi	a5,a5,360
    800027c8:	fef43423          	sd	a5,-24(s0)
    800027cc:	fe843703          	ld	a4,-24(s0)
    800027d0:	00019797          	auipc	a5,0x19
    800027d4:	73878793          	addi	a5,a5,1848 # 8001bf08 <pid_lock>
    800027d8:	f8f764e3          	bltu	a4,a5,80002760 <procinit+0x46>
  }
}
    800027dc:	0001                	nop
    800027de:	0001                	nop
    800027e0:	60e2                	ld	ra,24(sp)
    800027e2:	6442                	ld	s0,16(sp)
    800027e4:	6105                	addi	sp,sp,32
    800027e6:	8082                	ret

00000000800027e8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800027e8:	1101                	addi	sp,sp,-32
    800027ea:	ec06                	sd	ra,24(sp)
    800027ec:	e822                	sd	s0,16(sp)
    800027ee:	1000                	addi	s0,sp,32
  int id = r_tp();
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	e56080e7          	jalr	-426(ra) # 80002646 <r_tp>
    800027f8:	87aa                	mv	a5,a0
    800027fa:	fef42623          	sw	a5,-20(s0)
  return id;
    800027fe:	fec42783          	lw	a5,-20(s0)
}
    80002802:	853e                	mv	a0,a5
    80002804:	60e2                	ld	ra,24(sp)
    80002806:	6442                	ld	s0,16(sp)
    80002808:	6105                	addi	sp,sp,32
    8000280a:	8082                	ret

000000008000280c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000280c:	1101                	addi	sp,sp,-32
    8000280e:	ec06                	sd	ra,24(sp)
    80002810:	e822                	sd	s0,16(sp)
    80002812:	1000                	addi	s0,sp,32
  int id = cpuid();
    80002814:	00000097          	auipc	ra,0x0
    80002818:	fd4080e7          	jalr	-44(ra) # 800027e8 <cpuid>
    8000281c:	87aa                	mv	a5,a0
    8000281e:	fef42623          	sw	a5,-20(s0)
  struct cpu *c = &cpus[id];
    80002822:	fec42783          	lw	a5,-20(s0)
    80002826:	00779713          	slli	a4,a5,0x7
    8000282a:	00014797          	auipc	a5,0x14
    8000282e:	8de78793          	addi	a5,a5,-1826 # 80016108 <cpus>
    80002832:	97ba                	add	a5,a5,a4
    80002834:	fef43023          	sd	a5,-32(s0)
  return c;
    80002838:	fe043783          	ld	a5,-32(s0)
}
    8000283c:	853e                	mv	a0,a5
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	6105                	addi	sp,sp,32
    80002844:	8082                	ret

0000000080002846 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80002846:	1101                	addi	sp,sp,-32
    80002848:	ec06                	sd	ra,24(sp)
    8000284a:	e822                	sd	s0,16(sp)
    8000284c:	1000                	addi	s0,sp,32
  push_off();
    8000284e:	fffff097          	auipc	ra,0xfffff
    80002852:	b2e080e7          	jalr	-1234(ra) # 8000137c <push_off>
  struct cpu *c = mycpu();
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	fb6080e7          	jalr	-74(ra) # 8000280c <mycpu>
    8000285e:	fea43423          	sd	a0,-24(s0)
  struct proc *p = c->proc;
    80002862:	fe843783          	ld	a5,-24(s0)
    80002866:	639c                	ld	a5,0(a5)
    80002868:	fef43023          	sd	a5,-32(s0)
  pop_off();
    8000286c:	fffff097          	auipc	ra,0xfffff
    80002870:	b68080e7          	jalr	-1176(ra) # 800013d4 <pop_off>
  return p;
    80002874:	fe043783          	ld	a5,-32(s0)
}
    80002878:	853e                	mv	a0,a5
    8000287a:	60e2                	ld	ra,24(sp)
    8000287c:	6442                	ld	s0,16(sp)
    8000287e:	6105                	addi	sp,sp,32
    80002880:	8082                	ret

0000000080002882 <allocpid>:

int
allocpid()
{
    80002882:	1101                	addi	sp,sp,-32
    80002884:	ec06                	sd	ra,24(sp)
    80002886:	e822                	sd	s0,16(sp)
    80002888:	1000                	addi	s0,sp,32
  int pid;
  
  acquire(&pid_lock);
    8000288a:	00019517          	auipc	a0,0x19
    8000288e:	67e50513          	addi	a0,a0,1662 # 8001bf08 <pid_lock>
    80002892:	fffff097          	auipc	ra,0xfffff
    80002896:	9ec080e7          	jalr	-1556(ra) # 8000127e <acquire>
  pid = nextpid;
    8000289a:	0000b797          	auipc	a5,0xb
    8000289e:	46678793          	addi	a5,a5,1126 # 8000dd00 <nextpid>
    800028a2:	439c                	lw	a5,0(a5)
    800028a4:	fef42623          	sw	a5,-20(s0)
  nextpid = nextpid + 1;
    800028a8:	0000b797          	auipc	a5,0xb
    800028ac:	45878793          	addi	a5,a5,1112 # 8000dd00 <nextpid>
    800028b0:	439c                	lw	a5,0(a5)
    800028b2:	2785                	addiw	a5,a5,1
    800028b4:	0007871b          	sext.w	a4,a5
    800028b8:	0000b797          	auipc	a5,0xb
    800028bc:	44878793          	addi	a5,a5,1096 # 8000dd00 <nextpid>
    800028c0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800028c2:	00019517          	auipc	a0,0x19
    800028c6:	64650513          	addi	a0,a0,1606 # 8001bf08 <pid_lock>
    800028ca:	fffff097          	auipc	ra,0xfffff
    800028ce:	a18080e7          	jalr	-1512(ra) # 800012e2 <release>

  return pid;
    800028d2:	fec42783          	lw	a5,-20(s0)
}
    800028d6:	853e                	mv	a0,a5
    800028d8:	60e2                	ld	ra,24(sp)
    800028da:	6442                	ld	s0,16(sp)
    800028dc:	6105                	addi	sp,sp,32
    800028de:	8082                	ret

00000000800028e0 <allocproc>:
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
    800028e0:	1101                	addi	sp,sp,-32
    800028e2:	ec06                	sd	ra,24(sp)
    800028e4:	e822                	sd	s0,16(sp)
    800028e6:	1000                	addi	s0,sp,32
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800028e8:	00014797          	auipc	a5,0x14
    800028ec:	c2078793          	addi	a5,a5,-992 # 80016508 <proc>
    800028f0:	fef43423          	sd	a5,-24(s0)
    800028f4:	a80d                	j	80002926 <allocproc+0x46>
    acquire(&p->lock);
    800028f6:	fe843783          	ld	a5,-24(s0)
    800028fa:	853e                	mv	a0,a5
    800028fc:	fffff097          	auipc	ra,0xfffff
    80002900:	982080e7          	jalr	-1662(ra) # 8000127e <acquire>
    if(p->state == UNUSED) {
    80002904:	fe843783          	ld	a5,-24(s0)
    80002908:	4f9c                	lw	a5,24(a5)
    8000290a:	cb85                	beqz	a5,8000293a <allocproc+0x5a>
      goto found;
    } else {
      release(&p->lock);
    8000290c:	fe843783          	ld	a5,-24(s0)
    80002910:	853e                	mv	a0,a5
    80002912:	fffff097          	auipc	ra,0xfffff
    80002916:	9d0080e7          	jalr	-1584(ra) # 800012e2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000291a:	fe843783          	ld	a5,-24(s0)
    8000291e:	16878793          	addi	a5,a5,360
    80002922:	fef43423          	sd	a5,-24(s0)
    80002926:	fe843703          	ld	a4,-24(s0)
    8000292a:	00019797          	auipc	a5,0x19
    8000292e:	5de78793          	addi	a5,a5,1502 # 8001bf08 <pid_lock>
    80002932:	fcf762e3          	bltu	a4,a5,800028f6 <allocproc+0x16>
    }
  }
  return 0;
    80002936:	4781                	li	a5,0
    80002938:	a0e1                	j	80002a00 <allocproc+0x120>
      goto found;
    8000293a:	0001                	nop

found:
  p->pid = allocpid();
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	f46080e7          	jalr	-186(ra) # 80002882 <allocpid>
    80002944:	87aa                	mv	a5,a0
    80002946:	873e                	mv	a4,a5
    80002948:	fe843783          	ld	a5,-24(s0)
    8000294c:	db98                	sw	a4,48(a5)
  p->state = USED;
    8000294e:	fe843783          	ld	a5,-24(s0)
    80002952:	4705                	li	a4,1
    80002954:	cf98                	sw	a4,24(a5)

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	7d4080e7          	jalr	2004(ra) # 8000112a <kalloc>
    8000295e:	872a                	mv	a4,a0
    80002960:	fe843783          	ld	a5,-24(s0)
    80002964:	efb8                	sd	a4,88(a5)
    80002966:	fe843783          	ld	a5,-24(s0)
    8000296a:	6fbc                	ld	a5,88(a5)
    8000296c:	e385                	bnez	a5,8000298c <allocproc+0xac>
    freeproc(p);
    8000296e:	fe843503          	ld	a0,-24(s0)
    80002972:	00000097          	auipc	ra,0x0
    80002976:	098080e7          	jalr	152(ra) # 80002a0a <freeproc>
    release(&p->lock);
    8000297a:	fe843783          	ld	a5,-24(s0)
    8000297e:	853e                	mv	a0,a5
    80002980:	fffff097          	auipc	ra,0xfffff
    80002984:	962080e7          	jalr	-1694(ra) # 800012e2 <release>
    return 0;
    80002988:	4781                	li	a5,0
    8000298a:	a89d                	j	80002a00 <allocproc+0x120>
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
    8000298c:	fe843503          	ld	a0,-24(s0)
    80002990:	00000097          	auipc	ra,0x0
    80002994:	118080e7          	jalr	280(ra) # 80002aa8 <proc_pagetable>
    80002998:	872a                	mv	a4,a0
    8000299a:	fe843783          	ld	a5,-24(s0)
    8000299e:	ebb8                	sd	a4,80(a5)
  if(p->pagetable == 0){
    800029a0:	fe843783          	ld	a5,-24(s0)
    800029a4:	6bbc                	ld	a5,80(a5)
    800029a6:	e385                	bnez	a5,800029c6 <allocproc+0xe6>
    freeproc(p);
    800029a8:	fe843503          	ld	a0,-24(s0)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	05e080e7          	jalr	94(ra) # 80002a0a <freeproc>
    release(&p->lock);
    800029b4:	fe843783          	ld	a5,-24(s0)
    800029b8:	853e                	mv	a0,a5
    800029ba:	fffff097          	auipc	ra,0xfffff
    800029be:	928080e7          	jalr	-1752(ra) # 800012e2 <release>
    return 0;
    800029c2:	4781                	li	a5,0
    800029c4:	a835                	j	80002a00 <allocproc+0x120>
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
    800029c6:	fe843783          	ld	a5,-24(s0)
    800029ca:	06078793          	addi	a5,a5,96
    800029ce:	07000613          	li	a2,112
    800029d2:	4581                	li	a1,0
    800029d4:	853e                	mv	a0,a5
    800029d6:	fffff097          	auipc	ra,0xfffff
    800029da:	a7c080e7          	jalr	-1412(ra) # 80001452 <memset>
  p->context.ra = (uint64)forkret;
    800029de:	00001717          	auipc	a4,0x1
    800029e2:	9da70713          	addi	a4,a4,-1574 # 800033b8 <forkret>
    800029e6:	fe843783          	ld	a5,-24(s0)
    800029ea:	f3b8                	sd	a4,96(a5)
  p->context.sp = p->kstack + PGSIZE;
    800029ec:	fe843783          	ld	a5,-24(s0)
    800029f0:	63b8                	ld	a4,64(a5)
    800029f2:	6785                	lui	a5,0x1
    800029f4:	973e                	add	a4,a4,a5
    800029f6:	fe843783          	ld	a5,-24(s0)
    800029fa:	f7b8                	sd	a4,104(a5)

  return p;
    800029fc:	fe843783          	ld	a5,-24(s0)
}
    80002a00:	853e                	mv	a0,a5
    80002a02:	60e2                	ld	ra,24(sp)
    80002a04:	6442                	ld	s0,16(sp)
    80002a06:	6105                	addi	sp,sp,32
    80002a08:	8082                	ret

0000000080002a0a <freeproc>:
// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
    80002a0a:	1101                	addi	sp,sp,-32
    80002a0c:	ec06                	sd	ra,24(sp)
    80002a0e:	e822                	sd	s0,16(sp)
    80002a10:	1000                	addi	s0,sp,32
    80002a12:	fea43423          	sd	a0,-24(s0)
  if(p->trapframe)
    80002a16:	fe843783          	ld	a5,-24(s0)
    80002a1a:	6fbc                	ld	a5,88(a5)
    80002a1c:	cb89                	beqz	a5,80002a2e <freeproc+0x24>
    kfree((void*)p->trapframe);
    80002a1e:	fe843783          	ld	a5,-24(s0)
    80002a22:	6fbc                	ld	a5,88(a5)
    80002a24:	853e                	mv	a0,a5
    80002a26:	ffffe097          	auipc	ra,0xffffe
    80002a2a:	660080e7          	jalr	1632(ra) # 80001086 <kfree>
  p->trapframe = 0;
    80002a2e:	fe843783          	ld	a5,-24(s0)
    80002a32:	0407bc23          	sd	zero,88(a5) # 1058 <_entry-0x7fffefa8>
  if(p->pagetable)
    80002a36:	fe843783          	ld	a5,-24(s0)
    80002a3a:	6bbc                	ld	a5,80(a5)
    80002a3c:	cf89                	beqz	a5,80002a56 <freeproc+0x4c>
    proc_freepagetable(p->pagetable, p->sz);
    80002a3e:	fe843783          	ld	a5,-24(s0)
    80002a42:	6bb8                	ld	a4,80(a5)
    80002a44:	fe843783          	ld	a5,-24(s0)
    80002a48:	67bc                	ld	a5,72(a5)
    80002a4a:	85be                	mv	a1,a5
    80002a4c:	853a                	mv	a0,a4
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	11a080e7          	jalr	282(ra) # 80002b68 <proc_freepagetable>
  p->pagetable = 0;
    80002a56:	fe843783          	ld	a5,-24(s0)
    80002a5a:	0407b823          	sd	zero,80(a5)
  p->sz = 0;
    80002a5e:	fe843783          	ld	a5,-24(s0)
    80002a62:	0407b423          	sd	zero,72(a5)
  p->pid = 0;
    80002a66:	fe843783          	ld	a5,-24(s0)
    80002a6a:	0207a823          	sw	zero,48(a5)
  p->parent = 0;
    80002a6e:	fe843783          	ld	a5,-24(s0)
    80002a72:	0207bc23          	sd	zero,56(a5)
  p->name[0] = 0;
    80002a76:	fe843783          	ld	a5,-24(s0)
    80002a7a:	14078c23          	sb	zero,344(a5)
  p->chan = 0;
    80002a7e:	fe843783          	ld	a5,-24(s0)
    80002a82:	0207b023          	sd	zero,32(a5)
  p->killed = 0;
    80002a86:	fe843783          	ld	a5,-24(s0)
    80002a8a:	0207a423          	sw	zero,40(a5)
  p->xstate = 0;
    80002a8e:	fe843783          	ld	a5,-24(s0)
    80002a92:	0207a623          	sw	zero,44(a5)
  p->state = UNUSED;
    80002a96:	fe843783          	ld	a5,-24(s0)
    80002a9a:	0007ac23          	sw	zero,24(a5)
}
    80002a9e:	0001                	nop
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	6105                	addi	sp,sp,32
    80002aa6:	8082                	ret

0000000080002aa8 <proc_pagetable>:

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
    80002aa8:	7179                	addi	sp,sp,-48
    80002aaa:	f406                	sd	ra,40(sp)
    80002aac:	f022                	sd	s0,32(sp)
    80002aae:	1800                	addi	s0,sp,48
    80002ab0:	fca43c23          	sd	a0,-40(s0)
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
    80002ab4:	fffff097          	auipc	ra,0xfffff
    80002ab8:	3ac080e7          	jalr	940(ra) # 80001e60 <uvmcreate>
    80002abc:	fea43423          	sd	a0,-24(s0)
  if(pagetable == 0)
    80002ac0:	fe843783          	ld	a5,-24(s0)
    80002ac4:	e399                	bnez	a5,80002aca <proc_pagetable+0x22>
    return 0;
    80002ac6:	4781                	li	a5,0
    80002ac8:	a859                	j	80002b5e <proc_pagetable+0xb6>

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002aca:	00007797          	auipc	a5,0x7
    80002ace:	53678793          	addi	a5,a5,1334 # 8000a000 <_trampoline>
    80002ad2:	4729                	li	a4,10
    80002ad4:	86be                	mv	a3,a5
    80002ad6:	6605                	lui	a2,0x1
    80002ad8:	040007b7          	lui	a5,0x4000
    80002adc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002ade:	00c79593          	slli	a1,a5,0xc
    80002ae2:	fe843503          	ld	a0,-24(s0)
    80002ae6:	fffff097          	auipc	ra,0xfffff
    80002aea:	19c080e7          	jalr	412(ra) # 80001c82 <mappages>
    80002aee:	87aa                	mv	a5,a0
    80002af0:	0007db63          	bgez	a5,80002b06 <proc_pagetable+0x5e>
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    80002af4:	4581                	li	a1,0
    80002af6:	fe843503          	ld	a0,-24(s0)
    80002afa:	fffff097          	auipc	ra,0xfffff
    80002afe:	662080e7          	jalr	1634(ra) # 8000215c <uvmfree>
    return 0;
    80002b02:	4781                	li	a5,0
    80002b04:	a8a9                	j	80002b5e <proc_pagetable+0xb6>
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    80002b06:	fd843783          	ld	a5,-40(s0)
    80002b0a:	6fbc                	ld	a5,88(a5)
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002b0c:	4719                	li	a4,6
    80002b0e:	86be                	mv	a3,a5
    80002b10:	6605                	lui	a2,0x1
    80002b12:	020007b7          	lui	a5,0x2000
    80002b16:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002b18:	00d79593          	slli	a1,a5,0xd
    80002b1c:	fe843503          	ld	a0,-24(s0)
    80002b20:	fffff097          	auipc	ra,0xfffff
    80002b24:	162080e7          	jalr	354(ra) # 80001c82 <mappages>
    80002b28:	87aa                	mv	a5,a0
    80002b2a:	0207d863          	bgez	a5,80002b5a <proc_pagetable+0xb2>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002b2e:	4681                	li	a3,0
    80002b30:	4605                	li	a2,1
    80002b32:	040007b7          	lui	a5,0x4000
    80002b36:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b38:	00c79593          	slli	a1,a5,0xc
    80002b3c:	fe843503          	ld	a0,-24(s0)
    80002b40:	fffff097          	auipc	ra,0xfffff
    80002b44:	220080e7          	jalr	544(ra) # 80001d60 <uvmunmap>
    uvmfree(pagetable, 0);
    80002b48:	4581                	li	a1,0
    80002b4a:	fe843503          	ld	a0,-24(s0)
    80002b4e:	fffff097          	auipc	ra,0xfffff
    80002b52:	60e080e7          	jalr	1550(ra) # 8000215c <uvmfree>
    return 0;
    80002b56:	4781                	li	a5,0
    80002b58:	a019                	j	80002b5e <proc_pagetable+0xb6>
  }

  return pagetable;
    80002b5a:	fe843783          	ld	a5,-24(s0)
}
    80002b5e:	853e                	mv	a0,a5
    80002b60:	70a2                	ld	ra,40(sp)
    80002b62:	7402                	ld	s0,32(sp)
    80002b64:	6145                	addi	sp,sp,48
    80002b66:	8082                	ret

0000000080002b68 <proc_freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	1000                	addi	s0,sp,32
    80002b70:	fea43423          	sd	a0,-24(s0)
    80002b74:	feb43023          	sd	a1,-32(s0)
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002b78:	4681                	li	a3,0
    80002b7a:	4605                	li	a2,1
    80002b7c:	040007b7          	lui	a5,0x4000
    80002b80:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002b82:	00c79593          	slli	a1,a5,0xc
    80002b86:	fe843503          	ld	a0,-24(s0)
    80002b8a:	fffff097          	auipc	ra,0xfffff
    80002b8e:	1d6080e7          	jalr	470(ra) # 80001d60 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002b92:	4681                	li	a3,0
    80002b94:	4605                	li	a2,1
    80002b96:	020007b7          	lui	a5,0x2000
    80002b9a:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002b9c:	00d79593          	slli	a1,a5,0xd
    80002ba0:	fe843503          	ld	a0,-24(s0)
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	1bc080e7          	jalr	444(ra) # 80001d60 <uvmunmap>
  uvmfree(pagetable, sz);
    80002bac:	fe043583          	ld	a1,-32(s0)
    80002bb0:	fe843503          	ld	a0,-24(s0)
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	5a8080e7          	jalr	1448(ra) # 8000215c <uvmfree>
}
    80002bbc:	0001                	nop
    80002bbe:	60e2                	ld	ra,24(sp)
    80002bc0:	6442                	ld	s0,16(sp)
    80002bc2:	6105                	addi	sp,sp,32
    80002bc4:	8082                	ret

0000000080002bc6 <userinit>:
};

// Set up first user process.
void
userinit(void)
{
    80002bc6:	1101                	addi	sp,sp,-32
    80002bc8:	ec06                	sd	ra,24(sp)
    80002bca:	e822                	sd	s0,16(sp)
    80002bcc:	1000                	addi	s0,sp,32
  struct proc *p;

  p = allocproc();
    80002bce:	00000097          	auipc	ra,0x0
    80002bd2:	d12080e7          	jalr	-750(ra) # 800028e0 <allocproc>
    80002bd6:	fea43423          	sd	a0,-24(s0)
  initproc = p;
    80002bda:	0000b797          	auipc	a5,0xb
    80002bde:	2b678793          	addi	a5,a5,694 # 8000de90 <initproc>
    80002be2:	fe843703          	ld	a4,-24(s0)
    80002be6:	e398                	sd	a4,0(a5)
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002be8:	fe843783          	ld	a5,-24(s0)
    80002bec:	6bbc                	ld	a5,80(a5)
    80002bee:	03400613          	li	a2,52
    80002bf2:	0000b597          	auipc	a1,0xb
    80002bf6:	13658593          	addi	a1,a1,310 # 8000dd28 <initcode>
    80002bfa:	853e                	mv	a0,a5
    80002bfc:	fffff097          	auipc	ra,0xfffff
    80002c00:	2a0080e7          	jalr	672(ra) # 80001e9c <uvmfirst>
  p->sz = PGSIZE;
    80002c04:	fe843783          	ld	a5,-24(s0)
    80002c08:	6705                	lui	a4,0x1
    80002c0a:	e7b8                	sd	a4,72(a5)

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
    80002c0c:	fe843783          	ld	a5,-24(s0)
    80002c10:	6fbc                	ld	a5,88(a5)
    80002c12:	0007bc23          	sd	zero,24(a5)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002c16:	fe843783          	ld	a5,-24(s0)
    80002c1a:	6fbc                	ld	a5,88(a5)
    80002c1c:	6705                	lui	a4,0x1
    80002c1e:	fb98                	sd	a4,48(a5)

  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002c20:	fe843783          	ld	a5,-24(s0)
    80002c24:	15878793          	addi	a5,a5,344
    80002c28:	4641                	li	a2,16
    80002c2a:	00008597          	auipc	a1,0x8
    80002c2e:	5be58593          	addi	a1,a1,1470 # 8000b1e8 <etext+0x1e8>
    80002c32:	853e                	mv	a0,a5
    80002c34:	fffff097          	auipc	ra,0xfffff
    80002c38:	b22080e7          	jalr	-1246(ra) # 80001756 <safestrcpy>
  p->cwd = namei("/");
    80002c3c:	00008517          	auipc	a0,0x8
    80002c40:	5bc50513          	addi	a0,a0,1468 # 8000b1f8 <etext+0x1f8>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	1f4080e7          	jalr	500(ra) # 80005e38 <namei>
    80002c4c:	872a                	mv	a4,a0
    80002c4e:	fe843783          	ld	a5,-24(s0)
    80002c52:	14e7b823          	sd	a4,336(a5)

  p->state = RUNNABLE;
    80002c56:	fe843783          	ld	a5,-24(s0)
    80002c5a:	470d                	li	a4,3
    80002c5c:	cf98                	sw	a4,24(a5)

  release(&p->lock);
    80002c5e:	fe843783          	ld	a5,-24(s0)
    80002c62:	853e                	mv	a0,a5
    80002c64:	ffffe097          	auipc	ra,0xffffe
    80002c68:	67e080e7          	jalr	1662(ra) # 800012e2 <release>
}
    80002c6c:	0001                	nop
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	6105                	addi	sp,sp,32
    80002c74:	8082                	ret

0000000080002c76 <growproc>:

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
    80002c76:	7179                	addi	sp,sp,-48
    80002c78:	f406                	sd	ra,40(sp)
    80002c7a:	f022                	sd	s0,32(sp)
    80002c7c:	1800                	addi	s0,sp,48
    80002c7e:	87aa                	mv	a5,a0
    80002c80:	fcf42e23          	sw	a5,-36(s0)
  uint64 sz;
  struct proc *p = myproc();
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	bc2080e7          	jalr	-1086(ra) # 80002846 <myproc>
    80002c8c:	fea43023          	sd	a0,-32(s0)

  sz = p->sz;
    80002c90:	fe043783          	ld	a5,-32(s0)
    80002c94:	67bc                	ld	a5,72(a5)
    80002c96:	fef43423          	sd	a5,-24(s0)
  if(n > 0){
    80002c9a:	fdc42783          	lw	a5,-36(s0)
    80002c9e:	2781                	sext.w	a5,a5
    80002ca0:	02f05963          	blez	a5,80002cd2 <growproc+0x5c>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002ca4:	fe043783          	ld	a5,-32(s0)
    80002ca8:	6ba8                	ld	a0,80(a5)
    80002caa:	fdc42703          	lw	a4,-36(s0)
    80002cae:	fe843783          	ld	a5,-24(s0)
    80002cb2:	97ba                	add	a5,a5,a4
    80002cb4:	4691                	li	a3,4
    80002cb6:	863e                	mv	a2,a5
    80002cb8:	fe843583          	ld	a1,-24(s0)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	268080e7          	jalr	616(ra) # 80001f24 <uvmalloc>
    80002cc4:	fea43423          	sd	a0,-24(s0)
    80002cc8:	fe843783          	ld	a5,-24(s0)
    80002ccc:	eb95                	bnez	a5,80002d00 <growproc+0x8a>
      return -1;
    80002cce:	57fd                	li	a5,-1
    80002cd0:	a835                	j	80002d0c <growproc+0x96>
    }
  } else if(n < 0){
    80002cd2:	fdc42783          	lw	a5,-36(s0)
    80002cd6:	2781                	sext.w	a5,a5
    80002cd8:	0207d463          	bgez	a5,80002d00 <growproc+0x8a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002cdc:	fe043783          	ld	a5,-32(s0)
    80002ce0:	6bb4                	ld	a3,80(a5)
    80002ce2:	fdc42703          	lw	a4,-36(s0)
    80002ce6:	fe843783          	ld	a5,-24(s0)
    80002cea:	97ba                	add	a5,a5,a4
    80002cec:	863e                	mv	a2,a5
    80002cee:	fe843583          	ld	a1,-24(s0)
    80002cf2:	8536                	mv	a0,a3
    80002cf4:	fffff097          	auipc	ra,0xfffff
    80002cf8:	322080e7          	jalr	802(ra) # 80002016 <uvmdealloc>
    80002cfc:	fea43423          	sd	a0,-24(s0)
  }
  p->sz = sz;
    80002d00:	fe043783          	ld	a5,-32(s0)
    80002d04:	fe843703          	ld	a4,-24(s0)
    80002d08:	e7b8                	sd	a4,72(a5)
  return 0;
    80002d0a:	4781                	li	a5,0
}
    80002d0c:	853e                	mv	a0,a5
    80002d0e:	70a2                	ld	ra,40(sp)
    80002d10:	7402                	ld	s0,32(sp)
    80002d12:	6145                	addi	sp,sp,48
    80002d14:	8082                	ret

0000000080002d16 <fork>:

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
    80002d16:	7179                	addi	sp,sp,-48
    80002d18:	f406                	sd	ra,40(sp)
    80002d1a:	f022                	sd	s0,32(sp)
    80002d1c:	1800                	addi	s0,sp,48
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	b28080e7          	jalr	-1240(ra) # 80002846 <myproc>
    80002d26:	fea43023          	sd	a0,-32(s0)

  // Allocate process.
  if((np = allocproc()) == 0){
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	bb6080e7          	jalr	-1098(ra) # 800028e0 <allocproc>
    80002d32:	fca43c23          	sd	a0,-40(s0)
    80002d36:	fd843783          	ld	a5,-40(s0)
    80002d3a:	e399                	bnez	a5,80002d40 <fork+0x2a>
    return -1;
    80002d3c:	57fd                	li	a5,-1
    80002d3e:	aab5                	j	80002eba <fork+0x1a4>
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002d40:	fe043783          	ld	a5,-32(s0)
    80002d44:	6bb8                	ld	a4,80(a5)
    80002d46:	fd843783          	ld	a5,-40(s0)
    80002d4a:	6bb4                	ld	a3,80(a5)
    80002d4c:	fe043783          	ld	a5,-32(s0)
    80002d50:	67bc                	ld	a5,72(a5)
    80002d52:	863e                	mv	a2,a5
    80002d54:	85b6                	mv	a1,a3
    80002d56:	853a                	mv	a0,a4
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	44e080e7          	jalr	1102(ra) # 800021a6 <uvmcopy>
    80002d60:	87aa                	mv	a5,a0
    80002d62:	0207d163          	bgez	a5,80002d84 <fork+0x6e>
    freeproc(np);
    80002d66:	fd843503          	ld	a0,-40(s0)
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	ca0080e7          	jalr	-864(ra) # 80002a0a <freeproc>
    release(&np->lock);
    80002d72:	fd843783          	ld	a5,-40(s0)
    80002d76:	853e                	mv	a0,a5
    80002d78:	ffffe097          	auipc	ra,0xffffe
    80002d7c:	56a080e7          	jalr	1386(ra) # 800012e2 <release>
    return -1;
    80002d80:	57fd                	li	a5,-1
    80002d82:	aa25                	j	80002eba <fork+0x1a4>
  }
  np->sz = p->sz;
    80002d84:	fe043783          	ld	a5,-32(s0)
    80002d88:	67b8                	ld	a4,72(a5)
    80002d8a:	fd843783          	ld	a5,-40(s0)
    80002d8e:	e7b8                	sd	a4,72(a5)

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);
    80002d90:	fe043783          	ld	a5,-32(s0)
    80002d94:	6fb8                	ld	a4,88(a5)
    80002d96:	fd843783          	ld	a5,-40(s0)
    80002d9a:	6fbc                	ld	a5,88(a5)
    80002d9c:	86be                	mv	a3,a5
    80002d9e:	12000793          	li	a5,288
    80002da2:	863e                	mv	a2,a5
    80002da4:	85ba                	mv	a1,a4
    80002da6:	8536                	mv	a0,a3
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	86a080e7          	jalr	-1942(ra) # 80001612 <memcpy>

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;
    80002db0:	fd843783          	ld	a5,-40(s0)
    80002db4:	6fbc                	ld	a5,88(a5)
    80002db6:	0607b823          	sd	zero,112(a5)

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    80002dba:	fe042623          	sw	zero,-20(s0)
    80002dbe:	a0a9                	j	80002e08 <fork+0xf2>
    if(p->ofile[i])
    80002dc0:	fe043703          	ld	a4,-32(s0)
    80002dc4:	fec42783          	lw	a5,-20(s0)
    80002dc8:	07e9                	addi	a5,a5,26
    80002dca:	078e                	slli	a5,a5,0x3
    80002dcc:	97ba                	add	a5,a5,a4
    80002dce:	639c                	ld	a5,0(a5)
    80002dd0:	c79d                	beqz	a5,80002dfe <fork+0xe8>
      np->ofile[i] = filedup(p->ofile[i]);
    80002dd2:	fe043703          	ld	a4,-32(s0)
    80002dd6:	fec42783          	lw	a5,-20(s0)
    80002dda:	07e9                	addi	a5,a5,26
    80002ddc:	078e                	slli	a5,a5,0x3
    80002dde:	97ba                	add	a5,a5,a4
    80002de0:	639c                	ld	a5,0(a5)
    80002de2:	853e                	mv	a0,a5
    80002de4:	00004097          	auipc	ra,0x4
    80002de8:	9ec080e7          	jalr	-1556(ra) # 800067d0 <filedup>
    80002dec:	86aa                	mv	a3,a0
    80002dee:	fd843703          	ld	a4,-40(s0)
    80002df2:	fec42783          	lw	a5,-20(s0)
    80002df6:	07e9                	addi	a5,a5,26
    80002df8:	078e                	slli	a5,a5,0x3
    80002dfa:	97ba                	add	a5,a5,a4
    80002dfc:	e394                	sd	a3,0(a5)
  for(i = 0; i < NOFILE; i++)
    80002dfe:	fec42783          	lw	a5,-20(s0)
    80002e02:	2785                	addiw	a5,a5,1
    80002e04:	fef42623          	sw	a5,-20(s0)
    80002e08:	fec42783          	lw	a5,-20(s0)
    80002e0c:	0007871b          	sext.w	a4,a5
    80002e10:	47bd                	li	a5,15
    80002e12:	fae7d7e3          	bge	a5,a4,80002dc0 <fork+0xaa>
  np->cwd = idup(p->cwd);
    80002e16:	fe043783          	ld	a5,-32(s0)
    80002e1a:	1507b783          	ld	a5,336(a5)
    80002e1e:	853e                	mv	a0,a5
    80002e20:	00002097          	auipc	ra,0x2
    80002e24:	29c080e7          	jalr	668(ra) # 800050bc <idup>
    80002e28:	872a                	mv	a4,a0
    80002e2a:	fd843783          	ld	a5,-40(s0)
    80002e2e:	14e7b823          	sd	a4,336(a5)

  safestrcpy(np->name, p->name, sizeof(p->name));
    80002e32:	fd843783          	ld	a5,-40(s0)
    80002e36:	15878713          	addi	a4,a5,344
    80002e3a:	fe043783          	ld	a5,-32(s0)
    80002e3e:	15878793          	addi	a5,a5,344
    80002e42:	4641                	li	a2,16
    80002e44:	85be                	mv	a1,a5
    80002e46:	853a                	mv	a0,a4
    80002e48:	fffff097          	auipc	ra,0xfffff
    80002e4c:	90e080e7          	jalr	-1778(ra) # 80001756 <safestrcpy>

  pid = np->pid;
    80002e50:	fd843783          	ld	a5,-40(s0)
    80002e54:	5b9c                	lw	a5,48(a5)
    80002e56:	fcf42a23          	sw	a5,-44(s0)

  release(&np->lock);
    80002e5a:	fd843783          	ld	a5,-40(s0)
    80002e5e:	853e                	mv	a0,a5
    80002e60:	ffffe097          	auipc	ra,0xffffe
    80002e64:	482080e7          	jalr	1154(ra) # 800012e2 <release>

  acquire(&wait_lock);
    80002e68:	00019517          	auipc	a0,0x19
    80002e6c:	0b850513          	addi	a0,a0,184 # 8001bf20 <wait_lock>
    80002e70:	ffffe097          	auipc	ra,0xffffe
    80002e74:	40e080e7          	jalr	1038(ra) # 8000127e <acquire>
  np->parent = p;
    80002e78:	fd843783          	ld	a5,-40(s0)
    80002e7c:	fe043703          	ld	a4,-32(s0)
    80002e80:	ff98                	sd	a4,56(a5)
  release(&wait_lock);
    80002e82:	00019517          	auipc	a0,0x19
    80002e86:	09e50513          	addi	a0,a0,158 # 8001bf20 <wait_lock>
    80002e8a:	ffffe097          	auipc	ra,0xffffe
    80002e8e:	458080e7          	jalr	1112(ra) # 800012e2 <release>

  acquire(&np->lock);
    80002e92:	fd843783          	ld	a5,-40(s0)
    80002e96:	853e                	mv	a0,a5
    80002e98:	ffffe097          	auipc	ra,0xffffe
    80002e9c:	3e6080e7          	jalr	998(ra) # 8000127e <acquire>
  np->state = RUNNABLE;
    80002ea0:	fd843783          	ld	a5,-40(s0)
    80002ea4:	470d                	li	a4,3
    80002ea6:	cf98                	sw	a4,24(a5)
  release(&np->lock);
    80002ea8:	fd843783          	ld	a5,-40(s0)
    80002eac:	853e                	mv	a0,a5
    80002eae:	ffffe097          	auipc	ra,0xffffe
    80002eb2:	434080e7          	jalr	1076(ra) # 800012e2 <release>

  return pid;
    80002eb6:	fd442783          	lw	a5,-44(s0)
}
    80002eba:	853e                	mv	a0,a5
    80002ebc:	70a2                	ld	ra,40(sp)
    80002ebe:	7402                	ld	s0,32(sp)
    80002ec0:	6145                	addi	sp,sp,48
    80002ec2:	8082                	ret

0000000080002ec4 <reparent>:

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
    80002ec4:	7179                	addi	sp,sp,-48
    80002ec6:	f406                	sd	ra,40(sp)
    80002ec8:	f022                	sd	s0,32(sp)
    80002eca:	1800                	addi	s0,sp,48
    80002ecc:	fca43c23          	sd	a0,-40(s0)
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002ed0:	00013797          	auipc	a5,0x13
    80002ed4:	63878793          	addi	a5,a5,1592 # 80016508 <proc>
    80002ed8:	fef43423          	sd	a5,-24(s0)
    80002edc:	a081                	j	80002f1c <reparent+0x58>
    if(pp->parent == p){
    80002ede:	fe843783          	ld	a5,-24(s0)
    80002ee2:	7f9c                	ld	a5,56(a5)
    80002ee4:	fd843703          	ld	a4,-40(s0)
    80002ee8:	02f71463          	bne	a4,a5,80002f10 <reparent+0x4c>
      pp->parent = initproc;
    80002eec:	0000b797          	auipc	a5,0xb
    80002ef0:	fa478793          	addi	a5,a5,-92 # 8000de90 <initproc>
    80002ef4:	6398                	ld	a4,0(a5)
    80002ef6:	fe843783          	ld	a5,-24(s0)
    80002efa:	ff98                	sd	a4,56(a5)
      wakeup(initproc);
    80002efc:	0000b797          	auipc	a5,0xb
    80002f00:	f9478793          	addi	a5,a5,-108 # 8000de90 <initproc>
    80002f04:	639c                	ld	a5,0(a5)
    80002f06:	853e                	mv	a0,a5
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	57c080e7          	jalr	1404(ra) # 80003484 <wakeup>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002f10:	fe843783          	ld	a5,-24(s0)
    80002f14:	16878793          	addi	a5,a5,360
    80002f18:	fef43423          	sd	a5,-24(s0)
    80002f1c:	fe843703          	ld	a4,-24(s0)
    80002f20:	00019797          	auipc	a5,0x19
    80002f24:	fe878793          	addi	a5,a5,-24 # 8001bf08 <pid_lock>
    80002f28:	faf76be3          	bltu	a4,a5,80002ede <reparent+0x1a>
    }
  }
}
    80002f2c:	0001                	nop
    80002f2e:	0001                	nop
    80002f30:	70a2                	ld	ra,40(sp)
    80002f32:	7402                	ld	s0,32(sp)
    80002f34:	6145                	addi	sp,sp,48
    80002f36:	8082                	ret

0000000080002f38 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
    80002f38:	7139                	addi	sp,sp,-64
    80002f3a:	fc06                	sd	ra,56(sp)
    80002f3c:	f822                	sd	s0,48(sp)
    80002f3e:	0080                	addi	s0,sp,64
    80002f40:	87aa                	mv	a5,a0
    80002f42:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	900080e7          	jalr	-1792(ra) # 80002846 <myproc>
    80002f4e:	fea43023          	sd	a0,-32(s0)

  if(p == initproc)
    80002f52:	0000b797          	auipc	a5,0xb
    80002f56:	f3e78793          	addi	a5,a5,-194 # 8000de90 <initproc>
    80002f5a:	639c                	ld	a5,0(a5)
    80002f5c:	fe043703          	ld	a4,-32(s0)
    80002f60:	00f71a63          	bne	a4,a5,80002f74 <exit+0x3c>
    panic("init exiting");
    80002f64:	00008517          	auipc	a0,0x8
    80002f68:	29c50513          	addi	a0,a0,668 # 8000b200 <etext+0x200>
    80002f6c:	ffffe097          	auipc	ra,0xffffe
    80002f70:	d1e080e7          	jalr	-738(ra) # 80000c8a <panic>

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    80002f74:	fe042623          	sw	zero,-20(s0)
    80002f78:	a881                	j	80002fc8 <exit+0x90>
    if(p->ofile[fd]){
    80002f7a:	fe043703          	ld	a4,-32(s0)
    80002f7e:	fec42783          	lw	a5,-20(s0)
    80002f82:	07e9                	addi	a5,a5,26
    80002f84:	078e                	slli	a5,a5,0x3
    80002f86:	97ba                	add	a5,a5,a4
    80002f88:	639c                	ld	a5,0(a5)
    80002f8a:	cb95                	beqz	a5,80002fbe <exit+0x86>
      struct file *f = p->ofile[fd];
    80002f8c:	fe043703          	ld	a4,-32(s0)
    80002f90:	fec42783          	lw	a5,-20(s0)
    80002f94:	07e9                	addi	a5,a5,26
    80002f96:	078e                	slli	a5,a5,0x3
    80002f98:	97ba                	add	a5,a5,a4
    80002f9a:	639c                	ld	a5,0(a5)
    80002f9c:	fcf43c23          	sd	a5,-40(s0)
      fileclose(f);
    80002fa0:	fd843503          	ld	a0,-40(s0)
    80002fa4:	00004097          	auipc	ra,0x4
    80002fa8:	892080e7          	jalr	-1902(ra) # 80006836 <fileclose>
      p->ofile[fd] = 0;
    80002fac:	fe043703          	ld	a4,-32(s0)
    80002fb0:	fec42783          	lw	a5,-20(s0)
    80002fb4:	07e9                	addi	a5,a5,26
    80002fb6:	078e                	slli	a5,a5,0x3
    80002fb8:	97ba                	add	a5,a5,a4
    80002fba:	0007b023          	sd	zero,0(a5)
  for(int fd = 0; fd < NOFILE; fd++){
    80002fbe:	fec42783          	lw	a5,-20(s0)
    80002fc2:	2785                	addiw	a5,a5,1
    80002fc4:	fef42623          	sw	a5,-20(s0)
    80002fc8:	fec42783          	lw	a5,-20(s0)
    80002fcc:	0007871b          	sext.w	a4,a5
    80002fd0:	47bd                	li	a5,15
    80002fd2:	fae7d4e3          	bge	a5,a4,80002f7a <exit+0x42>
    }
  }

  begin_op();
    80002fd6:	00003097          	auipc	ra,0x3
    80002fda:	1c6080e7          	jalr	454(ra) # 8000619c <begin_op>
  iput(p->cwd);
    80002fde:	fe043783          	ld	a5,-32(s0)
    80002fe2:	1507b783          	ld	a5,336(a5)
    80002fe6:	853e                	mv	a0,a5
    80002fe8:	00002097          	auipc	ra,0x2
    80002fec:	2ae080e7          	jalr	686(ra) # 80005296 <iput>
  end_op();
    80002ff0:	00003097          	auipc	ra,0x3
    80002ff4:	26e080e7          	jalr	622(ra) # 8000625e <end_op>
  p->cwd = 0;
    80002ff8:	fe043783          	ld	a5,-32(s0)
    80002ffc:	1407b823          	sd	zero,336(a5)

  acquire(&wait_lock);
    80003000:	00019517          	auipc	a0,0x19
    80003004:	f2050513          	addi	a0,a0,-224 # 8001bf20 <wait_lock>
    80003008:	ffffe097          	auipc	ra,0xffffe
    8000300c:	276080e7          	jalr	630(ra) # 8000127e <acquire>

  // Give any children to init.
  reparent(p);
    80003010:	fe043503          	ld	a0,-32(s0)
    80003014:	00000097          	auipc	ra,0x0
    80003018:	eb0080e7          	jalr	-336(ra) # 80002ec4 <reparent>

  // Parent might be sleeping in wait().
  wakeup(p->parent);
    8000301c:	fe043783          	ld	a5,-32(s0)
    80003020:	7f9c                	ld	a5,56(a5)
    80003022:	853e                	mv	a0,a5
    80003024:	00000097          	auipc	ra,0x0
    80003028:	460080e7          	jalr	1120(ra) # 80003484 <wakeup>
  
  acquire(&p->lock);
    8000302c:	fe043783          	ld	a5,-32(s0)
    80003030:	853e                	mv	a0,a5
    80003032:	ffffe097          	auipc	ra,0xffffe
    80003036:	24c080e7          	jalr	588(ra) # 8000127e <acquire>

  p->xstate = status;
    8000303a:	fe043783          	ld	a5,-32(s0)
    8000303e:	fcc42703          	lw	a4,-52(s0)
    80003042:	d7d8                	sw	a4,44(a5)
  p->state = ZOMBIE;
    80003044:	fe043783          	ld	a5,-32(s0)
    80003048:	4715                	li	a4,5
    8000304a:	cf98                	sw	a4,24(a5)

  release(&wait_lock);
    8000304c:	00019517          	auipc	a0,0x19
    80003050:	ed450513          	addi	a0,a0,-300 # 8001bf20 <wait_lock>
    80003054:	ffffe097          	auipc	ra,0xffffe
    80003058:	28e080e7          	jalr	654(ra) # 800012e2 <release>

  // Jump into the scheduler, never to return.
  sched();
    8000305c:	00000097          	auipc	ra,0x0
    80003060:	230080e7          	jalr	560(ra) # 8000328c <sched>
  panic("zombie exit");
    80003064:	00008517          	auipc	a0,0x8
    80003068:	1ac50513          	addi	a0,a0,428 # 8000b210 <etext+0x210>
    8000306c:	ffffe097          	auipc	ra,0xffffe
    80003070:	c1e080e7          	jalr	-994(ra) # 80000c8a <panic>

0000000080003074 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
    80003074:	7139                	addi	sp,sp,-64
    80003076:	fc06                	sd	ra,56(sp)
    80003078:	f822                	sd	s0,48(sp)
    8000307a:	0080                	addi	s0,sp,64
    8000307c:	fca43423          	sd	a0,-56(s0)
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	7c6080e7          	jalr	1990(ra) # 80002846 <myproc>
    80003088:	fca43c23          	sd	a0,-40(s0)

  acquire(&wait_lock);
    8000308c:	00019517          	auipc	a0,0x19
    80003090:	e9450513          	addi	a0,a0,-364 # 8001bf20 <wait_lock>
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	1ea080e7          	jalr	490(ra) # 8000127e <acquire>

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    8000309c:	fe042223          	sw	zero,-28(s0)
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800030a0:	00013797          	auipc	a5,0x13
    800030a4:	46878793          	addi	a5,a5,1128 # 80016508 <proc>
    800030a8:	fef43423          	sd	a5,-24(s0)
    800030ac:	a8d1                	j	80003180 <wait+0x10c>
      if(pp->parent == p){
    800030ae:	fe843783          	ld	a5,-24(s0)
    800030b2:	7f9c                	ld	a5,56(a5)
    800030b4:	fd843703          	ld	a4,-40(s0)
    800030b8:	0af71e63          	bne	a4,a5,80003174 <wait+0x100>
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);
    800030bc:	fe843783          	ld	a5,-24(s0)
    800030c0:	853e                	mv	a0,a5
    800030c2:	ffffe097          	auipc	ra,0xffffe
    800030c6:	1bc080e7          	jalr	444(ra) # 8000127e <acquire>

        havekids = 1;
    800030ca:	4785                	li	a5,1
    800030cc:	fef42223          	sw	a5,-28(s0)
        if(pp->state == ZOMBIE){
    800030d0:	fe843783          	ld	a5,-24(s0)
    800030d4:	4f9c                	lw	a5,24(a5)
    800030d6:	873e                	mv	a4,a5
    800030d8:	4795                	li	a5,5
    800030da:	08f71663          	bne	a4,a5,80003166 <wait+0xf2>
          // Found one.
          pid = pp->pid;
    800030de:	fe843783          	ld	a5,-24(s0)
    800030e2:	5b9c                	lw	a5,48(a5)
    800030e4:	fcf42a23          	sw	a5,-44(s0)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800030e8:	fc843783          	ld	a5,-56(s0)
    800030ec:	c7a9                	beqz	a5,80003136 <wait+0xc2>
    800030ee:	fd843783          	ld	a5,-40(s0)
    800030f2:	6bb8                	ld	a4,80(a5)
    800030f4:	fe843783          	ld	a5,-24(s0)
    800030f8:	02c78793          	addi	a5,a5,44
    800030fc:	4691                	li	a3,4
    800030fe:	863e                	mv	a2,a5
    80003100:	fc843583          	ld	a1,-56(s0)
    80003104:	853a                	mv	a0,a4
    80003106:	fffff097          	auipc	ra,0xfffff
    8000310a:	20a080e7          	jalr	522(ra) # 80002310 <copyout>
    8000310e:	87aa                	mv	a5,a0
    80003110:	0207d363          	bgez	a5,80003136 <wait+0xc2>
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
    80003114:	fe843783          	ld	a5,-24(s0)
    80003118:	853e                	mv	a0,a5
    8000311a:	ffffe097          	auipc	ra,0xffffe
    8000311e:	1c8080e7          	jalr	456(ra) # 800012e2 <release>
            release(&wait_lock);
    80003122:	00019517          	auipc	a0,0x19
    80003126:	dfe50513          	addi	a0,a0,-514 # 8001bf20 <wait_lock>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	1b8080e7          	jalr	440(ra) # 800012e2 <release>
            return -1;
    80003132:	57fd                	li	a5,-1
    80003134:	a879                	j	800031d2 <wait+0x15e>
          }
          freeproc(pp);
    80003136:	fe843503          	ld	a0,-24(s0)
    8000313a:	00000097          	auipc	ra,0x0
    8000313e:	8d0080e7          	jalr	-1840(ra) # 80002a0a <freeproc>
          release(&pp->lock);
    80003142:	fe843783          	ld	a5,-24(s0)
    80003146:	853e                	mv	a0,a5
    80003148:	ffffe097          	auipc	ra,0xffffe
    8000314c:	19a080e7          	jalr	410(ra) # 800012e2 <release>
          release(&wait_lock);
    80003150:	00019517          	auipc	a0,0x19
    80003154:	dd050513          	addi	a0,a0,-560 # 8001bf20 <wait_lock>
    80003158:	ffffe097          	auipc	ra,0xffffe
    8000315c:	18a080e7          	jalr	394(ra) # 800012e2 <release>
          return pid;
    80003160:	fd442783          	lw	a5,-44(s0)
    80003164:	a0bd                	j	800031d2 <wait+0x15e>
        }
        release(&pp->lock);
    80003166:	fe843783          	ld	a5,-24(s0)
    8000316a:	853e                	mv	a0,a5
    8000316c:	ffffe097          	auipc	ra,0xffffe
    80003170:	176080e7          	jalr	374(ra) # 800012e2 <release>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003174:	fe843783          	ld	a5,-24(s0)
    80003178:	16878793          	addi	a5,a5,360
    8000317c:	fef43423          	sd	a5,-24(s0)
    80003180:	fe843703          	ld	a4,-24(s0)
    80003184:	00019797          	auipc	a5,0x19
    80003188:	d8478793          	addi	a5,a5,-636 # 8001bf08 <pid_lock>
    8000318c:	f2f761e3          	bltu	a4,a5,800030ae <wait+0x3a>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
    80003190:	fe442783          	lw	a5,-28(s0)
    80003194:	2781                	sext.w	a5,a5
    80003196:	cb89                	beqz	a5,800031a8 <wait+0x134>
    80003198:	fd843503          	ld	a0,-40(s0)
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	456080e7          	jalr	1110(ra) # 800035f2 <killed>
    800031a4:	87aa                	mv	a5,a0
    800031a6:	cb99                	beqz	a5,800031bc <wait+0x148>
      release(&wait_lock);
    800031a8:	00019517          	auipc	a0,0x19
    800031ac:	d7850513          	addi	a0,a0,-648 # 8001bf20 <wait_lock>
    800031b0:	ffffe097          	auipc	ra,0xffffe
    800031b4:	132080e7          	jalr	306(ra) # 800012e2 <release>
      return -1;
    800031b8:	57fd                	li	a5,-1
    800031ba:	a821                	j	800031d2 <wait+0x15e>
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800031bc:	00019597          	auipc	a1,0x19
    800031c0:	d6458593          	addi	a1,a1,-668 # 8001bf20 <wait_lock>
    800031c4:	fd843503          	ld	a0,-40(s0)
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	240080e7          	jalr	576(ra) # 80003408 <sleep>
    havekids = 0;
    800031d0:	b5f1                	j	8000309c <wait+0x28>
  }
}
    800031d2:	853e                	mv	a0,a5
    800031d4:	70e2                	ld	ra,56(sp)
    800031d6:	7442                	ld	s0,48(sp)
    800031d8:	6121                	addi	sp,sp,64
    800031da:	8082                	ret

00000000800031dc <scheduler>:
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
    800031dc:	1101                	addi	sp,sp,-32
    800031de:	ec06                	sd	ra,24(sp)
    800031e0:	e822                	sd	s0,16(sp)
    800031e2:	1000                	addi	s0,sp,32
  struct proc *p;
  struct cpu *c = mycpu();
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	628080e7          	jalr	1576(ra) # 8000280c <mycpu>
    800031ec:	fea43023          	sd	a0,-32(s0)
  
  c->proc = 0;
    800031f0:	fe043783          	ld	a5,-32(s0)
    800031f4:	0007b023          	sd	zero,0(a5)
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	3f6080e7          	jalr	1014(ra) # 800025ee <intr_on>

    for(p = proc; p < &proc[NPROC]; p++) {
    80003200:	00013797          	auipc	a5,0x13
    80003204:	30878793          	addi	a5,a5,776 # 80016508 <proc>
    80003208:	fef43423          	sd	a5,-24(s0)
    8000320c:	a0bd                	j	8000327a <scheduler+0x9e>
      acquire(&p->lock);
    8000320e:	fe843783          	ld	a5,-24(s0)
    80003212:	853e                	mv	a0,a5
    80003214:	ffffe097          	auipc	ra,0xffffe
    80003218:	06a080e7          	jalr	106(ra) # 8000127e <acquire>
      if(p->state == RUNNABLE) {
    8000321c:	fe843783          	ld	a5,-24(s0)
    80003220:	4f9c                	lw	a5,24(a5)
    80003222:	873e                	mv	a4,a5
    80003224:	478d                	li	a5,3
    80003226:	02f71d63          	bne	a4,a5,80003260 <scheduler+0x84>
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
    8000322a:	fe843783          	ld	a5,-24(s0)
    8000322e:	4711                	li	a4,4
    80003230:	cf98                	sw	a4,24(a5)
        c->proc = p;
    80003232:	fe043783          	ld	a5,-32(s0)
    80003236:	fe843703          	ld	a4,-24(s0)
    8000323a:	e398                	sd	a4,0(a5)
        swtch(&c->context, &p->context);
    8000323c:	fe043783          	ld	a5,-32(s0)
    80003240:	00878713          	addi	a4,a5,8
    80003244:	fe843783          	ld	a5,-24(s0)
    80003248:	06078793          	addi	a5,a5,96
    8000324c:	85be                	mv	a1,a5
    8000324e:	853a                	mv	a0,a4
    80003250:	00000097          	auipc	ra,0x0
    80003254:	66e080e7          	jalr	1646(ra) # 800038be <swtch>

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
    80003258:	fe043783          	ld	a5,-32(s0)
    8000325c:	0007b023          	sd	zero,0(a5)
      }
      release(&p->lock);
    80003260:	fe843783          	ld	a5,-24(s0)
    80003264:	853e                	mv	a0,a5
    80003266:	ffffe097          	auipc	ra,0xffffe
    8000326a:	07c080e7          	jalr	124(ra) # 800012e2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000326e:	fe843783          	ld	a5,-24(s0)
    80003272:	16878793          	addi	a5,a5,360
    80003276:	fef43423          	sd	a5,-24(s0)
    8000327a:	fe843703          	ld	a4,-24(s0)
    8000327e:	00019797          	auipc	a5,0x19
    80003282:	c8a78793          	addi	a5,a5,-886 # 8001bf08 <pid_lock>
    80003286:	f8f764e3          	bltu	a4,a5,8000320e <scheduler+0x32>
    intr_on();
    8000328a:	b7bd                	j	800031f8 <scheduler+0x1c>

000000008000328c <sched>:
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
    8000328c:	7179                	addi	sp,sp,-48
    8000328e:	f406                	sd	ra,40(sp)
    80003290:	f022                	sd	s0,32(sp)
    80003292:	ec26                	sd	s1,24(sp)
    80003294:	1800                	addi	s0,sp,48
  int intena;
  struct proc *p = myproc();
    80003296:	fffff097          	auipc	ra,0xfffff
    8000329a:	5b0080e7          	jalr	1456(ra) # 80002846 <myproc>
    8000329e:	fca43c23          	sd	a0,-40(s0)

  if(!holding(&p->lock))
    800032a2:	fd843783          	ld	a5,-40(s0)
    800032a6:	853e                	mv	a0,a5
    800032a8:	ffffe097          	auipc	ra,0xffffe
    800032ac:	090080e7          	jalr	144(ra) # 80001338 <holding>
    800032b0:	87aa                	mv	a5,a0
    800032b2:	eb89                	bnez	a5,800032c4 <sched+0x38>
    panic("sched p->lock");
    800032b4:	00008517          	auipc	a0,0x8
    800032b8:	f6c50513          	addi	a0,a0,-148 # 8000b220 <etext+0x220>
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	9ce080e7          	jalr	-1586(ra) # 80000c8a <panic>
  if(mycpu()->noff != 1)
    800032c4:	fffff097          	auipc	ra,0xfffff
    800032c8:	548080e7          	jalr	1352(ra) # 8000280c <mycpu>
    800032cc:	87aa                	mv	a5,a0
    800032ce:	5fbc                	lw	a5,120(a5)
    800032d0:	873e                	mv	a4,a5
    800032d2:	4785                	li	a5,1
    800032d4:	00f70a63          	beq	a4,a5,800032e8 <sched+0x5c>
    panic("sched locks");
    800032d8:	00008517          	auipc	a0,0x8
    800032dc:	f5850513          	addi	a0,a0,-168 # 8000b230 <etext+0x230>
    800032e0:	ffffe097          	auipc	ra,0xffffe
    800032e4:	9aa080e7          	jalr	-1622(ra) # 80000c8a <panic>
  if(p->state == RUNNING)
    800032e8:	fd843783          	ld	a5,-40(s0)
    800032ec:	4f9c                	lw	a5,24(a5)
    800032ee:	873e                	mv	a4,a5
    800032f0:	4791                	li	a5,4
    800032f2:	00f71a63          	bne	a4,a5,80003306 <sched+0x7a>
    panic("sched running");
    800032f6:	00008517          	auipc	a0,0x8
    800032fa:	f4a50513          	addi	a0,a0,-182 # 8000b240 <etext+0x240>
    800032fe:	ffffe097          	auipc	ra,0xffffe
    80003302:	98c080e7          	jalr	-1652(ra) # 80000c8a <panic>
  if(intr_get())
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	312080e7          	jalr	786(ra) # 80002618 <intr_get>
    8000330e:	87aa                	mv	a5,a0
    80003310:	cb89                	beqz	a5,80003322 <sched+0x96>
    panic("sched interruptible");
    80003312:	00008517          	auipc	a0,0x8
    80003316:	f3e50513          	addi	a0,a0,-194 # 8000b250 <etext+0x250>
    8000331a:	ffffe097          	auipc	ra,0xffffe
    8000331e:	970080e7          	jalr	-1680(ra) # 80000c8a <panic>

  intena = mycpu()->intena;
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	4ea080e7          	jalr	1258(ra) # 8000280c <mycpu>
    8000332a:	87aa                	mv	a5,a0
    8000332c:	5ffc                	lw	a5,124(a5)
    8000332e:	fcf42a23          	sw	a5,-44(s0)
  swtch(&p->context, &mycpu()->context);
    80003332:	fd843783          	ld	a5,-40(s0)
    80003336:	06078493          	addi	s1,a5,96
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	4d2080e7          	jalr	1234(ra) # 8000280c <mycpu>
    80003342:	87aa                	mv	a5,a0
    80003344:	07a1                	addi	a5,a5,8
    80003346:	85be                	mv	a1,a5
    80003348:	8526                	mv	a0,s1
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	574080e7          	jalr	1396(ra) # 800038be <swtch>
  mycpu()->intena = intena;
    80003352:	fffff097          	auipc	ra,0xfffff
    80003356:	4ba080e7          	jalr	1210(ra) # 8000280c <mycpu>
    8000335a:	872a                	mv	a4,a0
    8000335c:	fd442783          	lw	a5,-44(s0)
    80003360:	df7c                	sw	a5,124(a4)
}
    80003362:	0001                	nop
    80003364:	70a2                	ld	ra,40(sp)
    80003366:	7402                	ld	s0,32(sp)
    80003368:	64e2                	ld	s1,24(sp)
    8000336a:	6145                	addi	sp,sp,48
    8000336c:	8082                	ret

000000008000336e <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
    8000336e:	1101                	addi	sp,sp,-32
    80003370:	ec06                	sd	ra,24(sp)
    80003372:	e822                	sd	s0,16(sp)
    80003374:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003376:	fffff097          	auipc	ra,0xfffff
    8000337a:	4d0080e7          	jalr	1232(ra) # 80002846 <myproc>
    8000337e:	fea43423          	sd	a0,-24(s0)
  acquire(&p->lock);
    80003382:	fe843783          	ld	a5,-24(s0)
    80003386:	853e                	mv	a0,a5
    80003388:	ffffe097          	auipc	ra,0xffffe
    8000338c:	ef6080e7          	jalr	-266(ra) # 8000127e <acquire>
  p->state = RUNNABLE;
    80003390:	fe843783          	ld	a5,-24(s0)
    80003394:	470d                	li	a4,3
    80003396:	cf98                	sw	a4,24(a5)
  sched();
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	ef4080e7          	jalr	-268(ra) # 8000328c <sched>
  release(&p->lock);
    800033a0:	fe843783          	ld	a5,-24(s0)
    800033a4:	853e                	mv	a0,a5
    800033a6:	ffffe097          	auipc	ra,0xffffe
    800033aa:	f3c080e7          	jalr	-196(ra) # 800012e2 <release>
}
    800033ae:	0001                	nop
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	486080e7          	jalr	1158(ra) # 80002846 <myproc>
    800033c8:	87aa                	mv	a5,a0
    800033ca:	853e                	mv	a0,a5
    800033cc:	ffffe097          	auipc	ra,0xffffe
    800033d0:	f16080e7          	jalr	-234(ra) # 800012e2 <release>

  if (first) {
    800033d4:	0000b797          	auipc	a5,0xb
    800033d8:	93078793          	addi	a5,a5,-1744 # 8000dd04 <first.1>
    800033dc:	439c                	lw	a5,0(a5)
    800033de:	cf81                	beqz	a5,800033f6 <forkret+0x3e>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    800033e0:	0000b797          	auipc	a5,0xb
    800033e4:	92478793          	addi	a5,a5,-1756 # 8000dd04 <first.1>
    800033e8:	0007a023          	sw	zero,0(a5)
    fsinit(ROOTDEV);
    800033ec:	4505                	li	a0,1
    800033ee:	00001097          	auipc	ra,0x1
    800033f2:	5bc080e7          	jalr	1468(ra) # 800049aa <fsinit>
  }

  usertrapret();
    800033f6:	00001097          	auipc	ra,0x1
    800033fa:	87a080e7          	jalr	-1926(ra) # 80003c70 <usertrapret>
}
    800033fe:	0001                	nop
    80003400:	60a2                	ld	ra,8(sp)
    80003402:	6402                	ld	s0,0(sp)
    80003404:	0141                	addi	sp,sp,16
    80003406:	8082                	ret

0000000080003408 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80003408:	7179                	addi	sp,sp,-48
    8000340a:	f406                	sd	ra,40(sp)
    8000340c:	f022                	sd	s0,32(sp)
    8000340e:	1800                	addi	s0,sp,48
    80003410:	fca43c23          	sd	a0,-40(s0)
    80003414:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	42e080e7          	jalr	1070(ra) # 80002846 <myproc>
    80003420:	fea43423          	sd	a0,-24(s0)
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80003424:	fe843783          	ld	a5,-24(s0)
    80003428:	853e                	mv	a0,a5
    8000342a:	ffffe097          	auipc	ra,0xffffe
    8000342e:	e54080e7          	jalr	-428(ra) # 8000127e <acquire>
  release(lk);
    80003432:	fd043503          	ld	a0,-48(s0)
    80003436:	ffffe097          	auipc	ra,0xffffe
    8000343a:	eac080e7          	jalr	-340(ra) # 800012e2 <release>

  // Go to sleep.
  p->chan = chan;
    8000343e:	fe843783          	ld	a5,-24(s0)
    80003442:	fd843703          	ld	a4,-40(s0)
    80003446:	f398                	sd	a4,32(a5)
  p->state = SLEEPING;
    80003448:	fe843783          	ld	a5,-24(s0)
    8000344c:	4709                	li	a4,2
    8000344e:	cf98                	sw	a4,24(a5)

  sched();
    80003450:	00000097          	auipc	ra,0x0
    80003454:	e3c080e7          	jalr	-452(ra) # 8000328c <sched>

  // Tidy up.
  p->chan = 0;
    80003458:	fe843783          	ld	a5,-24(s0)
    8000345c:	0207b023          	sd	zero,32(a5)

  // Reacquire original lock.
  release(&p->lock);
    80003460:	fe843783          	ld	a5,-24(s0)
    80003464:	853e                	mv	a0,a5
    80003466:	ffffe097          	auipc	ra,0xffffe
    8000346a:	e7c080e7          	jalr	-388(ra) # 800012e2 <release>
  acquire(lk);
    8000346e:	fd043503          	ld	a0,-48(s0)
    80003472:	ffffe097          	auipc	ra,0xffffe
    80003476:	e0c080e7          	jalr	-500(ra) # 8000127e <acquire>
}
    8000347a:	0001                	nop
    8000347c:	70a2                	ld	ra,40(sp)
    8000347e:	7402                	ld	s0,32(sp)
    80003480:	6145                	addi	sp,sp,48
    80003482:	8082                	ret

0000000080003484 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80003484:	7179                	addi	sp,sp,-48
    80003486:	f406                	sd	ra,40(sp)
    80003488:	f022                	sd	s0,32(sp)
    8000348a:	1800                	addi	s0,sp,48
    8000348c:	fca43c23          	sd	a0,-40(s0)
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80003490:	00013797          	auipc	a5,0x13
    80003494:	07878793          	addi	a5,a5,120 # 80016508 <proc>
    80003498:	fef43423          	sd	a5,-24(s0)
    8000349c:	a085                	j	800034fc <wakeup+0x78>
    if(p != myproc()){
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	3a8080e7          	jalr	936(ra) # 80002846 <myproc>
    800034a6:	872a                	mv	a4,a0
    800034a8:	fe843783          	ld	a5,-24(s0)
    800034ac:	04e78263          	beq	a5,a4,800034f0 <wakeup+0x6c>
      acquire(&p->lock);
    800034b0:	fe843783          	ld	a5,-24(s0)
    800034b4:	853e                	mv	a0,a5
    800034b6:	ffffe097          	auipc	ra,0xffffe
    800034ba:	dc8080e7          	jalr	-568(ra) # 8000127e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800034be:	fe843783          	ld	a5,-24(s0)
    800034c2:	4f9c                	lw	a5,24(a5)
    800034c4:	873e                	mv	a4,a5
    800034c6:	4789                	li	a5,2
    800034c8:	00f71d63          	bne	a4,a5,800034e2 <wakeup+0x5e>
    800034cc:	fe843783          	ld	a5,-24(s0)
    800034d0:	739c                	ld	a5,32(a5)
    800034d2:	fd843703          	ld	a4,-40(s0)
    800034d6:	00f71663          	bne	a4,a5,800034e2 <wakeup+0x5e>
        p->state = RUNNABLE;
    800034da:	fe843783          	ld	a5,-24(s0)
    800034de:	470d                	li	a4,3
    800034e0:	cf98                	sw	a4,24(a5)
      }
      release(&p->lock);
    800034e2:	fe843783          	ld	a5,-24(s0)
    800034e6:	853e                	mv	a0,a5
    800034e8:	ffffe097          	auipc	ra,0xffffe
    800034ec:	dfa080e7          	jalr	-518(ra) # 800012e2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800034f0:	fe843783          	ld	a5,-24(s0)
    800034f4:	16878793          	addi	a5,a5,360
    800034f8:	fef43423          	sd	a5,-24(s0)
    800034fc:	fe843703          	ld	a4,-24(s0)
    80003500:	00019797          	auipc	a5,0x19
    80003504:	a0878793          	addi	a5,a5,-1528 # 8001bf08 <pid_lock>
    80003508:	f8f76be3          	bltu	a4,a5,8000349e <wakeup+0x1a>
    }
  }
}
    8000350c:	0001                	nop
    8000350e:	0001                	nop
    80003510:	70a2                	ld	ra,40(sp)
    80003512:	7402                	ld	s0,32(sp)
    80003514:	6145                	addi	sp,sp,48
    80003516:	8082                	ret

0000000080003518 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80003518:	7179                	addi	sp,sp,-48
    8000351a:	f406                	sd	ra,40(sp)
    8000351c:	f022                	sd	s0,32(sp)
    8000351e:	1800                	addi	s0,sp,48
    80003520:	87aa                	mv	a5,a0
    80003522:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80003526:	00013797          	auipc	a5,0x13
    8000352a:	fe278793          	addi	a5,a5,-30 # 80016508 <proc>
    8000352e:	fef43423          	sd	a5,-24(s0)
    80003532:	a0ad                	j	8000359c <kill+0x84>
    acquire(&p->lock);
    80003534:	fe843783          	ld	a5,-24(s0)
    80003538:	853e                	mv	a0,a5
    8000353a:	ffffe097          	auipc	ra,0xffffe
    8000353e:	d44080e7          	jalr	-700(ra) # 8000127e <acquire>
    if(p->pid == pid){
    80003542:	fe843783          	ld	a5,-24(s0)
    80003546:	5b98                	lw	a4,48(a5)
    80003548:	fdc42783          	lw	a5,-36(s0)
    8000354c:	2781                	sext.w	a5,a5
    8000354e:	02e79a63          	bne	a5,a4,80003582 <kill+0x6a>
      p->killed = 1;
    80003552:	fe843783          	ld	a5,-24(s0)
    80003556:	4705                	li	a4,1
    80003558:	d798                	sw	a4,40(a5)
      if(p->state == SLEEPING){
    8000355a:	fe843783          	ld	a5,-24(s0)
    8000355e:	4f9c                	lw	a5,24(a5)
    80003560:	873e                	mv	a4,a5
    80003562:	4789                	li	a5,2
    80003564:	00f71663          	bne	a4,a5,80003570 <kill+0x58>
        // Wake process from sleep().
        p->state = RUNNABLE;
    80003568:	fe843783          	ld	a5,-24(s0)
    8000356c:	470d                	li	a4,3
    8000356e:	cf98                	sw	a4,24(a5)
      }
      release(&p->lock);
    80003570:	fe843783          	ld	a5,-24(s0)
    80003574:	853e                	mv	a0,a5
    80003576:	ffffe097          	auipc	ra,0xffffe
    8000357a:	d6c080e7          	jalr	-660(ra) # 800012e2 <release>
      return 0;
    8000357e:	4781                	li	a5,0
    80003580:	a03d                	j	800035ae <kill+0x96>
    }
    release(&p->lock);
    80003582:	fe843783          	ld	a5,-24(s0)
    80003586:	853e                	mv	a0,a5
    80003588:	ffffe097          	auipc	ra,0xffffe
    8000358c:	d5a080e7          	jalr	-678(ra) # 800012e2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80003590:	fe843783          	ld	a5,-24(s0)
    80003594:	16878793          	addi	a5,a5,360
    80003598:	fef43423          	sd	a5,-24(s0)
    8000359c:	fe843703          	ld	a4,-24(s0)
    800035a0:	00019797          	auipc	a5,0x19
    800035a4:	96878793          	addi	a5,a5,-1688 # 8001bf08 <pid_lock>
    800035a8:	f8f766e3          	bltu	a4,a5,80003534 <kill+0x1c>
  }
  return -1;
    800035ac:	57fd                	li	a5,-1
}
    800035ae:	853e                	mv	a0,a5
    800035b0:	70a2                	ld	ra,40(sp)
    800035b2:	7402                	ld	s0,32(sp)
    800035b4:	6145                	addi	sp,sp,48
    800035b6:	8082                	ret

00000000800035b8 <setkilled>:

void
setkilled(struct proc *p)
{
    800035b8:	1101                	addi	sp,sp,-32
    800035ba:	ec06                	sd	ra,24(sp)
    800035bc:	e822                	sd	s0,16(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	fea43423          	sd	a0,-24(s0)
  acquire(&p->lock);
    800035c4:	fe843783          	ld	a5,-24(s0)
    800035c8:	853e                	mv	a0,a5
    800035ca:	ffffe097          	auipc	ra,0xffffe
    800035ce:	cb4080e7          	jalr	-844(ra) # 8000127e <acquire>
  p->killed = 1;
    800035d2:	fe843783          	ld	a5,-24(s0)
    800035d6:	4705                	li	a4,1
    800035d8:	d798                	sw	a4,40(a5)
  release(&p->lock);
    800035da:	fe843783          	ld	a5,-24(s0)
    800035de:	853e                	mv	a0,a5
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	d02080e7          	jalr	-766(ra) # 800012e2 <release>
}
    800035e8:	0001                	nop
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	6105                	addi	sp,sp,32
    800035f0:	8082                	ret

00000000800035f2 <killed>:

int
killed(struct proc *p)
{
    800035f2:	7179                	addi	sp,sp,-48
    800035f4:	f406                	sd	ra,40(sp)
    800035f6:	f022                	sd	s0,32(sp)
    800035f8:	1800                	addi	s0,sp,48
    800035fa:	fca43c23          	sd	a0,-40(s0)
  int k;
  
  acquire(&p->lock);
    800035fe:	fd843783          	ld	a5,-40(s0)
    80003602:	853e                	mv	a0,a5
    80003604:	ffffe097          	auipc	ra,0xffffe
    80003608:	c7a080e7          	jalr	-902(ra) # 8000127e <acquire>
  k = p->killed;
    8000360c:	fd843783          	ld	a5,-40(s0)
    80003610:	579c                	lw	a5,40(a5)
    80003612:	fef42623          	sw	a5,-20(s0)
  release(&p->lock);
    80003616:	fd843783          	ld	a5,-40(s0)
    8000361a:	853e                	mv	a0,a5
    8000361c:	ffffe097          	auipc	ra,0xffffe
    80003620:	cc6080e7          	jalr	-826(ra) # 800012e2 <release>
  return k;
    80003624:	fec42783          	lw	a5,-20(s0)
}
    80003628:	853e                	mv	a0,a5
    8000362a:	70a2                	ld	ra,40(sp)
    8000362c:	7402                	ld	s0,32(sp)
    8000362e:	6145                	addi	sp,sp,48
    80003630:	8082                	ret

0000000080003632 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80003632:	7139                	addi	sp,sp,-64
    80003634:	fc06                	sd	ra,56(sp)
    80003636:	f822                	sd	s0,48(sp)
    80003638:	0080                	addi	s0,sp,64
    8000363a:	87aa                	mv	a5,a0
    8000363c:	fcb43823          	sd	a1,-48(s0)
    80003640:	fcc43423          	sd	a2,-56(s0)
    80003644:	fcd43023          	sd	a3,-64(s0)
    80003648:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	1fa080e7          	jalr	506(ra) # 80002846 <myproc>
    80003654:	fea43423          	sd	a0,-24(s0)
  if(user_dst){
    80003658:	fdc42783          	lw	a5,-36(s0)
    8000365c:	2781                	sext.w	a5,a5
    8000365e:	c38d                	beqz	a5,80003680 <either_copyout+0x4e>
    return copyout(p->pagetable, dst, src, len);
    80003660:	fe843783          	ld	a5,-24(s0)
    80003664:	6bbc                	ld	a5,80(a5)
    80003666:	fc043683          	ld	a3,-64(s0)
    8000366a:	fc843603          	ld	a2,-56(s0)
    8000366e:	fd043583          	ld	a1,-48(s0)
    80003672:	853e                	mv	a0,a5
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	c9c080e7          	jalr	-868(ra) # 80002310 <copyout>
    8000367c:	87aa                	mv	a5,a0
    8000367e:	a839                	j	8000369c <either_copyout+0x6a>
  } else {
    memmove((char *)dst, src, len);
    80003680:	fd043783          	ld	a5,-48(s0)
    80003684:	fc043703          	ld	a4,-64(s0)
    80003688:	2701                	sext.w	a4,a4
    8000368a:	863a                	mv	a2,a4
    8000368c:	fc843583          	ld	a1,-56(s0)
    80003690:	853e                	mv	a0,a5
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	ea4080e7          	jalr	-348(ra) # 80001536 <memmove>
    return 0;
    8000369a:	4781                	li	a5,0
  }
}
    8000369c:	853e                	mv	a0,a5
    8000369e:	70e2                	ld	ra,56(sp)
    800036a0:	7442                	ld	s0,48(sp)
    800036a2:	6121                	addi	sp,sp,64
    800036a4:	8082                	ret

00000000800036a6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800036a6:	7139                	addi	sp,sp,-64
    800036a8:	fc06                	sd	ra,56(sp)
    800036aa:	f822                	sd	s0,48(sp)
    800036ac:	0080                	addi	s0,sp,64
    800036ae:	fca43c23          	sd	a0,-40(s0)
    800036b2:	87ae                	mv	a5,a1
    800036b4:	fcc43423          	sd	a2,-56(s0)
    800036b8:	fcd43023          	sd	a3,-64(s0)
    800036bc:	fcf42a23          	sw	a5,-44(s0)
  struct proc *p = myproc();
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	186080e7          	jalr	390(ra) # 80002846 <myproc>
    800036c8:	fea43423          	sd	a0,-24(s0)
  if(user_src){
    800036cc:	fd442783          	lw	a5,-44(s0)
    800036d0:	2781                	sext.w	a5,a5
    800036d2:	c38d                	beqz	a5,800036f4 <either_copyin+0x4e>
    return copyin(p->pagetable, dst, src, len);
    800036d4:	fe843783          	ld	a5,-24(s0)
    800036d8:	6bbc                	ld	a5,80(a5)
    800036da:	fc043683          	ld	a3,-64(s0)
    800036de:	fc843603          	ld	a2,-56(s0)
    800036e2:	fd843583          	ld	a1,-40(s0)
    800036e6:	853e                	mv	a0,a5
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	cf6080e7          	jalr	-778(ra) # 800023de <copyin>
    800036f0:	87aa                	mv	a5,a0
    800036f2:	a839                	j	80003710 <either_copyin+0x6a>
  } else {
    memmove(dst, (char*)src, len);
    800036f4:	fc843783          	ld	a5,-56(s0)
    800036f8:	fc043703          	ld	a4,-64(s0)
    800036fc:	2701                	sext.w	a4,a4
    800036fe:	863a                	mv	a2,a4
    80003700:	85be                	mv	a1,a5
    80003702:	fd843503          	ld	a0,-40(s0)
    80003706:	ffffe097          	auipc	ra,0xffffe
    8000370a:	e30080e7          	jalr	-464(ra) # 80001536 <memmove>
    return 0;
    8000370e:	4781                	li	a5,0
  }
}
    80003710:	853e                	mv	a0,a5
    80003712:	70e2                	ld	ra,56(sp)
    80003714:	7442                	ld	s0,48(sp)
    80003716:	6121                	addi	sp,sp,64
    80003718:	8082                	ret

000000008000371a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000371a:	1101                	addi	sp,sp,-32
    8000371c:	ec06                	sd	ra,24(sp)
    8000371e:	e822                	sd	s0,16(sp)
    80003720:	1000                	addi	s0,sp,32
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80003722:	00008517          	auipc	a0,0x8
    80003726:	b4650513          	addi	a0,a0,-1210 # 8000b268 <etext+0x268>
    8000372a:	ffffd097          	auipc	ra,0xffffd
    8000372e:	30a080e7          	jalr	778(ra) # 80000a34 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80003732:	00013797          	auipc	a5,0x13
    80003736:	dd678793          	addi	a5,a5,-554 # 80016508 <proc>
    8000373a:	fef43423          	sd	a5,-24(s0)
    8000373e:	a04d                	j	800037e0 <procdump+0xc6>
    if(p->state == UNUSED)
    80003740:	fe843783          	ld	a5,-24(s0)
    80003744:	4f9c                	lw	a5,24(a5)
    80003746:	c7d1                	beqz	a5,800037d2 <procdump+0xb8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80003748:	fe843783          	ld	a5,-24(s0)
    8000374c:	4f9c                	lw	a5,24(a5)
    8000374e:	873e                	mv	a4,a5
    80003750:	4795                	li	a5,5
    80003752:	02e7ee63          	bltu	a5,a4,8000378e <procdump+0x74>
    80003756:	fe843783          	ld	a5,-24(s0)
    8000375a:	4f9c                	lw	a5,24(a5)
    8000375c:	0000a717          	auipc	a4,0xa
    80003760:	60470713          	addi	a4,a4,1540 # 8000dd60 <states.0>
    80003764:	1782                	slli	a5,a5,0x20
    80003766:	9381                	srli	a5,a5,0x20
    80003768:	078e                	slli	a5,a5,0x3
    8000376a:	97ba                	add	a5,a5,a4
    8000376c:	639c                	ld	a5,0(a5)
    8000376e:	c385                	beqz	a5,8000378e <procdump+0x74>
      state = states[p->state];
    80003770:	fe843783          	ld	a5,-24(s0)
    80003774:	4f9c                	lw	a5,24(a5)
    80003776:	0000a717          	auipc	a4,0xa
    8000377a:	5ea70713          	addi	a4,a4,1514 # 8000dd60 <states.0>
    8000377e:	1782                	slli	a5,a5,0x20
    80003780:	9381                	srli	a5,a5,0x20
    80003782:	078e                	slli	a5,a5,0x3
    80003784:	97ba                	add	a5,a5,a4
    80003786:	639c                	ld	a5,0(a5)
    80003788:	fef43023          	sd	a5,-32(s0)
    8000378c:	a039                	j	8000379a <procdump+0x80>
    else
      state = "???";
    8000378e:	00008797          	auipc	a5,0x8
    80003792:	ae278793          	addi	a5,a5,-1310 # 8000b270 <etext+0x270>
    80003796:	fef43023          	sd	a5,-32(s0)
    printf("%d %s %s", p->pid, state, p->name);
    8000379a:	fe843783          	ld	a5,-24(s0)
    8000379e:	5b98                	lw	a4,48(a5)
    800037a0:	fe843783          	ld	a5,-24(s0)
    800037a4:	15878793          	addi	a5,a5,344
    800037a8:	86be                	mv	a3,a5
    800037aa:	fe043603          	ld	a2,-32(s0)
    800037ae:	85ba                	mv	a1,a4
    800037b0:	00008517          	auipc	a0,0x8
    800037b4:	ac850513          	addi	a0,a0,-1336 # 8000b278 <etext+0x278>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	27c080e7          	jalr	636(ra) # 80000a34 <printf>
    printf("\n");
    800037c0:	00008517          	auipc	a0,0x8
    800037c4:	aa850513          	addi	a0,a0,-1368 # 8000b268 <etext+0x268>
    800037c8:	ffffd097          	auipc	ra,0xffffd
    800037cc:	26c080e7          	jalr	620(ra) # 80000a34 <printf>
    800037d0:	a011                	j	800037d4 <procdump+0xba>
      continue;
    800037d2:	0001                	nop
  for(p = proc; p < &proc[NPROC]; p++){
    800037d4:	fe843783          	ld	a5,-24(s0)
    800037d8:	16878793          	addi	a5,a5,360
    800037dc:	fef43423          	sd	a5,-24(s0)
    800037e0:	fe843703          	ld	a4,-24(s0)
    800037e4:	00018797          	auipc	a5,0x18
    800037e8:	72478793          	addi	a5,a5,1828 # 8001bf08 <pid_lock>
    800037ec:	f4f76ae3          	bltu	a4,a5,80003740 <procdump+0x26>
  }
}
    800037f0:	0001                	nop
    800037f2:	0001                	nop
    800037f4:	60e2                	ld	ra,24(sp)
    800037f6:	6442                	ld	s0,16(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret

00000000800037fc <getprocs>:
void
getprocs(void){
    800037fc:	7179                	addi	sp,sp,-48
    800037fe:	f406                	sd	ra,40(sp)
    80003800:	f022                	sd	s0,32(sp)
    80003802:	1800                	addi	s0,sp,48
  struct proc *p;
  char name[16];
  int pid;
  int state;

  for(p = proc; p < &proc[NPROC]; p++){
    80003804:	00013797          	auipc	a5,0x13
    80003808:	d0478793          	addi	a5,a5,-764 # 80016508 <proc>
    8000380c:	fef43423          	sd	a5,-24(s0)
    80003810:	a849                	j	800038a2 <getprocs+0xa6>

    acquire(&p->lock);
    80003812:	fe843783          	ld	a5,-24(s0)
    80003816:	853e                	mv	a0,a5
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	a66080e7          	jalr	-1434(ra) # 8000127e <acquire>

    if(p->state != UNUSED){
    80003820:	fe843783          	ld	a5,-24(s0)
    80003824:	4f9c                	lw	a5,24(a5)
    80003826:	c3a5                	beqz	a5,80003886 <getprocs+0x8a>
      safestrcpy(name, p->name, sizeof(name)); //Rather copy than wait for printf() due to locking.
    80003828:	fe843783          	ld	a5,-24(s0)
    8000382c:	15878713          	addi	a4,a5,344
    80003830:	fd040793          	addi	a5,s0,-48
    80003834:	4641                	li	a2,16
    80003836:	85ba                	mv	a1,a4
    80003838:	853e                	mv	a0,a5
    8000383a:	ffffe097          	auipc	ra,0xffffe
    8000383e:	f1c080e7          	jalr	-228(ra) # 80001756 <safestrcpy>
      pid = p->pid;
    80003842:	fe843783          	ld	a5,-24(s0)
    80003846:	5b9c                	lw	a5,48(a5)
    80003848:	fef42223          	sw	a5,-28(s0)
      state = p->state;
    8000384c:	fe843783          	ld	a5,-24(s0)
    80003850:	4f9c                	lw	a5,24(a5)
    80003852:	fef42023          	sw	a5,-32(s0)
    }
    else{
      release(&p->lock);
      continue;
    }
    release(&p->lock);
    80003856:	fe843783          	ld	a5,-24(s0)
    8000385a:	853e                	mv	a0,a5
    8000385c:	ffffe097          	auipc	ra,0xffffe
    80003860:	a86080e7          	jalr	-1402(ra) # 800012e2 <release>
    
    printf("%s (%d): %d \n", name,  pid, state);
    80003864:	fe042683          	lw	a3,-32(s0)
    80003868:	fe442703          	lw	a4,-28(s0)
    8000386c:	fd040793          	addi	a5,s0,-48
    80003870:	863a                	mv	a2,a4
    80003872:	85be                	mv	a1,a5
    80003874:	00008517          	auipc	a0,0x8
    80003878:	a1450513          	addi	a0,a0,-1516 # 8000b288 <etext+0x288>
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	1b8080e7          	jalr	440(ra) # 80000a34 <printf>
    80003884:	a809                	j	80003896 <getprocs+0x9a>
      release(&p->lock);
    80003886:	fe843783          	ld	a5,-24(s0)
    8000388a:	853e                	mv	a0,a5
    8000388c:	ffffe097          	auipc	ra,0xffffe
    80003890:	a56080e7          	jalr	-1450(ra) # 800012e2 <release>
      continue;
    80003894:	0001                	nop
  for(p = proc; p < &proc[NPROC]; p++){
    80003896:	fe843783          	ld	a5,-24(s0)
    8000389a:	16878793          	addi	a5,a5,360
    8000389e:	fef43423          	sd	a5,-24(s0)
    800038a2:	fe843703          	ld	a4,-24(s0)
    800038a6:	00018797          	auipc	a5,0x18
    800038aa:	66278793          	addi	a5,a5,1634 # 8001bf08 <pid_lock>
    800038ae:	f6f762e3          	bltu	a4,a5,80003812 <getprocs+0x16>
  }
}
    800038b2:	0001                	nop
    800038b4:	0001                	nop
    800038b6:	70a2                	ld	ra,40(sp)
    800038b8:	7402                	ld	s0,32(sp)
    800038ba:	6145                	addi	sp,sp,48
    800038bc:	8082                	ret

00000000800038be <swtch>:
    800038be:	00153023          	sd	ra,0(a0)
    800038c2:	00253423          	sd	sp,8(a0)
    800038c6:	e900                	sd	s0,16(a0)
    800038c8:	ed04                	sd	s1,24(a0)
    800038ca:	03253023          	sd	s2,32(a0)
    800038ce:	03353423          	sd	s3,40(a0)
    800038d2:	03453823          	sd	s4,48(a0)
    800038d6:	03553c23          	sd	s5,56(a0)
    800038da:	05653023          	sd	s6,64(a0)
    800038de:	05753423          	sd	s7,72(a0)
    800038e2:	05853823          	sd	s8,80(a0)
    800038e6:	05953c23          	sd	s9,88(a0)
    800038ea:	07a53023          	sd	s10,96(a0)
    800038ee:	07b53423          	sd	s11,104(a0)
    800038f2:	0005b083          	ld	ra,0(a1)
    800038f6:	0085b103          	ld	sp,8(a1)
    800038fa:	6980                	ld	s0,16(a1)
    800038fc:	6d84                	ld	s1,24(a1)
    800038fe:	0205b903          	ld	s2,32(a1)
    80003902:	0285b983          	ld	s3,40(a1)
    80003906:	0305ba03          	ld	s4,48(a1)
    8000390a:	0385ba83          	ld	s5,56(a1)
    8000390e:	0405bb03          	ld	s6,64(a1)
    80003912:	0485bb83          	ld	s7,72(a1)
    80003916:	0505bc03          	ld	s8,80(a1)
    8000391a:	0585bc83          	ld	s9,88(a1)
    8000391e:	0605bd03          	ld	s10,96(a1)
    80003922:	0685bd83          	ld	s11,104(a1)
    80003926:	8082                	ret

0000000080003928 <r_sstatus>:
{
    80003928:	1101                	addi	sp,sp,-32
    8000392a:	ec22                	sd	s0,24(sp)
    8000392c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000392e:	100027f3          	csrr	a5,sstatus
    80003932:	fef43423          	sd	a5,-24(s0)
  return x;
    80003936:	fe843783          	ld	a5,-24(s0)
}
    8000393a:	853e                	mv	a0,a5
    8000393c:	6462                	ld	s0,24(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret

0000000080003942 <w_sstatus>:
{
    80003942:	1101                	addi	sp,sp,-32
    80003944:	ec22                	sd	s0,24(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000394c:	fe843783          	ld	a5,-24(s0)
    80003950:	10079073          	csrw	sstatus,a5
}
    80003954:	0001                	nop
    80003956:	6462                	ld	s0,24(sp)
    80003958:	6105                	addi	sp,sp,32
    8000395a:	8082                	ret

000000008000395c <r_sip>:
{
    8000395c:	1101                	addi	sp,sp,-32
    8000395e:	ec22                	sd	s0,24(sp)
    80003960:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003962:	144027f3          	csrr	a5,sip
    80003966:	fef43423          	sd	a5,-24(s0)
  return x;
    8000396a:	fe843783          	ld	a5,-24(s0)
}
    8000396e:	853e                	mv	a0,a5
    80003970:	6462                	ld	s0,24(sp)
    80003972:	6105                	addi	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <w_sip>:
{
    80003976:	1101                	addi	sp,sp,-32
    80003978:	ec22                	sd	s0,24(sp)
    8000397a:	1000                	addi	s0,sp,32
    8000397c:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sip, %0" : : "r" (x));
    80003980:	fe843783          	ld	a5,-24(s0)
    80003984:	14479073          	csrw	sip,a5
}
    80003988:	0001                	nop
    8000398a:	6462                	ld	s0,24(sp)
    8000398c:	6105                	addi	sp,sp,32
    8000398e:	8082                	ret

0000000080003990 <w_sepc>:
{
    80003990:	1101                	addi	sp,sp,-32
    80003992:	ec22                	sd	s0,24(sp)
    80003994:	1000                	addi	s0,sp,32
    80003996:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000399a:	fe843783          	ld	a5,-24(s0)
    8000399e:	14179073          	csrw	sepc,a5
}
    800039a2:	0001                	nop
    800039a4:	6462                	ld	s0,24(sp)
    800039a6:	6105                	addi	sp,sp,32
    800039a8:	8082                	ret

00000000800039aa <r_sepc>:
{
    800039aa:	1101                	addi	sp,sp,-32
    800039ac:	ec22                	sd	s0,24(sp)
    800039ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800039b0:	141027f3          	csrr	a5,sepc
    800039b4:	fef43423          	sd	a5,-24(s0)
  return x;
    800039b8:	fe843783          	ld	a5,-24(s0)
}
    800039bc:	853e                	mv	a0,a5
    800039be:	6462                	ld	s0,24(sp)
    800039c0:	6105                	addi	sp,sp,32
    800039c2:	8082                	ret

00000000800039c4 <w_stvec>:
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec22                	sd	s0,24(sp)
    800039c8:	1000                	addi	s0,sp,32
    800039ca:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw stvec, %0" : : "r" (x));
    800039ce:	fe843783          	ld	a5,-24(s0)
    800039d2:	10579073          	csrw	stvec,a5
}
    800039d6:	0001                	nop
    800039d8:	6462                	ld	s0,24(sp)
    800039da:	6105                	addi	sp,sp,32
    800039dc:	8082                	ret

00000000800039de <r_satp>:
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec22                	sd	s0,24(sp)
    800039e2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, satp" : "=r" (x) );
    800039e4:	180027f3          	csrr	a5,satp
    800039e8:	fef43423          	sd	a5,-24(s0)
  return x;
    800039ec:	fe843783          	ld	a5,-24(s0)
}
    800039f0:	853e                	mv	a0,a5
    800039f2:	6462                	ld	s0,24(sp)
    800039f4:	6105                	addi	sp,sp,32
    800039f6:	8082                	ret

00000000800039f8 <r_scause>:
{
    800039f8:	1101                	addi	sp,sp,-32
    800039fa:	ec22                	sd	s0,24(sp)
    800039fc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800039fe:	142027f3          	csrr	a5,scause
    80003a02:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a06:	fe843783          	ld	a5,-24(s0)
}
    80003a0a:	853e                	mv	a0,a5
    80003a0c:	6462                	ld	s0,24(sp)
    80003a0e:	6105                	addi	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <r_stval>:
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec22                	sd	s0,24(sp)
    80003a16:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003a18:	143027f3          	csrr	a5,stval
    80003a1c:	fef43423          	sd	a5,-24(s0)
  return x;
    80003a20:	fe843783          	ld	a5,-24(s0)
}
    80003a24:	853e                	mv	a0,a5
    80003a26:	6462                	ld	s0,24(sp)
    80003a28:	6105                	addi	sp,sp,32
    80003a2a:	8082                	ret

0000000080003a2c <intr_on>:
{
    80003a2c:	1141                	addi	sp,sp,-16
    80003a2e:	e406                	sd	ra,8(sp)
    80003a30:	e022                	sd	s0,0(sp)
    80003a32:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	ef4080e7          	jalr	-268(ra) # 80003928 <r_sstatus>
    80003a3c:	87aa                	mv	a5,a0
    80003a3e:	0027e793          	ori	a5,a5,2
    80003a42:	853e                	mv	a0,a5
    80003a44:	00000097          	auipc	ra,0x0
    80003a48:	efe080e7          	jalr	-258(ra) # 80003942 <w_sstatus>
}
    80003a4c:	0001                	nop
    80003a4e:	60a2                	ld	ra,8(sp)
    80003a50:	6402                	ld	s0,0(sp)
    80003a52:	0141                	addi	sp,sp,16
    80003a54:	8082                	ret

0000000080003a56 <intr_off>:
{
    80003a56:	1141                	addi	sp,sp,-16
    80003a58:	e406                	sd	ra,8(sp)
    80003a5a:	e022                	sd	s0,0(sp)
    80003a5c:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003a5e:	00000097          	auipc	ra,0x0
    80003a62:	eca080e7          	jalr	-310(ra) # 80003928 <r_sstatus>
    80003a66:	87aa                	mv	a5,a0
    80003a68:	9bf5                	andi	a5,a5,-3
    80003a6a:	853e                	mv	a0,a5
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	ed6080e7          	jalr	-298(ra) # 80003942 <w_sstatus>
}
    80003a74:	0001                	nop
    80003a76:	60a2                	ld	ra,8(sp)
    80003a78:	6402                	ld	s0,0(sp)
    80003a7a:	0141                	addi	sp,sp,16
    80003a7c:	8082                	ret

0000000080003a7e <intr_get>:
{
    80003a7e:	1101                	addi	sp,sp,-32
    80003a80:	ec06                	sd	ra,24(sp)
    80003a82:	e822                	sd	s0,16(sp)
    80003a84:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80003a86:	00000097          	auipc	ra,0x0
    80003a8a:	ea2080e7          	jalr	-350(ra) # 80003928 <r_sstatus>
    80003a8e:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80003a92:	fe843783          	ld	a5,-24(s0)
    80003a96:	8b89                	andi	a5,a5,2
    80003a98:	00f037b3          	snez	a5,a5
    80003a9c:	0ff7f793          	zext.b	a5,a5
    80003aa0:	2781                	sext.w	a5,a5
}
    80003aa2:	853e                	mv	a0,a5
    80003aa4:	60e2                	ld	ra,24(sp)
    80003aa6:	6442                	ld	s0,16(sp)
    80003aa8:	6105                	addi	sp,sp,32
    80003aaa:	8082                	ret

0000000080003aac <r_tp>:
{
    80003aac:	1101                	addi	sp,sp,-32
    80003aae:	ec22                	sd	s0,24(sp)
    80003ab0:	1000                	addi	s0,sp,32
  asm volatile("mv %0, tp" : "=r" (x) );
    80003ab2:	8792                	mv	a5,tp
    80003ab4:	fef43423          	sd	a5,-24(s0)
  return x;
    80003ab8:	fe843783          	ld	a5,-24(s0)
}
    80003abc:	853e                	mv	a0,a5
    80003abe:	6462                	ld	s0,24(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret

0000000080003ac4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003ac4:	1141                	addi	sp,sp,-16
    80003ac6:	e406                	sd	ra,8(sp)
    80003ac8:	e022                	sd	s0,0(sp)
    80003aca:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003acc:	00008597          	auipc	a1,0x8
    80003ad0:	80458593          	addi	a1,a1,-2044 # 8000b2d0 <etext+0x2d0>
    80003ad4:	00018517          	auipc	a0,0x18
    80003ad8:	46450513          	addi	a0,a0,1124 # 8001bf38 <tickslock>
    80003adc:	ffffd097          	auipc	ra,0xffffd
    80003ae0:	772080e7          	jalr	1906(ra) # 8000124e <initlock>
}
    80003ae4:	0001                	nop
    80003ae6:	60a2                	ld	ra,8(sp)
    80003ae8:	6402                	ld	s0,0(sp)
    80003aea:	0141                	addi	sp,sp,16
    80003aec:	8082                	ret

0000000080003aee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003aee:	1141                	addi	sp,sp,-16
    80003af0:	e406                	sd	ra,8(sp)
    80003af2:	e022                	sd	s0,0(sp)
    80003af4:	0800                	addi	s0,sp,16
  w_stvec((uint64)kernelvec);
    80003af6:	00005797          	auipc	a5,0x5
    80003afa:	d6a78793          	addi	a5,a5,-662 # 80008860 <kernelvec>
    80003afe:	853e                	mv	a0,a5
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	ec4080e7          	jalr	-316(ra) # 800039c4 <w_stvec>
}
    80003b08:	0001                	nop
    80003b0a:	60a2                	ld	ra,8(sp)
    80003b0c:	6402                	ld	s0,0(sp)
    80003b0e:	0141                	addi	sp,sp,16
    80003b10:	8082                	ret

0000000080003b12 <usertrap>:
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
    80003b12:	7179                	addi	sp,sp,-48
    80003b14:	f406                	sd	ra,40(sp)
    80003b16:	f022                	sd	s0,32(sp)
    80003b18:	ec26                	sd	s1,24(sp)
    80003b1a:	1800                	addi	s0,sp,48
  int which_dev = 0;
    80003b1c:	fc042e23          	sw	zero,-36(s0)

  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	e08080e7          	jalr	-504(ra) # 80003928 <r_sstatus>
    80003b28:	87aa                	mv	a5,a0
    80003b2a:	1007f793          	andi	a5,a5,256
    80003b2e:	cb89                	beqz	a5,80003b40 <usertrap+0x2e>
    panic("usertrap: not from user mode");
    80003b30:	00007517          	auipc	a0,0x7
    80003b34:	7a850513          	addi	a0,a0,1960 # 8000b2d8 <etext+0x2d8>
    80003b38:	ffffd097          	auipc	ra,0xffffd
    80003b3c:	152080e7          	jalr	338(ra) # 80000c8a <panic>

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);
    80003b40:	00005797          	auipc	a5,0x5
    80003b44:	d2078793          	addi	a5,a5,-736 # 80008860 <kernelvec>
    80003b48:	853e                	mv	a0,a5
    80003b4a:	00000097          	auipc	ra,0x0
    80003b4e:	e7a080e7          	jalr	-390(ra) # 800039c4 <w_stvec>

  struct proc *p = myproc();
    80003b52:	fffff097          	auipc	ra,0xfffff
    80003b56:	cf4080e7          	jalr	-780(ra) # 80002846 <myproc>
    80003b5a:	fca43823          	sd	a0,-48(s0)
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
    80003b5e:	fd043783          	ld	a5,-48(s0)
    80003b62:	6fa4                	ld	s1,88(a5)
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	e46080e7          	jalr	-442(ra) # 800039aa <r_sepc>
    80003b6c:	87aa                	mv	a5,a0
    80003b6e:	ec9c                	sd	a5,24(s1)
  
  if(r_scause() == 8){
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	e88080e7          	jalr	-376(ra) # 800039f8 <r_scause>
    80003b78:	872a                	mv	a4,a0
    80003b7a:	47a1                	li	a5,8
    80003b7c:	04f71163          	bne	a4,a5,80003bbe <usertrap+0xac>
    // system call

    if(killed(p))
    80003b80:	fd043503          	ld	a0,-48(s0)
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	a6e080e7          	jalr	-1426(ra) # 800035f2 <killed>
    80003b8c:	87aa                	mv	a5,a0
    80003b8e:	c791                	beqz	a5,80003b9a <usertrap+0x88>
      exit(-1);
    80003b90:	557d                	li	a0,-1
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	3a6080e7          	jalr	934(ra) # 80002f38 <exit>

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;
    80003b9a:	fd043783          	ld	a5,-48(s0)
    80003b9e:	6fbc                	ld	a5,88(a5)
    80003ba0:	6f98                	ld	a4,24(a5)
    80003ba2:	fd043783          	ld	a5,-48(s0)
    80003ba6:	6fbc                	ld	a5,88(a5)
    80003ba8:	0711                	addi	a4,a4,4
    80003baa:	ef98                	sd	a4,24(a5)

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	e80080e7          	jalr	-384(ra) # 80003a2c <intr_on>

    syscall();
    80003bb4:	00000097          	auipc	ra,0x0
    80003bb8:	66c080e7          	jalr	1644(ra) # 80004220 <syscall>
    80003bbc:	a885                	j	80003c2c <usertrap+0x11a>
  } else if((which_dev = devintr()) != 0){
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	34e080e7          	jalr	846(ra) # 80003f0c <devintr>
    80003bc6:	87aa                	mv	a5,a0
    80003bc8:	fcf42e23          	sw	a5,-36(s0)
    80003bcc:	fdc42783          	lw	a5,-36(s0)
    80003bd0:	2781                	sext.w	a5,a5
    80003bd2:	efa9                	bnez	a5,80003c2c <usertrap+0x11a>
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	e24080e7          	jalr	-476(ra) # 800039f8 <r_scause>
    80003bdc:	872a                	mv	a4,a0
    80003bde:	fd043783          	ld	a5,-48(s0)
    80003be2:	5b9c                	lw	a5,48(a5)
    80003be4:	863e                	mv	a2,a5
    80003be6:	85ba                	mv	a1,a4
    80003be8:	00007517          	auipc	a0,0x7
    80003bec:	71050513          	addi	a0,a0,1808 # 8000b2f8 <etext+0x2f8>
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	e44080e7          	jalr	-444(ra) # 80000a34 <printf>
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003bf8:	00000097          	auipc	ra,0x0
    80003bfc:	db2080e7          	jalr	-590(ra) # 800039aa <r_sepc>
    80003c00:	84aa                	mv	s1,a0
    80003c02:	00000097          	auipc	ra,0x0
    80003c06:	e10080e7          	jalr	-496(ra) # 80003a12 <r_stval>
    80003c0a:	87aa                	mv	a5,a0
    80003c0c:	863e                	mv	a2,a5
    80003c0e:	85a6                	mv	a1,s1
    80003c10:	00007517          	auipc	a0,0x7
    80003c14:	71850513          	addi	a0,a0,1816 # 8000b328 <etext+0x328>
    80003c18:	ffffd097          	auipc	ra,0xffffd
    80003c1c:	e1c080e7          	jalr	-484(ra) # 80000a34 <printf>
    setkilled(p);
    80003c20:	fd043503          	ld	a0,-48(s0)
    80003c24:	00000097          	auipc	ra,0x0
    80003c28:	994080e7          	jalr	-1644(ra) # 800035b8 <setkilled>
  }

  if(killed(p))
    80003c2c:	fd043503          	ld	a0,-48(s0)
    80003c30:	00000097          	auipc	ra,0x0
    80003c34:	9c2080e7          	jalr	-1598(ra) # 800035f2 <killed>
    80003c38:	87aa                	mv	a5,a0
    80003c3a:	c791                	beqz	a5,80003c46 <usertrap+0x134>
    exit(-1);
    80003c3c:	557d                	li	a0,-1
    80003c3e:	fffff097          	auipc	ra,0xfffff
    80003c42:	2fa080e7          	jalr	762(ra) # 80002f38 <exit>

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    80003c46:	fdc42783          	lw	a5,-36(s0)
    80003c4a:	0007871b          	sext.w	a4,a5
    80003c4e:	4789                	li	a5,2
    80003c50:	00f71663          	bne	a4,a5,80003c5c <usertrap+0x14a>
    yield();
    80003c54:	fffff097          	auipc	ra,0xfffff
    80003c58:	71a080e7          	jalr	1818(ra) # 8000336e <yield>

  usertrapret();
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	014080e7          	jalr	20(ra) # 80003c70 <usertrapret>
}
    80003c64:	0001                	nop
    80003c66:	70a2                	ld	ra,40(sp)
    80003c68:	7402                	ld	s0,32(sp)
    80003c6a:	64e2                	ld	s1,24(sp)
    80003c6c:	6145                	addi	sp,sp,48
    80003c6e:	8082                	ret

0000000080003c70 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003c70:	715d                	addi	sp,sp,-80
    80003c72:	e486                	sd	ra,72(sp)
    80003c74:	e0a2                	sd	s0,64(sp)
    80003c76:	fc26                	sd	s1,56(sp)
    80003c78:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	bcc080e7          	jalr	-1076(ra) # 80002846 <myproc>
    80003c82:	fca43c23          	sd	a0,-40(s0)

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();
    80003c86:	00000097          	auipc	ra,0x0
    80003c8a:	dd0080e7          	jalr	-560(ra) # 80003a56 <intr_off>

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003c8e:	00006717          	auipc	a4,0x6
    80003c92:	37270713          	addi	a4,a4,882 # 8000a000 <_trampoline>
    80003c96:	00006797          	auipc	a5,0x6
    80003c9a:	36a78793          	addi	a5,a5,874 # 8000a000 <_trampoline>
    80003c9e:	8f1d                	sub	a4,a4,a5
    80003ca0:	040007b7          	lui	a5,0x4000
    80003ca4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003ca6:	07b2                	slli	a5,a5,0xc
    80003ca8:	97ba                	add	a5,a5,a4
    80003caa:	fcf43823          	sd	a5,-48(s0)
  w_stvec(trampoline_uservec);
    80003cae:	fd043503          	ld	a0,-48(s0)
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	d12080e7          	jalr	-750(ra) # 800039c4 <w_stvec>

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003cba:	fd843783          	ld	a5,-40(s0)
    80003cbe:	6fa4                	ld	s1,88(a5)
    80003cc0:	00000097          	auipc	ra,0x0
    80003cc4:	d1e080e7          	jalr	-738(ra) # 800039de <r_satp>
    80003cc8:	87aa                	mv	a5,a0
    80003cca:	e09c                	sd	a5,0(s1)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003ccc:	fd843783          	ld	a5,-40(s0)
    80003cd0:	63b4                	ld	a3,64(a5)
    80003cd2:	fd843783          	ld	a5,-40(s0)
    80003cd6:	6fbc                	ld	a5,88(a5)
    80003cd8:	6705                	lui	a4,0x1
    80003cda:	9736                	add	a4,a4,a3
    80003cdc:	e798                	sd	a4,8(a5)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003cde:	fd843783          	ld	a5,-40(s0)
    80003ce2:	6fbc                	ld	a5,88(a5)
    80003ce4:	00000717          	auipc	a4,0x0
    80003ce8:	e2e70713          	addi	a4,a4,-466 # 80003b12 <usertrap>
    80003cec:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003cee:	fd843783          	ld	a5,-40(s0)
    80003cf2:	6fa4                	ld	s1,88(a5)
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	db8080e7          	jalr	-584(ra) # 80003aac <r_tp>
    80003cfc:	87aa                	mv	a5,a0
    80003cfe:	f09c                	sd	a5,32(s1)

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	c28080e7          	jalr	-984(ra) # 80003928 <r_sstatus>
    80003d08:	fca43423          	sd	a0,-56(s0)
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003d0c:	fc843783          	ld	a5,-56(s0)
    80003d10:	eff7f793          	andi	a5,a5,-257
    80003d14:	fcf43423          	sd	a5,-56(s0)
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003d18:	fc843783          	ld	a5,-56(s0)
    80003d1c:	0207e793          	ori	a5,a5,32
    80003d20:	fcf43423          	sd	a5,-56(s0)
  w_sstatus(x);
    80003d24:	fc843503          	ld	a0,-56(s0)
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	c1a080e7          	jalr	-998(ra) # 80003942 <w_sstatus>

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003d30:	fd843783          	ld	a5,-40(s0)
    80003d34:	6fbc                	ld	a5,88(a5)
    80003d36:	6f9c                	ld	a5,24(a5)
    80003d38:	853e                	mv	a0,a5
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	c56080e7          	jalr	-938(ra) # 80003990 <w_sepc>

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003d42:	fd843783          	ld	a5,-40(s0)
    80003d46:	6bbc                	ld	a5,80(a5)
    80003d48:	00c7d713          	srli	a4,a5,0xc
    80003d4c:	57fd                	li	a5,-1
    80003d4e:	17fe                	slli	a5,a5,0x3f
    80003d50:	8fd9                	or	a5,a5,a4
    80003d52:	fcf43023          	sd	a5,-64(s0)

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003d56:	00006717          	auipc	a4,0x6
    80003d5a:	34670713          	addi	a4,a4,838 # 8000a09c <userret>
    80003d5e:	00006797          	auipc	a5,0x6
    80003d62:	2a278793          	addi	a5,a5,674 # 8000a000 <_trampoline>
    80003d66:	8f1d                	sub	a4,a4,a5
    80003d68:	040007b7          	lui	a5,0x4000
    80003d6c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003d6e:	07b2                	slli	a5,a5,0xc
    80003d70:	97ba                	add	a5,a5,a4
    80003d72:	faf43c23          	sd	a5,-72(s0)
  ((void (*)(uint64))trampoline_userret)(satp);
    80003d76:	fb843783          	ld	a5,-72(s0)
    80003d7a:	fc043503          	ld	a0,-64(s0)
    80003d7e:	9782                	jalr	a5
}
    80003d80:	0001                	nop
    80003d82:	60a6                	ld	ra,72(sp)
    80003d84:	6406                	ld	s0,64(sp)
    80003d86:	74e2                	ld	s1,56(sp)
    80003d88:	6161                	addi	sp,sp,80
    80003d8a:	8082                	ret

0000000080003d8c <kerneltrap>:

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
    80003d8c:	7139                	addi	sp,sp,-64
    80003d8e:	fc06                	sd	ra,56(sp)
    80003d90:	f822                	sd	s0,48(sp)
    80003d92:	f426                	sd	s1,40(sp)
    80003d94:	0080                	addi	s0,sp,64
  int which_dev = 0;
    80003d96:	fc042e23          	sw	zero,-36(s0)
  uint64 sepc = r_sepc();
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	c10080e7          	jalr	-1008(ra) # 800039aa <r_sepc>
    80003da2:	fca43823          	sd	a0,-48(s0)
  uint64 sstatus = r_sstatus();
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	b82080e7          	jalr	-1150(ra) # 80003928 <r_sstatus>
    80003dae:	fca43423          	sd	a0,-56(s0)
  uint64 scause = r_scause();
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	c46080e7          	jalr	-954(ra) # 800039f8 <r_scause>
    80003dba:	fca43023          	sd	a0,-64(s0)
  
  if((sstatus & SSTATUS_SPP) == 0)
    80003dbe:	fc843783          	ld	a5,-56(s0)
    80003dc2:	1007f793          	andi	a5,a5,256
    80003dc6:	eb89                	bnez	a5,80003dd8 <kerneltrap+0x4c>
    panic("kerneltrap: not from supervisor mode");
    80003dc8:	00007517          	auipc	a0,0x7
    80003dcc:	58050513          	addi	a0,a0,1408 # 8000b348 <etext+0x348>
    80003dd0:	ffffd097          	auipc	ra,0xffffd
    80003dd4:	eba080e7          	jalr	-326(ra) # 80000c8a <panic>
  if(intr_get() != 0)
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	ca6080e7          	jalr	-858(ra) # 80003a7e <intr_get>
    80003de0:	87aa                	mv	a5,a0
    80003de2:	cb89                	beqz	a5,80003df4 <kerneltrap+0x68>
    panic("kerneltrap: interrupts enabled");
    80003de4:	00007517          	auipc	a0,0x7
    80003de8:	58c50513          	addi	a0,a0,1420 # 8000b370 <etext+0x370>
    80003dec:	ffffd097          	auipc	ra,0xffffd
    80003df0:	e9e080e7          	jalr	-354(ra) # 80000c8a <panic>

  if((which_dev = devintr()) == 0){
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	118080e7          	jalr	280(ra) # 80003f0c <devintr>
    80003dfc:	87aa                	mv	a5,a0
    80003dfe:	fcf42e23          	sw	a5,-36(s0)
    80003e02:	fdc42783          	lw	a5,-36(s0)
    80003e06:	2781                	sext.w	a5,a5
    80003e08:	e7b9                	bnez	a5,80003e56 <kerneltrap+0xca>
    printf("scause %p\n", scause);
    80003e0a:	fc043583          	ld	a1,-64(s0)
    80003e0e:	00007517          	auipc	a0,0x7
    80003e12:	58250513          	addi	a0,a0,1410 # 8000b390 <etext+0x390>
    80003e16:	ffffd097          	auipc	ra,0xffffd
    80003e1a:	c1e080e7          	jalr	-994(ra) # 80000a34 <printf>
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003e1e:	00000097          	auipc	ra,0x0
    80003e22:	b8c080e7          	jalr	-1140(ra) # 800039aa <r_sepc>
    80003e26:	84aa                	mv	s1,a0
    80003e28:	00000097          	auipc	ra,0x0
    80003e2c:	bea080e7          	jalr	-1046(ra) # 80003a12 <r_stval>
    80003e30:	87aa                	mv	a5,a0
    80003e32:	863e                	mv	a2,a5
    80003e34:	85a6                	mv	a1,s1
    80003e36:	00007517          	auipc	a0,0x7
    80003e3a:	56a50513          	addi	a0,a0,1386 # 8000b3a0 <etext+0x3a0>
    80003e3e:	ffffd097          	auipc	ra,0xffffd
    80003e42:	bf6080e7          	jalr	-1034(ra) # 80000a34 <printf>
    panic("kerneltrap");
    80003e46:	00007517          	auipc	a0,0x7
    80003e4a:	57250513          	addi	a0,a0,1394 # 8000b3b8 <etext+0x3b8>
    80003e4e:	ffffd097          	auipc	ra,0xffffd
    80003e52:	e3c080e7          	jalr	-452(ra) # 80000c8a <panic>
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003e56:	fdc42783          	lw	a5,-36(s0)
    80003e5a:	0007871b          	sext.w	a4,a5
    80003e5e:	4789                	li	a5,2
    80003e60:	02f71663          	bne	a4,a5,80003e8c <kerneltrap+0x100>
    80003e64:	fffff097          	auipc	ra,0xfffff
    80003e68:	9e2080e7          	jalr	-1566(ra) # 80002846 <myproc>
    80003e6c:	87aa                	mv	a5,a0
    80003e6e:	cf99                	beqz	a5,80003e8c <kerneltrap+0x100>
    80003e70:	fffff097          	auipc	ra,0xfffff
    80003e74:	9d6080e7          	jalr	-1578(ra) # 80002846 <myproc>
    80003e78:	87aa                	mv	a5,a0
    80003e7a:	4f9c                	lw	a5,24(a5)
    80003e7c:	873e                	mv	a4,a5
    80003e7e:	4791                	li	a5,4
    80003e80:	00f71663          	bne	a4,a5,80003e8c <kerneltrap+0x100>
    yield();
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	4ea080e7          	jalr	1258(ra) # 8000336e <yield>

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
    80003e8c:	fd043503          	ld	a0,-48(s0)
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	b00080e7          	jalr	-1280(ra) # 80003990 <w_sepc>
  w_sstatus(sstatus);
    80003e98:	fc843503          	ld	a0,-56(s0)
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	aa6080e7          	jalr	-1370(ra) # 80003942 <w_sstatus>
}
    80003ea4:	0001                	nop
    80003ea6:	70e2                	ld	ra,56(sp)
    80003ea8:	7442                	ld	s0,48(sp)
    80003eaa:	74a2                	ld	s1,40(sp)
    80003eac:	6121                	addi	sp,sp,64
    80003eae:	8082                	ret

0000000080003eb0 <clockintr>:

void
clockintr()
{
    80003eb0:	1141                	addi	sp,sp,-16
    80003eb2:	e406                	sd	ra,8(sp)
    80003eb4:	e022                	sd	s0,0(sp)
    80003eb6:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80003eb8:	00018517          	auipc	a0,0x18
    80003ebc:	08050513          	addi	a0,a0,128 # 8001bf38 <tickslock>
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	3be080e7          	jalr	958(ra) # 8000127e <acquire>
  ticks++;
    80003ec8:	0000a797          	auipc	a5,0xa
    80003ecc:	fd078793          	addi	a5,a5,-48 # 8000de98 <ticks>
    80003ed0:	439c                	lw	a5,0(a5)
    80003ed2:	2785                	addiw	a5,a5,1
    80003ed4:	0007871b          	sext.w	a4,a5
    80003ed8:	0000a797          	auipc	a5,0xa
    80003edc:	fc078793          	addi	a5,a5,-64 # 8000de98 <ticks>
    80003ee0:	c398                	sw	a4,0(a5)
  wakeup(&ticks);
    80003ee2:	0000a517          	auipc	a0,0xa
    80003ee6:	fb650513          	addi	a0,a0,-74 # 8000de98 <ticks>
    80003eea:	fffff097          	auipc	ra,0xfffff
    80003eee:	59a080e7          	jalr	1434(ra) # 80003484 <wakeup>
  release(&tickslock);
    80003ef2:	00018517          	auipc	a0,0x18
    80003ef6:	04650513          	addi	a0,a0,70 # 8001bf38 <tickslock>
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	3e8080e7          	jalr	1000(ra) # 800012e2 <release>
}
    80003f02:	0001                	nop
    80003f04:	60a2                	ld	ra,8(sp)
    80003f06:	6402                	ld	s0,0(sp)
    80003f08:	0141                	addi	sp,sp,16
    80003f0a:	8082                	ret

0000000080003f0c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003f0c:	1101                	addi	sp,sp,-32
    80003f0e:	ec06                	sd	ra,24(sp)
    80003f10:	e822                	sd	s0,16(sp)
    80003f12:	1000                	addi	s0,sp,32
  uint64 scause = r_scause();
    80003f14:	00000097          	auipc	ra,0x0
    80003f18:	ae4080e7          	jalr	-1308(ra) # 800039f8 <r_scause>
    80003f1c:	fea43423          	sd	a0,-24(s0)

  if((scause & 0x8000000000000000L) &&
    80003f20:	fe843783          	ld	a5,-24(s0)
    80003f24:	0807d463          	bgez	a5,80003fac <devintr+0xa0>
     (scause & 0xff) == 9){
    80003f28:	fe843783          	ld	a5,-24(s0)
    80003f2c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003f30:	47a5                	li	a5,9
    80003f32:	06f71d63          	bne	a4,a5,80003fac <devintr+0xa0>
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();
    80003f36:	00005097          	auipc	ra,0x5
    80003f3a:	a5c080e7          	jalr	-1444(ra) # 80008992 <plic_claim>
    80003f3e:	87aa                	mv	a5,a0
    80003f40:	fef42223          	sw	a5,-28(s0)

    if(irq == UART0_IRQ){
    80003f44:	fe442783          	lw	a5,-28(s0)
    80003f48:	0007871b          	sext.w	a4,a5
    80003f4c:	47a9                	li	a5,10
    80003f4e:	00f71763          	bne	a4,a5,80003f5c <devintr+0x50>
      uartintr();
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	034080e7          	jalr	52(ra) # 80000f86 <uartintr>
    80003f5a:	a825                	j	80003f92 <devintr+0x86>
    } else if(irq == VIRTIO0_IRQ){
    80003f5c:	fe442783          	lw	a5,-28(s0)
    80003f60:	0007871b          	sext.w	a4,a5
    80003f64:	4785                	li	a5,1
    80003f66:	00f71763          	bne	a4,a5,80003f74 <devintr+0x68>
      virtio_disk_intr();
    80003f6a:	00005097          	auipc	ra,0x5
    80003f6e:	3ea080e7          	jalr	1002(ra) # 80009354 <virtio_disk_intr>
    80003f72:	a005                	j	80003f92 <devintr+0x86>
    } else if(irq){
    80003f74:	fe442783          	lw	a5,-28(s0)
    80003f78:	2781                	sext.w	a5,a5
    80003f7a:	cf81                	beqz	a5,80003f92 <devintr+0x86>
      printf("unexpected interrupt irq=%d\n", irq);
    80003f7c:	fe442783          	lw	a5,-28(s0)
    80003f80:	85be                	mv	a1,a5
    80003f82:	00007517          	auipc	a0,0x7
    80003f86:	44650513          	addi	a0,a0,1094 # 8000b3c8 <etext+0x3c8>
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	aaa080e7          	jalr	-1366(ra) # 80000a34 <printf>
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
    80003f92:	fe442783          	lw	a5,-28(s0)
    80003f96:	2781                	sext.w	a5,a5
    80003f98:	cb81                	beqz	a5,80003fa8 <devintr+0x9c>
      plic_complete(irq);
    80003f9a:	fe442783          	lw	a5,-28(s0)
    80003f9e:	853e                	mv	a0,a5
    80003fa0:	00005097          	auipc	ra,0x5
    80003fa4:	a30080e7          	jalr	-1488(ra) # 800089d0 <plic_complete>

    return 1;
    80003fa8:	4785                	li	a5,1
    80003faa:	a081                	j	80003fea <devintr+0xde>
  } else if(scause == 0x8000000000000001L){
    80003fac:	fe843703          	ld	a4,-24(s0)
    80003fb0:	57fd                	li	a5,-1
    80003fb2:	17fe                	slli	a5,a5,0x3f
    80003fb4:	0785                	addi	a5,a5,1
    80003fb6:	02f71963          	bne	a4,a5,80003fe8 <devintr+0xdc>
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
    80003fba:	fffff097          	auipc	ra,0xfffff
    80003fbe:	82e080e7          	jalr	-2002(ra) # 800027e8 <cpuid>
    80003fc2:	87aa                	mv	a5,a0
    80003fc4:	e789                	bnez	a5,80003fce <devintr+0xc2>
      clockintr();
    80003fc6:	00000097          	auipc	ra,0x0
    80003fca:	eea080e7          	jalr	-278(ra) # 80003eb0 <clockintr>
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	98e080e7          	jalr	-1650(ra) # 8000395c <r_sip>
    80003fd6:	87aa                	mv	a5,a0
    80003fd8:	9bf5                	andi	a5,a5,-3
    80003fda:	853e                	mv	a0,a5
    80003fdc:	00000097          	auipc	ra,0x0
    80003fe0:	99a080e7          	jalr	-1638(ra) # 80003976 <w_sip>

    return 2;
    80003fe4:	4789                	li	a5,2
    80003fe6:	a011                	j	80003fea <devintr+0xde>
  } else {
    return 0;
    80003fe8:	4781                	li	a5,0
  }
}
    80003fea:	853e                	mv	a0,a5
    80003fec:	60e2                	ld	ra,24(sp)
    80003fee:	6442                	ld	s0,16(sp)
    80003ff0:	6105                	addi	sp,sp,32
    80003ff2:	8082                	ret

0000000080003ff4 <fetchaddr>:
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
    80003ff4:	7179                	addi	sp,sp,-48
    80003ff6:	f406                	sd	ra,40(sp)
    80003ff8:	f022                	sd	s0,32(sp)
    80003ffa:	1800                	addi	s0,sp,48
    80003ffc:	fca43c23          	sd	a0,-40(s0)
    80004000:	fcb43823          	sd	a1,-48(s0)
  struct proc *p = myproc();
    80004004:	fffff097          	auipc	ra,0xfffff
    80004008:	842080e7          	jalr	-1982(ra) # 80002846 <myproc>
    8000400c:	fea43423          	sd	a0,-24(s0)
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80004010:	fe843783          	ld	a5,-24(s0)
    80004014:	67bc                	ld	a5,72(a5)
    80004016:	fd843703          	ld	a4,-40(s0)
    8000401a:	00f77b63          	bgeu	a4,a5,80004030 <fetchaddr+0x3c>
    8000401e:	fd843783          	ld	a5,-40(s0)
    80004022:	00878713          	addi	a4,a5,8
    80004026:	fe843783          	ld	a5,-24(s0)
    8000402a:	67bc                	ld	a5,72(a5)
    8000402c:	00e7f463          	bgeu	a5,a4,80004034 <fetchaddr+0x40>
    return -1;
    80004030:	57fd                	li	a5,-1
    80004032:	a01d                	j	80004058 <fetchaddr+0x64>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80004034:	fe843783          	ld	a5,-24(s0)
    80004038:	6bbc                	ld	a5,80(a5)
    8000403a:	46a1                	li	a3,8
    8000403c:	fd843603          	ld	a2,-40(s0)
    80004040:	fd043583          	ld	a1,-48(s0)
    80004044:	853e                	mv	a0,a5
    80004046:	ffffe097          	auipc	ra,0xffffe
    8000404a:	398080e7          	jalr	920(ra) # 800023de <copyin>
    8000404e:	87aa                	mv	a5,a0
    80004050:	c399                	beqz	a5,80004056 <fetchaddr+0x62>
    return -1;
    80004052:	57fd                	li	a5,-1
    80004054:	a011                	j	80004058 <fetchaddr+0x64>
  return 0;
    80004056:	4781                	li	a5,0
}
    80004058:	853e                	mv	a0,a5
    8000405a:	70a2                	ld	ra,40(sp)
    8000405c:	7402                	ld	s0,32(sp)
    8000405e:	6145                	addi	sp,sp,48
    80004060:	8082                	ret

0000000080004062 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
    80004062:	7139                	addi	sp,sp,-64
    80004064:	fc06                	sd	ra,56(sp)
    80004066:	f822                	sd	s0,48(sp)
    80004068:	0080                	addi	s0,sp,64
    8000406a:	fca43c23          	sd	a0,-40(s0)
    8000406e:	fcb43823          	sd	a1,-48(s0)
    80004072:	87b2                	mv	a5,a2
    80004074:	fcf42623          	sw	a5,-52(s0)
  struct proc *p = myproc();
    80004078:	ffffe097          	auipc	ra,0xffffe
    8000407c:	7ce080e7          	jalr	1998(ra) # 80002846 <myproc>
    80004080:	fea43423          	sd	a0,-24(s0)
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80004084:	fe843783          	ld	a5,-24(s0)
    80004088:	6bbc                	ld	a5,80(a5)
    8000408a:	fcc42703          	lw	a4,-52(s0)
    8000408e:	86ba                	mv	a3,a4
    80004090:	fd843603          	ld	a2,-40(s0)
    80004094:	fd043583          	ld	a1,-48(s0)
    80004098:	853e                	mv	a0,a5
    8000409a:	ffffe097          	auipc	ra,0xffffe
    8000409e:	412080e7          	jalr	1042(ra) # 800024ac <copyinstr>
    800040a2:	87aa                	mv	a5,a0
    800040a4:	0007d463          	bgez	a5,800040ac <fetchstr+0x4a>
    return -1;
    800040a8:	57fd                	li	a5,-1
    800040aa:	a801                	j	800040ba <fetchstr+0x58>
  return strlen(buf);
    800040ac:	fd043503          	ld	a0,-48(s0)
    800040b0:	ffffd097          	auipc	ra,0xffffd
    800040b4:	722080e7          	jalr	1826(ra) # 800017d2 <strlen>
    800040b8:	87aa                	mv	a5,a0
}
    800040ba:	853e                	mv	a0,a5
    800040bc:	70e2                	ld	ra,56(sp)
    800040be:	7442                	ld	s0,48(sp)
    800040c0:	6121                	addi	sp,sp,64
    800040c2:	8082                	ret

00000000800040c4 <argraw>:

static uint64
argraw(int n)
{
    800040c4:	7179                	addi	sp,sp,-48
    800040c6:	f406                	sd	ra,40(sp)
    800040c8:	f022                	sd	s0,32(sp)
    800040ca:	1800                	addi	s0,sp,48
    800040cc:	87aa                	mv	a5,a0
    800040ce:	fcf42e23          	sw	a5,-36(s0)
  struct proc *p = myproc();
    800040d2:	ffffe097          	auipc	ra,0xffffe
    800040d6:	774080e7          	jalr	1908(ra) # 80002846 <myproc>
    800040da:	fea43423          	sd	a0,-24(s0)
  switch (n) {
    800040de:	fdc42783          	lw	a5,-36(s0)
    800040e2:	0007871b          	sext.w	a4,a5
    800040e6:	4795                	li	a5,5
    800040e8:	06e7e263          	bltu	a5,a4,8000414c <argraw+0x88>
    800040ec:	fdc46783          	lwu	a5,-36(s0)
    800040f0:	00279713          	slli	a4,a5,0x2
    800040f4:	00007797          	auipc	a5,0x7
    800040f8:	2fc78793          	addi	a5,a5,764 # 8000b3f0 <etext+0x3f0>
    800040fc:	97ba                	add	a5,a5,a4
    800040fe:	439c                	lw	a5,0(a5)
    80004100:	0007871b          	sext.w	a4,a5
    80004104:	00007797          	auipc	a5,0x7
    80004108:	2ec78793          	addi	a5,a5,748 # 8000b3f0 <etext+0x3f0>
    8000410c:	97ba                	add	a5,a5,a4
    8000410e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80004110:	fe843783          	ld	a5,-24(s0)
    80004114:	6fbc                	ld	a5,88(a5)
    80004116:	7bbc                	ld	a5,112(a5)
    80004118:	a091                	j	8000415c <argraw+0x98>
  case 1:
    return p->trapframe->a1;
    8000411a:	fe843783          	ld	a5,-24(s0)
    8000411e:	6fbc                	ld	a5,88(a5)
    80004120:	7fbc                	ld	a5,120(a5)
    80004122:	a82d                	j	8000415c <argraw+0x98>
  case 2:
    return p->trapframe->a2;
    80004124:	fe843783          	ld	a5,-24(s0)
    80004128:	6fbc                	ld	a5,88(a5)
    8000412a:	63dc                	ld	a5,128(a5)
    8000412c:	a805                	j	8000415c <argraw+0x98>
  case 3:
    return p->trapframe->a3;
    8000412e:	fe843783          	ld	a5,-24(s0)
    80004132:	6fbc                	ld	a5,88(a5)
    80004134:	67dc                	ld	a5,136(a5)
    80004136:	a01d                	j	8000415c <argraw+0x98>
  case 4:
    return p->trapframe->a4;
    80004138:	fe843783          	ld	a5,-24(s0)
    8000413c:	6fbc                	ld	a5,88(a5)
    8000413e:	6bdc                	ld	a5,144(a5)
    80004140:	a831                	j	8000415c <argraw+0x98>
  case 5:
    return p->trapframe->a5;
    80004142:	fe843783          	ld	a5,-24(s0)
    80004146:	6fbc                	ld	a5,88(a5)
    80004148:	6fdc                	ld	a5,152(a5)
    8000414a:	a809                	j	8000415c <argraw+0x98>
  }
  panic("argraw");
    8000414c:	00007517          	auipc	a0,0x7
    80004150:	29c50513          	addi	a0,a0,668 # 8000b3e8 <etext+0x3e8>
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	b36080e7          	jalr	-1226(ra) # 80000c8a <panic>
  return -1;
}
    8000415c:	853e                	mv	a0,a5
    8000415e:	70a2                	ld	ra,40(sp)
    80004160:	7402                	ld	s0,32(sp)
    80004162:	6145                	addi	sp,sp,48
    80004164:	8082                	ret

0000000080004166 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80004166:	1101                	addi	sp,sp,-32
    80004168:	ec06                	sd	ra,24(sp)
    8000416a:	e822                	sd	s0,16(sp)
    8000416c:	1000                	addi	s0,sp,32
    8000416e:	87aa                	mv	a5,a0
    80004170:	feb43023          	sd	a1,-32(s0)
    80004174:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    80004178:	fec42783          	lw	a5,-20(s0)
    8000417c:	853e                	mv	a0,a5
    8000417e:	00000097          	auipc	ra,0x0
    80004182:	f46080e7          	jalr	-186(ra) # 800040c4 <argraw>
    80004186:	87aa                	mv	a5,a0
    80004188:	0007871b          	sext.w	a4,a5
    8000418c:	fe043783          	ld	a5,-32(s0)
    80004190:	c398                	sw	a4,0(a5)
}
    80004192:	0001                	nop
    80004194:	60e2                	ld	ra,24(sp)
    80004196:	6442                	ld	s0,16(sp)
    80004198:	6105                	addi	sp,sp,32
    8000419a:	8082                	ret

000000008000419c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000419c:	1101                	addi	sp,sp,-32
    8000419e:	ec06                	sd	ra,24(sp)
    800041a0:	e822                	sd	s0,16(sp)
    800041a2:	1000                	addi	s0,sp,32
    800041a4:	87aa                	mv	a5,a0
    800041a6:	feb43023          	sd	a1,-32(s0)
    800041aa:	fef42623          	sw	a5,-20(s0)
  *ip = argraw(n);
    800041ae:	fec42783          	lw	a5,-20(s0)
    800041b2:	853e                	mv	a0,a5
    800041b4:	00000097          	auipc	ra,0x0
    800041b8:	f10080e7          	jalr	-240(ra) # 800040c4 <argraw>
    800041bc:	872a                	mv	a4,a0
    800041be:	fe043783          	ld	a5,-32(s0)
    800041c2:	e398                	sd	a4,0(a5)
}
    800041c4:	0001                	nop
    800041c6:	60e2                	ld	ra,24(sp)
    800041c8:	6442                	ld	s0,16(sp)
    800041ca:	6105                	addi	sp,sp,32
    800041cc:	8082                	ret

00000000800041ce <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800041ce:	7179                	addi	sp,sp,-48
    800041d0:	f406                	sd	ra,40(sp)
    800041d2:	f022                	sd	s0,32(sp)
    800041d4:	1800                	addi	s0,sp,48
    800041d6:	87aa                	mv	a5,a0
    800041d8:	fcb43823          	sd	a1,-48(s0)
    800041dc:	8732                	mv	a4,a2
    800041de:	fcf42e23          	sw	a5,-36(s0)
    800041e2:	87ba                	mv	a5,a4
    800041e4:	fcf42c23          	sw	a5,-40(s0)
  uint64 addr;
  argaddr(n, &addr);
    800041e8:	fe840713          	addi	a4,s0,-24
    800041ec:	fdc42783          	lw	a5,-36(s0)
    800041f0:	85ba                	mv	a1,a4
    800041f2:	853e                	mv	a0,a5
    800041f4:	00000097          	auipc	ra,0x0
    800041f8:	fa8080e7          	jalr	-88(ra) # 8000419c <argaddr>
  return fetchstr(addr, buf, max);
    800041fc:	fe843783          	ld	a5,-24(s0)
    80004200:	fd842703          	lw	a4,-40(s0)
    80004204:	863a                	mv	a2,a4
    80004206:	fd043583          	ld	a1,-48(s0)
    8000420a:	853e                	mv	a0,a5
    8000420c:	00000097          	auipc	ra,0x0
    80004210:	e56080e7          	jalr	-426(ra) # 80004062 <fetchstr>
    80004214:	87aa                	mv	a5,a0
}
    80004216:	853e                	mv	a0,a5
    80004218:	70a2                	ld	ra,40(sp)
    8000421a:	7402                	ld	s0,32(sp)
    8000421c:	6145                	addi	sp,sp,48
    8000421e:	8082                	ret

0000000080004220 <syscall>:
[SYS_getprocs] sys_getprocs,
};

void
syscall(void)
{
    80004220:	7179                	addi	sp,sp,-48
    80004222:	f406                	sd	ra,40(sp)
    80004224:	f022                	sd	s0,32(sp)
    80004226:	ec26                	sd	s1,24(sp)
    80004228:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000422a:	ffffe097          	auipc	ra,0xffffe
    8000422e:	61c080e7          	jalr	1564(ra) # 80002846 <myproc>
    80004232:	fca43c23          	sd	a0,-40(s0)

  num = p->trapframe->a7;
    80004236:	fd843783          	ld	a5,-40(s0)
    8000423a:	6fbc                	ld	a5,88(a5)
    8000423c:	77dc                	ld	a5,168(a5)
    8000423e:	fcf42a23          	sw	a5,-44(s0)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80004242:	fd442783          	lw	a5,-44(s0)
    80004246:	2781                	sext.w	a5,a5
    80004248:	04f05263          	blez	a5,8000428c <syscall+0x6c>
    8000424c:	fd442783          	lw	a5,-44(s0)
    80004250:	873e                	mv	a4,a5
    80004252:	47d9                	li	a5,22
    80004254:	02e7ec63          	bltu	a5,a4,8000428c <syscall+0x6c>
    80004258:	0000a717          	auipc	a4,0xa
    8000425c:	b3870713          	addi	a4,a4,-1224 # 8000dd90 <syscalls>
    80004260:	fd442783          	lw	a5,-44(s0)
    80004264:	078e                	slli	a5,a5,0x3
    80004266:	97ba                	add	a5,a5,a4
    80004268:	639c                	ld	a5,0(a5)
    8000426a:	c38d                	beqz	a5,8000428c <syscall+0x6c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000426c:	0000a717          	auipc	a4,0xa
    80004270:	b2470713          	addi	a4,a4,-1244 # 8000dd90 <syscalls>
    80004274:	fd442783          	lw	a5,-44(s0)
    80004278:	078e                	slli	a5,a5,0x3
    8000427a:	97ba                	add	a5,a5,a4
    8000427c:	639c                	ld	a5,0(a5)
    8000427e:	fd843703          	ld	a4,-40(s0)
    80004282:	6f24                	ld	s1,88(a4)
    80004284:	9782                	jalr	a5
    80004286:	87aa                	mv	a5,a0
    80004288:	f8bc                	sd	a5,112(s1)
    8000428a:	a815                	j	800042be <syscall+0x9e>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000428c:	fd843783          	ld	a5,-40(s0)
    80004290:	5b98                	lw	a4,48(a5)
            p->pid, p->name, num);
    80004292:	fd843783          	ld	a5,-40(s0)
    80004296:	15878793          	addi	a5,a5,344
    printf("%d %s: unknown sys call %d\n",
    8000429a:	fd442683          	lw	a3,-44(s0)
    8000429e:	863e                	mv	a2,a5
    800042a0:	85ba                	mv	a1,a4
    800042a2:	00007517          	auipc	a0,0x7
    800042a6:	16650513          	addi	a0,a0,358 # 8000b408 <etext+0x408>
    800042aa:	ffffc097          	auipc	ra,0xffffc
    800042ae:	78a080e7          	jalr	1930(ra) # 80000a34 <printf>
    p->trapframe->a0 = -1;
    800042b2:	fd843783          	ld	a5,-40(s0)
    800042b6:	6fbc                	ld	a5,88(a5)
    800042b8:	577d                	li	a4,-1
    800042ba:	fbb8                	sd	a4,112(a5)
  }
}
    800042bc:	0001                	nop
    800042be:	0001                	nop
    800042c0:	70a2                	ld	ra,40(sp)
    800042c2:	7402                	ld	s0,32(sp)
    800042c4:	64e2                	ld	s1,24(sp)
    800042c6:	6145                	addi	sp,sp,48
    800042c8:	8082                	ret

00000000800042ca <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800042ca:	1101                	addi	sp,sp,-32
    800042cc:	ec06                	sd	ra,24(sp)
    800042ce:	e822                	sd	s0,16(sp)
    800042d0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800042d2:	fec40793          	addi	a5,s0,-20
    800042d6:	85be                	mv	a1,a5
    800042d8:	4501                	li	a0,0
    800042da:	00000097          	auipc	ra,0x0
    800042de:	e8c080e7          	jalr	-372(ra) # 80004166 <argint>
  exit(n);
    800042e2:	fec42783          	lw	a5,-20(s0)
    800042e6:	853e                	mv	a0,a5
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	c50080e7          	jalr	-944(ra) # 80002f38 <exit>
  return 0;  // not reached
    800042f0:	4781                	li	a5,0
}
    800042f2:	853e                	mv	a0,a5
    800042f4:	60e2                	ld	ra,24(sp)
    800042f6:	6442                	ld	s0,16(sp)
    800042f8:	6105                	addi	sp,sp,32
    800042fa:	8082                	ret

00000000800042fc <sys_getpid>:

uint64
sys_getpid(void)
{
    800042fc:	1141                	addi	sp,sp,-16
    800042fe:	e406                	sd	ra,8(sp)
    80004300:	e022                	sd	s0,0(sp)
    80004302:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80004304:	ffffe097          	auipc	ra,0xffffe
    80004308:	542080e7          	jalr	1346(ra) # 80002846 <myproc>
    8000430c:	87aa                	mv	a5,a0
    8000430e:	5b9c                	lw	a5,48(a5)
}
    80004310:	853e                	mv	a0,a5
    80004312:	60a2                	ld	ra,8(sp)
    80004314:	6402                	ld	s0,0(sp)
    80004316:	0141                	addi	sp,sp,16
    80004318:	8082                	ret

000000008000431a <sys_fork>:

uint64
sys_fork(void)
{
    8000431a:	1141                	addi	sp,sp,-16
    8000431c:	e406                	sd	ra,8(sp)
    8000431e:	e022                	sd	s0,0(sp)
    80004320:	0800                	addi	s0,sp,16
  return fork();
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	9f4080e7          	jalr	-1548(ra) # 80002d16 <fork>
    8000432a:	87aa                	mv	a5,a0
}
    8000432c:	853e                	mv	a0,a5
    8000432e:	60a2                	ld	ra,8(sp)
    80004330:	6402                	ld	s0,0(sp)
    80004332:	0141                	addi	sp,sp,16
    80004334:	8082                	ret

0000000080004336 <sys_wait>:

uint64
sys_wait(void)
{
    80004336:	1101                	addi	sp,sp,-32
    80004338:	ec06                	sd	ra,24(sp)
    8000433a:	e822                	sd	s0,16(sp)
    8000433c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000433e:	fe840793          	addi	a5,s0,-24
    80004342:	85be                	mv	a1,a5
    80004344:	4501                	li	a0,0
    80004346:	00000097          	auipc	ra,0x0
    8000434a:	e56080e7          	jalr	-426(ra) # 8000419c <argaddr>
  return wait(p);
    8000434e:	fe843783          	ld	a5,-24(s0)
    80004352:	853e                	mv	a0,a5
    80004354:	fffff097          	auipc	ra,0xfffff
    80004358:	d20080e7          	jalr	-736(ra) # 80003074 <wait>
    8000435c:	87aa                	mv	a5,a0
}
    8000435e:	853e                	mv	a0,a5
    80004360:	60e2                	ld	ra,24(sp)
    80004362:	6442                	ld	s0,16(sp)
    80004364:	6105                	addi	sp,sp,32
    80004366:	8082                	ret

0000000080004368 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80004368:	1101                	addi	sp,sp,-32
    8000436a:	ec06                	sd	ra,24(sp)
    8000436c:	e822                	sd	s0,16(sp)
    8000436e:	1000                	addi	s0,sp,32
  uint64 addr;
  int n;

  argint(0, &n);
    80004370:	fe440793          	addi	a5,s0,-28
    80004374:	85be                	mv	a1,a5
    80004376:	4501                	li	a0,0
    80004378:	00000097          	auipc	ra,0x0
    8000437c:	dee080e7          	jalr	-530(ra) # 80004166 <argint>
  addr = myproc()->sz;
    80004380:	ffffe097          	auipc	ra,0xffffe
    80004384:	4c6080e7          	jalr	1222(ra) # 80002846 <myproc>
    80004388:	87aa                	mv	a5,a0
    8000438a:	67bc                	ld	a5,72(a5)
    8000438c:	fef43423          	sd	a5,-24(s0)
  if(growproc(n) < 0)
    80004390:	fe442783          	lw	a5,-28(s0)
    80004394:	853e                	mv	a0,a5
    80004396:	fffff097          	auipc	ra,0xfffff
    8000439a:	8e0080e7          	jalr	-1824(ra) # 80002c76 <growproc>
    8000439e:	87aa                	mv	a5,a0
    800043a0:	0007d463          	bgez	a5,800043a8 <sys_sbrk+0x40>
    return -1;
    800043a4:	57fd                	li	a5,-1
    800043a6:	a019                	j	800043ac <sys_sbrk+0x44>
  return addr;
    800043a8:	fe843783          	ld	a5,-24(s0)
}
    800043ac:	853e                	mv	a0,a5
    800043ae:	60e2                	ld	ra,24(sp)
    800043b0:	6442                	ld	s0,16(sp)
    800043b2:	6105                	addi	sp,sp,32
    800043b4:	8082                	ret

00000000800043b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800043b6:	1101                	addi	sp,sp,-32
    800043b8:	ec06                	sd	ra,24(sp)
    800043ba:	e822                	sd	s0,16(sp)
    800043bc:	1000                	addi	s0,sp,32
  int n;
  uint ticks0;

  argint(0, &n);
    800043be:	fe840793          	addi	a5,s0,-24
    800043c2:	85be                	mv	a1,a5
    800043c4:	4501                	li	a0,0
    800043c6:	00000097          	auipc	ra,0x0
    800043ca:	da0080e7          	jalr	-608(ra) # 80004166 <argint>
  acquire(&tickslock);
    800043ce:	00018517          	auipc	a0,0x18
    800043d2:	b6a50513          	addi	a0,a0,-1174 # 8001bf38 <tickslock>
    800043d6:	ffffd097          	auipc	ra,0xffffd
    800043da:	ea8080e7          	jalr	-344(ra) # 8000127e <acquire>
  ticks0 = ticks;
    800043de:	0000a797          	auipc	a5,0xa
    800043e2:	aba78793          	addi	a5,a5,-1350 # 8000de98 <ticks>
    800043e6:	439c                	lw	a5,0(a5)
    800043e8:	fef42623          	sw	a5,-20(s0)
  while(ticks - ticks0 < n){
    800043ec:	a099                	j	80004432 <sys_sleep+0x7c>
    if(killed(myproc())){
    800043ee:	ffffe097          	auipc	ra,0xffffe
    800043f2:	458080e7          	jalr	1112(ra) # 80002846 <myproc>
    800043f6:	87aa                	mv	a5,a0
    800043f8:	853e                	mv	a0,a5
    800043fa:	fffff097          	auipc	ra,0xfffff
    800043fe:	1f8080e7          	jalr	504(ra) # 800035f2 <killed>
    80004402:	87aa                	mv	a5,a0
    80004404:	cb99                	beqz	a5,8000441a <sys_sleep+0x64>
      release(&tickslock);
    80004406:	00018517          	auipc	a0,0x18
    8000440a:	b3250513          	addi	a0,a0,-1230 # 8001bf38 <tickslock>
    8000440e:	ffffd097          	auipc	ra,0xffffd
    80004412:	ed4080e7          	jalr	-300(ra) # 800012e2 <release>
      return -1;
    80004416:	57fd                	li	a5,-1
    80004418:	a0a9                	j	80004462 <sys_sleep+0xac>
    }
    sleep(&ticks, &tickslock);
    8000441a:	00018597          	auipc	a1,0x18
    8000441e:	b1e58593          	addi	a1,a1,-1250 # 8001bf38 <tickslock>
    80004422:	0000a517          	auipc	a0,0xa
    80004426:	a7650513          	addi	a0,a0,-1418 # 8000de98 <ticks>
    8000442a:	fffff097          	auipc	ra,0xfffff
    8000442e:	fde080e7          	jalr	-34(ra) # 80003408 <sleep>
  while(ticks - ticks0 < n){
    80004432:	0000a797          	auipc	a5,0xa
    80004436:	a6678793          	addi	a5,a5,-1434 # 8000de98 <ticks>
    8000443a:	439c                	lw	a5,0(a5)
    8000443c:	fec42703          	lw	a4,-20(s0)
    80004440:	9f99                	subw	a5,a5,a4
    80004442:	0007871b          	sext.w	a4,a5
    80004446:	fe842783          	lw	a5,-24(s0)
    8000444a:	2781                	sext.w	a5,a5
    8000444c:	faf761e3          	bltu	a4,a5,800043ee <sys_sleep+0x38>
  }
  release(&tickslock);
    80004450:	00018517          	auipc	a0,0x18
    80004454:	ae850513          	addi	a0,a0,-1304 # 8001bf38 <tickslock>
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	e8a080e7          	jalr	-374(ra) # 800012e2 <release>
  return 0;
    80004460:	4781                	li	a5,0
}
    80004462:	853e                	mv	a0,a5
    80004464:	60e2                	ld	ra,24(sp)
    80004466:	6442                	ld	s0,16(sp)
    80004468:	6105                	addi	sp,sp,32
    8000446a:	8082                	ret

000000008000446c <sys_kill>:

uint64
sys_kill(void)
{
    8000446c:	1101                	addi	sp,sp,-32
    8000446e:	ec06                	sd	ra,24(sp)
    80004470:	e822                	sd	s0,16(sp)
    80004472:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80004474:	fec40793          	addi	a5,s0,-20
    80004478:	85be                	mv	a1,a5
    8000447a:	4501                	li	a0,0
    8000447c:	00000097          	auipc	ra,0x0
    80004480:	cea080e7          	jalr	-790(ra) # 80004166 <argint>
  return kill(pid);
    80004484:	fec42783          	lw	a5,-20(s0)
    80004488:	853e                	mv	a0,a5
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	08e080e7          	jalr	142(ra) # 80003518 <kill>
    80004492:	87aa                	mv	a5,a0
}
    80004494:	853e                	mv	a0,a5
    80004496:	60e2                	ld	ra,24(sp)
    80004498:	6442                	ld	s0,16(sp)
    8000449a:	6105                	addi	sp,sp,32
    8000449c:	8082                	ret

000000008000449e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000449e:	1101                	addi	sp,sp,-32
    800044a0:	ec06                	sd	ra,24(sp)
    800044a2:	e822                	sd	s0,16(sp)
    800044a4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800044a6:	00018517          	auipc	a0,0x18
    800044aa:	a9250513          	addi	a0,a0,-1390 # 8001bf38 <tickslock>
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	dd0080e7          	jalr	-560(ra) # 8000127e <acquire>
  xticks = ticks;
    800044b6:	0000a797          	auipc	a5,0xa
    800044ba:	9e278793          	addi	a5,a5,-1566 # 8000de98 <ticks>
    800044be:	439c                	lw	a5,0(a5)
    800044c0:	fef42623          	sw	a5,-20(s0)
  release(&tickslock);
    800044c4:	00018517          	auipc	a0,0x18
    800044c8:	a7450513          	addi	a0,a0,-1420 # 8001bf38 <tickslock>
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	e16080e7          	jalr	-490(ra) # 800012e2 <release>
  return xticks;
    800044d4:	fec46783          	lwu	a5,-20(s0)
}
    800044d8:	853e                	mv	a0,a5
    800044da:	60e2                	ld	ra,24(sp)
    800044dc:	6442                	ld	s0,16(sp)
    800044de:	6105                	addi	sp,sp,32
    800044e0:	8082                	ret

00000000800044e2 <sys_getprocs>:
uint64
sys_getprocs(void)
{
    800044e2:	1141                	addi	sp,sp,-16
    800044e4:	e406                	sd	ra,8(sp)
    800044e6:	e022                	sd	s0,0(sp)
    800044e8:	0800                	addi	s0,sp,16
  getprocs();
    800044ea:	fffff097          	auipc	ra,0xfffff
    800044ee:	312080e7          	jalr	786(ra) # 800037fc <getprocs>
  return 0;
    800044f2:	4781                	li	a5,0
}
    800044f4:	853e                	mv	a0,a5
    800044f6:	60a2                	ld	ra,8(sp)
    800044f8:	6402                	ld	s0,0(sp)
    800044fa:	0141                	addi	sp,sp,16
    800044fc:	8082                	ret

00000000800044fe <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800044fe:	1101                	addi	sp,sp,-32
    80004500:	ec06                	sd	ra,24(sp)
    80004502:	e822                	sd	s0,16(sp)
    80004504:	1000                	addi	s0,sp,32
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004506:	00007597          	auipc	a1,0x7
    8000450a:	f2258593          	addi	a1,a1,-222 # 8000b428 <etext+0x428>
    8000450e:	00018517          	auipc	a0,0x18
    80004512:	a4250513          	addi	a0,a0,-1470 # 8001bf50 <bcache>
    80004516:	ffffd097          	auipc	ra,0xffffd
    8000451a:	d38080e7          	jalr	-712(ra) # 8000124e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000451e:	00018717          	auipc	a4,0x18
    80004522:	a3270713          	addi	a4,a4,-1486 # 8001bf50 <bcache>
    80004526:	67a1                	lui	a5,0x8
    80004528:	97ba                	add	a5,a5,a4
    8000452a:	00020717          	auipc	a4,0x20
    8000452e:	c8e70713          	addi	a4,a4,-882 # 800241b8 <bcache+0x8268>
    80004532:	2ae7b823          	sd	a4,688(a5) # 82b0 <_entry-0x7fff7d50>
  bcache.head.next = &bcache.head;
    80004536:	00018717          	auipc	a4,0x18
    8000453a:	a1a70713          	addi	a4,a4,-1510 # 8001bf50 <bcache>
    8000453e:	67a1                	lui	a5,0x8
    80004540:	97ba                	add	a5,a5,a4
    80004542:	00020717          	auipc	a4,0x20
    80004546:	c7670713          	addi	a4,a4,-906 # 800241b8 <bcache+0x8268>
    8000454a:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000454e:	00018797          	auipc	a5,0x18
    80004552:	a1a78793          	addi	a5,a5,-1510 # 8001bf68 <bcache+0x18>
    80004556:	fef43423          	sd	a5,-24(s0)
    8000455a:	a895                	j	800045ce <binit+0xd0>
    b->next = bcache.head.next;
    8000455c:	00018717          	auipc	a4,0x18
    80004560:	9f470713          	addi	a4,a4,-1548 # 8001bf50 <bcache>
    80004564:	67a1                	lui	a5,0x8
    80004566:	97ba                	add	a5,a5,a4
    80004568:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000456c:	fe843783          	ld	a5,-24(s0)
    80004570:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004572:	fe843783          	ld	a5,-24(s0)
    80004576:	00020717          	auipc	a4,0x20
    8000457a:	c4270713          	addi	a4,a4,-958 # 800241b8 <bcache+0x8268>
    8000457e:	e7b8                	sd	a4,72(a5)
    initsleeplock(&b->lock, "buffer");
    80004580:	fe843783          	ld	a5,-24(s0)
    80004584:	07c1                	addi	a5,a5,16
    80004586:	00007597          	auipc	a1,0x7
    8000458a:	eaa58593          	addi	a1,a1,-342 # 8000b430 <etext+0x430>
    8000458e:	853e                	mv	a0,a5
    80004590:	00002097          	auipc	ra,0x2
    80004594:	01e080e7          	jalr	30(ra) # 800065ae <initsleeplock>
    bcache.head.next->prev = b;
    80004598:	00018717          	auipc	a4,0x18
    8000459c:	9b870713          	addi	a4,a4,-1608 # 8001bf50 <bcache>
    800045a0:	67a1                	lui	a5,0x8
    800045a2:	97ba                	add	a5,a5,a4
    800045a4:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    800045a8:	fe843703          	ld	a4,-24(s0)
    800045ac:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    800045ae:	00018717          	auipc	a4,0x18
    800045b2:	9a270713          	addi	a4,a4,-1630 # 8001bf50 <bcache>
    800045b6:	67a1                	lui	a5,0x8
    800045b8:	97ba                	add	a5,a5,a4
    800045ba:	fe843703          	ld	a4,-24(s0)
    800045be:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800045c2:	fe843783          	ld	a5,-24(s0)
    800045c6:	45878793          	addi	a5,a5,1112
    800045ca:	fef43423          	sd	a5,-24(s0)
    800045ce:	00020797          	auipc	a5,0x20
    800045d2:	bea78793          	addi	a5,a5,-1046 # 800241b8 <bcache+0x8268>
    800045d6:	fe843703          	ld	a4,-24(s0)
    800045da:	f8f761e3          	bltu	a4,a5,8000455c <binit+0x5e>
  }
}
    800045de:	0001                	nop
    800045e0:	0001                	nop
    800045e2:	60e2                	ld	ra,24(sp)
    800045e4:	6442                	ld	s0,16(sp)
    800045e6:	6105                	addi	sp,sp,32
    800045e8:	8082                	ret

00000000800045ea <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    800045ea:	7179                	addi	sp,sp,-48
    800045ec:	f406                	sd	ra,40(sp)
    800045ee:	f022                	sd	s0,32(sp)
    800045f0:	1800                	addi	s0,sp,48
    800045f2:	87aa                	mv	a5,a0
    800045f4:	872e                	mv	a4,a1
    800045f6:	fcf42e23          	sw	a5,-36(s0)
    800045fa:	87ba                	mv	a5,a4
    800045fc:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  acquire(&bcache.lock);
    80004600:	00018517          	auipc	a0,0x18
    80004604:	95050513          	addi	a0,a0,-1712 # 8001bf50 <bcache>
    80004608:	ffffd097          	auipc	ra,0xffffd
    8000460c:	c76080e7          	jalr	-906(ra) # 8000127e <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80004610:	00018717          	auipc	a4,0x18
    80004614:	94070713          	addi	a4,a4,-1728 # 8001bf50 <bcache>
    80004618:	67a1                	lui	a5,0x8
    8000461a:	97ba                	add	a5,a5,a4
    8000461c:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    80004620:	fef43423          	sd	a5,-24(s0)
    80004624:	a095                	j	80004688 <bget+0x9e>
    if(b->dev == dev && b->blockno == blockno){
    80004626:	fe843783          	ld	a5,-24(s0)
    8000462a:	4798                	lw	a4,8(a5)
    8000462c:	fdc42783          	lw	a5,-36(s0)
    80004630:	2781                	sext.w	a5,a5
    80004632:	04e79663          	bne	a5,a4,8000467e <bget+0x94>
    80004636:	fe843783          	ld	a5,-24(s0)
    8000463a:	47d8                	lw	a4,12(a5)
    8000463c:	fd842783          	lw	a5,-40(s0)
    80004640:	2781                	sext.w	a5,a5
    80004642:	02e79e63          	bne	a5,a4,8000467e <bget+0x94>
      b->refcnt++;
    80004646:	fe843783          	ld	a5,-24(s0)
    8000464a:	43bc                	lw	a5,64(a5)
    8000464c:	2785                	addiw	a5,a5,1
    8000464e:	0007871b          	sext.w	a4,a5
    80004652:	fe843783          	ld	a5,-24(s0)
    80004656:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    80004658:	00018517          	auipc	a0,0x18
    8000465c:	8f850513          	addi	a0,a0,-1800 # 8001bf50 <bcache>
    80004660:	ffffd097          	auipc	ra,0xffffd
    80004664:	c82080e7          	jalr	-894(ra) # 800012e2 <release>
      acquiresleep(&b->lock);
    80004668:	fe843783          	ld	a5,-24(s0)
    8000466c:	07c1                	addi	a5,a5,16
    8000466e:	853e                	mv	a0,a5
    80004670:	00002097          	auipc	ra,0x2
    80004674:	f8a080e7          	jalr	-118(ra) # 800065fa <acquiresleep>
      return b;
    80004678:	fe843783          	ld	a5,-24(s0)
    8000467c:	a07d                	j	8000472a <bget+0x140>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000467e:	fe843783          	ld	a5,-24(s0)
    80004682:	6bbc                	ld	a5,80(a5)
    80004684:	fef43423          	sd	a5,-24(s0)
    80004688:	fe843703          	ld	a4,-24(s0)
    8000468c:	00020797          	auipc	a5,0x20
    80004690:	b2c78793          	addi	a5,a5,-1236 # 800241b8 <bcache+0x8268>
    80004694:	f8f719e3          	bne	a4,a5,80004626 <bget+0x3c>
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004698:	00018717          	auipc	a4,0x18
    8000469c:	8b870713          	addi	a4,a4,-1864 # 8001bf50 <bcache>
    800046a0:	67a1                	lui	a5,0x8
    800046a2:	97ba                	add	a5,a5,a4
    800046a4:	2b07b783          	ld	a5,688(a5) # 82b0 <_entry-0x7fff7d50>
    800046a8:	fef43423          	sd	a5,-24(s0)
    800046ac:	a8b9                	j	8000470a <bget+0x120>
    if(b->refcnt == 0) {
    800046ae:	fe843783          	ld	a5,-24(s0)
    800046b2:	43bc                	lw	a5,64(a5)
    800046b4:	e7b1                	bnez	a5,80004700 <bget+0x116>
      b->dev = dev;
    800046b6:	fe843783          	ld	a5,-24(s0)
    800046ba:	fdc42703          	lw	a4,-36(s0)
    800046be:	c798                	sw	a4,8(a5)
      b->blockno = blockno;
    800046c0:	fe843783          	ld	a5,-24(s0)
    800046c4:	fd842703          	lw	a4,-40(s0)
    800046c8:	c7d8                	sw	a4,12(a5)
      b->valid = 0;
    800046ca:	fe843783          	ld	a5,-24(s0)
    800046ce:	0007a023          	sw	zero,0(a5)
      b->refcnt = 1;
    800046d2:	fe843783          	ld	a5,-24(s0)
    800046d6:	4705                	li	a4,1
    800046d8:	c3b8                	sw	a4,64(a5)
      release(&bcache.lock);
    800046da:	00018517          	auipc	a0,0x18
    800046de:	87650513          	addi	a0,a0,-1930 # 8001bf50 <bcache>
    800046e2:	ffffd097          	auipc	ra,0xffffd
    800046e6:	c00080e7          	jalr	-1024(ra) # 800012e2 <release>
      acquiresleep(&b->lock);
    800046ea:	fe843783          	ld	a5,-24(s0)
    800046ee:	07c1                	addi	a5,a5,16
    800046f0:	853e                	mv	a0,a5
    800046f2:	00002097          	auipc	ra,0x2
    800046f6:	f08080e7          	jalr	-248(ra) # 800065fa <acquiresleep>
      return b;
    800046fa:	fe843783          	ld	a5,-24(s0)
    800046fe:	a035                	j	8000472a <bget+0x140>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004700:	fe843783          	ld	a5,-24(s0)
    80004704:	67bc                	ld	a5,72(a5)
    80004706:	fef43423          	sd	a5,-24(s0)
    8000470a:	fe843703          	ld	a4,-24(s0)
    8000470e:	00020797          	auipc	a5,0x20
    80004712:	aaa78793          	addi	a5,a5,-1366 # 800241b8 <bcache+0x8268>
    80004716:	f8f71ce3          	bne	a4,a5,800046ae <bget+0xc4>
    }
  }
  panic("bget: no buffers");
    8000471a:	00007517          	auipc	a0,0x7
    8000471e:	d1e50513          	addi	a0,a0,-738 # 8000b438 <etext+0x438>
    80004722:	ffffc097          	auipc	ra,0xffffc
    80004726:	568080e7          	jalr	1384(ra) # 80000c8a <panic>
}
    8000472a:	853e                	mv	a0,a5
    8000472c:	70a2                	ld	ra,40(sp)
    8000472e:	7402                	ld	s0,32(sp)
    80004730:	6145                	addi	sp,sp,48
    80004732:	8082                	ret

0000000080004734 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80004734:	7179                	addi	sp,sp,-48
    80004736:	f406                	sd	ra,40(sp)
    80004738:	f022                	sd	s0,32(sp)
    8000473a:	1800                	addi	s0,sp,48
    8000473c:	87aa                	mv	a5,a0
    8000473e:	872e                	mv	a4,a1
    80004740:	fcf42e23          	sw	a5,-36(s0)
    80004744:	87ba                	mv	a5,a4
    80004746:	fcf42c23          	sw	a5,-40(s0)
  struct buf *b;

  b = bget(dev, blockno);
    8000474a:	fd842703          	lw	a4,-40(s0)
    8000474e:	fdc42783          	lw	a5,-36(s0)
    80004752:	85ba                	mv	a1,a4
    80004754:	853e                	mv	a0,a5
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	e94080e7          	jalr	-364(ra) # 800045ea <bget>
    8000475e:	fea43423          	sd	a0,-24(s0)
  if(!b->valid) {
    80004762:	fe843783          	ld	a5,-24(s0)
    80004766:	439c                	lw	a5,0(a5)
    80004768:	ef81                	bnez	a5,80004780 <bread+0x4c>
    virtio_disk_rw(b, 0);
    8000476a:	4581                	li	a1,0
    8000476c:	fe843503          	ld	a0,-24(s0)
    80004770:	00005097          	auipc	ra,0x5
    80004774:	8a2080e7          	jalr	-1886(ra) # 80009012 <virtio_disk_rw>
    b->valid = 1;
    80004778:	fe843783          	ld	a5,-24(s0)
    8000477c:	4705                	li	a4,1
    8000477e:	c398                	sw	a4,0(a5)
  }
  return b;
    80004780:	fe843783          	ld	a5,-24(s0)
}
    80004784:	853e                	mv	a0,a5
    80004786:	70a2                	ld	ra,40(sp)
    80004788:	7402                	ld	s0,32(sp)
    8000478a:	6145                	addi	sp,sp,48
    8000478c:	8082                	ret

000000008000478e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000478e:	1101                	addi	sp,sp,-32
    80004790:	ec06                	sd	ra,24(sp)
    80004792:	e822                	sd	s0,16(sp)
    80004794:	1000                	addi	s0,sp,32
    80004796:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    8000479a:	fe843783          	ld	a5,-24(s0)
    8000479e:	07c1                	addi	a5,a5,16
    800047a0:	853e                	mv	a0,a5
    800047a2:	00002097          	auipc	ra,0x2
    800047a6:	f18080e7          	jalr	-232(ra) # 800066ba <holdingsleep>
    800047aa:	87aa                	mv	a5,a0
    800047ac:	eb89                	bnez	a5,800047be <bwrite+0x30>
    panic("bwrite");
    800047ae:	00007517          	auipc	a0,0x7
    800047b2:	ca250513          	addi	a0,a0,-862 # 8000b450 <etext+0x450>
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	4d4080e7          	jalr	1236(ra) # 80000c8a <panic>
  virtio_disk_rw(b, 1);
    800047be:	4585                	li	a1,1
    800047c0:	fe843503          	ld	a0,-24(s0)
    800047c4:	00005097          	auipc	ra,0x5
    800047c8:	84e080e7          	jalr	-1970(ra) # 80009012 <virtio_disk_rw>
}
    800047cc:	0001                	nop
    800047ce:	60e2                	ld	ra,24(sp)
    800047d0:	6442                	ld	s0,16(sp)
    800047d2:	6105                	addi	sp,sp,32
    800047d4:	8082                	ret

00000000800047d6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800047d6:	1101                	addi	sp,sp,-32
    800047d8:	ec06                	sd	ra,24(sp)
    800047da:	e822                	sd	s0,16(sp)
    800047dc:	1000                	addi	s0,sp,32
    800047de:	fea43423          	sd	a0,-24(s0)
  if(!holdingsleep(&b->lock))
    800047e2:	fe843783          	ld	a5,-24(s0)
    800047e6:	07c1                	addi	a5,a5,16
    800047e8:	853e                	mv	a0,a5
    800047ea:	00002097          	auipc	ra,0x2
    800047ee:	ed0080e7          	jalr	-304(ra) # 800066ba <holdingsleep>
    800047f2:	87aa                	mv	a5,a0
    800047f4:	eb89                	bnez	a5,80004806 <brelse+0x30>
    panic("brelse");
    800047f6:	00007517          	auipc	a0,0x7
    800047fa:	c6250513          	addi	a0,a0,-926 # 8000b458 <etext+0x458>
    800047fe:	ffffc097          	auipc	ra,0xffffc
    80004802:	48c080e7          	jalr	1164(ra) # 80000c8a <panic>

  releasesleep(&b->lock);
    80004806:	fe843783          	ld	a5,-24(s0)
    8000480a:	07c1                	addi	a5,a5,16
    8000480c:	853e                	mv	a0,a5
    8000480e:	00002097          	auipc	ra,0x2
    80004812:	e5a080e7          	jalr	-422(ra) # 80006668 <releasesleep>

  acquire(&bcache.lock);
    80004816:	00017517          	auipc	a0,0x17
    8000481a:	73a50513          	addi	a0,a0,1850 # 8001bf50 <bcache>
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	a60080e7          	jalr	-1440(ra) # 8000127e <acquire>
  b->refcnt--;
    80004826:	fe843783          	ld	a5,-24(s0)
    8000482a:	43bc                	lw	a5,64(a5)
    8000482c:	37fd                	addiw	a5,a5,-1
    8000482e:	0007871b          	sext.w	a4,a5
    80004832:	fe843783          	ld	a5,-24(s0)
    80004836:	c3b8                	sw	a4,64(a5)
  if (b->refcnt == 0) {
    80004838:	fe843783          	ld	a5,-24(s0)
    8000483c:	43bc                	lw	a5,64(a5)
    8000483e:	e7b5                	bnez	a5,800048aa <brelse+0xd4>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80004840:	fe843783          	ld	a5,-24(s0)
    80004844:	6bbc                	ld	a5,80(a5)
    80004846:	fe843703          	ld	a4,-24(s0)
    8000484a:	6738                	ld	a4,72(a4)
    8000484c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000484e:	fe843783          	ld	a5,-24(s0)
    80004852:	67bc                	ld	a5,72(a5)
    80004854:	fe843703          	ld	a4,-24(s0)
    80004858:	6b38                	ld	a4,80(a4)
    8000485a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000485c:	00017717          	auipc	a4,0x17
    80004860:	6f470713          	addi	a4,a4,1780 # 8001bf50 <bcache>
    80004864:	67a1                	lui	a5,0x8
    80004866:	97ba                	add	a5,a5,a4
    80004868:	2b87b703          	ld	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
    8000486c:	fe843783          	ld	a5,-24(s0)
    80004870:	ebb8                	sd	a4,80(a5)
    b->prev = &bcache.head;
    80004872:	fe843783          	ld	a5,-24(s0)
    80004876:	00020717          	auipc	a4,0x20
    8000487a:	94270713          	addi	a4,a4,-1726 # 800241b8 <bcache+0x8268>
    8000487e:	e7b8                	sd	a4,72(a5)
    bcache.head.next->prev = b;
    80004880:	00017717          	auipc	a4,0x17
    80004884:	6d070713          	addi	a4,a4,1744 # 8001bf50 <bcache>
    80004888:	67a1                	lui	a5,0x8
    8000488a:	97ba                	add	a5,a5,a4
    8000488c:	2b87b783          	ld	a5,696(a5) # 82b8 <_entry-0x7fff7d48>
    80004890:	fe843703          	ld	a4,-24(s0)
    80004894:	e7b8                	sd	a4,72(a5)
    bcache.head.next = b;
    80004896:	00017717          	auipc	a4,0x17
    8000489a:	6ba70713          	addi	a4,a4,1722 # 8001bf50 <bcache>
    8000489e:	67a1                	lui	a5,0x8
    800048a0:	97ba                	add	a5,a5,a4
    800048a2:	fe843703          	ld	a4,-24(s0)
    800048a6:	2ae7bc23          	sd	a4,696(a5) # 82b8 <_entry-0x7fff7d48>
  }
  
  release(&bcache.lock);
    800048aa:	00017517          	auipc	a0,0x17
    800048ae:	6a650513          	addi	a0,a0,1702 # 8001bf50 <bcache>
    800048b2:	ffffd097          	auipc	ra,0xffffd
    800048b6:	a30080e7          	jalr	-1488(ra) # 800012e2 <release>
}
    800048ba:	0001                	nop
    800048bc:	60e2                	ld	ra,24(sp)
    800048be:	6442                	ld	s0,16(sp)
    800048c0:	6105                	addi	sp,sp,32
    800048c2:	8082                	ret

00000000800048c4 <bpin>:

void
bpin(struct buf *b) {
    800048c4:	1101                	addi	sp,sp,-32
    800048c6:	ec06                	sd	ra,24(sp)
    800048c8:	e822                	sd	s0,16(sp)
    800048ca:	1000                	addi	s0,sp,32
    800048cc:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    800048d0:	00017517          	auipc	a0,0x17
    800048d4:	68050513          	addi	a0,a0,1664 # 8001bf50 <bcache>
    800048d8:	ffffd097          	auipc	ra,0xffffd
    800048dc:	9a6080e7          	jalr	-1626(ra) # 8000127e <acquire>
  b->refcnt++;
    800048e0:	fe843783          	ld	a5,-24(s0)
    800048e4:	43bc                	lw	a5,64(a5)
    800048e6:	2785                	addiw	a5,a5,1
    800048e8:	0007871b          	sext.w	a4,a5
    800048ec:	fe843783          	ld	a5,-24(s0)
    800048f0:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    800048f2:	00017517          	auipc	a0,0x17
    800048f6:	65e50513          	addi	a0,a0,1630 # 8001bf50 <bcache>
    800048fa:	ffffd097          	auipc	ra,0xffffd
    800048fe:	9e8080e7          	jalr	-1560(ra) # 800012e2 <release>
}
    80004902:	0001                	nop
    80004904:	60e2                	ld	ra,24(sp)
    80004906:	6442                	ld	s0,16(sp)
    80004908:	6105                	addi	sp,sp,32
    8000490a:	8082                	ret

000000008000490c <bunpin>:

void
bunpin(struct buf *b) {
    8000490c:	1101                	addi	sp,sp,-32
    8000490e:	ec06                	sd	ra,24(sp)
    80004910:	e822                	sd	s0,16(sp)
    80004912:	1000                	addi	s0,sp,32
    80004914:	fea43423          	sd	a0,-24(s0)
  acquire(&bcache.lock);
    80004918:	00017517          	auipc	a0,0x17
    8000491c:	63850513          	addi	a0,a0,1592 # 8001bf50 <bcache>
    80004920:	ffffd097          	auipc	ra,0xffffd
    80004924:	95e080e7          	jalr	-1698(ra) # 8000127e <acquire>
  b->refcnt--;
    80004928:	fe843783          	ld	a5,-24(s0)
    8000492c:	43bc                	lw	a5,64(a5)
    8000492e:	37fd                	addiw	a5,a5,-1
    80004930:	0007871b          	sext.w	a4,a5
    80004934:	fe843783          	ld	a5,-24(s0)
    80004938:	c3b8                	sw	a4,64(a5)
  release(&bcache.lock);
    8000493a:	00017517          	auipc	a0,0x17
    8000493e:	61650513          	addi	a0,a0,1558 # 8001bf50 <bcache>
    80004942:	ffffd097          	auipc	ra,0xffffd
    80004946:	9a0080e7          	jalr	-1632(ra) # 800012e2 <release>
}
    8000494a:	0001                	nop
    8000494c:	60e2                	ld	ra,24(sp)
    8000494e:	6442                	ld	s0,16(sp)
    80004950:	6105                	addi	sp,sp,32
    80004952:	8082                	ret

0000000080004954 <readsb>:
struct superblock sb; 

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
    80004954:	7179                	addi	sp,sp,-48
    80004956:	f406                	sd	ra,40(sp)
    80004958:	f022                	sd	s0,32(sp)
    8000495a:	1800                	addi	s0,sp,48
    8000495c:	87aa                	mv	a5,a0
    8000495e:	fcb43823          	sd	a1,-48(s0)
    80004962:	fcf42e23          	sw	a5,-36(s0)
  struct buf *bp;

  bp = bread(dev, 1);
    80004966:	fdc42783          	lw	a5,-36(s0)
    8000496a:	4585                	li	a1,1
    8000496c:	853e                	mv	a0,a5
    8000496e:	00000097          	auipc	ra,0x0
    80004972:	dc6080e7          	jalr	-570(ra) # 80004734 <bread>
    80004976:	fea43423          	sd	a0,-24(s0)
  memmove(sb, bp->data, sizeof(*sb));
    8000497a:	fe843783          	ld	a5,-24(s0)
    8000497e:	05878793          	addi	a5,a5,88
    80004982:	02000613          	li	a2,32
    80004986:	85be                	mv	a1,a5
    80004988:	fd043503          	ld	a0,-48(s0)
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	baa080e7          	jalr	-1110(ra) # 80001536 <memmove>
  brelse(bp);
    80004994:	fe843503          	ld	a0,-24(s0)
    80004998:	00000097          	auipc	ra,0x0
    8000499c:	e3e080e7          	jalr	-450(ra) # 800047d6 <brelse>
}
    800049a0:	0001                	nop
    800049a2:	70a2                	ld	ra,40(sp)
    800049a4:	7402                	ld	s0,32(sp)
    800049a6:	6145                	addi	sp,sp,48
    800049a8:	8082                	ret

00000000800049aa <fsinit>:

// Init fs
void
fsinit(int dev) {
    800049aa:	1101                	addi	sp,sp,-32
    800049ac:	ec06                	sd	ra,24(sp)
    800049ae:	e822                	sd	s0,16(sp)
    800049b0:	1000                	addi	s0,sp,32
    800049b2:	87aa                	mv	a5,a0
    800049b4:	fef42623          	sw	a5,-20(s0)
  readsb(dev, &sb);
    800049b8:	fec42783          	lw	a5,-20(s0)
    800049bc:	00020597          	auipc	a1,0x20
    800049c0:	c5458593          	addi	a1,a1,-940 # 80024610 <sb>
    800049c4:	853e                	mv	a0,a5
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	f8e080e7          	jalr	-114(ra) # 80004954 <readsb>
  if(sb.magic != FSMAGIC)
    800049ce:	00020797          	auipc	a5,0x20
    800049d2:	c4278793          	addi	a5,a5,-958 # 80024610 <sb>
    800049d6:	439c                	lw	a5,0(a5)
    800049d8:	873e                	mv	a4,a5
    800049da:	102037b7          	lui	a5,0x10203
    800049de:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800049e2:	00f70a63          	beq	a4,a5,800049f6 <fsinit+0x4c>
    panic("invalid file system");
    800049e6:	00007517          	auipc	a0,0x7
    800049ea:	a7a50513          	addi	a0,a0,-1414 # 8000b460 <etext+0x460>
    800049ee:	ffffc097          	auipc	ra,0xffffc
    800049f2:	29c080e7          	jalr	668(ra) # 80000c8a <panic>
  initlog(dev, &sb);
    800049f6:	fec42783          	lw	a5,-20(s0)
    800049fa:	00020597          	auipc	a1,0x20
    800049fe:	c1658593          	addi	a1,a1,-1002 # 80024610 <sb>
    80004a02:	853e                	mv	a0,a5
    80004a04:	00001097          	auipc	ra,0x1
    80004a08:	48e080e7          	jalr	1166(ra) # 80005e92 <initlog>
}
    80004a0c:	0001                	nop
    80004a0e:	60e2                	ld	ra,24(sp)
    80004a10:	6442                	ld	s0,16(sp)
    80004a12:	6105                	addi	sp,sp,32
    80004a14:	8082                	ret

0000000080004a16 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
    80004a16:	7179                	addi	sp,sp,-48
    80004a18:	f406                	sd	ra,40(sp)
    80004a1a:	f022                	sd	s0,32(sp)
    80004a1c:	1800                	addi	s0,sp,48
    80004a1e:	87aa                	mv	a5,a0
    80004a20:	872e                	mv	a4,a1
    80004a22:	fcf42e23          	sw	a5,-36(s0)
    80004a26:	87ba                	mv	a5,a4
    80004a28:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;

  bp = bread(dev, bno);
    80004a2c:	fdc42783          	lw	a5,-36(s0)
    80004a30:	fd842703          	lw	a4,-40(s0)
    80004a34:	85ba                	mv	a1,a4
    80004a36:	853e                	mv	a0,a5
    80004a38:	00000097          	auipc	ra,0x0
    80004a3c:	cfc080e7          	jalr	-772(ra) # 80004734 <bread>
    80004a40:	fea43423          	sd	a0,-24(s0)
  memset(bp->data, 0, BSIZE);
    80004a44:	fe843783          	ld	a5,-24(s0)
    80004a48:	05878793          	addi	a5,a5,88
    80004a4c:	40000613          	li	a2,1024
    80004a50:	4581                	li	a1,0
    80004a52:	853e                	mv	a0,a5
    80004a54:	ffffd097          	auipc	ra,0xffffd
    80004a58:	9fe080e7          	jalr	-1538(ra) # 80001452 <memset>
  log_write(bp);
    80004a5c:	fe843503          	ld	a0,-24(s0)
    80004a60:	00002097          	auipc	ra,0x2
    80004a64:	a1a080e7          	jalr	-1510(ra) # 8000647a <log_write>
  brelse(bp);
    80004a68:	fe843503          	ld	a0,-24(s0)
    80004a6c:	00000097          	auipc	ra,0x0
    80004a70:	d6a080e7          	jalr	-662(ra) # 800047d6 <brelse>
}
    80004a74:	0001                	nop
    80004a76:	70a2                	ld	ra,40(sp)
    80004a78:	7402                	ld	s0,32(sp)
    80004a7a:	6145                	addi	sp,sp,48
    80004a7c:	8082                	ret

0000000080004a7e <balloc>:

// Allocate a zeroed disk block.
// returns 0 if out of disk space.
static uint
balloc(uint dev)
{
    80004a7e:	7139                	addi	sp,sp,-64
    80004a80:	fc06                	sd	ra,56(sp)
    80004a82:	f822                	sd	s0,48(sp)
    80004a84:	0080                	addi	s0,sp,64
    80004a86:	87aa                	mv	a5,a0
    80004a88:	fcf42623          	sw	a5,-52(s0)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
    80004a8c:	fe043023          	sd	zero,-32(s0)
  for(b = 0; b < sb.size; b += BPB){
    80004a90:	fe042623          	sw	zero,-20(s0)
    80004a94:	a295                	j	80004bf8 <balloc+0x17a>
    bp = bread(dev, BBLOCK(b, sb));
    80004a96:	fec42783          	lw	a5,-20(s0)
    80004a9a:	41f7d71b          	sraiw	a4,a5,0x1f
    80004a9e:	0137571b          	srliw	a4,a4,0x13
    80004aa2:	9fb9                	addw	a5,a5,a4
    80004aa4:	40d7d79b          	sraiw	a5,a5,0xd
    80004aa8:	2781                	sext.w	a5,a5
    80004aaa:	0007871b          	sext.w	a4,a5
    80004aae:	00020797          	auipc	a5,0x20
    80004ab2:	b6278793          	addi	a5,a5,-1182 # 80024610 <sb>
    80004ab6:	4fdc                	lw	a5,28(a5)
    80004ab8:	9fb9                	addw	a5,a5,a4
    80004aba:	0007871b          	sext.w	a4,a5
    80004abe:	fcc42783          	lw	a5,-52(s0)
    80004ac2:	85ba                	mv	a1,a4
    80004ac4:	853e                	mv	a0,a5
    80004ac6:	00000097          	auipc	ra,0x0
    80004aca:	c6e080e7          	jalr	-914(ra) # 80004734 <bread>
    80004ace:	fea43023          	sd	a0,-32(s0)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004ad2:	fe042423          	sw	zero,-24(s0)
    80004ad6:	a8e9                	j	80004bb0 <balloc+0x132>
      m = 1 << (bi % 8);
    80004ad8:	fe842783          	lw	a5,-24(s0)
    80004adc:	8b9d                	andi	a5,a5,7
    80004ade:	2781                	sext.w	a5,a5
    80004ae0:	4705                	li	a4,1
    80004ae2:	00f717bb          	sllw	a5,a4,a5
    80004ae6:	fcf42e23          	sw	a5,-36(s0)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80004aea:	fe842783          	lw	a5,-24(s0)
    80004aee:	41f7d71b          	sraiw	a4,a5,0x1f
    80004af2:	01d7571b          	srliw	a4,a4,0x1d
    80004af6:	9fb9                	addw	a5,a5,a4
    80004af8:	4037d79b          	sraiw	a5,a5,0x3
    80004afc:	2781                	sext.w	a5,a5
    80004afe:	fe043703          	ld	a4,-32(s0)
    80004b02:	97ba                	add	a5,a5,a4
    80004b04:	0587c783          	lbu	a5,88(a5)
    80004b08:	2781                	sext.w	a5,a5
    80004b0a:	fdc42703          	lw	a4,-36(s0)
    80004b0e:	8ff9                	and	a5,a5,a4
    80004b10:	2781                	sext.w	a5,a5
    80004b12:	ebd1                	bnez	a5,80004ba6 <balloc+0x128>
        bp->data[bi/8] |= m;  // Mark block in use.
    80004b14:	fe842783          	lw	a5,-24(s0)
    80004b18:	41f7d71b          	sraiw	a4,a5,0x1f
    80004b1c:	01d7571b          	srliw	a4,a4,0x1d
    80004b20:	9fb9                	addw	a5,a5,a4
    80004b22:	4037d79b          	sraiw	a5,a5,0x3
    80004b26:	2781                	sext.w	a5,a5
    80004b28:	fe043703          	ld	a4,-32(s0)
    80004b2c:	973e                	add	a4,a4,a5
    80004b2e:	05874703          	lbu	a4,88(a4)
    80004b32:	0187169b          	slliw	a3,a4,0x18
    80004b36:	4186d69b          	sraiw	a3,a3,0x18
    80004b3a:	fdc42703          	lw	a4,-36(s0)
    80004b3e:	0187171b          	slliw	a4,a4,0x18
    80004b42:	4187571b          	sraiw	a4,a4,0x18
    80004b46:	8f55                	or	a4,a4,a3
    80004b48:	0187171b          	slliw	a4,a4,0x18
    80004b4c:	4187571b          	sraiw	a4,a4,0x18
    80004b50:	0ff77713          	zext.b	a4,a4
    80004b54:	fe043683          	ld	a3,-32(s0)
    80004b58:	97b6                	add	a5,a5,a3
    80004b5a:	04e78c23          	sb	a4,88(a5)
        log_write(bp);
    80004b5e:	fe043503          	ld	a0,-32(s0)
    80004b62:	00002097          	auipc	ra,0x2
    80004b66:	918080e7          	jalr	-1768(ra) # 8000647a <log_write>
        brelse(bp);
    80004b6a:	fe043503          	ld	a0,-32(s0)
    80004b6e:	00000097          	auipc	ra,0x0
    80004b72:	c68080e7          	jalr	-920(ra) # 800047d6 <brelse>
        bzero(dev, b + bi);
    80004b76:	fcc42783          	lw	a5,-52(s0)
    80004b7a:	fec42703          	lw	a4,-20(s0)
    80004b7e:	86ba                	mv	a3,a4
    80004b80:	fe842703          	lw	a4,-24(s0)
    80004b84:	9f35                	addw	a4,a4,a3
    80004b86:	2701                	sext.w	a4,a4
    80004b88:	85ba                	mv	a1,a4
    80004b8a:	853e                	mv	a0,a5
    80004b8c:	00000097          	auipc	ra,0x0
    80004b90:	e8a080e7          	jalr	-374(ra) # 80004a16 <bzero>
        return b + bi;
    80004b94:	fec42783          	lw	a5,-20(s0)
    80004b98:	873e                	mv	a4,a5
    80004b9a:	fe842783          	lw	a5,-24(s0)
    80004b9e:	9fb9                	addw	a5,a5,a4
    80004ba0:	2781                	sext.w	a5,a5
    80004ba2:	2781                	sext.w	a5,a5
    80004ba4:	a8a5                	j	80004c1c <balloc+0x19e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80004ba6:	fe842783          	lw	a5,-24(s0)
    80004baa:	2785                	addiw	a5,a5,1
    80004bac:	fef42423          	sw	a5,-24(s0)
    80004bb0:	fe842783          	lw	a5,-24(s0)
    80004bb4:	0007871b          	sext.w	a4,a5
    80004bb8:	6789                	lui	a5,0x2
    80004bba:	02f75263          	bge	a4,a5,80004bde <balloc+0x160>
    80004bbe:	fec42783          	lw	a5,-20(s0)
    80004bc2:	873e                	mv	a4,a5
    80004bc4:	fe842783          	lw	a5,-24(s0)
    80004bc8:	9fb9                	addw	a5,a5,a4
    80004bca:	2781                	sext.w	a5,a5
    80004bcc:	0007871b          	sext.w	a4,a5
    80004bd0:	00020797          	auipc	a5,0x20
    80004bd4:	a4078793          	addi	a5,a5,-1472 # 80024610 <sb>
    80004bd8:	43dc                	lw	a5,4(a5)
    80004bda:	eef76fe3          	bltu	a4,a5,80004ad8 <balloc+0x5a>
      }
    }
    brelse(bp);
    80004bde:	fe043503          	ld	a0,-32(s0)
    80004be2:	00000097          	auipc	ra,0x0
    80004be6:	bf4080e7          	jalr	-1036(ra) # 800047d6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004bea:	fec42783          	lw	a5,-20(s0)
    80004bee:	873e                	mv	a4,a5
    80004bf0:	6789                	lui	a5,0x2
    80004bf2:	9fb9                	addw	a5,a5,a4
    80004bf4:	fef42623          	sw	a5,-20(s0)
    80004bf8:	00020797          	auipc	a5,0x20
    80004bfc:	a1878793          	addi	a5,a5,-1512 # 80024610 <sb>
    80004c00:	43d8                	lw	a4,4(a5)
    80004c02:	fec42783          	lw	a5,-20(s0)
    80004c06:	e8e7e8e3          	bltu	a5,a4,80004a96 <balloc+0x18>
  }
  printf("balloc: out of blocks\n");
    80004c0a:	00007517          	auipc	a0,0x7
    80004c0e:	86e50513          	addi	a0,a0,-1938 # 8000b478 <etext+0x478>
    80004c12:	ffffc097          	auipc	ra,0xffffc
    80004c16:	e22080e7          	jalr	-478(ra) # 80000a34 <printf>
  return 0;
    80004c1a:	4781                	li	a5,0
}
    80004c1c:	853e                	mv	a0,a5
    80004c1e:	70e2                	ld	ra,56(sp)
    80004c20:	7442                	ld	s0,48(sp)
    80004c22:	6121                	addi	sp,sp,64
    80004c24:	8082                	ret

0000000080004c26 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004c26:	7179                	addi	sp,sp,-48
    80004c28:	f406                	sd	ra,40(sp)
    80004c2a:	f022                	sd	s0,32(sp)
    80004c2c:	1800                	addi	s0,sp,48
    80004c2e:	87aa                	mv	a5,a0
    80004c30:	872e                	mv	a4,a1
    80004c32:	fcf42e23          	sw	a5,-36(s0)
    80004c36:	87ba                	mv	a5,a4
    80004c38:	fcf42c23          	sw	a5,-40(s0)
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004c3c:	fdc42683          	lw	a3,-36(s0)
    80004c40:	fd842783          	lw	a5,-40(s0)
    80004c44:	00d7d79b          	srliw	a5,a5,0xd
    80004c48:	0007871b          	sext.w	a4,a5
    80004c4c:	00020797          	auipc	a5,0x20
    80004c50:	9c478793          	addi	a5,a5,-1596 # 80024610 <sb>
    80004c54:	4fdc                	lw	a5,28(a5)
    80004c56:	9fb9                	addw	a5,a5,a4
    80004c58:	2781                	sext.w	a5,a5
    80004c5a:	85be                	mv	a1,a5
    80004c5c:	8536                	mv	a0,a3
    80004c5e:	00000097          	auipc	ra,0x0
    80004c62:	ad6080e7          	jalr	-1322(ra) # 80004734 <bread>
    80004c66:	fea43423          	sd	a0,-24(s0)
  bi = b % BPB;
    80004c6a:	fd842703          	lw	a4,-40(s0)
    80004c6e:	6789                	lui	a5,0x2
    80004c70:	17fd                	addi	a5,a5,-1 # 1fff <_entry-0x7fffe001>
    80004c72:	8ff9                	and	a5,a5,a4
    80004c74:	fef42223          	sw	a5,-28(s0)
  m = 1 << (bi % 8);
    80004c78:	fe442783          	lw	a5,-28(s0)
    80004c7c:	8b9d                	andi	a5,a5,7
    80004c7e:	2781                	sext.w	a5,a5
    80004c80:	4705                	li	a4,1
    80004c82:	00f717bb          	sllw	a5,a4,a5
    80004c86:	fef42023          	sw	a5,-32(s0)
  if((bp->data[bi/8] & m) == 0)
    80004c8a:	fe442783          	lw	a5,-28(s0)
    80004c8e:	41f7d71b          	sraiw	a4,a5,0x1f
    80004c92:	01d7571b          	srliw	a4,a4,0x1d
    80004c96:	9fb9                	addw	a5,a5,a4
    80004c98:	4037d79b          	sraiw	a5,a5,0x3
    80004c9c:	2781                	sext.w	a5,a5
    80004c9e:	fe843703          	ld	a4,-24(s0)
    80004ca2:	97ba                	add	a5,a5,a4
    80004ca4:	0587c783          	lbu	a5,88(a5)
    80004ca8:	2781                	sext.w	a5,a5
    80004caa:	fe042703          	lw	a4,-32(s0)
    80004cae:	8ff9                	and	a5,a5,a4
    80004cb0:	2781                	sext.w	a5,a5
    80004cb2:	eb89                	bnez	a5,80004cc4 <bfree+0x9e>
    panic("freeing free block");
    80004cb4:	00006517          	auipc	a0,0x6
    80004cb8:	7dc50513          	addi	a0,a0,2012 # 8000b490 <etext+0x490>
    80004cbc:	ffffc097          	auipc	ra,0xffffc
    80004cc0:	fce080e7          	jalr	-50(ra) # 80000c8a <panic>
  bp->data[bi/8] &= ~m;
    80004cc4:	fe442783          	lw	a5,-28(s0)
    80004cc8:	41f7d71b          	sraiw	a4,a5,0x1f
    80004ccc:	01d7571b          	srliw	a4,a4,0x1d
    80004cd0:	9fb9                	addw	a5,a5,a4
    80004cd2:	4037d79b          	sraiw	a5,a5,0x3
    80004cd6:	2781                	sext.w	a5,a5
    80004cd8:	fe843703          	ld	a4,-24(s0)
    80004cdc:	973e                	add	a4,a4,a5
    80004cde:	05874703          	lbu	a4,88(a4)
    80004ce2:	0187169b          	slliw	a3,a4,0x18
    80004ce6:	4186d69b          	sraiw	a3,a3,0x18
    80004cea:	fe042703          	lw	a4,-32(s0)
    80004cee:	0187171b          	slliw	a4,a4,0x18
    80004cf2:	4187571b          	sraiw	a4,a4,0x18
    80004cf6:	fff74713          	not	a4,a4
    80004cfa:	0187171b          	slliw	a4,a4,0x18
    80004cfe:	4187571b          	sraiw	a4,a4,0x18
    80004d02:	8f75                	and	a4,a4,a3
    80004d04:	0187171b          	slliw	a4,a4,0x18
    80004d08:	4187571b          	sraiw	a4,a4,0x18
    80004d0c:	0ff77713          	zext.b	a4,a4
    80004d10:	fe843683          	ld	a3,-24(s0)
    80004d14:	97b6                	add	a5,a5,a3
    80004d16:	04e78c23          	sb	a4,88(a5)
  log_write(bp);
    80004d1a:	fe843503          	ld	a0,-24(s0)
    80004d1e:	00001097          	auipc	ra,0x1
    80004d22:	75c080e7          	jalr	1884(ra) # 8000647a <log_write>
  brelse(bp);
    80004d26:	fe843503          	ld	a0,-24(s0)
    80004d2a:	00000097          	auipc	ra,0x0
    80004d2e:	aac080e7          	jalr	-1364(ra) # 800047d6 <brelse>
}
    80004d32:	0001                	nop
    80004d34:	70a2                	ld	ra,40(sp)
    80004d36:	7402                	ld	s0,32(sp)
    80004d38:	6145                	addi	sp,sp,48
    80004d3a:	8082                	ret

0000000080004d3c <iinit>:
  struct inode inode[NINODE];
} itable;

void
iinit()
{
    80004d3c:	1101                	addi	sp,sp,-32
    80004d3e:	ec06                	sd	ra,24(sp)
    80004d40:	e822                	sd	s0,16(sp)
    80004d42:	1000                	addi	s0,sp,32
  int i = 0;
    80004d44:	fe042623          	sw	zero,-20(s0)
  
  initlock(&itable.lock, "itable");
    80004d48:	00006597          	auipc	a1,0x6
    80004d4c:	76058593          	addi	a1,a1,1888 # 8000b4a8 <etext+0x4a8>
    80004d50:	00020517          	auipc	a0,0x20
    80004d54:	8e050513          	addi	a0,a0,-1824 # 80024630 <itable>
    80004d58:	ffffc097          	auipc	ra,0xffffc
    80004d5c:	4f6080e7          	jalr	1270(ra) # 8000124e <initlock>
  for(i = 0; i < NINODE; i++) {
    80004d60:	fe042623          	sw	zero,-20(s0)
    80004d64:	a82d                	j	80004d9e <iinit+0x62>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004d66:	fec42703          	lw	a4,-20(s0)
    80004d6a:	87ba                	mv	a5,a4
    80004d6c:	0792                	slli	a5,a5,0x4
    80004d6e:	97ba                	add	a5,a5,a4
    80004d70:	078e                	slli	a5,a5,0x3
    80004d72:	02078713          	addi	a4,a5,32
    80004d76:	00020797          	auipc	a5,0x20
    80004d7a:	8ba78793          	addi	a5,a5,-1862 # 80024630 <itable>
    80004d7e:	97ba                	add	a5,a5,a4
    80004d80:	07a1                	addi	a5,a5,8
    80004d82:	00006597          	auipc	a1,0x6
    80004d86:	72e58593          	addi	a1,a1,1838 # 8000b4b0 <etext+0x4b0>
    80004d8a:	853e                	mv	a0,a5
    80004d8c:	00002097          	auipc	ra,0x2
    80004d90:	822080e7          	jalr	-2014(ra) # 800065ae <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004d94:	fec42783          	lw	a5,-20(s0)
    80004d98:	2785                	addiw	a5,a5,1
    80004d9a:	fef42623          	sw	a5,-20(s0)
    80004d9e:	fec42783          	lw	a5,-20(s0)
    80004da2:	0007871b          	sext.w	a4,a5
    80004da6:	03100793          	li	a5,49
    80004daa:	fae7dee3          	bge	a5,a4,80004d66 <iinit+0x2a>
  }
}
    80004dae:	0001                	nop
    80004db0:	0001                	nop
    80004db2:	60e2                	ld	ra,24(sp)
    80004db4:	6442                	ld	s0,16(sp)
    80004db6:	6105                	addi	sp,sp,32
    80004db8:	8082                	ret

0000000080004dba <ialloc>:
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode,
// or NULL if there is no free inode.
struct inode*
ialloc(uint dev, short type)
{
    80004dba:	7139                	addi	sp,sp,-64
    80004dbc:	fc06                	sd	ra,56(sp)
    80004dbe:	f822                	sd	s0,48(sp)
    80004dc0:	0080                	addi	s0,sp,64
    80004dc2:	87aa                	mv	a5,a0
    80004dc4:	872e                	mv	a4,a1
    80004dc6:	fcf42623          	sw	a5,-52(s0)
    80004dca:	87ba                	mv	a5,a4
    80004dcc:	fcf41523          	sh	a5,-54(s0)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    80004dd0:	4785                	li	a5,1
    80004dd2:	fef42623          	sw	a5,-20(s0)
    80004dd6:	a855                	j	80004e8a <ialloc+0xd0>
    bp = bread(dev, IBLOCK(inum, sb));
    80004dd8:	fec42783          	lw	a5,-20(s0)
    80004ddc:	8391                	srli	a5,a5,0x4
    80004dde:	0007871b          	sext.w	a4,a5
    80004de2:	00020797          	auipc	a5,0x20
    80004de6:	82e78793          	addi	a5,a5,-2002 # 80024610 <sb>
    80004dea:	4f9c                	lw	a5,24(a5)
    80004dec:	9fb9                	addw	a5,a5,a4
    80004dee:	0007871b          	sext.w	a4,a5
    80004df2:	fcc42783          	lw	a5,-52(s0)
    80004df6:	85ba                	mv	a1,a4
    80004df8:	853e                	mv	a0,a5
    80004dfa:	00000097          	auipc	ra,0x0
    80004dfe:	93a080e7          	jalr	-1734(ra) # 80004734 <bread>
    80004e02:	fea43023          	sd	a0,-32(s0)
    dip = (struct dinode*)bp->data + inum%IPB;
    80004e06:	fe043783          	ld	a5,-32(s0)
    80004e0a:	05878713          	addi	a4,a5,88
    80004e0e:	fec42783          	lw	a5,-20(s0)
    80004e12:	8bbd                	andi	a5,a5,15
    80004e14:	079a                	slli	a5,a5,0x6
    80004e16:	97ba                	add	a5,a5,a4
    80004e18:	fcf43c23          	sd	a5,-40(s0)
    if(dip->type == 0){  // a free inode
    80004e1c:	fd843783          	ld	a5,-40(s0)
    80004e20:	00079783          	lh	a5,0(a5)
    80004e24:	eba1                	bnez	a5,80004e74 <ialloc+0xba>
      memset(dip, 0, sizeof(*dip));
    80004e26:	04000613          	li	a2,64
    80004e2a:	4581                	li	a1,0
    80004e2c:	fd843503          	ld	a0,-40(s0)
    80004e30:	ffffc097          	auipc	ra,0xffffc
    80004e34:	622080e7          	jalr	1570(ra) # 80001452 <memset>
      dip->type = type;
    80004e38:	fd843783          	ld	a5,-40(s0)
    80004e3c:	fca45703          	lhu	a4,-54(s0)
    80004e40:	00e79023          	sh	a4,0(a5)
      log_write(bp);   // mark it allocated on the disk
    80004e44:	fe043503          	ld	a0,-32(s0)
    80004e48:	00001097          	auipc	ra,0x1
    80004e4c:	632080e7          	jalr	1586(ra) # 8000647a <log_write>
      brelse(bp);
    80004e50:	fe043503          	ld	a0,-32(s0)
    80004e54:	00000097          	auipc	ra,0x0
    80004e58:	982080e7          	jalr	-1662(ra) # 800047d6 <brelse>
      return iget(dev, inum);
    80004e5c:	fec42703          	lw	a4,-20(s0)
    80004e60:	fcc42783          	lw	a5,-52(s0)
    80004e64:	85ba                	mv	a1,a4
    80004e66:	853e                	mv	a0,a5
    80004e68:	00000097          	auipc	ra,0x0
    80004e6c:	138080e7          	jalr	312(ra) # 80004fa0 <iget>
    80004e70:	87aa                	mv	a5,a0
    80004e72:	a835                	j	80004eae <ialloc+0xf4>
    }
    brelse(bp);
    80004e74:	fe043503          	ld	a0,-32(s0)
    80004e78:	00000097          	auipc	ra,0x0
    80004e7c:	95e080e7          	jalr	-1698(ra) # 800047d6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004e80:	fec42783          	lw	a5,-20(s0)
    80004e84:	2785                	addiw	a5,a5,1
    80004e86:	fef42623          	sw	a5,-20(s0)
    80004e8a:	0001f797          	auipc	a5,0x1f
    80004e8e:	78678793          	addi	a5,a5,1926 # 80024610 <sb>
    80004e92:	47d8                	lw	a4,12(a5)
    80004e94:	fec42783          	lw	a5,-20(s0)
    80004e98:	f4e7e0e3          	bltu	a5,a4,80004dd8 <ialloc+0x1e>
  }
  printf("ialloc: no inodes\n");
    80004e9c:	00006517          	auipc	a0,0x6
    80004ea0:	61c50513          	addi	a0,a0,1564 # 8000b4b8 <etext+0x4b8>
    80004ea4:	ffffc097          	auipc	ra,0xffffc
    80004ea8:	b90080e7          	jalr	-1136(ra) # 80000a34 <printf>
  return 0;
    80004eac:	4781                	li	a5,0
}
    80004eae:	853e                	mv	a0,a5
    80004eb0:	70e2                	ld	ra,56(sp)
    80004eb2:	7442                	ld	s0,48(sp)
    80004eb4:	6121                	addi	sp,sp,64
    80004eb6:	8082                	ret

0000000080004eb8 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
    80004eb8:	7179                	addi	sp,sp,-48
    80004eba:	f406                	sd	ra,40(sp)
    80004ebc:	f022                	sd	s0,32(sp)
    80004ebe:	1800                	addi	s0,sp,48
    80004ec0:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004ec4:	fd843783          	ld	a5,-40(s0)
    80004ec8:	4394                	lw	a3,0(a5)
    80004eca:	fd843783          	ld	a5,-40(s0)
    80004ece:	43dc                	lw	a5,4(a5)
    80004ed0:	0047d79b          	srliw	a5,a5,0x4
    80004ed4:	0007871b          	sext.w	a4,a5
    80004ed8:	0001f797          	auipc	a5,0x1f
    80004edc:	73878793          	addi	a5,a5,1848 # 80024610 <sb>
    80004ee0:	4f9c                	lw	a5,24(a5)
    80004ee2:	9fb9                	addw	a5,a5,a4
    80004ee4:	2781                	sext.w	a5,a5
    80004ee6:	85be                	mv	a1,a5
    80004ee8:	8536                	mv	a0,a3
    80004eea:	00000097          	auipc	ra,0x0
    80004eee:	84a080e7          	jalr	-1974(ra) # 80004734 <bread>
    80004ef2:	fea43423          	sd	a0,-24(s0)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004ef6:	fe843783          	ld	a5,-24(s0)
    80004efa:	05878713          	addi	a4,a5,88
    80004efe:	fd843783          	ld	a5,-40(s0)
    80004f02:	43dc                	lw	a5,4(a5)
    80004f04:	1782                	slli	a5,a5,0x20
    80004f06:	9381                	srli	a5,a5,0x20
    80004f08:	8bbd                	andi	a5,a5,15
    80004f0a:	079a                	slli	a5,a5,0x6
    80004f0c:	97ba                	add	a5,a5,a4
    80004f0e:	fef43023          	sd	a5,-32(s0)
  dip->type = ip->type;
    80004f12:	fd843783          	ld	a5,-40(s0)
    80004f16:	04479703          	lh	a4,68(a5)
    80004f1a:	fe043783          	ld	a5,-32(s0)
    80004f1e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004f22:	fd843783          	ld	a5,-40(s0)
    80004f26:	04679703          	lh	a4,70(a5)
    80004f2a:	fe043783          	ld	a5,-32(s0)
    80004f2e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004f32:	fd843783          	ld	a5,-40(s0)
    80004f36:	04879703          	lh	a4,72(a5)
    80004f3a:	fe043783          	ld	a5,-32(s0)
    80004f3e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004f42:	fd843783          	ld	a5,-40(s0)
    80004f46:	04a79703          	lh	a4,74(a5)
    80004f4a:	fe043783          	ld	a5,-32(s0)
    80004f4e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004f52:	fd843783          	ld	a5,-40(s0)
    80004f56:	47f8                	lw	a4,76(a5)
    80004f58:	fe043783          	ld	a5,-32(s0)
    80004f5c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004f5e:	fe043783          	ld	a5,-32(s0)
    80004f62:	00c78713          	addi	a4,a5,12
    80004f66:	fd843783          	ld	a5,-40(s0)
    80004f6a:	05078793          	addi	a5,a5,80
    80004f6e:	03400613          	li	a2,52
    80004f72:	85be                	mv	a1,a5
    80004f74:	853a                	mv	a0,a4
    80004f76:	ffffc097          	auipc	ra,0xffffc
    80004f7a:	5c0080e7          	jalr	1472(ra) # 80001536 <memmove>
  log_write(bp);
    80004f7e:	fe843503          	ld	a0,-24(s0)
    80004f82:	00001097          	auipc	ra,0x1
    80004f86:	4f8080e7          	jalr	1272(ra) # 8000647a <log_write>
  brelse(bp);
    80004f8a:	fe843503          	ld	a0,-24(s0)
    80004f8e:	00000097          	auipc	ra,0x0
    80004f92:	848080e7          	jalr	-1976(ra) # 800047d6 <brelse>
}
    80004f96:	0001                	nop
    80004f98:	70a2                	ld	ra,40(sp)
    80004f9a:	7402                	ld	s0,32(sp)
    80004f9c:	6145                	addi	sp,sp,48
    80004f9e:	8082                	ret

0000000080004fa0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
    80004fa0:	7179                	addi	sp,sp,-48
    80004fa2:	f406                	sd	ra,40(sp)
    80004fa4:	f022                	sd	s0,32(sp)
    80004fa6:	1800                	addi	s0,sp,48
    80004fa8:	87aa                	mv	a5,a0
    80004faa:	872e                	mv	a4,a1
    80004fac:	fcf42e23          	sw	a5,-36(s0)
    80004fb0:	87ba                	mv	a5,a4
    80004fb2:	fcf42c23          	sw	a5,-40(s0)
  struct inode *ip, *empty;

  acquire(&itable.lock);
    80004fb6:	0001f517          	auipc	a0,0x1f
    80004fba:	67a50513          	addi	a0,a0,1658 # 80024630 <itable>
    80004fbe:	ffffc097          	auipc	ra,0xffffc
    80004fc2:	2c0080e7          	jalr	704(ra) # 8000127e <acquire>

  // Is the inode already in the table?
  empty = 0;
    80004fc6:	fe043023          	sd	zero,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004fca:	0001f797          	auipc	a5,0x1f
    80004fce:	67e78793          	addi	a5,a5,1662 # 80024648 <itable+0x18>
    80004fd2:	fef43423          	sd	a5,-24(s0)
    80004fd6:	a89d                	j	8000504c <iget+0xac>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004fd8:	fe843783          	ld	a5,-24(s0)
    80004fdc:	479c                	lw	a5,8(a5)
    80004fde:	04f05663          	blez	a5,8000502a <iget+0x8a>
    80004fe2:	fe843783          	ld	a5,-24(s0)
    80004fe6:	4398                	lw	a4,0(a5)
    80004fe8:	fdc42783          	lw	a5,-36(s0)
    80004fec:	2781                	sext.w	a5,a5
    80004fee:	02e79e63          	bne	a5,a4,8000502a <iget+0x8a>
    80004ff2:	fe843783          	ld	a5,-24(s0)
    80004ff6:	43d8                	lw	a4,4(a5)
    80004ff8:	fd842783          	lw	a5,-40(s0)
    80004ffc:	2781                	sext.w	a5,a5
    80004ffe:	02e79663          	bne	a5,a4,8000502a <iget+0x8a>
      ip->ref++;
    80005002:	fe843783          	ld	a5,-24(s0)
    80005006:	479c                	lw	a5,8(a5)
    80005008:	2785                	addiw	a5,a5,1
    8000500a:	0007871b          	sext.w	a4,a5
    8000500e:	fe843783          	ld	a5,-24(s0)
    80005012:	c798                	sw	a4,8(a5)
      release(&itable.lock);
    80005014:	0001f517          	auipc	a0,0x1f
    80005018:	61c50513          	addi	a0,a0,1564 # 80024630 <itable>
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	2c6080e7          	jalr	710(ra) # 800012e2 <release>
      return ip;
    80005024:	fe843783          	ld	a5,-24(s0)
    80005028:	a069                	j	800050b2 <iget+0x112>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000502a:	fe043783          	ld	a5,-32(s0)
    8000502e:	eb89                	bnez	a5,80005040 <iget+0xa0>
    80005030:	fe843783          	ld	a5,-24(s0)
    80005034:	479c                	lw	a5,8(a5)
    80005036:	e789                	bnez	a5,80005040 <iget+0xa0>
      empty = ip;
    80005038:	fe843783          	ld	a5,-24(s0)
    8000503c:	fef43023          	sd	a5,-32(s0)
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80005040:	fe843783          	ld	a5,-24(s0)
    80005044:	08878793          	addi	a5,a5,136
    80005048:	fef43423          	sd	a5,-24(s0)
    8000504c:	fe843703          	ld	a4,-24(s0)
    80005050:	00021797          	auipc	a5,0x21
    80005054:	08878793          	addi	a5,a5,136 # 800260d8 <log>
    80005058:	f8f760e3          	bltu	a4,a5,80004fd8 <iget+0x38>
  }

  // Recycle an inode entry.
  if(empty == 0)
    8000505c:	fe043783          	ld	a5,-32(s0)
    80005060:	eb89                	bnez	a5,80005072 <iget+0xd2>
    panic("iget: no inodes");
    80005062:	00006517          	auipc	a0,0x6
    80005066:	46e50513          	addi	a0,a0,1134 # 8000b4d0 <etext+0x4d0>
    8000506a:	ffffc097          	auipc	ra,0xffffc
    8000506e:	c20080e7          	jalr	-992(ra) # 80000c8a <panic>

  ip = empty;
    80005072:	fe043783          	ld	a5,-32(s0)
    80005076:	fef43423          	sd	a5,-24(s0)
  ip->dev = dev;
    8000507a:	fe843783          	ld	a5,-24(s0)
    8000507e:	fdc42703          	lw	a4,-36(s0)
    80005082:	c398                	sw	a4,0(a5)
  ip->inum = inum;
    80005084:	fe843783          	ld	a5,-24(s0)
    80005088:	fd842703          	lw	a4,-40(s0)
    8000508c:	c3d8                	sw	a4,4(a5)
  ip->ref = 1;
    8000508e:	fe843783          	ld	a5,-24(s0)
    80005092:	4705                	li	a4,1
    80005094:	c798                	sw	a4,8(a5)
  ip->valid = 0;
    80005096:	fe843783          	ld	a5,-24(s0)
    8000509a:	0407a023          	sw	zero,64(a5)
  release(&itable.lock);
    8000509e:	0001f517          	auipc	a0,0x1f
    800050a2:	59250513          	addi	a0,a0,1426 # 80024630 <itable>
    800050a6:	ffffc097          	auipc	ra,0xffffc
    800050aa:	23c080e7          	jalr	572(ra) # 800012e2 <release>

  return ip;
    800050ae:	fe843783          	ld	a5,-24(s0)
}
    800050b2:	853e                	mv	a0,a5
    800050b4:	70a2                	ld	ra,40(sp)
    800050b6:	7402                	ld	s0,32(sp)
    800050b8:	6145                	addi	sp,sp,48
    800050ba:	8082                	ret

00000000800050bc <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
    800050bc:	1101                	addi	sp,sp,-32
    800050be:	ec06                	sd	ra,24(sp)
    800050c0:	e822                	sd	s0,16(sp)
    800050c2:	1000                	addi	s0,sp,32
    800050c4:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    800050c8:	0001f517          	auipc	a0,0x1f
    800050cc:	56850513          	addi	a0,a0,1384 # 80024630 <itable>
    800050d0:	ffffc097          	auipc	ra,0xffffc
    800050d4:	1ae080e7          	jalr	430(ra) # 8000127e <acquire>
  ip->ref++;
    800050d8:	fe843783          	ld	a5,-24(s0)
    800050dc:	479c                	lw	a5,8(a5)
    800050de:	2785                	addiw	a5,a5,1
    800050e0:	0007871b          	sext.w	a4,a5
    800050e4:	fe843783          	ld	a5,-24(s0)
    800050e8:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    800050ea:	0001f517          	auipc	a0,0x1f
    800050ee:	54650513          	addi	a0,a0,1350 # 80024630 <itable>
    800050f2:	ffffc097          	auipc	ra,0xffffc
    800050f6:	1f0080e7          	jalr	496(ra) # 800012e2 <release>
  return ip;
    800050fa:	fe843783          	ld	a5,-24(s0)
}
    800050fe:	853e                	mv	a0,a5
    80005100:	60e2                	ld	ra,24(sp)
    80005102:	6442                	ld	s0,16(sp)
    80005104:	6105                	addi	sp,sp,32
    80005106:	8082                	ret

0000000080005108 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
    80005108:	7179                	addi	sp,sp,-48
    8000510a:	f406                	sd	ra,40(sp)
    8000510c:	f022                	sd	s0,32(sp)
    8000510e:	1800                	addi	s0,sp,48
    80005110:	fca43c23          	sd	a0,-40(s0)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    80005114:	fd843783          	ld	a5,-40(s0)
    80005118:	c791                	beqz	a5,80005124 <ilock+0x1c>
    8000511a:	fd843783          	ld	a5,-40(s0)
    8000511e:	479c                	lw	a5,8(a5)
    80005120:	00f04a63          	bgtz	a5,80005134 <ilock+0x2c>
    panic("ilock");
    80005124:	00006517          	auipc	a0,0x6
    80005128:	3bc50513          	addi	a0,a0,956 # 8000b4e0 <etext+0x4e0>
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	b5e080e7          	jalr	-1186(ra) # 80000c8a <panic>

  acquiresleep(&ip->lock);
    80005134:	fd843783          	ld	a5,-40(s0)
    80005138:	07c1                	addi	a5,a5,16
    8000513a:	853e                	mv	a0,a5
    8000513c:	00001097          	auipc	ra,0x1
    80005140:	4be080e7          	jalr	1214(ra) # 800065fa <acquiresleep>

  if(ip->valid == 0){
    80005144:	fd843783          	ld	a5,-40(s0)
    80005148:	43bc                	lw	a5,64(a5)
    8000514a:	e7e5                	bnez	a5,80005232 <ilock+0x12a>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000514c:	fd843783          	ld	a5,-40(s0)
    80005150:	4394                	lw	a3,0(a5)
    80005152:	fd843783          	ld	a5,-40(s0)
    80005156:	43dc                	lw	a5,4(a5)
    80005158:	0047d79b          	srliw	a5,a5,0x4
    8000515c:	0007871b          	sext.w	a4,a5
    80005160:	0001f797          	auipc	a5,0x1f
    80005164:	4b078793          	addi	a5,a5,1200 # 80024610 <sb>
    80005168:	4f9c                	lw	a5,24(a5)
    8000516a:	9fb9                	addw	a5,a5,a4
    8000516c:	2781                	sext.w	a5,a5
    8000516e:	85be                	mv	a1,a5
    80005170:	8536                	mv	a0,a3
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	5c2080e7          	jalr	1474(ra) # 80004734 <bread>
    8000517a:	fea43423          	sd	a0,-24(s0)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000517e:	fe843783          	ld	a5,-24(s0)
    80005182:	05878713          	addi	a4,a5,88
    80005186:	fd843783          	ld	a5,-40(s0)
    8000518a:	43dc                	lw	a5,4(a5)
    8000518c:	1782                	slli	a5,a5,0x20
    8000518e:	9381                	srli	a5,a5,0x20
    80005190:	8bbd                	andi	a5,a5,15
    80005192:	079a                	slli	a5,a5,0x6
    80005194:	97ba                	add	a5,a5,a4
    80005196:	fef43023          	sd	a5,-32(s0)
    ip->type = dip->type;
    8000519a:	fe043783          	ld	a5,-32(s0)
    8000519e:	00079703          	lh	a4,0(a5)
    800051a2:	fd843783          	ld	a5,-40(s0)
    800051a6:	04e79223          	sh	a4,68(a5)
    ip->major = dip->major;
    800051aa:	fe043783          	ld	a5,-32(s0)
    800051ae:	00279703          	lh	a4,2(a5)
    800051b2:	fd843783          	ld	a5,-40(s0)
    800051b6:	04e79323          	sh	a4,70(a5)
    ip->minor = dip->minor;
    800051ba:	fe043783          	ld	a5,-32(s0)
    800051be:	00479703          	lh	a4,4(a5)
    800051c2:	fd843783          	ld	a5,-40(s0)
    800051c6:	04e79423          	sh	a4,72(a5)
    ip->nlink = dip->nlink;
    800051ca:	fe043783          	ld	a5,-32(s0)
    800051ce:	00679703          	lh	a4,6(a5)
    800051d2:	fd843783          	ld	a5,-40(s0)
    800051d6:	04e79523          	sh	a4,74(a5)
    ip->size = dip->size;
    800051da:	fe043783          	ld	a5,-32(s0)
    800051de:	4798                	lw	a4,8(a5)
    800051e0:	fd843783          	ld	a5,-40(s0)
    800051e4:	c7f8                	sw	a4,76(a5)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800051e6:	fd843783          	ld	a5,-40(s0)
    800051ea:	05078713          	addi	a4,a5,80
    800051ee:	fe043783          	ld	a5,-32(s0)
    800051f2:	07b1                	addi	a5,a5,12
    800051f4:	03400613          	li	a2,52
    800051f8:	85be                	mv	a1,a5
    800051fa:	853a                	mv	a0,a4
    800051fc:	ffffc097          	auipc	ra,0xffffc
    80005200:	33a080e7          	jalr	826(ra) # 80001536 <memmove>
    brelse(bp);
    80005204:	fe843503          	ld	a0,-24(s0)
    80005208:	fffff097          	auipc	ra,0xfffff
    8000520c:	5ce080e7          	jalr	1486(ra) # 800047d6 <brelse>
    ip->valid = 1;
    80005210:	fd843783          	ld	a5,-40(s0)
    80005214:	4705                	li	a4,1
    80005216:	c3b8                	sw	a4,64(a5)
    if(ip->type == 0)
    80005218:	fd843783          	ld	a5,-40(s0)
    8000521c:	04479783          	lh	a5,68(a5)
    80005220:	eb89                	bnez	a5,80005232 <ilock+0x12a>
      panic("ilock: no type");
    80005222:	00006517          	auipc	a0,0x6
    80005226:	2c650513          	addi	a0,a0,710 # 8000b4e8 <etext+0x4e8>
    8000522a:	ffffc097          	auipc	ra,0xffffc
    8000522e:	a60080e7          	jalr	-1440(ra) # 80000c8a <panic>
  }
}
    80005232:	0001                	nop
    80005234:	70a2                	ld	ra,40(sp)
    80005236:	7402                	ld	s0,32(sp)
    80005238:	6145                	addi	sp,sp,48
    8000523a:	8082                	ret

000000008000523c <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
    8000523c:	1101                	addi	sp,sp,-32
    8000523e:	ec06                	sd	ra,24(sp)
    80005240:	e822                	sd	s0,16(sp)
    80005242:	1000                	addi	s0,sp,32
    80005244:	fea43423          	sd	a0,-24(s0)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80005248:	fe843783          	ld	a5,-24(s0)
    8000524c:	c385                	beqz	a5,8000526c <iunlock+0x30>
    8000524e:	fe843783          	ld	a5,-24(s0)
    80005252:	07c1                	addi	a5,a5,16
    80005254:	853e                	mv	a0,a5
    80005256:	00001097          	auipc	ra,0x1
    8000525a:	464080e7          	jalr	1124(ra) # 800066ba <holdingsleep>
    8000525e:	87aa                	mv	a5,a0
    80005260:	c791                	beqz	a5,8000526c <iunlock+0x30>
    80005262:	fe843783          	ld	a5,-24(s0)
    80005266:	479c                	lw	a5,8(a5)
    80005268:	00f04a63          	bgtz	a5,8000527c <iunlock+0x40>
    panic("iunlock");
    8000526c:	00006517          	auipc	a0,0x6
    80005270:	28c50513          	addi	a0,a0,652 # 8000b4f8 <etext+0x4f8>
    80005274:	ffffc097          	auipc	ra,0xffffc
    80005278:	a16080e7          	jalr	-1514(ra) # 80000c8a <panic>

  releasesleep(&ip->lock);
    8000527c:	fe843783          	ld	a5,-24(s0)
    80005280:	07c1                	addi	a5,a5,16
    80005282:	853e                	mv	a0,a5
    80005284:	00001097          	auipc	ra,0x1
    80005288:	3e4080e7          	jalr	996(ra) # 80006668 <releasesleep>
}
    8000528c:	0001                	nop
    8000528e:	60e2                	ld	ra,24(sp)
    80005290:	6442                	ld	s0,16(sp)
    80005292:	6105                	addi	sp,sp,32
    80005294:	8082                	ret

0000000080005296 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
    80005296:	1101                	addi	sp,sp,-32
    80005298:	ec06                	sd	ra,24(sp)
    8000529a:	e822                	sd	s0,16(sp)
    8000529c:	1000                	addi	s0,sp,32
    8000529e:	fea43423          	sd	a0,-24(s0)
  acquire(&itable.lock);
    800052a2:	0001f517          	auipc	a0,0x1f
    800052a6:	38e50513          	addi	a0,a0,910 # 80024630 <itable>
    800052aa:	ffffc097          	auipc	ra,0xffffc
    800052ae:	fd4080e7          	jalr	-44(ra) # 8000127e <acquire>

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800052b2:	fe843783          	ld	a5,-24(s0)
    800052b6:	479c                	lw	a5,8(a5)
    800052b8:	873e                	mv	a4,a5
    800052ba:	4785                	li	a5,1
    800052bc:	06f71f63          	bne	a4,a5,8000533a <iput+0xa4>
    800052c0:	fe843783          	ld	a5,-24(s0)
    800052c4:	43bc                	lw	a5,64(a5)
    800052c6:	cbb5                	beqz	a5,8000533a <iput+0xa4>
    800052c8:	fe843783          	ld	a5,-24(s0)
    800052cc:	04a79783          	lh	a5,74(a5)
    800052d0:	e7ad                	bnez	a5,8000533a <iput+0xa4>
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);
    800052d2:	fe843783          	ld	a5,-24(s0)
    800052d6:	07c1                	addi	a5,a5,16
    800052d8:	853e                	mv	a0,a5
    800052da:	00001097          	auipc	ra,0x1
    800052de:	320080e7          	jalr	800(ra) # 800065fa <acquiresleep>

    release(&itable.lock);
    800052e2:	0001f517          	auipc	a0,0x1f
    800052e6:	34e50513          	addi	a0,a0,846 # 80024630 <itable>
    800052ea:	ffffc097          	auipc	ra,0xffffc
    800052ee:	ff8080e7          	jalr	-8(ra) # 800012e2 <release>

    itrunc(ip);
    800052f2:	fe843503          	ld	a0,-24(s0)
    800052f6:	00000097          	auipc	ra,0x0
    800052fa:	21a080e7          	jalr	538(ra) # 80005510 <itrunc>
    ip->type = 0;
    800052fe:	fe843783          	ld	a5,-24(s0)
    80005302:	04079223          	sh	zero,68(a5)
    iupdate(ip);
    80005306:	fe843503          	ld	a0,-24(s0)
    8000530a:	00000097          	auipc	ra,0x0
    8000530e:	bae080e7          	jalr	-1106(ra) # 80004eb8 <iupdate>
    ip->valid = 0;
    80005312:	fe843783          	ld	a5,-24(s0)
    80005316:	0407a023          	sw	zero,64(a5)

    releasesleep(&ip->lock);
    8000531a:	fe843783          	ld	a5,-24(s0)
    8000531e:	07c1                	addi	a5,a5,16
    80005320:	853e                	mv	a0,a5
    80005322:	00001097          	auipc	ra,0x1
    80005326:	346080e7          	jalr	838(ra) # 80006668 <releasesleep>

    acquire(&itable.lock);
    8000532a:	0001f517          	auipc	a0,0x1f
    8000532e:	30650513          	addi	a0,a0,774 # 80024630 <itable>
    80005332:	ffffc097          	auipc	ra,0xffffc
    80005336:	f4c080e7          	jalr	-180(ra) # 8000127e <acquire>
  }

  ip->ref--;
    8000533a:	fe843783          	ld	a5,-24(s0)
    8000533e:	479c                	lw	a5,8(a5)
    80005340:	37fd                	addiw	a5,a5,-1
    80005342:	0007871b          	sext.w	a4,a5
    80005346:	fe843783          	ld	a5,-24(s0)
    8000534a:	c798                	sw	a4,8(a5)
  release(&itable.lock);
    8000534c:	0001f517          	auipc	a0,0x1f
    80005350:	2e450513          	addi	a0,a0,740 # 80024630 <itable>
    80005354:	ffffc097          	auipc	ra,0xffffc
    80005358:	f8e080e7          	jalr	-114(ra) # 800012e2 <release>
}
    8000535c:	0001                	nop
    8000535e:	60e2                	ld	ra,24(sp)
    80005360:	6442                	ld	s0,16(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret

0000000080005366 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
    80005366:	1101                	addi	sp,sp,-32
    80005368:	ec06                	sd	ra,24(sp)
    8000536a:	e822                	sd	s0,16(sp)
    8000536c:	1000                	addi	s0,sp,32
    8000536e:	fea43423          	sd	a0,-24(s0)
  iunlock(ip);
    80005372:	fe843503          	ld	a0,-24(s0)
    80005376:	00000097          	auipc	ra,0x0
    8000537a:	ec6080e7          	jalr	-314(ra) # 8000523c <iunlock>
  iput(ip);
    8000537e:	fe843503          	ld	a0,-24(s0)
    80005382:	00000097          	auipc	ra,0x0
    80005386:	f14080e7          	jalr	-236(ra) # 80005296 <iput>
}
    8000538a:	0001                	nop
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	6105                	addi	sp,sp,32
    80005392:	8082                	ret

0000000080005394 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80005394:	7139                	addi	sp,sp,-64
    80005396:	fc06                	sd	ra,56(sp)
    80005398:	f822                	sd	s0,48(sp)
    8000539a:	0080                	addi	s0,sp,64
    8000539c:	fca43423          	sd	a0,-56(s0)
    800053a0:	87ae                	mv	a5,a1
    800053a2:	fcf42223          	sw	a5,-60(s0)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800053a6:	fc442783          	lw	a5,-60(s0)
    800053aa:	0007871b          	sext.w	a4,a5
    800053ae:	47ad                	li	a5,11
    800053b0:	04e7ee63          	bltu	a5,a4,8000540c <bmap+0x78>
    if((addr = ip->addrs[bn]) == 0){
    800053b4:	fc843703          	ld	a4,-56(s0)
    800053b8:	fc446783          	lwu	a5,-60(s0)
    800053bc:	07d1                	addi	a5,a5,20
    800053be:	078a                	slli	a5,a5,0x2
    800053c0:	97ba                	add	a5,a5,a4
    800053c2:	439c                	lw	a5,0(a5)
    800053c4:	fef42623          	sw	a5,-20(s0)
    800053c8:	fec42783          	lw	a5,-20(s0)
    800053cc:	2781                	sext.w	a5,a5
    800053ce:	ef85                	bnez	a5,80005406 <bmap+0x72>
      addr = balloc(ip->dev);
    800053d0:	fc843783          	ld	a5,-56(s0)
    800053d4:	439c                	lw	a5,0(a5)
    800053d6:	853e                	mv	a0,a5
    800053d8:	fffff097          	auipc	ra,0xfffff
    800053dc:	6a6080e7          	jalr	1702(ra) # 80004a7e <balloc>
    800053e0:	87aa                	mv	a5,a0
    800053e2:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    800053e6:	fec42783          	lw	a5,-20(s0)
    800053ea:	2781                	sext.w	a5,a5
    800053ec:	e399                	bnez	a5,800053f2 <bmap+0x5e>
        return 0;
    800053ee:	4781                	li	a5,0
    800053f0:	aa19                	j	80005506 <bmap+0x172>
      ip->addrs[bn] = addr;
    800053f2:	fc843703          	ld	a4,-56(s0)
    800053f6:	fc446783          	lwu	a5,-60(s0)
    800053fa:	07d1                	addi	a5,a5,20
    800053fc:	078a                	slli	a5,a5,0x2
    800053fe:	97ba                	add	a5,a5,a4
    80005400:	fec42703          	lw	a4,-20(s0)
    80005404:	c398                	sw	a4,0(a5)
    }
    return addr;
    80005406:	fec42783          	lw	a5,-20(s0)
    8000540a:	a8f5                	j	80005506 <bmap+0x172>
  }
  bn -= NDIRECT;
    8000540c:	fc442783          	lw	a5,-60(s0)
    80005410:	37d1                	addiw	a5,a5,-12
    80005412:	fcf42223          	sw	a5,-60(s0)

  if(bn < NINDIRECT){
    80005416:	fc442783          	lw	a5,-60(s0)
    8000541a:	0007871b          	sext.w	a4,a5
    8000541e:	0ff00793          	li	a5,255
    80005422:	0ce7ea63          	bltu	a5,a4,800054f6 <bmap+0x162>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80005426:	fc843783          	ld	a5,-56(s0)
    8000542a:	0807a783          	lw	a5,128(a5)
    8000542e:	fef42623          	sw	a5,-20(s0)
    80005432:	fec42783          	lw	a5,-20(s0)
    80005436:	2781                	sext.w	a5,a5
    80005438:	eb85                	bnez	a5,80005468 <bmap+0xd4>
      addr = balloc(ip->dev);
    8000543a:	fc843783          	ld	a5,-56(s0)
    8000543e:	439c                	lw	a5,0(a5)
    80005440:	853e                	mv	a0,a5
    80005442:	fffff097          	auipc	ra,0xfffff
    80005446:	63c080e7          	jalr	1596(ra) # 80004a7e <balloc>
    8000544a:	87aa                	mv	a5,a0
    8000544c:	fef42623          	sw	a5,-20(s0)
      if(addr == 0)
    80005450:	fec42783          	lw	a5,-20(s0)
    80005454:	2781                	sext.w	a5,a5
    80005456:	e399                	bnez	a5,8000545c <bmap+0xc8>
        return 0;
    80005458:	4781                	li	a5,0
    8000545a:	a075                	j	80005506 <bmap+0x172>
      ip->addrs[NDIRECT] = addr;
    8000545c:	fc843783          	ld	a5,-56(s0)
    80005460:	fec42703          	lw	a4,-20(s0)
    80005464:	08e7a023          	sw	a4,128(a5)
    }
    bp = bread(ip->dev, addr);
    80005468:	fc843783          	ld	a5,-56(s0)
    8000546c:	439c                	lw	a5,0(a5)
    8000546e:	fec42703          	lw	a4,-20(s0)
    80005472:	85ba                	mv	a1,a4
    80005474:	853e                	mv	a0,a5
    80005476:	fffff097          	auipc	ra,0xfffff
    8000547a:	2be080e7          	jalr	702(ra) # 80004734 <bread>
    8000547e:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    80005482:	fe043783          	ld	a5,-32(s0)
    80005486:	05878793          	addi	a5,a5,88
    8000548a:	fcf43c23          	sd	a5,-40(s0)
    if((addr = a[bn]) == 0){
    8000548e:	fc446783          	lwu	a5,-60(s0)
    80005492:	078a                	slli	a5,a5,0x2
    80005494:	fd843703          	ld	a4,-40(s0)
    80005498:	97ba                	add	a5,a5,a4
    8000549a:	439c                	lw	a5,0(a5)
    8000549c:	fef42623          	sw	a5,-20(s0)
    800054a0:	fec42783          	lw	a5,-20(s0)
    800054a4:	2781                	sext.w	a5,a5
    800054a6:	ef9d                	bnez	a5,800054e4 <bmap+0x150>
      addr = balloc(ip->dev);
    800054a8:	fc843783          	ld	a5,-56(s0)
    800054ac:	439c                	lw	a5,0(a5)
    800054ae:	853e                	mv	a0,a5
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	5ce080e7          	jalr	1486(ra) # 80004a7e <balloc>
    800054b8:	87aa                	mv	a5,a0
    800054ba:	fef42623          	sw	a5,-20(s0)
      if(addr){
    800054be:	fec42783          	lw	a5,-20(s0)
    800054c2:	2781                	sext.w	a5,a5
    800054c4:	c385                	beqz	a5,800054e4 <bmap+0x150>
        a[bn] = addr;
    800054c6:	fc446783          	lwu	a5,-60(s0)
    800054ca:	078a                	slli	a5,a5,0x2
    800054cc:	fd843703          	ld	a4,-40(s0)
    800054d0:	97ba                	add	a5,a5,a4
    800054d2:	fec42703          	lw	a4,-20(s0)
    800054d6:	c398                	sw	a4,0(a5)
        log_write(bp);
    800054d8:	fe043503          	ld	a0,-32(s0)
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	f9e080e7          	jalr	-98(ra) # 8000647a <log_write>
      }
    }
    brelse(bp);
    800054e4:	fe043503          	ld	a0,-32(s0)
    800054e8:	fffff097          	auipc	ra,0xfffff
    800054ec:	2ee080e7          	jalr	750(ra) # 800047d6 <brelse>
    return addr;
    800054f0:	fec42783          	lw	a5,-20(s0)
    800054f4:	a809                	j	80005506 <bmap+0x172>
  }

  panic("bmap: out of range");
    800054f6:	00006517          	auipc	a0,0x6
    800054fa:	00a50513          	addi	a0,a0,10 # 8000b500 <etext+0x500>
    800054fe:	ffffb097          	auipc	ra,0xffffb
    80005502:	78c080e7          	jalr	1932(ra) # 80000c8a <panic>
}
    80005506:	853e                	mv	a0,a5
    80005508:	70e2                	ld	ra,56(sp)
    8000550a:	7442                	ld	s0,48(sp)
    8000550c:	6121                	addi	sp,sp,64
    8000550e:	8082                	ret

0000000080005510 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80005510:	7139                	addi	sp,sp,-64
    80005512:	fc06                	sd	ra,56(sp)
    80005514:	f822                	sd	s0,48(sp)
    80005516:	0080                	addi	s0,sp,64
    80005518:	fca43423          	sd	a0,-56(s0)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000551c:	fe042623          	sw	zero,-20(s0)
    80005520:	a899                	j	80005576 <itrunc+0x66>
    if(ip->addrs[i]){
    80005522:	fc843703          	ld	a4,-56(s0)
    80005526:	fec42783          	lw	a5,-20(s0)
    8000552a:	07d1                	addi	a5,a5,20
    8000552c:	078a                	slli	a5,a5,0x2
    8000552e:	97ba                	add	a5,a5,a4
    80005530:	439c                	lw	a5,0(a5)
    80005532:	cf8d                	beqz	a5,8000556c <itrunc+0x5c>
      bfree(ip->dev, ip->addrs[i]);
    80005534:	fc843783          	ld	a5,-56(s0)
    80005538:	439c                	lw	a5,0(a5)
    8000553a:	0007869b          	sext.w	a3,a5
    8000553e:	fc843703          	ld	a4,-56(s0)
    80005542:	fec42783          	lw	a5,-20(s0)
    80005546:	07d1                	addi	a5,a5,20
    80005548:	078a                	slli	a5,a5,0x2
    8000554a:	97ba                	add	a5,a5,a4
    8000554c:	439c                	lw	a5,0(a5)
    8000554e:	85be                	mv	a1,a5
    80005550:	8536                	mv	a0,a3
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	6d4080e7          	jalr	1748(ra) # 80004c26 <bfree>
      ip->addrs[i] = 0;
    8000555a:	fc843703          	ld	a4,-56(s0)
    8000555e:	fec42783          	lw	a5,-20(s0)
    80005562:	07d1                	addi	a5,a5,20
    80005564:	078a                	slli	a5,a5,0x2
    80005566:	97ba                	add	a5,a5,a4
    80005568:	0007a023          	sw	zero,0(a5)
  for(i = 0; i < NDIRECT; i++){
    8000556c:	fec42783          	lw	a5,-20(s0)
    80005570:	2785                	addiw	a5,a5,1
    80005572:	fef42623          	sw	a5,-20(s0)
    80005576:	fec42783          	lw	a5,-20(s0)
    8000557a:	0007871b          	sext.w	a4,a5
    8000557e:	47ad                	li	a5,11
    80005580:	fae7d1e3          	bge	a5,a4,80005522 <itrunc+0x12>
    }
  }

  if(ip->addrs[NDIRECT]){
    80005584:	fc843783          	ld	a5,-56(s0)
    80005588:	0807a783          	lw	a5,128(a5)
    8000558c:	cbc5                	beqz	a5,8000563c <itrunc+0x12c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000558e:	fc843783          	ld	a5,-56(s0)
    80005592:	4398                	lw	a4,0(a5)
    80005594:	fc843783          	ld	a5,-56(s0)
    80005598:	0807a783          	lw	a5,128(a5)
    8000559c:	85be                	mv	a1,a5
    8000559e:	853a                	mv	a0,a4
    800055a0:	fffff097          	auipc	ra,0xfffff
    800055a4:	194080e7          	jalr	404(ra) # 80004734 <bread>
    800055a8:	fea43023          	sd	a0,-32(s0)
    a = (uint*)bp->data;
    800055ac:	fe043783          	ld	a5,-32(s0)
    800055b0:	05878793          	addi	a5,a5,88
    800055b4:	fcf43c23          	sd	a5,-40(s0)
    for(j = 0; j < NINDIRECT; j++){
    800055b8:	fe042423          	sw	zero,-24(s0)
    800055bc:	a081                	j	800055fc <itrunc+0xec>
      if(a[j])
    800055be:	fe842783          	lw	a5,-24(s0)
    800055c2:	078a                	slli	a5,a5,0x2
    800055c4:	fd843703          	ld	a4,-40(s0)
    800055c8:	97ba                	add	a5,a5,a4
    800055ca:	439c                	lw	a5,0(a5)
    800055cc:	c39d                	beqz	a5,800055f2 <itrunc+0xe2>
        bfree(ip->dev, a[j]);
    800055ce:	fc843783          	ld	a5,-56(s0)
    800055d2:	439c                	lw	a5,0(a5)
    800055d4:	0007869b          	sext.w	a3,a5
    800055d8:	fe842783          	lw	a5,-24(s0)
    800055dc:	078a                	slli	a5,a5,0x2
    800055de:	fd843703          	ld	a4,-40(s0)
    800055e2:	97ba                	add	a5,a5,a4
    800055e4:	439c                	lw	a5,0(a5)
    800055e6:	85be                	mv	a1,a5
    800055e8:	8536                	mv	a0,a3
    800055ea:	fffff097          	auipc	ra,0xfffff
    800055ee:	63c080e7          	jalr	1596(ra) # 80004c26 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800055f2:	fe842783          	lw	a5,-24(s0)
    800055f6:	2785                	addiw	a5,a5,1
    800055f8:	fef42423          	sw	a5,-24(s0)
    800055fc:	fe842783          	lw	a5,-24(s0)
    80005600:	873e                	mv	a4,a5
    80005602:	0ff00793          	li	a5,255
    80005606:	fae7fce3          	bgeu	a5,a4,800055be <itrunc+0xae>
    }
    brelse(bp);
    8000560a:	fe043503          	ld	a0,-32(s0)
    8000560e:	fffff097          	auipc	ra,0xfffff
    80005612:	1c8080e7          	jalr	456(ra) # 800047d6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80005616:	fc843783          	ld	a5,-56(s0)
    8000561a:	439c                	lw	a5,0(a5)
    8000561c:	0007871b          	sext.w	a4,a5
    80005620:	fc843783          	ld	a5,-56(s0)
    80005624:	0807a783          	lw	a5,128(a5)
    80005628:	85be                	mv	a1,a5
    8000562a:	853a                	mv	a0,a4
    8000562c:	fffff097          	auipc	ra,0xfffff
    80005630:	5fa080e7          	jalr	1530(ra) # 80004c26 <bfree>
    ip->addrs[NDIRECT] = 0;
    80005634:	fc843783          	ld	a5,-56(s0)
    80005638:	0807a023          	sw	zero,128(a5)
  }

  ip->size = 0;
    8000563c:	fc843783          	ld	a5,-56(s0)
    80005640:	0407a623          	sw	zero,76(a5)
  iupdate(ip);
    80005644:	fc843503          	ld	a0,-56(s0)
    80005648:	00000097          	auipc	ra,0x0
    8000564c:	870080e7          	jalr	-1936(ra) # 80004eb8 <iupdate>
}
    80005650:	0001                	nop
    80005652:	70e2                	ld	ra,56(sp)
    80005654:	7442                	ld	s0,48(sp)
    80005656:	6121                	addi	sp,sp,64
    80005658:	8082                	ret

000000008000565a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000565a:	1101                	addi	sp,sp,-32
    8000565c:	ec22                	sd	s0,24(sp)
    8000565e:	1000                	addi	s0,sp,32
    80005660:	fea43423          	sd	a0,-24(s0)
    80005664:	feb43023          	sd	a1,-32(s0)
  st->dev = ip->dev;
    80005668:	fe843783          	ld	a5,-24(s0)
    8000566c:	439c                	lw	a5,0(a5)
    8000566e:	0007871b          	sext.w	a4,a5
    80005672:	fe043783          	ld	a5,-32(s0)
    80005676:	c398                	sw	a4,0(a5)
  st->ino = ip->inum;
    80005678:	fe843783          	ld	a5,-24(s0)
    8000567c:	43d8                	lw	a4,4(a5)
    8000567e:	fe043783          	ld	a5,-32(s0)
    80005682:	c3d8                	sw	a4,4(a5)
  st->type = ip->type;
    80005684:	fe843783          	ld	a5,-24(s0)
    80005688:	04479703          	lh	a4,68(a5)
    8000568c:	fe043783          	ld	a5,-32(s0)
    80005690:	00e79423          	sh	a4,8(a5)
  st->nlink = ip->nlink;
    80005694:	fe843783          	ld	a5,-24(s0)
    80005698:	04a79703          	lh	a4,74(a5)
    8000569c:	fe043783          	ld	a5,-32(s0)
    800056a0:	00e79523          	sh	a4,10(a5)
  st->size = ip->size;
    800056a4:	fe843783          	ld	a5,-24(s0)
    800056a8:	47fc                	lw	a5,76(a5)
    800056aa:	02079713          	slli	a4,a5,0x20
    800056ae:	9301                	srli	a4,a4,0x20
    800056b0:	fe043783          	ld	a5,-32(s0)
    800056b4:	eb98                	sd	a4,16(a5)
}
    800056b6:	0001                	nop
    800056b8:	6462                	ld	s0,24(sp)
    800056ba:	6105                	addi	sp,sp,32
    800056bc:	8082                	ret

00000000800056be <readi>:
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    800056be:	715d                	addi	sp,sp,-80
    800056c0:	e486                	sd	ra,72(sp)
    800056c2:	e0a2                	sd	s0,64(sp)
    800056c4:	0880                	addi	s0,sp,80
    800056c6:	fca43423          	sd	a0,-56(s0)
    800056ca:	87ae                	mv	a5,a1
    800056cc:	fac43c23          	sd	a2,-72(s0)
    800056d0:	fcf42223          	sw	a5,-60(s0)
    800056d4:	87b6                	mv	a5,a3
    800056d6:	fcf42023          	sw	a5,-64(s0)
    800056da:	87ba                	mv	a5,a4
    800056dc:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800056e0:	fc843783          	ld	a5,-56(s0)
    800056e4:	47f8                	lw	a4,76(a5)
    800056e6:	fc042783          	lw	a5,-64(s0)
    800056ea:	2781                	sext.w	a5,a5
    800056ec:	00f76f63          	bltu	a4,a5,8000570a <readi+0x4c>
    800056f0:	fc042783          	lw	a5,-64(s0)
    800056f4:	873e                	mv	a4,a5
    800056f6:	fb442783          	lw	a5,-76(s0)
    800056fa:	9fb9                	addw	a5,a5,a4
    800056fc:	0007871b          	sext.w	a4,a5
    80005700:	fc042783          	lw	a5,-64(s0)
    80005704:	2781                	sext.w	a5,a5
    80005706:	00f77463          	bgeu	a4,a5,8000570e <readi+0x50>
    return 0;
    8000570a:	4781                	li	a5,0
    8000570c:	a299                	j	80005852 <readi+0x194>
  if(off + n > ip->size)
    8000570e:	fc042783          	lw	a5,-64(s0)
    80005712:	873e                	mv	a4,a5
    80005714:	fb442783          	lw	a5,-76(s0)
    80005718:	9fb9                	addw	a5,a5,a4
    8000571a:	0007871b          	sext.w	a4,a5
    8000571e:	fc843783          	ld	a5,-56(s0)
    80005722:	47fc                	lw	a5,76(a5)
    80005724:	00e7fa63          	bgeu	a5,a4,80005738 <readi+0x7a>
    n = ip->size - off;
    80005728:	fc843783          	ld	a5,-56(s0)
    8000572c:	47fc                	lw	a5,76(a5)
    8000572e:	fc042703          	lw	a4,-64(s0)
    80005732:	9f99                	subw	a5,a5,a4
    80005734:	faf42a23          	sw	a5,-76(s0)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005738:	fe042623          	sw	zero,-20(s0)
    8000573c:	a8f5                	j	80005838 <readi+0x17a>
    uint addr = bmap(ip, off/BSIZE);
    8000573e:	fc042783          	lw	a5,-64(s0)
    80005742:	00a7d79b          	srliw	a5,a5,0xa
    80005746:	2781                	sext.w	a5,a5
    80005748:	85be                	mv	a1,a5
    8000574a:	fc843503          	ld	a0,-56(s0)
    8000574e:	00000097          	auipc	ra,0x0
    80005752:	c46080e7          	jalr	-954(ra) # 80005394 <bmap>
    80005756:	87aa                	mv	a5,a0
    80005758:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    8000575c:	fe842783          	lw	a5,-24(s0)
    80005760:	2781                	sext.w	a5,a5
    80005762:	c7ed                	beqz	a5,8000584c <readi+0x18e>
      break;
    bp = bread(ip->dev, addr);
    80005764:	fc843783          	ld	a5,-56(s0)
    80005768:	439c                	lw	a5,0(a5)
    8000576a:	fe842703          	lw	a4,-24(s0)
    8000576e:	85ba                	mv	a1,a4
    80005770:	853e                	mv	a0,a5
    80005772:	fffff097          	auipc	ra,0xfffff
    80005776:	fc2080e7          	jalr	-62(ra) # 80004734 <bread>
    8000577a:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    8000577e:	fc042783          	lw	a5,-64(s0)
    80005782:	3ff7f793          	andi	a5,a5,1023
    80005786:	2781                	sext.w	a5,a5
    80005788:	40000713          	li	a4,1024
    8000578c:	40f707bb          	subw	a5,a4,a5
    80005790:	2781                	sext.w	a5,a5
    80005792:	fb442703          	lw	a4,-76(s0)
    80005796:	86ba                	mv	a3,a4
    80005798:	fec42703          	lw	a4,-20(s0)
    8000579c:	40e6873b          	subw	a4,a3,a4
    800057a0:	2701                	sext.w	a4,a4
    800057a2:	863a                	mv	a2,a4
    800057a4:	0007869b          	sext.w	a3,a5
    800057a8:	0006071b          	sext.w	a4,a2
    800057ac:	00d77363          	bgeu	a4,a3,800057b2 <readi+0xf4>
    800057b0:	87b2                	mv	a5,a2
    800057b2:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800057b6:	fe043783          	ld	a5,-32(s0)
    800057ba:	05878713          	addi	a4,a5,88
    800057be:	fc046783          	lwu	a5,-64(s0)
    800057c2:	3ff7f793          	andi	a5,a5,1023
    800057c6:	973e                	add	a4,a4,a5
    800057c8:	fdc46683          	lwu	a3,-36(s0)
    800057cc:	fc442783          	lw	a5,-60(s0)
    800057d0:	863a                	mv	a2,a4
    800057d2:	fb843583          	ld	a1,-72(s0)
    800057d6:	853e                	mv	a0,a5
    800057d8:	ffffe097          	auipc	ra,0xffffe
    800057dc:	e5a080e7          	jalr	-422(ra) # 80003632 <either_copyout>
    800057e0:	87aa                	mv	a5,a0
    800057e2:	873e                	mv	a4,a5
    800057e4:	57fd                	li	a5,-1
    800057e6:	00f71c63          	bne	a4,a5,800057fe <readi+0x140>
      brelse(bp);
    800057ea:	fe043503          	ld	a0,-32(s0)
    800057ee:	fffff097          	auipc	ra,0xfffff
    800057f2:	fe8080e7          	jalr	-24(ra) # 800047d6 <brelse>
      tot = -1;
    800057f6:	57fd                	li	a5,-1
    800057f8:	fef42623          	sw	a5,-20(s0)
      break;
    800057fc:	a889                	j	8000584e <readi+0x190>
    }
    brelse(bp);
    800057fe:	fe043503          	ld	a0,-32(s0)
    80005802:	fffff097          	auipc	ra,0xfffff
    80005806:	fd4080e7          	jalr	-44(ra) # 800047d6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000580a:	fec42783          	lw	a5,-20(s0)
    8000580e:	873e                	mv	a4,a5
    80005810:	fdc42783          	lw	a5,-36(s0)
    80005814:	9fb9                	addw	a5,a5,a4
    80005816:	fef42623          	sw	a5,-20(s0)
    8000581a:	fc042783          	lw	a5,-64(s0)
    8000581e:	873e                	mv	a4,a5
    80005820:	fdc42783          	lw	a5,-36(s0)
    80005824:	9fb9                	addw	a5,a5,a4
    80005826:	fcf42023          	sw	a5,-64(s0)
    8000582a:	fdc46783          	lwu	a5,-36(s0)
    8000582e:	fb843703          	ld	a4,-72(s0)
    80005832:	97ba                	add	a5,a5,a4
    80005834:	faf43c23          	sd	a5,-72(s0)
    80005838:	fec42783          	lw	a5,-20(s0)
    8000583c:	873e                	mv	a4,a5
    8000583e:	fb442783          	lw	a5,-76(s0)
    80005842:	2701                	sext.w	a4,a4
    80005844:	2781                	sext.w	a5,a5
    80005846:	eef76ce3          	bltu	a4,a5,8000573e <readi+0x80>
    8000584a:	a011                	j	8000584e <readi+0x190>
      break;
    8000584c:	0001                	nop
  }
  return tot;
    8000584e:	fec42783          	lw	a5,-20(s0)
}
    80005852:	853e                	mv	a0,a5
    80005854:	60a6                	ld	ra,72(sp)
    80005856:	6406                	ld	s0,64(sp)
    80005858:	6161                	addi	sp,sp,80
    8000585a:	8082                	ret

000000008000585c <writei>:
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    8000585c:	715d                	addi	sp,sp,-80
    8000585e:	e486                	sd	ra,72(sp)
    80005860:	e0a2                	sd	s0,64(sp)
    80005862:	0880                	addi	s0,sp,80
    80005864:	fca43423          	sd	a0,-56(s0)
    80005868:	87ae                	mv	a5,a1
    8000586a:	fac43c23          	sd	a2,-72(s0)
    8000586e:	fcf42223          	sw	a5,-60(s0)
    80005872:	87b6                	mv	a5,a3
    80005874:	fcf42023          	sw	a5,-64(s0)
    80005878:	87ba                	mv	a5,a4
    8000587a:	faf42a23          	sw	a5,-76(s0)
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000587e:	fc843783          	ld	a5,-56(s0)
    80005882:	47f8                	lw	a4,76(a5)
    80005884:	fc042783          	lw	a5,-64(s0)
    80005888:	2781                	sext.w	a5,a5
    8000588a:	00f76f63          	bltu	a4,a5,800058a8 <writei+0x4c>
    8000588e:	fc042783          	lw	a5,-64(s0)
    80005892:	873e                	mv	a4,a5
    80005894:	fb442783          	lw	a5,-76(s0)
    80005898:	9fb9                	addw	a5,a5,a4
    8000589a:	0007871b          	sext.w	a4,a5
    8000589e:	fc042783          	lw	a5,-64(s0)
    800058a2:	2781                	sext.w	a5,a5
    800058a4:	00f77463          	bgeu	a4,a5,800058ac <writei+0x50>
    return -1;
    800058a8:	57fd                	li	a5,-1
    800058aa:	a295                	j	80005a0e <writei+0x1b2>
  if(off + n > MAXFILE*BSIZE)
    800058ac:	fc042783          	lw	a5,-64(s0)
    800058b0:	873e                	mv	a4,a5
    800058b2:	fb442783          	lw	a5,-76(s0)
    800058b6:	9fb9                	addw	a5,a5,a4
    800058b8:	2781                	sext.w	a5,a5
    800058ba:	873e                	mv	a4,a5
    800058bc:	000437b7          	lui	a5,0x43
    800058c0:	00e7f463          	bgeu	a5,a4,800058c8 <writei+0x6c>
    return -1;
    800058c4:	57fd                	li	a5,-1
    800058c6:	a2a1                	j	80005a0e <writei+0x1b2>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800058c8:	fe042623          	sw	zero,-20(s0)
    800058cc:	a209                	j	800059ce <writei+0x172>
    uint addr = bmap(ip, off/BSIZE);
    800058ce:	fc042783          	lw	a5,-64(s0)
    800058d2:	00a7d79b          	srliw	a5,a5,0xa
    800058d6:	2781                	sext.w	a5,a5
    800058d8:	85be                	mv	a1,a5
    800058da:	fc843503          	ld	a0,-56(s0)
    800058de:	00000097          	auipc	ra,0x0
    800058e2:	ab6080e7          	jalr	-1354(ra) # 80005394 <bmap>
    800058e6:	87aa                	mv	a5,a0
    800058e8:	fef42423          	sw	a5,-24(s0)
    if(addr == 0)
    800058ec:	fe842783          	lw	a5,-24(s0)
    800058f0:	2781                	sext.w	a5,a5
    800058f2:	cbe5                	beqz	a5,800059e2 <writei+0x186>
      break;
    bp = bread(ip->dev, addr);
    800058f4:	fc843783          	ld	a5,-56(s0)
    800058f8:	439c                	lw	a5,0(a5)
    800058fa:	fe842703          	lw	a4,-24(s0)
    800058fe:	85ba                	mv	a1,a4
    80005900:	853e                	mv	a0,a5
    80005902:	fffff097          	auipc	ra,0xfffff
    80005906:	e32080e7          	jalr	-462(ra) # 80004734 <bread>
    8000590a:	fea43023          	sd	a0,-32(s0)
    m = min(n - tot, BSIZE - off%BSIZE);
    8000590e:	fc042783          	lw	a5,-64(s0)
    80005912:	3ff7f793          	andi	a5,a5,1023
    80005916:	2781                	sext.w	a5,a5
    80005918:	40000713          	li	a4,1024
    8000591c:	40f707bb          	subw	a5,a4,a5
    80005920:	2781                	sext.w	a5,a5
    80005922:	fb442703          	lw	a4,-76(s0)
    80005926:	86ba                	mv	a3,a4
    80005928:	fec42703          	lw	a4,-20(s0)
    8000592c:	40e6873b          	subw	a4,a3,a4
    80005930:	2701                	sext.w	a4,a4
    80005932:	863a                	mv	a2,a4
    80005934:	0007869b          	sext.w	a3,a5
    80005938:	0006071b          	sext.w	a4,a2
    8000593c:	00d77363          	bgeu	a4,a3,80005942 <writei+0xe6>
    80005940:	87b2                	mv	a5,a2
    80005942:	fcf42e23          	sw	a5,-36(s0)
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80005946:	fe043783          	ld	a5,-32(s0)
    8000594a:	05878713          	addi	a4,a5,88 # 43058 <_entry-0x7ffbcfa8>
    8000594e:	fc046783          	lwu	a5,-64(s0)
    80005952:	3ff7f793          	andi	a5,a5,1023
    80005956:	97ba                	add	a5,a5,a4
    80005958:	fdc46683          	lwu	a3,-36(s0)
    8000595c:	fc442703          	lw	a4,-60(s0)
    80005960:	fb843603          	ld	a2,-72(s0)
    80005964:	85ba                	mv	a1,a4
    80005966:	853e                	mv	a0,a5
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	d3e080e7          	jalr	-706(ra) # 800036a6 <either_copyin>
    80005970:	87aa                	mv	a5,a0
    80005972:	873e                	mv	a4,a5
    80005974:	57fd                	li	a5,-1
    80005976:	00f71963          	bne	a4,a5,80005988 <writei+0x12c>
      brelse(bp);
    8000597a:	fe043503          	ld	a0,-32(s0)
    8000597e:	fffff097          	auipc	ra,0xfffff
    80005982:	e58080e7          	jalr	-424(ra) # 800047d6 <brelse>
      break;
    80005986:	a8b9                	j	800059e4 <writei+0x188>
    }
    log_write(bp);
    80005988:	fe043503          	ld	a0,-32(s0)
    8000598c:	00001097          	auipc	ra,0x1
    80005990:	aee080e7          	jalr	-1298(ra) # 8000647a <log_write>
    brelse(bp);
    80005994:	fe043503          	ld	a0,-32(s0)
    80005998:	fffff097          	auipc	ra,0xfffff
    8000599c:	e3e080e7          	jalr	-450(ra) # 800047d6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800059a0:	fec42783          	lw	a5,-20(s0)
    800059a4:	873e                	mv	a4,a5
    800059a6:	fdc42783          	lw	a5,-36(s0)
    800059aa:	9fb9                	addw	a5,a5,a4
    800059ac:	fef42623          	sw	a5,-20(s0)
    800059b0:	fc042783          	lw	a5,-64(s0)
    800059b4:	873e                	mv	a4,a5
    800059b6:	fdc42783          	lw	a5,-36(s0)
    800059ba:	9fb9                	addw	a5,a5,a4
    800059bc:	fcf42023          	sw	a5,-64(s0)
    800059c0:	fdc46783          	lwu	a5,-36(s0)
    800059c4:	fb843703          	ld	a4,-72(s0)
    800059c8:	97ba                	add	a5,a5,a4
    800059ca:	faf43c23          	sd	a5,-72(s0)
    800059ce:	fec42783          	lw	a5,-20(s0)
    800059d2:	873e                	mv	a4,a5
    800059d4:	fb442783          	lw	a5,-76(s0)
    800059d8:	2701                	sext.w	a4,a4
    800059da:	2781                	sext.w	a5,a5
    800059dc:	eef769e3          	bltu	a4,a5,800058ce <writei+0x72>
    800059e0:	a011                	j	800059e4 <writei+0x188>
      break;
    800059e2:	0001                	nop
  }

  if(off > ip->size)
    800059e4:	fc843783          	ld	a5,-56(s0)
    800059e8:	47f8                	lw	a4,76(a5)
    800059ea:	fc042783          	lw	a5,-64(s0)
    800059ee:	2781                	sext.w	a5,a5
    800059f0:	00f77763          	bgeu	a4,a5,800059fe <writei+0x1a2>
    ip->size = off;
    800059f4:	fc843783          	ld	a5,-56(s0)
    800059f8:	fc042703          	lw	a4,-64(s0)
    800059fc:	c7f8                	sw	a4,76(a5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800059fe:	fc843503          	ld	a0,-56(s0)
    80005a02:	fffff097          	auipc	ra,0xfffff
    80005a06:	4b6080e7          	jalr	1206(ra) # 80004eb8 <iupdate>

  return tot;
    80005a0a:	fec42783          	lw	a5,-20(s0)
}
    80005a0e:	853e                	mv	a0,a5
    80005a10:	60a6                	ld	ra,72(sp)
    80005a12:	6406                	ld	s0,64(sp)
    80005a14:	6161                	addi	sp,sp,80
    80005a16:	8082                	ret

0000000080005a18 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80005a18:	1101                	addi	sp,sp,-32
    80005a1a:	ec06                	sd	ra,24(sp)
    80005a1c:	e822                	sd	s0,16(sp)
    80005a1e:	1000                	addi	s0,sp,32
    80005a20:	fea43423          	sd	a0,-24(s0)
    80005a24:	feb43023          	sd	a1,-32(s0)
  return strncmp(s, t, DIRSIZ);
    80005a28:	4639                	li	a2,14
    80005a2a:	fe043583          	ld	a1,-32(s0)
    80005a2e:	fe843503          	ld	a0,-24(s0)
    80005a32:	ffffc097          	auipc	ra,0xffffc
    80005a36:	c18080e7          	jalr	-1000(ra) # 8000164a <strncmp>
    80005a3a:	87aa                	mv	a5,a0
}
    80005a3c:	853e                	mv	a0,a5
    80005a3e:	60e2                	ld	ra,24(sp)
    80005a40:	6442                	ld	s0,16(sp)
    80005a42:	6105                	addi	sp,sp,32
    80005a44:	8082                	ret

0000000080005a46 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80005a46:	715d                	addi	sp,sp,-80
    80005a48:	e486                	sd	ra,72(sp)
    80005a4a:	e0a2                	sd	s0,64(sp)
    80005a4c:	0880                	addi	s0,sp,80
    80005a4e:	fca43423          	sd	a0,-56(s0)
    80005a52:	fcb43023          	sd	a1,-64(s0)
    80005a56:	fac43c23          	sd	a2,-72(s0)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80005a5a:	fc843783          	ld	a5,-56(s0)
    80005a5e:	04479783          	lh	a5,68(a5)
    80005a62:	873e                	mv	a4,a5
    80005a64:	4785                	li	a5,1
    80005a66:	00f70a63          	beq	a4,a5,80005a7a <dirlookup+0x34>
    panic("dirlookup not DIR");
    80005a6a:	00006517          	auipc	a0,0x6
    80005a6e:	aae50513          	addi	a0,a0,-1362 # 8000b518 <etext+0x518>
    80005a72:	ffffb097          	auipc	ra,0xffffb
    80005a76:	218080e7          	jalr	536(ra) # 80000c8a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005a7a:	fe042623          	sw	zero,-20(s0)
    80005a7e:	a849                	j	80005b10 <dirlookup+0xca>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a80:	fd840793          	addi	a5,s0,-40
    80005a84:	fec42683          	lw	a3,-20(s0)
    80005a88:	4741                	li	a4,16
    80005a8a:	863e                	mv	a2,a5
    80005a8c:	4581                	li	a1,0
    80005a8e:	fc843503          	ld	a0,-56(s0)
    80005a92:	00000097          	auipc	ra,0x0
    80005a96:	c2c080e7          	jalr	-980(ra) # 800056be <readi>
    80005a9a:	87aa                	mv	a5,a0
    80005a9c:	873e                	mv	a4,a5
    80005a9e:	47c1                	li	a5,16
    80005aa0:	00f70a63          	beq	a4,a5,80005ab4 <dirlookup+0x6e>
      panic("dirlookup read");
    80005aa4:	00006517          	auipc	a0,0x6
    80005aa8:	a8c50513          	addi	a0,a0,-1396 # 8000b530 <etext+0x530>
    80005aac:	ffffb097          	auipc	ra,0xffffb
    80005ab0:	1de080e7          	jalr	478(ra) # 80000c8a <panic>
    if(de.inum == 0)
    80005ab4:	fd845783          	lhu	a5,-40(s0)
    80005ab8:	c7b1                	beqz	a5,80005b04 <dirlookup+0xbe>
      continue;
    if(namecmp(name, de.name) == 0){
    80005aba:	fd840793          	addi	a5,s0,-40
    80005abe:	0789                	addi	a5,a5,2
    80005ac0:	85be                	mv	a1,a5
    80005ac2:	fc043503          	ld	a0,-64(s0)
    80005ac6:	00000097          	auipc	ra,0x0
    80005aca:	f52080e7          	jalr	-174(ra) # 80005a18 <namecmp>
    80005ace:	87aa                	mv	a5,a0
    80005ad0:	eb9d                	bnez	a5,80005b06 <dirlookup+0xc0>
      // entry matches path element
      if(poff)
    80005ad2:	fb843783          	ld	a5,-72(s0)
    80005ad6:	c791                	beqz	a5,80005ae2 <dirlookup+0x9c>
        *poff = off;
    80005ad8:	fb843783          	ld	a5,-72(s0)
    80005adc:	fec42703          	lw	a4,-20(s0)
    80005ae0:	c398                	sw	a4,0(a5)
      inum = de.inum;
    80005ae2:	fd845783          	lhu	a5,-40(s0)
    80005ae6:	fef42423          	sw	a5,-24(s0)
      return iget(dp->dev, inum);
    80005aea:	fc843783          	ld	a5,-56(s0)
    80005aee:	439c                	lw	a5,0(a5)
    80005af0:	fe842703          	lw	a4,-24(s0)
    80005af4:	85ba                	mv	a1,a4
    80005af6:	853e                	mv	a0,a5
    80005af8:	fffff097          	auipc	ra,0xfffff
    80005afc:	4a8080e7          	jalr	1192(ra) # 80004fa0 <iget>
    80005b00:	87aa                	mv	a5,a0
    80005b02:	a005                	j	80005b22 <dirlookup+0xdc>
      continue;
    80005b04:	0001                	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b06:	fec42783          	lw	a5,-20(s0)
    80005b0a:	27c1                	addiw	a5,a5,16
    80005b0c:	fef42623          	sw	a5,-20(s0)
    80005b10:	fc843783          	ld	a5,-56(s0)
    80005b14:	47f8                	lw	a4,76(a5)
    80005b16:	fec42783          	lw	a5,-20(s0)
    80005b1a:	2781                	sext.w	a5,a5
    80005b1c:	f6e7e2e3          	bltu	a5,a4,80005a80 <dirlookup+0x3a>
    }
  }

  return 0;
    80005b20:	4781                	li	a5,0
}
    80005b22:	853e                	mv	a0,a5
    80005b24:	60a6                	ld	ra,72(sp)
    80005b26:	6406                	ld	s0,64(sp)
    80005b28:	6161                	addi	sp,sp,80
    80005b2a:	8082                	ret

0000000080005b2c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
// Returns 0 on success, -1 on failure (e.g. out of disk blocks).
int
dirlink(struct inode *dp, char *name, uint inum)
{
    80005b2c:	715d                	addi	sp,sp,-80
    80005b2e:	e486                	sd	ra,72(sp)
    80005b30:	e0a2                	sd	s0,64(sp)
    80005b32:	0880                	addi	s0,sp,80
    80005b34:	fca43423          	sd	a0,-56(s0)
    80005b38:	fcb43023          	sd	a1,-64(s0)
    80005b3c:	87b2                	mv	a5,a2
    80005b3e:	faf42e23          	sw	a5,-68(s0)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    80005b42:	4601                	li	a2,0
    80005b44:	fc043583          	ld	a1,-64(s0)
    80005b48:	fc843503          	ld	a0,-56(s0)
    80005b4c:	00000097          	auipc	ra,0x0
    80005b50:	efa080e7          	jalr	-262(ra) # 80005a46 <dirlookup>
    80005b54:	fea43023          	sd	a0,-32(s0)
    80005b58:	fe043783          	ld	a5,-32(s0)
    80005b5c:	cb89                	beqz	a5,80005b6e <dirlink+0x42>
    iput(ip);
    80005b5e:	fe043503          	ld	a0,-32(s0)
    80005b62:	fffff097          	auipc	ra,0xfffff
    80005b66:	734080e7          	jalr	1844(ra) # 80005296 <iput>
    return -1;
    80005b6a:	57fd                	li	a5,-1
    80005b6c:	a075                	j	80005c18 <dirlink+0xec>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005b6e:	fe042623          	sw	zero,-20(s0)
    80005b72:	a0a1                	j	80005bba <dirlink+0x8e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b74:	fd040793          	addi	a5,s0,-48
    80005b78:	fec42683          	lw	a3,-20(s0)
    80005b7c:	4741                	li	a4,16
    80005b7e:	863e                	mv	a2,a5
    80005b80:	4581                	li	a1,0
    80005b82:	fc843503          	ld	a0,-56(s0)
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	b38080e7          	jalr	-1224(ra) # 800056be <readi>
    80005b8e:	87aa                	mv	a5,a0
    80005b90:	873e                	mv	a4,a5
    80005b92:	47c1                	li	a5,16
    80005b94:	00f70a63          	beq	a4,a5,80005ba8 <dirlink+0x7c>
      panic("dirlink read");
    80005b98:	00006517          	auipc	a0,0x6
    80005b9c:	9a850513          	addi	a0,a0,-1624 # 8000b540 <etext+0x540>
    80005ba0:	ffffb097          	auipc	ra,0xffffb
    80005ba4:	0ea080e7          	jalr	234(ra) # 80000c8a <panic>
    if(de.inum == 0)
    80005ba8:	fd045783          	lhu	a5,-48(s0)
    80005bac:	cf99                	beqz	a5,80005bca <dirlink+0x9e>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005bae:	fec42783          	lw	a5,-20(s0)
    80005bb2:	27c1                	addiw	a5,a5,16
    80005bb4:	2781                	sext.w	a5,a5
    80005bb6:	fef42623          	sw	a5,-20(s0)
    80005bba:	fc843783          	ld	a5,-56(s0)
    80005bbe:	47f8                	lw	a4,76(a5)
    80005bc0:	fec42783          	lw	a5,-20(s0)
    80005bc4:	fae7e8e3          	bltu	a5,a4,80005b74 <dirlink+0x48>
    80005bc8:	a011                	j	80005bcc <dirlink+0xa0>
      break;
    80005bca:	0001                	nop
  }

  strncpy(de.name, name, DIRSIZ);
    80005bcc:	fd040793          	addi	a5,s0,-48
    80005bd0:	0789                	addi	a5,a5,2
    80005bd2:	4639                	li	a2,14
    80005bd4:	fc043583          	ld	a1,-64(s0)
    80005bd8:	853e                	mv	a0,a5
    80005bda:	ffffc097          	auipc	ra,0xffffc
    80005bde:	afa080e7          	jalr	-1286(ra) # 800016d4 <strncpy>
  de.inum = inum;
    80005be2:	fbc42783          	lw	a5,-68(s0)
    80005be6:	17c2                	slli	a5,a5,0x30
    80005be8:	93c1                	srli	a5,a5,0x30
    80005bea:	fcf41823          	sh	a5,-48(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005bee:	fd040793          	addi	a5,s0,-48
    80005bf2:	fec42683          	lw	a3,-20(s0)
    80005bf6:	4741                	li	a4,16
    80005bf8:	863e                	mv	a2,a5
    80005bfa:	4581                	li	a1,0
    80005bfc:	fc843503          	ld	a0,-56(s0)
    80005c00:	00000097          	auipc	ra,0x0
    80005c04:	c5c080e7          	jalr	-932(ra) # 8000585c <writei>
    80005c08:	87aa                	mv	a5,a0
    80005c0a:	873e                	mv	a4,a5
    80005c0c:	47c1                	li	a5,16
    80005c0e:	00f70463          	beq	a4,a5,80005c16 <dirlink+0xea>
    return -1;
    80005c12:	57fd                	li	a5,-1
    80005c14:	a011                	j	80005c18 <dirlink+0xec>

  return 0;
    80005c16:	4781                	li	a5,0
}
    80005c18:	853e                	mv	a0,a5
    80005c1a:	60a6                	ld	ra,72(sp)
    80005c1c:	6406                	ld	s0,64(sp)
    80005c1e:	6161                	addi	sp,sp,80
    80005c20:	8082                	ret

0000000080005c22 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
    80005c22:	7179                	addi	sp,sp,-48
    80005c24:	f406                	sd	ra,40(sp)
    80005c26:	f022                	sd	s0,32(sp)
    80005c28:	1800                	addi	s0,sp,48
    80005c2a:	fca43c23          	sd	a0,-40(s0)
    80005c2e:	fcb43823          	sd	a1,-48(s0)
  char *s;
  int len;

  while(*path == '/')
    80005c32:	a031                	j	80005c3e <skipelem+0x1c>
    path++;
    80005c34:	fd843783          	ld	a5,-40(s0)
    80005c38:	0785                	addi	a5,a5,1
    80005c3a:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005c3e:	fd843783          	ld	a5,-40(s0)
    80005c42:	0007c783          	lbu	a5,0(a5)
    80005c46:	873e                	mv	a4,a5
    80005c48:	02f00793          	li	a5,47
    80005c4c:	fef704e3          	beq	a4,a5,80005c34 <skipelem+0x12>
  if(*path == 0)
    80005c50:	fd843783          	ld	a5,-40(s0)
    80005c54:	0007c783          	lbu	a5,0(a5)
    80005c58:	e399                	bnez	a5,80005c5e <skipelem+0x3c>
    return 0;
    80005c5a:	4781                	li	a5,0
    80005c5c:	a06d                	j	80005d06 <skipelem+0xe4>
  s = path;
    80005c5e:	fd843783          	ld	a5,-40(s0)
    80005c62:	fef43423          	sd	a5,-24(s0)
  while(*path != '/' && *path != 0)
    80005c66:	a031                	j	80005c72 <skipelem+0x50>
    path++;
    80005c68:	fd843783          	ld	a5,-40(s0)
    80005c6c:	0785                	addi	a5,a5,1
    80005c6e:	fcf43c23          	sd	a5,-40(s0)
  while(*path != '/' && *path != 0)
    80005c72:	fd843783          	ld	a5,-40(s0)
    80005c76:	0007c783          	lbu	a5,0(a5)
    80005c7a:	873e                	mv	a4,a5
    80005c7c:	02f00793          	li	a5,47
    80005c80:	00f70763          	beq	a4,a5,80005c8e <skipelem+0x6c>
    80005c84:	fd843783          	ld	a5,-40(s0)
    80005c88:	0007c783          	lbu	a5,0(a5)
    80005c8c:	fff1                	bnez	a5,80005c68 <skipelem+0x46>
  len = path - s;
    80005c8e:	fd843703          	ld	a4,-40(s0)
    80005c92:	fe843783          	ld	a5,-24(s0)
    80005c96:	40f707b3          	sub	a5,a4,a5
    80005c9a:	fef42223          	sw	a5,-28(s0)
  if(len >= DIRSIZ)
    80005c9e:	fe442783          	lw	a5,-28(s0)
    80005ca2:	0007871b          	sext.w	a4,a5
    80005ca6:	47b5                	li	a5,13
    80005ca8:	00e7dc63          	bge	a5,a4,80005cc0 <skipelem+0x9e>
    memmove(name, s, DIRSIZ);
    80005cac:	4639                	li	a2,14
    80005cae:	fe843583          	ld	a1,-24(s0)
    80005cb2:	fd043503          	ld	a0,-48(s0)
    80005cb6:	ffffc097          	auipc	ra,0xffffc
    80005cba:	880080e7          	jalr	-1920(ra) # 80001536 <memmove>
    80005cbe:	a80d                	j	80005cf0 <skipelem+0xce>
  else {
    memmove(name, s, len);
    80005cc0:	fe442783          	lw	a5,-28(s0)
    80005cc4:	863e                	mv	a2,a5
    80005cc6:	fe843583          	ld	a1,-24(s0)
    80005cca:	fd043503          	ld	a0,-48(s0)
    80005cce:	ffffc097          	auipc	ra,0xffffc
    80005cd2:	868080e7          	jalr	-1944(ra) # 80001536 <memmove>
    name[len] = 0;
    80005cd6:	fe442783          	lw	a5,-28(s0)
    80005cda:	fd043703          	ld	a4,-48(s0)
    80005cde:	97ba                	add	a5,a5,a4
    80005ce0:	00078023          	sb	zero,0(a5)
  }
  while(*path == '/')
    80005ce4:	a031                	j	80005cf0 <skipelem+0xce>
    path++;
    80005ce6:	fd843783          	ld	a5,-40(s0)
    80005cea:	0785                	addi	a5,a5,1
    80005cec:	fcf43c23          	sd	a5,-40(s0)
  while(*path == '/')
    80005cf0:	fd843783          	ld	a5,-40(s0)
    80005cf4:	0007c783          	lbu	a5,0(a5)
    80005cf8:	873e                	mv	a4,a5
    80005cfa:	02f00793          	li	a5,47
    80005cfe:	fef704e3          	beq	a4,a5,80005ce6 <skipelem+0xc4>
  return path;
    80005d02:	fd843783          	ld	a5,-40(s0)
}
    80005d06:	853e                	mv	a0,a5
    80005d08:	70a2                	ld	ra,40(sp)
    80005d0a:	7402                	ld	s0,32(sp)
    80005d0c:	6145                	addi	sp,sp,48
    80005d0e:	8082                	ret

0000000080005d10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80005d10:	7139                	addi	sp,sp,-64
    80005d12:	fc06                	sd	ra,56(sp)
    80005d14:	f822                	sd	s0,48(sp)
    80005d16:	0080                	addi	s0,sp,64
    80005d18:	fca43c23          	sd	a0,-40(s0)
    80005d1c:	87ae                	mv	a5,a1
    80005d1e:	fcc43423          	sd	a2,-56(s0)
    80005d22:	fcf42a23          	sw	a5,-44(s0)
  struct inode *ip, *next;

  if(*path == '/')
    80005d26:	fd843783          	ld	a5,-40(s0)
    80005d2a:	0007c783          	lbu	a5,0(a5)
    80005d2e:	873e                	mv	a4,a5
    80005d30:	02f00793          	li	a5,47
    80005d34:	00f71b63          	bne	a4,a5,80005d4a <namex+0x3a>
    ip = iget(ROOTDEV, ROOTINO);
    80005d38:	4585                	li	a1,1
    80005d3a:	4505                	li	a0,1
    80005d3c:	fffff097          	auipc	ra,0xfffff
    80005d40:	264080e7          	jalr	612(ra) # 80004fa0 <iget>
    80005d44:	fea43423          	sd	a0,-24(s0)
    80005d48:	a845                	j	80005df8 <namex+0xe8>
  else
    ip = idup(myproc()->cwd);
    80005d4a:	ffffd097          	auipc	ra,0xffffd
    80005d4e:	afc080e7          	jalr	-1284(ra) # 80002846 <myproc>
    80005d52:	87aa                	mv	a5,a0
    80005d54:	1507b783          	ld	a5,336(a5)
    80005d58:	853e                	mv	a0,a5
    80005d5a:	fffff097          	auipc	ra,0xfffff
    80005d5e:	362080e7          	jalr	866(ra) # 800050bc <idup>
    80005d62:	fea43423          	sd	a0,-24(s0)

  while((path = skipelem(path, name)) != 0){
    80005d66:	a849                	j	80005df8 <namex+0xe8>
    ilock(ip);
    80005d68:	fe843503          	ld	a0,-24(s0)
    80005d6c:	fffff097          	auipc	ra,0xfffff
    80005d70:	39c080e7          	jalr	924(ra) # 80005108 <ilock>
    if(ip->type != T_DIR){
    80005d74:	fe843783          	ld	a5,-24(s0)
    80005d78:	04479783          	lh	a5,68(a5)
    80005d7c:	873e                	mv	a4,a5
    80005d7e:	4785                	li	a5,1
    80005d80:	00f70a63          	beq	a4,a5,80005d94 <namex+0x84>
      iunlockput(ip);
    80005d84:	fe843503          	ld	a0,-24(s0)
    80005d88:	fffff097          	auipc	ra,0xfffff
    80005d8c:	5de080e7          	jalr	1502(ra) # 80005366 <iunlockput>
      return 0;
    80005d90:	4781                	li	a5,0
    80005d92:	a871                	j	80005e2e <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
    80005d94:	fd442783          	lw	a5,-44(s0)
    80005d98:	2781                	sext.w	a5,a5
    80005d9a:	cf99                	beqz	a5,80005db8 <namex+0xa8>
    80005d9c:	fd843783          	ld	a5,-40(s0)
    80005da0:	0007c783          	lbu	a5,0(a5)
    80005da4:	eb91                	bnez	a5,80005db8 <namex+0xa8>
      // Stop one level early.
      iunlock(ip);
    80005da6:	fe843503          	ld	a0,-24(s0)
    80005daa:	fffff097          	auipc	ra,0xfffff
    80005dae:	492080e7          	jalr	1170(ra) # 8000523c <iunlock>
      return ip;
    80005db2:	fe843783          	ld	a5,-24(s0)
    80005db6:	a8a5                	j	80005e2e <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
    80005db8:	4601                	li	a2,0
    80005dba:	fc843583          	ld	a1,-56(s0)
    80005dbe:	fe843503          	ld	a0,-24(s0)
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	c84080e7          	jalr	-892(ra) # 80005a46 <dirlookup>
    80005dca:	fea43023          	sd	a0,-32(s0)
    80005dce:	fe043783          	ld	a5,-32(s0)
    80005dd2:	eb89                	bnez	a5,80005de4 <namex+0xd4>
      iunlockput(ip);
    80005dd4:	fe843503          	ld	a0,-24(s0)
    80005dd8:	fffff097          	auipc	ra,0xfffff
    80005ddc:	58e080e7          	jalr	1422(ra) # 80005366 <iunlockput>
      return 0;
    80005de0:	4781                	li	a5,0
    80005de2:	a0b1                	j	80005e2e <namex+0x11e>
    }
    iunlockput(ip);
    80005de4:	fe843503          	ld	a0,-24(s0)
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	57e080e7          	jalr	1406(ra) # 80005366 <iunlockput>
    ip = next;
    80005df0:	fe043783          	ld	a5,-32(s0)
    80005df4:	fef43423          	sd	a5,-24(s0)
  while((path = skipelem(path, name)) != 0){
    80005df8:	fc843583          	ld	a1,-56(s0)
    80005dfc:	fd843503          	ld	a0,-40(s0)
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	e22080e7          	jalr	-478(ra) # 80005c22 <skipelem>
    80005e08:	fca43c23          	sd	a0,-40(s0)
    80005e0c:	fd843783          	ld	a5,-40(s0)
    80005e10:	ffa1                	bnez	a5,80005d68 <namex+0x58>
  }
  if(nameiparent){
    80005e12:	fd442783          	lw	a5,-44(s0)
    80005e16:	2781                	sext.w	a5,a5
    80005e18:	cb89                	beqz	a5,80005e2a <namex+0x11a>
    iput(ip);
    80005e1a:	fe843503          	ld	a0,-24(s0)
    80005e1e:	fffff097          	auipc	ra,0xfffff
    80005e22:	478080e7          	jalr	1144(ra) # 80005296 <iput>
    return 0;
    80005e26:	4781                	li	a5,0
    80005e28:	a019                	j	80005e2e <namex+0x11e>
  }
  return ip;
    80005e2a:	fe843783          	ld	a5,-24(s0)
}
    80005e2e:	853e                	mv	a0,a5
    80005e30:	70e2                	ld	ra,56(sp)
    80005e32:	7442                	ld	s0,48(sp)
    80005e34:	6121                	addi	sp,sp,64
    80005e36:	8082                	ret

0000000080005e38 <namei>:

struct inode*
namei(char *path)
{
    80005e38:	7179                	addi	sp,sp,-48
    80005e3a:	f406                	sd	ra,40(sp)
    80005e3c:	f022                	sd	s0,32(sp)
    80005e3e:	1800                	addi	s0,sp,48
    80005e40:	fca43c23          	sd	a0,-40(s0)
  char name[DIRSIZ];
  return namex(path, 0, name);
    80005e44:	fe040793          	addi	a5,s0,-32
    80005e48:	863e                	mv	a2,a5
    80005e4a:	4581                	li	a1,0
    80005e4c:	fd843503          	ld	a0,-40(s0)
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	ec0080e7          	jalr	-320(ra) # 80005d10 <namex>
    80005e58:	87aa                	mv	a5,a0
}
    80005e5a:	853e                	mv	a0,a5
    80005e5c:	70a2                	ld	ra,40(sp)
    80005e5e:	7402                	ld	s0,32(sp)
    80005e60:	6145                	addi	sp,sp,48
    80005e62:	8082                	ret

0000000080005e64 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005e64:	1101                	addi	sp,sp,-32
    80005e66:	ec06                	sd	ra,24(sp)
    80005e68:	e822                	sd	s0,16(sp)
    80005e6a:	1000                	addi	s0,sp,32
    80005e6c:	fea43423          	sd	a0,-24(s0)
    80005e70:	feb43023          	sd	a1,-32(s0)
  return namex(path, 1, name);
    80005e74:	fe043603          	ld	a2,-32(s0)
    80005e78:	4585                	li	a1,1
    80005e7a:	fe843503          	ld	a0,-24(s0)
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	e92080e7          	jalr	-366(ra) # 80005d10 <namex>
    80005e86:	87aa                	mv	a5,a0
}
    80005e88:	853e                	mv	a0,a5
    80005e8a:	60e2                	ld	ra,24(sp)
    80005e8c:	6442                	ld	s0,16(sp)
    80005e8e:	6105                	addi	sp,sp,32
    80005e90:	8082                	ret

0000000080005e92 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev, struct superblock *sb)
{
    80005e92:	1101                	addi	sp,sp,-32
    80005e94:	ec06                	sd	ra,24(sp)
    80005e96:	e822                	sd	s0,16(sp)
    80005e98:	1000                	addi	s0,sp,32
    80005e9a:	87aa                	mv	a5,a0
    80005e9c:	feb43023          	sd	a1,-32(s0)
    80005ea0:	fef42623          	sw	a5,-20(s0)
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  initlock(&log.lock, "log");
    80005ea4:	00005597          	auipc	a1,0x5
    80005ea8:	6ac58593          	addi	a1,a1,1708 # 8000b550 <etext+0x550>
    80005eac:	00020517          	auipc	a0,0x20
    80005eb0:	22c50513          	addi	a0,a0,556 # 800260d8 <log>
    80005eb4:	ffffb097          	auipc	ra,0xffffb
    80005eb8:	39a080e7          	jalr	922(ra) # 8000124e <initlock>
  log.start = sb->logstart;
    80005ebc:	fe043783          	ld	a5,-32(s0)
    80005ec0:	4bdc                	lw	a5,20(a5)
    80005ec2:	0007871b          	sext.w	a4,a5
    80005ec6:	00020797          	auipc	a5,0x20
    80005eca:	21278793          	addi	a5,a5,530 # 800260d8 <log>
    80005ece:	cf98                	sw	a4,24(a5)
  log.size = sb->nlog;
    80005ed0:	fe043783          	ld	a5,-32(s0)
    80005ed4:	4b9c                	lw	a5,16(a5)
    80005ed6:	0007871b          	sext.w	a4,a5
    80005eda:	00020797          	auipc	a5,0x20
    80005ede:	1fe78793          	addi	a5,a5,510 # 800260d8 <log>
    80005ee2:	cfd8                	sw	a4,28(a5)
  log.dev = dev;
    80005ee4:	00020797          	auipc	a5,0x20
    80005ee8:	1f478793          	addi	a5,a5,500 # 800260d8 <log>
    80005eec:	fec42703          	lw	a4,-20(s0)
    80005ef0:	d798                	sw	a4,40(a5)
  recover_from_log();
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	272080e7          	jalr	626(ra) # 80006164 <recover_from_log>
}
    80005efa:	0001                	nop
    80005efc:	60e2                	ld	ra,24(sp)
    80005efe:	6442                	ld	s0,16(sp)
    80005f00:	6105                	addi	sp,sp,32
    80005f02:	8082                	ret

0000000080005f04 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
    80005f04:	7139                	addi	sp,sp,-64
    80005f06:	fc06                	sd	ra,56(sp)
    80005f08:	f822                	sd	s0,48(sp)
    80005f0a:	0080                	addi	s0,sp,64
    80005f0c:	87aa                	mv	a5,a0
    80005f0e:	fcf42623          	sw	a5,-52(s0)
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    80005f12:	fe042623          	sw	zero,-20(s0)
    80005f16:	a0f9                	j	80005fe4 <install_trans+0xe0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80005f18:	00020797          	auipc	a5,0x20
    80005f1c:	1c078793          	addi	a5,a5,448 # 800260d8 <log>
    80005f20:	579c                	lw	a5,40(a5)
    80005f22:	0007871b          	sext.w	a4,a5
    80005f26:	00020797          	auipc	a5,0x20
    80005f2a:	1b278793          	addi	a5,a5,434 # 800260d8 <log>
    80005f2e:	4f9c                	lw	a5,24(a5)
    80005f30:	fec42683          	lw	a3,-20(s0)
    80005f34:	9fb5                	addw	a5,a5,a3
    80005f36:	2781                	sext.w	a5,a5
    80005f38:	2785                	addiw	a5,a5,1
    80005f3a:	2781                	sext.w	a5,a5
    80005f3c:	2781                	sext.w	a5,a5
    80005f3e:	85be                	mv	a1,a5
    80005f40:	853a                	mv	a0,a4
    80005f42:	ffffe097          	auipc	ra,0xffffe
    80005f46:	7f2080e7          	jalr	2034(ra) # 80004734 <bread>
    80005f4a:	fea43023          	sd	a0,-32(s0)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80005f4e:	00020797          	auipc	a5,0x20
    80005f52:	18a78793          	addi	a5,a5,394 # 800260d8 <log>
    80005f56:	579c                	lw	a5,40(a5)
    80005f58:	0007869b          	sext.w	a3,a5
    80005f5c:	00020717          	auipc	a4,0x20
    80005f60:	17c70713          	addi	a4,a4,380 # 800260d8 <log>
    80005f64:	fec42783          	lw	a5,-20(s0)
    80005f68:	07a1                	addi	a5,a5,8
    80005f6a:	078a                	slli	a5,a5,0x2
    80005f6c:	97ba                	add	a5,a5,a4
    80005f6e:	4b9c                	lw	a5,16(a5)
    80005f70:	2781                	sext.w	a5,a5
    80005f72:	85be                	mv	a1,a5
    80005f74:	8536                	mv	a0,a3
    80005f76:	ffffe097          	auipc	ra,0xffffe
    80005f7a:	7be080e7          	jalr	1982(ra) # 80004734 <bread>
    80005f7e:	fca43c23          	sd	a0,-40(s0)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80005f82:	fd843783          	ld	a5,-40(s0)
    80005f86:	05878713          	addi	a4,a5,88
    80005f8a:	fe043783          	ld	a5,-32(s0)
    80005f8e:	05878793          	addi	a5,a5,88
    80005f92:	40000613          	li	a2,1024
    80005f96:	85be                	mv	a1,a5
    80005f98:	853a                	mv	a0,a4
    80005f9a:	ffffb097          	auipc	ra,0xffffb
    80005f9e:	59c080e7          	jalr	1436(ra) # 80001536 <memmove>
    bwrite(dbuf);  // write dst to disk
    80005fa2:	fd843503          	ld	a0,-40(s0)
    80005fa6:	ffffe097          	auipc	ra,0xffffe
    80005faa:	7e8080e7          	jalr	2024(ra) # 8000478e <bwrite>
    if(recovering == 0)
    80005fae:	fcc42783          	lw	a5,-52(s0)
    80005fb2:	2781                	sext.w	a5,a5
    80005fb4:	e799                	bnez	a5,80005fc2 <install_trans+0xbe>
      bunpin(dbuf);
    80005fb6:	fd843503          	ld	a0,-40(s0)
    80005fba:	fffff097          	auipc	ra,0xfffff
    80005fbe:	952080e7          	jalr	-1710(ra) # 8000490c <bunpin>
    brelse(lbuf);
    80005fc2:	fe043503          	ld	a0,-32(s0)
    80005fc6:	fffff097          	auipc	ra,0xfffff
    80005fca:	810080e7          	jalr	-2032(ra) # 800047d6 <brelse>
    brelse(dbuf);
    80005fce:	fd843503          	ld	a0,-40(s0)
    80005fd2:	fffff097          	auipc	ra,0xfffff
    80005fd6:	804080e7          	jalr	-2044(ra) # 800047d6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80005fda:	fec42783          	lw	a5,-20(s0)
    80005fde:	2785                	addiw	a5,a5,1
    80005fe0:	fef42623          	sw	a5,-20(s0)
    80005fe4:	00020797          	auipc	a5,0x20
    80005fe8:	0f478793          	addi	a5,a5,244 # 800260d8 <log>
    80005fec:	57d8                	lw	a4,44(a5)
    80005fee:	fec42783          	lw	a5,-20(s0)
    80005ff2:	2781                	sext.w	a5,a5
    80005ff4:	f2e7c2e3          	blt	a5,a4,80005f18 <install_trans+0x14>
  }
}
    80005ff8:	0001                	nop
    80005ffa:	0001                	nop
    80005ffc:	70e2                	ld	ra,56(sp)
    80005ffe:	7442                	ld	s0,48(sp)
    80006000:	6121                	addi	sp,sp,64
    80006002:	8082                	ret

0000000080006004 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
    80006004:	7179                	addi	sp,sp,-48
    80006006:	f406                	sd	ra,40(sp)
    80006008:	f022                	sd	s0,32(sp)
    8000600a:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    8000600c:	00020797          	auipc	a5,0x20
    80006010:	0cc78793          	addi	a5,a5,204 # 800260d8 <log>
    80006014:	579c                	lw	a5,40(a5)
    80006016:	0007871b          	sext.w	a4,a5
    8000601a:	00020797          	auipc	a5,0x20
    8000601e:	0be78793          	addi	a5,a5,190 # 800260d8 <log>
    80006022:	4f9c                	lw	a5,24(a5)
    80006024:	2781                	sext.w	a5,a5
    80006026:	85be                	mv	a1,a5
    80006028:	853a                	mv	a0,a4
    8000602a:	ffffe097          	auipc	ra,0xffffe
    8000602e:	70a080e7          	jalr	1802(ra) # 80004734 <bread>
    80006032:	fea43023          	sd	a0,-32(s0)
  struct logheader *lh = (struct logheader *) (buf->data);
    80006036:	fe043783          	ld	a5,-32(s0)
    8000603a:	05878793          	addi	a5,a5,88
    8000603e:	fcf43c23          	sd	a5,-40(s0)
  int i;
  log.lh.n = lh->n;
    80006042:	fd843783          	ld	a5,-40(s0)
    80006046:	4398                	lw	a4,0(a5)
    80006048:	00020797          	auipc	a5,0x20
    8000604c:	09078793          	addi	a5,a5,144 # 800260d8 <log>
    80006050:	d7d8                	sw	a4,44(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006052:	fe042623          	sw	zero,-20(s0)
    80006056:	a03d                	j	80006084 <read_head+0x80>
    log.lh.block[i] = lh->block[i];
    80006058:	fd843703          	ld	a4,-40(s0)
    8000605c:	fec42783          	lw	a5,-20(s0)
    80006060:	078a                	slli	a5,a5,0x2
    80006062:	97ba                	add	a5,a5,a4
    80006064:	43d8                	lw	a4,4(a5)
    80006066:	00020697          	auipc	a3,0x20
    8000606a:	07268693          	addi	a3,a3,114 # 800260d8 <log>
    8000606e:	fec42783          	lw	a5,-20(s0)
    80006072:	07a1                	addi	a5,a5,8
    80006074:	078a                	slli	a5,a5,0x2
    80006076:	97b6                	add	a5,a5,a3
    80006078:	cb98                	sw	a4,16(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000607a:	fec42783          	lw	a5,-20(s0)
    8000607e:	2785                	addiw	a5,a5,1
    80006080:	fef42623          	sw	a5,-20(s0)
    80006084:	00020797          	auipc	a5,0x20
    80006088:	05478793          	addi	a5,a5,84 # 800260d8 <log>
    8000608c:	57d8                	lw	a4,44(a5)
    8000608e:	fec42783          	lw	a5,-20(s0)
    80006092:	2781                	sext.w	a5,a5
    80006094:	fce7c2e3          	blt	a5,a4,80006058 <read_head+0x54>
  }
  brelse(buf);
    80006098:	fe043503          	ld	a0,-32(s0)
    8000609c:	ffffe097          	auipc	ra,0xffffe
    800060a0:	73a080e7          	jalr	1850(ra) # 800047d6 <brelse>
}
    800060a4:	0001                	nop
    800060a6:	70a2                	ld	ra,40(sp)
    800060a8:	7402                	ld	s0,32(sp)
    800060aa:	6145                	addi	sp,sp,48
    800060ac:	8082                	ret

00000000800060ae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800060ae:	7179                	addi	sp,sp,-48
    800060b0:	f406                	sd	ra,40(sp)
    800060b2:	f022                	sd	s0,32(sp)
    800060b4:	1800                	addi	s0,sp,48
  struct buf *buf = bread(log.dev, log.start);
    800060b6:	00020797          	auipc	a5,0x20
    800060ba:	02278793          	addi	a5,a5,34 # 800260d8 <log>
    800060be:	579c                	lw	a5,40(a5)
    800060c0:	0007871b          	sext.w	a4,a5
    800060c4:	00020797          	auipc	a5,0x20
    800060c8:	01478793          	addi	a5,a5,20 # 800260d8 <log>
    800060cc:	4f9c                	lw	a5,24(a5)
    800060ce:	2781                	sext.w	a5,a5
    800060d0:	85be                	mv	a1,a5
    800060d2:	853a                	mv	a0,a4
    800060d4:	ffffe097          	auipc	ra,0xffffe
    800060d8:	660080e7          	jalr	1632(ra) # 80004734 <bread>
    800060dc:	fea43023          	sd	a0,-32(s0)
  struct logheader *hb = (struct logheader *) (buf->data);
    800060e0:	fe043783          	ld	a5,-32(s0)
    800060e4:	05878793          	addi	a5,a5,88
    800060e8:	fcf43c23          	sd	a5,-40(s0)
  int i;
  hb->n = log.lh.n;
    800060ec:	00020797          	auipc	a5,0x20
    800060f0:	fec78793          	addi	a5,a5,-20 # 800260d8 <log>
    800060f4:	57d8                	lw	a4,44(a5)
    800060f6:	fd843783          	ld	a5,-40(s0)
    800060fa:	c398                	sw	a4,0(a5)
  for (i = 0; i < log.lh.n; i++) {
    800060fc:	fe042623          	sw	zero,-20(s0)
    80006100:	a03d                	j	8000612e <write_head+0x80>
    hb->block[i] = log.lh.block[i];
    80006102:	00020717          	auipc	a4,0x20
    80006106:	fd670713          	addi	a4,a4,-42 # 800260d8 <log>
    8000610a:	fec42783          	lw	a5,-20(s0)
    8000610e:	07a1                	addi	a5,a5,8
    80006110:	078a                	slli	a5,a5,0x2
    80006112:	97ba                	add	a5,a5,a4
    80006114:	4b98                	lw	a4,16(a5)
    80006116:	fd843683          	ld	a3,-40(s0)
    8000611a:	fec42783          	lw	a5,-20(s0)
    8000611e:	078a                	slli	a5,a5,0x2
    80006120:	97b6                	add	a5,a5,a3
    80006122:	c3d8                	sw	a4,4(a5)
  for (i = 0; i < log.lh.n; i++) {
    80006124:	fec42783          	lw	a5,-20(s0)
    80006128:	2785                	addiw	a5,a5,1
    8000612a:	fef42623          	sw	a5,-20(s0)
    8000612e:	00020797          	auipc	a5,0x20
    80006132:	faa78793          	addi	a5,a5,-86 # 800260d8 <log>
    80006136:	57d8                	lw	a4,44(a5)
    80006138:	fec42783          	lw	a5,-20(s0)
    8000613c:	2781                	sext.w	a5,a5
    8000613e:	fce7c2e3          	blt	a5,a4,80006102 <write_head+0x54>
  }
  bwrite(buf);
    80006142:	fe043503          	ld	a0,-32(s0)
    80006146:	ffffe097          	auipc	ra,0xffffe
    8000614a:	648080e7          	jalr	1608(ra) # 8000478e <bwrite>
  brelse(buf);
    8000614e:	fe043503          	ld	a0,-32(s0)
    80006152:	ffffe097          	auipc	ra,0xffffe
    80006156:	684080e7          	jalr	1668(ra) # 800047d6 <brelse>
}
    8000615a:	0001                	nop
    8000615c:	70a2                	ld	ra,40(sp)
    8000615e:	7402                	ld	s0,32(sp)
    80006160:	6145                	addi	sp,sp,48
    80006162:	8082                	ret

0000000080006164 <recover_from_log>:

static void
recover_from_log(void)
{
    80006164:	1141                	addi	sp,sp,-16
    80006166:	e406                	sd	ra,8(sp)
    80006168:	e022                	sd	s0,0(sp)
    8000616a:	0800                	addi	s0,sp,16
  read_head();
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	e98080e7          	jalr	-360(ra) # 80006004 <read_head>
  install_trans(1); // if committed, copy from log to disk
    80006174:	4505                	li	a0,1
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	d8e080e7          	jalr	-626(ra) # 80005f04 <install_trans>
  log.lh.n = 0;
    8000617e:	00020797          	auipc	a5,0x20
    80006182:	f5a78793          	addi	a5,a5,-166 # 800260d8 <log>
    80006186:	0207a623          	sw	zero,44(a5)
  write_head(); // clear the log
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	f24080e7          	jalr	-220(ra) # 800060ae <write_head>
}
    80006192:	0001                	nop
    80006194:	60a2                	ld	ra,8(sp)
    80006196:	6402                	ld	s0,0(sp)
    80006198:	0141                	addi	sp,sp,16
    8000619a:	8082                	ret

000000008000619c <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
    8000619c:	1141                	addi	sp,sp,-16
    8000619e:	e406                	sd	ra,8(sp)
    800061a0:	e022                	sd	s0,0(sp)
    800061a2:	0800                	addi	s0,sp,16
  acquire(&log.lock);
    800061a4:	00020517          	auipc	a0,0x20
    800061a8:	f3450513          	addi	a0,a0,-204 # 800260d8 <log>
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	0d2080e7          	jalr	210(ra) # 8000127e <acquire>
  while(1){
    if(log.committing){
    800061b4:	00020797          	auipc	a5,0x20
    800061b8:	f2478793          	addi	a5,a5,-220 # 800260d8 <log>
    800061bc:	53dc                	lw	a5,36(a5)
    800061be:	cf91                	beqz	a5,800061da <begin_op+0x3e>
      sleep(&log, &log.lock);
    800061c0:	00020597          	auipc	a1,0x20
    800061c4:	f1858593          	addi	a1,a1,-232 # 800260d8 <log>
    800061c8:	00020517          	auipc	a0,0x20
    800061cc:	f1050513          	addi	a0,a0,-240 # 800260d8 <log>
    800061d0:	ffffd097          	auipc	ra,0xffffd
    800061d4:	238080e7          	jalr	568(ra) # 80003408 <sleep>
    800061d8:	bff1                	j	800061b4 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800061da:	00020797          	auipc	a5,0x20
    800061de:	efe78793          	addi	a5,a5,-258 # 800260d8 <log>
    800061e2:	57d8                	lw	a4,44(a5)
    800061e4:	00020797          	auipc	a5,0x20
    800061e8:	ef478793          	addi	a5,a5,-268 # 800260d8 <log>
    800061ec:	539c                	lw	a5,32(a5)
    800061ee:	2785                	addiw	a5,a5,1
    800061f0:	2781                	sext.w	a5,a5
    800061f2:	86be                	mv	a3,a5
    800061f4:	87b6                	mv	a5,a3
    800061f6:	0027979b          	slliw	a5,a5,0x2
    800061fa:	9fb5                	addw	a5,a5,a3
    800061fc:	0017979b          	slliw	a5,a5,0x1
    80006200:	2781                	sext.w	a5,a5
    80006202:	9fb9                	addw	a5,a5,a4
    80006204:	2781                	sext.w	a5,a5
    80006206:	873e                	mv	a4,a5
    80006208:	47f9                	li	a5,30
    8000620a:	00e7df63          	bge	a5,a4,80006228 <begin_op+0x8c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000620e:	00020597          	auipc	a1,0x20
    80006212:	eca58593          	addi	a1,a1,-310 # 800260d8 <log>
    80006216:	00020517          	auipc	a0,0x20
    8000621a:	ec250513          	addi	a0,a0,-318 # 800260d8 <log>
    8000621e:	ffffd097          	auipc	ra,0xffffd
    80006222:	1ea080e7          	jalr	490(ra) # 80003408 <sleep>
    80006226:	b779                	j	800061b4 <begin_op+0x18>
    } else {
      log.outstanding += 1;
    80006228:	00020797          	auipc	a5,0x20
    8000622c:	eb078793          	addi	a5,a5,-336 # 800260d8 <log>
    80006230:	539c                	lw	a5,32(a5)
    80006232:	2785                	addiw	a5,a5,1
    80006234:	0007871b          	sext.w	a4,a5
    80006238:	00020797          	auipc	a5,0x20
    8000623c:	ea078793          	addi	a5,a5,-352 # 800260d8 <log>
    80006240:	d398                	sw	a4,32(a5)
      release(&log.lock);
    80006242:	00020517          	auipc	a0,0x20
    80006246:	e9650513          	addi	a0,a0,-362 # 800260d8 <log>
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	098080e7          	jalr	152(ra) # 800012e2 <release>
      break;
    80006252:	0001                	nop
    }
  }
}
    80006254:	0001                	nop
    80006256:	60a2                	ld	ra,8(sp)
    80006258:	6402                	ld	s0,0(sp)
    8000625a:	0141                	addi	sp,sp,16
    8000625c:	8082                	ret

000000008000625e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000625e:	1101                	addi	sp,sp,-32
    80006260:	ec06                	sd	ra,24(sp)
    80006262:	e822                	sd	s0,16(sp)
    80006264:	1000                	addi	s0,sp,32
  int do_commit = 0;
    80006266:	fe042623          	sw	zero,-20(s0)

  acquire(&log.lock);
    8000626a:	00020517          	auipc	a0,0x20
    8000626e:	e6e50513          	addi	a0,a0,-402 # 800260d8 <log>
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	00c080e7          	jalr	12(ra) # 8000127e <acquire>
  log.outstanding -= 1;
    8000627a:	00020797          	auipc	a5,0x20
    8000627e:	e5e78793          	addi	a5,a5,-418 # 800260d8 <log>
    80006282:	539c                	lw	a5,32(a5)
    80006284:	37fd                	addiw	a5,a5,-1
    80006286:	0007871b          	sext.w	a4,a5
    8000628a:	00020797          	auipc	a5,0x20
    8000628e:	e4e78793          	addi	a5,a5,-434 # 800260d8 <log>
    80006292:	d398                	sw	a4,32(a5)
  if(log.committing)
    80006294:	00020797          	auipc	a5,0x20
    80006298:	e4478793          	addi	a5,a5,-444 # 800260d8 <log>
    8000629c:	53dc                	lw	a5,36(a5)
    8000629e:	cb89                	beqz	a5,800062b0 <end_op+0x52>
    panic("log.committing");
    800062a0:	00005517          	auipc	a0,0x5
    800062a4:	2b850513          	addi	a0,a0,696 # 8000b558 <etext+0x558>
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	9e2080e7          	jalr	-1566(ra) # 80000c8a <panic>
  if(log.outstanding == 0){
    800062b0:	00020797          	auipc	a5,0x20
    800062b4:	e2878793          	addi	a5,a5,-472 # 800260d8 <log>
    800062b8:	539c                	lw	a5,32(a5)
    800062ba:	eb99                	bnez	a5,800062d0 <end_op+0x72>
    do_commit = 1;
    800062bc:	4785                	li	a5,1
    800062be:	fef42623          	sw	a5,-20(s0)
    log.committing = 1;
    800062c2:	00020797          	auipc	a5,0x20
    800062c6:	e1678793          	addi	a5,a5,-490 # 800260d8 <log>
    800062ca:	4705                	li	a4,1
    800062cc:	d3d8                	sw	a4,36(a5)
    800062ce:	a809                	j	800062e0 <end_op+0x82>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
    800062d0:	00020517          	auipc	a0,0x20
    800062d4:	e0850513          	addi	a0,a0,-504 # 800260d8 <log>
    800062d8:	ffffd097          	auipc	ra,0xffffd
    800062dc:	1ac080e7          	jalr	428(ra) # 80003484 <wakeup>
  }
  release(&log.lock);
    800062e0:	00020517          	auipc	a0,0x20
    800062e4:	df850513          	addi	a0,a0,-520 # 800260d8 <log>
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	ffa080e7          	jalr	-6(ra) # 800012e2 <release>

  if(do_commit){
    800062f0:	fec42783          	lw	a5,-20(s0)
    800062f4:	2781                	sext.w	a5,a5
    800062f6:	c3b9                	beqz	a5,8000633c <end_op+0xde>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	134080e7          	jalr	308(ra) # 8000642c <commit>
    acquire(&log.lock);
    80006300:	00020517          	auipc	a0,0x20
    80006304:	dd850513          	addi	a0,a0,-552 # 800260d8 <log>
    80006308:	ffffb097          	auipc	ra,0xffffb
    8000630c:	f76080e7          	jalr	-138(ra) # 8000127e <acquire>
    log.committing = 0;
    80006310:	00020797          	auipc	a5,0x20
    80006314:	dc878793          	addi	a5,a5,-568 # 800260d8 <log>
    80006318:	0207a223          	sw	zero,36(a5)
    wakeup(&log);
    8000631c:	00020517          	auipc	a0,0x20
    80006320:	dbc50513          	addi	a0,a0,-580 # 800260d8 <log>
    80006324:	ffffd097          	auipc	ra,0xffffd
    80006328:	160080e7          	jalr	352(ra) # 80003484 <wakeup>
    release(&log.lock);
    8000632c:	00020517          	auipc	a0,0x20
    80006330:	dac50513          	addi	a0,a0,-596 # 800260d8 <log>
    80006334:	ffffb097          	auipc	ra,0xffffb
    80006338:	fae080e7          	jalr	-82(ra) # 800012e2 <release>
  }
}
    8000633c:	0001                	nop
    8000633e:	60e2                	ld	ra,24(sp)
    80006340:	6442                	ld	s0,16(sp)
    80006342:	6105                	addi	sp,sp,32
    80006344:	8082                	ret

0000000080006346 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
    80006346:	7179                	addi	sp,sp,-48
    80006348:	f406                	sd	ra,40(sp)
    8000634a:	f022                	sd	s0,32(sp)
    8000634c:	1800                	addi	s0,sp,48
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    8000634e:	fe042623          	sw	zero,-20(s0)
    80006352:	a86d                	j	8000640c <write_log+0xc6>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80006354:	00020797          	auipc	a5,0x20
    80006358:	d8478793          	addi	a5,a5,-636 # 800260d8 <log>
    8000635c:	579c                	lw	a5,40(a5)
    8000635e:	0007871b          	sext.w	a4,a5
    80006362:	00020797          	auipc	a5,0x20
    80006366:	d7678793          	addi	a5,a5,-650 # 800260d8 <log>
    8000636a:	4f9c                	lw	a5,24(a5)
    8000636c:	fec42683          	lw	a3,-20(s0)
    80006370:	9fb5                	addw	a5,a5,a3
    80006372:	2781                	sext.w	a5,a5
    80006374:	2785                	addiw	a5,a5,1
    80006376:	2781                	sext.w	a5,a5
    80006378:	2781                	sext.w	a5,a5
    8000637a:	85be                	mv	a1,a5
    8000637c:	853a                	mv	a0,a4
    8000637e:	ffffe097          	auipc	ra,0xffffe
    80006382:	3b6080e7          	jalr	950(ra) # 80004734 <bread>
    80006386:	fea43023          	sd	a0,-32(s0)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000638a:	00020797          	auipc	a5,0x20
    8000638e:	d4e78793          	addi	a5,a5,-690 # 800260d8 <log>
    80006392:	579c                	lw	a5,40(a5)
    80006394:	0007869b          	sext.w	a3,a5
    80006398:	00020717          	auipc	a4,0x20
    8000639c:	d4070713          	addi	a4,a4,-704 # 800260d8 <log>
    800063a0:	fec42783          	lw	a5,-20(s0)
    800063a4:	07a1                	addi	a5,a5,8
    800063a6:	078a                	slli	a5,a5,0x2
    800063a8:	97ba                	add	a5,a5,a4
    800063aa:	4b9c                	lw	a5,16(a5)
    800063ac:	2781                	sext.w	a5,a5
    800063ae:	85be                	mv	a1,a5
    800063b0:	8536                	mv	a0,a3
    800063b2:	ffffe097          	auipc	ra,0xffffe
    800063b6:	382080e7          	jalr	898(ra) # 80004734 <bread>
    800063ba:	fca43c23          	sd	a0,-40(s0)
    memmove(to->data, from->data, BSIZE);
    800063be:	fe043783          	ld	a5,-32(s0)
    800063c2:	05878713          	addi	a4,a5,88
    800063c6:	fd843783          	ld	a5,-40(s0)
    800063ca:	05878793          	addi	a5,a5,88
    800063ce:	40000613          	li	a2,1024
    800063d2:	85be                	mv	a1,a5
    800063d4:	853a                	mv	a0,a4
    800063d6:	ffffb097          	auipc	ra,0xffffb
    800063da:	160080e7          	jalr	352(ra) # 80001536 <memmove>
    bwrite(to);  // write the log
    800063de:	fe043503          	ld	a0,-32(s0)
    800063e2:	ffffe097          	auipc	ra,0xffffe
    800063e6:	3ac080e7          	jalr	940(ra) # 8000478e <bwrite>
    brelse(from);
    800063ea:	fd843503          	ld	a0,-40(s0)
    800063ee:	ffffe097          	auipc	ra,0xffffe
    800063f2:	3e8080e7          	jalr	1000(ra) # 800047d6 <brelse>
    brelse(to);
    800063f6:	fe043503          	ld	a0,-32(s0)
    800063fa:	ffffe097          	auipc	ra,0xffffe
    800063fe:	3dc080e7          	jalr	988(ra) # 800047d6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80006402:	fec42783          	lw	a5,-20(s0)
    80006406:	2785                	addiw	a5,a5,1
    80006408:	fef42623          	sw	a5,-20(s0)
    8000640c:	00020797          	auipc	a5,0x20
    80006410:	ccc78793          	addi	a5,a5,-820 # 800260d8 <log>
    80006414:	57d8                	lw	a4,44(a5)
    80006416:	fec42783          	lw	a5,-20(s0)
    8000641a:	2781                	sext.w	a5,a5
    8000641c:	f2e7cce3          	blt	a5,a4,80006354 <write_log+0xe>
  }
}
    80006420:	0001                	nop
    80006422:	0001                	nop
    80006424:	70a2                	ld	ra,40(sp)
    80006426:	7402                	ld	s0,32(sp)
    80006428:	6145                	addi	sp,sp,48
    8000642a:	8082                	ret

000000008000642c <commit>:

static void
commit()
{
    8000642c:	1141                	addi	sp,sp,-16
    8000642e:	e406                	sd	ra,8(sp)
    80006430:	e022                	sd	s0,0(sp)
    80006432:	0800                	addi	s0,sp,16
  if (log.lh.n > 0) {
    80006434:	00020797          	auipc	a5,0x20
    80006438:	ca478793          	addi	a5,a5,-860 # 800260d8 <log>
    8000643c:	57dc                	lw	a5,44(a5)
    8000643e:	02f05963          	blez	a5,80006470 <commit+0x44>
    write_log();     // Write modified blocks from cache to log
    80006442:	00000097          	auipc	ra,0x0
    80006446:	f04080e7          	jalr	-252(ra) # 80006346 <write_log>
    write_head();    // Write header to disk -- the real commit
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	c64080e7          	jalr	-924(ra) # 800060ae <write_head>
    install_trans(0); // Now install writes to home locations
    80006452:	4501                	li	a0,0
    80006454:	00000097          	auipc	ra,0x0
    80006458:	ab0080e7          	jalr	-1360(ra) # 80005f04 <install_trans>
    log.lh.n = 0;
    8000645c:	00020797          	auipc	a5,0x20
    80006460:	c7c78793          	addi	a5,a5,-900 # 800260d8 <log>
    80006464:	0207a623          	sw	zero,44(a5)
    write_head();    // Erase the transaction from the log
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	c46080e7          	jalr	-954(ra) # 800060ae <write_head>
  }
}
    80006470:	0001                	nop
    80006472:	60a2                	ld	ra,8(sp)
    80006474:	6402                	ld	s0,0(sp)
    80006476:	0141                	addi	sp,sp,16
    80006478:	8082                	ret

000000008000647a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000647a:	7179                	addi	sp,sp,-48
    8000647c:	f406                	sd	ra,40(sp)
    8000647e:	f022                	sd	s0,32(sp)
    80006480:	1800                	addi	s0,sp,48
    80006482:	fca43c23          	sd	a0,-40(s0)
  int i;

  acquire(&log.lock);
    80006486:	00020517          	auipc	a0,0x20
    8000648a:	c5250513          	addi	a0,a0,-942 # 800260d8 <log>
    8000648e:	ffffb097          	auipc	ra,0xffffb
    80006492:	df0080e7          	jalr	-528(ra) # 8000127e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80006496:	00020797          	auipc	a5,0x20
    8000649a:	c4278793          	addi	a5,a5,-958 # 800260d8 <log>
    8000649e:	57dc                	lw	a5,44(a5)
    800064a0:	873e                	mv	a4,a5
    800064a2:	47f5                	li	a5,29
    800064a4:	02e7c063          	blt	a5,a4,800064c4 <log_write+0x4a>
    800064a8:	00020797          	auipc	a5,0x20
    800064ac:	c3078793          	addi	a5,a5,-976 # 800260d8 <log>
    800064b0:	57d8                	lw	a4,44(a5)
    800064b2:	00020797          	auipc	a5,0x20
    800064b6:	c2678793          	addi	a5,a5,-986 # 800260d8 <log>
    800064ba:	4fdc                	lw	a5,28(a5)
    800064bc:	37fd                	addiw	a5,a5,-1
    800064be:	2781                	sext.w	a5,a5
    800064c0:	00f74a63          	blt	a4,a5,800064d4 <log_write+0x5a>
    panic("too big a transaction");
    800064c4:	00005517          	auipc	a0,0x5
    800064c8:	0a450513          	addi	a0,a0,164 # 8000b568 <etext+0x568>
    800064cc:	ffffa097          	auipc	ra,0xffffa
    800064d0:	7be080e7          	jalr	1982(ra) # 80000c8a <panic>
  if (log.outstanding < 1)
    800064d4:	00020797          	auipc	a5,0x20
    800064d8:	c0478793          	addi	a5,a5,-1020 # 800260d8 <log>
    800064dc:	539c                	lw	a5,32(a5)
    800064de:	00f04a63          	bgtz	a5,800064f2 <log_write+0x78>
    panic("log_write outside of trans");
    800064e2:	00005517          	auipc	a0,0x5
    800064e6:	09e50513          	addi	a0,a0,158 # 8000b580 <etext+0x580>
    800064ea:	ffffa097          	auipc	ra,0xffffa
    800064ee:	7a0080e7          	jalr	1952(ra) # 80000c8a <panic>

  for (i = 0; i < log.lh.n; i++) {
    800064f2:	fe042623          	sw	zero,-20(s0)
    800064f6:	a03d                	j	80006524 <log_write+0xaa>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800064f8:	00020717          	auipc	a4,0x20
    800064fc:	be070713          	addi	a4,a4,-1056 # 800260d8 <log>
    80006500:	fec42783          	lw	a5,-20(s0)
    80006504:	07a1                	addi	a5,a5,8
    80006506:	078a                	slli	a5,a5,0x2
    80006508:	97ba                	add	a5,a5,a4
    8000650a:	4b9c                	lw	a5,16(a5)
    8000650c:	0007871b          	sext.w	a4,a5
    80006510:	fd843783          	ld	a5,-40(s0)
    80006514:	47dc                	lw	a5,12(a5)
    80006516:	02f70263          	beq	a4,a5,8000653a <log_write+0xc0>
  for (i = 0; i < log.lh.n; i++) {
    8000651a:	fec42783          	lw	a5,-20(s0)
    8000651e:	2785                	addiw	a5,a5,1
    80006520:	fef42623          	sw	a5,-20(s0)
    80006524:	00020797          	auipc	a5,0x20
    80006528:	bb478793          	addi	a5,a5,-1100 # 800260d8 <log>
    8000652c:	57d8                	lw	a4,44(a5)
    8000652e:	fec42783          	lw	a5,-20(s0)
    80006532:	2781                	sext.w	a5,a5
    80006534:	fce7c2e3          	blt	a5,a4,800064f8 <log_write+0x7e>
    80006538:	a011                	j	8000653c <log_write+0xc2>
      break;
    8000653a:	0001                	nop
  }
  log.lh.block[i] = b->blockno;
    8000653c:	fd843783          	ld	a5,-40(s0)
    80006540:	47dc                	lw	a5,12(a5)
    80006542:	0007871b          	sext.w	a4,a5
    80006546:	00020697          	auipc	a3,0x20
    8000654a:	b9268693          	addi	a3,a3,-1134 # 800260d8 <log>
    8000654e:	fec42783          	lw	a5,-20(s0)
    80006552:	07a1                	addi	a5,a5,8
    80006554:	078a                	slli	a5,a5,0x2
    80006556:	97b6                	add	a5,a5,a3
    80006558:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    8000655a:	00020797          	auipc	a5,0x20
    8000655e:	b7e78793          	addi	a5,a5,-1154 # 800260d8 <log>
    80006562:	57d8                	lw	a4,44(a5)
    80006564:	fec42783          	lw	a5,-20(s0)
    80006568:	2781                	sext.w	a5,a5
    8000656a:	02e79563          	bne	a5,a4,80006594 <log_write+0x11a>
    bpin(b);
    8000656e:	fd843503          	ld	a0,-40(s0)
    80006572:	ffffe097          	auipc	ra,0xffffe
    80006576:	352080e7          	jalr	850(ra) # 800048c4 <bpin>
    log.lh.n++;
    8000657a:	00020797          	auipc	a5,0x20
    8000657e:	b5e78793          	addi	a5,a5,-1186 # 800260d8 <log>
    80006582:	57dc                	lw	a5,44(a5)
    80006584:	2785                	addiw	a5,a5,1
    80006586:	0007871b          	sext.w	a4,a5
    8000658a:	00020797          	auipc	a5,0x20
    8000658e:	b4e78793          	addi	a5,a5,-1202 # 800260d8 <log>
    80006592:	d7d8                	sw	a4,44(a5)
  }
  release(&log.lock);
    80006594:	00020517          	auipc	a0,0x20
    80006598:	b4450513          	addi	a0,a0,-1212 # 800260d8 <log>
    8000659c:	ffffb097          	auipc	ra,0xffffb
    800065a0:	d46080e7          	jalr	-698(ra) # 800012e2 <release>
}
    800065a4:	0001                	nop
    800065a6:	70a2                	ld	ra,40(sp)
    800065a8:	7402                	ld	s0,32(sp)
    800065aa:	6145                	addi	sp,sp,48
    800065ac:	8082                	ret

00000000800065ae <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800065ae:	1101                	addi	sp,sp,-32
    800065b0:	ec06                	sd	ra,24(sp)
    800065b2:	e822                	sd	s0,16(sp)
    800065b4:	1000                	addi	s0,sp,32
    800065b6:	fea43423          	sd	a0,-24(s0)
    800065ba:	feb43023          	sd	a1,-32(s0)
  initlock(&lk->lk, "sleep lock");
    800065be:	fe843783          	ld	a5,-24(s0)
    800065c2:	07a1                	addi	a5,a5,8
    800065c4:	00005597          	auipc	a1,0x5
    800065c8:	fdc58593          	addi	a1,a1,-36 # 8000b5a0 <etext+0x5a0>
    800065cc:	853e                	mv	a0,a5
    800065ce:	ffffb097          	auipc	ra,0xffffb
    800065d2:	c80080e7          	jalr	-896(ra) # 8000124e <initlock>
  lk->name = name;
    800065d6:	fe843783          	ld	a5,-24(s0)
    800065da:	fe043703          	ld	a4,-32(s0)
    800065de:	f398                	sd	a4,32(a5)
  lk->locked = 0;
    800065e0:	fe843783          	ld	a5,-24(s0)
    800065e4:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    800065e8:	fe843783          	ld	a5,-24(s0)
    800065ec:	0207a423          	sw	zero,40(a5)
}
    800065f0:	0001                	nop
    800065f2:	60e2                	ld	ra,24(sp)
    800065f4:	6442                	ld	s0,16(sp)
    800065f6:	6105                	addi	sp,sp,32
    800065f8:	8082                	ret

00000000800065fa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800065fa:	1101                	addi	sp,sp,-32
    800065fc:	ec06                	sd	ra,24(sp)
    800065fe:	e822                	sd	s0,16(sp)
    80006600:	1000                	addi	s0,sp,32
    80006602:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    80006606:	fe843783          	ld	a5,-24(s0)
    8000660a:	07a1                	addi	a5,a5,8
    8000660c:	853e                	mv	a0,a5
    8000660e:	ffffb097          	auipc	ra,0xffffb
    80006612:	c70080e7          	jalr	-912(ra) # 8000127e <acquire>
  while (lk->locked) {
    80006616:	a819                	j	8000662c <acquiresleep+0x32>
    sleep(lk, &lk->lk);
    80006618:	fe843783          	ld	a5,-24(s0)
    8000661c:	07a1                	addi	a5,a5,8
    8000661e:	85be                	mv	a1,a5
    80006620:	fe843503          	ld	a0,-24(s0)
    80006624:	ffffd097          	auipc	ra,0xffffd
    80006628:	de4080e7          	jalr	-540(ra) # 80003408 <sleep>
  while (lk->locked) {
    8000662c:	fe843783          	ld	a5,-24(s0)
    80006630:	439c                	lw	a5,0(a5)
    80006632:	f3fd                	bnez	a5,80006618 <acquiresleep+0x1e>
  }
  lk->locked = 1;
    80006634:	fe843783          	ld	a5,-24(s0)
    80006638:	4705                	li	a4,1
    8000663a:	c398                	sw	a4,0(a5)
  lk->pid = myproc()->pid;
    8000663c:	ffffc097          	auipc	ra,0xffffc
    80006640:	20a080e7          	jalr	522(ra) # 80002846 <myproc>
    80006644:	87aa                	mv	a5,a0
    80006646:	5b98                	lw	a4,48(a5)
    80006648:	fe843783          	ld	a5,-24(s0)
    8000664c:	d798                	sw	a4,40(a5)
  release(&lk->lk);
    8000664e:	fe843783          	ld	a5,-24(s0)
    80006652:	07a1                	addi	a5,a5,8
    80006654:	853e                	mv	a0,a5
    80006656:	ffffb097          	auipc	ra,0xffffb
    8000665a:	c8c080e7          	jalr	-884(ra) # 800012e2 <release>
}
    8000665e:	0001                	nop
    80006660:	60e2                	ld	ra,24(sp)
    80006662:	6442                	ld	s0,16(sp)
    80006664:	6105                	addi	sp,sp,32
    80006666:	8082                	ret

0000000080006668 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80006668:	1101                	addi	sp,sp,-32
    8000666a:	ec06                	sd	ra,24(sp)
    8000666c:	e822                	sd	s0,16(sp)
    8000666e:	1000                	addi	s0,sp,32
    80006670:	fea43423          	sd	a0,-24(s0)
  acquire(&lk->lk);
    80006674:	fe843783          	ld	a5,-24(s0)
    80006678:	07a1                	addi	a5,a5,8
    8000667a:	853e                	mv	a0,a5
    8000667c:	ffffb097          	auipc	ra,0xffffb
    80006680:	c02080e7          	jalr	-1022(ra) # 8000127e <acquire>
  lk->locked = 0;
    80006684:	fe843783          	ld	a5,-24(s0)
    80006688:	0007a023          	sw	zero,0(a5)
  lk->pid = 0;
    8000668c:	fe843783          	ld	a5,-24(s0)
    80006690:	0207a423          	sw	zero,40(a5)
  wakeup(lk);
    80006694:	fe843503          	ld	a0,-24(s0)
    80006698:	ffffd097          	auipc	ra,0xffffd
    8000669c:	dec080e7          	jalr	-532(ra) # 80003484 <wakeup>
  release(&lk->lk);
    800066a0:	fe843783          	ld	a5,-24(s0)
    800066a4:	07a1                	addi	a5,a5,8
    800066a6:	853e                	mv	a0,a5
    800066a8:	ffffb097          	auipc	ra,0xffffb
    800066ac:	c3a080e7          	jalr	-966(ra) # 800012e2 <release>
}
    800066b0:	0001                	nop
    800066b2:	60e2                	ld	ra,24(sp)
    800066b4:	6442                	ld	s0,16(sp)
    800066b6:	6105                	addi	sp,sp,32
    800066b8:	8082                	ret

00000000800066ba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800066ba:	7139                	addi	sp,sp,-64
    800066bc:	fc06                	sd	ra,56(sp)
    800066be:	f822                	sd	s0,48(sp)
    800066c0:	f426                	sd	s1,40(sp)
    800066c2:	0080                	addi	s0,sp,64
    800066c4:	fca43423          	sd	a0,-56(s0)
  int r;
  
  acquire(&lk->lk);
    800066c8:	fc843783          	ld	a5,-56(s0)
    800066cc:	07a1                	addi	a5,a5,8
    800066ce:	853e                	mv	a0,a5
    800066d0:	ffffb097          	auipc	ra,0xffffb
    800066d4:	bae080e7          	jalr	-1106(ra) # 8000127e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800066d8:	fc843783          	ld	a5,-56(s0)
    800066dc:	439c                	lw	a5,0(a5)
    800066de:	cf99                	beqz	a5,800066fc <holdingsleep+0x42>
    800066e0:	fc843783          	ld	a5,-56(s0)
    800066e4:	5784                	lw	s1,40(a5)
    800066e6:	ffffc097          	auipc	ra,0xffffc
    800066ea:	160080e7          	jalr	352(ra) # 80002846 <myproc>
    800066ee:	87aa                	mv	a5,a0
    800066f0:	5b9c                	lw	a5,48(a5)
    800066f2:	8726                	mv	a4,s1
    800066f4:	00f71463          	bne	a4,a5,800066fc <holdingsleep+0x42>
    800066f8:	4785                	li	a5,1
    800066fa:	a011                	j	800066fe <holdingsleep+0x44>
    800066fc:	4781                	li	a5,0
    800066fe:	fcf42e23          	sw	a5,-36(s0)
  release(&lk->lk);
    80006702:	fc843783          	ld	a5,-56(s0)
    80006706:	07a1                	addi	a5,a5,8
    80006708:	853e                	mv	a0,a5
    8000670a:	ffffb097          	auipc	ra,0xffffb
    8000670e:	bd8080e7          	jalr	-1064(ra) # 800012e2 <release>
  return r;
    80006712:	fdc42783          	lw	a5,-36(s0)
}
    80006716:	853e                	mv	a0,a5
    80006718:	70e2                	ld	ra,56(sp)
    8000671a:	7442                	ld	s0,48(sp)
    8000671c:	74a2                	ld	s1,40(sp)
    8000671e:	6121                	addi	sp,sp,64
    80006720:	8082                	ret

0000000080006722 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80006722:	1141                	addi	sp,sp,-16
    80006724:	e406                	sd	ra,8(sp)
    80006726:	e022                	sd	s0,0(sp)
    80006728:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000672a:	00005597          	auipc	a1,0x5
    8000672e:	e8658593          	addi	a1,a1,-378 # 8000b5b0 <etext+0x5b0>
    80006732:	00020517          	auipc	a0,0x20
    80006736:	aee50513          	addi	a0,a0,-1298 # 80026220 <ftable>
    8000673a:	ffffb097          	auipc	ra,0xffffb
    8000673e:	b14080e7          	jalr	-1260(ra) # 8000124e <initlock>
}
    80006742:	0001                	nop
    80006744:	60a2                	ld	ra,8(sp)
    80006746:	6402                	ld	s0,0(sp)
    80006748:	0141                	addi	sp,sp,16
    8000674a:	8082                	ret

000000008000674c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000674c:	1101                	addi	sp,sp,-32
    8000674e:	ec06                	sd	ra,24(sp)
    80006750:	e822                	sd	s0,16(sp)
    80006752:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80006754:	00020517          	auipc	a0,0x20
    80006758:	acc50513          	addi	a0,a0,-1332 # 80026220 <ftable>
    8000675c:	ffffb097          	auipc	ra,0xffffb
    80006760:	b22080e7          	jalr	-1246(ra) # 8000127e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80006764:	00020797          	auipc	a5,0x20
    80006768:	ad478793          	addi	a5,a5,-1324 # 80026238 <ftable+0x18>
    8000676c:	fef43423          	sd	a5,-24(s0)
    80006770:	a815                	j	800067a4 <filealloc+0x58>
    if(f->ref == 0){
    80006772:	fe843783          	ld	a5,-24(s0)
    80006776:	43dc                	lw	a5,4(a5)
    80006778:	e385                	bnez	a5,80006798 <filealloc+0x4c>
      f->ref = 1;
    8000677a:	fe843783          	ld	a5,-24(s0)
    8000677e:	4705                	li	a4,1
    80006780:	c3d8                	sw	a4,4(a5)
      release(&ftable.lock);
    80006782:	00020517          	auipc	a0,0x20
    80006786:	a9e50513          	addi	a0,a0,-1378 # 80026220 <ftable>
    8000678a:	ffffb097          	auipc	ra,0xffffb
    8000678e:	b58080e7          	jalr	-1192(ra) # 800012e2 <release>
      return f;
    80006792:	fe843783          	ld	a5,-24(s0)
    80006796:	a805                	j	800067c6 <filealloc+0x7a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80006798:	fe843783          	ld	a5,-24(s0)
    8000679c:	02878793          	addi	a5,a5,40
    800067a0:	fef43423          	sd	a5,-24(s0)
    800067a4:	00021797          	auipc	a5,0x21
    800067a8:	a3478793          	addi	a5,a5,-1484 # 800271d8 <disk>
    800067ac:	fe843703          	ld	a4,-24(s0)
    800067b0:	fcf761e3          	bltu	a4,a5,80006772 <filealloc+0x26>
    }
  }
  release(&ftable.lock);
    800067b4:	00020517          	auipc	a0,0x20
    800067b8:	a6c50513          	addi	a0,a0,-1428 # 80026220 <ftable>
    800067bc:	ffffb097          	auipc	ra,0xffffb
    800067c0:	b26080e7          	jalr	-1242(ra) # 800012e2 <release>
  return 0;
    800067c4:	4781                	li	a5,0
}
    800067c6:	853e                	mv	a0,a5
    800067c8:	60e2                	ld	ra,24(sp)
    800067ca:	6442                	ld	s0,16(sp)
    800067cc:	6105                	addi	sp,sp,32
    800067ce:	8082                	ret

00000000800067d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800067d0:	1101                	addi	sp,sp,-32
    800067d2:	ec06                	sd	ra,24(sp)
    800067d4:	e822                	sd	s0,16(sp)
    800067d6:	1000                	addi	s0,sp,32
    800067d8:	fea43423          	sd	a0,-24(s0)
  acquire(&ftable.lock);
    800067dc:	00020517          	auipc	a0,0x20
    800067e0:	a4450513          	addi	a0,a0,-1468 # 80026220 <ftable>
    800067e4:	ffffb097          	auipc	ra,0xffffb
    800067e8:	a9a080e7          	jalr	-1382(ra) # 8000127e <acquire>
  if(f->ref < 1)
    800067ec:	fe843783          	ld	a5,-24(s0)
    800067f0:	43dc                	lw	a5,4(a5)
    800067f2:	00f04a63          	bgtz	a5,80006806 <filedup+0x36>
    panic("filedup");
    800067f6:	00005517          	auipc	a0,0x5
    800067fa:	dc250513          	addi	a0,a0,-574 # 8000b5b8 <etext+0x5b8>
    800067fe:	ffffa097          	auipc	ra,0xffffa
    80006802:	48c080e7          	jalr	1164(ra) # 80000c8a <panic>
  f->ref++;
    80006806:	fe843783          	ld	a5,-24(s0)
    8000680a:	43dc                	lw	a5,4(a5)
    8000680c:	2785                	addiw	a5,a5,1
    8000680e:	0007871b          	sext.w	a4,a5
    80006812:	fe843783          	ld	a5,-24(s0)
    80006816:	c3d8                	sw	a4,4(a5)
  release(&ftable.lock);
    80006818:	00020517          	auipc	a0,0x20
    8000681c:	a0850513          	addi	a0,a0,-1528 # 80026220 <ftable>
    80006820:	ffffb097          	auipc	ra,0xffffb
    80006824:	ac2080e7          	jalr	-1342(ra) # 800012e2 <release>
  return f;
    80006828:	fe843783          	ld	a5,-24(s0)
}
    8000682c:	853e                	mv	a0,a5
    8000682e:	60e2                	ld	ra,24(sp)
    80006830:	6442                	ld	s0,16(sp)
    80006832:	6105                	addi	sp,sp,32
    80006834:	8082                	ret

0000000080006836 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80006836:	715d                	addi	sp,sp,-80
    80006838:	e486                	sd	ra,72(sp)
    8000683a:	e0a2                	sd	s0,64(sp)
    8000683c:	0880                	addi	s0,sp,80
    8000683e:	faa43c23          	sd	a0,-72(s0)
  struct file ff;

  acquire(&ftable.lock);
    80006842:	00020517          	auipc	a0,0x20
    80006846:	9de50513          	addi	a0,a0,-1570 # 80026220 <ftable>
    8000684a:	ffffb097          	auipc	ra,0xffffb
    8000684e:	a34080e7          	jalr	-1484(ra) # 8000127e <acquire>
  if(f->ref < 1)
    80006852:	fb843783          	ld	a5,-72(s0)
    80006856:	43dc                	lw	a5,4(a5)
    80006858:	00f04a63          	bgtz	a5,8000686c <fileclose+0x36>
    panic("fileclose");
    8000685c:	00005517          	auipc	a0,0x5
    80006860:	d6450513          	addi	a0,a0,-668 # 8000b5c0 <etext+0x5c0>
    80006864:	ffffa097          	auipc	ra,0xffffa
    80006868:	426080e7          	jalr	1062(ra) # 80000c8a <panic>
  if(--f->ref > 0){
    8000686c:	fb843783          	ld	a5,-72(s0)
    80006870:	43dc                	lw	a5,4(a5)
    80006872:	37fd                	addiw	a5,a5,-1
    80006874:	0007871b          	sext.w	a4,a5
    80006878:	fb843783          	ld	a5,-72(s0)
    8000687c:	c3d8                	sw	a4,4(a5)
    8000687e:	fb843783          	ld	a5,-72(s0)
    80006882:	43dc                	lw	a5,4(a5)
    80006884:	00f05b63          	blez	a5,8000689a <fileclose+0x64>
    release(&ftable.lock);
    80006888:	00020517          	auipc	a0,0x20
    8000688c:	99850513          	addi	a0,a0,-1640 # 80026220 <ftable>
    80006890:	ffffb097          	auipc	ra,0xffffb
    80006894:	a52080e7          	jalr	-1454(ra) # 800012e2 <release>
    80006898:	a879                	j	80006936 <fileclose+0x100>
    return;
  }
  ff = *f;
    8000689a:	fb843783          	ld	a5,-72(s0)
    8000689e:	638c                	ld	a1,0(a5)
    800068a0:	6790                	ld	a2,8(a5)
    800068a2:	6b94                	ld	a3,16(a5)
    800068a4:	6f98                	ld	a4,24(a5)
    800068a6:	739c                	ld	a5,32(a5)
    800068a8:	fcb43423          	sd	a1,-56(s0)
    800068ac:	fcc43823          	sd	a2,-48(s0)
    800068b0:	fcd43c23          	sd	a3,-40(s0)
    800068b4:	fee43023          	sd	a4,-32(s0)
    800068b8:	fef43423          	sd	a5,-24(s0)
  f->ref = 0;
    800068bc:	fb843783          	ld	a5,-72(s0)
    800068c0:	0007a223          	sw	zero,4(a5)
  f->type = FD_NONE;
    800068c4:	fb843783          	ld	a5,-72(s0)
    800068c8:	0007a023          	sw	zero,0(a5)
  release(&ftable.lock);
    800068cc:	00020517          	auipc	a0,0x20
    800068d0:	95450513          	addi	a0,a0,-1708 # 80026220 <ftable>
    800068d4:	ffffb097          	auipc	ra,0xffffb
    800068d8:	a0e080e7          	jalr	-1522(ra) # 800012e2 <release>

  if(ff.type == FD_PIPE){
    800068dc:	fc842783          	lw	a5,-56(s0)
    800068e0:	873e                	mv	a4,a5
    800068e2:	4785                	li	a5,1
    800068e4:	00f71e63          	bne	a4,a5,80006900 <fileclose+0xca>
    pipeclose(ff.pipe, ff.writable);
    800068e8:	fd843783          	ld	a5,-40(s0)
    800068ec:	fd144703          	lbu	a4,-47(s0)
    800068f0:	2701                	sext.w	a4,a4
    800068f2:	85ba                	mv	a1,a4
    800068f4:	853e                	mv	a0,a5
    800068f6:	00000097          	auipc	ra,0x0
    800068fa:	5a6080e7          	jalr	1446(ra) # 80006e9c <pipeclose>
    800068fe:	a825                	j	80006936 <fileclose+0x100>
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80006900:	fc842783          	lw	a5,-56(s0)
    80006904:	873e                	mv	a4,a5
    80006906:	4789                	li	a5,2
    80006908:	00f70863          	beq	a4,a5,80006918 <fileclose+0xe2>
    8000690c:	fc842783          	lw	a5,-56(s0)
    80006910:	873e                	mv	a4,a5
    80006912:	478d                	li	a5,3
    80006914:	02f71163          	bne	a4,a5,80006936 <fileclose+0x100>
    begin_op();
    80006918:	00000097          	auipc	ra,0x0
    8000691c:	884080e7          	jalr	-1916(ra) # 8000619c <begin_op>
    iput(ff.ip);
    80006920:	fe043783          	ld	a5,-32(s0)
    80006924:	853e                	mv	a0,a5
    80006926:	fffff097          	auipc	ra,0xfffff
    8000692a:	970080e7          	jalr	-1680(ra) # 80005296 <iput>
    end_op();
    8000692e:	00000097          	auipc	ra,0x0
    80006932:	930080e7          	jalr	-1744(ra) # 8000625e <end_op>
  }
}
    80006936:	60a6                	ld	ra,72(sp)
    80006938:	6406                	ld	s0,64(sp)
    8000693a:	6161                	addi	sp,sp,80
    8000693c:	8082                	ret

000000008000693e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000693e:	7139                	addi	sp,sp,-64
    80006940:	fc06                	sd	ra,56(sp)
    80006942:	f822                	sd	s0,48(sp)
    80006944:	0080                	addi	s0,sp,64
    80006946:	fca43423          	sd	a0,-56(s0)
    8000694a:	fcb43023          	sd	a1,-64(s0)
  struct proc *p = myproc();
    8000694e:	ffffc097          	auipc	ra,0xffffc
    80006952:	ef8080e7          	jalr	-264(ra) # 80002846 <myproc>
    80006956:	fea43423          	sd	a0,-24(s0)
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000695a:	fc843783          	ld	a5,-56(s0)
    8000695e:	439c                	lw	a5,0(a5)
    80006960:	873e                	mv	a4,a5
    80006962:	4789                	li	a5,2
    80006964:	00f70963          	beq	a4,a5,80006976 <filestat+0x38>
    80006968:	fc843783          	ld	a5,-56(s0)
    8000696c:	439c                	lw	a5,0(a5)
    8000696e:	873e                	mv	a4,a5
    80006970:	478d                	li	a5,3
    80006972:	06f71263          	bne	a4,a5,800069d6 <filestat+0x98>
    ilock(f->ip);
    80006976:	fc843783          	ld	a5,-56(s0)
    8000697a:	6f9c                	ld	a5,24(a5)
    8000697c:	853e                	mv	a0,a5
    8000697e:	ffffe097          	auipc	ra,0xffffe
    80006982:	78a080e7          	jalr	1930(ra) # 80005108 <ilock>
    stati(f->ip, &st);
    80006986:	fc843783          	ld	a5,-56(s0)
    8000698a:	6f9c                	ld	a5,24(a5)
    8000698c:	fd040713          	addi	a4,s0,-48
    80006990:	85ba                	mv	a1,a4
    80006992:	853e                	mv	a0,a5
    80006994:	fffff097          	auipc	ra,0xfffff
    80006998:	cc6080e7          	jalr	-826(ra) # 8000565a <stati>
    iunlock(f->ip);
    8000699c:	fc843783          	ld	a5,-56(s0)
    800069a0:	6f9c                	ld	a5,24(a5)
    800069a2:	853e                	mv	a0,a5
    800069a4:	fffff097          	auipc	ra,0xfffff
    800069a8:	898080e7          	jalr	-1896(ra) # 8000523c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800069ac:	fe843783          	ld	a5,-24(s0)
    800069b0:	6bbc                	ld	a5,80(a5)
    800069b2:	fd040713          	addi	a4,s0,-48
    800069b6:	46e1                	li	a3,24
    800069b8:	863a                	mv	a2,a4
    800069ba:	fc043583          	ld	a1,-64(s0)
    800069be:	853e                	mv	a0,a5
    800069c0:	ffffc097          	auipc	ra,0xffffc
    800069c4:	950080e7          	jalr	-1712(ra) # 80002310 <copyout>
    800069c8:	87aa                	mv	a5,a0
    800069ca:	0007d463          	bgez	a5,800069d2 <filestat+0x94>
      return -1;
    800069ce:	57fd                	li	a5,-1
    800069d0:	a021                	j	800069d8 <filestat+0x9a>
    return 0;
    800069d2:	4781                	li	a5,0
    800069d4:	a011                	j	800069d8 <filestat+0x9a>
  }
  return -1;
    800069d6:	57fd                	li	a5,-1
}
    800069d8:	853e                	mv	a0,a5
    800069da:	70e2                	ld	ra,56(sp)
    800069dc:	7442                	ld	s0,48(sp)
    800069de:	6121                	addi	sp,sp,64
    800069e0:	8082                	ret

00000000800069e2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800069e2:	7139                	addi	sp,sp,-64
    800069e4:	fc06                	sd	ra,56(sp)
    800069e6:	f822                	sd	s0,48(sp)
    800069e8:	0080                	addi	s0,sp,64
    800069ea:	fca43c23          	sd	a0,-40(s0)
    800069ee:	fcb43823          	sd	a1,-48(s0)
    800069f2:	87b2                	mv	a5,a2
    800069f4:	fcf42623          	sw	a5,-52(s0)
  int r = 0;
    800069f8:	fe042623          	sw	zero,-20(s0)

  if(f->readable == 0)
    800069fc:	fd843783          	ld	a5,-40(s0)
    80006a00:	0087c783          	lbu	a5,8(a5)
    80006a04:	e399                	bnez	a5,80006a0a <fileread+0x28>
    return -1;
    80006a06:	57fd                	li	a5,-1
    80006a08:	a23d                	j	80006b36 <fileread+0x154>

  if(f->type == FD_PIPE){
    80006a0a:	fd843783          	ld	a5,-40(s0)
    80006a0e:	439c                	lw	a5,0(a5)
    80006a10:	873e                	mv	a4,a5
    80006a12:	4785                	li	a5,1
    80006a14:	02f71363          	bne	a4,a5,80006a3a <fileread+0x58>
    r = piperead(f->pipe, addr, n);
    80006a18:	fd843783          	ld	a5,-40(s0)
    80006a1c:	6b9c                	ld	a5,16(a5)
    80006a1e:	fcc42703          	lw	a4,-52(s0)
    80006a22:	863a                	mv	a2,a4
    80006a24:	fd043583          	ld	a1,-48(s0)
    80006a28:	853e                	mv	a0,a5
    80006a2a:	00000097          	auipc	ra,0x0
    80006a2e:	66e080e7          	jalr	1646(ra) # 80007098 <piperead>
    80006a32:	87aa                	mv	a5,a0
    80006a34:	fef42623          	sw	a5,-20(s0)
    80006a38:	a8ed                	j	80006b32 <fileread+0x150>
  } else if(f->type == FD_DEVICE){
    80006a3a:	fd843783          	ld	a5,-40(s0)
    80006a3e:	439c                	lw	a5,0(a5)
    80006a40:	873e                	mv	a4,a5
    80006a42:	478d                	li	a5,3
    80006a44:	06f71463          	bne	a4,a5,80006aac <fileread+0xca>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80006a48:	fd843783          	ld	a5,-40(s0)
    80006a4c:	02479783          	lh	a5,36(a5)
    80006a50:	0207c663          	bltz	a5,80006a7c <fileread+0x9a>
    80006a54:	fd843783          	ld	a5,-40(s0)
    80006a58:	02479783          	lh	a5,36(a5)
    80006a5c:	873e                	mv	a4,a5
    80006a5e:	47a5                	li	a5,9
    80006a60:	00e7ce63          	blt	a5,a4,80006a7c <fileread+0x9a>
    80006a64:	fd843783          	ld	a5,-40(s0)
    80006a68:	02479783          	lh	a5,36(a5)
    80006a6c:	0001f717          	auipc	a4,0x1f
    80006a70:	71470713          	addi	a4,a4,1812 # 80026180 <devsw>
    80006a74:	0792                	slli	a5,a5,0x4
    80006a76:	97ba                	add	a5,a5,a4
    80006a78:	639c                	ld	a5,0(a5)
    80006a7a:	e399                	bnez	a5,80006a80 <fileread+0x9e>
      return -1;
    80006a7c:	57fd                	li	a5,-1
    80006a7e:	a865                	j	80006b36 <fileread+0x154>
    r = devsw[f->major].read(1, addr, n);
    80006a80:	fd843783          	ld	a5,-40(s0)
    80006a84:	02479783          	lh	a5,36(a5)
    80006a88:	0001f717          	auipc	a4,0x1f
    80006a8c:	6f870713          	addi	a4,a4,1784 # 80026180 <devsw>
    80006a90:	0792                	slli	a5,a5,0x4
    80006a92:	97ba                	add	a5,a5,a4
    80006a94:	639c                	ld	a5,0(a5)
    80006a96:	fcc42703          	lw	a4,-52(s0)
    80006a9a:	863a                	mv	a2,a4
    80006a9c:	fd043583          	ld	a1,-48(s0)
    80006aa0:	4505                	li	a0,1
    80006aa2:	9782                	jalr	a5
    80006aa4:	87aa                	mv	a5,a0
    80006aa6:	fef42623          	sw	a5,-20(s0)
    80006aaa:	a061                	j	80006b32 <fileread+0x150>
  } else if(f->type == FD_INODE){
    80006aac:	fd843783          	ld	a5,-40(s0)
    80006ab0:	439c                	lw	a5,0(a5)
    80006ab2:	873e                	mv	a4,a5
    80006ab4:	4789                	li	a5,2
    80006ab6:	06f71663          	bne	a4,a5,80006b22 <fileread+0x140>
    ilock(f->ip);
    80006aba:	fd843783          	ld	a5,-40(s0)
    80006abe:	6f9c                	ld	a5,24(a5)
    80006ac0:	853e                	mv	a0,a5
    80006ac2:	ffffe097          	auipc	ra,0xffffe
    80006ac6:	646080e7          	jalr	1606(ra) # 80005108 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80006aca:	fd843783          	ld	a5,-40(s0)
    80006ace:	6f88                	ld	a0,24(a5)
    80006ad0:	fd843783          	ld	a5,-40(s0)
    80006ad4:	539c                	lw	a5,32(a5)
    80006ad6:	fcc42703          	lw	a4,-52(s0)
    80006ada:	86be                	mv	a3,a5
    80006adc:	fd043603          	ld	a2,-48(s0)
    80006ae0:	4585                	li	a1,1
    80006ae2:	fffff097          	auipc	ra,0xfffff
    80006ae6:	bdc080e7          	jalr	-1060(ra) # 800056be <readi>
    80006aea:	87aa                	mv	a5,a0
    80006aec:	fef42623          	sw	a5,-20(s0)
    80006af0:	fec42783          	lw	a5,-20(s0)
    80006af4:	2781                	sext.w	a5,a5
    80006af6:	00f05d63          	blez	a5,80006b10 <fileread+0x12e>
      f->off += r;
    80006afa:	fd843783          	ld	a5,-40(s0)
    80006afe:	5398                	lw	a4,32(a5)
    80006b00:	fec42783          	lw	a5,-20(s0)
    80006b04:	9fb9                	addw	a5,a5,a4
    80006b06:	0007871b          	sext.w	a4,a5
    80006b0a:	fd843783          	ld	a5,-40(s0)
    80006b0e:	d398                	sw	a4,32(a5)
    iunlock(f->ip);
    80006b10:	fd843783          	ld	a5,-40(s0)
    80006b14:	6f9c                	ld	a5,24(a5)
    80006b16:	853e                	mv	a0,a5
    80006b18:	ffffe097          	auipc	ra,0xffffe
    80006b1c:	724080e7          	jalr	1828(ra) # 8000523c <iunlock>
    80006b20:	a809                	j	80006b32 <fileread+0x150>
  } else {
    panic("fileread");
    80006b22:	00005517          	auipc	a0,0x5
    80006b26:	aae50513          	addi	a0,a0,-1362 # 8000b5d0 <etext+0x5d0>
    80006b2a:	ffffa097          	auipc	ra,0xffffa
    80006b2e:	160080e7          	jalr	352(ra) # 80000c8a <panic>
  }

  return r;
    80006b32:	fec42783          	lw	a5,-20(s0)
}
    80006b36:	853e                	mv	a0,a5
    80006b38:	70e2                	ld	ra,56(sp)
    80006b3a:	7442                	ld	s0,48(sp)
    80006b3c:	6121                	addi	sp,sp,64
    80006b3e:	8082                	ret

0000000080006b40 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80006b40:	715d                	addi	sp,sp,-80
    80006b42:	e486                	sd	ra,72(sp)
    80006b44:	e0a2                	sd	s0,64(sp)
    80006b46:	0880                	addi	s0,sp,80
    80006b48:	fca43423          	sd	a0,-56(s0)
    80006b4c:	fcb43023          	sd	a1,-64(s0)
    80006b50:	87b2                	mv	a5,a2
    80006b52:	faf42e23          	sw	a5,-68(s0)
  int r, ret = 0;
    80006b56:	fe042623          	sw	zero,-20(s0)

  if(f->writable == 0)
    80006b5a:	fc843783          	ld	a5,-56(s0)
    80006b5e:	0097c783          	lbu	a5,9(a5)
    80006b62:	e399                	bnez	a5,80006b68 <filewrite+0x28>
    return -1;
    80006b64:	57fd                	li	a5,-1
    80006b66:	aae1                	j	80006d3e <filewrite+0x1fe>

  if(f->type == FD_PIPE){
    80006b68:	fc843783          	ld	a5,-56(s0)
    80006b6c:	439c                	lw	a5,0(a5)
    80006b6e:	873e                	mv	a4,a5
    80006b70:	4785                	li	a5,1
    80006b72:	02f71363          	bne	a4,a5,80006b98 <filewrite+0x58>
    ret = pipewrite(f->pipe, addr, n);
    80006b76:	fc843783          	ld	a5,-56(s0)
    80006b7a:	6b9c                	ld	a5,16(a5)
    80006b7c:	fbc42703          	lw	a4,-68(s0)
    80006b80:	863a                	mv	a2,a4
    80006b82:	fc043583          	ld	a1,-64(s0)
    80006b86:	853e                	mv	a0,a5
    80006b88:	00000097          	auipc	ra,0x0
    80006b8c:	3bc080e7          	jalr	956(ra) # 80006f44 <pipewrite>
    80006b90:	87aa                	mv	a5,a0
    80006b92:	fef42623          	sw	a5,-20(s0)
    80006b96:	a255                	j	80006d3a <filewrite+0x1fa>
  } else if(f->type == FD_DEVICE){
    80006b98:	fc843783          	ld	a5,-56(s0)
    80006b9c:	439c                	lw	a5,0(a5)
    80006b9e:	873e                	mv	a4,a5
    80006ba0:	478d                	li	a5,3
    80006ba2:	06f71463          	bne	a4,a5,80006c0a <filewrite+0xca>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80006ba6:	fc843783          	ld	a5,-56(s0)
    80006baa:	02479783          	lh	a5,36(a5)
    80006bae:	0207c663          	bltz	a5,80006bda <filewrite+0x9a>
    80006bb2:	fc843783          	ld	a5,-56(s0)
    80006bb6:	02479783          	lh	a5,36(a5)
    80006bba:	873e                	mv	a4,a5
    80006bbc:	47a5                	li	a5,9
    80006bbe:	00e7ce63          	blt	a5,a4,80006bda <filewrite+0x9a>
    80006bc2:	fc843783          	ld	a5,-56(s0)
    80006bc6:	02479783          	lh	a5,36(a5)
    80006bca:	0001f717          	auipc	a4,0x1f
    80006bce:	5b670713          	addi	a4,a4,1462 # 80026180 <devsw>
    80006bd2:	0792                	slli	a5,a5,0x4
    80006bd4:	97ba                	add	a5,a5,a4
    80006bd6:	679c                	ld	a5,8(a5)
    80006bd8:	e399                	bnez	a5,80006bde <filewrite+0x9e>
      return -1;
    80006bda:	57fd                	li	a5,-1
    80006bdc:	a28d                	j	80006d3e <filewrite+0x1fe>
    ret = devsw[f->major].write(1, addr, n);
    80006bde:	fc843783          	ld	a5,-56(s0)
    80006be2:	02479783          	lh	a5,36(a5)
    80006be6:	0001f717          	auipc	a4,0x1f
    80006bea:	59a70713          	addi	a4,a4,1434 # 80026180 <devsw>
    80006bee:	0792                	slli	a5,a5,0x4
    80006bf0:	97ba                	add	a5,a5,a4
    80006bf2:	679c                	ld	a5,8(a5)
    80006bf4:	fbc42703          	lw	a4,-68(s0)
    80006bf8:	863a                	mv	a2,a4
    80006bfa:	fc043583          	ld	a1,-64(s0)
    80006bfe:	4505                	li	a0,1
    80006c00:	9782                	jalr	a5
    80006c02:	87aa                	mv	a5,a0
    80006c04:	fef42623          	sw	a5,-20(s0)
    80006c08:	aa0d                	j	80006d3a <filewrite+0x1fa>
  } else if(f->type == FD_INODE){
    80006c0a:	fc843783          	ld	a5,-56(s0)
    80006c0e:	439c                	lw	a5,0(a5)
    80006c10:	873e                	mv	a4,a5
    80006c12:	4789                	li	a5,2
    80006c14:	10f71b63          	bne	a4,a5,80006d2a <filewrite+0x1ea>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    80006c18:	6785                	lui	a5,0x1
    80006c1a:	c0078793          	addi	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80006c1e:	fef42023          	sw	a5,-32(s0)
    int i = 0;
    80006c22:	fe042423          	sw	zero,-24(s0)
    while(i < n){
    80006c26:	a0f9                	j	80006cf4 <filewrite+0x1b4>
      int n1 = n - i;
    80006c28:	fbc42783          	lw	a5,-68(s0)
    80006c2c:	873e                	mv	a4,a5
    80006c2e:	fe842783          	lw	a5,-24(s0)
    80006c32:	40f707bb          	subw	a5,a4,a5
    80006c36:	fef42223          	sw	a5,-28(s0)
      if(n1 > max)
    80006c3a:	fe442783          	lw	a5,-28(s0)
    80006c3e:	873e                	mv	a4,a5
    80006c40:	fe042783          	lw	a5,-32(s0)
    80006c44:	2701                	sext.w	a4,a4
    80006c46:	2781                	sext.w	a5,a5
    80006c48:	00e7d663          	bge	a5,a4,80006c54 <filewrite+0x114>
        n1 = max;
    80006c4c:	fe042783          	lw	a5,-32(s0)
    80006c50:	fef42223          	sw	a5,-28(s0)

      begin_op();
    80006c54:	fffff097          	auipc	ra,0xfffff
    80006c58:	548080e7          	jalr	1352(ra) # 8000619c <begin_op>
      ilock(f->ip);
    80006c5c:	fc843783          	ld	a5,-56(s0)
    80006c60:	6f9c                	ld	a5,24(a5)
    80006c62:	853e                	mv	a0,a5
    80006c64:	ffffe097          	auipc	ra,0xffffe
    80006c68:	4a4080e7          	jalr	1188(ra) # 80005108 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80006c6c:	fc843783          	ld	a5,-56(s0)
    80006c70:	6f88                	ld	a0,24(a5)
    80006c72:	fe842703          	lw	a4,-24(s0)
    80006c76:	fc043783          	ld	a5,-64(s0)
    80006c7a:	00f70633          	add	a2,a4,a5
    80006c7e:	fc843783          	ld	a5,-56(s0)
    80006c82:	539c                	lw	a5,32(a5)
    80006c84:	fe442703          	lw	a4,-28(s0)
    80006c88:	86be                	mv	a3,a5
    80006c8a:	4585                	li	a1,1
    80006c8c:	fffff097          	auipc	ra,0xfffff
    80006c90:	bd0080e7          	jalr	-1072(ra) # 8000585c <writei>
    80006c94:	87aa                	mv	a5,a0
    80006c96:	fcf42e23          	sw	a5,-36(s0)
    80006c9a:	fdc42783          	lw	a5,-36(s0)
    80006c9e:	2781                	sext.w	a5,a5
    80006ca0:	00f05d63          	blez	a5,80006cba <filewrite+0x17a>
        f->off += r;
    80006ca4:	fc843783          	ld	a5,-56(s0)
    80006ca8:	5398                	lw	a4,32(a5)
    80006caa:	fdc42783          	lw	a5,-36(s0)
    80006cae:	9fb9                	addw	a5,a5,a4
    80006cb0:	0007871b          	sext.w	a4,a5
    80006cb4:	fc843783          	ld	a5,-56(s0)
    80006cb8:	d398                	sw	a4,32(a5)
      iunlock(f->ip);
    80006cba:	fc843783          	ld	a5,-56(s0)
    80006cbe:	6f9c                	ld	a5,24(a5)
    80006cc0:	853e                	mv	a0,a5
    80006cc2:	ffffe097          	auipc	ra,0xffffe
    80006cc6:	57a080e7          	jalr	1402(ra) # 8000523c <iunlock>
      end_op();
    80006cca:	fffff097          	auipc	ra,0xfffff
    80006cce:	594080e7          	jalr	1428(ra) # 8000625e <end_op>

      if(r != n1){
    80006cd2:	fdc42783          	lw	a5,-36(s0)
    80006cd6:	873e                	mv	a4,a5
    80006cd8:	fe442783          	lw	a5,-28(s0)
    80006cdc:	2701                	sext.w	a4,a4
    80006cde:	2781                	sext.w	a5,a5
    80006ce0:	02f71463          	bne	a4,a5,80006d08 <filewrite+0x1c8>
        // error from writei
        break;
      }
      i += r;
    80006ce4:	fe842783          	lw	a5,-24(s0)
    80006ce8:	873e                	mv	a4,a5
    80006cea:	fdc42783          	lw	a5,-36(s0)
    80006cee:	9fb9                	addw	a5,a5,a4
    80006cf0:	fef42423          	sw	a5,-24(s0)
    while(i < n){
    80006cf4:	fe842783          	lw	a5,-24(s0)
    80006cf8:	873e                	mv	a4,a5
    80006cfa:	fbc42783          	lw	a5,-68(s0)
    80006cfe:	2701                	sext.w	a4,a4
    80006d00:	2781                	sext.w	a5,a5
    80006d02:	f2f743e3          	blt	a4,a5,80006c28 <filewrite+0xe8>
    80006d06:	a011                	j	80006d0a <filewrite+0x1ca>
        break;
    80006d08:	0001                	nop
    }
    ret = (i == n ? n : -1);
    80006d0a:	fe842783          	lw	a5,-24(s0)
    80006d0e:	873e                	mv	a4,a5
    80006d10:	fbc42783          	lw	a5,-68(s0)
    80006d14:	2701                	sext.w	a4,a4
    80006d16:	2781                	sext.w	a5,a5
    80006d18:	00f71563          	bne	a4,a5,80006d22 <filewrite+0x1e2>
    80006d1c:	fbc42783          	lw	a5,-68(s0)
    80006d20:	a011                	j	80006d24 <filewrite+0x1e4>
    80006d22:	57fd                	li	a5,-1
    80006d24:	fef42623          	sw	a5,-20(s0)
    80006d28:	a809                	j	80006d3a <filewrite+0x1fa>
  } else {
    panic("filewrite");
    80006d2a:	00005517          	auipc	a0,0x5
    80006d2e:	8b650513          	addi	a0,a0,-1866 # 8000b5e0 <etext+0x5e0>
    80006d32:	ffffa097          	auipc	ra,0xffffa
    80006d36:	f58080e7          	jalr	-168(ra) # 80000c8a <panic>
  }

  return ret;
    80006d3a:	fec42783          	lw	a5,-20(s0)
}
    80006d3e:	853e                	mv	a0,a5
    80006d40:	60a6                	ld	ra,72(sp)
    80006d42:	6406                	ld	s0,64(sp)
    80006d44:	6161                	addi	sp,sp,80
    80006d46:	8082                	ret

0000000080006d48 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006d48:	7179                	addi	sp,sp,-48
    80006d4a:	f406                	sd	ra,40(sp)
    80006d4c:	f022                	sd	s0,32(sp)
    80006d4e:	1800                	addi	s0,sp,48
    80006d50:	fca43c23          	sd	a0,-40(s0)
    80006d54:	fcb43823          	sd	a1,-48(s0)
  struct pipe *pi;

  pi = 0;
    80006d58:	fe043423          	sd	zero,-24(s0)
  *f0 = *f1 = 0;
    80006d5c:	fd043783          	ld	a5,-48(s0)
    80006d60:	0007b023          	sd	zero,0(a5)
    80006d64:	fd043783          	ld	a5,-48(s0)
    80006d68:	6398                	ld	a4,0(a5)
    80006d6a:	fd843783          	ld	a5,-40(s0)
    80006d6e:	e398                	sd	a4,0(a5)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006d70:	00000097          	auipc	ra,0x0
    80006d74:	9dc080e7          	jalr	-1572(ra) # 8000674c <filealloc>
    80006d78:	872a                	mv	a4,a0
    80006d7a:	fd843783          	ld	a5,-40(s0)
    80006d7e:	e398                	sd	a4,0(a5)
    80006d80:	fd843783          	ld	a5,-40(s0)
    80006d84:	639c                	ld	a5,0(a5)
    80006d86:	c3e9                	beqz	a5,80006e48 <pipealloc+0x100>
    80006d88:	00000097          	auipc	ra,0x0
    80006d8c:	9c4080e7          	jalr	-1596(ra) # 8000674c <filealloc>
    80006d90:	872a                	mv	a4,a0
    80006d92:	fd043783          	ld	a5,-48(s0)
    80006d96:	e398                	sd	a4,0(a5)
    80006d98:	fd043783          	ld	a5,-48(s0)
    80006d9c:	639c                	ld	a5,0(a5)
    80006d9e:	c7cd                	beqz	a5,80006e48 <pipealloc+0x100>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006da0:	ffffa097          	auipc	ra,0xffffa
    80006da4:	38a080e7          	jalr	906(ra) # 8000112a <kalloc>
    80006da8:	fea43423          	sd	a0,-24(s0)
    80006dac:	fe843783          	ld	a5,-24(s0)
    80006db0:	cfd1                	beqz	a5,80006e4c <pipealloc+0x104>
    goto bad;
  pi->readopen = 1;
    80006db2:	fe843783          	ld	a5,-24(s0)
    80006db6:	4705                	li	a4,1
    80006db8:	22e7a023          	sw	a4,544(a5)
  pi->writeopen = 1;
    80006dbc:	fe843783          	ld	a5,-24(s0)
    80006dc0:	4705                	li	a4,1
    80006dc2:	22e7a223          	sw	a4,548(a5)
  pi->nwrite = 0;
    80006dc6:	fe843783          	ld	a5,-24(s0)
    80006dca:	2007ae23          	sw	zero,540(a5)
  pi->nread = 0;
    80006dce:	fe843783          	ld	a5,-24(s0)
    80006dd2:	2007ac23          	sw	zero,536(a5)
  initlock(&pi->lock, "pipe");
    80006dd6:	fe843783          	ld	a5,-24(s0)
    80006dda:	00005597          	auipc	a1,0x5
    80006dde:	81658593          	addi	a1,a1,-2026 # 8000b5f0 <etext+0x5f0>
    80006de2:	853e                	mv	a0,a5
    80006de4:	ffffa097          	auipc	ra,0xffffa
    80006de8:	46a080e7          	jalr	1130(ra) # 8000124e <initlock>
  (*f0)->type = FD_PIPE;
    80006dec:	fd843783          	ld	a5,-40(s0)
    80006df0:	639c                	ld	a5,0(a5)
    80006df2:	4705                	li	a4,1
    80006df4:	c398                	sw	a4,0(a5)
  (*f0)->readable = 1;
    80006df6:	fd843783          	ld	a5,-40(s0)
    80006dfa:	639c                	ld	a5,0(a5)
    80006dfc:	4705                	li	a4,1
    80006dfe:	00e78423          	sb	a4,8(a5)
  (*f0)->writable = 0;
    80006e02:	fd843783          	ld	a5,-40(s0)
    80006e06:	639c                	ld	a5,0(a5)
    80006e08:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006e0c:	fd843783          	ld	a5,-40(s0)
    80006e10:	639c                	ld	a5,0(a5)
    80006e12:	fe843703          	ld	a4,-24(s0)
    80006e16:	eb98                	sd	a4,16(a5)
  (*f1)->type = FD_PIPE;
    80006e18:	fd043783          	ld	a5,-48(s0)
    80006e1c:	639c                	ld	a5,0(a5)
    80006e1e:	4705                	li	a4,1
    80006e20:	c398                	sw	a4,0(a5)
  (*f1)->readable = 0;
    80006e22:	fd043783          	ld	a5,-48(s0)
    80006e26:	639c                	ld	a5,0(a5)
    80006e28:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80006e2c:	fd043783          	ld	a5,-48(s0)
    80006e30:	639c                	ld	a5,0(a5)
    80006e32:	4705                	li	a4,1
    80006e34:	00e784a3          	sb	a4,9(a5)
  (*f1)->pipe = pi;
    80006e38:	fd043783          	ld	a5,-48(s0)
    80006e3c:	639c                	ld	a5,0(a5)
    80006e3e:	fe843703          	ld	a4,-24(s0)
    80006e42:	eb98                	sd	a4,16(a5)
  return 0;
    80006e44:	4781                	li	a5,0
    80006e46:	a0b1                	j	80006e92 <pipealloc+0x14a>
    goto bad;
    80006e48:	0001                	nop
    80006e4a:	a011                	j	80006e4e <pipealloc+0x106>
    goto bad;
    80006e4c:	0001                	nop

 bad:
  if(pi)
    80006e4e:	fe843783          	ld	a5,-24(s0)
    80006e52:	c799                	beqz	a5,80006e60 <pipealloc+0x118>
    kfree((char*)pi);
    80006e54:	fe843503          	ld	a0,-24(s0)
    80006e58:	ffffa097          	auipc	ra,0xffffa
    80006e5c:	22e080e7          	jalr	558(ra) # 80001086 <kfree>
  if(*f0)
    80006e60:	fd843783          	ld	a5,-40(s0)
    80006e64:	639c                	ld	a5,0(a5)
    80006e66:	cb89                	beqz	a5,80006e78 <pipealloc+0x130>
    fileclose(*f0);
    80006e68:	fd843783          	ld	a5,-40(s0)
    80006e6c:	639c                	ld	a5,0(a5)
    80006e6e:	853e                	mv	a0,a5
    80006e70:	00000097          	auipc	ra,0x0
    80006e74:	9c6080e7          	jalr	-1594(ra) # 80006836 <fileclose>
  if(*f1)
    80006e78:	fd043783          	ld	a5,-48(s0)
    80006e7c:	639c                	ld	a5,0(a5)
    80006e7e:	cb89                	beqz	a5,80006e90 <pipealloc+0x148>
    fileclose(*f1);
    80006e80:	fd043783          	ld	a5,-48(s0)
    80006e84:	639c                	ld	a5,0(a5)
    80006e86:	853e                	mv	a0,a5
    80006e88:	00000097          	auipc	ra,0x0
    80006e8c:	9ae080e7          	jalr	-1618(ra) # 80006836 <fileclose>
  return -1;
    80006e90:	57fd                	li	a5,-1
}
    80006e92:	853e                	mv	a0,a5
    80006e94:	70a2                	ld	ra,40(sp)
    80006e96:	7402                	ld	s0,32(sp)
    80006e98:	6145                	addi	sp,sp,48
    80006e9a:	8082                	ret

0000000080006e9c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006e9c:	1101                	addi	sp,sp,-32
    80006e9e:	ec06                	sd	ra,24(sp)
    80006ea0:	e822                	sd	s0,16(sp)
    80006ea2:	1000                	addi	s0,sp,32
    80006ea4:	fea43423          	sd	a0,-24(s0)
    80006ea8:	87ae                	mv	a5,a1
    80006eaa:	fef42223          	sw	a5,-28(s0)
  acquire(&pi->lock);
    80006eae:	fe843783          	ld	a5,-24(s0)
    80006eb2:	853e                	mv	a0,a5
    80006eb4:	ffffa097          	auipc	ra,0xffffa
    80006eb8:	3ca080e7          	jalr	970(ra) # 8000127e <acquire>
  if(writable){
    80006ebc:	fe442783          	lw	a5,-28(s0)
    80006ec0:	2781                	sext.w	a5,a5
    80006ec2:	cf99                	beqz	a5,80006ee0 <pipeclose+0x44>
    pi->writeopen = 0;
    80006ec4:	fe843783          	ld	a5,-24(s0)
    80006ec8:	2207a223          	sw	zero,548(a5)
    wakeup(&pi->nread);
    80006ecc:	fe843783          	ld	a5,-24(s0)
    80006ed0:	21878793          	addi	a5,a5,536
    80006ed4:	853e                	mv	a0,a5
    80006ed6:	ffffc097          	auipc	ra,0xffffc
    80006eda:	5ae080e7          	jalr	1454(ra) # 80003484 <wakeup>
    80006ede:	a831                	j	80006efa <pipeclose+0x5e>
  } else {
    pi->readopen = 0;
    80006ee0:	fe843783          	ld	a5,-24(s0)
    80006ee4:	2207a023          	sw	zero,544(a5)
    wakeup(&pi->nwrite);
    80006ee8:	fe843783          	ld	a5,-24(s0)
    80006eec:	21c78793          	addi	a5,a5,540
    80006ef0:	853e                	mv	a0,a5
    80006ef2:	ffffc097          	auipc	ra,0xffffc
    80006ef6:	592080e7          	jalr	1426(ra) # 80003484 <wakeup>
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80006efa:	fe843783          	ld	a5,-24(s0)
    80006efe:	2207a783          	lw	a5,544(a5)
    80006f02:	e785                	bnez	a5,80006f2a <pipeclose+0x8e>
    80006f04:	fe843783          	ld	a5,-24(s0)
    80006f08:	2247a783          	lw	a5,548(a5)
    80006f0c:	ef99                	bnez	a5,80006f2a <pipeclose+0x8e>
    release(&pi->lock);
    80006f0e:	fe843783          	ld	a5,-24(s0)
    80006f12:	853e                	mv	a0,a5
    80006f14:	ffffa097          	auipc	ra,0xffffa
    80006f18:	3ce080e7          	jalr	974(ra) # 800012e2 <release>
    kfree((char*)pi);
    80006f1c:	fe843503          	ld	a0,-24(s0)
    80006f20:	ffffa097          	auipc	ra,0xffffa
    80006f24:	166080e7          	jalr	358(ra) # 80001086 <kfree>
    80006f28:	a809                	j	80006f3a <pipeclose+0x9e>
  } else
    release(&pi->lock);
    80006f2a:	fe843783          	ld	a5,-24(s0)
    80006f2e:	853e                	mv	a0,a5
    80006f30:	ffffa097          	auipc	ra,0xffffa
    80006f34:	3b2080e7          	jalr	946(ra) # 800012e2 <release>
}
    80006f38:	0001                	nop
    80006f3a:	0001                	nop
    80006f3c:	60e2                	ld	ra,24(sp)
    80006f3e:	6442                	ld	s0,16(sp)
    80006f40:	6105                	addi	sp,sp,32
    80006f42:	8082                	ret

0000000080006f44 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006f44:	715d                	addi	sp,sp,-80
    80006f46:	e486                	sd	ra,72(sp)
    80006f48:	e0a2                	sd	s0,64(sp)
    80006f4a:	0880                	addi	s0,sp,80
    80006f4c:	fca43423          	sd	a0,-56(s0)
    80006f50:	fcb43023          	sd	a1,-64(s0)
    80006f54:	87b2                	mv	a5,a2
    80006f56:	faf42e23          	sw	a5,-68(s0)
  int i = 0;
    80006f5a:	fe042623          	sw	zero,-20(s0)
  struct proc *pr = myproc();
    80006f5e:	ffffc097          	auipc	ra,0xffffc
    80006f62:	8e8080e7          	jalr	-1816(ra) # 80002846 <myproc>
    80006f66:	fea43023          	sd	a0,-32(s0)

  acquire(&pi->lock);
    80006f6a:	fc843783          	ld	a5,-56(s0)
    80006f6e:	853e                	mv	a0,a5
    80006f70:	ffffa097          	auipc	ra,0xffffa
    80006f74:	30e080e7          	jalr	782(ra) # 8000127e <acquire>
  while(i < n){
    80006f78:	a8f1                	j	80007054 <pipewrite+0x110>
    if(pi->readopen == 0 || killed(pr)){
    80006f7a:	fc843783          	ld	a5,-56(s0)
    80006f7e:	2207a783          	lw	a5,544(a5)
    80006f82:	cb89                	beqz	a5,80006f94 <pipewrite+0x50>
    80006f84:	fe043503          	ld	a0,-32(s0)
    80006f88:	ffffc097          	auipc	ra,0xffffc
    80006f8c:	66a080e7          	jalr	1642(ra) # 800035f2 <killed>
    80006f90:	87aa                	mv	a5,a0
    80006f92:	cb91                	beqz	a5,80006fa6 <pipewrite+0x62>
      release(&pi->lock);
    80006f94:	fc843783          	ld	a5,-56(s0)
    80006f98:	853e                	mv	a0,a5
    80006f9a:	ffffa097          	auipc	ra,0xffffa
    80006f9e:	348080e7          	jalr	840(ra) # 800012e2 <release>
      return -1;
    80006fa2:	57fd                	li	a5,-1
    80006fa4:	a0ed                	j	8000708e <pipewrite+0x14a>
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006fa6:	fc843783          	ld	a5,-56(s0)
    80006faa:	21c7a703          	lw	a4,540(a5)
    80006fae:	fc843783          	ld	a5,-56(s0)
    80006fb2:	2187a783          	lw	a5,536(a5)
    80006fb6:	2007879b          	addiw	a5,a5,512
    80006fba:	2781                	sext.w	a5,a5
    80006fbc:	02f71863          	bne	a4,a5,80006fec <pipewrite+0xa8>
      wakeup(&pi->nread);
    80006fc0:	fc843783          	ld	a5,-56(s0)
    80006fc4:	21878793          	addi	a5,a5,536
    80006fc8:	853e                	mv	a0,a5
    80006fca:	ffffc097          	auipc	ra,0xffffc
    80006fce:	4ba080e7          	jalr	1210(ra) # 80003484 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80006fd2:	fc843783          	ld	a5,-56(s0)
    80006fd6:	21c78793          	addi	a5,a5,540
    80006fda:	fc843703          	ld	a4,-56(s0)
    80006fde:	85ba                	mv	a1,a4
    80006fe0:	853e                	mv	a0,a5
    80006fe2:	ffffc097          	auipc	ra,0xffffc
    80006fe6:	426080e7          	jalr	1062(ra) # 80003408 <sleep>
    80006fea:	a0ad                	j	80007054 <pipewrite+0x110>
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006fec:	fe043783          	ld	a5,-32(s0)
    80006ff0:	6ba8                	ld	a0,80(a5)
    80006ff2:	fec42703          	lw	a4,-20(s0)
    80006ff6:	fc043783          	ld	a5,-64(s0)
    80006ffa:	973e                	add	a4,a4,a5
    80006ffc:	fdf40793          	addi	a5,s0,-33
    80007000:	4685                	li	a3,1
    80007002:	863a                	mv	a2,a4
    80007004:	85be                	mv	a1,a5
    80007006:	ffffb097          	auipc	ra,0xffffb
    8000700a:	3d8080e7          	jalr	984(ra) # 800023de <copyin>
    8000700e:	87aa                	mv	a5,a0
    80007010:	873e                	mv	a4,a5
    80007012:	57fd                	li	a5,-1
    80007014:	04f70a63          	beq	a4,a5,80007068 <pipewrite+0x124>
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80007018:	fc843783          	ld	a5,-56(s0)
    8000701c:	21c7a783          	lw	a5,540(a5)
    80007020:	2781                	sext.w	a5,a5
    80007022:	0017871b          	addiw	a4,a5,1
    80007026:	0007069b          	sext.w	a3,a4
    8000702a:	fc843703          	ld	a4,-56(s0)
    8000702e:	20d72e23          	sw	a3,540(a4)
    80007032:	1ff7f793          	andi	a5,a5,511
    80007036:	2781                	sext.w	a5,a5
    80007038:	fdf44703          	lbu	a4,-33(s0)
    8000703c:	fc843683          	ld	a3,-56(s0)
    80007040:	1782                	slli	a5,a5,0x20
    80007042:	9381                	srli	a5,a5,0x20
    80007044:	97b6                	add	a5,a5,a3
    80007046:	00e78c23          	sb	a4,24(a5)
      i++;
    8000704a:	fec42783          	lw	a5,-20(s0)
    8000704e:	2785                	addiw	a5,a5,1
    80007050:	fef42623          	sw	a5,-20(s0)
  while(i < n){
    80007054:	fec42783          	lw	a5,-20(s0)
    80007058:	873e                	mv	a4,a5
    8000705a:	fbc42783          	lw	a5,-68(s0)
    8000705e:	2701                	sext.w	a4,a4
    80007060:	2781                	sext.w	a5,a5
    80007062:	f0f74ce3          	blt	a4,a5,80006f7a <pipewrite+0x36>
    80007066:	a011                	j	8000706a <pipewrite+0x126>
        break;
    80007068:	0001                	nop
    }
  }
  wakeup(&pi->nread);
    8000706a:	fc843783          	ld	a5,-56(s0)
    8000706e:	21878793          	addi	a5,a5,536
    80007072:	853e                	mv	a0,a5
    80007074:	ffffc097          	auipc	ra,0xffffc
    80007078:	410080e7          	jalr	1040(ra) # 80003484 <wakeup>
  release(&pi->lock);
    8000707c:	fc843783          	ld	a5,-56(s0)
    80007080:	853e                	mv	a0,a5
    80007082:	ffffa097          	auipc	ra,0xffffa
    80007086:	260080e7          	jalr	608(ra) # 800012e2 <release>

  return i;
    8000708a:	fec42783          	lw	a5,-20(s0)
}
    8000708e:	853e                	mv	a0,a5
    80007090:	60a6                	ld	ra,72(sp)
    80007092:	6406                	ld	s0,64(sp)
    80007094:	6161                	addi	sp,sp,80
    80007096:	8082                	ret

0000000080007098 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80007098:	715d                	addi	sp,sp,-80
    8000709a:	e486                	sd	ra,72(sp)
    8000709c:	e0a2                	sd	s0,64(sp)
    8000709e:	0880                	addi	s0,sp,80
    800070a0:	fca43423          	sd	a0,-56(s0)
    800070a4:	fcb43023          	sd	a1,-64(s0)
    800070a8:	87b2                	mv	a5,a2
    800070aa:	faf42e23          	sw	a5,-68(s0)
  int i;
  struct proc *pr = myproc();
    800070ae:	ffffb097          	auipc	ra,0xffffb
    800070b2:	798080e7          	jalr	1944(ra) # 80002846 <myproc>
    800070b6:	fea43023          	sd	a0,-32(s0)
  char ch;

  acquire(&pi->lock);
    800070ba:	fc843783          	ld	a5,-56(s0)
    800070be:	853e                	mv	a0,a5
    800070c0:	ffffa097          	auipc	ra,0xffffa
    800070c4:	1be080e7          	jalr	446(ra) # 8000127e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800070c8:	a835                	j	80007104 <piperead+0x6c>
    if(killed(pr)){
    800070ca:	fe043503          	ld	a0,-32(s0)
    800070ce:	ffffc097          	auipc	ra,0xffffc
    800070d2:	524080e7          	jalr	1316(ra) # 800035f2 <killed>
    800070d6:	87aa                	mv	a5,a0
    800070d8:	cb91                	beqz	a5,800070ec <piperead+0x54>
      release(&pi->lock);
    800070da:	fc843783          	ld	a5,-56(s0)
    800070de:	853e                	mv	a0,a5
    800070e0:	ffffa097          	auipc	ra,0xffffa
    800070e4:	202080e7          	jalr	514(ra) # 800012e2 <release>
      return -1;
    800070e8:	57fd                	li	a5,-1
    800070ea:	a8e5                	j	800071e2 <piperead+0x14a>
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800070ec:	fc843783          	ld	a5,-56(s0)
    800070f0:	21878793          	addi	a5,a5,536
    800070f4:	fc843703          	ld	a4,-56(s0)
    800070f8:	85ba                	mv	a1,a4
    800070fa:	853e                	mv	a0,a5
    800070fc:	ffffc097          	auipc	ra,0xffffc
    80007100:	30c080e7          	jalr	780(ra) # 80003408 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80007104:	fc843783          	ld	a5,-56(s0)
    80007108:	2187a703          	lw	a4,536(a5)
    8000710c:	fc843783          	ld	a5,-56(s0)
    80007110:	21c7a783          	lw	a5,540(a5)
    80007114:	00f71763          	bne	a4,a5,80007122 <piperead+0x8a>
    80007118:	fc843783          	ld	a5,-56(s0)
    8000711c:	2247a783          	lw	a5,548(a5)
    80007120:	f7cd                	bnez	a5,800070ca <piperead+0x32>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80007122:	fe042623          	sw	zero,-20(s0)
    80007126:	a8bd                	j	800071a4 <piperead+0x10c>
    if(pi->nread == pi->nwrite)
    80007128:	fc843783          	ld	a5,-56(s0)
    8000712c:	2187a703          	lw	a4,536(a5)
    80007130:	fc843783          	ld	a5,-56(s0)
    80007134:	21c7a783          	lw	a5,540(a5)
    80007138:	08f70063          	beq	a4,a5,800071b8 <piperead+0x120>
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000713c:	fc843783          	ld	a5,-56(s0)
    80007140:	2187a783          	lw	a5,536(a5)
    80007144:	2781                	sext.w	a5,a5
    80007146:	0017871b          	addiw	a4,a5,1
    8000714a:	0007069b          	sext.w	a3,a4
    8000714e:	fc843703          	ld	a4,-56(s0)
    80007152:	20d72c23          	sw	a3,536(a4)
    80007156:	1ff7f793          	andi	a5,a5,511
    8000715a:	2781                	sext.w	a5,a5
    8000715c:	fc843703          	ld	a4,-56(s0)
    80007160:	1782                	slli	a5,a5,0x20
    80007162:	9381                	srli	a5,a5,0x20
    80007164:	97ba                	add	a5,a5,a4
    80007166:	0187c783          	lbu	a5,24(a5)
    8000716a:	fcf40fa3          	sb	a5,-33(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000716e:	fe043783          	ld	a5,-32(s0)
    80007172:	6ba8                	ld	a0,80(a5)
    80007174:	fec42703          	lw	a4,-20(s0)
    80007178:	fc043783          	ld	a5,-64(s0)
    8000717c:	97ba                	add	a5,a5,a4
    8000717e:	fdf40713          	addi	a4,s0,-33
    80007182:	4685                	li	a3,1
    80007184:	863a                	mv	a2,a4
    80007186:	85be                	mv	a1,a5
    80007188:	ffffb097          	auipc	ra,0xffffb
    8000718c:	188080e7          	jalr	392(ra) # 80002310 <copyout>
    80007190:	87aa                	mv	a5,a0
    80007192:	873e                	mv	a4,a5
    80007194:	57fd                	li	a5,-1
    80007196:	02f70363          	beq	a4,a5,800071bc <piperead+0x124>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000719a:	fec42783          	lw	a5,-20(s0)
    8000719e:	2785                	addiw	a5,a5,1
    800071a0:	fef42623          	sw	a5,-20(s0)
    800071a4:	fec42783          	lw	a5,-20(s0)
    800071a8:	873e                	mv	a4,a5
    800071aa:	fbc42783          	lw	a5,-68(s0)
    800071ae:	2701                	sext.w	a4,a4
    800071b0:	2781                	sext.w	a5,a5
    800071b2:	f6f74be3          	blt	a4,a5,80007128 <piperead+0x90>
    800071b6:	a021                	j	800071be <piperead+0x126>
      break;
    800071b8:	0001                	nop
    800071ba:	a011                	j	800071be <piperead+0x126>
      break;
    800071bc:	0001                	nop
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800071be:	fc843783          	ld	a5,-56(s0)
    800071c2:	21c78793          	addi	a5,a5,540
    800071c6:	853e                	mv	a0,a5
    800071c8:	ffffc097          	auipc	ra,0xffffc
    800071cc:	2bc080e7          	jalr	700(ra) # 80003484 <wakeup>
  release(&pi->lock);
    800071d0:	fc843783          	ld	a5,-56(s0)
    800071d4:	853e                	mv	a0,a5
    800071d6:	ffffa097          	auipc	ra,0xffffa
    800071da:	10c080e7          	jalr	268(ra) # 800012e2 <release>
  return i;
    800071de:	fec42783          	lw	a5,-20(s0)
}
    800071e2:	853e                	mv	a0,a5
    800071e4:	60a6                	ld	ra,72(sp)
    800071e6:	6406                	ld	s0,64(sp)
    800071e8:	6161                	addi	sp,sp,80
    800071ea:	8082                	ret

00000000800071ec <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800071ec:	7179                	addi	sp,sp,-48
    800071ee:	f422                	sd	s0,40(sp)
    800071f0:	1800                	addi	s0,sp,48
    800071f2:	87aa                	mv	a5,a0
    800071f4:	fcf42e23          	sw	a5,-36(s0)
    int perm = 0;
    800071f8:	fe042623          	sw	zero,-20(s0)
    if(flags & 0x1)
    800071fc:	fdc42783          	lw	a5,-36(s0)
    80007200:	8b85                	andi	a5,a5,1
    80007202:	2781                	sext.w	a5,a5
    80007204:	c781                	beqz	a5,8000720c <flags2perm+0x20>
      perm = PTE_X;
    80007206:	47a1                	li	a5,8
    80007208:	fef42623          	sw	a5,-20(s0)
    if(flags & 0x2)
    8000720c:	fdc42783          	lw	a5,-36(s0)
    80007210:	8b89                	andi	a5,a5,2
    80007212:	2781                	sext.w	a5,a5
    80007214:	c799                	beqz	a5,80007222 <flags2perm+0x36>
      perm |= PTE_W;
    80007216:	fec42783          	lw	a5,-20(s0)
    8000721a:	0047e793          	ori	a5,a5,4
    8000721e:	fef42623          	sw	a5,-20(s0)
    return perm;
    80007222:	fec42783          	lw	a5,-20(s0)
}
    80007226:	853e                	mv	a0,a5
    80007228:	7422                	ld	s0,40(sp)
    8000722a:	6145                	addi	sp,sp,48
    8000722c:	8082                	ret

000000008000722e <exec>:

int
exec(char *path, char **argv)
{
    8000722e:	de010113          	addi	sp,sp,-544
    80007232:	20113c23          	sd	ra,536(sp)
    80007236:	20813823          	sd	s0,528(sp)
    8000723a:	20913423          	sd	s1,520(sp)
    8000723e:	1400                	addi	s0,sp,544
    80007240:	dea43423          	sd	a0,-536(s0)
    80007244:	deb43023          	sd	a1,-544(s0)
  char *s, *last;
  int i, off;
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80007248:	fa043c23          	sd	zero,-72(s0)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
    8000724c:	fa043023          	sd	zero,-96(s0)
  struct proc *p = myproc();
    80007250:	ffffb097          	auipc	ra,0xffffb
    80007254:	5f6080e7          	jalr	1526(ra) # 80002846 <myproc>
    80007258:	f8a43c23          	sd	a0,-104(s0)

  begin_op();
    8000725c:	fffff097          	auipc	ra,0xfffff
    80007260:	f40080e7          	jalr	-192(ra) # 8000619c <begin_op>

  if((ip = namei(path)) == 0){
    80007264:	de843503          	ld	a0,-536(s0)
    80007268:	fffff097          	auipc	ra,0xfffff
    8000726c:	bd0080e7          	jalr	-1072(ra) # 80005e38 <namei>
    80007270:	faa43423          	sd	a0,-88(s0)
    80007274:	fa843783          	ld	a5,-88(s0)
    80007278:	e799                	bnez	a5,80007286 <exec+0x58>
    end_op();
    8000727a:	fffff097          	auipc	ra,0xfffff
    8000727e:	fe4080e7          	jalr	-28(ra) # 8000625e <end_op>
    return -1;
    80007282:	57fd                	li	a5,-1
    80007284:	a199                	j	800076ca <exec+0x49c>
  }
  ilock(ip);
    80007286:	fa843503          	ld	a0,-88(s0)
    8000728a:	ffffe097          	auipc	ra,0xffffe
    8000728e:	e7e080e7          	jalr	-386(ra) # 80005108 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80007292:	e3040793          	addi	a5,s0,-464
    80007296:	04000713          	li	a4,64
    8000729a:	4681                	li	a3,0
    8000729c:	863e                	mv	a2,a5
    8000729e:	4581                	li	a1,0
    800072a0:	fa843503          	ld	a0,-88(s0)
    800072a4:	ffffe097          	auipc	ra,0xffffe
    800072a8:	41a080e7          	jalr	1050(ra) # 800056be <readi>
    800072ac:	87aa                	mv	a5,a0
    800072ae:	873e                	mv	a4,a5
    800072b0:	04000793          	li	a5,64
    800072b4:	3af71563          	bne	a4,a5,8000765e <exec+0x430>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800072b8:	e3042783          	lw	a5,-464(s0)
    800072bc:	873e                	mv	a4,a5
    800072be:	464c47b7          	lui	a5,0x464c4
    800072c2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800072c6:	38f71e63          	bne	a4,a5,80007662 <exec+0x434>
    goto bad;

  if((pagetable = proc_pagetable(p)) == 0)
    800072ca:	f9843503          	ld	a0,-104(s0)
    800072ce:	ffffb097          	auipc	ra,0xffffb
    800072d2:	7da080e7          	jalr	2010(ra) # 80002aa8 <proc_pagetable>
    800072d6:	faa43023          	sd	a0,-96(s0)
    800072da:	fa043783          	ld	a5,-96(s0)
    800072de:	38078463          	beqz	a5,80007666 <exec+0x438>
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800072e2:	fc042623          	sw	zero,-52(s0)
    800072e6:	e5043783          	ld	a5,-432(s0)
    800072ea:	fcf42423          	sw	a5,-56(s0)
    800072ee:	a0fd                	j	800073dc <exec+0x1ae>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800072f0:	df840793          	addi	a5,s0,-520
    800072f4:	fc842683          	lw	a3,-56(s0)
    800072f8:	03800713          	li	a4,56
    800072fc:	863e                	mv	a2,a5
    800072fe:	4581                	li	a1,0
    80007300:	fa843503          	ld	a0,-88(s0)
    80007304:	ffffe097          	auipc	ra,0xffffe
    80007308:	3ba080e7          	jalr	954(ra) # 800056be <readi>
    8000730c:	87aa                	mv	a5,a0
    8000730e:	873e                	mv	a4,a5
    80007310:	03800793          	li	a5,56
    80007314:	34f71b63          	bne	a4,a5,8000766a <exec+0x43c>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
    80007318:	df842783          	lw	a5,-520(s0)
    8000731c:	873e                	mv	a4,a5
    8000731e:	4785                	li	a5,1
    80007320:	0af71163          	bne	a4,a5,800073c2 <exec+0x194>
      continue;
    if(ph.memsz < ph.filesz)
    80007324:	e2043703          	ld	a4,-480(s0)
    80007328:	e1843783          	ld	a5,-488(s0)
    8000732c:	34f76163          	bltu	a4,a5,8000766e <exec+0x440>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80007330:	e0843703          	ld	a4,-504(s0)
    80007334:	e2043783          	ld	a5,-480(s0)
    80007338:	973e                	add	a4,a4,a5
    8000733a:	e0843783          	ld	a5,-504(s0)
    8000733e:	32f76a63          	bltu	a4,a5,80007672 <exec+0x444>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
    80007342:	e0843703          	ld	a4,-504(s0)
    80007346:	6785                	lui	a5,0x1
    80007348:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000734a:	8ff9                	and	a5,a5,a4
    8000734c:	32079563          	bnez	a5,80007676 <exec+0x448>
      goto bad;
    uint64 sz1;
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80007350:	e0843703          	ld	a4,-504(s0)
    80007354:	e2043783          	ld	a5,-480(s0)
    80007358:	00f704b3          	add	s1,a4,a5
    8000735c:	dfc42783          	lw	a5,-516(s0)
    80007360:	2781                	sext.w	a5,a5
    80007362:	853e                	mv	a0,a5
    80007364:	00000097          	auipc	ra,0x0
    80007368:	e88080e7          	jalr	-376(ra) # 800071ec <flags2perm>
    8000736c:	87aa                	mv	a5,a0
    8000736e:	86be                	mv	a3,a5
    80007370:	8626                	mv	a2,s1
    80007372:	fb843583          	ld	a1,-72(s0)
    80007376:	fa043503          	ld	a0,-96(s0)
    8000737a:	ffffb097          	auipc	ra,0xffffb
    8000737e:	baa080e7          	jalr	-1110(ra) # 80001f24 <uvmalloc>
    80007382:	f6a43823          	sd	a0,-144(s0)
    80007386:	f7043783          	ld	a5,-144(s0)
    8000738a:	2e078863          	beqz	a5,8000767a <exec+0x44c>
      goto bad;
    sz = sz1;
    8000738e:	f7043783          	ld	a5,-144(s0)
    80007392:	faf43c23          	sd	a5,-72(s0)
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80007396:	e0843783          	ld	a5,-504(s0)
    8000739a:	e0043703          	ld	a4,-512(s0)
    8000739e:	0007069b          	sext.w	a3,a4
    800073a2:	e1843703          	ld	a4,-488(s0)
    800073a6:	2701                	sext.w	a4,a4
    800073a8:	fa843603          	ld	a2,-88(s0)
    800073ac:	85be                	mv	a1,a5
    800073ae:	fa043503          	ld	a0,-96(s0)
    800073b2:	00000097          	auipc	ra,0x0
    800073b6:	32c080e7          	jalr	812(ra) # 800076de <loadseg>
    800073ba:	87aa                	mv	a5,a0
    800073bc:	2c07c163          	bltz	a5,8000767e <exec+0x450>
    800073c0:	a011                	j	800073c4 <exec+0x196>
      continue;
    800073c2:	0001                	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800073c4:	fcc42783          	lw	a5,-52(s0)
    800073c8:	2785                	addiw	a5,a5,1
    800073ca:	fcf42623          	sw	a5,-52(s0)
    800073ce:	fc842783          	lw	a5,-56(s0)
    800073d2:	0387879b          	addiw	a5,a5,56
    800073d6:	2781                	sext.w	a5,a5
    800073d8:	fcf42423          	sw	a5,-56(s0)
    800073dc:	e6845783          	lhu	a5,-408(s0)
    800073e0:	0007871b          	sext.w	a4,a5
    800073e4:	fcc42783          	lw	a5,-52(s0)
    800073e8:	2781                	sext.w	a5,a5
    800073ea:	f0e7c3e3          	blt	a5,a4,800072f0 <exec+0xc2>
      goto bad;
  }
  iunlockput(ip);
    800073ee:	fa843503          	ld	a0,-88(s0)
    800073f2:	ffffe097          	auipc	ra,0xffffe
    800073f6:	f74080e7          	jalr	-140(ra) # 80005366 <iunlockput>
  end_op();
    800073fa:	fffff097          	auipc	ra,0xfffff
    800073fe:	e64080e7          	jalr	-412(ra) # 8000625e <end_op>
  ip = 0;
    80007402:	fa043423          	sd	zero,-88(s0)

  p = myproc();
    80007406:	ffffb097          	auipc	ra,0xffffb
    8000740a:	440080e7          	jalr	1088(ra) # 80002846 <myproc>
    8000740e:	f8a43c23          	sd	a0,-104(s0)
  uint64 oldsz = p->sz;
    80007412:	f9843783          	ld	a5,-104(s0)
    80007416:	67bc                	ld	a5,72(a5)
    80007418:	f8f43823          	sd	a5,-112(s0)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible as a stack guard.
  // Use the second as the user stack.
  sz = PGROUNDUP(sz);
    8000741c:	fb843703          	ld	a4,-72(s0)
    80007420:	6785                	lui	a5,0x1
    80007422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80007424:	973e                	add	a4,a4,a5
    80007426:	77fd                	lui	a5,0xfffff
    80007428:	8ff9                	and	a5,a5,a4
    8000742a:	faf43c23          	sd	a5,-72(s0)
  uint64 sz1;
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000742e:	fb843703          	ld	a4,-72(s0)
    80007432:	6789                	lui	a5,0x2
    80007434:	97ba                	add	a5,a5,a4
    80007436:	4691                	li	a3,4
    80007438:	863e                	mv	a2,a5
    8000743a:	fb843583          	ld	a1,-72(s0)
    8000743e:	fa043503          	ld	a0,-96(s0)
    80007442:	ffffb097          	auipc	ra,0xffffb
    80007446:	ae2080e7          	jalr	-1310(ra) # 80001f24 <uvmalloc>
    8000744a:	f8a43423          	sd	a0,-120(s0)
    8000744e:	f8843783          	ld	a5,-120(s0)
    80007452:	22078863          	beqz	a5,80007682 <exec+0x454>
    goto bad;
  sz = sz1;
    80007456:	f8843783          	ld	a5,-120(s0)
    8000745a:	faf43c23          	sd	a5,-72(s0)
  uvmclear(pagetable, sz-2*PGSIZE);
    8000745e:	fb843703          	ld	a4,-72(s0)
    80007462:	77f9                	lui	a5,0xffffe
    80007464:	97ba                	add	a5,a5,a4
    80007466:	85be                	mv	a1,a5
    80007468:	fa043503          	ld	a0,-96(s0)
    8000746c:	ffffb097          	auipc	ra,0xffffb
    80007470:	e4e080e7          	jalr	-434(ra) # 800022ba <uvmclear>
  sp = sz;
    80007474:	fb843783          	ld	a5,-72(s0)
    80007478:	faf43823          	sd	a5,-80(s0)
  stackbase = sp - PGSIZE;
    8000747c:	fb043703          	ld	a4,-80(s0)
    80007480:	77fd                	lui	a5,0xfffff
    80007482:	97ba                	add	a5,a5,a4
    80007484:	f8f43023          	sd	a5,-128(s0)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    80007488:	fc043023          	sd	zero,-64(s0)
    8000748c:	a07d                	j	8000753a <exec+0x30c>
    if(argc >= MAXARG)
    8000748e:	fc043703          	ld	a4,-64(s0)
    80007492:	47fd                	li	a5,31
    80007494:	1ee7e963          	bltu	a5,a4,80007686 <exec+0x458>
      goto bad;
    sp -= strlen(argv[argc]) + 1;
    80007498:	fc043783          	ld	a5,-64(s0)
    8000749c:	078e                	slli	a5,a5,0x3
    8000749e:	de043703          	ld	a4,-544(s0)
    800074a2:	97ba                	add	a5,a5,a4
    800074a4:	639c                	ld	a5,0(a5)
    800074a6:	853e                	mv	a0,a5
    800074a8:	ffffa097          	auipc	ra,0xffffa
    800074ac:	32a080e7          	jalr	810(ra) # 800017d2 <strlen>
    800074b0:	87aa                	mv	a5,a0
    800074b2:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffd7ce9>
    800074b4:	2781                	sext.w	a5,a5
    800074b6:	873e                	mv	a4,a5
    800074b8:	fb043783          	ld	a5,-80(s0)
    800074bc:	8f99                	sub	a5,a5,a4
    800074be:	faf43823          	sd	a5,-80(s0)
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800074c2:	fb043783          	ld	a5,-80(s0)
    800074c6:	9bc1                	andi	a5,a5,-16
    800074c8:	faf43823          	sd	a5,-80(s0)
    if(sp < stackbase)
    800074cc:	fb043703          	ld	a4,-80(s0)
    800074d0:	f8043783          	ld	a5,-128(s0)
    800074d4:	1af76b63          	bltu	a4,a5,8000768a <exec+0x45c>
      goto bad;
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800074d8:	fc043783          	ld	a5,-64(s0)
    800074dc:	078e                	slli	a5,a5,0x3
    800074de:	de043703          	ld	a4,-544(s0)
    800074e2:	97ba                	add	a5,a5,a4
    800074e4:	6384                	ld	s1,0(a5)
    800074e6:	fc043783          	ld	a5,-64(s0)
    800074ea:	078e                	slli	a5,a5,0x3
    800074ec:	de043703          	ld	a4,-544(s0)
    800074f0:	97ba                	add	a5,a5,a4
    800074f2:	639c                	ld	a5,0(a5)
    800074f4:	853e                	mv	a0,a5
    800074f6:	ffffa097          	auipc	ra,0xffffa
    800074fa:	2dc080e7          	jalr	732(ra) # 800017d2 <strlen>
    800074fe:	87aa                	mv	a5,a0
    80007500:	2785                	addiw	a5,a5,1
    80007502:	2781                	sext.w	a5,a5
    80007504:	86be                	mv	a3,a5
    80007506:	8626                	mv	a2,s1
    80007508:	fb043583          	ld	a1,-80(s0)
    8000750c:	fa043503          	ld	a0,-96(s0)
    80007510:	ffffb097          	auipc	ra,0xffffb
    80007514:	e00080e7          	jalr	-512(ra) # 80002310 <copyout>
    80007518:	87aa                	mv	a5,a0
    8000751a:	1607ca63          	bltz	a5,8000768e <exec+0x460>
      goto bad;
    ustack[argc] = sp;
    8000751e:	fc043783          	ld	a5,-64(s0)
    80007522:	078e                	slli	a5,a5,0x3
    80007524:	1781                	addi	a5,a5,-32
    80007526:	97a2                	add	a5,a5,s0
    80007528:	fb043703          	ld	a4,-80(s0)
    8000752c:	e8e7b823          	sd	a4,-368(a5)
  for(argc = 0; argv[argc]; argc++) {
    80007530:	fc043783          	ld	a5,-64(s0)
    80007534:	0785                	addi	a5,a5,1
    80007536:	fcf43023          	sd	a5,-64(s0)
    8000753a:	fc043783          	ld	a5,-64(s0)
    8000753e:	078e                	slli	a5,a5,0x3
    80007540:	de043703          	ld	a4,-544(s0)
    80007544:	97ba                	add	a5,a5,a4
    80007546:	639c                	ld	a5,0(a5)
    80007548:	f3b9                	bnez	a5,8000748e <exec+0x260>
  }
  ustack[argc] = 0;
    8000754a:	fc043783          	ld	a5,-64(s0)
    8000754e:	078e                	slli	a5,a5,0x3
    80007550:	1781                	addi	a5,a5,-32
    80007552:	97a2                	add	a5,a5,s0
    80007554:	e807b823          	sd	zero,-368(a5)

  // push the array of argv[] pointers.
  sp -= (argc+1) * sizeof(uint64);
    80007558:	fc043783          	ld	a5,-64(s0)
    8000755c:	0785                	addi	a5,a5,1
    8000755e:	078e                	slli	a5,a5,0x3
    80007560:	fb043703          	ld	a4,-80(s0)
    80007564:	40f707b3          	sub	a5,a4,a5
    80007568:	faf43823          	sd	a5,-80(s0)
  sp -= sp % 16;
    8000756c:	fb043783          	ld	a5,-80(s0)
    80007570:	9bc1                	andi	a5,a5,-16
    80007572:	faf43823          	sd	a5,-80(s0)
  if(sp < stackbase)
    80007576:	fb043703          	ld	a4,-80(s0)
    8000757a:	f8043783          	ld	a5,-128(s0)
    8000757e:	10f76a63          	bltu	a4,a5,80007692 <exec+0x464>
    goto bad;
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80007582:	fc043783          	ld	a5,-64(s0)
    80007586:	0785                	addi	a5,a5,1
    80007588:	00379713          	slli	a4,a5,0x3
    8000758c:	e7040793          	addi	a5,s0,-400
    80007590:	86ba                	mv	a3,a4
    80007592:	863e                	mv	a2,a5
    80007594:	fb043583          	ld	a1,-80(s0)
    80007598:	fa043503          	ld	a0,-96(s0)
    8000759c:	ffffb097          	auipc	ra,0xffffb
    800075a0:	d74080e7          	jalr	-652(ra) # 80002310 <copyout>
    800075a4:	87aa                	mv	a5,a0
    800075a6:	0e07c863          	bltz	a5,80007696 <exec+0x468>
    goto bad;

  // arguments to user main(argc, argv)
  // argc is returned via the system call return
  // value, which goes in a0.
  p->trapframe->a1 = sp;
    800075aa:	f9843783          	ld	a5,-104(s0)
    800075ae:	6fbc                	ld	a5,88(a5)
    800075b0:	fb043703          	ld	a4,-80(s0)
    800075b4:	ffb8                	sd	a4,120(a5)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    800075b6:	de843783          	ld	a5,-536(s0)
    800075ba:	fcf43c23          	sd	a5,-40(s0)
    800075be:	fd843783          	ld	a5,-40(s0)
    800075c2:	fcf43823          	sd	a5,-48(s0)
    800075c6:	a025                	j	800075ee <exec+0x3c0>
    if(*s == '/')
    800075c8:	fd843783          	ld	a5,-40(s0)
    800075cc:	0007c783          	lbu	a5,0(a5)
    800075d0:	873e                	mv	a4,a5
    800075d2:	02f00793          	li	a5,47
    800075d6:	00f71763          	bne	a4,a5,800075e4 <exec+0x3b6>
      last = s+1;
    800075da:	fd843783          	ld	a5,-40(s0)
    800075de:	0785                	addi	a5,a5,1
    800075e0:	fcf43823          	sd	a5,-48(s0)
  for(last=s=path; *s; s++)
    800075e4:	fd843783          	ld	a5,-40(s0)
    800075e8:	0785                	addi	a5,a5,1
    800075ea:	fcf43c23          	sd	a5,-40(s0)
    800075ee:	fd843783          	ld	a5,-40(s0)
    800075f2:	0007c783          	lbu	a5,0(a5)
    800075f6:	fbe9                	bnez	a5,800075c8 <exec+0x39a>
  safestrcpy(p->name, last, sizeof(p->name));
    800075f8:	f9843783          	ld	a5,-104(s0)
    800075fc:	15878793          	addi	a5,a5,344
    80007600:	4641                	li	a2,16
    80007602:	fd043583          	ld	a1,-48(s0)
    80007606:	853e                	mv	a0,a5
    80007608:	ffffa097          	auipc	ra,0xffffa
    8000760c:	14e080e7          	jalr	334(ra) # 80001756 <safestrcpy>
    
  // Commit to the user image.
  oldpagetable = p->pagetable;
    80007610:	f9843783          	ld	a5,-104(s0)
    80007614:	6bbc                	ld	a5,80(a5)
    80007616:	f6f43c23          	sd	a5,-136(s0)
  p->pagetable = pagetable;
    8000761a:	f9843783          	ld	a5,-104(s0)
    8000761e:	fa043703          	ld	a4,-96(s0)
    80007622:	ebb8                	sd	a4,80(a5)
  p->sz = sz;
    80007624:	f9843783          	ld	a5,-104(s0)
    80007628:	fb843703          	ld	a4,-72(s0)
    8000762c:	e7b8                	sd	a4,72(a5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000762e:	f9843783          	ld	a5,-104(s0)
    80007632:	6fbc                	ld	a5,88(a5)
    80007634:	e4843703          	ld	a4,-440(s0)
    80007638:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000763a:	f9843783          	ld	a5,-104(s0)
    8000763e:	6fbc                	ld	a5,88(a5)
    80007640:	fb043703          	ld	a4,-80(s0)
    80007644:	fb98                	sd	a4,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80007646:	f9043583          	ld	a1,-112(s0)
    8000764a:	f7843503          	ld	a0,-136(s0)
    8000764e:	ffffb097          	auipc	ra,0xffffb
    80007652:	51a080e7          	jalr	1306(ra) # 80002b68 <proc_freepagetable>

  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80007656:	fc043783          	ld	a5,-64(s0)
    8000765a:	2781                	sext.w	a5,a5
    8000765c:	a0bd                	j	800076ca <exec+0x49c>
    goto bad;
    8000765e:	0001                	nop
    80007660:	a825                	j	80007698 <exec+0x46a>
    goto bad;
    80007662:	0001                	nop
    80007664:	a815                	j	80007698 <exec+0x46a>
    goto bad;
    80007666:	0001                	nop
    80007668:	a805                	j	80007698 <exec+0x46a>
      goto bad;
    8000766a:	0001                	nop
    8000766c:	a035                	j	80007698 <exec+0x46a>
      goto bad;
    8000766e:	0001                	nop
    80007670:	a025                	j	80007698 <exec+0x46a>
      goto bad;
    80007672:	0001                	nop
    80007674:	a015                	j	80007698 <exec+0x46a>
      goto bad;
    80007676:	0001                	nop
    80007678:	a005                	j	80007698 <exec+0x46a>
      goto bad;
    8000767a:	0001                	nop
    8000767c:	a831                	j	80007698 <exec+0x46a>
      goto bad;
    8000767e:	0001                	nop
    80007680:	a821                	j	80007698 <exec+0x46a>
    goto bad;
    80007682:	0001                	nop
    80007684:	a811                	j	80007698 <exec+0x46a>
      goto bad;
    80007686:	0001                	nop
    80007688:	a801                	j	80007698 <exec+0x46a>
      goto bad;
    8000768a:	0001                	nop
    8000768c:	a031                	j	80007698 <exec+0x46a>
      goto bad;
    8000768e:	0001                	nop
    80007690:	a021                	j	80007698 <exec+0x46a>
    goto bad;
    80007692:	0001                	nop
    80007694:	a011                	j	80007698 <exec+0x46a>
    goto bad;
    80007696:	0001                	nop

 bad:
  if(pagetable)
    80007698:	fa043783          	ld	a5,-96(s0)
    8000769c:	cb89                	beqz	a5,800076ae <exec+0x480>
    proc_freepagetable(pagetable, sz);
    8000769e:	fb843583          	ld	a1,-72(s0)
    800076a2:	fa043503          	ld	a0,-96(s0)
    800076a6:	ffffb097          	auipc	ra,0xffffb
    800076aa:	4c2080e7          	jalr	1218(ra) # 80002b68 <proc_freepagetable>
  if(ip){
    800076ae:	fa843783          	ld	a5,-88(s0)
    800076b2:	cb99                	beqz	a5,800076c8 <exec+0x49a>
    iunlockput(ip);
    800076b4:	fa843503          	ld	a0,-88(s0)
    800076b8:	ffffe097          	auipc	ra,0xffffe
    800076bc:	cae080e7          	jalr	-850(ra) # 80005366 <iunlockput>
    end_op();
    800076c0:	fffff097          	auipc	ra,0xfffff
    800076c4:	b9e080e7          	jalr	-1122(ra) # 8000625e <end_op>
  }
  return -1;
    800076c8:	57fd                	li	a5,-1
}
    800076ca:	853e                	mv	a0,a5
    800076cc:	21813083          	ld	ra,536(sp)
    800076d0:	21013403          	ld	s0,528(sp)
    800076d4:	20813483          	ld	s1,520(sp)
    800076d8:	22010113          	addi	sp,sp,544
    800076dc:	8082                	ret

00000000800076de <loadseg>:
// va must be page-aligned
// and the pages from va to va+sz must already be mapped.
// Returns 0 on success, -1 on failure.
static int
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
    800076de:	7139                	addi	sp,sp,-64
    800076e0:	fc06                	sd	ra,56(sp)
    800076e2:	f822                	sd	s0,48(sp)
    800076e4:	0080                	addi	s0,sp,64
    800076e6:	fca43c23          	sd	a0,-40(s0)
    800076ea:	fcb43823          	sd	a1,-48(s0)
    800076ee:	fcc43423          	sd	a2,-56(s0)
    800076f2:	87b6                	mv	a5,a3
    800076f4:	fcf42223          	sw	a5,-60(s0)
    800076f8:	87ba                	mv	a5,a4
    800076fa:	fcf42023          	sw	a5,-64(s0)
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800076fe:	fe042623          	sw	zero,-20(s0)
    80007702:	a07d                	j	800077b0 <loadseg+0xd2>
    pa = walkaddr(pagetable, va + i);
    80007704:	fec46703          	lwu	a4,-20(s0)
    80007708:	fd043783          	ld	a5,-48(s0)
    8000770c:	97ba                	add	a5,a5,a4
    8000770e:	85be                	mv	a1,a5
    80007710:	fd843503          	ld	a0,-40(s0)
    80007714:	ffffa097          	auipc	ra,0xffffa
    80007718:	49c080e7          	jalr	1180(ra) # 80001bb0 <walkaddr>
    8000771c:	fea43023          	sd	a0,-32(s0)
    if(pa == 0)
    80007720:	fe043783          	ld	a5,-32(s0)
    80007724:	eb89                	bnez	a5,80007736 <loadseg+0x58>
      panic("loadseg: address should exist");
    80007726:	00004517          	auipc	a0,0x4
    8000772a:	ed250513          	addi	a0,a0,-302 # 8000b5f8 <etext+0x5f8>
    8000772e:	ffff9097          	auipc	ra,0xffff9
    80007732:	55c080e7          	jalr	1372(ra) # 80000c8a <panic>
    if(sz - i < PGSIZE)
    80007736:	fc042783          	lw	a5,-64(s0)
    8000773a:	873e                	mv	a4,a5
    8000773c:	fec42783          	lw	a5,-20(s0)
    80007740:	40f707bb          	subw	a5,a4,a5
    80007744:	2781                	sext.w	a5,a5
    80007746:	873e                	mv	a4,a5
    80007748:	6785                	lui	a5,0x1
    8000774a:	00f77c63          	bgeu	a4,a5,80007762 <loadseg+0x84>
      n = sz - i;
    8000774e:	fc042783          	lw	a5,-64(s0)
    80007752:	873e                	mv	a4,a5
    80007754:	fec42783          	lw	a5,-20(s0)
    80007758:	40f707bb          	subw	a5,a4,a5
    8000775c:	fef42423          	sw	a5,-24(s0)
    80007760:	a021                	j	80007768 <loadseg+0x8a>
    else
      n = PGSIZE;
    80007762:	6785                	lui	a5,0x1
    80007764:	fef42423          	sw	a5,-24(s0)
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80007768:	fc442783          	lw	a5,-60(s0)
    8000776c:	873e                	mv	a4,a5
    8000776e:	fec42783          	lw	a5,-20(s0)
    80007772:	9fb9                	addw	a5,a5,a4
    80007774:	2781                	sext.w	a5,a5
    80007776:	fe842703          	lw	a4,-24(s0)
    8000777a:	86be                	mv	a3,a5
    8000777c:	fe043603          	ld	a2,-32(s0)
    80007780:	4581                	li	a1,0
    80007782:	fc843503          	ld	a0,-56(s0)
    80007786:	ffffe097          	auipc	ra,0xffffe
    8000778a:	f38080e7          	jalr	-200(ra) # 800056be <readi>
    8000778e:	87aa                	mv	a5,a0
    80007790:	0007871b          	sext.w	a4,a5
    80007794:	fe842783          	lw	a5,-24(s0)
    80007798:	2781                	sext.w	a5,a5
    8000779a:	00e78463          	beq	a5,a4,800077a2 <loadseg+0xc4>
      return -1;
    8000779e:	57fd                	li	a5,-1
    800077a0:	a015                	j	800077c4 <loadseg+0xe6>
  for(i = 0; i < sz; i += PGSIZE){
    800077a2:	fec42783          	lw	a5,-20(s0)
    800077a6:	873e                	mv	a4,a5
    800077a8:	6785                	lui	a5,0x1
    800077aa:	9fb9                	addw	a5,a5,a4
    800077ac:	fef42623          	sw	a5,-20(s0)
    800077b0:	fec42783          	lw	a5,-20(s0)
    800077b4:	873e                	mv	a4,a5
    800077b6:	fc042783          	lw	a5,-64(s0)
    800077ba:	2701                	sext.w	a4,a4
    800077bc:	2781                	sext.w	a5,a5
    800077be:	f4f763e3          	bltu	a4,a5,80007704 <loadseg+0x26>
  }
  
  return 0;
    800077c2:	4781                	li	a5,0
}
    800077c4:	853e                	mv	a0,a5
    800077c6:	70e2                	ld	ra,56(sp)
    800077c8:	7442                	ld	s0,48(sp)
    800077ca:	6121                	addi	sp,sp,64
    800077cc:	8082                	ret

00000000800077ce <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800077ce:	7139                	addi	sp,sp,-64
    800077d0:	fc06                	sd	ra,56(sp)
    800077d2:	f822                	sd	s0,48(sp)
    800077d4:	0080                	addi	s0,sp,64
    800077d6:	87aa                	mv	a5,a0
    800077d8:	fcb43823          	sd	a1,-48(s0)
    800077dc:	fcc43423          	sd	a2,-56(s0)
    800077e0:	fcf42e23          	sw	a5,-36(s0)
  int fd;
  struct file *f;

  argint(n, &fd);
    800077e4:	fe440713          	addi	a4,s0,-28
    800077e8:	fdc42783          	lw	a5,-36(s0)
    800077ec:	85ba                	mv	a1,a4
    800077ee:	853e                	mv	a0,a5
    800077f0:	ffffd097          	auipc	ra,0xffffd
    800077f4:	976080e7          	jalr	-1674(ra) # 80004166 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800077f8:	fe442783          	lw	a5,-28(s0)
    800077fc:	0207c863          	bltz	a5,8000782c <argfd+0x5e>
    80007800:	fe442783          	lw	a5,-28(s0)
    80007804:	873e                	mv	a4,a5
    80007806:	47bd                	li	a5,15
    80007808:	02e7c263          	blt	a5,a4,8000782c <argfd+0x5e>
    8000780c:	ffffb097          	auipc	ra,0xffffb
    80007810:	03a080e7          	jalr	58(ra) # 80002846 <myproc>
    80007814:	872a                	mv	a4,a0
    80007816:	fe442783          	lw	a5,-28(s0)
    8000781a:	07e9                	addi	a5,a5,26 # 101a <_entry-0x7fffefe6>
    8000781c:	078e                	slli	a5,a5,0x3
    8000781e:	97ba                	add	a5,a5,a4
    80007820:	639c                	ld	a5,0(a5)
    80007822:	fef43423          	sd	a5,-24(s0)
    80007826:	fe843783          	ld	a5,-24(s0)
    8000782a:	e399                	bnez	a5,80007830 <argfd+0x62>
    return -1;
    8000782c:	57fd                	li	a5,-1
    8000782e:	a015                	j	80007852 <argfd+0x84>
  if(pfd)
    80007830:	fd043783          	ld	a5,-48(s0)
    80007834:	c791                	beqz	a5,80007840 <argfd+0x72>
    *pfd = fd;
    80007836:	fe442703          	lw	a4,-28(s0)
    8000783a:	fd043783          	ld	a5,-48(s0)
    8000783e:	c398                	sw	a4,0(a5)
  if(pf)
    80007840:	fc843783          	ld	a5,-56(s0)
    80007844:	c791                	beqz	a5,80007850 <argfd+0x82>
    *pf = f;
    80007846:	fc843783          	ld	a5,-56(s0)
    8000784a:	fe843703          	ld	a4,-24(s0)
    8000784e:	e398                	sd	a4,0(a5)
  return 0;
    80007850:	4781                	li	a5,0
}
    80007852:	853e                	mv	a0,a5
    80007854:	70e2                	ld	ra,56(sp)
    80007856:	7442                	ld	s0,48(sp)
    80007858:	6121                	addi	sp,sp,64
    8000785a:	8082                	ret

000000008000785c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000785c:	7179                	addi	sp,sp,-48
    8000785e:	f406                	sd	ra,40(sp)
    80007860:	f022                	sd	s0,32(sp)
    80007862:	1800                	addi	s0,sp,48
    80007864:	fca43c23          	sd	a0,-40(s0)
  int fd;
  struct proc *p = myproc();
    80007868:	ffffb097          	auipc	ra,0xffffb
    8000786c:	fde080e7          	jalr	-34(ra) # 80002846 <myproc>
    80007870:	fea43023          	sd	a0,-32(s0)

  for(fd = 0; fd < NOFILE; fd++){
    80007874:	fe042623          	sw	zero,-20(s0)
    80007878:	a825                	j	800078b0 <fdalloc+0x54>
    if(p->ofile[fd] == 0){
    8000787a:	fe043703          	ld	a4,-32(s0)
    8000787e:	fec42783          	lw	a5,-20(s0)
    80007882:	07e9                	addi	a5,a5,26
    80007884:	078e                	slli	a5,a5,0x3
    80007886:	97ba                	add	a5,a5,a4
    80007888:	639c                	ld	a5,0(a5)
    8000788a:	ef91                	bnez	a5,800078a6 <fdalloc+0x4a>
      p->ofile[fd] = f;
    8000788c:	fe043703          	ld	a4,-32(s0)
    80007890:	fec42783          	lw	a5,-20(s0)
    80007894:	07e9                	addi	a5,a5,26
    80007896:	078e                	slli	a5,a5,0x3
    80007898:	97ba                	add	a5,a5,a4
    8000789a:	fd843703          	ld	a4,-40(s0)
    8000789e:	e398                	sd	a4,0(a5)
      return fd;
    800078a0:	fec42783          	lw	a5,-20(s0)
    800078a4:	a831                	j	800078c0 <fdalloc+0x64>
  for(fd = 0; fd < NOFILE; fd++){
    800078a6:	fec42783          	lw	a5,-20(s0)
    800078aa:	2785                	addiw	a5,a5,1
    800078ac:	fef42623          	sw	a5,-20(s0)
    800078b0:	fec42783          	lw	a5,-20(s0)
    800078b4:	0007871b          	sext.w	a4,a5
    800078b8:	47bd                	li	a5,15
    800078ba:	fce7d0e3          	bge	a5,a4,8000787a <fdalloc+0x1e>
    }
  }
  return -1;
    800078be:	57fd                	li	a5,-1
}
    800078c0:	853e                	mv	a0,a5
    800078c2:	70a2                	ld	ra,40(sp)
    800078c4:	7402                	ld	s0,32(sp)
    800078c6:	6145                	addi	sp,sp,48
    800078c8:	8082                	ret

00000000800078ca <sys_dup>:

uint64
sys_dup(void)
{
    800078ca:	1101                	addi	sp,sp,-32
    800078cc:	ec06                	sd	ra,24(sp)
    800078ce:	e822                	sd	s0,16(sp)
    800078d0:	1000                	addi	s0,sp,32
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    800078d2:	fe040793          	addi	a5,s0,-32
    800078d6:	863e                	mv	a2,a5
    800078d8:	4581                	li	a1,0
    800078da:	4501                	li	a0,0
    800078dc:	00000097          	auipc	ra,0x0
    800078e0:	ef2080e7          	jalr	-270(ra) # 800077ce <argfd>
    800078e4:	87aa                	mv	a5,a0
    800078e6:	0007d463          	bgez	a5,800078ee <sys_dup+0x24>
    return -1;
    800078ea:	57fd                	li	a5,-1
    800078ec:	a81d                	j	80007922 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
    800078ee:	fe043783          	ld	a5,-32(s0)
    800078f2:	853e                	mv	a0,a5
    800078f4:	00000097          	auipc	ra,0x0
    800078f8:	f68080e7          	jalr	-152(ra) # 8000785c <fdalloc>
    800078fc:	87aa                	mv	a5,a0
    800078fe:	fef42623          	sw	a5,-20(s0)
    80007902:	fec42783          	lw	a5,-20(s0)
    80007906:	2781                	sext.w	a5,a5
    80007908:	0007d463          	bgez	a5,80007910 <sys_dup+0x46>
    return -1;
    8000790c:	57fd                	li	a5,-1
    8000790e:	a811                	j	80007922 <sys_dup+0x58>
  filedup(f);
    80007910:	fe043783          	ld	a5,-32(s0)
    80007914:	853e                	mv	a0,a5
    80007916:	fffff097          	auipc	ra,0xfffff
    8000791a:	eba080e7          	jalr	-326(ra) # 800067d0 <filedup>
  return fd;
    8000791e:	fec42783          	lw	a5,-20(s0)
}
    80007922:	853e                	mv	a0,a5
    80007924:	60e2                	ld	ra,24(sp)
    80007926:	6442                	ld	s0,16(sp)
    80007928:	6105                	addi	sp,sp,32
    8000792a:	8082                	ret

000000008000792c <sys_read>:

uint64
sys_read(void)
{
    8000792c:	7179                	addi	sp,sp,-48
    8000792e:	f406                	sd	ra,40(sp)
    80007930:	f022                	sd	s0,32(sp)
    80007932:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    80007934:	fd840793          	addi	a5,s0,-40
    80007938:	85be                	mv	a1,a5
    8000793a:	4505                	li	a0,1
    8000793c:	ffffd097          	auipc	ra,0xffffd
    80007940:	860080e7          	jalr	-1952(ra) # 8000419c <argaddr>
  argint(2, &n);
    80007944:	fe440793          	addi	a5,s0,-28
    80007948:	85be                	mv	a1,a5
    8000794a:	4509                	li	a0,2
    8000794c:	ffffd097          	auipc	ra,0xffffd
    80007950:	81a080e7          	jalr	-2022(ra) # 80004166 <argint>
  if(argfd(0, 0, &f) < 0)
    80007954:	fe840793          	addi	a5,s0,-24
    80007958:	863e                	mv	a2,a5
    8000795a:	4581                	li	a1,0
    8000795c:	4501                	li	a0,0
    8000795e:	00000097          	auipc	ra,0x0
    80007962:	e70080e7          	jalr	-400(ra) # 800077ce <argfd>
    80007966:	87aa                	mv	a5,a0
    80007968:	0007d463          	bgez	a5,80007970 <sys_read+0x44>
    return -1;
    8000796c:	57fd                	li	a5,-1
    8000796e:	a839                	j	8000798c <sys_read+0x60>
  return fileread(f, p, n);
    80007970:	fe843783          	ld	a5,-24(s0)
    80007974:	fd843703          	ld	a4,-40(s0)
    80007978:	fe442683          	lw	a3,-28(s0)
    8000797c:	8636                	mv	a2,a3
    8000797e:	85ba                	mv	a1,a4
    80007980:	853e                	mv	a0,a5
    80007982:	fffff097          	auipc	ra,0xfffff
    80007986:	060080e7          	jalr	96(ra) # 800069e2 <fileread>
    8000798a:	87aa                	mv	a5,a0
}
    8000798c:	853e                	mv	a0,a5
    8000798e:	70a2                	ld	ra,40(sp)
    80007990:	7402                	ld	s0,32(sp)
    80007992:	6145                	addi	sp,sp,48
    80007994:	8082                	ret

0000000080007996 <sys_write>:

uint64
sys_write(void)
{
    80007996:	7179                	addi	sp,sp,-48
    80007998:	f406                	sd	ra,40(sp)
    8000799a:	f022                	sd	s0,32(sp)
    8000799c:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    8000799e:	fd840793          	addi	a5,s0,-40
    800079a2:	85be                	mv	a1,a5
    800079a4:	4505                	li	a0,1
    800079a6:	ffffc097          	auipc	ra,0xffffc
    800079aa:	7f6080e7          	jalr	2038(ra) # 8000419c <argaddr>
  argint(2, &n);
    800079ae:	fe440793          	addi	a5,s0,-28
    800079b2:	85be                	mv	a1,a5
    800079b4:	4509                	li	a0,2
    800079b6:	ffffc097          	auipc	ra,0xffffc
    800079ba:	7b0080e7          	jalr	1968(ra) # 80004166 <argint>
  if(argfd(0, 0, &f) < 0)
    800079be:	fe840793          	addi	a5,s0,-24
    800079c2:	863e                	mv	a2,a5
    800079c4:	4581                	li	a1,0
    800079c6:	4501                	li	a0,0
    800079c8:	00000097          	auipc	ra,0x0
    800079cc:	e06080e7          	jalr	-506(ra) # 800077ce <argfd>
    800079d0:	87aa                	mv	a5,a0
    800079d2:	0007d463          	bgez	a5,800079da <sys_write+0x44>
    return -1;
    800079d6:	57fd                	li	a5,-1
    800079d8:	a839                	j	800079f6 <sys_write+0x60>

  return filewrite(f, p, n);
    800079da:	fe843783          	ld	a5,-24(s0)
    800079de:	fd843703          	ld	a4,-40(s0)
    800079e2:	fe442683          	lw	a3,-28(s0)
    800079e6:	8636                	mv	a2,a3
    800079e8:	85ba                	mv	a1,a4
    800079ea:	853e                	mv	a0,a5
    800079ec:	fffff097          	auipc	ra,0xfffff
    800079f0:	154080e7          	jalr	340(ra) # 80006b40 <filewrite>
    800079f4:	87aa                	mv	a5,a0
}
    800079f6:	853e                	mv	a0,a5
    800079f8:	70a2                	ld	ra,40(sp)
    800079fa:	7402                	ld	s0,32(sp)
    800079fc:	6145                	addi	sp,sp,48
    800079fe:	8082                	ret

0000000080007a00 <sys_close>:

uint64
sys_close(void)
{
    80007a00:	1101                	addi	sp,sp,-32
    80007a02:	ec06                	sd	ra,24(sp)
    80007a04:	e822                	sd	s0,16(sp)
    80007a06:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    80007a08:	fe040713          	addi	a4,s0,-32
    80007a0c:	fec40793          	addi	a5,s0,-20
    80007a10:	863a                	mv	a2,a4
    80007a12:	85be                	mv	a1,a5
    80007a14:	4501                	li	a0,0
    80007a16:	00000097          	auipc	ra,0x0
    80007a1a:	db8080e7          	jalr	-584(ra) # 800077ce <argfd>
    80007a1e:	87aa                	mv	a5,a0
    80007a20:	0007d463          	bgez	a5,80007a28 <sys_close+0x28>
    return -1;
    80007a24:	57fd                	li	a5,-1
    80007a26:	a02d                	j	80007a50 <sys_close+0x50>
  myproc()->ofile[fd] = 0;
    80007a28:	ffffb097          	auipc	ra,0xffffb
    80007a2c:	e1e080e7          	jalr	-482(ra) # 80002846 <myproc>
    80007a30:	872a                	mv	a4,a0
    80007a32:	fec42783          	lw	a5,-20(s0)
    80007a36:	07e9                	addi	a5,a5,26
    80007a38:	078e                	slli	a5,a5,0x3
    80007a3a:	97ba                	add	a5,a5,a4
    80007a3c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80007a40:	fe043783          	ld	a5,-32(s0)
    80007a44:	853e                	mv	a0,a5
    80007a46:	fffff097          	auipc	ra,0xfffff
    80007a4a:	df0080e7          	jalr	-528(ra) # 80006836 <fileclose>
  return 0;
    80007a4e:	4781                	li	a5,0
}
    80007a50:	853e                	mv	a0,a5
    80007a52:	60e2                	ld	ra,24(sp)
    80007a54:	6442                	ld	s0,16(sp)
    80007a56:	6105                	addi	sp,sp,32
    80007a58:	8082                	ret

0000000080007a5a <sys_fstat>:

uint64
sys_fstat(void)
{
    80007a5a:	1101                	addi	sp,sp,-32
    80007a5c:	ec06                	sd	ra,24(sp)
    80007a5e:	e822                	sd	s0,16(sp)
    80007a60:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    80007a62:	fe040793          	addi	a5,s0,-32
    80007a66:	85be                	mv	a1,a5
    80007a68:	4505                	li	a0,1
    80007a6a:	ffffc097          	auipc	ra,0xffffc
    80007a6e:	732080e7          	jalr	1842(ra) # 8000419c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80007a72:	fe840793          	addi	a5,s0,-24
    80007a76:	863e                	mv	a2,a5
    80007a78:	4581                	li	a1,0
    80007a7a:	4501                	li	a0,0
    80007a7c:	00000097          	auipc	ra,0x0
    80007a80:	d52080e7          	jalr	-686(ra) # 800077ce <argfd>
    80007a84:	87aa                	mv	a5,a0
    80007a86:	0007d463          	bgez	a5,80007a8e <sys_fstat+0x34>
    return -1;
    80007a8a:	57fd                	li	a5,-1
    80007a8c:	a821                	j	80007aa4 <sys_fstat+0x4a>
  return filestat(f, st);
    80007a8e:	fe843783          	ld	a5,-24(s0)
    80007a92:	fe043703          	ld	a4,-32(s0)
    80007a96:	85ba                	mv	a1,a4
    80007a98:	853e                	mv	a0,a5
    80007a9a:	fffff097          	auipc	ra,0xfffff
    80007a9e:	ea4080e7          	jalr	-348(ra) # 8000693e <filestat>
    80007aa2:	87aa                	mv	a5,a0
}
    80007aa4:	853e                	mv	a0,a5
    80007aa6:	60e2                	ld	ra,24(sp)
    80007aa8:	6442                	ld	s0,16(sp)
    80007aaa:	6105                	addi	sp,sp,32
    80007aac:	8082                	ret

0000000080007aae <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    80007aae:	7169                	addi	sp,sp,-304
    80007ab0:	f606                	sd	ra,296(sp)
    80007ab2:	f222                	sd	s0,288(sp)
    80007ab4:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80007ab6:	ed040793          	addi	a5,s0,-304
    80007aba:	08000613          	li	a2,128
    80007abe:	85be                	mv	a1,a5
    80007ac0:	4501                	li	a0,0
    80007ac2:	ffffc097          	auipc	ra,0xffffc
    80007ac6:	70c080e7          	jalr	1804(ra) # 800041ce <argstr>
    80007aca:	87aa                	mv	a5,a0
    80007acc:	0007cf63          	bltz	a5,80007aea <sys_link+0x3c>
    80007ad0:	f5040793          	addi	a5,s0,-176
    80007ad4:	08000613          	li	a2,128
    80007ad8:	85be                	mv	a1,a5
    80007ada:	4505                	li	a0,1
    80007adc:	ffffc097          	auipc	ra,0xffffc
    80007ae0:	6f2080e7          	jalr	1778(ra) # 800041ce <argstr>
    80007ae4:	87aa                	mv	a5,a0
    80007ae6:	0007d463          	bgez	a5,80007aee <sys_link+0x40>
    return -1;
    80007aea:	57fd                	li	a5,-1
    80007aec:	aaad                	j	80007c66 <sys_link+0x1b8>

  begin_op();
    80007aee:	ffffe097          	auipc	ra,0xffffe
    80007af2:	6ae080e7          	jalr	1710(ra) # 8000619c <begin_op>
  if((ip = namei(old)) == 0){
    80007af6:	ed040793          	addi	a5,s0,-304
    80007afa:	853e                	mv	a0,a5
    80007afc:	ffffe097          	auipc	ra,0xffffe
    80007b00:	33c080e7          	jalr	828(ra) # 80005e38 <namei>
    80007b04:	fea43423          	sd	a0,-24(s0)
    80007b08:	fe843783          	ld	a5,-24(s0)
    80007b0c:	e799                	bnez	a5,80007b1a <sys_link+0x6c>
    end_op();
    80007b0e:	ffffe097          	auipc	ra,0xffffe
    80007b12:	750080e7          	jalr	1872(ra) # 8000625e <end_op>
    return -1;
    80007b16:	57fd                	li	a5,-1
    80007b18:	a2b9                	j	80007c66 <sys_link+0x1b8>
  }

  ilock(ip);
    80007b1a:	fe843503          	ld	a0,-24(s0)
    80007b1e:	ffffd097          	auipc	ra,0xffffd
    80007b22:	5ea080e7          	jalr	1514(ra) # 80005108 <ilock>
  if(ip->type == T_DIR){
    80007b26:	fe843783          	ld	a5,-24(s0)
    80007b2a:	04479783          	lh	a5,68(a5)
    80007b2e:	873e                	mv	a4,a5
    80007b30:	4785                	li	a5,1
    80007b32:	00f71e63          	bne	a4,a5,80007b4e <sys_link+0xa0>
    iunlockput(ip);
    80007b36:	fe843503          	ld	a0,-24(s0)
    80007b3a:	ffffe097          	auipc	ra,0xffffe
    80007b3e:	82c080e7          	jalr	-2004(ra) # 80005366 <iunlockput>
    end_op();
    80007b42:	ffffe097          	auipc	ra,0xffffe
    80007b46:	71c080e7          	jalr	1820(ra) # 8000625e <end_op>
    return -1;
    80007b4a:	57fd                	li	a5,-1
    80007b4c:	aa29                	j	80007c66 <sys_link+0x1b8>
  }

  ip->nlink++;
    80007b4e:	fe843783          	ld	a5,-24(s0)
    80007b52:	04a79783          	lh	a5,74(a5)
    80007b56:	17c2                	slli	a5,a5,0x30
    80007b58:	93c1                	srli	a5,a5,0x30
    80007b5a:	2785                	addiw	a5,a5,1
    80007b5c:	17c2                	slli	a5,a5,0x30
    80007b5e:	93c1                	srli	a5,a5,0x30
    80007b60:	0107971b          	slliw	a4,a5,0x10
    80007b64:	4107571b          	sraiw	a4,a4,0x10
    80007b68:	fe843783          	ld	a5,-24(s0)
    80007b6c:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007b70:	fe843503          	ld	a0,-24(s0)
    80007b74:	ffffd097          	auipc	ra,0xffffd
    80007b78:	344080e7          	jalr	836(ra) # 80004eb8 <iupdate>
  iunlock(ip);
    80007b7c:	fe843503          	ld	a0,-24(s0)
    80007b80:	ffffd097          	auipc	ra,0xffffd
    80007b84:	6bc080e7          	jalr	1724(ra) # 8000523c <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80007b88:	fd040713          	addi	a4,s0,-48
    80007b8c:	f5040793          	addi	a5,s0,-176
    80007b90:	85ba                	mv	a1,a4
    80007b92:	853e                	mv	a0,a5
    80007b94:	ffffe097          	auipc	ra,0xffffe
    80007b98:	2d0080e7          	jalr	720(ra) # 80005e64 <nameiparent>
    80007b9c:	fea43023          	sd	a0,-32(s0)
    80007ba0:	fe043783          	ld	a5,-32(s0)
    80007ba4:	cba5                	beqz	a5,80007c14 <sys_link+0x166>
    goto bad;
  ilock(dp);
    80007ba6:	fe043503          	ld	a0,-32(s0)
    80007baa:	ffffd097          	auipc	ra,0xffffd
    80007bae:	55e080e7          	jalr	1374(ra) # 80005108 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80007bb2:	fe043783          	ld	a5,-32(s0)
    80007bb6:	4398                	lw	a4,0(a5)
    80007bb8:	fe843783          	ld	a5,-24(s0)
    80007bbc:	439c                	lw	a5,0(a5)
    80007bbe:	02f71263          	bne	a4,a5,80007be2 <sys_link+0x134>
    80007bc2:	fe843783          	ld	a5,-24(s0)
    80007bc6:	43d8                	lw	a4,4(a5)
    80007bc8:	fd040793          	addi	a5,s0,-48
    80007bcc:	863a                	mv	a2,a4
    80007bce:	85be                	mv	a1,a5
    80007bd0:	fe043503          	ld	a0,-32(s0)
    80007bd4:	ffffe097          	auipc	ra,0xffffe
    80007bd8:	f58080e7          	jalr	-168(ra) # 80005b2c <dirlink>
    80007bdc:	87aa                	mv	a5,a0
    80007bde:	0007d963          	bgez	a5,80007bf0 <sys_link+0x142>
    iunlockput(dp);
    80007be2:	fe043503          	ld	a0,-32(s0)
    80007be6:	ffffd097          	auipc	ra,0xffffd
    80007bea:	780080e7          	jalr	1920(ra) # 80005366 <iunlockput>
    goto bad;
    80007bee:	a025                	j	80007c16 <sys_link+0x168>
  }
  iunlockput(dp);
    80007bf0:	fe043503          	ld	a0,-32(s0)
    80007bf4:	ffffd097          	auipc	ra,0xffffd
    80007bf8:	772080e7          	jalr	1906(ra) # 80005366 <iunlockput>
  iput(ip);
    80007bfc:	fe843503          	ld	a0,-24(s0)
    80007c00:	ffffd097          	auipc	ra,0xffffd
    80007c04:	696080e7          	jalr	1686(ra) # 80005296 <iput>

  end_op();
    80007c08:	ffffe097          	auipc	ra,0xffffe
    80007c0c:	656080e7          	jalr	1622(ra) # 8000625e <end_op>

  return 0;
    80007c10:	4781                	li	a5,0
    80007c12:	a891                	j	80007c66 <sys_link+0x1b8>
    goto bad;
    80007c14:	0001                	nop

bad:
  ilock(ip);
    80007c16:	fe843503          	ld	a0,-24(s0)
    80007c1a:	ffffd097          	auipc	ra,0xffffd
    80007c1e:	4ee080e7          	jalr	1262(ra) # 80005108 <ilock>
  ip->nlink--;
    80007c22:	fe843783          	ld	a5,-24(s0)
    80007c26:	04a79783          	lh	a5,74(a5)
    80007c2a:	17c2                	slli	a5,a5,0x30
    80007c2c:	93c1                	srli	a5,a5,0x30
    80007c2e:	37fd                	addiw	a5,a5,-1
    80007c30:	17c2                	slli	a5,a5,0x30
    80007c32:	93c1                	srli	a5,a5,0x30
    80007c34:	0107971b          	slliw	a4,a5,0x10
    80007c38:	4107571b          	sraiw	a4,a4,0x10
    80007c3c:	fe843783          	ld	a5,-24(s0)
    80007c40:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007c44:	fe843503          	ld	a0,-24(s0)
    80007c48:	ffffd097          	auipc	ra,0xffffd
    80007c4c:	270080e7          	jalr	624(ra) # 80004eb8 <iupdate>
  iunlockput(ip);
    80007c50:	fe843503          	ld	a0,-24(s0)
    80007c54:	ffffd097          	auipc	ra,0xffffd
    80007c58:	712080e7          	jalr	1810(ra) # 80005366 <iunlockput>
  end_op();
    80007c5c:	ffffe097          	auipc	ra,0xffffe
    80007c60:	602080e7          	jalr	1538(ra) # 8000625e <end_op>
  return -1;
    80007c64:	57fd                	li	a5,-1
}
    80007c66:	853e                	mv	a0,a5
    80007c68:	70b2                	ld	ra,296(sp)
    80007c6a:	7412                	ld	s0,288(sp)
    80007c6c:	6155                	addi	sp,sp,304
    80007c6e:	8082                	ret

0000000080007c70 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
    80007c70:	7139                	addi	sp,sp,-64
    80007c72:	fc06                	sd	ra,56(sp)
    80007c74:	f822                	sd	s0,48(sp)
    80007c76:	0080                	addi	s0,sp,64
    80007c78:	fca43423          	sd	a0,-56(s0)
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007c7c:	02000793          	li	a5,32
    80007c80:	fef42623          	sw	a5,-20(s0)
    80007c84:	a0b1                	j	80007cd0 <isdirempty+0x60>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007c86:	fd840793          	addi	a5,s0,-40
    80007c8a:	fec42683          	lw	a3,-20(s0)
    80007c8e:	4741                	li	a4,16
    80007c90:	863e                	mv	a2,a5
    80007c92:	4581                	li	a1,0
    80007c94:	fc843503          	ld	a0,-56(s0)
    80007c98:	ffffe097          	auipc	ra,0xffffe
    80007c9c:	a26080e7          	jalr	-1498(ra) # 800056be <readi>
    80007ca0:	87aa                	mv	a5,a0
    80007ca2:	873e                	mv	a4,a5
    80007ca4:	47c1                	li	a5,16
    80007ca6:	00f70a63          	beq	a4,a5,80007cba <isdirempty+0x4a>
      panic("isdirempty: readi");
    80007caa:	00004517          	auipc	a0,0x4
    80007cae:	96e50513          	addi	a0,a0,-1682 # 8000b618 <etext+0x618>
    80007cb2:	ffff9097          	auipc	ra,0xffff9
    80007cb6:	fd8080e7          	jalr	-40(ra) # 80000c8a <panic>
    if(de.inum != 0)
    80007cba:	fd845783          	lhu	a5,-40(s0)
    80007cbe:	c399                	beqz	a5,80007cc4 <isdirempty+0x54>
      return 0;
    80007cc0:	4781                	li	a5,0
    80007cc2:	a839                	j	80007ce0 <isdirempty+0x70>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80007cc4:	fec42783          	lw	a5,-20(s0)
    80007cc8:	27c1                	addiw	a5,a5,16
    80007cca:	2781                	sext.w	a5,a5
    80007ccc:	fef42623          	sw	a5,-20(s0)
    80007cd0:	fc843783          	ld	a5,-56(s0)
    80007cd4:	47f8                	lw	a4,76(a5)
    80007cd6:	fec42783          	lw	a5,-20(s0)
    80007cda:	fae7e6e3          	bltu	a5,a4,80007c86 <isdirempty+0x16>
  }
  return 1;
    80007cde:	4785                	li	a5,1
}
    80007ce0:	853e                	mv	a0,a5
    80007ce2:	70e2                	ld	ra,56(sp)
    80007ce4:	7442                	ld	s0,48(sp)
    80007ce6:	6121                	addi	sp,sp,64
    80007ce8:	8082                	ret

0000000080007cea <sys_unlink>:

uint64
sys_unlink(void)
{
    80007cea:	7155                	addi	sp,sp,-208
    80007cec:	e586                	sd	ra,200(sp)
    80007cee:	e1a2                	sd	s0,192(sp)
    80007cf0:	0980                	addi	s0,sp,208
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80007cf2:	f4040793          	addi	a5,s0,-192
    80007cf6:	08000613          	li	a2,128
    80007cfa:	85be                	mv	a1,a5
    80007cfc:	4501                	li	a0,0
    80007cfe:	ffffc097          	auipc	ra,0xffffc
    80007d02:	4d0080e7          	jalr	1232(ra) # 800041ce <argstr>
    80007d06:	87aa                	mv	a5,a0
    80007d08:	0007d463          	bgez	a5,80007d10 <sys_unlink+0x26>
    return -1;
    80007d0c:	57fd                	li	a5,-1
    80007d0e:	a2d5                	j	80007ef2 <sys_unlink+0x208>

  begin_op();
    80007d10:	ffffe097          	auipc	ra,0xffffe
    80007d14:	48c080e7          	jalr	1164(ra) # 8000619c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80007d18:	fc040713          	addi	a4,s0,-64
    80007d1c:	f4040793          	addi	a5,s0,-192
    80007d20:	85ba                	mv	a1,a4
    80007d22:	853e                	mv	a0,a5
    80007d24:	ffffe097          	auipc	ra,0xffffe
    80007d28:	140080e7          	jalr	320(ra) # 80005e64 <nameiparent>
    80007d2c:	fea43423          	sd	a0,-24(s0)
    80007d30:	fe843783          	ld	a5,-24(s0)
    80007d34:	e799                	bnez	a5,80007d42 <sys_unlink+0x58>
    end_op();
    80007d36:	ffffe097          	auipc	ra,0xffffe
    80007d3a:	528080e7          	jalr	1320(ra) # 8000625e <end_op>
    return -1;
    80007d3e:	57fd                	li	a5,-1
    80007d40:	aa4d                	j	80007ef2 <sys_unlink+0x208>
  }

  ilock(dp);
    80007d42:	fe843503          	ld	a0,-24(s0)
    80007d46:	ffffd097          	auipc	ra,0xffffd
    80007d4a:	3c2080e7          	jalr	962(ra) # 80005108 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80007d4e:	fc040793          	addi	a5,s0,-64
    80007d52:	00004597          	auipc	a1,0x4
    80007d56:	8de58593          	addi	a1,a1,-1826 # 8000b630 <etext+0x630>
    80007d5a:	853e                	mv	a0,a5
    80007d5c:	ffffe097          	auipc	ra,0xffffe
    80007d60:	cbc080e7          	jalr	-836(ra) # 80005a18 <namecmp>
    80007d64:	87aa                	mv	a5,a0
    80007d66:	16078863          	beqz	a5,80007ed6 <sys_unlink+0x1ec>
    80007d6a:	fc040793          	addi	a5,s0,-64
    80007d6e:	00004597          	auipc	a1,0x4
    80007d72:	8ca58593          	addi	a1,a1,-1846 # 8000b638 <etext+0x638>
    80007d76:	853e                	mv	a0,a5
    80007d78:	ffffe097          	auipc	ra,0xffffe
    80007d7c:	ca0080e7          	jalr	-864(ra) # 80005a18 <namecmp>
    80007d80:	87aa                	mv	a5,a0
    80007d82:	14078a63          	beqz	a5,80007ed6 <sys_unlink+0x1ec>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80007d86:	f3c40713          	addi	a4,s0,-196
    80007d8a:	fc040793          	addi	a5,s0,-64
    80007d8e:	863a                	mv	a2,a4
    80007d90:	85be                	mv	a1,a5
    80007d92:	fe843503          	ld	a0,-24(s0)
    80007d96:	ffffe097          	auipc	ra,0xffffe
    80007d9a:	cb0080e7          	jalr	-848(ra) # 80005a46 <dirlookup>
    80007d9e:	fea43023          	sd	a0,-32(s0)
    80007da2:	fe043783          	ld	a5,-32(s0)
    80007da6:	12078a63          	beqz	a5,80007eda <sys_unlink+0x1f0>
    goto bad;
  ilock(ip);
    80007daa:	fe043503          	ld	a0,-32(s0)
    80007dae:	ffffd097          	auipc	ra,0xffffd
    80007db2:	35a080e7          	jalr	858(ra) # 80005108 <ilock>

  if(ip->nlink < 1)
    80007db6:	fe043783          	ld	a5,-32(s0)
    80007dba:	04a79783          	lh	a5,74(a5)
    80007dbe:	00f04a63          	bgtz	a5,80007dd2 <sys_unlink+0xe8>
    panic("unlink: nlink < 1");
    80007dc2:	00004517          	auipc	a0,0x4
    80007dc6:	87e50513          	addi	a0,a0,-1922 # 8000b640 <etext+0x640>
    80007dca:	ffff9097          	auipc	ra,0xffff9
    80007dce:	ec0080e7          	jalr	-320(ra) # 80000c8a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80007dd2:	fe043783          	ld	a5,-32(s0)
    80007dd6:	04479783          	lh	a5,68(a5)
    80007dda:	873e                	mv	a4,a5
    80007ddc:	4785                	li	a5,1
    80007dde:	02f71163          	bne	a4,a5,80007e00 <sys_unlink+0x116>
    80007de2:	fe043503          	ld	a0,-32(s0)
    80007de6:	00000097          	auipc	ra,0x0
    80007dea:	e8a080e7          	jalr	-374(ra) # 80007c70 <isdirempty>
    80007dee:	87aa                	mv	a5,a0
    80007df0:	eb81                	bnez	a5,80007e00 <sys_unlink+0x116>
    iunlockput(ip);
    80007df2:	fe043503          	ld	a0,-32(s0)
    80007df6:	ffffd097          	auipc	ra,0xffffd
    80007dfa:	570080e7          	jalr	1392(ra) # 80005366 <iunlockput>
    goto bad;
    80007dfe:	a8f9                	j	80007edc <sys_unlink+0x1f2>
  }

  memset(&de, 0, sizeof(de));
    80007e00:	fd040793          	addi	a5,s0,-48
    80007e04:	4641                	li	a2,16
    80007e06:	4581                	li	a1,0
    80007e08:	853e                	mv	a0,a5
    80007e0a:	ffff9097          	auipc	ra,0xffff9
    80007e0e:	648080e7          	jalr	1608(ra) # 80001452 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80007e12:	fd040793          	addi	a5,s0,-48
    80007e16:	f3c42683          	lw	a3,-196(s0)
    80007e1a:	4741                	li	a4,16
    80007e1c:	863e                	mv	a2,a5
    80007e1e:	4581                	li	a1,0
    80007e20:	fe843503          	ld	a0,-24(s0)
    80007e24:	ffffe097          	auipc	ra,0xffffe
    80007e28:	a38080e7          	jalr	-1480(ra) # 8000585c <writei>
    80007e2c:	87aa                	mv	a5,a0
    80007e2e:	873e                	mv	a4,a5
    80007e30:	47c1                	li	a5,16
    80007e32:	00f70a63          	beq	a4,a5,80007e46 <sys_unlink+0x15c>
    panic("unlink: writei");
    80007e36:	00004517          	auipc	a0,0x4
    80007e3a:	82250513          	addi	a0,a0,-2014 # 8000b658 <etext+0x658>
    80007e3e:	ffff9097          	auipc	ra,0xffff9
    80007e42:	e4c080e7          	jalr	-436(ra) # 80000c8a <panic>
  if(ip->type == T_DIR){
    80007e46:	fe043783          	ld	a5,-32(s0)
    80007e4a:	04479783          	lh	a5,68(a5)
    80007e4e:	873e                	mv	a4,a5
    80007e50:	4785                	li	a5,1
    80007e52:	02f71963          	bne	a4,a5,80007e84 <sys_unlink+0x19a>
    dp->nlink--;
    80007e56:	fe843783          	ld	a5,-24(s0)
    80007e5a:	04a79783          	lh	a5,74(a5)
    80007e5e:	17c2                	slli	a5,a5,0x30
    80007e60:	93c1                	srli	a5,a5,0x30
    80007e62:	37fd                	addiw	a5,a5,-1
    80007e64:	17c2                	slli	a5,a5,0x30
    80007e66:	93c1                	srli	a5,a5,0x30
    80007e68:	0107971b          	slliw	a4,a5,0x10
    80007e6c:	4107571b          	sraiw	a4,a4,0x10
    80007e70:	fe843783          	ld	a5,-24(s0)
    80007e74:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    80007e78:	fe843503          	ld	a0,-24(s0)
    80007e7c:	ffffd097          	auipc	ra,0xffffd
    80007e80:	03c080e7          	jalr	60(ra) # 80004eb8 <iupdate>
  }
  iunlockput(dp);
    80007e84:	fe843503          	ld	a0,-24(s0)
    80007e88:	ffffd097          	auipc	ra,0xffffd
    80007e8c:	4de080e7          	jalr	1246(ra) # 80005366 <iunlockput>

  ip->nlink--;
    80007e90:	fe043783          	ld	a5,-32(s0)
    80007e94:	04a79783          	lh	a5,74(a5)
    80007e98:	17c2                	slli	a5,a5,0x30
    80007e9a:	93c1                	srli	a5,a5,0x30
    80007e9c:	37fd                	addiw	a5,a5,-1
    80007e9e:	17c2                	slli	a5,a5,0x30
    80007ea0:	93c1                	srli	a5,a5,0x30
    80007ea2:	0107971b          	slliw	a4,a5,0x10
    80007ea6:	4107571b          	sraiw	a4,a4,0x10
    80007eaa:	fe043783          	ld	a5,-32(s0)
    80007eae:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80007eb2:	fe043503          	ld	a0,-32(s0)
    80007eb6:	ffffd097          	auipc	ra,0xffffd
    80007eba:	002080e7          	jalr	2(ra) # 80004eb8 <iupdate>
  iunlockput(ip);
    80007ebe:	fe043503          	ld	a0,-32(s0)
    80007ec2:	ffffd097          	auipc	ra,0xffffd
    80007ec6:	4a4080e7          	jalr	1188(ra) # 80005366 <iunlockput>

  end_op();
    80007eca:	ffffe097          	auipc	ra,0xffffe
    80007ece:	394080e7          	jalr	916(ra) # 8000625e <end_op>

  return 0;
    80007ed2:	4781                	li	a5,0
    80007ed4:	a839                	j	80007ef2 <sys_unlink+0x208>
    goto bad;
    80007ed6:	0001                	nop
    80007ed8:	a011                	j	80007edc <sys_unlink+0x1f2>
    goto bad;
    80007eda:	0001                	nop

bad:
  iunlockput(dp);
    80007edc:	fe843503          	ld	a0,-24(s0)
    80007ee0:	ffffd097          	auipc	ra,0xffffd
    80007ee4:	486080e7          	jalr	1158(ra) # 80005366 <iunlockput>
  end_op();
    80007ee8:	ffffe097          	auipc	ra,0xffffe
    80007eec:	376080e7          	jalr	886(ra) # 8000625e <end_op>
  return -1;
    80007ef0:	57fd                	li	a5,-1
}
    80007ef2:	853e                	mv	a0,a5
    80007ef4:	60ae                	ld	ra,200(sp)
    80007ef6:	640e                	ld	s0,192(sp)
    80007ef8:	6169                	addi	sp,sp,208
    80007efa:	8082                	ret

0000000080007efc <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
    80007efc:	7139                	addi	sp,sp,-64
    80007efe:	fc06                	sd	ra,56(sp)
    80007f00:	f822                	sd	s0,48(sp)
    80007f02:	0080                	addi	s0,sp,64
    80007f04:	fca43423          	sd	a0,-56(s0)
    80007f08:	87ae                	mv	a5,a1
    80007f0a:	8736                	mv	a4,a3
    80007f0c:	fcf41323          	sh	a5,-58(s0)
    80007f10:	87b2                	mv	a5,a2
    80007f12:	fcf41223          	sh	a5,-60(s0)
    80007f16:	87ba                	mv	a5,a4
    80007f18:	fcf41123          	sh	a5,-62(s0)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80007f1c:	fd040793          	addi	a5,s0,-48
    80007f20:	85be                	mv	a1,a5
    80007f22:	fc843503          	ld	a0,-56(s0)
    80007f26:	ffffe097          	auipc	ra,0xffffe
    80007f2a:	f3e080e7          	jalr	-194(ra) # 80005e64 <nameiparent>
    80007f2e:	fea43423          	sd	a0,-24(s0)
    80007f32:	fe843783          	ld	a5,-24(s0)
    80007f36:	e399                	bnez	a5,80007f3c <create+0x40>
    return 0;
    80007f38:	4781                	li	a5,0
    80007f3a:	a2dd                	j	80008120 <create+0x224>

  ilock(dp);
    80007f3c:	fe843503          	ld	a0,-24(s0)
    80007f40:	ffffd097          	auipc	ra,0xffffd
    80007f44:	1c8080e7          	jalr	456(ra) # 80005108 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80007f48:	fd040793          	addi	a5,s0,-48
    80007f4c:	4601                	li	a2,0
    80007f4e:	85be                	mv	a1,a5
    80007f50:	fe843503          	ld	a0,-24(s0)
    80007f54:	ffffe097          	auipc	ra,0xffffe
    80007f58:	af2080e7          	jalr	-1294(ra) # 80005a46 <dirlookup>
    80007f5c:	fea43023          	sd	a0,-32(s0)
    80007f60:	fe043783          	ld	a5,-32(s0)
    80007f64:	cfb9                	beqz	a5,80007fc2 <create+0xc6>
    iunlockput(dp);
    80007f66:	fe843503          	ld	a0,-24(s0)
    80007f6a:	ffffd097          	auipc	ra,0xffffd
    80007f6e:	3fc080e7          	jalr	1020(ra) # 80005366 <iunlockput>
    ilock(ip);
    80007f72:	fe043503          	ld	a0,-32(s0)
    80007f76:	ffffd097          	auipc	ra,0xffffd
    80007f7a:	192080e7          	jalr	402(ra) # 80005108 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80007f7e:	fc641783          	lh	a5,-58(s0)
    80007f82:	0007871b          	sext.w	a4,a5
    80007f86:	4789                	li	a5,2
    80007f88:	02f71563          	bne	a4,a5,80007fb2 <create+0xb6>
    80007f8c:	fe043783          	ld	a5,-32(s0)
    80007f90:	04479783          	lh	a5,68(a5)
    80007f94:	873e                	mv	a4,a5
    80007f96:	4789                	li	a5,2
    80007f98:	00f70a63          	beq	a4,a5,80007fac <create+0xb0>
    80007f9c:	fe043783          	ld	a5,-32(s0)
    80007fa0:	04479783          	lh	a5,68(a5)
    80007fa4:	873e                	mv	a4,a5
    80007fa6:	478d                	li	a5,3
    80007fa8:	00f71563          	bne	a4,a5,80007fb2 <create+0xb6>
      return ip;
    80007fac:	fe043783          	ld	a5,-32(s0)
    80007fb0:	aa85                	j	80008120 <create+0x224>
    iunlockput(ip);
    80007fb2:	fe043503          	ld	a0,-32(s0)
    80007fb6:	ffffd097          	auipc	ra,0xffffd
    80007fba:	3b0080e7          	jalr	944(ra) # 80005366 <iunlockput>
    return 0;
    80007fbe:	4781                	li	a5,0
    80007fc0:	a285                	j	80008120 <create+0x224>
  }

  if((ip = ialloc(dp->dev, type)) == 0){
    80007fc2:	fe843783          	ld	a5,-24(s0)
    80007fc6:	439c                	lw	a5,0(a5)
    80007fc8:	fc641703          	lh	a4,-58(s0)
    80007fcc:	85ba                	mv	a1,a4
    80007fce:	853e                	mv	a0,a5
    80007fd0:	ffffd097          	auipc	ra,0xffffd
    80007fd4:	dea080e7          	jalr	-534(ra) # 80004dba <ialloc>
    80007fd8:	fea43023          	sd	a0,-32(s0)
    80007fdc:	fe043783          	ld	a5,-32(s0)
    80007fe0:	eb89                	bnez	a5,80007ff2 <create+0xf6>
    iunlockput(dp);
    80007fe2:	fe843503          	ld	a0,-24(s0)
    80007fe6:	ffffd097          	auipc	ra,0xffffd
    80007fea:	380080e7          	jalr	896(ra) # 80005366 <iunlockput>
    return 0;
    80007fee:	4781                	li	a5,0
    80007ff0:	aa05                	j	80008120 <create+0x224>
  }

  ilock(ip);
    80007ff2:	fe043503          	ld	a0,-32(s0)
    80007ff6:	ffffd097          	auipc	ra,0xffffd
    80007ffa:	112080e7          	jalr	274(ra) # 80005108 <ilock>
  ip->major = major;
    80007ffe:	fe043783          	ld	a5,-32(s0)
    80008002:	fc445703          	lhu	a4,-60(s0)
    80008006:	04e79323          	sh	a4,70(a5)
  ip->minor = minor;
    8000800a:	fe043783          	ld	a5,-32(s0)
    8000800e:	fc245703          	lhu	a4,-62(s0)
    80008012:	04e79423          	sh	a4,72(a5)
  ip->nlink = 1;
    80008016:	fe043783          	ld	a5,-32(s0)
    8000801a:	4705                	li	a4,1
    8000801c:	04e79523          	sh	a4,74(a5)
  iupdate(ip);
    80008020:	fe043503          	ld	a0,-32(s0)
    80008024:	ffffd097          	auipc	ra,0xffffd
    80008028:	e94080e7          	jalr	-364(ra) # 80004eb8 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
    8000802c:	fc641783          	lh	a5,-58(s0)
    80008030:	0007871b          	sext.w	a4,a5
    80008034:	4785                	li	a5,1
    80008036:	04f71463          	bne	a4,a5,8000807e <create+0x182>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000803a:	fe043783          	ld	a5,-32(s0)
    8000803e:	43dc                	lw	a5,4(a5)
    80008040:	863e                	mv	a2,a5
    80008042:	00003597          	auipc	a1,0x3
    80008046:	5ee58593          	addi	a1,a1,1518 # 8000b630 <etext+0x630>
    8000804a:	fe043503          	ld	a0,-32(s0)
    8000804e:	ffffe097          	auipc	ra,0xffffe
    80008052:	ade080e7          	jalr	-1314(ra) # 80005b2c <dirlink>
    80008056:	87aa                	mv	a5,a0
    80008058:	0807ca63          	bltz	a5,800080ec <create+0x1f0>
    8000805c:	fe843783          	ld	a5,-24(s0)
    80008060:	43dc                	lw	a5,4(a5)
    80008062:	863e                	mv	a2,a5
    80008064:	00003597          	auipc	a1,0x3
    80008068:	5d458593          	addi	a1,a1,1492 # 8000b638 <etext+0x638>
    8000806c:	fe043503          	ld	a0,-32(s0)
    80008070:	ffffe097          	auipc	ra,0xffffe
    80008074:	abc080e7          	jalr	-1348(ra) # 80005b2c <dirlink>
    80008078:	87aa                	mv	a5,a0
    8000807a:	0607c963          	bltz	a5,800080ec <create+0x1f0>
      goto fail;
  }

  if(dirlink(dp, name, ip->inum) < 0)
    8000807e:	fe043783          	ld	a5,-32(s0)
    80008082:	43d8                	lw	a4,4(a5)
    80008084:	fd040793          	addi	a5,s0,-48
    80008088:	863a                	mv	a2,a4
    8000808a:	85be                	mv	a1,a5
    8000808c:	fe843503          	ld	a0,-24(s0)
    80008090:	ffffe097          	auipc	ra,0xffffe
    80008094:	a9c080e7          	jalr	-1380(ra) # 80005b2c <dirlink>
    80008098:	87aa                	mv	a5,a0
    8000809a:	0407cb63          	bltz	a5,800080f0 <create+0x1f4>
    goto fail;

  if(type == T_DIR){
    8000809e:	fc641783          	lh	a5,-58(s0)
    800080a2:	0007871b          	sext.w	a4,a5
    800080a6:	4785                	li	a5,1
    800080a8:	02f71963          	bne	a4,a5,800080da <create+0x1de>
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    800080ac:	fe843783          	ld	a5,-24(s0)
    800080b0:	04a79783          	lh	a5,74(a5)
    800080b4:	17c2                	slli	a5,a5,0x30
    800080b6:	93c1                	srli	a5,a5,0x30
    800080b8:	2785                	addiw	a5,a5,1
    800080ba:	17c2                	slli	a5,a5,0x30
    800080bc:	93c1                	srli	a5,a5,0x30
    800080be:	0107971b          	slliw	a4,a5,0x10
    800080c2:	4107571b          	sraiw	a4,a4,0x10
    800080c6:	fe843783          	ld	a5,-24(s0)
    800080ca:	04e79523          	sh	a4,74(a5)
    iupdate(dp);
    800080ce:	fe843503          	ld	a0,-24(s0)
    800080d2:	ffffd097          	auipc	ra,0xffffd
    800080d6:	de6080e7          	jalr	-538(ra) # 80004eb8 <iupdate>
  }

  iunlockput(dp);
    800080da:	fe843503          	ld	a0,-24(s0)
    800080de:	ffffd097          	auipc	ra,0xffffd
    800080e2:	288080e7          	jalr	648(ra) # 80005366 <iunlockput>

  return ip;
    800080e6:	fe043783          	ld	a5,-32(s0)
    800080ea:	a81d                	j	80008120 <create+0x224>
      goto fail;
    800080ec:	0001                	nop
    800080ee:	a011                	j	800080f2 <create+0x1f6>
    goto fail;
    800080f0:	0001                	nop

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
    800080f2:	fe043783          	ld	a5,-32(s0)
    800080f6:	04079523          	sh	zero,74(a5)
  iupdate(ip);
    800080fa:	fe043503          	ld	a0,-32(s0)
    800080fe:	ffffd097          	auipc	ra,0xffffd
    80008102:	dba080e7          	jalr	-582(ra) # 80004eb8 <iupdate>
  iunlockput(ip);
    80008106:	fe043503          	ld	a0,-32(s0)
    8000810a:	ffffd097          	auipc	ra,0xffffd
    8000810e:	25c080e7          	jalr	604(ra) # 80005366 <iunlockput>
  iunlockput(dp);
    80008112:	fe843503          	ld	a0,-24(s0)
    80008116:	ffffd097          	auipc	ra,0xffffd
    8000811a:	250080e7          	jalr	592(ra) # 80005366 <iunlockput>
  return 0;
    8000811e:	4781                	li	a5,0
}
    80008120:	853e                	mv	a0,a5
    80008122:	70e2                	ld	ra,56(sp)
    80008124:	7442                	ld	s0,48(sp)
    80008126:	6121                	addi	sp,sp,64
    80008128:	8082                	ret

000000008000812a <sys_open>:

uint64
sys_open(void)
{
    8000812a:	7131                	addi	sp,sp,-192
    8000812c:	fd06                	sd	ra,184(sp)
    8000812e:	f922                	sd	s0,176(sp)
    80008130:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80008132:	f4c40793          	addi	a5,s0,-180
    80008136:	85be                	mv	a1,a5
    80008138:	4505                	li	a0,1
    8000813a:	ffffc097          	auipc	ra,0xffffc
    8000813e:	02c080e7          	jalr	44(ra) # 80004166 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80008142:	f5040793          	addi	a5,s0,-176
    80008146:	08000613          	li	a2,128
    8000814a:	85be                	mv	a1,a5
    8000814c:	4501                	li	a0,0
    8000814e:	ffffc097          	auipc	ra,0xffffc
    80008152:	080080e7          	jalr	128(ra) # 800041ce <argstr>
    80008156:	87aa                	mv	a5,a0
    80008158:	fef42223          	sw	a5,-28(s0)
    8000815c:	fe442783          	lw	a5,-28(s0)
    80008160:	2781                	sext.w	a5,a5
    80008162:	0007d463          	bgez	a5,8000816a <sys_open+0x40>
    return -1;
    80008166:	57fd                	li	a5,-1
    80008168:	aafd                	j	80008366 <sys_open+0x23c>

  begin_op();
    8000816a:	ffffe097          	auipc	ra,0xffffe
    8000816e:	032080e7          	jalr	50(ra) # 8000619c <begin_op>

  if(omode & O_CREATE){
    80008172:	f4c42783          	lw	a5,-180(s0)
    80008176:	2007f793          	andi	a5,a5,512
    8000817a:	2781                	sext.w	a5,a5
    8000817c:	c795                	beqz	a5,800081a8 <sys_open+0x7e>
    ip = create(path, T_FILE, 0, 0);
    8000817e:	f5040793          	addi	a5,s0,-176
    80008182:	4681                	li	a3,0
    80008184:	4601                	li	a2,0
    80008186:	4589                	li	a1,2
    80008188:	853e                	mv	a0,a5
    8000818a:	00000097          	auipc	ra,0x0
    8000818e:	d72080e7          	jalr	-654(ra) # 80007efc <create>
    80008192:	fea43423          	sd	a0,-24(s0)
    if(ip == 0){
    80008196:	fe843783          	ld	a5,-24(s0)
    8000819a:	e7b5                	bnez	a5,80008206 <sys_open+0xdc>
      end_op();
    8000819c:	ffffe097          	auipc	ra,0xffffe
    800081a0:	0c2080e7          	jalr	194(ra) # 8000625e <end_op>
      return -1;
    800081a4:	57fd                	li	a5,-1
    800081a6:	a2c1                	j	80008366 <sys_open+0x23c>
    }
  } else {
    if((ip = namei(path)) == 0){
    800081a8:	f5040793          	addi	a5,s0,-176
    800081ac:	853e                	mv	a0,a5
    800081ae:	ffffe097          	auipc	ra,0xffffe
    800081b2:	c8a080e7          	jalr	-886(ra) # 80005e38 <namei>
    800081b6:	fea43423          	sd	a0,-24(s0)
    800081ba:	fe843783          	ld	a5,-24(s0)
    800081be:	e799                	bnez	a5,800081cc <sys_open+0xa2>
      end_op();
    800081c0:	ffffe097          	auipc	ra,0xffffe
    800081c4:	09e080e7          	jalr	158(ra) # 8000625e <end_op>
      return -1;
    800081c8:	57fd                	li	a5,-1
    800081ca:	aa71                	j	80008366 <sys_open+0x23c>
    }
    ilock(ip);
    800081cc:	fe843503          	ld	a0,-24(s0)
    800081d0:	ffffd097          	auipc	ra,0xffffd
    800081d4:	f38080e7          	jalr	-200(ra) # 80005108 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800081d8:	fe843783          	ld	a5,-24(s0)
    800081dc:	04479783          	lh	a5,68(a5)
    800081e0:	873e                	mv	a4,a5
    800081e2:	4785                	li	a5,1
    800081e4:	02f71163          	bne	a4,a5,80008206 <sys_open+0xdc>
    800081e8:	f4c42783          	lw	a5,-180(s0)
    800081ec:	cf89                	beqz	a5,80008206 <sys_open+0xdc>
      iunlockput(ip);
    800081ee:	fe843503          	ld	a0,-24(s0)
    800081f2:	ffffd097          	auipc	ra,0xffffd
    800081f6:	174080e7          	jalr	372(ra) # 80005366 <iunlockput>
      end_op();
    800081fa:	ffffe097          	auipc	ra,0xffffe
    800081fe:	064080e7          	jalr	100(ra) # 8000625e <end_op>
      return -1;
    80008202:	57fd                	li	a5,-1
    80008204:	a28d                	j	80008366 <sys_open+0x23c>
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80008206:	fe843783          	ld	a5,-24(s0)
    8000820a:	04479783          	lh	a5,68(a5)
    8000820e:	873e                	mv	a4,a5
    80008210:	478d                	li	a5,3
    80008212:	02f71c63          	bne	a4,a5,8000824a <sys_open+0x120>
    80008216:	fe843783          	ld	a5,-24(s0)
    8000821a:	04679783          	lh	a5,70(a5)
    8000821e:	0007ca63          	bltz	a5,80008232 <sys_open+0x108>
    80008222:	fe843783          	ld	a5,-24(s0)
    80008226:	04679783          	lh	a5,70(a5)
    8000822a:	873e                	mv	a4,a5
    8000822c:	47a5                	li	a5,9
    8000822e:	00e7de63          	bge	a5,a4,8000824a <sys_open+0x120>
    iunlockput(ip);
    80008232:	fe843503          	ld	a0,-24(s0)
    80008236:	ffffd097          	auipc	ra,0xffffd
    8000823a:	130080e7          	jalr	304(ra) # 80005366 <iunlockput>
    end_op();
    8000823e:	ffffe097          	auipc	ra,0xffffe
    80008242:	020080e7          	jalr	32(ra) # 8000625e <end_op>
    return -1;
    80008246:	57fd                	li	a5,-1
    80008248:	aa39                	j	80008366 <sys_open+0x23c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000824a:	ffffe097          	auipc	ra,0xffffe
    8000824e:	502080e7          	jalr	1282(ra) # 8000674c <filealloc>
    80008252:	fca43c23          	sd	a0,-40(s0)
    80008256:	fd843783          	ld	a5,-40(s0)
    8000825a:	cf99                	beqz	a5,80008278 <sys_open+0x14e>
    8000825c:	fd843503          	ld	a0,-40(s0)
    80008260:	fffff097          	auipc	ra,0xfffff
    80008264:	5fc080e7          	jalr	1532(ra) # 8000785c <fdalloc>
    80008268:	87aa                	mv	a5,a0
    8000826a:	fcf42a23          	sw	a5,-44(s0)
    8000826e:	fd442783          	lw	a5,-44(s0)
    80008272:	2781                	sext.w	a5,a5
    80008274:	0207d763          	bgez	a5,800082a2 <sys_open+0x178>
    if(f)
    80008278:	fd843783          	ld	a5,-40(s0)
    8000827c:	c799                	beqz	a5,8000828a <sys_open+0x160>
      fileclose(f);
    8000827e:	fd843503          	ld	a0,-40(s0)
    80008282:	ffffe097          	auipc	ra,0xffffe
    80008286:	5b4080e7          	jalr	1460(ra) # 80006836 <fileclose>
    iunlockput(ip);
    8000828a:	fe843503          	ld	a0,-24(s0)
    8000828e:	ffffd097          	auipc	ra,0xffffd
    80008292:	0d8080e7          	jalr	216(ra) # 80005366 <iunlockput>
    end_op();
    80008296:	ffffe097          	auipc	ra,0xffffe
    8000829a:	fc8080e7          	jalr	-56(ra) # 8000625e <end_op>
    return -1;
    8000829e:	57fd                	li	a5,-1
    800082a0:	a0d9                	j	80008366 <sys_open+0x23c>
  }

  if(ip->type == T_DEVICE){
    800082a2:	fe843783          	ld	a5,-24(s0)
    800082a6:	04479783          	lh	a5,68(a5)
    800082aa:	873e                	mv	a4,a5
    800082ac:	478d                	li	a5,3
    800082ae:	00f71f63          	bne	a4,a5,800082cc <sys_open+0x1a2>
    f->type = FD_DEVICE;
    800082b2:	fd843783          	ld	a5,-40(s0)
    800082b6:	470d                	li	a4,3
    800082b8:	c398                	sw	a4,0(a5)
    f->major = ip->major;
    800082ba:	fe843783          	ld	a5,-24(s0)
    800082be:	04679703          	lh	a4,70(a5)
    800082c2:	fd843783          	ld	a5,-40(s0)
    800082c6:	02e79223          	sh	a4,36(a5)
    800082ca:	a809                	j	800082dc <sys_open+0x1b2>
  } else {
    f->type = FD_INODE;
    800082cc:	fd843783          	ld	a5,-40(s0)
    800082d0:	4709                	li	a4,2
    800082d2:	c398                	sw	a4,0(a5)
    f->off = 0;
    800082d4:	fd843783          	ld	a5,-40(s0)
    800082d8:	0207a023          	sw	zero,32(a5)
  }
  f->ip = ip;
    800082dc:	fd843783          	ld	a5,-40(s0)
    800082e0:	fe843703          	ld	a4,-24(s0)
    800082e4:	ef98                	sd	a4,24(a5)
  f->readable = !(omode & O_WRONLY);
    800082e6:	f4c42783          	lw	a5,-180(s0)
    800082ea:	8b85                	andi	a5,a5,1
    800082ec:	2781                	sext.w	a5,a5
    800082ee:	0017b793          	seqz	a5,a5
    800082f2:	0ff7f793          	zext.b	a5,a5
    800082f6:	873e                	mv	a4,a5
    800082f8:	fd843783          	ld	a5,-40(s0)
    800082fc:	00e78423          	sb	a4,8(a5)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80008300:	f4c42783          	lw	a5,-180(s0)
    80008304:	8b85                	andi	a5,a5,1
    80008306:	2781                	sext.w	a5,a5
    80008308:	e791                	bnez	a5,80008314 <sys_open+0x1ea>
    8000830a:	f4c42783          	lw	a5,-180(s0)
    8000830e:	8b89                	andi	a5,a5,2
    80008310:	2781                	sext.w	a5,a5
    80008312:	c399                	beqz	a5,80008318 <sys_open+0x1ee>
    80008314:	4785                	li	a5,1
    80008316:	a011                	j	8000831a <sys_open+0x1f0>
    80008318:	4781                	li	a5,0
    8000831a:	0ff7f713          	zext.b	a4,a5
    8000831e:	fd843783          	ld	a5,-40(s0)
    80008322:	00e784a3          	sb	a4,9(a5)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80008326:	f4c42783          	lw	a5,-180(s0)
    8000832a:	4007f793          	andi	a5,a5,1024
    8000832e:	2781                	sext.w	a5,a5
    80008330:	cf99                	beqz	a5,8000834e <sys_open+0x224>
    80008332:	fe843783          	ld	a5,-24(s0)
    80008336:	04479783          	lh	a5,68(a5)
    8000833a:	873e                	mv	a4,a5
    8000833c:	4789                	li	a5,2
    8000833e:	00f71863          	bne	a4,a5,8000834e <sys_open+0x224>
    itrunc(ip);
    80008342:	fe843503          	ld	a0,-24(s0)
    80008346:	ffffd097          	auipc	ra,0xffffd
    8000834a:	1ca080e7          	jalr	458(ra) # 80005510 <itrunc>
  }

  iunlock(ip);
    8000834e:	fe843503          	ld	a0,-24(s0)
    80008352:	ffffd097          	auipc	ra,0xffffd
    80008356:	eea080e7          	jalr	-278(ra) # 8000523c <iunlock>
  end_op();
    8000835a:	ffffe097          	auipc	ra,0xffffe
    8000835e:	f04080e7          	jalr	-252(ra) # 8000625e <end_op>

  return fd;
    80008362:	fd442783          	lw	a5,-44(s0)
}
    80008366:	853e                	mv	a0,a5
    80008368:	70ea                	ld	ra,184(sp)
    8000836a:	744a                	ld	s0,176(sp)
    8000836c:	6129                	addi	sp,sp,192
    8000836e:	8082                	ret

0000000080008370 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80008370:	7135                	addi	sp,sp,-160
    80008372:	ed06                	sd	ra,152(sp)
    80008374:	e922                	sd	s0,144(sp)
    80008376:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80008378:	ffffe097          	auipc	ra,0xffffe
    8000837c:	e24080e7          	jalr	-476(ra) # 8000619c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80008380:	f6840793          	addi	a5,s0,-152
    80008384:	08000613          	li	a2,128
    80008388:	85be                	mv	a1,a5
    8000838a:	4501                	li	a0,0
    8000838c:	ffffc097          	auipc	ra,0xffffc
    80008390:	e42080e7          	jalr	-446(ra) # 800041ce <argstr>
    80008394:	87aa                	mv	a5,a0
    80008396:	0207c163          	bltz	a5,800083b8 <sys_mkdir+0x48>
    8000839a:	f6840793          	addi	a5,s0,-152
    8000839e:	4681                	li	a3,0
    800083a0:	4601                	li	a2,0
    800083a2:	4585                	li	a1,1
    800083a4:	853e                	mv	a0,a5
    800083a6:	00000097          	auipc	ra,0x0
    800083aa:	b56080e7          	jalr	-1194(ra) # 80007efc <create>
    800083ae:	fea43423          	sd	a0,-24(s0)
    800083b2:	fe843783          	ld	a5,-24(s0)
    800083b6:	e799                	bnez	a5,800083c4 <sys_mkdir+0x54>
    end_op();
    800083b8:	ffffe097          	auipc	ra,0xffffe
    800083bc:	ea6080e7          	jalr	-346(ra) # 8000625e <end_op>
    return -1;
    800083c0:	57fd                	li	a5,-1
    800083c2:	a821                	j	800083da <sys_mkdir+0x6a>
  }
  iunlockput(ip);
    800083c4:	fe843503          	ld	a0,-24(s0)
    800083c8:	ffffd097          	auipc	ra,0xffffd
    800083cc:	f9e080e7          	jalr	-98(ra) # 80005366 <iunlockput>
  end_op();
    800083d0:	ffffe097          	auipc	ra,0xffffe
    800083d4:	e8e080e7          	jalr	-370(ra) # 8000625e <end_op>
  return 0;
    800083d8:	4781                	li	a5,0
}
    800083da:	853e                	mv	a0,a5
    800083dc:	60ea                	ld	ra,152(sp)
    800083de:	644a                	ld	s0,144(sp)
    800083e0:	610d                	addi	sp,sp,160
    800083e2:	8082                	ret

00000000800083e4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800083e4:	7135                	addi	sp,sp,-160
    800083e6:	ed06                	sd	ra,152(sp)
    800083e8:	e922                	sd	s0,144(sp)
    800083ea:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800083ec:	ffffe097          	auipc	ra,0xffffe
    800083f0:	db0080e7          	jalr	-592(ra) # 8000619c <begin_op>
  argint(1, &major);
    800083f4:	f6440793          	addi	a5,s0,-156
    800083f8:	85be                	mv	a1,a5
    800083fa:	4505                	li	a0,1
    800083fc:	ffffc097          	auipc	ra,0xffffc
    80008400:	d6a080e7          	jalr	-662(ra) # 80004166 <argint>
  argint(2, &minor);
    80008404:	f6040793          	addi	a5,s0,-160
    80008408:	85be                	mv	a1,a5
    8000840a:	4509                	li	a0,2
    8000840c:	ffffc097          	auipc	ra,0xffffc
    80008410:	d5a080e7          	jalr	-678(ra) # 80004166 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80008414:	f6840793          	addi	a5,s0,-152
    80008418:	08000613          	li	a2,128
    8000841c:	85be                	mv	a1,a5
    8000841e:	4501                	li	a0,0
    80008420:	ffffc097          	auipc	ra,0xffffc
    80008424:	dae080e7          	jalr	-594(ra) # 800041ce <argstr>
    80008428:	87aa                	mv	a5,a0
    8000842a:	0207cc63          	bltz	a5,80008462 <sys_mknod+0x7e>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000842e:	f6442783          	lw	a5,-156(s0)
    80008432:	0107971b          	slliw	a4,a5,0x10
    80008436:	4107571b          	sraiw	a4,a4,0x10
    8000843a:	f6042783          	lw	a5,-160(s0)
    8000843e:	0107969b          	slliw	a3,a5,0x10
    80008442:	4106d69b          	sraiw	a3,a3,0x10
    80008446:	f6840793          	addi	a5,s0,-152
    8000844a:	863a                	mv	a2,a4
    8000844c:	458d                	li	a1,3
    8000844e:	853e                	mv	a0,a5
    80008450:	00000097          	auipc	ra,0x0
    80008454:	aac080e7          	jalr	-1364(ra) # 80007efc <create>
    80008458:	fea43423          	sd	a0,-24(s0)
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000845c:	fe843783          	ld	a5,-24(s0)
    80008460:	e799                	bnez	a5,8000846e <sys_mknod+0x8a>
    end_op();
    80008462:	ffffe097          	auipc	ra,0xffffe
    80008466:	dfc080e7          	jalr	-516(ra) # 8000625e <end_op>
    return -1;
    8000846a:	57fd                	li	a5,-1
    8000846c:	a821                	j	80008484 <sys_mknod+0xa0>
  }
  iunlockput(ip);
    8000846e:	fe843503          	ld	a0,-24(s0)
    80008472:	ffffd097          	auipc	ra,0xffffd
    80008476:	ef4080e7          	jalr	-268(ra) # 80005366 <iunlockput>
  end_op();
    8000847a:	ffffe097          	auipc	ra,0xffffe
    8000847e:	de4080e7          	jalr	-540(ra) # 8000625e <end_op>
  return 0;
    80008482:	4781                	li	a5,0
}
    80008484:	853e                	mv	a0,a5
    80008486:	60ea                	ld	ra,152(sp)
    80008488:	644a                	ld	s0,144(sp)
    8000848a:	610d                	addi	sp,sp,160
    8000848c:	8082                	ret

000000008000848e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000848e:	7135                	addi	sp,sp,-160
    80008490:	ed06                	sd	ra,152(sp)
    80008492:	e922                	sd	s0,144(sp)
    80008494:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80008496:	ffffa097          	auipc	ra,0xffffa
    8000849a:	3b0080e7          	jalr	944(ra) # 80002846 <myproc>
    8000849e:	fea43423          	sd	a0,-24(s0)
  
  begin_op();
    800084a2:	ffffe097          	auipc	ra,0xffffe
    800084a6:	cfa080e7          	jalr	-774(ra) # 8000619c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800084aa:	f6040793          	addi	a5,s0,-160
    800084ae:	08000613          	li	a2,128
    800084b2:	85be                	mv	a1,a5
    800084b4:	4501                	li	a0,0
    800084b6:	ffffc097          	auipc	ra,0xffffc
    800084ba:	d18080e7          	jalr	-744(ra) # 800041ce <argstr>
    800084be:	87aa                	mv	a5,a0
    800084c0:	0007ce63          	bltz	a5,800084dc <sys_chdir+0x4e>
    800084c4:	f6040793          	addi	a5,s0,-160
    800084c8:	853e                	mv	a0,a5
    800084ca:	ffffe097          	auipc	ra,0xffffe
    800084ce:	96e080e7          	jalr	-1682(ra) # 80005e38 <namei>
    800084d2:	fea43023          	sd	a0,-32(s0)
    800084d6:	fe043783          	ld	a5,-32(s0)
    800084da:	e799                	bnez	a5,800084e8 <sys_chdir+0x5a>
    end_op();
    800084dc:	ffffe097          	auipc	ra,0xffffe
    800084e0:	d82080e7          	jalr	-638(ra) # 8000625e <end_op>
    return -1;
    800084e4:	57fd                	li	a5,-1
    800084e6:	a0ad                	j	80008550 <sys_chdir+0xc2>
  }
  ilock(ip);
    800084e8:	fe043503          	ld	a0,-32(s0)
    800084ec:	ffffd097          	auipc	ra,0xffffd
    800084f0:	c1c080e7          	jalr	-996(ra) # 80005108 <ilock>
  if(ip->type != T_DIR){
    800084f4:	fe043783          	ld	a5,-32(s0)
    800084f8:	04479783          	lh	a5,68(a5)
    800084fc:	873e                	mv	a4,a5
    800084fe:	4785                	li	a5,1
    80008500:	00f70e63          	beq	a4,a5,8000851c <sys_chdir+0x8e>
    iunlockput(ip);
    80008504:	fe043503          	ld	a0,-32(s0)
    80008508:	ffffd097          	auipc	ra,0xffffd
    8000850c:	e5e080e7          	jalr	-418(ra) # 80005366 <iunlockput>
    end_op();
    80008510:	ffffe097          	auipc	ra,0xffffe
    80008514:	d4e080e7          	jalr	-690(ra) # 8000625e <end_op>
    return -1;
    80008518:	57fd                	li	a5,-1
    8000851a:	a81d                	j	80008550 <sys_chdir+0xc2>
  }
  iunlock(ip);
    8000851c:	fe043503          	ld	a0,-32(s0)
    80008520:	ffffd097          	auipc	ra,0xffffd
    80008524:	d1c080e7          	jalr	-740(ra) # 8000523c <iunlock>
  iput(p->cwd);
    80008528:	fe843783          	ld	a5,-24(s0)
    8000852c:	1507b783          	ld	a5,336(a5)
    80008530:	853e                	mv	a0,a5
    80008532:	ffffd097          	auipc	ra,0xffffd
    80008536:	d64080e7          	jalr	-668(ra) # 80005296 <iput>
  end_op();
    8000853a:	ffffe097          	auipc	ra,0xffffe
    8000853e:	d24080e7          	jalr	-732(ra) # 8000625e <end_op>
  p->cwd = ip;
    80008542:	fe843783          	ld	a5,-24(s0)
    80008546:	fe043703          	ld	a4,-32(s0)
    8000854a:	14e7b823          	sd	a4,336(a5)
  return 0;
    8000854e:	4781                	li	a5,0
}
    80008550:	853e                	mv	a0,a5
    80008552:	60ea                	ld	ra,152(sp)
    80008554:	644a                	ld	s0,144(sp)
    80008556:	610d                	addi	sp,sp,160
    80008558:	8082                	ret

000000008000855a <sys_exec>:

uint64
sys_exec(void)
{
    8000855a:	7161                	addi	sp,sp,-432
    8000855c:	f706                	sd	ra,424(sp)
    8000855e:	f322                	sd	s0,416(sp)
    80008560:	1b00                	addi	s0,sp,432
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80008562:	e6040793          	addi	a5,s0,-416
    80008566:	85be                	mv	a1,a5
    80008568:	4505                	li	a0,1
    8000856a:	ffffc097          	auipc	ra,0xffffc
    8000856e:	c32080e7          	jalr	-974(ra) # 8000419c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80008572:	f6840793          	addi	a5,s0,-152
    80008576:	08000613          	li	a2,128
    8000857a:	85be                	mv	a1,a5
    8000857c:	4501                	li	a0,0
    8000857e:	ffffc097          	auipc	ra,0xffffc
    80008582:	c50080e7          	jalr	-944(ra) # 800041ce <argstr>
    80008586:	87aa                	mv	a5,a0
    80008588:	0007d463          	bgez	a5,80008590 <sys_exec+0x36>
    return -1;
    8000858c:	57fd                	li	a5,-1
    8000858e:	aa8d                	j	80008700 <sys_exec+0x1a6>
  }
  memset(argv, 0, sizeof(argv));
    80008590:	e6840793          	addi	a5,s0,-408
    80008594:	10000613          	li	a2,256
    80008598:	4581                	li	a1,0
    8000859a:	853e                	mv	a0,a5
    8000859c:	ffff9097          	auipc	ra,0xffff9
    800085a0:	eb6080e7          	jalr	-330(ra) # 80001452 <memset>
  for(i=0;; i++){
    800085a4:	fe042623          	sw	zero,-20(s0)
    if(i >= NELEM(argv)){
    800085a8:	fec42783          	lw	a5,-20(s0)
    800085ac:	873e                	mv	a4,a5
    800085ae:	47fd                	li	a5,31
    800085b0:	0ee7ee63          	bltu	a5,a4,800086ac <sys_exec+0x152>
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800085b4:	fec42783          	lw	a5,-20(s0)
    800085b8:	00379713          	slli	a4,a5,0x3
    800085bc:	e6043783          	ld	a5,-416(s0)
    800085c0:	97ba                	add	a5,a5,a4
    800085c2:	e5840713          	addi	a4,s0,-424
    800085c6:	85ba                	mv	a1,a4
    800085c8:	853e                	mv	a0,a5
    800085ca:	ffffc097          	auipc	ra,0xffffc
    800085ce:	a2a080e7          	jalr	-1494(ra) # 80003ff4 <fetchaddr>
    800085d2:	87aa                	mv	a5,a0
    800085d4:	0c07ce63          	bltz	a5,800086b0 <sys_exec+0x156>
      goto bad;
    }
    if(uarg == 0){
    800085d8:	e5843783          	ld	a5,-424(s0)
    800085dc:	eb8d                	bnez	a5,8000860e <sys_exec+0xb4>
      argv[i] = 0;
    800085de:	fec42783          	lw	a5,-20(s0)
    800085e2:	078e                	slli	a5,a5,0x3
    800085e4:	17c1                	addi	a5,a5,-16
    800085e6:	97a2                	add	a5,a5,s0
    800085e8:	e607bc23          	sd	zero,-392(a5)
      break;
    800085ec:	0001                	nop
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
      goto bad;
  }

  int ret = exec(path, argv);
    800085ee:	e6840713          	addi	a4,s0,-408
    800085f2:	f6840793          	addi	a5,s0,-152
    800085f6:	85ba                	mv	a1,a4
    800085f8:	853e                	mv	a0,a5
    800085fa:	fffff097          	auipc	ra,0xfffff
    800085fe:	c34080e7          	jalr	-972(ra) # 8000722e <exec>
    80008602:	87aa                	mv	a5,a0
    80008604:	fef42423          	sw	a5,-24(s0)

  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008608:	fe042623          	sw	zero,-20(s0)
    8000860c:	a8bd                	j	8000868a <sys_exec+0x130>
    argv[i] = kalloc();
    8000860e:	ffff9097          	auipc	ra,0xffff9
    80008612:	b1c080e7          	jalr	-1252(ra) # 8000112a <kalloc>
    80008616:	872a                	mv	a4,a0
    80008618:	fec42783          	lw	a5,-20(s0)
    8000861c:	078e                	slli	a5,a5,0x3
    8000861e:	17c1                	addi	a5,a5,-16
    80008620:	97a2                	add	a5,a5,s0
    80008622:	e6e7bc23          	sd	a4,-392(a5)
    if(argv[i] == 0)
    80008626:	fec42783          	lw	a5,-20(s0)
    8000862a:	078e                	slli	a5,a5,0x3
    8000862c:	17c1                	addi	a5,a5,-16
    8000862e:	97a2                	add	a5,a5,s0
    80008630:	e787b783          	ld	a5,-392(a5)
    80008634:	c3c1                	beqz	a5,800086b4 <sys_exec+0x15a>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80008636:	e5843703          	ld	a4,-424(s0)
    8000863a:	fec42783          	lw	a5,-20(s0)
    8000863e:	078e                	slli	a5,a5,0x3
    80008640:	17c1                	addi	a5,a5,-16
    80008642:	97a2                	add	a5,a5,s0
    80008644:	e787b783          	ld	a5,-392(a5)
    80008648:	6605                	lui	a2,0x1
    8000864a:	85be                	mv	a1,a5
    8000864c:	853a                	mv	a0,a4
    8000864e:	ffffc097          	auipc	ra,0xffffc
    80008652:	a14080e7          	jalr	-1516(ra) # 80004062 <fetchstr>
    80008656:	87aa                	mv	a5,a0
    80008658:	0607c063          	bltz	a5,800086b8 <sys_exec+0x15e>
  for(i=0;; i++){
    8000865c:	fec42783          	lw	a5,-20(s0)
    80008660:	2785                	addiw	a5,a5,1
    80008662:	fef42623          	sw	a5,-20(s0)
    if(i >= NELEM(argv)){
    80008666:	b789                	j	800085a8 <sys_exec+0x4e>
    kfree(argv[i]);
    80008668:	fec42783          	lw	a5,-20(s0)
    8000866c:	078e                	slli	a5,a5,0x3
    8000866e:	17c1                	addi	a5,a5,-16
    80008670:	97a2                	add	a5,a5,s0
    80008672:	e787b783          	ld	a5,-392(a5)
    80008676:	853e                	mv	a0,a5
    80008678:	ffff9097          	auipc	ra,0xffff9
    8000867c:	a0e080e7          	jalr	-1522(ra) # 80001086 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80008680:	fec42783          	lw	a5,-20(s0)
    80008684:	2785                	addiw	a5,a5,1
    80008686:	fef42623          	sw	a5,-20(s0)
    8000868a:	fec42783          	lw	a5,-20(s0)
    8000868e:	873e                	mv	a4,a5
    80008690:	47fd                	li	a5,31
    80008692:	00e7ea63          	bltu	a5,a4,800086a6 <sys_exec+0x14c>
    80008696:	fec42783          	lw	a5,-20(s0)
    8000869a:	078e                	slli	a5,a5,0x3
    8000869c:	17c1                	addi	a5,a5,-16
    8000869e:	97a2                	add	a5,a5,s0
    800086a0:	e787b783          	ld	a5,-392(a5)
    800086a4:	f3f1                	bnez	a5,80008668 <sys_exec+0x10e>

  return ret;
    800086a6:	fe842783          	lw	a5,-24(s0)
    800086aa:	a899                	j	80008700 <sys_exec+0x1a6>
      goto bad;
    800086ac:	0001                	nop
    800086ae:	a031                	j	800086ba <sys_exec+0x160>
      goto bad;
    800086b0:	0001                	nop
    800086b2:	a021                	j	800086ba <sys_exec+0x160>
      goto bad;
    800086b4:	0001                	nop
    800086b6:	a011                	j	800086ba <sys_exec+0x160>
      goto bad;
    800086b8:	0001                	nop

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800086ba:	fe042623          	sw	zero,-20(s0)
    800086be:	a015                	j	800086e2 <sys_exec+0x188>
    kfree(argv[i]);
    800086c0:	fec42783          	lw	a5,-20(s0)
    800086c4:	078e                	slli	a5,a5,0x3
    800086c6:	17c1                	addi	a5,a5,-16
    800086c8:	97a2                	add	a5,a5,s0
    800086ca:	e787b783          	ld	a5,-392(a5)
    800086ce:	853e                	mv	a0,a5
    800086d0:	ffff9097          	auipc	ra,0xffff9
    800086d4:	9b6080e7          	jalr	-1610(ra) # 80001086 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800086d8:	fec42783          	lw	a5,-20(s0)
    800086dc:	2785                	addiw	a5,a5,1
    800086de:	fef42623          	sw	a5,-20(s0)
    800086e2:	fec42783          	lw	a5,-20(s0)
    800086e6:	873e                	mv	a4,a5
    800086e8:	47fd                	li	a5,31
    800086ea:	00e7ea63          	bltu	a5,a4,800086fe <sys_exec+0x1a4>
    800086ee:	fec42783          	lw	a5,-20(s0)
    800086f2:	078e                	slli	a5,a5,0x3
    800086f4:	17c1                	addi	a5,a5,-16
    800086f6:	97a2                	add	a5,a5,s0
    800086f8:	e787b783          	ld	a5,-392(a5)
    800086fc:	f3f1                	bnez	a5,800086c0 <sys_exec+0x166>
  return -1;
    800086fe:	57fd                	li	a5,-1
}
    80008700:	853e                	mv	a0,a5
    80008702:	70ba                	ld	ra,424(sp)
    80008704:	741a                	ld	s0,416(sp)
    80008706:	615d                	addi	sp,sp,432
    80008708:	8082                	ret

000000008000870a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000870a:	7139                	addi	sp,sp,-64
    8000870c:	fc06                	sd	ra,56(sp)
    8000870e:	f822                	sd	s0,48(sp)
    80008710:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80008712:	ffffa097          	auipc	ra,0xffffa
    80008716:	134080e7          	jalr	308(ra) # 80002846 <myproc>
    8000871a:	fea43423          	sd	a0,-24(s0)

  argaddr(0, &fdarray);
    8000871e:	fe040793          	addi	a5,s0,-32
    80008722:	85be                	mv	a1,a5
    80008724:	4501                	li	a0,0
    80008726:	ffffc097          	auipc	ra,0xffffc
    8000872a:	a76080e7          	jalr	-1418(ra) # 8000419c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000872e:	fd040713          	addi	a4,s0,-48
    80008732:	fd840793          	addi	a5,s0,-40
    80008736:	85ba                	mv	a1,a4
    80008738:	853e                	mv	a0,a5
    8000873a:	ffffe097          	auipc	ra,0xffffe
    8000873e:	60e080e7          	jalr	1550(ra) # 80006d48 <pipealloc>
    80008742:	87aa                	mv	a5,a0
    80008744:	0007d463          	bgez	a5,8000874c <sys_pipe+0x42>
    return -1;
    80008748:	57fd                	li	a5,-1
    8000874a:	a219                	j	80008850 <sys_pipe+0x146>
  fd0 = -1;
    8000874c:	57fd                	li	a5,-1
    8000874e:	fcf42623          	sw	a5,-52(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80008752:	fd843783          	ld	a5,-40(s0)
    80008756:	853e                	mv	a0,a5
    80008758:	fffff097          	auipc	ra,0xfffff
    8000875c:	104080e7          	jalr	260(ra) # 8000785c <fdalloc>
    80008760:	87aa                	mv	a5,a0
    80008762:	fcf42623          	sw	a5,-52(s0)
    80008766:	fcc42783          	lw	a5,-52(s0)
    8000876a:	0207c063          	bltz	a5,8000878a <sys_pipe+0x80>
    8000876e:	fd043783          	ld	a5,-48(s0)
    80008772:	853e                	mv	a0,a5
    80008774:	fffff097          	auipc	ra,0xfffff
    80008778:	0e8080e7          	jalr	232(ra) # 8000785c <fdalloc>
    8000877c:	87aa                	mv	a5,a0
    8000877e:	fcf42423          	sw	a5,-56(s0)
    80008782:	fc842783          	lw	a5,-56(s0)
    80008786:	0207df63          	bgez	a5,800087c4 <sys_pipe+0xba>
    if(fd0 >= 0)
    8000878a:	fcc42783          	lw	a5,-52(s0)
    8000878e:	0007cb63          	bltz	a5,800087a4 <sys_pipe+0x9a>
      p->ofile[fd0] = 0;
    80008792:	fcc42783          	lw	a5,-52(s0)
    80008796:	fe843703          	ld	a4,-24(s0)
    8000879a:	07e9                	addi	a5,a5,26
    8000879c:	078e                	slli	a5,a5,0x3
    8000879e:	97ba                	add	a5,a5,a4
    800087a0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800087a4:	fd843783          	ld	a5,-40(s0)
    800087a8:	853e                	mv	a0,a5
    800087aa:	ffffe097          	auipc	ra,0xffffe
    800087ae:	08c080e7          	jalr	140(ra) # 80006836 <fileclose>
    fileclose(wf);
    800087b2:	fd043783          	ld	a5,-48(s0)
    800087b6:	853e                	mv	a0,a5
    800087b8:	ffffe097          	auipc	ra,0xffffe
    800087bc:	07e080e7          	jalr	126(ra) # 80006836 <fileclose>
    return -1;
    800087c0:	57fd                	li	a5,-1
    800087c2:	a079                	j	80008850 <sys_pipe+0x146>
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800087c4:	fe843783          	ld	a5,-24(s0)
    800087c8:	6bbc                	ld	a5,80(a5)
    800087ca:	fe043703          	ld	a4,-32(s0)
    800087ce:	fcc40613          	addi	a2,s0,-52
    800087d2:	4691                	li	a3,4
    800087d4:	85ba                	mv	a1,a4
    800087d6:	853e                	mv	a0,a5
    800087d8:	ffffa097          	auipc	ra,0xffffa
    800087dc:	b38080e7          	jalr	-1224(ra) # 80002310 <copyout>
    800087e0:	87aa                	mv	a5,a0
    800087e2:	0207c463          	bltz	a5,8000880a <sys_pipe+0x100>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800087e6:	fe843783          	ld	a5,-24(s0)
    800087ea:	6bb8                	ld	a4,80(a5)
    800087ec:	fe043783          	ld	a5,-32(s0)
    800087f0:	0791                	addi	a5,a5,4
    800087f2:	fc840613          	addi	a2,s0,-56
    800087f6:	4691                	li	a3,4
    800087f8:	85be                	mv	a1,a5
    800087fa:	853a                	mv	a0,a4
    800087fc:	ffffa097          	auipc	ra,0xffffa
    80008800:	b14080e7          	jalr	-1260(ra) # 80002310 <copyout>
    80008804:	87aa                	mv	a5,a0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80008806:	0407d463          	bgez	a5,8000884e <sys_pipe+0x144>
    p->ofile[fd0] = 0;
    8000880a:	fcc42783          	lw	a5,-52(s0)
    8000880e:	fe843703          	ld	a4,-24(s0)
    80008812:	07e9                	addi	a5,a5,26
    80008814:	078e                	slli	a5,a5,0x3
    80008816:	97ba                	add	a5,a5,a4
    80008818:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000881c:	fc842783          	lw	a5,-56(s0)
    80008820:	fe843703          	ld	a4,-24(s0)
    80008824:	07e9                	addi	a5,a5,26
    80008826:	078e                	slli	a5,a5,0x3
    80008828:	97ba                	add	a5,a5,a4
    8000882a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000882e:	fd843783          	ld	a5,-40(s0)
    80008832:	853e                	mv	a0,a5
    80008834:	ffffe097          	auipc	ra,0xffffe
    80008838:	002080e7          	jalr	2(ra) # 80006836 <fileclose>
    fileclose(wf);
    8000883c:	fd043783          	ld	a5,-48(s0)
    80008840:	853e                	mv	a0,a5
    80008842:	ffffe097          	auipc	ra,0xffffe
    80008846:	ff4080e7          	jalr	-12(ra) # 80006836 <fileclose>
    return -1;
    8000884a:	57fd                	li	a5,-1
    8000884c:	a011                	j	80008850 <sys_pipe+0x146>
  }
  return 0;
    8000884e:	4781                	li	a5,0
}
    80008850:	853e                	mv	a0,a5
    80008852:	70e2                	ld	ra,56(sp)
    80008854:	7442                	ld	s0,48(sp)
    80008856:	6121                	addi	sp,sp,64
    80008858:	8082                	ret
    8000885a:	0000                	unimp
    8000885c:	0000                	unimp
	...

0000000080008860 <kernelvec>:
    80008860:	7111                	addi	sp,sp,-256
    80008862:	e006                	sd	ra,0(sp)
    80008864:	e40a                	sd	sp,8(sp)
    80008866:	e80e                	sd	gp,16(sp)
    80008868:	ec12                	sd	tp,24(sp)
    8000886a:	f016                	sd	t0,32(sp)
    8000886c:	f41a                	sd	t1,40(sp)
    8000886e:	f81e                	sd	t2,48(sp)
    80008870:	fc22                	sd	s0,56(sp)
    80008872:	e0a6                	sd	s1,64(sp)
    80008874:	e4aa                	sd	a0,72(sp)
    80008876:	e8ae                	sd	a1,80(sp)
    80008878:	ecb2                	sd	a2,88(sp)
    8000887a:	f0b6                	sd	a3,96(sp)
    8000887c:	f4ba                	sd	a4,104(sp)
    8000887e:	f8be                	sd	a5,112(sp)
    80008880:	fcc2                	sd	a6,120(sp)
    80008882:	e146                	sd	a7,128(sp)
    80008884:	e54a                	sd	s2,136(sp)
    80008886:	e94e                	sd	s3,144(sp)
    80008888:	ed52                	sd	s4,152(sp)
    8000888a:	f156                	sd	s5,160(sp)
    8000888c:	f55a                	sd	s6,168(sp)
    8000888e:	f95e                	sd	s7,176(sp)
    80008890:	fd62                	sd	s8,184(sp)
    80008892:	e1e6                	sd	s9,192(sp)
    80008894:	e5ea                	sd	s10,200(sp)
    80008896:	e9ee                	sd	s11,208(sp)
    80008898:	edf2                	sd	t3,216(sp)
    8000889a:	f1f6                	sd	t4,224(sp)
    8000889c:	f5fa                	sd	t5,232(sp)
    8000889e:	f9fe                	sd	t6,240(sp)
    800088a0:	cecfb0ef          	jal	80003d8c <kerneltrap>
    800088a4:	6082                	ld	ra,0(sp)
    800088a6:	6122                	ld	sp,8(sp)
    800088a8:	61c2                	ld	gp,16(sp)
    800088aa:	7282                	ld	t0,32(sp)
    800088ac:	7322                	ld	t1,40(sp)
    800088ae:	73c2                	ld	t2,48(sp)
    800088b0:	7462                	ld	s0,56(sp)
    800088b2:	6486                	ld	s1,64(sp)
    800088b4:	6526                	ld	a0,72(sp)
    800088b6:	65c6                	ld	a1,80(sp)
    800088b8:	6666                	ld	a2,88(sp)
    800088ba:	7686                	ld	a3,96(sp)
    800088bc:	7726                	ld	a4,104(sp)
    800088be:	77c6                	ld	a5,112(sp)
    800088c0:	7866                	ld	a6,120(sp)
    800088c2:	688a                	ld	a7,128(sp)
    800088c4:	692a                	ld	s2,136(sp)
    800088c6:	69ca                	ld	s3,144(sp)
    800088c8:	6a6a                	ld	s4,152(sp)
    800088ca:	7a8a                	ld	s5,160(sp)
    800088cc:	7b2a                	ld	s6,168(sp)
    800088ce:	7bca                	ld	s7,176(sp)
    800088d0:	7c6a                	ld	s8,184(sp)
    800088d2:	6c8e                	ld	s9,192(sp)
    800088d4:	6d2e                	ld	s10,200(sp)
    800088d6:	6dce                	ld	s11,208(sp)
    800088d8:	6e6e                	ld	t3,216(sp)
    800088da:	7e8e                	ld	t4,224(sp)
    800088dc:	7f2e                	ld	t5,232(sp)
    800088de:	7fce                	ld	t6,240(sp)
    800088e0:	6111                	addi	sp,sp,256
    800088e2:	10200073          	sret
    800088e6:	00000013          	nop
    800088ea:	00000013          	nop
    800088ee:	0001                	nop

00000000800088f0 <timervec>:
    800088f0:	34051573          	csrrw	a0,mscratch,a0
    800088f4:	e10c                	sd	a1,0(a0)
    800088f6:	e510                	sd	a2,8(a0)
    800088f8:	e914                	sd	a3,16(a0)
    800088fa:	6d0c                	ld	a1,24(a0)
    800088fc:	7110                	ld	a2,32(a0)
    800088fe:	6194                	ld	a3,0(a1)
    80008900:	96b2                	add	a3,a3,a2
    80008902:	e194                	sd	a3,0(a1)
    80008904:	4589                	li	a1,2
    80008906:	14459073          	csrw	sip,a1
    8000890a:	6914                	ld	a3,16(a0)
    8000890c:	6510                	ld	a2,8(a0)
    8000890e:	610c                	ld	a1,0(a0)
    80008910:	34051573          	csrrw	a0,mscratch,a0
    80008914:	30200073          	mret
	...

000000008000891a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000891a:	1141                	addi	sp,sp,-16
    8000891c:	e422                	sd	s0,8(sp)
    8000891e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80008920:	0c0007b7          	lui	a5,0xc000
    80008924:	02878793          	addi	a5,a5,40 # c000028 <_entry-0x73ffffd8>
    80008928:	4705                	li	a4,1
    8000892a:	c398                	sw	a4,0(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000892c:	0c0007b7          	lui	a5,0xc000
    80008930:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
    80008932:	4705                	li	a4,1
    80008934:	c398                	sw	a4,0(a5)
}
    80008936:	0001                	nop
    80008938:	6422                	ld	s0,8(sp)
    8000893a:	0141                	addi	sp,sp,16
    8000893c:	8082                	ret

000000008000893e <plicinithart>:

void
plicinithart(void)
{
    8000893e:	1101                	addi	sp,sp,-32
    80008940:	ec06                	sd	ra,24(sp)
    80008942:	e822                	sd	s0,16(sp)
    80008944:	1000                	addi	s0,sp,32
  int hart = cpuid();
    80008946:	ffffa097          	auipc	ra,0xffffa
    8000894a:	ea2080e7          	jalr	-350(ra) # 800027e8 <cpuid>
    8000894e:	87aa                	mv	a5,a0
    80008950:	fef42623          	sw	a5,-20(s0)
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80008954:	fec42783          	lw	a5,-20(s0)
    80008958:	0087979b          	slliw	a5,a5,0x8
    8000895c:	2781                	sext.w	a5,a5
    8000895e:	873e                	mv	a4,a5
    80008960:	0c0027b7          	lui	a5,0xc002
    80008964:	08078793          	addi	a5,a5,128 # c002080 <_entry-0x73ffdf80>
    80008968:	97ba                	add	a5,a5,a4
    8000896a:	873e                	mv	a4,a5
    8000896c:	40200793          	li	a5,1026
    80008970:	c31c                	sw	a5,0(a4)

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80008972:	fec42783          	lw	a5,-20(s0)
    80008976:	00d7979b          	slliw	a5,a5,0xd
    8000897a:	2781                	sext.w	a5,a5
    8000897c:	873e                	mv	a4,a5
    8000897e:	0c2017b7          	lui	a5,0xc201
    80008982:	97ba                	add	a5,a5,a4
    80008984:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80008988:	0001                	nop
    8000898a:	60e2                	ld	ra,24(sp)
    8000898c:	6442                	ld	s0,16(sp)
    8000898e:	6105                	addi	sp,sp,32
    80008990:	8082                	ret

0000000080008992 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80008992:	1101                	addi	sp,sp,-32
    80008994:	ec06                	sd	ra,24(sp)
    80008996:	e822                	sd	s0,16(sp)
    80008998:	1000                	addi	s0,sp,32
  int hart = cpuid();
    8000899a:	ffffa097          	auipc	ra,0xffffa
    8000899e:	e4e080e7          	jalr	-434(ra) # 800027e8 <cpuid>
    800089a2:	87aa                	mv	a5,a0
    800089a4:	fef42623          	sw	a5,-20(s0)
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800089a8:	fec42783          	lw	a5,-20(s0)
    800089ac:	00d7979b          	slliw	a5,a5,0xd
    800089b0:	2781                	sext.w	a5,a5
    800089b2:	873e                	mv	a4,a5
    800089b4:	0c2017b7          	lui	a5,0xc201
    800089b8:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    800089ba:	97ba                	add	a5,a5,a4
    800089bc:	439c                	lw	a5,0(a5)
    800089be:	fef42423          	sw	a5,-24(s0)
  return irq;
    800089c2:	fe842783          	lw	a5,-24(s0)
}
    800089c6:	853e                	mv	a0,a5
    800089c8:	60e2                	ld	ra,24(sp)
    800089ca:	6442                	ld	s0,16(sp)
    800089cc:	6105                	addi	sp,sp,32
    800089ce:	8082                	ret

00000000800089d0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800089d0:	7179                	addi	sp,sp,-48
    800089d2:	f406                	sd	ra,40(sp)
    800089d4:	f022                	sd	s0,32(sp)
    800089d6:	1800                	addi	s0,sp,48
    800089d8:	87aa                	mv	a5,a0
    800089da:	fcf42e23          	sw	a5,-36(s0)
  int hart = cpuid();
    800089de:	ffffa097          	auipc	ra,0xffffa
    800089e2:	e0a080e7          	jalr	-502(ra) # 800027e8 <cpuid>
    800089e6:	87aa                	mv	a5,a0
    800089e8:	fef42623          	sw	a5,-20(s0)
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800089ec:	fec42783          	lw	a5,-20(s0)
    800089f0:	00d7979b          	slliw	a5,a5,0xd
    800089f4:	2781                	sext.w	a5,a5
    800089f6:	873e                	mv	a4,a5
    800089f8:	0c2017b7          	lui	a5,0xc201
    800089fc:	0791                	addi	a5,a5,4 # c201004 <_entry-0x73dfeffc>
    800089fe:	97ba                	add	a5,a5,a4
    80008a00:	873e                	mv	a4,a5
    80008a02:	fdc42783          	lw	a5,-36(s0)
    80008a06:	c31c                	sw	a5,0(a4)
}
    80008a08:	0001                	nop
    80008a0a:	70a2                	ld	ra,40(sp)
    80008a0c:	7402                	ld	s0,32(sp)
    80008a0e:	6145                	addi	sp,sp,48
    80008a10:	8082                	ret

0000000080008a12 <virtio_disk_init>:
  
} disk;

void
virtio_disk_init(void)
{
    80008a12:	7179                	addi	sp,sp,-48
    80008a14:	f406                	sd	ra,40(sp)
    80008a16:	f022                	sd	s0,32(sp)
    80008a18:	1800                	addi	s0,sp,48
  uint32 status = 0;
    80008a1a:	fe042423          	sw	zero,-24(s0)

  initlock(&disk.vdisk_lock, "virtio_disk");
    80008a1e:	00003597          	auipc	a1,0x3
    80008a22:	c4a58593          	addi	a1,a1,-950 # 8000b668 <etext+0x668>
    80008a26:	0001f517          	auipc	a0,0x1f
    80008a2a:	8da50513          	addi	a0,a0,-1830 # 80027300 <disk+0x128>
    80008a2e:	ffff9097          	auipc	ra,0xffff9
    80008a32:	820080e7          	jalr	-2016(ra) # 8000124e <initlock>

  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80008a36:	100017b7          	lui	a5,0x10001
    80008a3a:	439c                	lw	a5,0(a5)
    80008a3c:	2781                	sext.w	a5,a5
    80008a3e:	873e                	mv	a4,a5
    80008a40:	747277b7          	lui	a5,0x74727
    80008a44:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80008a48:	04f71063          	bne	a4,a5,80008a88 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80008a4c:	100017b7          	lui	a5,0x10001
    80008a50:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80008a52:	439c                	lw	a5,0(a5)
    80008a54:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80008a56:	873e                	mv	a4,a5
    80008a58:	4789                	li	a5,2
    80008a5a:	02f71763          	bne	a4,a5,80008a88 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008a5e:	100017b7          	lui	a5,0x10001
    80008a62:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80008a64:	439c                	lw	a5,0(a5)
    80008a66:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80008a68:	873e                	mv	a4,a5
    80008a6a:	4789                	li	a5,2
    80008a6c:	00f71e63          	bne	a4,a5,80008a88 <virtio_disk_init+0x76>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80008a70:	100017b7          	lui	a5,0x10001
    80008a74:	07b1                	addi	a5,a5,12 # 1000100c <_entry-0x6fffeff4>
    80008a76:	439c                	lw	a5,0(a5)
    80008a78:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80008a7a:	873e                	mv	a4,a5
    80008a7c:	554d47b7          	lui	a5,0x554d4
    80008a80:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80008a84:	00f70a63          	beq	a4,a5,80008a98 <virtio_disk_init+0x86>
    panic("could not find virtio disk");
    80008a88:	00003517          	auipc	a0,0x3
    80008a8c:	bf050513          	addi	a0,a0,-1040 # 8000b678 <etext+0x678>
    80008a90:	ffff8097          	auipc	ra,0xffff8
    80008a94:	1fa080e7          	jalr	506(ra) # 80000c8a <panic>
  }
  
  // reset device
  *R(VIRTIO_MMIO_STATUS) = status;
    80008a98:	100017b7          	lui	a5,0x10001
    80008a9c:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008aa0:	fe842703          	lw	a4,-24(s0)
    80008aa4:	c398                	sw	a4,0(a5)

  // set ACKNOWLEDGE status bit
  status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
    80008aa6:	fe842783          	lw	a5,-24(s0)
    80008aaa:	0017e793          	ori	a5,a5,1
    80008aae:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008ab2:	100017b7          	lui	a5,0x10001
    80008ab6:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008aba:	fe842703          	lw	a4,-24(s0)
    80008abe:	c398                	sw	a4,0(a5)

  // set DRIVER status bit
  status |= VIRTIO_CONFIG_S_DRIVER;
    80008ac0:	fe842783          	lw	a5,-24(s0)
    80008ac4:	0027e793          	ori	a5,a5,2
    80008ac8:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008acc:	100017b7          	lui	a5,0x10001
    80008ad0:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008ad4:	fe842703          	lw	a4,-24(s0)
    80008ad8:	c398                	sw	a4,0(a5)

  // negotiate features
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80008ada:	100017b7          	lui	a5,0x10001
    80008ade:	07c1                	addi	a5,a5,16 # 10001010 <_entry-0x6fffeff0>
    80008ae0:	439c                	lw	a5,0(a5)
    80008ae2:	2781                	sext.w	a5,a5
    80008ae4:	1782                	slli	a5,a5,0x20
    80008ae6:	9381                	srli	a5,a5,0x20
    80008ae8:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_RO);
    80008aec:	fe043783          	ld	a5,-32(s0)
    80008af0:	fdf7f793          	andi	a5,a5,-33
    80008af4:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_SCSI);
    80008af8:	fe043783          	ld	a5,-32(s0)
    80008afc:	f7f7f793          	andi	a5,a5,-129
    80008b00:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_CONFIG_WCE);
    80008b04:	fe043703          	ld	a4,-32(s0)
    80008b08:	77fd                	lui	a5,0xfffff
    80008b0a:	7ff78793          	addi	a5,a5,2047 # fffffffffffff7ff <end+0xffffffff7ffd84e7>
    80008b0e:	8ff9                	and	a5,a5,a4
    80008b10:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_BLK_F_MQ);
    80008b14:	fe043703          	ld	a4,-32(s0)
    80008b18:	77fd                	lui	a5,0xfffff
    80008b1a:	17fd                	addi	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7ffd7ce7>
    80008b1c:	8ff9                	and	a5,a5,a4
    80008b1e:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_F_ANY_LAYOUT);
    80008b22:	fe043703          	ld	a4,-32(s0)
    80008b26:	f80007b7          	lui	a5,0xf8000
    80008b2a:	17fd                	addi	a5,a5,-1 # fffffffff7ffffff <end+0xffffffff77fd8ce7>
    80008b2c:	8ff9                	and	a5,a5,a4
    80008b2e:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_EVENT_IDX);
    80008b32:	fe043703          	ld	a4,-32(s0)
    80008b36:	e00007b7          	lui	a5,0xe0000
    80008b3a:	17fd                	addi	a5,a5,-1 # ffffffffdfffffff <end+0xffffffff5ffd8ce7>
    80008b3c:	8ff9                	and	a5,a5,a4
    80008b3e:	fef43023          	sd	a5,-32(s0)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80008b42:	fe043703          	ld	a4,-32(s0)
    80008b46:	f00007b7          	lui	a5,0xf0000
    80008b4a:	17fd                	addi	a5,a5,-1 # ffffffffefffffff <end+0xffffffff6ffd8ce7>
    80008b4c:	8ff9                	and	a5,a5,a4
    80008b4e:	fef43023          	sd	a5,-32(s0)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80008b52:	100017b7          	lui	a5,0x10001
    80008b56:	02078793          	addi	a5,a5,32 # 10001020 <_entry-0x6fffefe0>
    80008b5a:	fe043703          	ld	a4,-32(s0)
    80008b5e:	2701                	sext.w	a4,a4
    80008b60:	c398                	sw	a4,0(a5)

  // tell device that feature negotiation is complete.
  status |= VIRTIO_CONFIG_S_FEATURES_OK;
    80008b62:	fe842783          	lw	a5,-24(s0)
    80008b66:	0087e793          	ori	a5,a5,8
    80008b6a:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008b6e:	100017b7          	lui	a5,0x10001
    80008b72:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008b76:	fe842703          	lw	a4,-24(s0)
    80008b7a:	c398                	sw	a4,0(a5)

  // re-read status to ensure FEATURES_OK is set.
  status = *R(VIRTIO_MMIO_STATUS);
    80008b7c:	100017b7          	lui	a5,0x10001
    80008b80:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008b84:	439c                	lw	a5,0(a5)
    80008b86:	fef42423          	sw	a5,-24(s0)
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80008b8a:	fe842783          	lw	a5,-24(s0)
    80008b8e:	8ba1                	andi	a5,a5,8
    80008b90:	2781                	sext.w	a5,a5
    80008b92:	eb89                	bnez	a5,80008ba4 <virtio_disk_init+0x192>
    panic("virtio disk FEATURES_OK unset");
    80008b94:	00003517          	auipc	a0,0x3
    80008b98:	b0450513          	addi	a0,a0,-1276 # 8000b698 <etext+0x698>
    80008b9c:	ffff8097          	auipc	ra,0xffff8
    80008ba0:	0ee080e7          	jalr	238(ra) # 80000c8a <panic>

  // initialize queue 0.
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80008ba4:	100017b7          	lui	a5,0x10001
    80008ba8:	03078793          	addi	a5,a5,48 # 10001030 <_entry-0x6fffefd0>
    80008bac:	0007a023          	sw	zero,0(a5)

  // ensure queue 0 is not in use.
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80008bb0:	100017b7          	lui	a5,0x10001
    80008bb4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008bb8:	439c                	lw	a5,0(a5)
    80008bba:	2781                	sext.w	a5,a5
    80008bbc:	cb89                	beqz	a5,80008bce <virtio_disk_init+0x1bc>
    panic("virtio disk should not be ready");
    80008bbe:	00003517          	auipc	a0,0x3
    80008bc2:	afa50513          	addi	a0,a0,-1286 # 8000b6b8 <etext+0x6b8>
    80008bc6:	ffff8097          	auipc	ra,0xffff8
    80008bca:	0c4080e7          	jalr	196(ra) # 80000c8a <panic>

  // check maximum queue size.
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80008bce:	100017b7          	lui	a5,0x10001
    80008bd2:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80008bd6:	439c                	lw	a5,0(a5)
    80008bd8:	fcf42e23          	sw	a5,-36(s0)
  if(max == 0)
    80008bdc:	fdc42783          	lw	a5,-36(s0)
    80008be0:	2781                	sext.w	a5,a5
    80008be2:	eb89                	bnez	a5,80008bf4 <virtio_disk_init+0x1e2>
    panic("virtio disk has no queue 0");
    80008be4:	00003517          	auipc	a0,0x3
    80008be8:	af450513          	addi	a0,a0,-1292 # 8000b6d8 <etext+0x6d8>
    80008bec:	ffff8097          	auipc	ra,0xffff8
    80008bf0:	09e080e7          	jalr	158(ra) # 80000c8a <panic>
  if(max < NUM)
    80008bf4:	fdc42783          	lw	a5,-36(s0)
    80008bf8:	0007871b          	sext.w	a4,a5
    80008bfc:	479d                	li	a5,7
    80008bfe:	00e7ea63          	bltu	a5,a4,80008c12 <virtio_disk_init+0x200>
    panic("virtio disk max queue too short");
    80008c02:	00003517          	auipc	a0,0x3
    80008c06:	af650513          	addi	a0,a0,-1290 # 8000b6f8 <etext+0x6f8>
    80008c0a:	ffff8097          	auipc	ra,0xffff8
    80008c0e:	080080e7          	jalr	128(ra) # 80000c8a <panic>

  // allocate and zero queue memory.
  disk.desc = kalloc();
    80008c12:	ffff8097          	auipc	ra,0xffff8
    80008c16:	518080e7          	jalr	1304(ra) # 8000112a <kalloc>
    80008c1a:	872a                	mv	a4,a0
    80008c1c:	0001e797          	auipc	a5,0x1e
    80008c20:	5bc78793          	addi	a5,a5,1468 # 800271d8 <disk>
    80008c24:	e398                	sd	a4,0(a5)
  disk.avail = kalloc();
    80008c26:	ffff8097          	auipc	ra,0xffff8
    80008c2a:	504080e7          	jalr	1284(ra) # 8000112a <kalloc>
    80008c2e:	872a                	mv	a4,a0
    80008c30:	0001e797          	auipc	a5,0x1e
    80008c34:	5a878793          	addi	a5,a5,1448 # 800271d8 <disk>
    80008c38:	e798                	sd	a4,8(a5)
  disk.used = kalloc();
    80008c3a:	ffff8097          	auipc	ra,0xffff8
    80008c3e:	4f0080e7          	jalr	1264(ra) # 8000112a <kalloc>
    80008c42:	872a                	mv	a4,a0
    80008c44:	0001e797          	auipc	a5,0x1e
    80008c48:	59478793          	addi	a5,a5,1428 # 800271d8 <disk>
    80008c4c:	eb98                	sd	a4,16(a5)
  if(!disk.desc || !disk.avail || !disk.used)
    80008c4e:	0001e797          	auipc	a5,0x1e
    80008c52:	58a78793          	addi	a5,a5,1418 # 800271d8 <disk>
    80008c56:	639c                	ld	a5,0(a5)
    80008c58:	cf89                	beqz	a5,80008c72 <virtio_disk_init+0x260>
    80008c5a:	0001e797          	auipc	a5,0x1e
    80008c5e:	57e78793          	addi	a5,a5,1406 # 800271d8 <disk>
    80008c62:	679c                	ld	a5,8(a5)
    80008c64:	c799                	beqz	a5,80008c72 <virtio_disk_init+0x260>
    80008c66:	0001e797          	auipc	a5,0x1e
    80008c6a:	57278793          	addi	a5,a5,1394 # 800271d8 <disk>
    80008c6e:	6b9c                	ld	a5,16(a5)
    80008c70:	eb89                	bnez	a5,80008c82 <virtio_disk_init+0x270>
    panic("virtio disk kalloc");
    80008c72:	00003517          	auipc	a0,0x3
    80008c76:	aa650513          	addi	a0,a0,-1370 # 8000b718 <etext+0x718>
    80008c7a:	ffff8097          	auipc	ra,0xffff8
    80008c7e:	010080e7          	jalr	16(ra) # 80000c8a <panic>
  memset(disk.desc, 0, PGSIZE);
    80008c82:	0001e797          	auipc	a5,0x1e
    80008c86:	55678793          	addi	a5,a5,1366 # 800271d8 <disk>
    80008c8a:	639c                	ld	a5,0(a5)
    80008c8c:	6605                	lui	a2,0x1
    80008c8e:	4581                	li	a1,0
    80008c90:	853e                	mv	a0,a5
    80008c92:	ffff8097          	auipc	ra,0xffff8
    80008c96:	7c0080e7          	jalr	1984(ra) # 80001452 <memset>
  memset(disk.avail, 0, PGSIZE);
    80008c9a:	0001e797          	auipc	a5,0x1e
    80008c9e:	53e78793          	addi	a5,a5,1342 # 800271d8 <disk>
    80008ca2:	679c                	ld	a5,8(a5)
    80008ca4:	6605                	lui	a2,0x1
    80008ca6:	4581                	li	a1,0
    80008ca8:	853e                	mv	a0,a5
    80008caa:	ffff8097          	auipc	ra,0xffff8
    80008cae:	7a8080e7          	jalr	1960(ra) # 80001452 <memset>
  memset(disk.used, 0, PGSIZE);
    80008cb2:	0001e797          	auipc	a5,0x1e
    80008cb6:	52678793          	addi	a5,a5,1318 # 800271d8 <disk>
    80008cba:	6b9c                	ld	a5,16(a5)
    80008cbc:	6605                	lui	a2,0x1
    80008cbe:	4581                	li	a1,0
    80008cc0:	853e                	mv	a0,a5
    80008cc2:	ffff8097          	auipc	ra,0xffff8
    80008cc6:	790080e7          	jalr	1936(ra) # 80001452 <memset>

  // set queue size.
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80008cca:	100017b7          	lui	a5,0x10001
    80008cce:	03878793          	addi	a5,a5,56 # 10001038 <_entry-0x6fffefc8>
    80008cd2:	4721                	li	a4,8
    80008cd4:	c398                	sw	a4,0(a5)

  // write physical addresses.
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80008cd6:	0001e797          	auipc	a5,0x1e
    80008cda:	50278793          	addi	a5,a5,1282 # 800271d8 <disk>
    80008cde:	639c                	ld	a5,0(a5)
    80008ce0:	873e                	mv	a4,a5
    80008ce2:	100017b7          	lui	a5,0x10001
    80008ce6:	08078793          	addi	a5,a5,128 # 10001080 <_entry-0x6fffef80>
    80008cea:	2701                	sext.w	a4,a4
    80008cec:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80008cee:	0001e797          	auipc	a5,0x1e
    80008cf2:	4ea78793          	addi	a5,a5,1258 # 800271d8 <disk>
    80008cf6:	639c                	ld	a5,0(a5)
    80008cf8:	0207d713          	srli	a4,a5,0x20
    80008cfc:	100017b7          	lui	a5,0x10001
    80008d00:	08478793          	addi	a5,a5,132 # 10001084 <_entry-0x6fffef7c>
    80008d04:	2701                	sext.w	a4,a4
    80008d06:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80008d08:	0001e797          	auipc	a5,0x1e
    80008d0c:	4d078793          	addi	a5,a5,1232 # 800271d8 <disk>
    80008d10:	679c                	ld	a5,8(a5)
    80008d12:	873e                	mv	a4,a5
    80008d14:	100017b7          	lui	a5,0x10001
    80008d18:	09078793          	addi	a5,a5,144 # 10001090 <_entry-0x6fffef70>
    80008d1c:	2701                	sext.w	a4,a4
    80008d1e:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80008d20:	0001e797          	auipc	a5,0x1e
    80008d24:	4b878793          	addi	a5,a5,1208 # 800271d8 <disk>
    80008d28:	679c                	ld	a5,8(a5)
    80008d2a:	0207d713          	srli	a4,a5,0x20
    80008d2e:	100017b7          	lui	a5,0x10001
    80008d32:	09478793          	addi	a5,a5,148 # 10001094 <_entry-0x6fffef6c>
    80008d36:	2701                	sext.w	a4,a4
    80008d38:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80008d3a:	0001e797          	auipc	a5,0x1e
    80008d3e:	49e78793          	addi	a5,a5,1182 # 800271d8 <disk>
    80008d42:	6b9c                	ld	a5,16(a5)
    80008d44:	873e                	mv	a4,a5
    80008d46:	100017b7          	lui	a5,0x10001
    80008d4a:	0a078793          	addi	a5,a5,160 # 100010a0 <_entry-0x6fffef60>
    80008d4e:	2701                	sext.w	a4,a4
    80008d50:	c398                	sw	a4,0(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80008d52:	0001e797          	auipc	a5,0x1e
    80008d56:	48678793          	addi	a5,a5,1158 # 800271d8 <disk>
    80008d5a:	6b9c                	ld	a5,16(a5)
    80008d5c:	0207d713          	srli	a4,a5,0x20
    80008d60:	100017b7          	lui	a5,0x10001
    80008d64:	0a478793          	addi	a5,a5,164 # 100010a4 <_entry-0x6fffef5c>
    80008d68:	2701                	sext.w	a4,a4
    80008d6a:	c398                	sw	a4,0(a5)

  // queue is ready.
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80008d6c:	100017b7          	lui	a5,0x10001
    80008d70:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80008d74:	4705                	li	a4,1
    80008d76:	c398                	sw	a4,0(a5)

  // all NUM descriptors start out unused.
  for(int i = 0; i < NUM; i++)
    80008d78:	fe042623          	sw	zero,-20(s0)
    80008d7c:	a005                	j	80008d9c <virtio_disk_init+0x38a>
    disk.free[i] = 1;
    80008d7e:	0001e717          	auipc	a4,0x1e
    80008d82:	45a70713          	addi	a4,a4,1114 # 800271d8 <disk>
    80008d86:	fec42783          	lw	a5,-20(s0)
    80008d8a:	97ba                	add	a5,a5,a4
    80008d8c:	4705                	li	a4,1
    80008d8e:	00e78c23          	sb	a4,24(a5)
  for(int i = 0; i < NUM; i++)
    80008d92:	fec42783          	lw	a5,-20(s0)
    80008d96:	2785                	addiw	a5,a5,1
    80008d98:	fef42623          	sw	a5,-20(s0)
    80008d9c:	fec42783          	lw	a5,-20(s0)
    80008da0:	0007871b          	sext.w	a4,a5
    80008da4:	479d                	li	a5,7
    80008da6:	fce7dce3          	bge	a5,a4,80008d7e <virtio_disk_init+0x36c>

  // tell device we're completely ready.
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80008daa:	fe842783          	lw	a5,-24(s0)
    80008dae:	0047e793          	ori	a5,a5,4
    80008db2:	fef42423          	sw	a5,-24(s0)
  *R(VIRTIO_MMIO_STATUS) = status;
    80008db6:	100017b7          	lui	a5,0x10001
    80008dba:	07078793          	addi	a5,a5,112 # 10001070 <_entry-0x6fffef90>
    80008dbe:	fe842703          	lw	a4,-24(s0)
    80008dc2:	c398                	sw	a4,0(a5)

  // plic.c and trap.c arrange for interrupts from VIRTIO0_IRQ.
}
    80008dc4:	0001                	nop
    80008dc6:	70a2                	ld	ra,40(sp)
    80008dc8:	7402                	ld	s0,32(sp)
    80008dca:	6145                	addi	sp,sp,48
    80008dcc:	8082                	ret

0000000080008dce <alloc_desc>:

// find a free descriptor, mark it non-free, return its index.
static int
alloc_desc()
{
    80008dce:	1101                	addi	sp,sp,-32
    80008dd0:	ec22                	sd	s0,24(sp)
    80008dd2:	1000                	addi	s0,sp,32
  for(int i = 0; i < NUM; i++){
    80008dd4:	fe042623          	sw	zero,-20(s0)
    80008dd8:	a825                	j	80008e10 <alloc_desc+0x42>
    if(disk.free[i]){
    80008dda:	0001e717          	auipc	a4,0x1e
    80008dde:	3fe70713          	addi	a4,a4,1022 # 800271d8 <disk>
    80008de2:	fec42783          	lw	a5,-20(s0)
    80008de6:	97ba                	add	a5,a5,a4
    80008de8:	0187c783          	lbu	a5,24(a5)
    80008dec:	cf89                	beqz	a5,80008e06 <alloc_desc+0x38>
      disk.free[i] = 0;
    80008dee:	0001e717          	auipc	a4,0x1e
    80008df2:	3ea70713          	addi	a4,a4,1002 # 800271d8 <disk>
    80008df6:	fec42783          	lw	a5,-20(s0)
    80008dfa:	97ba                	add	a5,a5,a4
    80008dfc:	00078c23          	sb	zero,24(a5)
      return i;
    80008e00:	fec42783          	lw	a5,-20(s0)
    80008e04:	a831                	j	80008e20 <alloc_desc+0x52>
  for(int i = 0; i < NUM; i++){
    80008e06:	fec42783          	lw	a5,-20(s0)
    80008e0a:	2785                	addiw	a5,a5,1
    80008e0c:	fef42623          	sw	a5,-20(s0)
    80008e10:	fec42783          	lw	a5,-20(s0)
    80008e14:	0007871b          	sext.w	a4,a5
    80008e18:	479d                	li	a5,7
    80008e1a:	fce7d0e3          	bge	a5,a4,80008dda <alloc_desc+0xc>
    }
  }
  return -1;
    80008e1e:	57fd                	li	a5,-1
}
    80008e20:	853e                	mv	a0,a5
    80008e22:	6462                	ld	s0,24(sp)
    80008e24:	6105                	addi	sp,sp,32
    80008e26:	8082                	ret

0000000080008e28 <free_desc>:

// mark a descriptor as free.
static void
free_desc(int i)
{
    80008e28:	1101                	addi	sp,sp,-32
    80008e2a:	ec06                	sd	ra,24(sp)
    80008e2c:	e822                	sd	s0,16(sp)
    80008e2e:	1000                	addi	s0,sp,32
    80008e30:	87aa                	mv	a5,a0
    80008e32:	fef42623          	sw	a5,-20(s0)
  if(i >= NUM)
    80008e36:	fec42783          	lw	a5,-20(s0)
    80008e3a:	0007871b          	sext.w	a4,a5
    80008e3e:	479d                	li	a5,7
    80008e40:	00e7da63          	bge	a5,a4,80008e54 <free_desc+0x2c>
    panic("free_desc 1");
    80008e44:	00003517          	auipc	a0,0x3
    80008e48:	8ec50513          	addi	a0,a0,-1812 # 8000b730 <etext+0x730>
    80008e4c:	ffff8097          	auipc	ra,0xffff8
    80008e50:	e3e080e7          	jalr	-450(ra) # 80000c8a <panic>
  if(disk.free[i])
    80008e54:	0001e717          	auipc	a4,0x1e
    80008e58:	38470713          	addi	a4,a4,900 # 800271d8 <disk>
    80008e5c:	fec42783          	lw	a5,-20(s0)
    80008e60:	97ba                	add	a5,a5,a4
    80008e62:	0187c783          	lbu	a5,24(a5)
    80008e66:	cb89                	beqz	a5,80008e78 <free_desc+0x50>
    panic("free_desc 2");
    80008e68:	00003517          	auipc	a0,0x3
    80008e6c:	8d850513          	addi	a0,a0,-1832 # 8000b740 <etext+0x740>
    80008e70:	ffff8097          	auipc	ra,0xffff8
    80008e74:	e1a080e7          	jalr	-486(ra) # 80000c8a <panic>
  disk.desc[i].addr = 0;
    80008e78:	0001e797          	auipc	a5,0x1e
    80008e7c:	36078793          	addi	a5,a5,864 # 800271d8 <disk>
    80008e80:	6398                	ld	a4,0(a5)
    80008e82:	fec42783          	lw	a5,-20(s0)
    80008e86:	0792                	slli	a5,a5,0x4
    80008e88:	97ba                	add	a5,a5,a4
    80008e8a:	0007b023          	sd	zero,0(a5)
  disk.desc[i].len = 0;
    80008e8e:	0001e797          	auipc	a5,0x1e
    80008e92:	34a78793          	addi	a5,a5,842 # 800271d8 <disk>
    80008e96:	6398                	ld	a4,0(a5)
    80008e98:	fec42783          	lw	a5,-20(s0)
    80008e9c:	0792                	slli	a5,a5,0x4
    80008e9e:	97ba                	add	a5,a5,a4
    80008ea0:	0007a423          	sw	zero,8(a5)
  disk.desc[i].flags = 0;
    80008ea4:	0001e797          	auipc	a5,0x1e
    80008ea8:	33478793          	addi	a5,a5,820 # 800271d8 <disk>
    80008eac:	6398                	ld	a4,0(a5)
    80008eae:	fec42783          	lw	a5,-20(s0)
    80008eb2:	0792                	slli	a5,a5,0x4
    80008eb4:	97ba                	add	a5,a5,a4
    80008eb6:	00079623          	sh	zero,12(a5)
  disk.desc[i].next = 0;
    80008eba:	0001e797          	auipc	a5,0x1e
    80008ebe:	31e78793          	addi	a5,a5,798 # 800271d8 <disk>
    80008ec2:	6398                	ld	a4,0(a5)
    80008ec4:	fec42783          	lw	a5,-20(s0)
    80008ec8:	0792                	slli	a5,a5,0x4
    80008eca:	97ba                	add	a5,a5,a4
    80008ecc:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80008ed0:	0001e717          	auipc	a4,0x1e
    80008ed4:	30870713          	addi	a4,a4,776 # 800271d8 <disk>
    80008ed8:	fec42783          	lw	a5,-20(s0)
    80008edc:	97ba                	add	a5,a5,a4
    80008ede:	4705                	li	a4,1
    80008ee0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80008ee4:	0001e517          	auipc	a0,0x1e
    80008ee8:	30c50513          	addi	a0,a0,780 # 800271f0 <disk+0x18>
    80008eec:	ffffa097          	auipc	ra,0xffffa
    80008ef0:	598080e7          	jalr	1432(ra) # 80003484 <wakeup>
}
    80008ef4:	0001                	nop
    80008ef6:	60e2                	ld	ra,24(sp)
    80008ef8:	6442                	ld	s0,16(sp)
    80008efa:	6105                	addi	sp,sp,32
    80008efc:	8082                	ret

0000000080008efe <free_chain>:

// free a chain of descriptors.
static void
free_chain(int i)
{
    80008efe:	7179                	addi	sp,sp,-48
    80008f00:	f406                	sd	ra,40(sp)
    80008f02:	f022                	sd	s0,32(sp)
    80008f04:	1800                	addi	s0,sp,48
    80008f06:	87aa                	mv	a5,a0
    80008f08:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    int flag = disk.desc[i].flags;
    80008f0c:	0001e797          	auipc	a5,0x1e
    80008f10:	2cc78793          	addi	a5,a5,716 # 800271d8 <disk>
    80008f14:	6398                	ld	a4,0(a5)
    80008f16:	fdc42783          	lw	a5,-36(s0)
    80008f1a:	0792                	slli	a5,a5,0x4
    80008f1c:	97ba                	add	a5,a5,a4
    80008f1e:	00c7d783          	lhu	a5,12(a5)
    80008f22:	fef42623          	sw	a5,-20(s0)
    int nxt = disk.desc[i].next;
    80008f26:	0001e797          	auipc	a5,0x1e
    80008f2a:	2b278793          	addi	a5,a5,690 # 800271d8 <disk>
    80008f2e:	6398                	ld	a4,0(a5)
    80008f30:	fdc42783          	lw	a5,-36(s0)
    80008f34:	0792                	slli	a5,a5,0x4
    80008f36:	97ba                	add	a5,a5,a4
    80008f38:	00e7d783          	lhu	a5,14(a5)
    80008f3c:	fef42423          	sw	a5,-24(s0)
    free_desc(i);
    80008f40:	fdc42783          	lw	a5,-36(s0)
    80008f44:	853e                	mv	a0,a5
    80008f46:	00000097          	auipc	ra,0x0
    80008f4a:	ee2080e7          	jalr	-286(ra) # 80008e28 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80008f4e:	fec42783          	lw	a5,-20(s0)
    80008f52:	8b85                	andi	a5,a5,1
    80008f54:	2781                	sext.w	a5,a5
    80008f56:	c791                	beqz	a5,80008f62 <free_chain+0x64>
      i = nxt;
    80008f58:	fe842783          	lw	a5,-24(s0)
    80008f5c:	fcf42e23          	sw	a5,-36(s0)
  while(1){
    80008f60:	b775                	j	80008f0c <free_chain+0xe>
    else
      break;
    80008f62:	0001                	nop
  }
}
    80008f64:	0001                	nop
    80008f66:	70a2                	ld	ra,40(sp)
    80008f68:	7402                	ld	s0,32(sp)
    80008f6a:	6145                	addi	sp,sp,48
    80008f6c:	8082                	ret

0000000080008f6e <alloc3_desc>:

// allocate three descriptors (they need not be contiguous).
// disk transfers always use three descriptors.
static int
alloc3_desc(int *idx)
{
    80008f6e:	7139                	addi	sp,sp,-64
    80008f70:	fc06                	sd	ra,56(sp)
    80008f72:	f822                	sd	s0,48(sp)
    80008f74:	f426                	sd	s1,40(sp)
    80008f76:	0080                	addi	s0,sp,64
    80008f78:	fca43423          	sd	a0,-56(s0)
  for(int i = 0; i < 3; i++){
    80008f7c:	fc042e23          	sw	zero,-36(s0)
    80008f80:	a89d                	j	80008ff6 <alloc3_desc+0x88>
    idx[i] = alloc_desc();
    80008f82:	fdc42783          	lw	a5,-36(s0)
    80008f86:	078a                	slli	a5,a5,0x2
    80008f88:	fc843703          	ld	a4,-56(s0)
    80008f8c:	00f704b3          	add	s1,a4,a5
    80008f90:	00000097          	auipc	ra,0x0
    80008f94:	e3e080e7          	jalr	-450(ra) # 80008dce <alloc_desc>
    80008f98:	87aa                	mv	a5,a0
    80008f9a:	c09c                	sw	a5,0(s1)
    if(idx[i] < 0){
    80008f9c:	fdc42783          	lw	a5,-36(s0)
    80008fa0:	078a                	slli	a5,a5,0x2
    80008fa2:	fc843703          	ld	a4,-56(s0)
    80008fa6:	97ba                	add	a5,a5,a4
    80008fa8:	439c                	lw	a5,0(a5)
    80008faa:	0407d163          	bgez	a5,80008fec <alloc3_desc+0x7e>
      for(int j = 0; j < i; j++)
    80008fae:	fc042c23          	sw	zero,-40(s0)
    80008fb2:	a015                	j	80008fd6 <alloc3_desc+0x68>
        free_desc(idx[j]);
    80008fb4:	fd842783          	lw	a5,-40(s0)
    80008fb8:	078a                	slli	a5,a5,0x2
    80008fba:	fc843703          	ld	a4,-56(s0)
    80008fbe:	97ba                	add	a5,a5,a4
    80008fc0:	439c                	lw	a5,0(a5)
    80008fc2:	853e                	mv	a0,a5
    80008fc4:	00000097          	auipc	ra,0x0
    80008fc8:	e64080e7          	jalr	-412(ra) # 80008e28 <free_desc>
      for(int j = 0; j < i; j++)
    80008fcc:	fd842783          	lw	a5,-40(s0)
    80008fd0:	2785                	addiw	a5,a5,1
    80008fd2:	fcf42c23          	sw	a5,-40(s0)
    80008fd6:	fd842783          	lw	a5,-40(s0)
    80008fda:	873e                	mv	a4,a5
    80008fdc:	fdc42783          	lw	a5,-36(s0)
    80008fe0:	2701                	sext.w	a4,a4
    80008fe2:	2781                	sext.w	a5,a5
    80008fe4:	fcf748e3          	blt	a4,a5,80008fb4 <alloc3_desc+0x46>
      return -1;
    80008fe8:	57fd                	li	a5,-1
    80008fea:	a831                	j	80009006 <alloc3_desc+0x98>
  for(int i = 0; i < 3; i++){
    80008fec:	fdc42783          	lw	a5,-36(s0)
    80008ff0:	2785                	addiw	a5,a5,1
    80008ff2:	fcf42e23          	sw	a5,-36(s0)
    80008ff6:	fdc42783          	lw	a5,-36(s0)
    80008ffa:	0007871b          	sext.w	a4,a5
    80008ffe:	4789                	li	a5,2
    80009000:	f8e7d1e3          	bge	a5,a4,80008f82 <alloc3_desc+0x14>
    }
  }
  return 0;
    80009004:	4781                	li	a5,0
}
    80009006:	853e                	mv	a0,a5
    80009008:	70e2                	ld	ra,56(sp)
    8000900a:	7442                	ld	s0,48(sp)
    8000900c:	74a2                	ld	s1,40(sp)
    8000900e:	6121                	addi	sp,sp,64
    80009010:	8082                	ret

0000000080009012 <virtio_disk_rw>:

void
virtio_disk_rw(struct buf *b, int write)
{
    80009012:	7139                	addi	sp,sp,-64
    80009014:	fc06                	sd	ra,56(sp)
    80009016:	f822                	sd	s0,48(sp)
    80009018:	0080                	addi	s0,sp,64
    8000901a:	fca43423          	sd	a0,-56(s0)
    8000901e:	87ae                	mv	a5,a1
    80009020:	fcf42223          	sw	a5,-60(s0)
  uint64 sector = b->blockno * (BSIZE / 512);
    80009024:	fc843783          	ld	a5,-56(s0)
    80009028:	47dc                	lw	a5,12(a5)
    8000902a:	0017979b          	slliw	a5,a5,0x1
    8000902e:	2781                	sext.w	a5,a5
    80009030:	1782                	slli	a5,a5,0x20
    80009032:	9381                	srli	a5,a5,0x20
    80009034:	fef43423          	sd	a5,-24(s0)

  acquire(&disk.vdisk_lock);
    80009038:	0001e517          	auipc	a0,0x1e
    8000903c:	2c850513          	addi	a0,a0,712 # 80027300 <disk+0x128>
    80009040:	ffff8097          	auipc	ra,0xffff8
    80009044:	23e080e7          	jalr	574(ra) # 8000127e <acquire>
  // data, one for a 1-byte status result.

  // allocate the three descriptors.
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
    80009048:	fd040793          	addi	a5,s0,-48
    8000904c:	853e                	mv	a0,a5
    8000904e:	00000097          	auipc	ra,0x0
    80009052:	f20080e7          	jalr	-224(ra) # 80008f6e <alloc3_desc>
    80009056:	87aa                	mv	a5,a0
    80009058:	cf91                	beqz	a5,80009074 <virtio_disk_rw+0x62>
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000905a:	0001e597          	auipc	a1,0x1e
    8000905e:	2a658593          	addi	a1,a1,678 # 80027300 <disk+0x128>
    80009062:	0001e517          	auipc	a0,0x1e
    80009066:	18e50513          	addi	a0,a0,398 # 800271f0 <disk+0x18>
    8000906a:	ffffa097          	auipc	ra,0xffffa
    8000906e:	39e080e7          	jalr	926(ra) # 80003408 <sleep>
    if(alloc3_desc(idx) == 0) {
    80009072:	bfd9                	j	80009048 <virtio_disk_rw+0x36>
      break;
    80009074:	0001                	nop
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80009076:	fd042783          	lw	a5,-48(s0)
    8000907a:	07a9                	addi	a5,a5,10
    8000907c:	00479713          	slli	a4,a5,0x4
    80009080:	0001e797          	auipc	a5,0x1e
    80009084:	15878793          	addi	a5,a5,344 # 800271d8 <disk>
    80009088:	97ba                	add	a5,a5,a4
    8000908a:	07a1                	addi	a5,a5,8
    8000908c:	fef43023          	sd	a5,-32(s0)

  if(write)
    80009090:	fc442783          	lw	a5,-60(s0)
    80009094:	2781                	sext.w	a5,a5
    80009096:	c791                	beqz	a5,800090a2 <virtio_disk_rw+0x90>
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80009098:	fe043783          	ld	a5,-32(s0)
    8000909c:	4705                	li	a4,1
    8000909e:	c398                	sw	a4,0(a5)
    800090a0:	a029                	j	800090aa <virtio_disk_rw+0x98>
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800090a2:	fe043783          	ld	a5,-32(s0)
    800090a6:	0007a023          	sw	zero,0(a5)
  buf0->reserved = 0;
    800090aa:	fe043783          	ld	a5,-32(s0)
    800090ae:	0007a223          	sw	zero,4(a5)
  buf0->sector = sector;
    800090b2:	fe043783          	ld	a5,-32(s0)
    800090b6:	fe843703          	ld	a4,-24(s0)
    800090ba:	e798                	sd	a4,8(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800090bc:	0001e797          	auipc	a5,0x1e
    800090c0:	11c78793          	addi	a5,a5,284 # 800271d8 <disk>
    800090c4:	6398                	ld	a4,0(a5)
    800090c6:	fd042783          	lw	a5,-48(s0)
    800090ca:	0792                	slli	a5,a5,0x4
    800090cc:	97ba                	add	a5,a5,a4
    800090ce:	fe043703          	ld	a4,-32(s0)
    800090d2:	e398                	sd	a4,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800090d4:	0001e797          	auipc	a5,0x1e
    800090d8:	10478793          	addi	a5,a5,260 # 800271d8 <disk>
    800090dc:	6398                	ld	a4,0(a5)
    800090de:	fd042783          	lw	a5,-48(s0)
    800090e2:	0792                	slli	a5,a5,0x4
    800090e4:	97ba                	add	a5,a5,a4
    800090e6:	4741                	li	a4,16
    800090e8:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800090ea:	0001e797          	auipc	a5,0x1e
    800090ee:	0ee78793          	addi	a5,a5,238 # 800271d8 <disk>
    800090f2:	6398                	ld	a4,0(a5)
    800090f4:	fd042783          	lw	a5,-48(s0)
    800090f8:	0792                	slli	a5,a5,0x4
    800090fa:	97ba                	add	a5,a5,a4
    800090fc:	4705                	li	a4,1
    800090fe:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80009102:	fd442683          	lw	a3,-44(s0)
    80009106:	0001e797          	auipc	a5,0x1e
    8000910a:	0d278793          	addi	a5,a5,210 # 800271d8 <disk>
    8000910e:	6398                	ld	a4,0(a5)
    80009110:	fd042783          	lw	a5,-48(s0)
    80009114:	0792                	slli	a5,a5,0x4
    80009116:	97ba                	add	a5,a5,a4
    80009118:	03069713          	slli	a4,a3,0x30
    8000911c:	9341                	srli	a4,a4,0x30
    8000911e:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80009122:	fc843783          	ld	a5,-56(s0)
    80009126:	05878693          	addi	a3,a5,88
    8000912a:	0001e797          	auipc	a5,0x1e
    8000912e:	0ae78793          	addi	a5,a5,174 # 800271d8 <disk>
    80009132:	6398                	ld	a4,0(a5)
    80009134:	fd442783          	lw	a5,-44(s0)
    80009138:	0792                	slli	a5,a5,0x4
    8000913a:	97ba                	add	a5,a5,a4
    8000913c:	8736                	mv	a4,a3
    8000913e:	e398                	sd	a4,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    80009140:	0001e797          	auipc	a5,0x1e
    80009144:	09878793          	addi	a5,a5,152 # 800271d8 <disk>
    80009148:	6398                	ld	a4,0(a5)
    8000914a:	fd442783          	lw	a5,-44(s0)
    8000914e:	0792                	slli	a5,a5,0x4
    80009150:	97ba                	add	a5,a5,a4
    80009152:	40000713          	li	a4,1024
    80009156:	c798                	sw	a4,8(a5)
  if(write)
    80009158:	fc442783          	lw	a5,-60(s0)
    8000915c:	2781                	sext.w	a5,a5
    8000915e:	cf89                	beqz	a5,80009178 <virtio_disk_rw+0x166>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80009160:	0001e797          	auipc	a5,0x1e
    80009164:	07878793          	addi	a5,a5,120 # 800271d8 <disk>
    80009168:	6398                	ld	a4,0(a5)
    8000916a:	fd442783          	lw	a5,-44(s0)
    8000916e:	0792                	slli	a5,a5,0x4
    80009170:	97ba                	add	a5,a5,a4
    80009172:	00079623          	sh	zero,12(a5)
    80009176:	a829                	j	80009190 <virtio_disk_rw+0x17e>
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80009178:	0001e797          	auipc	a5,0x1e
    8000917c:	06078793          	addi	a5,a5,96 # 800271d8 <disk>
    80009180:	6398                	ld	a4,0(a5)
    80009182:	fd442783          	lw	a5,-44(s0)
    80009186:	0792                	slli	a5,a5,0x4
    80009188:	97ba                	add	a5,a5,a4
    8000918a:	4709                	li	a4,2
    8000918c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80009190:	0001e797          	auipc	a5,0x1e
    80009194:	04878793          	addi	a5,a5,72 # 800271d8 <disk>
    80009198:	6398                	ld	a4,0(a5)
    8000919a:	fd442783          	lw	a5,-44(s0)
    8000919e:	0792                	slli	a5,a5,0x4
    800091a0:	97ba                	add	a5,a5,a4
    800091a2:	00c7d703          	lhu	a4,12(a5)
    800091a6:	0001e797          	auipc	a5,0x1e
    800091aa:	03278793          	addi	a5,a5,50 # 800271d8 <disk>
    800091ae:	6394                	ld	a3,0(a5)
    800091b0:	fd442783          	lw	a5,-44(s0)
    800091b4:	0792                	slli	a5,a5,0x4
    800091b6:	97b6                	add	a5,a5,a3
    800091b8:	00176713          	ori	a4,a4,1
    800091bc:	1742                	slli	a4,a4,0x30
    800091be:	9341                	srli	a4,a4,0x30
    800091c0:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800091c4:	fd842683          	lw	a3,-40(s0)
    800091c8:	0001e797          	auipc	a5,0x1e
    800091cc:	01078793          	addi	a5,a5,16 # 800271d8 <disk>
    800091d0:	6398                	ld	a4,0(a5)
    800091d2:	fd442783          	lw	a5,-44(s0)
    800091d6:	0792                	slli	a5,a5,0x4
    800091d8:	97ba                	add	a5,a5,a4
    800091da:	03069713          	slli	a4,a3,0x30
    800091de:	9341                	srli	a4,a4,0x30
    800091e0:	00e79723          	sh	a4,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800091e4:	fd042783          	lw	a5,-48(s0)
    800091e8:	0001e717          	auipc	a4,0x1e
    800091ec:	ff070713          	addi	a4,a4,-16 # 800271d8 <disk>
    800091f0:	0789                	addi	a5,a5,2
    800091f2:	0792                	slli	a5,a5,0x4
    800091f4:	97ba                	add	a5,a5,a4
    800091f6:	577d                	li	a4,-1
    800091f8:	00e78823          	sb	a4,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800091fc:	fd042783          	lw	a5,-48(s0)
    80009200:	0789                	addi	a5,a5,2
    80009202:	00479713          	slli	a4,a5,0x4
    80009206:	0001e797          	auipc	a5,0x1e
    8000920a:	fd278793          	addi	a5,a5,-46 # 800271d8 <disk>
    8000920e:	97ba                	add	a5,a5,a4
    80009210:	01078693          	addi	a3,a5,16
    80009214:	0001e797          	auipc	a5,0x1e
    80009218:	fc478793          	addi	a5,a5,-60 # 800271d8 <disk>
    8000921c:	6398                	ld	a4,0(a5)
    8000921e:	fd842783          	lw	a5,-40(s0)
    80009222:	0792                	slli	a5,a5,0x4
    80009224:	97ba                	add	a5,a5,a4
    80009226:	8736                	mv	a4,a3
    80009228:	e398                	sd	a4,0(a5)
  disk.desc[idx[2]].len = 1;
    8000922a:	0001e797          	auipc	a5,0x1e
    8000922e:	fae78793          	addi	a5,a5,-82 # 800271d8 <disk>
    80009232:	6398                	ld	a4,0(a5)
    80009234:	fd842783          	lw	a5,-40(s0)
    80009238:	0792                	slli	a5,a5,0x4
    8000923a:	97ba                	add	a5,a5,a4
    8000923c:	4705                	li	a4,1
    8000923e:	c798                	sw	a4,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80009240:	0001e797          	auipc	a5,0x1e
    80009244:	f9878793          	addi	a5,a5,-104 # 800271d8 <disk>
    80009248:	6398                	ld	a4,0(a5)
    8000924a:	fd842783          	lw	a5,-40(s0)
    8000924e:	0792                	slli	a5,a5,0x4
    80009250:	97ba                	add	a5,a5,a4
    80009252:	4709                	li	a4,2
    80009254:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[2]].next = 0;
    80009258:	0001e797          	auipc	a5,0x1e
    8000925c:	f8078793          	addi	a5,a5,-128 # 800271d8 <disk>
    80009260:	6398                	ld	a4,0(a5)
    80009262:	fd842783          	lw	a5,-40(s0)
    80009266:	0792                	slli	a5,a5,0x4
    80009268:	97ba                	add	a5,a5,a4
    8000926a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000926e:	fc843783          	ld	a5,-56(s0)
    80009272:	4705                	li	a4,1
    80009274:	c3d8                	sw	a4,4(a5)
  disk.info[idx[0]].b = b;
    80009276:	fd042783          	lw	a5,-48(s0)
    8000927a:	0001e717          	auipc	a4,0x1e
    8000927e:	f5e70713          	addi	a4,a4,-162 # 800271d8 <disk>
    80009282:	0789                	addi	a5,a5,2
    80009284:	0792                	slli	a5,a5,0x4
    80009286:	97ba                	add	a5,a5,a4
    80009288:	fc843703          	ld	a4,-56(s0)
    8000928c:	e798                	sd	a4,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000928e:	fd042703          	lw	a4,-48(s0)
    80009292:	0001e797          	auipc	a5,0x1e
    80009296:	f4678793          	addi	a5,a5,-186 # 800271d8 <disk>
    8000929a:	6794                	ld	a3,8(a5)
    8000929c:	0001e797          	auipc	a5,0x1e
    800092a0:	f3c78793          	addi	a5,a5,-196 # 800271d8 <disk>
    800092a4:	679c                	ld	a5,8(a5)
    800092a6:	0027d783          	lhu	a5,2(a5)
    800092aa:	2781                	sext.w	a5,a5
    800092ac:	8b9d                	andi	a5,a5,7
    800092ae:	2781                	sext.w	a5,a5
    800092b0:	1742                	slli	a4,a4,0x30
    800092b2:	9341                	srli	a4,a4,0x30
    800092b4:	0786                	slli	a5,a5,0x1
    800092b6:	97b6                	add	a5,a5,a3
    800092b8:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    800092bc:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800092c0:	0001e797          	auipc	a5,0x1e
    800092c4:	f1878793          	addi	a5,a5,-232 # 800271d8 <disk>
    800092c8:	679c                	ld	a5,8(a5)
    800092ca:	0027d703          	lhu	a4,2(a5)
    800092ce:	0001e797          	auipc	a5,0x1e
    800092d2:	f0a78793          	addi	a5,a5,-246 # 800271d8 <disk>
    800092d6:	679c                	ld	a5,8(a5)
    800092d8:	2705                	addiw	a4,a4,1
    800092da:	1742                	slli	a4,a4,0x30
    800092dc:	9341                	srli	a4,a4,0x30
    800092de:	00e79123          	sh	a4,2(a5)

  __sync_synchronize();
    800092e2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800092e6:	100017b7          	lui	a5,0x10001
    800092ea:	05078793          	addi	a5,a5,80 # 10001050 <_entry-0x6fffefb0>
    800092ee:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800092f2:	a819                	j	80009308 <virtio_disk_rw+0x2f6>
    sleep(b, &disk.vdisk_lock);
    800092f4:	0001e597          	auipc	a1,0x1e
    800092f8:	00c58593          	addi	a1,a1,12 # 80027300 <disk+0x128>
    800092fc:	fc843503          	ld	a0,-56(s0)
    80009300:	ffffa097          	auipc	ra,0xffffa
    80009304:	108080e7          	jalr	264(ra) # 80003408 <sleep>
  while(b->disk == 1) {
    80009308:	fc843783          	ld	a5,-56(s0)
    8000930c:	43dc                	lw	a5,4(a5)
    8000930e:	873e                	mv	a4,a5
    80009310:	4785                	li	a5,1
    80009312:	fef701e3          	beq	a4,a5,800092f4 <virtio_disk_rw+0x2e2>
  }

  disk.info[idx[0]].b = 0;
    80009316:	fd042783          	lw	a5,-48(s0)
    8000931a:	0001e717          	auipc	a4,0x1e
    8000931e:	ebe70713          	addi	a4,a4,-322 # 800271d8 <disk>
    80009322:	0789                	addi	a5,a5,2
    80009324:	0792                	slli	a5,a5,0x4
    80009326:	97ba                	add	a5,a5,a4
    80009328:	0007b423          	sd	zero,8(a5)
  free_chain(idx[0]);
    8000932c:	fd042783          	lw	a5,-48(s0)
    80009330:	853e                	mv	a0,a5
    80009332:	00000097          	auipc	ra,0x0
    80009336:	bcc080e7          	jalr	-1076(ra) # 80008efe <free_chain>

  release(&disk.vdisk_lock);
    8000933a:	0001e517          	auipc	a0,0x1e
    8000933e:	fc650513          	addi	a0,a0,-58 # 80027300 <disk+0x128>
    80009342:	ffff8097          	auipc	ra,0xffff8
    80009346:	fa0080e7          	jalr	-96(ra) # 800012e2 <release>
}
    8000934a:	0001                	nop
    8000934c:	70e2                	ld	ra,56(sp)
    8000934e:	7442                	ld	s0,48(sp)
    80009350:	6121                	addi	sp,sp,64
    80009352:	8082                	ret

0000000080009354 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80009354:	1101                	addi	sp,sp,-32
    80009356:	ec06                	sd	ra,24(sp)
    80009358:	e822                	sd	s0,16(sp)
    8000935a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000935c:	0001e517          	auipc	a0,0x1e
    80009360:	fa450513          	addi	a0,a0,-92 # 80027300 <disk+0x128>
    80009364:	ffff8097          	auipc	ra,0xffff8
    80009368:	f1a080e7          	jalr	-230(ra) # 8000127e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000936c:	100017b7          	lui	a5,0x10001
    80009370:	06078793          	addi	a5,a5,96 # 10001060 <_entry-0x6fffefa0>
    80009374:	439c                	lw	a5,0(a5)
    80009376:	0007871b          	sext.w	a4,a5
    8000937a:	100017b7          	lui	a5,0x10001
    8000937e:	06478793          	addi	a5,a5,100 # 10001064 <_entry-0x6fffef9c>
    80009382:	8b0d                	andi	a4,a4,3
    80009384:	2701                	sext.w	a4,a4
    80009386:	c398                	sw	a4,0(a5)

  __sync_synchronize();
    80009388:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000938c:	a045                	j	8000942c <virtio_disk_intr+0xd8>
    __sync_synchronize();
    8000938e:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80009392:	0001e797          	auipc	a5,0x1e
    80009396:	e4678793          	addi	a5,a5,-442 # 800271d8 <disk>
    8000939a:	6b98                	ld	a4,16(a5)
    8000939c:	0001e797          	auipc	a5,0x1e
    800093a0:	e3c78793          	addi	a5,a5,-452 # 800271d8 <disk>
    800093a4:	0207d783          	lhu	a5,32(a5)
    800093a8:	2781                	sext.w	a5,a5
    800093aa:	8b9d                	andi	a5,a5,7
    800093ac:	2781                	sext.w	a5,a5
    800093ae:	078e                	slli	a5,a5,0x3
    800093b0:	97ba                	add	a5,a5,a4
    800093b2:	43dc                	lw	a5,4(a5)
    800093b4:	fef42623          	sw	a5,-20(s0)

    if(disk.info[id].status != 0)
    800093b8:	0001e717          	auipc	a4,0x1e
    800093bc:	e2070713          	addi	a4,a4,-480 # 800271d8 <disk>
    800093c0:	fec42783          	lw	a5,-20(s0)
    800093c4:	0789                	addi	a5,a5,2
    800093c6:	0792                	slli	a5,a5,0x4
    800093c8:	97ba                	add	a5,a5,a4
    800093ca:	0107c783          	lbu	a5,16(a5)
    800093ce:	cb89                	beqz	a5,800093e0 <virtio_disk_intr+0x8c>
      panic("virtio_disk_intr status");
    800093d0:	00002517          	auipc	a0,0x2
    800093d4:	38050513          	addi	a0,a0,896 # 8000b750 <etext+0x750>
    800093d8:	ffff8097          	auipc	ra,0xffff8
    800093dc:	8b2080e7          	jalr	-1870(ra) # 80000c8a <panic>

    struct buf *b = disk.info[id].b;
    800093e0:	0001e717          	auipc	a4,0x1e
    800093e4:	df870713          	addi	a4,a4,-520 # 800271d8 <disk>
    800093e8:	fec42783          	lw	a5,-20(s0)
    800093ec:	0789                	addi	a5,a5,2
    800093ee:	0792                	slli	a5,a5,0x4
    800093f0:	97ba                	add	a5,a5,a4
    800093f2:	679c                	ld	a5,8(a5)
    800093f4:	fef43023          	sd	a5,-32(s0)
    b->disk = 0;   // disk is done with buf
    800093f8:	fe043783          	ld	a5,-32(s0)
    800093fc:	0007a223          	sw	zero,4(a5)
    wakeup(b);
    80009400:	fe043503          	ld	a0,-32(s0)
    80009404:	ffffa097          	auipc	ra,0xffffa
    80009408:	080080e7          	jalr	128(ra) # 80003484 <wakeup>

    disk.used_idx += 1;
    8000940c:	0001e797          	auipc	a5,0x1e
    80009410:	dcc78793          	addi	a5,a5,-564 # 800271d8 <disk>
    80009414:	0207d783          	lhu	a5,32(a5)
    80009418:	2785                	addiw	a5,a5,1
    8000941a:	03079713          	slli	a4,a5,0x30
    8000941e:	9341                	srli	a4,a4,0x30
    80009420:	0001e797          	auipc	a5,0x1e
    80009424:	db878793          	addi	a5,a5,-584 # 800271d8 <disk>
    80009428:	02e79023          	sh	a4,32(a5)
  while(disk.used_idx != disk.used->idx){
    8000942c:	0001e797          	auipc	a5,0x1e
    80009430:	dac78793          	addi	a5,a5,-596 # 800271d8 <disk>
    80009434:	0207d703          	lhu	a4,32(a5)
    80009438:	0001e797          	auipc	a5,0x1e
    8000943c:	da078793          	addi	a5,a5,-608 # 800271d8 <disk>
    80009440:	6b9c                	ld	a5,16(a5)
    80009442:	0027d783          	lhu	a5,2(a5)
    80009446:	2701                	sext.w	a4,a4
    80009448:	2781                	sext.w	a5,a5
    8000944a:	f4f712e3          	bne	a4,a5,8000938e <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    8000944e:	0001e517          	auipc	a0,0x1e
    80009452:	eb250513          	addi	a0,a0,-334 # 80027300 <disk+0x128>
    80009456:	ffff8097          	auipc	ra,0xffff8
    8000945a:	e8c080e7          	jalr	-372(ra) # 800012e2 <release>
}
    8000945e:	0001                	nop
    80009460:	60e2                	ld	ra,24(sp)
    80009462:	6442                	ld	s0,16(sp)
    80009464:	6105                	addi	sp,sp,32
    80009466:	8082                	ret
	...

000000008000a000 <_trampoline>:
    8000a000:	14051073          	csrw	sscratch,a0
    8000a004:	02000537          	lui	a0,0x2000
    8000a008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a00a:	0536                	slli	a0,a0,0xd
    8000a00c:	02153423          	sd	ra,40(a0)
    8000a010:	02253823          	sd	sp,48(a0)
    8000a014:	02353c23          	sd	gp,56(a0)
    8000a018:	04453023          	sd	tp,64(a0)
    8000a01c:	04553423          	sd	t0,72(a0)
    8000a020:	04653823          	sd	t1,80(a0)
    8000a024:	04753c23          	sd	t2,88(a0)
    8000a028:	f120                	sd	s0,96(a0)
    8000a02a:	f524                	sd	s1,104(a0)
    8000a02c:	fd2c                	sd	a1,120(a0)
    8000a02e:	e150                	sd	a2,128(a0)
    8000a030:	e554                	sd	a3,136(a0)
    8000a032:	e958                	sd	a4,144(a0)
    8000a034:	ed5c                	sd	a5,152(a0)
    8000a036:	0b053023          	sd	a6,160(a0)
    8000a03a:	0b153423          	sd	a7,168(a0)
    8000a03e:	0b253823          	sd	s2,176(a0)
    8000a042:	0b353c23          	sd	s3,184(a0)
    8000a046:	0d453023          	sd	s4,192(a0)
    8000a04a:	0d553423          	sd	s5,200(a0)
    8000a04e:	0d653823          	sd	s6,208(a0)
    8000a052:	0d753c23          	sd	s7,216(a0)
    8000a056:	0f853023          	sd	s8,224(a0)
    8000a05a:	0f953423          	sd	s9,232(a0)
    8000a05e:	0fa53823          	sd	s10,240(a0)
    8000a062:	0fb53c23          	sd	s11,248(a0)
    8000a066:	11c53023          	sd	t3,256(a0)
    8000a06a:	11d53423          	sd	t4,264(a0)
    8000a06e:	11e53823          	sd	t5,272(a0)
    8000a072:	11f53c23          	sd	t6,280(a0)
    8000a076:	140022f3          	csrr	t0,sscratch
    8000a07a:	06553823          	sd	t0,112(a0)
    8000a07e:	00853103          	ld	sp,8(a0)
    8000a082:	02053203          	ld	tp,32(a0)
    8000a086:	01053283          	ld	t0,16(a0)
    8000a08a:	00053303          	ld	t1,0(a0)
    8000a08e:	12000073          	sfence.vma
    8000a092:	18031073          	csrw	satp,t1
    8000a096:	12000073          	sfence.vma
    8000a09a:	8282                	jr	t0

000000008000a09c <userret>:
    8000a09c:	12000073          	sfence.vma
    8000a0a0:	18051073          	csrw	satp,a0
    8000a0a4:	12000073          	sfence.vma
    8000a0a8:	02000537          	lui	a0,0x2000
    8000a0ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000a0ae:	0536                	slli	a0,a0,0xd
    8000a0b0:	02853083          	ld	ra,40(a0)
    8000a0b4:	03053103          	ld	sp,48(a0)
    8000a0b8:	03853183          	ld	gp,56(a0)
    8000a0bc:	04053203          	ld	tp,64(a0)
    8000a0c0:	04853283          	ld	t0,72(a0)
    8000a0c4:	05053303          	ld	t1,80(a0)
    8000a0c8:	05853383          	ld	t2,88(a0)
    8000a0cc:	7120                	ld	s0,96(a0)
    8000a0ce:	7524                	ld	s1,104(a0)
    8000a0d0:	7d2c                	ld	a1,120(a0)
    8000a0d2:	6150                	ld	a2,128(a0)
    8000a0d4:	6554                	ld	a3,136(a0)
    8000a0d6:	6958                	ld	a4,144(a0)
    8000a0d8:	6d5c                	ld	a5,152(a0)
    8000a0da:	0a053803          	ld	a6,160(a0)
    8000a0de:	0a853883          	ld	a7,168(a0)
    8000a0e2:	0b053903          	ld	s2,176(a0)
    8000a0e6:	0b853983          	ld	s3,184(a0)
    8000a0ea:	0c053a03          	ld	s4,192(a0)
    8000a0ee:	0c853a83          	ld	s5,200(a0)
    8000a0f2:	0d053b03          	ld	s6,208(a0)
    8000a0f6:	0d853b83          	ld	s7,216(a0)
    8000a0fa:	0e053c03          	ld	s8,224(a0)
    8000a0fe:	0e853c83          	ld	s9,232(a0)
    8000a102:	0f053d03          	ld	s10,240(a0)
    8000a106:	0f853d83          	ld	s11,248(a0)
    8000a10a:	10053e03          	ld	t3,256(a0)
    8000a10e:	10853e83          	ld	t4,264(a0)
    8000a112:	11053f03          	ld	t5,272(a0)
    8000a116:	11853f83          	ld	t6,280(a0)
    8000a11a:	7928                	ld	a0,112(a0)
    8000a11c:	10200073          	sret
	...
